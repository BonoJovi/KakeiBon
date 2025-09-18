unit UEditDetail;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, DBCtrls, LCLIntf, LCLType, ActnList,
  DBDateTimePicker;

type

  { TFrmEditDetail }

  TFrmEditDetail = class(TForm)
    ActionList1: TActionList;
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
    ActGoBack           : TAction;
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
    BtnEntryMaker: TPanel;
    BtnEntryBrandName: TPanel;
    BtnEntryUnit: TPanel;
    BtnCancel: TPanel;
    BtnSave: TPanel;
    BtnGoBack: TPanel;
    PnlSeparator      : TPanel;
    PnlCancel         : TPanel;
    PnlCommit         : TPanel;
    PnlGoBack         : TPanel;
    PnlEntryMaker     : TPanel;
    PnlEntryUnit      : TPanel;
    PnlEntryBrandName : TPanel;
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
    procedure ProcEntryMaker(Sender: TObject);
    procedure ProcEntryBrandName(Sender: TObject);
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
    procedure ActEntryMakerExecute(Sender: TObject);
    procedure ActEntryBrandNameExecute(Sender: TObject);
    procedure ActEntryUnitExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
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
    FInsert     : Boolean;
    FGoBack     : Boolean;
    FTaxRate    : Single;
    procedure BackupValues;
    procedure CalcInclusiveTax;
    procedure ClearInputFields;
    function GetGoBack: Boolean;
    procedure SetGoBack(GoBack: boolean);
    procedure SelectExp2(
      var Cn2: TSQLite3Connection; var DS2: TDataSource;
      var Tr2: TSQLTransaction; var Qu2: TSQLQuery);
    procedure SelectExp3(
      var Cn3: TSQLite3Connection; var DS3: TDataSource;
      var Tr3: TSQLTransaction; var Qu3: TSQLQuery);
  public

  end;

var
  FrmEditDetail: TFrmEditDetail;

implementation
uses
  LazLogger,UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageDetails,
  UAddDetailsHeader, UEditDetailsHeader, UEntryMaker, UEntryBrandName,
  UEntryUnit;

{$R *.lfm}

{ TFrmEditDetail }

procedure TFrmEditDetail.BackupValues;
begin
  with Defs do begin
    if DBEdtDetailID.Text <> '' then begin
      SetDID(StrToInt(DBEdtDetailID.Text));
    end else begin
      SetDID(0);
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
      if Active then begin;
        if (Not VarIsNull(DBLCBTaxType.KeyValue))
            And (VarToStr(DBLCBTaxType.KeyValue) <> '')
            And (VarToInt(DBLCBTaxType.KeyValue) > 0) then begin
          First;
          while FieldByName('TAX_TYPE_ID').AsInteger <> VarToInt(DBLCBTaxType.KeyValue) do begin
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
  with Defs do begin
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
end;

procedure TFrmEditDetail.ClearInputFields;
var
  LNextDetailID : Integer;
begin
  with CommonDB do begin
    with Defs do begin
      DBEdtUserID.Text        := IntToStr(GetUID);
      DBEdtHeaderID.Text      := IntToStr(GetHID);
      DBEdtExpKey1.Text       := IntToStr(GetExpKey1);

      with AQuNextID do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQueryWithHeaderID(ADSNextID, AQuNextID, SQL_20120003, GetHID);
        LNextDetailID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

        CloseQuery(AQu);
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

      DBEdtDetailID.Text      := IntToStr(LNextDetailID);
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
      EdtAmount.Text          := FormatFloat('#,##0.000', 0);
      EdtExcludeTax.Text      := IntToStr(0);
      EdtTax.Text             := IntToStr(0);
      EdtSubTotal.Text        := IntToStr(0);

      DBEdtQuantity.Text        := IntToStr(1);
      DBEdtExcludeTax.Text      := FloatToStr(0.0);
      DBEdtTax.Text             := FloatToStr(0.0);
      DBEdtSubTotal.Text        := FloatToStr(0.0);
    end;
  end;
end;

procedure TFrmEditDetail.ProcCancel(Sender: TObject);
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

function TFrmEditDetail.ProcSave(Sender: TObject): Boolean;
var
  LNextDetailID : Integer = 0;
