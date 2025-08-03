unit UAddDetail;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, DBCtrls, LCLIntf, ActnList,
  DBDateTimePicker, DateTimePicker;

type

  { TFrmAddDetail }

  TFrmAddDetail = class(TForm)
    ACn               : TSQLite3Connection;
    ADS               : TDataSource;
    ATr               : TSQLTransaction;
    AQu               : TSQLQuery;
    ACnNextID         : TSQLite3Connection;
    ADSNextID         : TDataSource;
    ATrNextID         : TSQLTransaction;
    AQuNextID         : TSQLQuery;
    ACnMaker          : TSQLite3Connection;
    ADSMaker          : TDataSource;
    ATrMaker          : TSQLTransaction;
    AQuMaker          : TSQLQuery;
    ACnBrand          : TSQLite3Connection;
    ADSBrand          : TDataSource;
    ATrBrand          : TSQLTransaction;
    AQuBrand          : TSQLQuery;
    ACnExp2           : TSQLite3Connection;
    ADSExp2           : TDataSource;
    ATrExp2           : TSQLTransaction;
    AQuExp2           : TSQLQuery;
    ACnExp3           : TSQLite3Connection;
    ADSExp3           : TDataSource;
    ATrExp3           : TSQLTransaction;
    AQuExp3           : TSQLQuery;
    ACnUnit           : TSQLite3Connection;
    ADSUnit           : TDataSource;
    ATrUnit           : TSQLTransaction;
    AQuUnit           : TSQLQuery;
    ACnTaxType        : TSQLite3Connection;
    ADSTaxType        : TDataSource;
    ATrTaxType        : TSQLTransaction;
    AQuTaxType        : TSQLQuery;
    { ActionLists }
    ActionList        : TActionList;
    ActEntryMaker     : TAction;
    ActEntryBrandName : TAction;
    ActEntryUnit      : TAction;
    ActCancel         : TAction;
    ActCommit         : TAction;
    ActQuit           : TAction;
    { Screen controls }
    BtnEntryMaker     : TButton;
    BtnEntryBrandName : TButton;
    BtnEntryUnit      : TButton;
    BtnCancel         : TButton;
    BtnCommit         : TButton;
    BtnGoBack         : TButton;
    EdtExcludeTax     : TEdit;
    DBDTPEntryDT      : TDBDateTimePicker;
    DBDTPUpdateDT     : TDBDateTimePicker;
    DBEdtTax          : TDBEdit;
    DBEdtBrandNameID  : TDBEdit;
    DBEdtDetailID     : TDBEdit;
    DBEdtExpKey1      : TDBEdit;
    DBEdtExpKey2      : TDBEdit;
    DBEdtExpKey3      : TDBEdit;
    DBEdtMakerID      : TDBEdit;
    DBEdtHeaderID     : TDBEdit;
    DBEdtExcludeTax   : TDBEdit;
    DBEdtTaxTypeID    : TDBEdit;
    DBEdtSubTotal     : TDBEdit;
    DBEdtUnitID       : TDBEdit;
    DBEdtQuantity     : TDBEdit;
    DBEdtUserID       : TDBEdit;
    DBLCBMaker        : TDBLookupComboBox;
    DBLCBExp2         : TDBLookupComboBox;
    DBLCBExp3         : TDBLookupComboBox;
    DBLCBBrandName    : TDBLookupComboBox;
    DBLCBUnit         : TDBLookupComboBox;
    DBLCBTaxType      : TDBLookupComboBox;
    EdtAmount         : TEdit;
    EdtTax            : TEdit;
    EdtQuantity       : TEdit;
    EdtSubTotal       : TEdit;
    LblMaker          : TLabel;
    LblBrandName1     : TLabel;
    LblBrandName2     : TLabel;
    LblExp1           : TLabel;
    LblExp2           : TLabel;
    LblUnit1          : TLabel;
    LblUnit2          : TLabel;
    LblTaxType1       : TLabel;
    LblTaxType2       : TLabel;
    LblTaxType3       : TLabel;
    LblQuantity1      : TLabel;
    LblQuantity2      : TLabel;
    LblAmount1        : TLabel;
    LblAmount2        : TLabel;
    LblExcludeTax1    : TLabel;
    LblExcludeTax2    : TLabel;
    LblExcludeTax3    : TLabel;
    LblExcludeTax4    : TLabel;
    LblTax1           : TLabel;
    LblTax2           : TLabel;
    LblSubTotal1      : TLabel;
    LblSubTotal2      : TLabel;
    PnlSeparator      : TPanel;
    PnlCancel         : TPanel;
    PnlCommit         : TPanel;
    PnlGoBack         : TPanel;
    PnlEntryUnit      : TPanel;
    PnlEntryBrandName : TPanel;
    PnlEntryMaker     : TPanel;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
    procedure ActEntryBrandNameExecute(Sender: TObject);
    procedure ActEntryMakerExecute(Sender: TObject);
    procedure ActEntryUnitExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure DBLCBBrandNameChange(Sender: TObject);
    procedure DBLCBExp2Change(Sender: TObject);
    procedure DBLCBExp3Change(Sender: TObject);
    procedure DBLCBMakerChange(Sender: TObject);
    procedure DBLCBUnitChange(Sender: TObject);
    procedure DBLCBTaxTypeChange(Sender: TObject);
    procedure DBLCBTaxTypeExit(Sender: TObject);
    procedure EdtQuantityExit(Sender: TObject);
    procedure EdtAmountChange(Sender: TObject);
    procedure EdtExcludeTaxExit(Sender: TObject);
    procedure EdtTaxChange(Sender: TObject);
    procedure EdtTaxExit(Sender: TObject);
    procedure EdtSubTotalChange(Sender: TObject);
    procedure EdtSubTotalExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FInsert     : Boolean;
    FGoBack     : Boolean;
    FTaxRate    : Double;
    FQuantity   : Variant;
    FAmount     : Variant;
    FExcludeTax : Variant;
    FTax        : Variant;
    FSubTotal   : Variant;
    procedure CloseTransactions;
    procedure BackupValues;
    procedure CalcInclusiveTax;
    procedure ClearInputFields;
    procedure ProcCancel;
    procedure ProcCommit;
    procedure ProcInsert;
    procedure ProcEntryBrandName;
    procedure ProcEntryMaker;
    procedure ProcEntryUnit;
    function GetGoBack: Boolean;
    procedure SetGoBack(GoBack: boolean);
    function GetQuantity: Variant;
    procedure SetQuantity(Quantity: Variant);
    function GetAmount: Variant;
    procedure SetAmount(Amount: Variant);
    function GetExcludeTax: Variant;
    procedure SetExcludeTax(ExcludeTax: Variant);
    function GetTax: Variant;
    procedure SetTax(Tax: Variant);
    function GetSubTotal: Variant;
    procedure SetSubTotal(SubTotal: Variant);
    procedure SelectExp2(
      var Cn2: TSQLite3Connection; var DS2: TDataSource;
      var Tr2: TSQLTransaction; var Qu2: TSQLQuery);
    procedure SelectExp3(
      var Cn3: TSQLite3Connection; var DS3: TDataSource;
      var Tr3: TSQLTransaction; var Qu3: TSQLQuery);
    property GoBack: Boolean read GetGoBack write SetGoBack;
    property Quantity: Variant read GetQuantity write SetQuantity;
    property Amount: Variant read GetAmount write SetAmount;
    property ExcludeTax: Variant read GetExcludeTax write SetExcludeTax;
    property Tax: Variant read GetTax write SetTax;
    property SubTotal: Variant read GetSubTotal write SetSubTotal;
  public

  end;

