(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                ---------------------------------                *
 *                            DELPHI                               *
 *                    Rijndael Extended API                        *
 *                          version 1.0                            *
 *                ---------------------------------                *
 *                                                   December 2000 *
 *                                                                 *
 * Author: Sergey Kirichenko (ksv@cheerful.com)                    *
 * Home Page: http://rcolonel.tripod.com                           *
 * Adapted to FastReport: Alexander Tzyganenko                     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

unit rc_Crypt;

{$I frx.inc}

interface

uses sysutils,
     rc_ApiRef;

const
  _KEYLength = 128;

function ExpandKey(sKey: AnsiString; iLength: integer): Ansistring;
{encode string}
function EnCryptString(const sMessage: AnsiString; sKeyMaterial: AnsiString): AnsiString;
{decode string}
function DeCryptString(const sMessage: AnsiString; sKeyMaterial: AnsiString): AnsiString;


implementation

function ExpandKey(sKey: Ansistring; iLength: integer): AnsiString;
var
  ikey: array [0..(_KEYLength div 8)-1] of byte;
  i,t: integer;
  sr: Ansistring;
begin
  sr:= sKey;
  FillChar(ikey,sizeof(ikey),0);
  try
    if (length(sr) mod 2)<> 0 then
      sr:= sr+ '0';
    t:= length(sr) div 2;
    if t> (iLength div 8) then
      t:= (iLength div 8);
    for i:= 0 to t-1 do
      ikey[i]:= strtoint('$'+String(sr[i*2+1]) + String(sr[i*2+2]));
  except
  end;
  sr:= '';
  for i:= 0 to (iLength div 8)-1 do
    sr:= sr + AnsiString(IntToHex(ikey[i],2));
  result:= sr;
end;

function EnCryptString(const sMessage: AnsiString; sKeyMaterial: AnsiString): AnsiString;
var
  sres: Ansistring;
  blockLength,i: integer;
  keyInst: TkeyInstance;
  cipherInst: TcipherInstance;
begin
  keyInst.blockLen:= BITSPERBLOCK;
  sres:= ExpandKey(sKeyMaterial,_KEYLength);
  if makeKey(addr(keyInst), DIR_ENCRYPT, _KEYLength, pAnsichar(sres))<> rTRUE then
    raise Exception.CreateFmt('Key error.',[-1]);
  cipherInst.blockLen:= BITSPERBLOCK;
  cipherInst.mode:= MODE_CBC;
  FillChar(cipherInst.IV,sizeof(cipherInst.IV),0);

  sres:= sMessage;
  blockLength:= length(sres)*8;
  if (blockLength mod BITSPERBLOCK)<> 0 then
    begin
      for i:= 1 to ((BITSPERBLOCK-(blockLength-(BITSPERBLOCK*(blockLength div BITSPERBLOCK)))) div 8) do
        sres:= sres+ ' ';
      blockLength:= length(sres)*8;
    end;

  if blocksEnCrypt(addr(cipherInst), addr(keyInst), addr(sres[1]), blockLength, addr(sres[1]))<> blockLength then
    raise Exception.CreateFmt('EnCrypt error.',[-2]);
  result:= sres;
end;

function DeCryptString(const sMessage: AnsiString; sKeyMaterial: AnsiString): AnsiString;
var
  sres: AnsiString;
  blockLength: integer;
  keyInst: TkeyInstance;
  cipherInst: TcipherInstance;
begin
  keyInst.blockLen:= BITSPERBLOCK;
  sres:= ExpandKey(sKeyMaterial,_KEYLength);
  if makeKey(addr(keyInst), DIR_DECRYPT, _KEYLength, pAnsichar(sres))<> rTRUE then
    raise Exception.CreateFmt('Key error.',[-1]);
  cipherInst.blockLen:= BITSPERBLOCK;
  cipherInst.mode:= MODE_CBC;
  FillChar(cipherInst.IV,sizeof(cipherInst.IV),0);

  sres:= sMessage;
  blockLength:= length(sres)*8;
  if (blockLength= 0) or ((blockLength mod BITSPERBLOCK)<> 0) then
    raise Exception.CreateFmt('Wrong message length.',[-4]);

  if blocksDeCrypt(addr(cipherInst), addr(keyInst), addr(sres[1]), blockLength, addr(sres[1]))<> blockLength then
    raise Exception.CreateFmt('DeCrypt error.',[-3]);
  result:= sres;
end;

end.

