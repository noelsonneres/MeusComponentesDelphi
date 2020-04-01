
{******************************************}
{                                          }
{             FastReport v5.0              }
{          Report encrypt/decrypt          }
{                                          }
{         Copyright (c) 2007-2008          }
{         by Alexander Tzyganenko,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxCrypt;

interface

{$I frx.inc}

uses {$IFNDEF FPC}Windows, {$ENDIF}Classes, SysUtils, Forms, Controls, frxClass;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxCrypt = class(TfrxCustomCrypter)
  private
    function AskKey(const Key: AnsiString): AnsiString;
  public
    procedure Crypt(Dest: TStream; const Key: AnsiString); override;
    function Decrypt(Source: TStream; const Key: AnsiString): Boolean; override;
  end;


procedure frxCryptStream(Source, Dest: TStream; const Key: AnsiString);
procedure frxDecryptStream(Source, Dest: TStream; const Key: AnsiString);


implementation

uses frxUtils, rc_Crypt, frxPassw;


function MakeKey(const Key: AnsiString): AnsiString;
begin
  Result := '';
  if (Key <> '') then
  begin
    SetLength(Result, Length(Key) * 2);
{$IFDEF Delphi12}
    BinToHex(PAnsiChar(@Key[1]), PAnsiChar(@Result[1]), Length(Key));
{$ELSE}
    BinToHex(@Key[1], @Result[1], Length(Key));
{$ENDIF}
  end;
  Result := ExpandKey(Result, _KEYLength);
end;

procedure frxCryptStream(Source, Dest: TStream; const Key: AnsiString);
var
  s: AnsiString;
  header: array [0..2] of byte;
begin
  Source.Position := 0;
  SetLength(s, Source.Size);
  Source.Read(s[1], Source.Size);

  s := EncryptString(s, MakeKey(Key));

  header[0] := Ord('r');
  header[1] := Ord('i');
  header[2] := Ord('j');
  Dest.Write(header, 3);
  Dest.Write(s[1], Length(s));
end;

procedure frxDecryptStream(Source, Dest: TStream; const Key: AnsiString);
var
  s: AnsiString;
begin
  SetLength(s, Source.Size);
  Source.Read(s[1], Source.Size);

  if (s <> '') and (s[1] = 'r') and (s[2] = 'i') and (s[3] = 'j') then
  begin
    Delete(s, 1, 3);
    s := DecryptString(s, MakeKey(Key));
  end;

  Dest.Write(s[1], Length(s));
end;


{ TfrxCrypt }

function TfrxCrypt.AskKey(const Key: AnsiString): AnsiString;
begin
  Result := Key;
  if Result = '' then
    with TfrxPasswordForm.Create(Application) do
    begin
      if ShowModal = mrOk then
{$IFDEF Delphi12}
        Result :=  AnsiString(PasswordE.Text);
{$ELSE}
        Result := PasswordE.Text;
{$ENDIF}
      Free;
    end;
end;

procedure TfrxCrypt.Crypt(Dest: TStream; const Key: AnsiString);
begin
  frxCryptStream(Stream, Dest, Key);
end;

function TfrxCrypt.Decrypt(Source: TStream; const Key: AnsiString): Boolean;
var
  Signature: array[0..2] of Byte;
begin
  Source.Read(Signature, 3);
  Source.Seek(-3, soFromCurrent);
  Result := (Signature[0] = Ord('r')) and (Signature[1] = Ord('i')) and (Signature[2] = Ord('j'));
  if Result then
    frxDecryptStream(Source, Stream, AskKey(Key));
  Stream.Position := 0;
end;

end.
