
{******************************************}
{                                          }
{             FastReport v6.0              }
{          Map Interactive Layer           }
{                                          }
{        Copyright (c) 2017 - 2018         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapInteractiveLayer;

interface

{$I frx.inc}

uses
  Classes,
  frxMapLayer, frxMapHelpers, frxClass, frxMapShape;

type
  TfrxMapInteractiveLayer = class (TfrxCustomLayer)
  private
    FEditedShape: TShape;
  protected
    procedure AddValueList(vaAnalyticalValue: Variant); override; // Empty
  public
    constructor Create(AOwner: TComponent); override;

    procedure AddShape(const ShapeData: TShapeData);
    procedure ReplaceShape(const ShapeData: TShapeData);

    function IsSelectEditedShape(P: TfrxPoint; Threshold: Extended): Boolean;
    function IsHighlightSelectedShape: boolean; override;
    function IsHiddenShape(iRecord: Integer): Boolean; override;
    function IsEditing: Boolean;
    procedure CancelEditedShape(NeedRebuild: Boolean = True);
    procedure RemoveEditedShape;

    property EditedShape: TShape read FEditedShape;
  published
    property LabelColumn;
  end;

implementation

uses
  Math, Contnrs, Types, frxMap, frxAnaliticGeometry;

{ TfrxMapInteractiveLayer }

procedure TfrxMapInteractiveLayer.AddShape(const ShapeData: TShapeData);
begin
  FShapes.AddShapeData(ShapeData);
  FShapes.SetMapRectByData;
end;

procedure TfrxMapInteractiveLayer.AddValueList(vaAnalyticalValue: Variant);
begin
  // Empty
end;

procedure TfrxMapInteractiveLayer.CancelEditedShape(NeedRebuild: Boolean = True);
begin
  FEditedShape := nil;
  TfrxMapView(MapView).NeedBuildVector := NeedRebuild;
end;

constructor TfrxMapInteractiveLayer.Create(AOwner: TComponent);
begin
  inherited;

  FShapes := TShapeList.Create(FConverter);
  FShapes.EmbeddedData := True;
  CancelEditedShape;
end;

function TfrxMapInteractiveLayer.IsEditing: Boolean;
begin
  Result := FEditedShape <> nil;
end;

function TfrxMapInteractiveLayer.IsHiddenShape(iRecord: Integer): Boolean;
begin
  Result := FShapes[iRecord] = EditedShape;
end;

function TfrxMapInteractiveLayer.IsHighlightSelectedShape: boolean;
begin
  Result := IsDesigning;
end;

function TfrxMapInteractiveLayer.IsSelectEditedShape(P: TfrxPoint; Threshold: Extended): Boolean;
var
  i: Integer;
  MD: TMinDistance;
begin
  MD := TMinDistance.Create(Threshold);
  for i := 0 to FShapes.Count - 1 do
    MD.Add(FShapes.CanvasDistance(i, P), i);
  Result := MD.IsNear;
  if Result then
  begin
    FEditedShape := FShapes[MD.Index];
    TfrxMapView(MapView).NeedBuildVector := True;
  end;
  MD.Free;
end;

procedure TfrxMapInteractiveLayer.RemoveEditedShape;
begin
  FShapes.Remove(EditedShape);
  CancelEditedShape;
  TfrxMapView(MapView).NeedBuildVector := True;
end;

procedure TfrxMapInteractiveLayer.ReplaceShape(const ShapeData: TShapeData);
begin
  FShapes.RePlaceShapeData(FShapes.IndexOf(EditedShape), ShapeData);
  FShapes.SetMapRectByData;
end;

initialization

  RegisterClasses([TfrxMapInteractiveLayer]);

end.
