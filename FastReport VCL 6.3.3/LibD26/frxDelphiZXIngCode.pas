unit frxDelphiZXIngCode;

(*
 * Copyright 2008 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *)

interface

uses Contnrs;

{$I frx.inc}

type
  TIntegerArray = array of Integer;

  TGenericGFPoly = class;

  TGenericGF = class
  private
    FExpTable: TIntegerArray;
    FLogTable: TIntegerArray;
    FZero: TGenericGFPoly;
    FOne: TGenericGFPoly;
    FSize: Integer;
    FPrimitive: Integer;
    FGeneratorBase: Integer;
    FInitialized: Boolean;
    FPolyList: array of TGenericGFPoly;

    procedure CheckInit;
    procedure Initialize;
  public
    class function CreateQRCodeField256: TGenericGF;

    class function CreateAztecData12: TGenericGF; // x^12 + x^6 + x^5 + x^3 + 1
    class function CreateAztecData10: TGenericGF; // x^10 + x^3 + 1
    class function CreateAztecData8: TGenericGF;
    class function CreateMatrixField256: TGenericGF; // x^8 + x^5 + x^3 + x^2 + 1
    class function CreateAztecData6: TGenericGF;
    class function CreateMaxicodeField64: TGenericGF; // x^6 + x + 1
    class function CreateAztecParam: TGenericGF; // x^4 + x + 1

    class function AddOrSubtract(A, B: Integer): Integer;

    constructor Create(Primitive, Size, B: Integer);
    destructor Destroy; override;
    function GetZero: TGenericGFPoly;
    function Exp(A: Integer): Integer;
    function GetGeneratorBase: Integer;
    function Inverse(A: Integer): Integer;
    function Multiply(A, B: Integer): Integer;
    function BuildMonomial(Degree, Coefficient: Integer): TGenericGFPoly;
  end;

  TGenericGFPolyArray = array of TGenericGFPoly;

  TGenericGFPoly = class
  private
    FField: TGenericGF;
    FCoefficients: TIntegerArray;
  public
    constructor Create(AField: TGenericGF; ACoefficients: TIntegerArray);
    destructor Destroy; override;
    function Coefficients: TIntegerArray;
    function Multiply(Other: TGenericGFPoly): TGenericGFPoly;
    function MultiplyByMonomial(Degree, Coefficient: Integer): TGenericGFPoly;
    function Divide(Other: TGenericGFPoly): TGenericGFPolyArray;
    function GetCoefficients: TIntegerArray;
    function IsZero: Boolean;
    function GetCoefficient(Degree: Integer): Integer;
    function GetDegree: Integer;
    function AddOrSubtract(Other: TGenericGFPoly): TGenericGFPoly;
  end;

  TReedSolomonEncoder = class
  private
    FField: TGenericGF;
    FCachedGenerators: TObjectList;
  public
    constructor Create(AField: TGenericGF);
    destructor Destroy; override;
    procedure Encode(ToEncode: TIntegerArray; ECBytes: Integer);
    function BuildGenerator(Degree: Integer): TGenericGFPoly;
  end;

  TByteArray = array of Byte;

  TBitArray = class
  private
    FSize: Integer;
    Bits: array of Integer;

    procedure SetItem(i: Integer; const Value: Boolean);
  protected
    procedure EnsureCapacity(Size: Integer);
  public
    constructor Create; overload;
    constructor Create(const Size: Integer); overload;
    procedure Clear;
    function GetSizeInBytes: Integer;
    function GetSize: Integer;
    function Get(i: Integer): Boolean;
    procedure SetBit(Index: Integer);
    procedure AppendBit(Bit: Boolean);
    procedure AppendBits(Value, NumBits: Integer);
    procedure AppendBitArray(NewBitArray: TBitArray);
    procedure ToBytes(BitOffset: Integer; Source: TByteArray;
      Offset, NumBytes: Integer);
    procedure XorOperation(Other: TBitArray);

    property Size: Integer read FSize;
    property Item[i: Integer]: Boolean read Get write SetItem; default;
  end;

