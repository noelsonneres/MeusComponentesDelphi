program FRDemo;

{$I frx.inc}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {ReportData: TDataModule};

{$R *.RES}

begin
{$IfDef Delphi10}
  ReportMemoryLeaksOnShutdown := True;
{$EndIf}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TReportData, ReportData);
  Application.Run;
end.
