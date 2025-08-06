unit UDefs;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Variants, Dialogs, StdCtrls, SysUtils, Forms, SQLDB, DB,
  SQLite3Conn, DBCtrls;

type

  TShowType = (stWithCreate, stShowOnly);
  TFormRec = Record
    Form     : TForm;
    ShowType : TShowType;
  end;

  { TDefs }

  TDefs = class(TObject)
    FormArray : Array[0..50] of TFormRec;
    FormTop   : Integer;
    constructor Create;
    procedure ClearPaw(EdtPaw, EdtPawConfirm: TEdit);
    procedure ClearPawAndUserId(EdtUserId, EdtPaw, EdtPawConfirm: TEdit);
    procedure CloseConn(var Cn: TSQLite3Connection; var Tr: TSQLTransaction);
    function MatchRole(Sender: Integer): Boolean;
    procedure OpenForm(Sender, NextForm: TForm);
    procedure OpenSelectQuery(
      var Cn: TSQLite3Connection; var DS: TDataSource;
      var Tr: TSQLTransaction; var Qu: TSQLQuery; SS: AnsiString);
    procedure OpenSelectQueryByUnit(
      var Cn: TSQLite3Connection; var DS: TDataSource;
      var Tr: TSQLTransaction; var Qu: TSQLQuery; SS: AnsiString);
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
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; SS: AnsiString; aHeaderID: Integer);
    procedure OpenSelectQueryWithMakerID(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; SS: AnsiString; aMakerID: Integer);
    procedure OpenSelectQueryWithMakerIDAndBrandNameID(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; SS: AnsiString; aMakerID, aBrandNameID: Integer);
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
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; var DBEditObj: TDBEdit; SS: AnsiString);
    procedure OpenSelQuAndSetVal(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
      var DBEditObj: TDBEdit; SS: AnsiString; KeyValue: Integer);
    procedure OpenSelQuBrandAndSetVal(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
      var DBEditObj: TDBEdit; SS: AnsiString; KeyValue: Integer);
    procedure OpenSelQuUnitAndSetVal(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
      var DBEditObj: TDBEdit; SS: AnsiString; KeyValue: Integer);
    procedure OpenSelQuTaxTypeAndSetVal(
      var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
      var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
      var DBEditObj: TDBEdit; SS: AnsiString; KeyValue: Integer);
    procedure SetDatabaseName(var Cn: TSQLite3Connection);

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
    function GetOSHomeDir: AnsiString;
    procedure SetOSHomeDir(aOSHomeDir: AnsiString);
    function GetDBPath: AnsiString;
    procedure SetDBPath(aDBDir: AnsiString);
    function GetDBFullPath: AnsiString;
    procedure SetDBFullPath(aDBFullPath: AnsiString);
    function GetUID: Integer;
    procedure SetUID(UID: Integer);
    function GetUName: String;
    procedure SetUName(UName: String);
    function GetShopID: Variant;
    procedure SetShopID(ShopID: Variant);
    function GetExpKey1: Variant;
    procedure SetExpKey1(ExpKey1: Variant);
    function GetExpKey2: Variant;
    procedure SetExpKey2(ExpKey2: Variant);
    function GetExpKey3: Variant;
    procedure SetExpKey3(ExpKey3: Variant);
    function GetFromACID: Variant;
    procedure SetFromACID(FromACID: Variant);
    function GetToACID: Variant;
    procedure SetToACID(ToACID: Variant);
    function GetHID: Integer;
    procedure SetHID(HID: Integer);
    function GetHeaderDT: String;
    procedure SetHeaderDT(HeaderDT: String);
    function GetDID: Variant;
    procedure SetDID(DID: Variant);
    function GetBrandNameID: Variant;
    procedure SetBrandNameID(BrandNameID: Variant);
    function GetBrandName: String;
    procedure SetBrandName(BrandName: String);
    function GetMakerID: Variant;
    procedure SetMakerID(MakerID: Variant);
    function GetMakerName: String;
    procedure SetMakerName(MakerName: String);
    function GetEndOfSales: Boolean;
    procedure SetEndOfSales(EndOfSales: Boolean);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    function GetUnitID: Variant;
    procedure SetUnitID(UnitID: Variant);
    function GetQuantity: Integer;
    procedure SetQuantity(Quantity: Integer);
    function GetExcludeTax: Integer;
    procedure SetExcludeTax(ExcludeTax: Integer);
    function GetTaxTypeID: Variant;
    procedure SetTaxTypeID(TaxTypeID: Variant);
    function GetTaxRateID: Variant;
    procedure SetTaxRateID(TaxRateID: Variant);
    function GetTax: Integer;
    procedure SetTax(Tax: Integer);
    function GetSubTotal: Integer;
    procedure SetSubTotal(SubTotal: Integer);
    function GetTotalAmount: Integer;
    procedure SetTotalAmount(TotalAmount: Integer);
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
    property OSHomeDir : AnsiString read GetOSHomeDir write SetOSHomeDir;
    property DBDir : AnsiString read GetDBPath write SetDBPath;
    property DBFullPath : AnsiString read GetDBFullPath write SetDBFullPath;
    property UID : Integer read GetUID write SetUID;
    property UName : String read GetUName write SetUName;
    property ShopID : Variant read GetShopID write SetShopID;
    property ExpKey1 : Variant read GetExpKey1 write SetExpKey1;
    property ExpKey2 : Variant read GetExpKey2 write SetExpKey2;
    property ExpKey3 : Variant read GetExpKey3 write SetExpKey3;
    property FromACID : Variant read GetFromACID write SetFromACID;
    property ToACID : Variant read GetToACID write SetToACID;
    property HID : Integer read GetHID write SetHID;
    property HeaderDT : String read GetHeaderDT write SetHeaderDT;
    property DID : Variant read GetDID write SetDID;
    property BrandNameID : Variant read GetBrandNameID write SetBrandNameID;
    property BrandName : String read GetBrandName write SetBrandName;
    property MakerID : Variant read GetMakerID write SetMakerID;
    property MakerName : String read GetMakerName write SetMakerName;
    property EndOfSales : Boolean read GetEndOfSales write SetEndOfSales;
    property Disabled : Boolean read GetDisabled write SetDisabled;
    property UnitID : Variant read GetUnitID write SetUnitID;
    property Quantity : Integer read GetQuantity write SetQuantity;
    property ExcludeTax : Integer read GetExcludeTax write SetExcludeTax;
    property TaxTypeID : Variant read GetTaxTypeID write SetTaxTypeID;
    property TaxRateID : Variant read GetTaxRateID write SetTaxRateID;
    property Tax : Integer read GetTax write SetTax;
    property SubTotal : Integer read GetSubTotal write SetSubTotal;
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
    FOSHomeDir      : AnsiString;
    FDBPath         : AnsiString;
    FDBFullPath     : AnsiString;
    FUID            : Integer;
    FUName          : String;
    FRole           : Integer;
    FShopID         : Variant;
    FExpKey1        : Variant;
    FExpKey2        : Variant;
    FExpKey3        : Variant;
    FFromACID       : Variant;
    FToACID         : Variant;
    FHID            : Integer;
    FHeaderDT       : String;
    FDID            : Variant;
    FBrandNameID    : Variant;
    FBrandName      : String;
    FMakerID        : Variant;
    FMakerName      : String;
    FEndOfSales     : Boolean;
    FDisabled       : Boolean;
    FUnitID         : Variant;
    FQuantity       : Integer;
    FExcludeTax     : Integer;
    FTaxTypeID      : Variant;
    FTaxRateID      : Variant;
    FTax            : Integer;
    FSubTotal       : Integer;
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

