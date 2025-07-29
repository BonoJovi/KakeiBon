unit UEditDetailsHeader;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Variants, SysUtils, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, StdCtrls, DBCtrls, DBGrids, ExtCtrls, LCLIntf, ActnList,
  DateTimePicker, DBDateTimePicker, UDefs;

type

  { TFrmEditDetailsHeader }

  TFrmEditDetailsHeader = class(TForm)
    ActAddDetail     : TAction;
    ActEntryAccount  : TAction;
    ActEntryShop     : TAction;
    ActEditDetail    : TAction;
    ActRemoveDetail  : TAction;
    ActionList       : TActionList;
    ActQuit          : TAction;
    ADBNav           : TDBNavigator;
    ADS              : TDataSource;
    ADSDetail        : TDataSource;
    ADSExp1          : TDataSource;
    ADSFromAC        : TDataSource;
    ADSNextID        : TDataSource;
    ADSShop          : TDataSource;
    ADSToAC          : TDataSource;
    AQu              : TSQLQuery;
    AQuDetail        : TSQLQuery;
    AQuExp1          : TSQLQuery;
    AQuFromAC        : TSQLQuery;
    AQuNextID        : TSQLQuery;
    AQuShop          : TSQLQuery;
    AQuToAC          : TSQLQuery;
    ATr              : TSQLTransaction;
    ATrDetail        : TSQLTransaction;
    ATrExp1          : TSQLTransaction;
    ATrFromAC        : TSQLTransaction;
    ATrNextID        : TSQLTransaction;
    ATrShop          : TSQLTransaction;
    ATrToAC          : TSQLTransaction;
    BtnAddDetail     : TButton;
    BtnEditDetail    : TButton;
    BtnEntryAccount  : TButton;
    BtnEntryShop     : TButton;
    BtnGoBack        : TButton;
    BtnRemoveDetail  : TButton;
    DBDTPHeaderDT    : TDBDateTimePicker;
    DBDTPEntryDT     : TDBDateTimePicker;
    DBDTPUpdateDT    : TDBDateTimePicker;
    DBEdtHeaderID    : TDBEdit;
    DBEdtFromID      : TDBEdit;
    DBEdtTotalAmount: TDBEdit;
    DBEdtUserID      : TDBEdit;
    DBEdtToID        : TDBEdit;
    DBEdtPhonem    : TDBEdit;
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
    LblPhonem1     : TLabel;
    LblPhonem2     : TLabel;
    LblPhonem3     : TLabel;
    LblPhonem4     : TLabel;
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
    procedure EdtTotalAmountExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FGoBack      : Boolean;
    FTotalAmount : Integer;
    procedure CloseTransactions;
    procedure BackupValues;
    function CheckInput: Boolean;
    procedure ProcAddDetail;
    procedure ProcEditDetail;
    procedure ProcEntryAccount;
    procedure ProcEntryShop;
    procedure ProcRemoveDetail;
    procedure SetButtonEnabled(Qu: TSQLQuery);
    procedure Summarize;
  public

  end;

var
  FrmEditDetailsHeader: TFrmEditDetailsHeader;


implementation
uses
  UConsts, UDBAccess, UTopMenu, UManageDetails, UEntryAccount, UEntryShop,
  UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmEditDetailsHeader }

procedure TFrmEditDetailsHeader.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn        , ATr      );
    CloseConn(ACnDetail, ATrDetail);
    CloseConn(ACnNextID  , ATrNextID);
    CloseConn(ACnShop  , ATrShop  );
    CloseConn(ACnExp1  , ATrExp1  );
    CloseConn(ACnFromAC, ATrFromAC);
    CloseConn(ACnToAC  , ATrToAC  );
  end;
end;

