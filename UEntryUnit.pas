unit UEntryUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, LCLIntf, ActnList,
  UDBNavi, UDBG, Types, LMessages;

type

  { TFrmEntryUnit }

  TFrmEntryUnit = class(TForm)
    ADBGrid: TDBG;
    ADS          : TDataSource;
    AQu          : TSQLQuery;
    ADSNextID    : TDataSource;
    AQuNextID    : TSQLQuery;
   { ActionLists }
    ActionList   : TActionList;
    ActCancel    : TAction;
    ActGoBack    : TAction;
    ActInsert    : TAction;
    ActSave      : TAction;
    ADBNavi      : TDBNavi;
    DBCBDisabled : TDBCheckBox;
    DBEdtUnitID  : TDBEdit;
    DBEdtUnit    : TDBEdit;
    LblDisabled1 : TLabel;
    LblDisabled2 : TLabel;
    LblDisabled3 : TLabel;
    LblUnitID1   : TLabel;
    LblUnitID2   : TLabel;
    LblUnit1     : TLabel;
    LblUnit2     : TLabel;
    BtnInsert    : TPanel;
    BtnCancel    : TPanel;
    BtnSave      : TPanel;
    BtnGoBack    : TPanel;
    Panel1       : TPanel;
    Panel2       : TPanel;
    Panel3       : TPanel;
    Panel4       : TPanel;
    PnlCancel    : TPanel;
    PnlSave      : TPanel;
    PnlGoBack    : TPanel;
    PnlInsert    : TPanel;
    Shape1       : TShape;
    Shape2       : TShape;
    Shape3       : TShape;
    Timer        : TTimer;
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
    procedure DBEdtUnitChange(Sender: TObject);
    procedure DBEdtUnitEnter(Sender: TObject);
    procedure DBEdtUnitExit(Sender: TObject);
    procedure DBEdtUnitIDChange(Sender: TObject);
    procedure DBEdtUnitIDEnter(Sender: TObject);
    procedure DBEdtUnitIDExit(Sender: TObject);
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
    FUnitID                   : Integer;
    FUnit                     : String;
    FDisabled                 : Boolean;
    procedure BackupValues;
    function CannotFocusedNavButton: Boolean;
    function DataSetStateToStr(State: TDataSetState): string;
    procedure EnableTimer(Data: PtrInt);
    procedure ProcInsert(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure InsertMouseOver(NewColor: TColor);
    procedure SaveMouseOver(NewColor: TColor);
    function ShiftStateToStr(Shift: TShiftState): string;
    function GetUnit: String;
    procedure SetUnit(ArgUnit: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
  public

  end;

var
  FrmEntryUnit: TFrmEntryUnit;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UManageDetails,
  UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmEntryUnit }

procedure TFrmEntryUnit.BackupValues;
begin
  with Defs do begin
    with DBEdtUnitID do begin
      if Text <> '' then begin
        SetUnitID(StrToInt(Text));
      end else begin
        SetUnitID(0);
      end;
    end;

    SetUnit(DBEdtUnit.Text);

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

function TFrmEntryUnit.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

function TFrmEntryUnit.DataSetStateToStr(State: TDataSetState): string;
begin
  case State of
    dsInactive: Result := 'dsInactive';
    dsBrowse: Result := 'dsBrowse';
    dsEdit: Result := 'dsEdit';
    dsInsert: Result := 'dsInsert';
    dsSetKey: Result := 'dsSetKey';
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

procedure TFrmEntryUnit.EnableTimer(Data: PtrInt);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('EnableTimer: Enabling Timer');
{$ENDIF}
  Timer.Enabled := True;
end;

procedure TFrmEntryUnit.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        if State in [dsInsert, dsEdit] then begin
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20150001);
        end;

        if RecordCount = 0 then begin
          DBEdtUnit.SetFocus;
        end else begin
          ADBNavi.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.ProcInsert(Sender: TObject);
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
            OpenSelectQuery(ADS, AQu, SQL_20150001);
          end;

          Insert;

          DBEdtUnit.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.ProcSave(Sender: TObject);
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

            // Validate UNIT before setting Params
            if Trim(GetUnit) = '' then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: UNIT is empty. Aborting save.');
{$ENDIF}
              MessageDlg(MSG_JP_000051, mtError, [mbOK], 0);
              Exit;
            end;
            try
              SQL.Text := SQL_20150003;
              with Params do begin
                ParamByName('pUnitID').AsInteger := GetUnitID;
                ParamByName('pUnit').AsString := GetUnit;
                ParamByName('pOrderID').AsInteger := GetUnitID;
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
                                ', UNIT_ID=' + FieldByName('UNIT_ID').AsString +
                                ', UNIT=' + FieldByName('UNIT').AsString +
                                ', ORDER_ID=' + FieldByName('ORDER_ID').AsString +
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

            OpenSelectQuery(ADS, AQu, SQL_20150001);

            if Not Active then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: Failed to reopen AQu after ApplyUpdates');
{$ENDIF}
              raise Exception.Create('Failed to reopen dataset after ApplyUpdates');
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
    Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
  end;
end;

procedure TFrmEntryUnit.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryUnit.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryUnit.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryUnit.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

function TFrmEntryUnit.GetUnit: String;
begin
  Result := FUnit;
end;

procedure TFrmEntryUnit.SetUnit(ArgUnit: String);
begin
  FUnit := ArgUnit;
end;

function TFrmEntryUnit.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryUnit.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryUnit.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);

  ADBNavi.SetFocus;
  ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
end;

procedure TFrmEntryUnit.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryUnit.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryUnit.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryUnit.ADBGridDblClick(Sender: TObject);
begin
  AQu.Edit;
