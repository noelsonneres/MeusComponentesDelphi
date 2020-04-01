{******************************************}
{                                          }
{             FastReport v6.0              }
{        Table Object Clipboard Editors    }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxTableObjectClipboard;

interface

{$I frx.inc}

uses
  SysUtils, Types, Classes, Variants, Controls,
  frxClass;

type
  TfrxRowColumnCopyPasteEditor = class(TfrxInPlaceEditor)
  public
    procedure CopyContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault); override;
    procedure PasteContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault); override;
    function IsPasteAvailable(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType = cptDefault): Boolean; override;
  end;

  TfrxTableCellCopyPasteEditor = class(TfrxInPlaceEditor)
  public
    procedure CopyContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault); override;
    procedure PasteContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault); override;
    function IsPasteAvailable(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType = cptDefault): Boolean; override;
  end;

implementation

uses Math, frxTableObject,
  frxInPlaceEditors, Clipbrd, frxXML, frxXMLSerializer,
  frxUnicodeUtils, frxInPlaceClipboards
{$IFDEF Delphi10}
, WideStrings
{$ENDIF}
{$IFDEF FPC}
  ,Lazhelper
{$ENDIF} ;

const
  ClipboardPrefix: String = '#FR6 clipboard#table#';

{ TfrxRowColumnCopyPasteEditor }

procedure TfrxRowColumnCopyPasteEditor.CopyContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType);
var
  aTable: TfrxTableObject;
  i: Integer;
  aBase: TfrxTableRowColumnBase;
  ss: TStringStream;
  aRoot: TfrxXMLItem;
  wr: TfrxXMLWriter;
  Writer: TfrxXMLSerializer;
  aText: String;
begin
  if not(CopyFrom is TfrxTableRowColumnBase) then
    Exit;

  aText := ClipboardPrefix;
  aTable := TfrxTableObject.Create(nil);
  try
    aBase := TfrxTableRowColumnBase(CopyFrom);
    if CopyFrom is TfrxTableRow then
    begin
      aTable.RowCount := 1;
      aTable.ColumnCount := aBase.ParentTable.ColumnCount;
      for i := 0 to aTable.ColumnCount - 1 do
        aTable.Cells[i, 0].AssignAll(aBase.ParentTable.Cells[i, aBase.Index]);
    end
    else
    begin
      aTable.ColumnCount := 1;
      aTable.RowCount := aBase.ParentTable.RowCount;
      for i := 0 to aTable.RowCount - 1 do
        aTable.Cells[0, i].AssignAll(aBase.ParentTable.Cells[aBase.Index, i]);
    end;

    ss := TStringStream.Create('');
    Writer := TfrxXMLSerializer.Create(nil);
    aRoot := TfrxXMLItem.Create;
    wr := TfrxXMLWriter.Create(ss);
    try
      Writer.Owner := aBase.Report;

      Writer.WriteRootComponent(aTable, True, aRoot, True);
      wr.AutoIndent := False;
      wr.WriteRootItem(aRoot);
      aText := aText + ss.DataString;
    finally
      aRoot.Free;
      wr.Free;
      ss.Free;
      Writer.Free;
    end;
  finally
    aTable.Free;
  end;
  Clipboard.AsText := aText;
end;

function TfrxRowColumnCopyPasteEditor.IsPasteAvailable(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType): Boolean;

  function FastCheck: Boolean;
  var
    I, MaxLen: Integer;
    sText: String;
  begin
    MaxLen := Length(ClipboardPrefix);
    sText := Clipboard.AsText;
    Result := False;
    if MaxLen > Length(sText) then
      Exit;
    Result := True;
    for i := 1 to MaxLen do
      if sText[i] <> ClipboardPrefix[i] then
      begin
        Result := False;
        break;
      end;
  end;
begin
  Result := FastCheck;
end;

procedure TfrxRowColumnCopyPasteEditor.PasteContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType);
var
  aTable: TfrxTableObject;
  i, maxCount: Integer;
  aBase: TfrxTableRowColumnBase;
  aRow: TfrxTableRow;
  aColumn: TfrxTableColumn;
  ss: TStringStream;
  aRoot: TfrxXMLItem;
  wr: TfrxXMLReader;
  Writer: TfrxXMLSerializer;
  aText: String;
