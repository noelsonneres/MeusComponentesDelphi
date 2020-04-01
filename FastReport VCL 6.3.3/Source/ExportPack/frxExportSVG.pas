
{******************************************}
{                                          }
{             FastReport v6.0              }
{              SVG 1.1 Export              }
{                                          }
{         Copyright (c) 2015-2018          }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportSVG;

interface

{$I frx.inc}

uses
  Windows,
  Classes,
  StrUtils,
  Graphics,
  frxClass,
  frxExportBaseDialog,
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
{$IFDEF Delphi10}
  WideStrings,
{$ENDIF}
  frxExportHelpers,
  frxUnicodeUtils;

type
  { SVG export filter }

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxSVGExport = class(TExportHTMLDivSVGParent)
  private
    FShadowStyle: TfrxCSSStyle;

    function GetShadowStyle: TfrxCSSStyle;
    procedure PutImage(Obj: TfrxView; Pic: TGraphic);
    procedure StartSVG(Width, Height: Extended);
    procedure FinishSVG;

    { Handlers for specific kinds of TfrxView objects.
      They return "True" if they succeed to export an object, or "False"
      if they want to pass the object further along the handlers chain. }
    function ExportAsPicture  (Obj: TfrxView): Boolean;
    function ExportPicture    (Obj: TfrxView): Boolean;
    function ExportViaEMF     (Obj: TfrxView): Boolean;
    function ExportGradient   (Obj: TfrxView): Boolean;
    function ExportLine       (Obj: TfrxView): Boolean;
    function ExportShape      (Obj: TfrxView): Boolean;
    function ExportMemo       (Obj: TfrxView): Boolean;
  protected
    FGlobalPageY: Extended;

    procedure RunExportsChain(Obj: TfrxView); override;

    procedure DoGradient(Obj: TfrxView; BeginValue, EndValue: string; Style: TfrxGradientStyle; ClipValue: string = '');
    procedure DoFrameLine(x1, y1, x2, y2: Extended; frxFrameLine: TfrxFrameLine);
    procedure DoFill(Obj: TfrxView);
    procedure DoFrame(Obj: TfrxView);
    procedure DoFilledRect(x, y, Width, Height: integer; FillValue: string; ClipValue: string = ''); overload;
    procedure DoFilledRect(Obj: TfrxView; FillValue: string; ClipValue: string = ''); overload;
    function DoHyperLink(Obj: TfrxView): boolean;
    procedure DoExportAsPicture(Obj: TfrxView; Transparent: boolean; TransparentColor: TColor = clNone);
    function WrapByTSpan(const TextList: TWideStrings; Memo: TfrxCustomMemoView;
                         const x, dy, Width: Extended): WideString;
    function DefineShapeClipPath(Obj: TfrxView): string;
    function DefineRectClipPath(Obj: TfrxView): string;

    procedure StartAnchors;
    procedure StartNavigator;
    procedure CreateCSS; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function GetDescription: string; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;

    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure Finish; override;

    property ShadowStyle: TfrxCSSStyle read GetShadowStyle;
  published
  end;

implementation

uses ShellAPI, SysUtils, frxUtils, frxRes, Math, frxPreviewPages, frxGradient,
     frxXML, frxEMFtoSVGExport, frxStorage, frxExportSVGDialog, frxDMPClass;

{ TfrxSVGExport }

const
  PageIndent = 20;
  ShadowOpacity = '0.5';
  ShadowFilterName = 'pageshadowfilter';
  ShadowStyleName = 'shadow';
  BorderHalfWidth = 0.5;

constructor TfrxSVGExport.Create(AOwner: TComponent);
begin
  inherited;
  DefaultExt := GetStr('SVGExtension');
  FilterDesc := GetStr('SVGFilter');
  { LIFO }
  AttachHandler(ExportAsPicture);
  AttachHandler(ExportPicture);
  AttachHandler(ExportViaEMF);
  AttachHandler(ExportGradient);
  AttachHandler(ExportLine);
  AttachHandler(ExportShape);
  AttachHandler(ExportMemo);

  { Make a shadowed border around each page }
  ShadowStyle['fill'] := 'white';
  ShadowStyle['filter'] := 'url(#' + ShadowFilterName + ')';
  ShadowStyle['opacity'] := ShadowOpacity;
  ShadowStyle['stroke'] := 'black';
  ShadowStyle['stroke-width'] := IntToStr(Round(BorderHalfWidth * 2));
