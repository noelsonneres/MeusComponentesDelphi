
{******************************************}
{                                          }
{              FastReport v6.0             }
{            Map Geo Data Layer            }
{                                          }
{            Copyright (c) 2018            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapGeodataLayer;

interface

{$I frx.inc}

uses
  Classes, Graphics,
  frxMapLayer, frxMapHelpers, frxClass, frxMapShape;

type
  TGeoDataKind = (gdWKT, gdWKB);

  TfrxMapGeodataLayer = class (TfrxCustomLayer)
  private
    FBorderColorColumn: String;
    FFillColorColumn: String;
    FDataColumn: String;
    FGeoDataKind: TGeoDataKind;
    FMapDataSet: TfrxDataSet;
  protected
    function GetSelectedShapeName: String; override; // Similarly TfrxMapFileLayer
    function GetSelectedShapeValue: String; override; // Similarly TfrxMapFileLayer
    procedure InitialiseData; override;
    procedure LoadShapes;
    function IsCanGetData: Boolean; override;
    function IsWideText: Boolean;
    procedure LoadGeoData(MemoryStream: TMemoryStream; Tags: TStringList);

    procedure AddValueList(vaAnalyticalValue: Variant); override; // Similarly TfrxMapFileLayer
    function IsSpecialBorderColor(iRecord: Integer; out SpecialColor: TColor): Boolean; override;
    function IsSpecialFillColor(iRecord: Integer; out SpecialColor: TColor): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure GetColumnList(List: TStrings); override;
  published
    property ShowLines;
    property ShowPoints;
    property ShowPolygons;
    property LabelColumn;
    property SpatialColumn;
    property MapAccuracy;
    property PixelAccuracy;

    property MapDataSet: TfrxDataSet read FMapDataSet write FMapDataSet;
    property BorderColorColumn: String read FBorderColorColumn write FBorderColorColumn;
    property FillColorColumn: String read FFillColorColumn write FFillColorColumn;
    property DataColumn: String read FDataColumn write FDataColumn;
    property GeoDataKind: TGeoDataKind read FGeoDataKind write FGeoDataKind;
    property SpatialValue;
  end;

implementation

uses
  Math, Contnrs, Types, Variants, SysUtils,
  frxMap, frxAnaliticGeometry, frxDsgnIntf, frxUtils;

type
  TfrxCustomDBDataSetHelper = class(TfrxCustomDBDataSet)
  public
    property Fields;
  end;

  TAnsiCharSet = set of AnsiChar;

const
  Numeric: TAnsiCharSet = ['+', '-', '.', '0'..'9'];
  Literal: TAnsiCharSet = ['a'..'z', 'A'..'Z'];

type
  TReaderWKx = class
  private
  protected
    FStream: TStream;
    FData: TDoublePointArray;

    function GetData(Index: Integer): TDoublePoint;
    function GetCount: Integer; virtual; abstract;
    function EndOfStream: Boolean;
  public
    destructor Destroy; override;

    function ReadDouble: Double; virtual; abstract;
    function ReadDoublePoint: TDoublePoint; virtual;
    procedure ReadDoublePointArray; virtual; abstract;

    property Data[Index: Integer]: TDoublePoint read GetData;
    property Count: Integer read GetCount;
  end;

  TGeoDataLoaderWKx = class
  private
  protected
    FStream: TStream;
    FShapes: TShapeList;
    FTags: TStringList;
    FReaderWKx: TReaderWKx;

    procedure FillShapeDataPart(ShapeData: TShapeData);
    procedure ReadAddFillPart(ShapeData: TShapeData);

    procedure LoadPointShape;
    procedure LoadLineStringShape;
  public
    constructor Create(Stream: TStream; Shapes: TShapeList; Tags: TStringList);
    destructor Destroy; override;

    procedure LoadShapes; virtual; abstract;
  end;

// WKT / WKB - http://www.opengeospatial.org/standards/sfa
  TReaderWKT = class(TReaderWKx)
  private
    FNextChar: AnsiChar;
    FCount: Integer;
  protected
    FWideText: Boolean;

    function GetCount: Integer; override;
  public
    constructor Create(Stream: TStream; WideText: Boolean);

    function ReadNext: AnsiChar;
    function ReadWhile(Suitable: TAnsiCharSet): AnsiString;
    function ReadUntil(UnSuitable: TAnsiCharSet): AnsiString;

    function ReadDouble: Double; override;
    function ReadDoublePoint: TDoublePoint; override;
    procedure ReadDoublePointArray; override;

    property NextChar: AnsiChar read FNextChar;
  end;

  TGeoDataLoaderWKT = class (TGeoDataLoaderWKx)
  protected
    function ReaderWKT: TReaderWKT;

    procedure LoadMultiPointShape;
    procedure LoadMultiLineStringShape;
    procedure LoadPolygonShape;
    procedure LoadMultiPoligonShape;
  public
    constructor Create(Stream: TStream; Shapes: TShapeList;
      Tags: TStringList; WideText: Boolean);
    procedure LoadShapes; override;
  end;

  TReaderWKB = class(TReaderWKx)
  private
  protected
    FBigEndian: Boolean;
    FGeometry: LongWord;
    FHexString: String;

    function GetCount: Integer; override;

    function SwapLongWord(Value: LongWord): LongWord;
    function SwapDouble(Value: Double): Double;
    function ReadByte: Byte;
    function ReadLongWord: LongWord;

    procedure StreamToHex;
  public
    constructor Create(Stream: TStream);

    function ReadDouble: Double; override;
    procedure ReadDoublePointArray; override;
    procedure ReadEndiannessAndGeomety;
  end;

  TGeoDataLoaderWKB = class (TGeoDataLoaderWKx)
  protected
    function ReaderWKB: TReaderWKB;

    procedure LoadMultiPointShape;
    procedure LoadMultiLineStringShape;
    procedure LoadPolygonShape;
    procedure LoadMultiPoligonShape;
  public
    constructor Create(Stream: TStream; Shapes: TShapeList; Tags: TStringList);
    procedure LoadShapes; override;
  end;

{ TfrxMapGeodataLayer }

procedure TfrxMapGeodataLayer.AddValueList(vaAnalyticalValue: Variant);
var
  vaSpatialValue: Variant;
begin
  vaSpatialValue := Report.Calc(SpatialValue);
  if not VarIsNull(vaSpatialValue) then
    FValuesList.AddValue(VarToStr(vaSpatialValue), vaAnalyticalValue);
end;

constructor TfrxMapGeodataLayer.Create(AOwner: TComponent);
begin
  inherited;

  FLabelColumn := '';
  FSpatialColumn := '';

  FMapAccuracy := 0.0;
  FPixelAccuracy := 0.0;

  FShapes := TShapeList.Create(FConverter);
  FShapes.EmbeddedData := True;

  FBorderColorColumn := '';
  FFillColorColumn := '';
  FDataColumn := '';

end;

procedure TfrxMapGeodataLayer.GetColumnList(List: TStrings);
begin
  if MapDataSet <> nil then
    MapDataSet.GetFieldList(List);
end;

function TfrxMapGeodataLayer.GetSelectedShapeName: String;
begin
  if (SelectedShapeIndex = Unknown) or (FShapes = nil) or (LabelColumn = '') then
    Result := inherited GetSelectedShapeName
  else
    Result := GetShapeName(LabelColumn, SelectedShapeIndex);
end;

function TfrxMapGeodataLayer.GetSelectedShapeValue: String;
begin
  if (SelectedShapeIndex = Unknown) or (FShapes = nil) then
    Result := inherited GetSelectedShapeValue
  else
    Result := GetShapeValue(SelectedShapeIndex);
end;

procedure TfrxMapGeodataLayer.InitialiseData;
begin
  inherited InitialiseData;
  FShapes.Clear;
  if (MapDataSet <> nil) and (Trim(DataColumn) <> '') and not IsDesigning then
    LoadShapes;
end;

function TfrxMapGeodataLayer.IsCanGetData: Boolean;
begin
  Result := inherited IsCanGetData
    and not IsDesigning
    and (Trim(SpatialValue) <> '');
end;

function TfrxMapGeodataLayer.IsSpecialBorderColor(iRecord: Integer; out SpecialColor: TColor): Boolean;
var
  stColor: String;
begin
  Result := (BorderColorColumn <> '');
  if Result then
  begin
    stColor := FShapes[iRecord].Legend[BorderColorColumn];
    Result := (stColor <> '') and TryStrToInt(stColor, Integer(SpecialColor));
  end;
end;

function TfrxMapGeodataLayer.IsSpecialFillColor(iRecord: Integer; out SpecialColor: TColor): Boolean;
var
  stColor: String;
begin
  Result := (FillColorColumn <> '');
  if Result then
  begin
    stColor := FShapes[iRecord].Legend[FillColorColumn];
    Result := (stColor <> '') and TryStrToInt(stColor, Integer(SpecialColor));
  end;
end;

function TfrxMapGeodataLayer.IsWideText: Boolean;
begin
  Result := False;
  if Assigned(MapDataSet) then
    Result := MapDataSet.IsWideMemoBlobField(DataColumn);
end;

procedure TfrxMapGeodataLayer.LoadGeoData(MemoryStream: TMemoryStream; Tags: TStringList);
var
  Loader: TGeoDataLoaderWKx;
begin
  case GeoDataKind of
    gdWKT:
      Loader := TGeoDataLoaderWKT.Create(MemoryStream, FShapes, Tags, IsWideText);
    gdWKB:
      Loader := TGeoDataLoaderWKB.Create(MemoryStream, FShapes, Tags);
  else
    raise Exception.Create('Unknown GeoDataKind');
  end;

  try
    Loader.LoadShapes;
  finally
    Loader.Free;
  end;
end;

procedure TfrxMapGeodataLayer.LoadShapes;
var
  MemoryStream: TMemoryStream;
  Tags: TStringList;
  i: Integer;
begin
  MapDataSet.First;
  while not MapDataSet.Eof do
  begin
    if (Trim(Filter) = '') or (Report.Calc(Filter) = True {Because Report.Calc: Variant}) then
      if MapDataSet.IsBlobField(DataColumn) then
      begin
        Tags := TStringList.Create;
        MapDataSet.GetFieldList(Tags);
        try
          for i := 0 to MapDataSet.FieldsCount - 1 do
            Tags[i] := Tags[i] + Tags.NameValueSeparator + MapDataSet.DisplayText[Tags[i]];
          MemoryStream := TMemoryStream.Create;
          try
            MapDataSet.AssignBlobTo(DataColumn, MemoryStream);
            LoadGeoData(MemoryStream, Tags);
          finally
            MemoryStream.Free;
          end;
        finally
          Tags.Free;
        end
      end;
    MapDataSet.Next;
  end;
  FShapes.SetMapRectByData;
//  FShapes.SaveToTextFile(ExtractFilePath(Paramstr(0)) + 'Shapes.txt'); { TODO : Debug }
end;

{ TGeoDataLoaderWKT }

constructor TGeoDataLoaderWKT.Create(Stream: TStream; Shapes: TShapeList; Tags: TStringList; WideText: Boolean);
begin
  inherited Create(Stream, Shapes, Tags);
  FReaderWKx := TReaderWKT.Create(Stream, WideText);
end;

procedure TGeoDataLoaderWKT.LoadMultiLineStringShape;
var
  ShapeData: TShapeData;
begin
  ReaderWKT.ReadNext; // '('
  ShapeData := TShapeData.CreateEmpty(stMultiPolyLine, FTags);

  repeat
    ReadAddFillPart(ShapeData);

    ReaderWKT.ReadNext; // Second ')' or ','
  until ReaderWKT.EndOfStream or (ReaderWKT.NextChar = ')');

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKT.LoadMultiPointShape;
var
  ShapeData: TShapeData;
begin
  ReaderWKT.ReadNext; // '('
  ShapeData := TShapeData.CreateEmpty(stMultiPoint, FTags);

  ReadAddFillPart(ShapeData);

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKT.LoadMultiPoligonShape;
var
  ShapeData: TShapeData;
begin
  ReaderWKT.ReadNext; // '('
  ShapeData := TShapeData.CreateEmpty(stMultiPolygon, FTags);

  repeat
    ReaderWKT.ReadNext; // Second '('
    repeat
      ReadAddFillPart(ShapeData);

      ReaderWKT.ReadNext; // Second ')' or ','
    until ReaderWKT.EndOfStream or (ReaderWKT.NextChar = ')');

    ReaderWKT.ReadNext; // )' or ','
  until ReaderWKT.EndOfStream or (ReaderWKT.NextChar = ')');

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKT.LoadPolygonShape;
var
  ShapeData: TShapeData;
begin
  ReaderWKT.ReadNext; // Second '('
  ShapeData := TShapeData.CreateEmpty(stPolygon, FTags);

  repeat
    ReadAddFillPart(ShapeData);

    ReaderWKT.ReadNext; // Second ')' or ','
  until ReaderWKT.EndOfStream or (ReaderWKT.NextChar = ')');

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKT.LoadShapes;
var
  Geometry: AnsiString;
begin
  if ReaderWKT.EndOfStream then
    Exit;

  ReaderWKT.ReadUntil(Literal);
  Geometry := ReaderWKT.ReadWhile(Literal);
  ReaderWKT.ReadUntil(['(']);

  if      Geometry = 'POINT' then
    LoadPointShape
  else if Geometry = 'LINESTRING' then
    LoadLineStringShape
  else if Geometry = 'POLYGON' then
    LoadPolygonShape
  else if Geometry = 'MULTIPOINT' then
    LoadMultiPointShape
  else if Geometry = 'MULTILINESTRING' then
    LoadMultiLineStringShape
  else if Geometry = 'MULTIPOLYGON' then
    LoadMultiPoligonShape
  else
    raise Exception.Create('Unknown Geometry: ' + String(Geometry));
end;

function TGeoDataLoaderWKT.ReaderWKT: TReaderWKT;
begin
  Result := TReaderWKT(FReaderWKx);
end;

{ TGeoDataLoaderWKx }

constructor TGeoDataLoaderWKx.Create(Stream: TStream; Shapes: TShapeList; Tags: TStringList);
begin
  FStream := Stream;
  Stream.Position := 0;
  FShapes := Shapes;
  FTags := Tags;
end;

destructor TGeoDataLoaderWKx.Destroy;
begin
  FReaderWKx.Free;
  inherited;
end;

procedure TGeoDataLoaderWKx.FillShapeDataPart(ShapeData: TShapeData);
var
  i, iPart: Integer;
begin
  iPart := ShapeData.PartCount - 1;
  for i := 0 to FReaderWKx.Count - 1 do
    ShapeData.MultiLine[iPart, i] := FReaderWKx.Data[i];
end;

procedure TGeoDataLoaderWKx.LoadLineStringShape;
var
  ShapeData: TShapeData;
begin
  ShapeData := TShapeData.CreateEmpty(stPolyLine, FTags);

  ReadAddFillPart(ShapeData);

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKx.LoadPointShape;
begin
  with FReaderWKx.ReadDoublePoint do
    FShapes.AddShapeData(TShapeData.CreatePoint(FTags, X, Y));
end;

procedure TGeoDataLoaderWKx.ReadAddFillPart(ShapeData: TShapeData);
begin
  FReaderWKx.ReadDoublePointArray;
  ShapeData.AddPart(FReaderWKx.Count);
  FillShapeDataPart(ShapeData);
end;

{ TReaderWKT }

constructor TReaderWKT.Create(Stream: TStream; WideText: Boolean);
begin
  FStream := Stream;
  FWideText := WideText;
  FStream.Position := 0;
  ReadNext;
  FCount := 0;
  SetLength(FData, 1024);
end;

function TReaderWKT.GetCount: Integer;
begin
  Result := FCount;
end;

function TReaderWKT.ReadDouble: Double;
var
  Number: AnsiString;
begin
  ReadUntil(Numeric);
  Number := ReadWhile(Numeric);
  Result := frxStrToFloat(String(Number));
end;

function TReaderWKT.ReadDoublePoint: TDoublePoint;
var
  InBrackets: Boolean;
begin
  InBrackets := NextChar = '(';

  Result := inherited ReadDoublePoint;

  if InBrackets then
    ReadNext; // Skip ')'
end;

procedure TReaderWKT.ReadDoublePointArray;
begin
  FCount := 0;
  while not EndOfStream and (NextChar <> ')') do
  begin
    if Count > High(FData) then
      SetLength(FData, Length(FData) * 2);
    FData[Count] := ReadDoublePoint;
    Inc(FCount);
  end;
end;

function TReaderWKT.ReadNext: AnsiChar;
var
  WCh: WideChar;
begin
  if FWideText then
  begin
    FStream.Read(WCh, 2);
    FNextChar := AnsiChar(WCh);
  end
  else
    FStream.Read(FNextChar, 1);
  Result := NextChar;
end;

function TReaderWKT.ReadUntil(UnSuitable: TAnsiCharSet): AnsiString;
begin
  Result := '';
  while not EndOfStream and not (NextChar in UnSuitable) do
  begin
    Result := Result + NextChar;
    ReadNext;
  end;
end;

function TReaderWKT.ReadWhile(Suitable: TAnsiCharSet): AnsiString;
begin
  Result := '';
  while not EndOfStream and (NextChar in Suitable) do
  begin
    Result := Result + NextChar;
    ReadNext;
  end;
end;

{ TGeoDataLoaderWKB }

constructor TGeoDataLoaderWKB.Create(Stream: TStream; Shapes: TShapeList; Tags: TStringList);
begin
  inherited Create(Stream, Shapes, Tags);
  FReaderWKx := TReaderWKB.Create(Stream);
end;

procedure TGeoDataLoaderWKB.LoadMultiLineStringShape;
var
  ShapeData: TShapeData;
  i: Integer;
  NumLineStrings: LongWord;
begin
  ShapeData := TShapeData.CreateEmpty(stMultiPolyLine, FTags);

  NumLineStrings := ReaderWKB.ReadLongWord;
  for i := 0 to NumLineStrings - 1 do
  begin
    ReaderWKB.ReadEndiannessAndGeomety;

    ReadAddFillPart(ShapeData);
  end;

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKB.LoadMultiPointShape;
var
  ShapeData: TShapeData;
begin
  ShapeData := TShapeData.CreateEmpty(stMultiPoint, FTags);

  ReadAddFillPart(ShapeData);

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKB.LoadMultiPoligonShape;
var
  ShapeData: TShapeData;
  i, iRing: Integer;
  NumPolygons, NumRings: LongWord;
begin
  ShapeData := TShapeData.CreateEmpty(stMultiPolygon, FTags);

  NumPolygons := ReaderWKB.ReadLongWord;
  for i := 0 to NumPolygons - 1 do
  begin
    ReaderWKB.ReadEndiannessAndGeomety;

    NumRings := ReaderWKB.ReadLongWord;
    for iRing := 0 to NumRings - 1 do
      ReadAddFillPart(ShapeData);
  end;

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKB.LoadPolygonShape;
var
  ShapeData: TShapeData;
  iRing: Integer;
  NumRings: LongWord;
begin
  ShapeData := TShapeData.CreateEmpty(stPolygon, FTags);

  NumRings := ReaderWKB.ReadLongWord;
  for iRing := 0 to NumRings - 1 do
    ReadAddFillPart(ShapeData);

  FShapes.AddShapeData(ShapeData);
end;

procedure TGeoDataLoaderWKB.LoadShapes;
const
  wkbPoint = 1;
  wkbLineString = 2;
  wkbPolygon = 3;
  wkbMultiPoint = 4;
  wkbMultiLineString = 5;
  wkbMultiPolygon = 6;
  wkbGeometryCollection = 7;
begin
  ReaderWKB.ReadEndiannessAndGeomety;

  case ReaderWKB.FGeometry of
    wkbPoint:
      LoadPointShape;
    wkbLineString:
      LoadLineStringShape;
    wkbPolygon:
      LoadPolygonShape;
    wkbMultiPoint:
      LoadMultiPointShape;
    wkbMultiLineString:
      LoadMultiLineStringShape;
    wkbMultiPolygon:
      LoadMultiPoligonShape;
  else
    raise Exception.Create('Unknown Geometry: ' + IntToStr(ReaderWKB.FGeometry));
  end;
end;

function TGeoDataLoaderWKB.ReaderWKB: TReaderWKB;
begin
  Result := TReaderWKB(FReaderWKx);
end;

{ TReaderWKB }
constructor TReaderWKB.Create(Stream: TStream);
begin
  FStream := Stream;
  SetLength(FData, 0);
  FStream.Position := 0;

//  StreamToHex; { TODO : Debug HexString}
end;

function TReaderWKB.GetCount: Integer;
begin
  Result := Length(FData);
end;

function TReaderWKB.ReadByte: Byte;
begin
  FStream.ReadBuffer(Result, SizeOf(Result));
end;

function TReaderWKB.ReadDouble: Double;
begin
  FStream.ReadBuffer(Result, SizeOf(Result));
  if FBigEndian then
    Result := SwapDouble(Result);
end;

procedure TReaderWKB.ReadDoublePointArray;
var
  i: Integer;
  NumPoints: LongWord;
begin
  NumPoints := ReadLongWord;
  SetLength(FData, NumPoints);
  for i := 0 to NumPoints - 1 do
    FData[i] := ReadDoublePoint;
end;

procedure TReaderWKB.ReadEndiannessAndGeomety;
begin
  FBigEndian := ReadByte = 0;
  FGeometry := ReadLongWord;
end;

function TReaderWKB.ReadLongWord: LongWord;
begin
  FStream.ReadBuffer(Result, SizeOf(Result));
  if FBigEndian then
    Result := SwapLongWord(Result);
end;

procedure TReaderWKB.StreamToHex;
var
  OldPosition: Int64;
begin
  OldPosition := FStream.Position;

  FHexString := '';
  while not EndOfStream do
    FHexString := FHexString + ToHex(ReadByte);

  FStream.Position := OldPosition;
end;

function TReaderWKB.SwapDouble(Value: Double): Double;
const
  Len = SizeOf(Double);
type
  TSwap = packed record
    case Boolean of
      True: (Value: Double);
      False: (Bytes: array[0..Len - 1] of Byte);
  end;
var
  BigE, LittleE: TSwap;
  i: Integer;
begin
  BigE.Value := Value;
  for i := Len - 1 downto 0 do
    LittleE.Bytes[i] := BigE.Bytes[Len - 1 - i];
  Result := LittleE.Value;
end;

function TReaderWKB.SwapLongWord(Value: LongWord): LongWord;
const
  Len = SizeOf(LongWord);
type
  TSwap = packed record
    case Boolean of
      True: (Value: LongWord);
      False: (Bytes: array[0..Len - 1] of Byte);
  end;
var
  BigE, LittleE: TSwap;
  i: Integer;
begin
  BigE.Value := Value;
  for i := Len - 1 downto 0 do
    LittleE.Bytes[i] := BigE.Bytes[Len - 1 - i];
  Result := LittleE.Value;
end;

{ TReaderWKx }

destructor TReaderWKx.Destroy;
begin
  SetLength(FData, 0);

  inherited;
end;

function TReaderWKx.EndOfStream: Boolean;
begin
  Result := FStream.Position >= FStream.Size;
end;

function TReaderWKx.GetData(Index: Integer): TDoublePoint;
begin
  Result := FData[Index];
end;

function TReaderWKx.ReadDoublePoint: TDoublePoint;
begin
  Result := DoublePoint(ReadDouble, ReadDouble);
end;

initialization

  frxPropertyEditors.Register(TypeInfo(String), TfrxComponent, 'DataColumn', TfrxLabelColumnProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxComponent, 'BorderColorColumn', TfrxLabelColumnProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxComponent, 'FillColorColumn', TfrxLabelColumnProperty);
  RegisterClasses([TfrxMapGeodataLayer]);
  frxObjects.RegisterObject1(TfrxMapGeodataLayer, nil, '', '', 0, 74, [ctNone]);

end.
