
{******************************************}
{                                          }
{             FastReport v6.0              }
{                Map Shape                 }
{                                          }
{         Copyright (c) 2016 - 2018        }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapShape;

interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf, LConvEncoding, LazUTF8,
{$ELSE}
  Windows,
{$ENDIF}
  Classes, Contnrs, frxClass, Graphics, Types, frxMapHelpers, frxOSMFileFormat,
  frxGPXFileFormat, frxERSIShapeFileFormat, frxAnaliticGeometry;

type
  TShapeStyle = class(TPersistent)
  private
    FBorderColor: TColor;
    FBorderStyle: TPenStyle;
    FBorderWidth: Integer;
    FFillColor: TColor;
    FPointSize: Extended;
  public
    constructor Create;
    procedure TunePen(Pen: TPen);
  published
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BorderStyle: TPenStyle read FBorderStyle write FBorderStyle;
    property BorderWidth: Integer read FBorderWidth write FBorderWidth;
    property FillColor: TColor read FFillColor write FFillColor;
    property PointSize: Extended read FPointSize write FPointSize; // Diameter
  end;
(******************************************************************************)
  TShape = class(TPersistent)
  private
    FZoom: Extended;
    FCenterOffsetX: Extended;
    FCenterOffsetY: Extended;
    FOffsetX: Extended;
    FOffsetY: Extended;
    FValue: Extended;
    function GetShapeType: TShapeType;
    function GetLegend(const Name: String): String;
    function GetPartCount: integer;
    function GetShapeCenter: TfrxPoint;
    function GetShapeTags: TStringList;
  protected
    FShapeData: TShapeData;

    procedure Clear; virtual;
  public
    procedure Write(Writer: TWriter);
    procedure WriteData(Writer: TWriter);
    procedure Read(Reader: TReader);
    procedure ReadData(Reader: TReader);

    constructor CreateClear;
    destructor Destroy; override;
    function IsValueEmpty: Boolean;

    property Value: Extended read FValue write FValue;
    property ShapeType: TShapeType read GetShapeType;
    property Legend[const Name: String]: String read GetLegend;
    property PartCount: integer read GetPartCount;
    property ShapeCenter: TfrxPoint read GetShapeCenter;
    property ShapeData: TShapeData read FShapeData;

    property OffsetX: Extended read FOffsetX write FOffsetX;
    property OffsetY: Extended read FOffsetY write FOffsetY;
    property Zoom: Extended read FZoom write FZoom;
  published
    property CenterOffsetX: Extended read FCenterOffsetX write FCenterOffsetX;
    property CenterOffsetY: Extended read FCenterOffsetY write FCenterOffsetY;
    property ShapeTags: TStringList read GetShapeTags;
  end;

  TAdjustableShape = class(TShape)
  published
    property OffsetX;
    property OffsetY;
    property Zoom;
  end;

(******************************************************************************)
  TShapeList = class(TObjectList)
  private
    FEmbeddedData: Boolean;
    FAdjustableShape: Boolean;

    function GetShape(Index: Integer): TShape;
    procedure SetShape(Index: Integer; const AShape: TShape);
  protected
    FXMin, FXMax, FYMin, FYMax: Extended;
    FConverter: TMapToCanvasCoordinateConverter;
    FValidMapRect: Boolean;

    procedure SetMapRect(XMin, XMax, YMin, YMax: Extended);
    function Data(iRecord, iPart, iPoint: Integer): TDoublePoint;
  public
    constructor Create(Converter: TMapToCanvasCoordinateConverter);
    function AddShapeData(const AShapeData: TShapeData): integer;
    procedure ReplaceShapeData(iRecord: Integer; const AShapeData: TShapeData);

    procedure ReadDFM(Stream: TStream);
    procedure WriteDFM(Stream: TStream);
    procedure Read(Reader: TReader);
    procedure Write(Writer: TWriter);

    function IsGetValues(var Values: TDoubleArray): boolean;
    procedure ClearValues;

    function IsCanvasPolyPoints(iRecord, iPart: Integer;  MapAccuracy, PixelAccuracy: Extended; var PolyPoints: TPointArray): boolean;
    function CanvasPoint(iRecord: Integer): TfrxPoint;
    function CanvasRect(iRecord: Integer): TDoubleRect;
    function CanvasPoly(iRecord: Integer): TDoublePointArray;
    function CanvasMatrix(iRecord: Integer): TDoublePointMatrix;
    function CanvasWidestPartBounds(iRecord: Integer): TfrxRect;
    procedure GetColumnList(List: TStrings);
    function IsValidMapRect(out MapRect: TfrxRect): boolean;
    procedure SetMapRectByData;
    function IsHasLegend(FieldName: String; Legend: String; out iRecord: Integer): boolean;
    function CanvasDistance(iRecord: Integer; P: TfrxPoint): Extended;
    function IsInside(iRecord: Integer; P: TfrxPoint): Boolean; // Canvas Point
    procedure SaveToTextFile(FileName: String);


    property Items[Index: Integer]: TShape read GetShape write SetShape; default;
    property EmbeddedData: Boolean read FEmbeddedData write FEmbeddedData;
    property AdjustableShape: Boolean read FAdjustableShape write FAdjustableShape;
  end;