begin
  result := False;
  try
    try
      with CommonDB do begin
        with Defs do begin
          if GetDID = 0 then begin
            CloseQuery(AQuNextID);

            with AQuNextID do begin
              SQLConnection  := ACn;
              SQLTransaction := ATr;

              OpenSelectQueryWithHeaderID(
                ADSNextID, AQuNextID, SQL_20120003, GetHID);
              LNextDetailID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              CloseQuery(AQuNextID);

              DBEdtDetailID.Text := IntToStr(LNextDetailID);
              SetDID(LNextDetailID);
            end;
          end;

          with AQu do begin
            CloseQuery(AQu);

            SQLConnection  := ACn;
            SQLTransaction := ATr;

            SQL.Text := SQL_20120007;
            with Params do begin
              ParamByName('pUserID'     ).AsInteger   := GetUID;
              ParamByName('pHeaderID'   ).AsInteger   := GetHID;
              ParamByName('pDetailID'   ).AsInteger   := GetDID;
              ParamByName('pExpKey1'    ).AsInteger   := GetExpKey1;
              if GetExpKey2 > 0 then begin
                ParamByName('pExpKey2'    ).AsInteger   := GetExpKey2;
              end else begin
                ParamByName('pExpKey2'    ).AsInteger   := 0;
              end;
              if GetExpKey3 > 0 then begin
                ParamByName('pExpKey3'    ).AsInteger   := GetExpKey3;
              end else begin
                ParamByName('pExpKey3'    ).AsInteger   := 0;
              end;
              if GetMakerID > 0 then begin
                ParamByName('pMakerID'    ).AsInteger   := GetMakerID;
              end else begin
                MessageDlg(MSG_JP_000032, mtInformation, [mbOK], 0);
                DBLCBMaker.SetFocus;
                Exit;
              end;
              if GetBrandNameID > 0 then begin
                ParamByName('pBrandNameID').AsInteger   := GetBrandNameID;
              end else begin
                MessageDlg(MSG_JP_000035, mtInformation, [mbOK], 0);
                DBLCBBrandName.SetFocus;
                Exit;
              end;
              if GetUnitID > 0 then begin
                ParamByName('pUnitID'     ).AsInteger   := GetUnitID;
              end else begin
                MessageDlg(MSG_JP_000036, mtInformation, [mbOK], 0);
                DBLCBUnit.SetFocus;
                Exit;
              end;
              if GetTaxTypeID > 0 then begin
                ParamByName('pTaxTypeID'  ).AsInteger   := GetTaxTypeID;
                ParamByName('pTaxRateID'  ).AsInteger   := GetTaxRateID;
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
              ParamByName('pExcludeTax' ).AsInteger    := Round(GetExcludeTax);
              ParamByName('pTax'        ).AsInteger    := Round(GetTax);
              ParamByName('pSubTotal'   ).AsInteger    := Round(GetSubTotal);
              ParamByName('pEntryDT'    ).AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
              ParamByName('pUpdateDT'   ).AsAnsiString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now, GetFS);
            end;

            ExecSQL;
            ATr.Commit;
          end;


          ClearInputFields;
          //DBEdtMakerID.Text     := IntToStr(0);
          //DBEdtBrandNameID.Text := IntToStr(0);
          //DBEdtExpKey2.Text     := IntToStr(0);
          //DBEdtExpKey3.Text     := IntToStr(0);
          //DBEdtUnitID.Text      := IntToStr(0);
          //DBEdtTaxTypeID.Text   := IntToStr(0);
          //
          //DBEdtQuantity.Text    := IntToStr(1);
          //DBEdtExcludeTax.Text  := FloatToStr(0.0);
          //DBEdtTax.Text         := FloatToStr(0.0);
          //DBEdtSubTotal.Text    := FloatToStr(0.0);

          FormActivate(Self);
        end;
        result := True;
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

procedure TFrmEditDetail.ProcInsert(Sender: TObject);
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

procedure TFrmEditDetail.DBLCBMakerEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmEditDetail.DBLCBBrandNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;
end;

procedure TFrmEditDetail.DBLCBBrandNameExit(Sender: TObject);
begin
  Shape2.Visible := False;
end;

