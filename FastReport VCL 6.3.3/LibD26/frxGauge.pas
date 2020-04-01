
{******************************************}
{                                          }
{             FastReport v6.0              }
{                  Gauge                   }
{                                          }
{            Copyright (c) 2017            }
{            by Oleg Adibekov,             }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxGauge;

{$I frx.inc}

interface

uses
  Classes, Graphics, Types, Controls;

type
  TFloatPoint = record
    X, Y: Extended;
  end;

  TRay = record
    FP: TFloatPoint;
    Angle, Tangent: Extended; // Radians
  end;

  TfrxBaseGauge = class;

  TGaugeCoordinateConverter = class(TPersistent)
  private
  protected
    FRect: TRect;
    FWidth: Integer;
    FHeight: Integer;
    FIndent: TFloatPoint;
    FBaseGauge: TfrxBaseGauge;
    FRange: Extended;

    FCenter: TFloatPoint;
    FRadius: Extended;
    FAngle: Extended; // Radians

    function Part(Minimum, Value, Maximum: Extended): Extended; // 0..1
  public
    constructor Create(ABaseGauge: TfrxBaseGauge);
    procedure AssignTo(Dest: TPersistent); override;
    procedure Init(Rect: TRect; Indent: TFloatPoint);
    function ScreenRay(Value: Extended): TRay;
    function Value(Point: TPoint): Extended;
    procedure OutsideInside(fp1, fp2: TFloatPoint;
      out Outside, Inside: TFloatPoint);
  end;

  TGaugeScaleTicks = class(TPersistent)
  private
    FLength: Integer;
    FWidth: Integer;
    FColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure SetLength(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
    FBaseGauge: TfrxBaseGauge;
  public
    constructor Create(ABaseGauge: TfrxBaseGauge);
    procedure AssignTo(Dest: TPersistent); override;
    procedure Draw(Canvas: TCanvas; Ray: TRay);
  published
    property Length: Integer read FLength write SetLength;
    property Width: Integer read FWidth write SetWidth;
    property Color: TColor read FColor write SetColor;
  end;

  TGaugeMargin = class(TPersistent)
  private
    FLeft: Integer;
    FTop: Integer;
    FRight: Integer;
    FBottom: Integer;
    procedure SetBottom(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetRight(const Value: Integer);
    procedure SetTop(const Value: Integer);
  protected
    FBaseGauge: TfrxBaseGauge;
  public
    constructor Create(ABaseGauge: TfrxBaseGauge);
    procedure AssignTo(Dest: TPersistent); override;
    procedure Init(ALeft, ATop, ARight, ABottom: Integer);
  published
    property Left: Integer read FLeft write SetLeft;
    property Top: Integer read FTop write SetTop;
    property Right: Integer read FRight write SetRight;
    property Bottom: Integer read FBottom write SetBottom;
  end;

  TGaugePointerKind = (pkSegment, pkTriangle, pkDiamond, pkPentagon, pkBand);

  TGaugePointer = class(TPersistent)
  private
    FColor: TColor;
    FBorderWidth: Integer;
    FBorderColor: TColor;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderWidth(const Value: Integer);
    procedure SetColor(const Value: TColor);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  protected
    FBaseGauge: TfrxBaseGauge;
    procedure Paint(Canvas: TCanvas; Value: Extended); virtual; abstract;
    procedure PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended);
      virtual; abstract;
    function fp(x, y: Extended): TFloatPoint;
    procedure PaintFloatPolygon(Canvas: TCanvas; Value: Extended;
      const FPs: array of TFloatPoint);
  public
    constructor Create(ABaseGauge: TfrxBaseGauge);
    procedure AssignTo(Dest: TPersistent); override;
    procedure SetupCanvas(Canvas: TCanvas);
    function IsPublishedWidth: boolean; virtual;
    function IsPublishedHeight: boolean; virtual;
    function IsPublishedColor: boolean; virtual;

    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property Color: TColor read FColor write SetColor;
  published
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
  end;

  TGaugeScale = class(TPersistent)
  private
    FFont: TFont;
    FTicks: TGaugeScaleTicks;
    FValueFormat: String;
    FVisible: Boolean;
    FVisibleDigits: Boolean;
    FBilateral: Boolean;
    procedure SetBilateral(const Value: Boolean);
    procedure SetValueFormat(const Value: String);
    procedure SetVisible(const Value: Boolean);
    procedure SetVisibleDigits(const Value: Boolean);
    procedure SetTicks(const Value: TGaugeScaleTicks);
    procedure SetFont(const Value: TFont);
  protected
    FTextSize: TSize;
    FOneDigit: Boolean;
    FOneValue: Extended;
    FBaseGauge: TfrxBaseGauge;

    procedure FontChanged(Sender: TObject);
    procedure DrawDigits(Canvas: TCanvas; Ray: TRay; Value: Extended);
    function Correction: Integer;
  public
    constructor Create(ABaseGauge: TfrxBaseGauge);
    destructor Destroy; override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure SetupCanvas(Canvas: TCanvas);
    procedure Draw(Canvas: TCanvas; ValueStep: Extended);
    function Indent: TFloatPoint;
    procedure OneDigitAt(Value: Extended);
    procedure MultiDigits;
  published
    property Font: TFont read FFont write SetFont;
    property Ticks: TGaugeScaleTicks read FTicks write SetTicks;
    property ValueFormat: String read FValueFormat write SetValueFormat;
    property Visible: Boolean read FVisible write SetVisible;
    property VisibleDigits: Boolean read FVisibleDigits write SetVisibleDigits;
    property Bilateral: Boolean read FBilateral write SetBilateral;
  end;

  TGaugeKind = (gkHorizontal, gkVertical, gkCircle);
  TUpdateEvent = procedure of object;

  TfrxBaseGauge = class(TPersistent)
  private
    FOnUpdateOI: TUpdateEvent;
    FOnRepaint: TUpdateEvent;
    FMinorScale: TGaugeScale;
    FMajorScale: TGaugeScale;
    FPointer: TGaugePointer;
    FMajorStep: Extended;
    FMinorStep: Extended;
    FMinimum: Extended;
    FMaximum: Extended;
    FMargin: TGaugeMargin;
    FPointerKind: TGaugePointerKind;
    FKind: TGaugeKind;
    FAngle: Integer;
    procedure SetMaximum(const Value: Extended);
    procedure SetMinimum(const Value: Extended);
    procedure SetMajorStep(const Value: Extended);
    procedure SetMinorStep(const Value: Extended);
    procedure SetPointerKind(const Value: TGaugePointerKind);
    procedure SetMajorScale(const Value: TGaugeScale);
    procedure SetMargin(const Value: TGaugeMargin);
    procedure SetMinorScale(const Value: TGaugeScale);
    procedure SetPointer(const Value: TGaugePointer);
    procedure SetKind(const Value: TGaugeKind);
    procedure SetAngle(const Value: Integer);
  protected
    FScaleX, FScaleY, FScale: Extended;
    FLeftPressed: Boolean;
    FCC: TGaugeCoordinateConverter;
    FIsPrinting: Boolean;

    function CreatePointer(Old: TGaugePointer = nil; DestroyOld: Boolean = False): TGaugePointer;
    procedure UpdateOI;
    procedure Repaint;
    procedure OneDigit(P: Tpoint); virtual; abstract;
    procedure MultiDigits; virtual;
    procedure CorrectByMaximum; virtual; abstract;
    procedure CorrectByMinimum; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure Draw(Canvas: TCanvas; ClientRect: TRect);
    procedure DrawPointer(Canvas: TCanvas); virtual; abstract;
    procedure SetXYScales(AScaleX, AScaleY: Extended; IsPrinting: Boolean = False);
    function Radians: Extended;

    // Return True if the owner has to be updated
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState): Boolean;
    function DoMouseMove(X, Y: Integer; Shift: TShiftState): Boolean;
    function DoMouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState): Boolean;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; virtual; abstract;

    property ScaleX: Extended read FScaleX;
    property ScaleY: Extended read FScaleY;
    property Scale: Extended read FScale;
    property Minimum: Extended read FMinimum write SetMinimum;
    property Maximum: Extended read FMaximum write SetMaximum;
  published
    property OnUpdateOI: TUpdateEvent read FOnUpdateOI write FOnUpdateOI;
    property OnRepaint: TUpdateEvent read FOnRepaint write FOnRepaint;
    property Kind: TGaugeKind read FKind write SetKind;
    property Angle: Integer read FAngle write SetAngle; // Degrees - for people
    property MinorScale: TGaugeScale read FMinorScale write SetMinorScale;
    property MajorScale: TGaugeScale read FMajorScale write SetMajorScale;
    property Pointer: TGaugePointer read FPointer write SetPointer;
    property PointerKind: TGaugePointerKind read FPointerKind write SetPointerKind;
    property MajorStep: Extended read FMajorStep write SetMajorStep;
    property MinorStep: Extended read FMinorStep write SetMinorStep;
    property Margin: TGaugeMargin read FMargin write SetMargin;
  end;

  TfrxGauge = class(TfrxBaseGauge)
  private
    FCurrentValue: Extended;
    procedure SetCurrentValue(const Value: Extended);
  protected
    procedure OneDigit(P: Tpoint); override;
    procedure CorrectByMaximum; override;
    procedure CorrectByMinimum; override;
  public
    constructor Create;
    procedure AssignTo(Dest: TPersistent); override;
    procedure DrawPointer(Canvas: TCanvas); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
  published
    property Minimum;
    property Maximum;
    property CurrentValue: Extended read FCurrentValue write SetCurrentValue;
  end;

  TSelectedPointer = (spNo, spStart, spEnd, spBoth);
  TfrxIntervalGauge = class(TfrxBaseGauge)
  private
    FStartValue: Extended;
    FEndValue: Extended;
    procedure SetEndValue(const Value: Extended);
    procedure SetStartValue(const Value: Extended);
  protected
    FSelectedPointer: TSelectedPointer;
    procedure OneDigit(P: Tpoint); override;
    procedure MultiDigits; override;
    procedure CorrectByMaximum; override;
    procedure CorrectByMinimum; override;
  public
    constructor Create;
    procedure AssignTo(Dest: TPersistent); override;
    procedure DrawPointer(Canvas: TCanvas); override;

    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
  published
    property Maximum;
    property Minimum;
    property EndValue: Extended read FEndValue write SetEndValue;
    property StartValue: Extended read FStartValue write SetStartValue;
  end;

    TSegmentPointer = class(TGaugePointer)
  protected
    procedure Paint(Canvas: TCanvas; Value: Extended); override;
    procedure PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended); override;
  public
    function IsPublishedHeight: boolean; override;
  published
    property Height;
  end;

  TBasePolygonPointer = class(TGaugePointer)
  public
    function IsPublishedWidth: boolean; override;
    function IsPublishedHeight: boolean; override;
    function IsPublishedColor: boolean; override;
  published
    property Height;
    property Width;
    property Color;
  end;

  TTrianglePointer = class(TBasePolygonPointer)
  protected
    procedure Paint(Canvas: TCanvas; Value: Extended); override;
    procedure PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended); override;
  end;

  TDiamondPointer = class(TBasePolygonPointer)
  protected
    procedure Paint(Canvas: TCanvas; Value: Extended); override;
    procedure PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended); override;
  end;

  TPentagonPointer = class(TBasePolygonPointer)
  protected
    procedure Paint(Canvas: TCanvas; Value: Extended); override;
    procedure PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended); override;
  end;

  TBandPointer = class(TGaugePointer)
  protected
    procedure Paint(Canvas: TCanvas; Value: Extended); override;
    procedure PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended); override;
    procedure PaintRectBand(Canvas: TCanvas; Start, Current: TRay);
    procedure PaintCircleBand(Canvas: TCanvas; Start, Current: TRay);
  public
    function IsPublishedWidth: boolean; override;
    function IsPublishedColor: boolean; override;
  published
    property Width;
    property Color;
  end;

