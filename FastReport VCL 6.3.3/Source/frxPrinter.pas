
{******************************************}
{                                          }
{             FastReport v5.0              }
{                 Printer                  }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxPrinter;

interface


{$I frx.inc}

{$IFDEF NONWINFPC}
{$I frxLazPrinters.inc}
{$ELSE}

uses 
  Windows, SysUtils, Types, Classes, Graphics, Forms, Printers
  {$IFDEF FPC}
  ,LCLType, LCLIntf, LazHelper
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


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

    property Bin: Integer read FBin write FBin;
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

  { TfrxPrinter }

  TfrxPrinter = class(TfrxCustomPrinter)
  private
    FDeviceMode: THandle;
    FDC: HDC;
    FDriver: String;
    FMode: {$IFNDEF FPC}PDeviceMode{$ELSE}PDeviceModeW{$ENDIF};
    procedure CreateDevMode;
    procedure FreeDevMode;
    procedure GetDC;
  public
    destructor Destroy; override;
    procedure Init; override;
    procedure RecreateDC;
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
    property DeviceMode: {$IFNDEF FPC}PDeviceMode{$ELSE}PDeviceModeW{$ENDIF} read FMode;
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

uses frxUtils, {$IFDEF FPC}WinUtilPrn, lazutf8,{$ELSE}WinSpool,{$ENDIF} Dialogs, frxRes;


{$IFDEF FPC}
{type

    _PRINTER_DEFAULTSA = record
       pDatatype : LPSTR;
       pDevMode : LPDEVMODE;
       DesiredAccess : ACCESS_MASK;
    end;
  PRINTER_DEFAULTSA = _PRINTER_DEFAULTSA;
  PPRINTER_DEFAULTSA = ^_PRINTER_DEFAULTSA;
  LPPRINTER_DEFAULTSA = ^_PRINTER_DEFAULTSA;


function OpenPrinter(_para1:LPSTR; _para2:PHANDLE; _para3:LPPRINTER_DEFAULTSA):BOOL;stdcall; external LibWinSpool name 'OpenPrinterA';
function DocumentProperties(_para1:HWND; _para2:HANDLE; _para3:LPSTR; _para4:PDEVMODE; _para5:PDEVMODE; _para6:DWORD):LONG;stdcall; external LibWinSpool name 'DocumentPropertiesA';}
function EnumPrinters(_para1:DWORD; _para2:LPSTR; _para3:DWORD; _para4:PBYTE; _para5:DWORD; _para6:PDWORD; _para7:PDWORD):BOOL;stdcall; external LibWinSpool name 'EnumPrintersA';
{$ENDIF}


type
  TPaperInfo = {packed} record
    Typ: Integer;
    Name: String;
    X, Y: Integer;
  end;


