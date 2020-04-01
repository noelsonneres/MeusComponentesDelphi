
{******************************************}
{                                          }
{             FastReport v6.0              }
{         Map Interactive Layer Editor     }
{                                          }
{            Copyright (c) 2017            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapILEditor;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType, LCLIntf, LCLProc,
{$ENDIF}
  Classes, Graphics, Controls, Forms, Buttons, ComCtrls, StdCtrls,
  ExtCtrls, ToolWin, Dialogs, Menus, Messages,
  frxClass, frxMapInteractiveLayer, frxMap, frxMapHelpers, frxMapShape,
  frxAnaliticGeometry, frxPolygonTemplate;

type
  TCanvasMapPair = class
  private
    FCanvasPoint: TfrxPoint;
    FMapPoint: TfrxPoint;
    FConverter: TMapToCanvasCoordinateConverter;
    procedure SetCanvasPoint(const Value: TfrxPoint);
    procedure SetMapPoint(const Value: TfrxPoint);
  public
    constructor Create(Converter: TMapToCanvasCoordinateConverter);
    constructor CreateClone(CanvasMapPair: TCanvasMapPair);
    procedure CalcCanvas;
    procedure CalcMap;
    procedure CanvasShift(dX, dY: Extended);

    property CanvasPoint: TfrxPoint read FCanvasPoint write SetCanvasPoint;
    property MapPoint: TfrxPoint read FMapPoint write SetMapPoint;
  end;

  TGraphicView = record
    PenWidth: Integer;
    PenStyle: TPenStyle;
    PenColor: TColor;
    BrushStyle: TBrushStyle;
    BrushColor: TColor;
  end;

  TFigureCreateRecord = record
    Converter: TMapToCanvasCoordinateConverter;
    Canvas: TCanvas;
    X, Y: Integer;
    Shape: TShape;
  end;
function FigureCreateRecord(Converter: TMapToCanvasCoordinateConverter;
  Canvas: TCanvas; X, Y: Integer; Shape: TShape): TFigureCreateRecord;

type
  TVirtualCursor = (vcDefault, vcCanSelect,
    vcMoveMobile, vcFixAndAdd, vcFix, vcUnfix, vcUnfixSegment,
    vcSize, vcSizeNESW, vcSizeNS, vcSizeNWSE, vcSizeWE);

  TAbstractFigure = class
  protected
    FShape: TShape;
    FCanvas: TCanvas;
    FConverter: TMapToCanvasCoordinateConverter;

    FLastPoint: TCanvasMapPair;

    procedure ReadShapeData; virtual; abstract;

    procedure SetupGraphics(GV: TGraphicView);
    procedure DrawCircle(Center: TfrxPoint; GV: TGraphicView; Radius: Integer = Unknown);
    procedure DrawLine(P1, P2: TfrxPoint; GV: TGraphicView);
    procedure DrawRect(TopLeft, BottomRight: TfrxPoint; GV: TGraphicView);
    procedure DrawPolygon(Points: TPointArray; GV: TGraphicView);
    procedure DrawEllipse(TopLeft, BottomRight: TfrxPoint; GV: TGraphicView);

    procedure DrawMobilePoint;

    function IsNearLastPoint(const X, Y: Integer): boolean;
  public
    constructor Create(FCR: TFigureCreateRecord);
    destructor Destroy; override;
    procedure Draw; virtual; abstract;
    procedure SetConstrainProportions(AConstrainProportions: Boolean); virtual; // Empty
    function ShapeName: String; virtual; abstract;
    function MouseDown(const X, Y: Integer): boolean; virtual; abstract;
    function MouseMove(const X, Y: Integer): boolean; virtual; abstract;
    procedure MouseUp(const X, Y: Integer); virtual; // Empty
    procedure RecalcCanvas; virtual;
    function GetCursor(const X, Y: Integer): TVirtualCursor; virtual; abstract;
    function ShapeType: TShapeType; virtual; abstract;
    function GetShapeData(Strings: TStrings): TShapeData; virtual; abstract;
    function IsCanDeletePoint: boolean; virtual; // False
    function IsCanDeleteShape: boolean; virtual;
    function IsCanSave: boolean; virtual; // True;
    function IsCanVK_DELETE: boolean; virtual; // True;
    procedure DeletePoint; virtual; // Empty
  end;

{$IfNdef Delphi10}
  TPaintBox = class(ExtCtrls.TPaintBox)
  private
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  published
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
  end;
{$EndIf}

  TfrxMapILEditorForm = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    ShapeGroupBox: TGroupBox;
    TagsMemo: TMemo;
    TagsLabel: TLabel;
    CancelShapeButton: TButton;
    SaveShapeButton: TButton;
    MapPanel: TPanel;
    MapPaintBox: TPaintBox;
    RemoveShapeButton: TButton;
    PolyGroupBox: TGroupBox;
    DeletePointButton: TButton;
    PictureGroupBox: TGroupBox;
    EditPictureButton: TButton;
    ConstrainProportionsCheckBox: TCheckBox;
    LegendGroupBox: TGroupBox;
    TextMemo: TMemo;
    LabelFontButton: TButton;
    LabelFontLabel: TLabel;
    FontDialog: TFontDialog;
    TopPanel: TPanel;
    SelectSpeedButton: TSpeedButton;
    PointSpeedButton: TSpeedButton;
    PointPopupMenu: TPopupMenu;
    Point1: TMenuItem;
    Polyline1: TMenuItem;
    Polygon1: TMenuItem;
    PointMenuSpeedButton: TSpeedButton;
    RectSpeedButton: TSpeedButton;
    RectMenuSpeedButton: TSpeedButton;
    RectPopupMenu: TPopupMenu;
    Rectangle1: TMenuItem;
    Ellipse1: TMenuItem;
    Diamond1: TMenuItem;
    PictureSpeedButton: TSpeedButton;
    PictureMenuSpeedButton: TSpeedButton;
    PicturePopupMenu: TPopupMenu;
    Picture1: TMenuItem;
    Legend1: TMenuItem;
    TemplateSpeedButton: TSpeedButton;
    TemplateMenuSpeedButton: TSpeedButton;
    TemplatePopupMenu: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: boolean);
    procedure FormResize(Sender: TObject);
    procedure MapPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MapPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MapPaintBoxMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure MapPaintBoxPaint(Sender: TObject);
    procedure SaveShapeButtonClick(Sender: TObject);
    procedure CancelShapeButtonClick(Sender: TObject);
    procedure RemoveShapeButtonClick(Sender: TObject);
    procedure DeletePointButtonClick(Sender: TObject);
    procedure EditPictureButtonClick(Sender: TObject);
    procedure ConstrainProportionsCheckBoxClick(Sender: TObject);
    procedure TextMemoChange(Sender: TObject);
    procedure LabelFontButtonClick(Sender: TObject);
    procedure PointMenuSpeedButtonClick(Sender: TObject);
    procedure Point1Click(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure RectMenuSpeedButtonClick(Sender: TObject);
    procedure Picture1Click(Sender: TObject);
    procedure PictureMenuSpeedButtonClick(Sender: TObject);
    procedure MapPaintBoxMouseLeave(Sender: TObject);
    procedure TemplateMenuSpeedButtonClick(Sender: TObject);
    procedure TemplateClick(Sender: TObject);
  private
    FMap: TfrxMapView;
    FOriginalMap: TfrxMapView;
    FReportDesigner: TfrxCustomDesigner;
    FLayer: TfrxMapInteractiveLayer;
    FFigure: TAbstractFigure;
    FPreviousLines: TStringList;
    FCurentCursor: TCursor;

    procedure Change;
    procedure SetLayer(const Value: TfrxMapInteractiveLayer);
    procedure FontDialogToLabel(Lbl: TLabel);
    procedure RefreshCursor(VirtualCursor: TVirtualCursor);
    procedure LoadTemplates;
  protected
    FPointNextFigure: TShapeType;
    FRectNextFigure: TShapeType;
    FPictureNextFigure: TShapeType;

    function NextTemplateName: String;
    function IsInsidePaintBox(const X, Y: Integer): boolean;

    procedure CancelEditing;

    procedure FigureCreate(const X, Y: Integer);
    function NextFigureShapeType: TShapeType;

    function OffsetPoint(X, Y: Extended): TfrxPoint; overload;
    function OffsetPoint(P: TfrxPoint): TfrxPoint; overload;

    procedure UpdateControls;
  public
    property Layer: TfrxMapInteractiveLayer read FLayer write SetLayer;
    property ReportDesigner: TfrxCustomDesigner read FReportDesigner write FReportDesigner;
  end;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  Math, Types, SysUtils, Contnrs, {$IFDEF DELPHI16} System.UITypes, {$ENDIF}
  frxCustomEditors, frxRes, frxDsgnIntf, frxMapLayer, frxMapShapeTags, frxUtils,
  frxEditPicture;

const
  InitialPictureSize = 64;

function FigureCreateRecord(Converter: TMapToCanvasCoordinateConverter;
  Canvas: TCanvas; X, Y: Integer; Shape: TShape): TFigureCreateRecord;
begin
  Result.Converter := Converter;
  Result.Canvas := Canvas;
  Result.X := X;
  Result.Y := Y;
  Result.Shape := Shape;
end;

const
  ZoomFactor = 1.1;
  MinSelectDistance = 8;
  FocusRectIndent = 2 * MinSelectDistance;

  PenMode = pmXor;
  MobileView: TGraphicView = (PenWidth: 2; PenStyle: psSolid; PenColor: clAqua;
    BrushStyle: bsSolid; BrushColor: clFuchsia;
  );
  FixedView: TGraphicView = (PenWidth: 3; PenStyle: psSolid; PenColor: clYellow;
    BrushStyle: bsSolid; BrushColor: clYellow;
  );
  FocusRectView: TGraphicView = (PenWidth: 1; PenStyle: psDot; PenColor: clYellow;
    BrushStyle: bsClear; BrushColor: clNone;
  );
  RectView: TGraphicView = (PenWidth: 3; PenStyle: psSolid; PenColor: clYellow;
    BrushStyle: bsClear; BrushColor: clNone;
  );

type
  TPointFigure = class(TAbstractFigure)
  protected
    procedure ReadShapeData; override;
  public
    procedure Draw; override;
    function ShapeName: String; override;
    function MouseMove(const X, Y: Integer): boolean; override;
    function MouseDown(const X, Y: Integer): boolean; override;
    function GetCursor(const X, Y: Integer): TVirtualCursor; override;
    function ShapeType: TShapeType; override;
    function GetShapeData(Strings: TStrings): TShapeData; override;
  end;

  TFocusMarker = (fmLeftTop, fmRightTop, fmRightBottom, fmLeftBottom, fmLeft, fmTop, fmRight, fmBottom);

const
  LeftSide = [fmLeft, fmLeftTop, fmLeftBottom];
  RightSide = [fmRight, fmRightTop, fmRightBottom];
  TopSide = [fmTop, fmLeftTop, fmRightTop];
  BottomSide = [fmBottom, fmLeftBottom, fmRightBottom];

type
  TAbstract2DResizer = class
  protected
    FMarker: TFocusMarker;
  public
    procedure Init(AMarker: TFocusMarker); virtual;
    procedure Resize(const X, Y: Integer); virtual; abstract;
  end;

  TFigureState = (fsEmpty, fsAddBegin, fsAddEnd, fsAddMiddle,
    fsSelected, fsSelectedMoveMap, fsSelectedMoveShape, fsSelectedResize,
    fsPartial, fsComplete);

  TAbstract2DFigure = class (TAbstractFigure)
  protected
    FMD: TMinDistance;
    FState: TFigureState;
    FResizer: TAbstract2DResizer;

    function CalcFocusRect: TRect; virtual; abstract;
    function CalcFocusDoubleRect: TDoubleRect; virtual; abstract;
    function FocusMarkerCenter(fm: TFocusMarker): TPoint;
    procedure DrawFocusRectangle;
    procedure CanvasShift(dX, dY: Extended); virtual; abstract;
    procedure LPMoveShape(const X, Y: Integer);
    procedure LPResizeShape(const X, Y: Integer);
    function IsNearFocusMarker(const X, Y: Integer; out FocusMarker: TFocusMarker): boolean;
    function IsInsideFocusRect(const X, Y: Integer): boolean;
    function IsSelected: Boolean; virtual; // True
  public
    constructor Create(FCR: TFigureCreateRecord);
    destructor Destroy; override;
    function GetCursor(const X, Y: Integer): TVirtualCursor; override;

    function MouseDown(const X, Y: Integer): boolean; override;
    function MouseMove(const X, Y: Integer): boolean; override;
    procedure MouseUp(const X, Y: Integer); override;
  end;

  TPairList = class(TObjectList)
  private
    function GetPair(Index: Integer): TCanvasMapPair;
    procedure SetPair(Index: Integer; const Value: TCanvasMapPair);
  public
    procedure RecalcCanvas;
    function CalcFocusDoubleRect: TDoubleRect;
    function GetSegment(Index: Integer): TSegment;
    procedure CanvasShift(dX, dY: Extended);
    function CanvasPoints: TPointArray;

    property Items[Index: Integer]: TCanvasMapPair read GetPair write SetPair; default;
  end;

  TMultyPointResizer = class (TAbstract2DResizer)
  protected
    FInitialRect, FInnerRect: TDoubleRect;
    FInnerWidth, FInnerHeight: Double;
    FInitialPairList: TPairList;
    FParentPairList: TPairList;

    procedure Factors(const X, Y: Integer; out FX, FY: Extended);
  public
    constructor Create(AParentPairList: TPairList);
    destructor Destroy; override;
    procedure Init(AMarker: TFocusMarker); override;
    procedure Resize(const X, Y: Integer); override;
  end;

  TAbstractMultyPointFigure = class(TAbstract2DFigure)
  protected
    FPairList: TPairList;

    procedure ReadShapeData; override;

    function CalcFocusRect: TRect; override;
    function CalcFocusDoubleRect: TDoubleRect; override;
    function MinCount: Integer; virtual; abstract;
    procedure CanvasShift(dX, dY: Extended); override;

    function IsSelected: Boolean; override;
    function IsNearPoint(const X, Y: Integer; out PointIndex: Integer): boolean;
  public
    constructor Create(FCR: TFigureCreateRecord);
    destructor Destroy; override;
    procedure RecalcCanvas; override;
    function IsCanSave: boolean; override;
    function GetShapeData(Strings: TStrings): TShapeData; override;
  end;

  TTemplateFigure = class(TAbstractMultyPointFigure)
  protected
    FPT: TfrxPolygonTemplate;
    function MinCount: Integer; override;
    procedure AddPoint(const X, Y: Integer);
  public
    FMovedPointIndex: Integer;

    constructor Create(FCR: TFigureCreateRecord; APT: TfrxPolygonTemplate);
    function GetCursor(const X, Y: Integer): TVirtualCursor; override;
    procedure Draw; override;
    function IsCanDeletePoint: boolean; override;
    function IsCanFix: boolean;
    function GetShapeData(Strings: TStrings): TShapeData; override;

    function MouseDown(const X, Y: Integer): boolean; override;
    function MouseMove(const X, Y: Integer): boolean; override;
    procedure MouseUp(const X, Y: Integer); override;
    function ShapeName: String; override;
    function ShapeType: TShapeType; override;
  end;

  TAbstractPolyFigure = class(TAbstractMultyPointFigure)
  protected
    FMiddleRight: Integer;

    procedure DrawMobileLine(Index: Integer);
    procedure DrawFixedLine(Index: Integer); // Right Index
    procedure DrawMobile;
    procedure DrawFixed;

    function FirstLineNumber: Integer; virtual; abstract;
    function UnfixStateByIndex(PointIndex: Integer): TFigureState; virtual; abstract;
    procedure CloseFigure; virtual; // Empty

    procedure LPAddToFigure;
    procedure LPFix(const X, Y: Integer);
    procedure LPFixAndAdd(const X, Y: Integer);
    procedure LPMoveMobile(const X, Y: Integer);
    procedure LPUnfixPoint(const X, Y, PointIndex: Integer);
    procedure LPUnfixSegment(const X, Y, PointIndex: Integer);

    function IsNearSegment(const X, Y: Integer; out PointIndex: Integer): boolean;
  public
    function GetCursor(const X, Y: Integer): TVirtualCursor; override;
    procedure Draw; override;
    function IsCanDeletePoint: boolean; override;
    function IsCanDeleteShape: boolean; override;
    function IsCanFix: boolean;
    procedure DeletePoint; override;

    function MouseDown(const X, Y: Integer): boolean; override;
    function MouseMove(const X, Y: Integer): boolean; override;
  end;

  TPolylineFigure = class(TAbstractPolyFigure)
  protected
    function FirstLineNumber: Integer; override;
    function MinCount: Integer; override;
    function UnfixStateByIndex(PointIndex: Integer): TFigureState; override;
  public
    function ShapeName: String; override;
    function ShapeType: TShapeType; override;
  end;

  TPolygonFigure = class(TAbstractPolyFigure)
  protected
    function FirstLineNumber: Integer; override;
    function MinCount: Integer; override;
    function UnfixStateByIndex(PointIndex: Integer): TFigureState; override;
    procedure CloseFigure; override;
  public
    function ShapeName: String; override;
    function ShapeType: TShapeType; override;
  end;

  TRectFigureResizer = class (TAbstract2DResizer)
  protected
    FParentTopLeft, FParentBottomRight: TCanvasMapPair;
  public
    constructor Create(AParentTopLeft, AParentBottomRight: TCanvasMapPair);
    procedure Resize(const X, Y: Integer); override;
  end;

  TAbstractRectFigure = class(TAbstract2DFigure)
  protected
    FTopLeft, FBottomRight: TCanvasMapPair;

    procedure ReadShapeData; override;

    function CanvasTopRight: TfrxPoint;
    function CanvasBottomLeft: TfrxPoint;
    function CalcFocusRect: TRect; override;
    function CalcFocusDoubleRect: TDoubleRect; override;
    procedure CanvasShift(dX, dY: Extended); override;
  public
    constructor Create(FCR: TFigureCreateRecord);
    destructor Destroy; override;
    procedure RecalcCanvas; override;

    function GetShapeData(Strings: TStrings): TShapeData; override;
  end;

  TRectFigure = class(TAbstractRectFigure)
  public
    procedure Draw; override;

    function ShapeName: String; override;
    function ShapeType: TShapeType; override;
  end;

  TDiamondFigure = class(TAbstractRectFigure)
  public
    procedure Draw; override;

    function ShapeName: String; override;
    function ShapeType: TShapeType; override;
  end;

  TEllipseFigure = class (TAbstractRectFigure)
  public
    procedure Draw; override;

    function ShapeName: String; override;
    function ShapeType: TShapeType; override;
  end;

  TPictureFigure = class (TAbstractRectFigure)
  private
    FPicture: TPicture;
    FIntermediateBitmap: TBitmap;
    FConstrainProportions: Boolean;
  protected
    procedure ReadShapeData; override;
    procedure OpenPicture(NewlyCreated: Boolean = False);
    procedure CreatePicture;
    procedure MakeDefaultPicture;
    procedure DrawOnIntermediateBitmap;
  public
    constructor Create(FCR: TFigureCreateRecord; AConstrainProportions: Boolean);
    destructor Destroy; override;
    procedure Draw; override;
    procedure SetConstrainProportions(AConstrainProportions: Boolean); override;

    function ShapeName: String; override;
    function ShapeType: TShapeType; override;
    function GetShapeData(Strings: TStrings): TShapeData; override;
  end;

  TLegendFigure = class (TAbstractRectFigure)
  private
    FSecondFont: TFont; // Pointer to Form.LabelFontLabel.Font
    FSecondLines: TStrings; // Pointer to Form.FPreviousLines
  protected
  public
    procedure Draw; override;

    function ShapeName: String; override;
    function ShapeType: TShapeType; override;
    function IsCanSave: boolean; override;
    function IsCanVK_DELETE: boolean; override; // False
    function GetShapeData(Strings: TStrings): TShapeData; override;
  end;

{ TfrxMapILEditorForm }

procedure TfrxMapILEditorForm.CancelEditing;
begin
  FreeAndNil(FFigure);
  Layer.CancelEditedShape;
  Change;
end;

procedure TfrxMapILEditorForm.CancelShapeButtonClick(Sender: TObject);
begin
  CancelEditing;
  UpdateControls;
end;

procedure TfrxMapILEditorForm.Change;
begin
  MapPaintBox.Refresh;
end;

procedure TfrxMapILEditorForm.DeletePointButtonClick(Sender: TObject);
begin
  FFigure.DeletePoint;
  UpdateControls;
end;

procedure TfrxMapILEditorForm.EditPictureButtonClick(Sender: TObject);
begin
  (FFigure as TPictureFigure).OpenPicture;
  UpdateControls;
  Change;
end;

procedure TfrxMapILEditorForm.FigureCreate(const X, Y: Integer);
var
  NextShapeType: TShapeType;
  FCR: TFigureCreateRecord;
  IsEditing: Boolean;
  TemplateName: String;
begin
  IsEditing := Layer.IsEditing;
  if IsEditing then TagsMemo.Lines.Assign(Layer.EditedShape.ShapeTags)
  else              TagsMemo.Lines.Clear;
  if IsEditing then NextShapeType := Layer.EditedShape.ShapeType
  else              NextShapeType := NextFigureShapeType;
  FPreviousLines.Assign(TagsMemo.Lines);

  FCR := FigureCreateRecord(FMap.Converter, MapPaintBox.Canvas, X, Y, Layer.EditedShape);
  case NextShapeType of
    stPoint:    FFigure := TPointFigure.Create(FCR);
    stPolyLine: FFigure := TPolylineFigure.Create(FCR);
    stPolygon:  FFigure := TPolygonFigure.Create(FCR);
    stRect:     FFigure := TRectFigure.Create(FCR);
    stDiamond:  FFigure := TDiamondFigure.Create(FCR);
    stEllipse:  FFigure := TEllipseFigure.Create(FCR);
    stPicture:  FFigure := TPictureFigure.Create(FCR, ConstrainProportionsCheckBox.Checked);
    stLegend:   FFigure := TLegendFigure.Create(FCR);
    stTemplate:
      begin
        if IsEditing then TemplateName := Layer.EditedShape.ShapeData.TemplateName
        else              TemplateName := NextTemplateName;
        FFigure := TTemplateFigure.Create(FCR, PolygonTemplateList.ItemsByName[TemplateName]);
      end;
  else
    raise Exception.Create('Unknown Figure');
  end;

 // Setup Form Controls and FFigure
  case FFigure.ShapeType of
    stPicture:
      if IsEditing then
        ConstrainProportionsCheckBox.Checked := Layer.EditedShape.ShapeData.ConstrainProportions
      else
        TPictureFigure(FFigure).CreatePicture;
    stLegend:
      begin
        if IsEditing then
          LabelFontLabel.Font.Assign(Layer.EditedShape.ShapeData.Font);
        TLegendFigure(FFigure).FSecondFont := LabelFontLabel.Font;
        LabelFontLabel.Caption := LabelFontLabel.Font.Name + ', ' + IntToStr(LabelFontLabel.Font.Size);

        TextMemo.OnChange := nil;
        if IsEditing then TextMemo.Lines.Assign(Layer.EditedShape.ShapeData.LegendText)
        else              TextMemo.Lines.Clear;
        FPreviousLines.Assign(TextMemo.Lines);
        TLegendFigure(FFigure).FSecondLines := FPreviousLines;
        TextMemo.OnChange := TextMemoChange;
      end;
  end;

  if FFigure.FShape <> nil then
    FFigure.ReadShapeData;

  FFigure.Draw;

  if (FFigure.ShapeType = stTemplate) and (FFigure.FShape = nil) then
    TTemplateFigure(FFigure).AddPoint(X, Y);
end;

procedure TfrxMapILEditorForm.FontDialogToLabel(Lbl: TLabel);
begin
  FontDialog.Font.Assign(Lbl.Font);
  if FontDialog.Execute then
  begin
    if FFigure <> nil then FFigure.Draw; // Hide
    Lbl.Font.Assign(FontDialog.Font);
    Lbl.Caption := Lbl.Font.Name + ', ' + IntToStr(Lbl.Font.Size);
    if FFigure <> nil then FFigure.Draw; // Show
  end;
end;

procedure TfrxMapILEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  c: TfrxComponent;
begin
  if ModalResult = mrOk then
  begin
    FMap.GeometryRestore;
    ReportDesigner.SelectedObjects.Clear;
    FOriginalMap.AssignAll(FMap);
    c := FOriginalMap.FindObject(FLayer.Name);
    if Assigned(c) then
      ReportDesigner.SelectedObjects.Add(c);
    ReportDesigner.ReloadObjects(False);
  end;
  FMap.Free;
  FFigure.Free;
  FPreviousLines.Free;
end;

procedure TfrxMapILEditorForm.FormCreate(Sender: TObject);
begin
  Translate(Self);
  DoubleBuffered := True;
  ConstrainProportionsCheckBox.Checked := False;
  PolyGroupBox.Caption := '';
  PictureGroupBox.Caption := '';
  PictureGroupBox.Left := PolyGroupBox.Left;
  PictureGroupBox.Top := PolyGroupBox.Top;
  LegendGroupBox.Caption := '';
  LegendGroupBox.Left := PolyGroupBox.Left;
  LegendGroupBox.Top := PolyGroupBox.Top;

  FPreviousLines := TStringList.Create;

  FFigure := nil;
  FCurentCursor := Cursor;

  FPointNextFigure := stPoint;
  frxResources.MainButtonImages.GetBitmap(101, PointMenuSpeedButton.Glyph);
  FRectNextFigure := stRect;
  frxResources.MainButtonImages.GetBitmap(101, RectMenuSpeedButton.Glyph);
  FPictureNextFigure := stPicture;
  frxResources.MainButtonImages.GetBitmap(101, PictureMenuSpeedButton.Glyph);

  LoadTemplates;
  SelectSpeedButton.Down := True;
  frxResources.MainButtonImages.GetBitmap(101, TemplateMenuSpeedButton.Glyph);

  MapPaintBox.OnMouseLeave := MapPaintBoxMouseLeave; // for Delphi 7

  UpdateControls;
end;

procedure TfrxMapILEditorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DELETE:
      if      RemoveShapeButton.Enabled and FFigure.IsCanVK_DELETE then
        RemoveShapeButton.Click
      else if DeletePointButton.Enabled then
        DeletePointButton.Click;
  end;
end;

procedure TfrxMapILEditorForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: boolean);
var
  EventParams: TfrxInteractiveEventsParams;
