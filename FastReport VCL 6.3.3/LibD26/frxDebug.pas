
{******************************************}
{                                          }
{             FastReport v5.0              }
{               Debug Module               }
{                                          }
{         Copyright (c) 1998-2014          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxDebug;

interface

uses
  frxXML, frxExportMatrix, MemInfo;

{ Profiling routines }

function DbgTimerCreate(Name: string): Integer;
procedure DbgTimerStart(TimerId: Integer);
procedure DbgTimerStop(TimerId: Integer);
function DbgTimerValue(TimerId: Integer): Cardinal;
procedure DbgTimerReset(TimerId: Integer);
function DbgTimerInfo(MainTimerId: Integer): string;

{ Replaces invisible characters with hex-codes. Examples:

  abc def       abc<20>def
  abcdef        abcdef
                <empty>
  abc<20><def   abc<3c>20<3e>def }

function DbgStr(s: string): string;

{ Dumping routines.

  Dumps are a list of XML documents that are created dynamically
  during runtime and are saved at the shutdown. Each XML document
  is associated with a file where it will be saved and a unique id.

  - DbgDumpGet
      Returns an existing or creates a new dump.

  - DbgDump
      Adds to a specified dump a new XML node with information
      about a passed object.

  - DbgDumpSave
      Saves a specified dump to to the associated file.

  - DbgDumpSaveAll
      Saves all dumps. }

type

  TDbgDumpId = LongInt;

  TDbgDump = class
  public

    Id:   TDbgDumpId;
    Path: string;
    Doc:  TfrxXMLDocument;

    constructor Create(Id: TDbgDumpId);
    destructor Destroy; override;

  end;

function DbgDumpGet(Id: TDbgDumpId): TDbgDump;
procedure DbgDump(Obj: TObject; Id: TDbgDumpId);
procedure DbgDumpObj(Obj: TObject; Node: TfrxXMLItem);
procedure DbgDumpSave(Id: TDbgDumpId);
procedure DbgDumpSaveAll;
procedure DbgDumpToFile(const s: AnsiString; const FileName: string);

{ This routine prints a text to a global file.
  This routine can be used by a few threads.
  Avoid calling this routine because it's very slow. }

procedure DbgPrint(const Fmt: string; const Args: array of const); overload
procedure DbgPrint(const s: AnsiString); overload
procedure DbgPrint(const s: string); overload
procedure DbgPrintln(const Fmt: string; const Args: array of const); overload
procedure DbgPrintln(const s: AnsiString); overload
procedure DbgPrintln(const s: string = ''); overload
procedure DbgPrintTitle(const s: string); overload;
procedure DbgPrintTitle(const Fmt: string; const Args: array of const); overload;
procedure DbgPrintMatrix(m: TfrxIEMatrix; RowFirst, RowLast: Integer);
procedure DbgPrintMatrixObjects(m: TfrxIEMatrix);

{ Writes data from internal buffers to the disk file }

procedure DbgPrintFlush;

{ Logging features. }

type
  TDbgListener = procedure(s: string);

procedure DbgLog(s: string); overload;
procedure DbgLog(Fmt: string; Args: array of const); overload;

procedure DbgAddListener(p: TDbgListener);

{ Memory info }

function DbgGetMemInfo: PROCESS_MEMORY_COUNTERS_EX;

implementation

uses
  Windows, Classes, SysUtils,
  frxCrypto, frxClass,
  frxStorage;

type
  TTimer = record
    Value:  Cardinal;
    Start:  Cardinal;
    Name:   string;
  end;

const
  DbgLogFilePath = 'dbgprint.log';

var
  Timers: array of TTimer;
  DumpList: TObjList; // List of TDbgDump
  CsDbgPrint: TRTLCriticalSection;
  FsDbgPrint: TFileStream;
  DbgListeners: array of TDbgListener;

{ Timer routines }

function DbgTimerCreate(Name: string): Integer;
begin
  Result := Length(Timers);
  SetLength(Timers, Length(Timers) + 1);
  ZeroMemory(@Timers[Result], SizeOf(TTimer));
  Timers[Result].Name := Name;
end;

function DbgTimerInfo(MainTimerId: Integer): string;
var
  i, n: Integer;
  Total: Cardinal;
  s: string;
begin
  if Length(Timers) = 0 then
  begin
    Result := 'No timers';
    Exit;
  end;

  Total := DbgTimerValue(MainTimerId);

  for i := 0 to High(Timers) do
    with Timers[i] do
    begin
      if Name = '' then
        s := 'Timer #' + IntToStr(i)
      else
        s := Name;

      if Total = 0 then
        n := 100
      else
        n := 100 * Value div Total;

      Result := Result + #10 + Format('%20s: %6d ms (%d%%)', [s, Value, n]);
    end;
end;

procedure DbgTimerStart(TimerId: Integer);
begin
  Timers[TimerId].Start := GetTickCount
end;

procedure DbgTimerStop(TimerId: Integer);
begin
  with Timers[TimerId] do
    Inc(Value, GetTickCount - Start)
end;

function DbgTimerValue(TimerId: Integer): Cardinal;
begin
  Result := Timers[TimerId].Value
end;

procedure DbgTimerReset(TimerId: Integer);
begin
  Timers[TimerId].Value := 0
end;

{ TDbgDump }

constructor TDbgDump.Create(Id: TDbgDumpId);
begin
  Self.Id := Id;
  Doc := TfrxXMLDocument.Create;
  Doc.Root.Name := 'Root';
  Path := Format('%d.dump.xml', [Id]);
end;

destructor TDbgDump.Destroy;
begin
  Doc.Destroy;
end;

{ Dump routines }

function DbgDumpGet(Id: TDbgDumpId): TDbgDump;
var
  i: LongInt;
begin
  for i := 0 to DumpList.Count - 1 do
  begin
    Result := TDbgDump(DumpList[i]);
    if (Result <> nil) and (Result.Id = Id) then Exit;
  end;

  Result := TDbgDump.Create(Id);
  DumpList.Add(Result);
end;

procedure DumpMatrix(Matrix: TfrxIEMatrix; Node: TfrxXMLItem);
var
  i, j: LongInt;
  Obj: TfrxIEMObject;
begin
  with Node do
  begin
    Prop['Columns'] := Format('%d', [Matrix.Width]);
    Prop['Rows'] := Format('%d', [Matrix.Height]);

    with Add do
    begin
      Name := 'XPos';
      for i := 0 to Matrix.Width - 1 do
        Prop[Format('Col%d', [i])] := Format('%f', [Matrix.GetXPosById(i)]);
    end;

    with Add do
    begin
      Name := 'YPos';
      for i := 0 to Matrix.Height - 1 do
        Prop[Format('Row%d', [i])] := Format('%f', [Matrix.GetYPosById(i)]);
    end;

    with Add do
    begin
      Name := 'ObjectsList';
      for i := 0 to Matrix.GetObjectsCount - 1 do
        DbgDumpObj(Matrix.GetObjectById(i), Add);
    end;

    with Add do
    begin
      Name := 'ObjectsMatrix';
      with Matrix do
      begin
        for i := 0 to Height - 1 do
          for j := 0 to Width - 1 do
          begin
            Obj := GetObject(i, j);
            if Obj = nil then Continue;
            Obj.Counter := 0;
          end;

        for i := 0 to Height - 1 do
          for j := 0 to Width - 1 do
          begin
            Obj := GetObject(i, j);
            if (Obj = nil) or (Obj.Counter <> 0) then Continue;
            Obj.Counter := 1;
            DbgDumpObj(Obj, Add);
          end;
      end;
    end;
  end;
end;

procedure DumpReportPage(Page: TfrxReportPage; Node: TfrxXMLItem);
begin
  with Node do
  begin
    Prop['PaperWidth'] := Format('%f mm', [Page.PaperWidth]);
    Prop['PaperHeight'] := Format('%f mm', [Page.PaperHeight]);

    with Add do
    begin
      Name := 'Margins';
      Prop['Left'] := Format('%f mm', [Page.LeftMargin]);
      Prop['Top'] := Format('%f mm', [Page.TopMargin]);
      Prop['Right'] := Format('%f mm', [Page.RightMargin]);
      Prop['Bottom'] := Format('%f mm', [Page.BottomMargin]);
    end;
  end;
end;

function BoolToStr(b: Boolean): string;
begin
  if b then
    Result := 'Yes'
  else
    Result := 'No'
end;

procedure DumpIEMObject(Obj: TfrxIEMObject; Node: TfrxXMLItem);
begin
  with Node do
  begin
    Prop['Metafile'] := BoolToStr(Obj.Metafile <> nil);
    Prop['Image'] := BoolToStr(Obj.Image <> nil);
    Prop['Text']    := Obj.Memo.Text;
  end;
end;

procedure DbgDumpObj(Obj: TObject; Node: TfrxXMLItem);
begin
  Node.Name := Obj.ClassName;

  if Obj is TfrxIEMatrix then
    DumpMatrix(Obj as TfrxIEMatrix, Node)
  else if Obj is TfrxReportPage then
    DumpReportPage(Obj as TfrxReportPage, Node)
  else if Obj is TfrxIEMObject then
    DumpIEMObject(Obj as TfrxIEMObject, Node);
end;

procedure DbgDump(Obj: TObject; Id: TDbgDumpId);
var
  d: TDbgDump;
begin
  d := DbgDumpGet(Id);
  if d = nil then
    raise Exception.CreateFmt('Dump %d does not exist', [Id]);

  DbgDumpObj(Obj, d.Doc.Root.Add);
end;

procedure DbgDumpSave(Id: TDbgDumpId);
var
  d: TDbgDump;
  s: TFileStream;
begin
  d := DbgDumpGet(Id);
  if d = nil then
    raise Exception.CreateFmt('Dump %d does not exist', [Id]);

  s := TFileStream.Create(d.Path, fmCreate); // Let it raise exceptions
  d.Doc.AutoIndent := True;
  d.Doc.SaveToStream(s);
  s.Destroy;
end;

procedure DbgDumpSaveAll;
var
  i: LongInt;
  d: TDbgDump;
begin
  for i := 0 to DumpList.Count - 1 do
  begin
    d := TDbgDump(DumpList[i]);
    if d <> nil then
      try
        DbgDumpSave(d.Id);
      finally
      end;
  end;
end;

procedure DbgDumpToFile(const s: AnsiString; const FileName: string);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmCreate);

  if s <> '' then
    f.Write(s[1], Length(s));

  f.Free;
end;

{ DbgPrint }

procedure DbgPrint(const s: AnsiString);
begin
  if (s = '') or (FsDbgPrint = nil) then
    Exit;

  EnterCriticalSection(CsDbgPrint);
  FsDbgPrint.Write(s[1], Length(s));
  LeaveCriticalSection(CsDbgPrint);
end;

procedure DbgPrint(const Fmt: string; const Args: array of const);
begin
  DbgPrint(AnsiString(Format(Fmt, Args)));
end;

procedure DbgPrintln(const s: string);
begin
  DbgPrintln(AnsiString(s))
end;

procedure DbgPrint(const s: string);
begin
  DbgPrint(AnsiString(s))
end;

procedure DbgPrintln(const Fmt: string; const Args: array of const);
begin
  DbgPrint(Fmt, Args);
  DbgPrint(#10);
end;

procedure DbgPrintln(const s: AnsiString);
begin
  Dbgprint(s);
  DbgPrint(#10);
end;

procedure DbgPrintTitle(const s: string);
begin
  DbgPrint(#10#10'--- %s ---'#10#10, [s])
end;

procedure DbgPrintTitle(const Fmt: string; const Args: array of const);
begin
  DbgPrintTitle(Format(Fmt, Args))
end;

procedure DbgPrintFlush;
begin
  if FsDbgPrint <> nil then
    FlushFileBuffers(FsDbgPrint.Handle);
end;

procedure DbgPrintMatrix(m: TfrxIEMatrix; RowFirst, RowLast: Integer);
var
  r, c: Integer;
  s: string;
begin
  DbgPrint(#10#10'--- rows %d-%d ---'#10#10, [RowFirst, RowLast]);

  for r := RowFirst to RowLast do
  begin
    s := '';

    for c := 0 to m.Width - 1 do
      if m.GetCell(c, r) = -1 then
        s := s + '     •'
      else
        s := s + Format('%6d', [m.GetCell(c, r)]);

    DbgPrint(AnsiString(s));
    DbgPrint(#10);
  end;
end;

procedure DbgPrintMatrixObjects(m: TfrxIEMatrix);
var
  i: Integer;
  Obj: TfrxIEMObject;
begin
  DbgPrint(#10#10'--- %d objects ---'#10#10, [m.GetObjectsCount]);

  for i := 0 to m.GetObjectsCount do
  begin
    Obj := m.GetObjectById(i);

    if Obj = nil then
      DbgPrint('%6d'#10, [i])
    else
    begin
      DbgPrint('%6d %s'#10, [i, Obj.Name]);
    end;
  end;
end;

{ Logging features. }

procedure DbgLog(s: string);
var
  i: Integer;
begin
  for i := 0 to Length(DbgListeners) - 1 do
    DbgListeners[i](s);
end;

procedure DbgLog(Fmt: string; Args: array of const);
begin
  DbgLog(Format(Fmt, Args))
end;

procedure DbgAddListener(p: TDbgListener);
begin
  SetLength(DbgListeners, Length(DbgListeners) + 1);
  DbgListeners[Length(DbgListeners) - 1] := p;
end;

{ String features. }

function DbgStr(s: string): string;

  function Hex(x: Byte): string;
  const
    d: string = '0123456789abcdef';
  begin
    Result := '<' + d[1 + x div 16] + d[1 + x mod 16] + '>';
  end;

var
  i: Integer;
begin
  Result := '';

  for i := 1 to Length(s) do
    if (Ord(s[i]) < 33) or (s[i] = '<') or (s[i] = '>') then
      Result := Result + Hex(Ord(s[i]))
    else
      Result := Result + s[i];

  if Result = '' then
    Result := '<empty>';
end;

{ Memory info }

function DbgGetMemInfo: PROCESS_MEMORY_COUNTERS_EX;
begin
  Result := GetMemInfo
end;

initialization

DumpList := TObjList.Create;
InitializeCriticalSection(CsDbgPrint);

try
  if FileExists(DbgLogFilePath) then
    FsDbgPrint := TFileStream.Create(DbgLogFilePath, fmOpenWrite or fmShareDenyWrite)
  else
    FsDbgPrint := TFileStream.Create(DbgLogFilePath, fmCreate or fmShareDenyWrite);

  FsDbgPrint.Seek(0, soEnd);
except
  FsDbgPrint := nil;
end;

DbgPrint(#10#10'=== Session started at %s ==='#10#10, [DateTimeToStr(Now)]);

finalization

DbgDumpSaveAll;
DumpList.Free;

DbgPrint(#10#10'=== Session finished at %s ==='#10#10, [DateTimeToStr(Now)]);
DeleteCriticalSection(CsDbgPrint);
FsDbgPrint.Free;

end.
