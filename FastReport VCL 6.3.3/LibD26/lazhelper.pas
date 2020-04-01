unit LazHelper;
interface
{$I frx.inc}
uses
  SysUtils, Classes, Controls, LCLType, LMessages,
  Graphics, ExtCtrls, LazUTF8, LCLIntf, MaskEdit, Forms, Buttons
  ,lmf4, typinfo, types
{$IFNDEF NONWINFPC}
  ,Windows, Messages, Registry
{$ENDIF}
{$IFDEF LCLGTK2}
  ,gdk2pixbuf, glib2, gdk2, gtk2, Pango, Gtk2FontCache
  ,Gtk2Globals, Gtk2Def,  Gtk2Proc
{$ENDIF}
  ;
const
  MAC_CHARSET = 7;
  VIETNAMESE_CHARSET = 163;
  JOHAB_CHARSET = 130;

  DMBIN_UPPER = 1;
  DMBIN_FIRST = DMBIN_UPPER;
  DMBIN_ONLYONE = 1;
  DMBIN_LOWER = 2;
  DMBIN_MIDDLE = 3;
  DMBIN_MANUAL = 4;
  DMBIN_ENVELOPE = 5;
  DMBIN_ENVMANUAL = 6;
  DMBIN_AUTO = 7;
  DMBIN_TRACTOR = 8;
  DMBIN_SMALLFMT = 9;
  DMBIN_LARGEFMT = 10;
  DMBIN_LARGECAPACITY = 11;
  DMBIN_CASSETTE = 14;
  DMBIN_LAST = DMBIN_CASSETTE;
  DMBIN_USER = 256;

  DMPAPER_LETTER=1;//	US Letter 8 1/2 x 11 in
  DMPAPER_LETTERSMALL=2;//	US Letter Small 8 1/2 x 11 in
  DMPAPER_TABLOID=3;//	US Tabloid 11 x 17 in
  DMPAPER_LEDGER=4;//	US Ledger 17 x 11 in
  DMPAPER_LEGAL=5;//	US Legal 8 1/2 x 14 in
  DMPAPER_STATEMENT=6;//	US Statement 5 1/2 x 8 1/2 in
  DMPAPER_EXECUTIVE=7;//	US Executive 7 1/4 x 10 1/2 in
  DMPAPER_A3=8;//	A3 297 x 420 mm
  DMPAPER_A4=9;//	A4 210 x 297 mm
  DMPAPER_A4SMALL=10;//	A4 Small 210 x 297 mm
  DMPAPER_A5=11;//	A5 148 x 210 mm
  DMPAPER_B4=12;//	B4 (JIS) 257 x 364 mm
  DMPAPER_B5=13;//	B5 (JIS) 182 x 257 mm
  DMPAPER_FOLIO=14;//	Folio 8 1/2 x 13 in
  DMPAPER_QUARTO=15;//	Quarto 215 x 275 mm

  DMPAPER_10X14=16;//	10 x 14 in
  DMPAPER_11X17=17;//	11 x 17 in
  DMPAPER_NOTE=18;//	US Note 8 1/2 x 11 in
  DMPAPER_ENV_9=19;//	US Envelope #9 3 7/8 x 8 7/8
  DMPAPER_ENV_10=20;//	US Envelope #10 4 1/8 x 9 1/2
  DMPAPER_ENV_11=21;//	US Envelope #11 4 1/2 x 10 3/8
  DMPAPER_ENV_12=22;//	US Envelope #12 4 3/4 x 11 in
  DMPAPER_ENV_14=23;//	US Envelope #14 5 x 11 1/2
  DMPAPER_CSHEET=24;//	C size sheet
  DMPAPER_DSHEET=25;//	D size sheet
  DMPAPER_ESHEET=26;//	E size sheet
  DMPAPER_ENV_DL=27;//	Envelope DL 110 x 220mm
  DMPAPER_ENV_C5=28;//	Envelope C5 162 x 229 mm
  DMPAPER_ENV_C3=29;//	Envelope C3 324 x 458 mm
  DMPAPER_ENV_C4=30;//	Envelope C4 229 x 324 mm
  DMPAPER_ENV_C6=31;//	Envelope C6 114 x 162 mm
  DMPAPER_ENV_C65=32;//	Envelope C65 114 x 229 mm
  DMPAPER_ENV_B4=33;//	Envelope B4 250 x 353 mm
  DMPAPER_ENV_B5=34;//	Envelope B5 176 x 250 mm
  DMPAPER_ENV_B6=35;//	Envelope B6 176 x 125 mm
  DMPAPER_ENV_ITALY=36;//	Envelope 110 x 230 mm
  DMPAPER_ENV_MONARCH=37;//	US Envelope Monarch 3.875 x 7.5 in
  DMPAPER_ENV_PERSONAL=38;//	6 3/4 US Envelope 3 5/8 x 6 1/2 in
  DMPAPER_FANFOLD_US=39;//	US Std Fanfold 14 7/8 x 11 in
  DMPAPER_FANFOLD_STD_GERMAN=40;//	German Std Fanfold 8 1/2 x 12 in
  DMPAPER_FANFOLD_LGL_GERMAN=41;//	German Legal Fanfold 8 1/2 x 13 in
  DMPAPER_ISO_B4=42;//	B4 (ISO) 250 x 353 mm
  DMPAPER_JAPANESE_POSTCARD=43;//	Japanese Postcard 100 x 148 mm
  DMPAPER_9X11=44;//	9 x 11 in
  DMPAPER_10X11=45;//	10 x 11 in
  DMPAPER_15X11=46;//	15 x 11 in
  DMPAPER_ENV_INVITE=47;//	Envelope Invite 220 x 220 mm
  DMPAPER_RESERVED_48=48;//	RESERVED--DO NOT USE
  DMPAPER_RESERVED_49=49;//	RESERVED--DO NOT USE
  DMPAPER_A2 = 66;
  DMPAPER_A6 = 70;

  DMPAPER_FIRST = DMPAPER_LETTER;
  DMPAPER_LAST = DMPAPER_FANFOLD_LGL_GERMAN;
  DMPAPER_USER = 256;

  DMORIENT_PORTRAIT = 1;
  DMORIENT_LANDSCAPE = 2;

  DM_PAPERSIZE = 2;//1;
  DM_ORIENTATION = 1;//8;
  DM_COPIES = 16;
  DM_DUPLEX = 32;
  DM_DEFAULTSOURCE = 64;
  DM_PAPERLENGTH = 128;
  DM_PAPERWIDTH = 255;

  DMDUP_SIMPLEX = $01;
  DMDUP_VERTICAL = $02;
  DMDUP_HORIZONTAL = $03;

  DMCOLLATE_FALSE = 0;
  DMCOLLATE_TRUE = 1;

  srNone = '(None)';
  srUnknown = '(Unknown)';
  WM_PAINT = LM_PAINT;
  WM_SIZE = LM_SIZE;
  WM_ERASEBKGND = LM_ERASEBKGND;
  WM_HSCROLL = LM_HSCROLL;
  WM_VSCROLL = LM_VSCROLL;
  WM_GETDLGCODE = LM_GETDLGCODE;
  WM_SETTEXT = CM_TEXTCHANGED;
  WM_PARENTNOTIFY = LM_PARENTNOTIFY;
  WM_CREATE = LM_CREATE;
  WM_WINDOWPOSCHANGING = LM_WINDOWPOSCHANGING;
  WM_ACTIVATEAPP = LM_ACTIVATE;
  WM_SYSCOMMAND = LM_SYSCOMMAND;
  WM_SYSCOLORCHANGE = CM_SYSCOLORCHANGE;
  WM_USER = LM_USER;
  WM_KILLFOCUS = LM_KILLFOCUS;
  WM_SETFOCUS = LM_SETFOCUS;
  WM_MOVE = LM_MOVE;
  WM_ENABLE = LM_ENABLE;
  WM_QUIT = LM_QUIT;

  EM_FORMATRANGE = WM_USER + 57;
  EM_REPLACESEL          = $00C2;

  E_INVALIDARG = 80070057;

  CP_ACP = 0;

  MEM_COMMIT = $1000;
  MEM_RESERVE = $2000;
  MEM_RESET = $80000;
  MEM_LARGE_PAGES = $20000000;
  MEM_PHYSICAL = $400000;
  MEM_TOP_DOWN = $100000;
  MEM_WRITE_WATCH = $200000;

  MEM_DECOMMIT = $4000;
  MEM_RELEASE = $8000;

  PAGE_EXECUTE = $10;
  PAGE_EXECUTE_READ = $20;
  PAGE_EXECUTE_READWRITE = $40;
  PAGE_EXECUTE_WRITECOPY = $80;
  PAGE_NOACCESS = $01;
  PAGE_READONLY = $02;
  PAGE_READWRITE = $04;
  PAGE_WRITECOPY = $08;
  PAGE_GUARD = $100;
  PAGE_NOCACHE = $200;
  PAGE_WRITECOMBINE = $400;


  STRETCH_ANDSCANS = $01;
  STRETCH_ORSCANS = $02;
  STRETCH_DELETESCANS = $03;
  STRETCH_HALFTONE = $04;



