
{******************************************}
{                                          }
{             FastReport v5.0              }
{              Gradient RTTI               }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxGradientRTTI;

interface

{$I frx.inc}

implementation

uses
  {$IFNDEF FPC}
  Windows, Classes,
  {$ENDIF}
  Types, SysUtils, Forms, fs_iinterpreter, frxGradient, frxClassRTTI
{$IFDEF Delphi6}
, Variants
{$ENDIF};
  

type
  TFunctions = class(TfsRTTIModule)
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddEnum('TfrxGradientStyle', 'gsHorizontal, gsVertical, gsElliptic, ' +
      'gsRectangle, gsVertCenter, gsHorizCenter');
    AddClass(TfrxGradientView, 'TfrxView');
  end;
end;


initialization
  fsRTTIModules.Add(TFunctions);
  
finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