implementation

uses
  Math, SysUtils, Dialogs, {$IFNDEF FPC}Windows{$ELSE}
  LCLIntf, LCLType, LCLProc{$ENDIF}
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

const
  NeedDestoy = True;

{ Utilities }

function iPoint(rX, rY: Extended): TPoint;
begin
  Result := Point(Round(rX), Round(rY));
end;

function FloatPoint(X, Y: Extended): TFloatPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function fpMax(fp1, fp2: TFloatPoint): TFloatPoint;
begin
  Result := FloatPoint(Max(fp1.X, fp2.X), Max(fp1.Y, fp2.Y));
end;

function Distance(fp1, fp2: TFloatPoint): Extended;
begin
  Result := Sqrt(Sqr(fp1.X - fp2.X) + Sqr(fp1.Y - fp2.Y));
end;

function ToDegrees(Rad: Extended): Extended;
begin
  Result := Rad * 180 / Pi;
end;

{ TfrxBaseGauge }

procedure TfrxBaseGauge.AssignTo(Dest: TPersistent);
begin
  if Dest is TfrxBaseGauge then
    with TfrxBaseGauge(Dest) do
    begin
      FOnUpdateOI := Self.OnUpdateOI;
      FOnRepaint := Self.OnRepaint;
      FKind := Self.Kind;
      FMinorScale.Assign(Self.MinorScale);
      FMajorScale.Assign(Self.MajorScale);

      FPointerKind := Self.PointerKind;
      FPointer := CreatePointer(Self.Pointer);

      FMajorStep := Self.MajorStep;
      FMinorStep := Self.MinorStep;
      FMinimum := Self.Minimum;
      FMaximum := Self.Maximum;
      FMargin.Assign(Self.Margin);

      FCC.Assign(Self.FCC);
      SetXYScales(Self.FScaleX, Self.FScaleY);
    end
  else
    inherited;
