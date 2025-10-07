unit UEntryAccount;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, LCLIntf, ActnList,
  DBDateTimePicker, Types, UDBNavi, UDBG, LMessages;

type

  { TFrmEntryAccount }

  TFrmEntryAccount = class(TForm)
    ActCancel1: TAction;
    ActCommit1: TAction;
    ActInsert1: TAction;
    ActQuit1: TAction;
    ADBGrid: TDBG;
    ADS                 : TDataSource;
    AQu                 : TSQLQuery;
    ADSNextID           : TDataSource;
    AQuNextID           : TSQLQuery;
    { ActionLists }
    ActionList          : TActionList;
    ActCancel           : TAction;
    ActGoBack           : TAction;
    ActInsert           : TAction;
    ActSave             : TAction;
    ADBNavi             : TDBNavi;
    BtnCancel           : TPanel;
    BtnGoBack           : TPanel;
    BtnInsert           : TPanel;
    BtnSave             : TPanel;
    DBCBDisabled        : TDBCheckBox;
    DBDTPEntryDT        : TDBDateTimePicker;
    DBDTPUpdateDT       : TDBDateTimePicker;
    DBEdtUserID         : TDBEdit;
    DBEdtAccountID      : TDBEdit;
    DBEdtBrandName      : TDBEdit;
    DBEdtCurrentBalance : TDBEdit;
    DBEdtPhoneNum       : TDBEdit;
    DBEdtOpeningBalance : TDBEdit;
    DBEdtSubName        : TDBEdit;
    LblAccountID2       : TLabel;
    LblAccountID1       : TLabel;
    LblBrandName1       : TLabel;
    LblBrandName2       : TLabel;
    LblDisabled1        : TLabel;
    LblDisabled2        : TLabel;
    LblDisabled3        : TLabel;
    LblOpeningBalance   : TLabel;
    LblPhoneNumber3     : TLabel;
    LblPhoneNumber2     : TLabel;
    LblPhoneNumber1     : TLabel;
    LblPhoneNumber4     : TLabel;
    LblSubName1         : TLabel;
    LblSubName2         : TLabel;
    LblSubName3         : TLabel;
    Panel1              : TPanel;
    Panel2              : TPanel;
    Panel3              : TPanel;
    Panel4              : TPanel;
    PnlCancel           : TPanel;
    PnlGoBack           : TPanel;
    PnlInsert           : TPanel;
    PnlSave             : TPanel;
    Shape1              : TShape;
    Shape2              : TShape;
    Shape3              : TShape;
    Shape4              : TShape;
    Shape5              : TShape;
    Shape6              : TShape;
    Timer               : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ADBGridDblClick(Sender: TObject);
    procedure ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADBGridMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure ADBGridWMVScroll(Sender: TObject; var Message: TLMVScroll);
    procedure ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AQuAfterClose(DataSet: TDataSet);
    procedure AQuAfterInsert(DataSet: TDataSet);
    procedure AQuAfterPost(DataSet: TDataSet);
    procedure AQuAfterScroll(DataSet: TDataSet);
    procedure AQuBeforeClose(DataSet: TDataSet);
    procedure AQuBeforeOpen(DataSet: TDataSet);
    procedure AQuBeforePost(DataSet: TDataSet);
    procedure AQuBeforeScroll(DataSet: TDataSet);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBEdtAccountIDEnter(Sender: TObject);
    procedure DBEdtAccountIDExit(Sender: TObject);
    procedure DBEdtBrandNameEnter(Sender: TObject);
    procedure DBEdtBrandNameExit(Sender: TObject);
    procedure DBEdtOpeningBalanceEnter(Sender: TObject);
    procedure DBEdtOpeningBalanceExit(Sender: TObject);
    procedure DBEdtPhoneNumEnter(Sender: TObject);
    procedure DBEdtPhoneNumExit(Sender: TObject);
    procedure DBEdtSubNameEnter(Sender: TObject);
    procedure DBEdtSubNameExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcSave(Sender: TObject);
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
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBEdtAccountIDChange(Sender: TObject);
    procedure DBEdtBrandNameChange(Sender: TObject);
    procedure DBEdtOpeningBalanceChange(Sender: TObject);
    procedure DBEdtPhoneNumChange(Sender: TObject);
    procedure DBEdtSubNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FSkipFirstProcess         : Boolean;
    FGuidePanels              : Array[0..3] of TPanel;
    FNavigateBtn              : TNavigateBtn;
    FDBGridClicked            : Boolean;
    FDoCommit                 : Boolean;
    FReOpenDS                 : Boolean;
    FSuppressRecursiveEvent   : Boolean;
    FGoFirst                  : Boolean;
    FAccountID                : Integer;
    FBrandName                : String;
    FSubName                  : String;
    FPhoneNum                 : String;
    FOpeningBalance           : Integer;
    FDisabled                 : Boolean;
    procedure BackupValues;
    function CannotFocusedNavButton: Boolean;
    function DataSetStateToStr(State: TDataSetState): string;
    procedure EnableTimer(Data: PtrInt);
    function GetBrandName: String;
    procedure SetBrandName(BrandName: String);
    function GetSubName: String;
    procedure SetSubName(SubName: String);
    function GetPhoneNum: String;
    procedure SetPhoneNum(PhoneNum: String);
    function GetOpeningBalance: Integer;
    procedure SetOpeningBalance(OpeningBalance: Integer);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    function ShiftStateToStr(Shift: TShiftState): string;
  public
  end;

