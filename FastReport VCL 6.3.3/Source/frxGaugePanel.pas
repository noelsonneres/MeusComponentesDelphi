
{******************************************}
{                                          }
{             FastReport v6.0              }
{        Gauge Panel VCL Component         }
{                                          }
{            Copyright (c) 2017            }
{            by Oleg Adibekov,             }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxGaugePanel;

interface

{$I frx.inc}

uses
  Classes, ExtCtrls, Types, Controls, Messages,
  frxGauge;

type
  TfrxBaseGaugePanel = class(TPanel)
  private
  protected
    FBaseGauge: TfrxBaseGauge;

    procedure CreateGauge; virtual; abstract;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  {$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  TfrxGaugePanel = class(TfrxBaseGaugePanel)
  private
    FGauge: TfrxGauge;
    procedure SetGauge(const Value: TfrxGauge);
  protected
    procedure CreateGauge; override;
  public
  published
    property Gauge: TfrxGauge read FGauge write SetGauge;
  end;

  {$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  TfrxIntervalGaugePanel = class(TfrxBaseGaugePanel)
  private
    FIntervalGauge: TfrxIntervalGauge;
    procedure SetGauge(const Value: TfrxIntervalGauge);
  protected
    procedure CreateGauge; override;
  public
  published
    property Gauge: TfrxIntervalGauge read FIntervalGauge write SetGauge;
  end;

implementation

{ TfrxGaugePanel }

procedure TfrxGaugePanel.CreateGauge;
begin
  FGauge := TfrxGauge.Create;
  FBaseGauge := FGauge;
end;

procedure TfrxGaugePanel.SetGauge(const Value: TfrxGauge);
begin
  FGauge.Assign(Value);
end;

{ TfrxBaseGaugePanel }

constructor TfrxBaseGaugePanel.Create(AOwner: TComponent);
begin
  inherited;

  Width := 225;
  Height := 225;
  DoubleBuffered := True;
  Caption := '';
  CreateGauge;
  FBaseGauge.OnRepaint := Repaint;
end;

destructor TfrxBaseGaugePanel.Destroy;
begin
  FBaseGauge.Free;

  inherited;
end;

function TfrxBaseGaugePanel.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  Result := FBaseGauge.DoMouseWheel(Shift, WheelDelta, MousePos);
end;

procedure TfrxBaseGaugePanel.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  FBaseGauge.DoMouseDown(X, Y, Button, Shift);
end;

procedure TfrxBaseGaugePanel.MouseMove(Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  FBaseGauge.DoMouseMove(X, Y, Shift)
end;

procedure TfrxBaseGaugePanel.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FBaseGauge.DoMouseUp(X, Y, Button, Shift);
end;

procedure TfrxBaseGaugePanel.Paint;
begin
//  inherited;
  FBaseGauge.Draw(Canvas, ClientRect);
end;

{ TfrxIntervalGaugePanel }

procedure TfrxIntervalGaugePanel.CreateGauge;
begin
  FIntervalGauge := TfrxIntervalGauge.Create;
  FBaseGauge := FIntervalGauge;
end;

procedure TfrxIntervalGaugePanel.SetGauge(const Value: TfrxIntervalGauge);
begin
  FIntervalGauge.Assign(Value);
end;

end.
