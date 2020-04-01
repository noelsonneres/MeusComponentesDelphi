unit frxTrueTypeFont;

interface

{$I frx.inc}

uses
      TTFHelpers, frxCmapTableClass, frxFontHeaderClass, frxGlyphTableClass,
      frxGlyphSubstitutionClass, frxHorizontalHeaderClass,
      frxHorizontalMetrixClass, frxIndexToLocationClass,
      frxKerningTableClass, frxNameTableClass, frxPostScriptClass,
      frxMaximumProfileClass, frxOS2WindowsMetricsClass,
      Classes, frxTrueTypeTable,
      frxPreprogramClass,
      Windows;

type
    ChecksumFaultAction = (ChecksumFaultAction_IgnoreChecksum=0, ChecksumFaultAction_ThrowException=1, ChecksumFaultAction_Warn=2);
    TablesID = (TablesID_CMAP=$70616d63, TablesID_ControlValueTable=$20747663, TablesID_DigitalSignature=$47495344,
      TablesID_EmbedBitmapLocation=$434c4245, TablesID_EmbededBitmapData=$54444245, TablesID_FontHeader=$64616568,
      TablesID_FontProgram=$6d677066, TablesID_Glyph=$66796c67, TablesID_GlyphDefinition=$46454447, TablesID_GlyphPosition=$534f5047,
      TablesID_GlyphSubstitution=$42555347, TablesID_GridFittingAndScanConversion=$70736167, TablesID_HorizontakDeviceMetrix=$786d6468,
      TablesID_HorizontalHeader=$61656868, TablesID_HorizontalMetrix=$78746d68, TablesID_IndexToLocation=$61636f6c,
      TablesID_Justification=$4654534a, TablesID_KerningTable=$6e72656b, TablesID_LinearThreshold=$4853544c,
      TablesID_MaximumProfile=$7078616d, TablesID_Name=$656d616e, TablesID_OS2Table=$322f534f, TablesID_PCL5Table=$544c4350,
      TablesID_Postscript=$74736f70, TablesID_PreProgram=$70657270, TablesID_VerticalDeviceMetrix=$584d4456,
      TablesID_VerticalMetrix=$78746d76, TablesID_VertivalMetrixHeader=$61656876);

    TByteArray = Array of Byte;
    TTagList = TList;

    TTableSortHelper = record
      Offset: Cardinal;
      TAG:    Cardinal;
    end;

    PTableSortHelper = ^TTableSortHelper;

    TableDirectory = packed record
        sfntversion: Cardinal;
        numTables: Word;
        searchRange: Word;
        entrySelector: Word;
        rangeShift: Word;
    end;

    TrueTypeFont = class(TTF_Helpers)
      // Fields
    private
      beginfile_ptr: Pointer;
      cmap_table: CmapTableClass;
      dir: TableDirectory;
      font_header: FontHeaderClass;
      glyph_table: GlyphTableClass;
      gsub_table: GlyphSubstitutionClass;
      horizontal_header: HorizontalHeaderClass;
      horizontal_metrix_table: HorizontalMetrixClass;
      index_to_location: IndexToLocationClass;
      kerning_table: KerningTableClass;
      name_table: NameTableClass;
      postscript: PostScriptClass;
      profile: MaximumProfileClass;
      selector_ptr: Pointer;
      windows_metrix: OS2WindowsMetricsClass;
      preprogram_table: PreProgramClass;
      ListOfTables: TList;
      ListOfUsedGlyphs: TList;
      // private ListOfUsedWidths: TList;
      GlyphWidths: TIntegerList;
      Indices: TIntegerList;
      FSubstitutionName: String;
      function CalcTableChecksum(font: Pointer; entry: TrueTypeTable;
        debug: boolean): Cardinal;
      procedure CalculateFontChecksum(start_offset: Pointer;
        font_length: Cardinal);
      procedure ChangeEndian;
      procedure CheckTablesChecksum;
      // public procedure GetOutlineTextMetrics(var FTextMetric: OutlineTextMetricW);
      function GetTablesOrder: TTagList;
      procedure LoadCoreTables;
      procedure LoadDescriptors(skip_array: TIntegerList);
      procedure ReorderGlyphTable(position: Pointer; uniscribe: boolean);
      procedure SaveDescriptors(position: Pointer);
      procedure set_UsedGlyphs(dict: TList);
      function get_GlyphWidth(glph: Integer): Cardinal;
      function get_Glyph(idx: Integer): Cardinal;
      function GetFamilyName: WideString;
      // Methods
    public
      checksum_action: ChecksumFaultAction;
      constructor Create(bgn: Pointer; font: Pointer;
        action: ChecksumFaultAction);
      destructor Destroy; override;
      procedure AddCharacterToKeepList(ch: WideChar);
      procedure ParseSingleGlyph(idx: Word);
      procedure BuildGlyphIndexList(used_glyphs: TList; uniscribe: boolean;
        decompose: boolean; collate: boolean; use_kerning: boolean);
      function PackFont(translate_to: FontType; uniscribe: boolean): TByteArray;
      procedure PrepareFont(skip_list: TIntegerList);
      property Names: NameTableClass read name_table;
      property UsedGlyphs: TList write set_UsedGlyphs;
      property Widths: TList read GlyphWidths;
      property Width[glph: Integer]: Cardinal read get_GlyphWidth;
      property Glyph[idx: Integer]: Cardinal read get_Glyph;
      property SubstitutionName: String read FSubstitutionName
        write FSubstitutionName;
      property FamilyName: WideString read GetFamilyName;
    end;

