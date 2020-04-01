
{******************************************}
{                                          }
{             FastReport v6.0              }
{            EMF to PDF Export             }
{                                          }
{        Copyright (c) 2015 - 2019         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxEMFtoPDFExport;

interface

{$I frx.inc}

uses Windows, Graphics, Classes, frxExportHelpers, frxEMFAbstractExport,
  frxEMFFormat, frxExportPDFHelpers, frxClass;

type
  TBezierResult = record
    P0, P1, P2, P3: TfrxPoint;
  end;

  TPDFDeviceContext = class (TDeviceContext)
  protected
    FExtSelectClipRgnCreated: Boolean;
  public
    procedure CopyFrom(ADC: TObject); override;
    procedure Init; override;
  end;

  TPDFPath = class
  private
    FOutStream: TStream;
    FExists: Boolean;
  protected
    FStream: TMemoryStream;
  public
    constructor Create(AOutStream: TStream);
    destructor Destroy; override;

    procedure Put(const S: AnsiString);
    procedure Flush;

    property Exists: Boolean read FExists write FExists;
  end;

  TEMFtoPDFExport = class (TEMFAbstractExport)
  private
    FForceMitterLineJoin: Boolean;
    FForceButtLineCap: Boolean;
    FJPGQuality: integer;
    FForceNullBrush: Boolean;
    FTransparency: Boolean;
    FForceAnsi: Boolean;

    procedure Put(const S: AnsiString);
    procedure PutLn(const S: AnsiString); {$IFDEF Delphi12} overload;
    procedure PutLn(const S: String); overload; {$ENDIF}

    function pdfSize(emfSize: Extended): Extended;

    function pdfFrxPoint(emfP: TPoint): TfrxPoint; overload;
    function pdfFrxPoint(emfSP: TSmallPoint): TfrxPoint; overload;
    function pdfFrxPoint(emfDP: TfrxPoint): TfrxPoint; overload;

    function pdfFrxRect(emfR: TRect): TfrxRect;

//    function emfSize2Str(emfSize: Extended): String;

    function emfPoint2Str(emfP: TPoint): String; overload;
    function emfPoint2Str(emfSP: TSmallPoint): String; overload;
    function emfPoint2Str(emfFP: TfrxPoint): String; overload;

    function emfRect2Str(emfR: TRect): String;

    function EvenOdd: String;
    function IsNullBrush: Boolean;
    function IsNullPen: Boolean;

    function BezierCurve(Center, Radius: TfrxPoint; startAngle, arcAngle: Double): TBezierResult;
    procedure cmd_AngleArc(Center, Radius: TfrxPoint; StartAngle, SweepAngle: Single);
    procedure cmd_RoundRect(l, t, r, b, rx, ry: Extended);
    procedure cmdPathPainting(Options: integer; UseBkColor: Boolean = False);
    procedure cmdPathParams(Options: integer; UseBkColor: Boolean);
    procedure cmdSetClippingPath;
    procedure cmdCloseSubpath;
    procedure cmdAppendAngleArcToPath(AngleArc: TEMRAngleArc);
    procedure cmdAppendPieToPath(Pie: TEMRPie);
    procedure cmdAppendEllipsToPath(emfRect: TRect);
    procedure cmdAppendRectangleToPath(emfRect: TRect);
    procedure cmdAppendEMFRectangleToPath(emfRect: TRect);
    procedure cmdAppendRoundRectToPath(emfRect: TRect; emfCorners: TSize);

    procedure cmdMoveTo(X, Y: extended); overload;
    procedure cmdMoveTo(emfP: TPoint); overload;
    procedure cmdMoveTo(emfSP: TSmallPoint); overload;
    procedure cmdMoveTo(emfFP: TfrxPoint); overload;

    procedure cmdLineTo(X, Y: extended); overload;
    procedure cmdLineTo(emfP: TPoint); overload;
    procedure cmdLineTo(emfSP: TSmallPoint); overload;
    procedure cmdLineTo(emfDP: TfrxPoint); overload;
    procedure cmdSetLineDashPattern(PenStyle: LongWord; Width: Extended);
    procedure cmdSetStrokeColor(Color: TColor);
    procedure cmdSetFillColor(Color: TColor);
    procedure cmdSetLineWidth(Width: Extended); overload;
    procedure cmdSetLineWidth(PDFWidth: String); overload;
    procedure cmdSetMiterLimit(MiterLimit: Extended);
    procedure cmdSetLineCap(PenEndCap: Integer);
    procedure cmdSetLineJoin(PenLineJoin: Integer);
    procedure cmdAppendCurvedSegment2final(emfSP1, emfSP3: TSmallPoint); overload;
    procedure cmdAppendCurvedSegment2final(emfP1, emfP3: TPoint); overload;
    procedure cmdAppendCurvedSegment3(emfSP1, emfSP2, emfSP3: TSmallPoint); overload;
    procedure cmdAppendCurvedSegment3(emfP1, emfP2, emfP3: TPoint); overload;
    procedure cmdAppendCurvedSegment3(emfDP1, emfDP2, emfDP3: TfrxPoint); overload;
    procedure cmdPolyBezier(Options: integer = 0);
    procedure cmdPolyBezier16(Options: integer = 0);
    procedure cmdPolyLine(Options: integer = 0);
    procedure cmdPolyLine16(Options: integer = 0);
    procedure cmdPolyPolyLine(Options: integer = 0);
    procedure cmdPolyPolyLine16(Options: integer = 0);

    procedure cmdCreateExtSelectClipRgn;

    procedure cmdSaveGraphicsState;
    procedure cmdRestoreGraphicsState;

    procedure cmdBitmap(emfRect: TRect; dwRop: LongWord; EMRBitmap: TEMRBitmap);

    procedure cmdTranslationAndScaling(Sx, Sy, Tx, Ty: Extended);
  protected
    FPDFRect: TfrxRect;
    FEMFtoPDFFactor: TfrxPoint;
    FPOH: TPDFObjectsHelper;
    FRotation2D: TRotation2D;
    FRealizationList: TStringList;
    FqQBalance: Integer;
    FPdfA: Boolean;
    FPath: TPDFPath;

    procedure Comment(CommentString: String = ''); override;
    procedure CommentAboutRealization;
    procedure RealizationListFill(RealizedCommands: array of String);
    procedure DCCreate; override;
    function FontCreate: TFont; override;
    function PDFDeviceContext: TPDFDeviceContext;

    procedure DrawFontLines(FontSize: integer; TextPosition: TfrxPoint; TextWidth: Extended);
    procedure DrawFigureStart;
    procedure DrawFigureFinish(Options: integer);
    function FillStrokeOptions(Options: integer): integer;

    procedure DoEMR_AngleArc; override;
    procedure DoEMR_AlphaBlend; override;
    procedure DoEMR_BitBlt; override;
    procedure DoEMR_CloseFigure; override;
    procedure DoEMR_Ellipse; override;
    procedure DoEMR_EoF; override;
    procedure DoEMR_ExtSelectClipRgn; override;
    procedure DoEMR_ExtTextOutW; override;
    procedure DoEMR_FillPath; override;
    procedure DoEMR_Header; override;
    procedure DoEMR_IntersectClipRect; override;
    procedure DoEMR_LineTo; override;
    procedure DoEMR_MaskBlt; override;
    procedure DoEMR_MoveToEx; override;
    procedure DoEMR_Pie; override;
    procedure DoEMR_PolyBezier; override;
    procedure DoEMR_PolyBezier16; override;
    procedure DoEMR_PolyBezierTo; override;
    procedure DoEMR_PolyBezierTo16; override;
    procedure DoEMR_Polygon; override;
    procedure DoEMR_Polygon16; override;
    procedure DoEMR_Polyline; override;
    procedure DoEMR_Polyline16; override;
    procedure DoEMR_PolylineTo; override;
    procedure DoEMR_PolylineTo16; override;
    procedure DoEMR_PolyPolygon; override;
    procedure DoEMR_PolyPolygon16; override;
    procedure DoEMR_PolyPolyline; override;
    procedure DoEMR_PolyPolyline16; override;
    procedure DoEMR_Rectangle; override;
    procedure DoEMR_RestoreDC; override;
    procedure DoEMR_RoundRect; override;
    procedure DoEMR_SaveDC; override;
    procedure DoEMR_SelectClipPath; override;
    procedure DoEMR_StretchBlt; override;
    procedure DoEMR_StretchDIBits; override;
    procedure DoEMR_StrokeAndFillPath; override;
    procedure DoEMR_StrokePath; override;
    procedure DoEMR_TransparentBlt; override;

    procedure DoStart; override;
    procedure DoFinish; override;
  public
    constructor Create(InStream, OutStream: TStream; APDFRect: TfrxRect; APOH: TPDFObjectsHelper; APdfA: Boolean);
    destructor Destroy; override;

    property ForceMitterLineJoin: Boolean read FForceMitterLineJoin write FForceMitterLineJoin;
    property ForceButtLineCap: Boolean write FForceButtLineCap;
    property JPGQuality: integer write FJPGQuality;
    property ForceNullBrush: Boolean write FForceNullBrush;
    property Transparency: Boolean write FTransparency;
    property ForceAnsi: Boolean write FForceAnsi;
  end;

implementation

uses
  {$IFDEF Delphi12}pngimage{$ELSE}frxpngimage{$ENDIF},
  Contnrs, SysUtils, Types, Math, JPEG,
{$IFDEF DELPHI16}
  UITypes,
{$ENDIF} {It is necessary to prevent H2443}
  frxUtils, frxAnaliticGeometry;

const
  // Path-Painting Operators
  ppEnd = $0;
  ppClose = $1;
  ppStroke = $2;
  ppFill = $4;
  ppWithTo = $8; // To resets the current position

{ Utility routines }

function IsContain(const Options, Param: integer): Boolean;
begin
  Result := Options and Param = Param;
end;

function PenStyle2Str(PenStyle: LongWord; Width: Extended): String;
var
  Dash, Dot: string;
begin
  Dash := Float2Str(6 * Width) + ' ';
  Dot := Float2Str(2 * Width) + ' ';
  case PenStyle of
    PS_SOLID:
      Result := '';
    PS_DASH:
      Result := Dash;
    PS_DOT:
      Result := Dot + Dash;
    PS_DASHDOT:
      Result := Dash + Dash + Dot + Dash;
    PS_DASHDOTDOT:
      Result := Dash + Dash + Dot + Dash + Dot + Dash;
    PS_NULL:
      Result := '';
    PS_INSIDEFRAME:
      Result := '';
    PS_ALTERNATE:
      Result := Dot + Dot;
  else // PS_USERSTYLE:
    Result := Dash + Dot;
  end;
  if Result <> '' then
    Delete(Result, Length(Result), 1);
end;

{ TEMFtoPDFExport }

function TEMFtoPDFExport.BezierCurve(Center, Radius: TfrxPoint; StartAngle, ArcAngle: Double): TBezierResult;
  function Rad(Degree: Double): Extended;
  begin
    Result := Degree * Pi / 180;
  end;
var
  Cos1, Sin1, Cos2, Sin2, Aux, Alpha: Extended;
begin
  SinCos(Rad(StartAngle), Sin1, Cos1);
  SinCos(Rad(StartAngle + ArcAngle), Sin2, Cos2);

  //point p1. Start point
  Result.P0 := frxPoint(Center.X + Radius.X * Cos1, Center.Y - Radius.Y * Sin1);
  //point p2. End point
  Result.P3 := frxPoint(Center.X + Radius.X * Cos2, Center.Y - Radius.Y * Sin2);

  //Alpha constant
  Aux := Tan(Rad(ArcAngle / 2));
  Alpha := Sin(Rad(ArcAngle)) * (Sqrt(4 + 3 * Aux * Aux) - 1.0) / 3.0;

  //point q1. First control point
  Result.P1 := frxPoint(Result.P0.X - Alpha * Radius.X * Sin1,
                        Result.P0.Y - Alpha * Radius.Y * Cos1);
  //point q2. Second control point.
  Result.P2 := frxPoint(Result.P3.X + Alpha * Radius.X * Sin2,
                        Result.P3.Y + Alpha * Radius.Y * Cos2);
end;

procedure TEMFtoPDFExport.cmdAppendAngleArcToPath(AngleArc: TEMRAngleArc);
begin
  with AngleArc do
    cmd_AngleArc(ToFrxPoint(ptlCenter), frxPoint(nRadius, nRadius), eStartAngle, eSweepAngle);
end;

procedure TEMFtoPDFExport.cmdAppendCurvedSegment2final(emfSP1, emfSP3: TSmallPoint);
begin
  PutLn(emfPoint2Str(emfSP1) + ' ' + emfPoint2Str(emfSP3) + ' v');
end;

procedure TEMFtoPDFExport.cmdAppendCurvedSegment2final(emfP1, emfP3: TPoint);
begin
  PutLn(emfPoint2Str(emfP1) + ' ' + emfPoint2Str(emfP3) + ' v');
end;

procedure TEMFtoPDFExport.cmdAppendCurvedSegment3(emfDP1, emfDP2, emfDP3: TfrxPoint);
begin
  PutLn(emfPoint2Str(emfDP1) + ' ' + emfPoint2Str(emfDP2) + ' ' + emfPoint2Str(emfDP3) + ' c');
end;

procedure TEMFtoPDFExport.cmdAppendCurvedSegment3(emfP1, emfP2, emfP3: TPoint);
begin
  PutLn(emfPoint2Str(emfP1) + ' ' + emfPoint2Str(emfP2) + ' ' + emfPoint2Str(emfP3) + ' c');
end;

procedure TEMFtoPDFExport.cmdAppendCurvedSegment3(emfSP1, emfSP2, emfSP3: TSmallPoint);
begin
  PutLn(emfPoint2Str(emfSP1) + ' ' + emfPoint2Str(emfSP2) + ' ' + emfPoint2Str(emfSP3) + ' c');
end;

procedure TEMFtoPDFExport.cmdAppendEllipsToPath(emfRect: TRect);
begin
  with pdfFrxRect(emfRect) do
    cmd_RoundRect(Left, Top, Right, Bottom, (Right - Left) / 2, (Top - Bottom) / 2);
end;

procedure TEMFtoPDFExport.cmdAppendEMFRectangleToPath(emfRect: TRect);
begin
  EnableTransform := False;
  cmdAppendRectangleToPath(emfRect);
  EnableTransform := True;
end;

procedure TEMFtoPDFExport.cmdAppendPieToPath(Pie: TEMRPie);
var
  Center, Radius: TfrxPoint;
  StartAngle, EndAngle, SweepAngle: Extended;
begin
  with Pie do
  begin
    with rclBox do
    begin
      Center := frxPoint((Right + Left) / 2, (Bottom + Top) / 2);
      Radius := frxPoint((Right - Left) / 2, (Bottom - Top) / 2);
    end;

    StartAngle := ArcTan2(ptlStart.Y - Center.Y, ptlStart.X - Center.X) / Pi * 180;
    EndAngle := ArcTan2(ptlEnd.Y - Center.Y, ptlEnd.X - Center.X) / Pi * 180;
    SweepAngle := StartAngle - EndAngle;
    SweepAngle := IfReal(SweepAngle < 0, SweepAngle + 360, SweepAngle);

    cmd_AngleArc(Center, Radius, -StartAngle, SweepAngle);

    cmdLineTo(Center);
  end;
end;

procedure TEMFtoPDFExport.cmdAppendRectangleToPath(emfRect: TRect);
begin
  FPath.Exists := True;
  PutLn(emfRect2Str(emfRect) + ' re'); // Begin new subpath
end;

procedure TEMFtoPDFExport.cmdAppendRoundRectToPath(emfRect: TRect; emfCorners: TSize);
begin
  with pdfFrxRect(emfRect), emfCorners do
    cmd_RoundRect(Left, Top, Right, Bottom, pdfSize(cx) / 2, pdfSize(cy) / 2);
end;

procedure TEMFtoPDFExport.cmdBitmap(emfRect: TRect; dwRop: LongWord; EMRBitmap: TEMRBitmap);
var
  pdfRect: TfrxRect;
  TempBitmap: TBitMap;
  Jpg: TJPEGImage;
  XObjectStream: TMemoryStream;
  XObjectHash: TfrxPDFXObjectHash;
  PicIndex: Integer;
  PNGA: TPNGObject;
  Size: TSize;

  procedure ReferenceToXObject;
  begin
    FPOH.AddUsedObject(PicIndex);

    cmdSaveGraphicsState;
    cmdTranslationAndScaling(pdfRect.Right - pdfRect.Left,
      pdfRect.Top - pdfRect.Bottom, pdfRect.Left, pdfRect.Bottom);
    Putln('/Im' + IntToStr(PicIndex) + ' Do');
    cmdRestoreGraphicsState;
  end;

  procedure OutOpaque;
  begin
    TempBitmap := EMRBitmap.GetBitmap;
    try
      Jpg := TJPEGImage.Create;
      try
        Jpg.PixelFormat := jf24bit;
        Jpg.CompressionQuality := FJPGQuality;
        Jpg.Assign(TempBitmap);
        XObjectStream := TMemoryStream.Create;
        try
          Jpg.SaveToStream(XObjectStream);

          XObjectStream.Position := 0;
          GetStreamHash(XObjectHash, XObjectStream);
          PicIndex := FPOH.FindXObject(XObjectHash);

          if PicIndex = -1 then
            PicIndex := FPOH.OutXObjectImage(XObjectHash, Jpg, XObjectStream);

        finally
          XObjectStream.Free;
        end;
      finally
        Jpg.Free;
      end;
    finally
      TempBitmap.Free;
    end;
    ReferenceToXObject;
  end;

begin
  pdfRect := pdfFrxRect(emfRect);
  case dwRop of // https://msdn.microsoft.com/en-us/library/cc250408.aspx
    PATCOPY {P}:
      begin
        DrawFigureStart;

        cmdAppendRectangleToPath(emfRect);

        DrawFigureFinish(ppFill);
      end;
    $1FF0000: // 32 bit here
      if FTransparency then
      begin
        PNGA := TEMRAlphaBlendObj(EMRBitmap).GetPngObject;
        try
          Size.cx := Round(pdfRect.Right - pdfRect.Left);
          Size.cy := Round(pdfRect.Top - pdfRect.Bottom);
          PicIndex := FPOH.OutTransparentPNG(PNGA, Size);
        finally
          PNGA.Free;
        end;
        ReferenceToXObject;
      end
      else
        OutOpaque;
    SRCCOPY {S}, SRCPAINT {DSo}, SRCAND {DSa}, SRCINVERT {DSx}:
      OutOpaque;
    $AA0029: {D}
      begin
        // Do nothing
      end;
  else
    Comment(' Unsupported dwRop: ' + IntToStr(dwRop));
  end;
end;

procedure TEMFtoPDFExport.cmdCloseSubpath;
begin
  PutLn('h');
end;

procedure TEMFtoPDFExport.cmdCreateExtSelectClipRgn;
var
  PRegionData: PRgnData;
  Size, i: Integer;
  R: TRect;
begin
  if FDC.ClipRgn <> HRGN(nil) then
  begin
    Size := GetRegionData(FDC.ClipRgn, 0, nil);
    if Size > 0 then
    begin
      GetMem(PRegionData, Size);
      try
        GetRegionData(FDC.ClipRgn, Size, PRegionData);
        for i := 0 to PRegionData^.rdh.nCount - 1 do
        begin
          Move(PRegionData^.Buffer[i * SizeOf(TRect)], R, SizeOf(TRect));
          cmdAppendEMFRectangleToPath(R);
        end;
        cmdSetClippingPath;
        cmdPathPainting(ppEnd);
      finally
        FreeMem(PRegionData, Size);
      end;
    end;
  end;
end;

procedure TEMFtoPDFExport.cmdLineTo(emfDP: TfrxPoint);
begin
  PutLn(emfPoint2Str(emfDP) + ' l'); // Append straight line segment to path
end;

procedure TEMFtoPDFExport.cmdLineTo(emfP: TPoint);
begin
  PutLn(emfPoint2Str(emfP) + ' l'); // Append straight line segment to path
end;

procedure TEMFtoPDFExport.cmdLineTo(emfSP: TSmallPoint);
begin
  PutLn(emfPoint2Str(emfSP) + ' l'); // Append straight line segment to path
end;

procedure TEMFtoPDFExport.cmdLineTo(X, Y: extended);
begin
  PutLn(frxPoint2Str(X, Y) + ' l'); // Append straight line segment to path
end;

procedure TEMFtoPDFExport.cmdMoveTo(emfFP: TfrxPoint);
begin
  FPath.Exists := True;
  PutLn(emfPoint2Str(emfFP) + ' m'); // Begin new subpath
end;

procedure TEMFtoPDFExport.cmdMoveTo(emfP: TPoint);
begin
  FPath.Exists := True;
  PutLn(emfPoint2Str(emfP) + ' m'); // Begin new subpath
end;

procedure TEMFtoPDFExport.cmdMoveTo(emfSP: TSmallPoint);
begin
  FPath.Exists := True;
  PutLn(emfPoint2Str(emfSP) + ' m'); // Begin new subpath
end;

procedure TEMFtoPDFExport.cmdMoveTo(X, Y: extended);
begin
  FPath.Exists := True;
  PutLn(frxPoint2Str(X, Y) + ' m'); // Begin new subpath
end;

procedure TEMFtoPDFExport.cmdPathPainting(Options: integer; UseBkColor: Boolean = False);
begin
  FPath.Exists := False;

  cmdPathParams(Options, UseBkColor);

  FPath.Flush;

  case Options of
    ppEnd:              PutLn('n');
    ppStroke:           PutLn('S');
    ppStroke + ppClose: PutLn('s');
    ppFill, ppFill + ppClose:    PutLn('f' + EvenOdd);
    ppFill + ppStroke:           PutLn('B' + EvenOdd);
    ppFill + ppStroke + ppClose: PutLn('b' + EvenOdd);
  else
    raise Exception.Create('Invalid Patch Painting');
  end;
end;

procedure TEMFtoPDFExport.cmdPathParams(Options: integer; UseBkColor: Boolean);
begin
  if IsContain(Options, ppFill) then
    if UseBkColor then
      cmdSetFillColor(FDC.BkColor)
    else
      cmdSetFillColor(FDC.BrushColor);

  if IsContain(Options, ppStroke) then
  begin
    cmdSetLineDashPattern(FDC.PenStyle, pdfSize(FDC.PenWidth));
    cmdSetStrokeColor(FDC.PenColor);
    cmdSetLineWidth(pdfSize(FDC.PenWidth));
    cmdSetMiterLimit(FDC.MiterLimit);
    cmdSetLineCap(FDC.PenEndCap);
    cmdSetLineJoin(FDC.PenLineJoin);
  end;
end;

procedure TEMFtoPDFExport.cmdPolyBezier(Options: integer);
var
  Point: integer;
begin
  with PLast^ do
  begin
    if IsContain(Options, ppWithTo) then
      Point := 0
    else
      begin
        cmdMoveTo(Polyline.aptl[0]);
        Point := 1;
      end;
    while True do
      case Integer(Polyline.cptl) - Point of
        0, 1:
          Break;
        2, 4:
          begin
            cmdAppendCurvedSegment2final(Polyline.aptl[Point],
              Polyline.aptl[Point + 1]);
            Inc(Point, 2);
          end;
      else
        cmdAppendCurvedSegment3(Polyline.aptl[Point],
          Polyline.aptl[Point + 1], Polyline.aptl[Point + 2]);
        Inc(Point, 3);
      end;
  end;
end;

procedure TEMFtoPDFExport.cmdPolyBezier16(Options: integer = 0);
var
  Point: integer;
begin
  with PLast^ do
  begin
    if IsContain(Options, ppWithTo) then
      Point := 0
    else
      begin
        cmdMoveTo(Polyline16.apts[0]);
        Point := 1;
      end;
    while True do
      case Integer(Polyline16.cpts) - Point of
        0, 1:
          Break;
        2, 4:
          begin
            cmdAppendCurvedSegment2final(Polyline16.apts[Point],
              Polyline16.apts[Point + 1]);
            Inc(Point, 2);
          end;
      else
        cmdAppendCurvedSegment3(Polyline16.apts[Point],
          Polyline16.apts[Point + 1], Polyline16.apts[Point + 2]);
        Inc(Point, 3);
      end;
  end;
end;

procedure TEMFtoPDFExport.cmdPolyLine(Options: integer);
var
  Point: integer;
begin
  with PLast^ do
  begin
    if IsContain(Options, ppWithTo) then
      cmdLineTo(Polyline.aptl[0])
    else
      cmdMoveTo(Polyline.aptl[0]);
    for Point := 1 to Polyline.cptl - 1 do
      cmdLineTo(Polyline.aptl[Point])
  end;
  if IsContain(Options, ppClose) then
    cmdCloseSubpath;
end;

procedure TEMFtoPDFExport.cmdPolyLine16(Options: integer = 0);
var
  Point: integer;
begin
  with PLast^ do
  begin
    if IsContain(Options, ppWithTo) then
      cmdLineTo(Polyline16.apts[0])
    else
      cmdMoveTo(Polyline16.apts[0]);
    for Point := 1 to Polyline16.cpts - 1 do
      cmdLineTo(Polyline16.apts[Point])
  end;
  if IsContain(Options, ppClose) then
    cmdCloseSubpath;
end;

procedure TEMFtoPDFExport.cmdPolyPolyLine(Options: integer);
var
  Poly, Point: integer;
begin
  with FEMRList.Last as TEMRPolyPolygonObj do
  begin
    for Poly := 0 to P^.PolyPolygon.nPolys - 1 do
    begin
      if IsContain(Options, ppWithTo) then
        cmdLineTo(PolyPoint[Poly, 0])
      else
        cmdMoveTo(PolyPoint[Poly, 0]);
      for Point := 1 to P^.PolyPolygon.aPolyCounts[Poly] - 1 do
        cmdLineTo(PolyPoint[Poly, Point]);
    end;
  end;
  if IsContain(Options, ppClose) then
    cmdCloseSubpath;
end;

procedure TEMFtoPDFExport.cmdPolyPolyLine16(Options: integer);
var
  Poly, Point: integer;
begin
  with FEMRList.Last as TEMRPolyPolygon16Obj do
  begin
    for Poly := 0 to P^.PolyPolygon16.nPolys - 1 do
    begin
      if IsContain(Options, ppWithTo) then
        cmdLineTo(PolyPoint[Poly, 0])
      else
        cmdMoveTo(PolyPoint[Poly, 0]);
      for Point := 1 to P^.PolyPolygon16.aPolyCounts[Poly] - 1 do
        cmdLineTo(PolyPoint[Poly, Point]);
    end;
  end;
  if IsContain(Options, ppClose) then
    cmdCloseSubpath;
end;

procedure TEMFtoPDFExport.cmdRestoreGraphicsState;
begin
  PutLn('Q');
  FqQBalance := FqQBalance - 1;
end;

procedure TEMFtoPDFExport.cmdSaveGraphicsState;
begin
  PutLn('q');
  FqQBalance := FqQBalance + 1;
end;

procedure TEMFtoPDFExport.cmdSetClippingPath;
begin
  PutLn('W' + EvenOdd);
end;

procedure TEMFtoPDFExport.cmdSetFillColor(Color: TColor);
begin
  PutLn(Color2Str(Color) + ' rg'); // Set RGB color for nonstroking operations
end;

procedure TEMFtoPDFExport.cmdSetLineCap(PenEndCap: Integer);
begin
  if FForceButtLineCap then
    PutLn('2 J')
  else
    case FDC.PenEndCap of
      PS_ENDCAP_ROUND:
        PutLn('1 J');
      PS_ENDCAP_SQUARE:
        PutLn('2 J');
    else // PS_ENDCAP_FLAT
        PutLn('0 J');
    end;
end;

procedure TEMFtoPDFExport.cmdSetLineDashPattern(PenStyle: LongWord; Width: Extended);
begin
  PutLn('[' + PenStyle2Str(PenStyle, Width) + '] 0 d');
end;

procedure TEMFtoPDFExport.cmdSetLineJoin(PenLineJoin: Integer);
begin
  if FForceMitterLineJoin then
    PutLn('0 j')
  else
    case FDC.PenLineJoin of
      PS_JOIN_ROUND:
        PutLn('1 j');
      PS_JOIN_BEVEL:
        PutLn('2 j');
    else // PS_JOIN_MITER
        PutLn('0 j');
    end;

end;

procedure TEMFtoPDFExport.cmdSetLineWidth(PDFWidth: String);
begin
  PutLn(PDFWidth + ' w');
end;

procedure TEMFtoPDFExport.cmdSetLineWidth(Width: Extended);
begin
  cmdSetLineWidth(Float2Str(Width));
end;

procedure TEMFtoPDFExport.cmdSetMiterLimit(MiterLimit: Extended);
begin
  PutLn(Float2Str(MiterLimit) + ' M');
end;

procedure TEMFtoPDFExport.cmdSetStrokeColor(Color: TColor);
begin
  PutLn(Color2Str(Color) + ' RG'); // Set RGB color for stroking operations
end;

procedure TEMFtoPDFExport.cmdTranslationAndScaling(Sx, Sy, Tx, Ty: Extended);
begin
  PutLn(Float2Str(Sx) + ' 0 0 ' + Float2Str(Sy) + ' ' +
        Float2Str(Tx) + ' ' + Float2Str(Ty) + ' cm');
end;

procedure TEMFtoPDFExport.cmd_AngleArc(Center, Radius: TfrxPoint; StartAngle, SweepAngle: Single);
const
  MaxAnglePerCurve = 60;
var
  n, i: Integer;
  ActualArcAngle: Double;
  Bezier: TBezierResult;
begin
  n := Ceil(Abs(SweepAngle / MaxAnglePerCurve));
  ActualArcAngle := SweepAngle / n;
  for i := 0 to n - 1 do
  begin
    Bezier := BezierCurve(Center, Radius, StartAngle + i * ActualArcAngle, ActualArcAngle);
  	if i = 0 then
      cmdMoveTo(Bezier.P0);
    cmdAppendCurvedSegment3(Bezier.P1, Bezier.P2, Bezier.P3);
  end;
end;

procedure TEMFtoPDFExport.cmd_RoundRect(l, t, r, b, rx, ry: Extended);
  procedure Corner(x1, y1, x2, y2, x3, y3: Extended);
  begin
    PutLn(Float2Str(x1) + ' ' + Float2Str(y1) + ' ' + Float2Str(x2) + ' ' +
          Float2Str(y2) + ' ' + Float2Str(x3) + ' ' + Float2Str(y3) + '  c');
  end;
begin
  CmdMoveTo(l + rx, b);
  CmdLineTo(r - rx, b); // bottom
  Corner(r - rx / 2, b, r, b + ry / 2, r, b + ry);  // right-bottom
  CmdLineTo(r, t - ry); // right
  Corner(r, t - ry / 2, r - rx / 2, t, r - rx, t);  // right-top
  CmdLineTo(l + rx, t); // top
  Corner(l + rx / 2, t, l, t - ry / 2, l, t - ry);  // left-top
  CmdLineTo(l, b + ry); // left
  Corner(l, b + ry / 2, l + rx / 2, b, l + rx, b);  // left-bottom
end;

procedure TEMFtoPDFExport.Comment(CommentString: String);
begin
  if CommentString <> '' then
    PutLn('%--'+ CommentString)
  else if ShowComments then
  begin
    CommentAboutRealization;
    PutLn('%--' + Parsing);
  end;
end;

procedure TEMFtoPDFExport.CommentAboutRealization;
var
  CommandName, Value: String;
  i: integer;
begin
  CommandName := Copy(Parsing, 1, Pos(' ', Parsing + ' ') - 1);
  if FRealizationList.IndexOf(CommandName) <> -1 then // OK
    Exit;
  i := FRealizationList.IndexOfName(CommandName);
  Value := IfStr(i <> -1, FRealizationList.ValueFromIndex[i], '0');
  PutLn('% Realization: ' + Value);
end;

constructor TEMFtoPDFExport.Create(InStream, OutStream: TStream; APDFRect: TfrxRect; APOH: TPDFObjectsHelper; APdfA: Boolean);
begin
  inherited Create(InStream, OutStream);
  FPDFRect := APDFRect;
  FPOH := APOH;
  FPdfA := APdfA;

  FJPGQuality := 90;
  FForceMitterLineJoin := False;
  FForceButtLineCap := False;
  FForceNullBrush := False;
  FForceAnsi := False;

  FRotation2D := TRotation2D.Create;
  FPath := TPDFPath.Create(FOutStream);

  FRealizationList := TStringList.Create;
  FRealizationList.NameValueSeparator := '=';
  RealizationListFill([
    'EMR_AbortPath=?',
    'EMR_AngleArc',
    'EMR_AlphaBlend',
    'EMR_BeginPath',
    'EMR_BitBlt',
    'EMR_BrushOrgEx',
    'EMR_CloseFigure',
    'EMR_CreateBrushIndirect',
    'EMR_CreatePen',
    'EMR_DeleteObject',
    'EMR_Ellipse',
    'EMR_EndPath',
    'EMR_EoF',
    'EMR_ExtCreateFontIndirectW',
    'EMR_ExtCreatePen',
    'EMR_ExtSelectClipRgn',
    'EMR_ExtTextOutW',
    'EMR_FillPath',
    'EMR_GDIComment',
    'EMR_Header',
    'EMR_IntersectClipRect=?',
    'EMR_LineTo',
    'EMR_MaskBlt',
    'EMR_ModifyWorldTransform',
    'EMR_MoveToEx',
    'EMR_PolyBezier',
    'EMR_PolyBezier16',
    'EMR_PolyBezierTo',
    'EMR_PolyBezierTo16',
    'EMR_Polygon',
    'EMR_Polygon16',
    'EMR_Polyline',
    'EMR_Polyline16',
    'EMR_PolylineTo',
    'EMR_PolylineTo16',
    'EMR_PolyPolygon',
    'EMR_PolyPolygon16',
    'EMR_PolyPolyline',
    'EMR_PolyPolyline16',
    'EMR_Rectangle',
    'EMR_RestoreDC',
    'EMR_RoundRect',
    'EMR_SaveDC',
    'EMR_SelectClipPath',
    'EMR_SelectObject',
    'EMR_SetBkColor',
    'EMR_SetBkMode',
    'EMR_SetICMMode',
    'EMR_SetLayout',
    'EMR_SetMetaRgn',
    'EMR_SetMiterLimit',
    'EMR_SetPolyFillMode',
    'EMR_SetRop2',
    'EMR_SetTextAlign',
    'EMR_SetTextColor',
    'EMR_SetStretchBltMode',
    'EMR_SetWorldTransform',
    'EMR_StretchDIBits',
    'EMR_StretchBlt',
    'EMR_StrokeAndFillPath',
    'EMR_StrokePath',
    'EMR_TransparentBlt'
  ]);
end;

procedure TEMFtoPDFExport.DCCreate;
begin
  FDC := TPDFDeviceContext.Create;
end;

destructor TEMFtoPDFExport.Destroy;
begin
  FPath.Free;
  FRotation2D.Free;
  FRealizationList.Free;
  inherited;
end;

procedure TEMFtoPDFExport.DoEMR_AlphaBlend;
begin
  inherited;

  with PLast^.AlphaBlend do
    cmdBitMap(Bounds(xDest, yDest, cxDest, cyDest), dwRop,
      FEMRList.Last as TEMRAlphaBlendObj);
end;

procedure TEMFtoPDFExport.DoEMR_AngleArc;
begin
  inherited;

  DrawFigureStart;

  with PLast^ do
    cmdAppendAngleArcToPath(AngleArc);

  DrawFigureFinish(ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_BitBlt;
begin
  inherited;

  with PLast^.BitBlt do
    cmdBitMap(Bounds(xDest, yDest, cxDest, cyDest), dwRop, FEMRList.Last as TEMRBitBltObj);
end;

procedure TEMFtoPDFExport.DoEMR_CloseFigure;
begin
  inherited;

  cmdCloseSubpath;
end;

procedure TEMFtoPDFExport.DoEMR_Ellipse;
begin
  inherited;

  DrawFigureStart;

  with PLast^ do
    cmdAppendEllipsToPath(Ellipse.rclBox);

  DrawFigureFinish(ppFill + ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_EoF;
begin                    
  inherited;

  if FPath.Exists then
    cmdPathPainting(ppEnd);

  if PDFDeviceContext.FExtSelectClipRgnCreated then
    cmdRestoreGraphicsState;

  while FqQBalance > 0 do
    cmdRestoreGraphicsState;
end;

procedure TEMFtoPDFExport.DoEMR_ExtSelectClipRgn;
begin                    
  inherited;

  if PDFDeviceContext.FExtSelectClipRgnCreated then
    cmdRestoreGraphicsState
  else
    PDFDeviceContext.FExtSelectClipRgnCreated := True;

  cmdSaveGraphicsState;
  cmdCreateExtSelectClipRgn;
end;

procedure TEMFtoPDFExport.DoEMR_ExtTextOutW;

  procedure DrawTextRotation(var TextPosition: TfrxPoint);
  begin
    FRotation2D.Init(FDC.FontRadian, frxPoint(0.0, 0.0));
    PutLn(FRotation2D.Matrix + ' cm');
    TextPosition := FRotation2D.Turn(TextPosition);
  end;

var
  OutputString: WideString;
  RS: TRemapedString;
  pdfFont: TfrxPDFFont;
  RTLReading: Boolean;
  Font: TFont;
  FontIndex: Integer;
  pdfTextPosition: TfrxPoint;
  Simulation: String;
  SimulateBold: Boolean;
  Corr: TfrxPoint;
  EMRExtTextOutWObj: TEMRExtTextOutWObj;
  IsRTL, IsGlyphOut: Boolean;
  OutputDx: TLongWordArray;
  DxFactor: Extended;
  SkipFirstDx: Boolean;
const
  YCorr: array[TfrxVAlign] of Extended = (0.92, -0.92{ not tested }, 0.0);
  XCorr: array[TfrxHalign] of Extended = (0.0, -1.0, -0.5, 0.0);
begin
  inherited;
  EMRExtTextOutWObj := FEMRList.Last as TEMRExtTextOutWObj;
  OutputDx := EMRExtTextOutWObj.OutputDx;

  IsRTL := IsContain(PLast^.ExtTextOutW.emrtext.fOptions, ETO_RTLREADING)
        or IsContain(FDC.TextAlignmentMode, TA_RTLREADING)
        or IsContain(FDC.Layout, LAYOUT_RTL)
        or (FDC.FontCharSet in [ARABIC_CHARSET, HEBREW_CHARSET]);
  IsGlyphOut := not IsRTL and
    IsContain(PLast^.ExtTextOutW.emrtext.fOptions, ETO_GLYPH_INDEX);
  { disable back conversion in OutputString }
  if IsGlyphOut then
    PLast^.ExtTextOutW.emrtext.fOptions := PLast^.ExtTextOutW.emrtext.fOptions and not ETO_GLYPH_INDEX;
  OutputString := EMRExtTextOutWObj.OutputString(FDC.FontFamily, IsRTL);
  if OutputString = '' then
    Exit;
  cmdSaveGraphicsState;

  with PLast^.ExtTextOutW do
    if IsContain(emrtext.fOptions, ETO_OPAQUE) then
    begin
      cmdAppendRectangleToPath(emrtext.rcl);
      cmdPathPainting(ppFill, True); // Use BkColor
    end;

  with PLast^.ExtTextOutW do
    if IsContain(emrtext.fOptions, ETO_CLIPPED) then
    begin
      cmdAppendRectangleToPath(emrtext.rcl);
      cmdSetClippingPath;
      cmdPathPainting(ppEnd);
    end;

  Font := FontCreate;
  FontIndex := FPOH.GetObjFontNumber(Font);
  pdfFont := FPOH.PageFonts[FontIndex];

  Corr.X := Sin(FDC.FontRadian) * YCorr[FDC.VAlign] * FDC.FontSize
          + Cos(FDC.FontRadian) * XCorr[FDC.HAlign] * EMRExtTextOutWObj.TextLength;
  Corr.Y := Cos(FDC.FontRadian) * YCorr[FDC.VAlign] * FDC.FontSize +
          - Sin(FDC.FontRadian) * XCorr[FDC.HAlign] * EMRExtTextOutWObj.TextLength;
  with PLast^.ExtTextOutW.emrtext.ptlReference do
    pdfTextPosition := frxPoint(X + Corr.X, Y + Corr.Y);
  pdfTextPosition := pdfFrxPoint(pdfTextPosition);

  if FDC.FontOrientation <> 0 then
    DrawTextRotation(pdfTextPosition);

  if FPath.Exists then
    cmdPathPainting(ppEnd);

  PutLn('BT'); // Begin text object

  PutLn(FPOH.Fonts[FontIndex].Name + AnsiString(' ' + IntToStr(Font.Size) + ' Tf')); // Set text font and size
  PutLn('[] 0 d');
  cmdSetFillColor(Font.Color);

  PutLn(frxPoint2Str(pdfTextPosition) + ' Td'); // Move text position

  RTLReading := FDC.TextAlignmentMode and TA_RTLREADING = TA_RTLREADING;

  pdfFont.ForceAnsi := FForceAnsi;
  try
    RS := pdfFont.SoftRemapString(OutputString, RTLReading, FPdfA, IsGlyphOut);
  finally
    pdfFont.ForceAnsi := False;
  end;

  if IsNeedsItalicSimulation(Font, Simulation) then
    PutLn(Simulation + ' ' + frxPoint2Str(pdfTextPosition) + ' Tm');
  SimulateBold := IsNeedsBoldSimulation(Font, Simulation);
  if SimulateBold then
    PutLn(Simulation);

  DxFactor := pdfSize(1) * 1000 / Font.Size;
  SkipFirstDx := PLast^.ExtTextOutW.rclBounds.Left = 2; // Empirically
  if IsRTL or not RS.IsValidCharWidth then
    PutLn('<' + StrToHex(RS.Data) + '> Tj') // Show text
  else
    PutLn('[<' + StrToHexDx(RS.Data, OutputDx, DxFactor, SkipFirstDx,
                            RS.CharWidth) + '>] TJ');

  PutLn('ET'); // End text object

  if SimulateBold then
    PutLn('0 Tr');

  if FDC.FontUnderline or FDC.FontStrikeOut then
    DrawFontLines(Font.Size, pdfTextPosition, pdfSize(EMRExtTextOutWObj.TextLength));

  cmdRestoreGraphicsState;

  Font.Free;
end;

procedure TEMFtoPDFExport.DoEMR_FillPath;
begin
  inherited;

  cmdPathPainting(ppFill);
end;

procedure TEMFtoPDFExport.DoEMR_Header;
var                      
  rWidth, rHeight: double;
begin
  inherited;

  with PLast^.Header do
  begin
    rWidth := szlDevice.cx / szlMillimeters.cx * (rclFrame.Right - rclFrame.Left) / 100;
    rHeight := szlDevice.cy / szlMillimeters.cy * (rclFrame.Bottom - rclFrame.Top) / 100;
  end;

  FEMFtoPDFFactor := frxPoint(
    (FPDFRect.Right - FPDFRect.Left) / rWidth,
    (FPDFRect.Top - FPDFRect.Bottom) / rHeight);

  FqQBalance := 0;
end;

procedure TEMFtoPDFExport.DoEMR_IntersectClipRect;
begin
  inherited;

//  with PLast^.IntersectClipRect.rclClip do
//    if (Right = Left) or (Bottom = Top) then
//      Exit;
//  cmdAppendEMFRectangleToPath(PLast^.IntersectClipRect.rclClip);
//  cmdSetClippingPath;
//  cmdPathPainting(ppEnd);
end;

procedure TEMFtoPDFExport.DoEMR_LineTo;
begin
  inherited;
  // Specifies a line from the current position up to the specified point.

  DrawFigureStart;

  cmdLineTo(FDC.PositionNext);

  DrawFigureFinish(ppStroke + ppWithTo);
end;

procedure TEMFtoPDFExport.DoEMR_MaskBlt;
begin
  inherited;

  with PLast^.MaskBlt do
    cmdBitMap(Bounds(xDest, yDest, cxDest, cyDest), dwRop, FEMRList.Last as TEMRBitBltObj);
end;

procedure TEMFtoPDFExport.DoEMR_MoveToEx;
begin
  inherited;

  cmdMoveTo(FDC.PositionNext);
end;

procedure TEMFtoPDFExport.DoEMR_Pie;
begin
  inherited;

  DrawFigureStart;

  with PLast^ do
    cmdAppendPieToPath(Pie);

  DrawFigureFinish(ppClose + ppFill + ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_PolyBezier;
begin
  inherited;

  DrawFigureStart;

  cmdPolyBezier;

  DrawFigureFinish(ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_PolyBezier16;
begin
  inherited;
  // The curves are drawn using the current pen.

  DrawFigureStart;

  cmdPolyBezier16;

  DrawFigureFinish(ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_PolyBezierTo;
begin
  inherited;

  DrawFigureStart;

  cmdPolyBezier(ppWithTo);

  DrawFigureFinish(ppStroke + ppWithTo);
end;

procedure TEMFtoPDFExport.DoEMR_PolyBezierTo16;
begin
  inherited;
// Specifies one or more Bezier curves based on the current position.

  DrawFigureStart;

  cmdPolyBezier16(ppWithTo);

  DrawFigureFinish(ppStroke + ppWithTo);
end;

procedure TEMFtoPDFExport.DoEMR_Polygon;
begin
  inherited;

  if PLast^.Polyline.cptl > 1 then
  begin
    DrawFigureStart;

    cmdPolyLine(ppClose);

    DrawFigureFinish(ppFill + ppStroke);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_Polygon16;
begin
  inherited;
// The polygon SHOULD be outlined using the current pen and filled using
// the current brush and polygon fill mode. The polygon SHOULD be closed
// automatically by drawing a line from the last vertex to the first.

  if PLast^.Polyline16.cpts > 1 then
  begin
    DrawFigureStart;

    cmdPolyLine16(ppClose);

    DrawFigureFinish(ppFill + ppStroke);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_Polyline;
begin
  inherited;

  if PLast^.Polyline.cptl > 1 then
  begin
    DrawFigureStart;

    cmdPolyLine;

    DrawFigureFinish(ppStroke);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_Polyline16;
begin
  inherited;

  if PLast^.Polyline16.cpts > 1 then
  begin
    DrawFigureStart;

    cmdPolyLine16;

    DrawFigureFinish(ppStroke);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_PolylineTo;
begin
  inherited;

  if PLast^.Polyline.cptl > 1 then
  begin
    DrawFigureStart;

    cmdPolyLine(ppWithTo);

    DrawFigureFinish(ppStroke + ppWithTo);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_PolylineTo16;
begin
  inherited;

  if PLast^.Polyline16.cpts > 1 then
  begin
    DrawFigureStart;

    cmdPolyLine16(ppWithTo);

    DrawFigureFinish(ppStroke + ppWithTo);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_PolyPolygon;
begin
  inherited;

  if PLast^.PolyPolyline.nPolys > 0 then
  begin
    DrawFigureStart;

    cmdPolyPolyLine(ppClose);

    DrawFigureFinish(ppFill + ppStroke);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_PolyPolygon16;
begin
  inherited;

  if PLast^.PolyPolyline16.nPolys > 0 then
  begin
    DrawFigureStart;

    cmdPolyPolyLine16(ppClose);

    DrawFigureFinish(ppFill + ppStroke);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_PolyPolyline;
begin
  inherited;

  if PLast^.PolyPolyline.nPolys > 0 then
  begin
    DrawFigureStart;

    cmdPolyPolyLine(ppEnd);

    DrawFigureFinish(ppStroke);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_PolyPolyline16;
begin
  inherited;

  if PLast^.PolyPolyline16.nPolys > 0 then
  begin
    DrawFigureStart;

    cmdPolyPolyLine16(ppEnd);

    DrawFigureFinish(ppStroke);
  end;
end;

procedure TEMFtoPDFExport.DoEMR_Rectangle;
begin
  inherited;

  DrawFigureStart;

  cmdAppendRectangleToPath(PLast^.Rectangle.rclBox);

  DrawFigureFinish(ppFill + ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_RestoreDC;
var
  i: integer;
begin
  if PDFDeviceContext.FExtSelectClipRgnCreated then
  begin
    PDFDeviceContext.FExtSelectClipRgnCreated := False;
    cmdRestoreGraphicsState;
  end;

  inherited;

  for i := PLast^.RestoreDC.iRelative to -1 do
    cmdRestoreGraphicsState;
end;

procedure TEMFtoPDFExport.DoEMR_RoundRect;
begin
  inherited;

  DrawFigureStart;

  with PLast^ do
    cmdAppendRoundRectToPath(RoundRect.rclBox, RoundRect.szlCorner);

  DrawFigureFinish(ppFill + ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_SaveDC;
begin
  inherited;

  cmdSaveGraphicsState;
end;

procedure TEMFtoPDFExport.DoEMR_SelectClipPath;
begin
  inherited;

  cmdSetClippingPath;
  cmdPathPainting(ppEnd);
end;

procedure TEMFtoPDFExport.DoEMR_StretchBlt;
begin
  inherited;

  with PLast^.StretchBlt do
    cmdBitMap(Bounds(xDest, yDest, cxDest, cyDest), dwRop, FEMRList.Last as TEMRStretchBltObj);
end;

procedure TEMFtoPDFExport.DoEMR_StretchDIBits;
begin
  inherited;

  with PLast^.StretchDIBits do
    cmdBitMap(Bounds(xDest, yDest, cxDest, cyDest), dwRop, FEMRList.Last as TEMRStretchDIBitsObj);
end;

procedure TEMFtoPDFExport.DoEMR_StrokeAndFillPath;
begin
  inherited;

  cmdPathPainting(ppFill + ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_StrokePath;
begin
  inherited;

  cmdPathPainting(ppStroke);
end;

procedure TEMFtoPDFExport.DoEMR_TransparentBlt;
begin
  inherited;

  with PLast^.BitBlt do
    cmdBitMap(Bounds(xDest, yDest, cxDest, cyDest), dwRop, FEMRList.Last as TEMRBitBltObj);
end;

procedure TEMFtoPDFExport.DoFinish;
begin
  inherited;

  cmdRestoreGraphicsState;
end;

procedure TEMFtoPDFExport.DoStart;
begin        // Before EMR_Header
  inherited;

  cmdSaveGraphicsState;

  PutLn(frxRect2Str(FPDFRect) + ' re');

  cmdSetClippingPath;
  cmdPathPainting(ppEnd);
end;

procedure TEMFtoPDFExport.DrawFigureFinish(Options: integer);
begin
  if not FDC.IsPathBracketOpened then
  begin
    cmdPathPainting(FillStrokeOptions(Options));
    cmdRestoreGraphicsState;
    if IsContain(Options, ppWithTo) then
      cmdMoveTo(FDC.PositionNext);
  end;
end;

procedure TEMFtoPDFExport.DrawFigureStart;
begin
  if not FDC.IsPathBracketOpened then
    cmdSaveGraphicsState;
end;

procedure TEMFtoPDFExport.DrawFontLines(FontSize: integer; TextPosition: TfrxPoint; TextWidth: Extended);
  procedure DrawLine(Shift, Width: Extended);
  var
    Y: Extended;
  begin
    Y := TextPosition.Y + FontSize * Shift;

    cmdMoveTo(TextPosition.X, Y);
    cmdLineTo(TextPosition.X + TextWidth, Y);
    cmdSetLineWidth(Width);

    cmdPathPainting(ppStroke);
  end;
const
  FontLineThickness = 0.095 * PDF_DIVIDER;
  UnderlineShift = -0.125;
  StrikeOutShift = 0.29;
begin
  cmdSetLineDashPattern(PS_SOLID, 0);
  cmdSetStrokeColor(FDC.TextColor);

  if FDC.FontUnderline then
    DrawLine(UnderlineShift, FontSize * FontLineThickness);
  if FDC.FontStrikeOut then
    DrawLine(StrikeOutShift, FontSize * FontLineThickness / 2);
end;

function TEMFtoPDFExport.emfPoint2Str(emfSP: TSmallPoint): String;
begin
  Result := frxPoint2Str(pdfFrxPoint(emfSP));
end;

function TEMFtoPDFExport.emfPoint2Str(emfP: TPoint): String;
begin
  Result := frxPoint2Str(pdfFrxPoint(emfP));
end;

function TEMFtoPDFExport.emfPoint2Str(emfFP: TfrxPoint): String;
begin
  Result := frxPoint2Str(pdfFrxPoint(emfFP));
end;

function TEMFtoPDFExport.emfRect2Str(emfR: TRect): String;
begin
  Result := frxRect2Str(pdfFrxRect(emfR));
end;

//function TEMFtoPDFExport.emfSize2Str(emfSize: Extended): String;
//begin
//  Result := Float2Str(pdfSize(emfSize));
//end;

function TEMFtoPDFExport.EvenOdd: String;
begin
  Result := IfStr(FDC.PolyFillMode = ALTERNATE, '*');
end;

function TEMFtoPDFExport.FillStrokeOptions(Options: integer): integer;
begin
  Result := IfInt(IsContain(Options, ppStroke) and not IsNullPen, ppStroke) +
            IfInt(IsContain(Options, ppFill) and not IsNullBrush, ppFill);

end;

function TEMFtoPDFExport.FontCreate: TFont;
begin
  Result := inherited FontCreate;

  Result.Size := Round(pdfSize(FDC.FontSize));
end;

function TEMFtoPDFExport.IsNullBrush: Boolean;
begin
  Result := FForceNullBrush or
    (FDC.BrushStyle in [BS_NULL, BS_PATTERN8X8, BS_DIBPATTERN8X8, BS_MONOPATTERN]);
end;

function TEMFtoPDFExport.IsNullPen: Boolean;
begin
  Result := FDC.PenStyle in [PS_NULL];
end;

function TEMFtoPDFExport.PDFDeviceContext: TPDFDeviceContext;
begin
  Result := FDC as TPDFDeviceContext;
end;

function TEMFtoPDFExport.pdfFrxPoint(emfP: TPoint): TfrxPoint;
begin
  Result := LogToDevPoint(emfP);
  Result.X := FPDFRect.Left + Result.X * FEMFtoPDFFactor.X;
  Result.Y := FPDFRect.Top - Result.Y * FEMFtoPDFFactor.Y;
end;

function TEMFtoPDFExport.pdfFrxPoint(emfSP: TSmallPoint): TfrxPoint;
begin
  Result := LogToDevPoint(emfSP);
  Result.X := FPDFRect.Left + Result.X * FEMFtoPDFFactor.X;
  Result.Y := FPDFRect.Top - Result.Y * FEMFtoPDFFactor.Y;
end;

function TEMFtoPDFExport.pdfFrxPoint(emfDP: TfrxPoint): TfrxPoint;
begin
  Result := LogToDevPoint(emfDP);
  Result.X := FPDFRect.Left + Result.X * FEMFtoPDFFactor.X;
  Result.Y := FPDFRect.Top - Result.Y * FEMFtoPDFFactor.Y;
end;

function TEMFtoPDFExport.pdfFrxRect(emfR: TRect): TfrxRect;
var
  TopLeft, BottomRight: TfrxPoint;
begin
  TopLeft := pdfFrxPoint(emfR.TopLeft);
  BottomRight := pdfFrxPoint(emfR.BottomRight);

  Result.Left := Min(TopLeft.X, BottomRight.X);
  Result.Right := Max(TopLeft.X, BottomRight.X);

  Result.Top := Max(TopLeft.Y, BottomRight.Y);    // Max !
  Result.Bottom := Min(TopLeft.Y, BottomRight.Y); // Min !
end;

function TEMFtoPDFExport.pdfSize(emfSize: Extended): Extended;
begin
  Result := LogToDevSize(emfSize) * (FEMFtoPDFFactor.X + FEMFtoPDFFactor.Y) / 2;
end;

procedure TEMFtoPDFExport.Put(const S: AnsiString);
begin
  if FPath.Exists then
    FPath.Put(S)
  else
    FOutStream.Write(S[1], Length(S));
end;

procedure TEMFtoPDFExport.PutLn(const S: AnsiString);
begin
  Put(S + AnsiString(#13#10));
end;

procedure TEMFtoPDFExport.RealizationListFill(RealizedCommands: array of String);
var
  i: integer;
begin
  for i := Low(RealizedCommands) to High(RealizedCommands) do
    FRealizationList.Add(RealizedCommands[i]);
end;

{$IFDEF Delphi12}
procedure TEMFtoPDFExport.PutLn(const S: String);
begin
  PutLn(AnsiString(S));
end;
{$ENDIF}

{ TPDFDeviceContext }

procedure TPDFDeviceContext.CopyFrom(ADC: TObject);
begin
  inherited;

//  FExtSelectClipRgnCreated := (ADC as TPDFDeviceContext).FExtSelectClipRgnCreated;
end;

procedure TPDFDeviceContext.Init;
begin
  inherited;

  FExtSelectClipRgnCreated := False;
end;

{ TPDFPath }

constructor TPDFPath.Create(AOutStream: TStream);
begin
  FOutStream := AOutStream;

  FExists := False;
  FStream := TMemoryStream.Create;
end;

destructor TPDFPath.Destroy;
begin
  FStream.Free;

  inherited;
end;

procedure TPDFPath.Flush;
begin
  FStream.Position := 0;
  FOutStream.CopyFrom(FStream, FStream.Size);
  FStream.Clear;
  FExists := False;
end;

procedure TPDFPath.Put(const S: AnsiString);
begin
  FStream.Write(S[1], Length(S));
end;

end.

