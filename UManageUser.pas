unit UManageUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, SQLite3Conn, DB, BufDataset, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, DBCtrls, LCLIntf, ActnList,
  UDefs;

type

  { TFrmManageUser }

  TFrmManageUser = class(TForm)
    ActAddUser       : TAction;
    ActEditAdminUser : TAction;
    ActEditUser      : TAction;
    ActionList       : TActionList;
    ActQuit          : TAction;
    ActDeleteUser    : TAction;
    ADataSet         : TDataSet;
    ADBGrid          : TDBGrid;
    ADS              : TDataSource;
    ADSByCount       : TDataSource;
    AQu              : TSQLQuery;
    AQuByCount       : TSQLQuery;
    ATr              : TSQLTransaction;
    ATrByCount       : TSQLTransaction;
    BtnAddUser: TButton;
    BtnEditAdminUser: TButton;
    BtnEditUser: TButton;
    BtnGoBack: TButton;
    BtnRemoveUser: TButton;
    PnlAddUser       : TPanel;
    PnlEditAdminUser : TPanel;
    PnlEditUser      : TPanel;
    PnlGoBack        : TPanel;
    PnlRemoveUser    : TPanel;
    ACn: TSQLite3Connection;
    ACnByCount: TSQLite3Connection;
    Timer            : TTimer;
    procedure ActAddUserExecute(Sender: TObject);
    procedure ActEditAdminUserExecute(Sender: TObject);
    procedure ActEditUserExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ActDeleteUserExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    function CountUser(RoleNum: Integer): Integer;
    procedure EnableButton(
      AddUser, EditUser, RemoveUser, EditAdminUser: Boolean);
    procedure OpenFormOrMsgDlg(Sender: TForm);
    procedure ProcAddUser;
    procedure ProcEditAdminUser;
    procedure ProcEditUser;
    procedure ProcGoBack;
    procedure ProcRemoveUser;
  public

  end;

var
  FrmManageUser : TFrmManageUser;

implementation
uses
  UConsts, UDBAccess, UTopMenu, UAddUser, UEditUser, URemoveUser, UEditAdmUser;

{$R *.lfm}

{ TFrmManageUser }

procedure TFrmManageUser.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn       );
    SetDatabaseName(ACnByCount);
  end;
end;

procedure TFrmManageUser.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn       , ATr       );
    CloseConn(ACnByCount, ATrByCount);
  end;
end;

function TFrmManageUser.CountUser(RoleNum: Integer): Integer;
var
  LRet: Integer;
begin
  try
    with ACn do begin
      if Not Connected then
      begin
        DatabaseName := DB_NAME;
        Connected    := True;
      end;
    end;
    with AQuByCount do begin
      Database                              := ACn;
      SQL.Text                              := SQL_20020003;
      with Params do begin
        ParamByName('pRole').AsInteger := RoleNum;
      end;
    end;

    AQuByCount.Open;
  finally
    LRet                       := AQuByCount.FieldByName('COUNT').AsInteger;
    Result                     := LRet;
  end;
end;

procedure TFrmManageUser.EnableButton(
    AddUser, EditUser, RemoveUser, EditAdminUser: Boolean);
begin
    BtnAddUser.Enabled       := AddUser;
    BtnEditUser.Enabled      := EditUser;
    BtnRemoveUser.Enabled    := RemoveUser;
    BtnEditAdminUser.Enabled := EditAdminUser;
end;

procedure TFrmManageUser.OpenFormOrMsgDlg(Sender: TForm);
begin
  CloseTransactions;
  SetDatabaseNames;

  with FrmTopMenu.Defs do begin
    if Not GetShowChildForm then
    begin
      SetShowChildForm(True);
    end;
  end;

  FrmManageUser.Visible := False;

  Sender.Show;
end;

procedure TFrmManageUser.ProcAddUser;
begin
  FrmAddUser := TFrmAddUser.Create(Application);
  OpenFormOrMsgDlg(FrmAddUser);
end;

procedure TFrmManageUser.ProcEditAdminUser;
begin
  FrmEditAdmUser := TFrmEditAdmUser.Create(Application);
  OpenFormOrMsgDlg(FrmEditAdmUser);