end;

constructor TfrxBaseGauge.Create;
begin
  FMinimum := 0.0;
  FMaximum := 100.0;
  FMajorStep := 25;
  FMinorStep := 5;
  FAngle := 180;

  SetXYScales(1.0, 1.0);

  FKind := gkHorizontal;
  FMargin := TGaugeMargin.Create(Self);
  FMargin.Init(20, 10, 20, 10);

  FPointerKind := pkTriangle;
  FPointer := CreatePointer;

  FMajorScale := TGaugeScale.Create(Self);
  FMinorScale := TGaugeScale.Create(Self);

  FCC := TGaugeCoordinateConverter.Create(Self);

  FMinorScale.VisibleDigits := False;
  FMajorScale.Ticks.Length := 25;
  FMajorScale.Ticks.Width := 2;

  FLeftPressed := False;
end;

function TfrxBaseGauge.CreatePointer(Old: TGaugePointer = nil; DestroyOld: Boolean = False): TGaugePointer;
begin
  case PointerKind of
    pkSegment:
      Result := TSegmentPointer.Create(Self);
    pkTriangle:
      Result := TTrianglePointer.Create(Self);
    pkDiamond:
      Result := TDiamondPointer.Create(Self);
    pkPentagon:
      Result := TPentagonPointer.Create(Self);
  else { pkBand: }
    Result := TBandPointer.Create(Self);
  end;
  if Old <> nil then
    Result.Assign(Old);
  if DestroyOld then
    Old.Free;
end;

destructor TfrxBaseGauge.Destroy;
begin
  FMinorScale.Free;
  FMajorScale.Free;
  FPointer.Free;
  FMargin.Free;
  FCC.Free;

  inherited;
end;

function TfrxBaseGauge.DoMouseDown(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState): Boolean;
begin
  Result := not FLeftPressed and (Button = mbLeft);

  if Result then
  begin
    FLeftPressed := True;

    OneDigit(Point(X, Y));
    Repaint;
  end;
end;

function TfrxBaseGauge.DoMouseMove(X, Y: Integer; Shift: TShiftState): Boolean;
begin
  Result := FLeftPressed and (ssLeft in Shift);
  if FLeftPressed then
  begin
    if ssLeft in Shift then
      OneDigit(Point(X, Y))
    else
    begin
      MultiDigits;
      FLeftPressed := False;
    end;
    Repaint;
  end;
end;

function TfrxBaseGauge.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState): Boolean;
begin
  Result := FLeftPressed and (Button = mbLeft);

  if Result then
  begin
    FLeftPressed := False;

    MultiDigits;
    RePaint;
  end;
end;

procedure TfrxBaseGauge.Draw(Canvas: TCanvas; ClientRect: TRect);
var
  Rect: TRect;
begin
  with ClientRect do
    Rect := Types.Rect(Left   + Round(Margin.Left * FScaleX),
                       Top    + Round(Margin.Top * FScaleY),
                       Right  - Round(Margin.Right * FScaleX),
                       Bottom - Round(Margin.Bottom * FScaleY));

  MinorScale.SetupCanvas(Canvas);
  MajorScale.SetupCanvas(Canvas);

  FCC.Init(Rect, fpMax(MinorScale.Indent, MajorScale.Indent));

  if MinorScale.Visible then
    MinorScale.Draw(Canvas, MinorStep);
  if MajorScale.Visible then
    MajorScale.Draw(Canvas, MajorStep);

  Pointer.SetupCanvas(Canvas);
  DrawPointer(Canvas);
end;

procedure TfrxBaseGauge.MultiDigits;
begin
  MajorScale.MultiDigits;
  MinorScale.MultiDigits;
end;

function TfrxBaseGauge.Radians: Extended;
begin
  Result := Angle * Pi / 180;
end;

procedure TfrxBaseGauge.Repaint;
begin
  if Assigned(OnRepaint) then
    OnRepaint;
end;

procedure TfrxBaseGauge.SetAngle(const Value: Integer);
begin
  if FAngle <> Value then
  begin
    FAngle := Value mod 360;
    if FAngle <= 0 then
      FAngle := FAngle + 360;
    RePaint;
  end;
end;

