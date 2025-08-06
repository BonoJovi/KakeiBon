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
    { Main DB components }
    ACn              : TSQLite3Connection;
    ADS              : TDataSource;
    ATr              : TSQLTransaction;
    AQu              : TSQLQuery;
    { Detatil DB components }
    ACnDetail        : TSQLite3Connection;
    ADSDetail        : TDataSource;
    ATrDetail        : TSQLTransaction;
    AQuDetail        : TSQLQuery;
    { NextID DB components }
    ACnNextID        : TSQLite3Connection;
    ADSNextID        : TDataSource;
    ATrNextID        : TSQLTransaction;
    AQuNextID        : TSQLQuery;
    { Shop DB components }
    ACnShop          : TSQLite3Connection;
    ADSShop          : TDataSource;
    ATrShop          : TSQLTransaction;
    AQuShop          : TSQLQuery;
    { Exp1 DB components }
    ACnExp1          : TSQLite3Connection;
    ADSExp1          : TDataSource;
    ATrExp1          : TSQLTransaction;
    AQuExp1          : TSQLQuery;
    { FromAC DB components }
    ACnFromAC        : TSQLite3Connection;
    ADSFromAC        : TDataSource;
    ATrFromAC        : TSQLTransaction;
    AQuFromAC        : TSQLQuery;
    { ToAc DB components }
    ACnToAC          : TSQLite3Connection;
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
    { Etc components }
    ADBNav           : TDBNavigator;
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
    DBEdtTotalAmount : TDBEdit;
    DBEdtUserID      : TDBEdit;
    DBEdtToID        : TDBEdit;
    DBEdtPhoneNum    : TDBEdit;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FGoBack      : Boolean;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    procedure BackupValues;
    function CheckInput: Boolean;
    procedure ProcAddDetail;
    procedure ProcEditDetail;
    procedure ProcEntryAccount;
    procedure ProcEntryShop;
    procedure ProcRemoveDetail;
    procedure SetButtonEnabled(Qu: TSQLQuery);
    function GetFractionProc: Integer;
    procedure UpdateFractionProc(FractionProc: Integer; SS: String);
    procedure ReQuery;
    procedure Summarize;
    function GetGoBack: Boolean;
    procedure SetGoBack(aGoBack: Boolean);
    property GoBack: Boolean read GetGoBack write SetGoBack;
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

procedure TFrmEditDetailsHeader.SetDatabaseNames;
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

procedure TFrmEditDetailsHeader.CloseTransactions;
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