end;

procedure TfrxSVGExport.CreateCSS;
begin
  inherited;

  FCSS := TfrxCSS.Create;
  FShadowStyle.AssignTo(FCSS.Add('.' + ShadowStyleName));

  with FCSS do
  begin
    with Add('.nav') do
    begin
      Style['font-family'] := 'Courier New, monospace';
      Style['font-size'] := '16';
      Style['font-weight'] := 'bold';
    end;

    with Add('.nav a') do
    begin
      Style['text-decoration'] := 'none';
      Style['color'] := 'black';
    end;

    Add('.nav a:hover')['text-decoration'] := 'underline';
  end;
end;

function TfrxSVGExport.DefineRectClipPath(Obj: TfrxView): string;
var
  x, y, w, h: string;
begin
  Result := SVGUniqueID;

  w := frFloat2Str(Obj.Width - Obj.ShadowSize, 1);
  h := frFloat2Str(Obj.Height - Obj.ShadowSize, 1);
  x := frFloat2Str(Obj.AbsLeft, 1);
  y := frFloat2Str(Obj.AbsTop, 1);

  if Obj is TfrxDMPMemoView then
  begin
    w := frFloat2Str(Obj.Width + fr1CharX - Obj.ShadowSize, 1);
    h := frFloat2Str(Obj.Height + fr1CharY - Obj.ShadowSize, 1);
    x := frFloat2Str(Obj.AbsLeft - fr1CharX / 2, 1);
    y := frFloat2Str(Obj.AbsTop - fr1CharY / 2, 1);
  end;


  Puts('<defs><clipPath id="%s">', [Result]);
  Puts('<rect x="%s" y="%s" width="%s" height="%s"/>', [x, y, w, h]);
  Puts('</clipPath></defs>');
end;

function TfrxSVGExport.DefineShapeClipPath(Obj: TfrxView): string;
begin
  Result := '';
  if Obj is TfrxShapeView then
    with Obj as TfrxShapeView do
      if Shape in [skRectangle, skRoundRectangle, skEllipse, skTriangle, skDiamond] then
      begin
        Result := SVGUniqueID;
        Puts('<defs><clipPath id="%s">', [Result]);
        Puts(SVGShapePath(Obj as TfrxShapeView));
        Puts('</clipPath></defs>');
      end;
end;

destructor TfrxSVGExport.Destroy;
begin
  FShadowStyle.Free; // it's created by the getter
  inherited
end;

procedure TfrxSVGExport.DoExportAsPicture(Obj: TfrxView; Transparent: boolean; TransparentColor: TColor);
var
  Pic: TfrxPicture;
  PF: TfrxPictureFormat;
begin
  if Transparent then PF := pfPNG
  else                PF := PictureFormat;

  { Some objects can have negative dimensions }
  Pic := TfrxPicture.Create(PF,
    Abs(Round(Obj.AbsLeft + Obj.Width) - Round(Obj.AbsLeft)),
    Abs(Round(Obj.AbsTop + Obj.Height) - Round(Obj.AbsTop)));

  Pic.FillColor(clWhite);
  Obj.DrawClipped(Pic.Canvas, 1, 1, -Obj.AbsLeft, -Obj.AbsTop);

  if Transparent then
    Pic.SetTransparentColor(TransparentColor);

  PutImage(Obj, Pic.Release);
  Pic.Free;
end;

procedure TfrxSVGExport.DoFill(Obj: TfrxView);
var
  ClipValue: string;

  procedure DefineAndFillPattern(XLine, YLine, Turn: boolean; Color: TColor);
  var
    PatternName: string;
  begin
    PatternName := SVGUniqueID;

    Puts(SVGPattern(Formatted, XLine, YLine, Turn, Color, 1.4, PatternName));

    DoFilledRect(Obj, Format('url(#%s)', [PatternName]), ClipValue);
  end;

var
  x, y, Width, Height: integer;

