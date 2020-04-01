unit Unit1;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
{$IFDEF Delphi22}
  System.ImageList,
{$ENDIF}
  StdCtrls, Db, frxDesgn, frxClass, frxDCtrl,
  frxRich, frxBarcode, ImgList, ComCtrls, ExtCtrls, frxOLE,
  frxCross, frxDMPExport, frxExportImage, frxExportRTF,
  frxExportXML, frxExportHTML, frxGZip, frxExportPDF,
  frxChBox, frxExportText, frxExportCSV, frxExportMail,
  frxADOComponents, frxCrypt, frxExportODF, frxPrinter, frxSaveFRX,
  frxExportHTMLDiv, frxExportXLSX, frxExportPPTX, frxExportDOCX,
  frxExportBIFF, frxChart, frxExportSVG, frxTableObject, frxMap,
  frxExportHelpers, frxExportBaseDialog, Variants, frxCellularTextObject;

type
  TForm1 = class(TForm)
    frxDesigner1: TfrxDesigner;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxRichObject1: TfrxRichObject;
    frxDialogControls1: TfrxDialogControls;
    ImageList1: TImageList;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    frxOLEObject1: TfrxOLEObject;
    frxCrossObject1: TfrxCrossObject;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    frxBMPExport1: TfrxBMPExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxTIFFExport1: TfrxTIFFExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxXMLExport1: TfrxXMLExport;
    frxRTFExport1: TfrxRTFExport;
    frxGZipCompressor1: TfrxGZipCompressor;
    frxPDFExport1: TfrxPDFExport;
    Label4: TLabel;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxMailExport1: TfrxMailExport;
    frxCSVExport1: TfrxCSVExport;
    frxGIFExport1: TfrxGIFExport;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    frxADOComponents1: TfrxADOComponents;
    frxCrypt1: TfrxCrypt;
    GroupBox1: TGroupBox;
    Tree: TTreeView;
    GroupBox2: TGroupBox;
    DescriptionM: TMemo;
    DesignB: TButton;
    PreviewB: TButton;
    Label5: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    FileNameL: TLabel;
    Shape1: TShape;
    frxODSExport1: TfrxODSExport;
    frxODTExport1: TfrxODTExport;
    frxReport1: TfrxReport;
    frxDOCXExport1: TfrxDOCXExport;
    frxPPTXExport1: TfrxPPTXExport;
    frxXLSXExport1: TfrxXLSXExport;
    frxHTML5DivExport1: TfrxHTML5DivExport;
    frxBIFFExport1: TfrxBIFFExport;
    frxChartObject1: TfrxChartObject;
    frxSVGExport1: TfrxSVGExport;
    procedure DesignBClick(Sender: TObject);
    procedure TreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure PreviewBClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { IOTransport declarations }
    WPath: String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Unit2, ShellApi, frxIOTransportMail, frxIOTransportFTP, frxIOTransportDropbox,
  frxIOTransportOneDrive, frxIOTransportBoxCom, frxIOTransportGoogleDrive,
  frxGaugeView, frxGaugeDialogControl, frxZipCode
{$IFDEF Delphi7}
  , XPMan
{$ENDIF};

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  TfrxMailIOTransport.Create(Self);
  TfrxFTPIOTransport.Create(Self);
  TfrxDropboxIOTransport.Create(Self);
  TfrxOneDriveIOTransport.Create(Self);
  TfrxBoxComIOTransport.Create(Self);
  TfrxGoogleDriveIOTransport.Create(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  WPath := ExtractFilePath(Application.ExeName);
  Tree.Items[0].Item[0].Selected := True;
  Label2.Caption := FR_VERSION;
  Label4.Caption := #174;
end;

procedure TForm1.DesignBClick(Sender: TObject);
begin
  frxReport1.DesignReport;
end;

procedure TForm1.PreviewBClick(Sender: TObject);
begin
  frxReport1.ShowReport;
end;

procedure TForm1.TreeCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Node.Count <> 0 then
    Tree.Canvas.Font.Style := [fsBold];
end;

procedure TForm1.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  if Node.StateIndex = -1 then
  begin
    Tree.FullCollapse;
    Node[0].Selected := True;
  end
  else
  begin
    DesignB.Enabled := True;
    PreviewB.Enabled := True;
    frxReport1.LoadFromFile(WPath + IntToStr(Node.StateIndex) + '.fr3');
    frxReport1.PreviewOptions.Buttons := frxReport1.PreviewOptions.Buttons + [pbInplaceEdit ,pbSelection, pbCopy, pbPaste];
    frxReport1.PreviewOptions.AllowPreviewEdit := True;
    FileNameL.Caption := ' Report file: ' + IntToStr(Node.StateIndex) + '.fr3';
    DescriptionM.Lines := frxReport1.ReportOptions.Description;
  end;
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow, 'open',
    PChar(TLabel(Sender).Caption), nil, nil, sw_ShowNormal);
end;

end.