(******************************************************************************)
  TOSMFileList = class (TStringList)
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddFile(FileName: String);
    function FileByName(FileName: String): TOSMFile;
  end;

  TOSMShapeList = class (TShapeList)
  protected
    procedure LoadData(OSMFile: TOSMFile; LayerTags: TStrings);
  public
    constructor CreateFromFile(FileName: String; Converter: TMapToCanvasCoordinateConverter;
      FileList: TOSMFileList; LayerTags: TStrings);
  end;
(******************************************************************************)
  TGPXShapeList = class (TShapeList)
  protected
    procedure LoadData(GPXFile: TGPXFile);
  public
    constructor CreateFromFile(FileName: String; Converter: TMapToCanvasCoordinateConverter);
  end;
(******************************************************************************)
  TERSIShapeList = class (TShapeList)
  protected
    procedure LoadData(ERSIFile: TERSIShapeFile);
  public
    constructor CreateFromFile(FileName: String; Converter: TMapToCanvasCoordinateConverter);
  end;
(******************************************************************************)

implementation

uses
  Math, SysUtils, frxUtils, frxMapShapeTags {Editor}, frxMapLayerTags;

{ TShape }

procedure TShape.Clear;
begin
  FZoom := 1;
  FCenterOffsetX := 0;
  FCenterOffsetY := 0;
  FOffsetX := 0;
  FOffsetY := 0;
  FValue := NaN;
end;

constructor TShape.CreateClear;
begin
  inherited Create;

  Clear;
end;

destructor TShape.Destroy;
begin
  FShapeData.Free;

  inherited;
end;

function TShape.GetLegend(const Name: String): String;
begin
  Result := FShapeData.Legend[Name];
end;

function TShape.GetPartCount: integer;
begin
  Result := FShapeData.PartCount;
end;

function TShape.GetShapeCenter: TfrxPoint;
begin
  Result := FShapeData.ShapeCenter;
end;

function TShape.GetShapeTags: TStringList;
begin
  Result := FShapeData.Tags;
end;

function TShape.GetShapeType: TShapeType;
begin
  Result := FShapeData.ShapeType;
end;

function TShape.IsValueEmpty: Boolean;
begin
  Result := IsNaN(Value);
end;

procedure TShape.Read(Reader: TReader);
begin
  FZoom := Reader.ReadFloat;
  FCenterOffsetX := Reader.ReadFloat;
  FCenterOffsetY := Reader.ReadFloat;
  FOffsetX := Reader.ReadFloat;
  FOffsetY := Reader.ReadFloat;
  FValue := Reader.ReadFloat;

  if FShapeData = nil then
    FShapeData := TShapeData.Create;
  FShapeData.ReadTags(Reader);
end;

procedure TShape.ReadData(Reader: TReader);
begin
  FShapeData.ReadData(Reader);
end;

procedure TShape.Write(Writer: TWriter);
begin
  Writer.WriteFloat(FZoom);
  Writer.WriteFloat(FCenterOffsetX);
  Writer.WriteFloat(FCenterOffsetY);
  Writer.WriteFloat(FOffsetX);
  Writer.WriteFloat(FOffsetY);
  Writer.WriteFloat(FValue);

  FShapeData.WriteTags(Writer);
end;

procedure TShape.WriteData(Writer: TWriter);
begin
  FShapeData.WriteData(Writer);
end;

