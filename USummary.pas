unit USummary;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, BufDataset, Forms, Controls,
  Graphics, Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, LCLType, ActnList;

type

  { TFrmSummary }

  TFrmSummary = class(TForm)
    ADS        : TDataSource;
    AQu        : TSQLQuery;
    ActionList : TActionList;
    ActGoBack    : TAction;
    DBGrid1    : TDBGrid;
    BtnGoBack: TPanel;
    PnlGoBack: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
      CloseQuery(AQu);
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
  FrmSummary.KeyPreview := True;
end;

procedure TFrmSummary.FormActivate(Sender: TObject);
var
  i            : Integer;
  LWidth       : Integer = 0;
  LLeftPos     : Integer = 0;
begin
  with CommonDB do begin
    with Defs do begin
      with AQu do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

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

  LLeftPos := Trunc((Screen.Width - FrmSummary.Width) / 2);
  FrmSummary.Left := LLeftPos;
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