end;

procedure TFrmEntryUnit.ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
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
          if DBEdtUnit.Text <> '' then begin
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

procedure TFrmEntryUnit.ADBGridMouseWheel(Sender: TObject; Shift: TShiftState;
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
        if DBEdtUnit.Text <> '' then begin
          Msg := MSG_JP_000043;
        end;

        if AQu.RecordCount > 0 then begin
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

procedure TFrmEntryUnit.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryUnit.ADBGridWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
var
  Msg           : string = MSG_JP_000042;
begin
  if FSuppressRecursiveEvent then begin
    Exit;
  end;

  if (AQu.State in [dsInsert, dsEdit])
      And (Message.ScrollCode
        in [SB_LINEUP, SB_LINEDOWN, SB_PAGEUP, SB_PAGEDOWN]) then begin
    FSuppressRecursiveEvent := True;
    try
      if DBEdtUnit.Text <> '' then begin
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

procedure TFrmEntryUnit.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
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

procedure TFrmEntryUnit.ADBNaviKeyUp(Sender: TObject; var Key: Word;
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

procedure TFrmEntryUnit.AQuAfterClose(DataSet: TDataSet);
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

procedure TFrmEntryUnit.AQuAfterInsert(DataSet: TDataSet);
begin
  with Defs do begin
    with AQuNextID do begin
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-1: Before Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;
      OpenSelectQuery(ADSNextID, AQuNextID, SQL_20150002);
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-2: After Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;
      AQu.FieldByName('UNIT_ID').AsInteger  := FieldByName('NEXT_ID').AsInteger;
      AQu.FieldByName('DISABLED').AsBoolean := False;

      with CommonDB do begin
        CloseQuery(AQuNextID);
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.AQuAfterPost(DataSet: TDataSet);
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
          OpenSelectQuery(ADS, AQu, SQL_20130001);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.AQuAfterScroll(DataSet: TDataSet);
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
        if DBEdtUnit.Text <> '' then begin
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
  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.AQuBeforeClose(DataSet: TDataSet);
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

procedure TFrmEntryUnit.AQuBeforeOpen(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeOpen: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryUnit.AQuBeforePost(DataSet: TDataSet);
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
      if Trim(FieldByName('UNIT').AsString) = '' then begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuBeforePost: UNIT is empty. Aborting post.');
{$ENDIF}
        MessageDlg(MSG_JP_000051, mtError, [mbOk], 0);
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
      // Log Param values for debugging
{$IFDEF Debug}
      LazLogger.DebugLn('AQuBeforePost: UNIT_ID=' + FieldByName('UNIT_ID').AsString +
                        ', UNIT=' + FieldByName('UNIT').AsString +
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
                      ', UNIT raw=' + FieldByName('UNIT').AsString +
                      ', Trimmed=' + Trim(FieldByName('UNIT').AsString));
{$ENDIF}
  end;
end;

procedure TFrmEntryUnit.AQuBeforeScroll(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeScroll: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryUnit.DBEdtUnitIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with Defs do begin
      with DBEdtUnitID do begin
        if Text <> '' then begin
          SetUnitID(StrToInt(Text));
        end else begin
          SetUnitID(0);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.DBEdtUnitIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.DBEdtUnitIDExit(Sender: TObject);
begin
  Shape1.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.DBEdtUnitChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetUnit(DBEdtUnit.Text);
  end;
end;

procedure TFrmEntryUnit.DBEdtUnitEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.DBEdtUnitExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.DBCBDisabledChange(Sender: TObject);
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

procedure TFrmEntryUnit.DBCBDisabledEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.DBCBDisabledExit(Sender: TObject);
begin
  Shape3.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
  end;

  with Defs do begin
    // Restore value of previous screen
    SetUnitID(FUnitID);

    if GetEntryUnit = 0 then begin
      FrmManageDetails         := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible := True;
    end else if GetEntryUnit = 1 then begin
      FrmAddDetail             := TFrmAddDetail.Create(Application);
      FrmAddDetail.Visible     := True;
    end else if GetEntryUnit = 2 then begin
      FrmEditDetail            := TFrmEditDetail.Create(Application);
      FrmEditDetail.Visible    := True;
    end;
  end;

  CloseAction                  := caFree;
  FrmEntryUnit                 := nil;
end;

procedure TFrmEntryUnit.FormCreate(Sender: TObject);
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

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryUnit.FormShow(Sender: TObject);
begin
  Self.Width      := 594;

  Self.KeyPreview := True;

  Self.Color      := RGB(112, 168, 175);
  PnlInsert.Color := RGB( 72, 122, 129);
  PnlCancel.Color := RGB( 72, 122, 129);
  PnlSave.Color   := RGB( 72, 122, 129);
  PnlGoBack.Color := RGB( 72, 122, 129);

  with Defs do begin
    FUnitID       := GetUnitID;
  end;

  { Debug }
  //Self.Width      := 776;
end;

procedure TFrmEntryUnit.FormActivate(Sender: TObject);
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

          OpenSelectQuery(ADS, AQu, SQL_20150001);
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

function TFrmEntryUnit.ShiftStateToStr(Shift: TShiftState): string;
begin
  Result                          := '';
  if ssShift in Shift then Result := Result + 'Shift+';
  if ssAlt in Shift then Result   := Result + 'Alt+';
  if ssCtrl in Shift then Result  := Result + 'Ctrl+';
  if Result = '' then Result      := 'None';
end;

procedure TFrmEntryUnit.FormKeyUp(Sender: TObject; var Key: Word;
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
    Key := 0; // Prevent further processing
  end;
  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryUnit.TimerTimer(Sender: TObject);
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