begin
  ClipValue := DefineShapeClipPath(Obj);
  case Obj.FillType of
    ftBrush:
      with Obj.Fill as TfrxBrushFill do
      begin
        DoFilledRect(Obj, GetColor(BackColor), ClipValue);
        case (Obj.Fill as TfrxBrushFill).Style of
          bsHorizontal: DefineAndFillPattern(True,  False, False, ForeColor);
          bsVertical:   DefineAndFillPattern(False, True,  False, ForeColor);
          bsFDiagonal:  DefineAndFillPattern(True,  False, True,  ForeColor);
          bsBDiagonal:  DefineAndFillPattern(False, True,  True,  ForeColor);
          bsCross:      DefineAndFillPattern(True,  True,  False, ForeColor);
          bsDiagCross:  DefineAndFillPattern(True,  True,  True,  ForeColor);
          else // bsSolid, bsClear:
        end;
      end;
    ftGradient:
      with Obj.Fill as TfrxGradientFill do
        DoGradient(Obj, frxExportHelpers.GetColor(StartColor), frxExportHelpers.GetColor(EndColor), GradientStyle, ClipValue);
    ftGlass:
      with Obj.Fill as TfrxGlassFill do
        if Color <> clNone then
        begin
          DoFilledRect(Obj, frxExportHelpers.GetColor(Color), ClipValue);
          x := Round(Obj.AbsLeft);
          y := Round(Obj.AbsTop);
          Width :=  Round(Obj.Width - Obj.ShadowSize);
          Height := Round(Obj.Height - Obj.ShadowSize);
          CalcGlassRect(Orientation, Obj.AbsTop, Obj.AbsLeft, x, y, Width, Height);
          DoFilledRect(x, y, Width, Height, frxExportHelpers.GetColor(BlendColor), ClipValue);
          if Hatch then
            DefineAndFillPattern(False, True, True, HatchColor);
        end;
  end;
end;

procedure TfrxSVGExport.DoFilledRect(x, y, Width, Height: integer; FillValue: string; ClipValue: string = '');
var
  ClipPath: string;
begin
  if FillValue <> 'transparent' then
  begin
    ClipPath := IfStr(ClipValue <> '', Format(' clip-path="url(#%s)"', [ClipValue]));

    Puts('<rect x="%d" y="%d" width="%d" height="%d" fill="%s"%s/>',
      [x, y, Width, Height, FillValue, ClipPath]);
  end;
end;

procedure TfrxSVGExport.DoFilledRect(Obj: TfrxView; FillValue: string; ClipValue: string = '');
begin
  DoFilledRect(Round(Obj.AbsLeft), Round(Obj.AbsTop),
               Round(Obj.Width - Obj.ShadowSize),   Round(Obj.Height - Obj.ShadowSize),
               FillValue, ClipValue);
end;

procedure TfrxSVGExport.DoFrame(Obj: TfrxView);
var
  Left, Top, Right, Bottom, sw: Extended;
  isLeft, isRight, isTop, isBottom: boolean;

  function Addition(isSide: boolean): Extended;
  begin
    Result := IfReal(isSide, sw / 2);
  end;
begin
  Left := Obj.AbsLeft;
  Top := Obj.AbsTop;
  Right := Left + Obj.Width;
  Bottom := Top + Obj.Height;
  if Obj.Frame.DropShadow then
  begin
    sw := Obj.Frame.ShadowWidth;
    Right := Right - sw;
    Bottom := Bottom - sw;
    // Shadow
    Puts('<path d="M %d,%d H %d V %d H %d V %d H %d Z" fill="%s"/>',
      [Round(Right), Round(Top + sw), Round(Right + sw), Round(Bottom + sw),
       Round(Left + sw), Round(Bottom), Round(Right), GetColor(Obj.Frame.ShadowColor)]);
  end;
  isLeft := ftLeft in Obj.Frame.Typ;
  isRight := ftRight in Obj.Frame.Typ;
  isTop := ftTop in Obj.Frame.Typ;
  isBottom := ftBottom in Obj.Frame.Typ;
  if isLeft then
    DoFrameLine(Left,  Top    - IfReal(isTop, Obj.Frame.TopLine.Width / 2),
                Left,  Bottom + IfReal(isBottom, Obj.Frame.BottomLine.Width / 2),
                Obj.Frame.LeftLine);
  if isRight then
    DoFrameLine(Right, Top    - IfReal(isTop, Obj.Frame.TopLine.Width / 2),
                Right, Bottom + IfReal(isBottom, Obj.Frame.BottomLine.Width / 2),
                Obj.Frame.RightLine);
  if isTop then
    DoFrameLine(Left  - IfReal(isLeft, Obj.Frame.LeftLine.Width / 2), Top,
                Right + IfReal(isRight, Obj.Frame.RightLine.Width / 2), Top,
                Obj.Frame.TopLine);
  if isBottom then
    DoFrameLine(Left  - IfReal(isLeft, Obj.Frame.LeftLine.Width / 2), Bottom,
                Right + IfReal(isRight, Obj.Frame.RightLine.Width / 2), Bottom,
                Obj.Frame.BottomLine);
