(*
 * Copyright 2013 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org.ext.zawq.ru/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *)

unit frxDelphiZXIngAztecCode;

interface

{$I frx.inc}

const
  DEFAULT_EC_PERCENT = 33; // default minimal percentage of error check words

type
  TAztecEncoder = class
  private
    FData: WideString;
    FMatrixSize: integer;
    FMinECCPercent: integer;

    function GetIsBlack(Row, Column: integer): Boolean;
    procedure SetData(const Value: WideString);
    procedure SetMinECCPercent(const Value: integer);
  protected
    FElements: array of array of Boolean;

    procedure Update;
  public
    constructor Create;

    property IsBlack[Row, Column: integer]: Boolean read GetIsBlack;
    property Data: WideString read FData write SetData;
    property MatrixSize: integer read FMatrixSize;
    property MinECCPercent: integer read FMinECCPercent write SetMinECCPercent;
  end;

implementation

uses
  {$IFNDEF FPC}Windows,{$ENDIF} Math, Classes, SysUtils, Contnrs,
  frxDelphiZXIngCode, frxUnicodeUtils;

const
  DEFAULT_AZTEC_LAYERS = 0;
  MAX_NB_BITS = 32;
  MAX_NB_BITS_COMPACT = 4;
  MaxLayers = 32;
  WORD_SIZE: array [0 .. MaxLayers] of integer = (4, 6, 6, 8, 8, 8, 8, 8, 8, 10,
    10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 12, 12, 12, 12, 12, 12,
    12, 12, 12, 12);

type
  TEncoder = class
  private
    FMatrixSize: integer;
    FMatrix: array of array of Boolean;
    FCompact: Boolean;
    FLayers: integer;
    FCodeWords: integer;

    function GetMatrix(x, y: integer): Boolean;
  protected
    FGarbage: TObjectList;

    procedure SetBlack(x, y: integer);
    procedure DrawBullsEye(Center, Size: LongInt);
    function GenerateModeMessage: TBitArray;
    procedure DrawModeMessage(MatrixSize: LongInt; ModeMessage: TBitArray);
    function GenerateCheckWords(BitArray: TBitArray;
      TotalBits, WordSize: integer): TBitArray;
    function BitsToWords(StuffedBits: TBitArray; WordSize, TotalWords: integer)
      : TIntegerArray;
    function GetGF(WordSize: integer): TGenericGF;
    function StuffBits(Bits: TBitArray; WordSize: integer): TBitArray;
    function TotalBitsInLayer: integer;
  public
    destructor Destroy; override;
    // Encodes the given binary content as an Aztec symbol
    // minECCPercent: minimal percentage of error check words (According to ISO/IEC 24778:2008, a minimum of 23% + 3 words is recommended)
    // userSpecifiedLayers: if non-zero, a user-specified value for the number of layers
    // Returns Aztec symbol matrix with metadata
    procedure Encode(Data: AnsiString;
      MinECCPercent: LongInt = DEFAULT_EC_PERCENT;
      UserSpecifiedLayers: LongInt = DEFAULT_AZTEC_LAYERS);

    property MatrixSize: integer read FMatrixSize;
    property Matrix[x, y: integer]: Boolean read GetMatrix;
    property Compact: Boolean read FCompact;
    property Layers: integer read FLayers;
    property CodeWords: integer read FCodeWords;
  end;

{ TAztecEncoder }

constructor TAztecEncoder.Create;
begin
  FData := '';
  FMatrixSize := 0;
end;

function TAztecEncoder.GetIsBlack(Row, Column: integer): Boolean;
begin
  Result := FElements[Row, Column];
end;

procedure TAztecEncoder.SetData(const Value: WideString);
begin
  if (FData <> Value) then
  begin
    FData := Value;
    Update;
  end;
end;

procedure TAztecEncoder.SetMinECCPercent(const Value: integer);
begin
  if (FMinECCPercent <> Value) then
  begin
    FMinECCPercent := Value;
    Update;
  end;
end;

procedure TAztecEncoder.Update;
var
  AnsiSt: AnsiString;
  Encoder: TEncoder;
  w, h: integer;
begin
{$IFDEF Delphi12}
  AnsiSt := _UnicodeToAnsi(FData, DEFAULT_CHARSET);
{$ELSE}
  AnsiSt := AnsiString(FData);
{$ENDIF}
  Encoder := TEncoder.Create;
  Encoder.Encode(AnsiSt, FMinECCPercent);
  FMatrixSize := Encoder.MatrixSize;
  SetLength(FElements, MatrixSize, MatrixSize);
  for w := 0 to MatrixSize - 1 do
    for h := 0 to MatrixSize - 1 do
      FElements[w, h] := Encoder.Matrix[h, w];
  Encoder.Free;
end;

(******************************************************************************)