const
  winspoolDrv = 'winspool.drv';
{$IFDEF DELPHI12}
  GetDefPrinter = 'GetDefaultPrinterW';
{$ELSE}
  GetDefPrinter = 'GetDefaultPrinterA';
{$ENDIF}
  PAPERCOUNT = 66;
  PaperInfo: array[0..PAPERCOUNT - 1] of TPaperInfo = (
    (Typ:1;  Name: ''; X:2159; Y:2794),
    (Typ:2;  Name: ''; X:2159; Y:2794),
    (Typ:3;  Name: ''; X:2794; Y:4318),
    (Typ:4;  Name: ''; X:4318; Y:2794),
    (Typ:5;  Name: ''; X:2159; Y:3556),
    (Typ:6;  Name: ''; X:1397; Y:2159),
    (Typ:7;  Name: ''; X:1842; Y:2667),
    (Typ:8;  Name: ''; X:2970; Y:4200),
    (Typ:9;  Name: ''; X:2100; Y:2970),
    (Typ:10; Name: ''; X:2100; Y:2970),
    (Typ:11; Name: ''; X:1480; Y:2100),
    (Typ:12; Name: ''; X:2500; Y:3540),
    (Typ:13; Name: ''; X:1820; Y:2570),
    (Typ:14; Name: ''; X:2159; Y:3302),
    (Typ:15; Name: ''; X:2150; Y:2750),
    (Typ:16; Name: ''; X:2540; Y:3556),
    (Typ:17; Name: ''; X:2794; Y:4318),
    (Typ:18; Name: ''; X:2159; Y:2794),
    (Typ:19; Name: ''; X:984;  Y:2254),
    (Typ:20; Name: ''; X:1048; Y:2413),
    (Typ:21; Name: ''; X:1143; Y:2635),
    (Typ:22; Name: ''; X:1207; Y:2794),
    (Typ:23; Name: ''; X:1270; Y:2921),
    (Typ:24; Name: ''; X:4318; Y:5588),
    (Typ:25; Name: ''; X:5588; Y:8636),
    (Typ:26; Name: ''; X:8636; Y:11176),
    (Typ:27; Name: ''; X:1100; Y:2200),
    (Typ:28; Name: ''; X:1620; Y:2290),
    (Typ:29; Name: ''; X:3240; Y:4580),
    (Typ:30; Name: ''; X:2290; Y:3240),
    (Typ:31; Name: ''; X:1140; Y:1620),
    (Typ:32; Name: ''; X:1140; Y:2290),
    (Typ:33; Name: ''; X:2500; Y:3530),
    (Typ:34; Name: ''; X:1760; Y:2500),
    (Typ:35; Name: ''; X:1760; Y:1250),
    (Typ:36; Name: ''; X:1100; Y:2300),
    (Typ:37; Name: ''; X:984;  Y:1905),
    (Typ:38; Name: ''; X:920;  Y:1651),
    (Typ:39; Name: ''; X:3778; Y:2794),
    (Typ:40; Name: ''; X:2159; Y:3048),
    (Typ:41; Name: ''; X:2159; Y:3302),
    (Typ:42; Name: ''; X:2500; Y:3530),
    (Typ:43; Name: ''; X:1000; Y:1480),
    (Typ:44; Name: ''; X:2286; Y:2794),
    (Typ:45; Name: ''; X:2540; Y:2794),
    (Typ:46; Name: ''; X:3810; Y:2794),
    (Typ:47; Name: ''; X:2200; Y:2200),
    (Typ:50; Name: ''; X:2355; Y:3048),
    (Typ:51; Name: ''; X:2355; Y:3810),
    (Typ:52; Name: ''; X:2969; Y:4572),
    (Typ:53; Name: ''; X:2354; Y:3223),
    (Typ:54; Name: ''; X:2101; Y:2794),
    (Typ:55; Name: ''; X:2100; Y:2970),
    (Typ:56; Name: ''; X:2355; Y:3048),
    (Typ:57; Name: ''; X:2270; Y:3560),
    (Typ:58; Name: ''; X:3050; Y:4870),
    (Typ:59; Name: ''; X:2159; Y:3223),
    (Typ:60; Name: ''; X:2100; Y:3300),
    (Typ:61; Name: ''; X:1480; Y:2100),
    (Typ:62; Name: ''; X:1820; Y:2570),
    (Typ:63; Name: ''; X:3220; Y:4450),
    (Typ:64; Name: ''; X:1740; Y:2350),
    (Typ:65; Name: ''; X:2010; Y:2760),
    (Typ:66; Name: ''; X:4200; Y:5940),
    (Typ:67; Name: ''; X:2970; Y:4200),
    (Typ:68; Name: ''; X:3220; Y:4450));


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
  FName := AName;
  FPort := APort;

  FBins := TStringList.Create;
  FBins.AddObject(frxResources.Get('prDefault'), Pointer(DMBIN_AUTO));

  FPapers := TStringList.Create;
  FPapers.AddObject(frxResources.Get('prCustom'), Pointer(256));

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
    if Integer(FBins.Objects[i]) = ABin then
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
    if Integer(FPapers.Objects[i]) = APaper then
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
  Result := Integer(FBins.Objects[i]);
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
    FPapers.AddObject(PaperInfo[i].Name, Pointer(PaperInfo[i].Typ));

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

  procedure FillPapers;
  var
    i, PaperSizesCount: Integer;
    PaperSizes: array[0..511] of Word;
    PaperNames: {$IFNDEF FPC}PChar{$ELSE}PWideChar{$ENDIF};
{$IFDEF FPC}
    ss:string;
{$ENDIF}
  begin
    FillChar(PaperSizes, SizeOf(PaperSizes), 0);
    {$IFDEF FPC}
    PaperSizesCount := DeviceCapabilitiesW(PWideChar(UTF8ToUTF16(FName)),
      PWideChar(UTF8ToUTF16(FPort)), DC_PAPERS, @PaperSizes, FMode);
    {$ELSE}
    PaperSizesCount := DeviceCapabilities(PChar(FName), PChar(FPort), DC_PAPERS, @PaperSizes, FMode);
    {$ENDIF}
    GetMem(PaperNames, PaperSizesCount * 64 * sizeof({$IFNDEF FPC}char{$ELSE}WideChar{$ENDIF}));
    {$IFDEF FPC}
    DeviceCapabilitiesW(PWideChar(UTF8ToUTF16(UTF8ToUTF16(FName))),
      PWideChar(UTF8ToUTF16(FPort)), DC_PAPERNAMES, PaperNames, FMode);
    {$ELSE}
    DeviceCapabilities(PChar(FName), PChar(FPort), DC_PAPERNAMES, PaperNames, FMode);
    {$ENDIF}
    for i := 0 to PaperSizesCount - 1 do
      if PaperSizes[i] <> 256 then
{$IFDEF Delphi12}
        FPapers.AddObject(StrPas(PWideChar(PaperNames + i * 64)), Pointer(PaperSizes[i]));
{$ELSE}
      begin
       {$IFDEF FPC}
       ss :=  SysToUtf8(StrPas(PWideChar(PaperNames + i * 64)));
       FPapers.AddObject(ss, Pointer(PaperSizes[i]));
       {$ELSE}
        FPapers.AddObject(StrPas(PAnsiChar(PaperNames + i * 64)), Pointer(PaperSizes[i]));
       {$ENDIF}
      end;
{$ENDIF}

    FreeMem(PaperNames, PaperSizesCount * 64 * sizeof({$IFNDEF FPC}char{$ELSE}WideChar{$ENDIF}));
  end;

  procedure FillBins;
  var
    i, BinsCount: Integer;
    BinNumbers: array[0..255] of Word;
    BinNames: {$IFNDEF FPC}PChar{$ELSE}PWideChar{$ENDIF};
  begin
    FillChar(BinNumbers, SizeOf(BinNumbers), 0);
{$IFDEF FPC}
    BinsCount := DeviceCapabilitiesW(PWideChar(UTF8ToUTF16(FName)),
      PWideChar(UTF8ToUTF16(FPort)), DC_BINS, @BinNumbers[0], FMode);
{$ELSE}
    BinsCount := DeviceCapabilities(PChar(FName), PChar(FPort), DC_BINS, @BinNumbers[0], FMode);
{$ENDIF}
    GetMem(BinNames, BinsCount * 24 * sizeof({$IFNDEF FPC}char{$ELSE}WideChar{$ENDIF}));
    try
{$IFDEF FPC}
      DeviceCapabilitiesW(PWideChar(UTF8ToUTF16(FName)),
        PWideChar(UTF8ToUTF16(FPort)), DC_BINNAMES, BinNames, FMode);
{$ELSE}
      DeviceCapabilities(PChar(FName), PChar(FPort), DC_BINNAMES, BinNames, FMode);
{$ENDIF}
    except
    end;

    for i := 0 to BinsCount - 1 do
      if BinNumbers[i] <> DMBIN_AUTO then
{$IFDEF Delphi12}
        FBins.AddObject(StrPas(PwideChar(BinNames + i * 24)), Pointer(BinNumbers[i]));
{$ELSE}
        FBins.AddObject(StrPas(BinNames + i * 24), Pointer(BinNumbers[i]));
{$ENDIF}

    FreeMem(BinNames, BinsCount * 24 * sizeof({$IFNDEF FPC}Char{$ELSE}WideChar{$ENDIF}));
  end;

