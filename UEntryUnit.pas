unit UEntryUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, DBGrids, LCLIntf, ActnList, UDBNavi,
  UDBG, Types, LMessages;

type

  { TFrmEntryUnit }

  TFrmEntryUnit = class(TForm)
    ADBGrid: TDBG;
    ADS          : TDataSource;
    AQu          : TSQLQuery;
    ADSNextID    : TDataSource;
    AQuNextID    : TSQLQuery;
   { ActionLists }
    ActionList   : TActionList;
    ActCancel    : TAction;
    ActGoBack    : TAction;
    ActInsert    : TAction;
    ActSave      : TAction;
    ADBNavi      : TDBNavi;
    DBCBDisabled : TDBCheckBox;
    DBEdtUnitID  : TDBEdit;
    DBEdtUnit    : TDBEdit;
    LblDisabled1 : TLabel;
    LblDisabled2 : TLabel;
    LblDisabled3 : TLabel;
    LblUnitID1   : TLabel;
    LblUnitID2   : TLabel;
    LblUnit1     : TLabel;
    LblUnit2     : TLabel;
    BtnInsert    : TPanel;
    BtnCancel    : TPanel;
    BtnSave      : TPanel;
    BtnGoBack    : TPanel;
    Panel1       : TPanel;
    Panel2       : TPanel;
    Panel3       : TPanel;
    Panel4       : TPanel;
    PnlCancel    : TPanel;
    PnlSave      : TPanel;
    PnlGoBack    : TPanel;
    PnlInsert    : TPanel;
    Shape1       : TShape;
    Shape2       : TShape;
    Shape3       : TShape;
    Timer        : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADBGridMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure ADBGridWMVScroll(Sender: TObject; var Message: TLMVScroll);
    procedure ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AQuAfterScroll(DataSet: TDataSet);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBEdtUnitChange(Sender: TObject);
    procedure DBEdtUnitEnter(Sender: TObject);
    procedure DBEdtUnitExit(Sender: TObject);
    procedure DBEdtUnitIDChange(Sender: TObject);
    procedure DBEdtUnitIDEnter(Sender: TObject);
    procedure DBEdtUnitIDExit(Sender: TObject);
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
    FDoCommit          : Boolean;
    FReOpenDS          : Boolean;
    FInsert            : Boolean;
    FUnitID            : Integer;
    FUnit              : String;
    FDisabled          : Boolean;
    procedure BackupValues;
    function CannotFocusedNavButton: Boolean;
    procedure ProcInsert(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure InsertMouseOver(NewColor: TColor);
    procedure SaveMouseOver(NewColor: TColor);
    function GetUnit: String;
    procedure SetUnit(ArgUnit: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
  public

  end;

var
  FrmEntryUnit: TFrmEntryUnit;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UManageDetails,
  UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmEntryUnit }

procedure TFrmEntryUnit.BackupValues;
begin
  with Defs do begin
    with DBEdtUnitID do begin
      if Text <> '' then begin;
        SetUnitID(StrToInt(Text));
      end else begin
        SetUnitID(0);
      end;
    end;

    SetUnit(DBEdtUnit.Text);

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

function TFrmEntryUnit.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

procedure TFrmEntryUnit.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        if AQu.RecordCount > 0 then begin
          FInsert := False;
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20150001);
        end;
      end;

      if AQu.RecordCount = 0 then begin
        DBEdtUnit.SetFocus;
      end else begin
        ADBNavi.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.ProcInsert(Sender: TObject);
var
  LNextID: Integer;
begin
  if Not FInsert then begin
    with CommonDB do begin
      with Defs do begin
        try
          with ACn do begin
            if Not Connected then begin
              Open;
            end;
          end;
        except
          on E: Exception do begin
            ShowMessage(MSG_JP_000013 + ' : ' + E.Message);
          end;
        end;

        ATr.Active := False;
        with ATr do begin
          if Not Active then begin
            StartTransaction;
          end;
        end;

        CloseQuery(AQu);
        with AQu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Not Active then begin
            OpenSelectQuery(ADS, AQu, SQL_20150001);
          end;

          Insert;

          if GetUnitID = 0 then begin
            OpenSelectQuery(ADSNextID, AQuNextID, SQL_20150002);
            LNextID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

            CloseQuery(AQuNextID);
            DBEdtUnitID.Text := IntToStr(LNextID);

            SetUnitID(LNextID);
          end;


          FInsert := True;

          DBCBDisabled.Checked := False;
          DBEdtUnit.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.ProcSave(Sender: TObject);
