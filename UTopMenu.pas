unit UTopMenu;

{$mode objfpc}{$H+}{$M+}

interface

uses
  Classes, SysUtils, SQLDB, SQLite3Conn, DB, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, ActnList, LCLIntf, LCLType, UConsts, UDefs,
  UEntryAdmin, USummary;

type

  { TFrmTopMenu }

  TFrmTopMenu = class(TForm)
    ACn                   : TSQLite3Connection;
    ADS                   : TDataSource;
    AQu                   : TSQLQuery;
    ATr                   : TSQLTransaction;
    ActionList            : TActionList;
    ActEntryDetails       : TAction;
    ActSummary            : TAction;
    ActManageUser         : TAction;
    ActManageExp          : TAction;
    ActLogin              : TAction;
    ActLogout             : TAction;
    ActQuit               : TAction;
    Panel1                : TPanel;
    Panel2                : TPanel;
    Panel3                : TPanel;
    Panel4                : TPanel;
    Panel5                : TPanel;
    Panel6                : TPanel;
    Panel7                : TPanel;
    Panel8                : TPanel;
    Panel9                : TPanel;
    Panel10               : TPanel;
    Panel11               : TPanel;
    Panel12               : TPanel;
    Panel13               : TPanel;
    Panel14               : TPanel;
    Panel15               : TPanel;
    Panel16               : TPanel;
    Panel17               : TPanel;
    Panel18               : TPanel;
    Panel19               : TPanel;
    Panel20               : TPanel;
    Panel21               : TPanel;
    Panel22               : TPanel;
    Panel23               : TPanel;
    Panel24               : TPanel;
    Panel25               : TPanel;
    Panel26               : TPanel;
    Panel27               : TPanel;
    Panel28               : TPanel;
    Panel29               : TPanel;
    Panel30               : TPanel;
    Panel31               : TPanel;
    Panel32               : TPanel;
    Panel33               : TPanel;
    Panel34               : TPanel;
    Panel35               : TPanel;
    Panel36               : TPanel;
    Panel37               : TPanel;
    Panel38               : TPanel;
    Panel39               : TPanel;
    Panel40               : TPanel;
    Panel41               : TPanel;
    Panel42               : TPanel;
    Panel43               : TPanel;
    BtnEnterDetails : TPanel;
    BtnSummary       : TPanel;
    BtnEnterManageUser    : TPanel;
    BtnEnterManageExp     : TPanel;
    BtnLogin              : TPanel;
    BtnLogout             : TPanel;
    BtnQuit               : TPanel;
    PnlManageDetails      : TPanel;
    PnlEntryDetails       : TPanel;
    PnlSummary            : TPanel;
    PnlEnterSummary       : TPanel;
    PnlManagements        : TPanel;
    PnlManageUser         : TPanel;
    PnlManageExp          : TPanel;
    PnlLogInAndOut        : TPanel;
    PnlLogin              : TPanel;
    PnlLogout             : TPanel;
    PnlQuit               : TPanel;
    Timer                 : TTimer;
    procedure ActEntryDetailsExecute(Sender: TObject);
    procedure ActSummaryExecute(Sender: TObject);
    procedure BtnEnterManageExpEnter(Sender: TObject);
    procedure BtnEnterManageExpExit(Sender: TObject);
    procedure BtnLoginEnter(Sender: TObject);
    procedure BtnLoginExit(Sender: TObject);
    procedure BtnLogoutEnter(Sender: TObject);
    procedure BtnLogoutExit(Sender: TObject);
    procedure BtnQuitEnter(Sender: TObject);
    procedure BtnQuitExit(Sender: TObject);
    procedure ManageDetailsMouseOver(NewColor: TColor);
    procedure BtnEnterDetailsEnter(Sender: TObject);
    procedure BtnEnterDetailsExit(Sender: TObject);
    procedure SummaryMouseOver(NewColor: TColor);
    procedure BtnSummaryEnter(Sender: TObject);
    procedure BtnSummaryExit(Sender: TObject);
    procedure ManageUserMouseOver(NewColor: TColor);
    procedure BtnEnterManageUserEnter(Sender: TObject);
    procedure BtnEnterManageUserExit(Sender: TObject);
    procedure ManageExpMouseOver(NewColor: TColor);
    procedure LoginMouseOver(NewColor: TColor);
    procedure LogoutMouseOver(NewColor: TColor);
    procedure QuitMouseOver(NewColor: TColor);
    procedure ProcManageDetails(Sender: TObject);
    procedure ProcSummary(Sender: TObject);
    procedure ProcManageUser(Sender: TObject);
    procedure ProcManageExp(Sender: TObject);
    procedure ProcLogin(Sender: TObject);
    procedure ProcLogout(Sender: TObject);
    procedure ProcQuit(Sender: TObject);
    procedure SetDatabaseNames;
    procedure ActLoginExecute(Sender: TObject);
    procedure ActLogoutExecute(Sender: TObject);
    procedure ActManageExpExecute(Sender: TObject);
    procedure ActManageUserExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    function Defs: TDefs;
  private
    FDefs            : TDefs;
    procedure CloseTransactions;
    procedure OpenFormEntryAdmin(Sender: TObject);
    procedure OpenFormOrMsgDlg(Sender: TForm; NoMessageDlg: Boolean);
    procedure SetBtnEnterManageDetailsEnabled(IsEnable: Boolean);
    procedure SetBtnEnterSummaryEnabled(IsEnable: Boolean);
    procedure SetBtnEnterManageUserEnabled(IsEnable: Boolean);
    procedure SetBtnEnterManageExpEnabled(IsEnable: Boolean);
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

