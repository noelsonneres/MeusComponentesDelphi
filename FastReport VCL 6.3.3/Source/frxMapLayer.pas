
{******************************************}
{                                          }
{             FastReport v6.0              }
{                Map Layer                 }
{                                          }
{         Copyright (c) 2015 - 2019        }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapLayer;

interface

{$I frx.inc}

uses
  frxClass, Contnrs,
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType, LCLIntf, LCLProc, LazHelper,
{$ENDIF}
  Graphics, Classes, frxMapShape, frxMapHelpers, frxDsgnIntf,
  frxMapColorRangeForm, frxMapSizeRangeForm, frxMapRanges, frxAnaliticGeometry;

type
  TMapOperation = (opSum, opAverage, opMin, opMax, opCount);
  TMapLabelKind = (mlNone, mlName, mlValue, mlNameAndValue);
  TMapPalette = (mpNone, mpLight, mpPastel, mpGrayScale, mpEarth, mpSea, mpBrightPastel);
(******************************************************************************)
  TOperationCalculator = class
  private
    FValue: Extended;
    FCount: Integer;
    FOperation: TMapOperation;
  public
    constructor Create(AOperation: TMapOperation); reintroduce;
    procedure Add(AValue: Extended);
    function Get: Extended;
  end;
(******************************************************************************)
  TValuesList = class(TStringList)
  private
    FOperation: TMapOperation;
    function GetOperationCalculator(Index: integer): TOperationCalculator;
  public
    constructor Create(AOperation: TMapOperation); reintroduce;
    destructor Destroy; override;
    procedure AddValue(SpatialValue: String; AnalyticalValue: Extended);
    function MinValue: Extended;
    function MaxValue: Extended;

    property OperationCalculator[Index: integer]: TOperationCalculator read GetOperationCalculator;
  end;
(******************************************************************************)
  TfrxCustomLayer = class(TfrxComponent)
  private
    FLabelKind: TMapLabelKind;
    FHighlightColor: TColor;
    FSelectedShapeIndex: Integer;
    FAnalyticalValue: String;
    FSpatialValue: String;
    FMapPalette: TMapPalette;
    FOperation: TMapOperation;
    FDataSet: TfrxDataSet;
    FColorRanges: TfrxColorRanges;
    FValueFormat: String;
    FFilter: String;
    FDefaultShapeStyle: TShapeStyle;
    FSizeRanges: TfrxSizeRanges;
    FPointLabelsVisibleAtZoom: Extended;
    FActive: Boolean;
    FShowLines: Boolean;
    FShowPoints: Boolean;
    FShowPolygons: Boolean;

    function GetSelectedShape: TShape;
    function GetColorRangeData: TColorRangeCollection;
    function GetSizeRangeData: TSizeRangeCollection;
  protected
    FLabelColumn: String;
    FSpatialColumn: String;
    FMapAccuracy: Extended;
    FPixelAccuracy: Extended;
    FPreviousSelectedShapeIndex: Integer;

    FValuesList: TValuesList;
    FShapes: TShapeList;
    FConverter: TMapToCanvasCoordinateConverter;
    FMapView: TComponent;
    FActiveHyperlink: Boolean;
    FVectorGraphic: TGraphic;
    FClippingRect: TfrxClippingRect;
{$IFDEF FRX_USE_BITMAP_MAP}
    FClippingMapRect: TfrxClippingRect;
{$ENDIF}
    procedure Draw(Canvas: TCanvas);

    procedure DrawClippedPoint(Canvas: TCanvas; X, Y, Radius: Extended);
    procedure DrawPoint(Canvas: TCanvas; iRecord: Integer);
    procedure DrawMultiPoint(Canvas: TCanvas; iRecord: Integer);
    procedure DrawPointLegend(Canvas: TCanvas; iRecord: Integer);

    procedure DrawPolyLine(Canvas: TCanvas; iRecord: Integer);
    procedure DrawPolygon(Canvas: TCanvas; iRecord: Integer);
    procedure DrawPolyLegend(Canvas: TCanvas; iRecord: Integer);
    procedure DrawTemplate(Canvas: TCanvas; iRecord: Integer);
    procedure DrawRect(Canvas: TCanvas; iRecord: Integer);
    procedure DrawDiamond(Canvas: TCanvas; iRecord: Integer);
    procedure DrawEllipse(Canvas: TCanvas; iRecord: Integer);
    procedure DrawPicture(Canvas: TCanvas; iRecord: Integer);
    procedure DrawLegend(Canvas: TCanvas; iRecord: Integer);
    procedure DrawHighlightFrame(Canvas: TCanvas; iRecord: Integer);

    procedure TunePoint(Canvas: TCanvas; iRecord: Integer; out Radius: Extended);
    procedure TuneBrush(Brush: TBrush; iRecord: Integer);
    procedure TunePen(Pen: TPen; iRecord: Integer);
    procedure SetParent(AParent: TfrxComponent); override;
    procedure InitTransform(iRecord: Integer); virtual; // Empty
    function GetShapeValue(iRecord: Integer): String;
    function GetShapeName(FieldName: String; iRecord: Integer): String;
    function GetShapeLegeng(FieldName: String; iRecord: Integer): String;
    function GetSelectedShapeName: String; virtual;
    function GetSelectedShapeValue: String; virtual;
    function IsHighlightSelectedShape: boolean; virtual;
    function IsHiddenShape(iRecord: Integer): Boolean; virtual; // False;
    procedure GetDesigningData;
    procedure InitialiseData; virtual;
    function IsCanGetData: Boolean; virtual;
    procedure FinaliseData;
    procedure FillRanges(const Values: TDoubleArray);
    procedure ExpandVariables; virtual;
    procedure AddValueList(vaAnalyticalValue: Variant); virtual; abstract;
    function IsIncludeAsRegion(P: TfrxPoint): Boolean; virtual;
    function IsSpecialBorderColor(iRecord: Integer; out SpecialColor: TColor): Boolean; virtual; // False;
    function IsSpecialFillColor(iRecord: Integer; out SpecialColor: TColor): Boolean; virtual; // False;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DefinePrimeProperties(Filer: TFiler); virtual; // Empty
    function GetMetaFile(CanvasSize: TfrxPoint; ActiveHyperlink: Boolean): TMetaFile;

    property SelectedShapeIndex: Integer read FSelectedShapeIndex write FSelectedShapeIndex;
    property MapAccuracy: Extended read FMapAccuracy write FMapAccuracy;
    property PixelAccuracy: Extended read FPixelAccuracy write FPixelAccuracy;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawOn(Canvas: TCanvas; ActiveHyperlink: Boolean; aClipRect: TfrxRect);
    procedure BuildGraphic(CanvasSize: TfrxPoint; ActiveHyperlink: Boolean);
    function IsInclude(P: TfrxPoint): Boolean; virtual;
    procedure GetData;
    function IsHasMapRect(out MapRect: TfrxRect): boolean;
    function IsHasZoomRect(out ZoomRect: TfrxRect): boolean; virtual;
    function IsSelectedShapeChanded: Boolean;
    procedure GetColumnList(List: TStrings); virtual;
    procedure ClearSelectedShape;

    property ClippingRect: TfrxClippingRect read FClippingRect;
    property SelectedShape: TShape read GetSelectedShape;
    property SelectedShapeName: String read GetSelectedShapeName;
    property SelectedShapeValue: String read GetSelectedShapeValue;
    property VectorGraphic: TGraphic read FVectorGraphic;
    property MapView: TComponent read FMapView;

    property ShowLines: Boolean read FShowLines write FShowLines default True;
    property ShowPoints: Boolean read FShowPoints write FShowPoints default True;
    property ShowPolygons: Boolean read FShowPolygons write FShowPolygons default True;
    property LabelColumn: String read FLabelColumn write FLabelColumn;
    property SpatialColumn: String read FSpatialColumn write FSpatialColumn;
    property SpatialValue: String read FSpatialValue write FSpatialValue;
  published
    property Active: Boolean read FActive write FActive;
    property Visible;
    property Font;
    property AnalyticalValue: String read FAnalyticalValue write FAnalyticalValue;
    property ColorRanges: TfrxColorRanges read FColorRanges;
    property ColorRangesData: TColorRangeCollection read GetColorRangeData;
    property DataSet: TfrxDataSet read FDataSet write FDataSet;
    property DefaultShapeStyle: TShapeStyle read FDefaultShapeStyle;
    property Filter: String read FFilter write FFilter;
    property HighlightColor: TColor read FHighlightColor write FHighlightColor;
    property Operation: TMapOperation read FOperation write FOperation; // function
    property ValueFormat: String read FValueFormat write FValueFormat; // LabelFormat
    property LabelKind: TMapLabelKind read FLabelKind write FLabelKind;
    property MapPalette: TMapPalette read FMapPalette write FMapPalette; // Palette
    property SizeRanges: TfrxSizeRanges read FSizeRanges;
    property SizeRangesData: TSizeRangeCollection read GetSizeRangeData;
    property PointLabelsVisibleAtZoom: Extended read FPointLabelsVisibleAtZoom write FPointLabelsVisibleAtZoom;
  end;
