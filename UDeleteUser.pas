unit UDeleteUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LazUTF8, SysUtils, DB, SQLDB, SQLite3Conn, Forms, Controls, Graphics,
  Dialogs, DBCtrls, DBGrids, StdCtrls, ExtCtrls, LCLIntf, LCLType, ActnList,
  DBNavi, UDBNavi;

type

  { TFrmDeleteUser }

  TFrmDeleteUser = class(TForm)
    ADS            : TDataSource;
    AQu            : TSQLQuery;
    { ActionLists }
    ActionList     : TActionList;
    ActCancel      : TAction;
    ActDeleteUser  : TAction;
    ActQuit        : TAction;
    { Etc }
    ADBGrid        : TDBGrid;
    BtnCancel      : TButton;
    ADBNavi: TDBNavi;
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
    Panel1         : TPanel;
    Panel2         : TPanel;
    Panel3         : TPanel;
    Panel4         : TPanel;
    PnlCancel      : TPanel;
    PnlDeleteUser  : TPanel;
    Timer          : TTimer;
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
    procedure FormActivate(Sender: TObject);
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
    procedure TimerTimer(Sender: TObject);
  private
    FTab              : Boolean;
    FGuidePanels      : Array[0..3] of TPanel;
    FCurrentComponent : TObject;
  public

  end;

var
  FrmDeleteUser: TFrmDeleteUser;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageUser;

{$R *.lfm}

{ TFrmDeleteUser }

procedure TFrmDeleteUser.ProcCancel(Sender: TObject);
begin
  FrmManageUser.Visible := True;
  FrmDeleteUser.Close;
end;

procedure TFrmDeleteUser.ADBGridEnter(Sender: TObject);
var
  LPanel : TPanel;
begin
  if FCurrentComponent is TPanel then begin
    LPanel := FCurrentComponent as TPanel;
    LPanel.SetFocus;
  end;
end;

procedure TFrmDeleteUser.ADBNaviClick(Sender: TObject; Button: TDBNavButtonType
  );
