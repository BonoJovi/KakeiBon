unit UAddDetail;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, DB, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, DBCtrls, LCLIntf, LCLType, ActnList,
  DBDateTimePicker;

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
    ActSave           : TAction;
    ActGoBack         : TAction;
    DBLCBMaker        : TDBLookupComboBox;
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
    Timer: TTimer;
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
    procedure EdtQuantityChange(Sender: TObject);
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
    procedure TimerTimer(Sender: TObject);
  private
    FPressBtnUp   : Boolean;
    FInsert       : Boolean;
    FGoBack       : Boolean;
    FTaxRate      : Double;
    //FQuantity     : Integer;
    //FAmount       : Single;
    //FExcludeTax   : Single;
    //FTax          : Single;
    //FSubTotal     : Single;
    procedure BackupValues;
    procedure CalcInclusiveTax;
    procedure ClearInputFields;
    function GetGoBack: Boolean;
    procedure SetGoBack(GoBack: boolean);
    procedure SelectExp2(var Qu2: TSQLQuery);
    procedure SelectExp3(var Qu3: TSQLQuery);
  public

  end;

var
  FrmAddDetail: TFrmAddDetail;

implementation
uses
  LazLogger, UConsts, UDefs, UDBAccess, UCommonDB, UManageDetails,
  UEditDetailsHeader, UEntryBrandName, UEntryMaker, UEntryUnit;

{$R *.lfm}

{ TFrmAddDetail }

procedure TFrmAddDetail.BackupValues;
begin
  with Defs do begin
    with DBEdtHeaderID do begin
      if Text <> '' then begin
        SetHID(StrToInt(Text));
      end else begin
        SetHID(0);
      end;
    end;

    with DBEdtDetailID do begin
      if Text <> '' then begin
        SetDID(StrToInt(Text));
      end else begin
        SetDID(0);
      end;
    end;

    with DBEdtMakerID do begin
      if Text <> '' then begin
        SetMakerID(StrToInt(Text));
      end else begin
        SetMakerID(0);
      end;
    end;

    with DBEdtBrandNameID do begin
      if Text <> '' then begin
        SetBrandNameID(StrToInt(Text));
      end else begin
        SetBrandNameID(0);
      end;
    end;

    with DBEdtExpKey1 do begin
      if Text <> '' then begin
        SetExpKey1(StrToInt(Text));
      end else begin
        SetExpKey1(0);
      end;
    end;

    with DBEdtExpKey2 do begin
      if Text <> '' then begin
        SetExpKey2(StrToInt(Text));
      end else begin
        SetExpKey2(0);
      end;
    end;

    with DBEdtExpKey3 do begin
      if Text <> '' then begin
        SetExpKey3(StrToInt(Text));
      end else begin
        SetExpKey3(0);
      end;
    end;

    with DBEdtUnitID do begin
      if Text <> '' then begin
        SetUnitID(StrToInt(Text));
      end else begin
        SetUnitID(0);
      end;
    end;

    with DBEdtTaxTypeID do begin
      if Text <> '' then begin
        SetTaxTypeID(StrToInt(Text));
      end else begin
        SetTaxTypeID(0);
      end;
    end;

    with AQuTaxType do begin
      if Active then begin
        with DBLCBTaxType do begin
          if VarToInt(KeyValue) > 0 then begin
            First;
            while FieldByName('TAX_TYPE_ID').AsInteger <> VarToInt(KeyValue) do begin
              if EOF then begin
                break;
              end;
              Next;
            end;
            SetTaxRateID(FieldByName('TAX_RATE_ID').AsInteger);
          end else begin
            SetTaxTypeID(0);
            SetTaxRateID(0);
          end;
        end;
      end;
    end;

    if DBEdtQuantity.Text <> '' then begin
      SetQuantity(StrToInt(DBEdtQuantity.Text));
    end else begin
      SetQuantity(1);
    end;

    if EdtAmount.Text <> '' then begin
      SetAmount(StrToFloat(StringReplace(EdtAmount.Text, ',', '', [rfReplaceAll])));
    end else begin
      SetAmount(0);
    end;

    if DBEdtExcludeTax.Text <> '' then begin
      SetExcludeTax(StrToFloat(DBEdtExcludeTax.Text));
    end else begin
      SetExcludeTax(0);
    end;

    if DBEdtTax.Text <> '' then begin
      SetTax(StrToFloat(DBEdtTax.Text));
    end else begin
      SetTax(0);
    end;

    if DBEdtSubTotal.Text <> '' then begin
      SetSubTotal(StrToFloat(DBEdtSubTotal.Text));
    end else begin
      SetSubTotal(0);
    end;
  end;
