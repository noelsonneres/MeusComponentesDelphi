
{******************************************}
{                                          }
{             FastReport v5.0              }
{             PDF file library             }
{                                          }
{         Copyright (c) 1998-2014          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{******************************************}
{          Add CJK Font support by         }
{          crispin2k@hotmail.com           }
{          http://www.jane.com.tw          }
{******************************************}

unit frxPDFFile;

interface

{$I frx.inc}
{$DEFINE PDF_RC4}

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  ComObj, ComCtrls, frxClass, frxUtils, JPEG, frxUnicodeUtils
{$IFDEF Delphi6}, Variants {$ENDIF}
{$IFDEF PDF_RC4}, frxRC4{$ELSE}, frxRC4, frxAES{$ENDIF}
{$IFDEF Delphi10}
, WideStrings
{$ENDIF}
{$IFDEF Delphi12}
, AnsiStrings
{$ENDIF};

type
  TfrxPDFEncBit = (ePrint, eModify, eCopy, eAnnot);
  TfrxPDFEncBits = set of TfrxPDFEncBit;
  TfrxPDFPage = class;
  TfrxPDFFont = class;

  TfrxPDFElement = class(TObject)
  private
    FXrefPosition: Cardinal;
    FIndex: Integer;
    FCR: Boolean;
    procedure Write(Stream: TStream; const S: AnsiString);{$IFDEF Delphi12} overload;
    procedure Write(Stream: TStream; const S: String); overload;
{$ENDIF}
    procedure WriteLn(Stream: TStream; const S: AnsiString);{$IFDEF Delphi12} overload;
    procedure WriteLn(Stream: TStream; const S: String); overload;
{$ENDIF}
  public
    constructor Create;
    procedure SaveToStream(const Stream: TStream); virtual;
    property XrefPosition: Cardinal read FXrefPosition;
    property Index: Integer read FIndex write FIndex;
  end;

  TfrxPDFFile = class(TfrxPDFElement)
  private
    FPages: TList;
    FFonts: TList;
    FXRef: TStringList;
    FObjNo: Integer;
    FCounter: Integer;
    FTitle: String;
    FStartXRef: Cardinal;
    FStartFonts: Integer;
    FStartPages: Integer;
    FPagesRoot: Integer;
    FCompressed: Boolean;
    FPrintOpt: Boolean;
    FOutline: Boolean;
    FPreviewOutline: TfrxCustomOutline;
    FSubject: String;
    FAuthor: String;
    FBackground: Boolean;
    FCreator: String;
    FHTMLTags: Boolean;
    FPageNumbers: String;
    FTotalPages: Integer;
    FFileID: AnsiString;
    FProtection: Boolean;
    FEncBits: Cardinal;
    FProtectionFlags: TfrxPDFEncBits;
    FOwnerPassword: AnsiString;
    FUserPassword: AnsiString;
    FEncKey: AnsiString;
    FOPass: AnsiString;
    FUPass: AnsiString;
    FKeywords: WideString;
    FProducer: WideString;
    FPrintScaling: Boolean;
    FFitWindow: Boolean;
    FHideMenubar: Boolean;
    FCenterWindow: Boolean;
    FHideWindowUI: Boolean;
    FHideToolbar: Boolean;
    procedure PrepareKeys;
    function GetOwnerPassword: AnsiString;
    function GetUserPassword: AnsiString;
    procedure SetProtectionFlags(const Value: TfrxPDFEncBits);
  public
    FStreamObjects: TStream;
    FTempStreamFile: String;
    FEmbedded: Boolean;
    FFontDCnt: Integer;
    constructor Create(const UseFileCache: Boolean; const TempDir: String);
    destructor Destroy; override;
    procedure Clear;
    procedure XRefAdd(Stream: TStream; ObjNo: Integer);
    procedure SaveToStream(const Stream: TStream); override;
    function AddPage(const Page: TfrxReportPage): TfrxPDFPage;
    function AddFont(const Font: TFont): Integer;
    procedure Start;

    property Pages: TList read FPages;
    property Fonts: TList read FFonts;
    property Counter: Integer read FCounter write FCounter;
    property Compressed: Boolean read FCompressed write FCompressed;
    property EmbeddedFonts: Boolean read FEmbedded write FEmbedded default True;
    property PrintOptimized: Boolean read FPrintOpt write FPrintOpt;
    property Outline: Boolean read FOutline write FOutline;
    property PreviewOutline: TfrxCustomOutline read FPreviewOutline write FPreviewOutline;
    property Background: Boolean read FBackground write FBackground;

    property Title: String read FTitle write FTitle;
    property Creator: String read FCreator write FCreator;
    property Producer: WideString read FProducer write FProducer;
    property Keywords: WideString read FKeywords write FKeywords;
    property Author: String read FAuthor write FAuthor;
    property Subject: String read FSubject write FSubject;

    property HTMLTags: Boolean read FHTMLTags write FHTMLTags;
    property PageNumbers: String read FPageNumbers write FPageNumbers;
    property TotalPages: Integer read FTotalPages write FTotalPages;
    property Protection: Boolean read FProtection write FProtection;
    property UserPassword: AnsiString read FUserPassword write FUserPassword;
    property OwnerPassword: AnsiString read FOwnerPassword write FOwnerPassword;
    property ProtectionFlags: TfrxPDFEncBits read FProtectionFlags write SetProtectionFlags;

    property HideToolbar: Boolean read FHideToolbar write FHideToolbar;
    property HideMenubar: Boolean read FHideMenubar write FHideMenubar;
    property HideWindowUI: Boolean read FHideWindowUI write FHideWindowUI;
    property FitWindow: Boolean read FFitWindow write FFitWindow;
    property CenterWindow: Boolean read FCenterWindow write FCenterWindow;
    property PrintScaling: Boolean read FPrintScaling write FPrintScaling;
  end;

  TfrxPDFPage = class(TfrxPDFElement)
  private
    FStreamOffset: Longint;
    FParent: TfrxPDFFile;
    FWidth: Extended;
    FHeight: Extended;
    FMarginLeft: Extended;
    FMarginTop: Extended;
    FStream: TStream;
    FStreamSize: Longint;
    FDivider: Extended;
    FLastColor: TColor;
    FLastColorResult: String;
    FBMP: TBitmap;
    FDefFontCharSet: Integer;
    function CodepageByCharset(const Charset: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToStream(const Stream: TStream); override;
    procedure AddObject(const Obj: TfrxView);
    property StreamOffset: Longint read FStreamOffset write FStreamOffset;
    property StreamSize: Longint read FStreamSize write FStreamSize;

    property OutStream: TStream read FStream write FStream;
    property Parent: TfrxPDFFile read FParent write FParent;
    property Width: Extended read FWidth write FWidth;
    property Height: Extended read FHeight write FHeight;
    property MarginLeft: Extended read FMarginLeft write FMarginLeft;
    property MarginTop: Extended read FMarginTop write FMarginTop;
  end;

  TfrxPDFFont = class(TfrxPDFElement)
  private
    FFont: TFont;
    FParent: TfrxPDFFile;
    FFontDCnt: Integer;
    FCodepage: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToStream(const Stream: TStream); override;

    property Parent: TfrxPDFFile read FParent write FParent;
    property Font: TFont read FFont;
    property Codepage: Integer read FCodepage write FCodepage;
  end;

  TfrxPDFOutlineNode = class(TObject)
  private
    FNumber: Integer;
    FDest: Integer;
    FTop: Integer;
    FCountTree: Integer;
    FCount: Integer;
    FTitle: String;
    FLast: TfrxPDFOutlineNode;
    FNext: TfrxPDFOutlineNode;
    FParent: TfrxPDFOutlineNode;
    FPrev: TfrxPDFOutlineNode;
    FFirst: TfrxPDFOutlineNode;
  public
    constructor Create;
    destructor Destroy; override;
    property Title: String read FTitle write FTitle;
    property Dest: Integer read FDest write FDest;
    property Top: Integer read FTop write FTop;
    property Number: Integer read FNumber write FNumber;
    property CountTree: Integer read FCountTree write FCountTree;
    property Count: Integer read FCount write FCount;
    property First: TfrxPDFOutlineNode read FFirst write FFirst;
    property Last: TfrxPDFOutlineNode read FLast write FLast;
    property Parent: TfrxPDFOutlineNode read FParent write FParent;
    property Prev: TfrxPDFOutlineNode read FPrev write FPrev;
    property Next: TfrxPDFOutlineNode read FNext write FNext;
  end;

implementation

uses frxGraphicUtils, frxGzip, frxMD5, ActiveX, SyncObjs, math;

var
  pdfCS: TCriticalSection;

const
  PDF_VER = '1.5';
  PDF_DIVIDER = 0.75;
  PDF_MARG_DIVIDER = 0.05;
  PDF_PRINTOPT = 3;
  PDF_PK: array [ 1..32 ] of Byte =
    ( $28, $BF, $4E, $5E, $4E, $75, $8A, $41, $64, $00, $4E, $56, $FF, $FA, $01, $08,
      $2E, $2E, $00, $B6, $D0, $68, $3E, $80, $2F, $0C, $A9, $FE, $64, $53, $69, $7A );

type
  PABC = ^ABCarray;
  ABCarray = array [0..255] of ABC;

function GetID: AnsiString;
var
  AGUID: TGUID;
  AGUIDString: widestring;
begin
  CoCreateGUID(AGUID);
  SetLength(AGUIDString, 39);
  StringFromGUID2(AGUID, PWideChar(AGUIDString), 39);
  Result := AnsiString(PWideChar(AGUIDString));
  MD5String(AnsiString(PWideChar(AGUIDString)));
end;

function frxReverseStringU(const AText: WideString): WideString;
var
  I: Integer;
  P: PWideChar;
begin
  SetLength(Result, Length(AText));
  P := PWideChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

function GetLocaleInformation(Flag: Integer): AnsiString;
var
  pcLCA: array[0..20] of AnsiChar;
begin
  if (GetLocaleInfoA(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA,19) <= 0 ) then
    pcLCA[0] := #0;
  Result := pcLCA;
end;

function CheckOEM(const Value: WideString): boolean;
var
  i: integer;
begin
  result := false;
  for i := 1 to Length(Value) do
    if (ByteType(Value, i) <> mbSingleByte) or
       (Ord(Value[i]) > 122) or
       (Ord(Value[i]) < 32) then
    begin
      result := true;
      Break;
    end;
end;

function StrToUTF16U(const Value: WideString): AnsiString;
var
  i: integer;
  pwc: ^Word;
begin
  result := 'FEFF';
  for i := 1 to Length(Value) do
  begin
    pwc := @Value[i];
    result := result  + AnsiString(IntToHex(pwc^, 4));
  end;
end;

function StrToHex(const Value: AnsiString): AnsiString;
var
  i: integer;
begin
  result := '';
  for i := 1 to Length(Value) do
    result := result  + AnsiString(IntToHex(Byte(Value[i]), 2));
end;

function StrToUTF16(const Value: AnsiString): AnsiString;
var
  PW: Pointer;
  Len: integer;
  i: integer;
  pwc: ^Word;
begin
  result := 'FEFF';
  Len := MultiByteToWideChar(0, CP_ACP, PAnsiChar(Value), Length(Value), nil, 0);
  GetMem(PW, Len * 2);
  try
    Len := MultiByteToWideChar(0, CP_ACP, PAnsiChar(Value), Length(Value), PW, Len * 2);
    pwc := PW;
    for i := 0 to Len - 1 do
    begin
      result := result  + AnsiString(IntToHex(pwc^, 4));
      Inc(pwc);
    end;
  finally
    FreeMem(PW);
  end;
end;

function HexEncode7F(Str: WideString): AnsiString;
var
  s: AnsiString;
  Index, Len: Integer;
begin
  s := '';
  Len := Length(Str);
  Index := 0;
  while Index < Len do
  begin
    Index := Index + 1;
    if Byte(Str[Index]) > $7F then
      s := s + '#' + AnsiString(IntToHex(Byte(Str[Index]), 2))
    else
      s := s + AnsiString(Str[Index]);
  end;
  Result := s;
end;

function Dec2Oct(const i: Longint): AnsiString;
var
  m, j: Longint;
Begin
  Result := '';
  j := i;
  while j > 0 Do
  begin
    m := j mod 8;
    Result := AnsiChar(m + Ord('0')) + Result;
    j := j div 8;
  end;
  Result := StringOfChar(AnsiChar('0'),  3 - Length(Result)) + Result;
end;

function StrToOct(const Value: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Value) do
    Result := Result + '\' + Dec2Oct(Ord(Value[i]));
end;

function EscapeSpecialChar(TextStr: AnsiString): AnsiString;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length ( TextStr ) do
    case TextStr [ I ] of
      '(': Result := Result + '\(';
      ')': Result := Result + '\)';
      '\': Result := Result + '\\';
      #13: Result := result + '\r';
      #10: Result := result + '\n';
    else
      Result := Result + AnsiChar(chr ( Ord ( textstr [ i ] ) ));
    end;
end;

function CryptStr(Source: AnsiString; Key: AnsiString; Enc: Boolean; id: Integer): AnsiString;
var
{$IFDEF PDF_RC4}
  k: array [ 1..21 ] of Byte;
  rc4: TfrxRC4;
{$ELSE}
  k: array [ 1..25 ] of Byte;
  aes: TfrxAES;
{$ENDIF}
  s, s1, ss: AnsiString;
begin
  if Enc then
  begin
{$IFDEF PDF_RC4}
    rc4 := TfrxRC4.Create;
{$ELSE}
    aes := TfrxAES.Create;
{$ENDIF}
    try
      s := Key;
      FillChar(k, 21, 0);
      Move(s[1], k, 16);
      Move(id, k [17], 3);
{$IFDEF PDF_RC4}
      SetLength(s1, 21);
      MD5Buf(@k, 21, @s1[1]);
{$ELSE}
      k[22] := $73;
      k[23] := $41;
      k[24] := $6c;
      k[25] := $54;
      SetLength(s1, 25);
      MD5Buf(@k, 25, @s1[1]);
{$ENDIF}
      ss := Source;
{$IFDEF PDF_RC4}
      SetLength(Result, Length(ss));
      rc4.Start(@s1[1], 16);
      rc4.Crypt(@ss[1], @Result[1], Length(ss));
      Result := EscapeSpecialChar(Result);
{$ELSE}
      aes.Start(s1);
      Result := EscapeSpecialChar(aes.Crypt(ss));
{$ENDIF}
    finally
{$IFDEF PDF_RC4}
      rc4.Free;
{$ELSE}
      aes.Free;
{$ENDIF}
    end;
  end
  else
    Result := EscapeSpecialChar(Source);
end;

function CryptStream(Source: TStream; Target: TStream; Key: AnsiString; id: Integer): AnsiString;
var
  s: AnsiString;
{$IFDEF PDF_RC4}
  k: array [ 1..21 ] of Byte;
  rc4: TfrxRC4;
  m1, m2: TMemoryStream;
{$ELSE}
  k: array [ 1..25 ] of Byte;
  aes: TfrxAES;
{$ENDIF}
begin
  FillChar(k, 21, 0);
  Move(Key[1], k, 16);
  Move(id, k[17], 3);
{$IFDEF PDF_RC4}
  SetLength(s, 16);
  MD5Buf(@k, 21, @s[1]);
{$ELSE}
  k[22] := $73;
  k[23] := $41;
  k[24] := $6c;
  k[25] := $54;
  SetLength(s, 25);
  MD5Buf(@k, 25, @s[1]);
{$ENDIF}
{$IFDEF PDF_RC4}
  m1 := TMemoryStream.Create;
  m2 := TMemoryStream.Create;
  rc4 := TfrxRC4.Create;
{$ELSE}
  aes := TfrxAES.Create;
{$ENDIF}
  try
{$IFDEF PDF_RC4}
    m1.LoadFromStream(Source);
    m2.SetSize(m1.Size);
    rc4.Start(@s[1], 16);
    rc4.Crypt(m1.Memory, m2.Memory, m1.Size);
    m2.SaveToStream(Target);
{$ELSE}
    aes.Start(s);
    SetLength(s, Source.Size);
    Source.Read(s[1], Source.Size);
    s := aes.Crypt(s);
    Target.Write(Stream, s[1], Length(s));
{$ENDIF}
  finally
{$IFDEF PDF_RC4}
    m1.Free;
    m2.Free;
    rc4.Free;
{$ELSE}
    aes.Free;
{$ENDIF}
  end;
end;

function PrepareString(const Text: WideString; Key: AnsiString; Enc: Boolean; id: Integer): AnsiString;
begin
  if Enc then
  begin
    Result := '(' + CryptStr(AnsiString(Text), Key, Enc, id) + ')'
  end
  else
    Result := '<' + StrToUTF16(AnsiString(Text)) + '>'
end;

function UnicodeToANSI(const Str: WideString; Codepage: Integer): AnsiString;
var
  i: Integer;
begin
  Result := '';
  i := WideCharToMultiByte(CodePage, 0, @Str[1], Length(Str), nil, 0, nil, nil);
  if i <> 0 then
  begin
    SetLength(Result, i);
    WideCharToMultiByte(CodePage, 0, @Str[1], Length(Str), @Result[1], i, nil, nil)
  end;
end;

{ TfrxPDFFile }

constructor TfrxPDFFile.Create(const UseFileCache: Boolean; const TempDir: String);
begin
  inherited Create;
  FPages := TList.Create;
  FFonts := TList.Create;
  FXRef := TStringList.Create;
  FCounter := 4;
  FStartPages := 0;
  FStartXRef := 0;
  FStartFonts := 0;
  FCompressed := True;
  FPrintOpt := False;
  FOutline := False;
  FPreviewOutline := nil;
  FHTMLTags := False;
  FFontDCnt := 0;
  FObjNo := 0;
  if UseFileCache then
  begin
    FTempStreamFile := frxCreateTempFile(TempDir);
    FStreamObjects := TFileStream.Create(FTempStreamFile, fmCreate);
  end else
    FStreamObjects := TMemoryStream.Create;
  ProtectionFlags := [ePrint, eModify, eCopy, eAnnot];
end;

destructor TfrxPDFFile.Destroy;
begin
  Clear;
  FXRef.Free;
  FPages.Free;
  FFonts.Free;
  FStreamObjects.Free;
  try
    DeleteFile(FTempStreamFile);
  except
  end;
  inherited;
end;

procedure TfrxPDFFile.Clear;
var
  i: Integer;
begin
  for i := 0 to FPages.Count - 1 do
    TfrxPDFPage(FPages[i]).Free;
  FPages.Clear;
  for i := 0 to FFonts.Count - 1 do
    TfrxPDFFont(FFonts[i]).Free;
  FFonts.Clear;
  FXRef.Clear;
  ProtectionFlags := [ePrint, eModify, eCopy, eAnnot];
end;

procedure TfrxPDFFile.SaveToStream(const Stream: TStream);
var
  i, j: Integer;
  s, s1: {Ansi}String;
  Page, Top: Integer;
  Text: String;
  Parent: Integer;
  OutlineCount: Integer;
  NodeNumber: Integer;
  OutlineTree: TfrxPDFOutlineNode;
  pgN: TStringList;
  FOutlineN: Integer;

  function CheckPageInRange(const PageN: Integer): Boolean;
  begin
    Result := True;
    if (pgN.Count <> 0) and (pgN.IndexOf(IntToStr(PageN + 1)) = -1) then
      Result := False;
  end;

  procedure DoPrepareOutline(Node: TfrxPDFOutlineNode);
  var
    i: Integer;
    p: TfrxPDFOutlineNode;
    prev: TfrxPDFOutlineNode;
  begin
    Inc(NodeNumber);
    prev := nil;
    p := nil;
    for i := 0 to FPreviewOutline.Count - 1 do
    begin
      FPreviewOutline.GetItem(i, Text, Page, Top);
      if CheckPageInRange(Page) then
      begin
        p := TfrxPDFOutlineNode.Create;
        p.Title := Text;
        p.Dest := Page;
        p.Top := Top;
        p.Prev := prev;
        if prev <> nil then
          prev.Next := p
        else
          Node.First := p;
        prev := p;
        p.Parent := Node;
        FPreviewOutline.LevelDown(i);
        DoPrepareOutline(p);
        Node.Count := Node.Count + 1;
        Node.CountTree := Node.CountTree + p.CountTree + 1;
        FPreviewOutline.LevelUp;
      end;
    end;
    Node.Last := p;
  end;

  procedure DoWriteOutline(Node: TfrxPDFOutlineNode; Parent: Integer);
  var
    p: TfrxPDFOutlineNode;
    i: Integer;
  begin
    p := Node;
    if p.Dest = -1 then
      p.Number := Parent
    else
    begin
      p.Number := FCounter;
      Inc(FObjNo);
      XRefAdd(Stream, FObjNo);
      WriteLn(Stream, IntToStr(FCounter) + ' 0 obj');
      Inc(FCounter);
      WriteLn(Stream, '<<');
      WriteLn(Stream, '/Title ' + PrepareString(p.Title, FEncKey, FProtection, FCounter - 1));
      WriteLn(Stream, '/Parent ' + IntToStr(Parent) + ' 0 R');
      if p.Prev <> nil then
        WriteLn(Stream, '/Prev ' + IntToStr(p.Prev.Number) + ' 0 R');
      if p.First <> nil then
      begin
        WriteLn(Stream, '/First ' + IntToStr(p.Number + 1) + ' 0 R');
        WriteLn(Stream, '/Last ' + IntToStr(p.Number + p.CountTree - p.Last.CountTree ) + ' 0 R');
        WriteLn(Stream, '/Count ' + IntToStr(p.Count));
      end;
      if p.Next <> nil then
        WriteLn(Stream, '/Next ' + IntToStr(p.Number + p.CountTree + 1) + ' 0 R');
      if CheckPageInRange(p.Dest) then
      begin
        if FEmbedded then
          i := FFontDCnt + 1
        else
          i := FFontDCnt;
        if pgN.Count > 0 then
          s := '/Dest [' + IntToStr(FpagesRoot + FFonts.Count * i + pgN.IndexOf(IntToStr(p.Dest + 1)) * 2 + 1) + ' 0 R /XYZ 0 ' + IntToStr(Round(TfrxPDFPage(FPages[pgN.IndexOf(IntToStr(p.Dest + 1))]).Height - p.Top * PDF_DIVIDER)) + ' 0]'
        else
          s := '/Dest [' + IntToStr(FpagesRoot + FFonts.Count * i + p.Dest * 2 + 1) + ' 0 R /XYZ 0 ' + IntToStr(Round(TfrxPDFPage(FPages[p.Dest]).Height - p.Top * PDF_DIVIDER)) + ' 0]';
        WriteLn(Stream, s);
      end;
      WriteLn(Stream, '>>');
      WriteLn(Stream, 'endobj');
    end;
    if p.First <> nil then
      DoWriteOutline(p.First, p.Number);
    if p.Next <> nil then
      DoWriteOutline(p.Next, Parent);
  end;

begin
  inherited SaveToStream(Stream);
  OutlineCount := 0;
  OutlineTree := nil;
  if FOutline then
    if not Assigned(FPreviewOutline) then
      FOutline := False
    else
      FPreviewOutline.LevelRoot;
  FCounter := 1;
  WriteLn(Stream, '%PDF-' + PDF_VER);
  WriteLn(Stream, '%'#226#227#207#211);
  Inc(FObjNo);
  XRefAdd(Stream, FObjNo);
  WriteLn(Stream, IntToStr(FCounter) + ' 0 obj');
  Inc(FCounter);
  WriteLn(Stream, '<<');
  WriteLn(Stream, '/Type /Catalog');
  i := 0;

  if FOutline then
  begin
    OutlineTree := TfrxPDFOutlineNode.Create;
    pgN := TStringList.Create;
    NodeNumber := 0;
    frxParsePageNumbers(PageNumbers, pgN, FTotalPages);
    DoPrepareOutline(OutlineTree);
    if OutlineTree.CountTree > 0 then
    begin
      OutlineCount := OutlineTree.CountTree - OutlineTree.Last.CountTree;
      i := OutlineTree.CountTree + 1;
    end else
    begin
      OutlineTree.Free;
      pgN.Free;
      FOutline := False;
    end;
  end;

  FPagesRoot := FObjNo + 2 + i;
  WriteLn(Stream, '/Pages ' + IntToStr(FPagesRoot) + ' 0 R');
  if FOutline then s1 := '/UseOutlines'
  else s1 := '/UseNone';
  WriteLn(Stream, '/PageMode ' + s1);
  if FOutline then
    WriteLn(Stream, '/Outlines ' + IntToStr(FCounter + 1) + ' 0 R');
  WriteLn(Stream, '/ViewerPreferences <<');
  if FTitle <> '' then
    WriteLn(Stream, '/DisplayDocTitle true');
  if FHideToolbar then
    WriteLn(Stream, '/HideToolbar true');
  if FHideMenubar then
    WriteLn(Stream, '/HideMenubar true');
  if FHideWindowUI then
    WriteLn(Stream, '/HideWindowUI true');
  if FFitWindow then
    WriteLn(Stream, '/FitWindow true');
  if FCenterWindow then
    WriteLn(Stream, '/CenterWindow true');
  if not FPrintScaling then
    WriteLn(Stream, '/PrintScaling /None');
  WriteLn(Stream, '>>');
  WriteLn(Stream, '>>');
  WriteLn(Stream, 'endobj');
  Inc(FObjNo);
  XRefAdd(Stream, FObjNo);
  WriteLn(Stream, IntToStr(FCounter) + ' 0 obj');
  Inc(FCounter);
  WriteLn(Stream, '<<');
  WriteLn(Stream, '/Title ' + PrepareString(FTitle, FEncKey, FProtection, FCounter - 1));
  WriteLn(Stream, '/Author ' + PrepareString(FAuthor, FEncKey, FProtection, FCounter - 1));
  WriteLn(Stream, '/Subject ' + PrepareString(FSubject, FEncKey, FProtection, FCounter - 1));
  WriteLn(Stream, '/Keywords ' + PrepareString(FKeywords, FEncKey, FProtection, FCounter - 1));
  WriteLn(Stream, '/Creator ' + PrepareString(FCreator, FEncKey, FProtection, FCounter - 1));
  WriteLn(Stream, '/Producer ' + PrepareString(FProducer, FEncKey, FProtection, FCounter - 1));
  s := 'D:' + FormatDateTime('yyyy', Now) + FormatDateTime('mm', Now) +
    FormatDateTime('dd', Now) + FormatDateTime('hh', Now) +
    FormatDateTime('nn', Now) + FormatDateTime('ss', Now);
  if FProtection then
  begin
    WriteLn(Stream, '/CreationDate ' + PrepareString(s, FEncKey, FProtection, FCounter - 1));
    WriteLn(Stream, '/ModDate ' + PrepareString(s, FEncKey, FProtection, FCounter - 1));
  end
  else
  begin
    WriteLn(Stream, '/CreationDate (' + s + ')');
    WriteLn(Stream, '/ModDate (' + s + ')');
  end;
  WriteLn(Stream, '>>');
  WriteLn(Stream, 'endobj');
  if FOutline then
  begin
    Inc(FObjNo);
    XRefAdd(Stream, FObjNo);
    FOutlineN := FCounter;
    WriteLn(Stream, IntToStr(FOutlineN) + ' 0 obj');
    Parent := FCounter;
    Inc(FCounter);
    FPreviewOutline.LevelRoot;
    WriteLn(Stream, '<<');
    WriteLn(Stream, '/Count ' + IntToStr(FPreviewOutline.Count));
    WriteLn(Stream, '/First ' + IntToStr(FCounter) + ' 0 R');
    WriteLn(Stream, '/Last ' + IntToStr(FCounter + OutlineCount - 1) + ' 0 R');
    WriteLn(Stream, '>>');
    WriteLn(Stream, 'endobj');
    try
      DoWriteOutline(OutlineTree, Parent);
    finally
      OutlineTree.Free;
    end;
    pgN.Free;
    FCounter := FCounter + FPreviewOutline.Count;
  end;
  FStartFonts := FObjNo;
  Inc(FObjNo);
  for i := 0 to FFonts.Count - 1 do
    TfrxPDFFont(FFonts[i]).SaveToStream(Stream);

  FStartPages := FObjNo + 1;

  for i := 0 to FPages.Count - 1 do
  begin
    TfrxPDFPage(FPages[FPages.Count - 1]).StreamSize := FStreamObjects.Size - TfrxPDFPage(FPages[FPages.Count - 1]).StreamOffset;
    TfrxPDFPage(FPages[i]).SaveToStream(Stream);
  end;

  XRefAdd(Stream, FPagesRoot);
  WriteLn(Stream, IntToStr(FPagesRoot) + ' 0 obj');
  WriteLn(Stream, '<<');
  WriteLn(Stream, '/Type /Pages');
  Write(Stream, '/Kids [');
  for i := 0 to FPages.Count - 1 do
    Write(Stream, IntToStr(FStartPages + i * 2) + ' 0 R ');
  WriteLn(Stream, ']');
  WriteLn(Stream, '/Count ' + IntToStr(FPages.Count));
  WriteLn(Stream, '>>');
  WriteLn(Stream, 'endobj');
  FStartXRef := Stream.Position;
  WriteLn(Stream, 'xref');
  WriteLn(Stream, '0 ' + IntToStr(FXRef.Count + 1));
  WriteLn(Stream, '0000000000 65535 f');

  for i := 1 to FXRef.Count do
  begin
    j := FXRef.IndexOfObject(TObject(i));
    if j <> -1 then
      WriteLn(Stream, FXRef.Strings[j] + ' 00000 n');
  end;

  WriteLn(Stream, 'trailer');
  WriteLn(Stream, '<<');
  WriteLn(Stream, '/Size ' + IntToStr(FXref.Count + 1));
  WriteLn(Stream, '/Root 1 0 R');
  WriteLn(Stream, '/Info 2 0 R');
  WriteLn(Stream, '/ID [<' + FFileID + '><' + FFileID + '>]');

  if FProtection then
  begin
    WriteLn(Stream, '/Encrypt <<');
    WriteLn(Stream, '/Filter /Standard' );
{$IFDEF PDF_RC4}
    WriteLn(Stream, '/V 2');
    WriteLn(Stream, '/R 3');
{$ELSE}
    WriteLn(Stream, '/V 4');
    WriteLn(Stream, '/R 4');
    WriteLn(Stream, '/CF <<');
    WriteLn(Stream, '/StdCF <<');
    WriteLn(Stream, '/Type /CryptAlgorithm');
    WriteLn(Stream, '/CFM /AESV2');
    WriteLn(Stream, '/AuthEvent /DocOpen');
    WriteLn(Stream, '>>');
    WriteLn(Stream, '>>');
    WriteLn(Stream, '/StrF /StdCF');
    WriteLn(Stream, '/StmF /StdCF');
{$ENDIF}
    WriteLn(Stream, '/Length 128');
    WriteLn(Stream, '/P ' + IntToStr(Integer(FEncBits)));
    WriteLn(Stream, '/O (' + EscapeSpecialChar(GetOwnerPassword) + ')');
    WriteLn(Stream, '/U (' + EscapeSpecialChar(GetUserPassword) + ')');
    WriteLn(Stream, '>>');
  end;

  WriteLn(Stream, '>>');
  WriteLn(Stream, 'startxref');
  WriteLn(Stream, IntToStr(FStartXRef));
  WriteLn(Stream, '%%EOF');
end;

procedure TfrxPDFFile.XRefAdd(Stream: TStream; ObjNo: Integer);
begin
  FXRef.AddObject(StringOfChar('0',  10 - Length(IntToStr(Stream.Position))) + IntToStr(Stream.Position), TObject(ObjNo));
end;

function TfrxPDFFile.AddFont(const Font: TFont): Integer;
var
  Font2: TfrxPDFFont;
  i, j: Integer;
begin
  j := -1;
  for i := 0 to FFonts.Count - 1 do
  begin
    Font2 := TfrxPDFFont(FFonts[i]);
    if (Font2.Font.Name = Font.Name) and
       (Font2.Font.Style = Font.Style) and
       (Font2.Font.Charset = Font.Charset) then
    begin
      j := i;
      break;
    end;
  end;
  if j = -1 then
  begin
    Font2 := TfrxPDFFont.Create;
    Font2.Parent := Self;
    Font2.Font.Assign(Font);
    FFonts.Add(Font2);
    j := FFonts.Count - 1;
    Font2.Index := j + 1
  end;
  Result := j;
end;

function TfrxPDFFile.AddPage(const Page: TfrxReportPage): TfrxPDFPage;
var
  PDFPage: TfrxPDFPage;
begin
  PDFPage := TfrxPDFPage.Create;
  PDFPage.Width := Page.Width * PDF_DIVIDER;
  PDFPage.Height := Page.Height * PDF_DIVIDER;
  PDFPage.MarginLeft := Page.LeftMargin * PDF_MARG_DIVIDER;
  PDFPAge.MarginTop := Page.TopMargin * PDF_MARG_DIVIDER;
  PDFPage.Parent := Self;
  PDFPage.OutStream := FStreamObjects;
  PDFPage.StreamOffset := FStreamObjects.Position;
  if FPages.Count > 0 then
    TfrxPDFPage(FPages[FPages.Count - 1]).StreamSize := FStreamObjects.Position -
      TfrxPDFPage(FPages[FPages.Count - 1]).StreamOffset;
  FPages.Add(PDFPage);
  PDFPage.Index := FPages.Count;
  Result := PDFPage;
  FFontDCnt := 2;
end;

function PMD52Str(p: Pointer): AnsiString;
begin
  SetLength(Result, 16);
  Move(p^, Result[1], 16);
end;

function PadPassword(Password: AnsiString): AnsiString;
var
  i: Integer;
begin
  i := Length(Password);
  Result := Copy(Password, 1, i);
  SetLength(Result, 32);
  if i < 32 then
    Move(PDF_PK, Result[i + 1], 32 - i);
end;

procedure TfrxPDFFile.PrepareKeys;
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
      fid := fid + AnsiChar(chr(Byte(StrToInt('$' + String(FFileID[i * 2 - 1] + FFileID[i * 2])))));
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
      rc4.Start(@s1[1], 16 );
      rc4.Crypt(@s[1], @s[1], 16 );
      SetLength(p1, 16);
      for i := 1 to 19 do
      begin
        for j := 1 to 16 do
           p1[j] := AnsiChar(Byte(s1[j]) xor i);
         rc4.Start(@p1[1], 16 );
         rc4.Crypt(@s[1], @s[1], 16 );
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

function TfrxPDFFile.GetOwnerPassword: AnsiString;
begin
  Result := FOPass;
end;

function TfrxPDFFile.GetUserPassword: AnsiString;
begin
  Result := FUPass;
end;

procedure TfrxPDFFile.SetProtectionFlags(const Value: TfrxPDFEncBits);
begin
  FProtectionFlags := Value;
  FEncBits := $FFFFFFC0;
  FEncBits := FEncBits + (Cardinal(ePrint in Value) shl 2 +
    Cardinal(eModify in Value) shl 3 +
    Cardinal(eCopy in Value) shl 4 +
    Cardinal(eAnnot in Value) shl 5);
end;

procedure TfrxPDFFile.Start;
begin
  FFileID := MD5String(GetID);
  if FProtection then
    PrepareKeys;
end;

{ TfrxPDFPage }

constructor TfrxPDFPage.Create;
begin
  inherited;
  FMarginLeft := 0;
  FMarginTop := 0;
  FDivider := frxDrawText.DefPPI / frxDrawText.ScrPPI;
  FLastColor := clBlack;
  FLastColorResult := '0 0 0';
  FBMP := TBitmap.Create;
  FDefFontCharSet := GetDefFontCharSet;
end;

procedure TfrxPDFPage.SaveToStream(const Stream: TStream);
var
  i, id: Integer;
  s: String;
  TmpPageStream: TMemoryStream;
  TmpPageStream2: TMemoryStream;
begin
  inherited SaveToStream(Stream);
  Inc(Parent.FObjNo);
  Parent.XRefAdd(Stream, Parent.FObjNo);
  id := Parent.FFontDCnt + Parent.FStartFonts + (Index - 1) * 2;
  WriteLn(Stream, IntToStr(id) + ' 0 obj');
  WriteLn(Stream, '<<');
  WriteLn(Stream, '/Type /Page');
  WriteLn(Stream, '/Parent ' + IntToStr(Parent.FPagesRoot) + ' 0 R');
  WriteLn(Stream, '/MediaBox [0 0 ' + frFloat2Str(FWidth) + ' ' + frFloat2Str(FHeight) + ' ]');
  WriteLn(Stream, '/Resources <<');
  WriteLn(Stream, '/Font <<');
  for i := 0 to Parent.FFonts.Count - 1 do
    WriteLn(Stream, '/F' + IntToStr(TfrxPDFFont(Parent.FFonts[i]).Index - 1) + ' ' +
      IntToStr(TfrxPDFFont(Parent.FFonts[i]).FFontDCnt + Parent.FStartFonts) + ' 0 R');
  WriteLn(Stream, '>>');
  WriteLn(Stream, '/XObject <<');
  WriteLn(Stream, '>>');
  WriteLn(Stream, '/ProcSet [/PDF /Text /ImageC ]');
  WriteLn(Stream, '>>');
  WriteLn(Stream, '/Contents ' + IntToStr(id + 1) + ' 0 R');
  WriteLn(Stream, '>>');
  WriteLn(Stream, 'endobj');
  Inc(Parent.FObjNo);
  Parent.XRefAdd(Stream, Parent.FObjNo);
  id := id + 1;
  WriteLn(Stream, IntToStr(id) + ' 0 obj');
  Write(Stream, '<< ');
  TmpPageStream := TMemoryStream.Create;
  TmpPageStream2 := TMemoryStream.Create;
  try
    OutStream.Position := FStreamOffset;

    TmpPageStream2.CopyFrom(OutStream, FStreamSize);
    if Parent.FCompressed then
    begin
      frxDeflateStream(TmpPageStream2, TmpPageStream, gzFastest);
      s := '/Filter /FlateDecode /Length ' + IntToStr(TmpPageStream.Size) +
        ' /Length1 ' + IntToStr(TmpPageStream2.Size);
    end
    else
      s := '/Length ' + IntToStr(TmpPageStream2.Size);
    WriteLn(Stream, s + ' >>');
    WriteLn(Stream, 'stream');

    if Parent.FCompressed then
    begin
      if Parent.Protection then
        CryptStream(TmpPageStream, Stream, Parent.FEncKey, id)
      else
        Stream.CopyFrom(TmpPageStream, 0);
      WriteLn(Stream, '');
    end else
      if Parent.Protection then
        CryptStream(TmpPageStream2, Stream, Parent.FEncKey, id)
      else
        Stream.CopyFrom(TmpPageStream2, 0);
  finally
    TmpPageStream2.Free;
    TmpPageStream.Free;
  end;
  WriteLn(Stream, 'endstream');
  WriteLn(Stream, 'endobj');
end;

function TfrxPDFPage.CodepageByCharset(const Charset: Integer): Integer;
var
  i: Integer;
begin
  if Charset = DEFAULT_CHARSET then
    i := FDefFontCharSet
  else
    i := CharSet;
  case i of
    EASTEUROPE_CHARSET:   Result := 1250;
    RUSSIAN_CHARSET:      Result := 1251;
    GREEK_CHARSET:        Result := 1253;
    TURKISH_CHARSET:      Result := 1254;
    HEBREW_CHARSET:       Result := 1255;
    ARABIC_CHARSET:       Result := 1256;
    BALTIC_CHARSET:       Result := 1257;
    VIETNAMESE_CHARSET:   Result := 1258;
    JOHAB_CHARSET:        Result := 1361;
    THAI_CHARSET:         Result := 874;
    SHIFTJIS_CHARSET:     Result := 932;
    GB2312_CHARSET:       Result := 936;
    HANGEUL_CHARSET:      Result := 949;
    CHINESEBIG5_CHARSET:  Result := 950;
    SYMBOL_CHARSET:       Result := 42;
    OEM_CHARSET:          Result := CP_OEMCP;
  else
    Result := 1252;
  end;
end;

procedure TfrxPDFPage.AddObject(const Obj: TfrxView);
var
  FontIndex: Integer;
  x, y, dx, dy, fdx, fdy, PGap, FCharSpacing, ow, oh: Extended;
  i, iz: Integer;
  Jpg: TJPEGImage;
  s: AnsiString;
  su: WideString;
  Lines: TWideStrings;
  TempBitmap: TBitmap;
  OldFrameWidth: Extended;
  TempColor: TColor;
  Left, Right, Top, Bottom, Width, Height, BWidth, BHeight: String;
  FUnderlineSize: Double;
  FRealBounds: TfrxRect;
  FLineHeight: Extended;
  FTextHeight: Extended;
  FHeightWoMargin: Extended;
  FTextWidth: Extended;
  alpha, cosa, sina, rx, ry: Extended;

  function GetLeft(const Left: Extended): Extended;
  begin
    Result := FMarginLeft + Left * PDF_DIVIDER
  end;

  function GetTop(const Top: Extended): Extended;
  begin
    Result := FHeightWoMargin - Top * PDF_DIVIDER
  end;

  function GetVTextPos(const Top: Extended; const Height: Extended;
    const Text: String; const Align: TfrxVAlign; const Line: Integer = 0;
    const Count: Integer = 1): Extended;
  var
    i: Integer;
  begin
    if Line <= Count then
      i := Line
    else
      i := 0;
    if Align = vaBottom then
      Result := Top + Height - FLineHeight * (Count - i - 1)
    else if Align = vaCenter then
      Result := Top + (Height - (FLineHeight * Count)) / 2 + FLineHeight * (i + 1)
    else
      Result := Top + FLineHeight * i + FTextHeight;
  end;

  function GetHTextPos(const Left: Extended; const Width: Extended; const CharSpacing: Extended; const Text: String;
    const Align: TfrxHAlign): Extended;
  begin
    if (Align = haLeft) or (Align = haBlock) then
      Result := Left
    else begin
      FBMP.Canvas.Lock;
      try
        FBMP.Canvas.Font.Assign(frxDrawText.Canvas.Font);
        FTextWidth := FBMP.Canvas.TextWidth(Text) / FDivider + Length(Text) * CharSpacing;
      finally
        FBMP.Canvas.Unlock;
      end;
      if Align = haCenter then
        Result := Left + (Width - FTextWidth) / 2
      else
        Result := Left + Width - FTextWidth;
    end;
  end;

  function GetPDFColor(const Color: TColor): String;
  var
    TheRgbValue : TColorRef;
  begin
    if Color = clBlack then
      Result := '0 0 0'
    else if Color = clWhite then
      Result := '1 1 1'
    else if Color = FLastColor then
      Result := FLastColorResult
    else begin
      TheRgbValue := ColorToRGB(Color);
      Result:= frFloat2Str(Byte(TheRGBValue) / 255) + ' ' +
        frFloat2Str(Byte(TheRGBValue shr 8) / 255) + ' ' +
        frFloat2Str(Byte(TheRGBValue shr 16) / 255);
      FLastColor := Color;
      FLastColorResult := Result;
    end;
  end;

  procedure MakeUpFrames;
  begin
    if (Obj.Frame.Typ <> []) and (Obj.Frame.Color <> clNone) then
    begin
      Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
        frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10);
      if Obj.Frame.Typ = [ftTop, ftRight, ftBottom, ftLeft] then
        Write(OutStream, Left + ' ' + Top + ' m'#13#10 + Right + ' ' + Top + ' l'#13#10 +
          Right + ' ' + Bottom + ' l'#13#10 + Left + ' ' + Bottom + ' l'#13#10 +
          Left + ' ' + Top + ' l'#13#10's'#13#10)
      else
      begin
        if ftTop in Obj.Frame.Typ then
          Write(OutStream, Left + ' ' + Top + ' m'#13#10 + Right + ' ' + Top + ' l'#13#10'S'#13#10);
        if ftRight in Obj.Frame.Typ then
          Write(OutStream, Right + ' ' + Top + ' m'#13#10 + Right + ' ' + Bottom + ' l'#13#10'S'#13#10);
        if ftBottom in Obj.Frame.Typ then
          Write(OutStream, Left + ' ' + Bottom + ' m'#13#10 + Right + ' ' + Bottom + ' l'#13#10'S'#13#10);
        if ftLeft in Obj.Frame.Typ then
          Write(OutStream, Left + ' ' + Top + ' m'#13#10 + Left + ' ' + Bottom + ' l'#13#10'S'#13#10);
      end;
    end;
  end;

  function HTMLTags(const View: TfrxCustomMemoView): Boolean;
  begin
    if View.AllowHTMLTags then
      Result := FParent.HTMLTags and (Pos('<' ,View.Memo.Text) > 0)
    else
      Result := False;
  end;

  function TruncReturns(const Str: WideString): WideString;
  var
    l: Integer;
  begin
    l := Length(Str);
    if (l > 1) and (Str[l - 1] = #13) and (Str[l] = #10) then
      Result := Copy(Str, 1, l - 2)
    else
      Result := Str;
  end;

  function CheckOutPDFChars(const Str: WideString): WideString;
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to Length(Str) do
      if Str[i] = '\' then
        Result := Result + '\\'
      else if Str[i] = '(' then
        Result := Result + '\('
      else if Str[i] = ')' then
        Result := Result + '\)'
      else
        Result := Result + Str[i];
  end;

  function Str2RTL(const Str: WideString): WideString;
  var
    DC: HDC;
{$IFDEF Delphi10}
    GCP: TGCPResultsW;
{$ELSE}
    GCP: TGCPResults;
{$ENDIF}
    buffer: WideString;
    len: Integer;
  begin
    len := Length(Str);
    SetLength(buffer, Len);
    DC := GetDc(0);
    try
{$IFDEF Delphi10}
      GCP.lStructSize := SizeOf(TGCPResultsW);
{$ELSE}
      GCP.lStructSize := SizeOf(TGCPResults);
{$ENDIF}
      GCP.lpOutString := Pointer(buffer);
      GCP.lpOrder := nil;
      GCP.lpDx := nil;
      GCP.lpCaretPos := nil;
      GCP.lpClass := nil;
      GCP.lpGlyphs := nil;
      GCP.nGlyphs := len;
      GCP.nMaxFit := 0;
{$IFNDEF Delphi7}
      GetCharacterPlacementW(DC, pointer(Str), LongBool(len), LongBool(512), GCP, GCP_REORDER or GCP_DIACRITIC);
{$ELSE}
  {$IFDEF Delphi9}
    {$IFDEF Delphi10}
      GetCharacterPlacementW(DC, pointer(Str), len, 512, GCP, DWORD(GCP_REORDER or GCP_DIACRITIC));
    {$ELSE}
      GetCharacterPlacementW(DC, pointer(Str), LongBool(len), LongBool(512), GCP, GCP_REORDER or GCP_DIACRITIC);
    {$ENDIF}
  {$ELSE}
      GetCharacterPlacementW(DC, pointer(Str), len, 512, GCP, GCP_REORDER or GCP_DIACRITIC);
  {$ENDIF}
{$ENDIF}
      buffer := Copy(buffer, 1, len);
    finally
      ReleaseDc(0, DC);
    end;
    Result := buffer;
  end;

  procedure DrawArrow(Obj: TfrxCustomLineView; x1, y1, x2, y2: Extended);
  var
    k1, a, b, c, D: Double;
    xp, yp, x3, y3, x4, y4, ld, wd: Extended;
  begin
    wd := Obj.ArrowWidth * PDF_DIVIDER;
    ld := Obj.ArrowLength * PDF_DIVIDER;
    if abs(x2 - x1) > 0 then
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
        x3 := xp; y3 := yp - wd;
        x4 := xp; y4 := yp + wd;
      end;
    end
    else
    begin
      xp := x2;
      yp := y2 - ld;
      if (yp > y1) and (yp > y2) or (yp < y1) and (yp < y2) then
        yp := y2 + ld;
      x3 := xp - wd; y3 := yp;
      x4 := xp + wd; y4 := yp;
    end;
    WriteLn(OutStream, frFloat2Str(x3) + ' ' + frFloat2Str(y3) + ' m'#13#10 +
      frFloat2Str(x2) + ' ' + frFloat2Str(y2) + ' l'#13#10 +
      frFloat2Str(x4) + ' ' + frFloat2Str(y4) + ' l');
    if Obj.ArrowSolid then
      WriteLn(OutStream, '1 j'#13#10 + GetPDFColor(Obj.Frame.Color) + ' rg'#13#10'b')
    else
      WriteLn(OutStream, 'S');
  end;

begin
  FHeightWoMargin := FHeight - FMarginTop;
  Left := frFloat2Str(GetLeft(Obj.AbsLeft));
  Top := frFloat2Str(GetTop(Obj.AbsTop));
  Right := frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width));
  Bottom := frFloat2Str(GetTop(Obj.AbsTop + Obj.Height));
  Width := frFloat2Str(Obj.Width * PDF_DIVIDER);
  Height := frFloat2Str(Obj.Height * PDF_DIVIDER);

  OldFrameWidth := 0;
  // Text
  if (Obj is TfrxCustomMemoView){ and (TfrxCustomMemoView(Obj).Rotation = 0)} and
     (TfrxCustomMemoView(Obj).BrushStyle in [bsSolid, bsClear]) and
     (not HTMLTags(TfrxCustomMemoView(Obj))) then
  begin
    // save clip to stack
    Write(OutStream, 'q'#13#10);
    Write(OutStream,  frFloat2Str(GetLeft(Obj.AbsLeft - Obj.Frame.Width)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + Obj.Height + Obj.Frame.Width)) + ' ' +
      frFloat2Str((Obj.Width + Obj.Frame.Width * 2) * PDF_DIVIDER) + ' ' + frFloat2Str((Obj.Height + Obj.Frame.Width * 2) * PDF_DIVIDER) + ' re'#13#10'W'#13#10'n'#13#10);
    ow := Obj.Width - Obj.Frame.ShadowWidth;
    oh := Obj.Height - Obj.Frame.ShadowWidth;
    // Shadow
    if Obj.Frame.DropShadow then
    begin
      Width := frFloat2Str(ow * PDF_DIVIDER);
      Height := frFloat2Str(oh * PDF_DIVIDER);
      Right := frFloat2Str(GetLeft(Obj.AbsLeft + ow));
      Bottom := frFloat2Str(GetTop(Obj.AbsTop + oh));
      s := AnsiString(GetPDFColor(Obj.Frame.ShadowColor));
      Write(OutStream, s + ' rg'#13#10 + s + ' RG'#13#10 +
        AnsiString(frFloat2Str(GetLeft(Obj.AbsLeft + ow)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + oh + Obj.Frame.ShadowWidth)) + ' ' +
        frFloat2Str(Obj.Frame.ShadowWidth * PDF_DIVIDER) + ' ' + frFloat2Str(oh * PDF_DIVIDER) + ' re'#13#10'B'#13#10 +
        frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Frame.ShadowWidth)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + oh + Obj.Frame.ShadowWidth)) + ' ' +
        frFloat2Str(ow * PDF_DIVIDER) + ' ' + frFloat2Str(Obj.Frame.ShadowWidth * PDF_DIVIDER) + ' re'#13#10'B'#13#10));
    end;
    if TfrxCustomMemoView(Obj).Highlight.Active and
       Assigned(TfrxCustomMemoView(Obj).Highlight.Font) then
    begin
      Obj.Font.Assign(TfrxCustomMemoView(Obj).Highlight.Font);
      Obj.Color := TfrxCustomMemoView(Obj).Highlight.Color;
    end;
    if Obj.Color <> clNone then
      Write(OutStream, GetPDFColor(Obj.Color) + ' rg'#13#10 + Left + ' ' + Bottom + ' ' +
        Width + ' ' + Height + ' re'#13#10'f'#13#10);
    // Frames
    MakeUpFrames;
{$IFDEF Delphi10}
    Lines := TfrxWideStrings.Create;
{$ELSE}
    Lines := TWideStrings.Create;
{$ENDIF}
    Lines.Text := TfrxCustomMemoView(Obj).WrapText(True);
    if Lines.Count > 0 then
    begin
      FontIndex := Parent.AddFont(Obj.Font);
      Write(OutStream, '/F' + IntToStr(TfrxPDFFont(Parent.FFonts[FontIndex]).Index - 1) +
        ' ' + IntToStr(Obj.Font.Size) + ' Tf'#13#10);
      if Obj.Font.Color <> clNone then
        TempColor := Obj.Font.Color
      else
        TempColor := clBlack;
      Write(OutStream, GetPDFColor(TempColor) + ' rg'#13#10);
      FCharSpacing := TfrxCustomMemoView(Obj).CharSpacing * PDF_DIVIDER;
      if TfrxCustomMemoView(Obj).CharSpacing <> 0 then
        Write(OutStream, frFloat2Str(FCharSpacing) + ' Tc'#13#10);

      pdfCS.Enter;
      try
        frxDrawText.SetFont(TfrxCustomMemoView(Obj).Font);
        frxDrawText.SetGaps(0, 0, TfrxCustomMemoView(Obj).LineSpacing);
        FLineHeight := frxDrawText.LineHeight;
        FTextHeight := frxDrawText.TextHeight;
        // Underlines by FuxMedia
        if TfrxCustomMemoView(Obj).Underlines then
        begin
          iz := Trunc(Obj.Height / FLineHeight);
          for i:= 0 to iz do
          begin
            y := GetTop(GetVTextPos(Obj.AbsTop + TfrxCustomMemoView(Obj).GapY + 1,
              Obj.Height - TfrxCustomMemoView(Obj).GapY * 2,
              'XYZ', TfrxCustomMemoView(Obj).VAlign, i, iz));
            Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
              frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
              Left + ' ' + frFloat2Str(y) + ' m'#13#10 +
              Right + ' ' + frFloat2Str(y) + ' l'#13#10'S'#13#10);
          end;
        end;
        // output lines of memo
        FUnderlineSize := Obj.Font.Size * 0.12;
        for i := 0 to Lines.Count - 1 do
        begin
          if i = 0 then
            PGap := TfrxCustomMemoView(Obj).ParagraphGap
          else
            PGap := 0;
          if TfrxCustomMemoView(Obj).RTLReading then
            su := Str2RTL(TruncReturns(Lines[i]))
          else
            su := TruncReturns(Lines[i]);
          if Length(Trim(su)) > 0 then
          begin
            // Text output
            if TfrxCustomMemoView(Obj).HAlign <> haRight then
              FCharSpacing := 0;
            s := UnicodeToANSI(su, CodepageByCharset(TfrxCustomMemoView(Obj).Font.Charset));
            if TfrxCustomMemoView(Obj).Font.Charset = OEM_CHARSET then
              s := OemToStr(s);

            x := FCharSpacing + GetLeft(GetHTextPos(Obj.AbsLeft + TfrxCustomMemoView(Obj).GapX + Obj.Font.Size * 0.01 + TfrxCustomMemoView(Obj).GapX / 2 + PGap,
              ow - TfrxCustomMemoView(Obj).GapX * 2 - PGap, TfrxCustomMemoView(Obj).CharSpacing, String(s), TfrxCustomMemoView(Obj).HAlign));
            y := GetTop(GetVTextPos(Obj.AbsTop + TfrxCustomMemoView(Obj).GapY - (Obj.Font.Size * 0.05) + TfrxCustomMemoView(Obj).GapY / 4,
              oh - TfrxCustomMemoView(Obj).GapY * 2, Lines[i], TfrxCustomMemoView(Obj).VAlign, i, Lines.Count));

            Write(OutStream, 'BT'#13#10);
            if TfrxCustomMemoView(Obj).Rotation > 0 then
            begin
              alpha := TfrxCustomMemoView(Obj).Rotation * Pi / 180;
              cosa := Cos(alpha);
              sina := Sin(alpha);
              rx := x - cosa * FTextWidth * PDF_DIVIDER / 2 + FTextWidth * PDF_DIVIDER / 2;
              ry := y - sina * FTextWidth * PDF_DIVIDER / 2;
              Write(OutStream, frFloat2Str(cosa) + ' ' + frFloat2Str(sina)  + ' ' + frFloat2Str(-sina) + ' ' + frFloat2Str(cosa) + ' ' + frFloat2Str(rx) + ' ' + frFloat2Str(ry) + ' Tm'#13#10);
            end
            else
              Write(OutStream, frFloat2Str(x) + ' ' + frFloat2Str(y) + ' Td'#13#10);
            Write(OutStream, '<' + StrToHex(s) + '> Tj'#13#10'ET'#13#10);
            // set Underline
            if (fsUnderline in (TfrxCustomMemoView(Obj).Font.Style)) and (TfrxCustomMemoView(Obj).Rotation = 0) then
              Write(OutStream, GetPDFColor(Obj.Font.Color) + ' RG'#13#10 +
                frFloat2Str(Obj.Font.Size * 0.08) + ' w'#13#10 +
                frFloat2Str(x) + ' ' + frFloat2Str(y - FUnderlineSize) + ' m'#13#10 +
                frFloat2Str(x +  (frxDrawText.Canvas.TextWidth(Lines[i]) / FDivider + Length(Lines[i]) * TfrxCustomMemoView(Obj).CharSpacing) * PDF_DIVIDER) +
                ' ' + frFloat2Str(y - FUnderlineSize) + ' l'#13#10'S'#13#10);
          end;
        end;
      finally
        pdfCS.Leave;
      end;
    end;
    // restore clip
    Write(OutStream, 'Q'#13#10);
    Lines.Free;
  end
  // Lines
  else if Obj is TfrxCustomLineView then
  begin
    Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      Left + ' ' + Top + ' m'#13#10 +
      Right + ' ' + Bottom + ' l'#13#10'S'#13#10);
    if TfrxCustomLineView(Obj).ArrowStart then
      DrawArrow(TfrxCustomLineView(Obj), GetLeft(Obj.AbsLeft + Obj.Width), GetTop(Obj.AbsTop + Obj.Height), GetLeft(Obj.AbsLeft), GetTop(Obj.AbsTop));
    if TfrxCustomLineView(Obj).ArrowEnd then
      DrawArrow(TfrxCustomLineView(Obj), GetLeft(Obj.AbsLeft), GetTop(Obj.AbsTop), GetLeft(Obj.AbsLeft + Obj.Width), GetTop(Obj.AbsTop + Obj.Height));
  end
  // Rects
  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skRectangle) then
  begin
    Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      GetPDFColor(Obj.Color) + ' rg'#13#10 +
      Left + ' ' + Bottom + ' '#13#10 +
      Width + ' ' + Height + ' re'#13#10);
    if Obj.Color <> clNone then
      Write(OutStream, 'B'#13#10)
    else
      Write(OutStream, 'S'#13#10);
  end
  // Shape line 1
  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skDiagonal1) then
    Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      Left + ' ' + Bottom + ' m'#13#10 + Right + ' ' + Top + ' l'#13#10'S'#13#10)
  // Shape line 2
  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skDiagonal2) then
    Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      Left + ' ' + Top + ' m'#13#10 + Right + ' ' + Bottom + ' l'#13#10'S'#13#10)
  else
  // Bitmaps
  if not ((Obj.Name = '_pagebackground') and (not Parent.Background)) and
     (Obj.Height > 0) and (Obj.Width > 0) then
  begin
    if Obj.Frame.Width > 0 then
    begin
      OldFrameWidth := Obj.Frame.Width;
      Obj.Frame.Width := 0;
    end;

    FRealBounds := Obj.GetRealBounds;
    dx := FRealBounds.Right - FRealBounds.Left;
    dy := FRealBounds.Bottom - FRealBounds.Top;

    if (dx = Obj.Width) or (Obj.AbsLeft = FRealBounds.Left) then
      fdx := 0
    else if (Obj.AbsLeft + Obj.Width) = FRealBounds.Right then
      fdx := (dx - Obj.Width)
    else
      fdx := (dx - Obj.Width) / 2;

    if (dy = Obj.Height) or (Obj.AbsTop = FRealBounds.Top) then
      fdy := 0
    else if (Obj.AbsTop + Obj.Height) = FRealBounds.Bottom then
      fdy := (dy - Obj.Height)
    else
      fdy := (dy - Obj.Height) / 2;

    TempBitmap := TBitmap.Create;
    TempBitmap.PixelFormat := pf24bit;

    if (Parent.PrintOptimized or (Obj is TfrxCustomMemoView)) and (Obj.BrushStyle in [bsSolid, bsClear]) then
      i := PDF_PRINTOPT
    else i := 1;

    iz := 0;

    if (Obj.ClassName = 'TfrxBarCodeView') and not Parent.PrintOptimized then
    begin
      i := 2;
      iz := i;
    end;

    TempBitmap.Width := Round(dx * i) + i;
    TempBitmap.Height := Round(dy * i) + i;

    Obj.Draw(TempBitmap.Canvas, i, i, -Round((Obj.AbsLeft - fdx) * i) + iz, -Round((Obj.AbsTop - fdy)* i));

    if dx <> 0 then
      BWidth := frFloat2Str(dx * PDF_DIVIDER)
    else
      BWidth := '1';
    if dy <> 0 then
      BHeight := frFloat2Str(dy * PDF_DIVIDER)
    else
      BHeight := '1';

    Write(OutStream, 'q'#13#10 + BWidth + ' 0 0 ' + BHeight + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft - fdx)) + ' ' +
      frFloat2Str(GetTop(Obj.AbsTop - fdy + dy)) + ' cm'#13#10'BI'#13#10 +
      '/W ' + IntToStr(TempBitmap.Width) + #13#10 +
      '/H ' + IntToStr(TempBitmap.Height) + #13#10'/CS /RGB'#13#10'/BPC 8'#13#10'/I true'#13#10'/F [/DCT]'#13#10'ID'#13#10);

    Jpg := TJPEGImage.Create;

    if (Obj.ClassName = 'TfrxBarCodeView') or
       (Obj is TfrxCustomLineView) or
       (Obj is TfrxShapeView) then
    begin
      Jpg.PixelFormat := jf8Bit;
      Jpg.CompressionQuality := 85;
    end
    else begin
      Jpg.PixelFormat := jf24Bit;
      Jpg.CompressionQuality := 80;
    end;

    Jpg.Assign(TempBitmap);
    Jpg.SaveToStream(OutStream);
    Jpg.Free;

    Write(OutStream, #13#10'EI'#13#10'Q'#13#10);
    TempBitmap.Free;
    if OldFrameWidth > 0 then
      Obj.Frame.Width := OldFrameWidth;
    MakeUpFrames;
  end;
end;

destructor TfrxPDFPage.Destroy;
begin
  FBMP.Free;
  inherited;
end;

{ TfrxPDFFont }

constructor TfrxPDFFont.Create;
begin
  inherited;
  FFont := TFont.Create;
end;

destructor TfrxPDFFont.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TfrxPDFFont.SaveToStream(const Stream: TStream);
var
  s: AnsiString;
  b: TBitmap;
  pm: ^OUTLINETEXTMETRICA;
  FontName: String;
  i: Cardinal;
  id: Integer;
  pfont: PAnsiChar;
  FirstChar, LastChar : Integer;
  MemStream: TMemoryStream;
  MemStream1: TMemoryStream;
  pwidths: PABC;
  Charset: TFontCharSet;

  // support DBCS font name encoding

  function PrepareFontName(const Font: TFont): String;
  begin
    Result := StringReplace(Font.Name, ' ', '#20', [rfReplaceAll]);
    Result := StringReplace(Result, '(', '#28', [rfReplaceAll]);
    Result := StringReplace(Result, ')', '#29', [rfReplaceAll]);
    s := '';
    if fsBold in Font.Style then
      s := s + 'Bold';
    if fsItalic in Font.Style then
      s := s + 'Italic';
    if s <> '' then
      Result := Result + ',' + String(s);
    Result := String(HexEncode7F(Result));
  end;

begin
  inherited SaveToStream(Stream);
  b := TBitmap.Create;
  try
    b.Canvas.Lock;
    b.Canvas.Font.Assign(Font);
    b.Canvas.Font.PixelsPerInch := 96;
    b.Canvas.Font.Size := 750;
    i := GetOutlineTextMetrics(b.Canvas.Handle, 0, nil);
    if i = 0 then
    begin
      b.Canvas.Font.Name := 'Arial';
      i := GetOutlineTextMetrics(b.Canvas.Handle, 0, nil);
    end;
    if i <> 0 then
    begin
      pm := GlobalAllocPtr(GMEM_MOVEABLE or GMEM_SHARE, i);
      try
        if pm <> nil then
          i := GetOutlineTextMetricsA(b.Canvas.Handle, i, pm)
        else
          i := 0;
        if i <> 0 then
        begin
          FirstChar := Ord(pm.otmTextMetrics.tmFirstChar);
          LastChar := Ord(pm.otmTextMetrics.tmLastChar);

          FontName := PrepareFontName(b.Canvas.Font);

          Charset := pm.otmTextMetrics.tmCharSet;

          if Font.Charset = OEM_CHARSET then
            Charset := GetDefFontCharSet;

          FFontDCnt := Parent.FFontDCnt;
          Inc(Parent.FObjNo);
          Parent.XRefAdd(Stream, Parent.FObjNo);
          WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
          Parent.FFontDCnt := Parent.FFontDCnt + 1;
          WriteLn(Stream, '<<');
          WriteLn(Stream, '/Type /Font');
          WriteLn(Stream, '/Name /F' + IntToStr(Index - 1));
          WriteLn(Stream, '/BaseFont /' + FontName);

          if not (Charset in [CHINESEBIG5_CHARSET, GB2312_CHARSET,SHIFTJIS_CHARSET,HANGEUL_CHARSET]) then
            WriteLn(Stream, '/Subtype /TrueType')
          else
            WriteLn(Stream, '/Subtype /Type0');

          case Charset of
            SYMBOL_CHARSET:
              WriteLn(Stream, '/Encoding /MacRomanEncoding');

            ANSI_CHARSET:
              WriteLn(Stream, '/Encoding /WinAnsiEncoding');

            RUSSIAN_CHARSET: {1251}
            begin
              WriteLn(Stream, '/Encoding <</Type/Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences');
              Write(Stream, ' [');
              Write(Stream, '129 /afii10052');
              Write(Stream, '/quotesinglbase/afii10100/quotedblbase/ellipsis/dagger/daggerdbl/Euro/perthousand/afii10058/guilsinglleft/afii10059/afii10061/afii10060/afii10145/afii10099/quoteleft');
              Write(Stream, '/quoteright/quotedblleft/quotedblright/bullet/endash/emdash/space/trademark/afii10106/guilsinglright/afii10107/afii10109/afii10108/afii10193/space/afii10062');
              Write(Stream, '/afii10110/afii10057/currency/afii10050/brokenbar/section/afii10023/copyright/afii10053/guillemotleft/logicalnot/hyphen/registered/afii10056/degree/plusminus');
              Write(Stream, '/afii10055/afii10103/afii10098/mu/paragraph/periodcentered/afii10071/afii61352/afii10101/guillemotright/afii10105/afii10054/afii10102/afii10104/afii10017/afii10018');
              Write(Stream, '/afii10019/afii10020/afii10021/afii10022/afii10024/afii10025/afii10026/afii10027/afii10028/afii10029/afii10030/afii10031/afii10032/afii10033/afii10034/afii10035');
              Write(Stream, '/afii10036/afii10037/afii10038/afii10039/afii10040/afii10041/afii10042/afii10043/afii10044/afii10045/afii10046/afii10047/afii10048/afii10049/afii10065/afii10066');
              Write(Stream, '/afii10067/afii10068/afii10069/afii10070/afii10072/afii10073/afii10074/afii10075/afii10076/afii10077/afii10078/afii10079/afii10080/afii10081/afii10082/afii10083');
              Write(Stream, '/afii10084/afii10085/afii10086/afii10087/afii10088/afii10089/afii10090/afii10091/afii10092/afii10093/afii10094/afii10095/afii10096/afii10097/space');
              WriteLn(Stream, ']');
              WriteLn(Stream, '>>');
            end;

            EASTEUROPE_CHARSET: {1250}
            begin
              WriteLn(Stream, '/Encoding <</Type/Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences [128 /Euro 140 /Sacute /Tcaron /Zcaron /Zacute');
              Write(Stream, ' 156 /sacute /tcaron /zcaron /zacute 161 /caron /breve /Lslash');
              Write(Stream, ' 165 /Aogonek 170 /Scedilla 175 /Zdotaccent 178 /ogonek /lslash');
              Write(Stream, ' 185 /aogonek /scedilla 188 /Lcaron /hungarumlaut /lcaron /zdotaccent /Racute');
              Write(Stream, ' 195 /Abreve 197 /Lacute /Cacute 200 /Ccaron 202 /Eogonek 204 /Ecaron 207 /Dcaron /Dslash');
              Write(Stream, ' 209 /Nacute /Ncaron /Oacute 213 /Ohungarumlaut 216 /Rcaron /Uring 219 /Uhungarumlaut');
              Write(Stream, ' 222 /Tcedilla 224 /racute 227 /abreve 229 /lacute /cacute /ccedilla /ccaron');
              Write(Stream, ' 234 /eogonek 236 /ecaron 239 /dcaron /dmacron /nacute /ncaron 245 /ohungarumlaut');
              Write(Stream, ' 248 /rcaron /uring 251 /uhungarumlaut 254 /tcedilla /dotaccent]');
              WriteLn(Stream, '>>');
            end;

            VIETNAMESE_CHARSET: {1258}
            begin
              WriteLn(Stream, '/Encoding <</Type /Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences [128 /Euro 130 /quotesinglbase /florin /quotedblbase /ellipsis');
              Write(Stream, ' /dagger /daggerdbl /circumflex /perthousand 139 /guilsinglleft');
              Write(Stream, ' /OE 145 /quoteleft /quoteright /quotedblleft /quotedblright');
              Write(Stream, ' /bullet /endash /emdash /tilde /trademark 155 /guilsinglright');
              Write(Stream, ' /oe 159 /Ydieresis /space /exclamdown /cent /sterling');
              Write(Stream, ' /currency /yen /brokenbar /section /dieresis /copyright');
              Write(Stream, ' /ordfeminine /guillemotleft /logicalnot /hyphen ');
              Write(Stream, ' /registered /macron /degree /plusminus /twosuperior');
              Write(Stream, ' /threesuperior /acute /mu /paragraph /periodcentered');
              Write(Stream, ' /cedilla /onesuperior /ordmasculine /guillemotright');
              Write(Stream, ' /onequarter /onehalf /threequarters /questiondown');
              Write(Stream, ' /Agrave /Aacute /Acircumflex /Abreve /Adieresis');
              Write(Stream, ' /Aring /AE /Ccedilla /Egrave /Eacute /Ecircumflex');
              Write(Stream, ' /Edieresis /gravetonecmb /Iacute /Icircumflex /Idieresis');
              Write(Stream, ' /Dcroat /Ntilde /hookabovecomb /Oacute /Ocircumflex');
              Write(Stream, ' /Ohorn /Odieresis /multiply /Oslash /Ugrave /Uacute');
              Write(Stream, ' /Ucircumflex /Udieresis /Uhorn /tildecomb /germandbls');
              Write(Stream, ' /agrave /aacute /acircumflex /abreve /adieresis /aring');
              Write(Stream, ' /ae /ccedilla /egrave /eacute /ecircumflex /edieresis');
              Write(Stream, ' /acutetonecmb /iacute /icircumflex /idieresis');
              Write(Stream, ' /dcroat /ntilde /dotbelowcomb /oacute /ocircumflex');
              Write(Stream, ' /ohorn /odieresis /divide /oslash /ugrave /uacute');
              Write(Stream, ' /ucircumflex /udieresis /uhorn /dong /ydieresis]');
              WriteLn(Stream, '>>');
            end;

            THAI_CHARSET: {874}
            begin
              WriteLn(Stream, '/Encoding <</Type /Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences [128 /Euro 133 /ellipsis 145 /quoteleft /quoteright /quotedblleft /quotedblright');
              Write(Stream, ' /bullet /endash /emdash 160 /space /kokaithai /khokhaithai /khokhuatthai');
              Write(Stream, ' /khokhwaithai /khokhonthai /khorakhangthai /ngonguthai /chochanthai');
              Write(Stream, ' /chochingthai /chochangthai /sosothai /chochoethai /yoyingthai /dochadathai');
              Write(Stream, ' /topatakthai /thothanthai /thonangmonthothai /thophuthaothai /nonenthai');
              Write(Stream, ' /dodekthai /totaothai /thothungthai /thothahanthai /thothongthai');
              Write(Stream, ' /nonuthai /bobaimaithai /poplathai /phophungthai /fofathai /phophanthai');
              Write(Stream, ' /fofanthai /phosamphaothai /momathai /yoyakthai /roruathai /ruthai /lolingthai');
              Write(Stream, ' /luthai /wowaenthai /sosalathai /sorusithai /sosuathai /hohipthai /lochulathai');
              Write(Stream, ' /oangthai /honokhukthai /paiyannoithai /saraathai /maihanakatthai /saraaathai');
              Write(Stream, ' /saraamthai /saraithai /saraiithai /sarauethai /saraueethai /sarauthai /sarauuthai');
              Write(Stream, ' /phinthuthai 223 /bahtthai /saraethai /saraaethai /saraothai /saraaimaimuanthai ');
              Write(Stream, ' /saraaimaimalaithai /lakkhangyaothai /maiyamokthai /maitaikhuthai /maiekthai /maithothai');
              Write(Stream, ' /maitrithai /maichattawathai /thanthakhatthai /nikhahitthai /yamakkanthai /fongmanthai');
              Write(Stream, ' /zerothai /onethai /twothai /threethai /fourthai /fivethai /sixthai /seventhai /eightthai');
              Write(Stream, ' /ninethai /angkhankhuthai /khomutthai]');
              WriteLn(Stream, '>>');
            end;

            GREEK_CHARSET: {1253}
            begin
              WriteLn(Stream, '/Encoding <</Type/Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences [ 128 /Euro 160 /quoteleft/quoteright 175 /afii00208');
              Write(Stream, ' 180 /tonos/dieresistonos/Alphatonos');
              Write(Stream, ' 184 /Epsilontonos/Etatonos/Iotatonos');
              Write(Stream, ' 188 /Omicrontonos 190 /Upsilontonos');
              Write(Stream, '/Omegatonos/iotadieresistonos/Alpha/Beta/Gamma/Delta/Epsilon/Zeta');
              Write(Stream, '/Eta/Theta/Iota/Kappa/Lambda/Mu/Nu/Xi/Omicron/Pi/Rho');
              Write(Stream, ' 211 /Sigma/Tau/Upsilon/Phi');
              Write(Stream, '/Chi/Psi/Omega/Iotadieresis/Upsilondieresis/alphatonos/epsilontonos');
              Write(Stream, '/etatonos/iotatonos/upsilondieresistonos/alpha/beta/gamma/delta/epsilon');
              Write(Stream, '/zeta/eta/theta/iota/kappa/lambda/mu/nu/xi/omicron/pi/rho/sigma1/sigma');
              Write(Stream, '/tau/upsilon/phi/chi/psi/omega/iotadieresis/upsilondieresis/omicrontonos');
              Write(Stream, '/upsilontonos/omegatonos ]');
              WriteLn(Stream, '>>');
            end;

            TURKISH_CHARSET: {1254}
            begin
              WriteLn(Stream, '/Encoding <</Type/Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences [ 128 /Euro');
              Write(Stream, ' 130 /quotesinglbase/florin/quotedblbase/ellipsis/dagger');
              Write(Stream, ' /daggerdbl/circumflex/perthousand/Scaron/guilsinglleft/OE');
              Write(Stream, ' 145 /quoteleft/quoteright/quotedblleft/quotedblright');
              Write(Stream, ' /bullet/endash/emdash/tilde/trademark/scaron/guilsinglright/oe');
              Write(Stream, ' 159 /Ydieresis 208 /Gbreve 221 /Idotaccent/Scedilla');
              Write(Stream, ' 240 /gbreve 253 /dotlessi/scedilla]');
              WriteLn(Stream, '>>');
            end;

            HEBREW_CHARSET: {1255}
            begin
              WriteLn(Stream, '/Encoding <</Type/Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences [ 128 /Euro 130 /quotesinglbase/florin/quotedblbase/ellipsis');
              Write(Stream, ' /dagger/daggerdbl/circumflex/perthousand 139 /guilsinglleft');
              Write(Stream, ' 145 /quoteleft/quoteright/quotedblleft/quotedblright');
              Write(Stream, ' /bullet/endash/emdash/tilde/trademark 155 /perthousand');
              Write(Stream, ' 164 /afii57636 170 /multiply 186 /divide');
              Write(Stream, ' 192 /afii57799/afii57801/afii57800/afii57802/afii57793');
              Write(Stream, ' /afii57794/afii57795/afii57798/afii57797/afii57806');
              Write(Stream, ' 203 /afii57796/afii57807/afii57839/afii57645/afii57841/afii57842');
              Write(Stream, ' /afii57804/afii57803/afii57658/afii57716/afii57717/afii57718');
              Write(Stream, ' 224 /afii57664/afii57665/afii57666/afii57667/afii57668/afii57669');
              Write(Stream, ' /afii57670/afii57671/afii57672/afii57673/afii57674/afii57675');
              Write(Stream, ' /afii57676/afii57677/afii57678/afii57679/afii57680/afii57681');
              Write(Stream, ' /afii57682/afii57683/afii57684/afii57685/afii57686/afii57687');
              Write(Stream, ' /afii57688/afii57689/afii57690 253 /afii299/afii300]');
              WriteLn(Stream, '>>');
            end;

            ARABIC_CHARSET:
            begin
              WriteLn(Stream, '/Encoding <</Type/Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences [ 128 /Euro/afii57506/quotesinglbase/florin/quotedblbase');
              Write(Stream, '/ellipsis/dagger/daggerdbl/circumflex/perthousand/afii57511');
              Write(Stream, '/guilsinglleft/OE/afii57507/afii57508');
              Write(Stream, ' 144 /afii57509/quoteleft/quoteright/quotedblleft');
              Write(Stream, '/quotedblright/bullet/endash/emdash');
              Write(Stream, ' 153 /trademark/afii57513/guilsinglright/oe/afii61664');
              Write(Stream, '/afii301/afii57514 161 /afii57388');
              Write(Stream, ' 186 /afii57403 191 /afii57407');
              Write(Stream, ' 193 /afii57409/afii57410/afii57411/afii57412/afii57413');
              Write(Stream, '/afii57414/afii57415/afii57416/afii57417/afii57418/afii57419');
              Write(Stream, '/afii57420/afii57421/afii57422/afii57423/afii57424/afii57425');
              Write(Stream, '/afii57426/afii57427/afii57428/afii57429/afii57430');
              Write(Stream, ' 216 /afii57431/afii57432/afii57433/afii57434/afii57440');
              Write(Stream, '/afii57441/afii57442/afii57443/afii57444');
              Write(Stream, ' 227 /afii57445/afii57446/afii57470/afii57448/afii57449');
              Write(Stream, '/afii57450 240 /afii57451/afii57452/afii57453/afii57454');
              Write(Stream, '/afii57455/afii57456 248 /afii57457 250 /afii57458');
              Write(Stream, ' 253 /afii299/afii300/afii57519]');
              WriteLn(Stream, '>>');
            end;

            BALTIC_CHARSET:
            begin
              WriteLn(Stream, '/Encoding <</Type/Encoding /BaseEncoding /WinAnsiEncoding');
              Write(Stream, '/Differences [ 128 /Euro /space /quotesinglbase /space /quotedblbase');
              Write(Stream, ' /ellipsis /dagger /daggerdbl /space /perthousand');
              Write(Stream, ' /space /guilsinglleft /space /dieresis /caron');
              Write(Stream, ' /cedilla /space /quoteleft /quoteright /quotedblleft');
              Write(Stream, ' /quotedblright /bullet /endash /emdash /space /trademark');
              Write(Stream, ' /space /guilsinglright /space /macron /ogonek /space');
              Write(Stream, ' 170 /Rcommaaccent 175 /AE 184 /oslash 186 /rcommaaccent');
              Write(Stream, ' 191 /ae /Aogonek /Iogonek /Amacron /Cacute 198 /Eogonek');
              Write(Stream, ' /Emacron /Ccaron 202 /Zacute /Edotaccent /Gcommaaccent');
              Write(Stream, ' /Kcommaaccent /Imacron /Lcommaaccent /Scaron /Nacute');
              Write(Stream, ' /Ncommaaccent /trademark /Omacron 216 /Uogonek /Lslash');
              Write(Stream, ' /Sacute /Umacron 221 /Zdotaccent /Zcaron 224 /aogonek');
              Write(Stream, ' /iogonek /amacron /cacute 230 /eogonek /emacron /ccaron');
              Write(Stream, ' 234 /zacute /edotaccent /gcommaaccent /kcommaaccent');
              Write(Stream, ' /imacron /lcommaaccent /scaron /nacute /ncommaaccent');
              Write(Stream, ' 244 /omacron 248 /uogonek /lslash /OE /umacron 253');
              Write(Stream, ' /zdotaccent /zcaron /dotaccent ]');
              WriteLn(Stream, '>>');
            end;

            CHINESEBIG5_CHARSET: {136}
            begin
              WriteLn(Stream, '/DescendantFonts [' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R]');
              WriteLn(Stream, '/Encoding /ETenms-B5-H');
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
              Inc(Parent.FObjNo);
              Parent.XRefAdd(Stream, Parent.FObjNo);

              WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
              Parent.FFontDCnt := Parent.FFontDCnt + 1;
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Type /Font');
              WriteLn(Stream, '/Subtype');
              WriteLn(Stream, '/CIDFontType2');
              WriteLn(Stream, '/BaseFont /'+ HexEncode7F(FontName));
              WriteLn(Stream, '/WinCharSet 136');
              WriteLn(Stream, '/FontDescriptor ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
              WriteLn(Stream, '/CIDSystemInfo');
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Registry(Adobe)');
              WriteLn(Stream, '/Ordering(CNS1)');
              WriteLn(Stream, '/Supplement 0');
              WriteLn(Stream, '>>');
              WriteLn(Stream, '/DW 1000');
              WriteLn(Stream, '/W [1 95 500]');
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
              Inc(Parent.FObjNo);
              Parent.XRefAdd(Stream, Parent.FObjNo);
              
              WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
              Parent.FFontDCnt := Parent.FFontDCnt + 1;
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Type /FontDescriptor');
              if Parent.FEmbedded then
                 WriteLn(Stream, '/FontFile2 ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
              WriteLn(Stream, '/FontName /' + HexEncode7F(FontName));
              WriteLn(Stream, '/Flags 7');
              WriteLn(Stream, '/FontBBox [' + IntToStr(pm^.otmrcFontBox.Left) + ' '+ IntToStr(pm^.otmrcFontBox.Bottom) + ' '+ IntToStr(pm^.otmrcFontBox.Right) + ' '+ IntToStr(pm^.otmrcFontBox.Top) + ' ]');
              WriteLn(Stream, '/Style << /Panose <010502020300000000000000> >>');
              WriteLn(Stream, '/Ascent ' + IntToStr(pm^.otmAscent));
              WriteLn(Stream, '/Descent ' + IntToStr(pm^.otmDescent));
              WriteLn(Stream, '/CapHeight ' + IntToStr(pm^.otmTextMetrics.tmHeight));
              WriteLn(Stream, '/StemV ' + IntToStr(50 + Round(sqr(pm^.otmTextMetrics.tmWeight / 65))));
              WriteLn(Stream, '/ItalicAngle ' + IntToStr(pm^.otmItalicAngle));
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
            end;

            GB2312_CHARSET: {134}
            begin
              WriteLn(Stream, '/DescendantFonts [' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R]');  
              WriteLn(Stream, '/Encoding /GB-EUC-H');
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
              Inc(Parent.FObjNo);
              Parent.XRefAdd(Stream, Parent.FObjNo);

              WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
              Parent.FFontDCnt := Parent.FFontDCnt + 1; 
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Type /Font');
              WriteLn(Stream, '/Subtype');
              WriteLn(Stream, '/CIDFontType2');
              WriteLn(Stream, '/BaseFont /'+ HexEncode7F(FontName));
              WriteLn(Stream, '/WinCharSet 134');
              WriteLn(Stream, '/FontDescriptor ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');  
              WriteLn(Stream, '/CIDSystemInfo');
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Registry(Adobe)');
              WriteLn(Stream, '/Ordering(GB1)');
              WriteLn(Stream, '/Supplement 2');
              WriteLn(Stream, '>>');
              WriteLn(Stream, '/DW 1000');
              WriteLn(Stream, '/W [ 1 95 500 814 939 500 7712 [ 500 ] 7716 [ 500 ] ]');
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
              Inc(Parent.FObjNo);
              Parent.XRefAdd(Stream, Parent.FObjNo);

              WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
              Parent.FFontDCnt := Parent.FFontDCnt + 1; 
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Type /FontDescriptor');
              if Parent.FEmbedded then
                 WriteLn(Stream, '/FontFile2 ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
              WriteLn(Stream, '/FontName /' + HexEncode7F(FontName));
              WriteLn(Stream, '/Flags 6');
              WriteLn(Stream, '/FontBBox [' + IntToStr(pm^.otmrcFontBox.Left) + ' '+ IntToStr(pm^.otmrcFontBox.Bottom) + ' '+ IntToStr(pm^.otmrcFontBox.Right) + ' '+ IntToStr(pm^.otmrcFontBox.Top) + ' ]');
              WriteLn(Stream, '/Style << /Panose <010502020400000000000000> >>');
              WriteLn(Stream, '/Ascent ' + IntToStr(pm^.otmAscent));
              WriteLn(Stream, '/Descent ' + IntToStr(pm^.otmDescent));
              WriteLn(Stream, '/CapHeight ' + IntToStr(pm^.otmTextMetrics.tmHeight));
              WriteLn(Stream, '/StemV ' + IntToStr(50 + Round(sqr(pm^.otmTextMetrics.tmWeight / 65))));
              WriteLn(Stream, '/ItalicAngle ' + IntToStr(pm^.otmItalicAngle));
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
            end;

            SHIFTJIS_CHARSET: {80}
            begin
              WriteLn(Stream, '/DescendantFonts [' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R]');
              WriteLn(Stream, '/Encoding /90msp-RKSJ-H');
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
              Inc(Parent.FObjNo);
              Parent.XRefAdd(Stream, Parent.FObjNo);

              WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
              Parent.FFontDCnt := Parent.FFontDCnt + 1;
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Type /Font');
              WriteLn(Stream, '/Subtype');
              WriteLn(Stream, '/CIDFontType2');
              WriteLn(Stream, '/BaseFont /'+ HexEncode7F(FontName));
              WriteLn(Stream, '/WinCharSet 80');
              Write(Stream, '/FontDescriptor ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
              WriteLn(Stream, '/CIDSystemInfo');
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Registry(Adobe)');
              WriteLn(Stream, '/Ordering(Japan1)');
              WriteLn(Stream, '/Supplement 2');
              WriteLn(Stream, '>>');
              WriteLn(Stream, '/DW 1000');
              WriteLn(Stream, '/W [ 1 95 500 231 632 500 ]');
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
              Inc(Parent.FObjNo);
              Parent.XRefAdd(Stream, Parent.FObjNo);
              WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
              Parent.FFontDCnt := Parent.FFontDCnt + 1;
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Type /FontDescriptor');
              if Parent.FEmbedded then
                WriteLn(Stream, '/FontFile2 ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
              WriteLn(Stream, '/FontName /' + HexEncode7F(FontName));
              WriteLn(Stream, '/Flags 6');
              WriteLn(Stream, '/FontBBox [' + IntToStr(pm^.otmrcFontBox.Left) + ' '+ IntToStr(pm^.otmrcFontBox.Bottom) + ' '+ IntToStr(pm^.otmrcFontBox.Right) + ' '+ IntToStr(pm^.otmrcFontBox.Top) + ' ]');
              WriteLn(Stream, '/Style << /Panose <010502020400000000000000> >>');
              WriteLn(Stream, '/Ascent ' + IntToStr(pm^.otmAscent));
              WriteLn(Stream, '/Descent ' + IntToStr(pm^.otmDescent));
              WriteLn(Stream, '/CapHeight ' + IntToStr(pm^.otmTextMetrics.tmHeight));
              WriteLn(Stream, '/StemV ' + IntToStr(50 + Round(sqr(pm^.otmTextMetrics.tmWeight / 65))));
              WriteLn(Stream, '/ItalicAngle ' + IntToStr(pm^.otmItalicAngle));
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
            end;

            HANGEUL_CHARSET: {129}
            begin
              WriteLn(Stream, '/DescendantFonts [' + IntToStr(Index + 1 + Parent.FStartFonts) + ' 0 R]');
              WriteLn(Stream, '/Encoding /KSCms-UHC-H');
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
              Inc(Parent.FObjNo);
              Parent.XRefAdd(Stream, Parent.FObjNo);

              WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
              Parent.FFontDCnt := Parent.FFontDCnt + 1;
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Type /Font');
              WriteLn(Stream, '/Subtype');
              WriteLn(Stream, '/CIDFontType2');
              WriteLn(Stream, '/BaseFont /'+ HexEncode7F(FontName));
              WriteLn(Stream, '/WinCharSet 129');
              Write(Stream, '/FontDescriptor '+ IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
              WriteLn(Stream, '/CIDSystemInfo');
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Registry(Adobe)');
              WriteLn(Stream, '/Ordering(Korea1)');
              WriteLn(Stream, '/Supplement 1');
              WriteLn(Stream, '>>');
              WriteLn(Stream, '/DW 1000');
              WriteLn(Stream, '/W [ 1 95 500 8094 8190 500 ]');
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
              Inc(Parent.FObjNo);
              Parent.XRefAdd(Stream, Parent.FObjNo);

              WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
              Parent.FFontDCnt := Parent.FFontDCnt + 1;
              WriteLn(Stream, '<<');
              WriteLn(Stream, '/Type /FontDescriptor ');
              if Parent.FEmbedded then
                 WriteLn(Stream, '/FontFile2 ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
              WriteLn(Stream, '/FontName /' + HexEncode7F(FontName));
              WriteLn(Stream, '/Flags 6');
              WriteLn(Stream, '/FontBBox [' + IntToStr(pm^.otmrcFontBox.Left) + ' '+ IntToStr(pm^.otmrcFontBox.Bottom) + ' '+ IntToStr(pm^.otmrcFontBox.Right) + ' '+ IntToStr(pm^.otmrcFontBox.Top) + ' ]');
              WriteLn(Stream, '/Style << /Panose <010502020400000000000000> >>');
              WriteLn(Stream, '/Ascent ' + IntToStr(pm^.otmAscent));
              WriteLn(Stream, '/Descent ' + IntToStr(pm^.otmDescent));
              WriteLn(Stream, '/CapHeight ' + IntToStr(pm^.otmTextMetrics.tmHeight));
              WriteLn(Stream, '/StemV ' + IntToStr(50 + Round(sqr(pm^.otmTextMetrics.tmWeight / 65))));
              WriteLn(Stream, '/ItalicAngle ' + IntToStr(pm^.otmItalicAngle));
              WriteLn(Stream, '>>');
              WriteLn(Stream, 'endobj');
            end;
          end;

          if not (Charset in [CHINESEBIG5_CHARSET, GB2312_CHARSET, SHIFTJIS_CHARSET, HANGEUL_CHARSET]) then
          begin
            WriteLn(Stream, '/FontDescriptor ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
            WriteLn(Stream, '/FirstChar ' + IntToStr(FirstChar));
            WriteLn(Stream, '/LastChar ' + IntToStr(LastChar));
            pwidths := GlobalAllocPtr(GMEM_MOVEABLE or GMEM_SHARE, SizeOf(ABCArray));
            try
              Write(Stream, '/Widths [');
              GetCharABCWidthsA(b.Canvas.Handle, FirstChar, LastChar, pwidths^);
              for i := 0 to (LastChar - FirstChar) do
                Write(Stream, IntToStr(pwidths^[i].abcA + Integer(pwidths^[i].abcB) + pwidths^[i].abcC) + ' ');
              WriteLn(Stream, ']');
            finally
              GlobalFreePtr(pwidths);
            end;
            WriteLn(Stream, '>>');
            WriteLn(Stream, 'endobj');
            Inc(Parent.FObjNo);
            Parent.XRefAdd(Stream, Parent.FObjNo);
            WriteLn(Stream, IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 obj');
            Parent.FFontDCnt := Parent.FFontDCnt + 1;
            WriteLn(Stream, '<<');
            WriteLn(Stream, '/Type /FontDescriptor');
            WriteLn(Stream, '/FontName /' + FontName);
            WriteLn(Stream, '/Flags 32');
            WriteLn(Stream, '/FontBBox [' + IntToStr(pm^.otmrcFontBox.Left) + ' '+ IntToStr(pm^.otmrcFontBox.Bottom) + ' '+ IntToStr(pm^.otmrcFontBox.Right) + ' '+ IntToStr(pm^.otmrcFontBox.Top) + ' ]');
            WriteLn(Stream, '/ItalicAngle ' + IntToStr(pm^.otmItalicAngle));
            WriteLn(Stream, '/Ascent ' + IntToStr(pm^.otmAscent));
            WriteLn(Stream, '/Descent ' + IntToStr(pm^.otmDescent));
            WriteLn(Stream, '/Leading ' + IntToStr(pm^.otmTextMetrics.tmInternalLeading));
            WriteLn(Stream, '/CapHeight ' + IntToStr(pm^.otmTextMetrics.tmHeight));
            WriteLn(Stream, '/StemV ' + IntToStr(50 + Round(sqr(pm^.otmTextMetrics.tmWeight / 65))));
            WriteLn(Stream, '/AvgWidth ' + IntToStr(pm^.otmTextMetrics.tmAveCharWidth));
            WriteLn(Stream, '/MaxWidth ' + IntToStr(pm^.otmTextMetrics.tmMaxCharWidth));
            WriteLn(Stream, '/MissingWidth ' + IntToStr(pm^.otmTextMetrics.tmAveCharWidth));
            if Parent.FEmbedded then
              WriteLn(Stream, '/FontFile2 ' + IntToStr(Parent.FFontDCnt + Parent.FStartFonts) + ' 0 R');
            WriteLn(Stream, '>>');
            WriteLn(Stream, 'endobj');
          end;

          if Parent.FEmbedded then
          begin
            Inc(Parent.FObjNo);
            Parent.XRefAdd(Stream, Parent.FObjNo);
            id := Parent.FFontDCnt + Parent.FStartFonts;
            WriteLn(Stream, IntToStr(id) + ' 0 obj');
            Parent.FFontDCnt := Parent.FFontDCnt + 1;
            i := GetFontData(b.Canvas.Handle, 0, 0, nil, 1);
            pfont := GlobalAllocPtr(GMEM_MOVEABLE or GMEM_SHARE, i);
            try
              i := GetFontData(b.Canvas.Handle, 0, 0, pfont, i);
              MemStream := TMemoryStream.Create;
              try
                MemStream.Write(pfont^, i);
                MemStream1 := TMemoryStream.Create;
                try
                  frxDeflateStream(MemStream, MemStream1, gzMax);
                  WriteLn(Stream, '<< /Length ' + IntToStr(MemStream1.Size) + ' /Filter /FlateDecode /Length1 ' + IntToStr(MemStream.Size) + ' >>');
                  WriteLn(Stream, 'stream');
                  if Parent.Protection then
                    CryptStream(MemStream1, Stream, Parent.FEncKey, id)
                  else
                    Stream.CopyFrom(MemStream1, 0);
                finally
                  MemStream1.Free;
                end;
              finally
                MemStream.Free;
              end;
            finally
              GlobalFreePtr(pfont);
            end;
            WriteLn(Stream, '');
            WriteLn(Stream, 'endstream');
            WriteLn(Stream, 'endobj');
          end;
        end;
      finally
        GlobalFreePtr(pm);
      end;
    end
    else
      Exception.Create('Error on get font info');
  finally
    b.Canvas.Unlock;
    b.Free;
  end;
end;

{ TfrxPDFElement }

constructor TfrxPDFElement.Create;
begin
  FIndex := 0;
  FXrefPosition := 0;
  FCR := False;
end;

procedure TfrxPDFElement.Write(Stream: TStream; const S: AnsiString);
begin
  Stream.Write(S[1], Length(S));
end;

procedure TfrxPDFElement.WriteLn(Stream: TStream; const S: AnsiString);
begin
  Stream.Write(S[1], Length(S));
{$IFDEF Delphi12}
  Stream.Write(AnsiChar(#13)+AnsiChar(#10), 2);
{$ELSE}
  Stream.Write(#13#10, 2);
{$ENDIF}
end;

{$IFDEF Delphi12}
procedure TfrxPDFElement.WriteLn(Stream: TStream; const S: String);
begin
  WriteLn(Stream, AnsiString(s));
end;

procedure TfrxPDFElement.Write(Stream: TStream; const S: String);
begin
  Write(Stream, AnsiString(S));
end;
{$ENDIF}

procedure TfrxPDFElement.SaveToStream(const Stream: TStream);
begin
  FXrefPosition := Stream.Position;
end;

{ TfrxPDFOutlineNode }

constructor TfrxPDFOutlineNode.Create;
begin
  Title := '';
  Dest := -1;
  Number := 0;
  Count := 0;
  CountTree :=0;
  Parent := nil;
  First := nil;
  Prev := nil;
  Next := nil;
  Last := nil;
end;

destructor TfrxPDFOutlineNode.Destroy;
begin
  if Next <> nil then
    Next.Free;
  if First <> nil then
    First.Free;
  inherited;
end;

initialization
  pdfCS := TCriticalSection.Create;

finalization
  pdfCS.Free;

end.

