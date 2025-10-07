unit UEntryMaker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, LCLIntf, ActnList,
  UDBNavi, UDBG, LMessages, Types;

type

  { TFrmEntryMaker }

  TFrmEntryMaker = class(TForm)
    ADBGrid: TDBG;
    ADS            : TDataSource;
    AQu            : TSQLQuery;
    ADSNextID      : TDataSource;
    AQuNextID      : TSQLQuery;
    { ActionLists }
    ActionList     : TActionList;
    ActCancel      : TAction;
    ActGoBack      : TAction;
    ActInsert      : TAction;
    ActSave        : TAction;
    ADBNavi        : TDBNavi;
    BtnCancel      : TPanel;
    BtnGoBack      : TPanel;
    BtnInsert      : TPanel;
    BtnSave        : TPanel;
    DBCBDisabled   : TDBCheckBox;
    DBEdtUserID    : TDBEdit;
    DBEdtMakerID   : TDBEdit;
    DBEdtMakerName : TDBEdit;
    LblDisabled1   : TLabel;
    LblDisabled2   : TLabel;
    LblDisabled3   : TLabel;
    LblMakerID1    : TLabel;
    LblMakerID2    : TLabel;
    LblMakerName   : TLabel;
    Panel1         : TPanel;
    Panel2         : TPanel;
    Panel3         : TPanel;
    Panel4         : TPanel;
    PnlCancel      : TPanel;
    PnlGoBack      : TPanel;
    PnlInsert      : TPanel;
    PnlSave        : TPanel;
    Shape1         : TShape;
    Shape2         : TShape;
    Shape3         : TShape;
    Timer          : TTimer;
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
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBEdtMakerIDChange(Sender: TObject);
    procedure DBEdtMakerIDEnter(Sender: TObject);
    procedure DBEdtMakerIDExit(Sender: TObject);
    procedure DBEdtMakerNameChange(Sender: TObject);
    procedure DBEdtMakerNameEnter(Sender: TObject);
    procedure DBEdtMakerNameExit(Sender: TObject);
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
    FMakerID                  : Integer;
    FMakerName                : String;
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
    function GetMakerName: String;
    procedure SetMakerName(MakerName: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
  public

  end;

var
  FrmEntryMaker: TFrmEntryMaker;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu,
  UAddDetail, UEditDetail, UEntryBrandName;

{$R *.lfm}

{ TFrmEntryMaker }

procedure TFrmEntryMaker.BackupValues;
begin
  with Defs do begin
    with DBEdtMakerID do begin
      if Text <> '' then begin
        SetMakerID(StrToInt(Text));
      end else begin
        SetMakerID(0);
      end;
    end;

    SetMakerName(DBEdtMakerName.Text);

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

function TFrmEntryMaker.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

function TFrmEntryMaker.DataSetStateToStr(State: TDataSetState): string;
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

procedure TFrmEntryMaker.EnableTimer(Data: PtrInt);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('EnableTimer: Enabling Timer');
{$ENDIF}
  Timer.Enabled := True;
end;

procedure TFrmEntryMaker.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        if State in [dsInsert, dsEdit] then begin
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20130001);
        end;

        if RecordCount = 0 then begin
          DBEdtMakerName.SetFocus;
        end else begin
          ADBNavi.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.ProcInsert(Sender: TObject);
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
            OpenSelectQuery(ADS, AQu, SQL_20130001);
          end;

          Insert;

          DBEdtUserID.Text := IntToStr(GetUID);

          DBEdtMakerName.SetFocus;
        end;
      end;
    end;
  end;
end;
 