procedure AddIgnoreChecksum(FamilyName: String);
procedure DeleteIgnoreChecksum(FamilyName: String);

implementation

uses SysUtils;

var
  IgnoreChecksumList: TStringList;

procedure AddIgnoreChecksum(FamilyName: String);
begin
  IgnoreChecksumList.Add(FamilyName);
end;

procedure DeleteIgnoreChecksum(FamilyName: String);
var
  Index: Integer;
begin
  if IgnoreChecksumList.Find(FamilyName, Index) then
    IgnoreChecksumList.Delete(Index);
end;

function IsIgnoreChecksum(FamilyName: String): Boolean;
var
  Index: Integer;
begin
  Result := IgnoreChecksumList.Find(FamilyName, Index);
end;

{ TrueTypeFont }

    function TrueTypeFont.get_Glyph(idx: Integer): Cardinal;
    begin
      Result := Cardinal(Indices[idx]);
    end;

    function TrueTypeFont.get_GlyphWidth(glph: Integer): Cardinal;
    var
      i: Integer;
      k: Integer;
    begin
      for i := 0 to self.Indices.Count-1 do begin
        k := Integer(self.Indices[i]);
        if k = glph then begin
          Result := Cardinal(self.GlyphWidths[i]);
          Exit;
        end;
      end;
      result := 0; //  Self.windows_metrix.AvgCharWidth;
    end;

    constructor TrueTypeFont.Create(bgn: Pointer; font: Pointer; action: ChecksumFaultAction);
    begin
      self.ListOfTables :=  TList.Create;
      self.ListOfUsedGlyphs := TList.Create;
//      self.ListOfUsedWidths := TList.Create;
      self.beginfile_ptr := bgn;
      self.selector_ptr := font;
      self.checksum_action := action;
      self.GlyphWidths := TIntegerList.Create;
      FSubstitutionName := '';
    end;

    destructor TrueTypeFont.Destroy;
    var
      t:    TrueTypeTable;
      i: Integer;
    begin
      for i := 0 to self.ListOfTables.Count - 1 do
      begin
        t := self.ListOfTables.Items[i];
        t.Free;
      end;
      self.ListOfTables.Clear;
      self.ListOfTables.Free;
      self.ListOfUsedGlyphs.Clear;
      self.ListOfUsedGlyphs.Free;
//      self.ListOfUsedWidths.Clear;
//      self.ListOfUsedWidths.Free;
      self.GlyphWidths.Clear;
      self.GlyphWidths.Free;
      if self.Indices <> nil then
        begin
          self.Indices.Clear;
          self.Indices.Free;
        end;
    end;

    procedure TrueTypeFont.set_UsedGlyphs(dict: TList);
    var
      i: Integer;
      key: Word;
    begin
      self.ListOfUsedGlyphs.Clear;
//      key := Word(' ');
//      self.ListOfUsedGlyphs.Add(Pointer(key));
      for i := 0 to dict.Count - 1 do
      if Integer(Word(dict[i])) = Integer(dict[i]) then
      begin
        key := Word(dict[i]);
        if (self.ListOfUsedGlyphs.IndexOf(Pointer(key)) = -1) then
          self.ListOfUsedGlyphs.Add(Pointer(key))
      end
      else
        raise Exception.Create('Format error');
    end;

    procedure TrueTypeFont.AddCharacterToKeepList(ch: WideChar);
    var
      key: Word;
    begin
        key := Word(ch);
        if (self.ListOfUsedGlyphs.IndexOf(Pointer(key)) = -1) then
        begin
            self.ListOfUsedGlyphs.Add(Pointer(key));
        end;
    end;

    procedure TrueTypeFont.ParseSingleGlyph(idx: Word);
    const
      collate   : Boolean = True;
      decompose : Boolean = False;
    var
        location: Cardinal;
        composed_idx: Word;
        j, Length, GlyphWidth: Integer;
//        hash_index: Cardinal;
        composed_indexes: TIntegerlist;
        new_key: Smallint;
