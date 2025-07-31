unit UTopMenu;

{$mode objfpc}{$H+}{$M+}

interface

uses
  Classes, SysUtils, SQLDB, SQLite3Conn, FBAdmin, DB, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, ActnList, StdActns, LCLIntf, UConsts, UDefs,
  UEntryAdmin;

type

  { TFrmTopMenu }

  TFrmTopMenu = class(TForm)
    ActEntryDetails  : TAction;
    ActionList       : TActionList;
    ActLogin         : TAction;
    ActLogout        : TAction;
    ActManageExp     : TAction;
    ActManageUser    : TAction;
    ActQuit          : TAction;
    ADS              : TDataSource;
    AQu              : TSQLQuery;
    ATr              : TSQLTransaction;
    BtnEntryDetails: TButton;
    BtnLogin: TButton;
    BtnLogout: TButton;
    BtnManageExp: TButton;
    BtnManageUser: TButton;
    BtnQuit: TButton;
    PnlManageDetails : TPanel;
    PnlLogin         : TPanel;
    PnlLogInAndOut   : TPanel;
    PnlLogout        : TPanel;
    PnlEntryDetails  : TPanel;
    PnlManageExp     : TPanel;
    PnlManagements   : TPanel;
    PnlManageUser    : TPanel;
    PnlQuit          : TPanel;
    ACn: TSQLite3Connection;
    Timer            : TTimer;
    procedure ActLoginExecute(Sender: TObject);
    procedure ActLogoutExecute(Sender: TObject);
    procedure ActEntryDetailsExecute(Sender: TObject);
    procedure ActManageExpExecute(Sender: TObject);
    procedure ActManageUserExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    function Defs: TDefs;
    procedure ProcLogout;
  private
    FDefs            : TDefs;
    Temp             : TFrmEntryAdmin;
    procedure OpenFormEntryAdmin;
    procedure OpenFormOrMsgDlg(Sender: TForm; NoMessageDlg: Boolean);
    procedure ProcEntryDetails;
    procedure ProcLogin;
    procedure ProcManageExp;
    procedure ProcManageUser;
    procedure SetPanelPosAndSize(Sender: TPanel;
      PosTop, PosLeft, SizeHeight, SizeWidth: Longint);
  public
  end;

var
  FrmTopMenu      : TFrmTopMenu;
  LoginFlg        : Boolean = False;
  ChngdAdmUserFlg : Boolean = False;

implementation

uses
  UDBAccess, ULogin, UManageUser, UManageExp,
  UManageDetails;

{$R *.lfm}

{ TFrmTopMenu }

function TFrmTopMenu.Defs: TDefs;
begin
  Result := FDefs;
end;

procedure TFrmTopMenu.ProcEntryDetails;
begin
  Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20070001);

  if AQu.FieldByName('COUNT').AsInteger > 0 then
  begin
    ATr.Active         := False;

    Defs.CloseConn(ACn, ATr);

    if Defs.GetRole = 1 then
    begin;
      FrmManageDetails := TFrmManageDetails.Create(Application);
      OpenFormOrMsgDlg(FrmManageDetails, False);
    end else begin
      MessageDlg(MSG_JP_000024, mtInformation, [mbOk], 0);
    end;
  end else begin
    ATr.Active         := False;

    Defs.CloseConn(ACn, ATr);

    MessageDlg(MSG_JP_000023, mtInformation, [mbOk], 0);
  end;
end;

procedure TFrmTopMenu.ProcLogin;
begin
  if Not LoginFlg then
  begin
    FrmLogin := TFrmLogin.Create(Application);
    OpenFormOrMsgDlg(FrmLogin, True);
  end;
end;

procedure TFrmTopMenu.ProcLogout;
begin
  if LoginFlg then
  begin
    BtnEntryDetails.Enabled   := False;

    BtnManageUser.Enabled      := False;
    BtnManageExp.Enabled       := False;

    BtnLogin.Visible           := True;
    BtnLogin.Enabled           := True;

    BtnLogout.Visible          := False;
    BtnLogout.Enabled          := False;

    FrmTopMenu.Caption         := APP_NAME;

    LoginFlg                   := False;
  end;
end;

procedure TFrmTopMenu.ProcManageExp;
begin
  Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20070001);

  if AQu.FieldByName('COUNT').AsInteger > 0 then
  begin
    ATr.Active      := False;

    Defs.CloseConn(ACn, ATr);

    FrmManageExp      := TFrmManageExp.Create(Application);
    OpenFormOrMsgDlg(FrmManageExp, False);
  end else begin
    ATr.Active      := False;

    Defs.CloseConn(ACn, ATr);

    MessageDlg(MSG_JP_000023, mtInformation, [mbOk], 0);
  end;
end;

procedure TFrmTopMenu.ProcManageUser;
begin
  Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20070001);

  ATr.Active      := False;

  Defs.CloseConn(ACn, ATr);

  FrmManageUser     := TFrmManageUser.Create(Application);
  OpenFormOrMsgDlg(FrmManageUser, False);
end;

