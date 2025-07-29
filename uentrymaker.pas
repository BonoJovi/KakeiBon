unit UEntryMaker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LCLType, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, ActnList,
  UDBAccess;

type

  { TFrmEntryMaker }

  TFrmEntryMaker = class(TForm)
    ActCancel      : TAction;
    ActCancel1: TAction;
    ActCommit      : TAction;
    ActCommit1: TAction;
    ActInsert      : TAction;
    ActEntryMaker  : TAction;
    ActInsert1: TAction;
    ActionList     : TActionList;
    ActQuit        : TAction;
    ActQuit1: TAction;
    ADBGrid        : TDBGrid;
    ADBNav         : TDBNavigator;
    ADS            : TDataSource;
    ADSNextID      : TDataSource;
    AQu            : TSQLQuery;
    AQuNextID      : TSQLQuery;
    ATr            : TSQLTransaction;
    ATrNextID      : TSQLTransaction;
    BtnCancel: TButton;
    BtnCommit: TButton;
    BtnGoBack: TButton;
    BtnInsert: TButton;
    DBCBDisabled   : TDBCheckBox;
    DBEdtMakerID   : TDBEdit;
    DBEdtMakerName : TDBEdit;
    LblDisabled1   : TLabel;
    LblDisabled2   : TLabel;
    LblDisabled3   : TLabel;
    LblMakerID1    : TLabel;
    LblMakerID2    : TLabel;
    LblMakerName   : TLabel;
    PnlCancel      : TPanel;
    PnlCommit      : TPanel;
    PnlGoBack      : TPanel;
    PnlInsert      : TPanel;
    ACn: TSQLite3Connection;
    ACnNextID: TSQLite3Connection;
    Timer          : TTimer;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActCommitExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ADBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBEdtMakerIDChange(Sender: TObject);
    procedure DBEdtMakerNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FIsDisabled : Boolean;
    FDoCommit   : Boolean;
    FReOpenDS   : Boolean;
    FInsert     : Boolean;
    FMakerID    : Variant;
    FMakerName  : String;
    FDisabled   : Boolean;
    procedure CloseTransactions;
    procedure BackupValues;
    procedure ProcCancel;
    procedure ProcCommit;
    procedure ProcInsert;
    function GetMakerID: Variant;
    procedure SetMakerID(MakerID: Variant);
    function GetMakerName: String;
    procedure SetMakerName(MakerName: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    property MakerID: Variant read GetMakerID write SetMakerID;
    property MakerName: String read GetMakerName write SetMakerName;
    property Disabled: Boolean read GetDisabled write SetDisabled;
  public

  end;

var
  FrmEntryMaker: TFrmEntryMaker;

implementation
uses
  UTopMenu, UAddDetail, UEditDetail, UEntryBrandName;

{$R *.lfm}

{ TFrmEntryMaker }

procedure TFrmEntryMaker.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);
  end;
end;

procedure TFrmEntryMaker.BackupValues;
begin
  if DBEdtMakerID.Text <> '' then begin;
    SetMakerID(DBEdtMakerID.Text);
  end else begin
    SetMakerID(Null);
  end;

  SetMakerName(DBEdtMakerName.Text);

  if DBCBDisabled.State = cbChecked then begin
    SetDisabled(True);
  end else begin
    SetDisabled(False);
  end;
end;

procedure TFrmEntryMaker.ProcCancel;
begin
  if FInsert then begin
    FInsert := False;
  end;
  ATr.Rollback;
  FrmTopMenu.Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20130001);
  DBEdtMakerName.SetFocus;
end;

procedure TFrmEntryMaker.ProcCommit;
var
  LNextMakerID : Integer;
begin
  FDoCommit := True;
  try
    try
      with ATr do begin
        if Not Active then begin
          StartTransaction;
        end;
      end;

      with AQu do begin
        SQL.Text := SQL_20130004;
        Params.ParamByName('pUserID').AsInteger := FrmTopMenu.Defs.GetUID;
        if (VarIsNull(GetMakerID)) Or (GetMakerID = '') then begin
          FrmTopMenu.Defs.OpenSelectQuery(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20130003);
          LNextMakerID                             := AQuNextID.FieldByName('NEXT_ID').AsInteger;
          FrmTopMenu.Defs.CloseConn(ACnNextID, ATrNextID);
          Params.ParamByName('pMakerID').AsInteger := LNextMakerID;
        end else begin
          Params.ParamByName('pMakerID').AsInteger := GetMakerID;
        end;
        Params.ParamByName('pMakerName').AsAnsiString := GetMakerName;
        Params.ParamByName('pDisabled').AsBoolean     := GetDisabled;
        Params.ParamByName('pEntryDT').AsDateTime     := Now;
        Params.ParamByName('pUpdateDT').AsDateTime    := Now;

        CloseTransactions;
        ExecSQL;
        ATr.Commit;
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