procedure TFrmTopMenu.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;
end;

function TFrmTopMenu.Defs: TDefs;
begin
  Result := FDefs;
end;

procedure TFrmTopMenu.ManageDetailsMouseOver(NewColor: TColor);
begin
  BtnEnterDetails.Color := NewColor;
  Panel37.Color               := NewColor;
  Panel1.Color                := NewColor;
  Panel2.Color                := NewColor;
  Panel3.Color                := NewColor;
  Panel4.Color                := NewColor;
  Panel5.Color                := NewColor;
end;

procedure TFrmTopMenu.BtnEnterDetailsEnter(Sender: TObject);
begin
  ManageDetailsMouseOver(clSkyBlue);
  SummaryMouseOver(clBtnFace);
  ManageUserMouseOver(clBtnFace);
  ManageExpMouseOver(clBtnFace);
  LoginMouseOver(clBtnFace);
  LogoutMouseOver(clBtnFace);
  QuitMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.BtnEnterDetailsExit(Sender: TObject);
begin
  ManageDetailsMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.SummaryMouseOver(NewColor: TColor);
begin
  BtnSummary.Color := NewColor;
  Panel38.Color         := NewColor;
  Panel6.Color          := NewColor;
  Panel7.Color          := NewColor;
end;

procedure TFrmTopMenu.BtnSummaryEnter(Sender: TObject);
begin
  ManageDetailsMouseOver(clBtnFace);
  SummaryMouseOver(clSkyBlue);
  ManageUserMouseOver(clBtnFace);
  ManageExpMouseOver(clBtnFace);
  LoginMouseOver(clBtnFace);
  LogoutMouseOver(clBtnFace);
  QuitMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.BtnSummaryExit(Sender: TObject);
begin
  SummaryMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.ManageUserMouseOver(NewColor: TColor);
begin
  BtnEnterManageUser.Color := NewColor;
  Panel39.Color            := NewColor;
  Panel8.Color             := NewColor;
  Panel9.Color             := NewColor;
  Panel10.Color            := NewColor;
  Panel11.Color            := NewColor;
  Panel12.Color            := NewColor;
end;

