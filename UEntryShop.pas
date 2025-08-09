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
    ACn                  : TSQLite3Connection;
    ADS                  : TDataSource;
    ATr                  : TSQLTransaction;
    AQu                  : TSQLQuery;
    ACnNextID            : TSQLite3Connection;
    ADSNextID            : TDataSource;
    ATrNextID            : TSQLTransaction;
    AQuNextID            : TSQLQuery;
    ActionList           : TActionList;
    ActInsert            : TAction;
    ActCancel            : TAction;
    ActSave              : TAction;
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
    Timer                : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FDoCommit        : Boolean;
    FReOpenDS        : Boolean;
    FInsert          : Boolean;
    FShopID          : Variant;
    FShopName        : String;
    FPhoneNum        : String;
    FStartBusinessDT : String;
    FEndBusinessDT   : String;
    FDisabled        : Boolean;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
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
    property ShopName: String read GetShopName write SetShopName;
    property PhoneNum: String read GetPhoneNum write SetPhoneNum;
    property StartBusinessDT: String read GetStartBusinessDT write SetStartBusinessDT;
    property EndBusinessDT: String read GetEndBusinessDT write SetEndBusinessDT;
    property Disabled: Boolean read GetDisabled write SetDisabled;
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

procedure TFrmEntryShop.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn      );
    SetDatabaseName(ACnNextID);
  end;
end;

procedure TFrmEntryShop.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);
  end;
end;

procedure TFrmEntryShop.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    with DBEdtShopID do begin
      if Text <> '' then begin;
        SetShopID(Text);
      end else begin
        SetShopID(Null);
      end;
    end;

    SetShopName(DBEdtShopName.Text);

    SetPhoneNum(DBEdtPhoneNum.Text);

    SetStartBusinessDT(FormatDateTime(
      'yyyy/mm/dd hh:mm:ss',
      DBDTPStartBusinessDT.Field.AsDateTime, GetFS));

    if Not DBDTPEndBusinessDT.Field.IsNull then begin;
      SetEndBusinessDT(FormatDateTime(
        'yyyy/mm/dd hh:mm:ss',
        DBDTPEndBusinessDT.Field.AsDateTime, GetFS));
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
  with FrmTopMenu.Defs do begin
    if FInsert then begin
      FInsert := False;
    end;
    ATr.Rollback;

    CloseTransactions;
    SetDatabaseNames;

    OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20080001);
    DBEdtShopName.SetFocus;
  end;
end;

procedure TFrmEntryShop.ProcCommit;
var
  LNextShopID : Integer;
  LNow        : TDateTime;
begin
  FDoCommit := True;
  try
    try
      with FrmTopMenu.Defs do begin
        with AQu do begin
          SQL.Text := SQL_20080003;
          with Params do begin
            ParamByName('pUserID').AsInteger   := GetUID;
          end;

          if (VarIsNull(GetShopID)) Or (VarToStr(GetShopID) = '') then begin
            CloseTransactions;
            SetDatabaseNames;

            OpenSelectQuery(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20080002);
            LNextShopID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

            CloseConn(ACnNextID, ATrNextID);

            with Params do begin
              ParamByName('pShopID').AsInteger := LNextShopID;
            end;
          end else begin
            with Params do begin
              ParamByName('pShopID').AsInteger := StrToInt(VarToStr(GetShopID));
            end;
          end;
          with Params do begin
            ParamByName('pShopName').AsAnsiString := GetShopName;
            ParamByName('pPhoneNum').AsAnsiString := GetPhoneNum;
            ParamByName('pStartBusinessDT').AsDateTime := StrToDateTime(GetStartBusinessDT, GetFS);
            if GetEndBusinessDT <> '' then begin
              ParamByName('pEndBusinessDT').AsDateTime := StrToDateTime(GetEndBusinessDT, GetFS);
            end else begin
              ParamByName('pEndBusinessDT').AsDateTime := StrToDateTime('9999/12/31 23:59:59', GetFS);
            end;
            ParamByName('pDisabled').AsBoolean  := GetDisabled;
            LNow                                       := Now;
            ParamByName('pEntryDT').AsDateTime  := LNow;
            ParamByName('pUpdateDT').AsDateTime := LNow;
          end;

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

procedure TFrmEntryShop.ActSaveExecute(Sender: TObject);
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
      SetShopID(DBEdtShopID.Text);
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
  with FrmTopMenu.Defs do begin
    if Not FDoCommit then begin
      SetStartBusinessDT(FormatDateTime(
        'yyyy/mm/dd hh:mm:ss',
        DBDTPStartBusinessDT.Field.AsDateTime, GetFS));
    end;
  end;
end;

procedure TFrmEntryShop.DBDTPEndBusinessDTChange(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if Not FDoCommit then begin
      if Not DBDTPEndBusinessDT.Field.IsNull then begin;
        SetEndBusinessDT(FormatDateTime(
          'yyyy/mm/dd hh:mm:ss',
          DBDTPEndBusinessDT.Field.AsDateTime, GetFS));
      end else begin
        SetEndBusinessDT('9999/12/31 23:59:59');
      end;
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
    SetShopID(FShopID);

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

procedure TFrmEntryShop.FormCreate(Sender: TObject);
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

procedure TFrmEntryShop.FormShow(Sender: TObject);
begin
  FrmEntryShop.Color := RGB(112, 168, 175);
  PnlInsert.Color    := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlCommit.Color    := RGB( 72, 122, 129);
  PnlGoBack.Color    := RGB( 72, 122, 129);

  with FrmTopMenu.Defs do begin
    FShopID := GetShopID;
  end;

  with AQu do begin
    with FrmTopMenu.Defs do begin
      CloseTransactions;
      SetDatabaseNames;

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
end;

procedure TFrmEntryShop.TimerTimer(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if FReOpenDS then
    begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20080001);
      ADBGrid.DataSource := ADS;

      FReOpenDS          := False;
      Timer.Enabled      := False;
    end;
  end;
end;

end.

