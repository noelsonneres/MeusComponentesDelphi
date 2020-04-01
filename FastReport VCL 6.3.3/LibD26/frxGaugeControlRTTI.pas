
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

unit frxGaugeControlRTTI;

interface

{$I frx.inc}

implementation

uses
  fs_iinterpreter, frxGaugeDialogControl, frxClassRTTI, frxGauge;

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
    AddClass(TfrxBaseGaugeControl, 'TfrxDialogControl');
    AddClass(TfrxGaugeControl, 'TfrxBaseGaugeControl');
    AddClass(TfrxIntervalGaugeControl, 'TfrxBaseGaugeControl');
  end;
end;

//function TFunctions.GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
//begin
//  Result := 0;
//end;

initialization

  fsRTTIModules.Add(TFunctions);

end.


