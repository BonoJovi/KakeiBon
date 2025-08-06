unit UEntryAccount;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, LCLType, Variants, LazUTF8, SysUtils, DB, SQLDB,
  SQLite3Conn, Forms, Controls, Graphics, Dialogs, ExtCtrls, LCLIntf, ActnList,
  StdCtrls, DBCtrls, DBGrids, DBDateTimePicker;

type

  { TFrmEntryAccount }

  TFrmEntryAccount = class(TForm)
    ActCancel1: TAction;
    ActCommit1: TAction;
    ActInsert1: TAction;
    ActQuit1: TAction;
    ADS                 : TDataSource;
    ADSNextID           : TDataSource;
    AQu                 : TSQLQuery;
    AQuNextID           : TSQLQuery;
    ATr                 : TSQLTransaction;
    ATrNextID           : TSQLTransaction;
    ActCancel           : TAction;
    ActCommit           : TAction;
    ActInsert           : TAction;
    ActionList          : TActionList;
    ActQuit             : TAction;
    ADBGrid             : TDBGrid;
    ADBNav              : TDBNavigator;
    BtnInsert           : TButton;
    BtnCancel           : TButton;
    BtnCommit           : TButton;
    BtnGoBack           : TButton;
    DBCBDisabled        : TDBCheckBox;
    DBDTPEntryDT        : TDBDateTimePicker;
    DBDTPUpdateDT       : TDBDateTimePicker;
    DBEdtPhoneNum       : TDBEdit;
    DBEdtOpeningBalance : TDBEdit;
    DBEdtCurrentBalance : TDBEdit;
    DBEdtAccountID      : TDBEdit;
    DBEdtBrandName      : TDBEdit;
    DBEdtSubName        : TDBEdit;
    LblAccountID1       : TLabel;
    LblOpeningBalance   : TLabel;
    LblCurrentBalance   : TLabel;
    LblDisabled1        : TLabel;
    LblDisabled2        : TLabel;
    LblAccountID2       : TLabel;
    LblDisabled3        : TLabel;
    LblSubName1         : TLabel;
    LblSubName2         : TLabel;
    LblSubName3         : TLabel;
    LblBrandName1       : TLabel;
    LblBrandName2       : TLabel;
    LblPhoneNumber3     : TLabel;
    LblPhoneNumber2     : TLabel;
    LblPhoneNumber1     : TLabel;
    LblPhoneNumber4     : TLabel;
    PnlCancel           : TPanel;
    PnlCommit           : TPanel;
    PnlGoBack           : TPanel;
    PnlInsert           : TPanel;
    ACn: TSQLite3Connection;
    ACnNextID: TSQLite3Connection;
    Timer               : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ADBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBEdtAccountIDChange(Sender: TObject);
    procedure DBEdtBrandNameChange(Sender: TObject);
    procedure DBEdtCurrentBalanceChange(Sender: TObject);
    procedure DBEdtOpeningBalanceChange(Sender: TObject);
    procedure DBEdtPhoneNumChange(Sender: TObject);
    procedure DBEdtSubNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FReOpenDS       : Boolean;
    FInsert         : Boolean;
    FDoCommit       : Boolean;
    FAccountID      : Variant;
    FBrandName      : String;
    FSubName        : String;
    FPhoneNum       : String;
    FOpeningBalance : Integer;
    FCurrentBalance : Integer;
    FDisabled       : Boolean;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    procedure BackupValues;
    function GetAccountID: Variant;
    procedure SetAccountID(AccountID: Variant);
    function GetBrandName: String;
    procedure SetBrandName(BrandName: String);
    function GetSubName: String;
    procedure SetSubName(SubName: String);
    function GetPhoneNum: String;
    procedure SetPhoneNum(PhoneNum: String);
    function GetOpeningBalance: Integer;
    procedure SetOpeningBalance(OpeningBalance: Integer);
    function GetCurrentBalance: Integer;
    procedure SetCurrentBalance(CurrentBalance: Integer);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    procedure ProcInsert;
    procedure ProcCancel;
    procedure ProcCommit;
    property AccountID: Variant read GetAccountID write SetAccountID;
    property BrandName: String read GetBrandName write SetBrandName;
    property SubName: String read GetSubName write SetSubName;
    property PhoneNum: String read GetPhoneNum write SetPhoneNum;
    property OpeningBalance: Integer read GetOpeningBalance write SetOpeningBalance;
    property CurrentBalance: Integer read GetCurrentBalance write SetCurrentBalance;
    property Disabled: Boolean read GetDisabled write SetDisabled;
  public

  end;

