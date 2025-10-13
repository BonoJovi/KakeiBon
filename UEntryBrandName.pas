unit UEntryBrandName;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, LCLType, ActnList,
  UDBNavi, UDBG, Types, LMessages;

type

  { TFrmEntryBrandName }

  TFrmEntryBrandName = class(TForm)
    ADBGrid          : TDBG;
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
    ADBNavi          : TDBNavi;
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
    FSkipFirstProcess         : Boolean;
    FGuidePanels              : Array[0..3] of TPanel;
    FNavigateBtn              : TNavigateBtn;
    FDBGridClicked            : Boolean;
    FDoCommit                 : Boolean;
    FReOpenDS                 : Boolean;
    FSuppressRecursiveEvent   : Boolean;
    FGoFirst                  : Boolean;
    FBrandNameID              : Integer;
    FMakerID                  : Integer;
    procedure BackupValues;
    function CanNotFocusedNavButton: Boolean;
    function DataSetStateToStr(State: TDataSetState): string;
    procedure EnableTimer(Data: PtrInt);
    procedure ProcCancel(Sender: TObject);
    procedure ProcEntryMaker(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure EntryMakerMouseOver(NewColor: TColor);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure InsertMouseOver(NewColor: TColor);
    procedure SaveMouseOver(NewColor: TColor);
    function ShiftStateToStr(Shift: TShiftState): string;
  public

  end;

var
  FrmEntryBrandName: TFrmEntryBrandName;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess,
  UAddDetail, UEditDetail, UEntryMaker;

{$R *.lfm}

{ TFrmEntryBrandName }

procedure TFrmEntryBrandName.BackupValues;
begin
  with Defs do begin
    if Not VarIsNull(DBLCBMaker.KeyValue) then begin
      SetMakerID(VarToInt(DBLCBMaker.KeyValue));
    end;
    with DBEdtBrandNameID do begin
      if (Text <> '')
        And (StrToInt(Text) > 0) then begin
          SetBrandNameID(StrToInt(Text));
      end else begin
        SetBrandNameID(0);
      end;
    end;
    SetBrandName(DBEdtBrandName.Text);

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

function TFrmEntryBrandName.CanNotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

function TFrmEntryBrandName.DataSetStateToStr(State: TDataSetState): string;
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

procedure TFrmEntryBrandName.EnableTimer(Data: PtrInt);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('EnableTimer: Enabling Timer');
{$ENDIF}
  Timer.Enabled := True;
end;

procedure TFrmEntryBrandName.ProcCancel(Sender: TObject);
var
  LMakerID     : Integer;
  LBrandNameID : Integer;
  LIncDecNum   : Integer;
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        if State in [dsInsert, dsEdit] then begin
          ATr.Rollback;

          OpenSelectQueryWithMakerID(
            ADS, AQu, SQL_20140001, GetMakerID);

          OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
          SetKeyValToDBLCB(
            DBLCBMaker, DBEdtMakerID, GetMakerID);
        end else if State = dsEdit then begin
          ATr.Rollback;

          LMakerID     := GetMakerID;
          with Defs do begin
            OpenSelectQueryWithMakerIDAndBrandNameID(
              ADS, AQu, SQL_20140001, LMakerID, GetBrandNameID);
          end;

          SetMakerID(LMakerID);
{$IFDEF Debug}
          LazLogger.DebugLn('ProcCancel: BRAND_NAME_ID=' +
                            IntToStr(GetBrandNameID));
{$ENDIF}

          OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
          SetKeyValToDBLCB(
            DBLCBMaker, DBEdtMakerID, GetMakerID);
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

procedure TFrmEntryBrandName.ProcEntryMaker(Sender: TObject);
begin
  with Defs do begin
    SetEntryMaker(0);
    Close;
  end;
end;

procedure TFrmEntryBrandName.ProcInsert(Sender: TObject);
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

        if Not VarIsNull(DBLCBMaker.KeyValue) then begin
          ATr.Rollback;
          with ATr do begin
            if Not Active then begin
              StartTransaction;
            end;
          end;

          with AQuMaker do begin
            OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130001);
            DBLCBMaker.KeyValue := GetMakerID;
          end;

          with AQu do begin
            if Not Active then begin
              if GetMakerID > 0 then begin
                OpenSelectQueryWithMakerID(ADS, AQu, SQL_20140001, GetMakerID);
                Insert;
              end else begin
                SetMakerID(1);
                OpenSelectQueryWithMakerID(ADS, AQu, SQL_20140001, GetMakerID);
                Insert;
              end;
              FSkipFirstProcess := True;
            end;
          end;
        end else begin
          with AQu do begin
            Insert;
            FSkipFirstProcess := True;
          end;
        end;

        DBEdtUserID.Text  := IntToStr(GetUID);
        DBEdtMakerID.Text := IntToStr(GetMakerID);

        DBEdtBrandName.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ProcSave(Sender: TObject);
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

            //Validate BRAND_NAME before setting fields
            if Trim(GetBrandName) = '' then begin
{$IFDEF Debug}
              LazLogger.DebugLn('ProcSave: BRAND_NAME is empty. Aborting save.');
{$ENDIF}
              MessageDlg(MSG_JP_000052, mtError, [mbOK], 0);
              Exit;
            end;
            try
              SQL.Text := SQL_20140005;
              with Params do begin
                ParamByName('pUserID').AsInteger := GetUID;
                ParamByName('pMakerID').AsInteger := GetMakerID;
                ParamByName('pBrandNameID').AsInteger := GetBrandNameID;
                ParamByName('pBrandName').AsString := GetBrandName;
                ParamByName('pEndOfSales').AsBoolean := GetEndOfSales;
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
                                ', BRAND_NAME_ID=' + FieldByName('BRAND_NAME_ID').AsString +
                                ', BRAND_NAME=' + FieldByName('BRAND_NAME').AsString +
                                ', END_OF_SALES=' + FieldByName('END_OF_SALES').AsString +
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

            OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130001);
            SetKeyValToDBLCB(DBLCBMaker, DBEdtMakerID, GetMakerID);

            OpenSelectQueryWithMakerID(
              ADS, AQu, SQL_20140001, GetMakerID);

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

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnEntryMakerEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clSkyBlue);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnEntryMakerExit(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnGoBackEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnInsertEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnSaveEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
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

procedure TFrmEntryBrandName.ADBGridDblClick(Sender: TObject);
begin
  AQu.Edit;
end;

procedure TFrmEntryBrandName.ADBGridMouseDown(Sender: TObject;
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

procedure TFrmEntryBrandName.ADBGridMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  Msg          : string = MSG_JP_000042;
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

procedure TFrmEntryBrandName.ADBGridSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryBrandName.ADBGridWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
var
  Msg          : string = MSG_JP_000042;
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
    if (AQu.State in [dsInsert, dsEdit])
        And (Message.ScrollCode in [SB_LINEUP, SB_LINEDOWN, SB_PAGEUP, SB_PAGEDOWN]) then begin
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
    end;
  finally
    ADBGrid.Tag := 0;
  end;

  ADBGrid.AutoAdjustColumns;
  FDBGridClicked := False;
end;

procedure TFrmEntryBrandName.ADBNaviBtnClick(Sender: TObject;
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

procedure TFrmEntryBrandName.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    BtnGoBack.SetFocus;
  end else if (Key = VK_TAB) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if CannotFocusedNavButton then begin
        DBLCBMaker.SetFocus;
      end else begin
        ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.AQuAfterClose(DataSet: TDataSet);
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

procedure TFrmEntryBrandName.AQuAfterInsert(DataSet: TDataSet);
begin
  with Defs do begin
    with AQuNextID do begin
      with CommonDB do begin
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-1: Before Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
        OpenSelectQueryWithMakerID(ADSNextID, AQuNextID, SQL_20140003, GetMakerID);
{$IFDEF Debug}
        LazLogger.DebugLn('AQuAfterInsert-2: After Calling OpenSelectQuery : ATr.Active=' + BoolToStr(ATr.Active, True));
{$ENDIF}
      end;

      DBEdtBrandNameID.Text := FieldByName('NEXT_ID').AsAnsiString;

      AQu.FieldByName('MAKER_ID').AsInteger  := GetMakerID;
      AQu.FieldByName('BRAND_NAME_ID').AsInteger  := FieldByName('NEXT_ID').AsInteger;
      AQu.FieldByName('END_OF_SALES').AsBoolean := False;
      AQu.FieldByName('DISABLED').AsBoolean := False;

      with CommonDB do begin
        CloseQuery(AQuNextID);
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.AQuAfterPost(DataSet: TDataSet);
var
  ADSM: TDataSource;
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
          OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130001);
          SetKeyValToDBLCB(DBLCBMaker, DBEdtMakerID, GetMakerID);
          OpenSelectQuery(ADS, AQu, SQL_20140001);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.AQuAfterScroll(DataSet: TDataSet);
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

  //======================================================
  try
    if AQu.State = dsInsert then begin
      FSuppressRecursiveEvent := True;
      try
        if Not FDoCommit then begin
          if DBEdtBrandName.Text <> '' then begin
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
  finally
    ADBGrid.Tag := 0;
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

procedure TFrmEntryBrandName.AQuBeforeClose(DataSet: TDataSet);
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

procedure TFrmEntryBrandName.AQuBeforeOpen(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeOpen: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
end;

procedure TFrmEntryBrandName.AQuBeforePost(DataSet: TDataSet);
var
  LFS: TFormatSettings;
begin
  with Defs do begin
    LFS := GetFS;
    with AQu do begin
      FieldByName('USER_ID').AsInteger := GetUID;
      FieldByName('BRAND_NAME').AsAnsiString := GetBrandName;
      if FieldByName('END_OF_SALES').AsAnsiString = '' then begin
        FieldByName('END_OF_SALES').AsBoolean := False;
      end;
      if FieldByName('DISABLED').AsAnsiString = '' then begin
        FieldByName('DISABLED').AsBoolean := False;
      end;
      if State in [dsInsert, dsEdit] then begin
        // Check BRAND_NAME And abort posting if empty
        if FDoCommit then begin
          if Trim(FieldByName('BRAND_NAME').AsString) = '' then begin
{$IFDEF Debug}
            LazLogger.DebugLn('AQuBeforePost: BRAND_NAME is empty. Aborting post.');
{$ENDIF}
            MessageDlg(MSG_JP_000052, mtError, [mbOk], 0);
            Abort; // Cancel the Post operation without affecting the transaction
          end;
        end else begin
          Abort;
        end;
        try
          if State in [dsInsert] then begin
            if FieldByName('ENTRY_DT').IsNull then begin
              FieldByName('ENTRY_DT').AsAnsiString
                := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, LFS);
            end;
          end else if State in [dsEdit] then begin
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
      end;
      // Log field values for debugging
{$IFDEF Debug}
      LazLogger.DebugLn('AQuBeforePost: USER_ID=' + FieldByName('USER_ID').AsString +
                        ', MAKER_ID=' + FieldByName('MAKER_ID').AsString +
                        ', BRAND_NAME_ID=' + FieldByName('BRAND_NAME_ID').AsString +
                        ', BRAND_NAME=' + FieldByName('BRAND_NAME').AsString +
                        ', END_OF_SALES=' + FieldByName('END_OF_SALES').AsString +
                        ', DISABLED=' + FieldByName('DISABLED').AsString +
                        ', ENTRY_DT=' + DateTimeToStr(FieldByName('ENTRY_DT').AsDateTime, LFS) +
                        ', UPDATE_DT=' + FieldByName('UPDATE_DT').AsString);
{$ENDIF}
{$IFDEF Debug}
      LazLogger.DebugLn('AQuBeforePost: AQu.Active=' + BoolToStr(AQu.Active, True) +
                        ', AQu.State=' + DataSetStateToStr(State) +
                        ', BRAND_NAME raw=' + FieldByName('BRAND_NAME').AsString +
                        ', Trimmed=' + Trim(FieldByName('BRAND_NAME').AsString));
{$ENDIF}
    end;
  end;
end;

procedure TFrmEntryBrandName.AQuBeforeScroll(DataSet: TDataSet);
begin
{$IFDEF Debug}
  LazLogger.DebugLn('AQuBeforeScroll: AQu.Active=' + BoolToStr(AQu.Active, True) +
                    ', AQu.State=' + DataSetStateToStr(AQu.State));
{$ENDIF}
  FSkipFirstProcess := True
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
          SetMakerID(LMakerID);

          CloseQuery(AQu);
          CloseQuery(AQuMaker);

          with AQu do begin
            ATr.Rollback;
            ATr.StartTransaction;

            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQueryWithMakerID(
              ADS, AQu, SQL_20140001, GetMakerID);

            Insert;
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

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBLCBMakerExit(Sender: TObject);
begin
  Shape1.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with CommonDB do begin
      with Defs do begin
        with AQu do begin
          SetBrandNameID(FieldByName('BRAND_NAME_ID').AsInteger);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBEdtBrandNameEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  with AQu do begin
    if State = dsBrowse then begin
      Edit;
    end;
  end;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBEdtBrandNameExit(Sender: TObject);
begin
  with Defs do begin
    SetBrandName(DBEdtBrandName.Text);
  end;

  Shape3.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBCBEndOfSalesEnter(Sender: TObject);
begin
  Shape4.Visible := True;

  with AQu do begin
    if State = dsBrowse then begin
      Edit;
    end;
  end;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBCBEndOfSalesExit(Sender: TObject);
begin
  Shape4.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBCBDisabledEnter(Sender: TObject);
begin
  Shape5.Visible := True;

  with AQu do begin
    if State = dsBrowse then begin
      Edit;
    end;
  end;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.DBCBDisabledExit(Sender: TObject);
begin
  Shape5.Visible := False;

  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
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
  //Self.Width := 813;
end;

procedure TFrmEntryBrandName.FormActivate(Sender: TObject);
var
  i        : Integer;
  LMakerID : Integer = 0;
begin
  with CommonDB do begin
    with Defs do begin
      with ATr do begin
        if Not Active then begin
          StartTransaction;
        end;
      end;

      OpenSelectQueryWithMakerID(ADS, AQu, SQL_20140001, LMakerID);

      OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
      DBEdtUserID.Text := IntToStr(GetUID);
      with AQuMaker do begin
        LMakerID       := FieldByName('MAKER_ID').AsInteger;
      end;

      CloseQuery(AQu);
      OpenSelectQueryWithMakerID(ADS, AQu, SQL_20140001, LMakerID);

      with AQuMaker do begin
        ProcInsert(Self);

        if (VarIsNull(DBLCBMaker.KeyValue))
            Or (DBLCBMaker.KeyValue = 0) then begin
          DBLCBMaker.KeyValue := 1;
          DBLCBMakerChange(Self);
        end;
      end;
    end;
  end;

  with Defs do begin
    SetMakerID(DBLCBMaker.KeyValue);
  end;

  DBLCBMaker.SetFocus;

  ADBGrid.AutoAdjustColumns;
  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

function TFrmEntryBrandName.ShiftStateToStr(Shift: TShiftState): string;
begin
  Result                          := '';
  if ssShift in Shift then Result := Result + 'Shift+';
  if ssAlt in Shift then Result   := Result + 'Alt+';
  if ssCtrl in Shift then Result  := Result + 'Ctrl+';
  if Result = '' then Result      := 'None';
end;

procedure TFrmEntryBrandName.FormKeyUp(Sender: TObject; var Key: Word;
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
    Key := 0; // Prevent further processing
  end;
  Application.QueueAsyncCall(@EnableTimer, 0); // Cross-platform timer enabling
end;

procedure TFrmEntryBrandName.TimerTimer(Sender: TObject);
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

  if FReOpenDS And Not FDoCommit then begin
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