procedure TfrxBaseGauge.SetKind(const Value: TGaugeKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    RePaint;
  end;
end;

procedure TfrxBaseGauge.SetMajorScale(const Value: TGaugeScale);
begin
  FMajorScale.Assign(Value);
end;

procedure TfrxBaseGauge.SetMajorStep(const Value: Extended);
begin
  if FMajorStep <> Value then
  begin
    FMajorStep := Value;
    RePaint;
  end;
end;

procedure TfrxBaseGauge.SetMargin(const Value: TGaugeMargin);
begin
  FMargin.Assign(Value);
end;

procedure TfrxBaseGauge.SetMaximum(const Value: Extended);
begin
  if (FMaximum <> Value) and (Value >= FMinimum) then
  begin
    FMaximum := Value;
    CorrectByMaximum;
    RePaint;
  end;
end;

procedure TfrxBaseGauge.SetMinimum(const Value: Extended);
begin
  if (FMinimum <> Value) and (Value <= FMaximum) then
  begin
    FMinimum := Value;
    CorrectByMinimum;
    RePaint;
  end;
end;

procedure TfrxBaseGauge.SetMinorScale(const Value: TGaugeScale);
begin
  FMinorScale.Assign(Value);
end;

procedure TfrxBaseGauge.SetMinorStep(const Value: Extended);
begin
  if FMinorStep <> Value then
  begin
    FMinorStep := Value;
    RePaint;
  end;
end;

procedure TfrxBaseGauge.SetPointer(const Value: TGaugePointer);
begin
  FPointer.Assign(Value);
end;

procedure TfrxBaseGauge.SetPointerKind(const Value: TGaugePointerKind);
begin
  if FPointerKind <> Value then
  begin
    FPointerKind := Value;
    FPointer := CreatePointer(FPointer, NeedDestoy);
    UpdateOI;
    RePaint;
  end;
end;

procedure TfrxBaseGauge.SetXYScales(AScaleX, AScaleY: Extended; IsPrinting: Boolean = False);
begin
  FScaleX := AScaleX;
  FScaleY := AScaleY;
  FScale := (FScaleX + FScaleY) / 2;
  FIsPrinting := IsPrinting;
end;

procedure TfrxBaseGauge.UpdateOI;
begin
  if Assigned(OnUpdateOI) then
    OnUpdateOI;
end;

{ TGaugeScale }

procedure TGaugeScale.AssignTo(Dest: TPersistent);
begin
  if Dest is TGaugeScale then
    with TGaugeScale(Dest) do
    begin
      FFont.Assign(Self.Font);
      FTicks.Assign(Self.Ticks);
      FValueFormat := Self.ValueFormat;
      FVisible := Self.Visible;
      FVisibleDigits := Self.VisibleDigits;
      FBilateral := Self.Bilateral;

      FBaseGauge := Self.FBaseGauge;
    end
  else
    inherited;
end;

function TGaugeScale.Correction: Integer;
begin
  if (FBaseGauge <> nil) and (FBaseGauge.Kind = gkCircle) then
    Result := 4
  else
    Result := 0;
end;

constructor TGaugeScale.Create(ABaseGauge: TfrxBaseGauge);
begin
  FBaseGauge := ABaseGauge;

  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FTicks := TGaugeScaleTicks.Create(FBaseGauge);
  FValueFormat := '%1.0f';
  FVisible := True;
  FVisibleDigits := True;
  FBilateral := False;

  FOneDigit := False;
end;

destructor TGaugeScale.Destroy;
begin
  FFont.Free;
  FTicks.Free;

  inherited;
end;

procedure TGaugeScale.Draw(Canvas: TCanvas; ValueStep: Extended);
var
  Ray: TRay;
  Value: Extended;
  SkipLast: boolean;
begin
  inherited;
  Value := FBaseGauge.Minimum;
  if ValueStep <= 0 then
    ValueStep := FBaseGauge.Maximum - FBaseGauge.Minimum;
  repeat
    Ray := FBaseGauge.FCC.ScreenRay(Value);
    Ticks.Draw(Canvas, Ray);

    SkipLast := (FBaseGauge.Kind = gkCircle)
            and (Value + ValueStep > FBaseGauge.Maximum)
            and (FBaseGauge.Angle > 330);
    if VisibleDigits and not FOneDigit and not SkipLast then
      DrawDigits(Canvas, Ray, Value);
    Value := Value + ValueStep;
  until Value > FBaseGauge.Maximum;

  if VisibleDigits and FOneDigit then
    DrawDigits(Canvas, FBaseGauge.FCC.ScreenRay(FOneValue), FOneValue);
end;

procedure TGaugeScale.DrawDigits(Canvas: TCanvas; Ray: TRay; Value: Extended);
var
  Digits: String;
  dx, dy: Extended;
  Outside, Inside: TFloatPoint;
  DigitsHalfWidth: Extended;
begin
  Canvas.Lock;
  try
    Canvas.Brush.Style := bsClear;
    Digits := Format(FValueFormat, [Value]);
    DigitsHalfWidth := Canvas.TextWidth(Digits) / 2;
    case FBaseGauge.Kind of
      gkHorizontal:
        begin
          Canvas.TextOut(Round(Ray.FP.X - DigitsHalfWidth),
            Round(Ray.FP.Y - Ticks.Length / 2 * FBaseGauge.ScaleY - FTextSize.cy), Digits);
          if Bilateral then
            Canvas.TextOut(Round(Ray.FP.X - DigitsHalfWidth),
              Round(Ray.FP.Y + Ticks.Length / 2 * FBaseGauge.ScaleY), Digits);
        end;
      gkVertical:
        begin
          Canvas.TextOut(Round(Ray.FP.X - Ticks.Length / 2 * FBaseGauge.ScaleX -
            2 * DigitsHalfWidth), Round(Ray.FP.Y - FTextSize.cy / 2), Digits);
          if Bilateral then
            Canvas.TextOut(Round(Ray.FP.X + Ticks.Length / 2 * FBaseGauge.ScaleX),
              Round(Ray.FP.Y - FTextSize.cy / 2), Digits);
        end;
    else
      begin
        dX := Sin(Ray.Angle) * (Ticks.Length + Correction) / 2 * FBaseGauge.ScaleX;
        dY := Cos(Ray.Angle) * (Ticks.Length + Correction) / 2 * FBaseGauge.ScaleY;
        FBaseGauge.FCC.OutsideInside(FloatPoint(Ray.FP.X + dX, Ray.FP.Y + dY),
                                 FloatPoint(Ray.FP.X - dX, Ray.FP.Y - dY),
                                 Outside, Inside);
        Canvas.TextOut(
          Round(Outside.X - DigitsHalfWidth * (1 + Sin(Ray.Angle))),
          Round(Outside.Y - FTextSize.cy * (1 + Cos(Ray.Angle)) / 2),
            Digits);
        if Bilateral then
          Canvas.TextOut(
            Round(Inside.X - DigitsHalfWidth * (1 - Sin(Ray.Angle))),
            Round(Inside.Y - FTextSize.cy * (1 - Cos(Ray.Angle)) / 2),
            Digits);
      end;
    end;
  finally
    Canvas.Unlock;
  end;
end;

procedure TGaugeScale.FontChanged(Sender: TObject);
begin
  FBaseGauge.Repaint;
end;

function TGaugeScale.Indent: TFloatPoint;
begin
  Result.X := FTextSize.cx + (Ticks.Length + Correction) / 2 * FBaseGauge.ScaleX;
  Result.Y := FTextSize.cy + (Ticks.Length + Correction) / 2 * FBaseGauge.ScaleY;
end;

procedure TGaugeScale.MultiDigits;
begin
  FOneDigit := False;
end;

procedure TGaugeScale.OneDigitAt(Value: Extended);
begin
  FOneDigit := True;
  FOneValue := Value;
end;

procedure TGaugeScale.SetBilateral(const Value: Boolean);
begin
  if FBilateral <> Value then
  begin
    FBilateral := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugeScale.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TGaugeScale.SetTicks(const Value: TGaugeScaleTicks);
begin
  FTicks.Assign(Value);
end;

procedure TGaugeScale.SetupCanvas(Canvas: TCanvas);
var
  PPI: Integer;
begin
  FTextSize.cx := 0;
  FTextSize.cy := 0;
  if VisibleDigits then
    try
      Canvas.Lock;
      Canvas.Font := Font;
  {$IFDEF MSWINDOWS}
      PPI := GetDeviceCaps(Canvas.Handle, LOGPIXELSX);
      if PPI = 0 then
  {$ENDIF}
        PPI := 96;
      if FBaseGauge.FIsPrinting then
        Canvas.Font.Height := -Round(Canvas.Font.Size * PPI / 72)
      else
        Canvas.Font.Height := -Round(Canvas.Font.Size * FBaseGauge.FScaleY * 96 / 72);
      FTextSize.cx := Max(Canvas.TextWidth(Format(FValueFormat, [FBaseGauge.Minimum])),
        Canvas.TextWidth(Format(FValueFormat, [FBaseGauge.Maximum])));
      FTextSize.cy := Canvas.TextHeight('0');
    finally
      Canvas.Unlock;
    end;
end;

procedure TGaugeScale.SetValueFormat(const Value: String);
begin
  if FValueFormat <> Value then
  begin
    FValueFormat := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugeScale.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugeScale.SetVisibleDigits(const Value: Boolean);
begin
  if FVisibleDigits <> Value then
  begin
    FVisibleDigits := Value;
    FBaseGauge.Repaint;
  end;
end;

{ TGaugePointer }

procedure TGaugePointer.AssignTo(Dest: TPersistent);
begin
  if Dest is TGaugePointer then
    with TGaugePointer(Dest) do
    begin
      FColor := Self.Color;
      FBorderWidth := Self.BorderWidth;
      FBorderColor := Self.BorderColor;

      FWidth := Self.Width;
      FHeight := Self.Height;

      FBaseGauge := Self.FBaseGauge;
    end
  else
    inherited;
end;

constructor TGaugePointer.Create(ABaseGauge: TfrxBaseGauge);
begin
  FColor := clYellow;
  FBorderWidth := 1;
  FBorderColor := clBlack;

  FHeight := 20;
  FWidth := 8;

  FBaseGauge := ABaseGauge;
end;

function TGaugePointer.fp(x, y: Extended): TFloatPoint;
begin
  Result := FloatPoint(x, y);
end;

function TGaugePointer.IsPublishedColor: boolean;
begin
  Result := False;
end;

function TGaugePointer.IsPublishedHeight: boolean;
begin
  Result := False;
end;

function TGaugePointer.IsPublishedWidth: boolean;
begin
  Result := False;
end;

procedure TGaugePointer.PaintFloatPolygon(Canvas: TCanvas; Value: Extended;
  const FPs: array of TFloatPoint);
var
  Points: array of TPoint;
  Ray: TRay;
  i: Integer;
  XX, XY, YX, YY: Extended;
begin
  Ray := FBaseGauge.FCC.ScreenRay(Value);
  SetLength(Points, Length(FPs));
  XX := Width * FBaseGauge.ScaleX * Sin(Ray.Tangent);
  XY := Height * FBaseGauge.ScaleX * Sin(Ray.Angle);
  YX := Width * FBaseGauge.ScaleY * Cos(Ray.Tangent);
  YY := Height * FBaseGauge.ScaleY * Cos(Ray.Angle);
  for i := Low(FPs) to High(FPs) do
    Points[i] := iPoint(Ray.FP.X + FPs[i].X * XX + FPs[i].Y * XY,
                        Ray.FP.Y + FPs[i].X * YX + FPs[i].Y * YY);
  Canvas.Lock;
  try
    Canvas.Polygon(Points);
  finally
    Canvas.Unlock;
  end;
end;

procedure TGaugePointer.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugePointer.SetBorderWidth(const Value: Integer);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugePointer.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugePointer.SetHeight(const Value: Integer);
begin
  if FHeight <> Value then
  begin
    FHeight := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugePointer.SetupCanvas(Canvas: TCanvas);
begin
  Canvas.Lock;
  try
    Canvas.Pen.Color := BorderColor;
    Canvas.Pen.Width := Round(BorderWidth * FBaseGauge.Scale);
    Canvas.Brush.Color := Color;
  finally
    Canvas.UnLock;
  end;
end;

procedure TGaugePointer.SetWidth(const Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    FBaseGauge.Repaint;
  end;
end;

{ TSegmentPointer }

function TSegmentPointer.IsPublishedHeight: boolean;
begin
  Result := True;
end;

procedure TSegmentPointer.Paint(Canvas: TCanvas; Value: Extended);
begin
  PaintFloatPolygon(Canvas, Value,
    [fp(0, 0), fp(0, 1)]);
end;

procedure TSegmentPointer.PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended);
begin
  Paint(Canvas, StartValue);
  Paint(Canvas, EndValue);
end;

{ TTrianglePointer }

procedure TTrianglePointer.Paint(Canvas: TCanvas; Value: Extended);
begin
  PaintFloatPolygon(Canvas, Value,
    [fp(0, 0), fp(-0.5, 1), fp(0.5, 1)]);
end;

procedure TTrianglePointer.PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended);
begin
  PaintFloatPolygon(Canvas, StartValue,
    [fp(0, 0), fp(-1, 1), fp(0, 1)]);
  PaintFloatPolygon(Canvas, EndValue,
    [fp(0, 0), fp(0, 1), fp(1, 1)]);
