unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frxClass, StdCtrls, frxExportBaseDialog, frxExportPDF, frxRich, frxUtils,
  frxTableObject;


type
  TForm1 = class(TForm)
    CreateButton: TButton;
    SelectLabel: TLabel;
    XmlEdit: TEdit;
    SelectButton: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    frxReport1: TfrxReport;
    frxPDFExport1: TfrxPDFExport;
    procedure CreateButtonClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  frxExportPDFHelpers;

{$R *.DFM}

procedure TForm1.CreateButtonClick(Sender: TObject);
begin
  if      not FileExists(XmlEdit.Text) then
    frxErrorMsg('XML file does not exist!')
  else if not FileExists('Invoice.fr3') then
    frxErrorMsg('Report file does not exist!')
  else if SaveDialog1.Execute then
  begin
    frxPDFExport1.PDFStandard := psPDFA_3a;
    frxPDFExport1.OpenAfterExport := True;
    frxPDFExport1.AddEmbeddedXML('ZUGFeRD-invoice.xml', 'ZUGFeRD invoice', Now,
      TFileStream.Create(XmlEdit.Text, fmOpenRead));
    frxPDFExport1.FileName := SaveDialog1.FileName;
    frxPDFExport1.ShowDialog := False;

    frxReport1.LoadFromFile('Invoice.fr3');
    frxReport1.PrepareReport;
    frxReport1.Export(frxPDFExport1);
  end;
end;

procedure TForm1.SelectButtonClick(Sender: TObject);
begin
  OpenDialog1.FileName := XmlEdit.Text;
  if OpenDialog1.Execute then
    XmlEdit.Text :=  OpenDialog1.FileName;
end;

end.