type
  UINT = Cardinal;
  TMessage = TLMessage;
  TWMCommand = TLMCommand;
  TWMGetDlgCode = TLMNoParams;
  TWMHScroll = TLMHScroll;
  TWMVScroll = TLMVScroll;
  TWMPaint = TLMPaint;
  TWMSize = TLMSize;
  TWMActivateApp = TLMessage;
  TWMSysCommand = TLMSysCommand;
  TWMKillFocus = TLMKillFocus;
  TWMSetFocus = TLMSetFocus;
  TWMMove = TLMMove;
  TSmallRect = TRect;
  TDTDateFormat = (dfShort, dfLong);
  TDateTimeKind = (dtkDate, dtkTime);
  TButtonStyle = (bsAutoDetect, bsWin31, bsNew);
  {$IFDEF MSWINDOWS}
  PRect   = ^TRect;
  {$ENDIF}

  {$note PDeviceMode added just until compiles ok}
  {$IFDEF NONWINFPC}
  PDeviceMode = ^TDeviceMode;
  TDeviceMode =  packed Record
    dmDeviceName      : array[0..31] of AnsiChar;
    dmSpecVersion     : Word;
    dmDriverVersion   : Word;
    dmSize            : Word;
    dmDriverExtra     : Word;
    dmFields          : DWORD;
    dmOrientation     : SHORT;
    dmPaperSize       : SHORT;
    dmPaperLength     : SHORT;
    dmPaperWidth      : SHORT;
    dmScale           : SHORT;
    dmCopies          : SHORT;
    dmDefaultSource   : SHORT;
    dmPrintQuality    : SHORT;
    dmColor           : SHORT;
    dmDuplex          : SHORT;
    dmYResolution     : SHORT;
    dmTTOption        : SHORT;
    dmCollate         : SHORT;
    dmFormName        : Array[0..31] of AnsiChar;
    dmLogPixels       : Word;
    dmBitsPerPel      : DWORD;
    dmPelsWidth       : DWORD;
    dmPelsHeight      : DWORD;
    dmDisplayFlags    : DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod       : DWORD;
    dmICMIntent       : DWORD;
    dmMediaType       : DWORD;
    dmDitherType      : DWORD;
    dmICCManufacturer : DWORD;
    dmICCModel        : DWORD;
    dmPanningWidth    : DWORD;
    dmPanningHeight   : DWORD;
  end;
  {$ENDIF}

  _charrange = record
    cpMin: Longint;
    cpMax: LongInt;
  end;
  TCharRange = _charrange;
  CHARRANGE = _charrange;

  _formatrange = record
    hdc: HDC;
    hdcTarget: HDC;
    rc: TRect;
    rcPage: TRect;
    chrg: TCharRange;
  end;
  TFormatRange = _formatrange;
  FORMATRANGE = _formatrange;

  TDateTimePicker = class(TMaskEdit)
  public
    Date: TDate;
    Time: TTime;
    DateFormat: TDTDateFormat;
    Kind: TDateTimeKind;
  end;

  TOleContainer = class(TPanel)
  end;

  PANOSE = cardinal;
  (*
  PANOSE = ^tagPanose;
  tagPANOSE = record
    bFamilyType: Byte;
    bSerifStyle: Byte;
    bWeight: Byte;
    bProportion: Byte;
    bContrast: Byte;
    bStrokeVariation: Byte;
    bArmStyle: Byte;
    bLetterform: Byte;
    bMidline: Byte;
    bXHeight: Byte;
  end;
  *)

  OUTLINETEXTMETRIC  = ^TOUTLINETEXTMETRIC;
  TOUTLINETEXTMETRIC = packed record
    otmSize: PtrUInt;
    otmTextMetrics: TEXTMETRIC;
    otmFiller: BYTE;
    otmPanoseNumber: PANOSE;
    otmfsSelection: PtrUInt;
    otmfsType: PtrUInt;
    otmsCharSlopeRise: PtrInt;
    otmsCharSlopeRun: PtrInt;
    otmItalicAngle: PtrInt;
    otmEMSquare: PtrUint;
    otmAscent: PtrInt;
    otmDescent: PtrInt;
    otmLineGap: PtrUInt;
    otmsCapEmHeight: PtrUInt;
    otmsXHeight: PtrUInt;
    otmrcFontBox: TRect;
    otmMacAscent: PtrInt;
    otmMacDescent: PtrInt;
    otmMacLineGap: PtrUInt;
    otmusMinimumPPEM: PtrUInt;
    otmptSubscriptSize: TPoint;
    otmptSubscriptOffset: TPoint;
    otmptSuperscriptSize: TPoint;
    otmptSuperscriptOffset: TPoint;
    otmsStrikeoutSize: PtrUInt;
    otmsStrikeoutPosition: PtrInt;
    otmsUnderscoreSize: PtrInt;
    otmsUnderscorePosition: PtrInt;
    otmpFamilyName: PChar;
    otmpFaceName: PChar;
    otmpStyleName: PChar;
    otmpFullName: PChar;
  end;
  OUTLINETEXTMETRICA = OUTLINETEXTMETRIC;

