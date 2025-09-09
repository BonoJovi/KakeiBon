unit UEntryMaker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, LCLType,
  ActnList, UDBAccess, UDBNavi;

type

  { TFrmEntryMaker }

  TFrmEntryMaker = class(TForm)
    ADS            : TDataSource;
    AQu            : TSQLQuery;
    ActCancel1     : TAction;
    ActCommit1     : TAction;
    ActInsert1     : TAction;
    ActQuit1       : TAction;
    ADBNavi        : TDBNavi;
    ADSNextID      : TDataSource;
    AQuNextID      : TSQLQuery;
    ActionList     : TActionList;
    ActInsert      : TAction;
    ActCancel      : TAction;
    ActSave        : TAction;
    ActGoBack      : TAction;
    ADBGrid        : TDBGrid;
    DBCBDisabled   : TDBCheckBox;
    DBEdtMakerID   : TDBEdit;
    DBEdtMakerName : TDBEdit;
    LblDisabled1   : TLabel;
    LblDisabled2   : TLabel;
    LblDisabled3   : TLabel;
    LblMakerID1    : TLabel;
    LblMakerID2    : TLabel;
    LblMakerName   : TLabel;
    BtnInsert      : TPanel;
    BtnCancel      : TPanel;
    BtnSave        : TPanel;
    BtnGoBack      : TPanel;
    Panel1         : TPanel;
    Panel2         : TPanel;
    Panel3         : TPanel;
    Panel4         : TPanel;
    PnlCancel      : TPanel;
    PnlSave        : TPanel;
    PnlGoBack      : TPanel;
    PnlInsert      : TPanel;
    Shape1         : TShape;
    Shape2         : TShape;
    Shape3         : TShape;
    Timer          : TTimer;
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBEdtMakerIDEnter(Sender: TObject);
    procedure DBEdtMakerIDExit(Sender: TObject);
    procedure DBEdtMakerNameEnter(Sender: TObject);
    procedure DBEdtMakerNameExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure InsertMouseOver(NewColor: TColor);
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure SaveMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBEdtMakerIDChange(Sender: TObject);
    procedure DBEdtMakerNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FTab               : Boolean;
    FGuidePanels       : Array[0..3] of TPanel;
    FCurrentComponent  : TObject;
    FDoCommit          : Boolean;
    FIsDisabled        : Boolean;
    FReOpenDS          : Boolean;
    FInsert            : Boolean;
    FInsertPrev        : Boolean;
    FDoCancelAndInsert : Boolean;
    FMakerID           : Variant;
    FMakerName         : String;
    FDisabled          : Boolean;
    procedure BackupValues;
    function GetMakerID: Variant;
    procedure SetMakerID(MakerID: Variant);
    function GetMakerName: String;
    procedure SetMakerName(MakerName: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    property MakerID: Variant read GetMakerID write SetMakerID;
    property MakerName: String read GetMakerName write SetMakerName;
    property Disabled: Boolean read GetDisabled write SetDisabled;
  public

  end;

var
  FrmEntryMaker: TFrmEntryMaker;

implementation
uses
  UCommonDB, UDefs, UTopMenu, UAddDetail, UEditDetail, UEntryBrandName;

{$R *.lfm}

{ TFrmEntryMaker }

procedure TFrmEntryMaker.BackupValues;
begin
  with Defs do begin
    if DBEdtMakerID.Text <> '' then begin;
      SetMakerID(DBEdtMakerID.Text);
    end else begin
      SetMakerID(Null);
    end;

    SetMakerName(DBEdtMakerName.Text);

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

procedure TFrmEntryMaker.ProcInsert(Sender: TObject);
begin
  if Not FInsert then begin
    with AQu do begin
      Edit;
      if AQu.RecordCount > 0 then begin;
        Insert;
      end;
      FInsert := True;
    end;

    DBCBDisabled.Field.AsBoolean := False;
    DBEdtMakerName.SetFocus;
  end;
end;

procedure TFrmEntryMaker.DBEdtMakerIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.DBCBDisabledEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.ADBNaviClick(Sender: TObject; Button: TDBNavButtonType
  );
begin
  if FInsert then begin
    ProcCancel(Sender);
  end;

  with CommonDB do begin
    with Defs do begin
      if (Button = nbFirst) or (Button = nbPrior) then begin
        if AQu.RecNo = 1  then begin
          AQu.First;
          BtnGoBack.SetFocus;
        end;
      end else if (Button = nbNext) Or (Button = nbLast) then begin
        if AQu.RecNo = AQu.RecordCount  then begin
          AQu.Last;
          DBEdtMakerName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.ADBGridEnter(Sender: TObject);
var
  LDBEdit : TDBEdit;
  LDBCB   : TDBCheckBox;
  LPanel  : TPanel;
begin
  if FInsert then begin;
    ProcCancel(Sender);
  end;

  if FCurrentComponent is TDBNavi then begin
    ADBNavi.SetFocus;
  end else if FCurrentComponent is TDBEdit then begin
    LDBEdit := FCurrentComponent as TDBEdit;
    LDBEdit.SetFocus;
  end else if FCurrentComponent is TDBCheckBox then begin
    LDBCB := FCurrentComponent as TDBCheckBox;
    LDBCB.SetFocus;
  end else if FCurrentComponent is TPanel then begin
    LPanel := FCurrentComponent as TPanel;
    LPanel.SetFocus;
  end;
end;

procedure TFrmEntryMaker.ADBNaviEnter(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.ADBNaviExit(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND
  );
begin
  if FTab then begin
    try
      if Screen.ActiveControl is TDBNavi then begin
        TWinControl(ADBNavi.FindNextControl(ADBNavi, True, True, True)).SetFocus;
      end;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  end;

  Timer.Enabled := True;
end;

procedure TFrmEntryMaker.DBCBDisabledExit(Sender: TObject);
begin
  Shape3.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.DBEdtMakerIDExit(Sender: TObject);
begin
  Shape1.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.DBEdtMakerNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.DBEdtMakerNameExit(Sender: TObject);
begin
  Shape2.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        FInsert := False;
      end;
      ATr.Rollback;

      //CloseTransactions;
      //SetDatabaseNames;

      OpenSelectQuery(ADS, AQu, SQL_20130001);
      DBEdtMakerName.SetFocus;
    end;
  end;
end;

procedure TFrmEntryMaker.ProcSave(Sender: TObject);
var
  LNextMakerID : Integer;
begin
  FDoCommit := True;
  try
    try
      with CommonDB do begin
        with Defs do begin
          with ATr do begin
            if Not Active then begin
              StartTransaction;
            end;
          end;

          with AQu do begin
            SQL.Text := SQL_20130004;
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
              if (VarIsNull(GetMakerID)) Or (VarToStr(GetMakerID) = '') then begin
                //CloseTransactions;
                //SetDatabaseNames;

                OpenSelectQuery(ADSNextID, AQuNextID, SQL_20130003);
                LNextMakerID                             := AQuNextID.FieldByName('NEXT_ID').AsInteger;

                CloseQuery(AQuNextID);

                ParamByName('pMakerID').AsInteger := LNextMakerID;
              end else begin
                ParamByName('pMakerID').AsInteger := StrToInt(VarToStr(GetMakerID));
              end;
              ParamByName('pMakerName').AsAnsiString := GetMakerName;
              ParamByName('pDisabled').AsBoolean     := GetDisabled;
              ParamByName('pEntryDT').AsAnsiString   := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              ParamByName('pUpdateDT').AsAnsiString  := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
            end;

            //CloseTransactions;
            //SetDatabaseNames;

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

procedure TFrmEntryMaker.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryMaker.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

function TFrmEntryMaker.GetMakerID: Variant;
begin
  Result := FMakerID;
end;

procedure TFrmEntryMaker.SetMakerID(MakerID: Variant);
begin
  FMakerID := MakerID;
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

procedure TFrmEntryMaker.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryMaker.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEntryMaker.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryMaker.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryMaker.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryMaker.DBEdtMakerIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetMakerID(DBEdtMakerID.Text);
  end;
end;

procedure TFrmEntryMaker.DBEdtMakerNameChange(Sender: TObject);
begin
  with Defs do begin
    if Not FDoCommit then begin
      SetMakerName(DBEdtMakerName.Text);
    end;
  end;
end;

procedure TFrmEntryMaker.DBCBDisabledChange(Sender: TObject);
begin
  if Not FDoCommit then begin;
    if Not FDoCommit then begin
      if DBCBDisabled.State = cbChecked then begin
        SetDisabled(True);
      end else begin
        SetDisabled(False);
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin

  with Defs do begin
    //CloseTransactions;

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
    //SetDatabaseNames;

    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FDoCancelAndInsert := True;

  FReOpenDS          := False;
  FIsDisabled        := False;
  FDoCommit          := False;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryMaker.FormShow(Sender: TObject);
begin
  FrmEntryMaker.Width      := 599;

  FrmEntryMaker.KeyPreview := True;

  FrmEntryMaker.Color := RGB(112, 168, 175);
  PnlInsert.Color     := RGB( 72, 122, 129);
  PnlCancel.Color     := RGB( 72, 122, 129);
  PnlSave.Color       := RGB( 72, 122, 129);
  PnlGoBack.Color     := RGB( 72, 122, 129);

  { Debug }
  //FrmEntryMaker.Width      := 767;
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
      BtnGoBack.SetFocus;
    end;
    Timer.Enabled := True;
  end else begin
    Timer.Enabled := True;
  end;

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

