unit UEditAdmUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, SysUtils, LazUTF8, SQLDB, SQLite3Conn, DB, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, DBCtrls, DBGrids, LCLIntf,
  ActnList;

type

  { TFrmEditAdmUser }

  TFrmEditAdmUser = class(TForm)
    ACnUsers: TSQLite3Connection;
    ADS                : TDataSource;
    ADSUsers: TDataSource;
    AQuUsers: TSQLQuery;
    ATr                : TSQLTransaction;
    AQu                : TSQLQuery;
    { ActionLists }
    ActionList         : TActionList;
    ActCancel          : TAction;
    ActClearPaw        : TAction;
    ActCommit          : TAction;
    ActQuit            : TAction;
    { Etc controls }
    ADBGrid            : TDBGrid;
    ATrUsers: TSQLTransaction;
    BtnCancel: TButton;
    BtnClearPaw: TButton;
    BtnCommit: TButton;
    DBNavigator        : TDBNavigator;
    DBTextFromUserName : TDBText;
    DBTextUserID       : TDBText;
    EdtPaw             : TEdit;
    EdtPawConfirm      : TEdit;
    EdtToUserName      : TEdit;
    LblToUserName      : TLabel;
    LblInfo            : TLabel;
    LblPaw             : TLabel;
    LblPawConfirm      : TLabel;
    LblUserID          : TLabel;
    LblUserName        : TLabel;
    LblUserName1       : TLabel;
    PnlCancel          : TPanel;
    PnlClearPass       : TPanel;
    PnlCommit          : TPanel;
    ACn: TSQLite3Connection;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActClearPawExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure EdtPawChange(Sender: TObject);
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
    procedure ProcCancel;
    procedure ProcClearPaw;
    procedure ProcCommit;
  public
  end;

var
  FrmEditAdmUser: TFrmEditAdmUser;

implementation
uses
  UConsts, UDefs, UDBAccess, UTopMenu, UManageUser;

{$R *.lfm}

{ TFrmEditAdmUser }

procedure TFrmEditAdmUser.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn     );
    SetDatabaseName(ACnUsers);
  end;
end;

procedure TFrmEditAdmUser.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn     , ATr     );
    CloseConn(ACnUsers, ATrUsers);
  end;
end;

procedure TFrmEditAdmUser.ProcCancel;
begin
  FrmManageUser.Visible := True;
  FrmEditAdmUser.Close;
end;

procedure TFrmEditAdmUser.ProcClearPaw;
begin
  with FrmTopMenu.Defs do begin
    ClearPaw(EdtPaw, EdtPawConfirm);
  end;
end;

