unit UCommonDB;

{$mode ObjFPC}{$H+}{$M+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls;

const
  cSQLite3DatabaseName = 'KakeiBonDB.sqlite3';

  {$IFDEF LINUX}
    DB_DIR         = '.kakeibon/';
  {$ELSE}
    {$IFDEF DARWIN}
      // ToDo: Implements for macOS
    {$ELSE}
      {$IFDEF WINDOWS}
        DB_DIR         = '.kakeibon\';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

type

  { TCommonDB }

  TCommonDB = class(TDataModule)
    procedure ACnAfterDisconnect(Sender: TObject);
    procedure InitializeCommonDB;
    procedure SetSQLite3DatabaseName;
    procedure SQLite3Connect;
    procedure SQLite3Disconnect;
    procedure CloseQuery(var Qu: TSQLQuery);
  private
    FOSHomeDir           : AnsiString;
    FDBPath              : AnsiString;
    FDBFullPath          : AnsiString;
  public
    FSQLite3DatabaseName : String;
  published
    ACn                  : TSQLite3Connection;
    ATr                  : TSQLTransaction;
    function GetOSHomeDir: AnsiString;
    function GetDBPath: AnsiString;
    procedure SetDBPath(aDBDir: AnsiString);
    procedure SetOSHomeDir(aOSHomeDir: AnsiString);
    function GetDBFullPath: AnsiString;
    procedure SetDBFullPath(aDBFullPath: AnsiString);

    property OSHomeDir : AnsiString read GetOSHomeDir write SetOSHomeDir;
    property DBDir : AnsiString read GetDBPath write SetDBPath;
    property DBFullPath : AnsiString read GetDBFullPath write SetDBFullPath;
  end;

var
  CommonDB : TCommonDB;

implementation
uses
  LazLogger, UConsts, UDefs;

{$R *.lfm}

{ TCommonDB }

procedure TCommonDB.ACnAfterDisconnect(Sender: TObject);
begin
  DebugLn('After disconnect');
end;

procedure TCommonDB.InitializeCommonDB;
begin
  Defs := TDefs.Create;
  Defs.SetDoExitKakeiBon(False);
  SetSQlite3DatabaseName;
end;

procedure TCommonDB.SetSQlite3DatabaseName;
begin
  try
    try
      if FSQLite3DatabaseName = '' then begin
        {$IFDEF LINUX}
          SetOSHomeDir(GetEnvironmentVariable('HOME'));
          SetDBPath(GetOSHomeDir + '/' + DB_DIR);
        {$ELSE}
          {$IFDEF DARWIN}
            // ToDo: Implements for macOS
          {$ELSE}
            {$IFDEF WINDOWS}
              SetOSHomeDir(GetEnvironmentVariable('APPDATA'));
              SetDBPath(GetOSHomeDir + '\' + DB_DIR);
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}

        FSQLite3DatabaseName := GetDBPath + cSQLite3DatabaseName;
      end;

      ACn.DatabaseName := FSQLite3DatabaseName;

      if Defs.GetDoExitKakeiBon then begin
        Application.Terminate;
        Exit;
      end;

      ForceDirectories(GetDBPath);
    except
      on E: Exception do begin
        MessageDlg(MSG_JP_000008 + E.Message, mtError, [mbOk], 0);
        Defs.SetDoExitKakeiBon(True);
      end;
    end;
  finally
    SetDBFullPath(FSQLite3DatabaseName);
  end;
end;

procedure TCommonDB.SQLite3Connect;
begin
  try
    with ACn do begin
      if Not ((Assigned(ACn)) And (Connected)) then begin
        Open;
      end;
    end;
    with ATr do begin
      if Not ((Assigned(ATr)) And (Active)) then begin
        StartTransaction;
      end;
    end;

  except
    on E: Exception do begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TCommonDB.SQLite3Disconnect;
begin
  try
    if (Assigned(ATr)) And (ATr.Active) then begin
      ATr.Rollback;
    end;
    if (Assigned(ACn)) And (ACn.Connected) then begin
      ACn.Close;
    end;
  except
    on E: Exception do begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TCommonDB.CloseQuery(var Qu: TSQLQuery);
begin
  try
    try
      if (Assigned(Qu)) And (Qu.Active) then begin
        Qu.Close;
      end;
    except
      on E: Exception do begin
        ShowMessage(MSG_JP_000040 + ' : ' + E.Message);
      end;
    end;
  finally
  end;
end;

function TCommonDB.GetOSHomeDir: AnsiString;
begin
  Result     := FOSHomeDir;
end;

procedure TCommonDB.SetOSHomeDir(aOSHomeDir: AnsiString);
begin
  FOSHomeDir := aOSHomeDir;
end;

function TCommonDB.GetDBPath: AnsiString;
begin
  Result := FDBPath;
end;

procedure TCommonDB.SetDBPath(aDBDir: AnsiString);
begin
  FDBPath := aDBDir;
end;

function TCommonDB.GetDBFullPath: AnsiString;
begin
  Result       := FDBFullPath;
end;

procedure TCommonDB.SetDBFullPath(aDBFullPath: AnsiString);
begin
  if aDBFullPath <> '' then begin
    FDBFullPath := aDBFullPath;
  end else begin
    MessageDlg(MSG_JP_000008, mtError, [mbOk], 0);
    Defs.SetDoExitKakeiBon(True);
  end;
end;

end.