begin
  with CommonDB do begin
    with Defs do begin
      if (Button = nbFirst) or (Button = nbPrior) then begin
        if AQu.RecNo = 1  then begin
          AQu.First;
          BtnDeleteUser.SetFocus;
        end;
      end else if (Button = nbNext) Or (Button = nbLast) then begin
        if AQu.RecNo = AQu.RecordCount  then begin
          AQu.Last;
          BtnCancel.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmDeleteUser.ADBNaviEnter(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TFrmDeleteUser.ADBNaviExit(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TFrmDeleteUser.ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND
  );
begin
  if FTab then begin
    try
      if Screen.ActiveControl is TDBNavi then begin
        TWinControl(ADBNavi.FindNextControl(ADBNavi, True, True, True)).SetFocus;
      end;
    except
      on E: Exception do begin
      end;
    end;
  end;

  Timer.Enabled := True;
end;

procedure TFrmDeleteUser.ProcDeleteUser(Sender: TObject);
var
  LRet : Integer;
  LUID : Integer;
begin
  with CommonDB do begin
    with Defs do begin
      try
        try
          //ADBGrid.AutoEdit  := True;
          LUID           := StrToInt(DBTextUserId.Caption);

          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20050002;
            with Params do begin
              ParamByName('pUserID').AsInteger := LUID;
            end;

            LRet := MessageDlg(MSG_JP_000011, mtWarning, [mbNo, mbYes], 0, mbNo);
            if LRet = mrYes then begin
              //SetDatabaseNames;
              ExecSQL;

              // Delete TAX_TYPE
              SQL.Text := SQL_20050003;
              with Params do begin
                ParamByName('pUserID').AsInteger := LUID;
              end;
              ExecSQL;

              // Delete TAX_RATE
              SQL.Text := SQL_20050004;
              with Params do begin
                ParamByName('pUserID').AsInteger := LUID;
              end;
              ExecSQL;

              // Delete EXP1
              SQL.Text := SQL_20050005;
              with Params do begin
                ParamByName('pUserID').AsInteger := LUID;
              end;
              ExecSQL;

              // Delete EXP2
              SQL.Text := SQL_20050006;
              with Params do begin
                ParamByName('pUserID').AsInteger := LUID;
              end;
              ExecSQL;

              // Delete EXP3
              SQL.Text := SQL_20050007;
              with Params do begin
                ParamByName('pUserID').AsInteger := LUID;
              end;
              ExecSQL;

              ATr.Commit;
              SetChangedUserDef(True);

              FrmManageUser.Visible := True;
              if GetChangedUserDef then begin
                MessageDlg(MSG_JP_000031, mtInformation, [mbOk], 0);
                FrmManageUser.ActGoBackExecute(FrmTopMenu);
              end;
            end else begin
              MessageDlg(MSG_JP_000012, mtInformation, [mbOk], 0);
              ATr.Rollback;
            end;
          end;
        except
          on E: ESQLDatabaseError do begin
            MessageDlg(MSG_JP_000013, mtError, [mbOk], 0);
            ATr.Rollback;
          end;
        end;
      finally
        ATr.Active            := False;
        FrmDeleteUser.Close;
      end;
    end;
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

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmDeleteUser.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
  FCurrentComponent := Sender;
end;

procedure TFrmDeleteUser.DeleteUserMouseOver(NewColor: TColor);
begin
  BtnDeleteUser.Color := NewColor;
end;

procedure TFrmDeleteUser.BtnDeleteUserEnter(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
  DeleteUserMouseOver(clSkyBlue);

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmDeleteUser.BtnDeleteUserExit(Sender: TObject);
begin
  DeleteUserMouseOver(clBtnFace);
  FCurrentComponent := Sender;
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
  with CommonDB do begin
    CloseQuery(AQu);
  end;

  with Defs do begin
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
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmDeleteUser.FormShow(Sender: TObject);
begin
  FrmDeleteUser.Width      := 567;

  FrmDeleteUser.KeyPreview := True;

  FrmDeleteUser.Color := RGB(112, 168, 175);
  pnlCancel.Color     := RGB( 72, 122, 129);
  PnlDeleteUser.Color := RGB( 72, 122, 129);

  { Debug }
  //FrmDeleteUser.Width  := 689;
end;

procedure TFrmDeleteUser.FormActivate(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      try
        with AQu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text         := SQL_20050001;
          with Params do begin
            ParamByName('pRole').AsInteger := ROLE_USER;
          end;

          Open;
        end;
      finally
      end;
    end;
  end;

  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmDeleteUser.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    FTab := False;
  end else begin
    FTab := True;
    if Screen.ActiveControl is TDBNavi then begin
      ADBNaviWMSetFocus(ADBNavi, ADBNavi.Handle);
    end;
  end;

  if (Key = VK_TAB) AND (ssShift in Shift) then begin
    if Screen.ActiveControl is TDBNavi then begin
      BtnDeleteUser.SetFocus;
    end;
    Timer.Enabled := True;
  end else begin
    Timer.Enabled := True;
  end;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnDeleteUser' then begin
      ActDeleteUser.Execute;
    end;
  end;
end;

procedure TFrmDeleteUser.TimerTimer(Sender: TObject);
var
  i            : Integer;
  LTargetIndex : Integer;
  Key          : Word;
begin
  Timer.Enabled := False;
  try

    if (ActiveControl is TDBNavFocusableButton) then begin
      LTargetIndex := ActiveControl.ComponentIndex - 10;

      for i := Low(FGuidePanels) To High(FGuidePanels) do begin
        FGuidePanels[i].Visible := (i = LTargetIndex);
      end;
    end else begin
      for i := Low(FGuidePanels) To High(FGuidePanels) do begin
        FGuidePanels[i].Visible := False;
      end;
    end;
  except
    on E: Exception do begin
      ShowMessage(E.Message);
    end;
  end;
end;

end.

