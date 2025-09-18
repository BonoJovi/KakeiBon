unit UManageUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, SQLDB, SQLite3Conn, DB, BufDataset, Forms,
  Controls, Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, DBCtrls, Grids,
  LCLIntf, ActnList;

type

  { TFrmManageUser }

  TFrmManageUser = class(TForm)
    ADS              : TDataSource;
    AQu              : TSQLQuery;
    ActionList       : TActionList;
    ActAddUser       : TAction;
    ActEditUser      : TAction;
    ActDeleteUser    : TAction;
    ActEditAdminUser : TAction;
    ActGoBack        : TAction;
    ActRemoveUser    : TAction;
    ADataSet         : TDataSet;
    ADSByCount       : TDataSource;
    AQuByCount       : TSQLQuery;
    BtnAddUser       : TPanel;
    BtnEditUser      : TPanel;
    BtnDeleteUser    : TPanel;
    BtnEditAdminUser : TPanel;
    BtnGoBack        : TPanel;
    ADBGrid: TDBGrid;
    PnlAddUser       : TPanel;
    PnlEditAdminUser : TPanel;
    PnlEditUser      : TPanel;
    PnlGoBack        : TPanel;
    PnlRemoveUser    : TPanel;
    Timer            : TTimer;
    procedure ADBGridEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ProcAddUser(Sender: TObject);
    procedure ProcEditUser(Sender: TObject);
    procedure ProcRemoveUser(Sender: TObject);
    procedure ProcEditAdminUser(Sender: TObject);
    procedure AddUserMouseOver(NewColor: TColor);
    procedure BtnAddUserEnter(Sender: TObject);
    procedure BtnAddUserExit(Sender: TObject);
    procedure EditUserMouseOver(NewColor: TColor);
    procedure BtnEditUserEnter(Sender: TObject);
    procedure BtnEditUserExit(Sender: TObject);
    procedure RemoveUserMouseOver(NewColor: TColor);
    procedure BtnDeleteUserEnter(Sender: TObject);
    procedure BtnDeleteUserExit(Sender: TObject);
    procedure EditAdminUserMouseOver(NewColor: TColor);
    procedure BtnEditAdminUserEnter(Sender: TObject);
    procedure BtnEditAdminUserExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActAddUserExecute(Sender: TObject);
    procedure ActEditAdminUserExecute(Sender: TObject);
    procedure ActEditUserExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActRemoveUserExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FCurrentControl: TObject;
    FGoBack           : Boolean;
    function GetGoBack: Boolean;
    procedure SetGoBack(GoBack: Boolean);
    function CountUser(RoleNum: Integer): Integer;
    procedure EnableButton(
      AddUser, EditUser, RemoveUser, EditAdminUser: Boolean);
    procedure OpenFormOrMsgDlg(Sender: TForm);
  public
  published
  end;


var
  FrmManageUser : TFrmManageUser;

implementation
uses
  UConsts, UCommonDB, UDefs, UDBAccess, UTopMenu, UAddUser, UEditUser,
  UDeleteUser, UEditAdmUser;

{$R *.lfm}

{ TFrmManageUser }

function TFrmManageUser.GetGoBack: Boolean;
begin
  Result := FGoBack;
end;

procedure TFrmManageUser.SetGoBack(GoBack: Boolean);
begin
  FGoBack := GoBack;
end;

function TFrmManageUser.CountUser(RoleNum: Integer): Integer;
var
  LRet: Integer;
begin
  with CommonDB do begin
    with Defs do begin
      try
        with AQuByCount do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;;

          SQL.Text := SQL_20020003;
          with Params do begin
            ParamByName('pRole').AsInteger := RoleNum;
          end;
          Open;
        end;
      finally
        with AQuByCount do begin
          LRet := FieldByName('COUNT').AsInteger;
          Close;
        end;
        Result := LRet;
      end;
    end;
  end;
end;

procedure TFrmManageUser.EnableButton(
    AddUser, EditUser, RemoveUser, EditAdminUser: Boolean);
