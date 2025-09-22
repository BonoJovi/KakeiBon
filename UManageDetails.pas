unit UManageDetails;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Dialogs, Variants, SysUtils, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, StdCtrls, DBCtrls, DBGrids, ExtCtrls, LCLIntf, LCLType, ActnList,
  UDBNavi, UDBG, LMessages;

type

  { TFrmManageDetails }

  TFrmManageDetails = class(TForm)
    ADBG: TDBG;
    ADS                    : TDataSource;
    AQu                    : TSQLQuery;
    { ActionLists }
    ActionList             : TActionList;
    ActAddDetailsHeader    : TAction;
    ActEditDetailsHeader   : TAction;
    ActDeleteDetailsHeader : TAction;
    ActGoBack              : TAction;
    BtnAddDetailHeader     : TPanel;
    BtnEditDetailHeader    : TPanel;
    BtnDeleteDetailHeader  : TPanel;
    BtnGoBack              : TPanel;
    ADBNavi                : TDBNavi;
    Panel1                 : TPanel;
    Panel2                 : TPanel;
    Panel3                 : TPanel;
    Panel4                 : TPanel;
    PnlAddDetail           : TPanel;
    PnlEditDetail          : TPanel;
    PnlGoBack              : TPanel;
    PnlDeleteDetail        : TPanel;
    Timer                  : TTimer;
    procedure ADBGMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADBGWMVScroll(Sender: TObject; var Message: TLMVScroll);
    procedure ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AQuAfterScroll(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    procedure ProcAddDetailsHeader(Sender: TObject);
    procedure ProcEditDetailsHeader(Sender: TObject);
    procedure ProcDeleteDetailsHeader(Sender: TObject);
    procedure AddDetailHeaderMouseOver(NewColor: TColor);
    procedure BtnAddDetailHeaderEnter(Sender: TObject);
    procedure BtnAddDetailHeaderExit(Sender: TObject);
    procedure EditDetailHeaderMouseOver(NewColor: TColor);
    procedure BtnEditDetailHeaderEnter(Sender: TObject);
    procedure BtnEditDetailHeaderExit(Sender: TObject);
    procedure DeleteDetailHeaderMouseOver(NewColor: TColor);
    procedure BtnDeleteDetailHeaderEnter(Sender: TObject);
    procedure BtnDeleteDetailHeaderExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActAddDetailsHeaderExecute(Sender: TObject);
    procedure ActEditDetailsHeaderExecute(Sender: TObject);
    procedure ActDeleteDetailsHeaderExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
  private
    //FTab         : Boolean;
    FGuidePanels : Array[0..3] of TPanel;
    FNavigateBtn : TNavigateBtn;
    FGoBack      : Boolean;
    function CannotFocusedNavButton: Boolean;
    function GetGoBack: Boolean;
    procedure SetGoBack(GoBack: Boolean);
  public

  end;

var
  FrmManageDetails: TFrmManageDetails;

implementation
uses
  LazLogger, UConsts, UCommonDB, UDefs, UDBAccess, UTopMenu, UEntryAccount, UEntryShop,
  UAddDetailsHeader, UEditDetailsHeader;

{$R *.lfm}

{ TFrmManageDetails }


function TFrmManageDetails.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

procedure TFrmManageDetails.ProcAddDetailsHeader(Sender: TObject);
begin
  try
    try
      FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
      with Defs do begin
        SetHeaderDT('');

        FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
        OpenForm(Self, FrmAddDetailsHeader);
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmManageDetails.ProcEditDetailsHeader(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          if (Assigned(AQu)) And (AQu.RecordCount > 0) then begin
            with AQu do begin
              SetUID(FieldByName('USER_ID').AsInteger);
              SetHID(FieldByName('HEADER_ID').AsInteger);
              SetHeaderDT(FormatDateTime('yyyy/mm/dd hh:mm:ss', FieldByName('HEADER_DT').AsDateTime, GetFS));
              SetShopID(FieldByName('SHOP_ID').AsInteger);
              SetExpKey1(FieldByName('EXP_KEY1').AsInteger);
              SetFromACID(FieldByName('FROM_ID').AsInteger);
              SetToACID(FieldByName('TO_ID').AsInteger);
            end;

            FrmEditDetailsHeader := TFrmEditDetailsHeader.Create(Application);
            OpenForm(Self, FrmEditDetailsHeader);
          end else begin
            MessageDlg(MSG_JP_000030, mtInformation, [mbOk], 0);
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmManageDetails.ProcDeleteDetailsHeader(Sender: TObject);
var
  LHeaderID : Integer;
  LResult   : TModalResult;
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          LHeaderID := AQu.FieldByName('HEADER_ID').AsInteger;
          with AQu do begin

            LResult:= QuestionDlg(
              REMOVE_DETAILS_HEADER_CAPTION, REMOVE_DETAILS_HEADER_MESSAGE,
              mtConfirmation, [mrYes, mrNo], 0);
            if LResult = mrYes then begin
              SQL.Text := SQL_20090002;
              with Params do begin
                ParamByName('pUserID').AsInteger   := GetUID;
                ParamByName('pHeaderID').AsInteger := LHeaderID;
              end;
              ExecSQL;

              SQL.Text := SQL_20090003;
              with Params do begin
                ParamByName('pUserID').AsInteger   := GetUID;
                ParamByName('pHeaderID').AsInteger := LHeaderID;
              end;

              ExecSQL;
              ATr.Commit;
            end else begin
              MessageDlg(
                CANCEL_OF_REMOVE_CAPTION, CANCEL_OF_REMOVE_MESSAGE,
                mtInformation, [mbOK], 0);
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
    with CommonDB do begin
      with Defs do begin
        OpenSelectQuery(ADS, AQu, SQL_20090001);
        if AQu.RecordCount = 0 then begin
          BtnEditDetailHeader.Enabled   := False;
          BtnDeleteDetailHeader.Enabled := False;
        end else begin
          BtnEditDetailHeader.Enabled   := True;
          BtnDeleteDetailHeader.Enabled := True;
        end;

        ADBG.AutoAdjustColumns;
      end;
    end;
  end;
end;

procedure TFrmManageDetails.AddDetailHeaderMouseOver(NewColor: TColor);
begin
  BtnAddDetailHeader.Color := NewColor;
end;

procedure TFrmManageDetails.BtnAddDetailHeaderEnter(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clSkyBlue);
  EditDetailHeaderMouseOver(clBtnFace);
  DeleteDetailHeaderMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmManageDetails.BtnAddDetailHeaderExit(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmManageDetails.EditDetailHeaderMouseOver(NewColor: TColor);
begin
  BtnEditDetailHeader.Color := NewColor;
end;

procedure TFrmManageDetails.BtnEditDetailHeaderEnter(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clBtnFace);
  EditDetailHeaderMouseOver(clSkyBlue);
  DeleteDetailHeaderMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmManageDetails.BtnEditDetailHeaderExit(Sender: TObject);
begin
  EditDetailHeaderMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmManageDetails.DeleteDetailHeaderMouseOver(NewColor: TColor);
begin
  BtnDeleteDetailHeader.Color := NewColor;
end;

procedure TFrmManageDetails.BtnDeleteDetailHeaderEnter(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clBtnFace);
  EditDetailHeaderMouseOver(clBtnFace);
  DeleteDetailHeaderMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmManageDetails.BtnDeleteDetailHeaderExit(Sender: TObject);
begin
  DeleteDetailHeaderMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmManageDetails.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmManageDetails.BtnGoBackEnter(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clBtnFace);
  EditDetailHeaderMouseOver(clBtnFace);
  DeleteDetailHeaderMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  Timer.Enabled     := True;
end;

procedure TFrmManageDetails.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

function TFrmManageDetails.GetGoBack: Boolean;
begin
  Result := FGoBack;
end;

procedure TFrmManageDetails.SetGoBack(GoBack: Boolean);
begin
  FGoBack := GoBack;
end;

procedure TFrmManageDetails.ActAddDetailsHeaderExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcAddDetailsHeader(Sender);
  Close;
end;

procedure TFrmManageDetails.ActEditDetailsHeaderExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcEditDetailsHeader(Sender);
  Close;
end;

procedure TFrmManageDetails.ActDeleteDetailsHeaderExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcDeleteDetailsHeader(Sender);
  Close;
end;

procedure TFrmManageDetails.ActGoBackExecute(Sender: TObject);
begin
  SetGoBack(True);
  Close;
end;

procedure TFrmManageDetails.ADBGMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ADBNavi.SetFocus;
  ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
end;

procedure TFrmManageDetails.ADBGWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
begin
  ADBNavi.SetFocus;
  ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
end;

procedure TFrmManageDetails.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn
  );
begin
  FNavigateBtn := Index;
end;

procedure TFrmManageDetails.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    BtnEditDetailHeader.SetFocus;
  end else if (Key = VK_TAB) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if CannotFocusedNavButton then begin
        if BtnDeleteDetailHeader.Enabled then begin
          BtnDeleteDetailHeader.SetFocus;
        end else begin
          BtnGoBack.SetFocus;
        end;
      end else begin
        ADBNavi.FindNextControl(ADBNavi, True, True, False).SetFocus;
      end;
    end;
  end;
end;

procedure TFrmManageDetails.AQuAfterScroll(DataSet: TDataSet);
begin
  case FNavigateBtn of
  nbFirst:
    if AQu.RecordCount > 0 then begin
      ADBNavi.FindNextControl(ADBNavi, True, True, False).SetFocus;
    end;
  nbPrior:
    if AQu.RecNo <= 1 then begin
      ADBNavi.FindNextControl(ADBNavi, True, True, False).SetFocus;
    end;
  nbNext:
    begin
      if AQu.RecNo = AQu.RecordCount then begin
        ADBNavi.FindNextControl(ADBNavi, False, True, False).SetFocus;
      end;
    end;
  nbLast: ADBNavi.FindNextControl(ADBNavi, False, True, False).SetFocus;
  end;

  Timer.Enabled := True;
end;

procedure TFrmManageDetails.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
  end;

  if GetGoBack then begin
    with FrmTopMenu do begin
      Visible := True;
    end;
  end;

  CloseAction      := caFree;
  FrmManageDetails := nil;
end;

procedure TFrmManageDetails.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  SetGoBack(True);

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmManageDetails.FormShow(Sender: TObject);
begin
  Self.Width             := 859;

  Self.KeyPreview        := True;

  Self.Color             := RGB(112, 168, 175);
  PnlAddDetail.Color     := RGB( 72, 122, 129);
  PnlEditDetail.Color    := RGB( 72, 122, 129);
  PnlDeleteDetail.Color  := RGB( 72, 122, 129);
  PnlGoBack.Color        := RGB( 72, 122, 129);

  // Clear values of next screen
  with Defs do begin
    SetHeaderDT('');

    SetShopID(0);
    SetExpKey1(0);
    SetFromACID(0);
    SetToACID(0);
    SetUnitID(0);
    SetTaxTypeID(0);

    SetQuantity(0);
    SetExcludeTax(0);
    SetTax(0);
    SetTotalAmount(0);
  end;

  { Debug }
  //Self.Width      := 986;
end;

procedure TFrmManageDetails.FormActivate(Sender: TObject);
begin
  try
    with CommonDB do begin
      with Defs do begin
        with AQu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          OpenSelectQuery(ADS, AQu, SQL_20090001);
          if RecordCount = 0 then begin
            BtnEditDetailHeader.Enabled   := False;
            BtnDeleteDetailHeader.Enabled := False;
          end else begin
            BtnEditDetailHeader.Enabled   := True;
            BtnDeleteDetailHeader.Enabled := True;
          end;
        end;

        ADBG.AutoAdjustColumns;
      end;
    end;
  finally
  end;
end;

procedure TFrmManageDetails.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Timer.Enabled := True;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnAddDetailHeader' then begin
      ActAddDetailsHeader.Execute;
    end else if ActiveControl.Name = 'BtnEditDetailHeader' then begin
      ActEditDetailsHeader.Execute;
    end else if ActiveControl.Name = 'BtnDeleteDetailHeader' then begin
      ActDeleteDetailsHeader.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

procedure TFrmManageDetails.TimerTimer(Sender: TObject);
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

