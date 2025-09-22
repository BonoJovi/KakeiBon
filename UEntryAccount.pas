unit UEntryAccount;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, DBGrids, LCLIntf, ActnList,
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
    DBEdtUserID: TDBEdit;
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
    LblCurrentBalance   : TLabel;
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
    Shape7              : TShape;
    Timer               : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADBGridMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure ADBGridWMVScroll(Sender: TObject; var Message: TLMVScroll);
    procedure ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AQuAfterScroll(DataSet: TDataSet);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBEdtAccountIDEnter(Sender: TObject);
    procedure DBEdtAccountIDExit(Sender: TObject);
    procedure DBEdtBrandNameEnter(Sender: TObject);
    procedure DBEdtBrandNameExit(Sender: TObject);
    procedure DBEdtCurrentBalanceEnter(Sender: TObject);
    procedure DBEdtCurrentBalanceExit(Sender: TObject);
    procedure DBEdtOpeningBalanceEnter(Sender: TObject);
    procedure DBEdtOpeningBalanceExit(Sender: TObject);
    procedure DBEdtPhoneNumEnter(Sender: TObject);
    procedure DBEdtPhoneNumExit(Sender: TObject);
    procedure DBEdtSubNameEnter(Sender: TObject);
    procedure DBEdtSubNameExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
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
    procedure DBEdtCurrentBalanceChange(Sender: TObject);
    procedure DBEdtOpeningBalanceChange(Sender: TObject);
    procedure DBEdtPhoneNumChange(Sender: TObject);
    procedure DBEdtSubNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    //FTab               : Boolean;
    FGuidePanels       : Array[0..3] of TPanel;
    FNavigateBtn       : TNavigateBtn;
    FDBGridClicked     : Boolean;
    FDoCommit          : Boolean;
    FReOpenDS          : Boolean;
    FInsert            : Boolean;
    FAccountID         : Integer;
    FBrandName         : String;
    FSubName           : String;
    FPhoneNum          : String;
    FOpeningBalance    : Integer;
    FCurrentBalance    : Integer;
    FDisabled          : Boolean;
    procedure BackupValues;
    function CannotFocusedNavButton: Boolean;
    function GetBrandName: String;
    procedure SetBrandName(BrandName: String);
    function GetSubName: String;
    procedure SetSubName(SubName: String);
    function GetPhoneNum: String;
    procedure SetPhoneNum(PhoneNum: String);
    function GetOpeningBalance: Integer;
    procedure SetOpeningBalance(OpeningBalance: Integer);
    function GetCurrentBalance: Integer;
    procedure SetCurrentBalance(CurrentBalance: Integer);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
  public
  end;

var
  FrmEntryAccount: TFrmEntryAccount;

implementation
uses
  UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageDetails,
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
    SetCurrentBalance(DBEdtCurrentBalance.Field.AsInteger);

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

procedure TFrmEntryAccount.ProcInsert(Sender: TObject);
var
  LNextID: Integer;
begin
  if Not FInsert then begin
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

        with AQu do begin
          if Not Active then begin
            OpenSelectQuery(ADS, AQu, SQL_20110001);
          end;

          Insert;

          DBEdtUserID.Text := IntToStr(GetUID);

          if GetAccountID = 0 then begin
            OpenSelectQuery(ADSNextID, AQuNextID, SQL_20110003);
            LNextID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

            CloseQuery(AQuNextID);
            DBEdtAccountID.Text := IntToStr(LNextID);

            SetAccountID(LNextID);
          end;


          FInsert := True;

          DBCBDisabled.Checked := False;
          DBEdtBrandName.SetFocus;
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

procedure TFrmEntryAccount.DBCBDisabledEnter(Sender: TObject);
begin
  Shape7.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.ADBGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FInsert then begin
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

procedure TFrmEntryAccount.ADBGridMouseWheel(Sender: TObject;
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

procedure TFrmEntryAccount.ADBGridSelectEditor(
  Sender: TObject; Column: TColumn; var Editor: TWinControl);
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

procedure TFrmEntryAccount.ADBGridWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
begin
  if FInsert then begin
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

procedure TFrmEntryAccount.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn
  );
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

procedure TFrmEntryAccount.AQuAfterScroll(DataSet: TDataSet);
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

procedure TFrmEntryAccount.DBCBDisabledExit(Sender: TObject);
begin
  Shape7.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtAccountIDExit(Sender: TObject);
begin
  Shape1.Visible := False;

  Timer.Enabled     := True;
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

procedure TFrmEntryAccount.DBEdtCurrentBalanceEnter(Sender: TObject);
begin
  Shape6.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtCurrentBalanceExit(Sender: TObject);
