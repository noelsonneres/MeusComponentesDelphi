
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

unit frxExportPDFHelpers;

interface

{$I frx.inc}

uses
  {$IFDEF Delphi12}pngimage{$ELSE}frxpngimage{$ENDIF},
  Windows, Graphics, Classes, SysUtils, frxRC4, frxTrueTypeCollection,
  frxTrueTypeFont, frxEMFAbstractExport, frxClass, frxEMFFormat, frxUtils, JPEG
{$IFDEF Delphi12}
, AnsiStrings
{$ENDIF}
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  SCRIPT_CACHE = Pointer;
  PScriptCache = ^SCRIPT_CACHE;

  SCRIPT_ANALYSIS = record
     fFlags: Word;
     s: Word
  end;
  PScriptAnalysis = ^SCRIPT_ANALYSIS;

  TfrxPDFRun = class
  public
    analysis: SCRIPT_ANALYSIS;
    text: WideString;
    constructor Create(t: WideString; a: SCRIPT_ANALYSIS);
  end;

  TRemapedString = record
    Data: WideString;
    Width: Integer;
    SpacesCount: Integer;
    IsValidCharWidth: Boolean;
    CharWidth: TIntegerArray;
    IsHasLigatures: Boolean;
  end;

  TfrxPDFFont = class
  private
    tempBitmap: TBitmap;
    FUSCache: PScriptCache;
    TrueTypeTables: TrueTypeCollection;
    FColor: TColor;
    FFontName: AnsiString;
    FSize: Extended;
    FForceAnsi: Boolean;
    function GetGlyphs(hdc: HDC; run: TfrxPDFRun; glyphs: PWord; widths: PInteger; maxGlyphs: integer; rtl: boolean; IsIndexes: Boolean = false): Integer;
    function Itemize(s: WideString; rtl: boolean; maxItems: Integer): TList;
    function Layout(runs: TList; rtl: boolean): TList;
    function GetGlyphIndices(hdc: HDC; text: WideString; glyphs: PWord; widths: PInteger; rtl: boolean; IsIndexes: Boolean = false): integer;
  protected
    Index: Integer;
    ttf:  TrueTypeFont;
    SourceFont: TFont;
    PackFont: Boolean;
    PDFdpi_divider: double;
    FDpiFX: double;
    FIsLigatureless: Boolean;

    procedure FillOutlineTextMetrix;
    procedure Cleanup;
    procedure GetFontFile;
    function RemapString(str: WideString; rtl: Boolean; IsIndexes: Boolean = false): TRemapedString;
  public
    Widths: TList;
    UsedAlphabet: TList;
    UsedAlphabetUnicode: TList;
    TextMetric: ^OUTLINETEXTMETRICA;
    Name: AnsiString;
    Reference: Longint;
    Saved: Boolean;
    FontData: PAnsiChar;
    FontDataSize: Longint;

    constructor Create(Font: TFont);
    destructor Destroy; override;
    procedure PackTTFFont;
    function SoftRemapString(str: WideString; rtl, PdfA: Boolean; IsIndexes: Boolean = false): TRemapedString;
    function GetFontName: AnsiString;
    function SpaceAdjustment(RS: TRemapedString; TextWidth, FontSize: Extended): Extended;

    property FontName: AnsiString read FFontName write FFontName;
    property Size: Extended read FSize write FSize;
    property Color: TColor read FColor write FColor;
    property ForceAnsi: Boolean write FForceAnsi;
  end;

  TfrxPDFXObjectHash = array[0..15] of Byte; // MD5
  TfrxPDFXObject = record
    ObjId: Integer; // id that appears in 'id 0 R'
    Hash: TfrxPDFXObjectHash;
  end;

  TPDFObjectsHelper = class
  private
    FFonts: TList;
    FPageFonts: TList;
    FXRef: TStringList;
    FpdfStream: TStream;
    FProtection: boolean;
    FEncKey: AnsiString;
    FEmbedded: boolean;
    FQuality: Integer;

    FXObjects: array of TfrxPDFXObject;
    FUsedXObjects: array of Integer; // XObjects' ids used within the current page

    function GetFonts(Index: integer): TfrxPDFFont;
    function GetFontsCount: integer;
    function GetPageFonts(Index: integer): TfrxPDFFont;
    function GetPageFontsCount: integer;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetGlobalFont(const Font: TFont): TfrxPDFFont;
    function GetObjFontNumber(const Font: TFont): integer;

    procedure ClearUsedXObjects;
    procedure OutUsedXObjects;
    function FindXObject(const Hash: TfrxPDFXObjectHash): Integer;
    function AddXObject(Id: Integer; const Hash: TfrxPDFXObjectHash): Integer;
    procedure ClearXObject;
    procedure AddUsedObject(Index: integer);
    function GetXObjectsId(Index: integer): Integer;

    function OutXObjectImage(XObjectHash: TfrxPDFXObjectHash;
      Jpg: TJPEGImage; XObjectStream: TStream;
      IsTransparent: Boolean = False; MaskId: Integer = 0): Integer;
    function OutTransparentPNG(PNGA: TPNGObject; Size: TSize): Integer; // map images
    function UpdateXRef: Integer;

    property Fonts[Index: integer]: TfrxPDFFont read GetFonts;
    property FontsCount: integer read GetFontsCount;
    property PageFonts [Index: integer]: TfrxPDFFont read GetPageFonts;
    property PageFontsCount: integer read GetPageFontsCount;
    property pdfStream: TStream write FpdfStream;
    property XRef: TStringList read FXRef;
    property Protection: boolean write FProtection;
    property EncKey: AnsiString write FEncKey;
    property EmbeddedFonts: Boolean read FEmbedded write FEmbedded default False;
    property Quality: Integer write FQuality;
  end;

function IsNeedsItalicSimulation(Font: TFont; out Simulation: String): Boolean;
function IsNeedsBoldSimulation(Font: TFont; out Simulation: String): Boolean;

procedure AddStyleSimulation(FontName: String; FontStyles: TFontStyles);
procedure DeleteStyleSimulation(FontName: String);

procedure AddLigatureless(FontName: String);
procedure DeleteLigatureless(FontName: String);

function StrToHex(const Value: WideString): AnsiString;
function StrToHexSp(const SourceStr, Value: WideString; SpaceAdjustment: Extended): AnsiString;
function StrToHexDx(const RemappedStr: WideString; OutputDx: TLongWordArray;
  DxFactor: Extended; SkipFirstDx: Boolean; CharWidth: TIntegerArray): AnsiString;

function Color2Str(Color: TColor): String;
function frxRect2Str(DR: TfrxRect): String;

function frxPointSum(P1, P2: TfrxPoint): TfrxPoint;
function frxPointMult(P: TfrxPoint; Factor: Extended): TfrxPoint;

procedure GetStreamHash(out Hash: TfrxPDFXObjectHash; S: TStream);
function ObjNumberRef(FNumber: longint): String;
function ObjNumber(FNumber: longint): String;
function PrepXRefPos(Index: Integer): String;
function CryptStream(Source: TStream; Target: TStream; Key: AnsiString; id: Integer): AnsiString;