begin
  if IsInsidePaintBox(MousePos.X, MousePos.Y) then
  begin
    FMap.DoMouseWheel(Shift, WheelDelta, MousePos, EventParams);
    Change;
  end;
end;

procedure TfrxMapILEditorForm.FormResize(Sender: TObject);
begin
  if FMap <> nil then
    FMap.GeometryChange(0, 0, MapPaintBox.Width, MapPaintBox.Height);
end;

function TfrxMapILEditorForm.IsInsidePaintBox(const X, Y: Integer): boolean;
var
  MPRect: TRect;
begin
  with MapPanel do
    MPRect := Bounds(Left + Self.Left, Top + Self.Top, Width, Height);
  Result := PtInRect(MPRect, Point(X, Y));
end;

procedure TfrxMapILEditorForm.LabelFontButtonClick(Sender: TObject);
begin
  FontDialogToLabel(LabelFontLabel)
end;

procedure TfrxMapILEditorForm.LoadTemplates;
var
  i: Integer;
  Item: TMenuItem;
begin
  if (PolygonTemplateList <> nil) and (PolygonTemplateList.Count > 0) then
  begin
    TemplatePopupMenu.Items.Clear;
    for i := 0 to PolygonTemplateList.Count - 1 do
    begin
      Item := TMenuItem.Create(TemplatePopupMenu);
      Item.Caption := PolygonTemplateList[i].Name;
      Item.OnClick := TemplateClick;
      TemplatePopupMenu.Items.Add(Item);
    end;
    TemplatePopupMenu.Items[0].Click;
    TemplateSpeedButton.Visible := True;
    TemplateMenuSpeedButton.Visible := True;
  end;
