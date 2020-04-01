
{******************************************}
{                                          }
{             FastReport v5.0              }
{              CheckBox RTTI               }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxChBoxRTTI;

interface

{$I frx.inc}

implementation

uses
  {$IFNDEF FPC}Windows,{$ENDIF} Classes, Types, SysUtils, Forms, fs_iinterpreter, frxChBox, frxClassRTTI
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
    AddEnum('TfrxCheckStyle', 'csCross, csCheck, csLineCross, csPlus');
    AddEnum('TfrxUncheckStyle', 'usEmpty, usCross, usLineCross, usMinus');
    AddClass(TfrxCheckBoxView, 'TfrxView');
  end;
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.

