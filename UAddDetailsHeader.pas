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
    ActDeleteDetail  : TAction;
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
    procedure ActDeleteDetailExecute(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FGoBack : Boolean;
    procedure SetDatabaseNames;
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

procedure TFrmAddDetailsHeader.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn      );
    SetDatabaseName(ACnDetail);
    SetDatabaseName(ACnNextID);
    SetDatabaseName(ACnShop  );
    SetDatabaseName(ACnExp1  );
    SetDatabaseName(ACnFromAC);
    SetDatabaseName(ACnToAC  );
  end;
end;

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
begin
  try
    try
      if CheckInput then begin
        with FrmTopMenu.Defs do begin
          OpenSelQuAndSetNextID(
            ACnNextID, ADSNextID, ATrNextID, AQuNextID, DBEdtHeaderID,
            SQL_20100005);
          LNextHeaderID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
          CloseConn(ACnNextID, ATrNextID);

          with AQu do begin
            SQL.Text := SQL_20100007;
            with Params do begin
              ParamByName('pUserID').AsInteger        := GetUID;
              ParamByName('pHeaderID').AsInteger      := LNextHeaderID;
              ParamByName('pHeaderDT').AsDateTime     := DTPYear.DateTime;
              ParamByName('pShopID').AsInteger        := StrToInt(VarToStr(DBLCBShopName.KeyValue));
              ParamByName('pExpKey1').AsInteger       := StrToInt(VarToStr(DBLCBExp1.KeyValue));
              if Not VarIsNull(DBLCBFromAC.KeyValue) then begin
                ParamByName('pFromID').AsInteger      := StrToInt(VarToStr(DBLCBFromAC.KeyValue));
              end;
              if Not VarIsNull(DBLCBToAC.KeyValue) then begin
                ParamByName('pToID').AsInteger        := StrToInt(VarToStr(DBLCBToAC.KeyValue));
              end;
              if EdtTotalAmount.Text = '' then begin
                ParamByName('pTotalAmount').AsInteger := 0;
              end else begin
                ParamByName('pTotalAmount').AsInteger := StrToInt(StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll]));
              end;
              ParamByName('pEntryDT').AsDateTime      := Now;
            end;

            UpdateMode                                     := upWhereAll;

            CloseTransactions;
            SetDatabaseNames;

            ExecSQL;
            ATr.Commit;
          end;
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

        with FrmTopMenu.Defs do begin
          with AQu do begin
            SQL.Text := SQL_20100008;
            with Params do begin
              ParamByName('pUserID').AsInteger        := GetUID;
              ParamByName('pHeaderID').AsInteger      := LNextHeaderID;
              ParamByName('pHeaderDT').AsDateTime     := DTPYear.DateTime;
              ParamByName('pShopID').AsInteger        := StrToInt(VarToStr(DBLCBShopName.KeyValue));
              ParamByName('pExpKey1').AsInteger       := StrToInt(VarToStr(DBLCBExp1.KeyValue));
              if Not VarIsNull(DBLCBFromAC.KeyValue) then begin
                ParamByName('pFromID').AsInteger      := StrToInt(VarToStr(DBLCBFromAC.KeyValue));
              end;
              if Not VarIsNull(DBLCBToAC.KeyValue) then begin
                ParamByName('pToID').AsInteger        := StrToInt(VarToStr(DBLCBToAC.KeyValue));
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
            SetDatabaseNames;

            ExecSQL;
            ATr.Commit;
          end;
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
    CloseTransactions;

    FrmEntryAccount := TFrmEntryAccount.Create(Application);
    OpenForm(Self, FrmEntryAccount);
  end;
end;

procedure TFrmAddDetailsHeader.ProcEntryShop;
begin
  with FrmTopMenu.Defs do begin
    CloseTransactions;

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
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    BackupValues;
    SetAddDetail(1);
    ProcAddDetail;
  end;
end;