(******************************************************************************)
  TMapLayerList = class
  private
    FObjects: TList;
    FSelectedLayerIndex: Integer;
    function GetSelectedLayer: TfrxCustomLayer;
    function GetCount: Integer;
    function GetLayer(Index: Integer): TfrxCustomLayer;
  protected
    FPreviousSelectedLayerIndex: Integer;
  public
    constructor Create(AObjects: TList);
    procedure Exchange(Index1, Index2: Integer);
    function IndexOf(Item: Pointer): Integer;

    function IsSelectedShapeChanded: Boolean;
    function IsInclude(P: TfrxPoint): Boolean;
    procedure GetData;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TfrxCustomLayer read GetLayer; default;
    property SelectedLayer: TfrxCustomLayer read GetSelectedLayer;
  end;
(******************************************************************************)
  TfrxMapFileLayer = class(TfrxCustomLayer)
  private
    FZoomPolygon: String;
    procedure SetLayerTags(const Value: TStringList);
    function GetFileTags: TfrxSumStringList;
  protected
    FMapFileName: String;
    FLayerTags: TStringList;
    FFirstReading: Boolean;

    function GetSelectedShapeName: String; override;
    function GetSelectedShapeValue: String; override;
    procedure InitTransform(iRecord: Integer); override;
    procedure InitialiseData; override;
    function IsCanGetData: Boolean; override;
    function IsHighlightSelectedShape: boolean; override;

    procedure SetMapFileName(const AMapFileName: String);
    function GetFileExtension: string;

    procedure ExpandVariables; override;
    procedure AddValueList(vaAnalyticalValue: Variant); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsHasZoomRect(out ZoomRect: TfrxRect): boolean; override;
    procedure Embed;
    procedure ReRead;
    procedure JustAdded;

    property FileTags: TfrxSumStringList read GetFileTags;
  published
    property ShowLines;
    property ShowPoints;
    property ShowPolygons;
    property LabelColumn;
    property SpatialColumn;
    property LayerTags: TStringList read FLayerTags write SetLayerTags;
    property MapAccuracy;
    property MapFileName: String read FMapFileName write SetMapFileName;
    property PixelAccuracy;
    property SpatialValue;
    property ZoomPolygon: String read FZoomPolygon write FZoomPolygon;
  end;
(******************************************************************************)
  TfrxApplicationLayer = class(TfrxCustomLayer)
  private
    FLabelValue: String;
    FLatitudeValue: String;
    FLongitudeValue: String;
  protected
    procedure InitialiseData; override;
    function IsCanGetData: Boolean; override;

    procedure ExpandVariables; override;
    procedure AddValueList(vaAnalyticalValue: Variant); override;
    function ApplicationShapeData(X, Y: Extended; Name, Location: String): TShapeData;
  public
    constructor Create(AOwner: TComponent); override;
    function IsInclude(P: TfrxPoint): Boolean; override; // False
  published
    property LabelValue: String read FLabelValue write FLabelValue;
    property LatitudeValue: String read FLatitudeValue write FLatitudeValue;
    property LongitudeValue: String read FLongitudeValue write FLongitudeValue;
  end;
(******************************************************************************)
type
  TfrxLabelColumnProperty = class(TfrxPropertyEditor)
  public
    function GetValue: String; override;
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const Value: String); override;
  end;
(******************************************************************************)
  procedure OperationGetList(List: TStrings);
  procedure PaletteGetList(List: TStrings);
  procedure PenStyleGetList(List: TStrings);
  procedure MapLabelKindGetList(List: TStrings);
(******************************************************************************)
implementation

uses
  SysUtils, Math, frxMap,
  Types, Variants, frxUtils, frxRes, frxMapLayerTags {Editor},
  {$IFNDEF FPC}{$IFDEF Delphi12}pngimage{$ELSE}frxpngimage{$ENDIF},{$ENDIF}
  frxOSMFileFormat, frxPolygonTemplate;

const
  AppLabelColumn = 'NAME';
  AppSpatialColumn = 'LOCATION';

  PaletteSize = 8;
  FullPalette: array[TMapPalette] of array[0..PaletteSize - 1] of TColor =
    ((clNone, clNone, clNone, clNone, clNone, clNone, clNone, clNone),
     ($fae6e6, $f5f0ff, $b9daff, $cdfaff, $e1e4ff, $f0fff0, $fff8f0, $f5f5f5),
     ($89e0bf, $b7bdc8, $9cfaff, $8ac5f4, $e2ce87, $96a0e6, $dca0a0, $9595ff),
     ($c8c8c8, $bcbcbc, $b2b2b2, $a8a8a8, $9d9d9d, $939393, $888888, $7d7d7d),
     ($0080ff, $0b86b8, $0040c0, $238e6b, $3f85cd, $00c0c0, $228b22, $1e69d2),
     ($578b2e, $aacd66, $b48246, $8b8b00, $a09e5f, $71b33c, $ccd148, $8bbc8f),
     ($f08c41, $41b4fa, $0a40e0, $926405, $a8b9f1, $816350, $82e3ff, $dd9c12));

{ Utilities }
procedure MapLabelKindGetList(List: TStrings);
begin
  List.Clear;
  List.Add(frxResources.Get('mlNone'));
  List.Add(frxResources.Get('mlName'));
  List.Add(frxResources.Get('mlValue'));
  List.Add(frxResources.Get('mlNameAndValue'));
end;

procedure PenStyleGetList(List: TStrings);
begin
  List.Clear;
  List.Add(frxResources.Get('psSolid'));
  List.Add(frxResources.Get('psDash'));
  List.Add(frxResources.Get('psDot'));
  List.Add(frxResources.Get('psDashDot'));
  List.Add(frxResources.Get('psDashDotDot'));
  List.Add(frxResources.Get('psClear'));
  List.Add(frxResources.Get('psInsideFrame'));
  List.Add(frxResources.Get('psUserStyle'));
  List.Add(frxResources.Get('psAlternate'));
end;

