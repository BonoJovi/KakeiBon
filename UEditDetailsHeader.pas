unit UEditDetailsHeader;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Variants, SysUtils, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, StdCtrls, DBCtrls, DBGrids, ExtCtrls, LCLIntf, LCLType,
  ActnList, UDBNavi, DateTimePicker, DBDateTimePicker;

type

  { TFrmEditDetailsHeader }

  TFrmEditDetailsHeader = class(TForm)
    ADBNavi: TDBNavi;
    ADS              : TDataSource;
    AQu              : TSQLQuery;
    ADSDetail        : TDataSource;
    AQuDetail        : TSQLQuery;
    ADSNextID        : TDataSource;
    AQuNextID        : TSQLQuery;
    ADSShop          : TDataSource;
    AQuShop          : TSQLQuery;
    ADSExp1          : TDataSource;
    AQuExp1          : TSQLQuery;
    ADSFromAC        : TDataSource;
    AQuFromAC        : TSQLQuery;
    ADSToAC          : TDataSource;
    AQuToAC          : TSQLQuery;
    { ActionLists }
    ActionList       : TActionList;
    ActAddDetail     : TAction;
    ActEntryAccount  : TAction;
    ActEntryShop     : TAction;
    ActEditDetail    : TAction;
    ActDeleteDetail  : TAction;
    ActGoBack          : TAction;
    DBDTPHeaderDT    : TDBDateTimePicker;
    DBDTPEntryDT     : TDBDateTimePicker;
    DBDTPUpdateDT    : TDBDateTimePicker;
    DBEdtHeaderID    : TDBEdit;
    DBEdtFromID      : TDBEdit;
    DBEdtTotalAmount : TDBEdit;
    DBEdtUserID      : TDBEdit;
    DBEdtToID        : TDBEdit;
    DBEdtPhoneNum    : TDBEdit;
    DBEdtShopID      : TDBEdit;
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
    BtnEntryShop: TPanel;
    BtnEntryAccount: TPanel;
    BtnAddDetail: TPanel;
    BtnEditDetail: TPanel;
    BtnDeleteDetail: TPanel;
    BtnGoBack: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PnlEntryShop     : TPanel;
    PnlAddDetail     : TPanel;
    PnlEntryAccount  : TPanel;
    PnlEditDetail    : TPanel;
    PnlDeleteDetail  : TPanel;
    PnlGoBack        : TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Timer: TTimer;
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
    procedure DBEdtPhoneNumEnter(Sender: TObject);
    procedure DBEdtPhoneNumExit(Sender: TObject);
    procedure DBLCBExp1Enter(Sender: TObject);
    procedure DBLCBExp1Exit(Sender: TObject);
    procedure DBLCBFromACEnter(Sender: TObject);
    procedure DBLCBFromACExit(Sender: TObject);
    procedure DBLCBShopNameEnter(Sender: TObject);
    procedure DBLCBShopNameExit(Sender: TObject);
    procedure DBLCBToACEnter(Sender: TObject);
    procedure DBLCBToACExit(Sender: TObject);
    procedure EdtTotalAmountEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure HeaderDTEnter(Sender: TObject);
    procedure HeaderDTExit(Sender: TObject);
    procedure ProcEntryShop(Sender: TObject);
    procedure ProcEntryAccount(Sender: TObject);
    procedure ProcAddDetail(Sender: TObject);
    procedure ProcEditDetail(Sender: TObject);
    procedure ProcRemoveDetail(Sender: TObject);
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
    procedure ActAddDetailExecute(Sender: TObject);
    procedure ActEditDetailExecute(Sender: TObject);
    procedure ActEntryAccountExecute(Sender: TObject);
    procedure ActEntryShopExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ActDeleteDetailExecute(Sender: TObject);
    procedure DBLCBExp1Change(Sender: TObject);
    procedure DBLCBFromACChange(Sender: TObject);
    procedure DBLCBShopNameChange(Sender: TObject);
    procedure DBLCBToACChange(Sender: TObject);
    procedure DTPDayChange(Sender: TObject);
    procedure DTPHourChange(Sender: TObject);
    procedure DTPMonthChange(Sender: TObject);
    procedure DTPYearChange(Sender: TObject);
    procedure EdtTotalAmountExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
  private
    FTab              : Boolean;
    FGuidePanels      : Array[0..3] of TPanel;
    FCurrentComponent : TObject;
    FGoBack      : Boolean;
    //procedure SetDatabaseNames;
    procedure BackupValues;
    function CheckInput: Boolean;
    procedure SetButtonEnabled(Qu: TSQLQuery);
    function GetFractionProc: Integer;
    procedure UpdateFractionProc(FractionProc: Integer; SS: String);
    procedure ReQuery;
    procedure Summarize;
    function GetGoBack: Boolean;
    procedure SetGoBack(aGoBack: Boolean);
  public

  end;

