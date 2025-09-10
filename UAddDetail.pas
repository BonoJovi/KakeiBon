unit UAddDetail;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, DBCtrls, LCLIntf, LCLType, ActnList,
  DBGrids, DBDateTimePicker;

type

  { TFrmAddDetail }

  TFrmAddDetail = class(TForm)
    ADS               : TDataSource;
    AQu               : TSQLQuery;
    ADSNextID         : TDataSource;
    AQuNextID         : TSQLQuery;
    ADSMaker          : TDataSource;
    AQuMaker          : TSQLQuery;
    ADSBrand          : TDataSource;
    AQuBrand          : TSQLQuery;
    ADSExp2           : TDataSource;
    AQuExp2           : TSQLQuery;
    ADSExp3           : TDataSource;
    AQuExp3           : TSQLQuery;
    ADSUnit           : TDataSource;
    AQuUnit           : TSQLQuery;
    ADSTaxType        : TDataSource;
    AQuTaxType        : TSQLQuery;
    { ActionLists }
    ActionList        : TActionList;
    ActEntryMaker     : TAction;
    ActEntryBrandName : TAction;
    ActEntryUnit      : TAction;
    ActCancel         : TAction;
    ActSave         : TAction;
    ActGoBack           : TAction;
    DBLCBMaker: TDBLookupComboBox;
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
    BtnEntryMaker     : TPanel;
    BtnEntryBrandName : TPanel;
    BtnEntryUnit      : TPanel;
    BtnCancel         : TPanel;
    BtnSave           : TPanel;
    BtnGoBack         : TPanel;
    PnlSeparator      : TPanel;
    PnlCancel         : TPanel;
    PnlSave           : TPanel;
    PnlGoBack         : TPanel;
    PnlEntryUnit      : TPanel;
    PnlEntryBrandName : TPanel;
    PnlEntryMaker     : TPanel;
    Shape1            : TShape;
    Shape10           : TShape;
    Shape11           : TShape;
    Shape2            : TShape;
    Shape3            : TShape;
    Shape4            : TShape;
    Shape5            : TShape;
    Shape6            : TShape;
    Shape7            : TShape;
    Shape8            : TShape;
    Shape9            : TShape;
    Timer1: TTimer;
    procedure DBLCBBrandNameEnter(Sender: TObject);
    procedure DBLCBBrandNameExit(Sender: TObject);
    procedure DBLCBExp2Enter(Sender: TObject);
    procedure DBLCBExp2Exit(Sender: TObject);
    procedure DBLCBExp3Enter(Sender: TObject);
    procedure DBLCBExp3Exit(Sender: TObject);
    procedure DBLCBMakerEnter(Sender: TObject);
    procedure DBLCBMakerExit(Sender: TObject);
    procedure DBLCBTaxTypeEnter(Sender: TObject);
    procedure DBLCBUnitEnter(Sender: TObject);
    procedure DBLCBUnitExit(Sender: TObject);
    procedure EdtAmountEnter(Sender: TObject);
    procedure EdtAmountExit(Sender: TObject);
    procedure EdtExcludeTaxEnter(Sender: TObject);
    procedure EdtQuantityEnter(Sender: TObject);
    procedure EdtSubTotalEnter(Sender: TObject);
    procedure EdtTaxEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcEntryBrandName(Sender: TObject);
    procedure ProcEntryMaker(Sender: TObject);
    procedure ProcEntryUnit(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    function ProcSave(Sender: TObject): Boolean;
    procedure EntryMakerMouseOver(NewColor: TColor);
    procedure BtnEntryMakerEnter(Sender: TObject);
    procedure BtnEntryMakerExit(Sender: TObject);
    procedure EntryBrandNameMouseOver(NewColor: TColor);
    procedure BtnEntryBrandNameEnter(Sender: TObject);
    procedure BtnEntryBrandNameExit(Sender: TObject);
    procedure EntryUnitMouseOver(NewColor: TColor);
    procedure BtnEntryUnitEnter(Sender: TObject);
    procedure BtnEntryUnitExit(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure SaveMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActEntryBrandNameExecute(Sender: TObject);
    procedure ActEntryMakerExecute(Sender: TObject);
    procedure ActEntryUnitExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
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
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    FInsert     : Boolean;
    FGoBack     : Boolean;
    FTaxRate    : Double;
    FQuantity   : Variant;
    FAmount     : Variant;
    FExcludeTax : Variant;
    FTax        : Variant;
    FSubTotal   : Variant;
    procedure BackupValues;
    procedure CalcInclusiveTax;
    procedure ClearInputFields;
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
  LazLogger, UConsts, UDefs, UDBAccess, UCommonDB, UTopMenu, UManageDetails,
  UEditDetailsHeader, UEntryBrandName, UEntryMaker, UEntryUnit;

{$R *.lfm}

{ TFrmAddDetail }

procedure TFrmAddDetail.BackupValues;
begin
  with Defs do begin
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

    with AQuTaxType do begin
      if Active then begin;
        if (Not VarIsNull(DBLCBTaxType.KeyValue))
            And (VarToStr(DBLCBTaxType.KeyValue) <> '')
            And (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) > 0) then begin
          First;
          while FieldByName('TAX_TYPE_ID').AsInteger <> StrToInt(VarToStr(DBLCBTaxType.KeyValue)) do begin
            if EOF then begin
              break;
            end;
            Next;
          end;
          SetTaxRateID(FieldByName('TAX_RATE_ID').AsVariant);
        end else begin
          SetTaxTypeID(Null);
          SetTaxRateID(Null);
        end;
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
  with CommonDB do begin
    with Defs do begin
      DBEdtUserID.Text        := IntToStr(GetUID);
      DBEdtHeaderID.Text      := IntToStr(GetHID);

      with AQuNextID do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQueryWithHeaderID(
          ADSNextID, AQuNextID, SQL_20120003, GetHID);
        LNextDetailID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
        CloseQuery(AQuNextID);
      end;

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
end;

procedure TFrmAddDetail.ProcInsert(Sender: TObject);
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

procedure TFrmAddDetail.DBLCBMakerEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmAddDetail.DBLCBBrandNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;
end;

procedure TFrmAddDetail.DBLCBBrandNameExit(Sender: TObject);
begin
  Shape2.Visible := False;
end;

procedure TFrmAddDetail.DBLCBExp2Enter(Sender: TObject);
begin
  Shape3.Visible := True;
end;

procedure TFrmAddDetail.DBLCBExp2Exit(Sender: TObject);
begin
  Shape3.Visible := False;
end;

procedure TFrmAddDetail.DBLCBExp3Enter(Sender: TObject);
begin
  Shape4.Visible := True;
end;

procedure TFrmAddDetail.DBLCBExp3Exit(Sender: TObject);
begin
  Shape4.Visible := False;
end;

procedure TFrmAddDetail.DBLCBMakerExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmAddDetail.DBLCBTaxTypeEnter(Sender: TObject);
begin
  Shape6.Visible := True;
end;

procedure TFrmAddDetail.DBLCBUnitEnter(Sender: TObject);
begin
  Shape5.Visible := True;
end;

procedure TFrmAddDetail.DBLCBUnitExit(Sender: TObject);
begin
  Shape5.Visible := False;
end;

procedure TFrmAddDetail.EdtAmountEnter(Sender: TObject);
begin
  Shape8.Visible := True;
end;

procedure TFrmAddDetail.EdtAmountExit(Sender: TObject);
begin
  Shape8.Visible := False;
end;

procedure TFrmAddDetail.EdtExcludeTaxEnter(Sender: TObject);
begin
  Shape9.Visible := True;
end;

procedure TFrmAddDetail.EdtQuantityEnter(Sender: TObject);
begin
  Shape7.Visible := True;
end;

procedure TFrmAddDetail.EdtSubTotalEnter(Sender: TObject);
begin
  Shape11.Visible := True;
end;

procedure TFrmAddDetail.EdtTaxEnter(Sender: TObject);
begin
  Shape10.Visible := True;
end;

procedure TFrmAddDetail.ProcEntryBrandName(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    SetEntryMaker(999);
    SetEntryBrandName(1);

    FrmEntryBrandName := TFrmEntryBrandName.Create(Application);
    OpenForm(Self, FrmEntryBrandName);
  end;
end;

procedure TFrmAddDetail.ProcEntryMaker(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    SetEntryMaker(1);

    FrmEntryMaker := TFrmEntryMaker.Create(Application);
    OpenForm(Self, FrmEntryMaker);
  end;
end;

procedure TFrmAddDetail.ProcEntryUnit(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    SetEntryUnit(1);

    FrmEntryUnit := TFrmEntryUnit.Create(Application);
    OpenForm(Self, FrmEntryUnit);
  end;
end;

procedure TFrmAddDetail.ProcCancel(Sender: TObject);
begin
  if FInsert then begin
    FInsert := False;
  end;
  with CommonDB do begin
    ATr.Rollback;
  end;

  ClearInputFields;

  DBLCBMaker.SetFocus;
end;

function TFrmAddDetail.ProcSave(Sender: TObject): Boolean;
var
  LNextDetailID : Integer = 0;
begin
  result := False;
  try
    try
      with CommonDB do begin
        with Defs do begin
          if (VarIsNull(GetDID))
              Or (VarToStr(GetDID) = '')
              Or (StrToInt(VarToStr(GetDID)) = 0)then begin
            CloseQuery(AQuNextID);

            AQuNextID.SQLConnection  := ACn;
            AQuNextID.SQLTransaction := ATr;

            OpenSelectQueryWithHeaderID(
              ADSNextID, AQuNextID, SQL_20120003, GetHID);
            LNextDetailID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

            CloseQuery(AQuNextID);

            DBEdtDetailID.Text := IntToStr(LNextDetailID);
            SetDID(LNextDetailID);
          end;

          with AQu do begin
            CloseQuery(AQu);

            SQLConnection  := ACn;
            SQLTransaction := ATr;

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
              if (Not VarIsNull(GetMakerID))
                  And (VarToStr(GetMakerID) <> '')
                  And (StrToInt(VarToStr(GetMakerID)) > 0) then begin
                ParamByName('pMakerID'    ).AsInteger   := StrToInt(VarToStr(GetMakerID));
              end else begin
                MessageDlg(MSG_JP_000032, mtInformation, [mbOK], 0);
                DBLCBMaker.SetFocus;
                Exit;
              end;
              if (Not VarIsNull(GetBrandNameID))
                  And (VarToStr(GetBrandNameID) <> '')
                  And (StrToInt(VarToStr(GetBrandNameID)) > 0) then begin
                ParamByName('pBrandNameID').AsInteger   := StrToInt(VarToStr(GetBrandNameID));
              end else begin
                MessageDlg(MSG_JP_000035, mtInformation, [mbOK], 0);
                DBLCBBrandName.SetFocus;
                Exit;
              end;
              if (Not VarIsNull(GetUnitID))
                  And (VarToStr(GetUnitID) <> '')
                  And (StrToInt(VarToStr(GetUnitID)) > 0) then begin
                ParamByName('pUnitID'     ).AsInteger   := StrToInt(VarToStr(GetUnitID));
              end else begin
                MessageDlg(MSG_JP_000036, mtInformation, [mbOK], 0);
                DBLCBUnit.SetFocus;
                Exit;
              end;
              if (Not VarIsNull(GetTaxTypeID))
                  And (VarToStr(GetTaxTypeID) <> '')
                  And (StrToInt(VarToStr(GetTaxTypeID)) > 0) then begin
                ParamByName('pTaxTypeID'  ).AsInteger   := StrToInt(VarToStr(GetTaxTypeID));
                ParamByName('pTaxRateID'  ).AsInteger   := StrToInt(VarToStr(GetTaxRateID));
              end else begin
                MessageDlg(MSG_JP_000037, mtInformation, [mbOK], 0);
                DBLCBTaxType.SetFocus;
                Exit;
              end;
              if GetQuantity > 0 then begin
                ParamByName('pQuantity'   ).AsInteger   := GetQuantity;
              end else begin
                MessageDlg(MSG_JP_000038, mtInformation, [mbOK], 0);
                EdtQuantity.SetFocus;
                Exit;
              end;
              ParamByName('pExcludeTax' ).AsInteger    := GetExcludeTax;
              ParamByName('pTax'        ).AsInteger    := GetTax;
              ParamByName('pSubTotal'   ).AsInteger    := GetSubTotal;
              ParamByName('pEntryDT'    ).AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              ParamByName('pUpdateDT'   ).AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
            end;

            ExecSQL;
            ATr.Commit;
          end;
        end;

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

        FormActivate(Self);
      end;
      result := True;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
    FInsert := False;
  end;
end;

procedure TFrmAddDetail.EntryMakerMouseOver(NewColor: TColor);
begin
  BtnEntryMaker.Color := NewColor;
end;

procedure TFrmAddDetail.BtnEntryMakerEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clSkyBlue);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.BtnEntryMakerExit(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.EntryBrandNameMouseOver(NewColor: TColor);
begin
  BtnEntryBrandName.Color := NewColor;
end;

procedure TFrmAddDetail.BtnEntryBrandNameEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clSkyBlue);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.BtnEntryBrandNameExit(Sender: TObject);
begin
  EntryBrandNameMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.EntryUnitMouseOver(NewColor: TColor);
begin
  BtnEntryUnit.Color := NewColor;
end;

procedure TFrmAddDetail.BtnEntryUnitEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.BtnEntryUnitExit(Sender: TObject);
begin
  EntryUnitMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmAddDetail.BtnCancelEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmAddDetail.BtnSaveEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);
end;

procedure TFrmAddDetail.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmAddDetail.BtnGoBackEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmAddDetail.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
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
begin
  try
    with CommonDB do begin
      with Defs do begin
        with Qu2 do begin
          SQL.Text     := SQL_20120001;
          with Params do begin
            ParamByName('pUserID').AsInteger  := GetUID;
            ParamByName('pExpKey1').AsInteger := StrToInt(VarToStr(GetExpKey1));
          end;
          Open;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmAddDetail.SelectExp3(
  var Cn3: TSQLite3Connection; var DS3: TDataSource;
  var Tr3: TSQLTransaction; var Qu3: TSQLQuery);
begin
  try
    with CommonDB do begin
      with Defs do begin
        with Qu3 do begin
          SQL.Text     := SQL_20120002;
          with Params do begin
            ParamByName('pUserID').AsInteger  := GetUID;
            ParamByName('pExpKey1').AsInteger := StrToInt(VarToStr(GetExpKey1));
            if Not VarIsNull(DBLCBExp2.KeyValue) then begin
              ParamByName('pExpKey2').AsInteger := StrToInt(VarToStr(DBLCBExp2.KeyValue));
              Open;
            end;
          end;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmAddDetail.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmAddDetail.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  if ProcSave(Sender) then begin
    ProcInsert(Sender);
    ClearInputFields;
  end;
end;

procedure TFrmAddDetail.ActEntryBrandNameExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryBrandName(Sender);
end;

procedure TFrmAddDetail.ActEntryMakerExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryMaker(Sender);
end;

procedure TFrmAddDetail.ActEntryUnitExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryUnit(Sender);
end;

procedure TFrmAddDetail.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmAddDetail.DBLCBMakerChange(Sender: TObject);
begin
  if Not VarIsNull(DBLCBMaker.KeyValue) then begin
    if VarToStr(DBLCBMaker.KeyValue) <> DBEdtMakerID.Text then begin
      DBEdtMakerID.Text := DBLCBMaker.KeyValue;

      with CommonDB do begin
        with Defs do begin
          SetMakerID(DBLCBMaker.KeyValue);

          // Set BrandName ComboBox
          CloseQuery(AQuBrand);
          OpenSelectQueryWithMakerID(
            ADSBrand, AQuBrand, SQL_20140002, StrToInt(VarToStr(GetMakerID)));
          SetKeyValToDBLCB(
            DBLCBBrandName, DBEdtBrandNameID,
            StrToInt(VarToStr(DBLCBMaker.KeyValue)));
          // Set KeyValue
          DBLCBBrandName.KeyValue := -1;
          DBEdtBrandNameID.Text   := '';
        end;
      end;
    end;
  end;
end;

procedure TFrmAddDetail.DBLCBBrandNameChange(Sender: TObject);
begin
  if Not VarIsNull(DBLCBBrandName.KeyValue) then begin
    if VarToStr(DBLCBBrandName.KeyValue) <> DBEdtBrandNameID.Text then begin
      DBEdtBrandNameID.Text := DBLCBBrandName.KeyValue;

      with Defs do begin
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

      with CommonDB do begin
        with Defs do begin
          SetExpKey2(DBLCBExp2.KeyValue);
        end;

        with AQuExp3 do begin
          CloseQuery(AQuExp3);

          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SelectExp3(ACn, ADSExp3, ATr, AQuExp3);
          if RecordCount = 0 then begin
            DBEdtExpKey3.Text := '';
          end;
        end;
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

        with Defs do begin
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

      with Defs do begin
        SetTaxRateID(FieldByName('TAX_RATE_ID').AsVariant);
      end;

      FTaxRate := FieldByName('TAX_RATE').AsInteger / 100;
    end;

    if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 1)
      Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 2) then begin
      if (DBEdtExcludeTax.Text <> '')
        And (StrToInt(DBEdtExcludeTax.Text) <> 0) then begin
          EdtTax.Text := FormatFloat('#,##0', Round(StrToInt(VarToStr(DBEdtExcludeTax.Text)) * FTaxRate));
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

      if (DBEdtExcludeTax.Text <> '')
          And (StrToInt(DBEdtExcludeTax.Text) <> 0) then begin
        EdtTax.Text :=
          FormatFloat('#,##0', Round(StrToInt(DBEdtExcludeTax.Text) * FTaxRate));
      end else begin
        EdtTax.Text := FormatFloat('#,##0', 0);
      end;
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

  Shape6.Visible := False;