//        kerning: Smallint;
    begin
      Length := self.index_to_location.GetGlyph(idx, self.font_header, location);
      if (Length <> 0) then
      begin
        composed_indexes := self.glyph_table.CheckGlyph(Cardinal(location), length);
        for j := 0 to composed_indexes.Count - 1 do
        begin
          composed_idx := Word(composed_indexes[j]);
          new_key := Indices.IndexOf(Pointer(composed_idx));
          if (not collate or (decompose and (new_key = -1))) then begin
            Indices.Add( Pointer(composed_idx));
            GlyphWidth := ((self.horizontal_metrix_table.Item[idx].advanceWidth * $3e8) div self.font_header.unitsPerEm) - 2;
            GlyphWidths.Add(Pointer(GlyphWidth))
          end;
        end;
        if (not collate or (Indices.IndexOf(Pointer(idx)) = -1)) then
        begin
          Indices.Add( Pointer(idx));
          GlyphWidth := ((self.horizontal_metrix_table.Item[idx].advanceWidth * $3e8) div self.font_header.unitsPerEm) - 2;
{
          if (use_kerning and ((i < (used_glyphs.Count - 1)) and (self.kerning_table <> nil))) then
          begin
            new_key := Word(used_glyphs[i + 1]);
            if uniscribe then next_idx := new_key else next_idx :=  self.cmap_table.GetGlyphIndex(new_key);
            hash_index := Cardinal(idx or (next_idx shl $10));
            kerning := self.kerning_table.Item[hash_index];
            inc(GlyphWidth, ((kerning * $3e8) div self.font_header.unitsPerEm))
          end;
}
          GlyphWidths.Add(Pointer(GlyphWidth))
        end;
        composed_indexes.Free;
      end
      else
      begin
        new_key := Indices.IndexOf(Pointer(idx));
        if ((idx = $3) and (not collate or (new_key = -1))) then
        begin
          Indices.Add(Pointer(idx));
          j := (self.windows_metrix.AvgCharWidth * $3e8) div self.font_header.unitsPerEm;
          GlyphWidths.Add(Pointer(j))
        end;
      end;
    end;

    procedure TrueTypeFont.BuildGlyphIndexList(used_glyphs: TList; uniscribe: boolean; decompose: boolean; collate: boolean; use_kerning: boolean );
    var
        location: Cardinal;
        composed_idx: Word;
        i, j, length, GlyphWidth: Integer;
        key, idx, next_idx: Word;
        hash_index: Cardinal;
        composed_indexes: TIntegerlist;
        new_key, kerning: Smallint;
    begin
        Indices := TIntegerList.Create;
        i := 0;
        while ((i < used_glyphs.Count)) do
        begin
            key := Word(used_glyphs[i]);
            if uniscribe then idx := key else idx := self.cmap_table.GetGlyphIndex(key);
            length := self.index_to_location.GetGlyph(idx, self.font_header, location);
            if (length <> 0) then
            begin
              composed_indexes := self.glyph_table.CheckGlyph(Cardinal(location), length);
              for j := 0 to composed_indexes.Count - 1 do
              begin
                composed_idx := Word(composed_indexes[j]);
                new_key := Indices.IndexOf(Pointer(composed_idx));
                if (not collate or (decompose and (new_key = -1))) then begin
                  Indices.Add( Pointer(composed_idx));
                  if idx < self.horizontal_metrix_table.NumberOfMetrics then
                    GlyphWidth := ((self.horizontal_metrix_table.Item[idx].advanceWidth * $3e8) div self.font_header.unitsPerEm)
                  else
                    GlyphWidth := (self.windows_metrix.AvgCharWidth * $3e8) div self.font_header.unitsPerEm;
                  GlyphWidths.Add(Pointer(GlyphWidth))
                end;
              end;
              if (not collate or (Indices.IndexOf(Pointer(idx)) = -1)) then
              begin
                Indices.Add( Pointer(idx));
                  GlyphWidth := ((self.horizontal_metrix_table.Item[idx].advanceWidth * $3e8) div self.font_header.unitsPerEm);