var
  LNextUnitID : Integer;
  LNow        : String;
begin
  FDoCommit := True;
  try
    try
      with CommonDB do begin
        with Defs do begin
          CloseQuery(AQu);

          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20150003;
            with Params do begin
              if GetUnitID > 0 then begin
                OpenSelectQuery(ADSNextID, AQuNextID, SQL_20150002);
                LNextUnitID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

                CloseQuery(AQuNextID);

                ParamByName('pUnitID').AsInteger := LNextUnitID;
              end else begin
                ParamByName('pUnitID').AsInteger := GetUnitID;
              end;
              ParamByName('pUnit').AsAnsiString     := GetUnit;
              ParamByName('pOrderID').AsInteger     := ParamByName('pUnitID').AsInteger;
              ParamByName('pDisabled').AsBoolean    := GetDisabled;
              LNow                                  := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              ParamByName('pEntryDT').AsAnsiString  := LNow;
              ParamByName('pUpdateDT').AsAnsiString := LNow;
            end;

            ExecSQL;
            ATr.Commit;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
    FInsert := False;
  end;

  FReOpenDS     := True;
  Timer.Enabled := True;
  FDoCommit     := False;
end;

procedure TFrmEntryUnit.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryUnit.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryUnit.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryUnit.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

function TFrmEntryUnit.GetUnit: String;
begin
  Result := FUnit;
end;

procedure TFrmEntryUnit.SetUnit(ArgUnit: String);
begin
  FUnit := ArgUnit;
end;

function TFrmEntryUnit.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryUnit.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryUnit.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);

  ADBNavi.SetFocus;
  ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
end;

procedure TFrmEntryUnit.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryUnit.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryUnit.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryUnit.ADBGridEnter(Sender: TObject);
begin

end;

procedure TFrmEntryUnit.ADBGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FInsert then begin;
    if Not FDBGridClicked then begin
      FDBGridClicked := True;
      ADBGridSelectEditor(
        Sender, ADBGrid.LastColumn, TWinControl(ADBGrid));

      ADBNavi.SetFocus;
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;

      Abort;
    end;
  end;
end;

