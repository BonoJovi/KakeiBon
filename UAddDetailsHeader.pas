unit UAddDetailsHeader;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, Variants, SysUtils, SQLDB, SQLite3Conn, DB, Forms,
  Controls, Graphics, Dialogs, StdCtrls, DBCtrls, DBGrids, ExtCtrls, LCLIntf,
  LCLType, ActnList, DateTimePicker, DBDateTimePicker, UDefs, UDBNavi;

type

  { TFrmAddDetailsHeader }

  TFrmAddDetailsHeader = class(TForm)
    { ActionLists }
    ActionList       : TActionList;
    ActAddDetail     : TAction;
    ActEntryAccount  : TAction;
    ActEntryShop     : TAction;
    ActEditDetail    : TAction;
    ActDeleteDetail  : TAction;
    ActGoBack        : TAction;
    ADBNavi          : TDBNavi;
    ADSToAC          : TDataSource;
    ADSFromAC        : TDataSource;
    ADSExp1          : TDataSource;
    ADSShop          : TDataSource;
    ADSDetail        : TDataSource;
    ADSNextID        : TDataSource;
    AQuToAC          : TSQLQuery;
    AQuFromAC        : TSQLQuery;
    AQuExp1          : TSQLQuery;
    AQuShop          : TSQLQuery;
    AQuDetail        : TSQLQuery;
    AQuNextID        : TSQLQuery;
    ADS              : TDataSource;
    DBDTPHeaderDT    : TDBDateTimePicker;
    DBDTPEntryDT     : TDBDateTimePicker;
    DBDTPUpdateDT    : TDBDateTimePicker;
    DBEdtHeaderID    : TDBEdit;
    DBEdtFromID      : TDBEdit;
    DBEdtShopID      : TDBEdit;
    DBEdtTotalAmount : TDBEdit;
    DBEdtUserID      : TDBEdit;
    DBEdtToID        : TDBEdit;
    DBEdtPhoneNum    : TDBEdit;
    DBEdtExpKey1     : TDBEdit;
    ADBGrid          : TDBGrid;
    DBLCBExp1        : TDBLookupComboBox;
    DBLCBShopName    : TDBLookupComboBox;
    DBLCBFromAC      : TDBLookupComboBox;
    DBLCBToAC        : TDBLookupComboBox;
    DTPDay           : TDateTimePicker;
    DTPHour          : TDateTimePicker;
    DTPMonth         : TDateTimePicker;
    DTPYear          : TDateTimePicker;
    EdtTotalAmount   : TEdit;
    LblYear          : TLabel;
    LblMonth         : TLabel;
    LblDay           : TLabel;
    LblHour          : TLabel;
    LblCategory      : TLabel;
    LblDateTime1     : TLabel;
    LblDateTime2     : TLabel;
    LblFrom1         : TLabel;
    LblFrom2         : TLabel;
    LblFrom3         : TLabel;
    LblPhoneNum1     : TLabel;
    LblPhoneNum2     : TLabel;
    LblPhoneNum3     : TLabel;
    LblPhoneNum4     : TLabel;
    LblShopName1     : TLabel;
    LblShopName2     : TLabel;
    LblTo1           : TLabel;
    LblTo2           : TLabel;
    LblTo3           : TLabel;
    LblTotalAmount1  : TLabel;
    LblTotalAmount2  : TLabel;
    LblTotalAmount3  : TLabel;
    LblTotalAmount4  : TLabel;
    BtnEntryShop     : TPanel;
    BtnEntryAccount  : TPanel;
    BtnAddDetail     : TPanel;
    BtnEditDetail    : TPanel;
    BtnDeleteDetail  : TPanel;
    BtnGoBack        : TPanel;
    Panel1           : TPanel;
    Panel2           : TPanel;
    Panel3           : TPanel;
    Panel4           : TPanel;
    PnlEntryShop     : TPanel;
    PnlAddDetail     : TPanel;
    PnlEntryAccount  : TPanel;
    PnlEditDetail    : TPanel;
    PnlDeleteDetail  : TPanel;
    PnlGoBack        : TPanel;
    Shape1           : TShape;
    Shape2           : TShape;
    Shape3           : TShape;
    Shape4           : TShape;
    Shape5           : TShape;
    Shape6           : TShape;
    Shape7           : TShape;
    AQu              : TSQLQuery;
    Timer            : TTimer;
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
    procedure DBEdtPhoneNumEnter(Sender: TObject);
    procedure DBEdtPhoneNumExit(Sender: TObject);
    procedure DBLCBExp1Enter(Sender: TObject);
    procedure DBLCBExp1Exit(Sender: TObject);
    procedure DBLCBFromACEnter(Sender: TObject);
    procedure DBLCBFromACExit(Sender: TObject);
    procedure DBLCBShopNameChange(Sender: TObject);
    procedure DBLCBShopNameEnter(Sender: TObject);
    procedure DBLCBShopNameExit(Sender: TObject);
    procedure DBLCBToACEnter(Sender: TObject);
    procedure DBLCBToACExit(Sender: TObject);
    procedure EdtTotalAmountEnter(Sender: TObject);
    procedure EdtTotalAmountExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure HeaderDTEnter(Sender: TObject);
    procedure HeaderDTExit(Sender: TObject);
    procedure ProcAddDetail(Sender: TObject);
    procedure ProcEditDetail(Sender: TObject);
    procedure ProcEntryAccount(Sender: TObject);
    procedure ProcEntryShop(Sender: TObject);
    procedure EntryShopMouseOver(NewColor: TColor);
    procedure BtnEntryShopEnter(Sender: TObject);
    procedure BtnEntryShopExit(Sender: TObject);
    procedure EntryAccountMouseOver(NewColor: TColor);
    procedure BtnEntryAccountEnter(Sender: TObject);
    procedure BtnEntryAccountExit(Sender: TObject);
    procedure AddDetailMouseOver(NewColor: TColor);
    procedure BtnAddDetailEnter(Sender: TObject);
    procedure BtnAddDetailExit(Sender: TObject);
    procedure EditDetailMouseOver(NewColor: TColor);
    procedure BtnEditDetailEnter(Sender: TObject);
    procedure BtnEditDetailExit(Sender: TObject);
    procedure DeleteDetailMouseOver(NewColor: TColor);
    procedure BtnDeleteDetailEnter(Sender: TObject);
    procedure BtnDeleteDetailExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActEntryShopExecute(Sender: TObject);
    procedure ActEntryAccountExecute(Sender: TObject);
    procedure ActAddDetailExecute(Sender: TObject);
    procedure ActEditDetailExecute(Sender: TObject);
    procedure ActDeleteDetailExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure DBLCBExp1Change(Sender: TObject);
    procedure DBLCBFromACChange(Sender: TObject);
    procedure DBLCBToACChange(Sender: TObject);
    procedure DTPDayChange(Sender: TObject);
    procedure DTPHourChange(Sender: TObject);
    procedure DTPMonthChange(Sender: TObject);
    procedure DTPYearChange(Sender: TObject);
    procedure EdtTotalAmountChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
  private
    //FTab               : Boolean;
    FGuidePanels       : Array[0..3] of TPanel;
    FCurrentComponent  : TObject;
    FADBNaviFirstEnter : Boolean;
    FGoBack            : Boolean;
    procedure BackupValues;
    function CannotFocusedNavButton: Boolean;
    function CheckInput: Boolean;
    function GetGoBack: Boolean;
    procedure SetGoBack(GoBack: boolean);
  public

  end;

