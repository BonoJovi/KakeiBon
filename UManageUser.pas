unit UManageUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, SQLDB, SQLite3Conn, DB, BufDataset, Forms,
  Controls, Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, DBCtrls, LCLIntf,
  ActnList, UDefs;

type

  { TFrmManageUser }

  TFrmManageUser = class(TForm)
    ActAddUser       : TAction;
    ActEditAdminUser : TAction;
    ActEditUser      : TAction;
    ActionList       : TActionList;
    ActQuit          : TAction;
    ActRemoveUser    : TAction;
    ADataSet         : TDataSet;
    ADBGrid          : TDBGrid;
    ADS              : TDataSource;
    ADSByCount       : TDataSource;
    AQu              : TSQLQuery;
    AQuByCount       : TSQLQuery;
    ATr              : TSQLTransaction;
    ATrByCount       : TSQLTransaction;
    BtnAddUser           : TPanel;
    BtnEditUser: TPanel;
    BtnRemoveUser: TPanel;
    BtnEditAdminUser: TPanel;
    BtnGoBack: TPanel;
    PnlAddUser       : TPanel;
    PnlEditAdminUser : TPanel;
    PnlEditUser      : TPanel;
    PnlGoBack        : TPanel;
    PnlRemoveUser    : TPanel;
    ACn              : TSQLite3Connection;
    ACnByCount       : TSQLite3Connection;
    Timer            : TTimer;
    procedure ProcAddUser(Sender: TObject);
    procedure ProcEditUser(Sender: TObject);
    procedure ProcRemoveUser(Sender: TObject);
    procedure ProcEditAdminUser(Sender: TObject);
    procedure ProcGoBack(Sender: TObject);
    procedure AddUserMouseOver(NewColor: TColor);
    procedure BtnAddUserEnter(Sender: TObject);
    procedure BtnAddUserExit(Sender: TObject);
    procedure EditUserMouseOver(NewColor: TColor);
    procedure BtnEditUserEnter(Sender: TObject);
    procedure BtnEditUserExit(Sender: TObject);
    procedure RemoveUserMouseOver(NewColor: TColor);
    procedure BtnRemoveUserEnter(Sender: TObject);
    procedure BtnRemoveUserExit(Sender: TObject);
    procedure EditAdminUserMouseOver(NewColor: TColor);
    procedure BtnEditAdminUserEnter(Sender: TObject);
    procedure BtnEditAdminUserExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActAddUserExecute(Sender: TObject);
    procedure ActEditAdminUserExecute(Sender: TObject);
    procedure ActEditUserExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ActRemoveUserExecute(Sender: TObject);
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

procedure TFrmManageUser.ProcAddUser(Sender: TObject);
begin
  FrmAddUser := TFrmAddUser.Create(Application);
  OpenFormOrMsgDlg(FrmAddUser);
end;

procedure TFrmManageUser.ProcEditUser(Sender: TObject);
begin
  if CountUser(ROLE_USER) > 0 then
  begin
    FrmEditUser := TFrmEditUser.Create(Application);
    OpenFormOrMsgDlg(FrmEditUser);
  end else begin
    ShowMessage(MSG_JP_000015);
  end;
end;

procedure TFrmManageUser.ProcRemoveUser(Sender: TObject);
begin
  if CountUser(ROLE_USER) > 0 then
  begin
    FrmRemoveUser := TFrmRemoveUser.Create(Application);
    OpenFormOrMsgDlg(FrmRemoveUser);
  end else begin
    ShowMessage(MSG_JP_000016);
  end;
end;

procedure TFrmManageUser.ProcEditAdminUser(Sender: TObject);
begin
  FrmEditAdmUser := TFrmEditAdmUser.Create(Application);
  OpenFormOrMsgDlg(FrmEditAdmUser);
end;

procedure TFrmManageUser.ProcGoBack(Sender: TObject);
begin
  FrmTopMenu.Visible         := True;
  FrmManageUser.Close;
end;

procedure TFrmManageUser.AddUserMouseOver(NewColor: TColor);
begin
  BtnAddUser.Color := NewColor;
end;

procedure TFrmManageUser.BtnAddUserEnter(Sender: TObject);
begin
  AddUserMouseOver(clSkyBlue);
end;

procedure TFrmManageUser.BtnAddUserExit(Sender: TObject);
begin
  AddUserMouseOver(clBtnFace);
end;

procedure TFrmManageUser.EditUserMouseOver(NewColor: TColor);
begin
  BtnEditUser.Color := NewColor;
end;

procedure TFrmManageUser.BtnEditUserEnter(Sender: TObject);
begin
  EditUserMouseOver(clSkyBlue);
end;

procedure TFrmManageUser.BtnEditUserExit(Sender: TObject);
begin
  EditUserMouseOver(clBtnFace);
end;

procedure TFrmManageUser.RemoveUserMouseOver(NewColor: TColor);
begin
  BtnRemoveUser.Color := NewColor;
end;

procedure TFrmManageUser.BtnRemoveUserEnter(Sender: TObject);
begin
  RemoveUserMouseOver(clSkyBlue);
end;

procedure TFrmManageUser.BtnRemoveUserExit(Sender: TObject);
begin
  RemoveUserMouseOver(clBtnFace);
end;

procedure TFrmManageUser.EditAdminUserMouseOver(NewColor: TColor);
begin
  BtnEditAdminUser.Color := NewColor;
end;

procedure TFrmManageUser.BtnEditAdminUserEnter(Sender: TObject);
begin
  EditAdminUserMouseOver(clSkyBlue);
end;

procedure TFrmManageUser.BtnEditAdminUserExit(Sender: TObject);
begin
  EditAdminUserMouseOver(clBtnFace);
end;

procedure TFrmManageUser.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmManageUser.BtnGoBackEnter(Sender: TObject);
begin
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmManageUser.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageUser.ActAddUserExecute(Sender: TObject);
begin
  ProcAddUser(Sender);
end;

procedure TFrmManageUser.ActEditUserExecute(Sender: TObject);
begin
  ProcEditUser(Sender);
end;

procedure TFrmManageUser.ActRemoveUserExecute(Sender: TObject);
begin
  ProcRemoveUser(Sender);
end;

procedure TFrmManageUser.ActEditAdminUserExecute(Sender: TObject);
begin
  ProcEditAdminUser(Sender);
end;

procedure TFrmManageUser.ActGoBackExecute(Sender: TObject);
begin
  ProcGoBack(Sender);
end;

procedure TFrmManageUser.ActQuitExecute(Sender: TObject);
begin
  Close;
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

