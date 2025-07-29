unit UEntryBrandName;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, ActnList,
  UDBAccess;

type

  { TFrmEntryBrandName }

  TFrmEntryBrandName = class(TForm)
    ActCancel        : TAction;
    ActCommit        : TAction;
    ActInsert        : TAction;
    ActEntryMaker    : TAction;
    ActionList       : TActionList;
    ActQuit          : TAction;
    ActQuit1: TAction;
    ADBGrid          : TDBGrid;
    ADBNav           : TDBNavigator;
    ADS              : TDataSource;
    ADSNextID        : TDataSource;
    ADSMaker         : TDataSource;
    AQu              : TSQLQuery;
    AQuNextID        : TSQLQuery;
    AQuMaker         : TSQLQuery;
    ATr              : TSQLTransaction;
    ATrNextID        : TSQLTransaction;
    ATrMaker         : TSQLTransaction;
    BtnCancel        : TButton;
    BtnCommit        : TButton;
    BtnEntryMaker    : TButton;
    BtnGoBack        : TButton;
    BtnInsert        : TButton;
    DBCBDisabled     : TDBCheckBox;
    DBCBEndOfSales   : TDBCheckBox;
    DBEdtBrandNameID : TDBEdit;
    DBEdtBrandName   : TDBEdit;
    DBEdtMakerID     : TDBEdit;
    DBEdtUserID      : TDBEdit;
    DBLCBMaker       : TDBLookupComboBox;
    LblDisabled1     : TLabel;
    LblDisabled2     : TLabel;
    LblDisabled3     : TLabel;
    LblEndOfSales1   : TLabel;
    LblEndOfSales2   : TLabel;
    LblID1           : TLabel;
    LblID2           : TLabel;
    LblBrandName1    : TLabel;
    LblBrandName2    : TLabel;
    LblMaker         : TLabel;
    PnlCancel        : TPanel;
    PnlCommit        : TPanel;
    PnlGoBack        : TPanel;
    PnlInsert        : TPanel;
    PnlEntryMaker    : TPanel;
    ACn: TSQLite3Connection;
    ACnNextID: TSQLite3Connection;
    ACnMaker: TSQLite3Connection;
    Timer            : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
    procedure ActEntryMakerExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure DBEdtBrandNameExit(Sender: TObject);
    procedure DBEdtBrandNameIDChange(Sender: TObject);
    procedure DBLCBMakerChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FReOpenDS        : Boolean;
    FInsert          : Boolean;
    FDoCommit        : Boolean;
    FCurrMakerID     : Integer;
    FCurrBrandNameID : Integer;
    FMakerID         : Variant;
    FBrandNameID     : Variant;
    procedure CloseTransactions;
    procedure BackupValues;
    procedure ProcInsert;
    procedure ProcCancel;
    procedure ProcCommit;
    procedure ProcEntryMaker;
  public

  end;

var
  FrmEntryBrandName: TFrmEntryBrandName;

implementation
uses
  UTopMenu, UManageDetails, UAddDetail, UEditDetail, UEntryMaker;

{$R *.lfm}

{ TFrmEntryBrandName }

procedure TFrmEntryBrandName.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);
    CloseConn(ACnMaker , ATrMaker );
  end;
end;

procedure TFrmEntryBrandName.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    if Not VarIsNull(DBLCBMaker.KeyValue) then begin;
      SetMakerID(DBLCBMaker.KeyValue);
    end;
    if (DBEdtBrandNameID.Text <> '')
      And (StrToInt(DBEdtBrandNameID.Text) > 0) then begin;
        SetBrandNameID(DBEdtBrandNameID.Text);
    end else begin
      SetBrandNameID('');
    end;
    if DBEdtBrandName.Text <> '' then begin;
      SetBrandName(DBEdtBrandName.Text);
    end;

    if DBCBEndOfSales.State = cbChecked then begin
      SetEndOfSales(True);
    end else begin
      SetEndOfSales(False);
    end;

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

procedure TFrmEntryBrandName.ProcCancel;
begin
  if FInsert then begin
    FInsert := False;
  end;

  ATr.Rollback;
  FrmTopMenu.Defs.CloseConn(ACn, ATr);
  FrmTopMenu.Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20140003);
  if DBEdtMakerID.Text <> '' then begin
    DBLCBMaker.KeyValue := DBEdtMakerID.Field.AsInteger;
  end;
end;

procedure TFrmEntryBrandName.ProcCommit;
var
  LNextShopID : Integer;
