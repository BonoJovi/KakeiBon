unit UEditUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, LazUTF8, SysUtils, SQLDB, SQLite3Conn, DB, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, DBCtrls, DBGrids, LCLIntf,
  ActnList;

type

  { TFrmEditUser }

  TFrmEditUser = class(TForm)
    ACn                : TSQLite3Connection;
    ADS                : TDataSource;
    ATr                : TSQLTransaction;
    AQu                : TSQLQuery;
    ACnUsers           : TSQLite3Connection;
    ADSUsers           : TDataSource;
    ATrUsers           : TSQLTransaction;
    AQuUsers           : TSQLQuery;
    ActionList         : TActionList;
    ActCancel          : TAction;
    ActClearPaw        : TAction;
    ActSave          : TAction;
    ActQuit            : TAction;
    ADBGrid            : TDBGrid;
    DBNavigator        : TDBNavigator;
    DBTextFromUserName : TDBText;
    DBTextUserID       : TDBText;
    EdtPaw             : TEdit;
    EdtPawConfirm      : TEdit;
    EdtToUserName      : TEdit;
    LblInfo            : TLabel;
    LblPaw             : TLabel;
    LblPawConfirm      : TLabel;
    LblToUName         : TLabel;
    LblUserName        : TLabel;
    LblUserName1       : TLabel;
    LblUserID          : TLabel;
    BtnClearPaw: TPanel;
    BtnCancel: TPanel;
    BtnSave: TPanel;
    PnlCancel          : TPanel;
    PnlClearPaw        : TPanel;
    PnlCommit          : TPanel;
    procedure ProcClearPaw(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure ClearPawMouseOver(NewColor: TColor);
    procedure BtnClearPawEnter(Sender: TObject);
    procedure BtnClearPawExit(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure SaveMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure ActClearPawExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure EdtToUserNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FUName             : String;
    FPAW               : String;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    function CheckMultiFields(NameField: Boolean): String;
    function CheckSQuoteInPAW: Boolean;
    function CheckSQuoteInUName: Boolean;
    procedure EdtPawChange(Sender: TObject);
  public
  end;

var
  FrmEditUser: TFrmEditUser;

implementation
uses
  UConsts, UDefs, UDBAccess, UTopMenu, UManageUser;

{$R *.lfm}

{ TFrmEditUser }

procedure TFrmEditUser.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn     );
    SetDatabaseName(ACnUsers);
  end;
end;

procedure TFrmEditUser.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn     , ATr     );
    CloseConn(ACnUsers, ATrUsers);
  end;
end;

function TFrmEditUser.CheckMultiFields(NameField: Boolean): String;
var
  LRet: String = '';
begin
  with FrmTopMenu.Defs do begin
    if NameField then
    begin
      if Not CheckSQuoteInUName then
      begin
        LRet         := 'NAME = ''' + EdtToUserName.Text + '''';
      end else begin
        Result       := '';
        Exit;
      end;

      if EdtPaw.Text <> '' then
      begin
        if EdtPaw.Text = EdtPawConfirm.Text then
        begin
          if CheckSQuoteInPAW then
          begin
            Result   := '';
            Exit;
          end;
          Result     := LRet + ', PAW = ''' + EdtPaw.Text + '''';
        end else begin // EdtPaw.Text <> EdtPawConfirm.Text
          ClearPaw(EdtPaw, EdtPawConfirm);
          MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
          Result     := '';
        end;
      end else begin // EdtPaw.Text = ''
        if EdtPawConfirm.Text <> '' then
        begin
          ClearPaw(nil, EdtPaw);
          MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
          Result     := '';
        end else begin // EdtPawConfirm.Text = ''
          if NameField then
          begin
            if Not CheckSQuoteInUName then
            begin
              Result := 'NAME = ''' + EdtToUserName.Text + '''';
            end else begin // CheckSQuoteInUName = True
              Result := '';
            end;
          end else begin
            Result   := '';
          end;
        end;
      end;
    end else begin // Not NameField
      if EdtPaw.Text <> '' then
      begin
        if EdtPaw.Text = EdtPawConfirm.Text then
        begin
          if CheckSQuoteInPAW then
          begin
            Result                                   := '';
            Exit;
          end;
          Result                                     := '"PAW" = ''' + EdtPaw.Text + '''';
        end else begin // EdtPaw.Text <> EdtPawConfirm.Text
          ClearPaw(EdtPaw, EdtPawConfirm);
          MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
          Result                                     := '';
        end;
      end else begin // EdtPaw.Text = ''
        if EdtPawConfirm.Text <> '' then
        begin
          ClearPaw(nil, EdtPaw);
          MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
          Result                                     := '';
        end else begin // EdtPawConfirm.Text = ''
          MessageDlg(MSG_JP_000020, mtWarning, [mbOk], 0);
          Result                                     := '';
        end;
      end;
    end;
  end;
end;

function TFrmEditUser.CheckSQuoteInPAW: Boolean;
begin
  if (Pos('''', EdtPaw.Text) > 0) Or (Pos('''', EdtPawConfirm.Text) > 0) then
  begin
    MessageDlg(MSG_JP_000019, mtWarning, [mbOk], 0);
    Result := True;
  end else begin
    Result := False;
  end;
end;

function TFrmEditUser.CheckSQuoteInUName: Boolean;
begin
  if Pos('''', EdtToUserName.Text) > 0 then
  begin
    MessageDlg(MSG_JP_000018, mtWarning, [mbOk], 0);
    Result := True;
  end else begin
    Result := False;
  end;
