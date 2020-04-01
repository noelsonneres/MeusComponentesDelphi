unit frxGlyphTableClass;

interface

{$I frx.inc}

uses TTFHelpers, Classes, frxTrueTypeTable;

    type // Nested Types
        TIntegerList = TList;
        CompositeFlags = (ARG_1_AND_2_ARE_WORDS=1, ARGS_ARE_XY_VALUES=2, MORE_COMPONENTS=$20, OVERLAP_COMPOUND=$400, RESERVED=$10, ROUND_XY_TO_GRID=4, SCALED_COMPONENT_OFFSET=$800, UNSCALED_COMPONENT_OFFSET=$10000, USE_MY_METRICS=$200, WE_HAVE_A_SCALE=8, WE_HAVE_A_TWO_BY_TWO=$80, WE_HAVE_AN_X_AND_Y_SCALE=$40, WE_HAVE_INSTRUCTIONS=$100);
        GlyphFlags = (ON_CURVE=1, REP=8, X_POSITIVE=$10, X_SAME=$10, X_SHORT=2, Y_POSITIVE=$20, Y_SAME=$20, Y_SHORT=4);

        CompositeGlyphHeader = packed record
            flags: Word;
            glyphIndex: Word;
        end;
        GlyphHeader = packed record
            numberOfContours: Smallint;
            xMin: Smallint;
            yMin: Smallint;
            xMax: Smallint;
            yMax: Smallint;
        end;
        GlyphTableClass = class(TrueTypeTable)
          private glyph_table_ptr: Pointer;

          // Methods
          public constructor Create(src: TrueTypeTable);
          destructor Destroy; override;
          {
          strict private procedure AddSpline(path: GraphicsPath; pntStart: PointF; pntB: PointF; pntEnd: PointF; position: Point);
          private function GetGlyph(glyph_offset: Integer; glyph_data_size: Integer; font_rsize: Single; position: Point; [Out] var gheader: GlyphHeader): GraphicsPath;
          }
          public function CheckGlyph(glyph_offset: Integer; glyph_size: Integer): TIntegerList;
          private function GetGlyphHeader(glyph_offset: Integer): GlyphHeader;
          public procedure Load(font: Pointer); override;
//          strict private function ReadRawByte(ptr: Pointer; var val: Byte): Pointer;
        end;

        GlyphPoint = class
            // Properties
//            public property Point: TPointF read get_Point;

            // Fields
            public end_of_contour: boolean;
            public on_curve: boolean;
            public x: Single;
            public y: Single;
        end;

implementation

//function GlyphPoint.get_Point: TPointF;
//begin
//  Result := PointF(x, y);
//end;


