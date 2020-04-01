
{******************************************}
{                                          }
{             FastReport v6.0              }
{           ERSI Shape Map File            }
{                                          }
{        Copyright (c) 2015 - 2019         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxERSIShapeFileFormat;

interface

{$I frx.inc}

uses
  Classes, Contnrs,
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType, LCLIntf, LCLProc,
{$ENDIF}
  Graphics, Types, frxERSIShapeDBFImport, frxClass,
  frxMapHelpers, frxAnaliticGeometry;

const
  { ERSI Shape Types }
  ERSI_Null = 0;
  ERSI_Point = 1;
  ERSI_PolyLine = 3;
  ERSI_Polygon = 5;
  ERSI_MultiPoint = 8;
  ERSI_PointZ = 11;
  ERSI_PolyLineZ = 13;
  ERSI_PolygonZ = 15;
  ERSI_MultiPointZ = 18;
  ERSI_PointM = 21;
  ERSI_PolyLineM = 23;
  ERSI_PolygonM = 25;
  ERSI_MultiPointM = 28;
  ERSI_MultiPatch = 31;

type
  TERSIMainFileHeader = packed record
    FileCode: LongInt; { Big endian = 9994 }
    Unused: array[0..4] of LongInt;
    FileLength: LongInt; { Big endian; Measured in 16-bit words }
    Version: LongInt; { = 1000 }
    ShapeType: LongInt;
    Xmin, Ymin, Xmax, Ymax: Double;
    Zmin, Zmax, Mmin, Mmax: Double; { Unused, with value 0.0, if not Measured or Z type }
  end;

  TERSIMainFileRecordHeader = record
    RecordNumber: LongInt; { Big endian;  Record numbers begin at 1 }
    ContentLength: LongInt; { Big endian; Measured in 16-bit words }
    ShapeType: LongInt;
  end;

  TERSINull = class
  private
    FHeader: TERSIMainFileRecordHeader;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader);

    property Header: TERSIMainFileRecordHeader read FHeader;
  end;

  TERSIPoint = class(TERSINull)
  private
    FPoint: TDoublePoint;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
    property Point: TDoublePoint read FPoint;
  end;

  TDoublePointM = record
    X, Y, M: Double;
  end;
  TDoublePointMArray = array of TDoublePointM;

  TERSIPointM = class(TERSINull)
  private
    FPointM: TDoublePointM;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
    property PointM: TDoublePointM read FPointM;
  end;

  TDoublePointZ = record
    X, Y, Z, M: Double;
  end;
  TDoublePointZArray = array of TDoublePointZ;

  TERSIPointZ = class(TERSINull)
  private
    FPointZ: TDoublePointZ;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
    property PointZ: TDoublePointZ read FPointZ;
  end;

  TBox = record
    Xmin, Ymin, Xmax, Ymax: Double;
  end;

  TERSIMultiPoint = class(TERSINull)
  private
    FBox: TBox;
    FNumPoints: LongInt;
    FPoints: TDoublePointArray;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);

    property Box: TBox read FBox;
    property NumPoints: LongInt read FNumPoints;
    property Points: TDoublePointArray read FPoints;
  end;

  TERSIMultiPointM = class(TERSIMultiPoint)
  private
    FMMin: Double;
    FMMax: Double;
    FPointsM: TDoubleArray;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);

    property MMin: Double read FMMin;
    property MMax: Double read FMMax;
    property PointsM: TDoubleArray read FPointsM;
  end;

  TERSIMultiPointZ = class(TERSIMultiPoint)
  private
    FZMin: Double;
    FZMax: Double;
    FPointsZ: TDoubleArray;
    FMMin: Double;
    FMMax: Double;
    FPointsM: TDoubleArray;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);

    property ZMin: Double read FZMin;
    property ZMax: Double read FZMax;
    property PointsZ: TDoubleArray read FPointsZ;
    property MMin: Double read FMMin;
    property MMax: Double read FMMax;
    property PointsM: TDoubleArray read FPointsM;
  end;

  TLongIntArray = array of LongInt;

  TERSIPolyLine = class(TERSINull)
  private
    FBox: TBox;
    FNumParts: LongInt;
    FNumPoints: LongInt;
    FPartFirsPointIndex: TLongIntArray;
    FPoints: TDoublePointArray;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);

    function PartLastPointIndex(PartNumber: LongInt): LongInt;
    function PartCount(PartNumber: LongInt): LongInt;

    property Box: TBox read FBox;
    property NumParts: LongInt read FNumParts; { Number of Parts }
    property NumPoints: LongInt read FNumPoints; { Total Number of Points }
    property PartFirsPointIndex: TLongIntArray read FPartFirsPointIndex;
    property Points: TDoublePointArray read FPoints; { Points for All Parts }
  end;

  TERSIPolygon = class(TERSIPolyLine);

  TERSIPolyLineM = class(TERSIPolyLine)
  private
    FMMin: Double;
    FMMax: Double;
    FPointsM: TDoubleArray;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);

    property MMin: Double read FMMin;
    property MMax: Double read FMMax;
    property PointsM: TDoubleArray read FPointsM;
  end;

  TERSIPolygonM = class(TERSIPolyLineM);

  TERSIPolyLineZ = class(TERSIPolyLine)
  private
    FZMin: Double;
    FZMax: Double;
    FPointsZ: TDoubleArray;
    FMMin: Double;
    FMMax: Double;
    FPointsM: TDoubleArray;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);

    property ZMin: Double read FZMin;
    property MZax: Double read FZMax;
    property PointsZ: TDoubleArray read FPointsZ;
    property MMin: Double read FMMin;
    property MMax: Double read FMMax;
    property PointsM: TDoubleArray read FPointsM;
  end;

  TERSIPolygonZ = class(TERSIPolyLineZ);

  TMultiPath = class(TERSINull)
  private
    FBox: TBox;
    FNumParts: LongInt;
    FNumPoints: LongInt;
    FPartFirsPointIndex: TLongIntArray;
    FPartTypes: TLongIntArray;
    FPoints: TDoublePointArray;
    FZMin: Double;
    FZMax: Double;
    FPointsZ: TDoubleArray;
    FMMin: Double;
    FMMax: Double;
    FPointsM: TDoubleArray;
  public
    constructor Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);

    function PartLastPointIndex(PartNumber: LongInt): LongInt;
    function PartCount(PartNumber: LongInt): LongInt;

    property Box: TBox read FBox;
    property NumParts: LongInt read FNumParts; { Number of Parts }
    property NumPoints: LongInt read FNumPoints; { Total Number of Points }
    property PartFirsPointIndex: TLongIntArray read FPartFirsPointIndex;
    property PartTypes: TLongIntArray read FPartTypes;
    property Points: TDoublePointArray read FPoints; { Points for All Parts }
    property ZMin: Double read FZMin;
    property MZax: Double read FZMax;
    property PointsZ: TDoubleArray read FPointsZ;
    property MMin: Double read FMMin;
    property MMax: Double read FMMax;
    property PointsM: TDoubleArray read FPointsM;
  end;

  TERSIShapeFile = class
  private
    function GetRecordCount: Integer;
    function GetPolyPartsCount(iRecord: Integer): Integer;
    function GetPolyPointsCount(iRecord, iPart: Integer): Integer;
    function GetMultiPointCount(iRecord: Integer): Integer;
    function GetPolyPoint(iRecord, iPart, iPoint: Integer): TDoublePoint;
    function GetPoint(iRecord: Integer): TDoublePoint;
    function GetMultiPoint(iRecord, iPoint: Integer): TDoublePoint;
    function GetLegend(FieldName: AnsiString; iRecord: Integer): AnsiString;
    function GetERSIShapeType(iRecord: Integer): LongInt;
    function GetLegendByColumn(iColumn, iRecord: Integer): AnsiString;
    function GetLegendToString(iColumn, iRecord: Integer): String;
  protected
    FMainFileHeader: TERSIMainFileHeader;
    XRange, YRange: Double;
    FList: TObjectList;
    FDBFFile: TERSIDBFFile;

    procedure SwapEndianness(var Value: LongInt);
    procedure ReadFromStream(Stream: TStream);
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;

    procedure GetColumnList(List: TStrings);
    procedure GetPartPoints(var PartPoints: TDoublePointArray; iRecord, iPart: Integer);

    property Xmin: Double read FMainFileHeader.Xmin;
    property Ymin: Double read FMainFileHeader.Ymin;
    property Xmax: Double read FMainFileHeader.Xmax;
    property Ymax: Double read FMainFileHeader.Ymax;

    property RecordCount: Integer read GetRecordCount;
    property PolyPartsCount[iRecord: Integer]: Integer read GetPolyPartsCount;
    property PolyPointsCount[iRecord, iPart: Integer]: Integer read GetPolyPointsCount;
    property MultiPointCount[iRecord: Integer]: Integer read GetMultiPointCount;
    property Legend[FieldName: AnsiString; iRecord: Integer]: AnsiString read GetLegend;
    property LegendByColumn[iColumn, iRecord: Integer]: AnsiString read GetLegendByColumn;
    property LegendToString[iColumn, iRecord: Integer]: String read GetLegendToString;

    property ERSIShapeType[iRecord: Integer]: LongInt read GetERSIShapeType;
    property PolyPoint[iRecord, iPart, iPoint: Integer]: TDoublePoint read GetPolyPoint;
    property Point[iRecord: Integer]: TDoublePoint read GetPoint;
    property MultiPoint[iRecord, iPoint: Integer]: TDoublePoint read GetMultiPoint;
  end;

