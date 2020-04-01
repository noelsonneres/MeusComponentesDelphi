
{******************************************}
{                                          }
{             FastReport v5.0              }
{            PDF export filter             }
{                                          }
{         Copyright (c) 1998-2009          }
{          by Alexander Fediachov,         }
{                                          }
{         Copyright (c) 2010-2011          }
{          PDF/A by Anton Khayrudinov      }
{                                          }
{      After Service support by alman      }
{                                          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportAPDF;

interface

{$I frx.inc}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComObj,
  Printers,
  ShellAPI,
  ComCtrls,

  {$IFDEF Delphi10}
  WideStrings,
  {$ENDIF}

  {$IFDEF Delphi12}
  AnsiStrings,
  {$ENDIF}

  {$IFDEF Delphi6}
  Variants,
  {$ENDIF}

  JPEG,
  frxStorage,
  frxOTF,
  frxClass,
  frxRC4;

type
  TfrxPDFEncBit = (ePrint, eModify, eCopy, eAnnot);
  TfrxPDFEncBits = set of TfrxPDFEncBit;

  TfrxAPDFExportDialog = class(TForm)
    PageControl1: TPageControl;
    ExportPage: TTabSheet;
    InfoPage: TTabSheet;
    SecurityPage: TTabSheet;
    ViewerPage: TTabSheet;
    OkB: TButton;
    CancelB: TButton;
    SaveDialog1: TSaveDialog;
    OpenCB: TCheckBox;
    GroupQuality: TGroupBox;
    CompressedCB: TCheckBox;
    EmbeddedCB: TCheckBox;
    PrintOptCB: TCheckBox;
    OutlineCB: TCheckBox;
    BackgrCB: TCheckBox;
    GroupPageRange: TGroupBox;
    DescrL: TLabel;
    AllRB: TRadioButton;
    CurPageRB: TRadioButton;
    PageNumbersRB: TRadioButton;
    PageNumbersE: TEdit;
    SecGB: TGroupBox;
    OwnPassL: TLabel;
    UserPassL: TLabel;
    OwnPassE: TEdit;
    UserPassE: TEdit;
    PermGB: TGroupBox;
    PrintCB: TCheckBox;
    ModCB: TCheckBox;
    CopyCB: TCheckBox;
    AnnotCB: TCheckBox;
    DocInfoGB: TGroupBox;
    TitleL: TLabel;
    TitleE: TEdit;
    AuthorE: TEdit;
    AuthorL: TLabel;
    SubjectL: TLabel;
    SubjectE: TEdit;
    KeywordsL: TLabel;
    KeywordsE: TEdit;
    CreatorE: TEdit;
    CreatorL: TLabel;
    ProducerL: TLabel;
    ProducerE: TEdit;
    ViewerGB: TGroupBox;
    HideToolbarCB: TCheckBox;
    HideMenubarCB: TCheckBox;
    HideWindowUICB: TCheckBox;
    FitWindowCB: TCheckBox;
    CenterWindowCB: TCheckBox;
    PrintScalingCB: TCheckBox;
    cbPDFA: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure PageNumbersEChange(Sender: TObject);
    procedure PageNumbersEKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  end;

  TfrxPDFCharClass = (ccRegular, ccWhitespace, ccDelimiter);

  TfrxPDFFontInfo = record
    FontBox:      TFontBox;
    Ascent:       Integer;
    Descent:      Integer;
    AvgWidth:     Integer;
    MaxWidth:     Integer;
    ItalicAngle:  Integer;
    MissingWidth: Integer;
    StemV:        Integer;
    CapHeight:    Integer;
    Leading:      Integer;
    Flags:        Word;
  end;

  TfrxPDFFontView = class
  private
    FView: TView;
    FCollection: Boolean;
    FData: TMemoryStream;

    function  FindFont(Name: string): TFontView;
    procedure CreateView;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load(Handle: HFont); overload;
    procedure Load(Src: TStream); overload;

    function  GetFontsCount: Integer;
    function  GetFont(Index: Integer): TFontView; overload;
    function  GetFont(Name: string): TFontView; overload;
  end;

  TfrxPDFFont = class
  private
    FEmbedSubset: Boolean;
    FSourceFont: TFont;
    FReference: Longint;
    FSaved: Boolean;
    FName: AnsiString;
    FSubsetTag: AnsiString;
    FFontName: AnsiString;
    FView: TfrxPDFFontView;
    FFontView: TFontView;
    FUsedChars: TBitArray;
    FUsedGlyphs: TBitArray;
    FFontInfo: TfrxPDFFontInfo;
    FChars: array of Word;
    FGlyphs: array of Word;

    procedure MarkCharAsUsed(Char: Word);
    procedure MarkAllCharsAsUsed(const s: WideString);
    procedure LoadFontInfo;
    procedure CreateMapping;

    function GetFontFile: TStream;
    function GetFontName: AnsiString;
    function GetFontInfo: TfrxPDFFontInfo;
    function GetSubsetTag: AnsiString;
    function IsBuilt: Boolean;

    function GetCMapType: Integer;
    function GetCMapName: string;
    function GetCMapRegistry: string;
    function GetCMapOrdering: string;
    function GetCMapSupplement: Integer;
  public
    constructor Create(Font: TFont; EmbedSubset: Boolean);
    destructor Destroy; override;

    function RemapString(str: WideString; rtl: Boolean): WideString;
    procedure BuildFont;

    { Writes mapping from charcodes to CIDs.
      This stream is the content of the /Encoding key. }

    procedure WriteCharToCIDMap(Stream: TStream);

    { Writes a mapping from charcodes to unicodes }

    procedure WriteCharToUnicodeMap(Stream: TStream);

    { Writes mapping from CID to GID indices.
      This stream is the contents of the /CIDToGID key. }

    procedure WriteCIDToGIDMap(Stream: TStream);

    { Writes widths of used characters.
      This data is the value of the /W key. }

    procedure WriteCharWidths(Stream: TStream);

    { Writes a bit array of used CIDs }

    procedure WriteCIDSet(Stream: TStream);

    property FontName: AnsiString read GetFontName;
    property FontFile: TStream read GetFontFile;
    property FontInfo: TfrxPDFFontInfo read GetFontInfo;

    property CMapName: string read GetCMapName;
    property CMapOrdering: string read GetCMapOrdering;
    property CMapRegistry: string read GetCMapRegistry;
    property CMapSupplement: Integer read GetCMapSupplement;

    property PDFName: AnsiString read FName write FName;
    property Saved: Boolean read FSaved write FSaved;
    property Reference: Integer read FReference write FReference;
    property SourceFont: TFont read FSourceFont;
  end;

  TfrxPDFOutlineNode = class
  public
    Number:     Integer;
    Dest:       Integer;  // Index to a page referred to by this outline node
    Top:        Integer;  // Position on the referred to page
    CountTree:  Integer;  // Number of all descendant nodes
    Count:      Integer;  // Number of all first-level descendants
    Title:      string;

    First:  TfrxPDFOutlineNode; // The first first-level descendant
    Last:   TfrxPDFOutlineNode; // The last first-level descendant
    Next:   TfrxPDFOutlineNode; // The next neighbouring node
    Prev:   TfrxPDFOutlineNode; // The previous neighbouring node
    Parent: TfrxPDFOutlineNode; // The parent node of this node

    constructor Create;
    destructor Destroy; override;
  end;

  TfrxPDFPage = class
  public
    Height: Double;
  end;

  TfrxPDFXObjectHash = array[0..15] of Byte; // MD5

  TfrxPDFXObject = record
    ObjId: Integer; // id that appears in 'id 0 R'
    Hash: TfrxPDFXObjectHash;
  end;

  TfrxPDFBinaryStreamOption = (bsoEncrypt, bsoCompress, bsoHexEncode);
  TfrxPDFBinaryStreamOptions = set of TfrxPDFBinaryStreamOption;

  TfrxAPDFExport = class(TfrxCustomExportFilter)
  private
    FCompressed: Boolean;
    FEmbedded: Boolean;
    FOpenAfterExport: Boolean;
    FPrintOpt: Boolean;
    FPages: TList;
    FOutline: Boolean;
    FPreviewOutline: TfrxCustomOutline;

    FSubject: WideString;
    FAuthor: WideString;
    FBackground: Boolean;
    FCreator: WideString;
    FKeywords: WideString;
    FTitle: WideString;
    FProducer: WideString;

    FTags: Boolean;
    FProtection: Boolean;
    FUserPassword: AnsiString;
    FOwnerPassword: AnsiString;
    FProtectionFlags: TfrxPDFEncBits;
    FPrintScaling: Boolean;
    FFitWindow: Boolean;
    FHideMenubar: Boolean;
    FCenterWindow: Boolean;
    FHideWindowUI: Boolean;
    FHideToolbar: Boolean;

    pdf: TStream;

    FRootNumber: longint;
    FPagesNumber: longint;
    FInfoNumber: longint;
    FStartXRef: longint;

    FFonts: TList;
    FPageFonts: TList;
    FXRef: TStringList;
    FPagesRef: TStringList;

    FWidth: Extended;
    FHeight: Extended;
    FMarginLeft: Extended;
    FMarginWoBottom: Extended;
    FMarginTop: Extended;

    FEncKey: AnsiString;
    FOPass: AnsiString;
    FUPass: AnsiString;

    FEncBits: Cardinal;
    FFileID: AnsiString;

    FDivider: Extended;
    FLastColor: TColor;
    FLastColorResult: String;
    FID: AnsiString;

    FPDFA: Boolean;

    OutStream: TMemoryStream;
    FXObjects: array of TfrxPDFXObject;
    FUsedXObjects: array of Integer; // XObjects' ids used within the current page

    { These fields are used for debugging/profiling }

    FPicTotalSize: Cardinal;  // size occupied by all pictures
    FFontTotalSize: Cardinal; // size occupied by all embedded fonts

    { When an anchor is being added, two changes are made:

        - a link object is written to the document
        - a reference to the link object is added to /Annots field of the page

      FAnnots contains text of /Annots field.
      This stream is updated by WriteLink and its auxiliary routines. }

    FAnnots: TMemoryStream;

    { Writes to Res an object with Src inside.
      Performs compression and encryption if needed.
      Returns the id of the written object. }

    function WriteDataStream(Res, Src: TStream; const Ext: string;
      IsText: Boolean): Integer;

    function GetBinaryStreamOptions: TfrxPDFBinaryStreamOptions;

    function PrepXrefPos(pos: Longint): String;
    function GetID: AnsiString;
    function CryptStr(Source: AnsiString; Key: AnsiString; Enc: Boolean; id: Integer): AnsiString;
    function CryptStream(Source: TStream; Target: TStream; Key: AnsiString; id: Integer): AnsiString;
    function PrepareString(const Text: WideString; Key: AnsiString; Enc: Boolean; id: Integer): AnsiString;
    function EscapeSpecialChar(TextStr: AnsiString): AnsiString;
    function StrToUTF16(const Value: WideString): AnsiString;
    function PMD52Str(p: Pointer): AnsiString;
    function PadPassword(Password: AnsiString): AnsiString;
    procedure PrepareKeys;
    procedure SetProtectionFlags(const Value: TfrxPDFEncBits);
    procedure Clear;
    procedure WriteFont(pdfFont: TfrxPDFFont);
    procedure AddObject(const Obj: TfrxView);
    function StrToHex(const Value: WideString): AnsiString;
    function AddPage(Page: TfrxReportPage): TfrxPDFPage;
    function ObjNumber(FNumber: longint): String;
    function ObjNumberRef(FNumber: longint): String;
    function UpdateXRef: longint;
    function GetPDFColor(const Color: TColor): String;
    procedure GetStreamHash(out Hash: TfrxPDFXObjectHash; S: TStream);
    function FindXObject(const Hash: TfrxPDFXObjectHash): Integer;
    function AddXObject(Id: Integer; const Hash: TfrxPDFXObjectHash): Integer;

    { Writes the output profile.
      Returns id of the written PDF object. }

    function WriteOutputProfile: Integer;

    { Writes a PDF object with a specified id to the stream
      and writes to this object XMP metadata. }

    function WriteMetaData: Integer;

    { Formats a time in the PDF format.
      Acceptable modes:

      Mode    Sample formatted time

        D     D:19950325125439
        DZ    D:19950325125439Z
        TZ    1995-03-25T12:54:39Z }

    function FormatTime(Time: Extended; Mode: string): string;

    { Writes /OutputIntents entry.
      The entry has a subentry /DestOutputProfile.
      If OutputProfileId is not negative, then this subentry is written. }

    procedure WriteOutputIntents(OutputProfileId: Integer);

    { Writes /ViewerPreferences entry }

    procedure WriteViewerPreferences;

    { Writes /StructTreeRoot enrty }

    procedure WriteStructTreeRoot;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function ShowModal: TModalResult; override;
    function Start: Boolean; override;
    procedure ExportObject(Obj: TfrxComponent); override;
    procedure Finish; override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
  published
    property Compressed: Boolean read FCompressed write FCompressed default True;
    property EmbeddedFonts: Boolean read FEmbedded write FEmbedded default False;
    property OpenAfterExport: Boolean read FOpenAfterExport
      write FOpenAfterExport default False;
    property PrintOptimized: Boolean read FPrintOpt write FPrintOpt;
    property Outline: Boolean read FOutline write FOutline;
    property Background: Boolean read FBackground write FBackground;
    property HTMLTags: Boolean read FTags write FTags;
    property OverwritePrompt;
    property PDFA: Boolean read FPDFA write FPDFA;
    property ID: AnsiString read FID write FID;

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
  end;

{ Returns a color in PDF form. }

function PdfColor(Color: TColor): AnsiString;

{ Returns a pair of coordinates in PDF form. }

function PdfPoint(x, y: Double): AnsiString;

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

{ Fills a rectangle area. }

function PdfFillRect(Left, Bottom, Right, Top: Double; Color: TColor): AnsiString;

{ Returns either (...) or <...> sequence. }

function PdfString(const Str: WideString): AnsiString;

implementation

uses
  SyncObjs,
  Math,
  frxUtils,
  frxUnicodeUtils,
  frxFileUtils,
  frxRes,
  frxrcExports,
  frxPreviewPages,
  frxGraphicUtils,
  frxGzip,
  frxMD5,
  ActiveX,
  {$IFDEF DBGLOG}
  frxDebug,
  frxOTFPrinter,
  {$ENDIF}
  frxXML,
  frxCryptoUT,
  frxCrypto;

const
  PDF_VER = '1.5';
  PDF_DIVIDER = 0.75;
  PDF_MARG_DIVIDER = 0.05;
  PDF_PRINTOPT = 3;
  PDF_PK: array [ 1..32 ] of Byte =
    ( $28, $BF, $4E, $5E, $4E, $75, $8A, $41, $64, $00, $4E, $56, $FF, $FA, $01, $08,
      $2E, $2E, $00, $B6, $D0, $68, $3E, $80, $2F, $0C, $A9, $FE, $64, $53, $69, $7A );
  KAPPA1 = 1.5522847498;
  KAPPA2 = 2 - KAPPA1;

  iccprofile: array[0..3143] of Byte = (
	$00,$00,$0C,$48,$4C,$69,$6E,$6F,$02,$10,$00,$00,$6D,$6E,$74,$72,
	$52,$47,$42,$20,$58,$59,$5A,$20,$07,$CE,$00,$02,$00,$09,$00,$06,
	$00,$31,$00,$00,$61,$63,$73,$70,$4D,$53,$46,$54,$00,$00,$00,$00,
	$49,$45,$43,$20,$73,$52,$47,$42,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$F6,$D6,$00,$01,$00,$00,$00,$00,$D3,$2D,
	$48,$50,$20,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$11,$63,$70,$72,$74,$00,$00,$01,$50,$00,$00,$00,$33,
	$64,$65,$73,$63,$00,$00,$01,$84,$00,$00,$00,$6C,$77,$74,$70,$74,
	$00,$00,$01,$F0,$00,$00,$00,$14,$62,$6B,$70,$74,$00,$00,$02,$04,
	$00,$00,$00,$14,$72,$58,$59,$5A,$00,$00,$02,$18,$00,$00,$00,$14,
	$67,$58,$59,$5A,$00,$00,$02,$2C,$00,$00,$00,$14,$62,$58,$59,$5A,
	$00,$00,$02,$40,$00,$00,$00,$14,$64,$6D,$6E,$64,$00,$00,$02,$54,
	$00,$00,$00,$70,$64,$6D,$64,$64,$00,$00,$02,$C4,$00,$00,$00,$88,
	$76,$75,$65,$64,$00,$00,$03,$4C,$00,$00,$00,$86,$76,$69,$65,$77,
	$00,$00,$03,$D4,$00,$00,$00,$24,$6C,$75,$6D,$69,$00,$00,$03,$F8,
	$00,$00,$00,$14,$6D,$65,$61,$73,$00,$00,$04,$0C,$00,$00,$00,$24,
	$74,$65,$63,$68,$00,$00,$04,$30,$00,$00,$00,$0C,$72,$54,$52,$43,
	$00,$00,$04,$3C,$00,$00,$08,$0C,$67,$54,$52,$43,$00,$00,$04,$3C,
	$00,$00,$08,$0C,$62,$54,$52,$43,$00,$00,$04,$3C,$00,$00,$08,$0C,
	$74,$65,$78,$74,$00,$00,$00,$00,$43,$6F,$70,$79,$72,$69,$67,$68,
	$74,$20,$28,$63,$29,$20,$31,$39,$39,$38,$20,$48,$65,$77,$6C,$65,
	$74,$74,$2D,$50,$61,$63,$6B,$61,$72,$64,$20,$43,$6F,$6D,$70,$61,
	$6E,$79,$00,$00,$64,$65,$73,$63,$00,$00,$00,$00,$00,$00,$00,$12,
	$73,$52,$47,$42,$20,$49,$45,$43,$36,$31,$39,$36,$36,$2D,$32,$2E,
	$31,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$12,$73,$52,$47,
	$42,$20,$49,$45,$43,$36,$31,$39,$36,$36,$2D,$32,$2E,$31,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$58,$59,$5A,$20,$00,$00,$00,$00,$00,$00,$F3,$51,$00,$01,$00,$00,
	$00,$01,$16,$CC,$58,$59,$5A,$20,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$58,$59,$5A,$20,$00,$00,$00,$00,
	$00,$00,$6F,$A2,$00,$00,$38,$F5,$00,$00,$03,$90,$58,$59,$5A,$20,
	$00,$00,$00,$00,$00,$00,$62,$99,$00,$00,$B7,$85,$00,$00,$18,$DA,
	$58,$59,$5A,$20,$00,$00,$00,$00,$00,$00,$24,$A0,$00,$00,$0F,$84,
	$00,$00,$B6,$CF,$64,$65,$73,$63,$00,$00,$00,$00,$00,$00,$00,$16,
	$49,$45,$43,$20,$68,$74,$74,$70,$3A,$2F,$2F,$77,$77,$77,$2E,$69,
	$65,$63,$2E,$63,$68,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$16,$49,$45,$43,$20,$68,$74,$74,$70,$3A,$2F,$2F,$77,$77,$77,$2E,
	$69,$65,$63,$2E,$63,$68,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$64,$65,$73,$63,$00,$00,$00,$00,$00,$00,$00,$2E,
	$49,$45,$43,$20,$36,$31,$39,$36,$36,$2D,$32,$2E,$31,$20,$44,$65,
	$66,$61,$75,$6C,$74,$20,$52,$47,$42,$20,$63,$6F,$6C,$6F,$75,$72,
	$20,$73,$70,$61,$63,$65,$20,$2D,$20,$73,$52,$47,$42,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$2E,$49,$45,$43,$20,$36,$31,$39,
	$36,$36,$2D,$32,$2E,$31,$20,$44,$65,$66,$61,$75,$6C,$74,$20,$52,
	$47,$42,$20,$63,$6F,$6C,$6F,$75,$72,$20,$73,$70,$61,$63,$65,$20,
	$2D,$20,$73,$52,$47,$42,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$64,$65,$73,$63,
	$00,$00,$00,$00,$00,$00,$00,$2C,$52,$65,$66,$65,$72,$65,$6E,$63,
	$65,$20,$56,$69,$65,$77,$69,$6E,$67,$20,$43,$6F,$6E,$64,$69,$74,
	$69,$6F,$6E,$20,$69,$6E,$20,$49,$45,$43,$36,$31,$39,$36,$36,$2D,
	$32,$2E,$31,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$52,
	$65,$66,$65,$72,$65,$6E,$63,$65,$20,$56,$69,$65,$77,$69,$6E,$67,
	$20,$43,$6F,$6E,$64,$69,$74,$69,$6F,$6E,$20,$69,$6E,$20,$49,$45,
	$43,$36,$31,$39,$36,$36,$2D,$32,$2E,$31,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$76,$69,$65,$77,$00,$00,$00,$00,$00,$13,$A4,$FE,
	$00,$14,$5F,$2E,$00,$10,$CF,$14,$00,$03,$ED,$CC,$00,$04,$13,$0B,
	$00,$03,$5C,$9E,$00,$00,$00,$01,$58,$59,$5A,$20,$00,$00,$00,$00,
	$00,$4C,$09,$56,$00,$50,$00,$00,$00,$57,$1F,$E7,$6D,$65,$61,$73,
	$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,
	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$8F,$00,$00,$00,$02,
	$73,$69,$67,$20,$00,$00,$00,$00,$43,$52,$54,$20,$63,$75,$72,$76,
	$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$05,$00,$0A,$00,$0F,
	$00,$14,$00,$19,$00,$1E,$00,$23,$00,$28,$00,$2D,$00,$32,$00,$37,
	$00,$3B,$00,$40,$00,$45,$00,$4A,$00,$4F,$00,$54,$00,$59,$00,$5E,
	$00,$63,$00,$68,$00,$6D,$00,$72,$00,$77,$00,$7C,$00,$81,$00,$86,
	$00,$8B,$00,$90,$00,$95,$00,$9A,$00,$9F,$00,$A4,$00,$A9,$00,$AE,
	$00,$B2,$00,$B7,$00,$BC,$00,$C1,$00,$C6,$00,$CB,$00,$D0,$00,$D5,
	$00,$DB,$00,$E0,$00,$E5,$00,$EB,$00,$F0,$00,$F6,$00,$FB,$01,$01,
	$01,$07,$01,$0D,$01,$13,$01,$19,$01,$1F,$01,$25,$01,$2B,$01,$32,
	$01,$38,$01,$3E,$01,$45,$01,$4C,$01,$52,$01,$59,$01,$60,$01,$67,
	$01,$6E,$01,$75,$01,$7C,$01,$83,$01,$8B,$01,$92,$01,$9A,$01,$A1,
	$01,$A9,$01,$B1,$01,$B9,$01,$C1,$01,$C9,$01,$D1,$01,$D9,$01,$E1,
	$01,$E9,$01,$F2,$01,$FA,$02,$03,$02,$0C,$02,$14,$02,$1D,$02,$26,
	$02,$2F,$02,$38,$02,$41,$02,$4B,$02,$54,$02,$5D,$02,$67,$02,$71,
	$02,$7A,$02,$84,$02,$8E,$02,$98,$02,$A2,$02,$AC,$02,$B6,$02,$C1,
	$02,$CB,$02,$D5,$02,$E0,$02,$EB,$02,$F5,$03,$00,$03,$0B,$03,$16,
	$03,$21,$03,$2D,$03,$38,$03,$43,$03,$4F,$03,$5A,$03,$66,$03,$72,
	$03,$7E,$03,$8A,$03,$96,$03,$A2,$03,$AE,$03,$BA,$03,$C7,$03,$D3,
	$03,$E0,$03,$EC,$03,$F9,$04,$06,$04,$13,$04,$20,$04,$2D,$04,$3B,
	$04,$48,$04,$55,$04,$63,$04,$71,$04,$7E,$04,$8C,$04,$9A,$04,$A8,
	$04,$B6,$04,$C4,$04,$D3,$04,$E1,$04,$F0,$04,$FE,$05,$0D,$05,$1C,
	$05,$2B,$05,$3A,$05,$49,$05,$58,$05,$67,$05,$77,$05,$86,$05,$96,
	$05,$A6,$05,$B5,$05,$C5,$05,$D5,$05,$E5,$05,$F6,$06,$06,$06,$16,
	$06,$27,$06,$37,$06,$48,$06,$59,$06,$6A,$06,$7B,$06,$8C,$06,$9D,
	$06,$AF,$06,$C0,$06,$D1,$06,$E3,$06,$F5,$07,$07,$07,$19,$07,$2B,
	$07,$3D,$07,$4F,$07,$61,$07,$74,$07,$86,$07,$99,$07,$AC,$07,$BF,
	$07,$D2,$07,$E5,$07,$F8,$08,$0B,$08,$1F,$08,$32,$08,$46,$08,$5A,
	$08,$6E,$08,$82,$08,$96,$08,$AA,$08,$BE,$08,$D2,$08,$E7,$08,$FB,
	$09,$10,$09,$25,$09,$3A,$09,$4F,$09,$64,$09,$79,$09,$8F,$09,$A4,
	$09,$BA,$09,$CF,$09,$E5,$09,$FB,$0A,$11,$0A,$27,$0A,$3D,$0A,$54,
	$0A,$6A,$0A,$81,$0A,$98,$0A,$AE,$0A,$C5,$0A,$DC,$0A,$F3,$0B,$0B,
	$0B,$22,$0B,$39,$0B,$51,$0B,$69,$0B,$80,$0B,$98,$0B,$B0,$0B,$C8,
	$0B,$E1,$0B,$F9,$0C,$12,$0C,$2A,$0C,$43,$0C,$5C,$0C,$75,$0C,$8E,
	$0C,$A7,$0C,$C0,$0C,$D9,$0C,$F3,$0D,$0D,$0D,$26,$0D,$40,$0D,$5A,
	$0D,$74,$0D,$8E,$0D,$A9,$0D,$C3,$0D,$DE,$0D,$F8,$0E,$13,$0E,$2E,
	$0E,$49,$0E,$64,$0E,$7F,$0E,$9B,$0E,$B6,$0E,$D2,$0E,$EE,$0F,$09,
	$0F,$25,$0F,$41,$0F,$5E,$0F,$7A,$0F,$96,$0F,$B3,$0F,$CF,$0F,$EC,
	$10,$09,$10,$26,$10,$43,$10,$61,$10,$7E,$10,$9B,$10,$B9,$10,$D7,
	$10,$F5,$11,$13,$11,$31,$11,$4F,$11,$6D,$11,$8C,$11,$AA,$11,$C9,
	$11,$E8,$12,$07,$12,$26,$12,$45,$12,$64,$12,$84,$12,$A3,$12,$C3,
	$12,$E3,$13,$03,$13,$23,$13,$43,$13,$63,$13,$83,$13,$A4,$13,$C5,
	$13,$E5,$14,$06,$14,$27,$14,$49,$14,$6A,$14,$8B,$14,$AD,$14,$CE,
	$14,$F0,$15,$12,$15,$34,$15,$56,$15,$78,$15,$9B,$15,$BD,$15,$E0,
	$16,$03,$16,$26,$16,$49,$16,$6C,$16,$8F,$16,$B2,$16,$D6,$16,$FA,
	$17,$1D,$17,$41,$17,$65,$17,$89,$17,$AE,$17,$D2,$17,$F7,$18,$1B,
	$18,$40,$18,$65,$18,$8A,$18,$AF,$18,$D5,$18,$FA,$19,$20,$19,$45,
	$19,$6B,$19,$91,$19,$B7,$19,$DD,$1A,$04,$1A,$2A,$1A,$51,$1A,$77,
	$1A,$9E,$1A,$C5,$1A,$EC,$1B,$14,$1B,$3B,$1B,$63,$1B,$8A,$1B,$B2,
	$1B,$DA,$1C,$02,$1C,$2A,$1C,$52,$1C,$7B,$1C,$A3,$1C,$CC,$1C,$F5,
	$1D,$1E,$1D,$47,$1D,$70,$1D,$99,$1D,$C3,$1D,$EC,$1E,$16,$1E,$40,
	$1E,$6A,$1E,$94,$1E,$BE,$1E,$E9,$1F,$13,$1F,$3E,$1F,$69,$1F,$94,
	$1F,$BF,$1F,$EA,$20,$15,$20,$41,$20,$6C,$20,$98,$20,$C4,$20,$F0,
	$21,$1C,$21,$48,$21,$75,$21,$A1,$21,$CE,$21,$FB,$22,$27,$22,$55,
	$22,$82,$22,$AF,$22,$DD,$23,$0A,$23,$38,$23,$66,$23,$94,$23,$C2,
	$23,$F0,$24,$1F,$24,$4D,$24,$7C,$24,$AB,$24,$DA,$25,$09,$25,$38,
	$25,$68,$25,$97,$25,$C7,$25,$F7,$26,$27,$26,$57,$26,$87,$26,$B7,
	$26,$E8,$27,$18,$27,$49,$27,$7A,$27,$AB,$27,$DC,$28,$0D,$28,$3F,
	$28,$71,$28,$A2,$28,$D4,$29,$06,$29,$38,$29,$6B,$29,$9D,$29,$D0,
	$2A,$02,$2A,$35,$2A,$68,$2A,$9B,$2A,$CF,$2B,$02,$2B,$36,$2B,$69,
	$2B,$9D,$2B,$D1,$2C,$05,$2C,$39,$2C,$6E,$2C,$A2,$2C,$D7,$2D,$0C,
	$2D,$41,$2D,$76,$2D,$AB,$2D,$E1,$2E,$16,$2E,$4C,$2E,$82,$2E,$B7,
	$2E,$EE,$2F,$24,$2F,$5A,$2F,$91,$2F,$C7,$2F,$FE,$30,$35,$30,$6C,
	$30,$A4,$30,$DB,$31,$12,$31,$4A,$31,$82,$31,$BA,$31,$F2,$32,$2A,
	$32,$63,$32,$9B,$32,$D4,$33,$0D,$33,$46,$33,$7F,$33,$B8,$33,$F1,
	$34,$2B,$34,$65,$34,$9E,$34,$D8,$35,$13,$35,$4D,$35,$87,$35,$C2,
	$35,$FD,$36,$37,$36,$72,$36,$AE,$36,$E9,$37,$24,$37,$60,$37,$9C,
	$37,$D7,$38,$14,$38,$50,$38,$8C,$38,$C8,$39,$05,$39,$42,$39,$7F,
	$39,$BC,$39,$F9,$3A,$36,$3A,$74,$3A,$B2,$3A,$EF,$3B,$2D,$3B,$6B,
	$3B,$AA,$3B,$E8,$3C,$27,$3C,$65,$3C,$A4,$3C,$E3,$3D,$22,$3D,$61,
	$3D,$A1,$3D,$E0,$3E,$20,$3E,$60,$3E,$A0,$3E,$E0,$3F,$21,$3F,$61,
	$3F,$A2,$3F,$E2,$40,$23,$40,$64,$40,$A6,$40,$E7,$41,$29,$41,$6A,
	$41,$AC,$41,$EE,$42,$30,$42,$72,$42,$B5,$42,$F7,$43,$3A,$43,$7D,
	$43,$C0,$44,$03,$44,$47,$44,$8A,$44,$CE,$45,$12,$45,$55,$45,$9A,
	$45,$DE,$46,$22,$46,$67,$46,$AB,$46,$F0,$47,$35,$47,$7B,$47,$C0,
	$48,$05,$48,$4B,$48,$91,$48,$D7,$49,$1D,$49,$63,$49,$A9,$49,$F0,
	$4A,$37,$4A,$7D,$4A,$C4,$4B,$0C,$4B,$53,$4B,$9A,$4B,$E2,$4C,$2A,
	$4C,$72,$4C,$BA,$4D,$02,$4D,$4A,$4D,$93,$4D,$DC,$4E,$25,$4E,$6E,
	$4E,$B7,$4F,$00,$4F,$49,$4F,$93,$4F,$DD,$50,$27,$50,$71,$50,$BB,
	$51,$06,$51,$50,$51,$9B,$51,$E6,$52,$31,$52,$7C,$52,$C7,$53,$13,
	$53,$5F,$53,$AA,$53,$F6,$54,$42,$54,$8F,$54,$DB,$55,$28,$55,$75,
	$55,$C2,$56,$0F,$56,$5C,$56,$A9,$56,$F7,$57,$44,$57,$92,$57,$E0,
	$58,$2F,$58,$7D,$58,$CB,$59,$1A,$59,$69,$59,$B8,$5A,$07,$5A,$56,
	$5A,$A6,$5A,$F5,$5B,$45,$5B,$95,$5B,$E5,$5C,$35,$5C,$86,$5C,$D6,
	$5D,$27,$5D,$78,$5D,$C9,$5E,$1A,$5E,$6C,$5E,$BD,$5F,$0F,$5F,$61,
	$5F,$B3,$60,$05,$60,$57,$60,$AA,$60,$FC,$61,$4F,$61,$A2,$61,$F5,
	$62,$49,$62,$9C,$62,$F0,$63,$43,$63,$97,$63,$EB,$64,$40,$64,$94,
	$64,$E9,$65,$3D,$65,$92,$65,$E7,$66,$3D,$66,$92,$66,$E8,$67,$3D,
	$67,$93,$67,$E9,$68,$3F,$68,$96,$68,$EC,$69,$43,$69,$9A,$69,$F1,
	$6A,$48,$6A,$9F,$6A,$F7,$6B,$4F,$6B,$A7,$6B,$FF,$6C,$57,$6C,$AF,
	$6D,$08,$6D,$60,$6D,$B9,$6E,$12,$6E,$6B,$6E,$C4,$6F,$1E,$6F,$78,
	$6F,$D1,$70,$2B,$70,$86,$70,$E0,$71,$3A,$71,$95,$71,$F0,$72,$4B,
	$72,$A6,$73,$01,$73,$5D,$73,$B8,$74,$14,$74,$70,$74,$CC,$75,$28,
	$75,$85,$75,$E1,$76,$3E,$76,$9B,$76,$F8,$77,$56,$77,$B3,$78,$11,
	$78,$6E,$78,$CC,$79,$2A,$79,$89,$79,$E7,$7A,$46,$7A,$A5,$7B,$04,
	$7B,$63,$7B,$C2,$7C,$21,$7C,$81,$7C,$E1,$7D,$41,$7D,$A1,$7E,$01,
	$7E,$62,$7E,$C2,$7F,$23,$7F,$84,$7F,$E5,$80,$47,$80,$A8,$81,$0A,
	$81,$6B,$81,$CD,$82,$30,$82,$92,$82,$F4,$83,$57,$83,$BA,$84,$1D,
	$84,$80,$84,$E3,$85,$47,$85,$AB,$86,$0E,$86,$72,$86,$D7,$87,$3B,
	$87,$9F,$88,$04,$88,$69,$88,$CE,$89,$33,$89,$99,$89,$FE,$8A,$64,
	$8A,$CA,$8B,$30,$8B,$96,$8B,$FC,$8C,$63,$8C,$CA,$8D,$31,$8D,$98,
	$8D,$FF,$8E,$66,$8E,$CE,$8F,$36,$8F,$9E,$90,$06,$90,$6E,$90,$D6,
	$91,$3F,$91,$A8,$92,$11,$92,$7A,$92,$E3,$93,$4D,$93,$B6,$94,$20,
	$94,$8A,$94,$F4,$95,$5F,$95,$C9,$96,$34,$96,$9F,$97,$0A,$97,$75,
	$97,$E0,$98,$4C,$98,$B8,$99,$24,$99,$90,$99,$FC,$9A,$68,$9A,$D5,
	$9B,$42,$9B,$AF,$9C,$1C,$9C,$89,$9C,$F7,$9D,$64,$9D,$D2,$9E,$40,
	$9E,$AE,$9F,$1D,$9F,$8B,$9F,$FA,$A0,$69,$A0,$D8,$A1,$47,$A1,$B6,
	$A2,$26,$A2,$96,$A3,$06,$A3,$76,$A3,$E6,$A4,$56,$A4,$C7,$A5,$38,
	$A5,$A9,$A6,$1A,$A6,$8B,$A6,$FD,$A7,$6E,$A7,$E0,$A8,$52,$A8,$C4,
	$A9,$37,$A9,$A9,$AA,$1C,$AA,$8F,$AB,$02,$AB,$75,$AB,$E9,$AC,$5C,
	$AC,$D0,$AD,$44,$AD,$B8,$AE,$2D,$AE,$A1,$AF,$16,$AF,$8B,$B0,$00,
	$B0,$75,$B0,$EA,$B1,$60,$B1,$D6,$B2,$4B,$B2,$C2,$B3,$38,$B3,$AE,
	$B4,$25,$B4,$9C,$B5,$13,$B5,$8A,$B6,$01,$B6,$79,$B6,$F0,$B7,$68,
	$B7,$E0,$B8,$59,$B8,$D1,$B9,$4A,$B9,$C2,$BA,$3B,$BA,$B5,$BB,$2E,
	$BB,$A7,$BC,$21,$BC,$9B,$BD,$15,$BD,$8F,$BE,$0A,$BE,$84,$BE,$FF,
	$BF,$7A,$BF,$F5,$C0,$70,$C0,$EC,$C1,$67,$C1,$E3,$C2,$5F,$C2,$DB,
	$C3,$58,$C3,$D4,$C4,$51,$C4,$CE,$C5,$4B,$C5,$C8,$C6,$46,$C6,$C3,
	$C7,$41,$C7,$BF,$C8,$3D,$C8,$BC,$C9,$3A,$C9,$B9,$CA,$38,$CA,$B7,
	$CB,$36,$CB,$B6,$CC,$35,$CC,$B5,$CD,$35,$CD,$B5,$CE,$36,$CE,$B6,
	$CF,$37,$CF,$B8,$D0,$39,$D0,$BA,$D1,$3C,$D1,$BE,$D2,$3F,$D2,$C1,
	$D3,$44,$D3,$C6,$D4,$49,$D4,$CB,$D5,$4E,$D5,$D1,$D6,$55,$D6,$D8,
	$D7,$5C,$D7,$E0,$D8,$64,$D8,$E8,$D9,$6C,$D9,$F1,$DA,$76,$DA,$FB,
	$DB,$80,$DC,$05,$DC,$8A,$DD,$10,$DD,$96,$DE,$1C,$DE,$A2,$DF,$29,
	$DF,$AF,$E0,$36,$E0,$BD,$E1,$44,$E1,$CC,$E2,$53,$E2,$DB,$E3,$63,
	$E3,$EB,$E4,$73,$E4,$FC,$E5,$84,$E6,$0D,$E6,$96,$E7,$1F,$E7,$A9,
	$E8,$32,$E8,$BC,$E9,$46,$E9,$D0,$EA,$5B,$EA,$E5,$EB,$70,$EB,$FB,
	$EC,$86,$ED,$11,$ED,$9C,$EE,$28,$EE,$B4,$EF,$40,$EF,$CC,$F0,$58,
	$F0,$E5,$F1,$72,$F1,$FF,$F2,$8C,$F3,$19,$F3,$A7,$F4,$34,$F4,$C2,
	$F5,$50,$F5,$DE,$F6,$6D,$F6,$FB,$F7,$8A,$F8,$19,$F8,$A8,$F9,$38,
	$F9,$C7,$FA,$57,$FA,$E7,$FB,$77,$FC,$07,$FC,$98,$FD,$29,$FD,$BA,
	$FE,$4B,$FE,$DC,$FF,$6D,$FF,$FF);


var
  pdfCS: TCriticalSection;

{$R *.dfm}

{ See section 3.1.1 in the PDF reference }

function GetCharClass(c: AnsiChar): TfrxPDFCharClass;
begin
  case c of
    #0, #9, #10, #12, #13, #32: Result := ccWhitespace;
    '(', ')', '[', ']', '{', '}', '/', '%': Result := ccDelimiter;
    else Result := ccRegular;
  end;
end;

procedure EndLine(Stream: TStream);
begin
  Stream.Write(AnsiString(#13#10), 2);
end;

procedure Write(Stream: TStream; const s: AnsiString); overload;
begin
  if s <> '' then
    Stream.Write(s[1], Length(s))
end;

procedure Writeln(Stream: TStream; const s: AnsiString); overload;
begin
  Write(Stream, s);
  EndLine(Stream);
end;

procedure Write(Stream: TStream; const Fmt: string; const Args: array of const); overload;
begin
  Write(Stream, AnsiString(Format(Fmt, Args)))
end;

procedure Writeln(Stream: TStream; const Fmt: string; const Args: array of const); overload;
begin
  Writeln(Stream, AnsiString(Format(Fmt, Args)))
end;

procedure Write(Stream: TStream; const s: WideString); overload;
begin
  Write(Stream, AnsiString(s))
end;

procedure Writeln(Stream: TStream; const s: WideString); overload;
begin
  Writeln(Stream, AnsiString(s))
end;

procedure WriteTitle(Stream: TStream; Title: string; TitleLen: Integer = 120);
const
  Prefix: string = '% ===';
  Postfix: string = '=== %';
var
  i: Integer;
begin
  if Title <> '' then
    Title := ' ' + Title + ' ';

  Writeln(Stream, '');
  Write(Stream, Prefix);
  Write(Stream, Title);

  for i := 1 to TitleLen - Length(Prefix) - Length(Postfix) - Length(Title) do
    Write(Stream, '=');

  Writeln(Stream, Postfix);
  Writeln(Stream, '');
end;

procedure BeginObj(Stream: TStream; ObjId: Integer; ObjGen: Integer = 0);
begin
  Writeln(Stream, IntToStr(ObjId) + ' ' + IntToStr(ObjGen) + ' obj')
end;

procedure EndObj(Stream: TStream);
begin
  Writeln(Stream, 'endobj');
  {$IFDEF DEBUG}
  WriteTitle(Stream, '');
  {$ENDIF}
end;

procedure BeginStream(Res: TStream);
begin
  Write(Res, 'stream'#13#10); // 'stream'#10 is also valid
end;

procedure EndStream(Res: TStream);
begin
  Write(Res, #13#10'endstream'#13#10);
end;

{ PDF commands }

function PdfSetLineColor(Color: TColor): AnsiString;
begin
  Result := PdfColor(Color) + ' RG'#13#10;
end;

function PdfSetLineWidth(Width: Double): AnsiString;
begin
  Result := AnsiString(frFloat2Str(Width, 2) + ' w'#13#10);
end;

function PdfFillRect(Left, Bottom, Right, Top: Double; Color: TColor): AnsiString;
begin
  Result := PdfSetLineWidth(0) + PdfSetLineColor(Color) + PdfSetColor(Color) +
    PdfMove(Left, Bottom) + PdfLine(Right, Bottom) + PdfLine(Right, Top) +
    PdfLine(Left, Top) + PdfFill;
end;

function PdfSetColor(Color: TColor): AnsiString;
begin
  Result := PdfColor(Color) + ' rg'#13#10;
end;

function PdfFill: AnsiString;
begin
  Result := 'B'#13#10;
end;

function PdfPoint(x, y: Double): AnsiString;
begin
  Result := AnsiString(frFloat2Str(x, 2) + ' ' + frFloat2Str(y, 2));
end;

function PdfLine(x, y: Double): AnsiString;
begin
  Result := PdfPoint(x, y) + ' l'#13#10;
end;

function PdfMove(x, y: Double): AnsiString;
begin
  Result := PdfPoint(x, y) + ' m'#13#10;
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
  r, g, b, rgb: Integer;
begin
  rgb := ColorToRGB(Color);

  r := rgb and $ff;
  g := rgb shr 8 and $ff;
  b := rgb shr 16 and $ff;

  Result := c(r) + ' ' + c(g) + ' ' + c(b);
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

      Result[i*4 - 3 + 1] := hs[1];
      Result[i*4 - 3 + 2] := hs[2];
      Result[i*4 - 3 + 3] := hs[3];
      Result[i*4 - 3 + 4] := hs[4];
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
  Next.Free;
  First.Free;
  inherited;
end;

{ TfrxAPDFExport }

constructor TfrxAPDFExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAnnots := TMemoryStream.Create;
  FCompressed := True;
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

  FRootNumber := 0;
  FPagesNumber := 0;
  FInfoNumber := 0;
  FStartXRef := 0;

  FPages := TList.Create;
  FFonts := TList.Create;
  FPageFonts := TList.Create;
  FXRef := TStringList.Create;
  FPagesRef := TStringList.Create;

  FMarginLeft := 0;
  FMarginWoBottom := 0;

  FEncKey := '';
  FOPass := '';
  FUPass := '';

  FEncBits := 0;

  FDivider := frxDrawText.DefPPI / frxDrawText.ScrPPI;
  FLastColor := clBlack;
  FLastColorResult := '0 0 0';
end;

function TfrxAPDFExport.FormatTime(Time: Extended; Mode: string): string;

  function F(Fmt: string): string;
  begin
    Result := FormatDateTime(Fmt, Time)
  end;

  function FT(Fmt: string): string;
  begin
    Result := Format(Fmt, [F('yyyy'), F('mm'), F('dd'), F('hh'), F('nn'), F('ss')])
  end;

begin
  if Mode = 'TZ' then
    Result := FT('%s-%s-%sT%s:%s:%sZ')

  else if Mode = 'D' then
    Result := FT('D:%s%s%s%s%s%s')

  else if Mode = 'DZ' then
    Result := FT('D:%s%s%s%s%s%sZ')

  else
    Result := ''
end;

destructor TfrxAPDFExport.Destroy;
begin
  Clear;
  FAnnots.Free;
  FFonts.Free;
  FPageFonts.Free;
  FXRef.Free;
  FPagesRef.Free;
  FPages.Free;
  inherited;
end;

class function TfrxAPDFExport.GetDescription: String;
begin
  Result := frxResources.Get('APDFexport');
end;

function TfrxAPDFExport.ShowModal: TModalResult;
var
  s: String;
begin
  if (FTitle = '') and Assigned(Report) then
    FTitle := Report.ReportOptions.Name;
  if not Assigned(Stream) then
  begin
    if Assigned(Report) then
      FOutline := Report.PreviewOptions.OutlineVisible
    else
      FOutline := True;
    with TfrxAPDFExportDialog.Create(nil) do
    begin
      OpenCB.Visible := not SlaveExport;
      if OverwritePrompt then
        SaveDialog1.Options := SaveDialog1.Options + [ofOverwritePrompt];
      if SlaveExport then
        FOpenAfterExport := False;

      if (FileName = '') and (not SlaveExport) then
      begin
        s := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(Report.FileName)), SaveDialog1.DefaultExt);
        SaveDialog1.FileName := s;
      end
      else
        SaveDialog1.FileName := FileName;

      OpenCB.Checked := FOpenAfterExport;
      CompressedCB.Checked := FCompressed;
      EmbeddedCB.Checked := FEmbedded;
      PrintOptCB.Checked := FPrintOpt;
      OutlineCB.Checked := FOutline;
      OutlineCB.Enabled := FOutline;
      BackgrCB.Checked := FBackground;

      if PageNumbers <> '' then
      begin
        PageNumbersE.Text := PageNumbers;
        PageNumbersRB.Checked := True;
      end;

      OwnPassE.Text := String(FOwnerPassword);
      UserPassE.Text := String(FUserPassword);
      PrintCB.Checked := ePrint in FProtectionFlags;
      CopyCB.Checked := eCopy in FProtectionFlags;
      ModCB.Checked := eModify in FProtectionFlags;
      AnnotCB.Checked := eAnnot in FProtectionFlags;
      //cbPDFA.Checked := PDFA;

      TitleE.Text := FTitle;
      AuthorE.Text := FAuthor;
      SubjectE.Text := FSubject;
      KeywordsE.Text := FKeywords;
      CreatorE.Text := FCreator;
      ProducerE.Text := FProducer;

      PrintScalingCB.Checked := FPrintScaling;
      FitWindowCB.Checked := FFitWindow;
      HideMenubarCB.Checked := FHideMenubar;
      CenterWindowCB.Checked := FCenterWindow;
      HideWindowUICB.Checked := FHideWindowUI;
      HideToolbarCB.Checked := FHideToolbar;

      Result := ShowModal;
      if Result = mrOk then
      begin
        FOwnerPassword := AnsiString(OwnPassE.Text);
        FUserPassword := AnsiString(UserPassE.Text);
        FProtectionFlags := [];
        if PrintCB.Checked then
          FProtectionFlags := FProtectionFlags + [ePrint];
        if CopyCB.Checked then
          FProtectionFlags := FProtectionFlags + [eCopy];
        if ModCB.Checked then
          FProtectionFlags := FProtectionFlags + [eModify];
        if AnnotCB.Checked then
          FProtectionFlags := FProtectionFlags + [eAnnot];
        SetProtectionFlags(FProtectionFlags);
        PageNumbers := '';
        CurPage := False;
        if CurPageRB.Checked then
          CurPage := True
        else if PageNumbersRB.Checked then
          PageNumbers := PageNumbersE.Text;

        FOpenAfterExport := OpenCB.Checked;
        FCompressed := CompressedCB.Checked;
        FEmbedded := EmbeddedCB.Checked;
        FPrintOpt := PrintOptCB.Checked;
        FOutline := OutlineCB.Checked;
        FBackground := BackgrCB.Checked;
        PDFA := cbPDFA.Checked;

        FTitle := TitleE.Text;
        FAuthor := AuthorE.Text;
        FSubject := SubjectE.Text;
        FKeywords := KeywordsE.Text;
        FCreator := CreatorE.Text;
        FProducer := ProducerE.Text;

        FPrintScaling := PrintScalingCB.Checked;
        FFitWindow := FitWindowCB.Checked;
        FHideMenubar := HideMenubarCB.Checked;
        FCenterWindow := CenterWindowCB.Checked;
        FHideWindowUI := HideWindowUICB.Checked;
        FHideToolbar := HideToolbarCB.Checked;

        if not SlaveExport then
        begin
          if DefaultPath <> '' then
            SaveDialog1.InitialDir := DefaultPath;
          if SaveDialog1.Execute then
            FileName := SaveDialog1.FileName
          else
            Result := mrCancel;
        end;
      end;
      Free;
    end;
  end else
    Result := mrOk;
end;

procedure TfrxAPDFExport.Clear;
var
  i: Integer;
begin
  for i := 0 to FFonts.Count - 1 do
    TfrxPDFFont(FFonts[i]).Free;

  for i := 0 to FPages.Count - 1 do
    TObject(FPages[i]).Free;

  FPages.Clear;
  FFonts.Clear;
  FPageFonts.Clear;
  FXRef.Clear;
  FAnnots.Clear;
  FPagesRef.Clear;
  SetLength(FXObjects, 0);
end;

function TfrxAPDFExport.WriteDataStream(Res, Src: TStream; const Ext: string;
  IsText: Boolean): Integer;

  {$IFDEF DBGLOG}
  function GetDir(Path: string): string;
  var
    i: Integer;
  begin
    for i := Length(Path) downto 1 do
      if Path[i] = '\' then
      begin
        Result := Copy(Path, 1, i);
        Exit;
      end;

    Result := '';
  end;

  function GetFilePath(Hash: AnsiString; Ext: string): string;
  var
    DirPath: string;
  begin
    DirPath := GetDir(FileName) + 'fonts\';

    if not DirectoryExists(DirPath) then
      Createdir(DirPath);

    Result := DirPath + string(Copy(Hash, 1, 6));

    if Ext <> '' then
      Result := Result + '.' + Ext;
  end;

  procedure SaveStream(Data: TStream; const FilePath: string);
  begin
    with TFileStream.Create(FilePath, fmCreate) do
    try
      CopyFrom(Src, 0);
    finally
      Free;
    end;
  end;

  procedure WriteDebugInfo(Data: TStream);
  var
    Hash: AnsiString;
  begin
    Hash := HashStream('SHA1', Src);

    if not IsText then
    begin
      SaveStream(Data, GetFilePath(Hash, Ext));
      Writeln(Res, '%% Location %s', [GetFilePath(Hash, Ext)]);
    end;

    Writeln(Res, '%% Length %d', [Src.Size]);
    Writeln(Res, '%% SHA1 %s', [Hash]);

    if (Ext = 'ttf') or (Ext = 'ttc') then
    begin
      Writeln(Res, '%% Analysis saved to %s', [GetFilePath(Hash, 'log')]);
      PrintFontInfo(Src, GetFilePath(Hash, 'log'))
    end;
  end;
  {$ENDIF}

  procedure WriteStreamHeader(Data: TStream; Options: TfrxPDFBinaryStreamOptions);
  begin
    Write(Res, '<< ');
    Write(Res, '/Length %d ', [Data.Size]);
    Write(Res, '/Length1 %d ', [Src.Size]);

    if Options <> [] then
    begin
      Write(Res, '/Filter [ ');

      if bsoHexEncode in Options then
        Write(Res, '/ASCIIHexDecode ');

      if bsoCompress in Options then
        Write(Res, '/FlateDecode ');

      Write(Res, '] ');
    end;

    Writeln(Res, '>>');
  end;

  procedure EncryptStream(Data: TStream; Id: Integer);
  var
    s: TStream;
  begin
    s := TMemoryStream.Create;

    try
      CryptStream(Data, s, FEncKey, Id);
      Data.Size := 0;
      Data.CopyFrom(s, 0);
    finally
      s.Free;
    end;
  end;

  procedure CompressStream(Data: TStream);
  var
    Temp: TStream;
  begin
    Temp := TMemoryStream.Create;

    try
      Temp.CopyFrom(Data, 0);
      Data.Size := 0;
      frxDeflateStream(Temp, Data, gzFastest);
    finally
      Temp.Free;
    end;
  end;

  procedure HexEncodeStream(Data: TStream);
  var
    Hex: THexEncoder;
    Splitter: TLineSplitter;
    Temp: TStream;
  begin
    Splitter := TLineSplitter.Create(Data, 120);
    Hex := THexEncoder.Create(Splitter);
    Temp := TMemoryStream.Create;

    try
      Temp.CopyFrom(Data, 0);
      Data.Size := 0;
      Hex.CopyFrom(Temp, 0);
    finally
      Hex.Free;
      Splitter.Free;
      Temp.Free;
    end;
  end;

var
  Data: TStream;
  Options: TfrxPDFBinaryStreamOptions;
begin
  Options := GetBinaryStreamOptions;

//  {$IFNDEF DEBUG}   // Why debug was here?
  if not IsText then
    Options := Options + [bsoCompress];

  if not (bsoEncrypt in Options) then
    if not IsText or (bsoCompress in Options) then
      Options := Options + [bsoHexEncode];
//  {$ENDIF}

  Result := UpdateXRef;
  BeginObj(Res, Result);
  Data := TMemoryStream.Create;

  try
    Data.CopyFrom(Src, 0);

    if bsoCompress in Options then
      CompressStream(Data);

    if bsoEncrypt in Options then
      EncryptStream(Data, Result);

    if bsoHexEncode in Options then
      HexEncodeStream(Data);

    {$IFDEF DBGLOG}
    WriteDebugInfo(Data);
    {$ENDIF}

    WriteStreamHeader(Data, Options);
    BeginStream(Res);
    Res.CopyFrom(Data, 0);
    EndStream(Res);
  finally
    Data.Free;
    EndObj(Res);
  end;
end;

function TfrxAPDFExport.GetBinaryStreamOptions: TfrxPDFBinaryStreamOptions;
begin
  Result := [];

  if FCompressed then
    Result := Result + [bsoCompress];

  if FProtection then
    Result := Result + [bsoEncrypt];
end;

function TfrxAPDFExport.GetID: AnsiString;
var
  AGUID: TGUID;
  AGUIDString: widestring;
begin
  if ID <> '' then
    Result := ID
  else
  begin
    CoCreateGUID(AGUID);
    SetLength(AGUIDString, 39);
    StringFromGUID2(AGUID, PWideChar(AGUIDString), 39);
    Result := AnsiString(PWideChar(AGUIDString));
  end
end;

function TfrxAPDFExport.Start: Boolean;
begin
  if SlaveExport and (FileName = '') then
  begin
    if Report.FileName <> '' then
      FileName := ChangeFileExt(GetTemporaryFolder + ExtractFileName(Report.FileName), frxGet(8708))
    else
      FileName := ChangeFileExt(GetTempFile, frxGet(8708))
  end;

  if (FileName <> '') or Assigned(Stream) then
  begin
    if (ExtractFilePath(FileName) = '') and (DefaultPath <> '') then
      FileName := DefaultPath + '\' + FileName;
    FProtection := (FOwnerPassword <> '') or (FUserPassword <> '');
    if Assigned(Stream) then
      pdf := Stream
    else
      pdf := TFileStream.Create(FileName, fmCreate);
    Result := True;

    Clear;

    FFileID := MD5String(GetID);

    FPicTotalSize := 0;
    FFontTotalSize := 0;

    { PDF/A denies encryption and
      requires fonts embdedding }

    if PDFA then
    begin
      FProtection := False;
      FEmbedded := True;
    end;

    if FProtection then
    begin
      PrepareKeys;
      FEmbedded := True; // document encryption requires fonts embdedded
    end;

    if FOutline then
      FPreviewOutline := Report.PreviewPages.Outline;

    WriteLn(pdf, '%PDF-' + PDF_VER);
    WriteLn(pdf, '%'#128#128#128#128); // required by PDF/A
    UpdateXRef;
  end else
    Result := False;
end;

procedure TfrxAPDFExport.StartPage(Page: TfrxReportPage; Index: Integer);
const
  mm2p: Double = 1.0 / 25.4 * 72; // millimeters to points
begin
  SetLength(FUsedXObjects, 0);

  AddPage(Page);
  FWidth := Page.Width * PDF_DIVIDER;
  FHeight := Page.Height * PDF_DIVIDER;
  FMarginLeft := Page.LeftMargin * PDF_MARG_DIVIDER;
  FMarginTop := Page.TopMargin * PDF_MARG_DIVIDER;
  OutStream := TMemoryStream.Create;

  with Page do
    if Color <> clNone then
      Write(OutStream, PdfFillRect(LeftMargin * mm2p,
        BottomMargin * mm2p, FWidth - RightMargin * mm2p,
        FHeight - TopMargin * mm2p, Color));
end;

procedure TfrxAPDFExport.FinishPage(Page: TfrxReportPage; Index: Integer);
var
  FContentsPos, FPagePos: Integer;
  i: Integer;
begin
  FContentsPos := WriteDataStream(pdf, OutStream, '.page', True);
  OutStream.Free;

  if FPageFonts.Count > 0 then
    for i := 0 to FPageFonts.Count - 1 do
      if not TfrxPDFFont(FPageFonts[i]).Saved then
      begin
        TfrxPDFFont(FPageFonts[i]).Reference := UpdateXRef;
        TfrxPDFFont(FPageFonts[i]).Saved := true;
      end;

  FPagePos := UpdateXRef();
  FPagesRef.Add(IntToStr(FPagePos));
  WriteLn(pdf, ObjNumber(FPagePos));
  WriteLn(pdf, '<<');
  WriteLn(pdf, '/Type /Page');
  WriteLn(pdf, '/Parent 1 0 R');
  WriteLn(pdf, '/MediaBox [0 0 ' + frFloat2Str(FWidth) +
    ' ' + frFloat2Str(FHeight) + ' ]');

  { Write the list of references
    to anchor objects }

  if FAnnots.Size > 0 then
  begin
    WriteLn(PDF, '/Annots [');
    FAnnots.Seek(0, soFromBeginning);
    PDF.CopyFrom(FAnnots, FAnnots.Size);
    WriteLn(PDF, ']');
    FAnnots.Clear;
  end;

  WriteLn(pdf, '/Resources <<');
  Write(pdf, '/Font << ');
  for i := 0 to FPageFonts.Count - 1 do
{$IFDEF Delphi12}
    Write(pdf, TfrxPDFFont(FPageFonts[i]).PDFName + AnsiString(' ' + ObjNumberRef(TfrxPDFFont(FPageFonts[i]).Reference) + ' '));
{$ELSE}
    Write(pdf, TfrxPDFFont(FPageFonts[i]).PDFName + ' ' + ObjNumberRef(TfrxPDFFont(FPageFonts[i]).Reference) + ' ');
{$ENDIF}
  WriteLn(pdf, '>>');

  { Enumerate used XObjects }

  if Length(FUsedXObjects) > 0 then
  begin
    Write(pdf, '/XObject << ');

    for i := 0 to High(FUsedXObjects) do
    begin
      Write(pdf, '/Im' + IntToStr(FUsedXObjects[i]) + ' ');
      Write(pdf, ObjNumberRef(FXObjects[FUsedXObjects[i]].ObjId) + ' ');
    end;

    Writeln(pdf, '>>');
  end;

  WriteLn(pdf, '/ProcSet [/PDF /Text /ImageC ]');
  WriteLn(pdf, '>>');
  WriteLn(pdf, '/Contents ' + ObjNumberRef(FContentsPos));
  WriteLn(pdf, '>>');
  EndObj(pdf);
end;

procedure TfrxAPDFExport.ExportObject(Obj: TfrxComponent);
begin
  if (Obj is TfrxView) and (ExportNotPrintable or TfrxView(Obj).Printable) then
    AddObject(Obj as TfrxView);
end;

function TfrxAPDFExport.FindXObject(const Hash: TfrxPDFXObjectHash): Integer;
begin
  for Result := 0 to High(FXObjects) do
    if CompareMem(@Hash, @FXObjects[Result].Hash, SizeOf(Hash)) then
      Exit;

  Result := -1;
end;

procedure TfrxAPDFExport.Finish;
var
  i: Integer;
  FInfoNumber, FRootNumber: Integer;
  OutlineTree: TfrxPDFOutlineNode;
  pgN: TStringList;
  OutlineObjId: Integer;
  MetadataObjId: Integer;
  OutputProfileObjId: Integer;

  function IsPageInRange(const PageN: Integer): Boolean;
  begin
    Result := (PageN >= 0) and (PageN < FPages.Count) and
      ((pgN.Count = 0) or (pgN.IndexOf(IntToStr(PageN + 1)) >= 0));
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

    Node.Number := UpdateXRef;

    WriteLn(pdf, IntToStr(Node.Number) + ' 0 obj');
    WriteLn(pdf, '<<');
    WriteLn(pdf, '/Title ' + PrepareString(Node.Title, FEncKey, FProtection, Node.Number));
    WriteLn(pdf, '/Parent ' + IntToStr(Node.Parent.Number) + ' 0 R');

    if Node.Prev <> nil then
      WriteLn(pdf, '/Prev ' + IntToStr(Node.Prev.Number) + ' 0 R');

    if Node.Next <> nil then
      WriteLn(pdf, '/Next ' + IntToStr(Node.Next.Number) + ' 0 R');

    if Node.First <> nil then
    begin
      WriteLn(pdf, '/First ' + IntToStr(Node.First.Number) + ' 0 R');
      WriteLn(pdf, '/Last ' + IntToStr(Node.Last.Number) + ' 0 R');
      WriteLn(pdf, '/Count ' + IntToStr(Node.Count));
    end;

    if IsPageInRange(Node.Dest) then
    begin
      if pgN.Count > 0 then
        Page := pgN.IndexOf(IntToStr(Node.Dest + 1))
      else
        Page := Node.Dest;

      y := Round(TfrxPDFPage(FPages[Page]).Height - Node.Top * PDF_DIVIDER);
      Dest := FPagesRef[Page];
      WriteLn(pdf, '/Dest [' + Dest + ' 0 R /XYZ 0 ' + IntToStr(y) + ' 0]');
    end;

    WriteLn(pdf, '>>');
    EndObj(pdf);

    if Node.First <> nil then
      WriteOutline(Node.First);

    if Node.Next <> nil then
      WriteOutline(Node.Next);
  end;

begin
  {$IFDEF DBGLOG}
  DbgPrintTitle('Fonts');
  {$ENDIF}

  for i := 0 to FFonts.Count - 1 do
  begin
    {$IFDEF DEBUG}
    WriteTitle(pdf, 'font ' + IntToStr(i));
    {$ENDIF}

    WriteFont(TfrxPDFFont(FFonts[i]));
  end;

  FPagesNumber := 1;
  FXRef[0] := PrepXrefPos(pdf.Position);
  WriteLn(pdf, ObjNumber(FPagesNumber));
  WriteLn(pdf, '<<');
  WriteLn(pdf, '/Type /Pages');
  Write(pdf, '/Kids [');
  for i := 0 to FPagesRef.Count - 1 do
    Write(pdf, FPagesRef[i] + ' 0 R ');
  WriteLn(pdf, ']');
  WriteLn(pdf, '/Count ' + IntTOStr(FPagesRef.Count));
  WriteLn(pdf, '>>');
  EndObj(pdf);
  FInfoNumber := UpdateXRef();
  WriteLn(pdf, ObjNumber(FInfoNumber));
  WriteLn(pdf, '<<');
  WriteLn(pdf, '/Title ' + PrepareString(FTitle, FEncKey, FProtection, FInfoNumber));
  WriteLn(pdf, '/Author ' + PrepareString(FAuthor, FEncKey, FProtection, FInfoNumber));
  WriteLn(pdf, '/Subject ' + PrepareString(FSubject, FEncKey, FProtection, FInfoNumber));
  WriteLn(pdf, '/Keywords ' + PrepareString(FKeywords, FEncKey, FProtection, FInfoNumber));
  WriteLn(pdf, '/Creator ' + PrepareString(FCreator, FEncKey, FProtection, FInfoNumber));
  WriteLn(pdf, '/Producer ' + PrepareString(FProducer, FEncKey, FProtection, FInfoNumber));

  if FProtection then
  begin
    WriteLn(pdf, '/CreationDate ' + PrepareString(FormatTime(CreationTime, 'DZ'),
      FEncKey, FProtection, FInfoNumber));

    WriteLn(pdf, '/ModDate ' + PrepareString(FormatTime(CreationTime, 'DZ'),
      FEncKey, FProtection, FInfoNumber));
  end
  else
  begin
    WriteLn(pdf, '/CreationDate (' + FormatTime(CreationTime, 'DZ') + ')');
    WriteLn(pdf, '/ModDate (' + FormatTime(CreationTime, 'DZ') + ')');
  end;

  WriteLn(pdf, '>>');
  EndObj(pdf);

  { Write the document outline }

  OutlineTree := TfrxPDFOutlineNode.Create;
  pgN := TStringList.Create;
  OutlineObjId := 0;

  if FOutline then
  begin
    frxParsePageNumbers(PageNumbers, pgN, Report.PreviewPages.Count);
    FPreviewOutline.LevelRoot;

    { PrepareOutline needs to know the exact number of objects
      that will be written before the first outline node object.
      The number of already written objects is FXRef.Count, and
      one object (/Type /Outlines) will be written before the first
      outline node. That's why PrepareOutline is given FXRef.Count + 1. }

    PrepareOutline(FPreviewOutline, OutlineTree, FXRef.Count + 1);
  end;

  if OutlineTree.CountTree > 0 then
  begin
    OutlineObjId := UpdateXRef;
    OutlineTree.Number := OutlineObjId;

    { It's important to write the /Outlines object first,
      because object numbers for outline nodes was calculated
      in assumption that /Outlines will be written first. }

    WriteLn(pdf, IntToStr(OutlineObjId) + ' 0 obj');
    WriteLn(pdf, '<<');
    WriteLn(pdf, '/Type /Outlines');
    WriteLn(pdf, '/Count ' + IntToStr(OutlineTree.Count));
    WriteLn(pdf, '/First ' + IntToStr(OutlineTree.First.Number) + ' 0 R');
    WriteLn(pdf, '/Last ' + IntToStr(OutlineTree.Last.Number) + ' 0 R');
    WriteLn(pdf, '>>');
    EndObj(pdf);

    { Write outline nodes }

    WriteOutline(OutlineTree.First);
  end;

  OutlineTree.Free;
  pgN.Free;

  { Write metadata and the ICC profile }

  MetadataObjId := 0;
  OutputProfileObjId := 0;

  if PDFA then
  begin
    MetadataObjId := WriteMetaData;
    OutputProfileObjId := WriteOutputProfile;
  end;

  { Write the catalog }

  FRootNumber := UpdateXRef;

  WriteLn(pdf, ObjNumber(FRootNumber));
  WriteLn(pdf, '<<');
  WriteLn(pdf, '/Type /Catalog');
  WriteLn(pdf, '/Pages ' + ObjNumberRef(FPagesNumber));
  Writeln(pdf, '/MarkInfo<</Marked true>>');

  if PDFA then
  begin
    Writeln(pdf, '/Metadata ' + ObjNumberRef(MetadataObjId));
    WriteOutputIntents(OutputProfileObjId);
  end;

  if not FOutline then
    WriteLn(pdf, '/PageMode /UseNone')
  else
  begin
    WriteLn(pdf, '/PageMode /UseOutlines');
    WriteLn(pdf, '/Outlines ' + ObjNumberRef(OutlineObjId));
  end;

  WriteStructTreeRoot;
  WriteViewerPreferences;
  WriteLn(pdf, '>>');
  EndObj(pdf);

  { Write XRef }

  FStartXRef := pdf.Position;
  WriteLn(pdf, 'xref');
  WriteLn(pdf, '0 ' + IntToStr(FXRef.Count + 1));
  WriteLn(pdf, '0000000000 65535 f');
  for i := 0 to FXRef.Count - 1 do
    WriteLn(pdf, FXRef[i] + ' 00000 n');

  { Write the trailer }

  WriteLn(pdf, 'trailer');
  WriteLn(pdf, '<<');
  WriteLn(pdf, '/Size ' + IntToStr(FXRef.Count + 1));
  WriteLn(pdf, '/Root ' + ObjNumberRef(FRootNumber));
  WriteLn(pdf, '/Info ' + ObjNumberRef(FInfoNumber));
  WriteLn(pdf, '/ID [<' + FFileID + '><' + FFileID + '>]');
  if FProtection then
  begin
    WriteLn(pdf, '/Encrypt <<');
    WriteLn(pdf, '/Filter /Standard' );
    WriteLn(pdf, '/V 2');
    WriteLn(pdf, '/R 3');
    WriteLn(pdf, '/Length 128');
    WriteLn(pdf, '/P ' + IntToStr(Integer(FEncBits)));
    WriteLn(pdf, '/O (' + EscapeSpecialChar(FOPass) + ')');
    WriteLn(pdf, '/U (' + EscapeSpecialChar(FUPass) + ')');
    WriteLn(pdf, '>>');
  end;
  WriteLn(pdf, '>>');
  WriteLn(pdf, 'startxref');
  WriteLn(pdf, IntToStr(FStartXRef));
  WriteLn(pdf, '%%EOF');

  { Open the file if needed }

  Clear;

  if not Assigned(Stream) then
    pdf.Free;

  {$IFDEF DBGLOG}
  DbgPrint('Fonts total size: %d'#10, [FFontTotalSize]);
  DbgPrint('Pictures total size: %d'#10, [FPicTotalSize]);
  {$ENDIF}

  if FOpenAfterExport and not Assigned(Stream) then
    ShellExecute(GetDesktopWindow, 'open', PChar(FileName), nil, nil, SW_SHOW);
end;

procedure TfrxAPDFExport.WriteViewerPreferences;
begin
  WriteLn(pdf, '/ViewerPreferences <<');

  if FTitle <> '' then
    WriteLn(pdf, '/DisplayDocTitle true');

  if FHideToolbar then
    WriteLn(pdf, '/HideToolbar true');

  if FHideMenubar then
    WriteLn(pdf, '/HideMenubar true');

  if FHideWindowUI then
    WriteLn(pdf, '/HideWindowUI true');

  if FFitWindow then
    WriteLn(pdf, '/FitWindow true');

  if FCenterWindow then
    WriteLn(pdf, '/CenterWindow true');

  if not FPrintScaling then
    WriteLn(pdf, '/PrintScaling /None');

  WriteOutputIntents(-1);
  WriteLn(pdf, '>>');
end;

function TfrxAPDFExport.WriteMetaData: Integer;
var
  XMP: TfrxXMLItem;
  Writer: TfrxXMLWriter;
  Stream: TStream;
begin
  XMP := TfrxXMLItem.Create;
  XMP.Name := 'x:xmpmeta';

  with XMP do
  begin
    Prop['xmlns:x'] := 'adobe:ns:meta/';
    Prop['x:xmptk'] := 'Adobe XMP Core 4.2.1-c041 52.342996, 2008/05/07-20:48:00';

    with Add('rdf:RDF') do
    begin
      Prop['xmlns:rdf'] := 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';

      with Add('rdf:Description') do
      begin
        Prop['rdf:about'] := '';
        Prop['xmlns:dc'] := 'http://purl.org/dc/elements/1.1/';

        Add('dc:format').Value := 'application/pdf';
        Add('dc:creator').Add('rdf:Seq').Add('rdf:li').Value := string(UTF8Encode(Author));

        with Add('dc:description').Add('rdf:Alt').Add('rdf:li') do
        begin
          Value := FSubject;
          Prop['xml:lang'] := 'x-default';
        end;

        with Add('dc:title').Add('rdf:Alt').Add('rdf:li') do
        begin
          Prop['xml:lang'] := 'x-default';
        end;
      end;

      with Add('rdf:Description') do
      begin
        Prop['rdf:about'] := '';
        Prop['xmlns:xmp'] := 'http://ns.adobe.com/xap/1.0/';

        Add('xmp:CreatorTool').Value := string(UTF8Encode(Creator));
        Add('xmp:CreateDate').Value := FormatTime(CreationTime, 'TZ');
        Add('xmp:ModifyDate').Value := FormatTime(CreationTime, 'TZ');
        Add('xmp:MetadataDate').Value := FormatTime(CreationTime, 'TZ');
      end;

      with Add('rdf:Description') do
      begin
        Prop['rdf:about'] := '';
        Prop['xmlns:pdf'] := 'http://ns.adobe.com/pdf/1.3/';

        Add('pdf:Keywords');
        Add('pdf:Producer');
      end;

      with Add('rdf:Description') do
      begin
        Prop['rdf:about'] := '';
        Prop['xmlns:xmpMM'] := 'http://ns.adobe.com/xap/1.0/mm/';

        { These two values were generated by Adobe Reader for one document. }

        Add('xmpMM:DocumentID').Value := 'uuid:5b7f0115-34d9-4038-b3ef-9d13b830f2ad';
        Add('xmpMM:InstanceID').Value := 'uuid:fd19f723-4cc0-4ea4-99fa-3616bfbe1e92';
      end;

      with Add('rdf:Description') do
      begin
        Prop['rdf:about'] := '';
        Prop['xmlns:pdfaid'] := 'http://www.aiim.org/pdfa/ns/id/';

        Add('pdfaid:part').Value := '1';
        Add('pdfaid:conformance').Value := 'A';
      end;

      with Add('rdf:Description') do
      begin
        Prop['rdf:about'] := '';
        Prop['xmlns:pdfaExtension'] := 'http://www.aiim.org/pdfa/ns/extension/';
        Prop['xmlns:pdfaSchema'] := 'http://www.aiim.org/pdfa/ns/schema#';
        Prop['xmlns:pdfaProperty'] := 'http://www.aiim.org/pdfa/ns/property#';

        with Add('pdfaExtension:schemas').Add('rdf:Bag') do
        begin
          With Add('rdf:li') do
          begin
            Prop['rdf:parseType'] := 'Resource';

            Add('pdfaSchema:namespaceURI').Value := 'http://ns.adobe.com/pdf/1.3/';
            Add('pdfaSchema:prefix').Value := 'pdf';
            Add('pdfaSchema:schema').Value := 'Adobe PDF Schema';

            with Add('pdfaSchema:property').Add('rdf:Seq').Add('rdf:li') do
            begin
              Prop['rdf:parseType'] := 'Resource';

              Add('pdfaProperty:category').Value := 'internal';
              Add('pdfaProperty:description').Value := 'A name object indicating whether ' +
                'the document has been modified to include trapping information';
              Add('pdfaProperty:name').Value := 'Trapped';
              Add('pdfaProperty:valueType').Value := 'Text';
            end;
          end;

          With Add('rdf:li') do
          begin
            Prop['rdf:parseType'] := 'Resource';

            Add('pdfaSchema:namespaceURI').Value := 'http://ns.adobe.com/xap/1.0/mm/';
            Add('pdfaSchema:prefix').Value := 'xmpMM';
            Add('pdfaSchema:schema').Value := 'XMP Media Management Schema';

            with Add('pdfaSchema:property').Add('rdf:Seq').Add('rdf:li') do
            begin
              Prop['rdf:parseType'] := 'Resource';

              Add('pdfaProperty:category').Value := 'internal';
              Add('pdfaProperty:description').Value := 'UUID based identifier for ' +
                'specific incarnation of a document';
              Add('pdfaProperty:name').Value := 'InstanceID';
              Add('pdfaProperty:valueType').Value := 'URI';
            end;
          end;

          With Add('rdf:li') do
          begin
            Prop['rdf:parseType'] := 'Resource';

            Add('pdfaSchema:namespaceURI').Value := 'http://www.aiim.org/pdfa/ns/id/';
            Add('pdfaSchema:prefix').Value := 'pdfaid';
            Add('pdfaSchema:schema').Value := 'PDF/A ID Schema';

            with Add('pdfaSchema:property').Add('rdf:Seq') do
            begin
              with Add('rdf:li') do
              begin
                Prop['rdf:parseType'] := 'Resource';

                Add('pdfaProperty:category').Value := 'internal';
                Add('pdfaProperty:description').Value := 'Part of PDF/A standard';
                Add('pdfaProperty:name').Value := 'part';
                Add('pdfaProperty:valueType').Value := 'Integer';
              end;

              with Add('rdf:li') do
              begin
                Prop['rdf:parseType'] := 'Resource';

                Add('pdfaProperty:category').Value := 'internal';
                Add('pdfaProperty:description').Value := 'Amendment of PDF/A standard';
                Add('pdfaProperty:name').Value := 'amd';
                Add('pdfaProperty:valueType').Value := 'Text';
              end;

              with Add('rdf:li') do
              begin
                Prop['rdf:parseType'] := 'Resource';

                Add('pdfaProperty:category').Value := 'internal';
                Add('pdfaProperty:description').Value := 'Conformance level of PDF/A standard';
                Add('pdfaProperty:name').Value := 'conformance';
                Add('pdfaProperty:valueType').Value := 'Text';
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  { Save the built XML tree to a stream. }

  Stream := TMemoryStream.Create;

  Writer := TfrxXMLWriter.Create(Stream);
  Writer.AutoIndent := True;

  Writeln(Stream, '<?xpacket begin="'#$ef#$bb#$bf'" id="W5M0MpCehiHzreSzNTczkc9d"?>');
  Writer.WriteRootItem(XMP);
  Writeln(Stream, '<?xpacket end="w"?>');

  Writer.Free;
  XMP.Free;

  { Write a PDF object with the XMP metadata. }

  Result := UpdateXRef;
  Writeln(pdf, ObjNumber(Result));
  Writeln(pdf, '<</Length ' + IntToStr(Stream.Size) + '/Subtype/XML/Type/Metadata>>');
  BeginStream(pdf);

  Stream.Seek(0, soFromBeginning);
  pdf.CopyFrom(Stream, Stream.Size);
  Stream.Free;

  EndStream(pdf);
  EndObj(pdf);
end;

procedure TfrxAPDFExport.WriteOutputIntents(OutputProfileId: Integer);
begin
  Writeln(pdf, '/OutputIntents[<<');
  Writeln(pdf, '/Type/OutputIntent');
  Writeln(pdf, '/S/GTS_PDFA1');
  Writeln(pdf, '/RegistryName(http://www.color.org)');
  Writeln(pdf, '/OutputConditionIdentifier(Custom)');
  Writeln(pdf, '/OutputCondition()');
  Writeln(pdf, '/Info(sRGB IEC61966-2.1)');

  if OutputProfileId >= 0 then
    Writeln(pdf, '/DestOutputProfile ' + ObjNumberRef(OutputProfileId));

  Writeln(pdf, '>>]');
end;

function TfrxAPDFExport.WriteOutputProfile: Integer;
const
  ICCFile = 'pdfaprofile.icc';
var
  Stream: TStream;
  sz: Integer;
begin
{$IF FALSE}
  if not FileExists(ICCFile) then
    Stream := TMemoryStream.Create // empty stream
  else
  try
    Stream := TFileStream.Create(ICCFile, 0); // ICC profile required by PDF/A
  except
    Stream := TMemoryStream.Create; // empty stream
  end;
{$ELSE}
  Stream := TMemoryStream.Create;
  sz := SizeOf(iccprofile);
  Stream.WriteBuffer( iccprofile, sz );
  Stream.Seek(0, TSeekOrigin.soBeginning );
  sz := Stream.Size;
{$IFEND}

  Result := UpdateXRef;

  Writeln(pdf, ObjNumber(Result));
  Writeln(pdf, '<< /N 4 /Length ' + IntToStr(sz) + '>>');
  BeginStream(pdf);
  pdf.CopyFrom(Stream, sz);
  EndStream(pdf);
  EndObj(pdf);

  Stream.Free;
end;

procedure TfrxAPDFExport.WriteStructTreeRoot;
begin
  Writeln(pdf, '/StructTreeRoot<<');
  Writeln(pdf, '/Type /StructTreeRoot');
  Writeln(pdf, '>>');
end;

function TfrxAPDFExport.EscapeSpecialChar(TextStr: AnsiString): AnsiString;
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

function TfrxAPDFExport.CryptStr(Source: AnsiString; Key: AnsiString; Enc: Boolean; id: Integer): AnsiString;
var
  k: array [ 1..21 ] of Byte;
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
      Move(id, k [17], 3);
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

function TfrxAPDFExport.CryptStream(Source: TStream; Target: TStream; Key: AnsiString; id: Integer): AnsiString;
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

function TfrxAPDFExport.StrToUTF16(const Value: WideString): AnsiString;
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

function TfrxAPDFExport.PrepareString(const Text: WideString; Key: AnsiString; Enc: Boolean; id: Integer): AnsiString;
begin
  if Enc then
    Result := '(' + CryptStr(AnsiString(Text), Key, Enc, id) + ')'
  else
    Result := '<' + StrToUTF16(Text) + '>'
end;

function TfrxAPDFExport.PMD52Str(p: Pointer): AnsiString;
begin
  SetLength(Result, 16);
  Move(p^, Result[1], 16);
end;

function TfrxAPDFExport.PadPassword(Password: AnsiString): AnsiString;
var
  i: Integer;
begin
  i := Length(Password);
  Result := Copy(Password, 1, i);
  SetLength(Result, 32);
  if i < 32 then
    Move(PDF_PK, Result[i + 1], 32 - i);
end;

procedure TfrxAPDFExport.PrepareKeys;
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

procedure TfrxAPDFExport.SetProtectionFlags(const Value: TfrxPDFEncBits);
begin
  FProtectionFlags := Value;
  FEncBits := $FFFFFFC0;
  FEncBits := FEncBits + (Cardinal(ePrint in Value) shl 2 +
    Cardinal(eModify in Value) shl 3 +
    Cardinal(eCopy in Value) shl 4 +
    Cardinal(eAnnot in Value) shl 5);
end;

procedure TfrxAPDFExport.WriteFont(pdfFont: TfrxPDFFont);

  { Writes an object with the font file inside }

  function WriteFontFile: Integer;
  begin
    Inc(FFontTotalSize, pdfFont.FontFile.Size);
    Result := WriteDataStream(pdf, pdfFont.FontFile, 'ttf', False);
  end;

  { Writes CMap (char to glyph mapping) }

  function WriteCMap: Integer;
  var
    CMap: TStream;
  begin
    Result := UpdateXRef;
    BeginObj(pdf, Result);

    CMap := TMemoryStream.Create;

    try
      PDFFont.WriteCharToCIDMap(CMap);

      Writeln(pdf, '<<');
      Writeln(pdf, '/Type /CMap');
      Writeln(pdf, '/CMapName /%s', [PDFFont.CMapName]);
      Writeln(pdf, '/CIDSystemInfo << /Registry (%s) /Ordering (%s) /Supplement %d >>',
        [PDFFont.CMapRegistry, PDFFont.CMapOrdering, PDFFont.CMapSupplement]);
      Writeln(pdf, '/WMode 0');
      Writeln(pdf, '/Length %d', [CMap.Size]);
      Writeln(pdf, '>>');

      BeginStream(pdf);
      pdf.CopyFrom(CMap, 0);
      EndStream(pdf);
    finally
      CMap.Free;
      EndObj(pdf);
    end;
  end;

  { Writes FontDescriptor }

  function WriteFontDescriptor(CIDSetId: Integer): Integer;
  var
    FontFileId: Integer;
  begin
    FontFileId := 0; // to suppress W1036 compiler warning

    if FEmbedded then
      FontFileId := WriteFontFile;

    Result := UpdateXRef;
    BeginObj(pdf, Result);

    WriteLn(pdf, '<<');
    WriteLn(pdf, '/Type /FontDescriptor');
    WriteLn(pdf, '/FontName /' + pdffont.fontName);
    WriteLn(pdf, '/FontFamily /' + pdffont.fontName);

    with pdfFont.FontInfo do
    begin
      with FontBox do
        WriteLn(pdf, '/FontBBox [%d %d %d %d]', [XMin, YMin, XMax, YMax]);

      WriteLn(pdf, '/ItalicAngle %d', [ItalicAngle]);
      WriteLn(pdf, '/Ascent %d', [Ascent]);
      WriteLn(pdf, '/Descent %d', [Descent]);
      WriteLn(pdf, '/CapHeight %d', [CapHeight]);
      WriteLn(pdf, '/StemV %d', [StemV]);
      WriteLn(pdf, '/Flags %d', [32]);
    end;

    Writeln(pdf, '/CIDSet %s', [ObjNumberRef(CIDSetId)]);

    if FEmbedded then
      WriteLn(pdf, '/FontFile2 ' + ObjNumberRef(FontFileId));

    WriteLn(pdf, '>>');
    EndObj(pdf);
  end;

  { Writes CIDSystemInfo }

  function WriteCIDSystemInfo: Integer;
  begin
    Result := UpdateXRef;
    BeginObj(pdf, Result);
    WriteLn(pdf, '<< /Registry (%s) /Ordering (%s) /Supplement %d >>',
      [PDFFont.CMapRegistry, PDFFont.CMapOrdering, PDFFont.CMapSupplement]);
    EndObj(pdf);
  end;

  { Writes CID to GID mapping }

  function WriteCIDToGID: Integer;
  var
    Map: TStream;
  begin
    Map := TMemoryStream.Create;

    try
      pdfFont.WriteCIDToGIDMap(Map);
      Result := WriteDataStream(pdf, Map, 'cidtogid', False);
    finally
      Map.Free;
    end;
  end;

  { Writes CIDFontType2 }

  function WriteDescendantFonts(CIDSystemInfoId, DescriptorId: Integer): Integer;
  var
    CIDToGIDMapId: Integer;
  begin
    CIDToGIDMapId := WriteCIDToGID;

    Result := UpdateXRef;
    BeginObj(pdf, Result);

    WriteLn(pdf, '<<');
    WriteLn(pdf, '/Type /Font');
    WriteLn(pdf, '/Subtype /CIDFontType2');
    //Writeln(pdf, '/CIDToGIDMap /Identity');
    Writeln(pdf, '/CIDToGIDMap %s', [ObjNumberRef(CIDToGIDMapId)]);
    WriteLn(pdf, '/BaseFont /' + pdffont.fontName);
    WriteLn(pdf, '/CIDSystemInfo ' + ObjNumberRef(cIDSystemInfoId));
    WriteLn(pdf, '/FontDescriptor ' + ObjNumberRef(descriptorId));

    Write(pdf, '/W ');
    PDFFont.WriteCharWidths(pdf);
    WriteLn(pdf, '');

    WriteLn(pdf, '>>');
    EndObj(pdf);
  end;

  { Writes char to unicode map }

  function WriteUnicodeMap: Integer;
  var
    CMap: TStream;
  begin
    CMap := TMemoryStream.Create;

    try
      pdfFont.WriteCharToUnicodeMap(CMap);
      Result := WriteDataStream(pdf, CMap, 'cmap', True);
    finally
      CMap.Free;
    end;
  end;

  { Writes a bitmask of used CIDs }

  function WriteCIDSet: Integer;
  var
    s: TStream;
  begin
    s := TMemoryStream.Create;

    try
      pdfFont.WriteCIDSet(s);
      Result := WriteDataStream(pdf, s, 'cidset', False);
    finally
      s.Free;
    end;
  end;

var
  //CMapId: Integer;
  DescendantFontId: Integer;
  CIDSystemInfoId: Integer;
  FontDescriptorId: Integer;
  UnicodeMapId: Integer;
  CIDSetId: Integer;
begin
  pdfFont.BuildFont;

  //CMapId := WriteCMap;
  CIDSetId := WriteCIDSet;
  UnicodeMapId := WriteUnicodeMap;
  CIDSystemInfoId := WriteCIDSystemInfo;
  FontDescriptorId := WriteFontDescriptor(CIDSetId);
  DescendantFontId := WriteDescendantFonts(CIDSystemInfoId, FontDescriptorId);

  FXRef[pdfFont.Reference - 1] := PrepXrefPos(pdf.Position);
  WriteLn(pdf, ObjNumber(pdfFont.Reference));
  WriteLn(pdf, '<<');
  WriteLn(pdf, '/Type /Font');
  WriteLn(pdf, '/Subtype /Type0');
  WriteLn(pdf, '/BaseFont /%s', [pdffont.fontName]);
  //WriteLn(pdf, '/Encoding %s', [ObjNumberRef(CMapId)]);
  WriteLn(pdf, '/Encoding /Identity-H % char to CID');
  WriteLn(pdf, '/DescendantFonts [' +
    ObjNumberRef(DescendantFontId) + ']');
  WriteLn(pdf, '/ToUnicode %s', [ObjNumberRef(UnicodeMapId)]);
  WriteLn(pdf, '>>');
  EndObj(pdf);
end;

function TfrxAPDFExport.AddPage(Page: TfrxReportPage): TfrxPDFPage;
var
  p: TfrxPDFPage;
begin
  p := TfrxPDFPage.Create;
  p.Height := Page.Height * PDF_DIVIDER;
  FPages.Add(p);
  Result := p;
end;

function TfrxAPDFExport.AddXObject(Id: Integer; const Hash: TfrxPDFXObjectHash): Integer;
var
  X: TfrxPDFXObject;
begin
  X.ObjId := Id;
  Move(Hash, X.Hash, SizeOf(Hash));
  SetLength(FXObjects, Length(FXObjects) + 1);
  FXObjects[High(FXObjects)] := X;
  Result := High(FXObjects);
end;

function TfrxAPDFExport.StrToHex(const Value: WideString): AnsiString;
var
  i: integer;
begin
  result := '';
  for i := 1 to Length(Value) do
    result := result  + AnsiString(IntToHex(Word(Value[i]), 4));
end;

function TfrxAPDFExport.ObjNumber(FNumber: longint): String;
begin
  result := IntToStr(FNumber) + ' 0 obj';
end;

function TfrxAPDFExport.ObjNumberRef(FNumber: longint): String;
begin
  result := IntToStr(FNumber) + ' 0 R';
end;

function TfrxAPDFExport.PrepXrefPos(pos: Longint): String;
begin
  result := StringOfChar('0',  10 - Length(IntToStr(pos))) + IntToStr(pos)
end;

function TfrxAPDFExport.UpdateXRef: longint;
begin
  FXRef.Add(PrepXrefPos(pdf.Position));
  result := FXRef.Count;
end;

function TfrxAPDFExport.GetPDFColor(const Color: TColor): String;
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

procedure TfrxAPDFExport.GetStreamHash(out Hash: TfrxPDFXObjectHash; S: TStream);
var
  H: TCryptoHash;
begin
  H := TCryptoMD5.Create;

  try
    H.Push(S);
    H.GetDigest(Hash[0], SizeOf(Hash));
  finally
    H.Free
  end;
end;

procedure TfrxAPDFExport.AddObject(const Obj: TfrxView);
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
  FUnderlinePosition: Double;
  FStrikeoutPosition: Double;
  FRealBounds: TfrxRect;
  FLineHeight: Extended;
  FLineWidth: Extended;
  FHeightWoMargin: Extended;
  pdfFont: TfrxPDFFont;
  textObj: TfrxCustomMemoView;
  bx, by, bx1, by1, wx1, wx2, wy1, wy2, gx1, gy1: Integer;
  FTextRect: TRect;
  angle, a_sin, a_cos, a_x, a_y: Extended;
  rx, ry: Extended;
  XObjectId: Integer;
  XObjectHash: TfrxPDFXObjectHash;
  XObjectStream: TStream;
  PicIndex: Integer;

  function GetLeft(const Left: Extended): Extended;
  begin
    Result := FMarginLeft + Left * PDF_DIVIDER
  end;

  function GetTop(const Top: Extended): Extended;
  begin
    Result := FHeightWoMargin - Top * PDF_DIVIDER
  end;

  function GetVTextPos(const Top: Extended; const Height: Extended;
    const Align: TfrxVAlign; const Line: Integer = 0;
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
      Result := Top + FLineHeight * (i + 1);
  end;

  function GetVTextPosR(const Height: Extended;
    const Align: TfrxVAlign; const Line: Integer = 0;
    const Count: Integer = 1): Extended;
  var
    i: Integer;
  begin
    if Line <= Count then
      i := Line
    else
      i := 0;
    if Align = vaBottom then
      Result := Height - FLineHeight * (Count - i - 1)
    else if Align = vaCenter then
      Result := -FLineHeight * Count / 2 + FLineHeight * (i + 1)
    else
      Result := - Height + FLineHeight * (i + 1);
  end;

  function GetHTextPos(const Left: Extended; const Width: Extended; const Text: WideString;
    const Align: TfrxHAlign): Extended;
  var
    txt: TWideStrings;
  begin
{$IFDEF Delphi10}
    txt := TfrxWideStrings.Create;
{$ELSE}
    txt := TWideStrings.Create;
{$ENDIF}
    try
      txt.Add(Text);
      frxDrawText.SetText(txt);
      FLineWidth := frxDrawText.CalcWidth;
    finally
      txt.Free;
    end;

    case Align of
      haLeft:   Result := Left;
      haRight:  Result := Left + Width - FLineWidth;
      haCenter: Result := Left + (Width - FLineWidth) / 2;
      haBlock:  Result := Left;
      else      Result := Left;
    end;
  end;

  function GetHTextPosR(const Width: Extended; const Text: WideString;
    const Align: TfrxHAlign): Extended;
  var
    txt: TWideStrings;
  begin
    {$IFDEF Delphi10}
    txt := TfrxWideStrings.Create;
    {$ELSE}
    txt := TWideStrings.Create;
    {$ENDIF}

    try
      txt.Add(Text);
      frxDrawText.SetText(txt);
      FLineWidth := frxDrawText.CalcWidth;
    finally
      txt.Free;
    end;

    case Align of
      haRight:  Result := Width - FLineWidth;
      haCenter: Result := -FLineWidth / 2;
      else      Result := -Width;
    end;
  end;

  function GetPDFDash(const LineStyle: TfrxFrameStyle; Width: Extended): String;
  var
    dash, dot: String;
  begin
    if LineStyle = fsSolid then
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
      else
        Result := '[] 0 d';
    end;
  end;

  procedure MakeUpFrames;
  begin
    if (Obj.Frame.Typ <> []) and (Obj.Frame.Color <> clNone) then
    begin
      Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10);
      if ftTop in Obj.Frame.Typ then
      begin
        WriteLn(OutStream, GetPDFDash(Obj.Frame.TopLine.Style, Obj.Frame.TopLine.Width));
        Write(OutStream, frFloat2Str(Obj.Frame.TopLine.Width * PDF_DIVIDER) + ' w'#13#10);
        Write(OutStream, Left + ' ' + Top + ' m'#13#10 + Right + ' ' + Top + ' l'#13#10'S'#13#10);
      end;
      if ftRight in Obj.Frame.Typ then
      begin
        WriteLn(OutStream, GetPDFDash(Obj.Frame.RightLine.Style, Obj.Frame.RightLine.Width));
        Write(OutStream, frFloat2Str(Obj.Frame.RightLine.Width * PDF_DIVIDER) + ' w'#13#10);
        Write(OutStream, Right + ' ' + Top + ' m'#13#10 + Right + ' ' + Bottom + ' l'#13#10'S'#13#10);
      end;
      if ftBottom in Obj.Frame.Typ then
      begin
        WriteLn(OutStream, GetPDFDash(Obj.Frame.BottomLine.Style, Obj.Frame.BottomLine.Width));
        Write(OutStream, frFloat2Str(Obj.Frame.BottomLine.Width * PDF_DIVIDER) + ' w'#13#10);
        Write(OutStream, Left + ' ' + Bottom + ' m'#13#10 + Right + ' ' + Bottom + ' l'#13#10'S'#13#10);
      end;
      if ftLeft in Obj.Frame.Typ then
      begin
        WriteLn(OutStream, GetPDFDash(Obj.Frame.LeftLine.Style, Obj.Frame.LeftLine.Width));
        Write(OutStream, frFloat2Str(Obj.Frame.LeftLine.Width * PDF_DIVIDER) + ' w'#13#10);
        Write(OutStream, Left + ' ' + Top + ' m'#13#10 + Left + ' ' + Bottom + ' l'#13#10'S'#13#10);
      end;
    end;
  end;

  function HTMLTags(const View: TfrxCustomMemoView): Boolean;
  begin
    if View.AllowHTMLTags then
      Result := FTags and (Pos('<' ,View.Memo.Text) > 0)
    else
      Result := False;
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
    WriteLn(OutStream, GetPDFDash(Obj.Frame.Style, Obj.Frame.Width));
    WriteLn(OutStream, frFloat2Str(x3) + ' ' + frFloat2Str(y3) + ' m'#13#10 +
      frFloat2Str(x2) + ' ' + frFloat2Str(y2) + ' l'#13#10 +
      frFloat2Str(x4) + ' ' + frFloat2Str(y4) + ' l');
    if Obj.ArrowSolid then
      WriteLn(OutStream, '1 j'#13#10 + GetPDFColor(Obj.Frame.Color) + ' rg'#13#10'b')
    else
      WriteLn(OutStream, 'S');
  end;

  function GetGlobalFont(const Font: TFont): TfrxPDFFont;
  var
    i: Integer;
    Font2: TFont;
  begin
    for i := 0 to FFonts.Count - 1 do
    begin
      Font2 := TfrxPDFFont(FFonts[i]).SourceFont;
      if (Font.Name = Font2.Name) and (Font.Style = Font2.Style) then
        break;
    end;
    if i < FFonts.Count then
      result := TfrxPDFFont(FFonts[i])
    else
    begin
      result := TfrxPDFFont.Create(Font, FEmbedded);
      FFonts.Add(result);
      result.PDFName := AnsiString('/F' + IntToStr(FFonts.Count - 1));
    end;
  end;

  function GetObjFontNumber(const Font: TFont): integer;
  var
    i: Integer;
    Font2: TFont;
  begin
    for i := 0 to FPageFonts.Count - 1 do
    begin
      Font2 := TfrxPDFFont(FPageFonts[i]).SourceFont;
      if (Font.Name = Font2.Name) and (Font.Style = Font2.Style) then
        break;
    end;
    if i < FPageFonts.Count then
      result := i
    else
    begin
      FPageFonts.Add(GetGlobalFont(Font));
      result := FPageFonts.Count - 1;
    end;
  end;

  procedure Cmd(const Args: string; const Name: string = '');
  begin
    if Name = '' then
      WriteLn(OutStream, Args)
    else if Args = '' then
      WriteLn(OutStream, Name)
    else
      WriteLn(OutStream, Args + ' ' + Name);
  end;

  function CmdCoords(x, y: Extended): string;
  begin
    Result := frFloat2Str(GetLeft(x)) + ' ' + frFloat2Str(GetTop(y));
  end;

  procedure CmdMove(x, y: Extended);
  begin
    Cmd(CmdCoords(x, y), 'm');
  end;

  procedure CmdLine(x, y: Extended);
  begin
    Cmd(CmdCoords(x, y), 'l');
  end;

  procedure CmdBezier(x1, y1, x2, y2, x3, y3: Extended);
  begin
    Cmd(CmdCoords(x1, y1) + ' ' + CmdCoords(x2, y2) + ' ' +
      CmdCoords(x3, y3), 'c');
  end;

  { Rounded rectangle can be drawed
    using the following PDF commands:

      - m - start a new path
      - v - add a bezier curve
      - l - add a straight line
      - S - stroke the path
      - B - fill and stroke the path }

  procedure WriteRoundedRect(RoundedRect: TfrxShapeView);
  var
    rad, rf, l, t, r, b, w, h: Extended;
  begin
    with RoundedRect do
    begin
      with Frame do
      begin
        Cmd(GetPDFDash(Style, Width));
        Cmd(GetPDFColor(Color), 'RG');
        Cmd(frFloat2Str(Width * PDF_DIVIDER), 'w');
      end;

      if Curve = 0 then
        rad := 2 * 3.74
      else
        rad := Curve * 3.74;

      rf := 0.5 * rad;
      l := AbsLeft;
      t := AbsTop;
      w := Width;
      h := Height;
      r := l + w;
      b := t + h;

      Cmd(GetPDFColor(Color), 'rg');
      CmdMove(l + rad, b);
      CmdLine(r - rad, b);
      CmdBezier(r - rf, b, r, b - rf, r, b - rad);  // right-bottom
      CmdLine(r, t + rad);
      CmdBezier(r, t + rf, r - rf, t, r - rad, t);  // right-top
      CmdLine(l + rad, t);
      CmdBezier(l + rf, t, l, t + rf, l, t + rad);  // left-top
      CmdLine(l, b - rad);
      CmdBezier(l, b - rf, l + rf, b, l + rad, b);  // left-bottom

      if Color = clNone then
        Cmd('', 'S')
      else
        Cmd('', 'B');
    end;
  end;

  { An external link is a URL like http://company.com/index.html }

  procedure WriteExternalLink(const URI: string);
  var
    ObjId: Integer;
  begin
    ObjId := UpdateXRef;
    Writeln(FAnnots, ObjNumberRef(ObjId)); // for /Annots array in the page object

    Writeln(pdf, ObjNumber(ObjId));
    Writeln(pdf, '<<');
    Writeln(pdf, '/Subtype /Link');
    Writeln(pdf, '/Rect [' + Left + ' ' + Bottom + ' ' + Right + ' ' + Top + ']');
    Writeln(pdf, '/BS << /W 0 >>');
    Writeln(pdf, '/A <<');
    Writeln(pdf, '/URI ' + PdfString(WideString(URI)));
    Writeln(pdf, '/Type /Action');
    Writeln(pdf, '/S /URI');
    Writeln(pdf, '>>');
    Writeln(pdf, '>>');
    EndObj(pdf);
  end;

  { Writes an anchor to the PDF document. This kind
    of links make a jump to a specified location within
    the current document.

    Arguments:

      - Page  - an index of a page whither the anchor jumps
      - Pos   - a vertical position of the destination within the page }

  procedure WritePageAnchor(Page: Integer; Pos: Double);
  var
    s, r: string;
    i: Integer;
  begin
    i := UpdateXRef;
    r := Format('%d 0 R ', [i]);
    s := Format('%d 0 obj'#10'<</Type/Annot/Subtype/Link' +
      '/Rect[%s %s %s %s]/Border[16 16 0]/Dest[%d /XYZ null %f null]>>' +
      #10'endobj', [i, Left, Bottom, Right, Top, Page, GetTop(Pos)]);

    WriteLn(PDF, s);
    WriteLn(FAnnots, r);
  end;

  { Writes a link object to the PDF document }

  procedure WriteLink(a: string);
  var
    x: TfrxXMLItem;
  begin
    if a = '' then Exit;

    { Anchors.

      This kind of links make a jump to a specified
      location within the current document. Anchors
      begin with '#' sign. }

    if a[1] = '#' then
    begin
      a := Copy(a, 2, Length(a) - 1);
      x := (Report.PreviewPages as TfrxPreviewPages).FindAnchor(a);

      if x <> nil then
      try
        WritePageAnchor(StrToInt(x.Prop['page']), StrToFloat(x.Prop['top']));
      except
        // StrToInt will fail if a is not a properly formed number
      end
    end
    else

    { Page anchors.

      This kind of links make a jump to a
      specified page. }

    if a[1] = '@' then
    begin
      a := Copy(a, 2, Length(a) - 1);

      try
        WritePageAnchor(StrToInt(a) - 1, 0.0);
      except
        // StrToInt will fail if a is not a properly formed number
      end
    end
    else

    { External links.

      An external link is a URL like http://company.com/index.html. }

      WriteExternalLink(a)
  end;

begin
  {$IFDEF DEBUG}
  Writeln(OutStream, '');
  Writeln(OutStream, '%%------------ object %s : %s', [Obj.Name, Obj.ClassName]);
  Writeln(OutStream, '');
  {$ENDIF}

  FHeightWoMargin := FHeight - FMarginTop;
  Left := frFloat2Str(GetLeft(Obj.AbsLeft));
  Top := frFloat2Str(GetTop(Obj.AbsTop));
  Right := frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width));
  Bottom := frFloat2Str(GetTop(Obj.AbsTop + Obj.Height));
  Width := frFloat2Str(Obj.Width * PDF_DIVIDER);
  Height := frFloat2Str(Obj.Height * PDF_DIVIDER);

  OldFrameWidth := 0;
  WriteLink(Obj.URL);

  { Memo object will be written to a pdf file as text if
    the following conditions are satisfied. All other
    memo objects will be saved as pictures:

      - brush style is "solid" or "clear"
      - "wordwrap" option is disabled
      - clipping is disabled
      - html formatting is disabled }

  if (Obj is TfrxCustomMemoView)
     and (TfrxCustomMemoView(Obj).BrushStyle in [bsSolid, bsClear])
     and not HTMLTags(TfrxCustomMemoView(Obj)) then
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

    textObj := TfrxCustomMemoView(Obj);

    {$IFDEF PDF_LOG_TEXTS}
    DbgPrintln(Obj.Name + ': ' + string(PdfString(TextObj.Memo.Text)));
    {$ENDIF}

    frxDrawText.Lock;
    pdfCS.Enter;
    try
      if textObj.Highlight.Active and
         Assigned(textObj.Highlight.Font) then
      begin
        textObj.Font.Assign(textObj.Highlight.Font);
        textObj.Color := textObj.Highlight.Color;
      end;
      frxDrawText.SetFont(textObj.Font);

      frxDrawText.SetOptions(textObj.WordWrap, textObj.AllowHTMLTags,
        textObj.RTLReading, textObj.WordBreak, textObj.Clipped, textObj.Wysiwyg,
        textObj.Rotation);

      frxDrawText.SetGaps(textObj.ParagraphGap, textObj.CharSpacing, textObj.LineSpacing);

      wx1 := Round((textObj.Frame.Width - 1) / 2);
      wx2 := Round(textObj.Frame.Width / 2);
      wy1 := Round((textObj.Frame.Width - 1) / 2);
      wy2 := Round(textObj.Frame.Width / 2);

      bx := Round(textObj.AbsLeft);
      by := Round(textObj.AbsTop);
      bx1 := Round(textObj.AbsLeft + textObj.Width);
      by1 := Round(textObj.AbsTop + textObj.Height);
      if ftLeft in textObj.Frame.Typ then
        Inc(bx, wx1);
      if ftRight in textObj.Frame.Typ then
        Dec(bx1, wx2);
      if ftTop in textObj.Frame.Typ then
        Inc(by, wy1);
      if ftBottom in textObj.Frame.Typ then
        Dec(by1, wy2);
      gx1 := Round(textObj.GapX);
      gy1 := Round(textObj.GapY);

      FTextRect := Rect(bx + gx1, by + gy1, bx1 - gx1 + 1, by1 - gy1 + 1);
      frxDrawText.SetDimensions(1, 1, 1, FTextRect, FTextRect);
      frxDrawText.SetText(textObj.Memo);
      FLineHeight := frxDrawText.LineHeight;

      if textObj.Color <> clNone then
        Write(OutStream, GetPDFColor(textObj.Color) + ' rg'#13#10 + Left + ' ' + Bottom + ' ' +
          Width + ' ' + Height + ' re'#13#10'f'#13#10);
      // Frames
      MakeUpFrames;

      if TextObj.Rotation > 0 then
      begin
        Angle := TextObj.Rotation * Pi / 180;
        a_sin := Sin(Angle);
        a_cos := Cos(Angle);

        case TextObj.Rotation of
          90, 180, 270:
            begin
              a_x := GetLeft(TextObj.AbsLeft + TextObj.Width/2);
              a_y := GetTop(TextObj.AbsTop + TextObj.Height/2);
            end
          else
            begin
              case TextObj.Rotation of
                45..135, 225..315:
                  begin
                    rx := TextObj.Height;
                    ry := TextObj.Width;
                  end
                else
                  begin
                    rx := TextObj.Width;
                    ry := TextObj.Height;
                  end
              end;

              a_x := GetLeft(TextObj.AbsLeft + 0.5 * (rx * a_cos + ry * a_sin));
              a_y := GetTop(TextObj.AbsTop + 0.5 * (rx * a_sin + ry * a_cos));
            end
        end;

        WriteLn(OutStream, frFloat2Str(a_cos) + ' ' + frFloat2Str(a_sin) + ' ' +
          frFloat2Str(-a_sin) + ' ' + frFloat2Str(a_cos) + ' ' +
          frFloat2Str(a_x) + ' ' + frFloat2Str(a_y) + ' cm');
      end;

      if textObj.Underlines then
      begin
        iz := Trunc(textObj.Height / FLineHeight);
        for i:= 0 to iz - 1 do
        begin
          y := GetTop(textObj.AbsTop + textObj.GapY + 1 + FLineHeight * (i + 1));
          Write(OutStream, GetPDFColor(textObj.Frame.Color) + ' RG'#13#10 +
            frFloat2Str(textObj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
            Left + ' ' + frFloat2Str(y) + ' m'#13#10 +
            Right + ' ' + frFloat2Str(y) + ' l'#13#10'S'#13#10);
        end;
      end;

{$IFDEF Delphi10}
      Lines := TfrxWideStrings.Create;
{$ELSE}
      Lines := TWideStrings.Create;
{$ENDIF}
      Lines.Text := frxDrawText.WrappedText;
      if Lines.Count > 0 then
      begin
        FontIndex := GetObjFontNumber(textObj.Font);
        pdfFont := TfrxPDFFont(FPageFonts[FontIndex]);
{$IFDEF Delphi12}
        Write(OutStream, TfrxPDFFont(FFonts[FontIndex]).PDFName +
          AnsiString(' ' + IntToStr(textObj.Font.Size) + ' Tf'#13#10));
{$ELSE}
        Write(OutStream, TfrxPDFFont(FFonts[FontIndex]).Name +
          ' ' + IntToStr(textObj.Font.Size) + ' Tf'#13#10);
{$ENDIF}
        if textObj.Font.Color <> clNone then
          TempColor := textObj.Font.Color
        else
          TempColor := clBlack;
        Write(OutStream, GetPDFColor(TempColor) + ' rg'#13#10);
        FCharSpacing := textObj.CharSpacing * PDF_DIVIDER;
        if FCharSpacing <> 0 then
          Write(OutStream, frFloat2Str(FCharSpacing) + ' Tc'#13#10);

        // output lines of memo
        FUnderlinePosition := textObj.Font.Size * 0.12;
        FStrikeoutPosition := textObj.Font.Size * 0.28;
        frxDrawText.SetGaps(0, TfrxCustomMemoView(Obj).CharSpacing, TfrxCustomMemoView(Obj).LineSpacing);

        for i := 0 to Lines.Count - 1 do
        begin
          if i = 0 then
            PGap := textObj.ParagraphGap
          else
            PGap := 0;

          if Length(Lines[i]) > 0 then
          begin
            // Text output
            if textObj.HAlign <> haRight then
              FCharSpacing := 0;

            if textObj.Rotation > 0 then
            begin
              if ((textObj.Rotation >= 45) and (textObj.Rotation <= 135)) or
                ((textObj.Rotation >= 225 ) and (textObj.Rotation <= 315)) then
              begin
                rx := oh;
                ry := ow;
              end
              else
              begin
                rx := ow;
                ry := oh;
              end;
              x := FCharSpacing + (GetHTextPosR(rx / 2, Lines[i], textObj.HAlign)) * PDF_DIVIDER;
              y := -(GetVTextPosR(ry / 2, textObj.VAlign, i, Lines.Count)) * PDF_DIVIDER + textObj.Font.Size * 0.4;
            end
            else
            begin
              x := FCharSpacing + GetLeft(GetHTextPos(textObj.AbsLeft + textObj.GapX + textObj.Font.Size * 0.01 +
                textObj.GapX / 2 + PGap, ow - textObj.GapX * 2 - PGap, Lines[i], textObj.HAlign));
              y := GetTop(GetVTextPos(textObj.AbsTop + textObj.GapY - textObj.Font.Size * 0.1,
                oh - textObj.GapY * 2, textObj.VAlign, i, Lines.Count));
            end;

            Write(OutStream, 'BT'#13#10);
            Write(OutStream, frFloat2Str(x) + ' ' + frFloat2Str(y) + ' Td'#13#10);
            Write(OutStream, '<' + StrToHex(pdfFont.RemapString(Lines[i], textObj.RTLReading)) + '> Tj'#13#10'ET'#13#10);

            { underlined text }

            with textObj do
              if fsUnderline in Font.Style then
              begin
                Cmd(GetPDFColor(Font.Color), 'RG');
                Cmd(frFloat2Str(Font.Size * 0.08), 'w');
                Cmd(frFloat2Str(x) + ' ' + frFloat2Str(y - FUnderlinePosition), 'm');
                Cmd(frFloat2Str(x + FLineWidth * PDF_DIVIDER) + ' ' +
                  frFloat2Str(y - FUnderlinePosition), 'l');

                Cmd('', 'S');
              end;

            { struck out text }

            if fsStrikeout in (textObj.Font.Style) then
              Write(OutStream, GetPDFColor(textObj.Font.Color) + ' RG'#13#10 +
                frFloat2Str(textObj.Font.Size * 0.08) + ' w'#13#10 +
                frFloat2Str(x) + ' ' + frFloat2Str(y + FStrikeoutPosition) + ' m'#13#10 +
                frFloat2Str(x +  FLineWidth * PDF_DIVIDER) +
                ' ' + frFloat2Str(y + FStrikeoutPosition) + ' l'#13#10'S'#13#10);
          end;
        end;
      end;
    finally
      frxDrawText.Unlock;
      pdfCS.Leave;
    end;
    // restore clip
    Write(OutStream, 'Q'#13#10);
    Lines.Free;
  end
  // Lines
  else if Obj is TfrxCustomLineView then
  begin
    WriteLn(OutStream, GetPDFDash(Obj.Frame.Style, Obj.Frame.Width));
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
    WriteLn(OutStream, GetPDFDash(Obj.Frame.Style, Obj.Frame.Width));
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

  { Rounded rectangle }

  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skRoundRectangle) then
    WriteRoundedRect(TfrxShapeView(Obj))

  // Shape line 1
  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skDiagonal1) then
  begin
    WriteLn(OutStream, GetPDFDash(Obj.Frame.Style, Obj.Frame.Width));
    Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      Left + ' ' + Bottom + ' m'#13#10 + Right + ' ' + Top + ' l'#13#10'S'#13#10)
  end
  // Shape line 2
  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skDiagonal2) then
  begin
    WriteLn(OutStream, GetPDFDash(Obj.Frame.Style, Obj.Frame.Width));
    Write(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      Left + ' ' + Top + ' m'#13#10 + Right + ' ' + Bottom + ' l'#13#10'S'#13#10)
  end
  // Shape diamond
  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skDiamond) then
  begin
    WriteLn(OutStream, GetPDFDash(Obj.Frame.Style, Obj.Frame.Width));
    WriteLn(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      GetPDFColor(Obj.Color) + ' rg');
    WriteLn(OutStream, frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width / 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop)) + ' m ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + Obj.Height / 2)) + ' l ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width / 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + Obj.Height)) + ' l ' +
      frFloat2Str(GetLeft(Obj.AbsLeft)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + Obj.Height / 2)) + ' l ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width / 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop)) + ' l');
    if Obj.Color <> clNone then
      Write(OutStream, 'B'#13#10)
    else
      Write(OutStream, 'S'#13#10);
  end
  // Shape triangle
  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skTriangle) then
  begin
    WriteLn(OutStream, GetPDFDash(Obj.Frame.Style, Obj.Frame.Width));
    WriteLn(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      GetPDFColor(Obj.Color) + ' rg');
    WriteLn(OutStream, frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width / 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop)) + ' m ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + Obj.Height)) + ' l ' +
      frFloat2Str(GetLeft(Obj.AbsLeft)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + Obj.Height)) + ' l ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + Obj.Width / 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop)) + ' l');
    if Obj.Color <> clNone then
      Write(OutStream, 'B'#13#10)
    else
      Write(OutStream, 'S'#13#10);
  end
  // Shape ellipse
  else if (Obj is TfrxShapeView) and (TfrxShapeView(Obj).Shape = skEllipse) then
  begin
    WriteLn(OutStream, GetPDFDash(Obj.Frame.Style, Obj.Frame.Width));
    WriteLn(OutStream, GetPDFColor(Obj.Frame.Color) + ' RG'#13#10 +
      frFloat2Str(Obj.Frame.Width * PDF_DIVIDER) + ' w'#13#10 +
      GetPDFColor(Obj.Color) + ' rg');
    rx := Obj.Width / 2;
    ry := Obj.Height / 2;
    WriteLn(OutStream, frFloat2Str(GetLeft(Obj.AbsLeft + rx * 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry)) + ' m');
    WriteLn(OutStream,
      frFloat2Str(GetLeft(Obj.AbsLeft + rx * 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry * KAPPA1)) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + rx * KAPPA1)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry * 2)) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + rx)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry * 2)) + ' c');
    WriteLn(OutStream,
      frFloat2Str(GetLeft(Obj.AbsLeft + rx * KAPPA2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry * 2)) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry * KAPPA1)) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry)) + ' c');
    WriteLn(OutStream,
      frFloat2Str(GetLeft(Obj.AbsLeft)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry * KAPPA2)) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + rx * KAPPA2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop)) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + rx)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop)) + ' c');
    WriteLn(OutStream,
      frFloat2Str(GetLeft(Obj.AbsLeft + rx * KAPPA1)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop)) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + rx * 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry * KAPPA2)) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft + rx * 2)) + ' ' + frFloat2Str(GetTop(Obj.AbsTop + ry)) + ' c');
    if Obj.Color <> clNone then
      Write(OutStream, 'B'#13#10)
    else
      Write(OutStream, 'S'#13#10);
  end
  else
  // Bitmaps
  if not ((Obj.Name = '_pagebackground') and (not Background)) and
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

    try
      TempBitmap.PixelFormat := pf24bit;

      if (PrintOptimized or (Obj is TfrxCustomMemoView)) and (Obj.BrushStyle in [bsSolid, bsClear]) then
        i := PDF_PRINTOPT
      else
        i := 1;

      iz := 0;

      if (Obj.ClassName = 'TfrxBarCodeView') and not PrintOptimized then
      begin
        i := 2;
        iz := i;
      end;

      TempBitmap.Width := Round(dx * i) + i;
      TempBitmap.Height := Round(dy * i) + i;

      try
        Obj.Draw(TempBitmap.Canvas, i, i, -Round((Obj.AbsLeft - fdx) * i) + iz, -Round((Obj.AbsTop - fdy)* i));
      except
        // charts throw exceptions when numbers are malformed
      end;

      { Write XObject with a picture inside }

      Jpg := TJPEGImage.Create;

      try
        if (Obj.ClassName = 'TfrxBarCodeView') or
           (Obj is TfrxCustomLineView) or
           (Obj is TfrxShapeView) then
        begin
          Jpg.PixelFormat := jf8Bit;
          Jpg.CompressionQuality := 95;
        end
        else
        begin
          Jpg.PixelFormat := jf24Bit;
          Jpg.CompressionQuality := 90;
        end;

        Jpg.Assign(TempBitmap);
        XObjectStream := TMemoryStream.Create;

        try
          Jpg.SaveToStream(XObjectStream);
          GetStreamHash(XObjectHash, XObjectStream);
          PicIndex := FindXObject(XObjectHash);

          if PicIndex < 0 then
          begin
            XObjectId := UpdateXRef;
            PicIndex := AddXObject(XObjectId, XObjectHash);

            Writeln(pdf, ObjNumber(XObjectId));
            Writeln(pdf, '<<');
            Writeln(pdf, '/Type /XObject');
            Writeln(pdf, '/Subtype /Image');
            Writeln(pdf, '/ColorSpace /DeviceRGB');
            Writeln(pdf, '/BitsPerComponent 8');
            Writeln(pdf, '/Filter /DCTDecode');
            Writeln(pdf, '/Width ' + IntToStr(Jpg.Width));
            Writeln(pdf, '/Height ' + IntToStr(Jpg.Height));
            Writeln(pdf, '/Length ' + IntToStr(XObjectStream.Size));
            Writeln(pdf, '>>');

            BeginStream(pdf);
            pdf.CopyFrom(XObjectStream, 0);
            EndStream(pdf);

            Inc(FPicTotalSize, XObjectStream.Size);

            EndObj(pdf);
          end;
        finally
          XObjectStream.Free
        end;
      finally
        Jpg.Free;
      end;
    finally
      TempBitmap.Free;
    end;

    { Reference to this XObject }

    SetLength(FUsedXObjects, Length(FUsedXObjects) + 1);
    FUsedXObjects[High(FUsedXObjects)] := PicIndex;

    Writeln(OutStream, 'q');
    Writeln(OutStream,
      frFloat2Str(dx * PDF_DIVIDER) + ' ' +
      '0 ' +
      '0 ' +
      frFloat2Str(dy * PDF_DIVIDER) + ' ' +
      frFloat2Str(GetLeft(Obj.AbsLeft - fdx)) + ' ' +
      frFloat2Str(GetTop(Obj.AbsTop - fdy + dy)) + ' ' +
      'cm');
    Writeln(OutStream, '/Im' + IntToStr(PicIndex) + ' Do');
    Writeln(OUtStream, 'Q');

    if OldFrameWidth > 0 then
      Obj.Frame.Width := OldFrameWidth;

    MakeUpFrames;
  end;
end;

{ TfrxAPDFExportDialog }

procedure TfrxAPDFExportDialog.FormCreate(Sender: TObject);
begin
  Caption := frxGet(8700);
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  GroupPageRange.Caption := frxGet(7);
  AllRB.Caption := frxGet(3);
  CurPageRB.Caption := frxGet(4);
  PageNumbersRB.Caption := frxGet(5);
  DescrL.Caption := frxGet(9);
  GroupQuality.Caption := frxGet(8);
  CompressedCB.Caption := frxGet(8701);
  EmbeddedCB.Caption := frxGet(8702);
  PrintOptCB.Caption := frxGet(8703);
  OutlineCB.Caption := frxGet(8704);
  BackgrCB.Caption := frxGet(8705);
  OpenCB.Caption := frxGet(8706);
  SaveDialog1.Filter := frxGet(8707);
  SaveDialog1.DefaultExt := frxGet(8708);

  ExportPage.Caption := frxGet(107);
  DocInfoGB.Caption := frxGet(8971);
  InfoPage.Caption := frxGet(8972);
  TitleL.Caption := frxGet(8973);
  AuthorL.Caption := frxGet(8974);
  SubjectL.Caption := frxGet(8975);
  KeywordsL.Caption := frxGet(8976);
  CreatorL.Caption := frxGet(8977);
  ProducerL.Caption := frxGet(8978);

  SecurityPage.Caption := frxGet(8962);
  SecGB.Caption := frxGet(8979);
  PermGB.Caption := frxGet(8980);
  OwnPassL.Caption := frxGet(8964);
  UserPassL.Caption := frxGet(8965);
  PrintCB.Caption := frxGet(8966);
  ModCB.Caption := frxGet(8967);
  CopyCB.Caption := frxGet(8968);
  AnnotCB.Caption := frxGet(8969);

  ViewerPage.Caption := frxGet(8981);
  ViewerGB.Caption := frxGet(8982);
  HideToolbarCB.Caption := frxGet(8983);
  HideMenubarCB.Caption := frxGet(8984);
  HideWindowUICB.Caption := frxGet(8985);
  FitWindowCB.Caption := frxGet(8986);
  CenterWindowCB.Caption := frxGet(8987);
  PrintScalingCB.Caption := frxGet(8988);

  if UseRightToLeftAlignment then
    FlipChildren(True);
end;

procedure TfrxAPDFExportDialog.PageNumbersEChange(Sender: TObject);
begin
  PageNumbersRB.Checked := True;
end;

procedure TfrxAPDFExportDialog.PageNumbersEKeyPress(Sender: TObject;
  var Key: Char);
begin
  case key of
    '0'..'9':;
    #8, '-', ',':;
  else
    key := #0;
  end;
end;

procedure TfrxAPDFExportDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

{ TfrxPDFFontView }

constructor TfrxPDFFontView.Create;
begin
  FData := TMemoryStream.Create
end;

destructor TfrxPDFFontView.Destroy;
begin
  FView.Free;
  FData.Free;
end;

procedure TfrxPDFFontView.CreateView;
begin
  FView.Free;
  FView := OpenFont(FData);
  FCollection := FView is TFontCollectionView;
end;

procedure TfrxPDFFontView.Load(Handle: HFont);
const
  ttcf = $66637474;
var
  DC: HDC;
  Tag: Cardinal;
begin
  DC := CreateDC('DISPLAY', nil, nil, nil);

  try
    SelectObject(DC, Handle);

    if GetFontData(DC, ttcf, 0, nil, 0) = GDI_ERROR { -1 } then
      Tag := 0
    else
      Tag := ttcf;

    FData.Size := GetFontData(DC, Tag, 0, nil, 0);
    GetFontData(DC, Tag, 0, FData.Memory, FData.Size);
  finally
    DeleteDC(DC);
  end;

  CreateView;
end;

procedure TfrxPDFFontView.Load(Src: TStream);
begin
  FData.Size := 0;
  FData.LoadFromStream(Src);
  CreateView;
end;

function TfrxPDFFontView.GetFontsCount: Integer;
begin
  if FCollection then
    Result := TFontCollectionView(FView).FontsCount
  else
    Result := 1
end;

function TfrxPDFFontView.GetFont(Index: Integer): TFontView;
begin
  if FCollection then
    Result := TFontCollectionView(FView).Font[Index]
  else
    Result := TFontView(FView)
end;

function TfrxPDFFontView.GetFont(Name: string): TFontView;
begin
  if FCollection then
    Result := FindFont(Name)
  else if TFontView(FView).FamilyName = AnsiString(Name) then
    Result := TFontView(FView)
  else
    Result := nil
end;

function TfrxPDFFontView.FindFont(Name: string): TFontView;
var
  i: Integer;
begin
  for i := 0 to GetFontsCount - 1 do
    if GetFont(i).FamilyName = AnsiString(Name) then
    begin
      Result := GetFont(i);
      Exit;
    end;

  Result := nil;
end;

{ TfrxPDFFont }

constructor TfrxPDFFont.Create(Font: TFont; EmbedSubset: Boolean);
begin
  FView := TfrxPDFFontView.Create;
  FUsedChars := TBitArray.Create;
  FSourceFont := TFont.Create;
  FSourceFont.Assign(Font);
  FEmbedSubset := EmbedSubset;
end;

destructor TfrxPDFFont.Destroy;
begin
  FView.Free;
  FUsedGlyphs.Free;
  FUsedChars.Free;
  FSourceFont.Free;
  inherited;
end;

procedure TfrxPDFFont.CreateMapping;
var
  i, j, n: Integer;
begin
  Assert(IsBuilt);

  n := FUsedChars.GetNumOfSetBits;

  SetLength(FChars, n);
  SetLength(FGlyphs, n);

  j := 0;

  for i := 0 to FUsedChars.Length - 1 do
    if FUsedChars[i] then
    begin
      FChars[j] := i;
      FGlyphs[j] := FFontView.GetGlyphIndex(i);
      Inc(j);
    end;
end;

procedure TfrxPDFFont.LoadFontInfo;
begin
  Assert(IsBuilt);

  with FFontView do
  begin
    with HeadTable.Header do
    begin
      FFontInfo.FontBox := FontBox;
      FFontInfo.Flags   := Flags;
    end;

    with HMetricsInfoTable.Header do
    begin
      FFontInfo.Ascent    := Ascent;
      FFontInfo.Descent   := Descent;
      FFontInfo.Leading   := LineGap;
      FFontInfo.MaxWidth  := MaxWidth;
    end;
  end;
end;

procedure TfrxPDFFont.MarkAllCharsAsUsed(const s: WideString);
var
  i: Integer;
begin
  for i := 1 to Length(s) do
    MarkCharAsUsed(Word(s[i]))
end;

procedure TfrxPDFFont.MarkCharAsUsed(Char: Word);
begin
  Assert(not IsBuilt, 'Font is already built. New chars cannot be added to it.');

  if FUsedChars.Length <= Char then
    FUsedChars.Length := Char + 1;

  FUsedChars[Char] := True;
end;

function TfrxPDFFont.GetFontFile: TStream;
begin
  Assert(IsBuilt);
  Result := FFontView.Stream;
end;

procedure TfrxPDFFont.BuildFont;

  {$IFDEF DBGLOG}
  procedure PrintIndices(Title: string; b: TBitArray);
  var
    i, j: Integer;
  begin
    DbgPrint('%s (%d):', [Title, b.GetNumOfSetBits]);
    j := -1;

    for i := 0 to b.Length - 1 do
      if b[i] then
        if j < 0 then // new range is begun
        begin
          DbgPrint(' ' + IntToStr(i));
          j := i;
        end
        else // range is continued
          { do nothing }
      else
        if j >= 0 then // range is breaked
        begin
          if i > j + 1 then // long range is breaked
            DbgPrint('-' + IntToStr(i - 1))
          else // short range is breaked
            { do nothing };

          j := -1;
        end;

    DbgPrintln;
  end;

  procedure ProcessFont(Font: TStream; FontName: string);
  var
    Name, Path, Log: string;
  begin
    Name := string(SHA1(Font, 6));
    Path := 'fonts\' + Name + '.ttf';
    Log  := 'fonts\' + Name + '.log';

    with TFileStream.Create(Path, fmCreate) do
    try
      CopyFrom(Font, 0)
    finally
      Free
    end;

    DbgPrint('font %s (%s) saved to %s'#10, [Name, FontName, Path]);
    PrintFontInfo(Font, Log);
  end;
  {$ENDIF}

  function SelectFontView: TFontView;
  begin
    Result := FView.GetFont(SourceFont.Name);

    if Result = nil then
      Result := FView.GetFont(0)
  end;

  procedure EmbedFontSubset;
  var
    Builder: TFontBuilder;
    FontData: TMemoryStream;
  begin
    Builder := PackFont(FFontView, FUsedChars) as TFontBuilder;
    Assert(Builder <> nil);

    try
      FontData := TMemoryStream.Create;

      try
        Builder.SaveToStream(FontData);
        FView.Load(FontData);
      finally
        FontData.Free;
      end;

      FUsedGlyphs := Builder.GetUsedGlyphs;
    finally
      Builder.Free;
    end;

    FFontView := SelectFontView;

    {$IFDEF DBGLOG}
    PrintIndices('chars', FUsedChars);
    PrintIndices('glyphs', FUsedGlyphs);
    {$ENDIF}
  end;

begin
  if IsBuilt then
    Exit;

  {$IFDEF DBGLOG}
  if not DirectoryExists('fonts') then
    CreateDir('fonts');
  {$ENDIF}

  FView.Load(SourceFont.Handle);
  FFontView := SelectFontView;

  {$IFDEF DBGLOG}
  ProcessFont(FView.FData, SourceFont.Name);
  {$ENDIF}

  if FEmbedSubset then
    EmbedFontSubset;

  FFontView.SelectMapping(3, 1); // Unicode BMP (UCS-2)
  LoadFontInfo;
end;

function TfrxPDFFont.GetFontInfo: TfrxPDFFontInfo;
begin
  Assert(IsBuilt);
  Result := FFontInfo;
end;

function TfrxPDFFont.RemapString(str: WideString; rtl: Boolean): WideString;
begin
  MarkAllCharsAsUsed(Str);
  Result := Str;
end;

function TfrxPDFFont.GetFontName: AnsiString;

  function Encode(const s: AnsiString): AnsiString;
  var
    i: Integer;
  begin
    Result := '';

    for i := 1 to Length(s) do
      if Ord(s[i]) in [32..126] then
      begin
        if GetCharClass(s[i]) = ccRegular then
          Result := Result + s[i]
        else
          Result := Result + '#20';
      end;
  end;

begin
  Assert(IsBuilt);

  if FFontName = '' then
  begin
    FFontName := FFontView.FamilyName;

    if FEmbedSubset then
      FFontName := GetSubsetTag + '+' + FFontName;

    with SourceFont do
    begin
      if fsBold in Style then
        FFontName := FFontName + ',Bold';

      if fsItalic in Style then
        FFontName := FFontName + ',Italic';
    end;

    FFontName := Encode(FFontName);
  end;

  Result := FFontName;
end;

{ Font subset tag is arbitrary 6 uppercase letters.
  This function constructs the tag from the SHA1 of the font. }

function TfrxPDFFont.GetSubsetTag: AnsiString;
var
  h: TCryptoSHA1;
  d: array of Byte;
  i: Integer;
begin
  Assert(IsBuilt);

  if FSubsetTag = '' then
  begin
    h := TCryptoSHA1.Create;

    try
      h.Push(FontFile);
      SetLength(d, h.DigestSize);
      h.GetDigest(d[0], Length(d));
    finally
      h.Free;
    end;

    SetLength(FSubsetTag, 6);

    for i := 1 to 6 do
      FSubsetTag[i] := AnsiChar(Ord('A') + d[i] mod (Ord('Z') - Ord('A') + 1));
  end;

  Result := FSubsetTag;
end;

function TfrxPDFFont.IsBuilt: Boolean;
begin
  Result := FFontView <> nil
end;

function TfrxPDFFont.GetCMapName: string;
begin
  Result := 'CMap' + string(GetSubsetTag)
end;

function TfrxPDFFont.GetCMapRegistry: string;
begin
  Result := 'Adobe'
end;

function TfrxPDFFont.GetCMapOrdering: string;
begin
  Result := 'Identity'
end;

function TfrxPDFFont.GetCMapSupplement: Integer;
begin
  Result := 0
end;

function TfrxPDFFont.GetCMapType: Integer;
begin
  Result := 1
end;

procedure TfrxPDFFont.WriteCharToCIDMap(Stream: TStream);

  function GetCMapVersion: string;
  begin
    Result := '1'
  end;

  procedure WriteComment(const s: AnsiString); overload;
  begin
    Write(Stream, '%%');
    Writeln(Stream, s);
  end;

  procedure WriteComment(const Fmt: string; const Args: array of const); overload;
  begin
    WriteComment(AnsiString(Format(Fmt, Args)))
  end;

  procedure WriteHeader;
  begin
    Writeln(Stream, '%!PS-Adobe-3.0 Resource-CMap');

    WriteComment('DocumentNeededResources: ProcSet (CIDInit)');
    WriteComment('IncludeResource: ProcSet (CIDInit)');
    WriteComment('BeginResource: CMap (%s)', [GetCMapName]);
    WriteComment('Title: (%s %s %s %d)',
      [GetCMapName, GetCMapRegistry, GetCMapOrdering, GetCMapSupplement]);

    WriteComment('Version: %s', [GetCMapVersion]);
    WriteComment('EndComments');

    Writeln(Stream, '');
  end;

  procedure WriteFooter;
  begin
    WriteComment('EndResource');
    WriteComment('EOF');
  end;

  procedure WriteCIDSystemInfo;
  begin
    Writeln(Stream, '3 dict dup begin');
    Writeln(Stream, '/Registry (%s) def', [GetCMapRegistry]);
    Writeln(Stream, '/Ordering (%s) def', [GetCMapOrdering]);
    Writeln(Stream, '/Supplement %d def', [GetCMapSupplement]);
    Writeln(Stream, 'end def');
  end;

  procedure WriteCodespace;
  begin
    Writeln(Stream, '1 begincodespacerange');
    Writeln(Stream, '<0000> <FFFF>');
    Writeln(Stream, 'endcodespacerange');
  end;

  procedure WriteMapping(First, Count: Integer);
  const
    MaxCount = 100; // defined by the CMap standard
  var
    i: Integer;
  begin
    if Count > MaxCount then
    begin
      while Count > 0 do
      begin
        WriteMapping(First, Min(Count, MaxCount));
        Inc(First, MaxCount);
        Dec(Count, MaxCount);
      end;

      Exit;
    end;

    Assert(Count <= MaxCount);

    Writeln(Stream, '%d begincidchar', [Count]);

    for i := First to First + Count - 1 do
      Writeln(Stream, '<%X> %d', [FChars[i], FGlyphs[i]]);

    Writeln(Stream, 'endcidchar');
  end;

begin
  CreateMapping;

  WriteHeader;

  Writeln(Stream, '/CIDInit /ProcSet findresource begin');
  Writeln(Stream, '12 dict begin');
  Writeln(Stream, 'begincmap');

  WriteCIDSystemInfo;

  Writeln(Stream, '/CMapName /%s', [GetCMapName]);
  Writeln(Stream, '/CMapVersion %s def', [GetCMapVersion]);
  Writeln(Stream, '/CMapType %d def', [GetCMapType]);
  Writeln(Stream, '/UIDOffset 0 def');
  Writeln(Stream, '/XUID [0 0 0] def');
  Writeln(Stream, '/WMode 0 def');

  WriteCodespace;
  WriteMapping(0, Length(FChars));

  Writeln(Stream, 'endcmap');
  Writeln(Stream, 'CMapName currentdict /CMap defineresource pop');
  Writeln(Stream, 'end');
  Writeln(Stream, 'end');

  WriteFooter;
end;

procedure TfrxPDFFont.WriteCharToUnicodeMap(Stream: TStream);

  procedure WriteCodespace;
  begin
    Writeln(Stream, '1 begincodespacerange');
    Writeln(Stream, '<0000> <FFFF>');
    Writeln(Stream, 'endcodespacerange');
  end;

  procedure WriteMapping;
  begin
    Writeln(Stream, '1 beginbfrange');
    Writeln(Stream, '<0000> <FFFF> <0000>');
    Writeln(Stream, 'endbfrange');
  end;

begin
  Writeln(Stream, '/CIDInit /ProcSet findresource begin');
  Writeln(Stream, '12 dict begin');
  Writeln(Stream, 'begincmap');
  Writeln(Stream, '/CIDSystemInfo << /Registry (%s) /Ordering (%s) /Supplement %d >> def',
    [GetCMapRegistry, GetCMapOrdering, GetCMapSupplement]);
  Writeln(Stream, '/CMapName /%s def', [GetCMapName]);
  Writeln(Stream, '/CMapType %d def', [GetCMapType]);

  WriteCodespace;
  WriteMapping;

  Writeln(Stream, 'endcmap');
  Writeln(Stream, 'CMapName currentdict /CMap defineresource pop');
  Writeln(Stream, 'end');
  Writeln(Stream, 'end');
end;

procedure TfrxPDFFont.WriteCharWidths(Stream: TStream);

  function GetWidth(g: TGlyphIndex): Extended;
  var
    AW, UPEM: Integer;
  begin
    AW := FFontView.GlyphMetrics[g].AdvWidth; // glyph width in font units
    UPEM := FFontView.HeadTable.Header.UnitsPerEm; // font units per em
    Result := 1000 * AW / UPEM;
  end;

var
  i, g: Integer;
begin
  Assert(IsBuilt);
  Write(Stream, '[ ');

  for i := 0 to FUsedChars.Length - 1 do
    if FUsedChars[i] then
    begin
      g := FFontView.GetGlyphIndex(i);
      Write(Stream, IntToStr(i) + ' [' + FormatFloat('00', GetWidth(g)) + '] ');
    end;

  Write(Stream, ']');
end;

procedure TfrxPDFFont.WriteCIDSet(Stream: TStream);
type
  TSBox = array[0..255] of Byte;

  function SwapBits(b: Byte): Byte;
  var
    i: Integer;
    r: Byte;
  begin
    r := 0;

    for i := 0 to 7 do
    begin
      r := r shl 1;
      r := r xor (b and 1);
      b := b shr 1;
    end;

    Result := r;
  end;

  procedure InitSBox(var SBox: TSBox);
  var
    i: Integer;
  begin
    for i := 0 to 255 do
      SBox[i] := SwapBits(i)
  end;

var
  Temp: TMemoryStream;
  b: Byte;
  SBox: TSBox;
begin
  Assert(IsBuilt);

  InitSBox(SBox);
  Temp := TMemoryStream.Create;

  try
    FUsedChars.SaveToStream(Temp);

    with Temp do
    begin
      Position := 0;

      while Read(b, 1) = 1 do
      begin
        b := SBox[b];
        Stream.WriteBuffer(b, 1);
      end;
    end;
  finally
    Temp.Free;
  end;
end;

procedure TfrxPDFFont.WriteCIDToGIDMap(Stream: TStream);
var
  c, g: Word;
begin
  Assert(IsBuilt);

  for c := 0 to FUsedChars.Length - 1 do
  begin
    if FUsedChars[c] then
      g := FFontView.GetGlyphIndex(c)
    else
      g := 0;

    g := (g and $ff shl 8) or (g shr 8); // swap bytes
    Stream.WriteBuffer(g, 2);
  end;
end;

initialization
  pdfCS := TCriticalSection.Create;

finalization
  pdfCS.Free;

end.