var
  FrmEntryAccount: TFrmEntryAccount;

implementation
uses
  UConsts, UDefs, UDBAccess, UTopMenu, UManageDetails, UAddDetailsHeader,
  UEditDetailsHeader;

{$R *.lfm}

{ TFrmEntryAccount }

procedure TFrmEntryAccount.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn      );
    SetDatabaseName(ACnNextID);
  end;
end;

procedure TFrmEntryAccount.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);
  end;
end;

procedure TFrmEntryAccount.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    with DBEdtAccountID do begin
      if Text <> '' then begin;
        SetAccountID(Text);
      end else begin
        SetAccountID(Null);
      end;
    end;

    SetBrandName(DBEdtBrandName.Text);
    SetSubName(DBEdtSubName.Text);
    SetPhoneNum(DBEdtPhoneNum.Text);
    SetOpeningBalance(DBEdtOpeningBalance.Field.AsInteger);
    SetCurrentBalance(DBEdtCurrentBalance.Field.AsInteger);

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

procedure TFrmEntryAccount.ProcCancel;
begin
  with FrmTopMenu.Defs do begin
    if FInsert then begin
      FInsert := False;
    end;
    ATr.Rollback;
    CloseTransactions;
    SetDatabaseNames;

    OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20110001);
    DBEdtBrandName.SetFocus;
  end;
end;

procedure TFrmEntryAccount.ProcCommit;
var
  LNextAccountID : Integer;
  LNow       : TDateTime;
begin
  FDoCommit := True;
  try
    try
      with FrmTopMenu.Defs do begin
        with AQu do begin
          SQL.Text := SQL_20110003;
          with Params do begin
            ParamByName('pUserID').AsInteger         := GetUID;
          end;

          if (VarIsNull(GetAccountID)) Or (VarToStr(GetAccountID) = '') then begin
            CloseTransactions;
            SetDatabaseNames;

            OpenSelectQuery(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20110002);
            LNextAccountID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
            CloseConn(ACnNextID, ATrNextID);
            with Params do begin
              ParamByName('pAccountID').AsInteger    := LNextAccountID;
            end;
          end else begin
            with Params do begin
              ParamByName('pAccountID').AsInteger    := StrToInt(VarToStr(GetAccountID));
            end;
          end;
          with Params do begin
            ParamByName('pBrandName').AsAnsiString   := GetBrandName;
            ParamByName('pSubName').AsAnsiString     := GetSubName;
            ParamByName('pPhoneNum').AsAnsiString    := GetPhoneNum;
            ParamByName('pOpeningBalance').AsInteger := GetOpeningBalance;
            ParamByName('pCurrentBalance').AsInteger := GetCurrentBalance;
            ParamByName('pDisabled').AsBoolean       := GetDisabled;
            LNow                                            := Now;
            ParamByName('pEntryDT').AsDateTime       := LNow;
            ParamByName('pUpdateDT').AsDateTime      := LNow;
          end;

          CloseTransactions;
          ExecSQL;
          ATr.Commit;
        end;
      end;
    except
      on E: ESQLDatabaseError do
      begin
        ShowMessage(E.Message);
      end;
    end;
  finally
    FInsert := False;
  end;

  FReOpenDS     := True;
  Timer.Enabled := True;
  FDoCommit     := False;
end;

procedure TFrmEntryAccount.ProcInsert;
begin
  if Not FInsert then begin
    with AQu do begin
      Edit;
      if AQu.RecordCount > 0 then begin;
        Insert;
      end;
      FInsert := True;
    end;

    DBCBDisabled.Field.AsBoolean := False;
    DBEdtBrandName.SetFocus;
  end;
end;

function TFrmEntryAccount.GetAccountID: Variant;
begin
  Result := FAccountID;
end;

procedure TFrmEntryAccount.SetAccountID(AccountID: Variant);
begin
  FAccountID := AccountID;
end;

function TFrmEntryAccount.GetBrandName: String;
begin
  Result := FBrandName;
end;

procedure TFrmEntryAccount.SetBrandName(BrandName: String);
begin
  FBrandName := BrandName;
end;