// OUTLINETEXTMETRIC, *POUTLINETEXTMETRIC;



  {$IFDEF NOUSEFRUNICODEUTILS}
  TWString = record
    WString: String;
    Obj: TObject;
  end;

  TWideStrings = class(TStringList)
  end;
  {$ENDIF}

  { TControlBar }

  TControlBar = class(TPanel)
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TMetafile = class(TlmfImage)
  private
    FEnhanced: Boolean;
  published
    property Enhanced:Boolean read FEnhanced write FEnhanced;
  end;

  { TMetafileCanvas }

  TMetafileCanvas = class(TlmfCanvas)
  private
    FOriginalHandle: HDC;
  public
    constructor Create(Meta:TMetafile; Ref:Integer);
    destructor Destroy; override;
   end;

  TIntArray = array[0..MaxInt div 4 - 1] of Integer;
  PIntArray = ^TIntArray;


function isDBCSLeadByte(Const AByte: Byte): Boolean;
function GetWindowDC(AHWND: HWND): HDC;
procedure MessageBeep(AParam: Integer);
function DrawTextBiDiModeFlags(Const AParam: Integer): Integer;
function GetDoubleClickTime: PtrUInt;
function ValidParentForm(AControl: TWinControl): TCustomForm;

function DrawButtonFace(Canvas: TCanvas; const Client: TRect;
  BevelWidth: Integer; Style: TButtonStyle; IsRounded, IsDown,
  IsFocused: Boolean): TRect;
