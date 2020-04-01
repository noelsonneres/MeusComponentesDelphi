unit frxlazsqlitertti;

{$I frx.inc}

interface



implementation

uses
  Classes, SysUtils,
  fs_iinterpreter, frxlazsqlitecomp, Variants;

type

  { TFunctions }

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

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TfrxLazSqliteQuery then
  begin
    if MethodName = 'EXECSQL' then
      TfrxLazSqliteQuery(Instance).Query.ExecSQL
  end;
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TfrxLazSqliteDatabase then
  begin
    if PropName = 'DATABASE' then
      Result := frxInteger(TfrxLazSqliteDatabase(Instance).Database)
  end
  else if ClassType = TfrxLazSqliteQuery then
  begin
    if PropName = 'QUERY' then
      Result := frxInteger(TfrxLazSqliteQuery(Instance).Query)
  end

end;

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    with AddClass(TfrxLazSqliteDatabase, 'TfrxCustomDatabase') do
      AddProperty('Database', 'TSQLite3Connection', GetProp, nil);
    with AddClass(TfrxLazSqliteQuery, 'TfrxCustomQuery') do
    begin
      AddMethod('procedure ExecSQL', CallMethod);
      AddProperty('Query', 'TSqlQuery', GetProp, nil);
    end;
  end;

end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);




end.