procedure TFrmEditDetail.DBLCBExp2Enter(Sender: TObject);
begin
  Shape3.Visible := True;
end;

procedure TFrmEditDetail.DBLCBExp2Exit(Sender: TObject);
begin
  Shape3.Visible := False;
end;

procedure TFrmEditDetail.DBLCBExp3Enter(Sender: TObject);
begin
  Shape4.Visible := True;
end;

procedure TFrmEditDetail.DBLCBExp3Exit(Sender: TObject);
begin
  Shape4.Visible := False;
end;

procedure TFrmEditDetail.DBLCBMakerExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmEditDetail.DBLCBTaxTypeEnter(Sender: TObject);
begin
  Shape6.Visible := True;
end;

procedure TFrmEditDetail.DBLCBUnitEnter(Sender: TObject);
begin
  Shape5.Visible := True;
end;

procedure TFrmEditDetail.DBLCBUnitExit(Sender: TObject);
begin
  Shape5.Visible := False;
end;

procedure TFrmEditDetail.EdtAmountEnter(Sender: TObject);
begin
  Shape8.Visible := True;
end;

procedure TFrmEditDetail.EdtAmountExit(Sender: TObject);
begin
  Shape8.Visible := False;
end;

procedure TFrmEditDetail.EdtExcludeTaxEnter(Sender: TObject);
begin
  Shape9.Visible := True;
end;

procedure TFrmEditDetail.EdtQuantityChange(Sender: TObject);
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

procedure TFrmEditDetail.EdtQuantityEnter(Sender: TObject);
begin
  Shape7.Visible := True;
end;

procedure TFrmEditDetail.EdtSubTotalEnter(Sender: TObject);
begin
  Shape11.Visible := True;
end;

procedure TFrmEditDetail.EdtTaxEnter(Sender: TObject);
begin
  Shape10.Visible := True;
end;

procedure TFrmEditDetail.ProcEntryBrandName(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    SetEntryMaker(999);
    SetEntryBrandName(2);

    FrmEntryBrandName := TFrmEntryBrandName.Create(Application);
    OpenForm(Self, FrmEntryBrandName);
  end;
end;

procedure TFrmEditDetail.ProcEntryMaker(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    SetEntryMaker(2);

    FrmEntryMaker := TFrmEntryMaker.Create(Application);
    OpenForm(Self, FrmEntryMaker);
  end;
end;

procedure TFrmEditDetail.ProcEntryUnit(Sender: TObject);
begin
  with Defs do begin
    SetGoBack(False);
    SetEntryUnit(2);

    FrmEntryUnit := TFrmEntryUnit.Create(Application);
    OpenForm(Self, FrmEntryUnit);
  end;
end;

procedure TFrmEditDetail.EntryMakerMouseOver(NewColor: TColor);
begin
  BtnEntryMaker.Color := NewColor;
end;

procedure TFrmEditDetail.BtnEntryMakerEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clSkyBlue);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.BtnEntryMakerExit(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.EntryBrandNameMouseOver(NewColor: TColor);
begin
  BtnEntryBrandName.Color := NewColor;
end;

procedure TFrmEditDetail.BtnEntryBrandNameEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clSkyBlue);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.BtnEntryBrandNameExit(Sender: TObject);
begin
  EntryBrandNameMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.EntryUnitMouseOver(NewColor: TColor);
begin
  BtnEntryUnit.Color := NewColor;
end;

procedure TFrmEditDetail.BtnEntryUnitEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.BtnEntryUnitExit(Sender: TObject);
begin
  EntryUnitMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEditDetail.BtnCancelEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEditDetail.BtnSaveEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);
end;

procedure TFrmEditDetail.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEditDetail.BtnGoBackEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  EntryBrandNameMouseOver(clBtnFace);
  EntryUnitMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmEditDetail.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
end;

function TFrmEditDetail.GetGoBack: Boolean;
begin
  Result := FGoBack;
end;

procedure TFrmEditDetail.SetGoBack(GoBack: boolean);
begin
  FGoBack := GoBack;
end;