procedure ZeroMemory(var AValue; ASize: Cardinal); overload;
procedure ZeroMemory(AMem: Pointer; ASize: Cardinal); overload;

procedure FillMemory(var AValue; ASize: Cardinal;B:Byte); overload;
procedure FillMemory(AMem: Pointer; ASize: Cardinal;B:Byte); overload;


function VirtualAlloc(APtrAddress: Pointer; const ASize: PtrUInt; const AAllocType: PtrInt;
  const AProtect: PtrInt = 0): Pointer;
function VirtualFree(APtrAddress: Pointer; const ASize: PtrUInt; const AAllocType: PtrInt): Boolean;

function HeapCreate(AFlags: PtrUInt; AInitialSize, AMaximumSize: PtrInt): PtrUInt;
function HeapAlloc(AHandle: PtrUInt; AFlags: PtrUInt; ASize: Byte): Pointer;
function HeapDestroy(AHeap: PtrUInt): Boolean;

{supports lmf too}
function ExtTextOutExtra(ACanvas: TCanvas; X, Y: Integer; AOptions: Longint;
  ARect: PRect; AStr: PChar; ACount: Longint; ADx: PInteger): Boolean;
function ExtTextOutExtrW(ACanvas: TCanvas; X, Y: Integer; AOptions: Longint;
  ARect: PRect; AStr: PWideChar; ACount: Longint; ADx: PInteger): Boolean;
function GetTextExtentExPointW(DC: HDC; Str: PWideChar; Count, MaxWidth: Integer;
  MaxCount, PartialWidths: PInteger; var Size: TSize): Boolean;


