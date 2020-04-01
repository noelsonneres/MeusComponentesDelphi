{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbRegIBX;

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
  fqbClass, fqbIBXEngine;

{$R fqb_ib.dcr}

procedure Register;
begin
  RegisterComponents('FastQueryBuilder', [TfqbIBXEngine])
end;

end.
