
{******************************************}
{                                          }
{             FastReport v5.0              }
{       ADO components registration        }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxADOReg;

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
, frxADOComponents;

procedure Register;
begin
  RegisterComponents('FastReport 6.0', [TfrxADOComponents]);
{$IFDEF DELPHI16}
//  GroupDescendentsWith(TfrxADOComponents, TControl);
{$ENDIF}
end;

end.
