unit frxTrueTypeCollection;

interface

{$I frx.inc}

uses
  Classes, SysUtils, Graphics, Windows,
  TTFHelpers, frxTrueTypeFont, frxFontHeaderClass, frxNameTableClass
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF};


type // Nested Types

  TFontCollection = TList;
  TTCollectionHeader = packed record
      TTCTag: Cardinal;
      Version: Cardinal;
      numFonts: Cardinal;
  end;

  TrueTypeCollection = class(TTF_Helpers)
    // Fields
    private fonts_collection: TFontCollection;

    private function get_FontCollection: TFontCollection;
    private function get_Item(FamilyName: string): TrueTypeFont;

    // Methods
    public constructor Create;
    destructor Destroy; override;
    public procedure Initialize(FD: PAnsiChar; FontDataSize: Longint);
    function LoadFont( font: Tfont) : TrueTypeFont;
//    public function PackFont( font: Tfont; UsedAlphabet: TList) : TByteArray;
    public function PackFont( ttf: TrueTypeFont; UsedAlphabet: TList) : TByteArray;

    // Properties
    public property FontCollection: TFontCollection read get_FontCollection;
    public property Item[FamilyName: string]: TrueTypeFont read get_Item;
  end;

{$WARNINGS OFF}
const
  // You may put national font names here
  // but they should be represented in Unicode in form of 32 bit numbers
    Elements =12;
    Substitutes  : array  [1..Elements] of WideString = (
{
      'ＭＳ ゴシック',        'MS Gothic',
      'ＭＳ Ｐゴシック',     'MS PGothic',
      'ＭＳ 明朝',              'MS Mincho',
      'ＭＳ Ｐ明朝',           'MS PMincho',
      'メイリオ',               'Meiryo',
}
      #$FF2D#$FF33#$0020#$30B4#$30B7#$30C3#$30AF,
        'MS Gothic',
      #$FF2D#$FF33#$0020#$FF30#$30B4#$30B7#$30C3#$30AF,
        'MS PGothic',
      #$FF2D#$FF33#$0020#$660E#$671D,
        'MS Mincho',
      #$FF2D#$FF33#$0020#$FF30#$660E#$671D,
        'MS PMincho',
      #$30E1#$30A4#$30EA#$30AA,
        'Meiryo',
      'Tahoma Bold',
        'Tahoma Negreta'
    );

