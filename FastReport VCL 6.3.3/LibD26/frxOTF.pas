
{******************************************}
{                                          }
{             FastReport v5.0              }
{            OpenType Fonts API            }
{                                          }
{         Copyright (c) 1998-2011          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

{ http://www.microsoft.com/typography/otspec/ }

unit frxOTF;

{$IFDEF DEBUG}

{ Enables verification of all fields in font files,
  even those that are not needed for parsing. }

//{$DEFINE EXTENSIVE_CHECKS}

{$ENDIF} // {$IFDEF DEBUG}

{ Some fields in font files contain checksums of
  large file parts. Correct checksums are not required
  by most font consumer programs, but calculating them
  is a very slow process. }

//{$DEFINE EMIT_CHECKSUMS}

interface

{ Classes in this module fall into two groups: viewers and builders.

  A viewer represents a certain structure inside a font file and provides the
  read-only access to its contents. Viewers require minimum amount of memory
  and don't actually load contents of the font.

  A builder constructs a structure inside a font. It provides only one
  interface method - SaveToStream. It doesn't keep all the contents of the
  structure in memory, but rather it keeps minimum information about how to
  construct the stucture. Often a builder is connected with a corresponding viewer,
  from which it extracts needed information.

  Thus viewers and builders can completely change structure of a font file
  and write the changed font to another file without the need to load any considerable
  pieces of the source font. }

uses
  Classes,
  SysUtils,
  frxStorage;

type
  TGlyphIndex = Word;
  WordArray = array of Word;
  TPanose = array[1..10] of Byte;
  TFontTableTag = array[1..4] of AnsiChar;

  { Information about a glyph }

  TGlyphMetrics = record
    AdvWidth:   Word;     // advance width
    AdvHeight:  Word;     // advance height
    LeftSB:     SmallInt; // left side bearing
    TopSB:      SmallInt; // top side bearing
  end;

  { Bounding box for all glyphs }

  TFontBox = packed record
    XMin: SmallInt;
    YMin: SmallInt;
    XMax: SmallInt;
    YMax: SmallInt;
  end;

  { The header for a TTF or a OTF file }

  TFontFileHeader = packed record
    Version:    Cardinal;
    NumTables:  Word;
    Range:      Word;
    Selector:   Word;
    Shift:      Word;
  end;

  { The header for a named table }

  TTableRecordEntry = packed record
    Tag:        TFontTableTag;
    Checksum:   Cardinal;
    Offset:     Cardinal;
    Length:     Cardinal;
  end;

  { "head" table contents  }

  THeadTableHeader = packed record
    Version:    Cardinal;
    Revision:   Cardinal;
    Checksum:   Cardinal;
    Signature:  Cardinal; // must be 0x5F0F3CF5
    Flags:      Word;
    UnitsPerEm: Word;
    Created:    Int64;
    Modified:   Int64;
    FontBox:    TFontBox;
    Style:      Word;
    Smallest:   Word;
    DirHint:    SmallInt;
    LongOffset: SmallInt; // either 1 or 0
    Format:     SmallInt;
  end;

  { "maxp" table header }

  TMaxpTableHeader = packed record
    Version:    Cardinal;
    NumGlyphs:  Word;
    MaxPoints:  Word;
    MaxContours:Word;
    MaxCompPts: Word;
    MaxCompCtrs:Word;
    MaxZones:   Word;
    MaxTwPoints:Word;
    MaxStorage: Word;
    MaxFunc:    Word;
    MaxInst:    Word;
    MaxStack:   Word;
    MaxInstSize:Word;
    MaxComp:    Word;
    MaxDepth:   Word;
  end;

  { Each glyphs in the "glyf" table is begun with this header }

  TGlyphHeader = packed record
    NumContours:SmallInt;
    XMin:       SmallInt;
    YMin:       SmallInt;
    XMax:       SmallInt;
    YMax:       SmallInt;
  end;

  { Composite glyphs consists of a list of entries
    which are started with this header. }

  TGlyphEntryHeader = packed record
    Flags:      Word;
    Glyph:      Word;
  end;

  { "cmap" table header }

  TCharmapTableHeader = packed record
    Version:    Word;
    NumTables:  Word;
  end;

  { a "cmap" subtable record entry }

  TCharmapSubtableRecordEntry = packed record
    Platform:   Word;
    Encoding:   Word;
    Offset:     cardinal;
  end;

  { Header of the charmap subtable of the format 0 }

  TAsciiCharmapTableHeader = packed record
    Format:   Word;
    Length:   Word;
    Lang:     Word;
  end;

  { Header for the charmap subtable of the format 4 }

  TSegCharmapTableHeader = packed record
    Format:     Word;
    Length:     Word;
    Lang:       Word;
    SegCount2:  Word; // 2 * SegCount
    Range:      Word; // 2 * 2 ^ floor(log2(SegCount))
    Selector:   Word; // floor(log2(SegCount))
    Shift:      Word; // 2 * SegCount - Range
  end;

  { TTC file header }

  TFontCollectionFileHeader = packed record
    Tag:      array[1..4] of AnsiChar;
    Version:  Cardinal;
    NumFonts: Cardinal;
  end;

  { Contents of "hhea" and "vhea" tables }

  TMetricsTableHeader = packed record
    Version:    Cardinal;
    Ascent:     SmallInt;
    Descent:    SmallInt;
    LineGap:    SmallInt;
    MaxWidth:   Word;
    MinSB1:     SmallInt;
    MinSB2:     SmallInt;
    MaxExtent:  SmallInt;
    SlopeRise:  SmallInt;
    SlopeRun:   SmallInt;
    Offset:     SmallInt;
    Reserved:   array[1..4] of SmallInt;
    Metric:     SmallInt;
    NumMetrics: Word;
  end;

  { Contents of the "OS/2" table.
    Version 1. }

  TWinMetrics1TableHeader = packed record
    Version:    Word;
    AvgWidth:   SmallInt;
    Weight:     Word;
    Width:      Word;
    Rights:     Word;
    SubXSize:   SmallInt;
    SubYSize:   SmallInt;
    SubXOffset: SmallInt;
    SubYOffset: SmallInt;
    SupXSize:   SmallInt;
    SupYSize:   SmallInt;
    SupXOffset: SmallInt;
    SupYOffset: SmallInt;
    StrikeSize: SmallInt;
    StrikePos:  SmallInt;
    Family:     SmallInt;
    Panose:     TPanose;
    UniRange:   array[1..4] of Cardinal;
    Vendor:     array[1..4] of AnsiChar;
    Selection:  Word;
    FirstChar:  Word;
    LastChar:   Word;
    Ascender:   Word;
    Descender:  Word;
    LineGap:    Word;
    WinAscent:  Word;
    WinDescent: Word;
    PageRange:  array[1..2] of Cardinal;
    {
    Height:     SmallInt;
    CapHeight:  SmallInt;
    DefChar:    Word;
    BreakChar:  Word;
    MaxContext: Word;
    }
  end;

  { "name" table header }

  TStringTableHeader = packed record
    Format:     Word;
    Count:      Word;
    Offset:     Word;
  end;

  TStringRecord = packed record
    Platform:   Word;
    Encoding:   Word;
    Language:   Word;
    Id:         Word; // copyright notice, font family name, etc.
    Size:       Word; // in bytes
    Offset:     Word;
  end;

  TStringTableEntry = record
    Platform: Word;
    Encoding: Word;
    Language: Word;
    Id:       Word;
  end;

  { Conforms the Visitor pattern }

  TVisitor = class;

  { Represents a piece of a file with the font }

  TView = class
  private
    FStream: TStream;
    FOwnStream: Boolean;

    function GetSize: Cardinal;
  protected
    procedure Init; virtual;
  public
    constructor Create(Stream: TStream; OwnStream: Boolean);
    destructor Destroy; override;

    procedure Accept(v: TVisitor); virtual;

    property Stream: TStream read FStream;
    property Size: Cardinal read GetSize;
  end;

  { Represents a named table in a OpenType font file.
    Examples of this table: cmap, head, fpgm. }

  TFontTableView = class(TView);

  { "OS/2" table }

  TWinMetricsTableView = class(TFontTableView)
  private
    function GetVersion: Word;
  protected
    procedure Init; override;
  public
    procedure Accept(v: TVisitor); override;
    property Version: Word read GetVersion;
  end;

  TWinMetrics1TableView = class(TWinMetricsTableView)
    function GetHeader: TWinMetrics1TableHeader;
  protected
    procedure Init; override;
  public
    procedure Accept(v: TVisitor); override;
    property Header: TWinMetrics1TableHeader read GetHeader;
  end;

  { Represents a subtable in the "cmap" table }

  TCharmapSubtableView = class(TView)
  private
    function GetFormat: Word;
  protected
    function GetLanguage: Word; virtual; abstract;
    function GetGlyphIndex(Char: Word): TGlyphIndex; virtual; abstract;
  public
    class function CreateSubtable(Stream: TStream; OwnStream: Boolean): TCharmapSubtableView;

    procedure Accept(v: TVisitor); override;

    { Some subtables have the Length field at one offset,
      others have it at another offset. }

    class function GetSubtableLength(Stream: TStream): Cardinal;

    property Format: Word read GetFormat;
    property Language: Word read GetLanguage;
    property Glyph[Char: Word]: TGlyphIndex read GetGlyphIndex; default;
  end;

  { Represents a charmap subtable that maps all charcodes to the zero glyph.
    This class is used when it's needed to represent a subtable of an
    unknown format. }

  TEmptyCharmapTableView = class(TCharmapSubtableView)
  protected
    function GetLanguage: Word; override;
    function GetGlyphIndex(Char: Word): TGlyphIndex; override;
  end;

  { Represents a charmap subtable of the format 0 }

  TAsciiCharmapTableView = class(TCharmapSubtableView)
  private
    function GetHeader: TAsciiCharmapTableHeader;
    procedure CheckHeader(const h: TAsciiCharmapTableHeader);
  protected
    procedure Init; override;
    function GetLanguage: Word; override;
    function GetGlyphIndex(Char: Word): TGlyphIndex; override;
  public
    procedure Accept(v: TVisitor); override;
  end;

  { Represents a charmap subtable of the format 4 }

  TSegCharmapTableView = class(TCharmapSubtableView)
  private
    FSegNum: Integer;
    FGlyphNum: Integer;
    FFirst: WordArray;
    FLast: WordArray;
    FDelta: WordArray;
    FOffset: WordArray;

    function GetHeader: TSegCharmapTableHeader;
    procedure CheckHeader(const h: TSegCharmapTableHeader);

    function ReadWord(Offset: Cardinal): Word;
    function GetWord(var w: WordArray; i: Integer; p: Cardinal): Word;

    function GetFirst(i: Integer): Word;
    function GetLast(i: Integer): Word;
    function GetOffset(i: Integer): Word;
    function GetGlyph(i: Integer): Word;
    function GetDelta(i: Integer): Word;

    { Finds optimal set of segments for a set of used chars which
      produces the smallest charmap.

      Chars[i]  = charcode of the i-th char; this array must be ascending
      Glyphs[i] = glyph index the corresponds to the i-th char
      Seg[i]    = length of the i-th segment

      Result    = number of bytes needed for all these segments }

    class function FindOptimalMapping(const Chars, Glyphs: WordArray; out Seg: WordArray): Word;
  protected
    procedure Init; override;
    function GetLanguage: Word; override;
    function GetGlyphIndex(Char: Word): TGlyphIndex; override;
  public
    procedure Accept(v: TVisitor); override;

    property SegCount: Integer read FSegNum;
    property First[i: Integer]: Word read GetFirst;
    property Last[i: Integer]: Word read GetLast;
    property Delta[i: Integer]: Word read GetDelta;
    property Offset[i: Integer]: Word read GetOffset;
    property Glyph[i: Integer]: Word read GetGlyph;
  end;

  { "cmap" table }

  TCharmapTableView = class(TFontTableView)
  private
    FSubtables: array of TCharmapSubtableView;

    function GetSubtablesCount: Integer;
    function GetSubtable(i: Integer): TCharmapSubtableView;
    function GetPlatform(i: Integer): Word;
    function GetEncoding(i: Integer): Word;
    function GetHeader: TCharmapTableHeader;
    procedure LoadSubtable(i: Integer);
  protected
    procedure Init; override;
  public
    destructor Destroy; override;

    procedure Accept(v: TVisitor); override;
    function GetGlyphIndex(Char: Word): Cardinal;
    function GetSubtableRecordEntry(i: Integer): TCharmapSubtableRecordEntry;

    property SubtablesCount: Integer read GetSubtablesCount;
    property Subtable[i: Integer]: TCharmapSubtableView read GetSubtable;
    property Platform[i: Integer]: Word read GetPlatform;
    property Encoding[i: Integer]: Word read GetEncoding;
  end;

  { "head" table }

  THeadTableView = class(TFontTableView)
  private
    function GetHeader: THeadTableHeader;
  protected
    procedure Init; override;
  public
    procedure Accept(v: TVisitor); override;
    property Header: THeadTableHeader read GetHeader;
  end;

  { "hhea" and "vhea" tables }

  TMetricsInfoTableView = class(TFontTableView)
  private
    function GetHeader: TMetricsTableHeader;
  protected
    procedure Init; override;
  public
    property Header: TMetricsTableHeader read GetHeader;
  end;

  { "hmtx" and "vmtx" tables }

  TMetricsTableView = class(TFontTableView)
  private
    FNumMetrics: Cardinal;
    FNumGlyphs: Cardinal;

    function GetDim(i: Integer): Word;
    function GetSB(i: Integer): SmallInt;
  public
    // NumMetrics comes from hhea or vhea; NumGlyphs comes from maxp.
    constructor Create(Stream: TStream; Own: Boolean; NumMetrics, NumGlyphs: Cardinal);

    procedure Accept(v: TVisitor); override;

    property Count: Cardinal read FNumGlyphs;
    property Dim[i: Integer]: Word read GetDim;   // Width for hmtx; Height for vmtx
    property SB[i: Integer]: SmallInt read GetSB; // LSB for hmtx; TSB for vmtx
  end;

  { "name" table }

  TStringTableView = class(TFontTableView)
  private
    FCount: Word;
    FStorage: Word; // offset to the strings storage

    function GetHeader: TStringTableHeader;
    function GetEntry(i: Integer): TStringTableEntry;
    function getString(i: Integer): AnsiString;
    function GetStringRecord(i: Integer): TStringRecord;
    procedure CheckHeader(const h: TStringTableHeader);
    procedure CheckStringRecord(const h: TStringRecord);
  protected
    procedure Init; override;
  public
    procedure Accept(v: TVisitor); override;

    property Count: Word read FCount;
    property Entry[i: Integer]: TStringTableEntry read GetEntry;
    property Strings[i: Integer]: AnsiString read GetString; default;
  end;

  { "maxp" table.
    See http://www.microsoft.com/typography/otspec/maxp.htm for details.
    There're two versions of this table, but both have the same two first
    fields: Version (4 bytes) and NumGlyphs (2 bytes). }

  TMaxpTableView = class(TFontTableView)
  private
    function GetNumGlyphs: Word;
    function GetHeader: TMaxpTableHeader;
  protected
    procedure Init; override;
  public
    property Header: TMaxpTableHeader read GetHeader;
    property NumGlyphs: Word read GetNumGlyphs;
  end;

  { "loca" table.
    See for http://www.microsoft.com/typography/otspec/loca.htm details. }

  TGlyphPosTableView = class(TFontTableView)
  private
    FLongOffsets: Boolean;
    FNumOffsets: Cardinal;

    function GetGlyphOffset(i: Integer): Cardinal;
    function GetGlyphLength(i: Integer): Cardinal;
  public
    constructor Create(Stream: TStream; OwnStream, LongOffsets: Boolean;
      NumOffsets: Cardinal);

    procedure Accept(v: TVisitor); override;

    property LongOffsets: Boolean read FLongOffsets;
    property NumOffsets: Cardinal read FNumOffsets;

    property GlyphOffset[i: Integer]: Cardinal read GetGlyphOffset;
    property GlyphLength[i: Integer]: Cardinal read GetGlyphLength;
  end;

  { "glyf" table }

  TGlyphTableView = class(TFontTableView);

  { Represents a glyph.
    Glyphs can be wither simple or composite.
    Composite glyphs are constructed from other glyphs,
    and refer to these other glyphs by indices. }

  TGlyphView = class(TView)
  protected
    function GetWidth: Integer; virtual; abstract;
    function GetHeight: Integer; virtual; abstract;
    function IsComposite: Boolean; virtual; abstract;
  public
    class function CreateGlyph(Stream: TStream; Own: Boolean): TGlyphView;

    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property Composite: Boolean read IsComposite;
  end;

  { Represents a glyph whose size is zero }

  TNullGlyphView = class(TGlyphView)
  protected
    function GetWidth: Integer; override;
    function GetHeight: Integer; override;
    function IsComposite: Boolean; override;
  end;

  { Introducing this intermediate class is made because
    fonts can contain glyphs of zero size. Such glyphs are
    invalid due to the specification (any glyph begins with
    a 10 byte header), but all font-consumer programs happily
    accept such glyphs and many standard font files contain
    such glyphs (e.g. the space glyph). So, this situation must be
    handled in some way. This class represents a glyph of non-zero
    size. }

  TBaseGlyphView = class(TGlyphView)
  private
    function GetHeader: TGlyphHeader;
    procedure CheckHeader(const h: TGlyphHeader);
  protected
    function IsComposite: Boolean; override;
    function GetWidth: Integer; override;
    function GetHeight: Integer; override;
    procedure Init; override;
  public
    property Header: TGlyphHeader read GetHeader;
  end;

  { Simple glyph }

  TSimpleGlyphView = class(TBaseGlyphView);

  { Composite glyph }

  TCompositeGlyphView = class(TBaseGlyphView)
  private
    FEntryOffset: array of Cardinal;

    function GetCount: Cardinal;
    function GetGlyph(i: Cardinal): TGlyphIndex;
    function GetEntryOffset(i: Integer): Cardinal;
  protected
    procedure Init; override;
  public
    property Count: Cardinal read GetCount;
    property Component[i: Cardinal]: TGlyphIndex read GetGlyph;
    property EntryOffset[i: Integer]: Cardinal read GetEntryOffset;
  end;

  { Represents a TTF or a OTF file.
    Consists of several named tables. }

  TFontView = class(TView)
  private
    FFontFile: TStream;
    FTables: array of TFontTableView;
    FGlyphsCount: Cardinal;
    FGlyphs: TObjList;
    FCurCharmap: TCharmapSubtableView; // currently used mapping; can be nil

    FCharmapTable: TCharmapTableView;
    FGlyphPosTable: TGlyphPosTableView;
    FHMetricstable: TMetricsTableView;
    FGlyphTable: TGlyphTableView;

    function GetString(NameId: Integer): AnsiString;
    function GetFontName: AnsiString;
    function GetFontStyleName: AnsiString;

    function CreateTable(Name: AnsiString; Stream: TStream; Own: Boolean): TFontTableView;
    procedure LoadTable(i: Integer);
    function FindTable(Name: AnsiString): Integer;

    function GetGlyph(g: TGlyphIndex): TGlyphView;
    function GetGlyphMetrics(g: TGlyphIndex): TGlyphMetrics;

    function GetTablesCount: Integer;
    function GetGlyphsCount: Cardinal;

    function GetCharmapTable: TCharmapTableView;
    function GetGlyphPosTable: TGlyphPosTableView;
    function GetHMetricsTable: TMetricsTableView;
    function GetHMetricsInfoTable: TMetricsInfoTableView;
    function GetVMetricsTable: TMetricsTableView;
    function GetVMetricsInfoTable: TMetricsInfoTableView;
    function GetGlyphTable: TGlyphTableView;
    function GetHeadTable: THeadTableView;
    function GetMaxpTable: TMaxpTableView;
    function GetStringsTable: TStringTableView;
    function GetWinMetricsTable: TWinMetricsTableView;

    function GetHeader: TFontFileHeader;
    function GetHeadTableHeader: THeadTableHeader;
    function GetHorzHeader: TMetricsTableHeader;
    function GetVertHeader: TMetricsTableHeader;

    procedure CheckHeader(const h: TFontFileHeader);
    procedure CheckTableHeader(const h: TTableRecordEntry);
  protected
    procedure Init; override;
  public

    { "Stream" contains data of this font. "FontFile" contains the file either
      with this font or with a fonts collection (.ttc files). In the case when
      the file contains this single font, FontFile equals Stream. }

    constructor Create(FontFile, Stream: TStream; OwnStream: Boolean);
    destructor Destroy; override;

    procedure Accept(v: TVisitor); override;

    { Selects a mapping from charcodes to glyph indices.
      If no mapping is selected, then GetGlyphIndex(c) will try
      to find a mapping that is capable to map the charcode c. }

    function SelectMapping(Platform, Encoding: Integer): Boolean;

    function GetGlyphIndex(Char: Word): Cardinal;
    function TableExists(Name: AnsiString): Boolean;

    function GetTable(Index: Integer): TFontTableView; overload;
    function GetTableHeader(i: Integer): TTableRecordEntry;
    function GetTable(Name: AnsiString): TFontTableView; overload;

    property TablesCount: Integer read GetTablesCount;

    property GlyphsCount: Cardinal read GetGlyphsCount;
    property Glyph[g: TGlyphIndex]: TGlyphView read GetGlyph;
    property GlyphMetrics[g: TGlyphIndex]: TGlyphMetrics read GetGlyphMetrics;

    property CharmapTable: TCharmapTableView read GetCharmapTable;
    property GlyphPosTable: TGlyphPosTableView read GetGlyphPosTable;
    property HMetricsTable: TMetricsTableView read GetHMetricsTable;
    property HMetricsInfoTable: TMetricsInfoTableView read GetHMetricsInfoTable;
    property VMetricsTable: TMetricsTableView read GetVMetricsTable;
    property VMetricsInfoTable: TMetricsInfoTableView read GetVMetricsInfoTable;
    property GlyphTable: TGlyphTableView read GetGlyphTable;
    property HeadTable: THeadTableView read GetHeadTable;
    property StringsTable: TStringTableView read GetStringsTable;
    property MaxpTable: TMaxpTableView read GetMaxpTable;
    property WinMetricsTable: TWinMetricsTableView read GetWinMetricsTable;

    property FamilyName: AnsiString read GetFontName;
    property SubfamilyName: AnsiString read GetFontStyleName;
  end;

  { TTC file - a collection of TrueType fonts }

  TFontCollectionView = class(TView)
  private
    FFonts: array of TFontView; // loaded on demand

    function GetHeader: TFontCollectionFileHeader;
    function GetFontsCount: Cardinal;
    procedure CheckHeader(const h: TFontCollectionFileHeader);
    function GetFont(i: Integer): TFontView;
    procedure LoadFont(i: Integer);
  protected
    procedure Init; override;
  public
    destructor Destroy; override;

    procedure Accept(v: TVisitor); override;

    property FontsCount: Cardinal read GetFontsCount;
    property Font[i: Integer]: TFontView read GetFont; default;
  end;

  { Exceptions }

  EOpenTypeException = class(Exception);

  EInvalidOpenTypeFont          = class(EOpenTypeException);
  ETableDoesNotExist            = class(EOpenTypeException);
  EUnknownCharmapSubtableFormat = class(EOpenTypeException);
  EGlyphDoesNotExist            = class(EOpenTypeException);
  ENotEnoughDataForGlyph        = class(EOpenTypeException);
  EGlyphIndexOutOfBounds        = class(EOpenTypeException);
  EFormatNotSupported           = class(EOpenTypeException);

  { Visitor interface }

  TVisitor = class
  public
    procedure Visit(Obj: TObject);                overload; virtual;
    procedure Visit(Obj: TFontView);              overload; virtual;
    procedure Visit(Obj: TCharmapTableView);      overload; virtual;
    procedure Visit(Obj: TSegCharmapTableView);   overload; virtual;
    procedure Visit(Obj: TGlyphPosTableView);     overload; virtual;
    procedure Visit(Obj: TFontCollectionView);    overload; virtual;
    procedure Visit(Obj: TStringTableView);       overload; virtual;
    procedure Visit(Obj: TMetricsTableView);      overload; virtual;
    procedure Visit(Obj: TAsciiCharmapTableView); overload; virtual;
    procedure Visit(Obj: THeadTableView);         overload; virtual;
    procedure Visit(Obj: TCompositeGlyphView);    overload; virtual;
    procedure Visit(Obj: TSimpleGlyphView);       overload; virtual;
    procedure Visit(Obj: TNullGlyphView);         overload; virtual;
    procedure Visit(Obj: TWinMetrics1TableView);  overload; virtual;
  end;

  { Builder interface }

  TBuilder = class
  public
    procedure SaveToStream(Stream: TStream); virtual; abstract;
  end;

  { This is a helper builer. It writes the holded stream when
    someone calls its SaveToStream. This class allows to turn any
    data stream into a builder. }

  TStreamBuilder = class(TBuilder)
  private
    FStream: TStream;
    FOwn: Boolean;
  public
    constructor Create(Stream: TStream; Own: Boolean = False);
    constructor CreateWithStream;
    destructor Destroy; override;

    procedure SaveToStream(Stream: TStream); override;

    property Stream: TStream read FStream;
  end;

  { Builds a font table }

  TFontTableBuilder = class(TBuilder);

  { Builds the "cmap" table }

  TCharmapTableBuilder = class(TFontTableBuilder)
  private
    FPlatforms: array of Word;
    FEncodings: array of Word;
    FSubtables: array of TBuilder;

    procedure WriteHeader(Stream: TStream);
    procedure WriteSubHeader(Stream: TStream; i: Integer; Ptr: Cardinal);
  public
    destructor Destroy; override;

    procedure AddSubtable(Subtable: TBuilder; Platform, Encoding: Word);
    procedure SaveToStream(Stream: TStream); override;
  end;

  { Builds a charmap subtable }

  TCharmapSubtableBuilder = class(TBuilder);

  { Builds a charmap subtable of the format 4 }

  TSegCharmapTableBuilder = class(TCharmapSubtableBuilder)
  private
    FLang: Word;
    FFirst: array of Word;
    FLast: array of Word;
    FDelta: array of Word;

    procedure WriteHeader(Stream: TStream);
    procedure WriteZero(Stream: TStream; n: Integer);
    procedure WriteWords(Stream: TStream; const w: array of Word);
  public
    constructor Create(Lang: Word);

    procedure AddSegment(First, Last: Word; Delta: Word);
    procedure SaveToStream(Stream: TStream); override;
  end;

  { Builds a charmap subtable of the format 0 }

  TAsciiCharmapTableBuilder = class(TCharmapSubtableBuilder)
  private
    FGlyphs: array[0..255] of Byte;
    FLang: Word;

    procedure SetGlyphIndex(Char, Glyph: Word);
    procedure WriteHeader(Stream: TStream);
  public
    constructor Create(Lang: Word);
    procedure SaveToStream(Stream: TStream); override;
    property GlyphIndex[Char: Word]: Word write SetGlyphIndex;
  end;

  { Builds "hmtx" and "vmtx" tables }

  TMetricsTableBuilder = class(TFontTableBuilder)
  private
    FDim: array of Word;
    FSB: array of Word;
  public
    procedure AddMetric(Dim: Word; SB: SmallInt);
    procedure SaveToStream(Stream: TStream); override;
  end;

  { Builds the "name" table }

  TStringTableBuilder = class(TFontTableBuilder)
  private
    FItems: array of TStringTableEntry;
    FStrings: array of AnsiString;
    FStrRef: array of Integer;

    procedure WriteHeader(Stream: TStream; FSO: Cardinal);
    procedure WriteRecord(Stream: TStream; i: Integer; SO: Cardinal);
    procedure WriteString(Stream: TStream; const s: AnsiString);

    function FindString(const s: AnsiString): Integer;
  public
    procedure AddString(const s: AnsiString; Platform, Encoding, Language, Id: Word);
    procedure SaveToStream(Stream: TStream); override;
  end;

  { Builds a glyph }

  TGlyphBuilder = class(TBuilder);

  { Builds a simple glyph }

  TSimpleGlyphBuilder = class(TGlyphBuilder);

  { Builds a composite glyph }

  TCompositeGlyphBuilder = class(TGlyphBuilder)
  private
    FGlyph: TCompositeGlyphView;
    FComponents: array of TGlyphIndex;

    procedure LoadComponents;
    procedure SetComponent(i: Cardinal; Value: TGlyphIndex);
  public
    constructor Create(Glyph: TCompositeGlyphView);
    procedure SaveToStream(Stream: TStream); override;

    property Component[i: Cardinal]: TGlyphIndex write SetComponent;
  end;

  { Builds the "loca" table }

  TGlyphPosTableBuilder = class(TFontTableBuilder)
  private
    FOffset: array of Cardinal;

    procedure AddOffset(Offset: Cardinal);
    function GetLongOffsets: Boolean;
    function GetMaxOffset: Cardinal;
  public
    constructor Create;

    function AddGlyph(Len: Cardinal): Cardinal;
    procedure SaveToStream(Stream: TStream); override;

    property LongOffsets: Boolean read GetLongOffsets;
  end;

  { Builds the "glyf" table }

  TGlyphTableBuilder = class(TFontTableBuilder)
  private
    FGlyphs: array of TBuilder;
    FLengths: array of Cardinal;
  public
    destructor Destroy; override;

    procedure AddGlyph(Glyph: TBuilder; DesiredLength: Cardinal);
    procedure SaveToStream(Stream: TStream); override;
  end;

  { Builds a font (a .ttf file) }

  TFontBuilder = class(TBuilder)
  private
    FFontFileBase: Cardinal;
    FFont: TFontView;
    FTags: array of TFontTableTag;
    FTables: array of TBuilder;
    FCompChecksums: Boolean;

    FCharmap: TOrderedMap;  // maps charcodes to glyph indices
    FGUsed: TOrderedMap;    // set of original indices of all used glyphs
    FGRemap: TOrderedMap;   // maps original glyph indices to new ones
    FGlyphs: WordArray;     // list of original indices for all used glyphs
    FChars: WordArray;      // list of all used charcodes

    function RemapGlyph(g: TGlyphIndex): TGlyphIndex; // maps original index to index in repacked font
    function MapCharToGlyph(c: Word): TGlyphIndex;    // maps charcode to glyph index in original font

    function CreateMetricsInfoTable(View: TMetricsInfoTableView; NumMetrics: Word): TBuilder;
    function CreateSegCharmapTable(Lang: Word): TSegCharmapTableBuilder;
    function CreateAsciiCharmapTable(Lang: Word): TAsciiCharmapTableBuilder;
    function CreateCharmapTable: TCharmapTableBuilder;
    function CreateMetricsTable(View: TMetricsTableView): TMetricsTableBuilder;
    function CreateMaxpTable(NumGlyphs: Word): TBuilder;
    function CreateHeadTable(LongOffsets: Boolean): TBuilder;
    function CreateStringTable: TStringTableBuilder;

    procedure RepackGlyphs(out Glyf, Loca: TFontTableBuilder; out LongOffsets: Boolean);

    procedure AddDescendantGlyphs(g: TGlyphIndex);
    procedure BuildGlyphsRemapping; // fills in FGRemap, FGlyphs
    procedure BuildCharsList; // fills in FChars

    procedure WriteHeader(Stream: TStream);
    procedure WriteTableRecord(Stream: TStream; Index, Offset, Len, Checksum: Cardinal);

    procedure CopyTableFromSrcFont(Name: TFontTableTag);
    procedure AddTable(Tag: TFontTableTag; Table: TBuilder);
    procedure SaveTablesToStream(Stream: TStream);
  public
    constructor Create(Font: TFontView);
    destructor Destroy; override;

    procedure AddCharset(Charset: TBitArray);
    procedure AddChar(c: Word);
    procedure SaveToStream(Stream: TStream); override;

    function GetUsedGlyphs: TBitArray;

    property ComputeChecksums: Boolean read FCompChecksums write FCompChecksums;
    property FontFileBase: Cardinal read FFontFileBase write FFontFileBase;
  end;

  { Builds a fonts collection (a .ttc file) }

  TFontCollectionBuilder = class(TBuilder)
  private
    FFonts: array of TFontBuilder;
    procedure WriteHeader(Stream: TStream);
  public
    destructor Destroy; override;
    procedure AddFont(Font: TFontBuilder);
    procedure SaveToStream(Stream: TStream); override;
  end;

{ Creates either a font (TFontView) or a font collection (TFontCollectionView).
  If the stream contains a malformed data - raises an exception. }

function OpenFont(Stream: TStream): TView;

{ Extracts from a font a specified set of characters.

  If Font is TFontView, then a builder of a single font (.ttf file) will returned.

  If Font is TFontCollectionView then a builder of a fonts collection
  (.ttc file) will be returned. The returned collection will have
  the same number of fonts as in Font and each font in the result
  will contain the specified set of characters from the corresponding font. }

function PackFont(Font: TView; const UsedChars: TBitArray): TBuilder;

implementation

procedure Error(const Msg: string);
begin
  raise EInvalidOpenTypeFont.Create(Msg)
end;

procedure Check(Condition: Boolean; const Msg: string = 'Invalid font');
begin
  if not Condition then
    Error(Msg)
end;

{ Use it for n = 1..4 }

procedure WriteZeros(Stream: TStream; n: Integer);
var
  z: Cardinal;
begin
  while n > SizeOf(z) do
  begin
    WriteZeros(Stream, SizeOf(z));
    Dec(n, SizeOf(z));
  end;

  if n = 0 then
    Exit;

  z := 0;
  Stream.WriteBuffer(z, n);
end;

function Log2(x: Word): Word;
begin
  Result := 0;

  while x > 1 do
  begin
    Inc(Result);
    x := x div 2;
  end;
end;

procedure Zero(var p; Size: Cardinal);
begin
  FillChar(p, Size, 0)
end;

function Swap(x: Cardinal): Cardinal; overload;
begin
  Result :=
    (x shr 0  and $ff shl 24) or
    (x shr 8  and $ff shl 16) or
    (x shr 16 and $ff shl 8) or
    (x shr 24 and $ff shl 0)
end;

function Swap(x: Word): Word; overload;
begin
  Result := (x and $ff shl 8) or (x shr 8)
end;

function Swap(x: Int64): Int64; overload;
begin
  Result := (Int64(Swap(Cardinal(x and $ffffffff))) shl 32) xor
    Int64(Swap(Cardinal(x shr 32)))
end;

function Swap(x: SmallInt): SmallInt; overload;
begin
  Result := SmallInt(Swap(Word(x)))
end;

procedure Swap(var a: array of Word); overload;
var
  i: Integer;
begin
  for i := Low(a) to High(a) do
    a[i] := Swap(a[i])
end;

procedure Swap(var a: array of SmallInt); overload;
var
  i: Integer;
begin
  for i := Low(a) to High(a) do
    a[i] := Swap(a[i])
end;

procedure Swap(var s: WideString); overload;
var
  i: Integer;
begin
  for i := 1 to Length(s) do
    s[i] := WideChar(Swap(Word(s[i])))
end;

procedure SwapIP(var a: Word); overload;
begin
  a := Swap(a)
end;

procedure SwapIP(var a: SmallInt); overload;
begin
  a := Swap(a)
end;

procedure SwapIP(var a: Cardinal); overload;
begin
  a := Swap(a)
end;

procedure Swap(var h: TWinMetrics1TableHeader); overload;
begin
  with h do
  begin
    SwapIP(Version);
    SwapIP(AvgWidth);
    SwapIP(Weight);
    SwapIP(Width);
    SwapIP(Rights);

    SwapIP(SubXSize);
    SwapIP(SubYSize);
    SwapIP(SubXOffset);
    SwapIP(SubYOffset);

    SwapIP(SupXSize);
    SwapIP(SupYSize);
    SwapIP(SupXOffset);
    SwapIP(SupYOffset);

    SwapIP(StrikeSize);
    SwapIP(StrikePos);
    SwapIP(Family);

    // todo: swap Panose?
    // todo: swap UniRange?
    // todo: swap Vendor?

    SwapIP(Selection);
    SwapIP(FirstChar);
    SwapIP(LastChar);
    SwapIP(Ascender);
    SwapIP(Descender);
    SwapIP(WinAscent);
    SwapIP(WinDescent);

    // todo: swap PageRange?

    {
    SwapIP(Height);
    SwapIP(CapHeight);
    SwapIP(DefChar);
    SwapIP(BreakChar);
    SwapIP(MaxContext);
    }
  end;
end;

procedure Swap(var h: TGlyphHeader); overload;
begin
  with h do
  begin
    NumContours := Swap(NumContours);
    XMin := Swap(XMin);
    XMax := Swap(XMax);
    YMin := Swap(YMin);
    YMax := Swap(YMax);
  end;
end;

procedure Swap(var h: TGlyphEntryHeader); overload;
begin
  with h do
  begin
    Flags := Swap(Flags);
    Glyph := Swap(Glyph);
  end;
end;

procedure Swap(var h: TMetricsTableHeader); overload;
begin
  with h do
  begin
    Version   := Swap(Version);
    Ascent    := Swap(Ascent);
    Descent   := Swap(Descent);
    LineGap   := Swap(LineGap);
    MaxWidth  := Swap(MaxWidth);
    MinSB1    := Swap(MinSB1);
    MinSB2    := Swap(MinSB2);
    MaxExtent := Swap(MaxExtent);
    SlopeRise := Swap(SlopeRise);
    SlopeRun  := Swap(SlopeRun);
    Offset    := Swap(Offset);
    Metric    := Swap(Metric);
    NumMetrics:= Swap(NumMetrics);
  end;
end;

procedure Swap(var h: TAsciiCharmapTableHeader); overload;
begin
  with h do
  begin
    Format  := Swap(Format);
    Length  := Swap(Length);
    Lang    := Swap(Lang);
  end;
end;

procedure Swap(var h: TStringTableHeader); overload;
begin
  with h do
  begin
    Format    := Swap(Format);
    Count     := Swap(Count);
    Offset    := Swap(offset);
  end;
end;

procedure Swap(var h: TStringRecord); overload;
begin
  with h do
  begin
    Platform  := Swap(Platform);
    Encoding  := Swap(Encoding);
    Language  := Swap(Language);
    Id        := Swap(Id);
    Size      := Swap(Size);
    Offset    := Swap(Offset);
  end;
end;

procedure Swap(var h: TFontFileHeader); overload;
begin
  with h do
  begin
    NumTables := Swap(NumTables);
    Selector  := Swap(Selector);
    Shift     := Swap(Shift);
    Range     := Swap(Range);
    Version   := Swap(Version);
  end;
end;

procedure Swap(var h: TTableRecordEntry); overload;
begin
  with h do
  begin
    Checksum  := Swap(Checksum);
    Offset    := Swap(Offset);
    Length    := Swap(Length);
  end;
end;

procedure Swap(var h: TFontCollectionFileHeader); overload;
begin
  with h do
  begin
    Version   := Swap(Version);
    NumFonts  := Swap(NumFonts);
  end;
end;

procedure Swap(var h: TSegCharmapTableHeader); overload;
begin
  with h do
  begin
    Format    := Swap(Format);
    Length    := Swap(Length);
    Lang      := Swap(Lang);
    SegCount2 := Swap(SegCount2);
    Range     := Swap(Range);
    Selector  := Swap(Selector);
    Shift     := Swap(Shift);
  end;
end;

procedure Swap(var h: TCharmapSubtableRecordEntry); overload;
begin
  with h do
  begin
    Platform  := Swap(Platform);
    Encoding  := Swap(Encoding);
    Offset    := Swap(Offset);
  end;
end;

procedure Swap(var h: TCharmapTableHeader); overload;
begin
  with h do
  begin
    Version   := Swap(Version);
    NumTables := Swap(NumTables);
  end;
end;

procedure Swap(var h: TFontBox); overload;
begin
  with h do
  begin
    XMin        := Swap(XMin);
    YMin        := Swap(YMin);
    XMax        := Swap(XMax);
    YMax        := Swap(YMax);
  end;
end;

procedure Swap(var h: THeadTableHeader); overload;
begin
  with h do
  begin
    Version     := Swap(Version);
    Revision    := Swap(Revision);
    Checksum    := Swap(Checksum);
    Signature   := Swap(Signature);
    Flags       := Swap(Flags);
    UnitsPerEm  := Swap(UnitsPerEm);
    Created     := Swap(Created);
    Modified    := Swap(Modified);
    Style       := Swap(Style);
    Smallest    := Swap(Smallest);
    DirHint     := Swap(DirHint);
    LongOffset  := Swap(LongOffset);
    Format      := Swap(Format);

    Swap(FontBox);
  end;
end;

procedure Swap(var h: TMaxpTableHeader); overload;
begin
  with h do
  begin
    Version     := Swap(Version);
    NumGlyphs   := Swap(NumGlyphs);
    MaxPoints   := Swap(MaxPoints);
    MaxContours := Swap(MaxContours);
    MaxCompPts  := Swap(MaxCompPts);
    MaxCompCtrs := Swap(MaxCompCtrs);
    MaxZones    := Swap(MaxZones);
    MaxTwPoints := Swap(MaxTwPoints);
    MaxStorage  := Swap(MaxStorage);
    MaxFunc     := Swap(MaxFunc);
    MaxInst     := Swap(MaxInst);
    MaxStack    := Swap(MaxStack);
    MaxInstSize := Swap(MaxInstSize);
    MaxComp     := Swap(MaxComp);
    MaxDepth    := Swap(MaxDepth);
  end;
end;

{$Q-}
function SumNoOverflow(a, b: Cardinal): Cardinal; overload;
begin
  Result := a + b
end;

function SumNoOverflow(a, b: Word): Word; overload;
begin
  Result := (Cardinal(a) + Cardinal(b)) and $ffff
end;
{$Q+}

function GetTableChecksum(Stream: TStream): Cardinal;
var
  a: array[0..64] of Cardinal;
  i, n: Integer;
begin
  Assert(SizeOf(a[0]) = 4);
  Result := 0;

  while True do
  begin
    n := Stream.Read(a[0], SizeOf(a));

    if n = 0 then
      Exit;

    for i := 0 to n div 4 - 1 do
      Result := SumNoOverflow(Result, Swap(a[i]));

    if n mod 4 > 0 then
      Result := SumNoOverflow(Result, Swap(Cardinal(a[n div 4] and ((1 shl (8 * (n mod 4))) - 1))));
  end;
end;

function OpenFont(Stream: TStream): TView;
var
  Sign: array[1..4] of AnsiChar;
begin
  Check(Stream.Size >= 4);

  Stream.Position := 0;
  Stream.ReadBuffer(Sign[1], 4);

  if Sign = 'ttcf' then
    Result := TFontCollectionView.Create(Stream, False)
  else
    Result := TFontView.Create(Stream, Stream, False)
end;

function PackFont(Font: TView; const UsedChars: TBitArray): TBuilder;

  function CreateFont(Font: TFontView): TFontBuilder;
  begin
    Result := TFontBuilder.Create(Font);
    Result.AddCharset(UsedChars);
  end;

  function CreateFontCollection(FC: TFontCollectionView): TFontCollectionBuilder;
  var
    i: Integer;
  begin
    Result := TFontCollectionBuilder.Create;

    for i := 0 to FC.FontsCount - 1 do
      Result.AddFont(CreateFont(FC.Font[i]));
  end;

begin
  if Font is TFontView then
    Result := CreateFont(Font as TFontView)

  else if Font is TFontCollectionView then
    Result := CreateFontCollection(Font as TFontCollectionView)

  else
    raise EFormatNotSupported.Create('Unknown font format: ' + Font.ClassName)
end;

{ TVisitor }

procedure TVisitor.Visit(Obj: TObject);
begin
end;

procedure TVisitor.Visit(Obj: TCharmapTableView);
begin
end;

procedure TVisitor.Visit(Obj: TFontView);
begin
end;

procedure TVisitor.Visit(Obj: TSegCharmapTableView);
begin
end;

procedure TVisitor.Visit(Obj: TGlyphPosTableView);
begin
end;

procedure TVisitor.Visit(Obj: TFontCollectionView);
begin
end;

procedure TVisitor.Visit(Obj: TStringTableView);
begin
end;

procedure TVisitor.Visit(Obj: TMetricsTableView);
begin
end;

procedure TVisitor.Visit(Obj: TAsciiCharmapTableView);
begin
end;

procedure TVisitor.Visit(Obj: THeadTableView);
begin
end;

procedure TVisitor.Visit(Obj: TCompositeGlyphView);
begin
end;

procedure TVisitor.Visit(Obj: TSimpleGlyphView);
begin
end;

procedure TVisitor.Visit(Obj: TNullGlyphView);
begin
end;

procedure TVisitor.Visit(Obj: TWinMetrics1TableView);
begin
end;

{ TView }

procedure TView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

constructor TView.Create(Stream: TStream; OwnStream: Boolean);
begin
  Assert(Stream <> nil);
  FStream := Stream;
  FOwnStream := OwnStream;
  Init;
end;

destructor TView.Destroy;
begin
  if FOwnStream then
    FStream.Free;

  inherited;
end;

function TView.GetSize: Cardinal;
begin
  Result := FStream.Size
end;

procedure TView.Init;
begin
end;

{ TFontView }

constructor TFontView.Create(FontFile, Stream: TStream; OwnStream: Boolean);
begin
  inherited Create(Stream, OwnStream);
  FFontFile := FontFile;
  FGlyphs := TObjList.Create;
end;

destructor TFontView.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(FTables) do
    FTables[i].Free;

  FGlyphs.Free;
  inherited;
end;

procedure TFontView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

function TFontView.GetHeader: TFontFileHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

procedure TFontView.CheckHeader(const h: TFontFileHeader);
begin
  with h do
  begin
    {$IFDEF EXTENSIVE_CHECKS}
    Check(Selector = Log2(NumTables));
    Check(Range = 16 * (1 shl Log2(NumTables)));
    Check(Shift = 16 * NumTables - Range);
    {$ENDIF}
  end;
end;

procedure TFontView.CheckTableHeader(const h: TTableRecordEntry);

  procedure CheckChar(c: AnsiChar);
  begin
    Check(Ord(c) in [32..126])
  end;

begin
  {$IFDEF EXTENSIVE_CHECKS}
  ChecKChar(h.Tag[1]);
  ChecKChar(h.Tag[2]);
  ChecKChar(h.Tag[3]);
  ChecKChar(h.Tag[4]);
  {$ENDIF}

  Check(Size >= h.Offset + h.Length);
end;

procedure TFontView.Init;
var
  i: Integer;
  h: TFontFileHeader;
begin
  inherited;

  Check(Size >= SizeOf(GetHeader));

  h := GetHeader;
  CheckHeader(h);

  Check(Size >= SizeOf(h) + h.NumTables * SizeOf(TTableRecordEntry));
  SetLength(FTables, h.NumTables);

  for i := 0 to High(FTables) do
    FTables[i] := nil;
end;

function TFontView.FindTable(Name: AnsiString): Integer;
begin
  for Result := 0 to High(FTables) do
    if GetTableHeader(Result).Tag = Name then
      Exit;

  Result := -1;
end;

function TFontView.GetCharmapTable: TCharmapTableView;
begin
  if FCharmapTable = nil then
    FCharmapTable := GetTable('cmap') as TCharmapTableView;

  Result := FCharmapTable;
  Assert(FCharmapTable <> nil);
end;

function TFontView.GetString(NameId: Integer): AnsiString;
var
  i: Integer;
begin
  Result := '';

  if not TableExists('name') then
    Exit;

  with StringsTable do
    for i := 0 to Count - 1 do
      if Entry[i].Id = NameId then
      begin
        Result := Strings[i];
        Exit;
      end;
end;

function TFontView.GetFontName: AnsiString;
begin
  Result := GetString(1)
end;

function TFontView.GetFontStyleName: AnsiString;
begin
  Result := GetString(2)
end;

function TFontView.GetHeadTable: THeadTableView;
begin
  Result := GetTable('head') as THeadTableView;
  Assert(Result <> nil);
end;

function TFontView.GetHeadTableHeader: THeadTableHeader;
begin
  Result := HeadTable.Header
end;

function TFontView.GetHMetricsInfoTable: TMetricsInfoTableView;
begin
  Result := GetTable('hhea') as TMetricsInfoTableView;
  Assert(Result <> nil);
end;

function TFontView.GetHMetricsTable: TMetricsTableView;
begin
  if FHMetricstable = nil then
    FHMetricstable := GetTable('hmtx') as TMetricsTableView;

  Result := FHMetricstable;
  Assert(Result <> nil);
end;

function TFontView.GetGlyphIndex(Char: Word): Cardinal;
begin
  if FCurCharmap = nil then
    Result := CharmapTable.GetGlyphIndex(Char)
  else
    Result := FCurCharmap[Char]
end;

function TFontView.GetGlyphMetrics(g: TGlyphIndex): TGlyphMetrics;
begin
  Assert(g < GlyphsCount);
  Zero(Result, SizeOf(Result));

  if TableExists('hmtx') and TableExists('hhea') then
    with HMetricsTable do
    begin
      Result.AdvWidth   := Dim[g];
      Result.LeftSB     := SB[g];
    end;

  if TableExists('vmtx') and TableExists('vhea') then
    with VMetricsTable do
    begin
      Result.AdvHeight  := Dim[g];
      Result.TopSB      := SB[g];
    end;
end;

function TFontView.GetGlyphPosTable: TGlyphPosTableView;
begin
  if FGlyphPosTable = nil then
    FGlyphPosTable := GetTable('loca') as TGlyphPosTableView;

  Result := FGlyphPosTable;
  Assert(Result <> nil);
end;

function TFontView.GetGlyphsCount: Cardinal;
begin
  if FGlyphsCount = 0 then
    FGlyphsCount := MaxpTable.NumGlyphs;

  Result := FGlyphsCount
end;

function TFontView.GetGlyphTable: TGlyphTableView;
begin
  if FGlyphTable = nil then
    FGlyphTable := GetTable('glyf') as TGlyphTableView;

  Result := FGlyphTable;
  Assert(Result <> nil);
end;

function TFontView.GetGlyph(g: TGlyphIndex): TGlyphView;

  procedure ExpandGlyphsList;
  var
    i, n: Integer;
  begin
    if g < FGlyphs.Count then
      Exit;

    n := FGlyphs.Count;
    FGlyphs.Count := g + 1;

    for i := n to g do
      FGlyphs[i] := nil;
  end;

  function CreateGlyph: TGlyphView;
  var
    s: TStream;
  begin
    s := TProxyStream.Create(
      GetGlyphTable.Stream,
      GetGlyphPosTable.GlyphOffset[g],
      GetGlyphPosTable.GlyphLength[g]);

    Result := TGlyphView.CreateGlyph(s, True);
  end;

begin
  Assert(g < GlyphsCount);
  ExpandGlyphsList;

  if FGlyphs[g] = nil then
    FGlyphs[g] := CreateGlyph;

  Result := FGlyphs[g];
  Assert(Result <> nil);
end;

function TFontView.GetHorzHeader: TMetricsTableHeader;
begin
  Result := HMetricsInfoTable.Header
end;

function TFontView.GetVertHeader: TMetricsTableHeader;
begin
  Result := VMetricsInfoTable.Header
end;

function TFontView.GetMaxpTable: TMaxpTableView;
begin
  Result := GetTable('maxp') as TMaxpTableView;
  Assert(Result <> nil);
end;

function TFontView.GetStringsTable: TStringTableView;
begin
  Result := GetTable('name') as TStringTableView;
  Assert(Result <> nil);
end;

function TFontView.GetVMetricsInfoTable: TMetricsInfoTableView;
begin
  Result := GetTable('vhea') as TMetricsInfoTableView;
  Assert(Result <> nil);
end;

function TFontView.GetVMetricsTable: TMetricsTableView;
begin
  Result := GetTable('vmtx') as TMetricsTableView;
  Assert(Result <> nil);
end;

function TFontView.GetWinMetricsTable: TWinMetricsTableView;
begin
  Result := GetTable('OS/2') as TWinMetricsTableView;
  Assert(Result <> nil);
end;

function TFontView.GetTable(Index: Integer): TFontTableView;
begin
  if (Index < 0) or (Index > High(FTables)) then
    raise ETableDoesNotExist.CreateFmt('Table #%d does not exist', [Index]);

  if FTables[Index] = nil then
    LoadTable(Index);

  Result := FTables[Index]
end;

function TFontView.GetTable(Name: AnsiString): TFontTableView;
var
  i: Integer;
begin
  i := FindTable(Name);

  if i < 0 then
    raise ETableDoesNotExist.CreateFmt('Table "%s" does not exist', [Name]);

  Result := GetTable(i)
end;

function TFontView.GetTableHeader(i: Integer): TTableRecordEntry;
begin
  Stream.Position := SizeOf(TFontFileHeader) + i * SizeOf(TTableRecordEntry);
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

function TFontView.GetTablesCount: Integer;
begin
  Result := Length(FTables)
end;

procedure TFontView.LoadTable(i: Integer);
var
  th: TTableRecordEntry;
  ts: TStream;
begin
  th := GetTableHeader(i);
  CheckTableHeader(th);

  ts := TProxyStream.Create(FFontFile, th.Offset, th.Length);

  try
    {$IFDEF EXTENSIVE_CHECKS}
    Check((th.Tag = 'head') or (th.Checksum = GetTableChecksum(ts)));
    {$ENDIF}

    FTables[i] := CreateTable(th.Tag, ts, True);
  except
    ts.Free;
    raise;
  end;
end;

function TFontView.SelectMapping(Platform, Encoding: Integer): Boolean;
var
  i: Integer;
begin
  for i := 0 to CharmapTable.SubtablesCount - 1 do
    if (CharmapTable.Platform[i] = Platform) and (CharmapTable.Encoding[i] = Encoding) then
    begin
      FCurCharmap := CharmapTable.Subtable[i];
      Result := True;
      Exit;
    end;

  FCurCharmap := nil;
  Result := False;
end;

function TFontView.TableExists(Name: AnsiString): Boolean;
begin
  Result := FindTable(Name) >= 0
end;

function TFontView.CreateTable(Name: AnsiString; Stream: TStream; Own: Boolean): TFontTableView;
begin
  { CreateTable can be called only from LoadTable,
    that is called only after the TFontView object created.
    Thus CreateTable can access other tables by name. }

  if Name = 'head' then
    Result := THeadTableView.Create(Stream, Own)

  else if Name = 'cmap' then
    Result := TCharmapTableView.Create(Stream, Own)

  else if Name = 'hhea' then
    Result := TMetricsInfoTableView.Create(Stream, Own)

  else if Name = 'vhea' then
    Result := TMetricsInfoTableView.Create(Stream, Own)

  else if Name = 'name' then
    Result := TStringTableView.Create(Stream, Own)

  else if Name = 'maxp' then
    Result := TMaxpTableView.Create(Stream, Own)

  else if Name = 'glyf' then
    Result := TGlyphTableView.Create(Stream, Own)

  else if Name = 'OS/2' then
    Result := TWinMetrics1TableView.Create(Stream, Own)

  else if Name = 'hmtx' then
    Result := TMetricsTableView.Create(
      Stream,
      Own,
      GetHorzHeader.NumMetrics,
      GlyphsCount)

  else if Name = 'vmtx' then
    Result := TMetricsTableView.Create(
      Stream,
      Own,
      GetVertHeader.NumMetrics,
      GlyphsCount)

  else if Name = 'loca' then
    Result := TGlyphPosTableView.Create(
      Stream,
      Own,
      GetHeadTableHeader.LongOffset = 1,
      GlyphsCount)

  else
    Result := TFontTableView.Create(Stream, Own);
end;

{ THeadTableView }

procedure THeadTableView.Init;
begin
  inherited;
  Check(Size >= SizeOf(THeadTableHeader));
  {$IFDEF EXTENSIVE_CHECKS}
  Check(GetHeader.Signature = $5F0F3CF5);
  {$ENDIF}
end;

procedure THeadTableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

function THeadTableView.GetHeader: THeadTableHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

{ TWinMetricsTableView }

procedure TWinMetricsTableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

function TWinMetricsTableView.GetVersion: Word;
begin
  Check(Size >= 2);
  Stream.Position := 0;
  Stream.ReadBuffer(Result, 2);
  SwapIP(Result);
end;

procedure TWinMetricsTableView.Init;
begin
  inherited;
  Check(Size >= 2);
end;

{ TWinMetrics1TableView }

procedure TWinMetrics1TableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

function TWinMetrics1TableView.GetHeader: TWinMetrics1TableHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, Sizeof(Result));
  Swap(Result);
end;

procedure TWinMetrics1TableView.Init;
begin
  inherited;
  Check(Size >= SizeOf(Header));
end;

{ TCharmapTableView }

procedure TCharmapTableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

procedure TCharmapTableView.Init;
var
  i: Integer;
  h: TCharmapTableHeader;
begin
  inherited;

  Check(Size >= SizeOf(h));
  h := GetHeader;

  Check(Size >= 4 + 8 * h.NumTables);
  SetLength(FSubtables, h.NumTables);

  for i := 0 to High(FSubtables) do
    FSubtables[i] := nil;
end;

destructor TCharmapTableView.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(FSubtables) do
    FSubtables[i].Free;

  inherited;
end;

function TCharmapTableView.GetGlyphIndex(Char: Word): Cardinal;
var
  i: Integer;
begin
  for i := 0 to SubtablesCount - 1 do
  begin
    Result := Subtable[i].GetGlyphIndex(Char);

    if Result <> 0 then
      Exit;
  end;

  Result := 0;
end;

function TCharmapTableView.GetHeader: TCharmapTableHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

function TCharmapTableView.GetEncoding(i: Integer): Word;
begin
  Result := GetSubtableRecordEntry(i).Encoding
end;

function TCharmapTableView.GetPlatform(i: Integer): Word;
begin
  Result := GetSubtableRecordEntry(i).Platform
end;

function TCharmapTableView.GetSubtableRecordEntry(i: Integer): TCharmapSubtableRecordEntry;
begin
  Stream.Position := 4 + 8 * i;
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

function TCharmapTableView.GetSubtablesCount: Integer;
begin
  Result := Length(FSubtables)
end;

function TCharmapTableView.GetSubtable(i: Integer): TCharmapSubtableView;
begin
  if FSubtables[i] = nil then
    LoadSubtable(i);

  Result := FSubtables[i];
end;

procedure TCharmapTableView.LoadSubtable(i: Integer);
var
  Offset: Cardinal;
  ps: TStream;
  Len: Cardinal;
begin
  Offset := GetSubtableRecordEntry(i).Offset;
  Check(Size > Offset + 2);
  Stream.Position := Offset;
  Len := TCharmapSubtableView.GetSubtableLength(Stream);
  Check(Size >= Offset + Len);

  ps := TProxyStream.Create(Stream, Offset, Len);
  FSubtables[i] := TCharmapSubtableView.CreateSubtable(ps, True);
end;

{ TCharmapSubtableView }

procedure TCharmapSubtableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

class function TCharmapSubtableView.CreateSubtable(Stream: TStream;
  OwnStream: Boolean): TCharmapSubtableView;
var
  Fmt: Word;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Fmt, SizeOf(Fmt));
  Fmt := Swap(Fmt);

  case Fmt of
    0: Result := TAsciiCharmapTableView.Create(Stream, OwnStream);
    4: Result := TSegCharmapTableView.Create(Stream, OwnStream);

    else Result := TEmptyCharmapTableView.Create(Stream, OwnStream);
  end;
end;

function TCharmapSubtableView.GetFormat: Word;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, 2);
  Result := Swap(Result);
