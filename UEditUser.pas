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
    ActCancel          : TAction;
    ActClearPaw        : TAction;
    ActCommit          : TAction;
    ActionList         : TActionList;
    ActQuit            : TAction;
    ADBGrid            : TDBGrid;
    ADS                : TDataSource;
    AQu                : TSQLQuery;
    ATr                : TSQLTransaction;
    BtnCancel: TButton;
    BtnClearPaw: TButton;
    BtnCommit: TButton;
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
    PnlCancel          : TPanel;
    PnlClearPaw       : TPanel;
    PnlCommit          : TPanel;
    ACn: TSQLite3Connection;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActClearPawExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
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
    procedure ConnectUsersTable;
    procedure EdtPawChange(Sender: TObject);
    procedure ProcCancel;
    procedure ProcClearPaw;
    procedure ProcCommit;
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
    SetDatabaseName(ACn);
  end;
end;

procedure TFrmEditUser.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;
end;

function TFrmEditUser.CheckMultiFields(NameField: Boolean): String;
var
  LRet: String = '';
begin
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
        FrmTopMenu.Defs.ClearPaw(EdtPaw, EdtPawConfirm);
        MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
        Result     := '';
      end;
    end else begin // EdtPaw.Text = ''
      if EdtPawConfirm.Text <> '' then
      begin
        FrmTopMenu.Defs.ClearPaw(nil, EdtPaw);
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
        FrmTopMenu.Defs.ClearPaw(EdtPaw, EdtPawConfirm);
        MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
        Result                                     := '';
      end;
    end else begin // EdtPaw.Text = ''
      if EdtPawConfirm.Text <> '' then
      begin
        FrmTopMenu.Defs.ClearPaw(nil, EdtPaw);
        MessageDlg(MSG_JP_000005, mtWarning, [mbOk], 0);
        Result                                     := '';
      end else begin // EdtPawConfirm.Text = ''
        MessageDlg(MSG_JP_000020, mtWarning, [mbOk], 0);
        Result                                     := '';
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

procedure TFrmEditUser.ConnectUsersTable;
begin
  try
    with ACn do begin
      if Not Connected then
      begin
        DatabaseName := DB_NAME;
        Connected    := True;
        ATr.DataBase := ACn;
        AQu.DataBase := ACn;
        ATr.StartTransaction;
      end else begin
        ATr.CloseDataSets;
        ATr.StartTransaction;
      end;
    end;

    with AQu do begin
      SQL.Text   := SQL_20040001;
      if FrmTopMenu.Defs.GetRole = ROLE_USER then
      begin
        SQL.Text := SQL_20040002;
        Params.ParamByName('pName').AsAnsiString := FrmTopMenu.Defs.GetUName;
      end;
      Params.ParamByName('pRole').AsInteger      := ROLE_USER;

      Open;
    end;

    ADS.DataSet       := AQu;
    with ADBGrid do begin
      DataSource      := ADS;
      AutoFillColumns := True;
    end;
  finally
  end;
end;

procedure TFrmEditUser.ProcCancel;
begin
  FrmManageUser.Visible := True;
  FrmEditUser.close;
end;

procedure TFrmEditUser.ProcClearPaw;
begin
  FrmTopMenu.Defs.ClearPaw(nil, EdtPaw);
end;

procedure TFrmEditUser.ProcCommit;
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
        LFieldAndValue  := LRet + ', UPDATE_DT = ''' +
        FormatDateTime('yyyy/mm/dd hh:mm:ss', Now, FrmTopMenu.Defs.GetFS) + '''';

        AQu.SQL.Text    := LSQL.Replace(':pFieldAndValue', LFieldAndValue);

        CloseTransactions;
        AQu.ExecSQL;

        if (FUName <> '')
           And (FrmTopMenu.Defs.GetUName = LOriginalUName)
           And (FUName <> LOriginalUName) then
        begin
          ATr.Commit;
          FrmTopMenu.Defs.SetChangedUserDef(True);
        end;

        if (FPAW <> '')
           And (FrmTopMenu.Defs.GetUName = LOriginalUName)
           And (FPAW <> AQu.FieldByName('PAW').AsAnsiString) then
        begin
          ATr.Commit;
          FrmTopMenu.Defs.SetChangedUserDef(True);
        end;

        FrmManageUser.Visible := True;
        if FrmTopMenu.Defs.GetChangedUserDef then
        begin
          MessageDlg(MSG_JP_000021, mtInformation, [mbOk], 0);
          FrmManageUser.ActGoBackExecute(FrmTopMenu);
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

procedure TFrmEditUser.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmEditUser.ActClearPawExecute(Sender: TObject);
begin
  ProcClearPaw;
end;

procedure TFrmEditUser.ActCommitExecute(Sender: TObject);
begin
  ProcCommit;
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

  if FrmTopMenu.Defs.GetChangedUserDef = False then begin
    FrmManageUser := TFrmManageUser.Create(Application);
    FrmManageUser.Visible     := True;
  end else begin
    FrmTopMenu.Defs.SetChangedUserDef(False);
  end;
  CloseAction            := caFree;
  FrmEditUser            := nil;
end;

procedure TFrmEditUser.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FrmEditUser.Color  := RGB(112, 168, 175);
  PnlClearPaw.Color := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlCommit.Color    := RGB( 72, 122, 129);
  LblInfo.Font.Color := RGB(255,   0,   0);

  FrmEditUser.Height := 800;

  ConnectUsersTable;
end;

procedure TFrmEditUser.FormShow(Sender: TObject);
begin

end;

end.