implementation
uses
  UConsts, UTopMenu;

{ TDefs }

procedure TDefs.ClearPaw(EdtPaw, EdtPawConfirm: TEdit);
begin
  if EdtPaw <> nil then
  begin
    EdtPaw.Clear;
  end;
  EdtPawConfirm.Clear;
end;

procedure TDefs.ClearPawAndUserId(EdtUserId, EdtPaw, EdtPawConfirm: TEdit);
begin
  EdtUserId.Clear;
  ClearPaw(EdtPaw, EdtPawConfirm);
end;

procedure TDefs.CloseConn(
  var Cn: TSQLite3Connection; var Tr: TSQLTransaction);
begin
  if Assigned(Cn) then begin
    with Cn do begin
      if Connected then
      begin
        Close;
        Tr.CloseDataSets;
      end;
    end;
  end;
end;

constructor TDefs.Create;
begin
  FShowChildForm := False;
end;

function TDefs.MatchRole(Sender: Integer): Boolean;
begin
  if Sender = Self.GetRole then
  begin
    Result       := True;
  end else begin
    Result       := False;
  end;
end;

procedure TDefs.OpenForm(Sender, NextForm: TForm);
begin
  Sender.Visible := False;
  NextForm.Show;
  Sender.Release;
end;

procedure TDefs.OpenSelectQuery(
  var Cn: TSQLite3Connection; var DS: TDataSource;
  var Tr: TSQLTransaction; var Qu: TSQLQuery; SS: AnsiString);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
          if Active = False then
          begin
            SQL.Text                             := SS;
            if Pos(':pUserID', SS) > 0 then begin
              with Params do begin
                ParamByName('pUserID').AsInteger := GetUID;
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