end;

procedure TFrmAddDetail.CalcInclusiveTax;
begin
  if (DBEdtSubTotal.Text <> '')
      And (StrToFloat(DBEdtSubTotal.Text) <> 0.0) then begin
    DBEdtTax.Text :=
      IntToStr(Round(StrToFloat(DBEdtSubTotal.Text) / (1 + FTaxRate) * FTaxRate));
    EdtTax.Text   := FormatFloat('#,##0', StrToFloat(DBEdtTax.Text));

    DBEdtExcludeTax.Text :=
      IntToStr(Round(StrToFloat(DBEdtSubTotal.Text) - StrToFloat(DBEdtTax.Text)));
    EdtExcludeTax.Text := FormatFloat('#,##0', StrToFloat(DBEdtExcludeTax.Text));

    if (DBEdtExcludeTax.Text <> '')
        And (StrToFloat(DBEdtExcludeTax.Text) <> 0)
        And (DBEdtQuantity.Text <> '')
        And (StrToInt(DBEdtQuantity.Text) > 0) then begin
          EdtAmount.Text :=
            FormatFloat('#,##0.000',
            StrToFloat(DBEdtExcludeTax.Text) / StrToInt(DBEdtQuantity.Text));
    end else begin
      EdtAmount.Text := FormatFloat('#,##0.000', 0);
    end;
  end;
end;

procedure TFrmAddDetail.ClearInputFields;
var
  LNextID : Integer;
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
        LNextID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
        CloseQuery(AQuNextID);
      end;

      SetMakerID(0);
      SetBrandNameID(0);
      SetExpKey2(0);
      SetExpKey3(0);
      SetUnitID(0);
      SetTaxTypeID(0);

      SetQuantity(1);
      SetAmount(0);
      SetExcludeTax(0);
      SetTax(0);
      SetSubTotal(0);

      DBEdtDetailID.Text                := IntToStr(LNextID);
      DBLCBMaker.KeyValue     := -1;
      DBLCBBrandName.KeyValue := -1;
      DBLCBExp2.KeyValue      := -1;
      DBLCBExp3.KeyValue      := -1;
      DBLCBUnit.KeyValue      := -1;
      DBLCBTaxType.KeyValue   := -1;

      DBEdtMakerID.Text       := IntToStr(0);
      DBEdtBrandNameID.Text   := IntToStr(0);
      DBEdtExpKey2.Text       := IntToStr(0);
      DBEdtExpKey3.Text       := IntToStr(0);
      DBEdtUnitID.Text        := IntToStr(0);
      DBEdtTaxTypeID.Text     := IntToStr(0);

      EdtQuantity.Text        := IntToStr(1);
      EdtAmount.Text          := FloatToStr(0.0);
      EdtExcludeTax.Text      := FloatToStr(0.0);
      EdtTax.Text             := FloatToStr(0.0);
      EdtSubTotal.Text        := FloatToStr(0.0);

      DBEdtQuantity.Text      := IntToStr(1);
      DBEdtExcludeTax.Text    := FloatToStr(0.0);
      DBEdtTax.Text           := FloatToStr(0.0);
      DBEdtSubTotal.Text      := FloatToStr(0.0);
    end;
  end;
end;

procedure TFrmAddDetail.ProcInsert(Sender: TObject);
begin
  if Not FInsert then begin
    with AQu do begin
      //Edit;
      if AQu.RecordCount > 0 then begin
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

