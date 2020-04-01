
{******************************************}
{                                          }
{             FastReport v5.0              }
{          DBX components RTTI             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxDBXRTTI;

interface

{$I frx.inc}

implementation

uses
  Windows, Classes, Types, fs_iinterpreter, frxDBXComponents, Variants;


type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddClass(TfrxDBXDatabase, 'TfrxCustomDatabase');
    AddClass(TfrxDBXTable, 'TfrxCustomTable');
    with AddClass(TfrxDBXQuery, 'TfrxCustomQuery') do
      AddMethod('procedure ExecSQL', CallMethod);
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TfrxDBXQuery then
  begin
    if MethodName = 'EXECSQL' then
      TfrxDBXQuery(Instance).Query.ExecSQL
  end
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
