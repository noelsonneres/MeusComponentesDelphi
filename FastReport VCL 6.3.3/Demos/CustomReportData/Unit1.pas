unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxXML, frxXMLSerializer, frxDesgn, frxClass, StdCtrls, frxExportPDF;

type
  TForm1 = class(TForm)
    frxReport1: TfrxReport;
    frxDesigner1: TfrxDesigner;
    frxPDFExport1: TfrxPDFExport;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure frxReport1SaveCustomData(XMLItem: TfrxXMLItem);
    procedure frxReport1GetCustomData(XMLItem: TfrxXMLItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  frxReport1.DesignReport();
end;

procedure TForm1.frxReport1SaveCustomData(XMLItem: TfrxXMLItem);
var
  ss: TfrxXMLSerializer;
begin
  // serialize and save PDF filter settings to report file
  ss := TfrxXMLSerializer.Create(nil);
  ss.Owner := frxReport1;
  XMLItem := XMLItem.Add;
  XMLItem.Name := 'PDFExport';
  XMLItem.Text := ss.ObjToXML(frxPDFExport1);
end;

procedure TForm1.frxReport1GetCustomData(XMLItem: TfrxXMLItem);
var
  ss: TfrxXMLSerializer;
begin
  // load saved PDF filter settings from report file
  ss := TfrxXMLSerializer.Create(nil);
  ss.Owner := frxReport1;
  if(XMLItem.Count > 0) then
  begin
    XMLItem := XMLItem.Items[0];
    if AnsiCompareText(XMLItem.Name, 'PDFExport') = 0 then
      ss.XMLToObj(XMLItem.Text, frxPDFExport1);
  end;
end;

end.
