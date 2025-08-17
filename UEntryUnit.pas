unit UEntryUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, LCLType,
  ActnList, UDBAccess;

type

  { TFrmEntryUnit }

  TFrmEntryUnit = class(TForm)
    ACn          : TSQLite3Connection;
    ADS          : TDataSource;
    ATr          : TSQLTransaction;
    AQu          : TSQLQuery;
    ACnNextID    : TSQLite3Connection;
    ADSNextID    : TDataSource;
    ATrNextID    : TSQLTransaction;
    AQuNextID    : TSQLQuery;
    ActionList   : TActionList;
    ActInsert    : TAction;
    ActCancel    : TAction;
    ActSave      : TAction;
    ActGoBack    : TAction;
    ADBGrid      : TDBGrid;
    ADBNav       : TDBNavigator;
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
    BtnInsert    : TPanel;
    BtnCancel    : TPanel;
    BtnSave      : TPanel;
    BtnGoBack    : TPanel;
    PnlCancel    : TPanel;
    PnlSave      : TPanel;
    PnlGoBack    : TPanel;
    PnlInsert    : TPanel;
    Shape1       : TShape;
    Shape2       : TShape;
    Shape3       : TShape;
    Timer        : TTimer;
    TimerKeyPreview: TTimer;
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBEdtUnitEnter(Sender: TObject);
    procedure DBEdtUnitExit(Sender: TObject);
    procedure DBEdtUnitIDEnter(Sender: TObject);
    procedure DBEdtUnitIDExit(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure InsertMouseOver(NewColor: TColor);
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure SaveMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerKeyPreviewTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FReOpenDS   : Boolean;
    FInsert     : Boolean;
    FIsDisabled : Boolean;
    FDoCommit   : Boolean;
    FUnitID     : Variant;
    FUnit       : String;
    FDisabled   : Boolean;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    procedure BackupValues;
    function GetUnitID: Variant;
    procedure SetUnitID(UnitID: Variant);
    function GetUnit: String;
    procedure SetUnit(ArgUnit: String);
    function GetDisabled: Boolean;
    procedure SetDisabled(Disabled: Boolean);
    property UnitID: Variant read GetUnitID write SetUnitID;
    property ArgUnit: String read GetUnit write SetUnit;
    property Disabled: Boolean read GetDisabled write SetDisabled;
  public

  end;

var
  FrmEntryUnit: TFrmEntryUnit;

implementation
uses
  UTopMenu, UManageDetails, UAddDetail, UEditDetail;

{$R *.lfm}

{ TFrmEntryUnit }

procedure TFrmEntryUnit.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn      );
    SetDatabaseName(ACnNextID);
  end;
end;

procedure TFrmEntryUnit.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);
  end;
end;

procedure TFrmEntryUnit.BackupValues;
begin
  with FrmTopMenu.Defs do begin
    if DBEdtUnitID.Text <> '' then begin;
      SetUnitID(DBEdtUnitID.Text);
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
end;

procedure TFrmEntryUnit.ProcInsert(Sender: TObject);
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

procedure TFrmEntryUnit.DBEdtUnitIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmEntryUnit.DBEdtUnitEnter(Sender: TObject);
begin
  Shape2.Visible := True;
end;

procedure TFrmEntryUnit.DBCBDisabledEnter(Sender: TObject);
begin
  Shape3.Visible := True;
end;

procedure TFrmEntryUnit.DBCBDisabledExit(Sender: TObject);
begin
  Shape3.Visible := False;
end;

procedure TFrmEntryUnit.DBEdtUnitExit(Sender: TObject);
begin
  Shape2.Visible := False;
end;