{$IFDEF NOUSEFRUNICODEUTILS}
function AnsiToUnicode(const s: {$IFDEF FPCUNICODE}String{$ELSE}AnsiString{$ENDIF}; Charset: UINT; CodePage: Integer = 0): {$IFDEF FPCUNICODE}String{$ELSE}AnsiString{$ENDIF};
function _UnicodeToAnsi(const WS: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF}; Charset: UINT; CodePage: Integer = 0): {$IFDEF FPCUNICODE}String{$ELSE}AnsiString{$ENDIF};
function OemToStr(const AnsiStr: {$IFDEF FPCUNICODE}String{$ELSE}AnsiString{$ENDIF}): {$IFDEF FPCUNICODE}String{$ELSE}AnsiString{$ENDIF};
function CharSetToCodePage(ciCharset: DWORD): Cardinal;
function GetLocalByCharSet(Charset: UINT): Cardinal;
{$ENDIF}


{avoid extra ifdefs inside units}
function GetEnumValue(TypeInfo : TTypeInfo;const Name : string) : Integer; overload;
function GetEnumName(TypeInfo : TTypeInfo;Value : Integer) : string; overload;
function GetTypeData(TypeInfo : TTypeInfo) : PTypeData; overload;
function GetTypeData(TypeInfo : PTypeInfo) : PTypeData; overload;

{$IFNDEF NONWINFPC}
function GetComboEditHandle(AComboBoxHandle: HWND): HWND;
function GetFontData(p1:HDC; p2:DWORD; p3:DWORD; p4:Pointer; p5:DWORD):DWORD;
{$ENDIF}
{$IFDEF LCLGTK2}
 procedure frxPaintWidget(AControl: TWinControl; ACanvas: TCanvas);
{$ENDIF}
function GetFileMIMEType(const Extension: String): String;

procedure Translate(WinControl: TWinControl);



implementation

uses
  frxUtils
  {$IFDEF USEVIRTUALMEMORYALLOCS}
  {$IFDEF MSWINDOWS}
  ,Windows
  {$ELSE}
  ,baseunix
  {$ENDIF}
  {$ENDIF}
  ;

{$IFDEF LCLGTK2}

function gtk_offscreen_window_new : PGtkWidget; cdecl; external 'libgdk-x11-2.0.so';
function gtk_offscreen_window_get_pixbuf (offscreen: PGtkWidget):PGdkPixbuf; cdecl; external 'libgdk-x11-2.0.so';

 procedure frxPaintWidget(AControl: TWinControl; ACanvas: TCanvas);
 var
   Pixbuf: PGdkPixbuf;
   AWindow: PGdkWindow;
   DC: TGtkDeviceContext;
   OffscreenW, OldW: PGtkWidget;
   AWidget: PGtkWidget;
 begin
   AWidget := GetFixedWidget({%H-}PGtkWidget(AControl.Handle));
   DC :=  TGtkDeviceContext(ACanvas.Handle);
   AWindow := GetControlWindow(AWidget);
   OffscreenW := gtk_offscreen_window_new;
   OldW := gtk_widget_get_parent(AWidget);
   gtk_widget_reparent(AWidget, OffscreenW);
   gtk_widget_realize(OffscreenW);
   gtk_widget_show_all(OffscreenW);
   gtk_widget_draw(AWidget, nil);
   Pixbuf := gtk_offscreen_window_get_pixbuf(OffscreenW);
   gdk_pixbuf_render_to_drawable(Pixbuf, DC.Drawable, DC.GC, 0, 0, 0, 0,
     -1, -1, GDK_RGB_DITHER_NONE, 0, 0);
   gdk_pixbuf_unref(Pixbuf);
   gtk_widget_reparent(AWidget, OldW);
   gtk_widget_destroy (OffscreenW);
 end;
{$ENDIF}

function GetEnumValue(TypeInfo : TTypeInfo;const Name : string) : Integer;
begin
  Result := typinfo.GetEnumValue(@TypeInfo, Name);
end;

function GetEnumName(TypeInfo : TTypeInfo;Value : Integer) : string;
begin
  Result := typinfo.GetEnumName(@TypeInfo, Value);
end;

function GetTypeData(TypeInfo : TTypeInfo) : PTypeData;
begin
  Result := typinfo.GetTypeData(@TypeInfo);
end;

function GetTypeData(TypeInfo : PTypeInfo) : PTypeData;
begin
  Result := typinfo.GetTypeData(TypeInfo);
end;

function VirtualAlloc(APtrAddress: Pointer; const ASize: PtrUInt; const AAllocType: PtrInt;
  const AProtect: PtrInt = 0): Pointer;
