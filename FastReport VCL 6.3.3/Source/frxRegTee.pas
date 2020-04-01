
{******************************************}
{                                          }
{             FastReport v5.0              }
{            Registration unit             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxRegTee;

{$I frx.inc}

interface


procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
{$IFNDEF Delphi6}
  DsgnIntf,
{$ELSE}
  DesignIntf, DesignEditors,
{$ENDIF}
  frxChart;


procedure Register;
begin
  RegisterComponents('FastReport 6.0',
    [TfrxChartObject]);
{$IFDEF DELPHI16}
  //GroupDescendentsWith(TfrxChartObject, TControl);
{$ENDIF}
end;

end.
