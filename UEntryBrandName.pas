unit UEntryBrandName;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, ActnList;

type

  { TFrmEntryBrandName }

  TFrmEntryBrandName = class(TForm)
    ACn              : TSQLite3Connection;
    ACnNextID        : TSQLite3Connection;
    ActCancel1: TAction;
    ActCommit1: TAction;
    ActInsert1: TAction;
    ActionList       : TActionList;
    ACnMaker         : TSQLite3Connection;
    ActInsert        : TAction;
    ActCancel        : TAction;
    ActQuit1: TAction;
    ActSave          : TAction;
    ActEntryMaker    : TAction;
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
    BtnEntryMaker    : TPanel;
    BtnInsert: TPanel;
    BtnCancel: TPanel;
    BtnSave: TPanel;
    BtnGoBack: TPanel;
    PnlCancel        : TPanel;
    PnlSave        : TPanel;
    PnlGoBack        : TPanel;
    PnlInsert        : TPanel;
    PnlEntryMaker    : TPanel;
    Timer            : TTimer;
    procedure ProcEntryMaker(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure EntryMakerMouseOver(NewColor: TColor);
    procedure BtnEntryMakerEnter(Sender: TObject);
    procedure BtnEntryMakerExit(Sender: TObject);
    procedure InsertMouseOver(NewColor: TColor);
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure SaveMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActEntryMakerExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
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
    FMakerID         : Variant;
    FBrandNameID     : Variant;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    procedure BackupValues;
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

procedure TFrmEntryBrandName.ProcEntryMaker(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetEntryMaker(0);
    Close;
  end;
end;

procedure TFrmEntryBrandName.ProcInsert(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if Not FInsert then begin
      with AQu do begin
        CloseConn(ACn, ATr);
        SetDatabaseNames;
        OpenSelectQueryWithMakerIDAndBrandNameID(
          ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(GetMakerID)), 1);
        Insert;
        FInsert := True;
      end;

      with FrmTopMenu.Defs do begin
        DBEdtUserID.Text     := IntToStr(GetUID);
        FCurrMakerID         := 0;
        DBLCBMaker.SetFocus;
        DBCBEndOfSales.State := cbUnchecked;
        DBCBDisabled.State   := cbUnchecked;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ProcCancel(Sender: TObject);
begin
  if FInsert then begin
    FInsert := False;
  end;

  ATr.Rollback;
  with FrmTopMenu.Defs do begin
    CloseTransactions;
    SetDatabaseNames;

    OpenSelQuAndSetVal(ACnMaker, ADSMaker, ATrMaker, AQuMaker,
    DBLCBMaker, DBEdtMakerID, SQL_20130002, StrToInt(VarToStr(GetMakerID)));
  end;
end;

procedure TFrmEntryBrandName.ProcSave(Sender: TObject);
var
  LNextShopID  : Integer;
  LMakerID     : Integer;
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

            OpenSelectQueryWithMakerID(
              ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20140002, LMakerID);
            LNextShopID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

            CloseConn(ACnNextID, ATrNextID);

            SetDatabaseNames;
            if VarToStr(GetBrandNameID) <> '' then begin
              ParamByName('pBrandNameID').AsInteger  := StrToInt(VarToStr(GetBrandNameID));
            end else begin
              ParamByName('pBrandNameID').AsInteger  := LNextShopID;
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
          SetDatabaseNames;

          OpenSelectQuery(ACnMaker, ADSMaker, ATrMaker, AQuMaker, SQL_20130002);
          DBLCBMaker.KeyValue := GetMakerID;

          if DBEdtBrandNameID.Text <> '' then begin
            OpenSelectQueryWithMakerIDAndBrandNameID(
              ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(DBLCBMaker.KeyValue)), StrToInt(DBEdtBrandNameID.Text));
          end else begin
            if (LMakerID > 0) then begin
              OpenSelectQueryWithMakerIDAndBrandNameID(
                ACn, ADS, ATr, AQu, SQL_20140001, LMakerID, 1);
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

procedure TFrmEntryBrandName.EntryMakerMouseOver(NewColor: TColor);
begin
  BtnEntryMaker.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnEntryMakerEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clSkyBlue);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.BtnEntryMakerExit(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnInsertEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnCancelEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnSaveEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnGoBackEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmEntryBrandName.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryBrandName.ActEntryMakerExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryMaker(Sender);
end;

procedure TFrmEntryBrandName.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryBrandName.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEntryBrandName.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
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

      with AQu do begin
        SetMakerID(DBLCBMaker.KeyValue);
        DBEdtMakerID.Text := VarToStr(GetMakerID);

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
          DBLCBMaker.KeyValue := GetMakerID;
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

procedure TFrmEntryBrandName.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseTransactions;

  with FrmTopMenu.Defs do begin
    // Restore values of previous screen
    //SetMakerID(FMakerID);
    //SetBrandNameID(FBrandNameID);

    if GetEntryMaker = 0 then begin
      FrmEntryMaker            := TFrmEntryMaker.Create(Application);
      FrmEntryMaker.Visible    := True;
    //end else if GetEntryBrandName = 0 then begin
    //  FrmManageDetails         := TFrmManageDetails.Create(Application);
    //  FrmManageDetails.Visible := True;
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
  PnlSave.Color         := RGB( 72, 122, 129);
  PnlGoBack.Color         := RGB( 72, 122, 129);

  with FrmTopMenu.Defs do begin
    with AQuMaker do begin
      OpenSelectQuery(
        ACnMaker, ADSMaker, ATrMaker, AQuMaker, SQL_20130002);
      if RecordCount = 0 then begin
        ProcInsert(Sender);
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
      ADBGrid.DataSource := ADS;

      FReOpenDS       := False;
      Timer.Enabled   := False;
    end;
  end;
end;

end.

