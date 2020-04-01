{******************************************}
{                                          }
{             FastReport v6.0              }
{           Table Object Editors           }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxTableObjectEditor;

interface

{$I frx.inc}

uses
  SysUtils, Types, Classes, Variants, Controls,
  frxClass, frxDsgnIntf;

type
  TfrxTableCellEditor = class(TfrxComponentEditor)
  public
    procedure GetMenuItems; override;
    function Execute(Tag: Integer; Checked: Boolean): Boolean; override;
    function Edit: Boolean; override;
    function HasEditor: Boolean; override;
  end;

  TfrxTableRowColumnEditor = class(TfrxComponentEditor)
  public
    procedure GetMenuItems; override;
    function Execute(Tag: Integer; Checked: Boolean): Boolean; override;
  end;

  TfrxDragDropRowColumnEditor = class(TfrxInPlaceEditor)
  public
    function DoCustomDragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    function DoCustomDragDrop(Source: TObject; X, Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
      override;
  end;

implementation

uses Math, frxDesgnEditors, frxRes, frxTableObject, frxEditMemo,
  frxInPlaceEditors, ComCtrls;

const
  ClipboardPrefix: String = '#FR6 clipboard#table#';

type
  THackTableObject = class(TfrxTableObject);
{ TfrxTableCellEditor }

function TfrxTableCellEditor.Edit: Boolean;
begin
  with TfrxMemoEditorForm.Create(Designer) do
  begin
    MemoView := TfrxMemoView(Component);
    Result := ShowModal = mrOk;
    if Result then
    begin
      MemoView.Text := Text;
      MemoView.DataField := '';
    end;
    Free;
  end;
end;

function TfrxTableCellEditor.Execute(Tag: Integer; Checked: Boolean): Boolean;
begin
  Result := inherited Execute(Tag, Checked);
  if (Designer.SelectedObjects.Count > 0) and not (TObject(Designer.SelectedObjects[0]) is TfrxTableCell) then Exit;
  case Tag of
    0: TfrxTableCell(Designer.SelectedObjects[0]).ParentTable.JoinSelection;
    1: TfrxTableCell(Designer.SelectedObjects[0]).ParentTable.SplitCell(TfrxTableCell(Designer.SelectedObjects[0]));
  end;
  Designer.SelectedObjects.Clear;
  Designer.Invalidate;
  Result := True;
end;


procedure TfrxTableCellEditor.GetMenuItems;
var
  i: Integer;
  bAddItem: Boolean;
begin
  bAddItem := (Designer.SelectedObjects.Count > 1);
  for i := 0 to Designer.SelectedObjects.Count - 1 do
    if not(TObject(Designer.SelectedObjects[i]) is TfrxTableCell) then
    begin
      bAddItem := False;
      break;
    end;

  if bAddItem then
    AddItem('Join cell', 0); // TODO: Move to resources

  bAddItem := (Designer.SelectedObjects.Count = 1) and
    (TObject(Designer.SelectedObjects[0]) is TfrxTableCell) and
    ((TfrxTableCell(Designer.SelectedObjects[0]).RowSpan > 1) or (TfrxTableCell(Designer.SelectedObjects[0]).ColSpan > 1));
  if bAddItem then
    AddItem('Split cell', 1); // TODO: Move to resources
  AddItem('-', -1);
  inherited;
end;

function TfrxTableCellEditor.HasEditor: Boolean;
begin
  Result := True;
end;

{ TfrxTableRowColumnEditor }

function TfrxTableRowColumnEditor.Execute(Tag: Integer;
  Checked: Boolean): Boolean;
var
  i: Integer;
  c: TfrxComponent;
  rc: TfrxTableRowColumnBase;
  t: TfrxTableObject;
begin
  Result := inherited Execute(Tag, Checked);
  for i := 0 to Designer.SelectedObjects.Count - 1 do
  begin
    c := Designer.SelectedObjects[i];
    if (c is TfrxTableRowColumnBase) and not (rfDontModify in c.Restrictions) then
    begin
      rc := TfrxTableRowColumnBase(c);
      t := rc.ParentTable;
      case Tag of
        0: rc.AutoSize := Checked;
        1: t.CreateNewRow(rc.Index);
        2: t.CreateNewRow(rc.Index + 1);
        3: t.CreateNewColumn(rc.Index);
        4: t.CreateNewColumn(rc.Index + 1);
      end;
      Result := True;
    end;
  end;
end;

procedure TfrxTableRowColumnEditor.GetMenuItems;
var
  r: TfrxTableRowColumnBase;
begin
  r := TfrxTableRowColumnBase(Component);
  inherited;
  AddItem(frxResources.Get('pvAutoSize'), 0, r.AutoSize);
  if r is TfrxTableRow then
  begin
    AddItem('Add row before', 1);
    AddItem('Add row after', 2);
  end
  else if r is TfrxTableColumn then
  begin
    AddItem('Add column before', 3);
    AddItem('Add column after', 4);
  end;
end;

{ TfrxDragDropRowColumnEditor }

function TfrxDragDropRowColumnEditor.DoCustomDragDrop(Source: TObject; X,
  Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  Node: TTreeNode;
  i, nCount: Integer;
  s: String;
  aTable: TfrxTableObject;
  cell: TfrxTableCell;
  rc: TfrxTableRowColumnBase;
begin
  rc := TfrxTableRowColumnBase(FComponent);
  Result := False;
  if rc = nil then
    Exit;
  aTable := rc.ParentTable;
  if aTable = nil then
    Exit;
  if rc Is TfrxTableRow then
    nCount := aTable.ColumnCount
  else
    nCount := aTable.RowCount;
  if (Source is TTreeView) then

    for i := 0 to TTreeView(Source).SelectionCount - 1 do
    begin
      if i >= nCount then
        break;

      Node := TTreeView(Source).Selections[i];
      s := '';
      if (Node <> nil) and (Node.Data <> nil) then
        s := rc.Report.GetAlias(TfrxDataSet(Node.Data));
      if s <> '' then
      begin
        Result := True;
        if rc Is TfrxTableRow then
          cell := aTable.Cells[i, rc.Index]
        else
          cell := aTable.Cells[rc.Index, i];
        cell.Text := '[' + s + '."' + Node.Text + '"]';
        cell.DataSet := nil;
        cell.DataField := '';
        EventParams.Refresh := True;
        EventParams.Modified := True;
      end;
    end;
end;


function TfrxDragDropRowColumnEditor.DoCustomDragOver(Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  aTable: TfrxTableObject;
begin
  Result := False;
  aTable := TfrxTableRowColumnBase(FComponent).ParentTable;
  if aTable = nil then Exit;
  Accept := (Source is TControl and (TControl(Source).Name = 'DataTree'));
  EventParams.Refresh := Accept;
  if Accept then
    THackTableObject(aTable).FSelectedRowCol := TfrxTableRowColumnBase(FComponent);
end;

initialization
  frxComponentEditors.Register(TfrxTableCell, TfrxTableCellEditor);
  frxComponentEditors.Register(TfrxTableRowColumnBase, TfrxTableRowColumnEditor);
  frxRegEditorsClasses.Register(TfrxTableRow, [TfrxDragDropRowColumnEditor], [[evDesigner]]);
  frxRegEditorsClasses.Register(TfrxTableColumn, [TfrxDragDropRowColumnEditor], [[evDesigner]]);
  frxObjects.RegisterObject1(TfrxTableObject, nil, '', '', 0, 67);
  // prevent adding these items to the Objects toolbar
  frxObjects.RegisterObject1(TfrxTableRow, nil, '', '', 0, 73, [ctNone]);
  frxObjects.RegisterObject1(TfrxTableColumn, nil, '', '', 0, 72, [ctNone]);
  frxObjects.RegisterObject1(TfrxTableCell, nil, '', '', 0, 71, [ctNone]);
  frxRegEditorsClasses.Register(TfrxTableCell, [TfrxInPlaceDataFiledEditor, TfrxInPlaceMemoEditor], [[evDesigner], [evDesigner, evPreview]]);
  frxHideProperties(TfrxTableCell, 'Visible;ShiftMode;StretchMode');

finalization
  frxObjects.UnRegister(TfrxTableObject);
  frxObjects.UnRegister(TfrxTableRow);
  frxObjects.UnRegister(TfrxTableColumn);
  frxObjects.UnRegister(TfrxTableCell);


end.