procedure TFrmEntryMaker.ProcInsert;
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
    DBEdtMakerName.SetFocus;
  end;
end;

function TFrmEntryMaker.GetMakerID: Variant;
begin
  Result := FMakerID;
end;

procedure TFrmEntryMaker.SetMakerID(MakerID: Variant);
begin
  FMakerID := MakerID;
end;
function TFrmEntryMaker.GetMakerName: String;
begin
  Result := FMakerName;
end;

procedure TFrmEntryMaker.SetMakerName(MakerName: String);
begin
  FMakerName := MakerName;
end;

function TFrmEntryMaker.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryMaker.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryMaker.ActCancelExecute(Sender: TObject);
begin
  ProcCancel;
end;

procedure TFrmEntryMaker.ActCommitExecute(Sender: TObject);
begin
  BackupValues;
  ProcCommit;
end;

procedure TFrmEntryMaker.ActInsertExecute(Sender: TObject);
begin
  ProcInsert;
end;

procedure TFrmEntryMaker.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryMaker.ADBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) And (Key = VK_E) then begin
    DBEdtMakerName.SetFocus;
  end;
end;

procedure TFrmEntryMaker.ADBGridSelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
  AQu.Edit;
end;

procedure TFrmEntryMaker.DBEdtMakerIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    SetMakerID(DBEdtMakerID.Text);
  end;
end;

procedure TFrmEntryMaker.DBEdtMakerNameChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    FrmTopMenu.Defs.SetMakerName(DBEdtMakerName.Text);
  end;
end;

procedure TFrmEntryMaker.DBCBDisabledChange(Sender: TObject);
begin
  if Not FDoCommit then begin;
    if Not FDoCommit then begin
      if DBCBDisabled.State = cbChecked then begin
        SetDisabled(True);
      end else begin
        SetDisabled(False);
      end;
    end;
  end;
end;

procedure TFrmEntryMaker.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseTransactions;

  with FrmTopMenu.Defs do begin
    if GetEntryMaker = 0 then begin
      FrmEntryBrandName := TFrmEntryBrandName.Create(Application);
      FrmEntryBrandName.Visible := True;
    end else if GetEntryMaker = 1 then begin
      FrmAddDetail      := TFrmAddDetail.Create(Application);
      FrmAddDetail.Visible := True;
    end else if GetEntryMaker = 2 then begin
      FrmEditDetail   := TFrmEditDetail.Create(Application);
      FrmEditDetail.Visible := True;
    end;
  end;

  CloseAction               := caFree;
  FrmEntryMaker             := nil;
end;

procedure TFrmEntryMaker.FormShow(Sender: TObject);
begin
  FReOpenDS   := False;
  FIsDisabled := False;
  FDoCommit   := False;

  FrmEntryMaker.Color := RGB(112, 168, 175);
  PnlInsert.Color     := RGB( 72, 122, 129);
  PnlCancel.Color     := RGB( 72, 122, 129);
  PnlCommit.Color     := RGB( 72, 122, 129);
  PnlGoBack.Color     := RGB( 72, 122, 129);

  try
    FrmTopMenu.Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20130001);
    ADBGrid.DataSource := ADS;
    if AQu.RecordCount = 0 then begin
      ProcInsert;
    end else begin
      FInsert := False;
    end;
    ADBGrid.AutoAdjustColumns;
    DBEdtMakerName.SetFocus;
  finally
  end;
end;

procedure TFrmEntryMaker.TimerTimer(Sender: TObject);
begin
  if FReOpenDS then
  begin
    FrmTopMenu.Defs.OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20130001);
    ADBGrid.DataSource := ADS;

    FReOpenDS       := False;
    Timer.Enabled   := False;
  end;
end;

end.