implementation

uses
  SysUtils;

{ TERSINull }

constructor TERSINull.Create(AHeader: TERSIMainFileRecordHeader);
begin
  FHeader := AHeader;
end;

{ TERSIPoint }

constructor TERSIPoint.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader);
  Stream.Read(FPoint, SizeOf(FPoint));
end;

{ TERSIMultiPoint }

constructor TERSIMultiPoint.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader);
  Stream.Read(FBox, SizeOf(FBox));
  Stream.Read(FNumPoints, SizeOf(FNumPoints));

  SetLength(FPoints, FNumPoints);
  Stream.Read(FPoints[0], SizeOf(FPoints[0]) * FNumPoints);
end;

{ TERSIPolyLine }

constructor TERSIPolyLine.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader);

  Stream.Read(FBox, SizeOf(FBox));
  Stream.Read(FNumParts, SizeOf(FNumParts));
  Stream.Read(FNumPoints, SizeOf(FNumPoints));

  SetLength(FPartFirsPointIndex, FNumParts);
  Stream.Read(FPartFirsPointIndex[0], SizeOf(FPartFirsPointIndex[0]) * FNumParts);

  SetLength(FPoints, FNumPoints);
  Stream.Read(FPoints[0], SizeOf(FPoints[0]) * FNumPoints);