end;

procedure TfrxMapILEditorForm.MapPaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  EventParams: TfrxInteractiveEventsParams;
begin
  if Button <> mbLeft then
    Exit;

  if (FFigure = nil) and (NextFigureShapeType <> stNone) then
    FigureCreate(X, Y)
  else if (FFigure = nil) and Layer.IsSelectEditedShape(OffsetPoint(X, Y), MinSelectDistance) then
  begin
    Change;
    FigureCreate(X, Y);
  end
  else if (FFigure = nil) or not FFigure.MouseDown(X, Y) then // Move Map
  begin
    EventParams.EventSender := esPreview;
    FMap.DoMouseDown(X, Y, Button, Shift, EventParams);
  end;
  UpdateControls;
end;

procedure TfrxMapILEditorForm.MapPaintBoxMouseLeave(Sender: TObject);
begin
  RefreshCursor(vcDefault);
end;

procedure TfrxMapILEditorForm.MapPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  EventParams: TfrxInteractiveEventsParams;
begin
  if [ssLeft, ssRight, ssMiddle] * Shift = [] then // No mouse buttons pressed
  begin
    if (FFigure <> nil) then
      RefreshCursor(FFigure.GetCursor(X, Y))
    else if Layer.IsSelectEditedShape(OffsetPoint(X, Y), MinSelectDistance) then
    begin
      Layer.CancelEditedShape(False);
      RefreshCursor(vcCanSelect);
    end
    else
      RefreshCursor(vcDefault);
  end
  else if ssLeft in Shift then // Left pressed
  begin
    if (FFigure = nil) or not FFigure.MouseMove(X, Y) then // Move Map
    begin
      EventParams.Refresh := False;
      EventParams.EventSender := esPreview;
      FMap.DoMouseMove(X, Y, Shift, EventParams);
      if EventParams.Refresh then
      begin
        if FFigure <> nil then
          FFigure.RecalcCanvas;
        Invalidate;
      end;
    end;
  end;
end;

procedure TfrxMapILEditorForm.MapPaintBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  EventParams: TfrxInteractiveEventsParams;
begin
  if Button <> mbLeft then
    Exit;

  if FFigure = nil then
    FMap.DoMouseUp(X, Y, Button, Shift, EventParams)
  else
    FFigure.MouseUp(X, Y);
  UpdateControls;
end;

procedure TfrxMapILEditorForm.MapPaintBoxPaint(Sender: TObject);
begin
  MapPaintBox.Canvas.Lock;
  try
    FMap.Draw(MapPaintBox.Canvas, 1, 1, 0, 0);
    if FFigure <> nil then
    begin
      FFigure.RecalcCanvas;
      FFigure.Draw;
    end;
  finally
    MapPaintBox.Canvas.Unlock;
  end;
end;

function TfrxMapILEditorForm.NextFigureShapeType: TShapeType;
begin
  if      PointSpeedButton.Down then
    Result := FPointNextFigure
  else if RectSpeedButton.Down then
    Result := FRectNextFigure
  else if PictureSpeedButton.Down then
    Result := FPictureNextFigure
  else if TemplateSpeedButton.Down then
    Result := stTemplate
  else if SelectSpeedButton.Down then
    Result := stNone
  else
    raise Exception.Create('Unknown NextFigure');