procedure TFrmAddDetail.EdtQuantityChange(Sender: TObject);
begin
  with Defs do begin
    if (EdtQuantity.Text <> '') then begin
      if (StrToInt(EdtQuantity.Text) <= 0) then begin
        MessageDlg(MSG_JP_000044, mtInformation, [mbOk], 0);
        SetQuantity(1);
        EdtQuantity.Text := IntToStr(GetQuantity);
      end;
    end else begin
      SetQuantity(1);
      EdtQuantity.Text := IntToStr(GetQuantity);
    end;
  end;
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
  Result := False;
  try
    try
      with CommonDB do begin
        with Defs do begin
          if GetDID = 0 then begin
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

            with ATr do begin
              if Not Active then begin
                StartTransaction;
              end;
            end;

            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20120007;
            with Params do begin
              ParamByName('pUserID'     ).AsInteger   := GetUID;
              ParamByName('pHeaderID'   ).AsInteger   := GetHID;
              ParamByName('pDetailID'   ).AsInteger   := GetDID;
              ParamByName('pExpKey1'    ).AsInteger   := GetExpKey1;
              if VarToInt(DBLCBExp2.KeyValue) > 0 then begin
                SetExpKey2(VarToInt(DBLCBExp2.KeyValue));
                ParamByName('pExpKey2'    ).AsInteger   := GetExpKey2;
              end else begin
                SetExpKey2(0);
                ParamByName('pExpKey2'    ).AsInteger   := 0;
              end;
              if VarToInt(DBLCBExp3.KeyValue) > 0 then begin
                SetExpKey3(VarToInt(DBLCBExp3.KeyValue));
                ParamByName('pExpKey3'    ).AsInteger   := GetExpKey3;
              end else begin
                SetExpKey3(0);
                ParamByName('pExpKey3'    ).AsInteger   := 0;
              end;
              if VarToInt(DBLCBMaker.KeyValue) > 0 then begin
                SetMakerID(VarToInt(DBLCBMaker.KeyValue));
                ParamByName('pMakerID'    ).AsInteger   := GetMakerID;
              end else begin
                SetMakerID(0);
                MessageDlg(MSG_JP_000032, mtInformation, [mbOK], 0);
                DBLCBMaker.SetFocus;
                Exit;
              end;

              if VarToInt(DBLCBBrandName.KeyValue) > 0 then begin
                SetBrandNameID(VarToInt(DBLCBBrandName.KeyValue));
                ParamByName('pBrandNameID').AsInteger   := GetBrandNameID;
              end else begin
                SetBrandNameID(0);
                MessageDlg(MSG_JP_000035, mtInformation, [mbOK], 0);
                DBLCBBrandName.SetFocus;
                Exit;
              end;

              if VarToInt(DBLCBUnit.KeyValue) > 0 then begin
                SetUnitID(VarToInt(DBLCBUnit.KeyValue));
                ParamByName('pUnitID'     ).AsInteger := GetUnitID;
              end else begin
                SetUnitID(0);
                MessageDlg(MSG_JP_000036, mtInformation, [mbOK], 0);
                DBLCBUnit.SetFocus;
                Exit;
              end;

              if VarToInt(DBLCBTaxType.KeyValue) > 0 then begin
                SetTaxTypeID(VarToInt(DBLCBTaxType.KeyValue));
                ParamByName('pTaxTypeID'  ).AsInteger := GetTaxTypeID;
                ParamByName('pTaxRateID'  ).AsInteger := AQuTaxType.FieldByName('TAX_RATE_ID').AsInteger;
              end else begin
                SetTaxTypeID(0);
                MessageDlg(MSG_JP_000037, mtInformation, [mbOK], 0);
                DBLCBTaxType.SetFocus;
                Exit;
              end;
              if EdtQuantity.Text <> '' then begin
                SetQuantity(StrToInt(EdtQuantity.Text));
                ParamByName('pQuantity'   ).AsInteger := GetQuantity;
              end else begin
                SetQuantity(1);
                MessageDlg(MSG_JP_000038, mtInformation, [mbOK], 0);
                EdtQuantity.SetFocus;
                Abort;
              end;
              ParamByName('pExcludeTax' ).AsInteger    := Round(GetExcludeTax);
              ParamByName('pTax'        ).AsInteger    := Round(GetTax);
              ParamByName('pSubTotal'   ).AsInteger    := Round(GetSubTotal);
              ParamByName('pEntryDT'    ).AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              ParamByName('pUpdateDT'   ).AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
            end;

            ExecSQL;
            ATr.Commit;
          end;
        end;

        ClearInputFields;
        //DBEdtMakerID.Text     := IntToStr(0);
        //DBEdtBrandNameID.Text := IntToStr(0);
        //DBEdtExpKey2.Text     := IntToStr(0);
        //DBEdtExpKey3.Text     := IntToStr(0);
        //DBEdtUnitID.Text      := IntToStr(0);
        //DBEdtTaxTypeID.Text   := IntToStr(0);
        //
        //DBEdtQuantity.Text    := IntToStr(0);
        //DBEdtExcludeTax.Text  := IntToStr(0);
        //DBEdtTax.Text         := IntToStr(0);
        //DBEdtSubTotal.Text    := IntToStr(0);

        FormActivate(Self);
      end;
      Result := True;
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