end;

procedure TFrmManageUser.ProcEditUser;
begin
  if CountUser(ROLE_USER) > 0 then
  begin
    FrmEditUser := TFrmEditUser.Create(Application);
    OpenFormOrMsgDlg(FrmEditUser);
  end else begin
    ShowMessage(MSG_JP_000015);
  end;
end;

procedure TFrmManageUser.ProcGoBack;
begin
  FrmTopMenu.Visible         := True;
  FrmManageUser.Close;
end;

procedure TFrmManageUser.ProcRemoveUser;
begin
  if CountUser(ROLE_USER) > 0 then
  begin
    FrmRemoveUser := TFrmRemoveUser.Create(Application);
    OpenFormOrMsgDlg(FrmRemoveUser);
  end else begin
    ShowMessage(MSG_JP_000016);
  end;
end;

procedure TFrmManageUser.ActAddUserExecute(Sender: TObject);
begin
  ProcAddUser;
end;

procedure TFrmManageUser.ActEditAdminUserExecute(Sender: TObject);
begin
  ProcEditAdminUser;
end;

procedure TFrmManageUser.ActEditUserExecute(Sender: TObject);
begin
  ProcEditUser;
end;

procedure TFrmManageUser.ActGoBackExecute(Sender: TObject);
begin
  ProcGoBack;
end;

procedure TFrmManageUser.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmManageUser.ActDeleteUserExecute(Sender: TObject);
begin
  ProcRemoveUser;
end;

procedure TFrmManageUser.FormClose(
    Sender: TObject; var CloseAction: TCloseAction);
begin
  with FrmTopMenu do begin
    CloseTransactions;

    Visible := True;

    with Defs do begin
      if GetChangedUserDef then
      begin
        ProcLogout(Sender);
      end;
    end;
    CloseAction        := caFree;
    FrmManageUser      := nil;
  end;
end;

procedure TFrmManageUser.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmManageUser.FormShow(Sender: TObject);
begin
  FrmManageUser.Color    := RGB(112, 168, 175);
  PnlAddUser.Color       := RGB( 72, 122, 129);
  PnlEditUser.Color      := RGB( 72, 122, 129);
  PnlRemoveUser.Color    := RGB( 72, 122, 129);
  PnlEditAdminUser.Color := RGB( 72, 122, 129);
  PnlGoBack.Color        := RGB( 72, 122, 129);

  // Connecting users table with SQLite3
  try
    with FrmTopMenu.Defs do begin
      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20020001);

      if MatchRole(ROLE_ADMIN) then begin
        if AQu.RecordCount = 1 then
        begin
          EnableButton(True, False, False, True);
        end else if AQu.RecordCount > 1 then begin
          EnableButton(True, True, True, True);
        end;
      end else begin // Defs.MatchRole(ROLE_ADMIN) = False
        with AQu do begin
          CloseTransactions;
          SetDatabaseNames;

          SQL.Text := SQL_20020002;
          with Params do begin
            ParamByName('pUName').AsAnsiString  := GetUName;
          end;
          Open;
          if RecordCount = 1 then
          begin
            EnableButton(False, True, False, False);
          end else begin
            if Not GetChangedUserDef then
            begin
              EnableButton(False, False, False, False);
              MessageDlg(MSG_JP_000004, mtError, [mbOk], 0);
              Close;
            end;
          end;
        end;
      end;

      ADS.DataSet     := AQu;
      with ADBGrid do begin
        DataSource      := ADS;
        AutoFillColumns := True;
        AutoFillColumns := False;
      end;
    end;
  finally
  end;

  with ADBGrid do begin
    Options := Options - [dgAutoSizeColumns];
    Options := Options + [dgColumnResize];

    Columns[0].Width   := 50;
    Columns[1].Width   := 200;
    Columns[3].Width   := 200;
    Columns[4].Width   := 200;

    AutoSize   := False;
    ScrollBars := ssAutoBoth;
  end;
end;

procedure TFrmManageUser.TimerTimer(Sender: TObject);
begin
  if ChngdAdmUserFlg then
  begin
    FrmManageUser.Close;
  end;
end;

end.