function TFrmEntryAccount.GetSubName: String;
begin
  Result := FSubName;
end;

procedure TFrmEntryAccount.SetSubName(SubName: String);
begin
  FSubName := SubName;
end;

function TFrmEntryAccount.GetPhoneNum: String;
begin
  Result := FPhoneNum;
end;

procedure TFrmEntryAccount.SetPhoneNum(PhoneNum: String);
begin
  FPhoneNum := PhoneNum;
end;

function TFrmEntryAccount.GetOpeningBalance: Integer;
begin
  Result := FOpeningBalance;
end;

procedure TFrmEntryAccount.SetOpeningBalance(OpeningBalance: Integer);
begin
  FOpeningBalance := OpeningBalance;
end;

function TFrmEntryAccount.GetCurrentBalance: Integer;
begin
  Result := FCurrentBalance;
end;

procedure TFrmEntryAccount.SetCurrentBalance(CurrentBalance: Integer);
begin
  FCurrentBalance := CurrentBalance;
end;

function TFrmEntryAccount.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryAccount.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryAccount.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmEntryAccount.ActCommitExecute(Sender: TObject);
begin
  BackupValues;
  ProcCommit;
end;

procedure TFrmEntryAccount.ActInsertExecute(Sender: TObject);
begin
  ProcInsert;
end;

procedure TFrmEntryAccount.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryAccount.ADBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) And (Key = VK_E) then begin
    DBEdtBrandName.SetFocus;
  end;
end;

procedure TFrmEntryAccount.ADBGridSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
  AQu.Edit;
end;

procedure TFrmEntryAccount.DBEdtAccountIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetAccountID(DBEdtAccountID.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtBrandNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetBrandName(DBEdtBrandName.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtSubNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetSubName(DBEdtSubName.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtPhoneNumChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetPhoneNum(DBEdtPhoneNum.Text);
  end;
end;

procedure TFrmEntryAccount.DBEdtOpeningBalanceChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if DBEdtOpeningBalance.Text = '' then begin
      SetOpeningBalance(0);
    end else begin
      SetOpeningBalance(DBEdtOpeningBalance.Field.AsInteger);
    end;
  end;
end;

procedure TFrmEntryAccount.DBEdtCurrentBalanceChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if DBEdtCurrentBalance.Text = '' then begin
      SetCurrentBalance(0);
    end else begin
      SetCurrentBalance(DBEdtCurrentBalance.Field.AsInteger);
    end;
  end;
end;

procedure TFrmEntryAccount.DBCBDisabledChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

procedure TFrmEntryAccount.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);

    SetAccountID(FAccountID);

    if GetEntryAccount = 0 then begin
      FrmManageDetails.Visible  := True;
    end else if GetEntryAccount = 1 then begin
      FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
      FrmAddDetailsHeader.Visible  := True;
    end else if GetEntryAccount = 2 then begin
      FrmEditDetailsHeader := TFrmEditDetailsHeader.Create(Application);
      FrmEditDetailsHeader.Visible  := True;
    end;
  end;

  CloseAction     := caFree;
  FrmEntryAccount := nil;
end;

procedure TFrmEntryAccount.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FReOpenDS := False;
  FDoCommit := False;
end;

procedure TFrmEntryAccount.FormShow(Sender: TObject);
begin
  Color := RGB(112, 168, 175);

  PnlInsert.Color       := RGB( 72, 122, 129);
  PnlCancel.Color       := RGB( 72, 122, 129);
  PnlCommit.Color       := RGB( 72, 122, 129);
  PnlGoBack.Color       := RGB( 72, 122, 129);

  FAccountID := GetAccountID;

  try
    with FrmTopMenu.Defs do begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20110001);
      ADBGrid.DataSource := ADS;
      if AQu.RecordCount = 0 then begin
        ProcInsert;
      end else begin
        FInsert := False;
      end;

      ADBGrid.AutoAdjustColumns;
      DBEdtBrandName.SetFocus;
    end;
  finally
  end;
end;

procedure TFrmEntryAccount.TimerTimer(Sender: TObject);
begin
  if FReOpenDS then
  begin
    with FrmTopMenu.Defs do begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20110001);
      ADBGrid.DataSource := ADS;

      FReOpenDS       := False;
      Timer.Enabled   := False;
    end;
  end;
end;

end.