end;

{ TDiamondPointer }

procedure TDiamondPointer.Paint(Canvas: TCanvas; Value: Extended);
begin
  PaintFloatPolygon(Canvas, Value,
    [fp(0, 0), fp(-0.5, 0.5), fp(0, 1), fp(0.5, 0.5)]);
end;

procedure TDiamondPointer.PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended);
begin
  PaintFloatPolygon(Canvas, StartValue,
    [fp(0, 0), fp(-1.0, 0.5), fp(0, 1), fp(0, 0.5)]);
  PaintFloatPolygon(Canvas, EndValue,
    [fp(0, 0), fp(0, 0.5), fp(0, 1), fp(1, 0.5)]);
end;

{ TPentagonPointer }

procedure TPentagonPointer.Paint(Canvas: TCanvas; Value: Extended);
begin
  PaintFloatPolygon(Canvas, Value,
    [fp(0, 0), fp(-0.5, 0.3), fp(-0.5, 1), fp(0.5, 1), fp(0.5, 0.3)]);
end;

procedure TPentagonPointer.PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended);
begin
  PaintFloatPolygon(Canvas, StartValue,
    [fp(0, 0), fp(-1, 0.3), fp(-1, 1), fp(0, 1), fp(0, 0.3)]);
  PaintFloatPolygon(Canvas, EndValue,
    [fp(0, 0), fp(0, 0.3), fp(0, 1), fp(1, 1), fp(1, 0.3)]);
