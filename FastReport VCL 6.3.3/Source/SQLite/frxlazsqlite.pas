{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit frxlazsqlite;

interface

uses
  frxlazsqlitecomp, frxlazsqliteeditor, frxlazsqlitertti, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('frxlazsqlitecomp', @frxlazsqlitecomp.Register);
end;

initialization
  RegisterPackage('frxlazsqlite', @Register);
end.
