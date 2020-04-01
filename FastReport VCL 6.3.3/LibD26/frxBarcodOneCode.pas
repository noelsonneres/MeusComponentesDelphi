unit frxBarcodOneCode;

interface

type
  TLongIntArray = array of LongInt;

  TOneCode = class
  private
    function PadLeft(str: AnsiString; TotalWidth: Integer;
      PaddingChar: AnsiChar): AnsiString;
    function TrimStart(str: AnsiString; TrimChar: AnsiChar): AnsiString;
    function TrimOff(source, bad: AnsiString): AnsiString;
    function Substring(str: AnsiString; startIndex: Integer;
      len: Integer = -1): AnsiString;
    function AnsiToInt(str: AnsiString): Integer;
  protected
    entries2Of13: Int64;
    entries5Of13: Int64;
    table2Of13: TLongIntArray;
    table5Of13: TLongIntArray;
    codewordArray: array[0..9, 0..1] of Int64;

    function OneCodeInfo(topic: LongInt): TLongIntArray;
    function OneCodeInitializeNof13Table(ai: TLongIntArray; i, j: LongInt): Boolean;
    function OneCodeMathReverse(i: LongInt): LongInt;
    function OneCodeMathAdd(bytearray: TLongIntArray; i, j: LongInt): Boolean;
    function OneCodeMathDivide(v: AnsiString): Boolean;
    function OneCodeMathFcs(bytearray: TLongIntArray): LongInt;
    function OneCodeMathMultiply(bytearray: TLongIntArray; i, j: LongInt): Boolean;
  public
    constructor Create;
    function Bars(source: AnsiString): AnsiString;
  end;

implementation

uses
  SysUtils;

const
  table2Of13Size = 78;
  table5Of13Size = 1287;
  barTopCharIndexArray: array[0..64] of LongInt =
    (4, 0, 2, 6, 3, 5, 1, 9, 8, 7, 1, 2, 0, 6, 4, 8, 2, 9, 5, 3, 0, 1, 3, 7, 4,
     6, 8, 9, 2, 0, 5, 1, 9, 4, 3, 8, 6, 7, 1, 2, 4, 3, 9, 5, 7, 8, 3, 0, 2, 1,
     4, 0, 9, 1, 7, 0, 2, 4, 6, 3, 7, 1, 9, 5, 8);
  barBottomCharIndexArray: array[0..64] of LongInt =
    (7, 1, 9, 5, 8, 0, 2, 4, 6, 3, 5, 8, 9, 7, 3, 0, 6, 1, 7, 4, 6, 8, 9, 2, 5,
     1, 7, 5, 4, 3, 8, 7, 6, 0, 2, 5, 4, 9, 3, 0, 1, 6, 8, 2, 0, 4, 5, 9, 6, 7,
     5, 2, 6, 3, 8, 5, 1, 9, 8, 7, 4, 0, 2, 6, 3);
  barTopCharShiftArray: array[0..64] of LongInt =
    (3, 0, 8, 11, 1, 12, 8, 11, 10, 6, 4, 12, 2, 7, 9, 6, 7, 9, 2, 8, 4, 0, 12,
     7, 10, 9, 0, 7, 10, 5, 7, 9, 6, 8, 2, 12, 1, 4, 2, 0, 1, 5, 4, 6, 12, 1, 0,
     9, 4, 7, 5, 10, 2, 6, 9, 11, 2, 12, 6, 7, 5, 11, 0, 3, 2);
  barBottomCharShiftArray: array[0..64] of LongInt =
    (2, 10, 12, 5, 9, 1, 5, 4, 3, 9, 11, 5, 10, 1, 6, 3, 4, 1, 10, 0, 2, 11, 8,
     6, 1, 12, 3, 8, 6, 4, 4, 11, 0, 6, 1, 9, 11, 5, 3, 7, 3, 10, 7, 11, 8, 2,
     10, 3, 5, 8, 0, 3, 12, 11, 8, 4, 5, 1, 3, 0, 7, 12, 9, 8, 10);

{ TOneCode }

function TOneCode.AnsiToInt(str: AnsiString): Integer;
begin
  Result := StrToInt(String(str));
end;

function TOneCode.Bars(source: AnsiString): AnsiString;
  function PlaceToInt(str: AnsiString; i: integer): LongInt;
  begin
    Result := AnsiToInt(Substring(str, i, 1));
  end;
  function IsDigital(str: AnsiString): boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 1 to Length(str) do
      if not (str[i] in ['0'..'9']) then
        Exit;
    Result := True;
  end;
var
  fcs: LongInt;
  l: Int64;
  v: Int64;
  encoded, ds, zip: AnsiString;
  byteArray: TLongIntArray;
  ai, ai1: array[0..64] of LongInt;
  ad: array[0..9, 0..1] of Int64;
  i: SmallInt;