end;

class function TCharmapSubtableView.GetSubtableLength(Stream: TStream): Cardinal;
var
  Fmt: Word;
begin
  Result := 0;

  with Stream do
  begin
    ReadBuffer(Fmt, 2);
    Fmt := Swap(Fmt);

    case Fmt of
      0, 2, 4, 6:
      begin
        ReadBuffer(Result, 2);
        Result := Swap(Word(Result));
      end;

      8, 10, 12, 13:
      begin
        Seek(2, soFromCurrent);
        ReadBuffer(Result, 4);
        Result := Swap(Result);
      end;

      14:
      begin
        ReadBuffer(Result, 4);
        Result := Swap(Result);
      end;

      else raise EUnknownCharmapSubtableFormat.CreateFmt('Format %d is unknown', [Fmt]);
    end;
  end;
end;

{ TSegCharmapTableView }

procedure TSegCharmapTableView.Init;
var
  h: TSegCharmapTableHeader;
  ts: Integer;
begin
  inherited;

  Check(Size >= SizeOf(h));
  h := GetHeader;
  CheckHeader(h);

  FSegNum := h.SegCount2 div 2;
  Check(Size >= SizeOf(h) + 2 + 2 * 4 * Cardinal(FSegNum));

  ts := Integer(Size) - (SizeOf(h) + 2 + 2 * 4 * FSegNum);

  {$IFDEF EXTENSIVE_CHECKS}
  Check(ts mod 2 = 0);
  {$ENDIF}

  FGlyphNum := ts div 2;
