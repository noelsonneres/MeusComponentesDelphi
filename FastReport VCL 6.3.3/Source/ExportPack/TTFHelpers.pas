unit TTFHelpers;

interface

{$I frx.inc}

type
  TTF_Helpers = class
    // Methods
    protected constructor Create;
    public class function Increment(ptr: Pointer; cbSize: Integer): Pointer;
    public class function SwapInt16(v: Smallint): Smallint;
    public class function SwapInt32(v: LongInt): LongInt;
    public class function SwapUInt16(v: Word): Word;
    public class function SwapUInt32(v: LongWord): LongWord;
    public class function SwapUInt64(v: UInt64): UInt64; 

end;

implementation

// Methods
    constructor TTF_Helpers.Create;
    begin
    end;

    class function TTF_Helpers.Increment(ptr: Pointer; cbSize: Integer): Pointer;
    begin
//        Result := Pointer(Integer(ptr) + cbSize)
        Result := Pointer(NativeInt(ptr) + cbSize)
    end;

    class function TTF_Helpers.SwapInt16(v: Smallint): Smallint;
    begin
        Result := Smallint((((v and $ff) shl 8) or ((v shr 8) and $ff)))
    end;

    class function TTF_Helpers.SwapInt32(v: LongInt): LongInt;
    begin
        Result := ((TTF_Helpers.SwapInt16(Smallint(v)) and $ffff) shl $10) or (TTF_Helpers.SwapInt16(Smallint(v shr $10)) and $ffff)
    end;

    class function TTF_Helpers.SwapUInt16(v: Word): Word;
    begin
        Result := Word((((v and $ff) shl 8) or ((v shr 8) and $ff)))
    end;

    class function TTF_Helpers.SwapUInt32(v: LongWord): LongWord;
    begin
        Result := LongWord((((TTF_Helpers.SwapUInt16(Word(v)) and $ffff) shl $10) or (TTF_Helpers.SwapUInt16(Word(v shr $10)) and $ffff)))
    end;

    class function TTF_Helpers.SwapUInt64(v: UInt64): UInt64;
    begin
        Result := (((TTF_Helpers.SwapUInt32(LongWord(v)) and $ffffffff) shl $20) or (TTF_Helpers.SwapUInt32((LongWord(v shr $20))) and $ffffffff))
    end;

 end.