function IfValue(IsTrue: Boolean; TrueValue, FalseValue: Integer)
  : Integer; overload;
function IfValue(IsTrue: Boolean; TrueValue, FalseValue: string)
  : string; overload;
function IfValue(IsTrue: Boolean; TrueValue, FalseValue: AnsiChar)
  : AnsiChar; overload;

//function ToBinaryString(x: LongInt): string;
procedure FreeAndSetBitArray(var BitArray1: TBitArray; BitArray2: TBitArray);

implementation

(***************************************************************)

uses
  Math, Classes, SysUtils, frxUnicodeUtils{$IFNDEF FPC}, Windows{$ENDIF};

procedure FreeAndSetBitArray(var BitArray1: TBitArray; BitArray2: TBitArray);
var
  Temp: TBitArray;
begin
  Temp := BitArray2;
  BitArray1.Free;
  BitArray1 := Temp;
end;

//function ToBinaryString(x: LongInt): string;
//var
//  i: integer;
//begin
//  Result := '';
//  for i := 0 to 32 - 1 do
//  begin
//    Result := IfValue(Odd(x), '1', '0') + Result;
//    x := x div 2;
//  end;
//end;

{ IfValue }

function IfValue(IsTrue: Boolean; TrueValue, FalseValue: AnsiChar): AnsiChar;
begin
  if IsTrue then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function IfValue(IsTrue: Boolean; TrueValue, FalseValue: string): string;
begin
  if IsTrue then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function IfValue(IsTrue: Boolean; TrueValue, FalseValue: Integer): Integer;
begin
  if IsTrue then
    Result := TrueValue
  else
    Result := FalseValue;
end;

{ TBitArray }

procedure TBitArray.AppendBit(Bit: Boolean);
begin
  EnsureCapacity(Size + 1);
  if (Bit) then
  begin
    Bits[Size shr 5] := Bits[Size shr 5] or (1 shl (Size and $1F));
  end;
  Inc(FSize);
end;

procedure TBitArray.AppendBitArray(NewBitArray: TBitArray);
var
  OtherSize: Integer;
  i: Integer;
begin
  OtherSize := NewBitArray.GetSize;
  EnsureCapacity(Size + OtherSize);
  for i := 0 to OtherSize - 1 do
  begin
    AppendBit(NewBitArray.Get(i));
  end;
end;

procedure TBitArray.AppendBits(Value, NumBits: Integer);
var
  NumBitsLeft: Integer;
begin
  if ((NumBits < 0) or (NumBits > 32)) then
  begin

  end;
  EnsureCapacity(Size + NumBits);
  for NumBitsLeft := NumBits downto 1 do
  begin
    AppendBit(((Value shr (NumBitsLeft - 1)) and $01) = 1);
  end;
end;

constructor TBitArray.Create;
begin
  FSize := 0;
  SetLength(Bits, 1);
end;

procedure TBitArray.Clear;
begin
  FSize := 0;
  SetLength(Bits, 1);
  Bits[0] := 0;
end;

constructor TBitArray.Create(const Size: Integer);
begin
  FSize := Size;
  SetLength(Bits, (Size + 31) shr 5);
end;

procedure TBitArray.EnsureCapacity(Size: Integer);
begin
  if (Size > (Length(Bits) shl 5)) then
  begin
    SetLength(Bits, (Size + 31) shr 5);
  end;
end;

function TBitArray.Get(i: Integer): Boolean;
begin
  Result := (Bits[i shr 5] and (1 shl (i and $1F))) <> 0;
end;

function TBitArray.GetSize: Integer;
begin
  Result := Size;
end;

function TBitArray.GetSizeInBytes: Integer;
begin
  Result := (Size + 7) shr 3;
end;

procedure TBitArray.SetBit(Index: Integer);
begin
  Bits[Index shr 5] := Bits[Index shr 5] or (1 shl (Index and $1F));
end;

procedure TBitArray.SetItem(i: Integer; const Value: Boolean);
begin
  if Value then
    SetBit(i);
