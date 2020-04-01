
{******************************************}
{                                          }
{             FastReport v6.0              }
{        ERSI Shape File DBF Import        }
{                                          }
{        Copyright (c) 2015 - 2019         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxERSIShapeDBFImport;

interface

{$I frx.inc}

uses
  Classes, SysUtils
{$IFDEF Delphi12}
, AnsiStrings
{$ENDIF}
  ;

type
  // http://www.clicketyclick.dk/databases/xbase/format/dbf.html#DBF_NOTE_1_TARGET
  TERSIDBFFileHeader = packed record
    Signature: Byte; // Version number
    YY, MM, DD: Byte; // Date of last update
    NumberOfRecords: LongWord;
    LengthOfHeaderStructure: Word; // = 32
    LengthOfEachRecord: Word; // = Sum of lengths of all fields + 1 (deletion flag)
    Reserved0: Word;
    IncompleteTransaction: Byte;
    EncryptionFlag: Byte;
    FreeRecordThread: LongWord;
    ReservedForMultiUser: array[0..7] of Byte;
    MDXFlag: byte;
    LanguageDriver: byte; // ==> CodePage
    Reserved1: Word;
  end;

  TERSIDBFFieldDescriptor = packed record
    FieldName: array[0..10] of AnsiChar; //  in ASCII (terminated by 00h)
    FieldType: AnsiChar;
    Reserved0: LongWord;
    FieldLength: Byte;
    DecimalCount: Byte; // <= 15
    Reserved1: array[0..12] of Byte;
    IndexFieldFlag: Byte;
  end;

  TDBFFieldType = (dfUnhandled, dfChar, dfDate, dfNumeric, dfLogical);

  TAnsiCharSet = set of AnsiChar;

  TERSIDBFFileColumn = class
  private
    FFieldName: AnsiString;
    FFieldType: TDBFFieldType;
    FFieldLength: Byte;
    FData: array of AnsiString;
    function GetData(iRecord: integer): AnsiString;
  protected
    FBuffer: array of AnsiChar;
    function BufferToAnsiString(TrimLeft, TrimRight: TAnsiCharSet): AnsiString;
  public
    constructor Create(Stream: TStream; NumberOfRecords: LongWord);
    procedure Read(Stream: TStream; CurrentRecord: integer);

    property FieldName: AnsiString read FFieldName;
    property FieldType: TDBFFieldType read FFieldType;
    property FieldLength: Byte read FFieldLength;
    property Data[iRecord: integer]: AnsiString read GetData;
  end;

  TERSIDBFFile = class
  private
    function GetCodePage: integer;
    function GetLegend(FieldName: AnsiString; iRecord: Integer): AnsiString;
    function GetLegendByColumn(iColumn, iRecord: Integer): AnsiString;
  protected
    FDBFFileHeader: TERSIDBFFileHeader;
    FColumns: array of TERSIDBFFileColumn;
    FCPG: string;

    procedure ReadFromStream(Stream: TStream; RecordCount: integer);
  public
    constructor Create(const FileName: string; RecordCount: integer);
    destructor Destroy; override;
    procedure GetColumnList(List: TStrings);
    function IsUTF8: boolean;

    property CodePage: integer read GetCodePage;
    property Legend[FieldName: AnsiString; iRecord: Integer]: AnsiString read GetLegend;
    property LegendByColumn[iColumn, iRecord: Integer]: AnsiString read GetLegendByColumn;
  end;

implementation

uses
{$IFNDEF FPC}
  Windows
{$ELSE}
  LCLType, LCLIntf, LCLProc
{$ENDIF};

{ TERSIDBFFile }

constructor TERSIDBFFile.Create(const FileName: string; RecordCount: integer);
var
  Stream: TFileStream;
  Mode: Word;
  CPGFileName: string;
  CPGFile: TextFile;
begin
  CPGFileName := ChangeFileExt(FileName, '.cpg');
  if FileExists(CPGFileName) then
  begin
    AssignFile(CPGFile, CPGFileName);
    try
      Reset(CPGFile);
      ReadLn(CPGFile, FCPG);
      FCPG := UpperCase(FCPG);
    finally
      CloseFile(CPGFile);
    end;
  end;

  Mode := fmOpenRead or fmShareDenyWrite;
  Stream := TFileStream.Create(FileName, Mode);
  try
    ReadFromStream(Stream, RecordCount);
  finally
    Stream.Free;
  end;
end;

destructor TERSIDBFFile.Destroy;
var
  Column: integer;
begin
  for Column := 0 to High(FColumns) do
    FColumns[Column].Free;
  inherited;
end;

function TERSIDBFFile.GetCodePage: integer;
begin
  case FDBFFileHeader.LanguageDriver of
    1, 9, 11, 13, 15, 17, 21, 24, 25, 27:
      Result := 437;
    2, 10, 14, 16, 18, 20, 22, 26, 29, 37, 55:
      Result := 850;
    3, 88, 89:
      Result := 1252;
    4:
      Result := 10000;
    8, 23, 102:
      Result := 865;
    19, 123:
      Result := 932;
    28:
      Result := 863;
    36:
      Result := 860;
    38, 101:
      Result := 866;
    64, 100, 135:
      Result := 852;
    77, 122:
      Result := 936;
    78, 121:
      Result := 949;
    79, 120:
      Result := 950;
    80, 124:
      Result := 874;
    87:
      Result := 0;
    103:
      Result := 861;
    104:
      Result := 895;
    105:
      Result := 620;
    106, 134:
      Result := 737;
    107:
      Result := 857;
    108:
      Result := 863;
    136:
      Result := 857;
    150:
      Result := 10007;
    151:
      Result := 10029;
    152:
      Result := 10006;
    200:
      Result := 1250;
    201:
      Result := 1252;
    202:
      Result := 1254;
    203:
      Result := 1253;
    204:
      Result := 1257;
  else
    Result := 0;
  end;
end;

procedure TERSIDBFFile.GetColumnList(List: TStrings);
var
  i: integer;
begin
  for i := 0 to High(FColumns) do
    List.Add(String(FColumns[i].FFieldName));
end;

function TERSIDBFFile.GetLegend(FieldName: AnsiString; iRecord: Integer): AnsiString;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High(FColumns) do
    if AnsiSameText(FColumns[i].FieldName, FieldName) then
      Result := FColumns[i].Data[iRecord];
end;

function TERSIDBFFile.GetLegendByColumn(iColumn, iRecord: Integer): AnsiString;
begin
  Result := FColumns[iColumn].Data[iRecord];
end;

function TERSIDBFFile.IsUTF8: boolean;
begin
  Result := FCPG = 'UTF-8';
end;

procedure TERSIDBFFile.ReadFromStream(Stream: TStream; RecordCount: integer);
  function NextByte: Byte;
  begin
    Stream.Read(Result, SizeOf(Result));
  end;

  function IsNewField: Boolean;
  begin
    Result := NextByte <> $0D; // FieldTerminator
    if Result then
      Stream.Position := Stream.Position - SizeOf(Byte);
  end;

  function IsRecordDeleted: boolean;
  begin
    Result := NextByte = $2A; // RecordDeletedFlag
  end;

  function IsEndOfFile: boolean;
  begin
    Result := NextByte = $1A; // EndOfFile
    if not Result then
      Stream.Position := Stream.Position - SizeOf(Byte);
  end;
var
  CurrentRecord, CurrenColumn: integer;
begin
  Stream.Read(FDBFFileHeader, SizeOf(FDBFFileHeader));

  SetLength(FColumns, 0);
  while IsNewField do
  begin
    SetLength(FColumns, Length(FColumns) + 1);
    FColumns[High(FColumns)] := TERSIDBFFileColumn.Create(Stream, RecordCount);
  end;

  CurrentRecord := 0;
  while (Stream.Position < Stream.Size) and not IsEndOfFile do
    if IsRecordDeleted then
      Stream.Position := Stream.Position + FDBFFileHeader.LengthOfEachRecord - SizeOf(Byte)
    else
    begin
      for CurrenColumn := 0 to High(FColumns) do
        FColumns[CurrenColumn].Read(Stream, CurrentRecord);
      Inc(CurrentRecord);
      if CurrentRecord > RecordCount - 1 then
        Break;
    end;
end;

{ TERSIDBFFileColumn }

function TERSIDBFFileColumn.BufferToAnsiString(TrimLeft, TrimRight: TAnsiCharSet): AnsiString;
var
  Left, Right, ResultLength: integer;
begin
  Left := 0;
  while (Left <= High(FBuffer)) and
        (FBuffer[Left] in TrimLeft) do
    Inc(Left);

  Right := High(FBuffer);
  while (Right >= 0) and
        (FBuffer[Right] in TrimRight) do
    Dec(Right);

  ResultLength := Right - Left + 1;
  if ResultLength <= 0 then
    Result := ''
  else
  begin
    SetLength(Result, ResultLength);
    Move(FBuffer[Left], Result[1], ResultLength * SizeOf(FBuffer[0]));
  end;
end;

constructor TERSIDBFFileColumn.Create(Stream: TStream; NumberOfRecords: LongWord);
var
  i: integer;
  FieldDescriptor: TERSIDBFFieldDescriptor;
begin
  Stream.Read(FieldDescriptor, SizeOf(FieldDescriptor));

  FFieldName := '';
  for i := 0 to 10 do
    if FieldDescriptor.FieldName[i] <> #0 then
      FFieldName := FFieldName + FieldDescriptor.FieldName[i]
    else
      Break;

  case FieldDescriptor.FieldType of
    'C': FFieldType := dfChar;
    'D': FFieldType := dfDate;
    'N': FFieldType := dfNumeric;
    'L': FFieldType := dfLogical;
  else
    FFieldType := dfUnhandled;
  end;

  FFieldLength := FieldDescriptor.FieldLength;
  SetLength(FBuffer, FFieldLength);

  SetLength(FData, NumberOfRecords);
end;

function TERSIDBFFileColumn.GetData(iRecord: integer): AnsiString;
begin
  Result := FData[iRecord];
end;

procedure TERSIDBFFileColumn.Read(Stream: TStream; CurrentRecord: integer);
begin
  Stream.Read(FBuffer[0], Length(FBuffer) * SizeOf(FBuffer[0]));
  case FFieldType of
    dfChar:
      FData[CurrentRecord] := BufferToAnsiString([], [#0, ' ']);
    dfDate:
      FData[CurrentRecord] := FBuffer[6] + FBuffer[7] +'.' +
                              FBuffer[4] + FBuffer[5] +'.' +
        FBuffer[0] + FBuffer[1] +'.' + FBuffer[2] + FBuffer[3];
    dfNumeric:
      FData[CurrentRecord] := BufferToAnsiString([' '], [#0, ' ']);
    dfLogical:
      case FBuffer[0] of
        'T', 't', 'Y', 'y': FData[CurrentRecord] := 'True';
        'F', 'f', 'N', 'n': FData[CurrentRecord] := 'False';
      else                  FData[CurrentRecord] := '';
      end;
  else // dfUnhandled
    FData[CurrentRecord] := '';
  end;
end;

end.
