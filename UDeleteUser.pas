unit UDeleteUser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, DBGrids, LCLIntf, ActnList,
  UDBNavi;

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
    ADBNavi        : TDBNavi;
    BtnCancel      : TPanel;
    BtnDeleteUser  : TPanel;
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
    Panel1         : TPanel;
    Panel2         : TPanel;
    Panel3         : TPanel;
    Panel4         : TPanel;
    PnlCancel      : TPanel;
    PnlDeleteUser  : TPanel;
    Timer          : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActDeleteUserExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AQuAfterScroll(DataSet: TDataSet);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure BtnDeleteUserEnter(Sender: TObject);
    procedure BtnDeleteUserExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    //FTab               : Boolean;
    FGuidePanels       : Array[0..3] of TPanel;
    FNavigateBtn       : TNavigateBtn;
    FDBGridClicked     : Boolean;
    function CannotFocusedNavButton: Boolean;
    procedure ProcCancel(Sender: TObject);
    procedure ProcDeleteUser(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure DeleteUserMouseOver(NewColor: TColor);
  public

  end;

var
  FrmDeleteUser: TFrmDeleteUser;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageUser;

{$R *.lfm}

{ TFrmDeleteUser }

function TFrmDeleteUser.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

procedure TFrmDeleteUser.ProcCancel(Sender: TObject);
begin
  if (Not Assigned(FrmManageUser)) Or (FrmManageUser = nil) then begin
    FrmManageUser := TFrmManageUser.Create(Application);
  end;
  Self.Close;
end;

procedure TFrmDeleteUser.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmDeleteUser.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
begin
  FNavigateBtn := Index;
end;

procedure TFrmDeleteUser.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    BtnDeleteUser.SetFocus;
  end else if (Key = VK_TAB) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if CannotFocusedNavButton then begin
        BtnCancel.SetFocus;
      end else begin
        ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
      end;
    end;
  end;
end;

procedure TFrmDeleteUser.AQuAfterScroll(DataSet: TDataSet);
begin
  case FNavigateBtn of
  nbFirst:
    if AQu.RecordCount > 0 then begin
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
    end;
  nbPrior:
    if AQu.RecNo <= 1 then begin
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
    end;
  nbNext:
    begin
      if AQu.RecNo = AQu.RecordCount then begin
        ADBNavi.FindNextControl(ADBNavi, False, True, True).SetFocus;
      end;
    end;
  nbLast: ADBNavi.FindNextControl(ADBNavi, False, True, True).SetFocus;
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
          LUID := StrToInt(DBTextUserId.Caption);

          CloseQuery(AQu);
          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20050002;
            with Params do begin
              ParamByName('pUserID').AsInteger := LUID;
            end;

            LRet := MessageDlg(MSG_JP_000011, mtWarning, [mbNo, mbYes], 0, mbNo);
            if LRet = mrYes then begin
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

              if (Not Assigned(FrmManageUser))
                  Or (FrmManageUser = Nil) then begin
                FrmManageUser := TFrmManageUser.Create(Application);
              end;
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
        Self.Close;
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

  Timer.Enabled     := True;
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

procedure TFrmDeleteUser.ADBGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Not FDBGridClicked then begin
    FDBGridClicked := True;
    ADBGridSelectEditor(
      Sender, ADBGrid.LastColumn, TWinControl(ADBGrid));

    ADBNavi.SetFocus;
    ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;

    Abort;
  end;
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
  Self.Width          := 567;

  Self.KeyPreview     := True;

  Self.Color          := RGB(112, 168, 175);
  pnlCancel.Color     := RGB( 72, 122, 129);
  PnlDeleteUser.Color := RGB( 72, 122, 129);

  { Debug }
  //Self.Width  := 689;
end;

procedure TFrmDeleteUser.FormActivate(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text         := SQL_20050001;
            with Params do begin
              ParamByName('pRole').AsInteger := ROLE_USER;
            end;

            Open;
          end;
        end;
      end;
      ADBNavi.SetFocus;
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;

  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmDeleteUser.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Timer.Enabled := True;

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