{ TShapeList }

function TShapeList.AddShapeData(const AShapeData: TShapeData): integer;
begin
  if AdjustableShape then
    Result := Add(TAdjustableShape.CreateClear)
  else
    Result := Add(TShape.CreateClear);
  AShapeData.CalcBounds;
  Items[Count - 1].FShapeData := AShapeData;
end;

function TShapeList.CanvasDistance(iRecord: Integer; P: TfrxPoint): Extended;
begin
  case Items[iRecord].ShapeType of
    stPoint:
      Result := Distance(CanvasPoint(iRecord), P);
    stPolyLine:
      Result := DistancePolyline(CanvasPoly(iRecord), P);
    stPolygon:
      Result := DistancePolygon(CanvasPoly(iRecord), P);
    stRect:
      Result := DistanceRect(CanvasRect(iRecord), P);
    stDiamond:
      Result := DistanceDiamond(CanvasRect(iRecord), P);
    stEllipse:
      Result := DistanceEllipse(CanvasRect(iRecord), P);
    stPicture, stLegend:
      Result := DistancePicture(CanvasRect(iRecord), P);
    stTemplate:
      Result := DistanceTemplate(CanvasPoly(iRecord), P);
    stMultiPoint:
      Result := DistanceMultiPoint(CanvasMatrix(iRecord), P);
    stMultiPolyLine:
      Result := DistanceMultiPolyline(CanvasMatrix(iRecord), P);
    stMultiPolygon:
      Result := DistanceMultiPolygon(CanvasMatrix(iRecord), P);
  else
    raise Exception.Create('Unknown ShapeType');
  end;
end;

function TShapeList.CanvasMatrix(iRecord: Integer): TDoublePointMatrix;
var
  iPart, iPoint : Integer;
begin
  SetLength(Result, Items[iRecord].FShapeData.PartCount);
  for iPart := 0 to High(Result) do
  begin
    SetLength(Result[iPart], Items[iRecord].FShapeData.MultiLineCount[iPart]);
    for iPoint := 0 to High(Result[iPart]) do
      Result[iPart, iPoint] :=
        DoublePoint(FConverter.Transform(Data(iRecord, iPart, iPoint)));
  end;
end;

function TShapeList.CanvasPoint(iRecord: Integer): TfrxPoint;
begin
  Result := FConverter.Transform(Items[iRecord].FShapeData.Point);
end;

function TShapeList.CanvasPoly(iRecord: Integer): TDoublePointArray;
var
  i: Integer;
begin
  SetLength(Result, Items[iRecord].FShapeData.MultiLineCount[0]);
  for i := 0 to High(Result) do
    Result[i] := DoublePoint(FConverter.Transform(Data(iRecord, 0, i)));
end;

function TShapeList.CanvasRect(iRecord: Integer): TDoubleRect;
begin
  Result := Items[iRecord].FShapeData.Rect;
  Result.TopLeft := DoublePoint(FConverter.Transform(Result.TopLeft));
  Result.BottomRight := DoublePoint(FConverter.Transform(Result.BottomRight));
end;

function TShapeList.CanvasWidestPartBounds(iRecord: Integer): TfrxRect;
begin
  Result := FConverter.TransformRect(Items[iRecord].FShapeData.WidestPartBounds);
end;

procedure TShapeList.ClearValues;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Value := NaN;
end;

constructor TShapeList.Create(Converter: TMapToCanvasCoordinateConverter);
begin
  FConverter := Converter;
  OwnsObjects := True;
  FValidMapRect := False;
  FAdjustableShape := False;
  inherited Create;
end;

function TShapeList.Data(iRecord, iPart, iPoint: Integer): TDoublePoint;
begin
  Result := Items[iRecord].FShapeData.MultiLine[iPart, iPoint];
end;

procedure TShapeList.GetColumnList(List: TStrings);
var
  iRecord: Integer;
begin
  for iRecord := 0 to Count - 1 do
    Items[iRecord].FShapeData.IsGetColumnList(List);
end;

function TShapeList.GetShape(Index: Integer): TShape;
begin
  Result := (inherited Items[Index]) as TShape;
end;

function TShapeList.IsCanvasPolyPoints(iRecord, iPart: Integer; MapAccuracy, PixelAccuracy: Extended; var PolyPoints: TPointArray): boolean;
var
  iPoint, UsedCount: Integer;
  Points: TDoublePointArray;
