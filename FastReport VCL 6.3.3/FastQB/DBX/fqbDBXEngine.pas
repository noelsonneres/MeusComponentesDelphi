{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbDBXEngine;

interface

uses
  Windows, Messages, Classes, Dialogs, DB,  DBXpress, SqlExpr
{$IFDEF Delphi7}
  ,SimpleDS
{$ELSE}
  ,DBClient, DBLocal, DBLocalS
{$ENDIF}
{$IFDEF Delphi6}
  ,Variants
{$ENDIF}
  ,fqbClass;

type
  TfqbDBXEngine = class(TfqbEngine)
  private
    {$IFNDEF Delphi7}
    FSQLQuery: TSQLClientDataSet;
    {$ELSE}
    FSQLQuery: TSimpleDataSet;
    {$ENDIF}
    FSQLConnection: TSQLConnection;
    procedure SetDatabase(const Value: TSQLConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList);
                   override;
    procedure ReadTableList(ATableList: TStrings); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  published
    property Database: TSQLConnection read FSQLConnection write SetDatabase;
  end;
  

implementation

{-----------------------  TDBXEngine -----------------------}
constructor TfqbDBXEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFNDEF Delphi7}
  FSQLQuery := TSQLClientDataSet.Create(Self);
  FSQLQuery.CommandType := ctQuery;
  {$ELSE}
  FSQLQuery := TSimpleDataSet.Create(Self);
  FSQLQuery.DataSet.CommandType := ctQuery;
  {$ENDIF}
end;

destructor TfqbDBXEngine.Destroy;
begin
  FSQLQuery.Free;
  inherited Destroy;
end;

procedure TfqbDBXEngine.ReadFieldList(const ATableName: string; var AFieldList:
               TfqbFieldList);
var
  i: Integer;
  tbl: TSQLTable;
  Fields: TFieldDefs;
  tmpField: TfqbField;
begin
  tbl := TSQLTable.Create(Self);
  tbl.SQLConnection := Database;
  tbl.TableName := ATableName;
  Fields := tbl.FieldDefs;
  try
    try
      tbl.Active := True;
      tmpField:= TfqbField(AFieldList.Add);
      tmpField.FieldName := '*';
      for i := 0 to Fields.Count - 1 do
      begin
        tmpField:= TfqbField(AFieldList.Add);
        tmpField.FieldName := Fields.Items[i].Name;
        tmpField.FieldType := Ord(Fields.Items[i].DataType)
      end
    except
      begin
        Exit
      end
    end
  finally
    tbl.Free
  end
end;

procedure TfqbDBXEngine.ReadTableList(ATableList: TStrings);
begin
  ATableList.Clear;
  Database.GetTableNames(ATableList, ShowSystemTables);
end;

function TfqbDBXEngine.ResultDataSet: TDataSet;
begin
  Result := FSQLQuery;
end;

procedure TfqbDBXEngine.SetDatabase(const Value: TSQLConnection);
begin
  FSQLQuery.Close;
  FSQLConnection := Value;
  {$IFNDEF Delphi7}
  FSQLQuery.DBConnection := FSQLConnection;
  {$ELSE}
  FSQLQuery.Connection := FSQLConnection;
  {$ENDIF}
end;

procedure TfqbDBXEngine.SetSQL(const Value: string);
begin
  FSQLQuery.Close;
  {$IFNDEF Delphi7}
  FSQLQuery.CommandText := Value;
  {$ELSE}
  FSQLQuery.DataSet.CommandText := Value;
  {$ENDIF}
end;


end.