end;

function TfrxSVGExport.DoHyperLink(Obj: TfrxView): boolean;

  function FileByAnchor: string;
  begin
    Result := IntToStr((Report.PreviewPages as TfrxPreviewPages).GetAnchorPage(Obj.Hyperlink.Value))
            + DefaultExt;
  end;

  function PutsTrue(const Fmt: string; const Args: array of const): boolean;
  begin
    Puts(Fmt, Args);
    Result := True; // :-)
  end;

var
  OHV: string;

begin
  Result := False;
  if Obj.Hyperlink <> nil then
  begin
    OHV := SVGEscapeTextAndAttribute(Obj.Hyperlink.Value);
    if OHV <> '' then
      case Obj.Hyperlink.Kind of
        hkURL:
          Result := PutsTrue('<a xlink:href="%s" target="_blank">', [OHV]);
        hkAnchor:
          if MultiPage then
            Result := PutsTrue('<a xlink:href="%s#%s">', [FileByAnchor, OHV])
          else
            Result := PutsTrue('<a xlink:href="#%s">', [OHV]);
        hkPageNumber:
          if MultiPage then
            Result := PutsTrue('<a xlink:href="%s">', [OHV + DefaultExt])
          else
            Result := PutsTrue('<a xlink:href="#page%s">', [OHV]);
        hkDetailReport: ;
        hkDetailPage: ;
      else {hkCustom:}
      end;
  end;
end;

procedure TfrxSVGExport.DoFrameLine(x1, y1, x2, y2: Extended; frxFrameLine: TfrxFrameLine);
var
  LineWidth: Extended;
  Dasharray, w1, w2, CSSClassName: string;
begin
  LineWidth := frxFrameLine.Width;
  if frxFrameLine.Style = fsDouble then
    LineWidth := frxFrameLine.Width * 3;

  w1 := IntToStr(Round(1 * LineWidth));
  w2 := IntToStr(Round(2 * LineWidth));

  case frxFrameLine.Style of
    fsSolid, fsDouble: Dasharray := '';
    fsDash: Dasharray := '18 6';
    fsDot: Dasharray := '3 3';
    fsDashDot: Dasharray := '9 6 3 6';
    fsDashDotDot: Dasharray := '9 3 3 3 3 3';
    fsAltDot: Dasharray := w1 + ' ' + w2;
    fsSquare: Dasharray := w1 + ' ' + w1;
  end;

  with TfrxCSSStyle.Create do
  begin
    Style['stroke'] := GetColor(frxFrameLine.Color);
    Style['stroke-width'] := IntToStr(Round(LineWidth));
    Style['stroke-dasharray'] := Dasharray;
    if frxFrameLine.Style = fsDouble then
      Style['stroke-linecap'] := 'square';
    CSSClassName := LockStyle(This);
  end;

  Puts('<line x1="%d" y1="%d" x2="%d" y2="%d" class="%s"/>',
    [Round(x1), Round(y1), Round(x2), Round(y2), CSSClassName]);
end;

procedure TfrxSVGExport.DoGradient(Obj: TfrxView; BeginValue, EndValue: string; Style: TfrxGradientStyle; ClipValue: string = '');

  procedure DefineAndFillGradient(GradientValue: string; x2y2, r: boolean; c1, c2, c3: string);
  var
    GradientName: string;
  begin
    GradientName := SVGUniqueID;

    Puts('<defs>');
    Puts('<%sGradient' + IfStr(x2y2, ' x2="0%%" y2 ="100%%"') +
      IfStr(r, ' r="70%%"') + ' id="%s">', [GradientValue, GradientName]);
    Puts('<stop offset="0%%" stop-color="%s"/>', [c1]);
    if c2 <> '' then
      Puts('<stop offset="50%%" stop-color="%s"/>', [c2]);
    Puts('<stop offset="100%%" stop-color="%s"/>', [c3]);
    Puts('</%sGradient>', [GradientValue]);
    Puts('</defs>');

    DoFilledRect(Obj, Format('url(#%s)', [GradientName]), ClipValue);
  end;