procedure TFrmAddDetail.SelectExp2(var Qu2: TSQLQuery);
begin
  try
    with CommonDB do begin
      with Defs do begin
        with Qu2 do begin
          SQL.Text     := SQL_20120001;
          with Params do begin
            ParamByName('pUserID').AsInteger  := GetUID;
            ParamByName('pExpKey1').AsInteger := GetExpKey1;
          end;
          Open;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmAddDetail.SelectExp3(var Qu3: TSQLQuery);
begin
  try
    with CommonDB do begin
      with Defs do begin
        with Qu3 do begin
          SQL.Text     := SQL_20120002;
          with Params do begin
            ParamByName('pUserID').AsInteger  := GetUID;
            ParamByName('pExpKey1').AsInteger := GetExpKey1;
            with DBLCBExp2 do begin
              if Not VarIsNull(KeyValue) then begin
                ParamByName('pExpKey2').AsInteger := VarToInt(KeyValue);
                Open;
              end;
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
  FormActivate(Sender);
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
  with CommonDB do begin
    with Defs do begin
      with DBLCBMaker do begin
        if VarToInt(KeyValue) > 0 then begin
          if VarToStr(KeyValue) <> DBEdtMakerID.Text then begin
            DBEdtMakerID.Text := VarToStr(KeyValue);

            SetMakerID(VarToInt(KeyValue));

            // Set BrandName ComboBox
            CloseQuery(AQuBrand);
            OpenSelectQueryWithMakerID(
              ADSBrand, AQuBrand, SQL_20140002, GetMakerID);
            SetKeyValToDBLCB(
              DBLCBBrandName, DBEdtBrandNameID, VarToInt(KeyValue));
            // Set KeyValue
            DBLCBBrandName.KeyValue := -1;
            DBEdtBrandNameID.Text   := IntToStr(0);
          end;
        end else begin
          with DBEdtMakerID do begin
            if (DBEdtMakerID.Text <> '')
                And (StrToInt(DBEdtMakerID.Text) > 0) then begin
              with DBLCBMaker do begin
                SetMakerID(StrToInt(Text));

                CloseQuery(AQuBrand);
                OpenSelectQueryWithMakerID(
                  ADSBrand, AQuBrand, SQL_20140002, GetMakerID);
                SetKeyValToDBLCB(
                  DBLCBBrandName, DBEdtBrandNameID, VarToInt(KeyValue));
              end;
            end;
          end;
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
        with DBLCBBrandName do begin
          SetBrandNameID(VarToInt(KeyValue));
        end;
      end;
    end;
  end else begin
    DBEdtBrandNameID.Text := IntToStr(0);
  end;
end;

procedure TFrmAddDetail.DBLCBExp2Change(Sender: TObject);
begin
  if Not VarIsNull(DBLCBExp2.KeyValue) then begin
    if VarToStr(DBLCBExp2.KeyValue) <> DBEdtExpKey2.Text then begin
      DBEdtExpKey2.Text := DBLCBExp2.KeyValue;

      with CommonDB do begin
        with Defs do begin
          with DBLCBExp2 do begin
            SetExpKey2(VarToInt(KeyValue));
          end;
        end;

        with AQuExp3 do begin
          CloseQuery(AQuExp3);

          SQLConnection  := ACn;
          SQLTransaction := ATr;

          SelectExp3(AQuExp3);
          if RecordCount = 0 then begin
            DBEdtExpKey3.Text := IntToStr(0);
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmAddDetail.DBLCBExp3Change(Sender: TObject);
begin
  with Defs do begin
    with DBLCBExp3 do begin
      if VarToInt(KeyValue) > 0 then begin
        if VarToStr(KeyValue) <> DBEdtExpKey3.Text then begin
          DBEdtExpKey3.Text := KeyValue;

          with Defs do begin
            SetExpKey3(VarToInt(KeyValue));
          end;
        end else begin
          DBEdtExpKey3.Text := IntToStr(0);
        end;
      end else begin
        DBEdtExpKey3.Text := IntToStr(0);
      end;
    end;
  end;
end;

