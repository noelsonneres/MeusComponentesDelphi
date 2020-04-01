{*******************************************************}
{    The Delphi Unicode Controls Project                }
{                                                       }
{      http://home.ccci.org/wolbrink                    }
{                                                       }
{ Copyright (c) 2002, Troy Wolbrink (wolbrink@ccci.org) }
{                                                       }
{*******************************************************}

unit frxUnicodeUtils;
{$I frx.inc}
{$IFDEF NOUSEFRUNICODEUTILS}
// we use LazHelper
interface
implementation
{$ELSE}
interface


uses Windows, Classes, SysUtils
{$IFDEF Delphi10}
  , WideStrings
{$ENDIF};

type
  TWString = record
    WString: WideString;
    Obj: TObject;
  end;
{$IFDEF Delphi10}
  TfrxWideStrings = class(TWideStrings)
  private
    FWideStringList: TList;
    procedure ReadData(Reader: TReader);
{$IFDEF Delphi12}
    procedure ReadDataWOld(Reader: TReader);
{$ENDIF}
    procedure ReadDataW(Reader: TReader);
    procedure WriteDataW(Writer: TWriter);
  protected
    function Get(Index: Integer): WideString; override;
    procedure Put(Index: Integer; const S: WideString); override;
    function GetObject(Index: Integer): TObject; override;
    procedure PutObject(Index: Integer; Value: TObject); override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure DefineProperties(Filer: TFiler); override;
    function GetTextStr: WideString; override;
    procedure SetTextStr(const Value: WideString); override;
    function GetCount: Integer; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    function Add(const S: WideString): Integer; override;
    procedure AddStrings(Strings: TWideStrings); override;
    function AddObject(const S: WideString; AObject: TObject): Integer; override;
    function IndexOf(const S: WideString): Integer; override;
    procedure Insert(Index: Integer; const S: WideString); override;
    procedure LoadFromFile(const FileName: WideString); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure LoadFromWStream(Stream: TStream);
    procedure SaveToFile(const FileName: WideString); override;
    procedure SaveToStream(Stream: TStream); override;
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
    property Strings[Index: Integer]: WideString read Get write Put; default;
    property Text: WideString read GetTextStr write SetTextStr;
  end;
{$ELSE}
  TWideStrings = class(TPersistent)
  private
    FWideStringList: TList;
    procedure ReadData(Reader: TReader);
    procedure ReadDataW(Reader: TReader);
    procedure WriteDataW(Writer: TWriter);
  protected
    function Get(Index: Integer): WideString;
    procedure Put(Index: Integer; const S: WideString);
    function GetObject(Index: Integer): TObject;
    procedure PutObject(Index: Integer; Value: TObject);
    procedure AssignTo(Dest: TPersistent); override;
    procedure DefineProperties(Filer: TFiler); override;
    function GetTextStr: WideString;
    procedure SetTextStr(const Value: WideString);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function Count: Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Add(const S: WideString): Integer;
    procedure AddStrings(Strings: TWideStrings);
    function AddObject(const S: WideString; AObject: TObject): Integer;
    function IndexOf(const S: WideString): Integer;
    function Equals(Strings: TWideStrings): Boolean;
    procedure Insert(Index: Integer; const S: WideString);
    procedure LoadFromFile(const FileName: WideString);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromWStream(Stream: TStream);
    procedure SaveToFile(const FileName: WideString);
    procedure SaveToStream(Stream: TStream);
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
    property Strings[Index: Integer]: WideString read Get write Put; default;
    property Text: WideString read GetTextStr write SetTextStr;
  end;
{$ENDIF}

function AnsiToUnicode(const s: AnsiString; Charset: UINT; CodePage: Integer = 0): WideString;
function _UnicodeToAnsi(const WS: WideString; Charset: UINT; CodePage: Integer = 0): Ansistring;
function OemToStr(const AnsiStr: AnsiString): AnsiString;
function CharSetToCodePage(ciCharset: DWORD): Cardinal;
function GetLocalByCharSet(Charset: UINT): Cardinal;


implementation

const
  sLineBreak = #13#10;
  WideLineSeparator = WideChar($2028);
  NameValueSeparator = '=';


function OemToStr(const AnsiStr: AnsiString): AnsiString;
begin
  SetLength(Result, Length(AnsiStr));
  if Length(Result) > 0 then
    OemToAnsiBuff(PAnsiChar(AnsiStr), PAnsiChar(Result), Length(Result));
end;

{ TWideStrings }
constructor {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Create;
begin
  FWideStringList := TList.Create;
end;

destructor {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Destroy;
begin
  Clear;
  FWideStringList.Free;
  inherited;
end;

{$IFNDEF Delphi10}
function TWideStrings.Equals(Strings: TWideStrings): Boolean;
var
  I, aCount: Integer;
begin
  Result := False;
  aCount := Count;
  if aCount <> Strings.Count then Exit;
  for I := 0 to Count - 1 do if Get(I) <> Strings.Get(I) then Exit;
  Result := True;
end;
{$ENDIF}

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Clear;
var
  Index: Integer;
  PWStr: ^TWString;
begin
  for Index := 0 to FWideStringList.Count-1 do
  begin
    PWStr := FWideStringList.Items[Index];
    if PWStr <> nil then
      Dispose(PWStr);
  end;
  FWideStringList.Clear;
end;

function {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Get(Index: Integer): WideString;
var
  PWStr: ^TWString;
begin
  Result := '';
  if ( (Index >= 0) and (Index < FWideStringList.Count) ) then
  begin
    PWStr := FWideStringList.Items[Index];
    if PWStr <> nil then
      Result := PWStr^.WString;
  end;
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Put(Index: Integer; const S: WideString);
begin
  Insert(Index, S);
end;

function {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.GetObject(Index: Integer): TObject;
var
  PWStr: ^TWString;
begin
  Result := nil;
  if ( (Index >= 0) and (Index < FWideStringList.Count) ) then
  begin
    PWStr := FWideStringList.Items[Index];
    if PWStr <> nil then
      Result := PWStr^.Obj;
  end;
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.PutObject(Index: Integer; Value: TObject);
var
  PWStr: ^TWString;
begin
  if ( (Index >= 0) and (Index < FWideStringList.Count) ) then
  begin
    PWStr := FWideStringList.Items[Index];
    if PWStr <> nil then
      PWStr^.Obj := Value;
  end;
end;

function {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Add(const S: WideString): Integer;
var
  PWStr: ^TWString;
begin
  New(PWStr);
  PWStr^.WString := S;
  PWStr^.Obj := nil;
  Result := FWideStringList.Add(PWStr);
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Delete(Index: Integer);
var
  PWStr: ^TWString;
begin
  PWStr := FWideStringList.Items[Index];
  if PWStr <> nil then
    Dispose(PWStr);
  FWideStringList.Delete(Index);
end;

function {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.IndexOf(const S: WideString): Integer;
var
  Index: Integer;
  PWStr: ^TWString;
begin
  Result := -1;
  for Index := 0 to FWideStringList.Count -1 do
  begin
    PWStr := FWideStringList.Items[Index];
    if PWStr <> nil then
    begin
      if S = PWStr^.WString then
      begin
        Result := Index;
        break;
      end;
    end;
  end;
end;

{$IFDEF Delphi10}
function TfrxWideStrings.GetCount: Integer;
begin
  Result := FWideStringList.Count;
end;
{$ELSE}
function TWideStrings.Count: Integer;
begin
  Result := FWideStringList.Count;
end;
{$ENDIF}

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Insert(Index: Integer; const S: WideString);
var
  PWStr: ^TWString;
begin
  if((Index < 0) or (Index > FWideStringList.Count)) then
    raise Exception.Create('Wide String Out of Bounds');
  if Index < FWideStringList.Count then
  begin
    PWStr := FWideStringList.Items[Index];
    if PWStr <> nil then
      PWStr.WString := S;
  end
  else
    Add(S);
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.AddStrings(Strings: TWideStrings);
var
  I: Integer;
begin
  for I := 0 to Strings.Count - 1 do
    AddObject(Strings[I], Strings.Objects[I]);
end;

function {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.AddObject(const S: WideString; AObject: TObject): Integer;
begin
  Result := Add(S);
  PutObject(Result, AObject);
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TWideStrings then
  begin
    Clear;
    AddStrings(TWideStrings(Source));
  end
  else if Source is TStrings then
  begin
    Clear;
    for I := 0 to TStrings(Source).Count - 1 do
      AddObject(TStrings(Source)[I], TStrings(Source).Objects[I]);
  end
  else
    inherited Assign(Source);
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.AssignTo(Dest: TPersistent);
var
  I: Integer;
begin
  if Dest is TWideStrings then
    Dest.Assign(Self)
  else if Dest is TStrings then
  begin
    TStrings(Dest).BeginUpdate;
    try
      TStrings(Dest).Clear;
      for I := 0 to Count - 1 do
        TStrings(Dest).AddObject(Strings[I], Objects[I]);
    finally
      TStrings(Dest).EndUpdate;
    end;
  end
  else
    inherited AssignTo(Dest);
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then
    begin
      Result := True;
      if Filer.Ancestor is TWideStrings then
        Result := not Equals(TWideStrings(Filer.Ancestor))
    end
    else Result := Count > 0;
  end;

begin
  // compatibility
  Filer.DefineProperty('Strings', ReadData, nil, Count > 0);
{$IFDEF Delphi12}
  Filer.DefineProperty('UTF8', ReadDataWOld, nil, Count > 0);
  Filer.DefineProperty('UTF8W', ReadDataW, WriteDataW, DoWrite);
{$ELSE}
  Filer.DefineProperty('UTF8', ReadDataW, WriteDataW, DoWrite);
{$ENDIF}

end;

function {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.GetTextStr: WideString;
var
  I, L, Size, Count: Integer;
  P: PWideChar;
  S, LB: WideString;
begin
  Count := FWideStringList.Count;
  Size := 0;
  LB := sLineBreak;
  for I := 0 to Count - 1 do Inc(Size, Length(Get(I)) + Length(LB));
  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := Get(I);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L * SizeOf(WideChar));
      Inc(P, L);
    end;
    L := Length(LB);
    if L <> 0 then
    begin
      System.Move(Pointer(LB)^, P^, L * SizeOf(WideChar));
      Inc(P, L);
    end;
  end;
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.LoadFromFile(const FileName: WideString);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  S: WideString;
  ansiS: String;
  sign: Word;
begin
  Size := Stream.Size - Stream.Position;
  sign := 0;
  if Size > 2 then
    Stream.Read(sign, 2);

  if sign = $FEFF then
  begin
    Dec(Size, 2);
    SetLength(S, Size div 2);
    Stream.Read(S[1], Size);
    SetTextStr(S);
  end
  else
  begin
    Stream.Seek(-2, soFromCurrent);
    SetLength(ansiS, Size);
    Stream.Read(ansiS[1], Size);
    SetTextStr(ansiS);
  end;
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.LoadFromWStream(Stream: TStream);
var
  Size: Integer;
  S: WideString;
begin
  Size := Stream.Size - Stream.Position;
  SetLength(S, Size div 2);
  Stream.Read(S[1], Size);
  SetTextStr(S);
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.ReadData(Reader: TReader);
begin
  Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
    if Reader.NextValue in [vaString, vaLString] then
      Add(Reader.ReadString) {TStrings compatiblity}
    else
      Add(Reader.ReadWideString);
  Reader.ReadListEnd;
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.ReadDataW(Reader: TReader);
begin
  Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
{$IFDEF Delphi12}
    Add(Reader.ReadString);
{$ELSE}
    Add(Utf8Decode(Reader.ReadString));
{$ENDIF}
  Reader.ReadListEnd;
end;

{$IFDEF Delphi12}
procedure TfrxWideStrings.ReadDataWOld(Reader: TReader);
begin
  Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
    Add(Utf8Decode(AnsiString(Reader.ReadString)));
  Reader.ReadListEnd;
end;
{$ENDIF}

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.SaveToFile(const FileName: WideString);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.SaveToStream(Stream: TStream);
var
  SW: WideString;
begin
  SW := GetTextStr;
  Stream.WriteBuffer(PWideChar(SW)^, Length(SW) * SizeOf(WideChar));
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.SetTextStr(const Value: WideString);
var
  P, Start: PWideChar;
  S: WideString;
begin
  Clear;
  P := Pointer(Value);
  if P <> nil then
    while P^ <> #0 do
    begin
      Start := P;
{$IFDEF Delphi12}
      while not (CharInSet(P^, [WideChar(#0), WideChar(#10), WideChar(#13)])) and (P^ <> WideLineSeparator) do
{$ELSE}
      while not (P^ in [WideChar(#0), WideChar(#10), WideChar(#13)]) and (P^ <> WideLineSeparator) do
{$ENDIF}
        Inc(P);
      SetString(S, Start, P - Start);
      Add(S);
      if P^ = #13 then Inc(P);
      if P^ = #10 then Inc(P);
      if P^ = WideLineSeparator then Inc(P);
    end;
end;

procedure {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}.WriteDataW(Writer: TWriter);
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do
{$IFDEF Delphi12}
    Writer.WriteString(Get(I));
{$ELSE}
    Writer.WriteString(Utf8Encode(Get(I)));
{$ENDIF}
  Writer.WriteListEnd;
end;

function TranslateCharsetInfo(lpSrc: DWORD; var lpCs: TCharsetInfo;
  dwFlags: DWORD): BOOL; stdcall; external gdi32 name 'TranslateCharsetInfo';

function CharSetToCodePage(ciCharset: DWORD): Cardinal;
var
  C: TCharsetInfo;
begin
  if ciCharset = DEFAULT_CHARSET then
    Result := GetACP
  else if ciCharset = MAC_CHARSET then
    Result := CP_MACCP
  else if ciCharset = OEM_CHARSET then
    Result := CP_OEMCP// GetACP
  else
  begin
    Win32Check(TranslateCharsetInfo(ciCharset, C, TCI_SRCCHARSET));
    Result := C.ciACP;
  end;
end;

function AnsiToUnicode(const s: AnsiString; Charset: UINT; CodePage: Integer): WideString;
var
  InputLength, OutputLength: Integer;
begin
  Result := '';
  if CodePage = 0 then
    CodePage := CharSetToCodePage(Charset);
  InputLength := Length(S);
  OutputLength := MultiByteToWideChar(CodePage, 0, PAnsiChar(S), InputLength, nil, 0);
  if OutputLength <> 0 then
  begin
    SetLength(Result, OutputLength);
    MultiByteToWideChar(CodePage, 0, PAnsiChar(S), InputLength, PWideChar(Result), OutputLength);
  end;
end;

function _UnicodeToAnsi(const WS: WideString; Charset: UINT; CodePage: Integer): AnsiString;
var
  InputLength,
  OutputLength: Integer;
begin
  Result := '';
  if CodePage = 0 then
    CodePage := CharSetToCodePage(Charset);
  InputLength := Length(WS);
  OutputLength := WideCharToMultiByte(CodePage, 0, PWideChar(WS), InputLength, nil, 0, nil, nil);
  if OutputLength <> 0 then
  begin
    SetLength(Result, OutputLength);
    WideCharToMultiByte(CodePage, 0, PWideChar(WS), InputLength, PAnsiChar(Result), OutputLength, nil, nil);
  end;
end;

function GetLocalByCharSet(Charset: UINT): Cardinal;
begin
  case Charset of
    EASTEUROPE_CHARSET:   Result := $0405;//$040e
    RUSSIAN_CHARSET:      Result := $0419;
    GREEK_CHARSET:        Result := $0408;
    TURKISH_CHARSET:      Result := $041F;
    HEBREW_CHARSET:       Result := $040D;
    ARABIC_CHARSET:       Result := $3401;
    BALTIC_CHARSET:       Result := $0425;
    VIETNAMESE_CHARSET:   Result := $042A;
    JOHAB_CHARSET:        Result := $0812;
    THAI_CHARSET:         Result := $041E;
    SHIFTJIS_CHARSET:     Result := $0411;
    GB2312_CHARSET:       Result := $0804;
    HANGEUL_CHARSET:      Result := $0412;
    CHINESEBIG5_CHARSET:  Result := $0C04;
  else
    Result := GetThreadLocale;
  end;
end;
{$ENDIF}
end.



