unit UEntryUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, ActnList,
  UDBAccess;

type

  { TFrmEntryUnit }

  TFrmEntryUnit = class(TForm)
    ActCancel    : TAction;
    ActCommit    : TAction;
    ActInsert    : TAction;
    ActionList   : TActionList;
    ActQuit      : TAction;
    ADBGrid      : TDBGrid;
    ADBNav       : TDBNavigator;
    ADS          : TDataSource;
    ADSNextID    : TDataSource;
    AQu          : TSQLQuery;
    AQuNextID    : TSQLQuery;
    ATr          : TSQLTransaction;
    ATrNextID    : TSQLTransaction;
    BtnCancel    : TButton;
    BtnCommit    : TButton;
    BtnGoBack    : TButton;
    BtnInsert    : TButton;
    DBCBDisabled : TDBCheckBox;
    DBEdtUnitID  : TDBEdit;
    DBEdtUnit    : TDBEdit;
    LblDisabled1 : TLabel;
    LblDisabled2 : TLabel;
    LblDisabled3 : TLabel;
    LblUnitID1   : TLabel;
    LblUnitID2   : TLabel;
    LblUnit1     : TLabel;
    LblUnit2     : TLabel;
    PnlCancel    : TPanel;
    PnlCommit    : TPanel;
    PnlGoBack    : TPanel;
    PnlInsert    : TPanel;
    ACn: TSQLite3Connection;
    ACnNextID: TSQLite3Connection;
    Timer        : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FReOpenDS   : Boolean;
    FInsert     : Boolean;
    FIsDisabled : Boolean;
    FDoCommit   : Boolean;
    procedure CloseTransactions;
    procedure SetDatabaseNames;
    procedure BackupValues;
    procedure ProcInsert;
    procedure ProcCancel;
    procedure ProcCommit;
    function GetUnitID: Variant;
    procedure SetUnitID(UnitID: Variant);
    function GetUnit: String;
    procedure SetUnit(ArgUnit: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    property FUnitID: Variant read GetUnitID write SetUnitID;
    property FArgUnit: String read GetUnit write SetUnit;
    property FDisabled: Boolean read GetDisabled write SetDisabled;
  public

  end;

var
  FrmEntryUnit: TFrmEntryUnit;

implementation
uses
  UConsts, UTopMenu, UManageDetails, UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmEntryUnit }

procedure TFrmEntryUnit.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);
  end;
end;

procedure TFrmEntryUnit.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    ACn.DatabaseName       := GetHomeDir + DB_NAME;
    ACnNextID.DatabaseName := GetHomeDir + DB_NAME;
  end;
end;

procedure TFrmEntryUnit.BackupValues;
begin
  if DBEdtUnitID.Text <> '' then begin;
    GetUnitID.SetUnitID(DBEdtUnitID.Text);
  end else begin
    SetUnitID(Null);
  end;

  SetUnit(DBEdtUnit.Text);

  if DBCBDisabled.State = cbChecked then begin
    SetDisabled(True);
  end else begin
    SetDisabled(False);
  end;
end;

procedure TFrmEntryUnit.ProcCancel;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        if FInsert then begin
          FInsert := False;
        end;
        ATr.Rollback;
        OpenSelectQueryByUnit(ACn, ADS, ATr, AQu, SQL_20150001);
        DBEdtUnit.SetFocus;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmEntryUnit.ProcCommit;
var
  LNextUnitID : Integer;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with AQu do begin
          SQL.Text := SQL_20150003;
          if (VarIsNull(GetUnitID))
              Or (VarToStr(GetUnitID) = '') then begin
            OpenSelectQueryByUnit(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20150002);
            LNextUnitID                            := AQuNextID.FieldByName('NEXT_ID').AsInteger;
            CloseConn(ACnNextID, ATrNextID);
            SetDatabaseNames;
            Params.ParamByName('pUnitID').AsInteger := LNextUnitID;
          end else begin
            Params.ParamByName('pUnitID').AsInteger := StrToInt(VarToStr(GetUnitID));
          end;
          Params.ParamByName('pUnit').AsAnsiString   := GetUnit;
          Params.ParamByName('pOrderID').AsInteger   := Params.ParamByName('pUnitID').AsInteger;
          Params.ParamByName('pDisabled').AsBoolean  := GetDisabled;
          Params.ParamByName('pEntryDT').AsDateTime  := Now;
          Params.ParamByName('pUpdateDT').AsDateTime := Now;

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
end;

procedure TFrmEntryUnit.ProcInsert;
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
    DBEdtUnit.SetFocus;
  end;
end;

function TFrmEntryUnit.GetUnitID: Variant;
begin
  Result := FUnitID;
end;

procedure TFrmEntryUnit.SetUnitID(UnitID: Variant);
begin
  FUnitID := UnitID;
end;

function TFrmEntryUnit.GetUnit: String;
begin
  Result := FArgUnit;
end;

procedure TFrmEntryUnit.SetUnit(ArgUnit: String);
begin
  FArgUnit := ArgUnit;
end;

function TFrmEntryUnit.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryUnit.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryUnit.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmEntryUnit.ActCommitExecute(Sender: TObject);
begin
  BackupValues;
  ProcCommit;
end;

procedure TFrmEntryUnit.ActInsertExecute(Sender: TObject);
begin
  ProcInsert;
end;

procedure TFrmEntryUnit.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryUnit.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
  AQu.Edit;
end;

procedure TFrmEntryUnit.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseTransactions;

  with FrmTopMenu.Defs do begin
    if GetEntryUnit = 0 then begin
      FrmManageDetails         := TFrmManageDetails.Create(Application);
      FrmManageDetails.Visible := True;
    end else if GetEntryUnit = 1 then begin
      FrmAddDetail             := TFrmAddDetail.Create(Application);
      FrmAddDetail.Visible     := True;
    end else if GetEntryUnit = 2 then begin
      FrmEditDetail            := TFrmEditDetail.Create(Application);
      FrmEditDetail.Visible    := True;
    end;
  end;

  CloseAction                  := caFree;
  FrmEntryUnit                 := nil;
end;

procedure TFrmEntryUnit.FormCreate(Sender: TObject);
begin
  Color := RGB(112, 168, 175);

  PnlInsert.Color    := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlCommit.Color    := RGB( 72, 122, 129);
  PnlGoBack.Color    := RGB( 72, 122, 129);
end;

procedure TFrmEntryUnit.FormShow(Sender: TObject);
begin
  SetDatabaseNames;

  FReOpenDS   := False;
  FIsDisabled := False;
  FDoCommit   := False;

  try
    try
      with FrmTopMenu.Defs do begin
        OpenSelectQueryByUnit(ACn, ADS, ATr, AQu, SQL_20150001);
        ADBGrid.DataSource := ADS;
        if AQu.RecordCount = 0 then begin
          ProcInsert;
        end else begin
          FInsert := False;
        end;
        ADBGrid.AutoAdjustColumns;
        DBEdtUnit.SetFocus;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmEntryUnit.TimerTimer(Sender: TObject);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        if FReOpenDS then
        begin
          OpenSelectQueryByUnit(ACn, ADS, ATr, AQu, SQL_20150001);
          ADBGrid.DataSource := ADS;

          FReOpenDS          := False;
          Timer.Enabled      := False;
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

end.

