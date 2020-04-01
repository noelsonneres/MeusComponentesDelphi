{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{ JJA01, 22-7-2008: listing fields was very slow for large query     }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbADOEngine;

interface

uses
  Windows, Messages, Classes, Dialogs, DB
{$IFDEF Delphi6}
  ,Variants
{$ENDIF}
  ,fqbClass, ADODB, ADOInt;

type

  TfqbADOEngine = class(TfqbEngine)
  private
    FADOConnection: TADOConnection;
    FQuery: TADOQuery;
    procedure SetDatabase(Value: TADOConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList);
                   override;
    procedure ReadTableList(ATableList: TStrings); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  published
    property Database: TADOConnection read FADOConnection write SetDatabase;
  end;
  

implementation

{-----------------------  TfqbADOEngine -----------------------}
constructor TfqbADOEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuery := TADOQuery.Create(Self);
end;

destructor TfqbADOEngine.Destroy;
begin
  FQuery.Free;
  inherited Destroy;
end;

procedure TfqbADOEngine.ReadFieldList(const ATableName: string; var AFieldList:
               TfqbFieldList);
var
  i: Integer;
  tbl: TADOTable;
  Fields: TFieldDefs;
  tmpField: TfqbField;
begin
  tbl := TADOTable.Create(Self);
  tbl.Connection := FADOConnection;
  tbl.TableName := ATableName;
  //  JJA01, 22-7-2008: proc was slooooow for large queries !!!
  tbl.MaxRecords := 1;
  // JJA01 - end
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
      on E: EADOError do
        begin
          ShowMessage(E.Message);
          Exit
        end
    end
  finally
    tbl.Free
  end
end;

procedure TfqbADOEngine.ReadTableList(ATableList: TStrings);
begin
  ATableList.Clear;
  FQuery.Connection.GetTableNames(ATableList, ShowSystemTables);
end;

function TfqbADOEngine.ResultDataSet: TDataSet;
begin
  Result := FQuery
end;

procedure TfqbADOEngine.SetDatabase(Value: TADOConnection);
begin
  FQuery.Close;
  FADOConnection := Value;
  FQuery.Connection := FADOConnection;
end;

procedure TfqbADOEngine.SetSQL(const Value: string);
begin
  FQuery.Close;
  FQuery.SQL.Text := Value;
end;


end.