procedure TFrmTopMenu.BtnEnterManageUserEnter(Sender: TObject);
begin
  ManageDetailsMouseOver(clBtnFace);
  SummaryMouseOver(clBtnFace);
  ManageUserMouseOver(clSkyBlue);
  ManageExpMouseOver(clBtnFace);
  LoginMouseOver(clBtnFace);
  LogoutMouseOver(clBtnFace);
  QuitMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.BtnEnterManageUserExit(Sender: TObject);
begin
  ManageUserMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.ManageExpMouseOver(NewColor: TColor);
begin
  BtnEnterManageExp.Color := NewColor;
  Panel40.Color           := NewColor;
  Panel13.Color           := NewColor;
  Panel14.Color           := NewColor;
  Panel15.Color           := NewColor;
  Panel16.Color           := NewColor;
end;

procedure TFrmTopMenu.BtnEnterManageExpEnter(Sender: TObject);
begin
  ManageDetailsMouseOver(clBtnFace);
  SummaryMouseOver(clBtnFace);
  ManageUserMouseOver(clBtnFace);
  ManageExpMouseOver(clSkyBlue);
  LoginMouseOver(clBtnFace);
  LogoutMouseOver(clBtnFace);
  QuitMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.BtnEnterManageExpExit(Sender: TObject);
begin
  ManageExpMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.LoginMouseOver(NewColor: TColor);
begin
  BtnLogin.Color := NewColor;
  Panel41.Color  := NewColor;
  Panel17.Color  := NewColor;
  Panel18.Color  := NewColor;
  Panel19.Color  := NewColor;
  Panel20.Color  := NewColor;
end;

procedure TFrmTopMenu.BtnLoginEnter(Sender: TObject);
begin
  ManageDetailsMouseOver(clBtnFace);
  SummaryMouseOver(clBtnFace);
  ManageUserMouseOver(clBtnFace);
  ManageExpMouseOver(clBtnFace);
  LoginMouseOver(clSkyBlue);
  LogoutMouseOver(clBtnFace);
  QuitMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.BtnLoginExit(Sender: TObject);
begin
  LoginMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.LogoutMouseOver(NewColor: TColor);
begin
  BtnLogout.Color := NewColor;
  Panel42.Color   := NewColor;
  Panel21.Color   := NewColor;
  Panel22.Color   := NewColor;
  Panel23.Color   := NewColor;
  Panel24.Color   := NewColor;
  Panel25.Color   := NewColor;
end;

procedure TFrmTopMenu.BtnLogoutEnter(Sender: TObject);
begin
  ManageDetailsMouseOver(clBtnFace);
  SummaryMouseOver(clBtnFace);
  ManageUserMouseOver(clBtnFace);
  ManageExpMouseOver(clBtnFace);
  LoginMouseOver(clBtnFace);
  LogoutMouseOver(clSkyBlue);
  QuitMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.BtnLogoutExit(Sender: TObject);
begin
  LogoutMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.QuitMouseOver(NewColor: TColor);
begin
  BtnQuit.Color := NewColor;
  Panel43.Color := NewColor;
  Panel26.Color := NewColor;
  Panel27.Color := NewColor;
  Panel28.Color := NewColor;
  Panel29.Color := NewColor;
  Panel30.Color := NewColor;
  Panel31.Color := NewColor;
  Panel32.Color := NewColor;
  Panel33.Color := NewColor;
  Panel34.Color := NewColor;
  Panel35.Color := NewColor;
  Panel36.Color := NewColor;
end;

procedure TFrmTopMenu.BtnQuitEnter(Sender: TObject);
begin
  ManageDetailsMouseOver(clBtnFace);
  SummaryMouseOver(clBtnFace);
  ManageUserMouseOver(clBtnFace);
  ManageExpMouseOver(clBtnFace);
  LoginMouseOver(clBtnFace);
  LogoutMouseOver(clBtnFace);
  QuitMouseOver(clSkyBlue);
end;