procedure TFrmEditDetail.SelectExp2(
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
            ParamByName('pExpKey1').AsInteger := GetExpKey1;
          end;
          Open;
        end;
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
    with CommonDB do begin
      with Defs do begin
        with Qu3 do begin
          SQL.Text     := SQL_20120002;
          with Params do begin
            ParamByName('pUserID').AsInteger  := GetUID;
            ParamByName('pExpKey1').AsInteger := GetExpKey1;
            if Not VarIsNull(DBLCBExp2.KeyValue) then begin
              ParamByName('pExpKey2').AsInteger := VarToInt(DBLCBExp2.KeyValue);

              Tr3.Active        := True;
              Open;
            end;
          end;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFrmEditDetail.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEditDetail.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  if ProcSave(Sender) then begin
    ProcInsert(Sender);
    ClearInputFields;
  end;
end;

procedure TFrmEditDetail.ActEntryMakerExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryMaker(Sender);
end;

procedure TFrmEditDetail.ActEntryBrandNameExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryBrandName(Sender);
end;

procedure TFrmEditDetail.ActEntryUnitExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryUnit(Sender);
end;

procedure TFrmEditDetail.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditDetail.DBLCBMakerChange(Sender: TObject);
var
  LID: Integer;
begin
  with Defs do begin
    with DBLCBMaker do begin
      with DBEdtMakerID do begin
        LID := VarToInt(KeyValue);
        if LID > 0 then begin
          if IntToStr(LID) <> Text then begin
            Text := IntToStr(LID);
            with CommonDB do begin
              with Defs do begin
                SetMakerID(LID);

                // Set BrandName ComboBox
                CloseQuery(AQuBrand);
                OpenSelectQueryWithMakerID(
                  ADSBrand, AQuBrand, SQL_20140002, GetMakerID);
                SetKeyValToDBLCB(
                  DBLCBBrandName, DBEdtBrandNameID, GetBrandNameID);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmEditDetail.DBLCBBrandNameChange(Sender: TObject);
var
  LID: Integer;
begin
  with Defs do begin
    with DBLCBBrandName do begin
      with DBEdtBrandNameID do begin
        LID := VarToInt(KeyValue);
        if LID > 0 then begin
          if IntToStr(LID) <> Text then begin
            Text := IntToStr(LID);

            with Defs do begin
              SetBrandNameID(LID);
            end;
          end;
        end else begin
          Text := IntToStr(0);
        end;
      end;
    end;
  end;
end;

procedure TFrmEditDetail.DBLCBExp2Change(Sender: TObject);
var
  LID: Integer;
begin
  with Defs do begin
    with DBLCBExp2 do begin
      with DBEdtExpKey2 do begin
        LID := VarToInt(KeyValue);
        if LID > 0 then begin
          if IntToStr(LID) <> Text then begin
            Text := IntToStr(LID);

            with CommonDB do begin
              with Defs do begin
                SetExpKey2(LID);
              end;

              with AQuExp3 do begin
                CloseQuery(AQuExp3);

                SQLConnection  := ACn;
                SQLTransaction := ATr;

                SelectExp3(ACn, ADSExp3, ATr, AQuExp3);
                if AQuExp3.RecordCount = 0 then begin
                  DBEdtExpKey3.Text := IntToStr(0);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmEditDetail.DBLCBExp3Change(Sender: TObject);
var
  LID: Integer;
begin
  with Defs do begin
    with DBLCBExp3 do begin
      with DBEdtExpKey3 do begin
        LID := VarToInt(KeyValue);
        if LID > 0 then begin
          if LID <> StrToInt(Text) then begin
            Text := IntToStr(LID);

            with Defs do begin
              SetExpKey3(LID);
            end;
          end else begin
            Text := IntToStr(0);
          end;
        end else begin
          Text := IntToStr(0);
        end;
      end;
    end;
  end;
end;

procedure TFrmEditDetail.DBLCBUnitChange(Sender: TObject);
begin
  DBEdtUnitID.Text := VarToStr(DBLCBUnit.KeyValue);
end;

procedure TFrmEditDetail.DBLCBTaxTypeChange(Sender: TObject);
begin
  with Defs do begin
    DBEdtTaxTypeID.Text := VarToStr(DBLCBTaxType.KeyValue);
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
            And (StrToInt(Text) <> 0) then begin
              SetExcludeTax(StrToInt(Text));
              EdtTax.Text := FormatFloat('#,##0', Round(GetExcludeTax * FTaxRate));
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
        if DBEdtExcludeTax.Text <> '' then begin
          DBEdtExcludeTax.Text := DBEdtSubTotal.Text;
          EdtSubTotal.Text
            := FormatFloat('#,##0', StrToInt(DBEdtSubTotal.Text));
        end;
      end;
    end;
  end;
end;

procedure TFrmEditDetail.DBLCBTaxTypeExit(Sender: TObject);
begin
  DBLCBTaxTypeChange(Self);
  DBEdtTaxTypeID.Text := VarToStr(DBLCBTaxType.KeyValue);

  with Defs do begin
    if (Not VarIsNull(DBLCBTaxType.KeyValue)) And (EdtExcludeTax.Text <> '') then begin
      EdtAmount.TabStop  := False;
      EdtAmount.ReadOnly := True;
      if (VarToInt(DBLCBTaxType.KeyValue) = 1)
            Or (VarToInt(DBLCBTaxType.KeyValue) = 2) then begin
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
      end else if ((VarToInt(DBLCBTaxType.KeyValue) = 3)
        Or (VarToInt(DBLCBTaxType.KeyValue) = 4))
        And (EdtSubTotal.Text <> '') then begin
          EdtExcludeTax.TabStop  := False;
          EdtExcludeTax.ReadOnly := True;
          EdtTax.TabStop         := False;
          EdtTax.ReadOnly        := True;

          CalcInclusiveTax;
      end else if (VarToInt(DBLCBTaxType.KeyValue) = 5) then begin
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

  Shape6.Visible := False;
end;

procedure TFrmEditDetail.EdtQuantityExit(Sender: TObject);
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

procedure TFrmEditDetail.EdtAmountChange(Sender: TObject);
begin
  with Defs do begin
    with EdtAmount do begin
      SetAmount(StrToInt(
        StringReplace(EdtExcludeTax.Text, ',', '', [rfReplaceAll])));
    end;
  end;
end;

procedure TFrmEditDetail.EdtExcludeTaxExit(Sender: TObject);
begin
  FTaxRate := AQuTaxType.FieldByName('TAX_RATE').AsInteger / 100;

  with Defs do begin
    with EdtExcludeTax do begin
      DBEdtExcludeTax.Text := StringReplace(Text, ',', '', [rfReplaceAll]);

      if Text <> '' then begin
        SetExcludeTax(StrToInt(Text));
      end else begin
        SetExcludeTax(0);
      end;
    end;

    with DBLCBTaxType do begin
      if ((VarToInt(KeyValue) = 1)
          Or (VarToInt(KeyValue) = 2))
          And (GetExcludeTax <> 0)
          And (GetQuantity > 0) then begin
        EdtAmount.Text
          := FormatFloat('#,##0.000', GetExcludeTax / GetQuantity);
        DBEdtTax.Text
          := IntToStr(Round(GetExcludeTax * FTaxRate));
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
  end;

  Shape9.Visible := False;
end;

procedure TFrmEditDetail.EdtTaxChange(Sender: TObject);
begin
  with Defs do begin
    if (EdtTax.Text <> '')
      And (StrToInt(StringReplace(EdtTax.Text, ',', '', [rfReplaceAll])) > 0) then begin
      DBEdtTax.Text := StringReplace(EdtTax.Text, ',', '', [rfReplaceAll]);
    end else begin
      DBEdtTax.Text := IntToStr(0);
    end;
    SetTax(StrToInt(DBEdtTax.Text));
  end;
end;

procedure TFrmEditDetail.EdtTaxExit(Sender: TObject);
begin
  with Defs do begin
    EdtSubTotal.Text := FormatFloat('#,##0', GetExcludeTax + GetTax);

    Shape10.Visible := False;
  end;
end;

procedure TFrmEditDetail.EdtSubTotalChange(Sender: TObject);
begin
  if (EdtSubTotal.Text <> '-') then begin
    if (EdtSubTotal.Text <> '')
      And (StrToInt(StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll])) <> 0) then begin
      DBEdtSubTotal.Text := StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll]);
    end else begin
      DBEdtExcludeTax.Text := FloatToStr(0.0);
      DBEdtTax.Text        := FloatToStr(0.0);
      DBEdtSubTotal.Text   := FloatToStr(0.0);
    end;
  end;