procedure PaletteGetList(List: TStrings);
begin
  List.Clear;
  List.Add(frxResources.Get('mpNone'));
  List.Add(frxResources.Get('mpLight'));
  List.Add(frxResources.Get('mpPastel'));
  List.Add(frxResources.Get('mpGrayScale'));
  List.Add(frxResources.Get('mpEarth'));
  List.Add(frxResources.Get('mpSea'));
  List.Add(frxResources.Get('mpBrightPastel'));
end;

procedure OperationGetList(List: TStrings);
begin
  List.Clear;
  List.Add(frxResources.Get('opSum'));
  List.Add(frxResources.Get('opAverage'));
  List.Add(frxResources.Get('opMin'));
  List.Add(frxResources.Get('opMax'));
  List.Add(frxResources.Get('opCount'));
end;

{ TfrxCustomLayer }

procedure TfrxCustomLayer.BuildGraphic(CanvasSize: TfrxPoint; ActiveHyperlink: Boolean);
begin
  FVectorGraphic.Free;
  FVectorGraphic := GetMetaFile(CanvasSize, ActiveHyperlink);
end;

procedure TfrxCustomLayer.ClearSelectedShape;
begin
  FSelectedShapeIndex := Unknown;
end;

constructor TfrxCustomLayer.Create(AOwner: TComponent);
begin
  inherited;

  FShowLines := True;
  FShowPoints := True;
  FShowPolygons := True;
  FSelectedShapeIndex := Unknown;
  FPreviousSelectedShapeIndex := Unknown;
  FLabelKind := mlNone;
  FHighlightColor := clLime;
  FAnalyticalValue := '';
  FSpatialValue := '';
  FMapPalette := mpNone;
  FOperation := opSum;
  FDataSet := nil;
  FColorRanges := TfrxColorRanges.Create(TfrxMapView(AOwner).ColorScale);
  FSizeRanges := TfrxSizeRanges.Create(TfrxMapView(AOwner).SizeScale);
  FValueFormat := '%1.2f';
  FDefaultShapeStyle := TShapeStyle.Create;
  FPointLabelsVisibleAtZoom := 1;
  FClippingRect := TfrxClippingRect.Create;
{$IFDEF FRX_USE_BITMAP_MAP}
  FClippingMapRect := TfrxClippingRect.Create;
{$ENDIF}
  FShapes := nil;

  FValuesList := nil;
  FConverter := TfrxMapView(AOwner).Converter;
  FMapView := AOwner;
  FVectorGraphic := nil;
  FActive := True;
  frComponentStyle := frComponentStyle + [csDefaultDiff];
end;

procedure TfrxCustomLayer.DefinePrimeProperties(Filer: TFiler);
begin
  // Empty
end;

procedure TfrxCustomLayer.DefineProperties(Filer: TFiler);
var
  CRC: TColorRangeCollection;
  SRC: TSizeRangeCollection;
begin
  inherited;
  DefinePrimeProperties(Filer);

  CRC := ColorRanges.ColorRangeCollection;
  SRC := SizeRanges.SizeRangeCollection;
  if [csDesigning, csLoading] * ComponentState <> [] then // dfm
  begin
    Filer.DefineBinaryProperty('Shapes', FShapes.ReadDFM, FShapes.WriteDFM, FShapes <> nil);
    Filer.DefineBinaryProperty('ColorRangeCollection', CRC.ReadDFM, CRC.WriteDFM, CRC <> nil);
    Filer.DefineBinaryProperty('SizeRangeCollection', SRC.ReadDFM, SRC.WriteDFM, SRC <> nil);
  end
  else // fr3
  begin
    Filer.DefineProperty('Shapes', FShapes.Read, FShapes.Write, FShapes <> nil);
    Filer.DefineProperty('ColorRangeCollection', CRC.Read, CRC.Write, CRC <> nil);
    Filer.DefineProperty('SizeRangeCollection', SRC.Read, SRC.Write, SRC <> nil);
  end;

end;

destructor TfrxCustomLayer.Destroy;
begin
  FColorRanges.Free;
  FDefaultShapeStyle.Free;
  FShapes.Free;
  FValuesList.Free;
  FVectorGraphic.Free;
  FSizeRanges.Free;
  FClippingRect.Free;
{$IFDEF FRX_USE_BITMAP_MAP}
  FClippingMapRect.Free;
{$ENDIF}
  inherited;
end;

procedure TfrxCustomLayer.Draw(Canvas: TCanvas);
var
  iRecord: Integer;
begin
  DefaultShapeStyle.TunePen(Canvas.Pen);

  Canvas.Lock;
  try
    Canvas.Brush.Style := bsClear;
    for iRecord := 0 to FShapes.Count - 1 do
      if not IsHiddenShape(iRecord) then
        case FShapes[iRecord].ShapeType of
          stPoint:
            if ShowPoints then
              DrawPoint(Canvas, iRecord);
          stPolyLine, stMultiPolyLine:
            if ShowLines then
              DrawPolyLine(Canvas, iRecord);
          stPolygon, stMultiPolygon:
            if ShowPolygons then
              DrawPolygon(Canvas, iRecord);
          stRect:
            DrawRect(Canvas, iRecord);
          stDiamond:
            DrawDiamond(Canvas, iRecord);
          stEllipse:
            DrawEllipse(Canvas, iRecord);
          stPicture:
            DrawPicture(Canvas, iRecord);
          stLegend:
            DrawLegend(Canvas, iRecord);
          stTemplate:
            DrawTemplate(Canvas, iRecord);
          stMultiPoint:
            if ShowPoints then
              DrawMultiPoint(Canvas, iRecord);
          else
            raise Exception.Create('Unknown ShapeType');
        end;
    for iRecord := 0 to FShapes.Count - 1 do
      if not IsHiddenShape(iRecord) then
        case FShapes[iRecord].ShapeType of
          stPoint, stMultiPoint:
            if ShowPoints then
              if TfrxMapView(FMapView).Zoom >= PointLabelsVisibleAtZoom then
                DrawPointLegend(Canvas, iRecord);
          stPolyLine, stMultiPolyLine:
            if ShowLines then
              DrawPolyLegend(Canvas, iRecord);
          stPolygon, stMultiPolygon:
            if ShowPolygons then
              DrawPolyLegend(Canvas, iRecord);
          stRect, stDiamond, stEllipse, stPicture, stLegend, stTemplate:
            DrawPolyLegend(Canvas, iRecord);
          else
            raise Exception.Create('Unknown ShapeType');
        end;
  finally
    Canvas.Unlock;
  end;
end;

procedure TfrxCustomLayer.DrawClippedPoint(Canvas: TCanvas; X, Y, Radius: Extended);
begin
  if FClippingRect.IsCircleInside(Circle(X, Y, Radius)) then
    Canvas.Ellipse(Round(X - Radius), Round(Y - Radius),
                   Round(X + Radius), Round(Y + Radius));
end;

procedure TfrxCustomLayer.DrawDiamond(Canvas: TCanvas; iRecord: Integer);
var
  Rect: TRect;
begin
  TunePen(Canvas.Pen, iRecord);
  TuneBrush(Canvas.Brush, iRecord);
  InitTransform(iRecord);
  Rect := ToRect(FShapes.CanvasRect(iRecord));
  if FClippingRect.IsDiamondInside(Rect) then
    with Rect do
      Canvas.Polygon([Point((Left + Right) div 2, Top), Point(Right, (Top + Bottom) div 2),
                      Point((Left + Right) div 2, Bottom), Point(Left, (Top + Bottom) div 2)]);
end;