begin
    BtnAddUser.Enabled       := AddUser;
    ActAddUser.Enabled       := AddUser;

    BtnEditUser.Enabled      := EditUser;
    ActEditUser.Enabled      := EditUser;

    BtnDeleteUser.Enabled    := RemoveUser;
    ActRemoveUser.Enabled    := RemoveUser;

    BtnEditAdminUser.Enabled := EditAdminUser;
    ActEditAdminUser.Enabled := EditAdminUser;
end;

procedure TFrmManageUser.OpenFormOrMsgDlg(Sender: TForm);
begin
  //CloseTransactions;
  //SetDatabaseNames;

  with Defs do begin
    if Not GetShowChildForm then begin
      SetShowChildForm(True);
    end;
  end;

  Self.Visible := False;

  Sender.Show;
end;

procedure TFrmManageUser.ProcAddUser(Sender: TObject);
begin
  FrmAddUser := TFrmAddUser.Create(Application);
  OpenFormOrMsgDlg(FrmAddUser);
end;

procedure TFrmManageUser.ADBGridEnter(Sender: TObject);
var
  LPanel : TPanel;
begin
  try
    if FCurrentControl is TPanel then begin
      LPanel := FCurrentControl As TPanel;
      LPanel.SetFocus;
    end;
  except
    on E: Exception do begin
      MessageDlg(E.Message, mtError, [mbOk], 0);
    end;
  end;
end;

procedure TFrmManageUser.ProcEditUser(Sender: TObject);
begin
  if CountUser(ROLE_USER) > 0 then begin
    FrmEditUser := TFrmEditUser.Create(Application);
    OpenFormOrMsgDlg(FrmEditUser);
  end else begin
    ShowMessage(MSG_JP_000015);
  end;
end;

procedure TFrmManageUser.ProcRemoveUser(Sender: TObject);
begin
  if CountUser(ROLE_USER) > 0 then begin
    FrmDeleteUser := TFrmDeleteUser.Create(Application);
    OpenFormOrMsgDlg(FrmDeleteUser);
  end else begin
    ShowMessage(MSG_JP_000016);
  end;
end;

procedure TFrmManageUser.ProcEditAdminUser(Sender: TObject);
begin
  FrmEditAdmUser := TFrmEditAdmUser.Create(Application);
  OpenFormOrMsgDlg(FrmEditAdmUser);
end;

procedure TFrmManageUser.AddUserMouseOver(NewColor: TColor);
begin
  BtnAddUser.Color := NewColor;
end;

procedure TFrmManageUser.BtnAddUserEnter(Sender: TObject);
begin
  AddUserMouseOver(clSkyBlue);
  FCurrentControl := Sender;
end;

procedure TFrmManageUser.BtnAddUserExit(Sender: TObject);
begin
  AddUserMouseOver(clBtnFace);
end;

procedure TFrmManageUser.EditUserMouseOver(NewColor: TColor);
begin
  BtnEditUser.Color := NewColor;
end;

procedure TFrmManageUser.BtnEditUserEnter(Sender: TObject);
begin
  EditUserMouseOver(clSkyBlue);
  FCurrentControl := Sender;
end;

procedure TFrmManageUser.BtnEditUserExit(Sender: TObject);
begin
  EditUserMouseOver(clBtnFace);
end;

procedure TFrmManageUser.RemoveUserMouseOver(NewColor: TColor);
begin
  BtnDeleteUser.Color := NewColor;
end;

procedure TFrmManageUser.BtnDeleteUserEnter(Sender: TObject);
begin
  RemoveUserMouseOver(clSkyBlue);
  FCurrentControl := Sender;
end;

procedure TFrmManageUser.BtnDeleteUserExit(Sender: TObject);
begin
  RemoveUserMouseOver(clBtnFace);
end;

procedure TFrmManageUser.EditAdminUserMouseOver(NewColor: TColor);
begin
  BtnEditAdminUser.Color := NewColor;
end;

procedure TFrmManageUser.BtnEditAdminUserEnter(Sender: TObject);
begin
  EditAdminUserMouseOver(clSkyBlue);
  FCurrentControl := Sender;