procedure TFrmTopMenu.BtnQuitExit(Sender: TObject);
begin
  QuitMouseOver(clBtnFace);
end;

procedure TFrmTopMenu.ProcManageDetails(Sender: TObject);
begin
  with Defs do begin
    OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20070001);

    if AQu.FieldByName('COUNT').AsInteger > 0 then begin
      ATr.Active         := False;

      CloseConn(ACn, ATr);
      SetDatabaseNames;

      if GetRole = 1 then begin;
        FrmManageDetails := TFrmManageDetails.Create(Application);
        OpenFormOrMsgDlg(FrmManageDetails, False);
      end else begin
        MessageDlg(MSG_JP_000024, mtInformation, [mbOk], 0);
      end;
    end else begin
      ATr.Active         := False;

      CloseConn(ACn, ATr);
      SetDatabaseNames;

      MessageDlg(MSG_JP_000023, mtInformation, [mbOk], 0);
    end;
  end;
end;

procedure TFrmTopMenu.ProcSummary(Sender: TObject);
begin
  FrmSummary := TFrmSummary.Create(Application);
  OpenFormOrMsgDlg(FrmSummary, False);
end;

procedure TFrmTopMenu.ProcManageUser(Sender: TObject);
begin
  with Defs do begin
    OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20070001);

    ATr.Active      := False;

    CloseConn(ACn, ATr);
    SetDatabaseNames;

    FrmManageUser     := TFrmManageUser.Create(Application);
    OpenFormOrMsgDlg(FrmManageUser, False);
  end;
end;

procedure TFrmTopMenu.ProcManageExp(Sender: TObject);
begin
  with Defs do begin
    OpenSelectQueryWithUserID(ACn, ADS, ATr, AQu, SQL_20070002, GetUID);
    if AQu.FieldByName('COUNT').AsInteger > 0 then begin
      ATr.Active      := False;

      CloseConn(ACn, ATr);
      SetDatabaseNames;

      FrmManageExp      := TFrmManageExp.Create(Application);
      OpenFormOrMsgDlg(FrmManageExp, False);
    end else begin
      ATr.Active      := False;

      CloseConn(ACn, ATr);
      SetDatabaseNames;

      MessageDlg(MSG_JP_000023, mtInformation, [mbOk], 0);
    end;
  end;
end;

procedure TFrmTopMenu.ProcLogin(Sender: TObject);
begin
  if Not LoginFlg then begin
    FrmLogin := TFrmLogin.Create(Application);
    OpenFormOrMsgDlg(FrmLogin, True);
  end;
end;

procedure TFrmTopMenu.ProcLogout(Sender: TObject);
begin
  if LoginFlg then begin
    SetBtnEnterManageDetailsEnabled(False);
    SetBtnEnterSummaryEnabled(False);
    SetBtnEnterManageUserEnabled(False);
    SetBtnEnterManageExpEnabled(False);

    with PnlLogin do begin
      Visible          := True;
      Enabled          := True;
    end;
    with BtnLogin do begin
      Visible          := True;
      Enabled          := True;
    end;

    with PnlLogout do begin
      Visible          := False;
      Enabled          := False;
    end;

    FrmTopMenu.Caption := APP_NAME;

    LoginFlg           := False;
  end;
end;

procedure TFrmTopMenu.ProcQuit(Sender: TObject);
begin
  Close;
end;

procedure TFrmTopMenu.ActEntryDetailsExecute(Sender: TObject);
begin
  ProcManageDetails(Sender);
end;

procedure TFrmTopMenu.ActSummaryExecute(Sender: TObject);
begin
  ProcSummary(Sender);
end;

procedure TFrmTopMenu.OpenFormOrMsgDlg(Sender: TForm; NoMessageDlg: Boolean);
begin
  with FrmTopMenu do begin
    if LoginFlg then begin
      Visible         := False;
      Sender.Show;
    end else begin // LoginFlg = False
      if NoMessageDlg then begin
        Visible       := False;
        Sender.Show;
      end else begin // NoMessageDlg = False
        MessageDlg(MSG_JP_000001, mtInformation, [mbOk], 0);
      end;
    end;
  end;
