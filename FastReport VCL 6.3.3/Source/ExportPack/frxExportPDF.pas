
{******************************************}
{                                          }
{             FastReport v6.0              }
{            PDF export filter             }
{                                          }
{         Copyright (c) 1998-2019          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}
{      haBlock alignment improved by:      }
{              Nikolay Zverev              }
{            www.delphinotes.ru            }
{******************************************}

unit frxExportPDF;

interface

{$I frx.inc}

uses
  Windows, SysUtils, Graphics, Classes, ComObj, Printers, JPEG, Variants, Contnrs,
  frxExportBaseDialog, frxClass, frxExportPDFHelpers, frxVectorCanvas
{$IFDEF Delphi10}, WideStrings{$ENDIF}
{$IFDEF Delphi12}, AnsiStrings{$ENDIF}
{$IFDEF DELPHI16}, System.UITypes{$ENDIF}
{$IFDEF DEBUG_WITH_FASTMM}, FastMMDebugSupport, FastMMUsageTracker{$ENDIF}
    ;

{$IFDEF CPUX64}
(*$HPPEMIT '#pragma link "usp10.a"'*)
{$ELSE}
(*$HPPEMIT '#pragma link "usp10.lib"'*)
{$ENDIF}

type
  TfrxPDFEncBit = (ePrint, eModify, eCopy, eAnnot);
  TfrxPDFEncBits = set of TfrxPDFEncBit;

type
  TfrxPDFOutlineNode = class
  public
    Number: Integer;
    Dest: Integer; // Index to a page referred to by this outline node
    Top: Integer; // Position on the referred to page
    CountTree: Integer; // Number of all descendant nodes
    Count: Integer; // Number of all first-level descendants
    Title: string;

    First: TfrxPDFOutlineNode; // The first first-level descendant
    Last: TfrxPDFOutlineNode; // The last first-level descendant
    Next: TfrxPDFOutlineNode; // The next neighbouring node
    Prev: TfrxPDFOutlineNode; // The previous neighbouring node
    Parent: TfrxPDFOutlineNode; // The parent node of this node

    constructor Create;
    destructor Destroy; override;
  end;

  TfrxPDFPage = class
  public
    Height: Double;
    BackPictureVisible: Boolean;
  end;

  TfrxPDFAnnot = class
  public
    Number: Integer;
    Rect: String;
    Hyperlink: String;
    DestPage: Integer;
    DestY: Integer;
  end;

  TEmbeddedRelation = (
    erData, // The embedded file contains data which is used for the visual representation.
    erSource, // The embedded file contains the source data for the visual representation derived therefrom in the PDF part.
    erAlternative, // This data relationship should be used if the embedded data are an alternative representation of the PDF contents.
    erSupplement, // This data relationship is used if the embedded file serves neither as the source nor as the alternative representation, but the file contains additional information.
    erUnspecified // If none of the data relationships above apply or there is an unknown data relationship, this data relationship is used.
  );

  TZUGFeRD_ConformanceLevel = (
    clBASIC, // Basic level.
    clCOMFORT, // Comfort level.
    clEXTENDED // Extended level.
  );

{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}

  TfrxPDFExport = class(TfrxBaseDialogExportFilter)
  private
    FCompressed: Boolean;
    FEmbeddedFonts: Boolean;
    FEmbedProt: Boolean;
    FPrintOpt: Boolean;
    FPages: TList;
    FOutline: Boolean;
    FQuality: Integer;
    FPreviewOutline: TfrxCustomOutline;
    FSubject: WideString;
    FAuthor: WideString;
    FBackground: Boolean;
    FCreator: WideString;
    FTags: Boolean;
    FProtection: Boolean;
    FUserPassword: AnsiString;
    FOwnerPassword: AnsiString;
    FProtectionFlags: TfrxPDFEncBits;
    FKeywords: WideString;
    FTitle: WideString;
    FProducer: WideString;
    FPrintScaling: Boolean;
    FFitWindow: Boolean;
    FHideMenubar: Boolean;
    FCenterWindow: Boolean;
    FHideWindowUI: Boolean;
    FHideToolbar: Boolean;
    FTransparency: Boolean;
    FSaveOriginalImages: Boolean;

    pdf: TStream;

    FRootNumber: LongInt;
    FPagesNumber: LongInt;
    FInfoNumber: LongInt;
    FStartXRef: LongInt;

    FPOH: TPDFObjectsHelper;

    FPagesRef: TStringList;

    FWidth: Extended;
    FHeight: Extended;
    FMarginLeft: Extended;
    FMarginTop: Extended;

    FEncKey: AnsiString;
    FOPass: AnsiString;
    FUPass: AnsiString;

    FEncBits: Cardinal;
    FFileID: AnsiString;

    FLastColor: TColor;
    FLastColorResult: String;

    OutStream: TMemoryStream;

    { When an anchor is being added, two changes are made:

      - a link object is written to the document
      - a reference to the link object is added to /Annots field of the page

      FPageAnnots contains text of /Annots field.
      This stream is updated by WriteLink and its auxiliary routines. }

    FPageAnnots: TMemoryStream;
    FAnnots: TList;

    FMetaFileId: LongInt;
    FStructId: LongInt;
    FColorProfileId: LongInt;
    FAttachmentsNamesId: LongInt;
    FAttachmentsListId: LongInt;

    FPDFviaEMF: Integer;
    FPdfA: Boolean;
    FPDFStandard: TPDFStandard;
    FPDFVersion: TPDFVersion;
    FUsePNGAlpha: Boolean;

    function GetPDFDash(const LineStyle: TfrxFrameStyle;
      Width: Extended): String;
    function GetID: AnsiString;
    function CryptStr(Source: AnsiString; Key: AnsiString; Enc: Boolean;
      id: Integer): AnsiString;
    function PrepareString(const Text: WideString; Key: AnsiString;
      Enc: Boolean; id: Integer): AnsiString;
    function EscapeSpecialChar(TextStr: AnsiString): AnsiString;
    function StrToUTF16(const Value: WideString): AnsiString;
    function StrToUTF16H(const Value: WideString): AnsiString;
    function PMD52Str(p: Pointer): AnsiString;
    function PadPassword(Password: AnsiString): AnsiString;
    procedure PrepareKeys;
    procedure SetProtectionFlags(const Value: TfrxPDFEncBits);
    procedure Clear;
    procedure WriteFont(pdfFont: TfrxPDFFont);
    procedure AddObject(const Obj: TfrxView);
    procedure AddMemo(const Memo: TfrxCustomMemoView);
    procedure AddLine(const Line: TfrxCustomLineView);
    procedure AddShape(const Shape: TfrxShapeView);
    procedure AddCheckBox(const Obj: TfrxView);
{$IFNDEF RAD_ED}
    procedure AddViaEMF(const Obj: TfrxView);
{$ENDIF}
    procedure AddAsPicture(const Obj: TfrxView);

    procedure CreateColorMask(Obj: TfrxView; TransparentColorMask: TColor;
      Scale: Extended; Offset: TPoint; TempBitmap: TBitmap;
      var MaskBytes: TMaskArray);
    procedure CreatePNGMask(PictObj: TfrxPictureView;
      Scale: Extended; Offset: TPoint; TempBitmap: TBitmap;
      var MaskBytes: TMaskArray);


    function AddPage(Page: TfrxReportPage): TfrxPDFPage;
    function GetPDFColor(const Color: TColor): String;

    procedure AddAttachments;
    procedure AddEmbeddedFileItem(EmbeddedFile: TObject);
    procedure AddStructure;
    procedure AddMetaData;
    procedure AddColorProfile;
    procedure WritePDFStream(Target, Source: TStream;
      id: LongInt; Compressed, Encrypted: Boolean;
      startingBrackets, endingBrackets, enableLength2: Boolean);
    procedure SetEmbeddedFonts(const Value: Boolean);

    function GetRect(Obj: TfrxView): TfrxRect;
    function GetClipRect(Obj: TfrxView; Internal: Boolean = False): TfrxRect;
    function GetDMPRect(R: TfrxRect): TfrxRect;
    function GetRectEMFExport(Obj: TfrxView): TfrxRect;

    procedure Cmd(const Args: string);
    procedure Cmd_ObjPath(Obj: TfrxView);
    procedure Cmd_RoundRectanglePath(RoundedRect: TfrxShapeView);
    procedure Cmd_EllipsePath(Ellipse: TfrxShapeView);
    procedure Cmd_TrianglePath(Triangle: TfrxShapeView);
    procedure Cmd_DiamondPath(Diamond: TfrxShapeView);
    procedure Cmd_ClipObj(Obj: TfrxView);
    procedure Cmd_FillObj(Obj: TfrxView; Color: TColor);
    procedure Cmd_FillBrush(Obj: TfrxView; BrushFill: TfrxBrushFill);
    procedure Cmd_FillGlass(Obj: TfrxView; GlassFill: TfrxGlassFill);
    procedure Cmd_FillGradient(Obj: TfrxView; GradientFill: TfrxGradientFill);
    procedure Cmd_Hatch(Obj: TfrxView; Color: TColor; Style: TBrushStyle);
    procedure Cmd_ClipRect(Obj: TfrxView);
    function Cmd_Font(Obj: TfrxView): TfrxPDFFont;

    procedure CmdMoveTo(x, y: Extended);
    procedure CmdLineTo(x, y: Extended);
    procedure CmdCurveTo(x1, y1, x2, y2, x3, y3: Extended);
    procedure CmdFillColor(Color: TColor);
    procedure CmdStrokeColor(Color: TColor);
    procedure CmdStroke;
    procedure CmdLineWidth(Value: Extended);

    function pdfX(x: Extended): Extended;
    function pdfY(y: Extended): Extended;
    function pdfSize(Size: Extended): Extended;
    function pdfPoint(x, y: Extended): TfrxPoint;
    procedure SetPDFStandard(const Value: TPDFStandard);
    procedure SetPDFVersion(const Value: TPDFVersion);
    procedure SetTransparency(const Value: Boolean);
    procedure SetPdfA(const Value: Boolean);
  protected
    FPageRect: TfrxRect;
    stLeft, stRight, stTop, stBottom: String;
    FEmbeddedFiles: TObjectList;
    FZUGFeRDDescription: String;
    FCreationDateTime: TDateTime;

    function IsHasHTMLTags(const MemoView: TfrxCustomMemoView): Boolean;
    function IsAddViaEMF(const Obj: TfrxView): Boolean;
    procedure AddAsPictureOld(const Obj: TfrxView);
    procedure DoFill(const Obj: TfrxView);
    procedure DoFrame(const aFrame: TfrxFrame; const aRect: TfrxRect);

    function STpdfPoint(x, y: Extended): String;
    function STpdfSize(Size: Extended): String;
    function STpdfRect(x, y, Width, Height: Extended): String;

    procedure ExportViaVector(const Memo: TfrxCustomMemoView);
    procedure Vector_ExtTextOut(Memo: TfrxCustomMemoView; Vector: TVector_ExtTextOut);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;
    // function ShowModal: TModalResult; override;
    function Start: Boolean; override;
    procedure ExportObject(Obj: TfrxComponent); override;
    procedure Finish; override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure BeginClip(Obj: TfrxView); override;
    procedure EndClip; override;
    procedure AddEmbeddedFile(Name, Description: String; ModDate: TDateTime;
      Relation: TEmbeddedRelation; MIME: String; FileStream: TStream);
    procedure AddEmbeddedXML(Name, Description: String; ModDate: TDateTime;
      FileStream: TStream; ZUGFeRDLevel: TZUGFeRD_ConformanceLevel = clBASIC);
    function IsPDFA: Boolean;
    function IsPDFA_1: Boolean;

    property SaveOriginalImages: Boolean read FSaveOriginalImages write FSaveOriginalImages;
    property UsePNGAlpha: Boolean read FUsePNGAlpha write FUsePNGAlpha;
  published
    property Compressed: Boolean read FCompressed write FCompressed default True;
    property EmbeddedFonts: Boolean read FEmbeddedFonts write SetEmbeddedFonts default False;
    property EmbedFontsIfProtected: Boolean read FEmbedProt write FEmbedProt default True;
    property OpenAfterExport;
    property PrintOptimized: Boolean read FPrintOpt write FPrintOpt;
    property Outline: Boolean read FOutline write FOutline;
    property Background: Boolean read FBackground write FBackground;
    property HTMLTags: Boolean read FTags write FTags;
    property OverwritePrompt;
    property Quality: Integer read FQuality write FQuality;
    property Transparency: Boolean read FTransparency write SetTransparency;

    property Title: WideString read FTitle write FTitle;
    property Author: WideString read FAuthor write FAuthor;
    property Subject: WideString read FSubject write FSubject;
    property Keywords: WideString read FKeywords write FKeywords;
    property Creator: WideString read FCreator write FCreator;
    property Producer: WideString read FProducer write FProducer;

    property UserPassword: AnsiString read FUserPassword write FUserPassword;
    property OwnerPassword: AnsiString read FOwnerPassword write FOwnerPassword;
    property ProtectionFlags: TfrxPDFEncBits read FProtectionFlags write SetProtectionFlags;

    property HideToolbar: Boolean read FHideToolbar write FHideToolbar;
    property HideMenubar: Boolean read FHideMenubar write FHideMenubar;
    property HideWindowUI: Boolean read FHideWindowUI write FHideWindowUI;
    property FitWindow: Boolean read FFitWindow write FFitWindow;
    property CenterWindow: Boolean read FCenterWindow write FCenterWindow;
    property PrintScaling: Boolean read FPrintScaling write FPrintScaling;

    property PdfA: Boolean read FPdfA write SetPdfA; // Deprecated
    property PDFStandard: TPDFStandard read FPDFStandard write SetPDFStandard;
    property PDFVersion: TPDFVersion read FPDFVersion write SetPDFVersion;
  end;

  { Returns a color in PDF form. }

function PdfColor(Color: TColor): AnsiString;

{ Returns a pair of coordinates in PDF form. }

function pdfPoint(x, y: Double): AnsiString;

{ Moves the pen to the specified point. }

function PdfMove(x, y: Double): AnsiString;

{ Draws a line to the specified point. }

function PdfLine(x, y: Double): AnsiString;

{ Changes the current color. }

function PdfSetColor(Color: TColor): AnsiString;

{ Changes width of the line drawed by the pen.
  The width is measured in points (1/72 of an inch). }

function PdfSetLineWidth(Width: Double): AnsiString;

{ Changes the color of the pen. }

function PdfSetLineColor(Color: TColor): AnsiString;

{ Fills the latest contoured area. }

function PdfFill: AnsiString;

{ Strokes the latest contoured area. }

function PdfStroke: AnsiString;

{ Fills a rectangle area. }

function PdfFillRect(R: TfrxRect; Color: TColor): AnsiString;

{ Strokes a rectangle area. }

function PdfStrokeRect(R: TfrxRect; Color: TColor; LineWidth: Extended)
  : AnsiString;

{ Returns either (...) or <...> sequence. }

function PdfString(const Str: WideString): AnsiString;

implementation

uses
  Types,
{$IFDEF Delphi12}pngimage{$ELSE}frxpngimage{$ENDIF},
  frxUtils, frxUnicodeUtils, frxFileUtils, frxRes, frxrcExports,
  frxPreviewPages,
  frxGraphicUtils, frxGzip, frxMD5, ActiveX, SyncObjs, Math, frxXML, frxChBox,
  frxCrypto, frxRC4,
{$IFNDEF RAD_ED}
  frxEMFtoPDFExport,
{$ENDIF}
  frxExportHelpers, frxIOTransportIntf,
  frxExportPDFDialog, frxDMPClass, Forms, TypInfo;

const
  peAlways = 0;
  peAppropriately = 1;
  peNever = 2;

const
  PDF_SIGNATURE: AnsiString = #37#226#227#207#211;
  PDF_MARG_DIVIDER = 0.05;
  PDF_PRINTOPT = 3;
  PDF_PK: array [1 .. 32] of Byte = ($28, $BF, $4E, $5E, $4E, $75, $8A, $41,
    $64, $00, $4E, $56, $FF, $FA, $01, $08, $2E, $2E, $00, $B6, $D0, $68, $3E,
    $80, $2F, $0C, $A9, $FE, $64, $53, $69, $7A);
  tpPt = 0.00357; // typography pt

var
  pdfCS: TCriticalSection;

{$R frxExportPDFMetafile.RES}
{$R frxExportPDFProfile.RES}

const
  erName: array[TEmbeddedRelation] of String = (
    'Data', 'Source', 'Alternative', 'Supplement', ' Unspecified'
  );

  clName: array[TZUGFeRD_ConformanceLevel] of String = (
    'BASIC', 'COMFORT', 'EXTENDED'
  );

type
  TEmbeddedFile = class
  private
    FXRef: LongInt;
    FName: String;
    FZUGFeRD_ConformanceLevel: TZUGFeRD_ConformanceLevel;
    FFileStream: TStream;
    FDescription: String;
    FModDate: TDateTime;
    FRelation: TEmbeddedRelation;
    FMIME: String;
  public
    property Name: String read FName;
    property Description: String read FDescription;
    property ModDate: TDateTime read FModDate;
    property Relation: TEmbeddedRelation read FRelation;
    property MIME: String read FMIME;
    property FileStream: TStream read FFileStream;
    property XRef: LongInt read FXRef;
    property ZUGFeRD_ConformanceLevel: TZUGFeRD_ConformanceLevel read FZUGFeRD_ConformanceLevel;

    constructor Create;
  end;

  { PDF commands }

function PdfSetLineColor(Color: TColor): AnsiString;
begin
  Result := PdfColor(Color) + ' RG'#13#10;
end;