end;

procedure TSegCharmapTableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

procedure TSegCharmapTableView.CheckHeader(const h: TSegCharmapTableHeader);
begin
  with h do
  begin
    {$IFDEF EXTENSIVE_CHECKS}
    Check(Format = 4);
    Check(SegCount2 mod 2 = 0);
    Check(Range = 2 * (1 shl Log2(SegCount2 div 2)));
    Check(Selector = Log2(SegCount2 div 2));
    Check(Shift = SegCount2 - Range);
    Check(Length >= SizeOf(h));
    {$ENDIF}
  end;
end;

function TSegCharmapTableView.GetHeader: TSegCharmapTableHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

function TSegCharmapTableView.GetFirst(i: Integer): Word;
begin
  Check((i >= 0) and (i < FSegNum));
  Result := GetWord(FFirst, i, 2 + FSegNum * 2 + i * 2);
end;

function TSegCharmapTableView.GetLast(i: Integer): Word;
begin
  Check((i >= 0) and (i < FSegNum));
  Result := GetWord(FLast, i, i * 2);
end;

function TSegCharmapTableView.GetDelta(i: Integer): Word;
begin
  Check((i >= 0) and (i < FSegNum));
  Result := GetWord(FDelta, i, 2 + 2 * FSegNum * 2 + i * 2);
