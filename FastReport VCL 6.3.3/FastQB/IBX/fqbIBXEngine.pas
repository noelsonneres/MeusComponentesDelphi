{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbIBXEngine;

interface

uses
  Windows, Messages, Classes, Dialogs, DB, DBTables
{$IFDEF Delphi6}
  ,Variants
{$ENDIF}
  ,fqbClass, IBQuery, IBDataBase, IBTable;

type

  TfqbIBXEngine = class(TfqbEngine)
  private
    FIBXConnection: TIBDatabase;
    FResultQuery: TIBQuery;
    FTransaction: TIBTransaction;
    procedure SetDatabase(Value: TIBDatabase);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList);
                   override;
    procedure ReadTableList(ATableList: TStrings); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  published
    property Database: TIBDatabase read FIBXConnection write SetDatabase;
  end;
  

implementation

{-----------------------  TfqbIBXEngine -----------------------}
constructor TfqbIBXEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FResultQuery := TIBQuery.Create(Self);
  FTransaction := TIBTransaction.Create(Self);
  FResultQuery.Transaction := FTransaction;
end;

destructor TfqbIBXEngine.Destroy;
begin
  FResultQuery.Free;
  FTransaction.Free;
  inherited Destroy;
end;

procedure TfqbIBXEngine.ReadFieldList(const ATableName: string; var AFieldList:
               TfqbFieldList);
var
  i: Integer;
  tbl: TIBTable;
  Fields: TFieldDefs;
  tmpField: TfqbField;
begin
  tbl := TIBTable.Create(Self);
  FTransaction.DefaultDatabase := FIBXConnection;
  FTransaction.Active := True;
  tbl.Database := FIBXConnection;
  tbl.Transaction := FTransaction;
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
      on E: EDBEngineError do
        begin
          ShowMessage(E.Message);
          Exit
        end
    end
  finally
    tbl.Free
  end
end;

procedure TfqbIBXEngine.ReadTableList(ATableList: TStrings);
begin
  ATableList.BeginUpdate;
  ATableList.Clear;
  FResultQuery.Database.GetTableNames(ATableList, ShowSystemTables);
  ATableList.EndUpdate;
end;

function TfqbIBXEngine.ResultDataSet: TDataSet;
begin
  Result := FResultQuery;
end;

procedure TfqbIBXEngine.SetDatabase(Value: TIBDatabase);
begin
  FIBXConnection := Value;
  FResultQuery.Database := Value
end;

procedure TfqbIBXEngine.SetSQL(const Value: string);
begin
  FResultQuery.Close;
  FResultQuery.SQL.Text := Value;
end;


end.
