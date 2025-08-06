unit ULogin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SQLDB, SQLite3Conn, DB, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, LCLIntf, ActnList;

type

  { TFormLogin }

  { TFrmLogin }

  TFrmLogin = class(TForm)
    ActCancel    : TAction;
    ActClearPaw  : TAction;
    ActionList   : TActionList;
    ActLogin     : TAction;
    ActQuit      : TAction;
    ADS          : TDataSource;
    AQu          : TSQLQuery;
    ATr          : TSQLTransaction;
    BtnCancel    : TButton;
    BtnClearPaw  : TButton;
    BtnLogin     : TButton;
    EdtPaw       : TEdit;
    EdtUserName  : TEdit;
    LblUserName  : TLabel;
    LblPaw       : TLabel;
    pnlLogin     : TPanel;
    pnlCancel    : TPanel;
    pnlClearPaw  : TPanel;
    ACn: TSQLite3Connection;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActClearPawExecute(Sender: TObject);
    procedure ActLoginExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ProcCancel;
    procedure ProcLogin;
  private
    procedure SetDatabaseNames;
  public

  end;

var
  FrmLogin: TFrmLogin;

implementation
uses
  UDBAccess, UConsts, UTopMenu;

{$R *.lfm}

{ TFormLogin }

procedure TFrmLogin.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn);
  end;

end;

procedure TFrmLogin.ProcCancel;
begin
  UTopMenu.LoginFlg  := False;
  FrmTopMenu.Visible := True;
  FrmLogin.Close;
end;

procedure TFrmLogin.ProcLogin;
var
  LUID   : Integer;
  LUName : String;
  LRole  : Integer;
begin
  try
    try
      if LoginFlg = False then begin
        with FrmLogin do begin
          with AQu do begin
            ACn.Open;
            SQL.Text := SQL_20010001;
            with Params do begin
              ParamByName('pUName').AsUTF8String := EdtUserName.Text;
              ParamByName('pPaw').AsString       := EdtPaw.Text;
            end;

            Open;
            First;
            while Not EOF do begin
              with FrmTopMenu do begin
                with Defs do begin
                  LUID   := FieldByName('USER_ID').AsInteger;
                  SetUID(LUID);
                  LUName := FieldByName('NAME').AsAnsiString;
                  SetUName(LUName);
                  LRole  := FieldByName('ROLE').AsInteger;
                  SetRole(LRole);

                  with BtnLogin do begin
                    Visible  := False;
                    Enabled  := False;
                  end;
                  with BtnLogout do begin
                    Visible := True;
                    Enabled := True;
                  end;

                  Caption           := GetUName + MSG_JP_000006;

                  PnlManageUser.Color      := clMoneyGreen;
                  PnlManageExp.Color       := clMoneyGreen;
                  if GetRole = 1 then
                  begin;
                    PnlManageDetails.Color := clMoneyGreen;
                  end;

                  LoginFlg := True;
                end;
              end;
              Next;
            end;
          end;
          ATr.EndTransaction;

          if Not LoginFlg then
          begin
            MessageDlg(MSG_JP_000007, mtInformation, [mbOk], 0);
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
    if LoginFlg then begin
      FrmTopMenu.Visible := True;
      FrmLogin.Close;
    end;
  end;
end;

procedure TFrmLogin.ActClearPawExecute(Sender: TObject);
begin
  EdtPaw.Clear;
end;

procedure TFrmLogin.ActLoginExecute(Sender: TObject);
begin
  ProcLogin;
end;

procedure TFrmLogin.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmLogin.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  with FrmTopMenu do begin
    with Defs do begin
      CloseConn(ACn, ATr);
    end;

    Visible := True;
    CloseAction        := caFree;
    FrmLogin           := nil;
  end;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  FrmLogin.Color    := RGB(112, 168, 175);
  pnlClearPaw.Color := RGB( 72, 122, 129);
  pnlCancel.Color   := RGB( 72, 122, 129);
  pnlLogin.Color    := RGB( 72, 122, 129);

  BtnClearPaw.Visible := True;
  BtnClearPaw.Enabled := True;
  BtnCancel.Visible   := True;
  BtnCancel.Enabled   := True;
  BtnLogIn.Visible    := True;
  BtnLogIn.Enabled    := True;

  EdtUserName.Clear;
  EdtPaw.Clear;

  FrmLogin.Height := 260;
end;

end.

