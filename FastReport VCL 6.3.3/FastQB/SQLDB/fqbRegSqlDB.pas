{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbRegSqlDb;

interface

procedure Register;

implementation

uses
  Classes,
  LResources,
  LazarusPackageIntf,
  fqbClass,
  fqbSqlDbEngine;

procedure RegisterUnitfqbRegSqlDb;
begin
  RegisterComponents('FastQueryBuilder', [TfqbSQLDbEngine])
end;

procedure Register;
begin
  RegisterUnit('fqbRegSqlDb', @RegisterUnitfqbRegSqlDb);
end;

initialization
  {$INCLUDE fqb_sqldb.lrs}
end.