begin
  case Style of
    gsHorizontal:  DefineAndFillGradient('linear', False, False, BeginValue, '', EndValue);
    gsVertical:    DefineAndFillGradient('linear', True, False, BeginValue, '', EndValue);
    gsVertCenter:  DefineAndFillGradient('linear', True, False, BeginValue, EndValue, BeginValue);
    gsHorizCenter: DefineAndFillGradient('linear', False, False, BeginValue, EndValue, BeginValue);
  else // gsElliptic, gsRectangle:
                   DefineAndFillGradient('radial', False, True, EndValue, '', BeginValue);
  end;
end;

function TfrxSVGExport.ExportAsPicture(Obj: TfrxView): Boolean;
begin
  DoExportAsPicture(Obj, False);
  Result := True;
end;

class function TfrxSVGExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxSVGExportDialog;
end;

function TfrxSVGExport.ExportGradient(Obj: TfrxView): Boolean;
begin
  Result := Obj is TfrxGradientView;
  if not Result then Exit;

  with Obj as TfrxGradientView do
    DoGradient(Obj, GetColor(BeginColor), GetColor(EndColor), Style);

  DoFrame(Obj);
end;

function TfrxSVGExport.ExportLine(Obj: TfrxView): Boolean;
begin
  Result := Obj is TfrxLineView;
  if not Result then Exit;

  Puts(SVGLine(Formatted, False, FCSS, (Obj as TfrxLineView)));

//  DoFrame(Obj); TfrxLineView has no frame
end;

function TfrxSVGExport.ExportMemo(Obj: TfrxView): Boolean;

  function IsNeedEMF(Memo: TfrxCustomMemoView): Boolean;
  var
    LeftAngleBracketPos: Integer;
  begin
    LeftAngleBracketPos := PosEx('<', Memo.Memo.Text, 1);
    Result := (Memo.HAlign = haBlock)
      or Memo.AllowHTMLTags
      and (LeftAngleBracketPos > 0)
      and (PosEx('>', Memo.Memo.Text, LeftAngleBracketPos) > 0);
  end;

  procedure FillProps(Style: TfrxCSSStyle; Memo: TfrxCustomMemoView);
  begin
    Style['cursor'] := GetCursor(Memo.Cursor);
    case Memo.HAlign of
      haRight:  Style['text-anchor'] := 'end';
      haCenter: Style['text-anchor'] := 'middle';
    else        Style['text-anchor'] := 'start'; // haLeft, haBlock:
    end;
    case Memo.VAlign of
      vaTop:    Style['dominant-baseline'] := 'text-after-edge'; // !!!
      vaCenter: Style['dominant-baseline'] := 'auto';
      vaBottom: Style['dominant-baseline'] := 'text-after-edge';
    end;
//    See WrapByTSpan
//    if Memo.CharSpacing <> 0 then
//      Style['letter-spacing'] := IntToStr(Round(Memo.CharSpacing), True);

    Style['font-family'] := Memo.Font.Name + ';';
    Style['font-size'] := IntToStr(Memo.Font.Size) + 'pt;';
    Style['fill'] := GetColor(Memo.Font.Color) + ';';
    Style['font-weight'] := IfStr(fsBold in Memo.Font.Style, 'bold;');
    Style['font-style'] := IfStr(fsItalic in Memo.Font.Style, 'italic;');
    Style['text-decoration'] := IfStr(fsStrikeout in Memo.Font.Style, 'line-through;');
    Style['text-decoration'] := IfStr(fsUnderline in Memo.Font.Style, 'underline;');
  end;

var
  Text, CSSClassName: WideString;
  TextLeft, TextTop, Interval: Extended;
  Lines: TWideStrings;
  Center: TfrxPoint;
  TextWidth, TextHeight: Extended;
  Memo: TfrxCustomMemoView;