//                if (use_kerning and ((i < (used_glyphs.Count - 1)) and (self.kerning_table <> nil))) then
//                begin
//                  new_key := Word(used_glyphs[i + 1]);
//                  if uniscribe then next_idx := new_key else next_idx :=  self.cmap_table.GetGlyphIndex(new_key);
//                  hash_index := Cardinal(idx or (next_idx shl $10));
//                  kerning := self.kerning_table.Item[hash_index];
//                  inc(GlyphWidth, ((kerning * $3e8) div self.font_header.unitsPerEm))
//                end;

                if (use_kerning and (i < (used_glyphs.Count - 1))) then
                begin
                  new_key := Word(used_glyphs[i + 1]);
                  if uniscribe then next_idx := new_key else next_idx :=  self.cmap_table.GetGlyphIndex(new_key);
                  hash_index := Cardinal(idx or (next_idx shl 16));
                  kerning := 0;
                  if (self.kerning_table <> nil) then
                    kerning := self.kerning_table.Item[hash_index];
                  //if (kerning = 0) then
                  //  kerning := self.horizontal_metrix_table.Item[next_idx].lsb;

                  Dec(GlyphWidth, ((kerning * $3e8) div self.font_header.unitsPerEm))
                end;

                GlyphWidths.Add(Pointer(GlyphWidth))
              end;
              composed_indexes.Free;
            end
            else
            begin
              new_key := Indices.IndexOf(Pointer(idx));
              if new_key = -1 then
              begin
                Indices.Add(Pointer(idx));
                if key <> $667 then
                  begin
                    if location <> 0 then
                      j := ((self.horizontal_metrix_table.Item[idx].advanceWidth * $3e8) div self.font_header.unitsPerEm)
                    else
                      j := (self.windows_metrix.AvgCharWidth * $3e8) div self.font_header.unitsPerEm;
                  end
                else
                  j := 0;
                if (use_kerning and (i < (used_glyphs.Count - 1))) then
                begin
                  new_key := Word(used_glyphs[i + 1]);
                  if uniscribe then next_idx := new_key else next_idx :=  self.cmap_table.GetGlyphIndex(new_key);
                  hash_index := Cardinal(idx or (next_idx shl 16));
                  kerning := 0;
                  if (self.kerning_table <> nil) then
                    kerning := self.kerning_table.Item[hash_index];

                  Dec(j, ((kerning * $3e8) div self.font_header.unitsPerEm));
                end;
                GlyphWidths.Add(Pointer(j))
              end;
            end;
            inc(i)
        end;
    end;

  {$OVERFLOWCHECKS OFF}
    function TrueTypeFont.CalcTableChecksum(font: Pointer; entry: TrueTypeTable; debug: boolean): Cardinal;
    var
      Sum, Length, i: LongWord;
      Temp: ^LongWord;
      test: LongWord;
    begin
      Sum := 0;
      Length := entry.length div 4;
      Temp := TTF_Helpers.Increment(font, entry.offset );
      i := 0;
      while ((i < Length)) do
      begin
          inc( Sum, TTF_Helpers.SwapUInt32( Temp^ ));
          Inc( Temp, 1 );
          Inc(i, 1)
      end;

      if entry.length mod 4 <> 0 then
      begin
        i := i*4;
        Test := $ffffffff;
        if i + 1 = entry.length then Test:= $ff000000;
        if i + 2 = entry.length then Test:= $ffff0000;
        if i + 3 = entry.length then Test:= $ffffff00;
        inc( Sum, (Test and TTF_Helpers.SwapUInt32( Temp^ )) );
      end;
      Result := Sum;
    end;

    procedure TrueTypeFont.CalculateFontChecksum(start_offset: Pointer; font_length: Cardinal);
    var
      Sum, Length, i: LongWord;
      Temp: ^LongWord;
    begin
        Sum := 0;
        length := font_length div 4;
        Temp := start_offset;
        i := 0;
        while ((i < length)) do
        begin
            Inc(Sum, TTF_Helpers.SwapUInt32( Temp^ ));
            Inc( Temp );
            Inc(i, 1)
        end;
        Sum := ($b1b0afba - Sum);
        self.font_header.SaveFontHeader(self.beginfile_ptr, Sum)
    end;
  {$OVERFLOWCHECKS ON}

    procedure TrueTypeFont.ChangeEndian;
    begin
        self.dir.sfntversion := TTF_Helpers.SwapUInt32(self.dir.sfntversion);
        self.dir.numTables := TTF_Helpers.SwapUInt16(self.dir.numTables);
        self.dir.searchRange := TTF_Helpers.SwapUInt16(self.dir.searchRange);
        self.dir.entrySelector := TTF_Helpers.SwapUInt16(self.dir.entrySelector);
        self.dir.rangeShift := TTF_Helpers.SwapUInt16(self.dir.rangeShift)
    end;

    procedure TrueTypeFont.CheckTablesChecksum;
    var
      entry: TrueTypeTable;
      checksum: Cardinal;
      i:  Integer;
    begin
      if (self.checksum_action <> ChecksumFaultAction_IgnoreChecksum)
         and not IsIgnoreChecksum(self.FamilyName) then
        for i := 0 to self.ListOfTables.Count - 1 do try
          entry := self.ListOfTables.Items[i];
          checksum := self.CalcTableChecksum(self.beginfile_ptr, entry, false);
          if ( checksum <> entry.checkSum) then
            raise Exception.Create( String('Table ID "' + entry.TAGLINE + '" checksum error.' + IntToStr(checksum) + ' ' + IntToStr(entry.checkSum)))
          except
            on ex: Exception do
            begin
                if (self.checksum_action = ChecksumFaultAction_ThrowException) then
                    raise ex;
                if (Windows.MessageBox(GetDesktopWindow, PChar(ex.Message), PChar('Font table checksum error'), MB_YESNO) = 0) then
                    raise ex
            end
          end
    end;

{$IFDEF DRAWING_MANUALLY}
    function TrueTypeFont.DrawString(text: string; position: Point; size: Integer): GraphicsPath;
    var
        ch: Char;
        location: Cardinal;
        gheader: GlyphHeader;
        glyph_path: GraphicsPath;
        composed_idx: Word;
    begin
        path := GraphicsPath.Create(FillMode.Winding);
        rsize := ((self.font_header.unitsPerEm as Single) div (size as Single));
        uniscribe := false;

        for ch in text do
        begin
            glyph_width := 0;
            gheader.xMin := 0;
            gheader.xMax := 10;
            idx :=  /*pseudo*/ (if uniscribe then ch else self.cmap_table.GetGlyphIndex(ch));
            glyph_size := self.index_to_location.GetGlyph(idx, self.font_header, @(location));
            if (glyph_size <> 0) then
            begin
                composed_indexes := self.glyph_table.CheckGlyph((location as Integer), glyph_size);
                if (composed_indexes.Count <> 0) then

                    for composed_idx in composed_indexes do
                    begin
                        glyph_size := self.index_to_location.GetGlyph(composed_idx, self.font_header, @(location));
                        glyph_path := self.glyph_table.GetGlyph((location as Integer), glyph_size, rsize, position, @(gheader));
                        path.AddPath(glyph_path, false)
                    end
                else
                begin
                    glyph_path := self.glyph_table.GetGlyph((location as Integer), glyph_size, rsize, position, @(gheader));
                    path.AddPath(glyph_path, false)
                end
            end;
            glyph_width := (((gheader.xMax as Single) div rsize) as Integer);
            inc(glyph_width, 4);
            inc(position.X, glyph_width)
        end;
        begin
            Result := path;
            exit
        end
    end;

    function TrueTypeFont.GetGlyph(ch: Char; size: Integer; position: Point): GraphicsPath;
    var
        gheader: GlyphHeader;
        location: Cardinal;
    begin
        i2l_idx := self.cmap_table.GetGlyphIndex(ch);
        length := self.index_to_location.GetGlyph(i2l_idx, self.font_header, @(location));
        rsize := ((self.font_header.unitsPerEm as Single) div (size as Single));
        Result := self.glyph_table.GetGlyph((location as Integer), length, rsize, position, @(gheader))
    end;

    function TrueTypeFont.GetGlyphIndices(text: string; [Out] var glyphs: Word[]; [Out] var widths: Integer[]; rtl: boolean): Integer;
    var
        ch: Char;
    begin
        text_as_array := ArrayList.Create;

        for ch in text do
        begin
            text_as_array.Add((ch as Word))
        end;
        self.BuildGlyphIndexList(text_as_array, false, false, false, True, @(text_as_array), @(text_widths));
        glyphs := (text_as_array.ToArray(typeof(Word)) as Word[]);
        widths := (text_widths.ToArray(typeof(Integer)) as Integer[]);
        text_widths.Destroy;
        begin
            Result := glyphs.Length;
            exit
        end
    end;
{$ENDIF}