var
  FrmAddDetail: TFrmAddDetail;

implementation
uses
  UConsts, UDefs, UDBAccess, UTopMenu, UManageDetails, UAddDetailsHeader,
  UEditDetailsHeader, UEntryBrandName, UEntryMaker, UEntryUnit;

{$R *.lfm}

{ TFrmAddDetail }

procedure TFrmAddDetail.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn       , ATr       );
    CloseConn(ACnNextID , ATrNextID );
    CloseConn(ACnMaker  , ATrMaker  );
    CloseConn(ACnBrand  , ATrBrand  );
    CloseConn(ACnExp2   , ATrExp2   );
    CloseConn(ACnExp3   , ATrExp3   );
    CloseConn(ACnUnit   , ATrUnit   );
    CloseConn(ACnTaxType, ATrTaxType);
  end;
end;

procedure TFrmAddDetail.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    if DBEdtHeaderID.Text <> '' then begin
      SetHID(StrToInt(DBEdtHeaderID.Text));
    end;

    if DBEdtDetailID.Text <> '' then begin
      SetDID(StrToInt(DBEdtDetailID.Text));
    end else begin
      SetDID(Null);
    end;

    if DBEdtMakerID.Text <> '' then begin
      SetMakerID(DBEdtMakerID.Text);
    end else begin
      SetMakerID(Null);
    end;

    if DBEdtBrandNameID.Text <> '' then begin
      SetBrandNameID(DBEdtBrandNameID.Text);
    end else begin
      SetBrandNameID(Null);
    end;

    if DBEdtExpKey1.Text <> '' then begin
      SetExpKey1(DBEdtExpKey1.Text);
    end;

    if DBEdtExpKey2.Text <> '' then begin
      SetExpKey2(DBEdtExpKey2.Text);
    end else begin
      SetExpKey2(Null);
    end;

    if DBEdtExpKey3.Text <> '' then begin
      SetExpKey3(DBEdtExpKey3.Text);
    end else begin
      SetExpKey3(Null);
    end;

    if DBEdtUnitID.Text <> '' then begin
      SetUnitID(DBEdtUnitID.Text);
    end else begin
      SetUnitID(Null);
    end;

    if DBEdtTaxTypeID.Text <> '' then begin
      SetTaxTypeID(DBEdtTaxTypeID.Text);
    end else begin
      SetTaxTypeID(Null);
    end;

    if AQuTaxType.Active then begin;
      if (Not VarIsNull(DBLCBTaxType.KeyValue))
          And (VarToStr(DBLCBTaxType.KeyValue) <> '')
          And (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) > 0) then begin
        AQuTaxType.First;
        while AQuTaxType.FieldByName('TAX_TYPE_ID').AsInteger <> StrToInt(VarToStr(DBLCBTaxType.KeyValue)) do begin
          if AQuTaxType.EOF then begin
            break;
          end;
          AQuTaxType.Next;
        end;
        SetTaxRateID(AQuTaxType.FieldByName('TAX_RATE_ID').AsVariant);
      end else begin
        SetTaxRateID(Null);
      end;
    end;

    if DBEdtQuantity.Text <> '' then begin
      SetQuantity(StrToInt(DBEdtQuantity.Text));
    end else begin
      SetQuantity(0);
    end;

    if EdtAmount.Text <> '' then begin
      SetAmount(StringReplace(EdtAmount.Text, ',', '', [rfReplaceAll]));
    end else begin
      SetAmount(Null);
    end;

    if DBEdtExcludeTax.Text <> '' then begin
      SetExcludeTax(StrToInt(DBEdtExcludeTax.Text));
    end else begin
      SetExcludeTax(0);
    end;

    if DBEdtTax.Text <> '' then begin
      SetTax(StrToInt(DBEdtTax.Text));
    end else begin
      SetTax(0);
    end;

    if DBEdtSubTotal.Text <> '' then begin
      SetSubTotal(StrToInt(DBEdtSubTotal.Text));
    end else begin
      SetSubTotal(0);
    end;
  end;