type
  TState = class;

  THighLevelEncoder = class
  private
    function UpdateStateListForChar(States: TList; Index: integer): TList;
    procedure UpdateStateForChar(State: TState; Index: integer; Result: TList);
    function UpdateStateListForPair(States: TList;
      Index, PairCode: integer): TList;
    procedure UpdateStateForPair(State: TState; Index, PairCode: integer;
      Result: TList);
    function SimplifyStates(States: TList): TList;
  protected
    FText: AnsiString;
    FGarbage: TObjectList;
  public
    constructor Create(AGarbage: TObjectList; AText: AnsiString);
    function Encode: TBitArray;
  end;

  TToken = class
  private
    FPrevious: TToken;
    FGarbage: TObjectList;
  public
    constructor Create(AGarbage: TObjectList; APrevious: TToken);
    class function EMPTY(AGarbage: TObjectList): TToken;
    function Add(AValue, ABitCount: integer): TToken;
    function AddBinaryShift(Start, ByteCount: integer): TToken;

    procedure AppendTo(BitArray: TBitArray; Text: AnsiString); virtual;
      abstract;

    property Previous: TToken read FPrevious;
    property Garbage: TObjectList read FGarbage;
  end;

  TState = class
  private
    FMode: LongInt;
    FToken: TToken;
    FBinaryShiftByteCount: LongInt;
    FBitCount: LongInt;
  public
    class function INITIAL_STATE(AGarbage: TObjectList): TState;
    constructor Create(AToken: TToken; AMode, ABinaryBytes, ABitCount: LongInt);

    function LatchAndAppend(NewMode, Value: LongInt): TState;
    function ShiftAndAppend(NewMode, Value: LongInt): TState;
    function AddBinaryShiftChar(Index: LongInt): TState;
    function EndBinaryShift(Index: LongInt): TState;
    function IsBetterThanOrEqualTo(Other: TState): Boolean;

    function ToBitArray(Text: AnsiString): TBitArray;
//    function ToString: string;

    property Mode: LongInt read FMode;
    property BitCount: LongInt read FBitCount;
    property BinaryShiftByteCount: LongInt read FBinaryShiftByteCount;
  end;

const
  MODE_UPPER = 0; // 5 bits
  MODE_LOWER = 1; // 5 bits
  MODE_DIGIT = 2; // 4 bits
  MODE_MIXED = 3; // 5 bits
  MODE_PUNCT = 4; // 5 bits
  ShiftTableSize = 6;

type
  TMode = MODE_UPPER .. MODE_PUNCT;

const
  MODE_NAMES: array [TMode] of string = ('UPPER', 'LOWER', 'DIGIT',
    'MIXED', 'PUNCT');

  LATCH_TABLE: array [TMode, TMode] of integer = ((0, //
    5 shl 16 + 28, // UPPER -> LOWER
    5 shl 16 + 30, // UPPER -> DIGIT
    5 shl 16 + 29, // UPPER -> MIXED
    10 shl 16 + 29 shl 5 + 30 // UPPER -> MIXED -> PUNCT
    ), (9 shl 16 + 30 shl 4 + 14, // LOWER -> DIGIT -> UPPER
    0, //
    5 shl 16 + 30, // LOWER -> DIGIT
    5 shl 16 + 29, // LOWER -> MIXED
    10 shl 16 + 29 shl 5 + 30 // LOWER -> MIXED -> PUNCT
    ), (4 shl 16 + 14, // DIGIT -> UPPER
    9 shl 16 + 14 shl 5 + 28, // DIGIT -> UPPER -> LOWER
    0, //
    9 shl 16 + 14 shl 5 + 29, // DIGIT -> UPPER -> MIXED
    14 shl 16 + 14 shl 10 + 29 shl 5 + 30 // DIGIT -> UPPER -> MIXED -> PUNCT
    ), (5 shl 16 + 29, // MIXED -> UPPER
    5 shl 16 + 28, // MIXED -> LOWER
    10 shl 16 + 29 shl 5 + 30, // MIXED -> UPPER -> DIGIT
    0, //
    5 shl 16 + 30 // MIXED -> PUNCT
    ), (5 shl 16 + 31, // PUNCT -> UPPER
    10 shl 16 + 31 shl 5 + 28, // PUNCT -> UPPER -> LOWER
    10 shl 16 + 31 shl 5 + 30, // PUNCT -> UPPER -> DIGIT
    10 shl 16 + 31 shl 5 + 29, // PUNCT -> UPPER -> MIXED
    0 //
    ));

var
  CHAR_MAP: array [TMode, AnsiChar] of integer;
  SHIFT_TABLE: array [0 .. ShiftTableSize, 0 .. ShiftTableSize] of integer;

type
  TSimpleToken = class(TToken)
  private
    FValue: SmallInt;
    FBitCount: SmallInt;
  public
    constructor Create(AGarbage: TObjectList; Previous: TToken; AValue, ABitCount: integer);
//    function ToString: string;
    procedure AppendTo(BitArray: TBitArray; Text: AnsiString); override;
  end;

  TBinaryShiftToken = class(TToken)
  private
    FBinaryShiftStart: SmallInt;
    FBinaryShiftByteCount: SmallInt;
  public
    constructor Create(AGarbage: TObjectList; Previous: TToken;
      ABinaryShiftStart, ABinaryShiftByteCount: integer);
//    function ToString: string;
    procedure AppendTo(BitArray: TBitArray; Text: AnsiString); override;
  end;

procedure TBinaryShiftToken.AppendTo(BitArray: TBitArray; Text: AnsiString);
var
  i: integer;