procedure TFrmAddDetail.DBLCBUnitChange(Sender: TObject);
begin
  with DBEdtUnitID do begin
    Text := VarToStr(DBLCBUnit.KeyValue);
    with Defs do begin
      if Text <> '' then begin
        SetUnitID(StrToInt(Text));
      end;
    end;
  end;
end;

procedure TFrmAddDetail.DBLCBTaxTypeChange(Sender: TObject);
begin
  DBEdtTaxTypeID.Text := VarToStr(DBLCBTaxType.KeyValue);

  with Defs do begin
    if Not VarIsNull(DBLCBTaxType.KeyValue) then begin
      with AQuTaxType do begin
        First;
        while Not EOF do begin
          if FieldByName('TAX_TYPE_ID').AsInteger = VarToInt(DBLCBTaxType.KeyValue) then begin
            Break;
          end;
          Next;
        end;

        with Defs do begin
          SetTaxRateID(FieldByName('TAX_RATE_ID').AsInteger);
        end;

        FTaxRate := FieldByName('TAX_RATE').AsInteger / 100;
      end;

      if (VarToInt(DBLCBTaxType.KeyValue) = 1)
          Or (VarToInt(DBLCBTaxType.KeyValue) = 2) then begin
        with DBEdtExcludeTax do begin
          if (Text <> '')
              And (StrToFloat(Text) <> 0.0) then begin
            EdtTax.Text := FormatFloat('#,##0', Round(StrToFloat(Text) * FTaxRate));
          end else begin
            EdtTax.Text := FormatFloat('#,##0', 0);
          end;
        end;
      end else if ((VarToInt(DBLCBTaxType.KeyValue) = 3)
          Or (VarToInt(DBLCBTaxType.KeyValue) = 4))
          And (EdtSubTotal.Text <> '') then begin
        CalcInclusiveTax;
      end else if (VarToInt(DBLCBTaxType.KeyValue) = 5) then begin
        DBEdtTax.Text := IntToStr(0);
        EdtTax.Text := DBEdtTax.Text;
        with DBEdtExcludeTax do begin
          if Text <> '' then begin
            Text := DBEdtSubTotal.Text;
            EdtSubTotal.Text
              := FormatFloat('#,##0', StrToFloat(DBEdtSubTotal.Text));
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmAddDetail.DBLCBTaxTypeExit(Sender: TObject);
begin
  DBEdtTaxTypeID.Text := VarToStr(DBLCBTaxType.KeyValue);

  with Defs do begin
    if (Not VarIsNull(DBLCBTaxType.KeyValue)) And (EdtExcludeTax.Text <> '') then begin
      EdtAmount.TabStop  := False;
      EdtAmount.ReadOnly := True;
      if (VarToInt(DBLCBTaxType.KeyValue) = 1)
            Or (VarToInt(DBLCBTaxType.KeyValue) = 2) then begin
        with EdtExcludeTax do begin
          TabStop  := True;
          ReadOnly := False;
        end;
        with EdtTax do begin
          TabStop         := True;
          ReadOnly        := False;
        end;

        if (DBEdtExcludeTax.Text <> '')
            And (StrToFloat(DBEdtExcludeTax.Text) <> 0) then begin
          EdtTax.Text :=
            FormatFloat('#,##0', Round(StrToFloat(DBEdtExcludeTax.Text) * FTaxRate));
        end else begin
          EdtTax.Text := FormatFloat('#,##0', 0);
        end;
      end else if ((VarToInt(DBLCBTaxType.KeyValue) = 3)
        Or (VarToInt(DBLCBTaxType.KeyValue) = 4))
        And (EdtSubTotal.Text <> '') then begin
          with EdtExcludeTax do begin
            TabStop  := False;
            ReadOnly := True;
          end;
          with EdtTax do begin
            TabStop         := False;
            ReadOnly        := True;
          end;

          CalcInclusiveTax;
      end else if (VarToInt(DBLCBTaxType.KeyValue) = 5) then begin
        // Tax Free
        with EdtExcludeTax do begin
          TabStop  := False;
          ReadOnly := True;
        end;
        with EdtTax do begin
          TabStop         := False;
          ReadOnly        := True;
        end;

        DBEdtTax.Text := IntToStr(0);
        EdtTax.Text := DBEdtTax.Text;
        with DBEdtExcludeTax do begin
          if (Text <> '')
            And (StrToFloat(Text) <> 0) then begin
            Text := DBEdtSubTotal.Text;
            EdtSubTotal.Text
              := FormatFloat('#,##0', StrToFloat(DBEdtSubTotal.Text));
          end else begin
            Text := IntToStr(0);
            EdtSubTotal.Text
              := FormatFloat('#,##0', 0);
          end;
        end;
      end;
    end;
  end;

  Shape6.Visible := False;