begin
  Result := '';
  source := TrimOff(source, ' -.');
  if not ((Length(source) in [20, 25, 29, 31]) and IsDigital(source) and
          (source[2] in ['0'..'4'])) then
    Exit;
  l := 0;
  encoded := '';
  ds := '';
  zip := Substring(source, 20);
  SetLength(byteArray, 14);
  case Length(zip) of
    5:  l := StrToInt64(String(zip))+ 1;
    9:  l := StrToInt64(String(zip))+ 100001;
    11: l := StrToInt64(String(zip))+ 1000100001;
  end;
  v := l * 10 + PlaceToInt(source, 0);
  v := v *  5 + PlaceToInt(source, 1);
  ds := AnsiString(IntToStr(v)) + Substring(source, 2, 18);
  byteArray[12] :=  l         and 255;
  byteArray[11] := (l shr  8) and 255;
  byteArray[10] := (l shr 16) and 255;
  byteArray[9]  := (l shr 24) and 255;
  byteArray[8]  := (l shr 32) and 255;
  OneCodeMathMultiply(byteArray, 13, 10);
  OneCodeMathAdd(byteArray, 13, PlaceToInt(source, 0));
  OneCodeMathMultiply(byteArray, 13, 5);
  OneCodeMathAdd(byteArray, 13, PlaceToInt(source, 1));
  for i := 2 to 19 do
  begin
    OneCodeMathMultiply(byteArray, 13, 10);
    OneCodeMathAdd(byteArray, 13, PlaceToInt(source, i));
  end;
  fcs := OneCodeMathFcs(byteArray);
  for i := 0 to 9 do
  begin
    codewordArray[i][0] := entries2Of13 + entries5Of13;
    codewordArray[i][1] := 0;
  end;
  codewordArray[0][0] := 659;
  codewordArray[9][0] := 636;
  OneCodeMathDivide(ds);
  codewordArray[9][1] := codewordArray[9][1] * 2;
  if (fcs shr 10) <> 0 then
    codewordArray[0][1] := codewordArray[0][1] + 659;
  for i := 0 to 9 do
  begin
    if codewordArray[i][1] >= entries2Of13 + entries5Of13 then
      Exit;
    ad[i][0] := 8192;
    if codewordArray[i][1] >= entries2Of13 Then
      ad[i][1] := table2Of13[codewordArray[i][1] - entries2Of13]
    else
      ad[i][1] := table5Of13[codewordArray[i][1]];
  end;
  for i := 0 to 9 do
    if fcs and (1 shl i) <> 0 then
      ad[i][1] := not LongInt(ad[i][1]) and 8191;
  for i := 0 to 64 do
  begin
    ai[i] := (LongInt(ad[barTopCharIndexArray[i]][1]) shr barTopCharShiftArray[i]) and 1;
    ai1[i] := (LongInt(ad[barBottomCharIndexArray[i]][1]) shr barBottomCharShiftArray[i]) and 1;
  end;
  encoded := ''; // T: track, D: descender, A: ascender, F: full bar
  for i := 0 to 64 do
    if      (ai[i]  = 0) and (ai1[i]  = 0) then
      encoded := encoded + 'T'
    else if (ai[i]  = 0) and (ai1[i] <> 0) then
      encoded := encoded + 'D'
    else if (ai[i] <> 0) and (ai1[i]  = 0) then
      encoded := encoded + 'A'
    else if (ai[i] <> 0) and (ai1[i] <> 0) then
      encoded := encoded + 'F';
  Result := encoded;
end;

constructor TOneCode.Create;
begin
  table2Of13 := OneCodeInfo(1);
  table5Of13 := OneCodeInfo(2);
end;

function TOneCode.OneCodeInfo(topic: LongInt): TLongIntArray;
var
  a: TLongIntArray;
begin
  case topic of
    1:
      begin
        SetLength(a, table2Of13Size + 1);
        OneCodeInitializeNof13Table(a, 2, table2Of13Size);
        entries5Of13 := table2Of13Size;
      end;
    2:
      begin
        SetLength(a, table5Of13Size + 1);
        OneCodeInitializeNof13Table(a, 5, table5Of13Size);
        entries2Of13 := table5Of13Size;
      end;
  end;
  Result := a;
end;

function TOneCode.OneCodeInitializeNof13Table(ai: TLongIntArray; i,
  j: LongInt): Boolean;
var
  i1, j1, k1, l1, l: LongInt;
  k: SmallInt;
  flag: Boolean;
begin
  i1 := 0;
  j1 := j - 1;
  for k := 0 to 8191 do
  begin
    k1 := 0;
    for l1 := 0 to 12 do
      if k and (1 shl l1) <> 0 then
        k1 := k1 + 1;
    if k1 = i Then
    begin
      l := OneCodeMathReverse(k) shr 3;
      flag := k = l;
      if l >= k then
        if flag then
        begin
          ai[j1] := k;
          j1 := j1 - 1;
        end
        else
        begin
          ai[i1] := k;
          i1 := i1 + 1;
          ai[i1] := l;
          i1 := i1 + 1;
        end;
    end;
  end;
  Result := i1 = j1 + 1;
