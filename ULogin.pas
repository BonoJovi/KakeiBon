unit ULogin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SQLDB, SQLite3Conn, DB, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, LCLIntf, LCLType, ActnList;

type

  { TFormLogin }

  { TFrmLogin }

  TFrmLogin = class(TForm)
    { ActionLists }
    ActionList   : TActionList;
    ActClearPaw  : TAction;
    ActCancel    : TAction;
    ActLogin     : TAction;
    ActGoBack    : TAction;
    ADS: TDataSource;
    { Etc }
    LblUserName  : TLabel;
    Shape1       : TShape;
    EdtUserName  : TEdit;
    LblPaw       : TLabel;
    Shape2       : TShape;
    EdtPaw       : TEdit;
    pnlClearPaw  : TPanel;
    BtnClearPaw  : TPanel;
    pnlCancel    : TPanel;
    BtnCancel    : TPanel;
    pnlLogin     : TPanel;
    BtnLogin     : TPanel;
    AQu: TSQLQuery;
    procedure FormDestroy(Sender: TObject);
    procedure ProcClearPaw(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcLogin(Sender: TObject);
    procedure ClearPawMouseOver(NewColor: TColor);
    procedure BtnClearPawEnter(Sender: TObject);
    procedure BtnClearPawExit(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure LoginMouseOver(NewColor: TColor);
    procedure BtnLoginEnter(Sender: TObject);
    procedure BtnLoginExit(Sender: TObject);
    procedure EdtUserNameEnter(Sender: TObject);
    procedure EdtUserNameExit(Sender: TObject);
    procedure EdtPawEnter(Sender: TObject);
    procedure EdtPawExit(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActClearPawExecute(Sender: TObject);
    procedure ActLoginExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure EdtPawChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
  end;

var
  FrmLogin: TFrmLogin;

implementation
uses
  UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu;

{$R *.lfm}

{ TFormLogin }

procedure TFrmLogin.ClearPawMouseOver(NewColor: TColor);
begin
  BtnClearPaw.Color := NewColor;
end;

procedure TFrmLogin.BtnClearPawEnter(Sender: TObject);
begin
  ClearPawMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  LoginMouseOver(clBtnFace);
end;

procedure TFrmLogin.BtnClearPawExit(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
end;

procedure TFrmLogin.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmLogin.BtnCancelEnter(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  LoginMouseOver(clBtnFace);
end;

procedure TFrmLogin.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmLogin.EdtPawEnter(Sender: TObject);
begin
  Shape2.Visible := True;
end;

procedure TFrmLogin.EdtPawExit(Sender: TObject);
begin
  Shape2.Visible := False;
end;

procedure TFrmLogin.EdtUserNameEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmLogin.EdtUserNameExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmLogin.LoginMouseOver(NewColor: TColor);
begin
  BtnLogin.Color := NewColor;
end;

procedure TFrmLogin.BtnLoginEnter(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
    LoginMouseOver(clSkyBlue);
end;

procedure TFrmLogin.BtnLoginExit(Sender: TObject);
begin
  LoginMouseOver(clBtnFace);
end;

procedure TFrmLogin.ProcClearPaw(Sender: TObject);
begin
  EdtPaw.Clear;
end;

procedure TFrmLogin.ProcCancel(Sender: TObject);
begin
  UTopMenu.LoginFlg  := False;
  FrmTopMenu.Visible := True;
  FrmLogin.Close;
end;

procedure TFrmLogin.ProcLogin(Sender: TObject);
var
  LUID   : Integer;
  LUName : String;
  LRole  : Integer;
begin
  try
    try
      if LoginFlg = False then begin
        with CommonDB do begin
          with Defs do begin
            with AQu do begin
              SQLConnection  := ACn;
              //SQLTransaction := ATr;

              //ACn.Open;
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
                    if GetRole = 1 then begin;
                      PnlManageDetails.Color := clMoneyGreen;
                    end;

                    LoginFlg := True;
                  end;
                end;
                Next;
              end;
            end;
            ATr.EndTransaction;

            if Not LoginFlg then begin
              MessageDlg(MSG_JP_000007, mtInformation, [mbOk], 0);
            end;
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
  ProcClearPaw(Sender);
end;

procedure TFrmLogin.ActLoginExecute(Sender: TObject);
begin
  ProcLogin(Sender);
end;

procedure TFrmLogin.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmLogin.EdtPawChange(Sender: TObject);
begin
  if Length(EdtPaw.Text) > 0 then begin
    BtnClearPaw.Enabled := True;
  end else begin
    BtnClearPaw.Enabled := False;
  end;
end;

procedure TFrmLogin.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TFrmLogin.FormDestroy(Sender: TObject);
begin
  //with CommonDB.Defs do begin
  //  CloseAllDB;
  //end;

  with FrmTopMenu do begin
    Visible     := True;
  end;

  FrmLogin    := nil;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  with Defs do begin
    //SetDatabaseNames;

    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  FrmLogin.Width      := 585;

  FrmLogin.KeyPreview := True;

  FrmLogin.Color    := RGB(112, 168, 175);
  pnlClearPaw.Color := RGB( 72, 122, 129);
  pnlCancel.Color   := RGB( 72, 122, 129);
  pnlLogin.Color    := RGB( 72, 122, 129);

  BtnClearPaw.Enabled := False;
  BtnCancel.Enabled   := True;
  BtnLogIn.Enabled    := True;

  EdtUserName.Clear;
  EdtPaw.Clear;

  { Debug }
  //FrmLogin.Width      := 716;
end;

procedure TFrmLogin.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnClearPaw' then begin
      ActClearPaw.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnLogin' then begin
      ActLogin.Execute;
    end;
  end;
end;

end.

