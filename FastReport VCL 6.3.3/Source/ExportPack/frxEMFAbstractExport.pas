
{******************************************}
{                                          }
{             FastReport v6.0              }
{           EMF Abstract Export            }
{                                          }
{        Copyright (c) 2015 - 2019         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxEMFAbstractExport;

interface

{$I frx.inc}

uses Classes, Windows, frxEMFFormat, {The right order: "Windows, frxEMFFormat"}
     Contnrs, Graphics, frxClass, frxUtils, frxAnaliticGeometry;

type
  TDeviceContextData = record
    rTopLeft: TfrxPoint;
    Layout: LongWord;
    MapMode: LongWord;
    WindowOrgEx, ViewPortOrgEx, BrushOrgEx: TPoint;
    WindowExtEx, ViewPortExtEx: TSize;
    Pen: TEnhMetaObj;
    Brush: TEnhMetaObj;
    Font: TEnhMetaObj;
    Palette: TEnhMetaObj;
    ColorSpace: TEnhMetaObj;
    ColorAdjustment: TEnhMetaObj;
    PositionCurrent, PositionNext: TPoint;
    BkMode: LongWord;
    MiterLimit: Single;
    BkColor: LongWord;
    TextColor: LongWord;
    SetRop2: LongWord;
    PolyFillMode: LongWord;
    ClipRgn: HRGN;
    EOFPalette: array of TColor;
    StretchMode: LongWord;
    IsPathBracketOpened: Boolean;
    TextAlignmentMode: LongWord;
    ICMMode: LongWord;
    XForm: TXForm;
    MapperFlags: LongWord;
    iArcDirection: LongWord;
  end;

  TEMFAbstractExport = class; {forward;}
  TEnhMetaObjArray = array of TEnhMetaObj;

  TDeviceContext = class
  private
    function GetLogPenStyle: LongWord;
    function GetPenType: LongWord;
    function GetPenStyle: LongWord;
    function GetPenEndCap: LongWord;
    function GetPenLineJoin: LongWord;
    function GetPenWidth: Extended;

    function GetMiterLimit: Single;
    function GetPenColor: TColor;

    function GetBrushColor: TColor;
    function GetBrushStyle: LongWord;
    function GetBrushHatch: LongWord;

    function GetTextColor: TColor;
    function GetFontFamily: string;
    function GetFontSize: Integer;
    function GetFontWeight: Integer;
    function GetFontItalic: Boolean;
    function GetFontStrikeOut: Boolean;
    function GetFontCharSet: byte;
    function GetFontUnderline: Boolean;
    function GetFontOrientation: integer;
    function GetFontRadian: Extended;
    function GetBkColor: TColor;
    function GetHAlign: TfrxHAlign;
    function GetVAlign: TfrxVAlign;
  protected
    FData: TDeviceContextData;

    procedure DeleteObject(ih: LongWord);
    procedure SelectObject(ih: LongWord; EnhMetaObjArray: TEnhMetaObjArray);
  public
    procedure CopyFrom(ADC: TObject); virtual;
    procedure Init; virtual;
    function IsXFormDefault: boolean;

    property ClipRgn: HRGN read FData.ClipRgn;
    property IsPathBracketOpened: Boolean read FData.IsPathBracketOpened;
    property Layout: LongWord read FData.Layout;
    property MapMode: LongWord read FData.MapMode;
    property PolyFillMode: LongWord read FData.PolyFillMode;
    property PositionCurrent: TPoint read FData.PositionCurrent;
    property PositionNext: TPoint read FData.PositionNext;
    property ICMMode: LongWord read FData.ICMMode;
    property MapperFlags: LongWord read FData.MapperFlags;
    property iArcDirection: LongWord read FData.iArcDirection;

    property LogPenStyle: LongWord read GetLogPenStyle;
    property PenType: LongWord read GetPenType;
    property PenStyle: LongWord read GetPenStyle;
    property PenEndCap: LongWord read GetPenEndCap;
    property PenLineJoin: LongWord read GetPenLineJoin;
    property PenWidth: Extended read GetPenWidth;
    property PenColor: TColor read GetPenColor;

    property MiterLimit: Single read GetMiterLimit;
    property SetRop2: LongWord read FData.SetRop2;
    property StretchMode: LongWord read FData.StretchMode;

    property TextAlignmentMode: LongWord read FData.TextAlignmentMode;
    property TextColor: TColor read GetTextColor;
    property BkColor: TColor read GetBkColor;
    property FontFamily: string read GetFontFamily;
    property FontSize: Integer read GetFontSize;
    property FontWeight: Integer read GetFontWeight;
    property FontItalic: Boolean read GetFontItalic;
    property FontCharSet: byte read GetFontCharSet;
    property FontUnderline: Boolean read GetFontUnderline;
    property FontStrikeOut: Boolean read GetFontStrikeOut;
    property FontOrientation: integer read GetFontOrientation; // specifies the angle, in tenths of degrees
    property FontRadian: Extended read GetFontRadian;

    property BrushColor: TColor read GetBrushColor;
    property BrushStyle: LongWord read GetBrushStyle;
    property BrushHatch: LongWord read GetBrushHatch;

    property BkMode: LongWord read FData.BkMode;

    property rTopLeft: TfrxPoint read FData.rTopLeft;
    property WindowOrgEx: TPoint read FData.WindowOrgEx;
    property ViewPortOrgEx: TPoint read FData.ViewPortOrgEx;
    property BrushOrgEx: TPoint read FData.BrushOrgEx;
    property WindowExtEx: TSize read FData.WindowExtEx;
    property ViewPortExtEx: TSize read FData.ViewPortExtEx;
    property XForm: TXForm read FData.XForm;

    property VAlign: TfrxVAlign read GetVAlign;
    property HAlign: TfrxHAlign read GetHAlign;
  end;

  PWideCharArray = ^TWideCharArray;
  TWideCharArray = array[0..0] of WideChar;

  TMemoExternalParams = record
    IsExternal: Boolean;
    Margins: TfrxRect;
    Width, Height: Extended;
    Shift: TfrxPoint;
  end;

  TEMFAbstractExport = class
  private
    FShowComments: Boolean;
    FFormatted: Boolean;
    FEnableTransform: Boolean;
    FParsing: WideString;
    FInStream: TStream;
    FLastRecord: TEMR;
    FDCList: TObjectList; // Device Context List

    procedure SetParsing(const Value: WideString);

    procedure ReadCurrentRecord;
    procedure PlayMetaCommand;
    procedure AddLastRecord;
    function ByteToHex(B: byte): string;
    procedure ReadEoFPalette;
    procedure ReadAlign;

    procedure TransformPoint(var DP: TfrxPoint);

    procedure Parse_Poly(Name: string);
    procedure Parse_Poly16(Name: string);
    procedure Parse_PolyPoly(Name: string);
    procedure Parse_PolyPoly16(Name: string);

    function CommentRect(Rect: TRect): string;
    function CommentPoint(Point: TPoint): string;

    function LogToDevX(LX: Extended): Extended;
    function LogToDevY(LY: Extended): Extended;
  protected
    FOutStream: TStream;
    FEMRList: TObjectList;
    FEMRLastCreated: TEnhMetaObjArray;
    FDC: TDeviceContext;

    FMEP: TMemoExternalParams;
    procedure CalcMemoExternalParams(Obj: TfrxView);

    procedure Comment(CommentString: string = ''); virtual; {Empty}

    function CommentArray(A: TLongWordArray): string; overload;
    function CommentArray(A: TIntegerArray): string; overload;
    function CommentArray(A: TDoubleArray; Prec: Integer = 1): string; overload;

    function PLast: PEnhMetaData;

    procedure DCCreate; virtual; {Empty}
    function FontCreate: TFont; virtual; // Must be overrided for Font.Size

    function LogToDevPoint(LP: TSmallPoint): TfrxPoint; overload;
    function LogToDevPoint(LP: TPoint): TfrxPoint; overload;
    function LogToDevPoint(LP: TfrxPoint): TfrxPoint; overload;
    function LogToDevPoint(X, Y: Extended): TfrxPoint; overload;

    function LogToDevRect(LR: TRect): TfrxRect;

    function LogToDevSizeX(Value: Extended): Extended;
    function LogToDevSizeY(Value: Extended): Extended;
    function LogToDevSize(Value: Extended): Extended;

    procedure DoEMR_AbortPath; virtual;
    procedure DoEMR_AlphaBlend; virtual;
    procedure DoEMR_AngleArc; virtual;
    procedure DoEMR_Arc; virtual;
    procedure DoEMR_ArcTo; virtual;
    procedure DoEMR_BeginPath; virtual;
    procedure DoEMR_BitBlt; virtual;
    procedure DoEMR_Chord; virtual;
    procedure DoEMR_CloseFigure; virtual;
    procedure DoEMR_ColorCorrectPalette; virtual;
    procedure DoEMR_ColorMatchToTargetW; virtual;
    procedure DoEMR_CreateBrushIndirect; virtual;
    procedure DoEMR_CreateColorSpace; virtual;
    procedure DoEMR_CreateColorSpaceW; virtual;
    procedure DoEMR_CreateDIBPatternBrushPt; virtual;
    procedure DoEMR_CreateMonoBrush; virtual;
    procedure DoEMR_CreatePalette; virtual;
    procedure DoEMR_CreatePen; virtual;
    procedure DoEMR_DeleteColorSpace; virtual;
    procedure DoEMR_DeleteObject; virtual;
    procedure DoEMR_DrawEscape; virtual;
    procedure DoEMR_Ellipse; virtual;
    procedure DoEMR_EndPath; virtual;
    procedure DoEMR_EoF; virtual;
    procedure DoEMR_ExcludeClipRect; virtual;
    procedure DoEMR_ExtCreateFontIndirectW; virtual;
    procedure DoEMR_ExtCreatePen; virtual;
    procedure DoEMR_ExtEscape; virtual;
    procedure DoEMR_ExtFloodFill; virtual;
    procedure DoEMR_ExtSelectClipRgn; virtual;
    procedure DoEMR_ExtTextOutA; virtual;
    procedure DoEMR_ExtTextOutW; virtual;
    procedure DoEMR_FillPath; virtual;
    procedure DoEMR_FillRgn; virtual;
    procedure DoEMR_FlattenPath; virtual;
    procedure DoEMR_ForceUFIMapping; virtual;
    procedure DoEMR_FrameRgn; virtual;
    procedure DoEMR_GDIComment; virtual;
    procedure DoEMR_GLSBoundedRecord; virtual;
    procedure DoEMR_GLSRecord; virtual;
    procedure DoEMR_GradientFill; virtual;
    procedure DoEMR_Header; virtual;
    procedure DoEMR_IntersectClipRect; virtual;
    procedure DoEMR_InvertRgn; virtual;
    procedure DoEMR_LineTo; virtual;
    procedure DoEMR_MaskBlt; virtual;
    procedure DoEMR_ModifyWorldTransform; virtual;
    procedure DoEMR_MoveToEx; virtual;
    procedure DoEMR_NamedEscape; virtual;
    procedure DoEMR_OffsetClipRgn; virtual;
    procedure DoEMR_PaintRgn; virtual;
    procedure DoEMR_Pie; virtual;
    procedure DoEMR_PixelFormat; virtual;
    procedure DoEMR_PLGBlt; virtual;
    procedure DoEMR_PolyBezier; virtual;
    procedure DoEMR_PolyBezier16; virtual;
    procedure DoEMR_PolyBezierTo; virtual;
    procedure DoEMR_PolyBezierTo16; virtual;
    procedure DoEMR_PolyDraw; virtual;
    procedure DoEMR_PolyDraw16; virtual;
    procedure DoEMR_Polygon; virtual;
    procedure DoEMR_Polygon16; virtual;
    procedure DoEMR_Polyline; virtual;
    procedure DoEMR_Polyline16; virtual;
    procedure DoEMR_PolylineTo; virtual;
    procedure DoEMR_PolylineTo16; virtual;
    procedure DoEMR_PolyPolygon; virtual;
    procedure DoEMR_PolyPolygon16; virtual;
    procedure DoEMR_PolyPolyline; virtual;
    procedure DoEMR_PolyPolyline16; virtual;
    procedure DoEMR_PolyTextOutA; virtual;
    procedure DoEMR_PolyTextOutW; virtual;
    procedure DoEMR_RealizePalette; virtual;
    procedure DoEMR_Rectangle; virtual;
    procedure DoEMR_Reserved_69; virtual;
    procedure DoEMR_ResizePalette; virtual;
    procedure DoEMR_RestoreDC; virtual;
    procedure DoEMR_RoundRect; virtual;
    procedure DoEMR_SaveDC; virtual;
    procedure DoEMR_ScaleViewportExtEx; virtual;
    procedure DoEMR_ScaleWindowExtEx; virtual;
    procedure DoEMR_SelectClipPath; virtual;
    procedure DoEMR_SelectObject; virtual;
    procedure DoEMR_SelectPalette; virtual;
    procedure DoEMR_SetArcDirection; virtual;
    procedure DoEMR_SetBkColor; virtual;
    procedure DoEMR_SetBkMode; virtual;
    procedure DoEMR_SetBrushOrgEx; virtual;
    procedure DoEMR_SetColorSpace; virtual;
    procedure DoEMR_SetColorAdjustment; virtual;
    procedure DoEMR_SetDIBitsToDevice; virtual;
    procedure DoEMR_SetICMMode; virtual;
    procedure DoEMR_SetIcmProfileA; virtual;
    procedure DoEMR_SetIcmProfileW; virtual;
    procedure DoEMR_SetLayout; virtual;
    procedure DoEMR_SetLinkedUFIs; virtual;
    procedure DoEMR_SetMapMode; virtual;
    procedure DoEMR_SetMapperFlags; virtual;
    procedure DoEMR_SetMetaRgn; virtual;
    procedure DoEMR_SetMiterLimit; virtual;
    procedure DoEMR_SetPaletteEntries; virtual;
    procedure DoEMR_SetPixelV; virtual;
    procedure DoEMR_SetPolyFillMode; virtual;
    procedure DoEMR_SetRop2; virtual;
    procedure DoEMR_SetStretchBltMode; virtual;
    procedure DoEMR_SetTextAlign; virtual;
    procedure DoEMR_SetTextColor; virtual;
    procedure DoEMR_SetTextJustification; virtual;
    procedure DoEMR_SetViewPortExtEx; virtual;
    procedure DoEMR_SetViewPortOrgEx; virtual;
    procedure DoEMR_SetWindowExtEx; virtual;
    procedure DoEMR_SetWindowOrgEx; virtual;
    procedure DoEMR_SetWorldTransform; virtual;
    procedure DoEMR_SmallTextOut; virtual;
    procedure DoEMR_StartDoc; virtual;
    procedure DoEMR_StretchBlt; virtual;
    procedure DoEMR_StretchDIBits; virtual;
    procedure DoEMR_StrokeAndFillPath; virtual;
    procedure DoEMR_StrokePath; virtual;
    procedure DoEMR_TransparentBlt; virtual;
    procedure DoEMR_TransparentDIB; virtual;
    procedure DoEMR_WidenPath; virtual;

    procedure DoStart; virtual; {Empty}
    procedure DoFinish; virtual; {Empty}
    procedure DoUnknown; virtual;
  public
    constructor Create(InStream, OutStream: TStream);
    destructor Destroy; override;
    procedure PlayMetaFile;

    property ShowComments: Boolean read FShowComments write FShowComments;
    property Formatted: Boolean read FFormatted write FFormatted;
    property Parsing: WideString read FParsing write SetParsing;
    property EnableTransform: Boolean read FEnableTransform write FEnableTransform;
  end;

implementation (***************************************************************)

uses
  SysUtils, Types, Math,
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  frxExportHelpers;

const
  Dlm = '    ';
  Etc = Dlm + 'etc.';
  CRLF = #13#10;
  XFormDefault: TXForm =
    (eM11: 1.0; eM12: 0.0; eM21: 0.0; eM22: 1.0; eDx: 0.0; eDy: 0.0);
  FragmentDefaultSize = 1024;

const
  CreatePenSet = [EMR_CreatePen, EMR_ExtCreatePen];
  CreateBrushSet = [EMR_CreateBrushIndirect, EMR_CreateMonoBrush, EMR_CreateDIBPatternBrushPt];
  CreateFontSet = [EMR_ExtCreateFontIndirectW];
  CreatePaletteSet = [EMR_CreatePalette];
  CreateColorSpaceSet = [EMR_CreateColorSpace, EMR_CreateColorSpaceW];
  CreateObjSet = CreatePenSet + CreateBrushSet + CreateFontSet +
                 CreatePaletteSet + CreateColorSpaceSet;

type
  TQuickWideFragment = class
  private
    FText: WideString;
    FCount: Integer;
    function GetText: WideString;
  public
    constructor Create(MaxSize: integer = FragmentDefaultSize);
    procedure AddWide(s: WideString); overload;
    procedure AddWide(const Fmt: string; const Args: array of const); overload;
    procedure CutBy(Size: Integer);

    property Text: WideString read GetText;
  end;

{ Utility routines }


function WideStringFromArray(PW: PWideCharArray; MaxSize: integer): WideString;
var
  i: integer;
begin
  Result := '';
  for i := 0 to MaxSize - 1 do
    if PW^[i] = #0 then
      Break
    else
      Result := Result + PW^[i];
end;

{ TEMFAbstractExport }

procedure TEMFAbstractExport.AddLastRecord;
begin
  FEMRList.Add(TEnhMetaObj.Create(FInStream, FLastRecord.nSize));
end;

function TEMFAbstractExport.ByteToHex(B: byte): string;
const
  ByteHex: array[0..15] of char =
    ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
begin
  Result := ByteHex[B shr 4] + ByteHex[B and $0F];
end;

procedure TEMFAbstractExport.CalcMemoExternalParams(Obj: TfrxView);
var
  Memo: TfrxCustomMemoView;
begin
  FMEP.IsExternal := False;
  if Obj is TfrxCustomMemoView then
  begin
    Memo := TfrxCustomMemoView(Obj);
    FMEP.IsExternal := not Memo.Clipped and (Memo.Page <> nil) and (Memo.Page is TfrxReportPage);
    if FMEP.IsExternal then
      with TfrxReportPage(Memo.Page) do
      begin
        FMEP.Margins := frxRect(LeftMargin, TopMargin, RightMargin, BottomMargin);
        FMEP.Width := Width;
        FMEP.Height := Height;
        FMEP.Shift := frxPoint(Obj.AbsLeft, Obj.AbsTop);
      end;
  end;
end;

procedure TEMFAbstractExport.Comment(CommentString: string = '');
begin
// Empty
end;

function TEMFAbstractExport.CommentArray(A: TDoubleArray; Prec: Integer): string;
var
  i: Integer;
begin
  with TQuickWideFragment.Create do
  begin
    for i := 0 to High(A) do
      AddWide(frFloat2Str(A[i], Prec) + ' ');
    CutBy(1);
    Result := Text;
    Free;
  end;
end;

function TEMFAbstractExport.CommentArray(A: TIntegerArray): string;
var
  i: Integer;
begin
  with TQuickWideFragment.Create do
  begin
    for i := 0 to High(A) do
      AddWide(IntToStr(A[i]) + ' ');
    CutBy(1);
    Result := Text;
    Free;
  end;
end;

function TEMFAbstractExport.CommentArray(A: TLongWordArray): string;
var
  i: Integer;
begin
  with TQuickWideFragment.Create do
  begin
    for i := 0 to High(A) do
      AddWide(IntToStr(A[i]) + ' ');
    CutBy(1);
    Result := Text;
    Free;
  end;
end;

function TEMFAbstractExport.CommentPoint(Point: TPoint): string;
begin
  with Point do
    Result := Format('%d, %d', [X, Y]);
end;

function TEMFAbstractExport.CommentRect(Rect: TRect): string;
begin
  with Rect do
    Result := Format('%d, %d, %d, %d', [Left, Top, Right, Bottom]);
end;

constructor TEMFAbstractExport.Create(InStream, OutStream: TStream);
begin
  ShowComments := False;
  EnableTransform := True;

  FInStream := InStream;
  FOutStream := OutStream;

  FFormatted := True;
  FLastRecord.iType := 0;
  FEMRList := TObjectList.Create;
  FDCList := TObjectList.Create;
  FDCList.OwnsObjects := False;

  DCCreate;
  FDC.Init;

  FMEP.IsExternal := False;
end;

procedure TEMFAbstractExport.DCCreate;
begin
  // Empty
end;

destructor TEMFAbstractExport.Destroy;
begin
  FEMRList.Free;
  FDCList.Free;
  FDC.Free;
  inherited;
end;

procedure TEMFAbstractExport.DoEMR_AbortPath;
begin
  AddLastRecord;

  FDC.FData.IsPathBracketOpened := False;

  Parsing := 'EMR_AbortPath';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_AlphaBlend;
begin
  FEMRList.Add(TEMRAlphaBlendObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_AlphaBlend' + Dlm +
      Format('rclBounds: %s', [CommentRect(AlphaBlend.rclBounds)]) + Dlm +
      Format('xDest: %d', [AlphaBlend.xDest]) + Dlm +
      Format('yDest: %d', [AlphaBlend.yDest]) + Dlm +
      Format('cxDest: %d', [AlphaBlend.cxDest]) + Dlm +
      Format('cyDest: %d', [AlphaBlend.cyDest]) + Dlm +
      Format('dwRop: %u', [AlphaBlend.dwRop]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_AngleArc;
begin
  AddLastRecord;

  with PLast^.AngleArc do
    Parsing := 'EMR_AngleArc' + Dlm +
      Format('ptlCenter: %d, %d', [ptlCenter.X, ptlCenter.Y]) + Dlm +
      Format('nRadius: %u', [nRadius]) + Dlm +
      Format('eStartAngle: %.3g', [eStartAngle]) + Dlm +
      Format('eSweepAngle: %.3g', [eSweepAngle]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Arc;
begin
  AddLastRecord;

  with PLast^.Arc do
    Parsing := 'EMR_Arc' + Dlm +
      Format('rclBox: %s', [CommentRect(PLast^.Arc.rclBox)]) + Dlm +
      Format('ptlStart: %d, %d', [ptlStart.X, ptlStart.Y]) + Dlm +
      Format('ptlEnd: %d, %d', [ptlEnd.X, ptlEnd.Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ArcTo;
begin
  AddLastRecord;

  FDC.FData.PositionNext := PLast^.ArcTo.ptlEnd;

  with PLast^.ArcTo do
    Parsing := 'EMR_ArcTo' + Dlm +
      Format('rclBox: %s', [CommentRect(PLast^.Arc.rclBox)]) + Dlm +
      Format('ptlStart: %d, %d', [ptlStart.X, ptlStart.Y]) + Dlm +
      Format('ptlEnd: %d, %d', [ptlEnd.X, ptlEnd.Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_BeginPath;
begin
  AddLastRecord;

  FDC.FData.IsPathBracketOpened := True;

  Parsing := 'EMR_BeginPath';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_BitBlt;
begin
  FEMRList.Add(TEMRBitBltObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_BitBlt' + Dlm +
      Format('rclBounds: %s', [CommentRect(BitBlt.rclBounds)]) + Dlm +
      Format('xDest: %d', [BitBlt.xDest]) + Dlm +
      Format('yDest: %d', [BitBlt.yDest]) + Dlm +
      Format('cxDest: %d', [BitBlt.cxDest]) + Dlm +
      Format('cyDest: %d', [BitBlt.cyDest]) + Dlm +
      Format('dwRop: %u', [BitBlt.dwRop]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Chord;
begin
  AddLastRecord;

  with PLast^.Chord do
    Parsing := 'EMR_Chord' + Dlm +
      Format('rclBox: %s', [CommentRect(PLast^.Arc.rclBox)]) + Dlm +
      Format('ptlStart: %d, %d', [ptlStart.X, ptlStart.Y]) + Dlm +
      Format('ptlEnd: %d, %d', [ptlEnd.X, ptlEnd.Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_CloseFigure;
begin
  AddLastRecord;

  Parsing := 'EMR_CloseFigure';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ColorCorrectPalette;
begin
  AddLastRecord;

  with PLast^ do
    Parsing := 'EMR_ColorCorrectPalette' + Dlm +
      Format('ihPalette: %u', [ColorCorrectPalette.ihPalette]) + Dlm +
      Format('nFirstEntry: %u', [ColorCorrectPalette.nFirstEntry]) + Dlm +
      Format('nPalEntries: %u', [ColorCorrectPalette.nPalEntries]) + Dlm +
      Format('nReserved: %u', [ColorCorrectPalette.nReserved]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ColorMatchToTargetW;
begin
  AddLastRecord;

  Parsing := 'EMR_ColorMatchToTargetW' + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_CreateBrushIndirect;
begin
  AddLastRecord;
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^ do
    Parsing := 'EMR_CreateBrushIndirect' + Dlm +
      Format('ihBrush: %u', [CreateBrushIndirect.ihBrush]) + Dlm +
      Format('lb.lbStyle: %u', [CreateBrushIndirect.lb.lbStyle]) + Dlm +
      Format('lb.lbColor: %u', [CreateBrushIndirect.lb.lbColor]) + Dlm +
      Format('lb.lbHatch: %u', [CreateBrushIndirect.lb.lbHatch]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_CreateColorSpace;
begin
  AddLastRecord;
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^.CreateColorSpace do
    Parsing := 'EMR_CreateColorSpace' + Dlm +
      Format('ihCS: %u', [ihCS]) + Dlm +
      Format('lcs.lcsSignature: %u', [lcs.lcsSignature]) + Dlm +
      Format('lcs.lcsVersion: %u', [lcs.lcsVersion]) + Dlm +
      Format('lcs.lcsSize: %u', [lcs.lcsSize]) + Dlm +
      Format('lcs.lcsCSType: %d', [lcs.lcsCSType]) + Dlm +
      Format('lcs.lcsIntent: %d', [lcs.lcsIntent]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_CreateColorSpaceW;
begin
  AddLastRecord;
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^.CreateColorSpaceW do
    Parsing := 'EMR_CreateColorSpaceW' + Dlm +
      Format('ihCS: %u', [ihCS]) + Dlm +
      Format('lcs.lcsSignature: %u', [lcs.lcsSignature]) + Dlm +
      Format('lcs.lcsVersion: %u', [lcs.lcsVersion]) + Dlm +
      Format('lcs.lcsSize: %u', [lcs.lcsSize]) + Dlm +
      Format('lcs.lcsCSType: %d', [lcs.lcsCSType]) + Dlm +
      Format('lcs.lcsIntent: %d', [lcs.lcsIntent]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_CreateDIBPatternBrushPt;
begin
  FEMRList.Add(TEMRCreateDIBPatternBrushPtObj.Create(FInStream, FLastRecord.nSize));
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^ do
    Parsing := 'EMR_CreateDIBPatternBrushPt' + Dlm +
      Format('ihBrush: %u', [CreateDIBPatternBrushPt.ihBrush]) + Dlm +
      Format('iUsage: %u', [CreateDIBPatternBrushPt.iUsage]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_CreateMonoBrush;
begin
  FEMRList.Add(TEMRCreateMonoBrushObj.Create(FInStream, FLastRecord.nSize));
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^ do
    Parsing := 'EMR_CreateMonoBrush' + Dlm +
      Format('ihBrush: %u', [CreateMonoBrush.ihBrush]) + Dlm +
      Format('iUsage: %u', [CreateMonoBrush.iUsage]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_CreatePalette;
var
  i: Integer;
begin
  AddLastRecord;
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^.CreatePalette do
  begin
    Parsing := 'EMR_CreatePalette' + Dlm +
      Format('ihPal: %u', [ihPal]) + Dlm +
      Format('lgpl.palVersion: %u', [lgpl.palVersion]) + Dlm +
      Format('lgpl.palNumEntries: %u', [lgpl.palNumEntries]);
    if lgpl.palNumEntries > 0 then
      with TQuickWideFragment.Create do
      begin
        for i := 0 to lgpl.palNumEntries - 1 do
          AddWide(Dlm + '%u: %u', [i, LongWord(lgpl.palPalEntry[i])]);
        Parsing := Parsing + Text;
        Free;
      end;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_CreatePen;
begin
  AddLastRecord;
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^ do
    Parsing := 'EMR_CreatePen' + Dlm +
      Format('ihPen: %u', [CreatePen.ihPen]) + Dlm +
      Format('lopn.lopnStyle: %u', [CreatePen.lopn.lopnStyle]) + Dlm +
      Format('lopn.lopnWidth.X: %d', [CreatePen.lopn.lopnWidth.X]) + Dlm +
      Format('lopn.lopnColor: %u', [CreatePen.lopn.lopnColor]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_DeleteColorSpace;
begin
  AddLastRecord;

  FDC.DeleteObject(PLast^.DeleteColorSpace.ihCS);

  Parsing := 'EMR_DeleteColorSpace' + Dlm +
    Format('ihCS: %u', [PLast^.DeleteColorSpace.ihCS]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_DeleteObject;
begin
  AddLastRecord;

  FDC.DeleteObject(PLast^.DeleteObject.ihObject);

  Parsing := 'EMR_DeleteObject' + Dlm +
    Format('ihObject: %u', [PLast^.DeleteObject.ihObject]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_DrawEscape;
begin
  AddLastRecord;

  Parsing := 'EMR_DrawEscape' + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Ellipse;
begin
  AddLastRecord;

  Parsing := 'EMR_Ellipse' + Dlm +
    Format('rclBox: %s', [CommentRect(PLast^.Ellipse.rclBox)]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_EndPath;
begin
  AddLastRecord;

  FDC.FData.IsPathBracketOpened := False;

  Parsing := 'EMR_EndPath';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_EoF;
var
  i: Integer;
begin
  FEMRList.Add(TEoFObj.Create(FInStream, FLastRecord.nSize));

  with FEMRList.Last as TEoFObj do
  begin
    Parsing := 'EMR_EoF' + Dlm +
      Format('nPalEntries: %u', [P^.EoF.nPalEntries]) + Dlm +
      Format('offPalEntries: %u', [P^.EoF.offPalEntries]);
    if P^.EoF.nPalEntries > 0 then
      with TQuickWideFragment.Create do
      begin
        for i := 0 to P^.EoF.nPalEntries - 1 do
          AddWide(Dlm + '%u: %u', [i, LongWord(PaletteEntry[i])]);
        Parsing := Parsing + Text;
        Free;
      end;
    Parsing := Parsing + Dlm + Format('nSizeLast: %u', [nSizeLast]);
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ExcludeClipRect;
var
  RectRGN, RgnDest: HRGN;
begin
  AddLastRecord;

  with PLast^.IntersectClipRect do
    if FDC.ClipRgn <> HRGN(nil) then
    begin
      RgnDest := CreateRectRgn(0, 0, 0, 0);
      RectRGN := CreateRectRgnIndirect(rclClip);
      RgnDest := CombineRgn(RgnDest, FDC.FData.ClipRgn, RectRGN, RGN_DIFF);
      FDC.FData.ClipRgn := RgnDest;
    end;

  Parsing := 'EMR_ExcludeClipRect' + Dlm +
    Format('rclClip: %s', [CommentRect(PLast^.IntersectClipRect.rclClip)]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ExtCreateFontIndirectW;
begin
  AddLastRecord;
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^.ExtCreateFontIndirectW do
  begin
    Parsing := 'EMR_ExtCreateFontIndirectW' + Dlm +
      Format('ihFont: %u', [ihFont]) + Dlm +
      Format('elfw.elfLogFont.lfHeight: %d', [elfw.elfLogFont.lfHeight]) + Dlm +
      Format('elfw.elfLogFont.lfWidth: %d', [elfw.elfLogFont.lfWidth]) + Dlm +
      Format('elfw.elfLogFont.lfEscapement: %d', [elfw.elfLogFont.lfEscapement]) + Dlm +
      Format('elfw.elfLogFont.lfOrientation: %d', [elfw.elfLogFont.lfOrientation]) + Dlm +
      Format('elfw.elfLogFont.lfWeight: %d', [elfw.elfLogFont.lfWeight]) + Dlm +
      Format('elfw.elfLogFont.lfItalic: %u', [elfw.elfLogFont.lfItalic]) + Dlm +
      Format('elfw.elfLogFont.lfUnderline: %u', [elfw.elfLogFont.lfUnderline]) + Dlm +
      Format('elfw.elfLogFont.lfStrikeOut: %u', [elfw.elfLogFont.lfStrikeOut]) + Dlm +
      Format('elfw.elfLogFont.lfCharSet: %u', [elfw.elfLogFont.lfCharSet]) + Dlm +
      Format('elfw.elfLogFont.lfOutPrecision: %u', [elfw.elfLogFont.lfOutPrecision]) + Dlm +
      Format('elfw.elfLogFont.lfClipPrecision: %u', [elfw.elfLogFont.lfClipPrecision]) + Dlm +
      Format('elfw.elfLogFont.lfQuality: %u', [elfw.elfLogFont.lfQuality]) + Dlm +
      Format('elfw.elfLogFont.lfPitchAndFamily: %u', [elfw.elfLogFont.lfPitchAndFamily]) + Dlm +
      Format('elfw.elfLogFont.lfFaceName: %s', [WideStringFromArray(Addr(elfw.elfLogFont.lfFaceName), LF_FACESIZE)]);
    if emr.nSize - 12 > 320  then // https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-emf/7e266b6d-32e5-4201-b687-8ec40c24cd73
      Parsing := Parsing + Dlm +
        Format('elfw.elfFullName: %s', [WideStringFromArray(Addr(elfw.elfFullName), LF_FULLFACESIZE)]) + Dlm +
        Format('elfw.elfStyle: %s', [WideStringFromArray(Addr(elfw.elfStyle), LF_FACESIZE)]);
    Parsing := Parsing + Etc;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ExtCreatePen;
var
  i: Integer;
begin
  FEMRList.Add(TEMRExtCreatePenObj.Create(FInStream, FLastRecord.nSize));
  FEMRLastCreated[PLast^.SelectObject.ihObject] := TEnhMetaObj(FEMRList.Last);

  with PLast^ do
  begin
    Parsing := 'EMR_ExtCreatePen' + Dlm +
      Format('ihPen: %u', [ExtCreatePen.ihPen]) + Dlm +
      Format('offBmi: %u', [ExtCreatePen.offBmi]) + Dlm +
      Format('cbBmi: %u', [ExtCreatePen.cbBmi]) + Dlm +
      Format('offBits: %u', [ExtCreatePen.offBits]) + Dlm +
      Format('cbBits: %u', [ExtCreatePen.cbBits]) + Dlm +
      Format('elp.elpPenStyle: %u', [ExtCreatePen.elp.elpPenStyle]) + Dlm +
      Format('elp.elpWidth: %u', [ExtCreatePen.elp.elpWidth]) + Dlm +
      Format('elp.elpBrushStyle: %u', [ExtCreatePen.elp.elpBrushStyle]) + Dlm +
      Format('elp.elpColor: %u', [ExtCreatePen.elp.elpColor]) + Dlm +
      Format('elp.elpHatch: %u', [ExtCreatePen.elp.elpHatch]) + Dlm +
      Format('elp.elpNumEntries: %u', [ExtCreatePen.elp.elpNumEntries]);
      if ExtCreatePen.elp.elpNumEntries > 0 then
        for i := 0 to ExtCreatePen.elp.elpNumEntries - 1 do
          Parsing := Parsing + Dlm + Format('%u: %u',
            [i, ExtCreatePen.elp.elpStyleEntry[i]]);
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ExtEscape;
begin
  AddLastRecord;

  Parsing := 'EMR_ExtEscape' + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ExtFloodFill;
begin
  AddLastRecord;

  with PLast^.ExtFloodFill do
    Parsing := 'EMR_ExtFloodFill' + Dlm +
      Format('ptlStart: %d, %d', [ptlStart.X, ptlStart.Y]) + Dlm +
      Format('crColor: %u', [crColor]) + Dlm +
      Format('iMode: %u', [iMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ExtSelectClipRgn;
var
  i: integer;
  RgnSrc, RgnDest: HRGN;
begin
  FEMRList.Add(TEMRExtSelectClipRgnObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_ExtSelectClipRgn' + Dlm +
      Format('cbRgnData: %u', [ExtSelectClipRgn.cbRgnData]) + Dlm +
      Format('iMode: %u', [ExtSelectClipRgn.iMode]) + Dlm;

  with PLast^ do
    if ExtSelectClipRgn.cbRgnData = 0 then
      FDC.FData.ClipRgn := HRGN(nil)
    else
    begin
      RgnSrc := ExtCreateRegion(nil, ExtSelectClipRgn.cbRgnData,
                PRgnData(Addr(ExtSelectClipRgn.RgnData))^);
      if FDC.ClipRgn = HRGN(nil) then
        FDC.FData.ClipRgn := RgnSrc
      else
      begin
        RgnDest := CreateRectRgn(0, 0, 0, 0);
        CombineRgn(RgnDest,  RgnSrc, FDC.FData.ClipRgn, ExtSelectClipRgn.iMode);
        FDC.FData.ClipRgn := RgnDest;
      end;

    with FEMRList.Last as TEMRExtSelectClipRgnObj do
    begin
      Parsing := Parsing +
        Format('nCount: %u', [PRegionData^.rdh.nCount]);
      with TQuickWideFragment.Create do
      begin
        for i := 0 to PRegionData^.rdh.nCount - 1 do
          AddWide(Dlm + '%u: %s', [i, CommentRect(Region[i])]);
        Parsing := Parsing + Text;
        Free;
      end;
    end;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ExtTextOutA;
var
  EMRExtTextOutAObj: TEMRExtTextOutAObj;
begin
  EMRExtTextOutAObj := TEMRExtTextOutAObj.Create(FInStream, FLastRecord.nSize);
  FEMRList.Add(EMRExtTextOutAObj);

  with PLast^.ExtTextOutA do
  begin
    Parsing := 'EMR_ExtTextOutA' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('iGraphicsMode: %u', [iGraphicsMode]) + Dlm +
      Format('exScale: %.3g', [exScale]) + Dlm +
      Format('eyScale: %.3g', [eyScale]) + Dlm +
      Format('emrtext.ptlReference: %s', [CommentPoint(emrtext.ptlReference)]) + Dlm +
      Format('emrtext.nChars: %u', [emrtext.nChars]) + Dlm +
      Format('emrtext.offString: %u', [emrtext.offString]) + Dlm +
      Format('emrtext.fOptions: %u', [emrtext.fOptions]) + Dlm +
      Format('emrtext.rcl: %s', [CommentRect(emrtext.rcl)]) + Dlm +
      Format('emrtext.offDx: %u', [emrtext.offDx]) + Dlm +
      Format('OutputString: %s',
             [(FEMRList.Last as TEMRExtTextOutAObj).OutputString]) + Dlm;

    Parsing := Parsing + 'Dx: ' + CommentArray(EMRExtTextOutAObj.OutputDx);
    if EMRExtTextOutAObj.IsOption(ETO_PDY) then
      Parsing := Parsing + 'Dy: ' + CommentArray(EMRExtTextOutAObj.OutputDy);
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ExtTextOutW;
var
  EMRExtTextOutWObj: TEMRExtTextOutWObj;
begin
  EMRExtTextOutWObj := TEMRExtTextOutWObj.Create(FInStream, FLastRecord.nSize);
  FEMRList.Add(EMRExtTextOutWObj);

  with PLast^.ExtTextOutW do
  begin
    Parsing := 'EMR_ExtTextOutW' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('iGraphicsMode: %u', [iGraphicsMode]) + Dlm +
      Format('exScale: %.3g', [exScale]) + Dlm +
      Format('eyScale: %.3g', [eyScale]) + Dlm +
      Format('emrtext.ptlReference: %s', [CommentPoint(emrtext.ptlReference)]) + Dlm +
      Format('emrtext.nChars: %u', [emrtext.nChars]) + Dlm +
      Format('emrtext.offString: %u', [emrtext.offString]) + Dlm +
      Format('emrtext.fOptions: %u', [emrtext.fOptions]) + Dlm +
      Format('emrtext.rcl: %s', [CommentRect(emrtext.rcl)]) + Dlm +
      Format('emrtext.offDx: %u', [emrtext.offDx]) + Dlm +
      Format('OutputString: %s',
        [(FEMRList.Last as TEMRExtTextOutWObj).OutputString(FDC.FontFamily)]) + Dlm;

    Parsing := Parsing + 'Dx: ' + CommentArray(EMRExtTextOutWObj.OutputDx);
    if EMRExtTextOutWObj.IsOption(ETO_PDY) then
      Parsing := Parsing + 'Dy: ' + CommentArray(EMRExtTextOutWObj.OutputDy);
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_FillPath;
begin
  AddLastRecord;

  Parsing := 'EMR_FillPath' + Dlm +
    Format('rclBounds: %s', [CommentRect(PLast^.FillPath.rclBounds)]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_FillRgn;
begin
  AddLastRecord;

  with PLast^.FillRgn do
    Parsing := 'EMR_FillRgn' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('cbRgnData: %u', [cbRgnData]) + Dlm +
      Format('ihBrush: %u', [ihBrush]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_FlattenPath;
begin
  AddLastRecord;

  Parsing := 'EMR_FlattenPath';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ForceUFIMapping;
begin
  AddLastRecord;

  with PLast^ do
    Parsing := 'EMR_ForceUFIMapping' + Dlm +
      Format('Checksum: %u', [ForceUFIMapping.Checksum]) + Dlm +
      Format('Index: %u', [ForceUFIMapping.Index]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_FrameRgn;
begin
  AddLastRecord;

  with PLast^.FrameRgn do
    Parsing := 'EMR_FrameRgn' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('cbRgnData: %u', [cbRgnData]) + Dlm +
      Format('ihBrush: %u', [ihBrush]) + Dlm +
      Format('szlStroke: %u, %u', [szlStroke.cx, szlStroke.cy]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_GDIComment;
var
  i: integer;
begin
  AddLastRecord;

  Parsing := 'EMR_GDIComment' + Dlm +
    Format('cbData: %u', [PLast^.GDIComment.cbData]) + Dlm + 'Data:';
  with PLast^ do
    with TQuickWideFragment.Create do
    begin
      for i := 0 to GDIComment.cbData - 1 do
        AddWide(ByteToHex(GDIComment.Data[i]));
      Parsing := Parsing + Text;
      Free;
    end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_GLSBoundedRecord;
var
  i: integer;
begin
  AddLastRecord;

  with PLast^ do
    Parsing := 'EMR_GLSBoundedRecord' + Dlm +
      Format('rclBounds: %s', [CommentRect(GLSBoundedRecord.rclBounds)]) + Dlm +
      Format('cbData: %u', [GLSBoundedRecord.cbData]) + Dlm + 'Data:';
  with PLast^ do
    with TQuickWideFragment.Create do
    begin
      for i := 0 to GLSBoundedRecord.cbData - 1 do
        AddWide(ByteToHex(GLSBoundedRecord.Data[i]));
      Parsing := Parsing + Text;
      Free;
    end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_GLSRecord;
var
  i: integer;
begin
  AddLastRecord;

  Parsing := 'EMR_GLSRecord' + Dlm +
    Format('cbData: %u', [PLast^.GLSRecord.cbData]) + Dlm + 'Data:';
  with PLast^ do
    with TQuickWideFragment.Create do
    begin
      for i := 0 to GLSRecord.cbData - 1 do
        AddWide(ByteToHex(GLSRecord.Data[i]));
      Parsing := Parsing + Text;
      Free;
    end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_GradientFill;
begin
  AddLastRecord;

  with PLast^.GradientFill do
    Parsing := 'EMR_GradientFill' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('nVer: %u', [nVer]) + Dlm +
      Format('nTri: %u', [nTri]) + Dlm +
      Format('ulMode: %u', [ulMode]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Header;
var
  i: Integer;
begin
  FEMRList.Add(TEnhMetaHeaderObj.Create(FInStream, FLastRecord.nSize));

  with PLast^.Header do
  begin
    SetLength(FEMRLastCreated, nHandles);
    for i := Low(FEMRLastCreated) to High(FEMRLastCreated) do
      FEMRLastCreated[i] := nil;

    FDC.FData.rTopLeft.X := szlDevice.cx / szlMillimeters.cx * rclFrame.Left / 100;
    FDC.FData.rTopLeft.Y := szlDevice.cy / szlMillimeters.cy * rclFrame.Top / 100;
  end;
  if PLast^.Header.nPalEntries > 0 then
    ReadEOFPalette;

  with FEMRList.Last as TEnhMetaHeaderObj do
  begin
    Parsing := 'EMR_Header' + Dlm +
      Format('rclBounds: %s', [CommentRect(P^.Header.rclBounds)]) + Dlm +
      Format('rclFrame: %s', [CommentRect(P^.Header.rclFrame)]) + Dlm +
      Format('nRecords: %u', [P^.Header.nRecords]) + Dlm +
      Format('nHandles: %u', [P^.Header.nHandles]) + Dlm +
      Format('Description: %s', [Description]) + Dlm +
      Format('nPalEntries: %u', [P^.Header.nPalEntries]) + Dlm;
    with P^.Header.szlDevice do
      Parsing := Parsing +
        Format('szlDevice: %u, %u', [cx, cy]) + Dlm;
    with P^.Header.szlMillimeters do
      Parsing := Parsing +
        Format('szlMillimeters: %u, %u', [cx, cy]);
    if Extension <> ehOriginal then
    begin
      Parsing := Parsing + Dlm +
        Format('cbPixelFormat: %u', [P^.Header.cbPixelFormat]) + Dlm +
        Format('bOpenGL: %u', [P^.Header.bOpenGL]);
    end;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_IntersectClipRect;
var
  RectRGN, RgnDest: HRGN;
begin
  AddLastRecord;

  with PLast^.IntersectClipRect do
    if FDC.ClipRgn <> HRGN(nil) then
    begin
      RgnDest := CreateRectRgn(0, 0, 0, 0);
      RectRGN := CreateRectRgnIndirect(rclClip);
      RgnDest := CombineRgn(RgnDest, FDC.FData.ClipRgn, RectRGN, RGN_AND);
      FDC.FData.ClipRgn := RgnDest;
    end;

  Parsing := 'EMR_IntersectClipRect' + Dlm +
    Format('rclClip: %s', [CommentRect(PLast^.IntersectClipRect.rclClip)]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_InvertRgn;
begin
  AddLastRecord;

  with PLast^.InvertRgn do
    Parsing := 'EMR_InvertRgn' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('cbRgnData: %u', [cbRgnData]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_LineTo;
begin
  AddLastRecord;

  FDC.FData.PositionNext := PLast^.LineTo.ptl;

  with PLast^.LineTo.ptl do
    Parsing := 'EMR_LineTo' + Dlm +
      Format('ptl: %d, %d', [X, Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_MaskBlt;
begin
  FEMRList.Add(TEMRMaskBltObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_MaskBlt' + Dlm +
      Format('rclBounds: %s', [CommentRect(MaskBlt.rclBounds)]) + Dlm +
      Format('xDest: %d', [MaskBlt.xDest]) + Dlm +
      Format('yDest: %d', [MaskBlt.yDest]) + Dlm +
      Format('cxDest: %d', [MaskBlt.cxDest]) + Dlm +
      Format('cyDest: %d', [MaskBlt.cyDest]) + Dlm +
      Format('dwRop: %u', [MaskBlt.dwRop]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ModifyWorldTransform;

  function Multiply(XF1, XF2: TXForm): TXForm;
  begin
    Result.eM11 := XF1.eM11 * XF2.eM11 + XF1.eM12  * XF2.eM21;
    Result.eM12 := XF1.eM11 * XF2.eM12 + XF1.eM12  * XF2.eM22;
    Result.eM21 := XF1.eM21 * XF2.eM11 + XF1.eM22  * XF2.eM21;
    Result.eM22 := XF1.eM21 * XF2.eM12 + XF1.eM22  * XF2.eM22;
    Result.eDx := XF1.eDx * XF2.eM11 + XF1.eDy * XF2.eM21 + XF2.eDx;
    Result.eDy := XF1.eDx * XF2.eM12 + XF1.eDy * XF2.eM22 + XF2.eDy;
  end;
begin
  AddLastRecord;

  with PLast^ do
    case ModifyWorldTransform.iMode of
      MWT_IDENTITY:
        FDC.FData.XForm := XFormDefault;
      MWT_LEFTMULTIPLY:
        FDC.FData.XForm := Multiply(ModifyWorldTransform.xform, FDC.XForm);
      MWT_RIGHTMULTIPLY:
        FDC.FData.XForm := Multiply(FDC.XForm, ModifyWorldTransform.xform);
      MWT_SET:
        FDC.FData.XForm := ModifyWorldTransform.xform;
  end;

  with PLast^.ModifyWorldTransform do
    Parsing := 'EMR_ModifyWorldTransform' + Dlm +
      Format('xform.eM11: %.3g', [xform.eM11]) + Dlm +
      Format('xform.eM12: %.3g', [xform.eM12]) + Dlm +
      Format('xform.eM21: %.3g', [xform.eM21]) + Dlm +
      Format('xform.eM22: %.3g', [xform.eM22]) + Dlm +
      Format('xform.eDx: %.3g', [xform.eDx]) + Dlm +
      Format('xform.eDy: %.3g', [xform.eDy]) + Dlm +
      Format('iMode: %u', [iMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_MoveToEx;
begin
  AddLastRecord;

  FDC.FData.PositionNext := PLast^.MoveToEx.ptl;

  with PLast^.MoveToEx.ptl do
    Parsing := 'EMR_MoveToEx' + Dlm +
      Format('ptl: %d, %d', [X, Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_NamedEscape;
begin
  AddLastRecord;

  Parsing := 'EMR_NamedEscape' + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_OffsetClipRgn;
begin
  AddLastRecord;

  with PLast^.OffsetClipRgn.ptlOffset do
    if FDC.ClipRgn <> HRGN(nil) then
      OffsetRgn(FDC.FData.ClipRgn, X, Y);

  with PLast^.OffsetClipRgn.ptlOffset do
    Parsing := 'EMR_OffsetClipRgn' + Dlm +
      Format('ptlOffset: %d, %d', [X, Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PaintRgn;
begin
  AddLastRecord;

  with PLast^.PaintRgn do
    Parsing := 'EMR_PaintRgn' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('cbRgnData: %u', [cbRgnData]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Pie;
begin
  AddLastRecord;

  with PLast^.Pie do
    Parsing := 'EMR_Pie' + Dlm +
      Format('rclBox: %s', [CommentRect(PLast^.Arc.rclBox)]) + Dlm +
      Format('ptlStart: %d, %d', [ptlStart.X, ptlStart.Y]) + Dlm +
      Format('ptlEnd: %d, %d', [ptlEnd.X, ptlEnd.Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PixelFormat;
begin
  AddLastRecord;

  with PLast^.PixelFormat do
    Parsing := 'EMR_PixelFormat' + Dlm +
      Format('pfd.nSize: %u', [pfd.nSize]) + Dlm +
      Format('pfd.nVersion: %u', [pfd.nVersion]) + Dlm +
      Format('pfd.dwFlags: %u', [pfd.dwFlags]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PLGBlt;
begin
  FEMRList.Add(TEMRPLGBltObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_PLGBlt' + Dlm +
      Format('rclBounds: %s', [CommentRect(PLGBlt.rclBounds)]) + Dlm +
      Format('aptlDest[0]: %s', [CommentPoint(PLGBlt.aptlDest[0])]) + Dlm +
      Format('aptlDest[1]: %s', [CommentPoint(PLGBlt.aptlDest[1])]) + Dlm +
      Format('aptlDest[2]: %s', [CommentPoint(PLGBlt.aptlDest[2])]) + Dlm +
      Format('xSrc: %d', [PLGBlt.xSrc]) + Dlm +
      Format('ySrc: %d', [PLGBlt.ySrc]) + Dlm +
      Format('cySrc: %d', [PLGBlt.cxSrc]) + Dlm +
      Format('cySrc: %d', [PLGBlt.cySrc]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyBezier;
begin
  AddLastRecord;

  Parse_Poly('PolyBezier');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyBezier16;
begin
  AddLastRecord;

  Parse_Poly16('PolyBezier16');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyBezierTo;
begin
  AddLastRecord;

  with PLast^.PolyBezierTo, aptl[cptl - 1] do
    FDC.FData.PositionNext := Point(x, y);

  Parse_Poly('PolyBezierTo');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyBezierTo16;
begin
  AddLastRecord;

  with PLast^.PolyBezierTo16, apts[cpts - 1] do
    FDC.FData.PositionNext := Point(x, y);

  Parse_Poly16('PolyBezierTo16');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyDraw;
var
  Point: integer;
begin
  FEMRList.Add(TEMRPolyDrawObj.Create(FInStream, FLastRecord.nSize));

  with FEMRList.Last as TEMRPolyDrawObj do
  begin
    Parsing := 'EMR_PolyDraw' + Dlm +
      Format('rclBounds: %s', [CommentRect(P^.PolyDraw.rclBounds)]) + Dlm +
      Format('cpts: %u', [P^.PolyDraw.cptl]) + Dlm;
    with TQuickWideFragment.Create do
    begin
      for Point := 0 to P^.PolyDraw.cptl - 1 do
        AddWide(' (%d:%d %u)',
          [P^.PolyDraw.aptl[Point].X, P^.PolyDraw.aptl[Point].y, Types[Point]]);
      Parsing := Parsing + Text;
      Free;
    end;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyDraw16;
var
  Point: integer;
begin
  FEMRList.Add(TEMRPolyDraw16Obj.Create(FInStream, FLastRecord.nSize));

  with FEMRList.Last as TEMRPolyDraw16Obj do
  begin
    Parsing := 'EMR_PolyDraw' + Dlm +
      Format('rclBounds: %s', [CommentRect(P^.PolyDraw16.rclBounds)]) + Dlm +
      Format('cpts: %u', [P^.PolyDraw16.cpts]) + Dlm;
    with TQuickWideFragment.Create do
    begin
      for Point := 0 to P^.PolyDraw16.cpts - 1 do
        AddWide(' (%d:%d %u)',
          [P^.PolyDraw16.apts[Point].X, P^.PolyDraw16.apts[Point].y, Types[Point]]);
      Parsing := Parsing + Text;
      Free;
    end;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Polygon;
begin
  AddLastRecord;

  Parse_Poly('Polygon');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Polygon16;
begin
  AddLastRecord;

  Parse_Poly16('Polygon16');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Polyline;
begin
  AddLastRecord;

  Parse_Poly('Polyline');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Polyline16;
begin
  AddLastRecord;

  Parse_Poly16('Polyline16');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolylineTo;
begin
  AddLastRecord;

  with PLast^.PolylineTo, aptl[cptl - 1] do
    FDC.FData.PositionNext := Point(x, y);

  Parse_Poly('PolylineTo');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolylineTo16;
begin
  AddLastRecord;

  with PLast^.PolylineTo16, apts[cpts - 1] do
    FDC.FData.PositionNext := Point(x, y);

  Parse_Poly16('PolylineTo16');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyPolygon;
begin
  FEMRList.Add(TEMRPolyPolygonObj.Create(FInStream, FLastRecord.nSize));

  Parse_PolyPoly('Polygon');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyPolygon16;
begin
  FEMRList.Add(TEMRPolyPolygon16Obj.Create(FInStream, FLastRecord.nSize));

  Parse_PolyPoly16('Polygon16');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyPolyline;
begin
  FEMRList.Add(TEMRPolyPolylineObj.Create(FInStream, FLastRecord.nSize));

  Parse_PolyPoly('Polyline');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyPolyline16;
begin
  FEMRList.Add(TEMRPolyPolyline16Obj.Create(FInStream, FLastRecord.nSize));

  Parse_PolyPoly16('Polyline16');
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyTextOutA;
var
  i: integer;
begin
  FEMRList.Add(TEMRPolyTextOutAObj.Create(FInStream, FLastRecord.nSize));

  with PLast^.PolyTextOutA do
  begin
    Parsing := 'EMR_PolyTextOutA' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('iGraphicsMode: %u', [iGraphicsMode]) + Dlm +
      Format('exScale: %.3g', [exScale]) + Dlm +
      Format('eyScale: %.3g', [eyScale]) + Dlm +
      Format('cStrings: %d', [cStrings]);

    with TQuickWideFragment.Create do
    begin
      for i := 0 to cStrings - 1 do
        AddWide(Dlm + IntToStr(i) + ':' + Dlm +
          Format('ptlReference: %d, %d',
                 [aemrtext[i].ptlReference.X, aemrtext[i].ptlReference.Y]) + Dlm +
          Format('nChars: %u', [aemrtext[i].nChars]) + Dlm +
          Format('offString: %u', [aemrtext[i].offString]) + Dlm +
          Format('fOptions: %u', [aemrtext[i].fOptions]) + Dlm +
          Format('rcl: %s', [CommentRect(aemrtext[i].rcl)]) + Dlm +
          Format('offDx: %u', [aemrtext[i].offDx]) + Dlm +
          Format('OutputString: %s',
                 [(FEMRList.Last as TEMRPolyTextOutAObj).OutputString[i]]) + Etc);
      Parsing := Parsing + Text;
      Free;
    end;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_PolyTextOutW;
var
  i: integer;
begin
  FEMRList.Add(TEMRPolyTextOutAObj.Create(FInStream, FLastRecord.nSize));

  with PLast^.PolyTextOutW do
  begin
    Parsing := 'EMR_PolyTextOutW' + Dlm +
      Format('rclBounds: %s', [CommentRect(rclBounds)]) + Dlm +
      Format('iGraphicsMode: %u', [iGraphicsMode]) + Dlm +
      Format('exScale: %.3g', [exScale]) + Dlm +
      Format('eyScale: %.3g', [eyScale]) + Dlm +
      Format('cStrings: %d', [cStrings]);

    with TQuickWideFragment.Create do
    begin
      for i := 0 to cStrings - 1 do
        AddWide(Dlm + IntToStr(i) + ':' + Dlm +
          Format('ptlReference: %d, %d',
                 [aemrtext[i].ptlReference.X, aemrtext[i].ptlReference.Y]) + Dlm +
          Format('nChars: %u', [aemrtext[i].nChars]) + Dlm +
          Format('offString: %u', [aemrtext[i].offString]) + Dlm +
          Format('fOptions: %u', [aemrtext[i].fOptions]) + Dlm +
          Format('rcl: %s', [CommentRect(aemrtext[i].rcl)]) + Dlm +
          Format('offDx: %u', [aemrtext[i].offDx]) + Dlm +
          Format('OutputString: %s',
                 [(FEMRList.Last as TEMRPolyTextOutWObj).OutputString[i]]) + Etc);
      Parsing := Parsing + Text;
      Free;
    end;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_RealizePalette;
begin
  AddLastRecord;

  Parsing := 'EMR_RealizePalette';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Rectangle;
begin
  AddLastRecord;

  Parsing := 'EMR_Rectangle' + Dlm +
    Format('rclBox: %s', [CommentRect(PLast^.Rectangle.rclBox)]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_Reserved_69;
begin
  AddLastRecord;

  Parsing := 'EMR_Reserved_69';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ResizePalette;
begin
  AddLastRecord;

  with PLast^.ResizePalette do
    Parsing := 'EMR_ResizePalette' + Dlm +
      Format('ihPal: %u', [ihPal]) + Dlm +
      Format('cEntries: %u', [cEntries]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_RestoreDC;
var
  i: Integer;
begin
  AddLastRecord;

  i := PLast^.RestoreDC.iRelative;
  while (i < 0) and (FDCList.Count > 0) do
  begin
    FDC.Free;
    FDC := TDeviceContext(FDCList.Last);
    FDCList.Delete(FDCList.Count - 1);
    Inc(i);
  end;

  Parsing := 'EMR_RestoreDC' + Dlm +
    Format('iRelative: %d', [PLast^.RestoreDC.iRelative]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_RoundRect;
begin
  AddLastRecord;

  with PLast^ do
    Parsing := 'EMR_RoundRect' + Dlm +
      Format('rclBox: %s', [CommentRect(RoundRect.rclBox)]) + Dlm +
      Format('szlExtent: %d, %d', [RoundRect.szlCorner.cx, RoundRect.szlCorner.cy]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SaveDC;
begin
  AddLastRecord;

  FDCList.Add(FDC);
  DCCreate;
  FDC.CopyFrom(FDCList.Last);

  Parsing := 'EMR_SaveDC';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ScaleViewportExtEx;
begin
  AddLastRecord;

  if FDC.MapMode in [MM_ISOTROPIC, MM_ANISOTROPIC] then
    with FDC.FData.ViewPortExtEx, PLast^.ScaleViewportExtEx do
    begin
      cx := Round(cx * xNum / xDenom);
      cy := Round(cy * yNum / yDenom);
    end;

  with PLast^.ScaleViewportExtEx do
    Parsing := 'EMR_ScaleViewportExtEx' + Dlm +
      Format('xNum: %d',   [xNum]) +   Dlm +
      Format('xDenom: %d', [xDenom]) + Dlm +
      Format('yNum: %d',   [yNum]) +   Dlm +
      Format('yDenom: %d', [yDenom]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_ScaleWindowExtEx;
begin
  AddLastRecord;

  if FDC.MapMode in [MM_ISOTROPIC, MM_ANISOTROPIC] then
    with FDC.FData.WindowExtEx, PLast^.ScaleWindowExtEx do
    begin
      cx := Round(cx * xNum / xDenom);
      cy := Round(cy * yNum / yDenom);
    end;

  with PLast^.ScaleWindowExtEx do
    Parsing := 'EMR_ScaleWindowExtEx' + Dlm +
      Format('xNum: %d',   [xNum]) +   Dlm +
      Format('xDenom: %d', [xDenom]) + Dlm +
      Format('yNum: %d',   [yNum]) +   Dlm +
      Format('yDenom: %d', [yDenom]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SelectClipPath;
begin
  AddLastRecord;

  Parsing := 'EMR_SelectClipPath' + Dlm +
    Format('iMode: %u', [PLast^.SelectClipPath.iMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SelectObject;
begin
  AddLastRecord;

  FDC.SelectObject(PLast^.SelectObject.ihObject, FEMRLastCreated);

  Parsing := 'EMR_SelectObject' + Dlm +
    Format('ihObject: %u', [PLast^.SelectObject.ihObject]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SelectPalette;
begin
  AddLastRecord;

  FDC.SelectObject(PLast^.SelectPalette.ihPal, FEMRLastCreated);

  Parsing := 'EMR_SelectPalette' + Dlm +
    Format('ihPal: %u', [PLast^.SelectPalette.ihPal]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetArcDirection;
begin
  AddLastRecord;

  FDC.FData.iArcDirection := PLast^.SetArcDirection.iArcDirection;

  Parsing := 'EMR_SetArcDirection' + Dlm +
    Format('iArcDirection: %u', [FDC.iArcDirection]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetBkColor;
begin
  AddLastRecord;

  FDC.FData.BkColor := PLast^.SetBkColor.crColor;

  Parsing := 'EMR_SetBkColor' + Dlm +
    Format('crColor: %u', [FDC.BkColor]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetBkMode;
begin
  AddLastRecord;

  FDC.FData.BkMode := PLast^.SetBkMode.iMode;

  Parsing := 'EMR_SetBkMode' + Dlm +
    Format('iMode: %u', [FDC.BkMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetBrushOrgEx;
begin
  AddLastRecord;

  FDC.FData.BrushOrgEx := PLast^.SetBrushOrgEx.ptlOrigin;

  with FDC.BrushOrgEx do
    Parsing := 'EMR_BrushOrgEx' + Dlm +
      Format('ptlOrigin: %d, %d', [X, Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetColorAdjustment;
begin
  AddLastRecord;

  FDC.FData.ColorAdjustment := FEMRList.Last as TEnhMetaObj;

  with PLast^.SetColorAdjustment do
    Parsing := 'EMR_SetColorAdjustment' + Dlm +
      Format('ColorAdjustment.caSize: %u', [ColorAdjustment.caSize]) + Dlm +
      Format('ColorAdjustment.caFlags: %u', [ColorAdjustment.caFlags]) + Dlm +
      Format('ColorAdjustment.caIlluminantIndex: %u', [ColorAdjustment.caIlluminantIndex]) + Dlm +
      Format('ColorAdjustment.caRedGamma: %u', [ColorAdjustment.caRedGamma]) + Dlm +
      Format('ColorAdjustment.caGreenGamma: %u', [ColorAdjustment.caGreenGamma]) + Dlm +
      Format('ColorAdjustment.caBlueGamma: %u', [ColorAdjustment.caBlueGamma]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetColorSpace;
begin
  AddLastRecord;

  FDC.SelectObject(PLast^.SetColorSpace.ihCS, FEMRLastCreated);

  Parsing := 'EMR_SetColorSpace' + Dlm +
    Format('ihCS: %u', [PLast^.SetColorSpace.ihCS]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetDIBitsToDevice;
begin
  FEMRList.Add(TEMRSetDIBitsToDeviceObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_SetDIBitsToDevice' + Dlm +
      Format('rclBounds: %s', [CommentRect(SetDIBitsToDevice.rclBounds)]) + Dlm +
      Format('xDest: %d', [SetDIBitsToDevice.xDest]) + Dlm +
      Format('yDest: %d', [SetDIBitsToDevice.yDest]) + Dlm +
      Format('xSrc: %d', [SetDIBitsToDevice.xSrc]) + Dlm +
      Format('ySrc: %d', [SetDIBitsToDevice.ySrc]) + Dlm +
      Format('cxSrc: %d', [SetDIBitsToDevice.cxSrc]) + Dlm +
      Format('cySrc: %d', [SetDIBitsToDevice.cySrc]) + Dlm +
      Format('dwRop: %u', [BitBlt.dwRop]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetICMMode;
begin
  AddLastRecord;

  FDC.FData.ICMMode := PLast^.SetICMMode.iMode;

  Parsing := 'EMR_SetICMMode' + Dlm +
    Format('iMode: %u', [FDC.ICMMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetIcmProfileA;
begin
  AddLastRecord;

  with PLast^.SetIcmProfileA do
    Parsing := 'EMR_SetIcmProfileA' + Dlm +
      Format('dwFlags: %u', [dwFlags]) + Dlm +
      Format('cbName: %u', [cbName]) + Dlm +
      Format('cbData: %u', [cbData]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetIcmProfileW;
begin
  AddLastRecord;

  with PLast^.SetIcmProfileW do
    Parsing := 'EMR_SetIcmProfileW' + Dlm +
      Format('dwFlags: %u', [dwFlags]) + Dlm +
      Format('cbName: %u', [cbName]) + Dlm +
      Format('cbData: %u', [cbData]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetLayout;
begin
  AddLastRecord;

  FDC.FData.Layout := PLast^.SetLayout.iMode;

  Parsing := 'EMR_SetLayout' + Dlm +
    Format('iMode: %u', [FDC.Layout]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetLinkedUFIs;
begin
  AddLastRecord;

  Parsing := 'EMR_SetLinkedUFIs' + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetMapMode;
begin
  AddLastRecord;

  FDC.FData.MapMode := PLast^.SetMapMode.iMode;

  Parsing := 'EMR_SetMapMode' + Dlm +
    Format('iMode: %u', [FDC.MapMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetMapperFlags;
begin
  AddLastRecord;

  FDC.FData.MapperFlags := PLast^.SetMapperFlags.dwFlags;

  Parsing := 'EMR_SetMapperFlags' + Dlm +
    Format('dwFlags: %u', [FDC.MapperFlags]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetMetaRgn;
begin
  AddLastRecord;

  FDC.FData.ClipRgn := HRGN(nil);

  Parsing := 'EMR_SetMetaRgn';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetMiterLimit;
begin
  AddLastRecord;

  FDC.FData.MiterLimit := PLast^.SetMiterLimit.eMiterLimit;

  Parsing := 'EMR_SetMiterLimit' + Dlm +
    Format('eMiterLimit: %.3g', [FDC.MiterLimit]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetPaletteEntries;
var
  i: Integer;
begin
  AddLastRecord;

  with PLast^.SetPaletteEntries do
  begin
    Parsing := 'EMR_SetPaletteEntries' + Dlm +
      Format('ihPal: %u', [ihPal]) + Dlm +
      Format('iStart: %u', [iStart]) + Dlm +
      Format('cEntries: %u', [cEntries]);
    if cEntries > 0 then
      with TQuickWideFragment.Create do
      begin
        for i := 0 to cEntries - 1 do
          AddWide(Dlm + '%u: %u', [i, LongWord(aPalEntries[i])]);
        Parsing := Parsing + Text;
        Free;
      end;
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetPixelV;
begin
  AddLastRecord;

  with PLast^.SetPixelV do
    Parsing := 'EMR_SetPixelV' + Dlm +
      Format('ptlPixel: %d, %d', [ptlPixel.X, ptlPixel.X]) + Dlm +
      Format('crColor: %u', [crColor]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetPolyFillMode;
begin
  AddLastRecord;

  FDC.FData.PolyFillMode := PLast^.SetPolyFillMode.iMode;

  Parsing := 'EMR_SetPolyFillMode' + Dlm +
    Format('iMode: %u', [FDC.PolyFillMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetRop2;
begin
  AddLastRecord;

  FDC.FData.SetRop2 := PLast^.SetRop2.iMode;

  Parsing := 'EMR_SetRop2' + Dlm +
    Format('iMode: %u', [FDC.SetRop2]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetStretchBltMode;
begin
  AddLastRecord;

  FDC.FData.StretchMode := PLast^.SetStretchBltMode.iMode;

  Parsing := 'EMR_SetStretchBltMode' + Dlm +
    Format('iMode: %u', [FDC.StretchMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetTextAlign;
begin
  AddLastRecord;

  FDC.FData.TextAlignmentMode := PLast^.SetTextAlign.iMode;

  Parsing := 'EMR_SetTextAlign' + Dlm +
    Format('iMode: %u', [FDC.TextAlignmentMode]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetTextColor;
begin
  AddLastRecord;

  FDC.FData.TextColor := PLast^.SetTextColor.crColor;

  Parsing := 'EMR_SetTextColor' + Dlm +
    Format('crColor: %u', [FDC.TextColor]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetTextJustification;
begin
  AddLastRecord;

  Parsing := 'EMR_SetTextJustification' + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetViewPortExtEx;
begin
  AddLastRecord;

  FDC.FData.ViewPortExtEx := PLast^.SetViewPortExtEx.szlExtent;

  with FDC.ViewPortExtEx do
    Parsing := 'EMR_SetViewPortExtExX' + Dlm +
      Format('szlExtent: %d, %d', [cx, cy]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetViewPortOrgEx;
begin
  AddLastRecord;

  FDC.FData.ViewPortOrgEx := PLast^.SetViewPortOrgEx.ptlOrigin;

  with FDC.ViewPortOrgEx do
    Parsing := 'EMR_SetViewPortOrgEx' + Dlm +
      Format('ptlOrigin: %d, %d', [X, Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetWindowExtEx;
begin
  AddLastRecord;

  FDC.FData.WindowExtEx := PLast^.SetWindowExtEx.szlExtent;

  with FDC.WindowExtEx do
    Parsing := 'EMR_SetWindowExtEx' + Dlm +
      Format('szlExtent: %d, %d', [cx, cy]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetWindowOrgEx;
begin
  AddLastRecord;

  FDC.FData.WindowOrgEx := PLast^.SetWindowOrgEx.ptlOrigin;

  with FDC.WindowOrgEx do
    Parsing := 'EMR_SetWindowOrgEx' + Dlm +
      Format('ptlOrigin: %d, %d', [X, Y]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SetWorldTransform;
begin
  AddLastRecord;

  FDC.FData.XForm := PLast^.SetWorldTransform.xform;

  with PLast^.SetWorldTransform do
    Parsing := 'EMR_SetWorldTransform' + Dlm +
      Format('xform.eM11: %.3g', [xform.eM11]) + Dlm +
      Format('xform.eM12: %.3g', [xform.eM12]) + Dlm +
      Format('xform.eM21: %.3g', [xform.eM21]) + Dlm +
      Format('xform.eM22: %.3g', [xform.eM22]) + Dlm +
      Format('xform.eDx: %.3g', [xform.eDx]) + Dlm +
      Format('xform.eDy: %.3g', [xform.eDy]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_SmallTextOut;
begin
  FEMRList.Add(TEMRSmallTextOutObj.Create(FInStream, FLastRecord.nSize));

  with PLast^.SmallTextOut do
  begin
    Parsing := 'EMR_SmallTextOut' + Dlm +
      Format('ptlReference: %d, %d', [ptlReference.X, ptlReference.Y]) + Dlm +
      Format('nChars: %u', [nChars]) + Dlm +
      Format('fuOptions: %u', [fuOptions]) + Dlm +
      Format('iGraphicsMode: %u', [iGraphicsMode]) + Dlm +
      Format('exScale: %.3g', [exScale]) + Dlm +
      Format('eyScale: %.3g', [eyScale]) + Dlm;
    with (FEMRList.Last as TEMRSmallTextOutObj) do
      Parsing := Parsing +
        IfStr(IsNoRect, '', Format('rclClip: %s' + Dlm, [CommentRect(rclClip)])) +
        Format('OutputString: %s', [IfStr(IsANSI, string(OutputStringANSI), OutputStringWide)]);
  end;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_StartDoc;
begin
  AddLastRecord;

  Parsing := 'EMR_StartDoc' + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_StretchBlt;
begin
  FEMRList.Add(TEMRStretchBltObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_StretchBlt' + Dlm +
      Format('rclBounds: %s', [CommentRect(StretchBlt.rclBounds)]) + Dlm +
      Format('xDest: %d' + Dlm + 'yDest: %d' + Dlm +
             'cxDest: %d' + Dlm + 'cyDest: %d' + Dlm + 'dwRop: %u' + Etc,
             [StretchBlt.xDest, StretchBlt.yDest,
              StretchBlt.cxDest, StretchBlt.cyDest, StretchBlt.dwRop]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_StretchDIBits;
begin
  FEMRList.Add(TEMRStretchDIBitsObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_StretchDIBits' + Dlm +
      Format('rclBounds: %s', [CommentRect(StretchDIBits.rclBounds)]) + Dlm +
      Format('xDest: %d' + Dlm + 'yDest: %d' + Dlm +
             'cxDest: %d' + Dlm + 'cyDest: %d' + Dlm + 'dwRop: %u' + Dlm + 'etc.',
             [StretchDIBits.xDest, StretchDIBits.yDest,
              StretchDIBits.cxDest, StretchDIBits.cyDest, StretchDIBits.dwRop]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_StrokeAndFillPath;
begin
  AddLastRecord;

  Parsing := 'EMR_StrokeAndFillPath' + Dlm +
    Format('rclBounds: %s', [CommentRect(PLast^.StrokeAndFillPath.rclBounds)]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_StrokePath;
begin
  AddLastRecord;

  Parsing := 'EMR_StrokePath' + Dlm +
    Format('rclBounds: %s', [CommentRect(PLast^.StrokePath.rclBounds)]);
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_TransparentBlt;
begin
  FEMRList.Add(TEMRTransparentBltObj.Create(FInStream, FLastRecord.nSize));

  with PLast^ do
    Parsing := 'EMR_TransparentBlt' + Dlm +
      Format('rclBounds: %s', [CommentRect(TransparentBlt.rclBounds)]) + Dlm +
      Format('xDest: %d', [TransparentBlt.xDest]) + Dlm +
      Format('yDest: %d', [TransparentBlt.yDest]) + Dlm +
      Format('cxDest: %d', [TransparentBlt.cxDest]) + Dlm +
      Format('cyDest: %d', [TransparentBlt.cyDest]) + Dlm +
      Format('dwRop: %u', [TransparentBlt.dwRop]) + Etc;
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_TransparentDIB;
begin
  AddLastRecord;

  Parsing := 'TransparentDIB';
  Comment;
end;

procedure TEMFAbstractExport.DoEMR_WidenPath;
begin
  AddLastRecord;

  Parsing := 'EMR_WidenPath';
  Comment;
end;

procedure TEMFAbstractExport.DoFinish;
begin
  // Empty
end;

procedure TEMFAbstractExport.DoStart;
begin
  // Empty
end;

procedure TEMFAbstractExport.DoUnknown;
var
  B: array of byte;
  i: integer;
begin
  Parsing := '######################### Unknown' + CRLF +
    Format('Type:%d Size:%d Data:',
      [FLastRecord.iType, FLastRecord.nSize]);

  SetLength(B, FLastRecord.nSize);
  FInStream.Read(B[0], FLastRecord.nSize);
  with TQuickWideFragment.Create do
  begin
    for i := 0 to FLastRecord.nSize - 1 do
      AddWide(ByteToHex(B[i]));
    Parsing := Parsing + Text;
    Free;
  end;
  Comment;
end;

function TEMFAbstractExport.FontCreate: TFont;
begin
  Result := TFont.Create;
  Result.Name := FDC.FontFamily;
  Result.Charset := FDC.FontCharSet;
  Result.Color := FDC.TextColor;

//  Result.Size := Must be overrided!

// there is no such property in Delphi7!
//  Result.Orientation := FDC.FontOrientation;

  if FDC.FontWeight > 550 then
    Result.Style := Result.Style + [fsBold];
  if FDC.FontItalic then
    Result.Style := Result.Style + [fsItalic];
  if FDC.FontUnderline then
    Result.Style := Result.Style + [fsUnderline];
  if FDC.FontStrikeOut then
    Result.Style := Result.Style + [fsStrikeOut];
end;

function TEMFAbstractExport.LogToDevPoint(LP: TSmallPoint): TfrxPoint;
begin
  Result := LogToDevPoint(LP.X, LP.Y);
end;

function TEMFAbstractExport.LogToDevPoint(LP: TPoint): TfrxPoint;
begin
  Result := LogToDevPoint(LP.X, LP.Y);
end;

function TEMFAbstractExport.LogToDevPoint(LP: TfrxPoint): TfrxPoint;
begin
  Result := LogToDevPoint(LP.X, LP.Y);
end;

function TEMFAbstractExport.LogToDevPoint(X, Y: Extended): TfrxPoint;
begin
  Result.X := LogToDevX(X);
  Result.Y := LogToDevY(Y);

  TransformPoint(Result);
end;

function TEMFAbstractExport.LogToDevRect(LR: TRect): TfrxRect;
var
  TopLeft, BottomRight: TfrxPoint;
begin
  TopLeft := LogToDevPoint(LR.TopLeft);
  Result.Left := TopLeft.X;
  Result.Top :=  TopLeft.Y;

  BottomRight := LogToDevPoint(LR.BottomRight);
  Result.Right :=  BottomRight.X;
  Result.Bottom := BottomRight.Y;
end;

function TEMFAbstractExport.LogToDevSize(Value: Extended): Extended;
begin
  Result := (LogToDevSizeX(Value) + LogToDevSizeY(Value)) / 2;
end;

function TEMFAbstractExport.LogToDevSizeX(Value: Extended): Extended;
var
  Scale: Extended;
begin
  if FDC.MapMode in [MM_TEXT..MM_TWIPS] then
    Scale := 1.0
  else // if FDC.MapMode in [MM_ISOTROPIC, MM_ANISOTROPIC] then
    Scale := FDC.ViewPortExtEx.cx / FDC.WindowExtEx.cx ;

  Result := Max(1.0, Value) * Scale;

  with FDC do
    if not IsXFormDefault then
      Result := Result * XForm.eM11;
end;

function TEMFAbstractExport.LogToDevSizeY(Value: Extended): Extended;
var
  Scale: Extended;
begin
  if FDC.MapMode in [MM_TEXT..MM_TWIPS] then
    Scale := 1.0
  else // if FDC.MapMode in [MM_ISOTROPIC, MM_ANISOTROPIC] then
    Scale := FDC.ViewPortExtEx.cy / FDC.WindowExtEx.cy ;

  Result := Max(1.0, Value) * Scale;

  with FDC do
    if not IsXFormDefault then
      Result := Result * XForm.eM22;
end;

function TEMFAbstractExport.LogToDevX(LX: Extended): Extended;
begin
  if FDC.MapMode in [MM_TEXT..MM_TWIPS] then
    Result := (LX - FDC.WindowOrgEx.X) + FDC.ViewPortOrgEx.X
  else // if FDC.MapMode in [MM_ISOTROPIC, MM_ANISOTROPIC] then
    Result := (LX - FDC.WindowOrgEx.X) * FDC.ViewPortExtEx.cx / FDC.WindowExtEx.cx +
      FDC.ViewPortOrgEx.X - FDC.rTopLeft.X;
end;

function TEMFAbstractExport.LogToDevY(LY: Extended): Extended;
begin  // MM_LOMETRIC..MM_TWIPS positive y is up
  if FDC.MapMode in [MM_TEXT..MM_TWIPS] then
    Result := (LY - FDC.WindowOrgEx.Y) + FDC.ViewPortOrgEx.Y
  else // if FDC.MapMode in [MM_ISOTROPIC, MM_ANISOTROPIC] then
    Result := (LY - FDC.WindowOrgEx.Y) * FDC.ViewPortExtEx.cy / FDC.WindowExtEx.cy +
      FDC.ViewPortOrgEx.Y - FDC.rTopLeft.Y;
end;

procedure TEMFAbstractExport.Parse_Poly(Name: string);
var
  Point: integer;
begin
  Parsing := 'EMR_' + Name + Dlm +
    Format('rclBounds: %s', [CommentRect(PLast^.Polyline.rclBounds)]) + Dlm +
    Format('cpts: %u', [PLast^.Polyline.cptl]);

  with PLast^ do
    with TQuickWideFragment.Create do
    begin
      for Point := 0 to Polyline.cptl - 1 do
        with Polyline.aptl[Point] do
          AddWide(' (%d:%d)', [x, y]);
      Parsing := Parsing + Text;
      Free;
    end;
end;

procedure TEMFAbstractExport.Parse_Poly16(Name: string);
var
  Point: integer;
begin
  Parsing := 'EMR_' + Name + Dlm +
    Format('rclBounds: %s', [CommentRect(PLast^.Polyline16.rclBounds)]) + Dlm +
    Format('cpts: %u', [PLast^.Polyline16.cpts]);

  with TQuickWideFragment.Create do
  begin
    with PLast^ do
      for Point := 0 to Polyline16.cpts - 1 do
        with Polyline16.apts[Point] do
          AddWide(' (%d:%d)', [x, y]);
    Parsing := Parsing + Text;
    Free;
  end;
end;

procedure TEMFAbstractExport.Parse_PolyPoly(Name: string);
var
  Poly, Point: integer;
begin
  with FEMRList.Last as TEMRPolyPolygonObj do
  begin
    Parsing := 'EMR_Poly' + Name + Dlm +
    Format('rclBounds: %s', [CommentRect(P^.PolyPolygon.rclBounds)]) + Dlm +
    Format('nPolys: %u', [P^.PolyPolygon.nPolys]) + Dlm +
    Format('cpts: %u', [P^.PolyPolygon.cptl]);

    with TQuickWideFragment.Create do
    begin
      for Poly := 0 to P^.PolyPolygon.nPolys - 1 do
      begin
        AddWide(Dlm + 'Poly: %u (%u)', [Poly, P^.PolyPolygon.aPolyCounts[Poly]]);
        for Point := 0 to P^.PolyPolygon.aPolyCounts[Poly] - 1 do
          with PolyPoint[Poly, Point] do
            AddWide(' (%d:%d)', [x, y]);
      end;
      Parsing := Parsing + Text;
      Free;
    end;
  end;
end;

procedure TEMFAbstractExport.Parse_PolyPoly16(Name: string);
var
  Poly, Point: integer;
begin
  with FEMRList.Last as TEMRPolyPolygon16Obj do
  begin
    Parsing := 'EMR_Poly' + Name + Dlm +
    Format('rclBounds: %s', [CommentRect(P^.PolyPolygon16.rclBounds)]) + Dlm +
    Format('nPolys: %u', [P^.PolyPolygon16.nPolys]) + Dlm +
    Format('cpts: %u', [P^.PolyPolygon16.cpts]);

    with TQuickWideFragment.Create do
    begin
      for Poly := 0 to P^.PolyPolygon16.nPolys - 1 do
      begin
        AddWide(Dlm + 'Poly: %u (%u)', [Poly, P^.PolyPolygon16.aPolyCounts[Poly]]);
        for Point := 0 to P^.PolyPolygon16.aPolyCounts[Poly] - 1 do
          with PolyPoint[Poly, Point] do
            AddWide(' (%d:%d)', [x, y]);
      end;
      Parsing := Parsing + Text;
      Free;
    end;
  end;
end;

function TEMFAbstractExport.PLast: PEnhMetaData;
begin
  Result := TEnhMetaObj(FEMRList.Last).P;
end;

procedure TEMFAbstractExport.PlayMetaCommand;
begin
  FDC.FData.PositionCurrent := FDC.PositionNext;
  ReadCurrentRecord;
  case FLastRecord.iType of
    EMR_Header: DoEMR_Header; // https://msdn.microsoft.com/en-us/library/cc230635.aspx
    EMR_PolyBezier: DoEMR_PolyBezier; // https://msdn.microsoft.com/en-us/library/cc230649.aspx
    EMR_Polygon: DoEMR_Polygon; // https://msdn.microsoft.com/en-us/library/cc230653.aspx
    EMR_Polyline: DoEMR_Polyline; // https://msdn.microsoft.com/en-us/library/cc230655.aspx
    EMR_PolyBezierTo: DoEMR_PolyBezierTo; // https://msdn.microsoft.com/en-us/library/cc230651.aspx
    EMR_PolylineTo: DoEMR_PolylineTo; // https://msdn.microsoft.com/en-us/library/cc230657.aspx
    EMR_PolyPolyline: DoEMR_PolyPolyline; // https://msdn.microsoft.com/en-us/library/cc230661.aspx
    EMR_PolyPolygon: DoEMR_PolyPolygon; // https://msdn.microsoft.com/en-us/library/cc230663.aspx
    EMR_SetWindowExtEx: DoEMR_SetWindowExtEx; // https://msdn.microsoft.com/en-us/library/cc230597.aspx
    EMR_SetWindowOrgEx: DoEMR_SetWindowOrgEx; // https://msdn.microsoft.com/en-us/library/cc230598.aspx
    EMR_SetViewPortExtEx: DoEMR_SetViewPortExtEx; // https://msdn.microsoft.com/en-us/library/cc230595.aspx
    EMR_SetViewPortOrgEx: DoEMR_SetViewPortOrgEx; // https://msdn.microsoft.com/en-us/library/cc230596.aspx
    EMR_SetBrushOrgEx: DoEMR_SetBrushOrgEx; // https://msdn.microsoft.com/en-us/library/cc230682.aspx
    EMR_EoF: DoEMR_EoF; // https://msdn.microsoft.com/en-us/library/cc230617.aspx
    EMR_SetPixelV: DoEMR_SetPixelV; // https://msdn.microsoft.com/en-us/library/cc230586.aspx
    EMR_SetMapperFlags: DoEMR_SetMapperFlags; // https://msdn.microsoft.com/en-us/library/cc230692.aspx
    EMR_SetMapMode: DoEMR_SetMapMode; // https://msdn.microsoft.com/en-us/library/cc230691.aspx
    EMR_SetBkMode: DoEMR_SetBkMode; // https://msdn.microsoft.com/en-us/library/cc230681.aspx
    EMR_SetPolyFillMode: DoEMR_SetPolyFillMode; // https://msdn.microsoft.com/en-us/library/cc230587.aspx
    EMR_SetRop2: DoEMR_SetRop2; // https://msdn.microsoft.com/en-us/library/cc230588.aspx
    EMR_SetStretchBltMode: DoEMR_SetStretchBltMode; // https://msdn.microsoft.com/en-us/library/cc230589.aspx
    EMR_SetTextAlign: DoEMR_SetTextAlign; // https://msdn.microsoft.com/en-us/library/cc230590.aspx
    EMR_SetColorAdjustment: DoEMR_SetColorAdjustment; // https://msdn.microsoft.com/en-us/library/cc230683.aspx
    EMR_SetTextColor: DoEMR_SetTextColor; // https://msdn.microsoft.com/en-us/library/cc230591.aspx
    EMR_SetBkColor: DoEMR_SetBkColor; // https://msdn.microsoft.com/en-us/library/cc230680.aspx
    EMR_OffsetClipRgn: DoEMR_OffsetClipRgn; // https://msdn.microsoft.com/en-us/library/cc230644.aspx
    EMR_MoveToEx: DoEMR_MoveToEx; // https://msdn.microsoft.com/en-us/library/cc230641.aspx
    EMR_SetMetaRgn: DoEMR_SetMetaRgn; // https://msdn.microsoft.com/en-us/library/cc231162.aspx
    EMR_ExcludeClipRect: DoEMR_ExcludeClipRect; // https://msdn.microsoft.com/en-us/library/cc230618.aspx
    EMR_IntersectClipRect: DoEMR_IntersectClipRect; // https://msdn.microsoft.com/en-us/library/cc230636.aspx
    EMR_ScaleViewportExtEx: DoEMR_ScaleViewportExtEx; // https://msdn.microsoft.com/en-us/library/cc230674.aspx
    EMR_ScaleWindowExtEx: DoEMR_ScaleWindowExtEx; // https://msdn.microsoft.com/en-us/library/cc230675.aspx
    EMR_SaveDC: DoEMR_SaveDC; // https://msdn.microsoft.com/en-us/library/cc231190.aspx
    EMR_RestoreDC: DoEMR_RestoreDC; // https://msdn.microsoft.com/en-us/library/cc230671.aspx
    EMR_SetWorldTransform: DoEMR_SetWorldTransform; // https://msdn.microsoft.com/en-us/library/cc230593.aspx
    EMR_ModifyWorldTransform: DoEMR_ModifyWorldTransform; // https://msdn.microsoft.com/en-us/library/cc230640.aspx
    EMR_SelectObject: DoEMR_SelectObject; // https://msdn.microsoft.com/en-us/library/cc230677.aspx
    EMR_CreatePen: DoEMR_CreatePen; // https://msdn.microsoft.com/en-us/library/cc230611.aspx
    EMR_CreateBrushIndirect: DoEMR_CreateBrushIndirect; // https://msdn.microsoft.com/en-us/library/cc230604.aspx
    EMR_DeleteObject: DoEMR_DeleteObject; // https://msdn.microsoft.com/en-us/library/cc230614.aspx
    EMR_AngleArc: DoEMR_AngleArc; // https://msdn.microsoft.com/en-us/library/cc230623.aspx
    EMR_Ellipse: DoEMR_Ellipse; // https://msdn.microsoft.com/en-us/library/cc230616.aspx
    EMR_Rectangle: DoEMR_Rectangle; // https://msdn.microsoft.com/en-us/library/cc230669.aspx
    EMR_RoundRect: DoEMR_RoundRect; // https://msdn.microsoft.com/en-us/library/cc230672.aspx
    EMR_Arc: DoEMR_Arc; // https://msdn.microsoft.com/en-us/library/cc230632.aspx
    EMR_Chord: DoEMR_Chord; // https://msdn.microsoft.com/en-us/library/cc230673.aspx
    EMR_Pie: DoEMR_Pie; // https://msdn.microsoft.com/en-us/library/cc230646.aspx
    EMR_SelectPalette: DoEMR_SelectPalette; // https://msdn.microsoft.com/en-us/library/cc230678.aspx
    EMR_CreatePalette: DoEMR_CreatePalette; // https://msdn.microsoft.com/en-us/library/cc230610.aspx
    EMR_SetPaletteEntries: DoEMR_SetPaletteEntries; // https://msdn.microsoft.com/en-us/library/cc230585.aspx
    EMR_ResizePalette: DoEMR_ResizePalette; // https://msdn.microsoft.com/en-us/library/cc230670.aspx
    EMR_RealizePalette: DoEMR_RealizePalette; // https://msdn.microsoft.com/en-us/library/cc231190.aspx
    EMR_ExtFloodFill: DoEMR_ExtFloodFill;
    EMR_LineTo: DoEMR_LineTo; // https://msdn.microsoft.com/en-us/library/cc230638.aspx
    EMR_ArcTo: DoEMR_ArcTo;
    EMR_PolyDraw: DoEMR_PolyDraw; // https://msdn.microsoft.com/en-us/library/cc230659.aspx
    EMR_SetArcDirection: DoEMR_SetArcDirection;
    EMR_SetMiterLimit: DoEMR_SetMiterLimit; // https://msdn.microsoft.com/en-us/library/cc230584.aspx
    EMR_BeginPath: DoEMR_BeginPath; // https://msdn.microsoft.com/en-us/library/cc230531.aspx
    EMR_EndPath: DoEMR_EndPath; // https://msdn.microsoft.com/en-us/library/cc230531.aspx
    EMR_CloseFigure: DoEMR_CloseFigure; // https://msdn.microsoft.com/en-us/library/cc230531.aspx
    EMR_FillPath: DoEMR_FillPath; // https://msdn.microsoft.com/en-us/library/cc230627.aspx
    EMR_StrokeAndFillPath: DoEMR_StrokeAndFillPath; // https://msdn.microsoft.com/en-us/library/cc230602.aspx
    EMR_StrokePath: DoEMR_StrokePath; // https://msdn.microsoft.com/en-us/library/cc230603.aspx
    EMR_FlattenPath: DoEMR_FlattenPath;
    EMR_WidenPath: DoEMR_WidenPath;
    EMR_SelectClipPath: DoEMR_SelectClipPath; // https://msdn.microsoft.com/en-us/library/cc230676.aspx
    EMR_AbortPath: DoEMR_AbortPath;
    EMR_Reserved_69: DoEMR_Reserved_69; // http://www.sweetscape.com/010editor/templates/files/EMFTemplate.bt
    EMR_GDIComment: DoEMR_GDIComment; // https://msdn.microsoft.com/en-us/library/cc231170.aspx
    EMR_FillRgn: DoEMR_FillRgn; // https://msdn.microsoft.com/en-us/library/cc230628.aspx
    EMR_FrameRgn: DoEMR_FrameRgn; // https://msdn.microsoft.com/en-us/library/cc230630.aspx
    EMR_InvertRgn: DoEMR_InvertRgn; // https://msdn.microsoft.com/en-us/library/cc230637.aspx
    EMR_PaintRgn: DoEMR_PaintRgn; // https://msdn.microsoft.com/en-us/library/cc230645.aspx
    EMR_ExtSelectClipRgn: DoEMR_ExtSelectClipRgn; // https://msdn.microsoft.com/en-us/library/cc230624.aspx
    EMR_BitBlt: DoEMR_BitBlt; // https://msdn.microsoft.com/en-us/library/cc230664.aspx
    EMR_StretchBlt: DoEMR_StretchBlt; // https://msdn.microsoft.com/en-us/library/cc230600.aspx
    EMR_MaskBlt: DoEMR_MaskBlt; // https://msdn.microsoft.com/en-us/library/cc230664.aspx
    EMR_PLGBlt: DoEMR_PLGBlt; // https://msdn.microsoft.com/en-us/library/cc230648.aspx
    EMR_SetDIBitsToDevice: DoEMR_SetDIBitsToDevice; // https://msdn.microsoft.com/en-us/library/cc230685.aspx
    EMR_StretchDIBits: DoEMR_StretchDIBits; // https://msdn.microsoft.com/en-us/library/cc230601.aspx
    EMR_ExtCreateFontIndirectW: DoEMR_ExtCreateFontIndirectW; // https://msdn.microsoft.com/en-us/library/cc230619.aspx
    EMR_ExtTextOutA: DoEMR_ExtTextOutA; // https://msdn.microsoft.com/en-us/library/cc230625.aspx
    EMR_ExtTextOutW: DoEMR_ExtTextOutW; // https://msdn.microsoft.com/en-us/library/cc230626.aspx
    EMR_PolyBezier16: DoEMR_PolyBezier16; // https://msdn.microsoft.com/en-us/library/cc230650.aspx
    EMR_Polygon16: DoEMR_Polygon16; // https://msdn.microsoft.com/en-us/library/cc230654.aspx
    EMR_Polyline16: DoEMR_Polyline16; // https://msdn.microsoft.com/en-us/library/cc230662.aspx
    EMR_PolyBezierTo16: DoEMR_PolyBezierTo16; // https://msdn.microsoft.com/en-us/library/cc230652.aspx
    EMR_PolylineTo16: DoEMR_PolylineTo16; // https://msdn.microsoft.com/en-us/library/cc230658.aspx
    EMR_PolyPolyline16: DoEMR_PolyPolyline16; // https://msdn.microsoft.com/en-us/library/cc230662.aspx
    EMR_PolyPolygon16: DoEMR_PolyPolygon16; // https://msdn.microsoft.com/en-us/library/cc230665.aspx
    EMR_PolyDraw16: DoEMR_PolyDraw16; // https://msdn.microsoft.com/en-us/library/cc230652.aspx
    EMR_CreateMonoBrush: DoEMR_CreateMonoBrush; // https://msdn.microsoft.com/en-us/library/cc230609.aspx
    EMR_CreateDIBPatternBrushPt: DoEMR_CreateDIBPatternBrushPt; // https://msdn.microsoft.com/en-us/library/cc230608.aspx
    EMR_ExtCreatePen: DoEMR_ExtCreatePen; // https://msdn.microsoft.com/en-us/library/cc230620.aspx
    EMR_PolyTextOutA: DoEMR_PolyTextOutA; // https://msdn.microsoft.com/en-us/library/cc230625.aspx
    EMR_PolyTextOutW: DoEMR_PolyTextOutW; // https://msdn.microsoft.com/en-us/library/cc230668.aspx
    EMR_SetICMMode: DoEMR_SetICMMode; // https://msdn.microsoft.com/en-us/library/cc230686.aspx
    EMR_CreateColorSpace: DoEMR_CreateColorSpace; // https://msdn.microsoft.com/en-us/library/cc230606.aspx
    EMR_SetColorSpace: DoEMR_SetColorSpace; // https://msdn.microsoft.com/en-us/library/cc230684.aspx
    EMR_DeleteColorSpace: DoEMR_DeleteColorSpace; // https://msdn.microsoft.com/en-us/library/cc230612.aspx
    EMR_GLSRecord: DoEMR_GLSRecord; // https://msdn.microsoft.com/en-us/library/cc230631.aspx
    EMR_GLSBoundedRecord: DoEMR_GLSBoundedRecord; // https://msdn.microsoft.com/en-us/library/cc230631.aspx
    EMR_PixelFormat: DoEMR_PixelFormat; // https://msdn.microsoft.com/en-us/library/cc230647.aspx
    EMR_DrawEscape: DoEMR_DrawEscape; // https://msdn.microsoft.com/en-us/library/cc230615.aspx
    EMR_ExtEscape: DoEMR_ExtEscape; // https://msdn.microsoft.com/en-us/library/cc230621.aspx
    EMR_StartDoc: DoEMR_StartDoc; // ? https://msdn.microsoft.com/en-us/library/windows/desktop/dd145114%28v=vs.85%29.aspx
    EMR_SmallTextOut: DoEMR_SmallTextOut; // https://msdn.microsoft.com/en-us/library/cc230599.aspx
    EMR_ForceUFIMapping: DoEMR_ForceUFIMapping; // https://msdn.microsoft.com/en-us/library/cc230629.aspx
    EMR_NamedEscape: DoEMR_NamedEscape; // https://msdn.microsoft.com/en-us/library/cc230642.aspx
    EMR_ColorCorrectPalette: DoEMR_ColorCorrectPalette; // https://msdn.microsoft.com/en-us/library/cc230583.aspx
    EMR_SetIcmProfileA: DoEMR_SetIcmProfileA; // https://msdn.microsoft.com/en-us/library/cc230687.aspx
    EMR_SetIcmProfileW: DoEMR_SetIcmProfileW; // https://msdn.microsoft.com/en-us/library/cc230688.aspx
    EMR_AlphaBlend: DoEMR_AlphaBlend; // https://msdn.microsoft.com/en-us/library/cc230613.aspx
    EMR_SetLayout: DoEMR_SetLayout; // https://msdn.microsoft.com/en-us/library/cc230689.aspx
    EMR_TransparentBlt: DoEMR_TransparentBlt; // https://msdn.microsoft.com/en-us/library/cc230605.aspx
    EMR_TransparentDIB: DoEMR_TransparentDIB; // ??
    EMR_GradientFill: DoEMR_GradientFill; // https://msdn.microsoft.com/en-us/library/cc230634.aspx
    EMR_SetLinkedUFIs: DoEMR_SetLinkedUFIs; // https://msdn.microsoft.com/en-us/library/cc230690.aspx
    EMR_SetTextJustification: DoEMR_SetTextJustification; // https://msdn.microsoft.com/en-us/library/cc230592.aspx
    EMR_ColorMatchToTargetW: DoEMR_ColorMatchToTargetW; // https://msdn.microsoft.com/en-us/library/windows/desktop/dd162518(v=vs.85).aspx
    EMR_CreateColorSpaceW: DoEMR_CreateColorSpaceW; // https://msdn.microsoft.com/en-us/library/cc230607.aspx
  else
    DoUnknown;
  end;

// -- TEMRSelectColorSpace
// -- TEMRFormat
//
end;

procedure TEMFAbstractExport.PlayMetaFile;
begin
  DoStart;
  while (FLastRecord.iType <> EMR_EoF) and
        (FInStream.Position < FInStream.Size) do
    PlayMetaCommand;
  DoFinish;
end;

procedure TEMFAbstractExport.ReadAlign;
const
  Alignment = SizeOf(LongWord);
begin
  while FInStream.Position mod Alignment > 0 do
    FInStream.Position := FInStream.Position + 1;
end;

procedure TEMFAbstractExport.ReadCurrentRecord;
begin
  ReadAlign;
  FInStream.Read(FLastRecord, SizeOf(FLastRecord));
  FInStream.Position := FInStream.Position - SizeOf(FLastRecord);
end;

procedure TEMFAbstractExport.ReadEoFPalette;
var
  CurPos: Int64;
  EoFObj: TEoFObj;
  i: Integer;
begin
  CurPos := FInStream.Position;
  FInStream.Position := FInStream.Position - FLastRecord.nSize;
  while (FLastRecord.iType <> EMR_EoF) and
        (FInStream.Position < FInStream.Size) do
  begin
    FInStream.Position := FInStream.Position + FLastRecord.nSize;
    ReadCurrentRecord;
  end;
  if FLastRecord.iType <> EMR_EoF then
    raise Exception.Create('EMR_EoF not found')
  else
  begin
    EoFObj := TEoFObj.Create(FInStream, FLastRecord.nSize);
    SetLength(FDC.FData.EOFPalette, PLast^.Header.nPalEntries);
    for i := 0 to High(FDC.FData.EOFPalette) do
      FDC.FData.EOFPalette[i] := TColor(EoFObj.PaletteEntry[i]);
    EoFObj.Free;
  end;
  FInStream.Position := CurPos;
  FLastRecord.iType := EMR_Header; {!}
end;

procedure TEMFAbstractExport.SetParsing(const Value: WideString);
begin
  if ShowComments then
    FParsing := Value;
end;

procedure TEMFAbstractExport.TransformPoint(var DP: TfrxPoint);
begin
  with FDC do
    if EnableTransform and not IsXFormDefault then
    begin
      DP.X := XForm.eM11 * DP.X + XForm.eM12 * DP.Y + XForm.eDx;
      DP.Y := XForm.eM21 * DP.X + XForm.eM22 * DP.Y + XForm.eDy;
    end;
end;

{ TDeviceContext }

procedure TDeviceContext.CopyFrom(ADC: TObject);
begin
  FData := (ADC as TDeviceContext).FData;
end;

procedure TDeviceContext.DeleteObject(ih: LongWord);

  function IsIH(Obj: TEnhMetaObj): Boolean;
  begin
    Result := Assigned(Obj) and (Obj.P^.DeleteObject.ihObject = ih);
  end;

begin
  if      IsIH(FData.Pen) then        FData.Pen := nil
  else if IsIH(FData.Brush) then      FData.Brush := nil
  else if IsIH(FData.Font) then       FData.Font := nil
  else if IsIH(FData.Palette) then    FData.Palette := nil
  else if IsIH(FData.ColorSpace) then FData.ColorSpace := nil;
end;

function TDeviceContext.GetBkColor: TColor;
begin
  Result := TColor(FData.BkColor);
end;

function TDeviceContext.GetBrushColor: TColor;
begin
  if (FData.Brush = nil) or
     (FData.Brush.P^.EMR.iType <> EMR_CreateBrushIndirect) then
    Result := clWhite
  else if BrushStyle = BS_NULL then
    Result := clNone
  else
    Result := TColor(FData.Brush.P^.CreateBrushIndirect.lb.lbColor);
end;

function TDeviceContext.GetBrushHatch: LongWord;
begin
  if (FData.Brush = nil) or
     (FData.Brush.P^.EMR.iType <> EMR_CreateBrushIndirect) then
    Result := HS_HORIZONTAL
  else
    Result := FData.Brush.P^.CreateBrushIndirect.lb.lbHatch;
end;

function TDeviceContext.GetBrushStyle: LongWord;
begin
  if (FData.Brush = nil) or
     (FData.Brush.P^.EMR.iType <> EMR_CreateBrushIndirect) then
    Result := BS_SOLID
  else
    Result := FData.Brush.P^.CreateBrushIndirect.lb.lbStyle;
end;

function TDeviceContext.GetFontCharSet: byte;
begin
  if FData.Font = nil then
    Result := DEFAULT_CHARSET
  else
    Result := FData.Font.P^.ExtCreateFontIndirectW.elfw.elfLogFont.lfCharSet;
end;

function TDeviceContext.GetFontFamily: string;
begin
  if FData.Font = nil then
    Result := 'Serif'
  else
    with FData.Font.P^.ExtCreateFontIndirectW.elfw do
      Result := WideStringFromArray(Addr(elfLogFont.lfFaceName), LF_FACESIZE);
end;

function TDeviceContext.GetFontItalic: Boolean;
begin
  Result := (FData.Font <> nil) and
    (FData.Font.P^.ExtCreateFontIndirectW.elfw.elfLogFont.lfItalic = 1);
end;

function TDeviceContext.GetFontOrientation: integer;
begin
  if FData.Font = nil then
    Result := 0
  else
    with FData.Font.P^.ExtCreateFontIndirectW.elfw do
      Result := elfLogFont.lfEscapement; // specifies the angle, in tenths of degrees, between the escapement vector and the x-axis of the device. The escapement vector is parallel to the baseline of a row of text.
//      Result := elfLogFont.lfOrientation; // specifies the angle, in tenths of degrees, between each character's baseline and the x-axis of the device.
end;

function TDeviceContext.GetFontRadian: Extended;
begin
  Result := FontOrientation / 10.0 * Pi / 180.0;
end;

function TDeviceContext.GetFontSize: Integer;
begin
  if FData.Font = nil then
    Result := 12
  else
    with FData.Font.P^.ExtCreateFontIndirectW.elfw do
      Result := Abs(elfLogFont.lfHeight);
end;

function TDeviceContext.GetFontStrikeOut: Boolean;
begin
  Result := (FData.Font <> nil) and
    (FData.Font.P^.ExtCreateFontIndirectW.elfw.elfLogFont.lfStrikeOut = 1);
end;

function TDeviceContext.GetFontUnderline: Boolean;
begin
  Result := (FData.Font <> nil) and
    (FData.Font.P^.ExtCreateFontIndirectW.elfw.elfLogFont.lfUnderline = 1);
end;

function TDeviceContext.GetFontWeight: Integer;
begin
  if FData.Font = nil then
    Result := 400
  else
    Result := Abs(FData.Font.P^.ExtCreateFontIndirectW.elfw.elfLogFont.lfWeight);
end;

function TDeviceContext.GetHAlign: TfrxHAlign;
begin
  if      TextAlignmentMode and TA_CENTER = TA_CENTER then
    Result := haCenter
  else if TextAlignmentMode and TA_RIGHT = TA_RIGHT then
    Result := haRight
  else
    Result := haLeft;
end;

function TDeviceContext.GetLogPenStyle: LongWord;
begin
  if FData.Pen = nil then
    Result := PS_SOLID + PS_ENDCAP_FLAT + PS_JOIN_MITER
  else if FData.Pen.P^.EMR.iType = EMR_CreatePen then
    Result := FData.Pen.P^.CreatePen.lopn.lopnStyle
  else //if FData.Pen.P^.EMR.iType = EMR_ExtCreatePen then
    Result := FData.Pen.P^.ExtCreatePen.elp.elpPenStyle;
end;

function TDeviceContext.GetMiterLimit: Single;
var
  iMiterLimit: LongInt;
begin
  if FData.MiterLimit >= 1.0 then
    Result := FData.MiterLimit
  else
  begin
    Move(FData.MiterLimit, iMiterLimit, SizeOf(iMiterLimit));
    Result := iMiterLimit;
  end;
end;

function TDeviceContext.GetPenColor: TColor;
begin
  if FData.Pen = nil then
    Result := clBlack
  else if FData.Pen.P^.EMR.iType = EMR_CreatePen then
    Result := TColor(FData.Pen.P^.CreatePen.lopn.lopnColor)
  else //if FData.Pen.P^.EMR.iType = EMR_ExtCreatePen then
    Result := TColor(FData.Pen.P^.ExtCreatePen.elp.elpColor);
end;

function TDeviceContext.GetPenEndCap: LongWord;
begin
  Result := LogPenStyle and PS_ENDCAP_MASK;
end;

function TDeviceContext.GetPenLineJoin: LongWord;
begin
  Result := LogPenStyle and PS_JOIN_MASK;
end;

function TDeviceContext.GetPenStyle: LongWord;
begin
  Result := LogPenStyle and PS_STYLE_MASK;
end;

function TDeviceContext.GetPenType: LongWord;
begin
  Result := LogPenStyle and PS_TYPE_MASK;
end;

function TDeviceContext.GetPenWidth: Extended;
begin
  if (FData.Pen = nil){ or
     (PenType = PS_COSMETIC)} then
    Result := 1.0
  else if FData.Pen.P^.EMR.iType = EMR_CreatePen then
    Result := FData.Pen.P^.CreatePen.lopn.lopnWidth.X
  else //if FData.Pen.P^.EMR.iType = EMR_ExtCreatePen then
    Result := FData.Pen.P^.ExtCreatePen.elp.elpWidth;
end;

function TDeviceContext.GetTextColor: TColor;
begin
  Result := TColor(FData.TextColor);
end;

function TDeviceContext.GetVAlign: TfrxVAlign;
begin
  if      TextAlignmentMode and TA_BASELINE = TA_BASELINE then
    Result := vaCenter
  else if TextAlignmentMode and TA_BOTTOM = TA_BOTTOM then
    Result := vaBottom
  else
    Result := vaTop;
end;

procedure TDeviceContext.Init;
const
  UnitSize: TSize = (cx: 1; cy: 1);
begin
  FData.MapMode := MM_TEXT;
  FData.WindowOrgEx := Point(0, 0); FData.ViewPortOrgEx := Point(0, 0);
  FData.BrushOrgEx := Point(0, 0);
  FData.WindowExtEx := UnitSize; FData.ViewPortExtEx := UnitSize;
  FData.Pen := nil;
  FData.Brush := nil;
  FData.Font := nil;
  FData.Palette := nil;
  FData.ColorSpace := nil;
  FData.ColorAdjustment := nil;
  FData.PositionCurrent := Point(0, 0); FData.PositionNext := Point(0, 0);
  FData.BkMode := OPAQUE;
  FData.PolyFillMode := ALTERNATE;
  FData.MiterLimit := 4.0;
  FData.BkColor := $ffffff;
  FData.TextColor := 0;
  FData.SetRop2 := R2_COPYPEN;
  FData.ClipRgn := HRGN(nil);
  SetLength(FData.EOFPalette, 0);
  FData.StretchMode := BLACKONWHITE;
  FData.IsPathBracketOpened := False;
  FData.TextAlignmentMode := TA_LEFT + TA_TOP;
  FData.XForm := XFormDefault;
  FData.iArcDirection := AD_COUNTERCLOCKWISE;
end;

function TDeviceContext.IsXFormDefault: boolean;
const
  Eps = 1.0e-3;
begin
  with XFormDefault do
    Result := Abs(eM11 - XForm.eM11) + Abs(eM12 - XForm.eM12) +
              Abs(eM21 - XForm.eM21) + Abs(eM22 - XForm.eM22) +
              Abs(eDx  - XForm.eDx)  + Abs(eDy  - XForm.eDy)  < Eps;
end;

procedure TDeviceContext.SelectObject(ih: LongWord; EnhMetaObjArray: TEnhMetaObjArray);
begin
  if IsStockObject(ih) then
  begin
    if      IsStockPen(ih) then     FData.Pen := StockObject(ih)
    else if IsStockBrush(ih) then   FData.Brush := StockObject(ih)
    else if IsStockFont(ih) then    FData.Font := StockObject(ih)
    else if IsStockPalette(ih) then FData.Palette := StockObject(ih);
  end
  else if EnhMetaObjArray[ih] <> nil then
    with EnhMetaObjArray[ih].P^.EMR do
      if      iType in CreatePenSet then        FData.Pen := EnhMetaObjArray[ih]
      else if iType in CreateBrushSet then      FData.Brush := EnhMetaObjArray[ih]
      else if iType in CreateFontSet then       FData.Font := EnhMetaObjArray[ih]
      else if iType in CreatePaletteSet then    FData.Palette := EnhMetaObjArray[ih]
      else if iType in CreateColorSpaceSet then FData.ColorSpace := EnhMetaObjArray[ih];
end;

{ TQuickWideFragment }

procedure TQuickWideFragment.AddWide(s: WideString);
var
  i: integer;
begin
  for i := 1 to Length(s) do
  begin
    if FCount = Length(FText) then
      SetLength(FText, Length(FText) * 2);
    Inc(FCount);
    FText[FCount] := s[i];
  end;

end;

procedure TQuickWideFragment.AddWide(const Fmt: string; const Args: array of const);
begin
  AddWide(Format(Fmt, Args));
end;

constructor TQuickWideFragment.Create(MaxSize: integer = FragmentDefaultSize);
begin
  SetLength(FText, MaxSize);
  FCount := 0;
end;

procedure TQuickWideFragment.CutBy(Size: Integer);
begin
  FCount := Max(FCount - Size, 0);
end;

function TQuickWideFragment.GetText: WideString;
begin
  Result := FText;
  SetLength(Result, FCount);
end;

end.

