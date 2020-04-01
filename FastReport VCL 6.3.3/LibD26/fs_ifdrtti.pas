{**********************************************}
{                                              }
{              FastScript v1.9                 }
{        FireDac classes and functions         }
{                                              }
{   (c) 2003-2014 by Alexander Tzyganenko,     }
{              Fast Reports Inc                }
{                                              }
{   Copyright (c) 2018 by Stalker SoftWare     }
{           <stalker4zx@gmail.com>             }
{                                              }
{**********************************************}

unit fs_iFDRTTI;

interface

{$i fs.inc}

uses
  SysUtils, Classes, DB, Types, Controls, fs_iinterpreter, fs_itools, fs_idbrtti,
  FireDAC.DatS, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Param;


type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfsFDRTTI = class(TComponent); // fake component

 function IntToFDDataSetLocateOptions(i :Integer) :TFDDataSetLocateOptions; forward;
 function IntToFDCopyDataSetOptions(i :Integer) :TFDCopyDataSetOptions; forward;

implementation

type
  TfsFDRTTIFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure SetProp(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
  public
    constructor Create(AScript: TfsScript); override;
  end;

{ TfsFDRTTIFunctions }

{-------------------------------------------------------------------------------}
constructor TfsFDRTTIFunctions.Create(AScript: TfsScript);
begin

 inherited Create(AScript);

 with AScript do begin

   AddClass(TFDManager, 'TComponent');

   with AddClass(TFDBlobStream, 'TMemoryStream') do begin
     AddConstructor('constructor Create(Field :TBlobField; Mode :TBlobStreamMode)', CallMethod);
     AddMethod('procedure LoadFromFile(const FileName :String)', CallMethod);
     AddMethod('procedure LoadFromStream(Stream :TStream)', CallMethod);
     AddMethod('procedure SaveToStream(Stream :TStream)', CallMethod);
     AddMethod('procedure SaveToFile(const FileName :String)', CallMethod);
   end; { with }

   with AddClass(TFDConnection, 'TComponent') do begin
     AddMethod('procedure StartTransaction', CallMethod);
     AddMethod('procedure Commit', CallMethod);
     AddMethod('procedure Rollback', CallMethod);
     AddProperty('InTransaction', 'Boolean', GetProp, nil);
   end; { with }

   AddEnumSet('TFDDataSetLocateOptions' ,'lxoCaseInsensitive, lxoPartialKey, lxoFromCurrent, lxoBackward, lxoCheckOnly, lxoNoFetchAll');
   AddEnumSet('TFDCopyDataSetOptions' ,'coStructure, coCalcFields, coIndexesReset, coIndexesCopy, coConstraintsReset, coConstraintsCopy, coAggregatesReset, coAggregatesCopy, coRestart, coAppend, coEdit, coDelete, coRefresh');

   with AddClass(TFDDataSet, 'TDataSet') do begin
     AddMethod('function LocateEx(const AKeyFields :String; const AKeyValues :Variant; AOptions :TFDDataSetLocateOptions) :Boolean', CallMethod);
     AddMethod('function LocateExpr(const AExpression :String; AOptions :TFDDataSetLocateOptions) :Boolean', CallMethod);
     AddMethod('procedure FetchAll', CallMethod);
     AddMethod('function CreateBlobStream(Field :TField; Mode :TBlobStreamMode) :TStream', CallMethod);
     AddMethod('function FindField(const FieldName :String) :TField', CallMethod);
     AddMethod('procedure CopyDataSet(ASource :TDataset; AOptions :TFDCopyDataSetOptions)', CallMethod);
     AddMethod('procedure SetFDData(ASource :TFDDataSet)', CallMethod);
     AddProperty('RecNo', 'LongInt', GetProp, SetProp);
     AddProperty('RecordCount', 'LongInt', GetProp, nil);
     AddProperty('FieldDefs', 'TFieldDefs', GetProp, SetProp);
   end; { with }

   AddClass(TFDAdaptedDataSet, 'TFDDataSet');
   AddClass(TFDRdbmsDataSet, 'TFDAdaptedDataSet');
   AddClass(TFDParam, 'TCollectionItem');
   AddClass(TFDMacro, 'TCollectionItem');

   with AddClass(TFDQuery, 'TFDRdbmsDataSet') do begin
     AddMethod('procedure ExecSQL', CallMethod);
     AddMethod('function ParamByName(const Value :String) :TFDParam', CallMethod);
     AddMethod('procedure Prepare', CallMethod);
     AddMethod('function MacroByName(const Value :String) :TFDMacro', CallMethod);
     AddProperty('ParamCount', 'Word', GetProp, nil);
     AddProperty('MacroCount', 'Word', GetProp, nil);
   end; { with }

   with AddClass(TFDMemTable, 'TFDAdaptedDataSet') do begin
     AddMethod('procedure CreateDataSet', CallMethod);
     AddMethod('procedure Refresh', CallMethod);
   end; { with }

   with AddClass(TFDStoredProc, 'TFDRdbmsDataSet') do begin
     AddMethod('procedure ExecProc', CallMethod);
     AddMethod('function ParamByName(const Value :string) :TFDParam', CallMethod);
     AddMethod('procedure Prepare', CallMethod);
     AddProperty('ParamCount', 'Word', GetProp, nil);
   end;

 end; { with }

end; { Create }

{-------------------------------------------------------------------------------}
function TfsFDRTTIFunctions.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin

 Result := 0;

 if ClassType = TFDBlobStream then begin

   if MethodName = 'CREATE' then
     Result := frxInteger(TFDBlobStream.Create(TBlobField(frxInteger(Caller.Params[0])), Caller.Params[1]))
   else
   if MethodName = 'LOADFROMFILE' then
     TFDBlobStream(Instance).LoadFromFile(Caller.Params[0])
   else
   if MethodName = 'LOADFROMSTREAM' then
     TFDBlobStream(Instance).LoadFromStream(TStream(frxInteger(Caller.Params[0])))
   else
   if MethodName = 'SAVETOFILE' then
     TFDBlobStream(Instance).SaveToFile(Caller.Params[0])
   else
   if MethodName = 'SAVETOSTREAM' then
     TFDBlobStream(Instance).SaveToStream(TStream(frxInteger(Caller.Params[0])))

 end else
 if ClassType = TFDConnection then begin

   if MethodName = 'STARTTRANSACTION' then
     TFDConnection(Instance).StartTransaction
   else
   if MethodName = 'COMMIT' then
     TFDConnection(Instance).Commit
   else
   if MethodName = 'ROLLBACK' then
     TFDConnection(Instance).Rollback

 end else
 if ClassType = TFDDataSet then begin

   if MethodName = 'LOCATEEX' then
     Result := TFDDataSet(Instance).LocateEx(Caller.Params[0], Caller.Params[1], IntToFDDataSetLocateOptions(Caller.Params[2]))
   else
   if MethodName = 'LOCATEEXPR' then
     Result := TFDDataSet(Instance).LocateEx(Caller.Params[0], IntToFDDataSetLocateOptions(Caller.Params[1]))
   else
   if MethodName = 'FETCHALL' then
     TFDDataSet(Instance).FetchAll
   else
   if MethodName = 'CREATEBLOBSTREAM' then
     Result := frxInteger(TFDDataSet(Instance).CreateBlobStream(TField(frxInteger(Caller.Params[0])), Caller.Params[1]))
   else
   if MethodName = 'FINDFIELD' then
     Result := frxInteger(TFDDataSet(Instance).FindField(Caller.Params[0]))
   else
   if MethodName = 'COPYDATASET' then
     TFDDataSet(Instance).CopyDataSet(TDataSet(frxInteger(Caller.Params[0])), IntToFDCopyDataSetOptions(Caller.Params[1]))
   else
   if MethodName = 'SETFDDATA' then
     TFDDataSet(Instance).Data := TFDDataSet(frxInteger(Caller.Params[0])).Data;

 end else
 if ClassType = TFDQuery then begin

   if MethodName = 'EXECSQL' then
     TFDQuery(Instance).ExecSQL
   else
   if MethodName = 'PARAMBYNAME' then
     Result := frxInteger(TFDQuery(Instance).ParamByName(Caller.Params[0]))
   else
   if MethodName = 'PREPARE' then
     TFDQuery(Instance).Prepare
   else
   if MethodName = 'MACROBYNAME' then
     Result := frxInteger(TFDQuery(Instance).MacroByName(Caller.Params[0]))

 end else
 if ClassType = TFDMemTable then begin

   if MethodName = 'CREATEDATASET' then
     TFDMemTable(Instance).CreateDataSet()
   else
   if MethodName = 'REFRESH' then
     TFDMemTable(Instance).Refresh()

 end else
 if ClassType = TFDStoredProc then begin

   if MethodName = 'EXECPROC' then
     TFDStoredProc(Instance).ExecProc
   else
   if MethodName = 'PARAMBYNAME' then
     Result := frxInteger(TFDStoredProc(Instance).ParamByName(Caller.Params[0]))
   else
   if MethodName = 'PREPARE' then
     TFDStoredProc(Instance).Prepare;

 end; { if }

end; { CallMethod }

{-------------------------------------------------------------------------------}
function TfsFDRTTIFunctions.GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin

 Result := 0;

 if ClassType = TFDConnection then begin

   if PropName = 'INTRANSACTION' then
     Result := TFDConnection(Instance).InTransaction

 end else
 if ClassType = TFDDataSet then begin

   if PropName = 'RECNO' then
     Result := TFDDataSet(Instance).RecNo
   else
   if PropName = 'RECORDCOUNT' then
     Result := TFDDataSet(Instance).RecordCount

 end else
 if ClassType = TFDQuery then begin

   if PropName = 'PARAMCOUNT' then
     Result := TFDQuery(Instance).ParamCount
   else
   if PropName = 'MacroCount' then
     Result := TFDQuery(Instance).MacroCount

 end; { if }

end; { GetProp }

{-------------------------------------------------------------------------------}
procedure TfsFDRTTIFunctions.SetProp(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin

 if ClassType = TFDDataSet then begin

   if PropName = 'RECNO' then
     TFDDataSet(Instance).RecNo := Value

 end; { if }

end; { SetProp }

{-------------------------------------------------------------------------------}
function IntToFDDataSetLocateOptions(i :Integer) :TFDDataSetLocateOptions;
begin

 Result := [];

 if (i and 1) <> 0 then
   Result := Result + [lxoCaseInsensitive];

 if (i and 2) <> 0 then
   Result := Result + [lxoPartialKey];

 if (i and 4) <> 0 then
   Result := Result + [lxoFromCurrent];

 if (i and 8) <> 0 then
   Result := Result + [lxoBackward];

 if (i and 16) <> 0 then
   Result := Result + [lxoCheckOnly];

 if (i and 32) <> 0 then
   Result := Result + [lxoNoFetchAll];

end; { IntToFDDataSetLocateOptions }

{-------------------------------------------------------------------------------}
function IntToFDCopyDataSetOptions(i :Integer) :TFDCopyDataSetOptions;
begin

 Result := [];

 if (i and 1) <> 0 then
   Result := Result + [coStructure];

 if (i and 2) <> 0 then
   Result := Result + [coCalcFields];

 if (i and 4) <> 0 then
   Result := Result + [coIndexesReset];

 if (i and 8) <> 0 then
   Result := Result + [coIndexesCopy];

 if (i and 16) <> 0 then
   Result := Result + [coConstraintsReset];

 if (i and 32) <> 0 then
   Result := Result + [coConstraintsCopy];

 if (i and 64) <> 0 then
   Result := Result + [coAggregatesReset];

 if (i and 128) <> 0 then
   Result := Result + [coAggregatesCopy];

 if (i and 256) <> 0 then
   Result := Result + [coRestart];

 if (i and 512) <> 0 then
   Result := Result + [coAppend];

 if (i and 1024) <> 0 then
   Result := Result + [coEdit];

 if (i and 2048) <> 0 then
   Result := Result + [coDelete];

 if (i and 4096) <> 0 then
   Result := Result + [coRefresh];

end; { IntToFDCopyDataSetOptions }

initialization
{$IFDEF Delphi16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfsFDRTTI, TControl);
{$ENDIF}
  fsRTTIModules.Add(TfsFDRTTIFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TfsFDRTTIFunctions);

end.
