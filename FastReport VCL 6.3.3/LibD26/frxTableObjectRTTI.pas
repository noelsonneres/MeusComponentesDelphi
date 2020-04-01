
{******************************************}
{                                          }
{             FastReport v6.0              }
{            Table Object RTTI             }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxTableObjectRTTI;

interface

{$I frx.inc}

implementation

uses
  Types, Classes, SysUtils,
  fs_iinterpreter, frxClassRTTI, frxTableObject, Variants;


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
    with AddClass(TfrxTableCell, 'TfrxCustomMemoView') do
    begin
      AddMethod('function ParentTable: TfrxTableObject', CallMethod);
      AddMethod('function ParentRow: TfrxTableRow', CallMethod);
    end;

    with AddClass(TfrxTableRowColumnBase, 'TfrxComponent') do
    begin
      AddMethod('function ParentTable: TfrxTableObject', CallMethod);
      AddProperty('Index', 'Integer', GetProp, nil);
    end;

    AddClass(TfrxTableColumn, 'TfrxTableRowColumnBase');

    with AddClass(TfrxTableRow, 'TfrxTableRowColumnBase') do
    begin
      AddProperty('CellCount', 'Integer', GetProp, nil);
      AddIndexProperty('Cells', 'Integer', 'TfrxTableCell', CallMethod);
    end;

    with AddClass(TfrxTableObject, 'TfrxStretcheable') do
    begin
      AddMethod('function CreateNewColumn(Index: Integer): TfrxTableColumn', CallMethod);
      AddMethod('function CreateNewRow(Index: Integer): TfrxTableRow', CallMethod);
      AddMethod('procedure AddColumn(Value: TfrxTableColumn)', CallMethod);
      AddMethod('procedure InsertColumn(Index: Integer; Value: TfrxTableColumn)', CallMethod);
      AddMethod('procedure MoveColumn(Index, NewIndex: Integer)', CallMethod);
      AddMethod('procedure DeleteColumn(Index: Integer)', CallMethod);
      AddMethod('procedure AddRow(Value: TfrxTableRow)', CallMethod);
      AddMethod('procedure InsertRow(Index: Integer; Value: TfrxTableRow)', CallMethod);
      AddMethod('procedure SwapRows(Row1, Row2: Integer)', CallMethod);
      AddMethod('procedure DeleteRow(Index: Integer)', CallMethod);
      AddMethod('procedure UpdateBounds;', CallMethod);
      AddMethod('procedure JoinSelection(TopX: Integer; TopY: Integer; BottomX: Integer; BottomY: Integer)', CallMethod);
      AddMethod('procedure SplitCell(aCell: TfrxTableCell)', CallMethod);
      AddMethod('function Cells(X, Y: Integer): TfrxTableCell', CallMethod);

      AddIndexProperty('Columns', 'Integer', 'TfrxTableColumn', CallMethod);
      AddIndexProperty('Rows', 'Integer', 'TfrxTableRow', CallMethod);
      AddProperty('TableHeight', 'Extended', GetProp, SetProp);
      AddProperty('TableWidth', 'Extended', GetProp, SetProp);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TfrxTableCell then
  begin
    if MethodName = 'PARENTTABLE' then
      Result := frxInteger(TfrxTableCell(Instance).ParentTable)
    else if MethodName = 'PARENTROW' then
      Result := frxInteger(TfrxTableCell(Instance).ParentRow)
  end
  else if ClassType = TfrxTableRowColumnBase then
  begin
    if MethodName = 'PARENTTABLE' then
      Result := frxInteger(TfrxTableRowColumnBase(Instance).ParentTable)
  end
  else if ClassType = TfrxTableRow then
  begin
    if MethodName = 'CELLS.GET' then
      Result := frxInteger(TfrxTableRow(Instance).Cells[Caller.Params[0]])
  end
  else if ClassType = TfrxTableObject then
  begin
    if MethodName = 'CREATENEWCOLUMN' then
      Result := frxInteger(TfrxTableObject(Instance).CreateNewColumn(Caller.Params[0]))
    else if MethodName = 'CREATENEWROW' then
      Result := frxInteger(TfrxTableObject(Instance).CreateNewRow(Caller.Params[0]))
    else if MethodName = 'ADDCOLUMN' then
      TfrxTableObject(Instance).AddColumn(TfrxTableColumn(frxInteger(Caller.Params[0])))
    else if MethodName = 'INSERTCOLUMN' then
      TfrxTableObject(Instance).InsertColumn(Caller.Params[0], TfrxTableColumn(frxInteger(Caller.Params[1])))
    else if MethodName = 'MOVECOLUMN' then
      TfrxTableObject(Instance).MoveColumn(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'DELETECOLUMN' then
      TfrxTableObject(Instance).DeleteColumn(Caller.Params[0])
    else if MethodName = 'ADDROW' then
      TfrxTableObject(Instance).AddRow(TfrxTableRow(frxInteger(Caller.Params[0])))
    else if MethodName = 'INSERTROW' then
      TfrxTableObject(Instance).InsertRow(Caller.Params[0], TfrxTableRow(frxInteger(Caller.Params[1])))
    else if MethodName = 'SWAPROWS' then
      TfrxTableObject(Instance).SwapRows(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'DELETEROW' then
      TfrxTableObject(Instance).DeleteRow(Caller.Params[0])
    else if MethodName = 'UPDATEBOUNDS' then
      TfrxTableObject(Instance).UpdateBounds
    else if MethodName = 'JOINSELECTION' then
      TfrxTableObject(Instance).JoinSelection(Caller.Params[0], Caller.Params[1], Caller.Params[2], Caller.Params[3])
    else if MethodName = 'SPLITCELL' then
      TfrxTableObject(Instance).SplitCell(TfrxTableCell(frxInteger(Caller.Params[0])))
    else if MethodName = 'CELLS' then
      Result := frxInteger(TfrxTableObject(Instance).Cells[Caller.Params[0], Caller.Params[1]])
    else if MethodName = 'COLUMNS.GET' then
      Result := frxInteger(TfrxTableObject(Instance).Columns[Caller.Params[0]])
    else if MethodName = 'ROWS.GET' then
      Result := frxInteger(TfrxTableObject(Instance).Rows[Caller.Params[0]])
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TfrxTableRowColumnBase then
  begin
    if PropName = 'INDEX' then
      Result := TfrxTableRowColumnBase(Instance).Index
  end
  else if ClassType = TfrxTableRow then
  begin
    if PropName = 'CELLCOUNT' then
      Result := TfrxTableRow(Instance).CellCount
  end
  else if ClassType = TfrxTableObject then
  begin
    if PropName = 'TABLEHEIGHT' then
      Result := TfrxTableObject(Instance).TableHeight
    else if PropName = 'TABLEWIDTH' then
      Result := TfrxTableObject(Instance).TableWidth;
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TfrxTableObject then
  begin
    if PropName = 'TABLEHEIGHT' then
      TfrxTableObject(Instance).TableHeight := Value
    else if PropName = 'TABLEWIDTH' then
      TfrxTableObject(Instance).TableWidth := Value;
  end
end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  fsRTTIModules.Remove(TFunctions);

end.
