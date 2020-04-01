{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit frxlazdbf;

interface

uses
  frxlazdbfcomp, frxlazdbfeditor, frxlazdbfrtti, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('frxlazdbfcomp', @frxlazdbfcomp.Register);
end;

initialization
  RegisterPackage('frxlazdbf', @Register);
end.