end;

procedure TFrmAddDetail.EdtQuantityExit(Sender: TObject);
begin
  with Defs do begin
    with DBEdtQuantity do begin
      Text := StringReplace(EdtQuantity.Text, ',', '', [rfReplaceAll]);
      if Text <> '' then begin
        SetQuantity(StrToInt(Text));
      end else begin
        SetQuantity(1);
      end;
    end;

    with DBEdtExcludeTax do begin
      if (Text <> '')
          And (StrToFloat(Text) <> 0)
          And (GetQuantity > 0) then begin
        SetExcludeTax(StrToFloat(Text));
        EdtAmount.Text
          := FormatFloat('#,##0.000', GetExcludeTax / GetQuantity);
      end else begin
        EdtAmount.Text := FormatFloat('#,##0.000', 0);
      end;
    end;
  end;

  Shape7.Visible := False;
end;

procedure TFrmAddDetail.EdtAmountChange(Sender: TObject);
begin
  with Defs do begin
    with EdtAmount do begin
      SetAmount(StrToFloat(
        StringReplace(Text, ',', '', [rfReplaceAll])));
    end;
  end;
end;

procedure TFrmAddDetail.EdtExcludeTaxExit(Sender: TObject);
begin
  FTaxRate := AQuTaxType.FieldByName('TAX_RATE').AsInteger / 100;

  with Defs do begin
    with DBEdtExcludeTax do begin
      Text := StringReplace(EdtExcludeTax.Text, ',', '', [rfReplaceAll]);

      if Text <> '' then begin
        SetExcludeTax(StrToFloat(Text));
      end else begin
        SetExcludeTax(0);
      end;
    end;

    with DBEdtQuantity do begin
      if Text <> '' then begin
        SetQuantity(StrToInt(Text));
      end else begin
        SetQuantity(1);
      end;
    end;
    with DBLCBTaxType do begin
      if (Not VarIsNull(KeyValue))
          And ((VarToInt(KeyValue) = 1)
            Or (VarToInt(KeyValue) = 2))
          And (GetExcludeTax <> 0)
          And (GetQuantity > 0) then begin
        EdtAmount.Text
          := Format('%.3n', [(GetExcludeTax / GetQuantity)]);
        EdtExcludeTax.Text
          := Format('%.0n', [GetExcludeTax]);
        with DBEdtTax do begin
          Text := IntToStr(Round(GetExcludeTax * FTaxRate));
          EdtTax.Text        := Format('%.0n', [StrToFloat(Text)]);
          DBEdtSubTotal.Text := IntToStr(Round(StrToFloat(DBEdtExcludeTax.Text) + StrToFloat(Text)));
          EdtSubTotal.Text   := Format('%.0n', [StrToFloat(DBEdtSubTotal.Text)]);
        end;
      end else begin
        with DBEdtTax do begin
          EdtAmount.Text     := Format('%.3n', [0.0]);
          Text      := IntToStr(0);
          EdtTax.Text        := Format('%.0n', [StrToFloat(Text)]);
        end;
        with DBEdtSubTotal do begin
          Text := IntToStr(0);
          EdtSubTotal.Text   := Format('%.0n', [StrToFloat(Text)]);
        end;
      end;
    end;
  end;

  Shape9.Visible := False;
end;

procedure TFrmAddDetail.EdtTaxChange(Sender: TObject);
begin
  with Defs do begin
    with DBEdtTax do begin
      if (EdtTax.Text <> '')
        And (StrToFloat(StringReplace(EdtTax.Text, ',', '', [rfReplaceAll])) > 0.0) then begin
        Text := StringReplace(EdtTax.Text, ',', '', [rfReplaceAll]);
      end else begin
        Text := '0.0';
      end;
      SetTax(StrToFloat(Text));
    end;
  end;
end;

procedure TFrmAddDetail.EdtTaxExit(Sender: TObject);
begin
  with Defs do begin
    EdtSubTotal.Text := Format('%.0n', [GetExcludeTax + GetTax]);
  end;

  Shape10.Visible := False;
end;