procedure TDefs.OpenSelectQueryByUnit(
  var Cn: TSQLite3Connection; var DS: TDataSource;
  var Tr: TSQLTransaction; var Qu: TSQLQuery; SS: AnsiString);
begin
  try
    try
      with Qu do begin
        if Active = False then
        begin
          SQL.Text                             := SS;
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

procedure TDefs.OpenSelectQueryWithUserID(
  var Cn: TSQLite3Connection; var DS: TDataSource;
  var Tr: TSQLTransaction; var Qu: TSQLQuery; SS: AnsiString; aUserID: Integer);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
          if Active = False then
          begin
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
      with FrmTopMenu.Defs do begin
        with Qu do begin
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
      with FrmTopMenu.Defs do begin
        with Qu do begin
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
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; SS: AnsiString; aHeaderID: Integer);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
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
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; SS: AnsiString; aMakerID: Integer);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
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
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;

end;

procedure TDefs.OpenSelectQueryWithMakerIDAndBrandNameID(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; SS: AnsiString; aMakerID, aBrandNameID: Integer);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
          if Active = False then
          begin
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
      with FrmTopMenu.Defs do begin
        with Qu do begin
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
      with FrmTopMenu.Defs do begin
        with Qu do begin
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
      with FrmTopMenu.Defs do begin
        with Qu do begin
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
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; var DBEditObj: TDBEdit; SS: AnsiString);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
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
        Tr.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TDefs.OpenSelQuAndSetVal(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
  var DBEditObj: TDBEdit; SS: AnsiString; KeyValue: Integer);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
          SQL.Text                                := SS;
          with Params do begin
            ParamByName('pUserID').AsInteger := GetUID;
          end;
          Open;
          if KeyValue > 0 then begin
            if Assigned(DBLCBObj) then begin
              DBLCBObj.KeyValue := KeyValue;
            end;
            if Assigned(DBEditObj) then begin
              DBEditObj.Text := IntToStr(KeyValue);
            end;
          end;
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

procedure TDefs.OpenSelQuBrandAndSetVal(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
  var DBEditObj: TDBEdit; SS: AnsiString; KeyValue: Integer);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
          if Active = False then begin
            SQL.Text                                := SS;
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
              if (Not VarIsNull(GetMakerID))
                  And (VarToStr(GetMakerID) <> '')
                  And (StrToInt(VarToStr(GetMakerID)) > 0) then begin
                ParamByName('pMakerID').AsInteger := StrToInt(VarToStr(GetMakerID));
              end else begin
                ParamByName('pMakerID').AsInteger := 0;
              end;
            end;
            Open;
          end;
          if KeyValue > 0 then begin
            if Assigned(DBLCBObj) then begin
              DBLCBObj.KeyValue := KeyValue;
            end;
            if Assigned(DBEditObj) then begin
              DBEditObj.Text := IntToStr(KeyValue);
            end;
          end;
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

procedure TDefs.OpenSelQuUnitAndSetVal(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
  var DBEditObj: TDBEdit; SS: AnsiString; KeyValue: Integer);
begin
  try
    try
      with Qu do begin
        if Active = False then
        begin
          SQL.Text                                := SS;
          Open;
        end;
        if KeyValue > 0 then begin
          if Assigned(DBLCBObj) then begin
            DBLCBObj.KeyValue := KeyValue;
          end;
          if Assigned(DBEditObj) then begin
            DBEditObj.Text := IntToStr(KeyValue);
          end;
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

procedure TDefs.OpenSelQuTaxTypeAndSetVal(
  var Cn: TSQLite3Connection; var DS: TDataSource; var Tr: TSQLTransaction;
  var Qu: TSQLQuery; var DBLCBObj: TDBLookupComboBox;
  var DBEditObj: TDBEdit; SS: AnsiString; KeyValue: Integer);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with Qu do begin
          if Active = False then
          begin
            SQL.Text                                := SS;
            with Params do begin
              ParamByName('pUserID').AsInteger := GetUID;
            end;
            Qu.Open;
          end;
          if KeyValue > 0 then begin
            if Assigned(DBLCBObj) then begin
              DBLCBObj.KeyValue := KeyValue;
            end;
            if Assigned(DBEditObj) then begin
              DBEditObj.Text := IntToStr(KeyValue);
            end;
          end;
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

procedure TDefs.SetDatabaseName(var Cn: TSQLite3Connection);
begin
  if GetDBFullPath <> '' then begin
    Cn.DatabaseName := GetDBFullPath;
  end else begin
    MessageDlg('データベース名が取得できません。処理が続行できないためKakeiBonを終了します。', mtError, [mbOk], 0);
    SetDoExitKakeiBon(True);
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