begin
  FDoCommit := True;
  try
    try
      with AQu do begin
        SQL.Text := SQL_20140004;
        Params.ParamByName('pUserID').AsInteger    := FrmTopMenu.Defs.GetUID;

        with FrmTopMenu.Defs do begin
          if FCurrMakerID > 0 then begin
            Params.ParamByName('pMakerID').AsInteger   := FCurrMakerID;
          end else begin
            Params.ParamByName('pMakerID').AsInteger   := GetMakerID;
          end;
          Params.ParamByName('pNewMakerID').AsInteger   := GetMakerID;

          OpenSelectQueryWithMakerID(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20140002, GetMakerID);
          LNextShopID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
          CloseConn(ACnNextID, ATrNextID);
          if FCurrBrandNameID > 0 then begin
            Params.ParamByName('pBrandNameID').AsInteger  := FCurrBrandNameID;
          end else begin
            if GetBrandNameID <> '' then begin
              Params.ParamByName('pBrandNameID').AsInteger  := GetBrandNameID;
            end else begin
              Params.ParamByName('pBrandNameID').AsInteger  := LNextShopID;
            end;
          end;
          if FCurrMakerID = GetMakerID then begin
            Params.ParamByName('pNewBrandNameID').AsInteger  := GetBrandNameID;
          end else begin
            Params.ParamByName('pNewBrandNameID').AsInteger  := LNextShopID;
          end;

          Params.ParamByName('pBrandName').AsAnsiString := GetBrandName;

          Params.ParamByName('pEndOfSales').AsBoolean := GetEndOfSales;

          Params.ParamByName('pDisabled').AsBoolean   := GetDisabled;

          Params.ParamByName('pEntryDT').AsDateTime   := Now;
          Params.ParamByName('pUpdateDT').AsDateTime  := Now;
        end;

        CloseTransactions;
        ExecSQL;
        ATr.Commit;

        with FrmTopMenu.Defs do begin
          CloseConn(ACn, ATr);
          OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20140003);
        end;

        FInsert := False;
      end;
    except
      on E: ESQLDatabaseError do
      begin
        ShowMessage(E.Message);
      end;
    end;
    DBLCBMaker.SetFocus;
  finally
  end;

  FReOpenDS     := True;
  Timer.Enabled := True;
  FDoCommit     := False;
end;

procedure TFrmEntryBrandName.ProcEntryMaker;
begin
  with FrmTopMenu.Defs do begin
    FrmEntryMaker := TFrmEntryMaker.Create(Application);
    OpenForm(Self, FrmEntryMaker);
  end;
end;

procedure TFrmEntryBrandName.ProcInsert;
begin
  with FrmTopMenu.Defs do begin
    if Not FInsert then begin
      with AQu do begin
        CloseConn(ACn, ATr);
        OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20140007);
        Edit;
        if RecordCount > 0 then begin
          Insert;
        end;
        FInsert := True;
      end;

      with FrmTopMenu.Defs do begin
        DBEdtUserID.Field.AsInteger    := GetUID;
        FCurrMakerID                   := 0;
        FCurrBrandNameID               := 0;
        DBLCBMaker.SetFocus;
        DBCBEndOfSales.Field.AsBoolean := False;
        DBCBDisabled.Field.AsBoolean   := False;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmEntryBrandName.ActCommitExecute(Sender: TObject);
begin
  BackupValues;
  ProcCommit;
end;

procedure TFrmEntryBrandName.ActEntryMakerExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryMaker;
end;

procedure TFrmEntryBrandName.ActInsertExecute(Sender: TObject);
begin
  ProcInsert;
end;

procedure TFrmEntryBrandName.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryBrandName.ADBGridSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  if Not FDoCommit then begin
    with FrmTopMenu.Defs do begin
      if DBEdtMakerID.Text <> '' then begin
        DBLCBMaker.KeyValue := StrToInt(DBEdtMakerID.Text);
        if StrToInt(DBEdtMakerID.Text) > 0 then begin
          FCurrMakerID      := StrToInt(DBEdtMakerID.Text);
        end else begin
          FCurrMakerID      := 0;
        end;
      end;
      if (DBEdtBrandNameID.Text <> '') And (StrToInt(DBEdtBrandNameID.Text) > 0) then begin
        FCurrBrandNameID    := StrToInt(DBEdtBrandNameID.Text);
      end else begin
        FCurrBrandNameID    := 0;
      end;
    end;
    ADBGrid.AutoAdjustColumns;
    //AQu.Edit;
  end;
end;

