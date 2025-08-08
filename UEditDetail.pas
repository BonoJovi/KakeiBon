unit UEditDetail;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, DBCtrls, LCLIntf, ActnList,
  DBDateTimePicker;

type

  { TFrmEditDetail }

  TFrmEditDetail = class(TForm)
    ACn               : TSQLite3Connection;
    ADS               : TDataSource;
    AQu               : TSQLQuery;
    ATr               : TSQLTransaction;
    ACnNextID         : TSQLite3Connection;
    ADSNextID         : TDataSource;
    AQuNextID         : TSQLQuery;
    ATrNextID         : TSQLTransaction;
    ACnMaker          : TSQLite3Connection;
    ADSMaker          : TDataSource;
    AQuMaker          : TSQLQuery;
    ATrMaker          : TSQLTransaction;
    ACnBrand          : TSQLite3Connection;
    ADSBrand          : TDataSource;
    AQuBrand          : TSQLQuery;
    ATrBrand          : TSQLTransaction;
    ACnExp2           : TSQLite3Connection;
    ADSExp2           : TDataSource;
    AQuExp2           : TSQLQuery;
    ATrExp2           : TSQLTransaction;
    ACnExp3           : TSQLite3Connection;
    ADSExp3           : TDataSource;
    AQuExp3           : TSQLQuery;
    ATrExp3           : TSQLTransaction;
    ACnUnit           : TSQLite3Connection;
    ADSUnit           : TDataSource;
    AQuUnit           : TSQLQuery;
    ATrUnit           : TSQLTransaction;
    ACnTaxType        : TSQLite3Connection;
    ADSTaxType        : TDataSource;
    AQuTaxType        : TSQLQuery;
    ATrTaxType        : TSQLTransaction;
    { ActionLists }
    ActionList        : TActionList;
    ActEntryMaker     : TAction;
    ActEntryBrandName : TAction;
    ActEntryUnit      : TAction;
    ActCancel         : TAction;
    ActSave         : TAction;
    ActQuit           : TAction;
    { Screen controls }
    BtnEntryMaker     : TButton;
    BtnEntryBrandName : TButton;
    BtnEntryUnit      : TButton;
    BtnCancel         : TButton;
    BtnCommit         : TButton;
    BtnGoBack         : TButton;
    DBDTPEntryDT      : TDBDateTimePicker;
    DBDTPUpdateDT     : TDBDateTimePicker;
    DBEdtExcludeTax   : TDBEdit;
    DBEdtBrandNameID  : TDBEdit;
    DBEdtDetailID     : TDBEdit;
    DBEdtExpKey1      : TDBEdit;
    DBEdtExpKey2      : TDBEdit;
    DBEdtExpKey3      : TDBEdit;
    DBEdtHeaderID     : TDBEdit;
    DBEdtMakerID      : TDBEdit;
    DBEdtQuantity     : TDBEdit;
    DBEdtSubTotal     : TDBEdit;
    DBEdtTax          : TDBEdit;
    DBEdtTaxTypeID    : TDBEdit;
    DBEdtUnitID       : TDBEdit;
    DBEdtUserID       : TDBEdit;
    DBLCBExp2         : TDBLookupComboBox;
    DBLCBExp3         : TDBLookupComboBox;
    DBLCBBrandName    : TDBLookupComboBox;
    DBLCBMaker        : TDBLookupComboBox;
    DBLCBUnit         : TDBLookupComboBox;
    DBLCBTaxType      : TDBLookupComboBox;
    EdtAmount         : TEdit;
    EdtExcludeTax     : TEdit;
    EdtQuantity       : TEdit;
    EdtTax            : TEdit;
    EdtSubTotal       : TEdit;
    LblBrandName1     : TLabel;
    LblBrandName2     : TLabel;
    LblExcludeTax1    : TLabel;
    LblExcludeTax2    : TLabel;
    LblExcludeTax3    : TLabel;
    LblExcludeTax4    : TLabel;
    LblExp1           : TLabel;
    LblExp2           : TLabel;
    LblMaker          : TLabel;
    LblAmount1        : TLabel;
    LblAmount2        : TLabel;
    LblQuantity1      : TLabel;
    LblQuantity2      : TLabel;
    LblSubTotal1      : TLabel;
    LblSubTotal2      : TLabel;
    LblTax2           : TLabel;
    LblTaxType1       : TLabel;
    LblTaxType2       : TLabel;
    LblTaxType3       : TLabel;
    LblTax1           : TLabel;
    LblUnit1          : TLabel;
    LblUnit2          : TLabel;
    PnlSeparator      : TPanel;
    PnlCancel         : TPanel;
    PnlCommit         : TPanel;
    PnlGoBack         : TPanel;
    PnlEntryMaker     : TPanel;
    PnlEntryUnit      : TPanel;
    PnlEntryBrandName : TPanel;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
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
    procedure SetDatabaseNames;
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
  FrmEditDetail: TFrmEditDetail;