procedure TFrmEditDetailsHeader.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    if DBEdtHeaderID.Text <> '' then begin;
      SetHID(StrToInt(DBEdtHeaderID.Text));
    end;
    //if (AQuDetail.Active) And (AQuDetail.FieldByName('DETAIL_ID').AsInteger > 0) then begin
    //  SetDID(AQuDetail.FieldByName('DETAIL_ID').AsInteger);
    //end;
    DBDTPHeaderDT.TimeFormat := tf24;
    SetHeaderDT(
      //FormatDateTime('yyyy/mm/dd hh:nn:ss', DTPYear.DateTime, GetFS)
      DateTimeToStr(DTPYear.DateTime)
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

procedure TFrmEditDetailsHeader.ProcAddDetail;
begin
  try
    try
      if CheckInput then begin
        with AQu do begin
          SQL.Text := SQL_20100008;
          with FrmTopMenu.Defs do begin
            Params.ParamByName('pUserID').AsInteger        := GetUID;
            Params.ParamByName('pHeaderID').AsInteger      := GetHID;
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
            Params.ParamByName('pUpdateDT').AsDateTime      := Now;
          end;

          UpdateMode                                     := upWhereAll;

          CloseTransactions;
          ExecSQL;
          ATr.Commit;
        end;

        with FrmTopMenu.Defs do begin
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

procedure TFrmEditDetailsHeader.ProcEditDetail;
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

        with AQu do begin
          SQL.Text := SQL_20100008;
          with FrmTopMenu.Defs do begin
            Params.ParamByName('pUserID').AsInteger        := GetUID;
            Params.ParamByName('pHeaderID').AsInteger      := GetHID;
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
            Params.ParamByName('pUpdateDT').AsDateTime     := Now;
          end;
          UpdateMode                                       := upWhereAll;

          CloseTransactions;
          ExecSQL;
          ATr.Commit;
        end;

        with FrmTopMenu.Defs do begin
          SetDID(AQuDetail.FieldByName('DETAIL_ID').AsInteger);

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

procedure TFrmEditDetailsHeader.ProcEntryAccount;
begin
  with FrmTopMenu.Defs do begin
    FrmEntryAccount := TFrmEntryAccount.Create(Application);
    OpenForm(Self, FrmEntryAccount);
  end;
end;

procedure TFrmEditDetailsHeader.ProcEntryShop;
begin
  with FrmTopMenu.Defs do begin
    FrmEntryShop := TFrmEntryShop.Create(Application);
    OpenForm(Self, FrmEntryShop);
  end;
end;

procedure TFrmEditDetailsHeader.ProcRemoveDetail;
begin
  try
    try

      with FrmTopMenu.Defs do begin
        with AQuDetail do begin
          SQL.Text := SQL_20100010;
          Params.ParamByName('pUserID').AsInteger   := GetUID;
          Params.ParamByName('pHeaderID').AsInteger := GetHID;

          CloseTransactions;
          Open;

          First;
          while Not EOF do begin
            if FieldByName('DETAIL_ID').AsInteger = GetDID then begin
              break;
            end;
            Next;
          end;

          CloseTransactions;
          Edit;
          Delete;
          ApplyUpdates;
          ATrDetail.Commit;

          SetButtonEnabled(AQuDetail);
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATrDetail.Rollback;
      end;
    end;

    try
      with FrmTopMenu.Defs do begin
        with AQuDetail do begin
          CloseConn(ACnDetail, ATrDetail);
          OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
          SQL.Text := SQL_20100009;
          Params.ParamByName('pUserID').AsInteger   := GetUID;
          Params.ParamByName('pHeaderID').AsInteger := GetHID;
          Open;

          SetButtonEnabled(AQuDetail);
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATrDetail.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TFrmEditDetailsHeader.SetButtonEnabled(Qu: TSQLQuery);
begin
  with Qu do begin
    if RecordCount <= 0 then begin
      BtnRemoveDetail.Enabled := False;
      PnlRemoveDetail.Enabled := False;
    end else begin
      BtnRemoveDetail.Enabled := True;
      PnlRemoveDetail.Enabled := True;
    end;
  end;
end;

procedure TFrmEditDetailsHeader.Summarize;
var
  LDetailID        : Integer;
  LTotalAmount     : Integer;
  LPrevTotalAmount : Integer;
  LFractionProc    : Integer = FRACTION_PROC_UNDEF;
begin
  with FrmTopMenu.Defs do begin
    with AQuDetail do begin
      SQL.Text := SQL_20100009;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;

      CloseConn(ACnDetail, ATrDetail);
      Open;
    end;
  end;

  LDetailID        := AQuDetail.FieldByName('DETAIL_ID').AsInteger;
  with FrmTopMenu.Defs do begin
    SetDID(LDetailID);
  end;
  if EdtTotalAmount.Text <> '' then begin
    LPrevTotalAmount := StrToInt(StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll]));
  end else begin
    LPrevTotalAmount := 0;
  end;

  with FrmTopMenu.Defs do begin
    // Get fruction processing type
    OpenSelQuAndSetVal(
      ACnShop  , ADSShop  , ATrShop  , AQuShop  , DBLCBShopName,
      DBEdtShopID , SQL_20100001, GetShopID);

    if AQuShop.FieldByName('DO_ROUND').AsBoolean then begin
      LFractionProc := FRACTION_PROC_ROUND;
    end else if AQuShop.FieldByName('DO_TRUNCATE').AsBoolean then begin
      LFractionProc := FRACTION_PROC_TRUNCATE;
    end else begin
      LFractionProc := FRACTION_PROC_ROUND_UP;
    end;

    if (DBEdtTotalAmount.Text <> '') And (StrToInt(DBEdtTotalAmount.Text) <> 0) then begin
      LTotalAmount := StrToInt(DBEdtTotalAmount.Text);
    end else begin
      //with FrmTopMenu.Defs do begin
        with AQu do begin
          OpenConn(ACn, ADS, ATr, AQu);
          SQL.Text := SQL_20100006;
          Params.ParamByName('pUserID').AsInteger   := GetUID;
          Params.ParamByName('pHeaderID').AsInteger := GetHID;
          Open;

          LTotalAmount := FieldByName('TOTAL_AMOUNT').AsInteger;
        end;
      //end;
    end;

    with AQuDetail do begin
      // Calc TotalAmount (TRUNC)
      CloseConn(ACnDetail, ATrDetail);
      OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
      SQL.Text := SQL_20100012;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Open;

      if (FieldByName('TOTAL_AMOUNT').AsString = '')
        Or (FieldByName('TOTAL_AMOUNT').AsString = IntToStr(0)) then begin
        Exit;
      end;

      FTotalAmount := FieldByName('TOTAL_AMOUNT').AsInteger;

      CloseConn(ACnDetail, ATrDetail);
      OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
      SQL.Text := SQL_20100009;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Open;

      if FTotalAmount <= LTotalAmount then begin
        if (FTotalAmount = LTotalAmount) then begin
          with AQuShop do begin
            CloseConn(ACnShop, ATrShop);
            OpenConn(ACnShop, ADSShop, ATrShop, AQuShop);
            SQL.Text := SQL_20100015;
            Params.ParamByName('pUserID').AsInteger := GetUID;
            Params.ParamByName('pShopID').AsInteger := GetShopID;

            CloseTransactions;
            ExecSQL;
            ATrShop.Commit;

            OpenSelQuAndSetVal(
              ACnShop, ADSShop, ATrShop, AQuShop, DBLCBShopName,
              DBEdtShopID , SQL_20100001, GetShopID);
          end;
          EdtTotalAmount.Text := FormatFloat('#,##0', FTotalAmount);
          Exit;
        end;
      end;
    end;

    // Calc TotalAmount (ROUND UP)
    with AQuDetail do begin
      CloseConn(ACnDetail, ATrDetail);
      OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
      SQL.Text := SQL_20100013;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Open;

      FTotalAmount := FieldByName('TOTAL_AMOUNT').AsInteger;

      CloseConn(ACnDetail, ATrDetail);
      OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
      SQL.Text := SQL_20100009;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Open;

      if FTotalAmount >= LTotalAmount then begin
        if FTotalAmount = LTotalAmount then begin
          with AQuShop do begin
            CloseConn(ACnShop, ATrShop);
            OpenConn(ACnShop, ADSShop, ATrShop, AQuShop);
            SQL.Text := SQL_20100016;
            Params.ParamByName('pUserID').AsInteger := GetUID;
            Params.ParamByName('pShopID').AsInteger := GetShopID;

            CloseTransactions;
            ExecSQL;
            ATrShop.Commit;

            OpenSelQuAndSetVal(
              ACnShop, ADSShop, ATrShop, AQuShop, DBLCBShopName,
              DBEdtShopID , SQL_20100001, GetShopID);
          end;
          EdtTotalAmount.Text := FormatFloat('#,##0', FTotalAmount);
          Exit;
        end;
      end;
    end;

    // Calc TotalAmount (ROUND)
    with AQuDetail do begin
      CloseConn(ACnDetail, ATrDetail);
      OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
      SQL.Text := SQL_20100011;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Open;

      FTotalAmount := FieldByName('TOTAL_AMOUNT').AsInteger;

      CloseConn(ACnDetail, ATrDetail);
      OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
      SQL.Text := SQL_20100009;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Open;
    end;

    if FTotalAmount = LTotalAmount then begin
      with AQuShop do begin
        CloseConn(ACnShop, ATrShop);
        OpenConn(ACnShop, ADSShop, ATrShop, AQuShop);
        SQL.Text := SQL_20100014;
        Params.ParamByName('pUserID').AsInteger := GetUID;
        Params.ParamByName('pShopID').AsInteger := GetShopID;

        CloseTransactions;
        ExecSQL;
        ATrShop.Commit;

        OpenSelQuAndSetVal(
          ACnShop, ADSShop, ATrShop, AQuShop, DBLCBShopName,
          DBEdtShopID , SQL_20100001, GetShopID);
      end;

      EdtTotalAmount.Text := FormatFloat('#,##0', FTotalAmount);
    end;

    // ReQuery
    with AQuDetail do begin
      OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
      SQL.Text   := SQL_20100009;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Open;

      if RecordCount <= 0 then begin
        BtnEditDetail.Enabled   := False;
        BtnRemoveDetail.Enabled := False;
      end else begin
        BtnEditDetail.Enabled   := True;
        BtnRemoveDetail.Enabled := True;
      end;
    end;
  end;

  AQuDetail.First;
  while Not AQuDetail.EOF do begin
    if LDetailID = AQuDetail.FieldByName('DETAIL_ID').AsInteger then begin
      break;
    end;
    AQuDetail.Next;
  end;