begin
  for i := 0 to FBinaryShiftByteCount - 1 do
  begin
    if (i = 0) or (i = 31) and (FBinaryShiftByteCount <= 62) then
    begin
      // We need a header before the first character, and before
      // character 31 when the total byte code is <= 62
      BitArray.AppendBits(31, 5); // BINARY_SHIFT
      if FBinaryShiftByteCount > 62 then
        BitArray.AppendBits(FBinaryShiftByteCount - 31, 16)
      else if i = 0 then // 1 <= binaryShiftByteCode <= 62
        BitArray.AppendBits(Min(FBinaryShiftByteCount, 31), 5)
      else // 32 <= binaryShiftCount <= 62 and i == 31
        BitArray.AppendBits(FBinaryShiftByteCount - 31, 5);
    end;
    BitArray.AppendBits(Ord(Text[FBinaryShiftStart + i + 1]), 8);
    // + 1, because AnsiString is one-based instead of byte[] (zero-based) in the original.
  end;
end;

constructor TBinaryShiftToken.Create(AGarbage: TObjectList; Previous: TToken;
  ABinaryShiftStart, ABinaryShiftByteCount: integer);
begin
  inherited Create(AGarbage, Previous);
  FBinaryShiftStart := ABinaryShiftStart;
  FBinaryShiftByteCount := ABinaryShiftByteCount;
end;

//function TBinaryShiftToken.ToString: string;
//begin
//  Result := Format('<%d::%d>', [FBinaryShiftStart, FBinaryShiftStart + FBinaryShiftByteCount - 1]);
//end;

{ TSimpleToken }

procedure TSimpleToken.AppendTo(BitArray: TBitArray; Text: AnsiString);
begin
  BitArray.AppendBits(FValue, FBitCount)
end;

constructor TSimpleToken.Create(AGarbage: TObjectList; Previous: TToken; AValue, ABitCount: integer);
begin
  inherited Create(AGarbage, Previous);
  FValue := AValue;
  FBitCount := ABitCount;
end;

//function TSimpleToken.ToString: string;
//var
//  Value: LongInt;
//begin
//  Value := FValue and ((1 shl FBitCount) - 1);
//  Value := Value or (1 shl FBitCount);
//  Result := Format('<%s>', [ToBinaryString(Value or (1 shl FBitCount) and $7fffffff)]);
//end;

{ TToken }

function TToken.Add(AValue, ABitCount: integer): TToken;
begin
  Result := TSimpleToken.Create(Garbage, Self, AValue, ABitCount);
end;

function TToken.AddBinaryShift(Start, ByteCount: integer): TToken;
begin
  Result := TBinaryShiftToken.Create(Garbage, Self, Start, ByteCount)
end;

constructor TToken.Create(AGarbage: TObjectList; APrevious: TToken);
begin
  FPrevious := APrevious;
  FGarbage := AGarbage;
  if Assigned(Garbage) then
    Garbage.Add(Self);
end;

class function TToken.EMPTY(AGarbage: TObjectList): TToken;
begin
  Result := TSimpleToken.Create(AGarbage, nil, 0, 0);
end;

{ TState }

function TState.AddBinaryShiftChar(Index: LongInt): TState;
var
  Latch, LocalBitCount, LocalMode, DeltaBitCount: LongInt;
  LocalToken: TToken;
begin
  LocalToken := FToken;
  LocalMode := Mode;
  LocalBitCount := BitCount;
  if Mode in [MODE_PUNCT, MODE_DIGIT] then
  begin
    //assert binaryShiftByteCount == 0;
    Latch := LATCH_TABLE[LocalMode][MODE_UPPER];
    LocalToken := LocalToken.Add(Latch and $FFFF, Latch shr 16);
    LocalBitCount := LocalBitCount + Latch shr 16;
    LocalMode := MODE_UPPER;
  end;
  DeltaBitCount := IfValue(BinaryShiftByteCount in [0, 31], 18,
    IfValue(BinaryShiftByteCount = 62, 9, 8));
  Result := TState.Create(LocalToken, LocalMode, BinaryShiftByteCount + 1,
    LocalBitCount + DeltaBitCount);
  if Result.BinaryShiftByteCount = 2047 + 31 then
    // The string is as long as it's allowed to be.  We should end it.
    Result.EndBinaryShift(Index + 1);
end;

constructor TState.Create(AToken: TToken;
  AMode, ABinaryBytes, ABitCount: LongInt);
begin
  FToken := AToken;
  FMode := AMode;
  FBinaryShiftByteCount := ABinaryBytes;
  FBitCount := ABitCount;

  if Assigned(FToken.Garbage) then
    FToken.Garbage.Add(Self);
// Make sure we match the token
//int binaryShiftBitCount = (binaryShiftByteCount * 8) +
//    (binaryShiftByteCount == 0 ? 0 :
//     binaryShiftByteCount <= 31 ? 10 :
//     binaryShiftByteCount <= 62 ? 20 : 21);
//assert this.bitCount == token.getTotalBitCount() + binaryShiftBitCount;
end;

function TState.EndBinaryShift(Index: LongInt): TState;
var
  LocalToken: TToken;
