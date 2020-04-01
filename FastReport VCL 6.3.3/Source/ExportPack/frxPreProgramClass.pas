unit frxPreProgramClass;

interface

{$I frx.inc}

uses TTFHelpers, frxTrueTypeTable;

type
  PreProgramClass = class(TrueTypeTable)
    // Fields
    private pre_program: Array of Byte;
    // Methods
    public constructor Create(src: TrueTypeTable);
    public procedure Load(font: Pointer); override;
    public function Save(font: Pointer; offset: Cardinal): Cardinal; override;
end;

implementation

// Methods
    constructor PreProgramClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
    end;

    procedure PreProgramClass.Load(font: Pointer);
    var
      Tppr: ^Byte;
      i: Integer;
    begin
      length := (((self.entry.length + 3) div 4) * 4);
      SetLength(self.pre_program, length);
      Tppr := TTF_Helpers.Increment(font, self.entry.offset);
      for i := 0 to Length - 1 do
      begin
        self.pre_program[i] := Tppr^;
        Inc(Tppr);
      end;
    end;

    function PreProgramClass.Save(font: Pointer; offset: Cardinal): Cardinal;
    var
      Tppr: ^Byte;
      i: Integer;
    begin
      self.entry.offset := offset;
      Tppr := TTF_Helpers.Increment(font, self.entry.offset);
      for i := 0 to Length - 1 do
      begin
        Tppr^ := self.pre_program[i];
        Inc(Tppr);
      end;
      Result := offset + Length;
    end;
end.
