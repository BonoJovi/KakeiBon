unit UEntryMaker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, DBGrids, LCLIntf, ActnList, UDBNavi,
  UDBG, LMessages, Types;

type

  { TFrmEntryMaker }

  TFrmEntryMaker = class(TForm)
    ActCancel1: TAction;
    ActCommit1: TAction;
    ActInsert1: TAction;
    ActQuit1: TAction;
    ADBGrid: TDBG;
    ADS            : TDataSource;
    AQu            : TSQLQuery;
    ADSNextID      : TDataSource;
    AQuNextID      : TSQLQuery;
    { ActionLists }
    ActionList     : TActionList;
    ActCancel      : TAction;
    ActGoBack      : TAction;
    ActInsert      : TAction;
    ActSave        : TAction;
    ADBNavi        : TDBNavi;
    BtnCancel      : TPanel;
    BtnGoBack      : TPanel;
    BtnInsert      : TPanel;
    BtnSave        : TPanel;
    DBCBDisabled   : TDBCheckBox;
    DBEdtUserID: TDBEdit;
    DBEdtMakerID   : TDBEdit;
    DBEdtMakerName : TDBEdit;
    LblDisabled1   : TLabel;
    LblDisabled2   : TLabel;
    LblDisabled3   : TLabel;
    LblMakerID1    : TLabel;
    LblMakerID2    : TLabel;
    LblMakerName   : TLabel;
    Panel1         : TPanel;
    Panel2         : TPanel;
    Panel3         : TPanel;
    Panel4         : TPanel;
    PnlCancel      : TPanel;
    PnlGoBack      : TPanel;
    PnlInsert      : TPanel;
    PnlSave        : TPanel;
    Shape1         : TShape;
    Shape2         : TShape;
    Shape3         : TShape;
    Timer          : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
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
    procedure DBEdtMakerIDChange(Sender: TObject);
    procedure DBEdtMakerIDEnter(Sender: TObject);
    procedure DBEdtMakerIDExit(Sender: TObject);
    procedure DBEdtMakerNameChange(Sender: TObject);
    procedure DBEdtMakerNameEnter(Sender: TObject);
    procedure DBEdtMakerNameExit(Sender: TObject);
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
    FMakerID           : Integer;
    FMakerName         : String;
    FDisabled          : Boolean;
    procedure BackupValues;
    function CannotFocusedNavButton: Boolean;
    procedure ProcCancel(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure InsertMouseOver(NewColor: TColor);
    procedure SaveMouseOver(NewColor: TColor);
    function GetMakerName: String;
    procedure SetMakerName(MakerName: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
  public

  end;

var
  FrmEntryMaker: TFrmEntryMaker;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu,
  UAddDetail, UEditDetail, UEntryBrandName;

{$R *.lfm}

{ TFrmEntryMaker }

procedure TFrmEntryMaker.BackupValues;
begin
  with Defs do begin
    with DBEdtMakerID do begin
      if Text <> '' then begin;
        SetMakerID(StrToInt(Text));
      end else begin
        SetMakerID(0);
      end;
    end;

    SetMakerName(DBEdtMakerName.Text);

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

function TFrmEntryMaker.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

procedure TFrmEntryMaker.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        if AQu.RecordCount > 0 then begin
          FInsert := False;
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20130001);
        end;
      end;

      if AQu.RecordCount = 0 then begin
        DBEdtMakerName.SetFocus;
      end else begin
        ADBNavi.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.ProcInsert(Sender: TObject);
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
            OpenSelectQuery(ADS, AQu, SQL_20130001);
          end;

          Insert;

          DBEdtUserID.Text := IntToStr(GetUID);

          if GetMakerID = 0 then begin
            OpenSelectQuery(ADSNextID, AQuNextID, SQL_20130003);
            LNextID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

            CloseQuery(AQuNextID);
            DBEdtMakerID.Text := IntToStr(LNextID);

            SetMakerID(LNextID);
          end;


          FInsert := True;

          DBCBDisabled.Checked := False;
          DBEdtMakerName.SetFocus;
        end;
      end;
    end;
  end;
end;
 
procedure TFrmEntryMaker.ProcSave(Sender: TObject);
var
  LNextID : Integer;
  LNow    : String;
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

            SQL.Text := SQL_20130004;
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
            end;

            if GetMakerID > 0 then begin
              OpenSelectQuery(ADSNextID, AQuNextID, SQL_20130003);
              LNextID                      := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              CloseQuery(AQuNextID);

              with Params do begin
                ParamByName('pMakerID').AsInteger := LNextID;
              end;
            end else begin
              with Params do begin
                ParamByName('pMakerID').AsInteger := GetMakerID;
              end;
            end;

            with Params do begin
              ParamByName('pMakerName').AsAnsiString := GetMakerName;
              ParamByName('pDisabled').AsBoolean     := GetDisabled;
              LNow                                   := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              ParamByName('pEntryDT').AsAnsiString   := LNow;
              ParamByName('pUpdateDT').AsAnsiString  := LNow;
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

procedure TFrmEntryMaker.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryMaker.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryMaker.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryMaker.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  Timer.Enabled     := True;
end;

function TFrmEntryMaker.GetMakerName: String;
begin
  Result := FMakerName;
end;

procedure TFrmEntryMaker.SetMakerName(MakerName: String);
begin
  FMakerName := MakerName;
end;

function TFrmEntryMaker.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryMaker.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryMaker.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);

  ADBNavi.SetFocus;
  ADBNavi.FindNextControl(ADBNavi, True, True, True).SetFocus;