end;

function TSegCharmapTableView.GetOffset(i: Integer): Word;
begin
  Check((i >= 0) and (i < FSegNum));
  Result := GetWord(FOffset, i, 2 + 3 * FSegNum * 2 + i * 2);
end;

function TSegCharmapTableView.GetGlyph(i: Integer): Word;
begin
  Check((i >= 0) and (i < FGlyphNum));
  Result := ReadWord(2 + 4 * FSegNum * 2 + i * 2);
end;

function TSegCharmapTableView.GetWord(var w: WordArray; i: Integer; p: Cardinal): Word;
var
  n: Integer;
begin
  if i > High(w) then
  begin
    n := Length(w);
    SetLength(w, i + 9); // i + 1 is enough, but i + 9 reduces memory reallocations
    FillChar(w[n], 2 * (Length(w) - n), $11);
  end;

  if w[i] = $1111 then
    w[i] := ReadWord(p);

  Result := w[i];
end;

function TSegCharmapTableView.ReadWord(Offset: Cardinal): Word;
begin
  Stream.Position := SizeOf(TSegCharmapTableHeader) + Offset;
  Stream.ReadBuffer(Result, 2);
  Result := Swap(Result);
end;

function TSegCharmapTableView.GetLanguage: Word;
begin
  Result := GetHeader.Lang
