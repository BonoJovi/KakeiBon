unit UUpdator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, FileUtil;

type

  { TFrmUpdatorForWin }

  TFrmUpdatorForWin = class(TForm)
    ADS: TDataSource;
    BtnUpdate: TPanel;
    AQu: TSQLQuery;
    pnlUpdate: TPanel;
    procedure BtnUpdateClick(Sender: TObject);
    procedure BtnUpdateMouseEnter(Sender: TObject);
    procedure BtnUpdateMouseLeave(Sender: TObject);
    function ExecuteSQL(SS: String): Boolean;
  private

  public

  end;

var
  FrmUpdatorForWin: TFrmUpdatorForWin;

implementation
uses
  UConsts, UCommonDB, UNewTables;

{$R *.lfm}

{ TFrmUpdatorForWin }

function TFrmUpdatorForWin.ExecuteSQL(SS: String): Boolean;
begin
  try
    with CommonDB do begin
      with AQu do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        SQL.Text := SS;
        ExecSQL;
      end;
    end;
    Result := True;
  except
    on E: Exception do begin
      Result := False;
    end;
  end;
end;

procedure TFrmUpdatorForWin.BtnUpdateClick(Sender: TObject);
begin
  MessageDlg(MSG_JP_000041, mtInformation, [mbOK], 0);
  with CommonDB do begin
    InitializeCommonDB;

    // Backup DB file
    if CopyFile(FSQLite3DatabaseName, FSQLite3DatabaseName + '.backup') then begin
      with CommonDB do begin
        try
          with ATr do begin
            if Not Active then begin
              StartTransaction;
            end;
          end;

          try
            with AQu do begin
              SQLConnection  := ACn;
              SQLTransaction := ATr;

              SQL.Text := SQL_10000000_SEL;
              Open;
            end;

            if AQu.RecordCount = 1 then begin;
              if Not ExecuteSQL(SQL_10000000_DRP) then begin Raise Exception.Create('SQL_10000000_DRP') end;
            end;
            ATr.Commit;
          except
            on E: Exception do begin
              ATr.Rollback;
              Raise Exception.Create('SQL_10000000_SEL');
            end;
          end;

          ATr.StartTransaction;
          if Not ExecuteSQL(SQL_10000001_NEW) then Raise Exception.Create('SQL_10000001_NEW');
          if Not ExecuteSQL(SQL_10000001_CPY) then Raise Exception.Create('SQL_10000001_CPY');
          if Not ExecuteSQL(SQL_10000001_DRP) then Raise Exception.Create('SQL_10000001_DRP');
          if Not ExecuteSQL(SQL_10000001_REN) then Raise Exception.Create('SQL_10000001_REN');
          if Not ExecuteSQL(SQL_10000001_IDX) then Raise Exception.Create('SQL_10000001_IDX');

          if Not ExecuteSQL(SQL_10000010_NEW) then Raise Exception.Create('SQL_10000010_NEW');
          if Not ExecuteSQL(SQL_10000010_CPY) then Raise Exception.Create('SQL_10000010_CPY');
          if Not ExecuteSQL(SQL_10000010_DRP) then Raise Exception.Create('SQL_10000010_DRP');
          if Not ExecuteSQL(SQL_10000010_REN) then Raise Exception.Create('SQL_10000010_REN');
          if Not ExecuteSQL(SQL_10000010_IDX) then Raise Exception.Create('SQL_10000010_IDX');

          if Not ExecuteSQL(SQL_10000016_NEW) then Raise Exception.Create('SQL_10000016_NEW');
          if Not ExecuteSQL(SQL_10000016_CPY) then Raise Exception.Create('SQL_10000016_CPY');
          if Not ExecuteSQL(SQL_10000016_DRP) then Raise Exception.Create('SQL_10000016_DRP');
          if Not ExecuteSQL(SQL_10000016_REN) then Raise Exception.Create('SQL_10000016_REN');
          if Not ExecuteSQL(SQL_10000016_IDX) then Raise Exception.Create('SQL_10000016_IDX');

          if Not ExecuteSQL(SQL_10000018_NEW) then Raise Exception.Create('SQL_10000018_NEW');
          if Not ExecuteSQL(SQL_10000018_CPY) then Raise Exception.Create('SQL_10000018_CPY');
          if Not ExecuteSQL(SQL_10000018_DRP) then Raise Exception.Create('SQL_10000018_DRP');
          if Not ExecuteSQL(SQL_10000018_REN) then Raise Exception.Create('SQL_10000018_REN');
          if Not ExecuteSQL(SQL_10000018_IDX) then Raise Exception.Create('SQL_10000018_IDX');

          if Not ExecuteSQL(SQL_10000020_NEW) then Raise Exception.Create('SQL_10000020_NEW');
          if Not ExecuteSQL(SQL_10000020_CPY) then Raise Exception.Create('SQL_10000020_CPY');
          if Not ExecuteSQL(SQL_10000020_DRP) then Raise Exception.Create('SQL_10000020_DRP');
          if Not ExecuteSQL(SQL_10000020_REN) then Raise Exception.Create('SQL_10000020_REN');
          if Not ExecuteSQL(SQL_10000020_IDX) then Raise Exception.Create('SQL_10000020_IDX');

          if Not ExecuteSQL(SQL_10000022_NEW) then Raise Exception.Create('SQL_10000022_NEW');
          if Not ExecuteSQL(SQL_10000022_CPY) then Raise Exception.Create('SQL_10000022_CPY');
          if Not ExecuteSQL(SQL_10000022_DRP) then Raise Exception.Create('SQL_10000022_DRP');
          if Not ExecuteSQL(SQL_10000022_REN) then Raise Exception.Create('SQL_10000022_REN');
          if Not ExecuteSQL(SQL_10000022_IDX) then Raise Exception.Create('SQL_10000022_IDX');

          if Not ExecuteSQL(SQL_10000024_NEW) then Raise Exception.Create('SQL_10000024_NEW');
          if Not ExecuteSQL(SQL_10000024_CPY) then Raise Exception.Create('SQL_10000024_CPY');
          if Not ExecuteSQL(SQL_10000024_DRP) then Raise Exception.Create('SQL_10000024_DRP');
          if Not ExecuteSQL(SQL_10000024_REN) then Raise Exception.Create('SQL_10000024_REN');
          if Not ExecuteSQL(SQL_10000024_IDX) then Raise Exception.Create('SQL_10000024_IDX');

          if Not ExecuteSQL(SQL_10000026_NEW) then Raise Exception.Create('SQL_10000026_NEW');
          if Not ExecuteSQL(SQL_10000026_CPY) then Raise Exception.Create('SQL_10000026_CPY');
          if Not ExecuteSQL(SQL_10000026_DRP) then Raise Exception.Create('SQL_10000026_DRP');
          if Not ExecuteSQL(SQL_10000026_REN) then Raise Exception.Create('SQL_10000026_REN');
          if Not ExecuteSQL(SQL_10000026_IDX) then Raise Exception.Create('SQL_10000026_IDX');

          ATr.Commit;
          MessageDlg(MSG_JP_000042, mtInformation, [mbOK], 0);

          with CommonDB do begin
            // Delete DB backup file
            DeleteFile(FSQLite3DatabaseName + '.backup');
          end;
        Except
          on E: Exception do begin
            ATr.Rollback;
            MessageDlg(MSG_JP_000043, mtError, [mbOK], 0);
            with CommonDB do begin
              // Delete DB file
              DeleteFile(FSQLite3DatabaseName);
              // Rename DB backup file to DB file
              RenameFile(FSQLite3DatabaseName + '.backup', FSQLite3DatabaseName);
            end;
          end;
        end;
      end;
    end else begin
      MessageDlg(MSG_JP_000044, mtError, [mbOk], 0);
    end;
  end;
end;

procedure TFrmUpdatorForWin.BtnUpdateMouseEnter(Sender: TObject);
begin
  BtnUpdate.Color := clSkyBlue;
end;

procedure TFrmUpdatorForWin.BtnUpdateMouseLeave(Sender: TObject);
begin
  BtnUpdate.Color:= clBtnFace;
end;

end.