var
  FrmEntryAccount: TFrmEntryAccount;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageDetails,
  UAddDetailsHeader, UEditDetailsHeader;

{$R *.lfm}

{ TFrmEntryAccount }

procedure TFrmEntryAccount.BackupValues;
begin
  with Defs do begin
    with DBEdtAccountID do begin
      if Text <> '' then begin
        SetAccountID(StrToInt(Text));
      end else begin
        SetAccountID(0);
      end;
    end;

    SetBrandName(DBEdtBrandName.Text);
    SetSubName(DBEdtSubName.Text);
    SetPhoneNum(DBEdtPhoneNum.Text);
    SetOpeningBalance(DBEdtOpeningBalance.Field.AsInteger);

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

function TFrmEntryAccount.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

function TFrmEntryAccount.DataSetStateToStr(State: TDataSetState): string;
begin
  case State of
    dsInactive: Result := 'dsInactive';
    dsBrowse: Result := 'dsBrowse';
    dsEdit: Result := 'dsEdit';
    dsInsert: Result := 'dsInsert';
    dsSetKey: Result := 'dsSetKey';
    dsCalcFields: Result := 'dsCalcFields';
    dsFilter: Result := 'dsFilter';
    dsNewValue: Result := 'dsNewValue';
    dsOldValue: Result := 'dsOldValue';
    dsCurValue: Result := 'dsCurValue';
    dsBlockRead: Result := 'dsBlockRead';
    dsInternalCalc: Result := 'dsInternalCalc';
    dsOpening: Result := 'dsOpening';
  else
    Result := 'Unknown';
  end;
end;

procedure TFrmEntryAccount.EnableTimer(Data: PtrInt);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('EnableTimer: Enabling Timer');
{$ENDIF}
  Timer.Enabled := True;
end;

procedure TFrmEntryAccount.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        if State in [dsInsert, dsEdit] then begin
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20110001);
        end;

        if RecordCount = 0 then begin
          DBEdtBrandName.SetFocus;
        end else begin
          ADBNavi.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryAccount.ProcInsert(Sender: TObject);
var
  LNextID: Integer;
begin
  if Not (AQu.State in [dsInsert, dsEdit]) then begin
    with CommonDB do begin
      with Defs do begin
        try
          with ACn do begin
            if Not Connected then begin
              Open;
            end;
          end;
        except
          on E: Exception do begin
            ShowMessage(MSG_JP_000013 + ' : ' + E.Message);
          end;
        end;

        ATr.Active := False;
        with ATr do begin
          if Not Active then begin
            StartTransaction;
          end;
        end;

        CloseQuery(AQu);
        with AQu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Not Active then begin
            OpenSelectQuery(ADS, AQu, SQL_20110001);
          end;

          Insert;

          DBEdtUserID.Text := IntToStr(GetUID);

          DBEdtBrandName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryAccount.ProcSave(Sender: TObject);
var
  LFS: TFormatSettings;