procedure TfrxCustomLayer.DrawEllipse(Canvas: TCanvas; iRecord: Integer);
var
  Rect: TRect;
begin
  TunePen(Canvas.Pen, iRecord);
  TuneBrush(Canvas.Brush, iRecord);
  InitTransform(iRecord);
  Rect := ToRect(FShapes.CanvasRect(iRecord));
  if FClippingRect.IsRectInside(Rect) then
    with Rect do
      Canvas.Ellipse(Left, Top, Right, Bottom);
end;

procedure TfrxCustomLayer.DrawHighlightFrame(Canvas: TCanvas; iRecord: Integer);
begin
  Canvas.Pen.Color := HighlightColor;
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Width := 2;
  with ToRect(FShapes.CanvasRect(iRecord)) do
    Canvas.Rectangle(Left, Top, Right, Bottom);
end;

{$IFNDEF FRX_DONT_USE_METAFILE_MAP}
procedure TfrxCustomLayer.DrawLegend(Canvas: TCanvas; iRecord: Integer);
var
  Metafile: TMetafile;
  MetafileCanvas: TMetafileCanvas;
  Rect: TRect;
  i, hStep: Integer;
begin
  InitTransform(iRecord);

  Rect := ToRect(FShapes.CanvasRect(iRecord));
  if not FClippingRect.IsRectInside(Rect) then
    Exit;

  Metafile := TMetafile.Create;
  Metafile.Width := Rect.Right - Rect.Left;
  Metafile.Height := Rect.Bottom - Rect.Top;
  MetafileCanvas := TMetafileCanvas.Create(Metafile, 0);
  MetafileCanvas.Font.Assign(FShapes[iRecord].ShapeData.Font);
  MetafileCanvas.Brush.Style := bsClear;
  hStep := MetafileCanvas.TextHeight('Wy');
  for i := 0 to FShapes[iRecord].ShapeData.LegendText.Count - 1 do
    MetafileCanvas.TextOut(0, i * hStep, FShapes[iRecord].ShapeData.LegendText[i]);
  MetafileCanvas.Free;

  Canvas.CopyMode := cmSrcCopy;
  Canvas.Draw(Rect.Left, Rect.Top, Metafile);
  if IsHighlightSelectedShape and (FSelectedShapeIndex = iRecord) then
    DrawHighlightFrame(Canvas, iRecord);
  Metafile.Free;
end;
{$ELSE}
procedure TfrxCustomLayer.DrawLegend(Canvas: TCanvas; iRecord: Integer);
var
  Rect: TRect;
  i, hStep: Integer;
  oldBS: TBrushStyle;
  oldFont: TFont;
begin
  InitTransform(iRecord);

  Rect := ToRect(FShapes.CanvasRect(iRecord));
  if not FClippingRect.IsRectInside(Rect) then
    Exit;

  oldFont := Canvas.Font;
  oldBS := Canvas.Brush.Style;
  Canvas.Font.Assign(FShapes[iRecord].ShapeData.Font);
  Canvas.Brush.Style := bsClear;
  Canvas.CopyMode := cmSrcCopy;
  try
  hStep := Canvas.TextHeight('Wy');
  for i := 0 to FShapes[iRecord].ShapeData.LegendText.Count - 1 do
    Canvas.TextOut(Rect.Left, Rect.Top + i * hStep, FShapes[iRecord].ShapeData.LegendText[i]);

  if IsHighlightSelectedShape and (FSelectedShapeIndex = iRecord) then
    DrawHighlightFrame(Canvas, iRecord);

  finally
    Canvas.Font.Assign(oldFont);
    Canvas.Brush.Style := oldBS;
  end;
end;
{$ENDIF}

procedure TfrxCustomLayer.DrawMultiPoint(Canvas: TCanvas; iRecord: Integer);
var
  Radius: Extended;
  iPoint: Integer;
  CP: TDoublePointArray;
begin
  TunePoint(Canvas, iRecord, Radius);
  CP := FShapes.CanvasPoly(iRecord);
  for iPoint := 0 to High(CP) do
    with CP[iPoint] do
      DrawClippedPoint(Canvas, X, Y, Radius);
end;

procedure TfrxCustomLayer.DrawOn(Canvas: TCanvas; ActiveHyperlink: Boolean; aClipRect: TfrxRect);
var
  aMap: TfrxMapView;
begin
  aMap := TfrxMapView(FMapView);
  Canvas.Font := Font;
{$IFDEF FRX_USE_BITMAP_MAP}
  FClippingMapRect.Init(aMap.ClipMap,
      aMap.MapViewport);
{$ENDIF}
  FClippingRect.Init(aMap.ClipMap,
      aClipRect);

  if IsDesigning and (FShapes <> nil) then
    GetDesigningData;

  FActiveHyperlink := ActiveHyperlink;

  if Assigned(FShapes) then
    Draw(Canvas);
end;

procedure TfrxCustomLayer.DrawPicture(Canvas: TCanvas; iRecord: Integer);
var
  SourceGrapic: TGraphic;
  DR: TDoubleRect;
  DestRect: TRect;
  Bitmap: TBitmap;
begin
  InitTransform(iRecord);

  SourceGrapic := FShapes[iRecord].ShapeData.Picture.Graphic;
  DR := FShapes.CanvasRect(iRecord);
  if FShapes[iRecord].ShapeData.ConstrainProportions then
    DR := ConstrainedDR(DR, SourceGrapic.Width, SourceGrapic.Height);
  DestRect := ToRect(DR);

  if not FClippingRect.IsRectInside(DestRect) then
    Exit;

  Canvas.CopyMode := cmSrcCopy;
{$IFNDEF FPC}
  if (SourceGrapic is {$IFNDEF FPC}TPngObject{$ELSE}TPortableNetworkGraphic{$ENDIF}) and
     IsCanPngToTransparentBitmap32({$IFNDEF FPC}TPngObject{$ELSE}TPortableNetworkGraphic{$ENDIF}(SourceGrapic), Bitmap) then
  begin
    AlphaBlend(Canvas.Handle,
                 DestRect.Left, DestRect.Top,
                 DestRect.Right - DestRect.Left, DestRect.Bottom - DestRect.Top,
               Bitmap.Canvas.Handle,
                 0, 0,
                 SourceGrapic.Width, SourceGrapic.Height,
               Bitmap32BF);
    Bitmap.Free;
  end
  else
{$ENDIF}
    Canvas.StretchDraw(DestRect, SourceGrapic);
  if IsHighlightSelectedShape and (FSelectedShapeIndex = iRecord) then
    DrawHighlightFrame(Canvas, iRecord);
end;

procedure TfrxCustomLayer.DrawPoint(Canvas: TCanvas; iRecord: Integer);
var
  Radius: Extended;
begin
  TunePoint(Canvas, iRecord, Radius);

  with FShapes.CanvasPoint(iRecord) do
    DrawClippedPoint(Canvas, X, Y, Radius);
end;

procedure TfrxCustomLayer.DrawPointLegend(Canvas: TCanvas; iRecord: Integer);
var
  Legend: String;
  Rect: TRect;
  dX, dY: Integer;
  P: TfrxPoint;
begin
  Canvas.Brush.Style := bsClear;

  Legend := Trim(GetShapeLegeng(LabelColumn, iRecord));
  if Legend = '' then
    Exit;

  Rect := Bounds(0, 0, 0, 0);
  DrawText(Canvas.Handle, PChar(Legend), Length(Legend), Rect, DT_CALCRECT);

  InitTransform(iRecord);

  P := FConverter.Transform(DoublePoint(FShapes[iRecord].ShapeCenter));

  dX := Round(P.X - (Rect.Right + Rect.Left) / 2 + FShapes[iRecord].CenterOffsetX);
  dY := Round(P.Y - Rect.Bottom - Canvas.Font.Size / 2 + FShapes[iRecord].CenterOffsetY);
  OffsetRect(Rect, dX, dY);
  if FClippingRect.IsRectInside(Rect) then
    DrawText(Canvas.Handle, PChar(Legend), Length(Legend), Rect, DT_CENTER + DT_NOCLIP);
