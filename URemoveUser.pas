unit URemoveUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LazUTF8, SysUtils, DB, SQLDB, SQLite3Conn, Forms, Controls, Graphics,
  Dialogs, DBCtrls, DBGrids, StdCtrls, ExtCtrls, LCLIntf, ActnList;

type

  { TFrmRemoveUser }

  TFrmRemoveUser = class(TForm)
    ActCancel      : TAction;
    ActionList     : TActionList;
    ActQuit        : TAction;
    ActRemoveUser  : TAction;
    ADBGrid           : TDBGrid;
    ADS            : TDataSource;
    ATr            : TSQLTransaction;
    BtnCancel: TButton;
    BtnRemoveUser: TButton;
    DBNav          : TDBNavigator;
    DBTextUserId   : TDBText;
    DBTextName     : TDBText;
    DBTextRole     : TDBText;
    DBTextEntryDT  : TDBText;
    DBTextUpdateDT : TDBText;
    LblEntryDT1     : TLabel;
    LblEntryDT2    : TLabel;
    LblEntryDT3    : TLabel;
    LblName2       : TLabel;
    LblName3       : TLabel;
    LblName4       : TLabel;
    LblName1        : TLabel;
    LblRole1        : TLabel;
    LblRole2       : TLabel;
    LblUpdateDT1    : TLabel;
    LblUpdateDT2   : TLabel;
    LblUpdateDT3   : TLabel;
    LblUserId1      : TLabel;
    LblUserId2     : TLabel;
    LblUserId3     : TLabel;
    LblUserId4     : TLabel;
    LblUserId5     : TLabel;
    PnlCancel      : TPanel;
    PnlRemoveUser  : TPanel;
    AQu: TSQLQuery;
    ACn: TSQLite3Connection;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ActRemoveUserExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    procedure ConnectUsersTable;
    procedure ProcCancel;
    procedure ProcRemoveUser;
  public

  end;

var
  FrmRemoveUser: TFrmRemoveUser;

implementation
uses
  UConsts, UDBAccess, UTopMenu, UManageUser;

{$R *.lfm}

{ TFrmRemoveUser }

procedure TFrmRemoveUser.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn);
  end;
end;

procedure TFrmRemoveUser.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;
end;

procedure TFrmRemoveUser.ProcCancel;
begin
  FrmManageUser.Visible := True;
  FrmRemoveUser.Close;
end;

procedure TFrmRemoveUser.ProcRemoveUser;
var
  LRet : Integer;
  LUID : Integer;
begin
  try
    try
      ADBGrid.AutoEdit  := True;

      LUID           := StrToInt(DBTextUserId.Caption);

      with AQu do begin
        SQL.Text := SQL_20050002;
        Params.ParamByName('pUserID').AsInteger := LUID;

        LRet := MessageDlg(MSG_JP_000011, mtWarning, [mbNo, mbYes], 0, mbNo);
        if LRet = mrYes then
        begin
          CloseTransactions;
          ExecSQL;
          ATr.Commit;
          FrmTopMenu.Defs.SetChangedUserDef(True);

          FrmManageUser.Visible := True;
          if FrmTopMenu.Defs.GetChangedUserDef then
          begin
            MessageDlg(MSG_JP_000031, mtInformation, [mbOk], 0);
            FrmManageUser.ActGoBackExecute(FrmTopMenu);
          end;
        end else begin
          MessageDlg(MSG_JP_000012, mtInformation, [mbOk], 0);
          ATr.Rollback;
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
    FrmRemoveUser.Close;
  end;
end;

procedure TFrmRemoveUser.ConnectUsersTable;
begin
  try
    if Not ACn.Connected then
    begin
      ACn.DatabaseName   := DB_NAME;
      ATr.DataBase       := ACn;
      AQu.DataBase       := ACn;
      AQu.Transaction    := ATr;
      ADS.DataSet        := AQu;
      ACn.Open;
      ATr.Active         := True;
    end;

    AQu.SQL.Text         := SQL_20050001;
    AQu.Params.ParamByName('pRole').AsInteger := ROLE_USER;

    AQu.Open;

    ADBGrid.DataSource      := ADS;
    ADBGrid.AutoFillColumns := True;
  finally
  end;
end;

procedure TFrmRemoveUser.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmRemoveUser.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmRemoveUser.ActRemoveUserExecute(Sender: TObject);
begin
  ProcRemoveUser;
end;

procedure TFrmRemoveUser.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseTransactions;

  if FrmTopMenu.Defs.GetChangedUserDef = False then begin
    FrmManageUser := TFrmManageUser.Create(Application);
    FrmManageUser.Visible     := True;
  end else begin
    FrmTopMenu.Defs.SetChangedUserDef(False);
  end;
  CloseAction           := caFree;
  FrmRemoveUser         := nil;
end;

procedure TFrmRemoveUser.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FrmRemoveUser.Color := RGB(112, 168, 175);
  pnlCancel.Color     := RGB( 72, 122, 129);
  PnlRemoveUser.Color := RGB( 72, 122, 129);

  FrmRemoveUser.Height := 329;
  FrmRemoveUser.Width  := 567;

  ConnectUsersTable;

  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmRemoveUser.FormShow(Sender: TObject);
begin

end;

end.

