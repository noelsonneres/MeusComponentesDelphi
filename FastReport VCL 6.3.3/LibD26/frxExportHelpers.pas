
{******************************************}
{                                          }
{             FastReport v6.0              }
{         Helper classes for Exports       }
{                                          }
{         Copyright (c) 1998-2019          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportHelpers;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType, LCLIntf,
{$ENDIF}
  Classes, Graphics, Controls,
  frxClass, frxExportBaseDialog,
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  frxCrypto,    // for hashing pictures and CSS styles
  frxStorage,   // for TObjList and TCachedStream
  frxVectorCanvas;

type
  { Represents a CSS style }

  TfrxCSSStyle = class
  private
    FKeys, FValues: TStrings;
    FName: string;

    procedure SetStyle(Index: string; const Value: string);
    procedure SetPrefixStyle(Index: string; const Value: string);
    function GetStyle(Index: string): string;
  public
    constructor Create;
    destructor Destroy; override;

    function This: TfrxCSSStyle;
    function Count: Integer;
    function Text(Formatted: Boolean = False): string;
    procedure AssignTo(Dest: TfrxCSSStyle);

    property Style[Index: string]: string read GetStyle write SetStyle; default;
    property PrefixStyle[Index: string]: string write SetPrefixStyle;
    property Name: string read FName write FName;
  end;

  { Represents a CSS (Cascading Style Sheet) with a list of CSS styles }

  TfrxCSS = class
    FStyles: TObjList;
    FStyleHashes: TList;
  protected
    function GetStyle(i: Integer): TfrxCSSStyle;
    function GetHash(const s: string): Integer;
    function GetStyleName(i: Integer): string;
    function GetStylesCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function Add(Style: TfrxCSSStyle): string; overload;
    function Add(const StyleName: string): TfrxCSSStyle; overload;
    procedure Save(Stream: TStream; Formatted: Boolean);
  end;

    { Saves pictures and ensures that there will not be identical copies saved }

  TfrxPictureInfo = record
    Extension: string;
    Mimetype: string;
  end;

  TfrxPictureStorage = class
  private
    FWorkDir: string;
    FPrefix: string;
    FHashes: TList;
  protected
    function GetHash(Stream: TMemoryStream): Integer;
  public
    constructor Create(const WorkDir: string; Prefix: string = '');
    destructor Destroy; override;

    function Save(Pic: TGraphic; Filter: TfrxCustomIOTransport): string;

    class function GetInfo(Pic: TGraphic): TfrxPictureInfo;
  end;

  { Generalised picture }

  TfrxPictureFormat = (pfPNG, {$IFNDEF FPC}pfEMF,{$ENDIF} pfBMP, pfJPG);

  TfrxPicture = class
  private
    FFormat: TfrxPictureFormat;
    FGraphic: TGraphic;
    FCanvas: TCanvas;
    FBitmap: TBitmap; // for TJPEGImage that doesn't provide a canvas
  public
    constructor Create(Format: TfrxPictureFormat; Width, Height: Integer);
    destructor Destroy; override;

    function Release: TGraphic;
    procedure SetTransparentColor(TransparentColor: TColor);
    procedure FillColor(Color: TColor);

    property Canvas: TCanvas read FCanvas;
  end;

  TfrxExportHandler = function(Obj: TfrxView): Boolean of object;

  TTextFragment = class
  private
    FFormatted: boolean;
    FText: string;
  public
    constructor Create(AFormatted: boolean);
    procedure Add(const s: string); overload;
    procedure Add(const Fmt: string; const Args: array of const); overload;

    property Text: string read FText;
  end;

  TAnsiMemoryStream = class(TMemoryStream)
  private
    procedure PutsRaw(const s: AnsiString);
    procedure PutsA(const s: AnsiString);
  protected
    FFormatted: Boolean;
  public
    constructor Create(AFormatted: boolean);
    procedure Puts(const s: string); overload;
    procedure Puts(const Fmt: string; const Args: array of const); overload;

    function AsAnsiString: AnsiString;
  end;

  TExportHTMLDivSVGParent = class (TfrxBaseDialogExportFilter)
  private
    FMultiPage: Boolean;
    FFormatted: Boolean;
    FPicFormat: TfrxPictureFormat;
    FUnifiedPictures: Boolean;
    FNavigation: Boolean;
    FEmbeddedPictures: Boolean;
    FEmbeddedCSS: Boolean;
    FFilterStream: TStream;
    procedure SetPicFormat(Fmt: TfrxPictureFormat);
  protected
    FCurrentPage: Integer; // 1-based index of the current report page
    FCSS: TfrxCSS; // stylesheet for all pages
    FPictures: TfrxPictureStorage;
    FHandlers: array of TfrxExportHandler;
    FCurrentFile: TStream;

    procedure AttachHandler(Handler: TfrxExportHandler);
    procedure RunExportsChain(Obj: TfrxView); virtual;
    function GetCSSFileName: string;
    function GetCSSFilePath: string;
    procedure SaveCSS(const FileName: string);
    procedure CreateCSS; virtual; abstract;
    function IsCanSavePicture(Pic: TGraphic): Boolean;
    procedure SavePicture(Pic: TGraphic);
    procedure FreeStream;

    { Writes a string to the current file }
    procedure PutsRaw(const s: AnsiString);
    procedure PutsA(const s: AnsiString);
    procedure Puts(const s: string); overload;
    procedure Puts(const Fmt: string; const Args: array of const); overload;

    { Registers a CSS style in the internal CSS table and returns a selector
      that can be used in the "class" attribute of tags. }
    function LockStyle(Style: TfrxCSSStyle): string;

    function ExportViaVector(Obj: TfrxView): AnsiString;
    procedure Vector_ExtTextOut(Obj: TfrxView; AMS: TAnsiMemoryStream;
      Vector: TVector_ExtTextOut; const Shift: TPoint);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExportObject(Obj: TfrxComponent); override;
    function Start: Boolean; override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
  published
    property OverwritePrompt;
    property OpenAfterExport;
    { Exports each report page to a separate page }
    property MultiPage: Boolean read FMultiPage write FMultiPage;
    { Makes HTML sources formatted (and sligtly bigger) }
    property Formatted: Boolean read FFormatted write FFormatted;
    { Format for pictures representing report objects that are not saved natively,
      like RichText objects. }
    property PictureFormat: TfrxPictureFormat read FPicFormat write SetPicFormat;
    { Converts all pictures to PictureFormat: if there's a BMP picture in a report
      and PictureFormat is PNG, then this BMP will be saved as a PNG. }
    property UnifiedPictures: Boolean read FUnifiedPictures write FUnifiedPictures;
    { Creates navigation controls for Multipage mode }
    property Navigation: Boolean read FNavigation write FNavigation;
    { Embeds pictures }
    property EmbeddedPictures: Boolean read FEmbeddedPictures write FEmbeddedPictures;

    { Embeds CSS stylesheet }
    property EmbeddedCSS: Boolean read FEmbeddedCSS write FEmbeddedCSS;
  end;

  TRotation2D = class
  private
    FCenter: TfrxPoint;
    FMatrix: String;
  protected
    Sinus, Cosinus: Extended;
    C1, C2: Extended;

  public
    procedure Init(Radian: Extended; Center: TfrxPoint);

    function Turn2Str(DP: TfrxPoint): string;
    function Turn(DP: TfrxPoint): TfrxPoint;

    property Matrix: String read FMatrix;
  end;

{ Utility routines }

function Float2Str(const Value: Extended; const Prec: Integer = 3): String;
function frxPoint2Str(DP: TfrxPoint): String; overload;
function frxPoint2Str(X, Y: Extended): String; overload;
function GetCursor(Cursor: TCursor): string;
function GetColor(Color: TColor): string;
function GetBorderRadius(Curve: Integer): string;
function HasSpecialChars(const s: string): Boolean;

function StrFindAndReplace(const Source, Dlm: WideString; SFR: array of WideString): WideString;

function SVGPattern(Formatted, XLine, YLine, Turn: boolean; Color: TColor;
                    LineWidth: Extended; Name: string): string;
procedure CalcGlassRect(Orientation: TfrxGlassFillOrientation;
                        AbsTop, AbsLeft: Extended; var x, y, Width, Height: integer);
function SVGLine(Formatted, ZeroBased: boolean; CSS: TfrxCSS; Line: TfrxLineView): string;
function SVGDasharray(Style: TfrxFrameStyle; LineWidth: Extended): string;
function SVGUniqueID: string;
function SVGEscapeTextAndAttribute(const s: WideString): WideString;
function SVGStartSpace(const s: WideString): WideString;

const
  spStroke = $1;
  spHTML = $2;
function SVGShapePath(Shape: TfrxShapeView; Options: integer = 0): string;

function GraphicToBase64AnsiString(Graphic: TGraphic): AnsiString;

function IsTransparentPNG(Obj: TfrxView): Boolean;
procedure BitmapFill(Bitmap: TBitmap; Color: TColor);

function PiecewiseLinearInterpolation(Rotation: Integer; X, Y: array of Integer): Extended;

function IsContain(const Options, Param: integer): Boolean;

implementation

uses
  SysUtils, Types,
{$IFNDEF FPC}
  {$IFDEF Delphi12}
  pngimage
  {$ELSE}
  frxpngimage
  {$ENDIF}
  , jpeg,
{$ENDIF}
  Contnrs, Math, frxUtils, SyncObjs, frxRes, 
{$IFNDEF FPC}
frxNetUtils
{$ENDIF}
{$IFDEF FPC} 
base64
{$ENDIF};

var
  CriticalSection: TCriticalSection;
  UniqueNumber: LongWord;

{ Utility routines }

function IsContain(const Options, Param: integer): Boolean;
begin
  Result := Options and Param = Param;
end;

function PiecewiseLinearInterpolation(Rotation: Integer; X, Y: array of Integer): Extended;
var
  Left, Right: Integer;
begin
  if      Rotation <= X[0] then
    Result := Y[0]
  else if Rotation >= X[High(X)] then
    Result := Y[High(X)]
  else
  begin
    for Right := 1 to High(X) do
      if Rotation <= X[Right] then Break;
    Left := Right - 1;
    Result := Y[Left] + (Y[Right] - Y[Left]) * (Rotation - X[Left]) / (X[Right] - X[Left]);
  end;
end;

procedure BitmapFill(Bitmap: TBitmap; Color: TColor);
begin
  Bitmap.Canvas.Brush.Color := Color;
  Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));
