unit frxPostScriptClass;

interface

{$I frx.inc}

uses TTFHelpers, frxTrueTypeTable;

  type // Nested Types
      PostScript = packed record
          isFixedPitch: Cardinal;
          ItalicAngle: Integer;
          maxMemType1: Cardinal;
          maxMemType42: Cardinal;
          minMemType1: Cardinal;
          minMemType42: Cardinal;
          underlinePosition: Smallint;
          underlineThickness: Smallint;
          Version: Cardinal;
      end;


    PostScriptClass = class(TrueTypeTable)
      private post_script: PostScript;

      // Methods
      public constructor Create(src: TrueTypeTable);
      private procedure ChangeEndian;
      public procedure Load(font: Pointer); override;
      public function Save(font: Pointer; offset: Cardinal): Cardinal; override;

      // Properties
      public property ItalicAngle: Integer read post_script.ItalicAngle;

end;

implementation

// Methods
    constructor PostScriptClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
    end;

    procedure PostScriptClass.ChangeEndian;
    begin
        self.post_script.Version := TTF_Helpers.SwapUInt32(self.post_script.Version);
        self.post_script.ItalicAngle := TTF_Helpers.SwapInt32(self.post_script.ItalicAngle);
        self.post_script.underlinePosition := TTF_Helpers.SwapInt16(self.post_script.underlinePosition);
        self.post_script.underlineThickness := TTF_Helpers.SwapInt16(self.post_script.underlineThickness);
        self.post_script.isFixedPitch := TTF_Helpers.SwapUInt32(self.post_script.isFixedPitch);
        self.post_script.minMemType42 := TTF_Helpers.SwapUInt32(self.post_script.minMemType42);
        self.post_script.maxMemType42 := TTF_Helpers.SwapUInt32(self.post_script.maxMemType42);
        self.post_script.minMemType1 := TTF_Helpers.SwapUInt32(self.post_script.minMemType1);
        self.post_script.maxMemType1 := TTF_Helpers.SwapUInt32(self.post_script.maxMemType1)
    end;

    procedure PostScriptClass.Load(font: Pointer);
    var
      post_script: ^PostScript;
    begin
        post_script := TTF_Helpers.Increment(font, self.entry.offset);
        self.post_script.Version := post_script.Version;
        self.post_script.ItalicAngle := post_script.ItalicAngle;
        self.post_script.underlinePosition := post_script.underlinePosition;
        self.post_script.underlineThickness := post_script.underlineThickness;
        self.post_script.isFixedPitch := post_script.isFixedPitch;
        self.post_script.minMemType42 := post_script.minMemType42;
        self.post_script.maxMemType42 := post_script.maxMemType42;
        self.post_script.minMemType1 := post_script.minMemType1;
        self.post_script.maxMemType1 := post_script.maxMemType1;
        self.ChangeEndian
    end;

    function PostScriptClass.Save(font: Pointer; offset: Cardinal): Cardinal;
    var
      post_script: ^PostScript;
    begin
        self.entry.offset := offset;
        self.post_script.Version := $30000;
        self.entry.length := SizeOf(PostScript);
        self.ChangeEndian;
        post_script := TTF_Helpers.Increment(font, self.entry.offset);
        post_script.Version := self.post_script.Version;
        post_script.ItalicAngle := self.post_script.ItalicAngle;
        post_script.underlinePosition := self.post_script.underlinePosition;
        post_script.underlineThickness := self.post_script.underlineThickness;
        post_script.isFixedPitch := self.post_script.isFixedPitch;
        post_script.minMemType42 := self.post_script.minMemType42;
        post_script.maxMemType42 := self.post_script.maxMemType42;
        post_script.minMemType1 := self.post_script.minMemType1;
        post_script.maxMemType1 := self.post_script.maxMemType1;
        self.ChangeEndian;
        Result := offset + self.entry.length
    end;
end.
