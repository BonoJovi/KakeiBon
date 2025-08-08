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
  Forms, datetimectrls, UAddDetail, UAddDetailsHeader, UAddUser, UDBAccess,
  UDefs, UEditAdmUser, UEditDetail, UEditDetailsHeader, UEditUser,
  UEntryAccount, UEntryAdmin, UEntryBrandName, UEntryMaker, UEntryShop,
  UEntryUnit, ULogin, UManageDetails, UManageExp, UManageUser, URemoveUser,
  UTopMenu, UConsts, USummary;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TFrmTopMenu, FrmTopMenu);
  Application.CreateForm(TFrmSummary, FrmSummary);
  Application.Run;
end.