begin
  Result := False;

  Items[iRecord].FShapeData.GetPolyPoints(Points, iPart); // Get Map points
  UsedCount := Length(Points);

  Simplify(Points, MapAccuracy, UsedCount);
  if UsedCount < 2 then
    Exit;

  for iPoint := 0 to UsedCount - 1 do // Get Canvas points
    with FConverter.Transform(Points[iPoint]) do
      Points[iPoint] := DoublePoint(X, Y);

  Simplify(Points, PixelAccuracy, UsedCount);
  if UsedCount < 2 then
    Exit;

  SetLength(PolyPoints, UsedCount);
  for iPoint := 0 to UsedCount - 1 do
    with Points[iPoint] do
      PolyPoints[iPoint] := Point(Round(X), Round(Y));

  Finalize(Points);
  Result := True;
end;

function TShapeList.IsGetValues(var Values: TDoubleArray): boolean;
var
  i, ValuesCount: Integer;
begin
  SetLength(Values, Count);
  ValuesCount := 0;
  for i := 0 to Count - 1 do
    if not Items[i].IsValueEmpty then
    begin
      Values[ValuesCount] := Items[i].Value;
      ValuesCount := ValuesCount + 1;
    end;
  SetLength(Values, ValuesCount);
  Result := ValuesCount <> 0;
end;

function TShapeList.IsHasLegend(FieldName, Legend: String; out iRecord: Integer): boolean;
begin
  iRecord := 0;
  while iRecord <= Count - 1 do
    if Legend = Items[iRecord].FShapeData.Legend[FieldName] then
      Break
    else
      iRecord := iRecord + 1;
  Result := iRecord <= Count - 1;
end;

function TShapeList.IsInside(iRecord: Integer; P: TfrxPoint): Boolean;
begin
  case Items[iRecord].ShapeType of
    stPoint:
      Result := False;
    stPolyLine:
      Result := IsInsidePolyline(CanvasPoly(iRecord), P);
    stPolygon:
      Result := IsInsidePolygon(CanvasPoly(iRecord), P);
    stRect, stPicture, stLegend:
      Result := IsInsideRect(CanvasRect(iRecord), P);
    stDiamond:
      Result := IsInsideDiamond(CanvasRect(iRecord), P);
    stEllipse:
      Result := IsInsideEllipse(CanvasRect(iRecord), P);
    stTemplate:
      Result := IsInsidePolygon(CanvasPoly(iRecord), P);
    stMultiPoint:
      Result := False;
    stMultiPolyLine:
      Result := IsInsideMultiPolyline(CanvasMatrix(iRecord), P);
    stMultiPolygon:
      Result := IsInsideMultiPolygon(CanvasMatrix(iRecord), P);
  else
    raise Exception.Create('Unknown ShapeType');
  end;
end;

function TShapeList.IsValidMapRect(out MapRect: TfrxRect): boolean;
begin
  Result := FValidMapRect;
  if Result then
    MapRect := frxRect(FXMin, FYMin, FXMax, FYMax);
end;

procedure TShapeList.Read(Reader: TReader);
var
  SavedCount, i: Integer;
  Shape: TShape;
begin
  FValidMapRect := Reader.ReadBoolean;
  FXMin := Reader.ReadFloat;
  FXMax := Reader.ReadFloat;
  FYMin := Reader.ReadFloat;
  FYMax := Reader.ReadFloat;
  EmbeddedData := Reader.ReadBoolean;
  SavedCount := Reader.ReadInteger;

  if EmbeddedData then
  begin
    Clear;

    for i := 0 to SavedCount - 1 do
    begin
      if AdjustableShape then
        Shape := TAdjustableShape.CreateClear
      else
        Shape := TShape.CreateClear;
      Shape.Read(Reader);
      Shape.ReadData(Reader);
      Add(Shape);
    end;
  end
  else
    for i := 0 to Count - 1 do
      Items[i].Read(Reader);
end;

procedure TShapeList.ReadDFM(Stream: TStream);
var
  Reader: TReader;
begin
  Reader := TReader.Create(Stream, 4096);
  Read(Reader);
  Reader.Free;
end;