implementation
uses
  UConsts, UDefs, UDBAccess, UTopMenu, UManageDetails, UAddDetailsHeader,
  UEditDetailsHeader, UEntryMaker, UEntryBrandName, UEntryUnit;

{$R *.lfm}

{ TFrmEditDetail }

procedure TFrmEditDetail.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn       );
    SetDatabaseName(ACnNextID );
    SetDatabaseName(ACnMaker  );
    SetDatabaseName(ACnBrand  );
    SetDatabaseName(ACnExp2   );
    SetDatabaseName(ACnExp3   );
    SetDatabaseName(ACnUnit   );
    SetDatabaseName(ACnTaxType);
  end;
end;

procedure TFrmEditDetail.CloseTransactions;
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

procedure TFrmEditDetail.BackupValues;
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
      AQuTaxType.First;
      while AQuTaxType.FieldByName('TAX_TYPE_ID').AsInteger <> StrToInt(VarToStr(DBLCBTaxType.KeyValue)) do begin
        if AQuTaxType.EOF then begin
          break;
        end;
        AQuTaxType.Next;
      end;
      SetTaxRateID(AQuTaxType.FieldByName('TAX_RATE_ID').AsVariant);
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

procedure TFrmEditDetail.CalcInclusiveTax;
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

procedure TFrmEditDetail.ClearInputFields;
var
  LNextDetailID : Integer;
begin
  with FrmTopMenu.Defs do begin
    DBEdtUserID.Text        := IntToStr(GetUID);
    DBEdtHeaderID.Text      := IntToStr(GetHID);

    CloseConn(ACnNextID, ATrNextID);
    SetDatabaseNames;

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

    DBEdtDetailID.Text               := IntToStr(LNextDetailID);
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

procedure TFrmEditDetail.ProcCancel;
begin
  if FInsert then begin
    FInsert := False;
  end;
  ATr.Rollback;

  ClearInputFields;

  DBLCBMaker.SetFocus;
end;