var
  FrmEditDetailsHeader: TFrmEditDetailsHeader;


implementation
uses
  UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageDetails, UEntryAccount,
  UEntryShop, UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmEditDetailsHeader }

procedure TFrmEditDetailsHeader.BackupValues;
var
  LID: Integer;
begin
  with CommonDB do begin
    with Defs do begin
      with DBEdtHeaderID do begin
        if Text <> '' then begin;
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
          end;
        end;
      end;

      DBDTPHeaderDT.TimeFormat := tf24;
      SetHeaderDT(
        DateTimeToStr(DTPYear.DateTime)
      );
      with DBEdtShopID do begin
        LID := StrToInt(Text);
        if Text <> '' then begin
          SetShopID(LID);
        end else begin
          SetShopID(0);
        end;
      end;
      with DBEdtExpKey1 do begin
        if Text <> '' then begin
          LID := StrToInt(Text);
          SetExpKey1(LID);
        end;
      end;
      with DBLCBFromAC do begin
        LID := VarToInt(KeyValue);
        if (Enabled) And (LID > 0) then begin
          SetFromACID(LID);
        end;
      end;
      with DBLCBToAC do begin
        LID := VarToInt(KeyValue);
        if (Enabled) And (LID > 0) then begin
          SetToACID(LID);
        end;
      end;
    end;
  end;
end;

function TFrmEditDetailsHeader.CheckInput: Boolean;
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

procedure TFrmEditDetailsHeader.ProcEntryShop(Sender: TObject);
begin
  with Defs do begin
    FrmEntryShop := TFrmEntryShop.Create(Application);
    OpenForm(Self, FrmEntryShop);
  end;
end;