begin
  Timer.Enabled := False; // Prevent timer events during ProcSave
  FDoCommit := True;
  try
    try
      with CommonDB do begin
        with Defs do begin
          LFS := GetFS;

          // Ensure database connection is open
          if not ACn.Connected then begin
{$IFDEF Debug}
            LazLogger.DebugLn('ProcSave: Opening database connection');
{$ENDIF}
            ACn.Open;
          end;
          with AQu do begin
            CloseQuery(AQu);

            // Ensure transaction is active
            if not ATr.Active then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: Starting transaction');
{$ENDIF}
              ATr.StartTransaction;
            end;
            SQLConnection := ACn;
            SQLTransaction := ATr;

            // Validate BRAND_NAME before setting fields
            if Trim(GetBrandName) = '' then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: BRAND_NAME is empty. Aborting save.');
{$ENDIF}
              MessageDlg(MSG_JP_000048, mtError, [mbOK], 0);
              Exit;
            end;
            try
              SQL.Text := SQL_20110004;
              with Params do begin
                ParamByName('pUserID').AsInteger := GetUID;
                ParamByName('pAccountID').AsInteger := GetAccountID;
                ParamByName('pBrandName').AsString := GetBrandName;
                ParamByName('pSubName').AsString := GetSubName;
                ParamByName('pPhoneNum').AsString := GetPhoneNum;
                ParamByName('pOpeningBalance').AsInteger := GetOpeningBalance;
                ParamByName('pDisabled').AsBoolean := GetDisabled;
                ParamByName('pEntryDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, LFS);
                ParamByName('pUpdateDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, LFS);

                ExecSQL;
                ATr.Commit;
              end;
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave Before Post: AQu.Active=' + BoolToStr(Active, True) +
                                ', AQu.State=' + DataSetStateToStr(State) +
                                ', ATr.Active=' + BoolToStr(ATr.Active, True) +
                                ', ACn.Connected=' + BoolToStr(ACn.Connected, True) +
                                ', USER_ID=' + FieldByName('USER_ID').AsString +
                                ', ACCOUNT_ID=' + FieldByName('ACCOUNT_ID').AsString +
                                ', BRAND_NAME=' + FieldByName('BRAND_NAME').AsString +
                                ', SUB_NAME=' + FieldByName('SUB_NAME').AsString +
                                ', PHONE_NUM=' + FieldByName('PHONE_NUM').AsString +
                                ', OPENING_BALANCE=' + FieldByName('OPENING_BALANCE').AsString +
                                ', DISABLED=' + FieldByName('DISABLED').AsString +
                                ', ENTRY_DT=' + FieldByName('ENTRY_DT').AsString +
                                ', UPDATE_DT=' + FieldByName('UPDATE_DT').AsString);
{$ENDIF}
            except
              on E: ESQLDatabaseError do begin
                MessageDlg(MSG_JP_000046 + ': ' + E.Message, mtError, [mbOk], 0);
                ATr.Rollback;
              end;
            end;
          end;

          if not ATr.Active then begin
{$IFDEF Debug}
            LazLogger.DebugLn('ProcSave: Starting transaction after ApplyUpdates');
{$ENDIF}
            ATr.StartTransaction;
          end;

          OpenSelectQuery(ADS, AQu, SQL_20110002);

          if not Active then begin
{$IFDEF Debug}
            LazLogger.DebugLn('ProcSave: Failed to reopen AQu after ApplyUpdates');
{$ENDIF}
            raise Exception.Create('Failed to reopen dataset after ApplyUpdates');
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
{$IFDEF Debug}
        LazLogger.DebugLn('ProcSave: General SQL Error: ' + E.Message);
{$ENDIF}
        with CommonDB do begin
          if ATr.Active then ATr.Rollback;
          ShowMessage(MSG_JP_000013 + ': ' + E.Message);
        end;
      end;
    end;
  finally
    FReOpenDS := True;
    FDoCommit := False;
    Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
  end;
end;

procedure TFrmEntryAccount.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryAccount.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryAccount.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryAccount.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryAccount.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

function TFrmEntryAccount.GetBrandName: String;
begin
  Result := FBrandName;
end;

procedure TFrmEntryAccount.SetBrandName(BrandName: String);
begin
  FBrandName := BrandName;
end;

function TFrmEntryAccount.GetSubName: String;
begin
  Result := FSubName;
end;

procedure TFrmEntryAccount.SetSubName(SubName: String);
begin
  FSubName := SubName;
end;

function TFrmEntryAccount.GetPhoneNum: String;
begin
  Result := FPhoneNum;
end;

procedure TFrmEntryAccount.SetPhoneNum(PhoneNum: String);
begin
  FPhoneNum := PhoneNum;
end;

function TFrmEntryAccount.GetOpeningBalance: Integer;
begin
  Result := FOpeningBalance;
end;

procedure TFrmEntryAccount.SetOpeningBalance(OpeningBalance: Integer);
begin
  FOpeningBalance := OpeningBalance;
end;

function TFrmEntryAccount.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryAccount.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryAccount.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);

  ADBNavi.SetFocus;
  if AQu.RecordCount > 0 then begin
    ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
  end;
