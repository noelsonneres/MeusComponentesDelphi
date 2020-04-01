
{******************************************}
{                                          }
{             FastReport v6.0              }
{            HTML <div> Export             }
{                                          }
{         Copyright (c) 1998-2018          }
{          by Anton Khayrudinov            }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxExportHTMLDiv;

{ General advice for using this export.

  • Avoid using vertical alignment in memos:
  it forces the export to create more
  complicated HTML. Leave the alignment vaTop
  whenever it's possible.

  • Use @-type anchors in TfrxView.URL instead of
  #-type, because #-type is much slower to export. }

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows,
  {$ENDIF}
  SysUtils,
  Classes,
  {$IFDEF FPC}
    LCLType, LCLIntf, LCLProc,
  {$ENDIF}
  {$IFNDEF FPC}
  ShellAPI,
  {$ENDIF}
  Graphics,
  frxClass,
  frxStorage, // for TObjList and TCachedStream
  frxGradient,
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  frxExportHelpers, frxExportBaseDialog, frxVectorCanvas;

type
  { Measures actual size of a TfrxView.
    Example:

    Gauge := TfrxBoundsGauge.Create;
    Gauge.Obj := MemoView;

    Gauge.Bounds.Left; // the leftmost coordinate including the left border
    Gauge.Borders.Left; // the left border width }

  TfrxBoundsGauge = class
  private
    FObj: TfrxView;
    FBoundsSet: Boolean;
    FBounds: TRect;
    FBorders: TRect;

    FX, FY, FX1, FY1, FDX, FDY: Integer;
    FFrameWidth: Integer;

    procedure SetObj(Obj: TfrxView);
    procedure AddBounds(r: TRect);
    function GetInnerWidth: Integer;
    function GetInnerHeight: Integer;
  protected
    procedure BeginDraw;
    procedure DrawBackground;
    procedure DrawFrame;
    procedure DrawLine(x1, y1, x2, y2, w: Integer; Side: TfrxFrameType);
  public
    property Obj: TfrxView read FObj write SetObj;
    property Bounds: TRect read FBounds;
    property Borders: TRect read FBorders;
    property InnerWidth: Integer read GetInnerWidth;
    property InnerHeight: Integer read GetInnerHeight;
  end;

  { Represents a HTML tag }

  TfrxHTMLItem = class
  private
    FName: string;
    FKeys: TStrings;
    FValues: TStrings;
    FValue: string;
    FRawValue: AnsiString;
    FChildren: TObjList;
    FLeft, FTop, FWidth, FHeight: Extended;
    FLeftSet, FTopSet, FWidthSet, FHeightSet: Boolean;
    FStyle: TfrxCSSStyle;
    FClass: string;
    FRotation: Integer;
    FAllowNegativeLeft: Boolean;
    FIsTransformMatrix: Boolean;
    FTM: array of Extended; // TransformMatrix

    procedure SetProp(Index: string; const Value: string);
    function GetProp(Index: string): string;
    function GetStyle: TfrxCSSStyle;

    procedure SetLeft(a: Extended);
    procedure SetTop(a: Extended);
    procedure SetWidth(a: Extended);
    procedure SetHeight(a: Extended);
  public

    constructor Create(const Name: string);
    destructor Destroy; override;

    function This: TfrxHTMLItem;

    procedure GaudeFrame(Obj: TfrxView);
    procedure Gaude(Obj: TfrxView);
    procedure WidenBy(Size: Extended);
    procedure DoPositive;

    class function EscapeAttribute(const s: string): string;

    procedure Save(Stream: TStream; Formatted: Boolean);

    function Add(const Tag: string): TfrxHTMLItem; overload;
    function Add(Item: TfrxHTMLItem): TfrxHTMLItem; overload;
    function AddRotated(const Tag: string; ARotation: Integer): TfrxHTMLItem;
    function AddTransformed(const Tag: string; ATransformMatrix: array of Extended): TfrxHTMLItem;
    procedure AddCSSClass(const s: string);

    property Prop[Index: string]: string read GetProp write SetProp; default;
    property Value: string write FValue;
    property RawValue: AnsiString write FRawValue;
    property Name: string write FName;

    { CSS style is created on demand }
    property Style: TfrxCSSStyle read GetStyle;
    { These lengths are measured in FR units (pixels) }
    property Left: Extended read FLeft write SetLeft;
    property Top: Extended read FTop write SetTop;
    property Width: Extended read FWidth write SetWidth;
    property Height: Extended read FHeight write SetHeight;

    property AllowNegativeLeft: Boolean read FAllowNegativeLeft write FAllowNegativeLeft;
  end;

  { Queue of automatically serialised HTML tags }

  TfrxHTMLItemQueue = class
  private
    FQueue: array of TfrxHTMLItem;
    FUsed: Integer;
    FStream: TStream;
    FFormatted: Boolean;
  protected
    procedure Flush;
  public
    constructor Create(Stream: TStream; Formatted: Boolean);
    destructor Destroy; override;

    procedure Push(Item: TfrxHTMLItem);
    procedure SetQueueLength(n: Integer);
  end;

  { HTML export filter }

{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}

  TfrxHTMLDivExport = class(TExportHTMLDivSVGParent)
  private
    FTitle: string;
    FHTML5: Boolean;
    FAllPictures: Boolean;
    FPageStyle: TfrxCSSStyle;
    FExportAnchors: Boolean;
    FPictureTag: Integer;

    FQueue: TfrxHTMLItemQueue; // it represents the current page

    function GetPageStyle: TfrxCSSStyle;
    function GetAnchor(var Page: string; const Name: string): Boolean;
    function GetHRef(const URL: string): string;
    procedure PutImg(Obj: TfrxView; Pic: TGraphic; WriteSize: Boolean);
    procedure StartHTML;
    procedure EndHTML;

    { Handlers for specific kinds of TfrxView objects.
      They return "True" if they succeed to export an object, or "False"
      if they want to pass the object further along the handlers chain. }
    function ExportTaggedView(Obj: TfrxView): Boolean;
    function ExportAllPictures(Obj: TfrxView): Boolean;
    function ExportMemo(Obj: TfrxView): Boolean;
    function ExportPicture(Obj: TfrxView): Boolean;
    function ExportShape(Obj: TfrxView): Boolean;
    function ExportLine(Obj: TfrxView): Boolean;
    function ExportGradient(Obj: TfrxView): Boolean;
    {$IFNDEF FPC}
    function ExportViaEMF(Obj: TfrxView): Boolean;
    {$ENDIF}
    function ExportAsPicture(Obj: TfrxView): Boolean;
  protected
    { Creates a new HTML tag and returns it. The tag don't need to be
      deleted or serialised to a stream: this is done automatically. }
    function AddTag(const Name: string): TfrxHTMLItem;
    { Creates an empty <div> tag with assigned styles }
    function CreateDiv(Obj: TfrxView; Widen: Integer = 0): TfrxHTMLItem;
    function CreateFrameDiv(Obj: TfrxView): TfrxHTMLItem;
    function CreateFillDiv(Obj: TfrxView): TfrxHTMLItem;
    procedure FillGraduienProps(Style: TfrxCSSStyle;
      BeginColor, EndColor: TColor; GradientStyle: TfrxGradientStyle);
    function FilterHTML(const Text: string): string;
    function EscapeText(const s: string): string;

    function DoHyperLink(Text: string; Obj: TfrxView): string;
    procedure DoExportAsPicture(Obj: TfrxView; Transparent: Boolean;
      TransparentColor: TColor = clNone);

    function NavPageNumber(PageNumber: Integer): string;
    procedure StartAnchors;
    procedure StartNavigator;
    procedure CreateCSS; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function GetDescription: String; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;
    { function ShowModal: TModalResult; override; }

    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure Finish; override;

    { Report pages are represented as separate <div> tags. All these tags
      are associated with the same CSS style, so its possible to adjust
      appearance of pages by modifying this style. Example:

      PageStyle['border'] := '1mm solid orange';
      PageStyle['margin'] := '5mm';
      PageStyle.CSS3Style['box-shadow'] := '3mm 3mm 3mm gray';
      PageStyle.cSS3Style['border-radius'] := '3mm'; }
    property PageStyle: TfrxCSSStyle read GetPageStyle;
  published
    property Title: string read FTitle write FTitle;

    { Allows using HTML5 features }
    property HTML5: Boolean read FHTML5 write FHTML5;

    { Exports all report components as pictures }
    property AllPictures: Boolean read FAllPictures write FAllPictures;

    { Creates anchors based on TfrxView.URL property. This option is useful only if
      the URLs begin with the "#" sign. }
    property ExportAnchors: Boolean read FExportAnchors write FExportAnchors;

    { If not equals zero, forces the export to save all report components
      with this value of the Tag property export as pictures. The format of pictures
      is defined by PictureFormat. }
    property PictureTag: Integer read FPictureTag write FPictureTag;
  end;

  { HTML export that uses modern HTML5 features }
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}

  TfrxHTML5DivExport = class(TfrxHTMLDivExport)
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  end;

  { HTML export that is compatible with old browsers, like IE6 }
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}

  TfrxHTML4DivExport = class(TfrxHTMLDivExport)
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  end;