var
  FrmAddDetailsHeader: TFrmAddDetailsHeader;

implementation
uses
  UConsts, UDBAccess, UCommonDB, UTopMenu, UManageDetails, UEntryAccount,
  UEntryShop, UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmAddDetailsHeader }

procedure TFrmAddDetailsHeader.BackupValues;
var
  LID: Integer;
begin
  with CommonDB do begin
    with Defs do begin
      with DBEdtHeaderID do begin
        if Text <> '' then begin
          SetHID(StrToInt(Text));
        end else begin
          SetHID(0);
        end;
      end;
      with AQuDetail do begin
        with FieldByName('DETAIL_ID') do begin
          if (RecordCount > 0)
              And (AsInteger > 0) then begin
            SetDID(AsInteger);
          end else begin
            SetDID(0);
          end;
        end;
      end;
      DBDTPHeaderDT.TimeFormat := tf24;
      SetHeaderDT(
        FormatDateTime('yyyy/mm/dd hh:mm:dd', DTPYear.DateTime, GetFS)
      );
      with DBEdtShopID do begin
        if Text <> '' then begin
          SetShopID(StrToInt(Text));
        end else begin
          SetShopID(0);
        end;
      end;
      with DBEdtExpKey1 do begin
        if Text <> '' then begin
          SetExpKey1(StrToInt(Text));
        end else begin
          SetExpKey1(0);
        end;
      end;
      with DBLCBFromAC do begin
        LID := VarToInt(KeyValue);
        if (Enabled) And (LID > 0) then begin
          SetFromACID(LID);
        end else begin
          SetFromACID(0);
        end;
      end;
      with DBLCBToAC do begin
        LID := VarToInt(KeyValue);
        if (Enabled) And (LID > 0) then begin
          SetToACID(LID);
        end else begin
          SetToACID(0);
        end;
      end;

      SetExpKey2(0);
      SetExpKey3(0);
      SetQuantity(0);
      SetExcludeTax(0);
      SetTax(0);
      SetSubTotal(0);
    end;
  end;
