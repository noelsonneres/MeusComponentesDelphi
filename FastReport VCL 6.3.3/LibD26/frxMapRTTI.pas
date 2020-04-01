
{******************************************}
{                                          }
{             FastReport v5.0              }
{           ERSI Shape Map RTTI            }
{                                          }
{            Copyright (c) 2016            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapRTTI;

interface

{$I frx.inc}

implementation

uses
  fs_iinterpreter, frxMap, frxMapLayer, frxClassRTTI;

type

  TFunctions = class(TfsRTTIModule)
  private
    function GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);

  with AScript do
  begin
    AddClass(TfrxCustomLayer, 'TfrxComponent');
    AddClass(TfrxMapFileLayer, 'TfrxCustomLayer');
    with AddClass(TfrxMapView, 'TfrxView') do
    begin
      AddProperty('SelectedShapeName', 'String', GetProp, nil);
    end;
  end;
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TfrxMapView then
  begin
    if PropName = 'SELECTEDSHAPENAME' then
      Result := TfrxMapView(Instance).SelectedShapeName;
  end
end;

initialization

  fsRTTIModules.Add(TFunctions);

end.