implementation

uses
  Contnrs,
  frxUtils,
  frxRes,
  Math,
  frxXML, // for access to TfrxPreviewPages.FindAnchor's results
  frxPreviewPages,
  {$IFNDEF FPC}frxEMFtoSVGExport,{$ENDIF} frxExportHTMLDivDialog;

const
  wbFrame = 1;
  wbExport = 2;

{ Utility routines }

function FRLength(a: Extended; AllowNegative: Boolean = False): string;
var
  ra: Integer;
begin
  ra := Round(a);
  Result := IfStr(not AllowNegative and (ra <= 0), '0', IntToStr(ra) + 'px');
end;

function GetLineStyle(s: TfrxFrameStyle): string;
begin
  case s of
    fsSolid:
      Result := 'solid';
    fsDash:
      Result := 'dashed';
    fsDot:
      Result := 'dotted';
    fsDashDot:
      Result := 'dashed';
    fsDashDotDot:
      Result := 'dotted';
    fsDouble:
      Result := 'double';
    fsAltDot:
      Result := 'dotted';
    fsSquare:
      Result := 'dotted';
  else
    Result := '';
  end;
end;

function GetFrameLineStyle(w: Extended; s: TfrxFrameStyle; c: TColor): string; overload;
begin
  if Round(w) = 0 then
    Result := ''
  else
    Result := FRLength(Max(w, 1.0)) + ' ' + GetLineStyle(s) + ' ' + GetColor(c)
end;

function GetFrameLineStyle(Line: TfrxFrameLine): string; overload;
begin
  Result := GetFrameLineStyle(Line.Width, Line.Style, Line.Color)
end;

function GetHAlign(Align: TfrxHAlign): string;
begin
  case Align of
    haRight:
      Result := 'right';
    haCenter:
      Result := 'center';
    haBlock:
      Result := 'justify';
  else
    Result := '';
  end;
end;

function GetVAlign(Align: TfrxVAlign): string;
begin
  case Align of
    vaTop:
      Result := 'top';
    vaBottom:
      Result := 'bottom';
    vaCenter:
      Result := 'middle';
  else
    Result := '';
  end;
end;

function GetFont(Font: TFont): string;
begin
  Result := IfStr(fsBold in Font.Style, 'bold ') + IfStr(fsItalic in Font.Style,
    'italic ') + IntToStr(Font.Size) + 'pt ' + Font.Name
end;

function GetTextDecoration(s: TFontStyles): string;
begin
  Result := IfStr(fsUnderline in s, 'underline ') + IfStr(fsStrikeOut in s,
    'line-through')
end;

{ TfrxHTMLDivExportDialog }

{ TfrxHTMLDivExport }

function TfrxHTMLDivExport.AddTag(const Name: string): TfrxHTMLItem;
begin
  Result := TfrxHTMLItem.Create(Name);
  FQueue.Push(Result);
end;

constructor TfrxHTMLDivExport.Create(AOwner: TComponent);
begin
  inherited;
  DefaultExt := GetStr('HTMLExtension');
  FilterDesc := frxGet(9301);
  { LIFO }
  AttachHandler(ExportAsPicture);
  AttachHandler(ExportPicture);
  {$IFNDEF FPC}
  AttachHandler(ExportViaEMF);
  {$ENDIF}
  AttachHandler(ExportGradient);
  AttachHandler(ExportLine);
  AttachHandler(ExportShape); // Without Fill (except skRectangle)
  AttachHandler(ExportMemo);
  AttachHandler(ExportAllPictures);
  AttachHandler(ExportTaggedView);
end;

procedure TfrxHTMLDivExport.CreateCSS;
begin
  inherited;

  FCSS := TfrxCSS.Create;

  with FCSS do
  begin
    Add('div, img, table')['position'] := 'absolute';
    Add('div, td')['overflow'] := 'hidden';

    Add('sub')['font-size'] := '0.67em';

    with Add('sup') do
    begin
      Style['font-size'] := '0.67em';
      Style['vertical-align'] := 'top';
      Style['position'] := 'relative';
      Style['top'] := '-0.2em';
    end;

    Add('svg')['vertical-align'] := 'top';

    with Add('tr, td, table, tbody') do
    begin
      Style['text-decoration'] := 'inherit';
      Style['vertical-align'] := 'inherit';
    end;

    with Add('table') do
    begin
      Style['width'] := '100%';
      Style['height'] := '100%';
      Style['border-spacing'] := '0';
      if not HTML5 then
      begin
        Style['border'] := '0';
        Style['padding'] := '0';
      end;
    end;

    Add('img')['z-index'] := '1';

    with Add('.nav') do
    begin
      Style['font-family'] := 'Courier New, monospace';
      Style['font-size'] := '16';
      Style['font-weight'] := 'bold';
      Style['margin'] := '1em';
    end;

    with Add('.nav a') do
    begin
      Style['text-decoration'] := 'none';
      Style['margin-right'] := '1em';
      Style['color'] := 'black';
    end;

    Add('.nav a:hover')['text-decoration'] := 'underline';

    if FPageStyle <> nil then
      FPageStyle.AssignTo(Add('.page'));
  end;
end;

function TfrxHTMLDivExport.CreateDiv(Obj: TfrxView; Widen: Integer = 0): TfrxHTMLItem;
var
  rBounds: TfrxRect;
