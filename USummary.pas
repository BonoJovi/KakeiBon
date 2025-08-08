unit USummary;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, BufDataset, Forms, Controls,
  Graphics, Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, ActnList;

type

  { TFrmSummary }

  TFrmSummary = class(TForm)
    ActQuit: TAction;
    ActionList1: TActionList;
    ADS: TDataSource;
    BtnGoBack: TButton;
    DBGrid1: TDBGrid;
    ACn: TSQLite3Connection;
    ATr: TSQLTransaction;
    AQu: TSQLQuery;
    PnlGoBack: TPanel;
    procedure ActQuitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure SetDatabaseNames;
    procedure CloseTransactions;
  public

  end;

var
  FrmSummary: TFrmSummary;

implementation
uses
  UConsts, UDBAccess, UDefs, UTopMenu;

{$R *.lfm}

{ TFrmSummary }

procedure TFrmSummary.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn       );
  end;
end;

procedure TFrmSummary.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;
end;

procedure TFrmSummary.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;
end;

procedure TFrmSummary.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  with FrmTopMenu do begin
    CloseTransactions;

    Visible     := True;

    CloseAction := caFree;
    FrmSummary  := nil;
  end;
end;

procedure TFrmSummary.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmSummary.FormShow(Sender: TObject);
var
  i            : Integer;
  LWidth       : Integer = 0;
begin
  CloseTransactions;
  SetDatabaseNames;

  with FrmTopMenu.Defs do begin
    with AQu do begin
      SQL.Text := SQL_20160002;
      with Params do begin
        ParamByName('pUserID').AsInteger := GetUID;
      end;
      Open;

      DBGrid1.DataSource := ADS;
      DBGrid1.AutoAdjustColumns;
      for i := 0 to DBGrid1.Columns.VisibleCount - 1 do begin
        LWidth           := LWidth + DBGrid1.Columns.Items[i].Width + 6;
      end;
      FrmSummary.Width   := LWidth + 16 + 16;
    end;
  end;
end;

end.