begin
  Result := (Obj is TfrxCustomMemoView) and not IsNeedEMF(TfrxCustomMemoView(Obj));
  if not Result then
    Exit;

  DoFill(Obj);

  Memo := Obj as TfrxCustomMemoView;
  if Memo.ReducedAngle <> 0 then
    PutsA(ExportViaVector(Obj))
  else
  begin
    Lines := {$IFDEF Delphi10} TfrxWideStrings.Create;
             {$ELSE}           TWideStrings.Create;
             {$ENDIF}
    Memo.WrapText(True, Lines);

    TextWidth := Memo.Width - Memo.ShadowSize - 2 * Memo.GapX - Memo.Frame.Width;
    TextHeight := Memo.Height - Memo.ShadowSize - 2 * Memo.GapY - Memo.Frame.Width;
    Center := frxPoint(Memo.AbsLeft + Memo.Width / 2 - Memo.ShadowSize / 2,
                            Memo.AbsTop + Memo.Height / 2 - Memo.ShadowSize / 2);

    if Lines.Count > 0 then
    begin
      with TfrxCSSStyle.Create do
      begin
        FillProps(This, Memo);
        CSSClassName := LockStyle(This);
      end;

      case Memo.HAlign of
        haRight:  TextLeft := Center.X + TextWidth / 2;
        haCenter: TextLeft := Center.X;
      else        TextLeft := Center.X - TextWidth / 2; // haLeft, haBlock:
      end;

      Interval := Memo.LineSpacing + Memo.Font.Size * 96 / 72;
      Text := WrapByTSpan(Lines, Memo, TextLeft, Interval, TextWidth);

      case Memo.VAlign of
        vaTop:
          TextTop := Center.Y - TextHeight / 2 + Interval - Memo.LineSpacing;
        vaCenter:
          TextTop := Center.Y - (Lines.Count - 1) * Interval / 2 + Memo.Font.Size * 0.55;
      else //  vaBottom:
        TextTop := Center.Y + TextHeight / 2 - (Lines.Count - 1) * Interval;
      end;

      if Memo.Clipped then
        Puts('<g  clip-path="url(#%s)">', [DefineRectClipPath(Memo)]);

      Puts('<text x="%s" y="%s" width="%s" height="%s" class="%s">',
        [frFloat2Str(TextLeft, 1), frFloat2Str(TextTop, 1),
         frFloat2Str(Memo.Width, 1), frFloat2Str(Memo.Height, 1),
         CSSClassName]);
      Puts(Text);
      Puts('</text>');

      if Memo.Clipped then
        Puts('</g>');
    end;
    Lines.Free;
  end;

  DoFrame(Obj);
end;

function TfrxSVGExport.ExportPicture(Obj: TfrxView): Boolean;
var
  PictureView: TfrxPictureView;
  Typ: TfrxFrameTypes;
begin
  Result := Obj is TfrxPictureView;
  if not Result then Exit;

  PictureView := (Obj as TfrxPictureView);
  if PictureView.Picture.Graphic <> nil then
  begin
    if PictureView.Transparent or UnifiedPictures then
    begin
      Typ := Obj.Frame.Typ;
      Obj.Frame.Typ := [];
      DoExportAsPicture(Obj, PictureView.Transparent, PictureView.TransparentColor);
      Obj.Frame.Typ := Typ;
    end
    else
      PutImage(Obj, PictureView.Picture.Graphic);
  end
  else if PictureView.Color <> clNone then
    DoFilledRect(Obj, frxExportHelpers.GetColor(PictureView.Color));

  DoFrame(Obj);
end;

function TfrxSVGExport.ExportShape(Obj: TfrxView): Boolean;
begin
  Result := Obj is TfrxShapeView;
  if not Result then Exit;

  if (Obj as TfrxShapeView).Shape in [skRectangle, skRoundRectangle, skEllipse, skTriangle, skDiamond] then
    DoFill(Obj);

  Puts(SVGShapePath(Obj as TfrxShapeView, spStroke));

//  DoFrame(Obj); TfrxShapeView has no frame
end;

function TfrxSVGExport.ExportViaEMF(Obj: TfrxView): Boolean;
var
  MS: TMemoryStream;
  MF: TMetafile;
  EMFtoSVG: TEMFtoSVGExport;
begin
  Result := Obj.IsEMFExportable;
  if not Result then
    Exit;

  DoFill(Obj);
  MS := TMemoryStream.Create;
  try
    MF :=TMetaFile(Obj.GetVectorGraphic);
//    MF.SaveToFile(IntToStr(Random(1000000)) + '.emf'); { TODO : Debug File.emf}
    MF.SaveToStream(MS);
    MS.Position := 0;
    EMFtoSVG := TEMFtoSVGExport.Create(MS, FCurrentFile);
    EMFtoSVG.LinearBarcode :=
      (AnsiUpperCase(Obj.ClassName) = 'TFRXBARCODEVIEW');
    try
