unit USummary;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, BufDataset, Forms, Controls,
  Graphics, Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, LCLType, ActnList,
  ComCtrls;

type

  { TFrmSummary }

  TFrmSummary = class(TForm)
    ActionList1: TActionList;
    ADBExpGrid: TDBGrid;
    ADSExp        : TDataSource;
    ADSAccount: TDataSource;
    AQuExp        : TSQLQuery;
    ActionList : TActionList;
    ActGoBack  : TAction;
    AQuAccount: TSQLQuery;
    BtnGoBack  : TPanel;
    ADBAccountGrid: TDBGrid;
    PageControl: TPageControl;
    PnlGoBack  : TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
  private
  public

  end;

var
  FrmSummary: TFrmSummary;

implementation
uses
  UConsts, UDBAccess, UCommonDB, UDefs, UTopMenu;

{$R *.lfm}

{ TFrmSummary }

procedure TFrmSummary.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmSummary.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.COlor := NewColor;
end;

procedure TFrmSummary.BtnGoBackEnter(Sender: TObject);
begin
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmSummary.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmSummary.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    with Defs do begin
      CloseQuery(AQuExp);
    end;
  end;

  with FrmTopMenu do begin
    Visible     := True;

    CloseAction := caFree;
    FrmSummary  := nil;
  end;
end;

procedure TFrmSummary.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmSummary.FormShow(Sender: TObject);
begin
  Self.KeyPreview := True;

  TabSheet2.Show;
  TabSheet1.Show;
end;

procedure TFrmSummary.TabSheet1Show(Sender: TObject);
var
  i        : Integer;
  LWidth   : Integer = 0;
  LLeftPos : Integer = 0;
begin
  with CommonDB do begin
    with Defs do begin
      CloseQuery(AQuAccount);
      CloseQuery(AQuExp);
      with AQuAccount do begin
        OpenSelectQuery(ADSAccount, AQuAccount, SQL_20160002);
        ADBAccountGrid.DataSource := ADSAccount;
      end;
    end;
  end;
  ADBAccountGrid.AutoAdjustColumns;
  for i := 0 to ADBAccountGrid.Columns.VisibleCount - 1 do begin
    LWidth           := LWidth + ADBAccountGrid.Columns.Items[i].Width + 6;
  end;
  Self.Width   := LWidth + 16 + 16;
  PageControl.Width := LWidth;

  LLeftPos := Trunc((Screen.Width - Self.Width) / 2);
  Self.Left := LLeftPos;
end;

procedure TFrmSummary.TabSheet2Show(Sender: TObject);
var
  i        : Integer;
  LWidth   : Integer = 0;
  LLeftPos : Integer = 0;
begin
  with CommonDB do begin
    with Defs do begin
      with AQuExp do begin
        CloseQuery(AQuAccount);
        CloseQuery(AQuExp);
        OpenSelectQuery(ADSExp, AQuExp, SQL_20160004);
        ADBExpGrid.DataSource := ADSExp;
      end;
    end;
  end;
  ADBExpGrid.AutoAdjustColumns;
  for i := 0 to ADBExpGrid.Columns.VisibleCount - 1 do begin
    LWidth           := LWidth + ADBExpGrid.Columns.Items[i].Width + 6;
  end;
  Self.Width   := LWidth + 16 + 16;
  PageControl.Width := LWidth;

  LLeftPos := Trunc((Screen.Width - Self.Width) / 2);
  Self.Left := LLeftPos;
end;

procedure TFrmSummary.FormActivate(Sender: TObject);
var
  i        : Integer;
  LWidth   : Integer = 0;
  LLeftPos : Integer = 0;
begin
  with CommonDB do begin
    with Defs do begin
      with AQuAccount do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;
        OpenSelectQuery(ADSAccount, AQuAccount, SQL_20160002);
        ADBAccountGrid.DataSource := ADSAccount;
      end;
    end;
  end;
  ADBAccountGrid.AutoAdjustColumns;
  for i := 0 to ADBAccountGrid.Columns.VisibleCount - 1 do begin
    LWidth           := LWidth + ADBAccountGrid.Columns.Items[i].Width + 6;
  end;
  Self.Width   := LWidth + 16 + 16;
  PageControl.Width := LWidth;

  LLeftPos := Trunc((Screen.Width - Self.Width) / 2);
  Self.Left := LLeftPos;
end;

procedure TFrmSummary.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

end.