procedure TFrmAddDetailsHeader.ActEditDetailExecute(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEditDetail(1);
    ProcEditDetail;
  end;
end;

procedure TFrmAddDetailsHeader.ActEntryAccountExecute(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEntryAccount(1);
    ProcEntryAccount;
  end;
end;

procedure TFrmAddDetailsHeader.ActEntryShopExecute(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEntryShop(1);
    ProcEntryShop;
  end;
end;

procedure TFrmAddDetailsHeader.ActQuitExecute(Sender: TObject);
begin
  SetGoBack(True);
  Close;
end;

procedure TFrmAddDetailsHeader.ActDeleteDetailExecute(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    with AQuDetail do begin
      SQL.Text := SQL_20100010;
      with Params do begin
        ParamByName('pUserID').AsInteger   := GetUID;
        ParamByName('pHeaderID').AsInteger := GetHID;
        ParamByName('pDetailID').AsInteger := FieldByName('DETAIL_ID').AsInteger;
      end;

      CloseTransactions;
      SetDatabaseNames;

      ExecSQL;
      ATrDetail.Commit;
    end;
  end;
end;

procedure TFrmAddDetailsHeader.DBLCBExp1Change(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetExpKey1(DBLCBExp1.KeyValue);
    if Not VarIsNull(GetExpKey1) then begin
      if Not VarIsNull(GetExpKey1) then begin
        if StrToInt(VarToStr(GetExpKey1)) = 1 then begin
          with DBLCBFromAC do begin
            Enabled := True;
            Cursor  := crHandPoint;
          end;
          with DBLCBToAC do begin
            Enabled   := False;
            ItemIndex := -1;
            Cursor    := crDefault;
          end;

          if (DBLCBFromAC.Enabled) And (Not VarIsNull(DBLCBFromAC.KeyValue)) then begin
            DBEdtFromID.Text  := DBLCBFromAC.KeyValue;
          end;
          DBEdtToID.Text      := '';
        end else if StrToInt(VarToStr(GetExpKey1)) = 2 then begin
          with DBLCBFromAC do begin
            Enabled   := False;
            Cursor    := crDefault;
            ItemIndex := -1;
          end;
          with DBLCBToAC do begin
            Enabled     := True;
            Cursor      := crHandPoint;
          end;

          DBEdtFromID.Text      := '';
          if (DBLCBToAC.Enabled) And (Not VarIsNull(DBLCBToAC.KeyValue)) then begin
            DBEdtToID.Text        := DBLCBToAC.KeyValue;
          end;
        end else if StrToInt(VarToStr(GetExpKey1)) = 3 then begin
          with DBLCBFromAC do begin
            Enabled      := True;
            Cursor       := crHandPoint;
          end;
          with DBLCBToAC do begin
            Enabled        := True;
            Cursor         := crHandPoint;
          end;
          if (DBLCBFromAC.Enabled) then begin
            if (Not VarIsNull(GetFromACID)) And (VarToStr(GetFromACID) <> '') then begin
              DBEdtFromID.Text     := GetFromACID;
              DBLCBFromAC.KeyValue := GetFromACID;
            end else begin
              if Not VarIsNull(DBLCBFromAC.KeyValue) then begin
                DBEdtFromID.Text   := DBLCBFromAC.KeyValue;
                SetFromACID(DBEdtFromID.Text);
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
                SetToACID(DBEdtToID.Text);
              end;
            end;
          end;
        end;
      end;
      DBEdtExpKey1.Text          := DBLCBExp1.KeyValue;
    end else begin
      SetFromACID(DBEdtFromID.Text);
      SetToACID(DBEdtToID.Text);
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
      SetShopID(DBEdtShopID.Text);
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
  with DTPYear do begin
    DTPMonth.DateTime := DateTime;
    DTPDay.DateTime   := DateTime;
    DTPHour.DateTime  := DateTime;
  end;
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
  CloseTransactions;

  if GetGoBack then begin
    FrmManageDetails := TFrmManageDetails.Create(Application);
    FrmManageDetails.Visible := True;
  end;
  CloseAction              := caFree;
  FrmAddDetailsHeader    := nil;
end;

procedure TFrmAddDetailsHeader.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  SetGoBack(True);
end;

procedure TFrmAddDetailsHeader.FormShow(Sender: TObject);
begin
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
        DBEdtShopID , SQL_20100001, StrToInt(VarToStr(GetShopID)));

      if (Not VarIsNull(GetShopID))
        And (VarToStr(GetShopID) <> '') And (StrToInt(VarToStr(GetShopID)) > 0) then begin
          with AQuShop do begin
            First;
            while Not EOF do begin
              if FieldByName('SHOP_ID').AsInteger = StrToInt(VarToStr(GetShopID)) then begin
                Break;
              end;
              Next;
            end;
            if FieldByName('PHONE_NUM').AsAnsiString <> '' then begin
              DBEdtPhoneNum.Text := FieldByName('PHONE_NUM').AsAnsiString;
            end;
          end;
      end else begin
        DBEdtPhoneNum.Text := '';
      end;

      OpenSelQuAndSetVal(
        ACnExp1  , ADSExp1  , ATrExp1  , AQuExp1  , DBLCBExp1    ,
        DBEdtExpKey1, SQL_20100002, StrToInt(VarToStr(GetExpKey1)));
      DBLCBExp1Change(Self);

      if (Not VarIsNull(GetFromACID))
          And (VarToStr(GetFromACID) <> '') then begin
        OpenSelQuAndSetVal(
          ACnFromAC, ADSFromAC, ATrFromAC, AQuFromAC, DBLCBFromAC  ,
          DBEdtFromID , SQL_20100003, StrToInt(VarToStr(GetFromACID)));
        DBLCBFromACChange(Self);
      end else begin
        OpenSelQuAndSetVal(
          ACnFromAC, ADSFromAC, ATrFromAC, AQuFromAC, DBLCBFromAC  ,
          DBEdtFromID , SQL_20100003, 0);
        DBLCBFromACChange(Self);
      end;

      if (Not VarIsNull(GetToACID))
          And (VarToStr(GetToACID) <> '') then begin
        OpenSelQuAndSetVal(
          ACnToAC  , ADSToAC  , ATrToAC  , AQuToAC  , DBLCBToAC    ,
          DBEdtToID   , SQL_20100004, StrToInt(VarToStr(GetToACID)));
        DBLCBToACChange(Self);
      end else begin
        OpenSelQuAndSetVal(
          ACnToAC  , ADSToAC  , ATrToAC  , AQuToAC  , DBLCBToAC    ,
          DBEdtToID   , SQL_20100004, 0);
        DBLCBToACChange(Self);
      end;

      if DBEdtHeaderID.Text = '' then begin
        OpenSelQuAndSetNextID(
          ACnNextID, ADSNextID, ATrNextID, AQuNextID, DBEdtHeaderID,
          SQL_20100005);
        CloseConn(ACnNextID, ATrNextID);
      end else begin
        CloseConn(ACnDetail, ATrDetail);
        SetDatabaseNames;

        OpenSelectQueryWithHeaderID(
          ACnDetail, ADSDetail, ATrDetail, AQuDetail,
          SQL_20120005, StrToInt(DBEdtHeaderID.Text));
      end;

      if GetHeaderDT = '' then begin
        DTPYear.DateTime := Now;
      end else begin
        DTPYear.DateTime
          := StrToDateTime(GetHeaderDT, GetFS);
      end;

      DBEdtUserID.Text        := GetUID.ToString;

      DBEdtTotalAmount.Text   := IntToStr(GetTotalAmount);

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

