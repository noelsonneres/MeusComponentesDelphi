unit frxCmapTableClass;

interface

{$I frx.inc}

uses SysUtils, TTFHelpers, frxTrueTypeTable;

    type // Nested Types
        EncodingFormats = (ByteEncoding=0, HighByteMapping=2, SegmentMapping=4, TrimmedTable=6);
        TSmallintArray = array of Smallint;
        TWordArray = array of Word;

        TSegmentMapping = packed record
            segCountX2: Word;
            searchRange: Word;
            entrySelector: Word;
            rangeShift: Word;
        end;

        Table_CMAP = packed record
            TableVersion: Word;
            NumSubTables: Word;
        end;

        Table_Encode = packed record
            Format: Word;
            Length: Word;
            Version: Word;
        end;

        Table_SUBMAP = packed record
            Platform: Word;
            EncodingID: Word;
            TableOffset: Cardinal;
        end;


    CmapTableClass = class(TrueTypeTable)
    // Fields
    private endCount: TWordArray;
    private GlyphIndexArray: TWordArray;
    private idDelta: TSmallintArray;
    private idRangeOffset: TWordArray;
    private startCount: TWordArray;
    private segment_count: Integer;

    // Methods
    public constructor Create(src: TrueTypeTable);
    public function GetGlyphIndex(ch: Word): Word;
    private function LoadCmapSegment(segment_ptr: Pointer; segment_count: Integer): TWordArray;
    public procedure LoadCmapTable(font: Pointer);
    private function LoadSignedCmapSegment(segment_ptr: Pointer; segment_count: Integer): TSmallintArray;
end;

implementation

// Methods
    constructor CmapTableClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
    end;

    function CmapTableClass.GetGlyphIndex(ch: Word): Word;
    var
      i,j: Integer;
      GlyphIDX: SmallInt;
    begin
        GlyphIDX := 0;
        i := 0;
        while ((i < self.segment_count)) do
        begin
            if (self.endCount[i] >= ch) then
            begin
                if (self.startCount[i] > ch) then
                    begin
                        Result := GlyphIDX;
                        exit
                    end;
                if (self.idRangeOffset[i] = 0) then
                    begin
                        Result := Word((ch + self.idDelta[i]) mod $10000);
                        exit
                    end;
                j := Word(((self.idRangeOffset[i] div 2) + (ch - self.startCount[i])) - (self.segment_count - i));
                begin
                    Result := self.GlyphIndexArray[j];
                    exit
                end
            end;
            inc(i)
        end;
        Result := GlyphIDX;
    end;

    function CmapTableClass.LoadCmapSegment(segment_ptr: Pointer; segment_count: Integer): TWordArray;
    var
      i: Integer;
      ptr: ^Word;
    begin
      ptr := segment_ptr;
      SetLength(Result, segment_count);
      i := 0;
      try
        while ((i < segment_count)) do
        begin
            Result[i] := TTF_Helpers.SwapUInt16(ptr^);
            Inc(i);
            Inc(ptr);
        end;
      except
        // Wrong size "Meiryo Bold" and "Meiryo Bold Italic" in Windows 7
      end;
    end;

    procedure CmapTableClass.LoadCmapTable(font: Pointer);
    var
        encode_ptr:           ^Table_Encode;
        encode:               Table_Encode;
        cmap:                 ^Table_CMAP;
        j,subtables_count:    Integer;
        submap:               Table_SUBMAP;
        submap_ptr:           ^Table_SUBMAP;
        segment:              TSegmentMapping;
        segment_ptr:          ^TSegmentMapping;
        index_array_size:     Cardinal;
    begin
        cmap := TTF_Helpers.Increment( font, self.entry.offset );
        subtables_count := TTF_Helpers.SwapUInt16(cmap.NumSubTables);
        submap_ptr := TTF_Helpers.Increment(cmap, SizeOf(Table_CMAP));
        j := 0;
        while ((j < subtables_count)) do
        begin
//            submap := submap_ptr;
            submap.Platform := TTF_Helpers.SwapUInt16(submap_ptr.Platform);
            submap.EncodingID := TTF_Helpers.SwapUInt16(submap_ptr.EncodingID);
            submap.TableOffset := TTF_Helpers.SwapUInt32(submap_ptr.TableOffset);
            submap_ptr := TTF_Helpers.Increment(submap_ptr, SizeOf(Table_SUBMAP));
            if ((submap.Platform = 3) and (submap.EncodingID = 1)) then
            begin
                encode_ptr := TTF_Helpers.Increment(cmap, submap.TableOffset);
//                encode := encode_ptr;
                encode.Format := TTF_Helpers.SwapUInt16(encode_ptr.Format);
                encode.Length := TTF_Helpers.SwapUInt16(encode_ptr.Length);
                encode.Version := TTF_Helpers.SwapUInt16(encode_ptr.Version);
                case encode.Format of
                    0:
                        begin
                            raise Exception.Create('TO DO: ByteEncoding cmap format not implemented')
                        end;
//                    1,3,5:
//                        begin
//                            continue;
//                        end;
                    2:
                        begin
                            raise Exception.Create('TO DO: HighByteMapping cmap format not implemented')
                        end;
                    4:
                        begin
                          segment_ptr := TTF_Helpers.Increment(encode_ptr, SizeOf(Table_Encode));
//                          segment := encode_ptr;
                          segment.segCountX2 := TTF_Helpers.SwapUInt16(segment_ptr.segCountX2);
                          segment.searchRange := TTF_Helpers.SwapUInt16(segment_ptr.searchRange);
                          segment.entrySelector := TTF_Helpers.SwapUInt16(segment_ptr.entrySelector);
                          segment.rangeShift := TTF_Helpers.SwapUInt16(segment_ptr.rangeShift);
                          self.segment_count := (segment.segCountX2 div 2);

                          encode_ptr := TTF_Helpers.Increment(segment_ptr, SizeOf(TSegmentMapping));
                          self.endCount := self.LoadCmapSegment(encode_ptr, self.segment_count);
                          encode_ptr := TTF_Helpers.Increment(encode_ptr, (segment.segCountX2 + 2));
                          self.startCount := self.LoadCmapSegment(encode_ptr, self.segment_count);
                          encode_ptr := TTF_Helpers.Increment(encode_ptr, segment.segCountX2);
                          self.idDelta := self.LoadSignedCmapSegment(encode_ptr, self.segment_count);
                          encode_ptr := TTF_Helpers.Increment(encode_ptr, segment.segCountX2);
                          self.idRangeOffset := self.LoadCmapSegment(encode_ptr, self.segment_count);

                          index_array_size := Cardinal((8 + (4 * self.segment_count)) * 2);
                          index_array_size := ((inherited length - index_array_size) div 2);
                          encode_ptr := TTF_Helpers.Increment(encode_ptr, segment.segCountX2);

                          self.GlyphIndexArray := self.LoadCmapSegment(encode_ptr, index_array_size);
                        end;
                    6:
                        begin
                            raise Exception.Create('TO DO: TrimmedTable cmap format not implemented')
                        end;
                end
            end;
            inc(j);
            continue;
            ;

        end
    end;

    function CmapTableClass.LoadSignedCmapSegment(segment_ptr: Pointer; segment_count: Integer ): TSmallintArray;
    var
      i: Integer;
      p : PWord;
    begin
        SetLength(Result, segment_count);
        p := segment_ptr;
        i := 0;
        while ((i < segment_count)) do
        begin
            Result[i] := TTF_Helpers.SwapInt16(p^);
            inc(i);
            inc(p);
        end;
    end;

end.
