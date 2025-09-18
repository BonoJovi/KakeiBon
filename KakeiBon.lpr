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
  Forms, datetimectrls, UDBNavi, UDBG, UAddDetail, UAddDetailsHeader, UAddUser,
  UCommonDB, UConsts, UDBAccess, UDefs, UDeleteUser, UEditAdmUser, UEditDetail,
  UEditDetailsHeader, UEditUser, UEntryAccount, UEntryAdmin, UEntryBrandName,
  UEntryMaker, UEntryShop, UEntryUnit, ULogin, UManageDetails, UManageExp,
  UManageUser, USummary, UTopMenu;

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