end;

procedure TFrmTopMenu.SetBtnEnterManageDetailsEnabled(IsEnable: Boolean);
begin
  BtnEnterDetails.Enabled := IsEnable;
  Panel37.Enabled               := IsEnable;
  Panel1.Enabled                := IsEnable;
  Panel2.Enabled                := IsEnable;
  Panel3.Enabled                := IsEnable;
  Panel4.Enabled                := IsEnable;
  Panel5.Enabled                := IsEnable;
end;

procedure TFrmTopMenu.SetBtnEnterSummaryEnabled(IsEnable: Boolean);
begin
  BtnSummary.Enabled := IsEnable;
  Panel38.Enabled         := IsEnable;
  Panel6.Enabled          := IsEnable;
  Panel7.Enabled          := IsEnable;
end;

procedure TFrmTopMenu.SetBtnEnterManageUserEnabled(IsEnable: Boolean);
begin
  BtnEnterManageUser.Enabled := IsEnable;
  Panel39.Enabled            := IsEnable;
  Panel8.Enabled             := IsEnable;
  Panel9.Enabled             := IsEnable;
  Panel10.Enabled            := IsEnable;
  Panel11.Enabled            := IsEnable;
  Panel12.Enabled            := IsEnable;
end;

procedure TFrmTopMenu.SetBtnEnterManageExpEnabled(IsEnable: Boolean);
begin
  BtnEnterManageExp.Enabled := IsEnable;
  Panel40.Enabled           := IsEnable;
  Panel13.Enabled           := IsEnable;
  Panel14.Enabled           := IsEnable;
  Panel15.Enabled           := IsEnable;
  Panel16.Enabled           := IsEnable;
end;

procedure TFrmTopMenu.OpenFormEntryAdmin(Sender: TObject);
begin
  with Defs do begin
    if Not FileExists(GetDBFullPath) then begin
      ProcLogout(Sender);

      FrmEntryAdmin := TFrmEntryAdmin.Create(Application);
      FrmEntryAdmin.ShowModal;
    end;
  end;
end;

procedure TFrmTopMenu.ActLoginExecute(Sender: TObject);
begin
  ProcLogin(Sender);
end;

procedure TFrmTopMenu.ActLogoutExecute(Sender: TObject);
begin
  ProcLogout(Sender);
end;

procedure TFrmTopMenu.ActManageExpExecute(Sender: TObject);
begin
  ProcManageExp(Sender);
end;

procedure TFrmTopMenu.ActManageUserExecute(Sender: TObject);
begin
  ProcManageUser(Sender);
end;

procedure TFrmTopMenu.ActQuitExecute(Sender: TObject);
begin
  ProcQuit(Sender);
end;

procedure TFrmTopMenu.FormActivate(Sender: TObject);
begin
  with FrmTopMenu do begin
    WindowState       := wsMaximized;
    WindowState       := wsNormal;
  end;
end;

procedure TFrmTopMenu.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseTransactions;

  CloseAction := caFree;
  FrmTopMenu  := nil;
end;

procedure TFrmTopMenu.FormCreate(Sender: TObject);
var
  LFS : TFormatSettings;
begin
  FDefs := TDefs.Create;

  SetDatabaseNames;

  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;

    ChngdAdmUserFlg := False;

    { TFormatSettings }
    with LFS do begin
      DateSeparator   := '/';
      ShortDateFormat := 'yyyy-mm-dd';
      TimeSeparator   := ':';
      ShortTimeFormat := 'hh:nn:ss';
    end;
    SetFS(LFS);
  end;
end;

procedure TFrmTopMenu.FormShow(Sender: TObject);
var
  Key   : Word;
  Shift : TShiftState;