begin
  if FInitialized then Exit;
  CreateDevMode;
  if FDeviceMode = 0 then Exit;
  RecreateDC;

  if not UpdateDeviceCaps then
  begin
    FreeDevMode;
    Exit;
  end;

  FDefPaper := FMode.dmPaperSize;
  FDefBin := FMode.dmDefaultSource;
  FDefDuplex := FMode.dmDuplex;
  FPaper := FDefPaper;
  FDefPaperWidth := FPaperWidth;
  FDefPaperHeight := FPaperHeight;
  if FMode.dmOrientation = DMORIENT_PORTRAIT then
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
  AbortDoc(FDC);
  EndDoc;
end;

procedure TfrxPrinter.BeginDoc;
var
  DocInfo: {$IFNDEF FPC}TDocInfo{$ELSE}TDocInfoW{$ENDIF};
begin
  FPrinting := True;

  FillChar(DocInfo, SizeOf(DocInfo), 0);
  DocInfo.cbSize := SizeOf(DocInfo);
  if FTitle <> '' then
    DocInfo.lpszDocName := {$IFNDEF FPC}PChar(FTitle){$ELSE}
    PWideChar(UTF8ToUTF16(FTitle)){$ENDIF}
  else DocInfo.lpszDocName :=
    {$IFNDEF FPC}PChar('Fast Report Document'){$ELSE}
    PWideChar(UTF8ToUTF16('Fast Report Document')){$ENDIF};

  if FFileName <> '' then
    DocInfo.lpszOutput := {$IFNDEF FPC}PChar(FFileName){$ELSE}
      PWideChar(UTF8ToUTF16(FFileName)){$ENDIF};

  RecreateDC;
  {$IFDEF FPC}
  StartDoc(FDC, @DocInfo);
  {$ELSE}
  StartDoc(FDC, DocInfo);
  {$ENDIF}
