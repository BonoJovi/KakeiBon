unit UDefs;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Variants, Controls, Dialogs, StdCtrls, SysUtils, Forms, SQLDB, DB,
  SQLite3Conn, DBCtrls;

type

  { TDefs }

  TDefs = class(TObject)
    function VarToInt(Arg: Variant): Integer;
    procedure SetEnable(var FromAC, ToAC: TDBLookupComboBox;
      StateOfFromAC, StateOfToAC: Boolean);
    procedure ClearPaw(var EdtPaw, EdtPawConfirm: TEdit);
    procedure ClearPawAndUserId(
      var EdtUserId, EdtPaw, EdtPawConfirm: TEdit);
    function MatchRole(Sender: Integer): Boolean;
    procedure OpenForm(Sender, NextForm: TForm);
    procedure OpenSelectQuery(
      var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString);
    procedure OpenSelectQueryByUnit(
      var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString);
    procedure OpenSelectQueryWithUserID(
      var Cn: TSQLite3Connection; var DS: TDataSource;
      var Tr: TSQLTransaction; var Qu: TSQLQuery; SS: AnsiString; aUserID: Integer);
    procedure OpenSelectQueryWithExp1(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; SS: AnsiString; aExpKey1: Integer);
    procedure OpenSelectQueryWithExp1AndExp2(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; SS: AnsiString; aExpKey1, aExpKey2: Integer);
    procedure OpenSelectQueryWithHeaderID(
      var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString; aHeaderID: Integer);
    procedure OpenSelectQueryWithMakerID(
      var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString; aMakerID: Integer);
    procedure OpenSelectQueryWithMakerIDAndBrandNameID(
      var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString; aMakerID, aBrandNameID: Integer);
    procedure UpdateFractionProcQueryWithShopID(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; SS: AnsiString; aShopID: Integer);
    procedure SetDefaultOrderKey2(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; SS: AnsiString; aExpKey1: Integer);
    procedure SetDefaultOrderKey3(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; SS: AnsiString; aExpKey1, aExpKey2: Integer);
    procedure OpenSelQuAndSetNextID(
      var DS: TDataSource; var Qu: TSQLQuery;
      var DBEditObj: TDBEdit; SS: AnsiString);
    procedure OpenSelQuBrandAndSetVal(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
      var DBEditObj: TDBEdit; SS: AnsiString);
    procedure OpenSelQuUnitAndSetVal(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
      var DBEditObj: TDBEdit; SS: AnsiString);
    procedure OpenSelectQueryWithTaxType(
      var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString);
    procedure SetKeyValToDBLCB(
      var DBLCBObj: TDBLookupComboBox;
      var DBEditObj: TDBEdit; KV: Integer);

    { Properties accessor }
    function GetDoExitKakeiBon: Boolean;
    procedure SetDoExitKakeiBon(aDoExitKakeiBon: Boolean);
    function GetChangedUserDef: Boolean;
    procedure SetChangedUserDef(Sender: Boolean);
    function GetInitializedDB: Boolean;
    procedure SetInitializedDB(InitializedDB: Boolean);
    function GetRole: Integer;
    procedure SetRole(RoleNum: Integer);
    function GetShowChildForm: Boolean;
    procedure SetShowChildForm(Sender: Boolean);
    function GetUID: Integer;
    procedure SetUID(UID: Integer);
    function GetUName: String;
    procedure SetUName(UName: String);
    //function GetShopID: Variant;
    //procedure SetShopID(ShopID: Variant);
    function GetShopID: Integer;
    procedure SetShopID(ShopID: Integer = 0);
    function GetAccountID: Integer;
    procedure SetAccountID(AccountID: Integer = 0);
    //function GetExpKey1: Variant;
    //procedure SetExpKey1(ExpKey1: Variant);
    function GetExpKey1: Integer;
    procedure SetExpKey1(const ExpKey1: Integer = 0);
    //function GetExpKey2: Variant;
    //procedure SetExpKey2(ExpKey2: Variant);
    function GetExpKey2: Integer;
    procedure SetExpKey2(const ExpKey2: Integer = 0);
    //function GetExpKey3: Variant;
    //procedure SetExpKey3(ExpKey3: Variant);
    function GetExpKey3: Integer;
    procedure SetExpKey3(const ExpKey3: Integer = 0);
    //function GetFromACID: Variant;
    //procedure SetFromACID(FromACID: Variant);
    function GetFromACID: Integer;
    procedure SetFromACID(const FromACID: Integer = 0);
    //function GetToACID: Variant;
    //procedure SetToACID(ToACID: Variant);
    function GetToACID: Integer;
    procedure SetToACID(const ToACID: Integer = 0);
    function GetHID: Integer;
    procedure SetHID(const HID: Integer = 0);
    function GetHeaderDT: String;
    procedure SetHeaderDT(HeaderDT: String);
    //function GetDID: Variant;
    //procedure SetDID(DID: Variant);
    function GetDID: Integer;
    procedure SetDID(const DID: Integer = 0);
    //function GetBrandNameID: Variant;
    //procedure SetBrandNameID(BrandNameID: Variant);
    function GetBrandNameID: Integer;
    procedure SetBrandNameID(const BrandNameID: Integer = 0);
    function GetBrandName: String;
    procedure SetBrandName(BrandName: String);
    //function GetMakerID: Variant;
    //procedure SetMakerID(MakerID: Variant);
    function GetMakerID: Integer;
    procedure SetMakerID(const MakerID: Integer = 0);
    function GetMakerName: String;
    procedure SetMakerName(MakerName: String);
    function GetEndOfSales: Boolean;
    procedure SetEndOfSales(EndOfSales: Boolean);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    //function GetUnitID: Variant;
    //procedure SetUnitID(UnitID: Variant);
    function GetUnitID: Integer;
    procedure SetUnitID(const UnitID: Integer = 0);
    function GetQuantity: Integer;
    procedure SetQuantity(const Quantity: Integer = 0);
    function GetAmount: Single;
    procedure SetAmount(const Amount: Single = 0.0);
    function GetExcludeTax: Single;
    procedure SetExcludeTax(const ExcludeTax: Single = 0.0);
    function GetTaxTypeID: Integer;
    procedure SetTaxTypeID(const TaxTypeID: Integer = 0);
    function GetTaxRateID: Integer;
    procedure SetTaxRateID(const TaxRateID: Integer = 0);
    function GetTax: Single;
    procedure SetTax(const Tax: Single = 0.0);
    function GetSubTotal: Single;
    procedure SetSubTotal(const SubTotal: Single = 0.0);
    function GetTotalAmount: Integer;
    procedure SetTotalAmount(const TotalAmount: Integer = 0);
    function GetEntryShop: Integer;
    procedure SetEntryShop(const EntryShop: Integer = 0);
    function GetEntryAccount: Integer;
    procedure SetEntryAccount(const EntryAccount: Integer = 0);
    function GetAddDetail: Integer;
    procedure SetAddDetail(const AddDetail: Integer = 0);
    function GetEditDetail: Integer;
    procedure SetEditDetail(const EditDetail: Integer = 0);
    function GetEntryBrandName: Integer;
    procedure SetEntryBrandName(const EntryBrandName: Integer = 0);
    function GetEntryMaker: Integer;
    procedure SetEntryMaker(const EntryMaker: Integer = 0);
    function GetEntryUnit: Integer;
    procedure SetEntryUnit(const EntryUnit: Integer = 0);
    function GetFS: TFormatSettings;
    procedure SetFS(FS: TFormatSettings);

    { Properties }
    property DoExitKakeiBon : Boolean read GetDoExitKakeiBon write SetDoExitKakeiBon default False;
    property ChangedUserDef : Boolean read GetChangedUserDef write SetChangedUserDef;
    property InitializedDB : Boolean read GetInitializedDB write SetInitializedDB;
    property Role : Integer read GetRole write SetRole;
    property ShowChildForm : Boolean read GetShowChildForm write SetShowChildForm;
    property UID : Integer read GetUID write SetUID;
    property UName : String read GetUName write SetUName;
    property ShopID : Integer read GetShopID write SetShopID;
    property AccountID : Integer read GetAccountID write SetAccountID;
    property ExpKey1 : Integer read GetExpKey1 write SetExpKey1;
    property ExpKey2 : Integer read GetExpKey2 write SetExpKey2;
    property ExpKey3 : Integer read GetExpKey3 write SetExpKey3;
    property FromACID : Integer read GetFromACID write SetFromACID;
    property ToACID : Integer read GetToACID write SetToACID;
    property HID : Integer read GetHID write SetHID;
    property HeaderDT : String read GetHeaderDT write SetHeaderDT;
    property DID : Integer read GetDID write SetDID;
    property BrandNameID : Integer read GetBrandNameID write SetBrandNameID;
    property BrandName : String read GetBrandName write SetBrandName;
    property MakerID : Integer read GetMakerID write SetMakerID;
    property MakerName : String read GetMakerName write SetMakerName;
    property EndOfSales : Boolean read GetEndOfSales write SetEndOfSales;
    property Disabled : Boolean read GetDisabled write SetDisabled;
    property UnitID : Integer read GetUnitID write SetUnitID;
    property Quantity : Integer read GetQuantity write SetQuantity;
    property Amount : Single read GetAmount write SetAmount;
    property ExcludeTax : Single read GetExcludeTax write SetExcludeTax;
    property TaxTypeID : Integer read GetTaxTypeID write SetTaxTypeID;
    property TaxRateID : Integer read GetTaxRateID write SetTaxRateID;
    property Tax : Single read GetTax write SetTax;
    property SubTotal : Single read GetSubTotal write SetSubTotal;
    property TotalAmount : Integer read GetTotalAmount write SetTotalAmount;
    property EntryShop : Integer read GetEntryShop write SetEntryShop;
    property EntryAccount : Integer read GetEntryAccount write SetEntryAccount;
    property EntryAddDetail : Integer read GetAddDetail write SetAddDetail;
    property EntryEditDetail : Integer read GetEditDetail write SetEditDetail;
    property EntryBrandName : Integer read GetEntryBrandName write SetEntryBrandName;
    property EntryMaker : Integer read GetEntryMaker write SetEntryMaker;
    property EntryUnit : Integer read GetEntryUnit write SetEntryUnit;
    property FS : TFormatSettings read GetFS write SetFS;
  private
    FInitializedDB  : Boolean;
    FDoExitKakeiBon : Boolean;
    FUID            : Integer;
    FUName          : String;
    FRole           : Integer;
    FShopID         : Integer;
    FAccountID      : Integer;
    FExpKey1        : Integer;
    FExpKey2        : Integer;
    FExpKey3        : Integer;
    FFromACID       : Integer;
    FToACID         : Integer;
    FHID            : Integer;
    FHeaderDT       : String;
    FDID            : Integer;
    FBrandNameID    : Integer;
    FBrandName      : String;
    FMakerID        : Integer;
    FMakerName      : String;
    FEndOfSales     : Boolean;
    FDisabled       : Boolean;
    FUnitID         : Integer;
    FQuantity       : Integer;
    FAmount         : Single;
    FExcludeTax     : Single;
    FTaxTypeID      : Integer;
    FTaxRateID      : Integer;
    FTax            : Single;
    FSubTotal       : Single;
    FTotalAmount    : Integer;
    FEntryShop      : Integer;
    FEntryAccount   : Integer;
    FAddDetail      : Integer;
    FEditDetail     : Integer;
    FEntryBrandName : Integer;
    FEntryMaker     : Integer;
    FEntryUnit      : Integer;
    FChangedUserDef : Boolean;
    FShowChildForm  : Boolean;
    FFS             : TFormatSettings;
  end;