procedure TFrmEditDetail.ProcCommit;
var
  LNextDetailID : Integer = 0;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        if (VarIsNull(GetDID))
            Or (VarToStr(GetDID) = '')
            Or (StrToInt(VarToStr(GetDID)) = 0)then begin
          CloseConn(ACnNextID, ATrNextID);

          OpenSelectQuery(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20120003);
          LNextDetailID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

          CloseConn(ACnNextID, ATrNextID);

          DBEdtDetailID.Text := IntToStr(LNextDetailID);
          SetDID(LNextDetailID);
        end;

        with AQu do begin
          SQL.Text := SQL_20120007;
          with Params do begin
            ParamByName('pUserID'     ).AsInteger   := GetUID;
            ParamByName('pHeaderID'   ).AsInteger   := GetHID;
            ParamByName('pDetailID'   ).AsInteger   := StrToInt(VarToStr(GetDID));
            ParamByName('pExpKey1'    ).AsInteger   := StrToInt(VarToStr(GetExpKey1));
            if (Not VarIsNull(GetExpKey2))
              And (VarToStr(GetExpKey2) <> '')
              And (StrToInt(VarToStr(GetExpKey2)) > 0) then begin
              ParamByName('pExpKey2'    ).AsInteger   := StrToInt(VarToStr(GetExpKey2));
            end else begin
              ParamByName('pExpKey2'    ).AsInteger   := 0;
            end;
            if (Not VarIsNull(GetExpKey3))
              And (VarToStr(GetExpKey3) <> '')
              And (StrToInt(VarToStr(GetExpKey3)) > 0) then begin
              ParamByName('pExpKey3'    ).AsInteger   := StrToInt(VarToStr(GetExpKey3));
            end else begin
              ParamByName('pExpKey3'    ).AsInteger   := 0;
            end;
            ParamByName('pMakerID'    ).AsInteger   := StrToInt(VarToStr(GetMakerID));
            ParamByName('pBrandNameID').AsInteger   := StrToInt(VarToStr(GetBrandNameID));
            ParamByName('pUnitID'     ).AsInteger   := StrToInt(VarToStr(GetUnitID));
            ParamByName('pTaxTypeID'  ).AsInteger   := StrToInt(VarToStr(GetTaxTypeID));
            ParamByName('pTaxRateID'  ).AsInteger   := StrToInt(VarToStr(GetTaxRateID));
            ParamByName('pQuantity'   ).AsInteger   := GetQuantity;
            ParamByName('pExcludeTax' ).AsInteger   := GetExcludeTax;
            ParamByName('pTax'        ).AsInteger   := GetTax;
            ParamByName('pSubTotal'   ).AsInteger   := GetSubTotal;
            ParamByName('pEntryDT'    ).AsDateTime  := Now;
            ParamByName('pUpdateDT'   ).AsDateTime  := Now;
          end;

          CloseTransactions;
          SetDatabaseNames;

          ExecSQL;
          ATr.Commit;
        end;

        // Clear input values
        with FrmTopMenu.Defs do begin
          CloseTransactions;
          SetDatabaseNames;

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

procedure TFrmEditDetail.ProcInsert;
begin
  if Not FInsert then begin
    with AQu do begin
      Edit;
      if AQu.RecordCount > 0 then begin;
        Insert;
      end;
      FInsert := True;
    end;

    DBLCBMaker.SetFocus;
  end;
end;

procedure TFrmEditDetail.ProcEntryBrandName;
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    SetEntryMaker(999);
    SetEntryBrandName(2);

    FrmEntryBrandName := TFrmEntryBrandName.Create(Application);
    OpenForm(Self, FrmEntryBrandName);
  end;
end;

procedure TFrmEditDetail.ProcEntryMaker;
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    SetEntryMaker(2);

    FrmEntryMaker := TFrmEntryMaker.Create(Application);
    OpenForm(Self, FrmEntryMaker);
  end;
end;

procedure TFrmEditDetail.ProcEntryUnit;
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    SetEntryUnit(2);

    FrmEntryUnit := TFrmEntryUnit.Create(Application);
    OpenForm(Self, FrmEntryUnit);
  end;
end;

function TFrmEditDetail.GetGoBack: Boolean;
begin
  Result := FGoBack;
end;

procedure TFrmEditDetail.SetGoBack(GoBack: boolean);
begin
  FGoBack := GoBack;
end;

function TFrmEditDetail.GetQuantity: Variant;
begin
  Result := FQuantity;
end;

procedure TFrmEditDetail.SetQuantity(Quantity: Variant);
begin
  FQuantity := Quantity;
end;

function TFrmEditDetail.GetAmount: Variant;
begin
  Result := FAmount;
end;

procedure TFrmEditDetail.SetAmount(Amount: Variant);
begin
  FAmount := Amount;
end;

function TFrmEditDetail.GetExcludeTax: Variant;
begin
  Result := FExcludeTax;
end;

procedure TFrmEditDetail.SetExcludeTax(ExcludeTax: Variant);
begin
  FExcludeTax := ExcludeTax;
end;

function TFrmEditDetail.GetTax: Variant;
begin
  Result := FTax;
end;

procedure TFrmEditDetail.SetTax(Tax: Variant);
begin
  FTax := Tax;
end;

function TFrmEditDetail.GetSubTotal: Variant;
begin
  Result := FSubTotal;
end;

procedure TFrmEditDetail.SetSubTotal(SubTotal: Variant);
begin
  FSubTotal := SubTotal;
end;

procedure TFrmEditDetail.SelectExp2(
  var Cn2: TSQLite3Connection; var DS2: TDataSource;
  var Tr2: TSQLTransaction; var Qu2: TSQLQuery);
