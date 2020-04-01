unit DataUnit;

interface

uses
  SysUtils, Classes, frxClass, frxDBSet, DB, DBTables;

type
  TReportData = class(TDataModule)
    animals: TTable;
    biolife: TTable;
    clients: TTable;
    customer: TTable;
    animalsDB: TfrxDBDataset;
    biolifeDB: TfrxDBDataset;
    clientsBD: TfrxDBDataset;
    customerDB: TfrxDBDataset;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportData: TReportData;

implementation

{$R *.dfm}

end.