var
  Defs: TDefs;

implementation
uses
  UCommonDB, UConsts, UDBNavi;

{ TDefs }

function TDefs.VarToInt(Arg: Variant): Integer;
begin
  try
    if (Not VarIsNull(Arg))
        And (VarToStr(Arg) <> '') then begin
      Result := StrToInt(VarToStr(Arg));
    end else begin
      Result := 0;
    end;
  except
    on E: Exception do begin
      MessageDlg(MSG_JP_000041, mtError, [mbOk], 0);
      Result := 0;
    end;
  end;
end;

procedure TDefs.SetEnable(var FromAC, ToAC: TDBLookupComboBox;
  StateOfFromAC, StateOfToAC: Boolean);
begin
  with FromAC do begin
    Enabled := StateOfFromAC;
    if StateOfFromAC then begin
      Cursor  := crHandPoint;
    end else begin
      ItemIndex := -1;
      Cursor    := crDefault;
    end;
  end;
  with ToAC do begin
    Enabled   := StateOfToAC;
    if StateOfToAC then begin
      Cursor  := crHandPoint;
    end else begin
      ItemIndex := -1;
      Cursor    := crDefault;
    end;
  end;
end;

procedure TDefs.ClearPaw(var EdtPaw, EdtPawConfirm: TEdit);
begin
  if EdtPaw <> nil then begin
    EdtPaw.Clear;
  end;
  if EdtPawConfirm <> nil then begin
    EdtPawConfirm.Clear;
  end;