begin
  try
    with FrmTopMenu.Defs do begin
      with Qu2 do begin
        //OpenConn(Cn2, DS2, Tr2, Qu2);

        SQL.Text     := SQL_20120001;
        with Params do begin
          ParamByName('pUserID').AsInteger  := GetUID;
          ParamByName('pExpKey1').AsInteger := StrToInt(VarToStr(GetExpKey1));
        end;
        Tr2.StartTransaction;
        Open;
      end;
    end;
  finally
  end;
end;

procedure TFrmEditDetail.SelectExp3(
  var Cn3: TSQLite3Connection; var DS3: TDataSource;
  var Tr3: TSQLTransaction; var Qu3: TSQLQuery);
begin
  try
    with FrmTopMenu.Defs do begin
      with Qu3 do begin
        //OpenConn(Cn3, DS3, Tr3, Qu3);

        SQL.Text     := SQL_20120002;
        with Params do begin
          ParamByName('pUserID').AsInteger  := GetUID;
          ParamByName('pExpKey1').AsInteger := StrToInt(VarToStr(GetExpKey1));
          if Not VarIsNull(DBLCBExp2.KeyValue) then begin
            ParamByName('pExpKey2').AsInteger := StrToInt(VarToStr(DBLCBExp2.KeyValue));

            Tr3.Active        := True;
            Open;
          end;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmEditDetail.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmEditDetail.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcCommit;
  ProcInsert;
  ClearInputFields;
end;

procedure TFrmEditDetail.ActEntryBrandNameExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryBrandName;
end;

procedure TFrmEditDetail.ActEntryMakerExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryMaker;
end;

procedure TFrmEditDetail.ActEntryUnitExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryUnit;
end;

procedure TFrmEditDetail.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditDetail.DBLCBMakerChange(Sender: TObject);
begin
  if Not VarIsNull(DBLCBMaker.KeyValue) then begin
    if VarToStr(DBLCBMaker.KeyValue) <> DBEdtMakerID.Text then begin
      DBEdtMakerID.Text := DBLCBMaker.KeyValue;
      with FrmTopMenu.Defs do begin
        SetMakerID(DBLCBMaker.KeyValue);

        // Set BrandName ComboBox
        OpenSelQuBrandAndSetVal(ACnBrand, ADSBrand, ATrBrand, AQuBrand,
        DBLCBBrandName, DBEdtBrandNameID, SQL_20140001, StrToInt(VarToStr(GetBrandNameID)));
      end;
    end;
  end;
end;

procedure TFrmEditDetail.DBLCBBrandNameChange(Sender: TObject);
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

procedure TFrmEditDetail.DBLCBExp2Change(Sender: TObject);
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

procedure TFrmEditDetail.DBLCBExp3Change(Sender: TObject);
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

procedure TFrmEditDetail.DBLCBUnitChange(Sender: TObject);
begin
  DBEdtUnitID.Text := VarToStr(DBLCBUnit.KeyValue);
end;

procedure TFrmEditDetail.DBLCBTaxTypeChange(Sender: TObject);
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

procedure TFrmEditDetail.DBLCBTaxTypeExit(Sender: TObject);
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
          := FormatFloat('#,##0', StrToInt(DBEdtSubTotal.Text));
      end;
    end;
  end;
end;

procedure TFrmEditDetail.EdtQuantityExit(Sender: TObject);
begin
  DBEdtQuantity.Text := StringReplace(EdtQuantity.Text, ',', '', [rfReplaceAll]);
  SetQuantity(DBEdtQuantity.Text);

  if VarToStr(GetQuantity) <> '' then begin
    EdtQuantity.Text := FormatFloat('#,##0', StrToInt(VarToStr(GetQuantity)));
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

procedure TFrmEditDetail.EdtAmountChange(Sender: TObject);
begin
  SetAmount(EdtAmount.Text);
end;

procedure TFrmEditDetail.EdtExcludeTaxExit(Sender: TObject);
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

procedure TFrmEditDetail.EdtTaxChange(Sender: TObject);
begin
  if (EdtTax.Text <> '')
    And (StrToInt(StringReplace(EdtTax.Text, ',', '', [rfReplaceAll])) > 0) then begin
    DBEdtTax.Text := StringReplace(EdtTax.Text, ',', '', [rfReplaceAll]);
  end else begin
    DBEdtTax.Text := IntToStr(0);
  end;
  SetTax(DBEdtTax.Text);