begin
  {$IFDEF USEVIRTUALMEMORYALLOCS}
  {$IFDEF MSWINDOWS}
  Result := VirtualAlloc(APtrAddress, ASize, AAllocType, AProtect);
  {$ELSE}
  Result := Fpmmap(APtrAddress, ASize, AProtect, AAllocType, 0, 0);
  {$ENDIF}
  {$ELSE}
  Result := nil;
  {$ENDIF}
end;

function VirtualFree(APtrAddress: Pointer; const ASize: PtrUInt; const AAllocType: PtrInt): Boolean;
begin
  {$IFDEF USEVIRTUALMEMORYALLOCS}
  {$IFDEF MSWINDOWS}
  Result := VirtualFree(APtrAddress, ASize, AAllocType);
  {$ELSE}
  Result := Fpmunmap(APtrAddress, ASize) > 0;
  {$ENDIF}
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function HeapCreate(AFlags: PtrUInt; AInitialSize, AMaximumSize: PtrInt): PtrUInt;
begin
  Result := 0;
end;

function HeapAlloc(AHandle: PtrUInt; AFlags: PtrUInt; ASize: Byte): Pointer;
begin
  Result := nil;
end;

function HeapDestroy(AHeap: PtrUInt): Boolean;
begin
  Result := False;
end;


procedure ZeroMemory(var AValue; ASize: Cardinal);
begin
  FillChar(AValue, ASize, 0);
end;

procedure ZeroMemory(AMem: Pointer; ASize: Cardinal);
begin
  FillChar(AMem, ASize, 0);
end;

procedure FillMemory(var AValue; ASize: Cardinal;B:Byte);
begin
  FillByte(AValue, ASize,B);
end;

procedure FillMemory(AMem: Pointer; ASize: Cardinal;B:Byte);
begin
  FillByte(AMem, ASize,B);
end;

function GetDoubleClickTime: PtrUInt;
begin
  Result := LCLIntf.GetDoubleClickTime;
end;

function ValidParentForm(AControl: TWinControl): TCustomForm;
begin
  Result := GetParentForm(AControl);
end;

function isDBCSLeadByte(Const AByte: Byte): Boolean;
begin
  Result := AByte in [$C4, $C5];
end;

procedure MessageBeep(AParam: Integer);
begin
  SysUtils.Beep;
end;

function DrawTextBiDiModeFlags(Const AParam: Integer): Integer;
begin
  Result := AParam or DT_LEFT;
end;

function GetWindowDC(AHWND: HWND): HDC;
begin
  Result := GetDC(AHWND);
end;

{ DrawButtonFace - returns the remaining usable area inside the Client rect.}
function DrawButtonFace(Canvas: TCanvas; const Client: TRect;
  BevelWidth: Integer; Style: TButtonStyle; IsRounded, IsDown,
  IsFocused: Boolean): TRect;
var
  NewStyle: Boolean;
  R: TRect;
  DC: THandle;
begin
  NewStyle := ((Style = bsAutoDetect) and NewStyleControls) or (Style = bsNew);

  R := Client;
  with Canvas do
  begin
    if NewStyle then
    begin
      Brush.Color := clBtnFace;
      Brush.Style := bsSolid;
      DC := Canvas.Handle;    { Reduce calls to GetHandle }

      if IsDown then
      begin    { DrawEdge is faster than Polyline }
        DrawEdge(DC, R, BDR_SUNKENINNER, BF_TOPLEFT);              { black     }
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_BOTTOMRIGHT);          { btnhilite }
        Dec(R.Bottom);
        Dec(R.Right);
        Inc(R.Top);
        Inc(R.Left);
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_TOPLEFT or BF_MIDDLE); { btnshadow }
      end
      else
      begin
        DrawEdge(DC, R, BDR_RAISEDOUTER, BF_BOTTOMRIGHT);          { black }
        Dec(R.Bottom);
        Dec(R.Right);
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_TOPLEFT);              { btnhilite }
        Inc(R.Top);
        Inc(R.Left);
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_BOTTOMRIGHT or BF_MIDDLE); { btnshadow }
      end;
    end
    else
    begin
      Pen.Color := clWindowFrame;
      Brush.Color := clBtnFace;
      Brush.Style := bsSolid;
      Rectangle(R.Left, R.Top, R.Right, R.Bottom);

      { round the corners - only applies to Win 3.1 style buttons }
      if IsRounded then
      begin
        Pixels[R.Left, R.Top] := clBtnFace;
        Pixels[R.Left, R.Bottom - 1] := clBtnFace;
        Pixels[R.Right - 1, R.Top] := clBtnFace;
        Pixels[R.Right - 1, R.Bottom - 1] := clBtnFace;
      end;

      if IsFocused then
      begin
        InflateRect(R, -1, -1);
        Brush.Style := bsClear;
        Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      end;

      InflateRect(R, -1, -1);
      if not IsDown then
        Canvas.Frame3D(R, clBtnHighlight, clBtnShadow, BevelWidth)
      else
      begin
        Pen.Color := clBtnShadow;
        PolyLine([Classes.Point(R.Left, R.Bottom - 1), Classes.Point(R.Left, R.Top),
          Classes.Point(R.Right, R.Top)]);
      end;
    end;
  end;

  Result := Classes.Rect(Client.Left + 1, Client.Top + 1,
    Client.Right - 2, Client.Bottom - 2);
  if IsDown then OffsetRect(Result, 1, 1);
