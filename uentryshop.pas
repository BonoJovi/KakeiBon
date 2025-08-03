unit UEntryShop;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, DBGrids, DBCtrls, StdCtrls, LCLIntf, ActnList,
  DBDateTimePicker;

type

  { TFrmEntryShop }

  TFrmEntryShop = class(TForm)
    ADS                  : TDataSource;
    ADSNextID            : TDataSource;
    AQu                  : TSQLQuery;
    AQuNextID            : TSQLQuery;
    ATr                  : TSQLTransaction;
    ATrNextID            : TSQLTransaction;
    ActCancel            : TAction;
    ActCommit            : TAction;
    ActInsert            : TAction;
    ActionList           : TActionList;
    ActQuit              : TAction;
    ADBGrid              : TDBGrid;
    ADBNav               : TDBNavigator;
    BtnInsert            : TButton;
    BtnCancel            : TButton;
    BtnCommit            : TButton;
    BtnGoBack            : TButton;
    DBCBDisabled         : TDBCheckBox;
    DBDTPEndBusinessDT   : TDBDateTimePicker;
    DBDTPUpdateDT        : TDBDateTimePicker;
    DBDTPStartBusinessDT : TDBDateTimePicker;
    DBDTPEntryDT         : TDBDateTimePicker;
    DBEdtShopName        : TDBEdit;
    DBEdtShopID          : TDBEdit;
    DBEdtPhoneNum        : TDBEdit;
    LblID1               : TLabel;
    LblStartBusinessDT1  : TLabel;
    LblStartBusinessDT2  : TLabel;
    LblStartBusinessDT3  : TLabel;
    LblStartBusinessDT4  : TLabel;
    LblEndBusinessDT1    : TLabel;
    LblEndBusinessDT2    : TLabel;
    LblEndBusinessDT3    : TLabel;
    LblEndBusinessDT4    : TLabel;
    LblDisabled1         : TLabel;
    LblDisabled2         : TLabel;
    LblID2               : TLabel;
    LblDisabled3         : TLabel;
    LblShopName1         : TLabel;
    LblShopName2         : TLabel;
    LblShopName3         : TLabel;
    LblPhoneNumber3      : TLabel;
    LblPhoneNumber2      : TLabel;
    LblPhoneNumber1      : TLabel;
    LblPhoneNumber4      : TLabel;
    PnlCancel            : TPanel;
    PnlCommit            : TPanel;
    PnlGoBack            : TPanel;
    PnlInsert            : TPanel;
    ACn: TSQLite3Connection;
    ACnNextID: TSQLite3Connection;
    Timer                : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ADBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBDTPEndBusinessDTChange(Sender: TObject);
    procedure DBDTPStartBusinessDTChange(Sender: TObject);
    procedure DBEdtPhoneNumChange(Sender: TObject);
    procedure DBEdtShopIDChange(Sender: TObject);
    procedure DBEdtShopNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    //procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FDoCommit        : Boolean;
    FReOpenDS        : Boolean;
    FInsert          : Boolean;
    //FShopID          : Variant;
    //FShopName        : String;
    //FPhoneNum        : String;
    //FStartBusinessDT : String;
    //FEndBusinessDT   : String;
    //FDisabled        : Boolean;
    procedure CloseTransactions;
    procedure SetDatabaseNames;
    procedure BackupValues;
    procedure ProcCancel;
    procedure ProcCommit;
    procedure ProcInsert;
    function GetShopName: String;
    procedure SetShopName(ShopName: String);
    function GetPhoneNum: String;
    procedure SetPhoneNum(PhoneNum: String);
    function GetStartBusinessDT: String;
    procedure SetStartBusinessDT(StartBusinessDT: String);
    function GetEndBusinessDT: String;
    procedure SetEndBusinessDT(EndBusinessDT: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    property FShopName: String read GetShopName write SetShopName;
    property FPhoneNum: String read GetPhoneNum write SetPhoneNum;
    property FStartBusinessDT: String read GetStartBusinessDT write SetStartBusinessDT;
    property FEndBusinessDT: String read GetEndBusinessDT write SetEndBusinessDT;
    property FDisabled: Boolean read GetDisabled write SetDisabled;
  public

  end;

var
  FrmEntryShop: TFrmEntryShop;

implementation
uses
  UConsts, UDBAccess, UTopMenu, UManageDetails, UAddDetailsHeader,
  UEditDetailsHeader;

{$R *.lfm}

{ TFrmEntryShop }

procedure TFrmEntryShop.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);
  end;