begin
  if BinaryShiftByteCount = 0 then
    Result := Self
  else
  begin
    LocalToken := FToken.AddBinaryShift(Index - BinaryShiftByteCount,
      BinaryShiftByteCount);
    //assert token.getTotalBitCount() == this.bitCount;
    Result := TState.Create(LocalToken, Mode, 0, BitCount);
  end;
end;

class function TState.INITIAL_STATE(AGarbage: TObjectList): TState;
begin
  Result := TState.Create(TToken.EMPTY(AGarbage), MODE_UPPER, 0, 0);
end;

function TState.IsBetterThanOrEqualTo(Other: TState): Boolean;
var
  MySize: LongInt;
begin
  MySize := BitCount + (LATCH_TABLE[Mode][Other.Mode] shr 16);
  if (Other.BinaryShiftByteCount > 0) and
    ((BinaryShiftByteCount = 0) or
    (BinaryShiftByteCount > Other.BinaryShiftByteCount)) then
    MySize := MySize + 10; // Cost of entering Binary Shift mode.
  Result := MySize <= Other.BitCount;
end;

function TState.LatchAndAppend(NewMode, Value: LongInt): TState;
var
  Latch, LocalBitCount, LatchModeBitCount: LongInt;
  LocalToken: TToken;
begin
  //assert binaryShiftByteCount == 0;
  LocalBitCount := BitCount;
  LocalToken := FToken;
  if NewMode <> Mode then
  begin
    Latch := LATCH_TABLE[Mode][NewMode];
    LocalToken := LocalToken.Add(Latch and $FFFF, Latch shr 16);
    LocalBitCount := LocalBitCount + Latch shr 16;
  end;
  LatchModeBitCount := IfValue(NewMode = MODE_DIGIT, 4, 5);
  LocalToken := LocalToken.Add(Value, LatchModeBitCount);
  Result := TState.Create(LocalToken, NewMode, 0,
    LocalBitCount + LatchModeBitCount);
end;

function TState.ShiftAndAppend(NewMode, Value: LongInt): TState;
var
  ThisModeBitCount: LongInt;
  LocalToken: TToken;
begin
  //assert binaryShiftByteCount == 0 && this.mode != mode;
  LocalToken := FToken;
  ThisModeBitCount := IfValue(NewMode = MODE_DIGIT, 4, 5);
  // Shifts exist only to UPPER and PUNCT, both with tokens size 5.
  LocalToken := LocalToken.Add(SHIFT_TABLE[Mode][NewMode], ThisModeBitCount);
  LocalToken := LocalToken.Add(Value, 5);
  Result := TState.Create(LocalToken, Mode, 0, BitCount + ThisModeBitCount + 5);
end;

function TState.ToBitArray(Text: AnsiString): TBitArray;
var
  Symbols: TList;
  LocalToken: TToken;
  i: LongInt;
begin
  // Reverse the tokens, so that they are in the order that they should be output
  Symbols := TList.Create;
  LocalToken := EndBinaryShift(Length(Text)).FToken;
  while LocalToken <> nil do
  begin
    Symbols.Insert(0, LocalToken);
    LocalToken := LocalToken.Previous;
  end;

  Result := TBitArray.Create;
  for i := 0 to Symbols.Count - 1 do
    TToken(Symbols[i]).AppendTo(Result, Text);

  Symbols.Free;
end;

//function TState.ToString: string;
//begin
//  Result := Format('%s bits=%d bytes=%d', [MODE_NAMES[mode], BitCount, BinaryShiftByteCount]);
//end;

{ THighLevelEncoder }

constructor THighLevelEncoder.Create(AGarbage: TObjectList; AText: AnsiString);
begin
  FText := AText;
  FGarbage := AGarbage;
end;

function THighLevelEncoder.Encode: TBitArray;

  procedure FreeAndSet(var List1: TList; List2: TList);
  var
    Temp: TList;
  begin
    Temp := List2;
    List1.Free;
    List1 := Temp;
  end;

var
  States: TList;
  Index, PairCode, i: integer;
  NextChar: AnsiChar;
  MinState, State: TState;