end;

function TfrxMapILEditorForm.NextTemplateName: String;
begin
  Result := TemplateSpeedButton.Caption;
end;

function TfrxMapILEditorForm.OffsetPoint(P: TfrxPoint): TfrxPoint;
begin
  Result := OffsetPoint(P.X, P.Y);
end;

function TfrxMapILEditorForm.OffsetPoint(X, Y: Extended): TfrxPoint;
begin
  Result := frxPoint(X - FMap.OffsetX, Y - FMap.OffsetY);
end;

procedure TfrxMapILEditorForm.Picture1Click(Sender: TObject);
  procedure SetNext(ShapeType: TShapeType; Name: String);
  begin
    FPictureNextFigure := ShapeType;
    PictureSpeedButton.Caption := GetStr(Name);
  end;
begin
  if      Sender = Picture1 then SetNext(stPicture, 'stPicture')
  else if Sender = Legend1 then  SetNext(stLegend, 'stLegend')
  else
    raise Exception.Create('Unknown Shape Type');

  PictureSpeedButton.Down := True;
end;

procedure TfrxMapILEditorForm.PictureMenuSpeedButtonClick(Sender: TObject);
begin
  with PictureSpeedButton, ClientToScreen(Point(0, Height)) do
    PicturePopupMenu.Popup(X, Y);
end;

procedure TfrxMapILEditorForm.Point1Click(Sender: TObject);
  procedure SetNext(ShapeType: TShapeType; Name: String);
  begin
    FPointNextFigure := ShapeType;
    PointSpeedButton.Caption := GetStr(Name);
  end;
begin
  if      Sender = Point1 then    SetNext(stPoint, 'stPoint')
  else if Sender = Polyline1 then SetNext(stPolyline, 'stPolyline')
  else if Sender = Polygon1 then  SetNext(stPolygon, 'stPolygon')
  else
    raise Exception.Create('Unknown Shape Type');

  PointSpeedButton.Down := True;
end;

procedure TfrxMapILEditorForm.PointMenuSpeedButtonClick(Sender: TObject);
begin
  with PointSpeedButton, ClientToScreen(Point(0, Height)) do
    PointPopupMenu.Popup(X, Y);
end;

procedure TfrxMapILEditorForm.Rectangle1Click(Sender: TObject);
  procedure SetNext(ShapeType: TShapeType; Name: String);
  begin
    FRectNextFigure := ShapeType;
    RectSpeedButton.Caption := GetStr(Name);
  end;
begin
  if      Sender = Rectangle1 then SetNext(stRect, 'stRect')
  else if Sender = Ellipse1 then SetNext(stEllipse, 'stEllipse')
  else if Sender = Diamond1 then  SetNext(stDiamond, 'stDiamond')
  else
    raise Exception.Create('Unknown Shape Type');

  RectSpeedButton.Down := True;
end;

procedure TfrxMapILEditorForm.RectMenuSpeedButtonClick(Sender: TObject);
begin
  with RectSpeedButton, ClientToScreen(Point(0, Height)) do
    RectPopupMenu.Popup(X, Y);
end;

procedure TfrxMapILEditorForm.RefreshCursor(VirtualCursor: TVirtualCursor);
var
  NewCursor: TCursor;
  P: TPoint;
begin
  case VirtualCursor of
    vcDefault:
      NewCursor := Cursor;
    vcMoveMobile:
      NewCursor := crUpArrow;
    vcFixAndAdd, vcUnfixSegment:
      NewCursor := crCross;
    vcFix, vcUnfix, vcCanSelect:
      NewCursor := crHandPoint;
    vcSize:
      NewCursor := crSize;
    vcSizeNESW:
      NewCursor := crSizeNESW;
    vcSizeNS:
      NewCursor := crSizeNS;
    vcSizeNWSE:
      NewCursor := crSizeNWSE;
    vcSizeWE:
      NewCursor := crSizeWE;
  else
    raise Exception.Create('Unknown Virtual Cursor');
  end;

  if FCurentCursor <> NewCursor then
  begin
    FCurentCursor := NewCursor;
    Screen.Cursor := FCurentCursor;
    GetCursorPos(P);
    SetCursorPos(P.X + 1, P.Y + 1);
    SetCursorPos(P.X, P.Y);
  end;
end;

procedure TfrxMapILEditorForm.RemoveShapeButtonClick(Sender: TObject);
begin
  Layer.RemoveEditedShape;
  CancelEditing;
  UpdateControls;
end;

procedure TfrxMapILEditorForm.SaveShapeButtonClick(Sender: TObject);
var
  ShapeData: TShapeData;
begin
  ShapeData := FFigure.GetShapeData(TagsMemo.Lines);

  if Layer.IsEditing then Layer.ReplaceShape(ShapeData)
  else                    Layer.AddShape(ShapeData);

  CancelEditing;
  UpdateControls;
end;

procedure TfrxMapILEditorForm.SetLayer(const Value: TfrxMapInteractiveLayer);
var
  LayerIndex: Integer;
begin
  FOriginalMap := TfrxMapView(Value.MapView);
  LayerIndex := FOriginalMap.Layers.IndexOf(Value);
  FMap := TfrxMapView.Create(nil);
  FMap.AssignAll(FOriginalMap);
  FLayer := TfrxMapInteractiveLayer(FMap.Layers[LayerIndex]);
  FMap.GeometrySave;
  FMap.GeometryChange(0, 0, MapPaintBox.Width, MapPaintBox.Height);
end;

procedure TfrxMapILEditorForm.TemplateClick(Sender: TObject);
begin
  TemplateSpeedButton.Caption := (Sender as TMenuItem).Caption;

  TemplateSpeedButton.Down := True;
end;

procedure TfrxMapILEditorForm.TemplateMenuSpeedButtonClick(Sender: TObject);
begin
  with TemplateSpeedButton, ClientToScreen(Point(0, Height)) do
    TemplatePopupMenu.Popup(X, Y);
end;

procedure TfrxMapILEditorForm.TextMemoChange(Sender: TObject);
begin
  if (FFigure <> nil) and (FFigure.ShapeType = stLegend) then FFigure.Draw; // Hide
  FPreviousLines.Assign(TextMemo.Lines);
  if (FFigure <> nil) and (FFigure.ShapeType = stLegend) then FFigure.Draw; // Show
  UpdateControls;
end;

procedure TfrxMapILEditorForm.UpdateControls;
begin
  SelectSpeedButton.Enabled := FFigure = nil;
  PointSpeedButton.Enabled := FFigure = nil;
  PointMenuSpeedButton.Enabled := FFigure = nil;
  RectSpeedButton.Enabled := FFigure = nil;
  RectMenuSpeedButton.Enabled := FFigure = nil;
  PictureSpeedButton.Enabled := FFigure = nil;
  PictureMenuSpeedButton.Enabled := FFigure = nil;
  TemplateSpeedButton.Enabled := FFigure = nil;
  TemplateMenuSpeedButton.Enabled := FFigure = nil;
  if FFigure <> nil then
    SelectSpeedButton.Down := True;

  ShapeGroupBox.Visible := FFigure <> nil;
  if ShapeGroupBox.Visible then
    ShapeGroupBox.Caption := FFigure.ShapeName;
  PolyGroupBox.Visible := (FFigure <> nil) and (FFigure.ShapeType in [stPolyLine, stPolygon]);
  PictureGroupBox.Visible := (FFigure <> nil) and (FFigure.ShapeType = stPicture);
  LegendGroupBox.Visible := (FFigure <> nil) and (FFigure.ShapeType = stLegend);


  SaveShapeButton.Enabled := (FFigure <> nil) and FFigure.IsCanSave;
  CancelShapeButton.Enabled := True;

  btnOk.Enabled := FFigure = nil;

  RemoveShapeButton.Enabled := (FFigure <> nil) and FFigure.IsCanDeleteShape;
  DeletePointButton.Enabled := (FFigure <> nil) and FFigure.IsCanDeletePoint;
end;

procedure TfrxMapILEditorForm.ConstrainProportionsCheckBoxClick(Sender: TObject);
begin
  if FFigure <> nil then
  begin
    FFigure.SetConstrainProportions(ConstrainProportionsCheckBox.Checked);
    Change;
  end;
end;

{ TCanvasMapPair }

procedure TCanvasMapPair.CalcCanvas;
begin
  FConverter.IgnoreShape;
  FCanvasPoint := FConverter.TransformOffset(FMapPoint);
end;

procedure TCanvasMapPair.CalcMap;
begin
  FMapPoint := FConverter.CanvasToMap(FCanvasPoint);
end;

procedure TCanvasMapPair.CanvasShift(dX, dY: Extended);
begin
  CanvasPoint := frxPoint(CanvasPoint.X + dX, CanvasPoint.Y + dY);
end;

constructor TCanvasMapPair.Create(Converter: TMapToCanvasCoordinateConverter);
begin
  FConverter := Converter;
end;

constructor TCanvasMapPair.CreateClone(CanvasMapPair: TCanvasMapPair);
begin
  Create(CanvasMapPair.FConverter);
  FCanvasPoint := CanvasMapPair.CanvasPoint;
  FMapPoint := CanvasMapPair.MapPoint;
end;

procedure TCanvasMapPair.SetCanvasPoint(const Value: TfrxPoint);
begin
  FCanvasPoint := Value;
  CalcMap;
end;

procedure TCanvasMapPair.SetMapPoint(const Value: TfrxPoint);
begin
  FMapPoint := Value;
  CalcCanvas;
end;

{ TAbstractFigure }

constructor TAbstractFigure.Create(FCR: TFigureCreateRecord);
begin
  FConverter := FCR.Converter;
  FCanvas := FCR.Canvas;
  FLastPoint := TCanvasMapPair.Create(FConverter);
  FLastPoint.CanvasPoint := frxPoint(FCR.X, FCR.Y);
  FShape := FCR.Shape;
end;

procedure TAbstractFigure.DeletePoint;
begin
  // Empty
end;

destructor TAbstractFigure.Destroy;
begin
  FLastPoint.Free;
  inherited;
end;

procedure TAbstractFigure.DrawCircle(Center: TfrxPoint; GV: TGraphicView; Radius: Integer = Unknown);
begin
  if Radius = Unknown then
    Radius := MinSelectDistance;
  FCanvas.Lock;
  try
    SetupGraphics(GV);
    FCanvas.Ellipse(Round(Center.X - Radius), Round(Center.Y - Radius),
      Round(Center.X + Radius) + 1, Round(Center.Y + Radius) + 1);
  finally
    FCanvas.Unlock;
  end;
