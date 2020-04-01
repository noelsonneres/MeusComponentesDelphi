
{******************************************}
{                                          }
{             FastReport v5.0              }
{       BDE components registration        }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxBDEReg;

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
, frxBDEComponents;

procedure Register;
begin
  RegisterComponents('FastReport 6.0', [TfrxBDEComponents]);
{$IFDEF DELPHI16}
//  GroupDescendentsWith(TfrxBDEComponents, TControl);
{$ENDIF}
end;

end.