end;

procedure TFrmEditUser.ProcClearPaw(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    ClearPaw(nil, EdtPaw);
  end;
end;

procedure TFrmEditUser.ProcCancel(Sender: TObject);
begin
  FrmManageUser.Visible := True;
  FrmEditUser.close;
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
begin
  try
    try
      with FrmTopMenu.Defs do begin
        // Initialize
        LFieldAndValue    := '';
        LOriginalUName    := AQu.FieldByName('NAME').AsAnsiString;

        LUserID           := AQu.FieldByName('USER_ID').AsAnsiString;
        LSql              := SQL_20040003.Replace(':pUserID', LUserID);

        if EdtToUserName.Text <> '' then
        begin
          LRet            := CheckMultiFields(True);
        end else begin
          LRet            := CheckMultiFields(False);
        end;

        if LRet = '' then
        begin
          Exit;
        end else begin
          CloseTransactions;
          SetDatabaseNames;

          with AQuUsers do begin
            SQL.Text := SQL_20040001;
            with Params do begin
              ParamByName('pRole').AsInteger := ROLE_ADMIN;
              Open;
              LAdminName := FieldByName('NAME').AsAnsiString;
            end;

            CloseConn(ACnUsers, ATrUsers);
            SetDatabaseNames;

            SQL.Text := SQL_20040002;
            with Params do begin
              ParamByName('pRole').AsInteger    := ROLE_USER;
              ParamByName('pName').AsAnsiString := DBTextFromUserName.ToString;
              Open;
              LOriginalPaw := AQuUsers.FieldByName('PAW').AsAnsiString;
            end;
          end;

          CloseTransactions;
          SetDatabaseNames;

          LFieldAndValue := LRet + ', UPDATE_DT = datetime(''Now'', ''+9 hours'')';

          AQu.SQL.Text    := LSQL.Replace(':pFieldAndValue', LFieldAndValue);

          CloseTransactions;
          SetDatabaseNames;
          AQu.ExecSQL;

          if (FUName <> '')
              And ((GetUName = LAdminName)
                  Or (GetUName = LOriginalUName))
              And ((FUName <> LOriginalUName)
                  Or (FPAW <> LOriginalPaw)) then begin
            ATr.Commit;
            SetChangedUserDef(True);
          end else begin
            ATr.Rollback;
            SetChangedUserDef(False);
          end;

          CloseTransactions;
          SetDatabaseNames;

          FrmManageUser.Visible := True;
          if GetChangedUserDef then
          begin
            MessageDlg(MSG_JP_000021, mtInformation, [mbOk], 0);
            FrmManageUser.ActGoBackExecute(FrmTopMenu);
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do
      begin
        ShowMessage(E.Message);
        ATr.Rollback;
        MessageDlg(MSG_JP_000010, mtError, [mbOk], 0);
      end;
    end;
  finally
    ATr.Active            := False;
    FrmEditUser.Close;
  end;
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
end;

procedure TFrmEditUser.BtnClearPawExit(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
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
end;

procedure TFrmEditUser.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
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
end;

procedure TFrmEditUser.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);
end;

procedure TFrmEditUser.ActClearPawExecute(Sender: TObject);
begin
  ProcClearPaw(Sender);
end;

procedure TFrmEditUser.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEditUser.ActSaveExecute(Sender: TObject);
begin
  ProcSave(Sender);
end;

procedure TFrmEditUser.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditUser.EdtPawChange(Sender: TObject);
begin
  FPAW := EdtPaw.Text;
end;

procedure TFrmEditUser.EdtToUserNameChange(Sender: TObject);
begin
  FUName := EdtToUserName.Text;
end;

procedure TFrmEditUser.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseTransactions;

  with FrmTopMenu.Defs do begin
    if GetChangedUserDef = False then begin
      FrmManageUser := TFrmManageUser.Create(Application);
      FrmManageUser.Visible     := True;
    end else begin
      SetChangedUserDef(False);
    end;
    CloseAction            := caFree;
    FrmEditUser            := nil;
  end;
end;

procedure TFrmEditUser.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmEditUser.FormShow(Sender: TObject);
begin
  FrmEditUser.Color  := RGB(112, 168, 175);
  PnlClearPaw.Color  := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlCommit.Color    := RGB( 72, 122, 129);
  LblInfo.Font.Color := RGB(255,   0,   0);

  FrmEditUser.Height := 800;

  try
    try
      with FrmTopMenu.Defs do begin
        with AQu do begin
          SQL.Text   := SQL_20040001;
          with Params do begin
            if GetRole = ROLE_USER then
            begin
              SQL.Text := SQL_20040002;
              ParamByName('pName').AsAnsiString := GetUName;
            end;
            ParamByName('pRole').AsInteger      := ROLE_USER;
          end;

          Open;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

end.