end;

function IsTransparentPNG(Obj: TfrxView): Boolean;
begin
  Result := (Obj is TfrxPictureView);
  if Result then
    with Obj as TfrxPictureView do
      Result := Transparent
        and (Picture.Graphic <> nil)
        and (Picture.Graphic is {$IFNDEF FPC}TPNGObject{$ELSE}TPortableNetworkGraphic{$ENDIF})
        {$IFNDEF FPC}
        and (TPNGObject(Picture.Graphic).TransparencyMode in [ptmBit, ptmPartial])
{$ENDIF}
    ;
end;

function GraphicToBase64AnsiString(Graphic: TGraphic): AnsiString;
var
  MemoryStream: TMemoryStream;
  AnsiStr: AnsiString;
begin
  MemoryStream := TMemoryStream.Create;
  try
    Graphic.SaveToStream(MemoryStream);
    SetLength(AnsiStr, MemoryStream.Size);
    Move(MemoryStream.Memory^, AnsiStr[1], MemoryStream.Size);
    Result := {$IFNDEF FPC}Base64Encode{$ELSE}EncodeStringBase64{$ENDIF}(AnsiStr);
  finally
    MemoryStream.Free;
  end;
end;

function frxPoint2Str(DP: TfrxPoint): String; overload;
begin
  Result := frxPoint2Str(DP.X, DP.Y);
end;

function frxPoint2Str(X, Y: Extended): String; overload;
begin
  Result := Float2Str(X) + ' ' + Float2Str(Y);
end;

function Float2Str(const Value: Extended; const Prec: Integer = 3): String;
begin
  Result := frFloat2Str(Value, Prec);
  if Pos('.', Result) > 0 then
    while Result[Length(Result)] = '0' do
      Delete(Result, Length(Result), 1);
  if Result[Length(Result)] = '.' then
    Delete(Result, Length(Result), 1);
end;

function SVGStartSpace(const s: WideString): WideString;
begin
  if Length(s) > 0 then
  begin
    Result := IfStr(s[1] = ' ',
      '&#160;' + Copy(s, 2, Length(s) - 1), s);
    Result := IfStr(Result[Length(Result)] = ' ',
      Copy(Result, 1, Length(Result) - 1) + '&#160;', Result);
  end
  else
    Result := '';