procedure TFrmEditDetailsHeader.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    with DBEdtHeaderID do begin
      if Text <> '' then begin;
        SetHID(StrToInt(Text));
      end;
    end;

    with AQuDetail do begin
      if (RecordCount > 0)
        And (FieldByName('DETAIL_ID').AsInteger > 0) then begin
        SetDID(FieldByName('DETAIL_ID').AsInteger);
      end;
    end;

    DBDTPHeaderDT.TimeFormat := tf24;
    SetHeaderDT(
      DateTimeToStr(DTPYear.DateTime)
    );
    if DBEdtShopID.Text <> '' then begin
      SetShopID(DBEdtShopID.Text);
    end;
    if DBEdtExpKey1.Text <> '' then begin
      SetExpKey1(DBEdtExpKey1.Text);
    end;
    if (DBLCBFromAC.Enabled) And (VarToStr(DBLCBFromAC.KeyValue) <> '') then begin
      SetFromACID(DBLCBFromAC.KeyValue);
    end;
    if (DBLCBToAC.Enabled) And (VarToStr(DBLCBToAC.KeyValue) <> '') then begin
      SetToACID(DBLCBToAC.KeyValue);
    end;
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
        with FrmTopMenu.Defs do begin
          with AQu do begin
            SQL.Text := SQL_20100008;
            with Params do begin
              ParamByName('pUserID').AsInteger        := GetUID;
              ParamByName('pHeaderID').AsInteger      := GetHID;
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
              ParamByName('pUpdateDT').AsDateTime      := Now;
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
        with FrmTopMenu.Defs do begin
          with AQuDetail do begin
            SetDID(FieldByName('DETAIL_ID').AsInteger);
          end;
          with AQu do begin
            SQL.Text := SQL_20100008;
            with Params do begin
              ParamByName('pUserID').AsInteger        := GetUID;
              ParamByName('pHeaderID').AsInteger      := GetHID;
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
              ParamByName('pUpdateDT').AsDateTime     := Now;
            end;

            UpdateMode                                       := upWhereAll;

            CloseTransactions;
            ExecSQL;
            ATr.Commit;
          end;

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
var
  LResult   : TModalResult;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with AQuDetail do begin
          SQL.Text := SQL_20100010;
          with Params do begin
            ParamByName('pUserID').AsInteger   := GetUID;
            ParamByName('pHeaderID').AsInteger := GetHID;
          end;

          CloseTransactions;
          Open;

          First;
          while Not EOF do begin
            if FieldByName('DETAIL_ID').AsInteger = StrToInt(VarToStr(GetDID)) then begin
              break;
            end;
            Next;
          end;

          LResult:= QuestionDlg(
            REMOVE_DETAILS_HEADER_CAPTION, REMOVE_DETAILS_HEADER_MESSAGE,
            mtConfirmation, [mrYes, mrNo], 0);
          if LResult = mrYes then begin
            Edit;
            Delete;
            ApplyUpdates;
            ATrDetail.Commit;

            SetButtonEnabled(AQuDetail);
          end;
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
          And (VarToStr(GetFromACID) <> '')
          And (StrToInt(VarToStr(GetFromACID)) > 0) then begin
          OpenSelQuAndSetVal(
            ACnFromAC, ADSFromAC, ATrFromAC, AQuFromAC, DBLCBFromAC  ,
            DBEdtFromID , SQL_20100003, StrToInt(VarToStr(GetFromACID)));
          DBLCBFromACChange(Self);
        end;

        if (Not VarIsNull(GetToACID))
          And (VarToStr(GetToACID) <> '')
          And (StrToInt(VarToStr(GetToACID)) > 0) then begin
          OpenSelQuAndSetVal(
            ACnToAC  , ADSToAC  , ATrToAC  , AQuToAC  , DBLCBToAC    ,
            DBEdtToID   , SQL_20100004, StrToInt(VarToStr(GetToACID)));
          if AQuToAC.RecordCount > 0 then begin
            DBLCBToACChange(Self);
          end;
        end;

        with AQuDetail do begin
          CloseConn(ACnDetail, ATrDetail);
          //OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
          SQL.Text := SQL_20100009;
          with Params do begin
            ParamByName('pUserID').AsInteger   := GetUID;
            ParamByName('pHeaderID').AsInteger := GetHID;
          end;
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

function TFrmEditDetailsHeader.GetFractionProc: Integer;
begin
  if AQuShop.FieldByName('DO_TRUNCATE').AsBoolean then begin
    Result := FRACTION_PROC_TRUNCATE;
  end else if AQuShop.FieldByName('DO_ROUND').AsBoolean then begin
    Result := FRACTION_PROC_ROUND;
  end else if AQuShop.FieldByName('DO_ROUND_UP').AsBoolean then begin
    Result := FRACTION_PROC_ROUND_UP;
  end else begin
    Result := FRACTION_PROC_UNDEF;
  end;
end;

procedure TFrmEditDetailsHeader.UpdateFractionProc(
  FractionProc: Integer; SS: String);
begin
  with FrmTopMenu.Defs do begin
    if FractionProc = FRACTION_PROC_UNDEF then begin
      CloseTransactions;
      UpdateFractionProcQueryWithShopID(
        ACnShop, ADSShop, ATrShop, AQuShop,
        SS, StrToInt(VarToStr(GetShopID)));
      ATrShop.Commit;
    end;
  end;
end;

procedure TFrmEditDetailsHeader.ReQuery;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
    //OpenConn(ACn, ADS, ATr, AQu);
    SetDatabaseNames;
    OpenSelectQueryWithHeaderID(
      ACn, ADS, ATr, AQu, SQL_20100006, GetHID);
    OpenSelQuAndSetVal(
      ACnShop  , ADSShop  , ATrShop  , AQuShop  , DBLCBShopName,
      DBEdtShopID , SQL_20100001, StrToInt(VarToStr(GetShopID)));
  end;