procedure TFrmAddDetail.EdtSubTotalChange(Sender: TObject);
begin
  if (EdtSubTotal.Text <> '-') then begin
    if (EdtSubTotal.Text <> '')
      And (StrToFloat(StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll])) <> 0.0) then begin
      DBEdtSubTotal.Text := StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll]);
    end else begin
      DBEdtExcludeTax.Text := FloatToStr(0.0);
      DBEdtTax.Text        := FloatToStr(0.0);
      DBEdtSubTotal.Text   := FloatToStr(0.0);
    end;
  end;
end;

procedure TFrmAddDetail.EdtSubTotalExit(Sender: TObject);
begin
  with Defs do begin
    with DBEdtSubTotal do begin
      if (EdtSubTotal.Text <> '') then begin
        Text := StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll]);
      end else begin
        Text := FloatToStr(0.0);
      end;
    end;

    with DBEdtSubTotal do begin
      if (Text <> '') then begin
        SetSubTotal(StrToFloat(Text));
      end else begin
        SetSubTotal(0);
      end;
    end;

    with DBLCBTaxType do begin
      if Not VarIsNull(KeyValue) then begin
        if (VarToInt(KeyValue) = 1)
            Or (VarToInt(KeyValue) = 2) then begin
          if GetSubTotal <> 0 then begin
            EdtSubTotal.Text := Format('%.0n', [GetSubTotal]);
          end else begin
            //EdtQuantity.Text   := IntToStr(1);
            EdtExcludeTax.Text := FloatToStr(0.0);
            EdtTax.Text        := FloatToStr(0.0);
            EdtSubTotal.Text   := FloatToStr(0.0);
          end;
        end else if (VarToInt(KeyValue) = 3)
            Or (VarToInt(KeyValue) = 4) then begin
          if GetSubTotal <> 0 then begin
            CalcInclusiveTax;
          end else begin
            //EdtQuantity.Text   := IntToStr(1);
            EdtExcludeTax.Text := FloatToStr(0.0);
            EdtTax.Text        := FloatToStr(0.0);
            EdtSubTotal.Text   := FloatToStr(0.0);
          end;
        end else if (VarToInt(KeyValue) = 5) then begin
          // Tax Free
          with DBEdtTax do begin
            Text := IntToStr(0);
            EdtTax.Text := Text;
          end;
          with DBEdtExcludeTax do begin
            if DBEdtSubTotal.Text <> '' then begin
              EdtSubTotal.Text
                := FormatFloat('#,##0', StrToFloat(DBEdtSubTotal.Text));
              Text := DBEdtSubTotal.Text;
              SetExcludeTax(StrToFloat(Text));
              EdtExcludeTax.Text   := FormatFloat('#,##0', GetExcludeTax);

              if (GetExcludeTax <> 0)
                  And (GetQuantity > 0) then begin
                EdtAmount.Text
                  := FormatFloat('#,##0.000', GetExcludeTax / GetQuantity);
              end else begin
                EdtAmount.Text   := FormatFloat('#,##0.000', 0);
              end;
            end else begin
              //EdtQuantity.Text   := IntToStr(1);
              EdtExcludeTax.Text := FloatToStr(0.0);
              EdtTax.Text        := FloatToStr(0.0);
              EdtSubTotal.Text   := FloatToStr(0.0);
            end;
          end;
        end else begin
          //EdtQuantity.Text   := IntToStr(1);
          EdtExcludeTax.Text := FloatToStr(0.0);
          EdtTax.Text        := FloatToStr(0.0);
          EdtSubTotal.Text   := FloatToStr(0.0);
        end;
      end;
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
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FPressBtnUp := False;

  with Defs do begin
    SetQuantity(1);
  end;

  SetGoBack(True);

end;

