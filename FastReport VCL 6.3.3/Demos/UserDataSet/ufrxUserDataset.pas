unit ufrxUserDataset;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, frxClass, XPMan;

type
  TForm1 = class(TForm)
    frxReport1: TfrxReport;
    frxUserDataSet1: TfrxUserDataSet;
    ADOTable1: TADOTable;
    procedure frxUserDataSet1First(Sender: TObject);
    procedure frxUserDataSet1Next(Sender: TObject);
    procedure frxUserDataSet1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frxUserDataSet1Prior(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frxUserDataSet1GetValue(const VarName: String;
      var Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.frxUserDataSet1First(Sender: TObject);
begin
  ADOTable1.First;
end;

procedure TForm1.frxUserDataSet1Next(Sender: TObject);
begin
  ADOTable1.Next;
end;

procedure TForm1.frxUserDataSet1Prior(Sender: TObject);
begin
  ADOTable1.Prior;
end;

procedure TForm1.frxUserDataSet1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
  Eof := ADOTable1.Eof;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  frxUserDataSet1.Fields.Clear;
  frxUserDataSet1.Fields.Add('Company');
  frxUserDataSet1.Fields.Add('Addr1');
  frxUserDataSet1.Fields.Add('Contact');
  frxUserDataSet1.Fields.Add('Phone');
  frxUserDataSet1.Fields.Add('FAX');
  ADOTable1.Active := False;
  {$IFNDEF CPUX64}
  ADOTable1.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=..\Main\demo.mdb';
  {$ELSE}
  ADOTable1.ConnectionString := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=..\Main\demo.mdb';
  {$ENDIF}
  ADOTable1.Active := True;
  frxReport1.ShowReport();
  Close;
end;

procedure TForm1.frxUserDataSet1GetValue(const VarName: String;
  var Value: Variant);
begin
  if VarName = 'Company' then
    Value := ADOTable1.FieldByName('Company').AsString
  else if VarName = 'Addr1' then
    Value := ADOTable1.FieldByName('Addr1').AsString
  else if VarName = 'Contact' then
    Value := ADOTable1.FieldByName('Contact').AsString
  else if VarName = 'Phone' then
    Value := ADOTable1.FieldByName('Phone').AsString
  else if VarName = 'FAX' then
    Value := ADOTable1.FieldByName('FAX').AsString;
end;

end.