end;

procedure TAbstractFigure.DrawEllipse(TopLeft, BottomRight: TfrxPoint; GV: TGraphicView);
var
  TL, BR: TPoint;
begin
  TL := ToPoint(TopLeft);
  BR := ToPoint(BottomRight);

  FCanvas.Lock;
  try
    SetupGraphics(GV);
    FCanvas.Ellipse(TL.X, TL.Y, BR.X, BR.Y);
  finally
    FCanvas.Unlock;
  end;
end;

procedure TAbstractFigure.DrawLine(P1, P2: TfrxPoint; GV: TGraphicView);
begin
  FCanvas.Lock;
  try
    SetupGraphics(GV);
    FCanvas.MoveTo(Round(P1.X), Round(P1.Y));
    FCanvas.LineTo(Round(P2.X), Round(P2.Y));
  finally
    FCanvas.Unlock;
  end;
end;

procedure TAbstractFigure.DrawMobilePoint;
begin
  DrawCircle(FLastPoint.CanvasPoint, MobileView);
end;

procedure TAbstractFigure.DrawPolygon(Points: TPointArray; GV: TGraphicView);
begin
  FCanvas.Lock;
  try
    SetupGraphics(GV);
    FCanvas.Polygon(Points);
  finally
    FCanvas.Unlock;
  end;
end;

procedure TAbstractFigure.DrawRect(TopLeft, BottomRight: TfrxPoint; GV: TGraphicView);
var
  TL, BR: TPoint;
begin
  TL := ToPoint(TopLeft);
  BR := ToPoint(BottomRight);

  FCanvas.Lock;
  try
    SetupGraphics(GV);
    FCanvas.Rectangle(TL.X, TL.Y, BR.X, BR.Y);
  finally
    FCanvas.Unlock;
  end;
end;

function TAbstractFigure.IsCanDeletePoint: boolean;
begin
  Result := False;
end;

function TAbstractFigure.IsCanDeleteShape: boolean;
begin
  Result := FShape <> nil;
end;

function TAbstractFigure.IsCanSave: boolean;
begin
  Result := True;
end;

function TAbstractFigure.IsCanVK_DELETE: boolean;
begin
  Result := True;
end;

function TAbstractFigure.IsNearLastPoint(const X, Y: Integer): boolean;
begin
  Result := Distance(FLastPoint.CanvasPoint, X, Y) <= MinSelectDistance;
end;

procedure TAbstractFigure.MouseUp(const X, Y: Integer);
begin
  // Empty
end;

procedure TAbstractFigure.RecalcCanvas;
begin
  FLastPoint.CalcCanvas;
end;

procedure TAbstractFigure.SetConstrainProportions(AConstrainProportions: Boolean);
begin
  // Empty
end;

procedure TAbstractFigure.SetupGraphics(GV: TGraphicView);
begin
  FCanvas.Lock;
  try
    FCanvas.Pen.Mode := PenMode;
    FCanvas.Pen.Color := GV.PenColor;
    FCanvas.Pen.Width := GV.PenWidth;
    FCanvas.Pen.Style := GV.PenStyle;
    FCanvas.Brush.Style := GV.BrushStyle;
    FCanvas.Brush.Color := GV.BrushColor;
  finally
    FCanvas.Unlock;
  end;
end;

{ TPointFigure }

procedure TPointFigure.Draw;
begin
  DrawMobilePoint;
end;

function TPointFigure.GetCursor(const X, Y: Integer): TVirtualCursor;
begin
  Result := vcMoveMobile;
end;

function TPointFigure.GetShapeData(Strings: TStrings): TShapeData;
begin
  with FLastPoint.MapPoint do
    Result := TShapeData.CreatePoint(Strings, X, Y);
end;

function TPointFigure.MouseDown(const X, Y: Integer): boolean;
begin
  MouseMove(X, Y);
  Result := True;
end;

function TPointFigure.MouseMove(const X, Y: Integer): boolean;
begin
  Result := True;
  Draw; // Hide
  FLastPoint.CanvasPoint := frxPoint(X, Y);
  Draw; // Show
end;

procedure TPointFigure.ReadShapeData;
begin
  with FShape.ShapeData.Point do
    FLastPoint.CanvasPoint := frxPoint(X, Y);
end;

function TPointFigure.ShapeName: String;
begin
  Result := frxResources.Get('stPoint');
end;

function TPointFigure.ShapeType: TShapeType;
begin
  Result := stPoint;
end;

{ TAbstractPolyFigure }

procedure TAbstractPolyFigure.CloseFigure;
begin
  // Empty
end;

procedure TAbstractPolyFigure.DeletePoint;
begin
  DrawMobile; // Hide
  if FState = fsAddMiddle then
    DrawFixedLine(FMiddleRight); // Show
  if FPairList.Count = 1 then
  begin
    FLastPoint.CanvasPoint := FPairList[0].CanvasPoint;
    FPairList.Delete(0);
    FState := fsEmpty;
    DrawMobile; // Show
  end
  else
  begin
    FState := fsSelected;
    DrawFocusRectangle;
  end;
end;

procedure TAbstractPolyFigure.Draw;
var
  i: Integer;
begin
  for i := FirstLineNumber to FPairList.Count - 1 do
    if (FState <> fsAddMiddle) or (i <> FMiddleRight) then
      DrawFixedLine(i);
  case FState of
    fsEmpty:
      DrawMobilePoint;
    fsAddBegin:
      begin
        DrawMobileLine(0);
        DrawMobilePoint;
      end;
    fsAddEnd:
      begin
        DrawMobileLine(-1);
        DrawMobilePoint;
      end;
    fsAddMiddle:
      begin
        DrawMobileLine(FMiddleRight - 1);
        DrawMobileLine(FMiddleRight);
        DrawMobilePoint;
      end;
    fsSelected, fsSelectedMoveMap, fsSelectedMoveShape, fsSelectedResize:
      DrawFocusRectangle;
  end;
end;

procedure TAbstractPolyFigure.DrawFixed;
begin
  case FState of
    fsAddBegin:
      DrawFixedLine(1);
    fsAddEnd:
      DrawFixedLine(-1);
    fsAddMiddle:
      begin
        DrawFixedLine(FMiddleRight);
        DrawFixedLine(FMiddleRight + 1);
      end;
  end;
end;

procedure TAbstractPolyFigure.DrawFixedLine(Index: Integer); // Right Index
begin
  DrawLine(FPairList[Index - 1].CanvasPoint, FPairList[Index].CanvasPoint, FixedView);

  DrawCircle(FPairList[Index].CanvasPoint, FixedView);
  DrawCircle(FPairList[Index - 1].CanvasPoint, FixedView, MinSelectDistance - 1);
end;

procedure TAbstractPolyFigure.DrawMobile;
begin
  DrawMobilePoint;
  case FState of
    fsAddBegin:
      DrawMobileLine(0);
    fsAddEnd:
      DrawMobileLine(-1);
    fsAddMiddle:
      begin
        DrawMobileLine(FMiddleRight - 1);
        DrawMobileLine(FMiddleRight);
      end;
  end;
end;

procedure TAbstractPolyFigure.DrawMobileLine(Index: Integer);
begin
  DrawLine(FLastPoint.CanvasPoint, FPairList[Index].CanvasPoint, MobileView);
end;

function TAbstractPolyFigure.GetCursor(const X, Y: Integer): TVirtualCursor;
var
  PointIndex: Integer;
begin
  Result := vcDefault;
  case FState of
    fsEmpty:
      if IsNearLastPoint(X, Y) then Result := vcMoveMobile
      else                          Result := vcFixAndAdd;
    fsAddBegin, fsAddEnd:
      if      IsNearLastPoint(X, Y) and IsCanFix then Result := vcFix
      else if IsNearLastPoint(X, Y)              then Result := vcMoveMobile
      else                                            Result := vcFixAndAdd;
    fsAddMiddle:
      if IsNearLastPoint(X, Y) then Result := vcFix
      else                          Result := vcMoveMobile;
    fsSelected:
      if      IsNearPoint(X, Y, PointIndex)   then Result := vcUnFix
      else if IsNearSegment(X, Y, PointIndex) then Result := vcUnfixSegment
      else                                         Result := inherited GetCursor(X, Y);
  end;
end;

function TAbstractPolyFigure.IsCanDeletePoint: boolean;
begin
  Result := (FPairList.Count >= MinCount) and
    (FState in [fsAddBegin, fsAddEnd, fsAddMiddle]);
end;

function TAbstractPolyFigure.IsCanDeleteShape: boolean;
begin
  Result := inherited IsCanDeleteShape and (FState = fsSelected);
end;

function TAbstractPolyFigure.IsCanFix: boolean;
begin
  Result := FPairList.Count + 1 >= MinCount;
end;

function TAbstractPolyFigure.IsNearSegment(const X, Y: Integer; out PointIndex: Integer): boolean;
var
  i: Integer;
begin
  FMD.Init(MinSelectDistance);
  for i := FirstLineNumber to FPairList.Count - 1 do
    FMD.Add(DistanceSegment(FPairList.GetSegment(i), frxPoint(X, Y)), i);
  Result := FMD.IsNear;
  if Result then
    PointIndex := FMD.Index;
end;

procedure TAbstractPolyFigure.LPAddToFigure;
var
  CanvasMapPair: TCanvasMapPair;
begin
  DrawMobile; // Hide
  CanvasMapPair := TCanvasMapPair.CreateClone(FLastPoint);
  case FState of
    fsEmpty:
      FPairList.Add(CanvasMapPair);
    fsAddBegin:
      FPairList.Insert(0, CanvasMapPair);
    fsAddEnd:
      FPairList.Add(CanvasMapPair);
    fsAddMiddle:
      FPairList.Insert(FMiddleRight, CanvasMapPair);
  end;
  DrawFixed; // Show
end;

procedure TAbstractPolyFigure.LPFix(const X, Y: Integer);
begin
  LPAddToFigure;
  DrawFocusRectangle;
  CloseFigure;
  FState := fsSelected;
  FLastPoint.CanvasPoint := frxPoint(X, Y);
end;

procedure TAbstractPolyFigure.LPFixAndAdd(const X, Y: Integer);
begin
  LPAddToFigure;
  FLastPoint.CanvasPoint := frxPoint(X, Y);
  if FState = fsEmpty then
    FState := fsAddEnd;
  DrawMobile; // Show