end;

procedure TFrmEditDetail.EdtSubTotalExit(Sender: TObject);
begin
  with Defs do begin
    if (EdtSubTotal.Text <> '') then begin
      DBEdtSubTotal.Text := StringReplace(EdtSubTotal.Text, ',', '', [rfReplaceAll]);
    end else begin
      DBEdtSubTotal.Text := FloatToStr(0.0);
    end;

    with DBEdtSubTotal do begin
      if (Text <> '')
        And (StrToInt(Text) > 0) then begin
        SetSubTotal(StrToInt(Text));
      end else begin
        SetSubTotal(0);
      end;
    end;

    with DBLCBTaxType do begin
      if Not VarIsNull(KeyValue) then begin
        if (VarToInt(KeyValue) = 1)
          Or (VarToInt(KeyValue) = 2) then begin
          if GetSubTotal >= 0 then begin
            EdtSubTotal.Text := FormatFloat('#,##0', GetSubTotal);
          end else begin
            EdtExcludeTax.Text := FloatToStr(0.0);
            EdtTax.Text        := FloatToStr(0.0);
            EdtSubTotal.Text   := FloatToStr(0.0);
          end;
        end else if (VarToInt(KeyValue) = 3)
          Or (VarToInt(KeyValue) = 4) then begin
          if GetSubTotal >= 0 then begin
            CalcInclusiveTax;
          end else begin
            EdtExcludeTax.Text := FloatToStr(0.0);
            EdtTax.Text        := FloatToStr(0.0);
            EdtSubTotal.Text   := FloatToStr(0.0);
          end;
        end else if (VarToInt(KeyValue) = 5) then begin
          // Tax Free
          DBEdtTax.Text := IntToStr(0);
          EdtTax.Text := DBEdtTax.Text;
          if DBEdtSubTotal.Text <> '' then begin
            EdtSubTotal.Text
              := FormatFloat('#,##0', StrToInt(DBEdtSubTotal.Text));
            DBEdtExcludeTax.Text := DBEdtSubTotal.Text;
            SetExcludeTax(StrToInt(DBEdtExcludeTax.Text));
            EdtExcludeTax.Text   := FormatFloat('#,##0', GetExcludeTax);

            if GetQuantity > 0 then begin
              EdtAmount.Text
                := FormatFloat('#,##0.000', GetExcludeTax / GetQuantity);
            end else begin
              EdtAmount.Text   := FormatFloat('#,##0.000', 0);
            end;
          end else begin
            EdtExcludeTax.Text := FloatToStr(0.0);
            EdtTax.Text        := FloatToStr(0.0);
            EdtSubTotal.Text   := FloatToStr(0.0);
          end;
        end else begin
          EdtExcludeTax.Text := FloatToStr(0.0);
          EdtTax.Text        := FloatToStr(0.0);
          EdtSubTotal.Text   := FloatToStr(0.0);
        end;
      end;
    end;
  end;

  Shape11.Visible := False;
