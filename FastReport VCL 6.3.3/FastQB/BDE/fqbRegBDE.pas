{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbRegBDE;

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
  fqbBDEEngine;

{$R fqb_bde.dcr}

procedure Register;
begin
  RegisterComponents('FastQueryBuilder', [TfqbBDEEngine]);
end;

end.