end;

function TSegCharmapTableView.GetGlyphIndex(Char: Word): TGlyphIndex;

  function GetIndex(i: Integer; out g: TGlyphIndex): Integer;
  begin
    if Char < First[i] then
      Result := -1
    else if Char > Last[i] then
      Result := +1
    else
    begin
      {$IFDEF EXTENSIVE_CHECKS}
      Check(Offset[i] mod 2 = 0);
      {$ENDIF}

      if Offset[i] = 0 then
        g := SumNoOverflow(Delta[i], Char)
      else
        g := Glyph[Offset[i] div 2 + i - SegCount + (Char - First[i])];

      Result := 0;
    end;
  end;

var
  i, j, m: Integer;
begin
  Result := 0;
  i := 0;
  j := SegCount - 1;

  while i <= j do
  begin
    m := i + (j - i) div 2;

    case GetIndex(m, Result) of
      -1: j := m - 1;
      +1: i := m + 1;

      else Break;
    end;
  end;
end;

class function TSegCharmapTableView.FindOptimalMapping(const Chars, Glyphs: WordArray;
  out Seg: WordArray): Word;
var
  Size: array of Word; // Size[i] = optimal size for Chars[0]..Chars[i]
  Len:  array of Word; // Len[i] = length of a segment ending on Chars[i]

  function Delta(i: Integer): Integer;
  begin
    Result := Integer(Chars[i]) - Integer(Glyphs[i])
  end;

  { Returns size of one segment that covers Chars[First]..Chars[Last] chars.
    If these chars cannot be covered by one segment, -1 is returned. }

  function GetSize(First, Last: Integer): Integer;
  var
    i: Integer;
  begin
    Result := -1;

    { todo -cOptimisation: A better mapping can be done.
      This function is aware about only one segments kind - segments
      that operate as the shift operator: GID = CID + Delta.
      However, there's another segments kind - segments that
      perform arbitrary mapping: GID = Map[CID]. This kind
      of segments is not currently supported by charmap builders,
      that's why this function is aware only about one kind of segments. }

    for i := First + 1 to Last do
      if Delta(i) <> Delta(i - 1) then
        Exit;

    if (First = Last) and (Glyphs[First] = 0) then
      Result := 0
    else
      Result := 8
  end;

  { Finds optimal mapping for Chars[0]..Chars[i] }

  procedure Find(Last: Integer);
  var
    i, iOpt: Integer;
    sOpt, sTest: Integer;
  begin
    iOpt := Last;
    sOpt := GetSize(0, Last);

    // try segments 0..i and i+1..Last

    for i := Last - 1 downto 0 do
    begin
      sTest := GetSize(i + 1, Last);

      // if a the segment is invalid, then it's useless to extend it
      if sTest < 0 then
        Break;

      if (sTest >= 0) and ((sOpt < 0) or (Size[i] + sTest < sOpt)) then
      begin
        sOpt := Size[i] + sTest;
        iOpt := i;
      end;
    end;

    // i = Last-1 must give a positive sOpt
    Assert(sOpt >= 0);

    Size[Last] := Word(sOpt);

    if iOpt < Last then
      Len[Last] := Last - iOpt
    else
      Len[Last] := Last + 1
  end;

  { Finds the number of segments from the Len array }

  function GetSegCount: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    i := Length(Len) - 1;

    while i >= 0 do
    begin
      Inc(Result);
      Dec(i, Len[i]);
    end;
  end;

  { Finds segment lengths Seg from the Len array }

  procedure GetLayout;
  var
    i, s: Integer;
  begin
    SetLength(Seg, GetSegCount);

    i := Length(Len) - 1;
    s := Length(Seg) - 1;

    while i >= 0 do
    begin
      Seg[s] := Len[i];
      Dec(s);
      Dec(i, Len[i]);
    end;
  end;

  function GetLayoutSize: Word;
  var
    i, s: Integer;
    n: Word;
  begin
    n := 0;
    Result := 0;

    for i := 0 to High(Seg) do
    begin
      s := GetSize(n, n + Seg[i] - 1);
      Assert(s >= 0);
      Inc(Result, Word(s));
      Inc(n, Seg[i]);
    end;
  end;

  function SumSeg: Word;
  var
    i: Integer;
  begin
    Result := 0;

    for i := 0 to High(Seg) do
      Inc(Result, Seg[i]);
  end;

var
  i: Integer;
begin
  Assert(Length(Chars) = Length(Glyphs));

  SetLength(Size, Length(Chars));
  SetLength(Len, Length(Chars));

  // if there's only one char, it's covered by one segment

  Size[0] := Word(GetSize(0, 0));
  Len[0] := 1;

  for i := 1 to Length(Size) - 1 do
    Find(i);

  // get explicit segments layout

  GetLayout;

  Assert(Size[High(Size)] = GetLayoutSize);
  Assert(SumSeg = Length(Chars));

  // now Seg[i] contains length of i-th segment and
  // Size[High(Size)] tells how many bytes is needed for this layout

  Result := Size[High(Size)];
end;

{ TEmptyCharmapTableView }

function TEmptyCharmapTableView.GetGlyphIndex(Char: Word): TGlyphIndex;
begin
  Result := 0
end;

function TEmptyCharmapTableView.GetLanguage: Word;
begin
  Result := 0
end;

{ TAsciiCharmapTableView }

procedure TAsciiCharmapTableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

procedure TAsciiCharmapTableView.CheckHeader(const h: TAsciiCharmapTableHeader);
begin
  with h do
  begin
    {$IFDEF EXTENSIVE_CHECKS}
    Check(Format = 0);
    Check(Length = Size);
    {$ENDIF}
    Check(Size >= SizeOf(GetHeader) + 256);
  end;
end;

function TAsciiCharmapTableView.GetGlyphIndex(Char: Word): TGlyphIndex;
begin
  if Char > 255 then
  begin
    Result := 0;
    Exit;
  end;

  Stream.Position := SizeOf(GetHeader) + Char;
  Stream.ReadBuffer(Result, 1);
  Result := Result and $ff;
end;

function TAsciiCharmapTableView.GetHeader: TAsciiCharmapTableHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

function TAsciiCharmapTableView.GetLanguage: Word;
begin
  Result := GetHeader.Lang
end;

procedure TAsciiCharmapTableView.Init;
begin
  inherited;
  CheckHeader(GetHeader);
end;

{ TMaxpTableView }

function TMaxpTableView.GetHeader: TMaxpTableHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, Sizeof(Result));
  Swap(Result);
end;

