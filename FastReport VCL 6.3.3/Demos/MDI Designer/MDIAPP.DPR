program Mdiapp;

uses
  Forms,
  MAIN in 'MAIN.PAS' {MainForm},
  DataUnit in 'DataUnit.pas' {ReportData: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TReportData, ReportData);
  Application.Run;
end.
