{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbRegFIB;

interface

procedure Register;

implementation

uses
  Classes,
{$IFNDEF Delphi6}
  DsgnIntf,
{$ELSE}
  DesignIntf,
{$ENDIF}
  fqbClass, fqbFIBEngine;

{$R 'fqb_fib.DCR'}

procedure Register;
begin
  RegisterComponents('FastQueryBuilder', [TfqbFIBEngine])
end;

end.
