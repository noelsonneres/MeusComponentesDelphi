{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbRegXXX;

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
  fqbClass, fqbXXXEngine;


procedure Register;
begin
  RegisterComponents('FastQueryBuilder', [TfqbXXXEngine])
end;

end.
