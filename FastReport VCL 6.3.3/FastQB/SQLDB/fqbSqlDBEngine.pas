{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbSqlDBEngine;

interface

uses
  SysUtils, Classes, Dialogs, DB, Variants, fqbClass, sqldb, ibconnection, odbcconn;

type

  TfqbSqlDBEngine = class(TfqbEngine)
  private
    FSQLConnection: TSQLConnection;
    FQuery: TSQLQuery;
    procedure SetDatabase(Value: TSQLConnection);
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

{-----------------------  TfqbSqlDBEngine -----------------------}
constructor TfqbSqlDBEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuery := TSQLQuery.Create(Self);
end;

destructor TfqbSqlDBEngine.Destroy;
begin
  FQuery.Free;
  inherited Destroy;
end;

procedure TfqbSqlDBEngine.ReadFieldList(const ATableName: string; var AFieldList:
               TfqbFieldList);
var
  i: Integer;
  Fields: TFieldDefs;
  Q: TSQLQuery;
  tmpField: TfqbField;
begin
  Q := TSQLQuery.Create(Self);
  Q.DataBase := Database;
  Q.SQL.Text := 'SELECT * FROM ' + ATableName;
  Fields := Q.FieldDefs;
  try
    try
      Q.Active := True;
      tmpField:= TfqbField(AFieldList.Add);
      tmpField.FieldName := '*';
      for i := 0 to Fields.Count - 1 do
      begin
        tmpField := TfqbField(AFieldList.Add);
        tmpField.FieldName := Fields.Items[i].Name;
        tmpField.FieldType := Ord(Fields.Items[i].DataType)
      end
    except
      on E: Exception do
        begin
          ShowMessage(E.Message);
          Exit;
        end
    end
  finally
    Q.Free
  end
end;

procedure TfqbSqlDBEngine.ReadTableList(ATableList: TStrings);
begin
  ATableList.Clear;
  Database.GetTableNames(ATableList, ShowSystemTables);
end;

function TfqbSqlDBEngine.ResultDataSet: TDataSet;
begin
  Result := FQuery
end;

procedure TfqbSqlDBEngine.SetDatabase(Value: TSQLConnection);
begin
  FQuery.Close;
  FSQLConnection := Value;
  FQuery.Database := FSQLConnection;
end;

procedure TfqbSqlDBEngine.SetSQL(const Value: string);
begin
  FQuery.Close;
  FQuery.SQL.Text := Value;
end;


end.