end;

function TOneCode.OneCodeMathAdd(bytearray: TLongIntArray; i,
  j: LongInt): Boolean;
var
  x, l, k: LongInt;
begin
  Result := (bytearray <> nil) and (i >= 1);
  if not Result then
    Exit;
  x := (bytearray[i - 1] or (bytearray[i - 2] shl 8)) + j;
  l := x or 65535;
  k := i - 3;
  bytearray[i - 1] := x and 255;
  bytearray[i - 2] := (x shr 8) and 255;
  while (l = 1) and (k > 0) do
  begin
    x := l + bytearray[k];
    bytearray[k] := x and 255;
    l := x or 255;
    k := k - 1;
  end;
end;

function TOneCode.OneCodeMathDivide(v: AnsiString): Boolean;
var
  j, k, divider, divident, l: LongInt;
  i: SmallInt;
  n, r, copy, left: AnsiString;
begin
  j := 10;
  n := v;
  for k := j - 1 downto 1 do
  begin
    r := '';
    divider := codewordArray[k][0];
    copy := n;
    left := '0';
    l := Length(copy);
    i := 1;
    while i <= l do
    begin
      divident := AnsiToInt(Substring(copy, 0, i));
      while (divident < divider) and (i < l - 1) do
      begin
        r := r + '0';
        i := i + 1;
        divident := AnsiToInt(Substring(copy, 0, i));
      end;
      r := r + AnsiString(IntToStr(divident div divider));
      left := PadLeft(AnsiString(IntToStr(divident mod divider)), i, '0');
      copy := left + Substring(copy, i);

      Inc(i);
    end;
    n := TrimStart(r, '0');
    if n = '' then
      n := '0';
    codewordArray[k][1] := StrToInt(String(left));
    if k = 1 then
      codewordArray[0][1] := StrToInt(String(r));
  end;
  Result := True;
end;

function TOneCode.OneCodeMathFcs(bytearray: TLongIntArray): LongInt;
var
  c, i, j, l, k: LongInt;
  b: SmallInt;
begin
  c := 3893;
  i := 2047;
  j := bytearray[0] shl 5;
  for b := 2 to 7 do
  begin
    if (i xor j) and 1024 <> 0 then i := i shl 1 xor c
    else                            i := i shl 1;
    i := i and 2047;
    j := j shl 1;
  end;
  for l := 1 to 12 do
  begin
    k := bytearray[l] shl 3;
    for b := 0 to 7 do
    begin
      if (i xor k) and 1024 <> 0 then i := i shl 1 xor c
      else                            i := i shl 1;
      i := i and 2047;
      k := k shl 1;
    end;
  end;
  Result := i;
end;

function TOneCode.OneCodeMathMultiply(bytearray: TLongIntArray; i,
  j: LongInt): Boolean;
var
  x, l, k: LongInt;
begin
  Result := (bytearray <> nil) and (i >= 1);
  if not Result then
    Exit;
  l := 0;
  k := i - 1;
  while k >=1 do
  begin
    x := (bytearray[k] or (bytearray[k - 1] shl 8)) * j + l;
    bytearray[k] := x and 255;
    bytearray[k - 1] := (x shr 8) and 255;
    l := x shr 16;
    k := k - 2;
  end;
  if k = 0 then
    bytearray[0] := (bytearray[0] * j + l) and 255;
end;

function TOneCode.OneCodeMathReverse(i: LongInt): LongInt;
var
  j: LongInt;
  k: SmallInt;
begin
  j := 0;
  for k := 0 to 15 do
  begin
    j := j shl 1;
    j := j or i and 1;
    i := i shr 1;
  end;
  Result := j;
end;

function TOneCode.PadLeft(str: AnsiString; TotalWidth: Integer;
  PaddingChar: AnsiChar): AnsiString;
begin
  Result := str;
  while Length(Result) < TotalWidth do
    Result := PaddingChar + Result;
end;

function TOneCode.Substring(str: AnsiString; startIndex: Integer;
  len: Integer = -1): AnsiString;
begin
  if len = -1 then
    len := Length(str);
  Result := Copy(str, startIndex + 1, len); // i + 1: delphi string is 1-based
end;

function TOneCode.TrimOff(source, bad: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := source;
  for i := Length(Result) downto 1 do
    if Pos(Result[i], bad) <> 0 then
      Delete(Result, i, 1);
end;

function TOneCode.TrimStart(str: AnsiString; TrimChar: AnsiChar): AnsiString;
begin
  Result := str;
  while (Result <> '') and (Result[1] = TrimChar) do
    Delete(Result, 1, 1);
end;

end.