end;

procedure TfrxPrinter.BeginPage;
begin
  StartPage(FDC);
end;

procedure TfrxPrinter.EndDoc;
var
  Saved8087CW: Word;
begin
  Saved8087CW := Default8087CW;
  Set8087CW($133F);
  try
    Windows.EndDoc(FDC);
  except
  end;
  Set8087CW(Saved8087CW);

  FPrinting := False;
  RecreateDC;
  FBin := -1;
  FDuplex := -1;

  FMode.dmFields := FMode.dmFields or DM_DEFAULTSOURCE or DM_DUPLEX;
  FMode.dmDefaultSource := FDefBin;
  FMode.dmDuplex := FDefDuplex;
  {$IFDEF FPC}
  FDC := Windows.ResetDCW(FDC, FMode);
  {$ELSE}
  FDC := ResetDC(FDC, FMode^);
  {$ENDIF}
end;

procedure TfrxPrinter.EndPage;
begin
  Windows.EndPage(FDC);
end;

procedure TfrxPrinter.BeginRAWDoc;
var
  DocInfo1: TDocInfo1;
begin
  RecreateDC;
  DocInfo1.pDocName := PChar(FTitle);
  DocInfo1.pOutputFile := nil;
  DocInfo1.pDataType := 'RAW';
  StartDocPrinter(FHandle, 1, @DocInfo1);
  StartPagePrinter(FHandle);
end;

procedure TfrxPrinter.EndRAWDoc;
begin
  EndPagePrinter(FHandle);
  EndDocPrinter(FHandle);
end;

procedure TfrxPrinter.WriteRAWDoc(const buf: AnsiString);
var
  N: DWORD;
begin
  {$IFDEF FPC}
  WritePrinter(FHandle, PAnsiChar(buf), Length(buf), @N);
  {$ELSE}
  WritePrinter(FHandle, PAnsiChar(buf), Length(buf), N);
  {$ENDIF}
end;

procedure TfrxPrinter.CreateDevMode;
var
  bufSize: Integer;
{$IFNDEF Delphi12}
  dm: {$IFNDEF FPC}TDeviceMode{$ELSE}TDeviceModeW{$ENDIF};
{$ENDIF}
begin
  {$IFDEF FPC}
    if OpenPrinterW(PWideChar(UTF8ToUTF16(FName)), @FHandle, nil) then
  {$ELSE}
  if OpenPrinter(PChar(FName), FHandle, nil) then
  {$ENDIF}
  begin
{$IFDEF Delphi12}
    bufSize := DocumentProperties(0, FHandle, PChar(FName), nil, nil, 0);
{$ELSE}
{$IFDEF FPC}
    bufSize := DocumentPropertiesW(0, FHandle, PWideChar(UTF8ToUTF16(FName)),
                                    nil, nil,0);
{$ELSE}
    bufSize := DocumentProperties(0, FHandle, PChar(FName), dm, dm, 0);
{$ENDIF}
{$ENDIF}
    if bufSize > 0 then
    begin
      FDeviceMode := GlobalAlloc(GHND, bufSize);
      if FDeviceMode <> 0 then
      begin
        FMode := GlobalLock(FDeviceMode);
        {$IFDEF FPC}
        if DocumentPropertiesW(0, FHandle, PWideChar(UTF8ToUTF16(FName)),
          FMode, FMode, DM_OUT_BUFFER) < 0 then
        {$ELSE}
        if DocumentProperties(0, FHandle, PChar(FName), FMode^, FMode^,
          DM_OUT_BUFFER) < 0 then
        {$ENDIF}
        begin
          GlobalUnlock(FDeviceMode);
          GlobalFree(FDeviceMode);
          FDeviceMode := 0;
          FMode := nil;
        end
      end;
    end;
  end;