//      EMFtoSVG.ShowComments := True; { TODO : Debug ShowComments := True}
      EMFtoSVG.Formatted := Formatted;
      EMFtoSVG.ForceMitterLineJoin := True;

      EMFtoSVG.SetEmbedded2(FCSS, Obj);

      EMFtoSVG.PlayMetaFile;
    finally
      MF.Free;
      EMFtoSVG.Free;
    end;
  finally
    MS.Free;
  end;
  DoFrame(Obj);
end;

procedure TfrxSVGExport.Finish;
begin
  if not MultiPage then
  begin
    FinishSVG;
    FreeStream;
  end;

  if not Assigned(Stream) and not EmbeddedCSS then
    SaveCSS(GetCSSFilePath);

  FPictures.Free;
  FCSS.Free;
end;

procedure TfrxSVGExport.FinishPage(Page: TfrxReportPage; Index: Integer);
begin
  Puts('</svg>');

  if MultiPage then
  begin
    FinishSVG;
    FreeStream;
  end;

  inherited
end;

procedure TfrxSVGExport.FinishSVG;
begin
  if EmbeddedCSS then
  begin
    Puts('<style type="text/css"><![CDATA[');
    FCSS.Save(FCurrentFile, Formatted);
    Puts(']]></style>');
  end;

  Puts('</svg>');
end;

class function TfrxSVGExport.GetDescription: string;
begin
  Result := GetStr('SVGDescription');
end;

function TfrxSVGExport.GetShadowStyle: TfrxCSSStyle;
begin
  if FShadowStyle = nil then
    FShadowStyle := TfrxCSSStyle.Create;
  Result := FShadowStyle;
end;

procedure TfrxSVGExport.PutImage(Obj: TfrxView; Pic: TGraphic);
begin
  if not IsCanSavePicture(Pic) then
    Exit;

  PutsRaw(AnsiString(Format('<image x="%d" y="%d" width="%d" height="%d" xlink:href="',
   [Round(Obj.AbsLeft), Round(Obj.AbsTop), Round(Obj.Width), Round(Obj.Height)])));

  SavePicture(Pic);

  Puts('"/>');

  DoFrame(Obj);
end;

procedure TfrxSVGExport.RunExportsChain(Obj: TfrxView);
var
  IsAnchor: boolean;
begin
  IsAnchor := DoHyperLink(Obj);

  inherited RunExportsChain(Obj);

  if IsAnchor then
    Puts('</a>');
end;

procedure TfrxSVGExport.StartAnchors;
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
        Puts('<line id="%s" y1="%s"/>',
             [SVGEscapeTextAndAttribute(AnchorRoot[i].Prop['text']), AnchorRoot[i].Prop['top']]);
      end;

  SL.Free;
end;

procedure TfrxSVGExport.StartNavigator;
const
  y = '20';
begin
  if Formatted then
    Puts('<!-- navigation -->');

  if FCurrentPage > 1 then
  begin
    Puts('<a xlink:href="%u%s">', [1, DefaultExt]);
    Puts('<text x="20" y="%s" class="nav">|&#9668; First</text>', [y]);
    Puts('</a>');

    Puts('<a xlink:href="%u%s">', [FCurrentPage - 1, DefaultExt]);
    Puts('<text x="120" y="%s" class="nav">&#9668; Back</text>', [y]);
    Puts('</a>');
  end
  else
  begin
    Puts('<text x="20" y="%s" class="nav">|| First</text>', [y]);
    Puts('<text x="120" y="%s" class="nav">| Back</text>', [y]);
  end;

  if FCurrentPage < Report.PreviewPages.Count then
  begin
    Puts('<a xlink:href="%u%s">', [FCurrentPage + 1, DefaultExt]);
    Puts('<text x="220" y="%s" class="nav">Next &#9658;</text>', [y]);
    Puts('</a>');

    Puts('<a xlink:href="%u%s">', [Report.PreviewPages.Count, DefaultExt]);
    Puts('<text x="320" y="%s" class="nav">Last &#9658;|</text>', [y]);
    Puts('</a>');
  end
  else
  begin
    Puts('<text x="220" y="%s" class="nav">Next |</text>', [y]);
    Puts('<text x="320" y="%s" class="nav">Last ||</text>', [y]);
  end;

end;

procedure TfrxSVGExport.StartPage(Page: TfrxReportPage; Index: Integer);
var
  PreviewPages: TfrxPreviewPages;
  Width, Height: Extended;
  NavigatorIndent, i: integer;
  pgN: TStringList;
