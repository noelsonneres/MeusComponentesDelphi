{*******************************************}
{                                           }
{          FastQueryBuilder 1.01            }
{                                           }
{            Copyright (c) 2005             }
{             Fast Reports Inc.             }
{                                           }
{*******************************************}

{$I fqb.inc}

unit fqbFIBEngine;

interface

uses
  Windows, Messages, Classes, Dialogs, DB
{$IFDEF Delphi6}
  ,Variants
{$ENDIF}
  ,fqbClass, FIBDatabase, pFIBDatabase, FIBDataSet, pFIBDataSet;

type
  TfqbFIBEngine = class(TfqbEngine)
  private
    FDatabase: TpFIBDatabase;
    FQuery: TFIBDataSet;
    procedure SetDatabase(Value: TpFIBDatabase);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList);
                   override;
    procedure ReadTableList(ATableList: TStrings); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  published
    property Database: TpFIBDatabase read FDatabase write SetDatabase;
  end;
  

implementation

uses SysUtils, FIBQuery;

{-----------------------  TfqbFIBEngine -----------------------}
constructor TfqbFIBEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuery := TFIBDataSet.Create(Self);
end;

destructor TfqbFIBEngine.Destroy;
begin
  FQuery.Free;
  inherited Destroy;
end;

procedure TfqbFIBEngine.ReadFieldList(const ATableName: string; var AFieldList:
               TfqbFieldList);
var
  tmpTransaction: TFIBTransaction;
  tbl: TFIBDataSet;
  tmpField: TfqbField;
  i: Integer;
begin
  tbl := TFIBDataSet.Create(Self);
  tmpTransaction := TFIBTransaction.Create(Self);
  tmpTransaction.DefaultDatabase := FDatabase;
  try
    tbl.Database := FDatabase;
    tbl.Transaction := tmpTransaction;
    tbl.SelectSQL.Add('SELECT *');
    tbl.SelectSQL.Add('FROM ' + UpperCase(ATableName));
    tmpTransaction.StartTransaction;
    tbl.Prepare;
    tbl.Open;
    tmpField:= TfqbField(AFieldList.Add);
    tmpField.FieldName := '*';
    for i := 0 to tbl.FieldCount - 1 do
    begin
      tmpField:= TfqbField(AFieldList.Add);
      tmpField.FieldName := tbl.Fields[i].DisplayName;
      tmpField.FieldType := Ord(tbl.Fields[i].DataType);
    end
  finally
    if tmpTransaction.Active then
      tmpTransaction.Commit;
    tbl.Close;
    tbl.Free;
    tmpTransaction.Free;
  end;
end;

procedure TfqbFIBEngine.ReadTableList(ATableList: TStrings);
begin
  ATableList.Clear;
  FDatabase.Open;
  FDatabase.GetTableNames(ATableList, ShowSystemTables);
end;

function TfqbFIBEngine.ResultDataSet: TDataSet;
begin
  Result := FQuery
end;

procedure TfqbFIBEngine.SetDatabase(Value: TpFIBDatabase);
begin
  FQuery.Close;
  FDatabase := Value;
  FQuery.Database := FDatabase;
end;

procedure TfqbFIBEngine.SetSQL(const Value: string);
begin
  FQuery.Close;
  FQuery.SelectSQL.Text := Value;
end;



end.