procedure TShapeList.ReplaceShapeData(iRecord: Integer; const AShapeData: TShapeData);
begin
  AShapeData.CalcBounds;
  Items[iRecord].FShapeData.Free;
  Items[iRecord].FShapeData := AShapeData;
end;

procedure TShapeList.SaveToTextFile(FileName: String);
  function ShapeTypeName(ShapeType: TShapeType): String;
  begin
    case ShapeType of
      stNone: Result := 'Unknown';
      stPoint: Result := 'Point';
      stPolyLine: Result := 'PolyLine';
      stPolygon: Result := 'Polygon';
      stRect: Result := 'Rect';
      stDiamond: Result := 'Diamond';
      stEllipse: Result := 'Ellipse';
      stPicture: Result := 'Picture';
      stLegend: Result := 'Legend';
      stTemplate: Result := 'Template';
      stMultiPoint: Result := 'MultiPoint';
      stMultiPolyLine: Result := 'MultiPolyLine';
      stMultiPolygon: Result := 'MultiPolygon';
    end;
  end;
var
  F: TextFile;
  iShape, iPart, iPoint: Integer;
begin
  AssignFile(F, FileName);
  if FileExists(FileName) then
  begin
    Append(F)
  end
  else
    Rewrite(F);

  WriteLn(F, 'Count: ' + IntToStr(Count));
  for iShape := 0 to Count - 1 do
    with Items[iShape] do
    begin
      WriteLn(F, '  ' + ShapeTypeName(ShapeData.ShapeType) + ' PartCount: ' + IntToStr(ShapeData.PartCount));
      for iPart := 0 to ShapeData.PartCount - 1 do
      begin
        System.Write(F, '    MultiLineCount: ' + IntToStr(ShapeData.MultiLineCount[iPart]) + '  ');
        for iPoint := 0 to ShapeData.MultiLineCount[iPart] - 1 do
          with ShapeData.MultiLine[iPart, iPoint] do
            System.Write(F, FloatToStr(X) + ' ' + FloatToStr(Y) + ',');
        WriteLn(F);
      end;
    end;
  CloseFile(F);
end;

procedure TShapeList.SetMapRect(XMin, XMax, YMin, YMax: Extended);
begin
  FXMin := XMin;
  FXMax := XMax;
  FYMin := YMin;
  FYMax := YMax;
  FValidMapRect := True;
end;

procedure TShapeList.SetMapRectByData;
const
  Margin = 0.05;
var
  TotalBounds: TfrxRect;
  iRecord, iPart, iPoint: Integer;
  dWidth, dHeight: Extended;
begin
  if Count > 0 then
  begin
    with Items[0].FShapeData.Point do
      TotalBounds := frxRect(X, Y, X, Y);
    for iRecord := 0 to Count - 1 do
      case Items[iRecord].FShapeData.ShapeType of
        stPoint:
          ExpandRect(TotalBounds, Items[iRecord].FShapeData.Point);
      else
        for iPart := 0 to Items[iRecord].FShapeData.PartCount - 1 do
          for iPoint := 0 to Items[iRecord].FShapeData.MultiLineCount[iPart] - 1 do
            ExpandRect(TotalBounds, Data(iRecord, iPart, iPoint));
      end;
    dWidth := RectWidth(TotalBounds) * Margin;
    dHeight := RectHeight(TotalBounds) * Margin;
    with TotalBounds do
      SetMapRect(Left - dWidth, Right + dWidth, Top - dHeight, Bottom + dHeight);
  end
  else
    FValidMapRect := False;
end;

procedure TShapeList.SetShape(Index: Integer; const AShape: TShape);
begin
  inherited Items[Index] := AShape;
end;

procedure TShapeList.Write(Writer: TWriter);
var
  i: Integer;
begin
  Writer.WriteBoolean(FValidMapRect);
  Writer.WriteFloat(FXMin);
  Writer.WriteFloat(FXMax);
  Writer.WriteFloat(FYMin);
  Writer.WriteFloat(FYMax);
  Writer.WriteBoolean(EmbeddedData);
  Writer.WriteInteger(Count);
  for i := 0 to Count - 1 do
  begin
    Items[i].Write(Writer);
    if EmbeddedData then
      Items[i].WriteData(Writer);
  end;
end;

procedure TShapeList.WriteDFM(Stream: TStream);
var
  Writer: TWriter;
