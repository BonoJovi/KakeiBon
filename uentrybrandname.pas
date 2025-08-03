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
    procedure DBEdtBrandNameExit(Sender: TObject);
    procedure DBEdtBrandNameIDChange(Sender: TObject);
    procedure DBLCBMakerSelect(Sender: TObject);
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
    procedure CloseTransactions;
    procedure SetDatabaseNames;
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
  UConsts, UTopMenu, UManageDetails, UAddDetail, UEditDetail, UEntryMaker;

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

procedure TFrmEntryBrandName.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    ACn.DatabaseName       := GetHomeDir + DB_NAME;
    ACnNextID.DatabaseName := GetHomeDir + DB_NAME;
    ACnMaker.DatabaseName  := GetHomeDir + DB_NAME;
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
        GetBrandNameID.SetBrandNameID(DBEdtBrandNameID.Text);
    end else begin
      GetBrandNameID.SetBrandNameID('');
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
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
    SetDatabaseNames;
    OpenSelectQueryWithMakerID(
      ACn, ADS, ATr, AQu, SQL_20140001,  AQuMaker.FieldByName('MAKER_ID').AsInteger);
  end;
end;

procedure TFrmEntryBrandName.ProcCommit;
var
  LNextShopID  : Integer;
  LMakerID     : Integer;
  LNewMakerID  : Integer;
begin
  FDoCommit := True;
  try
    try
      with AQu do begin
        SQL.Text := SQL_20140004;
        Params.ParamByName('pUserID').AsInteger       := FrmTopMenu.Defs.GetUID;

        with FrmTopMenu.Defs do begin
          if FCurrMakerID > 0 then begin
            Params.ParamByName('pMakerID').AsInteger  := FCurrMakerID;
          end else begin
            Params.ParamByName('pMakerID').AsInteger  := StrToInt(VarToStr(GetMakerID));
          end;
          LMakerID := Params.ParamByName('pMakerID').AsInteger;
          Params.ParamByName('pNewMakerID').AsInteger := StrToInt(VarToStr(GetMakerID));
          LNewMakerID := Params.ParamByName('pNewMakerID').AsInteger;

          OpenSelectQueryWithMakerID(
            ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20140002, LMakerID);
          LNextShopID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
          CloseConn(ACnNextID, ATrNextID);
          SetDatabaseNames;
          if FCurrBrandNameID > 0 then begin
            Params.ParamByName('pBrandNameID').AsInteger    := FCurrBrandNameID;
          end else begin
            if VarToStr(GetBrandNameID) <> '' then begin
              Params.ParamByName('pBrandNameID').AsInteger  := StrToInt(VarToStr(GetBrandNameID));
            end else begin
              Params.ParamByName('pBrandNameID').AsInteger  := LNextShopID;
            end;
          end;
          if FCurrMakerID = StrToInt(VarToStr(GetMakerID)) then begin
            Params.ParamByName('pNewBrandNameID').AsInteger := StrToInt(VarToStr(GetBrandNameID));
          end else begin
            Params.ParamByName('pNewBrandNameID').AsInteger := LNextShopID;
          end;

          Params.ParamByName('pBrandName').AsAnsiString := GetBrandName;

          Params.ParamByName('pEndOfSales').AsBoolean := GetEndOfSales;

          Params.ParamByName('pDisabled').AsBoolean   := GetDisabled;

          Params.ParamByName('pEntryDT').AsDateTime   := Now;
          Params.ParamByName('pUpdateDT').AsDateTime  := Now;
        end;

        CloseTransactions;
        SetDatabaseNames;
        ExecSQL;
        ATr.Commit;

        with FrmTopMenu.Defs do begin
          OpenSelectQuery(
            ACnMaker, ADSMaker, ATrMaker, AQuMaker, SQL_20130002);
          OpenSelectQueryWithMakerID(
            ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(GetMakerID)));
          DBLCBMaker.KeyValue := AQu.FieldByName('MAKER_ID').AsVariant;
          if DBEdtBrandNameID.Text <> '' then begin
            OpenSelectQueryWithMakerIDAndBrandNameID(
              ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(DBLCBMaker.KeyValue)), StrToInt(DBEdtBrandNameID.Text));
          end else begin
            if (LMakerID > 0) then begin
              OpenSelectQueryWithMakerIDAndBrandNameID(
                ACn, ADS, ATr, AQu, SQL_20140001, LMakerID, 1);
            end else if (LNewMakerID > 0) then begin
              OpenSelectQueryWithMakerIDAndBrandNameID(
                ACn, ADS, ATr, AQu, SQL_20140001, LNewMakerID, 1);
            end else begin
              MessageDlg(MSG_JP_000034, mtInformation, [mbOk], 0);
            end;
          end;
        end;

        ADBGrid.AutoAdjustColumns;
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
        if DBEdtMakerID.Text <> '' then begin
          OpenSelectQueryWithMakerID(
            ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(DBEdtMakerID.Text));
        end;
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

procedure TFrmEntryBrandName.DBLCBMakerSelect(Sender: TObject);
begin
  if Not FDoCommit then begin
    with FrmTopMenu.Defs do begin
      //ProcCancel;
      with AQu do begin
        FMakerID := DBLCBMaker.KeyValue;
        with DBEdtBrandNameID do begin
          if Text <> '' then begin
            OpenSelectQueryWithMakerIDAndBrandNameID(
              ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(DBLCBMaker.KeyValue)), StrToInt(Text));
          end else begin
            OpenSelectQueryWithMakerIDAndBrandNameID(
              ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(DBLCBMaker.KeyValue)), 1);
          end;
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
      if (AQu.FieldByName('BRAND_NAME_ID').AsAnsiString <> '')
        And (AQu.FieldByName('BRAND_NAME_ID').AsInteger > 0) then begin
        SetBrandNameID(AQu.FieldByName('BRAND_NAME_ID').AsVariant);
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
begin
  SetDatabaseNames;

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
      OpenSelectQueryWithMakerID(ACn, ADS, ATr, AQu, SQL_20140001, 1);
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
        OpenSelectQuery(ACnMaker, ADSMaker, ATrMaker, AQuMaker, SQL_20130002);
        First;
        //if Not VarIsNull(GetMakerID) then begin
        if (FieldByName('MAKER_ID').AsAnsiString <> '')
          And (FieldByName('MAKER_ID').AsInteger > 0) then begin
          SetMakerID(FieldByName('MAKER_ID').AsVariant);
          with AQu do begin
            OpenSelectQueryWithMakerID(
              ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(GetMakerID)));
          end;
          if AQu.RecordCount = 0 then begin
            ProcInsert;
          end;
          DBLCBMaker.KeyValue := FieldByName('MAKER_ID').AsVariant;
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
      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20140001);
      ADBGrid.DataSource := ADS;

      FReOpenDS       := False;
      Timer.Enabled   := False;
    end;
  end;
end;

end.

