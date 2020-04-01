unit frxKerningTableClass;

interface

{$I frx.inc}

uses Classes, TTFHelpers, frxFontHeaderClass, frxTrueTypeTable;

type // Nested Types

    CommonKerningHeader = packed record
        Coverage: Word;
        Length: Word;
        Version: Word;
    end;

    FormatZero = packed record
        entrySelector: Word;
        nPairs: Word;
        rangeShift: Word;
        searchRange: Word;
    end;

    FormatZeroPair = packed record
        key_value: Cardinal;
        value: Smallint;
    end;

    KerningTableHeader = packed record
        Version: Word;
        nTables: Word;
    end;

    KerningSubtableClass = class(TTF_Helpers)
        // Fields
        private common_header: CommonKerningHeader;
        private zero_pairs: TStringList;
        private format_zero: FormatZero;
        // Methods
        public constructor Create(kerning_table_ptr: Pointer);
        destructor Destroy; override;
        private function get_Item(inx: Cardinal): Smallint;
        // Properties
        public property Item[hash_value: Cardinal]: Smallint read get_Item;
        public property Length: Word read common_header.Length;
    end;

    KerningTableClass = class(TrueTypeTable)
        // Fields
        private kerning_table_header: KerningTableHeader;
        private kerning_subtables_collection: TList;
        // Methods
        public constructor Create(src: TrueTypeTable);
        destructor Destroy; override;
        private procedure ChangeEndian;
        public procedure Load(font: Pointer); override;

        private function get_Item(idx: Cardinal): Smallint;
        // Properties
        public property Item[hash_value: Cardinal]: Smallint read get_Item;
    end;

implementation uses SysUtils;

    constructor KerningTableClass.Create(src: TrueTypeTable);
    begin
        inherited Create(src);
        self.kerning_subtables_collection := TList.Create
    end;

    destructor KerningTableClass.Destroy;
    var
      i : Integer;
      f : KerningSubtableClass;
    begin
      for i := 0 to self.kerning_subtables_collection.Count - 1 do
      begin
        f := KerningSubtableClass(self.kerning_subtables_collection[i]);
        f.Free;
      end;
      self.kerning_subtables_collection.Free;
    end;

    procedure KerningTableClass.ChangeEndian;
    begin
        self.kerning_table_header.nTables := TTF_Helpers.SwapUInt16(self.kerning_table_header.nTables)
    end;

    function KerningTableClass.get_Item(idx: Cardinal): Smallint;
    var
      subtable: KerningSubtableClass;
    begin
      subtable := self.kerning_subtables_collection[0];
      Result := subtable.Item[idx];
    end;

    procedure KerningTableClass.Load(font: Pointer);
    var
       kerning_table_header: ^KerningTableHeader;
       i: Integer;
       subtable_ptr: Pointer;
       subtable: KerningSubtableClass;
    begin
        kerning_table_header := TTF_Helpers.Increment(font, self.entry.offset);
        self.kerning_table_header.nTables := kerning_table_header.nTables;
        self.ChangeEndian;

        subtable_ptr := TTF_Helpers.Increment(kerning_table_header, SizeOf(KerningTableHeader));
        i := 0;
        while ((i < self.kerning_table_header.nTables)) do
        begin
            subtable := KerningSubtableClass.Create(subtable_ptr);
            self.kerning_subtables_collection.Add(subtable);
            subtable_ptr := TTF_Helpers.Increment(subtable_ptr, subtable.Length);
            inc(i)
        end
    end;


    constructor KerningSubtableClass.Create(kerning_table_ptr: Pointer);
    var
      subtable: ^CommonKerningHeader;
      coverage_zero: ^FormatZero;
//      pair_zero: ^FormatZeroPair;
      single_pair: ^FormatZeroPair;
      i: Integer;
      Val: Cardinal;
    begin
      zero_pairs := TStringList.Create;
      zero_pairs.Sorted := True;
      subtable := kerning_table_ptr;
      self.common_header.Length := TTF_Helpers.SwapUInt16(subtable.Length);
      self.common_header.Coverage := TTF_Helpers.SwapUInt16(subtable.Coverage);
      if (self.common_header.Coverage <> 1) then
         Exit;
      coverage_zero := TTF_Helpers.Increment(subtable, SizeOf(subtable^));
      self.format_zero.nPairs := TTF_Helpers.SwapUInt16(coverage_zero.nPairs);
      self.format_zero.searchRange := TTF_Helpers.SwapUInt16(coverage_zero.searchRange);
      self.format_zero.entrySelector := TTF_Helpers.SwapUInt16(coverage_zero.entrySelector);
      self.format_zero.rangeShift := TTF_Helpers.SwapUInt16(coverage_zero.rangeShift);

//      pair_zero := TTF_Helpers.Increment( coverage_zero, SizeOf(FormatZero));
      i := 0;
      single_pair := TTF_Helpers.Increment( kerning_table_ptr, SizeOf(FormatZero)) ;
      while ((i < self.format_zero.nPairs)) do
      begin
          Val := TTF_Helpers.SwapUInt32(single_pair.key_value);
          if self.zero_pairs.IndexOf(IntToStr(Val)) = -1 then
            self.zero_pairs.AddObject(IntToStr(Val), TObject(TTF_Helpers.SwapInt16(single_pair.value)));
//          self.zero_pairs.Items[] := );
//          kerning_table_ptr := kerning_table_ptr + SizeOf(single_pair);
          Inc(single_pair);
          inc(i)
      end

    end;

    destructor KerningSubtableClass.Destroy;
    begin
	  zero_pairs.Free;	
      inherited Destroy;
    end;

    function KerningSubtableClass.get_Item(inx: Cardinal): Smallint;
    var
      idx: Integer;
    begin
      Result := 0;
      idx := zero_pairs.IndexOf(IntToStr(inx));
      if idx <> -1 then
        Result := Smallint(zero_pairs.Objects[idx]);
    end;

end.