begin
  Result := AddTag('div');
  Result.Gaude(Obj);
  Result.DoPositive;
  if      Widen = wbFrame then
    Result.WidenBy(Obj.Frame.Width)
  else if Widen = wbExport then
  begin
    Result.AllowNegativeLeft := True;
    rBounds := Obj.GetExportBounds;
    Result.Left := rBounds.Left;
    Result.Width := rBounds.Right - rBounds.Left;
    Result.Top := rBounds.Top;
    Result.Height := rBounds.Bottom - rBounds.Top;
  end;

  if Obj.ShowHint then
    Result.Prop['title'] := Obj.Hint;
  with Result do
    if Obj.URL <> '' then
      with Add('a') do
      begin
        Style['width'] := '100%';
        Style['height'] := '100%';
        Style['position'] := 'absolute';

        Prop['href'] := GetHRef(Obj.URL);
      end;
end;

function TfrxHTMLDivExport.CreateFillDiv(Obj: TfrxView): TfrxHTMLItem;

  function SVGPatternFill(XLine, YLine, Turn: Boolean; Color: TColor;
    Width, Height: Integer; LineWidth: Extended): string;
  var
    PatternName: string;
  begin
    PatternName := SVGUniqueID;
    with TTextFragment.Create(Formatted) do
    begin
      Add('<svg width="100%" height="100%">');

      Add(SVGPattern(Formatted, XLine, YLine, Turn, Color, LineWidth,
        PatternName));

      Add('<rect width="%u" height="%u" fill="url(#%s)" />',
        [Width, Height, PatternName]);

      Add('</svg>');

      Result := Text;
      Free;
    end;
  end;

var
  Width, Height: Integer;

  function PF(LineColor: TColor; XLine, YLine, Turn: Boolean): string;
  begin
    PF := SVGPatternFill(XLine, YLine, Turn, LineColor, Width, Height, 1.4);
  end;

var
  x, y, w2, h2: Integer;
begin
  Result := nil;
  if (Obj.FillType = ftBrush) and
    (TfrxBrushFill(Obj.Fill).Style in [bsSolid, bsClear]) and
    (TfrxBrushFill(Obj.Fill).BackColor = clNone) { transparent brush } or
    (Obj.FillType = ftGlass) and (TfrxGlassFill(Obj.Fill).Color = clNone)
  { transparent glass } then
    Exit;

  Result := AddTag('div');
  Result.Gaude(Obj);

  Width := Round(Result.Width);
  Height := Round(Result.Height);
  case Obj.FillType of
    ftBrush:
      with TfrxBrushFill(Obj.Fill) do
      begin
        with TfrxCSSStyle.Create do
        begin
          Style['background'] := GetColor(BackColor);
          Result.AddCSSClass(LockStyle(This));
        end;

        case Style of
          bsHorizontal:
            Result.Value := PF(ForeColor, True, False, False);
          bsVertical:
            Result.Value := PF(ForeColor, False, True, False);
          bsFDiagonal:
            Result.Value := PF(ForeColor, True, False, True);
          bsBDiagonal:
            Result.Value := PF(ForeColor, False, True, True);
          bsCross:
            Result.Value := PF(ForeColor, True, True, False);
          bsDiagCross:
            Result.Value := PF(ForeColor, True, True, True);
        else // bsSolid, bsClear:
        end;
      end;
    ftGradient:
      with TfrxGradientFill(Obj.Fill) do
        with TfrxCSSStyle.Create do
        begin
          FillGraduienProps(This, StartColor, EndColor,
            TfrxGradientStyle(GradientStyle));
          Result.AddCSSClass(LockStyle(This));
        end;
    ftGlass:
      with TfrxGlassFill(Obj.Fill) do
      begin
        with TfrxCSSStyle.Create do
        begin
          Style['background'] := frxExportHelpers.GetColor(Color);
          Result.AddCSSClass(LockStyle(This));
        end;
        x := 0;
        y := 0;
        w2 := Width;
        h2 := Height;
        CalcGlassRect(Orientation, 0, 0, x, y, w2, h2);
        with TTextFragment.Create(Formatted) do
        begin
          Add('<svg width="100%" height="100%">');
          Add('<rect x="%d" y="%d" width="%u" height="%u" fill="%s" />',
            [x, y, w2, h2, frxExportHelpers.GetColor(BlendColor)]);
          if Hatch then
            Add(PF(HatchColor, False, True, True));
          Add('</svg>');
          Result.Value := Text;
          Free;
        end;
      end;
  end;
end;

function TfrxHTMLDivExport.CreateFrameDiv(Obj: TfrxView): TfrxHTMLItem;

  procedure FillFrameProps(Style: TfrxCSSStyle; Frame: TfrxFrame);
  var
    L, T, r, B: string;
  begin
    L := IfStr(ftLeft in Frame.Typ, GetFrameLineStyle(Frame.LeftLine));
    T := IfStr(ftTop in Frame.Typ, GetFrameLineStyle(Frame.TopLine));
    r := IfStr(ftRight in Frame.Typ, GetFrameLineStyle(Frame.RightLine));
    B := IfStr(ftBottom in Frame.Typ, GetFrameLineStyle(Frame.BottomLine));

    if (L = T) and (L = r) and (L = B) then
      Style['border'] := L
    else
    begin
      Style['border-left'] := L;
      Style['border-top'] := T;
      Style['border-right'] := r;
      Style['border-bottom'] := B;
    end;

    if Frame.DropShadow and HTML5 then
      with Style do
        PrefixStyle['box-shadow'] := FRLength(Frame.ShadowWidth) + ' ' +
          FRLength(Frame.ShadowWidth) + ' ' + FRLength(Frame.ShadowWidth) + ' '
          + GetColor(Frame.ShadowColor);
  end;

begin
  Result := nil;
  if (Obj.Frame.Typ = []) and not(Obj.Frame.DropShadow and HTML5) then
    Exit;
  Result := AddTag('div');

  Result.GaudeFrame(Obj);

  with TfrxCSSStyle.Create do
  begin
    FillFrameProps(This, Obj.Frame);
    Result.AddCSSClass(LockStyle(This));
  end;

end;

destructor TfrxHTMLDivExport.Destroy;
begin
  FPageStyle.Free; // it's created by the getter of PageStyle
  inherited
end;

procedure TfrxHTMLDivExport.DoExportAsPicture(Obj: TfrxView;
  Transparent: Boolean; TransparentColor: TColor = clNone);
var
  Pic: TfrxPicture;
  PF: TfrxPictureFormat;
  Correction: Integer;
begin
  if Transparent then
    PF := pfPNG
  else
    PF := PictureFormat;

  Correction := IfInt(Obj is TfrxShapeView, 2);

  { Some objects can have negative dimensions }
  Pic := TfrxPicture.Create(PF, Abs(Round(Obj.AbsLeft + Obj.Width) -
    Round(Obj.AbsLeft)) + Correction,
    Abs(Round(Obj.AbsTop + Obj.Height) - Round(Obj.AbsTop)) + Correction);

  Pic.FillColor(clWhite);
  Obj.DrawClipped(Pic.Canvas, 1, 1, -Obj.AbsLeft, -Obj.AbsTop);

  if Transparent then
    Pic.SetTransparentColor(TransparentColor);

  PutImg(Obj, Pic.Release, False);
  Pic.Free;
end;

function TfrxHTMLDivExport.DoHyperLink(Text: string; Obj: TfrxView): string;

  function FileByAnchor: string;
  begin
    Result := IntToStr((Report.PreviewPages as TfrxPreviewPages)
      .GetAnchorPage(Obj.Hyperlink.Value)) + DefaultExt;
  end;

var
  Start, Finish: string;

  procedure SetHL(const Fmt: string; const Args: array of const);
  begin
    Start := Format(Fmt, Args);
    Finish := '</a>'
  end;