begin
  FrmTopMenu.KeyPreview := True;

  FrmTopMenu.Color       := RGB(  0, 128, 128);
  PnlManageDetails.Color := RGB(192, 220, 192);
  PnlManagements.Color   := RGB(192, 220, 192);
  PnlLogInAndOut.Color   := RGB(192, 220, 192);

  SetBtnEnterManageDetailsEnabled(False);
  SetBtnEnterSummaryEnabled(False);
  SetBtnEnterManageUserEnabled(False);
  SetBtnEnterManageExpEnabled(False);

  if LoginFlg then begin
    PnlManageUser.Color := RGB(192, 220, 192);
    PnlManageExp.Color  := RGB(192, 220, 192);
  end;

  with FrmTopMenu do begin
    Width  := 634;
    Height := 464;
  end;

  with Defs do begin
    if LoginFlg then begin
      SetBtnEnterManageUserEnabled(True);

      if GetRole = ROLE_USER then begin;
        SetBtnEnterManageDetailsEnabled(True);
        SetBtnEnterSummaryEnabled(True);
        //SetBtnEnterManageUserEnabled(True);
        SetBtnEnterManageExpEnabled(True);
      end else begin
        SetBtnEnterManageDetailsEnabled(False);
        SetBtnEnterSummaryEnabled(False);
        //SetBtnEnterManageUserEnabled(True);
        SetBtnEnterManageExpEnabled(False);
      end;

      with PnlLogin do begin
        Visible := False;
        Enabled := False;
      end;

      with PnlLogout do begin
        Visible := True;
        Enabled := True;
      end;
    end else begin
      SetBtnEnterManageDetailsEnabled(False);
      SetBtnEnterSummaryEnabled(False);
      SetBtnEnterManageUserEnabled(False);
      SetBtnEnterManageExpEnabled(False);

      with PnlLogin do begin
        Visible          := True;
        Enabled          := True;
      end;

      with PnlLogout do begin
        Visible          := False;
        Enabled          := False;
      end;
    end;
  end;
end;

procedure TFrmTopMenu.TimerTimer(Sender: TObject);
begin
  with Defs do begin
    if (Not Assigned(FrmEntryAdmin))
        And (Not FileExists(GetDBFullPath)) then begin
      OpenFormEntryAdmin(Sender);
    end;

    if ChngdAdmUserFlg then begin
      ProcLogout(Sender);
      ChngdAdmUserFlg           := False;
    end;

    if LoginFlg then begin
      SetBtnEnterManageUserEnabled(True);
      if GetRole = ROLE_USER then begin
        SetBtnEnterManageDetailsEnabled(True);
        SetBtnEnterManageExpEnabled(True);
      end;

      with PnlLogin do begin
        Visible                 := False;
        Enabled                 := False;
      end;

      with PnlLogout do begin
        Visible                 := True;
        Enabled                 := True;
      end;
    end else begin
      with PnlLogin do begin
        Visible                 := True;
        Enabled                 := True;
      end;
      with BtnLogin do begin
        Visible                 := True;
        Enabled                 := True;
      end;

      with PnlLogout do begin
        Visible                 := False;
        Enabled                 := False;
      end;
    end;
  end;
end;

procedure TFrmTopMenu.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnEnterDetails' then begin
      ActEntryDetails.Execute;
    end else if ActiveControl.Name = 'BtnSummary' then begin
      ActSummary.Execute;
    end else if ActiveControl.Name = 'BtnEnterManageUser' then begin
      ActManageUser.Execute;
    end else if ActiveControl.Name = 'BtnEnterManageExp' then begin
      ActManageExp.Execute;
    end else if ActiveControl.Name = 'BtnLogin' then begin
      ActLogin.Execute;
    end else if ActiveControl.Name = 'BtnLogout' then begin
      ActLogout.Execute;
    end else if ActiveControl.Name = 'BtnQuit' then begin
      ActQuit.Execute;
    end;
  end;
end;

end.
