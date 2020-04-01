{******************************************}
{                                          }
{             FastReport v6.0              }
{              Table Object                }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxTableObject;

interface

{$I frx.inc}

uses
  SysUtils, Types, Classes, Graphics, Variants, Controls,
  frxClass;

const
  DefaultRowHeight: Extended = 37.7953 * 0.5;
  DefaultColumnWidth: Extended = 37.7953 * 2;
type
  TfrxTableObject = class;
  TfrxTableRow = class;
  TfrxTableColumn = class;
  TfrxHackView = class(TfrxView);

  TfrxContainerPadding = class(TPersistent)
  private
    FLeftPading: Extended;
    FTopPading: Extended;
    FRightPading: Extended;
    FBottomPading: Extended;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property LeftPading: Extended read FLeftPading write FLeftPading;
    property TopPading: Extended read FTopPading write FTopPading;
    property RightPading: Extended read FRightPading write FRightPading;
    property BottomPading: Extended read FBottomPading write FBottomPading;
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxReportTableObject = class(TComponent)  // fake component
  end;

  TfrxTableCell = class(TfrxCustomMemoView)
  private
    FColSpan: Integer;
    FRowSpan: Integer;
    FHidden: Boolean;
    FContainerPadding: TfrxContainerPadding;
    procedure SetColSpan(Value: Integer);
    procedure SetRowSpan(Value: Integer);
    function CellWidth: Extended;
    function CellHeight: Extended;
    procedure SetContainerPadding(const Value: TfrxContainerPadding);
    function IsPaddingStored: Boolean;
  protected
    FIndex: Integer;
    procedure SetParent(AParent: TfrxComponent); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    function GetRestrictions: TfrxRestrictions; override;
    procedure SetIsSelected(const Value: Boolean); override;
    function IsTopStored: Boolean; override;
    function IsLeftStored: Boolean; override;
    function IsWidthStored: Boolean; override;
    function IsHeightStored: Boolean; override;
    procedure DrawSizeBox(aCanvas: TCanvas; aScale: Extended; bForceDraw: Boolean = False); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterPrint; override;
    procedure BeforePrint; override;
    function CalcHeight: Extended; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure DrawSelected(Color: TColor = clSkyBlue);
    function IsAcceptControl(aControl: TfrxComponent): Boolean; override;
    function IsOwnerDraw: Boolean; override;
    function Diff(AComponent: TfrxComponent): String; override;
    procedure DoMouseMove(X, Y: Integer; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams)
      : Boolean; override;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
    function DoDragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams)
      : Boolean; override;
    procedure GetData; override;
    function GetClientArea: TfrxRect; override;
    function ParentTable: TfrxTableObject;
    function ParentRow: TfrxTableRow;
  published
    property AllowExpressions;
    property AllowHTMLTags;
    property BrushStyle;
    property CharSpacing;
    property Clipped;
    property Color;
    property DataField;
    property DataSet;
    property DataSetName;
    property DisplayFormat;
    property ExpressionDelimiters;
    property Font;
    property Frame;
    property FillType;
    property Fill;
    property FlowTo;
    property GapX;
    property GapY;
    property HAlign;
    property HideZeros;
    property Highlight;
    property LineSpacing;
    property Memo;
    property ParagraphGap;
    property ParentFont;
    property ContainerPadding: TfrxContainerPadding read FContainerPadding write SetContainerPadding stored IsPaddingStored;
    property Rotation;
    property RTLReading;
    property Style;
    property SuppressRepeated;
    property Underlines;
    property UseDefaultCharset;
    property WordBreak;
    property WordWrap;
    property Wysiwyg;
    property VAlign;
    property ColSpan: Integer read FColSpan write SetColSpan default 1;
    property RowSpan: Integer read FRowSpan write SetRowSpan default 1;
  end;

  TfrxTableRowColumnBase = class(TfrxComponent)
  private
    FAutoSize: Boolean;
    procedure SetAutoSize(Value: Boolean);
  protected
    FIndex: Integer;
    procedure SetParent(AParent: TfrxComponent); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    procedure SetIsSelected(const Value: Boolean); override;
    function IsTopStored: Boolean; override;
    function IsLeftStored: Boolean; override;
  public
    destructor Destroy; override;
    function ParentTable: TfrxTableObject;
    procedure DoMouseMove(X, Y: Integer; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams)
      : Boolean; override;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
    property Index: Integer read FIndex;
  published
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
  end;

  TfrxTableColumn = class(TfrxTableRowColumnBase)
  private
    FMinWidth: Extended;
    FMaxWidth: Extended;
  protected
    function IsHeightStored: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
  published
    function IsContain(X, Y: Extended): Boolean; override;
    property Width;
    property MinWidth: Extended read FMinWidth write FMinWidth;
    property MaxWidth: Extended read FMaxWidth write FMaxWidth;
  end;

  TfrxTableRow = class(TfrxTableRowColumnBase)
  private
    FMinHeight: Extended;
    FMaxHeight: Extended;
    function GetCellCount: Integer;
    function GetCell(Index: Integer): TfrxTableCell;
    procedure InitCells(Value: Integer);
    procedure CorrectCellsOnColumnChange(Index, Correct: Integer);
  protected
    procedure SetLeft(Value: Extended); override;
    function IsWidthStored: Boolean; override;
    function CreateTableCell(Index: Integer): TfrxTableCell; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsContain(X, Y: Extended): Boolean; override;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
    property CellCount: Integer read GetCellCount;
    property Cells[Index: Integer]: TfrxTableCell read GetCell;
  published
    property MinHeight: Extended read FMinHeight write FMinHeight;
    property MaxHeight: Extended read FMaxHeight write FMaxHeight;
    property Height;
  end;

  TfrxTableObject = class(TfrxStretcheable)
  private
    FRowCount: Integer;
    FColumnCount: Integer;
    FLockCorrectSpans: Boolean;
    FLockObjectsUpdate: Boolean;
    //FSpanList: array of TRect;
    FDragDropActive: Boolean;
    FColumnSelection: Boolean;
    FRowSelection: Boolean;
    FSelectionStart: TRect;
    FSelectionEnd: TRect;
    FCellsSelection: TRect;
    FModified: Boolean;
    FNewColumnDim: Integer;
    FNewRowDim: Integer;
    FResizeActive: Boolean;
    FBoundsUpdating: Boolean;

    FTableActive: Boolean;

    FSelectorPoint: TPoint;
    FSelectionFill: TfrxCustomFill;
    FSelectedGridCol: Integer;
    FSelectedGridRow: Integer;
    FCopyAppearance: Boolean;

    FVertSplitter: Integer;
    FHorzSplitter: Integer;
    FBreakRowIndex: Integer;

    FLastMousePos: TPoint;
    FBrakeTo: TfrxTableObject;
    FDefaultCellHeight: Extended;
    FDefaultCellWidth: Extended;
    function GetColumn(Index: Integer): TfrxTableColumn;
    function GetRow(Index: Integer): TfrxTableRow;
    function GetCell(X, Y: Integer): TfrxTableCell;
    procedure SetColumnCount(Value: Integer);
    procedure SetRowCount(Value: Integer);
    procedure CorrectSpansOnColumnChange(ColumnIndex, Correct: Integer);
    procedure CorrectSpansOnRowChange(RowIndex, Correct: Integer);
    procedure ResetSpanList;
    procedure DrawTable(Highlighted: Boolean = False);
    procedure CalcWidthInternal;
    procedure CalcHeightInternal;
    procedure NormalizeSpans;
    procedure AssignCellAppearance(FromCell, ToCell: TfrxTableCell);
    procedure UpdateDesigner;
    procedure UpdateCellDimensions(cell: TfrxTableCell);
    function GetTableHeight: Extended;
    function GetTableWidth: Extended;
    procedure SetTableHeight(const Value: Extended);
    procedure SetTableWidth(const Value: Extended);
  protected
    FSelectedRowCol: TfrxTableRowColumnBase;
    FSelectedRowColCount: Integer;
    procedure NormalizeObjectsList;
    procedure FillSpanList(var SpanList: TfrxRectArray);
    function IsInsideSpan(SpanList: TfrxRectArray; p: TPoint): Boolean;
    function IsTableActive: Boolean;
    function CheckColumnSelector(X, Y: Extended): Boolean;
    function CheckRowSelector(X, Y: Extended): Boolean;
    function CheckMoveArrow(X, Y: Extended): Boolean;
    function CheckSizeArrow(X, Y: Extended): Boolean;
    procedure ObjectListNotify(Ptr: Pointer; Action: TListNotification); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    function GetRowColumnByClass(aClass: TClass; Index: Integer): TfrxTableRowColumnBase;
    function IsWidthStored: Boolean; override;
    function IsHeightStored: Boolean; override;
    function CreateTableColumn: TfrxTableColumn; virtual;
    function CreateTableRow: TfrxTableRow; virtual;
    procedure Loaded; override;
    procedure DoMirror(MirrorModes: TfrxMirrorControlModes); override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    destructor Destroy; override;
    procedure AlignChildren(IgnoreInvisible: Boolean = False; MirrorModes: TfrxMirrorControlModes = []); override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    function DrawPart: Extended; override;
    procedure InitPart; override;
    function HasNextDataPart(aFreeSpace: Extended): Boolean; override;
    procedure DoMouseEnter(aPreviousObject: TfrxComponent;
      var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseLeave(aPreviousObject: TfrxComponent;
      var EventParams: TfrxInteractiveEventsParams); override;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams)
      : Boolean; override;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseMove(X, Y: Integer; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
    function IsContain(X, Y: Extended): Boolean; override;
    function IsAcceptAsChild(aParent: TfrxComponent): Boolean; override;
    function GetContainedComponent(X, Y: Extended; IsCanContain: TfrxComponent = nil): TfrxComponent; override;
//    function ContainerAdd(Obj: TfrxComponent): Boolean; override;
    procedure BeforePrint; override;
    procedure AfterPrint; override;
    function CalcHeight: Extended; override;
    { script helpers }
    function CreateNewColumn(Index: Integer): TfrxTableColumn;
    function CreateNewRow(Index: Integer): TfrxTableRow;

    procedure GetData; override;
    class function GetDescription: String; override;
    function ExportInternal(Filter: TfrxCustomExportFilter): Boolean; override;
    function GetSaveToComponent: TfrxReportComponent; override;
    procedure AddColumn(Value: TfrxTableColumn);
    procedure InsertColumn(Index: Integer; Value: TfrxTableColumn);
    procedure MoveColumn(Index, NewIndex: Integer);
    procedure DeleteColumn(Index: Integer);
    procedure AddRow(Value: TfrxTableRow);
    procedure InsertRow(Index: Integer; Value: TfrxTableRow);
    procedure SwapRows(Row1, Row2: Integer);
    procedure DeleteRow(Index: Integer);
    procedure UpdateBounds; override;
    procedure JoinSelection(TopX: Integer = MaxInt; TopY: Integer = MaxInt; BottomX: Integer = -1; BottomY: Integer = -1);
    procedure SplitSelected;
    procedure SplitCell(aCell: TfrxTableCell);
    property Columns[Index: Integer]: TfrxTableColumn read GetColumn;
    property Rows[Index: Integer]: TfrxTableRow read GetRow;
    property Cells[X, Y: Integer]: TfrxTableCell read GetCell;
    property DefaultCellHeight: Extended read FDefaultCellHeight write FDefaultCellHeight;
    property DefaultCellWidth: Extended read FDefaultCellWidth write FDefaultCellWidth;
    property TableHeight: Extended read GetTableHeight write SetTableHeight;
    property TableWidth: Extended read GetTableWidth write SetTableWidth;
  published
    property ColumnCount: Integer read FColumnCount write SetColumnCount stored False;
    property RowCount: Integer read FRowCount write SetRowCount stored False;
  end;



implementation

uses Math, frxGraphicUtils, frxRes, frxUtils, frxTableObjectRTTI,
  frxTableObjectEditor, frxTableObjectClipboard;


{ TfrxTableCell }

constructor TfrxTableCell.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColSpan := 1;
  FRowSpan := 1;
  frComponentStyle := frComponentStyle + [csContained, csAcceptsFrxComponents];
  Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
  LockAnchorsUpdate;
  FContainerPadding := TfrxContainerPadding.Create;
end;

procedure TfrxTableCell.SetColSpan(Value: Integer);
begin
  if Value < 1 then
    Value := 1;
  if not IsLoading then
    Value := Min(ParentTable.ColumnCount, FIndex + Value) - FIndex;

  if FColSpan <> Value then
  begin
    FColSpan := Value;
    if ParentTable <> nil then
      ParentTable.ResetSpanList;
  end;
end;

procedure TfrxTableCell.SetContainerPadding(const Value: TfrxContainerPadding);
begin
  FContainerPadding.Assign(Value);
end;

procedure TfrxTableCell.SetHeight(Value: Extended);
begin
  if Height = 0 then
    LockAnchorsUpdate;
  try
    inherited;
  finally
    LockAnchorsUpdate
  end;
end;

procedure TfrxTableCell.SetIsSelected(const Value: Boolean);
var
  aTable: TfrxTableObject;
begin
  inherited SetIsSelected(Value);
  aTable := ParentTable;
  if aTable <> nil then
    aTable.FTableActive := Value;
end;

procedure TfrxTableCell.SetParent(AParent: TfrxComponent);
begin
  { only row can containt cells}
  if not(AParent is TfrxTableRow) and (AParent <> nil) then Exit;
  inherited;
end;

procedure TfrxTableCell.SetRowSpan(Value: Integer);
begin
  if Value < 1 then
    Value := 1;
  if not IsLoading then
    Value := Min(ParentTable.RowCount, ParentRow.FIndex + Value) - ParentRow.FIndex;

  if FRowSpan <> Value then
  begin
    FRowSpan := Value;
    if ParentTable <> nil then
      ParentTable.ResetSpanList;
  end;
end;

procedure TfrxTableCell.SetWidth(Value: Extended);
begin
  if Width = 0 then
    LockAnchorsUpdate;
  try
    inherited;
  finally
    LockAnchorsUpdate
  end;
end;

function TfrxTableCell.ParentTable: TfrxTableObject;
begin
  if ParentRow = nil then
    Result := nil
  else
    Result := ParentRow.ParentTable;
end;

function TfrxTableCell.ParentRow: TfrxTableRow;
begin
  Result := Parent as TfrxTableRow;
end;

procedure TfrxTableCell.AfterPrint;
var
  aReport: TfrxReport;
begin
  inherited;
  aReport := Report;
  if Assigned(aReport) and (Objects.Count > 0) then
    aReport.Engine.Unstretch(Self);
end;

procedure TfrxTableCell.BeforePrint;
var
  i: Integer;
  aReport: TfrxReport;
begin
  inherited;
  aReport := Report;
  if (ParentRow <> nil) and not(ParentRow.AutoSize) then
  begin
    for i := 0 to Objects.Count - 1 do
    begin
      TfrxView(Objects[i]).BeforePrint;
      if Assigned(aReport) then
        aReport.DoBeforePrint(TfrxView(Objects[i]));
    end;
  end;
end;

function TfrxTableCell.CalcHeight: Extended;
var
  aReport: TfrxReport;
  SaveH: Extended;
begin
  SaveH := Height;
  Result := Inherited CalcHeight;
  aReport := Report;
  if Assigned(aReport) then
    aReport.Engine.Stretch(Self);

  if Height > Result then
    Result := Height;
  Height := SaveH;
end;

function TfrxTableCell.CellHeight: Extended;
var
  i, y: Integer;
begin
  Result := 0;
  y := ParentRow.Index;
  for i := y to y + RowSpan - 1 do
    Result := Result + ParentTable.Rows[i].Height;
end;

function TfrxTableCell.CellWidth: Extended;
var
  i, x: Integer;
begin
  Result := 0;
  x := FIndex;
  for i := x to x + ColSpan - 1 do
    Result := Result + ParentTable.Columns[i].Width;
end;

destructor TfrxTableCell.Destroy;
begin
  FreeAndNil(FContainerPadding);
  inherited;
end;

function TfrxTableCell.Diff(AComponent: TfrxComponent): String;
var
  c: TfrxTableCell;
begin
  Result := inherited Diff(AComponent);
  c := TfrxTableCell(AComponent);
  if FRowSpan <> c.FRowSpan then
    Result := Result + ' RowSpan="' + IntToStr(FRowSpan) + '"';
  if FColSpan <> c.FColSpan then
    Result := Result + ' ColSpan="' + IntToStr(FColSpan) + '"';
  if frxFloatDiff(FContainerPadding.LeftPading, c.ContainerPadding.LeftPading) then
    Result := Result + ' ContainerPadding.LeftPading="' + FloatToStr(FContainerPadding.LeftPading) + '"';
  if frxFloatDiff(FContainerPadding.RightPading, c.ContainerPadding.RightPading) then
    Result := Result + ' ContainerPadding.RightPading="' + FloatToStr(FContainerPadding.RightPading) + '"';
  if frxFloatDiff(FContainerPadding.TopPading, c.ContainerPadding.TopPading) then
    Result := Result + ' ContainerPadding.TopPading="' + FloatToStr(FContainerPadding.TopPading) + '"';
  if frxFloatDiff(FContainerPadding.BottomPading, c.ContainerPadding.BottomPading) then
    Result := Result + ' ContainerPadding.BottomPading="' + FloatToStr(FContainerPadding.BottomPading) + '"';
end;

function TfrxTableCell.DoDragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  aTable: TfrxTableObject;
begin
  Result := False;
  aTable := ParentTable;
  if aTable <> nil then
    aTable.FDragDropActive := True;
end;

function TfrxTableCell.DoMouseDown(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  aTable: TfrxTableObject;
  C: TfrxComponent;
begin
  Result := inherited DoMouseDown(X, Y, Button, Shift, EventParams);
  aTable := ParentTable;
  if aTable <> nil then
  begin
    Result := aTable.DoMouseDown(X, Y, Button, Shift, EventParams);
    if not Result and Assigned(EventParams.SelectionList) and (Button = mbLeft){ and (EventParams.EventSender = esDesigner)} then
    begin

      aTable.FSelectionStart.Left := FIndex;
      aTable.FSelectionStart.Top := ParentRow.FIndex;
      aTable.FSelectionStart.Right := FIndex + ColSpan - 1;
      aTable.FSelectionStart.Bottom := ParentRow.FIndex + RowSpan - 1;
      c := GetContainedComponent(X / FScaleX, Y / FScaleY);
      if c is TfrxTableCell then
        //if not c.IsSelected then
        begin
          EventParams.SelectionList.Clear;
          EventParams.SelectionList.Add(c);
        end;
      EventParams.Refresh := True;
      Result := True;
    end;
  end;
end;

procedure TfrxTableCell.DoMouseMove(X, Y: Integer; Shift: TShiftState;
  var EventParams: TfrxInteractiveEventsParams);
var
  aTable: TfrxTableObject;
begin
  inherited;
  aTable := ParentTable;
  if aTable <> nil then
      aTable.DoMouseMove(X, Y, Shift, EventParams);
end;

procedure TfrxTableCell.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  aTable: TfrxTableObject;
begin
  inherited;
  aTable := ParentTable;
  if aTable <> nil then
    aTable.DoMouseUp(X, Y, Button, Shift, EventParams);
end;

procedure TfrxTableCell.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  // handle draw in the Table object
  if Assigned(FVC) or FObjAsMetafile then
  begin
    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    DrawText;
  end;
end;


procedure TfrxTableCell.DrawSelected(Color: TColor = clSkyBlue);
begin
  TransparentFillRect(FCanvas.Handle, FX + 1, FY + 1, FX1 - 1, FY1 - 1, Color);
//  ParentTable.FSelectionFill.Draw(FCanvas, FX, FY, FX1, FY1, FScaleX, FScaleY);
end;

procedure TfrxTableCell.DrawSizeBox(aCanvas: TCanvas; aScale: Extended;
  bForceDraw: Boolean);
begin
  // nothing
end;

function TfrxTableCell.GetClientArea: TfrxRect;
begin
  Result := frxRect(FContainerPadding.FLeftPading, FContainerPadding.TopPading, Width - FContainerPadding.RightPading - FContainerPadding.FLeftPading, Height - FContainerPadding.BottomPading - FContainerPadding.TopPading);
end;

procedure TfrxTableCell.GetData;
var
  i: Integer;
  aReport: TfrxReport;
  View: TfrxView;
begin
  inherited;
  aReport := Report;
  if (ParentTable.StretchMode <> smDontStretch) and ParentRow.AutoSize then Exit;
  for i := 0 to Objects.Count -1 do
    if TObject(Objects[i]) is TfrxView then
    begin
      View := TfrxView(Objects[i]);
      if View.Processing.ProcessAt = paDefault then
      begin
        View.GetData;
        if Assigned(aReport) then
          aReport.DoNotifyEvent(View, View.OnAfterData);
      end;
    end;
end;

function TfrxTableCell.GetRestrictions: TfrxRestrictions;
begin
  Result := Inherited GetRestrictions + [rfDontDelete];
end;

function TfrxTableCell.IsAcceptControl(aControl: TfrxComponent): Boolean;
begin
  Result := Inherited IsAcceptControl(aControl);
  if aControl <> nil then
    Result := Result and aControl.IsAcceptAsChild(Self);
end;

function TfrxTableCell.IsHeightStored: Boolean;
begin
  Result := False;
end;

function TfrxTableCell.IsLeftStored: Boolean;
begin
  Result := False;
end;

function TfrxTableCell.IsOwnerDraw: Boolean;
begin
  Result := True;
end;

function TfrxTableCell.IsPaddingStored: Boolean;
begin
  Result := (FContainerPadding.FLeftPading <> 0) or
    (FContainerPadding.FTopPading <> 0) or (FContainerPadding.FRightPading <> 0)
    or (FContainerPadding.FBottomPading <> 0);
end;

function TfrxTableCell.IsTopStored: Boolean;
begin
  Result := False;
end;

function TfrxTableCell.IsWidthStored: Boolean;
begin
  Result := False;
end;

{ TfrxTableRowColumnBase }

procedure TfrxTableRowColumnBase.SetParent(AParent: TfrxComponent);
var
//  OldParent: TfrxComponent;
  i: Integer;
begin
  { only table can containt column/rows}
  if not(AParent is TfrxTableObject) and (AParent <> nil) then Exit;
  if FParent <> AParent then
  begin
    if FParent <> nil then
      FParent.Objects.Remove(Self);
    if AParent <> nil then
    begin
      if (AParent.Objects.Count = 0) or (Self is TfrxTableRow) then
        AParent.Objects.Add(Self)
      else if Self is TfrxTableColumn then
        for i := 0 to AParent.Objects.Count - 1 do
          if not(TObject(AParent.Objects[i]) is TfrxTableColumn) then
          begin
            AParent.Objects.Insert(i, Self);
            break;
          end
          else if i = AParent.Objects.Count - 1  then
            AParent.Objects.Add(Self);
    end;
  end;
  FParent := AParent;
  if FParent <> nil then
    SetParentFont(ParentFont);
{
  OldParent := Parent;
  inherited SetParent(AParent);
  if Parent <> OldParent then
  begin
    if OldParent <> nil then
      (OldParent as TfrxTableObject).NormalizeObjectsList;
    if Parent <> nil then
      (Parent as TfrxTableObject).NormalizeObjectsList;
  end;}
end;

procedure TfrxTableRowColumnBase.SetWidth(Value: Extended);
begin
  if Value < 0 then Exit;
  inherited;
end;

procedure TfrxTableRowColumnBase.SetAutoSize(Value: Boolean);
begin
  FAutoSize := Value;
end;

procedure TfrxTableRowColumnBase.SetHeight(Value: Extended);
begin
  if Value < 0 then Exit;
  inherited;
end;

procedure TfrxTableRowColumnBase.SetIsSelected(const Value: Boolean);
var
  aTable: TfrxTableObject;
begin
  inherited SetIsSelected(Value);
  aTable := ParentTable;
  if aTable <> nil then
    aTable.FTableActive := Value;
end;


destructor TfrxTableRowColumnBase.Destroy;
var
  aTable: TfrxTableObject;
begin
  aTable := ParentTable;
  if aTable <> nil then
  begin
    aTable.FSelectedRowCol := nil;
    aTable.FSelectedRowColCount := 0;
    aTable.FSelectionStart := Rect(-1, -1, -1, -1);
    aTable.FSelectionEnd := Rect(-1, -1, -1, -1);
    aTable.FCellsSelection := Rect(-1, -1, -1, -1);
  end;
  inherited;
end;

function TfrxTableRowColumnBase.DoMouseDown(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  aTable: TfrxTableObject;
begin
  Result := False;
  if ssRight in Shift then Exit;
  aTable := ParentTable;
  if aTable <> nil then
  begin
    aTable.FSelectedRowCol := Self;
    aTable.FSelectedRowColCount := 0;
  end;
  EventParams.SelectionList.Clear;
  EventParams.SelectionList.Add(Self);
  Result := True;
end;

procedure TfrxTableRowColumnBase.DoMouseMove(X, Y: Integer; Shift: TShiftState;
  var EventParams: TfrxInteractiveEventsParams);
var
  aTable: TfrxTableObject;
  i: Integer;
  FoundColumn: TfrxTableRowColumnBase;
begin
  inherited;
  aTable := ParentTable;
//  if IsSelected then
//    aTable.FSelectedRowCol := Self;


  if aTable <> nil then
  begin
    if not(ssCtrl in Shift) then
    begin
      FoundColumn := nil;
      if aTable.FSelectedRowCol is TfrxTableColumn then
        for i := 0 to aTable.ColumnCount - 1 do
          if aTable.Columns[i].IsContain(X / aTable.FScaleX, Y / aTable.FScaleY)
          then
          begin
            FoundColumn := aTable.Columns[i];
            break;
          end;
      if aTable.FSelectedRowCol is TfrxTableRow then
        for i := 0 to aTable.RowCount - 1 do
          if aTable.Rows[i].IsContain(X / aTable.FScaleX, Y / aTable.FScaleY)
          then
          begin
            FoundColumn := aTable.Rows[i];
            break;
          end;
      if (aTable.FSelectedRowCol <> nil) and (FoundColumn <> nil) and
        (aTable.FSelectedRowCol <> FoundColumn) then
        aTable.FSelectedRowColCount := FoundColumn.
          Index - aTable.FSelectedRowCol.Index
      else
        aTable.FSelectedRowColCount := 0;
    end;
    aTable.DoMouseMove(X, Y, Shift, EventParams);
  end;
end;

procedure TfrxTableRowColumnBase.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  aTable: TfrxTableObject;
  TSelection, i: Integer;
begin
  aTable := ParentTable;
  if aTable = nil then Exit;
  TSelection := aTable.FSelectedRowColCount;
  if (TSelection <> 0) and (aTable.FSelectedRowCol.ClassType = Self.ClassType) then
  begin
    i := aTable.FSelectedRowCol.Index;
    while TSelection <> 0 do
    begin
      EventParams.SelectionList.Add(aTable.GetRowColumnByClass(aTable.FSelectedRowCol.ClassType, i + TSelection));
      if TSelection > 0 then
        Dec(TSelection)
      else
        Inc(TSelection);
    end;
  end;
  aTable.FSelectedRowCol := nil;
  aTable.FSelectedRowColCount := 0;
end;

function TfrxTableRowColumnBase.IsLeftStored: Boolean;
begin
  Result := False;
end;

function TfrxTableRowColumnBase.IsTopStored: Boolean;
begin
  Result := False;
end;

function TfrxTableRowColumnBase.ParentTable: TfrxTableObject;
begin
  Result := Parent as TfrxTableObject;
end;


{ TfrxTableColumn }

constructor TfrxTableColumn.Create(AOwner: TComponent);
var
  t: TfrxTableObject;
begin
  inherited;
  t := ParentTable;
  if Assigned(t) then
    Width := t.FDefaultCellWidth
  else
    Width := DefaultColumnWidth;
  frComponentStyle := frComponentStyle + [csContained];
  FMinWidth := 0;
  FMaxWidth := 2 * fr1cm;
end;


destructor TfrxTableColumn.Destroy;
var
  t: TfrxTableObject;
begin
  t := ParentTable;
  if Assigned(t) then
  begin
    t.CorrectSpansOnColumnChange(Index, -1);
    t.UpdateDesigner;
  end;
  inherited;
end;

procedure TfrxTableColumn.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  aTable: TfrxTableObject;
  Selected, TableSelection: TfrxTableRowColumnBase;
  i, TSelection: Integer;
begin
  aTable := ParentTable;
  Selected := nil;
  if (aTable = nil) then Exit;
  TableSelection := aTable.FSelectedRowCol;
  TSelection := aTable.FSelectedRowColCount;
  inherited;
  if not(TableSelection is TfrxTableColumn) or (TSelection <> 0) then Exit;
  for i := 0 to aTable.ColumnCount - 1 do
    if aTable.Columns[i].IsContain(X / EventParams.Scale, Y / EventParams.Scale) then
      Selected := aTable.Columns[i];
  if (Selected <> nil) and (TableSelection <> Selected) then
  begin
    aTable.MoveColumn(aTable.Objects.IndexOf(Selected), aTable.Objects.IndexOf(TableSelection));
    EventParams.Modified := True;
  end;
end;


function TfrxTableColumn.IsContain(X, Y: Extended): Boolean;
var
  Table: TfrxTableObject;
begin
  Result := inherited IsContain(X, Y);
  Table := ParentTable;
  if (Table <> nil) and (Table.IsDesigning) then
    Result := Result or (AbsLeft <= X) and (AbsLeft + Width >= X) and (AbsTop - 20 <= Y) and (AbsTop + 2 >= Y);
end;

function TfrxTableColumn.IsHeightStored: Boolean;
begin
  Result := False;
end;

{ TfrxTableRow }

constructor TfrxTableRow.Create(AOwner: TComponent);
var
  t: TfrxTableObject;
begin
  inherited;
  t := ParentTable;
  if Assigned(t) then
    Height := t.FDefaultCellHeight
  else
    Height := DefaultRowHeight;
  frComponentStyle := frComponentStyle + [csContained];
  FMinHeight := 0;
  FMaxHeight := 0;
end;

function TfrxTableRow.CreateTableCell(Index: Integer): TfrxTableCell;
begin
  Result := TfrxTableCell.Create(Self);
  Result.FIndex := Index;
  Result.CreateUniqueName;
end;

destructor TfrxTableRow.Destroy;
var
  t: TfrxTableObject;
//  aReport: TfrxReport;
begin
  t := ParentTable;
  if Assigned(t) then
  begin
    t.CorrectSpansOnRowChange(Index, -1);
//    aReport := t.Report;
//    if t.IsDesigning and (aReport <> nil) and (aReport.Designer <> nil) and not t.FLockObjectsUpdate then
//      aReport.Designer.ReloadObjects(True);
  end;
  inherited;
end;

procedure TfrxTableRow.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  aTable: TfrxTableObject;
  Selected, TableSelection: TfrxTableRowColumnBase;
  i, TSelection: Integer;
begin
  aTable := ParentTable;
  Selected := nil;
  if aTable = nil then Exit;
  TSelection := aTable.FSelectedRowColCount;
  TableSelection := aTable.FSelectedRowCol;
  Inherited;
  if not(TableSelection is TfrxTableRow) or (TSelection <> 0) then Exit;
  for i := 0 to aTable.RowCount - 1 do
    if aTable.Rows[i].IsContain(X / EventParams.Scale, Y / EventParams.Scale) then
      Selected := aTable.Rows[i];
  if (Selected <> nil) and (TableSelection <> Selected) then
  begin
    aTable.InsertRow(Selected.FIndex, TfrxTableRow(TableSelection));
    EventParams.Modified := True;
  end;
end;


function TfrxTableRow.GetCellCount: Integer;
begin
  Result := Objects.Count;
end;

function TfrxTableRow.GetCell(Index: Integer): TfrxTableCell;
begin
  if (Index < 0) or (Index > CellCount - 1) then
    Result := nil
  else
  begin
    Result := TfrxTableCell(Objects[Index]);
    Result.FIndex := Index;
  end;
end;

procedure TfrxTableRow.InitCells(Value: Integer);
var
  i, n: Integer;
begin
  n := Value - CellCount;
  for i := 0 to n - 1 do
    CreateTableCell(i);

  while Value < CellCount do
    Cells[CellCount - 1].Free;
end;

function TfrxTableRow.IsContain(X, Y: Extended): Boolean;
var
  Table: TfrxTableObject;
begin
  Result := inherited IsContain(X, Y);
  Table := ParentTable;
  if (Table <> nil) and (Table.IsDesigning) then
    Result := Result or (AbsTop <= Y) and (AbsTop + Height >= Y) and (AbsLeft - 20 <= X) and (AbsLeft + 2 >= X);
end;


function TfrxTableRow.IsWidthStored: Boolean;
begin
  Result := False;
end;

procedure TfrxTableRow.SetLeft(Value: Extended);
begin
  //calculated by table
  inherited SetLeft(0);
end;

procedure TfrxTableRow.CorrectCellsOnColumnChange(Index, Correct: Integer);
begin
  if Index < 0 then
    Exit;

  if Correct >= 1 then
  begin
    CreateTableCell(Index);
    Objects.Move(CellCount - 1, Index);
  end
  else
  begin
    Cells[Index].Free;
  end;
end;


{ TfrxTableObject }

constructor TfrxTableObject.Create(AOwner: TComponent);
begin
  inherited;
  FDefaultCellHeight := DefaultRowHeight;
  FDefaultCellWidth := DefaultColumnWidth;
  FSelectionFill := TfrxBrushFill.Create;
  with TfrxBrushFill(FSelectionFill) do
  begin
    Style := bsFDiagonal;
    BackColor := clNone;
    ForeColor := clNavy;
  end;
  //FSpanList := nil;
  FLockObjectsUpdate := False;
  frComponentStyle := frComponentStyle + [csObjectsContainer];// + [csContainer, csAcceptsFrxComponents];
  FSelectedGridCol := -1;
  FSelectedGridRow := -1;
  FVertSplitter := -1;
  FHorzSplitter := -1;
  FSelectionStart := Rect(-1, -1, -1, -1);
  FSelectionEnd := Rect(-1, -1, -1, -1);
  FCellsSelection := Rect(-1, -1, -1, -1);
end;

function TfrxTableObject.CreateNewColumn(Index: Integer): TfrxTableColumn;
begin
  Result := CreateTableColumn;
  InsertColumn(Index, Result);
end;

function TfrxTableObject.CreateNewRow(Index: Integer): TfrxTableRow;
begin
  Result := CreateTableRow;
  InsertRow(Index, Result);
end;

function TfrxTableObject.CreateTableColumn: TfrxTableColumn;
begin
  Result := TfrxTableColumn.Create(Self);
  Result.CreateUniqueName;
end;

function TfrxTableObject.CreateTableRow: TfrxTableRow;
begin
  Result := TfrxTableRow.Create(nil);
  Result.CreateUniqueName(Report);
end;

constructor TfrxTableObject.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  inherited;
  FBoundsUpdating := True;
  FLockObjectsUpdate := True;
  frComponentStyle := frComponentStyle;// + [csContainer, csAcceptsFrxComponents];
  ColumnCount := 5;
  RowCount := 5;
  FLockObjectsUpdate := False;
  UpdateDesigner;
end;

destructor TfrxTableObject.Destroy;
begin
  FLockObjectsUpdate := True;
  FLockCorrectSpans := True;
  if FSelectionFill <> nil then
    FreeAndNil(FSelectionFill);
  inherited;
  FLockCorrectSpans := False;
  FLockObjectsUpdate := False;
end;

procedure TfrxTableObject.DoMirror(MirrorModes: TfrxMirrorControlModes);
var
  x: Integer;
begin
  //inherited;
  if (mcmOnlySelected in MirrorModes) and not IsSelected then Exit;
  MirrorContent(MirrorModes);
  if (mcmRTLObjects in MirrorModes) then
    for X := 0 to ColumnCount - 1 do
      if (ColumnCount div 2 > X) then
        MoveColumn(X, ColumnCount - 1 - X);
end;

function TfrxTableObject.DoMouseDown(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i: Integer;
  cSize: Extended;
begin
  Result := inherited DoMouseDown(X, Y, Button, Shift, EventParams);
  if (Button = mbRight) or (not IsTableActive) then Exit;
  FLastMousePos := Point(X, Y);
  if EventParams.EventSender = esPreview then Exit;
  if CheckSizeArrow(X / FScaleX, Y / FScaleY) then
  begin
    FNewColumnDim := 0;
    FNewRowDim := 0;
    FResizeActive := True;
    Result := True;
    EventParams.Refresh := True;
  end;

  if CheckMoveArrow(X / FScaleX, Y / FScaleY) then Exit;
  if CheckRowSelector(X / FScaleX, Y / FScaleY) then
    for i := 0 to RowCount - 1 do
      if Rows[i].IsContain((X + 21) / FScaleX, Y / FScaleY) then
      begin
        EventParams.Refresh := True;
        Result := True;
        Exit;
      end;
  if CheckColumnSelector(X / FScaleX, Y / FScaleY) then
    for i := 0 to ColumnCount - 1 do
      if Columns[i].IsContain(X / FScaleX, (Y + 21) / FScaleY) then
      begin
        EventParams.Refresh := True;
        Result := True;
        Exit;
      end;
  FSelectedGridCol := -1;
  cSize := AbsLeft;
  for i := 0 to ColumnCount - 1 do
  begin
    cSize := cSize + Columns[i].Width;
    if (Abs(cSize - X / FScaleX) < 2) and (Y / FScaleY >= AbsTop) and
      (Y / FScaleY <= AbsTop + Height) then
    begin
      Result := True;
      FSelectedGridCol := i;
      break;
    end;
  end;
  FSelectedGridRow := -1;
  cSize := AbsTop;
  for i := 0 to RowCount - 1 do
  begin
    cSize := cSize + Rows[i].Height;
    if (Abs(cSize - Y / FScaleY) < 2) and (X / FScaleX >= AbsLeft) and
      (X / FScaleX <= AbsLeft + Width) then
    begin
      Result := True;
      FSelectedGridRow := i;
      break;
    end;
  end;
end;

procedure TfrxTableObject.DoMouseEnter(aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  FCellsSelection := Rect(-1, -1, -1, -1);
  if EventParams.EventSender = esPreview then Exit;
  EventParams.Refresh := True;
  FSelectedGridCol := -1;
  FSelectedGridRow := -1;
end;

procedure TfrxTableObject.DoMouseLeave(aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  EventParams.Refresh := (FSelectionStart.Top > -1) and (EventParams.EventSender = esPreview);
  FSelectionStart := Rect(-1, -1, -1, -1);
  FSelectionEnd := Rect(-1, -1, -1, -1);
  FCellsSelection := Rect(-1, -1, -1, -1);
  if EventParams.EventSender = esPreview then
  begin
    Exit;
  end;
  EventParams.Refresh := (FHorzSplitter <> -1) or (FVertSplitter <> -1) or FDragDropActive;
  FVertSplitter := -1;
  FHorzSplitter := -1;
  if FDragDropActive then
  begin
    FDragDropActive := False;
    FSelectedRowCol := nil;
    FSelectedRowColCount := 0;
  end;

end;

procedure TfrxTableObject.DoMouseMove(X, Y: Integer;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  i: Integer;
  cSize: Extended;
  c: TfrxComponent;
  kx, ky: Extended;


  { TODO Move to base class}
  function CheckMove: Boolean;
  var
    al: Boolean;
    function GridCheck: Boolean;
    begin
      Result := (kx >= EventParams.GridX) or (kx <= -EventParams.GridX) or
              (ky >= EventParams.GridY) or (ky <= -EventParams.GridY);
    end;
  begin
    al := EventParams.GridAlign;
    if ssAlt in Shift then
      al := not al;

    Result := False;

    if (al and not GridCheck) or ((kx = 0) and (ky = 0)) then
      Result := True;
    //CheckGuides(kx, ky, Result);
  end;

begin
  inherited;
  FSelectorPoint := Point(X, Y);
  if FSelectionStart.Left <> -1 then
  begin
    c := GetContainedComponent(X / FScaleX, Y / FScaleY);
    if c is TfrxTableCell then
      if not c.IsSelected then
      begin
        FSelectionEnd.Left := TfrxTableCell(c).FIndex;
        FSelectionEnd.Top := TfrxTableCell(c).ParentRow.FIndex;
        FSelectionEnd.Right := FSelectionEnd.Left + TfrxTableCell(c)
          .ColSpan - 1;
        FSelectionEnd.Bottom := FSelectionEnd.Top + TfrxTableCell(c)
          .RowSpan - 1;

        FCellsSelection.Left := FSelectionStart.Left;
        FCellsSelection.Top := FSelectionStart.Top;
        FCellsSelection.Right := FSelectionStart.Right;
        FCellsSelection.Bottom := FSelectionStart.Bottom;

        if FCellsSelection.Left > FSelectionEnd.Left then
          FCellsSelection.Left := FSelectionEnd.Left;
        if FCellsSelection.Top > FSelectionEnd.Top then
          FCellsSelection.Top := FSelectionEnd.Top;

        if FCellsSelection.Right < FSelectionEnd.Right then
          FCellsSelection.Right := FSelectionEnd.Right;
        if FCellsSelection.Bottom < FSelectionEnd.Bottom then
          FCellsSelection.Bottom := FSelectionEnd.Bottom;
      end
      else
        FSelectionEnd := Rect(-1, -1, -1, -1);
    EventParams.Refresh := True;
    Exit;
  end;
  if (EventParams.EventSender = esPreview) or (not IsTableActive) then Exit;

  FColumnSelection := CheckColumnSelector(X / FScaleX, Y / FScaleY) and not CheckMoveArrow(X / FScaleX, Y / FScaleY);
  FRowSelection := CheckRowSelector(X / FScaleX, Y / FScaleY);


  EventParams.Refresh := (FColumnSelection or FRowSelection);
  EventParams.Refresh := EventParams.Refresh or (FHorzSplitter <> -1) or (FVertSplitter <> -1);

  EventParams.Refresh := EventParams.Refresh or (FSelectedGridRow <> -1) or (FSelectedGridCol <> -1);
  cSize := AbsLeft;
  FHorzSplitter := -1;
  if (X > (FX1 + (FDefaultCellWidth * FscaleX))) and FResizeActive then
    FNewColumnDim := Abs(Round((FX1 - X) / (FDefaultCellWidth * FscaleX)));

  for i := 0 to ColumnCount - 1 do
  begin
    cSize := cSize + Columns[i].Width;
    if Columns[i].IsContain(X / FScaleX, AbsTop) and FResizeActive then
      FNewColumnDim := i -(ColumnCount - 1);
    if (Abs(cSize - X / FScaleX) < 2) and (Y / FScaleY >= AbsTop) and
      (Y / FScaleY <= AbsTop + Height) then
    begin
      TWinControl(EventParams.Sender).Cursor := crHSplit;
      FHorzSplitter := i;
      break;
    end;
  end;

  FVertSplitter := -1;
  if (Y > (FY1 + (FDefaultCellHeight * FScaleY))) and FResizeActive then
    FNewRowDim := Abs(Round((FY1 - Y) / (FDefaultCellHeight * FScaleY)));
  cSize := AbsTop;
  for i := 0 to RowCount - 1 do
    begin
      cSize := cSize + Rows[i].Height;
      if Rows[i].IsContain(AbsLeft, Y / FScaleY) and FResizeActive then
        FNewRowDim := i -(RowCount - 1);
      if (Abs(cSize - Y / FScaleY) < 2) and (X / FScaleX >= AbsLeft) and
        (X / FScaleX <= AbsLeft + Width) then
      begin
        TWinControl(EventParams.Sender).Cursor := crVSplit;
        FVertSplitter := i;
        break;
      end;
    end;
  if (FVertSplitter <> -1) and (FHorzSplitter <> -1) then
    TWinControl(EventParams.Sender).Cursor := crSizeNWSE;

  EventParams.Refresh := EventParams.Refresh or (FHorzSplitter <> -1) or (FVertSplitter <> -1) or (FNewColumnDim <> 0)or (FNewRowDim <> 0);
  if (FSelectedGridRow <> -1) or (FSelectedGridCol <> -1) then
  begin
    kx := (X - FLastMousePos.X) / FScaleX;
    ky := (Y - FLastMousePos.Y) / FScaleY;
    if CheckMove then
      Exit;

    if FSelectedGridCol <> -1 then
    begin
      Columns[FSelectedGridCol].Width := Columns[FSelectedGridCol].Width +
        kx;
      FModified := (X <> FLastMousePos.X);
    end;

    if FSelectedGridRow <> -1 then
    begin
      Rows[FSelectedGridRow].Height := Rows[FSelectedGridRow].Height +
        ky;
      FModified := (X <> FLastMousePos.X);
    end;

    FLastMousePos := Point(X, Y);
  end;
end;

procedure TfrxTableObject.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  cx, ry: Integer;
  c: TfrxTableCell;
begin
  inherited;
  if Assigned(EventParams.SelectionList) and (FSelectionStart.Left <> -1) and (FSelectionEnd.Left <> -1) then
  begin
    EventParams.SelectionList.Clear;
    for cx := FCellsSelection.Left to FCellsSelection.Right do
      for ry := FCellsSelection.Top to FCellsSelection.Bottom do
      begin
        c := Cells[cx, ry];
        if not c.IsSelected and Assigned(EventParams.SelectionList) then
        begin
          EventParams.SelectionList.Add(c);
        end;
      end;
  end;
  FSelectionStart := Rect(-1, -1, -1, -1);
  FSelectionEnd := Rect(-1, -1, -1, -1);
  FCellsSelection := Rect(-1, -1, -1, -1);
  if EventParams.EventSender = esPreview then Exit;
  EventParams.Modified := (((FSelectedGridRow <> -1) or (FSelectedGridCol <> -1)) and FModified);
  FSelectedGridCol := -1;
  FSelectedGridRow := -1;
  FModified := False;
  FSelectedRowCol := nil;
  FSelectedRowColCount := 0;

  if FResizeActive and ((FNewRowDim <> 0) or (FNewColumnDim <> 0)) then
  begin
    FCopyAppearance := True;
    FLockObjectsUpdate := True;
    try
      RowCount := RowCount + FNewRowDim;
      ColumnCount := ColumnCount + FNewColumnDim;
    finally
      FCopyAppearance := False;
      FLockObjectsUpdate := False;
      UpdateDesigner;
    end;
    EventParams.Modified := True;
  end;

  FNewColumnDim := 0;
  FNewRowDim := 0;
  FResizeActive := False;
end;

procedure TfrxTableObject.NormalizeObjectsList;
var
  i: Integer;
  cl, rl: TList;
begin
  // This method is called every time when a row/column is added, or removed from the table
  // Columns and rows are in the objects list. Newly added items are at the end of a list, so we
  // need to sort the list so it will contain columns, then rows
  cl := TList.Create;
  rl := TList.Create;
  try
    for i := 0 to Objects.Count - 1 do
    begin
      if TfrxComponent(Objects[i]) is TfrxTableColumn then
        cl.Add(Objects[i])
      else if TfrxComponent(Objects[i]) is TfrxTableRow then
        rl.Add(Objects[i]);
    end;

    Objects.Clear;
    for i := 0 to cl.Count - 1 do
      Objects.Add(cl[i]);
    for i := 0 to rl.Count - 1 do
      Objects.Add(rl[i]);

    // Update FColumnCount, FRowCount
    FColumnCount := cl.Count;
    FRowCount := rl.Count;
  finally
    cl.Free;
    rl.Free;
  end;
end;

function TfrxTableObject.GetColumn(Index: Integer): TfrxTableColumn;
begin
  if (Index < 0) or (Index > ColumnCount - 1) then
    Result := nil
  else
  begin
    Result := TfrxTableColumn(Objects[Index]);
    Result.FIndex := Index;
  end;
end;

function TfrxTableObject.GetContainedComponent(X, Y: Extended;
  IsCanContain: TfrxComponent): TfrxComponent;
var
  i: Integer;
  c: TfrxComponent;
begin
  // do not use default TfrxComponent method here
  // for table we have to check from the first row, because of RowSpan
  Result := nil;
  if IsContain(X, Y){ or (RowCount > 0) }then
  begin
    if (RowCount = 0) or IsContain(X, Y) then
      Result := Self;
    if not(CheckMoveArrow(X, Y) or CheckSizeArrow(X, Y)) or Assigned(IsCanContain) then
    begin
      for i := 0 to ColumnCount - 1 do
      begin
        c := Columns[i].GetContainedComponent(X, Y, IsCanContain);
        if (c <> nil) then
        begin
          Result := c;
          break;
        end;
      end;

      for i := 0 to RowCount - 1 do
      begin
        c := Rows[i].GetContainedComponent(X, Y, IsCanContain);
        if (c <> nil) then
        begin
          Result := c;
          break;
        end;
      end;
    end;
  end;
  if (Result = Self) and ((IsCanContain = Self) or
    (not IsAcceptControl(IsCanContain))) then
    Result := nil;
end;

function TfrxTableObject.GetRow(Index: Integer): TfrxTableRow;
begin
  if (Index < 0) or (Index > RowCount - 1) then
    Result := nil
  else
  begin
    Result := TfrxTableRow(Objects[ColumnCount + Index]);
    Result.FIndex := Index;
  end;
end;

function TfrxTableObject.GetRowColumnByClass(aClass: TClass;
  Index: Integer): TfrxTableRowColumnBase;
begin
  Result := nil;
  if aClass = TfrxTableRow then
    Result := Rows[Index];
  if aClass = TfrxTableColumn then
    Result := Columns[Index];
end;

function TfrxTableObject.GetSaveToComponent: TfrxReportComponent;
begin
  if Assigned(FBrakeTo) then
    Result := FBrakeTo
  else
    Result := Inherited GetSaveToComponent;
end;

function TfrxTableObject.GetTableHeight: Extended;
begin
  Result := Height;
end;

function TfrxTableObject.GetTableWidth: Extended;
begin
  Result := Width;
end;

function TfrxTableObject.HasNextDataPart(aFreeSpace: Extended): Boolean;
begin
  Result := Inherited HasNextDataPart(aFreeSpace);
  if FBreakRowIndex = FRowCount then
    Result := False;
//  if Assigned(FBrakeTo) then
//  begin
//    Result := Result and (FBrakeTo.RowCount > 0);
//    if not Result then
//      FreeAndNil(FBrakeTo);
//  end;
end;

function TfrxTableObject.GetCell(X, Y: Integer): TfrxTableCell;
var
  R: TfrxTableRow;
begin
  Result := nil;
  R := Rows[Y];
  if R <> nil then
    Result := R.Cells[X];
end;

procedure TfrxTableObject.SetColumnCount(Value: Integer);
var
  i, j, n, x, y: Integer;
  cc: TfrxTableCell;
begin
  FLockObjectsUpdate := True;
  FLockCorrectSpans := True;
  try
    n := Value - ColumnCount;
    for i := 0 to n - 1 do
    begin
      AddColumn(CreateTableColumn);
      if FCopyAppearance and (ColumnCount > 1) then
        for j := 0 to RowCount - 1 do
          AssignCellAppearance(Cells[ColumnCount - 2, j],
            Cells[ColumnCount - 1, j]);
    end;
    while Value < ColumnCount do
      DeleteColumn(ColumnCount - 1);

    if n < 0 then
      for y := 0 to RowCount - 1 do
        for X := 0 to ColumnCount - 1 do
        begin
          cc := Cells[X, Y];
          if ColumnCount < X + cc.ColSpan then
            cc.ColSpan := cc.ColSpan + n;
        end;
  finally
    FLockObjectsUpdate := False;
    FLockCorrectSpans := False;
    UpdateDesigner;
  end;
end;

procedure TfrxTableObject.SetHeight(Value: Extended);
begin
  if not FBoundsUpdating and IsDesigning then
  begin
    if SameValue(Value, Height, 0.01) then Exit;
    SetTableHeight(Value);
  end;
  inherited
end;

procedure TfrxTableObject.SetRowCount(Value: Integer);
var
  i, j, n: Integer;
begin
  FLockObjectsUpdate := True;
  FLockCorrectSpans := True;
  n := Value - RowCount;
  try
    for i := 0 to n - 1 do
    begin
      AddRow(CreateTableRow);
      if FCopyAppearance and (RowCount > 1) then
        for j := 0 to ColumnCount - 1 do
          AssignCellAppearance(Cells[j, RowCount - 2], Cells[j, RowCount - 1]);
    end;
    while Value < RowCount do
      DeleteRow(RowCount - 1);
  finally
    FLockObjectsUpdate := False;
    FLockCorrectSpans := False;
    if n < 0 then
      CorrectSpansOnRowChange(Value, n);
    UpdateDesigner;
  end;
end;

procedure TfrxTableObject.SetTableHeight(const Value: Extended);
var
  i: Integer;
  dx: Extended;
begin
  dx := (Value - Height) / RowCount;
  for I := 0 to RowCount - 1 do
    Rows[i].Height := Rows[i].Height + dx;
  UpdateBounds;
end;

procedure TfrxTableObject.SetTableWidth(const Value: Extended);
var
  dx: Extended;
  i: Integer;
begin
  dx := (Value - Width) / ColumnCount;
  for I := 0 to ColumnCount - 1 do
    Columns[i].Width := Columns[i].Width + dx;
  UpdateBounds;
end;

procedure TfrxTableObject.SetWidth(Value: Extended);
begin
  if not FBoundsUpdating and IsDesigning then
  begin
    if SameValue(Value, Width, 0.01) then Exit;
    SetTableWidth(Value);
  end;
  inherited;
end;

procedure TfrxTableObject.SplitCell(aCell: TfrxTableCell);
begin
  aCell.ColSpan := 1;
  aCell.RowSpan := 1;
end;

procedure TfrxTableObject.SplitSelected;
var
  c: TfrxTableCell;
  x, y: Integer;
begin
  c := nil;
  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
    begin
      c := Cells[x, y];
      if c.IsSelected then
        break;
      c := nil;
    end;
  if (c <> nil) then
  begin
    c.RowSpan := 1;
    c.ColSpan := 1;
  end;
end;

procedure TfrxTableObject.SwapRows(Row1, Row2: Integer);
begin
  if not((Row1 >= 0) and (Row1 < RowCount) and (Row2 >= 0) and (Row2 < RowCount)) then
    Exit;

//  begin
//    // we need this to be sure that the new item is added at the end of list
//    // note: this will also normalize the objects list
//    Value.Parent := nil;
//    Value.Parent := Self;
//    // now move the item. take into account "columns, then rows" order in the objects list
//    Objects.Move(Objects.Count - 1, ColumnCount + Index);
//    //Value.InitCells(ColumnCount);
//    //CorrectSpansOnRowChange(Index, 1);
//    if (Report <> nil) and (Report.Designer <> nil) and not FLockObjectsUpdate then
//      Report.Designer.ReloadObjects(False);
//  end;
//
end;

//function TfrxTableObject.ContainerAdd(Obj: TfrxComponent): Boolean;
//var
//  X, Y: Integer;
//begin
//  Result := False;
//  if csContained in Obj.frComponentStyle then
//    Exit;
//  for X := 0 to ColumnCount - 1 do
//    for Y := 0 to RowCount - 1 do
//      if Cells[X, Y].IsContain(Obj.AbsLeft, Obj.AbsTop) then
//      begin
//        if Obj.Parent =  Cells[X, Y] then Exit;
//        //if Obj.Owner <> nil then
//        //  Obj.Owner.RemoveComponent(Obj);
//        Obj.Parent := Cells[X, Y];
//        Obj.Left := Obj.Left - (Left + Cells[X, Y].Left);
//        Obj.Top := Obj.Top - (Top + Rows[Y].Top);
//        Result := True;
//        //NormalizeObjectsList;
//        if (Report <> nil) and (Report.Designer <> nil) and not FLockObjectsUpdate
//        then
//          Report.Designer.ReloadObjects(False);
//        Exit;
//      end;
//end;

procedure TfrxTableObject.CorrectSpansOnColumnChange(ColumnIndex, Correct: Integer);
var
  x, y: Integer;
  c: TfrxTableCell;
begin
  if ColumnIndex > ColumnCount then
    ColumnIndex := ColumnCount;

  for y := 0 to RowCount - 1 do
  begin
    Rows[Y].CorrectCellsOnColumnChange(ColumnIndex, Correct);
    if not FLockCorrectSpans then
      for X := 0 to ColumnIndex - 1 do
      begin
        c := Cells[X, Y];
        if ColumnIndex < X + c.ColSpan then
          c.ColSpan := c.ColSpan + Correct;
      end;
  end;

  if not FLockCorrectSpans then
    ResetSpanList;
end;

procedure TfrxTableObject.CorrectSpansOnRowChange(RowIndex, Correct: Integer);
var
  x, y: Integer;
  c: TfrxTableCell;
begin
  if FLockCorrectSpans then
    Exit;
  if RowIndex > RowCount then
    RowIndex := RowCount;

  for y := 0 to RowIndex - 1 do
    for x := 0 to ColumnCount - 1 do
    begin
      c := Cells[x, y];
      if RowIndex < y + c.RowSpan then
        c.RowSpan := c.RowSpan + Correct;
    end;

  ResetSpanList;
end;

procedure TfrxTableObject.ResetSpanList;
begin
//  SetLength(FSpanList, 0);
end;

procedure TfrxTableObject.FillSpanList(var SpanList: TfrxRectArray);
var
  x, y, cnt: Integer;
  c: TfrxTableCell;
begin
  if Length(SpanList) > 0 then
    Exit;

  NormalizeSpans;
  cnt := 0;
  SetLength(SpanList, ColumnCount * RowCount);

  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
    begin
      c := Cells[x, y];
      if (c.ColSpan > 1) or (c.RowSpan > 1) then
      begin
        SpanList[cnt] := Rect(x, y, x + c.ColSpan, y + c.RowSpan);
        Inc(cnt);
      end;
    end;

  SetLength(SpanList, cnt);
end;

function TfrxTableObject.IsInsideSpan(SpanList: TfrxRectArray; p: TPoint): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Length(SpanList) - 1 do
    if PtInRect(SpanList[i], p) and not PointsEqual(SpanList[i].TopLeft, p) then
    begin
      Result := True;
      Exit;
    end;
end;

function TfrxTableObject.IsTableActive: Boolean;
begin
  Result := FTableActive or IsSelected or FDragDropActive;
end;

function TfrxTableObject.IsWidthStored: Boolean;
begin
  Result := False;
end;

procedure TfrxTableObject.JoinSelection(TopX: Integer; TopY: Integer; BottomX: Integer; BottomY: Integer);
var
  x, y: Integer;
  c: TfrxTableCell;
begin
  if (TopX = MaxInt) or (TopY = MaxInt) or (BottomX = -1) or (BottomY = -1) then
    for X := 0 to ColumnCount - 1 do
      for Y := 0 to RowCount - 1 do
      begin
        c := Cells[X, Y];
        if c.IsSelected then
        begin
          if X < TopX then
            TopX := X;
          if Y < TopY then
            TopY := Y;
          if X > BottomX then
            BottomX := X;
          if Y > BottomY then
            BottomY := Y;
        end;
      end;
  if (TopX <> MaxInt) and (TopY <> MaxInt) and (BottomX > -1) and (BottomY > -1) then
  begin
    c := Cells[TopX, TopY];
    c.ColSpan := BottomX - TopX + 1;
    c.RowSpan := BottomY - TopY + 1;
  end;
end;

procedure TfrxTableObject.Loaded;
begin
  inherited;
  UpdateBounds;
end;

procedure TfrxTableObject.MoveColumn(Index, NewIndex: Integer);
var
  i: Integer;
begin
  Objects.Exchange(Index, NewIndex);
  for i := 0 to RowCount - 1 do
    Rows[i].Objects.Exchange(Index, NewIndex);
  NormalizeSpans;
end;

procedure TfrxTableObject.NormalizeSpans;
var
  x, y, x1, y1: Integer;
  c: TfrxTableCell;
begin
  // Mainly needed after load a report to be sure that spans don't go outside the table bounds
  // (bounds checking is off during load).
  // In normal scenarios, spans are checked in the property setters.
  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
    begin
      c := Cells[x, y];
      c.ColSpan := c.ColSpan;
      c.RowSpan := c.RowSpan;
      c.FHidden := False;
    end;

  // set Hidden flag for cells inside spans
  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
    begin
      c := Cells[x, y];
      if c.FHidden then
        continue;
      if (c.ColSpan > 1) or (c.RowSpan > 1) then
      begin
        for x1 := x to x + c.ColSpan - 1 do
          for y1 := y to y + c.RowSpan - 1 do
            if (x1 <> x) or (y1 <> y) then
              Cells[x1, y1].FHidden := True;
      end;
    end;
end;

procedure TfrxTableObject.ObjectListNotify(Ptr: Pointer;
  Action: TListNotification);
var
  aIncremental: Integer;
begin
  inherited;
  aIncremental := 0;
  if Action = lnAdded then
    aIncremental := 1
  else if Action = lnDeleted then
    aIncremental := -1;
  if TObject(Ptr) is TfrxTableColumn then
    FColumnCount := FColumnCount + aIncremental
  else if TObject(Ptr) is TfrxTableRow then
    FRowCount := FRowCount + aIncremental;
end;

procedure TfrxTableObject.CalcWidthInternal;
var
  x, y, i: Integer;
  colWidth, cellWidth, tableWidth: Extended;
  col: TfrxTableColumn;
  c: TfrxTableCell;
begin
  // first pass, calc non-spanned cells
  for x := 0 to ColumnCount - 1 do
  begin
    col := Columns[x];
    if not col.AutoSize then
      continue;
    colWidth := col.MinWidth;
    if IsDesigning then
      colWidth := 16;

    // calc the max column width
    for y := 0 to RowCount - 1 do
    begin
      c := Cells[x, y];
      if not c.FHidden and (c.ColSpan = 1) and not ((c.Rotation = 90) or (c.Rotation = 270)) then
      begin
        cellWidth := c.CalcWidth;
        if cellWidth > colWidth then
          colWidth := cellWidth;
      end;
    end;

    // update column width
    if (colWidth > col.MaxWidth) and (col.MaxWidth > 0)then
      colWidth := col.MaxWidth;
    if colWidth <> -1 then
      col.Width := colWidth;
  end;

  // second pass, calc spanned cells
  for x := 0 to ColumnCount - 1 do
  begin
//    Columns[x].MinimumBreakWidth = 0;
    for y := 0 to RowCount - 1 do
    begin
      c := Cells[x, y];
      if not c.FHidden and (c.ColSpan > 1) then
      begin
        cellWidth := c.CalcWidth;
//        if (AdjustSpannedCellsWidth && cellWidth > Columns[x].MinimumBreakWidth)
//          Columns[x].MinimumBreakWidth = cellWidth;

        // check that spanned columns have enough width
        colWidth := 0;
        for i := 0 to c.ColSpan - 1 do
          colWidth := colWidth + Columns[x + i].Width;

        // if cell is bigger than sum of column widths, increase one of the columns.
        // check columns with AutoSize flag only, starting from the last one
        if cellWidth > colWidth then
          for i := c.ColSpan - 1 downto 0 do
          begin
            col := Columns[x + i];
            if col.AutoSize then
            begin
              col.Width := col.Width + (cellWidth - colWidth);
              break;
            end;
          end;
      end;
      { update anchors }
      c.UnlockAnchorsUpdate;
      c.Width := c.CellWidth;
    end;
  end;

  // finally, calculate the table width
  tableWidth := 0;
  for i := 0 to ColumnCount - 1 do
    tableWidth := tableWidth + Columns[i].Width;

//  FLockColumnRowChange = true;
  FBoundsUpdating := True;
  Width := tableWidth;
//  FLockColumnRowChange = false;
  FBoundsUpdating := False;
end;

function TfrxTableObject.CheckColumnSelector(X, Y: Extended): Boolean;
begin
  Result := (AbsLeft <= X) and (AbsLeft + Width >= X) and (AbsTop - 20 <= Y) and (AbsTop + 2 >= Y);
end;

function TfrxTableObject.CheckMoveArrow(X, Y: Extended): Boolean;
begin
  Result := (AbsLeft <= X) and (AbsLeft + 16 >= X) and (AbsTop - 6 <= Y) and (AbsTop + 16 >= Y);
end;

function TfrxTableObject.CheckRowSelector(X, Y: Extended): Boolean;
begin
  Result := (AbsTop <= Y) and (AbsTop + Height >= Y) and (AbsLeft - 20 <= X) and (AbsLeft + 2 >= X);
end;

function TfrxTableObject.CheckSizeArrow(X, Y: Extended): Boolean;
begin
  Result := (AbsLeft + Width + 2 <= X) and (AbsLeft + Width + 24 >= X) and (AbsTop + Height + 24 >= Y) and (AbsTop + Height + 2 <= Y);
end;

procedure TfrxTableObject.CalcHeightInternal;
var
  x, y, i: Integer;
  rowHeight, cellHeight, cellWidth, tableHeight: Extended;
  row: TfrxTableRow;
  c: TfrxTableCell;
begin
  // first pass, calc non-spanned cells
  for y := 0 to RowCount - 1 do
  begin
    row := Rows[y];
    if not row.AutoSize then
      continue;
    rowHeight := row.MinHeight;
    if IsDesigning then
      rowHeight := 16;

    // calc max row height
    for x := 0 to ColumnCount - 1 do
    begin
      c := Cells[x, y];
      if not c.FHidden and (c.RowSpan = 1) then
      begin
        c.UnlockAnchorsUpdate;
        c.Width := c.CellWidth;
        cellHeight := c.CalcHeight();
        if cellHeight > rowHeight then
          rowHeight := cellHeight;
      end;
    end;

    if (rowHeight > row.MaxHeight) and (row.MaxHeight > 0) then
      rowHeight := row.MaxHeight;
    // update row height
    if rowHeight <> -1 then
      row.Height := rowHeight;
  end;

  // second pass, calc spanned cells
  for y := 0 to RowCount - 1 do
  begin
    for x := 0 to ColumnCount - 1 do
    begin
      c := Cells[x, y];
      if not c.FHidden and (c.RowSpan > 1) then
      begin
        c.Width := c.CellWidth;
        cellHeight := c.CalcHeight();

        // check that spanned rows have enough height
        rowHeight := 0;
        for i := 0 to c.RowSpan - 1 do
          rowHeight := rowHeight + Rows[y + i].Height;

        // if cell is bigger than sum of row heights, increase one of the rows.
        // check rows with AutoSize flag only, starting from the last one
        if cellHeight > rowHeight then
          for i := c.RowSpan - 1 downto 0 do
          begin
            row := Rows[y + i];
            if row.AutoSize then
            begin
              row.Height := row.Height + (cellHeight - rowHeight);
              break;
            end;
          end;
      end;
      if (c.Rotation = 90) or (c.Rotation = 270) then
      begin
        c.Height := Rows[y].Height;
        cellWidth := c.CalcWidth;
        if (cellWidth > Columns[x].Width) then
        begin
          if cellWidth > Columns[x].MaxWidth then
            cellWidth := Columns[x].MaxWidth;
          Columns[x].Width := cellWidth;
        end;
      end;
      { update anchors }
      UpdateCellDimensions(c);
    end;
  end;

  // finally, calculate the table height
  tableHeight := 0;
  for i := 0 to RowCount - 1 do
    tableHeight := tableHeight + Rows[i].Height;
  FBoundsUpdating := True;
  Height := tableHeight;
  FBoundsUpdating := False;
end;

procedure TfrxTableObject.UpdateBounds;
var
  x, y: Integer;
  l, t: Extended;
  c: TfrxTableCell;
begin
  NormalizeSpans;

  l := 0;
  t := 0;
  for x := 0 to ColumnCount - 1 do
  begin
    t := 0;
    Columns[x].Left := l;
    for y := 0 to RowCount - 1 do
    begin
      Rows[y].Top := t;
      c := Cells[x, y];
      c.Left := l;
      UpdateCellDimensions(c);
      c.Visible := not c.FHidden;
      if IsPrinting and not c.Printable then
        c.Visible := False;
      if not c.Visible then
      begin
        c.Width := 0;
        c.Height := 0;
      end;
      t := t + Rows[y].Height;
    end;
    l := l + Columns[x].Width;
  end;
  FBoundsUpdating := True;
  LockAnchorsUpdate;
  Width := l;
  Height := t;
  UnlockAnchorsUpdate;
  FBoundsUpdating := False;
  for x := 0 to ColumnCount - 1 do
    Columns[x].Height := t;
  for y := 0 to RowCount - 1 do
    Rows[y].Width := l;
end;

procedure TfrxTableObject.UpdateCellDimensions(cell: TfrxTableCell);
begin
  cell.UnlockAnchorsUpdate;
  cell.Width := cell.CellWidth;
  cell.UnlockAnchorsUpdate;
  cell.Height := cell.CellHeight;
end;

procedure TfrxTableObject.UpdateDesigner;
begin
  if not FLockObjectsUpdate and IsDesigning and (Report <> nil) and
    (Report.Designer <> nil) then
    Report.Designer.ReloadObjects(False);
end;

procedure TfrxTableObject.DrawTable(Highlighted: Boolean);
var
  x, y, dx, dy, RowH, ColW, i: Integer;
  c: TfrxTableCell;
  IsRowColumnSelected: Boolean;
  SelColor: TColor;
  SelectionDir, cSel: Integer;

  procedure DrawLine(x, y, dx, dy: Extended);
  begin
    FCanvas.Pen.Width := 1;
    FCanvas.Pen.Color := clAqua;
    FCanvas.MoveTo(Round(x * FScaleX), Round(y * FScaleY));
    FCanvas.LineTo(Round((x + dx) * FScaleX), Round((y + dy) * FScaleY));
  end;

begin
  // update rows and columns positions, also cells bounds
  UpdateBounds;

  // draw background
  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
    begin
      c := Cells[x, y];
      if c.Visible then
      begin
        c.BeginDraw(FCanvas, FScaleX, FScaleY, FOffsetX, FOffsetY);
        c.DrawBackground;
        c.DrawFrame;
      end;
    end;

//  // draw frame
//  for x := 0 to ColumnCount - 1 do
//    for y := 0 to RowCount - 1 do
//    begin
//      c := Cells[x, y];
//      if c.Visible then
//        c.DrawFrame;
//    end;

  // draw text
  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
    begin
      c := Cells[x, y];
      SelColor := clSkyBlue;
      IsRowColumnSelected := False;
      { TODO: make boolean expression compact }
      if FSelectedRowColCount = 0 then
      begin
        { Row drag exchange selector}
        IsRowColumnSelected := ((FSelectedRowCol Is TfrxTableRow) and (Rows[y].IsContain(FSelectorPoint.X / FScaleX, FSelectorPoint.Y / FScaleY)) and ((FSelectedRowCol <> Rows[y]) or not FSelectedRowCol.IsSelected));
        { Column drag exchange selector}
        IsRowColumnSelected := (IsRowColumnSelected or ((FSelectedRowCol Is TfrxTableColumn) and (Columns[x].IsContain(FSelectorPoint.X / FScaleX, FSelectorPoint.Y / FScaleY)) and ((FSelectedRowCol <> Columns[x]) or not FSelectedRowCol.IsSelected)));
      end;
      if IsRowColumnSelected then
        SelColor := clPurple;
      IsRowColumnSelected := IsRowColumnSelected or (FResizeActive and ((ColumnCount + FNewColumnDim - 1 >= x) and (RowCount + FNewRowDim - 1 >= y)));
      IsRowColumnSelected := IsRowColumnSelected or (Columns[x].IsSelected or Rows[y].IsSelected or c.IsSelected);
      if FSelectedRowColCount <> 0  then
      begin
      SelectionDir := 1;
      if FSelectedRowColCount < 0 then
        SelectionDir := -1;
        cSel := Y;
        if (FSelectedRowCol Is TfrxTableColumn) then
          cSel := X;
        cSel := cSel * SelectionDir;
        IsRowColumnSelected := IsRowColumnSelected or ((FSelectedRowCol.Index * SelectionDir < cSel) and ((FSelectedRowCol.Index + FSelectedRowColCount) * SelectionDir >= cSel));
      end;
      if (FSelectionStart.Left <> -1) and (FSelectionEnd.Left <> -1) then
        IsRowColumnSelected := IsRowColumnSelected or ((FCellsSelection.Left <= X) and (FCellsSelection.Right >= X) and (FCellsSelection.Top <= Y) and (FCellsSelection.Bottom >= Y));
      if c.Visible then
      begin
        c.IsDesigning := IsDesigning;
        try
          c.FVC := FVC;
          c.DrawText;
        finally
          c.FVC := nil;
        end;
        if IsRowColumnSelected then
          c.DrawSelected(SelColor);
//        if Highlighted then
//          c.DrawHighlight(FCanvas, FScaleX, FScaleY, FOffsetX, FOffsetY);
        if {(c.IsDesigning and c.DrawHighlights and c.IsSelected) or} Highlighted or
            (not c.IsDesigning and c.IsSelected) then
            c.DrawHighlight(FCanvas, FScaleX, FScaleY, FOffsetX, FOffsetY);
        if FObjAsMetafile then
          for i := 0 to c.Objects.Count - 1 do
          begin
            TfrxHackView(c.Objects[i]).FVC := FVC;
            try
              TfrxView(c.Objects[i]).Draw(FCanvas, FScaleX, FScaleY, FOffsetX, FOffsetY);
            finally
              TfrxHackView(c.Objects[i]).FVC := nil;
            end;
          end;
      end;
      if IsTableActive and IsDesigning then
      begin
        if FColumnSelection then
          frxResources.MainButtonImages.Draw(FCanvas, FSelectorPoint.X,
            FY - 20, 112);
        if FRowSelection then
          frxResources.MainButtonImages.Draw(FCanvas, FX - 20,
            FSelectorPoint.Y, 111);
      end;
      if y = FVertSplitter then
        DrawLine(AbsLeft + FOffsetX, Rows[y].AbsTop + Rows[y].Height + FOffsetY, Width, 0)
      else if x = FHorzSplitter then
        DrawLine(Columns[x].AbsLeft + Columns[x].Width + FOffsetX, AbsTop + FOffsetY, 0, Height);
    end;
  // draw new columns/rows
  dx := FX;
  dy := FY;
  for X := 0 to ColumnCount + FNewColumnDim - 1 do
  begin
    ColW := Round(FDefaultCellWidth * FScaleX);
    if X < ColumnCount then
      ColW := Round(Columns[X].Width * FScaleX);
    Dec(ColW);
    dy := FY;
    for Y := 0 to RowCount + FNewRowDim - 1 do
    begin
      RowH := Round(FDefaultCellHeight * FScaleX);

      if Y < RowCount then
        RowH := Round(Rows[Y].Height * FScaleY);
      Dec(RowH);
      if not((X < ColumnCount) and (Y < RowCount)) then
        TransparentFillRect(FCanvas.Handle, dx, dy, dx + ColW, dy + RowH,
          clSkyBlue);
      dy := dy + 1 + RowH;
    end;
    dx := dx + 1 + ColW;
  end;
  if IsTableActive and IsDesigning then
    if FResizeActive then
      frxResources.ObjectImages.Draw(FCanvas, dx + 2, dy + 2, 65)
    else
      frxResources.ObjectImages.Draw(FCanvas, dx + 2, dy + 2, 67);
end;

function TfrxTableObject.ExportInternal(Filter: TfrxCustomExportFilter): Boolean;
var
  x, y, i: Integer;
  cell: TfrxTableCell;
  AllObjects: TList;
begin
  Result := False;
  if not Filter.IsProcessInternal then
  begin
    Filter.BeginClip(Self);
    FObjAsMetafile := True;
    try
      Filter.ExportObject(Self);
    finally
      FObjAsMetafile := False;
    end;
    Filter.EndClip;
    Exit;
  end;
  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
    begin
      cell := GetCell(x, y);
      cell.Width := cell.CellWidth;
      cell.Height := cell.CellHeight;
      if cell.FHidden then Continue;
      AllObjects := cell.AllObjects;
      Filter.ExportObject(cell);
      Filter.BeginClip(cell);
      try
        for i := 0 to AllObjects.Count - 1 do
          if TObject(AllObjects[i]) is TfrxView then
            Filter.ExportObject(TfrxView(AllObjects[i]));
      finally
        Filter.EndClip;
      end;
    end;
  Result := True;
end;


procedure TfrxTableObject.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  DrawTable(FHighlighted);
  if IsTableActive and IsDesigning then
    frxResources.MainButtonImages.Draw(Canvas, FX, FY - 6, 110);
  FBoundsUpdating := False;
end;

function TfrxTableObject.DrawPart: Extended;
var
  aReport: TfrxReport;
  i, breakRowIndex: Integer;
  rowsHeight, aHeight: Extended;
  cell, cellto: TfrxTableCell;
  SpanList: TfrxRectArray;
begin
  aReport := Report;
  Result := Height;
  if aReport = nil then Exit;

  rowsHeight := 0;
  breakRowIndex := FBreakRowIndex;
  aHeight := Height;
  if not Assigned(FBrakeTo) then
    FBrakeTo := TfrxTableObject.Create(nil);
  while (breakRowIndex < RowCount) and (rowsHeight + Rows[breakRowIndex].Height < aHeight) do
  begin
    rowsHeight := rowsHeight + Rows[breakRowIndex].Height;
    Inc(breakRowIndex);
  end;
  FillSpanList(SpanList);
  if (breakRowIndex = FBreakRowIndex) and (Rows[breakRowIndex].Height > aHeight) then
  begin
    rowsHeight := rowsHeight + Rows[breakRowIndex].Height;
    Inc(breakRowIndex);
  end;

  if FBrakeTo.ColumnCount <> ColumnCount then
  begin
    FBrakeTo.Assign(Self);
    FBrakeTo.ColumnCount := ColumnCount;
    for i := 0 to ColumnCount - 1 do
      FBrakeTo.Columns[i].AssignAll(Columns[i]);
  end;
  FBrakeTo.RowCount := breakRowIndex - FBreakRowIndex;
  for i := FBreakRowIndex to breakRowIndex - 1 do
    FBrakeTo.Rows[i - FBreakRowIndex].AssignAll(Rows[i]);

  for i := Low(SpanList) to High(SpanList) do
    if (SpanList[i].Top < FBreakRowIndex) and (SpanList[i].Bottom > FBreakRowIndex) then
    begin
      cell := Cells[SpanList[i].Left, SpanList[i].Top];
      cellto := FBrakeTo.Cells[SpanList[i].Left, 0];
      cellto.Assign(cell);
      cellto.RowSpan := SpanList[i].Bottom - FBreakRowIndex;
    end;
  FBrakeTo.NormalizeSpans;
  FBrakeTo.Height := rowsHeight;
  Result := aHeight - rowsHeight;
  if Result < 0 then Result := aHeight;

  FBreakRowIndex := breakRowIndex;
end;

function TfrxTableObject.IsAcceptAsChild(aParent: TfrxComponent): Boolean;
begin
  Result := (aParent is TfrxBand) or (aParent is TfrxPage);
end;

function TfrxTableObject.IsContain(X, Y: Extended): Boolean;
begin
  if IsTableActive and (CheckColumnSelector(X, Y) or CheckRowSelector(X, Y) or CheckMoveArrow(X, Y) or CheckSizeArrow(X, Y)) then
  begin
    Result := True;
    Exit;
  end;
  Result := inherited IsContain(X, Y);
end;

function TfrxTableObject.IsHeightStored: Boolean;
begin
  Result := False;
end;

procedure TfrxTableObject.AddColumn(Value: TfrxTableColumn);
begin
  if Value = nil then
    Exit;
  Value.Parent := nil;
  InsertColumn(ColumnCount, Value);
end;

procedure TfrxTableObject.InitPart;
begin
  inherited;
  FBreakRowIndex := 0;
end;

procedure TfrxTableObject.InsertColumn(Index: Integer; Value: TfrxTableColumn);
begin
  if (Index < 0) or (Value = nil) then
    Exit
  else
  begin
    // we need this to be sure that the new item is added at the end of list
    // note: this will also normalize the objects list
    Value.Parent := nil;
    Value.Parent := Self;
    // now move the item
    Objects.Move(ColumnCount - 1, Index);
    CorrectSpansOnColumnChange(Index, 1);
    UpdateDesigner;
  end;
end;

procedure TfrxTableObject.DeleteColumn(Index: Integer);
var
  c: tfrxTableColumn;
begin
  c := Columns[Index];
  if c <> nil then
  begin
    c.Free;
    CorrectSpansOnColumnChange(Index, -1);
    UpdateDesigner;
  end;
end;

procedure TfrxTableObject.AddRow(Value: TfrxTableRow);
begin
  if Value = nil then
    Exit;
  Value.Parent := nil;
  InsertRow(RowCount, Value);
end;

procedure TfrxTableObject.InsertRow(Index: Integer; Value: TfrxTableRow);
begin
  if (Index < 0) or (Value = nil) then
    Exit
  else
  begin
    // we need this to be sure that the new item is added at the end of list
    // note: this will also normalize the objects list
    Value.Parent := nil;
    Value.Parent := Self;
    // now move the item. take into account "columns, then rows" order in the objects list
    Objects.Move(Objects.Count - 1, ColumnCount + Index);
    Value.InitCells(ColumnCount);
    CorrectSpansOnRowChange(Index, 1);
    UpdateDesigner;
  end;
end;

procedure TfrxTableObject.DeleteRow(Index: Integer);
var
  r: TfrxTableRow;
begin
  r := Rows[Index];
  if r <> nil then
  begin
    r.Free;
    CorrectSpansOnRowChange(Index, -1);
    UpdateDesigner;
  end;
end;

function TfrxTableObject.CalcHeight: Extended;
begin
  NormalizeSpans;
  CalcWidthInternal;
  CalcHeightInternal;
  Result := Height;
end;

procedure TfrxTableObject.BeforePrint;
var
  x, y: Integer;
begin
  inherited;
  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
      Cells[x, y].BeforePrint;
end;

procedure TfrxTableObject.AfterPrint;
var
  x, y: Integer;
begin
  FBoundsUpdating := True;
  LockAnchorsUpdate;
  inherited;
  if Assigned(FBrakeTo) then
    FreeAndNil(FBrakeTo);
  FBoundsUpdating := False;
  for x := 0 to ColumnCount - 1 do
    for y := 0 to RowCount - 1 do
      Cells[x, y].AfterPrint;
  UnLockAnchorsUpdate;
end;

procedure TfrxTableObject.AlignChildren(IgnoreInvisible: Boolean; MirrorModes: TfrxMirrorControlModes);
var
  x, y: Integer;
begin
//  NormalizeSpans;
  for x := 0 to ColumnCount - 1 do
  begin
    for y := 0 to RowCount - 1 do
    begin
      UpdateCellDimensions(Cells[x, y]);
      if Cells[x, y].Objects.Count = 0 then
        Cells[x, y].DoMirror(MirrorModes);
      Cells[x, y].AlignChildren(IgnoreInvisible, MirrorModes);
    end;
  end;
end;

procedure TfrxTableObject.AssignCellAppearance(FromCell, ToCell: TfrxTableCell);
begin
  if (FromCell = nil) or (ToCell = nil) then Exit;
  ToCell.Font.Assign(FromCell.Font);
  ToCell.Frame.Assign(FromCell.Frame);
  ToCell.FillType := FromCell.FillType;
  ToCell.Fill.Assign(FromCell.Fill);
end;

procedure TfrxTableObject.GetData;
var
  x, y: Integer;
  aReport: TfrxReport;
  aOldObject: String;
  tCell: TfrxTableCell;
begin
  inherited;
  aReport := Report;
  for y := 0 to RowCount - 1 do
  begin
    aReport.Engine.CurTableRow := y + 1;
    for x := 0 to ColumnCount - 1 do
    begin
      aReport.Engine.CurTableColumn := x + 1;
      aOldObject := aReport.CurObject;
      tCell := Cells[x, y];
      aReport.CurObject := tCell.Name;
      try
        tCell.GetData;
      finally
        aReport.CurObject := aOldObject;
      end;
      // set Visible to True to prevent problems with serialization to previewpages
      tCell.Visible := True;
    end;
  end;
  aReport.Engine.CurTableColumn := 0;
  aReport.Engine.CurTableRow := 0;
end;

class function TfrxTableObject.GetDescription: String;
begin
  Result := frxResources.Get('obTable');
end;

{ TfrxContainerPadding }

procedure TfrxContainerPadding.Assign(Source: TPersistent);
begin
  if Source is TfrxContainerPadding then
  begin
    FLeftPading := TfrxContainerPadding(Source).FLeftPading;
    FTopPading := TfrxContainerPadding(Source).FTopPading;
    FRightPading := TfrxContainerPadding(Source).FRightPading;
    FBottomPading := TfrxContainerPadding(Source).FBottomPading;
  end;
end;

initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxTableObject, TControl);
{$ENDIF}

end.