begin
  Writer := TWriter.Create(Stream, 4096);
  Write(Writer);
  Writer.Free;
end;

{ TShapeStyle }

constructor TShapeStyle.Create;
begin
  FBorderColor := clBlack;
  FBorderStyle := psSolid;
  FBorderWidth := 1;
  FFillColor := clWhite;
  FPointSize := 10;
end;

procedure TShapeStyle.TunePen(Pen: TPen);
begin
  Pen.Color := BorderColor;
  Pen.Width := BorderWidth;
  Pen.Style := BorderStyle;
end;

{ TOSMShapeList }

constructor TOSMShapeList.CreateFromFile(FileName: String; Converter: TMapToCanvasCoordinateConverter;
  FileList: TOSMFileList; LayerTags: TStrings);
var
  OSMFile: TOSMFile;
begin
  inherited Create(Converter);
  FAdjustableShape := True;

  OSMFile := FileList.FileByName(FileName);

  LoadData(OSMFile, LayerTags);

  SetMapRect(OSMFile.Xmin, OSMFile.Xmax, OSMFile.Ymin, OSMFile.Ymax);
end;

procedure TOSMShapeList.LoadData(OSMFile: TOSMFile; LayerTags: TStrings);

  procedure LoadPoints(OSMFile: TOSMFile);
  var
    iNode: integer;
  begin
    for iNode := 0 to OSMFile.CountOfNodes - 1 do
      with OSMFile.Nodes[iNode] do
        if (Tags.Count > 0) and IsHaveAnyTag(LayerTags) then
          AddShapeData(TShapeData.CreatePoint(Tags, Longitude, Latitude));
  end;

  procedure LoadPolys(OSMFile: TOSMFile);
  var
    iWay, iNode, iCount: integer;
    FShapeData: TShapeData;
    DP: TDoublePoint;
  begin
    for iWay := 0 to OSMFile.CountOfWays - 1 do
      with OSMFile.Ways[iWay] do
        if IsHaveAnyTag(LayerTags) then
        begin
          FShapeData := TShapeData.CreatePoly(ShapeType, Tags, Count);
          iCount := 0;
          for iNode := 0 to Count - 1 do
            if OSMFile.IsGetNodeAsPoint(iWay, iNode, DP) then
            begin
              FShapeData.MultiLine[0, iCount] := DP;
              Inc(iCount);
            end;
          FShapeData.MultiLineCount[0] := iCount;
          AddShapeData(FShapeData);
        end;
  end;

begin
  LoadPolys(OSMFile);
  LoadPoints(OSMFile);
end;

{ TGPXShapeList }

constructor TGPXShapeList.CreateFromFile(FileName: String; Converter: TMapToCanvasCoordinateConverter);
var
  GPXFile: TGPXFile;
begin
  inherited Create(Converter);
  FAdjustableShape := True;

  GPXFile := TGPXFile.Create(FileName);

  LoadData(GPXFile);

  if GPXFile.IsValidBounds then
    SetMapRect(GPXFile.Xmin, GPXFile.Xmax, GPXFile.Ymin, GPXFile.Ymax)
  else
    SetMapRectByData;

  GPXFile.Free;
end;

procedure TGPXShapeList.LoadData(GPXFile: TGPXFile);

  procedure LoadPoints(GPXFile: TGPXFile);
  var
    iWayPoint: integer;
  begin
    for iWayPoint := 0 to GPXFile.CountOfWayPoints - 1 do
      with GPXFile.WayPoints[iWayPoint] do
        AddShapeData(TShapeData.CreatePoint(Tags, Longitude, Latitude));
  end;

  procedure LoadPolys(GPXFile: TGPXFile);
  var
    iTrack, iTrackSegment, iPoint: integer;
    FShapeData: TShapeData;
    DPA: TDoublePointArray;
  begin
    for iTrack := 0 to GPXFile.CountOfTracks - 1 do
      with GPXFile.Tracks[iTrack] do
      begin
        FShapeData := TShapeData.CreateFull(Count, ShapeType, Tags);
        for iTrackSegment := 0 to Count - 1 do
        begin
          GetSegmentPoints(iTrackSegment, DPA);
          FShapeData.MultiLineCount[iTrackSegment] := Length(DPA);
          for iPoint := 0 to High(DPA) do
            FShapeData.MultiLine[iTrackSegment, iPoint] := DPA[iPoint];
        end;
        AddShapeData(FShapeData);
      end;
  end;

