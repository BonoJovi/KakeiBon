unit UDeleteUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LazUTF8, SysUtils, DB, SQLDB, SQLite3Conn, Forms, Controls, Graphics,
  Dialogs, DBCtrls, DBGrids, StdCtrls, ExtCtrls, LCLIntf, LCLType, ActnList;

type

  { TFrmDeleteUser }

  TFrmDeleteUser = class(TForm)
    ACn            : TSQLite3Connection;
    ADS            : TDataSource;
    ATr            : TSQLTransaction;
    AQu            : TSQLQuery;
    ActionList     : TActionList;
    ActCancel      : TAction;
    ActDeleteUser  : TAction;
    ActQuit        : TAction;
    ADBGrid        : TDBGrid;
    BtnCancel      : TButton;
    DBNav          : TDBNavigator;
    DBTextUserId   : TDBText;
    DBTextName     : TDBText;
    DBTextRole     : TDBText;
    DBTextEntryDT  : TDBText;
    DBTextUpdateDT : TDBText;
    LblEntryDT1    : TLabel;
    LblEntryDT2    : TLabel;
    LblEntryDT3    : TLabel;
    LblName2       : TLabel;
    LblName3       : TLabel;
    LblName4       : TLabel;
    LblName1       : TLabel;
    LblRole1       : TLabel;
    LblRole2       : TLabel;
    LblUpdateDT1   : TLabel;
    LblUpdateDT2   : TLabel;
    LblUpdateDT3   : TLabel;
    LblUserId1     : TLabel;
    LblUserId2     : TLabel;
    LblUserId3     : TLabel;
    LblUserId4     : TLabel;
    LblUserId5     : TLabel;
    BtnDeleteUser  : TPanel;
    PnlCancel      : TPanel;
    PnlDeleteUser  : TPanel;
    procedure ProcCancel(Sender: TObject);
    procedure ProcDeleteUser(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure DeleteUserMouseOver(NewColor: TColor);
    procedure BtnDeleteUserEnter(Sender: TObject);
    procedure BtnDeleteUserExit(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActDeleteUserExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure SetDatabaseNames;
    procedure CloseTransactions;
  public

  end;

var
  FrmDeleteUser: TFrmDeleteUser;

implementation
uses
  UConsts, UDBAccess, UTopMenu, UManageUser;

{$R *.lfm}

{ TFrmDeleteUser }

procedure TFrmDeleteUser.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn);
  end;
end;

procedure TFrmDeleteUser.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;
end;

procedure TFrmDeleteUser.ProcCancel(Sender: TObject);
begin
  FrmManageUser.Visible := True;
  FrmDeleteUser.Close;
end;

procedure TFrmDeleteUser.ProcDeleteUser(Sender: TObject);
var
  LRet : Integer;
  LUID : Integer;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        ADBGrid.AutoEdit  := True;

        LUID           := StrToInt(DBTextUserId.Caption);

        with AQu do begin
          SQL.Text := SQL_20050002;
          with Params do begin
            ParamByName('pUserID').AsInteger := LUID;
          end;

          LRet := MessageDlg(MSG_JP_000011, mtWarning, [mbNo, mbYes], 0, mbNo);
          if LRet = mrYes then
          begin
            CloseTransactions;
            SetDatabaseNames;

            ExecSQL;
            ATr.Commit;
            SetChangedUserDef(True);

            FrmManageUser.Visible := True;
            if GetChangedUserDef then
            begin
              MessageDlg(MSG_JP_000031, mtInformation, [mbOk], 0);
              FrmManageUser.ActGoBackExecute(FrmTopMenu);
            end;
          end else begin
            MessageDlg(MSG_JP_000012, mtInformation, [mbOk], 0);
            ATr.Rollback;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do
      begin
        MessageDlg(MSG_JP_000013, mtError, [mbOk], 0);
        ATr.Rollback;
      end;
    end;
  finally
    ATr.Active            := False;
    FrmDeleteUser.Close;
  end;
end;

procedure TFrmDeleteUser.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmDeleteUser.BtnCancelEnter(Sender: TObject);
begin
  CancelMouseOver(clSkyBlue);
  DeleteUserMouseOver(clBtnFace);
end;

procedure TFrmDeleteUser.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmDeleteUser.DeleteUserMouseOver(NewColor: TColor);
begin
  BtnDeleteUser.Color := NewColor;
end;

procedure TFrmDeleteUser.BtnDeleteUserEnter(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
  DeleteUserMouseOver(clSkyBlue);
end;

procedure TFrmDeleteUser.BtnDeleteUserExit(Sender: TObject);
begin
  DeleteUserMouseOver(clBtnFace);
end;

procedure TFrmDeleteUser.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmDeleteUser.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmDeleteUser.ActDeleteUserExecute(Sender: TObject);
begin
  ProcDeleteUser(Sender);
end;

procedure TFrmDeleteUser.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with FrmTopMenu.Defs do begin
    CloseTransactions;

    if GetChangedUserDef = False then begin
      FrmManageUser := TFrmManageUser.Create(Application);
      FrmManageUser.Visible     := True;
    end else begin
      SetChangedUserDef(False);
    end;
    CloseAction           := caFree;
    FrmDeleteUser         := nil;
  end;
end;

procedure TFrmDeleteUser.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmDeleteUser.FormShow(Sender: TObject);
begin
  FrmDeleteUser.KeyPreview := True;

  FrmDeleteUser.Color := RGB(112, 168, 175);
  pnlCancel.Color     := RGB( 72, 122, 129);
  PnlDeleteUser.Color := RGB( 72, 122, 129);

  try
    with AQu do begin
      SQL.Text         := SQL_20050001;
      with Params do begin
        ParamByName('pRole').AsInteger := ROLE_USER;
      end;

      Open;
    end;

    with ADBGrid do begin
      DataSource      := ADS;
      AutoAdjustColumns;
    end;
  finally
  end;

  with FrmDeleteUser do begin
    Height := 513;
    Width  := 567;
  end;
end;

procedure TFrmDeleteUser.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnDeleteUser' then begin
      ActDeleteUser.Execute;
    end;
  end;
end;

end.