procedure TFrmEditDetailsHeader.HeaderDTEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBLCBShopNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBEdtPhoneNumEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.ADBNaviClick(Sender: TObject;
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

procedure TFrmEditDetailsHeader.ADBGridEnter(Sender: TObject);
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

procedure TFrmEditDetailsHeader.ADBNaviEnter(Sender: TObject);
begin
  Timer.Enabled := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.ADBNaviExit(Sender: TObject);
begin
  Timer.Enabled := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.ADBNaviWMSetFocus(Sender: TObject;
  HWndLostFocus: HWND);
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

procedure TFrmEditDetailsHeader.DBEdtPhoneNumExit(Sender: TObject);
begin
  Shape3.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBLCBExp1Enter(Sender: TObject);
begin
  Shape4.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBLCBExp1Exit(Sender: TObject);
begin
  Shape4.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBLCBFromACEnter(Sender: TObject);
begin
  Shape5.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBLCBFromACExit(Sender: TObject);
begin
  Shape5.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBLCBShopNameExit(Sender: TObject);
begin
  Shape2.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBLCBToACEnter(Sender: TObject);
begin
  Shape6.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DBLCBToACExit(Sender: TObject);
begin
  Shape6.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.EdtTotalAmountEnter(Sender: TObject);
begin
  Shape7.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.HeaderDTExit(Sender: TObject);
begin
  Shape1.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.ProcEntryAccount(Sender: TObject);
begin
  with Defs do begin
    FrmEntryAccount := TFrmEntryAccount.Create(Application);
    OpenForm(Self, FrmEntryAccount);
  end;
end;

procedure TFrmEditDetailsHeader.ProcAddDetail(Sender: TObject);
var
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
              CloseQuery(AQu);
              with AQu do begin
                SQLConnection  := ACn;
                SQLTransaction := ATr;

                SQL.Text := SQL_20100008;
                with Params do begin
                  ParamByName('pUserID').AsInteger        := GetUID;
                  ParamByName('pHeaderID').AsInteger      := GetHID;
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
                  ParamByName('pUpdateDT').AsAnsiString    := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
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

procedure TFrmEditDetailsHeader.ProcEditDetail(Sender: TObject);
var
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
              with AQuDetail do begin
                SetDID(FieldByName('DETAIL_ID').AsInteger);
              end;

              CloseQuery(AQu);
              with AQu do begin
                SQLConnection  := ACn;
                SQLTransaction := ATr;

                SQL.Text := SQL_20100008;
                with Params do begin
                  ParamByName('pUserID').AsInteger        := GetUID;
                  ParamByName('pHeaderID').AsInteger      := GetHID;
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
                  ParamByName('pUpdateDT').AsAnsiString    := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
                end;

                UpdateMode                                       := upWhereAll;

                ExecSQL;
                ATr.Commit;
              end;

              FrmEditDetail := TFrmEditDetail.Create(Application);
              OpenForm(Self, FrmEditDetail);
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
  end;
end;

procedure TFrmEditDetailsHeader.ProcRemoveDetail(Sender: TObject);
var
  LResult   : TModalResult;
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with AQuDetail do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20100010;
            with Params do begin
              ParamByName('pUserID').AsInteger   := GetUID;
              ParamByName('pHeaderID').AsInteger := GetHID;
            end;

            //CloseAllDB;
            //SetDatabaseNames;

            Open;

            First;
            while Not EOF do begin
              if FieldByName('DETAIL_ID').AsInteger = GetDID then begin
                break;
              end;
              Next;
            end;

            LResult:= QuestionDlg(
              REMOVE_DETAILS_HEADER_CAPTION, REMOVE_DETAILS_HEADER_MESSAGE,
              mtConfirmation, [mrYes, mrNo], 0);
            if LResult = mrYes then begin
              Edit;
              Delete;
              ApplyUpdates;
              ATr.Commit;

              SetButtonEnabled(AQuDetail);
            end;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        with CommonDB do begin
          ATr.Rollback;
        end;
      end;
    end;

    try
      with CommonDB do begin
        with Defs do begin
          with AQuShop do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQuery(ADSShop, AQuShop, SQL_20100001);
            SetKeyValToDBLCB(DBLCBShopName, DBEdtShopID , GetShopID);

            if GetShopID > 0 then begin
                First;
                while Not EOF do begin
                  if FieldByName('SHOP_ID').AsInteger = GetShopID then begin
                    Break;
                  end;
                  Next;
                end;
                if FieldByName('PHONE_NUM').AsAnsiString <> '' then begin
                  DBEdtPhoneNum.Text := FieldByName('PHONE_NUM').AsAnsiString;
                end;
            end else begin
              DBEdtPhoneNum.Text := '';
            end;
          end;

          with AQuExp1 do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQuery(ADSExp1, AQuExp1, SQL_20100002);
            SetKeyValToDBLCB(DBLCBExp1, DBEdtExpKey1, GetExpKey1);
            DBLCBExp1Change(Self);
          end;

          with AQuFromAC do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            if GetFromACID > 0 then begin
              OpenSelectQuery(
                ADSFromAC, AQuFromAC, SQL_20100003);
              SetKeyValToDBLCB(DBLCBFromAC, DBEdtFromID, GetFromACID);
              DBLCBFromACChange(Self);
            end;
          end;

          with AQuToAC do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            if GetToACID > 0 then begin
              OpenSelectQuery(
                ADSToAC  , AQuToAC, SQL_20100004);
              SetKeyValToDBLCB(DBLCBToAC, DBEdtToID, GetToACID);
              if AQuToAC.RecordCount > 0 then begin
                DBLCBToACChange(Self);
              end;
            end;
          end;

          with AQuDetail do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20100009;
            with Params do begin
              ParamByName('pUserID').AsInteger   := GetUID;
              ParamByName('pHeaderID').AsInteger := GetHID;
            end;
            Open;

            SetButtonEnabled(AQuDetail);
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        with CommonDB do begin
          ATr.Rollback;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmEditDetailsHeader.SetButtonEnabled(Qu: TSQLQuery);
begin
  with Qu do begin
    if RecordCount <= 0 then begin
      BtnDeleteDetail.Enabled := False;
      PnlDeleteDetail.Enabled := False;
      ActDeleteDetail.Enabled := False;
    end else begin
      BtnDeleteDetail.Enabled := True;
      PnlDeleteDetail.Enabled := True;
      ActDeleteDetail.Enabled := True;
    end;
  end;
end;

function TFrmEditDetailsHeader.GetFractionProc: Integer;
begin
  if AQuShop.FieldByName('DO_TRUNCATE').AsBoolean then begin
    Result := FRACTION_PROC_TRUNCATE;
  end else if AQuShop.FieldByName('DO_ROUND').AsBoolean then begin
    Result := FRACTION_PROC_ROUND;
  end else if AQuShop.FieldByName('DO_ROUND_UP').AsBoolean then begin
    Result := FRACTION_PROC_ROUND_UP;
  end else begin
    Result := FRACTION_PROC_UNDEF;
  end;
end;

procedure TFrmEditDetailsHeader.UpdateFractionProc(
  FractionProc: Integer; SS: String);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          if FractionProc = FRACTION_PROC_UNDEF then begin
            with AQuShop do begin
              SQLConnection  := ACn;
              SQLTransaction := ATr;

              if Active = False then begin
                SQL.Text                             := SS;
                with Params do begin
                  ParamByName('pUserID').AsInteger := GetUID;
                  ParamByName('pShopID').AsInteger := GetShopID;
                end;

                ExecSQL;
              end;
            end;
          end;
          //ATr.Commit;
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

procedure TFrmEditDetailsHeader.ReQuery;
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQueryWithHeaderID(ADS, AQu, SQL_20100006, GetHID);
      end;

      with AQuShop do begin
        OpenSelectQuery(ADSShop, AQuShop, SQL_20100001);
        SetKeyValToDBLCB(DBLCBShopName, DBEdtShopID , GetShopID);
      end;

    end;
  end;
end;

procedure TFrmEditDetailsHeader.Summarize;
var
  LFractionProc : Integer;
  LDetailID     : Integer;
  LTotalAmount  : Integer;
begin
  try
    try
      if AQuDetail.RecordCount > 0 then begin
        LDetailID          := AQuDetail.FieldByName('DETAIL_ID').AsInteger;
        with Defs do begin
          SetDID(LDetailID);
        end;
      end;

      // Get fruction processing type
      with CommonDB do begin
        with Defs do begin
          with AQuShop do begin
            OpenSelectQuery(ADSShop, AQuShop, SQL_20100001);
            SetKeyValToDBLCB(DBLCBShopName, DBEdtShopID , GetShopID);
          end;

          LFractionProc := GetFractionProc;

          // Get total amount
          if (DBEdtTotalAmount.Text <> '')
            And (StrToInt(DBEdtTotalAmount.Text) <> 0) then begin
            LTotalAmount := StrToInt(DBEdtTotalAmount.Text);
          end else begin
            with AQu do begin
              SQLConnection  := ACn;
              SQLTransaction := ATr;

              OpenSelectQueryWithHeaderID(
                ADS, AQu, SQL_20100006, GetHID);
              LTotalAmount := FieldByName('TOTAL_AMOUNT').AsInteger;
            end;
          end;

          CloseQuery(AQuDetail);
          with AQuDetail do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            if (LFractionProc = FRACTION_PROC_TRUNCATE)
                Or (LFractionProc = FRACTION_PROC_UNDEF) then begin
              // Calc TotalAmount (TRUNC)
              OpenSelectQueryWithHeaderID(
                ADSDetail, AQuDetail, SQL_20100012, GetHID);
              if AQuDetail.FieldByName('TOTAL_AMOUNT').AsAnsiString <> '' then begin
                if LTotalAmount >= AQuDetail.FieldByName('TOTAL_AMOUNT').AsInteger then begin
                  SetTotalAmount(LTotalAmount);
                  UpdateFractionProc(LFractionProc, SQL_20100015);
                  ReQuery;
                  Exit;
                end;
              end;
            end;
          end;

          with AQuDetail do begin
            if (LFractionProc = FRACTION_PROC_ROUND_UP)
                Or (LFractionProc = FRACTION_PROC_UNDEF) then begin
              // Calc TotalAmount (ROUND_UP)
              OpenSelectQueryWithHeaderID(
                ADSDetail, AQuDetail, SQL_20100013, GetHID);
              if AQuDetail.FieldByName('TOTAL_AMOUNT').AsAnsiString <> '' then begin
                if LTotalAmount <= AQuDetail.FieldByName('TOTAL_AMOUNT').AsInteger then begin
                  SetTotalAmount(LTotalAmount);
                  UpdateFractionProc(LFractionProc, SQL_20100016);
                  ReQuery;
                  Exit;
                end;
              end;
            end;
          end;

          with AQuDetail do begin
            if (LFractionProc = FRACTION_PROC_ROUND)
                Or (LFractionProc = FRACTION_PROC_UNDEF) then begin
              // Calc TotalAmount (ROUND)
              OpenSelectQueryWithHeaderID(
                ADSDetail, AQuDetail, SQL_20100011, GetHID);
              if AQuDetail.FieldByName('TOTAL_AMOUNT').AsAnsiString <> '' then begin
                if LTotalAmount = AQuDetail.FieldByName('TOTAL_AMOUNT').AsInteger then begin
                  SetTotalAmount(LTotalAmount);
                  UpdateFractionProc(LFractionProc, SQL_20100014);
                  ReQuery;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        with CommonDB do begin
          ATr.Rollback;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmEditDetailsHeader.EntryShopMouseOver(NewColor: TColor);
begin
  BtnEntryShop.Color := NewColor;
end;

procedure TFrmEditDetailsHeader.BtnEntryShopEnter(Sender: TObject);
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

procedure TFrmEditDetailsHeader.BtnEntryShopExit(Sender: TObject);
begin
  EntryShopMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.EntryAccountMouseOver(NewColor: TColor);
begin
  BtnEntryAccount.Color := NewColor;
end;

procedure TFrmEditDetailsHeader.BtnEntryAccountEnter(Sender: TObject);
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

procedure TFrmEditDetailsHeader.BtnEntryAccountExit(Sender: TObject);
begin
  EntryAccountMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.AddDetailMouseOver(NewColor: TColor);
begin
  BtnAddDetail.Color := NewColor;
end;

procedure TFrmEditDetailsHeader.BtnAddDetailEnter(Sender: TObject);
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

procedure TFrmEditDetailsHeader.BtnAddDetailExit(Sender: TObject);
begin
  AddDetailMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.EditDetailMouseOver(NewColor: TColor);
begin
  BtnEditDetail.Color := NewColor;
end;

procedure TFrmEditDetailsHeader.BtnEditDetailEnter(Sender: TObject);
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

procedure TFrmEditDetailsHeader.BtnEditDetailExit(Sender: TObject);
begin
  EditDetailMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DeleteDetailMouseOver(NewColor: TColor);
begin
  BtnDeleteDetail.Color := NewColor;
end;

procedure TFrmEditDetailsHeader.BtnDeleteDetailEnter(Sender: TObject);
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

procedure TFrmEditDetailsHeader.BtnDeleteDetailExit(Sender: TObject);
begin
  DeleteDetailMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEditDetailsHeader.BtnGoBackEnter(Sender: TObject);
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

procedure TFrmEditDetailsHeader.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

function TFrmEditDetailsHeader.GetGoBack: Boolean;
begin
  Result  := FGoBack;
end;

procedure TFrmEditDetailsHeader.SetGoBack(aGoBack: Boolean);
begin
  FGoBack := aGoBack;
end;

procedure TFrmEditDetailsHeader.ActAddDetailExecute(Sender: TObject);
begin
  SetGoBack(False);
  with Defs do begin
    SetAddDetail(2);

    SetMakerID(0);
    SetBrandNameID(0);
    SetUnitID(0);
    SetTaxTypeID(0);
  end;

  BackupValues;
  ProcAddDetail(Sender);
  Summarize;
end;

procedure TFrmEditDetailsHeader.ActEditDetailExecute(Sender: TObject);
begin
  SetGoBack(False);
  with Defs do begin
    SetEditDetail(2);
  end;

  BackupValues;
  ProcEditDetail(Sender);
  Summarize;
end;

procedure TFrmEditDetailsHeader.ActEntryAccountExecute(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEntryAccount(2);
    ProcEntryAccount(Sender);
  end;
end;

procedure TFrmEditDetailsHeader.ActEntryShopExecute(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEntryShop(2);
    ProcEntryShop(Sender);
  end;
end;

procedure TFrmEditDetailsHeader.ActGoBackExecute(Sender: TObject);
begin
  SetGoBack(True);
  Close;
end;

procedure TFrmEditDetailsHeader.ActDeleteDetailExecute(Sender: TObject);
begin
  BackupValues;
  ProcRemoveDetail(Sender);
end;

procedure TFrmEditDetailsHeader.DBLCBExp1Change(Sender: TObject);
var
  LID: Integer;
begin
  // 入出金区分の変更に伴う出勤元/入金先の変更処理
  with Defs do begin
    if GetExpKey1 = 1 then begin
      SetEnable(DBLCBFromAC, DBLCBToAC, True, False);

      with DBLCBFromAC do begin
        LID := VarToInt(KeyValue);
        if (Enabled) And (LID > 0) then begin
          Text  := IntToStr(LID);
        end;
      end;
      DBEdtToID.Text   := IntToStr(0);
    end else if GetExpKey1 = 2 then begin
      SetEnable(DBLCBFromAC, DBLCBToAC, False, True);

      DBEdtFromID.Text := IntToStr(0);
      with DBLCBToAC do begin
        if (Enabled) And (Not VarIsNull(KeyValue)) then begin
          DBEdtToID.Text := KeyValue;
        end;
      end;
    end else if GetExpKey1 = 3 then begin
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
    DBEdtExpKey1.Text          := DBLCBExp1.KeyValue;
  end;
end;

procedure TFrmEditDetailsHeader.DBLCBShopNameChange(Sender: TObject);
begin
  with Defs do begin
    with DBEdtShopID do begin
      if AQu.FieldByName('SHOP_ID').AsInteger > 0 then begin
        Text := AQu.FieldByName('SHOP_ID').AsAnsiString;
      end else begin
        Text := '';
      end;
      SetShopID(StrToInt(Text));
    end;
  end;
end;

procedure TFrmEditDetailsHeader.DBLCBFromACChange(Sender: TObject);
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

procedure TFrmEditDetailsHeader.DBLCBToACChange(Sender: TObject);
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

procedure TFrmEditDetailsHeader.DTPYearChange(Sender: TObject);
begin
  with DTPYear do begin
    DTPMonth.DateTime := DateTime;
    DTPDay.DateTime   := DateTime;
    DTPHour.DateTime  := DateTime;
  end;
end;

procedure TFrmEditDetailsHeader.EdtTotalAmountExit(Sender: TObject);
begin
  DBEdtTotalAmount.Text := StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll]);
  Shape7.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEditDetailsHeader.DTPMonthChange(Sender: TObject);
begin
  with DTPMonth do begin
    DTPYear.DateTime := DateTime;
    DTPDay.DateTime  := DateTime;
    DTPHour.DateTime := DTPYear.DateTime;
  end;
end;

procedure TFrmEditDetailsHeader.DTPDayChange(Sender: TObject);
begin
  with DTPDay do begin
    DTPYear.DateTime  := DateTime;
    DTPMonth.DateTime := DateTime;
    DTPHour.DateTime  := DTPYear.DateTime;
  end;
end;

procedure TFrmEditDetailsHeader.DTPHourChange(Sender: TObject);
begin
  with DTPHour do begin
    DTPYear.DateTime  := DateTime;
    DTPMonth.DateTime := DateTime;
    DTPDay.DateTime   := DateTime;
  end;
end;

procedure TFrmEditDetailsHeader.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    with Defs do begin
      CloseQuery(AQuDetail);
      CloseQuery(AQuShop);
      CloseQuery(AQuNextID);
      CloseQuery(AQuExp1);
      CloseQuery(AQuFromAC);
      CloseQuery(AQuToAC);
      CloseQuery(AQuNextID);
    end;
  end;

  if GetGoBack then begin
    FrmManageDetails := TFrmManageDetails.Create(Application);
    FrmManageDetails.Visible := True;
  end;
  CloseAction              := caFree;
  FrmEditDetailsHeader     := nil;
end;

procedure TFrmEditDetailsHeader.FormCreate(Sender: TObject);
begin
  with Defs do begin
    //SetDatabaseNames;

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

procedure TFrmEditDetailsHeader.FormShow(Sender: TObject);
begin
  Self.Width                 := 859;

  Self.KeyPreview            := True;

  Self.Color                 := RGB(112, 168, 175);
  PnlEntryShop.Color         := RGB( 72, 122, 129);
  PnlEntryAccount.Color      := RGB( 72, 122, 129);
  PnlAddDetail.Color         := RGB( 72, 122, 129);
  PnlEditDetail.Color        := RGB( 72, 122, 129);
  PnlDeleteDetail.Color      := RGB( 72, 122, 129);
  PnlGoBack.Color            := RGB( 72, 122, 129);
end;

procedure TFrmEditDetailsHeader.FormActivate(Sender: TObject);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20100006;
            with Params do begin
              ParamByName('pUserID').AsInteger   := GetUID;
              ParamByName('pHeaderID').AsInteger := GetHID;
            end;
            Open;
            Edit;
            SetHeaderDT(FormatDateTime('yyyy/mm/dd hh:mm:ss', FieldByName('HEADER_DT').AsDateTime, GetFS));
            if EdtTotalAmount.Text <> '' then begin
              SetTotalAmount(StrToInt(StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll])));
            end else begin
              SetTotalAmount(0);
            end;
          end;

          //with CommonDB.Defs do begin
          if GetHeaderDT = '' then begin
            DTPYear.DateTime := Now;
          end else begin
            DTPYear.DateTime := StrToDateTime(GetHeaderDT, GetFS);
          end;

          with AQuShop do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SetShopID(AQu.FieldByName('SHOP_ID').AsInteger);
            OpenSelectQuery(ADSShop, AQuShop, SQL_20100001);
            SetKeyValToDBLCB(
              DBLCBShopName, DBEdtShopID, GetShopID);

            if GetShopID > 0 then begin
              First;
              while Not EOF do begin
                if FieldByName('SHOP_ID').AsInteger = GetShopID then begin
                  Break;
                end;
                Next;
              end;
              if FieldByName('PHONE_NUM').AsAnsiString <> '' then begin
                DBEdtPhoneNum.Text := FieldByName('PHONE_NUM').AsAnsiString;
              end;
            end else begin
              DBEdtPhoneNum.Text := '';
            end;
          end;

          with AQuExp1 do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQuery(
              ADSExp1, AQuExp1, SQL_20100002);
            SetKeyValToDBLCB(DBLCBExp1, DBEdtExpKey1, GetExpKey1);

            DBLCBExp1Change(Sender);
          end;

          with AQuFromAC do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SetFromACID(AQu.FieldByName('FROM_ID').AsInteger);
            OpenSelectQuery(ADSFromAC, AQuFromAC, SQL_20100003);
            if GetFromACID > 0 then begin
              SetKeyValToDBLCB(DBLCBFromAC, DBEdtFromID, GetFromACID);
            end;
          end;

          with AQuToAC do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SetToACID(AQu.FieldByName('TO_ID').AsInteger);
            OpenSelectQuery(ADSToAC, AQuToAC, SQL_20100004);
            if GetToACID > 0 then begin
              SetKeyValToDBLCB(DBLCBToAC, DBEdtToID, GetToACID);
            end;
          end;

          if GetHeaderDT = '' then begin
            DTPYear.DateTime := Now;
          end else begin
              DTPYear.DateTime := StrToDateTime(GetHeaderDT, GetFS);
          end;

          if VarIsNull(DBLCBShopName.KeyValue) then begin
            DBEdtPhoneNum.Text := '';
          end;

          DBEdtUserID.Text     := IntToStr(GetUID);

          with AQuDetail do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQueryWithHeaderID(
              ADSDetail, AQuDetail, SQL_20100009, GetHID);

            if RecordCount <= 0 then begin
              BtnEditDetail.Enabled   := False;
              BtnDeleteDetail.Enabled := False;
            end else begin
              BtnEditDetail.Enabled   := True;
              BtnDeleteDetail.Enabled := True;
            end;
          end;

          SetButtonEnabled(AQuDetail);
          ADBGrid.AutoAdjustColumns;

          if DBEdtTotalAmount.Text <> '' then begin
            EdtTotalAmount.Text := FormatFloat('#,##0', StrToInt(DBEdtTotalAmount.Text));
          end else begin
            EdtTotalAmount.Text := FormatFloat('#,##0', 0);
          end;

          Summarize;
          ATr.Commit;

          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20100006;
            with Params do begin
              ParamByName('pUserID').AsInteger   := GetUID;
              ParamByName('pHeaderID').AsInteger := GetHID;
            end;
            Open;
            Edit;
            SetHeaderDT(FormatDateTime('yyyy/mm/dd hh:mm:ss', FieldByName('HEADER_DT').AsDateTime, GetFS));
            if EdtTotalAmount.Text <> '' then begin
              SetTotalAmount(StrToInt(StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll])));
            end else begin
              SetTotalAmount(0);
            end;
          end;

          //with CommonDB.Defs do begin
          if GetHeaderDT = '' then begin
            DTPYear.DateTime := Now;
          end else begin
            DTPYear.DateTime := StrToDateTime(GetHeaderDT, GetFS);
          end;

          with AQuShop do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SetShopID(AQu.FieldByName('SHOP_ID').AsInteger);
            OpenSelectQuery(ADSShop, AQuShop, SQL_20100001);
            SetKeyValToDBLCB(DBLCBShopName, DBEdtShopID, GetShopID);

            if GetShopID > 0 then begin
              First;
              while Not EOF do begin
                if FieldByName('SHOP_ID').AsInteger = GetShopID then begin
                  Break;
                end;
                Next;
              end;
              if FieldByName('PHONE_NUM').AsAnsiString <> '' then begin
                DBEdtPhoneNum.Text := FieldByName('PHONE_NUM').AsAnsiString;
              end;
            end else begin
              DBEdtPhoneNum.Text := '';
            end;
          end;

          with AQuExp1 do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQuery(
              ADSExp1, AQuExp1, SQL_20100002);
            SetKeyValToDBLCB(
              DBLCBExp1, DBEdtExpKey1, GetExpKey1);

            DBLCBExp1Change(Sender);
            //DBLCBExp1.ListSource := ADSExp1;
            //DBLCBExp1.ListField  := 'NAME1';
            //DBLCBExp1.KeyField   := 'EXP_KEY1';
          end;

          with AQuFromAC do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SetFromACID(AQu.FieldByName('FROM_ID').AsInteger);
            OpenSelectQuery(ADSFromAC, AQuFromAC, SQL_20100003);
            if GetFromACID > 0 then begin
              SetKeyValToDBLCB(
                DBLCBFromAC, DBEdtFromID, GetFromACID);
            end;
          end;

          with AQuToAC do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SetToACID(AQu.FieldByName('TO_ID').AsInteger);
            OpenSelectQuery(ADSToAC, AQuToAC, SQL_20100004);
            if GetToACID > 0 then begin
              SetKeyValToDBLCB(
                DBLCBToAC, DBEdtToID, GetToACID);
            end;
          end;

          if GetHeaderDT = '' then begin
            DTPYear.DateTime := Now;
          end else begin
              DTPYear.DateTime := StrToDateTime(GetHeaderDT, GetFS);
          end;

          if VarIsNull(DBLCBShopName.KeyValue) then begin
            DBEdtPhoneNum.Text := '';
          end;

          DBEdtUserID.Text     := IntToStr(GetUID);

          CloseQuery(AQuDetail);
          with AQuDetail do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQueryWithHeaderID(
              ADSDetail, AQuDetail, SQL_20100009, GetHID);

            if RecordCount <= 0 then begin
              BtnEditDetail.Enabled   := False;
              BtnDeleteDetail.Enabled := False;
            end else begin
              BtnEditDetail.Enabled   := True;
              BtnDeleteDetail.Enabled := True;
            end;
          end;

          SetButtonEnabled(AQuDetail);
          ADBGrid.AutoAdjustColumns;

          if DBEdtTotalAmount.Text <> '' then begin
            EdtTotalAmount.Text := FormatFloat('#,##0', StrToInt(DBEdtTotalAmount.Text));
          end else begin
            EdtTotalAmount.Text := FormatFloat('#,##0', 0);
          end;

          // Clear next screen fields
          SetMakerID(0);
          SetBrandNameID(0);
          SetExpKey2(0);
          SetExpKey3(0);
          SetQuantity(0);
          SetExcludeTax(0);
          SetTax(0);
          SetSubTotal(0);
          //end;

          DBLCBShopName.Height := 46;
          DBLCBExp1.Height     := 46;
        end;
      end;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;

  { Debug }
  //Self.Width := 1193;
end;

procedure TFrmEditDetailsHeader.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
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

procedure TFrmEditDetailsHeader.TimerTimer(Sender: TObject);
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