(*    procedure TrueTypeFont.GetOutlineTextMetrics(var FTextMetric: OutlineTextMetricW);
    begin
        FTextMetric.otmSize := $d4;
        FTextMetric.otmTextMetrics.tmHeight := (self.windows_metrix.Ascent + self.windows_metrix.Descent);
        FTextMetric.otmTextMetrics.tmAscent := self.windows_metrix.Ascent;
        FTextMetric.otmTextMetrics.tmDescent := self.windows_metrix.Descent;
        FTextMetric.otmTextMetrics.tmAveCharWidth := self.windows_metrix.AvgCharWidth;
        FTextMetric.otmTextMetrics.tmMaxCharWidth := self.horizontal_header.MaxWidth;
        FTextMetric.otmTextMetrics.tmFirstChar := WideChar(self.windows_metrix.FirstCharIndex);
        FTextMetric.otmTextMetrics.tmLastChar := WideChar(self.windows_metrix.LastCharIndex);
        FTextMetric.otmTextMetrics.tmDefaultChar := WideChar(self.windows_metrix.DefaultChar);
        FTextMetric.otmTextMetrics.tmBreakChar := WideChar(self.windows_metrix.BreakChar);
        FTextMetric.otmPanoseNumber.bFamilyType := self.windows_metrix.Panose[0];
        FTextMetric.otmPanoseNumber.bSerifStyle := self.windows_metrix.Panose[1];
        FTextMetric.otmPanoseNumber.bWeight := self.windows_metrix.Panose[2];
        FTextMetric.otmPanoseNumber.bProportion := self.windows_metrix.Panose[3];
        FTextMetric.otmPanoseNumber.bContrast := self.windows_metrix.Panose[4];
        FTextMetric.otmPanoseNumber.bStrokeVariation := self.windows_metrix.Panose[5];
//        FTextMetric.otmPanoseNumber.ArmStyle := self.windows_metrix.Panose[6];
        FTextMetric.otmPanoseNumber.bLetterform := self.windows_metrix.Panose[7];
        FTextMetric.otmPanoseNumber.bMidline := self.windows_metrix.Panose[8];
        FTextMetric.otmPanoseNumber.bXHeight := self.windows_metrix.Panose[9];
        FTextMetric.otmItalicAngle := ((self.postscript.ItalicAngle shr $10) * 10);
        FTextMetric.otmEMSquare := self.font_header.unitsPerEm;
        FTextMetric.otmAscent := self.horizontal_header.Ascender;
        FTextMetric.otmDescent := self.horizontal_header.Descender;
        if self.horizontal_header.LineGap > 0 then
          FTextMetric.otmLineGap := Cardinal(self.horizontal_header.LineGap)
        else
          FTextMetric.otmLineGap := 0;
        FTextMetric.otmpFamilyName := PAnsiChar(AnsiString(self.name_table.Item[FamilyName]));
        FTextMetric.otmpFullName := PAnsiChar(AnsiString(self.name_table.Item[FullName]))
    end;*)

    function CompareOffsets(P1, P2: Pointer): Integer;
    var
      V1, V2: Cardinal;
    begin
      V1 := PTableSortHelper(P1).Offset;
      V2 := PTableSortHelper(P2).Offset;
      if V1 = V2 then begin
        Result :=  0;
      end else if V1 > V2 then begin
        Result :=  1;
      end else begin
        Result := -1;
      end;
    end;

function TrueTypeFont.GetFamilyName: WideString;
begin
  Result := name_table.Item[NameID_FamilyName];
end;

