unit UEntryAdmin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, SysUtils, DB, SQLDB, SQLite3Conn, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Buttons, LCLIntf, ActnList,
  UDefs;

type

  { TFrmEntryAdmin }

  TFrmEntryAdmin = class(TForm)
    ActClearPaw    : TAction;
    ActCommit      : TAction;
    ActionList     : TActionList;
    ActQuit        : TAction;
    ADS            : TDataSource;
    AQu            : TSQLQuery;
    ATr            : TSQLTransaction;
    BtnClearPaw    : TButton;
    BtnCommit      : TButton;
    EdtPaw         : TEdit;
    EdtPawConfirm  : TEdit;
    EdtAdminUserId : TEdit;
    LblAdminUserID : TLabel;
    LblPaw         : TLabel;
    LblPawConfirm  : TLabel;
    PnlClearPaw    : TPanel;
    PnlCommit      : TPanel;
    ACn            : TSQLite3Connection;
    procedure ActClearPawExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Defs           : TDefs;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    procedure ProcClearPaw;
    procedure ProcCommit;
  public
  end;

var
  FrmEntryAdmin : TFrmEntryAdmin;

implementation

uses
  UDBAccess, UConsts, UTopMenu;

{$R *.lfm}

{ TFrmEntryAdmin }

procedure TFrmEntryAdmin.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn);
  end;
end;

procedure TFrmEntryAdmin.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;
end;

procedure TFrmEntryAdmin.ProcClearPaw;
begin
  Defs.ClearPaw(EdtPaw, EdtPawConfirm);
end;

procedure TFrmEntryAdmin.ProcCommit;
var
  AExistsDB : Boolean = False;
begin
  try
    with FrmTopMenu.Defs do begin
      if FileExists(ACn.DatabaseName) then begin
        with AQu do begin
          SQL.Text := 'SELECT COUNT(*) AS COUNT FROM sqlite_master WHERE TYPE=''table'' AND name=''USERS''';
          Open;
          if FieldByName('COUNT').AsInteger = 1 then begin
            AExistsDB := True;
          end;
        end;
        CloseTransactions;
      end;
    end;

    if Not AExistsDB then begin
      if EdtAdminUserId.Text = '' then begin
         MessageDlg(MSG_JP_000002, mtError, [mbOk], 0);
         Exit;
      end;

      if (EdtPaw.Text = '') And (EdtPawConfirm.Text = '') then begin
        MessageDlg(MSG_JP_000004, mtError, [mbOk], 0);
        Exit;
      end;

      if EdtPaw.Text <> EdtPawConfirm.Text then begin
        Defs.ClearPaw(EdtPaw, EdtPawConfirm);
        MessageDlg(MSG_JP_000005, mtError, [mbOk], 0);
        Exit;
      end else begin
        try
          with ACn do begin
            Open;

            // Create USERS table and index
            // 1st query (USERS)
            ExecuteDirect(SQL_10000001);
            // 2nd query (USERS_ID_idx)
            ExecuteDirect(SQL_10000002);
          end;

          with AQu do begin
            // 3rd query
            SQLConnection  := ACn;
            SQLTransaction := ATr;
            SQL.Text       := SQL_10000003;
            // Set params of 3rd query
            with Params do begin
              ParamByName('pUserId').AsUTF8String  := EdtAdminUserId.Text;
              ParamByName('pPaw').AsUTF8String     := EdtPaw.Text;
              ParamByName('pRole').AsInteger       := ROLE_ADMIN;
              ParamByName('pEntryDT').AsDateTime := Now;
            end;
            // Execute 3rd query
            ExecSQL;
          end;

          with ACn do begin
            // Create EXP1-EXP3 table and index.
            // 4th query (EXP1)
            ExecuteDirect(SQL_10000004);
            // 5th query (EXP1_ID_idx)
            ExecuteDirect(SQL_10000005);
            // 6th query (EXP2)
            ExecuteDirect(SQL_10000006);
            // 7th query (EXP2_ID_idx)
            ExecuteDirect(SQL_10000007);
            // 8th query (EXP3)
            ExecuteDirect(SQL_10000008);
            // 9th query (EXP3_ID_idx)
            ExecuteDirect(SQL_10000009);
            // 10th query (SHOP)
            ExecuteDirect(SQL_10000010);
            // 11th query (SHOP_ID_idx)
            ExecuteDirect(SQL_10000011);
            // 12th query (DETAILS_HEADER)
            ExecuteDirect(SQL_10000012);
            // 13th query (DETAILS_HEADER_ID_idx)
            ExecuteDirect(SQL_10000013);
            // 14th query (DETAILS)
            ExecuteDirect(SQL_10000014);
            // 15th query (DETAILS_ID_idx)
            ExecuteDirect(SQL_10000015);
            // 16th query (ACCOUNT)
            ExecuteDirect(SQL_10000016);
            // 17th query (ACCOUNT_ID_idx)
            ExecuteDirect(SQL_10000017);
            // 18th query (MAKER)
            ExecuteDirect(SQL_10000018);
            // 19th query (MAKER_ID_idx)
            ExecuteDirect(SQL_10000019);
            // 20th query (BRAND)
            ExecuteDirect(SQL_10000020);
            // 21th query (BRAND_ID_idx)
            ExecuteDirect(SQL_10000021);
            // 22th query (UNIT)
            ExecuteDirect(SQL_10000022);
            // 23th query (TAX_TYPE)
            ExecuteDirect(SQL_10000023);
            // 24th query (TAX_TYPE_ID_idx)
            ExecuteDirect(SQL_10000024);
            // 25th query (TAX_RATE)
            ExecuteDirect(SQL_10000025);
            // 26th query (TAX_RATE_ID_idx)
            ExecuteDirect(SQL_10000026);
            // 27th query (BRAND_VIEW)
            ExecuteDirect(SQL_10000027);
          end;

          // CloseTransactions;
          ATr.Commit;
        finally
          FrmTopMenu.Visible := True;
          FrmEntryAdmin.Close;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmEntryAdmin.ActClearPawExecute(Sender: TObject);
begin
  ProcClearPaw;
end;

procedure TFrmEntryAdmin.ActCommitExecute(Sender: TObject);
begin
  ProcCommit;
end;

procedure TFrmEntryAdmin.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryAdmin.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseTransactions;

  FrmTopMenu.Visible := True;

  CloseAction := caFree;
  FrmEntryAdmin  := nil;
end;

procedure TFrmEntryAdmin.FormCreate(Sender: TObject);
begin
  with FrmTopMenu do begin
    SetDatabaseNames;

    with Defs do begin
      if GetDoExitKakeiBon then begin
        Application.Terminate;
        Exit;
      end;

      ForceDirectories(GetDBPath);
      SetDatabaseName(ACn);
    end;
  end;
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmEntryAdmin.FormShow(Sender: TObject);
begin
  FrmEntryAdmin.Color := RGB(112, 168, 175);
  PnlClearPaw.Color   := RGB( 72, 122, 129);
  PnlCommit.Color     := RGB( 72, 122, 129);

  FrmEntryAdmin.Height := 279;

  EdtAdminUserId.Clear;
  EdtPaw.Clear;
  EdtPawConfirm.Clear;
end;

end.

