unit UAddDetailsHeader;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, Variants, SysUtils, SQLDB, SQLite3Conn, DB, Forms,
  Controls, Graphics, Dialogs, StdCtrls, DBCtrls, DBGrids, ExtCtrls, LCLIntf,
  ActnList, DateTimePicker, DBDateTimePicker, UDefs;

type

  { TFrmAddDetailsHeader }

  TFrmAddDetailsHeader = class(TForm)
    ADS              : TDataSource;
    ATr              : TSQLTransaction;
    AQu              : TSQLQuery;
    ADSDetail        : TDataSource;
    ATrDetail        : TSQLTransaction;
    AQuDetail        : TSQLQuery;
    ADSNextID        : TDataSource;
    ATrNextID        : TSQLTransaction;
    AQuNextID        : TSQLQuery;
    ADSShop          : TDataSource;
    ATrShop          : TSQLTransaction;
    AQuShop          : TSQLQuery;
    ADSExp1          : TDataSource;
    ATrExp1          : TSQLTransaction;
    AQuExp1          : TSQLQuery;
    ADSFromAC        : TDataSource;
    ATrFromAC        : TSQLTransaction;
    AQuFromAC        : TSQLQuery;
    ADSToAC          : TDataSource;
    ATrToAC          : TSQLTransaction;
    AQuToAC          : TSQLQuery;
    { ActionLists }
    ActionList       : TActionList;
    ActAddDetail     : TAction;
    ActEntryAccount  : TAction;
    ActEntryShop     : TAction;
    ActEditDetail    : TAction;
    ActRemoveDetail  : TAction;
    ActQuit          : TAction;
    { Screen controls }
    ADBNav           : TDBNavigator;
    BtnEntryShop     : TButton;
    BtnEntryAccount  : TButton;
    BtnAddDetail     : TButton;
    BtnEditDetail    : TButton;
    BtnRemoveDetail  : TButton;
    BtnGoBack        : TButton;
    DBDTPHeaderDT    : TDBDateTimePicker;
    DBDTPEntryDT     : TDBDateTimePicker;
    DBDTPUpdateDT    : TDBDateTimePicker;
    DBEdtHeaderID    : TDBEdit;
    DBEdtFromID      : TDBEdit;
    DBEdtTotalAmount: TDBEdit;
    DBEdtUserID      : TDBEdit;
    DBEdtToID        : TDBEdit;
    DBEdtPhoneNum    : TDBEdit;
    DBEdtShopID      : TDBEdit;
    DBEdtExpKey1     : TDBEdit;
    DBGrid           : TDBGrid;
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
    PnlEntryShop     : TPanel;
    PnlAddDetail     : TPanel;
    PnlEntryAccount  : TPanel;
    PnlEditDetail    : TPanel;
    PnlRemoveDetail  : TPanel;
    PnlGoBack        : TPanel;
    ACn: TSQLite3Connection;
    ACnDetail: TSQLite3Connection;
    ACnNextID: TSQLite3Connection;
    ACnShop: TSQLite3Connection;
    ACnExp1: TSQLite3Connection;
    ACnFromAC: TSQLite3Connection;
    ACnToAC: TSQLite3Connection;
    procedure ActAddDetailExecute(Sender: TObject);
    procedure ActEditDetailExecute(Sender: TObject);
    procedure ActEntryAccountExecute(Sender: TObject);
    procedure ActEntryShopExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ActRemoveDetailExecute(Sender: TObject);
    procedure DBLCBExp1Change(Sender: TObject);
    procedure DBLCBFromACChange(Sender: TObject);
    procedure DBLCBShopNameChange(Sender: TObject);
    procedure DBLCBToACChange(Sender: TObject);
    procedure DTPDayChange(Sender: TObject);
    procedure DTPHourChange(Sender: TObject);
    procedure DTPMonthChange(Sender: TObject);
    procedure DTPYearChange(Sender: TObject);
    procedure EdtTotalAmountChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FGoBack : Boolean;
    procedure CloseTransactions;
    procedure BackupValues;
    function CheckInput: Boolean;
    procedure ProcAddDetail;
    procedure ProcEditDetail;
    procedure ProcEntryAccount;
    procedure ProcEntryShop;
    function GetGoBack: Boolean;
    procedure SetGoBack(GoBack: boolean);
    property GoBack: Boolean read GetGoBack write SetGoBack;
  public

  end;