procedure TFrmEditAdmUser.ProcCommit;
var
  LSql           : String;
  LUserID        : String;
  LFieldAndValue : String;
  LRet           : String;
  LAdminName     : String;
  LOriginalPaw   : String;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        // Initialize
        LFieldAndValue := '';

        with AQu do begin
          DataBase    := ACn;
          Transaction := ATr;
          ADS.DataSet := AQu;
          LUserID     := FieldByName('USER_ID').AsAnsiString;
          LSql        := SQL_20040003.Replace(':pUserID', LUserID);
        end;

        if EdtToUserName.Text <> '' then
        begin
          LRet := CheckMultiFields(True);
        end else begin
          LRet := CheckMultiFields(False);
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
              LOriginalPaw := AQuUsers.FieldByName('PAW').AsAnsiString;
            end;
          end;

          CloseTransactions;
          SetDatabaseNames;

          LFieldAndValue := LRet + ', UPDATE_DT = datetime(''Now'', ''+9 hours'')';

          AQu.SQL.Text   := LSQL.Replace(':pFieldAndValue', LFieldAndValue);

          CloseTransactions;
          SetDatabaseNames;
          AQu.ExecSQL;

          if (FUName <> '')
              And (GetUName = LAdminName)
              And ((FUName <> LAdminName)
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
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATr.Rollback;
        MessageDlg(MSG_JP_000010, mtError, [mbOk], 0);
      end;
    end;
  finally
    FrmEditAdmUser.Close;
  end;
end;

function TFrmEditAdmUser.CheckMultiFields(NameField: Boolean): String;
var
  LRet: String = '';
begin
  with FrmTopMenu.Defs do begin
    if NameField then
    begin
      if Not CheckSQuoteInUName then
      begin
        LRet   := 'NAME = ''' + EdtToUserName.Text + '''';
      end else begin
        Result := '';
        Exit;
      end;

      if EdtPaw.Text <> '' then
      begin
        if EdtPaw.Text = EdtPawConfirm.Text then
        begin
          if CheckSQuoteInPAW then
          begin
            Result := '';
            Exit;
          end;
          Result   := LRet + ', PAW = ''' + EdtPaw.Text + '''';
        end else begin // EdtPaw.Text <> EdtPawConfirm.Text
          ClearPaw(EdtPaw, EdtPawConfirm);
          MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
          Result   := '';
        end;
      end else begin // EdtPaw.Text = ''
        if EdtPawConfirm.Text <> '' then
        begin
          ClearPaw(EdtPaw, EdtPawConfirm);
          MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
          Result                                     := '';
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
            Result := '';
            Exit;
          end;
          Result   := 'PAW = ''' + EdtPaw.Text + '''';
        end else begin // EdtPaw.Text <> EdtPawConfirm.Text
          ClearPaw(EdtPaw, EdtPawConfirm);
          MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
          Result   := '';
        end;
      end else begin // EdtPaw.Text = ''
        if EdtPawConfirm.Text <> '' then
        begin
          ClearPaw(EdtPaw, EdtPawConfirm);
          MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
          Result   := '';
        end else begin // EdtPawConfirm.Text = ''
          MessageDlg(MSG_JP_000020, mtWarning, [mbOk], 0);
          Result   := '';
        end;
      end;
    end;
  end;
end;

function TFrmEditAdmUser.CheckSQuoteInPAW: Boolean;
begin
  if (Pos('''', EdtPaw.Text) > 0) Or (Pos('''', EdtPawConfirm.Text) > 0) then
  begin
    MessageDlg(MSG_JP_000019, mtWarning, [mbOk], 0);
    Result := True;
  end else begin
    Result := False;
  end;
end;

function TFrmEditAdmUser.CheckSQuoteInUName: Boolean;
begin
  if Pos('''', EdtToUserName.Text) > 0 then
  begin
    MessageDlg(MSG_JP_000018, mtWarning, [mbOk], 0);
    Result := True;
  end else begin
    Result := False;
  end;
end;

procedure TFrmEditAdmUser.EdtPawChange(Sender: TObject);
begin
  FPAW                                      := EdtPaw.Text;
end;

procedure TFrmEditAdmUser.ActClearPawExecute(Sender: TObject);
begin
  ProcClearPaw;
end;

procedure TFrmEditAdmUser.ActCommitExecute(Sender: TObject);
begin
  ProcCommit;
end;

procedure TFrmEditAdmUser.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditAdmUser.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmEditAdmUser.EdtToUserNameChange(Sender: TObject);
begin
  FUName := EdtToUserName.Text;
end;

procedure TFrmEditAdmUser.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with FrmTopMenu.Defs do begin
    CloseTransactions;

    if GetChangedUserDef = False then begin
      FrmManageUser := TFrmManageUser.Create(Application);
      FrmManageUser.Visible     := True;
    end else begin
      SetChangedUserDef(False);
    end;
    CloseAction               := caFree;
    FrmEditAdmUser            := nil;
  end;
end;

procedure TFrmEditAdmUser.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmEditAdmUser.FormShow(Sender: TObject);
begin
  FrmEditAdmUser.Color := RGB(112, 168, 175);
  PnlClearPass.Color   := RGB( 72, 122, 129);
  PnlCancel.Color      := RGB( 72, 122, 129);
  PnlCommit.Color      := RGB( 72, 122, 129);
  LblInfo.Font.Color   := RGB(255,   0,   0);

  FrmEditAdmUser.Height := 442;
  FrmEditAdmUser.Width  := 667;

  try
    try
      with FrmTopMenu.Defs do begin
        with AQu do begin
          SQL.Text   := SQL_20040001;
          with Params do begin
            if GetRole = ROLE_ADMIN then
            begin
              SQL.Text := SQL_20040002;
              ParamByName('pName').AsAnsiString := GetUName;
            end;
            ParamByName('pRole').AsInteger      := ROLE_ADMIN;
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

