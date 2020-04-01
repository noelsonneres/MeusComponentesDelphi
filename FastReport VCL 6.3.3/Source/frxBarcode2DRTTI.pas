{ ****************************************** }
{                                            }
{             FastReport v5.0                }
{               Barcode RTTI                 }
{                                            }
{         Copyright (c) 1998-2014            }
{         by Alexander Tzyganenko,           }
{            Fast Reports Inc.               }
{                                            }
{ ****************************************** }

unit frxBarcode2DRTTI;

interface

{$I frx.inc}

implementation

uses
{$IFNDEF FPC}Windows, {$ENDIF}
  Classes, Types, SysUtils, Forms, fs_iinterpreter, frxBarcodePDF417,
  frxBarcodeDataMatrix, frxBarcodeQR, frxBarcodeAztec, frxBarcodeMaxiCode,
  frxClassRTTI, frxBarcode2D, frxBarcodeProperties
{$IFDEF Delphi6}
    , Variants
{$ENDIF};

type
  TFunctions = class(TfsRTTIModule)
  public
    constructor Create(AScript: TfsScript); override;
  end;

  { TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddEnum('TfrxBarcode2DType', 'bcCodePDF417, bcCodeDataMatrix, bcCodeQR, bcCodeAztec, bcCodeMaxiCode');
    AddEnum('TQRCodeEncoding', 'qrAuto, qrNumeric, qrAlphanumeric, qrISO88591, qrUTF8NoBOM, qrUTF8BOM, qrShift_JIS');
    AddEnum('TQRErrorLevels', 'ecL, ecM, ecQ, ecH');

    AddEnum('DatamatrixEncoding', 'Auto, Ascii, C40, Txt, Base256, X12, Edifact');
    AddEnum('DatamatrixSymbolSize', 'AutoSize, Size10x10, Size12x12, Size8x18, Size14x14, Size8x32, Size16x16, Size12x26,'
    + ' Size18x18, Size20x20, Size12x36, Size22x22, Size16x36, Size24x24, Size26x26, Size16x48, Size32x32, Size36x36, Size40x40,'
    + 'Size44x44, Size48x48, Size52x52, Size64x64, Size72x72, Size80x80, Size88x88, Size96x96, Size104x104, Size120x120, Size132x132, Size144x144');

    AddEnum('PDF417ErrorCorrection', ' AutoCorr, Level0, Level1, Level2, Level3, Level4, Level5, Level6, Level7, Level8');
    AddEnum('PDF417CompactionMode', 'AutoCompaction, TextComp, Numeric, Binary');

    AddClass(TfrxBarcode2DProperties, 'TPersistent');
    AddClass(TfrxPDF417Properties, 'TfrxBarcode2DProperties');
    AddClass(TfrxDataMatrixProperties, 'TfrxBarcode2DProperties');
    AddClass(TfrxQRProperties, 'TfrxBarcode2DProperties');
    AddClass(TfrxAztecProperties, 'TfrxBarcode2DProperties');
    AddClass(TfrxMaxiCodeProperties, 'TfrxBarcode2DProperties');

    AddClass(TfrxBarcode2DView, 'TfrxView');
  end;
end;

initialization

fsRTTIModules.Add(TFunctions);

finalization

if fsRTTIModules <> nil then
  fsRTTIModules.Remove(TFunctions);

end.