end;

procedure TBitArray.ToBytes(BitOffset: Integer; Source: TByteArray;
  Offset, NumBytes: Integer);
var
  i: Integer;
  J: Integer;
  TheByte: Integer;
begin
  for i := 0 to NumBytes - 1 do
  begin
    TheByte := 0;
    for J := 0 to 7 do
    begin
      if (Get(BitOffset)) then
      begin
        TheByte := TheByte or (1 shl (7 - J));
      end;
      Inc(BitOffset);
    end;
    Source[Offset + i] := TheByte;
  end;
end;

procedure TBitArray.XorOperation(Other: TBitArray);
var
  i: Integer;
begin
  if (Length(Bits) = Length(Other.Bits)) then
  begin
    for i := 0 to Length(Bits) - 1 do
    begin
      // The last byte could be incomplete (i.e. not have 8 bits in
      // it) but there is no problem since 0 XOR 0 == 0.
      Bits[i] := Bits[i] xor Other.Bits[i];
    end;
  end;
end;

{ TReedSolomonEncoder }

function TReedSolomonEncoder.BuildGenerator(Degree: Integer): TGenericGFPoly;
var
  LastGenerator: TGenericGFPoly;
  NextGenerator: TGenericGFPoly;
  Poly: TGenericGFPoly;
  D: Integer;
  CA: TIntegerArray;
begin
  if (Degree >= FCachedGenerators.Count) then
  begin
    LastGenerator := TGenericGFPoly
      (FCachedGenerators[FCachedGenerators.Count - 1]);

    for D := FCachedGenerators.Count to Degree do
    begin
      SetLength(CA, 2);
      CA[0] := 1;
      CA[1] := FField.Exp(D - 1 + FField.GetGeneratorBase);
      Poly := TGenericGFPoly.Create(FField, CA);
      NextGenerator := LastGenerator.Multiply(Poly);
      FCachedGenerators.Add(NextGenerator);
      LastGenerator := NextGenerator;
    end;
  end;
  Result := TGenericGFPoly(FCachedGenerators[Degree]);
end;

constructor TReedSolomonEncoder.Create(AField: TGenericGF);
var
  GenericGFPoly: TGenericGFPoly;
  IntArray: TIntegerArray;
begin
  FField := AField;

  // Contents of FCachedGenerators will be freed by FGenericGF.Destroy
  FCachedGenerators := TObjectList.Create(False);

  SetLength(IntArray, 1);
  IntArray[0] := 1;
  GenericGFPoly := TGenericGFPoly.Create(AField, IntArray);
  FCachedGenerators.Add(GenericGFPoly);
end;

destructor TReedSolomonEncoder.Destroy;
begin
  FCachedGenerators.Free;
  inherited;
end;

procedure TReedSolomonEncoder.Encode(ToEncode: TIntegerArray; ECBytes: Integer);
var
  DataBytes: Integer;
  Generator: TGenericGFPoly;
  InfoCoefficients: TIntegerArray;
  Info: TGenericGFPoly;
  Remainder: TGenericGFPoly;
  Coefficients: TIntegerArray;
  NumZeroCoefficients: Integer;
  i: Integer;
begin
  SetLength(Coefficients, 0);
  if (ECBytes > 0) then
  begin
    DataBytes := Length(ToEncode) - ECBytes;
    if (DataBytes > 0) then
    begin
      Generator := BuildGenerator(ECBytes);
      SetLength(InfoCoefficients, DataBytes);
      InfoCoefficients := Copy(ToEncode, 0, DataBytes);
      Info := TGenericGFPoly.Create(FField, InfoCoefficients);
      Info := Info.MultiplyByMonomial(ECBytes, 1);
      Remainder := Info.Divide(Generator)[1];
      Coefficients := Remainder.GetCoefficients;
      NumZeroCoefficients := ECBytes - Length(Coefficients);
      for i := 0 to NumZeroCoefficients - 1 do
      begin
        ToEncode[DataBytes + i] := 0;
      end;
      Move(Coefficients[0], ToEncode[DataBytes + NumZeroCoefficients],
        Length(Coefficients) * SizeOf(Integer));
    end;
  end;