end;

 { TControlBar }

 constructor TControlBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.BevelInner := bvNone;
  Self.BevelOuter := bvNone;
  {$IFDEF ENABLELCLDOCKING}
  Self.DragKind := dkDock;
  Self.DragMode := dmAutomatic;
  {$ENDIF}
end;

{ TMetafileCanvas }
 constructor TMetafileCanvas.Create(Meta: TMetafile; Ref: Integer);
 begin
   inherited Create(TlmfImage(Meta));
   FCreateOnlyText := False;
   FOriginalHandle := LCLIntf.CreateCompatibleDC(0);
   Handle := FOriginalHandle;
   Brush.Style := bsSolid;
   // raise Exception.Create('TMetaFileCanvas cannot be created with FPC !!');
 end;

 destructor TMetafileCanvas.Destroy;
begin
  LCLIntf.DeleteDC(FOriginalHandle);
  inherited Destroy;
end;

function OemToStr(const AnsiStr: String): String;
begin
  {$IFDEF FPC}
  {$note warning OemToStr()}
  Result := AnsiStr;
  {$ELSE}
  SetLength(Result, Length(AnsiStr));
  if Length(Result) > 0 then
    OemToAnsiBuff(PAnsiChar(AnsiStr), PAnsiChar(Result), Length(Result));
  {$ENDIF}
end;

function CharSetToCodePage(ciCharset: DWORD): Cardinal;
{$IFNDEF FPC}
var
  C: TCharsetInfo;
{$ENDIF}
begin
  {$IFDEF FPC}
  {$note warning TranslateCharsetInfo() }
  Result := 0;
  {$ELSE}
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
  {$ENDIF}
end;

function AnsiToUnicode(const s: {$IFDEF FPCUNICODE}String{$ELSE}AnsiString{$ENDIF}; Charset: UINT; CodePage: Integer): {$IFDEF FPCUNICODE}String{$ELSE}AnsiString{$ENDIF};
{$IFNDEF FPC}
var
  InputLength, OutputLength: Integer;
{$ENDIF}
begin
  {$IFDEF FPC}
  {$IFDEF FPCUNICODE}
  Result := S;
  {$ELSE}
  Result := UTF16ToUTF8(S);
  {$ENDIF}
  // UTF16ToUTF8(S);
  // AnsiToUtf8(s);
  {$ELSE}
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
  {$ENDIF}
end;

function _UnicodeToAnsi(const WS: {$IFDEF FPCUNICODE}String{$ELSE}WideString{$ENDIF}; Charset: UINT; CodePage: Integer): {$IFDEF FPCUNICODE}String{$ELSE}AnsiString{$ENDIF};
{$IFNDEF FPC}
var
  InputLength,
  OutputLength: Integer;
{$ENDIF}
begin
  {$IFDEF FPC}
  {$IFDEF FPCUNICODE}
  Result := WS;
  {$ELSE}
  Result := UTF8ToUTF16(WS);
  {$ENDIF}
  // UTF8ToUTF16(WS);
  // Utf8ToAnsi(WS);
  {$ELSE}
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
  {$ENDIF}
end;

function GetLocalByCharSet(Charset: UINT): Cardinal;
begin
  case Charset of
    EASTEUROPE_CHARSET:   Result := $0405;
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
    {$IFDEF FPC}
    Result := $0405;
    {$ELSE}
    Result := GetThreadLocale;
    {$ENDIF}
  end;
end;

function ExtTextOutExtra(ACanvas: TCanvas; X, Y: Integer; AOptions: Longint;
  ARect: PRect; AStr: PChar; ACount: Longint; ADx: PInteger): Boolean;
var
  AStyle: TTextStyle;
  S: String;