end;

procedure TFrmEditDetail.EdtTaxExit(Sender: TObject);
begin
  if (Not VarIsNull(GetExcludeTax))
    And (VarToStr(GetExcludeTax) <> '')
    And (Not VarIsNull(GetTax))
    And (VarToStr(GetTax) <> '') then begin
      EdtSubTotal.Text := FormatFloat('#,##0', StrToInt(VarToStr(GetExcludeTax)) + StrToInt(VarToStr(GetTax)));
  end;
end;

procedure TFrmEditDetail.EdtSubTotalChange(Sender: TObject);
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

procedure TFrmEditDetail.EdtSubTotalExit(Sender: TObject);
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
    if StrToInt(VarToStr(GetSubTotal)) > 0 then begin
      EdtSubTotal.Text := FormatFloat('#,##0', StrToInt(VarToStr(GetSubTotal)));
    end else begin
      EdtQuantity.Text   := '';
      EdtExcludeTax.Text := '';
      EdtTax.Text        := '';
      EdtSubTotal.Text   := '';
    end;
  end else if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 3)
    Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 4) then begin
    if StrToInt(VarToStr(GetSubTotal)) > 0 then begin
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
      EdtExcludeTax.Text   := FormatFloat('#,##0', StrToInt(VarToStr(GetExcludeTax)));

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

procedure TFrmEditDetail.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ATr.Rollback;

  CloseTransactions;

  // Go back to the screen
  with FrmTopMenu.Defs do begin
    if GetGoBack then begin
      if GetEditDetail = 0 then begin
        FrmManageDetails := TFrmManageDetails.Create(Application);
        FrmManageDetails.Visible := True;
      end else if GetEditDetail = 1 then begin
        FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
        FrmAddDetailsHeader.Visible := True;
      end else if GetEditDetail = 2 then begin
        FrmEditDetailsHeader := TFrmEditDetailsHeader.Create(Application);
        FrmEditDetailsHeader.Visible := True;
      end;
    end;

    SetEditDetail(0);
  end;

  CloseAction                 := caFree;
  FrmEditDetail              := nil;
end;

procedure TFrmEditDetail.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  SetGoBack(True);
end;