end;

{ TGenericGFPoly }

function TGenericGFPoly.AddOrSubtract(Other: TGenericGFPoly): TGenericGFPoly;
var
  SmallerCoefficients: TIntegerArray;
  LargerCoefficients: TIntegerArray;
  Temp: TIntegerArray;
  SumDiff: TIntegerArray;
  LengthDiff: Integer;
  i: Integer;
begin
  SetLength(SmallerCoefficients, 0);
  SetLength(LargerCoefficients, 0);
  SetLength(Temp, 0);
  SetLength(SumDiff, 0);

  Result := nil;
  if (Assigned(Other)) then
  begin
    if (FField = Other.FField) then
    begin
      if (IsZero) then
      begin
        Result := Other;
        Exit;
      end;

      if (Other.IsZero) then
      begin
        Result := Self;
        Exit;
      end;

      SmallerCoefficients := FCoefficients;
      LargerCoefficients := Other.Coefficients;
      if (Length(SmallerCoefficients) > Length(LargerCoefficients)) then
      begin
        Temp := SmallerCoefficients;
        SmallerCoefficients := LargerCoefficients;
        LargerCoefficients := Temp;
      end;
      SetLength(SumDiff, Length(LargerCoefficients));
      LengthDiff := Length(LargerCoefficients) - Length(SmallerCoefficients);

      // Copy high-order terms only found in higher-degree polynomial's coefficients
      if (LengthDiff > 0) then
      begin
        //SumDiff := Copy(LargerCoefficients, 0, LengthDiff);
        Move(LargerCoefficients[0], SumDiff[0], LengthDiff * SizeOf(Integer));
      end;

      for i := LengthDiff to Length(LargerCoefficients) - 1 do
      begin
        SumDiff[i] := TGenericGF.AddOrSubtract
          (SmallerCoefficients[i - LengthDiff], LargerCoefficients[i]);
      end;

      Result := TGenericGFPoly.Create(FField, SumDiff);
    end;
  end;
end;

function TGenericGFPoly.Coefficients: TIntegerArray;
begin
  Result := FCoefficients;
end;

constructor TGenericGFPoly.Create(AField: TGenericGF;
  ACoefficients: TIntegerArray);
var
  CoefficientsLength: Integer;
  FirstNonZero: Integer;
begin
  FField := AField;
  SetLength(FField.FPolyList, Length(FField.FPolyList) + 1);
  FField.FPolyList[Length(FField.FPolyList) - 1] := Self;
  CoefficientsLength := Length(ACoefficients);
  if ((CoefficientsLength > 1) and (ACoefficients[0] = 0)) then
  begin
    // Leading term must be non-zero for anything except the constant polynomial "0"
    FirstNonZero := 1;
    while ((FirstNonZero < CoefficientsLength) and
      (ACoefficients[FirstNonZero] = 0)) do
    begin
      Inc(FirstNonZero);
    end;

    if (FirstNonZero = CoefficientsLength) then
    begin
      FCoefficients := AField.GetZero.Coefficients;
    end
    else
    begin
      SetLength(FCoefficients, CoefficientsLength - FirstNonZero);
      FCoefficients := Copy(ACoefficients, FirstNonZero, Length(FCoefficients));
    end;
  end
  else
  begin
    FCoefficients := ACoefficients;
  end;
end;

destructor TGenericGFPoly.Destroy;
begin
  Self.FField := FField;
  inherited;
end;

function TGenericGFPoly.Divide(Other: TGenericGFPoly): TGenericGFPolyArray;
var
  Quotient: TGenericGFPoly;
  Remainder: TGenericGFPoly;
  DenominatorLeadingTerm: Integer;
  InverseDenominatorLeadingTerm: Integer;
  DegreeDifference: Integer;
  Scale: Integer;
  Term: TGenericGFPoly;
  IterationQuotient: TGenericGFPoly;