begin
  Shape6.Visible := False;

  Timer.Enabled     := True;
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

procedure TFrmEntryAccount.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        if AQu.RecordCount > 0 then begin
          FInsert := False;
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20110001);
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

procedure TFrmEntryAccount.ProcSave(Sender: TObject);
var
  LNextAccountID : Integer;
  LNow           : String;
begin
  FDoCommit := True;
  try
    try
      with CommonDB do begin
        with Defs do begin
          CloseQuery(AQu);

          with AQu do begin
            SQL.Text := SQL_20110004;
            with Params do begin
              ParamByName('pUserID').AsInteger         := GetUID;
            end;

            if GetAccountID = 0 then begin
              OpenSelectQuery(ADSNextID, AQuNextID, SQL_20110003);
              LNextAccountID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              with Params do begin
                ParamByName('pAccountID').AsInteger    := LNextAccountID;
              end;
            end else begin
              with Params do begin
                ParamByName('pAccountID').AsInteger    := GetAccountID;
              end;
            end;
            with Params do begin
              ParamByName('pBrandName').AsAnsiString   := GetBrandName;
              ParamByName('pSubName').AsAnsiString     := GetSubName;
              ParamByName('pPhoneNum').AsAnsiString    := GetPhoneNum;
              ParamByName('pOpeningBalance').AsInteger := GetOpeningBalance;
              ParamByName('pCurrentBalance').AsInteger := GetCurrentBalance;
              ParamByName('pDisabled').AsBoolean       := GetDisabled;
              LNow                                     := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);;
              ParamByName('pEntryDT').AsAnsiString     := LNow;
              ParamByName('pUpdateDT').AsAnsiString    := LNow;
            end;

            ExecSQL;
            ATr.Commit;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
    FInsert := False;
  end;

  FReOpenDS     := True;
  Timer.Enabled := True;
  FDoCommit     := False;
end;

procedure TFrmEntryAccount.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
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

procedure TFrmEntryAccount.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
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

procedure TFrmEntryAccount.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
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

procedure TFrmEntryAccount.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
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

function TFrmEntryAccount.GetCurrentBalance: Integer;
begin
  Result := FCurrentBalance;
end;

procedure TFrmEntryAccount.SetCurrentBalance(CurrentBalance: Integer);
begin
  FCurrentBalance := CurrentBalance;
end;

function TFrmEntryAccount.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryAccount.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryAccount.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryAccount.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEntryAccount.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryAccount.ActGoBackExecute(Sender: TObject);
begin
  Close;
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

procedure TFrmEntryAccount.DBEdtBrandNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetBrandName(DBEdtBrandName.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtSubNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetSubName(DBEdtSubName.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtPhoneNumChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetPhoneNum(DBEdtPhoneNum.Text);
  end;
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

procedure TFrmEntryAccount.DBEdtCurrentBalanceChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if DBEdtCurrentBalance.Text = '' then begin
      SetCurrentBalance(0);
    end else begin
      SetCurrentBalance(DBEdtCurrentBalance.Field.AsInteger);
    end;
  end;
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
      FrmManageDetails    := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible  := True;
    end else if GetEntryAccount = 1 then begin
      FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
      FrmAddDetailsHeader.Visible  := True;
    end else if GetEntryAccount = 2 then begin
      FrmEditDetailsHeader := TFrmEditDetailsHeader.Create(Application);
      FrmEditDetailsHeader.Visible  := True;
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

  FReOpenDS       := False;
  FDoCommit       := False;
  FInsert         := False;
  Timer.Enabled   := False;

  FDBGridClicked  := False;

  //FTab            := FTAB_UNDEFINED;

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

procedure TFrmEntryAccount.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if (Key = VK_TAB) And (ssShift in Shift) then begin
  //  FTab := FTAB_SHIFT_TAB;
  //end else if (Key = VK_TAB) And (Not (ssShift in Shift)) then begin
  //  FTab := FTAB_TAB_ONLY;
  //end;
  Timer.Enabled := True;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnInsert' then begin
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

procedure TFrmEntryAccount.TimerTimer(Sender: TObject);
var
  i            : Integer;
  LTargetIndex : Integer;
begin
  Timer.Enabled      := False;

  if FInsert then begin
    if DBCBDisabled.State = cbChecked then begin
      AQu.FieldByName('DISABLED').AsBoolean := True;
    end else begin
      AQu.FieldByName('DISABLED').AsBoolean := False;
    end;
  end;

  if FReOpenDS then begin
    with CommonDB do begin
      with Defs do begin
        OpenSelectQuery(ADS, AQu, SQL_20110001);
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