function TDefs.GetOSHomeDir: AnsiString;
begin
  Result     := FOSHomeDir;
end;

procedure TDefs.SetOSHomeDir(aOSHomeDir: AnsiString);
begin
  FOSHomeDir := aOSHomeDir;
end;

function TDefs.GetDBPath: AnsiString;
begin
  Result := FDBPath;
end;

procedure TDefs.SetDBPath(aDBDir: AnsiString);
begin
  FDBPath := aDBDir;
end;

function TDefs.GetDBFullPath: AnsiString;
begin
  Result       := FDBFullPath;
end;

procedure TDefs.SetDBFullPath(aDBFullPath: AnsiString);
begin
  if aDBFullPath <> '' then begin
    FDBFullPath := aDBFullPath;
  end else begin
    MessageDlg(MSG_JP_000008, mtError, [mbOk], 0);
    SetDoExitKakeiBon(True);
  end;
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

function TDefs.GetShopID: Variant;
begin
  Result  := FShopID;
end;

procedure TDefs.SetShopID(ShopID: Variant);
begin
  FShopID := ShopID;
end;

function TDefs.GetExpKey1: Variant;
begin
  Result   := FExpKey1;
end;

procedure TDefs.SetExpKey1(ExpKey1: Variant);
begin
  FExpKey1 := ExpKey1;
end;

function TDefs.GetExpKey2: Variant;
begin
  Result   := FExpKey2;
end;

procedure TDefs.SetExpKey2(ExpKey2: Variant);
begin
  FExpKey2 := ExpKey2;
end;

function TDefs.GetExpKey3: Variant;
begin
  Result   := FExpKey3;
end;

procedure TDefs.SetExpKey3(ExpKey3: Variant);
begin
  FExpKey3 := ExpKey3;
end;

function TDefs.GetFromACID: Variant;
begin
  Result    := FFromACID;
end;

procedure TDefs.SetFromACID(FromACID: Variant);
begin
  FFromACID := FromACID;
end;

function TDefs.GetToACID: Variant;
begin
  Result  := FToACID;
end;

procedure TDefs.SetToACID(ToACID: Variant);
begin
  FToACID := ToACID;
end;

function TDefs.GetHID: Integer;
begin
  Result := FHID;
end;

procedure TDefs.SetHID(HID: Integer);
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

function TDefs.GetDID: Variant;
begin
  Result := FDID;
end;

procedure TDefs.SetDID(DID: Variant);
begin
  FDID   := DID;
end;

function TDefs.GetBrandNameID: Variant;
begin
  Result       := FBrandNameID;
end;

procedure TDefs.SetBrandNameID(BrandNameID: Variant);
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

function TDefs.GetMakerID: Variant;
begin
  Result   := FMakerID;
end;

procedure TDefs.SetMakerID(MakerID: Variant);
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

function TDefs.GetUnitID: Variant;
begin
  Result  := FUnitID;
end;

procedure TDefs.SetUnitID(UnitID: Variant);
begin
  FUnitID := UnitID;
end;

function TDefs.GetQuantity: Integer;
begin
  Result    := FQuantity;
end;

procedure TDefs.SetQuantity(Quantity: Integer);
begin
  FQuantity := Quantity;
end;

function TDefs.GetExcludeTax: Integer;
begin
  Result    := FExcludeTax;
end;

procedure TDefs.SetExcludeTax(ExcludeTax: Integer);
begin
  FExcludeTax := ExcludeTax;
end;

function TDefs.GetTaxTypeID: Variant;
begin
  Result     := FTaxTypeID;
end;

procedure TDefs.SetTaxTypeID(TaxTypeID: Variant);
begin
  FTaxTypeID := TaxTypeID;
end;

function TDefs.GetTaxRateID: Variant;
begin
  Result     := FTaxRateID;
end;

procedure TDefs.SetTaxRateID(TaxRateID: Variant);
begin
  FTaxRateID := TaxRateID;
end;

function TDefs.GetTax: Integer;
begin
  Result := FTax;
end;

procedure TDefs.SetTax(Tax: Integer);
begin
  FTax   := Tax;
end;

function TDefs.GetSubTotal: Integer;
begin
  Result := FSubTotal;
end;

procedure TDefs.SetSubTotal(SubTotal: Integer);
begin
  FSubTotal   := SubTotal;
end;

function TDefs.GetTotalAmount: Integer;
begin
  Result := FTotalAmount;
end;

procedure TDefs.SetTotalAmount(TotalAmount: Integer);
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

