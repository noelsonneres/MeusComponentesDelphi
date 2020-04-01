
{ Prints contents of a OTF font in a readable form }

unit frxOTFPrinter;

interface

uses
  SysUtils,
  frxStorage,
  Classes,
  frxOTF;

type

  { Printing visitor }

  TPrintVisitor = class(TVisitor)
  private
    FOut: TFmtStream;
    FIndent: Integer;

    procedure PrintProp(Key: string; Value: string); overload;
    procedure PrintProp(Key: string; Value: Int64); overload;
    procedure PrintPropHex(Key: string; Value: Int64);
    procedure PrintPropBits(Key: string; Value: Int64);
  public
    constructor Create(Stream: TFmtStream);

    procedure Visit(Obj: TFontView);              override;
    procedure Visit(Obj: TCharmapTableView);      override;
    procedure Visit(Obj: TSegCharmapTableView);   override;
    procedure Visit(Obj: TFontCollectionView);    override;
    procedure Visit(Obj: TStringTableView);       override;
    procedure Visit(Obj: TAsciiCharmapTableView); override;
    procedure Visit(Obj: THeadTableView);         override;
    procedure Visit(Obj: TWinMetrics1TableView);   override;

    property Indent: Integer read FIndent write FIndent;
  end;

procedure PrintFontInfo(Font: TView; Stream: TStream); overload;
procedure PrintFontInfo(Font: TStream; Stream: TStream); overload;
procedure PrintFontInfo(Font: TStream; ResFile: string); overload;
procedure PrintFontInfo(Font: TView; ResFile: string); overload;
procedure PrintFontInfo(FontFile: string; Stream: TStream); overload;
procedure PrintFontInfo(FontFile: string; ResFile: string); overload;

implementation

uses
  Math,
  frxCryptoUtils;

procedure PrintFontInfo(FontFile: string; ResFile: string);
var
  Res: TStream;
begin
  Res := TFileStream.Create(ResFile, fmCreate);

  try
    PrintFontInfo(FontFile, Res);
  finally
    Res.Free;
  end;
end;

procedure PrintFontInfo(Font: TView; ResFile: string);
var
  Res: TStream;
begin
  Res := TFileStream.Create(ResFile, fmCreate);

  try
    PrintFontInfo(Font, Res)
  finally
    Res.Free
  end;
end;

procedure PrintFontInfo(Font: TStream; ResFile: string);
var
  Res: TStream;
begin
  Res := TFileStream.Create(ResFile, fmCreate);

  try
    PrintFontInfo(Font, Res)
  finally
    Res.Free
  end;
end;

procedure PrintFontInfo(Font: TStream; Stream: TStream);
var
  View: TView;
begin
  View := OpenFont(Font);

  try
    PrintFontInfo(View, Stream)
  finally
    View.Free
  end;
end;

procedure PrintFontInfo(FontFile: string; Stream: TStream);
var
  Font: TStream;
begin
  Font := TFileStream.Create(FontFile, fmShareDenyWrite);

  try
    PrintFontInfo(Font, Stream)
  finally
    Font.Free
  end;
end;