end;

procedure TFrmAddDetail.CalcInclusiveTax;
begin
  if (DBEdtSubTotal.Text <> '')
      And (StrToInt(DBEdtSubTotal.Text) <> 0) then begin
    DBEdtTax.Text :=
      IntToStr(Round(StrToInt(DBEdtSubTotal.Text) / (1 + FTaxRate) * FTaxRate));
    EdtTax.Text   := FormatFloat('#,##0', StrToInt(DBEdtTax.Text));

    DBEdtExcludeTax.Text :=
      IntToStr(StrToInt(DBEdtSubTotal.Text) - StrToInt(DBEdtTax.Text));
    EdtExcludeTax.Text := FormatFloat('#,##0', StrToInt(DBEdtExcludeTax.Text));

    if (DBEdtExcludeTax.Text <> '')
        And (StrToInt(DBEdtExcludeTax.Text) <> 0)
        And (DBEdtQuantity.Text <> '')
        And (StrToInt(DBEdtQuantity.Text) > 0) then begin
          EdtAmount.Text :=
            FormatFloat('#,##0.000',
            StrToInt(DBEdtExcludeTax.Text) / StrToInt(DBEdtQuantity.Text));
    end else begin
      EdtAmount.Text := FormatFloat('#,##0.000', 0);
    end;
  end;
end;

procedure TFrmAddDetail.ClearInputFields;
var
  LNextDetailID : Integer;
begin
  with FrmTopMenu.Defs do begin
    DBEdtUserID.Text        := VarToStr(GetUID);
    DBEdtHeaderID.Text      := VarToStr(GetHID);

    OpenSelectQueryWithHeaderID(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20120003, GetHID);
    LNextDetailID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
    CloseConn(ACnNextID, ATrNextID);

    SetMakerID(Null);
    SetBrandNameID(Null);
    SetExpKey2(Null);
    SetExpKey3(Null);
    SetUnitID(Null);
    SetTaxTypeID(Null);

    SetQuantity(0);
    SetAmount(0);
    SetExcludeTax(0);
    SetTax(0);
    SetSubTotal(0);

    DBEdtDetailID.Text      := IntToStr(LNextDetailID);
    DBLCBMaker.KeyValue     := -1;
    DBLCBBrandName.KeyValue := -1;
    DBLCBExp2.KeyValue      := -1;
    DBLCBExp3.KeyValue      := -1;
    DBLCBUnit.KeyValue      := -1;
    DBLCBTaxType.KeyValue   := -1;

    DBEdtMakerID.Text     := '';
    DBEdtBrandNameID.Text := '';
    DBEdtExpKey2.Text     := '';
    DBEdtExpKey3.Text     := '';
    DBEdtUnitID.Text      := '';
    DBEdtTaxTypeID.Text   := '';

    EdtQuantity.Text        := IntToStr(0);
    EdtAmount.Text          := FormatFloat('#,##0.000', 0);
    EdtExcludeTax.Text      := IntToStr(0);
    EdtTax.Text             := IntToStr(0);
    EdtSubTotal.Text        := IntToStr(0);

    DBEdtQuantity.Text        := '';
    DBEdtExcludeTax.Text      := '';
    DBEdtTax.Text             := '';
    DBEdtSubTotal.Text        := '';
  end;
end;

procedure TFrmAddDetail.ProcCancel;
begin
  if FInsert then begin
    FInsert := False;
  end;
  ATr.Rollback;

  ClearInputFields;

  DBLCBMaker.SetFocus;
end;

