unit UAddUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, LazUTF8, SQLDB, SQLite3Conn, DB, SysUtils, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, LCLIntf, LCLType, ActnList;

type

  { TFrmAddUser }

  TFrmAddUser = class(TForm)
    ActionList    : TActionList;
    ActCancel     : TAction;
    ActClearPaw   : TAction;
    ActSave       : TAction;
    ActQuit       : TAction;
    ADS: TDataSource;
    EdtPaw        : TEdit;
    EdtPawConfirm : TEdit;
    EdtUserName   : TEdit;
    LblPaw        : TLabel;
    LblPawConfirm : TLabel;
    LblUserID1    : TLabel;
    LblUserID2    : TLabel;
    LblUserID3    : TLabel;
    LblUserID4    : TLabel;
    BtnClearPaw   : TPanel;
    BtnCancel     : TPanel;
    BtnSave       : TPanel;
    PnlCancel     : TPanel;
    PnlClearPass  : TPanel;
    PnlSave       : TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    AQu: TSQLQuery;
    procedure EdtPawChange(Sender: TObject);
    procedure EdtPawConfirmChange(Sender: TObject);
    procedure EdtPawConfirmEnter(Sender: TObject);
    procedure EdtPawConfirmExit(Sender: TObject);
    procedure EdtPawEnter(Sender: TObject);
    procedure EdtPawExit(Sender: TObject);
    procedure EdtUserNameEnter(Sender: TObject);
    procedure EdtUserNameExit(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ProcClearPaw(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure ClearPawMouseOver(NewColor: TColor);
    procedure BtnClearPawEnter(Sender: TObject);
    procedure BtnClearPawExit(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure SaveMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActClearPawExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure CallInsertSQL(UserID: Integer; SQLStr: String);
    procedure CallInsertSQLWithoutUserID(SQLStr: String);
  public

  end;

var
  FrmAddUser : TFrmAddUser;

implementation
uses
  UConsts, UDefs, UCommonDB, UDBAccess, UTopMenu, UManageUser;

{$R *.lfm}

{ TFrmAddUser }


procedure TFrmAddUser.CallInsertSQL(UserID: Integer; SQLStr: String);
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        SQL.Text                               := SQLStr;
        with Params do begin
          ParamByName('pUserID').AsInteger     := UserID;
          ParamByName('pEntryDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
        end;
        ExecSQL;
      end;
    end;
  end;
end;

procedure TFrmAddUser.CallInsertSQLWithoutUserID(SQLStr: String);
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        SQL.Text                               := SQLStr;
        with Params do begin
          ParamByName('pEntryDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
        end;
        ExecSQL;
      end;
    end;
  end;
end;

procedure TFrmAddUser.ProcCancel(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmAddUser.ProcClearPaw(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      ClearPaw(EdtPaw, EdtPawConfirm);
      EdtUserName.SetFocus;
    end;
  end;
end;

procedure TFrmAddUser.EdtUserNameEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmAddUser.EdtPawEnter(Sender: TObject);
begin
  Shape2.Visible := True;
end;

procedure TFrmAddUser.EdtPawConfirmEnter(Sender: TObject);
begin
  Shape3.Visible := True;
end;

procedure TFrmAddUser.EdtPawChange(Sender: TObject);
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

procedure TFrmAddUser.EdtPawConfirmChange(Sender: TObject);
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

procedure TFrmAddUser.EdtPawConfirmExit(Sender: TObject);
begin
  Shape3.Visible := False;
end;

procedure TFrmAddUser.EdtPawExit(Sender: TObject);
begin
  Shape2.Visible := False;
end;

procedure TFrmAddUser.EdtUserNameExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmAddUser.ProcSave(Sender: TObject);
var
  LUserID   : Integer;
begin
  try
    // Input check
    if EdtUserName.Text = '' then begin
       MessageDlg(MSG_JP_000003, mtError, [mbOk], 0);
       Exit;
    end;

    if Pos('''', EdtUserName.Text) > 0 then begin
      MessageDlg(MSG_JP_000018, mtInformation, [mbOk], 0);
      Exit;
    end;

    try
      try
        with CommonDB do begin
          with Defs do begin
            with AQu do begin
              SQLConnection  := ACn;
              SQLTransaction := ATr;

              SQL.Text := SQL_20030002;
              with Params do begin
                ParamByName('pUName').AsAnsiString := EdtUserName.Text;
                Open;
              end;

              if RecordCount > 0 then begin
                MessageDlg(MSG_JP_000009, mtError, [mbOk], 0);

                EdtUserName.Text   := '';
                EdtPaw.Text        := '';
                EdtPawConfirm.Text := '';

                Exit;
              end;
            end;
          end;
        end;
      except
        on E: ESQLDatabaseError do begin
          ShowMessage(E.Message);
          Exit;
        end;
      end;
    finally
      with AQu do begin
        Close;
      end;
    end;

    // Input check
    if (EdtPaw.Text = '') And (EdtPawConfirm.Text = '') then begin
      MessageDlg(MSG_JP_000004, mtError, [mbOk], 0);
      Exit;
    end;

    if (Pos('''', EdtPaw.Text) > 0)
        Or (Pos('''', EdtPawConfirm.Text) > 0) then begin
      MessageDlg(MSG_JP_000019, mtInformation, [mbOk], 0);
      Exit;
    end;

    with CommonDB do begin
      with Defs do begin
        // Input check
        if EdtPaw.Text <> EdtPawConfirm.Text then begin
          ClearPaw(EdtPaw, EdtPawConfirm);
          MessageDlg(MSG_JP_000005, mtError, [mbOk], 0);
          Exit;
        end;
      end;
    end;

    try
      with CommonDB do begin
        with Defs do begin
          with AQu do begin
            // Add user
            SQL.Text                               := SQL_20030001;
            with Params do begin
              ParamByName('pUName').AsUTF8String   := EdtUserName.Text;
              ParamByName('pPaw').AsUTF8String     := EdtPaw.Text;
              ParamByName('pRole').AsInteger       := ROLE_USER;
              ParamByName('pEntryDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
            end;

            ExecSQL;
            ATr.Commit;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        with CommonDB do begin
          ATr.Rollback;
        end;
      end;
    end;

    try
      with CommonDB do begin
        with Defs do begin
          with AQu do begin
            SQL.Text := SQL_20030002;
            Open;
            LUserID  := FieldByName('USER_ID').AsInteger;
            Close;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;

    try
      // Insert TAX_RATE datas
      // 税率
      CallInsertSQL(LUserID, SQL_90010001);
      CallInsertSQL(LUserID, SQL_90010002);
      CallInsertSQL(LUserID, SQL_90010003);

      // Insert TAX_TYPE datas
      // 課税種別
      CallInsertSQL(LUserID, SQL_90020001);
      CallInsertSQL(LUserID, SQL_90020002);
      CallInsertSQL(LUserID, SQL_90020003);
      CallInsertSQL(LUserID, SQL_90020004);
      CallInsertSQL(LUserID, SQL_90020005);

      // Insert EXP1 datas
      // 支出
      CallInsertSQL(LUserID, SQL_91000001);

      CallInsertSQL(LUserID, SQL_91010001);
      CallInsertSQL(LUserID, SQL_91010002);
      CallInsertSQL(LUserID, SQL_91010003);
      CallInsertSQL(LUserID, SQL_91010004);
      CallInsertSQL(LUserID, SQL_91010005);
      CallInsertSQL(LUserID, SQL_91010006);
      CallInsertSQL(LUserID, SQL_91010007);
      CallInsertSQL(LUserID, SQL_91010008);
      CallInsertSQL(LUserID, SQL_91010009);
      CallInsertSQL(LUserID, SQL_91010010);
      CallInsertSQL(LUserID, SQL_91010011);

      CallInsertSQL(LUserID, SQL_91020001);
      CallInsertSQL(LUserID, SQL_91020002);
      CallInsertSQL(LUserID, SQL_91020003);
      CallInsertSQL(LUserID, SQL_91020004);
      CallInsertSQL(LUserID, SQL_91020005);
      CallInsertSQL(LUserID, SQL_91020006);

      CallInsertSQL(LUserID, SQL_91030001);
      CallInsertSQL(LUserID, SQL_91030002);
      CallInsertSQL(LUserID, SQL_91030003);
      CallInsertSQL(LUserID, SQL_91030004);
      CallInsertSQL(LUserID, SQL_91030005);
      CallInsertSQL(LUserID, SQL_91030006);
      CallInsertSQL(LUserID, SQL_91030007);
      CallInsertSQL(LUserID, SQL_91030008);
      CallInsertSQL(LUserID, SQL_91030009);
      CallInsertSQL(LUserID, SQL_91030010);

      CallInsertSQL(LUserID, SQL_91040001);
      CallInsertSQL(LUserID, SQL_91040002);
      CallInsertSQL(LUserID, SQL_91040003);
      CallInsertSQL(LUserID, SQL_91040004);
      CallInsertSQL(LUserID, SQL_91040005);
      CallInsertSQL(LUserID, SQL_91040006);
      CallInsertSQL(LUserID, SQL_91040007);
      CallInsertSQL(LUserID, SQL_91040008);

      CallInsertSQL(LUserID, SQL_91050001);
      CallInsertSQL(LUserID, SQL_91050002);
      CallInsertSQL(LUserID, SQL_91050003);
      CallInsertSQL(LUserID, SQL_91050004);
      CallInsertSQL(LUserID, SQL_91050005);
      CallInsertSQL(LUserID, SQL_91050006);
      CallInsertSQL(LUserID, SQL_91050007);
      CallInsertSQL(LUserID, SQL_91050008);
      CallInsertSQL(LUserID, SQL_91050009);
      CallInsertSQL(LUserID, SQL_91050010);
      CallInsertSQL(LUserID, SQL_91050011);

      CallInsertSQL(LUserID, SQL_91060001);
      CallInsertSQL(LUserID, SQL_91060002);
      CallInsertSQL(LUserID, SQL_91060003);
      CallInsertSQL(LUserID, SQL_91060004);
      CallInsertSQL(LUserID, SQL_91060005);
      CallInsertSQL(LUserID, SQL_91060006);
      CallInsertSQL(LUserID, SQL_91060007);
      CallInsertSQL(LUserID, SQL_91060008);

      CallInsertSQL(LUserID, SQL_91070001);
      CallInsertSQL(LUserID, SQL_91070002);
      CallInsertSQL(LUserID, SQL_91070003);
      CallInsertSQL(LUserID, SQL_91070004);
      CallInsertSQL(LUserID, SQL_91070005);
      CallInsertSQL(LUserID, SQL_91070006);
      CallInsertSQL(LUserID, SQL_91070007);
      CallInsertSQL(LUserID, SQL_91070008);
      CallInsertSQL(LUserID, SQL_91070009);
      CallInsertSQL(LUserID, SQL_91070010);

      CallInsertSQL(LUserID, SQL_91080001);
      CallInsertSQL(LUserID, SQL_91080002);
      CallInsertSQL(LUserID, SQL_91080003);
      CallInsertSQL(LUserID, SQL_91080004);
      CallInsertSQL(LUserID, SQL_91080005);
      CallInsertSQL(LUserID, SQL_91080006);

      CallInsertSQL(LUserID, SQL_91090001);
      CallInsertSQL(LUserID, SQL_91090002);
      CallInsertSQL(LUserID, SQL_91090003);
      CallInsertSQL(LUserID, SQL_91090004);
      CallInsertSQL(LUserID, SQL_91090005);
      CallInsertSQL(LUserID, SQL_91090006);
      CallInsertSQL(LUserID, SQL_91090007);
      CallInsertSQL(LUserID, SQL_91090008);
      CallInsertSQL(LUserID, SQL_91090009);

      CallInsertSQL(LUserID, SQL_91100001);
      CallInsertSQL(LUserID, SQL_91100002);
      CallInsertSQL(LUserID, SQL_91100003);
      CallInsertSQL(LUserID, SQL_91100004);
      CallInsertSQL(LUserID, SQL_91100005);
      CallInsertSQL(LUserID, SQL_91100006);

      CallInsertSQL(LUserID, SQL_91110001);
      CallInsertSQL(LUserID, SQL_91110002);
      CallInsertSQL(LUserID, SQL_91110003);
      CallInsertSQL(LUserID, SQL_91110004);
      CallInsertSQL(LUserID, SQL_91110005);
      CallInsertSQL(LUserID, SQL_91110006);
      CallInsertSQL(LUserID, SQL_91110007);
      CallInsertSQL(LUserID, SQL_91110008);
      CallInsertSQL(LUserID, SQL_91110009);

      CallInsertSQL(LUserID, SQL_91120001);
      CallInsertSQL(LUserID, SQL_91120002);
      CallInsertSQL(LUserID, SQL_91120003);
      CallInsertSQL(LUserID, SQL_91120004);
      CallInsertSQL(LUserID, SQL_91120005);
      CallInsertSQL(LUserID, SQL_91120006);
      CallInsertSQL(LUserID, SQL_91120007);

      CallInsertSQL(LUserID, SQL_91130001);
      CallInsertSQL(LUserID, SQL_91130002);
      CallInsertSQL(LUserID, SQL_91130003);
      CallInsertSQL(LUserID, SQL_91130004);
      CallInsertSQL(LUserID, SQL_91130005);
      CallInsertSQL(LUserID, SQL_91130006);
      CallInsertSQL(LUserID, SQL_91130007);
      CallInsertSQL(LUserID, SQL_91130008);
      CallInsertSQL(LUserID, SQL_91130009);
      CallInsertSQL(LUserID, SQL_91130010);

      CallInsertSQL(LUserID, SQL_91140001);
      CallInsertSQL(LUserID, SQL_91140002);
      CallInsertSQL(LUserID, SQL_91140003);
      CallInsertSQL(LUserID, SQL_91140004);
      CallInsertSQL(LUserID, SQL_91140005);
      CallInsertSQL(LUserID, SQL_91140006);
      CallInsertSQL(LUserID, SQL_91140007);
      CallInsertSQL(LUserID, SQL_91140008);

      // 収入
      CallInsertSQL(LUserID, SQL_92000001);

      CallInsertSQL(LUserID, SQL_92010001);
      CallInsertSQL(LUserID, SQL_92010002);
      CallInsertSQL(LUserID, SQL_92010003);
      CallInsertSQL(LUserID, SQL_92010004);
      CallInsertSQL(LUserID, SQL_92010005);

      CallInsertSQL(LUserID, SQL_92020001);
      CallInsertSQL(LUserID, SQL_92020002);
      CallInsertSQL(LUserID, SQL_92020003);
      CallInsertSQL(LUserID, SQL_92020004);
      CallInsertSQL(LUserID, SQL_92020005);
      CallInsertSQL(LUserID, SQL_92020006);
      CallInsertSQL(LUserID, SQL_92020007);

      CallInsertSQL(LUserID, SQL_92030001);
      CallInsertSQL(LUserID, SQL_92030002);
      CallInsertSQL(LUserID, SQL_92030003);
      CallInsertSQL(LUserID, SQL_92030004);
      CallInsertSQL(LUserID, SQL_92030005);
      CallInsertSQL(LUserID, SQL_92030006);
      CallInsertSQL(LUserID, SQL_92030007);
      CallInsertSQL(LUserID, SQL_92030008);

      CallInsertSQL(LUserID, SQL_92040001);

      CallInsertSQL(LUserID, SQL_92050001);
      CallInsertSQL(LUserID, SQL_92050002);
      CallInsertSQL(LUserID, SQL_92050003);
      CallInsertSQL(LUserID, SQL_92050004);
      CallInsertSQL(LUserID, SQL_92050005);

      CallInsertSQL(LUserID, SQL_92060001);

      // 振替
      CallInsertSQL(LUserID, SQL_93000001);

      with CommonDB do begin
        ATr.Commit;
      end;
      Self.Close;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        with CommonDB do begin
          ATr.Rollback;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmAddUser.ClearPawMouseOver(NewColor: TColor);
begin
  BtnClearPaw.Color := NewColor;
end;

procedure TFrmAddUser.BtnClearPawEnter(Sender: TObject);
begin
  ClearPawMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
end;

procedure TFrmAddUser.BtnClearPawExit(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
end;

procedure TFrmAddUser.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmAddUser.BtnCancelEnter(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
end;

procedure TFrmAddUser.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmAddUser.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmAddUser.BtnSaveEnter(Sender: TObject);
begin
  ClearPawMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
end;

procedure TFrmAddUser.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);
end;

procedure TFrmAddUser.ActClearPawExecute(Sender: TObject);
begin
  ProcClearPaw(Sender);
end;

procedure TFrmAddUser.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmAddUser.ActSaveExecute(Sender: TObject);
begin
  ProcSave(Sender);
end;

procedure TFrmAddUser.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmAddUser.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
  end;

  if (Not Assigned(FrmManageUser))
      Or (FrmManageUser = Nil) then begin
    FrmManageUser := TFrmManageUser.Create(Application);
  end;
  FrmManageUser.Visible := True;

  CloseAction           := caFree;
  FrmAddUser            := nil;
end;

procedure TFrmAddUser.FormCreate(Sender: TObject);
begin
  with Defs do begin
    //SetDatabaseNames;

    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmAddUser.FormShow(Sender: TObject);
begin
  Self.Width         := 712;

  Self.KeyPreview    := True;

  Self.Color         := RGB(112, 168, 175);
  PnlClearPass.Color := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlSave.Color      := RGB( 72, 122, 129);

  if (Length(EdtPaw.Text) = 0)
      And (Length(EdtPawConfirm.Text) = 0) then begin
    BtnClearPaw.Enabled := False;
    ActClearPaw.Enabled := False;
  end;

  { Debug }
  //Self.Width      := 845;
end;

procedure TFrmAddUser.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnClearPaw' then begin
      ActClearPaw.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end;
  end;
end;

end.

