{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit DBNavi;

{$warn 5023 off : no warning about unused units}
interface

uses
  UDBNavi, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('UDBNavi', @UDBNavi.Register);
end;

initialization
  RegisterPackage('DBNavi', @Register);
end.