end;

procedure TfrxCustomLayer.DrawPolygon(Canvas: TCanvas; iRecord: Integer);
var
  iPart: Integer;
  PolyPoints: TPointArray;
begin
  TunePen(Canvas.Pen, iRecord);
  TuneBrush(Canvas.Brush, iRecord);
  InitTransform(iRecord);
  for iPart := 0 to FShapes[iRecord].PartCount - 1 do
  begin
{$IFDEF FRX_USE_BITMAP_MAP}
    if TfrxMapView(FMapView).ClipMap  and not FClippingMapRect.IsPolygonInside(FShapes.Items[iRecord].ShapeData, iPart)  then
      continue;
{$ENDIF}
    if FShapes.IsCanvasPolyPoints(iRecord, iPart, MapAccuracy, PixelAccuracy, PolyPoints)
      and FClippingRect.IsPolygonInside(PolyPoints) then
      Canvas.Polygon(PolyPoints);
  end;
end;

procedure TfrxCustomLayer.DrawPolyLegend(Canvas: TCanvas; iRecord: Integer);
var
  Text: String;
  TextHeight: Integer;
  dHeight: Extended;
  Rect: TRect;
  R: TfrxRect;
begin
  Canvas.Brush.Style := bsClear;

  Text := Trim(GetShapeLegeng(LabelColumn, iRecord));
  if Text = '' then
    Exit;

  Rect := Bounds(0, 0, 0, 0);
  TextHeight := DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, DT_CALCRECT);
  InitTransform(iRecord);
  R := FShapes.CanvasWidestPartBounds(iRecord);
  if (TextHeight <= R.Bottom - R.Top) and (Rect.Right - Rect.Left <= R.Right - R.Left) then
    with FShapes[iRecord] do
    begin
      R.Left := R.Left + CenterOffsetX;
      R.Right := R.Right + CenterOffsetX;
      dHeight := (R.Bottom - R.Top - TextHeight) / 2;
      R.Top := R.Top + dHeight + CenterOffsetY;
      R.Bottom := R.Bottom - dHeight + CenterOffsetY;
      Rect := Types.Rect(Round(R.Left), Round(R.Top), Round(R.Right), Round(R.Bottom));
      if FClippingRect.IsRectInside(Rect) then
        DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, DT_CENTER + DT_NOCLIP);
    end;
end;

procedure TfrxCustomLayer.DrawPolyLine(Canvas: TCanvas; iRecord: Integer);
var
  iPart: Integer;
  PolyPoints: TPointArray;
begin
  InitTransform(iRecord);

  TunePen(Canvas.Pen, iRecord);

  for iPart := 0 to FShapes[iRecord].PartCount - 1 do
  begin
{$IFDEF FRX_USE_BITMAP_MAP}
    if TfrxMapView(FMapView).ClipMap and not FClippingMapRect.IsPolyLineInside(FShapes.Items[iRecord].ShapeData, iPart) then
      continue;
{$ENDIF}
    if FShapes.IsCanvasPolyPoints(iRecord, iPart, MapAccuracy, PixelAccuracy, PolyPoints)
       and FClippingRect.IsPolyLineInside(PolyPoints) then
      Canvas.PolyLine(PolyPoints);
  end;
end;

procedure TfrxCustomLayer.DrawRect(Canvas: TCanvas; iRecord: Integer);
var
  Rect: TRect;
begin
  TunePen(Canvas.Pen, iRecord);
  TuneBrush(Canvas.Brush, iRecord);
  InitTransform(iRecord);
  Rect := ToRect(FShapes.CanvasRect(iRecord));
  if FClippingRect.IsRectInside(Rect) then
    with Rect do
      Canvas.Rectangle(Left, Top, Right, Bottom);
end;

procedure TfrxCustomLayer.DrawTemplate(Canvas: TCanvas; iRecord: Integer);
var
  PolygonTemplate: TfrxPolygonTemplate;
  Points: TPointArray;
begin
  PolygonTemplate := PolygonTemplateList.ItemsByName[FShapes[iRecord].ShapeData.TemplateName];
  if PolygonTemplate <> nil then
  begin
    TunePen(Canvas.Pen, iRecord);
    TuneBrush(Canvas.Brush, iRecord);
    InitTransform(iRecord);

    FShapes.IsCanvasPolyPoints(iRecord, 0, 0, 0, Points);
    PolygonTemplate.Draw(Canvas, Points);
  end;
end;

procedure TfrxCustomLayer.ExpandVariables;
begin
  with TfrxMapView(FMapView) do
  begin
    ExpandVar(FAnalyticalValue);
    ExpandVar(FSpatialValue);
    ExpandVar(FFilter);
  end;
end;

procedure TfrxCustomLayer.FillRanges(const Values: TDoubleArray);
begin
  if FColorRanges.RangeCount > 0 then
    FColorRanges.Fill(Values);
  if FSizeRanges.RangeCount > 0 then
    FSizeRanges.Fill(Values);
end;

procedure TfrxCustomLayer.FinaliseData;
var
  Values: TDoubleArray;
begin
  if FShapes <> nil then
    if FShapes.IsGetValues(Values) then
      FillRanges(Values);
end;

function TfrxCustomLayer.GetColorRangeData: TColorRangeCollection;
begin
  Result := FColorRanges.ColorRangeCollection;
end;

procedure TfrxCustomLayer.GetColumnList(List: TStrings);
var
  ColumnList: TStringList;
begin
  ColumnList := TStringList.Create;
  ColumnList.Sorted := True;
  ColumnList.Duplicates := dupIgnore;
  if FShapes <> nil then
    FShapes.GetColumnList(ColumnList);
  List.Assign(ColumnList);
  ColumnList.Free;
end;

procedure TfrxCustomLayer.GetData;
var
  vaAnalyticalValue: Variant;
  stSpatialValue: String;
  Index, iRecord: Integer;

  procedure AddValues;
  begin
    if (Trim(Filter) = '') or
      (Report.Calc(Filter) = True { Since Report.Calc: Variant } ) then
    begin
      vaAnalyticalValue := Report.Calc(AnalyticalValue);

      if not VarIsNull(vaAnalyticalValue) then
        AddValueList(vaAnalyticalValue);
    end;
  end;
begin
  ExpandVariables;
  InitialiseData;

  if IsCanGetData then
  begin
    if (DataSet <> nil) then
    begin
      DataSet.First;
      while not DataSet.Eof do
      begin
        AddValues;
        DataSet.Next;
      end;
    end
    else
      AddValues;

    for iRecord := 0 to FShapes.Count - 1 do
    begin
      stSpatialValue := FShapes[iRecord].Legend[SpatialColumn];
      if FValuesList.Find(stSpatialValue, Index) then
        FShapes[iRecord].Value := FValuesList.OperationCalculator[Index].Get;
    end;
  end;

  FinaliseData;
end;

procedure TfrxCustomLayer.GetDesigningData;
const
  MinValue = 1.0;
  MaxValue = 1000.0;
var
  iRecord: Integer;
