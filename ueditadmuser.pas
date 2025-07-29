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
    ADS                : TDataSource;
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
    procedure FormShow(Sender: TObject);
  private
    FUName             : String;
    FPAW               : String;
    procedure CloseTransactions;
    function CheckMultiFields(NameField: Boolean): String;
    function CheckSQuoteInPAW: Boolean;
    function CheckSQuoteInUName: Boolean;
    procedure ConnectUsersTable;
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

procedure TFrmEditAdmUser.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;
end;

procedure TFrmEditAdmUser.ProcCancel;
begin
  FrmManageUser.Visible := True;
  FrmEditAdmUser.Close;
end;

procedure TFrmEditAdmUser.ProcClearPaw;
begin
  FrmTopMenu.Defs.ClearPaw(EdtPaw, EdtPawConfirm);
end;

procedure TFrmEditAdmUser.ProcCommit;
var
  LSql           : String;
  LUserID        : String;
  LFieldAndValue : String;
  LRet           : String;
  LOriginalUName : String;
begin
  try
    try
      // Initialize
      LFieldAndValue := '';
      LOriginalUName := AQu.FieldByName('NAME').AsAnsiString;

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
        LFieldAndValue := LRet + ', UPDATE_DT = ''' +
        FormatDateTime('yyyy/mm/dd hh:mm:ss', Now, FrmTopMenu.Defs.GetFS) + '''';

        AQu.SQL.Text   := LSQL.Replace(':pFieldAndValue', LFieldAndValue);

        CloseTransactions;
        AQu.ExecSQL;
        ATr.Commit;

        if (FUName <> '')
           And (FrmTopMenu.Defs.UName = LOriginalUName)
           And (FUName <> LOriginalUName) then
        begin
          FrmTopMenu.Defs.SetChangedUserDef(True);
        end;

        if (FPAW <> '')
           And (FrmTopMenu.Defs.UName = LOriginalUName)
           And (FPAW <> AQu.FieldByName('PAW').AsAnsiString) then
        begin
          FrmTopMenu.Defs.SetChangedUserDef(True);
        end;

        CloseTransactions;
        ATr.Commit;

        FrmManageUser.Visible := True;
        if FrmTopMenu.Defs.GetChangedUserDef then
        begin
          MessageDlg(MSG_JP_000021, mtInformation, [mbOk], 0);
          FrmManageUser.ActGoBackExecute(FrmTopMenu);
          //FrmEditAdmUser.Close;
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

procedure TFrmEditAdmUser.ConnectUsersTable;
begin
  try
    with AQu do begin
      if Not ACn.Connected then
      begin
        ACn.DatabaseName := DB_NAME;
        ACn.Connected    := True;
        ATr.DataBase     := ACn;
        DataBase         := ACn;
        ATr.Active       := True;
      end;

      SQL.Text           := SQL_20040001;
      Params.ParamByName('pRole').AsInteger := ROLE_ADMIN;

      Open;
    end;

    ADS.DataSet             := AQu;
    ADBGrid.DataSource      := ADS;
    ADBGrid.AutoFillColumns := True;
  finally
  end;
end;

function TFrmEditAdmUser.CheckMultiFields(NameField: Boolean): String;
var
  LRet: String = '';
begin
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
        FrmTopMenu.Defs.ClearPaw(EdtPaw, EdtPawConfirm);
        MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
        Result   := '';
      end;
    end else begin // EdtPaw.Text = ''
      if EdtPawConfirm.Text <> '' then
      begin
        FrmTopMenu.Defs.ClearPaw(EdtPaw, EdtPawConfirm);
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
        FrmTopMenu.Defs.ClearPaw(EdtPaw, EdtPawConfirm);
        MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
        Result   := '';
      end;
    end else begin // EdtPaw.Text = ''
      if EdtPawConfirm.Text <> '' then
      begin
        FrmTopMenu.Defs.ClearPaw(EdtPaw, EdtPawConfirm);
        MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
        Result   := '';
      end else begin // EdtPawConfirm.Text = ''
        MessageDlg(MSG_JP_000020, mtWarning, [mbOk], 0);
        Result   := '';
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
  CloseTransactions;

  if FrmTopMenu.Defs.GetChangedUserDef = False then begin
    FrmManageUser := TFrmManageUser.Create(Application);
    FrmManageUser.Visible     := True;
  end else begin
    FrmTopMenu.Defs.SetChangedUserDef(False);
  end;
  CloseAction               := caFree;
  FrmEditAdmUser            := nil;
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

  ConnectUsersTable;
end;

end.

