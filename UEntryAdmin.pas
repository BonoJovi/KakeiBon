unit UEntryAdmin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, SysUtils, DB, SQLDB, SQLite3Conn, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Buttons, LCLIntf, LCLType, ActnList;

type

  { TFrmEntryAdmin }

  TFrmEntryAdmin = class(TForm)
    ActClearPaw    : TAction;
    ActSave      : TAction;
    ActionList     : TActionList;
    ActQuit        : TAction;
    ADS            : TDataSource;
    AQu            : TSQLQuery;
    EdtPaw         : TEdit;
    EdtPawConfirm  : TEdit;
    EdtAdminUserId : TEdit;
    LblAdminUserID : TLabel;
    LblPaw         : TLabel;
    LblPawConfirm  : TLabel;
    BtnClearPaw    : TPanel;
    BtnSave        : TPanel;
    PnlClearPaw    : TPanel;
    PnlCommit      : TPanel;
    Shape1         : TShape;
    Shape2         : TShape;
    Shape3         : TShape;
    procedure EdtAdminUserIdEnter(Sender: TObject);
    procedure EdtAdminUserIdExit(Sender: TObject);
    procedure EdtPawChange(Sender: TObject);
    procedure EdtPawConfirmChange(Sender: TObject);
    procedure EdtPawConfirmEnter(Sender: TObject);
    procedure EdtPawConfirmExit(Sender: TObject);
    procedure EdtPawEnter(Sender: TObject);
    procedure EdtPawExit(Sender: TObject);
    procedure ProcClearPaw(Sender: TObject);
    procedure ProcCommit(Sender: TObject);
    procedure ClearPawMouseOver(NewColor: TColor);
    procedure BtnClearPawEnter(Sender: TObject);
    procedure BtnClearPawExit(Sender: TObject);
    procedure CommitMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure ActClearPawExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
  end;

var
  FrmEntryAdmin : TFrmEntryAdmin;

implementation

uses
  UConsts, UCommonDB, UDefs, UDBAccess, UTopMenu;

{$R *.lfm}

{ TFrmEntryAdmin }

procedure TFrmEntryAdmin.ProcClearPaw(Sender: TObject);
begin
  Defs.ClearPaw(EdtPaw, EdtPawConfirm);
end;

procedure TFrmEntryAdmin.EdtAdminUserIdEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmEntryAdmin.EdtAdminUserIdExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmEntryAdmin.EdtPawChange(Sender: TObject);
begin
  if (Length(EdtPaw.Text) = 0)
      And (Length(EdtPawConfirm.Text) = 0) then begin
    BtnClearPaw.Enabled := False;
    ActClearPaw.Enabled := False;
  end else begin
    BtnClearPaw.Enabled := True;
    ActClearPaw.Enabled := True;
  end;
end;

procedure TFrmEntryAdmin.EdtPawConfirmChange(Sender: TObject);
begin
  if (Length(EdtPaw.Text) = 0)
      And (Length(EdtPawConfirm.Text) = 0) then begin
    BtnClearPaw.Enabled := False;
    ActClearPaw.Enabled := False;
  end else begin
    BtnClearPaw.Enabled := True;
    ActClearPaw.Enabled := True;
  end;
end;

procedure TFrmEntryAdmin.EdtPawConfirmEnter(Sender: TObject);
begin
  Shape3.Visible := True;
end;

procedure TFrmEntryAdmin.EdtPawConfirmExit(Sender: TObject);
begin
  Shape3.Visible := False;
end;

procedure TFrmEntryAdmin.EdtPawEnter(Sender: TObject);
begin
  Shape2.Visible := True;
end;

procedure TFrmEntryAdmin.EdtPawExit(Sender: TObject);
begin
  Shape2.Visible := False;
end;

procedure TFrmEntryAdmin.ProcCommit(Sender: TObject);
var
  AExistsDB : Boolean = False;