end;

procedure TFrmEntryShop.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    ACn.DatabaseName       := GetHomeDir + DB_NAME;
    ACnNextID.DatabaseName := GetHomeDir + DB_NAME;
  end;
end;

procedure TFrmEntryShop.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    if DBEdtShopID.Text <> '' then begin;
      GetShopID.SetShopID(DBEdtShopID.Text);
    end else begin
      SetShopID(Null);
    end;

    SetShopName(DBEdtShopName.Text);

    SetPhoneNum(DBEdtPhoneNum.Text);

    SetStartBusinessDT(FormatDateTime(
      'yyyy/mm/dd hh:mm:ss',
      DBDTPStartBusinessDT.Field.AsDateTime,
      FrmTopMenu.Defs.GetFS));

    if Not DBDTPEndBusinessDT.Field.IsNull then begin;
      SetEndBusinessDT(FormatDateTime(
        'yyyy/mm/dd hh:mm:ss',
        DBDTPEndBusinessDT.Field.AsDateTime,
        FrmTopMenu.Defs.GetFS));
    end else begin
      SetEndBusinessDT('9999/12/31 23:59:59');
    end;

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

procedure TFrmEntryShop.ProcCancel;
begin
  if FInsert then begin
    FInsert := False;
  end;
  ATr.Rollback;
  FrmTopMenu.Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20080001);
  DBEdtShopName.SetFocus;
end;

procedure TFrmEntryShop.ProcCommit;
var
  LNextShopID : Integer;
  LNow        : TDateTime;
begin
  FDoCommit := True;
  try
    try
      with AQu do begin
        with FrmTopMenu.Defs do begin
          SQL.Text := SQL_20080003;
          Params.ParamByName('pUserID').AsInteger   := GetUID;

          if (VarIsNull(GetShopID))
              Or (VarToStr(GetShopID) = '') then begin
            OpenSelectQuery(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20080002);
            LNextShopID := AQuNextID.FieldByName('NEXT_ID').AsInteger;
            CloseConn(ACnNextID, ATrNextID);
            SetDatabaseNames;
            Params.ParamByName('pShopID').AsInteger := LNextShopID;
          end else begin
            Params.ParamByName('pShopID').AsInteger := StrToInt(VarToStr(GetShopID));
          end;
          Params.ParamByName('pShopName').AsAnsiString := GetShopName;
          Params.ParamByName('pPhoneNum').AsAnsiString := GetPhoneNum;
          with FrmTopMenu.Defs do begin
            Params.ParamByName('pStartBusinessDT').AsDateTime := StrToDateTime(GetStartBusinessDT, GetFS);
            if GetEndBusinessDT <> '' then begin
              Params.ParamByName('pEndBusinessDT').AsDateTime := StrToDateTime(GetEndBusinessDT, GetFS);
            end else begin
              Params.ParamByName('pEndBusinessDT').AsDateTime := StrToDateTime('9999/12/31 23:59:59', GetFS);
            end;
          end;
          Params.ParamByName('pDisabled').AsBoolean  := GetDisabled;
          LNow                                       := Now;
          Params.ParamByName('pEntryDT').AsDateTime  := LNow;
          Params.ParamByName('pUpdateDT').AsDateTime := LNow;

          CloseTransactions;
          SetDatabaseNames;
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

procedure TFrmEntryShop.ProcInsert;
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
    DBEdtShopName.SetFocus;
  end;
end;

function TFrmEntryShop.GetShopName: String;
begin
  Result := FShopName;
end;

procedure TFrmEntryShop.SetShopName(ShopName: String);
begin
  FShopName := ShopName;
end;

function TFrmEntryShop.GetPhoneNum: String;
begin
  Result := FPhoneNum;
end;

procedure TFrmEntryShop.SetPhoneNum(PhoneNum: String);
begin
  FPhoneNum := PhoneNum;
end;

function TFrmEntryShop.GetStartBusinessDT: String;
begin
  Result := FStartBusinessDT;
