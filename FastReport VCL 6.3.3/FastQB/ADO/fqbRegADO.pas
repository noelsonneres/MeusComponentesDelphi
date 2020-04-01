{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbRegADO;

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
  fqbClass, fqbADOEngine;

{$R 'fqb_ado.DCR'}

procedure Register;
begin
  RegisterComponents('FastQueryBuilder', [TfqbADOEngine])
end;

end.
