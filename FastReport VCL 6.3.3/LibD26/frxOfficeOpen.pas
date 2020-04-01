
{******************************************}
{                                          }
{             FastReport v5.0              }
{    Utilities for Office Open exports     }
{                                          }
{         Copyright (c) 1998-2010          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxOfficeOpen;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  Types, LCLType, LCLIntf, LCLProc, LazHelper, DateUtils,
  LazFileUtils, FileUtil,
{$ENDIF}
  Classes, SysUtils, Graphics, frxClass;

type
  TfrxStrList = class(TStringList)
  public
    function AddObject(const s: string; Obj: TObject): Integer; override;
  end;

  TfrxWriter = class
  private
    FStream: TStream;
    FOwn: Boolean;
  public
    constructor Create(Stream: TStream; Own: Boolean = False);
    destructor Destroy; override;
    procedure Write(s: string; UCS: Boolean = False); overload;
    procedure Write(const a: array of string; UCS: Boolean = False); overload;
    procedure Write(const Section: string; StrList: TStrings); overload;
    procedure Write(const Fmt: string; const f: array of const); overload;
  end;

  TfrxFileWriter = class(TfrxWriter)
  public
    constructor Create(FileName: string); overload;
  end;

  TfrxMap = record
    FirstRow: Integer;
    LastRow: Integer;
    Margins: TfrxRect;
    PaperSize: Integer;
    PageOrientation: Integer;
    Index: Integer;
  end;

procedure WriteStr(Stream: TStream; const s: string; UCS: Boolean = False);
procedure WriteStrList(Stream: TStream; const Section: string; StrList: TStrings);
procedure CreateDirs(aSaveFilter: TfrxCustomIOTransport; const SubDirs: array of string);
function Escape(s: WideString): WideString;
function Distance(c1, c2: Integer): Integer; // 0..1024
function RGBSwap(c: TColor): TColor; // c &= 0xffffff, xchg(c.r, c.b)
function CleanTrash(const s: WideString): WideString;
procedure Exchange(var a, b: Integer);
{$IFNDEF FPC}
function DateTimeToUTC(DateTime: TDateTime): TDateTime;
{$ENDIF}

implementation

{$R frxOfficeOpen.res}

procedure Exchange(var a, b: Integer);
begin
  a := a xor b;
  b := b xor a;
  a := a xor b;
end;

function CleanTrash(const s: WideString): WideString;
begin
  if (Length(s) > 1) and (Copy(s, Length(s) - 1, 2) = #13#10) then
    Result := Copy(s, 1, Length(s) - 2)
  else
    Result := s;
end;

function RGBSwap(c: TColor): TColor;
var
  rgb: array[0..2] of Byte;
  i: Integer;
begin
  if c < 0 then
    c := GetSysColor(c and $000000FF);
  for i := 0 to 2 do
  begin
    rgb[i] := c and $ff;
    c := c shr 8;
  end;

  Result := 0;

  for i := 0 to 2 do
    Result := Result*256 + rgb[i];
end;

function Distance(c1, c2: Integer): Integer;
var
  i: Integer;
begin
  c1 := c1 xor c2;
  Result := 0;

  for i := 0 to 3 do
  begin
    Inc(Result, c1 and $ff);
    c1 := c1 shr 8;
  end;
end;

function Escape(s: WideString): WideString;
begin
  s := StringReplace(s, '&', '&amp;', [rfReplaceAll]);
  s := StringReplace(s, '"', '&quot;', [rfReplaceAll]);
  s := StringReplace(s, '<', '&lt;', [rfReplaceAll]);
  s := StringReplace(s, '>', '&gt;', [rfReplaceAll]);

  Result := s;
end;

procedure CreateDirs(aSaveFilter: TfrxCustomIOTransport; const SubDirs: array of string);
var
  i: Integer;
begin
  for i := Low(SubDirs) to High(SubDirs) do
    aSaveFilter.CreateContainer(SubDirs[i]);
end;

procedure WriteStr(Stream: TStream; const s: string; UCS: Boolean);
var
  r: AnsiString;
begin
  if s = '' then
    Exit;

  if UCS then
  begin
    r := UTF8Encode(s);
    Stream.Write(r[1], Length(r))
  end
  else
    Stream.Write(AnsiString(s)[1], Length(s));
end;

procedure WriteStrList(Stream: TStream; const Section: string; StrList: TStrings);
begin
  WriteStr(Stream, Format('<%s count="%d">', [Section, StrList.Count]));
  StrList.SaveToStream(Stream{$IFDEF Delphi12}, TEncoding.UTF8{$ENDIF});
  WriteStr(Stream, Format('</%s>', [Section]));
end;

{$IFNDEF FPC}
function DateTimeToUTC(DateTime: TDateTime): TDateTime;
var SystemTime, LocalSystemTime: TSystemTime;
    FileTime, LocalFileTime: TFileTime;
begin
    DateTimeToSystemTime(DateTime, SystemTime);
    SystemTimeToFileTime(SystemTime, LocalFileTime);
    LocalFileTimeToFileTime(LocalFileTime, FileTime);
    FileTimeToSystemTime(FileTime, LocalSystemTime);
    Result := SystemTimeToDateTime(LocalSystemTime);
end;
{$ENDIF}

{ TfrxWriter }

constructor TfrxWriter.Create(Stream: TStream; Own: Boolean);
begin
  FStream := Stream;
  FOwn := Own;
end;

destructor TfrxWriter.Destroy;
begin
  if FOwn then FStream.Destroy;
end;

procedure TfrxWriter.Write(s: string; UCS: Boolean);
begin
  WriteStr(FStream, s, UCS);
end;

procedure TfrxWriter.Write(const a: array of string; UCS: Boolean);
var
  i: Integer;
begin
  for i := Low(a) to High(a) do
    Write(a[i], UCS);
end;

procedure TfrxWriter.Write(const Section: string; StrList: TStrings);
begin
  WriteStrList(FStream, Section, StrList);
end;

procedure TfrxWriter.Write(const Fmt: string; const f: array of const);
begin
  Write(Format(Fmt, f));
end;

{ TfrxFileWriter }

constructor TfrxFileWriter.Create(FileName: string);
begin
  inherited Create(TFileStream.Create(FileName, fmCreate), True);
end;


{ TfrxStrList }

function TfrxStrList.AddObject(const s: string; Obj: TObject): Integer;
begin
  if Find(s, Result) then Exit;
  Result := Count;
  InsertItem(Count, s, Obj);
end;

end.