procedure TFrmEntryMaker.ProcSave(Sender: TObject);
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

            // Validate MAKER_NAME before setting fields
            if Trim(GetMakerName) = '' then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: MAKER_NAME is empty. Aborting save.');
{$ENDIF}
              MessageDlg(MSG_JP_000049, mtError, [mbOK], 0);
              Exit;
            end;
            try
              SQL.Text := SQL_20130004;
              with Params do begin
                ParamByName('pUserID').AsInteger := GetUID;
                ParamByName('pMakerID').AsInteger := GetMakerID;
                ParamByName('pMakerName').AsString := GetMakerName;
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
                                ', MAKER_ID=' + FieldByName('MAKER_ID').AsString +
                                ', MAKER_NAME=' + FieldByName('MAKER_NAME').AsString +
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

          OpenSelectQuery(ADS, AQu, SQL_20130001);

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

procedure TFrmEntryMaker.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryMaker.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryMaker.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryMaker.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

function TFrmEntryMaker.GetMakerName: String;
begin
  Result := FMakerName;
end;

procedure TFrmEntryMaker.SetMakerName(MakerName: String);
begin
  FMakerName := MakerName;
end;

function TFrmEntryMaker.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryMaker.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryMaker.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);

  ADBNavi.SetFocus;
  if AQu.RecordCount > 0 then begin
    ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
  end;
end;

procedure TFrmEntryMaker.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryMaker.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryMaker.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Self);
end;

procedure TFrmEntryMaker.ADBGridDblClick(Sender: TObject);
begin
  AQu.Edit;
end;

