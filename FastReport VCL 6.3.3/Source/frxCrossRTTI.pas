
{******************************************}
{                                          }
{             FastReport v5.0              }
{              Cross-tab RTTI              }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxCrossRTTI;

interface

{$I frx.inc}

implementation

uses
  {$IFNDEF FPC}Windows,{$ENDIF} Types, Classes, SysUtils, Forms, fs_iinterpreter, 
  frxCross, frxClassRTTI, Variants;


type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
    procedure SetProp(Instance: TObject; ClassType: TClass;
      const PropName: String; Value: Variant);
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddEnum('TfrxCrossFunction', 'cfNone, cfSum, cfMin, cfMax, cfAvg, cfCount');
    with AddClass(TfrxCustomCrossView, 'TfrxView') do
    begin
      AddMethod('procedure AddValue(Rows, Columns, Cells: array)', CallMethod);
      AddMethod('procedure BeginMatrix', CallMethod);
      AddMethod('function ColCount: Integer', CallMethod);
      AddMethod('function RowCount: Integer', CallMethod);
      AddMethod('function IsGrandTotalColumn(Index: Integer): Boolean', CallMethod);
      AddMethod('function IsGrandTotalRow(Index: Integer): Boolean', CallMethod);
      AddMethod('function IsTotalColumn(Index: Integer): Boolean', CallMethod);
      AddMethod('function IsTotalRow(Index: Integer): Boolean', CallMethod);
      AddProperty('ClearBeforePrint', 'Boolean', GetProp, SetProp);
      AddIndexProperty('CellFunctions', 'Integer', 'TfrxCrossFunction', CallMethod);
    end;

    AddClass(TfrxCrossView, 'TfrxCustomCrossView');
    AddClass(TfrxDBCrossView, 'TfrxCustomCrossView');
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  ar: array[0..2] of array of Variant;
  _TfrxCustomCrossView: TfrxCustomCrossView;

  procedure ConvertVariantToArray(v: Variant; Index: Integer);
  var
    i: Integer;
  begin
    SetLength(ar[Index], VarArrayHighBound(v, 1) + 1);
    for i := 0 to VarArrayHighBound(v, 1) do
      ar[Index][i] := v[i];
  end;

begin
  Result := 0;
  _TfrxCustomCrossView := TfrxCustomCrossView(Instance);

  if MethodName = 'ADDVALUE' then
  begin
    ConvertVariantToArray(Caller.Params[0], 0);
    ConvertVariantToArray(Caller.Params[1], 1);
    ConvertVariantToArray(Caller.Params[2], 2);
    _TfrxCustomCrossView.AddValue(ar[0], ar[1], ar[2]);
    ar[0] := nil;
    ar[1] := nil;
    ar[2] := nil;
  end
  else if MethodName = 'BEGINMATRIX' then
    _TfrxCustomCrossView.BeginMatrix
  else if MethodName = 'COLCOUNT' then
    Result := _TfrxCustomCrossView.ColCount
  else if MethodName = 'ROWCOUNT' then
    Result := _TfrxCustomCrossView.RowCount
  else if MethodName = 'ISGRANDTOTALCOLUMN' then
    Result := _TfrxCustomCrossView.IsGrandTotalColumn(Caller.Params[0])
  else if MethodName = 'ISGRANDTOTALROW' then
    Result := _TfrxCustomCrossView.IsGrandTotalRow(Caller.Params[0])
  else if MethodName = 'ISTOTALCOLUMN' then
    Result := _TfrxCustomCrossView.IsTotalColumn(Caller.Params[0])
  else if MethodName = 'ISTOTALROW' then
    Result := _TfrxCustomCrossView.IsTotalRow(Caller.Params[0])
  else if MethodName = 'CELLFUNCTIONS.GET' then
    Result := _TfrxCustomCrossView.CellFunctions[Caller.Params[0]]
  else if MethodName = 'CELLFUNCTIONS.SET' then
    _TfrxCustomCrossView.CellFunctions[Caller.Params[0]] := TfrxCrossFunction(Caller.Params[1])
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if PropName = 'CLEARBEFOREPRINT' then
    Result := TfrxCustomCrossView(Instance).ClearBeforePrint
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if PropName = 'CLEARBEFOREPRINT' then
    TfrxCustomCrossView(Instance).ClearBeforePrint := Value;
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