function TrueTypeFont.GetTablesOrder: TTagList;
    var
      entry: TrueTypeTable;
      indexed_tags: TList;
      tables_positions: TList;
      i: Integer;
      helper: array[0..40] of TTableSortHelper;
      t: PTableSortHelper;
    begin
      tables_positions := TList.Create;
      for i := 0 to self.ListOfTables.Count - 1 do
      begin
        entry := self.ListOfTables[i];
        helper[i].Offset := entry.offset;
        helper[i].Tag    := entry.tag;
        tables_positions.Add( @helper[i]);
      end;

      tables_positions.Sort(CompareOffsets);

      indexed_tags := TList.Create;
      for i := 0 to tables_positions.Count - 1 do
      begin
        t := tables_positions[i];
        indexed_tags.Add(Pointer(t.TAG))
      end;
      tables_positions.Free;
      Result := indexed_tags;
    end;

    procedure TrueTypeFont.LoadCoreTables;
    var
      i : Integer;
      t : TrueTypeTable;
    begin
      for i := 0 to self.ListOfTables.Count - 1 do
      begin
        t := self.ListOfTables[i];
        case TablesID(t.tag)  of
          TablesID_FontHeader:  begin
            self.font_header := t as FontHeaderClass;
            self.font_header.Load(self.beginfile_ptr);
            end;
          TablesID_MaximumProfile: begin
            self.profile := t as MaximumProfileClass;
            self.profile.Load(self.beginfile_ptr);
          end;
          TablesID_HorizontalHeader: begin
            self.horizontal_header := t as HorizontalHeaderClass;
            self.horizontal_header.Load(self.beginfile_ptr);
          end;
          TablesID_Postscript: begin
            self.postscript := t as PostScriptClass;
            self.postscript.Load(self.beginfile_ptr)
          end;
          TablesID_OS2Table: begin
            self.windows_metrix := t as OS2WindowsMetricsClass;
            self.windows_metrix.Load(self.beginfile_ptr);
          end;
          TablesID_IndexToLocation: begin
            self.index_to_location := t as IndexToLocationClass;
            self.index_to_location.LoadIndexToLocation(self.beginfile_ptr, self.font_header);
          end;
          TablesID_CMAP: begin
            self.cmap_table := t as CmapTableClass;
            self.cmap_table.LoadCmapTable(self.beginfile_ptr);
          end;
          TablesID_Name:          begin
            self.name_table := t as NameTableClass;
            self.name_table.Load(self.beginfile_ptr);
          end;
          TablesID_Glyph: begin
            self.glyph_table := t as GlyphTableClass;
            self.glyph_table.Load(self.beginfile_ptr);
          end;
          TablesID_KerningTable: begin
            self.kerning_table := t as KerningTableClass;
            self.kerning_table.Load(self.beginfile_ptr)
          end;
          TablesID_GlyphSubstitution: begin
            self.gsub_table := t as GlyphSubstitutionClass;
            self.gsub_table.Load(self.beginfile_ptr)
          end;
          TablesID_PreProgram: begin
            self.preprogram_table := t as PreProgramClass;
            self.preprogram_table.Load(self.beginfile_ptr);
          end;
          TablesID_HorizontalMetrix: begin
            self.horizontal_metrix_table := t as HorizontalMetrixClass;
            self.horizontal_metrix_table.NumberOfMetrics := horizontal_header.NumberOfHMetrics;
            self.horizontal_metrix_table.Load(self.beginfile_ptr);
          end
      end;
      end;

    end;

    procedure TrueTypeFont.LoadDescriptors(skip_array: TIntegerList);
    var
        parsed_table: TrueTypeTable;
        table: TrueTypeTable;
        i: Integer;
        tdir_ptr: ^TableDirectory;
        entry_ptr: ^TableEntry;
    begin
        tdir_ptr := self.selector_ptr;
        self.dir.sfntversion := tdir_ptr.sfntversion;
        self.dir.numTables := tdir_ptr.numTables;
        self.dir.searchRange := tdir_ptr.searchRange;
        self.dir.entrySelector := tdir_ptr.entrySelector;
        self.dir.rangeShift := tdir_ptr.rangeShift;
        self.ChangeEndian;
        entry_ptr := TTF_Helpers.Increment(self.selector_ptr, SizeOf(TableDirectory));
        i := 0;
        while ((i < self.dir.numTables)) do
        begin
            table := TrueTypeTable.Create(entry_ptr);
            if (skip_array.IndexOf( Pointer(table.tag)) = -1) then
            begin
                case ( TablesID(table.tag) ) of
                    TablesID_HorizontalHeader:
                        begin
                          parsed_table := HorizontalHeaderClass.Create(table);
                          table.Destroy;
                          end;
                    TablesID_FontHeader:
                        begin
                          parsed_table := FontHeaderClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_Name:
                        begin
                          parsed_table := NameTableClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_OS2Table:
                        begin
                          parsed_table := OS2WindowsMetricsClass.Create(table);
                          table.Destroy;
                          end;
                    TablesID_GlyphSubstitution:
                        begin
                          parsed_table := GlyphSubstitutionClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_IndexToLocation:
                        begin
                          parsed_table := IndexToLocationClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_Glyph:
                        begin
                          parsed_table := GlyphTableClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_KerningTable:
                        begin
                          parsed_table := KerningTableClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_CMAP:
                        begin
                          parsed_table := CmapTableClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_Postscript:
                        begin
                          parsed_table := PostScriptClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_HorizontalMetrix:
                        begin
                          parsed_table := HorizontalMetrixClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_PreProgram:
                        begin
                          parsed_table := PreProgramClass.Create(table);
                          table.Destroy;
                        end;
                    TablesID_MaximumProfile:
                        begin
                          parsed_table := MaximumProfileClass.Create(table);
                          table.Destroy;
                        end;
                    else
                        begin parsed_table := table; end;
                  end;
                try
                  self.ListOfTables.Add( parsed_table)
                except
                    on ex: Exception do
                      Windows.MessageBox(0, PChar(ex.Message), PChar('Font format error'), MB_YesNo)
                end
            end
            else begin
              table.Destroy;
            end;
            entry_ptr := TTF_Helpers.Increment(entry_ptr, SizeOf(TableEntry));
            inc(i);
        end;
        self.dir.numTables := self.ListOfTables.Count
    end;

    function CompareTags(P1, P2: Pointer): Integer;
    var
      V1, V2: Cardinal;
    begin
      V1 := TTF_Helpers.SwapUInt32( PTableSortHelper(P1).TAG );
      V2 := TTF_Helpers.SwapUInt32( PTableSortHelper(P2).TAG );
      if V1 = V2 then begin
        Result :=  0;
      end else if V1 > V2 then begin
        Result :=  1;
      end else begin
        Result := -1;
      end;
    end;

    procedure TrueTypeFont.SaveDescriptors(position: Pointer);
    var
      k, i: Integer;
      td_ptr: ^TableDirectory;
      descriptor_list: TList;
      tbls: Pointer;
      table:  TrueTypeTable;
      helper: array[0..40] of TTableSortHelper;
      desc: PTableSortHelper;
    begin
        td_ptr := position;
        td_ptr.sfntversion := TTF_Helpers.SwapUInt32(self.dir.sfntversion);
        td_ptr.numTables := TTF_Helpers.SwapUInt16(self.dir.numTables);
        td_ptr.searchRange := TTF_Helpers.SwapUInt16(self.dir.searchRange);
        td_ptr.entrySelector := TTF_Helpers.SwapUInt16(self.dir.entrySelector);
        td_ptr.rangeShift := TTF_Helpers.SwapUInt16(self.dir.rangeShift);

        tbls := TTF_Helpers.Increment(position, SizeOf(TableDirectory));
        descriptor_list := TList.Create;
        for i := 0 to self.ListOfTables.Count - 1 do
        begin
          table := self.ListOfTables[i];
          helper[i].Offset := table.offset;
          helper[i].Tag    := table.tag;
          descriptor_list.Add( @helper[i]);
        end;
        descriptor_list.Sort(CompareTags);

        for k := 0 to descriptor_list.Count - 1 do
        begin
          desc := descriptor_list[k];
          begin
            for i := 0 to self.ListOfTables.Count - 1 do
              begin
                table := self.ListOfTables[i];
                if table.tag = desc.TAG then
                begin
                  tbls := table.StoreDescriptor(tbls);
                  break;
                end;
              end;
{$IFDEF DEBUG_FONT_TAGS}
              Writeln(
                'Indexed tag ', TrueTypeTable(self.ListOfTables.Items[tag]).TAGLINE,
                ' Checksum ', IntToHex(TrueTypeTable(self.ListOfTables.Items[tag]).checkSum, 8),
                ' Size ', TrueTypeTable(self.ListOfTables.Items[tag]).length );
{$ENDIF}
          end;
        end;
        descriptor_list.Free;
    end;

    function TrueTypeFont.PackFont(translate_to: FontType; uniscribe: boolean): TByteArray;
    var
      indexed_tags: TTagList;
      current_offset: Cardinal;
      buff: TByteArray;
      i: Integer;
      j: Integer;
      ptr: ^Byte;
      table:  TrueTypeTable;
    begin
        indexed_tags := self.GetTablesOrder;
        self.ReorderGlyphTable(self.beginfile_ptr, uniscribe);
        current_offset := Cardinal( 12 {SizeOf(FontHeaderClass.FontHeader)} + (self.dir.numTables * $10));
        for i := 0 to indexed_tags.Count - 1 do
          for j := 0 to self.ListOfTables.Count - 1 do
          begin
            table := self.ListOfTables[j];
            if table.tag = Cardinal(indexed_tags[i]) then
            begin
              current_offset := table.Save(self.beginfile_ptr, current_offset);
              if ((current_offset mod 4) <> 0) then
                 raise Exception.Create('Align error');
            end;
          end;
        self.SaveDescriptors(self.beginfile_ptr);
        self.CalculateFontChecksum(self.beginfile_ptr, current_offset);
        SetLength( buff, current_offset );
        ptr := self.beginfile_ptr;
        for i:=0 to current_offset - 1 do
        begin
          buff[i] := ptr^;
          Inc(Ptr);
        end;
        indexed_tags.Free;
        Result := buff;
        buff := nil;
    end;

    procedure TrueTypeFont.PrepareFont(skip_list: TIntegerList);
    begin
        self.LoadDescriptors(skip_list);
        self.LoadCoreTables;
        self.CheckTablesChecksum;
    end;

    function ThisSort(Item1, Item2: Pointer): Integer;
    begin
       if ( Integer(Item1) < Integer(Item2) ) then Result := -1
       else if (Integer(Item1) > Integer(Item2) )
       then Result := 1  else Result := 0;
    end;

    procedure TrueTypeFont.ReorderGlyphTable(position: Pointer; uniscribe: boolean);
    var
        composite_indexes: TIntegerList;
        i,j: Integer;
        idx: Word;
        i2l_idx: Word;
        length: Word;
        glyph_table_size, location: Cardinal;
        LongIndexToLocation: TCardinalArray;
        ShortIndexToLocation: frxIndexToLocationClass.TWordArray;
        table_entry:  TrueTypeTable;
        out_index : Cardinal;
        sqz_index : Integer;
        glyph_table_ptr: ^Byte;
        glyph_ptr: ^Byte;
        SelectedGlyphs: Array of Byte;
        i2ll_ptr: ^Cardinal;
        i2ls_ptr: ^Smallint;
{$IFDEF DEBUG_STORE_PACKED_GLYPFS}
        out_ms: TMemoryStream;
{$ENDIF}
    begin
        ShortIndexToLocation := self.index_to_location.Short;
        LongIndexToLocation := self.index_to_location.Long;
        self.ListOfUsedGlyphs.Sort(ThisSort);
