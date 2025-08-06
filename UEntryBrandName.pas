unit UEntryBrandName;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, ActnList;

type

  { TFrmEntryBrandName }

  TFrmEntryBrandName = class(TForm)
    ACn: TSQLite3Connection;
    ACnNextID: TSQLite3Connection;
    ACnMaker: TSQLite3Connection;
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
    FMakerID         : Variant;
    FBrandNameID     : Variant;
    procedure SetDatabaseNames;
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
  UConsts, UDBAccess, UTopMenu, UManageDetails, UAddDetail, UEditDetail,
  UEntryMaker;

{$R *.lfm}

{ TFrmEntryBrandName }

procedure TFrmEntryBrandName.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn      );
    SetDatabaseName(ACnNextID);
    SetDatabaseName(ACnMaker );
  end;
end;

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
  with FrmTopMenu.Defs do begin
    //CloseConn(ACn, ATr);
    CloseTransactions;
    SetDatabaseNames;
    OpenSelQuAndSetVal(ACnMaker, ADSMaker, ATrMaker, AQuMaker,
    DBLCBMaker, DBEdtMakerID, SQL_20130002, StrToInt(VarToStr(GetMakerID)));
  end;
end;

procedure TFrmEntryBrandName.ProcCommit;
var
  LNextShopID  : Integer;
  LMakerID     : Integer;
  LNewMakerID  : Integer;
  LBrandNameID : Integer;
begin
  FDoCommit := True;
  try
    try
      with FrmTopMenu.Defs do begin
        with AQu do begin
          SQL.Text := SQL_20140004;
          Params.ParamByName('pUserID').AsInteger       := FrmTopMenu.Defs.GetUID;

          with Params do begin
            if FCurrMakerID > 0 then begin
              ParamByName('pMakerID').AsInteger  := FCurrMakerID;
            end else begin
              ParamByName('pMakerID').AsInteger  := StrToInt(VarToStr(GetMakerID));
            end;
            LMakerID := ParamByName('pMakerID').AsInteger;
            ParamByName('pNewMakerID').AsInteger := StrToInt(VarToStr(GetMakerID));
            LNewMakerID := ParamByName('pNewMakerID').AsInteger;

            OpenSelectQueryWithMakerID(
              ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20140002, LMakerID);
            LNextShopID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
            CloseConn(ACnNextID, ATrNextID);
            SetDatabaseNames;
            if FCurrBrandNameID > 0 then begin
              ParamByName('pBrandNameID').AsInteger    := FCurrBrandNameID;
            end else begin
              if VarToStr(GetBrandNameID) <> '' then begin
                ParamByName('pBrandNameID').AsInteger  := StrToInt(VarToStr(GetBrandNameID));
              end else begin
                ParamByName('pBrandNameID').AsInteger  := LNextShopID;
              end;
            end;
            if FCurrMakerID = StrToInt(VarToStr(GetMakerID)) then begin
              ParamByName('pNewBrandNameID').AsInteger := StrToInt(VarToStr(GetBrandNameID));
            end else begin
              ParamByName('pNewBrandNameID').AsInteger := LNextShopID;
            end;

            ParamByName('pBrandName').AsAnsiString     := GetBrandName;

            ParamByName('pEndOfSales').AsBoolean       := GetEndOfSales;

            ParamByName('pDisabled').AsBoolean         := GetDisabled;

            ParamByName('pEntryDT').AsDateTime         := Now;
            ParamByName('pUpdateDT').AsDateTime        := Now;
          end;

          CloseTransactions;
          SetDatabaseNames;
          ExecSQL;
          ATr.Commit;
        end;

        with FrmTopMenu.Defs do begin
          CloseConn(ACn, ATr);
          //CloseTransactions;
          SetDatabaseNames;
          OpenSelectQuery(ACnMaker, ADSMaker, ATrMaker, AQuMaker, SQL_20130002);
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
var
  LNextBrandNameID : Integer;
begin
  with FrmTopMenu.Defs do begin
    if Not FInsert then begin
      with AQu do begin
        //if DBEdtMakerID.Text <> '' then begin
        //  SetMakerID(StrToInt(DBEdtMakerID.Text));
        //end else begin
        //  SetMakerID(1);
        //end;
        //CloseConn(ACn, ATr);
        ////CloseTransactions;
        //SetDatabaseNames;
        //if DBEdtMakerID.Text <> '' then begin
        //  OpenSelectQueryWithMakerID(
        //    ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(DBEdtMakerID.Text));
        //  DBLCBMaker.KeyValue := GetMakerID;
        //end;
      end;
      with AQu do begin
        CloseConn(ACn, ATr);
        SetDatabaseNames;
        OpenSelectQueryWithMakerIDAndBrandNameID(
          ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(GetMakerID)), 1);
        //Edit;
        //if RecordCount > 0 then begin
          Insert;
        //end else begin
        //  Edit;
        //end;
        FInsert := True;
      end;

      with FrmTopMenu.Defs do begin
        DBEdtUserID.Text     := IntToStr(GetUID);
        FCurrMakerID         := 0;
        FCurrBrandNameID     := 0;
        DBLCBMaker.SetFocus;
        DBCBEndOfSales.State := cbUnchecked;
        DBCBDisabled.State   := cbUnchecked;
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
var
  LNextBrandNameID : Integer;
begin
  if Not FDoCommit then begin
    with FrmTopMenu.Defs do begin
      CloseConn(ACn, ATr);
      SetDatabaseNames;
      //ProcCancel;
      with AQu do begin
        SetMakerID(DBLCBMaker.KeyValue);
        DBEdtMakerID.Text := VarToStr(GetMakerID);

        //OpenSelectQueryWithMakerIDAndBrandNameID(ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(GetMakerID)), StrToInt(VarToStr(GetBrandNameID)));
        OpenSelectQueryWithMakerIDAndBrandNameID(ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(GetMakerID)), 1);
        if AQu.RecordCount > 0 then begin
          Edit;
        end else begin
          OpenSelectQuery(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20140002);
          LNextBrandNameID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
          CloseConn(ACnNextID, ATrNextID);
          DBEdtBrandNameID.Text := IntToStr(LNextBrandNameID);
          DBEdtBrandName.Text   := '';
          Insert;
          OpenSelectQuery(
            ACnMaker, ADSMaker, ATrMaker, AQuMaker, SQL_20130002);
          DBLCBMaker.KeyValue := StrToInt(VarToStr(GetMakerID));
        end;
        DBEdtUserID.Text := IntToStr(GetUID);
      end;
    end;
  end;
  ADBGrid.AutoAdjustColumns;
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
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  with FrmTopMenu.Defs do begin
    FMakerID     := GetMakerID;
    FBrandNameID := GetBrandNameID;
  end;
end;

procedure TFrmEntryBrandName.FormShow(Sender: TObject);
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
    with AQuMaker do begin
      OpenSelectQuery(
        ACnMaker, ADSMaker, ATrMaker, AQuMaker, SQL_20130002);
      if RecordCount = 0 then begin
        ProcInsert;
      end else begin
        FInsert := False;
      end;
      DBEdtUserID.Text := IntToStr(GetUID);
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
      //OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20140001);
      ADBGrid.DataSource := ADS;

      FReOpenDS       := False;
      Timer.Enabled   := False;
    end;
  end;
end;

end.