end;

function TFrmAddDetailsHeader.CheckInput: Boolean;
var
  LResult: Boolean;
begin
  LResult   := True;
  if VarIsNull(DBLCBShopName.KeyValue) then begin
    MessageDlg(MSG_JP_000025, mtError, [mbOk], 0);
    DBLCBShopName.SetFocus;
    LResult := False;
  end else if VarIsNull(DBLCBExp1.KeyValue) then begin
    MessageDlg(MSG_JP_000026, mtError, [mbOk], 0);
    DBLCBExp1.SetFocus;
    LResult := False;
  end else if (DBLCBFromAC.Enabled) And (VarIsNull(DBLCBFromAC.KeyValue)) then begin
    MessageDlg(MSG_JP_000027, mtError, [mbOk], 0);
    DBLCBFromAC.SetFocus;
    LResult := False;
  end else if (DBLCBToAC.Enabled) And (VarIsNull(DBLCBToAC.KeyValue)) then begin
    MessageDlg(MSG_JP_000028, mtError, [mbOk], 0);
    DBLCBToAC.SetFocus;
    LResult := False;
  end else if (EdtTotalAmount.Text = '') Or (EdtTotalAmount.Text = IntToStr(0)) then begin
    MessageDlg(MSG_JP_000029, mtError, [mbOk], 0);
    EdtTotalAmount.SetFocus;
    LResult := False;
  end;
  Result    := LResult;
end;

procedure TFrmAddDetailsHeader.ProcAddDetail(Sender: TObject);
var
  LNextHeaderID : Integer;
  LShopID       : Integer = 0;
  LExpKey1      : Integer = 0;
  LFromID       : Integer = 0;
  LToID         : Integer = 0;
begin
  try
    try
      with Defs do begin
        if (Not VarIsNull(DBLCBShopName.KeyValue)) And (VarToStr(DBLCBShopName.KeyValue) <> '')then begin
          LShopID := VarToInt(DBLCBShopName.KeyValue);
        end;
        if (Not VarIsNull(DBLCBExp1.KeyValue)) And (VarToStr(DBLCBExp1.KeyValue) <> '')then begin
          LExpKey1 := VarToInt(DBLCBExp1.KeyValue);
        end;
        if (Not VarIsNull(DBLCBFromAC.KeyValue)) And (VarToStr(DBLCBFromAC.KeyValue) <> '')then begin
          LFromID := VarToInt(DBLCBFromAC.KeyValue);
        end;
        if (Not VarIsNull(DBLCBToAC.KeyValue)) And (VarToStr(DBLCBToAC.KeyValue) <> '')then begin
          LToID := VarToInt(DBLCBToAC.KeyValue);
        end;

        if CheckInput then begin
          with CommonDB do begin
            with Defs do begin
              with AQuNextID do begin
                SQLConnection  := ACn;
                SQLTransaction := ATr;

                OpenSelQuAndSetNextID(
                  ADSNextID, AQuNextID, DBEdtHeaderID, SQL_20100005);
                SetHID(StrToInt(DBEdtHeaderID.Text));
                LNextHeaderID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
                CloseQuery(AQuNextID);
              end;

              CloseQuery(AQu);
              with AQu do begin
                SQLConnection  := ACn;
                SQLTransaction := ATr;

                SQL.Text := SQL_20100007;
                with Params do begin
                  ParamByName('pUserID').AsInteger        := GetUID;
                  ParamByName('pHeaderID').AsInteger      := LNextHeaderID;
                  ParamByName('pHeaderDT').AsDateTime     := DTPYear.DateTime;
                  ParamByName('pShopID').AsInteger        := LShopID;
                  ParamByName('pExpKey1').AsInteger       := LExpKey1;
                  if LFromID > 0 then begin
                    ParamByName('pFromID').AsInteger      := LFromID;
                  end;
                  if LToID > 0 then begin
                    ParamByName('pToID').AsInteger        := LToID;
                  end;
                  if EdtTotalAmount.Text = '' then begin
                    ParamByName('pTotalAmount').AsInteger := 0;
                  end else begin
                    ParamByName('pTotalAmount').AsInteger := StrToInt(StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll]));
                  end;
                  ParamByName('pEntryDT').AsAnsiString    := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
                end;

                UpdateMode                                     := upWhereAll;

                ExecSQL;
                ATr.Commit;
              end;
            end;
          end;

          with Defs do begin
            SetAddDetail(1);
            FrmAddDetail := TFrmAddDetail.Create(Application);
            OpenForm(Self, FrmAddDetail);
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

