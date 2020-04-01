{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbBDEEngine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, CheckLst, Buttons, Menus, Grids, Dbtables, Db,
  Dbgrids
{$IFDEF Delphi6}
  ,Variants
{$ENDIF}
  ,fqbClass;

type

  TfqbBDEEngine = class(TfqbEngine)
  private
    FDatabaseName: string;
    FQuery: TQuery;
    procedure SetDatabaseName(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList);
                   override;
    procedure ReadTableList(ATableList: TStrings); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  published
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
  end;
  

implementation

{-----------------------  TfqbBDEEngine -----------------------}
constructor TfqbBDEEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuery := TQuery.Create(Self);
end;

destructor TfqbBDEEngine.Destroy;
begin
  FQuery.Free;
  inherited Destroy;
end;

procedure TfqbBDEEngine.ReadFieldList(const ATableName: string; var AFieldList:
               TfqbFieldList);
var
  TempTable: TTable;
  Fields: TFieldDefs;
  i: Integer;
  tmpField: TfqbField;
begin
  AFieldList.Clear;
  TempTable := TTable.Create(Self);
  TempTable.DatabaseName := DatabaseName;
  TempTable.TableName := ATableName;
  Fields := TempTable.FieldDefs;
  try
    try
      TempTable.Active := True;
      tmpField:= TfqbField(AFieldList.Add);
      tmpField.FieldName := '*';
      for i := 0 to Fields.Count - 1 do
      begin
        tmpField:= TfqbField(AFieldList.Add);
        tmpField.FieldName := Fields.Items[i].Name;
        tmpField.FieldType := Ord(Fields.Items[i].DataType)
      end
    except
      on E: EDBEngineError do
      begin
        ShowMessage(E.Message);
        Exit
      end
    end
  finally
    TempTable.Free
  end
end;

procedure TfqbBDEEngine.ReadTableList(ATableList: TStrings);
begin
  ATableList.BeginUpdate;
  ATableList.Clear;
  try
    Session.GetTableNames(DatabaseName, '', True, ShowSystemTables, ATableList);
  finally
    ATableList.EndUpdate
  end
end;

function TfqbBDEEngine.ResultDataSet: TDataSet;
begin
  Result := FQuery
end;

procedure TfqbBDEEngine.SetDatabaseName(const Value: string);
begin
  FDatabaseName := Value;
  FQuery.Close;
  FQuery.DatabaseName := Value
end;

procedure TfqbBDEEngine.SetSQL(const Value: string);
begin
  FQuery.Close;
  FQuery.SQL.Text := Value;
end;


end.
