unit UTopMenu;

{$mode objfpc}{$H+}{$M+}

interface

uses
  Classes, SysUtils, SQLDB, SQLite3Conn, DB, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, ActnList, LCLIntf, UConsts, UDefs,
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
    ACn              : TSQLite3Connection;
    ADS              : TDataSource;
    AQu              : TSQLQuery;
    ATr              : TSQLTransaction;
    BtnEntryDetails  : TButton;
    BtnLogin         : TButton;
    BtnLogout        : TButton;
    BtnManageExp     : TButton;
    BtnManageUser    : TButton;
    BtnQuit          : TButton;
    PnlManageDetails : TPanel;
    PnlLogin         : TPanel;
    PnlLogInAndOut   : TPanel;
    PnlLogout        : TPanel;
    PnlEntryDetails  : TPanel;
    PnlManageExp     : TPanel;
    PnlManagements   : TPanel;
    PnlManageUser    : TPanel;
    PnlQuit          : TPanel;
    Timer            : TTimer;
    procedure SetDatabaseNames;
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

procedure TFrmTopMenu.SetDatabaseNames;
begin
  try
    try
      with Defs do begin
        SetOSHomeDir(GetEnvironmentVariable('APPDATA'));
        SetDBPath(GetOSHomeDir + '\' + DB_DIR);
        SetDBFullPath(GetDBPath + DB_NAME);

        if GetDoExitKakeiBon then begin
          Application.Terminate;
          Exit;
        end;

        ForceDirectories(GetDBPath);
        SetDatabaseName(ACn);
      end;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

function TFrmTopMenu.Defs: TDefs;
begin
  Result := FDefs;
end;

procedure TFrmTopMenu.ProcEntryDetails;
begin
  with Defs do begin
    OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20070001);

    if AQu.FieldByName('COUNT').AsInteger > 0 then
    begin
      ATr.Active         := False;

      CloseConn(ACn, ATr);

      if GetRole = 1 then
      begin;
        FrmManageDetails := TFrmManageDetails.Create(Application);
        OpenFormOrMsgDlg(FrmManageDetails, False);
      end else begin
        MessageDlg(MSG_JP_000024, mtInformation, [mbOk], 0);
      end;
    end else begin
      ATr.Active         := False;

      CloseConn(ACn, ATr);

      MessageDlg(MSG_JP_000023, mtInformation, [mbOk], 0);
    end;
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
    BtnEntryDetails.Enabled := False;

    BtnManageUser.Enabled   := False;
    BtnManageExp.Enabled    := False;

    with BtnLogin do begin
      Visible          := True;
      Enabled          := True;
    end;
    with BtnLogout do begin
      Visible          := False;
      Enabled          := False;
    end;

    FrmTopMenu.Caption := APP_NAME;

    LoginFlg           := False;
  end;
end;

procedure TFrmTopMenu.ProcManageExp;
begin
  with Defs do begin
    OpenSelectQueryWithUserID(ACn, ADS, ATr, AQu, SQL_20070002, GetUID);
    if AQu.FieldByName('COUNT').AsInteger > 0 then
    begin
      ATr.Active      := False;

      CloseConn(ACn, ATr);

      FrmManageExp      := TFrmManageExp.Create(Application);
      OpenFormOrMsgDlg(FrmManageExp, False);
    end else begin
      ATr.Active      := False;

      CloseConn(ACn, ATr);

      MessageDlg(MSG_JP_000023, mtInformation, [mbOk], 0);
    end;
  end;
end;

procedure TFrmTopMenu.ProcManageUser;
begin
  with Defs do begin
    OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20070001);

    ATr.Active      := False;

    CloseConn(ACn, ATr);

    FrmManageUser     := TFrmManageUser.Create(Application);
    OpenFormOrMsgDlg(FrmManageUser, False);
  end;
end;

procedure TFrmTopMenu.OpenFormOrMsgDlg(Sender: TForm; NoMessageDlg: Boolean);
begin
  with FrmTopMenu do begin
    if LoginFlg then
    begin
      Visible         := False;
      Sender.Show;
    end else begin // LoginFlg = False
      if NoMessageDlg then
      begin
        Visible       := False;
        Sender.Show;
      end else begin // NoMessageDlg = False
        MessageDlg(MSG_JP_000001, mtInformation, [mbOk], 0);
      end;
    end;
  end;