begin
  InitialiseData;
  for iRecord := 0 to FShapes.Count - 1 do
  begin
    RandSeed := iRecord + 1;
    FShapes[iRecord].Value := MinValue + (MaxValue - MinValue) * Random;
  end;
  FinaliseData;
end;

{$IFNDEF FRX_DONT_USE_METAFILE_MAP}
function TfrxCustomLayer.GetMetaFile(CanvasSize: TfrxPoint; ActiveHyperlink: Boolean): TMetaFile;
var
  Canvas: TCanvas;
begin
  Result := TMetaFile.Create;
  Result.Width := Round(CanvasSize.X);
  Result.Height := Round(CanvasSize.Y);

  Canvas := TMetafileCanvas.Create(Result, 0);
  Canvas.Font := Font;

  with TfrxMapView(FMapView) do
    FClippingRect.Init(ClipMap,
      frxRect(-OffSetX, -OffSetY, -OffSetX + Width, -OffSetY + Height));

  if IsDesigning and (FShapes <> nil) then
    GetDesigningData;

  FActiveHyperlink := ActiveHyperlink;

  if Assigned(FShapes) then
    Draw(Canvas);

  Canvas.Free;
end;
{$ELSE}
function TfrxCustomLayer.GetMetaFile(CanvasSize: TfrxPoint; ActiveHyperlink: Boolean): TMetaFile;
begin
  Result := nil;
end;
{$ENDIF}

function TfrxCustomLayer.GetSelectedShape: TShape;
begin
  if FSelectedShapeIndex = Unknown then
    Result := nil
  else
    Result := FShapes[FSelectedShapeIndex];
end;

function TfrxCustomLayer.GetSelectedShapeName: String;
begin
  Result := '';
end;

function TfrxCustomLayer.GetSelectedShapeValue: String;
begin
  Result := '';
end;

function TfrxCustomLayer.GetShapeLegeng(FieldName: String; iRecord: Integer): String;
var
  stValue: String;
begin
  case LabelKind of
    mlNone:
      Result := '';
    mlName:
      Result := GetShapeName(FieldName, iRecord);
    mlValue:
      Result := GetShapeValue(iRecord);
    mlNameAndValue:
    begin
      Result := GetShapeName(FieldName, iRecord);
      stValue := GetShapeValue(iRecord);
      Result := Result + IfStr((Result <> '') and (stValue <> ''), #13#10) + stValue;
    end;
  end;
end;

function TfrxCustomLayer.GetShapeName(FieldName: String; iRecord: Integer): String;
begin
  Result := FShapes[iRecord].Legend[FieldName];
end;

function TfrxCustomLayer.GetShapeValue(iRecord: Integer): String;
begin
  with FShapes[iRecord] do
    Result := IfStr(IsValueEmpty, '', Format(ValueFormat, [Value]));
end;

function TfrxCustomLayer.GetSizeRangeData: TSizeRangeCollection;
begin
  Result := FSizeRanges.SizeRangeCollection;
end;

procedure TfrxCustomLayer.InitialiseData;
begin
  FValuesList.Free;
  FValuesList := TValuesList.Create(Operation);
end;

procedure TfrxCustomLayer.InitTransform(iRecord: Integer);
begin
  // Empty
end;

function TfrxCustomLayer.IsCanGetData: Boolean;
begin
  { can handle static expression }
  Result := {(DataSet <> nil) and }(Trim(AnalyticalValue) <> '');
end;

function TfrxCustomLayer.IsHasMapRect(out MapRect: TfrxRect): boolean;
begin
  Result := (FShapes <> nil) and FShapes.IsValidMapRect(MapRect);
end;

function TfrxCustomLayer.IsHasZoomRect(out ZoomRect: TfrxRect): boolean;
begin
  Result := False;
end;

function TfrxCustomLayer.IsHiddenShape(iRecord: Integer): Boolean;
begin
  Result := False;
end;

function TfrxCustomLayer.IsHighlightSelectedShape: boolean;
begin
  Result := False;
end;

function TfrxCustomLayer.IsInclude(P: TfrxPoint): Boolean;
var
  iRecord: Integer;
  MD: TMinDistance;
  CanvasDist: Extended;
  NearToPointOrLine: Boolean;
begin
  Result := False;
  if FShapes = nil then
    Exit;
  FPreviousSelectedShapeIndex := SelectedShapeIndex;
  ClearSelectedShape;
  MD := TMinDistance.Create(MinSelectDistance);
  for iRecord := FShapes.Count - 1 downto 0 do // In reverse order of drawing
  begin
    InitTransform(iRecord);
    CanvasDist := FShapes.CanvasDistance(iRecord, P);
    NearToPointOrLine := (CanvasDist < MinSelectDistance) and
      (FShapes[iRecord].ShapeType in [stPoint, stPolyLine, stMultiPoint, stMultiPolyLine]);
    if NearToPointOrLine or FShapes.IsInside(iRecord, P) then
      MD.Add(0.0, iRecord)
    else
      MD.Add(CanvasDist, iRecord);
    if MD.IsZero then
      Break;
  end;
  Result := MD.IsNear;
  if Result then
    SelectedShapeIndex := MD.Index
  else
    Result := IsIncludeAsRegion(P);
  MD.Free;
end;

function TfrxCustomLayer.IsIncludeAsRegion(P: TfrxPoint): Boolean;

  function IsPointInRecordRegion(iRecord: Integer): boolean;
  var
    iPart: Integer;
    PolyPoints: TPointArray;
    RGN: hRGN;
  begin
    Result := False;
    for iPart := 0 to FShapes[iRecord].PartCount - 1 do
      if FShapes.IsCanvasPolyPoints(iRecord, iPart, MapAccuracy, PixelAccuracy, PolyPoints) then
      begin
{$IFNDEF FPC}
        RGN := CreatePolygonRgn(PolyPoints[0], Length(PolyPoints), WINDING);
{$ELSE}
        RGN := CreatePolygonRgn(@PolyPoints[0], Length(PolyPoints), WINDING);
{$ENDIF}
        Result := PtInRegion(RGN, Round(P.X), Round(P.Y));
        DeleteObject(RGN);
        if Result then
          Break;
      end;
  end;

var
  iRecord: Integer;
begin
  FPreviousSelectedShapeIndex := SelectedShapeIndex;
  ClearSelectedShape;
  for iRecord := 0 to FShapes.Count - 1 do
    if (FShapes[iRecord].ShapeType in [stPolygon, stMultiPolygon]) or
       (FShapes[iRecord].ShapeType in [stPolyLine, stMultiPolyLine]) and
        FShapes[iRecord].ShapeData.IsClosed then
    begin
      InitTransform(iRecord);
      if IsPointInRecordRegion(iRecord) then
      begin
        FSelectedShapeIndex := iRecord;
        Break;
      end;
    end;
  Result := FSelectedShapeIndex <> Unknown;
end;

function TfrxCustomLayer.IsSelectedShapeChanded: Boolean;
begin
  Result := FPreviousSelectedShapeIndex <> FSelectedShapeIndex;
end;

function TfrxCustomLayer.IsSpecialBorderColor(iRecord: Integer; out SpecialColor: TColor): Boolean;
begin
  Result := False;
end;

function TfrxCustomLayer.IsSpecialFillColor(iRecord: Integer; out SpecialColor: TColor): Boolean;
begin
  Result := False;
end;

procedure TfrxCustomLayer.SetParent(AParent: TfrxComponent);
begin
  if (AParent = nil) or (AParent is TfrxMapView) then
    inherited;
end;

procedure TfrxCustomLayer.TuneBrush(Brush: TBrush; iRecord: Integer);
var
  SpecialColor: TColor;
begin
  Brush.Style := bsSolid;
  if IsHighlightSelectedShape and (FSelectedShapeIndex = iRecord) then
    Brush.Color := HighlightColor
  else if IsSpecialFillColor(iRecord, SpecialColor) then
    Brush.Color := SpecialColor
  else if ColorRanges.RangeCount > 0 then
    Brush.Color := ColorRanges.GetColor(FShapes[iRecord].Value)
  else if MapPalette <> mpNone then
    Brush.Color := FullPalette[MapPalette, iRecord mod PaletteSize]
  else
    Brush.Color := DefaultShapeStyle.FillColor;
end;

procedure TfrxCustomLayer.TunePen(Pen: TPen; iRecord: Integer);
var
  SpecialColor: TColor;
begin
  if IsHighlightSelectedShape and (FSelectedShapeIndex = iRecord) then
    Pen.Color := HighlightColor
  else if IsSpecialBorderColor(iRecord, SpecialColor) then
    Pen.Color := SpecialColor
  else
    Pen.Color := DefaultShapeStyle.BorderColor;
end;

procedure TfrxCustomLayer.TunePoint(Canvas: TCanvas; iRecord: Integer; out Radius: Extended);
begin
  TunePen(Canvas.Pen, iRecord);
  TuneBrush(Canvas.Brush, iRecord);
  InitTransform(iRecord);
  Radius := DefaultShapeStyle.PointSize / 2;
  if SizeRanges.RangeCount > 0 then
    Radius := SizeRanges.GetSize(FShapes[iRecord].Value) / 2;
end;

{ TfrxLabelColumnProperty }

function TfrxLabelColumnProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList];
end;