end;

procedure TFrmEntryAccount.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryAccount.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryAccount.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryAccount.ADBGridDblClick(Sender: TObject);
begin
  AQu.Edit;
end;

procedure TFrmEntryAccount.ADBGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LMsg              : string = MSG_JP_000042;
  LGridCoord        : TGridCoord;
  LRowIndex         : Integer;
  LPrevRecNo        : Integer;
begin
  if FSuppressRecursiveEvent then begin
    Exit;
  end;

  // イベントの再帰呼び出しを防ぐ
  if ADBGrid.Tag = 1 then begin
    Exit;
  end;
  ADBGrid.Tag := 1;

  try
    with AQu do begin
      if AQu.State in [dsInsert, dsEdit] then begin
        FSuppressRecursiveEvent := True;

        LGridCoord := ADBGrid.MouseCoord(X, Y);
        LRowIndex  := LGridCoord.Y;
        if LRowIndex > 0 then begin
          if AQu.State = dsInsert then begin
            if AQu.RecNo = 0 then begin
              LPrevRecNo := 1;
            end else begin
              LPrevRecNo := AQu.RecNo;
            end;
            LRowIndex  := LRowIndex - 1;
          end;
        end;

        try
          if DBEdtBrandName.Text <> '' then begin
            LMsg := MSG_JP_000043;
          end;

          if AQu.RecordCount > 0 then begin;
            if MessageDlg(LMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
              // 「はい」が選ばれたらキャンセル処理を実行
              ProcCancel(Self);
              AQu.First;
              AQu.MoveBy(LRowIndex - LPrevRecNo);
              Abort;
            end else begin
              // 「いいえ」が選ばれたらスクロール自体を中止する
              Abort;
            end;
          end else begin
            Abort;
          end;
        finally
          FSuppressRecursiveEvent := False;
        end;
      end;
    end;
  finally
    ADBGrid.Tag := 0; // フラグをリセット
  end;
end;

procedure TFrmEntryAccount.ADBGridMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  Msg : string = MSG_JP_000042;
begin
  if FSuppressRecursiveEvent then begin
    Exit;
  end;

  // イベントの再帰呼び出しを防ぐ
  if ADBGrid.Tag = 1 then begin
    Exit;
  end;
  ADBGrid.Tag := 1;

  try
    if AQu.State in [dsInsert, dsEdit] then begin
      FSuppressRecursiveEvent := True;
      try
        if DBEdtBrandName.Text <> '' then begin
          Msg := MSG_JP_000043;
        end;

        if AQu.RecordCount > 0 then begin;
          if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            // 「はい」が選ばれたらキャンセル処理を実行
            ProcCancel(Self);
            Handled := True;
          end else begin
            // 「いいえ」が選ばれたらスクロール自体を中止する
            Handled := True;
          end;
        end else begin
          Handled := True;
        end;
      finally
        FSuppressRecursiveEvent := False;
      end;
    end;
  finally
    ADBGrid.Tag := 0;
  end;
end;

procedure TFrmEntryAccount.ADBGridSelectEditor(
  Sender: TObject; Column: TColumn; var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryAccount.ADBGridWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
var
  Msg : string = MSG_JP_000042;
begin
  if FSuppressRecursiveEvent then begin
    Exit;
  end;

  if (AQu.State in [dsInsert, dsEdit]) and (Message.ScrollCode in [SB_LINEUP, SB_LINEDOWN, SB_PAGEUP, SB_PAGEDOWN]) then begin
    FSuppressRecursiveEvent := True;
    try
      if DBEdtBrandName.Text <> '' then begin
        Msg := MSG_JP_000043;
      end;
      if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
        // 「はい」が選ばれたらキャンセル処理を実行してスクロールする
        ProcCancel(Self);
        Message.Result  := 1;
      end else begin
        // 「いいえ」が選ばれたらスクロール自体を中止する
        FGoFirst        := True;
        Message.Result  := 1;
      end;
    finally
      FSuppressRecursiveEvent := False;
    end;
  end else begin
    FDBGridClicked := False;
  end;
end;

procedure TFrmEntryAccount.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn
  );
begin
  with CommonDB do begin
{$IFDEF Debug}
    LazLogger.DebugLn('DBNaviClick: Button=' + IntToStr(Ord(Index)) +
                      ', AQu.Active=' + BoolToStr(AQu.Active, True) +
                      ', AQu.State=' + DataSetStateToStr(AQu.State) +
                      ', FDoCommit=' + BoolToStr(FDoCommit, True) +
                      ', ATr.Active=' + BoolToStr(ATr.Active, True) +
                      ', ACn.Connected=' + BoolToStr(ACn.Connected, True));
{$ENDIF}
  end;
  if FDoCommit then begin
{$IFDEF Debug}
    LazLogger.DebugLn('DBNaviClick: Skipping due to FDoCommit=True');
{$ENDIF}
    Exit;
  end;
  FNavigateBtn := Index;
end;

procedure TFrmEntryAccount.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    BtnGoBack.SetFocus;
  end else if (Key = VK_TAB) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if CannotFocusedNavButton then begin
        BtnInsert.SetFocus;
      end else begin
        ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryAccount.AQuAfterClose(DataSet: TDataSet);
begin
  with CommonDB do begin
{$IFDEF Debug}
    LazLogger.DebugLn('AQuAfterClose: AQu.Active=' + BoolToStr(AQu.Active, True) +
                      ', AQu.State=' + DataSetStateToStr(AQu.State) +
                      ', FDoCommit=' + BoolToStr(FDoCommit, True) +
                      ', FReOpenDS=' + BoolToStr(FReOpenDS, True) +
                      ', ATr.Active=' + BoolToStr(ATr.Active, True) +
                      ', ACn.Connected=' + BoolToStr(ACn.Connected, True));
{$ENDIF}
  end;
end;

procedure TFrmEntryAccount.AQuAfterInsert(DataSet: TDataSet);
begin
  with Defs do begin
    with AQuNextID do begin
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-1: Before Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;
      OpenSelectQuery(ADSNextID, AQuNextID, SQL_20110003);
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-2: After Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;
      AQu.FieldByName('ACCOUNT_ID').AsInteger  := FieldByName('NEXT_ID').AsInteger;
      AQu.FieldByName('DISABLED').AsBoolean := False;

      with CommonDB do begin
        CloseQuery(AQuNextID);
      end;
    end;
  end;
end;

procedure TFrmEntryAccount.AQuAfterPost(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuAfterPost: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State) +
                    ', FDoCommit=' + BoolToStr(FDoCommit, True) +
                    ', FReOpenDS=' + BoolToStr(FReOpenDS, True));
{$ENDIF}
  if FDoCommit then begin
{$IFDEF Debug}
    LazLogger.DebugLn('AQuAfterPost: Skipping additional actions due to FDoCommit=True');
{$ENDIF}
    Exit;
  end;

  with AQu do begin
    // Ensure dataset remains active
    if not Active then begin
{$IFDEF Debug}
      LazLogger.DebugLn('AQuAfterPost: AQu is inactive. Reopening dataset.');
{$ENDIF}
      with CommonDB do begin
        with Defs do begin
          if not ATr.Active then begin
{$IFDEF Debug}
            LazLogger.DebugLn('AQuAfterPost: Starting transaction');
{$ENDIF}
            ATr.StartTransaction;
          end;
          OpenSelectQuery(ADS, AQu, SQL_20110001);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryAccount.AQuAfterScroll(DataSet: TDataSet);
