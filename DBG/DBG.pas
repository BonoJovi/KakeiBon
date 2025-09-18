{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit DBG;

{$warn 5023 off : no warning about unused units}
interface

uses
  UDBG, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('UDBG', @UDBG.Register);
end;

initialization
  RegisterPackage('DBG', @Register);
end.