end;

procedure TDefs.ClearPawAndUserId(
  var EdtUserId, EdtPaw, EdtPawConfirm: TEdit);
begin
  EdtUserId.Clear;
  ClearPaw(EdtPaw, EdtPawConfirm);
end;

function TDefs.MatchRole(Sender: Integer): Boolean;
begin
  if Sender = Self.GetRole then begin
    Result       := True;
  end else begin
    Result       := False;
  end;
end;

procedure TDefs.OpenForm(Sender, NextForm: TForm);
begin
  Sender.Visible := False;
  NextForm.Show;
  Sender.Close;
end;

procedure TDefs.OpenSelectQuery(
  var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text := SS;
          if Pos(':pUserID', SS) > 0 then begin
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
            end;
          end;
          Open;
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

procedure TDefs.OpenSelectQueryByUnit(
  var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Active = False then begin
            SQL.Text                             := SS;
            Open;
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

procedure TDefs.OpenSelectQueryWithUserID(
  var Cn: TSQLite3Connection; var DS: TDataSource;
  var Tr: TSQLTransaction; var Qu: TSQLQuery; SS: AnsiString; aUserID: Integer);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Active = False then begin
            SQL.Text                             := SS;
            if Pos(':pUserID', SS) > 0 then begin
              with Params do begin
                ParamByName('pUserID').AsInteger  := GetUID;
                ParamByName('pUserID').AsInteger := aUserID;
              end;
            end;
            Open;
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

procedure TDefs.OpenSelectQueryWithExp1(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; SS: AnsiString; aExpKey1: Integer);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text                             := SS;
          if Pos(':pUserID', SS) > 0 then begin
            with Params do begin
              ParamByName('pUserID').AsInteger  := GetUID;
              ParamByName('pExpKey1').AsInteger := aExpKey1;
            end;
          end;
          Open;
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

procedure TDefs.OpenSelectQueryWithExp1AndExp2(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; SS: AnsiString; aExpKey1, aExpKey2: Integer);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text                             := SS;
          if Pos(':pUserID', SS) > 0 then begin
            with Params do begin
              ParamByName('pUserID').AsInteger  := GetUID;
              ParamByName('pExpKey1').AsInteger := aExpKey1;
              ParamByName('pExpKey2').AsInteger := aExpKey2;
            end;
          end;
          Open;
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

procedure TDefs.OpenSelectQueryWithHeaderID(
  var DS: TDataSource; var Qu: TSQLQuery;
  SS: AnsiString; aHeaderID: Integer);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text                             := SS;
          if Pos(':pUserID', SS) > 0 then begin
            with Params do begin
              ParamByName('pUserID').AsInteger  := GetUID;
              ParamByName('pHeaderID').AsInteger := aHeaderID;
            end;
          end;
          Open;
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

procedure TDefs.OpenSelectQueryWithMakerID(
  var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString; aMakerID: Integer);
begin
  try
    try
      with CommonDB do begin
        with Defs do begin
          with Qu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text                             := SS;
            if Pos(':pUserID', SS) > 0 then begin
              with Params do begin
                ParamByName('pUserID').AsInteger  := GetUID;
                ParamByName('pMakerID').AsInteger := aMakerID;
              end;
            end;
            Open;
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

procedure TDefs.OpenSelectQueryWithMakerIDAndBrandNameID(
  var DS: TDataSource; var Qu: TSQLQuery;
  SS: AnsiString; aMakerID, aBrandNameID: Integer);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Active = False then begin
            SQL.Text                             := SS;
            if Pos(':pUserID', SS) > 0 then begin
              with Params do begin
                ParamByName('pUserID').AsInteger  := GetUID;
                ParamByName('pMakerID').AsInteger := aMakerID;
              end;
            end;
            Open;

            First;
            while Not EOF do begin
              if aBrandNameID = FieldByName('BRAND_NAME_ID').AsInteger then begin
                Break;
              end;
              Next;
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

procedure TDefs.UpdateFractionProcQueryWithShopID(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; SS: AnsiString; aShopID: Integer);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Active = False then begin
            SQL.Text                             := SS;
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
              ParamByName('pShopID').AsInteger := aShopID;
            end;
            ExecSQL;
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

procedure TDefs.SetDefaultOrderKey2(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; SS: AnsiString; aExpKey1: Integer);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text                             := SS;
          with Params do begin
            ParamByName('pUserID').AsInteger := GetUID;
            ParamByName('pExpKey1').AsInteger := aExpKey1;
          end;
          ExecSQL;
          Tr.Commit;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        Tr.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TDefs.SetDefaultOrderKey3(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; SS: AnsiString; aExpKey1, aExpKey2: Integer);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text                             := SS;
          with Params do begin
            ParamByName('pUserID').AsInteger := GetUID;
            ParamByName('pExpKey1').AsInteger := aExpKey1;
            ParamByName('pExpKey2').AsInteger := aExpKey2;
          end;
          ExecSQL;
          Tr.Commit;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        Tr.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TDefs.OpenSelQuAndSetNextID(
  var DS: TDataSource; var Qu: TSQLQuery;
  var DBEditObj: TDBEdit; SS: AnsiString);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Active = False then begin
            SQL.Text                                := SS;
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
            end;
            Open;
          end;
          if (RecordCount = 1) And (Assigned(DBEditObj)) then begin
            DBEditObj.Text := FieldByName('NEXT_ID').AsString;
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

procedure TDefs.OpenSelQuBrandAndSetVal(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
  var DBEditObj: TDBEdit; SS: AnsiString);
begin
    try
      try
        with CommonDB do begin
          with Qu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text                                := SS;
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
              if GetMakerID > 0 then begin
                ParamByName('pMakerID').AsInteger := GetMakerID;
              end else begin
                ParamByName('pMakerID').AsInteger := 0;
              end;
            end;
            Open;
          end;
        end;
      except
        on E: ESQLDatabaseError do begin
          ShowMessage(E.Message);
          Tr.Rollback;
        end;
      end;
    finally
    end;
  //end;
end;

procedure TDefs.OpenSelQuUnitAndSetVal(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
  var DBEditObj: TDBEdit; SS: AnsiString);
begin
  with CommonDB do begin
    try
      try
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text                                := SS;
          Open;
        end;
      except
        on E: ESQLDatabaseError do begin
          ShowMessage(E.Message);
          Tr.Rollback;
        end;
      end;
    finally
    end;
  end;
end;

procedure TDefs.OpenSelectQueryWithTaxType(
  var DS: TDataSource; var Qu: TSQLQuery; SS: AnsiString);
begin
  try
    try
      with CommonDB do begin
        with Qu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Active = False then begin
            SQL.Text                                := SS;
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
            end;
            Qu.Open;
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

procedure TDefs.SetKeyValToDBLCB(
  var DBLCBObj: TDBLookupComboBox;
  var DBEditObj: TDBEdit; KV: Integer);
begin
  try
    try
      if KV > 0 then begin
        if Assigned(DBLCBObj) then begin
          DBLCBObj.KeyValue := KV;
        end;
        if Assigned(DBEditObj) then begin
          DBEditObj.Text    := IntToStr(KV);
        end;
      end;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

function TDefs.GetDoExitKakeiBon: Boolean;
begin
  Result          := FDoExitKakeiBon;
end;

procedure TDefs.SetDoExitKakeiBon(aDoExitKakeiBon: Boolean);
begin
  FDoExitKakeiBon := aDoExitKakeiBon;
end;

function TDefs.GetChangedUserDef: Boolean;
begin
  Result          := FChangedUserDef;
end;

procedure TDefs.SetChangedUserDef(Sender: Boolean);
begin
  FChangedUserDef := Sender;
end;

function TDefs.GetInitializedDB: Boolean;
begin
  Result         := FInitializedDB;
end;

procedure TDefs.SetInitializedDB(InitializedDB: Boolean);
begin
  FInitializedDB := InitializedDB;
end;

function TDefs.GetRole: Integer;
begin
  Result := FRole;
end;

procedure TDefs.SetRole(RoleNum: Integer);
begin
  FRole  := RoleNum;
end;

function TDefs.GetShowChildForm: Boolean;
begin
  Result         := FShowChildForm;
end;

procedure TDefs.SetShowChildForm(Sender: Boolean);
begin
  FShowChildForm := Sender;
end;

function TDefs.GetUID: Integer;
begin
  Result := FUID;
end;

procedure TDefs.SetUID(UID: Integer);
begin
  FUID   := UID;
end;

function TDefs.GetUName: String;
begin
  Result := FUName;
end;

procedure TDefs.SetUName(UName: String);
begin
  FUName := UName;
end;

function TDefs.GetShopID: Integer;
begin
  Result  := FShopID;
end;

procedure TDefs.SetShopID(ShopID: Integer);
begin
  FShopID := ShopID;
end;

function TDefs.GetAccountID: Integer;
begin
  Result  := FAccountID;
end;

procedure TDefs.SetAccountID(AccountID: Integer);
begin
  FAccountID := AccountID;
end;

function TDefs.GetExpKey1: Integer;
begin
  Result   := FExpKey1;
end;

procedure TDefs.SetExpKey1(const ExpKey1: Integer = 0);
begin
  FExpKey1 := ExpKey1;
end;

function TDefs.GetExpKey2: Integer;
begin
  Result   := FExpKey2;
end;

procedure TDefs.SetExpKey2(const ExpKey2: Integer = 0);
begin
  FExpKey2 := ExpKey2;
end;

function TDefs.GetExpKey3: Integer;
begin
  Result   := FExpKey3;
end;

procedure TDefs.SetExpKey3(const ExpKey3: Integer = 0);
begin
  FExpKey3 := ExpKey3;
end;

function TDefs.GetFromACID: Integer;
begin
  Result    := FFromACID;
end;

procedure TDefs.SetFromACID(const FromACID: Integer = 0);
begin
  FFromACID := FromACID;
end;

function TDefs.GetToACID: Integer;
begin
  Result  := FToACID;
end;

procedure TDefs.SetToACID(const ToACID: Integer = 0);
begin
  FToACID := ToACID;
end;

function TDefs.GetHID: Integer;
begin
  Result := FHID;
end;

procedure TDefs.SetHID(const HID: Integer = 0);
begin
  FHID   := HID;
end;

function TDefs.GetHeaderDT: String;
begin
  Result    := FHeaderDT;
end;

procedure TDefs.SetHeaderDT(HeaderDT: String);
begin
  FHeaderDT := HeaderDT;
end;

function TDefs.GetDID: Integer;
begin
  Result := FDID;
end;

procedure TDefs.SetDID(const DID: Integer = 0);
begin
  FDID   := DID;
end;

function TDefs.GetBrandNameID: Integer;
begin
  Result       := FBrandNameID;
end;

procedure TDefs.SetBrandNameID(const BrandNameID: Integer = 0);
begin
  FBrandNameID := BrandNameID;
end;

function TDefs.GetBrandName: String;
begin
  Result     := FBrandName;
end;

procedure TDefs.SetBrandName(BrandName: String);
begin
  FBrandName := BrandName;
end;

function TDefs.GetMakerID: Integer;
begin
  Result   := FMakerID;
end;

procedure TDefs.SetMakerID(const MakerID: Integer = 0);
begin
  FMakerID := MakerID;
end;

function TDefs.GetMakerName: String;
begin
  Result     := FMakerName;
end;

procedure TDefs.SetMakerName(MakerName: String);
begin
  FMakerName := MakerName;
end;

function TDefs.GetEndOfSales: Boolean;
begin
  Result      := FEndOfSales;
end;

procedure TDefs.SetEndOfSales(EndOfSales: Boolean);
begin
  FEndOfSales := EndOfSales;
end;

function TDefs.GetDisabled: Boolean;
begin
  Result    := FDisabled;
end;

procedure TDefs.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

function TDefs.GetUnitID: Integer;
begin
  Result  := FUnitID;
end;

procedure TDefs.SetUnitID(const UnitID: Integer = 0);
begin
  FUnitID := UnitID;
end;

function TDefs.GetQuantity: Integer;
begin
  Result    := FQuantity;
end;

procedure TDefs.SetQuantity(const Quantity: Integer);
begin
  FQuantity := Quantity;
end;

function TDefs.GetAmount: Single;
begin
  Result    := FAmount;
end;

procedure TDefs.SetAmount(const Amount: Single = 0.0);
begin
  FAmount := Amount;
end;

function TDefs.GetExcludeTax: Single;
begin
  Result    := FExcludeTax;
end;

procedure TDefs.SetExcludeTax(const ExcludeTax: Single = 0.0);
begin
  FExcludeTax := ExcludeTax;
end;

function TDefs.GetTaxTypeID: Integer;
begin
  Result     := FTaxTypeID;
end;

procedure TDefs.SetTaxTypeID(const TaxTypeID: Integer = 0);
begin
  FTaxTypeID := TaxTypeID;
end;

function TDefs.GetTaxRateID: Integer;
begin
  Result     := FTaxRateID;
end;

procedure TDefs.SetTaxRateID(const TaxRateID: Integer = 0);
begin
  FTaxRateID := TaxRateID;
end;

function TDefs.GetTax: Single;
begin
  Result := FTax;
end;

procedure TDefs.SetTax(const Tax: Single = 0.0);
begin
  FTax   := Tax;
end;

function TDefs.GetSubTotal: Single;
begin
  Result := FSubTotal;
end;

procedure TDefs.SetSubTotal(const SubTotal: Single = 0.0);
begin
  FSubTotal   := SubTotal;
end;

function TDefs.GetTotalAmount: Integer;
begin
  Result := FTotalAmount;
end;

procedure TDefs.SetTotalAmount(const TotalAmount: Integer = 0);
begin
  FTotalAmount := TotalAmount;
end;

function TDefs.GetEntryShop: Integer;
begin
  Result     := FEntryShop;
end;

procedure TDefs.SetEntryShop(const EntryShop: Integer = 0);
begin
  FEntryShop := EntryShop;
end;

function TDefs.GetEntryAccount: Integer;
begin
  Result        := FEntryAccount;
end;

procedure TDefs.SetEntryAccount(const EntryAccount: Integer = 0);
begin
  FEntryAccount := EntryAccount;
end;

function TDefs.GetAddDetail: Integer;
begin
  Result     := FAddDetail;
end;

procedure TDefs.SetAddDetail(const AddDetail: Integer = 0);
begin
  FAddDetail := AddDetail;
end;

function TDefs.GetEditDetail: Integer;
begin
  Result      := FEditDetail;
end;

procedure TDefs.SetEditDetail(const EditDetail: Integer = 0);
begin
  FEditDetail := EditDetail;
end;

function TDefs.GetEntryBrandName: Integer;
begin
  Result          := FEntryBrandName;
end;

procedure TDefs.SetEntryBrandName(const EntryBrandName: Integer = 0);
begin
  FEntryBrandName := EntryBrandName;
end;

function TDefs.GetEntryMaker: Integer;
begin
  Result      := FEntryMaker;
end;

procedure TDefs.SetEntryMaker(const EntryMaker: Integer = 0);
begin
  FEntryMaker := EntryMaker;
end;

function TDefs.GetEntryUnit: Integer;
begin
  Result     := FEntryUnit;
end;

procedure TDefs.SetEntryUnit(const EntryUnit: Integer = 0);
begin
  FEntryUnit := EntryUnit;
end;

function TDefs.GetFS: TFormatSettings;
begin
  Result := FFS;
end;

procedure TDefs.SetFS(FS: TFormatSettings);
begin
  FFS    := FS;
end;

end.

