program KakeiBon;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, UDefs, UAddDetail, UAddDetailsHeader, UAddUser, UDBAccess,
  UEditAdmUser, UEditDetail, UEditDetailsHeader, UEditUser,
  UEntryAccount, UEntryAdmin, UEntryBrandName, UEntryMaker, UEntryShop,
  UEntryUnit, ULogin, UManageDetails, UManageExp, UManageUser, UDeleteUser,
  UTopMenu, UConsts, USummary, UCommonDB;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TFrmTopMenu, FrmTopMenu);
  Application.Run;
end.