begin
  SetLength(Result, 0);
  if ((FField = Other.FField) and (not Other.IsZero)) then
  begin

    Quotient := FField.GetZero;
    Remainder := Self;

    DenominatorLeadingTerm := Other.GetCoefficient(Other.GetDegree);
    InverseDenominatorLeadingTerm := FField.Inverse(DenominatorLeadingTerm);

    while ((Remainder.GetDegree >= Other.GetDegree) and
      (not Remainder.IsZero)) do
    begin
      DegreeDifference := Remainder.GetDegree - Other.GetDegree;
      Scale := FField.Multiply(Remainder.GetCoefficient(Remainder.GetDegree),
        InverseDenominatorLeadingTerm);
      Term := Other.MultiplyByMonomial(DegreeDifference, Scale);
      IterationQuotient := FField.BuildMonomial(DegreeDifference, Scale);
      Quotient := Quotient.AddOrSubtract(IterationQuotient);
      Remainder := Remainder.AddOrSubtract(Term);
    end;

    SetLength(Result, 2);
    Result[0] := Quotient;
    Result[1] := Remainder;
  end;
end;

function TGenericGFPoly.GetCoefficient(Degree: Integer): Integer;
begin
  Result := FCoefficients[Length(FCoefficients) - 1 - Degree];
end;

function TGenericGFPoly.GetCoefficients: TIntegerArray;
begin
  Result := FCoefficients;
end;

function TGenericGFPoly.GetDegree: Integer;
begin
  Result := Length(FCoefficients) - 1;
end;

function TGenericGFPoly.IsZero: Boolean;
begin
  Result := FCoefficients[0] = 0;
end;

function TGenericGFPoly.Multiply(Other: TGenericGFPoly): TGenericGFPoly;
var
  ACoefficients: TIntegerArray;
  BCoefficients: TIntegerArray;
  Product: TIntegerArray;
  ALength: Integer;
  BLength: Integer;
  i: Integer;
  J: Integer;
  ACoeff: Integer;
begin
  SetLength(ACoefficients, 0);
  SetLength(BCoefficients, 0);
  Result := nil;

  if (FField = Other.FField) then
  begin
    if (IsZero or Other.IsZero) then
    begin
      Result := FField.GetZero;
      Exit;
    end;

    ACoefficients := FCoefficients;
    ALength := Length(ACoefficients);
    BCoefficients := Other.Coefficients;
    BLength := Length(BCoefficients);
    SetLength(Product, ALength + BLength - 1);
    for i := 0 to ALength - 1 do
    begin
      ACoeff := ACoefficients[i];
      for J := 0 to BLength - 1 do
      begin
        Product[i + J] := TGenericGF.AddOrSubtract(Product[i + J],
          FField.Multiply(ACoeff, BCoefficients[J]));
      end;
    end;
    Result := TGenericGFPoly.Create(FField, Product);
  end;
end;

function TGenericGFPoly.MultiplyByMonomial(Degree, Coefficient: Integer)
  : TGenericGFPoly;
var
  i: Integer;
  Size: Integer;
  Product: TIntegerArray;
begin
  Result := nil;
  if (Degree >= 0) then
  begin
    if (Coefficient = 0) then
    begin
      Result := FField.GetZero;
      Exit;
    end;
    Size := Length(Coefficients);
    SetLength(Product, Size + Degree);
    for i := 0 to Size - 1 do
    begin
      Product[i] := FField.Multiply(FCoefficients[i], Coefficient);
    end;
    Result := TGenericGFPoly.Create(FField, Product);
  end;
end;

{ TGenericGF }

class function TGenericGF.AddOrSubtract(A, B: Integer): Integer;
begin
  Result := A xor B;
end;

function TGenericGF.BuildMonomial(Degree, Coefficient: Integer): TGenericGFPoly;
var
  Coefficients: TIntegerArray;
begin
  CheckInit();

  if (Degree >= 0) then
  begin
    if (Coefficient = 0) then
    begin
      Result := FZero;
      Exit;
    end;
    SetLength(Coefficients, Degree + 1);
    Coefficients[0] := Coefficient;
    Result := TGenericGFPoly.Create(Self, Coefficients);
  end
  else
  begin
    Result := nil;
  end;