procedure TFrmTopMenu.OpenFormOrMsgDlg(Sender: TForm; NoMessageDlg: Boolean);
begin
  if LoginFlg then
  begin
    FrmTopMenu.Visible         := False;
    Sender.Show;
  end else begin // LoginFlg = False
    if NoMessageDlg then
    begin
      FrmTopMenu.Visible       := False;
      Sender.Show;
    end else begin // NoMessageDlg = False
      MessageDlg(MSG_JP_000001, mtInformation, [mbOk], 0);
    end;
  end;
end;

procedure TFrmTopMenu.SetPanelPosAndSize(Sender: TPanel; PosTop, PosLeft, SizeHeight, SizeWidth: Longint);
begin
  Sender.Top    := PosTop;
  Sender.Left   := PosLeft;
  Sender.Height := SizeHeight;
  Sender.Width  := SizeWidth;
end;

procedure TFrmTopMenu.OpenFormEntryAdmin;
begin
  if Not FileExists(DB_NAME) then
  begin
    ProcLogout;

    FrmEntryAdmin := TFrmEntryAdmin.Create(Application);
    FrmEntryAdmin.ShowModal;
  end;
end;

procedure TFrmTopMenu.ActEntryDetailsExecute(Sender: TObject);
begin
  ProcEntryDetails;
end;

procedure TFrmTopMenu.ActLoginExecute(Sender: TObject);
begin
  ProcLogin;
end;

procedure TFrmTopMenu.ActLogoutExecute(Sender: TObject);
begin
  ProcLogout;
end;

procedure TFrmTopMenu.ActManageExpExecute(Sender: TObject);
begin
  ProcManageExp;
end;

procedure TFrmTopMenu.ActManageUserExecute(Sender: TObject);
begin
  ProcManageUser;
end;

procedure TFrmTopMenu.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmTopMenu.FormActivate(Sender: TObject);
begin
  FrmTopMenu.WindowState       := wsMaximized;
  FrmTopMenu.WindowState       := wsNormal;
end;

procedure TFrmTopMenu.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;

  CloseAction := caFree;
  FrmTopMenu  := nil;
end;

procedure TFrmTopMenu.FormCreate(Sender: TObject);
var
  LFS : TFormatSettings;
begin
  FDefs := TDefs.Create;

  // Initialize
  LFS.DateSeparator        := '/';
  LFS.ShortDateFormat      := 'yyyy-mm-dd';
  LFS.TimeSeparator        := ':';
  LFS.ShortTimeFormat      := 'hh:nn:ss';
  Defs.SetFS(LFS);
end;

procedure TFrmTopMenu.FormShow(Sender: TObject);
var
  LHeight : Longint = 52;
  LWidth  : Longint = 572;
begin
  FrmTopMenu.Color       := RGB(  0, 128, 128);
  PnlManageDetails.Color := RGB(192, 220, 192);
  PnlManagements.Color   := RGB(192, 220, 192);
  PnlLogInAndOut.Color   := RGB(192, 220, 192);

  ChngdAdmUserFlg   := False;

  FrmTopMenu.Width  := 634;
  FrmTopMenu.Height := 374;

  if LoginFlg then
  begin
    PnlManageUser.Color := RGB(192, 220, 192);
    PnlManageExp.Color  := RGB(192, 220, 192);
    if Defs.GetRole = 1 then begin;
      BtnEntryDetails.Enabled  := True;
    end;

    BtnManageUser.Enabled := True;
    if Defs.GetRole = 1 then begin;
      BtnManageExp.Enabled  := True;
    end else begin
      BtnManageExp.Enabled  := False;
    end;

    BtnLogin.Enabled := False;

    BtnLogout.Enabled := True;
  end else begin
    BtnEntryDetails.Enabled := False;
    BtnManageUser.Enabled   := False;
    BtnManageExp.Enabled    := False;

    BtnLogin.Visible := True;
    BtnLogin.Enabled := True;

    //PnlLogout.Visible := False;
    //PnlLogout.Enabled := False;
    BtnLogout.Visible := False;
    BtnLogout.Enabled := False;
  end;

  SetPanelPosAndSize(PnlManageUser,    9 , 9, LHeight, LWidth + 2);
  SetPanelPosAndSize(PnlManageExp,     64, 9, LHeight, LWidth + 2);
  SetPanelPosAndSize(PnlEntryDetails,  9 , 9, LHeight, LWidth + 2);
  SetPanelPosAndSize(PnlLogin,         9 , 9, LHeight, LWidth + 0);
  SetPanelPosAndSize(PnlLogout,        9 , 9, LHeight, LWidth + 0);
  SetPanelPosAndSize(PnlQuit,          66, 9, LHeight, LWidth + 2);
end;

procedure TFrmTopMenu.TimerTimer(Sender: TObject);
begin
  if Not Assigned(FrmEntryAdmin) then
  begin
    OpenFormEntryAdmin;
  end;

  if ChngdAdmUserFlg then
  begin
    ProcLogout;
    ChngdAdmUserFlg            := False;
  end;

  if LoginFlg then
  begin
    BtnManageUser.Visible      := True;
    BtnManageExp.Visible       := True;

    BtnLogin.Visible           := False;
    BtnLogin.Enabled           := False;

    BtnLogout.Visible          := True;
    BtnLogout.Enabled          := True;
  end;
end;

end.