begin
  try
    with CommonDB do begin
      with Defs do begin
        with AQu do begin
          DataBase := CommonDB.ACn;

          SQL.Text := 'SELECT COUNT(*) AS COUNT FROM sqlite_master WHERE TYPE=''table'' AND name=''USERS''';
          Open;
          if FieldByName('COUNT').AsInteger = 1 then begin
            AExistsDB := True;
          end;
        end;
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
        with CommonDB do begin
          with Defs do begin
            try
              try
                with ACn do begin
                  // Create USERS table and index
                  // 1st query (USERS)
                  ExecuteDirect(SQL_10000001);
                  // 2nd query (USERS_ID_idx)
                  ExecuteDirect(SQL_10000002);
                end;

                with AQu do begin
                  CloseQuery(AQu);

                  // 3rd query
                  SQLConnection  := ACn;
                  SQLTransaction := ATr;

                  SQL.Text       := SQL_10000003;
                  // Set params of 3rd query
                  with Params do begin
                    ParamByName('pUserId').AsUTF8String  := EdtAdminUserId.Text;
                    ParamByName('pPaw').AsUTF8String     := EdtPaw.Text;
                    ParamByName('pRole').AsInteger       := ROLE_ADMIN;
                    ParamByName('pEntryDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
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
                  // 23th query (UNIT_ID_idx)
                  ExecuteDirect(SQL_10000023);
                  // 24th query (TAX_TYPE)
                  ExecuteDirect(SQL_10000024);
                  // 25th query (TAX_TYPE_ID_idx)
                  ExecuteDirect(SQL_10000025);
                  // 26th query (TAX_RATE)
                  ExecuteDirect(SQL_10000026);
                  // 27th query (TAX_RATE_ID_idx)
                  ExecuteDirect(SQL_10000027);
                  // 27th query (BRAND_VIEW)
                  //ExecuteDirect(SQL_10000028);
                end;

                ATr.Commit;
              except
                on E: Exception do begin
                  MessageDlg(MSG_JP_000013, mtError, [mbOK], 0);
                end;
              end;
            finally
              FrmTopMenu.Visible := True;
              Self.Close;
            end;
          end;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmEntryAdmin.ClearPawMouseOver(NewColor: TColor);
begin
  BtnClearPaw.Color := NewColor;
end;

procedure TFrmEntryAdmin.BtnClearPawEnter(Sender: TObject);
begin
  ClearPawMouseOver(clSkyBlue);
end;

procedure TFrmEntryAdmin.BtnClearPawExit(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
end;

procedure TFrmEntryAdmin.CommitMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryAdmin.BtnSaveEnter(Sender: TObject);
begin
  CommitMouseOver(clSkyBlue);
end;

procedure TFrmEntryAdmin.BtnSaveExit(Sender: TObject);
begin
  CommitMouseOver(clBtnFace);
end;

procedure TFrmEntryAdmin.ActClearPawExecute(Sender: TObject);
begin
  ProcClearPaw(Sender);
end;

procedure TFrmEntryAdmin.ActSaveExecute(Sender: TObject);
begin
  ProcCommit(Sender);
end;

procedure TFrmEntryAdmin.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryAdmin.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
  end;

  FrmTopMenu.Visible := True;

  CloseAction := caFree;
  FrmEntryAdmin  := nil;
end;

procedure TFrmEntryAdmin.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
      Exit;
    end;

    with CommonDB do begin
      ForceDirectories(GetDBPath);
    end;
  end;
  //SetDatabaseNames;

  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmEntryAdmin.FormShow(Sender: TObject);
begin
  Self.Width          := 712;

  Self.KeyPreview     := True;

  Self.Color          := RGB(112, 168, 175);
  PnlClearPaw.Color   := RGB( 72, 122, 129);
  PnlCommit.Color     := RGB( 72, 122, 129);

  EdtAdminUserId.Clear;
  EdtPaw.Clear;
  EdtPawConfirm.Clear;

  if (Length(EdtPaw.Text) = 0)
      And (Length(EdtPawConfirm.Text) = 0) then begin
    BtnClearPaw.Enabled := False;
    ActClearPaw.Enabled := False;
  end;

  { Debug }
  //Self.Width      := 823;
end;

procedure TFrmEntryAdmin.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnClearPaw' then begin
      ActClearPaw.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end;
  end;
end;

end.

