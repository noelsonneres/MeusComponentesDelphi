
{******************************************}
{                                          }
{             FastReport v5.0              }
{         Exports Registration unit        }
{                                          }
{         Copyright (c) 1998-2014          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxeReg;

{$I frx.inc}

interface


procedure Register;

implementation

uses
{$IFNDEF FPC}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
{$IFNDEF Delphi6}
  DsgnIntf,
{$ELSE}
  DesignIntf, DesignEditors,
{$ENDIF}
{$IFNDEF ACADEMIC_ED}
{$IFNDEF RAD_ED}
  frxExportXML, frxExportXLS, frxExportMail, frxExportHTMLDiv, 
  frxExportODF, frxExportDBF, frxExportBIFF, frxExportDOCX, frxExportPPTX, frxExportXLSX, frxExportSVG,
{$ENDIF}
  frxExportHTML, {$IFNDEF Delphi12}frxExportTXT, {$ENDIF} frxExportRTF, frxExportPDF, 
{$ENDIF}
  frxExportImage, frxExportText, frxExportCSV;
{$ELSE}
 SysUtils,
 Classes ,Graphics, Controls, Forms,
 PropEdits, LazarusPackageIntf, LResources,
 frxExportImage, frxExportHTMLDiv, frxExportODF;
{$ENDIF}

{-----------------------------------------------------------------------}

procedure Register;
begin
{$IFNDEF FPC}
  RegisterComponents('FastReport 6.0 exports',
    [
{$IFNDEF ACADEMIC_ED}
{$IFNDEF RAD_ED}
     TfrxXLSExport, TfrxXMLExport, TfrxMailExport,
      {$IFNDEF Delphi12}TfrxTXTExport, {$ENDIF}TfrxODSExport, TfrxODTExport,
      TfrxDBFExport, TfrxBIFFExport, TfrxDOCXExport, TfrxPPTXExport, TfrxXLSXExport,
      TfrxHTML4DivExport, TfrxHTML5DivExport, TfrxSVGExport,
{$ENDIF}
      TfrxPDFExport, TfrxHTMLExport, TfrxRTFExport,
{$ENDIF}
      TfrxBMPExport, TfrxJPEGExport, TfrxTIFFExport,
      TfrxGIFExport, TfrxSimpleTextExport, TfrxCSVExport]);
{$ELSE}
   RegisterComponents('FastReport 6.0 exports',[TfrxBMPExport, TfrxPNGExport,
  TfrxJPEGExport,TfrxTIFFExport, TfrxHTML4DivExport, TfrxHTML5DivExport,
  TfrxODSExport, TfrxODTExport]);
{$ENDIF}
end;

{$IFDEF FPC}
initialization
{$INCLUDE frxeReg.lrs}
{$ENDIF}


end.