procedure TFrmEditDetail.FormShow(Sender: TObject);
begin
  FrmEditDetail.Width := 737;

  FrmEditDetail.Color     := RGB(112, 168, 175);
  PnlEntryMaker.Color     := RGB( 72, 122, 129);
  PnlEntryBrandName.Color := RGB( 72, 122, 129);
  PnlEntryUnit.Color      := RGB( 72, 122, 129);
  PnlCancel.Color         := RGB( 72, 122, 129);
  PnlCommit.Color         := RGB( 72, 122, 129);
  PnlGoBack.Color         := RGB( 72, 122, 129);

  with FrmTopMenu.Defs do begin
    CloseTransactions;
    SetDatabaseNames;

    with AQu do begin
      if Active = False then
      begin
        SQL.Text := SQL_20120006;
        with Params do begin
          ParamByName('pUserID').AsInteger   := GetUID;
          ParamByName('pHeaderID').AsInteger := GetHID;
          ParamByName('pDetailID').AsInteger := StrToInt(VarToStr(GetDID));
        end;
        Open;
      end;
    end;
    if AQu.RecordCount = 0 then begin
      ProcInsert;
    end else begin
      FInsert := False;
    end;
  end;

  with FrmTopMenu.Defs do begin
    SetMakerID(AQu.FieldByName('MAKER_ID').AsVariant);
    OpenSelQuAndSetVal(ACnMaker, ADSMaker, ATrMaker, AQuMaker,
      DBLCBMaker, DBEdtMakerID, SQL_20130002, StrToInt(VarToStr(GetMakerID)));

    SetBrandNameID(AQu.FieldByName('BRAND_NAME_ID').AsVariant);
    OpenSelQuBrandAndSetVal(ACnBrand, ADSBrand, ATrBrand, AQuBrand,
      DBLCBBrandName, DBEdtBrandNameID, SQL_20140001, StrToInt(VarToStr(GetBrandNameID)));

    DBEdtExpKey1.Text := GetExpKey1;

    SetExpKey2(AQu.FieldByName('EXP_KEY2').AsVariant);
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

    SetExpKey3(AQu.FieldByName('EXP_KEY3').AsVariant);
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

    SetUnitID(AQu.FieldByName('UNIT_ID').AsVariant);
    if Not VarIsNull(GetUnitID) then begin
      OpenSelQuUnitAndSetVal(ACnUnit, ADSUnit, ATrUnit, AQuUnit,
      DBLCBUnit, DBEdtUnitID, SQL_20150001, StrToInt(VarToStr(GetUnitID)));
    end else begin
      OpenSelQuUnitAndSetVal(ACnUnit, ADSUnit, ATrUnit, AQuUnit,
      DBLCBUnit, DBEdtUnitID, SQL_20150001, 0);
      DBLCBUnit.KeyValue := -1;
      DBEdtUnitID.Text   := '';
    end;

    SetTaxTypeID(AQu.FieldByName('TAX_TYPE_ID').AsVariant);
    if Not VarIsNull(GetTaxTypeID) then begin
      OpenSelQuTaxTypeAndSetVal(ACnTaxType, ADSTaxType, ATrTaxType, AQuTaxType,
      DBLCBTaxType, DBEdtTaxTypeID, SQL_20120004, StrToInt(VarToStr(GetTaxTypeID)));
    end else begin
      OpenSelQuTaxTypeAndSetVal(ACnTaxType, ADSTaxType, ATrTaxType, AQuTaxType,
      DBLCBTaxType, DBEdtTaxTypeID, SQL_20120004, 0);
      DBLCBTaxType.KeyValue := -1;
      DBEdtTaxTypeID.Text   := '';
    end;

    SetQuantity(AQu.FieldByName('QUANTITY').AsInteger);
    if GetQuantity > 0 then begin
      DBEdtQuantity.Text := IntToStr(GetQuantity);
      EdtQuantity.Text   := FormatFloat('#,##0', GetQuantity);
    end else begin
      DBEdtQuantity.Text := IntToStr(0);
      EdtQuantity.Text   := FormatFloat('#,##0', 0);
    end;

    SetExcludeTax(AQu.FieldByName('EXCLUDE_TAX').AsInteger);
    if GetExcludeTax <> 0 then begin
      DBEdtExcludeTax.Text := IntToStr(GetExcludeTax);
      EdtExcludeTax.Text   := FormatFloat('#,##0', GetExcludeTax);
    end else begin
      DBEdtExcludeTax.Text := IntToStr(0);
      EdtExcludeTax.Text   := FormatFloat('#,##0', 0);
    end;

    if (GetExcludeTax <> 0)
        And (GetQuantity > 0) then begin
      EdtAmount.Text := FormatFloat('#,##0.000', GetExcludeTax / GetQuantity);
    end else begin
      EdtAmount.Text := FormatFloat('#,##0.000', 0);
    end;

    SetTax(AQu.FieldByName('TAX').AsInteger);
    if GetTax <> 0 then begin
      DBEdtTax.Text := IntToStr(GetTax);
      EdtTax.Text   := FormatFloat('#,##0', GetTax);
    end else begin
      DBEdtTax.Text := IntToStr(0);
      EdtTax.Text   := FormatFloat('#,##0', 0);
    end;

    SetSubTotal(AQu.FieldByName('SUB_TOTAL').AsInteger);
    if GetSubTotal <> 0 then begin
      DBEdtSubTotal.Text := IntToStr(GetSubTotal);
      EdtSubTotal.Text   := FormatFloat('#,##0', GetSubTotal);
    end else begin
      DBEdtSubTotal.Text := IntToStr(0);
      EdtSubTotal.Text   := FormatFloat('#,##0', 0);
    end;

    DBEdtUserID.Text   := IntToStr(GetUID);
    DBEdtHeaderID.Text := IntToStr(GetHID);

    SetEntryMaker(0);
    SetEntryAccount(0);
    SetEntryUnit(0);
  end;

  { Debug }
  //FrmEditDetail.Width := 1272;
end;

end.