//        self.ListOfUsedGlyphs.Add(nil);
        self.BuildGlyphIndexList(self.ListOfUsedGlyphs, uniscribe, true, true, True );
//        composite_indexes := Self.Indices;
        composite_indexes := TList.Create;
        for i := 0 to Self.Indices.Count - 1 do
          composite_indexes.Add(Self.Indices[i]);

        composite_indexes.Sort(ThisSort);
        glyph_table_size := 0;
//        length := 0;
        location := 0;

        for i := 0 to composite_indexes.Count - 1 do
        begin
            idx := Integer(composite_indexes[i]);
            inc(glyph_table_size, self.index_to_location.GetGlyph(idx, self.font_header, location))
        end;

        table_entry := nil;
        for i := 0 to self.ListOfTables.Count - 1 do
        begin
          table_entry := self.ListOfTables[i];
          if table_entry.tag = Cardinal(TablesID_Glyph) then break;
        end;
        if table_entry = nil then raise Exception.Create('Glyph table not found');

        glyph_table_ptr := TTF_Helpers.Increment(self.beginfile_ptr, (table_entry.offset));
        SetLength( SelectedGlyphs, glyph_table_size);
        out_index := 0;
        sqz_index := 0;

        for i := 0 to composite_indexes.Count - 1 do
        begin
          i2l_idx := Integer(composite_indexes[i]);
          length := self.index_to_location.GetGlyph(i2l_idx, self.font_header, location);
          case self.font_header.indexToLocFormat of
            IndexToLoc_ShortType:
                while ((sqz_index <= i2l_idx)) do
                begin
                  ShortIndexToLocation[sqz_index] := Word((out_index div 2));
                  inc(sqz_index);
                end;
            IndexToLoc_LongType:
                while ((sqz_index <= i2l_idx)) do
                begin
                  LongIndexToLocation[sqz_index] := out_index;
                  inc(sqz_index);
                end
            else raise Exception.Create('Unknown IndexToLoc value')
          end;
          if length <> 0 then
          begin
            glyph_ptr := TTF_Helpers.Increment(glyph_table_ptr, location);
            for j:= 0 to length-1 do
            begin
              SelectedGlyphs[out_index + Cardinal(j)] := glyph_ptr^;
              Inc(glyph_ptr);
            end;
            Inc(out_index, length);
          end;
        end;

        glyph_table_ptr := TTF_Helpers.Increment(self.beginfile_ptr, (table_entry.offset));
        if out_index > 0 then
          for i:= 0 to out_index do
          begin
            glyph_table_ptr^ := SelectedGlyphs[i];
            Inc(glyph_table_ptr);
          end;
        table_entry.length := out_index;

