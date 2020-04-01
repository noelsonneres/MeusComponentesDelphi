{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbXXXEngine;

interface

uses
  Windows, Messages, Classes, Dialogs, DB
{$IFDEF Delphi6}
  ,Variants
{$ENDIF}
  ,fqbClass;

type
  TXXXEngine = class(TfqbEngine)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList);
                   override;
    procedure ReadTableList(ATableList: TStrings); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  end;
  

implementation

{-----------------------  TXXXEngine -----------------------}
constructor TXXXEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TXXXEngine.Destroy;
begin
  inherited Destroy;
end;

procedure TXXXEngine.ReadFieldList(const ATableName: string; var AFieldList:
               TfqbFieldList);
begin
end;

procedure TXXXEngine.ReadTableList(ATableList: TStrings);
begin
end;

function TXXXEngine.ResultDataSet: TDataSet;
begin
end;

procedure TXXXEngine.SetSQL(const Value: string);
begin
end;


end.