procedure TFrmAddDetailsHeader.HeaderDTEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBLCBShopNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBEdtPhoneNumEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.ADBGridEnter(Sender: TObject);
var
  LDBEdit : TDBEdit;
  LDBCB   : TDBCheckBox;
  LPanel  : TPanel;
begin
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

procedure TFrmAddDetailsHeader.ADBNaviClick(Sender: TObject;
  Button: TDBNavButtonType);
begin
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
          DTPYear.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmAddDetailsHeader.ADBNaviEnter(Sender: TObject);
begin
  if FADBNaviFirstEnter then begin
    TWinControl(ADBNavi.FindNextControl(TWinControl(ADBNavi), True, True, True)).SetFocus;
    FADBNaviFirstEnter := False;
  end;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.ADBNaviExit(Sender: TObject);
begin
  Timer.Enabled := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

function TFrmAddDetailsHeader.CannotFocusedNavButton: Boolean;
begin
  with AQu do begin
    if Active then begin
      Result := RecordCount = 0;
    end else begin
      Result := True;
    end;
  end;
end;

procedure TFrmAddDetailsHeader.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    BtnGoBack.SetFocus;
  end else if (Key = VK_TAB) then begin
    if Screen.ActiveControl is TDBNavi then begin
      if (CannotFocusedNavButton)
          Or (AQuDetail.RecordCount = 0) then begin
        DTPYear.SetFocus;
      end else begin
        TWinControl(ADBNavi.FindNextControl(TWinControl(ADBNavi), True, True, True)).SetFocus;
      end;
    end;
  end;
end;

procedure TFrmAddDetailsHeader.ADBNaviWMSetFocus(Sender: TObject;
  HWndLostFocus: HWND);
begin

end;

procedure TFrmAddDetailsHeader.DBEdtPhoneNumExit(Sender: TObject);
begin
  Shape3.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBLCBExp1Enter(Sender: TObject);
begin
  Shape4.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBLCBExp1Exit(Sender: TObject);
begin
  Shape4.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBLCBFromACEnter(Sender: TObject);
begin
  Shape5.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBLCBFromACExit(Sender: TObject);
begin
  Shape5.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBLCBShopNameChange(Sender: TObject);
begin
  with Defs do begin
    with DBLCBShopName do begin
      with DBEdtShopID do begin
        if (VarToInt(KeyValue) > 0) then begin
          Text := VarToStr(KeyValue);
        end else begin
          Text := '0';
        end;
      end;
    end;
    SetShopID(StrToInt(DBEdtShopID.Text));
    if (VarToInt(DBLCBShopName.KeyValue) > 0) then begin
      with AQuShop do begin
        with FieldByName('PHONE_NUM') do begin
          with DBEdtPhoneNum do begin
            if AsAnsiString <> '' then begin
              Text := AsAnsiString;
            end else begin
              Text := '0';
            end;
          end;
        end;
      end;
    end else begin
      DBEdtPhoneNum.Text := '';
    end;
  end;
end;

procedure TFrmAddDetailsHeader.DBLCBShopNameExit(Sender: TObject);
begin
  Shape2.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBLCBToACEnter(Sender: TObject);
begin
  Shape6.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DBLCBToACExit(Sender: TObject);
begin
  Shape6.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.EdtTotalAmountEnter(Sender: TObject);
begin
  Shape7.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.EdtTotalAmountExit(Sender: TObject);
begin
  Shape7.Visible      := False;

  with Defs do begin
    EdtTotalAmount.Text := FormatFloat('#,##0', GetTotalAmount);
  end;

  FCurrentComponent   := Sender;
  Timer.Enabled       := True;
end;

procedure TFrmAddDetailsHeader.HeaderDTExit(Sender: TObject);
begin
  Shape1.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.ProcEditDetail(Sender: TObject);