var
  OHV: string;

begin
  Start := '';
  Finish := '';
  if Obj.Hyperlink <> nil then
  begin
    OHV := TfrxHTMLItem.EscapeAttribute(Obj.Hyperlink.Value);
    if OHV <> '' then
      case Obj.Hyperlink.Kind of
        hkURL:
          SetHL('<a href="%s" target="_blank">', [OHV]);
        hkAnchor:
          if MultiPage then
            SetHL('<a href="%s#%s">', [FileByAnchor, OHV])
          else
            SetHL('<a href="#%s">', [OHV]);
        hkPageNumber:
          if MultiPage then
            SetHL('<a href="%s">', [OHV + DefaultExt])
          else
            SetHL('<a href="#page%s">', [OHV]);
      else { hkDetailReport:, hkDetailPage:, hkCustom: }
      end;
  end;
  Result := Start + Text + Finish;
end;

procedure TfrxHTMLDivExport.EndHTML;
begin
  { <style> can only appear inside <head>, but there's no other way
    to embed styles and this approach works perfectly for all browsers. }
  if EmbeddedCSS then
  begin
    Puts('<style>');
    FCSS.Save(FCurrentFile, Formatted);
    Puts('</style>');
  end;

  Puts('</body>');
  Puts('</html>');

  FreeStream;
end;