end;

procedure TfrxPrinter.FreeDevMode;
begin
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
end;

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
    if FPrinting then
    {$IFNDEF FPC}
      FDC := CreateDC(PChar(FDriver), PChar(FName), nil, FMode) else
      FDC := CreateIC(PChar(FDriver), PChar(FName), nil, FMode);
    {$ELSE}
      FDC := CreateDCW(PWideChar(UTF8ToUTF16(FDriver)),
        PWideChar(UTF8ToUTF16(FName)), nil, FMode)
    else
      FDC := CreateICW(PWideChar(UTF8ToUTF16(FDriver)),
        PWideChar(UTF8ToUTF16(FName)), nil, FMode);
    {$ENDIF}
    FCanvas.Handle := FDC;
    FCanvas.Refresh;
    FCanvas.UpdateFont;
  end;
end;


procedure TfrxPrinter.SetViewParams(APaperSize: Integer;
  APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation);
var
  aPaperNotFound: Boolean;
  i, aPaper: Integer;
begin
  // if printer has only custom size, prevent the recursion
  aPaperNotFound := (APaperSize = -1);
  // printer doesnt have such paper size , use custom insted
  if (APaperSize <> 256) and (PaperIndex(APaperSize) = -1) then
    APaperSize := 256;

  if (APaperSize <> 256) or aPaperNotFound then
  begin
    FMode.dmFields := DM_PAPERSIZE or DM_ORIENTATION;
    FMode.dmPaperSize := APaperSize;
    if AOrientation = poPortrait then
      FMode.dmOrientation := DMORIENT_PORTRAIT else
      FMode.dmOrientation := DMORIENT_LANDSCAPE;
    RecreateDC;
    if not UpdateDeviceCaps then Exit;
  end
  else
  begin
    // copy the margins from A4 paper
    // when printer doesn't have A4, copy margins from first available size
    aPaper := DMPAPER_A4;
    if PaperIndex(aPaper) = -1 then aPaper := -1;

    if (FPapers.Count > 1) and (APaper = -1) then
      for i := 0 to FPapers.Count - 1 do
        if Integer(FPapers.Objects[i]) <> 256 then
        begin
          aPaper := Integer(FPapers.Objects[i]);
          break;
        end;
    SetViewParams(aPaper, 0, 0, AOrientation);
    FPaperHeight := APaperHeight;
    FPaperWidth := APaperWidth;
  end;

  FPaper := APaperSize;
  FOrientation := AOrientation;
end;

procedure TfrxPrinter.SetPrintParams(APaperSize: Integer;
  APaperWidth, APaperHeight: Extended; AOrientation: TPrinterOrientation;
  ABin, ADuplex, ACopies: Integer);