var
  FrmAddDetailsHeader: TFrmAddDetailsHeader;

implementation
uses
  UConsts, UDBAccess, UTopMenu, UManageDetails, UEntryAccount, UEntryShop,
  UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmAddDetailsHeader }

procedure TFrmAddDetailsHeader.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnDetail, ATrDetail);
    CloseConn(ACnNextID, ATrNextID);
    CloseConn(ACnShop  , ATrShop  );
    CloseConn(ACnExp1  , ATrExp1  );
    CloseConn(ACnFromAC, ATrFromAC);
    CloseConn(ACnToAC  , ATrToAC  );
  end;
end;

procedure TFrmAddDetailsHeader.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    if DBEdtHeaderID.Text <> '' then begin;
      SetHID(StrToInt(DBEdtHeaderID.Text));
    end;
    if (AQuDetail.RecordCount > 0)
      And (AQuDetail.FieldByName('DETAIL_ID').AsInteger > 0) then begin
      SetDID(AQuDetail.FieldByName('DETAIL_ID').AsInteger);
    end;
    DBDTPHeaderDT.TimeFormat := tf24;
    SetHeaderDT(
      FormatDateTime('yyyy/mm/dd hh:mm:dd', DTPYear.DateTime, GetFS)
    );
    if DBEdtShopID.Text <> '' then begin
      SetShopID(DBEdtShopID.Text);
    end;
    if DBEdtExpKey1.Text <> '' then begin
      SetExpKey1(DBEdtExpKey1.Text);
    end;
    if (DBLCBFromAC.Enabled) And (DBEdtFromID.Text <> '') then begin
      SetFromACID(DBEdtFromID.Text);
    end;
    if (DBLCBToAC.Enabled) And (DBEdtToID.Text <> '') then begin
      SetToACID(DBEdtToID.Text);
    end;

    SetExpKey2(Null);
    SetExpKey3(Null);
    SetQuantity(0);
    SetExcludeTax(0);
    SetTax(0);
    SetSubTotal(0);
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

procedure TFrmAddDetailsHeader.ProcAddDetail;
var
  LNextHeaderID : Integer;
  LUID          : Integer;
  LNilObj       : TDBLookupComboBox = nil;
begin
  try
    try
      if CheckInput then begin
        with ATr do begin
          ATr.DataBase := ACn;
          if Not Active then begin
            StartTransaction;
          end;
        end;

        with FrmTopMenu.Defs do begin
          OpenSelQuAndSetNextID(
            ACnNextID, ADSNextID, ATrNextID, AQuNextID, DBEdtHeaderID,
            SQL_20100005);
          LNextHeaderID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
          CloseConn(ACnNextID, ATrNextID);
        end;

        with AQu do begin
          SQL.Text := SQL_20100007;
          Params.ParamByName('pUserID').AsInteger        := FrmTopMenu.Defs.GetUID;
          Params.ParamByName('pHeaderID').AsInteger      := LNextHeaderID;
          Params.ParamByName('pHeaderDT').AsDateTime     := DTPYear.DateTime;
          Params.ParamByName('pShopID').AsInteger        := DBLCBShopName.KeyValue;
          Params.ParamByName('pExpKey1').AsInteger       := DBLCBExp1.KeyValue;
          if Not VarIsNull(DBLCBFromAC.KeyValue) then begin
            Params.ParamByName('pFromID').AsInteger      := DBLCBFromAC.KeyValue;
          end;
          if Not VarIsNull(DBLCBToAC.KeyValue) then begin
            Params.ParamByName('pToID').AsInteger        := DBLCBToAC.KeyValue;
          end;
          if EdtTotalAmount.Text = '' then begin
            Params.ParamByName('pTotalAmount').AsInteger := 0;
          end else begin
            Params.ParamByName('pTotalAmount').AsInteger := StrToInt(StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll]));
          end;
          Params.ParamByName('pEntryDT').AsDateTime      := Now;

          UpdateMode                                     := upWhereAll;

          CloseTransactions;
          ExecSQL;
          ATr.Commit;
        end;

        with FrmTopMenu.Defs do begin
          SetAddDetail(1);
          FrmAddDetail := TFrmAddDetail.Create(Application);
          OpenForm(Self, FrmAddDetail);
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