end;

{ TBandPointer }

function TBandPointer.IsPublishedColor: boolean;
begin
  Result := True;
end;

function TBandPointer.IsPublishedWidth: boolean;
begin
  Result := True;
end;

procedure TBandPointer.Paint(Canvas: TCanvas; Value: Extended);
begin
  PaintPair(Canvas, FBaseGauge.Minimum, Value);
end;

procedure TBandPointer.PaintCircleBand(Canvas: TCanvas; Start, Current: TRay);

  function CalcPoint(Radius: Extended; Angle: Extended): TPoint;
  begin
    Result := iPoint(FBaseGauge.FCC.FCenter.X + Radius * Sin(Angle),
                     FBaseGauge.FCC.FCenter.Y - Radius * Cos(Angle));
  end;
var
  iStart, iCenter: TPoint;
  iRadius, iR, dR, dR2: Integer;
  StartDegrees, CurrentDegrees, SweepDegrees: Extended;
begin
  iStart := iPoint(Start.FP.X, Start.FP.Y);
  iCenter := iPoint(FBaseGauge.FCC.FCenter.X, FBaseGauge.FCC.FCenter.Y);
  iRadius := Round(Distance(Start.FP, FBaseGauge.FCC.FCenter));

  StartDegrees := ToDegrees(Start.Tangent);
  CurrentDegrees := ToDegrees(Current.Tangent);

  SweepDegrees := ToDegrees(Start.Angle - Current.Angle);
  while SweepDegrees <    0 do SweepDegrees := SweepDegrees + 360;
  while SweepDegrees >= 360 do SweepDegrees := SweepDegrees - 360;

  Canvas.Pen.Color := Color;

  dR := Round(Width * FBaseGauge.Scale);
  dR2 := Round(Width * FBaseGauge.Scale / 2);
  for iR := -dR2 to dR - dR2 - 1 do
  begin
    if (iR = -dR2) or (iR = dR - dR2 - 1) then
      Canvas.Pen.Width := 1
    else
      Canvas.Pen.Width := 2;

    Canvas.MoveTo(iStart.X, iStart.Y);
    {$IFNDEF FPC}
    AngleArc(Canvas.Handle, iCenter.X, iCenter.Y, iRadius + iR, StartDegrees, -SweepDegrees);
    {$ELSE}
    Canvas.AngleArc(iCenter.X, iCenter.Y, iRadius + iR, StartDegrees, -SweepDegrees);
    {$ENDIF}
  end;

// Border
  Canvas.Pen.Width := Round(BorderWidth * FBaseGauge.Scale);
  Canvas.Pen.Color := BorderColor;

  with CalcPoint(iRadius - dR2, -Start.Angle) do
    Canvas.MoveTo(X, Y);
  with CalcPoint(iRadius + dR2, -Start.Angle) do
    Canvas.LineTo(X, Y);
  {$IFNDEF FPC}
  AngleArc(Canvas.Handle, iCenter.X, iCenter.Y, iRadius + dR2, StartDegrees, -SweepDegrees);
  {$ELSE}
  Canvas.AngleArc(iCenter.X, iCenter.Y, iRadius + dR2, StartDegrees, -SweepDegrees);
  {$ENDIF}

  with CalcPoint(iRadius + dR - dR2, -Current.Angle) do
    Canvas.MoveTo(X, Y);
  with CalcPoint(iRadius - dR + dR2, -Current.Angle) do
    Canvas.LineTo(X, Y);
  {$IFNDEF FPC}
  AngleArc(Canvas.Handle, iCenter.X, iCenter.Y, iRadius - dR + dR2, CurrentDegrees, SweepDegrees);
  {$ELSE}
  Canvas.AngleArc(iCenter.X, iCenter.Y, iRadius - dR + dR2, CurrentDegrees, SweepDegrees);
  {$ENDIF}
end;

procedure TBandPointer.PaintPair(Canvas: TCanvas; StartValue, EndValue: Extended);
var
  StartRay, EndRay: TRay;
begin
  StartRay := FBaseGauge.FCC.ScreenRay(StartValue);
  EndRay := FBaseGauge.FCC.ScreenRay(EndValue);
  case FBaseGauge.Kind of
    gkHorizontal, gkVertical:
      PaintRectBand(Canvas, StartRay, EndRay);
    gkCircle:
      PaintCircleBand(Canvas, StartRay, EndRay);
  end;
end;

procedure TBandPointer.PaintRectBand(Canvas: TCanvas; Start, Current: TRay);
  procedure CalcTopBottom(Ray: TRay; out Top, Bottom: TFloatPoint);
  begin
    Top := FloatPoint(Ray.FP.X + Width / 2 * FBaseGauge.ScaleX * Sin(Ray.Angle),
      Ray.FP.Y + Width / 2 * FBaseGauge.ScaleY * Cos(Ray.Angle));
    Bottom := FloatPoint(Ray.FP.X - Width / 2 * FBaseGauge.ScaleX * Sin(Ray.Angle),
      Ray.FP.Y - Width / 2 * FBaseGauge.ScaleY * Cos(Ray.Angle));
  end;

