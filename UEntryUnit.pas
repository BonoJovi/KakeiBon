unit UEntryUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, LCLType,
  ActnList, UDBAccess, UDBNavi;

type

  { TFrmEntryUnit }

  TFrmEntryUnit = class(TForm)
    ADBNavi: TDBNavi;
    ADS          : TDataSource;
    AQu          : TSQLQuery;
    ADSNextID    : TDataSource;
    AQuNextID    : TSQLQuery;
    ActionList   : TActionList;
    ActInsert    : TAction;
    ActCancel    : TAction;
    ActSave      : TAction;
    ActGoBack    : TAction;
    ADBGrid      : TDBGrid;
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
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PnlCancel    : TPanel;
    PnlSave      : TPanel;
    PnlGoBack    : TPanel;
    PnlInsert    : TPanel;
    Shape1       : TShape;
    Shape2       : TShape;
    Shape3       : TShape;
    Timer        : TTimer;
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBEdtUnitEnter(Sender: TObject);
    procedure DBEdtUnitExit(Sender: TObject);
    procedure DBEdtUnitIDEnter(Sender: TObject);
    procedure DBEdtUnitIDExit(Sender: TObject);
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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FTab              : Boolean;
    FGuidePanels      : Array[0..3] of TPanel;
    FCurrentComponent : TObject;
    FDoCommit   : Boolean;
    FReOpenDS   : Boolean;
    FInsert     : Boolean;
    FIsDisabled : Boolean;
    FUnitID     : Variant;
    FUnit       : String;
    FDisabled   : Boolean;
    procedure BackupValues;
    function GetUnitID: Variant;
    procedure SetUnitID(UnitID: Variant);
    function GetUnit: String;
    procedure SetUnit(ArgUnit: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    property UnitID: Variant read GetUnitID write SetUnitID;
    property ArgUnit: String read GetUnit write SetUnit;
    property Disabled: Boolean read GetDisabled write SetDisabled;
  public

  end;

var
  FrmEntryUnit: TFrmEntryUnit;

implementation
uses
  UCommonDB, UDefs, UTopMenu, UManageDetails, UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmEntryUnit }

procedure TFrmEntryUnit.BackupValues;
begin
  with Defs do begin
    if DBEdtUnitID.Text <> '' then begin;
      SetUnitID(DBEdtUnitID.Text);
    end else begin
      SetUnitID(Null);
    end;

    SetUnit(DBEdtUnit.Text);

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

procedure TFrmEntryUnit.ProcInsert(Sender: TObject);
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
    DBEdtUnit.SetFocus;
  end;
end;

procedure TFrmEntryUnit.DBEdtUnitIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBEdtUnitEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBCBDisabledEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.ADBGridEnter(Sender: TObject);
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

procedure TFrmEntryUnit.ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
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
          DBEdtUnit.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryUnit.ADBNaviEnter(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.ADBNaviExit(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
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

procedure TFrmEntryUnit.DBCBDisabledExit(Sender: TObject);
begin
  Shape3.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBEdtUnitExit(Sender: TObject);
begin
  Shape2.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.DBEdtUnitIDExit(Sender: TObject);
begin
  Shape1.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        FInsert := False;
      end;
      ATr.Rollback;

      //CloseTransactions;
      //SetDatabaseNames;

      OpenSelectQueryByUnit(ADS, AQu, SQL_20150001);
      DBEdtUnit.SetFocus;
    end;
  end;
end;

procedure TFrmEntryUnit.ProcSave(Sender: TObject);
var
  LNextUnitID : Integer;
begin
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
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20150003;
            if (VarIsNull(GetUnitID)) Or (VarToStr(GetUnitID) = '') then begin
              //CloseConn(ACnNextID, ATrNextID, AQuNextID);
              //SetDatabaseNames;

              AQuNextID.SQLConnection  := ACn;
              AQuNextID.SQLTransaction := ATr;

              OpenSelectQueryByUnit(ADSNextID, AQuNextID, SQL_20150002);
              LNextUnitID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              CloseQuery(AQuNextID);

              with Params do begin
                ParamByName('pUnitID').AsInteger := LNextUnitID;
              end;
            end else begin
              with Params do begin
                ParamByName('pUnitID').AsInteger := StrToInt(VarToStr(GetUnitID));
              end;
            end;
            with Params do begin
              ParamByName('pUnit').AsAnsiString     := GetUnit;
              ParamByName('pOrderID').AsInteger     := ParamByName('pUnitID').AsInteger;
              ParamByName('pDisabled').AsBoolean    := GetDisabled;
              ParamByName('pEntryDT').AsAnsiString  := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              ParamByName('pUpdateDT').AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
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
end;

procedure TFrmEntryUnit.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryUnit.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

function TFrmEntryUnit.GetUnitID: Variant;
begin
  Result := FUnitID;
end;

procedure TFrmEntryUnit.SetUnitID(UnitID: Variant);
begin
  FUnitID := UnitID;
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

procedure TFrmEntryUnit.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryUnit.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEntryUnit.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryUnit.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryUnit.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryUnit.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    with Defs do begin
      CloseQuery(AQu);
      CloseQuery(AQuNextID);
    end;
  end;
  with Defs do begin
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

  FReOpenDS   := False;
  FIsDisabled := False;
  FDoCommit   := False;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryUnit.FormActivate(Sender: TObject);
begin
  FrmEntryUnit.Width      := 594;

  FrmEntryUnit.KeyPreview := True;

  FrmEntryUnit.Color := RGB(112, 168, 175);
  PnlInsert.Color    := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlSave.Color      := RGB( 72, 122, 129);
  PnlGoBack.Color    := RGB( 72, 122, 129);

  try
    with CommonDB do begin
      with Defs do begin
        with AQu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          OpenSelectQueryByUnit(ADS, AQu, SQL_20150001);
          ADBGrid.DataSource := ADS;
          if RecordCount = 0 then begin
            ProcInsert(Sender);
          end else begin
            FInsert := False;
          end;
          ADBGrid.AutoAdjustColumns;
          DBEdtUnit.SetFocus;
        end;
      end;
    end;
  finally
  end;

  { Debug }
  //FrmEntryUnit.Width      := 776;
end;

procedure TFrmEntryUnit.FormKeyUp(Sender: TObject; var Key: Word;
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