procedure TFrmAddDetail.ProcCommit;
var
  LNextDetailID : Integer = 0;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        if (VarIsNull(GetDID))
          Or (VarToStr(GetDID) = '')
          Or (StrToInt(VarToStr(GetDID)) = 0)then begin
          OpenSelectQueryWithHeaderID(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20120003, GetHID);
          LNextDetailID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

          CloseConn(ACnNextID, ATrNextID);
          DBEdtDetailID.Text := IntToStr(LNextDetailID);
          SetDID(LNextDetailID);
        end;
      end;

      with AQu do begin
        SQL.Text := SQL_20120007;
        with FrmTopMenu.Defs do begin
          Params.ParamByName('pUserID'     ).AsInteger   := GetUID;
          Params.ParamByName('pHeaderID'   ).AsInteger   := GetHID;
          Params.ParamByName('pDetailID'   ).AsInteger   := GetDID;
          Params.ParamByName('pExpKey1'    ).AsInteger   := GetExpKey1;
          if (Not VarIsNull(GetExpKey2))
            And (VarToStr(GetExpKey2) <> '')
            And (StrToInt(VarToStr(GetExpKey2)) > 0) then begin
            Params.ParamByName('pExpKey2'    ).AsInteger   := StrToInt(VarToStr(GetExpKey2));
          end else begin
            Params.ParamByName('pExpKey2'    ).AsInteger   := 0;
          end;
          if (Not VarIsNull(GetExpKey3))
            And (VarToStr(GetExpKey3) <> '')
            And (StrToInt(VarToStr(GetExpKey3)) > 0) then begin
            Params.ParamByName('pExpKey3'    ).AsInteger   := StrToInt(VarToStr(GetExpKey3));
          end else begin
            Params.ParamByName('pExpKey3'    ).AsInteger   := 0;
          end;
          Params.ParamByName('pMakerID'    ).AsInteger   := GetMakerID;
          Params.ParamByName('pBrandNameID').AsInteger   := GetBrandNameID;
          Params.ParamByName('pQuantity'   ).AsInteger   := GetQuantity;
          Params.ParamByName('pUnitID'     ).AsInteger   := GetUnitID;
          Params.ParamByName('pExcludeTax' ).AsInteger   := GetExcludeTax;
          Params.ParamByName('pTaxTypeID'  ).AsInteger   := GetTaxTypeID;
          Params.ParamByName('pTaxRateID'  ).AsInteger   := GetTaxRateID;
          Params.ParamByName('pTax'        ).AsInteger   := GetTax;
          Params.ParamByName('pSubTotal'   ).AsInteger   := GetSubTotal;
          Params.ParamByName('pEntryDT'    ).AsDateTime  := Now;
          Params.ParamByName('pUpdateDT'   ).AsDateTime  := Now;
        end;
        CloseTransactions;
        ExecSQL;
        ATr.Commit;
      end;

      // Clear input values
      with FrmTopMenu.Defs do begin
        CloseTransactions;

        DBEdtMakerID.Text     := '';
        DBEdtBrandNameID.Text := '';
        DBEdtExpKey2.Text     := '';
        DBEdtExpKey3.Text     := '';
        DBEdtUnitID.Text      := '';
        DBEdtTaxTypeID.Text   := '';

        DBEdtQuantity.Text    := '';
        DBEdtExcludeTax.Text  := '';
        DBEdtTax.Text         := '';
        DBEdtSubTotal.Text    := '';

        FormShow(Self);
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
    FInsert := False;
  end;
end;

procedure TFrmAddDetail.ProcInsert;
begin
  if Not FInsert then begin
    with AQu do begin
      //Edit;
      if AQu.RecordCount > 0 then begin;
        Insert;
      end;
      FInsert := True;
    end;

    DBLCBMaker.SetFocus;
  end;
end;

procedure TFrmAddDetail.ProcEntryBrandName;
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    SetEntryBrandName(1);

    FrmEntryBrandName := TFrmEntryBrandName.Create(Application);
    OpenForm(Self, FrmEntryBrandName);
  end;
end;

procedure TFrmAddDetail.ProcEntryMaker;
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    SetEntryMaker(1);

    FrmEntryMaker := TFrmEntryMaker.Create(Application);
    OpenForm(Self, FrmEntryMaker);
  end;
end;

procedure TFrmAddDetail.ProcEntryUnit;
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    SetEntryUnit(1);

    FrmEntryUnit := TFrmEntryUnit.Create(Application);
    OpenForm(Self, FrmEntryUnit);
  end;
end;

function TFrmAddDetail.GetGoBack: Boolean;
begin
  Result := FGoBack;
end;

procedure TFrmAddDetail.SetGoBack(GoBack: boolean);
begin
  FGoBack := GoBack;
end;

function TFrmAddDetail.GetQuantity: Variant;
begin
  Result := FQuantity;
end;

procedure TFrmAddDetail.SetQuantity(Quantity: Variant);
begin
  FQuantity := Quantity;
end;

function TFrmAddDetail.GetAmount: Variant;
begin
  Result := FAmount;
end;

procedure TFrmAddDetail.SetAmount(Amount: Variant);
begin
  FAmount := Amount;
end;

function TFrmAddDetail.GetExcludeTax: Variant;
begin
  Result := FExcludeTax;
end;

procedure TFrmAddDetail.SetExcludeTax(ExcludeTax: Variant);
begin
  FExcludeTax := ExcludeTax;
end;

function TFrmAddDetail.GetTax: Variant;
begin
  Result := FTax;
end;

procedure TFrmAddDetail.SetTax(Tax: Variant);
begin
  FTax := Tax;
end;

function TFrmAddDetail.GetSubTotal: Variant;
begin
  Result := FSubTotal;
end;

procedure TFrmAddDetail.SetSubTotal(SubTotal: Variant);
begin
  FSubTotal := SubTotal;
end;

procedure TFrmAddDetail.SelectExp2(
  var Cn2: TSQLite3Connection; var DS2: TDataSource;
  var Tr2: TSQLTransaction; var Qu2: TSQLQuery);
var
  i        : Integer;
begin
  try
    with FrmTopMenu.Defs do begin
      with Qu2 do begin
        OpenConn(Cn2, DS2, Tr2, Qu2);

        SQL.Text     := SQL_20120001;
        with Params do begin
          ParamByName('pUserID').AsInteger  := GetUID;
          ParamByName('pExpKey1').AsInteger := GetExpKey1;
        end;
        Tr2.StartTransaction;
        Open;
      end;
    end;
  finally
  end;
end;

procedure TFrmAddDetail.SelectExp3(
  var Cn3: TSQLite3Connection; var DS3: TDataSource;
  var Tr3: TSQLTransaction; var Qu3: TSQLQuery);
var
  i        : Integer;
  LRow     : Integer;