function TMaxpTableView.GetNumGlyphs: Word;
begin
  Result := Header.NumGlyphs
end;

procedure TMaxpTableView.Init;
begin
  inherited;
  Check(Size >= SizeOf(GetHeader));
end;

{ TGlyphPosTableView }

procedure TGlyphPosTableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

constructor TGlyphPosTableView.Create(Stream: TStream; OwnStream, LongOffsets: Boolean; NumOffsets: Cardinal);
begin
  inherited Create(Stream, OwnStream);

  if LongOffsets then
    Check(Size >= 4 * (1 + NumOffsets))
  else
    Check(Size >= 2 * (1 + NumOffsets));

  FLongOffsets := LongOffsets;
  FNumOffsets := NumOffsets;
end;

function TGlyphPosTableView.GetGlyphLength(i: Integer): Cardinal;
begin
  Result := GlyphOffset[i + 1] - GlyphOffset[i]
end;

function TGlyphPosTableView.GetGlyphOffset(i: Integer): Cardinal;
begin
  if (i < 0) or (i > Integer(FNumOffsets)) then
    raise EGlyphIndexOutOfBounds.CreateFmt('Glyph #%d does not exist', [i]);

  with Stream do
    if FLongOffsets then
    begin
      Position := 4 * i;
      ReadBuffer(Result, 4);
      Result := Swap(Result);
    end
    else
    begin
      Position := 2 * i;
      ReadBuffer(Result, 2);
      Result := 2 * Swap(Word(Result and $ffff));
    end;
end;

{ TNullGlyphView }

function TNullGlyphView.GetHeight: Integer;
begin
  Result := 0
end;

function TNullGlyphView.GetWidth: Integer;
begin
  Result := 0
end;

function TNullGlyphView.IsComposite: Boolean;
begin
  Result := False
end;

{ TFontCollectionView }

procedure TFontCollectionView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

procedure TFontCollectionView.CheckHeader(const h: TFontCollectionFileHeader);
begin
  with h do
  begin
    {$IFDEF EXTENSIVE_CHECKS}
    Check(Tag = 'ttcf');
    {$ENDIF}

    Check(Size >= NumFonts * SizeOf(TFontFileHeader));
  end;
end;

destructor TFontCollectionView.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(FFonts) do
    FFonts[i].Free;

  inherited;
end;

function TFontCollectionView.GetFont(i: Integer): TFontView;
begin
  if FFonts[i] = nil then
    LoadFont(i);

  Result := FFonts[i];
end;

function TFontCollectionView.GetFontsCount: Cardinal;
begin
  Result := Length(FFonts)
end;

function TFontCollectionView.GetHeader: TFontCollectionFileHeader;
begin
  Stream.Position := 0;
  Stream.Read(Result, SizeOf(Result));
  Swap(Result);
end;

procedure TFontCollectionView.Init;
var
  h: TFontCollectionFileHeader;
  i: Integer;
begin
  inherited;

  Check(Size >= Sizeof(h));
  h := GetHeader;
  CheckHeader(h);

  SetLength(FFonts, h.NumFonts);

  for i := 0 to High(FFonts) do
    FFonts[i] := nil;
end;

procedure TFontCollectionView.LoadFont(i: Integer);
var
  Offset: Cardinal;
  Proxy: TStream;
begin
  Stream.Position := 12 + 4 * i;
  Stream.ReadBuffer(Offset, 4);
  Offset := Swap(Offset);

  Proxy := TProxyStream.Create(Stream, Offset, Size - Offset);
  FFonts[i] := TFontView.Create(Stream, Proxy, True);
end;

{ TGlyphView }

class function TGlyphView.CreateGlyph(Stream: TStream; Own: Boolean): TGlyphView;
var
  n: SmallInt;
begin
  if Stream.Size = 0 then
    Result := TNullGlyphView.Create(Stream, Own)
  else
  begin
    Check(Stream.Size >= 2);
    Stream.ReadBuffer(n, 2);
    n := Swap(n);

    if n < 0 then
      Result := TCompositeGlyphView.Create(Stream, Own)
    else
      Result := TSimpleGlyphView.Create(Stream, Own);
  end;
end;

{ TBaseGlyphView }

procedure TBaseGlyphView.CheckHeader(const h: TGlyphHeader);
begin
  with h do
  begin
    {$IFDEF EXTENSIVE_CHECKS}
    Check(XMin <= XMax);
    Check(YMin <= YMax);
    {$ENDIF}
  end;
end;

function TBaseGlyphView.GetHeader: TGlyphHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

function TBaseGlyphView.GetHeight: Integer;
begin
  with Header do
    Result := YMax - YMin
end;

function TBaseGlyphView.GetWidth: Integer;
begin
  with Header do
    Result := XMax - XMin
end;

procedure TBaseGlyphView.Init;
begin
  inherited;
  CheckHeader(GetHeader);
end;

function TBaseGlyphView.IsComposite: Boolean;
begin
  Result := Header.NumContours < 0
end;

{ TCompositeGlyphView }

function TCompositeGlyphView.GetCount: Cardinal;
begin
  Result := Length(FEntryOffset)
end;

function TCompositeGlyphView.GetEntryOffset(i: Integer): Cardinal;
begin
  Result := FEntryOffset[i]
end;

function TCompositeGlyphView.GetGlyph(i: Cardinal): TGlyphIndex;
var
  g: Word;
begin
  Assert(i < Count, 'Invalid entry index to a composite glyph');
  Stream.Position := FEntryOffset[i] + 2;
  Stream.ReadBuffer(g, 2);
  Result := Swap(g);
end;

procedure TCompositeGlyphView.Init;

  function TestBit(w: Word; i: Integer): Boolean;
  begin
    Result := (w and (1 shl i)) <> 0
  end;

  procedure Skip(n: Integer);
  begin
    Check(Size >= Stream.Position + n);
    Stream.Seek(n, soFromCurrent);
  end;

  function ReadWord: Word;
  begin
    Check(Size > Stream.Position + 2);
    Stream.ReadBuffer(Result, 2);
    Result := Swap(Result);
  end;

var
  Flags: Word;
begin
  inherited;
  Stream.Position := SizeOf(TGlyphHeader);

  repeat
    SetLength(FEntryOffset, Length(FEntryOffset) + 1);
    FEntryOffset[High(FEntryOffset)] := Stream.Position;

    Flags := ReadWord;
    Skip(2);

    { See http://www.microsoft.com/typography/otspec/glyf.htm for details
      about parsing composite glyphs. }

    if TestBit(Flags, 0) then
      Skip(4)
    else
      Skip(2);

    if TestBit(Flags, 3) then
      Skip(2)
    else if TestBit(Flags, 6) then
      Skip(4)
    else if TestBit(Flags, 7) then
      Skip(8);
  until not TestBit(Flags, 5);

  { A list of glyph entries is followed by an array of
    instructions. These instructions are not needed for
    current implementation. }

  {$IFDEF EXTENSIVE_CHECKS}
  if TestBit(Flags, 8) then
    Skip(ReadWord);
  {$ENDIF}
end;

{ TMetricsInfoTableView }

function TMetricsInfoTableView.GetHeader: TMetricsTableHeader;
begin
  Stream.Position := 0;
  Stream.Read(Result, SizeOf(Result));
  Swap(Result);
end;

procedure TMetricsInfoTableView.Init;
begin
  inherited;
  Check(Size >= SizeOf(Header));
end;

{ TMetricsTableView }

procedure TMetricsTableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

constructor TMetricsTableView.Create(Stream: TStream; Own: Boolean;
  NumMetrics, NumGlyphs: Cardinal);
begin
  inherited Create(Stream, Own);

  FNumMetrics := NumMetrics;
  FNumGlyphs := NumGlyphs;

  Check(FNumMetrics >= 1);
  Check(FNumMetrics <= FNumGlyphs);
  Check(Size >= 4 * FNumMetrics + 2 * (FNumGlyphs - FNumMetrics));
end;

function TMetricsTableView.GetSB(i: Integer): SmallInt;
begin
  Check((i >= 0) and (Cardinal(i) < FNumGlyphs));

  if Cardinal(i) <= FNumMetrics then
    Stream.Position := 4 * i + 2
  else
    Stream.Position := 4 * FNumMetrics + 2 * (Cardinal(i) - FNumMetrics);

  Stream.ReadBuffer(Result, 2);
  Result := Swap(Result);
end;

function TMetricsTableView.GetDim(i: Integer): Word;
begin
  Check((i >= 0) and (Cardinal(i) < FNumGlyphs));

  if Cardinal(i) <= FNumMetrics then
    Stream.Position := 4 * i
  else
    Stream.Position := 4 * (FNumMetrics - 1);

  Stream.ReadBuffer(Result, 2);
  Result := Swap(Result);
end;

{ TStringTableView }

procedure TStringTableView.Accept(v: TVisitor);
begin
  v.Visit(Self)
end;

procedure TStringTableView.CheckHeader(const h: TStringTableHeader);
begin
  with h do
  begin
    Check(Size >= FStorage + Offset);
    Check(Size >= SizeOf(h) + Count * SizeOf(TStringRecord));
  end;
end;

procedure TStringTableView.CheckStringRecord(const h: TStringRecord);
begin
  Check(Size >= FStorage + h.Offset + h.Size);
end;

function TStringTableView.GetHeader: TStringTableHeader;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

function TStringTableView.GetStringRecord(i: Integer): TStringRecord;
begin
  Stream.Position := SizeOf(GetHeader) + i * SizeOf(Result);
  Stream.ReadBuffer(Result, SizeOf(Result));
  Swap(Result);
end;

function TStringTableView.GetString(i: Integer): AnsiString;
var
  r: TStringRecord;
begin
  r := GetStringRecord(i);
  CheckStringRecord(r);

  if r.Size = 0 then
    Result := ''
  else
  begin
    SetLength(Result, r.Size);
    Stream.Position := FStorage + r.Offset;
    Stream.ReadBuffer(Result[1], r.Size);
  end;
end;

function TStringTableView.GetEntry(i: Integer): TStringTableEntry;
var
  r: TStringRecord;
begin
  r := GetStringRecord(i);

  with Result do
  begin
    Platform  := r.Platform;
    Encoding  := r.Encoding;
    Language  := r.Language;
    Id        := r.Id;
  end;
end;

procedure TStringTableView.Init;
var
  h: TStringTableHeader;
begin
  inherited;
  Check(Size >= SizeOf(h));
  h := GetHeader;
  CheckHeader(h);
  FCount := h.Count;
  FStorage := h.Offset;
end;

{ TFontBuilder }

constructor TFontBuilder.Create(Font: TFontView);
begin
  FFont := Font;

  FCharmap := TBtree.Create(8);
  FGRemap := TBTree.Create(8);
  FGUsed := TBTree.Create(8);

  FGUsed.Exists[Pointer(0)] := True; // use the missing glyph (aka .notdef)

  {$IFDEF EMIT_CHECKSUMS}
  FCompChecksums := True;
  {$ENDIF}
end;

destructor TFontBuilder.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(FTables) do
    FTables[i].Free;

  FCharmap.Free;
  FGRemap.Free;
  FGUsed.Free;

  inherited;
end;

procedure TFontBuilder.AddChar(c: Word);
var
  g: TGlyphIndex;
begin
  g := FFont.GetGlyphIndex(c);

  FCharmap[Pointer(c)] := Pointer(g);
  FGUsed.Exists[Pointer(g)] := True;

  AddDescendantGlyphs(g);
end;

procedure TFontBuilder.AddCharset(Charset: TBitArray);
var
  c: Word;
begin
  for c := 0 to Charset.Length - 1 do
    if Charset[c] then
      AddChar(c)
end;

procedure TFontBuilder.CopyTableFromSrcFont(Name: TFontTableTag);
begin
  if FFont.TableExists(Name) then
    AddTable(Name, TStreamBuilder.Create(FFont.GetTable(Name).Stream))
end;

procedure TFontBuilder.AddTable(Tag: TFontTableTag; Table: TBuilder);
var
  i: Integer;
begin
  SetLength(FTags, Length(FTags) + 1);
  SetLength(FTables, Length(FTables) + 1);

  // FTags must be sorted

  i := High(FTags);

  while (i > 0) and (Tag < FTags[i - 1]) do
  begin
    FTags[i] := FTags[i - 1];
    FTables[i] := FTables[i - 1];

    Dec(i);
  end;

  FTags[i] := Tag;
  FTables[i] := Table;
end;

procedure TFontBuilder.WriteHeader(Stream: TStream);
var
  h: TFontFileHeader;
begin
  Zero(h, SizeOf(h));

  with h do
  begin
    Version   := $00010000;
    NumTables := Length(FTags);
    Selector  := Log2(NumTables);
    Range     := 16 * (1 shl Log2(NumTables));
    Shift     := 16 * NumTables - Range;
  end;

  Swap(h);
  Stream.WriteBuffer(h, SizeOf(h));
end;

procedure TFontBuilder.WriteTableRecord(Stream: TStream;
  Index, Offset, Len, Checksum: Cardinal);
var
  h: TTableRecordEntry;
begin
  Zero(h, SizeOf(h));

  h.Tag := FTags[Index];
  h.Offset := Offset;
  h.Length := Len;
  h.Checksum := Checksum;

  Swap(h);
  Stream.WriteBuffer(h, SizeOf(h));
end;

procedure TFontBuilder.SaveTablesToStream(Stream: TStream);

  function AlignOffset(n: Integer): Integer;
  begin
    Result := (n + 3) and not 3 // (n + 3) div 4 * 4
  end;

  procedure WriteZeros(n: Integer);
  var
    z: Byte;
  begin
    z := 0;

    for n := n downto 1 do
      Stream.WriteBuffer(z, 1);
  end;

  function ComputeChecksum(Offset, Len: Cardinal): Cardinal;
  var
    s: TStream;
  begin
    s := TProxyStream.Create(Stream, Offset, Len);

    try
      Result := GetTableChecksum(s);
    finally
      s.Free;
    end;
  end;

const
  HeaderSize = SizeOf(TFontFileHeader);
  TableRecordSize = SizeOf(TTableRecordEntry);
var
  Base, i, n: Integer;
  Offset, Len, Checksum: Cardinal;