end;

procedure TFrmEditDetailsHeader.Summarize;
var
  LFractionProc : Integer;
  LDetailID     : Integer;
  LTotalAmount  : Integer;
begin
  try
    try
      if AQuDetail.RecordCount > 0 then begin
        LDetailID          := AQuDetail.FieldByName('DETAIL_ID').AsInteger;
        with FrmTopMenu.Defs do begin
          SetDID(LDetailID);
        end;
      end;

      // Get fruction processing type
      with FrmTopMenu.Defs do begin
        OpenSelQuAndSetVal(
          ACnShop  , ADSShop  , ATrShop  , AQuShop  , DBLCBShopName,
          DBEdtShopID , SQL_20100001, StrToInt(VarToStr(GetShopID)));

        LFractionProc := GetFractionProc;

        // Get total amount
        if (DBEdtTotalAmount.Text <> '')
          And (StrToInt(DBEdtTotalAmount.Text) <> 0) then begin
          LTotalAmount := StrToInt(DBEdtTotalAmount.Text);
        end else begin
          with AQu do begin
            CloseConn(ACn, ATr);
            //OpenConn(ACn, ADS, ATr, AQu);
            SetDatabaseNames;
            OpenSelectQueryWithHeaderID(
              ACn, ADS, ATr, AQu, SQL_20100006, GetHID);
            LTotalAmount := FieldByName('TOTAL_AMOUNT').AsInteger;
          end;
        end;

        with FrmTopMenu.Defs do begin
          with AQuDetail do begin
            if (LFractionProc = FRACTION_PROC_TRUNCATE)
              Or (LFractionProc = FRACTION_PROC_UNDEF) then begin
              // Calc TotalAmount (TRUNC)
                CloseConn(ACnDetail, ATrDetail);
                //OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
                SetDatabaseNames;
              OpenSelectQueryWithHeaderID(
                ACnDetail, ADSDetail, ATrDetail, AQuDetail, SQL_20100012, GetHID);
              if AQuDetail.FieldByName('TOTAL_AMOUNT').AsAnsiString <> '' then begin
                if LTotalAmount >= AQuDetail.FieldByName('TOTAL_AMOUNT').AsInteger then begin
                  SetTotalAmount(LTotalAmount);
                  UpdateFractionProc(LFractionProc, SQL_20100015);
                  ReQuery;
                  Exit;
                end;
              end;
            end;
          end;

          with AQuDetail do begin
            if (LFractionProc = FRACTION_PROC_ROUND_UP)
              Or (LFractionProc = FRACTION_PROC_UNDEF) then begin
              // Calc TotalAmount (ROUND_UP)
              CloseConn(ACnDetail, ATrDetail);
              //OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
              SetDatabaseNames;
              OpenSelectQueryWithHeaderID(
                ACnDetail, ADSDetail, ATrDetail, AQuDetail, SQL_20100013, GetHID);
              if AQuDetail.FieldByName('TOTAL_AMOUNT').AsAnsiString <> '' then begin
                if LTotalAmount <= AQuDetail.FieldByName('TOTAL_AMOUNT').AsInteger then begin
                  SetTotalAmount(LTotalAmount);
                  UpdateFractionProc(LFractionProc, SQL_20100016);
                  ReQuery;
                  Exit;
                end;
              end;
            end;
          end;

          with AQuDetail do begin
            if (LFractionProc = FRACTION_PROC_ROUND)
                Or (LFractionProc = FRACTION_PROC_UNDEF) then begin
              // Calc TotalAmount (ROUND)
              CloseConn(ACnDetail, ATrDetail);
              //OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
              SetDatabaseNames;
              OpenSelectQueryWithHeaderID(
                ACnDetail, ADSDetail, ATrDetail, AQuDetail, SQL_20100011, GetHID);
              if AQuDetail.FieldByName('TOTAL_AMOUNT').AsAnsiString <> '' then begin
                if LTotalAmount = AQuDetail.FieldByName('TOTAL_AMOUNT').AsInteger then begin
                  SetTotalAmount(LTotalAmount);
                  UpdateFractionProc(LFractionProc, SQL_20100014);
                  ReQuery;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATrShop.Rollback;
      end;
    end;
  finally
  end;
