{******************************************}
{                                          }
{             FastReport v6.0              }
{           CellularText Object            }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxCellularTextObject;

interface

{$I frx.inc}

uses
  SysUtils, Types, Classes, Graphics, Variants, Controls,
  frxClass, frxTableObject, frxUnicodeUtils
{$IFDEF Delphi10}
, WideStrings
{$ENDIF}
{$IFDEF FPC}
, LazHelper
{$ENDIF}
  ;


type


{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxReportCellularTextObject = class(TComponent)  // fake component
  end;

  TfrxCellularText = class(TfrxCustomMemoView)
  private
    FCellWidth: Extended;
    FCellHeight: Extended;
    FHorzSpacing: Extended;
    FVertSpacing: Extended;
    function GetCellWidth: Extended;
    function GetCellHeight: Extended;
    procedure WrapText(sLines: TWideStrings; ColumnCount: Integer);
    procedure BuildTable(aTable: TfrxTableObject);
  protected
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
  public
    constructor Create(AOwner: TComponent); override;
    function CalcHeight: Extended; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    function DrawPart: Extended; override;
    function ExportInternal(Filter: TfrxCustomExportFilter): Boolean; override;
    class function GetDescription: String; override;
  published
    property AllowExpressions;
    property BrushStyle;
    property Color;
    property CellWidth: Extended read FCellWidth write FCellWidth;
    property CellHeight: Extended read FCellHeight write FCellHeight;
    property HorzSpacing: Extended read FHorzSpacing write FHorzSpacing;
    property VertSpacing: Extended read FVertSpacing write FVertSpacing;
    property DataField;
    property DataSet;
    property DataSetName;
    property DisplayFormat;
    property ExpressionDelimiters;
    property Font;
    property Frame;
    property FillType;
    property Fill;
    property HAlign;
    property HideZeros;
    property Highlight;
    property Memo;
    property ParentFont;
    property RTLReading;
    property Style;
    property SuppressRepeated;
    property UseDefaultCharset;
    property WordWrap;
    property VAlign;
  end;




implementation

uses Math, frxGraphicUtils, frxRes, frxUtils, frxDesgnEditors, frxDsgnIntf,
     frxCellularTextObjectRTTI;


{ TfrxTableCell }

procedure TfrxCellularText.BuildTable(aTable: TfrxTableObject);
var
  i, ColColumn: Integer;
  cell: TfrxTableCell;
  sText: WideString;
  sLines: TWideStrings;
  aCellHeight, aCellWidth: Extended;

  procedure AssignCellsData;
  var
    X, Y, ln, Idx: Integer;
    IsGapRow, IsGapCol: Boolean;
  begin
    Ln := 0;
    for Y := 0 to aTable.RowCount - 1 do
    begin
      IsGapRow := (Y mod 2 = 1) and (FVertSpacing > 0) and (Y <> aTable.RowCount - 1);
      if IsGapRow then
        aTable.Rows[y].Height := FVertSpacing
      else
      begin
        aTable.Rows[y].Height := aCellHeight;

        if Ln < sLines.Count then
          sText := Trim(sLines[Ln])
        else
          sText := '';
        Inc(Ln);
        case HAlign of
          haLeft:
            i := 0;
          haRight:
            i := ColColumn - Length(sText);
        else
          i := (ColColumn - Length(sText)) div 2;
        end;
      end;
      Idx := 0;
      for X := 0 to aTable.ColumnCount - 1 do
      begin
        cell := aTable.Cells[X, Y];
        IsGapCol := (X mod 2 = 1) and (FHorzSpacing > 0) and (X <> aTable.ColumnCount - 1);
        if IsGapCol then
          aTable.Columns[X].Width := FHorzSpacing;
        if IsGapRow or IsGapCol then
        begin
          cell.Frame.Typ := [];
          Continue;
        end;
        cell.FillType := FillType;
        cell.Fill.Assign(Fill);
        cell.Frame.Assign(Frame);
        cell.Font.Assign(Font);
        cell.VAlign := vaCenter;
        cell.HAlign := haCenter;
        if (Length(sText) > Idx - i) and (Idx - i >= 0) then
          cell.Text := sText[Idx - i + 1];
        Inc(Idx)
      end;
    end;
  end;
begin
  aTable.RowCount := 0;
  aTable.ColumnCount := 0;
  aCellHeight := FCellHeight;
  aCellWidth := FCellWidth;
  if (aCellHeight = 0) or (aCellWidth = 0) then
  begin
    aCellHeight := GetCellHeight;
    aCellWidth := aCellHeight;
  end;

  aTable.DefaultCellHeight := aCellHeight;
  aTable.DefaultCellWidth := aCellWidth;
  aTable.RowCount := Trunc((Height + FVertSpacing) / (aCellHeight + FVertSpacing));
  if FVertSpacing > 0 then
    aTable.RowCount := aTable.RowCount * 2 - 1;
  ColColumn := Trunc((Width + FHorzSpacing) / (aCellWidth + FHorzSpacing));
  sText := Text;
{$IFDEF Delphi10}
  sLines := TfrxWideStrings.Create;
{$ELSE}
  sLines := TWideStrings.Create;
{$ENDIF}
  try
    WrapText(sLines, ColColumn);
    if FHorzSpacing > 0 then
      aTable.ColumnCount := ColColumn * 2 - 1
    else
      aTable.ColumnCount := ColColumn;
    AssignCellsData;
  finally
    sLines.Free;
  end;
end;

function TfrxCellularText.CalcHeight: Extended;
var
  aCellHeight, aCellWidth: Extended;
  sLines: TWideStrings;
begin
  aCellHeight := FCellHeight;
  aCellWidth  := FCellWidth;
  if (aCellHeight = 0) or (aCellWidth = 0) then
  begin
    aCellHeight := GetCellHeight;
    aCellWidth := aCellHeight;
  end;
{$IFDEF Delphi10}
  sLines := TfrxWideStrings.Create;
{$ELSE}
  sLines := TWideStrings.Create;
{$ENDIF}
  try
    WrapText(sLines, Trunc((Width + FHorzSpacing)/ (aCellWidth + FHorzSpacing)));
    Result := sLines.Count * (aCellHeight + FVertSpacing) - FVertSpacing;
  finally
    sLines.Free;
  end;
end;

constructor TfrxCellularText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCellWidth := 0;
  FCellHeight := 0;
  Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
end;

procedure TfrxCellularText.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  Table: TfrxTableObject;
begin
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  Table := TfrxTableObject.Create(nil);
  try
    BuildTable(Table);
    DrawBackground;
    Table.Draw(Canvas, ScaleX, ScaleY, OffsetX + AbsLeft * ScaleX, OffsetY + AbsTop * ScaleY);
    DrawFrameEdges;
  finally
    Table.Free;

  end;
end;

function TfrxCellularText.DrawPart: Extended;
begin
  // TODO make it breakable
  Result := Height;
end;

function TfrxCellularText.ExportInternal(
  Filter: TfrxCustomExportFilter): Boolean;
var
  x, y: Integer;
  cell: TfrxTableCell;
  aTable: TfrxTableObject;
begin
  aTable := TfrxTableObject.Create(nil);
  aTable.Top := AbsTop;
  aTable.Left := AbsLeft;
  BuildTable(aTable);
  aTable.UpdateBounds;
  for y := 0 to aTable.RowCount - 1 do
    for x := 0 to aTable.ColumnCount - 1 do
    begin
      cell := aTable.Cells[x, y];
      Filter.ExportObject(cell);
    end;
  Result := True;
  aTable.Free;
end;


function TfrxCellularText.GetCellHeight: Extended;
begin
  Result := FCellHeight;
  if Result <= 1 then
    Result := -Font.Height + 10;
end;

function TfrxCellularText.GetCellWidth: Extended;
begin
  Result := FCellWidth;
  if Result = 0 then
    Result := -Font.Height + 10;
end;

class function TfrxCellularText.GetDescription: String;
begin
  Result := frxResources.Get('obCellularText');
end;

procedure TfrxCellularText.SetHeight(Value: Extended);
begin
  if Value < GetCellHeight then Value := GetCellHeight;
  if Value = Height then
    Value := Round(Value / (GetCellHeight + FVertSpacing))*(GetCellHeight + FVertSpacing) - FVertSpacing;
  inherited;
end;

procedure TfrxCellularText.SetWidth(Value: Extended);
begin
  if Value < GetCellWidth then Value := GetCellWidth;
  if Value = Width then
    Value := Round(Value / (GetCellWidth + FHorzSpacing)) * (GetCellWidth + FHorzSpacing) - FHorzSpacing;
  inherited;
end;

procedure TfrxCellularText.WrapText(sLines: TWideStrings; ColumnCount: Integer);
var
  i, Len, LastPos, LastSpace, LastDelimSize: Integer;
  sText: WideString;
  bNewLine: Boolean;
begin
  i := 1;
  sText := Text;
  Len := Length(sText);
  LastPos := i;
  LastSpace := i;
  while (i <= Len) do
  begin
    LastDelimSize := 0;
    bNewLine := (sText[i] = #13);
    if (sText[i] = ' ') or bNewLine then
    begin
      if bNewLine then
      begin
        Inc(i);
        LastDelimSize := 1;
      end;
      LastSpace := i;
    end;
    if (i - LastPos >= ColumnCount) or (i = Len) or bNewLine then
    begin
      if not WordWrap or (LastSpace = LastPos) then
        LastSpace := i;
      sLines.AddObject(Copy(sText, LastPos, LastSpace - LastPos - LastDelimSize), TObject(LastSpace));
      if (sText[LastSpace] = ' ') then
        Inc(LastSpace);
      LastPos := LastSpace + LastDelimSize;
      LastSpace := LastPos;
    end;
    Inc(i);
  end;
end;

initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxCellularText, TControl);
{$ENDIF}
  frxObjects.RegisterObject1(TfrxCellularText, nil, '', '', 0, 82);

finalization
  frxObjects.UnRegister(TfrxCellularText);

end.
