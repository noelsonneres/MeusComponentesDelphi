unit frxOS2WindowsMetricsClass;

interface

{$I frx.inc}

uses SysUtils, TTFHelpers, frxTrueTypeTable;

type
  TVendorID = packed array[0..3] of Byte;
  TPanose   = packed array[0..9] of Byte;
  OS2WindowsMetrics = packed record
    Version: Word;         // version number 0x0004
    xAvgCharWidth: Smallint;
    usWeightClass: Word;
    usWidthClass: Word;
    fsType: Word;
    ySubscriptXSize: Smallint;
    ySubscriptYSize: Smallint;
    ySubscriptXOffset: Smallint;
    ySubscriptYOffset: Smallint;
    ySuperscriptXSize: Smallint;
    ySuperscriptYSize: Smallint;
    ySuperscriptXOffset: Smallint;
    ySuperscriptYOffset: Smallint;
    yStrikeoutSize: Smallint;
    yStrikeoutPosition: Smallint;
    sFamilyClass: Smallint;
    panose: TPanose;
    ulUnicodeRange1: Cardinal;
    ulUnicodeRange2: Cardinal;
    ulUnicodeRange3: Cardinal;
    ulUnicodeRange4: Cardinal;
    achVendID: TVendorID;
    fsSelection: Word;
    usFirstCharIndex: Word;
    usLastCharIndex: Word;
    sTypoAscender: Smallint;
    sTypoDescender: Smallint;
    sTypoLineGap: Smallint;
    usWinAscent: Word;
    usWinDescent: Word;
    ulCodePageRange1: Cardinal;
    ulCodePageRange2: Cardinal;
    sxHeight: Smallint;
    sCapHeight: Smallint;
    usDefaultChar: Word;
    usBreakChar: Word;
    usMaxContext: Word;
  end;

    POS2WindowsMetrics = ^OS2WindowsMetrics;

    OS2WindowsMetricsClass = class(TrueTypeTable)
        // Fields
      private win_metrix: POS2WindowsMetrics;
      // Methods
      public constructor Create(src: TrueTypeTable);
      public destructor  Destroy; override;

      public procedure Load(font: Pointer); override;
      public function Save(font: Pointer; offset: Cardinal): Cardinal; override;
      private function Get_AvgCharWidth: Smallint;
      private function Get_Ascent: Word;
      private function Get_BreakChar: Word;
      private function Get_DefaultChar: Word;
      private function Get_Descent: Word;
      private function Get_FirstCharIndex: Word;
      private function Get_LastCharIndex: Word;

      // Properties
      public property AvgCharWidth: Smallint read Get_AvgCharWidth;
      public property Ascent: Word read Get_Ascent;
      public property BreakChar: Word read Get_BreakChar;
      public property DefaultChar: Word read Get_DefaultChar;
      public property Descent: Word read Get_Descent;
      public property FirstCharIndex: Word read Get_FirstCharIndex;
      public property LastCharIndex: Word read Get_LastCharIndex;
    end;