procedure TFrmAddDetailsHeader.ProcEditDetail;
var
  LNextHeaderID : Integer;
begin
  try
    try
      if CheckInput then begin
        with ATr do begin
          ATr.DataBase := ACn;
          if Not Active then begin
            StartTransaction;
          end;
        end;

        if DBEdtHeaderID.Text = '' then begin
          with FrmTopMenu.Defs do begin
            OpenSelQuAndSetNextID(
              ACnNextID, ADSNextID, ATrNextID, AQuNextID, DBEdtHeaderID,
              SQL_20100005);
            LNextHeaderID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
            CloseConn(ACnNextID, ATrNextID);
          end;
        end;

        with AQu do begin
          SQL.Text := SQL_20100008;
          with Params do begin
            ParamByName('pUserID').AsInteger        := FrmTopMenu.Defs.GetUID;
            ParamByName('pHeaderID').AsInteger      := LNextHeaderID;
            ParamByName('pHeaderDT').AsDateTime     := DTPYear.DateTime;
            ParamByName('pShopID').AsInteger        := DBLCBShopName.KeyValue;
            ParamByName('pExpKey1').AsInteger       := DBLCBExp1.KeyValue;
            if Not VarIsNull(DBLCBFromAC.KeyValue) then begin
              ParamByName('pFromID').AsInteger      := DBLCBFromAC.KeyValue;
            end;
            if Not VarIsNull(DBLCBToAC.KeyValue) then begin
              ParamByName('pToID').AsInteger        := DBLCBToAC.KeyValue;
            end;
            if EdtTotalAmount.Text = '' then begin
              ParamByName('pTotalAmount').AsInteger := 0;
            end else begin
              ParamByName('pTotalAmount').AsInteger := StrToInt(EdtTotalAmount.Text);
            end;
            ParamByName('pEntryDT').AsDateTime      := Now;
          end;

          UpdateMode                                     := upWhereAll;

          CloseTransactions;
          ExecSQL;
          ATr.Commit;
        end;

        with FrmTopMenu.Defs do begin
          FrmEditDetail := TFrmEditDetail.Create(Application);
          OpenForm(Self, FrmEditDetail);
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

procedure TFrmAddDetailsHeader.ProcEntryAccount;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnDetail, ATrDetail);
    CloseConn(ACnNextID, ATrNextID);
    CloseConn(ACnShop  , ATrShop  );
    CloseConn(ACnExp1  , ATrExp1  );
    CloseConn(ACnFromAC, ATrFromAC);
    CloseConn(ACnToAC  , ATrToAC  );

    FrmEntryAccount := TFrmEntryAccount.Create(Application);
    OpenForm(Self, FrmEntryAccount);
  end;
end;

procedure TFrmAddDetailsHeader.ProcEntryShop;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnDetail, ATrDetail);
    CloseConn(ACnNextID, ATrNextID);
    CloseConn(ACnShop  , ATrShop  );
    CloseConn(ACnExp1  , ATrExp1  );
    CloseConn(ACnFromAC, ATrFromAC);
    CloseConn(ACnToAC  , ATrToAC  );

    FrmEntryShop := TFrmEntryShop.Create(Application);
    OpenForm(Self, FrmEntryShop);
  end;
end;

function TFrmAddDetailsHeader.GetGoBack: Boolean;
begin
  Result := FGoBack;
end;

procedure TFrmAddDetailsHeader.SetGoBack(GoBack: boolean);
begin
  FGoBack := GoBack;
end;

procedure TFrmAddDetailsHeader.ActAddDetailExecute(Sender: TObject);
begin
  SetGoBack(False);
  BackupValues;
  FrmTopMenu.Defs.SetAddDetail(1);
  ProcAddDetail;