end;

procedure TFrmEditDetail.FormClose(Sender: TObject; var CloseAction: TCloseAction);
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
  with CommonDB do begin
    with Defs do begin
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
  end;

  CloseAction                 := caFree;
  FrmEditDetail              := nil;
end;

procedure TFrmEditDetail.FormCreate(Sender: TObject);
begin
  with Defs do begin
    //SetDatabaseNames;

    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  SetGoBack(True);
end;

procedure TFrmEditDetail.FormShow(Sender: TObject);
begin
  Self.Width              := 737;

  Self.KeyPreview         := True;

  Self.Color              := RGB(112, 168, 175);
  PnlEntryMaker.Color     := RGB( 72, 122, 129);
  PnlEntryBrandName.Color := RGB( 72, 122, 129);
  PnlEntryUnit.Color      := RGB( 72, 122, 129);
  PnlCancel.Color         := RGB( 72, 122, 129);
  PnlCommit.Color         := RGB( 72, 122, 129);
  PnlGoBack.Color         := RGB( 72, 122, 129);

  { Debug }
  //Self.Width := 1212;
end;

procedure TFrmEditDetail.FormActivate(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        if Active = False then begin
          SQL.Text := SQL_20120006;
          with Params do begin
            ParamByName('pUserID').AsInteger   := GetUID;
            ParamByName('pHeaderID').AsInteger := GetHID;
            ParamByName('pDetailID').AsInteger := GetDID;
          end;
          Open;
        end;
        if RecordCount = 0 then begin
          ProcInsert(Sender);
        end else begin
          FInsert := False;
        end;
      end;

      with AQuMaker do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SetMakerID(AQu.FieldByName('MAKER_ID').AsInteger);
        OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
        DBLCBMaker.KeyValue := GetMakerID;
      end;

      with AQuBrand do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SetBrandNameID(AQu.FieldByName('BRAND_NAME_ID').AsInteger);
        OpenSelectQueryWithMakerID(
          ADSBrand, AQuBrand, SQL_20140002, GetMakerID);
        DBLCBBrandName.KeyValue := GetBrandNameID;
      end;

      with AQuExp2 do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        DBEdtExpKey1.Text := IntToStr(GetExpKey1);

        SetExpKey2(AQu.FieldByName('EXP_KEY2').AsInteger);
        SelectExp2(ACn, ADSExp2, ATr, AQuExp2);
        if GetExpKey2 > 0 then begin
            DBLCBExp2.KeyValue := GetExpKey2;
        end else begin
          DBLCBExp2.KeyValue   := -1;
        end;
      end;

      with AQuExp3 do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SetExpKey3(AQu.FieldByName('EXP_KEY3').AsInteger);
        SelectExp3(ACn, ADSExp3, ATr, AQuExp3);
        if GetExpKey3 > 0 then begin
            DBLCBExp3.KeyValue := GetExpKey3;
        end else begin
          DBLCBExp3.KeyValue := -1;
        end;
      end;

      with AQuUnit do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SetUnitID(AQu.FieldByName('UNIT_ID').AsInteger);
        OpenSelectQueryByUnit(ADSUnit, AQuUnit, SQL_20150001);
        if GetUnitID > 0 then begin
          DBLCBUnit.KeyValue := GetUnitID;
        end else begin
          DBLCBUnit.KeyValue := -1;
        end;
      end;


      with AQuTaxType do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SetTaxTypeID(AQu.FieldByName('TAX_TYPE_ID').AsInteger);
        OpenSelectQueryWithTaxType(ADSTaxType, AQuTaxType, SQL_20120004);
        if GetTaxTypeID > 0 then begin
          DBLCBTaxType.KeyValue := GetTaxTypeID;
        end else begin
          DBLCBTaxType.KeyValue := -1;
        end;

        SetQuantity(AQu.FieldByName('QUANTITY').AsInteger);
        if GetQuantity > 0 then begin
          EdtQuantity.Text   := FormatFloat('#,##0', GetQuantity);
        end else begin
          EdtQuantity.Text   := FormatFloat('#,##0', 1);
        end;

        SetExcludeTax(AQu.FieldByName('EXCLUDE_TAX').AsInteger);
        if GetExcludeTax <> 0 then begin
          EdtExcludeTax.Text   := FormatFloat('#,##0', GetExcludeTax);
        end else begin
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
          EdtTax.Text   := FormatFloat('#,##0', GetTax);
        end else begin
          EdtTax.Text   := FormatFloat('#,##0', 0);
        end;

        SetSubTotal(AQu.FieldByName('SUB_TOTAL').AsInteger);
        if GetSubTotal <> 0 then begin
          EdtSubTotal.Text   := FormatFloat('#,##0', GetSubTotal);
        end else begin
          EdtSubTotal.Text   := FormatFloat('#,##0', 0);
        end;

        Timer.Enabled := True;

        SetEntryMaker(0);
        SetEntryAccount(0);
        SetEntryUnit(0);
      end;
    end;
  end;
end;

procedure TFrmEditDetail.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TFrmEditDetail.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;

  with Defs do begin
    DBEdtUserID.Text   := IntToStr(GetUID);
    DBEdtHeaderID.Text := IntToStr(GetHID);
    DBEdtExpKey1.Text  := IntToStr(GetExpKey1);
  end;
end;

end.