begin
  LoadPolys(GPXFile);
  LoadPoints(GPXFile);
end;

{ TERSIShapeList }

constructor TERSIShapeList.CreateFromFile(FileName: String; Converter: TMapToCanvasCoordinateConverter);
var
  ERSIShapeFile: TERSIShapeFile;
begin
  inherited Create(Converter);
  FAdjustableShape := True;

  ERSIShapeFile := TERSIShapeFile.Create(FileName);

  LoadData(ERSIShapeFile);

  SetMapRect(ERSIShapeFile.Xmin, ERSIShapeFile.Xmax, ERSIShapeFile.Ymin, ERSIShapeFile.Ymax);

  ERSIShapeFile.Free;
end;

procedure TERSIShapeList.LoadData(ERSIFile: TERSIShapeFile);

  procedure AddPoint(Tags: TStringList; X, Y: Double);
  begin
    AddShapeData(TShapeData.CreatePoint(Tags, X, Y));
  end;

  procedure AddMultiPoint(iRecord: Integer; Tags: TStringList);
  var
    iPoint: Integer;
    FShapeData: TShapeData;
  begin
    FShapeData := TShapeData.CreateFull(1, stMultiPoint, Tags);
    FShapeData.MultiPointCount := ERSIFile.MultiPointCount[iRecord];

    for iPoint := 0 to High(FShapeData.MultiPointCount) do
      FShapeData.MultiPoint[iPoint] := ERSIFile.MultiPoint[iRecord, iPoint];
    AddShapeData(FShapeData);
  end;

  procedure AddPoly(iRecord: Integer; ST: TShapeType; Tags: TStringList);
  var
    Count, iPart, iPoint: Integer;
    DPA: TDoublePointArray;
    FShapeData: TShapeData;
  begin
    Count := ERSIFile.PolyPartsCount[iRecord];
    FShapeData := TShapeData.CreateFull(Count, ST, Tags);
    for iPart := 0 to Count - 1 do
    begin
      ERSIFile.GetPartPoints(DPA, iRecord, iPart);
      FShapeData.MultiLineCount[iPart] := Length(DPA);
      for iPoint := 0 to High(DPA) do
        FShapeData.MultiLine[iPart, iPoint] := DPA[iPoint];
    end;
    AddShapeData(FShapeData);
  end;

var
  iRecord, iColumn: Integer;
  Tags, Columns: TStringList;
begin
  Columns := TStringList.Create;
  ERSIFile.GetColumnList(Columns);
  for iRecord := 0 to ERSIFile.RecordCount - 1 do
  begin
    Tags := TStringList.Create;
    for iColumn := 0 to Columns.Count - 1 do
      Tags.Add(Columns[iColumn] + Tags.NameValueSeparator + ERSIFile.LegendToString[iColumn, iRecord]);
    case ERSIFile.ERSIShapeType[iRecord] of
      ERSI_Point:
        with ERSIFile.Point[iRecord] do
          AddPoint(Tags, X, Y);
      ERSI_PolyLine:
        if Count > 1 then AddPoly(iRecord, stMultiPolyLine, Tags)
        else              AddPoly(iRecord, stPolyLine, Tags);
      ERSI_Polygon:
        if Count > 1 then AddPoly(iRecord, stMultiPolygon, Tags)
        else              AddPoly(iRecord, stPolygon, Tags);
      ERSI_MultiPoint:
        AddMultiPoint(iRecord, Tags);
    end;
    Tags.Free;
  end;
  Columns.Free;
end;

{ TOSMFileList }

procedure TOSMFileList.AddFile(FileName: String);
var
  i: Integer;
begin
  if not Find(SafeFileName(FileName), i) then
    AddObject(SafeFileName(FileName), TOSMFile.Create(FileName))
end;

constructor TOSMFileList.Create;
begin
  inherited;
  Sorted := True;
  Duplicates := dupError;
end;

destructor TOSMFileList.Destroy;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Objects[i].Free;
  inherited;
end;

function TOSMFileList.FileByName(FileName: String): TOSMFile;
var
  Index: integer;
begin
  if Find(SafeFileName(FileName), Index) then
    Result := Objects[Index] as TOSMFile
  else
    Result := nil;
end;

end.
