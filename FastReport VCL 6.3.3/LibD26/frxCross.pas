{******************************************}
{                                          }
{             FastReport v5.0              }
{              Cross object                }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxCross;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}Windows, {$ENDIF}Types, SysUtils, Classes, Controls, Graphics, Forms,
  frxClass, Variants
{$IFDEF FPC}
  , LCLType, LMessages, LazHelper, LazarusPackageIntf
{$ENDIF}
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxCrossObject = class(TComponent);  // fake component

  TfrxPrintCellEvent = type String;
  TfrxPrintHeaderEvent = type String;
  TfrxCalcWidthEvent = type String;
  TfrxCalcHeightEvent = type String;
  TfrxOnPrintCellEvent = procedure (Memo: TfrxCustomMemoView;
    RowIndex, ColumnIndex, CellIndex: Integer;
    const RowValues, ColumnValues, Value: Variant) of object;
  TfrxOnPrintHeaderEvent = procedure (Memo: TfrxCustomMemoView;
    const HeaderIndexes, HeaderValues, Value: Variant) of object;
  TfrxOnCalcWidthEvent = procedure (ColumnIndex: Integer;
    const ColumnValues: Variant; var Width: Extended) of object;
  TfrxOnCalcHeightEvent = procedure (RowIndex: Integer;
    const RowValues: Variant; var Height: Extended) of object;

  { the record represents one cell of cross matrix }
  PfrCrossCell = ^TfrxCrossCell;
  TfrxCrossCell = packed record
    Value: Variant;
    Count: Integer;
    Next: PfrCrossCell;    { pointer to the next value in the same cell }
  end;

  TfrxCrossEditGrid = (seLeftTop, seLeftBottom, seRightTop, seRightBottom);
  TfrxCrossSortOrder = (soAscending, soDescending, soNone, soGrouping);
  TfrxCrossFunction = (cfNone, cfSum, cfMin, cfMax, cfAvg, cfCount);
  TfrxVariantArray = array of Variant;
  TfrxSortArray = array [0..63] of TfrxCrossSortOrder;

  { the base class for column/row item. Contains Indexes array that
    identifies a column/row }
  TfrxIndexItem = class(TCollectionItem)
  private
    FIndexes: TfrxVariantArray;
  public
    destructor Destroy; override;
    property Indexes: TfrxVariantArray read FIndexes write FIndexes;
  end;

  { the base collection for column/row items. Contains methods for working
    with Indexes and sorting them }
  TfrxIndexCollection = class(TCollection)
  private
    FIndexesCount: Integer;
    FSortOrder: TfrxSortArray;
    function GetItems(Index: Integer): TfrxIndexItem;
  public
    function Find(const Indexes: array of Variant; var Index: Integer): Boolean;
    function InsertItem(Index: Integer; const Indexes: array of Variant): TfrxIndexItem; virtual;
    property Items[Index: Integer]: TfrxIndexItem read GetItems; default;
  end;

  { the class representing a single row item }
  TfrxCrossRow = class(TfrxIndexItem)
  private
    FCellLevels: Integer;
    FCells: TList;
    procedure CreateCell(Index: Integer);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function GetCell(Index: Integer): PfrCrossCell;
    function GetCellValue(Index1, Index2: Integer): Variant;
    procedure SetCellValue(Index1, Index2: Integer; const Value: Variant);
  end;

  { the class representing row items }
  TfrxCrossRows = class(TfrxIndexCollection)
  private
    FCellLevels: Integer;
    function GetItems(Index: Integer): TfrxCrossRow;
  public
    constructor Create;
    function InsertItem(Index: Integer; const Indexes: array of Variant): TfrxIndexItem; override;
    function Row(const Indexes: array of Variant): TfrxCrossRow;
    property Items[Index: Integer]: TfrxCrossRow read GetItems; default;
  end;

  { the class representing a single column item }
  TfrxCrossColumn = class(TfrxIndexItem)
  private
    FCellIndex: Integer;
  public
    property CellIndex: Integer read FCellIndex write FCellIndex;
  end;

  { the class representing column items }
  TfrxCrossColumns = class(TfrxIndexCollection)
  private
    function GetItems(Index: Integer): TfrxCrossColumn;
  public
    constructor Create;
    function Column(const Indexes: array of Variant): TfrxCrossColumn;
    function InsertItem(Index: Integer; const Indexes: array of Variant): TfrxIndexItem; override;
    property Items[Index: Integer]: TfrxCrossColumn read GetItems; default;
  end;

  { TfrxCrossHeader represents one cell of a cross header. The cell has a value,
    position, size and list of subcells }
  TfrxCrossHeader = class(TObject)
  private
    FBounds: TfrxRect;              { bounds of the cell }
    FMemos: TList;
    FTotalMemos: TList;
    FCounts: TfrxVariantArray;
    FCellIndex: Integer;            { help to determine cell index for cell header }
    FCellLevels: Integer;
    FFuncValues: TfrxVariantArray;
    FHasCellHeaders: Boolean;       { top level item only }
    FIndex: Integer;                { index of the item }
    FIsCellHeader: Boolean;
    FIsIndex: Boolean;              { used in IndexItems to determine if item is index }
    FIsTotal: Boolean;              { is this cell a total cell }
    FItems: TList;                  { subcells }
    FLevelsCount: Integer;          { number of header levels }
    FMemo: TfrxCustomMemoView;      { memo for this cell }
    FNoLevels: Boolean;             { true if no items in row/column header }
    FParent: TfrxCrossHeader;       { parent of the cell }
    FSize: TfrxPoint;
    FTotalIndex: Integer;           { will help to choose which header memo to use }
    FValue: Variant;                { value (text) of the cell }
    FVisible: Boolean;              { visibility of the cell }
    FDefaultHeight: Integer;        { can be used to synchonize with other headers }
    FRecalcSizes: Boolean;          { used when Column width was decreased during cross building }

    function AddCellHeader(Memos: TList; Index, CellIndex: Integer): TfrxCrossHeader;
    function AddChild(Memo: TfrxCustomMemoView): TfrxCrossHeader;
    procedure AddFuncValues(const Values, Counts: array of Variant;
      const CellFunctions: array of TfrxCrossFunction);
    procedure AddValues(const Values: array of Variant; Unsorted: Boolean);
    procedure Reset(const CellFunctions: array of TfrxCrossFunction);

    function GetCount: Integer;
    function GetItems(Index: Integer): TfrxCrossHeader;
    function GetLevel: Integer;
    function GetHeight: Extended;
    function GetWidth: Extended;
  public
    constructor Create(CellLevels: Integer);
    destructor Destroy; override;
    procedure CalcBounds; virtual; abstract;
    procedure CalcSizes(MaxWidth, MinWidth: Integer; AutoSize: Boolean); virtual; abstract;

    function AllItems: TList;
    function Find(Value: Variant): Integer;
    function GetIndexes: Variant;
    function GetValues: Variant;
    function TerminalItems: TList;
    function IndexItems: TList;

    property Bounds: TfrxRect read FBounds write FBounds;
    property Count: Integer read GetCount;
    property HasCellHeaders: Boolean read FHasCellHeaders write FHasCellHeaders;
    property Height: Extended read GetHeight;
    property IsTotal: Boolean read FIsTotal;
    property Items[Index: Integer]: TfrxCrossHeader read GetItems; default;
    property Level: Integer read GetLevel;
    property Memo: TfrxCustomMemoView read FMemo;
    property Parent: TfrxCrossHeader read FParent;
    property Value: Variant read FValue write FValue;
    property Visible: Boolean read FVisible write FVisible;
    property Width: Extended read GetWidth;
    property DefaultHeight: Integer read FDefaultHeight write FDefaultHeight;
  end;

  { the cross columns }
  TfrxCrossColumnHeader = class(TfrxCrossHeader)
  private
    FCorner: TfrxCrossHeader;
  public
    procedure CalcBounds; override;
    procedure CalcSizes(MaxWidth, MinWidth: Integer; AutoSize: Boolean); override;
  end;

  { the cross rows }
  TfrxCrossRowHeader = class(TfrxCrossHeader)
  private
    FCorner: TfrxCrossHeader;
  public
    procedure CalcBounds; override;
    procedure CalcSizes(MaxWidth, MinWidth: Integer; AutoSize: Boolean); override;
  end;

  { the cross corner }
  TfrxCrossCorner = class(TfrxCrossColumnHeader)
  end;


  { cutted bands }
  TfrxCutBandItem = class(TCollectionItem)
  public
    Band: TfrxBand;
    FromIndex: Integer;
    ToIndex: Integer;
    destructor Destroy; override;
  end;

  TfrxCutBands = class(TCollection)
  private
    function GetItems(Index: Integer): TfrxCutBandItem;
  public
    constructor Create;
    procedure Add(ABand: TfrxBand; AFromIndex, AToIndex: Integer);
    property Items[Index: Integer]: TfrxCutBandItem read GetItems; default;
  end;

  { design-time grid resize support }
  TfrxGridLineItem = class(TCollectionItem)
  public
    Coord: Extended;
    Objects: TList;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  end;

  TfrxGridLines = class(TCollection)
  private
    function GetItems(Index: Integer): TfrxGridLineItem;
  public
    constructor Create;
    procedure Add(AObj: TObject; ACoord: Extended);
    property Items[Index: Integer]: TfrxGridLineItem read GetItems; default;
  end;


  { custom cross object }
{$IFDEF FR_COM}
  TfrxCustomCrossView = class(TfrxView, IfrxCustomCrossView)
{$ELSE}
  TfrxCustomCrossView = class(TfrxView)
{$ENDIF}
  private
    FAddHeight: Extended;
    FAddWidth: Extended;
    FAllowDuplicates: Boolean;
    FAutoSize: Boolean;
    FBorder: Boolean;
    FCellFields: TStrings;
    FCellFunctions: array[0..63] of TfrxCrossFunction;
    FCellLevels: Integer;
    FClearBeforePrint: Boolean;
    FColumnBands: TfrxCutBands;
    FColumnFields: TStrings;
    FColumnHeader: TfrxCrossColumnHeader;
    FColumnLevels: Integer;
    FColumns: TfrxCrossColumns;
    FColumnSort: TfrxSortArray;
    FCorner: TfrxCrossCorner;
    FDefHeight: Integer;
    FDotMatrix: Boolean;
    FDownThenAcross: Boolean;
    FFirstMousePos: TPoint;
    FGapX: Integer;
    FGapY: Integer;
    FGridUsed: TfrxGridLines;
    FGridX: TfrxGridLines;
    FGridY: TfrxGridLines;
    FJoinEqualCells: Boolean;
    FKeepTogether: Boolean;
    FLastMousePos: TPoint;
    FMaxWidth: Integer;
    FMinWidth: Integer;
    FMouseDown: Boolean;
    FMovingObjects: Integer;
    FNextCross: TfrxCustomCrossView;
    FNextCrossGap: Extended;
    FNoColumns: Boolean;
    FNoRows: Boolean;
    FPlainCells: Boolean;
    FRepeatHeaders: Boolean;
    FRowBands: TfrxCutBands;
    FRowFields: TStrings;
    FRowHeader: TfrxCrossRowHeader;
    FRowLevels: Integer;
    FRows: TfrxCrossRows;
    FRowSort: TfrxSortArray;
    FShowColumnHeader: Boolean;
    FShowColumnTotal: Boolean;
    FShowCorner: Boolean;
    FShowRowHeader: Boolean;
    FShowRowTotal: Boolean;
    FShowTitle: Boolean;
    FSuppressNullRecords: Boolean;
    FKeepRowsTogether: Boolean;
    FDragActive: Boolean;
    FShowMoveArrow: Boolean;

    FAllMemos: TList;
    FCellMemos: TList;
    FCellHeaderMemos: TList;
    FColumnMemos: TList;
    FColumnTotalMemos: TList;
    FCornerMemos: TList;
    FRowMemos: TList;
    FRowTotalMemos: TList;

    FOnCalcHeight: TfrxCalcHeightEvent;                  { script event }
    FOnCalcWidth: TfrxCalcWidthEvent;                    { script event }
    FOnPrintCell: TfrxPrintCellEvent;                    { script event }
    FOnPrintColumnHeader: TfrxPrintHeaderEvent;          { script event }
    FOnPrintRowHeader: TfrxPrintHeaderEvent;             { script event }
    FOnBeforeCalcHeight: TfrxOnCalcHeightEvent;          { Delphi event }
    FOnBeforeCalcWidth: TfrxOnCalcWidthEvent;            { Delphi event }
    FOnBeforePrintCell: TfrxOnPrintCellEvent;            { Delphi event }
    FOnBeforePrintColumnHeader: TfrxOnPrintHeaderEvent;  { Delphi event }
    FOnBeforePrintRowHeader: TfrxOnPrintHeaderEvent;     { Delphi event }

    procedure CalcBounds(addWidth, addHeight: Extended);
    procedure CalcTotal(Header: TfrxCrossHeader; Source: TfrxIndexCollection);
    procedure CalcTotals;
    procedure CreateHeader(Header: TfrxCrossHeader; Source: TfrxIndexCollection;
      Totals: TList; TotalVisible: Boolean);
    procedure CreateHeaders;
    procedure BuildColumnBands;
    procedure BuildRowBands;
    procedure ClearMatrix;
    procedure ClearMemos;
    procedure CreateCellHeaderMemos(NewCount: Integer);
    procedure CreateCellMemos(NewCount: Integer);
    procedure CreateColumnMemos(NewCount: Integer);
    procedure CreateCornerMemos(NewCount: Integer);
    procedure CreateRowMemos(NewCount: Integer);
    procedure CorrectDMPBounds(Memo: TfrxCustomMemoView);
    procedure DoCalcHeight(Row: Integer; var Height: Extended);
    procedure DoCalcWidth(Column: Integer; var Width: Extended);
    procedure DoOnCell(Memo: TfrxCustomMemoView; Row, Column, Cell: Integer;
      const Value: Variant);
    procedure DoOnColumnHeader(Memo: TfrxCustomMemoView; Header: TfrxCrossHeader);
    procedure DoOnRowHeader(Memo: TfrxCustomMemoView; Header: TfrxCrossHeader);
    procedure InitMatrix;
    procedure InitMemos(AddToScript: Boolean);
    procedure ReadMemos(Stream: TStream);
    procedure RenderMatrix;
    procedure SetCellFields(const Value: TStrings);
    procedure SetCellFunctions(Index: Integer; const Value: TfrxCrossFunction);
    procedure SetColumnFields(const Value: TStrings);
    procedure SetColumnSort(Index: Integer; Value: TfrxCrossSortOrder);
    procedure SetDotMatrix(const Value: Boolean);
    procedure SetRowFields(const Value: TStrings);
    procedure SetRowSort(Index: Integer; Value: TfrxCrossSortOrder);
    procedure SetupOriginalComponent(Obj1, Obj2: TfrxComponent);
    procedure UpdateVisibility;
    procedure WriteMemos(Stream: TStream);
    function CreateMemo(Parent: TfrxComponent): TfrxCustomMemoView;
    function GetCellFunctions(Index: Integer): TfrxCrossFunction;
    function GetCellHeaderMemos(Index: Integer): TfrxCustomMemoView;
    function GetCellMemos(Index: Integer): TfrxCustomMemoView;
    function GetColumnMemos(Index: Integer): TfrxCustomMemoView;
    function GetColumnSort(Index: Integer): TfrxCrossSortOrder;
    function GetColumnTotalMemos(Index: Integer): TfrxCustomMemoView;
    function GetCornerMemos(Index: Integer): TfrxCustomMemoView;
    function GetNestedObjects: TList;
    function GetRowMemos(Index: Integer): TfrxCustomMemoView;
    function GetRowSort(Index: Integer): TfrxCrossSortOrder;
    function GetRowTotalMemos(Index: Integer): TfrxCustomMemoView;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetCellLevels(const Value: Integer); virtual;
    procedure SetColumnLevels(const Value: Integer); virtual;
    procedure SetRowLevels(const Value: Integer); virtual;
    function GetContainerObjects: TList; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure BeforePrint; override;
    procedure BeforeStartReport; override;
    procedure GetData; override;
    procedure AddSourceObjects; override;
    function ContainerAdd(Obj: TfrxComponent): Boolean; override;
    function IsContain(X, Y: Extended): Boolean; override;
    function IsAcceptAsChild(aParent: TfrxComponent): Boolean; override;
    function GetContainedComponent(X, Y: Extended; IsCanContain: TfrxComponent = nil): TfrxComponent; override;

    procedure DoMouseMove(X, Y: Integer;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); override;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure DoMouseLeave(aNextObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseEnter(aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams); override;
    function DoDragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    function DoDragDrop(Source: TObject; X, Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean; override;

    function DoMouseWheel(Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint;
      var EventParams: TfrxInteractiveEventsParams): Boolean; override;

    procedure AddValue(const Rows, Columns, Cells: array of Variant);
    procedure ApplyStyle(Style: TfrxStyles);
    procedure BeginMatrix;
    procedure EndMatrix;
    procedure FillMatrix; virtual;
    procedure GetStyle(Style: TfrxStyles);

    function ColCount: Integer;
    function DrawCross(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended): TfrxPoint;
    function GetColumnIndexes(AColumn: Integer): Variant;
    function GetRowIndexes(ARow: Integer): Variant;
    function GetValue(ARow, AColumn, ACell: Integer): Variant;
    function IsCrossValid: Boolean; virtual;
    function IsGrandTotalColumn(Index: Integer): Boolean;
    function IsGrandTotalRow(Index: Integer): Boolean;
    function IsTotalColumn(Index: Integer): Boolean;
    function IsTotalRow(Index: Integer): Boolean;
    function RowCount: Integer;
    function RowHeaderWidth: Extended;
    function ColumnHeaderHeight: Extended;

    property ColumnHeader: TfrxCrossColumnHeader read FColumnHeader;
    property RowHeader: TfrxCrossRowHeader read FRowHeader;
    property Corner: TfrxCrossCorner read FCorner;
    property NoColumns: Boolean read FNoColumns;
    property NoRows: Boolean read FNoRows;

    property CellFields: TStrings read FCellFields write SetCellFields;
    property CellFunctions[Index: Integer]: TfrxCrossFunction read GetCellFunctions
      write SetCellFunctions;
    property CellMemos[Index: Integer]: TfrxCustomMemoView read GetCellMemos;
    property CellHeaderMemos[Index: Integer]: TfrxCustomMemoView read GetCellHeaderMemos;
    property ClearBeforePrint: Boolean read FClearBeforePrint write FClearBeforePrint;
    property ColumnFields: TStrings read FColumnFields write SetColumnFields;
    property ColumnMemos[Index: Integer]: TfrxCustomMemoView read GetColumnMemos;
    property ColumnSort[Index: Integer]: TfrxCrossSortOrder read GetColumnSort
      write SetColumnSort;
    property ColumnTotalMemos[Index: Integer]: TfrxCustomMemoView read GetColumnTotalMemos;
    property CornerMemos[Index: Integer]: TfrxCustomMemoView read GetCornerMemos;
    property DotMatrix: Boolean read FDotMatrix;
    property RowFields: TStrings read FRowFields write SetRowFields;
    property RowMemos[Index: Integer]: TfrxCustomMemoView read GetRowMemos;
    property RowSort[Index: Integer]: TfrxCrossSortOrder read GetRowSort
      write SetRowSort;
    property RowTotalMemos[Index: Integer]: TfrxCustomMemoView read GetRowTotalMemos;
    property OnBeforeCalcHeight: TfrxOnCalcHeightEvent
      read FOnBeforeCalcHeight write FOnBeforeCalcHeight;
    property OnBeforeCalcWidth: TfrxOnCalcWidthEvent
      read FOnBeforeCalcWidth write FOnBeforeCalcWidth;
    property OnBeforePrintCell: TfrxOnPrintCellEvent
      read FOnBeforePrintCell write FOnBeforePrintCell;
    property OnBeforePrintColumnHeader: TfrxOnPrintHeaderEvent
      read FOnBeforePrintColumnHeader write FOnBeforePrintColumnHeader;
    property OnBeforePrintRowHeader: TfrxOnPrintHeaderEvent
      read FOnBeforePrintRowHeader write FOnBeforePrintRowHeader;
  published
    property AddHeight: Extended read FAddHeight write FAddHeight;
    property AddWidth: Extended read FAddWidth write FAddWidth;
    property AllowDuplicates: Boolean read FAllowDuplicates write FAllowDuplicates default True;
    property AutoSize: Boolean read FAutoSize write FAutoSize default True;
    property Border: Boolean read FBorder write FBorder default True;
    property CellLevels: Integer read FCellLevels write SetCellLevels default 1;
    property ColumnLevels: Integer read FColumnLevels write SetColumnLevels default 1;
    property DefHeight: Integer read FDefHeight write FDefHeight default 0;
    property DownThenAcross: Boolean read FDownThenAcross write FDownThenAcross;
    property GapX: Integer read FGapX write FGapX default 3;
    property GapY: Integer read FGapY write FGapY default 3;
    property JoinEqualCells: Boolean read FJoinEqualCells write FJoinEqualCells default False;
    property KeepTogether: Boolean read FKeepTogether write FKeepTogether default False;
    property KeepRowsTogether: Boolean read FKeepRowsTogether write FKeepRowsTogether default False;
    property MaxWidth: Integer read FMaxWidth write FMaxWidth default 200;
    property MinWidth: Integer read FMinWidth write FMinWidth default 0;
    property NextCross: TfrxCustomCrossView read FNextCross write FNextCross;
    property NextCrossGap: Extended read FNextCrossGap write FNextCrossGap;
    property PlainCells: Boolean read FPlainCells write FPlainCells default False;
    property RepeatHeaders: Boolean read FRepeatHeaders write FRepeatHeaders default True;
    property RowLevels: Integer read FRowLevels write SetRowLevels default 1;
    property ShowColumnHeader: Boolean read FShowColumnHeader write FShowColumnHeader default True;
    property ShowColumnTotal: Boolean read FShowColumnTotal write FShowColumnTotal default True;
    property ShowCorner: Boolean read FShowCorner write FShowCorner default True;
    property ShowRowHeader: Boolean read FShowRowHeader write FShowRowHeader default True;
    property ShowRowTotal: Boolean read FShowRowTotal write FShowRowTotal default True;
    property ShowTitle: Boolean read FShowTitle write FShowTitle default True;
    property SuppressNullRecords: Boolean read FSuppressNullRecords write FSuppressNullRecords default True;
    property OnCalcHeight: TfrxCalcHeightEvent read FOnCalcHeight write FOnCalcHeight;
    property OnCalcWidth: TfrxCalcWidthEvent read FOnCalcWidth write FOnCalcWidth;
    property OnPrintCell: TfrxPrintCellEvent read FOnPrintCell write FOnPrintCell;
    property OnPrintColumnHeader: TfrxPrintHeaderEvent
      read FOnPrintColumnHeader write FOnPrintColumnHeader;
    property OnPrintRowHeader: TfrxPrintHeaderEvent
      read FOnPrintRowHeader write FOnPrintRowHeader;
  end;

{$IFDEF FR_COM}
  TfrxCrossView = class(TfrxCustomCrossView, IfrxCrossView)
{$ELSE}
  TfrxCrossView = class(TfrxCustomCrossView)
{$ENDIF}
  protected
    procedure SetCellLevels(const Value: Integer); override;
    procedure SetColumnLevels(const Value: Integer); override;
    procedure SetRowLevels(const Value: Integer); override;
  public
    class function GetDescription: String; override;
    function IsCrossValid: Boolean; override;
  published
  end;

{$IFDEF FR_COM}
  TfrxDBCrossView = class(TfrxCustomCrossView, IfrxDBCrossView)
{$ELSE}
  TfrxDBCrossView = class(TfrxCustomCrossView)
{$ENDIF}
  private
  public
    class function GetDescription: String; override;
    function IsCrossValid: Boolean; override;
    procedure FillMatrix; override;
  published
    property CellFields;
    property ColumnFields;
    property DataSet;
    property DataSetName;
    property RowFields;
  end;

{$IFDEF FPC}
//  procedure Register;
{$ENDIF}

implementation

uses
{$IFNDEF NO_EDITORS}
  frxCrossEditor,
{$ENDIF}
{$IFNDEF NO_INLINE_EDITORS}
  frxCrossInPlaceEditor,
{$ENDIF}
  frxCrossRTTI, frxDsgnIntf, frxXML, frxUtils, frxXMLSerializer, frxRes,
  frxDMPClass, frxVariables, frxUnicodeUtils, Math;

type
  THackComponent = class(TfrxComponent);
  THackReportComponent = class(TfrxReportComponent);
  THackMemoView = class(TfrxCustomMemoView);


function CalcSize(m: TfrxCustomMemoView): TfrxPoint;
var
  e, SaveHeight: Extended;
  r: integer;
begin
  SaveHeight := m.Height;
  m.Height := 10000;
  r := m.Rotation;
  m.Rotation := 0;
  try
    Result.X := m.CalcWidth;
    Result.Y := m.CalcHeight;
  finally
    m.Rotation := r;
  end;

  if m is TfrxDMPMemoView then
  begin
    Result.X := Result.X + fr1CharX;
    Result.Y := Result.Y + fr1CharY;
  end;

  if (m.Rotation = 90) or (m.Rotation = 270) then
  begin
    e := Result.X;
    Result.X := Result.Y;
    Result.Y := e;
  end;

  m.Height := SaveHeight;
end;


{ TfrxIndexItem }

destructor TfrxIndexItem.Destroy;
begin
  FIndexes := nil;
  inherited;
end;


{ TfrxIndexCollection }

function TfrxIndexCollection.GetItems(Index: Integer): TfrxIndexItem;
begin
  Result := TfrxIndexItem(inherited Items[Index]);
end;

function TfrxIndexCollection.Find(const Indexes: array of Variant;
  var Index: Integer): Boolean;
var
  i, i0, i1, c: Integer;
  Item: TfrxIndexItem;

{compare function returns > 2 to keep equal columns/rows together without sorting}
  function Compare: Integer;
  var
    i: Integer;
  begin
    Result := 1;
    for i := 0 to FIndexesCount - 1 do
      if Item.Indexes[i] = Indexes[i] then
      begin
        if (VarType(Indexes[i]) = varString) or (VarType(Indexes[i]) = varOleStr)
{$IFDEF Delphi12}or (VarType(Indexes[i]) = varUString){$ENDIF} then
          if VarToWideStr(Item.Indexes[i]) = VarToWideStr(Indexes[i]) then
            Result := 0
          else
          begin
            Result := -1;
            break;
          end
        else
          Result := 0;
      end
      else if (Result = 0) and (FSortOrder[0] = {soNone} soGrouping) then
      begin
          Result := i + 2;
          break;
      end
      else if VarIsNull(Indexes[i]) then
      begin
        if FSortOrder[i] = soAscending then
          Result := 1 else
          Result := -1;
        break;
      end
      else if VarIsNull(Item.Indexes[i]) then
      begin
        if FSortOrder[i] = soAscending then
          Result := -1 else
          Result := 1;
        break;
      end
      else if Item.Indexes[i] > Indexes[i] then
      begin
        if FSortOrder[i] = soAscending then
          Result := 1 else
          Result := -1;
        break;
      end
      else if Item.Indexes[i] < Indexes[i] then
      begin
        if FSortOrder[i] = soAscending then
          Result := -1 else
          Result := 1;
        break;
      end;
  end;

begin
  Result := False;
  if FSortOrder[0] in [soNone, soGrouping] then
  begin
    i0 := 0;
    Index := Count;
    for i := 0 to Count - 1 do
    begin
      Item := TfrxIndexItem(Items[i]);
      c := Compare;
      if c = 0 then
      begin
        Result := True;
        Index := i;
        Exit;
      end else if (c > 2) and (i0 <= c) then {place same colums together}
      begin
        Index := i + 1;
        i0 := c;
      end;
    end;
    Exit;
  end;

  { quick find }
  i0 := 0;
  i1 := Count - 1;

  while i0 <= i1 do
  begin
    i := (i0 + i1) div 2;
    Item := TfrxIndexItem(Items[i]);
    c := Compare;

    if c < 0 then
      i0 := i + 1
    else
    begin
      i1 := i - 1;
      if c = 0 then
      begin
        Result := True;
        i0 := i;
      end;
    end;
  end;

  Index := i0;
end;

function TfrxIndexCollection.InsertItem(Index: Integer;
  const Indexes: array of Variant): TfrxIndexItem;
var
  i: Integer;
begin
  if Index < Count then
    Result := TfrxIndexItem(Insert(Index)) else
    Result := TfrxIndexItem(Add);
  SetLength(Result.FIndexes, FIndexesCount);
  for i := 0 to FIndexesCount - 1 do
    Result.FIndexes[i] := Indexes[i];
end;


{ TfrxCrossRow }

constructor TfrxCrossRow.Create;
begin
  inherited;
  FCells := TList.Create;
end;

destructor TfrxCrossRow.Destroy;
var
  i: Integer;
  c, c1: PfrCrossCell;
begin
  for i := 0 to FCells.Count - 1 do
  begin
    c := FCells[i];
    while c <> nil do
    begin
      c1 := c;
      c := c.Next;
      VarClear(c1.Value);
      Dispose(c1);
    end;
  end;

  FCells.Free;
  inherited;
end;

procedure TfrxCrossRow.CreateCell(Index: Integer);
var
  i: Integer;
  c, c1: PfrCrossCell;
begin
  while Index >= FCells.Count do
  begin
    c1 := nil;
    for i := 0 to FCellLevels - 1 do
    begin
      New(c);
      c.Value := Null;
      c.Count := 1;
      c.Next := nil;
      if c1 <> nil then
        c1.Next := c else
        FCells.Add(c);
      c1 := c;
    end;
  end;
end;

function TfrxCrossRow.GetCellValue(Index1, Index2: Integer): Variant;
var
  c: PfrCrossCell;
begin
  Result := Null;
  if (Index1 < 0) or (Index1 >= FCells.Count) then Exit;

  c := FCells[Index1];
  while (c <> nil) and (Index2 > 0) do
  begin
    c := c.Next;
    Dec(Index2);
  end;

  if c <> nil then
    Result := c.Value;
end;

procedure TfrxCrossRow.SetCellValue(Index1, Index2: Integer; const Value: Variant);
var
  c: PfrCrossCell;
begin
  if Index1 < 0 then Exit;
  if Index1 >= FCells.Count then
    CreateCell(Index1);

  c := FCells[Index1];
  while (c <> nil) and (Index2 > 0) do
  begin
    c := c.Next;
    Dec(Index2);
  end;
  if c <> nil then
    if c.Value = Null then
      c.Value := Value else
      c.Value := c.Value + Value;
end;

function TfrxCrossRow.GetCell(Index: Integer): PfrCrossCell;
begin
  Result := nil;
  if Index < 0 then Exit;

  if Index >= FCells.Count then
    CreateCell(Index);

  Result := FCells[Index];
end;


{ TfrxCrossRows }

constructor TfrxCrossRows.Create;
begin
  inherited Create(TfrxCrossRow);
end;

function TfrxCrossRows.GetItems(Index: Integer): TfrxCrossRow;
begin
  Result := TfrxCrossRow(inherited Items[Index]);
end;

function TfrxCrossRows.InsertItem(Index: Integer;
  const Indexes: array of Variant): TfrxIndexItem;
begin
  Result := inherited InsertItem(Index, Indexes);
  TfrxCrossRow(Result).FCellLevels := FCellLevels;
end;

function TfrxCrossRows.Row(const Indexes: array of Variant): TfrxCrossRow;
var
  i: Integer;
begin
  if Find(Indexes, i) then
    Result := Items[i] else
    Result := TfrxCrossRow(InsertItem(i, Indexes));
end;


{ TfrxCrossColumns }

constructor TfrxCrossColumns.Create;
begin
  inherited Create(TfrxCrossColumn);
end;

function TfrxCrossColumns.GetItems(Index: Integer): TfrxCrossColumn;
begin
  Result := TfrxCrossColumn(inherited Items[Index]);
end;

function TfrxCrossColumns.Column(const Indexes: array of Variant): TfrxCrossColumn;
var
  i: Integer;
begin
  if Find(Indexes, i) then
    Result := Items[i] else
    Result := TfrxCrossColumn(InsertItem(i, Indexes));
end;

function TfrxCrossColumns.InsertItem(Index: Integer;
  const Indexes: array of Variant): TfrxIndexItem;
begin
  Result := inherited InsertItem(Index, Indexes);
  TfrxCrossColumn(Result).FCellIndex := Count - 1;
end;


{ TfrxCrossHeader }

constructor TfrxCrossHeader.Create(CellLevels: Integer);
begin
  FItems := TList.Create;
  FCellLevels := CellLevels;
  FValue := Null;
  FVisible := True;

  SetLength(FFuncValues, FCellLevels);
  SetLength(FCounts, FCellLevels);
  FDefaultHeight := 0;
end;

destructor TfrxCrossHeader.Destroy;
begin
  FFuncValues := nil;
  FCounts := nil;

  while FItems.Count > 0 do
  begin
    TfrxCrossHeader(FItems[0]).Free;
    FItems.Delete(0);
  end;

  FItems.Free;
  inherited;
end;

function TfrxCrossHeader.GetItems(Index: Integer): TfrxCrossHeader;
begin
  Result := TfrxCrossHeader(FItems[Index]);
end;

function TfrxCrossHeader.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TfrxCrossHeader.GetLevel: Integer;
var
  h: TfrxCrossHeader;
begin
  Result := -2;
  h := Self;

  while h <> nil do
  begin
    h := h.Parent;
    Inc(Result);
  end;
end;

function TfrxCrossHeader.Find(Value: Variant): Integer;
var
  i: Integer;
begin
  { find the cell containing the given value }
  Result := -1;
  for i := 0 to Count - 1 do
    if VarToWideStr(Items[i].Value) = VarToWideStr(Value) then
    begin
      Result := i;
      Exit;
    end;
end;

function TfrxCrossHeader.AddChild(Memo: TfrxCustomMemoView): TfrxCrossHeader;
begin
  Result := TfrxCrossHeader(NewInstance);
  Result.Create(FCellLevels);
  { link it to the parent }
  FItems.Add(Result);
  Result.FParent := Self;

  Result.FLevelsCount := FLevelsCount;
  Result.FMemo := Memo;
  Result.FValue := Memo.Text;
end;

function TfrxCrossHeader.AddCellHeader(Memos: TList; Index, CellIndex: Integer): TfrxCrossHeader;
begin
  Result := TfrxCrossHeader(NewInstance);
  Result.Create(FCellLevels);
  { link it to the parent }
  FItems.Add(Result);
  Result.FParent := Self;

  Result.FIndex := Index;
  Result.FCellIndex := CellIndex;
  Result.FLevelsCount := FLevelsCount;
  Result.FIsTotal := FIsTotal;
  Result.FTotalIndex := FTotalIndex;
  Result.FMemo := Memos[FTotalIndex * FCellLevels + CellIndex];
  Result.FValue := Result.FMemo.Text;
  Result.FIsCellHeader := True;
end;

procedure TfrxCrossHeader.AddValues(const Values: array of Variant; Unsorted: Boolean);
var
  i, j: Integer;
  Header, Header1: TfrxCrossHeader;
  v: Variant;
  s: String;
begin
  { create the header tree. For example, subsequent calls
      AddValues([1998,1]);
      AddValues([1998,2]);
      AddValues([1999,1]);
    will create the header
      1998 | 1999
      --+--+-----
      1 |2 | 1                }


  Header := Self;

  for i := Low(Values) to High(Values) do
  begin
    {unsorted mode join same cells only for consecutive values}
    if Unsorted then
    begin
      j := Header.Count;
      if (j > 0) and
        (VarToWideStr(Header.Items[Header.Count - 1].Value) = VarToWideStr(Values[i])) then
       dec(j)
      else j := -1;
    end
    else j := Header.Find(Values[i]);
    if j <> -1 then
      Header := Header.Items[j]   { find existing item... }
    else
    begin
      { ...or create new one }
      Header1 := TfrxCrossHeader(NewInstance);
      Header1.Create(FCellLevels);
      Header1.FLevelsCount := FLevelsCount;
      { link it to the parent }
      Header.FItems.Add(Header1);
      Header1.FParent := Header;

      v := Values[i];
      s := VarToStr(v);
      { this is subtotal item }
      if Pos('@@@', s) = 1 then
      begin
        { remove @@@ }
        s := Copy(s, 4, Length(s) - 5);
        v := s;
        Header1.FIsTotal := True;
        Header1.FMemo := FTotalMemos[i];
        Header1.FTotalIndex := FLevelsCount - i;
      end
      else
        Header1.FMemo := FMemos[i];

      Header1.FValue := v;
      Header := Header1;

      if Header.FIsTotal then break;
    end;
  end;
end;

procedure TfrxCrossHeader.Reset(const CellFunctions: array of TfrxCrossFunction);
var
  i: Integer;
  h: TfrxCrossHeader;
begin
  { reset aggregate values for this cell and all its parent cells }
  h := Self;

  while h <> nil do
  begin
    for i := 0 to FCellLevels - 1 do
    begin
      case CellFunctions[i] of
        cfNone, cfMin, cfMax:
          h.FFuncValues[i] := Null;

        cfSum, cfAvg, cfCount:
          h.FFuncValues[i] := 0;
      end;

      h.FCounts[i] := 0;
    end;

    h := h.Parent;
  end;
end;

procedure TfrxCrossHeader.AddFuncValues(const Values, Counts: array of Variant;
  const CellFunctions: array of TfrxCrossFunction);
var
  i: Integer;
  h: TfrxCrossHeader;
begin
  { add aggregate values for this cell and all its parent cells }
  h := Self;

  while h <> nil do
  begin
    for i := 0 to FCellLevels - 1 do
      if Values[i] <> Null then
        case CellFunctions[i] of
          cfNone:;

          cfSum:
            h.FFuncValues[i] := h.FFuncValues[i] + Values[i];

          cfMin:
            if (h.FFuncValues[i] = Null) or (Values[i] < h.FFuncValues[i]) then
              h.FFuncValues[i] := Values[i];

          cfMax:
            if (h.FFuncValues[i] = Null) or (Values[i] > h.FFuncValues[i]) then
              h.FFuncValues[i] := Values[i];

          cfAvg:
            begin
              h.FFuncValues[i] := h.FFuncValues[i] + Values[i];
              h.FCounts[i] := h.FCounts[i] + Counts[i];
            end;

          cfCount:
            h.FFuncValues[i] := h.FFuncValues[i] + Values[i];// + Counts[i];
        end;

    h := h.Parent;
  end;
end;

function TfrxCrossHeader.AllItems: TList;

  procedure EnumItems(Item: TfrxCrossHeader);
  var
    i: Integer;
  begin
    if Item.Memo <> nil then
      Result.Add(Item);
    for i := 0 to Item.Count - 1 do
      EnumItems(Item[i]);
  end;

begin
  { list all items in the header }
  Result := TList.Create;
  EnumItems(Self);
end;

function TfrxCrossHeader.TerminalItems: TList;
var
  i: Integer;
  Item: TfrxCrossHeader;
begin
  { list all terminal items in the header }
  Result := AllItems;
  i := 0;
  while i < Result.Count do
  begin
    Item := Result[i];
    if Item.Count = 0 then
      Inc(i)
    else
      Result.Delete(i);
  end;
end;

function TfrxCrossHeader.IndexItems: TList;
var
  i: Integer;
  Item: TfrxCrossHeader;
begin
  { list all terminal items in the header }
  Result := AllItems;
  i := 0;
  while i < Result.Count do
  begin
    Item := Result[i];
    if Item.FIsIndex then
      Inc(i)
    else
      Result.Delete(i);
  end;
end;

function TfrxCrossHeader.GetIndexes: Variant;
var
  ar: array of Variant;
  i, n: Integer;
  h, h1: TfrxCrossHeader;
begin
  SetLength(ar, FLevelsCount + 1);
  n := 0;
  h := Parent;
  h1 := Self;
  while h <> nil do
  begin
    ar[n] := h.FItems.IndexOf(h1);
    Inc(n);
    h1 := h;
    h := h.Parent;
  end;

  Result := VarArrayCreate([0, FLevelsCount - 1], varVariant);
  for i := 0 to FLevelsCount - 1 do
    if i < n then
      Result[i] := ar[n - i - 1] else
      Result[i] := Null;
  ar := nil;
end;

function TfrxCrossHeader.GetValues: Variant;
var
  ar: array of Variant;
  i, n: Integer;
  h: TfrxCrossHeader;
begin
  SetLength(ar, FLevelsCount + 1);
  n := 0;
  h := Self;
  while h.Parent <> nil do
  begin
    ar[n] := h.Value;
    Inc(n);
    h := h.Parent;
  end;

  Result := VarArrayCreate([0, FLevelsCount - 1], varVariant);
  for i := 0 to FLevelsCount - 1 do
    if i < n then
      Result[i] := ar[n - i - 1] else
      Result[i] := Null;
  ar := nil;
end;

function TfrxCrossHeader.GetHeight: Extended;
var
  Items: TList;
begin
  Items := TerminalItems;

  if (Items.Count > 0) and FVisible then
    Result := TfrxCrossHeader(Items[Items.Count - 1]).Bounds.Top +
      TfrxCrossHeader(Items[Items.Count - 1]).Bounds.Bottom
  else
    Result := 0;

  Items.Free;
end;

function TfrxCrossHeader.GetWidth: Extended;
var
  Items: TList;
begin
  Items := TerminalItems;

  if (Items.Count > 0) and FVisible then
    Result := TfrxCrossHeader(Items[Items.Count - 1]).Bounds.Left +
      TfrxCrossHeader(Items[Items.Count - 1]).Bounds.Right
  else
    Result := 0;

  Items.Free;
end;


{ TfrxCrossColumnHeader }

procedure TfrxCrossColumnHeader.CalcBounds;
var
  i, j, l: Integer;
  h, hAvg: Extended;
  Items: TList;
  Item: TfrxCrossHeader;
  LevelHeights: array of Extended;

  function DoAdjust(Item: TfrxCrossHeader): Extended;
  var
    i: Integer;
    Width: Extended;
  begin
    if Item.Count = 0 then
    begin
      Result := Item.FSize.X;
      Exit;
    end;

    Width := 0;
    for i := 0 to Item.Count - 1 do
      Width := Width + DoAdjust(Item[i]);

    if Item.FSize.X < Width then
      Item.FSize.X := Width
    else
    begin
      Item[Item.Count - 1].FSize.X := Item[Item.Count - 1].FSize.X + Item.FSize.X - Width;
      DoAdjust(Item[Item.Count - 1]);
    end;

    Result := Item.FSize.X;
  end;

  procedure FillBounds(Item: TfrxCrossHeader; Offset: TfrxPoint);
  var
    i, j, l: Integer;
    h: Extended;
  begin
    l := Item.Level;
    if l <> -1 then
      h := LevelHeights[l] else
      h := Item.FSize.Y;

    if Item.FIsCellHeader then
      h := LevelHeights[FLevelsCount]
    else if Item.IsTotal then
      for j := l + 1 to FLevelsCount - 1 do
        h := h + LevelHeights[j];

    Item.FBounds := frxRect(Offset.X, Offset.Y, Item.FSize.X, h);
    Offset.Y := Offset.Y + h;

    for i := 0 to Item.Count - 1 do
    begin
      FillBounds(Item[i], Offset);
      Offset.X := Offset.X + Item[i].FSize.X;
    end;
  end;

begin
  DoAdjust(Self);

  SetLength(LevelHeights, FLevelsCount + 1);

  Items := AllItems;

// calculate height of each row
  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    l := Item.Level;

    // cell headers always adjust the last level height
    if Item.FIsCellHeader then
      l := FLevelsCount
    // don't count total elemens unless they are on last level.
    // such elements will be adjusted later
    else if Item.IsTotal then
      if l <> FLevelsCount - 1 then continue;

    if l >= 0 then
      if Item.FSize.Y > LevelHeights[l] then
        LevelHeights[l] := Item.FSize.Y;
  end;

  if FNoLevels then
    LevelHeights[0] := 0;

// adjust level height - count totals that not on the last level
  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    l := Item.Level;

    if Item.IsTotal and (l < FLevelsCount - 1) then
    begin
      h := 0;
      for j := l to FLevelsCount - 1 do
        h := h + LevelHeights[j];

      if Item.FSize.Y > h then
        LevelHeights[FLevelsCount - 1] := LevelHeights[FLevelsCount - 1] + Item.FSize.Y - h;
    end;
  end;

  { syncronize height of CornerMemos[0] and [1] }
  if FCorner <> nil then
  begin
    if not FMemo.Visible then
      FSize.Y := 0;
    if not FCorner.FMemo.Visible then
      FCorner.FSize.Y := 0;
    h := FSize.Y;
    if FCorner.FSize.Y > h then
      h := FCorner.FSize.Y;
    FSize.Y := h;
    if not FNoLevels then
      FCorner.FSize.Y := h;
  end;

  //FillBounds(Self, frxPoint(0, 0));

  { update height of CornerMemos[2..n] }
  if FCorner <> nil then
  begin
    h := 0;
    l := FLevelsCount - 1;
    if HasCellHeaders then
      Inc(l);
    for i := 0 to l do
      h := h + LevelHeights[i];
    if FNoLevels then
      h := h + FSize.Y;

    for i := 0 to FCorner.Count - 1 do
      if FCorner[i].FSize.Y > h then
      begin
        if l = 0 then
         if TfrxCrossHeader(Items[0]).Memo.Visible then
            TfrxCrossHeader(Items[0]).FSize.Y := FCorner[i].FSize.Y
        else
        begin
           hAvg := (FCorner[i].FSize.Y - h) / (l + 1);
           for j := 0 to l do
            LevelHeights[j] := LevelHeights[j] + hAvg; {normalize columns height}
        end;
      end
      else FCorner[i].FSize.Y := h;
  end;

  FillBounds(Self, frxPoint(0, 0));
  Items.Free;
  LevelHeights := nil;

end;

procedure TfrxCrossColumnHeader.CalcSizes(MaxWidth, MinWidth: Integer; AutoSize: Boolean);
var
  i: Integer;
  Items: TList;
  Item: TfrxCrossHeader;
  s: WideString;
  m: TfrxCustomMemoView;
  DefHeaderSize: Extended;
  aMaxWidth, aMinWidth: Integer;
begin
  Items := AllItems;
  DefHeaderSize := 0;
  aMaxWidth := MaxWidth;
  aMinWidth := MinWidth;
  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    if (MaxWidth = -1) then
    begin
      if not Item.FRecalcSizes then Continue;
      Item.FRecalcSizes := False;
      aMaxWidth := Round(Item.FSize.X);
      aMinWidth := Round(Item.FSize.X);
    end;

    m := Item.FMemo;
    if m <> nil then
    begin
      if AutoSize or (((m.Width = 0) or (m.Height = 0)) and m.Visible) then
      begin
        m.Width := aMaxWidth;
        s := m.Text;
        m.Text := m.FormatData(Item.Value);
        if m.Lines.Count = 0 then
          m.Text := ' ';
        Item.FSize := CalcSize(m);
        m.Text := s;
      end
      else
      begin
        if (Item.Count = 0) or (Item.Count = 1) then
          Item.FSize.X := m.Width;
        if not Item.IsTotal then
          Item.FSize.Y := m.Height;
      end;

      if Item.FSize.X < aMinWidth then
        Item.FSize.X := aMinWidth;
      if Item.FSize.X > aMaxWidth then
        Item.FSize.X := aMaxWidth;
      if Item.DefaultHeight > 0 then
        DefHeaderSize := Item.DefaultHeight;
      if(DefHeaderSize > 0) then
        if i <  Items.Count - 1 then
          DefHeaderSize := DefHeaderSize - Item.FSize.Y
        else if (i =  Items.Count - 1) then

        begin
          if Item.FSize.Y < DefHeaderSize then
            Item.FSize.Y := DefHeaderSize
        end;
    end;
  end;

  Items.Free;
end;


{ TfrxCrossRowHeader }

procedure TfrxCrossRowHeader.CalcBounds;
var
  i, j, l: Integer;
  w: Extended;
  Items: TList;
  Item: TfrxCrossHeader;
  LevelWidths: array of Extended;

  function DoAdjust(Item: TfrxCrossHeader; HideNested: Boolean = false): Extended;
  var
    i: Integer;
    Height: Extended;
  begin
    if Item.Count = 0 then
    begin
      if HideNested then
        Item.FSize.Y := 0;
      Result := Item.FSize.Y;
      Exit;
    end;

    Height := 0;
    for i := 0 to Item.Count - 1 do
      Height := Height + DoAdjust(Item[i], ((not Item.Visible) and (Item.Parent <> nil)) or HideNested);

    if Item.FSize.Y < Height then
      Item.FSize.Y := Height
    else
    begin
      Item[Item.Count - 1].FSize.Y := Item[Item.Count - 1].FSize.Y + Item.FSize.Y - Height;
      DoAdjust(Item[Item.Count - 1]);
    end;

    Result := Item.FSize.Y;
  end;

  procedure FillBounds(Item: TfrxCrossHeader; Offset: TfrxPoint);
  var
    i, j, l: Integer;
    w: Extended;
  begin
    l := Item.Level;
    if l <> -1 then
      w := LevelWidths[l] else
      w := Item.FSize.X;

    if Item.FIsCellHeader then
      w := LevelWidths[FLevelsCount]
    else if Item.IsTotal then
      for j := l + 1 to FLevelsCount - 1 do
        w := w + LevelWidths[j];

    Item.FBounds := frxRect(Offset.X, Offset.Y, w, Item.FSize.Y);
    Offset.X := Offset.X + w;

    for i := 0 to Item.Count - 1 do
    begin
      FillBounds(Item[i], Offset);
      Offset.Y := Offset.Y + Item[i].FSize.Y;
    end;
  end;

begin
  DoAdjust(Self);

  SetLength(LevelWidths, FLevelsCount + 1);

  Items := AllItems;

// calculate maxwidth of each row
  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    l := Item.Level;

    // cell headers always adjust the last level width
    if Item.FIsCellHeader then
      l := FLevelsCount
    // don't count total elemens unless they are on last level.
    // such elements will be adjusted later
    else if Item.IsTotal then
      if l <> FLevelsCount - 1 then continue;

    if l >= 0 then
      if Item.FSize.X > LevelWidths[l] then
        LevelWidths[l] := Item.FSize.X;
  end;

// adjust totals
  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    l := Item.Level;

    if Item.IsTotal and (l < FLevelsCount - 1) then
    begin
      w := 0;
      for j := l to FLevelsCount - 1 do
        w := w + LevelWidths[j];

      if Item.FSize.X > w then
        LevelWidths[FLevelsCount - 1] := LevelWidths[FLevelsCount - 1] + Item.FSize.X - w;
    end;
  end;

// adjust corner
  for i := 0 to FCorner.Count - 1 do
    if FCorner[i].FSize.X > LevelWidths[i] then
      LevelWidths[i] := FCorner[i].FSize.X
    else
      FCorner[i].FSize.X := LevelWidths[i];

  FillBounds(Self, frxPoint(0, 0));

  Items.Free;
  LevelWidths := nil;
end;

procedure TfrxCrossRowHeader.CalcSizes(MaxWidth, MinWidth: Integer; AutoSize: Boolean);
var
  i: Integer;
  Items: TList;
  Item: TfrxCrossHeader;
  s: WideString;
  m: TfrxCustomMemoView;
begin
  Items := AllItems;

  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    m := Item.FMemo;
    if m <> nil then
    begin
      if AutoSize or (((m.Width = 0) or (m.Height = 0)) and m.Visible) then
      begin
        m.Width := MaxWidth;
        s := m.Text;
        m.Text := m.FormatData(Item.Value);
        if m.Lines.Count = 0 then
          m.Text := ' ';
        Item.FSize := CalcSize(m);
        m.Text := s;
      end
      else
      begin
        if Item.Count = 0 then
          Item.FSize.Y := m.Height;
        if not Item.IsTotal then
          Item.FSize.X := m.Width;
      end;

      if Item.FSize.X < MinWidth then
        Item.FSize.X := MinWidth;
      if Item.FSize.X > MaxWidth then
        Item.FSize.X := MaxWidth;
    end;
  end;

  Items.Free;
end;


{ TfrxCutBandItem }

destructor TfrxCutBandItem.Destroy;
begin
  Band.Free;
  inherited;
end;


{ TfrxCutBands }

constructor TfrxCutBands.Create;
begin
  inherited Create(TfrxCutBandItem);
end;

procedure TfrxCutBands.Add(ABand: TfrxBand; AFromIndex, AToIndex: Integer);
begin
  with TfrxCutBandItem(inherited Add) do
  begin
    Band := ABand;
    FromIndex := AFromIndex;
    ToIndex := AToIndex;
  end;
end;

function TfrxCutBands.GetItems(Index: Integer): TfrxCutBandItem;
begin
  Result := TfrxCutBandItem(inherited Items[Index]);
end;


{ TfrxGridLineItem }

constructor TfrxGridLineItem.Create(Collection: TCollection);
begin
  inherited;
  Objects := TList.Create;
end;

destructor TfrxGridLineItem.Destroy;
begin
  Objects.Free;
  inherited;
end;


{ TfrxGridLines }

constructor TfrxGridLines.Create;
begin
  inherited Create(TfrxGridLineItem);
end;

procedure TfrxGridLines.Add(AObj: TObject; ACoord: Extended);
var
  i: Integer;
  Item: TfrxGridLineItem;
begin
  Item := nil;
  for i := 0 to Count - 1 do
    if Abs(Items[i].Coord - ACoord) < 1 then
    begin
      Item := Items[i];
      break;
    end;

  if Item = nil then
    Item := TfrxGridLineItem(inherited Add);

  Item.Coord := ACoord;
  Item.Objects.Add(AObj);
end;

function TfrxGridLines.GetItems(Index: Integer): TfrxGridLineItem;
begin
  Result := TfrxGridLineItem(inherited Items[Index]);
end;


{ TfrxCustomCrossView }

constructor TfrxCustomCrossView.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited;
  Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
  Color := clWhite;
  frComponentStyle := frComponentStyle - [csPreviewVisible] + [csContainer];

  FAllMemos := TList.Create;
  FCellMemos := TList.Create;
  FCellHeaderMemos := TList.Create;
  FColumnMemos := TList.Create;
  FColumnTotalMemos := TList.Create;
  FCornerMemos := TList.Create;
  FRowMemos := TList.Create;
  FRowTotalMemos := TList.Create;

  FCellFields := TStringList.Create;
  FColumnFields := TStringList.Create;
  FRowFields := TStringList.Create;
  FColumnBands := TfrxCutBands.Create;
  FRowBands := TfrxCutBands.Create;

  FGridX := TfrxGridLines.Create;
  FGridY := TfrxGridLines.Create;

  FAutoSize := True;
  FBorder := True;
  FGapX := 3;
  FGapY := 3;
  FMaxWidth := 200;
  FRepeatHeaders := True;
  FShowColumnHeader := True;
  FShowColumnTotal := True;
  FShowRowHeader := True;
  FShowRowTotal := True;
  FShowCorner := True;
  FShowTitle := True;
  FAllowDuplicates := True;
  FClearBeforePrint := True;
  FSuppressNullRecords := True;
  FShowMoveArrow := False;

  SetDotMatrix(Page is TfrxDMPPage);
  CreateCornerMemos(3);
  CellLevels := 1;
  ColumnLevels := 1;
  RowLevels := 1;

  for i := 0 to 63 do
  begin
    FCellFunctions[i] := cfSum;
    FColumnSort[i] := soAscending;
    FRowSort[i] := soAscending;
  end;
end;

destructor TfrxCustomCrossView.Destroy;
begin
  ClearMemos;
  FAllMemos.Free;
  FCellMemos.Free;
  FCellHeaderMemos.Free;
  FColumnMemos.Free;
  FColumnTotalMemos.Free;
  FCornerMemos.Free;
  FRowMemos.Free;
  FRowTotalMemos.Free;

  FCellFields.Free;
  FColumnFields.Free;
  FRowFields.Free;

  FColumnBands.Free;
  FRowBands.Free;
  FGridX.Free;
  FGridY.Free;

  ClearMatrix;
  inherited;
end;

function TfrxCustomCrossView.GetCellFunctions(Index: Integer): TfrxCrossFunction;
begin
  Result := FCellFunctions[Index];
end;

function TfrxCustomCrossView.GetCellMemos(Index: Integer): TfrxCustomMemoView;
begin
  Result := FCellMemos[Index];
end;

function TfrxCustomCrossView.GetCellHeaderMemos(Index: Integer): TfrxCustomMemoView;
begin
  Result := FCellHeaderMemos[Index];
end;

function TfrxCustomCrossView.GetColumnMemos(Index: Integer): TfrxCustomMemoView;
begin
  Result := FColumnMemos[Index];
end;

function TfrxCustomCrossView.GetColumnTotalMemos(Index: Integer): TfrxCustomMemoView;
begin
  Result := FColumnTotalMemos[Index];
end;

function TfrxCustomCrossView.GetCornerMemos(Index: Integer): TfrxCustomMemoView;
begin
  Result := FCornerMemos[Index];
end;

function TfrxCustomCrossView.GetRowMemos(Index: Integer): TfrxCustomMemoView;
begin
  Result := FRowMemos[Index];
end;

function TfrxCustomCrossView.GetRowTotalMemos(Index: Integer): TfrxCustomMemoView;
begin
  Result := FRowTotalMemos[Index];
end;

function TfrxCustomCrossView.GetColumnSort(Index: Integer): TfrxCrossSortOrder;
begin
  Result := FColumnSort[Index];
end;

function TfrxCustomCrossView.GetRowSort(Index: Integer): TfrxCrossSortOrder;
begin
  Result := FRowSort[Index];
end;

procedure TfrxCustomCrossView.SetCellFunctions(Index: Integer;
  const Value: TfrxCrossFunction);
begin
  FCellFunctions[Index] := Value;
end;

procedure TfrxCustomCrossView.SetColumnSort(Index: Integer; Value: TfrxCrossSortOrder);
begin
  FColumnSort[Index] := Value;
end;

procedure TfrxCustomCrossView.SetRowSort(Index: Integer; Value: TfrxCrossSortOrder);
begin
  FRowSort[Index] := Value;
end;

function TfrxCustomCrossView.ColCount: Integer;
begin
  Result := FColumns.Count;
end;

function TfrxCustomCrossView.RowCount: Integer;
begin
  Result := FRows.Count;
end;

function TfrxCustomCrossView.IsGrandTotalColumn(Index: Integer): Boolean;
begin
  Result := Index = FColumns.Count - 1;
end;

function TfrxCustomCrossView.IsGrandTotalRow(Index: Integer): Boolean;
begin
  Result := Index = FRows.Count - 1;
end;

function TfrxCustomCrossView.IsTotalColumn(Index: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to FColumns.FIndexesCount - 1 do
    if VarToStr(FColumns[Index].Indexes[i]) = '@@@' then
      Result := True;
end;

function TfrxCustomCrossView.IsTotalRow(Index: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to FRows.FIndexesCount - 1 do
    if VarToStr(FRows[Index].Indexes[i]) = '@@@' then
      Result := True;
end;

function TfrxCustomCrossView.GetColumnIndexes(AColumn: Integer): Variant;
begin
  Result := FColumns[AColumn].Indexes;
end;

function TfrxCustomCrossView.GetRowIndexes(ARow: Integer): Variant;
begin
  Result := FRows[ARow].Indexes;
end;

procedure TfrxCustomCrossView.SetCellFields(const Value: TStrings);
begin
  FCellFields.Assign(Value);
end;

procedure TfrxCustomCrossView.SetColumnFields(const Value: TStrings);
begin
  FColumnFields.Assign(Value);
end;

procedure TfrxCustomCrossView.SetRowFields(const Value: TStrings);
begin
  FRowFields.Assign(Value);
end;

procedure TfrxCustomCrossView.SetCellLevels(const Value: Integer);
var
  max: Integer;
begin
  if Value > 64 then exit;
  FCellLevels := Value;
  CreateCellMemos(FCellLevels * (FRowLevels + 1) * (FColumnLevels + 1));
  max := FRowLevels;
  if FColumnLevels > max then
    max := FColumnLevels;
  CreateCellHeaderMemos(FCellLevels * (max + 1));
end;

procedure TfrxCustomCrossView.SetColumnLevels(const Value: Integer);
var
  max, lvl: Integer;
begin
  if Value > 64 then exit;
  FColumnLevels := Value;
  lvl := FColumnLevels;
  if lvl = 0 then
    lvl := 1;
  CreateColumnMemos(lvl);
  CreateCellMemos(FCellLevels * (FRowLevels + 1) * (FColumnLevels + 1));
  max := FRowLevels;
  if FColumnLevels > max then
    max := FColumnLevels;
  CreateCellHeaderMemos(FCellLevels * (max + 1));
end;

procedure TfrxCustomCrossView.SetRowLevels(const Value: Integer);
var
  max, lvl: Integer;
begin
  if Value > 64 then exit;
  FRowLevels := Value;
  lvl := FRowLevels;
  if lvl = 0 then
    lvl := 1;
  CreateRowMemos(lvl);
  CreateCornerMemos(FRowLevels + 3);
  CreateCellMemos(FCellLevels * (FRowLevels + 1) * (FColumnLevels + 1));
  max := FRowLevels;
  if FColumnLevels > max then
    max := FColumnLevels;
  CreateCellHeaderMemos(FCellLevels * (max + 1));
end;

procedure TfrxCustomCrossView.SetDotMatrix(const Value: Boolean);
begin
  FDotMatrix := Value;
  if FDotMatrix then
  begin
    FGapX := 0;
    FGapY := 0;
  end;
end;

function TfrxCustomCrossView.IsAcceptAsChild(aParent: TfrxComponent): Boolean;
begin
  Result :=  (aParent is TfrxBand) or (aParent is TfrxPage);
end;

function TfrxCustomCrossView.IsContain(X, Y: Extended): Boolean;
begin
  if FShowMoveArrow and (AbsLeft <= X) and (AbsLeft + 16 >= X) and (AbsTop - 20 <= Y) and (AbsTop + 2 >= Y) then
  begin
    Result := True;
    Exit;
  end;
  Result := Inherited IsContain(X, Y);
end;

function TfrxCustomCrossView.IsCrossValid: Boolean;
begin
  Result := True;
end;

function TfrxCustomCrossView.ColumnHeaderHeight: Extended;
begin
  Result := ColumnHeader.Height;
end;

function TfrxCustomCrossView.RowHeaderWidth: Extended;
begin
  Result := RowHeader.Width;
  if FNoRows then
    Result := 0;
end;

procedure TfrxCustomCrossView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FNextCross) then
    FNextCross := nil;
end;

procedure TfrxCustomCrossView.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('Memos', ReadMemos, WriteMemos, True);
end;

procedure TfrxCustomCrossView.ReadMemos(Stream: TStream);
var
  x: TfrxXMLDocument;
  i: Integer;

  procedure GetItem(m: TfrxCustomMemoView; const Name: String; Index: Integer);
  var
    xs: TfrxXMLSerializer;
    Item: TfrxXMLItem;
  begin
    Item := x.Root.FindItem(Name);
    if Index >= Item.Count then Exit;
    Item := Item[Index];

    xs := TfrxXMLSerializer.Create(nil);
    xs.OldFormat := x.OldVersion;
    m.Color := clNone;
    m.Frame.Color := clBlack;
    m.Frame.Width := 1;
    m.Frame.Typ := [];
    m.Font.Style := [];
    m.HAlign := haLeft;
    m.VAlign := vaTop;
    m.Restrictions := m.Restrictions - [rfDontMove, rfDontSize];
    xs.ReadRootComponent(m, Item);
    xs.Free;
  end;

  function GetItem1(const Name: String; Index: Integer): TfrxCrossFunction;
  var
    Item: TfrxXMLItem;
  begin
    Result := cfNone;
    Item := x.Root.FindItem(Name);
    if Index >= Item.Count then Exit;
    Item := Item[Index];
    Result := TfrxCrossFunction(StrToInt(Item.Text));
  end;

  function GetItem2(const Name: String; Index: Integer): TfrxCrossSortOrder;
  var
    Item: TfrxXMLItem;
  begin
    Result := soAscending;
    Item := x.Root.FindItem(Name);
    if Index >= Item.Count then Exit;
    Item := Item[Index];
    Result := TfrxCrossSortOrder(StrToInt(Item.Text));
  end;

begin
  x := TfrxXMLDocument.Create;

  try
    x.LoadFromStream(Stream);

    for i := 0 to FCellLevels - 1 do
      CellFunctions[i] := GetItem1('cellfunctions', i);

    for i := 0 to FCellHeaderMemos.Count - 1 do
      GetItem(CellHeaderMemos[i], 'cellheadermemos', i);

    for i := 0 to FCellMemos.Count - 1 do
      GetItem(CellMemos[i], 'cellmemos', i);

    for i := 0 to FColumnMemos.Count - 1 do
    begin
      GetItem(ColumnMemos[i], 'columnmemos', i);
      GetItem(ColumnTotalMemos[i], 'columntotalmemos', i);
      ColumnSort[i] := GetItem2('columnsort', i);
    end;

    for i := 0 to FRowMemos.Count - 1 do
    begin
      GetItem(RowMemos[i], 'rowmemos', i);
      GetItem(RowTotalMemos[i], 'rowtotalmemos', i);
      RowSort[i] := GetItem2('rowsort', i);
    end;

    for i := 0 to FCornerMemos.Count - 1 do
      GetItem(CornerMemos[i], 'cornermemos', i);

  finally
    x.Free;
  end;
end;

procedure TfrxCustomCrossView.WriteMemos(Stream: TStream);
var
  x: TfrxXMLDocument;
  i: Integer;

  procedure AddItem(m: TfrxCustomMemoView; const Name: String);
  var
    xs: TfrxXMLSerializer;
  begin
    xs := TfrxXMLSerializer.Create(nil);
    xs.WriteRootComponent(m, True, x.Root.FindItem(Name).Add);
    xs.Free;
  end;

  procedure AddItem1(f: TfrxCrossFunction; const Name: String);
  var
    Item: TfrxXMLItem;
  begin
    Item := x.Root.FindItem(Name);
    Item := Item.Add;
    Item.Name := 'item';
    Item.Text := IntToStr(Integer(f));
  end;

  procedure AddItem2(f: TfrxCrossSortOrder; const Name: String);
  var
    Item: TfrxXMLItem;
  begin
    Item := x.Root.FindItem(Name);
    Item := Item.Add;
    Item.Name := 'item';
    Item.Text := IntToStr(Integer(f));
  end;

begin
  x := TfrxXMLDocument.Create;
  x.Root.Name := 'cross';

  try
    x.Root.Add.Name := 'cellmemos';
    x.Root.Add.Name := 'cellheadermemos';
    x.Root.Add.Name := 'columnmemos';
    x.Root.Add.Name := 'columntotalmemos';
    x.Root.Add.Name := 'cornermemos';
    x.Root.Add.Name := 'rowmemos';
    x.Root.Add.Name := 'rowtotalmemos';
    x.Root.Add.Name := 'cellfunctions';
    x.Root.Add.Name := 'columnsort';
    x.Root.Add.Name := 'rowsort';

    for i := 0 to FCellLevels - 1 do
      AddItem1(CellFunctions[i], 'cellfunctions');

    for i := 0 to FCellHeaderMemos.Count - 1 do
      AddItem(CellHeaderMemos[i], 'cellheadermemos');

    for i := 0 to FCellMemos.Count - 1 do
      AddItem(CellMemos[i], 'cellmemos');

    for i := 0 to FColumnMemos.Count - 1 {FColumnLevels - 1} do
    begin
      AddItem(ColumnMemos[i], 'columnmemos');
      AddItem(ColumnTotalMemos[i], 'columntotalmemos');
      AddItem2(ColumnSort[i], 'columnsort');
    end;

    for i := 0 to FRowMemos.Count - 1 {FRowLevels - 1} do
    begin
      AddItem(RowMemos[i], 'rowmemos');
      AddItem(RowTotalMemos[i], 'rowtotalmemos');
      AddItem2(RowSort[i], 'rowsort');
    end;

    for i := 0 to FCornerMemos.Count - 1 do
      AddItem(CornerMemos[i], 'cornermemos');

    x.SaveToStream(Stream);
  finally
    x.Free;
  end;
end;

procedure TfrxCustomCrossView.CreateCellHeaderMemos(NewCount: Integer);
var
  i: Integer;
  m: TfrxCustomMemoView;
begin
  for i := FCellHeaderMemos.Count to NewCount - 1 do
  begin
    m := CreateMemo(nil);
    FCellHeaderMemos.Add(m);
    m.Restrictions := [rfDontDelete];
    m.VAlign := vaCenter;
    m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    m.AllowExpressions := False;
  end;
end;

procedure TfrxCustomCrossView.CreateCellMemos(NewCount: Integer);
var
  i: Integer;
  m: TfrxCustomMemoView;
begin
  for i := FCellMemos.Count to NewCount - 1 do
  begin
    m := CreateMemo(nil);
    FCellMemos.Add(m);
    m.Restrictions := [rfDontDelete];
    m.HAlign := haRight;
    m.VAlign := vaCenter;
    m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    m.AllowExpressions := False;
  end;
end;

procedure TfrxCustomCrossView.CreateColumnMemos(NewCount: Integer);
var
  i: Integer;
  m: TfrxCustomMemoView;
begin
  for i := FColumnMemos.Count to NewCount - 1 do
  begin
    m := CreateMemo(nil);
    FColumnMemos.Add(m);
    m.Restrictions := [rfDontDelete, rfDontEdit];
    m.HAlign := haCenter;
    m.VAlign := vaCenter;
    m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    m.AllowExpressions := False;

    m := CreateMemo(nil);
    FColumnTotalMemos.Add(m);
    m.Restrictions := [rfDontDelete];
    if i = 0 then
      m.Text := 'Grand Total'
    else
      m.Text := 'Total';
    m.Font.Style := [fsBold];
    m.HAlign := haCenter;
    m.VAlign := vaCenter;
    m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
  end;
end;

procedure TfrxCustomCrossView.CreateRowMemos(NewCount: Integer);
var
  i: Integer;
  m: TfrxCustomMemoView;
begin
  for i := FRowMemos.Count to NewCount - 1 do
  begin
    m := CreateMemo(nil);
    FRowMemos.Add(m);
    m.Restrictions := [rfDontDelete, rfDontEdit];
    m.HAlign := haCenter;
    m.VAlign := vaCenter;
    m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    m.AllowExpressions := False;

    m := CreateMemo(nil);
    FRowTotalMemos.Add(m);
    m.Restrictions := [rfDontDelete];
    if i = 0 then
      m.Text := 'Grand Total'
    else
      m.Text := 'Total';
    m.Font.Style := [fsBold];
    m.HAlign := haCenter;
    m.VAlign := vaCenter;
    m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
  end;
end;

procedure TfrxCustomCrossView.CreateCornerMemos(NewCount: Integer);
var
  i: Integer;
  m: TfrxCustomMemoView;
begin
  for i := FCornerMemos.Count to NewCount - 1 do
  begin
    m := CreateMemo(nil);
    FCornerMemos.Add(m);
    m.Restrictions := [rfDontDelete];
    m.HAlign := haCenter;
    m.VAlign := vaCenter;
    m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    m.AllowExpressions := False;
  end;
end;

procedure TfrxCustomCrossView.ClearMemos;
begin
  while FCellHeaderMemos.Count > 0 do
  begin
    CellHeaderMemos[0].Free;
    FCellHeaderMemos.Delete(0);
  end;
  while FCellMemos.Count > 0 do
  begin
    CellMemos[0].Free;
    FCellMemos.Delete(0);
  end;
  while FColumnMemos.Count > 0 do
  begin
    ColumnMemos[0].Free;
    FColumnMemos.Delete(0);
    ColumnTotalMemos[0].Free;
    FColumnTotalMemos.Delete(0);
  end;
  while FRowMemos.Count > 0 do
  begin
    RowMemos[0].Free;
    FRowMemos.Delete(0);
    RowTotalMemos[0].Free;
    FRowTotalMemos.Delete(0);
  end;
  while FCornerMemos.Count > 0 do
  begin
    CornerMemos[0].Free;
    FCornerMemos.Delete(0);
  end;
end;

procedure TfrxCustomCrossView.InitMatrix;
var
  ColL, RowL: Integer;
begin
  ClearMatrix;

  RowL := FRowLevels;
  FNoRows := FRowLevels = 0;
  if FNoRows then
    RowL := 1;
  ColL := FColumnLevels;
  FNoColumns := FColumnLevels = 0;
  if FNoColumns then
    ColL := 1;

  FRows := TfrxCrossRows.Create;
  FRows.FIndexesCount := RowL;
  FRows.FSortOrder := FRowSort;
  FRows.FCellLevels := FCellLevels;

  FColumns := TfrxCrossColumns.Create;
  FColumns.FIndexesCount := ColL;
  FColumns.FSortOrder := FColumnSort;

  FCorner := TfrxCrossCorner.Create(1);
  FCorner.FMemo := CornerMemos[0];
  FCorner.Value := CornerMemos[0].Text;
  FCorner.FLevelsCount := 1;

  FRowHeader := TfrxCrossRowHeader.Create(FCellLevels);
  FRowHeader.FMemos := FRowMemos;
  FRowHeader.FTotalMemos := FRowTotalMemos;
  FRowHeader.FLevelsCount := RowL;
  FRowHeader.HasCellHeaders := (FCellLevels > 1) and not FPlainCells;
  FRowHeader.FCorner := FCorner;
  FRowHeader.FNoLevels := FNoRows;

  FColumnHeader := TfrxCrossColumnHeader.Create(FCellLevels);
  FColumnHeader.FMemos := FColumnMemos;
  FColumnHeader.FTotalMemos := FColumnTotalMemos;
  FColumnHeader.FMemo := CornerMemos[1];
  FColumnHeader.Value := CornerMemos[1].Text;
  FColumnHeader.FLevelsCount := ColL;
  FColumnHeader.HasCellHeaders := (FCellLevels > 1) and FPlainCells;
  FColumnHeader.FCorner := FCorner;
  FColumnHeader.FNoLevels := FNoColumns;
end;

function TfrxCustomCrossView.GetNestedObjects: TList;
var
  i: Integer;
  NestedObjects: TList;

  procedure DoNested(Memo: TfrxCustomMemoView);
  var
    i: Integer;
    c: TfrxComponent;
  begin
    for i := 0 to Memo.Objects.Count - 1 do
    begin
      c := Memo.Objects[i];
      NestedObjects.Add(c);
    end;
  end;

begin
  NestedObjects := TList.Create;

  for i := 0 to FCellHeaderMemos.Count - 1 do
    DoNested(CellHeaderMemos[i]);

  for i := 0 to FCellMemos.Count - 1 do
    DoNested(CellMemos[i]);

  for i := 0 to FColumnMemos.Count - 1 do
  begin
    DoNested(ColumnMemos[i]);
    DoNested(ColumnTotalMemos[i]);
  end;

  for i := 0 to FRowMemos.Count - 1 do
  begin
    DoNested(RowMemos[i]);
    DoNested(RowTotalMemos[i]);
  end;

  for i := 0 to FCornerMemos.Count - 1 do
    DoNested(CornerMemos[i]);

  Result := NestedObjects;
end;

procedure TfrxCustomCrossView.InitMemos(AddToScript: Boolean);
var
  i: Integer;
  m: TfrxCustomMemoView;
  NestedObjects: TList;
begin
  for i := 0 to FCellHeaderMemos.Count - 1 do
  begin
    m := CellHeaderMemos[i];
    m.GapX := FGapX;
    m.GapY := FGapY;
    m.Visible := True;
    m.Restrictions := m.Restrictions - [rfDontMove, rfDontSize];
    m.Name := Name + 'CellHeader' + IntToStr(i);
    if AddToScript then
      Report.Script.AddObject(m.Name, m);
  end;

  for i := 0 to FCellMemos.Count - 1 do
  begin
    m := CellMemos[i];
    m.GapX := FGapX;
    m.GapY := FGapY;
    m.Restrictions := m.Restrictions - [rfDontMove, rfDontSize];
    m.Name := Name + 'Cell' + IntToStr(i);
    if AddToScript then
      Report.Script.AddObject(m.Name, m);
  end;

  for i := 0 to FColumnMemos.Count - 1 do
  begin
    m := ColumnMemos[i];
    m.GapX := FGapX;
    m.GapY := FGapY;
    m.Visible := True;
    m.Restrictions := m.Restrictions - [rfDontMove, rfDontSize];
    m.Name := Name + 'Column' + IntToStr(i);
    if AddToScript then
      Report.Script.AddObject(m.Name, m);

    m := ColumnTotalMemos[i];
    m.GapX := FGapX;
    m.GapY := FGapY;
    m.AllowExpressions := False;
    m.Name := Name + 'ColumnTotal' + IntToStr(i);
    if AddToScript then
      Report.Script.AddObject(m.Name, m);
  end;

  for i := 0 to FRowMemos.Count - 1 do
  begin
    m := RowMemos[i];
    m.GapX := FGapX;
    m.GapY := FGapY;
    m.Visible := true;
    m.Restrictions := m.Restrictions - [rfDontMove, rfDontSize];
    m.Name := Name + 'Row' + IntToStr(i);
    if AddToScript then
      Report.Script.AddObject(m.Name, m);

    m := RowTotalMemos[i];
    m.GapX := FGapX;
    m.GapY := FGapY;
    m.AllowExpressions := False;
    m.Name := Name + 'RowTotal' + IntToStr(i);
    if AddToScript then
      Report.Script.AddObject(m.Name, m);
  end;

  for i := 0 to FCornerMemos.Count - 1 do
  begin
    m := CornerMemos[i];
    m.GapX := FGapX;
    m.GapY := FGapY;
    m.Restrictions := m.Restrictions - [rfDontMove, rfDontSize];
    if i > 2 then
      m.Visible := True;
    m.Name := Name + 'Corner' + IntToStr(i);
    if AddToScript then
      Report.Script.AddObject(m.Name, m);
  end;

  NestedObjects := GetNestedObjects;

  for i := 0 to NestedObjects.Count - 1 do
  begin
    m := NestedObjects[i];
    m.Name := Name + 'Object' + IntToStr(m.Tag);
    if AddToScript then
      Report.Script.AddObject(m.Name, m);
  end;

  NestedObjects.Free;
end;

procedure TfrxCustomCrossView.ClearMatrix;
begin
  FRows.Free;
  FRows := nil;
  FColumns.Free;
  FColumns := nil;
  FCorner.Free;
  FCorner := nil;
  FRowHeader.Free;
  FRowHeader := nil;
  FColumnHeader.Free;
  FColumnHeader := nil;
end;

procedure TfrxCustomCrossView.AddValue(const Rows, Columns, Cells: array of Variant);
var
  i: Integer;
  Row: TfrxCrossRow;
  Column: TfrxCrossColumn;
  Cell: PfrCrossCell;
  Value, v: Variant;
  isNull: Boolean;
begin
  if not IsCrossValid then
    raise Exception.Create('Cross-tab is not valid');
  if FRows = nil then Exit;

  { check for all nulls }
  isNull := True;
  for i := Low(Rows) to High(Rows) do
    if not VarIsNull(Rows[i]) then
      isNull := False;
  if isNull then
  begin
    for i := Low(Columns) to High(Columns) do
      if not VarIsNull(Columns[i]) then
        isNull := False;
    if isNull then
    begin
      for i := Low(Cells) to High(Cells) do
        if not VarIsNull(Cells[i]) then
          isNull := False;
    end;
  end;

  if isNull and FSuppressNullRecords then Exit;

  if FNoColumns then
    Column := FColumns.Column([Null]) else
    Column := FColumns.Column(Columns);
  if FNoRows then
    Row := FRows.Row([Null]) else
    Row := FRows.Row(Rows);

  Cell := Row.GetCell(Column.CellIndex);

  for i := 0 to FCellLevels - 1 do
  begin
    Value := Cell.Value;
    v := Cells[i];

    if FCellFunctions[i] = cfCount then
    begin
      if v = Null then
        v := 0
      else
        v := 1;
    end;

    if Value = Null then
      Cell.Value := v
    else if (TVarData(Value).VType = varString) or (TVarData(Value).VType = varOleStr){$IFDEF Delphi12} or (TVarData(Value).VType = varUString){$ENDIF} then
    begin
      if FAllowDuplicates or
        (Pos(#13#10 + v + #13#10, #13#10 + Cell.Value + #13#10) = 0) then
        Cell.Value := Value + #13#10 + v
    end
    else
      Cell.Value := Value + v;

    Cell := Cell.Next;
  end;
end;

function TfrxCustomCrossView.GetValue(ARow, AColumn, ACell: Integer): Variant;
var
  Row: TfrxCrossRow;
  Column: TfrxCrossColumn;
  Cell: PfrCrossCell;
begin
  Result := Null;
  Column := FColumns[AColumn];
  Row := FRows[ARow];
  Cell := Row.GetCell(Column.CellIndex);

  while (Cell <> nil) and (ACell > 0) do
  begin
    Cell := Cell.Next;
    Dec(ACell);
  end;

  if Cell <> nil then
    Result := Cell.Value;
end;

procedure TfrxCustomCrossView.CreateHeader(Header: TfrxCrossHeader;
  Source: TfrxIndexCollection; Totals: TList; TotalVisible: Boolean);
var
  i, j, IndexesCount: Integer;
  LastValues, CurValues: TfrxVariantArray;
  Unsorted: Boolean;

  function ExpandVariable(s: String; const Value: Variant): String;
  var
    i: Integer;
  begin
    { expand the [Value] macro if any (eg. if total memo contains
      the text: 'Total of [Value]' }
    i := Pos('[VALUE]', AnsiUppercase(s));
    if i <> 0 then
    begin
      Delete(s, i, 7);
      Insert(VarToStr(Value), s, i);
    end;
    Result := s;
  end;

  procedure AddTotals;
  var
    j, k: Integer;
  begin
    for j := 0 to IndexesCount - 1 do
      { if value changed... }
      if LastValues[j] <> CurValues[j] then
      begin
        { ...create subtotals for all down-level values }
        for k := IndexesCount - 1 downto j + 1 do
          if TfrxCustomMemoView(Totals[k]).Visible then
          begin
            { '@@@' means that this is subtotal cell }
            LastValues[k] := '@@@' +
              ExpandVariable(TfrxCustomMemoView(Totals[k]).Text, LastValues[k - 1]);
            { create header cells... }
            Header.AddValues(LastValues, Unsorted);
            LastValues[k] := '@@@';
            { ...and row/column item }
            Source.InsertItem(i, LastValues);
            Inc(i);
          end;
        break;
      end;
  end;

begin
  if Source.Count = 0 then Exit;
  Unsorted := (Source.FSortOrder[0] = soNone);
  IndexesCount := Source.FIndexesCount;
  { copy first indexes to lastvalues }
  LastValues := Copy(Source.Items[0].Indexes, 0, IndexesCount);
  i := 0;

  while i < Source.Count do
  begin
    { copy current indexes to curvalues }
    CurValues := Copy(Source.Items[i].Indexes, 0, IndexesCount);
    { if lastvalues <> curvalues, make a subtotal item }
    AddTotals;
    { add header cells }
    Header.AddValues(CurValues, Unsorted);

    LastValues := CurValues;
    Inc(i);
  end;

  { create last subtotal item }
  CurValues := Copy(Source.Items[0].Indexes, 0, IndexesCount);
  for j := 0 to IndexesCount - 1 do
    CurValues[j] := Null;
  AddTotals;

  { create grand total }
  if TotalVisible and TfrxCustomMemoView(Totals[0]).Visible then
  begin
    LastValues[0] := '@@@' + TfrxCustomMemoView(Totals[0]).Text;
    Header.AddValues(LastValues, Unsorted);
    LastValues[0] := '@@@';
    Source.InsertItem(i, LastValues);
  end;
end;

procedure TfrxCustomCrossView.CreateHeaders;
var
  i: Integer;
begin
  CreateHeader(FColumnHeader, FColumns, FColumnTotalMemos, not FNoColumns);
  CreateHeader(FRowHeader, FRows, FRowTotalMemos, not FNoRows);

  { add corner elements }
  for i := 0 to FRowLevels - 1 do
    FCorner.AddChild(FCornerMemos[3 + i]);
  if FRowHeader.HasCellHeaders then
    FCorner.AddChild(FCornerMemos[2]);
end;

procedure TfrxCustomCrossView.CalcTotal(Header: TfrxCrossHeader;
  Source: TfrxIndexCollection);
var
  i, j: Integer;
  Items: TList;
  Values, Counts: TfrxVariantArray;
  Item: TfrxCrossHeader;
  p: PfrCrossCell;
  FinalPass: Boolean;

  procedure CellToArrays(p: PfrCrossCell);
  var
    i: Integer;
  begin
    for i := 0 to FCellLevels - 1 do
    begin
      Values[i] := p.Value;
      Counts[i] := p.Count;

      if (FCellFunctions[i] = cfAvg) and FinalPass and (p.Count <> 0) then
        p.Value := p.Value / p.Count;

      p := p.Next;
    end;
  end;

  procedure ArraysToCell(p: PfrCrossCell);
  var
    i: Integer;
  begin
    for i := 0 to FCellLevels - 1 do
    begin
      p.Value := Item.FFuncValues[i];
      p.Count := Item.FCounts[i];

      if (FCellFunctions[i] = cfAvg) and FinalPass then
        if p.Count <> 0 then
          p.Value := p.Value / p.Count else
          p.Value := 0;

      if (FCellFunctions[i] = cfCount) and not FinalPass then
        p.Count := p.Value;

      p := p.Next;
    end;
  end;

begin
  Items := Header.TerminalItems;
  SetLength(Values, FCellLevels);
  SetLength(Counts, FCellLevels);
  FinalPass := Source = FColumns;

  { scan the matrix }
  for i := 0 to Source.Count - 1 do
  begin
    for j := 0 to Items.Count - 1 do
      TfrxCrossHeader(Items[j]).Reset(FCellFunctions);

    for j := 0 to Items.Count - 1 do
    begin
      Item := Items[j];
      if Source = FRows then
        p := FRows[i].GetCell(FColumns[j].CellIndex) else
        p := FRows[j].GetCell(FColumns[i].CellIndex);

      if not Item.IsTotal then
      begin
        { convert cell values to Values and Counts arrays }
        CellToArrays(p);
        { accumulate values in the header items }
        Item.AddFuncValues(Values, Counts, FCellFunctions);
      end
      else
      begin
        { get the accumulated values from the item's parent }
        Item := Item.Parent;
        { and convert it to the cell }
        ArraysToCell(p);
      end;
    end;
  end;

  Items.Free;
  Values := nil;
  Counts := nil;
end;

procedure TfrxCustomCrossView.CalcTotals;
begin
  { scan the matrix from left to right, then from top to bottom }
  CalcTotal(FColumnHeader, FRows);
  { final pass, scan the matrix from top to bottom, then from left to right }
  CalcTotal(FRowHeader, FColumns);
end;

procedure TfrxCustomCrossView.CalcBounds;
var
  i, j, k: Integer;
  ColumnItems, RowItems, CornerItems, HeaderItems: TList;
  ColumnItem, RowItem: TfrxCrossHeader;
  Cell: PfrCrossCell;
  m: TfrxCustomMemoView;
  NewHeight: Extended;
  Size: TfrxPoint;

  function CalcRowHeight(aRowItem: TfrxCrossHeader): Extended;
  var
    idx: Integer;
  begin
    Result := 0;
    for idx := 0 to aRowItem.FItems.Count - 1 do
      Result := Result + TfrxCrossHeader(aRowItem.FItems[idx]).FSize.Y;
  end;

  procedure DoCalc(const Value: Variant);
  var
    i, r: Integer;
    s: WideString;
    Width, NewWidth: Extended;
    WidthChanged: Boolean;
  begin
    if FAutoSize then
    begin

      s := m.Text;
      m.Text := m.FormatData(Value, CellMemos[k].DisplayFormat);
      r := m.Rotation;
      m.Rotation := 0;

      Width := FMaxWidth;
      NewWidth := -1;
      DoCalcWidth(j, NewWidth);
      WidthChanged := NewWidth <> -1;
      if not WidthChanged then
        NewWidth := Width;
      m.Width := NewWidth;

      Size := CalcSize(m);
      Size.X := Size.X + FAddWidth;
      Size.Y := Size.Y + FAddHeight;
      if Size.X > FMaxWidth then
        Size.X := FMaxWidth;
      if Size.X < FMinWidth then
        Size.X := FMinWidth;
      m.Rotation := r;
      m.Text := s;
    end
    else
    begin
      NewWidth := m.Width;
      DoCalcWidth(j, NewWidth);
      WidthChanged := NewWidth <> m.Width;
      m.Width := NewWidth;
    end;

    if WidthChanged then
    begin
      Size.X := NewWidth;
      ColumnItem.FSize.X := Size.X;
      ColumnItem.FRecalcSizes := True;
      for i := 0 to ColumnItem.Count - 1 do
      begin
        ColumnItem[i].FSize.X := NewWidth;
        ColumnItem[i].FRecalcSizes := True;
      end;
    end;
    if FDefHeight <> 0 then
      Size.Y := FDefHeight;
    if NewWidth = 0 then
      Size.Y := 0;
  end;

begin
  ColumnItems := FColumnHeader.TerminalItems;
  RowItems := FRowHeader.TerminalItems;
  { create cell headers }
  if FCellLevels > 1 then
    if FPlainCells then
    begin
      for i := 0 to ColumnItems.Count - 1 do
      begin
        ColumnItem := ColumnItems[i];
        for j := 0 to FCellLevels - 1 do
          ColumnItem.AddCellHeader(FCellHeaderMemos, i, j);
      end;
    end
    else
    begin
      for i := 0 to RowItems.Count - 1 do
      begin
        RowItem := RowItems[i];
        for j := 0 to FCellLevels - 1 do
          RowItem.AddCellHeader(FCellHeaderMemos, i, j);
      end;
    end;

  { calculate the widths of columns and the heights of rows }
  if Corner.Visible then
    FCorner.CalcSizes(FMaxWidth, FMinWidth, FAutoSize);
  { correction when title text height is greater than column }

  if FColumnHeader.Visible or not FAutoSize then
  begin
    CornerItems := FCorner.AllItems;
    HeaderItems := FColumnHeader.AllItems;

    if (CornerItems.Count > 1) and (HeaderItems.Count > 1) then
      if (TfrxCrossCorner(CornerItems[1]).Visible) and (TfrxCrossCorner(HeaderItems[1]).DefaultHeight = 0) then
       TfrxCrossCorner(HeaderItems[1]).DefaultHeight := Round(TfrxCrossCorner(CornerItems[1]).FSize.Y);
    CornerItems.Free;
    HeaderItems.Free;
    FColumnHeader.CalcSizes(FMaxWidth, FMinWidth, FAutoSize);
  end;
  FRowHeader.CalcSizes(FMaxWidth, FMinWidth, FAutoSize);


  { scanning the matrix cells and update calculated widths and heights }
  for i := 0 to RowItems.Count - 1 do
  begin
    RowItem := RowItems[i];
    RowItem.FIsIndex := True;
    RowItem.FIndex := i;

    for j := 0 to ColumnItems.Count - 1 do
    begin
      ColumnItem := ColumnItems[j];
      ColumnItem.FIsIndex := True;
      ColumnItem.FIndex := j;
      if not FAutoSize then
      begin
       if ((FOnCalcWidth = '') or IsDesigning) then continue;
       Size := frxPoint(0 , 0);
      end;

      Cell := FRows[i].GetCell(FColumns[j].CellIndex);

      for k := 0 to FCellLevels - 1 do
      begin
        m := CellMemos[ColumnItem.FTotalIndex * ((FRowLevels + 1) * FCellLevels) +
          RowItem.FTotalIndex * FCellLevels + k];

        DoCalc(Cell.Value);
        if FCellLevels > 1 then
          if FPlainCells then
          begin
            if ColumnItem[k].FSize.X < Size.X then
              ColumnItem[k].FSize.X := Size.X;
            if RowItem.FSize.Y < Size.Y then
              RowItem.FSize.Y := Size.Y;
          end
          else
          begin
            if RowItem[k].FSize.Y < Size.Y then
              RowItem[k].FSize.Y := Size.Y;
            if ColumnItem.FSize.X < Size.X then
              ColumnItem.FSize.X := Size.X;
          end
        else
        begin
          if RowItem.FSize.Y < Size.Y then
            RowItem.FSize.Y := Size.Y;
          if ColumnItem.FSize.X < Size.X then
            ColumnItem.FSize.X := Size.X;
        end;

        Cell := Cell.Next;
      end;
    end;

    if (RowItem.FSize.Y = 0) and (RowItem.FItems.Count > 0) and not FPlainCells then
      RowItem.FSize.Y := CalcRowHeight(RowItem);
    NewHeight := RowItem.FSize.Y;
    DoCalcHeight(i, NewHeight);
    RowItem.FSize.Y := NewHeight;
    if NewHeight = 0 then
      RowItem.Visible := False;
  end;

  { calculate the positions and sizes of the header cells }
  FColumnHeader.CalcSizes(-1, -1, FAutoSize);
  FCorner.CalcBounds;
  FColumnHeader.CalcBounds;
  FRowHeader.CalcBounds;
  { recalc corner again - it may be adjusted in rowheader }
  FCorner.CalcBounds;


  ColumnItems.Free;
  RowItems.Free;
end;

function TfrxCustomCrossView.CreateMemo(Parent: TfrxComponent): TfrxCustomMemoView;
begin
  if FDotMatrix then
    Result := TfrxDMPMemoView.Create(Parent)
  else
    Result := TfrxMemoView.Create(Parent);
  Result.frComponentStyle := Result.frComponentStyle + [csContained];
end;

procedure TfrxCustomCrossView.CorrectDMPBounds(Memo: TfrxCustomMemoView);
begin
  if Memo is TfrxDMPMemoView then
  begin
    Memo.Left := Memo.Left + fr1CharX;
    Memo.Top := Memo.Top + fr1CharY;
    Memo.Width := Memo.Width - fr1CharX;
    Memo.Height := Memo.Height - fr1CharY;
  end;
end;

function TfrxCustomCrossView.GetContainedComponent(X, Y: Extended;
  IsCanContain: TfrxComponent): TfrxComponent;
//var
//  i: Integer;
//  c: TfrxComponent;
begin
  Result := Inherited GetContainedComponent(X, Y, IsCanContain);
//TODO : Make proper GetContainedComponent
//  for i := 0 to FAllMemos.Count - 1 do
//  begin
//    c := FAllMemos[i];
//    if c.IsContain(X, Y) then
//    begin
//      Result := c.GetContainedComponent(X, Y, IsCanContain);
//      if (Result = nil) or (IsCanContain = Self) then
//        Result := c;
//      break;
//    end;
//  end;
//  if (Result = Self) and (IsCanContain = Self){ or (not IsAcceptControl(IsCanContain)))} then
//    Result := nil;
end;

function TfrxCustomCrossView.GetContainerObjects: TList;
begin
  Result := FAllMemos;
end;

function TfrxCustomCrossView.ContainerAdd(Obj: TfrxComponent): Boolean;
var
  i, j, n: Integer;
  c: TfrxComponent;
  NestedObjects: TList;
  Found: Boolean;
begin
  Result := False;
  if (Obj is TfrxCustomCrossView) or (Obj is TfrxSubreport) then Exit;

  { call DrawCross to calc visible memos and their bounds }
  DrawCross(nil, FScaleX, FScaleY, AbsLeft, AbsTop);

  { find parent memo for added object }
  for i := 0 to FAllMemos.Count - 1 do
  begin
    c := FAllMemos[i];
    if (Obj.Left >= c.Left) and (Obj.Top >= c.Top) and
      (Obj.Left <= c.Left + c.Width) and
      (Obj.Top <= c.Top + c.Height) then
    begin
      Obj.Left := Obj.Left - c.Left;
      Obj.Top := Obj.Top - c.Top;
      Obj.Owner.RemoveComponent(Obj);
      Obj.Parent := c;

      { create unique tag for it - it will be used for name creation }
      NestedObjects := GetNestedObjects;
      n := 0;
      while True do
      begin
        Inc(n);
        Found := False;
        for j := 0 to NestedObjects.Count - 1 do
          if TfrxComponent(NestedObjects[j]).Tag = n then
          begin
            Found := True;
            break;
          end;
        if not Found then
        begin
          Obj.Tag := n;
          Obj.Name := Name + 'Object' + IntToStr(n);
          break;
        end;
      end;

      NestedObjects.Free;
      Result := True;
      break;
    end;
  end;
end;

function TfrxCustomCrossView.DoMouseDown(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i, j: Integer;
  c: TfrxComponent;
begin
  DrawCross(nil, FScaleX, FScaleY, AbsLeft, AbsTop);
  FGridUsed := nil;
  FFirstMousePos := Point(X, Y);
  FLastMousePos := Point(X, Y);

  for i := 0 to FGridX.Count - 1 do
    for j := 0 to FGridX[i].Objects.Count - 1 do
    begin
      c := FGridX[i].Objects[j];
      if (Abs(c.AbsLeft + c.Width - X / FScaleX) < 2) and
        (Y / FScaleY >= c.AbsTop) and (Y / FScaleY <= c.AbsTop + c.Height) then
      begin
        FGridUsed := FGridX;
        FMovingObjects := i;
        FMouseDown := True;
        break;
      end;
    end;

  for i := 0 to FGridY.Count - 1 do
    for j := 0 to FGridY[i].Objects.Count - 1 do
    begin
      c := FGridY[i].Objects[j];
      if (Abs(c.AbsTop + c.Height - Y / FScaleY) < 2) and
        (X / FScaleX >= c.AbsLeft) and (X / FScaleX <= c.AbsLeft + c.Width) then
      begin
        FGridUsed := FGridY;
        FMovingObjects := i;
        FMouseDown := True;
        break;
      end;
    end;

  Result := FMouseDown;
//  if not ((AbsLeft <= X) and (AbsLeft + 16 >= X) and (AbsTop - 20 <= Y) and (AbsTop + 2 >= Y)) then
//    Result := False;
end;

procedure TfrxCustomCrossView.DoMouseEnter(aPreviousObject: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  FShowMoveArrow := True;
  EventParams.Refresh := True;
end;

procedure TfrxCustomCrossView.DoMouseLeave(aNextObject: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  if FShowMoveArrow then
    EventParams.Refresh := True;
  FDragActive := False;
  FShowMoveArrow := False;
end;

procedure TfrxCustomCrossView.DoMouseMove(X, Y: Integer;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  i, j: Integer;
  c: TfrxComponent;
begin
  if (FScaleX = 0) or (FScaleY = 0) then Exit;

  if not FMouseDown then
  begin
    DrawCross(nil, FScaleX, FScaleY, AbsLeft, AbsTop);

    for i := 0 to FGridX.Count - 1 do
      for j := 0 to FGridX[i].Objects.Count - 1 do
      begin
        c := FGridX[i].Objects[j];
        if (Abs(c.AbsLeft + c.Width - X / FScaleX) < 2) and
          (Y / FScaleY >= c.AbsTop) and (Y / FScaleY <= c.AbsTop + c.Height) then
        begin
          TWinControl(EventParams.Sender).Cursor := crHSplit;
          break;
        end;
      end;

    for i := 0 to FGridY.Count - 1 do
      for j := 0 to FGridY[i].Objects.Count - 1 do
      begin
        c := FGridY[i].Objects[j];
        if (Abs(c.AbsTop + c.Height - Y / FScaleY) < 2) and
          (X / FScaleX >= c.AbsLeft) and (X / FScaleX <= c.AbsLeft + c.Width) then
        begin
          TWinControl(EventParams.Sender).Cursor := crVSplit;
          break;
        end;
      end;
  end
  else
  begin
    if FGridUsed = FGridX then
    begin
      for i := 0 to FGridX[FMovingObjects].Objects.Count - 1 do
      begin
        c := FGridX[FMovingObjects].Objects[i];
        c.Width := c.Width + (X - FLastMousePos.X);
      end;
    end
    else if FGridUsed = FGridY then
    begin
      for i := 0 to FGridY[FMovingObjects].Objects.Count - 1 do
      begin
        c := FGridY[FMovingObjects].Objects[i];
        c.Height := c.Height + (Y - FLastMousePos.Y);
      end;
    end;
    FLastMousePos := Point(X, Y);
    EventParams.Refresh := True;
  end;
end;

procedure TfrxCustomCrossView.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  i: Integer;
begin
  if (FScaleX = 0) or (FScaleY = 0) then Exit;

  for i := 0 to FAllMemos.Count - 1 do
    if TfrxComponent(FAllMemos[i]).IsContain(X / FScaleX, Y / FScaleY) then
    begin
      TfrxComponent(FAllMemos[i]).MouseUp(X, Y, Button, Shift, EventParams);
      break;
    end;

  if not FMouseDown then Exit;
  FMouseDown := False;
  if FAutoSize and ((Abs(X - FFirstMousePos.X) > 5) or (Abs(Y - FFirstMousePos.Y) > 5)) then
    frxInfoMsg(frxResources.Get('crResize'));
end;

function TfrxCustomCrossView.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos, EventParams);
{ just for testing event - remove }
//  MaxWidth := MaxWidth + WheelDelta;
//  Result := False;
//  EventParams.Refresh := True;
//  EventParams.Modified := True;
end;

function TfrxCustomCrossView.DrawCross(Canvas: TCanvas; ScaleX, ScaleY,
  OffsetX, OffsetY: Extended): TfrxPoint;

  procedure FillMatrix;
  var
    i: Integer;
    RowValues, ColumnValues, CellValues: array of Variant;
  begin
    BeginMatrix;
    InitMemos(False);
    SetLength(RowValues, RowLevels);
    SetLength(ColumnValues, ColumnLevels);
    SetLength(CellValues, CellLevels);

    for i := 0 to RowLevels - 1 do
      RowValues[i] := '[' + RowFields[i] + ']';
    for i := 0 to ColumnLevels - 1 do
      ColumnValues[i] := '[' + ColumnFields[i] + ']';
    for i := 0 to CellLevels - 1 do
      CellValues[i] := 0;
    AddValue(RowValues, ColumnValues, CellValues);

    RowValues := nil;
    ColumnValues := nil;
    CellValues := nil;
    EndMatrix;
  end;

  procedure DrawLine(x, y, dx, dy: Extended);
  begin
    Canvas.MoveTo(Round(x * ScaleX), Round(y * ScaleY));
    Canvas.LineTo(Round((x + dx) * ScaleX), Round((y + dy) * ScaleY));
  end;

  procedure DrawScriptSign(c: TfrxReportComponent);
  begin
    if (Canvas <> nil) and (c.OnBeforePrint <> '') then
      with c, Canvas do
      begin
        Pen.Style := psSolid;
        Pen.Color := clRed;
        Pen.Width := 1;
        DrawLine(AbsLeft + 2, AbsTop + 1, 0, 7);
        DrawLine(AbsLeft + 3, AbsTop + 2, 0, 5);
        DrawLine(AbsLeft + 4, AbsTop + 3, 0, 3);
        DrawLine(AbsLeft + 5, AbsTop + 4, 0, 1);
      end;
  end;

  procedure DrawObj(Obj: TfrxReportComponent; Child: Boolean = False);
  var
    i: Integer;
  begin
    { don't let a child move outside parent }
    if Child then
    begin
      if Obj.Left < 0 then
        Obj.Left := 0;
      if Obj.Left + Obj.Width > Obj.Parent.Width then
        Obj.Left := Obj.Parent.Width - Obj.Width;
      if Obj.Top < 0 then
        Obj.Top := 0;
      if Obj.Top + Obj.Height > Obj.Parent.Height then
        Obj.Top := Obj.Parent.Height - Obj.Height;
    end;
    Obj.IsDesigning := IsDesigning;
    if Canvas <> nil then
      Obj.InteractiveDraw(Canvas, ScaleX, ScaleY, 0, 0);

    DrawScriptSign(Obj);
    if not Child then
    begin
      FGridX.Add(Obj, Obj.AbsLeft + Obj.Width);
      FGridY.Add(Obj, Obj.AbsTop + Obj.Height);
    end;
    FAllMemos.Add(Obj);
    for i := 0 to Obj.Objects.Count - 1 do
      DrawObj(Obj.Objects[i], True);
  end;

  procedure DrawHeader(Header: TfrxCrossHeader; p: TfrxPoint; hVisible: Boolean = true);
  var
    i: Integer;
    Items: TList;
    Item: TfrxCrossHeader;
    r: TfrxRect;
    m: TfrxCustomMemoView;
    SaveWidth, SaveHeight: Extended; // for dot-matrix
    s: WideString;
  begin
    Items := Header.AllItems;

    for i := 0 to Items.Count - 1 do
    begin
      Item := Items[i];
      m := Item.Memo;
      r := Item.Bounds;

      s := m.Text;
      m.Text := VarToWideStr(Item.Value);
      m.SetBounds(r.Left + p.X, r.Top + p.Y, r.Right, r.Bottom);
      SaveWidth := m.Width;
      SaveHeight := m.Height;
      CorrectDMPBounds(m);
      if m.Left + m.Width > Result.X then
        Result.X := m.Left + m.Width;
      if m.Top + m.Height > Result.Y then
        Result.Y := m.Top + m.Height;

      if m.Visible and hVisible then
        DrawObj(m)
      else
      begin
        FGridX.Add(m, m.AbsLeft + m.Width);
        FGridY.Add(m, m.AbsTop + m.Height);
      end;

      m.Text := s;
      if m is TfrxDMPMemoView then
        TfrxDMPMemoView(m).SetBoundsDirect(m.Left - fr1CharX / 2,
          m.Top - fr1CharY / 2, SaveWidth, SaveHeight);
    end;

    Items.Free;
  end;

  procedure DrawCell(p: TfrxPoint);
  var
    i, j, CellIndex: Integer;
    Cell: Variant;
    ColumnItems, RowItems: TList;
    ColumnItem, RowItem: TfrxCrossHeader;
    m: TfrxCustomMemoView;
    SaveWidth, SaveHeight: Extended; // for dot-matrix
  begin
    ColumnItems := ColumnHeader.TerminalItems;
    RowItems := RowHeader.TerminalItems;

    for i := 0 to RowItems.Count - 1 do
    begin
      RowItem := RowItems[i];
      for j := 0 to ColumnItems.Count - 1 do
      begin
        ColumnItem := ColumnItems[j];

        if FCellLevels > 1 then
          if FPlainCells then
          begin
            CellIndex := ColumnItem.FCellIndex;
            Cell := GetValue(i, ColumnItem.FIndex, CellIndex);
          end
          else
          begin
            CellIndex := RowItem.FCellIndex;
            Cell := GetValue(RowItem.FIndex, j, CellIndex);
          end
        else
        begin
          CellIndex := 0;
          Cell := GetValue(i, j, 0);
        end;

        m := CellMemos[ColumnItem.FTotalIndex * ((FRowLevels + 1) * FCellLevels) +
          RowItem.FTotalIndex * FCellLevels + CellIndex];
        m.Visible := True;
        m.Restrictions := [rfDontDelete, rfDontEdit];
        m.Text := m.FormatData(Cell, CellMemos[CellIndex].DisplayFormat);
        m.SetBounds(ColumnItem.Bounds.Left, RowItem.Bounds.Top,
          ColumnItem.Bounds.Right, RowItem.Bounds.Bottom);
        m.Left := m.Left + p.X;
        m.Top := m.Top + p.Y;
        SaveWidth := m.Width;
        SaveHeight := m.Height;
        CorrectDMPBounds(m);
        if m.Left + m.Width > Result.X then
          Result.X := m.Left + m.Width;
        if m.Top + m.Height > Result.Y then
          Result.Y := m.Top + m.Height;

        DrawObj(m);
        if m is TfrxDMPMemoView then
          TfrxDMPMemoView(m).SetBoundsDirect(m.Left - fr1CharX / 2,
            m.Top - fr1CharY / 2, SaveWidth, SaveHeight);
      end;
    end;

    ColumnItems.Free;
    RowItems.Free;
  end;

begin
  Result := frxPoint(0, 0);
  FGridX.Clear;
  FGridY.Clear;
  FAllMemos.Clear;
  if IsCrossValid and not FDragActive then
  begin
    FillMatrix;
    if Corner.Visible then
      DrawHeader(Corner, frxPoint(OffsetX, OffsetY));
    if ColumnHeader.Visible or not FAutoSize then
      DrawHeader(ColumnHeader, frxPoint(OffsetX + RowHeaderWidth, OffsetY), ColumnHeader.Visible);
    if RowHeader.Visible then
      DrawHeader(RowHeader, frxPoint(OffsetX, OffsetY + ColumnHeaderHeight));
    DrawCell(frxPoint(OffsetX + RowHeaderWidth, OffsetY + ColumnHeaderHeight));
  end;
  Result.X := Result.X - OffsetX;
  Result.Y := Result.Y - OffsetY;
end;

procedure TfrxCustomCrossView.Draw(Canvas: TCanvas; ScaleX, ScaleY,
  OffsetX, OffsetY: Extended);
var
  size: TfrxPoint;
begin
  size := DrawCross(nil, ScaleX, ScaleY, AbsLeft, AbsTop);
  if (size.X > 0) and (size.Y > 0) then
  begin
    Width := size.X;// + 40;
    Height := size.Y;// + 40;
  end;

//  Color := clWhite;
  FillType := ftBrush;
  TfrxBrushFill(Fill).BackColor := clWhite;
  Frame.Style := fsDot;
  inherited;

  DrawCross(Canvas, ScaleX, ScaleY, AbsLeft, AbsTop);
  if FShowMoveArrow then
    frxResources.MainButtonImages.Draw(Canvas, FX, FY - 20, 110);
  if Assigned(FComponentEditors) then
    FComponentEditors.DrawCustomEditor(Canvas, Rect(FX, FY, FX1, FY1));
end;

procedure TfrxCustomCrossView.ApplyStyle(Style: TfrxStyles);
var
  i: Integer;
  s: String;
begin
  for i := 0 to FCellHeaderMemos.Count - 1 do
    CellHeaderMemos[i].ApplyStyle(Style.Find('cellheader'));

  for i := 0 to FCellMemos.Count - 1 do
    CellMemos[i].ApplyStyle(Style.Find('cell'));

  for i := 0 to FColumnMemos.Count - 1 do
  begin
    ColumnMemos[i].ApplyStyle(Style.Find('column'));
    if i = 0 then
      s := 'colgrand'
    else
      s := 'coltotal';
    ColumnTotalMemos[i].ApplyStyle(Style.Find(s));
  end;

  for i := 0 to FRowMemos.Count - 1 do
  begin
    RowMemos[i].ApplyStyle(Style.Find('row'));
    if i = 0 then
      s := 'rowgrand'
    else
      s := 'rowtotal';
    RowTotalMemos[i].ApplyStyle(Style.Find(s));
  end;

  for i := 0 to FCornerMemos.Count - 1 do
    CornerMemos[i].ApplyStyle(Style.Find('corner'));
end;

procedure TfrxCustomCrossView.GetStyle(Style: TfrxStyles);

  procedure DoStyle(m: TfrxCustomMemoView; const s: String);
  var
    stItem: TfrxStyleItem;
  begin
    stItem := Style.Find(s);
    if stItem = nil then
      stItem := Style.Add;
    stItem.Name := s;
    stItem.Color := m.Color;
    stItem.Font := m.Font;
    stItem.Frame := m.Frame;
  end;

begin
  if FCellHeaderMemos.Count > 0 then
    DoStyle(CellHeaderMemos[0], 'cellheader');

  if FCellMemos.Count > 0 then
    DoStyle(CellMemos[0], 'cell');

  if FColumnMemos.Count > 0 then
  begin
    DoStyle(ColumnMemos[0], 'column');
    DoStyle(ColumnTotalMemos[0], 'colgrand');
    if FColumnTotalMemos.Count > 1 then
      DoStyle(ColumnTotalMemos[1], 'coltotal');
  end;

  if FRowMemos.Count > 0 then
  begin
    DoStyle(RowMemos[0], 'row');
    DoStyle(RowTotalMemos[0], 'rowgrand');
    if FRowTotalMemos.Count > 1 then
      DoStyle(RowTotalMemos[1], 'rowtotal');
  end;

  if FCornerMemos.Count > 0 then
    DoStyle(CornerMemos[0], 'corner');
end;

procedure TfrxCustomCrossView.UpdateVisibility;
begin
  Corner.Visible := FShowCorner and not FNoRows
    and FShowColumnHeader and FShowRowHeader;
  CornerMemos[0].Visible := Corner.Visible and not FNoColumns and FShowTitle;
  CornerMemos[2].Visible := Corner.Visible and (FCellLevels > 1) and not FPlainCells;

  ColumnHeader.Visible := FShowColumnHeader;
  if FColumnTotalMemos.Count > 0 then
    ColumnTotalMemos[0].Visible := FShowColumnTotal and not FNoColumns;
  CornerMemos[1].Visible := FShowTitle and ColumnHeader.Visible;
  ColumnMemos[0].Visible := ColumnHeader.Visible and not FNoColumns;

  RowHeader.Visible := not FNoRows and FShowRowHeader;
  if FRowTotalMemos.Count > 0 then
    RowTotalMemos[0].Visible := FShowRowTotal and not FNoRows;
end;

procedure TfrxCustomCrossView.BeginMatrix;
begin
  InitMatrix;
  UpdateVisibility;
end;

procedure TfrxCustomCrossView.EndMatrix;
begin
  CreateHeaders;
  CalcTotals;
  CalcBounds(FAddWidth, FAddHeight);
end;

procedure TfrxCustomCrossView.FillMatrix;
begin
end;

procedure TfrxCustomCrossView.DoCalcHeight(Row: Integer; var Height: Extended);
var
  v: Variant;
begin
  if FOnCalcHeight <> '' then
  begin
    v := VarArrayOf([Row, GetRowIndexes(Row), Height]);
    if Report <> nil then
      Report.DoParamEvent(FOnCalcHeight, v);
    Height := v[2];
  end;
  if Assigned(FOnBeforeCalcHeight) then
    FOnBeforeCalcHeight(Row, GetRowIndexes(Row), Height);
end;

procedure TfrxCustomCrossView.DoCalcWidth(Column: Integer; var Width: Extended);
var
  v: Variant;
begin
  if FOnCalcWidth <> '' then
  begin
    v := VarArrayOf([Column, GetColumnIndexes(Column), Width]);
    if Report <> nil then
      Report.DoParamEvent(FOnCalcWidth, v);
    Width := v[2];
  end;
  if Assigned(FOnBeforeCalcWidth) then
    FOnBeforeCalcWidth(Column, GetColumnIndexes(Column), Width);
end;

function TfrxCustomCrossView.DoDragDrop(Source: TObject; X, Y: Integer;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
//  Result := False; // do not precess default enents
  FDragActive := False;
//  if Assigned(FComponentEditors) then
//    if FComponentEditors.DoCustomDragDrop(Source, Round(X / FScaleX), Round(Y / FScaleY), EventParams) then
//    begin
//      EventParams.Modified := True;
//      EventParams.Refresh := True;
//    end;
end;

function TfrxCustomCrossView.DoDragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
//  if Assigned(FComponentEditors) then
//    FComponentEditors.DoCustomDragOver(Source, Round(X / FScaleX), Round(Y / FScaleY), State, Accept, EventParams);
  if Accept then
    FDragActive := True;
end;

procedure TfrxCustomCrossView.DoOnCell(Memo: TfrxCustomMemoView;
  Row, Column, Cell: Integer; const Value: Variant);
var
  v: Variant;
begin
  if FOnPrintCell <> '' then
  begin
    v := VarArrayOf([frxInteger(Memo), Row, Column, Cell, GetRowIndexes(Row),
      GetColumnIndexes(Column), Value]);
    if Report <> nil then
      Report.DoParamEvent(FOnPrintCell, v);
  end;
  if Assigned(FOnBeforePrintCell) then
    FOnBeforePrintCell(Memo, Row, Column, Cell, GetRowIndexes(Row),
      GetColumnIndexes(Column), Value);
end;

procedure TfrxCustomCrossView.DoOnColumnHeader(Memo: TfrxCustomMemoView;
  Header: TfrxCrossHeader);
var
  v: Variant;
begin
  if FOnPrintColumnHeader <> '' then
  begin
    v := VarArrayOf([frxInteger(Memo), Header.GetIndexes, Header.GetValues, Header.Value]);
    if Report <> nil then
      Report.DoParamEvent(FOnPrintColumnHeader, v);
  end;
  if Assigned(FOnBeforePrintColumnHeader) then
    FOnBeforePrintColumnHeader(Memo, Header.GetIndexes, Header.GetValues, Header.Value);
end;

procedure TfrxCustomCrossView.DoOnRowHeader(Memo: TfrxCustomMemoView;
  Header: TfrxCrossHeader);
var
  v: Variant;
begin
  if FOnPrintRowHeader <> '' then
  begin
    v := VarArrayOf([frxInteger(Memo), Header.GetIndexes, Header.GetValues, Header.Value]);
    if Report <> nil then
      Report.DoParamEvent(FOnPrintRowHeader, v);
  end;
  if Assigned(FOnBeforePrintRowHeader) then
    FOnBeforePrintRowHeader(Memo, Header.GetIndexes, Header.GetValues, Header.Value);
end;

procedure TfrxCustomCrossView.BeforeStartReport;
begin
  inherited;
  InitMemos(True);
end;

procedure TfrxCustomCrossView.BeforePrint;
begin
  inherited;
  if FClearBeforePrint then
    BeginMatrix;
end;

procedure TfrxCustomCrossView.GetData;
begin
  inherited;
  Report.SetProgressMessage(frxResources.Get('crFillMx'));
  if IsCrossValid then
    FillMatrix;
  Report.SetProgressMessage(frxResources.Get('crBuildMx'));
  EndMatrix;
  RenderMatrix;
end;

procedure TfrxCustomCrossView.RenderMatrix;
var
  i, j, Page, SavePage, cIndex: Integer;
  CurY, FirstCurY, SaveCurY, AddWidth, MaxX: Extended;
  Band: TfrxBand;
  ColumnItems: TList;
  RowItems: TList;
  VarRowIndex, VarColumnIndex: TfrxVariable;
  aReport: TfrxReport;

  function GetCellBand(RowIndex, ColumnIndex: Integer): TfrxBand;
  var
    i, iFrom, iTo, j: Integer;
    Cell: Variant;
    CellIndex: Integer;
    ColumnItem, RowItem: TfrxCrossHeader;
    m, Memo: TfrxCustomMemoView;
    LeftMargin, TopMargin: Extended;
    SameMemos: array[0..63] of TfrxCustomMemoView;
    c, c1: TfrxReportComponent;
  begin
    RowItem := RowItems[RowIndex];

    Result := TfrxNullBand.Create(aReport);
    Result.ShiftEngine := seDontShift;
    Result.Height := RowItem.Bounds.Bottom;

    iFrom := FColumnBands[ColumnIndex].FromIndex;
    iTo := FColumnBands[ColumnIndex].ToIndex;
    LeftMargin := TfrxCrossHeader(ColumnItems[iFrom]).Bounds.Left;
    TopMargin := RowItem.Bounds.Top;

    for i := 0 to CellLevels - 1 do
      SameMemos[i] := nil;

    for i := iFrom to iTo do
    begin
      ColumnItem := ColumnItems[i];

      if FCellLevels > 1 then
        if FPlainCells then
        begin
          CellIndex := ColumnItem.FCellIndex;
          Cell := GetValue(RowIndex, ColumnItem.FIndex, CellIndex);
        end
        else
        begin
          CellIndex := RowItem.FCellIndex;
          Cell := GetValue(RowItem.FIndex, i, CellIndex);
        end
      else
      begin
        CellIndex := 0;
        Cell := GetValue(RowIndex, i, 0);
      end;

      m := CellMemos[ColumnItem.FTotalIndex * ((FRowLevels + 1) * FCellLevels) +
        RowItem.FTotalIndex * FCellLevels + CellIndex];
      Memo := CreateMemo(Result);
      Memo.Assign(m);
      SetupOriginalComponent(Memo, m);
      if Cell <> Null then
        THackMemoView(Memo).Value := Cell
      else
        THackMemoView(Memo).Value := 0;

      if THackMemoView(Memo).HideZeros and (not VarIsNull(THackMemoView(Memo).Value)) and (TVarData(THackMemoView(Memo).Value).VType <> varString)
      {$IFDEF Delphi12}and (TVarData(THackMemoView(Memo).Value).VType <> varUString){$ENDIF}  and
      (TVarData(THackMemoView(Memo).Value).VType <> varOleStr) and SameValue(THackMemoView(Memo).Value, 0) then
        Memo.Text := ''
      else
        Memo.Text := Memo.FormatData(Cell, CellMemos[CellIndex].DisplayFormat);

      //Memo.Rotation := 0;
      Memo.SetBounds(ColumnItem.Bounds.Left - LeftMargin + AddWidth,
        RowItem.Bounds.Top - TopMargin,
        ColumnItem.Bounds.Right,
        RowItem.Bounds.Bottom);
      CorrectDMPBounds(Memo);
      if Memo.AbsLeft + Memo.Width > MaxX then
        MaxX := Memo.AbsLeft + Memo.Width;
      Memo.Visible := (Memo.Width <> 0) and (Memo.Height <> 0);
      DoOnCell(Memo, RowItem.FIndex, ColumnItem.FIndex, CellIndex, Cell);

      if FBorder then
      begin
        if FPlainCells then
        begin
          if RowIndex = 0 then
            Memo.Frame.Typ := Memo.Frame.Typ + [ftTop];
          if (i = 0) and (CellIndex = 0) then
            Memo.Frame.Typ := Memo.Frame.Typ + [ftLeft];
          if (i = ColumnItems.Count - 1) and (CellIndex = CellLevels - 1) then
            Memo.Frame.Typ := Memo.Frame.Typ + [ftRight];
          if RowIndex = RowItems.Count - 1 then
            Memo.Frame.Typ := Memo.Frame.Typ + [ftBottom];
        end
        else
        begin
          if (RowIndex = 0) and (CellIndex = 0) then
            Memo.Frame.Typ := Memo.Frame.Typ + [ftTop];
          if i = 0 then
            Memo.Frame.Typ := Memo.Frame.Typ + [ftLeft];
          if i = ColumnItems.Count - 1 then
            Memo.Frame.Typ := Memo.Frame.Typ + [ftRight];
          if (RowIndex = RowItems.Count - 1) and (CellIndex = CellLevels - 1) then
            Memo.Frame.Typ := Memo.Frame.Typ + [ftBottom];
        end;
      end;

      { check if previous memo has the same value and JoinEqualCells is True }
      cIndex := CellIndex;
      { for PlainCells every next cell follows previous }
      if PlainCells then
        cIndex := 0;
      if JoinEqualCells then
        if RowItem.IsTotal or ColumnItem.IsTotal then
          SameMemos[cIndex] := nil
        else if (SameMemos[cIndex] = nil) or RowItem.IsTotal or ColumnItem.IsTotal or
          (TVarData(THackMemoView(Memo).Value).VType <> TVarData(THackMemoView(SameMemos[cIndex]).Value).VType) or
          (THackMemoView(SameMemos[cIndex]).Value <> THackMemoView(Memo).Value) then
          SameMemos[cIndex] := Memo
        else
        begin
          SameMemos[cIndex].Width := SameMemos[cIndex].Width + Memo.Width;
          SameMemos[cIndex].HAlign := haCenter;
          Memo.Free;
          Memo := SameMemos[cIndex];
        end;

      VarRowIndex.Value := RowIndex;
      VarColumnIndex.Value := i;
      aReport.LocalValue := THackMemoView(Memo).Value;
      aReport.CurObject := Memo.Name;
      aReport.DoBeforePrint(Memo);

      { process memo children if any }
      for j := 0 to m.Objects.Count - 1 do
      begin
        c := m.Objects[j];
        c1 := TfrxReportComponent(c.NewInstance);
        c1.Create(Result);
        c1.Assign(c);
        c1.Left := c1.Left + Memo.Left;
        c1.Top := c1.Top + Memo.Top;
        aReport.CurObject := c.Name;
        aReport.DoBeforePrint(c1);
      end;
    end;
  end;

  procedure DrawCorner(Offset: TfrxPoint);
  var
    i: Integer;
    Items: TList;
    Item: TfrxCrossHeader;
    r: TfrxRect;
    m: TfrxCustomMemoView;
  begin
    if not FShowRowHeader or not FShowColumnHeader or FNoRows or not FShowCorner then Exit;

    Items := Corner.AllItems;

    for i := 0 to Items.Count - 1 do
    begin
      Item := Items[i];
      m := Item.Memo;
      r := Item.Bounds;
      m.BeforePrint;
      m.Text := VarToWideStr(Item.Value);

      if Item.Value <> Null then
        THackMemoView(m).Value := Item.Value
      else
        THackMemoView(m).Value := 0;

      m.SetBounds(r.Left + Offset.X, r.Top + Offset.Y, r.Right, r.Bottom);
      CorrectDMPBounds(m);
      aReport.PreviewPages.AddObject(m);
      m.AfterPrint;
    end;

    Items.Free;
  end;

  procedure DoPagination(i, j: Integer);
  var
    k, kFrom, kTo: Integer;
  begin
    if ShowColumnHeader and (FRepeatHeaders or (i = 0)) then
    begin
      Band := FColumnBands[j].Band;
      Band.Top := CurY;
      aReport.Engine.ShowBand(Band);
    end;

    if ShowRowHeader and (FRepeatHeaders or (j = 0)) and not FNoRows then
    begin
      Band := FRowBands[i].Band;
      if j = 0 then
        Band.Left := Left
      else
        Band.Left := 0;
      Band.Top := Band.Top + CurY;
      aReport.Engine.ShowBand(Band);
      Band.Top := Band.Top - CurY;

      if ShowColumnHeader and (FRepeatHeaders or (i = 0)) then
        DrawCorner(frxPoint(Band.Left, Band.Top + CurY - ColumnHeaderHeight));
    end;

    if FRepeatHeaders or (i = 0) then
      aReport.Engine.CurY := CurY + ColumnHeaderHeight else
      aReport.Engine.CurY := CurY;
    if FRepeatHeaders or (j = 0) then
    begin
      AddWidth := RowHeaderWidth;
      if j = 0 then
        AddWidth := AddWidth + Left;
    end
    else
      AddWidth := 0;

    kFrom := FRowBands[i].FromIndex;
    kTo := FRowBands[i].ToIndex;

    for k := kFrom to kTo do
    begin
      Band := GetCellBand(k, j);
      Band.Top := aReport.Engine.CurY;
      aReport.Engine.ShowBand(Band);
      Band.Free;
    end;
  end;

begin
  aReport := Report;
  { chek if cross header doesn't fit on the free space}
  if ColumnHeaderHeight >= aReport.Engine.FreeSpace then
    aReport.Engine.NewPage;
  BuildColumnBands;
  BuildRowBands;

  ColumnItems := ColumnHeader.TerminalItems;
  RowItems := RowHeader.TerminalItems;
  SavePage := aReport.PreviewPages.CurPage;
  Page := SavePage;
  SaveCurY := aReport.Engine.CurY;
  CurY := SaveCurY;
  MaxX := 0;

  frxGlobalVariables['RowIndex'] := 0;
  frxGlobalVariables['ColumnIndex'] := 0;
  VarRowIndex := frxGlobalVariables.Items[frxGlobalVariables.IndexOf('RowIndex')];
  VarColumnIndex := frxGlobalVariables.Items[frxGlobalVariables.IndexOf('ColumnIndex')];

  if FDownThenAcross then
  begin
    FirstCurY := aReport.Engine.CurY;
    for i := 0 to FColumnBands.Count - 1 do
    begin
      for j := 0 to FRowBands.Count - 1 do
      begin
        aReport.PreviewPages.CurPage := Page + j;
        MaxX := 0;
        DoPagination(j, i);
        if j <> FRowBands.Count - 1 then
        begin
          aReport.Engine.BreakAllKeep;
          aReport.Engine.NewPage;
          CurY := aReport.Engine.CurY;
        end
        else if (NextCross <> nil) and ((FColumnBands.Count = 1) or (i > 0)) then
          NextCross.Left := MaxX + NextCrossGap;
      end;

      if i <> FColumnBands.Count - 1 then
        aReport.Engine.NewPage;
      CurY := FirstCurY;
      Inc(Page, FRowBands.Count);
      if not aReport.EngineOptions.EnableThreadSafe then
      	Application.ProcessMessages;
      if aReport.Terminated then break;
    end
  end
  else
    for i := 0 to FRowBands.Count - 1 do
    begin
      for j := 0 to FColumnBands.Count - 1 do
      begin
        aReport.PreviewPages.CurPage := Page + j;
        MaxX := 0;
        DoPagination(i, j);
        if j <> FColumnBands.Count - 1 then
        begin
          aReport.PreviewPages.AddPageAction := apWriteOver;
          aReport.Engine.NewPage;
        end
        else if NextCross <> nil then
          NextCross.Left := MaxX + NextCrossGap;
      end;

      if i <> FRowBands.Count - 1 then
      begin
        aReport.PreviewPages.AddPageAction := apAdd;
        aReport.Engine.BreakAllKeep;
        aReport.Engine.NewPage;
        Page := aReport.PreviewPages.CurPage;
      end
      else
        Inc(Page, FColumnBands.Count);
      CurY := aReport.Engine.CurY;
      if not aReport.EngineOptions.EnableThreadSafe then
      	Application.ProcessMessages;
      if aReport.Terminated then break;
    end;

  if Parent is TfrxBand then
    CurY := CurY - Height;
  { print last page footers }
  if FColumnBands.Count > 1 then
    aReport.Engine.EndPage;

  if NextCross <> nil then
  begin
    { position to last column, first row page }
    aReport.PreviewPages.CurPage := SavePage + FColumnBands.Count - 1;
    { for DownThenAcross we can try to print crosses side by side even when cross split to different pages }
    if DownThenAcross and (FColumnBands.Count > 1) then
      aReport.PreviewPages.CurPage := SavePage + (FColumnBands.Count - 1) * (FRowBands.Count);
    aReport.PreviewPages.AddPageAction := apAdd;
    aReport.Engine.CurY := SaveCurY;
  end
  else
  begin
    { position to last row, first column page }
    aReport.PreviewPages.CurPage := Page - FColumnBands.Count;
    aReport.PreviewPages.AddPageAction := apAdd;
    aReport.Engine.CurY := CurY;
  end;

  ColumnItems.Free;
  RowItems.Free;
  FColumnBands.Clear;
  FRowBands.Clear;
end;

procedure TfrxCustomCrossView.AddSourceObjects;
var
  i: Integer;
begin
  for i := 0 to FCellHeaderMemos.Count - 1 do
    Report.PreviewPages.AddToSourcePage(CellHeaderMemos[i]);
  for i := 0 to FCellMemos.Count - 1 do
    Report.PreviewPages.AddToSourcePage(CellMemos[i]);
  for i := 0 to FColumnMemos.Count - 1 do
  begin
    Report.PreviewPages.AddToSourcePage(ColumnMemos[i]);
    Report.PreviewPages.AddToSourcePage(ColumnTotalMemos[i]);
  end;
  for i := 0 to FCornerMemos.Count - 1 do
    Report.PreviewPages.AddToSourcePage(CornerMemos[i]);
  for i := 0 to FRowMemos.Count - 1 do
  begin
    Report.PreviewPages.AddToSourcePage(RowMemos[i]);
    Report.PreviewPages.AddToSourcePage(RowTotalMemos[i]);
  end;
end;

procedure TfrxCustomCrossView.SetupOriginalComponent(Obj1, Obj2: TfrxComponent);
begin
  THackComponent(Obj1).FOriginalComponent := THackComponent(Obj2).FOriginalComponent;
  THackComponent(Obj1).FAliasName := THackComponent(Obj2).FAliasName;
end;

procedure TfrxCustomCrossView.BuildColumnBands;
var
  i, j, LeftIndex, RightIndex: Integer;
  Items: TList;
  Item: TfrxCrossHeader;
  Memo: TfrxCustomMemoView;
  LargeBand: TfrxNullBand;
  CurWidth, AddWidth, LeftMargin, RightMargin: Extended;
  c: TfrxReportComponent;

  procedure CreateBand;
  var
    i: Integer;
    Band: TfrxNullBand;
    Memo, CutMemo: TfrxCustomMemoView;
    CutSize: Extended;
  begin
    Band := TfrxNullBand.Create(Report);
    Band.ShiftEngine := seDontShift;
    Band.Left := AddWidth;

    { move in-bounds memos to the new band }
    i := 0;
    while i < LargeBand.Objects.Count do
    begin
      Memo := LargeBand.Objects[i];
      if Memo.Left < RightMargin then
      begin
        if Memo.Left + Memo.Width <= RightMargin + 5 then
        begin
          Memo.Parent := Band;
          Memo.Visible := Memo.Width > 0;
          Dec(i);
        end
        else { cut off the memo }
        begin
          CutSize := RightMargin - Memo.Left;
          CutMemo := CreateMemo(Band);
          CutMemo.AssignAll(Memo);
          CutMemo.Width := CutSize;
          //if CutMemo.CalcWidth > CutSize then
            //CutMemo.Text := '';

          SetupOriginalComponent(CutMemo, Memo);
          Memo.Width := Memo.Width - CutSize;
          Memo.Left := Memo.Left + CutSize;
          if Memo is TfrxDMPMemoView then
          begin
            Memo.Left := Memo.Left + fr1CharX;
            Memo.Width := Memo.Width - fr1CharX;
          end;
          CutMemo.Frame.Typ := CutMemo.Frame.Typ - [ftRight];
          Memo.Frame.Typ := Memo.Frame.Typ - [ftLeft];

          //if Memo.CalcWidth > Memo.Width then
            //Memo.Text := '';
          Memo := CutMemo;
        end;

        Memo.Left := Memo.Left - LeftMargin;
      end;
      Inc(i);
    end;

    FColumnBands.Add(Band, LeftIndex, RightIndex);
  end;

begin
  FColumnBands.Clear;
  { create one large band }
  LargeBand := TfrxNullBand.Create(nil);
  LargeBand.ShiftEngine := seDontShift;
  Items := ColumnHeader.AllItems;

  { add memos to band }
  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    if (i = 0) and not FShowTitle then continue;
    Memo := CreateMemo(LargeBand);
    Memo.AssignAll(Item.Memo);
    SetupOriginalComponent(Memo, Item.Memo);
    Memo.Text := Memo.FormatData(Item.Value);

    if Item.Value <> Null then
      THackMemoView(Memo).Value := Item.Value
    else
      THackMemoView(Memo).Value := 0;

    Memo.Highlight.Condition := '';
    with Item.Bounds do
      Memo.SetBounds(Left, Top, Right, Bottom);
    CorrectDMPBounds(Memo);
    Memo.Visible := (Memo.Width <> 0) and (Memo.Height <> 0);
    DoOnColumnHeader(Memo, Item);

    Report.LocalValue := Item.Value;
    Report.CurObject := Memo.Name;
    Report.DoBeforePrint(Memo);

    { process memo children if any }
    for j := 0 to Memo.Objects.Count - 1 do
    begin
      c := Memo.Objects[j];
      Report.CurObject := c.Name;
      Report.DoBeforePrint(c);
    end;
  end;

  Items.Free;

  { cut it to small bands for each page }
  Items := ColumnHeader.TerminalItems;
  AddWidth := RowHeaderWidth;
  CurWidth := Report.Engine.PageWidth - AddWidth;
  LeftMargin := -Left;
  RightMargin := LeftMargin + CurWidth;
  LeftIndex := 0;
  RightIndex := Items.Count - 1;

  if not TfrxReportPage(Page).EndlessWidth then
    for i := 0 to Items.Count - 1 do
    begin
      Item := Items[i];
      { find right terminal item }
      if Item.Bounds.Left + Item.Bounds.Right - LeftMargin > CurWidth then
      begin
        RightMargin := Item.Bounds.Left;
        RightIndex := i - 1;
        CreateBand;
        LeftMargin := RightMargin;
        if FRepeatHeaders then
          AddWidth := RowHeaderWidth else
          AddWidth := 0;
        CurWidth := Report.Engine.PageWidth - AddWidth;
        RightMargin := LeftMargin + CurWidth;
        LeftIndex := RightIndex + 1;
        RightIndex := Items.Count - 1;
      end;
    end;

  if TfrxReportPage(Page).EndlessWidth then
  begin
    Item := Items[Items.Count - 1];
    CurWidth := Item.Bounds.Left + Item.Bounds.Right - LeftMargin + AddWidth;
    if Report.Engine.PageWidth < CurWidth then
      Report.Engine.PageWidth := CurWidth;
    RightMargin := 1e+6;
  end;

  { add last band }
  CreateBand;

  LargeBand.Free;
  Items.Free;
end;

procedure TfrxCustomCrossView.BuildRowBands;
var
  i, j, TopIndex, BottomIndex: Integer;
  Items: TList;
  Item, HParent: TfrxCrossHeader;
  Memo: TfrxCustomMemoView;
  LargeBand: TfrxNullBand;
  MaxHeight, CurHeight, AddHeight, TopMargin, BottomMargin: Extended;
  c: TfrxReportComponent;

  procedure CreateBand;
  var
    i: Integer;
    Band: TfrxNullBand;
    Memo, CutMemo: TfrxCustomMemoView;
    CutSize: Extended;
  begin
    Band := TfrxNullBand.Create(Report);
    Band.ShiftEngine := seDontShift;
    Band.Top := AddHeight;

    { move in-bounds memos to the new band }
    i := 0;
    while i < LargeBand.Objects.Count do
    begin
      Memo := LargeBand.Objects[i];
      if Memo.Top < BottomMargin then
      begin
        if Memo.Top + Memo.Height <= BottomMargin + 5 then
        begin
          Memo.Parent := Band;
          Dec(i);
        end
        else { cut off the memo }
        begin
          CutSize := BottomMargin - Memo.Top;
          CutMemo := CreateMemo(Band);
          CutMemo.AssignAll(Memo);
          CutMemo.Height := CutSize;
          SetupOriginalComponent(CutMemo, Memo);
          Memo.Height := Memo.Height - CutSize;
          Memo.Top := Memo.Top + CutSize;
          if Memo is TfrxDMPMemoView then
          begin
            Memo.Top := Memo.Top + fr1CharY;
            Memo.Height := Memo.Height - fr1CharY;
          end;
          CutMemo.Frame.Typ := CutMemo.Frame.Typ - [ftBottom];
          Memo.Frame.Typ := Memo.Frame.Typ - [ftTop];
          Memo := CutMemo;
        end;

        Memo.Top := Memo.Top - TopMargin;
      end;
      Inc(i);
    end;

    FRowBands.Add(Band, TopIndex, BottomIndex);
  end;

begin
  FRowBands.Clear;
  LargeBand := TfrxNullBand.Create(nil);
  LargeBand.ShiftEngine := seDontShift;
  Items := RowHeader.AllItems;
  MaxHeight := 0;
  HParent := nil;

  { create one large band }
  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    Memo := CreateMemo(LargeBand);
    Memo.AssignAll(Item.Memo);
    SetupOriginalComponent(Memo, Item.Memo);

    if Item.Value <> Null then
      THackMemoView(Memo).Value := Item.Value
    else
      THackMemoView(Memo).Value := 0;

    Memo.Text := Memo.FormatData(Item.Value);
    Memo.Highlight.Condition := '';
    with Item.Bounds do
      Memo.SetBounds(Left, Top, Right, Bottom);
    CorrectDMPBounds(Memo);
    Memo.Visible := (Memo.Width <> 0) and (Memo.Height <> 0);
    DoOnRowHeader(Memo, Item);
    if Item.Bounds.Top + Item.Bounds.Bottom > MaxHeight then
      MaxHeight := Item.Bounds.Top + Item.Bounds.Bottom;

    Report.LocalValue := Item.Value;
    Report.CurObject := Memo.Name;
    Report.DoBeforePrint(Memo);

    { process memo children if any }
    for j := 0 to Memo.Objects.Count - 1 do
    begin
      c := Memo.Objects[j];
      Report.CurObject := c.Name;
      Report.DoBeforePrint(c);
    end;
  end;

  Items.Free;

  { cut it to small bands for each page }
  Items := RowHeader.TerminalItems;
  AddHeight := ColumnHeaderHeight;
  CurHeight := Report.Engine.FreeSpace - AddHeight;
  if (MaxHeight > CurHeight) and KeepTogether then
  begin
    Report.Engine.NewPage;
    AddHeight := ColumnHeaderHeight;
    CurHeight := Report.Engine.FreeSpace - AddHeight;
  end;

  TopMargin := 0;
  BottomMargin := TopMargin + CurHeight;
  TopIndex := 0;
  BottomIndex := Items.Count - 1;

  for i := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    { find right terminal item }

    { keep rows by top parent }
    if FKeepRowsTogether then
    begin
      HParent := Item.Parent;
      while (HParent.Parent <> nil) do
      begin
        if (HParent.Parent.Parent = nil) then
          Break;
        HParent := HParent.Parent;
      end;
    end;

    if ((HParent <> nil) and (CurHeight > HParent.Bounds.Bottom)
      and (CurHeight - (HParent.Bounds.Top - TopMargin) < HParent.Bounds.Bottom))
        or  (Item.Bounds.Top + Item.Bounds.Bottom - TopMargin > CurHeight) then
    begin
      BottomMargin :=  Item.Bounds.Top;
      BottomIndex :=  i - 1;
      CreateBand;
      TopMargin := BottomMargin;
      if FRepeatHeaders then
        AddHeight := ColumnHeaderHeight else
        AddHeight := 0;
     if (Parent is TfrxDataBand) and (TfrxDataBand(Parent).FHeader is TfrxHeader)
      and TfrxHeader(TfrxDataBand(Parent).FHeader).ReprintOnNewPage then
        CurHeight := Report.Engine.PageHeight - Report.Engine.CurY -
          Report.Engine.FooterHeight - AddHeight
      else
        CurHeight := Report.Engine.PageHeight - Report.Engine.HeaderHeight -
          Report.Engine.FooterHeight - AddHeight;
      BottomMargin := TopMargin + CurHeight;
      TopIndex := BottomIndex + 1;
      BottomIndex := Items.Count - 1;
    end;
  end;

  CreateBand;

  LargeBand.Free;
  Items.Free;
end;

{$IFDEF FR_COM}
function TfrxCustomCrossView.Get_CellFields(out Value: WideString): HResult; stdcall;
begin
  Value := WideString(String(CellFields.GetText));
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_CellFields(const Value: WideString): HResult; stdcall;
begin
  CellFields.SetText( PChar(Value) );
  CellLevels := CellFields.Count;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_CellFunctions(Index: Integer; out Value: frxCrossFunction): HResult; stdcall;
begin
  Value := frxCrossFunction(CellFunctions[Index]);
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_CellFunctions(Index: Integer; Value: frxCrossFunction): HResult; stdcall;
begin
  CellFunctions[Index] := TfrxCrossFunction(Value);
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_CellMemos(Index: Integer; out Value: IfrxCustomMemoView): HResult; stdcall;
begin
  Value := CellMemos[Index];
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_ColumnFields(out Value: WideString): HResult; stdcall;
begin
  Value := WideString(String(ColumnFields.GetText));
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_ColumnFields(const Value: WideString): HResult; stdcall;
begin
  ColumnFields.SetText( PChar(Value) );
  ColumnLevels := ColumnFields.Count;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_ColumnMemos(Index: Integer; out Value: IfrxCustomMemoView): HResult; stdcall;
begin
  Value := ColumnMemos[Index];
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_ColumnSort(Index: Integer; out Value: frxCrossSortOrder): HResult; stdcall;
begin
  Value := frxCrossSortOrder(ColumnSort[Index]);
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_ColumnSort(Index: Integer; Value: frxCrossSortOrder): HResult; stdcall;
begin
  ColumnSort[Index] := TfrxCrossSortOrder(Value);
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_ColumnTotalMemos(Index: Integer; out Value: IfrxCustomMemoView): HResult; stdcall;
begin
  Value := ColumnTotalMemos[Index];
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_RowFields(out Value: WideString): HResult; stdcall;
begin
  Value := WideString(String(RowFields.GetText));
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_RowFields(const Value: WideString): HResult; stdcall;
begin
  RowFields.SetText( PChar(Value) );
  RowLevels := RowFields.Count;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_RowMemos(Index: Integer; out Value: IfrxCustomMemoView): HResult; stdcall;
begin
  Value := RowMemos[Index];
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_RowSort(Index: Integer; out Value: frxCrossSortOrder): HResult; stdcall;
begin
  Value := frxCrossSortOrder( RowSort[Index] );
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_RowSort(Index: Integer; Value: frxCrossSortOrder): HResult; stdcall;
begin
  RowSort[Index] := TfrxCrossSortOrder( Value );
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_RowTotalMemos(Index: Integer; out Value: IfrxCustomMemoView): HResult; stdcall;
begin
  Value := RowTotalMemos[Index];
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_MaxWidth(out Value: Integer): HResult; stdcall;
begin
  Value := MaxWidth;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_MaxWidth(Value: Integer): HResult; stdcall;
begin
  MaxWidth := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_MinWidth(out Value: Integer): HResult; stdcall;
begin
  Value := MinWidth;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_MinWidth(Value: Integer): HResult; stdcall;
begin
  MinWidth := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.AddValues(Rows: PSafeArray; Columns: PSafeArray; Cells: PSafeArray): HResult; stdcall;
type
  VariantArray = array of Variant;
var
  ArrayData: Pointer;
  R: VariantArray;
  C: VariantArray;
  V: VariantArray;
begin
  SafeArrayAccessData( Rows, ArrayData);
  R := VariantArray(ArrayData);
  SetLength(R,Rows.cDims);
  SafeArrayUnAccessData( Rows );

  SafeArrayAccessData( Columns, ArrayData );
  C := VariantArray(ArrayData);
  SetLength(C,Rows.cDims);
  SafeArrayUnAccessData( Columns );

  SafeArrayAccessData( Cells, ArrayData );
  V := VariantArray(ArrayData);
  SetLength(V,Rows.cDims);
  SafeArrayUnAccessData( Cells );
  AddValue( R, C, V );
  Result := S_OK;
end;

function TfrxCustomCrossView.AddValuesVB6(Rows: OleVariant; Columns: OleVariant; Cells: OleVariant): HResult; stdcall;
var
  r: PSafeArray;
  c: PSafeArray;
  v: PSafeArray;
begin
  Result := E_HANDLE;
  repeat
    if not VarIsArray(Rows) then break;
    if not VarIsArray(Columns) then break;
    if not VarIsArray(Cells) then break;
    r := VarArrayLock(Rows);
    c := VarArrayLock(Columns);
    v := VarArrayLock(Cells);
    Result := AddValues(r, c, v);
    VarArrayUnlock(Cells);
    VarArrayUnlock(Columns);
    VarArrayUnlock(Rows);
  until True;
end;

function TfrxCustomCrossView.Get_GapX(out Value: Integer): HResult; stdcall;
begin
  Value := GapX;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_GapX(Value: Integer): HResult; stdcall;
begin
  GapX := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_GapY(out Value: Integer): HResult; stdcall;
begin
  Value := GapY;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_GapY(Value: Integer): HResult; stdcall;
begin
  GapY := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_PlainCells(out Value: WordBool): HResult; stdcall;
begin
  Value := PlainCells;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_PlainCells(Value: WordBool): HResult; stdcall;
begin
  PlainCells := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_DownThenAcross(out Value: WordBool): HResult; stdcall;
begin
  Value := DownThenAcross;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_DownThenAcross(Value: WordBool): HResult; stdcall;
begin
  DownThenAcross := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_RepeatHeaders(out Value: WordBool): HResult; stdcall;
begin
  Value := RepeatHeaders;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_RepeatHeaders(Value: WordBool): HResult; stdcall;
begin
  RepeatHeaders := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_ShowColumnHeader(out Value: WordBool): HResult; stdcall;
begin
  Value := ShowColumnHeader;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_ShowColumnHeader(Value: WordBool): HResult; stdcall;
begin
  ShowColumnHeader := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_ShowColumnTotal(out Value: WordBool): HResult; stdcall;
begin
  Value := ShowColumnTotal;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_ShowColumnTotal(Value: WordBool): HResult; stdcall;
begin
  ShowColumnTotal := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_ShowRowHeader(out Value: WordBool): HResult; stdcall;
begin
  Value := ShowRowHeader;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_ShowRowHeader(Value: WordBool): HResult; stdcall;
begin
  ShowRowHeader := Value;
  Result := S_OK;
end;

function TfrxCustomCrossView.Get_ShowRowTotal(out Value: WordBool): HResult; stdcall;
begin
  Value := ShowRowTotal;
  Result := S_OK;
end;

function TfrxCustomCrossView.Set_ShowRowTotal(Value: WordBool): HResult; stdcall;
begin
  ShowRowTotal := Value;
  Result := S_OK;
end;
{$ENDIF}

{ TfrxCrossView }

class function TfrxCrossView.GetDescription: String;
begin
  Result := frxResources.Get('obCross');
end;

function TfrxCrossView.IsCrossValid: Boolean;
begin
  Result := (FCellLevels > 0) and (FRowLevels >= 0) and (FColumnLevels >= 0);
end;

procedure TfrxCrossView.SetCellLevels(const Value: Integer);
var
  i: Integer;
begin
  inherited;
  FCellFields.Clear;
  if Value = 1 then
    FCellFields.Add('Cell')
  else
    for i := 0 to Value - 1 do
      FCellFields.Add('Cell' + IntToStr(i + 1));
end;

procedure TfrxCrossView.SetColumnLevels(const Value: Integer);
var
  i: Integer;
begin
  inherited;
  FColumnFields.Clear;
  if Value = 1 then
    FColumnFields.Add('Column')
  else
    for i := 0 to Value - 1 do
      FColumnFields.Add('Column' + IntToStr(i + 1));
end;

procedure TfrxCrossView.SetRowLevels(const Value: Integer);
var
  i: Integer;
begin
  inherited;
  FRowFields.Clear;
  if Value = 1 then
    FRowFields.Add('Row')
  else
    for i := 0 to Value - 1 do
      FRowFields.Add('Row' + IntToStr(i + 1));
end;


{ TfrxDBCrossView }

class function TfrxDBCrossView.GetDescription: String;
begin
  Result := frxResources.Get('obDBCross');
end;

function TfrxDBCrossView.IsCrossValid: Boolean;
begin
  Result := (DataSet <> nil) and (FCellLevels > 0) and
    (FRowFields.Count = FRowLevels) and (FColumnFields.Count = FColumnLevels) and
    (FCellFields.Count = FCellLevels);
end;

procedure TfrxDBCrossView.FillMatrix;
var
  i: Integer;
  RowValues, ColumnValues, CellValues: array of Variant;
  sl: TStringList;
begin
  SetLength(RowValues, FRowLevels);
  SetLength(ColumnValues, FColumnLevels);
  SetLength(CellValues, FCellLevels);

  sl := TStringList.Create;
  try
    DataSet.Open;
    DataSet.GetFieldList(sl);
    sl.Sorted := True;

    DataSet.First;
    while not DataSet.Eof do
    begin
      { fix for preview on timer }
      if not Report.EngineOptions.EnableThreadSafe then
      	Application.ProcessMessages;
      if Report.Terminated then Exit;
      for i := 0 to FRowLevels - 1 do
      begin
        if sl.IndexOf(FRowFields[i]) <> -1 then
          RowValues[i] := DataSet.Value[FRowFields[i]]
        else
          RowValues[i] := Report.Calc(FRowFields[i])
      end;
      for i := 0 to FColumnLevels - 1 do
      begin
        if sl.IndexOf(FColumnFields[i]) <> -1 then
          ColumnValues[i] := DataSet.Value[FColumnFields[i]]
        else
          ColumnValues[i] := Report.Calc(FColumnFields[i])
      end;
      for i := 0 to FCellLevels - 1 do
      begin
        if sl.IndexOf(FCellFields[i]) <> -1 then
          CellValues[i] := DataSet.Value[FCellFields[i]]
        else
          CellValues[i] := Report.Calc(FCellFields[i])
      end;
      AddValue(RowValues, ColumnValues, CellValues);
      DataSet.Next;
    end;
  finally
    sl.Free;
  end;

  RowValues := nil;
  ColumnValues := nil;
  CellValues := nil;
end;

{$IFDEF FPC}
{procedure RegisterUnitfrxCross;
begin
  RegisterComponents('Fast Report 6',[TfrxCrossObject]);
  RegisterNoIcon([TfrxCrossView, TfrxDBCrossView]);
end;

procedure Register;
begin
  RegisterUnit('frxCross',@RegisterUnitfrxCross);
end; }
{$ENDIF}


{$IFNDEF RAD_ED}
initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxCrossObject, TControl);
{$ENDIF}
  frxObjects.RegisterObject1(TfrxCrossView, nil, '', '', 0, 42, [ctReport, ctDMP]);
  frxObjects.RegisterObject1(TfrxDBCrossView, nil, '', '', 0, 49, [ctReport, ctDMP]);
  frxResources.Add('TfrxPrintCellEvent',
    'PascalScript=(Memo: TfrxMemoView; RowIndex, ColumnIndex, CellIndex: Integer; RowValues, ColumnValues, Value: Variant);' + #13#10 +
    'C++Script=(TfrxMemoView Memo, int RowIndex, int ColumnIndex, int CellIndex, variant RowValues, variant ColumnValues, variant Value)' + #13#10 +
    'BasicScript=(Memo, RowIndex, ColumnIndex, CellIndex, RowValues, ColumnValues, Value)' + #13#10 +
    'JScript=(Memo, RowIndex, ColumnIndex, CellIndex, RowValues, ColumnValues, Value)');
  frxResources.Add('TfrxPrintHeaderEvent',
    'PascalScript=(Memo: TfrxMemoView; HeaderIndexes, HeaderValues, Value: Variant);' + #13#10 +
    'C++Script=(TfrxMemoView Memo, variant HeaderIndexes, variant HeaderValues, variant Value)' + #13#10 +
    'BasicScript=(Memo, HeaderIndexes, HeaderValues, Value)' + #13#10 +
    'JScript=(Memo, HeaderIndexes, HeaderValues, Value)');
  frxResources.Add('TfrxCalcWidthEvent',
    'PascalScript=(ColumnIndex: Integer; ColumnValues: Variant; var Width: Extended);' + #13#10 +
    'C++Script=(int ColumnIndex, variant ColumnValues, float &Width)' + #13#10 +
    'BasicScript=(ColumnIndex, ColumnValues, byref Width)' + #13#10 +
    'JScript=(ColumnIndex, ColumnValues, &Width)');
  frxResources.Add('TfrxCalcHeightEvent',
    'PascalScript=(RowIndex: Integer; RowValues: Variant; var Height: Extended);' + #13#10 +
    'C++Script=(int RowIndex, variant RowValues, float &Height)' + #13#10 +
    'BasicScript=(RowIndex, RowValues, byref Height)' + #13#10 +
    'JScript=(RowIndex, RowValues, &Height)');

finalization
  frxObjects.UnRegister(TfrxCrossView);
  frxObjects.UnRegister(TfrxDBCrossView);
{$ENDIF}


end.
