
{******************************************}
{                                          }
{             FastReport v5.0              }
{         ZIP archiver support unit        }
{                                          }
{         Copyright (c) 2006-2008          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxZip;

{$I frx.inc}

interface

uses Classes,
{$IFNDEF NONWINFPC}
  Windows,
{$ELSE}
{$DEFINE STATIC_EXPORTING_RESULTS}
  LCLType, LCLIntf, LCLProc, Types, FileUtil,
{$ENDIF}
{$IFDEF DELPHI16}
  ZLib,
{$ELSE}
  frxZLib,
{$ENDIF}
  frxGZip, frxUtils, frxFileUtils;

type
  TfrxZipLocalFileHeader = class;
  TfrxZipCentralDirectory = class;
  TfrxZipFileHeader = class;

  TfrxZipArchive = class(TObject)
  private
  {$IFDEF Delphi12}
    FRootFolder: AnsiString;
  {$ELSE}
    FRootFolder: String;
  {$ENDIF}
    FErrors: TStringList;
    FFileList: TStringList;
  {$IFDEF Delphi12}
    FComment: AnsiString;
  {$ELSE}
    FComment: AnsiString;
  {$ENDIF}
    FProgress: TNotifyEvent;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
  {$IFDEF Delphi12}
    procedure AddFile(const FileName: AnsiString);
    procedure AddDir(const DirName: AnsiString);
    procedure SaveToFile(const Filename: AnsiString);
  {$ELSE}
    procedure AddFile(const FileName: String);
    procedure AddDir(const DirName: String);
    procedure SaveToFile(const Filename: String);
  {$ENDIF}
    procedure SaveToStream(const Stream: TStream);
    procedure SaveToStreamFromList(const Stream: TStream; FileStreams: TStrings);
    property Errors: TStringList read FErrors;
  {$IFDEF Delphi12}
    property Comment: AnsiString read FComment write FComment;
    property RootFolder: AnsiString read FRootFolder write FRootFolder;
  {$ELSE}
    property Comment: String read FComment write FComment;
    property RootFolder: String read FRootFolder write FRootFolder;
  {$ENDIF}
    property FileCount: Integer read GetCount;
    property OnProgress: TNotifyEvent read FProgress write FProgress;
  end;

  TfrxZipLocalFileHeader = class(TObject)
  private
    FLocalFileHeaderSignature: Longword;
    FVersion: WORD;
    FGeneralPurpose: WORD;
    FCompressionMethod: WORD;
    FCrc32: Longword;
    FLastModFileDate: WORD;
    FLastModFileTime: WORD;
    FCompressedSize: Longword;
    FUnCompressedSize: Longword;
  {$IFDEF Delphi12}
    FExtraField: AnsiString;
    FFileName: AnsiString;
  {$ELSE}
    FExtraField: String;
    FFileName: String;
  {$ENDIF}
    FFileNameLength: WORD;
    FExtraFieldLength: WORD;
  {$IFDEF Delphi12}
    procedure SetExtraField(const Value: AnsiString);
    procedure SetFileName(const Value: AnsiString);
  {$ELSE}
    procedure SetExtraField(const Value: String);
    procedure SetFileName(const Value: String);
  {$ENDIF}
  public
    constructor Create;
    procedure SaveToStream(const Stream: TStream);
    property LocalFileHeaderSignature: Longword read FLocalFileHeaderSignature;
    property Version: WORD read FVersion write FVersion;
    property GeneralPurpose: WORD read FGeneralPurpose write FGeneralPurpose;
    property CompressionMethod: WORD read FCompressionMethod write FCompressionMethod;
    property LastModFileTime: WORD read FLastModFileTime write FLastModFileTime;
    property LastModFileDate: WORD read FLastModFileDate write FLastModFileDate;
    property Crc32: Longword read FCrc32 write FCrc32;
    property CompressedSize: Longword read FCompressedSize write FCompressedSize;
    property UnCompressedSize: Longword read FUnCompressedSize write FUnCompressedSize;
    property FileNameLength: WORD read FFileNameLength write FFileNameLength;
    property ExtraFieldLength: WORD read FExtraFieldLength write FExtraFieldLength;
  {$IFDEF Delphi12}
    property FileName: AnsiString read FFileName write SetFileName;
    property ExtraField: AnsiString read FExtraField write SetExtraField;
  {$ELSE}
    property FileName: String read FFileName write SetFileName;
    property ExtraField: String read FExtraField write SetExtraField;
  {$ENDIF}
  end;

  TfrxZipCentralDirectory = class(TObject)
  private
    FEndOfChentralDirSignature: Longword;
    FNumberOfTheDisk: WORD;
    FTotalOfEntriesCentralDirOnDisk: WORD;
    FNumberOfTheDiskStartCentralDir: WORD;
    FTotalOfEntriesCentralDir: WORD;
    FSizeOfCentralDir: Longword;
    FOffsetStartingDiskDir: Longword;
  {$IFDEF Delphi12}
    FComment: AnsiString;
  {$ELSE}
    FComment: String;
  {$ENDIF}
    FCommentLength: WORD;
  {$IFDEF Delphi12}
    procedure SetComment(const Value: AnsiString);
  {$ELSE}
    procedure SetComment(const Value: String);
  {$ENDIF}
  public
    constructor Create;
    procedure SaveToStream(const Stream: TStream);
    property EndOfChentralDirSignature: Longword read FEndOfChentralDirSignature;
    property NumberOfTheDisk: WORD read FNumberOfTheDisk write FNumberOfTheDisk;
    property NumberOfTheDiskStartCentralDir: WORD
      read FNumberOfTheDiskStartCentralDir write FNumberOfTheDiskStartCentralDir;
    property TotalOfEntriesCentralDirOnDisk: WORD
      read FTotalOfEntriesCentralDirOnDisk write FTotalOfEntriesCentralDirOnDisk;
    property TotalOfEntriesCentralDir: WORD
      read FTotalOfEntriesCentralDir write FTotalOfEntriesCentralDir;
    property SizeOfCentralDir: Longword read FSizeOfCentralDir write FSizeOfCentralDir;
    property OffsetStartingDiskDir: Longword read FOffsetStartingDiskDir write FOffsetStartingDiskDir;
    property CommentLength: WORD read FCommentLength write FCommentLength;
  {$IFDEF Delphi12}
    property Comment: AnsiString read FComment write SetComment;
  {$ELSE}
    property Comment: String read FComment write SetComment;
  {$ENDIF}
  end;

  TfrxZipFileHeader = class(TObject)
  private
    FCentralFileHeaderSignature: Longword;
    FRelativeOffsetLocalHeader: Longword;
    FUnCompressedSize: Longword;
    FCompressedSize: Longword;
    FCrc32: Longword;
    FExternalFileAttribute: Longword;
  {$IFDEF Delphi12}
    FExtraField: AnsiString;
    FFileComment: AnsiString;
    FFileName: AnsiString;
  {$ELSE}
    FExtraField: String;
    FFileComment: String;
    FFileName: String;
  {$ENDIF}
    FCompressionMethod: WORD;
    FDiskNumberStart: WORD;
    FLastModFileDate: WORD;
    FLastModFileTime: WORD;
    FVersionMadeBy: WORD;
    FGeneralPurpose: WORD;
    FFileNameLength: WORD;
    FInternalFileAttribute: WORD;
    FExtraFieldLength: WORD;
    FVersionNeeded: WORD;
    FFileCommentLength: WORD;
  {$IFDEF Delphi12}
    procedure SetExtraField(const Value: AnsiString);
    procedure SetFileComment(const Value: AnsiString);
    procedure SetFileName(const Value: AnsiString);
  {$ELSE}
    procedure SetExtraField(const Value: String);
    procedure SetFileComment(const Value: String);
    procedure SetFileName(const Value: String);
  {$ENDIF}
  public
    constructor Create;
    procedure SaveToStream(const Stream: TStream);
    property CentralFileHeaderSignature: Longword read FCentralFileHeaderSignature;
    property VersionMadeBy: WORD read FVersionMadeBy;
    property VersionNeeded: WORD read FVersionNeeded;
    property GeneralPurpose: WORD read FGeneralPurpose write FGeneralPurpose;
    property CompressionMethod: WORD read FCompressionMethod write FCompressionMethod;
    property LastModFileTime: WORD read FLastModFileTime write FLastModFileTime;
    property LastModFileDate: WORD read FLastModFileDate write FLastModFileDate;
    property Crc32: Longword read FCrc32 write FCrc32;
    property CompressedSize: Longword read FCompressedSize write FCompressedSize;
    property UnCompressedSize: Longword read FUnCompressedSize write FUnCompressedSize;
    property FileNameLength: WORD read FFileNameLength write FFileNameLength;
    property ExtraFieldLength: WORD read FExtraFieldLength write FExtraFieldLength;
    property FileCommentLength: WORD read FFileCommentLength write FFileCommentLength;
    property DiskNumberStart: WORD read FDiskNumberStart write FDiskNumberStart;
    property InternalFileAttribute: WORD read FInternalFileAttribute write FInternalFileAttribute;
    property ExternalFileAttribute: Longword read FExternalFileAttribute write FExternalFileAttribute;
    property RelativeOffsetLocalHeader: Longword read FRelativeOffsetLocalHeader write FRelativeOffsetLocalHeader;
  {$IFDEF Delphi12}
    property FileName: AnsiString read FFileName write SetFileName;
    property ExtraField: AnsiString read FExtraField write SetExtraField;
    property FileComment: AnsiString read FFileComment write SetFileComment;
  {$ELSE}
    property FileName: String read FFileName write SetFileName;
    property ExtraField: String read FExtraField write SetExtraField;
    property FileComment: String read FFileComment write SetFileComment;
  {$ENDIF}
  end;

  TfrxZipLocalFile = class(TObject)
  private
    FLocalFileHeader: TfrxZipLocalFileHeader;
    FFileData: TMemoryStream;
    FOffset: Longword;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToStream(const Stream: TStream);
    property LocalFileHeader: TfrxZipLocalFileHeader read FLocalFileHeader;
    property FileData: TMemoryStream read FFileData write FFileData;
    property Offset: Longword read FOffset write FOffset;
  end;

implementation

uses SysUtils{$IFDEF Delphi12}, AnsiStrings{$ENDIF};

const
  ZIP_VERSIONMADEBY = 20;
  ZIP_NONE = 0;
  ZIP_DEFLATED = 8;
  ZIP_MINSIZE = 128;

{ TfrxZipLocalFile }

constructor TfrxZipLocalFile.Create;
begin
  FLocalFileHeader := TfrxZipLocalFileHeader.Create;
  FOffset := 0;
end;

destructor TfrxZipLocalFile.Destroy;
begin
  FLocalFileHeader.Free;
  inherited;
end;

procedure TfrxZipLocalFile.SaveToStream(const Stream: TStream);
begin
  FLocalFileHeader.SaveToStream(Stream);
  FFileData.Position := 0;
  FFileData.SaveToStream(Stream);
end;

{ TfrxZipLocalFileHeader }

constructor TfrxZipLocalFileHeader.Create;
begin
  inherited;
  FLocalFileHeaderSignature := $04034b50;
  FVersion := ZIP_VERSIONMADEBY;
  FGeneralPurpose := 0;
  FCompressionMethod := ZIP_NONE;
  FCrc32 := 0;
  FLastModFileDate := 0;
  FLastModFileTime := 0;
  FCompressedSize := 0;
  FUnCompressedSize := 0;
  FExtraField := '';
  FFileName := '';
  FFileNameLength := 0;
  FExtraFieldLength := 0;
end;

procedure TfrxZipLocalFileHeader.SaveToStream(const Stream: TStream);
begin
  Stream.Write(FLocalFileHeaderSignature, 4);
  Stream.Write(FVersion, 2);
  Stream.Write(FGeneralPurpose, 2);
  Stream.Write(FCompressionMethod, 2);
  Stream.Write(FLastModFileTime, 2);
  Stream.Write(FLastModFileDate, 2);
  Stream.Write(FCrc32, 4);
  Stream.Write(FCompressedSize, 4);
  Stream.Write(FUnCompressedSize, 4);
  Stream.Write(FFileNameLength, 2);
  Stream.Write(FExtraFieldLength, 2);
  if FFileNameLength > 0 then
    Stream.Write(FFileName[1], FFileNameLength);
  if FExtraFieldLength > 0 then
    Stream.Write(FExtraField[1], FExtraFieldLength);
end;

procedure TfrxZipLocalFileHeader.SetExtraField(const Value: {$IFDEF Delphi12}AnsiString{$ELSE}String{$ENDIF});
begin
  FExtraField := Value;
  FExtraFieldLength := Length(Value);
end;

procedure TfrxZipLocalFileHeader.SetFileName(const Value: {$IFDEF Delphi12}AnsiString{$ELSE}String{$ENDIF});
begin
  FFileName :=  StringReplace(Value,
    {$IFDEF Delphi12}AnsiString('\'), AnsiString('/'){$ELSE}'\', '/'{$ENDIF}, [rfReplaceAll]);
  FFileNameLength := Length(Value);
end;

{ TfrxZipCentralDirectory }

constructor TfrxZipCentralDirectory.Create;
begin
  inherited;
  FEndOfChentralDirSignature := $06054b50;
  FNumberOfTheDisk := 0;
  FNumberOfTheDiskStartCentralDir := 0;
  FTotalOfEntriesCentralDirOnDisk := 0;
  FTotalOfEntriesCentralDir := 0;
  FSizeOfCentralDir := 0;
  FOffsetStartingDiskDir := 0;
  FCommentLength := 0;
  FComment := '';
end;

procedure TfrxZipCentralDirectory.SaveToStream(const Stream: TStream);
begin
  Stream.Write(FEndOfChentralDirSignature, 4);
  Stream.Write(FNumberOfTheDisk, 2);
  Stream.Write(FNumberOfTheDiskStartCentralDir, 2);
  Stream.Write(FTotalOfEntriesCentralDirOnDisk, 2);
  Stream.Write(FTotalOfEntriesCentralDir, 2);
  Stream.Write(FSizeOfCentralDir, 4);
  Stream.Write(FOffsetStartingDiskDir, 4);
  Stream.Write(FCommentLength, 2);
  if FCommentLength > 0 then
    Stream.Write(FComment[1], FCommentLength);
end;

procedure TfrxZipCentralDirectory.SetComment(const Value: {$IFDEF Delphi12}AnsiString{$ELSE}String{$ENDIF});
begin
  FComment := Value;
  FCommentLength := Length(Value);
end;

{ TfrxZipFileHeader }

constructor TfrxZipFileHeader.Create;
begin
  FCentralFileHeaderSignature := $02014b50;
  FRelativeOffsetLocalHeader := 0;
  FUnCompressedSize := 0;
  FCompressedSize := 0;
  FCrc32 := 0;
  FExternalFileAttribute := 0;
  FExtraField := '';
  FFileComment := '';
  FFileName := '';
  FCompressionMethod := 0;
  FDiskNumberStart := 0;
  FLastModFileDate := 0;
  FLastModFileTime := 0;
  FVersionMadeBy := ZIP_VERSIONMADEBY;
  FGeneralPurpose := 0;
  FFileNameLength := 0;
  FInternalFileAttribute := 0;
  FExtraFieldLength := 0;
  FVersionNeeded := ZIP_VERSIONMADEBY;
  FFileCommentLength := 0;
end;

procedure TfrxZipFileHeader.SaveToStream(const Stream: TStream);
begin
  Stream.Write(FCentralFileHeaderSignature, 4);
  Stream.Write(FVersionMadeBy, 2);
  Stream.Write(FVersionNeeded, 2);
  Stream.Write(FGeneralPurpose, 2);
  Stream.Write(FCompressionMethod, 2);
  Stream.Write(FLastModFileTime, 2);
  Stream.Write(FLastModFileDate, 2);
  Stream.Write(FCrc32, 4);
  Stream.Write(FCompressedSize, 4);
  Stream.Write(FUnCompressedSize, 4);
  Stream.Write(FFileNameLength, 2);
  Stream.Write(FExtraFieldLength, 2);
  Stream.Write(FFileCommentLength, 2);
  Stream.Write(FDiskNumberStart, 2);
  Stream.Write(FInternalFileAttribute, 2);
  Stream.Write(FExternalFileAttribute, 4);
  Stream.Write(FRelativeOffsetLocalHeader, 4);
  Stream.Write(FFilename[1], FFileNameLength);
  Stream.Write(FExtraField[1], FExtraFieldLength);
  Stream.Write(FFileComment[1], FFileCommentLength);
end;

procedure TfrxZipFileHeader.SetExtraField(const Value: {$IFDEF Delphi12}AnsiString{$ELSE}String{$ENDIF});
begin
  FExtraField := Value;
  FExtraFieldLength := Length(Value);
end;

procedure TfrxZipFileHeader.SetFileComment(const Value: {$IFDEF Delphi12}AnsiString{$ELSE}String{$ENDIF});
begin
  FFileComment := Value;
  FFileNameLength := Length(Value);
end;

procedure TfrxZipFileHeader.SetFileName(const Value: {$IFDEF Delphi12}AnsiString{$ELSE}String{$ENDIF});
begin
  FFileName := StringReplace(Value,
    {$IFDEF Delphi12}AnsiString('\'), AnsiString('/'){$ELSE}'\', '/'{$ENDIF}, [rfReplaceAll]);
  FFileNameLength := Length(Value);
end;

{ TfrxZipArchive }

procedure TfrxZipArchive.AddDir(const DirName: {$IFDEF Delphi12}AnsiString{$ELSE}String{$ENDIF});
var
  SRec: TSearchRec;
  i: Integer;
{$IFDEF Delphi12}
  s: AnsiString;
{$ELSE}
  s: String;
{$ENDIF}
begin
{$IFDEF Delphi12}
  if DirectoryExists(String(DirName)) then
{$ELSE}
  if DirectoryExists(DirName) then
{$ENDIF}
  begin
    s := DirName;
    if s[Length(s)] <> PathDelim then
      s := s + PathDelim;
{$IFDEF Delphi12}
    i := FindFirst(String(s) + '*.*', faDirectory + faArchive, SRec);
{$ELSE}
    i := FindFirst(s + '*.*', faDirectory + faArchive, SRec);
{$ENDIF}
    try
      while i = 0 do
      begin
        if (SRec.Name <> '.') and (SRec.Name <> '..') then
        begin
          if (SRec.Attr and faDirectory) = faDirectory then
{$IFDEF Delphi12}
            AddDir(s + AnsiString(SRec.Name))
          else
            AddFile(s + AnsiString(SRec.Name));
{$ELSE}
            AddDir(s + SRec.Name)
          else
            AddFile(s + SRec.Name);
{$ENDIF}
        end;
        i := FindNext(SRec);
      end;
    finally
      FindClose(SRec);
    end;
  end;
end;

{$IFDEF Delphi12}
procedure TfrxZipArchive.AddFile(const FileName: AnsiString);
begin
  if FileExists(String(FileName)) then
  begin
    FFileList.Add(String(FileName));
    if FRootFolder = '' then
      FRootFolder := ExtractFilePath(FileName);
  end
  else
    FErrors.Add('File ' + String(FileName) + ' not found!');
end;
{$ELSE}
procedure TfrxZipArchive.AddFile(const FileName: String);
begin
  if FileExists(FileName) then
  begin
    FFileList.Add(FileName);
    if FRootFolder = '' then
      FRootFolder := ExtractFilePath(FileName);
  end
  else
    FErrors.Add('File ' + FileName + ' not found!');
end;
{$ENDIF}
procedure TfrxZipArchive.Clear;
begin
  FErrors.Clear;
  FFileList.Clear;
  FRootFolder := '';
  FComment := '';
end;

constructor TfrxZipArchive.Create;
begin
  FProgress := nil;
  FErrors := TStringList.Create;
  FFileList := TStringList.Create;
  Clear;
end;

destructor TfrxZipArchive.Destroy;
begin
  FErrors.Free;
  FFileList.Free;
  inherited;
end;

function TfrxZipArchive.GetCount: Integer;
begin
  Result := FFileList.Count;
end;

procedure TfrxZipArchive.SaveToFile(const FileName: {$IFDEF Delphi12}AnsiString{$ELSE}String{$ENDIF});
var
  f: TFileStream;
begin
{$IFDEF Delphi12}
  f := TFileStream.Create(String(FileName), fmCreate);
{$ELSE}
  f := TFileStream.Create(FileName, fmCreate);
{$ENDIF}
  try
    SaveToStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxZipArchive.SaveToStream(const Stream: TStream);
var
  i: Integer;
  ZipFile: TfrxZipLocalFile;
  ZipFileHeader: TfrxZipFileHeader;
  ZipDir: TfrxZipCentralDirectory;
  FileStream: TFileStream;
  TempStream: TMemoryStream;
{$IFDEF Delphi12}
  FileName: AnsiString;
{$ELSE}
  FileName: String;
{$ENDIF}
  CentralStartPos, CentralEndPos: Longword;
{$IFNDEF STATIC_EXPORTING_RESULTS}
  LFT, LFT2: TFileTime;
  FDate, FTime: WORD;
{$ENDIF}
begin
  for i := 0 to FFileList.Count - 1 do
  begin
    ZipFile := TfrxZipLocalFile.Create;
    ZipFile.FileData := TMemoryStream.Create;
    try
{$IFDEF Delphi12}
      FileName := StringReplace(AnsiString(FFileList[i]), FRootFolder, AnsiString(''), []);
{$ELSE}
      FileName := StringReplace(FFileList[i], FRootFolder, '', []);
{$ENDIF}
      ZipFile.LocalFileHeader.FileName := FileName;
      FileStream := TFileStream.Create(FFileList[i], fmOpenRead + fmShareDenyWrite);
      try
        if FileStream.Size > ZIP_MINSIZE then
        begin
          FileStream.Position := 0;
          TempStream := TMemoryStream.Create;
          try
            frxDeflateStream(FileStream, TempStream);
            TempStream.Position := 2;
            ZipFile.FileData.CopyFrom(TempStream, TempStream.Size - 6);
          finally
            TempStream.Free;
          end;
          ZipFile.LocalFileHeader.CompressionMethod := ZIP_DEFLATED;
        end
        else
        begin
          ZipFile.FileData.CopyFrom(FileStream, 0);
          ZipFile.LocalFileHeader.CompressionMethod := ZIP_NONE;
        end;
        ZipFile.LocalFileHeader.CompressedSize := ZipFile.FileData.Size;
        ZipFile.LocalFileHeader.UnCompressedSize := FileStream.Size;
        TempStream := TMemoryStream.Create;
        try
          TempStream.CopyFrom(FileStream, 0);
          ZipFile.LocalFileHeader.Crc32 := frxStreamCRC32(TempStream);
        finally
          TempStream.Free;
        end;
        ZipFile.Offset := Stream.Position;
{$IFNDEF STATIC_EXPORTING_RESULTS}
        GetFileTime(FileStream.Handle, @LFT, nil, nil);
        FileTimeToLocalFileTime(LFT, LFT2);
        FileTimeToDosDateTime(LFT2, FDate, FTime);

//      {$IFNDEF STATIC_EXPORTING_RESULTS}
        ZipFile.LocalFileHeader.LastModFileDate := FDate;
        ZipFile.LocalFileHeader.LastModFileTime := FTime;
{$ENDIF}
      finally
        FileStream.Free;
      end;
      ZipFile.SaveToStream(Stream);
      if Assigned(FProgress) then
        FProgress(Self);
    finally
      ZipFile.FileData.Free;
      ZipFile.FileData := nil;
    end;
    FFileList.Objects[i] := ZipFile;
  end;
  CentralStartPos := Stream.Position;
  for i := 0 to FFileList.Count - 1 do
  begin
    ZipFile := TfrxZipLocalFile(FFileList.Objects[i]);
    ZipFileHeader := TfrxZipFileHeader.Create;
    try
      ZipFileHeader.CompressionMethod := ZipFile.LocalFileHeader.CompressionMethod;
      ZipFileHeader.LastModFileTime := ZipFile.LocalFileHeader.LastModFileTime;
      ZipFileHeader.LastModFileDate := ZipFile.LocalFileHeader.LastModFileDate;
      ZipFileHeader.GeneralPurpose := ZipFile.LocalFileHeader.GeneralPurpose;
      ZipFileHeader.Crc32 := ZipFile.LocalFileHeader.Crc32;
      ZipFileHeader.CompressedSize := ZipFile.LocalFileHeader.CompressedSize;
      ZipFileHeader.UnCompressedSize := ZipFile.LocalFileHeader.UnCompressedSize;
      ZipFileHeader.RelativeOffsetLocalHeader := ZipFile.Offset;
      ZipFileHeader.FileName := ZipFile.LocalFileHeader.FileName;
      ZipFileHeader.SaveToStream(Stream);
    finally
      ZipFileHeader.Free;
    end;
    ZipFile.Free;
  end;
  CentralEndPos := Stream.Position;
  ZipDir := TfrxZipCentralDirectory.Create;
  try
    ZipDir.TotalOfEntriesCentralDirOnDisk := FFileList.Count;
    ZipDir.TotalOfEntriesCentralDir := FFileList.Count;
    ZipDir.SizeOfCentralDir := CentralEndPos - CentralStartPos;
    ZipDir.OffsetStartingDiskDir := CentralStartPos;
    ZipDir.SaveToStream(Stream);
  finally
    ZipDir.Free;
  end;
end;

procedure TfrxZipArchive.SaveToStreamFromList(const Stream: TStream; FileStreams: TStrings);
var
  i: Integer;
  ZipFile: TfrxZipLocalFile;
  ZipFileHeader: TfrxZipFileHeader;
  ZipDir: TfrxZipCentralDirectory;
  FileStream: TStream;
  TempStream: TMemoryStream;
{$IFDEF Delphi12}
  FileName: AnsiString;
{$ELSE}
  FileName: String;
{$ENDIF}
  CentralStartPos, CentralEndPos: Longword;
{$IFNDEF STATIC_EXPORTING_RESULTS}
  {LFT, }LFT2: TFileTime;
  st: _SYSTEMTIME;
  FDate, FTime: WORD;
{$ENDIF}
begin
  for i := 0 to FileStreams.Count - 1 do
  begin
    ZipFile := TfrxZipLocalFile.Create;
    ZipFile.FileData := TMemoryStream.Create;
    try
{$IFDEF Delphi12}
      FileName := StringReplace(AnsiString(FileStreams[i]), FRootFolder, AnsiString(''), []);
{$ELSE}
      FileName := StringReplace(FileStreams[i], FRootFolder, '', []);
{$ENDIF}
      ZipFile.LocalFileHeader.FileName := FileName;
      FileStream := TStream(FileStreams.Objects[i]);// TFileStream.Create(FFileList[i], fmOpenRead + fmShareDenyWrite);
      try
        if FileStream.Size > ZIP_MINSIZE then
        begin
          FileStream.Position := 0;
          TempStream := TMemoryStream.Create;
          try
            frxDeflateStream(FileStream, TempStream);
            TempStream.Position := 2;
            ZipFile.FileData.CopyFrom(TempStream, TempStream.Size - 6);
          finally
            TempStream.Free;
          end;
          ZipFile.LocalFileHeader.CompressionMethod := ZIP_DEFLATED;
        end
        else
        begin
          ZipFile.FileData.CopyFrom(FileStream, 0);
          ZipFile.LocalFileHeader.CompressionMethod := ZIP_NONE;
        end;
        ZipFile.LocalFileHeader.CompressedSize := ZipFile.FileData.Size;
        ZipFile.LocalFileHeader.UnCompressedSize := FileStream.Size;
        TempStream := TMemoryStream.Create;
        try
          TempStream.CopyFrom(FileStream, 0);
          ZipFile.LocalFileHeader.Crc32 := frxStreamCRC32(TempStream);
        finally
          TempStream.Free;
        end;
        ZipFile.Offset := Stream.Position;
{$IFNDEF STATIC_EXPORTING_RESULTS}
        GetLocalTime(st);
        SystemTimeToFileTime(st, LFT2);
//        GetFileTime(FileStream.Handle, @LFT, nil, nil);
        //FileTimeToLocalFileTime(LFT, LFT2);
        FileTimeToDosDateTime(LFT2, FDate, FTime);


        ZipFile.LocalFileHeader.LastModFileDate := FDate;
        ZipFile.LocalFileHeader.LastModFileTime := FTime;
{$ENDIF}
      finally
        //FileStream.Free;
      end;
      ZipFile.SaveToStream(Stream);
      if Assigned(FProgress) then
        FProgress(Self);
    finally
      ZipFile.FileData.Free;
      ZipFile.FileData := nil;
    end;
    FileStreams.Objects[i] := ZipFile;
  end;
  CentralStartPos := Stream.Position;
  for i := 0 to FileStreams.Count - 1 do
  begin
    ZipFile := TfrxZipLocalFile(FileStreams.Objects[i]);
    ZipFileHeader := TfrxZipFileHeader.Create;
    try
      ZipFileHeader.CompressionMethod := ZipFile.LocalFileHeader.CompressionMethod;
      ZipFileHeader.LastModFileTime := ZipFile.LocalFileHeader.LastModFileTime;
      ZipFileHeader.LastModFileDate := ZipFile.LocalFileHeader.LastModFileDate;
      ZipFileHeader.GeneralPurpose := ZipFile.LocalFileHeader.GeneralPurpose;
      ZipFileHeader.Crc32 := ZipFile.LocalFileHeader.Crc32;
      ZipFileHeader.CompressedSize := ZipFile.LocalFileHeader.CompressedSize;
      ZipFileHeader.UnCompressedSize := ZipFile.LocalFileHeader.UnCompressedSize;
      ZipFileHeader.RelativeOffsetLocalHeader := ZipFile.Offset;
      ZipFileHeader.FileName := ZipFile.LocalFileHeader.FileName;
      ZipFileHeader.SaveToStream(Stream);
    finally
      ZipFileHeader.Free;
    end;
    ZipFile.Free;
  end;
  CentralEndPos := Stream.Position;
  ZipDir := TfrxZipCentralDirectory.Create;
  try
    ZipDir.TotalOfEntriesCentralDirOnDisk := FileStreams.Count;
    ZipDir.TotalOfEntriesCentralDir := FileStreams.Count;
    ZipDir.SizeOfCentralDir := CentralEndPos - CentralStartPos;
    ZipDir.OffsetStartingDiskDir := CentralStartPos;
    ZipDir.SaveToStream(Stream);
  finally
    ZipDir.Free;
  end;

end;
end.
