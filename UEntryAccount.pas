unit UEntryAccount;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, Variants, LazUTF8, SysUtils, DB, SQLDB, SQLite3Conn,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, LCLIntf, LCLType, ActnList,
  StdCtrls, DBCtrls, DBGrids, UDBNavi, DBDateTimePicker;

type

  { TFrmEntryAccount }

  TFrmEntryAccount = class(TForm)
    ADS                 : TDataSource;
    AQu                 : TSQLQuery;
    ADSNextID           : TDataSource;
    AQuNextID           : TSQLQuery;
    { ActionLists }
    ActionList          : TActionList;
    ActInsert           : TAction;
    ActCancel           : TAction;
    ActSave             : TAction;
    ActGoBack           : TAction;
    ADBGrid             : TDBGrid;
    ADBNavi             : TDBNavi;
    DBCBDisabled        : TDBCheckBox;
    DBDTPEntryDT        : TDBDateTimePicker;
    DBDTPUpdateDT       : TDBDateTimePicker;
    DBEdtPhoneNum       : TDBEdit;
    DBEdtOpeningBalance : TDBEdit;
    DBEdtCurrentBalance : TDBEdit;
    DBEdtAccountID      : TDBEdit;
    DBEdtBrandName      : TDBEdit;
    DBEdtSubName        : TDBEdit;
    LblAccountID1       : TLabel;
    LblOpeningBalance   : TLabel;
    LblCurrentBalance   : TLabel;
    LblDisabled1        : TLabel;
    LblDisabled2        : TLabel;
    LblAccountID2       : TLabel;
    LblDisabled3        : TLabel;
    LblSubName1         : TLabel;
    LblSubName2         : TLabel;
    LblSubName3         : TLabel;
    LblBrandName1       : TLabel;
    LblBrandName2       : TLabel;
    LblPhoneNumber3     : TLabel;
    LblPhoneNumber2     : TLabel;
    LblPhoneNumber1     : TLabel;
    LblPhoneNumber4     : TLabel;
    BtnInsert           : TPanel;
    BtnCancel           : TPanel;
    BtnSave             : TPanel;
    BtnGoBack           : TPanel;
    Panel1              : TPanel;
    Panel2              : TPanel;
    Panel3              : TPanel;
    Panel4              : TPanel;
    PnlCancel           : TPanel;
    PnlSave             : TPanel;
    PnlGoBack           : TPanel;
    PnlInsert           : TPanel;
    Shape1              : TShape;
    Shape2              : TShape;
    Shape3              : TShape;
    Shape4              : TShape;
    Shape5              : TShape;
    Shape6              : TShape;
    Shape7              : TShape;
    Timer               : TTimer;
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
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
    procedure ActInsertExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ADBGridSelectEditor(
      Sender: TObject; Column: TColumn; var Editor: TWinControl);
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
    FTab              : Boolean;
    FGuidePanels      : Array[0..3] of TPanel;
    FCurrentComponent : TObject;
    FDoCommit       : Boolean;
    FReOpenDS       : Boolean;
    FInsert         : Boolean;
    FAccountID      : Variant;
    FBrandName      : String;
    FSubName        : String;
    FPhoneNum       : String;
    FOpeningBalance : Integer;
    FCurrentBalance : Integer;
    FDisabled       : Boolean;
    procedure BackupValues;
    function GetAccountID: Variant;
    procedure SetAccountID(AccountID: Variant);
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
    property AccountID: Variant read GetAccountID write SetAccountID;
    property BrandName: String read GetBrandName write SetBrandName;
    property SubName: String read GetSubName write SetSubName;
    property PhoneNum: String read GetPhoneNum write SetPhoneNum;
    property OpeningBalance: Integer read GetOpeningBalance write SetOpeningBalance;
    property CurrentBalance: Integer read GetCurrentBalance write SetCurrentBalance;
    property Disabled: Boolean read GetDisabled write SetDisabled;
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
      if Text <> '' then begin;
        SetAccountID(Text);
      end else begin
        SetAccountID(Null);
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

procedure TFrmEntryAccount.ProcInsert(Sender: TObject);
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

          if RecordCount > 0 then begin
            Insert;
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
  FCurrentComponent := Sender;
end;

procedure TFrmEntryAccount.DBCBDisabledEnter(Sender: TObject);
begin
  Shape7.Visible := True;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryAccount.ADBGridEnter(Sender: TObject);
var
  LDBEdit : TDBEdit;
  LDBCB   : TDBCheckBox;
  LPanel  : TPanel;
