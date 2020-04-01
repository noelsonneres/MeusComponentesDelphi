{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit frxChartLazarus;

interface

uses
  frxRegChartLaz, frxChartLaz, frxChartEditorLaz, frxSelSeries, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('frxRegChartLaz', @frxRegChartLaz.Register);
end;

initialization
  RegisterPackage('frxChartLazarus', @Register);
end.