end;

procedure TGenericGF.CheckInit;
begin
  if (not FInitialized) then
  begin
    Initialize;
  end;
end;

constructor TGenericGF.Create(Primitive, Size, B: Integer);
begin
  FInitialized := False;
  FPrimitive := Primitive;
  FSize := Size;
  FGeneratorBase := B;
  if (FSize < 0) then
  begin
    Initialize;
  end;
end;

class function TGenericGF.CreateAztecData10: TGenericGF;
begin
  Result := TGenericGF.Create($0409, 1024, 1);
end;

class function TGenericGF.CreateAztecData12: TGenericGF;
begin
  Result := TGenericGF.Create($1069, 4096, 1);
end;

class function TGenericGF.CreateAztecData6: TGenericGF;
begin
  Result := TGenericGF.Create($0043, 64, 1);
end;

class function TGenericGF.CreateAztecData8: TGenericGF;
begin
  Result := TGenericGF.Create($012D, 256, 1);
end;

class function TGenericGF.CreateAztecParam: TGenericGF;
begin
  Result := TGenericGF.Create($0013, 16, 1);
end;

class function TGenericGF.CreateMatrixField256: TGenericGF;
begin
  Result := CreateAztecData8;
end;

class function TGenericGF.CreateMaxicodeField64: TGenericGF;
begin
  Result := CreateAztecData6;
end;

class function TGenericGF.CreateQRCodeField256: TGenericGF;
begin
  Result := TGenericGF.Create($011D, 256, 0);
end;

destructor TGenericGF.Destroy;
var
  X, Y: Integer;
begin
  for X := 0 to Length(FPolyList) - 1 do
    if (Assigned(FPolyList[X])) then
    begin
      for Y := X + 1 to Length(FPolyList) - 1 do
        if FPolyList[Y] = FPolyList[X] then
          FPolyList[Y] := nil;
      FPolyList[X].Free;
    end;
  inherited;
end;

function TGenericGF.Exp(A: Integer): Integer;
begin
  CheckInit;
  Result := FExpTable[A];
end;

function TGenericGF.GetGeneratorBase: Integer;
begin
  Result := FGeneratorBase;
end;

function TGenericGF.GetZero: TGenericGFPoly;
begin
  CheckInit;
  Result := FZero;
end;

procedure TGenericGF.Initialize;
var
  X: Integer;
  i: Integer;
  CA: TIntegerArray;
begin
  SetLength(FExpTable, FSize);
  SetLength(FLogTable, FSize);
  X := 1;
  for i := 0 to FSize - 1 do
  begin
    FExpTable[i] := X;
    X := X shl 1; // x = x * 2; we're assuming the generator alpha is 2
    if (X >= FSize) then
    begin
      X := X xor FPrimitive;
      X := X and (FSize - 1);
    end;
  end;

  for i := 0 to FSize - 2 do
  begin
    FLogTable[FExpTable[i]] := i;
  end;

  // logTable[0] == 0 but this should never be used

  SetLength(CA, 1);
  CA[0] := 0;
  FZero := TGenericGFPoly.Create(Self, CA);

  SetLength(CA, 1);
  CA[0] := 1;
  FOne := TGenericGFPoly.Create(Self, CA);

  FInitialized := True;
end;

function TGenericGF.Inverse(A: Integer): Integer;
begin
  CheckInit;

  if (A <> 0) then
  begin
    Result := FExpTable[FSize - FLogTable[A] - 1];
  end
  else
  begin
    Result := 0;
  end;
end;

function TGenericGF.Multiply(A, B: Integer): Integer;
begin
  CheckInit;
  if ((A <> 0) and (B <> 0)) then
  begin
    Result := FExpTable[(FLogTable[A] + FLogTable[B]) mod (FSize - 1)];
  end
  else
  begin
    Result := 0;
  end;
end;

initialization

end.

