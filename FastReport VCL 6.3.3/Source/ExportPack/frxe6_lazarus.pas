{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit frxe6_lazarus;

{$warn 5023 off : no warning about unused units}
interface

uses
  frxExportBaseDialog, frxExportImageDialog, frxExportImage, frxeReg, 
  frxExportMatrix, frxExportHTMLDivDialog, frxExportHTMLDiv, frxExportODF, 
  frxExportODFDialog, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('frxeReg', @frxeReg.Register);
end;

initialization
  RegisterPackage('frxe6_lazarus', @Register);
end.