begin
  try
    with FrmTopMenu.Defs do begin
      with Qu3 do begin
        OpenConn(Cn3, DS3, Tr3, Qu3);

        SQL.Text     := SQL_20120002;
        with Params do begin
          ParamByName('pUserID').AsInteger  := GetUID;
          ParamByName('pExpKey1').AsInteger := GetExpKey1;
          if Not VarIsNull(DBLCBExp2.KeyValue) then begin
            ParamByName('pExpKey2').AsInteger := DBLCBExp2.KeyValue;

            Tr3.Active        := True;
            Open;
          end;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmAddDetail.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmAddDetail.ActCommitExecute(Sender: TObject);
begin
  BackupValues;
  ProcCommit;
  ProcInsert;
  ClearInputFields;
end;

procedure TFrmAddDetail.ActEntryBrandNameExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryBrandName;
end;

procedure TFrmAddDetail.ActEntryMakerExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryMaker;
end;

procedure TFrmAddDetail.ActEntryUnitExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryUnit;
end;

procedure TFrmAddDetail.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmAddDetail.DBLCBMakerChange(Sender: TObject);
begin
  if Not VarIsNull(DBLCBMaker.KeyValue) then begin
    if VarToStr(DBLCBMaker.KeyValue) <> DBEdtMakerID.Text then begin
      DBEdtMakerID.Text := DBLCBMaker.KeyValue;
      with FrmTopMenu.Defs do begin
        SetMakerID(DBLCBMaker.KeyValue);

        // Set BrandName ComboBox
        OpenSelQuBrandAndSetVal(ACnBrand, ADSBrand, ATrBrand, AQuBrand,
        DBLCBBrandName, DBEdtBrandNameID, SQL_20140001, 0);
      end;
    end;
  end;
end;

procedure TFrmAddDetail.DBLCBBrandNameChange(Sender: TObject);
begin
  if Not VarIsNull(DBLCBBrandName.KeyValue) then begin
    if VarToStr(DBLCBBrandName.KeyValue) <> DBEdtBrandNameID.Text then begin
      DBEdtBrandNameID.Text := DBLCBBrandName.KeyValue;
      with FrmTopMenu.Defs do begin
        SetBrandNameID(DBLCBBrandName.KeyValue);
      end;
    end;
  end else begin
    DBEdtBrandNameID.Text := '';
  end;
end;

procedure TFrmAddDetail.DBLCBExp2Change(Sender: TObject);
begin
  if Not VarIsNull(DBLCBExp2.KeyValue) then begin
    if VarToStr(DBLCBExp2.KeyValue) <> DBEdtExpKey2.Text then begin
      DBEdtExpKey2.Text := DBLCBExp2.KeyValue;
      with FrmTopMenu.Defs do begin
        SetExpKey2(DBLCBExp2.KeyValue);
      end;
      SelectExp3(ACnExp3, ADSExp3, ATrExp3, AQuExp3);
      if AQuExp3.RecordCount = 0 then begin
        DBEdtExpKey3.Text := '';
      end;
    end;
  end;
end;

procedure TFrmAddDetail.DBLCBExp3Change(Sender: TObject);
begin
  if Not VarIsNull(DBLCBExp3.KeyValue) then begin
    if StrToInt(VarToStr(DBLCBExp3.KeyValue)) > 0 then begin
      if VarToStr(DBLCBExp3.KeyValue) <> DBEdtExpKey3.Text then begin
        DBEdtExpKey3.Text := DBLCBExp3.KeyValue;
        with FrmTopMenu.Defs do begin
          SetExpKey3(DBLCBExp3.KeyValue);
        end;
      end;
    end else begin
      DBEdtExpKey3.Text := '';
    end;
  end else begin
    DBEdtExpKey3.Text := '';
  end;
end;

procedure TFrmAddDetail.DBLCBUnitChange(Sender: TObject);
begin
  DBEdtUnitID.Text := VarToStr(DBLCBUnit.KeyValue);
end;

procedure TFrmAddDetail.DBLCBTaxTypeChange(Sender: TObject);
begin
  DBEdtTaxTypeID.Text := VarToStr(DBLCBTaxType.KeyValue);
  if Not VarIsNull(DBLCBTaxType.KeyValue) then begin
    with AQuTaxType do begin
      First;
      while Not EOF do begin
        if FieldByName('TAX_TYPE_ID').AsInteger = StrToInt(VarToStr(DBLCBTaxType.KeyValue)) then begin
          Break;
        end;
        Next;
      end;

      with FrmTopMenu.Defs do begin
        SetTaxRateID(FieldByName('TAX_RATE_ID').AsVariant);
      end;

      FTaxRate := FieldByName('TAX_RATE').AsInteger / 100;
    end;

    if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 1)
      Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 2) then begin
      if (DBEdtExcludeTax.Text <> '')
        And (StrToInt(DBEdtExcludeTax.Text) <> 0) then begin
          EdtTax.Text := FormatFloat('#,##0', Round(StrToInt(VarToStr(GetExcludeTax)) * FTaxRate));
      end else begin
          EdtTax.Text := FormatFloat('#,##0', 0);
      end;
    end else if ((StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 3)
        Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 4))
        And (EdtSubTotal.Text <> '') then begin
        CalcInclusiveTax;
    end else if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 5) then begin
      DBEdtTax.Text := IntToStr(0);
      EdtTax.Text := DBEdtTax.Text;
      if DBEdtExcludeTax.Text <> '' then begin
        DBEdtExcludeTax.Text := DBEdtSubTotal.Text;
        EdtSubTotal.Text
          := FormatFloat('#,##0', StrToInt(DBEdtSubTotal.Text));
      end;
    end;
  end;