function TfrxLabelColumnProperty.GetValue: String;
begin
  Result := GetStrValue;
end;

procedure TfrxLabelColumnProperty.GetValues;
begin
  inherited;
  (Component as TfrxCustomLayer).GetColumnList(Values);
end;

procedure TfrxLabelColumnProperty.SetValue(const Value: String);
begin
  SetStrValue(Value);
end;

{ TOperationCalculator }

procedure TOperationCalculator.Add(AValue: Extended);
begin
  FCount := FCount + 1;
  case FOperation of
    opAverage, opSum:
      FValue := FValue + AValue;
    opMin:
      FValue := Min(FValue, AValue);
    opMax:
      FValue := Max(FValue, AValue);
  end;
end;

constructor TOperationCalculator.Create(AOperation: TMapOperation);
begin
  FOperation := AOperation;
  FCount := 0;
  case FOperation of
    opAverage, opSum:
      FValue := 0;
    opMin:
      FValue := 1e+38;
    opMax:
      FValue := -1e+38;
  end;
end;

function TOperationCalculator.Get: Extended;
begin
  case FOperation of
    opAverage:
      Result := IfReal(FCount > 0, FValue / FCount);
    opMin, opMax, opSum:
      Result := IfReal(FCount > 0, FValue);
  else // opCount:
    Result := FCount;
  end;
end;

{ TValuesList }

procedure TValuesList.AddValue(SpatialValue: String; AnalyticalValue: Extended);
var
  Index: Integer;
begin
  if not Find(SpatialValue, Index) then
    Index := AddObject(SpatialValue, TOperationCalculator.Create(FOperation));

  OperationCalculator[Index].Add(AnalyticalValue);
end;

constructor TValuesList.Create(AOperation: TMapOperation);
begin
  inherited Create;

  FOperation := AOperation;

  Duplicates := dupError;
  Sorted := True;
end;

destructor TValuesList.Destroy;
var
  i: Integer;
begin
  OnChange := nil;
  OnChanging := nil;
  for i := 0 to Count - 1 do
    Objects[i].Free;

  inherited;
end;

function TValuesList.GetOperationCalculator(Index: integer): TOperationCalculator;
begin
  Result := TOperationCalculator(Objects[Index]);
end;

function TValuesList.MaxValue: Extended;
var
  i: integer;
begin
  Result := IfReal(Count > 0, OperationCalculator[0].Get);
  for i := 1 to Count - 1 do
    Result := Max(Result, OperationCalculator[i].Get);
end;

function TValuesList.MinValue: Extended;
var
  i: integer;
begin
  Result := IfReal(Count > 0, OperationCalculator[0].Get);
  for i := 1 to Count - 1 do
    Result := Min(Result, OperationCalculator[i].Get);
end;

{ TfrxApplicationLayer }

procedure TfrxApplicationLayer.AddValueList(vaAnalyticalValue: Variant);
var
  vaLatitudeValue, vaLongitudeValue, vaLabelValue: Variant;
  stSpatialValue: String;
  Index: Integer;
begin
  vaLabelValue := Report.Calc(LabelValue);
  vaLatitudeValue := Report.Calc(LatitudeValue);
  vaLongitudeValue := Report.Calc(LongitudeValue);
  if not (VarIsNull(vaLatitudeValue) or VarIsNull(vaLongitudeValue) or VarIsNull(vaLabelValue)) then
  begin
    stSpatialValue := VarToStr(vaLatitudeValue) + ':' + VarToStr(vaLongitudeValue);
    if not FValuesList.Find(stSpatialValue, Index) then
      FShapes.AddShapeData(ApplicationShapeData(vaLongitudeValue, vaLatitudeValue, vaLabelValue, stSpatialValue));
    FValuesList.AddValue(stSpatialValue, vaAnalyticalValue);
  end;
end;

function TfrxApplicationLayer.ApplicationShapeData(X, Y: Extended; Name, Location: String): TShapeData;
var
  Tags: TStringList;
begin
  Tags := TStringList.Create;
  Tags.Add(AppLabelColumn + Tags.NameValueSeparator + Name);
  Tags.Add(AppSpatialColumn + Tags.NameValueSeparator + Location);
  Result := TShapeData.CreatePoint(Tags, X, Y);
  Tags.Free;
  Result.CalcBounds;
end;

constructor TfrxApplicationLayer.Create(AOwner: TComponent);
begin
  inherited;

  FLatitudeValue := '';
  FLongitudeValue := '';
  FLabelValue := '';

  FLabelColumn := AppLabelColumn;
  FSpatialColumn := AppSpatialColumn;

  FShapes := TShapeList.Create(FConverter);
  FShapes.EmbeddedData := True;
end;

procedure TfrxApplicationLayer.ExpandVariables;
begin
  inherited;

  with TfrxMapView(FMapView) do
  begin
    ExpandVar(FLabelValue);
    ExpandVar(FLatitudeValue);
    ExpandVar(FLongitudeValue);
  end;
end;

procedure TfrxApplicationLayer.InitialiseData;
begin
  inherited InitialiseData;
  FShapes.Clear;
end;

function TfrxApplicationLayer.IsCanGetData: Boolean;
begin
  Result := inherited IsCanGetData
    and (Trim(LabelValue) <> '')
    and (Trim(LatitudeValue) <> '')
    and (Trim(LongitudeValue) <> '');
end;

function TfrxApplicationLayer.IsInclude(P: TfrxPoint): Boolean;
begin
  Result := False;
end;

{ TfrxMapFileLayer }

procedure TfrxMapFileLayer.AddValueList(vaAnalyticalValue: Variant);
var
  vaSpatialValue: Variant;
begin
  vaSpatialValue := Report.Calc(SpatialValue);
  if not VarIsNull(vaSpatialValue) then
    FValuesList.AddValue(VarToStr(vaSpatialValue), vaAnalyticalValue);
end;