end;

procedure TFrmAddDetailsHeader.ActEditDetailExecute(Sender: TObject);
begin
  SetGoBack(False);
  BackupValues;
  FrmTopMenu.Defs.SetEditDetail(1);
  ProcEditDetail;
end;

procedure TFrmAddDetailsHeader.ActEntryAccountExecute(Sender: TObject);
begin
  SetGoBack(False);
  BackupValues;
  FrmTopMenu.Defs.SetEntryAccount(1);
  ProcEntryAccount;
end;

procedure TFrmAddDetailsHeader.ActEntryShopExecute(Sender: TObject);
begin
  SetGoBack(False);
  BackupValues;
  FrmTopMenu.Defs.SetEntryShop(1);
  ProcEntryShop;
end;

procedure TFrmAddDetailsHeader.ActQuitExecute(Sender: TObject);
begin
  SetGoBack(True);
  Close;
end;

procedure TFrmAddDetailsHeader.ActRemoveDetailExecute(Sender: TObject);
begin
  with AQuDetail do begin
    SQL.Text := SQL_20100010;
    with FrmTopMenu.Defs do begin
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Params.ParamByName('pDetailID').AsInteger := AQuDetail.FieldByName('DETAIL_ID').AsInteger;
    end;

    CloseTransactions;
    ExecSQL;
    ATrDetail.Commit;
  end;
end;