end;

procedure TFrmAddDetail.DBLCBTaxTypeExit(Sender: TObject);
begin
  DBEdtTaxTypeID.Text := VarToStr(DBLCBTaxType.KeyValue);

  if (Not VarIsNull(DBLCBTaxType.KeyValue)) And (EdtExcludeTax.Text <> '') then begin
    EdtAmount.TabStop  := False;
    EdtAmount.ReadOnly := True;
    if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 1)
          Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 2) then begin
      EdtExcludeTax.TabStop  := True;
      EdtExcludeTax.ReadOnly := False;
      EdtTax.TabStop         := True;
      EdtTax.ReadOnly        := False;

      EdtTax.Text :=
        FormatFloat('#,##0', Round(StrToInt(VarToStr(GetExcludeTax)) * FTaxRate));
    end else if ((StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 3)
      Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 4))
      And (EdtSubTotal.Text <> '') then begin
        EdtExcludeTax.TabStop  := False;
        EdtExcludeTax.ReadOnly := True;
        EdtTax.TabStop         := False;
        EdtTax.ReadOnly        := True;

        CalcInclusiveTax;
    end else if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 5) then begin
      // Tax Free
      EdtExcludeTax.TabStop  := False;
      EdtExcludeTax.ReadOnly := True;
      EdtTax.TabStop         := False;
      EdtTax.ReadOnly        := True;

      DBEdtTax.Text := IntToStr(0);
      EdtTax.Text := DBEdtTax.Text;
      if (DBEdtExcludeTax.Text <> '')
        And (StrToInt(DBEdtExcludeTax.Text) <> 0) then begin
        DBEdtExcludeTax.Text := DBEdtSubTotal.Text;
        EdtSubTotal.Text
          := FormatFloat('#,##0', StrToInt(DBEdtSubTotal.Text));
      end else begin
        DBEdtExcludeTax.Text := IntToStr(0);
        EdtSubTotal.Text
          := FormatFloat('#,##0', 0);
      end;
    end;
  end;
end;

procedure TFrmAddDetail.EdtQuantityExit(Sender: TObject);
begin
  DBEdtQuantity.Text := StringReplace(EdtQuantity.Text, ',', '', [rfReplaceAll]);
  SetQuantity(DBEdtQuantity.Text);

  if VarToStr(GetQuantity) <> '' then begin
    EdtQuantity.Text := FormatFloat('#,##0', GetQuantity);
  end else begin
    EdtQuantity.Text := FormatFloat('#,##0', 0);
  end;
  if (DBEdtExcludeTax.Text <> '')
    And (StrToInt(DBEdtExcludeTax.Text) <> 0)
    And (Not VarIsNull(GetQuantity))
    And (VarToStr(GetQuantity) <> '')
    And (StrToInt(VarToStr(GetQuantity)) > 0) then begin
      SetExcludeTax(AQu.FieldByName('EXCLUDE_TAX').AsVariant);
      EdtAmount.Text
        := FormatFloat(
          '#,##0.000',
          StrToInt(VarToStr(GetExcludeTax)) / StrToInt(VarToStr(GetQuantity)));
  end else begin
    EdtAmount.Text := FormatFloat('#,##0.000', 0);
  end;
end;

procedure TFrmAddDetail.EdtAmountChange(Sender: TObject);
begin
  SetAmount(EdtAmount.Text);
end;

procedure TFrmAddDetail.EdtExcludeTaxExit(Sender: TObject);
begin
  FTaxRate := AQuTaxType.FieldByName('TAX_RATE').AsInteger / 100;

  DBEdtExcludeTax.Text := StringReplace(EdtExcludeTax.Text, ',', '', [rfReplaceAll]);

  if DBEdtExcludeTax.Text <> '' then begin
    SetExcludeTax(DBEdtExcludeTax.Text);
  end else begin
    SetExcludeTax(0);
  end;

  if ((StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 1)
    Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 2))
    And (Not VarIsNull(GetExcludeTax))
    And (VarToStr(GetExcludeTax) <> '')
    And (StrToInt(VarToStr(GetExcludeTax)) <> 0)
    And (Not VarIsNull(GetQuantity))
    And (VarToStr(GetQuantity) <> '')
    And (StrToInt(VarToStr(GetQuantity)) > 0) then begin
      EdtAmount.Text
        := FormatFloat(
          '#,##0.000',
          StrToInt(VarToStr(GetExcludeTax)) /
          StrToInt(VarToStr(GetQuantity)));
      DBEdtTax.Text
        := IntToStr(Round(StrToInt(VarToStr(GetExcludeTax)) * FTaxRate));
      EdtTax.Text        := FormatFloat('#,##0', StrToInt(DBEdtTax.Text));
      DBEdtSubTotal.Text := IntToStr(StrToInt(DBEdtExcludeTax.Text) + StrToInt(DBEdtTax.Text));
      EdtSubTotal.Text   := FormatFloat('#,##0', StrToInt(DBEdtSubTotal.Text));
  end else begin
    EdtAmount.Text     := FormatFloat('#,##0.000', 0);
    DBEdtTax.Text      := IntToStr(0);
    EdtTax.Text        := FormatFloat('#,##0', StrToInt(DBEdtTax.Text));
    DBEdtSubTotal.Text := IntToStr(0);
    EdtSubTotal.Text   := FormatFloat('#,##0', StrToInt(DBEdtSubTotal.Text));
  end;
end;

