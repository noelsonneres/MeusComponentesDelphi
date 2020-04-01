
{******************************************}
{                                          }
{             FastReport v5.0              }
{          Report Server misc utils        }
{                                          }
{         Copyright (c) 1998-2014          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServerUtils;

{$I frx.inc}

interface

uses Windows, Classes, SysUtils, Messages, ActiveX, frxUtils;

function StrToHex(const s: AnsiString): AnsiString;
function HexToStr(const s : AnsiString) : AnsiString;
function Byte2Hex(const b: byte): AnsiString;
function GetHTTPErrorText(const ErrorCode: integer):AnsiString;
function GetUniqueFileName(const Path: String; const Prefix: String): String;
{$IFDEF Delphi12}
function Str2HTML(const Str: WideString): AnsiString; overload;
function Str2HTML(const Str: AnsiString): AnsiString; overload;
{$ELSE}
function Str2HTML(const Str: AnsiString): AnsiString;
{$ENDIF}

function HTML2Str(const Line: AnsiString): AnsiString;
function UnQuoteStr(const s: AnsiString): AnsiString;
function GetEnvVar(const VarName: String): String;
function MakeSessionId: AnsiString;

function frxGetAbsPath(const Path: String): String;
function frxGetRelPath(const Path: String): String;
function frxGetAbsPathDir(const Path: String; const Dir: String): String;
function frxGetRelPathDir(const Path: String; const Dir: String): String;

procedure frxTouchDir(const Path: String);
procedure SetCommaText(const Text: String; sl: TStrings; Comma: Char = ';');
function NormalDir(const DirName: string): string;
procedure CopyFile(const fFrom, fTo: String);
procedure CopyFiles(const sFrom, sTo, sNames, sExcept: String; const Recursive: Boolean);
procedure CopyFilesF(const sFrom, sTo, sNames, sExcept: String);

type
  TfrxServerFormat = (sfHTM, sfXML, sfXLS, sfRTF, sfCSV, sfTXT, sfPDF, sfJPG, sfBMP, sfTIFF, sfGIF, sfFRP, sfODS, sfODT);
  TfrxServerOutputFormats = set of TfrxServerFormat;
  TfrxHTTPQueryType = (qtGet, qtPost, qtHead);

implementation


function StrToHex(const s: AnsiString): AnsiString;
var
  Len, i: Integer;
  C, H, L: Byte;

  function HexChar(N : Byte) : AnsiChar;
  begin
    if (N < 10) then Result := AnsiChar(Chr(Ord('0') + N))
    else Result := AnsiChar(Chr(Ord('A') + (N - 10)));
  end;

begin
  Len := Length(s);
  SetLength(Result, Len shl 1);
  for i := 1 to Len do begin
    C := Ord(s[i]);
    H := (C shr 4) and $f;
    L := C and $f;
    Result[i shl 1 - 1] := HexChar(H);
    Result[i shl 1]:= HexChar(L);
  end;
end;

function HexToStr(const s : AnsiString) : AnsiString;
var
  Len, i: Integer;
  C, H, L: Byte;

  function CharHex(C: AnsiChar): Byte;
  begin
    C := UpCase(C);
    if (C <= '9') then Result := Ord(C) - Ord('0')
    else Result := Ord(C) - Ord('A') + 10;
  end;

begin
  Len := Length(s);
  SetLength(Result, Len shr 1);
  for i := 1 to Len shr 1 do begin
    H := CharHex(s[i shl 1 - 1]);
    L := CharHex(s[i shl 1]);
    C := H shl 4 or L;
    Result[i] := AnsiChar(Chr(C));
  end;
end;

function Byte2Hex(const b: byte): AnsiString;
var
  H, L: Byte;
  function HexChar(N : Byte) : AnsiChar;
  begin
    if (N < 10) then Result := AnsiChar(Chr(Ord('0') + N))
    else Result := AnsiChar(Chr(Ord('A') + (N - 10)));
  end;
begin
  SetLength(Result, 2);
  H := (b shr 4) and $f;
  L := b and $f;
  Result[1] := HexChar(H);
  Result[2]:= HexChar(L);
end;

function GetHTTPErrorText(const ErrorCode: integer):AnsiString;
begin
  case errorcode of
    400: result:=  'Bad Request';
    401: result:=  'Unauthorized';
    402: result:=  'Payment Required';
    403: result:=  'Forbidden';
    404: result:=  'Not Found';
    405: result:=  'Method Not Allowed';
    406: result:=  'Not Acceptable';
    407: result:=  'Proxy Authentication Required';
    408: result:=  'Request Timeout';
    409: result:=  'Conflict';
    410: result:=  'Gone';
    411: result:=  'Length Required';
    412: result:=  'Precondition Failed';
    413: result:=  'Request Entity Too Large';
    414: result:=  'Request-URI Too Long';
    415: result:=  'Unsupported Media Type';
    500: result:=  'Internal Server Error';
    501: result:=  'Not Implemented'
    else
      Result := ''
  end;
  if Length(Result) > 0 then
    Result := Result + ' (' + AnsiString(IntToStr(errorcode)) + ')';
end;

function GetUniqueFileName(const Path: String; const Prefix: String): String;
begin
{$IFDEF Delphi12}
  Result := Path + '\' + Prefix + String(MakeSessionId) + '.tmp';
{$ELSE}
  Result := Path + '\' + Prefix + MakeSessionId + '.tmp';
{$ENDIF}
end;

{$IFDEF Delphi12}
function Str2HTML(const Str: WideString): AnsiString;
begin
  Result := Str2HTML(AnsiString(Str));
end;
{$ENDIF}

function Str2HTML(const Str: AnsiString): AnsiString;
var
  i: Integer;
  c: AnsiChar;
  s: AnsiString;
begin
  Result := '';
  for i := 1 to Length(Str) do
  begin
    c := Str[i];
    case c of
     '0'..'9', 'A'..'Z', 'a'..'z', '.', '-': Result := Result + c;
      else begin
        s := c;
        Result := Result + '%' + StrToHex(s);
      end
   end;
  end;
end;

function HTML2Str(const Line: AnsiString): AnsiString;
var
  i: Integer;
  s, buf: AnsiString;
begin
  Result := Line;
  if Length(Result) > 0 then
  begin
    i := 1;
    while i <= Length(Result) do
    begin
      if Result[i] = '%' then
      begin
        if i <= Length(Result) - 2 then
        begin
          s := Result[i + 1] + Result[i + 2];
          buf := HexToStr(s);
          Delete(Result, i, 2);
          Result[i] := buf[1];
        end
      end
      else
      if Result[i] = '+' then
        Result[i] := ' ';
      i := i + 1;
    end;
  end;
end;

function UnQuoteStr(const s: AnsiString): AnsiString;
begin
  Result := s;
  if Length(Result) > 0 then
  begin
    if (Result[1] = #39) and (Result[Length(Result)] = #39) then
    begin
      Delete(Result, 1, 1);
      Delete(Result, Length(Result), 1);
    end;
  end;
end;

function GetEnvVar(const VarName: String): String;
var
  buffer: PChar;
  size: Integer;
const
  BUF_SIZE = 4096;
begin
  Result := '';
  size := 0;
  GetMem(buffer, BUF_SIZE);
  if buffer <> nil then
  size := GetEnvironmentVariable(PChar(VarName), buffer, BUF_SIZE);
  if size > 0 then
    Result := String(buffer);
  FreeMem(buffer);
end;

function MakeSessionId: AnsiString;
var
  AGUID: TGUID;
  AGUIDString: widestring;
begin
  CoCreateGUID(AGUID);
  SetLength(AGUIDString, 39);
  StringFromGUID2(AGUID, PWideChar(AGUIDString), 39);
{$IFDEF Delphi12}
  Result := AnsiString(PWideChar(AGUIDString));
{$ELSE}
  Result := string(PWideChar(AGUIDString));
{$ENDIF}
  Result := Copy(Result, 2, 36);

{$IFDEF Delphi12}
  Result := AnsiString(StringReplace(String(Result), '-', '', [rfReplaceAll]));
{$ELSE}
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
{$ENDIF}
end;

function frxGetAbsPath(const Path: String): String;
begin
  Result := frxGetAbsPathDir(Path, GetAppPath);
end;

function frxGetAbsPathDir(const Path: String; const Dir: String): String;
var
  s: String;
  i: Integer;

  function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
  var
    I,X: Integer;
    Len, LenSubStr: Integer;
  begin
    if Offset = 1 then
      Result := Pos(SubStr, S)
    else
    begin
      I := Offset;
      LenSubStr := Length(SubStr);
      Len := Length(S) - LenSubStr + 1;
      while I <= Len do
      begin
        if S[I] = SubStr[1] then
        begin
          X := 1;
          while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
            Inc(X);
          if (X = LenSubStr) then
          begin
            Result := I;
            exit;
          end;
        end;
        Inc(I);
      end;
      Result := 0;
    end;
  end;

begin
  s := Dir;
  if Pos('.\', Path) = 1 then
    Result := StringReplace(Path, '.\', s, [])
  else
  if Pos('..\', Path) = 1 then
  begin
    s := frxReverseString(s);
    i := PosEx('\', s, 2);
    if i > 0 then
      s := Copy(s, i, Length(s) - i + 1);
    Result := frxReverseString(s) + Copy(Path, 4, Length(Path) - 3);
  end
  else
  if (Pos('\', Path) = 1) or (Pos(':', Path) = 2) then
    Result := Path
  else
    Result := s + Path;
end;

function frxGetRelPath(const Path: String): String;
begin
  Result := frxGetRelPathDir(Path, GetAppPath);
end;

function frxGetRelPathDir(const Path: String; const Dir: String): String;
var
  s1, s2: String;
begin
  s1 := Dir;
  s2 := frxGetAbsPathDir('..\', Dir);
  if Pos(s1, Path) = 1 then
    Result := StringReplace(Path, s1, '.\', [rfIgnoreCase])
  else
  if Pos(s2, Path) = 1 then
    Result := StringReplace(Path, s2, '..\', [rfIgnoreCase])
  else
    Result := Path;
end;

procedure frxTouchDir(const Path: String);
var
  SecAtrtrs: TSecurityAttributes;
begin
  if not DirectoryExists(Path) then
  begin
    SecAtrtrs.nLength := SizeOf(TSecurityAttributes);
    SecAtrtrs.lpSecurityDescriptor := nil;
    SecAtrtrs.bInheritHandle := true;
    CreateDirectory(PChar(Path), @SecAtrtrs);
  end;
end;

procedure SetCommaText(const Text: String; sl: TStrings; Comma: Char = ';');
var
  i: Integer;

  function ExtractCommaName(s: string; var Pos: Integer): string;
  var
    i: Integer;
  begin
    i := Pos;
    while (i <= Length(s)) and (s[i] <> Comma) do Inc(i);
    Result := Copy(s, Pos, i - Pos);
    if (i <= Length(s)) and (s[i] = Comma) then Inc(i);
    Pos := i;
  end;

begin
  i := 1;
  sl.Clear;
  while i <= Length(Text) do
    sl.Add(ExtractCommaName(Text, i));
end;

function NormalDir(const DirName: string): string;
begin
  Result := DirName;
  if (Result <> '') and
{$IFDEF Delphi12}
    not (CharInSet(Result[Length(Result)], [WideChar(':'), WideChar('\')])) then
{$ELSE}
    not (Result[Length(Result)] in [':', '\']) then
{$ENDIF}
  begin
{$IFDEF Delphi12}
    if (Length(Result) = 1) and (CharInSet(UpCase(Result[1]),  [WideChar('A') .. WideChar('Z')])) then
{$ELSE}
    if (Length(Result) = 1) and (UpCase(Result[1]) in ['A'..'Z']) then
{$ENDIF}
      Result := Result + ':\'
    else Result := Result + '\';
  end;
end;

procedure CopyFile(const fFrom, fTo: String);
var
  fsFrom, fsTo: TFileStream;
begin
  try
  fsFrom := TFileStream.Create(fFrom, fmOpenRead);
  fsTo := TFileStream.Create(fTo, fmCreate);
  fsTo.CopyFrom(fsFrom, 0);
  fsTo.Free;
  fsFrom.Free;
  except
  end;
end;

procedure CopyFiles(const sFrom, sTo, sNames, sExcept: String; const Recursive: Boolean);
var
  SRec: TSearchRec;
  i: Integer;
  dirName: String;
begin
  CopyFilesF(sFrom, sTo, sNames, sExcept);
  if Recursive then
  begin
    i := FindFirst(NormalDir(sFrom) + '*.*', faArchive + faDirectory, SRec);
    while i = 0 do
    begin
      if (SRec.Name <> '.') and (SRec.Name <> '..') then
      begin
        if (SRec.Attr and faDirectory) > 0 then
        begin
          try
            dirName := NormalDir(sTo) + SRec.Name;
            if not DirectoryExists(dirName) then
              MkDir(dirName);
          except
          end;
          CopyFiles(NormalDir(sFrom) + SRec.Name, NormalDir(sTo) + SRec.Name, sNames, sExcept, Recursive);
        end;
      end;
      i := FindNext(SRec);
    end;
    FindClose(SRec);
  end;
end;

procedure CopyFilesF(const sFrom, sTo, sNames, sExcept: String);
var
  i: Integer;
  lNames, lExcept, ExceptList: TStringList;

  procedure MakeExceptList(const ext: String);
  var
    sr: TSearchRec;
  begin
    if FindFirst(NormalDir(sFrom) + ext, faReadOnly + faArchive, sr) = 0 then
    begin
      repeat
        ExceptList.Add(sr.Name);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;

  procedure CopyOneExt(const ext: String);
  var
    sr: TSearchRec;
  begin
    if FindFirst(NormalDir(sFrom) + ext, faReadOnly + faArchive, sr) = 0 then
    begin
      repeat
        if ExceptList.IndexOf(sr.Name) = -1 then
          CopyFile(NormalDir(sFrom) + sr.Name, NormalDir(sTo) + sr.Name);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;

begin
  lNames := TStringList.Create;
  lExcept := TStringList.Create;
  ExceptList := TStringList.Create;
  SetCommaText(Trim(sNames), lNames, ' ');
  SetCommaText(Trim(sExcept), lExcept, ' ');

  for i := 0 to lExcept.Count - 1 do
    MakeExceptList(lExcept[i]);
  for i := 0 to lNames.Count - 1 do
    CopyOneExt(lNames[i]);

  lNames.Free;
  lExcept.Free;
  ExceptList.Free;
end;



end.