procedure TFrmAddDetailsHeader.DBLCBExp1Change(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetExpKey1(DBLCBExp1.KeyValue);
    if Not VarIsNull(GetExpKey1) then begin
      if Not VarIsNull(GetExpKey1) then begin
        if GetExpKey1 = 1 then begin
          DBLCBFromAC.Enabled := True;
          DBLCBFromAC.Cursor  := crHandPoint;
          DBLCBToAC.Enabled   := False;
          DBLCBToAC.ItemIndex := -1;
          DBLCBToAC.Cursor    := crDefault;

          if (DBLCBFromAC.Enabled) And (Not VarIsNull(DBLCBFromAC.KeyValue)) then begin
            DBEdtFromID.Text  := DBLCBFromAC.KeyValue;
          end;
          DBEdtToID.Text      := '';
        end else if GetExpKey1 = 2 then begin
          DBLCBFromAC.Enabled   := False;
          DBLCBFromAC.Cursor    := crDefault;
          DBLCBFromAC.ItemIndex := -1;
          DBLCBToAC.Enabled     := True;
          DBLCBToAC.Cursor      := crHandPoint;

          DBEdtFromID.Text      := '';
          if (DBLCBToAC.Enabled) And (Not VarIsNull(DBLCBToAC.KeyValue)) then begin
            DBEdtToID.Text        := DBLCBToAC.KeyValue;
          end;
        end else if GetExpKey1 = 3 then begin
          DBLCBFromAC.Enabled      := True;
          DBLCBFromAC.Cursor       := crHandPoint;
          DBLCBToAC.Enabled        := True;
          DBLCBToAC.Cursor         := crHandPoint;
          if (DBLCBFromAC.Enabled) then begin
            if (Not VarIsNull(GetFromACID)) And (VarToStr(GetFromACID) <> '') then begin
              DBEdtFromID.Text     := GetFromACID;
              DBLCBFromAC.KeyValue := GetFromACID;
            end else begin
              if Not VarIsNull(DBLCBFromAC.KeyValue) then begin
                DBEdtFromID.Text   := DBLCBFromAC.KeyValue;
                FrmTopMenu.Defs.SetFromACID(DBEdtFromID.Text);
              end;
            end;
          end;
          if (DBLCBToAC.Enabled) then begin
            if (Not VarIsNull(GetToACID)) And (VarToStr(GetToACID) <> '') then begin
              DBEdtToID.Text     := GetToACID;
              DBLCBToAC.KeyValue := GetToACID;
            end else begin
              if Not VarIsNull(DBLCBToAC.KeyValue) then begin
                DBEdtToID.Text   := DBLCBToAC.KeyValue;
                FrmTopMenu.Defs.SetToACID(DBEdtToID.Text);
              end;
            end;
          end;
        end;
      end;
      DBEdtExpKey1.Text          := DBLCBExp1.KeyValue;
    end else begin
      FrmTopMenu.Defs.SetFromACID(DBEdtFromID.Text);
      FrmTopMenu.Defs.SetToACID(DBEdtToID.Text);
    end;
  end;
end;

procedure TFrmAddDetailsHeader.DBLCBShopNameChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if DBLCBShopName.Enabled then begin
      if (Not VarIsNull(DBLCBShopName.KeyValue))
        And (VarToStr(DBLCBShopName.KeyValue) <> '') then begin
          DBEdtShopID.Text := DBLCBShopName.KeyValue;
      end else begin
        DBEdtShopID.Text := '';
      end;
      SetShopID(DBEdtShopID.Text);
    end else begin
      DBEdtShopID.Text := '';
      FrmTopMenu.Defs.SetShopID(DBEdtShopID.Text);
    end;
  end;
end;

procedure TFrmAddDetailsHeader.DBLCBFromACChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if DBLCBFromAC.Enabled then begin
      if (Not VarIsNull(DBLCBFromAC.KeyValue))
        And (VarToStr(DBLCBFromAC.KeyValue) <> '') then begin
          DBEdtFromID.Text := DBLCBFromAC.KeyValue;
      end else begin
        DBEdtFromID.Text := '';
      end;
      SetFromACID(DBEdtFromID.Text);
    end else begin
      DBEdtFromID.Text := '';
      SetFromACID(DBEdtFromID.Text);
    end;
  end;
end;

procedure TFrmAddDetailsHeader.DBLCBToACChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if DBLCBToAC.Enabled then begin
      if (Not VarIsNull(DBLCBToAC.KeyValue))
        And (VarToStr(DBLCBToAC.KeyValue) <> '') then begin
          DBEdtToID.Text := DBLCBToAC.KeyValue;
      end else begin
        DBEdtToID.Text := '';
      end;
      SetToACID(DBEdtToID.Text);
    end else begin
      DBEdtToID.Text := '';
      SetToACID(DBEdtToID.Text);
    end;
  end;
end;

procedure TFrmAddDetailsHeader.DTPYearChange(Sender: TObject);
begin
  DTPMonth.DateTime := DTPYear.DateTime;
  DTPDay.DateTime   := DTPYear.DateTime;
  DTPHour.DateTime  := DTPYear.DateTime;
end;

procedure TFrmAddDetailsHeader.EdtTotalAmountChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if EdtTotalAmount.Text <> '' then begin
      SetTotalAmount(StrToInt(EdtTotalAmount.Text));
    end;
  end;
end;

procedure TFrmAddDetailsHeader.DTPMonthChange(Sender: TObject);
begin
  DTPYear.DateTime := DTPMonth.DateTime;
  DTPDay.DateTime  := DTPMonth.DateTime;
  DTPHour.DateTime := DTPYear.DateTime;
end;

procedure TFrmAddDetailsHeader.DTPDayChange(Sender: TObject);
begin
  DTPYear.DateTime  := DTPDay.DateTime;
  DTPMonth.DateTime := DTPDay.DateTime;
  DTPHour.DateTime  := DTPYear.DateTime;
end;

procedure TFrmAddDetailsHeader.DTPHourChange(Sender: TObject);
begin
  DTPYear.DateTime  := DTPHour.DateTime;
  DTPMonth.DateTime := DTPHour.DateTime;
  DTPDay.DateTime   := DTPHour.DateTime;
end;

procedure TFrmAddDetailsHeader.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseTransactions;

  if GetGoBack then begin
    FrmManageDetails := TFrmManageDetails.Create(Application);
    FrmManageDetails.Visible := True;
  end;
  CloseAction              := caFree;
  FrmAddDetailsHeader    := nil;
end;

procedure TFrmAddDetailsHeader.FormShow(Sender: TObject);
var
  i       : Integer;
begin
  SetGoBack(True);

  FrmAddDetailsHeader.Color := RGB(112, 168, 175);
  PnlEntryShop.Color        := RGB( 72, 122, 129);
  PnlEntryAccount.Color     := RGB( 72, 122, 129);
  PnlAddDetail.Color        := RGB( 72, 122, 129);
  PnlEditDetail.Color       := RGB( 72, 122, 129);
  PnlRemoveDetail.Color     := RGB( 72, 122, 129);
  PnlGoBack.Color           := RGB( 72, 122, 129);

  try
    with FrmTopMenu.Defs do begin
      OpenSelQuAndSetVal(
        ACnShop  , ADSShop  , ATrShop  , AQuShop  , DBLCBShopName,
        DBEdtShopID , SQL_20100001, GetShopID);

      if (Not VarIsNull(GetShopID))
        And (VarToStr(GetShopID) <> '')
        And (GetShopID > 0) then begin
          AQuShop.First;
          while Not AQuShop.EOF do begin
            if AQuShop.FieldByName('SHOP_ID').AsInteger = GetShopID then begin
              Break;
            end;
            AQuShop.Next;
          end;
          DBEdtPhoneNum.Text := AQuShop.FieldByName('PHONE_NUM').AsAnsiString;
      end else begin
        DBEdtPhoneNum.Text := '';
      end;

      OpenSelQuAndSetVal(
        ACnExp1  , ADSExp1  , ATrExp1  , AQuExp1  , DBLCBExp1    ,
        DBEdtExpKey1, SQL_20100002, GetExpKey1);
      DBLCBExp1Change(Self);

      OpenSelQuAndSetVal(
        ACnFromAC, ADSFromAC, ATrFromAC, AQuFromAC, DBLCBFromAC  ,
        DBEdtFromID , SQL_20100003, GetFromACID);
      DBLCBFromACChange(Self);

      OpenSelQuAndSetVal(
        ACnToAC  , ADSToAC  , ATrToAC  , AQuToAC  , DBLCBToAC    ,
        DBEdtToID   , SQL_20100004, GetToACID);
      DBLCBToACChange(Self);

      if DBEdtHeaderID.Text = '' then begin
        OpenSelQuAndSetNextID(
          ACnNextID, ADSNextID, ATrNextID, AQuNextID, DBEdtHeaderID,
          SQL_20100005);
        CloseConn(ACnNextID, ATrNextID);
      end else begin
        OpenSelectQueryWithHeaderID(
          ACnDetail, ADSDetail, ATrDetail, AQuDetail,
          SQL_20120005, StrToInt(DBEdtHeaderID.Text));
      end;
    end;

    with FrmTopMenu.Defs do begin
      if GetHeaderDT = '' then begin
        DTPYear.DateTime := Now;
      end else begin
        ShowMessage(GetHeaderDT);
        DTPYear.DateTime
          := StrToDateTime(GetHeaderDT, GetFS);
      end;
    end;

    with FrmTopMenu.Defs do begin
      DBEdtUserID.Text        := GetUID.ToString;
    end;

    with FrmTopMenu.Defs do begin
      DBEdtTotalAmount.Text   := VarToStr(GetTotalAmount);
    end;

    with AQuDetail do begin
      SQL.Text      := SQL_20100009;
      Open;

      if RecordCount <= 0 then begin
        BtnEditDetail.Enabled   := False;
        BtnRemoveDetail.Enabled := False;
      end else begin
        BtnEditDetail.Enabled   := True;
        BtnRemoveDetail.Enabled := True;
      end;
    end;

    with FrmTopMenu.Defs do begin
      SetExpKey1(AQuDetail.FieldByName('EXP_KEY1').AsInteger);
      SetHID(AQuDetail.FieldByName('HEADER_ID').AsInteger);
    end;

    // Clear next screen fields
    with FrmTopMenu.Defs do begin
      SetMakerID(Null);
      SetBrandNameID(Null);
      SetExpKey2(Null);
      SetExpKey3(Null);
    end;

    DBLCBShopName.Height    := 46;
    DBLCBExp1.Height        := 46;

    { Debug }
    //FrmAddDetailsHeader.Width := 1167;
  finally
  end;
end;

end.