end;

procedure TFrmEditDetailsHeader.ActAddDetailExecute(Sender: TObject);
begin
  FGoBack := False;
  with FrmTopMenu.Defs do begin
    SetAddDetail(2);

    SetMakerID(Null);
    SetBrandNameID(Null);
    SetUnitID(Null);
    SetTaxTypeID(Null);
  end;

  BackupValues;
  ProcAddDetail;
  Summarize;
end;

procedure TFrmEditDetailsHeader.ActEditDetailExecute(Sender: TObject);
begin
  FGoBack := False;
  with FrmTopMenu.Defs do begin
    SetEditDetail(2);
  end;

  BackupValues;
  ProcEditDetail;
  Summarize;
end;

procedure TFrmEditDetailsHeader.ActEntryAccountExecute(Sender: TObject);
begin
  FGoBack := False;
  BackupValues;
  FrmTopMenu.Defs.SetEntryAccount(2);
  ProcEntryAccount;
end;

procedure TFrmEditDetailsHeader.ActEntryShopExecute(Sender: TObject);
begin
  FGoBack := False;
  BackupValues;
  FrmTopMenu.Defs.SetEntryShop(2);
  ProcEntryShop;
end;

procedure TFrmEditDetailsHeader.ActQuitExecute(Sender: TObject);
begin
  FGoBack := True;
  Close;