constructor TfrxMapFileLayer.Create(AOwner: TComponent);
begin
  inherited;

  FLabelColumn := '';
  FSpatialColumn := '';
  FSpatialValue := '';
  FMapFileName := '';
  FMapAccuracy := 0.0;
  FPixelAccuracy := 0.0;

  FShapes := TShapeList.Create(FConverter);
  FShapes.AdjustableShape := True;
  FLayerTags := TStringList.Create;
  FLayerTags.Sorted := True;

  FFirstReading := False;
end;

destructor TfrxMapFileLayer.Destroy;
begin
  FLayerTags.Free;

  inherited;
end;

procedure TfrxMapFileLayer.Embed;
begin
  FMapFileName := '';
  FShapes.EmbeddedData := True;
end;

procedure TfrxMapFileLayer.ExpandVariables;
begin
  inherited;

  with TfrxMapView(FMapView) do
  begin
    ExpandVar(FZoomPolygon);
  end;
end;

function TfrxMapFileLayer.GetFileExtension: string;
begin
  Result := AnsiLowerCase(Copy(FMapFileName, Length(FMapFileName) - 3, 4));
end;

function TfrxMapFileLayer.GetFileTags: TfrxSumStringList;
var
  OSMFile: TOSMFile;
begin
  OSMFile := TfrxMapView(FMapView).OSMFileList.FileByName(MapFileName);
  if OSMFile <> nil then
    Result := OSMFile.SumTags
  else
    Result := nil;
end;

function TfrxMapFileLayer.GetSelectedShapeName: String;
begin
  if (SelectedShapeIndex = Unknown) or (FShapes = nil) or (LabelColumn = '') then
    Result := inherited GetSelectedShapeName
  else
    Result := GetShapeName(LabelColumn, SelectedShapeIndex);
end;

function TfrxMapFileLayer.GetSelectedShapeValue: String;
begin
  if (SelectedShapeIndex = Unknown) or (FShapes = nil) then
    Result := inherited GetSelectedShapeValue
  else
    Result := GetShapeValue(SelectedShapeIndex);
end;

procedure TfrxMapFileLayer.InitialiseData;
begin
  inherited InitialiseData;
  FShapes.ClearValues;
end;

procedure TfrxMapFileLayer.InitTransform(iRecord: Integer);
begin
  with FShapes[iRecord] do
    FConverter.InitShape(OffsetX, OffsetY, Zoom, FShapes[iRecord].ShapeCenter);
end;

function TfrxMapFileLayer.IsCanGetData: Boolean;
begin
  Result := inherited IsCanGetData
    and (Trim(SpatialValue) <> '');
end;

function TfrxMapFileLayer.IsHasZoomRect(out ZoomRect: TfrxRect): boolean;
var
  iRecord: Integer;
begin
  Result := (FShapes <> nil) and (LabelColumn <> '') and (ZoomPolygon <> '')
        and FShapes.IsHasLegend(SpatialColumn, ZoomPolygon, iRecord)
        and (FShapes[iRecord].ShapeType in [stPolyLine, stPolygon, stMultiPoint, stMultiPolyLine, stMultiPolygon]);
  if Result then
  begin
    InitTransform(iRecord);
{$IFDEF FRX_USE_BITMAP_MAP}
    FConverter.UseOffset := False;
{$ENDIF}
    ZoomRect := FShapes.CanvasWidestPartBounds(iRecord);
{$IFDEF FRX_USE_BITMAP_MAP}
    FConverter.UseOffset := True;
{$ENDIF}
  end;
end;

function TfrxMapFileLayer.IsHighlightSelectedShape: boolean;
begin
  Result := IsDesigning
         or FActiveHyperlink;
end;

procedure TfrxMapFileLayer.JustAdded;
begin
  FFirstReading := True;
end;

procedure TfrxMapFileLayer.ReRead;
var
  FileExtension: String;
begin
  if (FMapFileName <> '') and FileExists(PlatformFileName(FMapFileName)) then
  begin
    FShapes.Free;
    FileExtension := GetFileExtension;
    if FileExtension = '.osm' then
    begin
      TfrxMapView(FMapView).OSMFileList.AddFile(FMapFileName);
      if FFirstReading then
        EditLayerTags(FileTags, LayerTags);
      FShapes := TOSMShapeList.CreateFromFile(FMapFileName, FConverter,
        TfrxMapView(FMapView).OSMFileList, LayerTags)
    end
    else if FileExtension = '.gpx' then
      FShapes := TGPXShapeList.CreateFromFile(FMapFileName, FConverter)
    else if FileExtension = '.shp' then
      try
        FShapes := TERSIShapeList.CreateFromFile(FMapFileName, FConverter)
      except
        FreeAndNil(FShapes);
      end
    else
      raise Exception.Create('Unknown File Format');
    FShapes.EmbeddedData := False;
  end
  else
    FShapes.Clear;
  FFirstReading := False;
end;

procedure TfrxMapFileLayer.SetLayerTags(const Value: TStringList);
begin
  FLayerTags.Assign(Value);
end;

procedure TfrxMapFileLayer.SetMapFileName(const AMapFileName: String);
begin
  if SafeFileName(FMapFileName) <> SafeFileName(AMapFileName) then
  begin
    FFirstReading := FFirstReading or (FMapFileName <> '');
    FMapFileName := Trim(AMapFileName);
    ReRead;
  end
  else if FMapFileName <> AMapFileName then
    FMapFileName := Trim(AMapFileName);
end;

{ TMapLayerList }

constructor TMapLayerList.Create(AObjects: TList);
begin
  FObjects := AObjects;

  FSelectedLayerIndex := Unknown;
  FPreviousSelectedLayerIndex := Unknown;
end;

procedure TMapLayerList.Exchange(Index1, Index2: Integer);
begin
  FObjects.Exchange(Index1, Index2);
end;

function TMapLayerList.GetCount: Integer;
begin
  Result := FObjects.Count;
end;

procedure TMapLayerList.GetData;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].GetData;
end;

function TMapLayerList.GetLayer(Index: Integer): TfrxCustomLayer;
begin
  Result := TfrxCustomLayer(FObjects[Index]);
end;

function TMapLayerList.GetSelectedLayer: TfrxCustomLayer;
begin
  if FSelectedLayerIndex = Unknown then
    Result := nil
  else
    Result := Items[FSelectedLayerIndex];
end;

function TMapLayerList.IndexOf(Item: Pointer): Integer;
begin
  Result := FObjects.IndexOf(Item);
end;

function TMapLayerList.IsInclude(P: TfrxPoint): Boolean;
var
  i, j: Integer;
begin
  FPreviousSelectedLayerIndex := FSelectedLayerIndex;
  FSelectedLayerIndex := Unknown;
  for i := Count - 1 downto 0 do
    if Items[i].IsInclude(P) then
    begin
      FSelectedLayerIndex := i;
      for j := i - 1 downto 0 do
        Items[j].ClearSelectedShape;
      Break;
    end
    else
      Items[i].ClearSelectedShape;
  Result := FSelectedLayerIndex <> Unknown;
end;

function TMapLayerList.IsSelectedShapeChanded: Boolean;
begin
  Result := (FPreviousSelectedLayerIndex <> FSelectedLayerIndex) or
    (FSelectedLayerIndex <> Unknown) and SelectedLayer.IsSelectedShapeChanded;
end;

initialization

  frxPropertyEditors.Register(TypeInfo(String), TfrxComponent, 'LabelColumn', TfrxLabelColumnProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxComponent, 'SpatialColumn', TfrxLabelColumnProperty);

  RegisterClasses([TfrxMapFileLayer, TfrxApplicationLayer]);

end.