end;

function TERSIPolyLine.PartCount(PartNumber: LongInt): LongInt;
begin
  Result := PartLastPointIndex(PartNumber) - PartFirsPointIndex[PartNumber];
end;

function TERSIPolyLine.PartLastPointIndex(PartNumber: LongInt): LongInt;
begin
  if PartNumber < FNumParts - 1 then
    Result := PartFirsPointIndex[PartNumber + 1] - 1
  else
    Result := FNumPoints - 1;
end;

{ TERSIShapeFile }

constructor TERSIShapeFile.Create(const FileName: string);
var
  Stream: TFileStream;
  PlatformName: string;
  Mode: Word;
begin
  PlatformName := PlatformFileName(FileName);
  Mode := fmOpenRead or fmShareDenyWrite;

  Stream := TFileStream.Create(PlatformName, Mode);
  try
    ReadFromStream(Stream);
  finally
    Stream.Free;
  end;

  FDBFFile := TERSIDBFFile.Create(ChangeFileExt(PlatformName, '.dbf'), FList.Count);
end;

destructor TERSIShapeFile.Destroy;
begin
  FList.Free;
  FDBFFile.Free;
  inherited;
end;

procedure TERSIShapeFile.GetColumnList(List: TStrings);
begin
  FDBFFile.GetColumnList(List);
end;

function TERSIShapeFile.GetERSIShapeType(iRecord: Integer): LongInt;
begin
  Result := (FList[iRecord] as TERSINull).FHeader.ShapeType;
end;

function TERSIShapeFile.GetLegend(FieldName: AnsiString; iRecord: Integer): AnsiString;
begin
  Result := FDBFFile.Legend[FieldName, iRecord];
end;

function TERSIShapeFile.GetLegendByColumn(iColumn, iRecord: Integer): AnsiString;
begin
  Result := FDBFFile.LegendByColumn[iColumn, iRecord];
end;

function TERSIShapeFile.GetLegendToString(iColumn, iRecord: Integer): String;
var
  Ansi: AnsiString;
begin
  Ansi := GetLegendByColumn(iColumn, iRecord);

  if FDBFFile.IsUTF8 then
    Result := {$IFDEF Delphi12} UTF8ToString(Ansi)
              {$ELSE}           UTF8Decode(Ansi)
              {$ENDIF}
  else
    Result := String(Ansi);