procedure PrintFontInfo(Font: TView; Stream: TStream);

  function SHA1(Stream: TStream): string;
  begin
    Result := string(HashStream('SHA1', Stream))
  end;

  function BoolStr(b: Boolean): string;
  begin
    if b then
      Result := 'Yes'
    else
      Result := 'No'
  end;

  function GetGlyphHash(Font: TFontView; Glyph: Word): string;
  begin
    Result := SHA1(Font.Glyph[Glyph].Stream);
  end;

  procedure PrintCharmap(Res: TFmtStream; Font: TFontView; FirstChar, LastChar: Word);
  var
    Char, Glyph: Word;
  begin
    Res.Puts('%-10s %-10s %-10s', ['Char', 'CharCode', 'GID']);
    Res.Puts;

    for Char := FirstChar to LastChar do
    begin
      Glyph := Font.GetGlyphIndex(Char);

      Res.Puts('%-10s %-10d %-10d', [System.Char(Char), Char, Glyph]);
    end;
  end;

  procedure PrintGlyphs(Output: TFmtStream; Font: TFontView);
  var
    i: Integer;
    Hash: string;
    AW, AH: Integer;
    W, H: Integer;
    Offset, Length: Cardinal;
    IsComposite: Boolean;
    LSB, TSB: Integer;
  begin
    with Output do
    begin
      Puts('%6s - %s', ['GID',  'index']);
      Puts('%6s - %s', ['W',    'width in font units']);
      Puts('%6s - %s', ['H',    'height in font units']);
      Puts('%6s - %s', ['AW',   'advance width in font units']);
      Puts('%6s - %s', ['AH',   'advance height in font units']);
      Puts('%6s - %s', ['LSB',  'left side bearing in font units']);
      Puts('%6s - %s', ['TSB',  'top side bearing in font units']);
      Puts('%6s - %s', ['Offset', 'offset to glyph data from beginning of the "glyf" table']);
      Puts('%6s - %s', ['Length', 'number of bytes in the glyph data']);
      Puts('%6s - %s', ['IsC',  'is glyph composite']);
      Puts('%6s - %s', ['SHA1', 'SHA1 from the glyph data']);
      Puts;

      Puts('%5s %5s %5s %5s %5s %5s %5s %6s %6s %3s %s',
        ['GID', 'W', 'H', 'AW', 'AH', 'LSB', 'TSB', 'Offset', 'Length', 'IsC', 'SHA1']);
      Puts;
    end;

    for i := 0 to Font.GlyphsCount - 1 do
    begin
      Hash := GetGlyphHash(Font, i);

      with Font.GlyphMetrics[i] do
      begin
        AW  := AdvWidth;
        AH  := AdvHeight;
        LSB := LeftSB;
        TSB := TopSB;
      end;

      with Font.Glyph[i] do
      begin
        W := Width;
        H := Height;
      end;

      Offset := Font.GlyphPosTable.GlyphOffset[i];
      Length := Font.GlyphPosTable.GlyphLength[i];
      IsComposite := Font.Glyph[i].Composite;

      Output.Puts('%5d %5d %5d %5d %5d %5d %5d %6x %6d %3s %s',
        [i, W, H, AW, AH, LSB, TSB, Offset, Length, BoolStr(IsComposite), Hash]);
    end;
  end;

  procedure PrintTitle(Fmt: TFmtStream; Title: string; Width: Integer = 120);
  const
    L = '---';
    R = '---';
  begin
    with Fmt do
    begin
      Puts;
      PutsRaw(L);
      Dec(Width, Length(L));

      if Title <> '' then
      begin
        PutsRaw(' ' + Title + ' ');
        Dec(Width, 2 + Length(Title));
      end;

      while Width > 0 do
      begin
        PutsRaw('-');
        Dec(Width);
      end;

      Puts;
      Puts;
    end;
  end;

  procedure AnalyseFont(ResFmt: TFmtStream; Font: TFontView);
  begin
    PrintTitle(ResFmt, 'ASCII printset mapping');
    PrintCharmap(ResFmt, Font, 32, 126);

    //PrintTitle(ResFmt, 'Glyphs');
    //PrintGlyphs(ResFmt, Font);
  end;

  procedure AnalyseFontCollection(ResFmt: TFmtStream; FC: TFontCollectionView);
  var
    i: Integer;
  begin
    for i := 0 to FC.FontsCount - 1 do
    begin
      PrintTitle(ResFmt, 'Font #' + IntToStr(i));
      AnalyseFont(ResFmt, FC.Font[i]);
    end;
  end;

var
  Printer: TVisitor;
  ResFmt: TFmtStream;
begin
  ResFmt := nil;
  Printer := nil;

  try
    ResFmt := TFmtStream.Create(Stream, False);
    ResFmt.Formatted := True;
    ResFmt.Puts('SHA1 ' + SHA1(Font.Stream));
    ResFmt.Puts;

    Printer := TPrintVisitor.Create(ResFmt);
    Font.Accept(Printer);

    if Font is TFontView then
      AnalyseFont(ResFmt, Font as TFontView)
    else if Font is TFontCollectionView then
      AnalyseFontCollection(ResFmt, Font as TFontCollectionView)
    else
      ResFmt.Puts('Unknown font type %s', [Font.ClassName]);
  finally
    ResFmt.Free;
    Printer.Free;
  end;
