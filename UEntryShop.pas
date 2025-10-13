unit UEntryShop;

{$mode ObjFPC}{$H+}

interface
uses
  Classes, LCLType, SysUtils, Variants, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, LCLIntf, ActnList,
  DBDateTimePicker, UDBNavi, UDBG, Types, LMessages;

type
  { TFrmEntryShop }

  TFrmEntryShop = class(TForm)
    ADBGrid: TDBG;
    ADS                  : TDataSource;
    AQu                  : TSQLQuery;
    ADSNextID            : TDataSource;
    AQuNextID            : TSQLQuery;
    { ActionLists }
    ActionList           : TActionList;
    ActCancel            : TAction;
    ActGoBack            : TAction;
    ActInsert            : TAction;
    ActSave              : TAction;
    ADBNavi              : TDBNavi;
    BtnCancel            : TPanel;
    BtnGoBack            : TPanel;
    BtnInsert            : TPanel;
    BtnSave              : TPanel;
    DBCBDisabled         : TDBCheckBox;
    DBDTPEndBusinessDT   : TDBDateTimePicker;
    DBDTPUpdateDT        : TDBDateTimePicker;
    DBDTPStartBusinessDT : TDBDateTimePicker;
    DBDTPEntryDT         : TDBDateTimePicker;
    DBEdtUserID          : TDBEdit;
    DBEdtShopName        : TDBEdit;
    DBEdtShopID          : TDBEdit;
    DBEdtPhoneNum        : TDBEdit;
    LblDisabled1         : TLabel;
    LblDisabled2         : TLabel;
    LblDisabled3         : TLabel;
    LblEndBusinessDT1    : TLabel;
    LblEndBusinessDT2    : TLabel;
    LblEndBusinessDT3    : TLabel;
    LblEndBusinessDT4    : TLabel;
    LblID1               : TLabel;
    LblID2               : TLabel;
    LblStartBusinessDT1  : TLabel;
    LblStartBusinessDT2  : TLabel;
    LblStartBusinessDT3  : TLabel;
    LblStartBusinessDT4  : TLabel;
    LblShopName1         : TLabel;
    LblShopName2         : TLabel;
    LblShopName3         : TLabel;
    LblPhoneNumber3      : TLabel;
    LblPhoneNumber2      : TLabel;
    LblPhoneNumber1      : TLabel;
    LblPhoneNumber4      : TLabel;
    Panel1               : TPanel;
    Panel2               : TPanel;
    Panel3               : TPanel;
    Panel4               : TPanel;
    PnlCancel            : TPanel;
    PnlGoBack            : TPanel;
    PnlInsert            : TPanel;
    PnlSave              : TPanel;
    Shape1               : TShape;
    Shape2               : TShape;
    Shape3               : TShape;
    Shape4               : TShape;
    Shape5               : TShape;
    Shape6               : TShape;
    Timer                : TTimer;
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
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure BtnInsertClick(Sender: TObject);
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBDTPEndBusinessDTChange(Sender: TObject);
    procedure DBDTPEndBusinessDTEnter(Sender: TObject);
    procedure DBDTPEndBusinessDTExit(Sender: TObject);
    procedure DBDTPStartBusinessDTChange(Sender: TObject);
    procedure DBDTPStartBusinessDTEnter(Sender: TObject);
    procedure DBDTPStartBusinessDTExit(Sender: TObject);
    procedure DBEdtPhoneNumChange(Sender: TObject);
    procedure DBEdtPhoneNumEnter(Sender: TObject);
    procedure DBEdtPhoneNumExit(Sender: TObject);
    procedure DBEdtShopIDChange(Sender: TObject);
    procedure DBEdtShopIDEnter(Sender: TObject);
    procedure DBEdtShopIDExit(Sender: TObject);
    procedure DBEdtShopNameChange(Sender: TObject);
    procedure DBEdtShopNameEnter(Sender: TObject);
    procedure DBEdtShopNameExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FSkipFirstProcess         : Boolean;
    FGuidePanels              : Array[0..3] of TPanel;
    FNavigateBtn              : TNavigateBtn;
    FDBGridClicked            : Boolean;
    FDoCommit                 : Boolean;
    FReOpenDS                 : Boolean;
    FSuppressRecursiveEvent   : Boolean;
    FGoFirst                  : Boolean;
    FShopID                   : Integer;
    FShopName                 : String;
    FPhoneNum                 : String;
    FStartBusinessDT          : String;
    FEndBusinessDT            : String;
    FDisabled                 : Boolean;
    procedure BackupValues;
    function CannotFocusedNavButton: Boolean;
    function DataSetStateToStr(State: TDataSetState): string;
    procedure EnableTimer(Data: PtrInt);
    procedure ProcCancel(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure InsertMouseOver(NewColor: TColor);
    procedure SaveMouseOver(NewColor: TColor);
    function ShiftStateToStr(Shift: TShiftState): string;
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    function GetEndBusinessDT: String;
    procedure SetEndBusinessDT(EndBusinessDT: String);
    function GetPhoneNum: String;
    procedure SetPhoneNum(PhoneNum: String);
    function GetShopName: String;
    procedure SetShopName(ShopName: String);
    function GetStartBusinessDT: String;
    procedure SetStartBusinessDT(StartBusinessDT: String);
  public  end;var
  FrmEntryShop: TFrmEntryShop;implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UManageDetails,
  UAddDetailsHeader, UEditDetailsHeader;

{$R *.lfm}

{ TFrmEntryShop }

procedure TFrmEntryShop.BackupValues;
begin
  with Defs do begin
    with DBEdtShopID do begin
      if Text <> '' then begin
        SetShopID(StrToInt(Text));
      end else begin
        SetShopID(0);
      end;
    end;

    SetShopName(DBEdtShopName.Text);
    SetPhoneNum(DBEdtPhoneNum.Text);
    SetStartBusinessDT(FormatDateTime(
      'yyyy/mm/dd hh:nn:ss',
      DBDTPStartBusinessDT.Field.AsDateTime, GetFS));

    if Not DBDTPEndBusinessDT.Field.IsNull then begin
      SetEndBusinessDT(FormatDateTime(
        'yyyy/mm/dd hh:nn:ss',
        DBDTPEndBusinessDT.Field.AsDateTime, GetFS));
    end else begin
      SetEndBusinessDT('9999/12/31 23:59:59');
    end;
    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

function TFrmEntryShop.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;function TFrmEntryShop.DataSetStateToStr(State: TDataSetState): string;
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

procedure TFrmEntryShop.EnableTimer(Data: PtrInt);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('EnableTimer: Enabling Timer');
{$ENDIF}
  Timer.Enabled := True;
end;

procedure TFrmEntryShop.ProcCancel(Sender: TObject);
var
  LPrevID : Integer;
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        if State in [dsInsert, dsEdit] then begin
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20080001);
        end;

        if RecordCount = 0 then begin
          DBEdtShopName.SetFocus;
        end else if RecordCount > 0 then begin
          ADBNavi.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryShop.ProcInsert(Sender: TObject);
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
            OpenSelectQuery(ADS, AQu, SQL_20080001);
          end;

          Insert;
          FSkipFirstProcess := True;

          DBEdtUserID.Text := IntToStr(GetUID);

          DBEdtShopName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryShop.ProcSave(Sender: TObject);
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
          if Not ACn.Connected then begin
{$IFDEF Debug}
            LazLogger.DebugLn('ProcSave: Opening database connection');
{$ENDIF}
            ACn.Open;
          end;
          with AQu do begin
            CloseQuery(AQu);

            // Ensure transaction is active
            if Not ATr.Active then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: Starting transaction');
{$ENDIF}
              ATr.StartTransaction;
            end;
            SQLConnection := ACn;
            SQLTransaction := ATr;

            //Validate SHOP_NAME before setting fields
            if Trim(GetShopName) = '' then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: SHOP_NAME is empty. Aborting save.');
{$ENDIF}
              MessageDlg(MSG_JP_000025, mtError, [mbOK], 0);
              Exit;
            end;
            try
              SQL.Text := SQL_20080004;
              with Params do begin
                ParamByName('pUserID').AsInteger := GetUID;
                ParamByName('pShopID').AsInteger := GetShopID;
                ParamByName('pShopName').AsString := GetShopName;
                ParamByName('pPhoneNum').AsString := GetPhoneNum;
                ParamByName('pStartBusinessDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', StrToDateTime(GetStartBusinessDT, LFS), LFS);
                ParamByName('pEndBusinessDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', StrToDateTime(GetEndBusinessDT, LFS), LFS);
                ParamByName('pDisabled').AsBoolean := GetDisabled;
                ParamByName('pEntryDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, LFS);
                ParamByName('pUpdateDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, LFS);            ExecSQL;

                ExecSQL;
                ATr.Commit;
              end;
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave Before Post: AQu.Active=' + BoolToStr(Active, True) +
                                ', AQu.State=' + DataSetStateToStr(State) +
                                ', ATr.Active=' + BoolToStr(ATr.Active, True) +
                                ', ACn.Connected=' + BoolToStr(ACn.Connected, True) +
                                ', USER_ID=' + FieldByName('USER_ID').AsString +
                                ', SHOP_ID=' + FieldByName('SHOP_ID').AsString +
                                ', SHOP_NAME=' + FieldByName('SHOP_NAME').AsString +
                                ', PHONE_NUM=' + FieldByName('PHONE_NUM').AsString +
                                ', START_BUSINESS_DT=' + FieldByName('START_BUSINESS_DT').AsString +
                                ', END_BUSINESS_DT=' + FieldByName('END_BUSINESS_DT').AsString +
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

            if Not ATr.Active then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: Starting transaction after ApplyUpdates');
{$ENDIF}
              ATr.StartTransaction;
            end;
            OpenSelectQuery(ADS, AQu, SQL_20080001);

            if Not Active then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: Failed to reopen AQu after ExecSQL');
{$ENDIF}
              raise Exception.Create('Failed to reopen dataset after ExecSQL');
            end;
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

    // Cross-platform timer enabling
    Application.QueueAsyncCall(@EnableTimer, 0);
  end;
end;

procedure TFrmEntryShop.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryShop.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryShop.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryShop.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryShop.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.BtnInsertClick(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryShop.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

function TFrmEntryShop.GetShopName: String;
begin
  Result := FShopName;
end;

procedure TFrmEntryShop.SetShopName(ShopName: String);
begin
  FShopName := ShopName;
end;

function TFrmEntryShop.GetPhoneNum: String;
begin
  Result := FPhoneNum;
end;

procedure TFrmEntryShop.SetPhoneNum(PhoneNum: String);
begin
  FPhoneNum := PhoneNum;
end;

function TFrmEntryShop.GetStartBusinessDT: String;
begin
  Result := FStartBusinessDT;
end;

procedure TFrmEntryShop.SetStartBusinessDT(StartBusinessDT: String);
begin
  FStartBusinessDT := StartBusinessDT;
end;

function TFrmEntryShop.GetEndBusinessDT: String;
begin
  Result := FEndBusinessDT;
end;

procedure TFrmEntryShop.SetEndBusinessDT(EndBusinessDT: String);
begin
  FEndBusinessDT := EndBusinessDT;
end;

function TFrmEntryShop.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryShop.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryShop.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);  ADBNavi.SetFocus;
  if AQu.RecordCount > 0 then begin
    ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
    ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
  end;
end;

procedure TFrmEntryShop.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryShop.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryShop.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryShop.ADBGridDblClick(Sender: TObject);
begin
  AQu.Edit;
end;

procedure TFrmEntryShop.ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
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
          if DBEdtShopName.Text <> '' then begin
            LMsg := MSG_JP_000043;
          end;

          if AQu.RecordCount > 0 then begin
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

procedure TFrmEntryShop.ADBGridMouseWheel(
  Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  LMsg              : string = MSG_JP_000042;
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
        if DBEdtShopName.Text <> '' then begin
          LMsg := MSG_JP_000043;
        end;

        if AQu.RecordCount > 0 then begin
          if MessageDlg(LMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
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
    ADBGrid.Tag := 0; // フラグをリセット
   end;
end;

procedure TFrmEntryShop.ADBGridSelectEditor(
  Sender: TObject; Column: TColumn; var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryShop.ADBGridWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
var
  Msg : string = MSG_JP_000042;
begin
  if FSuppressRecursiveEvent then begin
    Exit;
  end;

  if (AQu.State in [dsInsert, dsEdit])
      And (Message.ScrollCode in [SB_LINEUP, SB_LINEDOWN, SB_PAGEUP, SB_PAGEDOWN]) then begin
    FSuppressRecursiveEvent := True;
    try
      if DBEdtShopName.Text <> '' then begin
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

procedure TFrmEntryShop.ADBNaviBtnClick(Sender: TObject;
  Index: TNavigateBtn);
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

procedure TFrmEntryShop.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (Shift = [ssShift]) then begin
    BtnGoBack.SetFocus;
  end else if (Key = VK_TAB) And (Shift = []) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if CannotFocusedNavButton then begin
        BtnInsert.SetFocus;
      end else begin
        ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryShop.AQuAfterClose(DataSet: TDataSet);
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

procedure TFrmEntryShop.AQuAfterInsert(DataSet: TDataSet);
begin
  with Defs do begin
    with AQuNextID do begin
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-1: Before Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;
      OpenSelectQuery(ADSNextID, AQuNextID, SQL_20080003);
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-2: After Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;

      AQu.FieldByName('SHOP_ID').AsInteger  := FieldByName('NEXT_ID').AsInteger;
      AQu.FieldByName('DISABLED').AsBoolean := False;

      with CommonDB do begin
        CloseQuery(AQuNextID);
      end;
    end;
  end;
end;

procedure TFrmEntryShop.AQuAfterPost(DataSet: TDataSet);
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
    if Not Active then begin
{$IFDEF Debug}
      LazLogger.DebugLn('AQuAfterPost: AQu is inactive. Reopening dataset.');
{$ENDIF}
      with CommonDB do begin
        with Defs do begin
          if Not ATr.Active then begin
{$IFDEF Debug}
            LazLogger.DebugLn('AQuAfterPost: Starting transaction');
{$ENDIF}
            ATr.StartTransaction;
          end;
          OpenSelectQuery(ADS, AQu, SQL_20080001);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryShop.AQuAfterScroll(DataSet: TDataSet);
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
        if DBEdtShopName.Text <> '' then begin
          Msg := MSG_JP_000043;
        end;

        if AQu.RecordCount > 0 then begin
          if Not FSkipFirstProcess then begin
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
  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.AQuBeforeClose(DataSet: TDataSet);
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

procedure TFrmEntryShop.AQuBeforeOpen(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeOpen: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryShop.AQuBeforePost(DataSet: TDataSet);
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
      if Trim(FieldByName('SHOP_NAME').AsString) = '' then begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuBeforePost: SHOP_NAME is empty. Aborting post.');
{$ENDIF}
        MessageDlg(MSG_JP_000025, mtError, [mbOk], 0);
        // Cancel the Post operation without affecting the transaction
        Abort;
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
          // Prevent posting
          Abort;
        end;
      end;

{$IFDEF Debug}
      LazLogger.DebugLn('AQuBeforePost: USER_ID=' + FieldByName('USER_ID').AsString +
                        ', SHOP_ID=' + FieldByName('SHOP_ID').AsString +
                        ', SHOP_NAME=' + FieldByName('SHOP_NAME').AsString +
                        ', PHONE_NUM=' + FieldByName('PHONE_NUM').AsString +
                        ', START_BUSINESS_DT=' + FieldByName('START_BUSINESS_DT').AsString +
                        ', END_BUSINESS_DT=' + FieldByName('END_BUSINESS_DT').AsString +
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
                      ', SHOP_NAME raw=' + FieldByName('SHOP_NAME').AsString +
                      ', Trimmed=' + Trim(FieldByName('SHOP_NAME').AsString));
{$ENDIF}
  end;
end;

procedure TFrmEntryShop.AQuBeforeScroll(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeScroll: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryShop.DBEdtShopIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with Defs do begin
      with DBEdtShopID do begin
        if Text <> '' then begin
          SetShopID(StrToInt(Text));
        end else begin
          SetShopID(0);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryShop.DBEdtShopIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmEntryShop.DBEdtShopIDExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmEntryShop.DBEdtShopNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetShopName(DBEdtShopName.Text);
  end;
end;

procedure TFrmEntryShop.DBEdtShopNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBEdtShopNameExit(Sender: TObject);
begin
  Shape2.Visible := False;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBEdtPhoneNumChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetPhoneNum(DBEdtPhoneNum.Text);
  end;
end;

procedure TFrmEntryShop.DBEdtPhoneNumEnter(Sender: TObject);
begin
  Shape3.Visible := True;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBEdtPhoneNumExit(Sender: TObject);
begin
  Shape3.Visible := False;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBDTPStartBusinessDTChange(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if Not FDoCommit then begin
        SetStartBusinessDT(FormatDateTime(
          'yyyy/mm/dd hh:nn:ss',
          DBDTPStartBusinessDT.Field.AsDateTime, GetFS));
      end;
    end;
  end;
end;

procedure TFrmEntryShop.DBDTPStartBusinessDTEnter(Sender: TObject);
begin
  Shape4.Visible := True;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBDTPStartBusinessDTExit(Sender: TObject);
begin
  Shape4.Visible := False;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBDTPEndBusinessDTChange(Sender: TObject);
begin
  with Defs do begin
    if Not FDoCommit then begin
      if Not DBDTPEndBusinessDT.Field.IsNull then begin
        SetEndBusinessDT(FormatDateTime(
          'yyyy/mm/dd hh:nn:ss',
          DBDTPEndBusinessDT.Field.AsDateTime, GetFS));
      end else begin
        SetEndBusinessDT('9999/12/31 23:59:59');
      end;
    end;
  end;
end;

procedure TFrmEntryShop.DBDTPEndBusinessDTEnter(Sender: TObject);
begin
  Shape5.Visible := True;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBDTPEndBusinessDTExit(Sender: TObject);
begin
  Shape5.Visible := False;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBCBDisabledChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
      DBCBDisabled.Checked := True;
    end else begin
      SetDisabled(False);
      DBCBDisabled.Checked := False;
    end;

    // Cross-platform timer enabling
    Application.QueueAsyncCall(@EnableTimer, 0);
  end;
end;

procedure TFrmEntryShop.DBCBDisabledEnter(Sender: TObject);
begin
  Shape6.Visible := True;  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryShop.DBCBDisabledExit(Sender: TObject);
begin
  Shape6.Visible := False;
  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
  end;

  with Defs do begin
    // Restore value of previous screen
    SetShopID(FShopID);
    if GetEntryShop = 0 then begin
      FrmManageDetails             := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible     := True;
    end else if GetEntryShop = 1 then begin
      FrmAddDetailsHeader          := TFrmAddDetailsHeader.Create(Application);
      FrmAddDetailsHeader.Visible  := True;
    end else if GetEntryShop = 2 then begin
      FrmEditDetailsHeader         := TFrmEditDetailsHeader.Create(Application);
      FrmEditDetailsHeader.Visible := True;
    end;
  end;

  CloseAction  := caFree;
  FrmEntryShop := nil;
end;

procedure TFrmEntryShop.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FReOpenDS         := False;
  FDoCommit         := False;
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

procedure TFrmEntryShop.FormShow(Sender: TObject);
begin
  Self.Width      := 623;
  Self.KeyPreview := True;

  Self.Color      := RGB(112, 168, 175);
  PnlInsert.Color := RGB( 72, 122, 129);
  PnlCancel.Color := RGB( 72, 122, 129);
  PnlSave.Color   := RGB( 72, 122, 129);
  PnlGoBack.Color := RGB( 72, 122, 129);

  with Defs do begin
    FShopID       := GetShopID;
  end;

  { Debug }
  //Self.Width      := 920;
end;

procedure TFrmEntryShop.FormActivate(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with ACn do begin
            if Not Connected then begin
              Open;
            end;
          end;

          with ATr do begin
            if Not Active then begin
              StartTransaction;
            end;
          end;

          OpenSelectQuery(ADS, AQu, SQL_20080001);

          ProcInsert(Sender);
        end;
      end;

      ADBGrid.AutoAdjustColumns;
      // Cross-platform timer enabling
      Application.QueueAsyncCall(@EnableTimer, 0);
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

function TFrmEntryShop.ShiftStateToStr(Shift: TShiftState): string;
begin
  Result                          := '';
  if ssShift in Shift then begin
    Result := Result + 'Shift+';
  end else if ssAlt in Shift then begin
    Result   := Result + 'Alt+';
  end else if ssCtrl in Shift then begin
    Result  := Result + 'Ctrl+';
  end else if Result = '' then begin
    Result      := 'None';
  end;
end;

procedure TFrmEntryShop.FormKeyUp(Sender: TObject; var Key: Word;
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
  if ((Key = VK_SPACE) Or (Key = VK_RETURN)) And (Shift = []) then begin
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
    // Prevent further processing
    Key := 0;
  end;
  // Cross-platform timer enabling
  Application.QueueAsyncCall(@EnableTimer, 0);
end;

procedure TFrmEntryShop.TimerTimer(Sender: TObject);
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

  if AQu.Active And (AQu.State in [dsInsert, dsEdit]) then begin
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

  if FReOpenDS And not FDoCommit then begin
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
    if ActiveControl is TDBNavFocusableButton then begin
      LTargetIndex := ActiveControl.ComponentIndex - 10;
      for i := Low(FGuidePanels) to High(FGuidePanels) do begin
        FGuidePanels[i].Visible := (i = LTargetIndex);
      end;
    end else begin
      for i := Low(FGuidePanels) to High(FGuidePanels) do begin
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