var
  StartTop, StartBottom, CurrentTop, CurrentBottom: TFloatPoint;
  Left, Top, Right, Bottom: Integer;
begin
  CalcTopBottom(Start, StartTop, StartBottom);
  CalcTopBottom(Current, CurrentTop, CurrentBottom);

  Canvas.Pen.Width := Round(BorderWidth * FBaseGauge.Scale);
  Canvas.Pen.Color := BorderColor;
  Canvas.Brush.Color := Color;

  Left  := Round(Min(StartTop.X, CurrentBottom.X));
  Right := Round(Max(StartTop.X, CurrentBottom.X));
  Top    := Round(Min(StartTop.Y, CurrentBottom.Y));
  Bottom := Round(Max(StartTop.Y, CurrentBottom.Y));
  case FBaseGauge.Kind of
    gkHorizontal:
      begin
        Inc(Top);
        Inc(Bottom);
      end;
    gkVertical:
      begin
        Inc(Left);
        Inc(Right);
      end;
  end;
  Canvas.Rectangle(Left, Top, Right, Bottom);
end;

{ TGaugeScaleTicks }

procedure TGaugeScaleTicks.AssignTo(Dest: TPersistent);
begin
  if Dest is TGaugeScaleTicks then
    with TGaugeScaleTicks(Dest) do
    begin
      FLength := Self.Length;
      FWidth := Self.Width;
      FColor := Self.Color;
      FBaseGauge := Self.FBaseGauge;
    end
  else
    inherited;
end;

constructor TGaugeScaleTicks.Create(ABaseGauge: TfrxBaseGauge);
begin
  FLength := 18;
  FWidth := 1;
  FColor := clBlack;

  FBaseGauge := ABaseGauge;
end;

procedure TGaugeScaleTicks.Draw(Canvas: TCanvas; Ray: TRay);
var
  dX, dY: Extended;
begin
  Canvas.Pen.Width := Round(Width * FBaseGauge.Scale);
  Canvas.Pen.Color := Color;
  dX := Sin(Ray.Angle) * Length / 2 * FBaseGauge.ScaleX;
  dY := Cos(Ray.Angle) * Length / 2 * FBaseGauge.ScaleY;

  with Ray.FP do
  begin
    Canvas.MoveTo(Round(X + dX), Round(Y + dY));
    Canvas.LineTo(Round(X - dX), Round(Y - dY));
  end;
end;

