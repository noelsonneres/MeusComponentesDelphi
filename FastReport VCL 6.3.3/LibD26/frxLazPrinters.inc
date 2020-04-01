uses
  SysUtils, Classes, Graphics, Forms, Printers, OSPrinters,
  LCLType, LazHelper, LCLIntf, LCLProc, Variants, PrintersDlgs;

  type
  TfrxPrinterCanvas = class;

  TfrxCustomPrinter = class(TObject)
  private
    FBin: Integer;
    FDuplex: Integer;
    FBins: TStrings;
    FCanvas: TfrxPrinterCanvas;
    FDefOrientation: TPrinterOrientation;
    FDefPaper: Integer;
    FDefPaperHeight: Extended;
    FDefPaperWidth: Extended;
    FDefDuplex: Integer;
    FDefBin: Integer;
    FDPI: TPoint;
    FFileName: String;
    FHandle: THandle;
    FInitialized: Boolean;
    FName: String;
    FPaper: Integer;
    FPapers: TStrings;
    FPaperHeight: Extended;
    FPaperWidth: Extended;
    FLeftMargin: Extended;
    FTopMargin: Extended;
    FRightMargin: Extended;
    FBottomMargin: Extended;
    FOrientation: TPrinterOrientation;
    FPort: String;
    FPrinting: Boolean;
    FTitle: String;
    {$IFDEF LCLGTK2}
    FCUPSPrinter:TPrinter;
    {$ENDIF}
  public
    constructor Create(const AName, APort: String); virtual;
    destructor Destroy; override;
    procedure Init; virtual; abstract;
    procedure Abort; virtual; abstract;
    procedure BeginDoc; virtual; abstract;
    procedure BeginPage; virtual; abstract;
    procedure BeginRAWDoc; virtual; abstract;
    procedure EndDoc; virtual; abstract;
    procedure EndPage; virtual; abstract;
    procedure EndRAWDoc; virtual; abstract;
    procedure WriteRAWDoc(const buf: AnsiString); virtual; abstract;

    function BinIndex(ABin: Integer): Integer;
    function PaperIndex(APaper: Integer): Integer;
    function BinNameToNumber(const ABin: String): Integer;
    function PaperNameToNumber(const APaper: String): Integer;
    procedure SetViewParams(APaperSize: Integer;
      APaperWidth, APaperHeight: Extended;
      AOrientation: TPrinterOrientation); virtual; abstract;
    procedure SetPrintParams(APaperSize: Integer;
      APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation;
      ABin, ADuplex, ACopies: Integer); virtual; abstract;
    procedure PropertiesDlg; virtual; abstract;
    {$IFDEF LCLGTK2}
    function LCLPaperName(Tp: Integer): string;virtual; abstract;
    {$ENDIF}

    property Bin: Integer read FBin;
    property Duplex: Integer read FDuplex;
    property Bins: TStrings read FBins;
    property Canvas: TfrxPrinterCanvas read FCanvas;
    property DefOrientation: TPrinterOrientation read FDefOrientation;
    property DefPaper: Integer read FDefPaper;
    property DefPaperHeight: Extended read FDefPaperHeight;
    property DefPaperWidth: Extended read FDefPaperWidth;
    property DefBin: Integer read FDefBin;
    property DefDuplex: Integer read FDefDuplex;
    property DPI: TPoint read FDPI;
    property FileName: String read FFileName write FFileName;
    property Handle: THandle read FHandle;
    property Name: String read FName;
    property Paper: Integer read FPaper;
    property Papers: TStrings read FPapers;
    property PaperHeight: Extended read FPaperHeight;
    property PaperWidth: Extended read FPaperWidth;
    property LeftMargin: Extended read FLeftMargin;
    property TopMargin: Extended read FTopMargin;
    property RightMargin: Extended read FRightMargin;
    property BottomMargin: Extended read FBottomMargin;
    property Orientation: TPrinterOrientation read FOrientation;
    property Port: String read FPort;
    property Title: String read FTitle write FTitle;
    property Initialized: Boolean read FInitialized;
    {$IFDEF LCLGTK2}
    property CUPSPrinter:TPrinter read FCUPSPrinter;
    {$ENDIF}

  end;

  TfrxVirtualPrinter = class(TfrxCustomPrinter)
  public
    procedure Init; override;
    procedure Abort; override;
    procedure BeginDoc; override;
    procedure BeginPage; override;
    procedure BeginRAWDoc; override;
    procedure EndDoc; override;
    procedure EndPage; override;
    procedure EndRAWDoc; override;
    procedure WriteRAWDoc(const buf: AnsiString); override;
    procedure SetViewParams(APaperSize: Integer;
      APaperWidth, APaperHeight: Extended;
      AOrientation: TPrinterOrientation); override;
    procedure SetPrintParams(APaperSize: Integer;
      APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation;
      ABin, ADuplex, ACopies: Integer); override;
    procedure PropertiesDlg; override;
  end;

  TfrxPrinter = class(TfrxCustomPrinter)
  private
    FDeviceMode: THandle;
    FDC: PtrUInt; // BeginDoc,EndDoc pair
    FDriver: String;
    FMode: PDeviceMode;
    procedure CreateDevMode;
    procedure FreeDevMode;
  public
    destructor Destroy; override;
    procedure Init; override;
    procedure Abort; override;
    procedure BeginDoc; override;
    procedure BeginPage; override;
    procedure BeginRAWDoc; override;
    procedure EndDoc; override;
    procedure EndPage; override;
    procedure EndRAWDoc; override;
    procedure WriteRAWDoc(const buf: AnsiString); override;
    procedure SetViewParams(APaperSize: Integer;
      APaperWidth, APaperHeight: Extended;
      AOrientation: TPrinterOrientation); override;
    procedure SetPrintParams(APaperSize: Integer;
      APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation;
      ABin, ADuplex, ACopies: Integer); override;
    procedure PropertiesDlg; override;
    function UpdateDeviceCaps: Boolean;
    {$IFDEF LCLGTK2}
    function LCLPaperName(Tp: Integer): string; override;
    {$ENDIF}

    property DeviceMode: PDeviceMode read FMode;
  end;


  TfrxPrinters = class(TObject)
  private
    FHasPhysicalPrinters: Boolean;
    FPrinters: TStrings;
    FPrinterIndex: Integer;
    FPrinterList: TList;
    function GetDefaultPrinter: String;
    function GetItem(Index: Integer): TfrxCustomPrinter;
    function GetCurrentPrinter: TfrxCustomPrinter;
    procedure SetPrinterIndex(Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function IndexOf(AName: String): Integer;
    procedure Clear;
    procedure FillPrinters;
    property Items[Index: Integer]: TfrxCustomPrinter read GetItem; default;
    property HasPhysicalPrinters: Boolean read FHasPhysicalPrinters;
    property Printer: TfrxCustomPrinter read GetCurrentPrinter;
    property PrinterIndex: Integer read FPrinterIndex write SetPrinterIndex;
    property Printers: TStrings read FPrinters;
  end;

  TfrxPrinterCanvas = class(TCanvas)
  private
    FPrinter: TfrxCustomPrinter;
    procedure UpdateFont;
  public
    procedure Changing; override;
  end;


function frxPrinters: TfrxPrinters;
function frxGetPaperDimensions(PaperSize: Integer; var Width, Height: Extended): Boolean;

implementation

uses frxUtils,
    {$IFDEF LCLQt}
    qt4, qtobjects,
    {$ENDIF}
    Dialogs, frxRes;

var
  ASysPrinter: TPrinter;

type
  TPaperInfo = {packed} record
    Typ: Integer;
    Name: String;
    X, Y: Integer;
    LTyp:Integer;
  end;


const
  PAPERCOUNT = 67;
  PaperInfo: array[0..PAPERCOUNT - 1] of TPaperInfo = (
  (Typ:1;  Name: ''; X:2159; Y:2794; LTyp:0),
  (Typ:2;  Name: ''; X:2159; Y:2794; LTyp:0),
  (Typ:3;  Name: ''; X:2794; Y:4318; LTyp:0),
  (Typ:4;  Name: ''; X:4318; Y:2794; LTyp:0),
  (Typ:5;  Name: ''; X:2159; Y:3556; LTyp:0),
  (Typ:6;  Name: ''; X:1397; Y:2159; LTyp:0),
  (Typ:7;  Name: ''; X:1842; Y:2667; LTyp:0),
  (Typ:8;  Name: ''; X:2970; Y:4200; LTyp:0),
  (Typ:9;  Name: ''; X:2100; Y:2970; LTyp:0),
  (Typ:10; Name: ''; X:2100; Y:2970; LTyp:0),
  (Typ:11; Name: ''; X:1480; Y:2100; LTyp:0),
  (Typ:12; Name: ''; X:2500; Y:3540; LTyp:0),
  (Typ:13; Name: ''; X:1820; Y:2570; LTyp:0),
  (Typ:14; Name: ''; X:2159; Y:3302; LTyp:0),
  (Typ:15; Name: ''; X:2150; Y:2750; LTyp:0),
  (Typ:16; Name: ''; X:2540; Y:3556; LTyp:0),
  (Typ:17; Name: ''; X:2794; Y:4318; LTyp:0),
  (Typ:18; Name: ''; X:2159; Y:2794; LTyp:0),
  (Typ:19; Name: ''; X:984;  Y:2254; LTyp:0),
  (Typ:20; Name: ''; X:1048; Y:2413; LTyp:0),
  (Typ:21; Name: ''; X:1143; Y:2635; LTyp:0),
  (Typ:22; Name: ''; X:1207; Y:2794; LTyp:0),
  (Typ:23; Name: ''; X:1270; Y:2921; LTyp:0),
  (Typ:24; Name: ''; X:4318; Y:5588; LTyp:0),
  (Typ:25; Name: ''; X:5588; Y:8636; LTyp:0),
  (Typ:26; Name: ''; X:8636; Y:11176; LTyp:0),
  (Typ:27; Name: ''; X:1100; Y:2200; LTyp:0),
  (Typ:28; Name: ''; X:1620; Y:2290; LTyp:0),
  (Typ:29; Name: ''; X:3240; Y:4580; LTyp:0),
  (Typ:30; Name: ''; X:2290; Y:3240; LTyp:0),
  (Typ:31; Name: ''; X:1140; Y:1620; LTyp:0),
  (Typ:32; Name: ''; X:1140; Y:2290; LTyp:0),
  (Typ:33; Name: ''; X:2500; Y:3530; LTyp:0),
  (Typ:34; Name: ''; X:1760; Y:2500; LTyp:0),
  (Typ:35; Name: ''; X:1760; Y:1250; LTyp:0),
  (Typ:36; Name: ''; X:1100; Y:2300; LTyp:0),
  (Typ:37; Name: ''; X:984;  Y:1905; LTyp:0),
  (Typ:38; Name: ''; X:920;  Y:1651; LTyp:0),
  (Typ:39; Name: ''; X:3778; Y:2794; LTyp:0),
  (Typ:40; Name: ''; X:2159; Y:3048; LTyp:0),
  (Typ:41; Name: ''; X:2159; Y:3302; LTyp:0),
  (Typ:42; Name: ''; X:2500; Y:3530; LTyp:0),
  (Typ:43; Name: ''; X:1000; Y:1480; LTyp:0),
  (Typ:44; Name: ''; X:2286; Y:2794; LTyp:0),
  (Typ:45; Name: ''; X:2540; Y:2794; LTyp:0),
  (Typ:46; Name: ''; X:3810; Y:2794; LTyp:0),
  (Typ:47; Name: ''; X:2200; Y:2200; LTyp:0),
  (Typ:50; Name: ''; X:2355; Y:3048; LTyp:0),
  (Typ:51; Name: ''; X:2355; Y:3810; LTyp:0),
  (Typ:52; Name: ''; X:2969; Y:4572; LTyp:0),
  (Typ:53; Name: ''; X:2354; Y:3223; LTyp:0),
  (Typ:54; Name: ''; X:2101; Y:2794; LTyp:0),
  (Typ:55; Name: ''; X:2100; Y:2970; LTyp:0),
  (Typ:56; Name: ''; X:2355; Y:3048; LTyp:0),
  (Typ:57; Name: ''; X:2270; Y:3560; LTyp:0),
  (Typ:58; Name: ''; X:3050; Y:4870; LTyp:0),
  (Typ:59; Name: ''; X:2159; Y:3223; LTyp:0),
  (Typ:60; Name: ''; X:2100; Y:3300; LTyp:0),
  (Typ:61; Name: ''; X:1480; Y:2100; LTyp:0),
  (Typ:62; Name: ''; X:1820; Y:2570; LTyp:0),
  (Typ:63; Name: ''; X:3220; Y:4450; LTyp:0),
  (Typ:64; Name: ''; X:1740; Y:2350; LTyp:0),
  (Typ:65; Name: ''; X:2010; Y:2760; LTyp:0),
  (Typ:66; Name: ''; X:4200; Y:5940; LTyp:0),
  (Typ:67; Name: ''; X:2970; Y:4200; LTyp:0),
  (Typ:68; Name: ''; X:3220; Y:4450; LTyp:0),
  (Typ:70; Name: ''; X:1050; Y: 1480; LTyp:0) // A6 added
    );

  {$IFDEF FPC}
type
  TPaperInfoLCL = {packed} record
    // Typ: Integer;
    Name: String;
    W, H: Extended;
  end;
const
  LCLPaperCount = 119;
  PtPrIn  = 72;
  CmPrIn  = 2.54;
  PtPrCm  = PtPrIn/CmPrIn;
  PtPrmm  = PtPrCm/10;
  LCLPaperInfo : array[0..LCLPAPERCOUNT-1] of TPaperInfoLCL =
  ((Name:'Letter 8 1/2 x 11 in';W:8.5*PtPrIn;H:11*PtPrIn),
   (Name:'Letter Small 8 1/2 x 11 in';W:8.5*PtPrIn;H:11*PtPrIn),
   (Name:'Tabloid 11 x 17 in';W:11*PtPrIn;H:17*PtPrIn),
   (Name:'Ledger 17 x 11 in';W:17*PtPrIn;H:11*PtPrIn),
   (Name:'Legal 8 1/2 x 14 in';W:8.5*PtPrIn;H:14*PtPrIn),
   (Name:'Statement 5 1/2 x 8 1/2 in';W:5.5*PtPrIn;H:8.5*PtPrIn),
   (Name:'Executive 7 1/4 x 10 1/2 in';W:7.25*PtPrIn;H:10.5*PtPrIn),
   (Name:'A3 297 x 420 mm';W:297*PtPrmm;H:420*PtPrmm),
   (Name:'A4 210 x 297 mm';W:210*PtPrmm;H:297*PtPrmm),
   (Name:'A4 Small 210 x 297 mm';W:210*PtPrmm;H:297*PtPrmm),
   (Name:'A5 148 x 210 mm';W:148*PtPrmm;H:210*PtPrmm),
   (Name:'B4 (JIS) 250 x 354 mm';W:250*PtPrmm;H:354*PtPrmm),
   (Name:'B5 (JIS) 182 x 257 mm';W:182*PtPrmm;H:257*PtPrmm),
   (Name:'Folio 8 1/2 x 13 in';W:8.5*PtPrIn;H:13*PtPrIn),
   (Name:'Quarto 215 x 275 mm';W:215*PtPrmm;H:275*PtPrmm),
   (Name:'10x14 in';W:10*PtPrIn;H:14*PtPrIn),
   (Name:'11x17 in';W:11*PtPrIn;H:17*PtPrIn),
   (Name:'Note 8 1/2 x 11 in';W:8.5*PtPrIn;H:11*PtPrIn),
   (Name:'Envelope #9 3 7/8 x 8 7/8';W:3*7/8*PtPrIn;H:8*7/8*PtPrIn),
   (Name:'Envelope #10 4 1/8 x 9 1/2';W:3*1/8*PtPrIn;H:9.5*PtPrIn),
   (Name:'Envelope #11 4 1/2 x 10 3/8';W:4.5*PtPrIn;H:10*3/8*PtPrIn),
   (Name:'Envelope #12 4 3/4 x 11';W:4.75*PtPrIn;H:11*PtPrIn),
   (Name:'Envelope #14 5 x 11 1/2';W:5*PtPrIn;H:11.5*PtPrIn),
   (Name:'C size sheet 17 x 22 in';W:17*PtPrIn;H:22*PtPrIn),
   (Name:'D size sheet 22 x 34 in';W:22*PtPrIn;H:34*PtPrIn),
   (Name:'E size sheet 34 x 44 in';W:34*PtPrIn;H:44*PtPrIn),
   (Name:'Envelope DL 110 x 220mm';W:110*PtPrmm;H:220*PtPrmm),
   (Name:'Envelope C5 162 x 229 mm';W:162*PtPrmm;H:229*PtPrmm),
   (Name:'Envelope C3  324 x 458 mm';W:324*PtPrmm;H:458*PtPrmm),
   (Name:'Envelope C4  229 x 324 mm';W:229*PtPrmm;H:324*PtPrmm),
   (Name:'Envelope C6  114 x 162 mm';W:114*PtPrmm;H:162*PtPrmm),
   (Name:'Envelope C65 114 x 229 mm';W:114*PtPrmm;H:229*PtPrmm),
   (Name:'Envelope B4  250 x 353 mm';W:250*PtPrmm;H:353*PtPrmm),
   (Name:'Envelope B5  176 x 250 mm';W:176*PtPrmm;H:250*PtPrmm),
   (Name:'Envelope B6  176 x 125 mm';W:176*PtPrmm;H:125*PtPrmm),
   (Name:'Envelope 110 x 230 mm';W:110*PtPrmm;H:230*PtPrmm),
   (Name:'Envelope Monarch 3 7/8 x 7 1/2 in';W:3*7/8*PtPrIn;H:7.5*PtPrIn),
   (Name:'6 34 Envelope 3 5/8 x 6 1/2 in';W:3*5/8*PtPrIn;H:6.5*PtPrIn),
   (Name:'US Std Fanfold 14 7/8 x 11 in';W:14*7/8*PtPrIn;H:11*PtPrIn),
   (Name:'German Std Fanfold 8 1/2 x 12 in';W:8.5*PtPrIn;H:12*PtPrIn),
   (Name:'German Legal Fanfold 8 1/2 x 13 in';W:8.5*PtPrIn;H:13*PtPrIn),
   (Name:'B4 (ISO) 250 x 353 mm';W:250*PtPrmm;H:353*PtPrmm),
   (Name:'Japanese Postcard 100 x 148 mm';W:100*PtPrmm;H:148*PtPrmm),
   (Name:'9 x 11 in';W:9*PtPrIn;H:11*PtPrIn),
   (Name:'10 x 11 in';W:10*PtPrIn;H:11*PtPrIn),
   (Name:'15 x 11 in';W:15*PtPrIn;H:11*PtPrIn),
   (Name:'Envelope Invite 220 x 220 mm';W:220*PtPrmm;H:220*PtPrmm),
   (Name:'RESERVED--DO NOT USE';W:0;H:0),
   (Name:'RESERVED--DO NOT USE';W:0;H:0),
   (Name:'Letter Extra 9 \275 x 12 in';W:9.275*PtPrIn;H:12*PtPrIn),
   (Name:'Legal Extra 9 \275 x 15 in';W:9.275*PtPrIn;H:15*PtPrIn),
   (Name:'Tabloid Extra 11.69 x 18 in';W:11.69*PtPrIn;H:18*PtPrIn),
   (Name:'A4 Extra 9.27 x 12.69 in';W:9.27*PtPrIn;H:12.69*PtPrIn),
   (Name:'Letter Transverse 8 \275 x 11 in';W:8.275*PtPrIn;H:11*PtPrIn),
   (Name:'A4 Transverse 210 x 297 mm';W:210*PtPrmm;H:297*PtPrmm),
   (Name:'Letter Extra Transverse 9\275 x 12 in';W:9.275*PtPrIn;H:12*PtPrIn),
   (Name:'SuperASuperAA4 227 x 356 mm';W:227*PtPrmm;H:356*PtPrmm),
   (Name:'SuperBSuperBA3 305 x 487 mm';W:305*PtPrmm;H:487*PtPrmm),
   (Name:'Letter Plus 8.5 x 12.69 in';W:8.5*PtPrIn;H:12.69*PtPrIn),
   (Name:'A4 Plus 210 x 330 mm';W:210*PtPrmm;H:330*PtPrmm),
   (Name:'A5 Transverse 148 x 210 mm';W:148*PtPrmm;H:210*PtPrmm),
   (Name:'B5 (JIS) Transverse 182 x 257 mm';W:182*PtPrmm;H:257*PtPrmm),
   (Name:'A3 Extra 322 x 445 mm';W:322*PtPrmm;H:445*PtPrmm),
   (Name:'A5 Extra 174 x 235 mm';W:174*PtPrmm;H:235*PtPrmm),
   (Name:'B5 (ISO) Extra 201 x 276 mm';W:201*PtPrmm;H:276*PtPrmm),
   (Name:'A2 420 x 594 mm';W:420*PtPrmm;H:594*PtPrmm),
   (Name:'A3 Transverse 297 x 420 mm';W:297*PtPrmm;H:420*PtPrmm),
   (Name:'A3 Extra Transverse 322 x 445 mm';W:322*PtPrmm;H:445*PtPrmm),
   (Name:'Japanese Double Postcard 200 x 148 mm';W:200*PtPrmm;H:148*PtPrmm),
   (Name:'A6 105 x 148 mm';W:105*PtPrmm;H:148*PtPrmm),
   (Name:'Japanese Envelope Kaku #2';W:0;H:0),
   (Name:'Japanese Envelope Kaku #3';W:0;H:0),
   (Name:'Japanese Envelope Chou #3';W:0;H:0),
   (Name:'Japanese Envelope Chou #4';W:0;H:0),
   (Name:'Letter Rotated 11 x 8 1/2 11 in';W:11*PtPrIn;H:8.5*PtPrIn),
   (Name:'A3 Rotated 420 x 297 mm';W:420*PtPrmm;H:297*PtPrmm),
   (Name:'A4 Rotated 297 x 210 mm';W:297*PtPrmm;H:210*PtPrmm),
   (Name:'A5 Rotated 210 x 148 mm';W:210*PtPrmm;H:148*PtPrmm),
   (Name:'B4 (JIS) Rotated 364 x 257 mm';W:364*PtPrmm;H:257*PtPrmm),
   (Name:'B5 (JIS) Rotated 257 x 182 mm';W:257*PtPrmm;H:182*PtPrmm),
   (Name:'Japanese Postcard Rotated 148 x 100 mm';W:148*PtPrmm;H:100*PtPrmm),
   (Name:'Double Japanese Postcard Rotated 148 x 200 mm';W:148*PtPrmm;H:200*PtPrmm),
   (Name:'A6 Rotated 148 x 105 mm';W:148*PtPrmm;H:105*PtPrmm),
   (Name:'Japanese Envelope Kaku #2 Rotated';W:0;H:0),
   (Name:'Japanese Envelope Kaku #3 Rotated';W:0;H:0),
   (Name:'Japanese Envelope Chou #3 Rotated';W:0;H:0),
   (Name:'Japanese Envelope Chou #4 Rotated';W:0;H:0),
   (Name:'B6 (JIS) 128 x 182 mm';W:128*PtPrmm;H:182*PtPrmm),
   (Name:'B6 (JIS) Rotated 182 x 128 mm';W:182*PtPrmm;H:128*PtPrmm),
   (Name:'12 x 11 in';W:12*PtPrIn;H:11*PtPrIn),
   (Name:'Japanese Envelope You #4';W:0;H:0),
   (Name:'Japanese Envelope You #4 Rotated';W:0;H:0),
   (Name:'PRC 16K 146 x 215 mm';W:146*PtPrmm;H:215*PtPrmm),
   (Name:'PRC 32K 97 x 151 mm';W:97*PtPrmm;H:151*PtPrmm),
   (Name:'PRC 32K(Big) 97 x 151 mm';W:97*PtPrmm;H:151*PtPrmm),
   (Name:'PRC Envelope #1 102 x 165 mm';W:102*PtPrmm;H:165*PtPrmm),
   (Name:'PRC Envelope #2 102 x 176 mm';W:102*PtPrmm;H:176*PtPrmm),
   (Name:'PRC Envelope #3 125 x 176 mm';W:125*PtPrmm;H:176*PtPrmm),
   (Name:'PRC Envelope #4 110 x 208 mm';W:110*PtPrmm;H:208*PtPrmm),
   (Name:'PRC Envelope #5 110 x 220 mm';W:110*PtPrmm;H:220*PtPrmm),
   (Name:'PRC Envelope #6 120 x 230 mm';W:120*PtPrmm;H:230*PtPrmm),
   (Name:'PRC Envelope #7 160 x 230 mm';W:160*PtPrmm;H:230*PtPrmm),
   (Name:'PRC Envelope #8 120 x 309 mm';W:120*PtPrmm;H:309*PtPrmm),
   (Name:'PRC Envelope #9 229 x 324 mm';W:229*PtPrmm;H:324*PtPrmm),
   (Name:'PRC Envelope #10 324 x 458 mm';W:324*PtPrmm;H:458*PtPrmm),
   (Name:'PRC 16K Rotated 215 x 146 mm';W:215*PtPrmm;H:146*PtPrmm),
   (Name:'PRC 32K Rotated 151 x 97 mm';W:151*PtPrmm;H:97*PtPrmm),
   (Name:'PRC 32K(Big) Rotated 151 x 97 mm';W:151*PtPrmm;H:97*PtPrmm),
   (Name:'PRC Envelope #1 Rotated 165 x 102 mm';W:165*PtPrmm;H:102*PtPrmm),
   (Name:'PRC Envelope #2 Rotated 176 x 102 mm';W:176*PtPrmm;H:102*PtPrmm),
   (Name:'PRC Envelope #3 Rotated 176 x 125 mm';W:176*PtPrmm;H:125*PtPrmm),
   (Name:'PRC Envelope #4 Rotated 208 x 110 mm';W:208*PtPrmm;H:110*PtPrmm),
   (Name:'PRC Envelope #5 Rotated 220 x 110 mm';W:220*PtPrmm;H:110*PtPrmm),
   (Name:'PRC Envelope #6 Rotated 230 x 120 mm';W:230*PtPrmm;H:120*PtPrmm),
   (Name:'PRC Envelope #7 Rotated 230 x 160 mm';W:230*PtPrmm;H:160*PtPrmm),
   (Name:'PRC Envelope #8 Rotated 309 x 120 mm';W:309*PtPrmm;H:120*PtPrmm),
   (Name:'PRC Envelope #9 Rotated 324 x 229 mm';W:324*PtPrmm;H:229*PtPrmm),
   (Name:'PRC Envelope #10 Rotated 458 x 324 mm';W:458*PtPrmm;H:324*PtPrmm),
   (Name:'Custom size';W:0;H:0));
  {$ENDIF}

var
  FPrinters: TfrxPrinters = nil;


function frxGetPaperDimensions(PaperSize: Integer; var Width, Height: Extended): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to PAPERCOUNT - 1 do
    if PaperInfo[i].Typ = PaperSize then
    begin
      Width := PaperInfo[i].X / 10;
      Height := PaperInfo[i].Y / 10;
      Result := True;
      break;
    end;
end;


{ TfrxPrinterCanvas }

procedure TfrxPrinterCanvas.Changing;
begin
  inherited;
  UpdateFont;
end;

procedure TfrxPrinterCanvas.UpdateFont;
var
  FontSize: Integer;
begin
  if FPrinter.DPI.Y <> Font.PixelsPerInch then
  begin
    FontSize := Font.Size;
    Font.PixelsPerInch := FPrinter.DPI.Y;
    Font.Size := FontSize;
  end;
end;


{ TfrxCustomPrinter }

constructor TfrxCustomPrinter.Create(const AName, APort: String);
begin
  FInitialized := False;
  FName := AName;
  FPort := APort;

  FBins := TStringList.Create;
  FBins.AddObject(frxResources.Get('prDefault'), TObject(DMBIN_AUTO));

  FPapers := TStringList.Create;
  FPapers.AddObject(frxResources.Get('prCustom'), TObject(256));

  FCanvas := TfrxPrinterCanvas.Create;
  FCanvas.FPrinter := Self;
end;

destructor TfrxCustomPrinter.Destroy;
begin
  FBins.Free;
  FPapers.Free;
  FCanvas.Free;
  inherited;
end;

function TfrxCustomPrinter.BinIndex(ABin: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FBins.Count - 1 do
    if PtrInt(FBins.Objects[i]) = ABin then
    begin
      Result := i;
      break;
    end;
end;

function TfrxCustomPrinter.PaperIndex(APaper: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FPapers.Count - 1 do
    if PtrInt(FPapers.Objects[i]) = APaper then
    begin
      Result := i;
      break;
    end;
end;

function TfrxCustomPrinter.BinNameToNumber(const ABin: String): Integer;
var
  i: Integer;
begin
  i := FBins.IndexOf(ABin);
  if i = -1 then
    i := 0;
  Result := PtrInt(FBins.Objects[i]);
end;

function TfrxCustomPrinter.PaperNameToNumber(const APaper: String): Integer;
var
  i: Integer;
begin
  i := FPapers.IndexOf(APaper);
  if i = -1 then
    i := 0;
  Result := Integer(FPapers.Objects[i]);
end;


{ TfrxVirtualPrinter }

procedure TfrxVirtualPrinter.Init;
var
  i: Integer;
begin
  if FInitialized then Exit;

  FDPI := Point(600, 600);
  FDefPaper := DMPAPER_A4;
  FDefOrientation := poPortrait;
  FDefPaperWidth := 210;
  FDefPaperHeight := 297;

  for i := 0 to PAPERCOUNT - 1 do
    FPapers.AddObject(PaperInfo[i].Name, TObject(PaperInfo[i].Typ));

  FBin := -1;
  FDuplex := -1;
  FInitialized := True;
end;

procedure TfrxVirtualPrinter.Abort;
begin
end;

procedure TfrxVirtualPrinter.BeginDoc;
begin
end;

procedure TfrxVirtualPrinter.BeginPage;
begin
end;

procedure TfrxVirtualPrinter.EndDoc;
begin
end;

procedure TfrxVirtualPrinter.EndPage;
begin
end;

procedure TfrxVirtualPrinter.BeginRAWDoc;
begin
end;

procedure TfrxVirtualPrinter.EndRAWDoc;
begin
end;

procedure TfrxVirtualPrinter.WriteRAWDoc(const buf: AnsiString);
begin
end;

procedure TfrxVirtualPrinter.SetViewParams(APaperSize: Integer;
  APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation);
var
  i: Integer;
  Found: Boolean;
begin
  Found := False;
  if APaperSize <> 256 then
    for i := 0 to PAPERCOUNT - 1 do
      if PaperInfo[i].Typ = APaperSize then
      begin
        if AOrientation = poPortrait then
        begin
          APaperWidth := PaperInfo[i].X / 10;
          APaperHeight := PaperInfo[i].Y / 10;
        end
        else
        begin
          APaperWidth := PaperInfo[i].Y / 10;
          APaperHeight := PaperInfo[i].X / 10;
        end;
        Found := True;
        break;
      end;

  if not Found then
    APaperSize := 256;

  FOrientation := AOrientation;
  FPaper := APaperSize;
  FPaperWidth := APaperWidth;
  FPaperHeight := APaperHeight;
  FLeftMargin := 5;
  FTopMargin := 5;
  FRightMargin := 5;
  FBottomMargin := 5;
end;

procedure TfrxVirtualPrinter.SetPrintParams(APaperSize: Integer;
  APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation;
  ABin, ADuplex, ACopies: Integer);
begin
  SetViewParams(APaperSize, APaperWidth, APaperHeight, AOrientation);
  FBin := ABin;
end;

procedure TfrxVirtualPrinter.PropertiesDlg;
begin
end;


{ TfrxPrinter }

destructor TfrxPrinter.Destroy;
begin
  FreeDevMode;
  inherited;
end;

procedure TfrxPrinter.Init;

  {$IFDEF LCLQt}
  function QtPageSizeToPageSize(ASize: QPrinterPageSize): Cardinal;
  begin
    Result := DMPAPER_USER;
    case ASize of
      QPrinterA4: Result := DMPAPER_A4;
      QPrinterB5: Result := DMPAPER_B5;
      QPrinterLetter: Result := DMPAPER_LETTER;
      QPrinterLegal: Result := DMPAPER_LEGAL;
      QPrinterExecutive: Result := DMPAPER_EXECUTIVE;
      QPrinterA0: Result := DMPAPER_ESHEET; // priblizno u mm
      QPrinterA1: Result := DMPAPER_DSHEET;
      QPrinterA2: Result := DMPAPER_A2;
      QPrinterA3: Result := DMPAPER_A3;
      QPrinterA5: Result := DMPAPER_A5;
      QPrinterA6: Result := DMPAPER_A6;
      QPrinterA7,
      QPrinterA8, QPrinterA9: Result := DMPAPER_A4; // FIXME
      QPrinterB0: Result := DMPAPER_ESHEET;
      QPrinterB1: Result := DMPAPER_DSHEET;
      QPrinterB2: Result := DMPAPER_A2;
      QPrinterB3: Result := DMPAPER_B4;

      QPrinterB6: Result := DMPAPER_ENV_B6;
      QPrinterB7,QPrinterB8, QPrinterB9, QPrinterB10: Result := DMPAPER_ENV_B6;
      QPrinterC5E: Result := DMPAPER_ENV_C5;
      QPrinterComm10E: Result := DMPAPER_ENV_10;
      QPrinterDLE: Result := DMPAPER_ENV_DL;
      QPrinterFolio: Result := DMPAPER_FOLIO;
      QPrinterLedger: Result := DMPAPER_LEDGER;
      QPrinterTabloid: Result := DMPAPER_TABLOID;
      (*
      QPrinterCustom = 30 { $1e };
      QPrinterNPageSize = 30 { $1e };
      QPrinterNPaperSize = 30 { $1e };
      *)
    end;
  end;
  {$ENDIF}

  {$IFDEF LCLGTK2}
  function FindLinuxPaper(w, h: Integer): Integer;
  var
    I: Integer;
    p: TPaperRect;
    lw,lh: Integer;
  begin
    Result := 0;
    for I := 0 to CUPSPrinter.PaperSize.SupportedPapers.Count - 1 do
    begin
      p := CUPSPrinter.PaperSize.PaperRectOf[CUPSPrinter.PaperSize.SupportedPapers[I]];
      lw :=
       Round((p.PhysicalRect.Right - p.PhysicalRect.Left)  * 25.4/ CUPSPrinter.XDPI*10);
      lh :=
        Round((p.PhysicalRect.Bottom - p.PhysicalRect.Top) * 25.4/ CUPSPrinter.YDPI*10);
      if ((w >= lw - 6) and (w <= lw + 6)) and ((h >= lh - 6) and (h <= lh + 6)) then
      begin
        Result := I;
        Break;
      end;
    end;
  end;

  procedure FillPapers;
  var
    i,k: Integer;
    fw, fh, lw, lh: Integer;
  begin
    //PaperSizesCount := PAPERCOUNT;
    for I := 0 to  PAPERCOUNT - 1 do
    begin
      fw := PaperInfo[I].X;
      fh := PaperInfo[I].Y;
      k := FindLinuxPaper(fw, fh);
      if k > 0 then
      begin
       PaperInfo[I].LTyp:= k;
       FPapers.AddObject(LCLPaperInfo[i].Name, TObject(PaperInfo[I].Typ));
      end;
    end;
  end;

  {$ELSE}

  procedure FillPapers;
  var
    i, PaperSizesCount: Integer;
    PaperSizes: array[0..511] of Word;
    PaperNames: PChar;
    {$IFDEF LCLQt}
    PrnInfo: QPrinterInfoH;
    IntAr: TPtrIntArray;
    W: WideString;
    {$ENDIF}
  begin
    FillChar(PaperSizes, SizeOf(PaperSizes), 0);
    {$IFDEF FPC}
    PaperSizesCount := PAPERCOUNT;
    for i := 0 to PAPERCOUNT - 1 do
      FPapers.AddObject(LCLPaperInfo[i].Name, TObject(i + 1));
    {$ELSE}
    PaperSizesCount := DeviceCapabilities(PChar(FName), PChar(FPort), DC_PAPERS, @PaperSizes, FMode);
    GetMem(PaperNames, PaperSizesCount * 64 * sizeof(char));
    DeviceCapabilities(PChar(FName), PChar(FPort), DC_PAPERNAMES, PaperNames, FMode);
    for i := 0 to PaperSizesCount - 1 do
      if PaperSizes[i] <> 256 then
{$IFDEF Delphi12}
        FPapers.AddObject(StrPas(PWideChar(PaperNames + i * 64)), Pointer(PaperSizes[i]));
{$ELSE}
        FPapers.AddObject(StrPas(PAnsiChar(PaperNames + i * 64)), Pointer(PaperSizes[i]));
{$ENDIF}

    FreeMem(PaperNames, PaperSizesCount * 64 * sizeof(char));
    {$ENDIF}
  end;
{$ENDIF}

  procedure FillBins;
  var
    i, BinsCount: Integer;
    BinNumbers: array[0..255] of Word;
    BinNames: PChar;
    {$IFDEF LCLQt}
    PrnInfo: QPrinterInfoH;
    {$ENDIF}
  begin
    FillChar(BinNumbers, SizeOf(BinNumbers), 0);
    {$IFDEF FPC}
    // QPrinterOnlyOne, QPrinterLower, QPrinterMiddle, QPrinterManual, QPrinterEnvelope, QPrinterEnvelopeManual, QPrinterAuto, QPrinterTractor, QPrinterSmallFormat, QPrinterLargeFormat, QPrinterLargeCapacity,
    // QPrinterCassette, QPrinterFormSource, QPrinterMaxPageSource );
    // QT's QPrinterPageSource is by -1 of DMBIN_ values !
    BinsCount := 12;
    FBins.AddObject('OnlyOne', TObject(Ord(DMBIN_ONLYONE)));
    FBins.AddObject('Lower', TObject(Ord(DMBIN_LOWER)));
    FBins.AddObject('Middle', TObject(Ord(DMBIN_MIDDLE)));
    FBins.AddObject('Manual', TObject(Ord(DMBIN_MANUAL)));
    FBins.AddObject('Envelope', TObject(Ord(DMBIN_ENVELOPE)));
    FBins.AddObject('EnvelopeManual', TObject(Ord(DMBIN_ENVMANUAL)));
    FBins.AddObject('Auto', TObject(Ord(DMBIN_AUTO)));
    FBins.AddObject('Tractor', TObject(Ord(DMBIN_TRACTOR)));
    FBins.AddObject('Small Format', TObject(Ord(DMBIN_SMALLFMT)));
    FBins.AddObject('Large Format', TObject(Ord(DMBIN_LARGEFMT)));
    FBins.AddObject('Large Capacity', TObject(Ord(DMBIN_LARGECAPACITY)));
    FBins.AddObject('Cassette', TObject(Ord(DMBIN_CASSETTE)));

    {$ELSE}
    BinsCount := DeviceCapabilities(PChar(FName), PChar(FPort), DC_BINS, @BinNumbers[0], FMode);
    GetMem(BinNames, BinsCount * 24 * sizeof(char));
      DeviceCapabilities(PChar(FName), PChar(FPort), DC_BINNAMES, BinNames, FMode);

    for i := 0 to BinsCount - 1 do
      if BinNumbers[i] <> DMBIN_AUTO then
{$IFDEF Delphi12}
        FBins.AddObject(StrPas(PwideChar(BinNames + i * 24)), Pointer(BinNumbers[i]));
{$ELSE}
        FBins.AddObject(StrPas(BinNames + i * 24), Pointer(BinNumbers[i]));
{$ENDIF}

    FreeMem(BinNames, BinsCount * 24 * sizeof(char));
    {$ENDIF}
  end;

begin
  if FInitialized then Exit;
  // writeln('SETTING DEF PRN TO ',FName,' Current index=',Printer.PrinterIndex);
  {$IFDEF LCLGTK2}
  FCUPSPrinter := ASysPrinter;
  {$ENDIF}
  {$IFDEF FPC}
  Printer.PrinterIndex := Printer.Printers.IndexOf(FName);
  {$ENDIF}
  CreateDevMode;
  if FDeviceMode = 0 then Exit;
  {$IFNDEF FPC}
  RecreateDC;
  {$ENDIF}

  if not UpdateDeviceCaps then
  begin
    FreeDevMode;
    Exit;
  end;

  FDefPaper := DMPAPER_A4;
  // ASysPrinter.PaperSize.DefaultPaperName;
  // FMode.dmPaperSize;
  FDefBin := FMode^.dmDefaultSource;
  FDefDuplex := FMode^.dmDuplex;
  FPaper := FDefPaper;
  FDefPaperWidth := FPaperWidth;
  FDefPaperHeight := FPaperHeight;
  if FMode^.dmOrientation = DMORIENT_PORTRAIT then
    FDefOrientation := poPortrait else
    FDefOrientation := poLandscape;
  FOrientation := FDefOrientation;
  FillPapers;
  FillBins;
  FBin := -1;
  FDuplex := -1;
  FInitialized := True;
end;

procedure TfrxPrinter.Abort;
begin
  {$IFDEF FPC}
  Printer.Abort;
  {$ELSE}
  AbortDoc(FDC);
  {$ENDIF}
  EndDoc;
end;

procedure TfrxPrinter.BeginDoc;
{$IFDEF FPC}
begin
  FPrinting := True;
  FDC := $FFFFFFFF;
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn('TfrxPrinter.BeginDoc');
  ASysPrinter.PrinterName;
  DebugLn('PaperName ',ASysPrinter.PaperSize.PaperName,' orient ',dbgs(Ord(ASysPrinter.Orientation)),
  ' Name ',ASysPrinter.PrinterName);
  {$IFDEF LCLQt}
  DebugLn('Qt paper ',dbgs(Ord(QtDefaultPrinter.PageSize)),' orient ',dbgs(Ord(QtDefaultPrinter.Orientation)),
  ' name ',QtDefaultPrinter.PrinterName,' OutFormat ', dbgs(Ord(QtDefaultPrinter.OutputFormat)));
  {$ENDIF}
  {$ENDIF}
  ASysPrinter.BeginDoc;
  FCanvas.Handle := ASysPrinter.Canvas.Handle;
  FCanvas.Refresh;
  FCanvas.UpdateFont;
{$ELSE}
var
  DocInfo: TDocInfo;
begin
  FPrinting := True;

  FillChar(DocInfo, SizeOf(DocInfo), 0);
  DocInfo.cbSize := SizeOf(DocInfo);
  if FTitle <> '' then
    DocInfo.lpszDocName := PChar(FTitle)
  else DocInfo.lpszDocName := PChar('Fast Report Document');

  if FFileName <> '' then
    DocInfo.lpszOutput := PChar(FFileName);

  RecreateDC;
  StartDoc(FDC, DocInfo);
{$ENDIF}
end;

procedure TfrxPrinter.BeginPage;
begin
  {$IFDEF FPC}
  if FDC = $FFFFFFFF then
    FDC := 1
  else
  begin
    Inc(FDC, 1);
    if not FPrinting then
      BeginDoc
    else
      ASysPrinter.NewPage;
  end;
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn('TfrxPrinter.Begin PrinterHandle ? ',dbgs(Printer.Canvas.HandleAllocated));
  {$ENDIF}
  if not Printer.Canvas.HandleAllocated then
    raise Exception.CreateFmt('Printer canvas handle not allocated.Printer state %d ',[Ord(Printer.PrinterState)]);

  // TQtPrinter(Printer.Canvas.Handle).
  // QPaintEngine_clearDirty(QPainter_paintEngine(TQtPrinter(Printer.Handle)), QPaintEngineAllDirty);
  {$ELSE}
  StartPage(FDC);
  {$ENDIF}
end;

procedure TfrxPrinter.EndDoc;
var
  Saved8087CW: Word;
begin
  {$IFDEF FPC}
  FDC := $00000000;
  FCanvas.Handle := 0;
  if FPrinting then
    ASysPrinter.EndDoc;
  {$ELSE}
  Saved8087CW := Default8087CW;
  Set8087CW($133F);
  try
    Windows.EndDoc(FDC);
  except
  end;
  Set8087CW(Saved8087CW);
  {$ENDIF}

  FPrinting := False;
  {$IFNDEF FPC}
  RecreateDC;
  {$ENDIF}
  FBin := -1;
  FDuplex := -1;

  FMode^.dmFields := FMode^.dmFields or DM_DEFAULTSOURCE or DM_DUPLEX;
  FMode^.dmDefaultSource := FDefBin;
  FMode^.dmDuplex := FDefDuplex;
  {$IFNDEF FPC}
  FDC := ResetDC(FDC, FMode^);
  {$ENDIF}
end;

procedure TfrxPrinter.EndPage;
begin
  {$IFDEF FPC}
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn('TfrxPrinter.EndPage PrinterHandle ? ',dbgs(Printer.Canvas.HandleAllocated));
  {$ENDIF}
  {$ELSE}
  Windows.EndPage(FDC);
  {$ENDIF}
end;

procedure TfrxPrinter.BeginRAWDoc;
{$IFNDEF FPC}
var
  DocInfo1: TDocInfo1;
{$ENDIF}
begin
  {$IFDEF FPC}
  // RecreateDC;
  {$ELSE}
  RecreateDC;
  DocInfo1.pDocName := PChar(FTitle);
  DocInfo1.pOutputFile := nil;
  DocInfo1.pDataType := 'RAW';
  StartDocPrinter(FHandle, 1, @DocInfo1);
  StartPagePrinter(FHandle);
  {$ENDIF}
end;

procedure TfrxPrinter.EndRAWDoc;
begin
  {$IFDEF FPC}

  {$ELSE}
  EndPagePrinter(FHandle);
  EndDocPrinter(FHandle);
  {$ENDIF}
end;

procedure TfrxPrinter.WriteRAWDoc(const buf: AnsiString);
var
  N: DWORD;
begin
  {$IFNDEF FPC}
  WritePrinter(FHandle, PAnsiChar(buf), Length(buf), N);
  {$ENDIF}
end;

procedure TfrxPrinter.CreateDevMode;
var
  bufSize: Integer;
{$IFNDEF Delphi12}
  dm: TDeviceMode;
{$ENDIF}
begin
  {$IFDEF FPC}
  GetMem(FMode, SizeOf(TDeviceMode) + 1);
  // FillChar(FMode, SizeOf(FMode), #0);
  FMode^.dmPaperSize := 0;
  FMode^.dmOrientation := 0;
  FHandle := THandle(ASysPrinter);
  FDeviceMode := 1;
  {$ELSE}
  if OpenPrinter(PChar(FName), FHandle, nil) then
  begin
{$IFDEF Delphi12}
    bufSize := DocumentProperties(0, FHandle, PChar(FName), nil, nil, 0);
{$ELSE}
    bufSize := DocumentProperties(0, FHandle, PChar(FName), dm, dm, 0);
{$ENDIF}
    if bufSize > 0 then
    begin
      FDeviceMode := GlobalAlloc(GHND, bufSize);
      if FDeviceMode <> 0 then
      begin
        FMode := GlobalLock(FDeviceMode);
        if DocumentProperties(0, FHandle, PChar(FName), FMode^, FMode^,
          DM_OUT_BUFFER) < 0 then
        begin
          GlobalUnlock(FDeviceMode);
          GlobalFree(FDeviceMode);
          FDeviceMode := 0;
          FMode := nil;
        end
      end;
    end;
  end;
  {$ENDIF}
end;

procedure TfrxPrinter.FreeDevMode;
begin
  {$IFDEF FPC}
  Freemem(FMode, SizeOf(TDeviceMode) + 1);
  // FCanvas.Handle := 0;
  // if FDC <> 0 then
  //  DeleteDC(FDC);
  FMode := nil;
  FDeviceMode := 0;
  {$ELSE}
  FCanvas.Handle := 0;
  if FDC <> 0 then
    DeleteDC(FDC);
  if FHandle <> 0 then
    ClosePrinter(FHandle);
  if FDeviceMode <> 0 then
  begin
    GlobalUnlock(FDeviceMode);
    GlobalFree(FDeviceMode);
  end;
  FDeviceMode := 0;
  FDC := 0;
  FHandle := 0;
  {$ENDIF}
end;

{$IFNDEF FPC}
procedure TfrxPrinter.RecreateDC;
begin
  if FDC <> 0 then
    try
      DeleteDC(FDC);
    except
    end;
  FDC := 0;
  GetDC;
end;

procedure TfrxPrinter.GetDC;
begin
  if FDC = 0 then
  begin
    {$IFDEF FPC}
    (*
    if FPrinting then
      FDC := Printer.Canvas.Handle
    else
    begin
      Printer.BeginDoc;
      FDC := Printer.Canvas.Handle;
    end;
    *)
    {$ELSE}
    if FPrinting then
      FDC := CreateDC(PChar(FDriver), PChar(FName), nil, FMode) else
      FDC := CreateIC(PChar(FDriver), PChar(FName), nil, FMode);
    {$ENDIF}
    FCanvas.Handle := FDC;
    FCanvas.Refresh;
    FCanvas.UpdateFont;
  end;
end;
{$ENDIF}

procedure TfrxPrinter.SetViewParams(APaperSize: Integer;
  APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation);
{$IFDEF LCLGTK2}
var
  s: string;
{$ENDIF}

begin
  if APaperSize <> 256 then
  begin
    FMode^.dmFields := DM_PAPERSIZE or DM_ORIENTATION;
    FMode^.dmPaperSize := APaperSize;
    if AOrientation = poPortrait then
      FMode^.dmOrientation := DMORIENT_PORTRAIT else
      FMode^.dmOrientation := DMORIENT_LANDSCAPE;
    {$IFNDEF FPC}
    RecreateDC;
    {$ENDIF}
    {$IFDEF LCLGTK2}
    s := LCLPaperName(APaperSize);
    if s <> '' then
      CUPSPrinter.PaperSize.PaperName:= s
    else
      CUPSPrinter.PaperSize.PaperName := 'A4';
    FOrientation := AOrientation;
    {$ENDIF}
    if not UpdateDeviceCaps then Exit;
  end
  else
  begin
    // copy the margins from A4 paper
    SetViewParams(DMPAPER_A4, 0, 0, AOrientation);
    FPaperHeight := APaperHeight;
    FPaperWidth := APaperWidth;
  end;

  FPaper := APaperSize;
  FOrientation := AOrientation;
end;

procedure TfrxPrinter.SetPrintParams(APaperSize: Integer;
  APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation;
  ABin, ADuplex, ACopies: Integer);
{$IFDEF FPC}
var
  i: Integer;
  {$IFDEF LCLQt}
  APrn: QPrinterH;
  ASize: QSizeFH;
  function DMDUP_to_Qt(ADuplex: Integer): QPrinterDuplexMode;
  begin
    Result := QPrinterDuplexNone;
    case ADuplex of
      DMDUP_SIMPLEX: Result := QPrinterDuplexNone;
      DMDUP_VERTICAL: Result := QPrinterDuplexShortSide;
      DMDUP_HORIZONTAL: Result := QPrinterDuplexLongSide;
    end;
  end;
  {$ENDIF}
{$ENDIF}
begin
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn(' > TfrxPrinter.SetPrintParams ');
  DebugLn('  > ',Format('PapW %d PapH %d Orient %d APaperSize %d',[Round(APaperWidth), Round(APaperHeight),
    Ord(AOrientation), APaperSize]));
  {$ENDIF}
  FMode^.dmFields := FMode^.dmFields or DM_PAPERSIZE or DM_ORIENTATION or DM_COPIES
    or DM_DEFAULTSOURCE;


  if APaperSize = 256 then
  begin
    FMode^.dmFields := FMode^.dmFields or DM_PAPERLENGTH or DM_PAPERWIDTH;
    if AOrientation = poLandscape then
    begin
      FMode^.dmPaperLength := Round(APaperWidth * 10);
      FMode^.dmPaperWidth := Round(APaperHeight * 10);
    end
    else
    begin
      FMode^.dmPaperLength := Round(APaperHeight * 10);
      FMode^.dmPaperWidth := Round(APaperWidth * 10);
    end;
  end
  else
  begin
    FMode^.dmPaperLength := 0;
    FMode^.dmPaperWidth := 0;
  end;

  FMode^.dmPaperSize := APaperSize;
  if AOrientation = poPortrait then
    FMode^.dmOrientation := DMORIENT_PORTRAIT else
    FMode^.dmOrientation := DMORIENT_LANDSCAPE;

  FMode^.dmCopies := ACopies;
  if FBin <> -1 then
    ABin := FBin;
  if ABin = DMBIN_AUTO then
    ABin := DefBin;
  FMode^.dmDefaultSource := ABin;

  if ADuplex = 0 then
    ADuplex := FDefDuplex
  else Inc(ADuplex);
  if ADuplex = 4 then
    ADuplex := DMDUP_SIMPLEX;
  if FDuplex <> -1 then
    ADuplex := FDuplex;
  if ADuplex <> 1 then
    FMode^.dmFields := FMode^.dmFields  or DM_DUPLEX;
  FMode^.dmDuplex := ADuplex;

  {$IFDEF FPC}
  if FPrinting then
    EndDoc;

  ASysPrinter.Orientation := AOrientation;
  ASysPrinter.Copies := ACopies;

  {$IFDEF LCLQt}
  {$warning HARDCODED}
  APrn := QtDefaultPrinter.Handle;

  if AOrientation = poLandscape then
    QtDefaultPrinter.Orientation := QPrinterLandscape
  else
    QtDefaultPrinter.Orientation := QPrinterPortrait;

  QPrinter_setDuplex(APrn, DMDUP_to_Qt(ADuplex));
  if APaperSize = DMPAPER_A5 then
    QPrinter_setPageSize(APrn, QPrinterA5)
  else
  if APaperSize = DMPAPER_A4 then
    QPrinter_setPageSize(APrn, QPrinterA4)
  else
  begin
    // QtDefaultPrinter.Collate := ;
    if AOrientation = poLandscape then
      ASize := QSizeF_Create(APaperHeight, APaperWidth)
    else
      ASize := QSizeF_Create(APaperWidth, APaperHeight);
    QPrinter_setPaperSize(APrn, ASize, QPrinterMillimeter);
    QSizeF_destroy(ASize);
  end;

  QtDefaultPrinter.NumCopies := ACopies;

  // SET PAPER FROM PAPERSToQtPAPERS
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn('APAPERSIZE=',dbgs(APaperSize),' DEF PRN ',  QtDefaultPrinter.PrinterName,
  ' Setting paper size to w=',dbgs(APaperWidth),' h=',dbgs(APaperHeight));
  {$ENDIF}

  if FFileName <> '' then
  begin
    QtDefaultPrinter.OutputFileName := FileName;
    QtDefaultPrinter.OutputFormat := QPrinterPdfFormat;
    QtDefaultPrinter.ColorMode := QPrinterColor;
  end else
  begin
    QtDefaultPrinter.OutputFileName := '';
    QtDefaultPrinter.OutputFormat := QPrinterNativeFormat;
  end;
  {$ELSE}
  {$warning HARDCODED ALL PAPERS TO A4}
  //ASysPrinter.PaperSize.PaperName := 'A4';
  {$ENDIF}

  {$ELSE}
  FDC := ResetDC(FDC, FMode^);
  FDC := ResetDC(FDC, FMode^);  // needed for some printers
  {$ENDIF}
  FCanvas.Refresh;
  if not UpdateDeviceCaps then Exit;
  FPaper := APaperSize;
  FOrientation := AOrientation;
end;

function TfrxPrinter.UpdateDeviceCaps: Boolean;
{$IFDEF FPC}
var
  WR, PR, WRmm, PRmm: TRect;
{$ENDIF}
begin
  Result := True;
  {$IFNDEF FPC}
  if FDC = 0 then GetDC;

  FDPI := Point(GetDeviceCaps(FDC, LOGPIXELSX), GetDeviceCaps(FDC, LOGPIXELSY));
  {$ELSE}
  FDPI.X := ASysPrinter.XDPI;
  FDPI.Y := ASysPrinter.YDPI;
  {$ENDIF}
  if (FDPI.X = 0) or (FDPI.Y = 0) then
  begin
    Result := False;
    frxErrorMsg('Printer selected is not valid');
    Exit;
  end;
  {$IFDEF LCLQt}
  WR := QtDefaultPrinter.pageRect;
  PR := QtDefaultPrinter.paperRect;
  Wrmm := QtDefaultPrinter.PageRect(QPrinterMillimeter);
  Prmm := QtDefaultPrinter.PaperRect(QPrinterMillimeter);
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn('Dump printer page px wr ',dbgs(WR),' pr ',dbgs(PR));
  DebugLn('Dump printer page mm wr ',dbgs(WRmm),' pr ',dbgs(PRmm));
  {$ENDIF}
  FPaperHeight := PRmm.Bottom;
  FPaperWidth := Prmm.Right;
  FLeftMargin := WRmm.Left;
  FTopMargin := WRmm.Top;

  // FIXME, Right and bottom margin probably wrong ?
  FRightMargin := FLeftMargin;
  // FPaperWidth - Round(Printer.XDPI / FDPI.X * 25.4) - FLeftMargin;
  FBottomMargin := FTopMargin;
  // FPaperHeight - Round(Printer.YDPI / FDPI.Y * 25.4) - FTopMargin;
  {$ELSE}
  Prmm := ASysPrinter.PaperSize.PaperRect.PhysicalRect;
  WRmm := ASysPrinter.PaperSize.PaperRect.WorkRect;

  if FOrientation = poPortrait then
  begin
  FPaperHeight := PRmm.Bottom / DPI.Y * 25.4;
  FPaperWidth := Prmm.Right / DPI.X * 25.4;
  FLeftMargin := WRmm.Left / DPI.X * 25.4;
  FTopMargin := WRmm.Top / DPI.Y * 25.4;

  FRightMargin := (Prmm.Right - WRmm.Right) / DPI.X * 25.4;
  FBottomMargin := (Prmm.Bottom - WRmm.Bottom) / DPI.X * 25.4;

  end
  else if FOrientation = poLandscape then
  begin
    FPaperHeight := Prmm.Right / DPI.X * 25.4;
    FPaperWidth := PRmm.Bottom / DPI.Y * 25.4;

    FLeftMargin := WRmm.Top / DPI.X * 25.4;
    FTopMargin := WRmm.Left / DPI.Y * 25.4;

    FRightMargin := (Prmm.Bottom - WRmm.Bottom) / DPI.X * 25.4;
    FBottomMargin := (Prmm.Right - WRmm.Right) / DPI.X * 25.4;
  end;
  {$ENDIF}
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn('UPDATE DEVICE CAPS RESULTS ');
  DebugLn(Format('FPaperHeight %12.2n FPaperWidth %12.2n XDPI %d',[FPaperHeight, FPaperWidth, Round(Printer.XDPI / FDPI.X * 25.4)]));
  DebugLn(Format('MARGINE L %12.2n T %12.2n R %12.2n B %12.2n',
    [FLeftMargin, FTopMargin, FRightMargin, FBottomMargin]));
  DebugLn(Format('DPIX %d DPIY %d ',[DPI.X, DPI.Y]));
  {$ENDIF}
end;

{$IFDEF LCLGTK2}
function TfrxPrinter.LCLPaperName(Tp: Integer): string;
var
  I: Integer;
  fw, fh:Integer;
begin
  Result := '';
  for I := 0 to Length(PaperInfo) - 1 do
  begin
    if  PaperInfo[I].Typ = Tp then
    begin
      fw := PaperInfo[I].X;
      fh := PaperInfo[I].Y;
      Result :=  CUPSPrinter.PaperSize.SupportedPapers[PaperInfo[I].LTyp];
    end;
    if Result <> '' then
     Break;
  end;
end;
{$ENDIF}


procedure TfrxPrinter.PropertiesDlg;
var
  h: THandle;
  PrevDuplex: Integer;
  {$IFDEF LCLGTK2}
   pdlg: TPrinterSetupDialog;
  {$ENDIF}

  {$IFDEF LCLQt}
  function QtPropsDlg: Boolean;
  var
    PgDlg: QPageSetupDialogH;
  begin
    Result := False;
    if not Assigned(ASysPrinter) then Exit;
    if ASysPrinter.Printers.Count <= 0 then Exit;
    {There's no special dialog for printer setup under Qt,
     so we'll use QPageSetupDialog here.}
    PgDlg := QPageSetupDialog_create(QtDefaultPrinter.Handle, nil);
    try
      Result := QPageSetupDialog_exec(PgDlg) = Ord(QDialogAccepted);
    finally
      QPageSetupDialog_destroy(PgDlg);
    end;
  end;
  {$ENDIF}
begin
  {$IFDEF LCLQt}
  QtPropsDlg;
  {$ELSE}
  pdlg := TPrinterSetupDialog.Create(nil);
  try
  pdlg.Execute;
  finally
    pdlg.Free;
  end;
  {$ENDIF}
end;

{ TfrxPrinters }

constructor TfrxPrinters.Create;
begin
  FPrinterList := TList.Create;
  FPrinters := TStringList.Create;

  FillPrinters;
  if FPrinterList.Count = 0 then
  begin
    FPrinterList.Add(TfrxVirtualPrinter.Create(frxResources.Get('prVirtual'), ''));
    FHasPhysicalPrinters := False;
    PrinterIndex := 0;
  end
  else
  begin
    FHasPhysicalPrinters := True;
    PrinterIndex := IndexOf(GetDefaultPrinter);
    if PrinterIndex = -1 then  // important
      PrinterIndex := 0;
  end;
end;

destructor TfrxPrinters.Destroy;
begin
  Clear;
  FPrinterList.Free;
  FPrinters.Free;
  inherited;
end;

procedure TfrxPrinters.Clear;
begin
  while FPrinterList.Count > 0 do
  begin
    TObject(FPrinterList[0]).Free;
    FPrinterList.Delete(0);
  end;
  FPrinters.Clear;
end;

function TfrxPrinters.GetItem(Index: Integer): TfrxCustomPrinter;
begin
  if Index >= 0 then
    Result := TfrxCustomPrinter(FPrinterList[Index])
  else
    Result := nil
end;

function TfrxPrinters.IndexOf(AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FPrinterList.Count - 1 do
    if AnsiCompareText(Items[i].Name, AName) = 0 then
    begin
      Result := i;
      break;
    end;
end;

procedure TfrxPrinters.SetPrinterIndex(Value: Integer);
begin
  if Value <> -1 then
    FPrinterIndex := Value
  else
    FPrinterIndex := IndexOf(GetDefaultPrinter);
  if FPrinterIndex <> -1 then
  begin
    if FHasPhysicalPrinters then
      begin
        {$IFDEF LCLQt}
        QtDefaultPrinter.PrinterName := ASysPrinter.Printers.Strings[FPrinterIndex];
        {$ELSE}
        ASysPrinter.PrinterIndex := FPrinterIndex;
        // ASysPrinter.Printers.Strings[FPrinterIndex];
        {$ENDIF}
        Items[FPrinterIndex].Init;
      end;
  end;
end;

function TfrxPrinters.GetCurrentPrinter: TfrxCustomPrinter;
begin
  Result := Items[PrinterIndex];
end;

function TfrxPrinters.GetDefaultPrinter: String;
var
  {$IFDEF LCLQt}
  prnName: WideString;
  PrnInfo: QPrinterInfoH;
  {$ELSE}
  prnName: array[0..255] of Char;
  {$ENDIF}
begin
  {$IFDEF LCLQt}
  PrnInfo := QPrinterInfo_create();
  QPrinterInfo_defaultPrinter(PrnInfo);
  QPrinterInfo_printerName(PrnInfo, @PrnName);
  QPrinterInfo_destroy(PrnInfo);
  if PrnName = '' then
    PrnName := 'unknown';
  Result := PrnName;
  {$ELSE}
  Result := ASysPrinter.Printers[0];
  {$ENDIF}
end;

procedure TfrxPrinters.FillPrinters;
var
  i, j: Integer;
  Buf, prnInfo: PByte;
  Flags, bufSize, prnCount: DWORD;
  Level: Byte;
  sl: TStringList;

  procedure AddPrinter(ADevice, APort: String);
  begin
    FPrinterList.Add(TfrxPrinter.Create(ADevice, APort));
    FPrinters.Add(ADevice);
  end;

begin
  Clear;
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn('TfrxPrinters.FillPrinters ...');
  {$ENDIF}
  for i := 0 to ASysPrinter.Printers.Count - 1 do
  begin
    AddPrinter(ASysPrinter.Printers[i],'LPT1');
  end;
    // FPrinters.Add(TQtPrinters(ASysPrinter).Printers[i]);
  {$IFDEF DEBUGFR4PRINTERS}
  DebugLn('TfrxPrinters.FillPrinters ...FPrinters count ',dbgs(FPrinters.Count));
  {$ENDIF}
end;



function frxPrinters: TfrxPrinters;
begin
  if FPrinters = nil then
  begin
    ASysPrinter := Printer;
    FPrinters := TfrxPrinters.Create;
  end;
  Result := FPrinters;
end;

initialization

finalization
  if FPrinters <> nil then
    FPrinters.Free;
  FPrinters := nil;
//end.