end;

procedure TFrmAddDetail.EdtQuantityExit(Sender: TObject);
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
      SetExcludeTax(StrToInt(DBEdtExcludeTax.Text));
      EdtAmount.Text
        := FormatFloat(
          '#,##0.000',
          StrToInt(VarToStr(GetExcludeTax)) / StrToInt(VarToStr(GetQuantity)));
  end else begin
    EdtAmount.Text := FormatFloat('#,##0.000', 0);
  end;

  Shape7.Visible := False;
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

  if (Not VarIsNull(DBLCBTaxType.KeyValue))
    And ((StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 1)
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

  Shape9.Visible := False;
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

  Shape10.Visible := False;
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
  if (EdtSubTotal.Text <> '') then begin
    DBEdtSubTotal.Text := StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll]);
  end else begin
    DBEdtSubTotal.Text := '';
  end;

  if (DBEdtSubTotal.Text <> '')
    And (StrToInt(DBEdtSubTotal.Text) >= 0) then begin
    SetSubTotal(DBEdtSubTotal.Text);
  end else begin
    SetSubTotal(0);
  end;

  if Not VarIsNull(DBLCBTaxType.KeyValue) then begin
    if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 1)
      Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 2) then begin
      if StrToInt(VarToStr(GetSubTotal)) >= 0 then begin
        EdtSubTotal.Text := FormatFloat('#,##0', StrToInt(VarToStr(GetSubTotal)));
      end else begin
        EdtQuantity.Text   := '';
        EdtExcludeTax.Text := '';
        EdtTax.Text        := '';
        EdtSubTotal.Text   := '';
      end;
    end else if (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 3)
      Or (StrToInt(VarToStr(DBLCBTaxType.KeyValue)) = 4) then begin
      if StrToInt(VarToStr(GetSubTotal)) >= 0 then begin
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
            //And (StrToInt(VarToStr(GetExcludeTax)) <> 0)
            And (Not VarIsNull(GetQuantity))
            And (VarToStr(GetQuantity) <> '')
            And (StrToInt(VarToStr(GetQuantity)) > 0) then begin
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

  Shape11.Visible := False;
