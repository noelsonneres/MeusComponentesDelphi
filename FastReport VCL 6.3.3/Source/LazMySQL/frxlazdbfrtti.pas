unit frxlazdbfrtti;

{$I frx.inc}

interface


implementation

uses
  Classes, SysUtils,Types, fs_iinterpreter,
  Variants, frxlazdbfcomp;

type

  { TFunctions }

  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject;  ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;
  if ClassType = TfrxDBFTable then
    if MethodName = 'ADDINDEX' then
      TfrxDBFTable(Instance).AddIndex(Caller.Params[0], Caller.Params[1]);
    if MethodName = 'ADDINDEXDESCENDING' then
      TfrxDBFTable(Instance).AddIndexDescending(Caller.Params[0], Caller.Params[1]);

end;


constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    with AddClass(TfrxDBFTable,'TfrxCustomTable') do
    begin
      AddMethod('procedure AddIndex(AIndexName, AFields: string)',
        CallMethod);
      AddMethod('procedure AddIndexDescending(AIndexName, AFields: string)',
        CallMethod);

    end;
  end;
end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);


end.