begin
  Result := False;
  if ACanvas is TMetaFileCanvas then // UseLMFForTextSearch and (CurrentLMFCanvas <> nil) then
  begin
    // FIX STYLE FROM AOptions !
    AStyle := ACanvas.TextStyle;
    S := UTF8Copy(StrPas(AStr), 1, ACount);
    TMetaFileCanvas(ACanvas).TextRect(ARect^,X, Y, S, AStyle);
    Result := True;
  end else
  begin
    {$IFDEF NONWINFPC}
    ADx := nil;
    {$ENDIF}

    Result := LCLIntf.ExtTextOut(ACanvas.Handle, X, Y, AOptions, ARect, AStr, ACount, ADx);
  end;
end;

function ExtTextOutExtrW(ACanvas: TCanvas; X, Y: Integer; AOptions: Longint;
  ARect: PRect; AStr: PWideChar; ACount: Longint; ADx: PInteger): Boolean;
var
  AStyle: TTextStyle;
  S: String;
begin
  Result := False;
  if ACanvas is TMetaFileCanvas then // UseLMFForTextSearch and (CurrentLMFCanvas <> nil) then
  begin
    // FIX STYLE FROM AOptions !
    AStyle := ACanvas.TextStyle;
    S := UTF16ToUTF8(AStr);
    TMetaFileCanvas(ACanvas).TextRect(ARect^,X, Y, S, AStyle);
    Result := True;
  end else
  begin
    {$IFDEF NONWINFPC}
    ADx := nil;
    {$ENDIF}

    Result := LCLIntf.ExtTextOut(ACanvas.Handle, X, Y, AOptions, ARect, PChar(UTF16ToUTF8(AStr)), ACount, ADx);
  end;
end;

function GetTextExtentExPointW(DC: HDC; Str: PWideChar; Count, MaxWidth: Integer;
  MaxCount, PartialWidths: PInteger; var Size: TSize): Boolean;
  var
  LCLStr: UnicodeString;
  s: AnsiString;
begin
  // use temp buffer, if count is set, there might be no null terminator
  if count = -1 then
    LCLStr := Str
  else
  begin
    SetLength(LCLStr, count);
    move(str^, PWideChar(LCLStr)^, count);
  end;
  s := UTF16ToUTF8(LCLStr);
  Result := GetTextExtentExPoint(DC,PChar(s),Length(s),MaxWidth,MaxCount, PartialWidths,Size);
end;

{$IFNDEF NONWINFPC}
function GetComboEditHandle(AComboBoxHandle: HWND): HWND;
begin
  Result := GetWindow(AComboBoxHandle, GW_CHILD);
end;

function GetFontData(p1: HDC; p2: DWORD; p3: DWORD; p4: Pointer; p5: DWORD):DWORD;
begin
  Result := Windows.GetFontData(p1,p2,p3,LPVOID(p4),p5);
end;

{$ENDIF}

function GetFileMIMEType(const Extension: String): String;
{$IFNDEF NONWINFPC}
var
  Registry: TRegistry;
begin
  Result := '';
  Registry  := TRegistry.Create;
  try
{$IFNDEF Delphi4}
    Registry.Access := KEY_READ;
{$ENDIF}
    Registry.RootKey := HKEY_CLASSES_ROOT;
    if Registry.KeyExists(Extension) then
    begin
      Registry.OpenKey(Extension, false);
      Result := Registry.ReadString('Content Type');
      if Result = '' then
        Result := Registry.ReadString('PerceivedType');
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;


{$ELSE}
begin
  if Extension = '.bmp' then
    Result := 'image/bmp'
  else if Extension = '.jpg' then
    Result := 'image/jpg'
  else if Extension = '.png' then
    Result := 'image/png'
  else
    Result := 'image';
end;
{$ENDIF}

procedure Translate(WinControl: TWinControl);
  procedure AssignTexts(Root: TControl);
  var
    i: Integer;
  begin
    with Root do
    begin
      if Tag > 0 then
        SetTextBuf(PChar(GetStr(IntToStr(Tag))));

      if Root is TWinControl then
        with Root as TWinControl do
          for i := 0 to ControlCount - 1 do
            if Controls[i] is TControl then
              AssignTexts(Controls[i] as TControl);
    end;
  end;

begin
  AssignTexts(WinControl);

  if WinControl.UseRightToLeftAlignment then
    WinControl.FlipChildren(True);
end;


end.


//821d3e87fb8b61d30ebb85e8c97f2d24