end;

procedure TAbstractPolyFigure.LPMoveMobile(const X, Y: Integer);
begin
  DrawMobile; // Hide
  FLastPoint.CanvasPoint := frxPoint(X, Y);
  DrawMobile; // Show
end;

procedure TAbstractPolyFigure.LPUnfixPoint(const X, Y, PointIndex: Integer);
begin
  FMiddleRight := PointIndex;

  FState :=  UnfixStateByIndex(PointIndex);

  DrawFixed; // Hide
  DrawFocusRectangle;
  FPairList.Delete(PointIndex);
  FLastPoint.CanvasPoint := frxPoint(X, Y);
  DrawMobile; // Show
end;

procedure TAbstractPolyFigure.LPUnfixSegment(const X, Y, PointIndex: Integer);
begin
  FMiddleRight := PointIndex;

  FState := fsAddMiddle;

  DrawFixedLine(FMiddleRight); // Hide
  DrawFocusRectangle;

  FLastPoint.CanvasPoint := frxPoint(X, Y);
  DrawMobile; // Show
end;

function TAbstractPolyFigure.MouseDown(const X, Y: Integer): boolean;
var
  PointIndex: Integer;
begin
  case FState of
    fsEmpty:
      if IsNearLastPoint(X, Y) then LPMoveMobile(X, Y)
      else                          LPFixAndAdd(X, Y);
    fsAddBegin, fsAddEnd:
      if      IsNearLastPoint(X, Y) and IsCanFix then LPFix(X, Y)
      else if IsNearLastPoint(X, Y)              then LPMoveMobile(X, Y)
      else                                            LPFixAndAdd(X, Y);
    fsAddMiddle:
      if IsNearLastPoint(X, Y) then LPFix(X, Y)
      else                          LPMoveMobile(X, Y);
    fsSelected:
      if IsNearPoint(X, Y, PointIndex) then
        LPUnfixPoint(X, Y, PointIndex)
      else if IsNearSegment(X, Y, PointIndex) then
        LPUnfixSegment(X, Y, PointIndex)
      else
        inherited MouseDown(X, Y);
  end;
  Result := FState <> fsSelectedMoveMap; // not Result => Move Map
end;

function TAbstractPolyFigure.MouseMove(const X, Y: Integer): boolean;
begin
  case FState of
    fsEmpty, fsAddBegin, fsAddEnd, fsAddMiddle:
      LPMoveMobile(X, Y);
  else
    inherited MouseMove(X, Y);
  end;
  Result := FState <> fsSelectedMoveMap; // not Result => Move Map
end;

{ TPairList }

function TPairList.CalcFocusDoubleRect: TDoubleRect;
var
  i: Integer;
begin
  if Count = 0 then
    raise Exception.Create('Empty PairList')
  else
  begin
    with Items[0].CanvasPoint do
      Result := DoubleRect(X, Y, X, Y);
    for i := 1 to Count - 1 do
      with Items[i].CanvasPoint do
      begin
        if      Result.Left > X then  Result.Left := X
        else if Result.Right < X then Result.Right := X;
        if      Result.Top > Y then    Result.Top := Y
        else if Result.Bottom < Y then Result.Bottom := Y
      end;
  end;
end;

function TPairList.CanvasPoints: TPointArray;
var
  i: Integer;
begin
  SetLength(Result, Count);
  for i := 0 to Count - 1 do
    Result[i] := ToPoint(Items[i].CanvasPoint);
end;

procedure TPairList.CanvasShift(dX, dY: Extended);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].CanvasShift(dX, dY);
end;

function TPairList.GetPair(Index: Integer): TCanvasMapPair;
begin
  if      Index < 0 then
    Index := Index + Count
  else if Index >= Count then
    Index := Index - Count;
  Result := (inherited Items[Index]) as TCanvasMapPair;
end;

function TPairList.GetSegment(Index: Integer): TSegment;
begin
  Result := Segment(Items[Index - 1].CanvasPoint, Items[Index].CanvasPoint);
end;

procedure TPairList.RecalcCanvas;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].CalcCanvas;
end;

procedure TPairList.SetPair(Index: Integer; const Value: TCanvasMapPair);
begin
  if Index < 0 then
    Index := Index + Count;
  inherited Items[Index] := Value;
end;

{ TPolylineFigure }

function TPolylineFigure.FirstLineNumber: Integer;
begin
  Result := 1;
end;

function TPolylineFigure.MinCount: Integer;
begin
  Result := 2;
end;

function TPolylineFigure.ShapeName: String;
begin
  Result := frxResources.Get('stPolyline');
end;

function TPolylineFigure.ShapeType: TShapeType;
begin
  Result := stPolyLine;
end;

function TPolylineFigure.UnfixStateByIndex(PointIndex: Integer): TFigureState;
begin
  if      PointIndex = 0 then                   Result := fsAddBegin
  else if PointIndex = FPairList.Count - 1 then Result := fsAddEnd
  else                                          Result := fsAddMiddle;
end;

{ TMultyPointResizer }

constructor TMultyPointResizer.Create(AParentPairList: TPairList);
begin
  FInitialPairList := TPairList.Create;
  FParentPairList := AParentPairList;
end;

destructor TMultyPointResizer.Destroy;
begin
  FInitialPairList.Free;
  inherited;
end;

procedure TMultyPointResizer.Factors(const X, Y: Integer; out FX, FY: Extended);
var
  Mi, Ma: Extended;
begin
  Mi := FInitialRect.Left;
  Ma := FInitialRect.Right;
  if FMarker in LeftSide then
    Mi := Min(X, FInitialRect.Right - 2 * FocusRectIndent)
  else if FMarker in RightSide then
    Ma := Max(X, FInitialRect.Left + 2 * FocusRectIndent + 1);
  FX := (Ma - Mi - 2 * FocusRectIndent) / FInnerWidth;

  Mi := FInitialRect.Top;
  Ma := FInitialRect.Bottom;
  if FMarker in TopSide then
    Mi := Min(Y, FInitialRect.Bottom - 2 * FocusRectIndent)
  else if FMarker in BottomSide then
    Ma := Max(Y, FInitialRect.Top + 2 * FocusRectIndent);
  FY := (Ma - Mi - 2 * FocusRectIndent) / FInnerHeight;
end;

procedure TMultyPointResizer.Init(AMarker: TFocusMarker);
var
  i: Integer;
begin
  inherited Init(AMarker);

  FInnerRect := FParentPairList.CalcFocusDoubleRect;
  FInitialRect := DoubleRectExpand(FInnerRect, FocusRectIndent);

  FInnerWidth := FInnerRect.Right - FInnerRect.Left;
  FInnerHeight := FInnerRect.Bottom - FInnerRect.Top;
  FInitialPairList.Clear;
  for i := 0 to FParentPairList.Count - 1 do
    FInitialPairList.Add(TCanvasMapPair.CreateClone(FParentPairList[i]));
end;

procedure TMultyPointResizer.Resize(const X, Y: Integer);
var
  i: Integer;
  FX, FY: Extended;
  CP, ICP: TfrxPoint;
begin
  Factors(X, Y, FX, FY);
  for i := 0 to FParentPairList.Count - 1 do
  begin
    CP := FParentPairList[i].CanvasPoint;
    ICP := FInitialPairList[i].CanvasPoint;

    if FMarker in LeftSide then
      CP.X := FInnerRect.Right + (ICP.X - FInnerRect.Right) * FX
    else if FMarker in RightSide then
      CP.X := FInnerRect.Left + (ICP.X - FInnerRect.Left) * FX;

    if FMarker in TopSide then
      CP.Y := FInnerRect.Bottom + (ICP.Y - FInnerRect.Bottom) * FY
    else if FMarker in BottomSide then
      CP.Y := FInnerRect.Top + (ICP.Y - FInnerRect.Top) * FY;

    FParentPairList[i].CanvasPoint := CP;
  end;
end;

{ TPolygonFigure }

procedure TPolygonFigure.CloseFigure;
begin
  if FState = fsAddEnd then
    DrawFixedLine(0);
end;

function TPolygonFigure.FirstLineNumber: Integer;
begin
  Result := 0;
  if FPairList.Count = 2 then // Line only one. Do not use it twice.
    Result := 1;
end;

function TPolygonFigure.MinCount: Integer;
begin
  Result := 3;
end;

function TPolygonFigure.ShapeName: String;
begin
  Result := frxResources.Get('stPolygon');
end;

function TPolygonFigure.ShapeType: TShapeType;
begin
  Result := stPolygon;
end;

function TPolygonFigure.UnfixStateByIndex(PointIndex: Integer): TFigureState;
begin
  Result := fsAddMiddle;
end;

{ TRectFigure }

procedure TRectFigure.Draw;
begin
  DrawRect(FTopLeft.CanvasPoint, FBottomRight.CanvasPoint, RectView);
  DrawFocusRectangle;
end;

function TRectFigure.ShapeName: String;
begin
  Result := frxResources.Get('stRect');
end;

function TRectFigure.ShapeType: TShapeType;
begin
  Result := stRect;
end;

{ TAbstract2DFigure }

constructor TAbstract2DFigure.Create(FCR: TFigureCreateRecord);
begin
  inherited;

  FMD := TMinDistance.Create;
end;

destructor TAbstract2DFigure.Destroy;
begin
  FMD.Free;

  inherited;
end;

procedure TAbstract2DFigure.DrawFocusRectangle;
var
  fm: TFocusMarker;

  function SquareByCenter(Center: TPoint; SquareSide: Integer): TRect;
  begin
    with Result do
    begin
      Left := Center.X - SquareSide div 2;
      Top := Center.Y - SquareSide div 2;
      Right := Left + SquareSide;
      Bottom := Top + SquareSide;
    end;
  end;

  procedure DrawFocusMarker(Center: TPoint);
  begin
{$IFNDEF FPC}
    InvertRect(FCanvas.Handle, SquareByCenter(Center, MinSelectDistance + 2));
    InvertRect(FCanvas.Handle, SquareByCenter(Center, MinSelectDistance));
{$ELSE}
//TODO
{$ENDIF}
  end;

begin
  FCanvas.Lock;
  try
    SetupGraphics(FocusRectView);
    with CalcFocusRect do
      FCanvas.Rectangle(Left, Top, Right, Bottom);
    for fm := Low(TFocusMarker) to High(TFocusMarker) do
      DrawFocusMarker(FocusMarkerCenter(fm));
  finally
    FCanvas.Unlock;
  end;