{$IFDEF DEBUG_STORE_PACKED_GLYPFS}
        glyph_table_ptr := TTF_Helpers.Increment(self.beginfile_ptr, (table_entry.offset));
        out_ms := TMemoryStream.Create;
        with out_ms do begin
          SetSize(out_index);
          CopyMemory(out_ms.Memory, glyph_table_ptr, out_index);
        end;
        out_ms.SaveToFile('packed_glyf.bin');
        out_ms.Clear;
        out_ms.Free;
{$ENDIF}

        SetLength( SelectedGlyphs, 0);
        SelectedGlyphs := nil;
        for i := 0 to self.ListOfTables.Count - 1 do
        begin
          table_entry := self.ListOfTables[i];
          if table_entry.tag = Cardinal(TablesID_IndexToLocation) then break;
        end;

        i := 0;
        case self.font_header.indexToLocFormat of
          IndexToLoc_ShortType:
          begin
            i2ls_ptr := TTF_Helpers.Increment(self.beginfile_ptr, table_entry.offset);
            while (sqz_index < High(ShortIndexToLocation)) do
            begin
              ShortIndexToLocation[sqz_index] := Word((out_index div 2));
              inc(sqz_index)
            end;
            while (i < High(ShortIndexToLocation)) do
            begin
              i2ls_ptr^ :=  Smallint(TTF_Helpers.SwapUInt16(ShortIndexToLocation[i]));
              Inc(i2ls_ptr);
              inc(i)
            end;
          end;

          IndexToLoc_LongType:
          begin
            i2ll_ptr := TTF_Helpers.Increment(self.beginfile_ptr, table_entry.offset);
            while (sqz_index <= High(LongIndexToLocation)) do
            begin
                LongIndexToLocation[sqz_index] := out_index;
                inc(sqz_index)
            end;
            while (i <= High(LongIndexToLocation)) do
            begin
              i2ll_ptr^ := Cardinal(TTF_Helpers.SwapUInt32(LongIndexToLocation[i]));
              Inc(i2ll_ptr);
              inc(i)
            end;
          end;
        end;
        table_entry.checkSum := self.CalcTableChecksum(self.beginfile_ptr, table_entry, false);
        for i := 0 to self.ListOfTables.Count - 1 do
        begin
          table_entry := self.ListOfTables[i];
          if table_entry.tag = Cardinal(TablesID_Glyph) then
          begin
            table_entry.checkSum := self.CalcTableChecksum(self.beginfile_ptr, table_entry, true );
            break;
          end;

        end;
      composite_indexes.Free;
    end;

initialization

  IgnoreChecksumList := TStringList.Create;
  IgnoreChecksumList.CaseSensitive := False;
  IgnoreChecksumList.Duplicates := dupIgnore;
  IgnoreChecksumList.Sorted := True;
  AddIgnoreChecksum('EanGniv?');
//  AddIgnoreChecksum('ISDiagra?');
  AddIgnoreChecksum('Roboto Cn');

finalization

  IgnoreChecksumList.Free;

end.