end;

procedure TFrmAddDetail.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    with Defs do begin
      CloseQuery(AQu);
      CloseQuery(AQuNextID);
      CloseQuery(AQuMaker);
      CloseQuery(AQuBrand);
      CloseQuery(AQuExp2);
      CloseQuery(AQuExp3);
      CloseQuery(AQuUnit);
      CloseQuery(AQuTaxType);
    end;
  end;

  // Go back to the screen
  with Defs do begin
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
  end;

  CloseAction                  := caFree;
  FrmAddDetail                 := nil;
end;

procedure TFrmAddDetail.FormCreate(Sender: TObject);
begin
  with Defs do begin
    //SetDatabaseNames;

    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  SetGoBack(True);
end;

procedure TFrmAddDetail.FormShow(Sender: TObject);
begin
  FrmAddDetail.Width      := 737;

  FrmAddDetail.KeyPreview := True;

  FrmAddDetail.Width := 737;

  FrmAddDetail.Color      := RGB(112, 168, 175);
  PnlEntryMaker.Color     := RGB( 72, 122, 129);
  PnlEntryBrandName.Color := RGB( 72, 122, 129);
  PnlEntryUnit.Color      := RGB( 72, 122, 129);
  PnlCancel.Color         := RGB( 72, 122, 129);
  PnlSave.Color         := RGB( 72, 122, 129);
  PnlGoBack.Color         := RGB( 72, 122, 129);

  { Debug }
  //FrmAddDetail.Width := 1212;
