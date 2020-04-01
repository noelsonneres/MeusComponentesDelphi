
{******************************************}
{                                          }
{             FastReport v5.0              }
{              ZipCode Object              }
{                                          }
{            Copyright (c) 2017            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxZipCode;

{$I frx.inc}

interface

uses
  Classes, Graphics, Types,
  frxClass;

type
  TZipCodeKind = (zcCustom, zcInternational, zcRF, zcSample);
  {$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  TfrxZipCodeView = class(TfrxView)
  private
    FmmDigitWidth: Extended;
    FmmDigitHeight: Extended;
    FmmSpacing: Extended;
    FmmLineWidth: Extended;
    FShowMarkers: Boolean;
    FShowGrid: Boolean;
    FExpression: String;
    FText: String;
    FDigitCount: Integer;
    FKind: TZipCodeKind;
    FColor: TColor;
    procedure SetKind(const Value: TZipCodeKind);
    procedure SetmmDigitWidth(const Value: Extended);
    procedure SetmmDigitHeight(const Value: Extended);
    procedure SetmmLineWidth(const Value: Extended);
    procedure SetmmSpacing(const Value: Extended);
    procedure SetDigitCount(const Value: Integer);
    procedure SetShowMarkers(const Value: Boolean);
    procedure SetShowGrid(const Value: Boolean);
    procedure SetText(const Value: String);
  protected
    FMarker: Integer; // if ShowMarkers then FMarker := 1 else FMarker := 0;
    F1mm: TfrxPoint;
    FSpacing: Extended;
    FMarkerHeight: Extended;
    FMarkerWidth: Extended;
    FGridPoint: TfrxPoint;
    FGridStep: TfrxPoint;
    FDigitLeftTop: TfrxPoint;
    FDigitWidth: Extended;
    FDigitHeight: Extended;
    FDigitPenThickness: Extended;
    procedure DrawSegment(Canvas: TCanvas; Number: Integer);
    procedure PaintPolyline(Canvas: TCanvas; const Ps: array of TPoint);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure GetData; override;
  published
    property FillType;
    property Fill;
    property Cursor;

    property DataField;
    property DataSet;
    property DataSetName;
    property Expression: String read FExpression write FExpression;
    property Text: String read FText write SetText;

    property Kind: TZipCodeKind read FKind write SetKind;
    property mmDigitWidth: Extended read FmmDigitWidth write SetmmDigitWidth;
    property mmDigitHeight: Extended read FmmDigitHeight write SetmmDigitHeight;
    property mmLineWidth: Extended read FmmLineWidth write SetmmLineWidth;
    property mmSpacing: Extended read FmmSpacing write SetmmSpacing;
    property DigitCount: Integer read FDigitCount write SetDigitCount;
    property ShowMarkers: Boolean read FShowMarkers write SetShowMarkers;
    property ShowGrid: Boolean read FShowGrid write SetShowGrid;
    property Color: TColor read FColor write FColor;
  end;

implementation

uses
  Variants,
  frxDsgnIntf, frxRes, frxUtils, frxZipCodeInPlaceEditor;

const
  mmPointDiameter = 0.25;
  mmMarkerOverhang = 1;
  mmMarkerHeight = 2;

{ Utilities }

function p(X, Y: Integer): TPoint;
begin
  Result := Point(X, Y);
end;

{ TfrxZipCodeView }

constructor TfrxZipCodeView.Create(AOwner: TComponent);
begin
  inherited;

  Kind := zcRF;
end;

procedure TfrxZipCodeView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  i: Integer;
begin
  F1mm := frxPoint(fr01cm * ScaleX, fr01cm * ScaleY);
  FSpacing := mmSpacing * F1mm.X;
  FMarkerHeight := mmMarkerHeight * F1mm.Y;
  FMarkerWidth := (mmDigitWidth + 2 * mmMarkerOverhang) * F1mm.X;
  FGridPoint := frxPoint(0.25 * F1mm.X, 0.25 * F1mm.Y);
  FGridStep := frxPoint(mmDigitWidth / 5 * F1mm.X, mmDigitHeight / 10 * F1mm.Y);
  FDigitWidth := mmDigitWidth * F1mm.X;
  FDigitHeight := mmDigitHeight * F1mm.Y;
  FDigitPenThickness := mmLineWidth * (F1mm.X + F1mm.Y) / 2;

  if ShowMarkers then FMarker := 1 else FMarker := 0;
  Width := (DigitCount + FMarker) * FSpacing / ScaleX;
  Height := (FDigitHeight + FMarker * 2 * FMarkerHeight + FDigitPenThickness / 2) / ScaleY + 1;

  inherited;

  Canvas.Pen.Color := Color;
  Canvas.Brush.Color := Color;
  Canvas.Brush.Style := bsSolid;
  for i := 0 to DigitCount + FMarker - 1 do
    DrawSegment(Canvas, i);
  if FHighlighted then
    TransparentFillRect(FCanvas.Handle, FX, FY, FX1, FY1, clSkyBlue);
end;

procedure TfrxZipCodeView.DrawSegment(Canvas: TCanvas; Number: Integer);
var
  iX, iY, x1, y1, x2, y2, Index: Integer;
  MarkerX: Extended;
  Digit: Char;
  FirstMarker: boolean;
begin
  MarkerX := FX + Round(Number * FSpacing);
  FDigitLeftTop := frxPoint(MarkerX + 1 * F1mm.X,
                            FY + Round(FMarker * 2 * FMarkerHeight));
  Canvas.Pen.Width := 1;
  if ShowMarkers then
  begin
    Canvas.Rectangle(Round(MarkerX), FY,
      Round(MarkerX + FMarkerWidth), Round(FY + FMarkerHeight));

    if Number = 0 then
      Canvas.Rectangle(Round(MarkerX), Round(FY + FMarkerHeight + F1mm.X),
        Round(MarkerX + FMarkerWidth), Round(FY + FMarkerHeight + 2 * F1mm.Y));
  end;

  FirstMarker := ShowMarkers and (Number = 0);

  if not FirstMarker and ShowGrid then
    for iX := 0 to 5 do
      for iY := 0 to 10 do
        if (iX mod 5 = 0) or (iY mod 5 = 0) or ((iX + iY) mod 5 = 0)then
        begin
          x1 := Round(FDigitLeftTop.X + iX * FGridStep.X - FGridPoint.X / 2);
          y1 := Round(FDigitLeftTop.Y + iY * FGridStep.Y - FGridPoint.Y / 2);
          x2 := x1 + Round(FGridPoint.X);
          y2 := y1 + Round(FGridPoint.Y);
          Canvas.Ellipse(x1, y1, x2 + 1, y2 + 1);
        end;

  Index := Number + 1 - FMarker;
  Canvas.Pen.Width := Round(FDigitPenThickness);
  if not FirstMarker and (Index <= Length(Text)) then
  begin
    Digit := Text[Index];
    case Digit of
      '0': PaintPolyline(Canvas,
        [p(0, 0), p(1, 0), p(1, 2), p(0, 2), p(0, 0)]);
      '1': PaintPolyline(Canvas,
        [p(0, 1), p(1, 0), p(1, 2)]);
      '2': PaintPolyline(Canvas,
        [p(0, 0), p(1, 0), p(1, 1), p(0, 2), p(1, 2)]);
      '3': PaintPolyline(Canvas,
        [p(0, 0), p(1, 0), p(0, 1), p(1, 1), p(0, 2)]);
      '4': PaintPolyline(Canvas,
        [p(0, 0), p(0, 1), p(1, 1), p(1, 0), p(1, 2)]);
      '5': PaintPolyline(Canvas,
        [p(1, 0), p(0, 0), p(0, 1), p(1, 1), p(1, 2), p(0, 2)]);
      '6': PaintPolyline(Canvas,
        [p(1, 0), p(0, 1), p(0, 2), p(1, 2), p(1, 1), p(0, 1)]);
      '7': PaintPolyline(Canvas,
        [p(0, 0), p(1, 0), p(0, 1), p(0, 2)]);
      '8': PaintPolyline(Canvas,
        [p(0, 0), p(1, 0), p(1, 2), p(0, 2), p(0, 0), p(0, 1), p(1, 1)]);
      '9': PaintPolyline(Canvas,
        [p(0, 2), p(1, 1), p(1, 0), p(0, 0), p(0, 1), p(1, 1)]);
    end;
  end;
end;

procedure TfrxZipCodeView.GetData;
begin
  inherited;

  if IsDataField then
    FText := VarToStr(DataSet.Value[DataField])
  else if FExpression <> '' then
    FText := VarToStr(Report.Calc(FExpression));
end;

procedure TfrxZipCodeView.PaintPolyline(Canvas: TCanvas; const Ps: array of TPoint);
var
  Points: array of TPoint;
  i: Integer;
begin
  SetLength(Points, Length(Ps));

  for i := Low(Ps) to High(Ps) do
    Points[i] := Point(Round(FDigitLeftTop.X + Ps[i].X * FDigitWidth),
                       Round(FDigitLeftTop.Y + Ps[i].Y * FDigitHeight / 2));
  Canvas.Polyline(Points);
end;

procedure TfrxZipCodeView.SetDigitCount(const Value: Integer);
begin
  if FDigitCount <> Value then
  begin
    FDigitCount := Value;
    FKind := zcCustom;
  end;
end;

procedure TfrxZipCodeView.SetKind(const Value: TZipCodeKind);
begin
  if Kind <> Value then
  begin
    FKind := Value;
    case Kind of
      zcInternational:
        begin
          mmDigitWidth := 5;
          mmDigitHeight := 10;
          mmLineWidth := 1;
          mmSpacing := 9;
          DigitCount := 3;
          ShowMarkers := True;
          ShowGrid := False;
          Text := '555';
        end;
      zcRF:
        begin
          mmDigitWidth := 5;
          mmDigitHeight := 10;
          mmLineWidth := 0.625;
          mmSpacing := 9;
          DigitCount := 6;
          ShowMarkers := True;
          ShowGrid := True;
        end;
      zcSample:
        begin
          mmDigitWidth := 4;
          mmDigitHeight := 8;
          mmLineWidth := 0.5;
          mmSpacing := 7;
          DigitCount := 10;
          ShowMarkers := False;
          ShowGrid := True;
          Text := '0123456789';
        end;
    else //  zcCustom:
      { Do nothing }
    end;

  end;
end;

procedure TfrxZipCodeView.SetmmDigitHeight(const Value: Extended);
begin
  if FmmDigitHeight <> Value then
  begin
    FmmDigitHeight := Value;
    FKind := zcCustom;
  end;
end;

procedure TfrxZipCodeView.SetmmDigitWidth(const Value: Extended);
begin
  if FmmDigitWidth <> Value then
  begin
    FmmDigitWidth := Value;
    FKind := zcCustom;
  end;
end;

procedure TfrxZipCodeView.SetmmLineWidth(const Value: Extended);
begin
  if FmmLineWidth <> Value then
  begin
    FmmLineWidth := Value;
    FKind := zcCustom;
  end;
end;

procedure TfrxZipCodeView.SetmmSpacing(const Value: Extended);
begin
  if FmmSpacing <> Value then
  begin
    FmmSpacing := Value;
    FKind := zcCustom;
  end;
end;

procedure TfrxZipCodeView.SetShowGrid(const Value: Boolean);
begin
  if FShowGrid <> Value then
  begin
    FShowGrid := Value;
    FKind := zcCustom;
  end;
end;

procedure TfrxZipCodeView.SetShowMarkers(const Value: Boolean);
begin
  if FShowMarkers <> Value then
  begin
    FShowMarkers := Value;
    FKind := zcCustom;
  end;
end;

procedure TfrxZipCodeView.SetText(const Value: String);
begin
  if FText <> Value then
  begin
    FText := Value;
    FKind := zcCustom;
  end;
end;

initialization
  frxObjects.RegisterObject1(TfrxZipCodeView, nil, frxResources.Get('obZipCode'), '', 0, 68);

finalization
  frxObjects.Unregister(TfrxZipCodeView);

end.