procedure TFrmAddDetail.FormShow(Sender: TObject);
begin
  Self.Width              := 737;

  Self.KeyPreview         := True;

  Self.Color              := RGB(112, 168, 175);
  PnlEntryMaker.Color     := RGB( 72, 122, 129);
  PnlEntryBrandName.Color := RGB( 72, 122, 129);
  PnlEntryUnit.Color      := RGB( 72, 122, 129);
  PnlCancel.Color         := RGB( 72, 122, 129);
  PnlSave.Color         := RGB( 72, 122, 129);
  PnlGoBack.Color         := RGB( 72, 122, 129);

  { Debug }
  //Self.Width := 1212;
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
        if GetMakerID > 0 then begin
          SetKeyValToDBLCB(DBLCBMaker, DBEdtMakerID, GetMakerID);
        end else begin
          with DBLCBMaker do begin
            KeyValue          := -1;
            DBEdtMakerID.Text := IntToStr(0);
          end;
        end;
      end;

      // Brand
      with AQuBrand do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        if GetMakerID = 0 then begin
          SetMakerID(0);
        end;
        OpenSelectQueryWithMakerID(
          ADSBrand, AQuBrand, SQL_20140002, GetMakerID);
        if GetBrandNameID > 0 then begin
          SetKeyValToDBLCB(DBLCBBrandName, DBEdtBrandNameID, GetBrandNameID);
        end else begin
          with DBLCBBrandName do begin
            KeyValue              := -1;
            DBEdtBrandNameID.Text := IntToStr(0);
          end;
        end;
      end;

      // Exp2
      with AQuExp2 do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        DBEdtExpKey1.Text := IntToStr(GetExpKey1);
        SelectExp2(AQuExp2);
        with DBLCBExp2 do begin
          if GetExpKey2 > 0 then begin
            KeyValue           := GetExpKey2;
            DBEdtExpKey2.Text  := IntToStr(GetExpKey2);
          end else begin
            KeyValue           := -1;
            DBEdtExpKey2.Text  := IntToStr(0);
          end;
        end;
      end;

      // Exp3
      with AQuExp3 do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SelectExp3(AQuExp3);
        with DBLCBExp3 do begin
          if GetExpKey3 > 0 then begin
            KeyValue          := GetExpKey3;
            DBEdtExpKey3.Text := IntToStr(GetExpKey3);
          end else begin
            KeyValue          := -1;
            DBEdtExpKey3.Text := IntToStr(0);
          end;
        end;
      end;

      // Unit
      with AQuUnit do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQueryByUnit(ADSUnit, AQuUnit, SQL_20150001);
        if GetUnitID > 0 then begin
          SetKeyValToDBLCB(DBLCBUnit, DBEdtUnitID, GetUnitID);
        end else begin
          DBLCBUnit.KeyValue := -1;
          DBEdtUnitID.Text   := IntToStr(0);
        end;
      end;

      // TaxType
      with AQuTaxType do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQuery(ADSTaxType, AQuTaxType, SQL_20120004);
        if GetTaxTypeID > 0 then begin
          SetKeyValToDBLCB(DBLCBTaxType, DBEdtTaxTypeID, GetTaxTypeID);
        end else begin
          DBLCBTaxType.KeyValue := -1;
          DBEdtTaxTypeID.Text   := IntToStr(0);
        end;
      end;

      // Quantity
      if GetQuantity > 0 then begin
        DBEdtQuantity.Text := IntToStr(GetQuantity);
        EdtQuantity.Text   := FormatFloat('#,##0', GetQuantity);
      end else begin
        DBEdtQuantity.Text := IntToStr(1);
        EdtQuantity.Text   := FormatFloat('#,##0', 0);
      end;

      // ExcludeTax
      if GetExcludeTax <> 0 then begin
          DBEdtExcludeTax.Text := FloatToStr(GetExcludeTax);
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
          DBEdtTax.Text := FloatToStr(GetTax);
          EdtTax.Text   := FormatFloat('#,##0', GetTax);
      end else begin
        EdtTax.Text     := FormatFloat('#,##0', 0);
      end;

      // SubTotal
      if GetSubTotal <> 0 then begin
          DBEdtSubTotal.Text := FloatToStr(GetSubTotal);
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
  Timer.Enabled := True;
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

procedure TFrmAddDetail.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;

  with Defs do begin
    DBEdtQuantity.Text := IntToStr(GetQuantity);
  end;

  //ShowMessage('--- タイマー実行時点の状態 ---' + sLineBreak +
  //            'AQuMaker.Active: '       + BoolToStr(AQuMaker.Active, True) + sLineBreak +
  //            'AQuMaker.RecordCount: '  + IntToStr(AQuMaker.RecordCount) + sLineBreak +
  //            'CommonDB.ATr.Active: '   + BoolToStr(CommonDB.ATr.Active, True) + sLineBreak +
  //            'CommonDB.ACn.Connected: '+ BoolToStr(CommonDB.ACn.Connected, True)
  //           );
end;

end.

