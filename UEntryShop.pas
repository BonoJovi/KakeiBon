unit UEntryShop;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, DBGrids, DBCtrls, StdCtrls, LCLIntf, ActnList,
  UDBNavi, DBDateTimePicker;

type

  { TFrmEntryShop }

  TFrmEntryShop = class(TForm)
    ADS                  : TDataSource;
    AQu                  : TSQLQuery;
    ADSNextID            : TDataSource;
    AQuNextID            : TSQLQuery;
    { ActionLists }
    ActionList           : TActionList;
    ActInsert            : TAction;
    ActCancel            : TAction;
    ActGoBack            : TAction;
    ActSave              : TAction;
    ADBGrid              : TDBGrid;
    ADBNavi              : TDBNavi;
    DBCBDisabled         : TDBCheckBox;
    DBDTPEndBusinessDT   : TDBDateTimePicker;
    DBDTPUpdateDT        : TDBDateTimePicker;
    DBDTPStartBusinessDT : TDBDateTimePicker;
    DBDTPEntryDT         : TDBDateTimePicker;
    DBEdtShopName        : TDBEdit;
    DBEdtShopID          : TDBEdit;
    DBEdtPhoneNum        : TDBEdit;
    LblID1               : TLabel;
    LblStartBusinessDT1  : TLabel;
    LblStartBusinessDT2  : TLabel;
    LblStartBusinessDT3  : TLabel;
    LblStartBusinessDT4  : TLabel;
    LblEndBusinessDT1    : TLabel;
    LblEndBusinessDT2    : TLabel;
    LblEndBusinessDT3    : TLabel;
    LblEndBusinessDT4    : TLabel;
    LblDisabled1         : TLabel;
    LblDisabled2         : TLabel;
    LblID2               : TLabel;
    LblDisabled3         : TLabel;
    LblShopName1         : TLabel;
    LblShopName2         : TLabel;
    LblShopName3         : TLabel;
    LblPhoneNumber3      : TLabel;
    LblPhoneNumber2      : TLabel;
    LblPhoneNumber1      : TLabel;
    LblPhoneNumber4      : TLabel;
    BtnInsert            : TPanel;
    BtnCancel            : TPanel;
    BtnSave              : TPanel;
    BtnGoBack            : TPanel;
    Panel1               : TPanel;
    Panel2               : TPanel;
    Panel3               : TPanel;
    Panel4               : TPanel;
    PnlCancel            : TPanel;
    PnlSave              : TPanel;
    PnlGoBack            : TPanel;
    PnlInsert            : TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Timer                : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBGridSelectEditor(
      Sender: TObject; Column: TColumn; var Editor: TWinControl);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBDTPEndBusinessDTChange(Sender: TObject);
    procedure DBDTPEndBusinessDTEnter(Sender: TObject);
    procedure DBDTPEndBusinessDTExit(Sender: TObject);
    procedure DBDTPStartBusinessDTChange(Sender: TObject);
    procedure DBDTPStartBusinessDTEnter(Sender: TObject);
    procedure DBDTPStartBusinessDTExit(Sender: TObject);
    procedure DBEdtPhoneNumChange(Sender: TObject);
    procedure DBEdtPhoneNumEnter(Sender: TObject);
    procedure DBEdtPhoneNumExit(Sender: TObject);
    procedure DBEdtShopIDChange(Sender: TObject);
    procedure DBEdtShopIDEnter(Sender: TObject);
    procedure DBEdtShopIDExit(Sender: TObject);
    procedure DBEdtShopNameChange(Sender: TObject);
    procedure DBEdtShopNameEnter(Sender: TObject);
    procedure DBEdtShopNameExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FTab              : Boolean;
    FGuidePanels      : Array[0..3] of TPanel;
    FCurrentComponent : TObject;
    FDoCommit        : Boolean;
    FReOpenDS        : Boolean;
    FInsert          : Boolean;
    FShopID          : Variant;
    FShopName        : String;
    FPhoneNum        : String;
    FStartBusinessDT : String;
    FEndBusinessDT   : String;
    FDisabled        : Boolean;
    procedure BackupValues;
    procedure ProcInsert(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure InsertMouseOver(NewColor: TColor);
    procedure CancelMouseOver(NewColor: TColor);
    procedure SaveMouseOver(NewColor: TColor);
    procedure GoBackMouseOver(NewColor: TColor);
    function GetShopName: String;
    procedure SetShopName(ShopName: String);
    function GetPhoneNum: String;
    procedure SetPhoneNum(PhoneNum: String);
    function GetStartBusinessDT: String;
    procedure SetStartBusinessDT(StartBusinessDT: String);
    function GetEndBusinessDT: String;
    procedure SetEndBusinessDT(EndBusinessDT: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    property ShopName: String read GetShopName write SetShopName;
    property PhoneNum: String read GetPhoneNum write SetPhoneNum;
    property StartBusinessDT: String read GetStartBusinessDT write SetStartBusinessDT;
    property EndBusinessDT: String read GetEndBusinessDT write SetEndBusinessDT;
    property Disabled: Boolean read GetDisabled write SetDisabled;
  public

  end;

var
  FrmEntryShop: TFrmEntryShop;

implementation
uses
  LazLogger, UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageDetails,
  UAddDetailsHeader, UEditDetailsHeader;

{$R *.lfm}

{ TFrmEntryShop }

procedure TFrmEntryShop.BackupValues;
begin
  with CommonDB do begin
    with Defs do begin
      with DBEdtShopID do begin
        if Text <> '' then begin;
          SetShopID(Text);
        end else begin
          SetShopID(Null);
        end;
      end;

      SetShopName(DBEdtShopName.Text);
      SetPhoneNum(DBEdtPhoneNum.Text);
      SetStartBusinessDT(FormatDateTime(
        'yyyy/mm/dd hh:mm:ss',
        DBDTPStartBusinessDT.Field.AsDateTime, GetFS));
      if Not DBDTPEndBusinessDT.Field.IsNull then begin;
        SetEndBusinessDT(FormatDateTime(
          'yyyy/mm/dd hh:mm:ss',
          DBDTPEndBusinessDT.Field.AsDateTime, GetFS));
      end else begin
        SetEndBusinessDT('9999/12/31 23:59:59');
      end;
      if DBCBDisabled.State = cbChecked then begin
        SetDisabled(True);
      end else begin
        SetDisabled(False);
      end;
    end;
  end;
end;

procedure TFrmEntryShop.ProcInsert(Sender: TObject);
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
            OpenSelectQuery(ADS, AQu, SQL_20080001);
          end;

          if RecordCount > 0 then begin
            Insert;
          end;
          FInsert := True;
          DBCBDisabled.Checked := False;
          DBEdtShopName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryShop.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        if AQu.RecordCount > 0 then begin
          ATr.Rollback;
          OpenSelectQuery(ADS, AQu, SQL_20080001);
          FInsert := False;
        end;
      end;

      if AQu.RecordCount = 0 then begin
        DBEdtShopName.SetFocus;
      end else begin
        ADBNavi.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryShop.ProcSave(Sender: TObject);
var
  LNextShopID : Integer;
  LNow        : String;
begin
  FDoCommit := True;
  try
    try
      with CommonDB do begin
        with Defs do begin
          CloseQuery(AQu);

          with AQu do begin
            SQL.Text := SQL_20080004;
            with Params do begin
              ParamByName('pUserID').AsInteger   := GetUID;
            end;

            if (VarIsNull(GetShopID)) Or (VarToStr(GetShopID) = '') then begin
              OpenSelectQuery(ADSNextID, AQuNextID, SQL_20080003);
              LNextShopID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              with Params do begin
                ParamByName('pShopID').AsInteger := LNextShopID;
              end;
            end else begin
              with Params do begin
                ParamByName('pShopID').AsInteger := StrToInt(VarToStr(GetShopID));
              end;
            end;
            with Params do begin
              ParamByName('pShopName').AsAnsiString := GetShopName;
              ParamByName('pPhoneNum').AsAnsiString := GetPhoneNum;
              ParamByName('pStartBusinessDT').AsDateTime := StrToDateTime(GetStartBusinessDT, GetFS);
              if GetEndBusinessDT <> '' then begin
                ParamByName('pEndBusinessDT').AsDateTime := StrToDateTime(GetEndBusinessDT, GetFS);
              end else begin
                ParamByName('pEndBusinessDT').AsDateTime := StrToDateTime('9999/12/31 23:59:59', GetFS);
              end;
              ParamByName('pDisabled').AsBoolean         := GetDisabled;
              LNow                                       := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              ParamByName('pEntryDT').AsAnsiString       := LNow;
              ParamByName('pUpdateDT').AsAnsiString      := LNow;
            end;

            ExecSQL;
            ATr.Commit;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do
      begin
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

procedure TFrmEntryShop.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryShop.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryShop.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryShop.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryShop.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

function TFrmEntryShop.GetShopName: String;
begin
  Result := FShopName;
end;

procedure TFrmEntryShop.SetShopName(ShopName: String);
begin
  FShopName := ShopName;
end;

function TFrmEntryShop.GetPhoneNum: String;
begin
  Result := FPhoneNum;
end;

procedure TFrmEntryShop.SetPhoneNum(PhoneNum: String);
begin
  FPhoneNum := PhoneNum;
end;

function TFrmEntryShop.GetStartBusinessDT: String;
begin
  Result := FStartBusinessDT;
end;

procedure TFrmEntryShop.SetStartBusinessDT(StartBusinessDT: String);
begin
  FStartBusinessDT := StartBusinessDT;
end;

function TFrmEntryShop.GetEndBusinessDT: String;
begin
  Result := FEndBusinessDT;
end;

procedure TFrmEntryShop.SetEndBusinessDT(EndBusinessDT: String);
begin
  FEndBusinessDT := EndBusinessDT;
end;

function TFrmEntryShop.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryShop.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryShop.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEntryShop.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryShop.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryShop.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryShop.ADBGridEnter(Sender: TObject);
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

procedure TFrmEntryShop.ADBGridSelectEditor(
  Sender: TObject; Column: TColumn; var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryShop.ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
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
          DBEdtShopName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryShop.ADBNaviEnter(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.ADBNaviExit(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryShop.ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
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

procedure TFrmEntryShop.DBEdtShopIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with CommonDB do begin
      with Defs do begin
        SetShopID(DBEdtShopID.Text);
      end;
    end;
  end;
end;

procedure TFrmEntryShop.DBEdtShopIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmEntryShop.DBEdtShopIDExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmEntryShop.DBEdtShopNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetShopName(DBEdtShopName.Text);
  end;
end;

procedure TFrmEntryShop.DBEdtShopNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBEdtShopNameExit(Sender: TObject);
begin
  Shape2.Visible := False;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBEdtPhoneNumChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetPhoneNum(DBEdtPhoneNum.Text);
  end;
end;

procedure TFrmEntryShop.DBEdtPhoneNumEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBEdtPhoneNumExit(Sender: TObject);
begin
  Shape3.Visible := False;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBDTPStartBusinessDTChange(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if Not FDoCommit then begin
        SetStartBusinessDT(FormatDateTime(
          'yyyy/mm/dd hh:mm:ss',
          DBDTPStartBusinessDT.Field.AsDateTime, GetFS));
      end;
    end;
  end;
end;

procedure TFrmEntryShop.DBDTPStartBusinessDTEnter(Sender: TObject);
begin
  Shape4.Visible := True;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBDTPStartBusinessDTExit(Sender: TObject);
begin
  Shape4.Visible := False;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBDTPEndBusinessDTChange(Sender: TObject);
begin
  with Defs do begin
    if Not FDoCommit then begin
      if Not DBDTPEndBusinessDT.Field.IsNull then begin;
        SetEndBusinessDT(FormatDateTime(
          'yyyy/mm/dd hh:mm:ss',
          DBDTPEndBusinessDT.Field.AsDateTime, GetFS));
      end else begin
        SetEndBusinessDT('9999/12/31 23:59:59');
      end;
    end;
  end;
end;

procedure TFrmEntryShop.DBDTPEndBusinessDTEnter(Sender: TObject);
begin
  Shape5.Visible := True;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBDTPEndBusinessDTExit(Sender: TObject);
begin
  Shape5.Visible := False;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBCBDisabledChange(Sender: TObject);
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

procedure TFrmEntryShop.DBCBDisabledEnter(Sender: TObject);
begin
  Shape6.Visible := True;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.DBCBDisabledExit(Sender: TObject);
begin
  Shape6.Visible := False;

  Timer.Enabled     := True;
  FCurrentComponent := Sender;
end;

procedure TFrmEntryShop.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
  end;

  with Defs do begin
    // Restore value of previous screen
    SetShopID(FShopID);

    if GetEntryShop = 0 then begin
      FrmManageDetails    := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible  := True;
    end else if GetEntryShop = 1 then begin
      FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
      FrmAddDetailsHeader.Visible  := True;
    end else if GetEntryShop = 2 then begin
      FrmEditDetailsHeader := TFrmEditDetailsHeader.Create(Application);
      FrmEditDetailsHeader.Visible  := True;
    end;
  end;

  CloseAction  := caFree;
  FrmEntryShop := nil;
end;

procedure TFrmEntryShop.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FReOpenDS := False;
  FDoCommit := False;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryShop.FormShow(Sender: TObject);
begin
  FrmEntryShop.Width      := 598;

  FrmEntryShop.KeyPreview := True;

  FrmEntryShop.Color := RGB(112, 168, 175);
  PnlInsert.Color    := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlSave.Color      := RGB( 72, 122, 129);
  PnlGoBack.Color    := RGB( 72, 122, 129);

  with Defs do begin
    FShopID := GetShopID;
  end;

  { Debug }
  //FrmEntryShop.Width      := 893;
end;

procedure TFrmEntryShop.FormActivate(Sender: TObject);
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

          OpenSelectQuery(ADS, AQu, SQL_20080001);
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

procedure TFrmEntryShop.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TFrmEntryShop.TimerTimer(Sender: TObject);
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
        OpenSelectQuery(ADS, AQu, SQL_20080001);
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