end;

procedure TFrmAddDetail.FormActivate(Sender: TObject);
var
  LNextDetailID : Integer;
begin
  with CommonDB do begin
    SetSQLite3DatabaseName;

    if Not ATr.Active then begin
      ATr.StartTransaction;
    end;

    with Defs do begin
      // NextID
      with AQuNextID do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQueryWithHeaderID(
          ADSNextID, AQuNextID, SQL_20120003, GetHID);
        LNextDetailID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
        CloseQuery(AQuNextID);
      end;

      with AQu do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SQL.Text := SQL_20120006;
        with Params do begin
          ParamByName('pUserID').AsInteger   := GetUID;
          ParamByName('pHeaderID').AsInteger := GetHID;
          ParamByName('pDetailID').AsInteger := LNextDetailID;
        end;
        Open;
        Edit;
      end;

      // Maker
      with AQuMaker do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        with AQuMaker do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SQL.Text := SQL_20130002;
          with Params do begin
            ParamByName('pUserID').AsInteger := GetUID;
          end;
          Open;
        end;

        OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
        if Not VarIsNull(GetMakerID) then begin
          SetKeyValToDBLCB(
            DBLCBMaker, DBEdtMakerID, StrToInt(VarToStr(GetMakerID)));
        end else begin
          DBLCBMaker.KeyValue := -1;
          DBEdtMakerID.Text   := '';
        end;
      end;

      // Brand
      with AQuBrand do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        if (VarIsNull(GetMakerID))
            Or (VarToStr(GetMakerID) = '')
            Or (VarToStr(GetMakerID) = '0') then begin
          SetMakerID(0);
        end;
        OpenSelectQueryWithMakerID(
          ADSBrand, AQuBrand, SQL_20140002,
          StrToInt(VarToStr(GetMakerID)));
        if Not VarIsNull(GetBrandNameID) then begin
          SetKeyValToDBLCB(
            DBLCBBrandName, DBEdtBrandNameID,
            StrToInt(VarToStr(GetBrandNameID)));
        end else begin
          DBLCBBrandName.KeyValue := -1;
          DBEdtBrandNameID.Text   := '';
        end;
      end;

      // Exp2
      with AQuExp2 do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        DBEdtExpKey1.Text := GetExpKey1;
        SelectExp2(ACn, ADSExp2, ATr, AQuExp2);
        if Not VarIsNull(GetExpKey2) then begin
            DBEdtExpKey2.Text := VarToStr(GetExpKey2);
            DBLCBExp2.KeyValue := GetExpKey2;
        end else begin
          DBLCBExp2.KeyValue := -1;
          DBEdtExpKey2.Text  := '';
        end;
      end;

      // Exp3
      with AQuExp3 do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SelectExp3(ACn, ADSExp3, ATr, AQuExp3);
        if Not VarIsNull(GetExpKey3) then begin
            DBEdtExpKey3.Text := VarToStr(GetExpKey3);
            DBLCBExp3.KeyValue := GetExpKey3;
        end else begin
          DBLCBExp3.KeyValue := -1;
          DBEdtExpKey3.Text  := '';
        end;
      end;

      // Unit
      with AQuUnit do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQueryByUnit(ADSUnit, AQuUnit, SQL_20150001);
        if Not VarIsNull(GetUnitID) then begin
          SetKeyValToDBLCB(
            DBLCBUnit, DBEdtUnitID,
            StrToInt(VarToStr(GetUnitID)));
        end else begin
          DBLCBUnit.KeyValue := -1;
          DBEdtUnitID.Text   := '';
        end;
      end;

      // TaxType
      with AQuTaxType do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQuery(ADSTaxType, AQuTaxType, SQL_20120004);
        if Not VarIsNull(GetTaxTypeID) then begin
          SetKeyValToDBLCB(
            DBLCBTaxType, DBEdtTaxTypeID,
            StrToInt(VarToStr(GetTaxTypeID)));
        end else begin
          DBLCBTaxType.KeyValue := -1;
          DBEdtTaxTypeID.Text   := '';
        end;
      end;

      // Quantity
      if GetQuantity > 0 then begin
          DBEdtQuantity.Text := IntToStr(GetQuantity);
          EdtQuantity.Text   := FormatFloat('#,##0', GetQuantity);
      end else begin
        EdtQuantity.Text     := FormatFloat('#,##0', 0);
      end;

      // ExcludeTax
      if GetExcludeTax <> 0 then begin
          DBEdtExcludeTax.Text := IntToStr(GetExcludeTax);
          EdtExcludeTax.Text   := FormatFloat('#,##0', GetExcludeTax);
      end else begin
        EdtExcludeTax.Text     := FormatFloat('#,##0', 0);
      end;

      // Amount
      if (GetExcludeTax <> 0)
          And (GetQuantity > 0) then begin
        EdtAmount.Text := FormatFloat('#,##0.000', GetExcludeTax / GetQuantity);
      end else begin
        EdtAmount.Text := FormatFloat('#,##0.000', 0);
      end;

      // Tax
      if GetTax <> 0 then begin
          DBEdtTax.Text := IntToStr(GetTax);
          EdtTax.Text   := FormatFloat('#,##0', GetTax);
      end else begin
        EdtTax.Text     := FormatFloat('#,##0', 0);
      end;

      // SubTotal
      if GetSubTotal <> 0 then begin
          DBEdtSubTotal.Text := IntToStr(GetSubTotal);
          EdtSubTotal.Text   := FormatFloat('#,##0', GetSubTotal);
      end else begin
        EdtSubTotal.Text     := FormatFloat('#,##0', 0);
      end;

      DBEdtUserID.Text   := IntToStr(GetUID);
      DBEdtHeaderID.Text := IntToStr(GetHID);
      DBEdtDetailID.Text := IntToStr(LNextDetailID);

      SetEntryMaker(0);
      SetEntryAccount(0);
      SetEntryUnit(0);
    end;
  end;
  //Timer1.Enabled := True;
end;

procedure TFrmAddDetail.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnEntryMaker' then begin
      ActEntryMaker.Execute;
    end else if ActiveControl.Name = 'BtnEntryBrandName' then begin
      ActEntryBrandName.Execute;
    end else if ActiveControl.Name = 'BtnEntryUnit' then begin
      ActEntryUnit.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

procedure TFrmAddDetail.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False; // １回だけ実行して止める

  //ShowMessage('--- タイマー実行時点の状態 ---' + sLineBreak +
  //            'AQuMaker.Active: '       + BoolToStr(AQuMaker.Active, True) + sLineBreak +
  //            'AQuMaker.RecordCount: '  + IntToStr(AQuMaker.RecordCount) + sLineBreak +
  //            'CommonDB.ATr.Active: '   + BoolToStr(CommonDB.ATr.Active, True) + sLineBreak +
  //            'CommonDB.ACn.Connected: '+ BoolToStr(CommonDB.ACn.Connected, True)
  //           );
end;

end.

