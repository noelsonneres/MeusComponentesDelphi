
{******************************************}
{                                          }
{             FastReport v6.0              }
{            Analitic Geometry             }
{                                          }
{            Copyright (c) 2018            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxAnaliticGeometry;

interface

uses
  Types,
  frxClass;

{$I frx.inc}

type
  TDoublePoint = record
    X, Y: Double;
  end;

  TDoubleRect = record
    case Integer of
      0: (Left, Top, Right, Bottom: Double);
      1: (TopLeft, BottomRight: TDoublePoint);
  end;

  TPointArray = array of TPoint;
  TDoubleArray = array of Double;
  TDoublePointArray = array of TDoublePoint;
  TDoublePointMatrix = array of TDoublePointArray;

type
  TCircle = record
    X, Y, Radius: Extended;
  end;

  TSegment = record
    First, Second: TfrxPoint;
  end;

function Circle(X, Y, Radius: Extended): TCircle;

function Segment(P1, P2: TPoint): TSegment; overload;
function Segment(x1, y1, x2, y2: Extended): TSegment; overload;
function Segment(P1, P2: TDoublePoint): TSegment; overload;
function Segment(P1, P2: TfrxPoint): TSegment; overload;

type
  TMinDistance = class
  private
  protected
    FValue: Extended;
    FIndex: Integer;
    FTreshold: Extended;
  public
    constructor Create(ATreshold: Extended = 0.0);
    procedure Init(ATreshold: Extended);
    procedure Add(AValue: Extended; AIndex: Integer);
    function IsNear: Boolean;
    function IsZero: Boolean;

    property Index: Integer read FIndex;
  end;

function DoublePoint(X, Y: Extended): TDoublePoint; overload;
function DoublePoint(P: TfrxPoint): TDoublePoint; overload;
function DoubleRect(TL, BR: TfrxPoint): TDoubleRect; overload;
function DoubleRect(Left, Top, Right, Bottom: Double): TDoubleRect; overload;
function DoubleRect(R: TRect): TDoubleRect; overload;
function DoubleRectExpand(DR: TDoubleRect; dX, dY: Double): TDoubleRect; overload;
function DoubleRectExpand(DR: TDoubleRect; d: Double): TDoubleRect; overload;
function ConstrainedDR(DR: TDoubleRect; ConstrainWidth, ConstrainHeight: Double): TDoubleRect;
function ToRect(DR: TDoubleRect): TRect;
function ToPoint(X, Y: Extended): TPoint; overload;
function ToPoint(frxPoint: TfrxPoint): TPoint; overload;
function ToFrxPoint(Point: TPoint): TfrxPoint;
function CenterRect(R: TfrxRect): TfrxPoint;
procedure InitRect(var R: TfrxRect; DP: TDoublePoint);
procedure ExpandRect(var R: TfrxRect; X, Y: Extended); overload;
procedure ExpandRect(var R: TfrxRect; DP: TDoublePoint); overload;
procedure ExpandRect(var R: TfrxRect; R1: TfrxRect); overload;
function RectWidth(R: TfrxRect): Extended;
function RectHeight(R: TfrxRect): Extended;
function Boundary(Value, MinValue, MaxValue: Extended): Extended;
function frxCanonicalRect(ALeft, ATop, ARight, ABottom: Extended): TfrxRect; overload;
function frxCanonicalRect(DR: TDoubleRect): TfrxRect; overload;
function IsPointInRect(P: TfrxPoint; R: TfrxRect): Boolean;
function IsInside(Value, Start, Finish: Extended): Boolean;
function IsInsideRect(R: TDoubleRect; P: TfrxPoint): Boolean;
function IsInsideEllipse(R: TDoubleRect; P: TfrxPoint): Boolean;
function IsInsidePolyline(Poly: TDoublePointArray; P: TfrxPoint): Boolean;
function IsInsidePolygon(Poly: TDoublePointArray; P: TfrxPoint): Boolean;
function IsInsideDiamond(R: TDoubleRect; P: TfrxPoint): Boolean;
function IsInsideMultiPolygon(Matrix: TDoublePointMatrix; P: TfrxPoint): Boolean;
function IsInsideMultiPolyline(Matrix: TDoublePointMatrix; P: TfrxPoint): Boolean;

function IsSegmentsIntersect(S1, S2: TSegment): Boolean;
function IsPointInPolygon(x, y: Extended; PolyPoints: TPointArray): Boolean;
function Distance(P1, P2: TfrxPoint): Extended; overload;
function Distance(P1: TDoublePoint; P2: TfrxPoint): Extended; overload;
function Distance(P: TfrxPoint; X, Y: Extended): Extended; overload;
function Distance(P: TPoint; X, Y: Extended): Extended; overload;
function DistancePolyline(Poly: TDoublePointArray; P: TfrxPoint): Extended;
function DistancePolygon(Poly: TDoublePointArray; P: TfrxPoint): Extended;
function DistanceSegment(Segment: TSegment; P: TfrxPoint): Extended;
function DistanceRect(Rect: TDoubleRect; P: TfrxPoint): Extended;
function DistanceDiamond(Rect: TDoubleRect; P: TfrxPoint): Extended;
function DistanceEllipse(Rect: TDoubleRect; P: TfrxPoint): Extended;
function DistancePicture(Rect: TDoubleRect; P: TfrxPoint): Extended;
function DistanceTemplate(Poly: TDoublePointArray; P: TfrxPoint): Extended;
function DistanceMultiPoint(Matrix: TDoublePointMatrix; P: TfrxPoint): Extended;
function DistanceMultiPolyline(Matrix: TDoublePointMatrix; P: TfrxPoint): Extended;
function DistanceMultiPolygon(Matrix: TDoublePointMatrix; P: TfrxPoint): Extended;

function IntersectionEllipse(Rect: TDoubleRect; P: TfrxPoint): TfrxPoint;

function IsEqual(P1, P2: TDoublePoint): Boolean;

const
  Unknown = -1;
  MinSelectDistance = 8;
  MaxDistance = 1e38;

implementation

uses
  Math,
  frxUtils;

function Circle(X, Y, Radius: Extended): TCircle;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Radius := Radius;
end;

function Segment(P1, P2: TDoublePoint): TSegment;
begin
  Result.First := frxPoint(P1.X, P1.Y);
  Result.Second := frxPoint(P2.X, P2.Y);
end;

function Segment(x1, y1, x2, y2: Extended): TSegment;
begin
  Result.First := frxPoint(x1, y1);
  Result.Second := frxPoint(x2, y2);
end;

function Segment(P1, P2: TPoint): TSegment;
begin
  Result.First := frxPoint(P1.X, P1.Y);
  Result.Second := frxPoint(P2.X, P2.Y);
end;

function Segment(P1, P2: TfrxPoint): TSegment;
begin
  Result.First := P1;
  Result.Second := P2;
end;

function DoublePoint(P: TfrxPoint): TDoublePoint;
begin
  Result := DoublePoint(P.X, P.Y);
end;

function DoublePoint(X, Y: Extended): TDoublePoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function DoubleRectExpand(DR: TDoubleRect; d: Double): TDoubleRect;
begin
  Result := DoubleRectExpand(DR, d, d);
end;

function DoubleRectExpand(DR: TDoubleRect; dX, dY: Double): TDoubleRect;
begin
  with DR do
    Result := DoubleRect(Left - dX, Top - dY, Right + dX, Bottom + dY);
end;

function DoubleRect(Left, Top, Right, Bottom: Double): TDoubleRect;
begin
  Result.Left := Left;
  Result.Right := Right;
  Result.Top := Top;
  Result.Bottom := Bottom;
end;

function DoubleRect(R: TRect): TDoubleRect;
begin
  Result := DoubleRect(R.Left, R.Top, R.Right, R.Bottom);
end;

function DoubleRect(TL, BR: TfrxPoint): TDoubleRect;
begin
  Result.TopLeft := DoublePoint(TL);
  Result.BottomRight := DoublePoint(BR);
end;

function ConstrainedDR(DR: TDoubleRect; ConstrainWidth, ConstrainHeight: Double): TDoubleRect;
var
  DRWidth, DRHeight, NewWidth, NewHeight: Double;
begin
  DRWidth := DR.Right - DR.Left;
  DRHeight := DR.Bottom - DR.Top;
  NewWidth := DRHeight * (ConstrainWidth / ConstrainHeight);
  NewHeight := DRWidth * (ConstrainHeight / ConstrainWidth);
  if (DRHeight <= NewHeight) or (DRWidth >= NewWidth) then
    DR.Right := DR.Left + NewWidth
  else
    DR.Bottom := DR.Top + NewHeight;
  Result := DR;
end;

function ToRect(DR: TDoubleRect): TRect;
begin
  with DR do
    Result := Rect(Round(Left), Round(Top), Round(Right), Round(Bottom));
end;

function ToPoint(X, Y: Extended): TPoint;
begin
  Result := Point(Round(X), Round(Y));
end;

function ToPoint(frxPoint: TfrxPoint): TPoint;
begin
  with frxPoint do
    Result := Point(Round(X), Round(Y));
end;

function ToFrxPoint(Point: TPoint): TfrxPoint;
begin
  with Point do
    Result := frxPoint(X, Y);
end;

function CenterRect(R: TfrxRect): TfrxPoint;
begin
  with R do
    Result := frxPoint((Left + Right) / 2, (Top + Bottom) / 2);
end;

procedure InitRect(var R: TfrxRect; DP: TDoublePoint);
begin
  with DP do
    R := frxRect(X, Y, X, Y);
end;

procedure ExpandRect(var R: TfrxRect; R1: TfrxRect);
begin
  R.Left :=   Min(R.Left,   R1.Left);
  R.Top :=    Min(R.Top,    R1.Top);
  R.Right :=  Max(R.Right,  R1.Right);
  R.Bottom := Max(R.Bottom, R1.Bottom);
end;

procedure ExpandRect(var R: TfrxRect; DP: TDoublePoint);
begin
  with DP do
    ExpandRect(R, X, Y);
end;

procedure ExpandRect(var R: TfrxRect; X, Y: Extended);
begin
  if      R.Left > X then  R.Left := X
  else if R.Right < X then R.Right := X;
  if      R.Top > Y then    R.Top := Y
  else if R.Bottom < Y then R.Bottom := Y;
end;

function RectWidth(R: TfrxRect): Extended;
begin
  Result := R.Right - R.Left;
end;

function RectHeight(R: TfrxRect): Extended;
begin
  Result := R.Bottom - R.Top;
end;

function DistanceMultiPolygon(Matrix: TDoublePointMatrix; P: TfrxPoint): Extended;
var
  iPart: Integer;
begin
  Result := MaxDistance;
  for iPart := 0 to High(Matrix) do
    Result := Min(Result, DistancePolygon(Matrix[iPart], P));
end;

function DistanceMultiPolyline(Matrix: TDoublePointMatrix; P: TfrxPoint): Extended;
var
  iPart: Integer;
begin
  Result := MaxDistance;
  for iPart := 0 to High(Matrix) do
    Result := Min(Result, DistancePolyline(Matrix[iPart], P));
end;

function DistanceMultiPoint(Matrix: TDoublePointMatrix; P: TfrxPoint): Extended;
var
  iPart, iPoint: Integer;
begin
  Result := MaxDistance;
  for iPart := 0 to High(Matrix) do
    for iPoint := 0 to High(Matrix[iPart]) do
      Result := Min(Result, Distance(Matrix[iPart, iPoint], P));
end;

function DistanceSegment(Segment: TSegment; P: TfrxPoint): Extended;
var
  a, b, c, sp: Extended; // sp - semiperimeter
begin
  a := Distance(Segment.First, Segment.Second);
  b := Distance(Segment.First, P);
  c := Distance(Segment.Second, P);
  sp := (a + b + c) / 2;
  if      b * b >= a * a + c * c then
    Result := c
  else if c * c >= a * a + b * b then
    Result := b
  else
    Result := Sqrt(sp * (sp - a) * (sp - b) * (sp - c)) * 2 / a;
end;

function DistancePolygon(Poly: TDoublePointArray; P: TfrxPoint): Extended;
begin
  Result := Min(DistanceSegment(Segment(Poly[0], Poly[High(Poly)]), P),
                DistancePolyline(Poly, P));
end;

function DistancePolyline(Poly: TDoublePointArray; P: TfrxPoint): Extended;
var
  i: Integer;
begin
  Result := DistanceSegment(Segment(Poly[0], Poly[1]), P);
  for i := 2 to High(Poly) do
    Result := Min(Result, DistanceSegment(Segment(Poly[i - 1], Poly[i]), P));
end;

function DistanceTemplate(Poly: TDoublePointArray; P: TfrxPoint): Extended;
var
  i: Integer;
begin
  Result := Distance(Poly[0], P);
  for i := 1 to High(Poly) do
    Result := Min(Result, Distance(Poly[i], P));
end;

function Distance(P1: TDoublePoint; P2: TfrxPoint): Extended;
begin
  Result := Sqrt(Sqr(P1.X - P2.X) + Sqr(P1.Y - P2.Y));
end;

function Distance(P1, P2: TfrxPoint): Extended;
begin
  Result := Sqrt(Sqr(P1.X - P2.X) + Sqr(P1.Y - P2.Y));
end;

function Distance(P: TfrxPoint; X, Y: Extended): Extended;
begin
  Result := Sqrt(Sqr(P.X - X) + Sqr(P.Y - Y));
end;

function Distance(P: TPoint; X, Y: Extended): Extended;
begin
  Result := Sqrt(Sqr(P.X - X) + Sqr(P.Y - Y));
end;

function DistanceRect(Rect: TDoubleRect; P: TfrxPoint): Extended;
var
  Poly: TDoublePointArray;
begin
  SetLength(Poly, 4);
  with Rect do
  begin
    Poly[0] := DoublePoint(Left, Top);
    Poly[1] := DoublePoint(Right, Top);
    Poly[2] := DoublePoint(Right, Bottom);
    Poly[3] := DoublePoint(Left, Bottom);
  end;
  Result := DistancePolygon(Poly, P);
end;

function IntersectionEllipse(Rect: TDoubleRect; P: TfrxPoint): TfrxPoint;

  function Intersection(semi_major, semi_minor: Extended; p: TfrxPoint): TfrxPoint;
    function hypot(x, y: Extended): Extended;
    begin
      Result := Sqrt(Sqr(x) + Sqr(y));
    end;
  var
    px, py, t, a, b, x, y, ex, ey, rx, ry, qx, qy, r, q, delta_c, delta_t: Extended;
    i: Integer;
  begin // http://wet-robots.ghost.io/simple-method-for-distance-to-ellipse/
    px := Abs(p.X);
    py := Abs(p.Y);

    t := Pi / 4;

    a := semi_major;
    b := semi_minor;

    for i := 0 to 3 do
    begin
      x := a * Cos(t);
      y := b * Sin(t);

      ex := (a * a - b * b) * Power(Cos(t), 3) / a;
      ey := (b * b - a * a) * Power(Sin(t), 3) / b;

      rx := x - ex;
      ry := y - ey;

      qx := px - ex;
      qy := py - ey;

      r := hypot(ry, rx);
      q := hypot(qy, qx);

      delta_c := r * ArcSin((rx * qy - ry * qx) / (r * q));
      delta_t := delta_c / Sqrt(a * a + b * b - x * x - y * y);

      t := t + delta_t;
      t := Min(Pi / 2, Max(0, t));
    end;

    Result := frxPoint(x * Sign(p.X), y * Sign(p.Y));
  end;

var
  a, b: Extended;
  Center: TfrxPoint;
begin
  with frxCanonicalRect(Rect) do
  begin
    Center := frxPoint((Left + Right) / 2, (Top + Bottom) / 2);
    a := (Right - Left) / 2;
    b := (Bottom - Top) / 2;
  end;
  with Intersection(a, b, frxPoint(P.X - Center.X, P.Y - Center.Y)) do
    Result := frxPoint(X + Center.X, Y + Center.Y);
end;

function DistanceEllipse(Rect: TDoubleRect; P: TfrxPoint): Extended;
begin
  Result := Distance(p, IntersectionEllipse(Rect, P));
end;

function DistancePicture(Rect: TDoubleRect; P: TfrxPoint): Extended;
begin
  if IsPointInRect(P, frxCanonicalRect(Rect)) then
    Result := 0
  else
    Result := DistanceRect(Rect, P);
end;

function DistanceDiamond(Rect: TDoubleRect; P: TfrxPoint): Extended;
var
  Poly: TDoublePointArray;
begin
  SetLength(Poly, 4);
  with Rect do
  begin
    Poly[0] := DoublePoint((Left + Right) / 2, Top);
    Poly[1] := DoublePoint(Right, (Top + Bottom) / 2);
    Poly[2] := DoublePoint((Left + Right) / 2, Bottom);
    Poly[3] := DoublePoint(Left, (Top + Bottom) / 2);
  end;
  Result := DistancePolygon(Poly, P);
end;

function IsPointInPolygon(x, y: Extended; PolyPoints: TPointArray): Boolean;
var
 i1, i2: Integer;
begin
  Result := False;
  i2 := 0;
  i1 := Length(PolyPoints) - 1;
  while i1 >= 0 do
  begin;
    if not ((PolyPoints[i1].x < x) xor (x <= PolyPoints[i2].x)) then
      if y - PolyPoints[i1].y < (x - PolyPoints[i1].x) *
                                (PolyPoints[i2].y - PolyPoints[i1].y) /
                                (PolyPoints[i2].x - PolyPoints[i1].x) then
        Result := not Result;
    i2 := i1;
    i1 := i1-1;
  end;
end;

function IsSegmentsIntersect(S1, S2: TSegment): Boolean;
const
  Eps = 1e-6;
var
  dxFirst, dyFirst, dxS1, dyS1, dxS2, dyS2, s_numer, t_numer, denom: Extended;
  denomPositive: Boolean;
begin
  Result := False;

  dxS1 := S1.Second.X - S1.First.X;
  dyS1 := S1.Second.Y - S1.First.Y;
  dxS2 := S2.Second.X - S2.First.X;
  dyS2 := S2.Second.Y - S2.First.Y;

  denom := dxS1 * dyS2 - dxS2 * dyS1;
  if Abs(denom) < Eps then // Collinear
    Exit;
  denomPositive := denom > 0;

  dxFirst := S1.First.X - S2.First.X;
  dyFirst := S1.First.Y - S2.First.Y;
  s_numer := dxS1 * dyFirst - dyS1 * dxFirst;
  if (s_numer < 0) = denomPositive then // No collision
    Exit;

  t_numer := dxS2 * dyFirst - dyS2 * dxFirst;
  if (t_numer < 0) = denomPositive then // No collision
    Exit;

  if ((s_numer > denom) = denomPositive) or ((t_numer > denom) = denomPositive) then // No collision
    Exit;

  // Collision detected
  Result := True;
end;

function frxCanonicalRect(ALeft, ATop, ARight, ABottom: Extended): TfrxRect;
begin
  with Result do
  begin
    Left := Min(ALeft, ARight);
    Top := Min(ATop, ABottom);
    Right := Max(ALeft, ARight);
    Bottom := Max(ATop, ABottom);
  end;
end;

function IsEqual(P1, P2: TDoublePoint): Boolean;
begin
  Result := (P1.X = P2.X) and (P1.Y = P2.Y);
end;

function IsInsideDiamond(R: TDoubleRect; P: TfrxPoint): Boolean;
var
  Center: TDoublePoint;
  Poly: TDoublePointArray;
begin
  Center := DoublePoint((R.Left + R.Right) / 2, (R.Top + R.Bottom) / 2);
  SetLength(Poly, 4);
  Poly[0] := DoublePoint(Center.X, R.Top);
  Poly[1] := DoublePoint(R.Right,  Center.Y);
  Poly[2] := DoublePoint(Center.X, R.Bottom);
  Poly[3] := DoublePoint(R.Left,   Center.Y);

  Result := IsInsidePolygon(Poly, P);
end;

function IsInsideMultiPolyline(Matrix: TDoublePointMatrix; P: TfrxPoint): Boolean;
var
  iPart: Integer;
begin
  Result := False;
  for iPart := 0 to High(Matrix) do
  begin
    Result := IsInsidePolyline(Matrix[iPart], P);
    if Result then
      Break;
  end;
end;

function IsInsideMultiPolygon(Matrix: TDoublePointMatrix; P: TfrxPoint): Boolean;
var
  iPart: Integer;
begin
  Result := False;
  for iPart := 0 to High(Matrix) do
  begin
    Result := IsInsidePolygon(Matrix[iPart], P);
    if Result then
      Break;
  end;
end;

function IsInsidePolyline(Poly: TDoublePointArray; P: TfrxPoint): Boolean;
begin
  Result := IsEqual(Poly[0], Poly[High(Poly)]) and IsInsidePolygon(Poly, P);
end;

function IsInsidePolygon(Poly: TDoublePointArray; P: TfrxPoint): Boolean;
var
 i1, i2: Integer;
begin
  Result := False;
  i2 := 0;
  i1 := Length(Poly) - 1;
  while i1 >= 0 do
  begin;
    if not ((Poly[i1].x < P.X) xor (P.X <= Poly[i2].x)) then
      if P.Y - Poly[i1].y < (P.X - Poly[i1].x) * (Poly[i2].y - Poly[i1].y) /
         (Poly[i2].x - Poly[i1].x) then
        Result := not Result;
    i2 := i1;
    i1 := i1 - 1;
  end;
end;

function IsInsideEllipse(R: TDoubleRect; P: TfrxPoint): Boolean;
var
  Center: TfrxPoint;
  a, b, x, y: Extended;
begin
  Center := frxPoint((R.Left + R.Right) / 2, (R.Top + R.Bottom) / 2);
  a := R.Right - Center.X;
  b := R.Bottom - Center.Y;
  x := P.X - Center.X;
  y := P.Y - Center.Y;
  Result := Sqr(x) / Sqr(a) + Sqr(y) / Sqr(b) <= 1.0;
end;

function IsInsideRect(R: TDoubleRect; P: TfrxPoint): Boolean;
begin
  Result := IsPointInRect(P, frxRect(R.Left, R.Top, R.Right, R.Bottom));
end;

function IsInside(Value, Start, Finish: Extended): Boolean;
begin
  Result := (Value >= Start) and (Value <= Finish);
end;

function IsPointInRect(P: TfrxPoint; R: TfrxRect): Boolean;
begin
  Result := IsInside(P.X, R.Left, R.Right) and
            IsInside(P.Y, R.Top, R.Bottom);
end;

function frxCanonicalRect(DR: TDoubleRect): TfrxRect;
begin
  with DR do
    Result := frxCanonicalRect(Left, Top, Right, Bottom);
end;

function Boundary(Value, MinValue, MaxValue: Extended): Extended;
begin
  if      Value < MinValue then Result := MinValue
  else if Value > MaxValue then Result := MaxValue
  else                          Result := Value;
end;

{ TMinDistance }

procedure TMinDistance.Add(AValue: Extended; AIndex: Integer);
begin
  if (FIndex = Unknown) or (FValue > AValue) then
  begin
    FValue := AValue;
    FIndex := AIndex;
  end;
end;

constructor TMinDistance.Create(ATreshold: Extended = 0.0);
begin
  Init(ATreshold);
end;

procedure TMinDistance.Init(ATreshold: Extended);
begin
  FIndex := Unknown;
  FTreshold := ATreshold;
end;

function TMinDistance.IsNear: Boolean;
begin
  Result := (FIndex <> Unknown) and (FValue <= FTreshold);
end;

function TMinDistance.IsZero: Boolean;
begin
  Result := (FIndex <> Unknown) and (FValue = 0.0);
end;

end.