begin
  if FInsert then begin;
    ProcCancel(Sender);
  end;

  if FCurrentComponent is TDBNavi then begin
    ADBNavi.SetFocus;
  end else if FCurrentComponent is TDBEdit then begin
    LDBEdit := FCurrentComponent as TDBEdit;
    LDBEdit.SetFocus;
  end else if FCurrentComponent is TDBCheckBox then begin
    LDBCB := FCurrentComponent as TDBCheckBox;
    LDBCB.SetFocus;
  end else if FCurrentComponent is TPanel then begin
    LPanel := FCurrentComponent as TPanel;
    LPanel.SetFocus;
  end;
end;

procedure TFrmEntryAccount.ADBNaviClick(Sender: TObject; Button: TDBNavButtonType
  );
begin
  if FInsert then begin
    ProcCancel(Sender);
  end;

  with CommonDB do begin
    with Defs do begin
      if (Button = nbFirst) or (Button = nbPrior) then begin
        if AQu.RecNo = 1  then begin
          AQu.First;
          BtnGoBack.SetFocus;
        end;
      end else if (Button = nbNext) Or (Button = nbLast) then begin
        if AQu.RecNo = AQu.RecordCount  then begin
          AQu.Last;
          DBEdtBrandName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryAccount.ADBNaviEnter(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.ADBNaviExit(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND
  );
begin
  if FTab then begin
    try
      if Screen.ActiveControl is TDBNavi then begin
        TWinControl(ADBNavi.FindNextControl(ADBNavi, True, True, True)).SetFocus;
      end;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  end;

  Timer.Enabled := True;
end;

procedure TFrmEntryAccount.DBCBDisabledExit(Sender: TObject);
begin
  Shape7.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtAccountIDExit(Sender: TObject);
begin
  Shape1.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtBrandNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtBrandNameExit(Sender: TObject);
begin
  Shape2.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtCurrentBalanceEnter(Sender: TObject);
begin
  Shape6.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtCurrentBalanceExit(Sender: TObject);
begin
  Shape6.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtOpeningBalanceEnter(Sender: TObject);
begin
  Shape5.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtOpeningBalanceExit(Sender: TObject);
begin
  Shape5.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtPhoneNumEnter(Sender: TObject);
begin
  Shape4.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtPhoneNumExit(Sender: TObject);
begin
  Shape4.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtSubNameEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.DBEdtSubNameExit(Sender: TObject);
begin
  Shape3.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        if AQu.RecordCount > 0 then begin
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20110001);
          FInsert := False;
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

            if (VarIsNull(GetAccountID)) Or (VarToStr(GetAccountID) = '') then begin
              OpenSelectQuery(ADSNextID, AQuNextID, SQL_20110003);
              LNextAccountID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              with Params do begin
                ParamByName('pAccountID').AsInteger    := LNextAccountID;
              end;
            end else begin
              with Params do begin
                ParamByName('pAccountID').AsInteger    := StrToInt(VarToStr(GetAccountID));
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

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  FCurrentComponent := Sender;
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

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  FCurrentComponent := Sender;
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

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  FCurrentComponent := Sender;
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

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryAccount.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

function TFrmEntryAccount.GetAccountID: Variant;
begin
  Result := FAccountID;
end;

procedure TFrmEntryAccount.SetAccountID(AccountID: Variant);
begin
  FAccountID := AccountID;
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

procedure TFrmEntryAccount.ADBGridSelectEditor(
  Sender: TObject; Column: TColumn; var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryAccount.DBEdtAccountIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetAccountID(DBEdtAccountID.Text);
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
  if Not FDoCommit then begin;
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

  FReOpenDS := False;
  FDoCommit := False;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryAccount.FormShow(Sender: TObject);
begin
  FrmEntryAccount.Width      := 708;

  FrmEntryAccount.KeyPreview := True;

  Color := RGB(112, 168, 175);

  PnlInsert.Color := RGB( 72, 122, 129);
  PnlCancel.Color := RGB( 72, 122, 129);
  PnlSave.Color   := RGB( 72, 122, 129);
  PnlGoBack.Color := RGB( 72, 122, 129);

  FAccountID := GetAccountID;

  { Debug }
  //FrmEntryAccount.Width      := 865;
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
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    FTab := False;
  end else begin
    FTab := True;
    if Screen.ActiveControl is TDBNavi then begin
      ADBNaviWMSetFocus(ADBNavi, ADBNavi.Handle);
    end;
  end;

  if (Key = VK_TAB) AND (ssShift in Shift) then begin
    if Screen.ActiveControl is TDBNavi then begin
      BtnGoBack.SetFocus;
    end;
    Timer.Enabled := True;
  end else begin
    Timer.Enabled := True;
  end;

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