// Methods
    constructor GlyphTableClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
    end;

    destructor GlyphTableClass.Destroy;
    begin
      inherited Destroy;
    end;
{
    procedure GlyphTableClass.AddSpline(path: GraphicsPath; pntStart: PointF; pntB: PointF; pntEnd: PointF; position: Point);
    begin
        pnt1 := pntStart;
        inc(pnt1.X, (0.6666667 * (pntB.X - pntStart.X)));
        inc(pnt1.Y, (0.6666667 * (pntB.Y - pntStart.Y)));
        pnt2 := pntB;
        inc(pnt2.X, ((pntEnd.X - pntB.X) div 3));
        inc(pnt2.Y, ((pntEnd.Y - pntB.Y) div 3));
        path.AddBezier(pntStart, pnt1, pnt2, pntEnd)
    end;
}
    function GlyphTableClass.CheckGlyph(glyph_offset: Integer; glyph_size: Integer): TIntegerlist;
    var
        gheader: GlyphHeader;
        pcgh: ^CompositeGlyphHeader;
        cgh: CompositeGlyphHeader;
        CompositeIndexes: TIntegerlist;
        glyph_ptr: Pointer;
        composite_header_ptr: Pointer;
    begin
        CompositeIndexes := TIntegerlist.Create;
        gheader := self.GetGlyphHeader(glyph_offset);

        glyph_ptr := TTF_Helpers.Increment(self.glyph_table_ptr, glyph_offset);
        if (gheader.numberOfContours < 0) then
        begin
            composite_header_ptr := TTF_Helpers.Increment(glyph_ptr, SizeOf(GlyphHeader));
            repeat
                pcgh := composite_header_ptr;
                cgh.flags := TTF_Helpers.SwapUInt16(pcgh.flags);
                cgh.glyphIndex := TTF_Helpers.SwapUInt16(pcgh.glyphIndex);
                CompositeIndexes.Add( Pointer(cgh.glyphIndex) );
                // Skip
                composite_header_ptr := TTF_Helpers.Increment(composite_header_ptr, SizeOf(CompositeGlyphHeader));
                if ((cgh.flags and 1) <> 0) then
                    composite_header_ptr := TTF_Helpers.Increment(composite_header_ptr, 4)
                else
                    composite_header_ptr := TTF_Helpers.Increment(composite_header_ptr, 2);
                if ((cgh.flags and 8) <> 0) then
                    composite_header_ptr := TTF_Helpers.Increment(composite_header_ptr, 2)
                else
                    if ((cgh.flags and $40) <> 0) then
                        composite_header_ptr := TTF_Helpers.Increment(composite_header_ptr, 4)
                    else
                        if ((cgh.flags and $80) <> 0) then
                            composite_header_ptr := TTF_Helpers.Increment(composite_header_ptr, 8)
            until ((cgh.flags and $20) = 0);
        end;
        Result := CompositeIndexes;
        exit
      end;
{
            function GlyphTableClass.GetGlyph(glyph_offset: Integer; glyph_data_size: Integer; font_rsize: Single; position: Point; [Out] var gheader: GlyphHeader): GraphicsPath;
            var
                i: Integer;
                val: Byte;
                sign: boolean;
                &end: PointF;
                next: PointF;
                implied: PointF;
                next_on_curve: boolean;
            begin
                glyph_ptr := TTF_Helpers.Increment(self.glyph_table_ptr, glyph_offset);
                gheader := (Marshal.PtrToStructure(glyph_ptr, typeof(GlyphHeader)) as GlyphHeader);
                gheader.numberOfContours := TTF_Helpers.SwapInt16(gheader.numberOfContours);
                gheader.xMax := TTF_Helpers.SwapInt16(gheader.xMax);
                gheader.yMax := TTF_Helpers.SwapInt16(gheader.yMax);
                gheader.xMin := TTF_Helpers.SwapInt16(gheader.xMin);
                gheader.yMin := TTF_Helpers.SwapInt16(gheader.yMin);
                endPtsOfContours := New(array[gheader.numberOfContours] of Word);
                ptr := TTF_Helpers.Increment(glyph_ptr, Marshal.SizeOf((gheader as GlyphHeader)));
                i := 0;
                while ((i < endPtsOfContours.Length)) do
                begin
                    endPtsOfContours[i] := TTF_Helpers.SwapUInt16((Marshal.PtrToStructure(ptr, typeof(Word)) as Word));
                    ptr := TTF_Helpers.Increment(ptr, 2);
                    inc(i)
                end;
                instructions_count := TTF_Helpers.SwapUInt16((Marshal.PtrToStructure(ptr, typeof(Word)) as Word));
                ptr := TTF_Helpers.Increment(ptr, 2);
                instructions := New(array[instructions_count] of Byte);
                Marshal.Copy(ptr, instructions, 0, instructions.Length);
                ptr := TTF_Helpers.Increment(ptr, instructions.Length);
                number_of_points := (endPtsOfContours[(endPtsOfContours.Length - 1)] + 1);
                flags := New(array[number_of_points] of Byte);
                points := New(array[number_of_points] of GlyphPoint);
                repeatCount := 0;
                repeatFlag := 0;
                i := 0;
                while ((i < number_of_points)) do
                begin
                    if (repeatCount > 0) then
                    begin
                        flags[i] := repeatFlag;
                        repeatCount := ((repeatCount - 1) as Byte)
                    end
                    else
                    begin
                        ptr := self.ReadRawByte(ptr, @(flags[i]));
                        if ((flags[i] and 8) <> 0) then
                        begin
                            ptr := self.ReadRawByte(ptr, @(repeatCount));
                            repeatFlag := flags[i]
                        end
                    end;
                    points[i] := GlyphPoint.Create;
                    points[i].on_curve := ((flags[i] and 1) <> 0);
                    inc(i)
                end;
                i := 0;
                while ((i < endPtsOfContours.Length)) do
                begin
                    points[endPtsOfContours[i]].end_of_contour := true;
                    inc(i)
                end;
                last := 0;
                i := 0;
                while ((i < number_of_points)) do
                begin
                    sign := ((flags[i] and $10) <> 0);
                    if ((flags[i] and 2) <> 0) then
                    begin
                        val := Marshal.ReadByte(ptr);
                        ptr := TTF_Helpers.Increment(ptr, 1);
                        last := ((last + } {pseudo} {(if sign then (val as Smallint) else (-val as Smallint))) as Smallint)
                    end
                    else
                        if (not sign) then
                        begin
                            last := ((last + TTF_Helpers.SwapInt16(Marshal.ReadInt16(ptr))) as Smallint);
                            ptr := TTF_Helpers.Increment(ptr, 2)
                        end;
                    points[i].x := ((last as Single) div font_rsize);
                    inc(i)
                end;
                last := 0;
                i := 0;
                while ((i < number_of_points)) do
                begin
                    sign := ((flags[i] and $20) <> 0);
                    if ((flags[i] and 4) <> 0) then
                    begin
                        val := Marshal.ReadByte(ptr);
                        ptr := TTF_Helpers.Increment(ptr, 1);
                        last := ((last +  }{pseudo}{ (if sign then (val as Smallint) else (-val as Smallint))) as Smallint)
                    end
                    else
                        if (not sign) then
                        begin
                            last := ((last + TTF_Helpers.SwapInt16(Marshal.ReadInt16(ptr))) as Smallint);
                            ptr := TTF_Helpers.Increment(ptr, 2)
                        end;
                    points[i].y := ((last as Single) div font_rsize);
                    inc(i)
                end;
                start_new_contour := true;
                idx := 0;
                path := GraphicsPath.Create(FillMode.Winding);
                first_point := points[idx];
                start_new_contour := true;
                beg := PointF.Create((points[0].Point.X + position.X), (position.Y - points[0].Point.Y));
                first := beg;
                idx := 0;
                while ((idx < points.Length)) do
                begin
                    curent_on_curve := points[idx].on_curve;
                    if ((idx + 1) < points.Length) then
                    begin
                        next := PointF.Create((points[(idx + 1)].Point.X + position.X), (position.Y - points[(idx + 1)].Point.Y));
                        next_on_curve := points[(idx + 1)].on_curve
                    end
                    else
                    begin
                        next := PointF.Create((points[0].Point.X + position.X), (position.Y - points[0].Point.Y));
                        next_on_curve := points[0].on_curve
                    end;
                    if (start_new_contour) then
                    begin
                        path.StartFigure;
                        first := beg;
                        start_new_contour := false
                    end;
                    if (points[idx].end_of_contour) then
                    begin
                        start_new_contour := true;
                        implied := PointF.Create((points[idx].Point.X + position.X), (position.Y - points[idx].Point.Y));
                        end := first;
                        if (curent_on_curve) then
                            path.AddLine(beg, end)
                        else
                            self.AddSpline(path, beg, implied, end, position);
                        beg := next
                    end
                    else
                        if (curent_on_curve) then
                            if (next_on_curve) then
                            begin
                                end := next;
                                path.AddLine(beg, end);
                                beg := end
                            end
                        else
                        begin
                            implied := PointF.Create((points[idx].Point.X + position.X), (position.Y - points[idx].Point.Y));
                            if (next_on_curve) then
                            begin
                                end := next;
                                self.AddSpline(path, beg, implied, end, position);
                                beg := end
                            end
                            else
                            begin
                                X := ((position.X + ((points[(idx + 1)].x - points[idx].x) div 2)) + points[idx].x);
                                Y := (position.Y - (((points[(idx + 1)].y - points[idx].y) div 2) + points[idx].y));
                                end := PointF.Create(X, Y);
                                self.AddSpline(path, beg, implied, end, position);
                                beg := end
                            end
                        end;
                    inc(idx)
                end;
                begin
                    Result := path;
                    exit
                end
            end;
}
            function GlyphTableClass.GetGlyphHeader(glyph_offset: Integer): GlyphHeader;
            var
              gheader: ^GlyphHeader;
            begin
                gheader := TTF_Helpers.Increment(self.glyph_table_ptr, glyph_offset);
                Result.numberOfContours := TTF_Helpers.SwapInt16(gheader.numberOfContours);
                Result.xMax := TTF_Helpers.SwapInt16(gheader.xMax);
                Result.yMax := TTF_Helpers.SwapInt16(gheader.yMax);
                Result.xMin := TTF_Helpers.SwapInt16(gheader.xMin);
                Result.yMin := TTF_Helpers.SwapInt16(gheader.yMin);
            end;

            procedure GlyphTableClass.Load(font: Pointer);
            begin
              self.glyph_table_ptr := TTF_Helpers.Increment(font, self.entry.offset)
            end;
 {
            function GlyphTableClass.ReadRawByte(ptr: Pointer; var val: Byte): Pointer;
            var
              p: ^Byte;
            begin
              p := ptr;
              val := p^;
              Result := TTF_Helpers.Increment(ptr, 1)
            end;
}
end.