begin
  FMode.dmFields := FMode.dmFields or DM_PAPERSIZE or DM_ORIENTATION or DM_COPIES
    or DM_DEFAULTSOURCE or DM_COLLATE;

  // printer doesnt have such paper size , use custom insted
  if (APaperSize <> 256) and (PaperIndex(APaperSize) = -1) then
    APaperSize := 256;

  if APaperSize = 256 then
  begin
    FMode.dmFields := FMode.dmFields or DM_PAPERLENGTH or DM_PAPERWIDTH;
    if AOrientation = poLandscape then
    begin
      FMode.dmPaperLength := Round(APaperWidth * 10);
      FMode.dmPaperWidth := Round(APaperHeight * 10);
    end
    else
    begin
      FMode.dmPaperLength := Round(APaperHeight * 10);
      FMode.dmPaperWidth := Round(APaperWidth * 10);
    end;
  end
  else
  begin
    FMode.dmPaperLength := 0;
    FMode.dmPaperWidth := 0;
  end;

  FMode.dmPaperSize := APaperSize;
  if AOrientation = poPortrait then
    FMode.dmOrientation := DMORIENT_PORTRAIT else
    FMode.dmOrientation := DMORIENT_LANDSCAPE;

  FMode.dmCopies := ACopies;
  FMode.dmCollate := DMCOLLATE_FALSE;

  if ABin = DMBIN_AUTO then
    if FBin <> -1 then
      ABin := FBin
    else
      ABin := DefBin;
  FMode.dmDefaultSource := ABin;

  if ADuplex = 0 then
    ADuplex := FDefDuplex
  else Inc(ADuplex);
  if ADuplex = 4 then
    ADuplex := DMDUP_SIMPLEX;
  if FDuplex <> -1 then
    ADuplex := FDuplex;
  if ADuplex <> 1 then
    FMode.dmFields := FMode.dmFields  or DM_DUPLEX;
  FMode.dmDuplex := ADuplex;

  FDC := {$IFNDEF FPC}ResetDC(FDC, FMode^){$ELSE}
    ResetDCW(FDC, FMode){$ENDIF};
  FDC := {$IFNDEF FPC}ResetDC(FDC, FMode^){$ELSE}
    ResetDCW(FDC, FMode){$ENDIF};  // needed for some printers
  FCanvas.Refresh;
  if not UpdateDeviceCaps then Exit;
  FPaper := APaperSize;
  FOrientation := AOrientation;
end;

function TfrxPrinter.UpdateDeviceCaps: Boolean;
begin
  Result := True;
  if FDC = 0 then GetDC;

  FDPI := Point(GetDeviceCaps(FDC, LOGPIXELSX), GetDeviceCaps(FDC, LOGPIXELSY));
  if (FDPI.X = 0) or (FDPI.Y = 0) then
  begin
    Result := False;
    frxErrorMsg('Printer selected is not valid');
    Exit;
  end;
  FPaperHeight := Round(GetDeviceCaps(FDC, PHYSICALHEIGHT) / FDPI.Y * 25.4);
  FPaperWidth := Round(GetDeviceCaps(FDC, PHYSICALWIDTH) / FDPI.X * 25.4);
  FLeftMargin := Round(GetDeviceCaps(FDC, PHYSICALOFFSETX) / FDPI.X * 25.4);
  FTopMargin := Round(GetDeviceCaps(FDC, PHYSICALOFFSETY) / FDPI.Y * 25.4);
  FRightMargin := FPaperWidth - Round(GetDeviceCaps(FDC, HORZRES) / FDPI.X * 25.4) - FLeftMargin;
  FBottomMargin := FPaperHeight - Round(GetDeviceCaps(FDC, VERTRES) / FDPI.Y * 25.4) - FTopMargin;
end;

procedure TfrxPrinter.PropertiesDlg;
var
  h: THandle;
  PrevDuplex: Integer;
begin
  PrevDuplex := FMode.dmDuplex;
  if Screen.ActiveForm <> nil then
    h := Screen.ActiveForm.Handle else
    h := 0;
  {$IFDEF FPC}
  if DocumentPropertiesW(h, FHandle, PWideChar(UTF8ToUTF16(FName)), FMode,
    FMode, DM_IN_BUFFER or DM_OUT_BUFFER or DM_IN_PROMPT) > 0 then
  {$ELSE}
  if DocumentProperties(h, FHandle, PChar(FName), FMode^,
    FMode^, DM_IN_BUFFER or DM_OUT_BUFFER or DM_IN_PROMPT) > 0 then
  {$ENDIF}
  begin
    FBin := FMode.dmDefaultSource;
    FDefBin := FMode.dmDefaultSource;
    if PrevDuplex <> FMode.dmDuplex then
      FDuplex := FMode.dmDuplex;
    RecreateDC;
  end;
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
    PrinterIndex := IndexOf(Trim(GetDefaultPrinter));
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
    Result := FPrinterList[Index]
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
    Items[FPrinterIndex].Init;
end;

function TfrxPrinters.GetCurrentPrinter: TfrxCustomPrinter;
begin
  Result := Items[PrinterIndex];
