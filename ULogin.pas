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
    SetDatabaseName(ACn      );
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
  if LoginFlg = False then
  begin
    try
      with ACn do begin
        if Not Connected then
        begin
          DatabaseName := DB_NAME;
          ATr.DataBase := ACn;
          AQu.Database := ACn;
          ADS.DataSet  := AQu;
        end else begin
          ATr.DataBase := ACn;
          AQu.Database := ACn;
          ADS.DataSet  := AQu;
          Close;
        end;
      end;

      with AQu do begin
        ACn.Open;
        SQL.Text := SQL_20010001;
        with Params do begin
          ParamByName('pUName').AsUTF8String := FrmLogin.EdtUserName.Text;
          ParamByName('pPaw').AsString       := FrmLogin.EdtPaw.Text;
        end;
        ATr.StartTransaction;

        Open;
      end;

      while Not AQu.EOF do
      begin
        LUID   := AQu.FieldByName('USER_ID').AsInteger;
        FrmTopMenu.Defs.SetUID(LUID);
        LUName := AQu.FieldByName('NAME').AsAnsiString;
        FrmTopMenu.Defs.SetUName(LUName);
        LRole  := AQu.FieldByName('ROLE').AsInteger;
        FrmTopMenu.Defs.SetRole(LRole);

        FrmTopMenu.BtnLogin.Visible  := False;
        FrmTopMenu.BtnLogin.Enabled  := False;
        FrmTopMenu.BtnLogout.Visible := True;
        FrmTopMenu.BtnLogout.Enabled := True;

        FrmTopMenu.Caption           := FrmTopMenu.Defs.GetUName + MSG_JP_000006;

        FrmTopMenu.PnlManageUser.Color      := clMoneyGreen;
        FrmTopMenu.PnlManageExp.Color       := clMoneyGreen;
        if FrmTopMenu.Defs.GetRole = 1 then
        begin;
          FrmTopMenu.PnlManageDetails.Color := clMoneyGreen;
        end;

        LoginFlg := True;
        AQu.Next;
      end;
      ATr.EndTransaction;

      if Not LoginFlg then
      begin
        MessageDlg(MSG_JP_000007, mtInformation, [mbOk], 0);
      end;
    finally
      if LoginFlg then
      begin
        FrmTopMenu.Visible := True;
        FrmLogin.Close;
      end;
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
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;

  FrmTopMenu.Visible := True;
  CloseAction        := caFree;
  FrmLogin           := nil;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

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

procedure TFrmLogin.FormShow(Sender: TObject);
begin

end;

end.