end;

function SVGEscapeTextAndAttribute(const s: WideString): WideString;
begin
  Result := StrFindAndReplace(s, ':', ['&:&amp;', '<:&lt;', '>:&gt;', '":&quot;',
    ''':&apos;', #13':', '  : &#160;']);
end;

function SVGUniqueID: string;
begin
  CriticalSection.Enter;
  try
    Result := Format('SVGUID%d', [UniqueNumber]);
    Inc(UniqueNumber);
  finally
    CriticalSection.Leave;
  end;
end;

function SVGDasharray(Style: TfrxFrameStyle; LineWidth: Extended): string;
var
  w1, w2: string;
  Width: Extended;
begin
  Width := IfReal(Style = fsDouble, LineWidth * 3, LineWidth);
  w1 := IntToStr(Round(1 * Width));
  w2 := IntToStr(Round(2 * Width));
  case Style of
    fsSolid, fsDouble: Result := '';
    fsDash: Result := '18 6';
    fsDot: Result := '3 3';
    fsDashDot: Result := '9 6 3 6';
    fsDashDotDot: Result := '9 3 3 3 3 3';
    fsAltDot: Result := w1 + ' ' + w2;
    fsSquare: Result := w1 + ' ' + w1;
  end;
end;

function SVGLineArrow(x1, y1, x2, y2: Extended; Line: TfrxLineView;
                      ClassName: string): string;
var
  k1, a, b, c, D: Extended;
  xp, yp, x3, y3, x4, y4, wd, ld: Extended;
begin
  wd := Line.ArrowWidth;
  ld := Line.ArrowLength;
  if abs(x2 - x1) > 8 then
  begin
    k1 := (y2 - y1) / (x2 - x1);
    a := Sqr(k1) + 1;
    b := 2 * (k1 * ((x2 * y1 - x1 * y2) / (x2 - x1) - y2) - x2);
    c := Sqr(x2) + Sqr(y2) - Sqr(ld) + Sqr((x2 * y1 - x1 * y2) / (x2 - x1)) -
      2 * y2 * (x2 * y1 - x1 * y2) / (x2 - x1);
    D := Sqr(b) - 4 * a * c;
    xp := (-b + Sqrt(D)) / (2 * a);
    if (xp > x1) and (xp > x2) or (xp < x1) and (xp < x2) then
      xp := (-b - Sqrt(D)) / (2 * a);
    yp := xp * k1 + (x2 * y1 - x1 * y2) / (x2 - x1);
    if y2 <> y1 then
    begin
      x3 := xp + wd * sin(ArcTan(k1));
      y3 := yp - wd * cos(ArcTan(k1));
      x4 := xp - wd * sin(ArcTan(k1));
      y4 := yp + wd * cos(ArcTan(k1));
    end
    else
    begin
      x3 := xp;
      y3 := yp - wd;
      x4 := xp;
      y4 := yp + wd;
    end;
  end
  else
  begin
    xp := x2;
    yp := y2 - ld;
    if (yp > y1) and (yp > y2) or (yp < y1) and (yp < y2) then
      yp := y2 + ld;
    x3 := xp - wd;
    y3 := yp;
    x4 := xp + wd;
    y4 := yp;
  end;

  Result := Format('<%s points="%s,%s %s,%s %s,%s" class="%s"/>',
    [IfStr(Line.ArrowSolid, 'polygon', 'polyline'),
     frFloat2Str(x3, 1), frFloat2Str(y3, 1),
     frFloat2Str(x2, 1), frFloat2Str(y2, 1),
     frFloat2Str(x4, 1), frFloat2Str(y4, 1),
     ClassName]);
end;

function SVGLine(Formatted, ZeroBased: boolean; CSS: TfrxCSS; Line: TfrxLineView): string;

  procedure CalcEnds(First, Size: Extended; out z1, z2: Extended);
  begin
    z1 := IfReal(ZeroBased, 0.0, First);
    z2 := z1 + Size;
    if ZeroBased and (z2 < 0) then
    begin
      z1 := -z2;
      z2 := 0.0;
    end;
  end;

var
  x1, x2, y1, y2: Extended;
  CSSClassNameBG, CSSClassNameFG: string;
begin
  CalcEnds(Line.AbsLeft, Line.Width, x1, x2);
  CalcEnds(Line.AbsTop, Line.Height, y1, y2);

  if Line.Frame.Style <> fsSolid then
    if Line.Diagonal then
      with TfrxCSSStyle.Create do
      begin
        Style['stroke'] := GetColor(Line.Color);
        Style['stroke-width'] := IntToStr(Round(Line.Frame.Width));
        if Line.Frame.Style = fsDouble then
          Style['stroke-linecap'] := 'square';
        CSSClassNameBG := CSS.Add(This);
      end
    else
      if Abs(x1 - x2) > Abs(y1 - y2) then
        y2 := y1
      else
        x2 := x1;

  with TfrxCSSStyle.Create do
  begin
    Style['stroke'] := GetColor(Line.Frame.Color);
    Style['stroke-width'] := IntToStr(Round(Line.Frame.Width));
    Style['stroke-dasharray'] := SVGDasharray(Line.Frame.Style, Line.Frame.Width);
    if Line.Frame.Style = fsDouble then
      Style['stroke-linecap'] := 'square';
    if Line.ArrowEnd or Line.ArrowStart then
      if Line.ArrowSolid then Style['fill'] := GetColor(Line.Frame.Color)
      else                    Style['fill'] := 'transparent';
    CSSClassNameFG := CSS.Add(This);
  end;

  with TTextFragment.Create(Formatted) do
  begin
    if (Line.Frame.Style <> fsSolid) and Line.Diagonal then
      Add('<line x1="%d" y1="%d" x2="%d" y2="%d" class="%s"/>',
           [Round(x1), Round(y1), Round(x2), Round(y2), CSSClassNameBG]);

    Add('<line x1="%d" y1="%d" x2="%d" y2="%d" class="%s"/>',
         [Round(x1), Round(y1), Round(x2), Round(y2), CSSClassNameFG]);

    if Line.ArrowStart then
      Add(SVGLineArrow(x2, y2, x1, y1, Line, CSSClassNameFG));

    if Line.ArrowEnd then
      Add(SVGLineArrow(x1, y1, x2, y2, Line, CSSClassNameFG));
    Result := Text;
    Free;
  end;

end;

procedure CalcGlassRect(Orientation: TfrxGlassFillOrientation;
                        AbsTop, AbsLeft: Extended; var x, y, Width, Height: integer);
begin
  case Orientation of
    foHorizontal:
      Height := Round(Height / 2);
    foHorizontalMirror:
      begin
        y := Round(AbsTop + Height / 2);
        Height := Round(AbsTop + Height) - y;
      end;
    foVertical:
      Width :=  Round(Width / 2);
    foVerticalMirror:
      begin
        x := Round(AbsLeft + Width / 2);
        Width :=  Round(AbsLeft + Width) - x;
      end;
  end;
end;

function SVGShapePath(Shape: TfrxShapeView; Options: integer = 0): string;
var
  RadiusValue, StrokeValue, StrokeWidth, sf: string;
  w, h, h2, w2: Extended;
  x1, x2, x3, y1, y2, y3: Extended;
begin
  if Options and spStroke = spStroke then
  begin
    StrokeWidth := IfStr(Shape.Shape in [skDiagonal1, skDiagonal2],
      frFloat2Str(1.5 * Shape.Frame.Width, 1), frFloat2Str(Shape.Frame.Width, 1));
    StrokeValue := GetColor(Shape.Frame.Color);
    sf := Format('stroke="%s" stroke-width="%s" fill="transparent"',
      [StrokeValue, StrokeWidth]);
  end
  else
    sf := '';

  RadiusValue := GetBorderRadius(Shape.Curve);
  w := Shape.Width - Shape.ShadowSize;  w2 := w / 2;
  h := Shape.Height - Shape.ShadowSize; h2 := h / 2;

  if Options and spHTML = spHTML then
  begin
    x1 := Shape.Frame.Width / 2;
    y1 := Shape.Frame.Width / 2;
  end
  else
  begin
    x1 := Shape.AbsLeft;
    y1 := Shape.AbsTop;
  end;
  x2 := x1 + w2; x3 := x1 + w;
  y2 := y1 + h2; y3 := y1 + h;

  case Shape.Shape of
    skRectangle:
      Result := Format('<rect x="%d" y="%d" width="%d" height="%d" %s/>',
        [Round(x1), Round(y1), Round(w), Round(h), sf]);
    skRoundRectangle:
      Result := Format('<rect x="%d" y="%d" width="%d" height="%d" rx="%s" ry="%s" %s/>',
        [Round(x1), Round(y1), Round(w), Round(h), RadiusValue, RadiusValue, sf]);
    skEllipse:
      Result := Format('<ellipse cx="%d" cy="%d" rx="%d" ry="%d" %s/>',
        [Round(x2), Round(y2), Round(w2), Round(h2), sf]);
    skTriangle:
      Result := Format('<polygon points="%d,%d %d,%d %d,%d" %s/>',
        [Round(x2), Round(y1), Round(x3), Round(y3), Round(x1), Round(y3), sf]);
    skDiamond:
      Result := Format('<polygon points="%d,%d %d,%d %d,%d %d,%d" %s/>',
        [Round(x2), Round(y1), Round(x3), Round(y2), Round(x2), Round(y3), Round(x1), Round(y2), sf]);
    skDiagonal1:
      Result := Format('<line x1="%d" y1="%d" x2="%d" y2="%d" %s/>',
        [Round(x1), Round(y3), Round(x3), Round(y1), sf]);
    skDiagonal2:
      Result := Format('<line x1="%d" y1="%d" x2="%d" y2="%d" %s/>',
        [Round(x1), Round(y1), Round(x3), Round(y3), sf]);
  end;

end;

function SVGPattern(Formatted, XLine, YLine, Turn: boolean; Color: TColor;
                    LineWidth: Extended; Name: string): string;
var
  Size: string;
begin
  Size := IfStr(Turn, '6', '8');

  with TTextFragment.Create(Formatted) do
  begin
    Add('<defs>');
    Add('<pattern id="%s" width="%s" height="%s" patternUnits="userSpaceOnUse"%s>',
      [Name, Size, Size, IfStr(Turn, ' patternTransform="rotate(45)"')]);
    if XLine then
      Add('<line x2="%s" stroke="%s" stroke-width="%s" />',
         [Size, GetColor(Color), frFloat2Str(LineWidth, 1)]);
    if YLine then
      Add('<line y2="%s" stroke="%s" stroke-width="%s" />',
         [Size, GetColor(Color), frFloat2Str(LineWidth, 1)]);
    Add('</pattern>');
    Add('</defs>');

    Result := Text;
    Free;
  end;
end;

function StrFindAndReplace(const Source, Dlm: WideString; SFR: array of WideString): WideString;

  function IsSplit(const Source, Dlm: WideString; out UpToDlm, AfterDlm: WideString): boolean;
  var
    p: integer;
  begin
    p := Pos(Dlm, Source);
    Result := p > 0;
    if Result then
    begin
      UpToDlm := Copy(Source, 1, p - 1);
      AfterDlm := Copy(Source, p + Length(Dlm), Length(Source) - (p + Length(Dlm)) + 1);
    end
    else
    begin
      UpToDlm := Source;
      AfterDlm := '';
    end;
  end;

var
  i: integer;
  Find, Replace, UpToDlm, AfterDlm, Rest: WideString;

begin
  Result := Source;

  for i := 0 to High(SFR) do
    if IsSplit(SFR[i], Dlm, Find, Replace) and (Find <> '') then
    begin
      Rest := Result;
      Result := '';

      while IsSplit(Rest, Find, UpToDlm, AfterDlm) do
      begin
        Result := Result + UpToDlm + Replace;
        Rest := AfterDlm;
      end;

      Result := Result + UpToDlm;
    end;

  Rest := Result;
  Result := '';
  for i := 1 to Length(Rest) do
    if Word(Rest[i]) < 32 then
      Result := Result + '&#' + IntToStr(Word(Rest[i])) + ';'
    else
      Result := Result + Rest[i];
end;

function HasSpecialChars(const s: string): Boolean;
var
  i: Integer;
begin
  Result := True;

  for i := 1 to Length(s) do
    case s[i] of
      '<', '>', '&': Exit;
      else if Word(S[i]) < 32 then
        Exit
    end;

  Result := False
end;

function GetBorderRadius(Curve: Integer): string;
begin
  if Curve < 1 then
    Result := GetBorderRadius(2)
  else
    Result := IntToStr(Curve * 4) + 'pt'
end;

function GetColor(Color: TColor): string;
begin
  case Color of
    clAqua:    Result := 'aqua';
    clBlack:   Result := 'black';
    clBlue:    Result := 'blue';
    clFuchsia: Result := 'fuchsia';
    clGray:    Result := 'gray';
    clGreen:   Result := 'green';
    clLime:    Result := 'lime';
    clLtGray:  Result := 'lightgray';
    clMaroon:  Result := 'maroon';
    clNavy:    Result := 'navy';
    clOlive:   Result := 'olive';
    clPurple:  Result := 'purple';
    clRed:     Result := 'red';
    clTeal:    Result := 'teal';
    clWhite:   Result := 'white';
    clYellow:  Result := 'yellow';

    clNone:    Result := 'transparent';
  else
    if Color and $ff000000 <> 0 then
      Result := GetColor(GetSysColor(Color and $ffffff))
    else
      Result := HTMLRGBColor(Color)
  end
end;

function GetCursor(Cursor: TCursor): string;
begin
  Result := '';

  case Cursor of
    crCross:      Result := 'crosshair';
    crArrow:      Result := 'arrow';
    crIBeam:      Result := 'text';
    crHelp:       Result := 'help';
    crUpArrow:    Result := 'n-resize';
    crHourGlass:  Result := 'wait';
    crDrag:       Result := 'move';
    crHandPoint:  Result := 'pointer';
  else            Result := '';
  end;
end;

{ TfrxPictureStorage }

constructor TfrxPictureStorage.Create(const WorkDir: string; Prefix: string = '');
begin
  FHashes := TList.Create;

  if (WorkDir = '') or (WorkDir[Length(WorkDir)] = PathDelim) then
    FWorkDir := WorkDir
  else
    FWorkDir := WorkDir + PathDelim;
  FPrefix := Prefix;
end;

destructor TfrxPictureStorage.Destroy;
begin
  FHashes.Free;
  inherited;
end;

class function TfrxPictureStorage.GetInfo(Pic: TGraphic): TfrxPictureInfo;
var
  cn: string;
begin
  cn := Pic.ClassName;

  with Result do
    if cn = 'TMetafile' then
    begin
      Extension := '.emf';
      Mimetype := 'image/metafile';
    end
    else if cn = 'TBitmap' then
    begin
      Extension := '.bmp';
      Mimetype := 'image/bitmap';
    end
    else if (cn = 'TPngImage') or (cn = {$IFNDEF FPC}'TPNGObject'
    {$ELSE}'TPortableNetworkGraphic'{$ENDIF}) then
    begin
      Extension := '.png';
      Mimetype := 'image/png';
    end
    else if cn = 'TJPEGImage' then
    begin
      Extension := '.jpg';
      Mimetype := 'image/jpeg';
    end
    else
    begin
      Extension := '.pic';
      Mimetype := 'image/unknown';
    end
end;

function TfrxPictureStorage.GetHash(Stream: TMemoryStream): Integer;
begin
  TCryptoHash.Hash('Jenkins', Result, SizeOf(Result), Stream.Memory^, Stream.Size)
end;

function TfrxPictureStorage.Save(Pic: TGraphic; Filter: TfrxCustomIOTransport): string;
var
  Stream: TMemoryStream;
  Ext: string;
  Hash, i: Integer;
  s: TStream;
begin
  Stream := TMemoryStream.Create;
  Pic.SaveToStream(Stream);
  Ext := GetInfo(Pic).Extension;
  Hash := GetHash(Stream);

  i := FHashes.IndexOf(Pointer(Hash));

  try
    if i >= 0 then
      Result := FPrefix + IntToStr(i) + Ext
    else
    begin
      Result := FPrefix + IntToStr(FHashes.Count) + Ext;
      s := Filter.GetStream(FWorkDir + Result);
//      Stream.SaveToFile(FWorkDir + Result);
    try
      Stream.SaveToStream(s);
    finally
      Filter.DoFilterSave(s);
      Filter.FreeStream(s);
    end;
      FHashes.Add(Pointer(Hash));
    end
  finally
    Stream.Free;
  end;
end;

{ TfrxPicture }

constructor TfrxPicture.Create(Format: TfrxPictureFormat; Width, Height: Integer);
begin
  case Format of
    pfPNG:
      begin
{$IFNDEF FPC}
        FGraphic := TPngObject.CreateBlank(COLOR_RGB, 8, Width, Height);
        FCanvas := TPngObject(FGraphic).Canvas;
{$ELSE}
        FGraphic :=  TPortableNetworkGraphic.Create;
        FGraphic.Width := Width;
        FGraphic.Height := Height;
        FCanvas := TPortableNetworkGraphic(FGraphic).Canvas;
{$ENDIF}
      end;
{$IFNDEF FPC}
    pfEMF:
      begin
        FGraphic := TMetafile.Create;
        FGraphic.Width := Width;
        FGraphic.Height := Height;
        FCanvas := TMetafileCanvas.Create(TMetafile(FGraphic), 0);
      end;
{$ENDIF}

    pfBMP:
      begin
        FGraphic := TBitmap.Create;
        FGraphic.Width := Width;
        FGraphic.Height := Height;
        FCanvas := TBitmap(FGraphic).Canvas;
      end;

    pfJPG:
      begin
        FGraphic := TJPEGImage.Create;
        FBitmap := TBitmap.Create;
        FBitmap.Width := Width;
        FBitmap.Height := Height;
        FCanvas := FBitmap.Canvas;
      end;

    else
      raise Exception.Create('Unknown picture format');
  end;

  FFormat := Format;
end;

destructor TfrxPicture.Destroy;
begin
  FGraphic.Free;
  inherited;
end;

procedure TfrxPicture.SetTransparentColor(TransparentColor: TColor);
begin
  if FFormat = pfPNG then
    (FGraphic as {$IFNDEF FPC}TPngObject{$ELSE}TPortableNetworkGraphic{$ENDIF}).TransparentColor := TransparentColor;
end;

procedure TfrxPicture.FillColor(Color: TColor);
begin
  Canvas.Lock;
  try
    Canvas.Brush.Color := Color;
    Canvas.FillRect(Canvas.ClipRect);
  finally
    Canvas.Unlock;
  end;
end;

function TfrxPicture.Release: TGraphic;
begin
  case FFormat of
{$IFNDEF FPC}
    pfEMF:
      FCanvas.Free;
{$ENDIF}
    pfJPG:
      begin
        FGraphic.Assign(FBitmap);
        FBitmap.Free;
      end;
  end;

  FCanvas := nil;
  Result := FGraphic;
end;

{ TfrxCSS }

constructor TfrxCSS.Create;
begin
  FStyles := TObjList.Create;
  FStyleHashes := TList.Create;
end;

destructor TfrxCSS.Destroy;
begin
  FStyles.Free;
  FStyleHashes.Free;
  inherited;
end;

function TfrxCSS.GetHash(const s: string): Integer;
begin
  if s = '' then
    Result := -1
  else
    TCryptoHash.Hash('Jenkins', Result, SizeOf(Result), s[1], Length(s)*SizeOf(s[1]))
end;

function TfrxCSS.GetStyle(i: Integer): TfrxCSSStyle;
begin
  if i < GetStylesCount then
    Result := TfrxCSSStyle(FStyles[i])
  else
    Result := nil
end;

function TfrxCSS.GetStyleName(i: Integer): string;
begin
  { There're two kinds of styles: with automatically generated names
    (added via Add(TfrxCSSStyle) and with specified names (added via
    Add(string)). This function returns a name for a style with
    automatically generated style. }

  if FStyleHashes[i] = nil then
    raise Exception.CreateFmt('Cannot generate style name for style #%d', [i]);

  Result := 's' + IntToStr(i)
end;

function TfrxCSS.GetStylesCount: Integer;
begin
  Result := FStyles.Count
end;

function TfrxCSS.Add(Style: TfrxCSSStyle): string;
var
  i: Integer;
  s: string;
  h: Integer;
begin
  s := Style.Text;
  h := GetHash(s);

  if h <> 0 then
    for i := 0 to GetStylesCount - 1 do
      if Integer(FStyleHashes[i]) = h then
        if GetStyle(i).Text = s then
        begin
          Style.Free;
          Result := GetStyleName(i);
          Exit;
        end;

  FStyles.Add(Style);
  FStyleHashes.Add(Pointer(h));

  Result := GetStyleName(GetStylesCount - 1);
  Style.Name := '.' + Result;
end;

function TfrxCSS.Add(const StyleName: string): TfrxCSSStyle;
begin
  Result := TfrxCSSStyle.Create;
  Result.Name := StyleName;

  FStyles.Add(Result);
  FStyleHashes.Add(nil); // zero hash
end;

procedure TfrxCSS.Save(Stream: TStream; Formatted: Boolean);

  function Encode(const s: string): string;
  begin
    Result := string(UTF8Encode(s))
  end;

  procedure Puts(const Text: string);
  var
    s: AnsiString;
  begin
    s := AnsiString(Text);
    Stream.Write(s[1], Length(s));
  end;

var
  i: Integer;
  Sep: string;
begin
  Sep := IfStr(Formatted, #13#10);

  for i := 0 to GetStylesCount - 1 do
    with GetStyle(i) do
      Puts(This.Name + Sep + '{' +
        Encode(This.Text(Formatted)) + Sep + '}' + Sep);
end;

{ TfrxCSSStyle }

procedure TfrxCSSStyle.AssignTo(Dest: TfrxCSSStyle);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Dest[FKeys[i]] := FValues[i]
end;

constructor TfrxCSSStyle.Create;
begin
  FKeys := TStringList.Create;
  FValues := TStringList.Create;
end;

function TfrxCSSStyle.Count: Integer;
begin
  Result := FKeys.Count
end;

destructor TfrxCSSStyle.Destroy;
begin
  FKeys.Free;
  FValues.Free;
  inherited
end;

function TfrxCSSStyle.GetStyle(Index: string): string;
var
  i: Integer;
begin
  Result := '';
  if (Index <> '') then
  begin
    i := FKeys.IndexOf(Index);
    if i <> -1 then
      Result := FValues[i];
  end;
end;

procedure TfrxCSSStyle.SetPrefixStyle(Index: string; const Value: string);
begin
  if (Index <> '') and (Value <> '') then
  begin
    SetStyle(Index, Value);
    SetStyle('-webkit-' + Index, Value);
    SetStyle('-moz-' + Index, Value);
    SetStyle('-ms-' + Index, Value);
    SetStyle('-o-' + Index, Value);
  end;
end;

procedure TfrxCSSStyle.SetStyle(Index: string; const Value: string);
begin
  if (Index <> '') and (Value <> '') then
  begin
    FKeys.Add(Index);
    FValues.Add(Value);
  end;
end;

function TfrxCSSStyle.Text(Formatted: Boolean): string;
var
  i: Integer;
  function CheckSmall(const AFont: string): Boolean;
  begin
    Result := (Pos('8pt', AFont) > 0) or (Pos('7pt', AFont) > 0) or (Pos('9pt', AFont) > 0);

  end;
begin
  Result := '';
  for i := 0 to Count - 1 do
    if FValues[i] <> '' then
    begin
      if SameText('font', FKeys[i]) and CheckSmall(FValues[i]) then
      begin
        Result := Result + IfStr(Formatted, #13#10#9) + 'line-height' +
        IfStr(Formatted, ': ', ':') + '110% !important';
        if Result[Length(Result)] <> ';' then
          Result := Result + ';';
      end;
      Result := Result + IfStr(Formatted, #13#10#9) + FKeys[i] +
      IfStr(Formatted, ': ', ':') + string(UTF8Encode(FValues[i]));
      if Result[Length(Result)] <> ';' then
        Result := Result + ';';
    end;
end;

function TfrxCSSStyle.This: TfrxCSSStyle;
begin
  Result := Self
end;

{ TTextFragment }

procedure TTextFragment.Add(const s: string);
begin
  FText := FText + IfStr(FFormatted and (FText <> ''), #13#10) + s;
end;

procedure TTextFragment.Add(const Fmt: string; const Args: array of const);
begin
  Add(Format(Fmt, Args));
end;

constructor TTextFragment.Create(AFormatted: boolean);
begin
  FFormatted := AFormatted;
  FText := '';
end;

{ TExportHTMLDivSVGParent }

procedure TExportHTMLDivSVGParent.AttachHandler(Handler: TfrxExportHandler);
begin
  SetLength(FHandlers, Length(FHandlers) + 1);
  FHandlers[Length(FHandlers) - 1] := Handler;
end;

constructor TExportHTMLDivSVGParent.Create(AOwner: TComponent);
begin
  inherited;

  OpenAfterExport := False;
  MultiPage := False;
  Formatted := False;
  PictureFormat := pfPNG;
  UnifiedPictures := True;
  Navigation := False;
  EmbeddedCSS := True;
  EmbeddedPictures := True;
  FFilterStream := nil;
end;

procedure TExportHTMLDivSVGParent.ExportObject(Obj: TfrxComponent);
begin
  if Obj is TfrxView then
    RunExportsChain(Obj as TfrxView);

  inherited;
end;

function TExportHTMLDivSVGParent.ExportViaVector(Obj: TfrxView): AnsiString;
var
  AMS: TAnsiMemoryStream;
  VC: TVectorCanvas;
  i: Integer;
  ClippedShift: TPoint;
  CLippedMemo: Boolean;
begin
  Result := '';
  AMS := TAnsiMemoryStream.Create(Formatted);
  try
    VC := Obj.GetVectorCanvas;
    try
      CLippedMemo := (Obj is TfrxMemoView) and (Obj as TfrxMemoView).Clipped;
      if CLippedMemo then
      begin
        ClippedShift := Point(0, 0);
        with Obj do
          AMS.Puts('<svg x="%s" y="%s" width="%s" height="%s">',
            [Float2Str(AbsLeft), Float2Str(AbsTop), Float2Str(Width), Float2Str(Height)]);
      end
      else
        with Obj do
          ClippedShift := Point(Round(AbsLeft), Round(AbsTop));

      for i := 0 to VC.Count - 1 do
        if      (VC[i] is TVector_ExtTextOutW)
             or (VC[i] is TVector_ExtTextOutA) then
          Vector_ExtTextOut(Obj, AMS, TVector_ExtTextOut(VC[i]), ClippedShift);

      if CLippedMemo then
        AMS.Puts('</svg>');
    finally
      VC.Free;
    end;
    Result := AMS.AsAnsiString;
  finally
    AMS.Free;
  end;
end;

procedure TExportHTMLDivSVGParent.FreeStream;
begin
  if Assigned(FFilterStream) then
  begin
    IOTransport.DoFilterSave(FFilterStream);
    FCurrentFile.Free;
    IOTransport.FreeStream(FFilterStream);
    FFilterStream := nil;
  end;
end;

function TExportHTMLDivSVGParent.GetCSSFileName: string;
begin
  if Multipage then
    Result := 'styles.css'
  else
    Result := ExtractFileName(FileName) + '.css'
end;

function TExportHTMLDivSVGParent.GetCSSFilePath: string;
begin
  if Multipage then
    Result := FileName + '\' + GetCSSFileName
  else
    Result := ExtractFileDir(FileName) + '\' + GetCSSFileName
end;

function TExportHTMLDivSVGParent.IsCanSavePicture(Pic: TGraphic): Boolean;
begin
  { If the SVG is written to a specified stream (maybe a TMemoryStream),
    additional files with pictures cannot be created. }
  Result := not (Assigned(Stream) and not EmbeddedPictures or
                 (Pic = nil) or (Pic.Width <= 0) or (Pic.Height <= 0));
end;

function TExportHTMLDivSVGParent.LockStyle(Style: TfrxCSSStyle): string;
begin
  Result := FCSS.Add(Style)
end;

procedure TExportHTMLDivSVGParent.Puts(const s: string);
begin
{$IFDEF Delphi12}
  PutsA(AnsiString(Utf8Encode(s)));
{$ELSE}
  PutsA(AnsiString(s));
{$ENDIF}
end;

procedure TExportHTMLDivSVGParent.Puts(const Fmt: string; const Args: array of const);
begin
  Puts(Format(Fmt, Args));
end;

procedure TExportHTMLDivSVGParent.PutsA(const s: AnsiString);
begin
  PutsRaw(s);

  if Formatted and (s <> '') then
    PutsRaw(#13#10);
end;

procedure TExportHTMLDivSVGParent.PutsRaw(const s: AnsiString);
begin
  if s <> '' then
    FCurrentFile.Write(s[1], Length(s))
end;

procedure TExportHTMLDivSVGParent.RunExportsChain(Obj: TfrxView);
var
  i: Integer;
begin
  for i := Length(FHandlers) - 1 downto 0 do
    if TfrxExportHandler(FHandlers[i])(Obj) then
      Break;
end;

procedure TExportHTMLDivSVGParent.SaveCSS(const FileName: string);
var
  s, sf: TStream;
begin
  s := nil;
  sf := IOTransport.GetStream(FileName);
  try
    s := TCachedStream.Create(sf, False);
    FCSS.Save(s, Formatted)
  finally
    s.Free;
    IOTransport.DoFilterSave(sf);
    IOTransport.FreeStream(sf);
  end
end;

procedure TExportHTMLDivSVGParent.SavePicture(Pic: TGraphic);
begin
  if not EmbeddedPictures then
    PutsRaw(AnsiString(FPictures.Save(Pic, IOTransport)))
  else
  begin
    PutsRaw(AnsiString(Format('data:%s;base64,', [TfrxPictureStorage.GetInfo(Pic).Mimetype])));
    PutsRaw(GraphicToBase64AnsiString(Pic));
  end;
end;

procedure TExportHTMLDivSVGParent.SetPicFormat(Fmt: TfrxPictureFormat);
begin
  if Fmt in [{$IFNDEF FPC}pfEMF,{$ENDIF} pfBMP, pfPNG, pfJPG] then
    FPicFormat := Fmt
  else
    raise Exception.Create('Invalid PictureFormat')
end;

function TExportHTMLDivSVGParent.Start: Boolean;
begin
  Result := False;

  if (FileName = '') and not Assigned(Stream) then
    Exit;

  if MultiPage then
  begin
    if FileExists(FileName) and not DeleteFile(FileName) then
      Exit;

    //if not CreateDir(FileName) then
    //  Exit;
    IOTransport.CreateContainer(ExtractFileName(FileName));
  end
  else
  begin
    if Assigned(Stream) then
      FFilterStream := Stream
    else
      FFilterStream := IOTransport.GetStream(FileName);

    try
      FCurrentFile := TCachedStream.Create(FFilterStream, False);
    except
      Exit
    end;
  end;
//  else
//    try
//      IOTransport.GetStream(FileName)
//      FCurrentFile := TCachedStream.Create(
//        TFileStream.Create(FileName, fmCreate),
//        True)
//    except
//      Exit
//    end;

  if Multipage then
    FPictures := TfrxPictureStorage.Create(FileName)
  else
    FPictures := TfrxPictureStorage.Create(ExtractFileDir(FileName), ExtractFileName(FileName) + '-');

  CreateCSS;

  FCurrentPage := 0;
  Result := True;
end;

procedure TExportHTMLDivSVGParent.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  inherited;
  Inc(FCurrentPage);

  if MultiPage then
  begin
    if not Assigned(FFilterStream) then
    begin
      IOTransport.FileName := Format('%s\%d' + DefaultExt, [FileName, FCurrentPage]);
      FFilterStream := IOTransport.GetStream(IOTransport.FileName);
    end;
    try
      FCurrentFile := TCachedStream.Create(FFilterStream, False);
    except
      Exit
    end;
  end;

//    FCurrentFile := TCachedStream.Create(
//      TFileStream.Create(
//        Format('%s\%d' + DefaultExt, [FileName, FCurrentPage]),
//        fmCreate),
//        True);
end;

procedure TExportHTMLDivSVGParent.Vector_ExtTextOut(Obj: TfrxView; AMS: TAnsiMemoryStream; Vector: TVector_ExtTextOut; const Shift: TPoint);
var
  Memo: TfrxCustomMemoView;

  function MeasureTextLength: String;
  begin
    Result := '';
    if Vector.Dx <> nil then
      Result := Format('textLength="%d" lengthAdjust="spacingAndGlyphs"',
        [Vector.TextLength]);
  end;

  function MeasureFontOrientation: String;
  begin
    Result := '';
    if Memo.ReducedAngle <> 0 then
      Result := Format('transform="rotate(%s %d,%d)"',
        [frFloat2Str(-Memo.ReducedAngle, 1), Vector.X + Shift.X, Vector.Y + Shift.Y]);
  end;

  function CSSPaintStyleName: string;
  begin
    with TfrxCSSStyle.Create do
    begin
      Style['fill'] := GetColor(Obj.Font.Color);
      Style['fill-rule'] := 'evenodd';

      Style['text-anchor'] := 'start'; // Any Memo.HAlign
      Style['dominant-baseline'] := 'auto'; // Any Memo.VAlign
      Style['font-family'] := Obj.Font.Name;
      Style['font-size'] := IntToStr(Obj.Font.Size) + 'pt';
      Style['font-weight'] := IfStr(fsBold in Obj.Font.Style, 'bold');
      Style['font-style'] := IfStr(fsItalic in Obj.Font.Style, 'italic');
      Style['text-decoration'] := IfStr(fsStrikeout in Obj.Font.Style, 'line-through');
      Style['text-decoration'] := IfStr(fsUnderline in Obj.Font.Style, 'underline');

      Result := FCSS.Add(This);
    end;
  end;

begin
  Memo := TfrxCustomMemoView(Obj);

  AMS.Puts('<text class="%s" x="%d" y="%d" %s %s>', [CSSPaintStyleName,
    Vector.X + Shift.X, Vector.Y + Shift.Y + Round(Memo.Font.Size * 1.4),
    MeasureFontOrientation, MeasureTextLength]);
  AMS.Puts(SVGStartSpace(SVGEscapeTextAndAttribute(WideString(Vector.Str))));
  AMS.Puts('</text>');
end;

{ TAnsiMemoryStream }

function TAnsiMemoryStream.AsAnsiString: AnsiString;
begin
  Position := 0;
  SetLength(Result, Size);
  ReadBuffer(Result[1], Size);
end;

constructor TAnsiMemoryStream.Create(AFormatted: boolean);
begin
  inherited Create;
  FFormatted := AFormatted;
end;

procedure TAnsiMemoryStream.Puts(const s: string);
begin
{$IFDEF Delphi12}
  PutsA(AnsiString(Utf8Encode(s)));
{$ELSE}
  PutsA(AnsiString(s));
{$ENDIF}
end;

procedure TAnsiMemoryStream.Puts(const Fmt: string; const Args: array of const);
begin
  Puts(Format(Fmt, Args));
end;

procedure TAnsiMemoryStream.PutsA(const s: AnsiString);
begin
  PutsRaw(s);

  if FFormatted and (s <> '') then
    PutsRaw(#13#10);
end;

procedure TAnsiMemoryStream.PutsRaw(const s: AnsiString);
begin
  if s <> '' then
    Write(s[1], Length(s))
end;

{ TRotation2D }

procedure TRotation2D.Init(Radian: Extended; Center: TfrxPoint);
begin
  FCenter := Center;

  SinCos(Radian, Sinus, Cosinus);
  with FCenter do
  begin
    C1 := X - X * Cosinus + Y * Sinus;
    C2 := Y - X * Sinus -   Y * Cosinus;
  end;

  FMatrix := frFloat2Str(Cosinus, 4) +  ' ' + frFloat2Str(Sinus, 4) + ' ' +
             frFloat2Str(-Sinus, 4) +   ' ' + frFloat2Str(Cosinus, 4) + ' ' +
             frFloat2Str(C1, 4) +       ' ' + frFloat2Str(C2, 4);
end;

function TRotation2D.Turn(DP: TfrxPoint): TfrxPoint;
begin
  with FCenter do
    Result := frxPoint(X + (DP.X - X) * Cosinus + (DP.Y - Y) * Sinus,
                       Y - (DP.X - X) * Sinus +   (DP.Y - Y) * Cosinus);
end;

function TRotation2D.Turn2Str(DP: TfrxPoint): string;
begin
  Result := frxPoint2Str(Turn(DP));
end;

initialization
  CriticalSection := TCriticalSection.Create;
  UniqueNumber := 0;

finalization
  CriticalSection.Free;

end.
