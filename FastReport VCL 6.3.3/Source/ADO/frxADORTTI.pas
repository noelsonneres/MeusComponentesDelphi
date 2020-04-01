
{******************************************}
{                                          }
{             FastReport v5.0              }
{          ADO components RTTI             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxADORTTI;

interface

{$I frx.inc}

implementation

uses
  Windows, Types, Classes, fs_iinterpreter, frxADOComponents, fs_iadortti, Variants;
  

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddEnum('TADOLockType', 'ltUnspecified, ltReadOnly, ltPessimistic, ltOptimistic, ltBatchOptimistic');
    with AddClass(TfrxADODatabase, 'TfrxCustomDatabase') do
      AddProperty('Database', 'TADOConnection', GetProp, nil);
    with AddClass(TfrxADOTable, 'TfrxCustomTable') do
      AddProperty('Table', 'TADOTable', GetProp, nil);
    with AddClass(TfrxADOQuery, 'TfrxCustomQuery') do
    begin
      AddMethod('procedure ExecSQL', CallMethod);
      AddProperty('Query', 'TADOQuery', GetProp, nil);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TfrxADOQuery then
  begin
    if MethodName = 'EXECSQL' then
    begin
      TfrxADOQuery(Instance).UpdateParams;
      TfrxADOQuery(Instance).Query.ExecSQL
    end
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TfrxADODatabase then
  begin
    if PropName = 'DATABASE' then
      Result := frxInteger(TfrxADODatabase(Instance).Database)
  end
  else if ClassType = TfrxADOTable then
  begin
    if PropName = 'TABLE' then
      Result := frxInteger(TfrxADOTable(Instance).Table)
  end
  else if ClassType = TfrxADOQuery then
  begin
    if PropName = 'QUERY' then
      Result := frxInteger(TfrxADOQuery(Instance).Query)
  end
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
