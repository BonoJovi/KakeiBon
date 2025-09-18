unit UEditUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Controls, DateUtils, SysUtils, LazUTF8, SQLDB, SQLite3Conn, DB,
  Forms, Graphics, Dialogs, StdCtrls, ExtCtrls, DBCtrls, DBGrids, LCLIntf,
  LCLType, LMessages, ActnList, UDBNavi;

type

  { TFrmEditUser }

  TFrmEditUser = class(TForm)
    ADBNavi: TDBNavi;
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
    procedure ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AQuAfterScroll(DataSet: TDataSet);
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
    //FTab               : Boolean;
    FGuidePanels       : Array[0..3] of TPanel;
    FNavigateBtn       : TNavigateBtn;
    FDBGridClicked     : Boolean;
    FUName             : String;
    FPaw               : String;
    function CannotFocusedNavButton: Boolean;
    function CheckMultiFields(NameField: Boolean): String;
    function CheckSQuoteInPAW: Boolean;
    function CheckSQuoteInUName: Boolean;
  public
  end;

var
  FrmEditUser: TFrmEditUser;

implementation
uses
  UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageUser;

{$R *.lfm}

{ TFrmEditUser }

function TFrmEditUser.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

function TFrmEditUser.CheckMultiFields(NameField: Boolean): String;
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

function TFrmEditUser.CheckSQuoteInPAW: Boolean;
begin
  if (Pos('''', EdtPaw.Text) > 0)
      Or (Pos('''', EdtPawConfirm.Text) > 0) then begin
    MessageDlg(MSG_JP_000019, mtWarning, [mbOk], 0);
    Result := True;
  end else begin
    Result := False;
  end;
end;

function TFrmEditUser.CheckSQuoteInUName: Boolean;
begin
  if Pos('''', EdtToUserName.Text) > 0 then begin
    MessageDlg(MSG_JP_000018, mtWarning, [mbOk], 0);
    Result := True;
  end else begin
    Result := False;
  end;
end;

procedure TFrmEditUser.ProcClearPaw(Sender: TObject);
begin
  with Defs do begin
    ClearPaw(EdtPaw, EdtPawConfirm);
    EdtToUserName.SetFocus;
  end;
end;

procedure TFrmEditUser.ActClearPawExecute(Sender: TObject);
begin
  ProcClearPaw(Sender);
end;

procedure TFrmEditUser.EdtToUserNameChange(Sender: TObject);
begin
  FUName := EdtToUserName.Text;
end;

procedure TFrmEditUser.EdtToUserNameEnter(Sender: TObject);
begin
  Shape1.Visible    := True;

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.EdtToUserNameExit(Sender: TObject);
begin
  Shape1.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.EdtPawChange(Sender: TObject);
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

procedure TFrmEditUser.EdtPawEnter(Sender: TObject);
begin
  Shape2.Visible    := True;

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.EdtPawExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.EdtPawConfirmChange(Sender: TObject);
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

procedure TFrmEditUser.EdtPawConfirmEnter(Sender: TObject);
begin
  Shape3.Visible    := True;

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.EdtPawConfirmExit(Sender: TObject);
begin
  Shape3.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.ProcCancel(Sender: TObject);
begin
  Self.close;
end;

procedure TFrmEditUser.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEditUser.ProcSave(Sender: TObject);
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

procedure TFrmEditUser.ActSaveExecute(Sender: TObject);
begin
  ProcSave(Sender);
end;

procedure TFrmEditUser.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditUser.ClearPawMouseOver(NewColor: TColor);
begin
  BtnClearPaw.Color := NewColor;
end;

procedure TFrmEditUser.BtnClearPawEnter(Sender: TObject);
begin
  ClearPawMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.BtnClearPawExit(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEditUser.BtnCancelEnter(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEditUser.BtnSaveEnter(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEditUser.ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Not FDBGridClicked then begin
    FDBGridClicked := True;
    ADBGridSelectEditor(
      Sender, ADBGrid.LastColumn, TWinControl(ADBGrid));

    ADBNavi.SetFocus;
    ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;

    Abort;
  end;
end;

procedure TFrmEditUser.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEditUser.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
begin
  FNavigateBtn := Index;
end;

procedure TFrmEditUser.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    BtnSave.SetFocus;
  end else if (Key = VK_TAB) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if CannotFocusedNavButton then begin
        EdtToUserName.SetFocus;
      end else begin
        ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEditUser.AQuAfterScroll(DataSet: TDataSet);
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

procedure TFrmEditUser.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuUsers);
  end;

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
  end;

  CloseAction := caFree;
  FrmEditUser := nil;
end;

procedure TFrmEditUser.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FDBGridClicked     := False;

  //FTab               := FTAB_UNDEFINED;

  FGuidePanels[0]    := Panel1;
  FGuidePanels[1]    := Panel2;
  FGuidePanels[2]    := Panel3;
  FGuidePanels[3]    := Panel4;
end;

procedure TFrmEditUser.FormShow(Sender: TObject);
begin
  Self.Width             := 667;

  Self.KeyPreview        := True;

  Self.Color             := RGB(112, 168, 175);
  PnlClearPaw.Color      := RGB( 72, 122, 129);
  PnlCancel.Color        := RGB( 72, 122, 129);
  PnlSave.Color          := RGB( 72, 122, 129);
  LblInfo.Font.Color     := RGB(255,   0,   0);

  { Debug }
  //Self.Width      := 819;
end;

procedure TFrmEditUser.FormActivate(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            if GetRole = ROLE_ADMIN then begin
              SQL.Text   := SQL_20040001;
              with Params do begin
                ParamByName('pRole').AsInteger    := ROLE_USER;
              end;
            end else begin
              SQL.Text   := SQL_20040002;
              with Params do begin
                ParamByName('pRole').AsInteger    := ROLE_USER;
                ParamByName('pName').AsAnsiString := GetUName;
              end;
            end;
            Open;
          end;
        end;
      end;

      EdtToUserName.SetFocus;
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
end;

procedure TFrmEditUser.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Timer.Enabled := True;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnClearPaw' then begin
      ActClearPaw.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end;
  end;
end;

procedure TFrmEditUser.TimerTimer(Sender: TObject);
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

