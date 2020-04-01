
{******************************************}
{                                          }
{             FastReport v6.0              }
{               EMF Format                 }
{                                          }
{        Copyright (c) 2015 - 2018         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxEMFFormat;

interface

{$I frx.inc}

uses
  Windows, Graphics, Classes, frxTrueTypeFont, frxTrueTypeCollection, frxUtils,
  {$IFDEF Delphi12}pngimage{$ELSE}frxpngimage{$ENDIF};

const
{ Enhanced metafile record types.}
  EMR_Reserved_69 = $00000045;
  EMR_SetLayout =   $00000073;
  LAYOUT_RTL = 1; // https://msdn.microsoft.com/en-us/library/cc230689.aspx
  EMR_ColorMatchToTargetW = $00000079;
  EMR_CreateColorSpaceW = $0000007A;

  EMR_EMR = $0000007B;
  EMR_Bytes = $0000007C;
  EMR_CreateHandle = $0000007D;
  EMR_LongWords = $0000007E;

  MWT_SET = 4; // https://msdn.microsoft.com/en-us/library/cc230538.aspx

  ETO_NO_RECT = $00000100; // https://msdn.microsoft.com/en-us/library/cc231172.aspx
  ETO_SMALL_CHARS = $00000200;

{ Record structures for the enhanced metafile.}
type
  PEnhMetaHeader = ^TEnhMetaHeader;
  TEnhMetaHeader = record
    iType: DWORD;          { Record type EMR_HEADER}
    nSize: DWORD;          { Record size in bytes.  This may be greater than the sizeof(TEnhMetaHeader). }
    rclBounds: TRect;      { Inclusive-inclusive bounds in device units}
    rclFrame: TRect;       { Inclusive-inclusive Picture Frame of metafile in .01 mm units}
    dSignature: DWORD;     { Signature.  Must be ENHMETA_SIGNATURE.}
    nVersion: DWORD;       { Version number}
    nBytes: DWORD;         { Size of the metafile in bytes}
    nRecords: DWORD;       { Number of records in the metafile}
    nHandles: Word;        { Number of handles in the handle table Handle index zero is reserved. }
    sReserved: Word;       { Reserved.  Must be zero.}
    nDescription: DWORD;   { Number of chars in the unicode description string This is 0 if there is no description string }
    offDescription: DWORD; { Offset to the metafile description record. This is 0 if there is no description string }
    nPalEntries: DWORD;    { Number of entries in the metafile palette.}
    szlDevice: TSize;      { Size of the reference device in pels}
    szlMillimeters: TSize; { Size of the reference device in millimeters}
{ Extension 1 }
    cbPixelFormat: DWORD;  { Size of TPixelFormatDescriptor information This is 0 if no pixel format is set }
    offPixelFormat: DWORD; { Offset to TPixelFormatDescriptor This is 0 if no pixel format is set }
    bOpenGL: DWORD;        { True if OpenGL commands are present in the metafile, otherwise FALSE }
 {Extension 2 }
    szlMicrometers: TSize; { Size of the reference device in micrometers }
  end;

  TEMRPolyPolygon16 = TEMRPolyPolyline16;

  TEMRPolyBezier16 = TEMRPolyLine16;
  TEMRPolyBezierTo16 = TEMRPolyLine16;
  TEMRPolygon16 = TEMRPolyline16;
  TEMRPolylineTo16 = TEMRPolyLine16;

  TEMRDeleteObject = TEMRSelectObject;

  TEMRRectangle = TEMREllipse;

  TEMRMoveToEx = TEMRLineTo;

  TEMRExtCreateFontIndirectW = TEMRExtCreateFontIndirect;

  TEMRStrokeAndFillPath = TEMRFillPath;
  TEMRStrokePath = TEMRFillPath;

  TEMRExtTextOutW = TEMRExtTextOut;
  TEMRExtTextOutA = TEMRExtTextOut;

  TSetBrushOrgEx = TEMRSetViewportOrgEx;

  TEMRIntersectClipRect = TEMRExcludeClipRect;

  TEMRScaleWindowExtEx = TEMRScaleViewportExtEx;

  TEMRChord = TEMRArc;
  TEMRPie = TEMRArc;
  TEMRArcTo = TEMRArc;

  TEMRPaintRgn = TEMRInvertRgn;

  TEMRPolyTextOutA = TEMRPolyTextOut;
  TEMRPolyTextOutW = TEMRPolyTextOut;

  TEMRDeleteColorSpace = TEMRSelectColorSpace;
  TEMRSetColorSpace = TEMRSelectColorSpace;

  TEMRextEscape = record
    emr: TEMR;
    iEscape: LongInt; // Escape code
    cbEscData: LongInt; // Size of escape data
    EscData: array [0..0] of Byte; // Escape data
  end;
  TEMRDrawEsc = TEMRextEscape;

  TEMRColorCorrectPalette = record
    emr: TEMR;
    ihPalette: LongWord;   // Palette handle index
    nFirstEntry: LongWord; // Index of first entry to correct
    nPalEntries: LongWord; // Number of palette entries to correct
    nReserved: LongWord;   // Reserved
  end;

  TEMRSetIcmProfile = record
    emr: TEMR;
    dwFlags: LongWord; // flags
    cbName: LongWord; // Size of desired profile name
    cbData: LongWord; // Size of raw profile data if attached
    Data: array [0..0] of Byte; // Array size is cbName + cbData
  end;

  TEMRSetLayout = TEMRSetBkMode;

  TEMRPolyBezier = TEMRPolyLine;
  TEMRPolygon = TEMRPolyLine;
  TEMRPolyBezierTo = TEMRPolyLine;
  TEMRPolylineTo = TEMRPolyLine;

  TEMRPolyPolygon = TEMRPolyPolyline;

  TEMRForceUFIMapping = record
    emr: TEMR;
    Checksum: LongWord;
    Index: LongWord;
  end;

  TEMRSmallTextOut = record
    emr: TEMR;
    ptlReference: TPoint;
    nChars: LongWord;
    fuOptions: LongWord;
    iGraphicsMode: LongWord;
    exScale: Single;
    eyScale: Single;
    rclClip: TRect; {optional}
  end;

  TEMRGradientFill = TEMGradientFill;

  TEMRColorMatchToTarget = record
    emr: TEMR;
    dwAction: LongWord;  // CS_ENABLE, CS_DISABLE or CS_DELETE_TRANSFORM
    dwFlags: LongWord;   // flags
    cbName: LongWord;    // Size of desired target profile name
    cbData: LongWord;    // Size of raw target profile data if attached
    Data: array [0..0] of Byte; // Array size is cbName + cbData
  end;

//  PBytes = ^TBytes;
  TBytes = array[0..0] of Byte;
  TLongWords = array[0..0] of LongWord;
  {$NODEFINE TEnhMetaData}
  (*$HPPEMIT '  struct TEnhMetaData;'*)
  PEnhMetaData = ^TEnhMetaData;
  TEnhMetaData = record
    case LongWord of
      EMR_EMR: (EMR: TEMR);
      EMR_Bytes: (Bytes: TBytes);
      EMR_LongWords: (LongWords: TLongWords);
      EMR_Header: (Header: TEnhMetaHeader); // -- TEnhMetaHeader
      EMR_PolyBezier: (PolyBezier: TEMRPolyBezier);
      EMR_Polygon: (Polygon: TEMRPolygon);
      EMR_Polyline: (Polyline: TEMRPolyline);
      EMR_PolyBezierTo: (PolyBezierTo: TEMRPolyBezierTo);
      EMR_PolylineTo: (PolylineTo: TEMRPolylineTo);
      EMR_PolyPolyline: (PolyPolyline: TEMRPolyPolyline);
      EMR_PolyPolygon: (PolyPolygon: TEMRPolyPolygon);
      EMR_SetWindowExtEx: (SetWindowExtEx: TEMRSetViewportExtEx);
      EMR_SetWindowOrgEx: (SetWindowOrgEx: TEMRSetViewportOrgEx);
      EMR_SetViewPortExtEx: (SetViewPortExtEx: TEMRSetViewportExtEx);
      EMR_SetViewPortOrgEx: (SetViewPortOrgEx: TEMRSetViewportOrgEx);
      EMR_SetBrushOrgEx: (SetBrushOrgEx: TSetBrushOrgEx);
      EMR_EoF: (EoF: TEMREoF);
      EMR_SetPixelV: (SetPixelV: TEMRSetPixelV);
      EMR_SetMapperFlags: (SetMapperFlags: TEMRSetMapperFlags);
      EMR_SetMapMode: (SetMapMode: TEMRSetMapMode);
      EMR_SetBkMode: (SetBkMode: TEMRSetBkMode);
      EMR_SetPolyFillMode: (SetPolyFillMode: TEMRSetPolyFillMode);
      EMR_SetRop2: (SetRop2: TEMRSetRop2);
      EMR_SetStretchBltMode: (SetStretchBltMode: TEMRSetStretchBltMode);
      EMR_SetTextAlign: (SetTextAlign: TEMRSetTextAlign);
      EMR_SetColorAdjustment: (SetColorAdjustment: TEMRSetColorAdjustment);
      EMR_SetTextColor: (SetTextColor: TEMRSetTextColor);
      EMR_SetBkColor: (SetBkColor: TEMRSetBkColor);
      EMR_OffsetClipRgn: (OffsetClipRgn: TEMROffsetClipRgn);
      EMR_MoveToEx: (MoveToEx: TEMRMoveToEx);
      EMR_SetMetaRgn: (SetMetaRgn: TEMRSetMetaRgn);
      EMR_ExcludeClipRect: (ExcludeClipRect: TEMRExcludeClipRect);
      EMR_IntersectClipRect: (IntersectClipRect: TEMRIntersectClipRect);
      EMR_ScaleViewportExtEx: (ScaleViewportExtEx: TEMRScaleViewportExtEx);
      EMR_ScaleWindowExtEx: (ScaleWindowExtEx: TEMRScaleWindowExtEx);
      EMR_SaveDC: (SaveDC: TEMRSaveDC);
      EMR_RestoreDC: (RestoreDC: TEMRRestoreDC);
      EMR_SetWorldTransform: (SetWorldTransform: TEMRSetWorldTransform);
      EMR_ModifyWorldTransform: (ModifyWorldTransform: TEMRModifyWorldTransform);
      EMR_SelectObject: (SelectObject: TEMRSelectObject);
      EMR_CreatePen: (CreatePen: TEMRCreatePen);
      EMR_CreateBrushIndirect: (CreateBrushIndirect: TEMRCreateBrushIndirect);
      EMR_DeleteObject: (DeleteObject: TEMRDeleteObject);
      EMR_AngleArc: (AngleArc: TEMRAngleArc);
      EMR_Ellipse: (Ellipse: TEMREllipse);
      EMR_Rectangle: (Rectangle: TEMRRectangle);
      EMR_RoundRect: (RoundRect: TEMRRoundRect);
      EMR_Arc: (Arc: TEMRArc);
      EMR_Chord: (Chord: TEMRChord);
      EMR_Pie: (Pie: TEMRPie);
      EMR_SelectPalette: (SelectPalette: TEMRSelectPalette);
      EMR_CreatePalette: (CreatePalette: TEMRCreatePalette);
      EMR_SetPaletteEntries: (SetPaletteEntries: TEMRSetPaletteEntries);
      EMR_ResizePalette: (ResizePalette: TEMRResizePalette);
      EMR_RealizePalette: (RealizePalette: TEMR);
      EMR_ExtFloodFill: (ExtFloodFill: TEMRExtFloodFill);
      EMR_LineTo: (LineTo: TEMRLineTo);
      EMR_ArcTo: (ArcTo: TEMRArcTo);
      EMR_PolyDraw: (PolyDraw: TEMRPolyDraw);
      EMR_SetArcDirection: (SetArcDirection: TEMRSetArcDirection);
      EMR_SetMiterLimit: (SetMiterLimit: TEMRSetMiterLimit);
      EMR_BeginPath: (BeginPath: TEMRBeginPath);
      EMR_EndPath: (EndPath: TEMREndPath);
      EMR_CloseFigure: (CloseFigure: TEMRCloseFigure);
      EMR_FillPath: (FillPath: TEMRFillPath);
      EMR_StrokeAndFillPath: (StrokeAndFillPath: TEMRStrokeAndFillPath);
      EMR_StrokePath: (StrokePath: TEMRStrokePath);
      EMR_FlattenPath: (FlattenPath: TEMRFlattenPath);
      EMR_WidenPath: (WidenPath: TEMRWidenPath);
      EMR_SelectClipPath: (SelectClipPath: TEMRSelectClipPath);
      EMR_AbortPath: (AbortPath: TEMRAbortPath);
      EMR_Reserved_69: (Reserved_69: TEMR);
      EMR_GDIComment: (GDIComment: TEMRGDIComment);
      EMR_FillRgn: (FillRgn: TEMRFillRgn);
      EMR_FrameRgn: (FrameRgn: TEMRFrameRgn);
      EMR_InvertRgn: (InvertRgn: TEMRInvertRgn);
      EMR_PaintRgn: (PaintRgn: TEMRPaintRgn);
      EMR_ExtSelectClipRgn: (ExtSelectClipRgn: TEMRExtSelectClipRgn);
      EMR_BitBlt: (BitBlt: TEMRBitBlt);
      EMR_StretchBlt: (StretchBlt: TEMRStretchBlt);
      EMR_MaskBlt: (MaskBlt: TEMRMaskBlt);
      EMR_PLGBlt: (PLGBlt: TEMRPLGBlt);
      EMR_SetDIBitsToDevice: (SetDIBitsToDevice: TEMRSetDIBitsToDevice);
      EMR_StretchDIBits: (StretchDIBits: TEMRStretchDIBits);
      EMR_ExtCreateFontIndirectW: (ExtCreateFontIndirectW: TEMRExtCreateFontIndirectW);
      EMR_ExtTextOutA: (ExtTextOutA: TEMRExtTextOutA);
      EMR_ExtTextOutW: (ExtTextOutW: TEMRExtTextOutW);
      EMR_PolyBezier16: (PolyBezier16: TEMRPolyBezier16);
      EMR_Polygon16: (Polygon16: TEMRPolygon16);
      EMR_Polyline16: (Polyline16: TEMRPolyline16);
      EMR_PolyBezierTo16: (PolyBezierTo16: TEMRPolyBezierTo16);
      EMR_PolylineTo16: (PolylineTo16: TEMRPolylineTo16);
      EMR_PolyPolyline16: (PolyPolyline16: TEMRPolyPolyline16);
      EMR_PolyPolygon16: (PolyPolygon16: TEMRPolyPolygon16);
      EMR_PolyDraw16: (PolyDraw16: TEMRPolyDraw16);
      EMR_CreateMonoBrush: (CreateMonoBrush: TEMRCreateMonoBrush);
      EMR_CreateDIBPatternBrushPt: (CreateDIBPatternBrushPt: TEMRCreateDIBPatternBrushPt);
      EMR_ExtCreatePen: (ExtCreatePen: TEMRExtCreatePen);
      EMR_PolyTextOutA: (PolyTextOutA: TEMRPolyTextOutA);
      EMR_PolyTextOutW: (PolyTextOutW: TEMRPolyTextOutW);
      EMR_SetICMMode: (SetICMMode: TEMRSetICMMode);
      EMR_CreateColorSpace: (CreateColorSpace: TEMRCreateColorSpace);
      EMR_SetColorSpace: (SetColorSpace: TEMRSetColorSpace);
      EMR_DeleteColorSpace: (DeleteColorSpace: TEMRDeleteColorSpace);
      EMR_GLSRecord: (GLSRecord: TEMRGLSRecord);
      EMR_GLSBoundedRecord: (GLSBoundedRecord: TEMRGLSBoundedRecord);
      EMR_PixelFormat: (PixelFormat: TEMRPixelFormat);
      EMR_DrawEscape: (DrawEscape: TEMRDrawEsc);
      EMR_ExtEscape: (ExtEscape: TEMRExtEscape);
      EMR_StartDoc: (StartDoc: TEMR); // ? https://msdn.microsoft.com/en-us/library/windows/desktop/dd145114%28v=vs.85%29.aspx
      EMR_SmallTextOut: (SmallTextOut: TEMRSmallTextOut);
      EMR_ForceUFIMapping: (ForceUFIMapping: TEMRForceUFIMapping);
      EMR_NamedEscape: (NamedEscape: TEMR);
      EMR_ColorCorrectPalette: (ColorCorrectPalette: TEMRColorCorrectPalette);
      EMR_SetIcmProfileA: (SetIcmProfileA: TEmrSetIcmProfile);
      EMR_SetIcmProfileW: (SetIcmProfileW: TEmrSetIcmProfile);
      EMR_AlphaBlend: (AlphaBlend: TEMRAlphaBlend);
      EMR_SetLayout: (SetLayout: TEMRSetLayout);
      EMR_TransparentBlt: (TransparentBlt: TEMRTransparentBlt);
      EMR_TransparentDIB: (TransparentDIB: TEMR);
      EMR_GradientFill: (GradientFill: TEMRGradientFill);
      EMR_SetLinkedUFIs: (SetLinkedUFIs: TEMR);
      EMR_SetTextJustification: (SetTextJustification: TEMR);
      EMR_ColorMatchToTargetW: (ColorMatchToTargetW: TEMRColorMatchToTarget);
      EMR_CreateColorSpaceW: (CreateColorSpaceW: TEMRCreateColorSpace);
  end;

  TEnhMetaObj = class
  protected
    FP: PEnhMetaData;
    function GetWideString(Length, Offset: integer): WideString;
    function GetANSIString(Length, Offset: integer): AnsiString;
  public
    constructor Create(Stream: TStream; Size: Integer);
    constructor CreateRec(var EMR);
    destructor Destroy; override;

    property P: PEnhMetaData read FP;
  end;

const
{ TEnhMetaHeader Type}
  ehUnknown = -1;
  ehOriginal = 0;
  ehExtension1 = 1;
  ehExtension2 = 2;

type
  TEnhMetaHeaderObj = class (TEnhMetaObj)
  private
    function GetExtension: Integer;
    function GetDescription: WideString;
    function GetPixelFormatDescriptor: TPixelFormatDescriptor;
  public
    property Extension: Integer read GetExtension;
    property Description: WideString read GetDescription;
{Extension 1}
    property PixelFormatDescriptor: TPixelFormatDescriptor read GetPixelFormatDescriptor;
  end;

  TEoFObj = class (TEnhMetaObj)
  private
    function GetPaletteEntry(Index: LongWord): TPaletteEntry;
    function GetnSizeLast: LongWord;
  public
    property PaletteEntry[Index: LongWord]: TPaletteEntry read GetPaletteEntry;
    property nSizeLast: LongWord read GetnSizeLast;
  end;

  TEMRPolyPolygon16Obj = class (TEnhMetaObj)
  private
    function GetPolyPoint(Poly, Point: Integer): TSmallPoint;
  public
    property PolyPoint[Poly, Point: Integer]: TSmallPoint read GetPolyPoint;
  end;
  TEMRPolyPolyline16Obj = class (TEMRPolyPolygon16Obj);

  TEMRPolyPolygonObj = class (TEnhMetaObj)
  private
    function GetPolyPoint(Poly, Point: Integer): TPoint;
  public
    property PolyPoint[Poly, Point: Integer]: TPoint read GetPolyPoint;
  end;
  TEMRPolyPolylineObj = class (TEMRPolyPolygon16Obj);

  PRectArray = ^TRectArray;
  TRectArray = array[0..0] of TRect;

  TEMRExtSelectClipRgnObj = class (TEnhMetaObj)
  private
    function GetRegionData: PRgnData;
    function GetRegion(Index: LongWord): TRect;
  public
    property PRegionData: PRgnData read GetRegionData;
    property Region[Index: LongWord]: TRect read GetRegion;
  end;

  TEMRBitmap  = class (TEnhMetaObj)
  protected
    function OffsetBmiSrc: LongWord; virtual; abstract;
  public
    function GetBitmap: TBitmap;
  end;

  TEMRBitBltObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRStretchBltObj = class (TEMRBitBltObj);

  TEMRStretchDIBitsObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRMaskBltObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRPLGBltObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRSetDIBitsToDeviceObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRAlphaBlendObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  public
    function GetPngObject: TPngObject;
    function GetBitmap24: TBitmap;
  end;

  TEMRTransparentBltObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRCreateMonoBrushObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRExtCreatePenObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRCreateDIBPatternBrushPtObj = class (TEMRBitmap)
  protected
    function OffsetBmiSrc: LongWord; override;
  end;

  TEMRExtTextOutWObj = class (TEnhMetaObj)
  private
    function GetTextLength: LongWord;
  public
    function OutputString(FontName: string; IsRTL: Boolean = False): WideString;
    function OutputDx: TLongWordArray;
    function OutputDy: TLongWordArray;
    function IsOption(O: LongWord): Boolean;

    property TextLength: LongWord read GetTextLength;
  end;

  TEMRExtTextOutAObj = class (TEnhMetaObj)
  private
    function GetOutputString: AnsiString;
    function GetTextLength: LongWord;
  public
    function OutputDx: TLongWordArray;
    function OutputDy: TLongWordArray;
    function IsOption(O: LongWord): Boolean;

    property TextLength: LongWord read GetTextLength;
    property OutputString: AnsiString read GetOutputString;
  end;

  TEMRPolyTextOutWObj = class (TEnhMetaObj)
  private
    function GetOutputString(Index: integer): WideString;
  public
    property OutputString[Index: integer]: WideString read GetOutputString;
  end;

  TEMRPolyTextOutAObj = class (TEnhMetaObj)
  private
    function GetOutputString(Index: integer): AnsiString;
  public
    property OutputString[Index: integer]: AnsiString read GetOutputString;
  end;

  TEMRPolyDrawObj =  class (TEnhMetaObj)
  private
    function GetTypes(Index: LongWord): byte;
  public
    property Types[Index: LongWord]: byte read GetTypes;
  end;

  TEMRPolyDraw16Obj =  class (TEnhMetaObj)
  private
    function GetTypes(Index: LongWord): byte;
  public
    property Types[Index: LongWord]: byte read GetTypes;
  end;

  TEMRSmallTextOutObj =  class (TEnhMetaObj)
  private
    function GetOutputStringWide: WideString;
    function GetOutputStringANSI: AnsiString;

    function StringOffset: integer;
  public
    function IsNoRect: boolean;
    function IsANSI: boolean;

    property OutputStringWide: WideString read GetOutputStringWide;
    property OutputStringANSI: AnsiString read GetOutputStringANSI;
  end;

function IsStockObject(const ih: LongWord): Boolean; overload;
function IsStockObject(EnhMetaObj: TEnhMetaObj): Boolean; overload;
function IsStockBrush(const ih: LongWord): Boolean; overload;
function IsStockBrush(EnhMetaObj: TEnhMetaObj): Boolean; overload;
function IsStockPen(const ih: LongWord): Boolean; overload;
function IsStockPen(EnhMetaObj: TEnhMetaObj): Boolean; overload;
function IsStockFont(const ih: LongWord): Boolean; overload;
function IsStockFont(EnhMetaObj: TEnhMetaObj): Boolean; overload;
function IsStockPalette(const ih: LongWord): Boolean; overload;
function IsStockPalette(EnhMetaObj: TEnhMetaObj): Boolean; overload;
function StockObject(const ih: LongWord): TEnhMetaObj;

implementation(****************************************************************)

uses Types, SysUtils;

var
  StockObjectTable: array[0..STOCK_LAST] of TEnhMetaObj;

{ TEnhMetaObj }

constructor TEnhMetaObj.Create(Stream: TStream; Size: Integer);
begin
  GetMem(FP, Size);
  Stream.Read(P^, Size);
end;

constructor TEnhMetaObj.CreateRec(var EMR);
begin
  GetMem(FP, TEMR(EMR).nSize);
  Move(EMR, P^, TEMR(EMR).nSize);
end;

destructor TEnhMetaObj.Destroy;
begin
  FreeMem(FP);
  inherited;
end;

function TEnhMetaObj.GetANSIString(Length, Offset: integer): AnsiString;
begin
  SetLength(Result, Length);
  Move(P^.Bytes[Offset], Result[1], Length * SizeOf(Result[1]));
end;

function TEnhMetaObj.GetWideString(Length, Offset: integer): WideString;
begin
  SetLength(Result, Length);
  Move(P^.Bytes[Offset], Result[1], Length * SizeOf(Result[1]));
end;

{ TEnhMetaHeaderObj }

function TEnhMetaHeaderObj.GetDescription: WideString;
begin
  with P^.Header do
    Result := GetWideString(nDescription, offDescription);
end;

function TEnhMetaHeaderObj.GetExtension: Integer;
var
  HeaderSize: Integer;
begin
  if P^.Header.offDescription > 0 then
    HeaderSize := P^.Header.offDescription
  else
    HeaderSize := P^.Header.nSize;

  if HeaderSize >= 108 then // Extension 2
    Result := ehExtension2
  else if HeaderSize >= 100 then // Extension 1
    Result := ehExtension1
  else if HeaderSize >= 88 then // Original
    Result := ehOriginal
  else                     // Unknown
    Result := ehUnknown;
end;

function TEnhMetaHeaderObj.GetPixelFormatDescriptor: TPixelFormatDescriptor;
begin
  Move(P^.Bytes[P^.Header.offPixelFormat], Result, P^.Header.cbPixelFormat);
end;

{ TEoFObj }

function TEoFObj.GetnSizeLast: LongWord;
begin
  Result := LongWord(PaletteEntry[P^.EoF.nPalEntries]);
end;

function TEoFObj.GetPaletteEntry(Index: LongWord): TPaletteEntry;
begin
  Move(P^.Bytes[P^.EoF.offPalEntries + Index], Result, SizeOf(TPaletteEntry));
end;

{ TEMRPolyPolygon16Obj }

function TEMRPolyPolygon16Obj.GetPolyPoint(Poly, Point: Integer): TSmallPoint;
const
  ElementSize = SizeOf(TSmallPoint);
var
  i: Integer;
  PolyStart: Integer;
begin
  PolyStart :=
    SizeOf(P^.PolyPolygon16.emr) + SizeOf(P^.PolyPolygon16.rclBounds) +
    SizeOf(P^.PolyPolygon16.nPolys) + SizeOf(P^.PolyPolygon16.cpts) +
    SizeOf(P^.PolyPolygon16.aPolyCounts[0]) * P^.PolyPolygon16.nPolys;
  for i := 0 to Poly - 1 do
    PolyStart := PolyStart + Integer(P^.PolyPolygon16.aPolyCounts[i] * ElementSize);
  Move(P^.Bytes[PolyStart + Point * ElementSize], Result, ElementSize);
end;

{ TEMRExtSelectClipRgnObj }

function TEMRExtSelectClipRgnObj.GetRegion(Index: LongWord): TRect;
begin
  Move(PRgnData(Addr(P^.ExtSelectClipRgn.RgnData))^.Buffer[Index * SizeOf(TRect)],
    Result, SizeOf(TRect));
end;

function TEMRExtSelectClipRgnObj.GetRegionData: PRgnData;
begin
  Result := PRgnData(Addr(P^.ExtSelectClipRgn.RgnData));
end;

{ TEMRBitmap }

function TEMRBitmap.GetBitmap: TBitmap;
const
  SOB = SizeOf(TBitmapFileHeader);
var
  BitMapSize: Integer;
  BitmapFileHeader: TBitmapFileHeader;
  Stream: TMemoryStream;
begin
  BitMapSize := P^.EMR.nSize - OffsetBmiSrc;

  BitmapFileHeader.bfType := $4D42;
  BitmapFileHeader.bfSize := SOB + BitMapSize;
  BitmapFileHeader.bfReserved1 := 0;
  BitmapFileHeader.bfReserved2 := 0;
  BitmapFileHeader.bfOffBits := SOB + OffsetBmiSrc;

  Stream := TMemoryStream.Create;
  Stream.SetSize(BitmapFileHeader.bfSize);
  Stream.Write(BitmapFileHeader, SOB);
  Stream.Write(P^.Bytes[OffsetBmiSrc], BitMapSize);

  Stream.Position := 0;
  Result := TBitmap.Create;
  Result.LoadFromStream(Stream);
  Stream.Free;
end;

{ TEMRBitBltObj }

function TEMRBitBltObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.BitBlt.offBmiSrc;
end;

{ TEMRStretchDIBitsObj }

function TEMRStretchDIBitsObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.StretchDIBits.offBmiSrc;
end;

{ TEMRExtTextOutWObj }

function ConvertGlyphIdxToString2(Str: PWideChar; DC: HDC): WideString;
var
  ranges: PGLYPHSET;
  restoredString: PWideChar;
  allChars : array of WCHAR;
  allIndices: array of WORD;
  x, y : cardinal;
  idx : WORD;
  Count: LongWord;
begin
  Result:= '';
  Count := Length(Str);
  if Count = 0 then
    Exit;

  ranges := AllocMem(GetFontUnicodeRanges(DC, nil));
  GetFontUnicodeRanges(DC, ranges);

  SetLength(allChars, ranges.cGlyphsSupported);
  SetLength(allIndices, ranges.cGlyphsSupported);
  idx := 0;
  for x := 0 to ranges.cRanges - 1 do
    for y := Cardinal(ranges.ranges[x].wcLow) to Cardinal(ranges.ranges[x].wcLow) + Cardinal(ranges.ranges[x].cGlyphs) - 1 do
    begin
      allChars[idx] := WCHAR(y);
      Inc(idx);
    end;

  if GetGlyphIndicesW(DC, Pointer(allChars), ranges.cGlyphsSupported, Pointer(allIndices),
                      GGI_MARK_NONEXISTING_GLYPHS ) = GDI_ERROR then
    Exit;

  restoredString := AllocMem(Count * sizeof(PWideChar));

  for x := 0 to Count -1 do
  begin
    idx := Ord(Str[x]);
    restoredString[x] := '?'; // Not found
    for y := 0 to ranges.cGlyphsSupported -1 do
      if allIndices[y] = idx then
      begin
        restoredString[x] := allChars[y];
        Break;
      end;
  end;

  Result := Copy(restoredString, 0, Count);

  FreeMem(ranges);
  Finalize(allChars);
  Finalize(allIndices);
  FreeMem(restoredString);
end;

function ConvertGlyphIdxToString(const Str: WideString; FontName: string): WideString;
var
  Bitmap: TBitMap;
begin
  Bitmap := TBitMap.Create;
  Bitmap.Canvas.Lock;
  try
    Bitmap.Canvas.Font.Name := FontName;
    Result := ConvertGlyphIdxToString2(PWideChar(Str), Bitmap.Canvas.Handle);
  finally
    Bitmap.Canvas.Unlock;
    Bitmap.Free;
  end;
end;

function TEMRExtTextOutWObj.GetTextLength: LongWord;
var
  i, Shift: integer;
  Len: LongWord;
  HasDY: Boolean;
begin
  Result := 0;
  with P^.ExtTextOutW do
  begin
    Shift := Integer(emrtext.offDx div 4);
    HasDY := IsOption(ETO_PDY);
    for i := 0 to Integer(emrtext.nChars) - 1 do
    begin
      Len := P^.LongWords[Shift + i * IfInt(HasDY, 2, 1)];
      if Len > High(LongWord) div 2 then
        Len := 0;
      Result := Result + Len;
    end;
  end;
end;

function TEMRExtTextOutWObj.IsOption(O: LongWord): Boolean;
begin
  Result := P^.ExtTextOutW.emrtext.fOptions and O = O;
end;

function TEMRExtTextOutWObj.OutputDx: TLongWordArray;
var
  i, Shift: integer;
  Step: Integer;
begin
  with P^.ExtTextOutW do
  begin
    SetLength(Result, emrtext.nChars);
    Shift := Integer(emrtext.offDx div 4);
    Step := IfInt(IsOption(ETO_PDY), 2, 1);

    for i := 0 to Integer(emrtext.nChars) - 1 do
      Result[i] := P^.LongWords[Shift + i * Step];
  end;
end;

function TEMRExtTextOutWObj.OutputDy: TLongWordArray;
var
  i, Shift: integer;
  Step: Integer;
begin
  if not IsOption(ETO_PDY) then
    SetLength(Result, 0)
  else
    with P^.ExtTextOutW do
    begin
      SetLength(Result, emrtext.nChars);
      Shift := Integer(emrtext.offDx div 4);
      Step := 2;

      for i := 0 to Integer(emrtext.nChars) - 1 do
        Result[i] := P^.LongWords[Shift + i * Step + 1];
    end;
end;

function TEMRExtTextOutWObj.OutputString(FontName: string; IsRTL: Boolean = False): WideString;
var
  i, HR: integer;
  Temp: WideChar;
begin
  with P^.ExtTextOutW.emrtext do
  begin
    Result := GetWideString(nChars, offString);
    if IsOption(ETO_GLYPH_INDEX) and (Result <> '') then
      Result := ConvertGlyphIdxToString(Result, FontName);
  end;

  if IsRTL then
  begin
    HR := Length(Result);
    for i := 1 to HR div 2 do
    begin
      Temp := Result[i];
      Result[i] := Result[HR - i + 1];
      Result[HR - i + 1] := Temp;
    end;
  end;
end;

{ TEMRPolyPolygonObj }

function TEMRPolyPolygonObj.GetPolyPoint(Poly, Point: Integer): TPoint;
const
  ElementSize = SizeOf(TPoint);
var
  i: Integer;
  PolyStart: Integer;
begin
  PolyStart :=
    SizeOf(P^.PolyPolygon.emr) + SizeOf(P^.PolyPolygon.rclBounds) +
    SizeOf(P^.PolyPolygon.nPolys) + SizeOf(P^.PolyPolygon.cptl) +
    SizeOf(P^.PolyPolygon.aPolyCounts[0]) * P^.PolyPolygon.nPolys;
  for i := 0 to Poly - 1 do
    PolyStart := PolyStart + Integer(P^.PolyPolygon.aPolyCounts[i] * ElementSize);
  Move(P^.Bytes[PolyStart + Point * ElementSize], Result, ElementSize);
end;

{ TEMRPolyDrawObj }

function TEMRPolyDrawObj.GetTypes(Index: LongWord): byte;
begin
  Result := P^.Bytes[SizeOf(TEMR) + SizeOf(TRect) + SizeOf(LongWord) +
    SizeOf(TPoint) * P^.PolyDraw.cptl + Index];
end;

{ TEMRPolyDraw16Obj }

function TEMRPolyDraw16Obj.GetTypes(Index: LongWord): byte;
begin
  Result := P^.Bytes[SizeOf(TEMR) + SizeOf(TRect) + SizeOf(LongWord) +
    SizeOf(TSmallPoint) * P^.PolyDraw16.cpts + Index];
end;

{ TEMRSmallTextOutObj }

function TEMRSmallTextOutObj.GetOutputStringANSI: AnsiString;
begin
  with P^.SmallTextOut do
    Result := GetANSIString(nChars, StringOffset);
end;

function TEMRSmallTextOutObj.GetOutputStringWide: WideString;
begin
  with P^.SmallTextOut do
    Result := GetWideString(nChars, StringOffset);
end;

function TEMRSmallTextOutObj.IsANSI: boolean;
begin
  Result := P^.SmallTextOut.fuOptions and ETO_SMALL_CHARS = ETO_SMALL_CHARS;
end;

function TEMRSmallTextOutObj.IsNoRect: boolean;
begin
  Result := P^.SmallTextOut.fuOptions and ETO_NO_RECT = ETO_NO_RECT;
end;

function TEMRSmallTextOutObj.StringOffset: integer;
begin
  Result := SizeOf(TEMR) + SizeOf(TPoint) + 3 * SizeOf(LongWord) + 2 * SizeOf(Single);
  if not IsNoRect then
    Result := Result + SizeOf(TRect);
end;

{ TEMRExtTextOutAObj }

function TEMRExtTextOutAObj.GetOutputString: AnsiString;
begin
  with P^.ExtTextOutA.emrtext do
    Result := GetANSIString(nChars, offString);
end;

function TEMRExtTextOutAObj.GetTextLength: LongWord;
var
  i, Shift: integer;
  Len: LongWord;
  HasDY: Boolean;
begin
  Result := 0;
  with P^.ExtTextOutA do
  begin
    Shift := Integer(emrtext.offDx div 4);
    HasDY := emrtext.fOptions and ETO_PDY = ETO_PDY;
    for i := 0 to Integer(emrtext.nChars) - 1 do
    begin
      Len := P^.LongWords[Shift + i * IfInt(HasDY, 2, 1)];
      if Len > High(LongWord) div 2 then
        Len := 0;
      Result := Result + Len;
    end;
  end;
end;

function TEMRExtTextOutAObj.IsOption(O: LongWord): Boolean;
begin
  Result := P^.ExtTextOutA.emrtext.fOptions and O = O;
end;

function TEMRExtTextOutAObj.OutputDx: TLongWordArray;
var
  i, Shift: integer;
  Step: Integer;
begin
  with P^.ExtTextOutA do
  begin
    SetLength(Result, emrtext.nChars);
    Shift := Integer(emrtext.offDx div 4);
    Step := IfInt(IsOption(ETO_PDY), 2, 1);

    for i := 0 to Integer(emrtext.nChars) - 1 do
      Result[i] := P^.LongWords[Shift + i * Step];
  end;
end;

function TEMRExtTextOutAObj.OutputDy: TLongWordArray;
var
  i, Shift: integer;
  Step: Integer;
begin
  if not IsOption(ETO_PDY) then
    SetLength(Result, 0)
  else
    with P^.ExtTextOutW do
    begin
      SetLength(Result, emrtext.nChars);
      Shift := Integer(emrtext.offDx div 4);
      Step := 2;

      for i := 0 to Integer(emrtext.nChars) - 1 do
        Result[i] := P^.LongWords[Shift + i * Step + 1];
    end;
end;

{ TEMRMaskBltObj }

function TEMRMaskBltObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.MaskBlt.offBmiSrc;
end;

{ TEMRPLGBltObj }

function TEMRPLGBltObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.PLGBlt.offBmiSrc;
end;

{ TEMRSetDIBitsToDeviceObj }

function TEMRSetDIBitsToDeviceObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.SetDIBitsToDevice.offBmiSrc;
end;

{ TEMRAlphaBlendObj }

function TEMRAlphaBlendObj.GetBitmap24: TBitmap;
var
  Bitmap: TBitmap; // 32 bits
  SourceBM, DestBM: PByte;
  y, x: Integer;
  S1, S2, S3, Alpha: Byte;
  Factor: Double;
begin
  Bitmap := GetBitmap;

  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.Width := Bitmap.Width;
  Result.Height := Bitmap.Height;

  for y := 0 to Bitmap.Height - 1 do
  begin
    SourceBM := Bitmap.ScanLine[y];
    DestBM := Result.Scanline[y];

    for x := 0 to Bitmap.Width - 1 do
    begin
      S1 := SourceBM^; Inc(SourceBM);
      S2 := SourceBM^; Inc(SourceBM);
      S3 := SourceBM^; Inc(SourceBM);
      Alpha := SourceBM^; Inc(SourceBM);

      if Alpha > 0 then Factor := 255 / Alpha
      else              Factor := 0;

      DestBM^ := Round(S1 * Factor); Inc(DestBM);
      DestBM^ := Round(S2 * Factor); Inc(DestBM);
      DestBM^ := Round(S3 * Factor); Inc(DestBM);
    end;
  end;

  Bitmap.Free;
end;

function TEMRAlphaBlendObj.GetPngObject: TPngObject;
var
  Bitmap: TBitmap; // 32 bits
  SourceBM, DestPNG, AlphaPNG: PByte;
  y, x: Integer;
  S1, S2, S3, Alpha: Byte;
  Factor: Double;
begin
  Bitmap := GetBitmap;

  Result := TPngObject.CreateBlank(COLOR_RGBALPHA, 8, Bitmap.Width, Bitmap.Height);

  for y := 0 to Bitmap.Height - 1 do
  begin
    SourceBM := Bitmap.ScanLine[y];
    DestPNG := Result.Scanline[y];
    AlphaPNG := Pointer(Result.AlphaScanline[y]);

    for x := 0 to Bitmap.Width - 1 do
    begin
      S1 := SourceBM^; Inc(SourceBM);
      S2 := SourceBM^; Inc(SourceBM);
      S3 := SourceBM^; Inc(SourceBM);
      Alpha := SourceBM^; Inc(SourceBM);

      if Alpha > 0 then Factor := 255 / Alpha
      else              Factor := 0;

      DestPNG^ := Round(S1 * Factor); Inc(DestPNG);
      DestPNG^ := Round(S2 * Factor); Inc(DestPNG);
      DestPNG^ := Round(S3 * Factor); Inc(DestPNG);
      AlphaPNG^ := Alpha; Inc(AlphaPNG);
    end;
  end;

  Bitmap.Free;
end;

function TEMRAlphaBlendObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.AlphaBlend.offBmiSrc;
end;

{ TEMRTransparentBltObj }

function TEMRTransparentBltObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.TransparentBlt.offBmiSrc;
end;

{ TEMRCreateMonoBrushObj }

function TEMRCreateMonoBrushObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.CreateMonoBrush.offBmi;
end;

{ TEMRCreateDIBPatternBrushPtObj }

function TEMRCreateDIBPatternBrushPtObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.CreateDIBPatternBrushPt.offBmi;
end;

{ TEMRExtCreatePen }

function TEMRExtCreatePenObj.OffsetBmiSrc: LongWord;
begin
  Result := P^.ExtCreatePen.offBmi;
end;

{ TEMRPolyTextOutAObj }

function TEMRPolyTextOutAObj.GetOutputString(Index: integer): AnsiString;
begin
  with P^.PolyTextOutA.aemrtext[Index] do
    Result := GetANSIString(nChars, offString);
end;

{ TEMRPolyTextOutWObj }

function TEMRPolyTextOutWObj.GetOutputString(Index: integer): WideString;
begin
  with P^.PolyTextOutw.aemrtext[Index] do
    Result := GetWideString(nChars, offString);
end;

{ StockObjectTable }

const
  Brush = [WHITE_BRUSH, LTGRAY_BRUSH, GRAY_BRUSH, DKGRAY_BRUSH, BLACK_BRUSH,
           NULL_BRUSH, DC_BRUSH];
  Pen = [WHITE_PEN, BLACK_PEN, NULL_PEN, DC_PEN];
  Font = [OEM_FIXED_FONT, ANSI_FIXED_FONT, ANSI_VAR_FONT, ANSI_VAR_FONT,
          DEVICE_DEFAULT_FONT, SYSTEM_FIXED_FONT, DEFAULT_GUI_FONT];
  Palette = [DEFAULT_PALETTE];

function IsStockBrush(const ih: LongWord): Boolean;
begin
  Result := (ih - ENHMETA_STOCK_OBJECT) in Brush;
end;

function IsStockBrush(EnhMetaObj: TEnhMetaObj): Boolean;
begin
  Result := IsStockBrush(EnhMetaObj.P^.SelectObject.ihObject);
end;

function IsStockPen(const ih: LongWord): Boolean;
begin
  Result := (ih - ENHMETA_STOCK_OBJECT) in Pen;
end;

function IsStockPen(EnhMetaObj: TEnhMetaObj): Boolean;
begin
  Result := IsStockPen(EnhMetaObj.P^.SelectObject.ihObject);
end;

function IsStockFont(const ih: LongWord): Boolean;
begin
  Result := (ih - ENHMETA_STOCK_OBJECT) in Font;
end;

function IsStockFont(EnhMetaObj: TEnhMetaObj): Boolean;
begin
  Result := IsStockFont(EnhMetaObj.P^.SelectObject.ihObject);
end;

function IsStockPalette(const ih: LongWord): Boolean;
begin
  Result := (ih - ENHMETA_STOCK_OBJECT) in Palette;
end;

function IsStockPalette(EnhMetaObj: TEnhMetaObj): Boolean;
begin
  Result := IsStockPalette(EnhMetaObj.P^.SelectObject.ihObject);
end;

function IsStockObject(const ih: LongWord): Boolean;
begin
  Result := (ih >= ENHMETA_STOCK_OBJECT) and
           ((ih - ENHMETA_STOCK_OBJECT) in [0..STOCK_LAST]);
end;

function IsStockObject(EnhMetaObj: TEnhMetaObj): Boolean;
begin
  Result := IsStockObject(EnhMetaObj.P^.SelectObject.ihObject);
end;

function StockObject(const ih: LongWord): TEnhMetaObj;
var
  Index: LongWord;
begin
  Index := ih - ENHMETA_STOCK_OBJECT;
  Result := StockObjectTable[Index];
end;

procedure StockObjectTableInit;
  procedure CreateBrush(ih, Style, Color: LongWord);
  var
    CB: TEMRCreateBrushIndirect;
  begin
    CB.emr.iType := EMR_CreateBrushIndirect;
    CB.emr.nSize := 24;
    CB.ihBrush := ENHMETA_STOCK_OBJECT + ih;
    CB.lb.lbStyle := Style;
    CB.lb.lbColor := Color;
    StockObjectTable[ih] := TEnhMetaObj.CreateRec(CB);
  end;

  procedure CreatePen(ih, Style, Color: LongWord);
  var
    CP: TEMRCreatePen;
  begin
    CP.emr.iType := EMR_CreatePen;
    CP.emr.nSize := 28;
    CP.ihPen := ENHMETA_STOCK_OBJECT + ih;
    CP.lopn.lopnStyle := Style;
    CP.lopn.lopnWidth := Point(1, 1);
    CP.lopn.lopnColor := Color;
    StockObjectTable[ih] := TEnhMetaObj.CreateRec(CP);
  end;

  procedure CreateFont(ih: LongWord; Charset: byte; FaceName: WideString);
  var
    CF: TEMRExtCreateFontIndirectW;
    i: integer;
  begin
    CF.emr.iType := EMR_ExtCreateFontIndirectW;
    CF.emr.nSize := SizeOf(TEMRExtCreateFontIndirectW);
    CF.ihFont := ENHMETA_STOCK_OBJECT + ih;
    CF.elfw.elfLogFont.lfHeight := 12;
    CF.elfw.elfLogFont.lfWeight := 400;
    CF.elfw.elfLogFont.lfItalic := 0;
    CF.elfw.elfLogFont.lfUnderline := 0;
    CF.elfw.elfLogFont.lfStrikeOut := 0;
    CF.elfw.elfLogFont.lfCharSet := Charset;
    for i := 0 to High(CF.elfw.elfLogFont.lfFaceName) do
      if i + 1 <= Length(FaceName) then
        CF.elfw.elfLogFont.lfFaceName[i] := FaceName[i + 1]
      else
        CF.elfw.elfLogFont.lfFaceName[i] := #0;

    StockObjectTable[ih] := TEnhMetaObj.CreateRec(CF);
  end;

var
  i: Integer;
begin
  for i := 0 to STOCK_LAST do
    StockObjectTable[i] := nil;

  CreateBrush(WHITE_BRUSH, BS_SOLID, $00FFFFFF);
  CreateBrush(LTGRAY_BRUSH, BS_SOLID, $00C0C0C0);
  CreateBrush(GRAY_BRUSH, BS_SOLID, $00808080);
  CreateBrush(DKGRAY_BRUSH, BS_SOLID, $00404040);
  CreateBrush(BLACK_BRUSH, BS_SOLID, $00000000);
  CreateBrush(NULL_BRUSH, BS_NULL, 0);
  CreateBrush(DC_BRUSH, BS_SOLID, $00FFFFFF);

  CreatePen(WHITE_PEN, PS_COSMETIC + PS_SOLID, $00FFFFFF);
  CreatePen(BLACK_PEN, PS_COSMETIC + PS_SOLID, $00000000);
  CreatePen(NULL_PEN, PS_NULL, 0);
  CreatePen(DC_PEN, PS_COSMETIC + PS_SOLID, $00000000);

  CreateFont(ANSI_FIXED_FONT, ANSI_CHARSET, 'Courier');
  CreateFont(OEM_FIXED_FONT, OEM_CHARSET, 'Terminal');
  CreateFont(ANSI_VAR_FONT, ANSI_CHARSET, 'Serif');
  CreateFont(SYSTEM_FONT, DEFAULT_CHARSET, 'System');
  CreateFont(DEVICE_DEFAULT_FONT, DEFAULT_CHARSET, 'System');
  { TODO : DEFAULT_PALETTE = 0x8000000F }
  CreateFont(SYSTEM_FIXED_FONT, DEFAULT_CHARSET, 'Fixedsys');
  CreateFont(DEFAULT_GUI_FONT, DEFAULT_CHARSET, 'Serif');
end;

procedure StockObjectTableFree;
var
  i: Integer;
begin
  for i := 0 to STOCK_LAST do
    StockObjectTable[i].Free;
end;

initialization

StockObjectTableInit;

finalization

StockObjectTableFree;

end.