end;

function TFrmEditDetailsHeader.GetGoBack: Boolean;
begin
  Result  := FGoBack;
end;

procedure TFrmEditDetailsHeader.SetGoBack(aGoBack: Boolean);
begin
  FGoBack := aGoBack;
end;

procedure TFrmEditDetailsHeader.ActAddDetailExecute(Sender: TObject);
begin
  SetGoBack(False);
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
  SetGoBack(False);
  with FrmTopMenu.Defs do begin
    SetEditDetail(2);
  end;

  BackupValues;
  ProcEditDetail;
  Summarize;
end;

procedure TFrmEditDetailsHeader.ActEntryAccountExecute(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEntryAccount(2);
    ProcEntryAccount;
  end;
end;

procedure TFrmEditDetailsHeader.ActEntryShopExecute(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    SetGoBack(False);
    BackupValues;
    SetEntryShop(2);
    ProcEntryShop;
  end;
end;

procedure TFrmEditDetailsHeader.ActQuitExecute(Sender: TObject);
begin
  SetGoBack(True);
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
      if StrToInt(VarToStr(GetExpKey1)) = 1 then begin
        DBLCBFromAC.Enabled   := True;
        DBLCBToAC.Enabled     := False;
        DBLCBToAC.ItemIndex   := -1;

        if (DBLCBFromAC.Enabled) And (Not VarIsNull(DBLCBFromAC.KeyValue)) then begin
          DBEdtFromID.Text    := DBLCBFromAC.KeyValue;
        end;
        DBEdtToID.Text        := '';
      end else if StrToInt(VarToStr(GetExpKey1)) = 2 then begin
        DBLCBFromAC.Enabled   := False;
        DBLCBFromAC.ItemIndex := -1;
        DBLCBToAC.Enabled     := True;

        DBEdtFromID.Text      := '';
        if (DBLCBToAC.Enabled) And (Not VarIsNull(DBLCBToAC.KeyValue)) then begin
          DBEdtToID.Text      := DBLCBToAC.KeyValue;
        end;
      end else if StrToInt(VarToStr(GetExpKey1)) = 3 then begin
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

    //SetFromACID(DBEdtFromID.Text);
    //SetToACID(DBEdtToID.Text);
  end;
end;

procedure TFrmEditDetailsHeader.DBLCBShopNameChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if Not VarIsNull(DBLCBShopName.KeyValue) then begin
      DBEdtShopID.Text := VarToStr(DBLCBShopName.KeyValue);
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
      DBEdtFromID.Text := VarToStr(DBLCBFromAC.KeyValue);
    end else begin
      DBEdtFromID.Text := '';
    end;
    SetFromACID(DBLCBFromAC.KeyValue);
  end;
end;

procedure TFrmEditDetailsHeader.DBLCBToACChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if DBLCBToAC.Enabled then begin
      DBEdtToID.Text := VarToStr(DBLCBToAC.KeyValue);
    end else begin
      DBEdtToID.Text := '';
    end;
    SetToACID(DBLCBToAC.KeyValue);
  end;
end;

procedure TFrmEditDetailsHeader.DTPYearChange(Sender: TObject);
begin
  with DTPYear do begin
    DTPMonth.DateTime := DateTime;
    DTPDay.DateTime   := DateTime;
    DTPHour.DateTime  := DateTime;
  end;
end;

procedure TFrmEditDetailsHeader.EdtTotalAmountExit(Sender: TObject);
begin
  DBEdtTotalAmount.Text := StringReplace(EdtTotalAmount.Text, ',', '', [rfReplaceAll]);
end;

procedure TFrmEditDetailsHeader.DTPMonthChange(Sender: TObject);
begin
  with DTPMonth do begin
    DTPYear.DateTime := DateTime;
    DTPDay.DateTime  := DateTime;
    DTPHour.DateTime := DTPYear.DateTime;
  end;
end;

procedure TFrmEditDetailsHeader.DTPDayChange(Sender: TObject);
begin
  with DTPDay do begin
    DTPYear.DateTime  := DateTime;
    DTPMonth.DateTime := DateTime;
    DTPHour.DateTime  := DTPYear.DateTime;
  end;
end;

procedure TFrmEditDetailsHeader.DTPHourChange(Sender: TObject);
begin
  with DTPHour do begin
    DTPYear.DateTime  := DateTime;
    DTPMonth.DateTime := DateTime;
    DTPDay.DateTime   := DateTime;
  end;
end;

procedure TFrmEditDetailsHeader.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseTransactions;

  if GetGoBack then begin
    FrmManageDetails := TFrmManageDetails.Create(Application);
    FrmManageDetails.Visible := True;
  end;
  CloseAction              := caFree;
  FrmEditDetailsHeader     := nil;
end;

procedure TFrmEditDetailsHeader.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  SetGoBack(True);
end;

procedure TFrmEditDetailsHeader.FormShow(Sender: TObject);
begin
  FrmEditDetailsHeader.Color := RGB(112, 168, 175);
  PnlEntryShop.Color         := RGB( 72, 122, 129);
  PnlEntryAccount.Color      := RGB( 72, 122, 129);
  PnlAddDetail.Color         := RGB( 72, 122, 129);
  PnlEditDetail.Color        := RGB( 72, 122, 129);
  PnlRemoveDetail.Color      := RGB( 72, 122, 129);
  PnlGoBack.Color            := RGB( 72, 122, 129);

  with FrmTopMenu.Defs do begin
    with AQu do begin
      CloseConn(ACn, ATr);
      //OpenConn(ACn, ADS, ATr, AQu);
      SetDatabaseNames;
      SQL.Text := SQL_20100006;
      with Params do begin
        ParamByName('pUserID').AsInteger   := GetUID;
        ParamByName('pHeaderID').AsInteger := GetHID;
      end;
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
    if GetHeaderDT = '' then begin
      DTPYear.DateTime := Now;
    end else begin
      DTPYear.DateTime := StrToDateTime(GetHeaderDT, GetFS);
    end;
  end;

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

      if Not VarIsNull(GetToACID)
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

      if GetHeaderDT = '' then begin
        DTPYear.DateTime := Now;
      end else begin
          DTPYear.DateTime := StrToDateTime(GetHeaderDT, GetFS);
      end;

      if VarIsNull(DBLCBShopName.KeyValue) then begin
        DBEdtPhoneNum.Text := '';
      end;

      DBEdtUserID.Text     := IntToStr(GetUID);

      with AQuDetail do begin
        CloseConn(ACnDetail, ATrDetail);
        //OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
        SetDatabaseNames;
        OpenSelectQueryWithHeaderID(
          ACnDetail, ADSDetail, ATrDetail, AQuDetail, SQL_20100009, GetHID);

        if RecordCount <= 0 then begin
          BtnEditDetail.Enabled   := False;
          BtnRemoveDetail.Enabled := False;
        end else begin
          BtnEditDetail.Enabled   := True;
          BtnRemoveDetail.Enabled := True;
        end;
      end;

      SetButtonEnabled(AQuDetail);
      ADBGrid.AutoAdjustColumns;

      if DBEdtTotalAmount.Text <> '' then begin
        EdtTotalAmount.Text := FormatFloat('#,##0', StrToInt(DBEdtTotalAmount.Text));
      end else begin
        EdtTotalAmount.Text := FormatFloat('#,##0', 0);
      end;

      Summarize;

      CloseConn(ACnDetail, ATrDetail);
      //OpenConn(ACnDetail, ADSDetail, ATrDetail, AQuDetail);
      SetDatabaseNames;
      OpenSelectQueryWithHeaderID(
        ACnDetail, ADSDetail, ATrDetail, AQuDetail, SQL_20100009, GetHID);
    end;

    DBLCBShopName.Height := 46;
    DBLCBExp1.Height     := 46;

    FrmEditDetailsHeader.Width := 859;
    { Debug }
    //FrmEditDetailsHeader.Width := 1167;
  finally
  end;
end;

end.

