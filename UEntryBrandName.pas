unit UEntryBrandName;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, LCLType,
  ActnList, UDBNavi, UDBG, Types, LMessages;

type

  { TFrmEntryBrandName }

  TFrmEntryBrandName = class(TForm)
    ActCancel1: TAction;
    ActCommit1: TAction;
    ActInsert1: TAction;
    ActQuit1: TAction;
    ADBGrid: TDBG;
    ADS              : TDataSource;
    AQu              : TSQLQuery;
    ADSMaker         : TDataSource;
    AQuMaker         : TSQLQuery;
    ADSNextID        : TDataSource;
    AQuNextID        : TSQLQuery;
    { ActionLists }
    ActionList       : TActionList;
    ActCancel        : TAction;
    ActEntryMaker    : TAction;
    ActGoBack        : TAction;
    ActInsert        : TAction;
    ActSave          : TAction;
    ADBNavi           : TDBNavi;
    BtnCancel        : TPanel;
    BtnEntryMaker    : TPanel;
    BtnGoBack        : TPanel;
    BtnInsert        : TPanel;
    BtnSave          : TPanel;
    DBCBDisabled     : TDBCheckBox;
    DBCBEndOfSales   : TDBCheckBox;
    DBEdtBrandNameID : TDBEdit;
    DBEdtBrandName   : TDBEdit;
    DBEdtMakerID     : TDBEdit;
    DBEdtUserID      : TDBEdit;
    DBLCBMaker       : TDBLookupComboBox;
    LblBrandName1    : TLabel;
    LblBrandName2    : TLabel;
    LblDisabled1     : TLabel;
    LblDisabled2     : TLabel;
    LblDisabled3     : TLabel;
    LblEndOfSales1   : TLabel;
    LblEndOfSales2   : TLabel;
    LblID1           : TLabel;
    LblID2           : TLabel;
    LblMaker         : TLabel;
    Panel1           : TPanel;
    Panel2           : TPanel;
    Panel3           : TPanel;
    Panel4           : TPanel;
    PnlCancel        : TPanel;
    PnlEntryMaker    : TPanel;
    PnlGoBack        : TPanel;
    PnlInsert        : TPanel;
    PnlSave          : TPanel;
    Shape1           : TShape;
    Shape2           : TShape;
    Shape3           : TShape;
    Shape4           : TShape;
    Shape5           : TShape;
    Timer            : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActEntryMakerExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADBGridMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure ADBGridWMVScroll(Sender: TObject; var Message: TLMVScroll);
    procedure ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
    procedure AQuAfterScroll(DataSet: TDataSet);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure BtnEntryMakerEnter(Sender: TObject);
    procedure BtnEntryMakerExit(Sender: TObject);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBCBEndOfSalesEnter(Sender: TObject);
    procedure DBCBEndOfSalesExit(Sender: TObject);
    procedure DBEdtBrandNameEnter(Sender: TObject);
    procedure DBEdtBrandNameExit(Sender: TObject);
    procedure DBEdtBrandNameIDChange(Sender: TObject);
    procedure DBEdtBrandNameIDEnter(Sender: TObject);
    procedure DBEdtBrandNameIDExit(Sender: TObject);
    procedure DBLCBMakerChange(Sender: TObject);
    procedure DBLCBMakerEnter(Sender: TObject);
    procedure DBLCBMakerExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    //FTab              : Boolean;
    FGuidePanels      : Array[0..3] of TPanel;
    FNavigateBtn      : TNavigateBtn;
    FDBGridClicked     : Boolean;
    FDoCommit         : Boolean;
    FReOpenDS         : Boolean;
    FInsert           : Boolean;
    FBrandNameID      : Integer;
    FCurrMakerID      : Integer;
    FMakerID          : Integer;
    procedure BackupValues;
    function CannotFocusedNavButton: Boolean;
    procedure ProcCancel(Sender: TObject);
    procedure ProcEntryMaker(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure EntryMakerMouseOver(NewColor: TColor);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure InsertMouseOver(NewColor: TColor);
    procedure SaveMouseOver(NewColor: TColor);
  public

  end;

var
  FrmEntryBrandName: TFrmEntryBrandName;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageDetails,
  UAddDetail, UEditDetail, UEntryMaker;

{$R *.lfm}

{ TFrmEntryBrandName }

procedure TFrmEntryBrandName.BackupValues;
begin
  with Defs do begin
    if Not VarIsNull(DBLCBMaker.KeyValue) then begin;
      SetMakerID(VarToInt(DBLCBMaker.KeyValue));
    end;
    with DBEdtBrandNameID do begin
      if (Text <> '')
        And (StrToInt(Text) > 0) then begin;
          SetBrandNameID(StrToInt(Text));
      end else begin
        SetBrandNameID(0);
      end;
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

function TFrmEntryBrandName.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

procedure TFrmEntryBrandName.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        if AQu.RecordCount > 0 then begin
          FInsert := False;
          ATr.Rollback;
          OpenSelectQueryWithMakerID(ADS, AQu, SQL_20140002, GetMakerID);

          OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
          SetKeyValToDBLCB(
            DBLCBMaker, DBEdtMakerID, GetMakerID);

          DBCBEndOfSales.Checked := False;
          DBCBDisabled.Checked   := False;
        end;
      end;

      if AQu.RecordCount = 0 then begin
        DBEdtBrandName.SetFocus;
      end else begin
        ADBNavi.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ProcEntryMaker(Sender: TObject);
begin
  with Defs do begin
    SetEntryMaker(0);
    Close;
  end;
end;

procedure TFrmEntryBrandName.ProcInsert(Sender: TObject);
var
  LNextID: Integer;
begin
  try
    try
      if Not FInsert then begin
        with CommonDB do begin
          with Defs do begin
            if Not VarIsNull(DBLCBMaker.KeyValue) then begin
              ATr.Active := False;
              with ATr do begin
                if Not Active then begin
                  StartTransaction;
                end;
              end;

              with AQu do begin
                FInsert := True;
                OpenSelectQueryWithMakerID(ADS, AQu, SQL_20140002, GetMakerID);

                if Active then begin
                  Insert;
                end;
              end;

              with AQuMaker do begin
                OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
                SetKeyValToDBLCB(
                  DBLCBMaker, DBEdtMakerID, GetMakerID);
              end;

              DBEdtUserID.Text := IntToStr(GetUID);

              if GetBrandNameID = 0 then begin
                OpenSelectQueryWithMakerID(
                  ADSNextID, AQuNextID, SQL_20140003, GetMakerID);
                LNextID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

                CloseQuery(AQuNextID);
                DBEdtBrandNameID.Text := IntToStr(LNextID);

                SetBrandNameID(LNextID);
              end;


              FInsert := True;

              DBCBEndOfSales.Checked := False;
              DBCBDisabled.Checked   := False;
              DBLCBMaker.SetFocus;
            end;
          end;
        end;
      end;

    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmEntryBrandName.ProcSave(Sender: TObject);
var
  LNextBrandNameID  : Integer;
  LMakerID     : Integer;
begin
  FDoCommit := True;
  try
    try
      with CommonDB do begin
        CloseQuery(AQu);

        with Defs do begin
          with AQu do begin
            SQL.Text := SQL_20140005;
            Params.ParamByName('pUserID').AsInteger := GetUID;

            with Params do begin
              FCurrMakerID := GetMakerID;

              if FCurrMakerID > 0 then begin
                ParamByName('pMakerID').AsInteger  := FCurrMakerID;
              end else begin
                ParamByName('pMakerID').AsInteger  := GetMakerID;
              end;
              LMakerID := ParamByName('pMakerID').AsInteger;

              OpenSelectQueryWithMakerID(
                ADSNextID, AQuNextID, SQL_20140003, LMakerID);
              LNextBrandNameID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              CloseQuery(AQuNextID);

              if GetBrandNameID > 0 then begin
                ParamByName('pBrandNameID').AsInteger  := GetBrandNameID;
              end else begin
                ParamByName('pBrandNameID').AsInteger  := LNextBrandNameID;
              end;

              ParamByName('pBrandName').AsAnsiString     := GetBrandName;

              ParamByName('pEndOfSales').AsBoolean       := GetEndOfSales;

              ParamByName('pDisabled').AsBoolean         := GetDisabled;

              ParamByName('pEntryDT').AsDateTime         := Now;
              ParamByName('pUpdateDT').AsDateTime        := Now;
            end;

            //CloseTransactions;
            //SetDatabaseNames;

            ExecSQL;
            ATr.Commit;
          end;

          //CloseConn(ACn, ATr, AQu);
          //SetDatabaseNames;

          OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
          DBLCBMaker.KeyValue := GetMakerID;

          if DBEdtBrandNameID.Text <> '' then begin
            OpenSelectQueryWithMakerIDAndBrandNameID(
              ADS, AQu, SQL_20140002, VarToInt(DBLCBMaker.KeyValue), StrToInt(DBEdtBrandNameID.Text));
          end else begin
            if (LMakerID > 0) then begin
              OpenSelectQueryWithMakerIDAndBrandNameID(
                ADS, AQu, SQL_20140002, LMakerID, 1);
            end else begin
              MessageDlg(MSG_JP_000034, mtInformation, [mbOk], 0);
            end;
          end;

          ADBGrid.AutoAdjustColumns;
          FInsert := False;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
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

procedure TFrmEntryBrandName.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryBrandName.EntryMakerMouseOver(NewColor: TColor);
begin
  BtnEntryMaker.Color := NewColor;
end;

procedure TFrmEntryBrandName.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryBrandName.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryBrandName.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnCancelEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnEntryMakerEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clSkyBlue);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnEntryMakerExit(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnGoBackEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnInsertEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnSaveEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
  with CommonDB do begin
    ATr.Rollback;

    with Defs do begin
      with AQuMaker do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
      end;
      with AQu do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQuery(ADS, AQu, SQL_20140002);
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ActEntryMakerExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryMaker(Sender);
end;

procedure TFrmEntryBrandName.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryBrandName.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryBrandName.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryBrandName.ADBGridEnter(Sender: TObject);
begin

end;

procedure TFrmEntryBrandName.ADBGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FInsert then begin;
    if Not FDBGridClicked then begin
      FDBGridClicked := True;
      ADBGridSelectEditor(
        Sender, ADBGrid.LastColumn, TWinControl(ADBGrid));

      ADBNavi.SetFocus;
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;

      Abort;
    end;
  end;
end;

procedure TFrmEntryBrandName.ADBGridMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  if FInsert then begin
    if DBEdtBrandName.Text = '' then begin
      if MessageDlg(MSG_JP_000042,
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        // 「はい」が選ばれたらキャンセル処理を実行
        ProcCancel(Self);
      end else begin
        // 「いいえ」が選ばれたらスクロール自体を中止する
        Abort;
      end;
    end else begin
      if MessageDlg(MSG_JP_000043,
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        // 「はい」が選ばれたらキャンセル処理を実行
        ProcCancel(Self);
      end else begin
        // 「いいえ」が選ばれたらスクロール自体を中止する
        Abort;
      end;
    end;
  end else begin
    FDBGridClicked := False;
  end;
end;

procedure TFrmEntryBrandName.ADBGridSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  if FDBGridClicked then begin
    if FInsert then begin
      if DBEdtBrandName.Text = '' then begin
        if MessageDlg(MSG_JP_000042,
                      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          // 「はい」が選ばれたらキャンセル処理を実行
          ProcCancel(Self);
        end else begin
          // 「いいえ」が選ばれたらスクロール自体を中止する
          Abort;
        end;
      end else begin
        if MessageDlg(MSG_JP_000043,
                      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          // 「はい」が選ばれたらキャンセル処理を実行
          ProcCancel(Self);
        end else begin
          // 「いいえ」が選ばれたらスクロール自体を中止する
          Abort;
        end;
      end;
    end else begin
      FDBGridClicked := False;
    end;
  end;

  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryBrandName.ADBGridWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
begin
  if FInsert then begin;
    if Not FDBGridClicked then begin
      FDBGridClicked := True;
      ADBGridSelectEditor(Sender, ADBGrid.LastColumn, TWinControl(ADBGrid));

      ADBNavi.SetFocus;
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;

      Abort;
    end;
  end;
end;

procedure TFrmEntryBrandName.ADBNaviBtnClick(Sender: TObject;
  Index: TNavigateBtn);
begin
  FNavigateBtn := Index;

  with CommonDB do begin
    if AQu.RecordCount > 0 then begin
      if FInsert then begin
        ProcCancel(Sender);
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    BtnGoBack.SetFocus;
  end else if (Key = VK_TAB) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if CannotFocusedNavButton then begin
        DBLCBMaker.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ADBNaviWMSetFocus(Sender: TObject;
  HWndLostFocus: HWND);
begin
  if Screen.ActiveControl is TDBNavi then begin
    if CannotFocusedNavButton then begin
      DBLCBMaker.SetFocus;
    end else begin
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
    end;
  end;
end;

procedure TFrmEntryBrandName.AQuAfterScroll(DataSet: TDataSet);
begin
  case FNavigateBtn of
  nbFirst:
    if AQu.RecordCount > 0 then begin
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
    end;
  nbPrior:
    if AQu.RecNo <= 1 then begin
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
    end;
  nbNext:
    begin
      if AQu.RecNo = AQu.RecordCount then begin
        ADBNavi.FindNextControl(ADBNavi, False, True, True).SetFocus;
      end;
    end;
  nbLast: ADBNavi.FindNextControl(ADBNavi, False, True, True).SetFocus;
  end;

  Timer.Enabled := True;
end;

procedure TFrmEntryBrandName.DBCBDisabledEnter(Sender: TObject);
begin
  Shape5.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBCBDisabledExit(Sender: TObject);
begin
  Shape5.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBCBEndOfSalesEnter(Sender: TObject);
begin
  Shape4.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBCBEndOfSalesExit(Sender: TObject);
begin
  Shape4.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with CommonDB do begin
      with Defs do begin
        if (AQu.FieldByName('BRAND_NAME_ID').AsAnsiString <> '')
          And (AQu.FieldByName('BRAND_NAME_ID').AsInteger > 0) then begin
          SetBrandNameID(AQu.FieldByName('BRAND_NAME_ID').AsVariant);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameExit(Sender: TObject);
begin
  if Not FDoCommit then begin
    with Defs do begin
      SetBrandName(DBEdtBrandName.Text);
    end;
  end;

  Shape3.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBLCBMakerChange(Sender: TObject);
var
  LMakerID : Integer;
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          LMakerID := VarToInt(DBLCBMaker.KeyValue);

          CloseQuery(AQu);
          CloseQuery(AQuMaker);

          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQueryWithMakerID(
              ADS, AQu, SQL_20140002, LMakerID);

            Insert;
            FInsert := True;
          end;

          with AQuMaker do begin
            OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
            SetKeyValToDBLCB(DBLCBMaker, DBEdtMakerID, LMakerID);

            SetMakerID(LMakerID);

            DBCBEndOfSales.Checked := False;
            DBCBDisabled.Checked   := False;
          end;
        end;
      end;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmEntryBrandName.DBLCBMakerEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBLCBMakerExit(Sender: TObject);
begin
  Shape1.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
    CloseQuery(AQuMaker);
  end;

  with Defs do begin
    // Restore value of previous screen
    SetMakerID(FMakerID);
    SetBrandNameID(FBrandNameID);

    if GetEntryMaker = 0 then begin
      FrmEntryMaker            := TFrmEntryMaker.Create(Application);
      FrmEntryMaker.Visible    := True;
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
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FReOpenDS       := False;
  FDoCommit       := False;
  FInsert         := False;
  Timer.Enabled   := False;

  FDBGridClicked     := False;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryBrandName.FormShow(Sender: TObject);
begin
  Self.Width          := 594;

  Self.KeyPreview     := True;

  Self.Color          := RGB(112, 168, 175);
  PnlEntryMaker.Color := RGB( 72, 122, 129);
  PnlInsert.Color     := RGB( 72, 122, 129);
  PnlCancel.Color     := RGB( 72, 122, 129);
  PnlSave.Color       := RGB( 72, 122, 129);
  PnlGoBack.Color     := RGB( 72, 122, 129);

  with Defs do begin
    FMakerID          := GetMakerID;
    FBrandNameID      := GetBrandNameID;
  end;

  { Debug }
  //FrmEntryBrandName.Width := 813;
end;

procedure TFrmEntryBrandName.FormActivate(Sender: TObject);
var
  LMakerID: Integer = 0;
begin
  with CommonDB do begin
    with Defs do begin
      OpenSelectQueryWithMakerID(ADS, AQu, SQL_20140002, LMakerID);

      OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
      DBEdtUserID.Text := IntToStr(GetUID);
    end;
  end;

  DBLCBMaker.SetFocus;

  Timer.Enabled := True;
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryBrandName.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Timer.Enabled := True;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnEntryMaker' then begin
      ActEntryMaker.Execute;
    end else if ActiveControl.Name = 'BtnInsert' then begin
      ActInsert.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

procedure TFrmEntryBrandName.TimerTimer(Sender: TObject);
var
  i            : Integer;
  LTargetIndex : Integer;
begin
  Timer.Enabled      := False;

  if FInsert then begin
    with AQu do begin
      if Active then begin
        Edit;
        if DBCBEndOfSales.State = cbChecked then begin
          AQu.FieldByName('END_OF_SALES').AsBoolean := True;
        end else begin
          AQu.FieldByName('END_OF_SALES').AsBoolean := False;
        end;
        if DBCBDisabled.State = cbChecked then begin
          AQu.FieldByName('DISABLED').AsBoolean := True;
        end else begin
          AQu.FieldByName('DISABLED').AsBoolean := False;
        end;
      end;
    end;
  end;

  if FReOpenDS then begin
    with CommonDB do begin
      with Defs do begin
        OpenSelectQuery(ADS, AQu, SQL_20130002);
      end;
    end;
    FReOpenDS          := False;
  end;

  try
    if (ActiveControl is TDBNavFocusableButton) then begin
      LTargetIndex := ActiveControl.ComponentIndex - 10;

      for i := Low(FGuidePanels) To High(FGuidePanels) do begin
        FGuidePanels[i].Visible := (i = LTargetIndex);
      end;
    end else begin
      for i := Low(FGuidePanels) To High(FGuidePanels) do begin
        FGuidePanels[i].Visible := False;
      end;
    end;
  except
    on E: Exception do begin
      ShowMessage(E.Message);
    end;
  end;
end;

end.

