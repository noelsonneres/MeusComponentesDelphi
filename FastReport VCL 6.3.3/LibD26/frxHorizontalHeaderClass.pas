unit frxHorizontalHeaderClass;

interface

{$I frx.inc}

uses TTFHelpers, frxTrueTypeTable;


type
    HorizontalHeader = packed record
        Version: Cardinal;
        Ascender: Smallint;
        Descender: Smallint;
        LineGap: Smallint;
        advanceWidthMax: Word;
        minLeftSideBearing: Smallint;
        minRightSideBearing: Smallint;
        xMaxExtent: Smallint;
        caretSlopeRise: Smallint;
        caretSlopeRun: Smallint;
        reserved1: Smallint;
        reserved2: Smallint;
        reserved3: Smallint;
        reserved4: Smallint;
        reserved5: Smallint;
        metricDataFormat: Smallint;
        numberOfHMetrics: Word;
    end;

    HorizontalHeaderClass = class(TrueTypeTable)
      // Fields
      private horizontal_header: HorizontalHeader;

      // Methods
      public constructor Create(src: TrueTypeTable);
      private procedure ChangeEndian;
      public procedure Load(font: Pointer); override;
      public function Save(font: Pointer; offset: Cardinal): Cardinal; override;

      // Properties
      public property Ascender: Smallint read horizontal_header.Ascender;
      public property Descender: Smallint read horizontal_header.Descender;
      public property LineGap: Smallint read horizontal_header.LineGap;
      public property MaxWidth: Word read horizontal_header.advanceWidthMax;
      public property NumberOfHMetrics: Word read horizontal_header.NumberOfHMetrics;
    end;

implementation

// Methods
    constructor HorizontalHeaderClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
    end;

    procedure HorizontalHeaderClass.ChangeEndian;
    begin
        self.horizontal_header.Version := TTF_Helpers.SwapUInt32(self.horizontal_header.Version);
        self.horizontal_header.Ascender := TTF_Helpers.SwapInt16(self.horizontal_header.Ascender);
        self.horizontal_header.Descender := TTF_Helpers.SwapInt16(self.horizontal_header.Descender);
        self.horizontal_header.LineGap := TTF_Helpers.SwapInt16(self.horizontal_header.LineGap);
        self.horizontal_header.advanceWidthMax := TTF_Helpers.SwapUInt16(self.horizontal_header.advanceWidthMax);
        self.horizontal_header.minLeftSideBearing := TTF_Helpers.SwapInt16(self.horizontal_header.minLeftSideBearing);
        self.horizontal_header.minRightSideBearing := TTF_Helpers.SwapInt16(self.horizontal_header.minRightSideBearing);
        self.horizontal_header.xMaxExtent := TTF_Helpers.SwapInt16(self.horizontal_header.xMaxExtent);
        self.horizontal_header.caretSlopeRise := TTF_Helpers.SwapInt16(self.horizontal_header.caretSlopeRise);
        self.horizontal_header.caretSlopeRun := TTF_Helpers.SwapInt16(self.horizontal_header.caretSlopeRun);
        self.horizontal_header.metricDataFormat := TTF_Helpers.SwapInt16(self.horizontal_header.metricDataFormat);
        self.horizontal_header.numberOfHMetrics := TTF_Helpers.SwapUInt16(self.horizontal_header.numberOfHMetrics)
    end;

    procedure HorizontalHeaderClass.Load(font: Pointer);
    var
      horizontal_header: ^HorizontalHeader;
    begin
      horizontal_header := TTF_Helpers.Increment(font, self.entry.offset);
      self.horizontal_header.advanceWidthMax := horizontal_header.advanceWidthMax;
      self.horizontal_header.Ascender :=  horizontal_header.Ascender;
      self.horizontal_header.caretSlopeRise := horizontal_header.caretSlopeRise;
      self.horizontal_header.caretSlopeRun := horizontal_header.caretSlopeRun;
      self.horizontal_header.Descender := horizontal_header.Descender;
      self.horizontal_header.LineGap := horizontal_header.LineGap;
      self.horizontal_header.metricDataFormat := horizontal_header.metricDataFormat;
      self.horizontal_header.minLeftSideBearing := horizontal_header.minLeftSideBearing;
      self.horizontal_header.minRightSideBearing := horizontal_header.minRightSideBearing;
      self.horizontal_header.numberOfHMetrics := horizontal_header.numberOfHMetrics;
      self.horizontal_header.reserved1 := horizontal_header.reserved1;
      self.horizontal_header.reserved2 := horizontal_header.reserved2;
      self.horizontal_header.reserved3 := horizontal_header.reserved3;
      self.horizontal_header.reserved4 := horizontal_header.reserved4;
      self.horizontal_header.reserved5 := horizontal_header.reserved5;
      self.horizontal_header.Version  := horizontal_header.Version;
      self.horizontal_header.xMaxExtent := horizontal_header.xMaxExtent;
      self.ChangeEndian
    end;

    function HorizontalHeaderClass.Save(font: Pointer; offset: Cardinal): Cardinal;
    var
      horizontal_header: ^HorizontalHeader;
    begin
        self.entry.offset := offset;
        self.ChangeEndian;
        horizontal_header := TTF_Helpers.Increment(font, self.entry.offset);
        horizontal_header.advanceWidthMax := self.horizontal_header.advanceWidthMax;
        horizontal_header.Ascender := self.horizontal_header.Ascender;
        horizontal_header.caretSlopeRise := self.horizontal_header.caretSlopeRise;
        horizontal_header.caretSlopeRun := self.horizontal_header.caretSlopeRun;
        horizontal_header.Descender := self.horizontal_header.Descender;
        horizontal_header.LineGap := self.horizontal_header.LineGap;
        horizontal_header.metricDataFormat := self.horizontal_header.metricDataFormat;
        horizontal_header.minLeftSideBearing := self.horizontal_header.minLeftSideBearing;
        horizontal_header.minRightSideBearing := self.horizontal_header.minRightSideBearing;
        horizontal_header.numberOfHMetrics := self.horizontal_header.numberOfHMetrics;
        horizontal_header.reserved1 := self.horizontal_header.reserved1;
        horizontal_header.reserved2 := self.horizontal_header.reserved2;
        horizontal_header.reserved3 := self.horizontal_header.reserved3;
        horizontal_header.reserved4 := self.horizontal_header.reserved4;
        horizontal_header.reserved5 := self.horizontal_header.reserved5;
        horizontal_header.Version := self.horizontal_header.Version;
        horizontal_header.xMaxExtent := self.horizontal_header.xMaxExtent;
        self.ChangeEndian;
        Result := (offset + self.entry.length)
    end;
END.