procedure TFrmEntryMaker.ADBGridMouseDown(Sender: TObject;
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
          if DBEdtMakerName.Text <> '' then begin
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

procedure TFrmEntryMaker.ADBGridMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
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
        if DBEdtMakerName.Text <> '' then begin
          Msg := MSG_JP_000043;
        end;

        if AQu.RecordCount > 0 then begin;
          if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
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

procedure TFrmEntryMaker.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryMaker.ADBGridWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
var
  Msg : string = MSG_JP_000042;
begin
  if FSuppressRecursiveEvent then begin
    Exit;
  end;

  if ((AQu.State in [dsInsert, dsEdit])
      And (Message.ScrollCode in [SB_LINEUP, SB_LINEDOWN, SB_PAGEUP, SB_PAGEDOWN])) then begin
    FSuppressRecursiveEvent := True;
    try
      if DBEdtMakerName.Text <> '' then begin
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

procedure TFrmEntryMaker.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
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

procedure TFrmEntryMaker.ADBNaviKeyUp(Sender: TObject; var Key: Word;
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

procedure TFrmEntryMaker.AQuAfterClose(DataSet: TDataSet);
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

procedure TFrmEntryMaker.AQuAfterInsert(DataSet: TDataSet);
begin
  with Defs do begin
    with AQuNextID do begin
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-1: Before Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;
      OpenSelectQuery(ADSNextID, AQuNextID, SQL_20130003);
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-2: After Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;
      AQu.FieldByName('MAKER_ID').AsInteger  := FieldByName('NEXT_ID').AsInteger;
      AQu.FieldByName('DISABLED').AsBoolean := False;

      with CommonDB do begin
        CloseQuery(AQuNextID);
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.AQuAfterPost(DataSet: TDataSet);
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
          OpenSelectQuery(ADS, AQu, SQL_20130001);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.AQuAfterScroll(DataSet: TDataSet);
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
        if DBEdtMakerName.Text <> '' then begin
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

procedure TFrmEntryMaker.AQuBeforeClose(DataSet: TDataSet);
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

procedure TFrmEntryMaker.AQuBeforeOpen(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeOpen: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryMaker.AQuBeforePost(DataSet: TDataSet);
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
      if Trim(FieldByName('MAKER_NAME').AsString) = '' then begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuBeforePost: MAKER_NAME is empty. Aborting post.');
{$ENDIF}
        MessageDlg(MSG_JP_000049, mtError, [mbOk], 0);
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
              := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, FS);
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
                        ', MAKER_ID=' + FieldByName('MAKER_ID').AsString +
                        ', MAKER_NAME=' + FieldByName('MAKER_NAME').AsString +
                        ', DISABLED=' + FieldByName('DISABLED').AsString +
                        ', ENTRY_DT=' + DateTimeToStr(FieldByName('ENTRY_DT').AsDateTime, LFS) +
                        ', UPDATE_DT=' + DateTimeToStr(FieldByName('UPDATE_DT').AsDateTime, LFS));
{$ENDIF}
    end;
  end;
  with AQu do begin
{$IFDEF Debug}
    LazLogger.DebugLn('AQuBeforePost: AQu.Active=' + BoolToStr(AQu.Active, True) +
                      ', AQu.State=' + DataSetStateToStr(State) +
                      ', MAKER_NAME raw=' + FieldByName('MAKER_NAME').AsString +
                      ', Trimmed=' + Trim(FieldByName('MAKER_NAME').AsString));
{$ENDIF}
  end;
end;

procedure TFrmEntryMaker.AQuBeforeScroll(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeScroll: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryMaker.DBEdtMakerIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with Defs do begin
      with DBEdtMakerID do begin
        if Text <> '' then begin
          SetMakerID(StrToInt(Text));
        end else begin
          SetMakerID(0);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.DBEdtMakerIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmEntryMaker.DBEdtMakerIDExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmEntryMaker.DBEdtMakerNameChange(Sender: TObject);
begin
  with Defs do begin
    if Not FDoCommit then begin
      SetMakerName(DBEdtMakerName.Text);
    end;
  end;
end;

procedure TFrmEntryMaker.DBEdtMakerNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.DBEdtMakerNameExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.DBCBDisabledChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
      DBCBDisabled.Checked := True;
    end else begin
      SetDisabled(False);
      DBCBDisabled.Checked := False;
    end;

    Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
  end;
end;

procedure TFrmEntryMaker.DBCBDisabledEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.DBCBDisabledExit(Sender: TObject);
begin
  Shape3.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryMaker.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
  end;

  with Defs do begin
    // Restore value of previous screen
    SetMakerID(FMakerID);

    if GetEntryMaker = 0 then begin
      FrmEntryBrandName         := TFrmEntryBrandName.Create(Application);
      FrmEntryBrandName.Visible := True;
      SetEntryMaker(999);
    end else if GetEntryMaker = 1 then begin
      FrmAddDetail              := TFrmAddDetail.Create(Application);
      FrmAddDetail.Visible      := True;
    end else if GetEntryMaker = 2 then begin
      FrmEditDetail             := TFrmEditDetail.Create(Application);
      FrmEditDetail.Visible     := True;
    end;
  end;

  CloseAction               := caFree;
  FrmEntryMaker             := nil;
end;

procedure TFrmEntryMaker.FormCreate(Sender: TObject);
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

procedure TFrmEntryMaker.FormShow(Sender: TObject);
begin
  Self.Width      := 599;

  Self.KeyPreview := True;

  Self.Color      := RGB(112, 168, 175);
  PnlInsert.Color := RGB( 72, 122, 129);
  PnlCancel.Color := RGB( 72, 122, 129);
  PnlSave.Color   := RGB( 72, 122, 129);
  PnlGoBack.Color := RGB( 72, 122, 129);

  with Defs do begin
    FMakerID      := GetMakerID;
  end;

  { Debug }
  //Self.Width      := 767;
end;

procedure TFrmEntryMaker.FormActivate(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with ACn do begin
            if Not Connected then
              Open;
          end;

          with ATr do begin
            if Not Active then begin
              StartTransaction;
            end;
          end;

          OpenSelectQuery(ADS, AQu, SQL_20130001);
          ProcInsert(Sender);
        end;
      end;

      ADBGrid.AutoAdjustColumns;
      Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  finally
  end;
end;

function TFrmEntryMaker.ShiftStateToStr(Shift: TShiftState): string;
begin
  Result := '';
  if ssShift in Shift then Result := Result + 'Shift+';
  if ssAlt in Shift then Result   := Result + 'Alt+';
  if ssCtrl in Shift then Result  := Result + 'Ctrl+';
  if Result = '' then Result      := 'None';
end;

procedure TFrmEntryMaker.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TFrmEntryMaker.TimerTimer(Sender: TObject);
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

