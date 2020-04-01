
{******************************************}
{                                          }
{             FastReport v5.0              }
{                   GIF                    }
{                                          }
{         Copyright (c) 1998-2011          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit GIF;

interface

{$I frx.inc}

uses
  Classes,
  Windows,
  Graphics;

procedure GIFSaveToStream(Stream: TStream; Bitmap: TBitmap);

implementation

type
  TByteArray = array[Word] of Byte;
  PByteArray = ^TByteArray;

const
  HSIZE = 5003;
  MAXBITSCODES = 12;
  code_mask: array [0..16] of cardinal = ($0000, $0001, $0003, $0007, $000F,
    $001F, $003F, $007F, $00FF, $01FF, $03FF, $07FF, $0FFF,
    $1FFF, $3FFF, $7FFF, $FFFF);

procedure GIFSaveToStream(Stream: TStream; Bitmap: TBitmap);
var
  w, h: word;
  flags, b: byte;
  i: Integer;
  Palette: array [0..255] of PALETTEENTRY;
  s: AnsiString;
  CountDown: Integer;
  curx, cury: Integer;
  htab: array [0..HSIZE] of longint;
  codetab: array [0..HSIZE] of integer;
  accum: array [0..255] of byte;
  a_count: integer;
  InitCodeSize: Integer;
  g_init_bits: Integer;
  maxcode, free_ent: integer;
  cur_accum: cardinal;
  cur_bits, clear_flg, clearcode, EOFCode, n_bits: Integer;

  function GifNextPixel: Integer;
  var
    P : PByteArray;
  begin
    if CountDown = 0 then
      Result := -1
    else begin
      Dec(CountDown);
      P := Bitmap.ScanLine[cury];
      Result := P[curx];
      Inc(curx);
      if curx = Bitmap.Width then
      begin
        curx := 0;
        Inc(cury);
      end;
    end;
  end;

  procedure Putword(const w: Integer);
  begin
    Stream.Write(w, 2);
  end;

  procedure cl_hash(const hsize: longint);
  var
    i: longint;
  begin
    for i := 0 to hsize - 1 do
      htab[i] := -1;
  end;

  procedure flush_char;
  var
    b: byte;
  begin
    if a_count > 0 then
    begin
      b := byte(a_count);
      Stream.Write(b, 1);
      Stream.Write(accum, a_count);
      a_count := 0;
    end;
  end;

  procedure char_out(c: byte);
  begin
    accum[a_count] := c;
    Inc(a_count);
    if a_count >= 254 then
      flush_char;
  end;

  procedure output(const code: Integer);
  begin
    cur_accum := cur_accum and code_mask[cur_bits];
    if cur_bits > 0  then
      cur_accum := cur_accum or (cardinal(code) shl cur_bits)
    else
      cur_accum := code;
    cur_bits := cur_bits + n_bits;
    while cur_bits >= 8 do
    begin
      char_out(cur_accum and $ff);
      cur_accum := cur_accum shr 8;
      cur_bits := cur_bits - 8;
    end;
    if (free_ent > maxcode) or (clear_flg <> 0) then
    begin
      if clear_flg <> 0 then
      begin
        n_bits := g_init_bits;
        maxcode := (1 shl n_bits) - 1;
        clear_flg := 0;
      end
      else begin
        Inc(n_bits);
        if n_bits = MAXBITSCODES then
          maxcode := 1 shl MAXBITSCODES
        else
          maxcode := (1 shl n_bits) - 1;
      end;
    end;
    if code = EOFCode then
    begin
      while cur_bits > 0 do
      begin
        char_out(cur_accum and $ff);
        cur_accum := cur_accum shr 8;
        cur_bits := cur_bits - 8;
      end;
      flush_char;
    end;
  end;

  procedure compressLZW(const init_bits: Integer);
  var
    fcode, c, ent, hshift, disp, i: longint;
    maxmaxcode: integer;
    label probe;
    label nomatch;
  begin
    g_init_bits := init_bits;
    cur_accum := 0;
    cur_bits := 0;
    clear_flg := 0;
    n_bits := g_init_bits;
    maxcode := (1 shl g_init_bits) - 1;
    maxmaxcode := 1 shl MAXBITSCODES;
    ClearCode := 1 shl (init_bits - 1);
    EOFCode := ClearCode + 1;
    free_ent := ClearCode + 2;
    a_count := 0;
    ent := GifNextPixel;
    hshift := 0;
    fcode := HSIZE;
    while fcode < 65536 do
    begin
      fcode := fcode * 2;
      hshift := hshift + 1;
    end;
    hshift := 8 - hshift;
    cl_hash(HSIZE);
    output(ClearCode);
    c := GifNextPixel;
    while c <> -1 do
    begin
      fcode := longint((longint(c) shl MAXBITSCODES) + ent);
      i := ((c shl hshift) xor ent);
      if HTab[i] = fcode then
      begin
        ent := CodeTab[i];
        c := GifNextPixel;
        continue;
      end
      else if HTab[i] < 0 then
        goto nomatch;
      disp := HSIZE - i;
      if i = 0 then
        disp := 1;
  probe:
      i := i - disp;
      if i < 0  then  i := i + HSIZE;
      if HTab[i] = fcode then
      begin
        ent := CodeTab[i];
        c := GifNextPixel;
        continue;
      end;
      if HTab[i] > 0 then
        goto probe;
  nomatch:
      output(ent);
      ent := c;
      if free_ent < maxmaxcode then
      begin
        CodeTab[i] := free_ent;
        free_ent := free_ent + 1;
        HTab[i] := fcode;
      end
      else begin
        cl_hash(HSIZE);
        free_ent := ClearCode + 2;
        clear_flg := 1;
        output(ClearCode);
      end;
      c := GifNextPixel;
    end;
    output(ent);
    output(EOFCode);
  end;

begin
  Bitmap.PixelFormat := pf8bit;
  Stream.Write(AnsiString('GIF89a'), 6);
  w := Bitmap.Width;
  h := Bitmap.Height;
  Stream.Write(w, 2);
  Stream.Write(h, 2);
  flags := $e7;
  Stream.Write(flags, 1);
  flags := 0;
  Stream.Write(flags, 1);
  Stream.Write(flags, 1);
  GetPaletteEntries(Bitmap.Palette, 0, 256, Palette);
  for i := 0 to 255 do
  begin
    Stream.Write(Palette[i].peRed, 1);
    Stream.Write(Palette[i].peGreen, 1);
    Stream.Write(Palette[i].peBlue, 1);
  end;
  Stream.Write(AnsiString('!'), 1);
  flags := $F9;
  Stream.Write(flags, 1);
  flags := 4;
  Stream.Write(flags, 1);
  flags := 0;
  Stream.Write(flags, 1);
  Stream.Write(flags, 1);
  Stream.Write(flags, 1);
  Stream.Write(flags, 1);
  Stream.Write(flags, 1);
  Stream.Write(AnsiString('!'), 1);
  flags := 254;
  Stream.Write(flags, 1);
  s := 'FastReport';
  flags := Length(s);
  Stream.Write(flags, 1);
  Stream.Write(s[1], flags);
  flags := 0;
  Stream.Write(flags, 1);
  curx := 0;
  cury := 0;
  CountDown := Bitmap.Width * Bitmap.Height;
  Stream.Write(AnsiString(','), 1);
  Putword(0);
  Putword(0);
  Putword(Bitmap.Width);
  Putword(Bitmap.Height);
  flags := 0;
  Stream.Write(flags, 1);
  InitCodeSize := 8;
  b := byte(InitCodeSize);
  Stream.Write(b, 1);
  compressLZW(InitCodeSize + 1);
  flags := 0;
  Stream.Write(flags, 1);
  Stream.Write(AnsiString(';'), 1);
end;

end.