procedure Write(Stream: TStream; const S: AnsiString);{$IFDEF Delphi12} overload;
procedure Write(Stream: TStream; const S: String); overload; {$ENDIF}
procedure WriteLn(Stream: TStream; const S: AnsiString);{$IFDEF Delphi12} overload;
procedure WriteLn(Stream: TStream; const S: String); overload; {$ENDIF}

type
  TMaskArray = array of byte;
function BitmapPixelSize(Bitmap: TBitmap): Integer;
function CreateBitmap(PixelFormat: TPixelFormat; SizeBitmap: TBitmap): TBitmap; overload;
function CreateBitmap(PixelFormat: TPixelFormat; Width, Height: Integer): TBitmap; overload;
procedure CreateMask(Bitmap: TBitmap; var Mask: TMaskArray);
procedure SaveMask(pdf, XObjectStream: TStream; MaskBytes: TMaskArray;
  FPOH: TPDFObjectsHelper; TempBitmap: TBitmap; FProtection: Boolean; FEncKey: AnsiString;
  out XObjectHash: TfrxPDFXObjectHash; out XMaskId, PicIndex: Integer);

const
  PDF_DIVIDER = 0.75;

type
  TfrxShapeKindSet = set of TfrxShapeKind;

function IsShape(Obj: TfrxView; ShapeKindSet: TfrxShapeKindSet): boolean;
function Is2DShape(Obj: TfrxView): boolean;

type
  TViewSizes = record l, t, w, h, r, b: Extended; end;

function ShadowlessSizes(Obj: TfrxView): TViewSizes;

type
  TRGBAWord = packed record
    Blue: Byte;
    Green: Byte;
    Red: Byte;
    Alpha: Byte;
  end;

  PRGBAWord = ^TRGBAWordArray;
  TRGBAWordArray = array[0..4095] of TRGBAWord;

  TPDFStandard =
    (psNone, psPDFA_1a, psPDFA_1b, psPDFA_2a, psPDFA_2b, psPDFA_3a, psPDFA_3b);
  TPDFVersion =
    (pv14, pv15, pv16, pv17);

const
  PDFStandardName: array[TPDFStandard] of string =
    ('None', 'PDF/A-1a', 'PDF/A-1b', 'PDF/A-2a', 'PDF/A-2b', 'PDF/A-3a', 'PDF/A-3b');
  PDFPartName: array[TPDFStandard] of string =
    (    '',       '1',        '1',         '2',       '2',         '3',       '3');
  PDFConformanceName: array[TPDFStandard] of string =
    (    '',        'A',        'B',         'A',       'B',         'A',       'B');
  PDFVersionName: array[TPDFVersion] of string =
    ('1.4', '1.5', '1.6', '1.7');

function PDFStandardByName(StandardName: string): TPDFStandard;
function PDFVersionByName(VersionName: string): TPDFVersion;
function IsPDFA(ps: TPDFStandard): Boolean;
function IsPDFA_1(ps: TPDFStandard): Boolean;
function IsVersionByStandard(ps: TPDFStandard; var pv: TPDFVersion): Boolean;

implementation

uses
  Contnrs,
  frxCrypto, frxmd5, frxExportHelpers;

type
  SCRIPT_ITEM = record
    iCharPos: Integer;
    a: SCRIPT_ANALYSIS;
  end;
  PScriptItem = ^SCRIPT_ITEM;

  GOFFSET = record
    du:  Longint;
    dv:  Longint;
  end;
  PGOffset = ^GOFFSET;

  SCRIPT_DIGITSUBSTITUTE = record
    NationalDigitLanguage: WORD;
    TraditionalDigitLanguage: WORD;
    DigitSubstitute: DWORD;
    dwReserved: WORD;
  end;
  PSCRIPT_DIGITSUBSTITUTE= ^SCRIPT_DIGITSUBSTITUTE;

  TPDFFontSimulation = class
  private
    FName: String;
    FFontStyles: TFontStyles;
  public
    constructor Create(Name: String; FontStyles: TFontStyles);
    procedure AddStyles(FontStyles: TFontStyles);
    function IsName(Name: String): Boolean;
    function IsStyle(FontStyle: TFontStyle): Boolean;
  end;

  TPDFFontSimulationList = class (TObjectList)
  protected
    procedure DeleteFont(Name: String);
    function Find(Name: String): TPDFFontSimulation;
    function IsNeedsStyle(Name: String; FontStyle: TFontStyle): Boolean;
  public
    procedure AddFont(Name: String; FontStyles: TFontStyles);

    function IsNeedsBold(Name: String): Boolean;
    function IsNeedsItalic(Name: String): Boolean;
  end;

function ScriptFreeCache(psc: PScriptCache): HRESULT; stdcall; external 'usp10.dll' name 'ScriptFreeCache';
function ScriptLayout(cRuns: Integer; const pbLevel: PByte;
    piVisualToLogical: PInteger; piLogicalToVisual: PInteger): HRESULT; stdcall; external 'usp10.dll' name  'ScriptLayout';
function ScriptItemize(const pwcInChars: PWideChar; cInChars: Integer;
    cMaxItems: Integer; const psControl: PInteger; const psState: PWord;
    pItems: PScriptItem; pcItems: PInteger): HRESULT; stdcall; external 'usp10.dll' name 'ScriptItemize';
function ScriptPlace(hdc: HDC; psc: PScriptCache; const pwGlyphs: PWord;
    cGlyphs: Integer; const psva: PWord; psa: PScriptAnalysis;
    piAdvance: PInteger; const pGoffset: PGOffset; pABC: PABC): HRESULT; stdcall; external 'usp10.dll' name 'ScriptPlace';
function ScriptShape(hdc: HDC; psc: PScriptCache; const pwcChars: PWideChar;
    cChars: Integer; cMaxGlyphs: Integer; psa: PScriptAnalysis; pwOutGlyphs: PWord;
    pwLogClust: PWord; psva: PWord; pcGlyphs: PInteger): HRESULT; stdcall; external 'usp10.dll' name 'ScriptShape';
function ScriptApplyDigitSubstitution(psds: PSCRIPT_DIGITSUBSTITUTE; psc: PCardinal;
    pss: PCardinal): HRESULT; stdcall; external 'usp10.dll' name 'ScriptApplyDigitSubstitution';

//function ScriptRecordDigitSubstitution(Locale: Cardinal;
//  psds: PSCRIPT_DIGITSUBSTITUTE): HRESULT; stdcall; external 'usp10.dll' name 'ScriptRecordDigitSubstitution';

// list of fonts that do not have bold-italic versions and needs to be simulated
var
  PDFFontSimulationList: TPDFFontSimulationList;
  PDFFontLigaturelessList: TStringList;

{ Utility routines }

function CreateBitmap(PixelFormat: TPixelFormat; Width, Height: Integer): TBitmap;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := PixelFormat;
  Result.Width := Width;
  Result.Height := Height;
end;

function CreateBitmap(PixelFormat: TPixelFormat; SizeBitmap: TBitmap): TBitmap;
begin
  Result := CreateBitmap(PixelFormat, SizeBitmap.Width, SizeBitmap.Height);
end;

function BitmapPixelSize(Bitmap: TBitmap): Integer;
begin
  Result := Bitmap.Width * Bitmap.Height;
end;