end;

procedure TFrmEditDetailsHeader.ActRemoveDetailExecute(Sender: TObject);
begin
  BackupValues;
  ProcRemoveDetail;
end;

procedure TFrmEditDetailsHeader.DBLCBExp1Change(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetExpKey1(DBLCBExp1.KeyValue);
    if Not VarIsNull(GetExpKey1) then begin
      if GetExpKey1 = 1 then begin
        DBLCBFromAC.Enabled   := True;
        DBLCBToAC.Enabled     := False;
        DBLCBToAC.ItemIndex   := -1;

        if (DBLCBFromAC.Enabled) And (Not VarIsNull(DBLCBFromAC.KeyValue)) then begin
          DBEdtFromID.Text    := DBLCBFromAC.KeyValue;
        end;
        DBEdtToID.Text        := '';
      end else if GetExpKey1 = 2 then begin
        DBLCBFromAC.Enabled   := False;
        DBLCBFromAC.ItemIndex := -1;
        DBLCBToAC.Enabled     := True;

        DBEdtFromID.Text      := '';
        if (DBLCBToAC.Enabled) And (Not VarIsNull(DBLCBToAC.KeyValue)) then begin
          DBEdtToID.Text      := DBLCBToAC.KeyValue;
        end;
      end else if GetExpKey1 = 3 then begin
        DBLCBFromAC.Enabled   := True;
        DBLCBToAC.Enabled     := True;
        if (DBLCBFromAC.Enabled) And (Not VarIsNull(DBLCBFromAC.KeyValue)) then begin
          DBEdtFromID.Text    := DBLCBFromAC.KeyValue;
        end;
        if (DBLCBToAC.Enabled) And (Not VarIsNull(DBLCBToAC.KeyValue)) then begin
          DBEdtToID.Text      := DBLCBToAC.KeyValue;
        end;
      end;
      DBEdtExpKey1.Text       := DBLCBExp1.KeyValue;
    end else begin
      DBEdtFromID.Text        := '';
      DBEdtToID.Text          := '';
    end;

    FrmTopMenu.Defs.SetFromACID(DBEdtFromID.Text);
    FrmTopMenu.Defs.SetToACID(DBEdtToID.Text);
  end;
end;

procedure TFrmEditDetailsHeader.DBLCBShopNameChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if Not VarIsNull(DBLCBShopName.KeyValue) then begin
      DBEdtShopID.Text := DBLCBShopName.KeyValue;
    end else begin
      DBEdtShopID.Text := '';
    end;
    SetShopID(DBEdtShopID.Text);
  end;
end;

procedure TFrmEditDetailsHeader.DBLCBFromACChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if DBLCBFromAC.Enabled then begin
      DBEdtFromID.Text := DBLCBFromAC.KeyValue;
    end else begin
      DBEdtFromID.Text := '';
    end;
    SetFromACID(DBEdtFromID.Text);
  end;
end;

procedure TFrmEditDetailsHeader.DBLCBToACChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if DBLCBToAC.Enabled then begin
      DBEdtToID.Text := DBLCBToAC.KeyValue;
    end else begin
      DBEdtToID.Text := '';
    end;
    SetToACID(DBEdtToID.Text);
  end;
end;

procedure TFrmEditDetailsHeader.DTPYearChange(Sender: TObject);
begin
  DTPMonth.DateTime := DTPYear.DateTime;
  DTPDay.DateTime   := DTPYear.DateTime;
  DTPHour.DateTime  := DTPYear.DateTime;
end;

procedure TFrmEditDetailsHeader.EdtTotalAmountExit(Sender: TObject);
begin
  DBEdtTotalAmount.Text := StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll]);