begin
  inherited;

  PreviewPages := Report.PreviewPages as TfrxPreviewPages;
  if MultiPage then
    StartSVG(PreviewPages.Page[FCurrentPage - 1].Width + 2 * PageIndent,
             PreviewPages.Page[FCurrentPage - 1].Height + 2 * PageIndent)
  else if FCurrentPage = 1 then
  begin
    pgN := TStringList.Create;
    frxParsePageNumbers(PageNumbers, pgN, PreviewPages.Count);
    Width := 0;
    Height := PageIndent;
    for i := 0 to PreviewPages.Count - 1 do
      if (pgN.Count = 0) or (pgN.IndexOf(IntToStr(i + 1)) >= 0) then
      begin
        Width := Max(Width, PreviewPages.PageSize[i].X);
        Height := Height + PreviewPages.PageSize[i].Y + PageIndent;
      end;
    StartSVG(Width + 2 * PageIndent, Height);
    pgN.Free;
  end;

  if Multipage and Navigation then
    StartNavigator;
  NavigatorIndent := IfInt(Multipage and Navigation, PageIndent);

  Puts('<svg x="%d" y="%d" width="%d" height="%d">',
    [Round(Page.AbsLeft + PageIndent), Round(FGlobalPageY + PageIndent + NavigatorIndent),
     Round(Page.Width + PageIndent), Round(Page.Height + PageIndent)]);

  FGlobalPageY := FGlobalPageY + Page.Height + PageIndent;

  if Formatted then
    Puts('<!-- page #%d -->', [Index]);

  Puts('<rect x="%d" y="%d" width="%d" height="%d" id="page%u" class="%s"/>',
    [Round(Page.AbsLeft + BorderHalfWidth), Round(Page.AbsTop + BorderHalfWidth),
     Round(Page.Width), Round(Page.Height), Index + 1, ShadowStyleName]);

  StartAnchors;
end;

procedure TfrxSVGExport.StartSVG(Width, Height: Extended);
begin
  if not EmbeddedCSS then
    Puts('<?xml-stylesheet type="text/css" href="%s"?>', [GetCSSFileName]);

  Puts('<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"' +
       ' width="%d" height="%d">', [Round(Width), Round(Height)]);

  Puts('<defs><filter id="%s" width="200%%" height="200%%">' +
       '<feOffset result="offOut" in="SourceAlpha" dx="10" dy="10" />' +
       '<feGaussianBlur result="blurOut" in="offOut" stdDeviation="5" />' +
       '<feBlend in="SourceGraphic" in2="blurOut" mode="normal" />'+
       '</filter></defs>', [ShadowFilterName]);

  FGlobalPageY := 0.0;
end;

function TfrxSVGExport.WrapByTSpan(const TextList: TWideStrings; Memo: TfrxCustomMemoView;
                                   const x, dy, Width: Extended): WideString;
var
  TextLength, yStep, xShift, xSpace: WideString;
  i, j: integer;
  Gap: Extended;

  function IsParagraphStart: boolean;
  begin
    Result := Integer(TextList.Objects[i]) and 1 <> 0;
  end;

  function IsParagraphFinish: boolean;
  begin
    Result := Integer(TextList.Objects[i]) and 2 <> 0;
  end;

begin
  Result := '';
  xSpace := Float2Str(Memo.CharSpacing, 1);

  for i := 0 to TextList.Count - 1 do
  begin
    Gap := IfReal(IsParagraphStart and (Memo.HAlign in [haLeft, haBlock]),
                  Memo.ParagraphGap);

    TextLength := IfStr(not IsParagraphFinish and (Memo.HAlign = haBlock),
      Format(' textLength="%d" lengthAdjust="spacingAndGlyphs"', [Round(Width - Gap)]));

    yStep := IfStr(i <> 0, Format(' dy="%s"', [frFloat2Str(dy, 2)]));

    if (Memo.CharSpacing = 0) or (Length(TextList[i]) < 2) then
      xShift := ''
    else // Style['letter-spacing'] imitation
    begin
      xShift := ' dx="0';
      for j := 2 to Length(TextList[i]) do
        xShift := xShift + ' ' + xSpace;
      xShift := xShift + '"';
    end;

    Result := Result +
              Format('<tspan x="%d"' + yStep + TextLength + xShift +'>', [Round(x + Gap)]) +
    {$IfNDef Delphi12}UTF8Encode{$EndIf}
                     (SVGEscapeTextAndAttribute(TextList[i])) +
                     '</tspan>';
  end;
end;

end.