begin
  Base := Stream.Position;
  Assert(Cardinal(Base) >= FontFileBase);
  WriteHeader(Stream);
  n := Length(FTags);

  if n = 0 then
    Exit;

  for i := 0 to n - 1 do
    WriteTableRecord(Stream, i, 0, 0, 0);

  for i := 0 to n - 1 do
  begin
    Offset := Stream.Position;
    FTables[i].SaveToStream(Stream);
    WriteZeros(AlignOffset(Stream.Position) - Stream.Position);
    Len := Stream.Position - Offset;

    if ComputeChecksums then
      Checksum := ComputeChecksum(Offset, Len)
    else
      Checksum := 0;

    Stream.Position := Base + SizeOf(TFontFileHeader) + i * SizeOf(TTableRecordEntry);
    WriteTableRecord(Stream, i, Offset - FontFileBase, Len, Checksum);
    Stream.Position := Offset + Len;
  end;
end;

procedure TFontBuilder.AddDescendantGlyphs(g: TGlyphIndex);
var
  Glyph: TCompositeGlyphView;
  i: Integer;
  Sub: TGlyphIndex;
begin
  if not FFont.Glyph[g].Composite then
    Exit;

  Glyph := FFont.Glyph[g] as TCompositeGlyphView;

  for i := 0 to Glyph.Count - 1 do
  begin
    Sub := Glyph.Component[i];

    if not FGUsed.Exists[Pointer(Sub)] then
    begin
      FGUsed.Exists[Pointer(Sub)] := True;
      AddDescendantGlyphs(Sub);
    end;
  end;
end;

procedure TFontBuilder.BuildCharsList;
var
  i: Integer;
  Keys: TList;
begin
  Keys := TList.Create;

  try
    FCharmap.GetKeysAndValues(Keys, nil);
    SetLength(FChars, Keys.Count);

    for i := 0 to Keys.Count - 1 do
      FChars[i] := Word(Keys[i])
  finally
    Keys.Free;
  end;
end;

procedure TFontBuilder.BuildGlyphsRemapping;
var
  i: Integer;
  Glyphs: TList;
begin
  Glyphs := TList.Create;

  try
    FGUsed.GetKeysAndValues(Glyphs, nil);
    SetLength(FGlyphs, Glyphs.Count);

    for i := 0 to Glyphs.Count - 1 do
    begin
      FGRemap[Glyphs[i]] := Pointer(i);
      FGlyphs[i] := TGlyphIndex(Glyphs[i]);
    end;
  finally
    Glyphs.Free;
  end;
end;

function TFontBuilder.GetUsedGlyphs: TBitArray;
var
  i: Integer;
begin
  Result := TBitArray.Create;

  if Length(FGlyphs) > 0 then
  try
    Result.Length := FGlyphs[High(FGlyphs)] + 1;

    for i := 0 to High(FGlyphs) do
      Result[RemapGlyph(FGlyphs[i])] := True
  except
    Result.Free;
    Result := nil;
  end;
end;

function TFontBuilder.MapCharToGlyph(c: Word): TGlyphIndex;
begin
  Result := TGlyphIndex(FCharmap[Pointer(c)])
end;

function TFontBuilder.RemapGlyph(g: TGlyphIndex): TGlyphIndex;
begin
  Result := TGlyphIndex(FGRemap[Pointer(g)])
end;

procedure TFontBuilder.RepackGlyphs(out Glyf, Loca: TFontTableBuilder; out LongOffsets: Boolean);

  function CreateSimpleGlyph(G: TGlyphView): TBuilder;
  begin
    Result := TStreamBuilder.Create(G.Stream);
  end;

  function CreateCompositeGlyph(G: TCompositeGlyphView): TCompositeGlyphBuilder;
  var
    i: Integer;
  begin
    Result := TCompositeGlyphBuilder.Create(G);

    for i := 0 to G.Count - 1 do
      Result.Component[i] := RemapGlyph(G.Component[i]);
  end;

var
  GlyphTable: TGlyphTableBuilder;
  PosTable: TGlyphPosTableBuilder;
  i: TGlyphIndex;
  Glyph: TGlyphView;
  PaddedLength: Cardinal;
begin
  GlyphTable := TGlyphTableBuilder.Create;
  PosTable := TGlyphPosTableBuilder.Create;

  for i := 0 to High(FGlyphs) do
  begin
    Glyph := FFont.Glyph[FGlyphs[i]];
    PaddedLength := PosTable.AddGlyph(Glyph.Stream.Size);

    if Glyph.Composite then
      GlyphTable.AddGlyph(
        CreateCompositeGlyph(Glyph as TCompositeGlyphView),
        PaddedLength)
    else
      GlyphTable.AddGlyph(
        CreateSimpleGlyph(Glyph),
        PaddedLength);
  end;

  Glyf := GlyphTable;
  Loca := PosTable;

  LongOffsets := PosTable.LongOffsets;
end;

function TFontBuilder.CreateAsciiCharmapTable(Lang: Word): TAsciiCharmapTableBuilder;
var
  i: Integer;
begin
  Result := TAsciiCharmapTableBuilder.Create(Lang);

  for i := 0 to High(FChars) do
    if (FChars[i] < 256) and (MapCharToGlyph(FChars[i]) < 256) then
      Result.GlyphIndex[FChars[i]] := RemapGlyph(MapCharToGlyph(FChars[i]));
end;

function TFontBuilder.CreateSegCharmapTable(Lang: Word): TSegCharmapTableBuilder;
var
  Segs, Glyphs: WordArray;
  i, n: Integer;
begin
  SetLength(Glyphs, Length(FChars));

  for i := 0 to High(FChars) do
    Glyphs[i] := RemapGlyph(MapCharToGlyph(FChars[i]));

  TSegCharmapTableView.FindOptimalMapping(FChars, Glyphs, Segs);
  Result := TSegCharmapTableBuilder.Create(Lang);
  n := 0;

  for i := 0 to High(Segs) do
  begin
    if (Segs[i] > 1) or (Glyphs[n] > 0) then
      Result.AddSegment(FChars[n], FChars[n + Segs[i] - 1], $ffff and (Integer(Glyphs[n]) - Integer(FChars[n])));

    Inc(n, Segs[i]);
  end;
end;

function TFontBuilder.CreateCharmapTable: TCharmapTableBuilder;
var
  Cmap: TCharmapTableView;
  Subtable: TCharmapSubtableView;
  NewSubTable: TCharmapSubtableBuilder;
  i: Integer;
begin
  Cmap := FFont.CharmapTable;
  Result := TCharmapTableBuilder.Create;

  for i := 0 to Cmap.SubtablesCount - 1 do
  begin
    Subtable := Cmap.Subtable[i];
    NewSubTable := nil;

    case Subtable.Format of
      4: NewSubTable := CreateSegCharmapTable(Subtable.Language);
      0: NewSubTable := CreateAsciiCharmapTable(Subtable.Language);
    end;

    if NewSubTable <> nil then
      Result.AddSubtable(NewSubTable, Cmap.Platform[i], Cmap.Encoding[i]);
  end;
end;

function TFontBuilder.CreateStringTable: TStringTableBuilder;
var
  i: Integer;
  View: TStringTableView;
begin
  View := FFont.StringsTable;
  Result := TStringTableBuilder.Create;

  for i := 0 to View.Count - 1 do
    with View.Entry[i] do
      if (Id in [1..4]) and ((Language = $409) or (Language = 0)) then
        Result.AddString(View[i], Platform, Encoding, Language, Id);
end;

function TFontBuilder.CreateMetricsTable(View: TMetricsTableView): TMetricsTableBuilder;
var
  i: Integer;
begin
  Assert(Cardinal(Length(FGlyphs)) <= View.Count);
  Result := TMetricsTableBuilder.Create;

  for i := 0 to High(FGlyphs) do
    Result.AddMetric(View.Dim[FGlyphs[i]], View.SB[FGlyphs[i]]);
end;

function TFontBuilder.CreateHeadTable(LongOffsets: Boolean): TBuilder;
var
  h: THeadTableHeader;
  s: TStreamBuilder;
begin
  h := FFont.HeadTable.Header;

  if LongOffsets then
    h.LongOffset := 1
  else
    h.LongOffset := 0;

  Swap(h);

  s := TStreamBuilder.CreateWithStream;
  s.Stream.WriteBuffer(h, Sizeof(h));

  Result := s;
end;

function TFontBuilder.CreateMaxpTable(NumGlyphs: Word): TBuilder;
var
  h: TMaxpTableHeader;
  s: TStreamBuilder;
begin
  h := FFont.MaxpTable.Header;
  h.NumGlyphs := NumGlyphs;
  Swap(h);

  s := TStreamBuilder.CreateWithStream;
  s.Stream.WriteBuffer(h, SizeOf(h));

  Result := s;
end;

function TFontBuilder.CreateMetricsInfoTable(View: TMetricsInfoTableView;
  NumMetrics: Word): TBuilder;
var
  h: TMetricsTableHeader;
  s: TStreamBuilder;
begin
  h := View.Header;
  h.NumMetrics := NumMetrics;
  Swap(h);

  s := TStreamBuilder.CreateWithStream;
  s.Stream.WriteBuffer(h, SizeOf(h));

  Result := s;
end;

procedure TFontBuilder.SaveToStream(Stream: TStream);
var
  LongOffsets: Boolean;
  Glyf, Loca: TFontTableBuilder;
  NumGlyphs: Word;
begin
  BuildCharsList;
  BuildGlyphsRemapping;

  NumGlyphs := Length(FGlyphs);
  RepackGlyphs(Glyf, Loca, LongOffsets);

  AddTable('glyf', Glyf);
  AddTable('loca', Loca);
  AddTable('cmap', CreateCharmapTable);
  AddTable('head', CreateHeadTable(LongOffsets));
  AddTable('maxp', CreateMaxpTable(NumGlyphs));
  AddTable('name', CreateStringTable);
  AddTable('hmtx', CreateMetricsTable(FFont.HMetricsTable));
  AddTable('hhea', CreateMetricsInfoTable(FFont.HMetricsInfoTable, NumGlyphs));

  if FFont.TableExists('vmtx') then
    AddTable('vmtx', CreateMetricsTable(FFont.VMetricsTable));

  if FFont.TableExists('vhea') then
    AddTable('hhea', CreateMetricsInfoTable(FFont.VMetricsInfoTable, NumGlyphs));

  CopyTableFromSrcFont('fpgm');
  CopyTableFromSrcFont('prep');
  CopyTableFromSrcFont('cvt ');

  SaveTablesToStream(Stream);
end;

{ TSegCharmapTableBuilder }

constructor TSegCharmapTableBuilder.Create(Lang: Word);
begin
  FLang := Lang;
  AddSegment($ffff, $ffff, 1);
end;

procedure TSegCharmapTableBuilder.AddSegment(First, Last: Word; Delta: Word);
var
  i, n: Integer;
begin
  Assert(First <= Last);

  n := Length(FLast);

  SetLength(FLast, n + 1);
  SetLength(FFirst, n + 1);
  SetLength(FDelta, n + 1);

  i := n;

  while (i > 0) and (Last < FLast[i - 1]) do
  begin
    FLast[i] := FLast[i - 1];
    FFirst[i] := FFirst[i - 1];
    FDelta[i] := FDelta[i - 1];

    Dec(i);
  end;

  Assert((i = 0) or (First > FLast[i - 1]));
  Assert((i = n) or (Last < FFirst[i]));

  FFirst[i] := First;
  FLast[i] := Last;
  FDelta[i] := Word(Delta);
end;

procedure TSegCharmapTableBuilder.WriteHeader(Stream: TStream);
var
  h: TSegCharmapTableHeader;
  n: Integer;
begin
  Zero(h, SizeOf(h));
  n := Length(FLast);

  with h do
  begin
    Format    := 4;
    Lang      := FLang;
    SegCount2 := n * 2;
    Range     := 2 * (1 shl Log2(SegCount2 div 2));
    Selector  := Log2(SegCount2 div 2);
    Shift     := SegCount2 - Range;
    Length    := SizeOf(TSegCharmapTableHeader) + 2 + 8 * n;
  end;

  Swap(h);
  Stream.WriteBuffer(h, SizeOf(h));
end;

procedure TSegCharmapTableBuilder.WriteWords(Stream: TStream; const w: array of Word);
var
  i: Integer;
  a: Word;
begin
  for i := 0 to High(w) do
  begin
    a := Swap(w[i]);
    Stream.WriteBuffer(a, 2);
  end;
end;

procedure TSegCharmapTableBuilder.WriteZero(Stream: TStream; n: Integer);
var
  z: Integer;
begin
  z := 0;

  while n > SizeOf(z) do
  begin
    Stream.WriteBuffer(z, SizeOf(z));
    Dec(n, SizeOf(z));
  end;

  if n > 0 then
    Stream.WriteBuffer(z, n);
end;

procedure TSegCharmapTableBuilder.SaveToStream(Stream: TStream);
var
  n: Integer;
begin
  WriteHeader(Stream);

  n := Length(FLast);

  if n > 0 then
    WriteWords(Stream, FLast);

  WriteZero(Stream, 2);

  if n > 0 then
  begin
    WriteWords(Stream, FFirst);
    WriteWords(Stream, FDelta);
    WriteZero(Stream, 2 * n);
  end;
end;

{ TCharmapTableBuilder }

procedure TCharmapTableBuilder.AddSubtable(Subtable: TBuilder; Platform, Encoding: Word);
var
  n: Integer;
begin
  n := Length(FSubtables);

  SetLength(FSubtables, n + 1);
  SetLength(FPlatforms, n + 1);
  SetLength(FEncodings, n + 1);

  FSubtables[n] := Subtable;
  FPlatforms[n] := Platform;
  FEncodings[n] := Encoding;
end;

procedure TCharmapTableBuilder.WriteHeader(Stream: TStream);
var
  h: TCharmapTableHeader;
begin
  Zero(h, SizeOf(h));

  with h do
  begin
    Version   := 0;
    NumTables := Length(FSubtables);
  end;

  Swap(h);
  Stream.WriteBuffer(h, SizeOf(h));
end;