end;

procedure TFrmEntryShop.SetStartBusinessDT(StartBusinessDT: String);
begin
  FStartBusinessDT := StartBusinessDT;
end;

function TFrmEntryShop.GetEndBusinessDT: String;
begin
  Result := FEndBusinessDT;
end;

procedure TFrmEntryShop.SetEndBusinessDT(EndBusinessDT: String);
begin
  FEndBusinessDT := EndBusinessDT;
end;

function TFrmEntryShop.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryShop.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryShop.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmEntryShop.ActCommitExecute(Sender: TObject);
begin
  BackupValues;
  ProcCommit;
end;

procedure TFrmEntryShop.ActInsertExecute(Sender: TObject);
begin
  ProcInsert;
end;

procedure TFrmEntryShop.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryShop.ADBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) And (Key = VK_E) then begin
    DBEdtShopName.SetFocus;
  end;
end;

procedure TFrmEntryShop.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
  AQu.Edit;
end;

procedure TFrmEntryShop.DBEdtShopIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with FrmTopMenu.Defs do begin
      GetShopID.SetShopID(DBEdtShopID.Text);
    end;
  end;
end;

procedure TFrmEntryShop.DBEdtShopNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetShopName(DBEdtShopName.Text);
  end;
end;

procedure TFrmEntryShop.DBEdtPhoneNumChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetPhoneNum(DBEdtPhoneNum.Text);
  end;
end;

procedure TFrmEntryShop.DBDTPStartBusinessDTChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetStartBusinessDT(FormatDateTime(
      'yyyy/mm/dd hh:mm:ss',
      DBDTPStartBusinessDT.Field.AsDateTime,
      FrmTopMenu.Defs.GetFS));
  end;
end;

procedure TFrmEntryShop.DBDTPEndBusinessDTChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    if Not DBDTPEndBusinessDT.Field.IsNull then begin;
      SetEndBusinessDT(FormatDateTime(
        'yyyy/mm/dd hh:mm:ss',
        DBDTPEndBusinessDT.Field.AsDateTime,
        FrmTopMenu.Defs.GetFS));
    end else begin
      SetEndBusinessDT('9999/12/31 23:59:59');
    end;
  end;
end;

procedure TFrmEntryShop.DBCBDisabledChange(Sender: TObject);
begin
  if Not FDoCommit then begin;
    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

procedure TFrmEntryShop.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseTransactions;

  with FrmTopMenu.Defs do begin
    // Restore value of previous screen
    //SetShopID(FShopID);

    if GetEntryShop = 0 then begin
      FrmManageDetails    := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible  := True;
    end else if GetEntryShop = 1 then begin
      FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
      FrmAddDetailsHeader.Visible  := True;
    end else if GetEntryShop = 2 then begin
      FrmEditDetailsHeader := TFrmEditDetailsHeader.Create(Application);
      FrmEditDetailsHeader.Visible  := True;
    end;
  end;

  CloseAction  := caFree;
  FrmEntryShop := nil;
end;

//procedure TFrmEntryShop.FormCreate(Sender: TObject);
//begin
//  with FrmTopMenu.Defs do begin
//    FShopID := GetShopID;
//  end;
//end;

procedure TFrmEntryShop.FormShow(Sender: TObject);
begin
  SetDatabaseNames;

  FReOpenDS := False;
  FDoCommit := False;

  FrmEntryShop.Color := RGB(112, 168, 175);
  PnlInsert.Color    := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlCommit.Color    := RGB( 72, 122, 129);
  PnlGoBack.Color    := RGB( 72, 122, 129);

  try
    try
      with AQu do begin
        with FrmTopMenu.Defs do begin
          OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20080001);
          ADBGrid.DataSource := ADS;
          if RecordCount = 0 then begin
            ProcInsert;
          end else begin
            FInsert := False;
          end;
          ADBGrid.AutoAdjustColumns;
          DBEdtShopName.SetFocus;
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

procedure TFrmEntryShop.TimerTimer(Sender: TObject);
begin
  try
    try
      if FReOpenDS then
      begin
        FrmTopMenu.Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20080001);
        ADBGrid.DataSource := ADS;

        FReOpenDS          := False;
        Timer.Enabled      := False;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

end.