end;

type
  TfrxGetDefaultPrinter = function (DefaultPrinter: PChar; var I: Integer): BOOL; stdcall;

function TfrxPrinters.GetDefaultPrinter: String;
var
  prnName: array[0..255] of Char;
  Ver: TOsVersionInfo;
  FLibHandle: THandle;
  GetDefPrn: TfrxGetDefaultPrinter;
  prnBuffSize: Integer;
begin
  Ver.dwOSVersionInfoSize := SizeOf(Ver);
  GetVersionEx(Ver);
  if (Ver.dwPlatformId = VER_PLATFORM_WIN32_NT) and (Ver.dwMajorVersion >= 5) then
  begin
    prnBuffSize := 0;
    FLibHandle := LoadLibrary(winspoolDrv);
    if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then FLibHandle := 0;
    if FLibHandle <> 0 then
    begin
      GetDefPrn := GetProcAddress(FLibHandle, GetDefPrinter);
      if Assigned(GetDefPrn) then
      begin
        GetDefPrn(nil, prnBuffSize);
        if (prnBuffSize > 0) then
        begin
          SetLength(Result, prnBuffSize);
          GetDefPrn(@Result[1], prnBuffSize);
          Exit;
        end;
      end;

    end;
  end;

  GetProfileString('windows', 'device', '', prnName,  255);
  Result := Copy(prnName, 1, Pos(',', prnName) - 1);
end;

procedure TfrxPrinters.FillPrinters;
var
  i, j: Integer;
  Buf, prnInfo: PByte;
  Flags, bufSize, prnCount: DWORD;
  Level: Byte;
  sl, sl1: TStringList;

  procedure AddPrinter(ADevice, APort: String); overload;
  begin
    sl1.AddObject(ADevice, TfrxPrinter.Create(ADevice, APort));
  end;

  procedure AddPrinter(ADevice: string; APrinter: TObject); overload;
  begin
    FPrinterList.Add(APrinter);
    FPrinters.Add(ADevice);
  end;

  procedure AddPrinters;
  var i: integer;
  begin
    sl1.Sorted := true;
    for i := 0 to sl1.Count - 1 do
      AddPrinter(sl1[i], sl1.Objects[i]);
  end;


begin
  Clear;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    Flags := PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL;
    Level := 4;
  end
  else
  begin
    Flags := PRINTER_ENUM_LOCAL;
    Level := 5;
  end;

  bufSize := 0;
  {$IFDEF FPC}
  EnumPrinters(Flags, nil, Level, nil, 0, @bufSize, @prnCount);
  {$ELSE}
  EnumPrinters(Flags, nil, Level, nil, 0, bufSize, prnCount);
  {$ENDIF}
  if bufSize = 0 then Exit;

  GetMem(Buf, bufSize);
  sl1 := TStringList.Create;
  sl1.Sorted := false;
  try

    {$IFDEF FPC}
    if not EnumPrinters(Flags, nil, Level, PByte(Buf), bufSize, @bufSize, @prnCount) then
    {$ELSE}
    if not EnumPrinters(Flags, nil, Level, PByte(Buf), bufSize, bufSize, prnCount) then
    {$ENDIF}
      Exit;
    prnInfo := Buf;
    for i := 0 to prnCount - 1 do
      if Level = 4 then
        with PPrinterInfo4(prnInfo)^ do
        begin
          AddPrinter(pPrinterName, '');
          Inc(prnInfo, SizeOf(TPrinterInfo4));
        end
      else
        with PPrinterInfo5(prnInfo)^ do
        begin
          sl := TStringList.Create;
          frxSetCommaText(pPortName, sl, ',');

          for j := 0 to sl.Count - 1 do
           AddPrinter(pPrinterName, sl[j]);

          sl.Free;
          Inc(prnInfo, SizeOf(TPrinterInfo5));
        end;

  finally
    AddPrinters;
    FreeAndNil(sl1);
    FreeMem(Buf, bufSize);
  end;
end;



function frxPrinters: TfrxPrinters;
begin
  if FPrinters = nil then
    FPrinters := TfrxPrinters.Create;
  Result := FPrinters;
end;

initialization

finalization
  if FPrinters <> nil then
    FPrinters.Free;
  FPrinters := nil;
{$ENDIF}
end.