end;

procedure TFrmEditDetailsHeader.DTPMonthChange(Sender: TObject);
begin
  DTPYear.DateTime := DTPMonth.DateTime;
  DTPDay.DateTime  := DTPMonth.DateTime;
  DTPHour.DateTime := DTPYear.DateTime;
end;

procedure TFrmEditDetailsHeader.DTPDayChange(Sender: TObject);
begin
  DTPYear.DateTime  := DTPDay.DateTime;
  DTPMonth.DateTime := DTPDay.DateTime;
  DTPHour.DateTime  := DTPYear.DateTime;
end;

procedure TFrmEditDetailsHeader.DTPHourChange(Sender: TObject);
begin
  DTPYear.DateTime  := DTPHour.DateTime;
  DTPMonth.DateTime := DTPHour.DateTime;
  DTPDay.DateTime   := DTPHour.DateTime;
end;

procedure TFrmEditDetailsHeader.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseTransactions;

  if FGoBack then begin
    FrmManageDetails := TFrmManageDetails.Create(Application);
    FrmManageDetails.Visible := True;
  end;
  CloseAction              := caFree;
  FrmEditDetailsHeader     := nil;
end;

procedure TFrmEditDetailsHeader.FormShow(Sender: TObject);
var
  i            : Integer;
begin
  FGoBack := True;

  FrmEditDetailsHeader.Color := RGB(112, 168, 175);
  PnlEntryShop.Color         := RGB( 72, 122, 129);
  PnlEntryAccount.Color      := RGB( 72, 122, 129);
  PnlAddDetail.Color         := RGB( 72, 122, 129);
  PnlEditDetail.Color        := RGB( 72, 122, 129);
  PnlRemoveDetail.Color      := RGB( 72, 122, 129);
  PnlGoBack.Color            := RGB( 72, 122, 129);

  with FrmTopMenu.Defs do begin
    with AQu do begin
      OpenConn(ACn, ADS, ATr, AQu);
        SQL.Text := SQL_20100006;
      Params.ParamByName('pUserID').AsInteger   := GetUID;
      Params.ParamByName('pHeaderID').AsInteger := GetHID;
      Open;
      SetHeaderDT(FormatDateTime('yyyy/mm/dd hh:mm:ss', FieldByName('HEADER_DT').AsDateTime, GetFS));
      if EdtTotalAmount.Text <> '' then begin
        SetTotalAmount(StrToInt(StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll])));
      end else begin
        SetTotalAmount(0);
      end;
    end;
  end;

  with FrmTopMenu.Defs do begin
    if VarIsNull(GetHeaderDT) then begin
      DTPYear.DateTime := Now;
    end else begin
      DTPYear.DateTime := StrToDateTime(GetHeaderDT, GetFS);
    end;
  end;

  try
    with FrmTopMenu.Defs do begin
      OpenSelQuAndSetVal(
        ACnShop  , ADSShop  , ATrShop  , AQuShop  , DBLCBShopName,
        DBEdtShopID , SQL_20100001, GetShopID);

      if (Not VarIsNull(GetShopID)) And (GetShopID > 0) then begin
        AQuShop.First;
        while Not AQuShop.EOF do begin
          if AQuShop.FieldByName('SHOP_ID').AsInteger = GetShopID then begin
            Break;
          end;
          AQuShop.Next;
        end;
        if AQuShop.FieldByName('PHONE_NUM').AsAnsiString <> '' then begin
          DBEdtPhonem.Text := AQuShop.FieldByName('PHONE_NUM').AsAnsiString;
        end;
      end else begin
        DBEdtPhonem.Text := '';
      end;

      OpenSelQuAndSetVal(
        ACnExp1  , ADSExp1  , ATrExp1  , AQuExp1  , DBLCBExp1    ,
        DBEdtExpKey1, SQL_20100002, GetExpKey1);

      DBLCBExp1Change(Self);

      if Not VarIsNull(GetFromACID) then begin
        OpenSelQuAndSetVal(
          ACnFromAC, ADSFromAC, ATrFromAC, AQuFromAC, DBLCBFromAC  ,
          DBEdtFromID , SQL_20100003, GetFromACID);
      end;
      if Not VarIsNull(GetToACID) then begin
        OpenSelQuAndSetVal(
          ACnToAC  , ADSToAC  , ATrToAC  , AQuToAC  , DBLCBToAC    ,
          DBEdtToID   , SQL_20100004, GetToACID);
      end;
    end;

    with FrmTopMenu.Defs do begin
      if VarIsNull(GetHeaderDT) then begin
        DTPYear.DateTime := Now;
      end else begin
          DTPYear.DateTime := StrToDateTime(GetHeaderDT, GetFS);
      end;
    end;

    if VarIsNull(DBLCBShopName.KeyValue) then begin
      DBEdtPhonem.Text := '';
    end;

    DBEdtUserID.Text     := FrmTopMenu.Defs.GetUID.ToString;

    with FrmTopMenu.Defs do begin
      with AQuDetail do begin
        OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
        SQL.Text   := SQL_20100009;
        Params.ParamByName('pUserID').AsInteger   := GetUID;
        Params.ParamByName('pHeaderID').AsInteger := GetHID;
        Open;

        if RecordCount <= 0 then begin
          BtnEditDetail.Enabled   := False;
          BtnRemoveDetail.Enabled := False;
        end else begin
          BtnEditDetail.Enabled   := True;
          BtnRemoveDetail.Enabled := True;
        end;
      end;
    end;
    SetButtonEnabled(AQuDetail);
    ADBGrid.AutoAdjustColumns;

    // Summarize
    Summarize;

    if DBEdtTotalAmount.Text <> '' then begin
      EdtTotalAmount.Text := FormatFloat('#,##0', StrToInt(DBEdtTotalAmount.Text));
    end else begin
      EdtTotalAmount.Text := FormatFloat('#,##0', 0);
    end;

    DBLCBShopName.Height := 46;
    DBLCBExp1.Height     := 46;

    FrmEditDetailsHeader.Width := 859;
    { Debug }
    //FrmAddDetailsHeader.Width := 1167;
  finally
  end;
end;

end.