begin
  aText := '';
  aTable := TfrxTableObject.Create(nil);
  try
    if PasteTo is TfrxTableRowColumnBase then
    begin
      aBase := TfrxTableRowColumnBase(PasteTo);
      ss := TStringStream.Create(Clipboard.AsText);
      Writer := TfrxXMLSerializer.Create(nil);
      aRoot := TfrxXMLItem.Create;
      wr := TfrxXMLReader.Create(ss);
      try
        wr.ReadRootItem(aRoot);
        Writer.Owner := aTable;
        Writer.ReadRootComponent(aTable, aRoot);
      finally
        aRoot.Free;
        wr.Free;
        ss.Free;
        Writer.Free;
      end;

      aTable.UpdateBounds;
      i := aBase.Index;
      if aBase is TfrxTableRow then
      begin
        maxCount := Min(aBase.ParentTable.ColumnCount, aTable.ColumnCount);
        aRow := TfrxTableRow.Create(aBase.ParentTable);
        aBase.ParentTable.InsertRow(i, aRow);
        aRow.ParentTable.UpdateBounds;
        for i := 0 to maxCount - 1 do
          aBase.ParentTable.Cells[i, aRow.Index].AssignAll(aTable.Cells[i, 0]);
      end
      else
      begin
        maxCount := Min(aBase.ParentTable.RowCount, aTable.RowCount);
        aColumn := TfrxTableColumn.Create(aBase.ParentTable);
        aBase.ParentTable.InsertColumn(i, aColumn);
        aColumn.ParentTable.UpdateBounds;
        for i := 0 to maxCount - 1 do
          aBase.ParentTable.Cells[aColumn.Index, i].AssignAll
            (aTable.Cells[0, i]);
      end;
    end;
  finally
    aTable.Free;
  end;
end;

{ TfrxTableCellCopyPasteEditor }

procedure TfrxTableCellCopyPasteEditor.CopyContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType);
var
  s: String;
  table, NextTable: TfrxTableObject;
  x, y, i: Integer;
  bFirst: Boolean;
  SkipList: TList;

  function BuildString(sLines: TWideStrings): WideString;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to sLines.Count - 1 do
    begin
      Result := Result + sLines[i];
      if i < sLines.Count - 1  then
        Result := Result + ' ';
    end;
  end;

begin

  if CopyFrom is TfrxTableCell then
  begin
    if Assigned(EventParams.SelectionList) and (EventParams.SelectionList.Count > 1) then
    begin
      SkipList := TList.Create;
      try
        for i := 0 to EventParams.SelectionList.Count - 1 do
          if TObject(EventParams.SelectionList[i]) is TfrxTableCell then
          begin
            NextTable := TfrxTableCell(EventParams.SelectionList[i])
              .ParentTable;
            if SkipList.IndexOf(NextTable) <> -1 then
              continue;
            SkipList.Add(NextTable);
            table := NextTable;
            for Y := 0 to table.RowCount - 1 do
            begin
              bFirst := True;
              for X := 0 to table.ColumnCount - 1 do
                if table.Cells[X, Y].IsSelected then
                begin
                  if bFirst then
                    bFirst := False
                  else
                    s := s + #9;
                  s := s + BuildString(table.Cells[X, Y].Lines);
                end;
              if not bFirst then
                s := s + sLineBreak;
            end;
          end;
        Clipboard.AsText := s;
      finally
        FreeAndNil(SkipList);
      end;
    end;
  end;
end;

function TfrxTableCellCopyPasteEditor.IsPasteAvailable(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType): Boolean;
begin
  Result := True;
end;

procedure TfrxTableCellCopyPasteEditor.PasteContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType);
var
  tCell: TfrxTableCell;
  table: TfrxTableObject;
  x, y, idx: Integer;
  sText: String;

  function GetCellText : String;
  var
    i: Integer;
  begin
    for i := idx to Length(sText) do
    begin
      if (sText[i] = #9) or (sText[i] = #$D) then
      begin
        Result := Copy(sText, idx, i - idx);
        idx := i + 1;
        if (sText[i] = #$D) then Inc(idx);
        Exit;
      end;
    end;
    Result := Copy(sText, idx, Length(sText) - idx);
  end;

begin

  if PasteTo is TfrxTableCell then
  begin
    sText := Clipboard.AsText;
    tCell := TfrxTableCell(PasteTo);
    table := tCell.ParentTable;
    idx := 1;
    for y := 0 to table.RowCount - 1 do
      for x := 0 to table.ColumnCount - 1 do
        if table.Cells[x, y].IsSelected then
        begin
          table.Cells[x, y].DataSet := nil;
          table.Cells[x, y].DataField := '';
          table.Cells[x, y].Text := GetCellText;
        end;
  end;
 EventParams.Modified := True;
 EventParams.Refresh := True;
end;

initialization
  frxRegEditorsClasses.Register(TfrxTableRow, [TfrxRowColumnCopyPasteEditor], [[evDesigner]]);
  frxRegEditorsClasses.Register(TfrxTableColumn, [TfrxRowColumnCopyPasteEditor], [[evDesigner]]);
  frxRegEditorsClasses.Register(TfrxTableCell, [TfrxInPlaceMemoCopyPasteEditor], [[evDesigner, evPreview]]);
end.