end;

function TAbstract2DFigure.FocusMarkerCenter(fm: TFocusMarker): TPoint;
var
  W2, H2: Integer;
begin
  with CalcFocusRect do
  begin
    W2 := (Left + Right) div 2;
    H2 := (Top + Bottom) div 2;
    case fm of
      fmLeftTop:     Result := Point(Left, Top);
      fmRightTop:    Result := Point(Right - 1, Top);
      fmRightBottom: Result := Point(Right - 1, Bottom - 1);
      fmLeftBottom:  Result := Point(Left, Bottom - 1);
      fmLeft:        Result := Point(Left, H2);
      fmTop:         Result := Point(W2, Top);
      fmRight:       Result := Point(Right - 1, H2);
      fmBottom:      Result := Point(W2, Bottom - 1);
    end;
  end;
end;

function TAbstract2DFigure.GetCursor(const X, Y: Integer): TVirtualCursor;
var
  FocusMarker: TFocusMarker;
begin
  Result := vcDefault;
  if IsSelected then
    if IsNearFocusMarker(X, Y, FocusMarker) then
      case FocusMarker of
        fmLeftTop, fmRightBottom:
          Result := vcSizeNWSE;
        fmRightTop, fmLeftBottom:
          Result := vcSizeNESW;
        fmLeft, fmRight:
          Result := vcSizeWE;
        fmTop, fmBottom:
          Result := vcSizeNS;
      end
    else if IsInsideFocusRect(X, Y) then
      Result := vcSize;
end;

function TAbstract2DFigure.IsInsideFocusRect(const X, Y: Integer): boolean;
begin
  Result := PtInRect(CalcFocusRect, Point(X, Y));
end;

function TAbstract2DFigure.IsNearFocusMarker(const X, Y: Integer; out FocusMarker: TFocusMarker): boolean;
var
  fm: TFocusMarker;
begin
  FMD.Init(MinSelectDistance);
  for fm := Low(TFocusMarker) to High(TFocusMarker) do
    FMD.Add(Distance(FocusMarkerCenter(fm), X, Y), Ord(fm));
  Result := FMD.IsNear;
  if Result then
    FocusMarker := TFocusMarker(FMD.Index);
end;

function TAbstract2DFigure.IsSelected: Boolean;
begin
  Result := True;
end;

procedure TAbstract2DFigure.LPMoveShape(const X, Y: Integer);
begin
  Draw; // Hide
  CanvasShift(X - FLastPoint.CanvasPoint.X, Y - FLastPoint.CanvasPoint.Y);
  FLastPoint.CanvasPoint := frxPoint(X, Y);
  Draw; // Show
end;

procedure TAbstract2DFigure.LPResizeShape(const X, Y: Integer);
begin
  Draw; // Hide
  FResizer.Resize(X, Y);
  Draw; // Show
end;

function TAbstract2DFigure.MouseDown(const X, Y: Integer): boolean;
var
  FocusMarker: TFocusMarker;
begin
  case FState of
    fsSelected:
      if IsNearFocusMarker(X, Y, FocusMarker) then
      begin
        FResizer.Init(FocusMarker);
        FState := fsSelectedResize;
      end
      else if IsInsideFocusRect(X, Y) then
      begin
        FLastPoint.CanvasPoint := frxPoint(X, Y);
        FState := fsSelectedMoveShape;
      end
      else
        FState := fsSelectedMoveMap;
  end;
  Result := FState <> fsSelectedMoveMap; // not Result => Move Map
end;

function TAbstract2DFigure.MouseMove(const X, Y: Integer): boolean;
begin
  case FState of
    fsSelectedMoveShape:
      LPMoveShape(X, Y);
    fsSelectedResize:
      LPResizeShape(X, Y);
  end;
  Result := FState <> fsSelectedMoveMap; // not Result => Move Map
end;

procedure TAbstract2DFigure.MouseUp(const X, Y: Integer);
begin
  inherited MouseUp(X, Y);

  case FState of
    fsSelectedMoveMap, fsSelectedMoveShape, fsSelectedResize:
      FState := fsSelected;
  end;
end;

{ TAbstractRectFigure }

function TAbstractRectFigure.CalcFocusDoubleRect: TDoubleRect;
begin
  Result := DoubleRect(FTopLeft.CanvasPoint, FBottomRight.CanvasPoint);
end;

function TAbstractRectFigure.CalcFocusRect: TRect;
begin
  Result := ToRect(CalcFocusDoubleRect);
end;

function TAbstractRectFigure.CanvasBottomLeft: TfrxPoint;
begin
  Result := frxPoint(FTopLeft.CanvasPoint.X, FBottomRight.CanvasPoint.Y);
end;

procedure TAbstractRectFigure.CanvasShift(dX, dY: Extended);
begin
  FTopLeft.CanvasShift(dX, dY);
  FBottomRight.CanvasShift(dX, dY);
end;

function TAbstractRectFigure.CanvasTopRight: TfrxPoint;
begin
  Result := frxPoint(FBottomRight.CanvasPoint.X, FTopLeft.CanvasPoint.Y);
end;

constructor TAbstractRectFigure.Create(FCR: TFigureCreateRecord);
begin
  inherited;

  FTopLeft := TCanvasMapPair.Create(FConverter);
  FBottomRight := TCanvasMapPair.Create(FConverter);
  FResizer := TRectFigureResizer.Create(FTopLeft, FBottomRight);

  if FShape <> nil then
    FState := fsSelected
  else
  begin
    FTopLeft.CanvasPoint := frxPoint(FCR.X, FCR.Y);
    FBottomRight.CanvasPoint := frxPoint(FCR.X, FCR.Y);
    FResizer.Init(fmRightBottom);
    FState := fsSelectedResize;
  end
end;

destructor TAbstractRectFigure.Destroy;
begin
  FTopLeft.Free;
  FBottomRight.Free;
  FResizer.Free;

  inherited;
end;

function TAbstractRectFigure.GetShapeData(Strings: TStrings): TShapeData;
begin
  Result := TShapeData.CreateRect(Strings, ShapeType,
    DoubleRect(FTopLeft.MapPoint, FBottomRight.MapPoint));
end;

procedure TAbstractRectFigure.ReadShapeData;
begin
  with FShape.ShapeData.Rect do
  begin
    FTopLeft.MapPoint := frxPoint(Left, Top);
    FBottomRight.MapPoint := frxPoint(Right, Bottom);
  end;
end;

procedure TAbstractRectFigure.RecalcCanvas;
begin
  inherited;

  FTopLeft.CalcCanvas;
  FBottomRight.CalcCanvas;
end;

{ TRectFigureResizer }

constructor TRectFigureResizer.Create(AParentTopLeft, AParentBottomRight: TCanvasMapPair);
begin
  FParentTopLeft := AParentTopLeft;
  FParentBottomRight := AParentBottomRight;
end;

procedure TRectFigureResizer.Resize(const X, Y: Integer);
var
  TL, BR: TfrxPoint;
begin
  TL := FParentTopLeft.CanvasPoint;
  BR := FParentBottomRight.CanvasPoint;

  if      FMarker in LeftSide then  TL.X := Min(X, BR.X)
  else if FMarker in RightSide then BR.X := Max(X, TL.X);

  if      FMarker in TopSide then    TL.Y := Min(Y, BR.Y)
  else if FMarker in BottomSide then BR.Y := Max(Y, TL.Y);

  FParentTopLeft.CanvasPoint := TL;
  FParentBottomRight.CanvasPoint := BR;
end;

{ TDiamondFigure }

procedure TDiamondFigure.Draw;
var
  DR: TDoubleRect;
  Center: TDoublePoint;
  P: TPointArray;
begin
  DR := CalcFocusDoubleRect;
  Center := DoublePoint((DR.Left + DR.Right) / 2, (DR.Top + DR.Bottom) / 2);
  with CalcFocusDoubleRect do
  begin
    SetLength(P, 4);
    P[0] := ToPoint(Center.X, Top);
    P[1] := ToPoint(Right, Center.Y);
    P[2] := ToPoint(Center.X, Bottom);
    P[3] := ToPoint(Left,  Center.Y);
    DrawPolygon(P, RectView);
  end;
  DrawFocusRectangle;
end;

function TDiamondFigure.ShapeName: String;
begin
  Result := frxResources.Get('stDiamond');
end;

function TDiamondFigure.ShapeType: TShapeType;
begin
  Result := stDiamond;
end;

{ TEllipseFigure }

procedure TEllipseFigure.Draw;
begin
  DrawEllipse(FTopLeft.CanvasPoint, FBottomRight.CanvasPoint, RectView);
  DrawFocusRectangle;
end;

function TEllipseFigure.ShapeName: String;
begin
  Result := frxResources.Get('stEllipse');
end;

function TEllipseFigure.ShapeType: TShapeType;
begin
  Result := stEllipse;
end;

{ TPictureFigure }

constructor TPictureFigure.Create(FCR: TFigureCreateRecord; AConstrainProportions: Boolean);
begin
  inherited Create(FCR);
  SetConstrainProportions(AConstrainProportions);
  FPicture := TPicture.Create;
  FIntermediateBitmap := TBitmap.Create;
  FIntermediateBitmap.PixelFormat := pf24bit;
end;

procedure TPictureFigure.CreatePicture;
begin
  OpenPicture(True);
end;

destructor TPictureFigure.Destroy;
begin
  FIntermediateBitmap.Free;
  FPicture.Free;
  inherited;
end;

procedure TPictureFigure.Draw;
var
  DR: TDoubleRect;
begin
  DR := CalcFocusDoubleRect;
  if FConstrainProportions then
    DR := ConstrainedDR(DR, FPicture.Width, FPicture.Height);

  FCanvas.CopyMode := cmSrcInvert;
  FCanvas.StretchDraw(ToRect(DR), FIntermediateBitmap);
  DrawFocusRectangle;
end;

procedure TPictureFigure.DrawOnIntermediateBitmap;
begin
  with FIntermediateBitmap do
  begin
    Width := FPicture.Width;
    Height := FPicture.Height;
    Canvas.Draw(0, 0, FPicture.Graphic);
  end;
end;

function TPictureFigure.GetShapeData(Strings: TStrings): TShapeData;
begin
  Result := inherited GetShapeData(Strings);
  Result.Picture.Assign(FPicture);
  Result.ConstrainProportions := FConstrainProportions;
end;

