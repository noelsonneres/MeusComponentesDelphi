unit frxMaximumProfileClass;

interface

{$I frx.inc}

uses TTFHelpers, frxTrueTypeTable;

    type // Nested Types
        MaximumProfile = packed record
            maxComponentDepth: Word;
            maxComponentElements: Word;
            maxCompositeContours: Word;
            maxCompositePoints: Word;
            maxContours: Word;
            maxFunctionDefs: Word;
            maxInstructionDefs: Word;
            maxPoints: Word;
            maxSizeOfInstructions: Word;
            maxStackElements: Word;
            maxStorage: Word;
            maxTwilightPoints: Word;
            maxZones: Word;
            numGlyphs: Word;
            Version: Cardinal;
        end;

    MaximumProfileClass = class(TrueTypeTable)
      private max_profile: MaximumProfile;

      public constructor Create(src: TrueTypeTable);
      private procedure ChangeEndian;
      public procedure Load(font: Pointer); override;
      public function Save(font: Pointer; offset: Cardinal): Cardinal; override;
end;

implementation

    constructor MaximumProfileClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
    end;

    procedure MaximumProfileClass.ChangeEndian;
    begin
        self.max_profile.Version := TTF_Helpers.SwapUInt32(self.max_profile.Version);
        self.max_profile.numGlyphs := TTF_Helpers.SwapUInt16(self.max_profile.numGlyphs);
        self.max_profile.maxPoints := TTF_Helpers.SwapUInt16(self.max_profile.maxPoints);
        self.max_profile.maxContours := TTF_Helpers.SwapUInt16(self.max_profile.maxContours);
        self.max_profile.maxCompositePoints := TTF_Helpers.SwapUInt16(self.max_profile.maxCompositePoints);
        self.max_profile.maxCompositeContours := TTF_Helpers.SwapUInt16(self.max_profile.maxCompositeContours);
        self.max_profile.maxZones := TTF_Helpers.SwapUInt16(self.max_profile.maxZones);
        self.max_profile.maxTwilightPoints := TTF_Helpers.SwapUInt16(self.max_profile.maxTwilightPoints);
        self.max_profile.maxStorage := TTF_Helpers.SwapUInt16(self.max_profile.maxStorage);
        self.max_profile.maxFunctionDefs := TTF_Helpers.SwapUInt16(self.max_profile.maxFunctionDefs);
        self.max_profile.maxInstructionDefs := TTF_Helpers.SwapUInt16(self.max_profile.maxInstructionDefs);
        self.max_profile.maxStackElements := TTF_Helpers.SwapUInt16(self.max_profile.maxStackElements);
        self.max_profile.maxSizeOfInstructions := TTF_Helpers.SwapUInt16(self.max_profile.maxSizeOfInstructions);
        self.max_profile.maxComponentElements := TTF_Helpers.SwapUInt16(self.max_profile.maxComponentElements);
        self.max_profile.maxComponentDepth := TTF_Helpers.SwapUInt16(self.max_profile.maxComponentDepth)
    end;

    procedure MaximumProfileClass.Load(font: Pointer);
    var
      max_profile: ^MaximumProfile;
    begin
        max_profile := TTF_Helpers.Increment(font, self.entry.offset);
        self.max_profile.Version := max_profile.Version;
        self.max_profile.numGlyphs := max_profile.numGlyphs;
        self.max_profile.maxPoints := max_profile.maxPoints;
        self.max_profile.maxContours := max_profile.maxContours;
        self.max_profile.maxCompositePoints := max_profile.maxCompositePoints;
        self.max_profile.maxCompositeContours := max_profile.maxCompositeContours;
        self.max_profile.maxZones := max_profile.maxZones;
        self.max_profile.maxTwilightPoints := max_profile.maxTwilightPoints;
        self.max_profile.maxStorage := max_profile.maxStorage;
        self.max_profile.maxFunctionDefs := max_profile.maxFunctionDefs;
        self.max_profile.maxInstructionDefs := max_profile.maxInstructionDefs;
        self.max_profile.maxStackElements := max_profile.maxStackElements;
        self.max_profile.maxSizeOfInstructions := max_profile.maxSizeOfInstructions;
        self.max_profile.maxComponentElements := max_profile.maxComponentElements;
        self.max_profile.maxComponentDepth := max_profile.maxComponentDepth;
        self.ChangeEndian
    end;

    function MaximumProfileClass.Save(font: Pointer; offset: Cardinal): Cardinal;
    var
      max_profile: ^MaximumProfile;
    begin
        self.entry.offset := offset;
        self.ChangeEndian;
        max_profile := TTF_Helpers.Increment(font, self.entry.offset);
        max_profile.Version := self.max_profile.Version;
        max_profile.numGlyphs := self.max_profile.numGlyphs;
        max_profile.maxPoints := self.max_profile.maxPoints;
        max_profile.maxContours := self.max_profile.maxContours;
        max_profile.maxCompositePoints := self.max_profile.maxCompositePoints;
        max_profile.maxCompositeContours := self.max_profile.maxCompositeContours;
        max_profile.maxZones := self.max_profile.maxZones;
        max_profile.maxTwilightPoints := self.max_profile.maxTwilightPoints;
        max_profile.maxStorage := self.max_profile.maxStorage;
        max_profile.maxFunctionDefs := self.max_profile.maxFunctionDefs;
        max_profile.maxInstructionDefs := self.max_profile.maxInstructionDefs;
        max_profile.maxStackElements := self.max_profile.maxStackElements;
        max_profile.maxSizeOfInstructions := self.max_profile.maxSizeOfInstructions;
        max_profile.maxComponentElements := self.max_profile.maxComponentElements;
        max_profile.maxComponentDepth := self.max_profile.maxComponentDepth;
        self.ChangeEndian;
        Result := offset + self.entry.length
    end;
end.