var
  LNextHeaderID : Integer;
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          if CheckInput then begin
            with ATr do begin
              ATr.DataBase := ACn;
              if Not Active then begin
                StartTransaction;
              end;
            end;

            if DBEdtHeaderID.Text = '' then begin
              OpenSelQuAndSetNextID(
                ADSNextID, AQuNextID, DBEdtHeaderID,
                SQL_20100005);
              LNextHeaderID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
              CloseQuery(AQuNextID);
            end;

            with AQu do begin
              SQL.Text := SQL_20100008;
              with Params do begin
                ParamByName('pUserID').AsInteger        := GetUID;
                ParamByName('pHeaderID').AsInteger      := LNextHeaderID;
                ParamByName('pHeaderDT').AsDateTime     := DTPYear.DateTime;
                ParamByName('pShopID').AsInteger        := VarToInt(DBLCBShopName.KeyValue);
                ParamByName('pExpKey1').AsInteger       := VarToInt(DBLCBExp1.KeyValue);
                if Not VarIsNull(DBLCBFromAC.KeyValue) then begin
                  ParamByName('pFromID').AsInteger      := VarToInt(DBLCBFromAC.KeyValue);
                end;
                if Not VarIsNull(DBLCBToAC.KeyValue) then begin
                  ParamByName('pToID').AsInteger        := VarToInt(DBLCBToAC.KeyValue);
                end;
                if EdtTotalAmount.Text = '' then begin
                  ParamByName('pTotalAmount').AsInteger := 0;
                end else begin
                  ParamByName('pTotalAmount').AsInteger := StrToInt(EdtTotalAmount.Text);
                end;
                ParamByName('pEntryDT').AsAnsiString    := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              end;

              UpdateMode                                     := upWhereAll;

              //CloseAllDB;
              //SetDatabaseNames;

              ExecSQL;
              ATr.Commit;
            end;

            FrmEditDetail := TFrmEditDetail.Create(Application);
            OpenForm(Self, FrmEditDetail);
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

procedure TFrmAddDetailsHeader.ProcEntryAccount(Sender: TObject);
begin
  with Defs do begin
    //CloseAllDB;

    FrmEntryAccount := TFrmEntryAccount.Create(Application);
    OpenForm(Self, FrmEntryAccount);
  end;
end;

procedure TFrmAddDetailsHeader.ProcEntryShop(Sender: TObject);
begin
  with Defs do begin
    //CloseAllDB;

    FrmEntryShop := TFrmEntryShop.Create(Application);
    OpenForm(Self, FrmEntryShop);
  end;
end;

procedure TFrmAddDetailsHeader.EntryShopMouseOver(NewColor: TColor);
begin
  BtnEntryShop.Color := NewColor;
end;

procedure TFrmAddDetailsHeader.BtnEntryShopEnter(Sender: TObject);
begin
  EntryShopMouseOver(clSkyBlue);
  EntryAccountMouseOver(clBtnFace);
  AddDetailMouseOver(clBtnFace);
  EditDetailMouseOver(clBtnFace);
  DeleteDetailMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.BtnEntryShopExit(Sender: TObject);
begin
  EntryShopMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.EntryAccountMouseOver(NewColor: TColor);
begin
  BtnEntryAccount.Color := NewColor;
end;

procedure TFrmAddDetailsHeader.BtnEntryAccountEnter(Sender: TObject);
begin
  EntryShopMouseOver(clBtnFace);
  EntryAccountMouseOver(clSkyBlue);
  AddDetailMouseOver(clBtnFace);
  EditDetailMouseOver(clBtnFace);
  DeleteDetailMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.BtnEntryAccountExit(Sender: TObject);
begin
  EntryAccountMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.AddDetailMouseOver(NewColor: TColor);
begin
  BtnAddDetail.Color := NewColor;
end;

procedure TFrmAddDetailsHeader.BtnAddDetailEnter(Sender: TObject);
begin
  EntryShopMouseOver(clBtnFace);
  EntryAccountMouseOver(clBtnFace);
  AddDetailMouseOver(clSkyBlue);
  EditDetailMouseOver(clBtnFace);
  DeleteDetailMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.BtnAddDetailExit(Sender: TObject);
begin
  AddDetailMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.EditDetailMouseOver(NewColor: TColor);
begin
  BtnEditDetail.Color := NewColor;
end;

procedure TFrmAddDetailsHeader.BtnEditDetailEnter(Sender: TObject);
begin
  EntryShopMouseOver(clBtnFace);
  EntryAccountMouseOver(clBtnFace);
  AddDetailMouseOver(clBtnFace);
  EditDetailMouseOver(clSkyBlue);
  DeleteDetailMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.BtnEditDetailExit(Sender: TObject);
begin
  EditDetailMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.DeleteDetailMouseOver(NewColor: TColor);
begin
  BtnEditDetail.Color := NewColor;
end;

procedure TFrmAddDetailsHeader.BtnDeleteDetailEnter(Sender: TObject);
begin
  EntryShopMouseOver(clBtnFace);
  EntryAccountMouseOver(clBtnFace);
  AddDetailMouseOver(clBtnFace);
  EditDetailMouseOver(clBtnFace);
  DeleteDetailMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.BtnDeleteDetailExit(Sender: TObject);
begin
  DeleteDetailMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmAddDetailsHeader.BtnGoBackEnter(Sender: TObject);
begin
  EntryShopMouseOver(clBtnFace);
  EntryAccountMouseOver(clBtnFace);
  AddDetailMouseOver(clBtnFace);
  EditDetailMouseOver(clBtnFace);
  DeleteDetailMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmAddDetailsHeader.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