end;

procedure TFrmEntryMaker.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryMaker.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryMaker.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryMaker.ADBGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TFrmEntryMaker.ADBGridMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if FInsert then begin
    if DBEdtMakerName.Text = '' then begin
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

procedure TFrmEntryMaker.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  if FDBGridClicked then begin
    if FInsert then begin
      if DBEdtMakerName.Text = '' then begin
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

procedure TFrmEntryMaker.ADBGridWMVScroll(Sender: TObject;
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

procedure TFrmEntryMaker.ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
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

procedure TFrmEntryMaker.ADBNaviKeyUp(Sender: TObject; var Key: Word;
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

procedure TFrmEntryMaker.AQuAfterScroll(DataSet: TDataSet);
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

procedure TFrmEntryMaker.DBCBDisabledChange(Sender: TObject);
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

procedure TFrmEntryMaker.DBCBDisabledEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.DBCBDisabledExit(Sender: TObject);
begin
  Shape3.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.DBEdtMakerIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with Defs do begin
      with DBEdtMakerID do begin
        if Text <> '' then begin
          SetMakerID(StrToInt(Text));
        end else begin
          SetMakerID(0);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.DBEdtMakerIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmEntryMaker.DBEdtMakerIDExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmEntryMaker.DBEdtMakerNameChange(Sender: TObject);
begin
  with Defs do begin
    if Not FDoCommit then begin
      SetMakerName(DBEdtMakerName.Text);
    end;
  end;
end;

procedure TFrmEntryMaker.DBEdtMakerNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.DBEdtMakerNameExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
  end;

  with Defs do begin
    // Restore value of previous screen
    SetMakerID(FMakerID);

    if GetEntryMaker = 0 then begin
      FrmEntryBrandName := TFrmEntryBrandName.Create(Application);
      FrmEntryBrandName.Visible := True;
      SetEntryMaker(999);
    end else if GetEntryMaker = 1 then begin
      FrmAddDetail      := TFrmAddDetail.Create(Application);
      FrmAddDetail.Visible := True;
    end else if GetEntryMaker = 2 then begin
      FrmEditDetail   := TFrmEditDetail.Create(Application);
      FrmEditDetail.Visible := True;
    end;
  end;

  CloseAction               := caFree;
  FrmEntryMaker             := nil;
end;

procedure TFrmEntryMaker.FormCreate(Sender: TObject);
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

procedure TFrmEntryMaker.FormShow(Sender: TObject);
begin
  Self.Width      := 599;

  Self.KeyPreview := True;

  Self.Color      := RGB(112, 168, 175);
  PnlInsert.Color := RGB( 72, 122, 129);
  PnlCancel.Color := RGB( 72, 122, 129);
  PnlSave.Color   := RGB( 72, 122, 129);
  PnlGoBack.Color := RGB( 72, 122, 129);

  with Defs do begin
    FMakerID      := GetMakerID;
  end;

  { Debug }
  //Self.Width      := 767;
end;

procedure TFrmEntryMaker.FormActivate(Sender: TObject);
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

          OpenSelectQuery(ADS, AQu, SQL_20130001);
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

procedure TFrmEntryMaker.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TFrmEntryMaker.TimerTimer(Sender: TObject);
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
        OpenSelectQuery(ADS, AQu, SQL_20130001);
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