begin
  States := TList.Create;
  States.Add(TState.INITIAL_STATE(FGarbage));
  Index := 1;
  while Index <= Length(FText) do
  begin
    NextChar := IfValue(Index < Length(FText), FText[Index + 1], #0);
    case FText[Index] of
      #13:
        PairCode := IfValue(NextChar = #10, 2, 0);
      '.':
        PairCode := IfValue(NextChar = ' ', 3, 0);
      ',':
        PairCode := IfValue(NextChar = ' ', 4, 0);
      ':':
        PairCode := IfValue(NextChar = ' ', 5, 0);
    else
      PairCode := 0;
    end;
    if PairCode > 0 then
    begin
      FreeAndSet(States, UpdateStateListForPair(States, Index, PairCode));
      Inc(Index);
    end
    else
      FreeAndSet(States, UpdateStateListForChar(States, Index));
    Inc(Index);
  end;

  MinState := nil;
  for i := 0 to States.Count - 1 do
  begin
    State := TState(States[i]);
    if (MinState = nil) or (State.BitCount < MinState.BitCount) then
      MinState := State;
  end;

  Result := MinState.ToBitArray(FText);

  States.Free;
end;

function THighLevelEncoder.SimplifyStates(States: TList): TList;
var
  Add: Boolean;
  i, j, Index: integer;
  NewState, OldState: TState;
  RemoveList: TList;
begin
  RemoveList := TList.Create;
  Result := TList.Create;
  for i := 0 to States.Count - 1 do
  begin
    NewState := TState(States[i]);
    Add := True;
    RemoveList.Clear;
    for j := 0 to Result.Count - 1 do
    begin
      OldState := TState(Result[j]);
      if OldState.IsBetterThanOrEqualTo(NewState) then
      begin
        Add := False;
        Break;
      end;
      if NewState.IsBetterThanOrEqualTo(OldState) then
        RemoveList.Add(OldState);
    end;
    if Add then
      Result.Add(NewState);
    for j := 0 to RemoveList.Count - 1 do
    begin
      Index := Result.IndexOf(RemoveList[j]);
      if Index > -1 then
        Result.Delete(Index);
    end;
  end;

  RemoveList.Free;
end;

procedure THighLevelEncoder.UpdateStateForChar(State: TState; Index: integer;
  Result: TList);
var
  ch: AnsiChar;
  CharInCurrentTable: Boolean;
  StateNoBinary, latch_state, shift_state, binaryState: TState;
  Mode: TMode;
  CharInMode: integer;
begin
  ch := FText[Index];
  CharInCurrentTable := CHAR_MAP[State.Mode][ch] > 0;
  StateNoBinary := nil;
  for Mode := MODE_UPPER to MODE_PUNCT do
  begin
    CharInMode := CHAR_MAP[Mode][ch];
    if CharInMode > 0 then
    begin
      if StateNoBinary = nil then
      // Only create stateNoBinary the first time it's required.
        StateNoBinary := State.EndBinaryShift(Index);
      if ((not CharInCurrentTable) or (Mode = State.Mode)) or (Mode = MODE_DIGIT)
      then
      begin
        latch_state := StateNoBinary.LatchAndAppend(Mode, CharInMode);
        Result.Add(latch_state);
      end;
      if (not CharInCurrentTable) and (SHIFT_TABLE[State.Mode][Mode] >= 0) then
      begin
        shift_state := StateNoBinary.ShiftAndAppend(Mode, CharInMode);
        Result.Add(shift_state);
      end;
    end;
  end;

  if (State.BinaryShiftByteCount > 0) or (CHAR_MAP[State.Mode][ch] = 0) then
  begin
    binaryState := State.AddBinaryShiftChar(Index);
    Result.Add(binaryState);
  end
end;

procedure THighLevelEncoder.UpdateStateForPair(State: TState;
  Index, PairCode: integer; Result: TList);
var
  StateNoBinary, digit_state, binaryState: TState;
begin
  StateNoBinary := State.EndBinaryShift(Index);
  // Possibility 1.  Latch to MODE_PUNCT, and then append this code
  Result.Add(StateNoBinary.LatchAndAppend(MODE_PUNCT, PairCode));
  if State.Mode <> MODE_PUNCT then
    // Possibility 2.  Shift to MODE_PUNCT, and then append this code.
    // Every state except MODE_PUNCT (handled above) can shift
    Result.Add(StateNoBinary.ShiftAndAppend(MODE_PUNCT, PairCode));
  if PairCode in [3 .. 4] then
  begin
    // both characters are in DIGITS.  Sometimes better to just add two digits
    // period or comma in DIGIT
    digit_state := StateNoBinary.LatchAndAppend(MODE_DIGIT, 16 - PairCode)
      .LatchAndAppend(MODE_DIGIT, 1);
    // space in DIGIT
    Result.Add(digit_state);
  end;
  if State.BinaryShiftByteCount > 0 then
  begin
    // It only makes sense to do the characters as binary if we're already
    // in binary mode.
    binaryState := State.AddBinaryShiftChar(Index)
      .AddBinaryShiftChar(Index + 1);
    Result.Add(binaryState);
  end
end;

function THighLevelEncoder.UpdateStateListForChar(States: TList;
  Index: integer): TList;
var
  i: integer;
  State: TState;
  Complex: TList;
begin
  Complex := TList.Create;
  for i := 0 to States.Count - 1 do
  begin
    State := TState(States[i]);
    UpdateStateForChar(State, Index, Complex);
  end;
  Result := SimplifyStates(Complex);

  Complex.Free;
end;

function THighLevelEncoder.UpdateStateListForPair(States: TList;
  Index, PairCode: integer): TList;
var
  i: integer;
  State: TState;
  Complex: TList;
begin
  Complex := TList.Create;
  for i := 0 to States.Count - 1 do
  begin
    State := TState(States[i]);
    UpdateStateForPair(State, Index, PairCode, Complex);
  end;
  Result := SimplifyStates(Complex);

  Complex.Free;
end;

{ TEncoder }

function TEncoder.BitsToWords(StuffedBits: TBitArray;
  WordSize, TotalWords: integer): TIntegerArray;
var
  i, j, N: integer;
  Value: LongInt;
begin
  SetLength(Result, TotalWords);
  N := StuffedBits.Size div WordSize;
  for i := 0 to N - 1 do
  begin
    Value := 0;
    for j := 0 to WordSize - 1 do
      Value := Value or IfValue(StuffedBits[i * WordSize + j],
        1 shl (WordSize - j - 1), 0);
    Result[i] := Value;
  end;
end;

destructor TEncoder.Destroy;
begin
  Finalize(FMatrix);
  inherited;
end;

procedure TEncoder.DrawBullsEye(Center, Size: integer);
var
  i, j: LongInt;
begin
  i := 0;
  while i < Size do
  begin
    for j := Center - i to Center + i do
    begin
      SetBlack(j, Center - i);
      SetBlack(j, Center + i);
      SetBlack(Center - i, j);
      SetBlack(Center + i, j);
    end;
    i := i + 2;
  end;
  SetBlack(Center - Size, Center - Size);
  SetBlack(Center - Size + 1, Center - Size);
  SetBlack(Center - Size, Center - Size + 1);
  SetBlack(Center + Size, Center - Size);
  SetBlack(Center + Size, Center - Size + 1);
  SetBlack(Center + Size, Center + Size - 1);
end;

procedure TEncoder.DrawModeMessage(MatrixSize: LongInt; ModeMessage: TBitArray);
var
  i, Center, Offset: LongInt;
begin
  Center := MatrixSize div 2;
  if Compact then
    for i := 0 to 7 - 1 do
    begin
      Offset := Center - 3 + i;
      if ModeMessage[i] then
        SetBlack(Offset, Center - 5);
      if ModeMessage[i + 7] then
        SetBlack(Center + 5, Offset);
      if ModeMessage[20 - i] then
        SetBlack(Offset, Center + 5);
      if ModeMessage[27 - i] then
        SetBlack(Center - 5, Offset);
    end
  else
    for i := 0 to 10 - 1 do
    begin
      Offset := Center - 5 + i + i div 5;
      if ModeMessage[i] then
        SetBlack(Offset, Center - 7);
      if ModeMessage[i + 10] then
        SetBlack(Center + 7, Offset);
      if ModeMessage[29 - i] then
        SetBlack(Offset, Center + 7);
      if ModeMessage[39 - i] then
        SetBlack(Center - 7, Offset);
    end;
end;

procedure TEncoder.Encode(Data: AnsiString;
  MinECCPercent: LongInt = DEFAULT_EC_PERCENT;
  UserSpecifiedLayers: LongInt = DEFAULT_AZTEC_LAYERS);
var
  Bits, StuffedBits, MessageBits, ModeMessage: TBitArray;
  HighLevelEncoder: THighLevelEncoder;
  i, j, k, EccBits, TotalSizeBits, LocalTotalBitsInLayer, WordSize,
    UsableBitsInLayers, BaseMatrixSize, OrigCenter, Center, NewOffset,
    RowOffset, RowSize, ColumnOffset: LongInt;
  AlignmentMap: TIntegerArray;
begin
  FGarbage := TObjectList.Create;

  // High-level encode
  HighLevelEncoder := THighLevelEncoder.Create(FGarbage, Data);
  Bits := HighLevelEncoder.Encode;

  // stuff bits and choose symbol size
  EccBits := Bits.Size * MinECCPercent div 100 + 11;
  TotalSizeBits := Bits.Size + EccBits;

  if UserSpecifiedLayers <> DEFAULT_AZTEC_LAYERS then
  begin
    FCompact := UserSpecifiedLayers < 0;
    FLayers := Abs(UserSpecifiedLayers);
    if Layers > IfValue(Compact, MAX_NB_BITS_COMPACT, MAX_NB_BITS) then
      raise Exception.Create(Format('Illegal value %d for layers',
        [UserSpecifiedLayers]));
    LocalTotalBitsInLayer := TotalBitsInLayer;
    WordSize := WORD_SIZE[Layers];
    UsableBitsInLayers := LocalTotalBitsInLayer -
      (LocalTotalBitsInLayer mod WordSize);
    FreeAndSetBitArray(StuffedBits, StuffBits(Bits, WordSize));
    if StuffedBits.Size + EccBits > UsableBitsInLayers then
      raise Exception.Create('Data to large for user specified layer');
    if Compact and (StuffedBits.Size > WordSize * 64) then
      // Compact format only allows 64 data words, though C4 can hold more words than that
      raise Exception.Create('Data to large for user specified layer');
  end
  else
  begin
    WordSize := 0;
    StuffedBits := nil;
    // We look at the possible table sizes in the order Compact1, Compact2, Compact3,
    // Compact4, Normal4,...  Normal(i) for i < 4 isn't typically used since Compact(i+1)
    // is the same size, but has more data.
    for i := 0 to MaxInt do
    begin
      if i > MAX_NB_BITS then
        raise Exception.Create('Data too large for an Aztec code');
      FCompact := i <= 3;
      FLayers := IfValue(Compact, i + 1, i);
      LocalTotalBitsInLayer := TotalBitsInLayer;
      if TotalSizeBits > LocalTotalBitsInLayer then
        Continue;
      // [Re]stuff the bits if this is the first opportunity, or if the
      // wordSize has changed
      if WordSize <> WORD_SIZE[Layers] then
      begin
        WordSize := WORD_SIZE[Layers];
        FreeAndSetBitArray(StuffedBits, StuffBits(Bits, WordSize));
      end;
      if StuffedBits = nil then
        Continue;
      UsableBitsInLayers := LocalTotalBitsInLayer -
        (LocalTotalBitsInLayer mod WordSize);
      if Compact and (StuffedBits.Size > WordSize * 64) then
        // Compact format only allows 64 data words, though C4 can hold more words than that
        Continue;
      if StuffedBits.Size + EccBits <= UsableBitsInLayers then
        Break;
    end;
  end;

  MessageBits := GenerateCheckWords(StuffedBits, LocalTotalBitsInLayer,
    WordSize);

  // generate mode message
  FCodeWords := StuffedBits.Size div WordSize;
  ModeMessage := GenerateModeMessage;

  // allocate symbol
  BaseMatrixSize := IfValue(Compact, 11 + Layers * 4, 14 + Layers * 4);
// not including alignment lines
  SetLength(AlignmentMap, BaseMatrixSize);
  if Compact then
  begin
    // no alignment marks in compact mode, alignmentMap is a no-op
    FMatrixSize := BaseMatrixSize;
    for i := 0 to High(AlignmentMap) do
      AlignmentMap[i] := i;
  end
  else
  begin
    FMatrixSize := BaseMatrixSize + 1 + 2 * ((BaseMatrixSize div 2 - 1) div 15);
    OrigCenter := BaseMatrixSize div 2;
    Center := MatrixSize div 2;
    for i := 0 to OrigCenter - 1 do
    begin
      NewOffset := i + i div 15;
      AlignmentMap[OrigCenter - i - 1] := Center - NewOffset - 1;
      AlignmentMap[OrigCenter + i] := Center + NewOffset + 1
    end;
  end;

  SetLength(FMatrix, MatrixSize, MatrixSize);

  // draw data bits
  RowOffset := 0;
  for i := 0 to Layers - 1 do
  begin
    RowSize := IfValue(Compact, (Layers - i) * 4 + 9, (Layers - i) * 4 + 12);
    for j := 0 to RowSize - 1 do
    begin
      ColumnOffset := j * 2;
      for k := 0 to 2 - 1 do
      begin
        if MessageBits[RowOffset + ColumnOffset + k] then
          SetBlack(AlignmentMap[i * 2 + k], AlignmentMap[i * 2 + j]);
        if MessageBits[RowOffset + RowSize * 2 + ColumnOffset + k] then
          SetBlack(AlignmentMap[i * 2 + j],
            AlignmentMap[BaseMatrixSize - 1 - i * 2 - k]);
        if MessageBits[RowOffset + RowSize * 4 + ColumnOffset + k] then
          SetBlack(AlignmentMap[BaseMatrixSize - 1 - i * 2 - k],
            AlignmentMap[BaseMatrixSize - 1 - i * 2 - j]);
        if MessageBits[RowOffset + RowSize * 6 + ColumnOffset + k] then
          SetBlack(AlignmentMap[BaseMatrixSize - 1 - i * 2 - j],
            AlignmentMap[i * 2 + k]);
      end
    end;
    RowOffset := RowOffset + RowSize * 8
  end;

  // draw mode message
  DrawModeMessage(MatrixSize, ModeMessage);

  // draw alignment marks
  if Compact then
    DrawBullsEye(MatrixSize div 2, 5)
  else
  begin
    DrawBullsEye(MatrixSize div 2, 7);
    i := 0;
    j := 0;
    while i < BaseMatrixSize div 2 - 1 do
    begin
      k := (MatrixSize div 2) and 1;
      while k < MatrixSize do
      begin
        SetBlack(MatrixSize div 2 - j, k);
        SetBlack(MatrixSize div 2 + j, k);
        SetBlack(k, MatrixSize div 2 - j);
        SetBlack(k, MatrixSize div 2 + j);
        k := k + 2;
      end;
      i := i + 15;
      j := j + 16;
    end;
  end;

  Bits.Free;
  StuffedBits.Free;
  MessageBits.Free;
  ModeMessage.Free;

  HighLevelEncoder.Free;

  FGarbage.Free;
end;

function TEncoder.GenerateCheckWords(BitArray: TBitArray;
  TotalBits, WordSize: integer): TBitArray;
var
  CodeWords, TotalWords, StartPad, i: integer;
  RS: TReedSolomonEncoder;
  MessageWords: TIntegerArray;
begin
  if BitArray.Size mod WordSize <> 0 then
    raise Exception.Create
      ('size of bit array is not a multiple of the word size');

  // bitArray is guaranteed to be a multiple of the wordSize, so no padding needed
  CodeWords := BitArray.Size div WordSize;

  RS := TReedSolomonEncoder.Create(GetGF(WordSize));
  TotalWords := TotalBits div WordSize;
  MessageWords := BitsToWords(BitArray, WordSize, TotalWords);
  RS.Encode(MessageWords, TotalWords - CodeWords);
  RS.Free;

  StartPad := TotalBits mod WordSize;
  Result := TBitArray.Create;
  Result.AppendBits(0, StartPad);

  for i := 0 to High(MessageWords) do
    Result.AppendBits(MessageWords[i], WordSize);
end;

function TEncoder.GenerateModeMessage: TBitArray;
begin
  Result := TBitArray.Create;
  if Compact then
  begin
    Result.AppendBits(Layers - 1, 2);
    Result.AppendBits(CodeWords - 1, 6);
    FreeAndSetBitArray(Result, GenerateCheckWords(Result, 28, 4));
  end
  else
  begin
    Result.AppendBits(Layers - 1, 5);
    Result.AppendBits(CodeWords - 1, 11);
    FreeAndSetBitArray(Result, GenerateCheckWords(Result, 40, 4));
  end;
end;

function TEncoder.GetGF(WordSize: integer): TGenericGF;
begin
  case WordSize of
    04:
      Result := TGenericGF.CreateAztecParam;
    06:
      Result := TGenericGF.CreateAztecData6;
    08:
      Result := TGenericGF.CreateAztecData8;
    10:
      Result := TGenericGF.CreateAztecData10;
    12:
      Result := TGenericGF.CreateAztecData12;
  else
    Result := nil;
  end;
  if Assigned(Result) and Assigned(FGarbage) then
    FGarbage.Add(Result);
end;

function TEncoder.GetMatrix(x, y: integer): Boolean;
begin
  Result := FMatrix[x, y];
end;

procedure TEncoder.SetBlack(x, y: integer);
begin
  FMatrix[x, y] := True;
end;

function TEncoder.StuffBits(Bits: TBitArray; WordSize: integer): TBitArray;
var
  N, Mask, i, j: integer;
  Word: LongInt;
begin
  Result := TBitArray.Create;
  N := Bits.Size;
  Mask := (1 shl WordSize) - 2;
  i := 0;
  while i < N do
  begin
    Word := 0;
    for j := 0 to WordSize - 1 do
      if (i + j >= N) or Bits[i + j] then
        Word := Word or (1 shl (WordSize - 1 - j));

    if (Word and Mask) = Mask then
    begin
      Result.AppendBits(Word and Mask, WordSize);
      Dec(i);
    end
    else if (Word and Mask) = 0 then
    begin
      Result.AppendBits(Word or 1, WordSize);
      Dec(i);
    end
    else
      Result.AppendBits(Word, WordSize);

    Inc(i, WordSize);
  end;

end;

function TEncoder.TotalBitsInLayer: integer;
begin
  Result := (IfValue(Compact, 88, 112) + 16 * Layers) * Layers;
end;

{ initialization }

procedure CHAR_MAPInit;
const
  mixedTable: array [0 .. 27] of AnsiChar = (#0, ' ', #1, #2, #3, #4, #5, #6,
    #7, #8, #9, #10, #11, #12, #13, #27, #28, #29, #30, #31, '@', '\', '^', '_',
    '`', '|', '~', #127);
  punctTable: array [0 .. 30] of AnsiChar = (#0, #13, #0, #0, #0, #0, '!', '\',
    '#', '$', '%', '&', '\', '(', ')', '*', '+', ',', '-', '.', '/', ':', ';',
    '<', '=', '>', '?', '[', ']', '{', '}');
var
  c: AnsiChar;
  i: integer;
begin
  CHAR_MAP[MODE_UPPER][' '] := 1;
  for c := 'A' to 'Z' do
    CHAR_MAP[MODE_UPPER][c] := Ord(c) - Ord('A') + 2;

  CHAR_MAP[MODE_LOWER][' '] := 1;
  for c := 'a' to 'z' do
    CHAR_MAP[MODE_LOWER][c] := Ord(c) - Ord('a') + 2;

  CHAR_MAP[MODE_DIGIT][' '] := 1;
  for c := '0' to '9' do
    CHAR_MAP[MODE_DIGIT][c] := Ord(c) - Ord('0') + 2;
  CHAR_MAP[MODE_DIGIT][','] := 12;
  CHAR_MAP[MODE_DIGIT]['.'] := 13;

  for i := 0 to High(mixedTable) do
    CHAR_MAP[MODE_MIXED][mixedTable[i]] := i;

  for i := 0 to High(punctTable) do
    CHAR_MAP[MODE_PUNCT][punctTable[i]] := i;
end;

procedure SHIFT_TABLEInit;
var
  i, j: integer;
begin
  for i := 0 to ShiftTableSize - 1 do
    for j := 0 to ShiftTableSize - 1 do
      SHIFT_TABLE[i, j] := -1;

  SHIFT_TABLE[MODE_UPPER][MODE_PUNCT] := 0;

  SHIFT_TABLE[MODE_LOWER][MODE_PUNCT] := 0;
  SHIFT_TABLE[MODE_LOWER][MODE_UPPER] := 28;

  SHIFT_TABLE[MODE_MIXED][MODE_PUNCT] := 0;

  SHIFT_TABLE[MODE_DIGIT][MODE_PUNCT] := 0;
  SHIFT_TABLE[MODE_DIGIT][MODE_UPPER] := 15
end;

initialization

CHAR_MAPInit;
SHIFT_TABLEInit;

end.