end;

{ TPrintVisitor }

constructor TPrintVisitor.Create(Stream: TFmtStream);
begin
  FOut := Stream;
  FIndent := 4;
end;

procedure TPrintVisitor.PrintProp(Key, Value: string);
begin
  FOut.Puts('%s = %s', [Key, Value])
end;

procedure TPrintVisitor.PrintProp(Key: string; Value: Int64);
begin
  FOut.Puts('%s = %d', [Key, Value])
end;

procedure TPrintVisitor.PrintPropHex(Key: string; Value: Int64);
begin
  FOut.Puts('%s = 0x%X', [Key, Value])
end;

procedure TPrintVisitor.Visit(Obj: TWinMetrics1TableView);
begin
  with Obj.Header do
  begin
    PrintProp('version',      Version);
    PrintProp('AvgWidth',     AvgWidth);
    PrintProp('Weight',       Weight);
    PrintProp('Width',        Width);
    PrintProp('Family',       Family);
    PrintProp('Vendor',       string(Vendor));
    PrintProp('Ascender',     Ascender);
    PrintProp('Descender',    Descender);
    PrintProp('WinAscent',    WinAscent);
    PrintProp('WinDescent',   WinDescent);
    PrintProp('LineGap',      LineGap);
    {
    PrintProp('Height',       Height);
    PrintProp('CapHeight',    CapHeight);
    PrintProp('DefChar',      DefChar);
    PrintProp('BreakChar',    BreakChar);
    }

    PrintPropBits('Selection', Selection);
    PrintPropBits('Rights', Rights);
  end;
end;

procedure TPrintVisitor.PrintPropBits(Key: string; Value: Int64);
var
  j: Integer;
  s: string;
begin
  if Value = 0 then
  begin
    FOut.Puts('%s = 0', [Key]);
    Exit;
  end;

  s := Format('%s = %d (bits', [Key, Value]);

  for j := 0 to 8 * SizeOf(Value) do
  begin
    if Value and 1 = 1 then
      s := s + ' ' + IntToStr(j);

    Value := Value shr 1;
  end;

  s := s + ')';
  FOut.Puts(s);
end;

procedure TPrintVisitor.Visit(Obj: TFontView);

  function Percent(n: Cardinal): Cardinal;
  begin
    Result := 100 * n div Obj.Size
  end;

var
  i: Integer;
  Len: Cardinal;
  t: TTableRecordEntry;
begin
  with Obj do
  try
    Len := 0;

    try
      for i := 0 to TablesCount - 1 do
        Inc(Len, GetTable(i).Size);
    except
    end;

    FOut.Puts('Family: %s', [FamilyName]);
    FOut.Puts('Subfamily: %s', [SubfamilyName]);
    FOut.Puts('%d glyphs', [GlyphsCount]);
    FOut.Puts('All tables occupy %d bytes', [Len]);
    FOut.Puts;

    FOut.IncIndent(+Indent);

    for i := 0 to TablesCount - 1 do
    try
      t := GetTableHeader(i);

      FOut.Puts('%s %s %x-%x %d %d%% sum:%x (sha1:%s)', [
        Format('#%d', [i]),
        AnsiString(t.Tag),
        t.Offset,
        t.Offset + t.Length - 1,
        t.Length,
        Percent(t.Length),
        t.Checksum,
        HashStream('SHA1', GetTable(i).Stream)]);

      FOut.IncIndent(+Indent);
      GetTable(i).Accept(Self);
      FOut.IncIndent(-Indent);
    except
      on e: Exception do
        FOut.Puts(e.ClassName + ': ' + e.Message);
    end;

    FOut.IncIndent(-Indent);
  except
    on e: Exception do
      FOut.Puts(e.ClassName + ': ' + e.Message);
  end;