procedure TGaugeScaleTicks.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugeScaleTicks.SetLength(const Value: Integer);
begin
  if FLength <> Value then
  begin
    FLength := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugeScaleTicks.SetWidth(const Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    FBaseGauge.Repaint;
  end;
end;

{ TGaugeMargin }

procedure TGaugeMargin.AssignTo(Dest: TPersistent);
begin
  if Dest is TGaugeMargin then
    with TGaugeMargin(Dest) do
    begin
      FLeft := Self.Left;
      FTop := Self.Top;
      FRight := Self.Right;
      FBottom := Self.Bottom;
      FBaseGauge := Self.FBaseGauge;
    end
  else
    inherited;
end;

constructor TGaugeMargin.Create(ABaseGauge: TfrxBaseGauge);
begin
  FBaseGauge := ABaseGauge;
end;

procedure TGaugeMargin.Init(ALeft, ATop, ARight, ABottom: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FRight := ARight;
  FBottom := ABottom;
  FBaseGauge.Repaint;
end;

procedure TGaugeMargin.SetBottom(const Value: Integer);
begin
  if FBottom <> Value then
  begin
    FBottom := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugeMargin.SetLeft(const Value: Integer);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugeMargin.SetRight(const Value: Integer);
begin
  if FRight <> Value then
  begin
    FRight := Value;
    FBaseGauge.Repaint;
  end;
end;

procedure TGaugeMargin.SetTop(const Value: Integer);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    FBaseGauge.Repaint;
  end;
end;

{ TGaugeCoordinateConverter }

procedure TGaugeCoordinateConverter.AssignTo(Dest: TPersistent);
begin
  if Dest is TGaugeCoordinateConverter then
    with TGaugeCoordinateConverter(Dest) do
    begin
      Init(Self.FRect, Self.FIndent);
    end
  else
    inherited;
end;

constructor TGaugeCoordinateConverter.Create(ABaseGauge: TfrxBaseGauge);
begin
  FBaseGauge := ABaseGauge;
end;

procedure TGaugeCoordinateConverter.Init(Rect: TRect; Indent: TFloatPoint);
var
  XR, YR: Extended;
begin
  FRect := Rect;
  FIndent := Indent;

  FWidth := FRect.Right - FRect.Left;
  FHeight := FRect.Bottom - FRect.Top;
  FRange := FBaseGauge.Maximum - FBaseGauge.Minimum;

  if FBaseGauge.Kind = gkCircle then
  begin
    FAngle := FBaseGauge.Radians;
    if FAngle >= Pi then XR := FWidth / 2 - FIndent.X
    else                 XR := FWidth / 2 / Sin(FAngle / 2) - FIndent.X;
    YR := (FHeight - FIndent.Y) / (1 - Cos(FAngle / 2));
    FRadius := Min(XR, YR);
    FCenter := FloatPoint(FRect.Left + FWidth / 2,
                          FRect.Top + FRadius + FIndent.Y);
  end;
end;

procedure TGaugeCoordinateConverter.OutsideInside(fp1, fp2: TFloatPoint;
  out Outside, Inside: TFloatPoint);
begin
  if Distance(FCenter, fp1) > Distance(FCenter, fp2) then
  begin
    Outside := fp1;
    Inside := fp2;
  end
  else
  begin
    Outside := fp2;
    Inside := fp1;
  end;
end;

function TGaugeCoordinateConverter.Part(Minimum, Value, Maximum: Extended)
  : Extended;
begin
  if Maximum - Minimum = 0 then
    Result := 1.0
  else
    Result := Max(0.0, Min(1.0, (Value - Minimum) / (Maximum - Minimum)));
end;

function TGaugeCoordinateConverter.ScreenRay(Value: Extended): TRay;
var
  P: Extended;
begin
  P := Part(FBaseGauge.Minimum, Value, FBaseGauge.Maximum);
  case FBaseGauge.Kind of
    gkHorizontal:
      begin
        Result.FP.X := FRect.Left + FWidth * P;
        Result.FP.Y := FRect.Top + FIndent.Y;
        Result.Angle := 0;
      end;
    gkVertical:
      begin
        Result.FP.X := FRect.Left + FIndent.X;
        Result.FP.Y := FRect.Bottom - FHeight * P;
        Result.Angle := Pi / 2;
      end;
  else // gkCircle:
    begin
      Result.Angle := FAngle * (0.5 - P);
      Result.FP.X := FCenter.X + FRadius * Sin(-Result.Angle);
      Result.FP.Y := FCenter.Y - FRadius * Cos(-Result.Angle);
    end;
  end;
  Result.Tangent := Result.Angle + Pi / 2;
end;

function TGaugeCoordinateConverter.Value(Point: TPoint): Extended;
var
  V1, V2: TFloatPoint;
  Angle: Extended;
begin
  case FBaseGauge.Kind of
    gkHorizontal:
      Result := FBaseGauge.Minimum + FRange * Part(FRect.Left, Point.X, FRect.Right);
    gkVertical:
      Result := FBaseGauge.Maximum - FRange * Part(FRect.Top, Point.Y, FRect.Bottom);
  else // gkCircle:
    begin // We reduce the origin to the point FCenter
      V1 := FloatPoint(0.0, -FRadius);
      V2 := FloatPoint(Point.X - FCenter.X, Point.Y - FCenter.Y);
      Angle := FAngle / 2 + Sign(V2.X) * ArcCos(
        (V1.X * V2.X + V1.Y * V2.Y) /
        (Sqrt(V1.X * V1.X + V1.Y * V1.Y) * Sqrt(V2.X * V2.X + V2.Y * V2.Y)));

      Result := FBaseGauge.Minimum + FRange * Part(0.0, Angle, FAngle);
    end;
  end;
end;

{ TBasePolygonPointer }

function TBasePolygonPointer.IsPublishedColor: boolean;
begin
  Result := True;
end;

function TBasePolygonPointer.IsPublishedHeight: boolean;
begin
  Result := True;
end;

function TBasePolygonPointer.IsPublishedWidth: boolean;
begin
  Result := True;
end;

{ TfrxGauge }

procedure TfrxGauge.AssignTo(Dest: TPersistent);
begin
  inherited;
  if Dest is TfrxGauge then
    with TfrxGauge(Dest) do
    begin
      FCurrentValue := Self.CurrentValue;
    end;
end;

procedure TfrxGauge.CorrectByMaximum;
begin
  FCurrentValue := Min(FCurrentValue, FMaximum);
end;

procedure TfrxGauge.CorrectByMinimum;
begin
  FCurrentValue := Max(FCurrentValue, FMinimum);
end;

constructor TfrxGauge.Create;
begin
  inherited;
  FCurrentValue := 33;
end;

function TfrxGauge.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  CurrentValue := CurrentValue + Sign(WheelDelta) * FCC.FRange / 100;
end;

procedure TfrxGauge.DrawPointer(Canvas: TCanvas);
begin
  Pointer.Paint(Canvas, CurrentValue);
end;

procedure TfrxGauge.OneDigit(P: Tpoint);
begin
  FCurrentValue := FCC.Value(P);
  MajorScale.OneDigitAt(CurrentValue);
  MinorScale.OneDigitAt(CurrentValue);
end;

procedure TfrxGauge.SetCurrentValue(const Value: Extended);
begin
  if (FCurrentValue <> Value) and (Value >= FMinimum) and (Value <= FMaximum) then
  begin
    FCurrentValue := Value;
    RePaint;
  end;
end;

{ TfrxIntervalGauge }

procedure TfrxIntervalGauge.AssignTo(Dest: TPersistent);
begin
  inherited;
  if Dest is TfrxGauge then
    with TfrxGauge(Dest) do
    begin
      FStartValue := Self.StartValue;
      FEndValue := Self.EndValue;
    end;
end;

procedure TfrxIntervalGauge.CorrectByMaximum;
begin
  FStartValue := Min(FStartValue, FMaximum);
  FEndValue := Min(FEndValue, FMaximum);
end;

procedure TfrxIntervalGauge.CorrectByMinimum;
begin
  FStartValue := Max(FStartValue, FMinimum);
  FEndValue := Max(FEndValue, FMinimum);
end;

constructor TfrxIntervalGauge.Create;
begin
  inherited;
  FStartValue := 33;
  FEndValue := 67;
  FSelectedPointer := spNo;
end;

function TfrxIntervalGauge.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
var
  dValue: Extended;
begin
  dValue := Sign(WheelDelta) * FCC.FRange / 100;
  Result := (dValue + StartValue >= Minimum) and (dValue + EndValue <= Maximum);
  if Result then
  begin
    StartValue := dValue + StartValue;
    EndValue := dValue + EndValue;
  end;
end;

procedure TfrxIntervalGauge.DrawPointer(Canvas: TCanvas);
begin
  Pointer.PaintPair(Canvas, StartValue, EndValue);
end;

procedure TfrxIntervalGauge.MultiDigits;
begin
  inherited;

  FSelectedPointer := spNo;
end;

procedure TfrxIntervalGauge.OneDigit(P: Tpoint);
var
  Value: Extended;
begin
  if FSelectedPointer = spNo then
  begin
    Value := FCC.Value(P);
    if Value <= (StartValue + EndValue) / 2 then
      FSelectedPointer := spStart
    else
      FSelectedPointer := spEnd;
  end;
  case FSelectedPointer of
    spStart:
      begin
        FStartValue := Min(FCC.Value(P), FEndValue);
        MajorScale.OneDigitAt(StartValue);
        MinorScale.OneDigitAt(StartValue);
      end;
    spEnd:
      begin
        FEndValue := Max(FCC.Value(P), FStartValue);
        MajorScale.OneDigitAt(EndValue);
        MinorScale.OneDigitAt(EndValue);
      end;
  end;
end;

procedure TfrxIntervalGauge.SetEndValue(const Value: Extended);
begin
  if (FEndValue <> Value) and (Value >= FStartValue) and (Value <= FMaximum) then
  begin
    FEndValue := Value;
    RePaint;
  end;
end;

procedure TfrxIntervalGauge.SetStartValue(const Value: Extended);
begin
  if (FStartValue <> Value) and (Value >= FMinimum) and (Value <= FEndValue) then
  begin
    FStartValue := Value;
    RePaint;
  end;
end;

end.