implementation

  function TrueTypeCollection.get_FontCollection: TFontCollection;
  begin
    Result := fonts_collection;
  end;

  function TrueTypeCollection.get_Item(FamilyName: string): TrueTypeFont;
  var
    font: TrueTypeFont;
    nt: NameTableClass;
    s : String;
    i:  Integer;
  begin
    Result := nil;
    for i := 0 to fonts_collection.Count - 1 do
    begin
      font := TrueTypeFont(fonts_collection[i]);
      nt := font.Names;
      s := nt.IsHasFontName(NameID_UniqueID, s);
      if s = FamilyName then
      begin
        Result := font;
        break
      end;
    end;
    if  Result = nil then raise Exception.Create('Font not found in collection');
  end;


  constructor TrueTypeCollection.Create;
  begin
    self.fonts_collection := TFontCollection.Create;
  end;

  destructor TrueTypeCollection.Destroy;
  var
    font: TrueTypeFont;
    i:  Integer;
  begin
    for i := 0 to fonts_collection.Count - 1 do
    begin
      font := TrueTypeFont(fonts_collection[i]);
      font.Free;
    end;
    fonts_collection.Free;
  end;

  procedure TrueTypeCollection.Initialize(FD: PAnsiChar; FontDataSize: Longint);
  var
    CollectionMode:   FontType;
    i: Cardinal;
    f: TrueTypeFont;
    pch: ^TTCollectionHeader;
    ch: TTCollectionHeader;
    subfont_table: ^Cardinal;
    subfont_idx: Cardinal;
    subfont_ptr: Pointer;
  begin
    if (FD[0] = AnsiChar(0)) and (FD[1] = AnsiChar(1)) and (FD[2] = AnsiChar(0)) and (FD[3] = AnsiChar(0)) then
      CollectionMode := FontType_TrueTypeFontType
    else if (FD[0] = 't') and (FD[1] = 't') and (FD[2] = 'c') and (FD[3] = 'f') then
      CollectionMode := FontType_TrueTypeCollection
    else if (FD[0] = 'O') and (FD[1] = 'T') and (FD[2] = 'T') and (FD[3] = 'O') then
      CollectionMode := FontType_OpenTypeFontType
    else
      raise Exception.Create('TrueType font format error');

    if (CollectionMode = FontType_TrueTypeFontType) then
    begin
      f := TrueTypeFont.Create( Pointer(FD), Pointer(FD), ChecksumFaultAction_Warn);
      self.fonts_collection.Add( f )
    end else if (CollectionMode = FontType_TrueTypeCollection) then
    begin
        pch := Pointer(FD);
        ch.TTCTag := TTF_Helpers.SwapUInt32(pch.TTCTag);
        ch.Version := TTF_Helpers.SwapUInt32(pch.Version);
        ch.numFonts := TTF_Helpers.SwapUInt32(pch.numFonts);
        case ch.Version of
        $10000: subfont_table := TTF_Helpers.Increment( pch, 12 ); // Version 1
        $20000: subfont_table := TTF_Helpers.Increment( pch, 12 ); // Version 2
        else raise Exception.Create('Unknown font collection version');
        end;

        i := 0;
        while i < ch.numFonts do
        begin
            subfont_idx := TTF_Helpers.SwapUInt32( subfont_table^ );
            subfont_ptr := TTF_Helpers.Increment( FD, subfont_idx);
            f := TrueTypeFont.Create(FD, subfont_ptr, ChecksumFaultAction_Warn);
            self.fonts_collection.Add( f );
            inc(i);
            inc( subfont_table, 1)
        end
    end
  end;

  function TrueTypeCollection.LoadFont( font: Tfont) : TrueTypeFont;
  var
    i:            Integer;
    skip_list:    TList;
    Transform:    WideString;
    Name:         WideString;
    s:            WideString;
    ttf:          TrueTypeFont;
    substituted:  Boolean;
  begin
    Result := nil;
    if (self.fonts_collection.Count = 0) then Exit;
    skip_list := TList.Create;
    skip_list.Add( Pointer(TablesID_EmbedBitmapLocation));
    skip_list.Add( Pointer(TablesID_EmbededBitmapData));
    skip_list.Add( Pointer(TablesID_HorizontakDeviceMetrix));
    skip_list.Add( Pointer(TablesID_VerticalDeviceMetrix));
    skip_list.Add( Pointer(TablesID_DigitalSignature));

    Name := font.Name;

    i := 1;
    substituted := false;
    while i <= ((High(Substitutes)-Low(Substitutes)) ) do
    begin
      Transform := UTF8Encode(Substitutes[i]);
      if Transform = Name then
      begin
        Name := Substitutes[i+1];
        substituted := true;
        break;
      end;
      i := i + 2;
    end;

    if substituted = False then begin
      if fsBold in font.Style   then Name := Name + ' Bold';
      if fsItalic in font.Style then Name := Name + ' Italic';
    end;

    for i := 0 to Self.fonts_collection.Count - 1 do
    begin
      ttf := TrueTypeFont(Self.fonts_collection[i]);
      ttf.PrepareFont( skip_list );
      s := ttf.Names.IsHasFontName(NameID_FullName, s);
      if s = Name then
      begin
        Result := ttf;
        break;
      end;
      s := ttf.Names.IsHasFontName(NameID_FamilyName, s);
      if s = Name then
      begin
        Result := ttf;
        break;
      end;
    end;
    if (Result = nil) and (Self.fonts_collection.Count > 0)  then
    begin
      TrueTypeFont(Self.fonts_collection[0]).SubstitutionName := Name + ' - ' + TrueTypeFont(Self.fonts_collection[0]).Names.Item[NameID_FullName];
      Result := TrueTypeFont(Self.fonts_collection[0]);
    end;

    skip_list.Free;
  end;

  function TrueTypeCollection.PackFont( ttf: TrueTypeFont; UsedAlphabet: TList) : TByteArray;
  var
    j:          Integer;
    ch:         WideChar;
  begin
    begin
      for j := 0 to UsedAlphabet.Count - 1 do
      begin
        ch := WideChar(UsedAlphabet[j]);
        ttf.AddCharacterToKeepList(ch);
      end;
      Result := ttf.PackFont(FontType_TrueTypeFontType, True );
    end;
  end;

{$WARNINGS ON}
end.