procedure TFrmEntryUnit.DBEdtUnitIDExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmEntryUnit.ProcCancel(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if FInsert then begin
      FInsert := False;
    end;
    ATr.Rollback;

    CloseTransactions;
    SetDatabaseNames;

    OpenSelectQueryByUnit(ACn, ADS, ATr, AQu, SQL_20150001);
    DBEdtUnit.SetFocus;
  end;
end;

procedure TFrmEntryUnit.ProcSave(Sender: TObject);
var
  LNextUnitID : Integer;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with ATr do begin
          if Not Active then begin
            StartTransaction;
          end;
        end;

        with AQu do begin
          SQL.Text := SQL_20150003;
          if (VarIsNull(GetUnitID)) Or (VarToStr(GetUnitID) = '') then begin
            CloseConn(ACnNextID, ATrNextID);
            SetDatabaseNames;

            OpenSelectQueryByUnit(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20150002);
            LNextUnitID                            := AQuNextID.FieldByName('NEXT_ID').AsInteger;

            CloseConn(ACnNextID, ATrNextID);

            with Params do begin
              ParamByName('pUnitID').AsInteger := LNextUnitID;
            end;
          end else begin
            with Params do begin
              ParamByName('pUnitID').AsInteger := StrToInt(VarToStr(GetUnitID));
            end;
          end;
          with Params do begin
            ParamByName('pUnit').AsAnsiString   := GetUnit;
            ParamByName('pOrderID').AsInteger   := ParamByName('pUnitID').AsInteger;
            ParamByName('pDisabled').AsBoolean  := GetDisabled;
            ParamByName('pEntryDT').AsDateTime  := Now;
            ParamByName('pUpdateDT').AsDateTime := Now;
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
end;

procedure TFrmEntryUnit.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryUnit.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
end;

procedure TFrmEntryUnit.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryUnit.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmEntryUnit.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryUnit.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);
end;

procedure TFrmEntryUnit.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryUnit.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmEntryUnit.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
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
  Result := FUnit;
end;

procedure TFrmEntryUnit.SetUnit(ArgUnit: String);
begin
  FUnit := ArgUnit;
end;

function TFrmEntryUnit.GetDisabled: Boolean;
begin
  Result := FDisabled;
end;

procedure TFrmEntryUnit.SetDisabled(Disabled: Boolean);
begin
  FDisabled := Disabled;
end;

procedure TFrmEntryUnit.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryUnit.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEntryUnit.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryUnit.ActGoBackExecute(Sender: TObject);
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
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  FReOpenDS   := False;
  FIsDisabled := False;
  FDoCommit   := False;
end;

procedure TFrmEntryUnit.FormShow(Sender: TObject);
begin
  //FrmEntryUnit.KeyPreview := True;

  Color := RGB(112, 168, 175);

  PnlInsert.Color    := RGB( 72, 122, 129);
  PnlCancel.Color    := RGB( 72, 122, 129);
  PnlSave.Color    := RGB( 72, 122, 129);
  PnlGoBack.Color    := RGB( 72, 122, 129);

  try
    with FrmTopMenu.Defs do begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQueryByUnit(ACn, ADS, ATr, AQu, SQL_20150001);
      ADBGrid.DataSource := ADS;
      if AQu.RecordCount = 0 then begin
        ProcInsert(Sender);
      end else begin
        FInsert := False;
      end;
      ADBGrid.AutoAdjustColumns;
      DBEdtUnit.SetFocus;
    end;
  finally
  end;
end;

procedure TFrmEntryUnit.TimerKeyPreviewTimer(Sender: TObject);
begin
  ShowMessage('OnTimer');
  FrmEntryUnit.KeyPreview := True;
  TimerKeyPreview.Enabled := False;
end;


procedure TFrmEntryUnit.TimerTimer(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if FReOpenDS then
    begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQueryByUnit(ACn, ADS, ATr, AQu, SQL_20150001);
      ADBGrid.DataSource := ADS;

      FReOpenDS          := False;
      Timer.Enabled      := False;
    end;
  end;
end;

procedure TFrmEntryUnit.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnInsert' then begin
      ActInsert.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

end.

