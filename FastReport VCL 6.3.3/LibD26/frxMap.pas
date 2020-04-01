
{******************************************}
{                                          }
{             FastReport v6.0              }
{                Map Object                }
{                                          }
{         Copyright (c) 2015 - 2018        }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMap;

interface

{$I frx.inc}

uses
  Types,
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType, LCLIntf, LCLProc,
{$ENDIF}
  Graphics, Classes, Controls, frxClass, frxMapLayer,
  frxMapHelpers, frxMapRanges, frxMapShape, frxMapLayerForm;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxMapObject = class(TComponent)  // fake component
  end;
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxMapView = class(TfrxView)
  private
    FZoom: Extended;
    FMinZoom: Extended;
    FMaxZoom: Extended;
    FMapOffsetX: Extended;
    FMapOffsetY: Extended;
    FKeepAspectRatio: Boolean;
    FMercatorProjection: boolean;
{$IFDEF FRX_USE_BITMAP_MAP}
    FBitmapCache: TBitmap;
    FRepaintCache: Boolean;
{$ENDIF}
    procedure SetZoom(const Value: Extended);
    procedure SetMaxZoom(const Value: Extended);
    procedure SetMinZoom(const Value: Extended);
    procedure SetMercatorProjection(const Value: Boolean);
    function GetSelectedShapeName: String;
  protected
    FLayers: TMapLayerList;
    FHasPreviousOffset: Boolean;
    FPreviousOffset: TfrxPoint;
    FShowMoveArrow: Boolean;
    FConverter: TMapToCanvasCoordinateConverter;
    FFirstDraw: Boolean;
    FPreviousHyperlinkKind: TfrxHyperlinkKind;
    FNeedBuildVector: Boolean;
    FColorScale: TMapScale;
    FSizeScale: TMapScale;
    FOSMFileList: TOSMFileList;
    FClipMap: Boolean;
    oldLeft, oldTop, oldWidth, oldHeight, oldOffsetX, oldOffsetY, oldZoom: Extended;
    FModified: Boolean;
    FAddingLayer: Boolean;
{$IFDEF FRX_USE_BITMAP_MAP}
    FMapViewport: TfrxRect;
{$ENDIF}
    procedure DrawMap(Canvas: TCanvas; ScaleX, ScaleY: Extended);
    function IsMoveArrowArea(X, Y: Extended): Boolean;
    function CanvasSize: TfrxPoint;
    procedure DefineProperties(Filer: TFiler); override;
    procedure InitConverter;
    function IsAlignByZoomPolygon: Boolean;
    procedure ZoomRecenter(CenterX, CenterY, Factor: Extended);
    procedure EnableSupportedHyperlink;
    procedure DisableSupportedHyperlink;
    function ShowMoveArrow: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure DrawClipped(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    function GetContainerObjects: TList; override;
    function IsContain(X, Y: Extended): Boolean; override;
    procedure GetData; override;
    procedure ExpandVar(var Expr: String);
    procedure AddLayer(LayerType: TLayerType; IsEmbed: Boolean; AMapFileName: string; DefaultReport: TfrxReport = nil);
    procedure GeometrySave;
    procedure GeometryChange(ALeft, ATop, AWidth, AHeight: Extended);
    procedure GeometryRestore;
    procedure ZoomByRect(ZoomRect: TfrxRect);
    procedure ZoomByFactor(Factor: Extended);

    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure DoMouseMove(X, Y: Integer; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseEnter(aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseLeave(aNextObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams); override;

    property Converter: TMapToCanvasCoordinateConverter read FConverter;
    property SelectedShapeName: String read GetSelectedShapeName;
    property Layers: TMapLayerList read FLayers;
    property OSMFileList: TOSMFileList read FOSMFileList;
    property ClipMap: Boolean read FClipMap write FClipMap;
    property NeedBuildVector: Boolean read FNeedBuildVector write FNeedBuildVector;
{$IFDEF FRX_USE_BITMAP_MAP}
    property MapViewport: TfrxRect read FMapViewport;
{$ENDIF}
  published
    property Font;
    property FillType;
    property Fill;
    property Frame;
    property Cursor;

    property Zoom: Extended read FZoom write SetZoom;
    property MaxZoom: Extended read FMaxZoom write SetMaxZoom;
    property MinZoom: Extended read FMinZoom write SetMinZoom;
    property OffsetX: Extended read FMapOffsetX write FMapOffsetX;
    property OffsetY: Extended read FMapOffsetY write FMapOffsetY;
    property KeepAspectRatio: Boolean read FKeepAspectRatio write FKeepAspectRatio;
    property MercatorProjection: Boolean read FMercatorProjection write SetMercatorProjection;

    property ColorScale: TMapScale read FColorScale;
    property SizeScale: TMapScale read FSizeScale;
  end;

implementation

uses
  Math, frxRes, frxUtils, frxDesgn, Forms,
  frxDsgnIntf, Dialogs, Contnrs, frxMapRTTI, frxMapEditor,
  frxMapInteractiveLayer, frxMapGeodataLayer, frxMapInPlaceEditor;

const
  ZoomFactor = 1.1;
  SupportedHyperlinkKind = [hkDetailReport, hkDetailPage];

{ TfrxMapView }

procedure TfrxMapView.AddLayer(LayerType: TLayerType; IsEmbed: Boolean; AMapFileName: string; DefaultReport: TfrxReport);
var
  MapFileLayer: TfrxMapFileLayer;
begin
  try
    FAddingLayer := True;
    case LayerType of
      ltApplication:
        with TfrxApplicationLayer.Create(Self) do
          CreateUniqueName;
      ltInteractive:
        with TfrxMapInteractiveLayer.Create(Self) do
          CreateUniqueName;
      ltMapFile:
        begin
          with TfrxMapFileLayer.Create(Self) do
            CreateUniqueName(DefaultReport);
          if AMapFileName <> '' then
          begin
            MapFileLayer := TfrxMapFileLayer(FLayers[FLayers.Count - 1]);
            MapFileLayer.JustAdded;
            MapFileLayer.MapFileName := AMapFileName;
            if IsEmbed then
              MapFileLayer.Embed;
          end;
        end;
      ltGeodata:
        with TfrxMapGeodataLayer.Create(Self) do
          CreateUniqueName;
    end;
  finally
    FAddingLayer := False;
  end;
end;

function TfrxMapView.CanvasSize: TfrxPoint;
var
  CanvasWidth, CanvasHeight: Extended;
begin
  CanvasWidth := Width * Zoom * FScaleX;
  CanvasHeight := Height * Zoom * FScaleY;
  if KeepAspectRatio and FConverter.IsHasData then
    if FConverter.AspectRatio > CanvasWidth / CanvasHeight then
      CanvasHeight := CanvasWidth / FConverter.AspectRatio
    else
      CanvasWidth := CanvasHeight * FConverter.AspectRatio;
  Result := frxPoint(CanvasWidth, CanvasHeight);
end;

constructor TfrxMapView.Create(AOwner: TComponent);
begin
  inherited;
  FZoom := 1;
  FMinZoom := 1;
  FMaxZoom := 50;
  FMapOffsetX := 0.0;
  FMapOffsetY := 0.0;
  FKeepAspectRatio := True;

  frComponentStyle := frComponentStyle + [csObjectsContainer];

  FLayers := TMapLayerList.Create(Objects);

  FConverter := TMapToCanvasCoordinateConverter.Create;
  MercatorProjection := True;

  FHasPreviousOffset := False;
  FShowMoveArrow := False;
  FFirstDraw := True;
  FPreviousHyperlinkKind := hkCustom;
  FNeedBuildVector := True;
  FClipMap := False;
  FAddingLayer := False;

  FColorScale := TMapScale.Create;
  FSizeScale := TMapScale.Create;

  FOSMFileList := TOSMFileList.Create;
{$IFDEF FRX_USE_BITMAP_MAP}
  FBitmapCache := TBitmap.Create;
  FRepaintCache := True;
{$ENDIF}
end;

procedure TfrxMapView.DefineProperties(Filer: TFiler);
begin
  inherited;
  if [csDesigning, csLoading] * ComponentState <> [] then // dfm
    Filer.DefineBinaryProperty('Converter', FConverter.ReadDFM, FConverter.WriteDFM, True)
  else // fr3
    Filer.DefineProperty('Converter', FConverter.Read, FConverter.Write, True);
end;

destructor TfrxMapView.Destroy;
begin
  FLayers.Free;
  FConverter.Free;
  FColorScale.Free;
  FSizeScale.Free;
  FOSMFileList.Free;
{$IFDEF FRX_USE_BITMAP_MAP}
  FBitmapCache.Free;
{$ENDIF}
  inherited;
end;

procedure TfrxMapView.DisableSupportedHyperlink;
begin
  if Hyperlink.Kind in SupportedHyperlinkKind then
  begin
    FPreviousHyperlinkKind := Hyperlink.Kind;
    Hyperlink.Kind := hkCustom;
    Screen.Cursor := crArrow;
  end;
end;

function TfrxMapView.DoMouseDown(X, Y: Integer; Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
  FModified := False;
  FNeedBuildVector:= False;
  if (Button = mbLeft) and not IsMoveArrowArea(X / FScaleX, Y / FScaleY) then
  begin
{$IFDEF FRX_USE_BITMAP_MAP}
    FPreviousOffset := frxPoint(X - AbsLeft * FScaleX,
                                Y - AbsTop * FScaleY);
{$ELSE}
    FPreviousOffset := frxPoint(X - OffsetX * FScaleX - AbsLeft * FScaleX,
                                Y - OffsetY * FScaleY - AbsTop * FScaleY);
{$ENDIF}
    FHasPreviousOffset := True;
    Result := True;

    if EventParams.EventSender = esDesigner then
      if FLayers.IsInclude(FPreviousOffset) and IsSelected then
      begin
        EventParams.SelectionList.ClearInspectorList;
        EventParams.SelectionList.Add(FLayers.SelectedLayer.SelectedShape);
      end
      else
      begin
        EventParams.SelectionList.Clear;
        EventParams.SelectionList.Add(Self);
      end;
    FPreviousOffset := frxPoint(X, Y);
  end;
end;

procedure TfrxMapView.DoMouseEnter(aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  FModified := False;
  FShowMoveArrow := EventParams.EventSender = esDesigner;
end;

procedure TfrxMapView.DoMouseLeave(aNextObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
begin
  if FHasPreviousOffset and IsDesigning then
    Exit;
  inherited;
  FShowMoveArrow := False;
  Screen.Cursor := crDefault;
  EnableSupportedHyperlink;
  EventParams.Modified := FModified;
  FModified := False;
  if not IsDesigning then
    FHasPreviousOffset := False;
end;

procedure TfrxMapView.DoMouseMove(X, Y: Integer; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  Inner: TfrxPoint;
begin
  Inner := frxPoint(X - AbsLeft * FScaleX, Y - AbsTop * FScaleY);
  if FHasPreviousOffset then
  begin
    OffsetX := OffsetX + ((X - FPreviousOffset.X) / FScaleX);
    OffsetY := OffsetY + ((Y - FPreviousOffset.Y) / FScaleY);
    if (Report <> nil) and (Report.Designer <> nil) then
      TfrxCustomDesigner(Report.Designer).UpdateInspector;
    EventParams.Refresh := True;
    FModified := True;
    FNeedBuildVector:= False;
//    FPreviousOffset := frxPoint(X - AbsLeft * FScaleX, Y - AbsTop * FScaleY);
    FPreviousOffset := frxPoint(X, Y);
  end
  else if ([ssLeft, ssRight, ssMiddle] * Shift = []) then
    case EventParams.EventSender of
      esDesigner:
        begin
          if (Min(FScaleX, FScaleY) > 1e-3) and IsMoveArrowArea(X / FScaleX, Y / FScaleY) then
            Screen.Cursor := crSizeAll
          else
            Screen.Cursor := crDefault;
          EventParams.Refresh := False;
        end;
      esPreview:
        begin
{$IFDEF FRX_USE_BITMAP_MAP}
          if FLayers.IsInclude(frxPoint(Inner.X, Inner.Y))
{$ELSE}
          if FLayers.IsInclude(frxPoint(Inner.X - OffsetX  * FScaleX, Inner.Y - OffsetY * FScaleY))
{$ENDIF}
             and (FLayers.SelectedLayer.SelectedShapeValue <> '') then
          begin
            EventParams.Refresh := FLayers.IsSelectedShapeChanded;
            EnableSupportedHyperlink;
          end
          else
          begin
            EventParams.Refresh := EventParams.Refresh or FLayers.IsSelectedShapeChanded
              and (Hyperlink.Kind in SupportedHyperlinkKind);
            DisableSupportedHyperlink;
          end;
        end;
  end;
end;

procedure TfrxMapView.DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
begin
  if Button = mbLeft then
    FHasPreviousOffset := False;
  EventParams.Modified := FModified;
end;

function TfrxMapView.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  EventParams.Refresh := True;
  Result := True;

  ZoomByFactor(IfReal(WheelDelta > 0, ZoomFactor, 1 / ZoomFactor));
  FModified := True;
  if (Report <> nil) and (Report.Designer <> nil) then
    TfrxCustomDesigner(Report.Designer).UpdateInspector;
end;

procedure TfrxMapView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
{$IFDEF FRX_USE_BITMAP_MAP}
var
  oldFX, oldFY: Integer;
{$ENDIF}
  procedure StartDraw;
  begin
    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    DrawBackground;
    InitConverter;
  end;
begin
  if FAddingLayer then
    Exit;
{$IFDEF FRX_USE_BITMAP_MAP}
  oldFX := FX;
  oldFY := FY;
{$ENDIF}
  StartDraw;
{$IFDEF FRX_USE_BITMAP_MAP}
  { do not refresh bitmap when moving object or scroll }
  FRepaintCache := (FX = oldFX) and (FY = oldFY);
{$ENDIF}

  if FFirstDraw and IsAlignByZoomPolygon then
    StartDraw;
  FFirstDraw := False;

  DrawMap(Canvas, ScaleX, ScaleY);

  if not FObjAsMetafile then
    DrawFrame;
  if ShowMoveArrow then
    frxResources.MainButtonImages.Draw(Canvas, FX, FY - 6, 110);
end;

procedure TfrxMapView.DrawClipped(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  CLipMap := True;
  try
    Draw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  finally
    CLipMap := False;
  end;
end;

{$IFDEF FRX_USE_BITMAP_MAP}
procedure TfrxMapView.DrawMap(Canvas: TCanvas; ScaleX, ScaleY: Extended);
var
  i, SavedDC: Integer;
  Bmp: TBitmap;
  p: TfrxPoint;

  procedure DrawScale(MapRanges: TMapRanges);
  begin
    if MapRanges.Visible and (MapRanges.RangeCount > 0) then
    begin
      with MapRanges.MapScale.LeftTopPoint(Rect(FX, FY, FX1 - MapRanges.Width + 1, FY1 - MapRanges.Height + 1)) do
        try
          Canvas.Lock;
          MapRanges.Draw(Bmp.Canvas);
        finally
          Canvas.Unlock;
        end;
    end;
  end;

begin
  SavedDC := SaveDC(Canvas.Handle);
  Bmp := FBitmapCache;
  ClipMap := True;
  try
    if FRepaintCache or (Abs(Bmp.Width - (FX1 - FX)) > 1) or (Abs(Bmp.Height - (FY1 - FY)) > 1) then
    begin
      Bmp.Width := FX1 - FX;
      Bmp.Height := FY1 - FY;
      p := FConverter.CanvasToMap(frxPoint(0, 0));
      FMapViewport.Left := p.X;
      FMapViewport.Bottom := p.Y;
      p := FConverter.CanvasToMap(frxPoint(Bmp.Width  , Bmp.Height));
      FMapViewport.Right := p.X;
      FMapViewport.Top := p.Y;
      Bmp.Canvas.Brush.Color := clWhite;
      Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
      Fill.Draw(Bmp.Canvas, 0, 0, Bmp.Width, Bmp.Height, 1, 1);
      IntersectClipRect(Canvas.Handle, FX, FY, FX1, FY1);

      for i := 0 to FLayers.Count - 1 do
        if FLayers[i].Active then
        begin
          FLayers[i].IsDesigning := IsDesigning;
          FLayers[i].DrawOn(Bmp.Canvas, Hyperlink.Kind in SupportedHyperlinkKind, frxRect(0, 0, Bmp.Width, Bmp.Height));
        end;
      if ColorScale.Visible then
        for i := 0 to FLayers.Count - 1 do
          DrawScale(FLayers[i].ColorRanges);
      if SizeScale.Visible then
        for i := 0 to FLayers.Count - 1 do
          DrawScale(FLayers[i].SizeRanges);
    end;
    Canvas.Lock;
    try
      Canvas.Draw(FX, FY, Bmp);
    finally
      Canvas.Unlock;
    end;

  finally
    RestoreDC(Canvas.Handle, SavedDC);
    FNeedBuildVector:= True;
    ClipMap := False;
  end;
end;
{$ELSE}
procedure TfrxMapView.DrawMap(Canvas: TCanvas; ScaleX, ScaleY: Extended);

  procedure DrawScale(MapRanges: TMapRanges);
  var
    VectorGraphic: TGraphic;
  begin
    if MapRanges.Visible and (MapRanges.RangeCount > 0) then
    begin
      VectorGraphic := MapRanges.GetGraphic;
      with MapRanges.MapScale.LeftTopPoint(Rect(FX, FY, FX1 - VectorGraphic.Width + 1, FY1 - VectorGraphic.Height + 1)) do
        try
          Canvas.Lock;
          Canvas.Draw(X, Y, VectorGraphic);
        finally
          Canvas.Unlock;
        end;
      VectorGraphic.Free;
    end;
  end;

var
  i, SavedDC: Integer;
begin
  SavedDC := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, FX, FY, FX1, FY1);
    for i := 0 to FLayers.Count - 1 do
      if FLayers[i].Active then
      begin
        FLayers[i].IsDesigning := IsDesigning;
        if FNeedBuildVector or ClipMap then
          FLayers[i].BuildGraphic(CanvasSize, Hyperlink.Kind in SupportedHyperlinkKind);
        Canvas.Lock;
        try
          Canvas.Draw(FX + Round(OffsetX * ScaleX), FY + Round(OffsetY * ScaleY), FLayers[i].VectorGraphic);
        finally
          Canvas.Unlock;
        end;
      end;

    if ColorScale.Visible then
      for i := 0 to FLayers.Count - 1 do
        DrawScale(FLayers[i].ColorRanges);
    if SizeScale.Visible then
      for i := 0 to FLayers.Count - 1 do
        DrawScale(FLayers[i].SizeRanges);

  finally
    RestoreDC(Canvas.Handle, SavedDC);
    FNeedBuildVector:= True;
  end;
end;
{$ENDIF}



procedure TfrxMapView.EnableSupportedHyperlink;
begin
  if FPreviousHyperlinkKind in SupportedHyperlinkKind then
    Hyperlink.Kind := FPreviousHyperlinkKind;
  Screen.Cursor := crDefault;
end;

procedure TfrxMapView.ExpandVar(var Expr: String);
begin
  ExpandVariables(Expr);
end;

procedure TfrxMapView.GeometryChange(ALeft, ATop, AWidth, AHeight: Extended);
var
  Factor: Extended;
begin
  Factor := Max(Width / Max(AWidth, 1), Height / Max(AHeight, 1));
  OffsetX := OffsetX / Factor;
  OffsetY := OffsetY / Factor;
  Left := ALeft;
  Top := ATop;
  Width := AWidth;
  Height := AHeight;
end;

procedure TfrxMapView.GeometryRestore;
begin
  Left := oldLeft;
  Top := oldTop;
  Width := oldWidth;
  Height := oldHeight;
  OffsetX := oldOffsetX;
  OffsetY := oldOffsetY;
  Zoom := oldZoom;
end;

procedure TfrxMapView.GeometrySave;
begin
  oldLeft := Left;
  oldTop := Top;
  oldWidth := Width;
  oldHeight := Height;
  oldOffsetX := OffsetX;
  oldOffsetY := OffsetY;
  oldZoom := Zoom;
end;

function TfrxMapView.GetContainerObjects: TList;
begin
  Result := Objects;
end;

procedure TfrxMapView.GetData;
begin
  inherited;
  FLayers.GetData;
end;

function TfrxMapView.GetSelectedShapeName: String;
begin
  if Assigned(FLayers.SelectedLayer) then
    Result := FLayers.SelectedLayer.SelectedShapeName
  else
    Result := '';
end;

procedure TfrxMapView.InitConverter;
var
  i: integer;
  MapRect: TfrxRect;
begin
  FConverter.Init;
  for i := 0 to FLayers.Count - 1 do
    if FLayers[i].IsHasMapRect(MapRect) then
      FConverter.IncludeRect(MapRect);
  FConverter.SetCanvasSize(CanvasSize);
{$IFDEF FRX_USE_BITMAP_MAP}
  FConverter.SetOffset(OffsetX * FScaleX, OffsetY * FScaleY);
  FConverter.UseOffset := True;
{$ELSE}
  FConverter.SetOffset(OffsetX, OffsetY);
  FConverter.UseOffset := False;
{$ENDIF}
  FConverter.MercatorProjection := MercatorProjection;
end;

function TfrxMapView.IsAlignByZoomPolygon: Boolean;
var
  i: integer;
  ZoomRect: TfrxRect;
begin
  Result := False;
  for i := 0 to FLayers.Count - 1 do
    if FLayers[i].IsHasZoomRect(ZoomRect) then
    begin
      Result := True;
      ZoomByRect(ZoomRect);
      Break;
    end;
end;

function TfrxMapView.IsContain(X, Y: Extended): Boolean;
begin
  Result := IsMoveArrowArea(X, Y) or inherited IsContain(X, Y);
end;

function TfrxMapView.IsMoveArrowArea(X, Y: Extended): Boolean;
begin
  Result := ShowMoveArrow and (AbsLeft <= X) and (AbsLeft + 16 >= X) and
                               (AbsTop - 6 <= Y) and (AbsTop + 16 >= Y);
end;

procedure TfrxMapView.SetMaxZoom(const Value: Extended);
begin
  FMaxZoom := Max(1.0, Value);
end;

procedure TfrxMapView.SetMercatorProjection(const Value: Boolean);
begin
  FMercatorProjection := Value;
  FConverter.MercatorProjection := Value;
end;

procedure TfrxMapView.SetMinZoom(const Value: Extended);
begin
  FMinZoom := Min(1.0, Value);
end;

procedure TfrxMapView.SetZoom(const Value: Extended);
begin
  FZoom := Max(MinZoom, Min(MaxZoom, Value));
end;

function TfrxMapView.ShowMoveArrow: Boolean;
begin
  Result := FShowMoveArrow or IsSelected;
end;

procedure TfrxMapView.ZoomByFactor(Factor: Extended);
begin
  ZoomRecenter(- OffsetX + Width / 2, - OffsetY + Height / 2, Factor);
end;

procedure TfrxMapView.ZoomByRect(ZoomRect: TfrxRect);
var
  Factor: Extended;
begin
  Factor := Min(Width / Max(ZoomRect.Right - ZoomRect.Left, 1),
               Height / Max(ZoomRect.Bottom - ZoomRect.Top, 1));

  ZoomRecenter((ZoomRect.Left + ZoomRect.Right) / 2,
               (ZoomRect.Top + ZoomRect.Bottom) / 2,
               Factor);
end;

procedure TfrxMapView.ZoomRecenter(CenterX, CenterY, Factor: Extended);
var
  OldZoom: Extended;
begin
  OldZoom := Zoom;
  Zoom := Zoom * Factor;
  Factor := Zoom / OldZoom;
  OffsetX := - CenterX * Factor + Width / 2;
  OffsetY := - CenterY * Factor + Height / 2;
end;

initialization
  frxObjects.RegisterObject1(TfrxMapView, nil, frxResources.Get('obMap'), '', 0, 69);
  frxObjects.RegisterObject1(TfrxMapFileLayer, nil, '', '', 0, 74, [ctNone]);
  frxObjects.RegisterObject1(TfrxApplicationLayer, nil, '', '', 0, 74, [ctNone]);

finalization
  frxObjects.Unregister(TfrxMapView);

end.