end;

function TERSIShapeFile.GetMultiPoint(iRecord, iPoint: Integer): TDoublePoint;
begin
  Result := (FList[iRecord] as TERSIMultiPoint).Points[iPoint];
end;

function TERSIShapeFile.GetMultiPointCount(iRecord: Integer): Integer;
begin
  Result := (FList[iRecord] as TERSIMultiPoint).NumPoints;
end;

procedure TERSIShapeFile.GetPartPoints(var PartPoints: TDoublePointArray; iRecord, iPart: Integer);
var
  iPoint, Count: Integer;
begin
  Count := PolyPointsCount[iRecord, iPart];
  SetLength(PartPoints, Count);
  for iPoint := 0 to Count - 1 do
    PartPoints[iPoint] := PolyPoint[iRecord, iPart, iPoint];
end;

function TERSIShapeFile.GetPoint(iRecord: Integer): TDoublePoint;
begin
  Result := (FList[iRecord] as TERSIPoint).Point;
end;

function TERSIShapeFile.GetPolyPartsCount(iRecord: Integer): Integer;
begin
  with FList[iRecord] as TERSIPolyLine do
    Result := NumParts;
end;

function TERSIShapeFile.GetPolyPoint(iRecord, iPart, iPoint: Integer): TDoublePoint;
begin
  with FList[iRecord] as TERSIPolyLine do
    Result := Points[PartFirsPointIndex[iPart] + iPoint];
end;

function TERSIShapeFile.GetPolyPointsCount(iRecord, iPart: Integer): Integer;
begin
  Result := (FList[iRecord] as TERSIPolyLine).PartCount(iPart);
end;

function TERSIShapeFile.GetRecordCount: Integer;
begin
  Result := FList.Count;
end;

procedure TERSIShapeFile.ReadFromStream(Stream: TStream);
var
  Header: TERSIMainFileRecordHeader;
begin
  Stream.Read(FMainFileHeader, SizeOf(FMainFileHeader));
  SwapEndianness(FMainFileHeader.FileCode);
  SwapEndianness(FMainFileHeader.FileLength);
  XRange := FMainFileHeader.Xmax - FMainFileHeader.Xmin;
  YRange := FMainFileHeader.Ymax - FMainFileHeader.Ymin;

  FList := TObjectList.Create;
  FList.OwnsObjects := True;

  while Stream.Position < Stream.Size do
  begin
    Stream.Read(Header, SizeOf(Header));
    SwapEndianness(Header.RecordNumber);
    SwapEndianness(Header.ContentLength);

    case Header.ShapeType of
      ERSI_Null:
        FList.Add(TERSINull.Create(Header));
      ERSI_Point:
        FList.Add(TERSIPoint.Create(Header, Stream));
      ERSI_PolyLine:
        FList.Add(TERSIPolyLine.Create(Header, Stream));
      ERSI_Polygon:
        FList.Add(TERSIPolygon.Create(Header, Stream));
      ERSI_MultiPoint:
        FList.Add(TERSIMultiPoint.Create(Header, Stream));
      ERSI_PointZ:
        FList.Add(TERSIPointZ.Create(Header, Stream));
      ERSI_PolyLineZ:
        FList.Add(TERSIPolyLineZ.Create(Header, Stream));
      ERSI_PolygonZ:
        FList.Add(TERSIPolygonZ.Create(Header, Stream));
      ERSI_MultiPointZ:
        FList.Add(TERSIMultiPointZ.Create(Header, Stream));
      ERSI_PointM:
        FList.Add(TERSIPointM.Create(Header, Stream));
      ERSI_PolyLineM:
        FList.Add(TERSIPolyLineM.Create(Header, Stream));
      ERSI_PolygonM:
        FList.Add(TERSIPolygonM.Create(Header, Stream));
      ERSI_MultiPointM:
        FList.Add(TERSIMultiPointM.Create(Header, Stream));
      ERSI_MultiPatch:
        FList.Add(TMultiPath.Create(Header, Stream));
    end;
  end;
end;

procedure TERSIShapeFile.SwapEndianness(var Value: LongInt);
var
  c1, c2: record
    case Byte of
      0: (CardinalValue: LongInt);
      1: (ByteValue: array[0..3] of Byte);
  end;
begin
  c1.CardinalValue := Value;
  c2.ByteValue[0] := c1.ByteValue[3];
  c2.ByteValue[1] := c1.ByteValue[2];
  c2.ByteValue[2] := c1.ByteValue[1];
  c2.ByteValue[3] := c1.ByteValue[0];
  Value := c2.CardinalValue;