procedure TFrmAddDetail.EdtTaxChange(Sender: TObject);
begin
  if (EdtTax.Text <> '')
    And (StrToInt(StringReplace(EdtTax.Text, ',', '', [rfReplaceAll])) > 0) then begin
    DBEdtTax.Text := StringReplace(EdtTax.Text, ',', '', [rfReplaceAll]);
  end else begin
    DBEdtTax.Text := '';
  end;
  SetTax(DBEdtTax.Text);
end;

procedure TFrmAddDetail.EdtTaxExit(Sender: TObject);
begin
  if (Not VarIsNull(GetExcludeTax))
    And (VarToStr(GetExcludeTax) <> '')
    And (Not VarIsNull(GetTax))
    And (VarToStr(GetTax) <> '') then begin
      EdtSubTotal.Text := FormatFloat('#,##0', StrToInt(VarToStr(GetExcludeTax)) + StrToInt(VarToStr(GetTax)));
  end;
end;

procedure TFrmAddDetail.EdtSubTotalChange(Sender: TObject);
begin
  if (EdtSubTotal.Text <> '-') then begin
    if (EdtSubTotal.Text <> '')
      And (StrToInt(StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll])) <> 0) then begin
      DBEdtSubTotal.Text := StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll]);
    end else begin
      DBEdtQuantity.Text   := '';
      DBEdtExcludeTax.Text := '';
      DBEdtTax.Text        := '';
      DBEdtSubTotal.Text   := '';
    end;
  end;
end;

procedure TFrmAddDetail.EdtSubTotalExit(Sender: TObject);
begin
  if StrToInt(StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll])) <> 0 then begin
    DBEdtSubTotal.Text := StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll]);
  end else begin
    DBEdtSubTotal.Text := '';
  end;

  if (DBEdtSubTotal.Text <> '')
    And (StrToInt(DBEdtSubTotal.Text) > 0) then begin
    SetSubTotal(DBEdtSubTotal.Text);
  end else begin
    SetSubTotal(0);
  end;

  if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 1)
    Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 2) then begin
    if GetSubTotal > 0 then begin
      EdtSubTotal.Text := FormatFloat('#,##0', GetSubTotal);
    end else begin
      EdtQuantity.Text   := '';
      EdtExcludeTax.Text := '';
      EdtTax.Text        := '';
      EdtSubTotal.Text   := '';
    end;
  end else if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 3)
    Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 4) then begin
    if GetSubTotal > 0 then begin
      CalcInclusiveTax;
    end else begin
      EdtQuantity.Text   := '';
      EdtExcludeTax.Text := '';
      EdtTax.Text        := '';
      EdtSubTotal.Text   := '';
    end;
  end else if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 5) then begin
    // Tax Free
    DBEdtTax.Text := IntToStr(0);
    EdtTax.Text := DBEdtTax.Text;
    if DBEdtSubTotal.Text <> '' then begin
      EdtSubTotal.Text
        := FormatFloat('#,##0', StrToInt(DBEdtSubTotal.Text));
      DBEdtExcludeTax.Text := DBEdtSubTotal.Text;
      SetExcludeTax(DBEdtExcludeTax.Text);
      EdtExcludeTax.Text   := FormatFloat('#,##0', GetExcludeTax);

      if (Not VarIsNull(GetExcludeTax))
          And (VarToStr(GetExcludeTax) <> '')
          And (StrToInt(VarToStr(GetExcludeTax)) <> 0)
          And (Not VarIsNull(GetQuantity))
          And (VarToStr(GetQuantity) <> '')
          And (StrToInt(VarToStr(GetQuantity)) <> 0) then begin
        EdtAmount.Text
          := FormatFloat('#,##0.000',
            StrToInt(VarToStr(GetExcludeTax)) /
            StrToInt(VarToStr(GetQuantity)));
      end else begin
        EdtAmount.Text   := FormatFloat('#,##0.000', 0);
      end;
    end else begin
      EdtQuantity.Text   := '';
      EdtExcludeTax.Text := '';
      EdtTax.Text        := '';
      EdtSubTotal.Text   := '';
    end;
  end else begin
    EdtQuantity.Text   := '';
    EdtExcludeTax.Text := '';
    EdtTax.Text        := '';
    EdtSubTotal.Text   := '';
  end;
end;

procedure TFrmAddDetail.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ATr.Rollback;

  CloseTransactions;

  // Go back to the screen
  with FrmTopMenu.Defs do begin
    if GetGoBack then begin
      if GetAddDetail = 0 then begin
        FrmManageDetails             := TFrmManageDetails.Create(Application);
        FrmManageDetails.Visible     := True;
      end else if GetAddDetail = 1 then begin
        FrmEditDetailsHeader         := TFrmEditDetailsHeader.Create(Application);
        FrmEditDetailsHeader.Visible := True;
      end else if GetAddDetail = 2 then begin
        FrmEditDetailsHeader         := TFrmEditDetailsHeader.Create(Application);
        FrmEditDetailsHeader.Visible := True;
      end;
    end;

    SetAddDetail(0);
  end;

  CloseAction                  := caFree;
  FrmAddDetail                 := nil;
end;