function PdfSetLineWidth(Width: Double): AnsiString;
begin
  Result := AnsiString(frFloat2Str(Width * PDF_DIVIDER, 2) + ' w'#13#10);
end;

function PdfStrokeRect(R: TfrxRect; Color: TColor; LineWidth: Extended)
  : AnsiString;
begin
  with R do
    Result := PdfSetLineWidth(LineWidth) + PdfSetLineColor(Color) +
      PdfMove(Left, Bottom) + PdfLine(Right, Bottom) + PdfLine(Right, Top) +
      PdfLine(Left, Top) + PdfLine(Left, Bottom) + PdfStroke;
end;

function PdfFillRect(R: TfrxRect; Color: TColor): AnsiString;
begin
  Result := PdfSetLineWidth(0) + PdfSetLineColor(Color) + PdfSetColor(Color) +
    PdfMove(R.Left, R.Bottom) + PdfLine(R.Right, R.Bottom) +
    PdfLine(R.Right, R.Top) + PdfLine(R.Left, R.Top) + PdfFill;
end;

function PdfSetColor(Color: TColor): AnsiString;
begin
  Result := PdfColor(Color) + ' rg'#13#10;
end;

function PdfStroke: AnsiString;
begin
  Result := 'S'#13#10;
end;

function PdfFill: AnsiString;
begin
  Result := 'B'#13#10;
end;

function pdfPoint(x, y: Double): AnsiString;
begin
  Result := AnsiString(frFloat2Str(x, 2) + ' ' + frFloat2Str(y, 2));
end;

function PdfLine(x, y: Double): AnsiString;
begin
  Result := pdfPoint(x, y) + ' l'#13#10;
end;

function PdfMove(x, y: Double): AnsiString;
begin
  Result := pdfPoint(x, y) + ' m'#13#10;
end;

function PdfColor(Color: TColor): AnsiString;

  function c(x: Integer): AnsiString;
  begin
    if x < 1 then
      Result := '0'
    else if x > 254 then
      Result := '1'
    else
      Result := AnsiString('0.' + IntToStr(x * 100 shr 8));

    { Actually, Result = x * 100 div 255, but
      division by 255 works much slower then
      division by 256. }
  end;

var
  R, g, b, rgb: Integer;
begin
  rgb := ColorToRGB(Color);

  R := rgb and $FF;
  g := rgb shr 8 and $FF;
  b := rgb shr 16 and $FF;

  Result := c(R) + ' ' + c(g) + ' ' + c(b);
end;

function PdfString(const Str: WideString): AnsiString;

{ A string is literal if parentheses in it are balanced and all characters
  are within the printable ASCII characters set. }

  function IsLiteralString(const s: WideString): Boolean;
  var
    i: Integer;
    nop: Integer; // number of opened parentheses
  begin
    Result := False;
    nop := 0;

    for i := 1 to Length(s) do
      if s[i] = '(' then
        Inc(nop)
      else if s[i] = ')' then
        if nop > 0 then
          Dec(nop)
        else
          Exit
          // printable ASCII characters are those with codes 32..126
      else if (Word(s[i]) < 32) or (Word(s[i]) > 126) then
        Exit;

    Result := nop = 0;
  end;

  function GetLiteralString(const s: WideString): AnsiString;
  begin
    Result := '(' + AnsiString(s) + ')'
  end;

  function GetHexString(const s: WideString): AnsiString;
  var
    i: Integer;
    hs: AnsiString;
  begin
    SetLength(Result, 2 + Length(s) * 4);
    Result[1] := '<';
    Result[Length(Result)] := '>';

    for i := 1 to Length(s) do
    begin
      hs := AnsiString(IntToHex(Word(s[i]), 4));

      Result[i * 4 - 3 + 1] := hs[1];
      Result[i * 4 - 3 + 2] := hs[2];
      Result[i * 4 - 3 + 3] := hs[3];
      Result[i * 4 - 3 + 4] := hs[4];
    end;
  end;

begin
  if IsLiteralString(Str) then
    Result := GetLiteralString(Str)
  else
    Result := GetHexString(Str)
end;

{ TfrxPDFOutlineNode }

constructor TfrxPDFOutlineNode.Create;
begin
  inherited;
  Dest := -1;
end;

destructor TfrxPDFOutlineNode.Destroy;
begin
  if Next <> nil then
    Next.Free;

  if First <> nil then
    First.Free;

  inherited;
end;

{ TfrxPDFExport }

procedure TfrxPDFExport.AddAsPicture(const Obj: TfrxView);
var
  Scale, dX, dY: Extended;
  TempSize, LeftTop: TfrxPoint;
  Offset: TPoint;
  PictObj: TfrxPictureView;

  function CalcGeometry: TPoint;
  var
    FRealBounds: TfrxRect;
    fdx, fdy, PictureSquare, TempSquare: Extended;
    iz: Integer;
  begin
    FRealBounds := Obj.GetRealBounds;
    dX := FRealBounds.Right - FRealBounds.Left;
    dY := FRealBounds.Bottom - FRealBounds.Top;

    if (dX = Obj.Width) or (Obj.AbsLeft = FRealBounds.Left) then
      fdx := 0
    else if (Obj.AbsLeft + Obj.Width) = FRealBounds.Right then
      fdx := (dX - Obj.Width)
    else
      fdx := (dX - Obj.Width) / 2;

    if (dY = Obj.Height) or (Obj.AbsTop = FRealBounds.Top) then
      fdy := 0
    else if (Obj.AbsTop + Obj.Height) = FRealBounds.Bottom then
      fdy := (dY - Obj.Height)
    else
      fdy := (dY - Obj.Height) / 2;

    if (PrintOptimized or (Obj is TfrxCustomMemoView)) and
       (Obj.BrushStyle in [bsSolid, bsClear]) then
      Scale := PDF_PRINTOPT
    else
      Scale := 1;

    iz := 0;
    if (Obj.ClassName = 'TfrxBarCodeView') and not PrintOptimized then
    begin
      Scale := 2;
      iz := 2;
    end;

    TempSize := frxPoint(dX, dY);

    PictObj := nil;
    if Obj is TfrxPictureView then
      PictObj := TfrxPictureView(Obj);

    if (PictObj <> nil) and SaveOriginalImages then
    begin
      PictureSquare := PictObj.Picture.Width * PictObj.Picture.Height;
      TempSquare := TempSize.X * TempSize.Y;
      if PictureSquare < TempSquare then
        Scale := Scale * Sqrt(PictureSquare / TempSquare);
    end;

    LeftTop := frxPoint(Obj.AbsLeft - fdx, Obj.AbsTop - fdy);

    Offset := Point(-Round(LeftTop.X * Scale) + iz,
                    -Round(LeftTop.Y * Scale));
  end;

var
  OldFrameWidth: Extended;
  TempBitmap: TBitmap;
  MaskBytes: TMaskArray;
  XMaskId: Integer;
  TransparentColorMask: TColor;
  IsTransparent, IsMasked, IsAlpha: Boolean;
  Jpg: TJPEGImage;
  XObjectStream: TStream;
  XObjectHash: TfrxPDFXObjectHash;
  PicIndex: Integer;
begin
  if Obj.Frame.Width > 0 then
  begin
    OldFrameWidth := Obj.Frame.Width;
    Obj.Frame.Width := 0;
  end
  else
    OldFrameWidth := 0;

  DoFill(Obj);
  if (Obj is TfrxPictureView) and (TfrxPictureView(Obj).Picture.Graphic = nil) then
  begin
    if OldFrameWidth > 0 then
      Obj.Frame.Width := OldFrameWidth;
    DoFrame(Obj.Frame, GetRect(Obj));
    Exit;
  end;

  CalcGeometry;

  TempBitmap := CreateBitmap(pf32bit, Round((TempSize.X + 1) * Scale),
                                      Round((TempSize.Y + 1) * Scale));
  try
    if PictObj <> nil then
    begin
      TransparentColorMask := PictObj.TransparentColor;
      IsMasked := (PictObj.TransparentColor <> clNone);
      IsAlpha := UsePNGAlpha and IsTransparentPNG(PictObj);
      IsTransparent := PictObj.Transparent and Transparency
        and (IsMasked or IsAlpha);
    end
    else
    begin
      TransparentColorMask := clWhite;
      IsMasked := True;
      IsAlpha := False;
      IsTransparent := (Obj.Color = clNone) and Transparency;
    end;

    if IsTransparent then
      try
        TempBitmap.Canvas.Lock;
        BitmapFill(TempBitmap, TransparentColorMask);
      finally
        TempBitmap.Canvas.Unlock;
      end;

    if IsTransparent then
      if IsAlpha then // create mask by png alpha chanel
        CreatePNGMask(PictObj, Scale, Offset, TempBitmap, MaskBytes)
      else if IsMasked then // create mask by trancparent color
        CreateColorMask(Obj, TransparentColorMask, Scale, Offset, TempBitmap, MaskBytes);

    try
      Obj.DrawClipped(TempBitmap.Canvas, Scale, Scale, Offset.X, Offset.Y);
    except
      // charts throw exceptions when numbers are malformed
    end;

    { Write XObject with a picture inside }
    Jpg := TJPEGImage.Create;
    try
      if (Obj.ClassName = 'TfrxBarCodeView') or (Obj is TfrxCustomLineView) or
        (Obj is TfrxShapeView) then
      begin
        Jpg.PixelFormat := jf8Bit;
        Jpg.CompressionQuality := FQuality + 5;
      end
      else
      begin
        Jpg.PixelFormat := jf24Bit;
        Jpg.CompressionQuality := FQuality;
      end;

      Jpg.Assign(TempBitmap);
      XObjectStream := TMemoryStream.Create;
      try
        Jpg.SaveToStream(XObjectStream);
        // Prepare mask
        if IsTransparent then
          SaveMask(pdf, XObjectStream, MaskBytes,
                   FPOH, TempBitmap, FProtection, FEncKey,
                   XObjectHash, XMaskId, PicIndex)
        else
        begin
          XObjectStream.Position := 0;
          GetStreamHash(XObjectHash, XObjectStream);
          PicIndex := FPOH.FindXObject(XObjectHash);
          XMaskId := 0;
        end;

        if PicIndex = -1 then
          PicIndex := FPOH.OutXObjectImage(XObjectHash, Jpg, XObjectStream,
            IsTransparent, XMaskId);
      finally
        XObjectStream.Free;
      end;
    finally
      Jpg.Free;
      SetLength(MaskBytes, 0);
    end;
  finally
    TempBitmap.Free;
  end;

  { Reference to this XObject }

  FPOH.AddUsedObject(PicIndex);

  Writeln(OutStream, 'q');
  Writeln(OutStream, frFloat2Str(dX * PDF_DIVIDER) + ' ' + '0 ' + '0 ' +
    frFloat2Str(dY * PDF_DIVIDER) + ' ' + frFloat2Str(pdfX(LeftTop.X)
    ) + ' ' + frFloat2Str(pdfY(LeftTop.Y + dY)) + ' ' + 'cm');
  Writeln(OutStream, '/Im' + IntToStr(PicIndex) + ' Do');
  Writeln(OutStream, 'Q');

  if OldFrameWidth > 0 then
    Obj.Frame.Width := OldFrameWidth;

  DoFrame(Obj.Frame, GetRect(Obj));
end;

procedure TfrxPDFExport.AddAsPictureOld(const Obj: TfrxView);
var
  OldFrameWidth: Extended;
  FRealBounds: TfrxRect;
  dX, dY, fdx, fdy: Extended;
  TempBitmap: TBitmap;
  i, iz: Integer;
  BWidth, BHeight: String;
  Jpg: TJPEGImage;
begin
  if Obj.Frame.Width > 0 then
  begin
    OldFrameWidth := Obj.Frame.Width;
    Obj.Frame.Width := 0;
  end
  else
    OldFrameWidth := 0;

  FRealBounds := Obj.GetRealBounds;
  dX := FRealBounds.Right - FRealBounds.Left;
  dY := FRealBounds.Bottom - FRealBounds.Top;

  if (dX = Obj.Width) or (Obj.AbsLeft = FRealBounds.Left) then
    fdx := 0
  else if (Obj.AbsLeft + Obj.Width) = FRealBounds.Right then
    fdx := (dX - Obj.Width)
  else
    fdx := (dX - Obj.Width) / 2;

  if (dY = Obj.Height) or (Obj.AbsTop = FRealBounds.Top) then
    fdy := 0
  else if (Obj.AbsTop + Obj.Height) = FRealBounds.Bottom then
    fdy := (dY - Obj.Height)
  else
    fdy := (dY - Obj.Height) / 2;

  TempBitmap := TBitmap.Create;
  TempBitmap.PixelFormat := pf24bit;

  if (PrintOptimized or (Obj is TfrxCustomMemoView)) and
    (Obj.BrushStyle in [bsSolid, bsClear]) then
    i := PDF_PRINTOPT
  else
    i := 1;

  iz := 0;

  if (Obj.ClassName = 'TfrxBarCodeView') and not PrintOptimized then
  begin
    i := 2;
    iz := i;
  end;

  TempBitmap.Width := Round(dX * i) + i;
  TempBitmap.Height := Round(dY * i) + i;

  Obj.DrawClipped(TempBitmap.Canvas, i, i, -Round((Obj.AbsLeft - fdx) * i) +
    iz, -Round((Obj.AbsTop - fdy) * i));

  if dX <> 0 then
    BWidth := frFloat2Str(dX * PDF_DIVIDER)
  else
    BWidth := '1';
  if dY <> 0 then
    BHeight := frFloat2Str(dY * PDF_DIVIDER)
  else
    BHeight := '1';

  Write(OutStream, 'q'#13#10 + BWidth + ' 0 0 ' + BHeight + ' ' +
    frFloat2Str(pdfX(Obj.AbsLeft - fdx)) + ' ' +
    frFloat2Str(pdfY(Obj.AbsTop - fdy + dY)) + ' cm'#13#10'BI'#13#10 + '/W ' +
    IntToStr(TempBitmap.Width) + #13#10 + '/H ' + IntToStr(TempBitmap.Height)
    + #13#10'/CS /RGB'#13#10'/BPC 8'#13#10'/I true'#13#10'/F [/DCT]'#13#10'ID ');
  Jpg := TJPEGImage.Create;

  if (Obj.ClassName = 'TfrxBarCodeView') or (Obj is TfrxCustomLineView) or
    (Obj is TfrxShapeView) then
  begin
    Jpg.PixelFormat := jf8Bit;
    Jpg.CompressionQuality := FQuality + 5; // 95;
  end
  else
  begin
    Jpg.PixelFormat := jf24Bit;
    Jpg.CompressionQuality := FQuality; // 90;
  end;

  Jpg.Assign(TempBitmap);
  Jpg.SaveToStream(OutStream);
  Jpg.Free;

  Write(OutStream, #13#10'EI'#13#10'Q'#13#10);
  TempBitmap.Free;
  if OldFrameWidth > 0 then
    Obj.Frame.Width := OldFrameWidth;
  DoFrame(Obj.Frame, GetRect(Obj));

end;

procedure TfrxPDFExport.AddAttachments;

  function EmFile(i: Integer): TEmbeddedFile;
  begin
    Result := FEmbeddedFiles[i] as TEmbeddedFile;
  end;

var
  i: Integer;
begin
  if FEmbeddedFiles.Count > 0 then
  begin
    for i := 0 to FEmbeddedFiles.Count - 1 do
      AddEmbeddedFileItem(FEmbeddedFiles[i]);
    FAttachmentsNamesId := FPOH.UpdateXRef;
    WriteLn(pdf, ObjNumber(FAttachmentsNamesId));
    Write(pdf, '<< /Names [');
    for i := 0 to FEmbeddedFiles.Count - 1 do
    begin
      Write(pdf, ' (' + EmFile(i).Name + ') ');
      Write(pdf, ObjNumberRef(EmFile(i).Xref));
    end;

    WriteLn(pdf, ' ] >>');
    WriteLn(pdf, 'endobj');

    FAttachmentsListId := FPOH.UpdateXRef;
    WriteLn(pdf, ObjNumber(FAttachmentsListId));
    Write(pdf, '[ ');
    for i := 0 to FEmbeddedFiles.Count - 1 do
      Write(pdf, ObjNumberRef(EmFile(i).Xref) + ' ');
    WriteLn(pdf, ']');
    WriteLn(pdf, 'endobj');
  end;

end;

procedure TfrxPDFExport.AddCheckBox(const Obj: TfrxView);
var
  cb: TfrxCheckBoxView;
  l: Extended;
  t: Extended;
  w: Extended;
  h: Extended;
begin
  cb := TfrxCheckBoxView(Obj);
  l := Obj.AbsLeft;
  t := Obj.AbsTop;
  h := Obj.Height;
  w := Obj.Width;

  Writeln(OutStream, GetPDFDash(fsSolid, Obj.Frame.Width * 2));
  Writeln(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
    frFloat2Str(Obj.Frame.Width * PDF_DIVIDER * 2) + ' w ' +
    GetPDFColor(Obj.Color) + ' rg');

  if cb.Checked then
    case cb.CheckStyle of
      csCross:
        Writeln(OutStream, frFloat2Str(Obj.Frame.Width * PDF_DIVIDER * 6) +
          ' w 2 J ' + frFloat2Str(pdfX(l + w / 4)) + ' ' +
          frFloat2Str(pdfY(t + h / 4)) + ' m ' +
          frFloat2Str(pdfX(l + w - w / 4)) + ' ' +
          frFloat2Str(pdfY(t + h - h / 4)) + ' l ' +
          frFloat2Str(pdfX(l + w - w / 4)) + ' ' + frFloat2Str(pdfY(t + h / 4)
          ) + ' m ' + frFloat2Str(pdfX(l + w / 4)) + ' ' +
          frFloat2Str(pdfY(t + h - h / 4)) + ' l ');
      csCheck:
        Writeln(OutStream, frFloat2Str(Obj.Frame.Width * PDF_DIVIDER * h / 10)
          + ' w 2 J ' + frFloat2Str(pdfX(l + w / 5)) + ' ' +
          frFloat2Str(pdfY(t + Obj.Height / 2)) + ' m ' +
          frFloat2Str(pdfX(l + w / 3)) + ' ' + frFloat2Str(pdfY(t + h - h / 4)
          ) + ' l ' + frFloat2Str(pdfX(l + w - w / 5)) + ' ' +
          frFloat2Str(pdfY(t + h / 7)) + ' l ');
      csLineCross:
        Writeln(OutStream, frFloat2Str(pdfX(l)) + ' ' + frFloat2Str(pdfY(t)) +
          ' m ' + frFloat2Str(pdfX(l + w)) + ' ' + frFloat2Str(pdfY(t + h)) +
          ' l ' + frFloat2Str(pdfX(l + w)) + ' ' + frFloat2Str(pdfY(t)) +
          ' m ' + frFloat2Str(pdfX(l)) + ' ' + frFloat2Str(pdfY(t + h)
          ) + ' l ');
      csPlus:
        Writeln(OutStream, frFloat2Str(pdfX(l + 0)) + ' ' +
          frFloat2Str(pdfY(t + Obj.Height / 2)) + ' m ' +
          frFloat2Str(pdfX(l + w - 0)) + ' ' +
          frFloat2Str(pdfY(t + Obj.Height / 2)) + ' l ' +
          frFloat2Str(pdfX(l + w / 2)) + ' ' + frFloat2Str(pdfY(t)) + ' m ' +
          frFloat2Str(pdfX(l + w / 2)) + ' ' +
          frFloat2Str(pdfY(t + Obj.Height)) + ' l ');
    end
  else
    case cb.UncheckStyle of
      usEmpty:
        ;
      usCross:
        Writeln(OutStream, frFloat2Str(Obj.Frame.Width * PDF_DIVIDER * 6) +
          ' w 2 J ' + frFloat2Str(pdfX(l + w / 4)) + ' ' +
          frFloat2Str(pdfY(t + h / 4)) + ' m ' +
          frFloat2Str(pdfX(l + w - w / 4)) + ' ' +
          frFloat2Str(pdfY(t + h - h / 4)) + ' l ' +
          frFloat2Str(pdfX(l + w - w / 4)) + ' ' + frFloat2Str(pdfY(t + h / 4)
          ) + ' m ' + frFloat2Str(pdfX(l + w / 4)) + ' ' +
          frFloat2Str(pdfY(t + h - h / 4)) + ' l ');
      usLineCross:
        Writeln(OutStream, frFloat2Str(pdfX(l)) + ' ' + frFloat2Str(pdfY(t)) +
          ' m ' + frFloat2Str(pdfX(l + w)) + ' ' + frFloat2Str(pdfY(t + h)) +
          ' l ' + frFloat2Str(pdfX(l + w)) + ' ' + frFloat2Str(pdfY(t)) +
          ' m ' + frFloat2Str(pdfX(l)) + ' ' + frFloat2Str(pdfY(t + h)
          ) + ' l ');
      usMinus:
        Writeln(OutStream, frFloat2Str(pdfX(l + 0)) + ' ' +
          frFloat2Str(pdfY(t + Obj.Height / 2)) + ' m ' +
          frFloat2Str(pdfX(l + w - 0)) + ' ' +
          frFloat2Str(pdfY(t + Obj.Height / 2)) + ' l ');
    end;

  if Obj.Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom] then
    Writeln(OutStream, ' S ' + frFloat2Str(Obj.Frame.Width * PDF_DIVIDER * 2)
      + ' w ' + frFloat2Str(pdfX(l)) + ' ' + frFloat2Str(pdfY(t)) + ' m ' +
      frFloat2Str(pdfX(l + w)) + ' ' + frFloat2Str(pdfY(t)) + ' l ' +
      frFloat2Str(pdfX(l + w)) + ' ' + frFloat2Str(pdfY(t + h)) + ' l ' +
      frFloat2Str(pdfX(l)) + ' ' + frFloat2Str(pdfY(t + h)) + ' l ' +
      frFloat2Str(pdfX(l)) + ' ' + frFloat2Str(pdfY(t)) + ' l ');

  if Obj.Color <> clNone then
    Write(OutStream, 'B'#13#10)
  else
    Write(OutStream, 'S'#13#10);

end;


procedure TfrxPDFExport.AddColorProfile;
var
  FColorProfileStreamId: LongInt;
  Res: TResourceStream;
  MemRes: TMemoryStream;
begin
  // color profile stream
  FColorProfileStreamId := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(FColorProfileStreamId));
  Writeln(pdf, '<<');
  Writeln(pdf, '/N 3');

  // get stream from resource and put it in PDF
  Res := TResourceStream.Create(hInstance, 'Profile', RT_RCDATA);
  try
    MemRes := TMemoryStream.Create;
    MemRes.LoadFromStream(Res);
    MemRes.Position := 0;
    WritePDFStream(pdf, MemRes, FColorProfileStreamId, FCompressed, FProtection,
      False, True, False);
  finally
    Res.Free;
  end;

  // color profile intent
  FColorProfileId := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(FColorProfileId));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Type /OutputIntent');
  Writeln(pdf, '/S /GTS_PDFA1');
  Writeln(pdf, '/OutputCondition (sRGB IEC61966-2.1)');
  Writeln(pdf, '/OutputConditionIdentifier (sRGB IEC61966-2.1)');
  Writeln(pdf, '/Info (sRGB IEC61966-2.1)');
  Writeln(pdf, '/DestOutputProfile ' + ObjNumberRef(FColorProfileStreamId));
  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');
end;

procedure TfrxPDFExport.AddEmbeddedFile(Name, Description: String;
  ModDate: TDateTime; Relation: TEmbeddedRelation; MIME: String;
  FileStream: TStream);
var
  EmbeddedFile: TEmbeddedFile;
begin
  EmbeddedFile := TEmbeddedFile.Create;
  EmbeddedFile.FName := Name;
  EmbeddedFile.FDescription := Description;
  EmbeddedFile.FModDate := ModDate;
  EmbeddedFile.FRelation := Relation;
  EmbeddedFile.FMIME := MIME;
  EmbeddedFile.FFileStream := FileStream;
  FEmbeddedFiles.Add(EmbeddedFile);
end;

procedure TfrxPDFExport.AddEmbeddedFileItem(EmbeddedFile: TObject);
var
  FileRef: Integer;
  FileRel: Integer;
  EmFile: TEmbeddedFile;
  FormattedDateTime: String;
  Desc: AnsiString;
begin
  EmFile := EmbeddedFile as TEmbeddedFile;

  FileRef := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(FileRef));

  DateTimeToString(FormattedDateTime, 'yyyymmddhhnnss', EmFile.ModDate);
  Write(pdf, '<< /Params << /ModDate (D:' + FormattedDateTime + ')');

  Write(pdf, ' /Size ' + IntToStr(EmFile.FileStream.Size));
  WriteLn(pdf, ' >>');
  WriteLn(pdf, '/Subtype /' + StringReplace(EmFile.MIME, '/', '#2f', [rfReplaceAll]));
  WriteLn(pdf, '/Type /EmbeddedFile');
  WritePDFStream(pdf, EmFile.FileStream, FileRef, Compressed, FProtection,
    False, True, False);


  FileRel := FPOH.UpdateXRef;
  EmFile.FXRef := FileRel;
  WriteLn(pdf, ObjNumber(FileRel));

  WriteLn(pdf, '<< /AFRelationship /' + erName[EmFile.Relation]);

  Desc := PrepareString(WideString(EmFile.Description), FEncKey, FProtection, FileRel);
  WriteLn(pdf, '/Desc ' + Desc);

  Write(pdf, '/EF <<');
  Write(pdf, ' /F ' + ObjNumberRef(FileRef));
  Write(pdf, ' /UF ' + ObjNumberRef(FileRef));
  WriteLn(pdf, ' >>');
  WriteLn(pdf, '/F (' + EmFile.Name + ')');
  WriteLn(pdf, '/Type /Filespec');
  WriteLn(pdf, '/UF <' + StrToUTF16H(WideString(EmFile.Name)) + '>');
  WriteLn(pdf, '>>');
  WriteLn(pdf, 'endobj');
end;

procedure TfrxPDFExport.AddEmbeddedXML(Name, Description: String;
  ModDate: TDateTime; FileStream: TStream; ZUGFeRDLevel:
  TZUGFeRD_ConformanceLevel = clBASIC);
begin
  FZUGFeRDDescription := Format(
    '<rdf:Description xmlns:zf="urn:ferd:pdfa:CrossIndustryDocument:invoice:1p0#" rdf:about="" zf:ConformanceLevel="%s" zf:DocumentFileName="%s" zf:DocumentType="INVOICE" zf:Version="1.0\"/>',
    [clName[ZUGFeRDLevel], Name]
  );

  AddEmbeddedFile(Name, Description, ModDate, erAlternative, 'text/xml', FileStream);
end;

procedure TfrxPDFExport.AddLine(const Line: TfrxCustomLineView);

  procedure DrawArrow(x1, y1, x2, y2: Extended);
  var
    k1, a, b, c, D: Double;
    xp, yp, x3, y3, x4, y4, ld, wd: Extended;
  begin
    wd := Line.ArrowWidth * PDF_DIVIDER;
    ld := Line.ArrowLength * PDF_DIVIDER;
    if Abs(x2 - x1) > 0 then
    begin
      k1 := (y2 - y1) / (x2 - x1);
      a := sqr(k1) + 1;
      b := 2 * (k1 * ((x2 * y1 - x1 * y2) / (x2 - x1) - y2) - x2);
      c := sqr(x2) + sqr(y2) - sqr(ld) + sqr((x2 * y1 - x1 * y2) / (x2 - x1)) -
        2 * y2 * (x2 * y1 - x1 * y2) / (x2 - x1);
      D := sqr(b) - 4 * a * c;
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
    Writeln(OutStream, GetPDFDash(Line.Frame.Style, Line.Frame.Width));
    Writeln(OutStream, frFloat2Str(x3) + ' ' + frFloat2Str(y3) + ' m'#13#10 +
      frFloat2Str(x2) + ' ' + frFloat2Str(y2) + ' l'#13#10 + frFloat2Str(x4) +
      ' ' + frFloat2Str(y4) + ' l');
    if Line.ArrowSolid then
      Writeln(OutStream, '1 j'#13#10 + GetPDFColor(Line.Frame.Color) +
        ' rg'#13#10'b')
    else
      Writeln(OutStream, 'S');
  end;

var
  stTopPlus, stTopMinus, stLeftPlus, stLeftMinus: String;
begin
  with GetRect(Line) do
  begin
    stTopPlus := frFloat2Str(Top + 1);
    stTopMinus := frFloat2Str(Top - 1);
    stLeftPlus := frFloat2Str(Left + 1);
    stLeftMinus := frFloat2Str(Left - 1);
  end;

  if Line.Diagonal then
    Writeln(OutStream, GetPDFDash(fsSolid, Line.Frame.Width))
  else
    Writeln(OutStream, GetPDFDash(Line.Frame.Style, Line.Frame.Width));

  if Line.Frame.Style <> fsDouble then
    Write(OutStream, GetPDFColor(Line.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Line.Frame.Width * PDF_DIVIDER) + ' w'#13#10 + stLeft + ' ' +
      stTop + ' m'#13#10 + stRight + ' ' + stBottom + ' l'#13#10'S'#13#10)
  else
  begin
    if Line.Height = 0 then
    begin
      Write(OutStream, GetPDFColor(Line.Frame.Color) + ' RG'#13#10 +
        frFloat2Str(Line.Frame.Width * PDF_DIVIDER) + ' w'#13#10 + stLeft + ' '
        + stTopPlus + ' m'#13#10 + stRight + ' ' + stTopPlus +
        ' l'#13#10'S'#13#10);
      Write(OutStream, GetPDFColor(Line.Frame.Color) + ' RG'#13#10 +
        frFloat2Str(Line.Frame.Width * PDF_DIVIDER) + ' w'#13#10 + stLeft + ' '
        + stTopMinus + ' m'#13#10 + stRight + ' ' + stTopMinus +
        ' l'#13#10'S'#13#10);
    end
    else if Line.Width = 0 then
    begin
      Write(OutStream, GetPDFColor(Line.Frame.Color) + ' RG'#13#10 +
        frFloat2Str(Line.Frame.Width * PDF_DIVIDER) + ' w'#13#10 + stLeftPlus +
        ' ' + stTop + ' m'#13#10 + stLeftPlus + ' ' + stBottom +
        ' l'#13#10'S'#13#10);
      Write(OutStream, GetPDFColor(Line.Frame.Color) + ' RG'#13#10 +
        frFloat2Str(Line.Frame.Width * PDF_DIVIDER) + ' w'#13#10 + stLeftMinus
        + ' ' + stTop + ' m'#13#10 + stLeftMinus + ' ' + stBottom +
        ' l'#13#10'S'#13#10);
    end;
  end;
  if Line.ArrowStart then
    DrawArrow(pdfX(Line.AbsLeft + Line.Width),
      pdfY(Line.AbsTop + Line.Height), pdfX(Line.AbsLeft), pdfY(Line.AbsTop));
  if Line.ArrowEnd then
    DrawArrow(pdfX(Line.AbsLeft), pdfY(Line.AbsTop),
      pdfX(Line.AbsLeft + Line.Width), pdfY(Line.AbsTop + Line.Height));
end;

procedure TfrxPDFExport.AddMemo(const Memo: TfrxCustomMemoView);
var
  FLineWidth, FLineHeight, aLineSpace: Extended;

  function GetLinesHeight(LinesCount: Integer): Extended;
  begin
    Result := FLineHeight * LinesCount;// - aLineSpace;
  end;

  function GetHTextPos(const Left: Extended; const Width: Extended;
    const Text: WideString; const Align: TfrxHAlign): Extended;
  begin
    case Align of
      haLeft:
        Result := Left;
      haRight:
        Result := Left + Width - FLineWidth;
      haCenter:
        Result := Left + (Width - FLineWidth) / 2;
      haBlock:
        Result := Left;
    else
      Result := Left;
    end;
  end;

  function GetHTextPosR(const Width: Extended; const Text: WideString;
    const Align: TfrxHAlign): Extended;
  begin
    case Align of
      haRight:
        Result := Width - FLineWidth;
      haCenter:
        Result := -FLineWidth / 2;
    else
      Result := -Width;
    end;
  end;

  function GetVTextPos(const Top: Extended; const Height: Extended;
    const Align: TfrxVAlign; const Line: Integer = 0; const Count: Integer = 1)
    : Extended;
  var
    i: Integer;
  begin
    if Line <= Count then
      i := Line
    else
      i := 0;
    if Align = vaBottom then
      Result := Top + (Height - aLineSpace) - GetLinesHeight(Count - i - 1)
    else if Align = vaCenter then
      Result := Top + (Height - GetLinesHeight(Count)) / 2 +
        GetLinesHeight(i + 1) - aLineSpace
    else
      Result := Top + GetLinesHeight(i + 1) - aLineSpace;
  end;

var
  pdfFont: TfrxPDFFont;
  RS: TRemapedString;
  Lines: TWideStrings;
  HWidth: Extended;
  SpaceAdjustment: Extended;

  function NeedSpaceAdjustment(i: Integer): Boolean;
    function IsEndOfParagraph: Boolean;
    begin
      if Memo.Lines.Count = Lines.Count then
        Result := True // i = Lines.Count - 1
      else
        Result := Integer(Lines.Objects[i]) and 2 <> 0;
    end;

  begin
    Result := (Memo.HAlign = haBlock) and not IsEndOfParagraph and
      (RS.SpacesCount > 0);
    if not Result then
      Exit;
    FLineWidth := HWidth;
    SpaceAdjustment := pdfFont.SpaceAdjustment(RS, HWidth * PDF_DIVIDER,
      Memo.Font.Size);
  end;

var
  ow, oh: Extended;
  bx, by, bx1, by1, wx1, wx2, wy1, wy2, gx1, gy1: Integer;
  FTextRect: TRect;
  i, iz: Integer;
  x, y, PGap, FCharSpacing: Extended;
  FUnderlinePosition: Double;
  FStrikeoutPosition: Double;
  simulateBold: Boolean;
  aDrawText: TfrxDrawText;
  Simulation: String;
begin
  DoFill(Memo);

  if (Memo.ReducedAngle <> 0) or (Min(Memo.GapX, Memo.GapY) < 0) then
    ExportViaVector(Memo)
  else
  begin
    Cmd('q'); // save clip to stack
    Cmd_ClipRect(Memo);

    ow := Memo.Width;
    oh := Memo.Height;
    if Memo.Frame.DropShadow then
    begin
      ow := Memo.Width - Memo.Frame.ShadowWidth;
      oh := Memo.Height - Memo.Frame.ShadowWidth;
    end;

    aDrawText := TfrxDrawText(Report.GetReportDrawText);
    if not Assigned(aDrawText) then
      aDrawText := frxDrawText;
    aDrawText.Lock;
    pdfCS.Enter;
    try
      if Memo.Highlight.Active and Assigned(Memo.Highlight.Font) then
      begin
        Memo.Font.Assign(Memo.Highlight.Font);
        Memo.Color := Memo.Highlight.Color;
      end;
      aDrawText.SetFont(Memo.Font);

      aDrawText.SetOptions(Memo.WordWrap, Memo.AllowHTMLTags,
        Memo.RTLReading, Memo.WordBreak, Memo.Clipped, Memo.Wysiwyg,
        Memo.ReducedAngle);

      aDrawText.SetGaps(Memo.ParagraphGap, Memo.CharSpacing,
        Memo.LineSpacing);

      wx1 := Round((Memo.Frame.Width - 1) / 2);
      wx2 := Round(Memo.Frame.Width / 2);
      wy1 := Round((Memo.Frame.Width - 1) / 2);
      wy2 := Round(Memo.Frame.Width / 2);

      bx := Round(Memo.AbsLeft);
      by := Round(Memo.AbsTop);
      bx1 := bx + Ceil(Memo.Width);
      // Round(Memo.AbsLeft + Memo.Width);
      by1 := by + Ceil(Memo.Height);
      // Round(Memo.AbsTop + Memo.Height);
      if ftLeft in Memo.Frame.Typ then
        Inc(bx, wx1);
      if ftRight in Memo.Frame.Typ then
        Dec(bx1, wx2);
      if ftTop in Memo.Frame.Typ then
        Inc(by, wy1);
      if ftBottom in Memo.Frame.Typ then
        Dec(by1, wy2);
      gx1 := Round(Memo.GapX);
      gy1 := Round(Memo.GapY);

      FTextRect := Rect(bx + gx1, by + gy1, bx1 - gx1 + 1, by1 - gy1 + 1);
      aDrawText.SetDimensions(1, 1, 1, FTextRect, FTextRect);
      aDrawText.SetText(Memo.Memo);
      aLineSpace := Memo.LineSpacing;
      FLineHeight := aDrawText.LineHeight;

      if Memo.Underlines then
      begin
        iz := Trunc(Memo.Height / FLineHeight);
        for i := 0 to iz - 1 do
        begin
          y := pdfY(Memo.AbsTop + Memo.GapY + 1 + GetLinesHeight(i + 1) - aLineSpace);
          Write(OutStream, GetPDFColor(Memo.Frame.Color) + ' RG'#13#10 +
            frFloat2Str(Memo.Frame.Width * PDF_DIVIDER) + ' w'#13#10 + stLeft
            + ' ' + frFloat2Str(y) + ' m'#13#10 + stRight + ' ' + frFloat2Str(y)
            + ' l'#13#10'S'#13#10);
        end;
      end;

      Lines := {$IFDEF Delphi10} TfrxWideStrings.Create;
               {$ELSE}           TWideStrings.Create;
               {$ENDIF}
      Lines.Text := aDrawText.WrappedText;
      if Lines.Count > 0 then
      begin
        if Memo.Lines.Count <> Lines.Count then
          for i := 0 to Lines.Count - 1 do
            Lines.Objects[i] := aDrawText.Text.Objects[i];

        pdfFont := Cmd_Font(Memo);

        FCharSpacing := Memo.CharSpacing * PDF_DIVIDER;
        if FCharSpacing <> 0 then
          Write(OutStream, frFloat2Str(FCharSpacing) + ' Tc'#13#10);

        // output lines of memo
        FUnderlinePosition := Memo.Font.Size * 0.12;
        FStrikeoutPosition := Memo.Font.Size * 0.28;
        aDrawText.SetGaps(0, TfrxCustomMemoView(Memo).CharSpacing,
          TfrxCustomMemoView(Memo).LineSpacing);

        for i := 0 to Lines.Count - 1 do
        begin
          if Memo.Lines.Count <> Lines.Count then
          begin
            if Integer(Lines.Objects[i]) and 1 <> 0 then
              PGap := Memo.ParagraphGap
            else
              PGap := 0;
          end
          else if i = 0 then
            PGap := Memo.ParagraphGap
          else
            PGap := 0;

          if Length(Lines[i]) > 0 then
          begin
            // Text output
            case Memo.HAlign of
              haLeft, haBlock:
                FCharSpacing := 0;
              haCenter:
                FCharSpacing := FCharSpacing / 2;
            end;

            RS := pdfFont.SoftRemapString(Lines[i], Memo.RTLReading, IsPDFA);
            FLineWidth := RS.Width / PDF_DIVIDER / 1000 * Memo.Font.Size;

            HWidth := ow - Memo.GapX * 2 - PGap;
            x := -FCharSpacing * (Length(Lines[i]) - 1) +
              pdfX(GetHTextPos(Memo.AbsLeft + Memo.GapX + PGap, HWidth,
              Lines[i], Memo.HAlign));
            y := pdfY(GetVTextPos(Memo.AbsTop + Memo.GapY -
              Memo.Font.Size * 0.1, oh - Memo.GapY * 2, Memo.VAlign,
              i, Lines.Count));

            Write(OutStream, 'BT'#13#10);

            // #332005
            Write(OutStream, pdfFont.FontName +
              AnsiString(' ' + frFloat2Str(pdfFont.Size) + ' Tf'#13#10));
            Write(OutStream, '[] 0 d'#13#10);
            Write(OutStream, GetPDFColor(pdfFont.Color) + ' rg'#13#10);

            if FCharSpacing <> 0 then
              Write(OutStream, frFloat2Str(FCharSpacing) + ' Tc'#13#10);
              Write(OutStream, frFloat2Str(x) + ' ' + frFloat2Str(y) +
                ' Td'#13#10);

            if IsNeedsItalicSimulation(Memo.Font, Simulation) then
              Write(OutStream, Simulation + ' ' + Float2Str(x) + ' ' +
                Float2Str(y) + ' Tm'#13#10);
            simulateBold := IsNeedsBoldSimulation(Memo.Font, Simulation);
            if simulateBold then
              Write(OutStream, Simulation + #13#10);
            if NeedSpaceAdjustment(i) then
              Write(OutStream, '[<' + StrToHexSp(Lines[i], RS.Data,
                SpaceAdjustment) + '>] TJ'#13#10'ET'#13#10)
            else
              Write(OutStream, '<' + StrToHex(RS.Data) +
                '> Tj'#13#10'ET'#13#10);
            if simulateBold then
              Write(OutStream, '0 Tr'#13#10);

            { underlined text }

            with Memo do
              if fsUnderline in Font.Style then
              begin
                Cmd('[] 0 d');
                Cmd(GetPDFColor(Font.Color) + ' RG');
                Cmd(frFloat2Str(Font.Size * 0.08) + ' w');
                Cmd(frFloat2Str(x) + ' ' +
                  frFloat2Str(y - FUnderlinePosition) + ' m');
                Cmd(frFloat2Str(x + FLineWidth * PDF_DIVIDER) + ' ' +
                  frFloat2Str(y - FUnderlinePosition) + ' l');

                Cmd('S');
              end;

            { struck out text }

            if fsStrikeout in (Memo.Font.Style) then
              Write(OutStream, GetPDFColor(Memo.Font.Color) + ' RG'#13#10 +
                frFloat2Str(Memo.Font.Size * 0.08) + ' w'#13#10 +
                frFloat2Str(x) + ' ' + frFloat2Str(y + FStrikeoutPosition) +
                ' m'#13#10 + frFloat2Str(x + FLineWidth * PDF_DIVIDER) + ' ' +
                frFloat2Str(y + FStrikeoutPosition) + ' l'#13#10'S'#13#10);
          end;
        end;
      end;
    finally
      aDrawText.Unlock;
      pdfCS.Leave;
    end;
    Cmd('Q'); // restore clip
    Lines.Free;
  end;

  DoFrame(Memo.Frame, GetRect(Memo));
end;

procedure TfrxPDFExport.AddMetaData;
var
  Res: TResourceStream;
  MemRes: TMemoryStream;
  meta_xml: AnsiString;
  current_time: String;

  procedure Replace(st: String; A: AnsiString); overload;
  begin
    meta_xml := StringReplace(meta_xml, AnsiString('{' + st + '}'),
      A, [rfReplaceAll]);
  end;

  procedure Replace(i: Integer; A: AnsiString); overload;
  begin
    Replace(IntToStr(i), A);
  end;

  procedure Compress;
  var
    Len, l, r: Integer;
  begin // delete #$D#$S + trailing spaces
    Len := Length(meta_xml);
    l := 1; r := 1;
    while r <= Len do
      if (r < Len) and (meta_xml[r] = #$D) and (meta_xml[r + 1] = #$A) then
      begin
        r := r + 2;
        while (r <= Len) and (meta_xml[r] = ' ') do
          r := r + 1;
      end
      else
      begin
        meta_xml[l] := meta_xml[r];
        l := l + 1;
        r := r + 1;
      end;
    SetLength(meta_xml, l - 1);
  end;
begin

  Res := TResourceStream.Create(hInstance, 'Metafile', RT_RCDATA);
  try
    SetLength(meta_xml, Integer(Res.Size));
    Res.Read(meta_xml[1], Res.Size);

    Compress;

    // do prepare meta
    if IsPDFA_1 then
    begin
      Replace('Creator', AnsiString(UTF8Encode(FAuthor)));
      Replace('CreatorTool', AnsiString(UTF8Encode(FCreator)));
    end
    else
    begin
      Replace('Creator', AnsiString(UTF8Encode(FCreator)));
      Replace('CreatorTool', AnsiString(UTF8Encode(FCreator)));
    end;

    Replace( 1, AnsiString(UTF8Encode(FSubject)));
    Replace( 2, AnsiString(UTF8Encode(FTitle)));
    {$IfDef EXPORT_TEST}
    current_time := '2019-01-09T16:57:21+00:00';
    {$Else}
    current_time := FormatDateTime('yyyy-MM-dd', FCreationDateTime) + 'T' +
      FormatDateTime('HH:mm:ss+00:00', FCreationDateTime);
    {$EndIf}
    Replace( 3, AnsiString(current_time));

    Replace( 4, AnsiString(UTF8Encode(FKeywords)));
    Replace( 5, AnsiString(UTF8Encode(FProducer)));
    Replace('PDFVersion', AnsiString(PDFVersionName[PDFVersion]));
    Replace( 6, FFileID);
    Replace( 7, FFileID);
    Replace( 8, AnsiString(PDFPartName[PDFStandard]));
    Replace( 9, AnsiString(PDFConformanceName[PDFStandard]));

    Replace(10, AnsiString(FZUGFeRDDescription));

    FMetaFileId := FPOH.UpdateXRef();
    Writeln(pdf, ObjNumber(FMetaFileId));
    Writeln(pdf, '<< /Type /Metadata /Subtype /XML ');
    MemRes := TMemoryStream.Create;
    Writeln(MemRes, meta_xml);
    MemRes.Position := 0;
    WritePDFStream(pdf, MemRes, FMetaFileId, False, FProtection,
      False, True, False);
  finally
    Res.Free;
  end;
end;

procedure TfrxPDFExport.AddObject(const Obj: TfrxView);

{ An extenral link is a URL like http://company.com/index.html }
  procedure WriteExternalLink(const URI: string);
  var
    ObjId: Integer;
    annot: TfrxPDFAnnot;
  begin
    ObjId := FPOH.UpdateXRef;
    Writeln(FPageAnnots, ObjNumberRef(ObjId));
    // for /Annots array in the page object

    annot := TfrxPDFAnnot.Create;
    annot.Number := ObjId;
    annot.Rect := stLeft + ' ' + stBottom + ' ' + stRight + ' ' + stTop;
    annot.Hyperlink := StringReplace(String(PdfString(WideString(Trim(URI)))), '\', '\\', [rfReplaceAll]);
    FAnnots.Add(annot);
  end;

{ Writes an anchor to the PDF document. This kind
  of links make a jump to a specified location within
  the current document.

  Arguments:

  - Page  - an index of a page whither the anchor jumps
  - Pos   - a vertical position of the destination within the page }
  procedure WritePageAnchor(Page: Integer; Pos: Double);
  var
    ObjId: Integer;
    annot: TfrxPDFAnnot;
  begin
    ObjId := FPOH.UpdateXRef;
    Writeln(FPageAnnots, ObjNumberRef(ObjId));
    // for /Annots array in the page object

    annot := TfrxPDFAnnot.Create;
    annot.Number := ObjId;
    annot.Rect := stLeft + ' ' + stBottom + ' ' + stRight + ' ' + stTop;
    annot.DestPage := Page;
    annot.DestY := Round(pdfY(Pos));
    FAnnots.Add(annot);
  end;

{ Writes a link object to the PDF document }
  procedure WriteHyperLink(Hyperlink: TfrxHyperlink);
  var
    x: TfrxXMLItem;
  begin
    case Hyperlink.kind of
      hkAnchor:
        begin
          x := (Report.PreviewPages as TfrxPreviewPages)
            .FindAnchor(Hyperlink.Value);
          if x <> nil then
            WritePageAnchor(StrToInt(x.Prop['page']),
              StrToFloat(x.Prop['top']));
        end;

      hkPageNumber:
        WritePageAnchor(StrToInt(Hyperlink.Value) - 1, 0.0);

      hkURL: // В документнации пока не описано-ноя думая-это для этих случаев...
        if Length(Hyperlink.Value) > 0 then
          WriteExternalLink(Hyperlink.Value)
    end; { case }
  end;

  procedure WriteLink(a: string);
  var
    x: TfrxXMLItem;
  begin
    if a = '' then
      Exit;

    { Anchors.
      This kind of links make a jump to a specified
      location within the current document. Anchors
      begin with '#' sign. }
    if a[1] = '#' then
    begin
      a := Copy(a, 2, Length(a) - 1);
      x := (Report.PreviewPages as TfrxPreviewPages).FindAnchor(a);

      if x <> nil then
        WritePageAnchor(StrToInt(x.Prop['page']), StrToFloat(x.Prop['top']));
    end

    { Page anchors.
      This kind of links make a jump to a
      specified page. }
    else if a[1] = '@' then
    begin
      a := Copy(a, 2, Length(a) - 1);
      WritePageAnchor(StrToInt(a) - 1, 0.0);
    end

    { Extenal links.
      An extenral link is a URL like http://company.com/index.html. }
    else
      WriteExternalLink(a)
  end;

  function IsMemoWithoutHTMLTags(const Obj: TfrxView): Boolean;
  begin
    Result := (Obj is TfrxCustomMemoView) and
          not (IsHasHTMLTags(TfrxCustomMemoView(Obj)));
  end;
begin
  with GetRect(Obj) do
  begin
    stLeft := frFloat2Str(Left);
    stTop := frFloat2Str(Top);
    stRight := frFloat2Str(Right);
    stBottom := frFloat2Str(Bottom);
  end;

  if Obj.Hyperlink.Value <> '' then
    WriteHyperLink(Obj.Hyperlink)
  else if Obj.URL <> '' then
    WriteLink(Obj.URL);
  if IsMemoWithoutHTMLTags(Obj) then
    AddMemo(TfrxCustomMemoView(Obj))
  else if Obj is TfrxCustomLineView then
    AddLine(TfrxCustomLineView(Obj))
  else if Obj is TfrxShapeView then
    AddShape(TfrxShapeView(Obj))
{$IFNDEF RAD_ED}
  else if IsAddViaEMF(Obj) then
    AddViaEMF(Obj)
{$ENDIF}
  else if (Obj is TfrxCheckBoxView) then
    AddCheckbox(Obj)
  else if ((Obj.Name = '_pagebackground') and ((not Background) or (not TfrxPDFPage(FPages[FPages.Count - 1]).BackPictureVisible))) or
    (Obj.Height = 0) or (Obj.Width = 0) then
  begin
    { do nothing }
  end
  else
{$IFNDEF OLD_STYLE}
    AddAsPicture(Obj);
{$ELSE}
    AddAsPictureOld(Obj);
{$ENDIF}
end;

function TfrxPDFExport.AddPage(Page: TfrxReportPage): TfrxPDFPage;
var
  p: TfrxPDFPage;
begin
  p := TfrxPDFPage.Create;
  p.Height := Page.Height * PDF_DIVIDER;
  p.BackPictureVisible := Page.BackPictureVisible;
  FPages.Add(p);
  Result := p;
end;

procedure TfrxPDFExport.AddShape(const Shape: TfrxShapeView);
begin
  if Is2DShape(Shape) then
  begin
    DoFill(Shape);

    if Shape.Frame.Color <> clNone then
    begin
      with Shape.Frame do
      begin
        Cmd(GetPDFDash(Style, Width));
        CmdStrokeColor(Color);
        CmdLineWidth(Width);
      end;

      Cmd_ObjPath(Shape);
      CmdStroke;
    end;
  end
  else if Shape.Shape = skDiagonal1 then
  begin
    Writeln(OutStream, GetPDFDash(Shape.Frame.Style, Shape.Frame.Width));
    Write(OutStream, GetPDFColor(Shape.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Shape.Frame.Width * PDF_DIVIDER) + ' w'#13#10 + stLeft + ' ' +
      stBottom + ' m'#13#10 + stRight + ' ' + stTop + ' l'#13#10'S'#13#10)
  end
  else if Shape.Shape = skDiagonal2 then
  begin
    Writeln(OutStream, GetPDFDash(Shape.Frame.Style, Shape.Frame.Width));
    Write(OutStream, GetPDFColor(Shape.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Shape.Frame.Width * PDF_DIVIDER) + ' w'#13#10 + stLeft + ' ' +
      stTop + ' m'#13#10 + stRight + ' ' + stBottom + ' l'#13#10'S'#13#10)
  end;

end;

procedure TfrxPDFExport.AddStructure;
var
  roleMaps: LongInt;
begin
  roleMaps := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(roleMaps));
  Writeln(pdf,
    '<<'#13#10'/Footnote /Note'#13#10'/Endnote /Note'#13#10'/Textbox /Sect'#13#10'/Header /Sect');
  Writeln(pdf,
    '/Footer /Sect'#13#10'/InlineShape /Sect'#13#10'/Annotation /Sect'#13#10'/Artifact /Sect');
  Writeln(pdf,
    '/Workbook /Document'#13#10'/Worksheet /Part'#13#10'/Macrosheet /Part'#13#10'/Chartsheet /Part');
  Writeln(pdf,
    '/Dialogsheet /Part'#13#10'/Slide /Part'#13#10'/Chart /Sect'#13#10'/Diagram /Figure'#13#10'>>'#13#10'endobj');
  FStructId := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(FStructId));
  Writeln(pdf, '<<'#13#10'/Type /StructTreeRoot');
  Writeln(pdf, '/RoleMap ' + ObjNumberRef(roleMaps));
  // /ParentTree /K /ParentTreeNextKey
  Writeln(pdf, '>>'#13#10'endobj');
end;

{$IFNDEF RAD_ED}
procedure TfrxPDFExport.AddViaEMF(const Obj: TfrxView);
var
  MS: TMemoryStream;
  MF: TMetafile;
  EMFtoPDF: TEMFtoPDFExport;
begin
  if not Obj.IsEMFExportable then
    Exit;

  DoFill(Obj);

  MS := TMemoryStream.Create;
  try
    MF := TMetaFile(Obj.GetVectorGraphic);
//    MF.SaveToFile(IntToStr(Random(1000000)) + '.emf'); { TODO : Debug File.emf}
    MF.SaveToStream(MS);
    MS.Position := 0;
    EMFtoPDF := TEMFtoPDFExport.Create(MS, OutStream,
      GetRectEMFExport(Obj), FPOH, IsPDFA);
    EMFtoPDF.ForceMitterLineJoin :=
      (AnsiUpperCase(Obj.ClassName) = 'TFRXBARCODEVIEW') or
      (AnsiUpperCase(Obj.ClassName) = 'TFRXBARCODE2DVIEW');
    EMFtoPDF.ForceButtLineCap := EMFtoPDF.ForceMitterLineJoin;
    EMFtoPDF.ForceNullBrush := Obj is TfrxShapeView;
    EMFtoPDF.Transparency := Transparency;
    EMFtoPDF.ForceAnsi := IsPDFA and
      (AnsiUpperCase(Obj.ClassName) = 'TFRXCHECKBOXVIEW');
//    EMFtoPDF.ShowComments := True; { TODO : Debug ShowComments := True}
    try
      EMFtoPDF.PlayMetaFile;
    finally
      MF.Free;
      EMFtoPDF.Free;
    end;
  finally
    MS.Free;
  end;

  DoFrame(Obj.Frame, GetRect(Obj));
end;
{$ENDIF}

procedure TfrxPDFExport.BeginClip(Obj: TfrxView);
begin
  Cmd('q'); // save clip to stack
  Cmd(frxRect2Str(GetClipRect(Obj, True)) + ' re');
  Cmd('W');
  Cmd('n');
end;

procedure TfrxPDFExport.Clear;
var
  i: Integer;
begin
  for i := 0 to FPages.Count - 1 do
    TObject(FPages[i]).Free;

  for i := 0 to FAnnots.Count - 1 do
    TObject(FAnnots[i]).Free;

  FPages.Clear;

  FPOH.Clear;

  FPageAnnots.Clear;
  FAnnots.Clear;
  FPagesRef.Clear;
end;

procedure TfrxPDFExport.Cmd(const Args: string);
begin
  Writeln(OutStream, Args);
end;

procedure TfrxPDFExport.CmdCurveTo(x1, y1, x2, y2, x3, y3: Extended);
begin
  Cmd(STpdfPoint(x1, y1) + ' ' + STpdfPoint(x2, y2) + ' ' + STpdfPoint(x3,
    y3) + ' c');
end;

procedure TfrxPDFExport.CmdFillColor(Color: TColor);
begin
  Cmd(Color2Str(Color) + ' rg');
end;

procedure TfrxPDFExport.CmdLineTo(x, y: Extended);
begin
  Cmd(STpdfPoint(x, y) + ' l');
end;

procedure TfrxPDFExport.CmdLineWidth(Value: Extended);
begin
  Cmd(STpdfSize(Value) + ' w');
end;

procedure TfrxPDFExport.CmdMoveTo(x, y: Extended);
begin
  Cmd(STpdfPoint(x, y) + ' m');
end;

procedure TfrxPDFExport.CmdStroke;
begin
  Cmd('S');
end;

procedure TfrxPDFExport.CmdStrokeColor(Color: TColor);
begin
  Cmd(Color2Str(Color) + ' RG');
end;

procedure TfrxPDFExport.Cmd_ClipObj(Obj: TfrxView);
begin
  Cmd_ObjPath(Obj);
  Cmd('W');
  Cmd('n');
end;

procedure TfrxPDFExport.Cmd_ClipRect(Obj: TfrxView);
begin
  if Obj is TfrxDMPMemoView then
    Cmd(frxRect2Str(GetDMPRect(GetClipRect(Obj))) + ' re')
  else
    Cmd(frxRect2Str(GetClipRect(Obj)) + ' re');
  Cmd('W');
  Cmd('n');
end;

procedure TfrxPDFExport.Cmd_DiamondPath(Diamond: TfrxShapeView);
begin
  with ShadowlessSizes(Diamond) do
  begin
    CmdMoveTo(l + w / 2, t);
    CmdLineTo(R, t + h / 2);
    CmdLineTo(l + w / 2, b);
    CmdLineTo(l, t + h / 2);
    CmdLineTo(l + w / 2, t);
  end;
end;

procedure TfrxPDFExport.Cmd_EllipsePath(Ellipse: TfrxShapeView);
const
  Kappa1 = 1.5522847498;
  Kappa2 = 2 - Kappa1;
begin
  with ShadowlessSizes(Ellipse) do
  begin
    CmdMoveTo(R, t + h / 2);
    CmdCurveTo(R, t + h / 2 * Kappa1, l + w / 2 * Kappa1, b, l + w / 2, b);
    CmdCurveTo(l + w / 2 * Kappa2, b, l, t + h / 2 * Kappa1, l, t + h / 2);
    CmdCurveTo(l, t + h / 2 * Kappa2, l + w / 2 * Kappa2, t, l + w / 2, t);
    CmdCurveTo(l + w / 2 * Kappa1, t, R, t + h / 2 * Kappa2, R, t + h / 2);
  end;
end;

procedure TfrxPDFExport.Cmd_FillBrush(Obj: TfrxView; BrushFill: TfrxBrushFill);
begin
  if (BrushFill.BackColor = clNone) and (BrushFill.Style in [bsSolid, bsClear])
  then
    Exit;

  with BrushFill do
  begin
    if BackColor <> clNone then
      Cmd_FillObj(Obj, BackColor);
    if not(Style in [bsSolid, bsClear]) then
      Cmd_Hatch(Obj, ForeColor, Style);
  end;

end;

procedure TfrxPDFExport.Cmd_FillGlass(Obj: TfrxView; GlassFill: TfrxGlassFill);
var
  ObjRect: TfrxRect;
begin
  if GlassFill.Color = clNone then
    Exit;

  with GlassFill do
  begin
    Cmd_FillObj(Obj, Color);

    ObjRect := GetRect(Obj);
    with ObjRect do
      case Orientation of
        foHorizontal:
          Bottom := (Top + Bottom) / 2;
        foHorizontalMirror:
          Top := (Top + Bottom) / 2;
        foVertical:
          Right := (Left + Right) / 2;
        foVerticalMirror:
          Left := (Left + Right) / 2;
      end;
    Cmd_ClipObj(Obj);
    CmdFillColor(HatchColor);
    Cmd(frxRect2Str(ObjRect) + ' re');
    Cmd('f');
    if Hatch then
      Cmd_Hatch(Obj, HatchColor, bsFDiagonal);
  end;

end;

procedure TfrxPDFExport.Cmd_FillGradient(Obj: TfrxView;
  GradientFill: TfrxGradientFill);

  function ShortStyle(Style: TfrxGradientStyle; w, h: Extended)
    : TfrxGradientStyle;
  begin
    if Style in [gsHorizontal, gsVertical, gsVertCenter, gsHorizCenter] then
      Result := Style
    else // Style in [gsElliptic, gsRectangle]
      if w > h then
        Result := gsVertCenter
      else
        Result := gsHorizCenter;
  end;

var
  StepR, StepG, StepB: Extended;
  StartR, StartG, StartB: Integer;

  procedure DrawLines(x1, y1, x2, y2, dX, dY, Size: Extended; Count: Integer);
  const
    LineWidthFactor = 1.8;
  var
    i: Integer;
    LineWidth: Extended;
  begin
    LineWidth := Size / Count;
    CmdLineWidth(LineWidth * LineWidthFactor);
    for i := 0 to Count do
    begin
      CmdMoveTo(x1 + dX * i * LineWidth, y1 + dY * i * LineWidth);
      CmdLineTo(x2 + dX * i * LineWidth, y2 + dY * i * LineWidth);
      CmdStrokeColor(rgb(Round(StartR + i * StepR), Round(StartG + i * StepG),
        Round(StartB + i * StepB)));
      CmdStroke;
    end;
  end;

var
  sColor, eColor: TColor;
  DeltaR, DeltaG, DeltaB, qLines: Integer;
begin
  if (GradientFill.StartColor = clNone) and (GradientFill.EndColor = clNone)
  then
    Exit;

  with GradientFill do
  begin
    sColor := IfColor(StartColor = clNone, clWhite, StartColor);
    eColor := IfColor(EndColor = clNone, clWhite, EndColor);
    StartR := GetRValue(sColor);
    StartG := GetGValue(sColor);
    StartB := GetBValue(sColor);
    DeltaR := Integer(GetRValue(eColor)) - StartR;
    DeltaG := Integer(GetGValue(eColor)) - StartG;
    DeltaB := Integer(GetBValue(eColor)) - StartB;
    qLines := MaxIntValue([Abs(DeltaR), Abs(DeltaG), Abs(DeltaB), 1]);
    StepR := DeltaR / qLines;
    StepG := DeltaG / qLines;
    StepB := DeltaB / qLines;

    Cmd_ClipObj(Obj);
    Cmd('[] 0 d');
    Cmd('0 J');

    with ShadowlessSizes(Obj) do
      case ShortStyle(GradientStyle, w, h) of
        gsHorizontal:
          DrawLines(l, t, l, b, 1, 0, w, qLines);
        gsVertical:
          DrawLines(l, t, R, t, 0, 1, h, qLines);
        gsElliptic:
          ;
        gsRectangle:
          ;
        gsVertCenter:
          begin
            DrawLines(l, t, R, t, 0, 1, h / 2, qLines);
            DrawLines(l, b, R, b, 0, -1, h / 2, qLines);
          end;
        gsHorizCenter:
          begin
            DrawLines(l, t, l, b, 1, 0, w / 2, qLines);
            DrawLines(R, t, R, b, -1, 0, w / 2, qLines);
          end;
      end;
  end;

end;

procedure TfrxPDFExport.Cmd_FillObj(Obj: TfrxView; Color: TColor);
begin
  CmdFillColor(Color);
  Cmd_ObjPath(Obj);
  Cmd('f');
end;

function TfrxPDFExport.Cmd_Font(Obj: TfrxView): TfrxPDFFont;
var
  FontIndex: Integer;
begin
  FontIndex := FPOH.GetObjFontNumber(Obj.Font);
  Result := FPOH.PageFonts[FontIndex];

  Result.FontName := FPOH.Fonts[FontIndex].Name;
  Result.Size := Trunc((Obj.Font.Size - (tpPt * Obj.Font.Size)) * 10) / 10;
  Result.Color := IfColor(Obj.Font.Color <> clNone, Obj.Font.Color, clBlack);
end;

procedure TfrxPDFExport.Cmd_Hatch(Obj: TfrxView; Color: TColor;
  Style: TBrushStyle);

  procedure DrawLines(x1, y1, x2, y2, dX, dY: Extended; Count: Integer);
  var
    i: Integer;
  begin
    for i := 0 to Count do
    begin
      CmdMoveTo(x1 + i * dX, y1 + i * dY);
      CmdLineTo(x2 + i * dX, y2 + i * dY);
    end;
  end;

const
  HatchWidth = 0.75;
  Step = 8;
var
  VertShift, HorShift: Extended;
  VertCount, HorCount: Integer;
begin
  Cmd('[] 0 d');
  CmdStrokeColor(Color);
  CmdLineWidth(HatchWidth);
  Cmd('0 J');

  Cmd_ClipObj(Obj);

  with ShadowlessSizes(Obj) do
  begin
    VertCount := Trunc(h / Step);
    VertShift := (h - VertCount * Step) / 2;
    HorCount := Trunc(w / Step);
    HorShift := (w - HorCount * Step) / 2;

    if Style in [bsHorizontal, bsCross] then
      DrawLines(l, t + VertShift, R, t + VertShift, 0, Step, VertCount);
    if Style in [bsVertical, bsCross] then
      DrawLines(l + HorShift, t, l + HorShift, b, Step, 0, HorCount);
    if Style in [bsFDiagonal, bsDiagCross] then
      DrawLines(l + HorShift - h, t, l + HorShift, b, Step, 0,
        HorCount + VertCount);
    if Style in [bsBDiagonal, bsDiagCross] then
      DrawLines(l + HorShift, t, l + HorShift - h, b, Step, 0,
        HorCount + VertCount);
  end;

  CmdStroke;
end;

procedure TfrxPDFExport.Cmd_ObjPath(Obj: TfrxView);
begin
  if IsShape(Obj, [skRoundRectangle]) then
    Cmd_RoundRectanglePath(TfrxShapeView(Obj))
  else if IsShape(Obj, [skEllipse]) then
    Cmd_EllipsePath(TfrxShapeView(Obj))
  else if IsShape(Obj, [skTriangle]) then
    Cmd_TrianglePath(TfrxShapeView(Obj))
  else if IsShape(Obj, [skDiamond]) then
    Cmd_DiamondPath(TfrxShapeView(Obj))
  else // Rectangle, Memo etc.
    Cmd(frxRect2Str(GetClipRect(Obj)) + ' re');
end;

procedure TfrxPDFExport.Cmd_RoundRectanglePath(RoundedRect: TfrxShapeView);
var
  Radius, HalfRadius: Extended;
begin
  with RoundedRect do
    Radius := 3.74 * IfReal(Curve = 0, 2.0, Curve);
  HalfRadius := Radius / 2;
  with ShadowlessSizes(RoundedRect) do
  begin
    CmdMoveTo(l + Radius, b);
    CmdLineTo(R - Radius, b);
    CmdCurveTo(R - HalfRadius, b, R, b - HalfRadius, R, b - Radius);
    // right-bottom
    CmdLineTo(R, t + Radius);
    CmdCurveTo(R, t + HalfRadius, R - HalfRadius, t, R - Radius, t);
    // right-top
    CmdLineTo(l + Radius, t);
    CmdCurveTo(l + HalfRadius, t, l, t + HalfRadius, l, t + Radius);
    // left-top
    CmdLineTo(l, b - Radius);
    CmdCurveTo(l, b - HalfRadius, l + HalfRadius, b, l + Radius, b);
    // left-bottom
  end;
end;

procedure TfrxPDFExport.Cmd_TrianglePath(Triangle: TfrxShapeView);
begin
  with ShadowlessSizes(Triangle) do
  begin
    CmdMoveTo(l + w / 2, t);
    CmdLineTo(R, b);
    CmdLineTo(l, b);
    CmdLineTo(l + w / 2, t);
  end;
end;

constructor TfrxPDFExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPageAnnots := TMemoryStream.Create;
  FAnnots := TList.Create;
  FCompressed := True;
  FEmbedProt := True;
  FPrintOpt := False;
  FAuthor := 'FastReport';
  FSubject := 'FastReport PDF export';
  FBackground := False;
  FCreator := 'FastReport';
  FTags := True;
  FProtection := False;
  FUserPassword := '';
  FOwnerPassword := '';
  FProducer := '';
  FKeywords := '';
  FProtectionFlags := [ePrint, eModify, eCopy, eAnnot];
  FilterDesc := frxGet(8707);
  DefaultExt := frxGet(8708);
  FCreator := Application.Name;
  FPrintScaling := False;
  FFitWindow := False;
  FHideMenubar := False;
  FCenterWindow := False;
  FHideWindowUI := False;
  FHideToolbar := False;
  FSaveOriginalImages := False;
  FUsePNGAlpha := True;

  FRootNumber := 0;
  FPagesNumber := 0;
  FInfoNumber := 0;
  FStartXRef := 0;

  FPages := TList.Create;

  FPOH := TPDFObjectsHelper.Create;

  FPagesRef := TStringList.Create;

  FMarginLeft := 0;

  FEncKey := '';
  FOPass := '';
  FUPass := '';

  FEncBits := 0;

  FLastColor := clBlack;
  FLastColorResult := '0 0 0';

  FQuality := 95;
  FTransparency := False;

  FPDFviaEMF := peAppropriately;

  FEmbeddedFiles := TObjectList.Create;
  FZUGFeRDDescription := '';

  FPdfA := False;
  FPDFStandard := psNone;
  FPDFVersion := pv17;
end;

procedure TfrxPDFExport.CreateColorMask(Obj: TfrxView; TransparentColorMask: TColor;
      Scale: Extended; Offset: TPoint; TempBitmap: TBitmap;
      var MaskBytes: TMaskArray);
var
  TempMaskBitmap, TempMask8bitBitmap: TBitmap;
  Iy: Integer;
begin
  try
    TempMaskBitmap := CreateBitmap(pf32bit, TempBitmap);
    TempMask8bitBitmap := CreateBitmap(pf8bit, TempBitmap);
    try
      // draw object like text in black/white chanel for mask
      Obj.DrawAsMask := True;
      TempMaskBitmap.Canvas.Lock;
      try
        BitmapFill(TempMaskBitmap, TransparentColorMask);
        Obj.DrawClipped(TempMaskBitmap.Canvas, Scale, Scale, Offset.X, Offset.Y);
      finally
        TempMaskBitmap.Canvas.Unlock;
      end;
      Obj.DrawAsMask := False;
      TempMaskBitmap.Mask(TransparentColorMask);

      TempMask8bitBitmap.Canvas.Lock;
      try
        BitmapFill(TempMask8bitBitmap, $FFFFFF);
        TempMask8bitBitmap.Canvas.CopyMode := cmSrcInvert;
        TempMask8bitBitmap.Canvas.Draw(0, 0, TempMaskBitmap);
      finally
        TempMask8bitBitmap.Canvas.Unlock;
      end;
      SetLength(MaskBytes, BitmapPixelSize(TempMask8bitBitmap));
      for Iy := 0 to TempMask8bitBitmap.Height - 1 do
        CopyMemory(@MaskBytes[Iy * TempMask8bitBitmap.Width],
          TempMask8bitBitmap.ScanLine[Iy], TempMask8bitBitmap.Width);
    finally
      TempMaskBitmap.Free;
      TempMask8bitBitmap.Free;
    end;
  except

  end;
end;

procedure TfrxPDFExport.CreatePNGMask(PictObj: TfrxPictureView;
      Scale: Extended; Offset: TPoint; TempBitmap: TBitmap;
      var MaskBytes: TMaskArray);
var
  PNG, PNGA: TPNGObject;
  AlphaGraphicBitmap, AlphaPDFBitmap: TBitmap;
  Iy: Integer;
begin
  PNG := TPNGObject.Create;
  PNG.Assign(PictObj.Picture.Graphic);

  try
    PNGA := PNGToPNGA(PNG);
    try
      AlphaGraphicBitmap := CreateBitmap(pf8bit, PNGA.Width, PNGA.Height);
      try
        for Iy := 0 to AlphaGraphicBitmap.Height - 1 do
          CopyMemory(AlphaGraphicBitmap.ScanLine[Iy], PNGA.AlphaScanline[Iy],
            AlphaGraphicBitmap.Width);

        PictObj.Transparent := False;
        PictObj.Picture.Graphic := nil;
        PictObj.Picture.Graphic := AlphaGraphicBitmap;
      finally
        AlphaGraphicBitmap.Free;
      end;
    finally
      PNGA.Free;
    end;

    AlphaPDFBitmap := CreateBitmap(pf8bit, TempBitmap);
    try
      AlphaPDFBitmap.Canvas.Lock;
      try
        BitmapFill(AlphaPDFBitmap, clNone);
        PictObj.DrawClipped(AlphaPDFBitmap.Canvas, Scale, Scale, Offset.X, Offset.Y);
      finally
        AlphaPDFBitmap.Canvas.Unlock;
      end;

      PictObj.Transparent := True;
      PictObj.Picture.Graphic := nil;
      PictObj.Picture.Graphic := PNG;

      SetLength(MaskBytes, BitmapPixelSize(AlphaPDFBitmap));
      for Iy := 0 to AlphaPDFBitmap.Height - 1 do
        CopyMemory(@MaskBytes[Iy * AlphaPDFBitmap.Width],
          AlphaPDFBitmap.ScanLine[Iy], AlphaPDFBitmap.Width);
    finally
      AlphaPDFBitmap.Free;
    end;
  finally
    PNG.Free;
  end;
end;

function TfrxPDFExport.CryptStr(Source: AnsiString; Key: AnsiString;
  Enc: Boolean; id: Integer): AnsiString;
var
  k: array [1 .. 21] of Byte;
  rc4: TfrxRC4;
  s, s1, ss: AnsiString;
begin
  if Enc then
  begin
    rc4 := TfrxRC4.Create;
    try
      s := Key;
      FillChar(k, 21, 0);
      Move(s[1], k, 16);
      Move(id, k[17], 3);
      SetLength(s1, 21);
      MD5Buf(@k, 21, @s1[1]);
      ss := Source;
      SetLength(Result, Length(ss));
      rc4.Start(@s1[1], 16);
      rc4.Crypt(@ss[1], @Result[1], Length(ss));
      Result := EscapeSpecialChar(Result);
    finally
      rc4.Free;
    end;
  end
  else
    Result := EscapeSpecialChar(Source);
end;

destructor TfrxPDFExport.Destroy;
begin
  Clear;
  FPageAnnots.Free;
  FAnnots.Free;

  FPOH.Free;

  FPagesRef.Free;
  FPages.Free;
  FEmbeddedFiles.Free;
  inherited;
end;

procedure TfrxPDFExport.DoFill(const Obj: TfrxView);
begin
  Cmd('q');

  case Obj.FillType of
    ftBrush:
      Cmd_FillBrush(Obj, Obj.Fill as TfrxBrushFill);
    ftGradient:
      Cmd_FillGradient(Obj, Obj.Fill as TfrxGradientFill);
    ftGlass:
      Cmd_FillGlass(Obj, Obj.Fill as TfrxGlassFill);
  end;

  Cmd('Q');
end;

procedure TfrxPDFExport.DoFrame(const aFrame: TfrxFrame; const aRect: TfrxRect);
var
  AddPos: Extended;
  s: AnsiString;
  ShadowWidth: Extended;

  procedure DrawFrameLine(X0, Y0, x1, y1: Extended; Line: TfrxFrameLine;
    FType: TfrxFrameType; SecondLine: Boolean = False);
  var
    dX0, dY0, dX1, dY1: Extended;
  begin
    if (Line.Color = clNone) or (Line.Width < 0.01) then
      Exit;

    if (Line.Style = fsDouble) and not SecondLine then
      AddPos := -(Line.Width / 2);

    dX0 := X0;
    dY0 := Y0;
    dX1 := x1;
    dY1 := y1;
    case FType of
      ftLeft:
        begin
          dX0 := X0 - AddPos;
          dY0 := Y0 - AddPos;
          dX1 := x1 - AddPos;
          dY1 := y1 + AddPos;
        end;
      ftTop:
        begin
          dX0 := X0 - AddPos;
          dY0 := Y0 + AddPos;
          dX1 := x1 + AddPos;
          dY1 := y1 + AddPos;
        end;
      ftRight:
        begin
          dX0 := X0 + AddPos;
          dY0 := Y0 - AddPos;
          dX1 := x1 + AddPos;
          dY1 := y1 + AddPos;
        end;
      ftBottom:
        begin
          dX0 := X0 - AddPos;
          dY0 := Y0 - AddPos;
          dX1 := x1 + AddPos;
          dY1 := y1 - AddPos;
        end;
    end;
    Cmd(GetPDFDash(Line.Style, Line.Width));
    Write(OutStream, String(PdfSetLineWidth(Line.Width) + '2 J'#13#10 +
      PdfSetLineColor(Line.Color) + PdfMove(dX0, dY0) + PdfLine(dX1, dY1) +
      PdfStroke));

    if (Line.Style = fsDouble) and not SecondLine then
    begin
      AddPos := Line.Width;
      DrawFrameLine(X0, Y0, x1, y1, Line, FType, True);
      AddPos := 0;
    end;
  end;

begin
  Writeln(OutStream, 'q');
  if aFrame.DropShadow then
  begin
    ShadowWidth := (aFrame.ShadowWidth - 1) * PDF_DIVIDER;
    s := AnsiString(GetPDFColor(aFrame.ShadowColor));
    Write(OutStream, PdfSetLineWidth(1));
    Write(OutStream, s + ' rg'#13#10 + s + ' RG'#13#10 +
      AnsiString(frFloat2Str(aRect.Right + PDF_DIVIDER) + ' ' +
      frFloat2Str(aRect.Top - aFrame.ShadowWidth * PDF_DIVIDER) + ' ' +
      frFloat2Str(ShadowWidth) + ' ' + frFloat2Str(aRect.Bottom - aRect.Top) +
      ' re'#13#10'B'#13#10 + frFloat2Str(aRect.Left + aFrame.ShadowWidth *
      PDF_DIVIDER) + ' ' + frFloat2Str(aRect.Bottom - PDF_DIVIDER - ShadowWidth)
      + ' ' + frFloat2Str(aRect.Right - aRect.Left) + ' ' +
      frFloat2Str(ShadowWidth) + ' re'#13#10'B'#13#10));
  end;
  AddPos := 0;
  with aRect do
  begin
    if ftBottom in aFrame.Typ then
      DrawFrameLine(Left, Bottom, Right, Bottom, aFrame.BottomLine, ftBottom);
    if ftLeft in aFrame.Typ then
      DrawFrameLine(Left, Bottom, Left, Top, aFrame.LeftLine, ftLeft);
    if ftTop in aFrame.Typ then
      DrawFrameLine(Left, Top, Right, Top, aFrame.TopLine, ftTop);
    if ftRight in aFrame.Typ then
      DrawFrameLine(Right, Bottom, Right, Top, aFrame.RightLine, ftRight);
  end;

  Writeln(OutStream, 'Q');
end;

procedure TfrxPDFExport.EndClip;
begin
  Cmd('Q');
end;

function TfrxPDFExport.EscapeSpecialChar(TextStr: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(TextStr) do
    case TextStr[i] of
      '(':
        Result := Result + '\(';
      ')':
        Result := Result + '\)';
      '\':
        Result := Result + '\\';
      #13:
        Result := Result + '\r';
      #10:
        Result := Result + '\n';
    else
      Result := Result + AnsiChar(chr(Ord(TextStr[i])));
    end;
end;

class function TfrxPDFExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxPDFExportDialog;
end;

procedure TfrxPDFExport.ExportObject(Obj: TfrxComponent);
begin
  if (Obj is TfrxView) and
    ((ExportNotPrintable and (not TfrxView(Obj).Printable)) or
    (vsExport in TfrxView(Obj).Visibility)) then
    AddObject(Obj as TfrxView);
end;

procedure TfrxPDFExport.ExportViaVector(const Memo: TfrxCustomMemoView);
var
  VC: TVectorCanvas;
  i: Integer;
begin
  VC := Memo.GetVectorCanvas;
  try
    Cmd('q'); // save clip to stack

    for i := 0 to VC.Count - 1 do
      if      (VC[i] is TVector_ExtTextOutW)
           or (VC[i] is TVector_ExtTextOutA) then
        Vector_ExtTextOut(Memo, TVector_ExtTextOut(VC[i]));

    Cmd('Q'); // restore clip
  finally
    VC.Free;
  end;
end;

procedure TfrxPDFExport.Finish;
var
  i: Integer;
  s: string;
  FInfoNumber, FRootNumber, FEncNumber: LongInt;
  OutlineTree: TfrxPDFOutlineNode;
  pgN: TStringList;
  FOutlineObjId: Integer;

  function IsPageInRange(const PageN: Integer): Boolean;
  begin
    Result := (pgN.Count = 0) or (pgN.IndexOf(IntToStr(PageN + 1)) >= 0);
  end;

{ Converts TfrxCustomOutline to a tree of TfrxPDFOutlineNode nodes.
  The last argument represents the number of already added objects
  to FXRef. This value is needed to correctly assign object numbers
  to TfrxPDFOutlineNode nodes. }

  procedure PrepareOutline(Outline: TfrxCustomOutline; Node: TfrxPDFOutlineNode;
    ObjNum: Integer);
  var
    i: Integer;
    p: TfrxPDFOutlineNode;
    Prev: TfrxPDFOutlineNode;
    Text: string;
    Page, Top: Integer;
  begin
    Prev := nil;
    p := nil;

    for i := 0 to Outline.Count - 1 do
    begin
      Outline.GetItem(i, Text, Page, Top);
      if not IsPageInRange(Page) then
        Continue;

      p := TfrxPDFOutlineNode.Create;
      p.Title := Text;
      p.Dest := Page;
      p.Top := Top;
      p.Prev := Prev;

      Inc(ObjNum);
      p.Number := ObjNum;

      if Prev <> nil then
        Prev.Next := p
      else
        Node.First := p;

      Prev := p;
      p.Parent := Node;
      Outline.LevelDown(i);

      PrepareOutline(Outline, p, ObjNum);
      Inc(ObjNum, p.CountTree);

      Node.Count := Node.Count + 1;
      Node.CountTree := Node.CountTree + p.CountTree + 1;
      Outline.LevelUp;
    end;

    Node.Last := p;
  end;

  procedure WriteOutline(Node: TfrxPDFOutlineNode);
  var
    Page, y: Integer;
    Dest: string;
  begin
    { Actually, the following line of code does nothing:
      UpdateXRef returns a number that was predicted
      by PrepareOutline. }

    Node.Number := FPOH.UpdateXRef;

    Writeln(pdf, ObjNumber(Node.Number));
    Writeln(pdf, '<<');
    Writeln(pdf, '/Title ' + PrepareString(Node.Title, FEncKey, FProtection,
      Node.Number));
    Writeln(pdf, '/Parent ' + ObjNumberRef(Node.Parent.Number));

    if Node.Prev <> nil then
      Writeln(pdf, '/Prev ' + ObjNumberRef(Node.Prev.Number));

    if Node.Next <> nil then
      Writeln(pdf, '/Next ' + ObjNumberRef(Node.Next.Number));

    if Node.First <> nil then
    begin
      Writeln(pdf, '/First ' + ObjNumberRef(Node.First.Number));
      Writeln(pdf, '/Last ' + ObjNumberRef(Node.Last.Number));
      Writeln(pdf, '/Count ' + IntToStr(Node.Count));
    end;

    if IsPageInRange(Node.Dest) then
    begin
      if pgN.Count > 0 then
        Page := pgN.IndexOf(IntToStr(Node.Dest + 1))
      else
        Page := Node.Dest;
      if Page <> -1 then
      begin
        y := Round(TfrxPDFPage(FPages[Page]).Height - Node.Top * PDF_DIVIDER);
        Dest := FPagesRef[Page];
        Writeln(pdf, '/Dest [' + Dest + ' 0 R /XYZ 0 ' + IntToStr(y) + ' 0]');
      end
    end;

    Writeln(pdf, '>>');
    Writeln(pdf, 'endobj');

    if Node.First <> nil then
      WriteOutline(Node.First);

    if Node.Next <> nil then
      WriteOutline(Node.Next);
  end;

  procedure WriteAnnots;
  var
    i: Integer;
    annot: TfrxPDFAnnot;
  begin
    for i := 0 to FAnnots.Count - 1 do
    begin
      annot := TfrxPDFAnnot(FAnnots[i]);
      // fix xref position
      FPOH.XRef[annot.Number - 1] := PrepXrefPos(pdf.Position);

      Writeln(pdf, ObjNumber(annot.Number));
      Writeln(pdf, '<<');
      Writeln(pdf, '/Type /Annot');
      Writeln(pdf, '/Subtype /Link');
      if IsPDFA then
        Writeln(pdf, '/F 4');
      Writeln(pdf, '/Rect [' + annot.Rect + ']');

      if annot.Hyperlink <> '' then
      begin
        Writeln(pdf, '/BS << /W 0 >>');
        Writeln(pdf, '/A <<');
        Writeln(pdf, '/URI ' + annot.Hyperlink);
        Writeln(pdf, '/Type /Action');
        Writeln(pdf, '/S /URI');
        Writeln(pdf, '>>');
      end
      else if annot.DestPage < FPagesRef.Count then
      begin
        Writeln(pdf, '/Border [16 16 0]');
        Writeln(pdf, '/Dest [' + FPagesRef[annot.DestPage] + ' 0 R /XYZ null ' +
          IntToStr(annot.DestY) + ' null]');
      end;

      Writeln(pdf, '>>');
      Writeln(pdf, 'endobj');
    end;
  end;

begin
  FCreationDateTime := Now;

  for i := 0 to FPOH.FontsCount - 1 do
    WriteFont(FPOH.Fonts[i]);

  FPagesNumber := 1;
  FPOH.XRef[0] := PrepXrefPos(pdf.Position);
  Writeln(pdf, ObjNumber(FPagesNumber));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Type /Pages');
  Write(pdf, '/Kids [');
  for i := 0 to FPagesRef.Count - 1 do
    Write(pdf, FPagesRef[i] + ' 0 R ');
  Writeln(pdf, ']');
  Writeln(pdf, '/Count ' + IntToStr(FPagesRef.Count));
  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');

  // PDF/A
  if IsPDFA then
  begin
    AddAttachments;
    AddStructure;
    AddMetaData;
    AddColorProfile;
  end;

  FInfoNumber := FPOH.UpdateXRef();
  Writeln(pdf, ObjNumber(FInfoNumber));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Title ' + PrepareString(FTitle, FEncKey, FProtection,
    FInfoNumber));
  Writeln(pdf, '/Author ' + PrepareString(FAuthor, FEncKey, FProtection,
    FInfoNumber));
  Writeln(pdf, '/Subject ' + PrepareString(FSubject, FEncKey, FProtection,
    FInfoNumber));
  Writeln(pdf, '/Keywords ' + PrepareString(FKeywords, FEncKey, FProtection,
    FInfoNumber));
  Writeln(pdf, '/Creator ' + PrepareString(FCreator, FEncKey, FProtection,
    FInfoNumber));
  Writeln(pdf, '/Producer ' + PrepareString(FProducer, FEncKey, FProtection,
    FInfoNumber));

  DateTimeToString(s, 'yyyymmddhhnnss', FCreationDateTime);
  s := 'D:' + s + '-00''00''';
  {$IfDef EXPORT_TEST}
    Writeln(pdf, '/CreationDate (20190109012524)');
    Writeln(pdf, '/ModDate (20190109012524)');
  {$ELSE}
    if FProtection then
    begin
      Writeln(pdf, '/CreationDate ' + PrepareString(s, FEncKey, FProtection,
        FInfoNumber));
      Writeln(pdf, '/ModDate ' + PrepareString(s, FEncKey, FProtection,
        FInfoNumber));
    end
    else
    begin
      Writeln(pdf, '/CreationDate (' + s + ')');
      Writeln(pdf, '/ModDate (' + s + ')');
    end;
  {$EndIf}
  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');

  FEncNumber := 0; // remove warning
  if FProtection then
  begin
    FRootNumber := FPOH.UpdateXRef;
    FEncNumber := FRootNumber;
    Writeln(pdf, ObjNumber(FRootNumber));
    Writeln(pdf, '<<');
    Writeln(pdf, '/Filter /Standard');
    Writeln(pdf, '/V 2');
    Writeln(pdf, '/R 3');
    Writeln(pdf, '/Length 128');
    Writeln(pdf, '/P ' + IntToStr(Integer(FEncBits)));
    Writeln(pdf, '/O (' + EscapeSpecialChar(FOPass) + ')');
    Writeln(pdf, '/U (' + EscapeSpecialChar(FUPass) + ')');
    Writeln(pdf, '>>');
    Writeln(pdf, 'endobj');
  end;

  { Write the document outline }

  OutlineTree := TfrxPDFOutlineNode.Create;
  pgN := TStringList.Create;
  FOutlineObjId := 0;

  if FOutline then
  begin
    frxParsePageNumbers(PageNumbers, pgN, Report.PreviewPages.Count);
    FPreviewOutline.LevelRoot;

    { PrepareOutline needs to know the exact number of objects
      that will be written before the first outline node object.
      The number of already written objects is FXRef.Count, and
      one object (/Type /Outlines) will be written before the first
      outline node. That's why PrepareOutline is given FXRef.Count + 1. }

    PrepareOutline(FPreviewOutline, OutlineTree, FPOH.XRef.Count + 1);
  end;

  if OutlineTree.CountTree > 0 then
  begin
    FOutlineObjId := FPOH.UpdateXRef;
    OutlineTree.Number := FOutlineObjId;

    { It's important to write the /Outlines object first,
      because object numbers for outline nodes was calculated
      in assumption that /Outlines will be written first. }

    Writeln(pdf, ObjNumber(FOutlineObjId));
    Writeln(pdf, '<<');
    Writeln(pdf, '/Type /Outlines');
//    Writeln(pdf, '/Count ' + IntToStr(OutlineTree.Count));
    Writeln(pdf, '/Count ' + IntToStr(OutlineTree.CountTree));
    Writeln(pdf, '/First ' + ObjNumberRef(OutlineTree.First.Number));
    Writeln(pdf, '/Last ' + ObjNumberRef(OutlineTree.Last.Number));
    Writeln(pdf, '>>');
    Writeln(pdf, 'endobj');

    { Write outline nodes }

    WriteOutline(OutlineTree.First);
  end;

  OutlineTree.Free;
  pgN.Free;

  { Write annots }
  if FAnnots.Count > 0 then
    WriteAnnots;

  { Write the catalog }

  FRootNumber := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(FRootNumber));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Type /Catalog');
  Writeln(pdf, '/Version /' + PDFVersionName[PDFVersion]);
  Writeln(pdf, '/MarkInfo << /Marked true >>');
  Writeln(pdf, '/Pages ' + ObjNumberRef(FPagesNumber));

  if FOutline then
    s := '/UseOutlines'
  else
    s := '/UseNone';

  Writeln(pdf, '/PageMode ' + s);

  if FOutline then
    Writeln(pdf, '/Outlines ' + ObjNumberRef(FOutlineObjId));

  if IsPDFA then
  begin
    Writeln(pdf, '/Metadata ' + ObjNumberRef(FMetaFileId));

    if FEmbeddedFiles.Count > 0 then
    begin
      Write(pdf, '/AF ' + ObjNumberRef(FAttachmentsListId));
      WriteLn(pdf, ' /Names << /EmbeddedFiles ' + ObjNumberRef(FAttachmentsNamesId) + ' >>');
    end;

    Writeln(pdf, '/OutputIntents [ ' + ObjNumberRef(FColorProfileId) + ' ]');
    Writeln(pdf, '/StructTreeRoot ' + ObjNumberRef(FStructId));
  end;

  Writeln(pdf, '/ViewerPreferences <<');

  if FTitle <> '' then
    Writeln(pdf, '/DisplayDocTitle true');
  if FHideToolbar then
    Writeln(pdf, '/HideToolbar true');
  if FHideMenubar then
    Writeln(pdf, '/HideMenubar true');
  if FHideWindowUI then
    Writeln(pdf, '/HideWindowUI true');
  if FFitWindow then
    Writeln(pdf, '/FitWindow true');
  if FCenterWindow then
    Writeln(pdf, '/CenterWindow true');
  if not FPrintScaling then
    Writeln(pdf, '/PrintScaling false');

  Writeln(pdf, '>>');

  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');

  FStartXRef := pdf.Position;
  Writeln(pdf, 'xref');
  Writeln(pdf, '0 ' + IntToStr(FPOH.XRef.Count + 1));
  Writeln(pdf, '0000000000 65535 f');
  for i := 0 to FPOH.XRef.Count - 1 do
    Writeln(pdf, FPOH.XRef[i] + ' 00000 n');
  Writeln(pdf, 'trailer');
  Writeln(pdf, '<<');
  Writeln(pdf, '/Size ' + IntToStr(FPOH.XRef.Count + 1));
  Writeln(pdf, '/Root ' + ObjNumberRef(FRootNumber));
  Writeln(pdf, '/Info ' + ObjNumberRef(FInfoNumber));
  Writeln(pdf, '/ID [<' + FFileID + '><' + FFileID + '>]');
  if FProtection then
    Writeln(pdf, '/Encrypt ' + ObjNumberRef(FEncNumber));
  Writeln(pdf, '>>');
  Writeln(pdf, 'startxref');
  Writeln(pdf, IntToStr(FStartXRef));
  Writeln(pdf, '%%EOF');
  Clear;
  if not Assigned(Stream) then
  begin
    IOTransport.DoFilterSave(pdf);
    IOTransport.FreeStream(pdf);
  end;
  // pdf.Free;
end;

procedure TfrxPDFExport.FinishPage(Page: TfrxReportPage; Index: Integer);
var
  FContentsPos, FPagePos: Integer;
  i: Integer;
begin

  // finish page
  FContentsPos := FPOH.UpdateXRef();
  Writeln(pdf, ObjNumber(FContentsPos));
  OutStream.Position := 0;
  WritePDFStream(pdf, OutStream, FContentsPos, FCompressed, FProtection,
    True, True, False);

  for i := 0 to FPOH.PageFontsCount - 1 do
    if not FPOH.PageFonts[i].Saved then
    begin
      FPOH.PageFonts[i].Reference := FPOH.UpdateXRef;
      FPOH.PageFonts[i].Saved := True;
    end;

  FPagePos := FPOH.UpdateXRef();
  FPagesRef.Add(IntToStr(FPagePos));
  Writeln(pdf, ObjNumber(FPagePos));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Type /Page');
  Writeln(pdf, '/Parent ' + ObjNumberRef(1));
  Writeln(pdf, '/MediaBox [0 0 ' + frFloat2Str(FWidth) + ' ' +
    frFloat2Str(FHeight) + ' ]');

  { Write the list of references
    to anchor objects }

  if FPageAnnots.Size > 0 then
  begin
    Writeln(pdf, '/Annots [');
    FPageAnnots.Seek(0, soFromBeginning);
    pdf.CopyFrom(FPageAnnots, FPageAnnots.Size);
    Writeln(pdf, ']');
    FPageAnnots.Clear;
  end;
  if Transparency then
    Writeln(pdf, '/Group << /Type /Group /S /Transparency /CS /DeviceRGB >>');
  Writeln(pdf, '/Resources <<');
  Write(pdf, '/Font << ');
  for i := 0 to FPOH.PageFontsCount - 1 do
    Write(pdf, FPOH.PageFonts[i].Name +
      AnsiString(' ' + ObjNumberRef(FPOH.PageFonts[i].Reference) + ' '));
  Writeln(pdf, '>>');

  FPOH.OutUsedXObjects;

  Writeln(pdf, '/ProcSet [/PDF /Text /ImageC ]');
  Writeln(pdf, '>>');
  Writeln(pdf, '/Contents ' + ObjNumberRef(FContentsPos));
  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');
  { Clear piture cache }
  Self.FPOH.ClearXObject;
end;

function TfrxPDFExport.GetClipRect(Obj: TfrxView; Internal: Boolean): TfrxRect;
var
  cLeft, cRight, cTop, cBottom, cShadow: Extended;

  function GetFrameCorr(Line: TfrxFrameLine): Extended;
  begin
    Result := Line.Width / 2;
    if Line.Style = fsDouble then
      Result := Result + 0.3 + Line.Width;
    if Internal then
      Result := (Result + Line.Width / 2) * (-1);
  end;

begin
  cLeft := IfReal(ftLeft in Obj.Frame.Typ, GetFrameCorr(Obj.Frame.LeftLine));
  cRight := IfReal(ftRight in Obj.Frame.Typ, GetFrameCorr(Obj.Frame.RightLine));
  cTop := IfReal(ftTop in Obj.Frame.Typ, GetFrameCorr(Obj.Frame.TopLine));
  cBottom := IfReal(ftBottom in Obj.Frame.Typ, GetFrameCorr(Obj.Frame.BottomLine));

  cShadow := IfReal(Obj.Frame.DropShadow, Obj.Frame.ShadowWidth);

  Result := frxRect(pdfX(Obj.AbsLeft - cLeft), pdfY(Obj.AbsTop - cTop),
    pdfX(Obj.AbsLeft + Obj.Width + cRight - cShadow),
    pdfY(Obj.AbsTop + Obj.Height + cBottom - cShadow));
end;

class function TfrxPDFExport.GetDescription: String;
begin
  Result := frxResources.Get('PDFexport');
end;

function TfrxPDFExport.GetDMPRect(R: TfrxRect): TfrxRect;
begin
  Result := R;
  with Result do
  begin
    Left := Left - fr1CharX / 2;
    Top := Top + fr1CharY / 2;
    Right := Right + fr1CharX / 2;
    Bottom := Bottom - fr1CharY / 2;
  end;
end;

function TfrxPDFExport.GetID: AnsiString;
var
  AGUID: TGUID;
  AGUIDString: WideString;
begin
  CoCreateGUID(AGUID);
  SetLength(AGUIDString, 39);
  StringFromGUID2(AGUID, PWideChar(AGUIDString), 39);
  Result := AnsiString(PWideChar(AGUIDString));
  MD5String(AnsiString(PWideChar(AGUIDString)));
end;

function TfrxPDFExport.GetPDFColor(const Color: TColor): String;
var
  TheRgbValue: TColorRef;
begin
  if Color = clBlack then
    Result := '0 0 0'
  else if Color = clWhite then
    Result := '1 1 1'
  else if Color = FLastColor then
    Result := FLastColorResult
  else
  begin
    TheRgbValue := ColorToRGB(Color);
    Result := frFloat2Str(Byte(TheRgbValue) / 255) + ' ' +
      frFloat2Str(Byte(TheRgbValue shr 8) / 255) + ' ' +
      frFloat2Str(Byte(TheRgbValue shr 16) / 255);
    FLastColor := Color;
    FLastColorResult := Result;
  end;
end;

function TfrxPDFExport.GetPDFDash(const LineStyle: TfrxFrameStyle;
  Width: Extended): String;
var
  dash, dot: String;
begin
  if (LineStyle = fsSolid) or (Width < 0.01) then
    Result := '[] 0 d'
  else
  begin
    dash := frFloat2Str(Width * 6) + ' ';
    dot := frFloat2Str(Width * 2) + ' ';
    if LineStyle = fsDash then
      Result := '[' + dash + '] 0 d'
    else if LineStyle = fsDashDot then
      Result := '[' + dash + dash + dot + dash + '] 0 d'
    else if LineStyle = fsDashDotDot then
      Result := '[' + dash + dash + dot + dash + dot + dash + '] 0 d'
    else if LineStyle = fsDot then
      Result := '[' + dot + dash + '] 0 d'
    else if LineStyle = fsSquare then
      Result := '[' + dot + dot + '] 0 d'
    else
      Result := '[] 0 d';
  end;
end;

function TfrxPDFExport.GetRect(Obj: TfrxView): TfrxRect;
begin
  Result := frxRect(pdfX(Obj.AbsLeft), pdfY(Obj.AbsTop),
    pdfX(Obj.AbsLeft + Obj.Width - Obj.ShadowSize),
    pdfY(Obj.AbsTop + Obj.Height - Obj.ShadowSize));
end;

function TfrxPDFExport.GetRectEMFExport(Obj: TfrxView): TfrxRect;
begin
  Result := Obj.GetExportBounds;
  Result := frxRect(pdfX(Result.Left), pdfY(Result.Top),
    pdfX(Result.Right), pdfY(Result.Bottom));
end;

function TfrxPDFExport.IsAddViaEMF(const Obj: TfrxView): Boolean;
begin
{$IFNDEF RAD_ED}
  Result := (FPDFviaEMF = peAlways) or (FPDFviaEMF = peAppropriately) and
    Obj.IsEMFExportable;
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TfrxPDFExport.IsHasHTMLTags(const MemoView
  : TfrxCustomMemoView): Boolean;
begin
  Result := MemoView.AllowHTMLTags and FTags and
    (Pos('<', MemoView.Memo.Text) > 0);
end;

function TfrxPDFExport.IsPDFA: Boolean;
begin
  Result := frxExportPDFHelpers.IsPDFA(PDFStandard);
end;

function TfrxPDFExport.IsPDFA_1: Boolean;
begin
  Result := frxExportPDFHelpers.IsPDFA_1(PDFStandard);
end;

function TfrxPDFExport.PrepareString(const Text: WideString; Key: AnsiString;
  Enc: Boolean; id: Integer): AnsiString;
begin
  if Enc then
    Result := '(' + CryptStr(StrToUTF16(Text), Key, Enc, id) + ')'
  else
    Result := '(' + StrToUTF16(Text) + ')'
end;

function TfrxPDFExport.PMD52Str(p: Pointer): AnsiString;
begin
  SetLength(Result, 16);
  Move(p^, Result[1], 16);
end;

function TfrxPDFExport.PadPassword(Password: AnsiString): AnsiString;
var
  i: Integer;
begin
  i := Length(Password);
  Result := Copy(Password, 1, i);
  SetLength(Result, 32);
  if i < 32 then
    Move(PDF_PK, Result[i + 1], 32 - i);
end;

function TfrxPDFExport.pdfPoint(x, y: Extended): TfrxPoint;
begin
  Result := frxPoint(pdfX(x), pdfY(y));
end;

function TfrxPDFExport.pdfSize(Size: Extended): Extended;
begin
  Result := Size * PDF_DIVIDER;
end;

function TfrxPDFExport.pdfX(x: Extended): Extended;
begin
  Result := FMarginLeft + pdfSize(x);
end;

function TfrxPDFExport.pdfY(y: Extended): Extended;
begin
  Result := FHeight - FMarginTop - pdfSize(y);
end;

procedure TfrxPDFExport.PrepareKeys;
var
  s, s1, p, p1, fid: AnsiString;
  i, j: Integer;
  rc4: TfrxRC4;
  md5: TfrxMD5;
begin
  // OWNER KEY
  if FOwnerPassword = '' then
    FOwnerPassword := FUserPassword;
  p := PadPassword(FOwnerPassword);
  md5 := TfrxMD5.Create;
  try
    md5.Init;
    md5.Update(@p[1], 32);
    md5.Finalize;
    s := PMD52Str(md5.Digest);
    for i := 1 to 50 do
    begin
      md5.Init;
      md5.Update(@s[1], 16);
      md5.Finalize;
      s := PMD52Str(md5.Digest);
    end;
  finally
    md5.Free;
  end;

  rc4 := TfrxRC4.Create;
  try
    p := PadPassword(FUserPassword);
    SetLength(s1, 32);
    rc4.Start(@s[1], 16);
    rc4.Crypt(@p[1], @s1[1], 32);
    SetLength(p1, 16);
    for i := 1 to 19 do
    begin
      for j := 1 to 16 do
        p1[j] := AnsiChar(Byte(s[j]) xor i);
      rc4.Start(@p1[1], 16);
      rc4.Crypt(@s1[1], @s1[1], 32);
    end;
    FOPass := s1;
  finally
    rc4.Free;
  end;

  // ENCRYPTION KEY
  p := PadPassword(FUserPassword);
  md5 := TfrxMD5.Create;
  try
    md5.Init;
    md5.Update(@p[1], 32);
    md5.Update(@FOPass[1], 32);
    md5.Update(@FEncBits, 4);
    fid := '';
    for i := 1 to 16 do
      fid := fid + AnsiChar
        (chr(Byte(StrToInt('$' + String(FFileID[i * 2 - 1] + FFileID[i
        * 2])))));
    md5.Update(@fid[1], 16);
    md5.Finalize;
    s := PMD52Str(md5.Digest);
    for i := 1 to 50 do
    begin
      md5.Init;
      md5.Update(@s[1], 16);
      md5.Finalize;
      s := PMD52Str(md5.Digest);
    end;
  finally
    md5.Free;
  end;
  FEncKey := s;
  FPOH.EncKey := FEncKey;

  // USER KEY
  md5 := TfrxMD5.Create;
  try
    md5.Update(@PDF_PK, 32);
    md5.Update(@fid[1], 16);
    md5.Finalize;
    s := PMD52Str(md5.Digest);
    s1 := FEncKey;
    rc4 := TfrxRC4.Create;
    try
      rc4.Start(@s1[1], 16);
      rc4.Crypt(@s[1], @s[1], 16);
      SetLength(p1, 16);
      for i := 1 to 19 do
      begin
        for j := 1 to 16 do
          p1[j] := AnsiChar(Byte(s1[j]) xor i);
        rc4.Start(@p1[1], 16);
        rc4.Crypt(@s[1], @s[1], 16);
      end;
      FUPass := s;
    finally
      rc4.Free;
    end;
    SetLength(FUPass, 32);
    FillChar(FUPass[17], 16, 0);
  finally
    md5.Free;
  end;
end;

procedure TfrxPDFExport.SetEmbeddedFonts(const Value: Boolean);
begin
  if IsPDFA then
    FEmbeddedFonts := True
  else
    FEmbeddedFonts := Value;

  if Assigned(FPOH) then
    FPOH.EmbeddedFonts := FEmbeddedFonts;
end;

procedure TfrxPDFExport.SetPdfA(const Value: Boolean);
begin
  FPdfA := Value;
  if FPdfA then
    SetPDFStandard(psPDFA_2a)
  else
    SetPDFStandard(psNone);
end;

procedure TfrxPDFExport.SetPDFStandard(const Value: TPDFStandard);
begin
  FPDFStandard := Value;
  IsVersionByStandard(PDFStandard, FPDFVersion);

  if IsPDFA then
    FEmbeddedFonts := True;

  if IsPDFA_1 then
    FTransparency := False;

  FPdfA := IsPDFA;
end;

procedure TfrxPDFExport.SetPDFVersion(const Value: TPDFVersion);
begin
  if not IsVersionByStandard(PDFStandard, FPDFVersion) then
    FPDFVersion := Value;
end;

procedure TfrxPDFExport.SetProtectionFlags(const Value: TfrxPDFEncBits);
begin
  FProtectionFlags := Value;
  FEncBits := $FFFFFFC0;
  FEncBits := FEncBits + (Cardinal(ePrint in Value) shl 2 +
    Cardinal(eModify in Value) shl 3 + Cardinal(eCopy in Value) shl 4 +
    Cardinal(eAnnot in Value) shl 5);
end;

procedure TfrxPDFExport.SetTransparency(const Value: Boolean);
begin
  if IsPDFA_1 then
    FTransparency := False
  else
    FTransparency := Value;
end;

function TfrxPDFExport.Start: Boolean;
begin
  if (FileName <> '') or Assigned(Stream) then
  begin
    FProtection := (FOwnerPassword <> '') or (FUserPassword <> '');

    if IsPDFA then
    begin
      FProtection := False;
      EmbeddedFonts := True;
    end;
    FPOH.Protection := FProtection;

    if Assigned(Stream) then
      pdf := Stream
    else
      pdf := IOTransport.GetStream(FileName);
    // TFileStream.Create(FileName, fmCreate);
    FPOH.pdfStream := pdf;
    FPOH.Quality := Quality;
    Result := True;
    // start here
    Clear;
    {$IfDef EXPORT_TEST}
      FFileID := 'a8985cb82e4ae9af39f65ebb03671ccd';
    {$ELSE}
      FFileID := MD5String(GetID);
    {$ENDIF}
    if FProtection then
    begin
      PrepareKeys;
      EmbeddedFonts := FEmbedProt;
    end;

    if FOutline then
      FPreviewOutline := Report.PreviewPages.Outline;

    Writeln(pdf, '%PDF-' + PDFVersionName[PDFVersion]);
    // PDF/A unicode signature
    Writeln(pdf, PDF_SIGNATURE);
    FPOH.UpdateXRef;
  end
  else
    Result := False;
end;

procedure TfrxPDFExport.StartPage(Page: TfrxReportPage; Index: Integer);
const
  mm2p: Double = 1.0 / 25.4 * 72; // millimeters to points
begin
  FPOH.ClearUsedXObjects;

  AddPage(Page);
  FWidth := Page.Width * PDF_DIVIDER;
  FHeight := Page.Height * PDF_DIVIDER;
  FMarginLeft := Page.LeftMargin * PDF_MARG_DIVIDER;
  FMarginTop := Page.TopMargin * PDF_MARG_DIVIDER;

  OutStream := TMemoryStream.Create;

  with Page do
    if MirrorMargins and (Index mod 2 = 1) then
      FPageRect := frxRect(RightMargin * mm2p + 0.5, FHeight - TopMargin * mm2p,
        FWidth - LeftMargin * mm2p + 0.5, BottomMargin * mm2p)
    else
      FPageRect := frxRect(LeftMargin * mm2p + 0.5, FHeight - TopMargin * mm2p,
        FWidth - RightMargin * mm2p + 0.5, BottomMargin * mm2p);

  if Background and (Page.Color <> clNone) then
    Write(OutStream, PdfFillRect(FPageRect, Page.Color));
  DoFrame(Page.Frame, FPageRect);
end;

function TfrxPDFExport.STpdfPoint(x, y: Extended): String;
begin
  Result := frxPoint2Str(pdfPoint(x, y));
end;

function TfrxPDFExport.STpdfRect(x, y, Width, Height: Extended): String;
begin
  Result := Float2Str(pdfX(x)) + ' ' + Float2Str(pdfY(y)) + ' ' +
    Float2Str(pdfSize(Width)) + ' ' + Float2Str(pdfSize(Height));
end;

function TfrxPDFExport.STpdfSize(Size: Extended): String;
begin
  Result := Float2Str(pdfSize(Size));
end;

function TfrxPDFExport.StrToUTF16H(const Value: WideString): AnsiString;
var
  i: Integer;
  pwc: ^Word;
begin
  Result := 'FEFF';
  for i := 1 to Length(Value) do
  begin
    pwc := @Value[i];
    Result := Result + AnsiString(IntToHex(pwc^, 4));
  end;
end;

procedure TfrxPDFExport.Vector_ExtTextOut(Memo: TfrxCustomMemoView; Vector: TVector_ExtTextOut);
const
  YCorrection = 1.2;
  UnderlineShift = -0.175;
  StrikeOutShift = 0.24;
  UnderlineWidth = 0.12;
  StrikeOutWidth = 0.06;
var
  pdfFont: TfrxPDFFont;
  pdfTextPosition: TfrxPoint;
  Correction: TfrxPoint;
  Angle: Extended; // Radian
  RTLReading: Boolean;
  RS: TRemapedString;
  Simulation: String;
  SimulateBold: Boolean;
  SpaceAdjustment, Y: Extended;
  FRotation2D: TRotation2D;

  procedure WriteFontLine(RelativeWidth, RelativeShift: Extended);
  begin
    Cmd(frFloat2Str(pdfFont.Size * RelativeWidth) + ' w');
    Y := pdfTextPosition.Y + pdfFont.Size * RelativeShift;
    WriteLn(OutStream, PdfMove(pdfTextPosition.X, Y));
    WriteLn(OutStream, PdfLine(pdfTextPosition.X + Vector.TextLength * PDF_DIVIDER, Y));
    Cmd('S');
  end;
begin
  if Vector.Str = '' then
    Exit;

  Cmd('q'); // save clip to stack

  if Vector.Options and ETO_CLIPPED = ETO_CLIPPED then
    Cmd_ClipRect(Memo); // This could be done by Vector.Rect

  //Font
  pdfFont := Cmd_Font(Memo);

  Angle := Memo.ReducedAngle * Pi / 180;
  Correction.X := Sin(Angle) * YCorrection * Memo.Font.Size;
  Correction.Y := Cos(Angle) * YCorrection * Memo.Font.Size;
  pdfTextPosition := pdfPoint(Memo.AbsLeft + Vector.X + Correction.X,
                              Memo.AbsTop + Vector.Y + Correction.Y);
  // Rotation
  FRotation2D := TRotation2D.Create;
  if Memo.ReducedAngle <> 0 then
  begin
    FRotation2D.Init(Angle, frxPoint(Vector.X, Vector.Y)); // 0, 0 the same result
    Cmd(FRotation2D.Matrix + ' cm');
    pdfTextPosition := FRotation2D.Turn(pdfTextPosition);
  end;
  FRotation2D.Free;

  Cmd('BT'); // Begin text object

  // #332005
  Write(OutStream, pdfFont.FontName +
    AnsiString(' ' + frFloat2Str(pdfFont.Size) + ' Tf'#13#10));
  Write(OutStream, GetPDFColor(pdfFont.Color) + ' rg'#13#10);

  Cmd(frxPoint2Str(pdfTextPosition) + ' Td'); // Move text position

  RTLReading := Vector.Options and ETO_RTLREADING = ETO_RTLREADING;
  RS := pdfFont.SoftRemapString(Vector.Str, RTLReading, IsPDFA);

  if IsNeedsItalicSimulation(Memo.Font, Simulation) then
    Cmd(Simulation + ' ' + frxPoint2Str(pdfTextPosition) + ' Tm');
  SimulateBold := IsNeedsBoldSimulation(Memo.Font, Simulation);
  if SimulateBold then
    Cmd(Simulation);

  // Show text
  if (Length(RS.Data) > 1) and (RS.SpacesCount > 0) then
  begin
    SpaceAdjustment := pdfFont.SpaceAdjustment(RS,
      Vector.TextLength * PDF_DIVIDER, pdfFont.Size);
    WriteLn(OutStream, '[<' + StrToHexSp(Vector.Str, RS.Data,
      SpaceAdjustment) + '>] TJ')
  end
  else
    WriteLn(OutStream, '<' + StrToHex(RS.Data) + '> Tj');

  Cmd('ET'); // End text object

  if SimulateBold then
    Cmd('0 Tr');

  with Memo do
    if (fsUnderline in Font.Style) or (fsStrikeout in Font.Style) then
    begin
      Cmd('[] 0 d');
      Cmd(GetPDFColor(Font.Color) + ' RG');
      if fsUnderline in Font.Style then
        WriteFontLine(UnderlineWidth, UnderlineShift);
      if fsStrikeout in Font.Style then
        WriteFontLine(StrikeOutWidth, StrikeOutShift);
    end;
  Cmd('Q'); // restore clip
end;

function TfrxPDFExport.StrToUTF16(const Value: WideString): AnsiString;
var
  i: Integer;
  pwc: ^Word;
begin
  Result := #$FE + #$FF;
  for i := 1 to Length(Value) do
  begin
    pwc := @Value[i];
    Result := Result + AnsiChar(pwc^ shr 8) + AnsiChar(pwc^ and $FF);
  end;
end;

procedure TfrxPDFExport.WriteFont(pdfFont: TfrxPDFFont);
var
  fontFileId, descriptorId, toUnicodeId, cIDSystemInfoId,
    descendantFontId: LongInt;
  fontName: String;
  i: Integer;
  fontstream, tounicode: TMemoryStream;
begin
  fontFileId := 0;
  fontName := String(pdfFont.GetFontName);
  // embedded font
  if EmbeddedFonts then
  begin
    fontFileId := FPOH.UpdateXRef;
    Writeln(pdf, ObjNumber(fontFileId));
    // alman
    pdfFont.PackTTFFont;
    fontstream := TMemoryStream.Create;
    fontstream.Write(pdfFont.FontData^, pdfFont.FontDataSize);
    fontstream.Position := 0;
    WritePDFStream(pdf, fontstream, fontFileId, FCompressed, FProtection,
      True, True, False);
  end;
  // descriptor
  descriptorId := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(descriptorId));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Type /FontDescriptor');
  Writeln(pdf, '/FontName /' + fontName);
  // WriteLn(pdf, '/FontFamily /' + fontName);
  Writeln(pdf, '/Flags 32');
  Writeln(pdf, '/FontBBox [' + IntToStr(pdfFont.TextMetric^.otmrcFontBox.Left) +
    ' ' + IntToStr(pdfFont.TextMetric^.otmrcFontBox.Bottom) + ' ' +
    IntToStr(pdfFont.TextMetric.otmrcFontBox.Right) + ' ' +
    IntToStr(pdfFont.TextMetric.otmrcFontBox.Top) + ' ]');
  Writeln(pdf, '/ItalicAngle ' + IntToStr(pdfFont.TextMetric^.otmItalicAngle));
  Writeln(pdf, '/Ascent ' + IntToStr(pdfFont.TextMetric^.otmAscent));
  Writeln(pdf, '/Descent ' + IntToStr(pdfFont.TextMetric^.otmDescent));
  Writeln(pdf, '/Leading ' +
    IntToStr(pdfFont.TextMetric^.otmTextMetrics.tmInternalLeading));
  Writeln(pdf, '/CapHeight ' +
    IntToStr(pdfFont.TextMetric^.otmTextMetrics.tmHeight));
  Writeln(pdf, '/StemV ' + IntToStr(50 +
    Round(sqr(pdfFont.TextMetric^.otmTextMetrics.tmWeight / 65))));
  Writeln(pdf, '/AvgWidth ' +
    IntToStr(pdfFont.TextMetric^.otmTextMetrics.tmAveCharWidth));
  Writeln(pdf, '/MxWidth ' +
    IntToStr(pdfFont.TextMetric^.otmTextMetrics.tmMaxCharWidth));
  Writeln(pdf, '/MissingWidth ' +
    IntToStr(pdfFont.TextMetric^.otmTextMetrics.tmAveCharWidth));
  if EmbeddedFonts then
    Writeln(pdf, '/FontFile2 ' + ObjNumberRef(fontFileId));
  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');
  // ToUnicode
  toUnicodeId := FPOH.UpdateXRef();
  Writeln(pdf, ObjNumber(toUnicodeId));
  tounicode := TMemoryStream.Create;
  Writeln(tounicode, '/CIDInit /ProcSet findresource begin');
  Writeln(tounicode, '12 dict begin');
  Writeln(tounicode, 'begincmap');
  Writeln(tounicode, '/CIDSystemInfo');
  Writeln(tounicode, '<< /Registry (Adobe)');
  Writeln(tounicode, '/Ordering (UCS)');
  Writeln(tounicode, '/Ordering (Identity)');
  Writeln(tounicode, '/Supplement 0');
  Writeln(tounicode, '>> def');
  Write(tounicode, '/CMapName /');
  Write(tounicode, StringReplace(pdfFont.GetFontName, AnsiString(','),
    AnsiString('+'), [rfReplaceAll]));
  Writeln(tounicode, ' def');
  Writeln(tounicode, '/CMapType 2 def');
  Writeln(tounicode, '1 begincodespacerange');
  Writeln(tounicode, '<0000> <FFFF>');
  Writeln(tounicode, 'endcodespacerange');
  Write(tounicode, IntToStr(pdfFont.UsedAlphabet.Count));
  Writeln(tounicode, ' beginbfchar');
  for i := 0 to pdfFont.UsedAlphabet.Count - 1 do
  begin
    Write(tounicode, '<');
    Write(tounicode, IntToHex(Word(pdfFont.UsedAlphabet[i]), 4));
    Write(tounicode, '> <');
    Write(tounicode, IntToHex(Word(pdfFont.UsedAlphabetUnicode[i]), 4));
    Writeln(tounicode, '>');
  end;
  Writeln(tounicode, 'endbfchar');
  Writeln(tounicode, 'endcmap');
  Writeln(tounicode, 'CMapName currentdict /CMap defineresource pop');
  Writeln(tounicode, 'end');
  Writeln(tounicode, 'end');
  tounicode.Position := 0;
  WritePDFStream(pdf, tounicode, toUnicodeId, FCompressed, FProtection,
    True, True, False);
  // CIDSystemInfo
  cIDSystemInfoId := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(cIDSystemInfoId));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Registry (Adobe) /Ordering (Identity) /Supplement 0');
  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');
  // DescendantFonts
  descendantFontId := FPOH.UpdateXRef;
  Writeln(pdf, ObjNumber(descendantFontId));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Type /Font');
  Writeln(pdf, '/Subtype /CIDFontType2');
  Writeln(pdf, '/BaseFont /' + fontName);
  Writeln(pdf, '/CIDToGIDMap /Identity');
  Writeln(pdf, '/CIDSystemInfo ' + ObjNumberRef(cIDSystemInfoId));
  Writeln(pdf, '/FontDescriptor ' + ObjNumberRef(descriptorId));

  Write(pdf, '/W [ ');
  for i := 0 to pdfFont.UsedAlphabet.Count - 1 do
    // ligatures has zero length
    if pdfFont.Widths[i] <> Pointer(-1) then
      Write(pdf, IntToStr(Word(pdfFont.UsedAlphabet[i])) + ' [' + IntToStr(Integer(pdfFont.Widths[i])) + '] ')
    else
      Write(pdf, IntToStr(Word(pdfFont.UsedAlphabet[i])) + ' [0] ');
  Writeln(pdf, ']');
  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');
  // main
  FPOH.XRef[pdfFont.Reference - 1] := PrepXrefPos(pdf.Position);
  Writeln(pdf, ObjNumber(pdfFont.Reference));
  Writeln(pdf, '<<');
  Writeln(pdf, '/Type /Font');
  Writeln(pdf, '/Subtype /Type0');
  Writeln(pdf, '/BaseFont /' + fontName);
  Writeln(pdf, '/Encoding /Identity-H');
  Writeln(pdf, '/DescendantFonts [' + ObjNumberRef(descendantFontId) + ']');
  Writeln(pdf, '/ToUnicode ' + ObjNumberRef(toUnicodeId));
  Writeln(pdf, '>>');
  Writeln(pdf, 'endobj');
end;

procedure TfrxPDFExport.WritePDFStream(Target, Source: TStream;
  id: LongInt; Compressed, Encrypted: Boolean;
  startingBrackets, endingBrackets, enableLength2: Boolean);
const
  CR: Byte = 10;
var
  tempStream: TStream;
begin
  if startingBrackets then
    Write(Target, '<<');
  if enableLength2 then
    Write(Target, '/Length ' + IntToStr(Source.Size));
  if Compressed then
  begin
    tempStream := TMemoryStream.Create;
    frxDeflateStream(Source, tempStream, gzFastest);
    tempStream.Position := 0;
    if enableLength2 then
      Write(Target, '/Length1 ' + IntToStr(tempStream.Size))
    else
      Write(Target, '/Length ' + IntToStr(tempStream.Size));
    Write(Target, '/Filter/FlateDecode');
  end
  else
  begin
    tempStream := Source;
    Write(Target, '/Length ' + IntToStr(tempStream.Size));
  end;
  if endingBrackets then
    Writeln(Target, '>>')
  else
    Writeln(Target, '');
  Writeln(Target, 'stream');
  if Encrypted then
    CryptStream(tempStream, Target, FEncKey, id)
  else
  begin
    Target.CopyFrom(tempStream, tempStream.Size);
  end;
  Target.Write(CR, 1);
  Writeln(Target, 'endstream');
  Writeln(Target, 'endobj');
  Source.Free;
  if Compressed then
    tempStream.Free;
end;

{ TEmbeddedFile }

constructor TEmbeddedFile.Create;
begin
  FModDate := Now;
  FRelation := erAlternative;
  FZUGFeRD_ConformanceLevel := clBASIC;
  FMIME := 'text/xml';
  FFileStream := nil;
end;

initialization
{$WARNINGS OFF}
pdfCS := TCriticalSection.Create;

finalization

pdfCS.Free;
{$WARNINGS ON}

end.