end;

procedure TPrintVisitor.Visit(Obj: TCharmapTableView);
var
  i: Integer;
  t: TCharmapSubtableView;
begin
  with Obj do
    for i := 0 to SubtablesCount - 1 do
    begin
      t := Subtable[i];

      with GetSubtableRecordEntry(i) do
        FOut.Puts('%-6s %-6s %-5s %-6s +%-8x %-6d (sha1:%s)', [
          Format('fmt:%d', [t.Format]),
          Format('plat:%d', [Platform]),
          Format('enc:%d', [Encoding]),
          Format('lang:%d', [t.Language]),
          Offset,
          t.Size,
          HashStream('SHA1', t.Stream)]);

      FOut.IncIndent(+Indent);
      t.Accept(Self);
      FOut.IncIndent(-Indent);
    end;
end;

procedure TPrintVisitor.Visit(Obj: TSegCharmapTableView);

  function Sign(a: Integer): string;
  begin
    if a < 0 then
      Result := '-'
    else
      Result := '+'
  end;

  function Abs(a: Integer): Integer;
  begin
    if a < 0 then
      Result := -a
    else
      Result := a
  end;

var
  i: Integer;
begin
  with Obj do
    for i := 0 to SegCount - 1 do
      FOut.Puts('%4x-%-4x %s%-5d r:%-d', [
        First[i],
        Last[i],
        Sign(Delta[i]),
        Abs(Delta[i]),
        Offset[i]])
end;

procedure TPrintVisitor.Visit(Obj: TFontCollectionView);
var
  i: Integer;
begin
  with Obj do
  begin
    FOut.Puts('Fonts collection with %d fonts', [FontsCount]);

    for i := 0 to FontsCount - 1 do
    begin
      FOut.IncIndent(+Indent);
      Font[i].Accept(Self);
      FOut.IncIndent(-Indent);
    end;
  end;
end;

procedure TPrintVisitor.Visit(Obj: TStringTableView);

  function Fix(const s: AnsiString): AnsiString;
  var
    i, j: Integer;
  begin
    SetLength(Result, Length(s));
    j := 1;

    for i := 1 to Length(s) do
      if Word(s[i]) in [32..126] then
      begin
        Result[j] := s[i];
        Inc(j);
      end;

    SetLength(Result, j - 1);
  end;

var
  i: Integer;
  r: TStringTableEntry;
begin
  with Obj do
    for i := 0 to Count - 1 do
    begin
      r := Entry[i];

      FOut.Puts('%-5s %-6s %-5s %-8s %-7s %s', [
        Format('id:%d',   [r.Id]),
        Format('plat:%d', [r.Platform]),
        Format('enc:%d',  [r.Encoding]),
        Format('lang:%x', [r.Language]),
        Format('len:%d',  [Length(Strings[i])]),
        Fix(Strings[i])]);
    end;
end;

procedure TPrintVisitor.Visit(Obj: TAsciiCharmapTableView);
var
  i, n: Integer;
begin
  n := 0;

  for i := 0 to 255 do
    if Obj[i] > 0 then
    begin
      FOut.Puts('%3d %-3d ', [i, Obj[i]]);
      Inc(n);
    end;

  if n = 0 then
    FOut.Puts('All charcodes are mapped to zero by this mapping');
end;

procedure TPrintVisitor.Visit(Obj: THeadTableView);
begin
  with Obj.Header do
  begin
    PrintPropHex('Version', Version);
    PrintPropHex('Checksum', Checksum);
    PrintPropHex('Signature', Signature);
    PrintProp('XMin', FontBox.XMin);
    PrintProp('XMax', FontBox.XMax);
    PrintProp('YMin', FontBox.YMin);
    PrintProp('YMax', FontBox.YMax);
    PrintProp('Long offsets', LongOffset);
    PrintProp('Glyph format', Format);
    PrintProp('Units per em', UnitsPerEm);
    PrintProp('Smallest size', Smallest);
    PrintPropBits('Flags', Flags);
  end;
end;

end.