procedure TFrmAddDetail.FormShow(Sender: TObject);
begin
  FrmAddDetail.Width := 737;

  SetGoBack(True);

  FrmAddDetail.Color      := RGB(112, 168, 175);
  PnlEntryMaker.Color     := RGB( 72, 122, 129);
  PnlEntryBrandName.Color := RGB( 72, 122, 129);
  PnlEntryUnit.Color      := RGB( 72, 122, 129);
  PnlCancel.Color         := RGB( 72, 122, 129);
  PnlCommit.Color         := RGB( 72, 122, 129);
  PnlGoBack.Color         := RGB( 72, 122, 129);

  with FrmTopMenu.Defs do begin
    if Not VarIsNull(GetMakerID) then begin
      OpenSelQuAndSetVal(ACnMaker, ADSMaker, ATrMaker, AQuMaker,
      DBLCBMaker, DBEdtMakerID, SQL_20130002, GetMakerID);
    end else begin
      OpenSelQuAndSetVal(ACnMaker, ADSMaker, ATrMaker, AQuMaker,
      DBLCBMaker, DBEdtMakerID, SQL_20130002, 0);
      DBLCBMaker.KeyValue := -1;
      DBEdtMakerID.Text   := '';
    end;

    if Not VarIsNull(GetBrandNameID) then begin
      OpenSelQuBrandAndSetVal(ACnBrand, ADSBrand, ATrBrand, AQuBrand,
      DBLCBBrandName, DBEdtBrandNameID, SQL_20140001, GetBrandNameID);
    end else begin
      OpenSelQuBrandAndSetVal(ACnBrand, ADSBrand, ATrBrand, AQuBrand,
      DBLCBBrandName, DBEdtBrandNameID, SQL_20140001, 0);
      DBLCBBrandName.KeyValue := -1;
      DBEdtBrandNameID.Text   := '';
    end;

    DBEdtExpKey1.Text := GetExpKey1;
    SelectExp2(ACnExp2, ADSExp2, ATrExp2, AQuExp2);
    if (Not VarIsNull(GetExpKey2))
      And (VarToStr(GetExpKey2) <> '')
      And (StrToInt(VarToStr(GetExpKey2)) > 0) then begin
        DBEdtExpKey2.Text := VarToStr(GetExpKey2);
        DBLCBExp2.KeyValue := GetExpKey2;
    end else begin
      DBLCBExp2.KeyValue := -1;
      DBEdtExpKey2.Text  := '';
    end;

    SelectExp3(ACnExp3, ADSExp3, ATrExp3, AQuExp3);
    if (Not VarIsNull(GetExpKey3))
      And (VarToStr(GetExpKey3) <> '')
      And (StrToInt(VarToStr(GetExpKey3)) > 0) then begin
        DBEdtExpKey3.Text := VarToStr(GetExpKey3);
        DBLCBExp3.KeyValue := GetExpKey3;
    end else begin
      DBLCBExp3.KeyValue := -1;
      DBEdtExpKey3.Text  := '';
    end;

    if Not VarIsNull(GetUnitID) then begin
      OpenSelQuUnitAndSetVal(ACnUnit, ADSUnit, ATrUnit, AQuUnit,
      DBLCBUnit, DBEdtUnitID, SQL_20150001, GetUnitID);
    end else begin
      OpenSelQuUnitAndSetVal(ACnUnit, ADSUnit, ATrUnit, AQuUnit,
      DBLCBUnit, DBEdtUnitID, SQL_20150001, 0);
      DBLCBUnit.KeyValue := -1;
      DBEdtUnitID.Text   := '';
    end;

    if Not VarIsNull(GetTaxTypeID) then begin
      OpenSelQuTaxTypeAndSetVal(ACnTaxType, ADSTaxType, ATrTaxType, AQuTaxType,
      DBLCBTaxType, DBEdtTaxTypeID, SQL_20120004, GetTaxTypeID);
    end else begin
      OpenSelQuTaxTypeAndSetVal(ACnTaxType, ADSTaxType, ATrTaxType, AQuTaxType,
      DBLCBTaxType, DBEdtTaxTypeID, SQL_20120004, 0);
      DBLCBTaxType.KeyValue := -1;
      DBEdtTaxTypeID.Text   := '';
    end;

    if GetQuantity > 0 then begin
        DBEdtQuantity.Text := IntToStr(GetQuantity);
        EdtQuantity.Text   := FormatFloat('#,##0', GetQuantity);
    end else begin
      EdtQuantity.Text     := FormatFloat('#,##0', 0);
    end;

    if GetExcludeTax <> 0 then begin
        DBEdtExcludeTax.Text := IntToStr(GetExcludeTax);
        EdtExcludeTax.Text   := FormatFloat('#,##0', GetExcludeTax);
    end else begin
      EdtExcludeTax.Text     := FormatFloat('#,##0', 0);
    end;

    if (GetExcludeTax <> 0)
        And (GetQuantity > 0) then begin
      EdtAmount.Text := FormatFloat('#,##0.000', GetExcludeTax / GetQuantity);
    end else begin
      EdtAmount.Text := FormatFloat('#,##0.000', 0);
    end;

    if GetTax > 0 then begin
        DBEdtTax.Text := IntToStr(GetTax);
        EdtTax.Text   := FormatFloat('#,##0', GetTax);
    end else begin
      EdtTax.Text     := FormatFloat('#,##0', 0);
    end;

    if GetSubTotal > 0 then begin
        DBEdtSubTotal.Text := IntToStr(GetSubTotal);
        EdtSubTotal.Text   := FormatFloat('#,##0', GetSubTotal);
    end else begin
      EdtSubTotal.Text     := FormatFloat('#,##0', 0);
    end;

    DBEdtUserID.Text   := GetUID.ToString;
    DBEdtHeaderID.Text := GetHID.ToString;

    SetEntryMaker(0);
    SetEntryAccount(0);
    SetEntryUnit(0);
  end;

  { Debug }
  //FrmAddDetail.Width := 1272;
end;

end.