implementation

    constructor OS2WindowsMetricsClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
      win_metrix := AllocMem( SizeOf(OS2WindowsMetrics) );
    end;

    destructor OS2WindowsMetricsClass.Destroy;
    begin
      FreeMem(win_metrix);
    end;

    function OS2WindowsMetricsClass.Get_AvgCharWidth: Smallint;
    begin
      Result := win_metrix^.xAvgCharWidth;
    end;

    function OS2WindowsMetricsClass.Get_Ascent: Word;
    begin
      Result := win_metrix^.usWinAscent;
    end;

    function OS2WindowsMetricsClass.Get_BreakChar: Word;
    begin
      Result := win_metrix^.usBreakChar;
    end;

    function OS2WindowsMetricsClass.Get_DefaultChar: Word;
    begin
      Result := win_metrix^.usDefaultChar;
    end;

    function OS2WindowsMetricsClass.Get_Descent: Word;
    begin
      Result := win_metrix^.usWinDescent;
    end;

    function OS2WindowsMetricsClass.Get_FirstCharIndex: Word;
    begin
      Result := win_metrix^.usFirstCharIndex;
    end;

    function OS2WindowsMetricsClass.Get_LastCharIndex: Word;
    begin
      Result := win_metrix^.usLastCharIndex;
    end;

    procedure OS2WindowsMetricsClass.Load(font: Pointer);
   var
      metrix: ^OS2WindowsMetrics;
    begin
        metrix := TTF_Helpers.Increment(font, self.entry.offset );
        self.win_metrix.Version := TTF_Helpers.SwapUInt16(metrix.Version);
        self.win_metrix.xAvgCharWidth := TTF_Helpers.SwapInt16(metrix.xAvgCharWidth);
        self.win_metrix.usWeightClass := TTF_Helpers.SwapUInt16(metrix.usWeightClass);
        self.win_metrix.usWidthClass := TTF_Helpers.SwapUInt16(metrix.usWidthClass);
        self.win_metrix.fsType := TTF_Helpers.SwapUInt16(metrix.fsType);
        self.win_metrix.ySubscriptXSize := TTF_Helpers.SwapInt16(metrix.ySubscriptXSize);
        self.win_metrix.ySubscriptYSize := TTF_Helpers.SwapInt16(metrix.ySubscriptYSize);
        self.win_metrix.ySubscriptXOffset := TTF_Helpers.SwapInt16(metrix.ySubscriptXOffset);
        self.win_metrix.ySubscriptYOffset := TTF_Helpers.SwapInt16(metrix.ySubscriptYOffset);
        self.win_metrix.ySuperscriptXSize := TTF_Helpers.SwapInt16(metrix.ySuperscriptXSize);
        self.win_metrix.ySuperscriptYSize := TTF_Helpers.SwapInt16(metrix.ySuperscriptYSize);
        self.win_metrix.ySuperscriptXOffset := TTF_Helpers.SwapInt16(metrix.ySuperscriptXOffset);
        self.win_metrix.ySuperscriptYOffset := TTF_Helpers.SwapInt16(metrix.ySuperscriptYOffset);
        self.win_metrix.yStrikeoutSize := TTF_Helpers.SwapInt16(metrix.yStrikeoutSize);
        self.win_metrix.yStrikeoutPosition := TTF_Helpers.SwapInt16(metrix.yStrikeoutPosition);
        self.win_metrix.sFamilyClass := TTF_Helpers.SwapInt16(metrix.sFamilyClass);
        self.win_metrix.ulUnicodeRange1 := TTF_Helpers.SwapUInt32(metrix.ulUnicodeRange1);
        self.win_metrix.ulUnicodeRange2 := TTF_Helpers.SwapUInt32(metrix.ulUnicodeRange2);
        self.win_metrix.ulUnicodeRange3 := TTF_Helpers.SwapUInt32(metrix.ulUnicodeRange3);
        self.win_metrix.ulUnicodeRange4 := TTF_Helpers.SwapUInt32(metrix.ulUnicodeRange4);
        self.win_metrix.fsSelection := TTF_Helpers.SwapUInt16(metrix.fsSelection);
        self.win_metrix.usFirstCharIndex := TTF_Helpers.SwapUInt16(metrix.usFirstCharIndex);
        self.win_metrix.usLastCharIndex := TTF_Helpers.SwapUInt16(metrix.usLastCharIndex);
        self.win_metrix.sTypoAscender := TTF_Helpers.SwapInt16(metrix.sTypoAscender);
        self.win_metrix.sTypoDescender := TTF_Helpers.SwapInt16(metrix.sTypoDescender);
        self.win_metrix.sTypoLineGap := TTF_Helpers.SwapInt16(metrix.sTypoLineGap);
        self.win_metrix.usWinAscent := TTF_Helpers.SwapUInt16(metrix.usWinAscent);
        self.win_metrix.usWinDescent := TTF_Helpers.SwapUInt16(metrix.usWinDescent);
        self.win_metrix.ulCodePageRange1 := TTF_Helpers.SwapUInt32(metrix.ulCodePageRange1);
        self.win_metrix.ulCodePageRange1 := TTF_Helpers.SwapUInt32(metrix.ulCodePageRange2);
        self.win_metrix.sxHeight := TTF_Helpers.SwapInt16(metrix.sxHeight);
        self.win_metrix.sCapHeight := TTF_Helpers.SwapInt16(metrix.sCapHeight);
        self.win_metrix.usDefaultChar := TTF_Helpers.SwapUInt16(metrix.usDefaultChar);
        self.win_metrix.usBreakChar := TTF_Helpers.SwapUInt16(metrix.usBreakChar);
        self.win_metrix.usMaxContext := TTF_Helpers.SwapUInt16(metrix.usMaxContext);
    end;

    function OS2WindowsMetricsClass.Save(font: Pointer; offset: Cardinal): Cardinal;
    var
      metrix: ^OS2WindowsMetrics;
    begin
        self.entry.offset := offset;
        metrix := TTF_Helpers.Increment(font, self.entry.offset);
        metrix.Version := TTF_Helpers.SwapUInt16(self.win_metrix.Version);
        metrix.xAvgCharWidth := TTF_Helpers.SwapInt16(self.win_metrix.xAvgCharWidth);
        metrix.usWeightClass := TTF_Helpers.SwapUInt16(self.win_metrix.usWeightClass);
        metrix.usWidthClass := TTF_Helpers.SwapUInt16(self.win_metrix.usWidthClass);
        metrix.fsType := TTF_Helpers.SwapUInt16(self.win_metrix.fsType);
        metrix.ySubscriptXSize := TTF_Helpers.SwapInt16(self.win_metrix.ySubscriptXSize);
        metrix.ySubscriptYSize := TTF_Helpers.SwapInt16(self.win_metrix.ySubscriptYSize);
        metrix.ySubscriptXOffset := TTF_Helpers.SwapInt16(self.win_metrix.ySubscriptXOffset);
        metrix.ySubscriptYOffset := TTF_Helpers.SwapInt16(self.win_metrix.ySubscriptYOffset);
        metrix.ySuperscriptXSize := TTF_Helpers.SwapInt16(self.win_metrix.ySuperscriptXSize);
        metrix.ySuperscriptYSize := TTF_Helpers.SwapInt16(self.win_metrix.ySuperscriptYSize);
        metrix.ySuperscriptXOffset := TTF_Helpers.SwapInt16(self.win_metrix.ySuperscriptXOffset);
        metrix.ySuperscriptYOffset := TTF_Helpers.SwapInt16(self.win_metrix.ySuperscriptYOffset);
        metrix.yStrikeoutSize := TTF_Helpers.SwapInt16(self.win_metrix.yStrikeoutSize);
        metrix.yStrikeoutPosition := TTF_Helpers.SwapInt16(self.win_metrix.yStrikeoutPosition);
        metrix.sFamilyClass := TTF_Helpers.SwapInt16(self.win_metrix.sFamilyClass);
        metrix.ulUnicodeRange1 := TTF_Helpers.SwapUInt32(self.win_metrix.ulUnicodeRange1);
        metrix.ulUnicodeRange2 := TTF_Helpers.SwapUInt32(self.win_metrix.ulUnicodeRange2);
        metrix.ulUnicodeRange3 := TTF_Helpers.SwapUInt32(self.win_metrix.ulUnicodeRange3);
        metrix.ulUnicodeRange4 := TTF_Helpers.SwapUInt32(self.win_metrix.ulUnicodeRange4);
        metrix.fsSelection := TTF_Helpers.SwapUInt16(self.win_metrix.fsSelection);
        metrix.usFirstCharIndex := TTF_Helpers.SwapUInt16(self.win_metrix.usFirstCharIndex);
        metrix.usLastCharIndex := TTF_Helpers.SwapUInt16(self.win_metrix.usLastCharIndex);
        metrix.sTypoAscender := TTF_Helpers.SwapInt16(self.win_metrix.sTypoAscender);
        metrix.sTypoDescender := TTF_Helpers.SwapInt16(self.win_metrix.sTypoDescender);
        metrix.sTypoLineGap := TTF_Helpers.SwapInt16(self.win_metrix.sTypoLineGap);
        metrix.usWinAscent := TTF_Helpers.SwapUInt16(self.win_metrix.usWinAscent);
        metrix.usWinDescent := TTF_Helpers.SwapUInt16(self.win_metrix.usWinDescent);
        metrix.ulCodePageRange1 := TTF_Helpers.SwapUInt32(self.win_metrix.ulCodePageRange1);
        metrix.ulCodePageRange1 := TTF_Helpers.SwapUInt32(self.win_metrix.ulCodePageRange2);
        metrix.sxHeight := TTF_Helpers.SwapInt16(self.win_metrix.sxHeight);
        metrix.sCapHeight := TTF_Helpers.SwapInt16(self.win_metrix.sCapHeight);
        metrix.usDefaultChar := TTF_Helpers.SwapUInt16(self.win_metrix.usDefaultChar);
        metrix.usBreakChar := TTF_Helpers.SwapUInt16(self.win_metrix.usBreakChar);
        metrix.usMaxContext := TTF_Helpers.SwapUInt16(self.win_metrix.usMaxContext);
        Result := (offset + self.entry.length + 3) and $fffffffc;
    end;
end.
