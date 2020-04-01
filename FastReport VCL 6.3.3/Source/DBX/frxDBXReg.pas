
{******************************************}
{                                          }
{             FastReport v5.0              }
{       DBX components registration        }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxDBXReg;

interface

{$I frx.inc}

procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes, Controls
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
, DesignIntf, DesignEditors
{$ENDIF}
, frxDBXComponents;

procedure Register;
begin
  RegisterComponents('FastReport 6.0', [TfrxDBXComponents]);
{$IFDEF DELPHI16}
  //StartClassGroup(TControl);
  //ActivateClassGroup(TControl);
  //GroupDescendentsWith(TfrxDBXComponents, TControl);
{$ENDIF}
end;

end.