var
  Msg : string = MSG_JP_000042;
begin
  if FSuppressRecursiveEvent then begin
    Exit;
  end;

  //======================================================
  if AQu.State = dsInsert then begin
    FSuppressRecursiveEvent := True;
    try
      if Not FDoCommit then begin
        if DBEdtBrandName.Text <> '' then begin
          Msg := MSG_JP_000043;
        end;

        if AQu.RecordCount > 0 then begin;
          if Not FSkipFirstProcess then begin;
            if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
              // 「はい」が選ばれたらキャンセル処理を実行
              ProcCancel(Self);
              Abort;
            end else begin
              // 「いいえ」が選ばれたらスクロール自体を中止する
              Abort;
            end;
          end else begin
            FSkipFirstProcess := False;
          end;
        end else begin
          Abort;
        end;
      end;
    finally
      FSuppressRecursiveEvent := False;
    end;
  end;

  ADBGrid.AutoAdjustColumns;

  //======================================================
{$IFDEF Debug}
  LazLogger.DebugLn('AQuAfterScroll-1: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}

  if FSuppressRecursiveEvent then begin
    Exit;
  end;

  if FGoFirst then begin
    FGoFirst := False;
    AQu.First;
  end;

  case FNavigateBtn of
  nbFirst:
    begin
      if AQu.RecordCount > 0 then begin
        ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
      end;
    end;
  nbPrior:
    begin
      if AQu.RecNo <= 1 then begin
        ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
      end;
    end;
  nbNext:
    begin
      if AQu.RecNo = AQu.RecordCount then begin
        ADBNavi.FindNextControl(ADBNavi, False, True, True).SetFocus;
      end;
    end;
  nbLast:
    begin
      ADBNavi.FindNextControl(ADBNavi, False, True, True).SetFocus;
    end;
  end;

{$IFDEF Debug}
  LazLogger.DebugLn('AQuAfterScroll-2: AQu.Active=' + BoolToStr(AQu.Active, True) +
                  ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryAccount.AQuBeforeClose(DataSet: TDataSet);
begin
  with CommonDB do begin
{$IFDEF Debug}
    LazLogger.DebugLn('AQuBeforeClose: AQu.Active=' + BoolToStr(AQu.Active, True) +
                      ', AQu.State=' + DataSetStateToStr(AQu.State) +
                      ', FDoCommit=' + BoolToStr(FDoCommit, True) +
                      ', FReOpenDS=' + BoolToStr(FReOpenDS, True) +
                      ', ATr.Active=' + BoolToStr(ATr.Active, True) +
                      ', ACn.Connected=' + BoolToStr(ACn.Connected, True));
{$ENDIF}
  end;
end;

procedure TFrmEntryAccount.AQuBeforeOpen(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeOpen: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryAccount.AQuBeforePost(DataSet: TDataSet);
var
  LFS: TFormatSettings;
begin
  with Defs do begin
    LFS := GetFS;
    with DataSet do begin
      if FieldByName('DISABLED').AsAnsiString = '' then begin
        FieldByName('DISABLED').AsBoolean := False;
      end;
      // Check MAKER_NAME and abort posting if empty
      if Trim(FieldByName('BRAND_NAME').AsString) = '' then begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuBeforePost: BRAND_NAME is empty. Aborting post.');
{$ENDIF}
        MessageDlg(MSG_JP_000048, mtError, [mbOk], 0);
        Abort; // Cancel the Post operation without affecting the transaction
      end;
      try
        if AQu.State = dsInsert then begin
          if FieldByName('ENTRY_DT').IsNull then begin
            FieldByName('ENTRY_DT').AsAnsiString
              := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, LFS);
          end;
        end else if AQu.State = dsEdit then begin
          if FieldByName('UPDATE_DT').IsNull then begin
            FieldByName('UPDATE_DT').AsAnsiString
              := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, LFS);
          end;
        end;
      except
        on E: EConvertError do begin
{$IFDEF Debug}
          LazLogger.DebugLn('AQuBeforePost: Date conversion error: ' + E.Message);
{$ENDIF}
          ShowMessage(MSG_JP_000050 + ':' + E.Message);
          Abort; // Prevent posting
        end;
      end;
      // Log field values for debugging
{$IFDEF Debug}
      LazLogger.DebugLn('AQuBeforePost: USER_ID=' + FieldByName('USER_ID').AsString +
                        ', ACCOUNT_ID=' + FieldByName('ACCOUNT_ID').AsString +
                        ', BRAND_NAME=' + FieldByName('BRAND_NAME').AsString +
                        ', SUB_NAME=' + FieldByName('SUB_NAME').AsString +
                        ', PHONE_NUM=' + FieldByName('PHONE_NUM').AsString +
                        ', OPENING_BALANCE=' + FieldByName('OPENING_BALANCE').AsString +
                        ', DISABLED=' + FieldByName('DISABLED').AsString +
                        ', ENTRY_DT=' + FieldByName('ENTRY_DT').AsString +
                        ', UPDATE_DT=' + FieldByName('UPDATE_DT').AsString);
{$ENDIF}
    end;
  end;
  with AQu do begin
{$IFDEF Debug}
    LazLogger.DebugLn('AQuBeforePost: AQu.Active=' + BoolToStr(AQu.Active, True) +
                      ', AQu.State=' + DataSetStateToStr(State) +
                      ', BRAND_NAME raw=' + FieldByName('BRAND_NAME').AsString +
                      ', Trimmed=' + Trim(FieldByName('BRAND_NAME').AsString));
{$ENDIF}
  end;
end;

procedure TFrmEntryAccount.AQuBeforeScroll(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeScroll: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryAccount.DBEdtAccountIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with Defs do begin
      with DBEdtAccountID do begin
        if Text <> '' then begin
          SetAccountID(StrToInt(Text));
        end else begin
          SetAccountID(0);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryAccount.DBEdtAccountIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtAccountIDExit(Sender: TObject);
begin
  Shape1.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtBrandNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetBrandName(DBEdtBrandName.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtBrandNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtBrandNameExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtSubNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetSubName(DBEdtSubName.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtSubNameEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtSubNameExit(Sender: TObject);
begin
  Shape3.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtPhoneNumChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetPhoneNum(DBEdtPhoneNum.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtPhoneNumEnter(Sender: TObject);
begin
  Shape4.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtPhoneNumExit(Sender: TObject);
begin
  Shape4.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtOpeningBalanceChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if DBEdtOpeningBalance.Text = '' then begin
      SetOpeningBalance(0);
    end else begin
      SetOpeningBalance(DBEdtOpeningBalance.Field.AsInteger);
    end;
  end;
end;

procedure TFrmEntryAccount.DBEdtOpeningBalanceEnter(Sender: TObject);
begin
  Shape5.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtOpeningBalanceExit(Sender: TObject);
begin
  Shape5.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBCBDisabledChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
      DBCBDisabled.Checked := True;
    end else begin
      SetDisabled(False);
      DBCBDisabled.Checked := False;
    end;
    Timer.Enabled := True;
  end;
end;

procedure TFrmEntryAccount.DBCBDisabledEnter(Sender: TObject);
begin
  Shape6.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBCBDisabledExit(Sender: TObject);
begin
  Shape6.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
  end;

  with Defs do begin
    SetAccountID(FAccountID);

    if GetEntryAccount = 0 then begin
      FrmManageDetails             := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible     := True;
    end else if GetEntryAccount = 1 then begin
      FrmAddDetailsHeader          := TFrmAddDetailsHeader.Create(Application);
      FrmAddDetailsHeader.Visible  := True;
    end else if GetEntryAccount = 2 then begin
      FrmEditDetailsHeader         := TFrmEditDetailsHeader.Create(Application);
      FrmEditDetailsHeader.Visible := True;
    end;
  end;

  CloseAction     := caFree;
  FrmEntryAccount := nil;
end;

procedure TFrmEntryAccount.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FReOpenDS         := False;
  FDoCommit         := False;
  Timer.Enabled     := False;
  FDBGridClicked    := False;
  FSkipFirstProcess := True;

  Timer.Enabled     := False;

  //with CommonDB do begin
  //  ACn.KeepConnection := True;
  //  ADS.AutoEdit       := False; // Prevent auto-editing
  //  AQu.Options        := AQu.Options - [sqoAutoApplyUpdates]; // Prevent auto-apply
  //  AQu.UpdateMode     := upWhereKeyOnly; // Optimize update behavior
  //  ADS.Enabled        := True;
  //end;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryAccount.FormShow(Sender: TObject);
begin
  Self.Width      := 708;

  Self.KeyPreview := True;

  Self.Color      := RGB(112, 168, 175);
  PnlInsert.Color := RGB( 72, 122, 129);
  PnlCancel.Color := RGB( 72, 122, 129);
  PnlSave.Color   := RGB( 72, 122, 129);
  PnlGoBack.Color := RGB( 72, 122, 129);

  with Defs do begin
    FAccountID := GetAccountID;
  end;

  { Debug }
  //Self.Width      := 865;
end;

procedure TFrmEntryAccount.FormActivate(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with ACn do begin
            if not Connected then
              Open;
          end;

          with ATr do begin
            if Not Active then begin
              StartTransaction;
            end;
          end;

          OpenSelectQuery(ADS, AQu, SQL_20110001);
          ProcInsert(Sender);
        end;
      end;

      ADBGrid.AutoAdjustColumns;
      Timer.Enabled := True;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  finally
  end;
end;

function TFrmEntryAccount.ShiftStateToStr(Shift: TShiftState): string;
begin
  Result                          := '';
  if ssShift in Shift then Result := Result + 'Shift+';
  if ssAlt in Shift then Result   := Result + 'Alt+';
  if ssCtrl in Shift then Result  := Result + 'Ctrl+';
  if Result = '' then Result      := 'None';
end;

procedure TFrmEntryAccount.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('FormKeyUp: Key=' + IntToStr(Key) +
                    ', Shift=' + ShiftStateToStr(Shift) +
                    ', AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State) +
                    ', FDoCommit=' + BoolToStr(FDoCommit, True));
{$ENDIF}
  if FDoCommit then begin
{$IFDEF Debug}
    LazLogger.DebugLn('FormKeyUp: Skipping due to FDoCommit=True');
{$ENDIF}
    Key := 0; // Suppress key event
    Exit;
  end;

  if ((Key = VK_SPACE) Or (Key = VK_RETURN)) and (Shift = []) then begin
{$IFDEF Debug}
    LazLogger.DebugLn('FormKeyUp: Executing ' + ActiveControl.Name);
{$ENDIF}
    if ActiveControl.Name = 'BtnInsert' then begin
      ActInsert.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
    Key := 0; // Prevent further processing
  end;
  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryAccount.TimerTimer(Sender: TObject);
var
  i            : Integer;
  LTargetIndex : Integer;
begin
  Timer.Enabled := False;

{$IFDEF Debug}
  LazLogger.DebugLn('TimerTimer: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State) +
                    ', FDoCommit=' + BoolToStr(FDoCommit, True) +
                    ', FReOpenDS=' + BoolToStr(FReOpenDS, True));
{$ENDIF}
  if FDoCommit then begin
{$IFDEF Debug}
    LazLogger.DebugLn('TimerTimer: Skipping due to FDoCommit=True');
{$ENDIF}
    Exit;
  end;

  if AQu.State in [dsInsert, dsEdit] then begin
    if AQu.Active and (AQu.State in [dsInsert, dsEdit]) then begin
      try
        if DBCBDisabled.State = cbChecked then begin
          AQu.FieldByName('DISABLED').AsBoolean := True;
        end else begin
          AQu.FieldByName('DISABLED').AsBoolean := False;
        end;
      except
        on E: Exception do begin
{$IFDEF Debug}
          LazLogger.DebugLn('TimerTimer: Error setting DISABLED: ' + E.Message);
{$ENDIF}
        end;
      end;
    end else begin
{$IFDEF Debug}
      LazLogger.DebugLn('TimerTimer: Skipping DISABLED update due to AQu.Active=' +
                        BoolToStr(AQu.Active, True) + ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
    end;
  end;

  if FReOpenDS and not FDoCommit then begin
{$IFDEF Debug}
    LazLogger.DebugLn('TimerTimer: Reopening dataset (skipped due to commented OpenSelectQuery)');
{$ENDIF}
    FReOpenDS := False;
  end else begin
{$IFDEF Debug}
    LazLogger.DebugLn('TimerTimer: Skipping dataset reopen due to FReOpenDS=' +
                      BoolToStr(FReOpenDS, True) + ', FDoCommit=' + BoolToStr(FDoCommit, True));
{$ENDIF}
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
{$IFDEF Debug}
      LazLogger.DebugLn('TimerTimer: Error in GuidePanels: ' + E.Message);
{$ENDIF}
      ShowMessage(E.Message);
    end;
  end;
end;

end.