procedure TPictureFigure.MakeDefaultPicture;
var
  x, y: Integer;
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf24bit;
  Bitmap.Width := InitialPictureSize;
  Bitmap.Height := InitialPictureSize;
  for x := 0 to Bitmap.Width - 1 do
    for y := 0 to Bitmap.Height - 1 do
      if Odd(x div 8) = Odd(y div 8) then
        Bitmap.Canvas.Pixels[x, y] := clWhite
      else
        Bitmap.Canvas.Pixels[x, y] := clLtGray;
  FPicture.Graphic := Bitmap;
  Bitmap.Free;
end;

procedure TPictureFigure.OpenPicture(NewlyCreated: Boolean = False);
begin
  with TfrxPictureEditorForm.Create(nil) do
    try
      Image.Picture.Assign(FPicture);
      if ShowModal = mrOk then
      begin
        FPicture.Assign(Image.Picture);
        if FPicture.Graphic = nil then
          MakeDefaultPicture;
        if NewlyCreated then
          FBottomRight.CanvasShift(InitialPictureSize, InitialPictureSize);
        DrawOnIntermediateBitmap;
//if FPicture.Graphic is TPNGObject then DisplayPNGInfo(TPNGObject(FPicture.Graphic)); { TODO : Debug }
      end;
    finally
      Free;
    end;
end;

procedure TPictureFigure.ReadShapeData;
begin
  inherited;

  FPicture.Assign(FShape.ShapeData.Picture);
  DrawOnIntermediateBitmap;
end;

procedure TPictureFigure.SetConstrainProportions(AConstrainProportions: Boolean);
begin
  FConstrainProportions := AConstrainProportions;
end;

function TPictureFigure.ShapeName: String;
begin
  Result := frxResources.Get('stPicture');
end;

function TPictureFigure.ShapeType: TShapeType;
begin
  Result := stPicture;
end;

{ TLegendFigure }

procedure TLegendFigure.Draw;
  function Distant(Value: Byte): Byte;
  begin
    Result := IfInt(Value > 127, 0, 255);
  end;
var
  Bitmap: TBitmap;
  Rect: TRect;
  i, hStep: Integer;
begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf24bit;
  Bitmap.Canvas.Font.Assign(FSecondFont);
  with Bitmap.Canvas.Font do
    Bitmap.Canvas.Brush.Color := RGB(Distant(GetRValue(Color)),
          Distant(GetGValue(Color)), Distant(GetBValue(Color)));
  Rect := CalcFocusRect;
  Bitmap.Width := Rect.Right - Rect.Left;
  Bitmap.Height := Rect.Bottom - Rect.Top;
  Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);

  hStep := Bitmap.Canvas.TextHeight('Wy');
  for i := 0 to FSecondLines.Count - 1 do
    Bitmap.Canvas.TextOut(0, i * hStep, FSecondLines[i]);

  FCanvas.CopyMode := cmSrcInvert;
  FCanvas.Draw(Rect.Left, Rect.Top, Bitmap);
  Bitmap.Free;

  DrawFocusRectangle;
end;

function TLegendFigure.GetShapeData(Strings: TStrings): TShapeData;
begin
  Result := inherited GetShapeData(Strings);
  Result.Font.Assign(FSecondFont);
  Result.LegendText.Assign(FSecondLines);
end;

function TLegendFigure.IsCanSave: boolean;
var
  i: Integer;
  st: String;
begin
  st := FSecondLines.Text;
  Result := st <> '';
  if Result then
    for i := 1 to Length(st) do
      if (st[i] <>  ' ') and (st[i] <> #10)  and (st[i] <> #13) then
        Exit;
  Result := False;
end;

function TLegendFigure.IsCanVK_DELETE: boolean;
begin
  Result := False;
end;

function TLegendFigure.ShapeName: String;
begin
  Result := frxResources.Get('stLegend');
end;

function TLegendFigure.ShapeType: TShapeType;
begin
  Result := stLegend;
end;

{ TAbstract2DResizer }

procedure TAbstract2DResizer.Init(AMarker: TFocusMarker);
begin
  FMarker := AMarker;
end;

{$IfNdef Delphi10}
{ TPaintBox }

procedure TPaintBox.CMMouseEnter(var Message: TMessage);
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TPaintBox.CMMouseLeave(var Message: TMessage);
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;
{$EndIf}

{ TAbstractMultyPointFigure }

function TAbstractMultyPointFigure.CalcFocusDoubleRect: TDoubleRect;
begin
  Result := DoubleRectExpand(FPairList.CalcFocusDoubleRect, FocusRectIndent);
end;

function TAbstractMultyPointFigure.CalcFocusRect: TRect;
begin
  Result := ToRect(CalcFocusDoubleRect);
end;

procedure TAbstractMultyPointFigure.CanvasShift(dX, dY: Extended);
begin
  FPairList.CanvasShift(dX, dY);
end;

constructor TAbstractMultyPointFigure.Create(FCR: TFigureCreateRecord);
begin
  inherited;

  FPairList := TPairList.Create;
  FResizer := TMultyPointResizer.Create(FPairList);

  if FShape <> nil then FState := fsSelected
  else                  FState := fsEmpty;
end;

destructor TAbstractMultyPointFigure.Destroy;
begin
  FPairList.Free;
  FResizer.Free;

  inherited;
end;

function TAbstractMultyPointFigure.GetShapeData(Strings: TStrings): TShapeData;
var
  i: Integer;
begin
  Result := TShapeData.CreatePoly(ShapeType, Strings, FPairList.Count);
  for i := 0 to FPairList.Count - 1 do
    with FPairList[i].MapPoint do
      Result.MultiLine[0, i] := DoublePoint(X, Y);
end;

function TAbstractMultyPointFigure.IsCanSave: boolean;
begin
  Result := (FPairList.Count >= MinCount) and (FState = fsSelected);
end;

function TAbstractMultyPointFigure.IsNearPoint(const X, Y: Integer; out PointIndex: Integer): boolean;
var
  i: Integer;
begin
  FMD.Init(MinSelectDistance);
  for i := 0 to FPairList.Count - 1 do
    FMD.Add(Distance(FPairList[i].CanvasPoint, X, Y), i);
  Result := FMD.IsNear;
  if Result then
    PointIndex := FMD.Index;
end;

function TAbstractMultyPointFigure.IsSelected: Boolean;
begin
  Result := FState in
    [fsSelected, fsSelectedMoveMap, fsSelectedMoveShape, fsSelectedResize];
end;

procedure TAbstractMultyPointFigure.ReadShapeData;
var
  i: Integer;
  CanvasMapPair: TCanvasMapPair;
begin
  for i := 0 to FShape.ShapeData.MultiLineCount[0] - 1 do
  begin
    CanvasMapPair := TCanvasMapPair.Create(FConverter);
    with FShape.ShapeData.MultiLine[0, i] do
      CanvasMapPair.MapPoint := frxPoint(X, Y);
    FPairList.Add(CanvasMapPair);
  end;
end;

procedure TAbstractMultyPointFigure.RecalcCanvas;
begin
  inherited;

  FPairList.RecalcCanvas;
end;

{ TTemplateFigure }

procedure TTemplateFigure.AddPoint(const X, Y: Integer);
var
  CanvasMapPair: TCanvasMapPair;
begin
  Draw; // Hide
  FLastPoint.CanvasPoint := frxPoint(X, Y);
  CanvasMapPair := TCanvasMapPair.CreateClone(FLastPoint);
  FPairList.Add(CanvasMapPair);
  if FPairList.Count >= MinCount then FState := fsComplete
  else                                FState := fsPartial;
  Draw; // Show
end;

constructor TTemplateFigure.Create(FCR: TFigureCreateRecord; APT: TfrxPolygonTemplate);
begin
  inherited Create(FCR);

  FPT := APT;
end;

procedure TTemplateFigure.Draw;
var
  i: Integer;
begin
  FCanvas.Lock;
  try
    SetupGraphics(FixedView);
    FPT.DrawWithNames(FCanvas, FPairList.CanvasPoints);
  finally
    FCanvas.Unlock;
  end;

  if FState in [fsSelected, fsSelectedMoveMap, fsSelectedMoveShape, fsSelectedResize] then
    DrawFocusRectangle
  else
    for i := 0 to FPairList.Count - 1 do
      DrawCircle(FPairList[i].CanvasPoint, MobileView);
end;

function TTemplateFigure.GetCursor(const X, Y: Integer): TVirtualCursor;
var
  PointIndex: Integer;
begin
  Result := vcDefault;
  case FState of
    fsSelected:
      if      IsNearPoint(X, Y, PointIndex)   then Result := vcUnFix
      else                                         Result := inherited GetCursor(X, Y);
  end;
end;

function TTemplateFigure.GetShapeData(Strings: TStrings): TShapeData;
begin
  Result := inherited GetShapeData(Strings);
  Result.TemplateName := FPT.Name;
end;

function TTemplateFigure.IsCanDeletePoint: boolean;
begin
  Result := False;
end;

function TTemplateFigure.IsCanFix: boolean;
begin
  Result := FPairList.Count + 1 = MinCount;
end;

function TTemplateFigure.MinCount: Integer;
begin
  Result := FPT.Count;
end;

function TTemplateFigure.MouseDown(const X, Y: Integer): boolean;
var
  PointIndex: Integer;
begin
  case FState of
    fsEmpty, fsPartial:
    begin
      AddPoint(X, Y);
      FMovedPointIndex := FPairList.Count - 1;
    end;
    fsSelected:
      if IsNearPoint(X, Y, PointIndex) then
      begin
        Draw; // Hide
        FState := fsComplete;
        FMovedPointIndex := PointIndex;
        Draw; // Show
      end
      else
        inherited MouseDown(X, Y);
  end;
  Result := FState <> fsSelectedMoveMap; // not Result => Move Map
end;

function TTemplateFigure.MouseMove(const X, Y: Integer): boolean;
begin
  case FState of
    fsPartial, fsComplete:
    begin
      Draw; // Hide
      FPairList[FMovedPointIndex].CanvasPoint := frxPoint(X, Y);
      Draw; // Show
    end;
  else
    inherited MouseMove(X, Y);
  end;
  Result := FState <> fsSelectedMoveMap; // not Result => Move Map
end;

procedure TTemplateFigure.MouseUp(const X, Y: Integer);
begin
  inherited MouseUp(X, Y);

  if FState = fsComplete then
  begin
    Draw; // Hide
    FState := fsSelected;
    Draw; // Show
  end;
end;

function TTemplateFigure.ShapeName: String;
begin
  Result := FPT.Name;
end;

function TTemplateFigure.ShapeType: TShapeType;
begin
  Result := stTemplate;
end;

end.
