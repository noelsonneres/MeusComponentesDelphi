
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

unit frxGaugeDialogControl;

interface

{$I frx.inc}

uses
  Classes, ExtCtrls, Types, Controls, Messages,
  frxGaugePanel, frxGauge, frxClass;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxGaugeDialogControls = class(TComponent) // fake component
  end;

  TfrxBaseGaugeControl = class(TfrxDialogControl)
  private
  protected
    FBaseGauge: TfrxBaseGaugePanel;
    procedure CreateGauge; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TfrxGaugeControl = class(TfrxBaseGaugeControl)
  private
    function GetGauge: TfrxGauge;
  protected
    procedure CreateGauge; override;
  public
  published
    property Gauge: TfrxGauge read GetGauge;
  end;

  TfrxIntervalGaugeControl = class(TfrxBaseGaugeControl)
  private
    function GetGauge: TfrxIntervalGauge;
  protected
    procedure CreateGauge; override;
  public
  published
    property Gauge: TfrxIntervalGauge read GetGauge;
  end;


implementation

uses SysUtils, frxDsgnIntf, frxGaugeControlRTTI;

{ TfrxBaseGaugeControl }

constructor TfrxBaseGaugeControl.Create(AOwner: TComponent);
begin
  inherited;
  CreateGauge;
  InitControl(FBaseGauge);
end;

{ TfrxGaugeControl }

procedure TfrxGaugeControl.CreateGauge;
begin
  FBaseGauge := TfrxGaugePanel.Create(nil);
end;

function TfrxGaugeControl.GetGauge: TfrxGauge;
begin
  Result := TfrxGaugePanel(FBaseGauge).Gauge;
end;


{ TfrxIntervalGaugeControl }

procedure TfrxIntervalGaugeControl.CreateGauge;
begin
  FBaseGauge := TfrxIntervalGaugePanel.Create(nil);
end;

function TfrxIntervalGaugeControl.GetGauge: TfrxIntervalGauge;
begin
  Result := TfrxIntervalGaugePanel(FBaseGauge).Gauge;
end;

initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxGaugeDialogControls, TControl);
{$ENDIF}
  frxObjects.RegisterObject1(TfrxGaugeControl, nil, '', '', 0, 70);
  frxObjects.RegisterObject1(TfrxIntervalGaugeControl, nil, '', '', 0, 70);

end.
