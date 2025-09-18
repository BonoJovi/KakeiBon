unit UEditAdmUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, SysUtils, LazUTF8, SQLDB, SQLite3Conn, DB, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, DBCtrls, DBGrids, LCLIntf,
  LCLType, LMessages, ActnList, UDBNavi;

type

  { TFrmEditAdmUser }

  TFrmEditAdmUser = class(TForm)
    ADS                : TDataSource;
    AQu                : TSQLQuery;
    { ActionLists }
    ActionList         : TActionList;
    ActCancel          : TAction;
    ActClearPaw        : TAction;
    ActSave            : TAction;
    ActQuit            : TAction;
    { Etc controls }
    ADBGrid            : TDBGrid;
    ADSUsers           : TDataSource;
    AQuUsers           : TSQLQuery;
    ADBNavi: TDBNavi;
    LblUserID          : TLabel;
    DBTextUserID       : TDBText;
    LblFromUserName    : TLabel;
    DBTextFromUserName : TDBText;
    LblUserName        : TLabel;
    LblToUserName      : TLabel;
    Panel1             : TPanel;
    Panel2             : TPanel;
    Panel3             : TPanel;
    Panel4             : TPanel;
    Shape1             : TShape;
    EdtToUserName      : TEdit;
    LblPaw             : TLabel;
    Shape2             : TShape;
    EdtPaw             : TEdit;
    LblPawConfirm      : TLabel;
    Shape3             : TShape;
    EdtPawConfirm      : TEdit;
    LblInfo            : TLabel;
    PnlClearPaw        : TPanel;
    BtnClearPaw        : TPanel;
    PnlCancel          : TPanel;
    BtnCancel          : TPanel;
    PnlSave            : TPanel;
    BtnSave            : TPanel;
    Timer              : TTimer;
    { DBGrid }
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
      procedure FormActivate(Sender: TObject);
    { Proc }
    procedure ProcClearPaw(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    { EdtToUserName }
    procedure EdtToUserNameChange(Sender: TObject);
    procedure EdtToUserNameEnter(Sender: TObject);
    procedure EdtToUserNameExit(Sender: TObject);
    { EdtPaw }
    procedure EdtPawChange(Sender: TObject);
    procedure EdtPawEnter(Sender: TObject);
    procedure EdtPawExit(Sender: TObject);
    { EdtPawConfirm }
    procedure EdtPawConfirmChange(Sender: TObject);
    procedure EdtPawConfirmEnter(Sender: TObject);
    procedure EdtPawConfirmExit(Sender: TObject);
    { BtnClearPaw }
    procedure ClearPawMouseOver(NewColor: TColor);
    procedure BtnClearPawEnter(Sender: TObject);
    procedure BtnClearPawExit(Sender: TObject);
    procedure ActClearPawExecute(Sender: TObject);
    { BtnCancel }
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    { BtnSave }
    procedure SaveMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    { ActQuit }
    procedure ActQuitExecute(Sender: TObject);
    { Form events }
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
  private
    FTab              : Boolean;
    FGuidePanels      : Array[0..3] of TPanel;
    FCurrentComponent : TObject;
    FUName            : String;
    FPaw              : String;
    function CheckMultiFields(NameField: Boolean): String;
    function CheckSQuoteInPAW: Boolean;
    function CheckSQuoteInUName: Boolean;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FrmEditAdmUser: TFrmEditAdmUser;

implementation
uses
  LazLogger, UConsts, UCommonDB, UDefs, UDBAccess, UTopMenu,
  UManageUser;

{$R *.lfm}

{ TFrmEditAdmUser }

constructor TFrmEditAdmUser.Create(TheOwner: TComponent);
  begin
  FTab := True;
  Inherited Create(TheOwner);
end;

destructor TFrmEditAdmUser.Destroy;
begin
  Inherited Destroy;
end;

function TFrmEditAdmUser.CheckMultiFields(NameField: Boolean): String;
var
  LRet: String = '';
begin
  with CommonDB do begin
    with Defs do begin
      if NameField then begin
        if Not CheckSQuoteInUName then begin
          LRet   := 'NAME = ''' + EdtToUserName.Text + '''';
        end else begin
          Result := '';
          Exit;
        end;

        if EdtPaw.Text <> '' then begin
          if EdtPaw.Text = EdtPawConfirm.Text then begin
            if CheckSQuoteInPAW then begin
              Result := '';
              Exit;
            end;
            Result := LRet + ', PAW = ''' + EdtPaw.Text + '''';
          end else begin // EdtPaw.Text <> EdtPawConfirm.Text
            ClearPaw(EdtPaw, EdtPawConfirm);
            MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
            Result := '';
          end;
        end else begin // EdtPaw.Text = ''
          if EdtPawConfirm.Text <> '' then begin
            ClearPaw(EdtPaw, EdtPawConfirm);
            MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
            Result := '';
          end else begin // EdtPawConfirm.Text = ''
            Result := LRet;
          end;
        end;
      end else begin // Not NameField
        if EdtPaw.Text <> '' then begin
          if EdtPaw.Text = EdtPawConfirm.Text then begin
            if CheckSQuoteInPAW then begin
              Result := '';
              Exit;
            end;
            Result := 'PAW = ''' + EdtPaw.Text + '''';
          end else begin // EdtPaw.Text <> EdtPawConfirm.Text
            ClearPaw(EdtPaw, EdtPawConfirm);
            MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
            Result := '';
          end;
        end else begin // EdtPaw.Text = ''
          if EdtPawConfirm.Text <> '' then begin
            ClearPaw(EdtPaw, EdtPawConfirm);
            MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
            Result := '';
          end else begin // EdtPawConfirm.Text = ''
            MessageDlg(MSG_JP_000020, mtWarning, [mbOk], 0);
            Result := '';
          end;
        end;
      end;
    end;
  end;
end;

function TFrmEditAdmUser.CheckSQuoteInPAW: Boolean;
begin
  if (Pos('''', EdtPaw.Text) > 0)
      Or (Pos('''', EdtPawConfirm.Text) > 0) then begin
    MessageDlg(MSG_JP_000019, mtWarning, [mbOk], 0);
    Result := True;
  end else begin
    Result := False;
  end;
end;

function TFrmEditAdmUser.CheckSQuoteInUName: Boolean;
begin
  if Pos('''', EdtToUserName.Text) > 0 then begin
    MessageDlg(MSG_JP_000018, mtWarning, [mbOk], 0);
    Result := True;
  end else begin
    Result := False;
  end;
end;

procedure TFrmEditAdmUser.ProcClearPaw(Sender: TObject);
begin
  with Defs do begin
    ClearPaw(EdtPaw, EdtPawConfirm);
    EdtToUserName.SetFocus;
  end;
end;

procedure TFrmEditAdmUser.ActClearPawExecute(Sender: TObject);
begin
  ProcClearPaw(Sender);
end;

procedure TFrmEditAdmUser.EdtToUserNameChange(Sender: TObject);
begin
  FUName := EdtToUserName.Text;
end;

procedure TFrmEditAdmUser.EdtToUserNameEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  Timer.Enabled := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEditAdmUser.EdtToUserNameExit(Sender: TObject);
begin
  Shape1.Visible := False;

  FCurrentComponent := Sender;
end;

procedure TFrmEditAdmUser.EdtPawChange(Sender: TObject);
begin
  FPaw := EdtPaw.Text;

  if (Length(EdtPaw.Text) = 0)
      And (Length(EdtPawConfirm.Text) = 0) then begin
    BtnClearPaw.Enabled := False;
    ActClearPaw.Enabled := False;
  end else begin
    BtnClearPaw.Enabled := True;
    ActClearPaw.Enabled := True;
  end;
end;

procedure TFrmEditAdmUser.EdtPawEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Timer.Enabled := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEditAdmUser.EdtPawExit(Sender: TObject);
begin
  Shape2.Visible := False;
end;

procedure TFrmEditAdmUser.EdtPawConfirmChange(Sender: TObject);
begin
  if (Length(EdtPaw.Text) = 0)
      And (Length(EdtPawConfirm.Text) = 0) then begin
    BtnClearPaw.Enabled := False;
    ActClearPaw.Enabled := False;
  end else begin
    BtnClearPaw.Enabled := True;
    ActClearPaw.Enabled := True;
  end;
end;

procedure TFrmEditAdmUser.EdtPawConfirmEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  Timer.Enabled := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEditAdmUser.EdtPawConfirmExit(Sender: TObject);
begin
  Shape3.Visible := False;
end;

procedure TFrmEditAdmUser.ProcCancel(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmEditAdmUser.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEditAdmUser.ProcSave(Sender: TObject);
var
  LSql           : String;
  LUserID        : String;
  LFieldAndValue : String;
  LRet           : String;
  LOriginalUName : String;
  LAdminName     : String;
  LOriginalPaw   : String;
  LDoFormShow    : Boolean = False;
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with AQuUsers do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20030002;
            with Params do begin
              ParamByName('pUName').AsAnsiString := EdtToUserName.Text;
              Open;
            end;
            if RecordCount > 0 then begin
              MessageDlg(MSG_JP_000009, mtInformation, [mbOk], 0);

              LDoFormShow := True;

              EdtToUserName.Text   := '';
              EdtPaw.Text        := '';
              EdtPawConfirm.Text := '';
            end;
          end;
        end;
      end;

      if LDoFormShow then begin
        FormShow(Self);
        LDoFormShow := False;
        Exit;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        Exit;
      end;
    end;
  finally
  end;

  with CommonDB do begin
    with Defs do begin
      try
        try
          // Initialize
          LFieldAndValue := '';
          LOriginalUName := AQu.FieldByName('NAME').AsAnsiString;

          LUserID := AQu.FieldByName('USER_ID').AsAnsiString;
          LSql    := SQL_20040003.Replace(':pUserID', LUserID);

          if EdtToUserName.Text <> '' then begin
            LRet := CheckMultiFields(True);
          end else begin
            LRet := CheckMultiFields(False);
          end;

          if LRet = '' then begin
            Exit;
          end else begin
            with AQuUsers do begin
              CloseQuery(AQuUsers);

              SQL.Text := SQL_20040001;
              with Params do begin
                ParamByName('pRole').AsInteger := ROLE_ADMIN;
                Open;
                LAdminName := FieldByName('NAME').AsAnsiString;
              end;

              CloseQuery(AQuUsers);

              SQL.Text := SQL_20040002;
              with Params do begin
                ParamByName('pRole').AsInteger    := ROLE_USER;
                ParamByName('pName').AsAnsiString := LOriginalUName;
                Open;
                LOriginalPaw := AQu.FieldByName('PAW').AsAnsiString;
              end;

              CloseQuery(AQuUsers);
            end;

            LFieldAndValue := LRet + ', UPDATE_DT = datetime(''Now'', ''+9 hours'')';

            CloseQuery(AQu);
            with AQu do begin
              SQL.Text    := LSQL.Replace(':pFieldAndValue', LFieldAndValue);
              ExecSQL;

              if ((GetUName = LAdminName)
                  Or (GetUName = LOriginalUName))
                And ((FUName <> LOriginalUName)
                  Or (FPaw <> LOriginalPaw)) then begin
                ATr.Commit;
                SetChangedUserDef(True);
              end else begin
                ATr.Rollback;
                SetChangedUserDef(False);
              end;
            end;
          end;
          Self.Close;
        except
          on E: ESQLDatabaseError do begin
            ShowMessage(E.Message);
            ATr.Rollback;
            MessageDlg(MSG_JP_000010, mtError, [mbOk], 0);
          end;
        end;
      finally
      end;
    end;
  end;
end;

procedure TFrmEditAdmUser.ActSaveExecute(Sender: TObject);
begin
  ProcSave(Sender);
end;

procedure TFrmEditAdmUser.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditAdmUser.ClearPawMouseOver(NewColor: TColor);
begin
  BtnClearPaw.Color := NewColor;
end;

procedure TFrmEditAdmUser.BtnClearPawEnter(Sender: TObject);
begin
  ClearPawMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);

  Timer.Enabled := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEditAdmUser.BtnClearPawExit(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
end;

procedure TFrmEditAdmUser.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEditAdmUser.BtnCancelEnter(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);

  Timer.Enabled := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEditAdmUser.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmEditAdmUser.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEditAdmUser.BtnSaveEnter(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);

  FCurrentComponent := Sender;
end;

procedure TFrmEditAdmUser.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEditAdmUser.ADBGridEnter(Sender: TObject);
var
  LEdit  : TEdit;
  LPanel : TPanel;
begin
  if FCurrentComponent is TEdit then begin
    LEdit := FCurrentComponent as TEdit;
    LEdit.SetFocus;
  end else if FCurrentComponent is TPanel then begin
    LPanel := FCurrentComponent as TPanel;
    LPanel.SetFocus;
  end;
end;

procedure TFrmEditAdmUser.ADBNaviClick(Sender: TObject; Button: TDBNavButtonType
  );
begin
  with CommonDB do begin
    with Defs do begin
      if (Button = nbFirst) or (Button = nbPrior) then begin
        if AQu.RecNo = 1  then begin
          AQu.First;
          BtnSave.SetFocus;
        end;
      end else if (Button = nbNext) Or (Button = nbLast) then begin
        if AQu.RecNo = AQu.RecordCount  then begin
          AQu.Last;
          EdtToUserName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEditAdmUser.ADBNaviEnter(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TFrmEditAdmUser.ADBNaviExit(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TFrmEditAdmUser.ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND
  );
begin
  if FTab then begin
    try
      if Screen.ActiveControl is TDBNavi then begin
        TWinControl(ADBNavi.FindNextControl(ADBNavi, True, True, True)).SetFocus;
      end;
    except
      on E: Exception do begin
      end;
    end;
  end;

  Timer.Enabled := True;
end;

procedure TFrmEditAdmUser.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with Defs do begin
    if (Not Assigned(FrmManageUser)) Or (FrmManageUser = nil) then begin
      FrmManageUser := TFrmManageUser.Create(Application);
    end;
    if GetChangedUserDef = False then begin
      FrmManageUser.Visible     := True;
    end else begin
      MessageDlg(MSG_JP_000021, mtInformation, [mbOk], 0);
      FrmManageUser.ActGoBackExecute(FrmTopMenu);
      SetChangedUserDef(False);
    end;
    CloseAction    := caFree;
    FrmEditAdmUser := nil;
  end;
end;

procedure TFrmEditAdmUser.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FGuidePanels[0]  := Panel1;
  FGuidePanels[1]  := Panel2;
  FGuidePanels[2]  := Panel3;
  FGuidePanels[3]  := Panel4;
end;

procedure TFrmEditAdmUser.FormShow(Sender: TObject);
begin
  Self.Width           := 665;

  Self.KeyPreview      := True;

  Self.Color           := RGB(112, 168, 175);
  PnlClearPaw.Color    := RGB( 72, 122, 129);
  PnlCancel.Color      := RGB( 72, 122, 129);
  PnlSave.Color        := RGB( 72, 122, 129);
  LblInfo.Font.Color   := RGB(255,   0,   0);

  { Debug }
  //Self.Width      := 807;
end;

procedure TFrmEditAdmUser.FormActivate(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text   := SQL_20040001;
            with Params do begin
              if GetRole = ROLE_ADMIN then begin
                SQL.Text := SQL_20040002;
                ParamByName('pName').AsAnsiString := GetUName;
              end;
              ParamByName('pRole').AsInteger      := ROLE_ADMIN;
            end;
            Open;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;

  if (Length(EdtPaw.Text) = 0)
      And (Length(EdtPawConfirm.Text) = 0) then begin
    BtnClearPaw.Enabled := False;
    ActClearPaw.Enabled := False;
  end;

  ADBGrid.AutoAdjustColumns;

  ADBNavi.SetFocus;
  Timer.Enabled := True;
end;

procedure TFrmEditAdmUser.FormKeyUp(Sender: TObject; var Key: Word;
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
      BtnSave.SetFocus;
    end;
    Timer.Enabled := True;
  end else begin
    Timer.Enabled := True;
  end;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnClearPaw' then begin
      ActClearPaw.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end;
  end;

  Key := VK_UNKNOWN;
end;

procedure TFrmEditAdmUser.TimerTimer(Sender: TObject);
var
  i            : Integer;
  LTargetIndex : Integer;
begin
  Timer.Enabled := False;
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