end;

procedure TFrmTopMenu.SetPanelPosAndSize(Sender: TPanel; PosTop, PosLeft, SizeHeight, SizeWidth: Longint);
begin
  with Sender do begin
    Top    := PosTop;
    Left   := PosLeft;
    Height := SizeHeight;
    Width  := SizeWidth;
  end;
end;

procedure TFrmTopMenu.OpenFormEntryAdmin;
begin
  with Defs do begin
    if Not FileExists(GetDBFullPath) then
    begin
      ProcLogout;

      FrmEntryAdmin := TFrmEntryAdmin.Create(Application);
      FrmEntryAdmin.ShowModal;
    end;
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
  with FrmTopMenu do begin
    WindowState       := wsMaximized;
    WindowState       := wsNormal;
  end;
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
  LFS        : TFormatSettings;
begin
  FDefs := TDefs.Create;

  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;

    ChngdAdmUserFlg   := False;

    { TFormatSettings }
    with LFS do begin
      DateSeparator        := '/';
      ShortDateFormat      := 'yyyy-mm-dd';
      TimeSeparator        := ':';
      ShortTimeFormat      := 'hh:nn:ss';
    end;
    SetFS(LFS);

    SetDatabaseNames;
  end;
end;

procedure TFrmTopMenu.FormShow(Sender: TObject);
var
  LHeight    : Longint = 52;
  LWidth     : Longint = 572;
begin
  FrmTopMenu.Color       := RGB(  0, 128, 128);
  PnlManageDetails.Color := RGB(192, 220, 192);
  PnlManagements.Color   := RGB(192, 220, 192);
  PnlLogInAndOut.Color   := RGB(192, 220, 192);

  if LoginFlg then
  begin
    PnlManageUser.Color := RGB(192, 220, 192);
    PnlManageExp.Color  := RGB(192, 220, 192);
  end;

  with FrmTopMenu do begin
    Width  := 634;
    Height := 374;
  end;

  with Defs do begin
    if LoginFlg then
    begin
      BtnManageUser.Enabled     := True;

      if GetRole = 1 then begin;
        BtnEntryDetails.Enabled := True;
        BtnManageExp.Enabled    := True;
      end else begin
        BtnEntryDetails.Enabled := False;
        BtnManageExp.Enabled    := False;
      end;

      BtnLogin.Enabled := False;

      BtnLogout.Enabled := True;
    end else begin
      BtnEntryDetails.Enabled := False;
      BtnManageUser.Enabled   := False;
      BtnManageExp.Enabled    := False;

      with BtnLogin do begin
        Visible          := True;
        Enabled          := True;
      end;
      with BtnLogout do begin
        Visible          := False;
        Enabled          := False;
      end;
    end;

    SetPanelPosAndSize(PnlManageUser,    9 , 9, LHeight, LWidth + 2);
    SetPanelPosAndSize(PnlManageExp,     64, 9, LHeight, LWidth + 2);
    SetPanelPosAndSize(PnlEntryDetails,  9 , 9, LHeight, LWidth + 2);
    SetPanelPosAndSize(PnlLogin,         9 , 9, LHeight, LWidth + 0);
    SetPanelPosAndSize(PnlLogout,        9 , 9, LHeight, LWidth + 0);
    SetPanelPosAndSize(PnlQuit,          66, 9, LHeight, LWidth + 2);
  end;
end;

procedure TFrmTopMenu.TimerTimer(Sender: TObject);
begin
  with Defs do begin
    if (Not Assigned(FrmEntryAdmin))
        And (Not FileExists(GetDBFullPath)) then
    begin
      OpenFormEntryAdmin;
    end;

    if ChngdAdmUserFlg then
    begin
      ProcLogout;
      ChngdAdmUserFlg           := False;
    end;

    if LoginFlg then
    begin
      BtnManageUser.Enabled     := True;
      if GetRole = 1 then begin
        BtnEntryDetails.Enabled := True;
        BtnManageExp.Enabled    := True;
      end;

      with BtnLogin do begin
        Visible          := False;
        Enabled          := False;
      end;
      with BtnLogout do begin
        Visible          := True;
        Enabled          := True;
      end;
    end;
  end;
end;

end.
