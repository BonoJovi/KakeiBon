unit UEntryMaker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, LCLType,
  ActnList, UDBAccess;

type

  { TFrmEntryMaker }

  TFrmEntryMaker = class(TForm)
    ACn            : TSQLite3Connection;
    ActCancel1: TAction;
    ActCommit1: TAction;
    ActInsert1: TAction;
    ActQuit1: TAction;
    ADS            : TDataSource;
    ATr            : TSQLTransaction;
    AQu            : TSQLQuery;
    ACnNextID      : TSQLite3Connection;
    ADSNextID      : TDataSource;
    ATrNextID      : TSQLTransaction;
    AQuNextID      : TSQLQuery;
    ActionList     : TActionList;
    ActInsert      : TAction;
    ActCancel      : TAction;
    ActSave        : TAction;
    ActGoBack        : TAction;
    ADBGrid        : TDBGrid;
    ADBNav         : TDBNavigator;
    DBCBDisabled   : TDBCheckBox;
    DBEdtMakerID   : TDBEdit;
    DBEdtMakerName : TDBEdit;
    LblDisabled1   : TLabel;
    LblDisabled2   : TLabel;
    LblDisabled3   : TLabel;
    LblMakerID1    : TLabel;
    LblMakerID2    : TLabel;
    LblMakerName   : TLabel;
    BtnInsert: TPanel;
    BtnCancel: TPanel;
    BtnSave: TPanel;
    BtnGoBack: TPanel;
    PnlCancel      : TPanel;
    PnlSave      : TPanel;
    PnlGoBack      : TPanel;
    PnlInsert      : TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Timer          : TTimer;
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBEdtMakerIDEnter(Sender: TObject);
    procedure DBEdtMakerIDExit(Sender: TObject);
    procedure DBEdtMakerNameEnter(Sender: TObject);
    procedure DBEdtMakerNameExit(Sender: TObject);
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
    procedure ADBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure DBCBDisabledChange(Sender: TObject);
    procedure DBEdtMakerIDChange(Sender: TObject);
    procedure DBEdtMakerNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FIsDisabled : Boolean;
    FDoCommit   : Boolean;
    FReOpenDS   : Boolean;
    FInsert     : Boolean;
    FMakerID    : Variant;
    FMakerName  : String;
    FDisabled   : Boolean;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    procedure BackupValues;
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

procedure TFrmEntryMaker.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn      );
    SetDatabaseName(ACnNextID);
  end;
end;

procedure TFrmEntryMaker.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
    CloseConn(ACnNextID, ATrNextID);
  end;
end;

procedure TFrmEntryMaker.BackupValues;
begin
  with FrmTopMenu.Defs do begin
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
end;

procedure TFrmEntryMaker.ProcInsert(Sender: TObject);
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

procedure TFrmEntryMaker.DBEdtMakerIDEnter(Sender: TObject);
begin
  Shape1.Visible := True;
end;

procedure TFrmEntryMaker.DBCBDisabledEnter(Sender: TObject);
begin
  Shape3.Visible := True;
end;

procedure TFrmEntryMaker.DBCBDisabledExit(Sender: TObject);
begin
  Shape3.Visible := False;
end;

procedure TFrmEntryMaker.DBEdtMakerIDExit(Sender: TObject);
begin
  Shape1.Visible := False;
end;

procedure TFrmEntryMaker.DBEdtMakerNameEnter(Sender: TObject);
begin
  Shape2.Visible := True;
end;

procedure TFrmEntryMaker.DBEdtMakerNameExit(Sender: TObject);
begin
  Shape2.Visible := False;
end;

procedure TFrmEntryMaker.ProcCancel(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if FInsert then begin
      FInsert := False;
    end;
    ATr.Rollback;

    CloseTransactions;
    SetDatabaseNames;

    OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20130001);
    DBEdtMakerName.SetFocus;
  end;
end;

procedure TFrmEntryMaker.ProcSave(Sender: TObject);
var
  LNextMakerID : Integer;
begin
  FDoCommit := True;
  try
    try
      with FrmTopMenu.Defs do begin
        with ATr do begin
          if Not Active then begin
            StartTransaction;
          end;
        end;

        with AQu do begin
          SQL.Text := SQL_20130004;
          with Params do begin
            ParamByName('pUserID').AsInteger := GetUID;
            if (VarIsNull(GetMakerID)) Or (VarToStr(GetMakerID) = '') then begin
              CloseTransactions;
              SetDatabaseNames;

              OpenSelectQuery(ACnNextID, ADSNextID, ATrNextID, AQuNextID, SQL_20130003);
              LNextMakerID                             := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              CloseConn(ACnNextID, ATrNextID);

              ParamByName('pMakerID').AsInteger := LNextMakerID;
            end else begin
              ParamByName('pMakerID').AsInteger := StrToInt(VarToStr(GetMakerID));
            end;
            ParamByName('pMakerName').AsAnsiString := GetMakerName;
            ParamByName('pDisabled').AsBoolean     := GetDisabled;
            ParamByName('pEntryDT').AsDateTime     := Now;
            ParamByName('pUpdateDT').AsDateTime    := Now;
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

procedure TFrmEntryMaker.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnInsertEnter(Sender: TObject);
begin
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryMaker.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
end;

procedure TFrmEntryMaker.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnCancelEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryMaker.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);
end;

procedure TFrmEntryMaker.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnSaveEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmEntryMaker.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);
end;

procedure TFrmEntryMaker.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryMaker.BtnGoBackEnter(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmEntryMaker.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
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

procedure TFrmEntryMaker.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryMaker.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
end;

procedure TFrmEntryMaker.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryMaker.ActGoBackExecute(Sender: TObject);
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
  with FrmTopMenu.Defs do begin
    if Not FDoCommit then begin
      SetMakerName(DBEdtMakerName.Text);
    end;
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
      SetEntryMaker(999);
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

procedure TFrmEntryMaker.FormCreate(Sender: TObject);
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

procedure TFrmEntryMaker.FormShow(Sender: TObject);
begin
  FrmEntryMaker.KeyPreview := True;

  FrmEntryMaker.Color := RGB(112, 168, 175);
  PnlInsert.Color     := RGB( 72, 122, 129);
  PnlCancel.Color     := RGB( 72, 122, 129);
  PnlSave.Color     := RGB( 72, 122, 129);
  PnlGoBack.Color     := RGB( 72, 122, 129);

  try
    with FrmTopMenu.Defs do begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20130001);
      ADBGrid.DataSource := ADS;
      if AQu.RecordCount = 0 then begin
        ProcInsert(Sender);
      end else begin
        FInsert := False;
      end;
      ADBGrid.AutoAdjustColumns;
      DBEdtMakerName.SetFocus;
    end;
  finally
  end;
end;

procedure TFrmEntryMaker.TimerTimer(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    if FReOpenDS then
    begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20130001);
      ADBGrid.DataSource := ADS;

      FReOpenDS       := False;
      Timer.Enabled   := False;
    end;
  end;
end;

procedure TFrmEntryMaker.FormKeyUp(Sender: TObject; var Key: Word;
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

