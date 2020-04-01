
{******************************************}
{                                          }
{             FastReport v6.0              }
{                Gauge RTTI                }
{                                          }
{            Copyright (c) 2017            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxGaugeViewRTTI;

interface

{$I frx.inc}

implementation

uses
  fs_iinterpreter, frxGaugeView, frxClassRTTI, frxGauge;

type

  TFunctions = class(TfsRTTIModule)
  private
//    function GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);

  with AScript do
  begin
    AddClass(TGaugeCoordinateConverter, 'TPersistent');
    AddClass(TGaugeScaleTicks, 'TPersistent');
    AddClass(TGaugeMargin, 'TPersistent');
    AddClass(TGaugePointer, 'TPersistent');

    AddClass(TSegmentPointer, 'TGaugePointer');
    AddClass(TBasePolygonPointer, 'TGaugePointer');
    AddClass(TTrianglePointer, 'TBasePolygonPointer');
    AddClass(TDiamondPointer, 'TBasePolygonPointer');
    AddClass(TPentagonPointer, 'TBasePolygonPointer');
    AddClass(TBandPointer, 'TGaugePointer');
    AddClass(TGaugeScale, 'TPersistent');
    AddClass(TfrxBaseGauge, 'TPersistent');
    AddClass(TfrxGauge, 'TfrxBaseGauge');
    AddClass(TfrxIntervalGauge, 'TfrxBaseGauge');
    AddClass(TfrxBaseGaugeView, 'TfrxView');

    with AddClass(TfrxGaugeView, 'TfrxBaseGaugeView') do
    begin
      //todo
    end;

    with AddClass(TfrxIntervalGaugeView, 'TfrxBaseGaugeView') do
    begin
      //todo
    end;
  end;
end;

//function TFunctions.GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
//begin
//  Result := 0;
//end;

initialization

  fsRTTIModules.Add(TFunctions);

end.