procedure SaveMask(pdf, XObjectStream: TStream; MaskBytes: TMaskArray;
  FPOH: TPDFObjectsHelper; TempBitmap: TBitmap; FProtection: Boolean; FEncKey: AnsiString;
  out XObjectHash: TfrxPDFXObjectHash; out XMaskId, PicIndex: Integer);
var
  MaskIndex, MaskSize: Integer;
  XMaskStream: TStream;
  XMaskHash: TfrxPDFXObjectHash;
begin
  XMaskStream := TMemoryStream.Create;
  try
    XMaskStream.Position := 0;
    MaskSize := BitmapPixelSize(TempBitmap);
    XMaskStream.Write(Pointer(MaskBytes)^, MaskSize);

    XMaskStream.Position := 0;
    GetStreamHash(XMaskHash, XMaskStream);
    MaskIndex := FPOH.FindXObject(XMaskHash);

    if MaskIndex < 0 then
    begin
      XMaskId := FPOH.UpdateXRef;
      FPOH.AddXObject(XMaskId, XMaskHash);
      Writeln(pdf, ObjNumber(XMaskId));

      Writeln(pdf, '<< /Type /XObject');
      Writeln(pdf, '/Subtype /Image');
      Writeln(pdf, '/Width ' + IntToStr(TempBitmap.Width));
      Writeln(pdf, '/Height ' + IntToStr(TempBitmap.Height));
      Writeln(pdf, '/ColorSpace /DeviceGray/Matte[ 0 0 0] ');
      Writeln(pdf, '/BitsPerComponent 8');
      Writeln(pdf, '/Interpolate false');

      /// ///////  NEED TO REPLACE

      Writeln(pdf, ' /Length ' + IntToStr(MaskSize) + ' >>');
      Writeln(pdf, 'stream');
      if FProtection then
        CryptStream(XMaskStream, pdf, FEncKey, XMaskId)
      else
        pdf.CopyFrom(XMaskStream, 0);

      Write(pdf, #13#10'endstream'#13#10);
      Writeln(pdf, 'endobj');
    end
    else
      XMaskId := FPOH.GetXObjectsId(MaskIndex);
    { hash should be calculated for Pic + Mask }
    XMaskStream.Position := XMaskStream.Size;
    XObjectStream.Position := 0;
    XMaskStream.CopyFrom(XObjectStream, 0);
    XMaskStream.Position := 0;
    XObjectStream.Position := 0;
    GetStreamHash(XObjectHash, XMaskStream);
    PicIndex := FPOH.FindXObject(XObjectHash);
  finally
    XMaskStream.Free;
  end;
end;

procedure CreateMask(Bitmap: TBitmap; var Mask: TMaskArray);
var
  Ix, Iy: Integer;
  dots: PRGBAWord;
begin
  SetLength(Mask, BitmapPixelSize(Bitmap));
  for Iy := 0 to Bitmap.Height - 1 do
  begin
    dots := Bitmap.ScanLine[Iy];
    for Ix := 0 to Bitmap.Width - 1 do
      Mask[Ix + Iy * Bitmap.Width] := dots[Ix].Alpha;
  end;
end;

function IsVersionByStandard(ps: TPDFStandard; var pv: TPDFVersion): Boolean;
begin
  Result := True;
  case ps of
    psPDFA_1a, psPDFA_1b:
      pv := pv14;
    psPDFA_2a, psPDFA_2b, psPDFA_3a, psPDFA_3b:
      pv := pv17;
  else
    Result := False;
  end;

end;

function IsPDFA_1(ps: TPDFStandard): Boolean;
begin
  Result := ps in [psPDFA_1a, psPDFA_1b];
end;

function IsPDFA(ps: TPDFStandard): Boolean;
begin
  Result := ps in [psPDFA_1a, psPDFA_1b, psPDFA_2a, psPDFA_2b, psPDFA_3a, psPDFA_3b];
end;

function PDFVersionByName(VersionName: string): TPDFVersion;
var
  pv: TPDFVersion;
begin
  for pv := Low(TPDFVersion) to High(TPDFVersion) do
    if VersionName = PDFVersionName[pv] then
    begin
      Result := pv;
      Exit;
    end;

  raise Exception.Create('Unknown/unsupported PDF version: "' + VersionName +'"');
end;

function PDFStandardByName(StandardName: string): TPDFStandard;
var
  ps: TPDFStandard;
begin
  for ps := Low(TPDFStandard) to High(TPDFStandard) do
    if StandardName = PDFStandardName[ps] then
    begin
      Result := ps;
      Exit;
    end;

  raise Exception.Create('Unknown/unsupported PDF standard: "' + StandardName +'"');
end;

function ShadowlessSizes(Obj: TfrxView): TViewSizes;
begin
  with Result do
  begin
    l := Obj.AbsLeft;
    t := Obj.AbsTop;
    w := Obj.Width - Obj.ShadowSize;
    h := Obj.Height - Obj.ShadowSize;
    r := l + w;
    b := t + h;
  end;
end;

function Is2DShape(Obj: TfrxView): boolean;
begin
  Result := IsShape(Obj,
    [skRectangle, skRoundRectangle, skEllipse, skTriangle, skDiamond]);
end;

function IsShape(Obj: TfrxView; ShapeKindSet: TfrxShapeKindSet): boolean;
begin
  Result := (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape in ShapeKindSet);
end;

procedure Write(Stream: TStream; const S: AnsiString);
begin
  Stream.Write(S[1], Length(S));
end;

procedure WriteLn(Stream: TStream; const S: AnsiString);
begin
  Write(Stream, S + AnsiString(#13#10));
end;

{$IFDEF Delphi12}
procedure WriteLn(Stream: TStream; const S: String);
begin
  WriteLn(Stream, AnsiString(s));
end;

procedure Write(Stream: TStream; const S: String);
begin
  Write(Stream, AnsiString(S));
end;
{$ENDIF}

procedure GetStreamHash(out Hash: TfrxPDFXObjectHash; S: TStream);
var
  H: TCryptoHash;
begin
  H := TCryptoMD5.Create;

  try
    H.Push(S);
    H.GetDigest(Hash[0], SizeOf(Hash));
  finally
    H.Free;
  end;
end;

function ObjNumber(FNumber: longint): String;
begin
  Result := IntToStr(FNumber) + ' 0 obj';
end;

function ObjNumberRef(FNumber: longint): String;
begin
  Result := IntToStr(FNumber) + ' 0 R';
end;

function PrepXRefPos(Index: Integer): String;
begin
  Result := StringOfChar('0',  10 - Length(IntToStr(Index))) + IntToStr(Index)
end;

function CryptStream(Source: TStream; Target: TStream; Key: AnsiString; id: Integer): AnsiString;
var
  s: AnsiString;
  k: array [ 1..21 ] of Byte;
  rc4: TfrxRC4;
  m1, m2: TMemoryStream;
begin
  FillChar(k, 21, 0);
  Move(Key[1], k, 16);
  Move(id, k[17], 3);
  SetLength(s, 16);
  MD5Buf(@k, 21, @s[1]);
  m1 := TMemoryStream.Create;
  m2 := TMemoryStream.Create;
  rc4 := TfrxRC4.Create;
  try
    m1.LoadFromStream(Source);
    m2.SetSize(m1.Size);
    rc4.Start(@s[1], 16);
    rc4.Crypt(m1.Memory, m2.Memory, m1.Size);
    m2.SaveToStream(Target);
  finally
    m1.Free;
    m2.Free;
    rc4.Free;
  end;
end;

procedure AddLigatureless(FontName: String);
begin
  PDFFontLigaturelessList.Add(FontName);
end;

procedure DeleteLigatureless(FontName: String);
var
  Index: Integer;
begin
  if PDFFontLigaturelessList.Find(FontName, Index) then
    PDFFontLigaturelessList.Delete(Index);
end;

function IsLigatureless(FontName: String): Boolean;
var
  Index: Integer;
begin
  Result := PDFFontLigaturelessList.Find(FontName, Index);
end;

procedure AddStyleSimulation(FontName: String; FontStyles: TFontStyles);
begin
  PDFFontSimulationList.AddFont(FontName, FontStyles);
end;

function SimulationlessStyle(Font: TFont): TFontStyles;
var
  Simulation: String;
begin
  Result := Font.Style;
  if IsNeedsItalicSimulation(Font, Simulation) then
    Exclude(Result, fsItalic);
  if IsNeedsBoldSimulation(Font, Simulation) then
    Exclude(Result, fsBold);
end;

procedure DeleteStyleSimulation(FontName: String);
begin
  PDFFontSimulationList.DeleteFont(FontName);
end;

function IsNeedsBoldSimulation(Font: TFont; out Simulation: String): Boolean;
begin
  Result := (fsBold in Font.Style) and
    PDFFontSimulationList.IsNeedsBold(Font.Name);

  if Result then
    Simulation := '2 Tr ' + frFloat2Str(Font.Size / 35.0) + ' w ' +
      Color2Str(Font.Color) + ' RG';
end;

function IsNeedsItalicSimulation(Font: TFont; out Simulation: String): Boolean;
begin
  Result := (fsItalic in Font.Style) and
    PDFFontSimulationList.IsNeedsItalic(Font.Name);

  if Result then
    Simulation := '1 0 0.25 1';
end;

function Color2Str(Color: TColor): String;
var
  RGB: LongInt;
begin
  if Color = clNone then
    Result:= '0 0 0'
  else
  begin
    RGB := ColorToRGB(Color);
    Result:= Float2Str(GetRValue(RGB) / 255) + ' ' +
             Float2Str(GetGValue(RGB) / 255) + ' ' +
             Float2Str(GetBValue(RGB) / 255);
  end;
end;

function frxRect2Str(DR: TfrxRect): String;
begin   // x  y  width  height, with lower-left corner (x, y)
  Result := Float2Str(DR.Left) + ' ' + Float2Str(DR.Bottom) + ' ' +
    Float2Str(DR.Right - DR.Left) + ' ' + Float2Str(DR.Top - DR.Bottom);
end;

function frxPointSum(P1, P2: TfrxPoint): TfrxPoint;
begin
  Result := frxPoint(P1.X + P2.X, P1.Y + P2.Y);
end;

function frxPointMult(P: TfrxPoint; Factor: Extended): TfrxPoint;
begin
  Result := frxPoint(Factor * P.X, Factor * P.Y);
end;

function StrToHex(const Value: WideString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Value) do
    Result := Result  + AnsiString(IntToHex(Word(Value[i]), 4));
end;

function StrToHexDx(const RemappedStr: WideString; OutputDx: TLongWordArray;
  DxFactor: Extended; SkipFirstDx: Boolean; CharWidth: TIntegerArray): AnsiString;
var
  i: Integer;
  Dx: AnsiString;
  pdfDx: array of Extended;
  SkipCurrent: Boolean;
begin
  SetLength(pdfDx, Length(OutputDx));
  for i := 0 to High(OutputDx) do
    pdfDx[i] := LongInt(OutputDx[i]) * DxFactor;

  Result := '';
  for i := 1 to Length(RemappedStr) do
  begin
    Dx := AnsiString(IntToStr(Round(CharWidth[i - 1] - pdfDx[i - 1])));
    SkipCurrent := (i = 1) and SkipFirstDx or (Dx = '0');
    if not SkipCurrent then
      Result := Result + '>' + Dx + '<';
    Result := Result + AnsiString(IntToHex(Word(RemappedStr[i]), 4));
  end;
end;

function StrToHexSp(const SourceStr, Value: WideString; SpaceAdjustment: Extended): AnsiString;
var
  i: integer;
  w: Integer;
  z: Extended;
begin
  result := '';
  z := 0;
  w := Trunc(SpaceAdjustment);
  for i := 1 to Length(Value) do
  begin
    result := result + AnsiString(IntToHex(Word(Value[i]), 4));
    if SourceStr[i] = ' ' then
    begin
      z := z + Frac(SpaceAdjustment);
      if w + Trunc(z) <> 0 then
        result := result + AnsiString('>' + IntToStr(w + Trunc(z)) + '<');
      z := Frac(z);
    end;
  end;
end;

{ TfrxPDFFont }

procedure TfrxPDFFont.Cleanup;
begin
  tempBitmap.Free;
  Widths.Clear;
  UsedAlphabet.Clear;
  UsedAlphabetUnicode.Clear;
  if FontDataSize > 0 then
  begin
    FreeMemory(FontData);
    FontDataSize := 0;
    FontData := nil;
  end;
  if TextMetric <> nil then
  begin
    FreeMemory(TextMetric);
    TextMetric := nil;
  end;
end;

constructor TfrxPDFFont.Create(Font: TFont);
var
  dpi: integer;
begin
  SourceFont := TFont.Create;
  dpi := SourceFont.PixelsPerInch;
  SourceFont.Assign(Font);
  FDpiFX := 96 / dpi;
  PDFdpi_divider := 1 / (750 * FDpiFX);
  SourceFont.Size := Round(750 * FDpiFX);
  tempBitmap := TBitmap.Create;
  Widths := TList.Create;
  UsedAlphabet := TList.Create;
  UsedAlphabetUnicode := TList.Create;
  Saved := false;
  PackFont := true;
  FontData := nil;
  FontDataSize := 0;
  TextMetric := nil;
  FUSCache := nil;
  TrueTypeTables := nil;
  FForceAnsi := False;
end;

destructor TfrxPDFFont.Destroy;
begin
  Cleanup;
  TrueTypeTables.Free;
  SourceFont.Free;
  Widths.Free;
  UsedAlphabet.Free;
  UsedAlphabetUnicode.Free;
  ScriptFreeCache(@FUSCache);
  inherited;
end;

procedure TfrxPDFFont.FillOutlineTextMetrix;
var
  i: Cardinal;
begin
  tempBitmap.Canvas.Lock;
  try
    tempBitmap.Canvas.Font.Assign(SourceFont);
    i := GetOutlineTextMetrics(tempBitmap.Canvas.Handle, 0, nil);
    if i = 0 then
    begin
      tempBitmap.Canvas.Font.Name := 'Arial';
      i := GetOutlineTextMetrics(tempBitmap.Canvas.Handle, 0, nil);
    end;
    if i <> 0 then
    begin
      TextMetric := GetMemory(i);
      if TextMetric <> nil then
        GetOutlineTextMetricsA(tempBitmap.Canvas.Handle, i, TextMetric);
    end;
  finally
    tempBitmap.Canvas.Unlock;
  end;
end;

procedure TfrxPDFFont.GetFontFile;
var
  CollectionMode:   Cardinal;
begin
{$IFDEF DEBUG_WITH_FASTMM}
{$define FullDebugMode}
  ShowFastMMUsageTracker;
{$ENDIF}

  if ttf <> nil then Exit;

  tempBitmap.Canvas.Lock;
  try
    tempBitmap.Canvas.Font.Assign(SourceFont);
    CollectionMode := $66637474;
    if Assigned(FontData) then
      if FontDataSize > 0 then
      begin
        FreeMemory(FontData);
        FontDataSize := 0;
        FontData := nil;
      end;
    FontDataSize := GetFontData(tempBitmap.Canvas.Handle, CollectionMode, 0, nil, 1);
    //if FontDataSize > 0 then
    begin
      if Cardinal(FontDataSize) = High(Cardinal) then
      begin
         CollectionMode := 0;
         FontDataSize := GetFontData(tempBitmap.Canvas.Handle, CollectionMode, 0, nil, 1);
      end;
      FontData := GetMemory(FontDataSize);
      if FontData <> nil then
      begin
        GetFontData(tempBitmap.Canvas.Handle, CollectionMode, 0, FontData, FontDataSize);
        if Self.PackFont then
        begin
          FreeAndNil(Self.TrueTypeTables);
          Self.TrueTypeTables := TrueTypeCollection.Create();
          Self.TrueTypeTables.Initialize( FontData, FontDataSize );
          ttf := Self.TrueTypeTables.LoadFont( Self.SourceFont );
        end;
      end
      else
        FontDataSize := 0;
    end;
  finally
    tempBitmap.Canvas.Unlock;
  end;
end;

function TfrxPDFFont.GetFontName: AnsiString;
var
  s: AnsiString;

  function HexEncode7F(Str: AnsiString): AnsiString;
  var
    AnStr: AnsiString;
    s: AnsiString;
    Index, Len: Integer;
  begin
    s := '';
    AnStr := AnsiString(Str);
    Len := Length(AnStr);
    Index := 0;
    while Index < Len do
    begin
      Index := Index + 1;
      if Byte(AnStr[Index]) > $7F then
        s := s + '#' + AnsiString(IntToHex(Byte(AnStr[Index]), 2))
      else
        s := s + AnsiString(AnStr[Index]);
    end;
    Result := s;
  end;

begin
{$IFDEF Delphi12}
  Result := UTF8Encode(SourceFont.Name);
  if (ttf <> nil) and (ttf.SubstitutionName <> '') and
     (ttf.FamilyName <> '') and (Pos('?', ttf.FamilyName) = 0) then
    Result :=  UTF8Encode(ttf.FamilyName);
  Result := StringReplace(Result, AnsiString(' '), AnsiString('#20'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString('('), AnsiString('#28'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString(')'), AnsiString('#29'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString('%'), AnsiString('#25'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString('<'), AnsiString('#3C'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString('>'), AnsiString('#3E'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString('['), AnsiString('#5B'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString(']'), AnsiString('#5D'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString('{'), AnsiString('#7B'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString('}'), AnsiString('#7D'), [rfReplaceAll]);
  Result := StringReplace(Result, AnsiString('/'), AnsiString('#2F'), [rfReplaceAll]);
{$ELSE}
  Result := SourceFont.Name;
  Result := StringReplace(Result, ' ', '#20', [rfReplaceAll]);
  Result := StringReplace(Result, '(', '#28', [rfReplaceAll]);
  Result := StringReplace(Result, ')', '#29', [rfReplaceAll]);
  Result := StringReplace(Result, '%', '#25', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '#3C', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '#3E', [rfReplaceAll]);
  Result := StringReplace(Result, '[', '#5B', [rfReplaceAll]);
  Result := StringReplace(Result, ']', '#5D', [rfReplaceAll]);
  Result := StringReplace(Result, '{', '#7B', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '#7D', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '#2F', [rfReplaceAll]);
{$ENDIF}
  s := '';
  if (fsBold in SourceFont.Style) and
    not PDFFontSimulationList.IsNeedsBold(SourceFont.Name) then
    s := s + 'Bold';
  if (fsItalic in SourceFont.Style) and
    not PDFFontSimulationList.IsNeedsItalic(SourceFont.Name) then
    s := s + 'Italic';
  if s <> '' then
    Result := Result + ',' + s;
{$IFDEF Delphi12}
  Result := HexEncode7F(Result);
{$ELSE}
  Result := HexEncode7F(Result);
{$ENDIF}
end;

function TfrxPDFFont.GetGlyphIndices(hdc: HDC; text: WideString; glyphs: PWord; widths: PInteger; rtl: boolean; IsIndexes: Boolean): integer;
var
  maxGlyphs: Integer;
  maxItems: Integer;
  runs: TList;
  i, j, len: Integer;
  tempGlyphs, g1, g2: PWord;
  tempWidths, w1, w2: PInteger;
  run: TfrxPDFRun;
  a: SCRIPT_ANALYSIS;
begin
  if text = '' then
    result := 0
  else
  begin
    maxGlyphs := Length(text) * 3;
    maxItems := Length(text) * 2;
    if not IsIndexes then
    begin
      runs := Itemize(text, rtl, maxItems);
      runs := Layout(runs, rtl);
    end
    else
    begin
      runs := TList.Create;
      ZeroMemory(@a, sizeof(SCRIPT_ANALYSIS));
      a.fFlags := 31;
      run := TfrxPDFRun.Create(text, a);
      runs.Add(run);
    end;
    result := 0;
    g2 := glyphs;
    w2 := widths;
    tempGlyphs := GetMemory(SizeOf(Word) * maxGlyphs);
    tempWidths := GetMemory(SizeOf(Integer) * maxGlyphs);
    try
      for i := 0 to runs.Count - 1 do
      begin
        run := TfrxPDFRun(runs[i]);
        len := GetGlyphs(hdc, run, tempGlyphs, tempWidths, maxGlyphs, rtl, IsIndexes);
        g1 := tempGlyphs;
        w1 := tempWidths;
        for j := 1 to len do
        begin
          g2^ := g1^;
          w2^ := w1^;
          Inc(g1);
          Inc(g2);
          Inc(w1);
          Inc(w2);
        end;
        Inc(result, len);
        run.Free;
      end;
    finally
      FreeMemory(tempGlyphs);
      FreeMemory(tempWidths);
    end;
    runs.Free;
  end;
end;

function TfrxPDFFont.GetGlyphs(hdc: HDC; run: TfrxPDFRun; glyphs: PWord; widths: PInteger; maxGlyphs: integer; rtl: boolean; IsIndexes: Boolean): Integer;
var
  psa: SCRIPT_ANALYSIS;
  pwLogClust: PWord;
  pcGlyphs, i: Integer;
  psva, lpsva, glyphsTmp: PWord;
  pGoffset_, pCurGoffset: PGOffset;
  pABC_: PABC;
  awidths, PrevWidth: PInteger;
begin
  psa := run.analysis;
  pcGlyphs := 0;
  pwLogClust := GetMemory(SizeOf(Word) * maxGlyphs);
  psva := GetMemory(SizeOf(Word) * maxGlyphs);
  ZeroMemory(psva, SizeOf(Word) * maxGlyphs);
  pGoffset_ := GetMemory(SizeOf(GOffset) * maxGlyphs);
  pABC_ := GetMemory(SizeOf(ABC) * maxGlyphs);
  psa := run.analysis;
  try
    if not IsIndexes then
      ScriptShape(hdc, @FUSCache, PWideChar(run.text), Length(run.text), maxGlyphs, @psa, glyphs, pwLogClust, psva, @pcGlyphs)
    else
    begin
      pcGlyphs := Length(run.text);
      glyphsTmp := glyphs;
      for i := 0 to pcGlyphs - 1 do
      begin
        glyphsTmp^ := Word(run.text[i + 1]);
        Inc(glyphsTmp);
      end;
    end;
    ScriptPlace(hdc, @FUSCache, glyphs, pcGlyphs, psva, @psa, widths, pGoffset_, pABC_);
    awidths := widths;
    PrevWidth := awidths;
    pCurGoffset := pGoffset_;
    lpsva := psva;
    { uniscribe already returns correct widths , but i'm not sure about different fonts }
    { so just in case we are trying to correct them }
    { remove after testing }
    for i := 0 to pcGlyphs - 1 do
    begin
      if (pCurGoffset^.du > 0) and (i > 0) or (lpsva^ and 32 = 32) then
      begin
        if PrevWidth^ < pCurGoffset^.du + awidths^ then
          PrevWidth^ := pCurGoffset^.du + awidths^;
        awidths^ := -1;// mark ligature to use later
      end;
      PrevWidth := awidths;
      Inc(awidths);
      Inc(lpsva);
      inc(pCurGoffset);
    end;

  finally
    FreeMemory(pwLogClust);
    FreeMemory(psva);
    FreeMemory(pGoffset_);
    FreeMemory(pABC_);
  end;
  Result := pcGlyphs;
end;

function TfrxPDFFont.Itemize(s: WideString; rtl: boolean; maxItems: Integer): TList;
var
  pItems, pItems_: PScriptItem;
  pcItems: Integer;
  control: Integer;
  state: Word;
  i: Integer;
  text: WideString;
  p1, p2: Integer;
  run: TfrxPDFRun;
  a: SCRIPT_ANALYSIS;
begin
  pItems := GetMemory(SizeOf(SCRIPT_ITEM) * maxItems);
  try
    pcItems := 0;
    if rtl then
      state := 1
    else
      state := 0;
    control := 0;
    if rtl then
      ScriptApplyDigitSubstitution(nil, @control, @state);
    ScriptItemize(PWideChar(s), Length(s), maxItems, @control, @state, pItems, @pcItems);
    result := TList.Create;
    pItems_ := pItems;
    for i := 0 to pcItems - 1 do
    begin
      p1 := pItems_^.iCharPos;
      a := pItems_^.a;
      Inc(pItems_);
      p2 := pItems_^.iCharPos;
      text := Copy(s, p1 + 1, p2 - p1);
      run := TfrxPDFRun.Create(text, a);
      result.Add(run);
    end;
  finally
    FreeMemory(pItems);
  end;
end;

function TfrxPDFFont.Layout(runs: TList; rtl: boolean): TList;
var
  pbLevel, p1: PByte;
  piVisualToLogical, piVT: PInteger;
  i: Integer;
  run: TfrxPDFRun;
begin
  pbLevel := GetMemory(runs.Count);
  piVT := GetMemory(SizeOf(Integer) * runs.Count);
  try
    p1 := pbLevel;
    for i := 0 to runs.Count - 1 do
    begin
      p1^ := byte(TfrxPDFRun(runs[i]).analysis.s and $1F);
      Inc(p1);
    end;
    ScriptLayout(runs.Count, pbLevel, piVT, nil);
    result := TList.Create;
    piVisualToLogical := piVT;
    for i := 0 to runs.Count - 1 do
    begin
      run := TfrxPDFRun(runs[piVisualToLogical^]);
      result.Add(run);
      Inc(piVisualToLogical);
    end;
  finally
    FreeMemory(pbLevel);
    FreeMemory(piVT);
    runs.Free;
  end;
end;

procedure TfrxPDFFont.PackTTFFont;
var
  i, j: Integer;
  packed_font: frxTrueTypeFont.TByteArray;
begin
  packed_font := nil;
  if (ttf <> nil) and Self.PackFont then
  begin
    packed_font := Self.TrueTypeTables.PackFont( ttf {Self.SourceFont}, Self.UsedAlphabet );
    if packed_font <> nil then
    begin
      FontDataSize := Length(packed_font);
      CopyMemory( FontData, packed_font, FontDataSize);
      for i := 0 to UsedAlphabet.Count - 1 do
        if (Word(UsedAlphabetUnicode[i]) <> $20) and
           (Word(UsedAlphabetUnicode[i]) <> $A0) then
        begin
          j := Integer(UsedAlphabet[i]);
          try
            { dont use values from table for ligatures }
            if Widths[i] <> Pointer(-1) then
            begin
              j := ttf.Width[j];
              Widths[i] := Pointer(j)
            end;
          except
            Widths[i] := Pointer(0);
          end;
        end;
    end;
  end;
end;

function TfrxPDFFont.RemapString(str: WideString; rtl: Boolean; IsIndexes: Boolean = false): TRemapedString;

  function ToWord(WCh: WideChar): Word;
  begin
    Result := Word(WCh);
    if FForceAnsi then
      Result := Result and $FF;
  end;
var
  maxGlyphs: Integer;
  g, g_: PWord;
  w, w_: PInteger;
  actualLength: Integer;
  i, j: Integer;
  c: Word;
  wc: WideChar;
begin
  Result.Width := 0;
  Result.SpacesCount := 0;
  Result.IsValidCharWidth := True;
  Result.Data := '';

  maxGlyphs := Length(str) * 3;
  g := GetMemory(SizeOf(Word) * maxGlyphs);
  w := GetMemory(SizeOf(Integer) * maxGlyphs);
  tempBitmap.Canvas.Lock;
  try
    tempBitmap.Canvas.Font.Assign(SourceFont);
    actualLength := GetGlyphIndices(tempBitmap.Canvas.Handle, str, g, w, rtl, IsIndexes);
    Result.IsHasLigatures := actualLength < Length(str);
    if FIsLigatureless and Result.IsHasLigatures then
      Exit;
    SetLength(Result.CharWidth, actualLength);

    g_ := g;
    w_ := w;
    for i := 0 to  actualLength - 1 do
    begin
      if rtl then
        j := actualLength - i
      else
        j := i + 1;
      Result.CharWidth[j - 1] := w_^;
      Result.IsValidCharWidth := Result.IsValidCharWidth and (w_^ < $ffff);
      c := g_^;
      { skip ligature }
      if w_^ <> -1 then
        Inc(Result.Width, w_^);
      if actualLength = Length(str) then
        if str[j] = ' ' then
          Inc(Result.SpacesCount);

      if c = 667 then
        continue; { Arial Unicode $1f charcode }

      if UsedAlphabet.IndexOf(Pointer(c)) = -1 then
      begin
        UsedAlphabet.Add(Pointer(c));
        Widths.Add(Pointer(w_^));
        if actualLength = Length(str) then
          UsedAlphabetUnicode.Add(Pointer(ToWord(str[j])))
        else
          UsedAlphabetUnicode.Add(Pointer(TextMetric^.otmTextMetrics.tmDefaultChar));
      end;
      wc := WideChar(c);
      Result.Data := Result.Data + wc;
      Inc(g_);
      Inc(w_);
    end;

  GetFontFile;
  finally
    FreeMemory(g);
    FreeMemory(w);
    tempBitmap.Canvas.Unlock;
  end;
end;

function TfrxPDFFont.SoftRemapString(str: WideString; rtl, PdfA: Boolean; IsIndexes: Boolean = false): TRemapedString;
var
  i: Integer;
  TotalData: WideString;
  TotalCharWidth: TIntegerArray;
begin
  Result.Data := '';
  if str = '' then
    Exit;

  if PdfA and (Pos('Arial', SourceFont.Name) > 0) then // Calc valid char width
    for i := 1 to Length(str) do
      RemapString(str[i], rtl, False);

  FIsLigatureless := IsLigatureless(SourceFont.Name);
  Result := RemapString(str, rtl, IsIndexes);
  if FIsLigatureless and Result.IsHasLigatures then
  begin
    SetLength(TotalData, Length(str));
    SetLength(TotalCharWidth, Length(str));
    for i := 1 to Length(str) do
    begin
      Result := RemapString(str[i], rtl, IsIndexes);
      TotalData[i] := Result.Data[1];
      TotalCharWidth[i - 1] := Result.CharWidth[0];
    end;
    Result.Width := 0;
    for i := 1 to Length(str) do
      Result.Width := Result.Width + TotalCharWidth[i - 1];
    Result.Data := TotalData;
    Result.CharWidth := TotalCharWidth;
  end
end;

function TfrxPDFFont.SpaceAdjustment(RS: TRemapedString; TextWidth, FontSize: Extended): Extended;
var
  TotalAjustment: Extended;
begin
  TotalAjustment := RS.Width;
  if FontSize <> 0 then
    TotalAjustment := TotalAjustment - TextWidth * 1000 / FontSize;

  Result := TotalAjustment / RS.SpacesCount;
end;

{ TfrxPDFRun }

constructor TfrxPDFRun.Create(t: WideString; a: SCRIPT_ANALYSIS);
begin
  text := t;
  analysis := a;
end;

{ TPDFObjectsHelper }

procedure TPDFObjectsHelper.AddUsedObject(Index: integer);
begin
  SetLength(FUsedXObjects, Length(FUsedXObjects) + 1);
  FUsedXObjects[High(FUsedXObjects)] := Index;
end;

function TPDFObjectsHelper.AddXObject(Id: Integer; const Hash: TfrxPDFXObjectHash): Integer;
var
  X: TfrxPDFXObject;
begin
  X.ObjId := Id;
  Move(Hash, X.Hash, SizeOf(Hash));
  SetLength(FXObjects, Length(FXObjects) + 1);
  FXObjects[High(FXObjects)] := X;
  Result := High(FXObjects);
end;

procedure TPDFObjectsHelper.Clear;
var
  i: Integer;
begin
  for i := 0 to FFonts.Count - 1 do
    Fonts[i].Free;

  FFonts.Clear;
  FPageFonts.Clear;
  FXRef.Clear;
end;

procedure TPDFObjectsHelper.ClearUsedXObjects;
begin
  SetLength(FUsedXObjects, 0);
end;

procedure TPDFObjectsHelper.ClearXObject;
var
  i:  Integer;
begin
  for i := 0 to High(FXObjects) do
  begin
    FXObjects[i].ObjId := 0;
    FillChar( FXObjects[i].Hash, Sizeof(TfrxPDFXObjectHash), 0);
  end;
end;

constructor TPDFObjectsHelper.Create;
begin
  FFonts := TList.Create;
  FPageFonts := TList.Create;
  FXRef := TStringList.Create;

  Protection := False;
  EmbeddedFonts := False;
  EncKey := '';
end;

destructor TPDFObjectsHelper.Destroy;
begin
  Clear;
  FFonts.Free;
  FPageFonts.Free;
  FXRef.Free;
  inherited;
end;

function TPDFObjectsHelper.FindXObject(const Hash: TfrxPDFXObjectHash): Integer;
begin
  for Result := 0 to High(FXObjects) do
    if CompareMem(@Hash, @FXObjects[Result].Hash, SizeOf(Hash)) then
      Exit;

  Result := -1;
end;

function TPDFObjectsHelper.GetFonts(Index: integer): TfrxPDFFont;
begin
  Result := TfrxPDFFont(FFonts[Index]);
end;

function TPDFObjectsHelper.GetFontsCount: integer;
begin
  Result := FFonts.Count;
end;

function TPDFObjectsHelper.GetGlobalFont(const Font: TFont): TfrxPDFFont;
var
  i: Integer;
  Font2: TFont;
begin
  i := 0;
  while i < FFonts.Count do
  begin
    Font2 := Fonts[i].SourceFont;
    if (Font.Name = Font2.Name) and (Font.Style = Font2.Style) then
      break;
    Inc(i)
  end;
  if i < FFonts.Count then
    result := Fonts[i]
  else
  begin
    result := TfrxPDFFont.Create(Font);
    result.FillOutlineTextMetrix();
    FFonts.Add(result);

    result.Name := AnsiString('/F' + IntToStr(FFonts.Count - 1));
  end;
end;

function TPDFObjectsHelper.GetObjFontNumber(const Font: TFont): integer;
  var
    i: Integer;
    Font2: TFont;
    OldStyle, NewStyle: TFontStyles;
  begin
    NewStyle := SimulationlessStyle(Font);
    i := 0;
    while i < FPageFonts.Count do
    begin
      Font2 := PageFonts[i].SourceFont;
      if (Font.Name = Font2.Name) and (NewStyle = Font2.Style) then
        break;
      Inc(i);
    end;
    if i < FPageFonts.Count then
      result := i
    else
    begin
      OldStyle := Font.Style;
      Font.Style := NewStyle;
      FPageFonts.Add(GetGlobalFont(Font));
      Font.Style := OldStyle;
      result := FPageFonts.Count - 1;
    end;
end;

function TPDFObjectsHelper.GetPageFonts(Index: integer): TfrxPDFFont;
begin
  Result := TfrxPDFFont(FPageFonts[Index]);
end;

function TPDFObjectsHelper.GetPageFontsCount: integer;
begin
  Result := FPageFonts.Count;
end;

function TPDFObjectsHelper.GetXObjectsId(Index: integer): Integer;
begin
  Result := FXObjects[Index].ObjId;
end;

function TPDFObjectsHelper.OutTransparentPNG(PNGA: TPNGObject; Size: TSize): Integer;
var
  TempBitmap: TBitmap;
  TBRect: TRect;
  XMaskId:    Integer;
  MaskBytes: TMaskArray;
  Jpg: TJPEGImage;
  XObjectStream: TStream;
  XObjectHash: TfrxPDFXObjectHash;
  PicIndex: Integer;
begin
  TempBitmap := CreateBitmap(pf32bit, Size.cx, Size.cy);
  try
    TBRect := Rect(0, 0, TempBitmap.Width, TempBitmap.Height);

    TempBitmap.Canvas.Lock;
    try
      TempBitmap.Canvas.FillRect(TBRect); // Any Brush.Color
      TempBitmap.Canvas.StretchDraw(TBRect, PNGA);
    finally
      TempBitmap.Canvas.Unlock;
    end;

    CreateMask(TempBitmap, MaskBytes);

    { Write XObject with a picture inside }
    Jpg := TJPEGImage.Create;
    try
      Jpg.PixelFormat := jf24Bit;
      Jpg.CompressionQuality := FQuality;

      Jpg.Assign(TempBitmap);
      XObjectStream := TMemoryStream.Create;
      try
        Jpg.SaveToStream(XObjectStream);
        SaveMask(FpdfStream, XObjectStream, MaskBytes,
                 Self, TempBitmap, FProtection, FEncKey,
                 XObjectHash, XMaskId, PicIndex);
        if PicIndex = -1 then
          PicIndex := OutXObjectImage(XObjectHash, Jpg, XObjectStream, True, XMaskId);
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

  Result := PicIndex;
end;

procedure TPDFObjectsHelper.OutUsedXObjects;
var
  i: integer;
begin
  if Length(FUsedXObjects) > 0 then
  begin
    Write(FpdfStream, '/XObject << ');

    for i := 0 to High(FUsedXObjects) do
    begin
      Write(FpdfStream, '/Im' + IntToStr(FUsedXObjects[i]) + ' ');
      Write(FpdfStream, ObjNumberRef(FXObjects[FUsedXObjects[i]].ObjId) + ' ');
    end;

    Writeln(FpdfStream, '>>');
  end;

end;

function TPDFObjectsHelper.OutXObjectImage(XObjectHash: TfrxPDFXObjectHash;
  Jpg: TJPEGImage; XObjectStream: TStream;
  IsTransparent: Boolean = False; MaskId: Integer = 0): Integer;
var
  XObjectId: Integer;
begin
  XObjectId := UpdateXRef;
  Result := AddXObject(XObjectId, XObjectHash);

  Writeln(FpdfStream, ObjNumber(XObjectId));
  Writeln(FpdfStream, '<<');
  Writeln(FpdfStream, '/Type /XObject');
  Writeln(FpdfStream, '/Subtype /Image');
  Writeln(FpdfStream, '/ColorSpace /DeviceRGB');
  Writeln(FpdfStream, '/BitsPerComponent 8');
  Writeln(FpdfStream, '/Filter /DCTDecode');
  Writeln(FpdfStream, '/Width ' + IntToStr(Jpg.Width));
  Writeln(FpdfStream, '/Height ' + IntToStr(Jpg.Height));

  if IsTransparent then
     WriteLn(FpdfStream, '/SMask ' + ObjNumberRef(MaskId));

  ///// NEED TO REPLACE

  Writeln(FpdfStream, '/Length ' + IntToStr(XObjectStream.Size));
  Writeln(FpdfStream, '>>');

  WriteLn(FpdfStream, 'stream'); // 'stream'#10 is also valid
  XObjectStream.Position := 0;
  if FProtection then
    CryptStream(XObjectStream, FpdfStream, FEncKey, XObjectId)
  else
    FpdfStream.CopyFrom(XObjectStream, 0);
  WriteLn(FpdfStream, '');
  WriteLn(FpdfStream, 'endstream');
  WriteLn(FpdfStream, 'endobj');
end;

function TPDFObjectsHelper.UpdateXRef: Integer;
begin
  FXRef.Add(PrepXrefPos(FpdfStream.Position));
  Result := FXRef.Count;
end;

{ TPDFFontSimulation }

procedure TPDFFontSimulation.AddStyles(FontStyles: TFontStyles);
begin
  FFontStyles := FFontStyles + FontStyles;
end;

constructor TPDFFontSimulation.Create(Name: String; FontStyles: TFontStyles);
begin
  FName := Name;
  FFontStyles := FontStyles;
end;

function TPDFFontSimulation.IsName(Name: String): Boolean;
begin
  Result := FName = Name;
end;

function TPDFFontSimulation.IsStyle(FontStyle: TFontStyle): Boolean;
begin
  Result := FFontStyles * [FontStyle] <> [];
end;

{ TPDFFontSimulationList }

procedure TPDFFontSimulationList.AddFont(Name: String; FontStyles: TFontStyles);
var
  PDFFontSimulation: TPDFFontSimulation;
begin
  if FontStyles <> [] then
  begin
    PDFFontSimulation := Find(Name);
    if PDFFontSimulation <> nil then
      PDFFontSimulation.AddStyles(FontStyles)
    else
      Add(TPDFFontSimulation.Create(Name, FontStyles));
  end;
end;

procedure TPDFFontSimulationList.DeleteFont(Name: String);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if TPDFFontSimulation(Items[i]).IsName(Name) then
    begin
      Delete(i);
      Break;
    end;
end;

function TPDFFontSimulationList.Find(Name: String): TPDFFontSimulation;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if TPDFFontSimulation(Items[i]).IsName(Name) then
    begin
      Result := TPDFFontSimulation(Items[i]);
      Break;
    end;
end;

function TPDFFontSimulationList.IsNeedsBold(Name: String): Boolean;
begin
  Result := IsNeedsStyle(Name, fsBold);
end;

function TPDFFontSimulationList.IsNeedsItalic(Name: String): Boolean;
begin
  Result := IsNeedsStyle(Name, fsItalic);
end;

function TPDFFontSimulationList.IsNeedsStyle(Name: String; FontStyle: TFontStyle): Boolean;
var
  PDFFontSimulation: TPDFFontSimulation;
begin
  PDFFontSimulation := Find(Name);
  Result := (PDFFontSimulation <> nil) and PDFFontSimulation.IsStyle(FontStyle);
end;

initialization

  PDFFontSimulationList := TPDFFontSimulationList.Create;
  AddStyleSimulation(#$FF2D#$FF33#$0020#$30B4#$30B7#$30C3#$30AF, [fsBold, fsItalic]);
  AddStyleSimulation(#$FF2D#$FF33#$0020#$FF30#$30B4#$30B7#$30C3#$30AF, [fsBold, fsItalic]);
  AddStyleSimulation(#$FF2D#$FF33#$0020#$660E#$671D, [fsBold, fsItalic]);
  AddStyleSimulation(#$FF2D#$FF33#$0020#$FF30#$660E#$671D, [fsBold, fsItalic]);
  AddStyleSimulation('MS UI Gothic', [fsBold, fsItalic]);
  AddStyleSimulation('Arial Black', [fsBold, fsItalic]);
  AddStyleSimulation('Tahoma', [fsItalic]);

  PDFFontLigaturelessList := TStringList.Create;
  PDFFontLigaturelessList.CaseSensitive := False;
  PDFFontLigaturelessList.Duplicates := dupIgnore;
  PDFFontLigaturelessList.Sorted := True;
  AddLigatureless('Calibri');
  AddLigatureless('Calibri Light');
  AddLigatureless('CADiagram');
  AddLigatureless('Carlito');
  AddLigatureless('EmojiOne Color');
  AddLigatureless('Gabriola');
  AddLigatureless('OpenSymbol');
  AddLigatureless('Segoe Script');
  AddLigatureless('ZWAdobeF');
finalization

  PDFFontSimulationList.Free;

  PDFFontLigaturelessList.Free;

end.