end;

procedure TFrmManageUser.BtnEditAdminUserExit(Sender: TObject);
begin
  EditAdminUserMouseOver(clBtnFace);
end;

procedure TFrmManageUser.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmManageUser.BtnGoBackEnter(Sender: TObject);
begin
  GoBackMouseOver(clSkyBlue);
  FCurrentControl := Sender;
end;

procedure TFrmManageUser.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageUser.ActAddUserExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcAddUser(Sender);
  Close;
end;

procedure TFrmManageUser.ActEditUserExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcEditUser(Sender);
  Close;
end;

procedure TFrmManageUser.ActRemoveUserExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcRemoveUser(Sender);
  Close;
end;

procedure TFrmManageUser.ActEditAdminUserExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcEditAdminUser(Sender);
  Close;
end;

procedure TFrmManageUser.ActGoBackExecute(Sender: TObject);
begin
  SetGoBack(True);
  if Sender is TForm then begin
    TForm(Sender).Visible := True;
  end;
  Close;
end;

procedure TFrmManageUser.FormClose(
    Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuByCount);
  end;

  if GetGoBack then begin
    with Defs do begin
      with FrmTopMenu do begin
        if GetChangedUserDef = False then begin
          Visible := True;
        end else begin
          ProcLogout(Sender);
          SetChangedUserDef(False);
        end;
      end;
    end;
  end;

  CloseAction   := caFree;
  FrmManageUser := nil;
end;

procedure TFrmManageUser.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FrmTopMenu.Visible := False;

  SetGoBack(True);
end;

procedure TFrmManageUser.FormShow(Sender: TObject);
begin
  Self.Width             := 710;

  Self.KeyPreview        := True;

  Self.Color             := RGB(112, 168, 175);
  PnlAddUser.Color       := RGB( 72, 122, 129);
  PnlEditUser.Color      := RGB( 72, 122, 129);
  PnlRemoveUser.Color    := RGB( 72, 122, 129);
  PnlEditAdminUser.Color := RGB( 72, 122, 129);
  PnlGoBack.Color        := RGB( 72, 122, 129);

  { Debug }
  //Self.Width      := 890;
end;

procedure TFrmManageUser.FormActivate(Sender: TObject);
begin
  try
    with CommonDB do begin
      with Defs do begin
        OpenSelectQuery(ADS, AQu, SQL_20020001);

        if MatchRole(ROLE_ADMIN) then begin
          if AQu.RecordCount = 0 then begin
            EnableButton(True, False, False, True);
          end else if AQu.RecordCount = 1 then begin
            EnableButton(True, False, False, True);
          end else if AQu.RecordCount > 1 then begin
            EnableButton(True, True, True, True);
          end;
        end else begin // Defs.MatchRole(ROLE_ADMIN) = False
          CloseQuery(AQu);

          with AQu do begin
            SQL.Text := SQL_20020002;
            with Params do begin
              ParamByName('pUName').AsAnsiString  := GetUName;
            end;
            Open;
            if RecordCount = 1 then begin
              EnableButton(False, True, False, False);
            end else begin
              if Not GetChangedUserDef then begin
                EnableButton(False, False, False, False);
                MessageDlg(MSG_JP_000004, mtError, [mbOk], 0);
                Close;
              end;
            end;
          end;
        end;

        ADS.DataSet     := AQu;
        with ADBGrid do begin
          DataSource := ADS;
          AutoAdjustColumns;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmManageUser.TimerTimer(Sender: TObject);
begin
  if ChngdAdmUserFlg then begin
    Self.Close;
  end;
end;

procedure TFrmManageUser.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnAddUser' then begin
      ActAddUser.Execute;
    end else if ActiveControl.Name = 'BtnEditUser' then begin
      ActEditUser.Execute;
    end else if ActiveControl.Name = 'BtnDeleteUser' then begin
      ActRemoveUser.Execute;
    end else if ActiveControl.Name = 'BtnEditAdminUser' then begin
      ActEditAdminUser.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

end.