procedure TCharmapTableBuilder.WriteSubHeader(Stream: TStream; i: Integer; Ptr: Cardinal);
var
  h: TCharmapSubtableRecordEntry;
begin
  Zero(h, SizeOf(h));

  with h do
  begin
    Platform  := FPlatforms[i];
    Encoding  := FEncodings[i];
    Offset    := Ptr;
  end;

  Swap(h);
  Stream.WriteBuffer(h, SizeOf(h));
end;

destructor TCharmapTableBuilder.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(FSubtables) do
    FSubtables[i].Free;

  inherited;
end;

procedure TCharmapTableBuilder.SaveToStream(Stream: TStream);

  function AlignOffset(n: Cardinal): Cardinal;
  begin
    Result := (n + 3) and not 3 // (n + 3) div 4 * 4
  end;

  procedure WriteZeros(n: Integer);
  var
    z: Byte;
  begin
    z := 0;

    for n := n downto 1 do
      Stream.WriteBuffer(z, 1);
  end;

  function GetOffset(Base, i: Cardinal): Cardinal;
  begin
    Result := Base + SizeOf(TCharmapTableHeader) +
      i * SizeOf(TCharmapSubtableRecordEntry)
  end;

var
  i, n: Integer;
  Base, Offset, Len: Cardinal;
begin
  Base := Stream.Position;
  WriteHeader(Stream);
  n := Length(FSubtables);

  if n = 0 then
    Exit;

  for i := 0 to n - 1 do
    WriteSubHeader(Stream, i, 0);

  for i := 0 to n - 1 do
  begin
    Offset := AlignOffset(Stream.Position);
    WriteZeros(Offset - Stream.Position);
    FSubtables[i].SaveToStream(Stream);
    Len := Stream.Position - Offset;
    Stream.Position := GetOffset(Base, i);
    WriteSubHeader(Stream, i, Offset - Base);
    Stream.Position := Offset + Len;
  end;
end;

{ TMetricsTableBuilder }

procedure TMetricsTableBuilder.AddMetric(Dim: Word; SB: SmallInt);
begin
  SetLength(FDim, Length(FDim) + 1);
  FDim[High(FDim)] := Dim;

  SetLength(FSB, Length(FSB) + 1);
  FSB[High(FSB)] := Word(SB);
end;

procedure TMetricsTableBuilder.SaveToStream(Stream: TStream);

  procedure WriteWord(w: Word);
  begin
    w := Swap(w);
    Stream.WriteBuffer(w, 2);
  end;

var
  i: Integer;
begin
  for i := 0 to High(FSB) do
  begin
    WriteWord(FDim[i]);
    WriteWord(FSB[i]);
  end;
end;

{ TStringTableBuilder }

procedure TStringTableBuilder.AddString(const s: AnsiString;
  Platform, Encoding, Language, Id: Word);

  function Less(const a, b: TStringTableEntry): Boolean;

    function PartialLess(const a, b: TStringTableEntry): Boolean;
    begin
      Result :=
        (a.Platform < b.Platform) or
        (a.Encoding < b.Encoding) or
        (a.Language < b.Language) or
        (a.Id < b.Id);
    end;

  begin
    Result := PartialLess(a, b) and not PartialLess(b, a)
  end;

var
  Entry: TStringTableEntry;
  i, n: Integer;
  Ref: Integer;
begin
  n := Length(FItems);

  // insert new entry

  Entry.Platform := Platform;
  Entry.Encoding := Encoding;
  Entry.Language := Language;
  Entry.Id       := Id;

  SetLength(FItems, n + 1);
  i := n;

  while (i > 0) and Less(Entry, FItems[i - 1]) do
  begin
    FItems[i] := FItems[i - 1];
    Dec(i);
  end;

  FItems[i] := Entry;

  // add new string
  // empty strings are not stored to FStrings, as they are
  // referred to by the -1 index

  Ref := FindString(s);

  if (Ref < 0) and (s <> '') then
  begin
    SetLength(FStrings, Length(FStrings) + 1);
    FStrings[High(FStrings)] := s;
    Ref := High(FStrings);
  end;

  SetLength(FStrRef, n + 1);
  FStrRef[n] := Ref;
end;

function TStringTableBuilder.FindString(const s: AnsiString): Integer;
begin
  for Result := 0 to High(FStrings) do
    if s = FStrings[Result] then
      Exit;

  Result := -1;
end;

procedure TStringTableBuilder.WriteHeader(Stream: TStream; FSO: Cardinal);
var
  h: TStringTableHeader;
begin
  Zero(h, SizeOf(h));

  with h do
  begin
    Format  := 0;
    Count   := Length(FItems);
    Offset  := FSO;
  end;

  Swap(h);
  Stream.WriteBuffer(h, SizeOf(h));
end;

procedure TStringTableBuilder.WriteRecord(Stream: TStream; i: Integer; SO: Cardinal);
var
  h: TStringRecord;
begin
  Zero(h, SizeOf(h));

  with h do
  begin
    Platform  := FItems[i].Platform;
    Encoding  := FItems[i].Encoding;
    Language  := FItems[i].Language;
    Id        := FItems[i].Id;
    Offset    := SO;

    if FStrRef[i] < 0 then
      Size := 0
    else
      Size := Length(FStrings[FStrRef[i]]);
  end;

  Swap(h);
  Stream.WriteBuffer(h, SizeOf(h));
end;

procedure TStringTableBuilder.WriteString(Stream: TStream; const s: AnsiString);
begin
  Assert(SizeOf(s[1]) = 1);

  if Length(s) > 0 then
    Stream.WriteBuffer(s[1], Length(s));
end;

procedure TStringTableBuilder.SaveToStream(Stream: TStream);

  function AlignOffset(p: Cardinal): Cardinal;
  begin
    Result := (p + 1) and not 1; // (p + 1) div 2 * 2
  end;

var
  Offsets: array of Cardinal;
  i, n: Integer;
begin
  n := Length(FItems);
  Assert(n > 0);

  // compute positions of all strings

  SetLength(Offsets, Length(FStrings));
  Offsets[0] := SizeOf(TStringTableHeader) + n * SizeOf(TStringRecord);

  for i := 1 to High(FStrings) do
    Offsets[i] := AlignOffset(Offsets[i - 1] + Cardinal(Length(FStrings[i - 1])));

  // write header

  WriteHeader(Stream, Offsets[0]);

  // write string records

  for i := 0 to n - 1 do
    if FStrRef[i] < 0 then
      WriteRecord(Stream, i, 0)
    else
      WriteRecord(Stream, i, Offsets[FStrRef[i]] - Offsets[0]);

  // write strings

  for i := 0 to High(FStrings) do
  begin
    WriteZeros(Stream, AlignOffset(Stream.Position) - Stream.Position);
    WriteString(Stream, FStrings[i]);
  end;
end;

{ TAsciiCharmapTableBuilder }

constructor TAsciiCharmapTableBuilder.Create(Lang: Word);
begin
  FLang := Lang;
end;

procedure TAsciiCharmapTableBuilder.SaveToStream(Stream: TStream);
begin
  WriteHeader(Stream);
  Stream.WriteBuffer(FGlyphs[0], 256);
end;

procedure TAsciiCharmapTableBuilder.SetGlyphIndex(Char, Glyph: Word);
begin
  Assert(Char < 256);
  Assert(Glyph < 256);

  FGlyphs[Char] := Glyph;
end;

procedure TAsciiCharmapTableBuilder.WriteHeader(Stream: TStream);
var
  h: TAsciiCharmapTableHeader;
begin
  Zero(h, SizeOf(h));

  with h do
  begin
    Format  := 0;
    Length  := SizeOf(h) + 256;
    Lang    := FLang;
  end;

  Swap(h);
  Stream.WriteBuffer(h, Sizeof(h));
end;

{ TCompositeGlyphBuilder }

constructor TCompositeGlyphBuilder.Create(Glyph: TCompositeGlyphView);
begin
  FGlyph := Glyph;
  LoadComponents;
end;

procedure TCompositeGlyphBuilder.SetComponent(i: Cardinal; Value: TGlyphIndex);
begin
  FComponents[i] := Value
end;

procedure TCompositeGlyphBuilder.LoadComponents;
var
  i: Integer;
begin
  SetLength(FComponents, FGlyph.Count);

  for i := 0 to FGlyph.Count - 1 do
    FComponents[i] := FGlyph.Component[i]
end;

procedure TCompositeGlyphBuilder.SaveToStream(Stream: TStream);

  procedure WriteWord(Pos: Integer; w: Word);
  begin
    w := Swap(w);
    Stream.Position := Pos;
    Stream.WriteBuffer(w, 2);
  end;

var
  Base, EndPos, i: Integer;
begin
  Assert(Integer(FGlyph.Count) = Length(FComponents));

  Base := Stream.Position;
  Stream.CopyFrom(FGlyph.Stream, 0);
  EndPos := Stream.Position;

  for i := 0 to High(FComponents) do
    WriteWord(Base + Integer(FGlyph.EntryOffset[i]) + 2, FComponents[i]);

  Stream.Position := EndPos;
end;

{ TGlyphPosTableBuilder }

function TGlyphPosTableBuilder.AddGlyph(Len: Cardinal): Cardinal;
begin
  if Len mod 2 = 1 then
    Inc(Len);

  AddOffset(GetMaxOffset + Len);
  Result := FOffset[High(FOffset)] - FOffset[High(FOffset) - 1];
end;

procedure TGlyphPosTableBuilder.AddOffset(Offset: Cardinal);
begin
  SetLength(FOffset, Length(FOffset) + 1);
  FOffset[High(FOffset)] := Offset;
end;

constructor TGlyphPosTableBuilder.Create;
begin
  AddOffset(0)
end;

function TGlyphPosTableBuilder.GetLongOffsets: Boolean;
begin
  Result := GetMaxOffset >= $20000
end;

function TGlyphPosTableBuilder.GetMaxOffset: Cardinal;
begin
  Result := FOffset[High(FOffset)]
end;

procedure TGlyphPosTableBuilder.SaveToStream(Stream: TStream);
var
  i: Integer;
  p: Cardinal;
begin
  if LongOffsets then
    for i := 0 to High(FOffset) do
    begin
      p := Swap(FOffset[i]);
      Stream.WriteBuffer(p, 4);
    end
  else
    for i := 0 to High(FOffset) do
    begin
      Assert(FOffset[i] mod 2 = 0);
      Assert(FOffset[i] div 2 < $10000);

      p := Swap(Word(FOffset[i] div 2));
      Stream.WriteBuffer(p, 2);
    end;
end;

{ TGlyphTableBuilder }

procedure TGlyphTableBuilder.AddGlyph(Glyph: TBuilder; DesiredLength: Cardinal);
begin
  SetLength(FGlyphs, Length(FGlyphs) + 1);
  FGlyphs[High(FGlyphs)] := Glyph;

  SetLength(FLengths, Length(FLengths) + 1);
  FLengths[High(FLengths)] := DesiredLength;
end;

destructor TGlyphTableBuilder.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(FGlyphs) do
    FGlyphs[i].Free;

  inherited;
end;

procedure TGlyphTableBuilder.SaveToStream(Stream: TStream);

  procedure WriteZeros(n: Cardinal);
  var
    z: Byte;
  begin
    z := 0;

    for n := n downto 1 do
      Stream.WriteBuffer(z, 1);
  end;

var
  p, Len: Cardinal;
  i: Integer;
begin
  for i := 0 to High(FGlyphs) do
  begin
    p := Stream.Position;
    FGlyphs[i].SaveToStream(Stream);
    Len := Stream.Position - p;

    Assert(Len <= FLengths[i]);
    WriteZeros(FLengths[i] - Len);
  end;
end;

{ TStreamBuilder }

constructor TStreamBuilder.Create(Stream: TStream; Own: Boolean);
begin
  FStream := Stream;
  FOwn := Own;
end;

constructor TStreamBuilder.CreateWithStream;
begin
  FStream := TMemoryStream.Create;
  FOwn := True;
end;

destructor TStreamBuilder.Destroy;
begin
  if FOwn then
    FStream.Free;

  inherited;
end;

procedure TStreamBuilder.SaveToStream(Stream: TStream);
begin
  Stream.CopyFrom(FStream, 0)
end;

{ TFontCollectionBuilder }

procedure TFontCollectionBuilder.AddFont(Font: TFontBuilder);
begin
  SetLength(FFonts, Length(FFonts) + 1);
  FFonts[High(FFonts)] := Font;
end;

destructor TFontCollectionBuilder.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(FFonts) do
    FFonts[i].Free;

  inherited;
end;

procedure TFontCollectionBuilder.SaveToStream(Stream: TStream);

  function AlignOffset(p: Cardinal): Cardinal;
  begin
    Result := (p + 3) and not 3
  end;

  procedure WriteZeros(n: Cardinal);
  var
    z: Byte;
  begin
    z := 0;

    for n := n downto 1 do
      Stream.WriteBuffer(z, 1);
  end;

  procedure WriteOffset(p: Cardinal);
  begin
    p := Swap(p);
    Stream.WriteBuffer(p, 4);
  end;

var
  i, n: Integer;
  Base, Offset, Len: Cardinal;
begin
  Base := Stream.Position;
  WriteHeader(Stream);
  n := Length(FFonts);

  if n = 0 then
    Exit;

  WriteZeros(n * 4); // reserve place for offsets

  for i := 0 to n - 1 do
  begin
    WriteZeros(AlignOffset(Stream.Position) - Stream.Position);
    Offset := Stream.Position;
    FFonts[i].FontFileBase := Base;
    FFonts[i].SaveToStream(Stream);
    Len := Stream.Position - Offset;
    Stream.Position := Integer(Base) + SizeOf(TFontCollectionFileHeader) + i * 4;
    WriteOffset(Offset - Base);
    Stream.Position := Offset + Len;
  end;
end;

procedure TFontCollectionBuilder.WriteHeader(Stream: TStream);
var
  h: TFontCollectionFileHeader;
begin
  Zero(h, SizeOf(h));

  with h do
  begin
    Tag       := 'ttcf';
    Version   := $00010000;
    NumFonts  := Length(FFonts);
  end;

  Swap(h);
  Stream.WriteBuffer(h, SizeOf(h));
end;

end.