procedure TFrmEntryUnit.ADBGridMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if FInsert then begin
    if DBEdtUnit.Text = '' then begin
      if MessageDlg(MSG_JP_000042,
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        // 「はい」が選ばれたらキャンセル処理を実行
        ProcCancel(Self);
      end else begin
        // 「いいえ」が選ばれたらスクロール自体を中止する
        Abort;
      end;
    end else begin
      if MessageDlg(MSG_JP_000043,
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        // 「はい」が選ばれたらキャンセル処理を実行
        ProcCancel(Self);
      end else begin
        // 「いいえ」が選ばれたらスクロール自体を中止する
        Abort;
      end;
    end;
  end else begin
    FDBGridClicked := False;
  end;
end;

procedure TFrmEntryUnit.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  if FDBGridClicked then begin
    if FInsert then begin
      if DBEdtUnit.Text = '' then begin
        if MessageDlg(MSG_JP_000042,
                      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          // 「はい」が選ばれたらキャンセル処理を実行
          ProcCancel(Self);
        end else begin
          // 「いいえ」が選ばれたらスクロール自体を中止する
          Abort;
        end;
      end else begin
        if MessageDlg(MSG_JP_000043,
                      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          // 「はい」が選ばれたらキャンセル処理を実行
          ProcCancel(Self);
        end else begin
          // 「いいえ」が選ばれたらスクロール自体を中止する
          Abort;
        end;
      end;
    end else begin
      FDBGridClicked := False;
    end;
  end;

  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryUnit.ADBGridWMVScroll(Sender: TObject;
  var Message: TLMVScroll);
begin
  if FInsert then begin;
    if Not FDBGridClicked then begin
      FDBGridClicked := True;
      ADBGridSelectEditor(Sender, ADBGrid.LastColumn, TWinControl(ADBGrid));

      ADBNavi.SetFocus;
      ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;

      Abort;
    end;
  end;
end;

procedure TFrmEntryUnit.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
begin
  FNavigateBtn := Index;

  with CommonDB do begin
    if AQu.RecordCount > 0 then begin
      if FInsert then begin
        ProcCancel(Sender);
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    BtnGoBack.SetFocus;
  end else if (Key = VK_TAB) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if CannotFocusedNavButton then begin
        BtnInsert.SetFocus;
      end else begin
        ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.AQuAfterScroll(DataSet: TDataSet);
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

procedure TFrmEntryUnit.DBCBDisabledChange(Sender: TObject);
begin
  if Not FDoCommit then begin;
    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
      DBCBDisabled.Checked := True;
    end else begin
      SetDisabled(False);
      DBCBDisabled.Checked := False;
    end;
    
    Timer.Enabled := True;
  end;
end;

procedure TFrmEntryUnit.DBCBDisabledEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBCBDisabledExit(Sender: TObject);
begin
  Shape3.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBEdtUnitChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetUnit(DBEdtUnit.Text);
  end;
end;

procedure TFrmEntryUnit.DBEdtUnitEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBEdtUnitExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBEdtUnitIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with Defs do begin
      with DBEdtUnitID do begin
        if Text <> '' then begin
          SetUnitID(StrToInt(Text));
        end else begin
          SetUnitID(0);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.DBEdtUnitIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBEdtUnitIDExit(Sender: TObject);
begin
  Shape1.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
  end;

  with Defs do begin
    // Restore value of previous screen
    SetUnitID(FUnitID);

    if GetEntryUnit = 0 then begin
      FrmManageDetails         := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible := True;
    end else if GetEntryUnit = 1 then begin
      FrmAddDetail             := TFrmAddDetail.Create(Application);
      FrmAddDetail.Visible     := True;
    end else if GetEntryUnit = 2 then begin
      FrmEditDetail            := TFrmEditDetail.Create(Application);
      FrmEditDetail.Visible    := True;
    end;
  end;

  CloseAction                  := caFree;
  FrmEntryUnit                 := nil;
end;

procedure TFrmEntryUnit.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FReOpenDS           := False;
  FDoCommit           := False;
  FInsert             := False;
  Timer.Enabled       := False;

  FDBGridClicked     := False;

  //FTab            := FTAB_UNDEFINED;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryUnit.FormShow(Sender: TObject);
begin
  Self.Width      := 594;

  Self.KeyPreview := True;

  Self.Color      := RGB(112, 168, 175);
  PnlInsert.Color := RGB( 72, 122, 129);
  PnlCancel.Color := RGB( 72, 122, 129);
  PnlSave.Color   := RGB( 72, 122, 129);
  PnlGoBack.Color := RGB( 72, 122, 129);

  with Defs do begin
    FUnitID       := GetUnitID;
  end;

  { Debug }
  //Self.Width      := 776;
end;

procedure TFrmEntryUnit.FormActivate(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with ACn do begin
            if Not Connected then
              Open;
          end;

          with ATr do begin
            if Not Active then begin
              StartTransaction;
            end;
          end;

          OpenSelectQuery(ADS, AQu, SQL_20150001);
          ProcInsert(Sender);
        end;
      end;

      ADBGrid.AutoAdjustColumns;
      Timer.Enabled := True;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  finally
  end;
end;

procedure TFrmEntryUnit.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Timer.Enabled := True;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnInsert' then begin
      ActInsert.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

procedure TFrmEntryUnit.TimerTimer(Sender: TObject);
var
  i            : Integer;
  LTargetIndex : Integer;
begin
  Timer.Enabled      := False;

  if FInsert then begin
    if DBCBDisabled.State = cbChecked then begin
      AQu.FieldByName('DISABLED').AsBoolean := True;
    end else begin
      AQu.FieldByName('DISABLED').AsBoolean := False;
    end;
  end;

  if FReOpenDS then begin
    with CommonDB do begin
      with Defs do begin
        OpenSelectQuery(ADS, AQu, SQL_20150001);
      end;
    end;
    FReOpenDS          := False;
  end;

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