function TfrxHTMLDivExport.EscapeText(const s: string): string;
begin
  Result := StrFindAndReplace(s, ':', ['&:&amp;', '<:&lt;', '>:&gt;',
    '":&quot;', ''':&#39;', #13':', '  : &nbsp;', #10':<br />']);
end;

function TfrxHTMLDivExport.ExportAllPictures(Obj: TfrxView): Boolean;
begin
  Result := AllPictures and ExportAsPicture(Obj)
end;

function TfrxHTMLDivExport.ExportAsPicture(Obj: TfrxView): Boolean;
begin
  DoExportAsPicture(Obj, False);
  CreateFrameDiv(Obj);
  Result := True;
end;

class function TfrxHTMLDivExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxHTMLDivExportDialog;
end;

function TfrxHTMLDivExport.ExportGradient(Obj: TfrxView): Boolean;
var
  Grad: TfrxGradientView;
begin
  Result := Obj is TfrxGradientView;
  if not Result then
    Exit;

  Grad := Obj as TfrxGradientView;

  if Result then
    with CreateDiv(Obj) do
      with TfrxCSSStyle.Create do
      begin
        FillGraduienProps(This, Grad.BeginColor, Grad.EndColor, Grad.Style);

        if Count > 0 then
          AddCSSClass(LockStyle(This));
      end;

  CreateFrameDiv(Obj);
end;

function TfrxHTMLDivExport.ExportLine(Obj: TfrxView): Boolean;
var
  Line: TfrxLineView;
begin
  Result := Obj is TfrxLineView;
  if not Result then
    Exit;

  Line := Obj as TfrxLineView;

  if not Line.Diagonal then
    CreateFrameDiv(Line)
  else if HTML5 then
    with CreateDiv(Line, wbFrame) do
      with TTextFragment.Create(Formatted) do
      begin
        Add('<svg width="100%" height="100%">');
        Add(SVGLine(Formatted, True, FCSS, Line));
        Add('</svg>');
        Value := Text;
        Free;
      end;
end;

function TfrxHTMLDivExport.ExportMemo(Obj: TfrxView): Boolean;
var
  Memo: TfrxCustomMemoView;

  procedure FillProps(Style: TfrxCSSStyle);
  begin
    with Style do
    begin
      Style['color'] := GetColor(Memo.Font.Color);
      Style['font'] := GetFont(Memo.Font);
      Style['text-decoration'] := GetTextDecoration(Memo.Font.Style);

      Style['text-align'] := GetHAlign(Memo.HAlign);
      Style['cursor'] := GetCursor(Memo.Cursor);

      { It's ok to ignore vaTop and vaCenter alignments.
        For vaTop a <div> is created which has the top alignment
        by default; for vaCenter a <table> is created which has
        the middle alignment by default. }
      Style['vertical-align'] := GetVAlign(Memo.VAlign);

      if Memo.ParagraphGap > 0 then
        Style['text-indent'] := FRLength(Memo.ParagraphGap);

      if Memo.CharSpacing <> 0 then
        Style['letter-spacing'] := FRLength(Memo.CharSpacing, True);

      Style['line-height'] :=
        IntToStr(Round(Memo.Font.Size * 96 / 72 + Memo.LineSpacing)) + 'px';

      if Memo.GapY > 0.5 then
        case Memo.VAlign of
          vaTop:
            Style['padding-top'] := Format('%dpx', [Round(Memo.GapY)]);
          vaBottom:
            Style['padding-bottom'] := Format('%dpx', [Round(Memo.GapY)]);
        else // vaCenter:
        end;

      if Memo.GapX > 0.5 then
      begin
        if Memo.HAlign in [haLeft, haBlock] then
          Style['padding-left'] := Format('%dpx', [Round(Memo.GapX)]);
        if Memo.HAlign in [haRight, haBlock] then
          Style['padding-right'] := Format('%dpx', [Round(Memo.GapX)]);
      end;

      if (Memo.Hyperlink <> nil) and (Memo.Hyperlink.Value <> '') then
        Style['z-index'] := '1';

    end;
  end;

const
  WidthFactor: array [TfrxHAlign] of Integer = (1, 1, 0, 2);
  // (haLeft, haRight, haCenter, haBlock);
  HeightFactor: array [TfrxVAlign] of Integer = (1, 1, 0);
  // (vaTop, vaBottom, vaCenter);

var
  Text: string;
  InnerTag: TfrxHTMLItem;
  IsEmpty: Boolean;
begin
  Result := Obj is TfrxCustomMemoView;
  if not Result then
    Exit;

  Memo := Obj as TfrxCustomMemoView;
  CreateFillDiv(Memo);

  Text := {$IFDEF Delphi12} Trim(Memo.Lines.Text);
          {$ELSE}           Trim(UTF8Encode(Memo.Lines.Text));
          {$ENDIF}
  IsEmpty := Memo.HideZeros and (Text = '0') or (Text = '');
  if not IsEmpty then
    if Memo.ReducedAngle <> 0 then
      CreateDiv(Obj).RawValue := ExportViaVector(Obj)
    else
      with CreateDiv(Memo) do
      begin
        Width := Width - WidthFactor[Memo.HAlign] * Round(Memo.GapX);
        Height := Height - HeightFactor[Memo.VAlign] * Round(Memo.GapY);

        with TfrxCSSStyle.Create do
        begin
          FillProps(This);
          AddCSSClass(LockStyle(This));
        end;

        if Memo.VAlign = vaTop then
          InnerTag := This
        else
          InnerTag := Add('table').Add('tr').Add('td');

        Text := EscapeText(Text);
        if Memo.AllowHTMLTags then
          Text := FilterHTML(Text);

        InnerTag.Value := DoHyperLink(Text, Memo);
      end;

  CreateFrameDiv(Memo);
end;

function TfrxHTMLDivExport.ExportPicture(Obj: TfrxView): Boolean;
var
  PictureView: TfrxPictureView;
  Typ: TfrxFrameTypes;
begin
  Result := Obj is TfrxPictureView;
  if not Result then
    Exit;

  CreateDiv(Obj);

  PictureView := (Obj as TfrxPictureView);
  if PictureView.Picture.Graphic <> nil then
  begin
    if PictureView.Transparent or UnifiedPictures then
    begin
      Typ := Obj.Frame.Typ;
      Obj.Frame.Typ := [];
      DoExportAsPicture(Obj, PictureView.Transparent,
        PictureView.TransparentColor);
      Obj.Frame.Typ := Typ;
    end
    else
      PutImg(Obj, PictureView.Picture.Graphic, True);
  end
  else if PictureView.Color <> clNone then
    CreateFillDiv(Obj);

  CreateFrameDiv(Obj);
end;

function TfrxHTMLDivExport.ExportShape(Obj: TfrxView): Boolean;
var
  Shape: TfrxShapeView;
begin
  Result := (Obj is TfrxShapeView);
  if not Result then
    Exit;
  Shape := Obj as TfrxShapeView;

  if Shape.Shape = skRectangle then
    CreateFillDiv(Obj);

  with CreateDiv(Obj, wbFrame) do
    if HTML5 then
      with TTextFragment.Create(Formatted) do
      begin
        Add('<svg width="100%" height="100%">');

        Add(SVGShapePath(Shape, spStroke + spHTML));

        Add('</svg>');

        Value := Text;
        Free;
      end;
end;

function TfrxHTMLDivExport.ExportTaggedView(Obj: TfrxView): Boolean;
begin
  Result := (PictureTag <> 0) and (Obj.Tag = PictureTag) and
    ExportAsPicture(Obj);
end;

{$IFNDEF FPC}
function TfrxHTMLDivExport.ExportViaEMF(Obj: TfrxView): Boolean;
var
  MS1, MS2: TMemoryStream;
  MF: TMetafile;
  EMFtoSVG: TEMFtoSVGExport;
  AnsiTemp: AnsiString;
begin
  Result := Obj.IsEMFExportable;
  if not Result then
    Exit;

  CreateFillDiv(Obj);

  if HTML5 then
  begin
    MS1 := TMemoryStream.Create;
    MS2 := nil;
    try
      MF := TMetaFile(Obj.GetVectorGraphic);
      MF.SaveToStream(MS1);
      MS1.Position := 0;
      MS2 := TMemoryStream.Create;
      EMFtoSVG := TEMFtoSVGExport.Create(MS1, MS2);
      EMFtoSVG.LinearBarcode :=
        (AnsiUpperCase(Obj.ClassName) = 'TFRXBARCODEVIEW');
      try
//        EMFtoSVG.ShowComments := True; { TODO : Debug }
        EMFtoSVG.Formatted := Formatted;
        EMFtoSVG.ForceMitterLineJoin := True;
        EMFtoSVG.SetEmbedded(FCSS, 0, 0);
        EMFtoSVG.PlayMetaFile;
      finally
        MF.Free;
        EMFtoSVG.Free;
      end;

      MS2.Position := 0;
      SetLength(AnsiTemp, MS2.Size);
      MS2.ReadBuffer(AnsiTemp[1], MS2.Size);
      CreateDiv(Obj, wbExport).RawValue := AnsiTemp;
    finally
      MS1.Free;
      MS2.Free;
    end;
  end;

  CreateFrameDiv(Obj);
end;
{$ENDIF}

function TfrxHTMLDivExport.GetAnchor(var Page: string;
  const Name: string): Boolean;
var
  a: TfrxXMLItem;
begin
  Result := Report.PreviewPages is TfrxPreviewPages;
  if not Result then
    Exit;

  a := (Report.PreviewPages as TfrxPreviewPages).FindAnchor(Name);
  if a = nil then
    Exit;

  Page := a.Prop['page'];
  Result := Page <> '';
end;

class function TfrxHTMLDivExport.GetDescription: String;
begin
  Result := GetStr('9300')
end;

function TfrxHTMLDivExport.GetHRef(const URL: string): string;
var
  Page: string;
begin
  if URL = '' then
    Result := ''
  else
    case URL[1] of
      '@':
        if MultiPage then
          Result := Copy(URL, 2, Length(URL)) + '.html'
        else
          Result := '#page' + Copy(URL, 2, Length(URL));

      '#':
        if ExportAnchors and GetAnchor(Page, Copy(URL, 2, Length(URL))) then
          try
            Result := '#page' + IntToStr(StrToInt(Page) + 1)
          except
            Result := ''
          end;

    else
      Result := URL
    end
end;

function TfrxHTMLDivExport.GetPageStyle: TfrxCSSStyle;
begin
  if FPageStyle = nil then
    FPageStyle := TfrxCSSStyle.Create;

  Result := FPageStyle;
end;

procedure TfrxHTMLDivExport.FillGraduienProps(Style: TfrxCSSStyle;
  BeginColor, EndColor: TColor; GradientStyle: TfrxGradientStyle);
begin
  if HTML5 then
    case GradientStyle of
      gsHorizontal:
        Style.PrefixStyle['background'] :=
          Format('linear-gradient(to right, %s, %s)',
          [GetColor(BeginColor), GetColor(EndColor)]);

      gsHorizCenter:
        Style.PrefixStyle['background'] :=
          Format('linear-gradient(to right, %s, %s, %s)',
          [GetColor(BeginColor), GetColor(EndColor), GetColor(BeginColor)]);

      gsVertical:
        Style.PrefixStyle['background'] := Format('linear-gradient(%s, %s)',
          [GetColor(BeginColor), GetColor(EndColor)]);

      gsVertCenter:
        Style.PrefixStyle['background'] := Format('linear-gradient(%s, %s, %s)',
          [GetColor(BeginColor), GetColor(EndColor), GetColor(BeginColor)]);

      gsRectangle, gsElliptic:
        Style.PrefixStyle['background'] :=
          Format('radial-gradient(ellipse, %s, %s)',
          [GetColor(EndColor), GetColor(BeginColor)]);
    end;
end;

function TfrxHTMLDivExport.FilterHTML(const Text: string): string;

  function RestoreTag(const Source, Tag: string): string;
  const
    LeftBracket = '&lt;';
    RightBracket = '&gt;';
  var
    OutStr, SubStr, Rest: string;

    function IsFound(const SearchStr, ReplaceStr: string): Boolean;
    var
      p: Integer;
    begin
      p := Pos(SearchStr, Rest);
      Result := p > 0;
      if Result then
      begin
        OutStr := OutStr + Copy(Rest, 1, p - 1) + ReplaceStr;
        Delete(Rest, 1, p - 1 + Length(SearchStr));
      end;
    end;

  begin
    Rest := Source;
    OutStr := '';
    SubStr := LeftBracket + Tag;
    while IsFound(SubStr, '<' + Tag) and IsFound(RightBracket, '>') do;
    Result := OutStr + Rest;
  end;

  function Tag(T: string): string;
  begin
    Result := Format('&lt;%s&gt;:<%s>', [T, T]);
  end;

begin
  Result := StrFindAndReplace(Text, ':', [Tag('b'), Tag('/b'), Tag('strong'),
    Tag('/strong'), Tag('i'), Tag('/i'), Tag('em'), Tag('/em'), Tag('u'),
    Tag('/u'), Tag('s'), Tag('/s'), Tag('br'), Tag('br/'), Tag('br /'),
    Tag('sub'), Tag('/sub'), Tag('sup'), Tag('/sup'), Tag('/font')]);
  Result := RestoreTag(Result, 'font');
end;

procedure TfrxHTMLDivExport.FinishPage(Page: TfrxReportPage; Index: Integer);
begin
  FQueue.Free;

  Puts('</div>'); // <div class="page">...</div>

  if MultiPage then
    EndHTML;

  inherited
end;

procedure TfrxHTMLDivExport.Finish;
begin
  if not MultiPage then
    EndHTML;

  if not Assigned(Stream) and not EmbeddedCSS then
    SaveCSS(GetCSSFilePath);

  FPictures.Free;
  FCSS.Free;
end;

function TfrxHTMLDivExport.NavPageNumber(PageNumber: Integer): string;
begin
  Result := Format('page%u', [PageNumber]);
end;

procedure TfrxHTMLDivExport.PutImg(Obj: TfrxView; Pic: TGraphic;
  WriteSize: Boolean);
begin
  if not IsCanSavePicture(Pic) then
    Exit;

  PutsRaw('<img style="');

  PutsRaw('left:' + AnsiString(FRLength(Obj.AbsLeft)));
  PutsRaw(';top:' + AnsiString(FRLength(Obj.AbsTop)));

  if WriteSize then
  begin
    PutsRaw(';width:' + AnsiString(FRLength(Round(Obj.AbsLeft + Obj.Width) -
      Round(Obj.AbsLeft))));

    PutsRaw(';height:' + AnsiString(FRLength(Round(Obj.AbsTop + Obj.Height) -
      Round(Obj.AbsTop))));
  end;

  Puts('" src="');

  SavePicture(Pic);

  Puts('">');
end;
{
  function TfrxHTMLDivExport.ShowModal: TModalResult;

  procedure DisableCB(CB: TCheckBox);
  begin
  CB.State := cbGrayed;
  CB.Enabled := False;
  end;

  begin
  Result := mrOk;
  if Assigned(Stream) then Exit;

  with TfrxHTMLDivExportDialog.Create(nil) do
  try
  if SlaveExport then
  begin
  OpenAfterExport := False;
  DisableCB(OpenCB);

  EmbeddedCSS := True;
  DisableCB(StylesCB);

  EmbeddedPictures := True;
  DisableCB(PicturesCB);

  MultiPage := False;
  DisableCB(MultipageCB);

  Navigation := False;
  DisableCB(NavigationCB);

  PictureFormat := pfPNG;
  PFormatCB.Enabled := False;

  UnifiedPictures := True;
  DisableCB(UnifiedPicturesCB);
  end;

  OpenCB.Checked := OpenAfterExport;
  StylesCB.Checked := EmbeddedCSS;
  PicturesCB.Checked := EmbeddedPictures;
  MultipageCB.Checked := MultiPage;
  NavigationCB.Checked := Navigation;
  UnifiedPicturesCB.Checked := UnifiedPictures;
  FormattedCB.Checked := Formatted;
  PFormatCB.ItemIndex := Integer(PictureFormat);

  if PageNumbers <> '' then
  begin
  PageNumbersE.Text     := PageNumbers;
  PageNumbersRB.Checked := True;
  end;

  if OverwritePrompt then
  sd.Options := sd.Options + [ofOverwritePrompt];
  sd.FileName := FileName;
  sd.DefaultExt := DefaultExt;
  sd.Filter := GetStr('9301');
  if (FileName = '') and not SlaveExport then
  sd.FileName := ChangeFileExt(
  ExtractFileName(frxUnixPath2WinPath(Report.FileName)), sd.DefaultExt);

  Result := ShowModal;

  if Result = mrOk then
  begin
  OpenAfterExport := OpenCB.Checked;
  EmbeddedCSS := StylesCB.Checked;
  EmbeddedPictures := PicturesCB.Checked;
  MultiPage := MultipageCB.Checked;
  Navigation := NavigationCB.Checked;
  UnifiedPictures := UnifiedPicturesCB.Checked;
  Formatted := FormattedCB.Checked;
  PictureFormat := TfrxPictureFormat(PFormatCB.ItemIndex);

  PageNumbers := '';
  CurPage := CurPageRB.Checked;
  if PageNumbersRB.Checked then
  PageNumbers := PageNumbersE.Text;

  if not SlaveExport then
  begin
  if DefaultPath <> '' then
  sd.InitialDir := DefaultPath;
  if sd.Execute then
  FileName := sd.FileName
  else
  Result := mrCancel;
  end;
  end;
  finally
  Free
  end;
  end;
}

procedure TfrxHTMLDivExport.StartAnchors;
var
  AnchorRoot: TfrxXMLItem;
  i: Integer;
  stCurrentPage: String;
  SL: TStringList;
begin
  SL := TStringList.Create;

  stCurrentPage := IntToStr(FCurrentPage - 1);
  AnchorRoot := (Report.PreviewPages as TfrxPreviewPages).FindAnchorRoot;
  if Assigned(AnchorRoot) then
    for i := 0 to AnchorRoot.Count - 1 do
      if (AnsiCompareText(AnchorRoot[i].Prop['page'], stCurrentPage) = 0) and
        (SL.IndexOf(AnchorRoot[i].Prop['text']) = -1) then
      begin
        SL.Add(AnchorRoot[i].Prop['text']);
        Puts('<div id="%s" style="left:0;top:%spx;width:0;height:0;"></div>',
          [TfrxHTMLItem.EscapeAttribute(AnchorRoot[i].Prop['text']),
          AnchorRoot[i].Prop['top']]);
      end;

  SL.Free;
end;

procedure TfrxHTMLDivExport.StartHTML;
begin
  if HTML5 then
    Puts('<!doctype html>')
  else
    Puts('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" ' +
      '"http://www.w3.org/TR/html4/strict.dtd">');

  Puts('<html>');
  Puts('<head>');
  Puts('<title>%s</title>', [Title]);
  Puts('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">');

  if not EmbeddedCSS then
    Puts('<link rel="stylesheet" href="%s">', [GetCSSFileName]);

  Puts('</head>');
  Puts('<body>');
end;

procedure TfrxHTMLDivExport.StartNavigator;
begin
  if Formatted then
    Puts('<!-- navigation -->');

  Puts('<div class="nav" style="position:relative">');

  if FCurrentPage > 1 then
  begin
    Puts('<a href="%u%s" title="Goto page %u">|&#9668; First</a>',
      [1, DefaultExt, 1]);
    Puts('<a href="%u%s" title="Goto page %d">&#9668; Back</a>',
      [FCurrentPage - 1, DefaultExt, FCurrentPage - 1]);
  end
  else
  begin
    Puts('<a href="#">|| First</a>');
    Puts('<a href="#">| Back</a>');
  end;

  if FCurrentPage < Report.PreviewPages.Count then
  begin
    Puts('<a href="%d%s" title="Goto page %d">Next &#9658;</a>',
      [FCurrentPage + 1, DefaultExt, FCurrentPage + 1]);
    Puts('<a href="%u%s" title="Goto page %u">Last &#9658;|</a>',
      [Report.PreviewPages.Count, DefaultExt, Report.PreviewPages.Count]);
  end
  else
  begin
    Puts('<a href="#">Next |</a>');
    Puts('<a href="#">Last ||</a>');
  end;

  Puts('</div>');
end;

procedure TfrxHTMLDivExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  inherited;

  FQueue := TfrxHTMLItemQueue.Create(FCurrentFile, Formatted);

  if MultiPage or (FCurrentPage = 1) then
    StartHTML;

  if MultiPage and Navigation then
    StartNavigator;

  if Formatted then
    Puts('<!-- page #%d -->', [Index]);

  Puts('<div id="page%d" class="page" style="position:relative;width:%s;height:%s">',
    [Index + 1, FRLength(Page.Width), FRLength(Page.Height)]);

  StartAnchors;
end;

{ TfrxHTMLItem }

function TfrxHTMLItem.Add(const Tag: string): TfrxHTMLItem;
begin
  Result := TfrxHTMLItem.Create(Tag);
  FChildren.Add(Result);
end;

function TfrxHTMLItem.Add(Item: TfrxHTMLItem): TfrxHTMLItem;
begin
  FChildren.Add(Item);
  Result := Item;
end;

procedure TfrxHTMLItem.AddCSSClass(const s: string);
begin
  if FClass = '' then
    FClass := s
  else
    FClass := FClass + ' ' + s
end;

function TfrxHTMLItem.AddRotated(const Tag: string; ARotation: Integer)
  : TfrxHTMLItem;
begin
  Result := TfrxHTMLItem.Create(Tag);
  Result.FRotation := ARotation;
  FChildren.Add(Result);
end;

function TfrxHTMLItem.AddTransformed(const Tag: string;
  ATransformMatrix: array of Extended): TfrxHTMLItem;
var
  i: Integer;
begin
  Result := TfrxHTMLItem.Create(Tag);
  Result.FIsTransformMatrix := True;
  SetLength(Result.FTM, Length(ATransformMatrix));
  for i := 0 to High(Result.FTM) do
    Result.FTM[i] := ATransformMatrix[i];
  FChildren.Add(Result);
end;

constructor TfrxHTMLItem.Create(const Name: string);
begin
  FName := Name;
  FKeys := TStringList.Create;
  FValues := TStringList.Create;
  FChildren := TObjList.Create;
  FAllowNegativeLeft := False;
  FIsTransformMatrix := False;
end;

destructor TfrxHTMLItem.Destroy;
begin
  FKeys.Free;
  FValues.Free;
  FChildren.Free;
  FStyle.Free;
  inherited;
end;

procedure TfrxHTMLItem.DoPositive;
begin
  if Width < 0 then
    Left := Left + Width;
  Width := Abs(Width);
  if Height < 0 then
    Top := Top + Height;
  Height := Abs(Height);
end;

class function TfrxHTMLItem.EscapeAttribute(const s: string): string;
begin
  Result := StrFindAndReplace(s, ':', ['&:&amp;', '<:&lt;', '>:&gt;',
    '":&quot;', ''':&#39;', #13, '  : &nbsp;']);
end;

procedure TfrxHTMLItem.Gaude(Obj: TfrxView);
begin
  GaudeFrame(Obj);
  if ftLeft in Obj.Frame.Typ then
    Left := Left + Obj.Frame.LeftLine.Width;
  if ftTop in Obj.Frame.Typ then
    Top := Top + Obj.Frame.TopLine.Width;
end;

procedure TfrxHTMLItem.GaudeFrame(Obj: TfrxView);
var
  BGauge: TfrxBoundsGauge;
begin
  BGauge := TfrxBoundsGauge.Create;
  BGauge.Obj := Obj;

  Left := BGauge.Bounds.Left;
  Top := BGauge.Bounds.Top;
  Width := BGauge.InnerWidth;
  Height := BGauge.InnerHeight;

  BGauge.Free;
end;

function TfrxHTMLItem.GetProp(Index: string): string;
var
  i: Integer;
begin
  Result := '';
  i := FKeys.IndexOf(Index);
  if i <> -1 then
    Result := FValues[i];
end;

function TfrxHTMLItem.GetStyle: TfrxCSSStyle;
begin
  if FStyle = nil then
    FStyle := TfrxCSSStyle.Create;

  Result := FStyle;
end;

procedure TfrxHTMLItem.Save(Stream: TStream; Formatted: Boolean);

  procedure PutsRaw(const s: AnsiString);
  begin
    Stream.Write(s[1], Length(s))
  end;

  procedure Puts(const s: string; IsNeedEndLine: Boolean = False);
  begin
    if s <> '' then
    begin
{$IFDEF Delphi12}
      PutsRaw(AnsiString(UTF8Encode(s)));
{$ELSE}
      PutsRaw(AnsiString(s));
{$ENDIF}
      if IsNeedEndLine then
        PutsRaw(AnsiString(#13#10))
    end;
  end;

  function DontNeedEndLine(const T: string): Boolean;
  begin
    Result := (T = 'a') or (T = 'tr') or (T = 'td')
  end;

  function IsShortTag(const T: string): Boolean;
  begin
    Result := (T = 'tr') or (T = 'td') or (T = 'p') or (T = 'img')
  end;

  procedure WriteDim;
  begin
    if FLeftSet then
      Style['left'] := FRLength(Left, AllowNegativeLeft);

    if FTopSet then
      Style['top'] := FRLength(Top);

    if FWidthSet then
      Style['width'] := FRLength(Round(Left + Width) - Round(Left));

    if FHeightSet then
      Style['height'] := FRLength(Round(Top + Height) - Round(Top));

    if FRotation <> 0 then
      Style['transform'] := Format('rotate(%ddeg)', [FRotation]);

    if FIsTransformMatrix then
      Style['transform'] := Format('matrix(%s, %s, %s, %s, %s, %s)',
        [frFloat2Str(FTM[0], 3), frFloat2Str(FTM[1], 3), frFloat2Str(FTM[2], 3),
         frFloat2Str(FTM[3], 3), frFloat2Str(FTM[4], 0), frFloat2Str(FTM[5], 0)]);

    if FStyle <> nil then
      Puts(' style="' + FStyle.Text + '"');
  end;

var
  ShortTag: Boolean;
  i: Integer;
begin
  ShortTag := IsShortTag(FName);

  Puts('<' + FName);

  for i := 0 to FKeys.Count - 1 do
    Puts(' ' + FKeys[i] + '="' + string(EscapeAttribute(FValues[i])) + '"');

  if FClass <> '' then
    Puts(' class="' + FClass + '"');

  WriteDim;

  Puts('>', Formatted and not DontNeedEndLine(FName));

  for i := 0 to FChildren.Count - 1 do
    TfrxHTMLItem(FChildren[i]).Save(Stream, Formatted);

  if FValue <> '' then
    Puts(FValue, Formatted);

  if FRawValue <> '' then
    PutsRaw(FRawValue);

  if not ShortTag then
    Puts('</' + FName + '>', Formatted);
end;

procedure TfrxHTMLItem.SetHeight(a: Extended);
begin
  FHeightSet := True;
  FHeight := a;
end;

procedure TfrxHTMLItem.SetLeft(a: Extended);
begin
  FLeftSet := True;
  FLeft := a;
end;

procedure TfrxHTMLItem.SetProp(Index: string; const Value: string);
begin
  FKeys.Add(Index);
  FValues.Add(Value);
end;

procedure TfrxHTMLItem.SetTop(a: Extended);
begin
  FTopSet := True;
  FTop := a;
end;

procedure TfrxHTMLItem.SetWidth(a: Extended);
begin
  FWidthSet := True;
  FWidth := a;
end;

function TfrxHTMLItem.This: TfrxHTMLItem;
begin
  Result := Self
end;

procedure TfrxHTMLItem.WidenBy(Size: Extended);
begin
  Left := Left - Size / 2;
  Top := Top - Size / 2;
  Width := Width + Size;
  Height := Height + Size;
end;

{ TfrxHTMLItemQueue }

constructor TfrxHTMLItemQueue.Create(Stream: TStream; Formatted: Boolean);
begin
  FStream := Stream;
  FFormatted := Formatted;
  SetQueueLength(10);
end;

destructor TfrxHTMLItemQueue.Destroy;
begin
  Flush;
  inherited
end;

procedure TfrxHTMLItemQueue.Flush;
var
  i: Integer;
begin
  for i := 0 to FUsed - 1 do
    with FQueue[i] do
    begin
      Save(FStream, FFormatted);
      Free;
    end;

  FUsed := 0
end;

procedure TfrxHTMLItemQueue.Push(Item: TfrxHTMLItem);
begin
  if FUsed = Length(FQueue) then
    Flush;

  FQueue[FUsed] := Item;
  Inc(FUsed);
end;

procedure TfrxHTMLItemQueue.SetQueueLength(n: Integer);
begin
  if FUsed > 0 then
    raise Exception.Create('Cannot resize a nonempty queue');

  SetLength(FQueue, n)
end;

{ TfrxBoundsGauge }

procedure TfrxBoundsGauge.AddBounds(r: TRect);
begin
  if not FBoundsSet then
    FBounds := r
  else
    with FBounds do
    begin
      Left := Min(Left, r.Left);
      Right := Max(Right, r.Right);
      Top := Min(Top, r.Top);
      Bottom := Max(Bottom, r.Bottom);
    end;

  FBoundsSet := True;
end;

procedure TfrxBoundsGauge.BeginDraw;
begin
  with Obj do
  begin
    FX := Round(AbsLeft);
    FY := Round(AbsTop);
    FX1 := Round(AbsLeft + Width) - Round(ShadowSize);
    FY1 := Round(AbsTop + Height) - Round(ShadowSize);

    FDX := FX1 - FX;
    FDY := FY1 - FY;

    FFrameWidth := Round(Frame.Width);
  end;
end;

procedure TfrxBoundsGauge.DrawBackground;
begin
  with FObj do
  begin
    AddBounds(Rect(FX, FY, FX1 - 1, FY1 - 1));

    if BrushStyle <> bsSolid then
      AddBounds(Rect(FX, FY, FX1, FY1));
  end;
end;

procedure TfrxBoundsGauge.DrawFrame;
var
  d, PenWidth: Integer;

  procedure Line(x, y, x1, y1: Integer; Line: TfrxFrameLine; Typ: TfrxFrameType;
    gap1, gap2: Boolean);
  var
    g1, g2, fw: Integer;

  begin
    fw := Round(Line.Width);

    if Line.Style in [fsSolid, fsDouble] then
    begin
      if gap1 then
        g1 := 0
      else
        g1 := 1;
      if gap2 then
        g2 := 0
      else
        g2 := 1;

      if Typ in [ftTop, ftBottom] then
      begin
        x := x + (fw * g1 div 2);
        x1 := x1 - (fw * g2 div 2);
      end
      else
      begin
        y := y + (fw * g1 div 2);
        y1 := y1 - (fw * g2 div 2);
      end;
    end;

    DrawLine(x, y, x1, y1, fw, Typ);
  end;

  procedure SetPen(Line: TfrxFrameLine);
  begin
    if Line.Style in [fsSolid, fsDouble] then
      PenWidth := Round(Line.Width)
    else
      PenWidth := 1;
  end;

begin
  with Obj do
    if (Frame.Typ <> []) and (Frame.Color <> clNone) and (Frame.Width <> 0) then
    begin
      if ftLeft in Frame.Typ then
      begin
        SetPen(Frame.LeftLine);

        if (PenWidth = 2) and (Frame.Style <> fsSolid) then
          d := 1
        else
          d := 0;

        Line(FX, FY - d, FX, FY1, Frame.LeftLine, ftLeft, ftTop in Frame.Typ,
          ftBottom in Frame.Typ);
      end;

      if ftRight in Frame.Typ then
      begin
        SetPen(Frame.RightLine);

        Line(FX1, FY, FX1, FY1, Frame.RightLine, ftRight, ftTop in Frame.Typ,
          ftBottom in Frame.Typ);
      end;

      if ftTop in Frame.Typ then
      begin
        SetPen(Frame.TopLine);

        Line(FX, FY, FX1, FY, Frame.TopLine, ftTop, ftLeft in Frame.Typ,
          ftRight in Frame.Typ);
      end;

      if ftBottom in Frame.Typ then
      begin
        SetPen(Frame.BottomLine);

        if (PenWidth = 1) and (Frame.Style <> fsSolid) then
          d := 1
        else
          d := 0;

        Line(FX, FY1, FX1 + d, FY1, Frame.BottomLine, ftBottom,
          ftLeft in Frame.Typ, ftRight in Frame.Typ);
      end;
    end;
end;

procedure TfrxBoundsGauge.DrawLine(x1, y1, x2, y2, w: Integer;
  Side: TfrxFrameType);
var
  LineBounds: TRect;
begin
  with LineBounds do
  begin
    Left := x1 - w div 2;
    Top := y1 - w div 2;
    Right := x2 + w - w div 2 - 1;
    Bottom := y2 + w - w div 2 - 1;
  end;

  AddBounds(LineBounds);

  with FBorders do
    case Side of
      ftLeft:
        Left := w;
      ftRight:
        Right := w;
      ftTop:
        Top := w;
      ftBottom:
        Bottom := w;
    end;
end;

function TfrxBoundsGauge.GetInnerHeight: Integer;
begin
  if FBoundsSet then
    Result := FBounds.Bottom - FBounds.Top + 1
  else
    Result := 0;

  Dec(Result, FBorders.Bottom + FBorders.Top);
end;

function TfrxBoundsGauge.GetInnerWidth: Integer;
begin
  if FBoundsSet then
    Result := FBounds.Right - FBounds.Left + 1
  else
    Result := 0;

  Dec(Result, FBorders.Right + FBorders.Left);
end;

procedure TfrxBoundsGauge.SetObj(Obj: TfrxView);
begin
  FObj := Obj;
  FBoundsSet := False;
  FBounds := Rect(0, 0, 0, 0);
  FBorders := Rect(0, 0, 0, 0);

  { Simulates TfrxView.Draw, but computes bounds and borders
    instead of actual drawing. }
  BeginDraw;
  DrawBackground;
  DrawFrame;
end;

{ TfrxHTML5DivExport }

constructor TfrxHTML5DivExport.Create(AOwner: TComponent);
begin
  inherited;

  HTML5 := True; // use HTML5 features
  ExportAnchors := True; // export page anchors
  Navigation := True;

  { Make a rounded border around each page }

  PageStyle['border'] := '1mm solid orange'; // CSS1 style
  PageStyle['margin'] := '5mm'; // cSS1 style
  PageStyle.PrefixStyle['box-shadow'] := '3mm 3mm 3mm gray'; // CSS3 style
  PageStyle.PrefixStyle['border-radius'] := '2mm'; // CSS3 style
end;

class function TfrxHTML5DivExport.GetDescription: String;
begin
  Result := GetStr('9303')
end;

{ TfrxHTML4DivExport }

constructor TfrxHTML4DivExport.Create(AOwner: TComponent);
begin
  inherited;

  ExportAnchors := True; // export page anchors
  EmbeddedPictures := False; // embed pictures into HTML
  EmbeddedCSS := False; // embed CSS into HTML
end;

class function TfrxHTML4DivExport.GetDescription: String;
begin
  Result := GetStr('9304')
end;

end.