function TFrmAddDetailsHeader.GetGoBack: Boolean;
begin
  Result := FGoBack;
end;

procedure TFrmAddDetailsHeader.SetGoBack(GoBack: boolean);
begin
  FGoBack := GoBack;
end;

procedure TFrmAddDetailsHeader.ActEntryShopExecute(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEntryShop(1);
    ProcEntryShop(Sender);
  end;
end;

procedure TFrmAddDetailsHeader.ActEntryAccountExecute(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEntryAccount(1);
    ProcEntryAccount(Sender);
  end;
end;

procedure TFrmAddDetailsHeader.ActAddDetailExecute(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    BackupValues;
    SetAddDetail(1);
    ProcAddDetail(Sender);
  end;
end;

procedure TFrmAddDetailsHeader.ActEditDetailExecute(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEditDetail(1);
    ProcEditDetail(Sender);
  end;
end;

procedure TFrmAddDetailsHeader.ActDeleteDetailExecute(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      with AQuDetail do begin
        SQL.Text := SQL_20100010;
        with Params do begin
          ParamByName('pUserID').AsInteger   := GetUID;
          ParamByName('pHeaderID').AsInteger := GetHID;
          ParamByName('pDetailID').AsInteger := FieldByName('DETAIL_ID').AsInteger;
        end;

        //CloseAllDB;
        //SetDatabaseNames;

        ExecSQL;
        ATr.Commit;
      end;
    end;
  end;
end;

procedure TFrmAddDetailsHeader.ActGoBackExecute(Sender: TObject);
begin
  SetGoBack(True);
  Close;
end;

procedure TFrmAddDetailsHeader.DBLCBExp1Change(Sender: TObject);
var
  LID: Integer;
begin
  // 入出金区分の変更に伴う出勤元/入金先の変更処理
  with Defs do begin
    if VarToInt(DBLCBExp1.KeyValue) = 1 then begin
      SetEnable(DBLCBFromAC, DBLCBToAC, True, False);

      with DBLCBFromAC do begin
        LID := VarToInt(KeyValue);
        if (Enabled) And (LID > 0) then begin
          Text  := IntToStr(LID);
        end;
      end;
      DBEdtToID.Text := IntToStr(0);
    end else if VarToInt(DBLCBExp1.KeyValue) = 2 then begin
      SetEnable(DBLCBFromAC, DBLCBToAC, False, True);

      DBEdtFromID.Text := IntToStr(0);
      with DBLCBToAC do begin
        if (Enabled) And (Not VarIsNull(KeyValue)) then begin
          DBEdtToID.Text := KeyValue;
        end;
      end;
    end else if VarToInt(DBLCBExp1.KeyValue) = 3 then begin
      SetEnable(DBLCBFromAC, DBLCBToAC, True, True);

      with DBLCBFromAC do begin
        if (Enabled) then begin
          if GetFromACID > 0 then begin
            DBEdtFromID.Text := IntToStr(GetFromACID);
            KeyValue         := GetFromACID;
          end else begin
            if (Not VarIsNull(KeyValue))
                And (VarToStr(KeyValue) <> '')then begin
              with DBEdtFromID do begin
                Text := KeyValue;
                if Text <> '' then begin
                  SetFromACID(StrToInt(Text));
                end;
              end;
            end else begin
              SetFromACID(0);
            end;
          end;
        end;
      end;

      with DBLCBToAC do begin
        if (Enabled) then begin
          if GetToACID > 0 then begin
            DBEdtToID.Text := IntToStr(GetToACID);
            KeyValue       := GetToACID;
          end else begin
            if (Not VarIsNull(KeyValue))
                And (VarToStr(KeyValue) <> '')then begin
              with DBEdtToID do begin
                Text := KeyValue;
                if Text <> '' then begin
                  SetToACID(StrToInt(Text));
                end;
              end;
            end else begin
              SetToACID(0);
            end;
          end;
        end;
      end;
    end;
    SetExpKey1(VarToInt(DBLCBExp1.KeyValue));
    DBEdtExpKey1.Text          := DBLCBExp1.KeyValue;
  end;
end;

procedure TFrmAddDetailsHeader.DBLCBFromACChange(Sender: TObject);
var
  LID: Integer;
begin
  with Defs do begin
    with DBLCBFromAC do begin
      LID := VarToInt(KeyValue);
      if (Enabled)
          And (LID > 0) then begin
        DBEdtFromID.Text := IntToStr(LID);
      end else begin
        DBEdtFromID.Text := IntToStr(0);
      end;
    end;
    SetFromACID(StrToInt(DBEdtFromID.Text));
  end;
end;

procedure TFrmAddDetailsHeader.DBLCBToACChange(Sender: TObject);
var
  LID: Integer;
begin
  with Defs do begin
    with DBLCBToAC do begin
      LID := VarToInt(KeyValue);
      if (Enabled)
          And (LID > 0) then begin
        DBEdtToID.Text := IntToStr(LID);
      end else begin
        DBEdtToID.Text := IntToStr(0);
      end;
    end;
    SetToACID(StrToInt(DBEdtToID.Text));
  end;
end;

procedure TFrmAddDetailsHeader.DTPYearChange(Sender: TObject);
begin
  with DTPYear do begin
    DTPMonth.DateTime := DateTime;
    DTPDay.DateTime   := DateTime;
    DTPHour.DateTime  := DateTime;
  end;
end;

procedure TFrmAddDetailsHeader.EdtTotalAmountChange(Sender: TObject);
var
  LTotalAmount: Integer;
begin
  with Defs do begin
    if EdtTotalAmount.Text <> '' then begin
      try
        LTotalAmount := StrToInt(StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll]));
      except
        on E: Exception do begin
          MessageDlg(MSG_JP_000039, mtWarning, [mbOk], 0);
          EdtTotalAmount.Text := IntToStr(0);
          Exit;
        end;
      end;
      SetTotalAmount(LTotalAmount);
    end;
  end;
end;

procedure TFrmAddDetailsHeader.DTPMonthChange(Sender: TObject);
begin
  with DTPMonth do begin
    DTPYear.DateTime := DateTime;
    DTPDay.DateTime  := DateTime;
    DTPHour.DateTime := DTPYear.DateTime;
  end;
end;

procedure TFrmAddDetailsHeader.DTPDayChange(Sender: TObject);
begin
  with DTPDay do begin
    DTPYear.DateTime  := DateTime;
    DTPMonth.DateTime := DateTime;
    DTPHour.DateTime  := DTPYear.DateTime;
  end;
end;

procedure TFrmAddDetailsHeader.DTPHourChange(Sender: TObject);
begin
  with DTPHour do begin
    DTPYear.DateTime  := DateTime;
    DTPMonth.DateTime := DateTime;
    DTPDay.DateTime   := DateTime;
  end;
end;

procedure TFrmAddDetailsHeader.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    with Defs do begin
      CloseQuery(AQu);
      CloseQuery(AQuDetail);
      CloseQuery(AQuNextID);
      CloseQuery(AQuShop);
      CloseQuery(AQuExp1);
      CloseQuery(AQuFromAC);
      CloseQuery(AQuToAC);
    end;
  end;

  if GetGoBack then begin
    FrmManageDetails := TFrmManageDetails.Create(Application);
    FrmManageDetails.Visible := True;
  end;

  CloseAction         := caFree;
  FrmAddDetailsHeader := nil;
end;

procedure TFrmAddDetailsHeader.FormCreate(Sender: TObject);
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

procedure TFrmAddDetailsHeader.FormShow(Sender: TObject);
begin
  Self.Width            := 859;

  Self.KeyPreview       := True;

  Self.Color            := RGB(112, 168, 175);
  PnlEntryShop.Color    := RGB( 72, 122, 129);
  PnlEntryAccount.Color := RGB( 72, 122, 129);
  PnlAddDetail.Color    := RGB( 72, 122, 129);
  PnlEditDetail.Color   := RGB( 72, 122, 129);
  PnlDeleteDetail.Color := RGB( 72, 122, 129);
  PnlGoBack.Color       := RGB( 72, 122, 129);

  { Debug }
  //Self.Width := 1193;
end;

procedure TFrmAddDetailsHeader.FormActivate(Sender: TObject);
var
  LNextHID : Integer;
begin
  try
    with CommonDB do begin
      with Defs do begin
        if DBEdtHeaderID.Text = '' then begin
          // NextID
          with AQuNextID do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelQuAndSetNextID(
              ADSNextID, AQuNextID, DBEdtHeaderID,
              SQL_20100005);
            LNextHID := FieldByName('NEXT_ID').AsInteger;
            CloseQuery(AQuNextID);
          end;

          with AQu do begin
            CloseQuery(AQu);
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20100006;
            Params.ParamByName('pUserID').AsInteger := GetUID;
            Params.ParamByName('pHeaderID').AsInteger := LNextHID;
            Open;
            //if RecordCount > 0 then begin
            Insert;
            //end;
          end;
        end else begin
          // Detail
          OpenSelectQueryWithHeaderID(
            ADSDetail, AQuDetail,
            SQL_20120005, StrToInt(DBEdtHeaderID.Text));
        end;

        // Shop lists
        with AQuShop do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          OpenSelectQuery(
            ADSShop, AQuShop, SQL_20100001);
          SetKeyValToDBLCB(
            DBLCBShopName, DBEdtShopID, GetShopID);
          //Edit;
          if VarToInt(DBLCBShopName.KeyValue) > 0 then begin
            if FieldByName('PHONE_NUM').AsAnsiString <> '' then begin
              DBEdtPhoneNum.Text := FieldByName('PHONE_NUM').AsAnsiString;
            end;
          end else begin
            DBEdtPhoneNum.Text := '';
          end;
        end;

        // Exp1 lists
        with AQuExp1 do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          OpenSelectQuery(
            ADSExp1, AQuExp1, SQL_20100002);
          SetKeyValToDBLCB(
            DBLCBExp1, DBEdtExpKey1, GetExpKey1);
          case GetExpKey1 of
          1: begin
               DBLCBFromAC.Enabled := True;
               DBLCBToAC.Enabled   := False;
             end;
          2: begin
               DBLCBFromAC.Enabled := False;
               DBLCBToAC.Enabled   := True;
             end;
          3: begin
               DBLCBFromAC.Enabled := False;
               DBLCBToAC.Enabled   := True;
             end;
          end;
        end;

        // FromAC lists
        with AQuFromAC do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if GetFromACID > 0 then begin
            OpenSelectQuery(
              ADSFromAC, AQuFromAC, SQL_20100003);
            SetKeyValToDBLCB(
              DBLCBFromAC, DBEdtFromID, GetFromACID);
          end else begin
            OpenSelectQuery(
              ADSFromAC, AQuFromAC, SQL_20100003);
            SetKeyValToDBLCB(
              DBLCBFromAC, DBEdtFromID, 0);
            SetFromACID(0);
          end;
        end;

        // ToAC lists
        with AQuToAC do begin
          AQuToAC.SQLConnection  := ACn;
          AQuToAC.SQLTransaction := ATr;

          if GetToACID > 0 then begin
            OpenSelectQuery(
              ADSToAC, AQuToAC, SQL_20100004);
            SetKeyValToDBLCB(
              DBLCBToAC, DBEdtToID, GetToACID);
          end else begin
            OpenSelectQuery(
              ADSToAC, AQuToAC, SQL_20100004);
            SetKeyValToDBLCB(
              DBLCBToAC, DBEdtToID, 0);
            SetToACID(0);
          end;
        end;

        if GetHeaderDT = '' then begin
          DTPYear.DateTime := Now;
        end else begin
          DTPYear.DateTime
            := StrToDateTime(GetHeaderDT, GetFS);
        end;

        DBEdtUserID.Text        := GetUID.ToString;

        DBEdtTotalAmount.Text   := IntToStr(GetTotalAmount);
        EdtTotalAmount.Text     := FormatFloat('#,##0', GetTotalAmount);

        with AQuDetail do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text      := SQL_20100009;
          Open;

          if RecordCount <= 0 then begin
            BtnEditDetail.Enabled   := False;
            ActEditDetail.Enabled   := False;

            BtnDeleteDetail.Enabled := False;
            ActDeleteDetail.Enabled := False;
          end else begin
            BtnEditDetail.Enabled   := True;
            ActEditDetail.Enabled   := True;

            BtnDeleteDetail.Enabled := True;
            ActDeleteDetail.Enabled := True;
          end;
        end;

        SetExpKey1(AQuDetail.FieldByName('EXP_KEY1').AsInteger);
        SetHID(AQuDetail.FieldByName('HEADER_ID').AsInteger);
      end;
    end;

    // Clear next screen fields
    with Defs do begin
      SetMakerID(0);
      SetBrandNameID(0);
      SetExpKey2(0);
      SetExpKey3(0);
    end;

    DBLCBShopName.Height    := 46;
    DBLCBExp1.Height        := 46;
  finally
  end;
end;

procedure TFrmAddDetailsHeader.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if (Key = VK_TAB) And (ssShift in Shift) then begin
  //  FTab := FTAB_SHIFT_TAB;
  //end else if (Key = VK_TAB) And (Not (ssShift in Shift)) then begin
  //  FTab := FTAB_TAB_ONLY;
  //end;
  Timer.Enabled := True;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnEntryShop' then begin
      ActEntryShop.Execute;
    end else if ActiveControl.Name = 'BtnEntryAccount' then begin
      ActEntryAccount.Execute;
    end else if ActiveControl.Name = 'BtnAddDetail' then begin
      ActAddDetail.Execute;
    end else if ActiveControl.Name = 'BtnEditDetail' then begin
      ActEditDetail.Execute;
    end else if ActiveControl.Name = 'BtnDeleteDetail' then begin
      ActDeleteDetail.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

procedure TFrmAddDetailsHeader.TimerTimer(Sender: TObject);
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