end;

{ TERSIPointM }

constructor TERSIPointM.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader);
  Stream.Read(FPointM, SizeOf(FPointM));
end;

{ TERSIPointZ }

constructor TERSIPointZ.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader);
  Stream.Read(FPointZ, SizeOf(FPointZ));
end;

{ TERSIMultiPointM }

constructor TERSIMultiPointM.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader, Stream);

  Stream.Read(FMMin, SizeOf(FMMin));
  Stream.Read(FMMax, SizeOf(FMMax));

  SetLength(FPointsM, FNumPoints);
  Stream.Read(FPointsM[0], SizeOf(FPointsM[0]) * FNumPoints);
end;

{ TERSIMultiPointZ }

constructor TERSIMultiPointZ.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader, Stream);

  Stream.Read(FZMin, SizeOf(FZMin));
  Stream.Read(FZMax, SizeOf(FZMax));

  SetLength(FPointsZ, FNumPoints);
  Stream.Read(FPointsZ[0], SizeOf(FPointsZ[0]) * FNumPoints);

  Stream.Read(FMMin, SizeOf(FMMin));
  Stream.Read(FMMax, SizeOf(FMMax));

  SetLength(FPointsM, FNumPoints);
  Stream.Read(FPointsM[0], SizeOf(FPointsM[0]) * FNumPoints);
end;

{ TERSIPolyLineM }

constructor TERSIPolyLineM.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader, Stream);

  Stream.Read(FMMin, SizeOf(FMMin));
  Stream.Read(FMMax, SizeOf(FMMax));

  SetLength(FPointsM, FNumPoints);
  Stream.Read(FPointsM[0], SizeOf(FPointsM[0]) * FNumPoints);
end;

{ TERSIPolyLineZ }

constructor TERSIPolyLineZ.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader, Stream);

  Stream.Read(FZMin, SizeOf(FZMin));
  Stream.Read(FZMax, SizeOf(FZMax));

  SetLength(FPointsZ, FNumPoints);
  Stream.Read(FPointsZ[0], SizeOf(FPointsZ[0]) * FNumPoints);

  Stream.Read(FMMin, SizeOf(FMMin));
  Stream.Read(FMMax, SizeOf(FMMax));

  SetLength(FPointsM, FNumPoints);
  Stream.Read(FPointsM[0], SizeOf(FPointsM[0]) * FNumPoints);
end;

{ TMultiPath }

constructor TMultiPath.Create(AHeader: TERSIMainFileRecordHeader; Stream: TStream);
begin
  inherited Create(AHeader);

  Stream.Read(FBox, SizeOf(FBox));
  Stream.Read(FNumParts, SizeOf(FNumParts));
  Stream.Read(FNumPoints, SizeOf(FNumPoints));

  SetLength(FPartFirsPointIndex, FNumParts);
  Stream.Read(FPartFirsPointIndex[0], SizeOf(FPartFirsPointIndex[0]) * FNumParts);

  SetLength(FPartTypes, FNumParts);
  Stream.Read(FPartTypes[0], SizeOf(FPartTypes[0]) * FNumParts);

  SetLength(FPoints, FNumPoints);
  Stream.Read(FPoints[0], SizeOf(FPoints[0]) * FNumPoints);

  Stream.Read(FZMin, SizeOf(FZMin));
  Stream.Read(FZMax, SizeOf(FZMax));

  SetLength(FPointsZ, FNumPoints);
  Stream.Read(FPointsZ[0], SizeOf(FPointsZ[0]) * FNumPoints);

  Stream.Read(FMMin, SizeOf(FMMin));
  Stream.Read(FMMax, SizeOf(FMMax));

  SetLength(FPointsM, FNumPoints);
  Stream.Read(FPointsM[0], SizeOf(FPointsM[0]) * FNumPoints);
end;

function TMultiPath.PartCount(PartNumber: Integer): LongInt;
begin
  Result := PartLastPointIndex(PartNumber) - PartFirsPointIndex[PartNumber];
end;

function TMultiPath.PartLastPointIndex(PartNumber: Integer): LongInt;
begin
  if PartNumber < FNumParts - 1 then
    Result := PartFirsPointIndex[PartNumber + 1] - 1
  else
    Result := FNumPoints - 1;
end;

end.