procedure TFrmEntryBrandName.DBLCBMakerChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with FrmTopMenu.Defs do begin
      if (Not VarIsNull(DBLCBMaker.KeyValue)) then begin
        if (DBLCBMaker.KeyValue <> DBEdtMakerID.Field.AsInteger) then begin
          AQu.Edit;
          DBEdtUserID.Field.AsInteger      := GetUID;
          if DBLCBMaker.KeyValue > 0 then begin
            SetMakerID(DBLCBMaker.KeyValue);
          end;
          DBEdtMakerID.Text     := VarToStr(GetMakerID);

          SetBrandNameID(AQu.FieldByName('BRAND_NAME_ID').AsString);
        end;
      end;

      if Not VarIsNull(GetBrandNameID) then begin
        DBEdtBrandNameID.Text := VarToStr(GetBrandNameID);
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with FrmTopMenu.Defs do begin
      if (DBEdtBrandNameID.Text <> '') And (StrToInt(DBEdtBrandNameID.Text) > 0) then begin
        SetBrandNameID(StrToInt(DBEdtBrandNameID.Text));
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameExit(Sender: TObject);
begin
  if Not FDoCommit then begin
    with FrmTopMenu.Defs do begin
      SetBrandName(DBEdtBrandName.Text);
    end;
  end;
end;

procedure TFrmEntryBrandName.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseTransactions;

  with FrmTopMenu.Defs do begin
    // Restore values of previous screen
    SetMakerID(FMakerID);
    SetBrandNameID(FBrandNameID);

    if GetEntryBrandName = 0 then begin
      FrmManageDetails         := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible := True;
    end else if GetEntryBrandName = 1 then begin
      FrmAddDetail             := TFrmAddDetail.Create(Application);
      FrmAddDetail.Visible     := True;
    end else if GetEntryBrandName = 2 then begin
      FrmEditDetail            := TFrmEditDetail.Create(Application);
      FrmEditDetail.Visible    := True;
    end;
  end;

  CloseAction                  := caFree;
  FrmEntryBrandName            := nil;
end;

procedure TFrmEntryBrandName.FormCreate(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    FMakerID     := GetMakerID;
    FBrandNameID := GetBrandNameID;
  end;
end;

procedure TFrmEntryBrandName.FormShow(Sender: TObject);
var
  i : Integer;
begin
  FReOpenDS       := False;
  Timer.Enabled   := False;
  FDoCommit       := False;
  FInsert         := False;

  FrmEntryBrandName.Color := RGB(112, 168, 175);
  PnlEntryMaker.Color     := RGB( 72, 122, 129);
  PnlInsert.Color         := RGB( 72, 122, 129);
  PnlCancel.Color         := RGB( 72, 122, 129);
  PnlCommit.Color         := RGB( 72, 122, 129);
  PnlGoBack.Color         := RGB( 72, 122, 129);

  with FrmTopMenu.Defs do begin
    with AQu do begin
      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20140003);
      //ADBGrid.DataSource := ADS;
      if RecordCount = 0 then begin
        ProcInsert;
      end else begin
        FInsert := False;
      end;
    end;
  end;

  // Restore Maker ComboBox
  with AQuMaker do begin
    with FrmTopMenu.Defs do begin
      if Not Active then begin
        SQL.Text := SQL_20130002;
        DBEdtUserID.Text := VarToStr(GetUID);
        Params.ParamByName('pUserID').AsInteger := GetUID;
        Open;
        //if Not VarIsNull(GetMakerID) then begin
        if (DBEdtMakerID.Text <> '') And (StrToInt(DBEdtMakerID.Text) > 0) then begin
          SetMakerID(StrToInt(DBEdtMakerID.Text));
          First;
          while Not EOF do begin
            if FieldByName('MAKER_ID').AsAnsiString = VarToStr(GetMakerID) then begin
              break;
            end;
            Next;
          end;

          DBLCBMaker.KeyValue := FieldByName('MAKER_ID').AsInteger;
        end else begin
          DBLCBMaker.ItemIndex := -1;
        end;
      end;
    end;
  end;
  ADBGrid.AutoAdjustColumns;
  DBLCBMaker.SetFocus;

  { Debug }
  //FrmEntryBrandName.Width := 921;
end;

procedure TFrmEntryBrandName.TimerTimer(Sender: TObject);
begin
  if FReOpenDS then
  begin
    with FrmTopMenu.Defs do begin
      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20140003);
      ADBGrid.DataSource := ADS;

      FReOpenDS       := False;
      Timer.Enabled   := False;
    end;
  end;
end;

end.

