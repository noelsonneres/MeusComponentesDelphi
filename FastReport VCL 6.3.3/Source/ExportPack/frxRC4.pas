
{******************************************}
{                                          }
{             FastReport v5.0              }
{          RC4 crypto algorythm            }
{                                          }
{******************************************}

unit frxRC4;

interface

{$I frx.inc}

uses
  SysUtils, Classes;

type
  PByte = ^Byte;

  TfrxRC4 = class(TObject)
  private
    FKey: array[0..255] of byte;
    procedure xchg(var byte1, byte2: Byte);
  public
    procedure Start(Key: Pointer; KeyLength: Integer);
    procedure Crypt(Source, Target: Pointer; Length: Integer);
  end;

implementation

uses
  frxClass;

procedure TfrxRC4.xchg(var byte1, byte2: Byte);
var
  t: Byte;
begin
  t := byte1;
  byte1 := byte2;
  byte2 := t;
end;

procedure TfrxRC4.Start(Key: Pointer; KeyLength: Integer);
var
  i, j: integer;
  k: array[0..255] of byte;
begin
  if (KeyLength > 0) and (KeyLength <=  256) then
  begin
    for i := 0 to 255 do
    begin
      FKey[i] := i;
      k[i] := PByte(frxInteger(Key) + (i mod KeyLength))^;
    end;
    j := 0;
    for i := 0 to 255 do
    begin
      j := (j + FKey[i] + k[i]) and $FF;
      xchg(FKey[i], FKey[j]);
    end;
  end;
end;

procedure TfrxRC4.Crypt(Source, Target: Pointer; Length: Integer);
var
  i, j: byte;
  k: integer;
begin
  i := 0;
  j := 0;
  for k := 0 to Length - 1 do
  begin
    i := Byte(i + 1);
    j := Byte(j + FKey[i]);
    xchg(FKey[i], FKey[j]);
    PByteArray(Target)[k] := PByteArray(Source)[k] xor FKey[Byte(FKey[i] + FKey[j])];
  end;
end;

end.
