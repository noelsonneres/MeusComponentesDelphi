{******************************************}
{                                          }
{             FastReport v6.0              }
{             Report classes               }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxClass;

interface

{$I frx.inc}

uses
  SysUtils, {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  Types, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, ExtCtrls, Printers, frxVariables, frxXML, frxProgress,
  fs_iinterpreter, frxUnicodeUtils, Variants, frxCollections, Math,
  frxVectorCanvas
{$IFDEF FPC}
  ,LResources, LMessages, LCLType, LCLIntf, LazarusPackageIntf,
  LCLProc, FileUtil, LazHelper
{$ENDIF}
{$IFNDEF NO_CRITICAL_SECTION}
,  SyncObjs
{$ENDIF}
{$IFDEF Delphi10}
, WideStrings
{$ENDIF}
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

const
  fr01cm: Extended = 3.77953;
  fr1cm: Extended = 37.7953;
  fr01in: Extended = 9.6;
  fr1in: Integer = 96;
  fr1CharX: Extended = 9.6;
  fr1CharY: Integer = 17;
  clTransparent: TColor = clNone;
  crHand: Integer = 150;
  crZoom: Integer = 151;
  crFormat: Integer = 152;
  DEF_REG_CONNECTIONS: String = '\Software\Fast Reports\Connections';
  WM_CREATEHANDLE = WM_USER + 1;
  WM_DESTROYHANDLE = WM_USER + 2;
  FRX_OWNER_DESTROY_MESSAGE = $D001;

type

  {$IFDEF NONWINFPC}

  { TfrxStringList }

  TfrxStringList = class(TStringList)
  protected
    function DoCompareText(const s1,s2 : string) : PtrInt; override;
  end;

  {$ENDIF}

  TfrxReport = class;
  TfrxPage = class;
  TfrxReportPage = class;
  TfrxDialogPage = class;
  TfrxCustomEngine = class;
  TfrxCustomDesigner = class;
  TfrxCustomPreview = class;
  TfrxCustomPreviewPages = class;
  TfrxComponent = class;
  TfrxReportComponent = class;
  TfrxView = class;
  TfrxStyleItem = class;
  TfrxCustomExportFilter = class;
  TfrxCustomCompressor = class;
  TfrxCustomDatabase = class;
  TfrxFrame = class;
  TfrxDataSet = class;
  TfrxHyperlink = class;
  TfrxInPlaceEditor = class;
  TfrxCustomIOTransport = class;
  TfrxComponentEditorsList = class;
  TfrxComponentEditorsManager = class;
  TfrxPostProcessor = class;
  TfrxObjectProcessing = class;
  TfrxMacrosItem = class;
  TfrxSelectedObjectsList = class;

  TfrxNotifyEvent = type String;
  TfrxCloseQueryEvent = type String;
  TfrxKeyEvent = type String;
  TfrxKeyPressEvent = type String;
  TfrxMouseEvent = type String;
  TfrxMouseEnterViewEvent = type String;
  TfrxMouseLeaveViewEvent = type String;
  TfrxMouseMoveEvent = type String;
  TfrxPreviewClickEvent = type String;
  TfrxRunDialogsEvent = type String;
  TfrxContentChangedEvent = type String;

  EDuplicateName = class(Exception);
  EExportTerminated = class(TObject);

  SYSINT = Integer;

  // TODO
  // remove unnecesary later
  // csContainer is legacy and used only with current crossTab for back compatibility
  // csObjectsContainer new flag which used in default Copy/Paste buffer for containers like Table
  // csContained means that object of this class only can be used inside other View object
  // csAcceptsFrxComponents used when view can accept other components as childs

  TfrxComponentStyle = set of (csContainer, csPreviewVisible, csDefaultDiff, csHandlesNestedProperties, csContained, csAcceptsFrxComponents, csObjectsContainer);
  TfrxStretchMode = (smDontStretch, smActualHeight, smMaxHeight);
  TfrxShiftMode = (smDontShift, smAlways, smWhenOverlapped);
  TfrxShiftEngine = (seLinear, seTree, seDontShift);
  TfrxDuplexMode = (dmNone, dmVertical, dmHorizontal, dmSimplex);

  TfrxAlign = (baNone, baLeft, baRight, baCenter, baWidth, baBottom, baClient, baHidden);

  TfrxFrameStyle = (fsSolid, fsDash, fsDot, fsDashDot, fsDashDotDot, fsDouble, fsAltDot, fsSquare);

  TfrxFrameType = (ftLeft, ftRight, ftTop, ftBottom);
  TfrxFrameTypes = set of TfrxFrameType;

  TfrxVisibilityType  = (vsPreview, vsExport, vsPrint);
  TfrxVisibilityTypes = set of TfrxVisibilityType;

  TfrxPrintOnType  = (ptFirstPage, ptLastPage, ptOddPages, ptEvenPages, ptRepeatedBand);
  TfrxPrintOnTypes = set of TfrxPrintOnType;

  TfrxFormatKind = (fkText, fkNumeric, fkDateTime, fkBoolean);

  TfrxHAlign = (haLeft, haRight, haCenter, haBlock);
  TfrxVAlign = (vaTop, vaBottom, vaCenter);

  TfrxSilentMode = (simMessageBoxes, simSilent, simReThrow);
  TfrxRestriction = (rfDontModify, rfDontSize, rfDontMove, rfDontDelete, rfDontEdit, rfDontEditInPreview, rfDontCopy);
  TfrxRestrictions = set of TfrxRestriction;

  TfrxShapeKind = (skRectangle, skRoundRectangle, skEllipse, skTriangle,
    skDiamond, skDiagonal1, skDiagonal2);

  TfrxPreviewButton = (pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind,
    pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick,
    pbNoClose, pbNoFullScreen, pbNoEmail, pbCopy, pbPaste, pbSelection, pbInplaceEdit);
  TfrxPreviewButtons = set of TfrxPreviewButton;
  TfrxZoomMode = (zmDefault, zmWholePage, zmPageWidth, zmManyPages);
  TfrxPrintPages = (ppAll, ppOdd, ppEven);
  TfrxAddPageAction = (apWriteOver, apAdd);
  TfrxRangeBegin = (rbFirst, rbCurrent);
  TfrxRangeEnd = (reLast, reCurrent, reCount);
  TfrxFieldType = (fftNumeric, fftString, fftBoolean, fftDateTime);
  TfrxProgressType = (ptRunning, ptExporting, ptPrinting);
  TfrxPrintMode = (pmDefault, pmSplit, pmJoin, pmScale);
  TfrxInheriteMode = (imDefault, imDelete, imRename);
  TfrxSerializeState = (ssTemplate, ssPreviewPages);
  TfrxHyperlinkKind = (hkURL, hkAnchor, hkPageNumber, hkDetailReport, hkDetailPage, hkCustom);

  TfrxFillType = (ftBrush, ftGradient, ftGlass);
  TfrxGradientStyle = (gsHorizontal, gsVertical, gsElliptic, gsRectangle,
    gsVertCenter, gsHorizCenter);
  { preview pages events }
  TfrxMouseIntEvents = (meClick, meDbClick, meMouseMove, meMouseUp, meMouseDown,
    meDragOver, meDragDrop, meMouseWheel);
  TfrxDesignTool = (dtSelect, dtHand, dtZoom, dtText, dtFormat, dtEditor);
  TfrxFilterAccess = (faRead, faWrite);

  TfrxDuplicateMerge = (dmShow, dmHide, dmClear, dmMerge);

  TfrxProcessAtMode = (paDefault, paReportFinished, paReportPageFinished,
    paPageFinished, paColumnFinished, paDataFinished, paGroupFinished,
    paCustom);
  TfrxGridType = (gt1pt, gt1cm, gt1in, gtDialog, gtChar, gtNone);
  TfrxCopyPasteType = (cptDefault, cptText, cptImage, cptNative);

  TfrxAnchorsKind = (fraLeft, fraTop, fraRight, fraBottom);
  TfrxAnchors = set of TfrxAnchorsKind;

  TfrxUnderlinesTextMode = (ulmNone, ulmUnderlinesAll, ulmUnderlinesText, ulmUnderlinesTextAndEmptyLines);

  TfrxMirrorControlMode = (mcmRTLBands, mcmRTLObjects, mcmRTLAppearance,
    mcmRTLContent, mcmRTLSpecial, mcmBTTBands, mcmBTTObjects, mcmBTTAppearance,
    mcmBTTContent, mcmBTTSpecial, mcmOnlySelected);
  TfrxMirrorControlModes = set of TfrxMirrorControlMode;

{$IFDEF DELPHI16}
  frxInteger = NativeInt;
{$ELSE}
  frxInteger = {$IFDEF FPC}PtrInt{$ELSE}Integer{$ENDIF};
{$ENDIF}

  TfrxPreviewIntEventParams = packed record
    MouseEventType: TfrxMouseIntEvents;
    Sender: TObject;
    Cursor: TCursor;
    EditMode: TfrxDesignTool;
    // DragDrop
    State: TDragState;
    Accept: Boolean;
    // Mouse Wheel
    WheelDelta: Integer;
    MousePos: TPoint;
    RetResult: Boolean;
  end;

  TfrxRect = packed record
    Left, Top, Right, Bottom: Extended;
  end;

  TfrxPoint = packed record
    X, Y: Extended;
  end;

  TfrxDispatchMessage = record
    MsgID: Word;
    Sender: TObject;
  end;

  { class uses in DragDrop events }
  { it helps to determinate when object event was called from another object editor }
  { check TfrxInPlaceBandEditor.DoCustomDragDrop }
  TfrxEventObject = class(TObject)
  public
    Sender: TObject;
    Index: NativeInt;
  end;

  TfrxInteractiveEventSender = (esDesigner, esPreview);
  TfrxOnFinishInPlaceEdit = procedure(Sender: TObject; Refresh, Modified: Boolean) of object;

  { remove unnecessary fields later }
  TfrxInteractiveEventsParams = packed record
    Sender: TObject;
    Refresh, Modified: Boolean;
    FireParentEvent: Boolean;
    EventSender: TfrxInteractiveEventSender;
    OnFinish: TfrxOnFinishInPlaceEdit;
    EditMode: TfrxDesignTool;
    PopupVisible: Boolean;
    EditRestricted: Boolean;
    { lets the object decide what editor to chose, not designer }
    EditorsList: TfrxComponentEditorsList;
    SelectionList: TfrxSelectedObjectsList;
    OffsetX: Extended;
    OffsetY: Extended;
    Scale: Extended;
    GridAlign: Boolean;
    GridType: TfrxGridType;
    GridX: Extended;
    GridY: Extended;
  end;

  TfrxGetCustomDataEvent = procedure(XMLItem: TfrxXMLItem) of object;
  TfrxSaveCustomDataEvent = procedure(XMLItem: TfrxXMLItem) of object;
  TfrxProgressEvent = procedure(Sender: TfrxReport;
    ProgressType: TfrxProgressType; Progress: Integer) of object;
  TfrxBeforePrintEvent = procedure(Sender: TfrxReportComponent) of object;
  TfrxGetValueEvent = procedure(const VarName: String; var Value: Variant) of object;
  TfrxNewGetValueEvent = procedure(Sender: TObject; const VarName: String; var Value: Variant) of object;
  TfrxGetBlobValueEvent = procedure(Sender: TObject; const FileldName: String; AssignTo: TObject) of object;
  TfrxIsBlobFieldEvent = function(Sender: TObject; const FileldName: String): Boolean of object;
  TfrxUserFunctionEvent = function(const MethodName: String;
    var Params: Variant): Variant of object;
  TfrxManualBuildEvent = procedure(Page: TfrxPage) of object;
  TfrxClickObjectEvent = procedure(Sender: TfrxView;
    Button: TMouseButton; Shift: TShiftState; var Modified: Boolean) of object;
  TfrxMouseOverObjectEvent = procedure(Sender: TfrxView) of object;
  TfrxMouseEnterEvent = procedure(Sender: TfrxView) of object;
  TfrxMouseLeaveEvent = procedure(Sender: TfrxView) of object;
  TfrxCheckEOFEvent = procedure(Sender: TObject; var Eof: Boolean) of object;
  TfrxRunDialogEvent = procedure(Page: TfrxDialogPage) of object;
  TfrxEditConnectionEvent = function(const ConnString: String): String of object;
  TfrxSetConnectionEvent = procedure(const ConnString: String) of object;
  TfrxBeforeConnectEvent = procedure(Sender: TfrxCustomDatabase; var Connected: Boolean) of object;
  TfrxAfterDisconnectEvent = procedure(Sender: TfrxCustomDatabase) of object;
  TfrxPrintPageEvent = procedure(Page: TfrxReportPage; CopyNo: Integer) of object;
  TfrxLoadTemplateEvent = procedure(Report: TfrxReport; const TemplateName: String) of object;
  TfrxLoadDetailTemplateEvent = function(Report :TfrxReport; const TemplateName :String; const AHyperlink :TfrxHyperlink): Boolean of object;

{ Root classes }

  { standard list with Notify event }
  { used as helper to detect added/deleted objets }

  TfrxObjectsNotifyEvent = procedure(Ptr: Pointer; Action: TListNotification) of object;

  TfrxObjectsNotifyList = class(TList)
  private
    FOnNotifyList: TfrxObjectsNotifyEvent;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    property OnNotifyList: TfrxObjectsNotifyEvent read FOnNotifyList write FOnNotifyList;
  end;

  TfrxComponent = class(TComponent)
  private
    FFont: TFont;
    FObjects: TfrxObjectsNotifyList;
    FAllObjects: TList;
    FSortedObjects: TStringList;
    FLeft: Extended;
    FTop: Extended;
    FWidth: Extended;
    FHeight: Extended;
    FParentFont: Boolean;
    FGroupIndex: Integer;
    FIsDesigning: Boolean;
    FIsLoading: Boolean;
    FIsPrinting: Boolean;
    FIsWriting: Boolean;
    FMouseInView: Boolean;
    //FIsSelected: Boolean;
    FSelectList: TList;
    FRestrictions: TfrxRestrictions;
    FVisible: Boolean;
    FDescription: String;
    FComponentStyle: TfrxComponentStyle;
    FAncestorOnlyStream: Boolean;
    FIndexTag: frxInteger;
    FAnchors: TfrxAnchors;
    FAnchorsUpdating: Boolean;
    function GetAbsTop: Extended;
    function GetPage: TfrxPage;
    function GetReport: TfrxReport;
    function GetTopParent: TfrxComponent;
    function IsFontStored: Boolean;
    function GetAllObjects: TList;
    function GetSortedObjects: TStringList;
    function GetAbsLeft: Extended;
    function GetIsLoading: Boolean;
    function GetIsAncestor: Boolean;
    function GetIsSelected: Boolean;
  protected
    FParent: TfrxComponent;
    FAliasName: String;
    FBaseName: String;
    FAncestor: Boolean;
    FOriginalComponent: TfrxComponent;
    FOriginalRect: TfrxRect;
    FOriginalBand: TfrxComponent;
    FComponentEditors: TfrxComponentEditorsManager;
    FSerializedItem: TfrxXMLItem;
    FHighlighted: Boolean;
    function IsTopStored: Boolean; virtual;
    function IsLeftStored: Boolean; virtual;
    function IsWidthStored: Boolean; virtual;
    function IsHeightStored: Boolean; virtual;
    function IsIndexTagStored: Boolean;
    procedure SetAnchors(const Value: TfrxAnchors); virtual;
    procedure SetIsSelected(const Value: Boolean); virtual;
    procedure SetParent(AParent: TfrxComponent); virtual;
    procedure SetLeft(Value: Extended); virtual;
    procedure SetTop(Value: Extended); virtual;
    procedure SetWidth(Value: Extended); virtual;
    procedure SetHeight(Value: Extended); virtual;
    procedure SetName(const AName: TComponentName); override;
    procedure SetFont(Value: TFont); virtual;
    procedure SetParentFont(const Value: Boolean); virtual;
    procedure SetVisible(Value: Boolean); virtual;
    procedure FontChanged(Sender: TObject); virtual;
    function DiffFont(f1, f2: TFont; const Add: String): String;
    function InternalDiff(AComponent: TfrxComponent): String;
    function GetContainerObjects: TList; virtual;
    function GetRestrictions: TfrxRestrictions; virtual;
    procedure InintComponentInPlaceEditor(var EventParams: TfrxInteractiveEventsParams);
    { override to detect what was added or deleted from Objects list }
    procedure ObjectListNotify(Ptr: Pointer; Action: TListNotification); virtual;
    procedure LockAnchorsUpdate;
    procedure UnlockAnchorsUpdate;

    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetChildOwner: TComponent; override;

        { interactive object behaviour }
    procedure DoMouseMove(X, Y: Integer; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); virtual;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams); virtual;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams)
      : Boolean; virtual;
    procedure DoMouseEnter(aPreviousObject: TfrxComponent;
      var EventParams: TfrxInteractiveEventsParams); virtual;
    procedure DoMouseLeave(aNextObject: TfrxComponent;
      var EventParams: TfrxInteractiveEventsParams); virtual;
    procedure DoMouseClick(Double: Boolean;
      var EventParams: TfrxInteractiveEventsParams); virtual;
    function DoMouseWheel(Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint;
      var EventParams: TfrxInteractiveEventsParams): Boolean; virtual;
    function DoDragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams)
      : Boolean; virtual;
    function DoDragDrop(Source: TObject; X, Y: Integer;
      var EventParams: TfrxInteractiveEventsParams): Boolean; virtual;
    procedure MirrorContent(MirrorModes: TfrxMirrorControlModes); virtual;
    procedure DoMirror(MirrorModes: TfrxMirrorControlModes); virtual;
    procedure UpdateAnchors(DeltaX, Deltay: Extended); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); virtual;
    destructor Destroy; override;
    class function GetDescription: String; virtual;
    procedure AlignChildren(IgnoreInvisible: Boolean = False; MirrorModes: TfrxMirrorControlModes = []); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure AssignAll(Source: TfrxComponent; Streaming: Boolean = False);
    procedure AssignAllWithOriginals(Source: TfrxComponent; Streaming: Boolean = False);
    procedure AddSourceObjects; virtual;
    procedure BeforeStartReport; virtual;
    procedure Clear; virtual;
    procedure CreateUniqueName(DefaultReport: TfrxReport = nil);
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream; SaveChildren: Boolean = True;
      SaveDefaultValues: Boolean = False; Streaming: Boolean = False); virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Extended);
    procedure OnNotify(Sender: TObject); virtual;
    procedure OnPaste; virtual;
    function AllDiff(AComponent: TfrxComponent): String;
    function Diff(AComponent: TfrxComponent): String; virtual;
    function FindObject(const AName: String): TfrxComponent; virtual;
    procedure WriteNestedProperties(Item: TfrxXmlItem; aAcenstor: TPersistent = nil); virtual;
    function ReadNestedProperty(Item: TfrxXmlItem): Boolean; virtual;
    { detect if point is inside an object coordinates }
    function IsContain(X, Y: Extended): Boolean; virtual;
    function IsInRect(const aRect: TfrxRect): Boolean; virtual;
    function GetClientArea: TfrxRect; virtual;
    function GetDrawTextObject: Pointer;
    function GetGlobalReport: TfrxReport;
    { return top-most object which contain point at passed coordinates }
    { IsCanContain = nil - return top-most object }
    { IsCanContain <> nil - return top-most object which can accept IsCanContain component as child }
    function GetContainedComponent(X, Y: Extended; IsCanContain: TfrxComponent = nil): TfrxComponent; virtual;
    procedure GetContainedComponents(const aRect: TfrxRect; InheriteFrom: TClass; aComponents: TList; bSelectContainers: Boolean = False); virtual;
    function ExportInternal(Filter: TfrxCustomExportFilter): Boolean; virtual;

    { control behaviour for detection childs which it can holds }
    function IsAcceptControl(aControl: TfrxComponent): Boolean; virtual;
    function IsAcceptAsChild(aParent: TfrxComponent): Boolean; virtual;
    { general function just quick check of flag }
    function IsAcceptControls: Boolean; virtual;
    { events trigger }
    procedure MouseMove(X, Y: Integer; Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams);
    procedure MouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState;
      var EventParams: TfrxInteractiveEventsParams);
    function MouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams)
      : Boolean;
    procedure MouseEnter(aPreviousObject: TfrxComponent;
      var EventParams: TfrxInteractiveEventsParams);
    procedure MouseLeave(X, Y: Integer; aNextObject: TfrxComponent;
      var EventParams: TfrxInteractiveEventsParams);
    procedure MouseClick(Double: Boolean;
      var EventParams: TfrxInteractiveEventsParams);
    function MouseWheel(Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint;
      var EventParams: TfrxInteractiveEventsParams): Boolean;
    function DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams)
      : Boolean;
    function DragDrop(Source: TObject; X, Y: Integer;
      var EventParams: TfrxInteractiveEventsParams): Boolean;

//    procedure FireEvent(Sender: TObject; X, Y: Integer; Button: TMouseButton; Shift: TShiftState; Scale, OffsetX, OffsetY: Extended; var aEventParams: TfrxPreviewIntEventParams);
    procedure UpdateBounds; virtual;
    function ContainerAdd(Obj: TfrxComponent): Boolean; virtual;
    function FindDataSet(DataSet: TfrxDataSet; const DSName: String): TfrxDataSet;
    property Anchors: TfrxAnchors read FAnchors write SetAnchors default [fraLeft, fraTop];
    property AncestorOnlyStream: Boolean read FAncestorOnlyStream write FAncestorOnlyStream;
    property Objects: TfrxObjectsNotifyList read FObjects;
    property AllObjects: TList read GetAllObjects;
    property ContainerObjects: TList read GetContainerObjects;
    property Parent: TfrxComponent read FParent write SetParent;
    property Page: TfrxPage read GetPage;
    property Report: TfrxReport read GetReport;
    property TopParent: TfrxComponent read GetTopParent;
    property IsAncestor: Boolean read GetIsAncestor;
    property IsDesigning: Boolean read FIsDesigning write FIsDesigning;
    property IsLoading: Boolean read GetIsLoading write FIsLoading;
    property IsPrinting: Boolean read FIsPrinting write FIsPrinting;
    property IsWriting: Boolean read FIsWriting write FIsWriting;
    property IsSelected: Boolean read GetIsSelected write SetIsSelected;
    property BaseName: String read FBaseName;
    property GroupIndex: Integer read FGroupIndex write FGroupIndex default 0;
    property frComponentStyle: TfrxComponentStyle read FComponentStyle write FComponentStyle;

    property Left: Extended read FLeft write SetLeft stored IsLeftStored;
    property Top: Extended read FTop write SetTop stored IsTopStored;
    property Width: Extended read FWidth write SetWidth stored IsWidthStored;
    property Height: Extended read FHeight write SetHeight stored IsHeightStored;
    property AbsLeft: Extended read GetAbsLeft;
    property AbsTop: Extended read GetAbsTop;

    property Description: String read FDescription write FDescription;
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property Restrictions: TfrxRestrictions read GetRestrictions write FRestrictions default [];
    property Visible: Boolean read FVisible write SetVisible default True;
    property Font: TFont read FFont write SetFont stored IsFontStored;
    property IndexTag: frxInteger read FIndexTag write FIndexTag stored IsIndexTagStored;
  end;

  TfrxReportComponent = class(TfrxComponent)
  private
    FOnAfterData: TfrxNotifyEvent;
    FOnAfterPrint: TfrxNotifyEvent;
    FOnBeforePrint: TfrxNotifyEvent;
    FOnPreviewClick: TfrxPreviewClickEvent;
    FOnPreviewDblClick: TfrxPreviewClickEvent;
    FOnContentChanged: TfrxContentChangedEvent;
    FPrintOn: TfrxPrintOnTypes;
  protected
    procedure DrawSizeBox(aCanvas: TCanvas; aScale: Extended; bForceDraw: Boolean = False); virtual;
  public
    FShiftObject: TObject; { used in new shift mechanism, stores shift tree or list }
    FOriginalObjectsCount: Integer;      { used for TfrxSubReport.PrintOnParent }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { used from designer and preview calls Draw/Highlighted }
    procedure InteractiveDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended; Highlighted: Boolean = False; hlColor: TColor = clNone);
    { back compat }
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
      virtual; abstract;
    procedure DrawChilds(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended; Highlighted: Boolean; IsDesigning: Boolean);
      virtual;
    procedure DrawWithChilds(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended; Highlighted: Boolean; IsDesigning: Boolean);
    procedure DrawHighlight(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended; hlColor: TColor = clNone); virtual;
    procedure BeforePrint; virtual;
    procedure GetData; virtual;
    procedure AfterPrint; virtual;
    function GetComponentText: String; virtual;
    function GetRealBounds: TfrxRect; virtual;
    function GetSaveToComponent: TfrxReportComponent; virtual;
    function IsOwnerDraw: Boolean; virtual;
    property OnAfterData: TfrxNotifyEvent read FOnAfterData write FOnAfterData;
    property OnAfterPrint: TfrxNotifyEvent read FOnAfterPrint write FOnAfterPrint;
    property OnBeforePrint: TfrxNotifyEvent read FOnBeforePrint write FOnBeforePrint;
    property OnPreviewClick: TfrxPreviewClickEvent read FOnPreviewClick write FOnPreviewClick;
    property OnPreviewDblClick: TfrxPreviewClickEvent read FOnPreviewDblClick write FOnPreviewDblClick;
    property OnContentChanged: TfrxContentChangedEvent read FOnContentChanged write FOnContentChanged;
    // todo
    property PrintOn: TfrxPrintOnTypes read FPrintOn write FPrintOn;
  published
    property Description;
    property IndexTag;
  end;

  TfrxDialogComponent = class(TfrxReportComponent)
  private
    FComponent: TComponent;
    procedure ReadLeft(Reader: TReader);
    procedure ReadTop(Reader: TReader);
    procedure WriteLeft(Writer: TWriter);
    procedure WriteTop(Writer: TWriter);
  protected
    FImageIndex: Integer;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    property Component: TComponent read FComponent write FComponent;
  end;

  TfrxDialogControl = class(TfrxReportComponent)
  private
    FControl: TControl;
    FOnClick: TfrxNotifyEvent;
    FOnDblClick: TfrxNotifyEvent;
    FOnEnter: TfrxNotifyEvent;
    FOnExit: TfrxNotifyEvent;
    FOnKeyDown: TfrxKeyEvent;
    FOnKeyPress: TfrxKeyPressEvent;
    FOnKeyUp: TfrxKeyEvent;
    FOnMouseDown: TfrxMouseEvent;
    FOnMouseMove: TfrxMouseMoveEvent;
    FOnMouseUp: TfrxMouseEvent;
    FOnActivate: TNotifyEvent;
    function GetColor: TColor;
    function GetEnabled: Boolean;
    procedure DoOnClick(Sender: TObject);
    procedure DoOnDblClick(Sender: TObject);
    procedure DoOnEnter(Sender: TObject);
    procedure DoOnExit(Sender: TObject);
    procedure DoOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnKeyPress(Sender: TObject; var Key: Char);
    procedure DoOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DoOnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoOnMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SetColor(const Value: TColor);
    procedure SetEnabled(const Value: Boolean);
    function GetCaption: String;
    procedure SetCaption(const Value: String);
    function GetHint: String;
    procedure SetHint(const Value: String);
    function GetShowHint: Boolean;
    procedure SetShowHint(const Value: Boolean);
    function GetTabStop: Boolean;
    procedure SetTabStop(const Value: Boolean);
  protected
    procedure SetAnchors(const Value: TfrxAnchors); override;
    procedure SetLeft(Value: Extended); override;
    procedure SetTop(Value: Extended); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    procedure SetParentFont(const Value: Boolean); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetParent(AParent: TfrxComponent); override;
    procedure FontChanged(Sender: TObject); override;
    procedure InitControl(AControl: TControl);
    procedure SetName(const AName: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    function IsOwnerDraw: Boolean; override;
    function IsAcceptControls: Boolean; override;
    function IsAcceptAsChild(aParent: TfrxComponent): Boolean; override;
    property Caption: String read GetCaption write SetCaption;
    property Color: TColor read GetColor write SetColor;
    property Control: TControl read FControl write FControl;
    property TabStop: Boolean read GetTabStop write SetTabStop default True;
    property OnClick: TfrxNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TfrxNotifyEvent read FOnDblClick write FOnDblClick;
    property OnEnter: TfrxNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TfrxNotifyEvent read FOnExit write FOnExit;
    property OnKeyDown: TfrxKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyPress: TfrxKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp: TfrxKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnMouseDown: TfrxMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TfrxMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TfrxMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
  published
    property Anchors;
    property Left;
    property Top;
    property Width;
    property Height;
    property Font;
    property GroupIndex;
    property ParentFont;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    property Hint: String read GetHint write SetHint;
    property ShowHint: Boolean read GetShowHint write SetShowHint;
    property Visible;
  end;

  TfrxDataSet = class(TfrxDialogComponent)
  private
    FCloseDataSource: Boolean;
    FEnabled: Boolean;
    FEof: Boolean;
    FOpenDataSource: Boolean;
    FRangeBegin: TfrxRangeBegin;
    FRangeEnd: TfrxRangeEnd;
    FRangeEndCount: Integer;
    FReportRef: TfrxReport;
    FUserName: String;
    FOnCheckEOF: TfrxCheckEOFEvent;
    FOnFirst: TNotifyEvent;
    FOnNext: TNotifyEvent;
    FOnPrior: TNotifyEvent;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
  protected
    FInitialized: Boolean;
    FRecNo: Integer;
    function GetDisplayText(Index: String): WideString; virtual;
    function GetDisplayWidth(Index: String): Integer; virtual;
    function GetFieldType(Index: String): TfrxFieldType; virtual;
    function GetValue(Index: String): Variant; virtual;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetUserName(const Value: String); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Navigation methods }
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure Open; virtual;
    procedure Close; virtual;
    procedure First; virtual;
    procedure Next; virtual;
    procedure Prior; virtual;
    function Eof: Boolean; virtual;

    { Data access }
    function FieldsCount: Integer; virtual;
    function HasField(const fName: String): Boolean;
    function IsBlobField(const fName: String): Boolean; virtual;
    function IsWideMemoBlobField(const fName: String): Boolean; virtual;
    function IsHasMaster: Boolean; virtual;
    function RecordCount: Integer; virtual;
    procedure AssignBlobTo(const fName: String; Obj: TObject); virtual;
    procedure GetFieldList(List: TStrings); virtual;
    property DisplayText[Index: String]: WideString read GetDisplayText;
    property DisplayWidth[Index: String]: Integer read GetDisplayWidth;
    property FieldType[Index: String]: TfrxFieldType read GetFieldType;
    property Value[Index: String]: Variant read GetValue;

    property CloseDataSource: Boolean read FCloseDataSource write FCloseDataSource;
    { OpenDataSource is kept for backward compatibility only }
    property OpenDataSource: Boolean read FOpenDataSource write FOpenDataSource default True;
    property RecNo: Integer read FRecNo;
    property ReportRef: TfrxReport read FReportRef write FReportRef;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
  published
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property RangeBegin: TfrxRangeBegin read FRangeBegin write FRangeBegin default rbFirst;
    property RangeEnd: TfrxRangeEnd read FRangeEnd write FRangeEnd default reLast;
    property RangeEndCount: Integer read FRangeEndCount write FRangeEndCount default 0;
    property UserName: String read FUserName write SetUserName;
    property OnCheckEOF: TfrxCheckEOFEvent read FOnCheckEOF write FOnCheckEOF;
    property OnFirst: TNotifyEvent read FOnFirst write FOnFirst;
    property OnNext: TNotifyEvent read FOnNext write FOnNext;
    property OnPrior: TNotifyEvent read FOnPrior write FOnPrior;
  end;

  TfrxComponentClass = class of TfrxComponent;

  TfrxBindableFieldProps = class(TPersistent)
    //
  end;

  { work in progress new aliases }
  {
  TfrxFileld = class(TPersistent)
  private
    FFiledName: String;
    FFieldAlias: String;
//    FBindComponent: TfrxComponentClass;
    FFieldType: TfrxFieldType;
    FFileld: TObject;
    FBindableFieldProps: TfrxBindableFieldProps;
  published
    property FiledName: String read FFiledName write FFiledName;
    property FieldAlias: String read FFieldAlias write FFieldAlias;
//    property BindComponent: TfrxComponentClass read FBindComponent write FBindComponent;
    property FieldType: TfrxFieldType read FFieldType write FFieldType;
    property Fileld: TObject read FFileld write FFileld;
    property BindableProperties: TfrxBindableFieldProps read FBindableFieldProps write FBindableFieldProps;
  end;
  }
  {
  TfrxFieldsStringList = class(TStringList)
  private
    function GetField(Index: Integer): TfrxFileld;
    procedure PutField(Index: Integer; const Value: TfrxFileld);
  public
    property Fields[Index: Integer]: TfrxFileld read GetField write PutField;
  end;
  }

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxUserDataSet = class(TfrxDataset)
  private
    FFields: TStrings;
    FOnGetValue: TfrxGetValueEvent;
    FOnNewGetValue: TfrxNewGetValueEvent;
    FOnGetBlobValue: TfrxGetBlobValueEvent;
    FOnIsBlobField : TfrxIsBlobFieldEvent;
    procedure SetFields(const Value: TStrings);
  protected
    function GetDisplayText(Index: String): WideString; override;
    function GetValue(Index: String): Variant; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FieldsCount: Integer; override;
    procedure GetFieldList(List: TStrings); override;
    function IsBlobField(const FieldName: String): Boolean; override;
    procedure AssignBlobTo(const FieldName: String; Obj: TObject); override;
  published
    property Fields: TStrings read FFields write SetFields;
    property OnGetValue: TfrxGetValueEvent read FOnGetValue write FOnGetValue;
    property OnNewGetValue: TfrxNewGetValueEvent read FOnNewGetValue write FOnNewGetValue;
    property OnGetBlobValue: TfrxGetBlobValueEvent read FOnGetBlobValue write FOnGetBlobValue;
    property OnIsBlobField: TfrxIsBlobFieldEvent read FOnIsBlobField write FOnIsBlobField;
  end;

  TfrxCustomDBDataSet = class(TfrxDataSet)
  private
    FAliases: TStrings;
    FFields: TStringList;
    //TODO
    //FFields: TfrxFieldsStringList;
    //procedure SetFieldAliases(const Value: TfrxFieldsStringList);
    procedure SetFieldAliases(const Value: TStrings);
  protected
    property Fields: TStringList read FFields;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ConvertAlias(const fName: String): String;
    function GetAlias(const fName: String): String;
    function FieldsCount: Integer; override;
  published
    property CloseDataSource;
    //property FieldAliases: TfrxFieldsStringList read FFields write SetFieldAliases;
    property FieldAliases: TStrings read FAliases write SetFieldAliases;
    property OpenDataSource;
    property OnClose;
    property OnOpen;
  end;

  TfrxDBComponents = class(TComponent)
  public
    function GetDescription: String; virtual;
  end;

  TfrxCustomDatabase = class(TfrxDialogComponent)
  protected
    procedure BeforeConnect(var Value: Boolean);
    procedure AfterDisconnect;
    procedure SetConnected(Value: Boolean); virtual;
    procedure SetDatabaseName(const Value: String); virtual;
    procedure SetLoginPrompt(Value: Boolean); virtual;
    procedure SetParams(Value: TStrings); virtual;
    function GetConnected: Boolean; virtual;
    function GetDatabaseName: String; virtual;
    function GetLoginPrompt: Boolean; virtual;
    function GetParams: TStrings; virtual;
  public
    function ToString: WideString{$IFDEF Delphi12}; reintroduce{$ENDIF}; virtual;
    procedure FromString(const Connection: WideString); virtual;
    procedure SetLogin(const Login, Password: String); virtual;
    property Connected: Boolean read GetConnected write SetConnected default False;
    property DatabaseName: String read GetDatabaseName write SetDatabaseName;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt default True;
    property Params: TStrings read GetParams write SetParams;
  end;

{ Report Objects }

  TfrxFillGaps = class(TPersistent)
  private
    FTop: Integer;
    FLeft: Integer;
    FBottom: Integer;
    FRight: Integer;
  published
    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property Bottom: Integer read FBottom write FBottom;
    property Right: Integer read FRight write FRight;
  end;

  TfrxCustomFill = class(TPersistent)
  public
//    procedure Assign(Source: TfrxCustomFill); virtual; abstract;
    procedure Draw(ACanvas: TCanvas; X, Y, X1, Y1: Integer; ScaleX, ScaleY: Extended); virtual; abstract;
    function Diff(AFill: TfrxCustomFill; const Add: String): String; virtual; abstract;
  end;

  TfrxBrushFill = class(TfrxCustomFill)
  private
    FBackColor: TColor;
    FForeColor: TColor;
    FStyle: TBrushStyle;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(ACanvas: TCanvas; X, Y, X1, Y1: Integer; ScaleX, ScaleY: Extended); override;
    function Diff(AFill: TfrxCustomFill; const Add: String): String; override;
  published
    property BackColor: TColor read FBackColor write FBackColor default clNone;
    property ForeColor: TColor read FForeColor write FForeColor default clBlack;
    property Style: TBrushStyle read FStyle write FStyle default bsSolid;
  end;

  TfrxGradientFill = class(TfrxCustomFill)
  private
    FStartColor: TColor;
    FEndColor: TColor;
    FGradientStyle: TfrxGradientStyle;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(ACanvas: TCanvas; X, Y, X1, Y1: Integer; ScaleX, ScaleY: Extended); override;
    function Diff(AFill: TfrxCustomFill; const Add: String): String; override;
    function GetColor: TColor;
  published
    property StartColor: TColor read FStartColor write FStartColor default clWhite;
    property EndColor: TColor read FEndColor write FEndColor default clBlack;
    property GradientStyle: TfrxGradientStyle read FGradientStyle write FGradientStyle;
  end;


  TfrxGlassFillOrientation = (foVertical, foHorizontal, foVerticalMirror, foHorizontalMirror);

  TfrxGlassFill = class(TfrxCustomFill)
  private
    FColor: TColor;
    FBlend: Extended;
    FHatch: Boolean;
    FOrient: TfrxGlassFillOrientation;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(ACanvas: TCanvas; X, Y, X1, Y1: Integer; ScaleX, ScaleY: Extended); override;
    function Diff(AFill: TfrxCustomFill; const Add: String): String; override;
    function GetColor: TColor;
    function BlendColor: TColor;
    function HatchColor: TColor;
  published
    property Color: TColor read FColor write FColor default clWhite;
    property Blend: Extended read FBlend write FBlend;
    property Hatch: Boolean read FHatch write FHatch default False;
    property Orientation: TfrxGlassFillOrientation read FOrient write FOrient default foHorizontal;
  end;


  TfrxHyperlink = class(TPersistent)
  private
    FKind: TfrxHyperlinkKind;
    FDetailReport: String;
    FDetailPage: String;
    FExpression: String;
    FReportVariable: String;
    FValue: String;
    FValuesSeparator: String;
    FTabCaption: String;
    function IsValuesSeparatorStored: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    function Diff(ALink: TfrxHyperlink; const Add: String): String;
    procedure AssignVariables(aReport: TfrxReport);
  published
    property Kind: TfrxHyperlinkKind read FKind write FKind default hkURL;
    property DetailReport: String read FDetailReport write FDetailReport;
    property DetailPage: String read FDetailPage write FDetailPage;
    property Expression: String read FExpression write FExpression;
    property ReportVariable: String read FReportVariable write FReportVariable;
    property TabCaption: String read FTabCaption write FTabCaption;
    property Value: String read FValue write FValue;
    property ValuesSeparator: String read FValuesSeparator write FValuesSeparator stored IsValuesSeparatorStored;
  end;

  TfrxFrameLine = class(TPersistent)
  private
    FFrame: TfrxFrame;
    FColor: TColor;
    FStyle: TfrxFrameStyle;
    FWidth: Extended;
    function IsColorStored: Boolean;
    function IsStyleStored: Boolean;
    function IsWidthStored: Boolean;
  public
    constructor Create(AFrame: TfrxFrame);
    procedure Assign(Source: TPersistent); override;

    function Diff(ALine: TfrxFrameLine; const LineName: String;
      ColorChanged, StyleChanged, WidthChanged: Boolean): String;
  published
    property Color: TColor read FColor write FColor stored IsColorStored;
    property Style: TfrxFrameStyle read FStyle write FStyle stored IsStyleStored;
    property Width: Extended read FWidth write FWidth stored IsWidthStored;
  end;


  TfrxFrame = class(TPersistent)
  private
    FLeftLine: TfrxFrameLine;
    FTopLine: TfrxFrameLine;
    FRightLine: TfrxFrameLine;
    FBottomLine: TfrxFrameLine;
    FColor: TColor;
    FDropShadow: Boolean;
    FShadowWidth: Extended;
    FShadowColor: TColor;
    FStyle: TfrxFrameStyle;
    FTyp: TfrxFrameTypes;
    FWidth: Extended;
    function IsShadowWidthStored: Boolean;
    function IsTypStored: Boolean;
    function IsWidthStored: Boolean;
    procedure SetBottomLine(const Value: TfrxFrameLine);
    procedure SetLeftLine(const Value: TfrxFrameLine);
    procedure SetRightLine(const Value: TfrxFrameLine);
    procedure SetTopLine(const Value: TfrxFrameLine);
    procedure SetColor(const Value: TColor);
    procedure SetStyle(const Value: TfrxFrameStyle);
    procedure SetWidth(const Value: Extended);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function Diff(AFrame: TfrxFrame): String;
    procedure Draw(Canvas: TCanvas; FX, FY, FX1, FY1: Integer; ScaleX, ScaleY: Extended);
  published
    property Color: TColor read FColor write SetColor default clBlack;
    property DropShadow: Boolean read FDropShadow write FDropShadow default False;
    property ShadowColor: TColor read FShadowColor write FShadowColor default clBlack;
    property ShadowWidth: Extended read FShadowWidth write FShadowWidth stored IsShadowWidthStored;
    property Style: TfrxFrameStyle read FStyle write SetStyle default fsSolid;
    property Typ: TfrxFrameTypes read FTyp write FTyp stored IsTypStored;
    property Width: Extended read FWidth write SetWidth stored IsWidthStored;
    property LeftLine: TfrxFrameLine read FLeftLine write SetLeftLine;
    property TopLine: TfrxFrameLine read FTopLine write SetTopLine;
    property RightLine: TfrxFrameLine read FRightLine write SetRightLine;
    property BottomLine: TfrxFrameLine read FBottomLine write SetBottomLine;
  end;



//  TfrxWatermark = class(TPersistent)
//  private
//    FVisibility: TfrxVisibilityTypes;
//    FTextFont: TFont;
//    FImage:
//    FImageTransparentColor
//    FShowImageOnTop
//    ShowTextOnTop
//    Text
//    TextFill
//    TextRotation
//
//  Visible
//Font
//Image
//ImageTransparentColor
//ShowImageOnTop
//ShowTextOnTop
//Text
//TextFill
//TextRotation
//  end;

  TfrxView = class(TfrxReportComponent)
  private
    FAlign: TfrxAlign;
    FCursor: TCursor;
    FDataField: String;
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    FFrame: TfrxFrame;
    FShiftMode: TfrxShiftMode;
    FTagStr: String;
    FTempTag: String;
    FTempHyperlink: String;
    FHint: String;
    FShowHint: Boolean;
    FURL: String;
    FPlainText: Boolean;
    FHyperlink: TfrxHyperlink;
    FFill: TfrxCustomFill;
    FVisibility: TfrxVisibilityTypes;
    FDrawAsMask: Boolean;
    FAllowVectorExport: Boolean;
    {  interactive script events  }
    FOnMouseEnter: TfrxMouseEnterViewEvent;
    FOnMouseLeave: TfrxMouseLeaveViewEvent;
    FOnMouseDown: TfrxMouseEvent;
    FOnMouseMove: TfrxMouseMoveEvent;
    FOnMouseUp: TfrxMouseEvent;
    procedure SetFrame(const Value: TfrxFrame);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
    procedure SetFillType(const Value: TfrxFillType);
    function GetFillType: TfrxFillType;
    procedure SetBrushStyle(const Value: TBrushStyle);
    function GetBrushStyle: TBrushStyle;
    procedure SetColor(const Value: TColor);
    function GetColor: TColor;
    procedure SetHyperLink(const Value: TfrxHyperlink);
    procedure SetFill(const Value: TfrxCustomFill);
    procedure SetURL(const Value: String);
    function GetPrintable: Boolean;
    procedure SetPrintable(Value: Boolean);
    procedure SetProcessing(const Value: TfrxObjectProcessing);
  protected
    FX: Integer;
    FY: Integer;
    FX1: Integer;
    FY1: Integer;
    FDX: Integer;
    FDY: Integer;
    FFrameWidth: Integer;
    FScaleX: Extended;
    FScaleY: Extended;
    FOffsetX: Extended;
    FOffsetY: Extended;
    FCanvas: TCanvas;
    FProcessing: TfrxObjectProcessing;
    FObjAsMetafile: Boolean;
    FDrawFillOnMetaFile: Boolean;
    FVC: TVectorCanvas;
    procedure BeginDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); virtual;
    procedure DrawBackground; virtual;
    procedure DrawFrame; virtual;
    procedure DrawFrameEdges;
    procedure DrawLine(x, y, x1, y1, w: Integer);
    procedure ExpandVariables(var Expr: String);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure GetScreenScale(var aScaleX, aScaleY: Extended);
    { interactive object behaviour }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Diff(AComponent: TfrxComponent): String; override;
    function IsDataField: Boolean;
    function IsEMFExportable: Boolean; virtual;
    function IsAcceptAsChild(aParent: TfrxComponent): Boolean; override;
    function GetVectorGraphic(DrawFill: Boolean = False): TGraphic; virtual;
    function GetVectorCanvas: TVectorCanvas; virtual;
    procedure DrawHighlight(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended; hlColor: TColor = clNone); override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure DrawClipped(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); virtual;
    procedure BeforePrint; override;
    procedure GetData; override;
    procedure GetScaleFactor(var ScaleX: Extended; var ScaleY: Extended); virtual;
    procedure MirrorContent(MirrorModes: TfrxMirrorControlModes); override;

    procedure AfterPrint; override;
    function ShadowSize: Extended; // In order to not test DropShadow every time
    function GetExportBounds: TfrxRect; virtual; // 0


    { post processing interfaces }
    procedure SaveContentToDictionary(aReport: TfrxReport; PostProcessor: TfrxPostProcessor); virtual;
    function LoadContentFromDictionary(aReport: TfrxReport; aItem: TfrxMacrosItem): Boolean; virtual;
    procedure ProcessDictionary(aItem: TfrxMacrosItem; aReport: TfrxReport; PostProcessor: TfrxPostProcessor); virtual;
    function IsPostProcessAllowed: Boolean; virtual;
    { end post process interfaces}

    property FillType: TfrxFillType read GetFillType write SetFillType default ftBrush;
    property Fill: TfrxCustomFill read FFill write SetFill;
    property BrushStyle: TBrushStyle read GetBrushStyle write SetBrushStyle stored False;
    property Color: TColor read GetColor write SetColor stored False;
    property DataField: String read FDataField write FDataField;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property Frame: TfrxFrame read FFrame write SetFrame;
    property PlainText: Boolean read FPlainText write FPlainText;
    property Cursor: TCursor read FCursor write FCursor default crDefault;
    property TagStr: String read FTagStr write FTagStr;
    property URL: String read FURL write SetURL stored False;
    property DrawAsMask: Boolean read FDrawAsMask write FDrawAsMask;
    property Processing: TfrxObjectProcessing read FProcessing write SetProcessing;
  published
    property Anchors;
    property Align: TfrxAlign read FAlign write FAlign default baNone;
    property AllowVectorExport: Boolean read FAllowVectorExport write FAllowVectorExport;
    property Printable: Boolean read GetPrintable write SetPrintable stored False default True;
    property ShiftMode: TfrxShiftMode read FShiftMode write FShiftMode default smAlways;
    property Left;
    property Top;
    property Width;
    property Height;
    property GroupIndex;
    property Restrictions;
    property Visible;
    property OnAfterData;
    property OnAfterPrint;
    property OnBeforePrint;
    property OnContentChanged;
    property OnMouseEnter: TfrxMouseEnterViewEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TfrxMouseLeaveViewEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseDown: TfrxMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TfrxMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TfrxMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnPreviewClick;
    property OnPreviewDblClick;
    property Hyperlink: TfrxHyperlink read FHyperlink write SetHyperLink;
    property Hint: String read FHint write FHint;
    property ShowHint: Boolean read FShowHint write FShowHint default False;
    property Visibility: TfrxVisibilityTypes read FVisibility write FVisibility default [vsPreview, vsExport, vsPrint];
  end;

  TfrxStretcheable = class(TfrxView)
  private
    FStretchMode: TfrxStretchMode;
    FCanShrink: Boolean;
  public
    FSaveHeight: Extended;
    FSavedTop: Extended;
    constructor Create(AOwner: TComponent); override;
    function CalcHeight: Extended; virtual;
    function DrawPart: Extended; virtual;
    procedure InitPart; virtual;
    function HasNextDataPart(aFreeSpace: Extended): Boolean; virtual;
  published
    property CanShrink: Boolean read FCanShrink write FCanShrink default False;
    property StretchMode: TfrxStretchMode read FStretchMode write FStretchMode
      default smDontStretch;
  end;

  TfrxInteractiveHighlightEvent = (ihNone, ihClick, ihEnter, ieLeave);

  TfrxHighlight = class(TfrxCollectionItem)
  private
    FActive: Boolean;
    FApplyFont: Boolean;
    FApplyFill: Boolean;
    FApplyFrame: Boolean;
    FCondition: String;
    FFont: TFont;
    FFill: TfrxCustomFill;
    FFrame: TfrxFrame;
    FVisible: Boolean;
    FInteractiveType: TfrxInteractiveHighlightEvent;
    procedure SetFont(const Value: TFont);
    procedure SetFill(const Value: TfrxCustomFill);
    procedure SetFillType(const Value: TfrxFillType);
    function GetFillType: TfrxFillType;
    procedure SetColor(const Value: TColor);
    function GetColor: TColor;
    procedure SetFrame(const Value: TfrxFrame);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function IsUniqueNameStored: Boolean; override;
  published
    // backward compatibility
    property Active: Boolean read FActive write FActive stored False default False;
    property ApplyFont: Boolean read FApplyFont write FApplyFont default True;
    property ApplyFill: Boolean read FApplyFill write FApplyFill default True;
    property ApplyFrame: Boolean read FApplyFrame write FApplyFrame default False;
    property Font: TFont read FFont write SetFont;
    // backward compatibility
    property Color: TColor read GetColor write SetColor stored False default clNone;
    property Condition: String read FCondition write FCondition;
    property InteractiveType: TfrxInteractiveHighlightEvent read FInteractiveType write FInteractiveType default ihNone;
 	  property FillType: TfrxFillType read GetFillType write SetFillType;
    property Fill: TfrxCustomFill read FFill write SetFill;
    property Frame: TfrxFrame read FFrame write SetFrame;
    property Visible: Boolean read FVisible write FVisible default True;
  end;

  TfrxHighlightCollection = class(TfrxCollection)
  private
    function GetItem(Index: Integer): TfrxHighlight;
  public
    constructor Create;
    property Items[Index: Integer]: TfrxHighlight read GetItem; default;
  end;

  TfrxFormat = class(TCollectionItem)
  private
    FDecimalSeparator: String;
    FThousandSeparator: String;
    FFormatStr: String;
    FKind: TfrxFormatKind;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property DecimalSeparator: String read FDecimalSeparator write FDecimalSeparator;
    property ThousandSeparator: String read FThousandSeparator write FThousandSeparator;
    property FormatStr: String read FFormatStr write FFormatStr;
    property Kind: TfrxFormatKind read FKind write FKind default fkText;
  end;

  TfrxFormatCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TfrxFormat;
  public
    constructor Create;
    property Items[Index: Integer]: TfrxFormat read GetItem; default;
  end;

  TfrxCustomMemoView = class(TfrxStretcheable)
  private
    FAllowExpressions: Boolean;
    FAllowHTMLTags: Boolean;
    FAutoWidth: Boolean;
    FCharSpacing: Extended;
    FClipped: Boolean;
    FFormats: TfrxFormatCollection;
    FExpressionDelimiters: String;
    FFlowTo: TfrxCustomMemoView;
    FFirstParaBreak: Boolean;
    FGapX: Extended;
    FGapY: Extended;
    FHAlign: TfrxHAlign;
    FHideZeros: Boolean;
    FHighlights: TfrxHighlightCollection;
    FLastParaBreak: Boolean;
    FLineSpacing: Extended;
    FMemo: TWideStrings;
    FParagraphGap: Extended;
    FPartMemo: WideString;
    FRotation: Integer;
    FRTLReading: Boolean;
    FStyle: String;
    FSuppressRepeated: Boolean;
    FDuplicates: TfrxDuplicateMerge;

    FTempMemo: WideString;
    FUnderlinesTextMode: TfrxUnderlinesTextMode;
    FVAlign: TfrxVAlign;
    FValue: Variant;
    FWordBreak: Boolean;
    FWordWrap: Boolean;
    FWysiwyg: Boolean;
    FUseDefaultCharset: Boolean;
    FHighlightActivated: Boolean;
    FTempFill: TfrxCustomFill;
    FTempFont: TFont;
    FTempFrame: TfrxFrame;
    FTempVisible: Boolean;
    FScaledRect: TRect;
    FMacroLoaded: Boolean;
    procedure SetMemo(const Value: TWideStrings);
    procedure SetRotation(Value: Integer);
    procedure SetText(const Value: WideString);
    procedure SetAnsiText(const Value: AnsiString);
    function AdjustCalcHeight: Extended;
    function AdjustCalcWidth: Extended;
    function GetText: WideString;
    function GetAnsiText: AnsiString;
    function IsExprDelimitersStored: Boolean;
    function IsLineSpacingStored: Boolean;
    function IsGapXStored: Boolean;
    function IsGapYStored: Boolean;
    function IsHighlightStored: Boolean;
    function IsDisplayFormatStored: Boolean;
    function IsParagraphGapStored: Boolean;
    function GetHighlight: TfrxHighlight;
    function GetDisplayFormat: TfrxFormat;
    procedure SetHighlight(const Value: TfrxHighlight);
    procedure SetDisplayFormat(const Value: TfrxFormat);
    procedure SetStyle(const Value: String);
    function IsCharSpacingStored: Boolean;
    procedure WriteFormats(Writer: TWriter);
    procedure WriteHighlights(Writer: TWriter);
    procedure ReadFormats(Reader: TReader);
    procedure ReadHighlights(Reader: TReader);
    procedure SavePreHighlightState;
    procedure RestorePreHighlightState;
    function GetUnderlines: Boolean;
    procedure SetUnderlines(const Value: Boolean);
  protected
    FLastValue: Variant;
    FTotalPages: Integer;
    FCopyNo: Integer;
    FTextRect: TRect;
    FPrintScale: Extended;
    FMacroIndex: Integer;
    FMacroLine: Integer;
    procedure Loaded; override;
    function CalcAndFormat(const Expr: WideString; Format: TfrxFormat): WideString;
    function CalcTextRect(OffsetX, OffsetY, ScaleX, ScaleY: Extended): TRect;

    procedure BeginDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure SetDrawParams(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
    procedure DrawText;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function Diff(AComponent: TfrxComponent): String; override;
    function CalcHeight: Extended; override;
    function CalcWidth: Extended; virtual;
    function DrawPart: Extended; override;
    procedure WriteNestedProperties(Item: TfrxXmlItem; aAcenstor: TPersistent = nil); override;
    function ReadNestedProperty(Item: TfrxXmlItem): Boolean; override;
    procedure ApplyPreviewHighlight;

    procedure SaveContentToDictionary(aReport: TfrxReport; PostProcessor: TfrxPostProcessor); override;
    function LoadContentFromDictionary(aReport: TfrxReport; aItem: TfrxMacrosItem): Boolean; override;
    procedure ProcessDictionary(aItem: TfrxMacrosItem; aReport: TfrxReport; PostProcessor: TfrxPostProcessor); override;
    function IsPostProcessAllowed: Boolean; override;

    { interactive object behaviour }
    procedure DoMouseEnter(aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseLeave(aNextObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams); override;

    procedure MirrorContent(MirrorModes: TfrxMirrorControlModes); override;
    function GetComponentText: String; override;
    function FormatData(const Value: Variant; AFormat: TfrxFormat = nil): WideString;
    // when aParaText is not nil function fills stringlist with paragraph indents in Objects property
    // 1 - begin of paragraph, 2 - end of paragraph, 3 -  both begin and end at one line, 0 - continue of paragraph
    function WrapText(WrapWords: Boolean; aParaText: TWideStrings = nil): WideString;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure BeforePrint; override;
    procedure GetData; override;
    procedure AfterPrint; override;
    procedure InitPart; override;
    procedure ApplyStyle(Style: TfrxStyleItem);
    procedure ApplyHighlight(AHighlight: TfrxHighlight);
    procedure ExtractMacros(Dictionary: TfrxPostProcessor = nil);
    procedure ResetSuppress;
    function ReducedAngle: Integer; // 0..359
    property Text: WideString read GetText write SetText;
    property AnsiText: AnsiString read GetAnsiText write SetAnsiText;
    property Value: Variant read FValue write FValue;
    // analogue of Memo property
    property Lines: TWideStrings read FMemo write SetMemo;

    property AllowExpressions: Boolean read FAllowExpressions write FAllowExpressions default True;
    property AllowHTMLTags: Boolean read FAllowHTMLTags write FAllowHTMLTags default False;
    property AutoWidth: Boolean read FAutoWidth write FAutoWidth default False;
    property CharSpacing: Extended read FCharSpacing write FCharSpacing stored IsCharSpacingStored;
    property Clipped: Boolean read FClipped write FClipped default True;
    property DisplayFormat: TfrxFormat read GetDisplayFormat write SetDisplayFormat stored IsDisplayFormatStored;
    property ExpressionDelimiters: String read FExpressionDelimiters
      write FExpressionDelimiters stored IsExprDelimitersStored;
    property FlowTo: TfrxCustomMemoView read FFlowTo write FFlowTo;
    property GapX: Extended read FGapX write FGapX stored IsGapXStored;
    property GapY: Extended read FGapY write FGapY stored IsGapYStored;
    property HAlign: TfrxHAlign read FHAlign write FHAlign default haLeft;
    property HideZeros: Boolean read FHideZeros write FHideZeros default False;
    property Highlight: TfrxHighlight read GetHighlight write SetHighlight stored IsHighlightStored;
    property LineSpacing: Extended read FLineSpacing write FLineSpacing stored IsLineSpacingStored;
    property Memo: TWideStrings read FMemo write SetMemo;
    property ParagraphGap: Extended read FParagraphGap write FParagraphGap stored IsParagraphGapStored;
    property Rotation: Integer read FRotation write SetRotation default 0;
    property RTLReading: Boolean read FRTLReading write FRTLReading default False;
    property Style: String read FStyle write SetStyle;
    property SuppressRepeated: Boolean read FSuppressRepeated write FSuppressRepeated default False;
    property Duplicates: TfrxDuplicateMerge read FDuplicates write FDuplicates default dmShow;
    property Underlines: Boolean read GetUnderlines write SetUnderlines default False;
    property UnderlinesTextMode: TfrxUnderlinesTextMode read FUnderlinesTextMode write FUnderlinesTextMode default ulmNone;
    property WordBreak: Boolean read FWordBreak write FWordBreak default False;
    property WordWrap: Boolean read FWordWrap write FWordWrap default True;
    property Wysiwyg: Boolean read FWysiwyg write FWysiwyg default True;
    property VAlign: TfrxVAlign read FVAlign write FVAlign default vaTop;
    property UseDefaultCharset: Boolean read FUseDefaultCharset write FUseDefaultCharset default False;
    property Highlights: TfrxHighlightCollection read FHighlights;
    property Formats: TfrxFormatCollection read FFormats;
  published
    property FirstParaBreak: Boolean read FFirstParaBreak write FFirstParaBreak default False;
    property LastParaBreak: Boolean read FLastParaBreak write FLastParaBreak default False;
    property Cursor;
    property TagStr;
    property URL;
  end;

  TfrxMemoView = class(TfrxCustomMemoView)
  published
    property AutoWidth;
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
    property FlowTo;
    property Font;
    property Frame;
    property FillType;
    property Fill;
    property GapX;
    property GapY;
    property HAlign;
    property HideZeros;
    property Highlight;
    property LineSpacing;
    property Memo;
    property ParagraphGap;
    property ParentFont;
    property Processing;
    property Rotation;
    property RTLReading;
    property Style;
    property SuppressRepeated;
    property Duplicates;
    property Underlines;
    property UnderlinesTextMode;
    property UseDefaultCharset;
    property WordBreak;
    property WordWrap;
    property Wysiwyg;
    property VAlign;
  end;

  TfrxSysMemoView = class(TfrxCustomMemoView)
  public
    class function GetDescription: String; override;
  published
    property AutoWidth;
    property CharSpacing;
    property Color;
    property DisplayFormat;
    property Font;
    property Frame;
    property FillType;
    property Fill;
    property GapX;
    property GapY;
    property HAlign;
    property HideZeros;
    property Highlight;
    property Memo;
    property ParentFont;
    property Rotation;
    property RTLReading;
    property Style;
    property SuppressRepeated;
    property Duplicates;
    property VAlign;
    property WordWrap;
  end;

  TfrxCustomLineView = class(TfrxStretcheable)
  private
    FColor: TColor;
    FDiagonal: Boolean;
    FArrowEnd: Boolean;
    FArrowLength: Integer;
    FArrowSolid: Boolean;
    FArrowStart: Boolean;
    FArrowWidth: Integer;
    procedure DrawArrow(x1, y1, x2, y2: Extended);
    procedure DrawDiagonalLine;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    function GetVectorGraphic(DrawFill: Boolean = False): TGraphic; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    function IsContain(X, Y: Extended): Boolean; override;
    function IsInRect(const aRect: TfrxRect): Boolean; override;
    property ArrowEnd: Boolean read FArrowEnd write FArrowEnd default False;
    property ArrowLength: Integer read FArrowLength write FArrowLength default 20;
    property ArrowSolid: Boolean read FArrowSolid write FArrowSolid default False;
    property ArrowStart: Boolean read FArrowStart write FArrowStart default False;
    property ArrowWidth: Integer read FArrowWidth write FArrowWidth default 5;
    property Diagonal: Boolean read FDiagonal write FDiagonal default False;
  published
    property Color: TColor read FColor write FColor default clNone;
    property TagStr;
  end;

  TfrxLineView = class(TfrxCustomLineView)
  public
    class function GetDescription: String; override;
  published
    property ArrowEnd;
    property ArrowLength;
    property ArrowSolid;
    property ArrowStart;
    property ArrowWidth;
    property Frame;
    property Diagonal;
  end;

  TfrxPictureView = class(TfrxView)
  private
    FAutoSize: Boolean;
    FCenter: Boolean;
    FFileLink: String;
    FImageIndex: Integer;
    FIsImageIndexStored: Boolean;
    FIsPictureStored: Boolean;
    FKeepAspectRatio: Boolean;
    FPicture: TPicture;
    FPictureChanged: Boolean;
    FStretched: Boolean;
    FHightQuality: Boolean;
    FTransparent: Boolean;
    FTransparentColor: TColor;
    procedure SetPicture(const Value: TPicture);
    procedure PictureChanged(Sender: TObject);
    procedure SetAutoSize(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function Diff(AComponent: TfrxComponent):String; override;
    function LoadPictureFromStream(s: TStream; ResetStreamPos: Boolean = True): HResult;
    function IsEMFExportable: Boolean; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;

    procedure GetData; override;
    property IsImageIndexStored: Boolean read FIsImageIndexStored write FIsImageIndexStored;
    property IsPictureStored: Boolean read FIsPictureStored write FIsPictureStored;
  published
    property Cursor;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Center: Boolean read FCenter write FCenter default False;
    property DataField;
    property DataSet;
    property DataSetName;
    property Frame;
    property FillType;
    property Fill;
    property FileLink: String read FFileLink write FFileLink;
    property ImageIndex: Integer read FImageIndex write FImageIndex stored FIsImageIndexStored;
    property KeepAspectRatio: Boolean read FKeepAspectRatio write FKeepAspectRatio default True;
    property Picture: TPicture read FPicture write SetPicture stored FIsPictureStored;
    property Stretched: Boolean read FStretched write FStretched default True;
    property TagStr;
    property URL;
    property HightQuality: Boolean read FHightQuality write FHightQuality;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property TransparentColor: TColor read FTransparentColor write FTransparentColor;
  end;

  TfrxShapeView = class(TfrxView)
  private
    FCurve: Integer;
    FShape: TfrxShapeKind;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    function Diff(AComponent: TfrxComponent): String; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;

    class function GetDescription: String; override;
  published
    property Color;
    property Cursor;
    property Curve: Integer read FCurve write FCurve default 0;
    property FillType;
    property Fill;
    property Frame;
    property Shape: TfrxShapeKind read FShape write FShape default skRectangle;
    property TagStr;
    property URL;
  end;

  TfrxSubreport = class(TfrxView)
  private
    FPage: TfrxReportPage;
    FPrintOnParent: Boolean;
    procedure SetPage(const Value: TfrxReportPage);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    class function GetDescription: String; override;
  published
    property Page: TfrxReportPage read FPage write SetPage;
    property PrintOnParent: Boolean read FPrintOnParent write FPrintOnParent
      default False;
  end;


{ Bands }
  TfrxChild = class;

  TfrxBand = class(TfrxReportComponent)
  private
    FAllowSplit: Boolean;
    FChild: TfrxChild;
    FKeepChild: Boolean;
    FOnAfterCalcHeight: TfrxNotifyEvent;
    FOutlineText: String;
    FOverflow: Boolean;
    FStartNewPage: Boolean;
    FStretched: Boolean;
    FPrintChildIfInvisible: Boolean;
    FVertical: Boolean;
    FFill: TfrxCustomFill;
    FFillType: TfrxFillType;
    FFillMemo: TfrxMemoView;
    FFillgap: TfrxFillGaps;
    FFrame: TfrxFrame;
    FBandDesignHeader: Extended;
    FShiftEngine: TfrxShiftEngine;
    function GetBandName: String;
    procedure SetChild(Value: TfrxChild);
    procedure SetVertical(const Value: Boolean);
    procedure SetFill(const Value: TfrxCustomFill);
    procedure SetFillType(const Value: TfrxFillType);
    procedure SetFrame(const Value: TfrxFrame);
  protected
    function GetBandTitleColor: TColor; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetLeft(Value: Extended); override;
    procedure SetTop(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
  public
    FSubBands: TList;                    { list of subbands }
    FHeader, FFooter, FGroup: TfrxBand;  { h./f./g. bands   }
    FLineN: Integer;                     { used for Line#   }
    FLineThrough: Integer;               { used for LineThrough#   }
    FHasVBands: Boolean;                 { whether the band should show vbands }
    FStretchedHeight: Extended;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function BandNumber: Integer;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure CreateFillMemo();
    procedure DisposeFillMemo();
    class function GetDescription: String; override;
    function IsContain(X, Y: Extended): Boolean; override;
    function GetContainedComponent(X, Y: Extended; IsCanContain: TfrxComponent = nil): TfrxComponent; override;
    property AllowSplit: Boolean read FAllowSplit write FAllowSplit default False;
    property BandName: String read GetBandName;
    property BandDesignHeader: Extended read FBandDesignHeader write FBandDesignHeader;
    property Child: TfrxChild read FChild write SetChild;
    property KeepChild: Boolean read FKeepChild write FKeepChild default False;
    property OutlineText: String read FOutlineText write FOutlineText;
    property Overflow: Boolean read FOverflow write FOverflow;
    property PrintChildIfInvisible: Boolean read FPrintChildIfInvisible
      write FPrintChildIfInvisible default False;
    property StartNewPage: Boolean read FStartNewPage write FStartNewPage default False;
    property Stretched: Boolean read FStretched write FStretched default False;
    { make IContainer Interface and move some base properties set/get to it }
    property ShiftEngine: TfrxShiftEngine read FShiftEngine write FShiftEngine default seTree;
  published
    property FillType: TfrxFillType read FFillType write SetFillType;
    property Fill: TfrxCustomFill read FFill write SetFill;
    property FillGap: TfrxFillGaps read FFillGap;
    property Frame: TfrxFrame read FFrame write SetFrame;
    property Font;
    property Height;
    property Left;
    property ParentFont;
    property Restrictions;
    property Top;
    property Vertical: Boolean read FVertical write SetVertical default False;
    property Visible;
    property Width;
    property OnAfterCalcHeight: TfrxNotifyEvent read FOnAfterCalcHeight
      write FOnAfterCalcHeight;
    property OnAfterPrint;
    property OnBeforePrint;
  end;

  TfrxBandClass = class of TfrxBand;

  TfrxToNRowsMode = (rmCount, rmAddToCount, rmTillPageEnds);

  TfrxDataBand = class(TfrxBand)
  private
    FColumnGap: Extended;
    FColumnWidth: Extended;
    FColumns: Integer;
    FCurColumn: Integer;
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    FFilter: String;
    FFooterAfterEach: Boolean;
    FKeepFooter: Boolean;
    FKeepHeader: Boolean;
    FKeepTogether: Boolean;
    FPrintIfDetailEmpty: Boolean;
    FRowCount: Integer;
    FOnMasterDetail: TfrxNotifyEvent;
    FVirtualDataSet: TfrxUserDataSet;
    procedure SetCurColumn(Value: Integer);
    procedure SetRowCount(const Value: Integer);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
  protected
    function GetBandTitleColor: TColor; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    FMaxY: Extended;                             { used for columns }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    class function GetDescription: String; override;
    property CurColumn: Integer read FCurColumn write SetCurColumn;
    property VirtualDataSet: TfrxUserDataSet read FVirtualDataSet;
  published
    property AllowSplit;
    property Child;
    property Columns: Integer read FColumns write FColumns default 0;
    property ColumnWidth: Extended read FColumnWidth write FColumnWidth;
    property ColumnGap: Extended read FColumnGap write FColumnGap;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property FooterAfterEach: Boolean read FFooterAfterEach write FFooterAfterEach default False;
    property Filter: String read FFilter write FFilter;
    property KeepChild;
    property KeepFooter: Boolean read FKeepFooter write FKeepFooter default False;
    property KeepHeader: Boolean read FKeepHeader write FKeepHeader default False;
    property KeepTogether: Boolean read FKeepTogether write FKeepTogether default False;
    property OutlineText;
    property PrintChildIfInvisible;
    property PrintIfDetailEmpty: Boolean read FPrintIfDetailEmpty
      write FPrintIfDetailEmpty default False;
    property RowCount: Integer read FRowCount write SetRowCount;
    property StartNewPage;
    property Stretched;
    property ShiftEngine;
    property OnMasterDetail: TfrxNotifyEvent read FOnMasterDetail write FOnMasterDetail;
  end;

  TfrxHeader = class(TfrxBand)
  private
    FReprintOnNewPage: Boolean;
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property ReprintOnNewPage: Boolean read FReprintOnNewPage write FReprintOnNewPage default False;
    property StartNewPage;
    property Stretched;
    property ShiftEngine;
  end;

  TfrxFooter = class(TfrxBand)
  private
  public
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property Stretched;
    property ShiftEngine;
  end;

  TfrxMasterData = class(TfrxDataBand)
  private
  public
  published
  end;

  TfrxDetailData = class(TfrxDataBand)
  private
  public
  published
  end;

  TfrxSubdetailData = class(TfrxDataBand)
  private
  public
  published
  end;

  TfrxDataBand4 = class(TfrxDataBand)
  private
  public
  published
  end;

  TfrxDataBand5 = class(TfrxDataBand)
  private
  public
  published
  end;

  TfrxDataBand6 = class(TfrxDataBand)
  private
  public
  published
  end;

  TfrxPageHeader = class(TfrxBand)
  private
    FPrintOnFirstPage: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Child;
    property PrintChildIfInvisible;
    property PrintOnFirstPage: Boolean read FPrintOnFirstPage write FPrintOnFirstPage default True;
    property Stretched;
    property ShiftEngine;
  end;

  TfrxPageFooter = class(TfrxBand)
  private
    FPrintOnFirstPage: Boolean;
    FPrintOnLastPage: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property PrintOnFirstPage: Boolean read FPrintOnFirstPage write FPrintOnFirstPage default True;
    property PrintOnLastPage: Boolean read FPrintOnLastPage write FPrintOnLastPage default True;
  end;

  TfrxColumnHeader = class(TfrxBand)
  private
  public
  published
    property Child;
    property Stretched;
    property ShiftEngine;
  end;

  TfrxColumnFooter = class(TfrxBand)
  private
  public
  published
  end;

  TfrxGroupHeader = class(TfrxBand)
  private
    FCondition: String;
    FDrillName: String;               { used instead Tag property in drill down }
    FDrillDown: Boolean;
    FExpandDrillDown: Boolean;
    FShowFooterIfDrillDown: Boolean;
    FShowChildIfDrillDown: Boolean;
    FKeepTogether: Boolean;
    FReprintOnNewPage: Boolean;
    FResetPageNumbers: Boolean;
  public
    FLastValue: Variant;
    function Diff(AComponent: TfrxComponent): String; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
  published
    property AllowSplit;
    property Child;
    property Condition: String read FCondition write FCondition;
    property DrillDown: Boolean read FDrillDown write FDrillDown default False;
    property ExpandDrillDown: Boolean read FExpandDrillDown write FExpandDrillDown default False;
    property KeepChild;
    property KeepTogether: Boolean read FKeepTogether write FKeepTogether default False;
    property ReprintOnNewPage: Boolean read FReprintOnNewPage write FReprintOnNewPage default False;
    property OutlineText;
    property PrintChildIfInvisible;
    property ResetPageNumbers: Boolean read FResetPageNumbers write FResetPageNumbers default False;
    property ShowFooterIfDrillDown: Boolean read FShowFooterIfDrillDown
      write FShowFooterIfDrillDown default False;
    property ShowChildIfDrillDown: Boolean read FShowChildIfDrillDown
      write FShowChildIfDrillDown default False;
    property StartNewPage;
    property Stretched;
    property ShiftEngine;
    property DrillName: String read FDrillName write FDrillName;
  end;

  TfrxGroupFooter = class(TfrxBand)
  private
    FHideIfSingleDataRecord: Boolean;
  public
  published
    property AllowSplit;
    property Child;
    property HideIfSingleDataRecord: Boolean read FHideIfSingleDataRecord
      write FHideIfSingleDataRecord default False;
    property KeepChild;
    property PrintChildIfInvisible;
    property Stretched;
    property ShiftEngine;
  end;

  TfrxReportTitle = class(TfrxBand)
  private
  public
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property StartNewPage;
    property Stretched;
    property ShiftEngine;
  end;

  TfrxReportSummary = class(TfrxBand)
  private
  public
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property StartNewPage;
    property Stretched;
    property ShiftEngine;
  end;

  TfrxChild = class(TfrxBand)
  private
    FToNRows: Integer;
    FToNRowsMode: TfrxToNRowsMode;
  public
  published
    property AllowSplit;
    property Child;
    property KeepChild;
    property PrintChildIfInvisible;
    property StartNewPage;
    property Stretched;
    property ShiftEngine;
    property ToNRows: Integer read FToNRows write FToNRows;
    property ToNRowsMode: TfrxToNRowsMode read FToNRowsMode write FToNRowsMode;
  end;

  TfrxOverlay = class(TfrxBand)
  private
    FPrintOnTop: Boolean;
  public
  published
    property PrintOnTop: Boolean read FPrintOnTop write FPrintOnTop default False;
  end;

  TfrxNullBand = class(TfrxBand);


{ Pages }

  TfrxPage = class(TfrxComponent)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); virtual;
  published
    property Font;
    property Visible;
  end;

  TfrxReportPage = class(TfrxPage)
  private
    FBackPicture: TfrxPictureView;
    FBin: Integer;
    FBinOtherPages: Integer;
    FBottomMargin: Extended;
    FColumns: Integer;
    FColumnWidth: Extended;
    FColumnPositions: TStrings;
    FDataSet: TfrxDataSet;
    FDuplex: TfrxDuplexMode;
    FEndlessHeight: Boolean;
    FEndlessWidth: Boolean;
    FHGuides: TStrings;
    FLargeDesignHeight: Boolean;
    FLeftMargin: Extended;
    FMirrorMargins: Boolean;
    FOrientation: TPrinterOrientation;
    FOutlineText: String;
    FPrintIfEmpty: Boolean;
    FPrintOnPreviousPage: Boolean;
    FResetPageNumbers: Boolean;
    FRightMargin: Extended;
    FSubReport: TfrxSubreport;
    FTitleBeforeHeader: Boolean;
    FTopMargin: Extended;
    FVGuides: TStrings;
    FOnAfterPrint: TfrxNotifyEvent;
    FOnBeforePrint: TfrxNotifyEvent;
    FOnManualBuild: TfrxNotifyEvent;
    FDataSetName: String;
    FBackPictureVisible: Boolean;
    FBackPicturePrintable: Boolean;
    FBackPictureStretched: Boolean;
    FPageCount: Integer;
    FShowTitleOnPreviousPage: Boolean;
    FReport: TfrxReport;
    FMirrorMode: TfrxMirrorControlModes;
    procedure SetPageCount(const Value: Integer);
    procedure SetColumns(const Value: Integer);
    procedure SetOrientation(Value: TPrinterOrientation);
    procedure SetHGuides(const Value: TStrings);
    procedure SetVGuides(const Value: TStrings);
    procedure SetColumnPositions(const Value: TStrings);
    procedure SetFrame(const Value: TfrxFrame);
    function GetFrame: TfrxFrame;
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    function GetBackPicture: TPicture;
    procedure SetBackPicture(const Value: TPicture);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
  protected
    FPaperHeight: Extended;
    FPaperSize: Integer;
    FPaperWidth: Extended;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetPaperHeight(const Value: Extended); virtual;
    procedure SetPaperWidth(const Value: Extended); virtual;
    procedure SetPaperSize(const Value: Integer); virtual;
    procedure UpdateDimensions;
  public
    FSubBands: TList;   { list of master bands }
    FVSubBands: TList;  { list of vertical master bands }
    constructor Create(AOwner: TComponent); overload; override;
    { C++ Builder doesn't support constructor names , use parameters}
    constructor CreateInPreview(AOwner: TComponent; AReport: TfrxReport); overload;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function FindBand(Band: TfrxBandClass): TfrxBand;
    function IsSubReport: Boolean;
    procedure AlignChildren(IgnoreInvisible: Boolean = False; MirrorModes: TfrxMirrorControlModes = []); override;
    procedure ClearGuides;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure SetDefaults; virtual;
    procedure SetSizeAndDimensions(ASize: Integer; AWidth, AHeight: Extended);
    property SubReport: TfrxSubreport read FSubReport;
    property ParentReport: TfrxReport read FReport;
  published
    { paper }
    property Orientation: TPrinterOrientation read FOrientation
      write SetOrientation default poPortrait;
    property PaperWidth: Extended read FPaperWidth write SetPaperWidth;
    property PaperHeight: Extended read FPaperHeight write SetPaperHeight;
    property PaperSize: Integer read FPaperSize write SetPaperSize;
    { margins }
    property LeftMargin: Extended read FLeftMargin write FLeftMargin;
    property RightMargin: Extended read FRightMargin write FRightMargin;
    property TopMargin: Extended read FTopMargin write FTopMargin;
    property BottomMargin: Extended read FBottomMargin write FBottomMargin;
    property MirrorMargins: Boolean read FMirrorMargins write FMirrorMargins
      default False;
    { columns }
    property Columns: Integer read FColumns write SetColumns default 0;
    property ColumnWidth: Extended read FColumnWidth write FColumnWidth;
    property ColumnPositions: TStrings read FColumnPositions write SetColumnPositions;
    { bins }
    property Bin: Integer read FBin write FBin default DMBIN_AUTO;
    property BinOtherPages: Integer read FBinOtherPages write FBinOtherPages
      default DMBIN_AUTO;
    { other }
    property BackPicture: TPicture read GetBackPicture write SetBackPicture;
    property BackPictureVisible: Boolean read FBackPictureVisible write FBackPictureVisible default True;
    property BackPicturePrintable: Boolean read FBackPicturePrintable write FBackPicturePrintable default True;
    property BackPictureStretched: Boolean read FBackPictureStretched write FBackPictureStretched default True;
    property PageCount: Integer read FPageCount write SetPageCount default 1;
    property Color: TColor read GetColor write SetColor default clNone;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property Duplex: TfrxDuplexMode read FDuplex write FDuplex default dmNone;
    property Frame: TfrxFrame read GetFrame write SetFrame;
    property EndlessHeight: Boolean read FEndlessHeight write FEndlessHeight default False;
    property EndlessWidth: Boolean read FEndlessWidth write FEndlessWidth default False;
    property LargeDesignHeight: Boolean read FLargeDesignHeight
      write FLargeDesignHeight default False;
    property MirrorMode: TfrxMirrorControlModes read FMirrorMode write FMirrorMode;
    property OutlineText: String read FOutlineText write FOutlineText;
    property PrintIfEmpty: Boolean read FPrintIfEmpty write FPrintIfEmpty default True;
    property PrintOnPreviousPage: Boolean read FPrintOnPreviousPage
      write FPrintOnPreviousPage default False;
    property ShowTitleOnPreviousPage: Boolean read FShowTitleOnPreviousPage
      write FShowTitleOnPreviousPage default True;
    property ResetPageNumbers: Boolean read FResetPageNumbers
      write FResetPageNumbers default False;
    property TitleBeforeHeader: Boolean read FTitleBeforeHeader
      write FTitleBeforeHeader default True;
    property HGuides: TStrings read FHGuides write SetHGuides;
    property VGuides: TStrings read FVGuides write SetVGuides;
    property OnAfterPrint: TfrxNotifyEvent read FOnAfterPrint write FOnAfterPrint;
    property OnBeforePrint: TfrxNotifyEvent read FOnBeforePrint write FOnBeforePrint;
    property OnManualBuild: TfrxNotifyEvent read FOnManualBuild write FOnManualBuild;
  end;

  TfrxDialogPage = class(TfrxPage)
  private
    FBorderStyle: TFormBorderStyle;
    FCaption: String;
    FColor: TColor;
    FForm: TForm;
    FOnActivate: TfrxNotifyEvent;
    FOnClick: TfrxNotifyEvent;
    FOnDeactivate: TfrxNotifyEvent;
    FOnHide: TfrxNotifyEvent;
    FOnKeyDown: TfrxKeyEvent;
    FOnKeyPress: TfrxKeyPressEvent;
    FOnKeyUp: TfrxKeyEvent;
    FOnResize: TfrxNotifyEvent;
    FOnShow: TfrxNotifyEvent;
    FOnCloseQuery: TfrxCloseQueryEvent;
    FPosition: TPosition;
    FWindowState: TWindowState;
    FClientWidth: Extended;
    FClientHeight: Extended;
    procedure DoInitialize;
    procedure DoOnActivate(Sender: TObject);
    procedure DoOnClick(Sender: TObject);
    procedure DoOnCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DoOnDeactivate(Sender: TObject);
    procedure DoOnHide(Sender: TObject);
    procedure DoOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnKeyPress(Sender: TObject; var Key: Char);
    procedure DoOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnShow(Sender: TObject);
    procedure DoOnResize(Sender: TObject);
    procedure DoModify(Sender: TObject);
    procedure DoOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SetBorderStyle(const Value: TFormBorderStyle);
    procedure SetCaption(const Value: String);
    procedure SetColor(const Value: TColor);
    function GetModalResult: TModalResult;
    procedure SetModalResult(const Value: TModalResult);
    function GetDoubleBuffered: Boolean;
    procedure SetDoubleBuffered(const Value: Boolean);
  protected
    procedure SetLeft(Value: Extended); override;
    procedure SetTop(Value: Extended); override;
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
    procedure SetClientWidth(Value: Extended);
    procedure SetClientHeight(Value: Extended);
    procedure SetScaled(Value: Boolean);
    function GetScaled: Boolean;
    function GetClientWidth: Extended;
    function GetClientHeight: Extended;
    procedure FontChanged(Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    procedure Initialize;
    function IsContain(X, Y: Extended): Boolean; override;
    function ShowModal: TModalResult;
    property DialogForm: TForm read FForm;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
  published
    property BorderStyle: TFormBorderStyle read FBorderStyle write SetBorderStyle default bsSizeable;
    property Caption: String read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property DoubleBuffered: Boolean read GetDoubleBuffered write SetDoubleBuffered;
    property Height;
    property ClientHeight: Extended read GetClientHeight write SetClientHeight;
    property Left;
    property Position: TPosition read FPosition write FPosition default poScreenCenter;
    property Top;
    property Width;
    property Scaled: Boolean read GetScaled write SetScaled;
    property ClientWidth: Extended read GetClientWidth write SetClientWidth;
    property WindowState: TWindowState read FWindowState write FWindowState default wsNormal;
    property OnActivate: TfrxNotifyEvent read FOnActivate write FOnActivate;
    property OnClick: TfrxNotifyEvent read FOnClick write FOnClick;
    property OnCloseQuery: TfrxCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
    property OnDeactivate: TfrxNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnHide: TfrxNotifyEvent read FOnHide write FOnHide;
    property OnKeyDown: TfrxKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyPress: TfrxKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp: TfrxKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnShow: TfrxNotifyEvent read FOnShow write FOnShow;
    property OnResize: TfrxNotifyEvent read FOnResize write FOnResize;
  end;

  TfrxDataPage = class(TfrxPage)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  published
    property Height;
    property Left;
    property Top;
    property Width;
  end;


{ Report }

  TfrxEngineOptions = class(TPersistent)
  private
    FConvertNulls: Boolean;
    FDestroyForms: Boolean;
    FDoublePass: Boolean;
    FMaxMemSize: Integer;
    FPrintIfEmpty: Boolean;
    FReportThread: TThread;
    FEnableThreadSafe: Boolean;
    FSilentMode: TfrxSilentMode;
    FTempDir: String;
    FUseFileCache: Boolean;
    FUseGlobalDataSetList: Boolean;
    FIgnoreDevByZero: Boolean;

    procedure SetSilentMode(Mode: Boolean);
    function GetSilentMode: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure AssignThreadProps(Source: TPersistent);
    procedure Clear;
    property ReportThread: TThread read FReportThread write FReportThread;
    property DestroyForms: Boolean read FDestroyForms write FDestroyForms;
    property EnableThreadSafe: Boolean read FEnableThreadSafe write FEnableThreadSafe;
    property UseGlobalDataSetList: Boolean read FUseGlobalDataSetList write FUseGlobalDataSetList;
  published
    property ConvertNulls: Boolean read FConvertNulls write FConvertNulls default True;
    property DoublePass: Boolean read FDoublePass write FDoublePass default False;
    property MaxMemSize: Integer read FMaxMemSize write FMaxMemSize default 10;
    property PrintIfEmpty: Boolean read FPrintIfEmpty write FPrintIfEmpty default True;
    property SilentMode: Boolean read GetSilentMode write SetSilentMode default False;
    property NewSilentMode: TfrxSilentMode read FSilentMode write FSilentMode default simMessageBoxes;
    property TempDir: String read FTempDir write FTempDir;
    property UseFileCache: Boolean read FUseFileCache write FUseFileCache default False;
    property IgnoreDevByZero: Boolean read FIgnoreDevByZero write FIgnoreDevByZero default False;
  end;

  TfrxPrintOptions = class(TPersistent)
  private
    FCopies: Integer;
    FCollate: Boolean;
    FPageNumbers: String;
    FPagesOnSheet: Integer;
    FPrinter: String;
    FPrintMode: TfrxPrintMode;
    FPrintOnSheet: Integer;
    FPrintPages: TfrxPrintPages;
    FReverse: Boolean;
    FShowDialog: Boolean;
    FSwapPageSize: Boolean;
    FPrnOutFileName: String;
    FDuplex: TfrxDuplexMode;
    FSplicingLine: Integer;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    property PrnOutFileName: String read FPrnOutFileName write FPrnOutFileName;
    property Duplex: TfrxDuplexMode read FDuplex write FDuplex;// set only after prepare report, need to store global duplex
    property SplicingLine: Integer read FSplicingLine write FSplicingLine default 3;
  published
    property Copies: Integer read FCopies write FCopies default 1;
    property Collate: Boolean read FCollate write FCollate default True;
    property PageNumbers: String read FPageNumbers write FPageNumbers;
    property Printer: String read FPrinter write FPrinter;
    property PrintMode: TfrxPrintMode read FPrintMode write FPrintMode default pmDefault;
    property PrintOnSheet: Integer read FPrintOnSheet write FPrintOnSheet;
    property PrintPages: TfrxPrintPages read FPrintPages write FPrintPages default ppAll;
    property Reverse: Boolean read FReverse write FReverse default False;
    property ShowDialog: Boolean read FShowDialog write FShowDialog default True;
    property SwapPageSize: Boolean read FSwapPageSize write FSwapPageSize stored False;// remove it
  end;

  TfrxPreviewOptions = class(TPersistent)
  private
    FAllowEdit: Boolean;
    FAllowPreviewEdit: Boolean;
    FButtons: TfrxPreviewButtons;
    FDoubleBuffered: Boolean;
    FMaximized: Boolean;
    FMDIChild: Boolean;
    FModal: Boolean;
    FOutlineExpand: Boolean;
    FOutlineVisible: Boolean;
    FOutlineWidth: Integer;
    FPagesInCache: Integer;
    FShowCaptions: Boolean;
    FThumbnailVisible: Boolean;
    FZoom: Extended;
    FZoomMode: TfrxZoomMode;
    FPictureCacheInFile: Boolean;
    FRTLPreview: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    property RTLPreview: Boolean read FRTLPreview write FRTLPreview;
  published
    property AllowEdit: Boolean read FAllowEdit write FAllowEdit default True;
    property AllowPreviewEdit: Boolean read FAllowPreviewEdit write FAllowPreviewEdit default True;
    property Buttons: TfrxPreviewButtons read FButtons write FButtons;
    property DoubleBuffered: Boolean read FDoubleBuffered write FDoubleBuffered default True;
    property Maximized: Boolean read FMaximized write FMaximized default True;
    property MDIChild: Boolean read FMDIChild write FMDIChild default False;
    property Modal: Boolean read FModal write FModal default True;
    property OutlineExpand: Boolean read FOutlineExpand write FOutlineExpand default True;
    property OutlineVisible: Boolean read FOutlineVisible write FOutlineVisible default False;
    property OutlineWidth: Integer read FOutlineWidth write FOutlineWidth default 120;
    property PagesInCache: Integer read FPagesInCache write FPagesInCache default 50;
    property ThumbnailVisible: Boolean read FThumbnailVisible write FThumbnailVisible default False;
    property ShowCaptions: Boolean read FShowCaptions write FShowCaptions default False;
    property Zoom: Extended read FZoom write FZoom;
    property ZoomMode: TfrxZoomMode read FZoomMode write FZoomMode default zmDefault;
    property PictureCacheInFile: Boolean read FPictureCacheInFile write FPictureCacheInFile default False;
  end;

  TfrxReportOptions = class(TPersistent)
  private
    FAuthor: String;
    FCompressed: Boolean;
    FConnectionName: String;
    FCreateDate: TDateTime;
    FDescription: TStrings;
    FInitString: String;
    FName: String;
    FLastChange: TDateTime;
    FPassword: String;
    FPicture: TPicture;
    FReport: TfrxReport;
    FVersionBuild: String;
    FVersionMajor: String;
    FVersionMinor: String;
    FVersionRelease: String;
    FPrevPassword: String;
    FHiddenPassword: String;
    FInfo: Boolean;
    procedure SetDescription(const Value: TStrings);
    procedure SetPicture(const Value: TPicture);
    procedure SetConnectionName(const Value: String);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    function CheckPassword: Boolean;
    property PrevPassword: String write FPrevPassword;
    property Info: Boolean read FInfo write FInfo;
    property HiddenPassword: String read FHiddenPassword write FHiddenPassword;
  published
    property Author: String read FAuthor write FAuthor;
    property Compressed: Boolean read FCompressed write FCompressed default False;
    property ConnectionName: String read FConnectionName write SetConnectionName;
    property CreateDate: TDateTime read FCreateDate write FCreateDate;
    property Description: TStrings read FDescription write SetDescription;
    property InitString: String read FInitString write FInitString;
    property Name: String read FName write FName;
    property LastChange: TDateTime read FLastChange write FLastChange;
    property Password: String read FPassword write FPassword;
    property Picture: TPicture read FPicture write SetPicture;
    property VersionBuild: String read FVersionBuild write FVersionBuild;
    property VersionMajor: String read FVersionMajor write FVersionMajor;
    property VersionMinor: String read FVersionMinor write FVersionMinor;
    property VersionRelease: String read FVersionRelease write FVersionRelease;
  end;


  TfrxExpressionCache = class(TObject)
  private
    FExpressions: TStringList;
    FMainScript: TfsScript;
    FScript: TfsScript;
    FScriptLanguage: String;
    procedure SetCaseSensitive(const Value: Boolean);
    function GetCaseSensitive: Boolean;
  public
    constructor Create(AScript: TfsScript);
    destructor Destroy; override;
    procedure Clear;
    function Calc(const Expression: String; var ErrorMsg: String;
      AScript: TfsScript): Variant;
    property CaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
  end;

  TfrxDataSetItem = class(TCollectionItem)
  private
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
  published
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
  end;

  TfrxReportDataSets = class(TCollection)
  private
    FReport: TfrxReport;
    function GetItem(Index: Integer): TfrxDataSetItem;
  public
    constructor Create(AReport: TfrxReport);
    procedure Initialize;
    procedure Finalize;
    procedure Add(ds: TfrxDataSet);
    function Find(ds: TfrxDataSet): TfrxDataSetItem; overload;
    function Find(const Name: String): TfrxDataSetItem; overload;
    procedure Delete(const Name: String); overload;
    property Items[Index: Integer]: TfrxDataSetItem read GetItem; default;
  end;

  TfrxStyleItem = class(TfrxCollectionItem)
  private
    FName: String;
    FFont: TFont;
    FFrame: TfrxFrame;
    FApplyFont: Boolean;
    FApplyFill: Boolean;
    FApplyFrame: Boolean;
    FFill: TfrxCustomFill;
    procedure SetFont(const Value: TFont);
    procedure SetFrame(const Value: TfrxFrame);
    procedure SetName(const Value: String);
    function GetFillType: TfrxFillType;
    procedure SetFill(const Value: TfrxCustomFill);
    procedure SetFillType(const Value: TfrxFillType);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
  protected
   function GetInheritedName: String; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure CreateUniqueName;
  published
    property Name: String read FName write SetName;
    property Color: TColor read GetColor write SetColor stored False;
    property Font: TFont read FFont write SetFont;
    property Frame: TfrxFrame read FFrame write SetFrame;
    property ApplyFont: Boolean read FApplyFont write FApplyFont default True;
    property ApplyFill: Boolean read FApplyFill write FApplyFill default True;
    property ApplyFrame: Boolean read FApplyFrame write FApplyFrame default True;
 	  property FillType: TfrxFillType read GetFillType write SetFillType default ftBrush;
    property Fill: TfrxCustomFill read FFill write SetFill;
  end;

  TfrxStyles = class(TfrxCollection)
  private
    FName: String;
    FReport: TfrxReport;
    function GetItem(Index: Integer): TfrxStyleItem;
  public
    constructor Create(AReport: TfrxReport);
    function Add: TfrxStyleItem;
    function Find(const Name: String): TfrxStyleItem;
    procedure Apply;
    procedure GetList(List: TStrings);
    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXMLItem(Item: TfrxXMLItem; OldXMLFormat: Boolean = True);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToXMLItem(Item: TfrxXMLItem);
    property Items[Index: Integer]: TfrxStyleItem read GetItem; default;
    property Name: String read FName write FName;
  end;

  TfrxStyleSheet = class(TObject)
  private
    FItems: TList;
    function GetItems(Index: Integer): TfrxStyles;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure GetList(List: TStrings);
    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);
    function Add: TfrxStyles;
    function Count: Integer;
    function Find(const Name: String): TfrxStyles;
    function IndexOf(const Name: String): Integer;
    property Items[Index: Integer]: TfrxStyles read GetItems; default;
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxReport = class(TfrxComponent)
  private
    FCurObject: String;
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    FDataSets: TfrxReportDatasets;
    FDesigner: TfrxCustomDesigner;
    FDotMatrixReport: Boolean;
    FDrawText: Pointer;
    FDrillState: TStrings;
    FEnabledDataSets: TfrxReportDataSets;
    FEngine: TfrxCustomEngine;
    FEngineOptions: TfrxEngineOptions;
    FErrors: TStrings;
    FExpressionCache: TfrxExpressionCache;
    FFileName: String;
    FIniFile: String;
    FLoadStream: TStream;
    FLocalValue: TfsCustomVariable;
    FSelfValue: TfsCustomVariable;
    FModified: Boolean;
    FOldStyleProgress: Boolean;
    FParentForm: TForm;
    FParentReport: String;
    FParentReportObject: TfrxReport;
    FPreviewPages: TfrxCustomPreviewPages;
    FMainPreviewPages: TfrxCustomPreviewPages;
    FPreview: TfrxCustomPreview;
    FPreviewForm: TForm;
    FPreviewOptions: TfrxPreviewOptions;
    FPrintOptions: TfrxPrintOptions;
    FProgress: TfrxProgress;
    FReloading: Boolean;
    FReportOptions: TfrxReportOptions;
    FScript: TfsScript;
    FSaveParentScript: TfsScript;
    FScriptLanguage: String;
    FScriptText: TStrings;
    FFakeScriptText: TStrings; {fake object}
    FShowProgress: Boolean;
    FStoreInDFM: Boolean;
    FStyles: TfrxStyles;
    FSysVariables: TStrings;
    FTerminated: Boolean;
    FTimer: TTimer;
    FVariables: TfrxVariables;
    FVersion: String;
    FXMLSerializer: TObject;
    FStreamLoaded: Boolean;

    FOnAfterPrint: TfrxBeforePrintEvent;
    FOnAfterPrintReport: TNotifyEvent;
    FOnBeforeConnect: TfrxBeforeConnectEvent;
    FOnAfterDisconnect: TfrxAfterDisconnectEvent;
    FOnBeforePrint: TfrxBeforePrintEvent;
    FOnBeginDoc: TNotifyEvent;
    FOnClickObject: TfrxClickObjectEvent;
    FOnDblClickObject: TfrxClickObjectEvent;
    FOnEditConnection: TfrxEditConnectionEvent;
    FOnEndDoc: TNotifyEvent;
    FOnGetValue: TfrxGetValueEvent;
    FOnNewGetValue: TfrxNewGetValueEvent;
    FOnLoadTemplate: TfrxLoadTemplateEvent;
    FOnLoadDetailTemplate: TfrxLoadDetailTemplateEvent;
    FOnManualBuild: TfrxManualBuildEvent;
    FOnMouseOverObject: TfrxMouseOverObjectEvent;
    FOnPreview: TNotifyEvent;
    FOnPrintPage: TfrxPrintPageEvent;
    FOnPrintReport: TNotifyEvent;
    FOnProgressStart: TfrxProgressEvent;
    FOnProgress: TfrxProgressEvent;
    FOnProgressStop: TfrxProgressEvent;
    FOnRunDialogs: TfrxRunDialogsEvent;
    FOnSetConnection: TfrxSetConnectionEvent;
    FOnStartReport: TfrxNotifyEvent;
    FOnStopReport: TfrxNotifyEvent;
    FOnUserFunction: TfrxUserFunctionEvent;
    FOnClosePreview: TNotifyEvent;
    FOnReportPrint: TfrxNotifyEvent;
    FOnAfterScriptCompile: TNotifyEvent;
    FOnMouseEnter: TfrxMouseEnterEvent;
    FOnMouseLeave: TfrxMouseLeaveEvent;

    FOnGetCustomDataEvent: TfrxGetCustomDataEvent;
    FOnSaveCustomDataEvent: TfrxSaveCustomDataEvent;

    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function DoGetValue(const Expr: String; var Value: Variant): Boolean;
    function GetScriptValue(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function SetScriptValue(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function DoUserFunction(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function GetDataSetName: String;
    function GetLocalValue: Variant;
    function GetSelfValue: TfrxView;
    function GetPages(Index: Integer): TfrxPage;
    function GetPagesCount: Integer;
    function GetCaseSensitive: Boolean;
    function GetScriptText: TStrings;
    procedure AncestorNotFound(Reader: TReader; const ComponentName: string;
      ComponentClass: TPersistentClass; var Component: TComponent);
    procedure DoClear;
    procedure DoLoadFromStream;
    procedure OnTimer(Sender: TObject);
    procedure ReadDatasets(Reader: TReader);
    procedure ReadStyle(Reader: TReader);
    procedure ReadVariables(Reader: TReader);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    procedure SetEngineOptions(const Value: TfrxEngineOptions);
    procedure SetSelfValue(const Value: TfrxView);
    procedure SetLocalValue(const Value: Variant);
    procedure SetParentReport(const Value: String);
    procedure SetPreviewOptions(const Value: TfrxPreviewOptions);
    procedure SetPrintOptions(const Value: TfrxPrintOptions);
    procedure SetReportOptions(const Value: TfrxReportOptions);
    procedure SetScriptText(const Value: TStrings);
    procedure SetStyles(const Value: TfrxStyles);
    procedure SetTerminated(const Value: Boolean);
    procedure SetCaseSensitive(const Value: Boolean);
    procedure WriteDatasets(Writer: TWriter);
    procedure WriteStyle(Writer: TWriter);
    procedure WriteVariables(Writer: TWriter);
    procedure SetPreview(const Value: TfrxCustomPreview);
    procedure SetVersion(const Value: String);
    procedure SetPreviewPages(const Value: TfrxCustomPreviewPages);
    {$IFDEF FPC}
    function GetLazIniFile:string;
    {$ENDIF}
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoGetAncestor(const Name: String; var Ancestor: TPersistent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    class function GetDescription: String; override;
    procedure WriteNestedProperties(Item: TfrxXmlItem; aAcenstor: TPersistent = nil); override;
    function ReadNestedProperty(Item: TfrxXmlItem): Boolean; override;

    { internal methods }
    function Calc(const Expr: String; AScript: TfsScript = nil): Variant;
    function DesignPreviewPage: Boolean;
    function GetAlias(DataSet: TfrxDataSet): String;
    function GetDataset(const Alias: String): TfrxDataset;
    function GetReportDrawText: Pointer;
    function GetIniFile: TCustomIniFile;
    function GetApplicationFolder: String;
    function FindObject(const AName: String): TfrxComponent; override;
    function PrepareScript(ActiveReport: TfrxReport = nil): Boolean;
    function InheritFromTemplate(const templName: String; InheriteMode: TfrxInheriteMode = imDefault): Boolean;
    procedure DesignReport(IDesigner: {$IFDEF FPC}TObject{$ELSE}IUnknown{$ENDIF}; Editor: TObject); overload;
    procedure DoNotifyEvent(Obj: TObject; const EventName: String;
      RunAlways: Boolean = False);
    procedure DoParamEvent(const EventName: String; var Params: Variant;
      RunAlways: Boolean = False);
    procedure DoAfterPrint(c: TfrxReportComponent);
    procedure DoBeforePrint(c: TfrxReportComponent);
    procedure DoPreviewClick(v: TfrxView; Button: TMouseButton;
      Shift: TShiftState; var Modified: Boolean; var EventParams: TfrxInteractiveEventsParams; DblClick: Boolean = False);
    procedure DoMouseEnter(Sender: TfrxView; aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams); reintroduce;
    procedure DoMouseLeave(Sender: TfrxView; X, Y: Integer; aNextObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams); reintroduce;
    procedure DoMouseUp(Sender: TfrxView; X, Y: Integer; Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams); reintroduce;
    procedure GetDatasetAndField(const ComplexName: String;
      var Dataset: TfrxDataset; var Field: String);
    procedure GetDataSetList(List: TStrings; OnlyDB: Boolean = False);
    procedure GetActiveDataSetList(List: TStrings);
    procedure InternalOnProgressStart(ProgressType: TfrxProgressType); virtual;
    procedure InternalOnProgress(ProgressType: TfrxProgressType; Progress: Integer); virtual;
    procedure InternalOnProgressStop(ProgressType: TfrxProgressType); virtual;
    procedure SelectPrinter;
    procedure SetProgressMessage(const Value: String; Ishint: Boolean = False; bHandleMessage: Boolean = True);
    procedure CheckDataPage;
    { public methods }
    function LoadFromFile(const FileName: String;
      ExceptionIfNotFound: Boolean = False): Boolean;
    procedure LoadFromStream(Stream: TStream); override;
    function LoadFromFilter(Filter: TfrxCustomIOTransport; const FileName: String): Boolean;
    function ProcessIOTransport(Filter: TfrxCustomIOTransport; const FileName: String; fAccess: TfrxFilterAccess): Boolean;
    function SaveToFilter(Filter: TfrxCustomIOTransport; const FileName: String): Boolean;
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream; SaveChildren: Boolean = True;
      SaveDefaultValues: Boolean = False; UseGetAncestor: Boolean = False); override;
    procedure DesignReport(Modal: Boolean = True; MDIChild: Boolean = False); overload; {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
    function PrepareReport(ClearLastReport: Boolean = True): Boolean;
  	function PreparePage(APage: TfrxPage): Boolean;
    procedure ShowPreparedReport; {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
    procedure ShowReport(ClearLastReport: Boolean = True); {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
    procedure AddFunction(const FuncName: String; const Category: String = '';
      const Description: String = '');
    procedure DesignReportInPanel(Panel: TWinControl);
    function Print: Boolean; {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
    function Export(Filter: TfrxCustomExportFilter): Boolean;

    { internals }
    property CurObject: String read FCurObject write FCurObject;
    property DrillState: TStrings read FDrillState;
    property LocalValue: Variant read GetLocalValue write SetLocalValue;
    property SelfValue: TfrxView read GetSelfValue write SetSelfValue;
    property PreviewForm: TForm read FPreviewForm;
    property XMLSerializer: TObject read FXMLSerializer;
    property Reloading: Boolean read FReloading write FReloading;

    { public }
    property DataSets: TfrxReportDataSets read FDataSets;
    property Designer: TfrxCustomDesigner read FDesigner write FDesigner;
    property EnabledDataSets: TfrxReportDataSets read FEnabledDataSets;
    property Engine: TfrxCustomEngine read FEngine;
    property Errors: TStrings read FErrors;
    property FileName: String read FFileName write FFileName;
    property Modified: Boolean read FModified write FModified;
    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages write SetPreviewPages;
    property Pages[Index: Integer]: TfrxPage read GetPages;
    property PagesCount: Integer read GetPagesCount;
    property Script: TfsScript read FScript;
    property Styles: TfrxStyles read FStyles write SetStyles;
    property Terminated: Boolean read FTerminated write SetTerminated;
    property Variables: TfrxVariables read FVariables;
    property CaseSensitiveExpressions: Boolean read GetCaseSensitive write SetCaseSensitive;

    property OnEditConnection: TfrxEditConnectionEvent read FOnEditConnection write FOnEditConnection;
    property OnSetConnection: TfrxSetConnectionEvent read FOnSetConnection write FOnSetConnection;
  published
    property Version: String read FVersion write SetVersion;
    property ParentReport: String read FParentReport write SetParentReport;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property DotMatrixReport: Boolean read FDotMatrixReport write FDotMatrixReport;
    property EngineOptions: TfrxEngineOptions read FEngineOptions write SetEngineOptions;
    property IniFile: String read {$IFNDEF FPC}FIniFile{$ELSE}GetLazIniFile{$ENDIF} write FIniFile;
    property OldStyleProgress: Boolean read FOldStyleProgress write FOldStyleProgress default False;
    property Preview: TfrxCustomPreview read FPreview write SetPreview;
    property PreviewOptions: TfrxPreviewOptions read FPreviewOptions write SetPreviewOptions;
    property PrintOptions: TfrxPrintOptions read FPrintOptions write SetPrintOptions;
    property ReportOptions: TfrxReportOptions read FReportOptions write SetReportOptions;
    property ScriptLanguage: String read FScriptLanguage write FScriptLanguage;
    property ScriptText: TStrings read GetScriptText write SetScriptText;
    property ShowProgress: Boolean read FShowProgress write FShowProgress default True;
    property StoreInDFM: Boolean read FStoreInDFM write FStoreInDFM default True;

    property OnAfterPrint: TfrxBeforePrintEvent read FOnAfterPrint write FOnAfterPrint;
    property OnBeforeConnect: TfrxBeforeConnectEvent read FOnBeforeConnect write FOnBeforeConnect;
    property OnAfterDisconnect: TfrxAfterDisconnectEvent read FOnAfterDisconnect write FOnAfterDisconnect;
    property OnBeforePrint: TfrxBeforePrintEvent read FOnBeforePrint write FOnBeforePrint;
    property OnBeginDoc: TNotifyEvent read FOnBeginDoc write FOnBeginDoc;
    property OnClickObject: TfrxClickObjectEvent read FOnClickObject write FOnClickObject;
    property OnDblClickObject: TfrxClickObjectEvent read FOnDblClickObject write FOnDblClickObject;
    property OnEndDoc: TNotifyEvent read FOnEndDoc write FOnEndDoc;
    property OnGetValue: TfrxGetValueEvent read FOnGetValue write FOnGetValue;
    property OnNewGetValue: TfrxNewGetValueEvent read FOnNewGetValue write FOnNewGetValue;
    property OnManualBuild: TfrxManualBuildEvent read FOnManualBuild write FOnManualBuild;
    property OnMouseOverObject: TfrxMouseOverObjectEvent read FOnMouseOverObject
      write FOnMouseOverObject;
    property OnMouseEnter: TfrxMouseEnterEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TfrxMouseLeaveEvent read FOnMouseLeave write FOnMouseLeave;
    property OnPreview: TNotifyEvent read FOnPreview write FOnPreview;
    property OnPrintPage: TfrxPrintPageEvent read FOnPrintPage write FOnPrintPage;
    property OnPrintReport: TNotifyEvent read FOnPrintReport write FOnPrintReport;
    property OnAfterPrintReport: TNotifyEvent read FOnAfterPrintReport write FOnAfterPrintReport;
    property OnProgressStart: TfrxProgressEvent read FOnProgressStart write FOnProgressStart;
    property OnProgress: TfrxProgressEvent read FOnProgress write FOnProgress;
    property OnProgressStop: TfrxProgressEvent read FOnProgressStop write FOnProgressStop;
    property OnRunDialogs: TfrxRunDialogsEvent read FOnRunDialogs write FOnRunDialogs;
    property OnStartReport: TfrxNotifyEvent read FOnStartReport write FOnStartReport;
    property OnStopReport: TfrxNotifyEvent read FOnStopReport write FOnStopReport;
    property OnUserFunction: TfrxUserFunctionEvent read FOnUserFunction write FOnUserFunction;
    property OnLoadTemplate: TfrxLoadTemplateEvent read FOnLoadTemplate write FOnLoadTemplate;
    property OnLoadDetailTemplate: TfrxLoadDetailTemplateEvent read FOnLoadDetailTemplate write FOnLoadDetailTemplate;
    property OnClosePreview: TNotifyEvent read FOnClosePreview write FOnClosePreview;
    property OnReportPrint: TfrxNotifyEvent read FOnReportPrint write FOnReportPrint;
    property OnAfterScriptCompile: TNotifyEvent read FOnAfterScriptCompile write FOnAfterScriptCompile;
    property OnGetCustomData: TfrxGetCustomDataEvent read FOnGetCustomDataEvent write FOnGetCustomDataEvent;
    property OnSaveCustomData: TfrxSaveCustomDataEvent read FOnSaveCustomDataEvent write FOnSaveCustomDataEvent;
  end;

  { Incapsulate second list for Object ispector }
  TfrxSelectedObjectsList = class(TList)
  private
    FInspSelectedObjects: TList;
    FUpdated: Boolean;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearInspectorList;
    property InspSelectedObjects: TList read FInspSelectedObjects;
    property Updated: Boolean read FUpdated write FUpdated;
  end;

  TfrxCustomDesigner = class(TForm)
  private
    FReport: TfrxReport;
    FIsPreviewDesigner: Boolean;
    FMemoFontName: String;
    FMemoFontSize: Integer;
    FUseObjectFont: Boolean;
    FParentForm: TForm;
  protected
    FModified: Boolean;
    FInspectorLock: Boolean;
    FObjects: TList;
    FPage: TfrxPage;
    FSelectedObjects: TfrxSelectedObjectsList;
    procedure SetModified(const Value: Boolean); virtual;
    procedure SetPage(const Value: TfrxPage); virtual;
    function GetCode: TStrings; virtual; abstract;
  public
    constructor CreateDesigner(AOwner: TComponent; AReport: TfrxReport;
      APreviewDesigner: Boolean = False);
    destructor Destroy; override;
    function InsertExpression(const Expr: String): String; virtual; abstract;
    function IsChangedExpression(const InExpr: String; out OutExpr: String): Boolean; virtual; abstract;
    procedure Lock; virtual; abstract;
    procedure ReloadPages(Index: Integer); virtual; abstract;
    procedure ReloadReport; virtual; abstract;
    procedure ReloadObjects(ResetSelection: Boolean = True); virtual; abstract;
    procedure UpdateDataTree; virtual; abstract;
    procedure UpdatePage; virtual; abstract;
    procedure UpdateInspector; virtual; abstract;
    procedure DisableInspectorUpdate; virtual; abstract;
    procedure EnableInspectorUpdate; virtual; abstract;
    procedure InternalCopy; virtual; abstract;
    procedure InternalPaste; virtual; abstract;
    function InternalIsPasteAvailable: Boolean; virtual; abstract;
    property IsPreviewDesigner: Boolean read FIsPreviewDesigner;
    property Modified: Boolean read FModified write SetModified;
    property Objects: TList read FObjects;
    property Report: TfrxReport read FReport;
    property SelectedObjects: TfrxSelectedObjectsList read FSelectedObjects;
    property Page: TfrxPage read FPage write SetPage;
    property Code: TStrings read GetCode;
    property UseObjectFont: Boolean read FUseObjectFont write FUseObjectFont;
    property MemoFontName: String read FMemoFontName write FMemoFontName;
    property MemoFontSize: Integer read FMemoFontSize write FMemoFontSize;
    property ParentForm: TForm read FParentForm write FParentForm;
  end;

  TfrxDesignerClass = class of TfrxCustomDesigner;
  TfrxNodeChanging = procedure(Name: String; bUseRemoveList: Boolean = False; aObject: TObject = nil) of object;

  TfrxNode = class(TObject)
  private
    FParent: TfrxNode;
    FNodesList: TStringList;
    FData: Variant;
    FObjectData: TObject;
    FName: String;
    FOriginalName: String;
    FOwnObject: Boolean;
    FOnAddItem: TfrxNodeChanging;
    FOnRemoveItem: TfrxNodeChanging;
    FFilterAccess: TfrxFilterAccess;
    FFilesCount: Integer;
    procedure SetName(const Value: String);
    procedure SetObjectData(const Value: TObject);
    function GetNode(Index: Integer): TfrxNode;
    procedure UpdateFilesCount(Count: Integer);
    procedure SetOriginalName(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetRoot: TfrxNode;
    function Add(Name: String; aObject: TObject = nil): TfrxNode;
    procedure RemoveNode(aNode: TfrxNode);
    function Find(Name: String; SearchInChilds: Boolean = False): TfrxNode; overload;
    function Find(aObject: TObject; SearchInChilds: Boolean = False): TfrxNode; overload;
    function Count: Integer;
    property Parent: TfrxNode read FParent;
    property Data: Variant read FData write FData;
    property ObjectData: TObject read FObjectData write SetObjectData;
    property Name: String read FName write SetName;
    property Items[Index: Integer]: TfrxNode read GetNode;
    property OriginalName: String read FOriginalName write SetOriginalName;
    property OnAddItem: TfrxNodeChanging read FOnAddItem write FOnAddItem;
    property OnRemoveItem: TfrxNodeChanging read FOnRemoveItem write FOnRemoveItem;
    property FilterAccess: TfrxFilterAccess read FFilterAccess write FFilterAccess;
    property FilesCount: Integer read FFilesCount;
  end;

  TfrxFilterVisibleState = (fvDesigner, fvPreview, fvExport, fvDesignerFileFilter, fvPreviewFileFilter, fvExportFileFilter, fvOther);
  TfrxFilterVisibility = set of TfrxFilterVisibleState;

  TfrxIOTransportStream = (tsIORead, tsIOWrite);
  TfrxIOTransportStreams = set of TfrxIOTransportStream;


  TfrxCustomIOTransport = class(TComponent)
  private
    FReport: TfrxReport;
    FShowDialog: Boolean;
    FOverwritePrompt: Boolean;
    FDefaultPath: String;
    FBasePath: String;
    FFileName: String;
    FDefaultExt: String;
    FExtDescription: String;
    FFilterString: String;
    FFilterAccess: TfrxFilterAccess;
    FTempFilter: TfrxCustomIOTransport;

    FCurNode: TfrxNode;
    function GetTempFilter: TfrxCustomIOTransport;
    procedure SetTempFilter(const Value: TfrxCustomIOTransport);
    procedure SetInternalFilter(const Value: TfrxCustomIOTransport);
    function GetInternalFilter: TfrxCustomIOTransport;
    function GetCurrentContainer: String;
    procedure SetCurrentContainer(const Value: String);
  protected
    FNoRegister: Boolean;
    FVisibility: TfrxFilterVisibility;
    FCreatedFrom: TfrxFilterVisibleState;
    FFreeStream: Boolean;
    FClosedLoadLock: Boolean;
    FInternalFilter: TfrxCustomIOTransport;
    FDirTree: TfrxNode;
    FSupportedStreams: TfrxIOTransportStreams;
    FOriginalCopy: TfrxCustomIOTransport;
    function GetFilterString: String; virtual;
    function GetVisibility: TfrxFilterVisibility; virtual;
    procedure SetVisibility(const Value: TfrxFilterVisibility); virtual;
    function GetNodeFromPath(aPath: String; bCreateNodes: Boolean = False; bLastNodeAsFile: Boolean = False): TfrxNode;
    { override for container functional if needed }
    function AddContainer(Item: TfrxNode): Boolean; virtual;
    function RemoveContainer(Item: TfrxNode): Boolean; virtual;
    function DoCreateStream(var aFullFilePath: String; aFileName: String): TStream; virtual;
    property InternalFilter: TfrxCustomIOTransport read GetInternalFilter write SetInternalFilter;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateNoRegister;
    function CreateFilterClone(CreatedFrom: TfrxFilterVisibleState): TfrxCustomIOTransport;
    destructor Destroy; override;
    // basic file structure methods
    procedure CloseAllStreams;
    procedure CopyStreamsNames(aStrings: TStrings; OpenedOnly: Boolean = False);
    procedure LoadStreamsList(aStrings: TStrings);
    procedure LoadClosedStreams;
    { containers / Directories }
    procedure CreateContainer(const cName: String; bSetCurrent: Boolean = False);
    procedure DeleteContainer(const cName: String);
    procedure CreateTempContainer; virtual;
    procedure FreeTempContainer; virtual;
    { file streams }
    function GetStream(aFileName: String = ''): TStream; virtual;
    procedure FreeStream(aStream: TStream; aFileName: String = ''); virtual;
    function DoFilterSave(aStream: TStream): Boolean; virtual;
    function AllInOneContainer: Boolean; virtual;
    // filter (un)init
    function OpenFilter: Boolean; virtual;
    procedure CloseFilter; virtual;
    procedure InitFromExport(ExportFilter: TfrxCustomExportFilter);
    procedure AssignFilter(Source: TfrxCustomIOTransport); virtual;
    procedure AssignSharedProperties(Source: TfrxCustomIOTransport); virtual;
    function GetFileNode: TfrxNode;
    class function GetDescription: String; virtual;
    property RootNode: TfrxNode read FDirTree;
    property CurrentContainer: String read GetCurrentContainer write SetCurrentContainer;
    property CreatedFrom: TfrxFilterVisibleState read FCreatedFrom write FCreatedFrom;
    property TempFilter: TfrxCustomIOTransport read GetTempFilter write SetTempFilter;
    property FilterAccess: TfrxFilterAccess read FFilterAccess write FFilterAccess;
    property FilterString: String read GetFilterString write FFilterString;
    property Report: TfrxReport read FReport write FReport;
    property ShowDialog: Boolean read FShowDialog write FShowDialog;
    property OverwritePrompt: Boolean read FOverwritePrompt write FOverwritePrompt;
    property DefaultPath: String read FDefaultPath write FDefaultPath;
    property FileName: String read FFileName write FFileName;
    property BasePath: String read FBasePath write FBasePath;
    property DefaultExt: String read FDefaultExt write FDefaultExt;
    property ExtDescription: String read FExtDescription write FExtDescription;
    property Visibility: TfrxFilterVisibility read GetVisibility write SetVisibility;
    property SupportedStreams: TfrxIOTransportStreams read FSupportedStreams write FSupportedStreams;
  end;

  TfrxIOTransportFile = class(TfrxCustomIOTransport)
  private
    FTempFolderCreated: Boolean;
  protected
    procedure SetVisibility(const Value: TfrxFilterVisibility); override;
    function AddContainer(Item: TfrxNode): Boolean; override;
    procedure DeleteFiles;
  public
    constructor Create(AOwner: TComponent); override;
    function OpenFilter: Boolean; override;
    function DoCreateStream(var aFullFilePath: String; aFileName: String): TStream; override;
    procedure CloseFilter; override; // Empty
    class function GetDescription: String; override;
    procedure CreateTempContainer; override;
    procedure FreeTempContainer; override;
  end;

  TfrxSaveToCompressedFilter = class(TfrxIOTransportFile)
  private
    FIsFR3File: Boolean;
    procedure SetIsFR3File(const Value: Boolean);
  protected
    function GetFilterString: String; override;
  public
    constructor Create(AOwner: TComponent); override;
    function OpenFilter: Boolean; override;
    class function GetDescription: String; override;
    property IsFR3File: Boolean read FIsFR3File write SetIsFR3File;
  end;

  TfrxCustomExportFilter = class(TComponent)
  private
    FCurPage: Boolean;
    FExportNotPrintable: Boolean;
    FName: String;
    FNoRegister: Boolean;
    FPageNumbers: String;
    FReport: TfrxReport;
    FShowDialog: Boolean;
    FStream: TStream;
    FUseFileCache: Boolean;
    FDefaultPath: String;
    FSlaveExport: Boolean;
    FShowProgress: Boolean;
    FDefaultExt: String;
    FFilterDesc: String;
    FSuppressPageHeadersFooters: Boolean;
    FTitle: String;
    FOverwritePrompt: Boolean;
    FFIles: TStrings;
    FOnBeforeExport: TNotifyEvent;
    FOnBeginExport: TNotifyEvent;
    FCreationTime: TDateTime;
    FDataOnly: Boolean;
    FIOTransport: TfrxCustomIOTransport;
    FOpenAfterExport: Boolean;
    function GetDefaultIOTransport: TfrxCustomIOTransport;
    procedure SetDefaultIOTransport(const Value: TfrxCustomIOTransport);
    procedure SetShowDialog(const Value: Boolean);
    procedure SetFileName(const Value: String);
  protected
    FDefaultIOTransport: TfrxCustomIOTransport;
    procedure Finish; virtual;
    procedure AfterFinish; virtual;
    procedure BeforeStart; virtual;
    function Start: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateNoRegister;
    destructor Destroy; override;
    class function GetDescription: String; virtual;
    function ShowModal: TModalResult; virtual;
    function DoStart: Boolean;
    function CreateDefaultIOTransport: TfrxCustomIOTransport; virtual;
    procedure ExportObject(Obj: TfrxComponent); virtual; abstract;
    procedure DoFinish;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); virtual;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); virtual;
    procedure BeginClip(Obj: TfrxView); virtual;
    procedure EndClip; virtual;
    function IsProcessInternal: Boolean; virtual;

    property DefaultIOTransport: TfrxCustomIOTransport read GetDefaultIOTransport write SetDefaultIOTransport;
    property CurPage: Boolean read FCurPage write FCurPage;
    property PageNumbers: String read FPageNumbers write FPageNumbers;
    property Report: TfrxReport read FReport write FReport;
    property Stream: TStream read FStream write FStream;
    property SlaveExport: Boolean read FSlaveExport write FSlaveExport;
    property DefaultExt: String read FDefaultExt write FDefaultExt;
    property FilterDesc: String read FFilterDesc write FFilterDesc;
    property SuppressPageHeadersFooters: Boolean read FSuppressPageHeadersFooters
      write FSuppressPageHeadersFooters;
    property ExportTitle: String read FTitle write FTitle;
    property Files: TStrings read FFiles write FFiles;
    property OpenAfterExport: Boolean read FOpenAfterExport write FOpenAfterExport;
  published
    property IOTransport: TfrxCustomIOTransport read FIOTransport write FIOTransport;
    property ShowDialog: Boolean read FShowDialog write SetShowDialog default True;
    property FileName: String read FName write SetFileName;
    property ExportNotPrintable: Boolean read FExportNotPrintable write FExportNotPrintable default False;
    property UseFileCache: Boolean read FUseFileCache write FUseFileCache;
    property DefaultPath: String read FDefaultPath write FDefaultPath;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;
    property OverwritePrompt: Boolean read FOverwritePrompt write FOverwritePrompt;
    property CreationTime: TDateTime read FCreationTime write FCreationTime;
    property DataOnly: Boolean read FDataOnly write FDataOnly;
    property OnBeforeExport: TNotifyEvent read FOnBeforeExport write FOnBeforeExport;
    property OnBeginExport: TNotifyEvent read FOnBeginExport write FOnBeginExport;
  end;

  TfrxCustomWizard = class(TComponent)
  private
    FDesigner: TfrxCustomDesigner;
    FReport: TfrxReport;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; virtual;
    function Execute: Boolean; virtual; abstract;
    property Designer: TfrxCustomDesigner read FDesigner;
    property Report: TfrxReport read FReport;
  end;

  TfrxWizardClass = class of TfrxCustomWizard;

  TfrxCustomEngine = class(TPersistent)
  private
    FCurColumn: Integer;
    FCurVColumn: Integer;
    FCurLine: Integer;
    FCurLineThrough: Integer;
    FFinalPass: Boolean;
    FNotifyList: TList;
    FPageHeight: Extended;
    FPageWidth: Extended;
    FPreviewPages: TfrxCustomPreviewPages;
    FReport: TfrxReport;
    FRunning: Boolean;
    FStartDate: TDateTime;
    FStartTime: TDateTime;
    FTotalPages: Integer;
    FOnRunDialog: TfrxRunDialogEvent;
    FSecondScriptCall: Boolean;
    FCurTableRow: Integer;
    FCurTableColumn: Integer;
    function GetDoublePass: Boolean;
  protected
    FCurX: Extended;
    FCurY: Extended;
  protected
    function GetPageHeight: Extended; virtual;
  public
    constructor Create(AReport: TfrxReport); virtual;
    destructor Destroy; override;
    procedure EndPage; virtual; abstract;
    procedure BreakAllKeep; virtual;
    procedure NewColumn; virtual; abstract;
    procedure NewPage; virtual; abstract;
    procedure PrepareShiftTree(Container: TfrxReportComponent); virtual; abstract;
    function ShowBand(Band: TfrxBand): TfrxBand; overload; virtual; abstract;
    procedure ShowBand(Band: TfrxBandClass); overload; virtual; abstract;
    procedure ShowBandByName(const BandName: String);
    procedure Stretch(Band: TfrxReportComponent); virtual; abstract;
    procedure UnStretch(Band: TfrxReportComponent); virtual; abstract;
    procedure StopReport;
    function HeaderHeight: Extended; virtual; abstract;
    function FooterHeight: Extended; virtual; abstract;
    function FreeSpace: Extended; virtual; abstract;
    function GetAggregateValue(const Name, Expression: String;
      Band: TfrxBand;  Flags: Integer): Variant; virtual; abstract;
    procedure ProcessObject(ReportObject: TfrxView); virtual; abstract;
    function Run(ARunDialogs: Boolean;
      AClearLast: Boolean = False; APage: TfrxPage = nil): Boolean; virtual; abstract;
    property CurLine: Integer read FCurLine write FCurLine;
    property CurLineThrough: Integer read FCurLineThrough write FCurLineThrough;
    property CurTableRow: Integer read FCurTableRow write FCurTableRow;
    property CurTableColumn: Integer read FCurTableColumn write FCurTableColumn;
    property NotifyList: TList read FNotifyList;
    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages write FPreviewPages;
    property Report: TfrxReport read FReport;
    property Running: Boolean read FRunning write FRunning;
    property OnRunDialog: TfrxRunDialogEvent read FOnRunDialog write FOnRunDialog;
  published
    property CurColumn: Integer read FCurColumn write FCurColumn;
    property CurVColumn: Integer read FCurVColumn write FCurVColumn;
    property CurX: Extended read FCurX write FCurX;
    property CurY: Extended read FCurY write FCurY;
    property DoublePass: Boolean read GetDoublePass;
    property FinalPass: Boolean read FFinalPass write FFinalPass;
    property PageHeight: Extended read GetPageHeight write FPageHeight;
    property PageWidth: Extended read FPageWidth write FPageWidth;
    property StartDate: TDateTime read FStartDate write FStartDate;
    property StartTime: TDateTime read FStartTime write FStartTime;
    property TotalPages: Integer read FTotalPages write FTotalPages;
    property SecondScriptCall: Boolean read FSecondScriptCall write FSecondScriptCall;
  end;

  TfrxCustomOutline = class(TPersistent)
  private
    FCurItem: TfrxXMLItem;
    FPreviewPages: TfrxCustomPreviewPages;
  protected
    function GetCount: Integer; virtual; abstract;
  public
    constructor Create(APreviewPages: TfrxCustomPreviewPages); virtual;
    procedure AddItem(const Text: String; Top: Integer); virtual; abstract;
    procedure DeleteItems(From: TfrxXMLItem); virtual; abstract;
    procedure LevelDown(Index: Integer); virtual; abstract;
    procedure LevelRoot; virtual; abstract;
    procedure LevelUp; virtual; abstract;
    procedure GetItem(Index: Integer; var Text: String;
      var Page, Top: Integer); virtual; abstract;
    procedure ShiftItems(From: TfrxXMLItem; NewTop: Integer); virtual; abstract;
    function Engine: TfrxCustomEngine;
    function GetCurPosition: TfrxXMLItem; virtual; abstract;
    property Count: Integer read GetCount;
    property CurItem: TfrxXMLItem read FCurItem write FCurItem;
    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages;
  end;

  TfrxObjectProcessing = class(TPersistent)
  private
    FProcessAt: TfrxProcessAtMode;
    FGroupLevel: Integer;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ProcessAt: TfrxProcessAtMode read FProcessAt write FProcessAt default paDefault;
    property GroupLevel: Integer read FGroupLevel write FGroupLevel default 0;
  end;

  TfrxMacrosItem = class(TObject)
  private
    FItems: TWideStrings;
    FSupressedValue: Variant;
    FLastIndex: Integer;
    FComponent: TfrxComponent;
    FBaseComponent: TfrxComponent;
    FBandName: String;
    FNeedReset: Boolean;
    FProcessAt: TfrxProcessAtMode;
    FGroupLevel: Integer;
    FDataLevel: Integer;
    FParent: TfrxPostProcessor;
    function GetItem(Index: Integer): WideString;
    procedure SetItem(Index: Integer; const Value: WideString);
  public
    constructor Create;
    destructor Destroy; override;
    function AddObject(const S: WideString; AObject: TObject; bSupressed: Boolean = false): Integer;
    function Count: Integer;
    property Item[Index: Integer]: WideString read GetItem write SetItem;
  end;

  TfrxPostProcessor = class(TPersistent)
  private
    FMacroses: TStrings;
    FProcessList: TList;
    FBands: TStrings;
    FGroupLevel: Integer;
    FDataLevel: Integer;
    FProcessing: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(const BandName: String; const Name: String; const Content: WideString; ProcessMode: TfrxProcessAtMode; aComponent: TfrxComponent; bSupressed: Boolean = false; bEmpty: Boolean = false): Integer;
    procedure EnterGroup;
    procedure LeaveGroup;
    procedure EnterData;
    procedure LeaveData;
    function GetValue(const MacroIndex: Integer; const MacroLine: Integer): WideString;
    function GetMacroList(const MacroName: String): TWideStrings;
    function LoadValue(aComponent: TfrxComponent): Boolean;
    procedure SaveToXML(Item: TfrxXMLItem);
    procedure LoadFromXML(Item: TfrxXMLItem);
    procedure ResetSuppressed;
    procedure ResetDuplicates(const BandName: String = '');
    procedure ProcessExpressions(AReport: TfrxReport; ABand: TfrxBand; ProcessMode: TfrxProcessAtMode);
    procedure ProcessObject(AReport: TfrxReport; aComponent: TfrxComponent);
    property Macroses: TStrings read FMacroses;
  end;

  TfrxCustomPreviewPages = class(TObject)
  private
    FAddPageAction: TfrxAddPageAction; { used in the cross-tab renderer }
    FCurPage: Integer;
    FCurPreviewPage: Integer;
    FFirstPage: Integer;               {  used in the composite reports }
    FOutline: TfrxCustomOutline;
    FReport: TfrxReport;
    FEngine: TfrxCustomEngine;
  protected
    FPostProcessor: TfrxPostProcessor;
    function GetCount: Integer; virtual; abstract;
    function GetPage(Index: Integer): TfrxReportPage; virtual; abstract;
    function GetPageSize(Index: Integer): TPoint; virtual; abstract;
  public
    constructor Create(AReport: TfrxReport); virtual;
    destructor Destroy; override;
    procedure Clear; virtual; abstract;
    procedure Initialize; virtual; abstract;

    procedure AddObject(Obj: TfrxComponent); virtual; abstract;
    procedure AddPage(Page: TfrxReportPage); virtual; abstract;
    procedure AddSourcePage(Page: TfrxReportPage); virtual; abstract;
    procedure AddToSourcePage(Obj: TfrxComponent); virtual; abstract;
    procedure BeginPass; virtual; abstract;
    procedure ClearFirstPassPages; virtual; abstract;
    procedure CutObjects(APosition: Integer); virtual; abstract;
    procedure DeleteObjects(APosition: Integer); virtual; abstract;
    procedure DeleteAnchors(From: Integer); virtual; abstract;
    procedure Finish; virtual; abstract;
    procedure IncLogicalPageNumber; virtual; abstract;
    procedure ResetLogicalPageNumber; virtual; abstract;
    procedure PasteObjects(X, Y: Extended); virtual; abstract;
    procedure ShiftAnchors(From, NewTop: Integer); virtual; abstract;
    procedure AddPicture(Picture: TfrxPictureView); virtual; abstract;
    function BandExists(Band: TfrxBand): Boolean; virtual; abstract;
    function GetCurPosition: Integer; virtual; abstract;
    function GetAnchorCurPosition: Integer; virtual; abstract;
    function GetLastY(ColumnPosition: Extended = 0): Extended; virtual; abstract;
    function GetLogicalPageNo: Integer; virtual; abstract;
    function GetLogicalTotalPages: Integer; virtual; abstract;
    procedure AddEmptyPage(Index: Integer); virtual; abstract;
    procedure DeletePage(Index: Integer); virtual; abstract;
    procedure ModifyPage(Index: Integer; Page: TfrxReportPage); virtual; abstract;
    procedure ModifyObject(Component: TfrxComponent); virtual; abstract;
    procedure DrawPage(Index: Integer; Canvas: TCanvas; ScaleX, ScaleY,
      OffsetX, OffsetY: Extended; bHighlightEditable: Boolean = False); virtual; abstract;
    procedure ObjectOver(Index: Integer; X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; Scale, OffsetX, OffsetY: Extended;
      var EventParams: TfrxPreviewIntEventParams); virtual; abstract;
    procedure AddFrom(Report: TfrxReport); virtual; abstract;

    procedure LoadFromStream(Stream: TStream;
      AllowPartialLoading: Boolean = False); virtual; abstract;
    procedure SaveToStream(Stream: TStream); virtual; abstract;
    function SaveToFilter(Filter: TfrxCustomIOTransport; const FileName: String): Boolean; virtual; abstract;
    function LoadFromFile(const FileName: String;
      ExceptionIfNotFound: Boolean = False): Boolean; virtual; abstract;
    procedure SaveToFile(const FileName: String); virtual; abstract;
    function Print: Boolean; virtual; abstract;
    function Export(Filter: TfrxCustomExportFilter): Boolean; virtual; abstract;

    property AddPageAction: TfrxAddPageAction read FAddPageAction write FAddPageAction;
    property Count: Integer read GetCount;
    property CurPage: Integer read FCurPage write FCurPage;
    property CurPreviewPage: Integer read FCurPreviewPage write FCurPreviewPage;
    property Engine: TfrxCustomEngine read FEngine write FEngine;
    property FirstPage: Integer read FFirstPage write FFirstPage;
    property Outline: TfrxCustomOutline read FOutline;
    property Page[Index: Integer]: TfrxReportPage read GetPage;
    property PageSize[Index: Integer]: TPoint read GetPageSize;
    property Report: TfrxReport read FReport;
    property PostProcessor: TfrxPostProcessor read FPostProcessor;
  end;

  TfrxCustomPreview = class(TCustomControl)
  private
    FPreviewPages: TfrxCustomPreviewPages;
    FReport: TfrxReport;
    FUseReportHints: Boolean;
  protected
    FPreviewForm: TForm;
    FInPlaceditorsList: TfrxComponentEditorsList;
    FSelectionList: TfrxSelectedObjectsList;
    procedure DoFinishInPlace(Sender: TObject; Refresh, Modified: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetDefaultEventParams(var EventParams: TfrxInteractiveEventsParams); virtual;
    function Init(aReport: TfrxReport; aPrevPages: TfrxCustomPreviewPages): Boolean; virtual; abstract;
    procedure UnInit(aPreviewPages: TfrxCustomPreviewPages); virtual; abstract;
    procedure Lock; virtual; abstract;
    procedure Unlock; virtual; abstract;
    procedure RefreshReport; virtual; abstract;
    procedure InternalCopy; virtual;
    procedure InternalPaste; virtual;
    function InternalIsPasteAvailable: Boolean; virtual;
    procedure InternalOnProgressStart(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); virtual; abstract;
    procedure InternalOnProgress(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); virtual; abstract;
    procedure InternalOnProgressStop(Sender: TfrxReport;
      ProgressType: TfrxProgressType; Progress: Integer); virtual; abstract;

    property PreviewPages: TfrxCustomPreviewPages read FPreviewPages write FPreviewPages;
    property Report: TfrxReport read FReport write FReport;
    property UseReportHints: Boolean read FUseReportHints write FUseReportHints;
  end;

  TfrxCompressorClass = class of TfrxCustomCompressor;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxCustomCompressor = class(TComponent)
  private
    FIsFR3File: Boolean;
    FOldCompressor: TfrxCompressorClass;
    FReport: TfrxReport;
    FStream: TStream;
    FTempFile: String;
    FFilter: TfrxSaveToCompressedFilter;
    procedure SetIsFR3File(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Decompress(Source: TStream): Boolean; virtual; abstract;
    procedure Compress(Dest: TStream); virtual; abstract;
    procedure CreateStream;
    property IsFR3File: Boolean read FIsFR3File write SetIsFR3File;
    property Report: TfrxReport read FReport write FReport;
    property Stream: TStream read FStream write FStream;
  end;

  TfrxCrypterClass = class of TfrxCustomCrypter;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxCustomCrypter = class(TComponent)
  private
    FStream: TStream;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Decrypt(Source: TStream; const Key: AnsiString): Boolean; virtual; abstract;
    procedure Crypt(Dest: TStream; const Key: AnsiString); virtual; abstract;
    procedure CreateStream;
    property Stream: TStream read FStream write FStream;
  end;

  TfrxLoadEvent = function(Sender: TfrxReport; Stream: TStream): Boolean of object;
  TfrxGetScriptValueEvent = function(var Params: Variant): Variant of object;

  TfrxFR2Events = class(TObject)
  private
    FOnGetValue: TfrxGetValueEvent;
    FOnPrepareScript: TNotifyEvent;
    FOnLoad: TfrxLoadEvent;
    FOnGetScriptValue: TfrxGetScriptValueEvent;
    FFilter: String;
  public
    property OnGetValue: TfrxGetValueEvent read FOnGetValue write FOnGetValue;
    property OnPrepareScript: TNotifyEvent read FOnPrepareScript write FOnPrepareScript;
    property OnLoad: TfrxLoadEvent read FOnLoad write FOnLoad;
    property OnGetScriptValue: TfrxGetScriptValueEvent read FOnGetScriptValue write FOnGetScriptValue;
    property Filter: String read FFilter write FFilter;
  end;

  TfrxGlobalDataSetList = class(TList)
{$IFNDEF NO_CRITICAL_SECTION}
    FCriticalSection: TCriticalSection;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure Unlock;
  end;

  { InPlace editors and custom draw for designer and preview }
  { remove unused properties }
  TfrxInPlaceEditor = class(TObject)
  protected
    FComponent: TfrxComponent;
    FParentComponent: TComponent;
    FOwner: TWinControl;
    FOnFinishInPlace: TfrxOnFinishInPlaceEdit;
    FClassRef: TfrxComponentClass;
    FOffsetX: Extended;
    FOffsetY: Extended;
    FScale: Extended;
    FLocked: Boolean;
    { used to call other editors }
    FEditors: TfrxComponentEditorsList;
    FComponents: TfrxSelectedObjectsList;
    FClipboardObject: TPersistent;
    procedure SetComponent(const Value: TfrxComponent);
  public
    constructor Create(aClassRef: TfrxComponentClass; aOwner: TWinControl); virtual;
    destructor Destroy; override;
    function GetActiveRect: TRect; virtual;
    function HasInPlaceEditor: Boolean; virtual;
    function HasCustomEditor: Boolean; virtual;
    procedure DrawCustomEditor(aCanvas: TCanvas; aRect: TRect); virtual;
    procedure SetOffset(aOffsetX, aOffsetY, aScale: Extended);
    function FillData: Boolean; virtual;
    procedure EditInPlace(aParent: TComponent; aRect: TRect); virtual;
    function EditInPlaceDone: Boolean; virtual;
    procedure DoFinishInPlace(Sender: TObject; Refresh, Modified: Boolean); virtual;
    function DoCustomDragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean; virtual;
    function DoCustomDragDrop(Source: TObject; X, Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean; virtual;

    function DoMouseMove(X, Y: Integer; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; virtual;
    function DoMouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; virtual;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; virtual;
    function DoMouseWheel(Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean; virtual;

    procedure InitializeUI(var EventParams: TfrxInteractiveEventsParams); virtual;
    procedure FinalizeUI(var EventParams: TfrxInteractiveEventsParams); virtual;

    procedure CopyGoupContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault); virtual;
    procedure PasteGoupContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault); virtual;

    procedure CopyContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault); virtual;
    procedure PasteContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault); virtual;
    function IsPasteAvailable(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType = cptDefault): Boolean; virtual;
    function DefaultContentType: TfrxCopyPasteType; virtual;

    property Component: TfrxComponent read FComponent write SetComponent;
    property ParentComponent: TComponent read FParentComponent write FParentComponent;
    property OnFinishInPlace: TfrxOnFinishInPlaceEdit read FOnFinishInPlace write FOnFinishInPlace;
    property Locked: Boolean read FLocked;
    property Editors: TfrxComponentEditorsList read FEditors write FEditors;
    property ClipboardObject: TPersistent read FClipboardObject write FClipboardObject;
  end;

  TfrxInPlaceEditorClass = class of TfrxInPlaceEditor;

  TfrxCustomIOTransportClass = class of TfrxCustomIOTransport;

  TfrxComponentEditorsRegItem = class(TObject)
  public
    FEditorsGlasses: TList;
    FEditorsVisibility: TList;
    FComponentClass: TfrxComponentClass;

    constructor Create;
    destructor Destroy; override;
  end;

  TfrxRectArray = array of TRect;

  TfrxComponentEditorsManager = class(TObject)
  private
    FOffsetX: Extended;
    FOffsetY: Extended;
    FScale: Extended;
    FEditorsGlasses: TList;
    FComponentClass: TfrxComponentClass;
    function GetComponent: TfrxComponent;
    procedure SetComponent(const Value: TfrxComponent);
  public
    function EditorsActiveRects(aComponent: TfrxComponent): TfrxRectArray;
    procedure DrawCustomEditor(aCanvas: TCanvas; aRect: TRect);
    function DoCustomDragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean;
    function DoCustomDragDrop(Source: TObject; X, Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
    procedure SetOffset(aOffsetX, aOffsetY, aScale: Extended);
    function DoMouseMove(X, Y: Integer; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
    function DoMouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
    function DoMouseWheel(Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean;

    procedure InitializeUI(var EventParams: TfrxInteractiveEventsParams);
    procedure FinalizeUI(var EventParams: TfrxInteractiveEventsParams);

    procedure CopyContent(CopyFrom: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType = cptDefault);
    procedure PasteContent(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType = cptDefault);
    function IsPasteAvailable(PasteTo: TfrxComponent; var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType = cptDefault): Boolean;
    function IsContain(ObjectRect: TRect; X, Y: Extended): Boolean;
    procedure SetClipboardObject(const aObject: TPersistent);
    constructor Create;
    destructor Destroy; override;
    property Component: TfrxComponent read GetComponent write SetComponent;
  end;

  TfrxComponentEditorVisibilityState = (evPreview, evDesigner);
  TfrxComponentEditorVisibility = set of TfrxComponentEditorVisibilityState;


  TfrxComponentEditorsList = class(TStringList)
  private
    FEditorsInstances: TList;
    function GetEditors(Index: Integer): TfrxComponentEditorsManager;
    procedure PutEditors(Index: Integer;
      const Value: TfrxComponentEditorsManager);
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure CreateInstanceFromItem(aItem: TfrxComponentEditorsRegItem; aOwner: TWinControl; aVisibility: TfrxComponentEditorVisibilityState);
    property Editors[Index: Integer]: TfrxComponentEditorsManager read GetEditors write PutEditors;
  end;

  TfrxComponentEditorsClasses = class(TStringList)
  private
    function GetEditors(Index: Integer): TfrxComponentEditorsRegItem;
    procedure PutEditors(Index: Integer;
      const Value: TfrxComponentEditorsRegItem);
  public
    destructor Destroy; override;
    function CreateEditorsInstances(aVisibility: TfrxComponentEditorVisibilityState; aOwner: TWinControl): TfrxComponentEditorsList;
    procedure Register(ComponentClass: TfrxComponentClass; ComponentEditors: array of TfrxInPlaceEditorClass; EditorsVisibility: array of TfrxComponentEditorVisibility);
    procedure UnRegister(ComponentClass: TfrxComponentClass);
    procedure UnRegisterEditor(EditroClass: TfrxInPlaceEditorClass);
    procedure SaveToIni(IniFile: TCustomIniFile);
    procedure LoadFromIni(IniFile: TCustomIniFile);
    property EditorsClasses[Index: Integer]: TfrxComponentEditorsRegItem read GetEditors write PutEditors;
  end;

function frxParentForm: TForm;
function frxFindDataSet(DataSet: TfrxDataSet; const Name: String;
  Owner: TComponent): TfrxDataSet;
procedure frxGetDataSetList(List: TStrings);
function frxCreateFill(const Value: TfrxFillType): TfrxCustomFill;
function frxGetFillType(const Value: TfrxCustomFill): TfrxFillType;
function frxRegEditorsClasses: TfrxComponentEditorsClasses;
function frxGetInPlaceEditor(aList: TfrxComponentEditorsList; aComponent: TfrxComponent): TfrxComponentEditorsManager;

var
  frxDefaultIOTransportClass: TfrxCustomIOTransportClass = nil;
  frxDefaultIODialogTransportClass: TfrxCustomIOTransportClass = nil;
  frxDefaultTempFilterClass: TfrxCustomIOTransportClass = nil;
  frxDesignerClass: TfrxDesignerClass;
  frxDotMatrixExport: TfrxCustomExportFilter;
  frxCompressorClass: TfrxCompressorClass;
  frxCrypterClass: TfrxCrypterClass;
  frxCharset: Integer = DEFAULT_CHARSET;
  frxFR2Events: TfrxFR2Events;
{$IFNDEF NO_CRITICAL_SECTION}
  frxCS: TCriticalSection;
{$ENDIF}
  frxGlobalVariables: TfrxVariables;
const
  FR_VERSION = {$I frxVersion.inc};
  BND_COUNT = 18;
  frxBands: array[0..BND_COUNT - 1] of TfrxComponentClass =
    (TfrxReportTitle, TfrxReportSummary, TfrxPageHeader, TfrxPageFooter,
     TfrxHeader, TfrxFooter, TfrxMasterData, TfrxDetailData, TfrxSubdetailData,
     TfrxDataBand4, TfrxDataBand5, TfrxDataBand6, TfrxGroupHeader, TfrxGroupFooter,
     TfrxChild, TfrxColumnHeader, TfrxColumnFooter, TfrxOverlay);

{$IFDEF FPC}
//  procedure Register;
{$ENDIF}

implementation

{$R *.res}

uses
  {$IFNDEF FPC}Registry,{$ENDIF}
  frxEngine, frxPreviewPages, frxPreview, frxPrinter, frxUtils, frxFileUtils,
  frxPassw, frxGraphicUtils, frxDialogForm, frxXMLSerializer,
  {$IFNDEF FPC}frxAggregate,{$ENDIF}
  frxRes, frxDsgnIntf, frxIOTransportIntf, frxrcClass, frxClassRTTI, frxInheritError, TypInfo,
  {$IFNDEF FS_SKIP_LANG_REG}fs_ipascal, fs_icpp, fs_ibasic, fs_ijs,{$ENDIF} fs_iclassesrtti,
  fs_igraphicsrtti, fs_iformsrtti, fs_idialogsrtti, fs_iinirtti, frxDMPClass,
  SysConst, StrUtils
{$IFNDEF FPC}
{$IFDEF JPEG}
, jpeg
{$ENDIF}
{$IFDEF PNG}
{$IFDEF Delphi12}
, pngimage
{$ELSE}
, frxpngimage
{$ENDIF}
{$ENDIF}
{$ENDIF};

var
  FParentForm: TForm;
  DatasetList: TfrxGlobalDataSetList;
  RegEditorsClasses: TfrxComponentEditorsClasses;

const
  DefFontName = {$IFNDEF LCLGTK2}'Arial'{$ELSE}'Nimbus Sans L'{$ENDIF};
  DefFontNameBand = 'Tahoma';
  DefFontSize = 10;

type
  TByteSet = set of 0..7;
  PByteSet = ^TByteSet;

  THackControl = class(TControl);
  THackWinControl = class(TWinControl);
  THackPersistent = class(TPersistent);
  THackThread = class(TThread);
{$IFDEF PNG}
{$IFDEF Delphi12}
  TPNGObject = class(TPngImage);
{$ENDIF}
{$ENDIF}

  TParentForm = class(TForm)
  protected
    procedure WndProc(var Message: TMessage); override;
  end;

{ TfrxStringList }
{$IFDEF NONWINFPC}
function TfrxStringList.DoCompareText(const s1, s2: string): PtrInt;
begin
  if s1 > s2 then
  Result := 1
else if s1 < s2 then
  Result := -1
else
  Result := 0;
end;
{$ENDIF}

procedure TParentForm.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_CREATEHANDLE:
      TWinControl(Message.WParam).HandleNeeded;
    WM_DESTROYHANDLE:
      THackWinControl(Message.WParam).DestroyHandle;
  else
    inherited;
  end;
end;

function Round8(e: Extended): Extended;
begin
  Result := Round(e * 100000000) / 100000000;
end;

function frxParentForm: TForm;
begin
  if FParentForm = nil then
  begin
    FParentForm := TParentForm.CreateNew(nil{$IFDEF FPC}, 1{$ENDIF});
    if not ModuleIsLib or ModuleIsPackage then // Access denied AV inside multithreaded (COM) environment
      FParentForm.HandleNeeded;
  end;
  Result := FParentForm;
end;

function frxFindDataSet(DataSet: TfrxDataSet; const Name: String;
  Owner: TComponent): TfrxDataSet;
var
  i: Integer;
  ds: TfrxDataSet;
begin
  Result := DataSet;
  if Name = '' then
  begin
    Result := nil;
    Exit;
  end;
  if Owner = nil then Exit;
  DatasetList.Lock;
  for i := 0 to DatasetList.Count - 1 do
  begin
    ds := DatasetList[i];
    if AnsiCompareText(ds.UserName, Name) = 0 then
      if not ((Owner is TfrxReport) and (ds.Owner is TfrxReport) and
        (ds.Owner <> Owner)) then
      begin
        Result := DatasetList[i];
        break;
      end;
  end;
  DatasetList.Unlock;
end;

procedure frxGetDataSetList(List: TStrings);
var
  i: Integer;
  ds: TfrxDataSet;
begin
  DatasetList.Lock;
  List.Clear;
  for i := 0 to DatasetList.Count - 1 do
  begin
    ds := DatasetList[i];
    if (ds <> nil) and (ds.UserName <> '') and ds.Enabled then
      List.AddObject(ds.UserName, ds);
  end;
  DatasetList.Unlock;
end;

procedure EmptyParentForm;
begin
  while FParentForm.ControlCount > 0 do
    FParentForm.Controls[0].Parent := nil;
end;

function ShiftToByte(Value: TShiftState): Byte;
begin
  Result := Byte(PByteSet(@Value)^);
end;

function frxCreateFill(const Value: TfrxFillType): TfrxCustomFill;
begin
  Result := nil;
  if Value = ftBrush then
    Result := TfrxBrushFill.Create
  else if Value = ftGradient then
    Result := TfrxGradientFill.Create
  else if Value = ftGlass then
    Result := TfrxGlassFill.Create;
end;

function frxGetFillType(const Value: TfrxCustomFill): TfrxFillType;
begin
  Result := ftBrush;
  if Value is TfrxGradientFill then
    Result := ftGradient
  else if Value is TfrxGlassFill then
    Result := ftGlass;
end;


{ TfrxDataset }

constructor TfrxDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled := True;
  FOpenDataSource := True;
  FRangeBegin := rbFirst;
  FRangeEnd := reLast;
  DatasetList.Lock;
  DatasetList.Add(Self);
  DatasetList.Unlock;
end;

destructor TfrxDataSet.Destroy;
begin
  DatasetList.Lock;
  DatasetList.Remove(Self);
  inherited;
  DatasetList.Unlock;
end;

procedure TfrxDataSet.SetName(const NewName: TComponentName);
begin
  inherited;
  if NewName <> '' then
    if (FUserName = '') or (FUserName = Name) then
      UserName := NewName
end;

procedure TfrxDataSet.SetUserName(const Value: String);
begin
  if Trim(Value) = '' then
    raise Exception.Create(frxResources.Get('prInvProp'));
  FUserName := Value;
end;

procedure TfrxDataSet.Initialize;
begin
end;

procedure TfrxDataSet.Finalize;
begin
end;

procedure TfrxDataSet.Close;
begin
  if Assigned(FOnClose) then FOnClose(Self);
end;

procedure TfrxDataSet.Open;
begin
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TfrxDataSet.First;
begin
  FRecNo := 0;
  FEof := False;
  if Assigned(FOnFirst) then
    FOnFirst(Self);
end;

procedure TfrxDataSet.Next;
begin
  FEof := False;
  Inc(FRecNo);
  if not ((FRangeEnd = reCount) and (FRecNo >= FRangeEndCount)) then
  begin
    if Assigned(FOnNext) then
      FOnNext(Self);
  end
  else
  begin
    FRecNo := FRangeEndCount - 1;
    FEof := True;
  end;
end;

procedure TfrxDataSet.Prior;
begin
  Dec(FRecNo);
  if Assigned(FOnPrior) then
    FOnPrior(Self);
end;

function TfrxDataSet.Eof: Boolean;
begin
  Result := False;
  if FRangeEnd = reCount then
    if (FRecNo >= FRangeEndCount) or FEof then
      Result := True;
  if Assigned(FOnCheckEOF) then
    FOnCheckEOF(Self, Result);
end;

function TfrxDataSet.GetDisplayText(Index: String): WideString;
begin
  Result := '';
end;

function TfrxDataSet.GetDisplayWidth(Index: String): Integer;
begin
  Result := 10;
end;

procedure TfrxDataSet.GetFieldList(List: TStrings);
begin
  List.Clear;
end;

function TfrxDataSet.GetValue(Index: String): Variant;
begin
  Result := Null;
end;

function TfrxDataSet.HasField(const fName: String): Boolean;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  GetFieldList(sl);
  Result := sl.IndexOf(fName) <> -1;
  sl.Free;
end;

procedure TfrxDataSet.AssignBlobTo(const fName: String; Obj: TObject);
begin
// empty method
end;

function TfrxDataSet.IsBlobField(const fName: String): Boolean;
begin
  Result := False;
end;

function TfrxDataSet.IsHasMaster: Boolean;
begin
  Result := False;
end;

function TfrxDataSet.IsWideMemoBlobField(const fName: String): Boolean;
begin
  Result := False;
end;

function TfrxDataSet.FieldsCount: Integer;
begin
  Result := 0;
end;

function TfrxDataSet.GetFieldType(Index: String): TfrxFieldType;
begin
  Result := fftNumeric;
end;

function TfrxDataSet.RecordCount: Integer;
begin
  if (RangeBegin = rbFirst) and (RangeEnd = reCount) then
    Result := RangeEndCount
  else
    Result := 0;
end;

{ TfrxUserDataSet }

procedure TfrxUserDataSet.AssignBlobTo(const FieldName: String; Obj: TObject);
begin
  if Assigned(FOnGetBlobValue) then
    FOnGetBlobValue(Self, FieldName, Obj);
end;

constructor TfrxUserDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FFields := TStringList.Create;
end;

destructor TfrxUserDataSet.Destroy;
begin
  FFields.Free;
  inherited;
end;

procedure TfrxUserDataSet.SetFields(const Value: TStrings);
begin
  FFields.Assign(Value);
end;

procedure TfrxUserDataSet.GetFieldList(List: TStrings);
begin
  List.Assign(FFields);
end;

function TfrxUserDataSet.FieldsCount: Integer;
begin
  Result := FFields.Count;
end;

function TfrxUserDataSet.GetDisplayText(Index: String): WideString;
var
  v: Variant;
begin
  Result := '';
  if Assigned(FOnGetValue) then
  begin
    v := Null;
    FOnGetValue(Index, v);
    Result := VarToWideStr(v);
  end;

  if Assigned(FOnNewGetValue) then
  begin
    v := Null;
    FOnNewGetValue(Self, Index, v);
    Result := VarToWideStr(v);
  end;
end;

function TfrxUserDataSet.GetValue(Index: String): Variant;
begin
  Result := Null;
  if Assigned(FOnGetValue) then
    FOnGetValue(Index, Result);
  if Assigned(FOnNewGetValue) then
    FOnNewGetValue(Self, Index, Result);
end;

function TfrxUserDataSet.IsBlobField(const FieldName: String): Boolean;
begin
  Result := False;
  if Assigned(FOnIsBlobField) then
    Result := FOnIsBlobField(Self, FieldName);
end;

{ TfrxCustomDBDataSet }

constructor TfrxCustomDBDataset.Create(AOwner: TComponent);
begin
  FFields := TStringList.Create;
  FFields.Sorted := True;
  FFields.Duplicates := dupIgnore;
  FAliases := TStringList.Create;
  inherited;
end;

destructor TfrxCustomDBDataset.Destroy;
begin
  FFields.Free;
  FAliases.Free;
  inherited;
end;

procedure TfrxCustomDBDataset.SetFieldAliases(const Value: TStrings);
begin
  FAliases.Assign(Value);
end;

function TfrxCustomDBDataset.ConvertAlias(const fName: String): String;
var
  i: Integer;
  s: String;
begin
  Result := fName;
  for i := 0 to FAliases.Count - 1 do
  begin
    s := FAliases[i];
    if AnsiCompareText(Copy(s, Pos('=', s) + 1, MaxInt), fName) = 0 then
    begin
      Result := FAliases.Names[i];
      break;
    end;
  end;

end;

function TfrxCustomDBDataset.GetAlias(const fName: String): String;
var
  i: Integer;
begin
  Result := fName;
  for i := 0 to FAliases.Count - 1 do
    if AnsiCompareText(FAliases.Names[i], fName) = 0 then
    begin
      Result := FAliases[i];
      Result := Copy(Result, Pos('=', Result) + 1, MaxInt);
      break;
    end;
end;

function TfrxCustomDBDataset.FieldsCount: Integer;
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    GetFieldList(sl);
  finally
    Result := sl.Count;
    sl.Free;
  end;
end;

{ TfrxDBComponents }

function TfrxDBComponents.GetDescription: String;
begin
  Result := '';
end;

{ TfrxCustomDatabase }

procedure TfrxCustomDatabase.BeforeConnect(var Value: Boolean);
begin
  if (Report <> nil) and Assigned(Report.OnBeforeConnect) then
    Report.OnBeforeConnect(Self, Value);
end;

procedure TfrxCustomDatabase.AfterDisconnect;
begin
  if (Report <> nil) and Assigned(Report.OnAfterDisconnect) then
    Report.OnAfterDisconnect(Self);
end;

function TfrxCustomDatabase.GetConnected: Boolean;
begin
  Result := False;
end;

function TfrxCustomDatabase.GetDatabaseName: String;
begin
  Result := '';
end;

function TfrxCustomDatabase.GetLoginPrompt: Boolean;
begin
  Result := False;
end;

function TfrxCustomDatabase.GetParams: TStrings;
begin
  Result := nil;
end;

procedure TfrxCustomDatabase.SetConnected(Value: Boolean);
begin
// empty
end;

procedure TfrxCustomDatabase.SetDatabaseName(const Value: String);
begin
// empty
end;

procedure TfrxCustomDatabase.FromString(const Connection: WideString);
begin
// empty
end;

function TfrxCustomDatabase.ToString: WideString;
begin
// empty
  Result := '';
end;


procedure TfrxCustomDatabase.SetLogin(const Login, Password: String);
begin
// empty
end;

procedure TfrxCustomDatabase.SetLoginPrompt(Value: Boolean);
begin
// empty
end;

procedure TfrxCustomDatabase.SetParams(Value: TStrings);
begin
// empty
end;


{ TfrxComponent }

constructor TfrxComponent.Create(AOwner: TComponent);
begin
  if AOwner is TfrxComponent then
    inherited Create(TfrxComponent(AOwner).Report)
  else
    inherited Create(AOwner);
  FAncestorOnlyStream := False;
  FComponentStyle := [csPreviewVisible];
  FBaseName := ClassName;
  Delete(FBaseName, Pos('Tfrx', FBaseName), 4);
  Delete(FBaseName, Pos('View', FBaseName), 4);
  FObjects := TfrxObjectsNotifyList.Create;
  FObjects.OnNotifyList := ObjectListNotify;
  FAllObjects := TList.Create;

  FFont := TFont.Create;
  with FFont do
  begin
    PixelsPerInch := 96;
    Name := DefFontName;
    Size := DefFontSize;
    Color := clBlack;
    Charset := frxCharset;
    OnChange := FontChanged;
  end;

  FVisible := True;
  ParentFont := True;
  if AOwner is TfrxComponent then
    SetParent(TfrxComponent(AOwner));
  FComponentEditors := nil;
  FSortedObjects := nil;
  FAnchors := [fraLeft, fraTop];
end;

constructor TfrxComponent.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  FIsDesigning := True;
  Create(AOwner);
end;

destructor TfrxComponent.Destroy;
begin
  if Assigned(FComponentEditors) then
    FComponentEditors.Component := nil;
  FComponentEditors := nil;
  if Assigned(FSortedObjects) then
    FSortedObjects.Clear;
  SetParent(nil);
  Clear;
  FFont.Free;
  FObjects.Free;
  FAllObjects.Free;
  FreeAndNil(FSortedObjects);
  if IsSelected then
    IsSelected := False;
  inherited;
end;

procedure TfrxComponent.Assign(Source: TPersistent);
var
  s: TMemoryStream;
begin
  if Source is TfrxComponent then
  begin
    s := TMemoryStream.Create;
    try
      TfrxComponent(Source).SaveToStream(s, False, True);
      s.Position := 0;
      LoadFromStream(s);
    finally
      s.Free;
    end;
  end;
end;

procedure TfrxComponent.AssignAll(Source: TfrxComponent; Streaming: Boolean = False);
var
  s: TMemoryStream;
begin
  s := TMemoryStream.Create;
  try
    Source.SaveToStream(s, True, True, Streaming);
    s.Position := 0;
    LoadFromStream(s);
  finally
    s.Free;
  end;
end;

procedure TfrxComponent.AssignAllWithOriginals(Source: TfrxComponent;
  Streaming: Boolean);

  procedure EnumObjects(ASource: TfrxComponent; ADest: TfrxComponent);
  var
    i: Integer;
  begin
    ADest.FAliasName := ASource.FAliasName;
    ADest.FOriginalComponent := ASource.FOriginalComponent;
    for i := 0 to ASource.Objects.Count - 1 do
      EnumObjects(ASource.Objects[i], ADest.Objects[i]);
  end;
begin
  AssignAll(Source, Streaming);
  EnumObjects(Source, Self);
end;

procedure TfrxComponent.LoadFromStream(Stream: TStream);
var
  Reader: TfrxXMLSerializer;
  aReport: TfrxReport;
begin
  if not FAncestorOnlyStream then
    Clear;
  aReport := Report;
  Reader := TfrxXMLSerializer.Create(Stream);
  Reader.HandleNestedProperties := True;
  //Reader.IgnoreName := True;
  if aReport <> nil then
  begin
    aReport.FXMLSerializer := Reader;
    Reader.OnGetCustomDataEvent := aReport.OnGetCustomData;
  end;

  try
    Reader.Owner := aReport;
    if (aReport <> nil) and aReport.EngineOptions.EnableThreadSafe then
    begin
{$IFNDEF NO_CRITICAL_SECTION}
      frxCS.Enter;
{$ENDIF}
      try
        Reader.ReadRootComponent(Self, nil);
      finally
{$IFNDEF NO_CRITICAL_SECTION}
        frxCS.Leave;
{$ENDIF}
      end;
    end
    else
      Reader.ReadRootComponent(Self, nil);

    if aReport <> nil then
      aReport.Errors.AddStrings(Reader.Errors);

  finally
    Reader.Free;
    if aReport <> nil then
      aReport.FXMLSerializer := nil;
  end;
end;

procedure TfrxComponent.LockAnchorsUpdate;
begin
  FAnchorsUpdating := True;
end;

procedure TfrxComponent.MirrorContent(MirrorModes: TfrxMirrorControlModes);
begin
end;

procedure TfrxComponent.MouseClick(Double: Boolean;
  var EventParams: TfrxInteractiveEventsParams);
begin
  if (EventParams.EventSender = esPreview) and ((rfDontEditInPreview in Restrictions) or (EventParams.EditRestricted)) then
    Exit;
  InintComponentInPlaceEditor(EventParams);
  DoMouseClick(Double, EventParams);
end;

function TfrxComponent.MouseDown(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  EventProcessed: Boolean;
begin
  EventProcessed := False;
  if not((EventParams.EventSender = esPreview) and
    (rfDontEditInPreview in Restrictions)) then
  begin
    InintComponentInPlaceEditor(EventParams);
    if Assigned(FComponentEditors) then
      EventProcessed := FComponentEditors.DoMouseDown(X, Y, Button, Shift,
        EventParams);
    if not EventProcessed then
    begin
        EventProcessed := DoMouseDown(X, Y, Button, Shift, EventParams);
        if (EventParams.FireParentEvent) and (Parent <> nil) and Parent.IsContain(X, Y) then
        begin
          EventProcessed := Parent.MouseDown(X, Y, Button, Shift, EventParams);
          EventParams.FireParentEvent := False;
        end;
    end;
  end;
  Result := EventProcessed;
end;

procedure TfrxComponent.MouseEnter(aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
begin
  FMouseInView := True;
  if (Parent <> nil) and not (Parent.FMouseInView) then
    Parent.MouseEnter(aPreviousObject, EventParams);

  if (EventParams.EventSender = esPreview) and ((rfDontEditInPreview in Restrictions) or (EventParams.EditRestricted)) then
    Exit;
  InintComponentInPlaceEditor(EventParams);
  DoMouseEnter(aPreviousObject, EventParams);
  if Assigned(FComponentEditors) then
    FComponentEditors.InitializeUI(EventParams);
end;

procedure TfrxComponent.MouseLeave(X, Y: Integer; aNextObject: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams);
begin
  FMouseInView := False;
  if (Parent <> nil) and (Parent.FMouseInView) and not Parent.IsContain(X, Y) then
    Parent.MouseLeave(X, Y, aNextObject, EventParams);
  if (EventParams.EventSender = esPreview) and ((rfDontEditInPreview in Restrictions) or (EventParams.EditRestricted)) then
    Exit;
  InintComponentInPlaceEditor(EventParams);
  DoMouseLeave(aNextObject, EventParams);
  if Assigned(FComponentEditors) then
    FComponentEditors.FinalizeUI(EventParams);
end;

procedure TfrxComponent.MouseMove(X, Y: Integer;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  EventProcessed: Boolean;
begin
  EventProcessed := False;
  if (EventParams.EventSender = esPreview) and ((rfDontEditInPreview in Restrictions) or (EventParams.EditRestricted)) then
    Exit;
  InintComponentInPlaceEditor(EventParams);
  if Assigned(FComponentEditors) then
    EventProcessed := FComponentEditors.DoMouseMove(X, Y, Shift, EventParams);
  if not EventProcessed then
  begin
    DoMouseMove(X, Y, Shift, EventParams);
    if (EventParams.FireParentEvent) and (Parent <> nil) and Parent.IsContain(X, Y) then
    begin
      Parent.MouseMove(X, Y, Shift, EventParams);
      EventParams.FireParentEvent := False;
    end;
  end;
end;

procedure TfrxComponent.MouseUp(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState;
  var EventParams: TfrxInteractiveEventsParams);
var
  EventProcessed: Boolean;
begin
  EventProcessed := False;
  if (EventParams.EventSender = esPreview) and ((rfDontEditInPreview in Restrictions) or (EventParams.EditRestricted)) then
    Exit;
  InintComponentInPlaceEditor(EventParams);
  if Assigned(FComponentEditors) then
    EventProcessed := FComponentEditors.DoMouseUp(X, Y, Button, Shift, EventParams);
  if not EventProcessed then
  begin
    DoMouseUp(X, Y, Button, Shift, EventParams);
    if (EventParams.FireParentEvent) and (Parent <> nil) and Parent.IsContain(X, Y) then
    begin
      Parent.MouseUp(X, Y, Button, Shift, EventParams);
      EventParams.FireParentEvent := False;
    end;
  end;
end;

function TfrxComponent.MouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  EventProcessed: Boolean;
begin
  EventProcessed := False;
  if not((EventParams.EventSender = esPreview) and ((rfDontEditInPreview in Restrictions) or (EventParams.EditRestricted))) then
  begin

    InintComponentInPlaceEditor(EventParams);
    if Assigned(FComponentEditors) then
      EventProcessed := FComponentEditors.DoMouseWheel(Shift, WheelDelta, MousePos, EventParams);
    if not EventProcessed then
    begin
        EventProcessed := DoMouseWheel(Shift, WheelDelta, MousePos, EventParams);
        if (EventParams.FireParentEvent) and (Parent <> nil) and Parent.IsContain(MousePos.X, MousePos.Y) then
        begin
          EventProcessed := Parent.MouseWheel(Shift, WheelDelta, MousePos, EventParams);
          EventParams.FireParentEvent := False;
       end;
    end;
  end;
  Result := EventProcessed;
end;

procedure TfrxComponent.SaveToStream(Stream: TStream; SaveChildren: Boolean = True;
  SaveDefaultValues: Boolean = False; Streaming: Boolean = False);
var
  Writer: TfrxXMLSerializer;
begin
  Writer := TfrxXMLSerializer.Create(Stream);
  Writer.HandleNestedProperties := True;
  Writer.SaveAncestorOnly := FAncestorOnlyStream;
  try
    Writer.Owner := Report;
    Writer.SerializeDefaultValues := SaveDefaultValues;
    // remove it after join new serialization
    // serialized from VBand
    Writer.IgnoreName := Assigned(FOriginalComponent) and (csObjectsContainer in frComponentStyle);
    if (Self is TfrxReport) or FAncestorOnlyStream then
    begin
      if not FAncestorOnlyStream then
        Writer.OnSaveCustomDataEvent := Report.OnSaveCustomData;
      Writer.OnGetAncestor := Report.DoGetAncestor;
    end;
    Writer.WriteRootComponent(Self, SaveChildren, nil, Streaming);
  finally
    Writer.Free;
  end;
end;

procedure TfrxComponent.Clear;
var
  i: Integer;
  c: TfrxComponent;
begin
  if Assigned(FSortedObjects) then
    FSortedObjects.Clear;
  i := 0;
  while i < FObjects.Count do
  begin
    c := FObjects[i];
    if (csAncestor in c.ComponentState) then
    begin
      c.Clear;
      Inc(i);
    end
    else
      c.Free;
  end;
end;

procedure TfrxComponent.SetParent(AParent: TfrxComponent);
begin
  if FParent <> AParent then
  begin
    if FParent <> nil then
      FParent.FObjects.Remove(Self);
    if AParent <> nil then
      AParent.FObjects.Add(Self);
  end;

  FParent := AParent;
  if FParent <> nil then
    SetParentFont(FParentFont);
end;

procedure TfrxComponent.SetAnchors(const Value: TfrxAnchors);
begin
  FAnchors := Value;
end;

procedure TfrxComponent.SetBounds(ALeft, ATop, AWidth, AHeight: Extended);
begin
  Left := ALeft;
  Top := ATop;
  Width := AWidth;
  Height := AHeight;
end;

function TfrxComponent.GetPage: TfrxPage;
var
  p: TfrxComponent;
begin
  if Self is TfrxPage then
  begin
    Result := TfrxPage(Self);
    Exit;
  end;

  Result := nil;
  p := Parent;
  while p <> nil do
  begin
    if p is TfrxPage then
    begin
      Result := TfrxPage(p);
      Exit;
    end;
    p := p.Parent;
  end;
end;

function TfrxComponent.GetReport: TfrxReport;
var
  p: TfrxComponent;
begin
  if Self is TfrxReport then
  begin
    Result := TfrxReport(Self);
    Exit;
  end;
  Result := nil;
  p := Parent;
  while p <> nil do
  begin
    if p is TfrxReport then
    begin
      Result := TfrxReport(p);
      Exit;
    end;
    p := p.Parent;
  end;
end;

function TfrxComponent.GetRestrictions: TfrxRestrictions;
begin
  Result := FRestrictions;
end;

function TfrxComponent.GetSortedObjects: TStringList;
var
  aTopParent: TfrxComponent;

  procedure EnumObjects(c: TfrxComponent);
  var
    i: Integer;
  begin
    if c.Name <> '' then
      FSortedObjects.AddObject(c.Name, c);
    for i := 0 to c.FObjects.Count - 1 do
      EnumObjects(c.FObjects[i]);
  end;

begin
  // Top most TfrxComponent stores sorted list (usually Page or Report)
  aTopParent := GetTopParent;
  if Assigned(aTopParent) then
  begin
    Result := aTopParent.GetSortedObjects;
    Exit;
  end;
  if not Assigned(FSortedObjects) and not(csDestroying in ComponentState) then
  begin
    FSortedObjects := TStringList.Create;
    FSortedObjects.Duplicates := dupIgnore;
    FSortedObjects.Sorted := True;
    EnumObjects(Self);
  end;
  Result := FSortedObjects;
end;

function TfrxComponent.GetTopParent: TfrxComponent;
var
  p: TfrxComponent;
begin
  Result := nil;
  p := Parent;
  while (p <> nil) and (p is TfrxComponent) do
  begin
    Result := p;
    p := p.Parent;
  end;
end;

function TfrxComponent.GetIsLoading: Boolean;
begin
  Result := FIsLoading or (csLoading in ComponentState);
end;

function TfrxComponent.GetIsSelected: Boolean;
begin
  Result := (FSelectList <> nil);
end;

function TfrxComponent.GetAbsTop: Extended;
begin
  if (Parent <> nil) and not (Parent is TfrxDialogPage) then
    Result := Parent.AbsTop + Top else
    Result := Top;
end;

function TfrxComponent.GetAbsLeft: Extended;
begin
  if (Parent <> nil) and not (Parent is TfrxDialogPage) then
    Result := Parent.AbsLeft + Left else
    Result := Left;
end;

procedure TfrxComponent.SetLeft(Value: Extended);
begin
  if not IsDesigning or not (rfDontMove in FRestrictions) then
    FLeft := Value;
end;

procedure TfrxComponent.SetTop(Value: Extended);
begin
  if not IsDesigning or not (rfDontMove in FRestrictions) then
    FTop := Value;
end;

procedure TfrxComponent.SetWidth(Value: Extended);
begin
  if not IsDesigning or not (rfDontSize in FRestrictions) then
  begin
    if (Objects.Count > 0) and not SameValue(Value, FWidth, 0.01) then
      UpdateAnchors(Value - FWidth, 0);
    FWidth := Value;
  end;
end;

procedure TfrxComponent.UnlockAnchorsUpdate;
begin
  FAnchorsUpdating := False;
end;

procedure TfrxComponent.UpdateAnchors(DeltaX, Deltay: Extended);
var
  c: TfrxComponent;
  i: Integer;
begin
  if FAnchorsUpdating then Exit;
  //if not((Self is TfrxBand) or (csObjectsContainer in frComponentStyle)) then Exit;
  FAnchorsUpdating := True;
  try
    for i := 0 to Objects.Count - 1 do
    begin
      c := TfrxComponent(Objects[i]);
      if fraRight in c.Anchors then
        if fraLeft in c.Anchors then
          c.Width := c.Width + DeltaX
        else
          c.Left := c.Left + DeltaX
      else if not(fraLeft in c.Anchors) then
        // emulates delphi's Anchor behaviour
        c.Left := c.Left + Round(DeltaX / 1.18);
      if fraBottom in c.Anchors then
        if fraTop in c.Anchors then
          c.Height := c.Height + Deltay
        else
          c.Top := c.Top + Deltay
      else if not(fraTop in c.Anchors) then
        // emulates delphi's Anchor behaviour
        c.Top := c.Top + Round(Deltay / 1.18);
    end;
  finally
    FAnchorsUpdating := False;
  end
end;

procedure TfrxComponent.UpdateBounds;
begin
//
end;

procedure TfrxComponent.SetHeight(Value: Extended);
begin
  if not IsDesigning or not (rfDontSize in FRestrictions) then
  begin
    if (Objects.Count > 0) and not SameValue(Value, FHeight, 0.01) then
      UpdateAnchors(0, Value - FHeight);
    FHeight := Value;
  end
end;

procedure TfrxComponent.SetIsSelected(const Value: Boolean);
var
  aReport: TfrxReport;
begin
  if Value then
  begin
    aReport := GetGlobalReport;
    if (aReport <> nil) and (aReport.Designer <> nil) then
      FSelectList := TfrxCustomDesigner(aReport.Designer).FSelectedObjects
    else if (aReport <> nil) and (aReport.Preview <> nil) then
      FSelectList := TfrxCustomPreview(aReport.Preview).FSelectionList;
  end
  else if Assigned(FSelectList) then
  begin
    FSelectList.Remove(Self);
    FSelectList := nil;
  end;
end;

function TfrxComponent.IsAcceptControl
(aControl: TfrxComponent): Boolean;
begin
  Result := (aControl = nil) or ((aControl <> nil) and IsAcceptControls and
    (aControl <> Self) and aControl.IsAcceptAsChild(Self) and
    not(csContained in aControl.frComponentStyle));
end;

function TfrxComponent.IsAcceptControls: Boolean;
begin
  Result := csAcceptsFrxComponents in frComponentStyle;
end;

function TfrxComponent.IsAcceptAsChild(aParent: TfrxComponent): Boolean;
begin
  Result := False;
end;

function TfrxComponent.IsContain(X, Y: Extended): Boolean;
var
  w0, w1, w2, w3: Extended;
begin
  w0 := 0;
  w1 := 0;
  w2 := 0;
  if Width = 0 then
  begin
    w0 := 4;
    w1 := 4
  end
  else if Height = 0 then
    w2 := 4;
  w3 := w2;

  Result := (X >= AbsLeft - w0) and
    (X <= AbsLeft + Width + w1) and
    (Y >= AbsTop - w2) and
    (Y <= AbsTop + Height + w3);

  if Assigned(FComponentEditors) then
    Result := Result or FComponentEditors.IsContain(Rect(Round(AbsLeft), Round(AbsTop), Round(AbsLeft + Width), Round(AbsTop + Height)), X, Y);
end;

function TfrxComponent.IsFontStored: Boolean;
begin
  Result := not FParentFont;
end;

function TfrxComponent.IsHeightStored: Boolean;
begin
  Result := True;
end;

function TfrxComponent.IsIndexTagStored: Boolean;
begin
  Result := IndexTag > 0;
end;

function TfrxComponent.IsInRect(const aRect: TfrxRect): Boolean;
var
  cLeft, cTop, cRight, cBottom, e: Extended;

  function RectInRect: Boolean;
  begin
    with aRect do
      Result := not((cLeft > Right) or (cRight < Left) or
        (cTop > Bottom) or (cBottom < Top));
  end;

begin
  cLeft := AbsLeft;
  cRight := AbsLeft + Width;
  cTop := AbsTop;
  cBottom := AbsTop + Height;

  if cRight < cLeft then
  begin
    e := cRight;
    cRight := cLeft;
    cLeft := e;
  end;
  if cBottom < cTop then
  begin
    e := cBottom;
    cBottom := cTop;
    cTop := e;
  end;
  Result := RectInRect;
end;

function TfrxComponent.IsLeftStored: Boolean;
begin
  Result := True;
end;

function TfrxComponent.IsTopStored: Boolean;
begin
  Result := True;
end;

function TfrxComponent.IsWidthStored: Boolean;
begin
  Result := True;
end;

procedure TfrxComponent.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  FParentFont := False;
end;

procedure TfrxComponent.SetParentFont(const Value: Boolean);
begin
  if Value then
    if Parent <> nil then
      Font := Parent.Font;
  FParentFont := Value;
end;

procedure TfrxComponent.SetVisible(Value: Boolean);
begin
  FVisible := Value;
end;

procedure TfrxComponent.FontChanged(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
begin
  FParentFont := False;
  for i := 0 to FObjects.Count - 1 do
  begin
    c := FObjects[i];
    if c.ParentFont then
      c.ParentFont := True;
  end;
end;

function TfrxComponent.GetAllObjects: TList;

  procedure EnumObjects(c: TfrxComponent);
  var
    i: Integer;
  begin
    if c <> Self then
      FAllObjects.Add(c);
    for i := 0 to c.FObjects.Count - 1 do
      EnumObjects(c.FObjects[i]);
  end;

begin
  FAllObjects.Clear;
  EnumObjects(Self);
  Result := FAllObjects;
end;

procedure TfrxComponent.SetName(const AName: TComponentName);
var
  c: TfrxComponent;
  Index: Integer;
  sl: TStringList;
begin
  if CompareText(AName, Name) = 0 then Exit;

  if (AName <> '') and (Report <> nil) then
  begin
    c := nil;//Report.FindObject(AName);
    sl := GetSortedObjects;
    Index := sl.IndexOf(AName);
    if Index <> -1 then
      c := TfrxComponent(sl.Objects[Index]);
    if (c <> nil) and (c <> Self) then
      raise EDuplicateName.Create(frxResources.Get('prDupl'));
    if IsAncestor then
      raise Exception.CreateFmt(frxResources.Get('clCantRen'), [Name]);
    Index := sl.IndexOf(Name);
    if Index <> - 1 then
      sl.Delete(Index);
    sl.AddObject(AName, Self)
  end;
  inherited;
end;

procedure TfrxComponent.CreateUniqueName(DefaultReport: TfrxReport);
var
  i, Index: Integer;
  sl: TStringList;
begin
  if Assigned(DefaultReport) then
    sl := DefaultReport.GetSortedObjects
  else
    sl := GetSortedObjects;
  i := 1;
  // trick when we have a lot of objects and call CreateUniqueName often
  // Like with big tables
  // we add two fake items, one will be on top and other on bottom of the FBaseName + I obects
  // it sets name index based on object count of this type
  // such trick allows to reduce cycles when creating lots of objects
  if sl.Count > 3 then
  begin
    Index := sl.Add(String(FBaseName) + '0');
    Index := sl.Add(String(FBaseName) + 'A') - Index;
    i := Index - 1;
    while sl.IndexOf(String(FBaseName) + IntToStr(i)) = -1 do
      Dec(i);
  end;

  while sl.IndexOf(String(FBaseName) + IntToStr(i)) <> -1 do
    Inc(i);
  SetName(String(FBaseName) + IntToStr(i));
  { Report is parent for object }
  if (DefaultReport = nil) or (sl = GetSortedObjects) then
    sl.AddObject(String(FBaseName) + IntToStr(i), Self);
end;

function TfrxComponent.Diff(AComponent: TfrxComponent): String;
begin
  Result := InternalDiff(AComponent);
end;

function TfrxComponent.DiffFont(f1, f2: TFont; const Add: String): String;
var
  fs: Integer;
begin
  Result := '';

  if f1.Name <> f2.Name then
    Result := Result + Add + 'Font.Name="' + frxStrToXML(f1.Name) + '"';
  if f1.Size <> f2.Size then
    Result := Result + Add + 'Font.Size="' + IntToStr(f1.Size) + '"';
  if f1.Color <> f2.Color then
    Result := Result + Add + 'Font.Color="' + IntToStr(f1.Color) + '"';
  if f1.Style <> f2.Style then
  begin
    fs := 0;
    if fsBold in f1.Style then fs := 1;
    if fsItalic in f1.Style then fs := fs or 2;
    if fsUnderline in f1.Style then fs := fs or 4;
    if fsStrikeout in f1.Style then fs := fs or 8;
    Result := Result + Add + 'Font.Style="' + IntToStr(fs) + '"';
  end;
  if f1.Charset <> f2.Charset then
    Result := Result + Add + 'Font.Charset="' + IntToStr(f1.Charset) + '"';
end;

function TfrxComponent.DoDragDrop(Source: TObject; X, Y: Integer;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  // if result = False then parent window should precess event in parent control
  Result := False;
end;

function TfrxComponent.DoDragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
//  DrawHighlights := True;
  // if result = False then parent window should precess event in parent control
  Result := False;
end;

procedure TfrxComponent.DoMirror(MirrorModes: TfrxMirrorControlModes);
begin
  if (mcmOnlySelected in MirrorModes) and not IsSelected then Exit;
  MirrorContent(MirrorModes);

  if Assigned(FParent) then
  begin
    if ((mcmRTLObjects in MirrorModes) and (Objects.Count = 0)) or
       ((mcmRTLBands in MirrorModes) and (Self is TfrxBand)) then
      Left := Left + ((FParent.Width - (Left + Width)) - Left);
    if ((mcmBTTObjects in MirrorModes) and (Objects.Count = 0)) or
      ((mcmBTTBands in MirrorModes) and (Self is TfrxBand)) then
      Top := Top + ((FParent.Height - (Top + Height)) - Top);
  end;
end;

procedure TfrxComponent.DoMouseClick(Double: Boolean;
  var EventParams: TfrxInteractiveEventsParams);
begin

end;

function TfrxComponent.DoMouseDown(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

procedure TfrxComponent.DoMouseEnter(aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
begin
end;

procedure TfrxComponent.DoMouseLeave(aNextObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
begin

end;

procedure TfrxComponent.DoMouseMove(X, Y: Integer;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
begin
//
end;

procedure TfrxComponent.DoMouseUp(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
begin
//
end;

function TfrxComponent.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

function TfrxComponent.DragDrop(Source: TObject; X, Y: Integer;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  EventProcessed: Boolean;
begin
  EventProcessed := False;
  InintComponentInPlaceEditor(EventParams);
  if Assigned(FComponentEditors) then
    EventProcessed := FComponentEditors.DoCustomDragDrop(Source, X, Y, EventParams);
  if not EventProcessed then
    EventProcessed := DoDragDrop(Source, X, Y, EventParams);
  Result := EventProcessed;
end;

function TfrxComponent.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean;
  var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  EventProcessed: Boolean;
begin
  EventProcessed := False;
  InintComponentInPlaceEditor(EventParams);
  if Assigned(FComponentEditors) then
    EventProcessed := FComponentEditors.DoCustomDragOver(Source, X, Y, State, Accept, EventParams);
  if not EventProcessed then
    EventProcessed := DoDragOver(Source, X, Y, State, Accept, EventParams);
  Result := EventProcessed;
end;

function TfrxComponent.ExportInternal(Filter: TfrxCustomExportFilter): Boolean;
begin
  Result := False;
end;

procedure TfrxComponent.InintComponentInPlaceEditor(var EventParams: TfrxInteractiveEventsParams);
begin
  if not Assigned(EventParams.EditorsList) then Exit;
  if not Assigned(FComponentEditors) then
    FComponentEditors := frxGetInPlaceEditor(EventParams.EditorsList, Self);
  if Assigned(FComponentEditors) then
    FComponentEditors.Component := Self;
  { Editor doesn't let to change component }
  { when editor is locked by another component }
  { and reset FComponentEditors to nil again }
  if Assigned(FComponentEditors) then
    FComponentEditors.SetOffset(EventParams.OffsetX, EventParams.OffsetY, EventParams.Scale);
   // FComponentEditors.Editors := EventParams.EditorsList;
end;

function TfrxComponent.InternalDiff(AComponent: TfrxComponent): String;
begin
  Result := '';

  if frxFloatDiff(FLeft, AComponent.FLeft) and IsLeftStored then
    Result := Result + ' l="' + FloatToStr(FLeft) + '"';
  if ((Self is TfrxBand) or frxFloatDiff(FTop, AComponent.FTop)) and IsTopStored then
    Result := Result + ' t="' + FloatToStr(FTop) + '"';
  if not ((Self is TfrxCustomMemoView) and TfrxCustomMemoView(Self).FAutoWidth) and IsWidthStored then
    if frxFloatDiff(FWidth, AComponent.FWidth) then
      Result := Result + ' w="' + FloatToStr(FWidth) + '"';
  if frxFloatDiff(FHeight, AComponent.FHeight) and IsHeightStored then
    Result := Result + ' h="' + FloatToStr(FHeight) + '"';
  if FVisible <> AComponent.FVisible then
    Result := Result + ' Visible="' + frxValueToXML(FVisible) + '"';
  if not FParentFont then
    Result := Result + DiffFont(FFont, AComponent.FFont, ' ');
  if FParentFont <> AComponent.FParentFont then
    Result := Result + ' ParentFont="' + frxValueToXML(FParentFont) + '"';
  if Tag <> AComponent.Tag then
    Result := Result + ' Tag="' + IntToStr(Tag) + '"';
end;

function TfrxComponent.AllDiff(AComponent: TfrxComponent): String;
var
  s: TStringStream;
  Writer: TfrxXMLSerializer;
  i: Integer;
begin
{$IFDEF Delphi12}
  s := TStringStream.Create('', TEncoding.UTF8);
{$ELSE}
  s := TStringStream.Create('');
{$ENDIF}
  Writer := TfrxXMLSerializer.Create(s);
  Writer.Owner := Report;
  Writer.WriteComponent(Self, AComponent);
  Writer.Free;

  Result := s.DataString;
  i := Pos(' ', Result);
  if i <> 0 then
  begin
    Delete(Result, 1, i);
    Delete(Result, Length(Result) - 1, 2);
  end
  else
    Result := '';
  if AComponent <> nil then
    Result := Result + ' ' + InternalDiff(AComponent);
  { cross bands and Keep mechanism fix }
  if (Self is TfrxNullBand) then
  begin
    Result := Result + ' l="' + FloatToStr(FLeft) + '"';
    Result := Result + ' t="' + FloatToStr(FTop) + '"';
  end;

  s.Free;
end;

procedure TfrxComponent.AddSourceObjects;
begin
// do nothing
end;

procedure TfrxComponent.AlignChildren(IgnoreInvisible: Boolean; MirrorModes: TfrxMirrorControlModes);
var
  i: Integer;
  c: TfrxComponent;
  sl: TStringList;
  aClientRect: TfrxRect;

  procedure DoAlign(v: TfrxView; n, dir: Integer);
  var
    i: Integer;
    c, c0: TfrxComponent;
  begin
    c0 := nil;
    i := n;
    while (i >= 0) and (i < sl.Count) do
    begin
      c := TfrxComponent(sl.Objects[i]);
      if c <> v then
        if (c.AbsTop < v.AbsTop + v.Height - 1e-4) and
          (v.AbsTop < c.AbsTop + c.Height - 1e-4) then
        begin
          { special case for baWidth }
          if (v.Align = baWidth) and
            (((dir = 1) and (c.Left > v.Left)) or
            ((dir = -1) and (c.Left + c.Width < v.Left + v.Width))) then
          begin
            Dec(i, dir);
            continue;
          end;
          c0 := c;
          break;
        end;
      Dec(i, dir);
    end;

    if (dir = 1) and (v.Align in [baLeft, baWidth]) then
      if c0 = nil then
        v.Left := aClientRect.Left else
        v.Left := c0.Left + c0.Width;

    if v.Align = baRight then
      if c0 = nil then
        v.Left := aClientRect.Right - v.Width else
        v.Left := c0.Left - v.Width;

    if (dir = -1) and (v.Align = baWidth) then
      if c0 = nil then
        v.Width := aClientRect.Right - v.Left else
        v.Width := c0.Left - v.Left;
  end;


  function IsVisibleView(c: TfrxComponent): Boolean;
  begin
    Result := (c is TfrxView) and (TfrxView(c).Align <> baHidden);
    if IgnoreInvisible then
      Result := Result and c.Visible;
  end;

begin
  if FObjects.Count = 0 then Exit;
  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupAccept;

  for i := 0 to FObjects.Count - 1 do
  begin
    c := FObjects[i];
    if IsVisibleView(c) then
    begin
      c.DoMirror(MirrorModes);
      if c.Left >= 0 then
        sl.AddObject('1' + Format('%9.2f', [c.Left]), c)
      else
        sl.AddObject('0' + Format('%9.2f', [-c.Left]), c);
    end;
  end;

  aClientRect := GetClientArea;
  { process baLeft }

  for i := 0 to sl.Count - 1 do
  begin
    c := TfrxComponent(sl.Objects[i]);
    if IsVisibleView(c) then
      if TfrxView(c).Align in [baLeft, baWidth] then
        DoAlign(TfrxView(c), i, 1);
  end;

  { process baRight }

  for i := sl.Count - 1 downto 0 do
  begin
    c := TfrxComponent(sl.Objects[i]);
    if IsVisibleView(c) then
      if TfrxView(c).Align in [baRight, baWidth] then
        DoAlign(TfrxView(c), i, -1);
  end;

  { process others }

  for i := 0 to FObjects.Count - 1 do
  begin
    c := FObjects[i];
    if IsVisibleView(c) then
    begin
      case TfrxView(c).Align of
        baCenter:
          c.Left := (aClientRect.Right - c.Width) / 2;

        baBottom:
          c.Top := aClientRect.Bottom - c.Height;

        baClient:
          begin
            c.Left := aClientRect.Left;
            c.Top := aClientRect.Top;
            c.Width := aClientRect.Right;
            c.Height := aClientRect.Bottom;
          end;
      end;
      TfrxView(c).AlignChildren(IgnoreInvisible, MirrorModes);
    end;
  end;

  sl.Free;
end;

function TfrxComponent.FindObject(const AName: String): TfrxComponent;
var
  i: Integer;
  l: TList;
begin
  Result := nil;
  l := AllObjects;
  for i := 0 to l.Count - 1 do
    if CompareText(AName, TfrxComponent(l[i]).Name) = 0 then
    begin
      Result := l[i];
      break;
    end;
end;

class function TfrxComponent.GetDescription: String;
begin
  Result := ClassName;
end;

function TfrxComponent.GetDrawTextObject: Pointer;
var
  aReport: TfrxReport;
begin
  aReport := GetGlobalReport;
  if aReport <> nil then
    Result := aReport.FDrawText else
    Result := frxDrawText;
end;

function TfrxComponent.GetGlobalReport: TfrxReport;
var
  p: TfrxComponent;
begin
  Result := Report;
  { preview report }
  if not Assigned(Result) then
  begin
    p := Parent;
    while p <> nil do
    begin
      if p is TfrxReportPage then
      begin
        Result := TfrxReportPage(p).ParentReport;
        Exit;
      end;
      p := p.Parent;
    end;
  end;
end;


function TfrxComponent.GetChildOwner: TComponent;
begin
  Result := Self;
end;

procedure TfrxComponent.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  if (Self is TfrxReport) and not TfrxReport(Self).StoreInDFM then
    Exit;
  for i := 0 to FObjects.Count - 1 do
    Proc(FObjects[i]);
end;

function TfrxComponent.GetClientArea: TfrxRect;
begin
  Result := frxRect(0, 0, Width, Height);
end;

procedure TfrxComponent.BeforeStartReport;
begin
// do nothing
end;

procedure TfrxComponent.ObjectListNotify(Ptr: Pointer;
  Action: TListNotification);
var
  SortedList: TStringList;

  procedure EnumObjects(c: TfrxComponent);
  var
    i: Integer;
  begin
    if (Action = lnAdded) then
      SortedList.AddObject(c.Name, c)
    else
    begin
      i := SortedList.IndexOf(c.Name);
      if i <> -1 then
        SortedList.Delete(i);
    end;
    for i := 0 to c.FObjects.Count - 1 do
      EnumObjects(c.FObjects[i]);
  end;

begin
  if (TfrxComponent(Ptr).Name = '') then
    Exit;

  if (Action = lnDeleted) and (Assigned(Parent) or Assigned(FSortedObjects)) then
  begin
    SortedList := GetSortedObjects;
    if Assigned(SortedList) and (SortedList.Count > 0) then
      EnumObjects(TfrxComponent(Ptr));
  end;
  if (Action = lnAdded) then
  begin
    SortedList := GetSortedObjects;
    EnumObjects(TfrxComponent(Ptr));
    FreeAndNil(TfrxComponent(Ptr).FSortedObjects);
  end;
end;

procedure TfrxComponent.OnNotify(Sender: TObject);
begin
// do nothing
end;

procedure TfrxComponent.OnPaste;
begin
//
end;

function TfrxComponent.GetIsAncestor: Boolean;
begin
  Result := (csAncestor in ComponentState) or FAncestor;
end;

function TfrxComponent.FindDataSet(DataSet: TfrxDataSet; const DSName: String): TfrxDataSet;
var
  DSItem:TfrxDataSetItem;
  AReport: TfrxReport;
begin
  Result := nil;
  if Self is TfrxReport then
    AReport := TfrxReport(Self)
  else AReport := Report;
  if (AReport <> nil) and not AReport.EngineOptions.UseGlobalDataSetList then
  begin
    DSItem := AReport.EnabledDataSets.Find(DSName);
    if DSItem <> nil then Result := DSItem.FDataSet;
  end
  else
    Result := frxFindDataSet(DataSet, DSName, AReport);
end;

function TfrxComponent.GetContainedComponent(X, Y: Extended;
  IsCanContain: TfrxComponent): TfrxComponent;
var
  i: Integer;
  c: TfrxComponent;
begin
  Result := nil;
  // TODO for components with child need to increase rect for outbound objects
  if IsContain(X, Y) or (Objects.Count > 0) then
  begin
    if (Objects.Count = 0) or IsContain(X, Y) then
      Result := Self;
    for i := Objects.Count -1 downto 0 do
    begin
      if TObject(Objects[i]) is TfrxComponent then
      begin
        c := TfrxComponent(Objects[i]).GetContainedComponent(X, Y, IsCanContain);
        if (c <> nil) and not (c is TfrxNullBand) then
        begin
          Result := c;
          break;
        end;
      end;
    end;
  end;
  if (Result = Self) and ((IsCanContain = Self) or (not IsAcceptControl(IsCanContain))) then
    Result := nil;
end;

procedure TfrxComponent.GetContainedComponents(const aRect: TfrxRect;
  InheriteFrom: TClass; aComponents: TList; bSelectContainers: Boolean);
var
  i: Integer;
begin
  if not Assigned(aComponents) then Exit;
  // TODO for components with child need to increase rect for outbound objects
  if IsInRect(aRect) or (Objects.Count > 0) then
  begin
    if not bSelectContainers then
      bSelectContainers := not (csObjectsContainer in frComponentStyle);
    if (aComponents.IndexOf(Self) = -1) and bSelectContainers and
      ((Objects.Count = 0) or IsInRect(aRect)) and InheritsFrom(InheriteFrom)
    then
      aComponents.Add(Self);
    for i := 0 to Objects.Count -1 do
      if TObject(Objects[i]) is TfrxComponent then
        TfrxComponent(Objects[i]).GetContainedComponents(aRect, InheriteFrom, aComponents);
  end;
end;


function TfrxComponent.GetContainerObjects: TList;
begin
  Result := FObjects;
end;

function TfrxComponent.ContainerAdd(Obj: TfrxComponent): Boolean;
begin
  Result := False;
end;

procedure TfrxComponent.WriteNestedProperties(Item: TfrxXmlItem; aAcenstor: TPersistent = nil);
begin
end;

function TfrxComponent.ReadNestedProperty(Item: TfrxXmlItem): Boolean;
begin
  Result := False;
end;


{ TfrxReportComponent }

constructor TfrxReportComponent.Create(AOwner: TComponent);
begin
  inherited;
  //FShiftChildren := TList.Create;
  FOriginalObjectsCount := -1;
end;

destructor TfrxReportComponent.Destroy;
var
  msg: TfrxDispatchMessage;
begin
  //FShiftChildren.Free;
  if Assigned(FShiftObject) then
  begin
    msg.MsgID := FRX_OWNER_DESTROY_MESSAGE;
    msg.Sender := Self;
    FShiftObject.DefaultHandler(msg);
    FShiftObject := nil;
  end;
  inherited;
end;

//procedure TfrxReportComponent.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
//  OffsetY: Extended; Highlighted: Boolean);
//begin
//  { support for old Draw interface}
//  FHighlightedCall := True;
//  try
//    Draw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
//  finally
//    FHighlightedCall := False;
//  end;
//end;
//
//procedure TfrxReportComponent.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
//  OffsetY: Extended);
//begin
//  if not FHighlightedCall then
//    Draw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY, False);
//end;

procedure TfrxReportComponent.DrawChilds(Canvas: TCanvas; ScaleX, ScaleY,
  OffsetX, OffsetY: Extended; Highlighted: Boolean; IsDesigning: Boolean);
var
  i: Integer;
  c: TfrxReportComponent;
begin
  for i := 0 to Objects.Count - 1 do
    if TObject(Objects[i]) is TfrxReportComponent then
    begin
      c := TfrxReportComponent(Objects[i]);
      c.IsDesigning := IsDesigning;
      if not c.IsOwnerDraw then
        c.InteractiveDraw(Canvas, ScaleX, ScaleY, OffsetX,
          OffsetY, Highlighted);
    end;
end;

procedure TfrxReportComponent.DrawHighlight(Canvas: TCanvas; ScaleX, ScaleY,
  OffsetX, OffsetY: Extended; hlColor: TColor);
begin

end;

procedure TfrxReportComponent.DrawSizeBox(aCanvas: TCanvas; aScale: Extended; bForceDraw: Boolean);
var
  px, py: Extended;

  procedure DrawPoint(x, y: Extended);
  var
    i, w: Integer;
  begin
    if aScale > 1.7 then
      w := 7
    else if aScale < 0.7 then
      w := 3 else
      w := 5;
    for i := 0 to w - 1 do
    begin
      aCanvas.MoveTo(Round(x * aScale) - w div 2, Round(y * aScale) - w div 2 + i);
      aCanvas.LineTo(Round(x * aScale) + w div 2  +1, Round(y * aScale) - w div 2 + i);
    end;
  end;

begin
  if not (Assigned(FSelectList) and IsDesigning) and not bForceDraw then Exit;
  with aCanvas do
  begin
    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Mode := pmXor;
    Pen.Color := clWhite;
    px := AbsLeft + Self.Width / 2;
    py := AbsTop + Self.Height / 2;

    DrawPoint(AbsLeft, AbsTop);
    if not(Self is TfrxCustomLineView) then
    begin
      DrawPoint(AbsLeft + Self.Width, AbsTop);
      DrawPoint(AbsLeft, AbsTop + Self.Height);
    end;
    //if (SelectedCount > 1) and (c = GetRightBottomObject) then
    //  Pen.Color := clTeal;
    DrawPoint(AbsLeft + Self.Width, AbsTop + Self.Height);

    Pen.Color := clWhite;
    if (bForceDraw or (FSelectList.Count = 1)) and not(Self is TfrxCustomLineView) then
    begin
      DrawPoint(px, AbsTop);
      DrawPoint(px, AbsTop + Self.Height);
      DrawPoint(AbsLeft, py);
      DrawPoint(AbsLeft + Self.Width, py);
    end;

    Pen.Mode := pmCopy;
  end;
end;

procedure TfrxReportComponent.DrawWithChilds(Canvas: TCanvas; ScaleX, ScaleY,
  OffsetX, OffsetY: Extended; Highlighted, IsDesigning: Boolean);
begin
  InteractiveDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY, Highlighted);
  DrawChilds(Canvas, ScaleX, ScaleY, OffsetX, OffsetY, Highlighted, IsDesigning);
end;

procedure TfrxReportComponent.GetData;
begin
// do nothing
end;

procedure TfrxReportComponent.BeforePrint;
begin
  FOriginalRect := frxRect(Left, Top, Width, Height);
end;

procedure TfrxReportComponent.AfterPrint;
begin
  with FOriginalRect do
    SetBounds(Left, Top, Right, Bottom);
end;

function TfrxReportComponent.GetComponentText: String;
begin
  Result := '';
end;

function TfrxReportComponent.GetRealBounds: TfrxRect;
begin
  Result := frxRect(AbsLeft, AbsTop, AbsLeft + Width, AbsTop + Height);
end;


function TfrxReportComponent.GetSaveToComponent: TfrxReportComponent;
begin
  Result := Self;
end;

procedure TfrxReportComponent.InteractiveDraw(Canvas: TCanvas; ScaleX, ScaleY,
  OffsetX, OffsetY: Extended; Highlighted: Boolean; hlColor: TColor);
begin
  FHighlighted := Highlighted;
  Draw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  FHighlighted := False;
  //DrawSizeBox(Canvas, ScaleX, False);
  if {(IsDesigning and FHighlighted and IsSelected) or} Highlighted or
    (not IsDesigning and IsSelected) then
    DrawHighlight(Canvas, ScaleX, ScaleY, OffsetX, OffsetY, hlColor);
end;

function TfrxReportComponent.IsOwnerDraw: Boolean;
begin
  Result := False;
end;

{ TfrxDialogComponent }

constructor TfrxDialogComponent.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csPreviewVisible];
  Width := 28;
  Height := 28;
end;

destructor TfrxDialogComponent.Destroy;
begin
  if FComponent <> nil then
    FComponent.Free;
  FComponent := nil;
  inherited;
end;

procedure TfrxDialogComponent.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('pLeft', ReadLeft, WriteLeft, Report <> nil);
  Filer.DefineProperty('pTop', ReadTop, WriteTop, Report <> nil);
end;

procedure TfrxDialogComponent.ReadLeft(Reader: TReader);
begin
  Left := Reader.ReadInteger;
end;

procedure TfrxDialogComponent.ReadTop(Reader: TReader);
begin
  Top := Reader.ReadInteger;
end;

procedure TfrxDialogComponent.WriteLeft(Writer: TWriter);
begin
  Writer.WriteInteger(Round(Left));
end;

procedure TfrxDialogComponent.WriteTop(Writer: TWriter);
begin
  Writer.WriteInteger(Round(Top));
end;

procedure TfrxDialogComponent.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  r: TRect;
  i, w, ImageIndex: Integer;
  Item: TfrxObjectItem;
begin
  Width := 28;
  Height := 28;
  r := Rect(Round(Left), Round(Top), Round(Left + 28), Round(Top + 28));
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(r);
  DrawEdge(Canvas.Handle, r, EDGE_RAISED, BF_RECT);

  ImageIndex := -1;
  for i := 0 to frxObjects.Count - 1 do
  begin
    Item := frxObjects[i];
    if Item.ClassRef = ClassType then
    begin
      ImageIndex := Item.ButtonImageIndex;
      break;
    end;
  end;

  if ImageIndex <> -1 then
    frxResources.ObjectImages.Draw(Canvas, r.Left + 6, r.Top + 6, ImageIndex);

  Canvas.Font.Name := 'Tahoma';
  Canvas.Font.Size := 8;
  Canvas.Font.Color := clBlack;
  Canvas.Font.Style := [];
  w := Canvas.TextWidth(Name);
  Canvas.Brush.Color := clWindow;
  Canvas.TextOut(r.Left - (w - 28) div 2, r.Bottom + 4, Name);
end;


{ TfrxDialogControl }

constructor TfrxDialogControl.Create(AOwner: TComponent);
begin
  inherited;
  FBaseName := ClassName;
  Delete(FBaseName, Pos('Tfrx', FBaseName), 4);
  Delete(FBaseName, Pos('Control', FBaseName), 7);
end;

destructor TfrxDialogControl.Destroy;
begin
  inherited;
  if FControl <> nil then
    FControl.Free;
  FControl := nil;
end;

procedure TfrxDialogControl.InitControl(AControl: TControl);
begin
  FControl := AControl;
  with THackControl(FControl) do
  begin
    OnClick := DoOnClick;
    OnDblClick := DoOnDblClick;
    OnMouseDown := DoOnMouseDown;
    OnMouseMove := DoOnMouseMove;
    OnMouseUp := DoOnMouseUp;
    OnMouseWheel := DoOnMouseWheel;
  end;
  if FControl is TWinControl then
    with THackWinControl(FControl) do
    begin
      OnEnter := DoOnEnter;
      OnExit := DoOnExit;
      OnKeyDown := DoOnKeyDown;
      OnKeyPress := DoOnKeyPress;
      OnKeyUp := DoOnKeyUp;
    end;
  SetParent(Parent);
end;

function TfrxDialogControl.IsAcceptAsChild(aParent: TfrxComponent): Boolean;
begin
  Result := (aParent is TfrxDialogPage) or (aParent is TfrxDialogControl);
end;

function TfrxDialogControl.IsAcceptControls: Boolean;
begin
  Result := csAcceptsControls in FControl.ControlStyle;
end;

function TfrxDialogControl.IsOwnerDraw: Boolean;
begin
  Result := False;
  if Assigned(Parent) and (Parent is TfrxDialogControl) then
    Result := TfrxDialogControl(Parent).IsOwnerDraw;
//  Result := Result or (csAcceptsFrxComponents in frComponentStyle);
end;

procedure TfrxDialogControl.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  Bmp: TBitmap;
  MemDC: HDC;
  OldBitmap: HBITMAP;
begin
  Bmp := TBitmap.Create;
  Bmp.Width := Round(Width);
  Bmp.Height := Round(Height);
  Bmp.Canvas.Brush.Color := clBtnFace;
  Bmp.Canvas.FillRect(Rect(0, 0, Round(Width) + 1, Round(Height) + 1));

  Canvas.Lock;
  try
    {$IFDEF FPC}
    //some widgetsets like qt and carbon does not like such constructs
    //so we simple draw everyting onto Bmp.Canvas
    if FControl is TWinControl then
      TWinControl(FControl).PaintTo(Bmp.Canvas.Handle, 0, 0)
    else
    begin
      FControl.Perform(WM_ERASEBKGND, Bmp.Canvas.Handle, MakeLParam(Round(Left), Round(Top)));
      FControl.Perform(WM_PAINT, Bmp.Canvas.Handle, MakeLParam(Round(Left), Round(Top)));
    end;
    {$ELSE}

    MemDC := CreateCompatibleDC(0);
    OldBitmap := SelectObject(MemDC, Bmp.Handle);
    if FControl is TWinControl then
      TWinControl(FControl).PaintTo(MemDC, 0, 0)
    else
    begin
      FControl.Perform(WM_ERASEBKGND, MemDC, 0);
      FControl.Perform(WM_PAINT, MemDC, 0);
    end;
    SelectObject(MemDC, OldBitmap);
    DeleteDC(MemDC);
    {$ENDIF}
  finally
    Canvas.Unlock;
  end;

  Canvas.Draw(Round(AbsLeft), Round(AbsTop), Bmp);
  Bmp.Free;
end;

function TfrxDialogControl.GetCaption: String;
begin
  Result := THackControl(FControl).Caption;
end;

function TfrxDialogControl.GetColor: TColor;
begin
  Result := THackControl(FControl).Color;
end;

function TfrxDialogControl.GetEnabled: Boolean;
begin
  Result := FControl.Enabled;
end;

procedure TfrxDialogControl.SetLeft(Value: Extended);
begin
  inherited;
  FControl.Left := Round(Left);
end;

procedure TfrxDialogControl.SetTop(Value: Extended);
begin
  inherited;
  FControl.Top := Round(Top);
end;

procedure TfrxDialogControl.SetWidth(Value: Extended);
begin
  inherited;
  FControl.Width := Round(Width);
end;

procedure TfrxDialogControl.SetHeight(Value: Extended);
begin
  inherited;
  FControl.Height := Round(Height);
end;

procedure TfrxDialogControl.SetVisible(Value: Boolean);
begin
  inherited;
  FControl.Visible := Visible;
end;

procedure TfrxDialogControl.SetAnchors(const Value: TfrxAnchors);

  function frAnchorToControl(const Anchors: TfrxAnchors): TAnchors;
  begin
    Result := [];
    if fraLeft in Anchors then
      Result := [akLeft];
    if fraRight in Anchors then
      Result := Result + [akRight];
    if fraTop in Anchors then
      Result := Result + [akTop];
    if fraBottom in Anchors then
      Result := Result + [akBottom];
  end;
begin
  inherited;
  FControl.Anchors := frAnchorToControl(Anchors);
end;

procedure TfrxDialogControl.SetCaption(const Value: String);
begin
  THackControl(FControl).Caption := Value;
end;

procedure TfrxDialogControl.SetColor(const Value: TColor);
begin
  THackControl(FControl).Color := Value;
end;

procedure TfrxDialogControl.SetEnabled(const Value: Boolean);
begin
  FControl.Enabled := Value;
end;

function TfrxDialogControl.GetHint: String;
begin
  Result := FControl.Hint;
end;

procedure TfrxDialogControl.SetHint(const Value: String);
begin
  FControl.Hint := Value;
end;

function TfrxDialogControl.GetShowHint: Boolean;
begin
  Result := FControl.ShowHint;
end;

procedure TfrxDialogControl.SetShowHint(const Value: Boolean);
begin
  FControl.ShowHint := Value;
end;

function TfrxDialogControl.GetTabStop: Boolean;
begin
  Result := True;
  if FControl is TWinControl then
    Result := THackWinControl(FControl).TabStop;
end;

procedure TfrxDialogControl.SetTabStop(const Value: Boolean);
begin
  if FControl is TWinControl then
    THackWinControl(FControl).TabStop := Value;
end;

procedure TfrxDialogControl.FontChanged(Sender: TObject);
begin
  inherited;
  if FControl <> nil then
    THackControl(FControl).Font.Assign(Font);
end;

procedure TfrxDialogControl.SetParentFont(const Value: Boolean);
begin
  inherited;
  if FControl <> nil then
    THackControl(FControl).ParentFont := Value;
end;

procedure TfrxDialogControl.SetParent(AParent: TfrxComponent);
begin
  inherited;
  if FControl <> nil then
    if AParent is TfrxDialogControl then
      FControl.Parent := TWinControl(TfrxDialogControl(AParent).Control)
    else if AParent is TfrxDialogPage then
      FControl.Parent := TfrxDialogPage(AParent).DialogForm
    else
      FControl.Parent := frxParentForm;
end;

procedure TfrxDialogControl.SetName(const AName: TComponentName);
var
  ChangeText: Boolean;
begin
  ChangeText := (csSetCaption in FControl.ControlStyle) and (Name = Caption) and
    not IsLoading;
  inherited SetName(AName);
  if ChangeText then
    Caption := AName;
end;

procedure TfrxDialogControl.DoOnClick(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnClick, True);
end;

procedure TfrxDialogControl.DoOnDblClick(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnDblClick, True);
end;

procedure TfrxDialogControl.DoOnEnter(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnEnter, True);
end;

procedure TfrxDialogControl.DoOnExit(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnExit, True);
end;

procedure TfrxDialogControl.DoOnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Key, ShiftToByte(Shift)]);
  if (Report <> nil) and (FOnKeyDown <> '') then
  begin
    Report.DoParamEvent(FOnKeyDown, v, True);
    Key := v[1];
  end;
end;

procedure TfrxDialogControl.DoOnKeyPress(Sender: TObject; var Key: Char);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Key]);
  if (Report <> nil) and (FOnKeyPress <> '') then
  begin
    Report.DoParamEvent(FOnKeyPress, v, True);
    if VarToStr(v[1]) <> '' then
      Key := VarToStr(v[1])[1]
    else
      Key := Chr(0);
  end;
end;

procedure TfrxDialogControl.DoOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Key, ShiftToByte(Shift)]);
  if (Report <> nil) and (FOnKeyUp <> '') then
  begin
    Report.DoParamEvent(FOnKeyUp, v, True);
    Key := v[1];
  end;
end;

procedure TfrxDialogControl.DoOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Button, ShiftToByte(Shift), X, Y]);
  if Report <> nil then
    Report.DoParamEvent(FOnMouseDown, v, True);
end;

procedure TfrxDialogControl.DoOnMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  v: Variant;
begin
  if (Report <> nil) and (Hint <> '') and ShowHint then
  begin
    Report.SetProgressMessage(GetLongHint(Self.Hint), True);
  end;
  v := VarArrayOf([frxInteger(Self), ShiftToByte(Shift), X, Y]);
  if Report <> nil then
    Report.DoParamEvent(FOnMouseMove, v, True);
end;

procedure TfrxDialogControl.DoOnMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Self), Button, ShiftToByte(Shift), X, Y]);
  if Report <> nil then
    Report.DoParamEvent(FOnMouseUp, v, True);
end;


procedure TfrxDialogControl.DoOnMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin

end;

{ TfrxHyperlink }

procedure TfrxHyperlink.AssignVariables(aReport: TfrxReport);
var
  VarIdx, idx: Integer;
  VariablesList, ValuesList: TStringList;
  lVal: Variant;

  procedure SetVar(aVariable: String; aValue: Variant);
  begin
    VarIdx := aReport.Variables.IndexOf(aVariable);
    if VarIdx <> - 1 then
      aReport.Variables.Items[VarIdx].Value := aValue;
  end;

begin
  if Pos(FValuesSeparator, ReportVariable) <> 0 then
  begin
    VariablesList := TStringList.Create;
    ValuesList := TStringList.Create;
    try
      frxParseDilimitedText(VariablesList, ReportVariable, FValuesSeparator[1]);
      frxParseDilimitedText(ValuesList, VarToStr(FValue), FValuesSeparator[1]);
      if ValuesList.Count = 0 then
        lVal := FValue;
      for idx := 0 to VariablesList.Count - 1 do
      begin
        if ValuesList.Count > idx then
          lVal := ValuesList[idx];
        SetVar(VariablesList[idx], lVal);
      end;
    finally
      VariablesList.Free;
      ValuesList.Free;
    end;
  Exit;
  end;
  SetVar(ReportVariable, Value);
end;

constructor TfrxHyperlink.Create;
begin
  FValuesSeparator := ';';
end;

procedure TfrxHyperlink.Assign(Source: TPersistent);
begin
  if Source is TfrxHyperlink then
  begin
    FKind := (Source as TfrxHyperlink).Kind;
    FDetailReport := (Source as TfrxHyperlink).DetailReport;
    FDetailPage := (Source as TfrxHyperlink).DetailPage;
    FReportVariable := (Source as TfrxHyperlink).ReportVariable;
    FExpression := (Source as TfrxHyperlink).Expression;
    FValue := (Source as TfrxHyperlink).Value;
    FValuesSeparator := (Source as TfrxHyperlink).ValuesSeparator;
    FTabCaption := (Source as TfrxHyperlink).FTabCaption;
  end;
end;

function TfrxHyperlink.IsValuesSeparatorStored: Boolean;
begin
  Result := FValuesSeparator <> ';';
end;

function TfrxHyperlink.Diff(ALink: TfrxHyperlink; const Add: String): String;
begin
  Result := '';

  if FKind <> ALink.FKind then
    Result := Result + ' ' + Add + '.Kind="' + frxValueToXML(FKind) + '"';
  if FDetailReport <> ALink.FDetailReport then
    Result := Result + ' ' + Add + '.DetailReport="' + frxStrToXML(FDetailReport) + '"';
  if FDetailPage <> ALink.FDetailPage then
    Result := Result + ' ' + Add + '.DetailPage="' + frxStrToXML(FDetailPage) + '"';
  if FReportVariable <> ALink.FReportVariable then
    Result := Result + ' ' + Add + '.ReportVariable="' +  frxStrToXML(FReportVariable) + '"';
  if FTabCaption <> ALink.FTabCaption then
    Result := Result + ' ' + Add + '.TabCaption="' + frxStrToXML(FTabCaption) + '"';
  if FValue <> ALink.FValue then
    Result := Result + ' ' + Add + '.Value="' + frxStrToXML(FValue) + '"';
  if FValuesSeparator <> ALink.FValuesSeparator then
    Result := Result + ' ' + Add + '.ValuesSeparator="' + frxStrToXML(FValuesSeparator) + '"';
end;


{ TfrxBrushFill }

constructor TfrxBrushFill.Create;
begin
  FBackColor := clNone;
  FForeColor := clBlack;
  FStyle := bsSolid;
end;

procedure TfrxBrushFill.Assign(Source: TPersistent);
begin
  if Source is TfrxBrushFill then
  begin
    FBackColor := TfrxBrushFill(Source).FBackColor;
    FForeColor := TfrxBrushFill(Source).FForeColor;
    FStyle := TfrxBrushFill(Source).FStyle;
  end;
end;

procedure TfrxBrushFill.Draw(ACanvas: TCanvas; X, Y, X1, Y1: Integer; ScaleX,
  ScaleY: Extended);
var
  br, oldbr: HBRUSH;
  OldPStyle: TPenStyle;
begin
  with ACanvas do
  begin
    Brush.Style := Style;
//    FFill.Draw(FCanvas, FX, FY, FX1, FY1, FScaleX, FScaleY);
    if FBackColor <> clNone then
    begin
      Brush.Color := FBackColor;
      Brush.Style := bsSolid;
      FillRect(Rect(X, Y, X1, Y1));
    end;
    if Style <> bsSolid then
    begin
      { Brush.Style := xxx does not work for some printers }
      { Brush.Style := xxx does not work for some printers }
{$IFDEF FPC}
{$warning LCL: CreateHatchBrush() NOT IMPLEMENTED YET !}
      {TODO: CreateHatchBrush() implementation}
      br := LCLIntf.CreateSolidBrush(ColorToRGB(FForeColor));
{$ELSE}
      br := CreateHatchBrush(Integer(Style) - 2, ColorToRGB(FForeColor));
{$ENDIF}
      oldbr := SelectObject(Handle, br);
      SetBkMode(Handle,TRANSPARENT);
      OldPStyle := Pen.Style;
      Pen.Style := psClear;
      Rectangle(X, Y, X1 + 1, Y1 + 1);
      SelectObject(Handle, oldbr);
      DeleteObject(br);
      Pen.Style := OldPStyle;
    end;
  end;
end;

function TfrxBrushFill.Diff(AFill: TfrxCustomFill; const Add: String): String;
var
  SourceFill: TfrxBrushFill;
begin
  Result := '';
  SourceFill := nil;
  if AFill is TfrxBrushFill then
    SourceFill := AFill as TfrxBrushFill;

  if (SourceFill = nil) or (FBackColor <> SourceFill.FBackColor) then
    Result := Result + ' ' + Add + '.BackColor="' + IntToStr(FBackColor) + '"';
  if (SourceFill = nil) or (FForeColor <> SourceFill.FForeColor) then
    Result := Result + ' ' + Add + '.ForeColor="' + IntToStr(FForeColor) + '"';
  if (SourceFill = nil) or (FStyle <> SourceFill.FStyle) then
    Result := Result + ' ' + Add + '.Style="' + frxValueToXML(FStyle) + '"';
end;


{ TfrxGradientFill }

constructor TfrxGradientFill.Create;
begin
  FStartColor := clWhite;
  FEndColor := clBlack;
  FGradientStyle := gsHorizontal;
end;

procedure TfrxGradientFill.Assign(Source: TPersistent);
begin
  if Source is TfrxGradientFill then
  begin
    FStartColor := TfrxGradientFill(Source).FStartColor;
    FEndColor := TfrxGradientFill(Source).FEndColor;
    FGradientStyle := TfrxGradientFill(Source).FGradientStyle;
  end;
end;

procedure TfrxGradientFill.Draw(ACanvas: TCanvas; X, Y, X1, Y1: Integer; ScaleX,
  ScaleY: Extended);
var
  FromR, FromG, FromB: Integer;
  DiffR, DiffG, DiffB: Integer;
  ox, oy, dx, dy: Integer;

  procedure DoHorizontal(fr, fg, fb, dr, dg, db: Integer);
  var
    ColorRect: TRect;
    I: Integer;
    R, G, B: Byte;
  begin
    ColorRect.Top := oy;
    ColorRect.Bottom := oy + dy;
    for I := 0 to 255 do
    begin
      ColorRect.Left := MulDiv (I, dx, 256) + ox;
      ColorRect.Right := MulDiv (I + 1, dx, 256) + ox;
      R := fr + MulDiv(I, dr, 255);
      G := fg + MulDiv(I, dg, 255);
      B := fb + MulDiv(I, db, 255);
      ACanvas.Brush.Color := RGB(R, G, B);
      ACanvas.FillRect(ColorRect);
    end;
  end;

  procedure DoVertical(fr, fg, fb, dr, dg, db: Integer);
  var
    ColorRect: TRect;
    I: Integer;
    R, G, B: Byte;
  begin
    ColorRect.Left := ox;
    ColorRect.Right := ox + dx;
    for I := 0 to 255 do
    begin
      ColorRect.Top := MulDiv (I, dy, 256) + oy;
      ColorRect.Bottom := MulDiv (I + 1, dy, 256) + oy;
      R := fr + MulDiv(I, dr, 255);
      G := fg + MulDiv(I, dg, 255);
      B := fb + MulDiv(I, db, 255);
      ACanvas.Brush.Color := RGB(R, G, B);
      ACanvas.FillRect(ColorRect);
    end;
  end;

  procedure DoElliptic(fr, fg, fb, dr, dg, db: Integer);
  var
    I: Integer;
    R, G, B: Byte;
    Pw, Ph: Double;
    x1, y1, x2, y2: Double;
    rgn: HRGN;
  begin
    rgn := CreateRectRgn(0, 0, 10000, 10000);
    GetClipRgn(ACanvas.Handle, rgn);
    IntersectClipRect(ACanvas.Handle, ox, oy, ox + dx, oy + dy);
    ACanvas.Pen.Style := psClear;

    x1 := ox - (dx / 4);
    x2 := ox + dx + (dx / 4);
    y1 := oy - (dy / 4);
    y2 := oy + dy + (dy / 4);
    Pw := ((dx / 4) + (dx / 2)) / 155;
    Ph := ((dy / 4) + (dy / 2)) / 155;
    for I := 0 to 155 do
    begin
      x1 := x1 + Pw;
      x2 := X2 - Pw;
      y1 := y1 + Ph;
      y2 := y2 - Ph;
      R := fr + MulDiv(I, dr, 155);
      G := fg + MulDiv(I, dg, 155);
      B := fb + MulDiv(I, db, 155);
      ACanvas.Brush.Color := R or (G shl 8) or (b shl 16);
      ACanvas.Ellipse(Trunc(x1), Trunc(y1), Trunc(x2), Trunc(y2));
    end;

    SelectClipRgn(ACanvas.Handle, rgn);
    DeleteObject(rgn);
  end;

  procedure DoRectangle(fr, fg, fb, dr, dg, db: Integer);
  var
    I: Integer;
    R, G, B: Byte;
    Pw, Ph: Real;
    x1, y1, x2, y2: Double;
  begin
    ACanvas.Pen.Style := psClear;
    ACanvas.Pen.Mode := pmCopy;
    x1 := 0 + ox;
    x2 := ox + dx;
    y1 := 0 + oy;
    y2 := oy + dy;
    Pw := (dx / 2) / 255;
    Ph := (dy / 2) / 255;
    for I := 0 to 255 do
    begin
      x1 := x1 + Pw;
      x2 := X2 - Pw;
      y1 := y1 + Ph;
      y2 := y2 - Ph;
      R := fr + MulDiv(I, dr, 255);
      G := fg + MulDiv(I, dg, 255);
      B := fb + MulDiv(I, db, 255);
      ACanvas.Brush.Color := RGB(R, G, B);
      ACanvas.FillRect(Rect(Trunc(x1), Trunc(y1), Trunc(x2), Trunc(y2)));
    end;
    ACanvas.Pen.Style := psSolid;
  end;

  procedure DoVertCenter(fr, fg, fb, dr, dg, db: Integer);
  var
    ColorRect: TRect;
    I: Integer;
    R, G, B: Byte;
    Haf: Integer;
  begin
    Haf := dy Div 2;
    ColorRect.Left := 0 + ox;
    ColorRect.Right := ox + dx;
    for I := 0 to Haf do
    begin
      ColorRect.Top := MulDiv(I, Haf, Haf) + oy;
      ColorRect.Bottom := MulDiv(I + 1, Haf, Haf) + oy;
      R := fr + MulDiv(I, dr, Haf);
      G := fg + MulDiv(I, dg, Haf);
      B := fb + MulDiv(I, db, Haf);
      ACanvas.Brush.Color := RGB(R, G, B);
      ACanvas.FillRect(ColorRect);
      ColorRect.Top := dy - (MulDiv (I, Haf, Haf)) + oy;
      ColorRect.Bottom := dy - (MulDiv (I + 1, Haf, Haf)) + oy;
      ACanvas.FillRect(ColorRect);
    end;
  end;

  procedure DoHorizCenter(fr, fg, fb, dr, dg, db: Integer);
  var
    ColorRect: TRect;
    I: Integer;
    R, G, B: Byte;
    Haf: Integer;
  begin
    Haf := dx Div 2;
    ColorRect.Top := 0 + oy;
    ColorRect.Bottom := oy + dy;
    for I := 0 to Haf do
    begin
      ColorRect.Left := MulDiv(I, Haf, Haf) + ox;
      ColorRect.Right := MulDiv(I + 1, Haf, Haf) + ox;
      R := fr + MulDiv(I, dr, Haf);
      G := fg + MulDiv(I, dg, Haf);
      B := fb + MulDiv(I, db, Haf);
      ACanvas.Brush.Color := RGB(R, G, B);
      ACanvas.FillRect(ColorRect);
      ColorRect.Left := dx - (MulDiv (I, Haf, Haf)) + ox;
      ColorRect.Right := dx - (MulDiv (I + 1, Haf, Haf)) + ox;
      ACanvas.FillRect(ColorRect);
    end;
  end;

begin
  ox := X;
  oy := Y;
  dx := X1 - X;
  dy := Y1 - Y;
  FromR := FStartColor and $000000ff;
  FromG := (FStartColor shr 8) and $000000ff;
  FromB := (FStartColor shr 16) and $000000ff;
  DiffR := (FEndColor and $000000ff) - FromR;
  DiffG := ((FEndColor shr 8) and $000000ff) - FromG;
  DiffB := ((FEndColor shr 16) and $000000ff) - FromB;

  case FGradientStyle of
    gsHorizontal:
      DoHorizontal(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    gsVertical:
      DoVertical(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    gsElliptic:
      DoElliptic(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    gsRectangle:
      DoRectangle(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    gsVertCenter:
      DoVertCenter(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    gsHorizCenter:
      DoHorizCenter(FromR, FromG, FromB, DiffR, DiffG, DiffB);
  end;
end;

function TfrxGradientFill.GetColor: TColor;
var
  R, G, B: Byte;
  FromR, FromG, FromB: Integer;
  DiffR, DiffG, DiffB: Integer;
begin
  FromR := FStartColor and $000000ff;
  FromG := (FStartColor shr 8) and $000000ff;
  FromB := (FStartColor shr 16) and $000000ff;
  DiffR := (FEndColor and $000000ff) - FromR;
  DiffG := ((FEndColor shr 8) and $000000ff) - FromG;
  DiffB := ((FEndColor shr 16) and $000000ff) - FromB;
  R := FromR + MulDiv(127, DiffR, 255);
  G := FromG + MulDiv(127, DiffG, 255);
  B := FromB + MulDiv(127, DiffB, 255);
  {$IFDEF FPC}
  Result := RGBToColor(R, G, B);
  {$ELSE}
  Result := RGB(R, G, B);
  {$ENDIF}
end;

function TfrxGradientFill.Diff(AFill: TfrxCustomFill; const Add: String): String;
var
  SourceFill: TfrxGradientFill;
begin
  Result := '';
  SourceFill := nil;
  if AFill is TfrxGradientFill then
    SourceFill := AFill as TfrxGradientFill;

  if (SourceFill = nil) or (FStartColor <> SourceFill.FStartColor) then
    Result := Result + ' ' + Add + '.StartColor="' + IntToStr(FStartColor) + '"';
  if (SourceFill = nil) or (FEndColor <> SourceFill.FEndColor) then
    Result := Result + ' ' + Add + '.EndColor="' + IntToStr(FEndColor) + '"';
  if (SourceFill = nil) or (FGradientStyle <> SourceFill.FGradientStyle) then
    Result := Result + ' ' + Add + '.GradientStyle="' + frxValueToXML(FGradientStyle) + '"';
end;


{ TfrxGlassFill }

constructor TfrxGlassFill.Create;
begin
  FHatch := False;
  FColor := clGray;
  FBlend := 0.5;
  FOrient := foHorizontal;
end;

procedure TfrxGlassFill.Assign(Source: TPersistent);
begin
  if Source is TfrxGlassFill then
  begin
    FColor := TfrxGlassFill(Source).FColor;
    FBlend := TfrxGlassFill(Source).FBlend;
    FHatch := TfrxGlassFill(Source).FHatch;
    FOrient := TfrxGlassFill(Source).FOrient
  end;
end;

function TfrxGlassFill.BlendColor: TColor;
var
  cR, cG, cB, AColor : Integer;
begin
  AColor := ColorToRGB(FColor);
  cR := (AColor and $000000ff);
  cR := (cR + Round((255 - cR) * FBlend));
  cG := ((AColor shr 8) and $000000ff);
  cG := (cG + Round((255 - cG) * FBlend));
  cB := ((AColor shr 16) and $000000ff);
  cB := (cB + Round((255 - cB) * FBlend));
  if cR > 255 then cR := 255;
  if cG > 255 then cG := 255;
  if cB > 255 then cB := 255;
  Result := ((cB and $000000ff) shl 16) or ((cG and $000000ff) shl 8) or cR;
end;

procedure TfrxGlassFill.Draw(ACanvas: TCanvas; X, Y, X1, Y1: Integer;
  ScaleX, ScaleY: Extended);
var
  OldColor: TColor;
  br, oldbr: HBRUSH;
  OldBStyle: TBrushStyle;
  OldPStyle: TPenStyle;
begin
  with ACanvas do
  begin
    if FColor <> clNone then
    begin
      OldColor := Brush.Color;
      OldBStyle := Brush.Style;
      Brush.Color := FColor;
      Brush.Style := bsSolid;
      FillRect(Rect(X, Y, X1, Y1));
      Brush.Color := BlendColor;
      Brush.Style := bsSolid;
      case FOrient of
        foHorizontal:
          FillRect(Rect(X, Y, X1, Y1 - (Y1 - Y)  div 2));
        foHorizontalMirror:
          FillRect(Rect(X, Y + (Y1 - Y)  div 2, X1, Y1));
        foVerticalMirror:
          FillRect(Rect(X + (X1 - X)  div 2, Y, X1, Y1));
        foVertical:
          FillRect(Rect(X, Y, X1 - (X1 - X) div 2, Y1));
      end;
      Brush.Color := OldColor;
      Brush.Style := OldBStyle;
      if FHatch then
      begin
{$IFDEF FPC}
{$warning LCL: CreateHatchBrush() NOT IMPLEMENTED YET !}
        {TODO: CreateHatchBrush() implementation}
        br := LCLIntf.CreateSolidBrush(ColorToRGB(HatchColor));
{$ELSE}
        br := CreateHatchBrush(HS_BDIAGONAL, HatchColor);
{$ENDIF}
        oldbr := SelectObject(Handle, br);
        SetBkMode(Handle,TRANSPARENT);
        OldPStyle := Pen.Style;
        Pen.Style := psClear;
        Rectangle(X, Y, X1 + 1, Y1 + 1);
        SelectObject(Handle, oldbr);
        DeleteObject(br);
        Pen.Style := OldPStyle;
      end;
    end;
  end;
end;

function TfrxGlassFill.GetColor: TColor;
begin
  Result := Color;
end;

function TfrxGlassFill.Diff(AFill: TfrxCustomFill; const Add: String): String;
var
  SourceFill: TfrxGlassFill;
begin
  Result := '';
  SourceFill := nil;
  if AFill is TfrxGlassFill then
    SourceFill := AFill as TfrxGlassFill;

  if (SourceFill = nil) or (FColor <> SourceFill.FColor) then
    Result := Result + ' ' + Add + '.Color="' + IntToStr(FColor) + '"';
  if (SourceFill = nil) or (FBlend <> SourceFill.FBlend) then
    Result := Result + ' ' + Add + '.Blend="' + FloatToStr(FBlend) + '"';
  if (SourceFill = nil) or (FHatch <> SourceFill.FHatch) then
    Result := Result + ' ' + Add + '.Hatch="' + frxValueToXML(FHatch) + '"';
  if (SourceFill = nil) or (FOrient <> SourceFill.FOrient) then
    Result := Result + ' ' + Add + '.Orientation="' + frxValueToXML(FOrient) + '"';
end;

function TfrxGlassFill.HatchColor: TColor;
begin
  Result := BlendColor - $060606;
end;

{ TfrxFrameLine }

constructor TfrxFrameLine.Create(AFrame: TfrxFrame);
begin
  FColor := clBlack;
  FStyle := fsSolid;
  FWidth := 1;
  FFrame := AFrame;
end;

procedure TfrxFrameLine.Assign(Source: TPersistent);
begin
  if Source is TfrxFrameLine then
  begin
    FColor := TfrxFrameLine(Source).Color;
    FStyle := TfrxFrameLine(Source).Style;
    FWidth := TfrxFrameLine(Source).Width;
  end;
end;

function TfrxFrameLine.IsColorStored: Boolean;
begin
  Result := FColor <> FFrame.Color;
end;

function TfrxFrameLine.IsStyleStored: Boolean;
begin
  Result := FStyle <> FFrame.Style;
end;

function TfrxFrameLine.IsWidthStored: Boolean;
begin
  Result := FWidth <> FFrame.Width;
end;

function TfrxFrameLine.Diff(ALine: TfrxFrameLine; const LineName: String;
  ColorChanged, StyleChanged, WidthChanged: Boolean): String;
begin
  Result := '';

  if (ColorChanged and IsColorStored) or (not ColorChanged and (FColor <> ALine.Color)) then
    Result := Result + ' ' + LineName + '.Color="' + IntToStr(FColor) + '"';
  if (StyleChanged and IsStyleStored) or (not StyleChanged and (FStyle <> ALine.Style)) then
    Result := Result + ' ' + LineName + '.Style="' + frxValueToXML(FStyle) + '"';
  if (WidthChanged and IsWidthStored) or (not WidthChanged and frxFloatDiff(FWidth, ALine.Width)) then
    Result := Result + ' ' + LineName + '.Width="' + FloatToStr(FWidth) + '"';
end;


{ TfrxFrame }

constructor TfrxFrame.Create;
begin
  FColor := clBlack;
  FShadowColor := clBlack;
  FShadowWidth := 4;
  FStyle := fsSolid;
  FTyp := [];
  FWidth := 1;

  FLeftLine := TfrxFrameLine.Create(Self);
  FTopLine := TfrxFrameLine.Create(Self);
  FRightLine := TfrxFrameLine.Create(Self);
  FBottomLine := TfrxFrameLine.Create(Self);
end;

destructor TfrxFrame.Destroy;
begin
  FLeftLine.Free;
  FTopLine.Free;
  FRightLine.Free;
  FBottomLine.Free;
  inherited;
end;

procedure TfrxFrame.Assign(Source: TPersistent);
begin
  if Source is TfrxFrame then
  begin
    FColor := TfrxFrame(Source).Color;
    FDropShadow := TfrxFrame(Source).DropShadow;
    FShadowColor := TfrxFrame(Source).ShadowColor;
    FShadowWidth := TfrxFrame(Source).ShadowWidth;
    FStyle := TfrxFrame(Source).Style;
    FTyp := TfrxFrame(Source).Typ;
    FWidth := TfrxFrame(Source).Width;

    FLeftLine.Assign(TfrxFrame(Source).LeftLine);
    FTopLine.Assign(TfrxFrame(Source).TopLine);
    FRightLine.Assign(TfrxFrame(Source).RightLine);
    FBottomLine.Assign(TfrxFrame(Source).BottomLine);
  end;
end;

function TfrxFrame.IsShadowWidthStored: Boolean;
begin
  Result := FShadowWidth <> 4;
end;

function TfrxFrame.IsTypStored: Boolean;
begin
  Result := True;//FTyp <> [];
end;

function TfrxFrame.IsWidthStored: Boolean;
begin
  Result := FWidth <> 1;
end;

procedure TfrxFrame.SetBottomLine(const Value: TfrxFrameLine);
begin
  FBottomLine.Assign(Value);
end;

procedure TfrxFrame.SetLeftLine(const Value: TfrxFrameLine);
begin
  FLeftLine.Assign(Value);
end;

procedure TfrxFrame.SetRightLine(const Value: TfrxFrameLine);
begin
  FRightLine.Assign(Value);
end;

procedure TfrxFrame.SetTopLine(const Value: TfrxFrameLine);
begin
  FTopLine.Assign(Value);
end;

procedure TfrxFrame.SetColor(const Value: TColor);
begin
  FColor := Value;
  FLeftLine.Color := Value;
  FTopLine.Color := Value;
  FRightLine.Color := Value;
  FBottomLine.Color := Value;
end;

procedure TfrxFrame.SetStyle(const Value: TfrxFrameStyle);
begin
  FStyle := Value;
  FLeftLine.Style := Value;
  FTopLine.Style := Value;
  FRightLine.Style := Value;
  FBottomLine.Style := Value;
end;

procedure TfrxFrame.SetWidth(const Value: Extended);
begin
  FWidth := Value;
  FLeftLine.Width := Value;
  FTopLine.Width := Value;
  FRightLine.Width := Value;
  FBottomLine.Width := Value;
end;

function TfrxFrame.Diff(AFrame: TfrxFrame): String;
var
  i: Integer;
  ColorChanged, StyleChanged, WidthChanged: Boolean;
begin
  Result := '';

  ColorChanged := FColor <> AFrame.Color;
  if ColorChanged then
    Result := Result + ' Frame.Color="' + IntToStr(FColor) + '"';
  if FDropShadow <> AFrame.DropShadow then
    Result := Result + ' Frame.DropShadow="' + frxValueToXML(FDropShadow) + '"';
  if FShadowColor <> AFrame.ShadowColor then
    Result := Result + ' Frame.ShadowColor="' + IntToStr(FShadowColor) + '"';
  if frxFloatDiff(FShadowWidth, AFrame.ShadowWidth) then
    Result := Result + ' Frame.ShadowWidth="' + FloatToStr(FShadowWidth) + '"';
  StyleChanged := FStyle <> AFrame.Style;
  if StyleChanged then
    Result := Result + ' Frame.Style="' + frxValueToXML(FStyle) + '"';
  if FTyp <> AFrame.Typ then
  begin
    i := 0;
    if ftLeft in FTyp then i := i or 1;
    if ftRight in FTyp then i := i or 2;
    if ftTop in FTyp then i := i or 4;
    if ftBottom in FTyp then i := i or 8;
    Result := Result + ' Frame.Typ="' + IntToStr(i) + '"';
  end;
  WidthChanged := frxFloatDiff(FWidth, AFrame.Width);
  if WidthChanged then
    Result := Result + ' Frame.Width="' + FloatToStr(FWidth) + '"';

  Result := Result + FLeftLine.Diff(AFrame.LeftLine, 'Frame.LeftLine',
    ColorChanged, StyleChanged, WidthChanged);
  Result := Result + FTopLine.Diff(AFrame.TopLine, 'Frame.TopLine',
    ColorChanged, StyleChanged, WidthChanged);
  Result := Result + FRightLine.Diff(AFrame.RightLine, 'Frame.RightLine',
    ColorChanged, StyleChanged, WidthChanged);
  Result := Result + FBottomLine.Diff(AFrame.BottomLine, 'Frame.BottomLine',
    ColorChanged, StyleChanged, WidthChanged);
end;

procedure TfrxFrame.Draw(Canvas: TCanvas; FX, FY, FX1, FY1: Integer; ScaleX, ScaleY: Extended);
var
  d: Integer;

  procedure DrawLine(x, y, x1, y1, w: Integer);
  var
    i, d: Integer;
  begin
    with Canvas do
    begin
      if w = 0 then
        w := 1;
      if w mod 2 = 0 then
        d := 1 else
        d := 0;

      for i := (-w div 2) to (w div 2 - d) do
      begin
        if Abs(x1 - x) > Abs(y1 - y) then
        begin
          MoveTo(x, y + i);
          LineTo(x1, y1 + i);
        end
        else
        begin
          MoveTo(x + i, y);
          LineTo(x1 + i, y1);
        end;
      end;
    end;
  end;

  procedure Line1(x, y, x1, y1: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x1, y1);
  end;

  procedure LineInt(x, y, x1, y1: Integer; Line: TfrxFrameLine;
    Typ: TfrxFrameType; gap1, gap2: Boolean);
  var
    g1, g2, g3, g4, fw: Integer;
    LG: {$IFDEF FPC}TLogBrush{$ELSE}LOGBRUSH{$ENDIF};
    hP: HPEN;
    PenStyle: array[0..1] of DWORD;
    PenSt: Cardinal;
    OldPen: HGDIOBJ;

    {back compatibility for win9x/ME}
    procedure DrawDotLine(x, y, x1, y1, w: Integer; Rounded:Boolean);
    var
      idX, idY, mWidth, mHeight, CpMode: Integer;
      Bcl: TColor;
      TmpBit: TBitmap;
    begin
      if w = 0 then
        w := 1;
      mHeight := y1 - y;
      mWidth := x1 - x;
      if mWidth = 0 then
        mWidth := w;
      if mHeight = 0 then
        mHeight := w;

      TmpBit := TBitmap.Create;
      TmpBit.Width := mWidth;
      TmpBit.Height := mHeight;
      TmpBit.Canvas.Brush.Color := clBlack;
      TmpBit.Canvas.Pen.Color := clBlack;
      Bcl := Canvas.Brush.Color;
      Canvas.Brush.Color := Line.Color;
      idX := 0;

      while (idX <= mWidth) do
      begin
        idY := 0;
        while (idY <= mHeight) do
        begin
          if w > 1 then
            if Rounded then
              TmpBit.Canvas.Ellipse(idX, idY, idX + w, idY + w)
            else
              TmpBit.Canvas.Rectangle(idX, idY, idX + w, idY + w)
          else
            TmpBit.Canvas.Pixels[idX, idY] := clBlack;
          idY := idY + w * 2;
        end;
        idX := idX +  w * 2;
      end;

      CpMode := Canvas.CopyMode;
      Canvas.CopyMode := $B8074A; {this mode copy all black pixels from source to dest with current brush color}
      Canvas.Draw(x - (w div 2), y - (w div 2), TmpBit);
      {restore canvas state}
      Canvas.Brush.Color := Bcl;
      Canvas.CopyMode := CpMode;
      TmpBit.Free;
    end;

  begin
    fw := Round(Line.Width * ScaleX);

    if Line.Style in [fsSolid, fsDouble] then
    begin
      if gap1 then g1 := 0 else g1 := 1;
      if gap2 then g2 := 0 else g2 := 1;

      if Typ in [ftTop, ftBottom] then
      begin
        x := x + (fw * g1 div 2);
        x1 := x1 - (fw * g2 div 2);
      end
      else
      begin
        y := y + (fw * g1 div 2);
        y1 := y1 - (fw * g2 div 2);
      end;
    end;

    if Line.Style = fsSolid then
      begin
        LG.lbStyle := BS_SOLID;
        LG.lbColor := line.Color;
        LG.lbHatch := 0;
        PenSt := PS_GEOMETRIC or PS_ENDCAP_SQUARE;
        hP := ExtCreatePen(PenSt, fw, LG, 0, nil);
        if hP <> 0 then
        begin
          OldPen := SelectObject(Canvas.Handle, Hp);
          Line1(x, y, x1, y1);
          SelectObject(Canvas.Handle, OldPen);
          DeleteObject(hP);
        end
        else Line1(x, y, x1, y1)
      end
    else if Line.Style = fsDouble then
    begin
      if gap1 then
        g1 := fw else
        g1 := 0;
      if gap2 then
        g2 := fw else
        g2 := 0;
      g3 := -g1;
      g4 := -g2;

      if Typ in [ftLeft, ftTop] then
      begin
        g1 := -g1;
        g2 := -g2;
        g3 := -g3;
        g4 := -g4;
      end;

      if x = x1 then
        Line1(x - fw, y + g1, x1 - fw, y1 - g2) else
        Line1(x + g1, y - fw, x1 - g2, y1 - fw);
      Canvas.Pen.Color := Line.Color;
      if x = x1 then
        Line1(x + fw, y + g3, x1 + fw, y1 - g4) else
        Line1(x + g3, y + fw, x1 - g4, y1 + fw);
    end
    {real round dot line / Square dot line}
    else if Line.Style in [fsAltDot, fsSquare] then
    begin
      LG.lbStyle := BS_SOLID;
      LG.lbColor := line.Color;
      LG.lbHatch := 0;
      PenSt := PS_GEOMETRIC or PS_USERSTYLE;
      if fw <= 1 then
      begin
        PenStyle[0] := 1;
        PenStyle[1] := 1;
        PenSt := PenSt or PS_ENDCAP_FLAT;
      end
      else if Line.Style = fsSquare then
      begin
        PenStyle[0] := fw;
        PenStyle[1] := fw;
        PenSt := PenSt or PS_ENDCAP_FLAT;
      end
      else
      begin
        PenStyle[0] := 0;
        PenStyle[1] := fw * 2;
        PenSt := PenSt or PS_ENDCAP_ROUND;
      end;

      hP := ExtCreatePen(PenSt, fw, LG, 2, @PenStyle);
      if hP = 0 then
        DrawDotLine(x, y, x1, y1, fw, Line.Style = fsAltDot)
      else
      begin
        OldPen := SelectObject(Canvas.Handle, Hp);
        Line1(x, y, x1, y1);
        SelectObject(Canvas.Handle, OldPen);
        DeleteObject(hP);
      end;
    end
    else
      DrawLine(x, y, x1, y1, fw);
  end;

  procedure SetPen(ALine: TfrxFrameLine);
  begin
    with Canvas do
    begin
      Pen.Color := ALine.Color;
      if ALine.Style in [fsSolid, fsDouble] then
      begin
        Pen.Style := psSolid;
        Pen.Width := Round(ALine.Width * ScaleX);
      end
      else
      begin
        Pen.Style := TPenStyle(ALine.Style);
        Pen.Width := 1;
      end;
    end;
  end;

begin
  if DropShadow then
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := ShadowColor;
      d := Round(ShadowWidth * ScaleX);
      DrawLine(FX1 + d div 2, FY + d, FX1 + d div 2, FY1, d);
      d := Round(ShadowWidth * ScaleY);
      DrawLine(FX + d, FY1 + d div 2, FX1 + d, FY1 + d div 2, d);
    end;

  if (Typ <> []) and (Color <> clNone) and (Width <> 0) then
    with Canvas do
    begin
      Brush.Style := bsSolid;
      if Style <> fsSolid then
        Brush.Style := bsClear;
      if ftLeft in Typ then
      begin
        SetPen(LeftLine);
        if (Pen.Width = 2) and (Style <> fsSolid) then
          d := 1 else
          d := 0;
        LineInt(FX, FY - d, FX, FY1, LeftLine, ftLeft, ftTop in Typ, ftBottom in Typ);
      end;
      if ftRight in Typ then
      begin
        SetPen(RightLine);
        LineInt(FX1, FY, FX1, FY1, RightLine, ftRight, ftTop in Typ, ftBottom in Typ);
      end;
      if ftTop in Typ then
      begin
        SetPen(TopLine);
        LineInt(FX, FY, FX1, FY, TopLine, ftTop, ftLeft in Typ, ftRight in Typ);
      end;
      if ftBottom in Typ then
      begin
        SetPen(BottomLine);
        if (Pen.Width = 1) and (Style <> fsSolid) then
          d := 1 else
          d := 0;
        LineInt(FX, FY1, FX1 + d, FY1, BottomLine, ftBottom, ftLeft in Typ, ftRight in Typ);
      end;
    end;
end;


{ TfrxView }

constructor TfrxView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  frComponentStyle := frComponentStyle + [csDefaultDiff];
  FAlign := baNone;
  FAllowVectorExport := True;
  FFrame := TfrxFrame.Create;
  FFill := TfrxBrushFill.Create;
  FHyperlink := TfrxHyperlink.Create;
  FProcessing := TfrxObjectProcessing.Create;
  FShiftMode := smAlways;
  FPlainText := False;
  FVisibility := [vsPreview, vsExport, vsPrint];
  FDrawAsMask := False;
  FObjAsMetafile := False;
  FDrawFillOnMetaFile := False;
  FScaleX := 1;
  FScaleY := 1;
  FVC := nil;
end;

destructor TfrxView.Destroy;
begin
  FFrame.Free;
  FHyperlink.Free;
  FFill.Free;
  FreeAndNil(FProcessing);
  inherited;
end;

procedure TfrxView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

procedure TfrxView.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxView.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := FindDataSet(FDataSet, FDataSetName);
end;

function TfrxView.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

procedure TfrxView.SetFrame(const Value: TfrxFrame);
begin
  FFrame.Assign(Value);
end;

procedure TfrxView.SetHyperLink(const Value: TfrxHyperlink);
begin
  FHyperlink.Assign(Value);
end;

procedure TfrxView.BeginDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  FCanvas := Canvas;
  FScaleX := ScaleX;
  FScaleY := ScaleY;
  FOffsetX := OffsetX;
  FOffsetY := OffsetY;
  FX := Round(AbsLeft * ScaleX + OffsetX);
  FY := Round(AbsTop * ScaleY + OffsetY);
  FX1 := Round((AbsLeft + Width) * ScaleX + OffsetX);
  FY1 := Round((AbsTop + Height) * ScaleY + OffsetY);

  if Frame.DropShadow then
  begin
    FX1 := FX1 - Round(Frame.ShadowWidth * ScaleX);
    FY1 := FY1 - Round(Frame.ShadowWidth * ScaleY);
  end;

  FDX := FX1 - FX;
  FDY := FY1 - FY;
  FFrameWidth := Round(Frame.Width * ScaleX);
end;

procedure TfrxView.DrawBackground;
var
  dX, dY, dX1, dY1, wx1, wx2, wy1, wy2: Integer;
begin
  if FObjAsMetafile and not FDrawFillOnMetaFile then Exit;
  dX := FX;
  dY := FY;
  dX1 := FX1;
  dY1 := FY1;

  wx1 := Round((Frame.Width * FScaleX) / 2);
  wx2 := Round(Frame.Width * FScaleX / 2) + Round(Frame.Width * FScaleX) mod 2;
  wy1 := Round((Frame.Width * FScaleY) / 2);
  wy2 := Round(Frame.Width * FScaleY / 2) + Round(Frame.Width * FScaleY) mod 2;
  if ftLeft in Frame.Typ then
    Dec(dX, wx1);
  if ftRight in Frame.Typ then
    Inc(dX1, wx2);
  if ftTop in Frame.Typ then
    Dec(dY, wy1);
  if ftBottom in Frame.Typ then
    Inc(dY1, wy2);

  FFill.Draw(FCanvas, dX, dY, dX1, dY1, FScaleX, FScaleY);
end;

procedure TfrxView.DrawLine(x, y, x1, y1, w: Integer);
var
  i, d: Integer;
begin
  with FCanvas do
  begin
    if w = 0 then
      w := 1;
    if w mod 2 = 0 then
      d := 1 else
      d := 0;

    for i := (-w div 2) to (w div 2 - d) do
    begin
      if Abs(x1 - x) > Abs(y1 - y) then
      begin
        MoveTo(x, y + i);
        LineTo(x1, y1 + i);
      end
      else
      begin
        MoveTo(x + i, y);
        LineTo(x1 + i, y1);
      end;
    end;
  end;
end;

procedure TfrxView.DrawFrame;
begin
  if not FObjAsMetafile then
    FFrame.Draw(FCanvas, FX, FY, FX1, FY1, FScaleX, FScaleY);
  if Assigned(FComponentEditors) then
    FComponentEditors.DrawCustomEditor(FCanvas, Rect(FX, FY, FX1, FY1));
end;

procedure TfrxView.DrawFrameEdges;
begin
  if IsDesigning and not (Page is TfrxDataPage) and (Frame.Typ <> [ftLeft, ftRight, ftTop, ftBottom]) then
    with FCanvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := clBlack;
      Pen.Width := 1;
      DrawLine(FX, FY + 3, FX, FY, 1);
      DrawLine(FX, FY, FX + 4, FY, 1);
      DrawLine(FX, FY1 - 3, FX, FY1, 1);
      DrawLine(FX, FY1, FX + 4, FY1, 1);
      DrawLine(FX1 - 3, FY, FX1, FY, 1);
      DrawLine(FX1, FY, FX1, FY + 4, 1);
      DrawLine(FX1 - 3, FY1, FX1, FY1, 1);
      DrawLine(FX1, FY1, FX1, FY1 - 4, 1);
    end;
end;

procedure TfrxView.DrawHighlight(Canvas: TCanvas; ScaleX, ScaleY,
  OffsetX, OffsetY: Extended; hlColor: TColor);
var
  DropRect: TRect;
  s: String;
begin
  DropRect := Rect(FX, FY, FX1, FY1);
  FCanvas.Pen.Color := clRed;
  Canvas.Pen.Style := psDash;
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Width := 1;
  if csDesigning in ComponentState then
    Canvas.Rectangle(DropRect.Left, DropRect.Top, DropRect.Right,
      DropRect.Bottom)
  else
    TransparentFillRect(FCanvas.Handle, DropRect.Left + 1, DropRect.Top + 1, DropRect.Right - 1, DropRect.Bottom - 1, clSkyBlue);

  if not IsDesigning then Exit;
  if Height < Width then
    DropRect.Left := DropRect.Right - Round(Height * FScaleY)
  else
    DropRect.Left := DropRect.Right - Round(Width * FScaleX);
  // TODO: drag and drip image
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := clGray;
  Canvas.Pen.Style := psDot;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Width := 1;
  // Canvas.FillRect(DropRect);
  Canvas.Rectangle(DropRect.Left, DropRect.Top + 2, DropRect.Right - 2,
    DropRect.Bottom - 2);
  if IndexTag <> 0 then
  begin
    s := IntToStr(IndexTag);
    Canvas.Font.Color := clRed;
    Canvas.TextRect(DropRect, 0, 0, s);
  end;
end;

procedure TfrxView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  DrawBackground;
  DrawFrame;
  DrawFrameEdges;
  Inherited;
end;

procedure TfrxView.DrawClipped(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  Draw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
end;

function TfrxView.Diff(AComponent: TfrxComponent): String;
var
  v: TfrxView;
  vs: Integer;
begin
  Result := inherited Diff(AComponent);
  v := TfrxView(AComponent);

  if FAlign <> v.FAlign then
    Result := Result + ' Align="' + frxValueToXML(FAlign) + '"';
  Result := Result + FFrame.Diff(v.FFrame);
  if Cursor <> v.Cursor then
    Result := Result + ' Cursor="' + frxValueToXML(Cursor) + '"';
  if FVisibility <> v.FVisibility then
  begin
    vs := 0;
    if vsPreview in FVisibility then vs := 1;
    if vsExport in FVisibility then vs := vs or 2;
    if vsPrint in FVisibility then vs := vs or 4;
    Result := Result + ' Visibility="' + IntToStr(vs) + '"';
  end;
  if TagStr <> v.TagStr then
    Result := Result + ' TagStr="' + frxStrToXML(TagStr) + '"';

  if FillType <> v.FillType then
    Result := Result + ' FillType="' + frxValueToXML(FillType) + '"';
  Result := Result + FFill.Diff(v.Fill, 'Fill');
  Result := Result + FHyperlink.Diff(v.Hyperlink, 'Hyperlink');
end;

function TfrxView.IsAcceptAsChild(aParent: TfrxComponent): Boolean;
begin
  Result := True;
end;

function TfrxView.IsDataField: Boolean;
begin
  Result := (DataSet <> nil) and (Length(DataField) <> 0);
end;

function TfrxView.IsEMFExportable: Boolean;
begin
  Result := {$IFDEF FPC} False;
            {$ELSE}      AllowVectorExport;
            {$ENDIF}
end;

function TfrxView.IsPostProcessAllowed: Boolean;
begin
  Result := Assigned(FProcessing) and (FProcessing.ProcessAt <> paDefault);
end;

function TfrxView.LoadContentFromDictionary(aReport: TfrxReport;
  aItem: TfrxMacrosItem): Boolean;
begin
  Result := False;
end;

procedure TfrxView.MirrorContent(MirrorModes: TfrxMirrorControlModes);

  procedure SwapLines(var Line1: TfrxFrameLine; var Line2: TfrxFrameLine);
  var
    frameColor: TColor;
    frameStyle: TfrxFrameStyle;
    frameWidth: Extended;
  begin
    frameColor := Line1.Color;
    frameStyle := Line1.Style;
    frameWidth := Line1.Width;
    Line1.Color := Line2.Color;
    Line1.Style := Line2.Style;
    Line1.Width := Line2.Width;
    Line2.Color := frameColor;
    Line2.Style := frameStyle;
    Line2.Width := frameWidth;
  end;

  procedure SwapFrameType(var FrameType: TfrxFrameTypes; Type1, Type2: TfrxFrameType);
  begin
    Exclude(FrameType, Type1);
    Include(FrameType, Type2);
  end;

begin
  inherited MirrorContent(MirrorModes);
  if mcmRTLAppearance in MirrorModes then
  begin
    if (ftLeft in FFrame.FTyp) and not (ftRight in FFrame.FTyp) then
      SwapFrameType(FFrame.FTyp, ftLeft, ftRight)
    else if (ftRight in FFrame.FTyp) and not (ftLeft in FFrame.FTyp) then
      SwapFrameType(FFrame.FTyp, ftRight, ftLeft);
    SwapLines(FFrame.FLeftLine, FFrame.FRightLine);
  end;
  if mcmBTTAppearance in MirrorModes then
  begin
    if (ftTop in FFrame.FTyp) and not (ftBottom in FFrame.FTyp) then
      SwapFrameType(FFrame.FTyp, ftTop, ftBottom)
    else if (ftBottom in FFrame.FTyp) and not (ftTop in FFrame.FTyp) then
      SwapFrameType(FFrame.FTyp, ftBottom, ftTop);
    SwapLines(FFrame.FTopLine, FFrame.FBottomLine);
  end;

end;

procedure TfrxView.ProcessDictionary(aItem: TfrxMacrosItem;
  aReport: TfrxReport; PostProcessor: TfrxPostProcessor);
begin

end;

function TfrxView.GetVectorGraphic(DrawFill: Boolean = False): TGraphic;
var
  aCanvas: TCanvas;
  aScaleX, aScaleY: Extended;
begin
  FObjAsMetafile := True;
  Result := TMetafile.Create;

  GetScreenScale(aScaleX, aScaleY);

  Result.Width := Round(Width * aScaleX);
  Result.Height := Round(Height * aScaleY);
  TMetafile(Result).Enhanced := True;

  if Result.Height < 1 then Result.Height := 1;
  if Result.Width < 1 then Result.Width := 1;

  aCanvas := TMetafileCanvas.Create(TMetafile(Result), 0);
  try
    FDrawFillOnMetaFile := DrawFill;
    DrawClipped(aCanvas, 1, 1, -AbsLeft, -AbsTop);
  finally
    FObjAsMetafile := False;
    FDrawFillOnMetaFile := False;
    aCanvas.Free;
  end;
end;

function TfrxView.GetVectorCanvas: TVectorCanvas;
var
  Bitmap: TBitmap;
  aScaleX, aScaleY: Extended;
begin
  FVC := TVectorCanvas.Create;
  try
    Bitmap := TBitmap.Create;
    Bitmap.PixelFormat := pf24bit;

    GetScreenScale(aScaleX, aScaleY);

    Bitmap.Width := Max(1, Round(Width * aScaleX));
    Bitmap.Height := Max(1, Round(Height * aScaleY));

    try
      DrawClipped(Bitmap.Canvas, 1, 1, -AbsLeft, -AbsTop);
    finally
      Bitmap.Free;
    end;
  finally
    Result := FVC;
    FVC := nil;
  end;
end;

procedure TfrxView.GetScreenScale(var aScaleX, aScaleY: Extended);
var
  PrinterHandle: THandle;
begin
  PrinterHandle := GetDC(0);
  try
    GetDisplayScale(PrinterHandle, False, aScaleX, aScaleY);
    aScaleX := Min(1, aScaleX);
    aScaleY := Min(1, aScaleY);
  finally
    ReleaseDC(0, PrinterHandle);
  end;
end;

procedure TfrxView.BeforePrint;
begin
  inherited;
  FTempTag := FTagStr;
  FTempHyperlink := FHyperlink.Value;
  if Report <> nil then
    Report.SelfValue := Self;
end;

procedure TfrxView.ExpandVariables(var Expr: String);
var
  i, j: Integer;
  s: String;
begin
  i := 1;
  repeat
    while i < Length(Expr) do
      if isDBCSLeadByte(Byte(Expr[i])) then  { if DBCS then skip 2 bytes }
        Inc(i, 2)
      else if (Expr[i] <> '[') then
        Inc(i)
      else
        break;
{$IFDEF Delphi12}
    s := frxGetBrackedVariableW(Expr, '[', ']', i, j);
{$ELSE}
    s := frxGetBrackedVariable(Expr, '[', ']', i, j);
{$ENDIF}
    if i <> j then
    begin
      Delete(Expr, i, j - i + 1);
      s := VarToStr(Report.Calc(s));
      Insert(s, Expr, i);
      Inc(i, Length(s));
      j := 0;
    end;
  until i = j;
end;

function TfrxView.GetExportBounds: TfrxRect;
begin
  Result := frxRect(AbsLeft, AbsTop, AbsLeft + Width, AbsTop + Height);
end;

procedure TfrxView.GetData;
var
//  val: Variant;
  st: TStringList;
  i: Integer;
  s: String;
  aReport: TfrxReport;

  function CalcValue(aExp: String): Variant;
  begin
    Result := aReport.Calc(aExp);
    if ((TVarData(Result).VType = varString) or (TVarData(Result).VType = varOleStr)
    {$IFDEF Delphi12} or (TVarData(Result).VType = varUString){$ENDIF}) and (FHyperlink.Kind <> hkURL) then
      if aReport.ScriptLanguage = 'PascalScript' then
        Result := QuotedStr(Result)
      else
        Result := '"' + StringReplace(Result, '"', '\"', [rfReplaceAll]) + '"';
  end;

begin
  aReport := Report;
  if aReport <> nil then
    aReport.SelfValue := Self;
  if (FTagStr <> '') and (Pos('[', FTagStr) <> 0) then
    ExpandVariables(FTagStr);

  st := TStringList.Create;
  try
    frxParseDilimitedText(st, FHyperlink.Value, FHyperlink.ValuesSeparator[1]);
    if (FHyperlink.Value <> '') and (Pos('[', FHyperlink.Value) <> 0) then
    begin
      if St.Count = 0 then
        ExpandVariables(FHyperlink.FValue)
      else
        for i := 0 to St.Count - 1 do
        begin
          s := st[i];
          ExpandVariables(s);
          if i > 0 then
            FHyperlink.Value := FHyperlink.Value + FHyperlink.ValuesSeparator[1] + s
          else
            FHyperlink.Value := s;
        end;
    end;

    if FHyperlink.Expression <> '' then
    begin
      frxParseDilimitedText(st, FHyperlink.Expression, FHyperlink.ValuesSeparator[1]);
      if St.Count = 0 then
        FHyperlink.Value := CalcValue(FHyperlink.Expression)
      else
        for i := 0 to St.Count - 1 do
        begin
          if i > 0 then
            FHyperlink.Value := FHyperlink.Value + FHyperlink.ValuesSeparator[1] + VarToStr(CalcValue(st[i]))
          else
            FHyperlink.Value :=  VarToStr(CalcValue(st[i]));
        end;
    end;
  finally
    St.Free;
  end;
end;

procedure TfrxView.AfterPrint;
begin
  inherited;
  FTagStr := FTempTag;
  FHyperlink.Value := FTempHyperlink;
end;

procedure TfrxView.SetFill(const Value: TfrxCustomFill);
begin
  FillType := frxGetFillType(Value);
  FFill.Assign(Value);
end;

procedure TfrxView.SetFillType(const Value: TfrxFillType);
begin
  if FillType = Value then Exit;
  FFill.Free;
  FFill := frxCreateFill(Value);
  if IsDesigning and (Report <> nil) and (Report.Designer <> nil) then
    TfrxCustomDesigner(Report.Designer).UpdateInspector;
end;

function TfrxView.GetFillType: TfrxFillType;
begin
  Result := frxGetFillType(FFill);
end;

procedure TfrxView.SaveContentToDictionary(
  aReport: TfrxReport; PostProcessor: TfrxPostProcessor);
begin

end;

procedure TfrxView.SetBrushStyle(const Value: TBrushStyle);
begin
  if Self.Fill is TfrxBrushFill then
    TfrxBrushFill(Self.Fill).FStyle := Value;
end;

function TfrxView.GetBrushStyle: TBrushStyle;
begin
  if Self.Fill is TfrxBrushFill then
    Result := TfrxBrushFill(Self.Fill).FStyle
  else
    Result := bsClear;
end;

procedure TfrxView.SetColor(const Value: TColor);
begin
  if Self.Fill is TfrxBrushFill then
    TfrxBrushFill(Self.Fill).FBackColor := Value;
end;

function TfrxView.GetColor: TColor;
begin
  if Self.Fill is TfrxBrushFill then
    Result := TfrxBrushFill(Self.Fill).FBackColor
  else if Self.Fill is TfrxGradientFill then
    Result := TfrxGradientFill(Self.Fill).GetColor
  else if Self.Fill is TfrxGlassFill then
    Result := TfrxGlassFill(Self.Fill).GetColor
  else
    Result := clNone;
end;

procedure TfrxView.SetURL(const Value: String);
begin
  if Value <> '' then
  begin
    if Pos('@', Value) = 1 then
    begin
      FHyperlink.Kind := hkPageNumber;
      FHyperlink.Value := Copy(Value, 2, 255);
    end
    else if Pos('#', Value) = 1 then
    begin
      FHyperlink.Kind := hkAnchor;
      FHyperlink.Value := Copy(Value, 2, 255);
    end
    else
    begin
      FHyperlink.Kind := hkURL;
      FHyperlink.Value := Value;
    end;
  end;
end;

function TfrxView.ShadowSize: Extended;
begin
 if Frame.DropShadow then
    Result := Frame.ShadowWidth
  else
    Result := 0.0;
end;

function TfrxView.GetPrintable: Boolean;
begin
  Result := vsPrint in Visibility;
end;

procedure TfrxView.GetScaleFactor(var ScaleX, ScaleY: Extended);
begin
//
end;

procedure TfrxView.SetPrintable(Value: Boolean);
begin
  if Value then
    Visibility := Visibility + [vsPrint]
  else
    Visibility := Visibility - [vsPrint];
end;

procedure TfrxView.SetProcessing(const Value: TfrxObjectProcessing);
begin
  FProcessing.Assign(Value);
end;

{ TfrxShapeView }

constructor TfrxShapeView.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csDefaultDiff];
end;

constructor TfrxShapeView.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  inherited;
  FShape := TfrxShapeKind(Flags);
end;

procedure TfrxShapeView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  SaveLeft, SaveTop, SaveWidth, SaveHeight: Extended;
{$IFNDEF FPC}
  rgn: HRGN;
{$ENDIF}

  procedure DrawShape;
  var
    min: Integer;
  begin
    with Canvas do
    case FShape of
      skRectangle:
        Rectangle(FX, FY, FX1 + 1, FY1 + 1);

      skRoundRectangle:
        begin
          if FDY < FDX then min := FDY
          else              min := FDX;

          if FCurve = 0 then
            min := min div 4
          else
            min := Round(FCurve * FScaleX * 10);
          RoundRect(FX, FY, FX1 + 1, FY1 + 1, min, min);
        end;

      skEllipse:
        Ellipse(FX, FY, FX1 + 1, FY1 + 1);

      skTriangle:
        Polygon([Point(FX1, FY1), Point(FX, FY1), Point(FX + FDX div 2, FY), Point(FX1, FY1)]);

      skDiamond:
        Polygon([Point(FX + FDX div 2, FY), Point(FX1, FY + FDY div 2),
          Point(FX + FDX div 2, FY1), Point(FX, FY + FDY div 2)]);

      skDiagonal1:
        DrawLine(FX, FY1, FX1, FY, FFrameWidth);

      skDiagonal2:
        DrawLine(FX, FY, FX1, FY1, FFrameWidth);
    end;
  end;

  procedure DrawShapeWithFill;
  begin
{$IFNDEF FPC}
    if (FShape in [skDiagonal1, skDiagonal2]) or (FillType = ftBrush) then
    begin
      DrawShape;
      Exit;
    end;
    rgn := CreateRectRgn(0, 0, 10000, 10000);
    GetClipRgn(Canvas.Handle, rgn);
    BeginPath(Canvas.Handle);
    DrawShape;
    EndPath(Canvas.Handle);
    SelectClipPath(Canvas.Handle, RGN_COPY);
    DrawBackground;
    Canvas.Brush.Style := bsClear;
    SelectClipRgn(Canvas.Handle, rgn);
    DeleteObject(rgn);
    DrawShape;
{$ELSE}
    DrawShape;
{$ENDIF}
  end;

  procedure DoDraw;
  begin
    with Canvas do
    begin
      Pen.Color := Self.Frame.Color;
      Pen.Width := FFrameWidth;
      Brush.Style := bsSolid;
      SetBkMode(Handle, Opaque);

      if BrushStyle = bsSolid then
      begin
        Pen.Style := TPenStyle(Self.Frame.Style);
        if Self.Frame.Color = clNone then
          Pen.Style := psClear;
        if Self.Color <> clNone then
          Brush.Color := Self.Color else
          Brush.Style := bsClear;
        DrawShapeWithFill;
      end
      else
      begin
        Pen.Style := TPenStyle(Self.Frame.Style);
        if Self.Frame.Color = clNone then
          Pen.Style := psClear;
        if Self.Color <> clNone then
        begin
          Brush.Color := Self.Color;
          DrawShapeWithFill;
        end;
        Brush.Style := BrushStyle;
        Brush.Color := Self.Frame.Color;
        DrawShapeWithFill;
      end;
    end;
  end;

begin
  if Frame.Style = fsDouble then
  begin
    Frame.Style := fsSolid;
    SaveLeft := Left;
    SaveTop := Top;
    SaveWidth := Width;
    SaveHeight := Height;
    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    DoDraw;
    case FShape of
      skRectangle, skRoundRectangle, skEllipse:
        begin
          Left := Left + 2 * Frame.Width;
          Top := Top + 2 * Frame.Width;
          Width := Width - 4 * Frame.Width;
          Height := Height - 4 * Frame.Width;
        end;

      skTriangle:
        begin
          Left := Left + 4 * Frame.Width;
          Top := Top + 4 * Frame.Width;
          Width := Width - 8 * Frame.Width;
          Height := Height - 6 * Frame.Width;
        end;

      skDiamond:
        begin
          Left := Left + 3 * Frame.Width;
          Top := Top + 3 * Frame.Width;
          Width := Width - 6 * Frame.Width;
          Height := Height - 6 * Frame.Width;
        end;

      skDiagonal1, skDiagonal2:
        begin
          Left := Left + 2 * Frame.Width;
        end;
    end;

    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    DoDraw;

    Frame.Style := fsDouble;
    Left := SaveLeft;
    Top := SaveTop;
    Width := SaveWidth;
    Height := SaveHeight;
  end
  else
  begin
    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    DoDraw;
  end;
end;

function TfrxShapeView.Diff(AComponent: TfrxComponent): String;
begin
  Result := inherited Diff(AComponent);

  if FShape <> TfrxShapeView(AComponent).FShape then
    Result := Result + ' Shape="' + frxValueToXML(FShape) + '"';
end;

class function TfrxShapeView.GetDescription: String;
begin
  Result := frxResources.Get('obShape');
end;

{ TfrxHighlight }

constructor TfrxHighlight.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFont := TFont.Create;
  with FFont do
  begin
    PixelsPerInch := 96;
    Name := DefFontName;
    Size := DefFontSize;
    Color := clRed;
    Charset := frxCharset;
  end;
  FFill := TfrxBrushFill.Create;
  FFrame := TfrxFrame.Create;
  FApplyFont := True;
  FApplyFill := True;
  FVisible := True;
end;

destructor TfrxHighlight.Destroy;
begin
  FFont.Free;
  FFill.Free;
  FFrame.Free;
  inherited;
end;

procedure TfrxHighlight.Assign(Source: TPersistent);
begin
  if Source is TfrxHighlight then
  begin
    ApplyFont := TfrxHighlight(Source).ApplyFont;
    ApplyFill := TfrxHighlight(Source).ApplyFill;
    ApplyFrame := TfrxHighlight(Source).ApplyFrame;
    Font := TfrxHighlight(Source).Font;
    Fill := TfrxHighlight(Source).Fill;
    Frame := TfrxHighlight(Source).Frame;
    Condition := TfrxHighlight(Source).Condition;
    Visible := TfrxHighlight(Source).Visible;
    FInteractiveType := TfrxHighlight(Source).InteractiveType;
  end;
end;

procedure TfrxHighlight.SetFill(const Value: TfrxCustomFill);
begin
  FillType := frxGetFillType(Value);
  FFill.Assign(Value);
end;

procedure TfrxHighlight.SetFillType(const Value: TfrxFillType);
begin
  if FillType = Value then Exit;
  FFill.Free;
  FFill := frxCreateFill(Value);
end;

function TfrxHighlight.GetFillType: TfrxFillType;
begin
  Result := frxGetFillType(FFill);
end;

function TfrxHighlight.IsUniqueNameStored: Boolean;
begin
  Result := True;
end;

procedure TfrxHighlight.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TfrxHighlight.SetColor(const Value: TColor);
begin
  if Fill is TfrxBrushFill then
    TfrxBrushFill(Fill).BackColor := Value;
end;

function TfrxHighlight.GetColor: TColor;
begin
  if Fill is TfrxBrushFill then
    Result := TfrxBrushFill(Fill).BackColor
  else
    Result := clNone;
end;

procedure TfrxHighlight.SetFrame(const Value: TfrxFrame);
begin
  FFrame.Assign(Value);
end;


{ TfrxHighlightCollection }

constructor TfrxHighlightCollection.Create;
begin
  inherited Create(TfrxHighlight);
end;

function TfrxHighlightCollection.GetItem(Index: Integer): TfrxHighlight;
begin
  Result := TfrxHighlight(inherited Items[Index]);
end;


{ TfrxFormat }

procedure TfrxFormat.Assign(Source: TPersistent);
begin
  if Source is TfrxFormat then
  begin
    FDecimalSeparator := TfrxFormat(Source).DecimalSeparator;
    FThousandSeparator := TfrxFormat(Source).ThousandSeparator;
    FFormatStr := TfrxFormat(Source).FormatStr;
    FKind := TfrxFormat(Source).Kind;
  end;
end;


{ TfrxFormatCollection }

constructor TfrxFormatCollection.Create;
begin
  inherited Create(TfrxFormat);
end;

function TfrxFormatCollection.GetItem(Index: Integer): TfrxFormat;
begin
  Result := TfrxFormat(inherited Items[Index]);
end;


{ TfrxStretcheable }

constructor TfrxStretcheable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStretchMode := smDontStretch;
end;

function TfrxStretcheable.CalcHeight: Extended;
begin
  Result := Height;
end;

function TfrxStretcheable.DrawPart: Extended;
begin
  Result := 0;
end;

procedure TfrxStretcheable.InitPart;
begin
//
end;

function TfrxStretcheable.HasNextDataPart(aFreeSpace: Extended): Boolean;
begin
  Result := not (Top + FSaveHeight <= aFreeSpace);
end;


{ TfrxCustomMemoView }

constructor TfrxCustomMemoView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  frComponentStyle := frComponentStyle - [csDefaultDiff] + [csHandlesNestedProperties];
  FHighlights := TfrxHighlightCollection.Create;
  FFormats := TfrxFormatCollection.Create;
{$IFDEF Delphi10}
  FMemo := TfrxWideStrings.Create;
{$ELSE}
  FMemo := TWideStrings.Create;
{$ENDIF}
  FAllowExpressions := True;
  FClipped := True;
  FExpressionDelimiters := '[,]';
  FGapX := 2;
  FGapY := 1;
  FHAlign := haLeft;
  FVAlign := vaTop;
  FLineSpacing := 2;
  ParentFont := True;
  FWordWrap := True;
  FWysiwyg := True;
  FLastValue := Null;
  FMacroIndex := -1;
  FMacroLine := -1;
  FMacroLoaded := False;
end;

destructor TfrxCustomMemoView.Destroy;
begin
  FHighlights.Free;
  FFormats.Free;
  FMemo.Free;
  inherited;
end;

class function TfrxCustomMemoView.GetDescription: String;
begin
  Result := frxResources.Get('obText');
end;

procedure TfrxCustomMemoView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FFlowTo) then
    FFlowTo := nil;
end;

procedure TfrxCustomMemoView.ProcessDictionary(aItem: TfrxMacrosItem;
  aReport: TfrxReport; PostProcessor: TfrxPostProcessor);
var
  sName: String;
  s: WideString;
  Index: Integer;
begin
  Index := aItem.Count - 1;
  s := Text;
  sName := aReport.CurObject;
  try
    aReport.CurObject := Name;
    GetData;
    aReport.DoNotifyEvent(Self, Self.OnAfterData);
    aItem.Item[Index] := Text;
  finally
    aReport.CurObject := sName;
    Text := s;
  end;
end;

function TfrxCustomMemoView.LoadContentFromDictionary(aReport: TfrxReport;
  aItem: TfrxMacrosItem): Boolean;
var
  ItemIdx: Integer;
  lComponent: TfrxComponent;
begin
  Result := False;
  if (aItem <> nil) and not FMacroLoaded then
    if TryStrToInt(Memo[0], ItemIdx) then
    begin
      FMacroLoaded := True;
      if (Duplicates = dmClear) and (aItem.FLastIndex = ItemIdx) then
        Text := ''
      else
        Text := aItem.Item[ItemIdx];
      lComponent := aItem.FComponent;

      if (Duplicates in [dmHide, dmMerge, dmClear]) and (aItem.FLastIndex = ItemIdx) then
      begin
        if (lComponent <> nil) and (Duplicates = dmMerge) then
          lComponent.Height := AbsTop - lComponent.AbsTop + Height;
        if (Duplicates <> dmClear) then
          Result := True;//aComponent.Free;

      end;
      if (aItem.FLastIndex <> ItemIdx) then
        aItem.FComponent := Self;

      aItem.FLastIndex := ItemIdx;

    end;
end;

procedure TfrxCustomMemoView.Loaded;
begin
  inherited Loaded;
  // backward compatibility, to support Highlight.Active
  // moved, cause see in ticket # 294150
//  if Highlight.Active then
//    ApplyHighlight(Highlight);
end;

procedure TfrxCustomMemoView.MirrorContent(
  MirrorModes: TfrxMirrorControlModes);
begin
  inherited MirrorContent(MirrorModes);
  if mcmRTLContent in MirrorModes then
  begin
    if HAlign = haLeft then
      HAlign := haRight
    else if HAlign = haRight then
      HAlign := haLeft;
  end;
  if mcmBTTContent in MirrorModes then
  begin
    if VAlign = vaTop then
      VAlign := vaBottom
    else if VAlign = vaBottom then
      VAlign := vaTop;
  end;
  if mcmRTLSpecial in MirrorModes then
    RTLReading := True;
end;

procedure TfrxCustomMemoView.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Formats', ReadFormats, WriteFormats, Formats.Count > 1);
  Filer.DefineProperty('Highlights', ReadHighlights, WriteHighlights, Highlights.Count > 1);
end;

procedure TfrxCustomMemoView.WriteFormats(Writer: TWriter);
begin
  frxWriteCollection(FFormats, Writer, Self);
end;

procedure TfrxCustomMemoView.WriteHighlights(Writer: TWriter);
begin
  frxWriteCollection(FHighlights, Writer, Self);
end;

procedure TfrxCustomMemoView.ReadFormats(Reader: TReader);
begin
  frxReadCollection(FFormats, Reader, Self);
end;

procedure TfrxCustomMemoView.ReadHighlights(Reader: TReader);
begin
  frxReadCollection(FHighlights, Reader, Self);
end;

function TfrxCustomMemoView.IsExprDelimitersStored: Boolean;
begin
  Result := FExpressionDelimiters <> '[,]';
end;

function TfrxCustomMemoView.IsLineSpacingStored: Boolean;
begin
  Result := FLineSpacing <> 2;
end;

function TfrxCustomMemoView.IsGapXStored: Boolean;
begin
  Result := FGapX <> 2;
end;

function TfrxCustomMemoView.IsGapYStored: Boolean;
begin
  Result := FGapY <> 1;
end;

function TfrxCustomMemoView.IsParagraphGapStored: Boolean;
begin
  Result := FParagraphGap <> 0;
end;

function TfrxCustomMemoView.IsPostProcessAllowed: Boolean;
begin
  Result := inherited IsPostProcessAllowed or (Duplicates <> dmShow);
end;

function TfrxCustomMemoView.IsCharSpacingStored: Boolean;
begin
  Result := FCharSpacing <> 0;
end;

function TfrxCustomMemoView.IsHighlightStored: Boolean;
begin
  Result := (FHighlights.Count = 1) and (Trim(Highlight.Condition) <> '');
end;

function TfrxCustomMemoView.IsDisplayFormatStored: Boolean;
begin
  Result := FFormats.Count = 1;
end;

function TfrxCustomMemoView.GetHighlight: TfrxHighlight;
begin
  if FHighlights.Count = 0 then
    FHighlights.Add;
  Result := FHighlights[0];
end;

function TfrxCustomMemoView.GetDisplayFormat: TfrxFormat;
begin
  if FFormats.Count = 0 then
    FFormats.Add;
  Result := FFormats[0];
end;

procedure TfrxCustomMemoView.SetRotation(Value: Integer);
begin
  FRotation := Value mod 360;
end;

function TfrxCustomMemoView.GetUnderlines: Boolean;
begin
  Result := not (FUnderlinesTextMode in [ulmNone]);
end;

procedure TfrxCustomMemoView.SetUnderlines(const Value: Boolean);
begin
  if not Value then
    FUnderlinesTextMode := ulmNone
  else
    if FUnderlinesTextMode = ulmNone then
      FUnderlinesTextMode := ulmUnderlinesAll;
end;

procedure TfrxCustomMemoView.SetText(const Value: WideString);
begin
 { if (FFont.Charset <> DEFAULT_CHARSET) and (Report <> nil) then
    FMemo.Text := AnsiToUnicode(Value, FFont.Charset)
  else}
  FMemo.Text := Value;
end;

procedure TfrxCustomMemoView.SetAnsiText(const Value: AnsiString);
begin
  FMemo.Text := AnsiToUnicode(Value, FFont.Charset);
end;

function TfrxCustomMemoView.GetText: WideString;
begin
  Result := FMemo.Text;
end;

function TfrxCustomMemoView.GetAnsiText: AnsiString;
begin
  Result := _UnicodeToAnsi(FMemo.Text,FFont.Charset);
end;

procedure TfrxCustomMemoView.SetMemo(const Value: TWideStrings);
begin
  FMemo.Assign(Value);
end;

procedure TfrxCustomMemoView.SetHighlight(const Value: TfrxHighlight);
begin
  Highlight.Assign(Value);
end;

procedure TfrxCustomMemoView.SetDisplayFormat(const Value: TfrxFormat);
begin
  DisplayFormat.Assign(Value);
end;

procedure TfrxCustomMemoView.SetStyle(const Value: String);
begin
  FStyle := Value;
  if Report <> nil then
    ApplyStyle(Report.Styles.Find(FStyle));
end;

function TfrxCustomMemoView.AdjustCalcHeight: Extended;
begin
  Result := GapY * 2;
  if ftTop in Frame.Typ then
    Result := Result + (Frame.Width - 1) / 2;
  if ftBottom in Frame.Typ then
    Result := Result + Frame.Width / 2;
  if Frame.DropShadow then
    Result := Result + Frame.ShadowWidth;
end;

function TfrxCustomMemoView.AdjustCalcWidth: Extended;
begin
  Result := GapX * 2;
  if ftLeft in Frame.Typ then
    Result := Result + (Frame.Width - 1) / 2;
  if ftRight in Frame.Typ then
    Result := Result + Frame.Width / 2;
  if Frame.DropShadow then
    Result := Result + Frame.ShadowWidth;
end;

procedure TfrxCustomMemoView.BeginDraw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
var
  SaveWidth: Extended;
  FDrawText: TfrxDrawText;
begin
  FDrawText := GetDrawTextObject;
  FDrawText.UseDefaultCharset := FUseDefaultCharset;
  FDrawText.UseMonoFont := FDrawAsMask;
  FDrawText.SetFont(FFont);
  FDrawText.SetOptions(FWordWrap, FAllowHTMLTags, FRTLReading, FWordBreak,
    FClipped, FWysiwyg, FRotation);
  FDrawText.SetGaps(FParagraphGap, FCharSpacing, FLineSpacing);

  if not IsDesigning then
    if FAutoWidth then
    begin
      FDrawText.SetDimensions(1, 1, 1, Rect(0, 0, 10000, 10000), Rect(0, 0, 10000, 10000));
      FDrawText.SetText(FMemo);
      SaveWidth := Width;
      if (FRotation = 90) or (FRotation = 270) then
        Width := FDrawText.CalcHeight + AdjustCalcWidth
      else
        Width := FDrawText.CalcWidth + AdjustCalcWidth;
      if FHAlign = haRight then
        Left := Left + SaveWidth - Width
      else if FHAlign = haCenter then
        Left := Left + (SaveWidth - Width) / 2;
      if Parent <> nil then
        Parent.AlignChildren;
    end;

  inherited BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  FScaledRect := CalcTextRect(OffsetX, OffsetY, ScaleX, ScaleY);
  FTextRect := CalcTextRect(0, 0, 1, 1);
end;

procedure TfrxCustomMemoView.SetDrawParams(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
var
  FDrawText: TfrxDrawText;
begin
  FDrawText := GetDrawTextObject;
  FDrawText.UseDefaultCharset := FUseDefaultCharset;
  FDrawText.UseMonoFont := FDrawAsMask;
  FDrawText.SetFont(FFont);
  FDrawText.SetOptions(FWordWrap, FAllowHTMLTags, FRTLReading, FWordBreak,
    FClipped, FWysiwyg, FRotation);
  FDrawText.SetGaps(FParagraphGap, FCharSpacing, FLineSpacing);

  if not IsPrinting then
    FPrintScale := 1;
  if (ScaleX = 1) and (ScaleY = 1) and (OffsetX = 0) and (OffsetY = 0) then
    FDrawText.SetDimensions(ScaleX, ScaleY, FPrintScale, FTextRect, FTextRect)
  else
    FDrawText.SetDimensions(ScaleX, ScaleY, FPrintScale, FTextRect,
      FScaledRect);
  FDrawText.SetText(FMemo, FFirstParaBreak);
  FDrawText.SetParaBreaks(FFirstParaBreak, FLastParaBreak);
end;

procedure TfrxCustomMemoView.DrawText;
var
  FDrawText: TfrxDrawText;
{
  procedure DrawUnderlines;
  var
    dy, h: Extended;
  begin
    with FCanvas do
    begin
      Pen.Color := Self.Frame.Color;
      Pen.Width := FFrameWidth;
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;
    end;

    h := FDrawText.LineHeight * FScaleY;
    dy := FY + h + (GapY - LineSpacing + 1) * FScaleY;
    while dy < FY1 do
    begin
      FCanvas.MoveTo(FX, Round(dy));
      FCanvas.LineTo(FX1, Round(dy));
      dy := dy + h;
    end;
  end;
}
begin
  FDrawText := GetDrawTextObject;
  FDrawText.UseDefaultCharset := FUseDefaultCharset;

  if not IsDesigning then
    ExtractMacros
  else if IsDataField then
    FMemo.Text := '[' + DataSet.UserName + '."' + DataField + '"]';

  FDrawText.Lock;
  try
    SetDrawParams(FCanvas, FScaleX, FScaleY, FOffsetX, FOffsetY);
    if (FUnderlinesTextMode <> ulmNone) and (FRotation = 0) then
    with FCanvas do
    begin
      Pen.Color := Self.Frame.Color;
      Pen.Width := FFrameWidth;
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;
    end;
    FDrawText.VC := FVC;
    try
      FDrawText.DrawText(FCanvas, HAlign, VAlign, FUnderlinesTextMode);
    finally
      FDrawText.VC := nil;
    end;
  finally
    FDrawText.Unlock;
  end;
end;

procedure TfrxCustomMemoView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  if FVC = nil then
  begin
    DrawBackground;
    DrawFrame;
    DrawFrameEdges;
  end;
  DrawText;
  if Assigned(FComponentEditors) then
    FComponentEditors.DrawCustomEditor(FCanvas, Rect(FX, FY, FX1, FY1));
end;

function TfrxCustomMemoView.CalcHeight: Extended;
var
  FDrawText: TfrxDrawText;
  bVerticalText: Boolean;
begin
  FDrawText := GetDrawTextObject;
  bVerticalText := (FRotation = 90) or (FRotation = 270);
  FDrawText.Lock;
  try
    FDrawText.SetFont(FFont);
    FDrawText.SetOptions(FWordWrap, FAllowHTMLTags, FRTLReading, FWordBreak,
      FClipped, FWysiwyg, FRotation);
    FDrawText.SetGaps(FParagraphGap, FCharSpacing, FLineSpacing);

    if FAutoWidth or bVerticalText then
      FDrawText.SetDimensions(1, 1, 1, Rect(0, 0, 10000, 10000), Rect(0, 0, 10000, 10000))
    else
    begin
      BeginDraw(nil, 1, 1, 0, 0);
      FDrawText.SetDimensions(1, 1, 1, FTextRect, FTextRect);
    end;

    FDrawText.SetText(FMemo);
    if bVerticalText then
      Result := Round(FDrawText.CalcWidth + AdjustCalcHeight)
    else
      Result := Round(FDrawText.CalcHeight + AdjustCalcHeight);
  finally
    FDrawText.Unlock;
  end;
end;

function TfrxCustomMemoView.CalcTextRect(OffsetX, OffsetY, ScaleX, ScaleY: Extended): TRect;
var
  bx, by, bx1, by1, wx1, wx2, wy1, wy2, gx1, gy1: Integer;
begin
  wx1 := Round((Frame.Width * ScaleX - 1) / 2);
  wx2 := Round(Frame.Width * ScaleX / 2);
  wy1 := Round((Frame.Width * ScaleY - 1) / 2);
  wy2 := Round(Frame.Width * ScaleY / 2);

  bx := Round(AbsLeft * ScaleX + OffsetX);;
  by := Round(AbsTop * ScaleY + OffsetY);
  // bx1 := FX1;
  // by1 := FY1;
  if Frame.DropShadow then
  begin
    bx1 := bx + Round((Width - Frame.ShadowWidth) * ScaleX);
    by1 := by + Round((Height - Frame.ShadowWidth) * ScaleY);
  end
  else
  begin
    bx1 := bx + Round(Width * ScaleX);
    by1 := by + Round(Height * ScaleY);
  end;

  if ftLeft in Frame.Typ then
    Inc(bx, wx1);
  if ftRight in Frame.Typ then
    Dec(bx1, wx2);
  if ftTop in Frame.Typ then
    Inc(by, wy1);
  if ftBottom in Frame.Typ then
    Dec(by1, wy2);
  gx1 := Round(GapX * ScaleX);
  gy1 := Round(GapY * ScaleY);

  Result := Rect(bx + gx1, by + gy1, bx1 - gx1 + 1, by1 - gy1 + 1);
end;

function TfrxCustomMemoView.CalcWidth: Extended;
var
  FDrawText: TfrxDrawText;
  bVerticalText: Boolean;
begin
  FDrawText := GetDrawTextObject;
  bVerticalText := (FRotation = 90) or (FRotation = 270);
  FDrawText.Lock;
  try
    FDrawText.SetFont(FFont);
    FDrawText.SetOptions(FWordWrap, FAllowHTMLTags, FRTLReading, FWordBreak,
      FClipped, FWysiwyg, FRotation);
    FDrawText.SetGaps(FParagraphGap, FCharSpacing, FLineSpacing);
    if bVerticalText then
    begin
      FTextRect := CalcTextRect(0, 0, 1, 1);
      FDrawText.SetDimensions(1, 1, 1, FTextRect, FTextRect);
    end
    else
      FDrawText.SetDimensions(1, 1, 1, Rect(0, 0, 10000, 10000), Rect(0, 0, 10000, 10000));
    FDrawText.SetText(FMemo);
    if bVerticalText then
      Result := Round(FDrawText.CalcHeight + AdjustCalcWidth)
    else
      Result := Round(FDrawText.CalcWidth + AdjustCalcWidth);
  finally
    FDrawText.Unlock;
  end;
end;

procedure TfrxCustomMemoView.InitPart;
begin
  FPartMemo := FMemo.Text;
  FFirstParaBreak := False;
  FLastParaBreak := False;
end;

function TfrxCustomMemoView.DrawPart: Extended;
var
  FDrawText: TfrxDrawText;
  ParaBreak: Boolean;
begin
  FDrawText := GetDrawTextObject;

  FDrawText.Lock;
  try
    FMemo.Text := FPartMemo;
    BeginDraw(nil, 1, 1, 0, 0);
    SetDrawParams(nil, 1, 1, 0, 0);
    FPartMemo := FDrawText.GetOutBoundsText(ParaBreak);
    FMemo.Text := FDrawText.GetInBoundsText;
    FLastParaBreak := ParaBreak;

    Result := FDrawText.UnusedSpace;
    if Result = 0 then
      Result := Height
	else
	  Result := Result + GapY * 2;

  finally
    FDrawText.Unlock;
  end;
end;

function TfrxCustomMemoView.Diff(AComponent: TfrxComponent): String;
var
  m: TfrxCustomMemoView;
  s: WideString;
  c: Integer;
begin
  Result := inherited Diff(AComponent);
  m := TfrxCustomMemoView(AComponent);

  if FAutoWidth <> m.FAutoWidth then
    Result := Result + ' AutoWidth="' + frxValueToXML(FAutoWidth) + '"';
  if frxFloatDiff(FCharSpacing, m.FCharSpacing) then
    Result := Result + ' CharSpacing="' + FloatToStr(FCharSpacing) + '"';
  if frxFloatDiff(FGapX, m.FGapX) then
    Result := Result + ' GapX="' + FloatToStr(FGapX) + '"';
  if frxFloatDiff(FGapY, m.FGapY) then
    Result := Result + ' GapY="' + FloatToStr(FGapY) + '"';
  if FHAlign <> m.FHAlign then
    Result := Result + ' HAlign="' + frxValueToXML(FHAlign) + '"';
  if frxFloatDiff(FLineSpacing, m.FLineSpacing) then
    Result := Result + ' LineSpacing="' + FloatToStr(FLineSpacing) + '"';
  if FUseDefaultCharset <> m.UseDefaultCharset then
    Result := Result + ' UseDefaultCharset="' + frxValueToXML(UseDefaultCharset) + '"';

  c := FMemo.Count;
  if c = 0 then
    Result := Result + ' u=""'
  else
  begin
    if c = 1 then
{$IFDEF Delphi12}
      Result := Result + ' u="' + frxStrToXML(FMemo[0]) + '"'
{$ELSE}
{$IFDEF FPC}
      Result := Result + ' u="' + frxStrToXML(FMemo[0]) + '"'
{$ELSE}
      Result := Result + ' u="' + frxStrToXML(Utf8Encode(FMemo[0])) + '"'
{$ENDIF}
{$ENDIF}
    else
    begin
      s := Text;
      SetLength(s, Length(s) - 2);
{$IFDEF delphi12}
      Result := Result + ' u="' + frxStrToXML(s) + '"';
{$ELSE}
{$IFDEF FPC}
      Result := Result + ' u="' + frxStrToXML(s) + '"';
{$ELSE}
      Result := Result + ' u="' + frxStrToXML(Utf8Encode(s)) + '"';
{$ENDIF}
{$ENDIF}
    end;
  end;

  if FHint <> '' then
    Result := Result + ' Hint="' + frxStrToXML(FHint) + '"';

  if frxFloatDiff(FParagraphGap, m.FParagraphGap) then
    Result := Result + ' ParagraphGap="' + FloatToStr(FParagraphGap) + '"';
  if FRotation <> m.FRotation then
    Result := Result + ' Rotation="' + IntToStr(FRotation) + '"';
  if FRTLReading <> m.FRTLReading then
    Result := Result + ' RTLReading="' + frxValueToXML(FRTLReading) + '"';
  if FUnderlinesTextMode <> m.FUnderlinesTextMode then
    Result := Result + ' UnderlinesTextMode="' + frxValueToXML(FUnderlinesTextMode) + '"';
  if FVAlign <> m.FVAlign then
    Result := Result + ' VAlign="' + frxValueToXML(FVAlign) + '"';
  if FWordWrap <> m.FWordWrap then
    Result := Result + ' WordWrap="' + frxValueToXML(FWordWrap) + '"';

  { formatting }
  if Formats.Count = 1 then
  begin
    if DisplayFormat.FKind <> m.DisplayFormat.FKind then
      Result := Result + ' DisplayFormat.Kind="' + frxValueToXML(DisplayFormat.FKind) + '"';
    if DisplayFormat.FDecimalSeparator <> m.DisplayFormat.FDecimalSeparator then
      Result := Result + ' DisplayFormat.DecimalSeparator="' + frxStrToXML(DisplayFormat.FDecimalSeparator) + '"';
    if DisplayFormat.FThousandSeparator <> m.DisplayFormat.FThousandSeparator then
      Result := Result + ' DisplayFormat.ThousandSeparator="' + frxStrToXML(DisplayFormat.FThousandSeparator) + '"';
    if DisplayFormat.FFormatStr <> m.DisplayFormat.FFormatStr then
      Result := Result + ' DisplayFormat.FormatStr="' + frxStrToXML(DisplayFormat.FFormatStr) + '"';
  end;

  if FFirstParaBreak then
    Result := Result + ' FirstParaBreak="1"';
  if FLastParaBreak then
    Result := Result + ' LastParaBreak="1"';

  FFirstParaBreak := FLastParaBreak;
  FLastParaBreak := False;
end;

procedure TfrxCustomMemoView.DoMouseEnter(aPreviousObject: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams);
begin
  Inherited DoMouseEnter(APreviousObject, EventParams);
end;

procedure TfrxCustomMemoView.DoMouseLeave(aNextObject: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams);
begin
  Inherited DoMouseLeave(aNextObject, EventParams);
end;


procedure TfrxCustomMemoView.BeforePrint;
begin
  inherited;
  if not IsDataField then
    FTempMemo := FMemo.Text;
end;

procedure TfrxCustomMemoView.AfterPrint;
begin
  if not IsDataField then
    FMemo.Text := FTempMemo;
  if FHighlightActivated then
    RestorePreHighlightState;
  inherited;
end;

procedure TfrxCustomMemoView.SaveContentToDictionary(
  aReport: TfrxReport; PostProcessor: TfrxPostProcessor);
var
  s{, dc1, dc2}: WideString;
  bName: String;
  Index: Integer;
begin
  bName := '';
  if Assigned(Parent) then
    bName := Parent.Name;
  if IsDataField then
  begin
    //dc1 := FExpressionDelimiters;
    //dc2 := Copy(dc1, Pos(',', dc1) + 1, 255);
    //dc1 := Copy(dc1, 1, Pos(',', dc1) - 1);
    s := VarToStr(Report.Calc({dc1 + }DatasetName + '."' + DataField + '"'{ + dc2}));
  end
  else
    s := Text;
  if (Length(s) >= 2) and (s[Length(s) - 1] = #13) and (s[Length(s)] = #10) then
    Delete(s, Length(s) - 1, 2);

{$IFDEF UNIX} // delete LineEnding
  if (Length(s) >= 1) and (s[Length(s)] = #10) then
    Delete(s, Length(s), 1);
        {$ENDIF}
  Index := PostProcessor.Add(bName, Name, s, Processing.ProcessAt, Self,
    ((Processing.ProcessAt <> paDefault) or (Duplicates <> dmShow)) and
    (bName <> ''));
  if Index <> -1 then
    Text := IntToStr(Index);
end;

procedure TfrxCustomMemoView.SavePreHighlightState;
begin
  FHighlightActivated := True;

  FTempFill := frxCreateFill(FillType);
  FTempFill.Assign(FFill);

  FTempFont := TFont.Create;
  FTempFont.Assign(FFont);

  FTempFrame := TfrxFrame.Create;
  FTempFrame.Assign(FFrame);

  FTempVisible := Visible;
end;

procedure TfrxCustomMemoView.RestorePreHighlightState;
begin
  FHighlightActivated := False;

  Fill := FTempFill;
  FTempFill.Free;
  FTempFill := nil;

  FFont.Assign(FTempFont);
  FTempFont.Free;
  FTempFont := nil;

  FFrame.Assign(FTempFrame);
  FTempFrame.Free;
  FTempFrame := nil;

  Visible := FTempVisible;
end;

procedure TfrxCustomMemoView.GetData;
var
  i, j, nFormat: Integer;
  s, s1, s2, dc1, dc2: WideString;
  ThLocale: Cardinal;
  LocCharset: Boolean;
begin
  inherited;
  ThLocale := 0;
  if FFormats.Count = 0 then
    FFormats.Add;

  LocCharset := ((Font.Charset <> DEFAULT_CHARSET) and  not FUseDefaultCharset);
  if IsDataField then
  begin
    if DataSet.IsBlobField(DataField) then
    begin
      {$IFNDEF FPC}
      if LocCharset then
      begin
        ThLocale := GetThreadLocale;
        SetThreadLocale(GetLocalByCharSet(Font.Charset));
      end;
      {$ENDIF}
      DataSet.AssignBlobTo(DataField, FMemo);
      {$IFNDEF FPC}
      if LocCharset then
        SetThreadLocale(ThLocale);
      {$ENDIF}
    end
    else
    begin
      FValue := DataSet.Value[DataField];
      if DisplayFormat.Kind = fkText then
      begin
        if LocCharset then
          FMemo.Text := AnsiToUnicode(AnsiString(DataSet.DisplayText[DataField]), Font.Charset) else
          FMemo.Text := DataSet.DisplayText[DataField];
      end
      else FMemo.Text := FormatData(FValue);
      if FHideZeros and (not VarIsNull(FValue)) and (TVarData(FValue).VType <> varString) and
      {$IFDEF Delphi12}(TVarData(FValue).VType <> varUString) and{$ENDIF}
        (TVarData(FValue).VType <> varOleStr) and SameValue(FValue, 0) then
        FMemo.Text := '';
    end;
  end
  else if AllowExpressions then
  begin
    s := FMemo.Text;
    i := 1;
    dc1 := FExpressionDelimiters;
    dc2 := Copy(dc1, Pos(',', dc1) + 1, 255);
    dc1 := Copy(dc1, 1, Pos(',', dc1) - 1);
    nFormat := 0;

    if Pos(dc1, s) <> 0 then
    begin
      repeat
        while (i < Length(s)) and (Copy(s, i, Length(dc1)) <> dc1) do Inc(i);

        s1 := frxGetBrackedVariableW(s, dc1, dc2, i, j);
        if i <> j then
        begin
          Delete(s, i, j - i + 1);
          s2 := CalcAndFormat(s1, FFormats[nFormat]);
          Insert(s2, s, i);
          Inc(i, Length(s2));
          j := 0;
          if nFormat < FFormats.Count - 1 then
            Inc(nFormat);
        end;
      until i = j;

      FMemo.Text := s;
    end;
  end;

  Report.LocalValue := FValue;
  for i := 0 to FHighlights.Count - 1 do
    if (FHighlights[i].Condition <> '') and (Report.Calc(FHighlights[i].Condition) = True) then
    begin
      SavePreHighlightState;
      ApplyHighlight(FHighlights[i]);
      break;
    end;

  if FSuppressRepeated then
  begin
    if FLastValue = FMemo.Text then
      FMemo.Text := '' else
      FLastValue := FMemo.Text;
  end;

  if FFlowTo <> nil then
  begin
    InitPart;
    DrawPart;
    FFlowTo.Text := FPartMemo;
    FFlowTo.AllowExpressions := False;
  end;
end;

procedure TfrxCustomMemoView.ResetSuppress;
begin
  FLastValue := '';
end;

function TfrxCustomMemoView.CalcAndFormat(const Expr: WideString; Format: TfrxFormat): WideString;
var
  i: Integer;
  ExprStr, FormatStr: WideString;
  needFreeFormat: Boolean;
begin
  Result := '';
  needFreeFormat := False;

  i := Pos(WideString(' #'), Expr);
  if i <> 0 then
  begin
    ExprStr := Copy(Expr, 1, i - 1);
    FormatStr := Copy(Expr, i + 2, Length(Expr) - i - 1);
    if Pos(')', FormatStr) = 0 then
    begin
      Format := TfrxFormat.Create(nil);
      needFreeFormat := True;

{$IFDEF Delphi12}
      if CharInSet(FormatStr[1], [WideChar('N'), WideChar('n')]) then
{$ELSE}
      if FormatStr[1] in [WideChar('N'), WideChar('n')] then
{$ENDIF}
      begin
        Format.Kind := fkNumeric;
        for i := 1 to Length(FormatStr) do
{$IFDEF Delphi12}
          if CharInSet(FormatStr[i], [WideChar(','), WideChar('.'), WideChar('-')]) then
{$ELSE}
          if FormatStr[i] in [WideChar(','), WideChar('.'), WideChar('-')] then
{$ENDIF}
          begin
            Format.DecimalSeparator := FormatStr[i];
            FormatStr[i] := '.';
          end;
      end
{$IFDEF Delphi12}
      else if  CharInSet(FormatStr[1], [WideChar('D'), WideChar('T'), WideChar('d'), WideChar('t')]) then
{$ELSE}
      else if FormatStr[1] in [WideChar('D'), WideChar('T'), WideChar('d'), WideChar('t')] then
{$ENDIF}
        Format.Kind := fkDateTime
{$IFDEF Delphi12}
      else if CharInSet(FormatStr[1], [WideChar('B'), WideChar('b')]) then
{$ELSE}
      else if FormatStr[1] in [WideChar('B'), WideChar('b')] then
{$ENDIF}
        Format.Kind := fkBoolean;

      Format.FormatStr := Copy(FormatStr, 2, 255);
    end
    else
      ExprStr := Expr;
  end
  else
    ExprStr := Expr;

  try
    if CompareText(ExprStr, 'TOTALPAGES#') = 0 then
      FValue := '[TotalPages#]'
    else if CompareText(ExprStr, 'COPYNAME#') = 0 then
      FValue := '[CopyName#]'
    else
    begin
    if (Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset then
      FValue := Report.Calc(String(_UnicodeToAnsi(ExprStr, Font.Charset))) else
      FValue := Report.Calc(ExprStr)
    end;
    if FHideZeros and (not VarIsNull(FValue)) and (TVarData(FValue).VType <> varString) and
      (TVarData(FValue).VType <> varOleStr){$IFDEF Delphi12} and (TVarData(FValue).VType <> varUString){$ENDIF}  and SameValue(FValue, 0) then
      Result := '' else
      Result := FormatData(FValue, Format);
  finally
    if needFreeFormat then
      Format.Free;
  end;
end;

function TfrxCustomMemoView.FormatData(const Value: Variant; AFormat: TfrxFormat = nil): WideString;
var
  i, DecSepPos: Integer;
  LocCharset: Boolean;
begin
  DecSepPos := 0;
  LocCharset := ((Font.Charset <> DEFAULT_CHARSET) and not FUseDefaultCharset);
  if AFormat = nil then
    AFormat := DisplayFormat;
  if VarIsNull(Value) then
    Result := ''
  else if AFormat.Kind = fkText then
    if LocCharset then
      Result := AnsiToUnicode(AnsiString(VarToStr(Value)), Font.Charset)
    else Result := VarToWideStr(Value)
  else
  try
    case AFormat.Kind of
      fkNumeric:
        begin
          if (Pos('#', AFormat.FormatStr) <> 0) or (Pos('0', AFormat.FormatStr) = 1) then
            Result := FormatFloat(AFormat.FormatStr, Extended(Value))
          else if (Pos('d', AFormat.FormatStr) <> 0) or (Pos('u', AFormat.FormatStr) <> 0) then
            Result := Format(AFormat.FormatStr, [Integer(Value)])
          else
            Result := Format(AFormat.FormatStr, [Extended(Value)]);
          if (Length(AFormat.DecimalSeparator) = 1) and
{$IFDEF Delphi16}
                  (FormatSettings.DecimalSeparator <> AFormat.DecimalSeparator[1]) then
            for i := Length(Result) downto 1 do
              if Result[i] = WideChar(FormatSettings.DecimalSeparator) then
{$ELSE}
                  (DecimalSeparator <> AFormat.DecimalSeparator[1]) then
            for i := Length(Result) downto 1 do
              if Result[i] = WideChar(DecimalSeparator) then
{$ENDIF}

              begin
                DecSepPos := i; // save dec seporator pos
                break;
              end;

          if (Length(AFormat.ThousandSeparator) = 1) and
{$IFDEF Delphi16}
            (FormatSettings.ThousandSeparator <> AFormat.ThousandSeparator[1]) then
            for i := 1 to Length(Result) do
              if Result[i] = WideChar(FormatSettings.ThousandSeparator) then
                Result[i] := WideChar(AFormat.ThousandSeparator[1]);
{$ELSE}
            (ThousandSeparator <> AFormat.ThousandSeparator[1]) then
            for i := 1 to Length(Result) do
              if Result[i] = WideChar(ThousandSeparator) then
                Result[i] := WideChar(AFormat.ThousandSeparator[1]);
{$ENDIF}

          if DecSepPos > 0 then // replace dec seporator
            Result[DecSepPos] := WideChar(AFormat.DecimalSeparator[1]);
        end;

      fkDateTime:
        Result := FormatDateTime(AFormat.FormatStr, Value);

      fkBoolean:
        if Value = True then
           Result := Copy(AFormat.FormatStr, Pos(',', AFormat.FormatStr) + 1, 255) else
           Result := Copy(AFormat.FormatStr, 1, Pos(',', AFormat.FormatStr) - 1);
      else
        Result := VarToWideStr(Value)
    end;
  except
    if LocCharset then
      Result := AnsiToUnicode(AnsiString(VarToStr(Value)), Font.Charset)
    else Result := VarToWideStr(Value)
  end;
end;

function TfrxCustomMemoView.GetComponentText: String;
var
  i: Integer;
begin
  Result := FMemo.Text;
  if FAllowExpressions then   { extract TOTALPAGES macro if any }
  begin
    i := Pos('[TOTALPAGES]', UpperCase(Result));
    if i <> 0 then
    begin
      Delete(Result, i, 12);
      Insert(IntToStr(FTotalPages), Result, i);
    end;
  end;
end;

procedure TfrxCustomMemoView.ApplyStyle(Style: TfrxStyleItem);
begin
  if Style <> nil then
  begin
    if Style.ApplyFill then
      Fill := Style.Fill;
    if Style.ApplyFont then
      Font := Style.Font;
    if Style.ApplyFrame then
      Frame := Style.Frame;
  end;
end;

procedure TfrxCustomMemoView.ApplyHighlight(AHighlight: TfrxHighlight);
begin
  if AHighlight <> nil then
  begin
    if AHighlight.ApplyFont then
      Font := AHighlight.Font;
    if AHighlight.ApplyFill then
      Fill := AHighlight.Fill;
    if AHighlight.ApplyFrame then
      Frame := AHighlight.Frame;
    Visible := AHighlight.Visible;
  end;
end;

procedure TfrxCustomMemoView.ApplyPreviewHighlight;
begin
  if Highlight.Active then
    ApplyHighlight(Highlight);
end;

function TfrxCustomMemoView.WrapText(WrapWords: Boolean; aParaText: TWideStrings): WideString;
var
  TempBMP: TBitmap;
  FDrawText: TfrxDrawText;
  i: Integer;
begin
  Result := '';
  TempBMP := TBitmap.Create;
  FDrawText := GetDrawTextObject;

  FDrawText.Lock;
  try
    BeginDraw(nil, 1, 1, 0, 0);
    SetDrawParams(TempBMP.Canvas, 1, 1, 0, 0);
    if WrapWords then
      Result := FDrawText.WrappedText
    else
      Result := FDrawText.DeleteTags(Text);
  finally
    FDrawText.Unlock;
    TempBMP.Free;
    if aParaText <> nil then
    begin
      aParaText.Text := Result;
      if aParaText.Count = FDrawText.Text.Count then
        for i := 0 to FDrawText.Text.Count - 1 do
          aParaText.Objects[i] := FDrawText.Text.Objects[i];
    end;
  end;
end;

procedure TfrxCustomMemoView.ExtractMacros(Dictionary: TfrxPostProcessor = nil);

{$IFNDEF DELPHI12}
function PosExW(const SubStr, S: WideString; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;
{$ENDIF}
var
  s, s1: WideString;
  j, i, slen: Integer;
  bChanged: Boolean;
begin
  if Dictionary <> nil then
    Dictionary.LoadValue(Self);

  if FAllowExpressions then
  begin
    s := FMemo.Text;
    bChanged := False;

    i := Pos('[TOTALPAGES#]', UpperCase(s));
    //if i <> 0 then
    while (i > 0) do
    begin
      Delete(s, i, 13);
      Insert(IntToStr(FTotalPages), s, i);
{$IFNDEF DELPHI12}
      i := PosExW('[TOTALPAGES#]', UpperCase(s), i);
{$ELSE}
      i := PosEx('[TOTALPAGES#]', UpperCase(s), i);
{$ENDIF}
     bChanged := True;
    end;

    i := Pos('[COPYNAME#]', UpperCase(s));
    //if i <> 0 then
    while (i > 0) do
    begin
      j := frxGlobalVariables.IndexOf('CopyName' + IntToStr(FCopyNo));
      if j <> -1 then
        s1 := VarToStr(frxGlobalVariables.Items[j].Value)
      else
        s1 := '';
      Delete(s, i, 11);
      Insert(s1, s, i);
      slen := length(s1);
{$IFNDEF DELPHI12}
      i := PosExW('[COPYNAME#]', UpperCase(s), i + slen);
{$ELSE}
      i := PosEx('[COPYNAME#]', UpperCase(s), i + slen);
{$ENDIF}
      bChanged := True;
    end;

    if bChanged then FMemo.Text := s;
  end;
end;

procedure TfrxCustomMemoView.WriteNestedProperties(Item: TfrxXmlItem; aAcenstor: TPersistent = nil);
begin
  if Formats.Count > 1 then
    frxWriteCollection(FFormats, 'Formats', Item, Self, nil);
  if Assigned(aAcenstor) then
    aAcenstor := TfrxCustomMemoView(aAcenstor).FHighlights;
  if Highlights.Count > 1 then
    frxWriteCollection(FHighlights, 'Highlights', Item, Self, TfrxCollection(aAcenstor));
end;

function TfrxCustomMemoView.ReadNestedProperty(Item: TfrxXmlItem): Boolean;
begin
  Result := True;
  if CompareText(Item.Name, 'Formats') = 0 then
    frxReadCollection(FFormats, Item, Self, nil)
  else if CompareText(Item.Name, 'Highlights') = 0 then
    frxReadCollection(FHighlights, Item, Self, nil)
  else
    Result := False;
end;


function TfrxCustomMemoView.ReducedAngle: Integer;
begin
  Result := Rotation mod 360;
  if Result < 0 then
    Result := Result + 360;
end;

{ TfrxSysMemoView }

class function TfrxSysMemoView.GetDescription: String;
begin
  Result := frxResources.Get('obSysText');
end;


{ TfrxCustomLineView }

constructor TfrxCustomLineView.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csDefaultDiff];
  FArrowWidth := 5;
  FArrowLength := 20;
end;

constructor TfrxCustomLineView.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  inherited;
  FDiagonal := Flags <> 0;
  FArrowEnd := Flags in [2, 4];
  FArrowStart := Flags in [3, 4];
end;

procedure TfrxCustomLineView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  if not FDiagonal then
  begin
    if Width > Height then
    begin
      Height := 0;
      Frame.Typ := [ftTop];
    end
    else
    begin
      Width := 0;
      Frame.Typ := [ftLeft];
    end;
  end;

  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  if not FDiagonal then
  begin
    DrawFrame;
    if FArrowStart then
      DrawArrow(FX1, FY1, FX, FY);
    if FArrowEnd then
      DrawArrow(FX, FY, FX1, FY1);
  end
  else
    DrawDiagonalLine;
end;

procedure TfrxCustomLineView.DrawArrow(x1, y1, x2, y2: Extended);
var
  k1, a, b, c, D: Double;
  xp, yp, x3, y3, x4, y4, wd, ld: Extended;
begin
  wd := FArrowWidth * FScaleX;
  ld := FArrowLength * FScaleX;
  if abs(x2 - x1) > 8 then
  begin
    k1 := (y2 - y1) / (x2 - x1);
    a := Sqr(k1) + 1;
    b := 2 * (k1 * ((x2 * y1 - x1 * y2) / (x2 - x1) - y2) - x2);
    c := Sqr(x2) + Sqr(y2) - Sqr(ld) + Sqr((x2 * y1 - x1 * y2) / (x2 - x1)) -
      2 * y2 * (x2 * y1 - x1 * y2) / (x2 - x1);
    D := Sqr(b) - 4 * a * c;
    xp := (-b + Sqrt(D)) / (2 * a);
    if (xp > x1) and (xp > x2) or (xp < x1) and (xp < x2) then
      xp := (-b - Sqrt(D)) / (2 * a);
    yp := xp * k1 + (x2 * y1 - x1 * y2) / (x2 - x1);
    if y2 <> y1 then
    begin
      x3 := xp + wd * sin(ArcTan(k1));
      y3 := yp - wd * cos(ArcTan(k1));
      x4 := xp - wd * sin(ArcTan(k1));
      y4 := yp + wd * cos(ArcTan(k1));
    end
    else
    begin
      x3 := xp;
      y3 := yp - wd;
      x4 := xp;
      y4 := yp + wd;
    end;
  end
  else
  begin
    xp := x2;
    yp := y2 - ld;
    if (yp > y1) and (yp > y2) or (yp < y1) and (yp < y2) then
      yp := y2 + ld;
    x3 := xp - wd;
    y3 := yp;
    x4 := xp + wd;
    y4 := yp;
  end;

  if FArrowSolid then
  begin
    FCanvas.Brush.Color := Frame.Color;
    FCanvas.Polygon([Point(Round(x2), Round(y2)),
      Point(Round(x3), Round(y3)), Point(Round(x4), Round(y4)),
      Point(Round(x2), Round(y2))])
  end
  else
  begin
    FCanvas.Pen.Width := Round(FFrame.Width * FScaleX);
    FCanvas.Polyline([Point(Round(x3), Round(y3)),
      Point(Round(x2), Round(y2)), Point(Round(x4), Round(y4))]);
  end;
end;

procedure TfrxCustomLineView.DrawDiagonalLine;
begin
  if (Frame.Color = clNone) or (Frame.Width = 0) then exit;
  with FCanvas do
  begin
    Brush.Style := bsSolid;
    if Color = clNone then
      Brush.Style := bsClear else
      Brush.Color := Color;
    Pen.Color := Self.Frame.Color;
    Pen.Width := 1;
    if Self.Frame.Style <> fsDouble then
      Pen.Style := TPenStyle(Self.Frame.Style) else
      Pen.Style := psSolid;

    DrawLine(FX, FY, FX1, FY1, FFrameWidth);

    if FArrowStart then
      DrawArrow(FX1, FY1, FX, FY);
    if FArrowEnd then
      DrawArrow(FX, FY, FX1, FY1);
  end;
end;

function TfrxCustomLineView.GetVectorGraphic(DrawFill: Boolean): TGraphic;
var
  OldLeft, OldTop, OldWidth, OldHeight: Extended;
begin
  OldLeft := Left; OldTop := Top; OldWidth := Width; OldHeight := Height;
  if Width < 0 then
  begin
    FLeft := Left + Width;
    FWidth := -Width;
  end;
  if Height < 0 then
  begin
    FTop := Top + Height;
    FHeight := -Height;
  end;

  Result := inherited GetVectorGraphic(DrawFill);

  FLeft := OldLeft; FTop := OldTop; FWidth := OldWidth; FHeight := OldHeight;
end;

function TfrxCustomLineView.IsContain(X, Y: Extended): Boolean;
var
  w0, w1, w2, w3: Extended;
  r: TfrxRect;
  e, k: Extended;
begin
  w0 := 0;
  w1 := 0;
  w2 := 0;
  if Width = 0 then
  begin
    w0 := 4;
    w1 := 4
  end
  else if Height = 0 then
    w2 := 4;
  w3 := w2;

  r.Left := AbsLeft;
  r.Right := AbsLeft + Width;
  r.Top := AbsTop;
  r.Bottom := AbsTop + Height;

  if r.Right < r.Left then
  begin
    e := r.Right;
    r.Right := r.Left;
    r.Left := e;
  end;
  if r.Bottom < r.Top then
  begin
    e := r.Bottom;
    r.Bottom := r.Top;
    r.Top := e;
  end;

  Result := (X >= r.Left - w0) and
    (X <= r.Right + w1) and
    (Y >= r.Top - w2) and
    (Y <= r.Bottom + w3);

  if Diagonal and (Width <> 0) and (Height <> 0) then
  begin
    k := Height / Width;
    if Abs((k * (X - AbsLeft) - (Y - AbsTop)) * cos(ArcTan(k))) < 5 then
      Result := True;
    if (X < r.Left - 5) or (X > r.Right + 5)
      or (Y < r.Top - 5) or
      (Y > r.Bottom + 5) then
      Result := False;
  end;
end;

function TfrxCustomLineView.IsInRect(const aRect: TfrxRect): Boolean;
var
  Sign: Boolean;

  function Dist(X, Y: Extended): Boolean;
  var
    k: Extended;
  begin
    k := Height / Width;
    k := (k * (X - AbsLeft) - (Y - AbsTop)) *
      cos(ArcTan(k));
    Result := k >= 0;
  end;

begin
  Result := False;
  if Diagonal and (Width <> 0) and (Height <> 0) then
    with aRect do
    begin
      Sign := Dist(Left, Top);
      if Dist(Right, Top) <> Sign then
        Result := True;
      if Dist(Left, Bottom) <> Sign then
        Result := True;
      if Dist(Right, Bottom) <> Sign then
        Result := True;

      if Result then
        Result := Inherited IsInRect(aRect);
    end
  else
    Result := Inherited IsInRect(aRect);
end;

{ TfrxLineView }

class function TfrxLineView.GetDescription: String;
begin
  Result := frxResources.Get('obLine');
end;

{ TfrxPictureView }

constructor TfrxPictureView.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csDefaultDiff];
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FKeepAspectRatio := True;
  FStretched := True;
  FTransparentColor := clWhite;
  FIsPictureStored := True;
end;

destructor TfrxPictureView.Destroy;
begin
  FPicture.Free;
  inherited;
end;

class function TfrxPictureView.GetDescription: String;
begin
  Result := frxResources.Get('obPicture');
end;

procedure TfrxPictureView.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TfrxPictureView.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
end;

procedure TfrxPictureView.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize and not (FPicture.Graphic = nil) then
  begin
    FWidth := FPicture.Width;
    FHeight := FPicture.Height;
  end;
end;

procedure TfrxPictureView.PictureChanged(Sender: TObject);
begin
  AutoSize := FAutoSize;
  FPictureChanged := True;
end;

procedure TfrxPictureView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
var
  r: TRect;
  kx, ky: Extended;
  rgn: HRGN;

  procedure PrintGraphic(Canvas: TCanvas; DestRect: TRect; aGraph: TGraphic);
  begin
    frxDrawGraphic(Canvas, DestRect, aGraph, IsPrinting, HightQuality, FTransparent and (FTransparentColor <> clNone), FTransparentColor);
  end;

begin
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);

  with Canvas do
  begin
    if not DrawAsMask then
      DrawBackground;

    r := Rect(FX, FY, FX1, FY1);

    if (FPicture.Graphic = nil) or FPicture.Graphic.Empty then
    begin
      if IsDesigning then
        frxResources.ObjectImages.Draw(Canvas, FX + 1, FY + 2, 3);
    end
    else
    begin
      if FStretched then
      begin
        if FKeepAspectRatio then
        begin
          if FPicture.Width <> 0 then
            kx := FDX / FPicture.Width
          else kx := 0;
          if FPicture.Height <> 0 then
            ky := FDY / FPicture.Height
          else
            ky := 0;
          if kx < ky then
            r.Bottom := r.Top + Round(FPicture.Height * kx) else
            r.Right := r.Left + Round(FPicture.Width * ky);

          if FCenter then
            OffsetRect(r, (FDX - (r.Right - r.Left)) div 2,
                          (FDY - (r.Bottom - r.Top)) div 2);
        end;

        PrintGraphic(Canvas, r, FPicture.Graphic);
      end
      else
      begin
        rgn := CreateRectRgn(0, 0, MaxInt, MaxInt);
        GetClipRgn(Canvas.Handle, rgn);
        IntersectClipRect(Canvas.Handle,
          Round(FX),
          Round(FY),
          Round(FX1),
          Round(FY1));

        if FCenter then
          OffsetRect(r, (FDX - Round(ScaleX * FPicture.Width)) div 2,
                        (FDY - Round(ScaleY * FPicture.Height)) div 2);
        r.Right := r.Left + Round(FPicture.Width * ScaleX);
        r.Bottom := r.Top + Round(FPicture.Height * ScaleY);
        PrintGraphic(Canvas, r, Picture.Graphic);

        SelectClipRgn(Canvas.Handle, rgn);
        DeleteObject(rgn);
      end;
    end;

    DrawFrame;
    DrawFrameEdges;
//    if IsDesigning and FDrawDragDrop then
//      DrawHighlight(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  end;
end;

function TfrxPictureView.Diff(AComponent: TfrxComponent): String;
begin
  if FPictureChanged then
  begin
    Report.PreviewPages.AddPicture(Self);
    FPictureChanged := False;
  end;

  Result := ' ' + inherited Diff(AComponent) + ' ImageIndex="' +
    IntToStr(FImageIndex) + '"';
  if Transparent then
    Result := Result + ' Transparent="' + frxValueToXML(FTransparent) + '"';
  if TransparentColor <> clWhite then
    Result := Result + ' TransparentColor="' + intToStr(FTransparentColor) + '"';
end;

const
  WMFKey = Integer($9AC6CDD7);
  WMFWord = $CDD7;
  rc3_StockIcon = 0;
  rc3_Icon = 1;
  rc3_Cursor = 2;

type
  TGraphicHeader = record
    Count: Word;
    HType: Word;
    Size: Longint;
  end;

  TMetafileHeader = packed record
    Key: Longint;
    Handle: SmallInt;
    Box: TSmallRect;
    Inch: Word;
    Reserved: Longint;
    CheckSum: Word;
  end;

  TCursorOrIcon = packed record
    Reserved: Word;
    wType: Word;
    Count: Word;
  end;

const
  OriginalPngHeader: array[0..7] of AnsiChar = (#137, #80, #78, #71, #13, #10, #26, #10);

function TfrxPictureView.LoadPictureFromStream(s: TStream; ResetStreamPos: Boolean): Hresult;
var
  pos: Integer;
  Header: TGraphicHeader;
  BMPHeader: TBitmapFileHeader;
{$IFDEF JPEG}
  JPEGHeader: array[0..1] of Byte;
{$ENDIF}
{$IFDEF PNG}
  PNGHeader: array[0..7] of AnsiChar;
{$ENDIF}
  {$IFNDEF FPC}
  EMFHeader: TEnhMetaHeader;
  {$ENDIF}
  WMFHeader: TMetafileHeader;
  ICOHeader: TCursorOrIcon;
  NewGraphic: TGraphic;
  bOK : Boolean;
begin
{$IFDEF FPC}
  Result := E_INVALIDARG;
  if ResetStreamPos then
    pos := 0
  else
    pos := s.Position;
  s.Position := pos;
  try
    FPicture.LoadFromStream(S);
  except
    on E:Exception do
    begin
      FPicture.Assign(nil);
      {$IFDEF DEBUGFR4}
      DebugLn('Error in TfrxPictureView.LoadPictureFromStream: '+E.Message);
      {$ENDIF}
    end;
  end;

  if FPicture.Graphic = nil then
    Result := E_INVALIDARG
  else
    Result := S_OK;
{$ELSE}

  NewGraphic := nil;
  if ResetStreamPos then
    pos := 0
  else
    pos := s.Position;

  s.Position := pos;

  if s.Size > 0 then
  begin
    // skip Delphi blob-image header
    if s.Size >= SizeOf(TGraphicHeader) then
    begin
      s.Read(Header, SizeOf(Header));
      if (Header.Count <> 1) or (Header.HType <> $0100) or
        (Header.Size <> s.Size - SizeOf(Header)) then
          s.Position := pos;
    end;
    pos := s.Position;

    bOK := False;

    if (s.Size-pos) >= SizeOf(BMPHeader) then
    begin
      // try bmp header
      s.ReadBuffer(BMPHeader, SizeOf(BMPHeader));
      s.Position := pos;
      if BMPHeader.bfType = $4D42 then
      begin
        NewGraphic := TBitmap.Create;
        bOK := True;
      end;
    end;

    {$IFDEF JPEG}
    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(JPEGHeader) then
      begin
        // try jpeg header
        s.ReadBuffer(JPEGHeader, SizeOf(JPEGHeader));
        s.Position := pos;
        if (JPEGHeader[0] = $FF) and (JPEGHeader[1] = $D8) then
        begin
          NewGraphic := TJPEGImage.Create;
          bOK := True;
        end;
      end;
    end;
    {$ENDIF}

    {$IFDEF PNG}
    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(PNGHeader) then
      begin
        // try png header
        s.ReadBuffer(PNGHeader, SizeOf(PNGHeader));
        s.Position := pos;
        if PNGHeader = OriginalPngHeader then
        begin
          NewGraphic := TPngObject.Create;
          bOK := True;
        end;
      end;
    end;
    {$ENDIF}

    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(WMFHeader) then
      begin
        // try wmf header
        s.ReadBuffer(WMFHeader, SizeOf(WMFHeader));
        s.Position := pos;
        if WMFHeader.Key = WMFKEY then
        begin
          NewGraphic := TMetafile.Create;
          bOK := True;
        end;
      end;
    end;

    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(EMFHeader) then
      begin
        // try emf header
        s.ReadBuffer(EMFHeader, SizeOf(EMFHeader));
        s.Position := pos;
        if EMFHeader.dSignature = ENHMETA_SIGNATURE then
        begin
          NewGraphic := TMetafile.Create;
          bOK := True;
        end;
      end;
    end;

    if not bOK then
    begin
      if (s.Size-pos) >= SizeOf(ICOHeader) then
      begin
        // try icon header
        s.ReadBuffer(ICOHeader, SizeOf(ICOHeader));
        s.Position := pos;
        if ICOHeader.wType in [RC3_STOCKICON, RC3_ICON] then
          NewGraphic := TIcon.Create;
      end;
    end;
  end;

  if NewGraphic <> nil then
  begin
    FPicture.Graphic := NewGraphic;
    NewGraphic.Free;
    FPicture.Graphic.LoadFromStream(s);
    Result := S_OK;
  end
  else
  begin
    FPicture.Assign(nil);
    Result := E_INVALIDARG;
  end;
// workaround pngimage bug
{$IFDEF PNG}
  if FPicture.Graphic is TPngObject then
    PictureChanged(nil);
{$ENDIF}
{$ENDIF} // fpc
end;

function TfrxPictureView.IsEMFExportable: Boolean;
begin
  Result := inherited IsEMFExportable and (Picture.Graphic is TMetafile);
end;

procedure TfrxPictureView.GetData;
var
  m: TMemoryStream;
  s: String;
begin
  inherited;
  if FFileLink <> '' then
  begin
    s := FFileLink;
    if Pos('[', s) <> 0 then
      ExpandVariables(s);
    if FileExists(s) then
      FPicture.LoadFromFile(s)
    else
      FPicture.Assign(nil);
  end
  else if IsDataField and DataSet.IsBlobField(DataField) then
  begin
    m := TMemoryStream.Create;
    try
      DataSet.AssignBlobTo(DataField, m);
      LoadPictureFromStream(m);
    finally
      m.Free;
    end;
  end;
end;


{ TfrxBand }

constructor TfrxBand.Create(AOwner: TComponent);
begin
  inherited;
  FSubBands := TList.Create;
  FFill := TfrxBrushFill.Create;
  FFillMemo := nil;
  FFillGap := TfrxFillGaps.Create;
  FBandDesignHeader := 0;
  frComponentStyle := frComponentStyle + [csAcceptsFrxComponents];
  FFrame := TfrxFrame.Create;
  FShiftEngine := seTree;
end;

procedure TfrxBand.CreateFillMemo;
begin
  if ((Self is TfrxNullBand) or
    ((FFillType = ftBrush) and
     (TfrxBrushFill(FFill).BackColor = clNone) and
     (TfrxBrushFill(FFill).ForeColor = clBlack) and
     (TfrxBrushFill(FFill).Style = bsSolid) and
     (FFrame.Typ = []))) then Exit;
  if FFillMemo = nil then
    FFillMemo := TfrxMemoView.Create(Self);
  FFillMemo.Align := baHidden;
  FFillMemo.Parent := Self;
  FFillMemo.FillType := FFillType;
  FFillMemo.Fill.Assign(FFill);
  FFillMemo.Frame.Assign(FFrame);
  FFillMemo.Height := Height - FFillgap.FRight;
  FFillMemo.Width := Width - FFillgap.FBottom;
  FFillMemo.Top := FFillgap.FTop;
  FFillMemo.Left := FFillgap.FLeft;
  Objects.Remove(FFillMemo);
  Objects.Insert(0, FFillMemo);
end;

destructor TfrxBand.Destroy;
begin
  FSubBands.Free;
  FFill.Free;
  FFillGap.Free;
  FFrame.Free;
  inherited;
end;

procedure TfrxBand.DisposeFillMemo;
begin
  if Assigned(FFillMemo) then
    FreeAndNil(FFillMemo);
end;

function TfrxBand.IsContain(X, Y: Extended): Boolean;
var
  w0, w1, w2, w3: Extended;
begin
  w0 := 0;
  w1 := 2;
  w2 := 0;
  if Width = 0 then
  begin
    w0 := 4;
    w1 := 4
  end
  else if Height = 0 then
    w2 := 4;
  w3 := w2;

  if Vertical then
    w0 := BandDesignHeader
  else
    w2 := BandDesignHeader;

  Result := (X >= AbsLeft - w0) and
    (X <= AbsLeft + Width + w1) and
    (Y >= AbsTop - w2) and
    (Y <= AbsTop + Height + w3 + 1);
end;

procedure TfrxBand.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FChild) then
    FChild := nil;
end;

procedure TfrxBand.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
var
  dX, dY, dX1, dY1: Integer;
  x, y: Integer;
  fh, oldfh: HFont;
  bName: String;
begin
  if IsDesigning then
  begin
    dx := Round(AbsLeft * ScaleX + OffsetX);
    dy := Round(AbsTop * ScaleY + OffsetY);
    dX1 := Round((AbsLeft + Width) * ScaleX + OffsetX);
    dY1 := Round((AbsTop + Height) * ScaleY + OffsetY);
    FFill.Draw(Canvas, dx, dy, dX1, dY1, ScaleX, ScaleY);

    with Canvas do
    begin
      if Vertical then
      begin
        Top := 0;
        Pen.Style := psSolid;
        Pen.Color := clGray;
        Pen.Width := 1;
        Brush.Style := bsClear;
        X := Round((Left - BandDesignHeader) * ScaleX);
        Rectangle(X, 0, Round((Left + Self.Width) * ScaleX) + 1,
          Round(Self.Height * ScaleY));

        if BandDesignHeader <> 0 then
        begin
          Brush.Style := bsSolid;
          Brush.Color := GetBandTitleColor;
          FillRect(Rect(X + 1, 1, Round(Left * ScaleX),
            Round(Self.Height * ScaleY)));
        end;

        Font.Name := DefFontNameBand;
        Font.Size := Round(8 * ScaleY);
        Font.Color := clBlack;
        Font.Style := [];
        fh := frxCreateRotatedFont(Font, 90);
        oldfh := SelectObject(Handle, fh);
        Y := TextWidth(Name) + 4;
        TextOut(X + 2, Y, Name);
        SelectObject(Handle, oldfh);
        DeleteObject(fh);
        Font.Style := [fsBold];
        fh := frxCreateRotatedFont(Font, 90);
        oldfh := SelectObject(Handle, fh);
        bName := frxResources.Get(BandName);
        TextOut(X + 2, Y + TextWidth(bName + ': ') + 2, bName + ': ');
        SelectObject(Handle, oldfh);
        DeleteObject(fh);
      end
      else
      begin
        Left := 0;
        if (Page is TfrxReportPage) and (TfrxReportPage(Page).Columns > 1) then
          if BandNumber in [4 .. 16] then
            Self.Width := TfrxReportPage(Page).ColumnWidth * fr01cm;
        Pen.Style := psSolid;
        Pen.Color := clGray;
        Pen.Width := 1;
        Brush.Style := bsClear;
        Y := Round((Top - BandDesignHeader) * ScaleY);
        Rectangle(0, Y, Round(Self.Width * ScaleX) + 1,
          Round((Top + Self.Height) * ScaleY) + 1);

        if BandDesignHeader <> 0 then
        begin
          Brush.Style := bsSolid;
          Brush.Color := GetBandTitleColor;
          FillRect(Rect(1, Y + 1, Round(Self.Width * ScaleX), Round(Top * ScaleY)));
        end;

        Font.Name := DefFontNameBand;
        Font.Size := Round(8 * ScaleY);
        Font.Color := clBlack;
        Font.Style := [fsBold];
        bName := frxResources.Get(BandName);
        TextOut(6, Y + 2, bName);
        Font.Style := [];
        TextOut(PenPos.X, Y + 2, ': ' + Name);
      end
    end;
    if Assigned(FComponentEditors) then
      FComponentEditors.DrawCustomEditor(Canvas, Rect(dx, dy, dx1, dy1));
  end;
end;

function TfrxBand.GetBandName: String;
begin
  Result := ClassName;
  Delete(Result, Pos('Tfrx', Result), 4);
  Delete(Result, Pos('Band', Result), 4);
end;

function TfrxBand.GetBandTitleColor: TColor;
begin
  Result := clBtnFace;
end;

function TfrxBand.GetContainedComponent(X, Y: Extended;
  IsCanContain: TfrxComponent): TfrxComponent;
var
  SaveLeft: Extended;
begin
  Result := nil;
  { emulate vertical band behaviour in the report designer }
  if FVertical and Assigned(Parent) and IsContain(X, Y) then
  begin
    if IsCanContain = Self then
     Exit;
    SaveLeft := Left;
    { dirty hack, hide band for IsContain }
    Left := -10000;
    try
      Result := Parent.GetContainedComponent(X, Y, IsCanContain);
    finally
      Left := SaveLeft;
    end;
    if ((Result is TfrxPage) or (Result is TfrxBand)) and (IsCanContain = nil) then
      Result := Self;
  end
  else
    Result := inherited GetContainedComponent(X, Y, IsCanContain);
  { #509861 compatibility with old behaviour }
  { it should be fixed on Engine level       }
  if (Result = Self) and not IsDesigning then
    Result := nil;
end;

function TfrxBand.BandNumber: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to BND_COUNT - 1 do
    if Self is frxBands[i] then
      Result := i;
end;

class function TfrxBand.GetDescription: String;
begin
  Result := frxResources.Get('obBand');
end;

procedure TfrxBand.SetLeft(Value: Extended);
begin
  if Parent is TfrxDMPPage then
    Value := Round(Value / fr1CharX) * fr1CharX;
  inherited;
end;

procedure TfrxBand.SetTop(Value: Extended);
begin
  if Parent is TfrxDMPPage then
    Value := Round(Value / fr1CharY) * fr1CharY;
  inherited;
end;

procedure TfrxBand.SetVertical(const Value: Boolean);
begin
{$IFDEF RAD_ED}
  FVertical := False;
{$ELSE}
  FVertical := Value;
{$ENDIF}
end;

procedure TfrxBand.SetHeight(Value: Extended);
begin
  if Parent is TfrxDMPPage then
    Value := Round(Value / fr1CharY) * fr1CharY;
  inherited;
end;

procedure TfrxBand.SetChild(Value: TfrxChild);
var
  b: TfrxBand;
begin
  b := Value;
  while b <> nil do
  begin
    b := b.Child;
    if b = Self then
      raise Exception.Create(frxResources.Get('clCirRefNotAllow'));
  end;
  FChild := Value;
end;

procedure TfrxBand.SetFill(const Value: TfrxCustomFill);
begin
  FillType := frxGetFillType(Value);
  FFill.Assign(Value);
end;

procedure TfrxBand.SetFillType(const Value: TfrxFillType);
begin
  if FFillType = Value then Exit;
  FFill.Free;
  if Value = ftBrush then
    FFill := TfrxBrushFill.Create
  else if Value = ftGradient then
    FFill := TfrxGradientFill.Create
  else if Value = ftGlass then
    FFill := TfrxGlassFill.Create;
  FFillType := Value;
  if (Report <> nil) and (Report.Designer <> nil) then
    TfrxCustomDesigner(Report.Designer).UpdateInspector;
end;

procedure TfrxBand.SetFrame(const Value: TfrxFrame);
begin
  FFrame.Assign(Value);
end;

{ TfrxDataBand }

constructor TfrxDataBand.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF FPC}
  FDataSet := nil;
  FDataSetName := '';
{$ENDIF}
  FVirtualDataSet := TfrxUserDataSet.Create(nil);
  FVirtualDataSet.RangeEnd := reCount;
end;

destructor TfrxDataBand.Destroy;
begin
  FVirtualDataSet.Free;
  inherited;
end;

procedure TfrxDataBand.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  s: String;
  i, w, y: Integer;
begin
  inherited;
  if not Vertical then
    with Canvas do
    begin
      Font.Name := DefFontNameBand;
      Font.Size := Round(8 * ScaleY);
      Font.Color := clBlack;
      Font.Style := [];
      y := Round((Top - BandDesignHeader) * ScaleY);
      if FBandDesignHeader <> 0 then
      begin
        if (DataSet <> nil) and (Report <> nil) then
          s := Report.GetAlias(DataSet)
        else if RowCount <> 0 then
          s := IntToStr(RowCount)
        else
          s := '';
        w := TextWidth(s);
        if ScaleX > 0.7 then
          frxResources.MainButtonImages.Draw(Canvas,
            Round(Self.Width * ScaleX - w - 24), Round(Y + 2 * ScaleY), 53);
        if s <> '' then
          TextOut(Round(Self.Width * ScaleX - w - 3), Y + 3, s);
      end;
      if Columns > 1 then
      begin
        Pen.Style := psDot;
        Pen.Color := clBlack;
        Brush.Style := bsClear;
        for i := 1 to Columns do
          Rectangle(Round((i - 1) * (ColumnWidth + ColumnGap) * ScaleX),
            Round(Top * ScaleY),
            Round(((i - 1) * (ColumnWidth + ColumnGap) + ColumnWidth) * ScaleX),
            Round((Top + Self.Height) * ScaleY));
      end;
    end;
end;

class function TfrxDataBand.GetDescription: String;
begin
  Result := frxResources.Get('obDataBand');
end;

procedure TfrxDataBand.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

procedure TfrxDataBand.SetCurColumn(Value: Integer);
begin
  if Value > FColumns then
    Value := 1;
  FCurColumn := Value;
  if FCurColumn = 1 then
    FMaxY := 0;
  FLeft := (FCurColumn - 1) * (FColumnWidth + FColumnGap);
end;

procedure TfrxDataBand.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxDataBand.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := FindDataSet(FDataSet, FDataSetName);
end;

function TfrxDataBand.GetBandTitleColor: TColor;
begin
  Result := $30A7E0;
  if Vertical then
    Result := $EEBB00;
end;

function TfrxDataBand.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

procedure TfrxDataBand.SetRowCount(const Value: Integer);
begin
  FRowCount := Value;
  FVirtualDataSet.RangeEndCount := Value;
end;

{ TfrxPageHeader }

constructor TfrxPageHeader.Create(AOwner: TComponent);
begin
  inherited;
  FPrintOnFirstPage := True;
end;


{ TfrxPageFooter }

constructor TfrxPageFooter.Create(AOwner: TComponent);
begin
  inherited;
  FPrintOnFirstPage := True;
  FPrintOnLastPage := True;
end;


{ TfrxGroupHeader }

function TfrxGroupHeader.Diff(AComponent: TfrxComponent): String;
begin
  Result := inherited Diff(AComponent);
 if FDrillDown then
  Result := Result + ' DrillName="' + FDrillName + '"';
end;


procedure TfrxGroupHeader.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);

begin
  inherited;
  Canvas.Font.Name := DefFontNameBand;
  Canvas.Font.Size := Round(8 * ScaleY);
  Canvas.Font.Color := clBlack;
  Canvas.Font.Style := [];
  if Condition <> '' then
    if FBandDesignHeader <> 0 then
      Canvas.TextOut(Round(Width * ScaleX - Canvas.TextWidth(Condition) - 3), Round((Top - BandDesignHeader) * ScaleY) + 3, Condition);
end;

{ TfrxSubreport }

constructor TfrxSubreport.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle - [csPreviewVisible];
  FFrame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
  FFont.Name := 'Tahoma';
  FFont.Size := 8;
  Color := clSilver;
end;

destructor TfrxSubreport.Destroy;
begin
  if FPage <> nil then
    FPage.FSubReport := nil;
  inherited;
end;

procedure TfrxSubreport.SetPage(const Value: TfrxReportPage);
begin
  FPage := Value;
  if FPage <> nil then
    FPage.FSubReport := Self;
end;

procedure TfrxSubreport.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  inherited;

  with Canvas do
  begin
    Font.Assign(FFont);
    TextOut(FX + 2, FY + 2, Name);
  end;
end;

class function TfrxSubreport.GetDescription: String;
begin
  Result := frxResources.Get('obSubRep');
end;

{ TfrxDialogPage }

constructor TfrxDialogPage.Create(AOwner: TComponent);
var
  FSaveTag: Integer;
begin
  inherited;
  FSaveTag := Tag;
  if (Report <> nil) and Report.EngineOptions.EnableThreadSafe then
    Tag := 318
  else
    Tag := 0;
  FForm := TfrxDialogForm.Create(Self);
  Tag := FSaveTag;
  FForm.KeyPreview := True;
  Font.Name := 'Tahoma';
  Font.Size := 8;
  BorderStyle := bsSizeable;
  Position := poScreenCenter;
  WindowState := wsNormal;
  Color := clBtnFace;
  FForm.ShowHint := True;
  FClientWidth := 0;
  FClientHeight := 0;
end;

destructor TfrxDialogPage.Destroy;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  frxCS.Enter;
{$ENDIF}
  try
    inherited;
    FForm.Free;
  finally
{$IFNDEF NO_CRITICAL_SECTION}
    frxCS.Leave;
{$ENDIF}
  end;
end;

class function TfrxDialogPage.GetDescription: String;
begin
  Result := frxResources.Get('obDlgPage');
end;

function TfrxDialogPage.GetDoubleBuffered: Boolean;
begin
  Result := FForm.DoubleBuffered;
end;

procedure TfrxDialogPage.SetLeft(Value: Extended);
begin
  inherited;
  FForm.Left := Round(Value);
end;

procedure TfrxDialogPage.SetTop(Value: Extended);
begin
  inherited;
  FForm.Top := Round(Value);
end;

procedure TfrxDialogPage.SetWidth(Value: Extended);
begin
  inherited;
  if IsLoading and (FClientWidth <> 0) then Exit;
  FForm.Width := Round(Value);
end;

procedure TfrxDialogPage.SetHeight(Value: Extended);
begin
  inherited;
  if IsLoading and (FClientHeight <> 0) then Exit;
  FForm.Height := Round(Value);
end;

procedure TfrxDialogPage.SetClientWidth(Value: Extended);
begin
  FForm.ClientWidth := Round(Value);
  FClientWidth := Value;
  inherited SetWidth(FForm.Width);
end;

procedure TfrxDialogPage.SetClientHeight(Value: Extended);
begin
  FForm.ClientHeight := Round(Value);
  FClientHeight := Value;
  inherited SetHeight(FForm.Height);
end;

procedure TfrxDialogPage.SetScaled(Value: Boolean);
begin
  FForm.Scaled := Value;
end;

function TfrxDialogPage.GetScaled: Boolean;
begin
  Result := FForm.Scaled;
end;

function TfrxDialogPage.GetClientWidth: Extended;
begin
  Result := FForm.ClientWidth;
end;

function TfrxDialogPage.GetClientHeight: Extended;
begin
  Result := FForm.ClientHeight;
end;

procedure TfrxDialogPage.SetBorderStyle(const Value: TFormBorderStyle);
begin
  FBorderStyle := Value;
end;

procedure TfrxDialogPage.SetCaption(const Value: String);
begin
  FCaption := Value;
  FForm.Caption := Value;
end;

procedure TfrxDialogPage.SetColor(const Value: TColor);
begin
  FColor := Value;
  FForm.Color := Value;
end;

procedure TfrxDialogPage.SetDoubleBuffered(const Value: Boolean);
begin
  FForm.DoubleBuffered := Value;
end;

function TfrxDialogPage.GetModalResult: TModalResult;
begin
  Result := FForm.ModalResult;
end;

procedure TfrxDialogPage.SetModalResult(const Value: TModalResult);
begin
  FForm.ModalResult := Value;
end;

procedure TfrxDialogPage.FontChanged(Sender: TObject);
begin
  inherited;
  FForm.Font := Font;
end;

procedure TfrxDialogPage.DoInitialize;
begin
  if FForm.Visible then
    FForm.Hide;
  FForm.Position := FPosition;
  FForm.WindowState := FWindowState;
  FForm.OnActivate := DoOnActivate;
  FForm.OnClick := DoOnClick;
  FForm.OnCloseQuery := DoOnCloseQuery;
  FForm.OnDeactivate := DoOnDeactivate;
  FForm.OnHide := DoOnHide;
  FForm.OnKeyDown := DoOnKeyDown;
  FForm.OnKeyPress := DoOnKeyPress;
  FForm.OnKeyUp := DoOnKeyUp;
  FForm.OnShow := DoOnShow;
  FForm.OnResize := DoOnResize;
  FForm.OnMouseMove := DoOnMouseMove;
end;

procedure TfrxDialogPage.Initialize;
begin

//  if (Report <> nil) and (Report.EngineOptions.ReportThread <> nil) then
//    THackThread(Report.EngineOptions.ReportThread).Synchronize(DoInitialize) else

    DoInitialize;
end;

function TfrxDialogPage.IsContain(X, Y: Extended): Boolean;
begin
  Result := inherited IsContain(X + AbsLeft, Y + AbsTop);
end;

function TfrxDialogPage.ShowModal: TModalResult;
begin
  Initialize;
  FForm.BorderStyle := FBorderStyle;
  FForm.FormStyle := fsNormal;
  try
    TfrxDialogForm(FForm).OnModify := DoModify;
    Result := FForm.ShowModal;
  finally
    FForm.FormStyle := fsStayOnTop;
  end;
end;

procedure TfrxDialogPage.DoModify(Sender: TObject);
begin
  FLeft := FForm.Left;
  FTop := FForm.Top;
  FWidth := FForm.Width;
  FHeight := FForm.Height;
end;

procedure TfrxDialogPage.DoOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (Report <> nil) then
  begin
    Report.SetProgressMessage('', True);
  end;
end;

procedure TfrxDialogPage.DoOnActivate(Sender: TObject);
var
  i: Integer;
begin
  DoModify(nil);
  if Report <> nil then
    Report.DoNotifyEvent(Sender, FOnActivate, True);
  for i := 0 to AllObjects.Count - 1 do
  begin
    if (TObject(AllObjects[i]) is TfrxDialogControl) and
    Assigned(TfrxDialogControl(AllObjects[i]).OnActivate) then
      TfrxDialogControl(AllObjects[i]).OnActivate(Self);
  end;
end;

procedure TfrxDialogPage.DoOnClick(Sender: TObject);
begin
  Report.DoNotifyEvent(Sender, FOnClick, True);
end;

procedure TfrxDialogPage.DoOnCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Sender), CanClose]);
  Report.DoParamEvent(FOnCloseQuery, v, True);
  CanClose := v[1];
end;

procedure TfrxDialogPage.DoOnDeactivate(Sender: TObject);
begin
  Report.DoNotifyEvent(Sender, FOnDeactivate, True);
end;

procedure TfrxDialogPage.DoOnHide(Sender: TObject);
begin
  Report.DoNotifyEvent(Sender, FOnHide, True);
end;

procedure TfrxDialogPage.DoOnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Sender), Key, ShiftToByte(Shift)]);
  if Report <> nil then
    Report.DoParamEvent(FOnKeyDown, v, True);
  Key := v[1];
end;

procedure TfrxDialogPage.DoOnKeyPress(Sender: TObject; var Key: Char);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Sender), Key]);
  if Report <> nil then
    Report.DoParamEvent(FOnKeyPress, v, True);
  if VarToStr(v[1]) <> '' then
    Key := VarToStr(v[1])[1]
  else
    Key := Chr(0);
end;

procedure TfrxDialogPage.DoOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  v: Variant;
begin
  v := VarArrayOf([frxInteger(Sender), Key, ShiftToByte(Shift)]);
  if Report <> nil then
    Report.DoParamEvent(FOnKeyUp, v, True);
  Key := v[1];
end;

procedure TfrxDialogPage.DoOnShow(Sender: TObject);
begin
  FForm.Perform(CM_FOCUSCHANGED, 0, frxInteger(FForm.ActiveControl));
  Report.DoNotifyEvent(Sender, FOnShow, True);
end;

procedure TfrxDialogPage.DoOnResize(Sender: TObject);
begin
  Report.DoNotifyEvent(Sender, FOnResize, True);
end;


{ TfrxReportPage }

constructor TfrxReportPage.Create(AOwner: TComponent);
begin
  inherited;
  FBackPicture := TfrxPictureView.Create(nil);
  FBackPicture.Color := clTransparent;
  FBackPicture.KeepAspectRatio := False;
  FColumnPositions := TStringList.Create;
  FOrientation := poPortrait;
  PaperSize := DMPAPER_A4;
  FBin := DMBIN_AUTO;
  FBinOtherPages := DMBIN_AUTO;
  FBaseName := 'Page';
  FSubBands := TList.Create;
  FVSubBands := TList.Create;
  FHGuides := TStringList.Create;
  FVGuides := TStringList.Create;
  FPrintIfEmpty := True;
  FTitleBeforeHeader := True;
  FBackPictureVisible := True;
  FBackPicturePrintable := True;
  FBackPictureStretched := True;
  FShowTitleOnPreviousPage := True;
  FMirrorMode := [];
  FPageCount := 1;
end;

constructor TfrxReportPage.CreateInPreview(AOwner: TComponent; AReport: TfrxReport);
begin
  Create(AOwner);
  FReport := AReport;
end;

destructor TfrxReportPage.Destroy;
begin
  FColumnPositions.Free;
  FBackPicture.Free;
  FSubBands.Free;
  FVSubBands.Free;
  FHGuides.Free;
  FVGuides.Free;
  if FSubReport <> nil then
    FSubReport.FPage := nil;
  inherited;
end;

class function TfrxReportPage.GetDescription: String;
begin
  Result := frxResources.Get('obRepPage');
end;

procedure TfrxReportPage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

procedure TfrxReportPage.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxReportPage.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := FindDataSet(FDataSet, FDataSetName);
end;

function TfrxReportPage.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

procedure TfrxReportPage.SetPaperHeight(const Value: Extended);
begin
  FPaperHeight := Round8(Value);
  FPaperSize := 256;
  UpdateDimensions;
end;

procedure TfrxReportPage.SetPaperWidth(const Value: Extended);
begin
  FPaperWidth := Round8(Value);
  FPaperSize := 256;
  UpdateDimensions;
end;

procedure TfrxReportPage.SetPaperSize(const Value: Integer);
var
  e: Extended;
begin
  FPaperSize := Value;
  if FPaperSize < DMPAPER_USER then
  begin
    if frxGetPaperDimensions(FPaperSize, FPaperWidth, FPaperHeight) then
      if FOrientation = poLandscape then
      begin
        e := FPaperWidth;
        FPaperWidth := FPaperHeight;
        FPaperHeight := e;
      end;
    UpdateDimensions;
  end;
end;

procedure TfrxReportPage.SetSizeAndDimensions(ASize: Integer; AWidth,
  AHeight: Extended);
begin
  FPaperSize := ASize;
  FPaperWidth := Round8(AWidth);
  FPaperHeight := Round8(AHeight);
  UpdateDimensions;
end;

procedure TfrxReportPage.SetColumns(const Value: Integer);
begin
  FColumns := Value;
  FColumnPositions.Clear;
  if FColumns <= 0 then exit;

  FColumnWidth := (FPaperWidth - FLeftMargin - FRightMargin) / FColumns;
  while FColumnPositions.Count < FColumns do
    FColumnPositions.Add(FloatToStr(FColumnPositions.Count * FColumnWidth));
end;

procedure TfrxReportPage.SetPageCount(const Value: Integer);
begin
  if Value > 0 then
    FPageCount := Value;
end;

procedure TfrxReportPage.SetOrientation(Value: TPrinterOrientation);
var
  e, m1, m2, m3, m4: Extended;
begin
  if FOrientation <> Value then
  begin
    e := FPaperWidth;
    FPaperWidth := FPaperHeight;
    FPaperHeight := e;

    m1 := FLeftMargin;
    m2 := FRightMargin;
    m3 := FTopMargin;
    m4 := FBottomMargin;

    if Value = poLandscape then
    begin
      FLeftMargin := m3;
      FRightMargin := m4;
      FTopMargin := m2;
      FBottomMargin := m1;
    end
    else
    begin
      FLeftMargin := m4;
      FRightMargin := m3;
      FTopMargin := m1;
      FBottomMargin := m2;
    end;
    UpdateDimensions;
  end;

  FOrientation := Value;
end;

procedure TfrxReportPage.UpdateDimensions;
begin
  Width := Round(FPaperWidth * fr01cm);
  Height := Round(FPaperHeight * fr01cm);
end;

procedure TfrxReportPage.ClearGuides;
begin
  FHGuides.Clear;
  FVGuides.Clear;
end;

procedure TfrxReportPage.SetHGuides(const Value: TStrings);
begin
  FHGuides.Assign(Value);
end;

procedure TfrxReportPage.SetVGuides(const Value: TStrings);
begin
  FVGuides.Assign(Value);
end;

function TfrxReportPage.FindBand(Band: TfrxBandClass): TfrxBand;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FObjects.Count - 1 do
    if TObject(FObjects[i]) is Band then
    begin
      Result := FObjects[i];
      break;
    end;
end;

function TfrxReportPage.IsSubReport: Boolean;
begin
  Result := SubReport <> nil;
end;

procedure TfrxReportPage.SetColumnPositions(const Value: TStrings);
begin
  FColumnPositions.Assign(Value);
end;

function TfrxReportPage.GetFrame: TfrxFrame;
begin
  Result := FBackPicture.Frame;
end;

procedure TfrxReportPage.SetFrame(const Value: TfrxFrame);
begin
  FBackPicture.Frame := Value;
end;

function TfrxReportPage.GetColor: TColor;
begin
  Result := FBackPicture.Color;
end;

procedure TfrxReportPage.SetColor(const Value: TColor);
begin
  FBackPicture.Color := Value;
end;

function TfrxReportPage.GetBackPicture: TPicture;
begin
  Result := FBackPicture.Picture;
end;

procedure TfrxReportPage.SetBackPicture(const Value: TPicture);
begin
  FBackPicture.Picture := Value;
end;

procedure TfrxReportPage.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  Inherited;
  if FBackPictureStretched then
    begin
      FBackPicture.Width := (FPaperWidth - FLeftMargin - FRightMargin) * fr01cm;
      FBackPicture.Height := (FPaperHeight - FTopMargin - FBottomMargin) * fr01cm;
    end
  else
    begin
      FBackPicture.Width := FBackPicture.Picture.Width;
      FBackPicture.Height := FBackPicture.Picture.Height;
    end;
  if FBackPictureVisible and (not IsPrinting or FBackPicturePrintable) then
    FBackPicture.Draw(Canvas, ScaleX, ScaleY,
      OffsetX + FLeftMargin * fr01cm * ScaleX,
      OffsetY + FTopMargin * fr01cm * ScaleY);
end;

procedure TfrxReportPage.SetDefaults;
begin
  FLeftMargin := 10;
  FRightMargin := 10;
  FTopMargin := 10;
  FBottomMargin := 10;
  FPaperSize := frxPrinters.Printer.DefPaper;
  FPaperWidth := frxPrinters.Printer.DefPaperWidth;
  FPaperHeight := frxPrinters.Printer.DefPaperHeight;
  FOrientation := frxPrinters.Printer.DefOrientation;
  UpdateDimensions;
end;

procedure TfrxReportPage.AlignChildren(IgnoreInvisible: Boolean; MirrorModes: TfrxMirrorControlModes);
var
  i: Integer;
  c: TfrxComponent;
begin
  Width := (FPaperWidth - FLeftMargin - FRightMargin) * fr01cm;
  Height := (FPaperHeight - FTopMargin - FBottomMargin) * fr01cm;
  inherited AlignChildren(IgnoreInvisible, MirrorModes);
  for i := 0 to Objects.Count - 1 do
  begin
    c := Objects[i];
    if c is TfrxBand then
    begin
      if TfrxBand(c).Vertical then
        c.Height := (FPaperHeight - FTopMargin - FBottomMargin) * fr01cm - c.Top
      else
        if (Columns > 1) and not((c is TfrxNullBand) or (c is TfrxReportSummary) or
          (c is TfrxPageHeader) or (c is TfrxPageFooter) or
          (c is TfrxReportTitle) or (c is TfrxOverlay)) then
          c.Width := ColumnWidth * fr01cm
        else
          c.Width := Width - c.Left;

      c.DoMirror(MirrorModes);
      c.AlignChildren(IgnoreInvisible, MirrorModes);
    end;
  end;
  UpdateDimensions;
end;

{ TfrxDataPage }

constructor TfrxDataPage.Create(AOwner: TComponent);
begin
  inherited;
  Width := 1000;
  Height := 1000;
end;

class function TfrxDataPage.GetDescription: String;
begin
  Result := frxResources.Get('obDataPage');
end;


{ TfrxEngineOptions }

constructor TfrxEngineOptions.Create;
begin
  Clear;
  FMaxMemSize := 10;
  FPrintIfEmpty := True;
  FSilentMode := simMessageBoxes;
  FEnableThreadSafe := False;
  FTempDir := '';
  FUseGlobalDataSetList := True;
  FUseFileCache := False;
  FDestroyForms := True;
end;

procedure TfrxEngineOptions.Assign(Source: TPersistent);
begin
  if Source is TfrxEngineOptions then
  begin
    FConvertNulls := TfrxEngineOptions(Source).ConvertNulls;
    FDoublePass := TfrxEngineOptions(Source).DoublePass;
    FMaxMemSize := TfrxEngineOptions(Source).MaxMemSize;
    FPrintIfEmpty := TfrxEngineOptions(Source).PrintIfEmpty;
    NewSilentMode := TfrxEngineOptions(Source).NewSilentMode;
    FTempDir := TfrxEngineOptions(Source).TempDir;
    FUseFileCache := TfrxEngineOptions(Source).UseFileCache;
    FIgnoreDevByZero := TfrxEngineOptions(Source).IgnoreDevByZero;
  end;
end;

procedure TfrxEngineOptions.AssignThreadProps(Source: TPersistent);
begin
  if Source is TfrxEngineOptions then
  begin
    NewSilentMode := TfrxEngineOptions(Source).NewSilentMode;
    FUseFileCache := TfrxEngineOptions(Source).UseFileCache;
    FDestroyForms := TfrxEngineOptions(Source).FDestroyForms;
    FEnableThreadSafe := TfrxEngineOptions(Source).FEnableThreadSafe;
    FUseGlobalDataSetList := TfrxEngineOptions(Source).FUseGlobalDataSetList;
  end;
end;

procedure TfrxEngineOptions.Clear;
begin
  FConvertNulls := True;
  FIgnoreDevByZero := False;
  FDoublePass := False;
end;

procedure TfrxEngineOptions.SetSilentMode(Mode: Boolean);
begin
  if Mode = True then
    FSilentMode := simSilent
  else
    FSilentMode := simMessageBoxes;
end;

function TfrxEngineOptions.GetSilentMode: Boolean;
begin
  if FSilentMode = simSilent then
    Result := True
  else
    Result := False;
end;

{ TfrxPreviewOptions }

constructor TfrxPreviewOptions.Create;
begin
  Clear;
  FAllowEdit := True;
  FButtons := [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind,
    pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection];
  FDoubleBuffered := True;
  FMaximized := True;
  FMDIChild := False;
  FModal := True;
  FPagesInCache := 50;
  FShowCaptions := False;
  FZoom := 1;
  FZoomMode := zmDefault;
  FPictureCacheInFile := False;
  AllowPreviewEdit := True;
end;

procedure TfrxPreviewOptions.Assign(Source: TPersistent);
begin
  if Source is TfrxPreviewOptions then
  begin
    FAllowEdit := TfrxPreviewOptions(Source).AllowEdit;
    FAllowPreviewEdit := TfrxPreviewOptions(Source).AllowPreviewEdit;
    FButtons := TfrxPreviewOptions(Source).Buttons;
    FDoubleBuffered := TfrxPreviewOptions(Source).DoubleBuffered;
    FMaximized := TfrxPreviewOptions(Source).Maximized;
    FMDIChild := TfrxPreviewOptions(Source).MDIChild;
    FModal := TfrxPreviewOptions(Source).Modal;
    FOutlineExpand := TfrxPreviewOptions(Source).OutlineExpand;
    FOutlineVisible := TfrxPreviewOptions(Source).OutlineVisible;
    FOutlineWidth := TfrxPreviewOptions(Source).OutlineWidth;
    FPagesInCache := TfrxPreviewOptions(Source).PagesInCache;
    FShowCaptions := TfrxPreviewOptions(Source).ShowCaptions;
    FThumbnailVisible := TfrxPreviewOptions(Source).ThumbnailVisible;
    FZoom := TfrxPreviewOptions(Source).Zoom;
    FZoomMode := TfrxPreviewOptions(Source).ZoomMode;
    FPictureCacheInFile := TfrxPreviewOptions(Source).PictureCacheInFile;
    FRTLPreview := TfrxPreviewOptions(Source).RTLPreview;
  end;
end;

procedure TfrxPreviewOptions.Clear;
begin
  FOutlineExpand := True;
  FOutlineVisible := False;
  FOutlineWidth := 120;
  FPagesInCache := 50;
  FThumbnailVisible := False;
end;

{ TfrxPrintOptions }

constructor TfrxPrintOptions.Create;
begin
  Clear;
end;

procedure TfrxPrintOptions.Assign(Source: TPersistent);
begin
  if Source is TfrxPrintOptions then
  begin
    FCopies := TfrxPrintOptions(Source).Copies;
    FCollate := TfrxPrintOptions(Source).Collate;
    FPageNumbers := TfrxPrintOptions(Source).PageNumbers;
    FPrinter := TfrxPrintOptions(Source).Printer;
    FPrintMode := TfrxPrintOptions(Source).PrintMode;
    FPrintOnSheet := TfrxPrintOptions(Source).PrintOnSheet;
    FPrintPages := TfrxPrintOptions(Source).PrintPages;
    FReverse := TfrxPrintOptions(Source).Reverse;
    FShowDialog := TfrxPrintOptions(Source).ShowDialog;
    FSplicingLine := TfrxPrintOptions(Source).SplicingLine;
  end;
end;

procedure TfrxPrintOptions.Clear;
begin
  FCopies := 1;
  FCollate := True;
  FPageNumbers := '';
  FPagesOnSheet := 0;
  FPrinter := frxResources.Get('prDefault');
  FPrintMode := pmDefault;
  FPrintOnSheet := 0;
  FPrintPages := ppAll;
  FReverse := False;
  FShowDialog := True;
  FSplicingLine := 3;
  FDuplex := dmNone;
end;

{ TfrxReportOptions }

constructor TfrxReportOptions.Create;
begin
  FDescription := TStringList.Create;
  FPicture := TPicture.Create;
  FCreateDate := Now;
  FLastChange := Now;
  FPrevPassword := '';
  FInfo := False;
end;

destructor TfrxReportOptions.Destroy;
begin
  FDescription.Free;
  FPicture.Free;
  inherited;
end;

procedure TfrxReportOptions.Assign(Source: TPersistent);
begin
  if Source is TfrxReportOptions then
  begin
    FAuthor := TfrxReportOptions(Source).Author;
    FCompressed := TfrxReportOptions(Source).Compressed;
    FConnectionName := TfrxReportOptions(Source).ConnectionName;
    FCreateDate := TfrxReportOptions(Source).CreateDate;
    Description := TfrxReportOptions(Source).Description;
    FInitString := TfrxReportOptions(Source).InitString;
    FLastChange := TfrxReportOptions(Source).LastChange;
    FName := TfrxReportOptions(Source).Name;
    FPassword := TfrxReportOptions(Source).Password;
    Picture := TfrxReportOptions(Source).Picture;
    FVersionBuild := TfrxReportOptions(Source).VersionBuild;
    FVersionMajor := TfrxReportOptions(Source).VersionMajor;
    FVersionMinor := TfrxReportOptions(Source).VersionMinor;
    FVersionRelease := TfrxReportOptions(Source).VersionRelease;
  end;
end;

procedure TfrxReportOptions.Clear;
begin
  if not FInfo then
  begin
    FAuthor := '';
    FCompressed := False;
    FCreateDate := Now;
    FDescription.Clear;
    FLastChange := Now;
    FPicture.Assign(nil);
    FVersionBuild := '';
    FVersionMajor := '';
    FVersionMinor := '';
    FVersionRelease := '';
  end;
  FConnectionName := '';
  FInitString := '';
  FName := '';
  FPassword := '';
  FPrevPassword := '';
end;

procedure TfrxReportOptions.SetDescription(const Value: TStrings);
begin
  FDescription.Assign(Value);
end;

procedure TfrxReportOptions.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

function TfrxReportOptions.CheckPassword: Boolean;
begin
  Result := True;
  if (FPassword <> '') and (FPassword <> FPrevPassword) and (FPassword <> HiddenPassword) then
    with TfrxPasswordForm.Create(Application) do
    begin
      if (ShowModal <> mrOk) or (FPassword <> PasswordE.Text) then
      begin
        Result := False;
        FReport.Errors.Add(frxResources.Get('Invalid password'));
        frxCommonErrorHandler(FReport, frxResources.Get('clErrors') + #13#10 + FReport.Errors.Text);
      end
      else
        FPrevPassword := FPassword;
      Free;
    end;
end;

procedure TfrxReportOptions.SetConnectionName(const Value: String);
{$IFNDEF FPC}
var
  ini: TRegistry;
  conn: String;
{$ENDIF}
begin
  FConnectionName := Value;
  {$IFNDEF FPC}
  if Value <> '' then
    if Assigned(FReport.OnSetConnection) then
    begin
      ini := TRegistry.Create;
      try
        ini.RootKey := HKEY_LOCAL_MACHINE;
        if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS) then
        begin
          conn := ini.ReadString(Value);
          if conn <> '' then FReport.OnSetConnection( conn );
          ini.CloseKey;
        end;
        ini.RootKey := HKEY_CURRENT_USER;
        if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS) then
        begin
          conn := ini.ReadString(Value);
          if conn <> '' then FReport.OnSetConnection(conn);
          ini.CloseKey;
        end;
// Samuray
        ini.RootKey := HKEY_LOCAL_MACHINE;
        if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS+'FIB') then
        begin
          conn := ini.ReadString(Value);
          if conn <> '' then FReport.OnSetConnection( conn );
          ini.CloseKey;
        end;
        ini.RootKey := HKEY_CURRENT_USER;
        if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS+'FIB') then
        begin
          conn := ini.ReadString(Value);
          if conn <> '' then FReport.OnSetConnection(conn);
          ini.CloseKey;
        end;
      finally
        ini.Free;
      end;
    end;
  {$ENDIF}
end;

{ TfrxDataSetItem }

procedure TfrxDataSetItem.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxDataSetItem.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  if FDataSetName = '' then
    FDataSet := nil
  else if TfrxReportDataSets(Collection).FReport <> nil then
    FDataSet := TfrxReportDataSets(Collection).FReport.FindDataSet(FDataSet, FDataSetName);
end;

function TfrxDataSetItem.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;


{ TfrxReportDatasets }

constructor TfrxReportDatasets.Create(AReport: TfrxReport);
begin
  inherited Create(TfrxDatasetItem);
  FReport := AReport;
end;

procedure TfrxReportDataSets.Initialize;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].DataSet <> nil then
    begin
      Items[i].DataSet.ReportRef := FReport;
      Items[i].DataSet.Initialize;
    end;
end;

procedure TfrxReportDataSets.Finalize;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].DataSet <> nil then
      Items[i].DataSet.Finalize;
end;

procedure TfrxReportDatasets.Add(ds: TfrxDataSet);
begin
  TfrxDatasetItem(inherited Add).DataSet := ds;
end;

function TfrxReportDatasets.GetItem(Index: Integer): TfrxDatasetItem;
begin
  Result := TfrxDatasetItem(inherited Items[Index]);
end;

function TfrxReportDatasets.Find(ds: TfrxDataSet): TfrxDatasetItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].DataSet = ds then
    begin
      Result := Items[i];
      Exit;
    end;
end;

function TfrxReportDatasets.Find(const Name: String): TfrxDatasetItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].DataSet <> nil then
      if (CompareText(Items[i].DataSet.UserName, Name) = 0) or
        (CompareText(Items[i].DataSet.Name, Name) = 0) then
      begin
        Result := Items[i];
        Exit;
      end;
end;

procedure TfrxReportDatasets.Delete(const Name: String);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].DataSet <> nil then
      if CompareText(Items[i].DataSet.UserName, Name) = 0 then
      begin
        Items[i].Free;
        Exit;
      end;
end;

{ TfrxStyleItem }

constructor TfrxStyleItem.Create(Collection: TCollection);
begin
  inherited;
  //FColor := clNone;
  FFont := TFont.Create;
  with FFont do
  begin
    PixelsPerInch := 96;
    Name := DefFontName;
    Size := DefFontSize;
    Charset := frxCharset;
  end;
  FFrame := TfrxFrame.Create;
  FFill := TfrxBrushFill.Create;
  ApplyFont := True;
  ApplyFill := True;
  ApplyFrame := True;
end;

destructor TfrxStyleItem.Destroy;
begin
  FFont.Free;
  FFrame.Free;
  FFill.Free;
  inherited;
end;

function TfrxStyleItem.GetColor: TColor;
begin
  if Self.Fill is TfrxBrushFill then
    Result := TfrxBrushFill(Self.Fill).FBackColor
  else if Self.Fill is TfrxGradientFill then
    Result := TfrxGradientFill(Self.Fill).GetColor
  else
    Result := clNone;
end;

function TfrxStyleItem.GetFillType: TfrxFillType;
begin
  Result := frxGetFillType(FFill);
end;

function TfrxStyleItem.GetInheritedName: String;
begin
  if FName <> '' then
    Result := FName
  else
    Result := inherited GetInheritedName;
end;

procedure TfrxStyleItem.Assign(Source: TPersistent);
begin
  if Source is TfrxStyleItem then
  begin
    FName := TfrxStyleItem(Source).Name;
    FillType := TfrxStyleItem(Source).FillType;
    FFill.Assign(TfrxStyleItem(Source).FFill);
    FFont.Assign(TfrxStyleItem(Source).Font);
    FFrame.Assign(TfrxStyleItem(Source).Frame);
    FApplyFont := TfrxStyleItem(Source).ApplyFont;
    FApplyFill := TfrxStyleItem(Source).ApplyFill;
    FApplyFrame := TfrxStyleItem(Source).ApplyFrame;
    FIsInherited := TfrxStyleItem(Source).IsInherited;
  end;
end;

procedure TfrxStyleItem.SetColor(const Value: TColor);
begin
  if Self.Fill is TfrxBrushFill then
    TfrxBrushFill(Self.Fill).FBackColor := Value;
end;

procedure TfrxStyleItem.SetFill(const Value: TfrxCustomFill);
begin
  FillType := frxGetFillType(Value);
  FFill.Assign(Value);
end;

procedure TfrxStyleItem.SetFillType(const Value: TfrxFillType);
begin
  if FillType = Value then Exit;
  FFill.Free;
  FFill := frxCreateFill(Value);
end;

procedure TfrxStyleItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TfrxStyleItem.SetFrame(const Value: TfrxFrame);
begin
  FFrame.Assign(Value);
end;

procedure TfrxStyleItem.SetName(const Value: String);
var
  Item: TfrxStyleItem;
begin
  Item := TfrxStyles(Collection).Find(Value);
  if (Item = nil) or (Item = Self) then
    FName := Value else
    raise Exception.Create(frxResources.Get('clDupName'));
end;

procedure TfrxStyleItem.CreateUniqueName;
var
  i: Integer;
begin
  i := 1;
  while TfrxStyles(Collection).Find('Style' + IntToStr(i)) <> nil do
    Inc(i);
  Name := 'Style' + IntToStr(i);
end;


{ TfrxStyles }

constructor TfrxStyles.Create(AReport: TfrxReport);
begin
  inherited Create(TfrxStyleItem);
  FReport := AReport;
end;

function TfrxStyles.Add: TfrxStyleItem;
begin
  Result := TfrxStyleItem(inherited Add);
end;

function TfrxStyles.Find(const Name: String): TfrxStyleItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, Name) = 0 then
    begin
      Result := Items[i];
      break;
    end;
end;

function TfrxStyles.GetItem(Index: Integer): TfrxStyleItem;
begin
  Result := TfrxStyleItem(inherited Items[Index]);
end;

procedure TfrxStyles.GetList(List: TStrings);
var
  i: Integer;
begin
  List.Clear;
  for i := 0 to Count - 1 do
    List.Add(Items[i].Name);
end;

procedure TfrxStyles.LoadFromXMLItem(Item: TfrxXMLItem; OldXMLFormat: Boolean);
var
  xs: TfrxXMLSerializer;
  i: Integer;
begin
  Clear;
  xs := TfrxXMLSerializer.Create(nil);
  try
    xs.OldFormat := OldXMLFormat;
    Name := Item.Prop['Name'];
    for i := 0 to Item.Count - 1 do
{$IFDEF Delphi12}
//      if AnsiStrIComp(PAnsiChar(Item[i].Name), PAnsiChar(AnsiString('item'))) = 0 then
      if CompareText(Item[i].Name, 'item') = 0 then
{$ELSE}
      if CompareText(Item[i].Name, 'item') = 0 then
{$ENDIF}
        xs.XMLToObj(Item[i].Text, Add);
  finally
    xs.Free;
  end;

  Apply;
end;

procedure TfrxStyles.SaveToXMLItem(Item: TfrxXMLItem);
var
  xi: TfrxXMLItem;
  xs: TfrxXMLSerializer;
  i: Integer;
begin
  xs := TfrxXMLSerializer.Create(nil);
  try
    Item.Name := 'style';
    Item.Prop['Name'] := Name;
    for i := 0 to Count - 1 do
    begin
      xi := Item.Add;
      xi.Name := 'item';
      xi.Text := xs.ObjToXML(Items[i]);
    end;
  finally
    xs.Free;
  end;
end;

procedure TfrxStyles.LoadFromFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxStyles.LoadFromStream(Stream: TStream);
var
  x: TfrxXMLDocument;
begin
  Clear;
  x := TfrxXMLDocument.Create;
  try
    x.LoadFromStream(Stream);
{$IFDEF Delphi12}
//    if AnsiStrIComp(PAnsiChar(x.Root.Name), PansiChar(AnsiString('style'))) = 0 then
    if CompareText(x.Root.Name, 'style') = 0 then
{$ELSE}
    if CompareText(x.Root.Name, 'style') = 0 then
{$ENDIF}
      LoadFromXMLItem(x.Root, x.OldVersion);
  finally
    x.Free;
  end;
end;

procedure TfrxStyles.SaveToFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxStyles.SaveToStream(Stream: TStream);
var
  x: TfrxXMLDocument;
begin
  x := TfrxXMLDocument.Create;
  x.AutoIndent := True;
  try
    x.Root.Name := 'style';
    SaveToXMLItem(x.Root);
    x.SaveToStream(Stream);
  finally
    x.Free;
  end;
end;

procedure TfrxStyles.Apply;
var
  i: Integer;
  l: TList;
begin
  if FReport <> nil then
  begin
    l := FReport.AllObjects;
    for i := 0 to l.Count - 1 do
      if TObject(l[i]) is TfrxCustomMemoView then
        if Find(TfrxCustomMemoView(l[i]).Style) = nil then
          TfrxCustomMemoView(l[i]).Style := ''
        else
          TfrxCustomMemoView(l[i]).Style := TfrxCustomMemoView(l[i]).Style;
  end;
end;


{ TfrxStyleSheet }

constructor TfrxStyleSheet.Create;
begin
  FItems := TList.Create;
end;

destructor TfrxStyleSheet.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TfrxStyleSheet.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

procedure TfrxStyleSheet.Delete(Index: Integer);
begin
  Items[Index].Free;
  FItems.Delete(Index);
end;

function TfrxStyleSheet.Add: TfrxStyles;
begin
  Result := TfrxStyles.Create(nil);
  FItems.Add(Result);
end;

function TfrxStyleSheet.Count: Integer;
begin
  Result := FItems.Count;
end;

function TfrxStyleSheet.GetItems(Index: Integer): TfrxStyles;
begin
  Result := FItems[Index];
end;

function TfrxStyleSheet.Find(const Name: String): TfrxStyles;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, Name) = 0 then
    begin
      Result := Items[i];
      break;
    end;
end;

function TfrxStyleSheet.IndexOf(const Name: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, Name) = 0 then
    begin
      Result := i;
      break;
    end;
end;

procedure TfrxStyleSheet.GetList(List: TStrings);
var
  i: Integer;
begin
  List.Clear;
  for i := 0 to Count - 1 do
    List.Add(Items[i].Name);
end;

procedure TfrxStyleSheet.LoadFromFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxStyleSheet.LoadFromStream(Stream: TStream);
var
  x: TfrxXMLDocument;
  i: Integer;
begin
  Clear;
  x := TfrxXMLDocument.Create;
  try
    x.LoadFromStream(Stream);
{$IFDEF Delphi12}
//    if AnsiStrIComp(PAnsiChar(x.Root.Name), PAnsiChar(AnsiString('stylesheet'))) = 0 then
    if CompareText(x.Root.Name, 'stylesheet') = 0 then
{$ELSE}
    if CompareText(x.Root.Name, 'stylesheet') = 0 then
{$ENDIF}
      for i := 0 to x.Root.Count - 1 do
{$IFDEF Delphi12}
//        if AnsiStrIComp(PAnsiChar(x.Root[i].Name), PAnsiChar(AnsiString('style'))) = 0 then
        if CompareText(x.Root[i].Name, 'style') = 0 then
{$ELSE}
        if CompareText(x.Root[i].Name, 'style') = 0 then
{$ENDIF}
          Add.LoadFromXMLItem(x.Root[i], x.OldVersion);
  finally
    x.Free;
  end;
end;

procedure TfrxStyleSheet.SaveToFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxStyleSheet.SaveToStream(Stream: TStream);
var
  x: TfrxXMLDocument;
  i: Integer;
begin
  x := TfrxXMLDocument.Create;
  x.AutoIndent := True;
  try
    x.Root.Name := 'stylesheet';
    for i := 0 to Count - 1 do
      Items[i].SaveToXMLItem(x.Root.Add);

    x.SaveToStream(Stream);
  finally
    x.Free;
  end;
end;


{ TfrxReport }

constructor TfrxReport.Create(AOwner: TComponent);
begin
  inherited;
  FVersion := FR_VERSION;
  {$IFDEF FPC}
  { create parent form for OLE and RICH controls in the main thread }
  frxParentForm;
  {$ENDIF}
  FDatasets := TfrxReportDatasets.Create(Self);
  FVariables := TfrxVariables.Create;
  FSaveParentScript := nil;
  FScript := TfsScript.Create(nil);
  FScript.ExtendedCharset := True;
  FScript.AddRTTI;

  FTimer := TTimer.Create(nil);
  FTimer.Interval := 50;
  FTimer.Enabled := False;
  FTimer.OnTimer := OnTimer;

  FEngineOptions := TfrxEngineOptions.Create;
  FPreviewOptions := TfrxPreviewOptions.Create;
  FPrintOptions := TfrxPrintOptions.Create;
  FReportOptions := TfrxReportOptions.Create(Self);
  FReportOptions.FReport := Self;

  FIniFile := '\Software\Fast Reports';
{$IFDEF FPC}
{$IFDEF UNIX}
  FIniFile := 'tmp/fr5.ini';
{$ENDIF}
{$ENDIF}
  FScriptText := TStringList.Create;
  FFakeScriptText := TStringList.Create;
  FExpressionCache := TfrxExpressionCache.Create(FScript);
  FErrors := TStringList.Create;
  TStringList(FErrors).Sorted := True;
  TStringList(FErrors).Duplicates := dupIgnore;
  FStyles := TfrxStyles.Create(Self);
  FSysVariables := TStringList.Create;
  FEnabledDataSets := TfrxReportDataSets.Create(Self);
  FShowProgress := True;
  FStoreInDFM := True;
  frComponentStyle := frComponentStyle + [csHandlesNestedProperties];

  FEngine := TfrxEngine.Create(Self);
  FMainPreviewPages := TfrxPreviewPages.Create(Self);
  FPreviewPages := FMainPreviewPages;
  FEngine.FPreviewPages := FPreviewPages;
  FPreviewPages.FEngine := FEngine;
  FDrawText := TfrxDrawText.Create;
  FDrillState := TStringList.Create;
  Clear;
end;

destructor TfrxReport.Destroy;
begin
  inherited;
  if (FPreviewForm <> nil) and not TfrxPreviewForm(FPreviewForm).IsClosing then
    FPreviewForm.Close;
  if Preview <> nil then
    Preview.UnInit(FPreviewPages);
  Preview := nil;
  if FParentReportObject <> nil then
    FParentReportObject.Free;
  FMainPreviewPages.Free;
  FDatasets.Free;
  FEngineOptions.Free;
  FPreviewOptions.Free;
  FPrintOptions.Free;
  FReportOptions.Free;
  FExpressionCache.Free;
  FScript.Free;
  FScriptText.Free;
  FFakeScriptText.Free;
  FVariables.Free;
  FEngine.Free;
  FErrors.Free;
  FStyles.Free;
  FSysVariables.Free;
  FEnabledDataSets.Free;
  FTimer.Free;
  TObject(FDrawText).Free;
  FDrillState.Free;
  if FParentForm <> nil then
  begin
    FParentForm.Free;
	FParentForm := nil;
  end;
end;

class function TfrxReport.GetDescription: String;
begin
  Result := frxResources.Get('obReport');
end;

procedure TfrxReport.DoClear;
begin
  inherited Clear;
  FDataSets.Clear;
  FVariables.Clear;
  FEngineOptions.Clear;
  FPreviewOptions.Clear;
  FPrintOptions.Clear;
  FReportOptions.Clear;
  FStyles.Clear;
  FDataSet := nil;
  FDataSetName := '';
  FDotMatrixReport := False;
  ParentReport := '';

  FScriptLanguage := 'PascalScript';
  with FScriptText do
  begin
    Clear;
    Add('begin');
    Add('');
    Add('end.');
  end;

  with FSysVariables do
  begin
    Clear;
    Add('Date');
    Add('Time');
    Add('Page');
    Add('Page#');
    Add('TotalPages');
    Add('TotalPages#');
    Add('Line');
    Add('Line#');
    Add('CopyName#');
    Add('TableRow');
    Add('TableColumn');
  end;

  FOnRunDialogs := '';
  FOnStartReport := '';
  FOnStopReport := '';
end;

procedure TfrxReport.Clear;
begin
  DoClear;
end;

procedure TfrxReport.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if AComponent is TfrxDataSet then
    begin
      if FDataSets.Find(TfrxDataSet(AComponent)) <> nil then
        FDataSets.Find(TfrxDataSet(AComponent)).Free;
      if FDataset = AComponent then
        FDataset := nil;
      if Designer <> nil then
        Designer.UpdateDataTree;
    end
//    else if AComponent is TfrxPreviewForm then
//      FPreviewForm := nil
    else if AComponent is TfrxCustomPreview then
      if FPreview = AComponent then
        FPreview := nil;
end;

procedure TfrxReport.AncestorNotFound(Reader: TReader; const ComponentName: string;
  ComponentClass: TPersistentClass; var Component: TComponent);
begin
  Component := FindObject(ComponentName);
end;

procedure TfrxReport.DefineProperties(Filer: TFiler);
begin
  inherited;
  if (csWriting in ComponentState) and not FStoreInDFM then Exit;

  Filer.DefineProperty('Datasets', ReadDatasets, WriteDatasets, True);
  Filer.DefineProperty('Variables', ReadVariables, WriteVariables, True);
  Filer.DefineProperty('Style', ReadStyle, WriteStyle, True);
  if Filer is TReader then
    TReader(Filer).OnAncestorNotFound := AncestorNotFound;
end;

procedure TfrxReport.WriteNestedProperties(Item: TfrxXmlItem; aAcenstor: TPersistent = nil);
var
  acVars: TfrxVariables;
  acStyles: TfrxStyles;
begin
  acStyles := nil;
  acVars := nil;
  if FParentReportObject <> nil then
  begin
    acStyles := FParentReportObject.Styles;
    acVars := FParentReportObject.Variables;
  end;

  if Datasets.Count > 0 then
    frxWriteCollection(Datasets, 'Datasets', Item, Self, nil);
  if Variables.Count > 0 then
    frxWriteCollection(Variables, 'Variables', Item, Self, acVars);
  if Styles.Count > 0 then
    frxWriteCollection(Styles, 'Styles', Item, Self, acStyles);
end;

function TfrxReport.ReadNestedProperty(Item: TfrxXmlItem): Boolean;
var
  acVars: TfrxVariables;
  acStyles: TfrxStyles;
begin
  Result := True;
  acStyles := nil;
  acVars := nil;
  if FParentReportObject <> nil then
  begin
    acStyles := FParentReportObject.Styles;
    acVars := FParentReportObject.Variables;
  end;
  if CompareText(Item.Name, 'Datasets') = 0 then
  begin
    if FParentReportObject <> nil then
    // datasets are not inheritable
      Datasets.Clear;
    frxReadCollection(Datasets, Item, Self, nil)
  end
  else if CompareText(Item.Name, 'Variables') = 0 then
    frxReadCollection(Variables, Item, Self, acVars)
  else if CompareText(Item.Name, 'Styles') = 0 then
    frxReadCollection(Styles, Item, Self, acStyles)
  else
    Result := False;
end;

procedure TfrxReport.ReadDatasets(Reader: TReader);
begin
  frxReadCollection(FDatasets, Reader, Self);
end;

procedure TfrxReport.ReadStyle(Reader: TReader);
begin
  frxReadCollection(FStyles, Reader, Self);
end;

procedure TfrxReport.ReadVariables(Reader: TReader);
begin
  frxReadCollection(FVariables, Reader, Self);
end;

procedure TfrxReport.WriteDatasets(Writer: TWriter);
begin
  frxWriteCollection(FDatasets, Writer, Self);
end;

procedure TfrxReport.WriteStyle(Writer: TWriter);
begin
  frxWriteCollection(FStyles, Writer, Self);
end;

procedure TfrxReport.WriteVariables(Writer: TWriter);
begin
  frxWriteCollection(FVariables, Writer, Self);
end;

function TfrxReport.GetPages(Index: Integer): TfrxPage;
begin
  Result := TfrxPage(Objects[Index]);
end;

function TfrxReport.GetPagesCount: Integer;
begin
  Result := Objects.Count;
end;

function TfrxReport.GetReportDrawText: Pointer;
begin
  Result := FDrawText;
end;

procedure TfrxReport.SetScriptText(const Value: TStrings);
begin
  FScriptText.Assign(Value);
end;

procedure TfrxReport.SetEngineOptions(const Value: TfrxEngineOptions);
begin
  FEngineOptions.Assign(Value);
end;

procedure TfrxReport.SetParentReport(const Value: String);
var
  i: Integer;
  list: TList;
  c: TfrxComponent;
  fName, SaveFileName: String;
  SaveXMLSerializer: TObject;
  SaveParentReport: TfrxReport;
  IsReportLoading: Boolean;
begin
  FParentReport := Value;
  if FParentReportObject <> nil then
  begin
    FParentReportObject.Free;
    FParentReportObject := nil;
    FScript.Parent := FSaveParentScript;
  end;
  if Value = '' then
  begin
    list := AllObjects;
    for i := 0 to list.Count - 1 do
    begin
      c := list[i];
      c.FAncestor := False;
    end;

    FAncestor := False;
    Exit;
  end;
  SaveFileName := FFileName;
  SaveXMLSerializer := FXMLSerializer;
  if Assigned(FOnLoadTemplate) then
    FOnLoadTemplate(Self, Value)
  else
  begin
    fName := Value;
    { check relative path, exclude network path }
    if (Length(fName) > 1) and (fName[2] <> ':')
{$IFDEF FPC}
      and not ((fName[1] = PathDelim) and (fName[2] = PathDelim)) then
{$ELSE}
      and not ((fName[1] = '\') and (fName[2] = '\')) then
{$ENDIF}
      begin
        fName := ExtractFilePath(SaveFileName) + Value;
        if not FileExists(fName) then
          fName := GetApplicationFolder + Value;
      end;
    IsReportLoading := IsLoading;
    try
      LoadFromFile(fName);
    finally
      IsLoading := IsReportLoading;
    end;
  end;

  SaveParentReport := TfrxReport.Create(nil);
  SaveParentReport.EngineOptions.AssignThreadProps(Self.EngineOptions);
  SaveParentReport.FileName := FFileName;
  if Assigned(FOnLoadTemplate) then
    SaveParentReport.OnLoadTemplate := FOnLoadTemplate;
  if Assigned(Script.OnGetUnit) then
    SaveParentReport.Script.OnGetUnit:= Script.OnGetUnit;
  SaveParentReport.AssignAll(Self);

  if FParentReportObject <> nil then
  begin
    FScript.Parent := FSaveParentScript;
    FParentReportObject.Free;
  end;
  FParentReportObject := SaveParentReport;
  FFileName := SaveFileName;

  for i := 0 to FParentReportObject.Objects.Count - 1 do
    if TObject(FParentReportObject.Objects[i]) is TfrxReportPage then
      TfrxReportPage(FParentReportObject.Objects[i]).PaperSize := 256;
  { set ancestor flag for parent objects }
  for i := 0 to FVariables.Count - 1 do
    FVariables.Items[i].IsInherited := True;
  for i := 0 to FStyles.Count - 1 do
    FStyles.Items[i].IsInherited := True;

  list := AllObjects;
  for i := 0 to list.Count - 1 do
  begin
    c := list[i];
    c.FAncestor := True;
  end;

  FAncestor := True;
  FParentReport := Value;
  FXMLSerializer := SaveXMLSerializer;
end;

function TfrxReport.InheritFromTemplate(const templName: String; InheriteMode: TfrxInheriteMode = imDefault): Boolean;
var
  tempReport: TfrxReport;
  Ref: TObject;
  i, Index: Integer;
  DS: TfrxDataSet;
  lItem: TfrxFixupItem;
  l, FixupList: TList;
  c: TfrxComponent;
  found, DeleteDuplicates: Boolean;
  saveScript, OpenQuote, CloseQuote: String;
  fn1, fn2: String;
  DSi: TfrxDataSetItem;
  rVar: TfrxVariable;
  rStyle, rStyle2: TfrxStyleItem;

  procedure FixNames(OldName, NewName: String);
  var
    i: Integer;
  begin
    for i := 0 to FixupList.Count - 1 do
      with TfrxFixupItem(FixupList[i]) do
      begin
        if Value = OldName then Value := NewName;
      end;
  end;

  procedure EnumObjects(ToParent, FromParent: TfrxComponent);
  var
    xs: TfrxXMLSerializer;
    s, OldName: String;
    i: Integer;
    cFrom, cTo, tObj: TfrxComponent;
    cFromSubPage, cToSubPage: TfrxReportPage;
  begin
    xs := TfrxXMLSerializer.Create(nil);
    xs.HandleNestedProperties := (ToParent is TfrxReport);
    { don't serialize ParentReport property! }
    xs.SerializeDefaultValues := not (ToParent is TfrxReport);
    if FromParent.Owner is TfrxComponent then
      xs.Owner := TfrxComponent(FromParent.Owner);
    s := xs.ObjToXML(FromParent);
    if ToParent.Owner is TfrxComponent then
      xs.Owner := TfrxComponent(ToParent.Owner);
    xs.XMLToObj(s, ToParent);
    xs.CopyFixupList(FixupList);
    xs.Free;
    i := 0;
    while (i < FromParent.Objects.Count) do
    begin
      cFrom := FromParent.Objects[i];
//      cTo := ToParent.Report.FindObject(cFrom.Name);
      cTo := Self.FindObject(cFrom.Name);
      inc(i);

      if (cTo <> nil) and not (cTo is TfrxPage) then
      begin
        { skip duplicate object }
        if DeleteDuplicates then continue;
        { set empty name for duplicate object, rename later }
        OldName := cFrom.Name;
        cFrom.Name := '';
        cTo := nil;
      end;

      if cTo = nil then
      begin
        cTo := TfrxComponent(cFrom.NewInstance);
        cTo.Create(ToParent);
        if cFrom.Name = '' then
        begin
          cTo.CreateUniqueName;
          tObj := tempReport.FindObject(cTo.Name);
          if tObj <> nil then
          begin
            tObj.Name := '';
            cFrom.Name := cTo.Name;
            tObj.CreateUniqueName;
          end
          else cFrom.Name := cTo.Name;
          FixNames(OldName, cTo.Name);
          if cFrom is TfrxDataSet then
          begin
            TfrxDataSet(cFrom).UserName := cFrom.Name;
            Self.DataSets.Add(TfrxDataSet(cTo));
          end;
        end
        else
          cTo.Name := cFrom.Name;

        if cFrom is TfrxSubreport then
        begin
          cFromSubPage := TfrxSubreport(cFrom).Page;
          TfrxSubreport(cTo).Page := TfrxReportPage.Create(Self);
          cToSubPage := TfrxSubreport(cTo).Page;
          cToSubPage.Assign(cFromSubPage);
          cToSubPage.CreateUniqueName;
          EnumObjects(cToSubPage, cFromSubPage);
          tempReport.Objects.Remove(cFromSubPage);
        end
      end;
      EnumObjects(cTo, cFrom);
    end;
  end;

begin
  Result := True;
{$IFDEF FPC}
  if (Length(FileName) > 1) and ((FileName[1] = '.') or (FileName[1] = PathDelim)) then
{$ELSE}
  if (Length(FileName) > 1) and ((FileName[1] = '.') or (FileName[1] = '\')) then
{$ENDIF}
    fn1 := ExpandFileName(FileName)
  else
    fn1 := FileName;

{$IFDEF FPC}
  if (Length(templName) > 1) and ((templName[1] = '.') or (templName[1] = PathDelim)) then
{$ELSE}
  if (Length(templName) > 1) and ((templName[1] = '.') or (templName[1] = '\')) then
{$ENDIF}
    fn2 := ExpandFileName(templName)
  else
    fn2 := templName;

  if fn1 = fn2 then
  begin
    Result := False;
    Exit;
  end;

  tempReport := TfrxReport.Create(nil);
  FixupList := TList.Create;
  tempReport.AssignAll(Self);
  { load the template }
  ParentReport := ExtractRelativePath(ExtractFilePath(FileName), templName);
  { find duplicate objects }
  found := False;
  l := tempReport.AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if not (c is TfrxPage) and (FindObject(c.Name) <> nil) then
    begin
      found := True;
      break;
    end;
  end;

  deleteDuplicates := False;
  if (found) and (InheriteMode = imDefault) then
  begin
    with TfrxInheritErrorForm.Create(nil) do
    begin
      Result := ShowModal = mrOk;
      if Result then
        deleteDuplicates := DeleteRB.Checked;
      Free;
    end;
  end
  else
    deleteDuplicates := (InheriteMode = imDelete);

  if Result then
  begin
    saveScript := ScriptText.Text;
    EnumObjects(Self, tempReport);

    //load DataSets, Styles and Variables, rename if need
    for i := 0 to tempReport.DataSets.Count - 1 do
    begin
      DSi := DataSets.Find(tempReport.DataSets[i].DataSetName);
      if DSi = nil then
      begin
        DS := Self.FindDataSet(nil, tempReport.DataSets[i].DataSetName);
        if DS <> nil then
          DataSets.Add(DS);
      end;
    end;

    for i := 0 to tempReport.Variables.Count - 1 do
    begin
      rVar := tempReport.Variables.Items[i];
      Index := Variables.IndexOf(rVar.Name);

      if Index <> -1 then
        if not deleteDuplicates then
          rVar.Name := rVar.Name + '_renamed'
        else
          rVar := nil;
      if rVar <> nil then
        Variables.Add.Assign(rVar);
    end;

    for i := 0 to tempReport.Styles.Count - 1 do
    begin
      rStyle := tempReport.Styles[i];
      rStyle2 := Styles.Find(rStyle.Name);
      if rStyle2 <> nil then
        if not deleteDuplicates then
          rStyle.Name := rStyle.Name + '_renamed'
        else
          rStyle := nil;
      if rStyle <> nil then
        Styles.Add.Assign(rStyle);
    end;

    if (Script.SyntaxType = 'C++Script') or (Script.SyntaxType = 'JScript') then
    begin
      OpenQuote := '/*';
      CloseQuote := '*/';
    end
    else if (Script.SyntaxType = 'BasicScript') then
    begin
      OpenQuote := '/\';
      CloseQuote := '/\';
    end
    else if (Script.SyntaxType = 'PascalScript') then
    begin
      OpenQuote := '{';
      CloseQuote := '}';
    end;

    ScriptText.Add(OpenQuote);
    ScriptText.Add('**********Script from parent report**********');
    ScriptText.Text := ScriptText.Text + saveScript;
    ScriptText.Add(CloseQuote);

    { fixup datasets }
    for i := 0 to Self.DataSets.Count - 1 do
//      if DataSets[i].DataSet = nil then
      begin
        DS := Self.FindDataSet(nil, DataSets[i].DataSetName);
        DataSets[i].DataSet := DS;
      end;

    { fixup properties}
    while FixupList.Count > 0 do
    begin
      lItem := TfrxFixupItem(FixupList[0]);
      Ref := Self.FindObject(lItem.Value);
      if Ref = nil then
        Ref := frxFindComponent(Self, lItem.Value);
      if Ref <> nil then
        SetOrdProp(lItem.Obj, lItem.PropInfo, frxInteger(Ref));
      lItem.Free;
      FixupList.Delete(0);
    end;
  end
  else
    AssignAll(tempReport);

  FixupList.Free;
  tempReport.Free;
end;

procedure TfrxReport.SetPreviewOptions(const Value: TfrxPreviewOptions);
begin
  FPreviewOptions.Assign(Value);
end;

procedure TfrxReport.SetPrintOptions(const Value: TfrxPrintOptions);
begin
  FPrintOptions.Assign(Value);
end;

procedure TfrxReport.SetReportOptions(const Value: TfrxReportOptions);
begin
  FReportOptions.Assign(Value);
end;

procedure TfrxReport.SetStyles(const Value: TfrxStyles);
begin
  if Value <> nil then
  begin
    FStyles.Assign(Value);
    FStyles.Apply;
  end
  else
    FStyles.Clear;
end;

procedure TfrxReport.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxReport.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := FindDataSet(FDataSet, FDataSetName);
end;

function TfrxReport.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

function TfrxReport.Calc(const Expr: String; AScript: TfsScript = nil): Variant;
{$IFDEF FPC}
const
  SZeroDivide = 'Division by zero.';
  {$warning HARDCODED CONST SZeroDivide}
{$ENDIF}

var
  ErrorMsg: String;
  CalledFromScript: Boolean;
begin
  CalledFromScript := False;
  if frxInteger(AScript) = 1 then
  begin
    AScript := FScript;
    CalledFromScript := True;
  end;
  if AScript = nil then
    AScript := FScript;
  if not DoGetValue(Expr, Result) then
  begin
    Result := FExpressionCache.Calc(Expr, ErrorMsg, AScript);
    if (ErrorMsg <> '') and
     not ((ErrorMsg = SZeroDivide) and FEngineOptions.IgnoreDevByZero) then
    begin
      if not CalledFromScript then
      begin
        if FCurObject <> '' then
          ErrorMsg := FCurObject + ': ' + ErrorMsg;
        FErrors.Add(ErrorMsg);
      end
      else ErrorMsg := frxResources.Get('clErrorInExp') + ErrorMsg;
      raise Exception.Create(ErrorMsg);
    end;
  end;
end;

function TfrxReport.GetAlias(DataSet: TfrxDataSet): String;
var
  ds: TfrxDataSetItem;
begin
  if DataSet = nil then
  begin
    Result := '';
    Exit;
  end;

  ds := DataSets.Find(DataSet);
  if ds <> nil then
    Result := ds.DataSet.UserName else
    Result := frxResources.Get('clDSNotIncl');
end;

function TfrxReport.GetDataset(const Alias: String): TfrxDataset;
var
  ds: TfrxDataSetItem;
begin
  ds := DataSets.Find(Alias);
  if ds <> nil then
    Result := ds.DataSet else
    Result := nil;
end;

procedure TfrxReport.GetDatasetAndField(const ComplexName: String;
  var DataSet: TfrxDataSet; var Field: String);
var
  i: Integer;
  s: String;
begin
  DataSet := nil;
  Field := '';

  { ComplexName has format: dataset name."field name"
    Spaces are allowed in both parts of the complex name }
  i := Pos('."', ComplexName);
  if i <> 0 then
  begin
    s := Copy(ComplexName, 1, i - 1); { dataset name }
    DataSet := GetDataSet(s);
    Field := Copy(ComplexName, i + 2, Length(ComplexName) - i - 2);
  end;
end;

procedure TfrxReport.GetDataSetList(List: TStrings; OnlyDB: Boolean = False);
var
  i: Integer;
begin
  List.Clear;
  for i := 0 to DataSets.Count - 1 do
    if Datasets[i].DataSet <> nil then
      if not OnlyDB or not (DataSets[i].DataSet is TfrxUserDataSet) then
        List.AddObject(DataSets[i].DataSet.UserName, DataSets[i].DataSet);
end;

procedure TfrxReport.GetActiveDataSetList(List: TStrings);
var
  i: Integer;
  ds: TfrxDataSet;
begin
  if EngineOptions.FUseGlobalDataSetList then
    frxGetDataSetList(List)
  else
  begin
    List.Clear;
    for i := 0 to EnabledDataSets.Count - 1 do
    begin
      ds := EnabledDataSets[i].DataSet;
      if ds <> nil then
        List.AddObject(ds.UserName, ds);
    end;
  end;
end;

procedure TfrxReport.DoLoadFromStream;
var
  SaveLeftTop: Longint;
  Loaded: Boolean;
begin
  SaveLeftTop := DesignInfo;
  Loaded := False;

  if Assigned(frxFR2Events.OnLoad) then
    Loaded := frxFR2Events.OnLoad(Self, FLoadStream);

  if not Loaded then
    inherited LoadFromStream(FLoadStream);

  DesignInfo := SaveLeftTop;
end;

procedure TfrxReport.CheckDataPage;
var
  i, x: Integer;
  l: TList;
  hasDataPage, hasDataObjects: Boolean;
  p: TfrxDataPage;
  c: TfrxComponent;
begin
  { check if report has datapage and datacomponents }
  hasDataPage := False;
  hasDataObjects := False;
  l := AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if c is TfrxDataPage then
      hasDataPage := True;
    if c is TfrxDialogComponent then
      hasDataObjects := True;
  end;

  if not hasDataPage then
  begin
    { create the datapage }
    p := TfrxDataPage.Create(Self);
    if FindObject('Data') = nil then
      p.Name := 'Data'
    else
      p.CreateUniqueName;

    { make it the first page }
    Objects.Delete(Objects.Count - 1);
    Objects.Insert(0, p);

    { move existing datacomponents to this page }
    if hasDataObjects then
    begin
      x := 60;
      for i := 0 to l.Count - 1 do
      begin
        c := l[i];
        if c is TfrxDialogComponent then
        begin
          c.Parent := p;
          c.Left := x;
          c.Top := 20;
          Inc(x, 64);
        end;
      end;
    end;
  end;
end;

procedure TfrxReport.LoadFromStream(Stream: TStream);
var
  Compressor: TfrxCustomCompressor;
  Crypter: TfrxCustomCrypter;
  SaveEngineOptions: TfrxEngineOptions;
  SavePreviewOptions: TfrxPreviewOptions;
  SaveConvertNulls: Boolean;
  SaveIgnoreDevByZero: Boolean;
  SaveDoublePass, SavePrintIfEmpty: Boolean;
  SaveOutlineVisible, SaveOutlineExpand: Boolean;
  SaveOutlineWidth, SavePagesInCache: Integer;
  SaveIni: String;
  SavePreview: TfrxCustomPreview;
  SaveOldStyleProgress, SaveShowProgress, SaveStoreInDFM: Boolean;
  Crypted, SaveThumbnailVisible: Boolean;

  function DecodePwd(const s: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to Length(s) do
      Result := Result + Chr(Ord(s[i]) + 10);
  end;
  { normally we are expect that there is no Global forms with DataSets         }
  { in multi-thread application, but just in case we fix DS link after TReader }
  procedure CheckMThreadDS;
  var
    List: TList;
    i: Integer;
    DSItem: TfrxDatasetItem;
  begin
    if not EngineOptions.UseGlobalDataSetList then
    begin
      List := TList.Create;
      try
        for i := 0 to DataSets.Count - 1 do
          if (DataSets.Items[i].DataSet <> nil) then
          begin
            { internal DS or DS witout owner }
            if (DataSets.Items[i].DataSet.Owner = nil) or
              (DataSets.Items[i].DataSet.Owner is TfrxComponent) then
              List.Add(DataSets.Items[i].DataSet);

            DSItem := EnabledDataSets.Find(DataSets.Items[i].DataSetName);
            if Assigned(DSItem) then
              List.Add(DSItem.DataSet);
          end;
        DataSets.Clear;
        for i := 0 to List.Count - 1 do
          DataSets.Add(TfrxDataSet(List[i]));
      finally
        List.Free;
      end;
    end;
  end;

begin
  FErrors.Clear;

  Compressor := nil;
  if frxCompressorClass <> nil then
  begin
    Compressor := TfrxCustomCompressor(frxCompressorClass.NewInstance);
    Compressor.Create(nil);
    Compressor.Report := Self;
    Compressor.IsFR3File := True;
    try
      Compressor.CreateStream;
      if Compressor.Decompress(Stream) then
        Stream := Compressor.Stream;
    except
      Compressor.Free;
      FErrors.Add(frxResources.Get('clDecompressError'));
      frxCommonErrorHandler(Self, frxResources.Get('clErrors') + #13#10 + FErrors.Text);
      Exit;
    end;
  end;

  ReportOptions.Password := ReportOptions.HiddenPassword;
  Crypter := nil;
  Crypted := False;
  if frxCrypterClass <> nil then
  begin
    Crypter := TfrxCustomCrypter(frxCrypterClass.NewInstance);
    Crypter.Create(nil);
    try
      Crypter.CreateStream;
{$IFDEF Delphi12}
      Crypted := Crypter.Decrypt(Stream, AnsiString(ReportOptions.Password));
{$ELSE}
      Crypted := Crypter.Decrypt(Stream, ReportOptions.Password);
{$ENDIF}
      if Crypted then
        Stream := Crypter.Stream;
    except
      Crypter.Free;
      FErrors.Add(frxResources.Get('clDecryptError'));
      frxCommonErrorHandler(Self, frxResources.Get('clErrors') + #13#10 + FErrors.Text);
      Exit;
    end;
  end;

  SaveEngineOptions := TfrxEngineOptions.Create;
  SaveEngineOptions.Assign(FEngineOptions);
  SavePreviewOptions := TfrxPreviewOptions.Create;
  SavePreviewOptions.Assign(FPreviewOptions);
  SaveIni := FIniFile;
  SavePreview := FPreview;
  SaveOldStyleProgress := FOldStyleProgress;
  SaveShowProgress := FShowProgress;
  SaveStoreInDFM := FStoreInDFM;
  FStreamLoaded := True;
  try
    FLoadStream := Stream;
    try
      DoLoadFromStream;
    except
      on E: Exception do
      begin
        FStreamLoaded := False;
        if (E is TfrxInvalidXMLException) and Crypted then
          FErrors.Add('Invalid password')
       else
         FErrors.Add(E.Message)
      end;
    end;
  finally
    if Compressor <> nil then
      Compressor.Free;
    if Crypter <> nil then
      Crypter.Free;

    CheckDataPage;
    CheckMThreadDS;
    SaveConvertNulls := FEngineOptions.ConvertNulls;
    SaveIgnoreDevByZero := FEngineOptions.IgnoreDevByZero;
    SaveDoublePass := FEngineOptions.DoublePass;
    SavePrintIfEmpty := FEngineOptions.PrintIfEmpty;
    FEngineOptions.Assign(SaveEngineOptions);
    FEngineOptions.ConvertNulls := SaveConvertNulls;
    FEngineOptions.IgnoreDevByZero := SaveIgnoreDevByZero;
    FEngineOptions.DoublePass := SaveDoublePass;
    FEngineOptions.PrintIfEmpty := SavePrintIfEmpty;
    SaveEngineOptions.Free;

    SaveOutlineVisible := FPreviewOptions.OutlineVisible;
    SaveOutlineWidth := FPreviewOptions.OutlineWidth;
    SaveOutlineExpand := FPreviewOptions.OutlineExpand;
    SavePagesInCache := FPreviewOptions.PagesInCache;
    SaveThumbnailVisible := FPreviewOptions.ThumbnailVisible;
    FPreviewOptions.Assign(SavePreviewOptions);
    FPreviewOptions.OutlineVisible := SaveOutlineVisible;
    FPreviewOptions.OutlineWidth := SaveOutlineWidth;
    FPreviewOptions.OutlineExpand := SaveOutlineExpand;
    FPreviewOptions.PagesInCache := SavePagesInCache;
    FPreviewOptions.ThumbnailVisible := SaveThumbnailVisible;
    SavePreviewOptions.Free;
    FIniFile := SaveIni;
    FPreview := SavePreview;
    FOldStyleProgress := SaveOldStyleProgress;
    FShowProgress := SaveShowProgress;
    FStoreInDFM := SaveStoreInDFM;
    if not Crypted then
      ReportOptions.Password := DecodePwd(ReportOptions.Password);

    if ReportOptions.Info or ((not FReloading) and
       (not FEngineOptions.EnableThreadSafe) and
       (not Crypted and not FReportOptions.CheckPassword)) then

      Clear
    else if (FErrors.Count > 0) then
      frxCommonErrorHandler(Self, frxResources.Get('clErrors') + #13#10 + FErrors.Text);
  end;
end;

procedure TfrxReport.SaveToStream(Stream: TStream; SaveChildren: Boolean = True;
  SaveDefaultValues: Boolean = False; UseGetAncestor: Boolean = False);
var
  Compressor: TfrxCustomCompressor;
  Crypter: TfrxCustomCrypter;
  StreamTo: TStream;
  SavePwd: String;
  SavePreview: TfrxCustomPreview;

  function EncodePwd(const s: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to Length(s) do
      Result := Result + Chr(Ord(s[i]) - 10);
  end;

begin
  StreamTo := Stream;

  Compressor := nil;
  if FReportOptions.Compressed and (frxCompressorClass <> nil) then
  begin
    Compressor := TfrxCustomCompressor(frxCompressorClass.NewInstance);
    Compressor.Create(nil);
    Compressor.Report := Self;
    Compressor.IsFR3File := True;
    Compressor.CreateStream;
    StreamTo := Compressor.Stream;
  end;

  Crypter := nil;
  if (FReportOptions.Password <> '') and (frxCrypterClass <> nil) then
  begin
    Crypter := TfrxCustomCrypter(frxCrypterClass.NewInstance);
    Crypter.Create(nil);
    Crypter.CreateStream;
    StreamTo := Crypter.Stream;
  end;

  SavePwd := ReportOptions.Password;
  ReportOptions.PrevPassword := SavePwd;
  if Crypter = nil then
    ReportOptions.Password := EncodePwd(SavePwd);
  SavePreview := FPreview;
  FPreview := nil;

  try
    inherited SaveToStream(StreamTo, SaveChildren, SaveDefaultValues);
  finally
    FPreview := SavePreview;
    ReportOptions.Password := SavePwd;
    { crypt }
    if Crypter <> nil then
    begin
      try
        if Compressor <> nil then
{$IFDEF Delphi12}
          Crypter.Crypt(Compressor.Stream, UTF8Encode(ReportOptions.Password))
{$ELSE}
          Crypter.Crypt(Compressor.Stream, ReportOptions.Password)
{$ENDIF}
        else
{$IFDEF Delphi12}
          Crypter.Crypt(Stream, UTF8Encode(ReportOptions.Password));
{$ELSE}
          Crypter.Crypt(Stream, ReportOptions.Password);
{$ENDIF}
      finally
        Crypter.Free;
      end;
    end;
    { compress }
    if Compressor <> nil then
    begin
      try
        Compressor.Compress(Stream);
      finally
        Compressor.Free;
      end;
    end;
  end;
end;

function TfrxReport.LoadFromFile(const FileName: String;
  ExceptionIfNotFound: Boolean = False): Boolean;
var
  f: TfrxIOTransportFile;
begin
  Clear;
  FFileName := '';
  Result := FileExists(FileName);
  if Result or ExceptionIfNotFound then
  begin
    f := TfrxIOTransportFile.CreateNoRegister;
    try
      FFileName := FileName;
      //f.FileName := FileName;
      ProcessIOTransport(f, FileName, faRead);
    finally
      f.Free;
    end;
  end;
end;

function TfrxReport.LoadFromFilter(Filter: TfrxCustomIOTransport;
  const FileName: String): Boolean;
begin
  Result := ProcessIOTransport(Filter, FileName, faRead);
end;

procedure TfrxReport.SaveToFile(const FileName: String);
var
  f: TfrxIOTransportFile;
begin
  //fix up ParentReport property
  if (Length(FParentReport) > 1) and (FParentReport[2] = ':') then
    FParentReport := ExtractRelativePath(ExtractFilePath(FileName), FParentReport);
  f := TfrxIOTransportFile.CreateNoRegister;
  f.BasePath := ExtractFilePath(FileName);
  try
    ProcessIOTransport(f, FileName, faWrite);
  finally
    f.Free;
  end;
end;

function TfrxReport.SaveToFilter(Filter: TfrxCustomIOTransport; const FileName: String): Boolean;
begin
  Result := ProcessIOTransport(Filter, FileName, faWrite);
end;

function TfrxReport.GetIniFile: TCustomIniFile;
begin
  {$IFNDEF FPC}
  if Pos('\Software\', FIniFile) = 1 then
    Result := TRegistryIniFile.Create(FIniFile)
  else
  {$ENDIF}
    Result := TIniFile.Create(FIniFile);
end;

function TfrxReport.GetApplicationFolder: String;
begin
  if csDesigning in ComponentState then
{$IFDEF FPC}
    Result := GetCurrentDir + PathDelim
{$ELSE}
    Result := GetCurrentDir + '\'
{$ENDIF}
  else
    Result := ExtractFilePath(Application.ExeName);
end;

procedure TfrxReport.SelectPrinter;
begin
  if frxPrinters.IndexOf(FPrintOptions.Printer) <> -1 then
    frxPrinters.PrinterIndex := frxPrinters.IndexOf(FPrintOptions.Printer);
end;

procedure TfrxReport.DoNotifyEvent(Obj: TObject; const EventName: String;
  RunAlways: Boolean = False);
begin
{$IFNDEF FR_VER_BASIC}
  if FEngine.Running or RunAlways then
    if EventName <> '' then
      FScript.CallFunction(EventName, VarArrayOf([frxInteger(Obj)]), True);
{$ENDIF}
end;

procedure TfrxReport.DoParamEvent(const EventName: String; var Params: Variant;
  RunAlways: Boolean = False);
begin
{$IFNDEF FR_VER_BASIC}
  if FEngine.Running or RunAlways then
    if EventName <> '' then
      FScript.CallFunction1(EventName, Params, True);
{$ENDIF}
end;

procedure TfrxReport.DoBeforePrint(c: TfrxReportComponent);
begin
  if Assigned(FOnBeforePrint) then
    FOnBeforePrint(c);
  DoNotifyEvent(c, c.OnBeforePrint);
end;

procedure TfrxReport.DoAfterPrint(c: TfrxReportComponent);
begin
  if Assigned(FOnAfterPrint) then
    FOnAfterPrint(c);
  DoNotifyEvent(c, c.OnAfterPrint);
end;

procedure TfrxReport.DoPreviewClick(v: TfrxView; Button: TMouseButton;
  Shift: TShiftState; var Modified: Boolean; var EventParams: TfrxInteractiveEventsParams; DblClick: Boolean);
var
  arr: Variant;
begin
  v.MouseClick(DblClick, EventParams);
  arr := VarArrayOf([frxInteger(v), Button, ShiftToByte(Shift), Modified]);
  if DblClick then
    DoParamEvent(v.OnPreviewDblClick, arr, True)
  else
    DoParamEvent(v.OnPreviewClick, arr, True);
  Modified := arr[3];
  if DblClick then
  begin
    if Assigned(FOnDblClickObject) then
      FOnDblClickObject(v, Button, Shift, Modified)
  end
  else
  begin
    if Assigned(FOnClickObject) then
      FOnClickObject(v, Button, Shift, Modified);
  end;
end;

procedure TfrxReport.DoGetAncestor(const Name: String; var Ancestor: TPersistent);
begin
  if FParentReportObject <> nil then
  begin
    if Name = Self.Name then
      Ancestor := FParentReportObject
    else
      Ancestor := FParentReportObject.FindObject(Name);
  end;
end;

function TfrxReport.DoGetValue(const Expr: String; var Value: Variant): Boolean;
var
  i: Integer;
  ds: TfrxDataSet;
  fld: String;
  val: Variant;
  v: TfsCustomVariable;
begin
  Result := False;
  Value := Null;

  if Assigned(frxFR2Events.OnGetValue) then
  begin
    TVarData(val).VType := varEmpty;
    frxFR2Events.OnGetValue(Expr, val);
    if TVarData(val).VType <> varEmpty then
    begin
      Value := val;
      Result := True;
      Exit;
    end;
  end;

  { maybe it's a dataset/field? }
  GetDataSetAndField(Expr, ds, fld);
  if (ds <> nil) and (fld <> '') then
  begin
    Value := ds.Value[fld];
    if FEngineOptions.ConvertNulls and (Value = Null) then
      case ds.FieldType[fld] of
        fftNumeric, fftDateTime:
          Value := 0;
        fftString:
          Value := '';
        fftBoolean:
          Value := False;
      end;
    Result := True;
    Exit;
  end;

  { searching in the sys variables }
  i := FSysVariables.IndexOf(Expr);
  if i <> -1 then
  begin
    case i of
      0: Value := FEngine.StartDate;  { Date }
      1: Value := FEngine.StartTime;  { Time }
      2: Value := FPreviewPages.GetLogicalPageNo; { Page }
      3: Value := FPreviewPages.CurPage + 1;  { Page# }
      4: Value := FPreviewPages.GetLogicalTotalPages;  { TotalPages }
      5: Value := FEngine.TotalPages;  { TotalPages# }
      6: Value := FEngine.CurLine;  { Line }
      7: Value := FEngine.CurLineThrough; { Line# }
      8: Value := frxGlobalVariables['CopyName0'];
      9: Value := FEngine.CurTableRow;
      10: Value := FEngine.CurTableColumn;
    end;
    Result := True;
    Exit;
  end;

  { value supplied by OnGetValue event }
  TVarData(val).VType := varEmpty;
  if Assigned(FOnGetValue) then
    FOnGetValue(Expr, val);
  if Assigned(FOnNewGetValue) then
    FOnNewGetValue(Self, Expr, val);
  if TVarData(val).VType <> varEmpty then
  begin
    Value := val;
    Result := True;
    Exit;
  end;

  { searching in the variables }
  i := FVariables.IndexOf(Expr);
  if i <> -1 then
  begin
    val := FVariables.Items[i].Value;
    if (TVarData(val).VType = varString) or (TVarData(val).VType = varOleStr){$IFDEF Delphi12} or (TVarData(val).VType = varUString){$ENDIF} then
    begin
      if Pos(#13#10, val) <> 0 then
        Value := val
      else
        Value := Calc(val);
    end
    else
      Value := val;
    Result := True;
    Exit;
  end;

  { searching in the global variables }
  i := frxGlobalVariables.IndexOf(Expr);
  if i <> -1 then
  begin
    Value := frxGlobalVariables.Items[i].Value;
    Result := True;
    Exit;
  end;

  if not Assigned(frxFR2Events.OnGetScriptValue) then
  begin
    { searching in the script }
    v := FScript.FindLocal(Expr);
    if (v <> nil) and
      not ((v is TfsProcVariable) or (v is TfsMethodHelper)) then
    begin
      Value := v.Value;
      Result := True;
      Exit;
    end;
  end;
end;

function TfrxReport.GetScriptValue(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
var
  i: Integer;
  s: String;
begin
  if not DoGetValue(Params[0], Result) then
  begin
    { checking aggregate functions }
    s := VarToStr(Params[0]);
    i := Pos('(', s);
    if i <> 0 then
    begin
      s := UpperCase(Trim(Copy(s, 1, i - 1)));
      if (s = 'SUM') or (s = 'MIN') or (s = 'MAX') or
         (s = 'AVG') or (s = 'COUNT') then
      begin
        Result := Calc(Params[0]);
        Exit;
      end;
    end;

    if Assigned(frxFR2Events.OnGetScriptValue) then
      Result := frxFR2Events.OnGetScriptValue(Params)
    else
      FErrors.Add(frxResources.Get('clUnknownVar') + ' ' + VarToStr(Params[0]));
  end;
end;

function TfrxReport.SetScriptValue(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  FVariables[Params[0]] := Params[1];
end;

function TfrxReport.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
var
  p1, p2, p3: Variant;
begin
  if MethodName = 'IIF' then
  begin
    p1 := Params[0];
    p2 := Params[1];
    p3 := Params[2];
    try
      if Calc(p1, FScript.ProgRunning) = True then
        Result := Calc(p2, FScript.ProgRunning) else
        Result := Calc(p3, FScript.ProgRunning);
    except
    end;
  end
  else
  begin
    { do not use ProgName for Aggregates }
    if FScript.ProgName <> '' then
      FScript.ProgName := '';
    if (MethodName = 'SUM') or (MethodName = 'AVG') or (MethodName = 'MIN') or
      (MethodName = 'MAX') then
    begin
      p2 := Params[1];
      if Trim(VarToStr(p2)) = '' then
        p2 := 0
      else
        p2 := Calc(p2, FScript.ProgRunning);
      p3 := Params[2];
      if Trim(VarToStr(p3)) = '' then
        p3 := 0
      else
        p3 := Calc(p3, FScript.ProgRunning);
      Result := FEngine.GetAggregateValue(MethodName, Params[0],
        TfrxBand(frxInteger(p2)), p3);
    end
    else if MethodName = 'COUNT' then
    begin
      p1 := Params[0];
      if Trim(VarToStr(p1)) = '' then
        p1 := 0
      else
        p1 := Calc(p1, FScript.ProgRunning);
      p2 := Params[1];
      if Trim(VarToStr(p2)) = '' then
        p2 := 0
      else
        p2 := Calc(p2, FScript.ProgRunning);
      Result := FEngine.GetAggregateValue(MethodName, '',
        TfrxBand(frxInteger(p1)), p2);
    end;
  end;
end;

function TfrxReport.DoUserFunction(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  if Assigned(FOnUserFunction) then
    Result := FOnUserFunction(MethodName, Params);
end;

function TfrxReport.PrepareScript(ActiveReport: TfrxReport): Boolean;
var
  i: Integer;
  l, l2: TList;
  c, c2: TfrxComponent;
  IsAncenstor: Boolean;
  SaveScript: TfsScript;
  v: TfsMethodHelper;

  function FindParentObj(sName: String): TfrxComponent;
  var
    i: Integer;
  begin
    Result := nil;
    if ActiveReport = Self then Exit;
    l2 := ActiveReport.AllObjects;
    for i := 0 to l2.Count - 1 do
    begin
      c2 := l2[i];
      if c2.Name = sName then
      begin
        Result := c2;
        break;
      end;
    end;
  end;

begin
  IsAncenstor := (FParentReportObject <> nil);

  if IsAncenstor then
  begin
    if (FSaveParentScript = nil) and (FScript.Parent <> FParentReportObject.FScript) then
      FSaveParentScript := FScript.Parent;
  end
  else if FSaveParentScript = nil then
    FSaveParentScript := FScript.Parent;
  if (FSaveParentScript <> nil) and (FParentReportObject <> nil) then
    FParentReportObject.FSaveParentScript := FSaveParentScript;
  if ActiveReport = nil then
    ActiveReport := Self;
  if IsAncenstor then
  begin
    // copy user functions
    for i := 0 to FScript.Count - 1 do
      if FScript.Items[i] is TfsMethodHelper then
        if FScript.Items[i].AddedBy = TObject(2) then
        begin
          FParentReportObject.Script.AddedBy := TObject(2);
          v := TfsMethodHelper(FScript.Items[i]);
          FParentReportObject.Script.AddMethod(v.Syntax, DoUserFunction,  v.Category,  v.Description);
          FParentReportObject.Script.AddedBy :=  nil;
        end;
    Result := FParentReportObject.PrepareScript(ActiveReport);
    if not Result then
    begin
      FErrors.Add(Format(frxResources.Get('clScrError'),
        ['Parent report: ' + FParentReport + ' Line: ' + FParentReportObject.FScript.ErrorPos, FParentReportObject.FScript.ErrorMsg]));
      Exit;
    end;
  end;

  FExpressionCache.Clear;
  FExpressionCache.FScriptLanguage := FScriptLanguage;
  FEngine.NotifyList.Clear;

  FScript.ClearItems(ActiveReport);
  FScript.AddedBy := ActiveReport;
  FScript.MainProg := True;
  if IsAncenstor then
    FScript.Parent := FParentReportObject.FScript
  else
    FScript.Parent := FSaveParentScript;

  try
    l := AllObjects;

    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      c2 := FindParentObj(c.Name);
      if c2 = nil then c2 := c;

      c2.IsDesigning := False;
      { need for cross InitMemos in Inherite report }
      SaveScript := ActiveReport.FScript;
      ActiveReport.FScript := FScript;
      c2.BeforeStartReport;
      ActiveReport.FScript := SaveScript;
      if c2 is TfrxPictureView then
        TfrxPictureView(c2).FPictureChanged := True;
      if not c.IsAncestor then
        FScript.AddObject(c2.Name, c2);
    end;

    FScript.AddObject('Report', ActiveReport);
    FScript.AddObject('PreviewPages', ActiveReport.PreviewPages);
    FScript.AddObject('Engine', ActiveReport.FEngine);
    FScript.AddObject('Outline', ActiveReport.FPreviewPages.Outline);
    FScript.AddVariable('Value', 'Variant', Null);
    FScript.AddVariable('Self', 'TfrxView', Null);
    FScript.AddMethod('function Get(Name: String): Variant', ActiveReport.GetScriptValue);
    FScript.AddMethod('procedure Set(Name: String; Value: Variant)', ActiveReport.SetScriptValue);
    FScript.AddMethod('macrofunction IIF(Expr: Boolean; TrueValue, FalseValue: Variant): Variant',
      ActiveReport.CallMethod);
    FScript.AddMethod('macrofunction SUM(Expr: Variant; Band: Variant = 0; Flags: Integer = 0): Variant',
      ActiveReport.CallMethod);
    FScript.AddMethod('macrofunction AVG(Expr: Variant; Band: Variant = 0; Flags: Integer = 0): Variant',
      ActiveReport.CallMethod);
    FScript.AddMethod('macrofunction MIN(Expr: Variant; Band: Variant = 0; Flags: Integer = 0): Variant',
      ActiveReport.CallMethod);
    FScript.AddMethod('macrofunction MAX(Expr: Variant; Band: Variant = 0; Flags: Integer = 0): Variant',
      ActiveReport.CallMethod);
    FScript.AddMethod('macrofunction COUNT(Band: Variant = 0; Flags: Integer = 0): Variant',
      ActiveReport.CallMethod);

    if Assigned(frxFR2Events.OnPrepareScript) then
      frxFR2Events.OnPrepareScript(ActiveReport);
    FLocalValue := FScript.Find('Value');
    FSelfValue := FScript.Find('Self');
    FScript.Lines := FScriptText;
    FScript.SyntaxType := FScriptLanguage;
  {$IFNDEF FR_VER_BASIC}
    Result := FScript.Compile;
    if not Result then
      FErrors.Add(Format(frxResources.Get('clScrError'),
        [FScript.ErrorPos, FScript.ErrorMsg]));
  {$ELSE}
    Result := True;
  {$ENDIF}
  finally
    FScript.AddedBy := nil;
    //FSaveParentScript := nil;
  end;
end;

function TfrxReport.PrepareReport(ClearLastReport: Boolean = True): Boolean;
var
  TempStream: TStream;
  ErrorsText: String;
  ErrorMessage: String;
  SavePwd: String;
  SaveSplisLine: Integer;
  TmpFile: String;
  EngineRun: Boolean;
  SaveDuplex: TfrxDuplexMode;

  function CheckDatasets: Boolean;
  var
    i: Integer;
  begin
    for i := 0 to FDataSets.Count - 1 do
      if FDatasets[i].DataSet = nil then
        FErrors.Add(Format(frxResources.Get('clDSNotExist'), [FDatasets[i].DataSetName]));
    Result := FErrors.Count = 0;
  end;

begin
  if ClearLastReport then
    PreviewPages.Clear;

  if FPreview <> nil then
    FPreview.Init(Self, FPreviewPages);
  SaveSplisLine := 0;
  FErrors.Clear;
  FTerminated := False;
  Result := False;
  EngineRun := False;

  if CheckDatasets then
  begin
    TempStream := nil;
    SavePwd := ReportOptions.Password;

    { save the report state }
    if FEngineOptions.DestroyForms then
    begin
      if EngineOptions.UseFileCache then
      begin
        TmpFile := frxCreateTempFile(EngineOptions.TempDir);
        TempStream := TFileStream.Create(TmpFile, fmCreate);
      end
      else TempStream := TMemoryStream.Create;

      ReportOptions.Password := '';
      SaveSplisLine := PrintOptions.SplicingLine;
      SaveToStream(TempStream);
    end;

    try
      if Assigned(FOnBeginDoc) then
        FOnBeginDoc(Self);
      if PrepareScript then
      begin
{$IFNDEF FR_VER_BASIC}
        if Assigned(FOnAfterScriptCompile) then FOnAfterScriptCompile(Self);
        if FScript.Statement.Count > 0 then
          FScript.Execute;
{$ENDIF}
        if not Terminated then
          EngineRun := FEngine.Run(True);
        if EngineRun then
        begin
          if Assigned(FOnEndDoc) then
            FOnEndDoc(Self);
          Result := True
        end
        else if FPreviewForm <> nil then
          FPreviewForm.Close;
      end;
    except
      on e: Exception do
        {$IFNDEF FR_VER_BASIC}
        if FScript.ErrorPos <> '' then
          FErrors.Add(e.Message + ' ' + FScript.ErrorPos)
        else
        {$ENDIF}
          FErrors.Add(e.Message);
    end;

    if FEngineOptions.DestroyForms then
    begin
      ErrorsText := FErrors.Text;
      TempStream.Position := 0;
      FReloading := True;
      SaveDuplex := PrintOptions.Duplex;
      try
//        if FEngineOptions.ReportThread = nil then
          LoadFromStream(TempStream);
      finally
        FReloading := False;
        ReportOptions.Password := SavePwd;
        PrintOptions.SplicingLine := SaveSplisLine;
        PrintOptions.Duplex := SaveDuplex;
      end;
      TempStream.Free;
      if EngineOptions.UseFileCache then
        SysUtils.DeleteFile(TmpFile);
      FErrors.Text := ErrorsText;
    end;
  end;

  if FErrors.Text <> '' then
  begin
    Result := False;
    ErrorMessage := frxResources.Get('clErrors') + #13#10 + FErrors.Text;
    frxCommonErrorHandler(Self, ErrorMessage);
  end;
end;

procedure TfrxReport.ShowPreparedReport; {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
var
  WndExStyles: Integer;
begin
  FPreviewForm := nil;
  if FPreview <> nil then
  begin
    FPreview.Init(Self, FPreviewPages);
//    FPreview.FReport := Self;
//    FPreview.FPreviewPages := FPreviewPages;
//    if not FPreview.Init then
//      FPreview.AddPreviewTabOrSwitch(Report, '', '', False);
  end
  else
  begin
    FPreviewForm := TfrxPreviewForm.Create(Application);
    with TfrxPreviewForm(FPreviewForm) do
    begin
      Preview.FReport := Self;
      Preview.FPreviewPages := FPreviewPages;
      FPreview := Preview;
      Init;
      if Assigned(FOnPreview) then
        FOnPreview(Self);
      if PreviewOptions.Maximized then
        Position := poDesigned;
      if FPreviewOptions.Modal then
      begin
        ShowModal;
        Free;
        FPreviewForm := nil;
      end
      else
      begin
        if not FPreviewOptions.MDIChild then
        begin
          WndExStyles := GetWindowLong(Handle, GWL_EXSTYLE);
          SetWindowLong(Handle, GWL_EXSTYLE, WndExStyles or WS_EX_APPWINDOW);
        end;
        FreeOnClose := True;
        Show;
      end;
    end;
  end;
end;

procedure TfrxReport.ShowReport(ClearLastReport: Boolean = True); {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
begin
  { protection from people whow like to click ESC/ENTER and rebuil reports less than a second }
  if Engine.Running then
    Exit;
  if ClearLastReport then
    PreviewPages.Clear;

  if FOldStyleProgress then
  begin
    if PrepareReport(False) then
      ShowPreparedReport;
  end
  else
  begin
    FTimer.Enabled := True;
    ShowPreparedReport;
  end;
end;

procedure TfrxReport.OnTimer(Sender: TObject);
begin
  FTimer.Enabled := False;
  PrepareReport(False);
end;

{$HINTS OFF}

{$UNDEF FR_RUN_DESIGNER}

{$IFDEF FR_LITE}
  {$DEFINE FR_RUN_DESIGNER}
{$ENDIF}

{$IFNDEF ACADEMIC_ED}
{$IFNDEF FR_VER_BASIC}
  {$DEFINE FR_RUN_DESIGNER}
{$ENDIF}
{$ENDIF}

procedure TfrxReport.DesignReport(Modal: Boolean = True; MDIChild: Boolean = False); {$IFDEF UNIX}cdecl;{$ELSE}stdcall;{$ENDIF}
var
  l: TList;
  i: Integer;
  c: TfrxComponent;
  WndExStyles: Integer;
begin
{$IFDEF FR_RUN_DESIGNER}
  if FDesigner <> nil then Exit;
  if frxDesignerClass <> nil then
  begin
    FScript.ClearItems(Self);
    l := AllObjects;
    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      if c is TfrxCustomDBDataset then
      begin
        c.IsDesigning := True;
        c.BeforeStartReport;
      end;
    end;

    FModified := False;
    FDesigner := TfrxCustomDesigner(frxDesignerClass.NewInstance);
    FDesigner.CreateDesigner(nil, Self);

    if MDIChild then
      FDesigner.FormStyle := fsMDIChild;
    PostMessage(FDesigner.Handle, WM_USER + 1, 0, 0);
    if Modal then
    begin
      FDesigner.ShowModal;
      FDesigner.Free;
      Application.ProcessMessages;
      FDesigner := nil;
    end
    else
    begin
      {if window not modal show it in taskbar}
      WndExStyles := GetWindowLong(FDesigner.Handle, GWL_EXSTYLE);
      SetWindowLong(FDesigner.Handle, GWL_EXSTYLE, WndExStyles or WS_EX_APPWINDOW);
      FDesigner.Show;
    end;
  end;
{$ENDIF}
end;
{$HINTS ON}

procedure TfrxReport.DesignReportInPanel(Panel: TWinControl);
{$IFDEF FR_RUN_DESIGNER}
var
  l: TList;
  i: Integer;
  c: TfrxComponent;
  ct: TControl;
  cp: TWinControl;
{$ENDIF}
begin
{$IFDEF FR_RUN_DESIGNER}
  if FDesigner <> nil then Exit;
  if frxDesignerClass <> nil then
  begin
    FScript.ClearItems(Self);
    l := AllObjects;
    for i := 0 to l.Count - 1 do
    begin
      c := l[i];
      if c is TfrxCustomDBDataset then
        c.BeforeStartReport;
    end;

    FModified := False;
    FDesigner := TfrxCustomDesigner(frxDesignerClass.NewInstance);
    FDesigner.CreateDesigner(nil, Self);
    cp := Panel.Parent;
    while cp <> nil do
    begin
      if cp is TForm then
        FDesigner.ParentForm := TForm(cp);
      cp:= cp.Parent;
    end;
    PostMessage(FDesigner.Handle, WM_USER + 1, 0, 0);
    FDesigner.OnShow(FDesigner);

    while FDesigner.ControlCount > 0 do
    begin
      ct := FDesigner.Controls[0];
      ct.Parent := Panel;
    end;
  end;
{$ENDIF}
end;


procedure TfrxReport.DesignReport(IDesigner: {$IFDEF FPC}TObject{$ELSE}IUnknown{$ENDIF}; Editor: TObject);
var
  l: TList;
  i: Integer;
  c: TfrxComponent;
begin
  if FDesigner <> nil then
  begin
    FDesigner.Activate;
    Exit;
  end;
  if (IDesigner = nil) or (Editor.ClassName <> 'TfrxReportEditor') then Exit;

  l := AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if c is TfrxCustomDBDataset then
      c.BeforeStartReport;
  end;

  FDesigner := TfrxCustomDesigner(frxDesignerClass.NewInstance);
  FDesigner.CreateDesigner(nil, Self);
  FDesigner.ShowModal;
end;

{$HINTS OFF}
function TfrxReport.DesignPreviewPage: Boolean;
begin
  Result := False;
{$IFNDEF FR_VER_BASIC}
{$IFNDEF ACADEMIC_ED}
  if FDesigner <> nil then Exit;
  if frxDesignerClass <> nil then
  begin
    FDesigner := TfrxCustomDesigner(frxDesignerClass.NewInstance);
    FDesigner.CreateDesigner(nil, Self, True);
    FDesigner.ShowModal;
    Result := FModified;
  end;
{$ENDIF}
{$ENDIF}
end;
{$HINTS ON}

function TfrxReport.Export(Filter: TfrxCustomExportFilter): Boolean;
begin
  Result := FPreviewPages.Export(Filter);
end;

function TfrxReport.FindObject(const AName: String): TfrxComponent;
  { we are using this code for DS on datamodules which created in threads }
  { when UseGlobalDataSetList is off                                      }
  function GetDSName: String;
  var
    i, pos: Integer;
  begin
    pos := 1;
    for i := Length(AName) downto 1 do
      if AName[i] = '.' then
      begin
        pos := i + 1;
        break;
      end;
    Result := Copy(AName, pos, Length(AName) - pos + 1);
  end;

begin
  Result := Inherited FindObject(AName);
  if (Result = nil) and IsLoading and not EngineOptions.UseGlobalDataSetList and
    (EnabledDataSets.Count > 0) then
    Result := FindDataSet(nil, GetDSName);
end;

function TfrxReport.Print: Boolean;
begin
  Result := FPreviewPages.Print;
end;

function TfrxReport.ProcessIOTransport(Filter: TfrxCustomIOTransport;
  const FileName: String; fAccess: TfrxFilterAccess): Boolean;
var
  FilterStream: TStream;
begin
  Result := False;
  if Filter = nil then Exit;
  Filter.FilterAccess := fAccess;
  if (FileName = '') and (Filter.FileName = '') then
    Filter.FileName := ExtractFileName(Report.FileName);
  Result := Filter.OpenFilter;
  try
    if Result then
    begin
      FilterStream := Filter.GetStream(FileName);
      if FilterStream <> nil then
      begin
        if not Filter.DoFilterSave(FilterStream) then
        if fAccess = faRead then
          LoadFromStream(FilterStream)
        else
          SaveToStream(FilterStream);
        if Filter.FileName <> '' then
          FFileName := Filter.FileName;
        Filter.FreeStream(FilterStream);
      end;
    end;
  finally
    Result := FStreamLoaded;
    Filter.CloseFilter;
  end;
end;

procedure TfrxReport.AddFunction(const FuncName: String;
  const Category: String = ''; const Description: String = '');
begin
  // need to assign function to parent script
  FScript.AddedBy := TObject(2);
  FScript.AddMethod(FuncName, DoUserFunction, Category, Description);
  FScript.AddedBy := nil;
end;

function TfrxReport.GetLocalValue: Variant;
begin
  Result := FLocalValue.Value;
end;

function TfrxReport.GetSelfValue: TfrxView;
begin
  Result := TfrxView(frxInteger(FSelfValue.Value));
end;

procedure TfrxReport.SetLocalValue(const Value: Variant);
begin
  FLocalValue.Value := Value;
end;

procedure TfrxReport.SetSelfValue(const Value: TfrxView);
begin
  FSelfValue.Value := frxInteger(Value);
end;

procedure TfrxReport.SetTerminated(const Value: Boolean);
begin
  FTerminated := Value;
  if Value then
    FScript.Terminate;
end;

procedure TfrxReport.SetPreview(const Value: TfrxCustomPreview);
begin
  if (FPreview <> nil) and (Value = nil) then
  begin
    FPreview.FReport := nil;
    FPreview.FPreviewPages := nil;
    FPreviewForm := nil;
  end;

  FPreview := Value;

  if FPreview <> nil then
  begin
    FPreview.Init(Self, FPreviewPages);
    FPreview.FReport := Self;
    FPreview.FPreviewPages := FPreviewPages;

    FPreviewForm := FPreview.FPreviewForm;
  end;
end;

function TfrxReport.GetCaseSensitive: Boolean;
begin
{$IFDEF Delphi6}
  Result := FExpressionCache.CaseSensitive;
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TfrxReport.GetScriptText: TStrings;
begin
  if (csWriting in ComponentState) and not FStoreInDFM then
    Result := FFakeScriptText
   else Result := FScriptText;
end;

procedure TfrxReport.SetCaseSensitive(const Value: Boolean);
begin
{$IFDEF Delphi6}
  FExpressionCache.CaseSensitive := Value;
{$ENDIF}
end;

procedure TfrxReport.InternalOnProgressStart(ProgressType: TfrxProgressType);
begin
  if (FEngineOptions.EnableThreadSafe) then Exit; //(FEngineOptions.ReportThread <> nil) or

  if Assigned(FOnProgressStart) then
    FOnProgressStart(Self, ProgressType, 0);

  if OldStyleProgress or (ProgressType <> ptRunning) then
  begin
    if FShowProgress then
    begin
      if FProgress <> nil then
        FProgress.Free;
      FProgress := TfrxProgress.Create(nil);
      FProgress.Execute(0, '', True, False);
    end;
  end;

  if (FPreview <> nil) and (ProgressType = ptRunning) then
    FPreview.InternalOnProgressStart(Self, ProgressType, 0);
  if not EngineOptions.EnableThreadSafe then
    Application.ProcessMessages;
end;

procedure TfrxReport.InternalOnProgress(ProgressType: TfrxProgressType;
  Progress: Integer);
begin
  if FEngineOptions.EnableThreadSafe then Exit;
//  if FEngineOptions.ReportThread <> nil then Exit;

  if Assigned(FOnProgress) then
    FOnProgress(Self, ProgressType, Progress);

  if OldStyleProgress or (ProgressType <> ptRunning) then
  begin
    if FShowProgress then
    begin
      case ProgressType of
        ptRunning:
          if not Engine.FinalPass then
            FProgress.Message := Format(frxResources.Get('prRunningFirst'), [Progress])
          else
            FProgress.Message := Format(frxResources.Get('prRunning'), [Progress]);
        ptPrinting:
          FProgress.Message := Format(frxResources.Get('prPrinting'), [Progress]);
        ptExporting:
          FProgress.Message := Format(frxResources.Get('prExporting'), [Progress]);
      end;
      if FProgress.Terminated then
        Terminated := True;
    end;
  end;

  if (FPreview <> nil) and (ProgressType = ptRunning) then
    FPreview.InternalOnProgress(Self, ProgressType, Progress - 1);
  if not EngineOptions.EnableThreadSafe then
    Application.ProcessMessages;
end;

procedure TfrxReport.InternalOnProgressStop(ProgressType: TfrxProgressType);
begin
  if FEngineOptions.EnableThreadSafe then Exit;
//  if FEngineOptions.ReportThread <> nil then Exit;

  if Assigned(FOnProgressStop) then
    FOnProgressStop(Self, ProgressType, 0);

  if OldStyleProgress or (ProgressType <> ptRunning) then
  begin
    if FShowProgress then
    begin
      FProgress.Free;
      FProgress := nil;
    end;
  end;

  if (FPreview <> nil) and (ProgressType = ptRunning) then
    FPreview.InternalOnProgressStop(Self, ProgressType, 0);
  if not EngineOptions.EnableThreadSafe then
    Application.ProcessMessages;
end;

procedure TfrxReport.SetProgressMessage(const Value: String; IsHint: Boolean; bHandleMessage: Boolean);
begin

  if FEngineOptions.EnableThreadSafe then Exit;
//  if FEngineOptions.ReportThread <> nil then Exit;

  if OldStyleProgress and Engine.Running then
  begin
    if FShowProgress then
      FProgress.Message := Value
  end;

  if FPreviewForm <> nil then
    TfrxPreviewForm(FPreviewForm).SetMessageText(Value, IsHint);
  if not EngineOptions.EnableThreadSafe and bHandleMessage then
    Application.ProcessMessages;
end;

procedure TfrxReport.SetVersion(const Value: String);
begin
  FVersion := FR_VERSION;
end;

function TfrxReport.PreparePage(APage: TfrxPage): Boolean;
begin
//  PrepareScript();
  FEngine.NotifyList.Clear;
  Result := FEngine.Run(False, False, APage);
end;

procedure TfrxReport.SetPreviewPages(const Value: TfrxCustomPreviewPages);
begin
  FPreviewPages := Value;
  FEngine.FPreviewPages := FPreviewPages;
  FPreviewPages.FEngine := FEngine;
end;

{$IFDEF FPC}
function TfrxReport.GetLazIniFile: string;
var
  bw,bl:Boolean;
begin
  bw := Pos('\', FIniFile) > 0;
  bl := Pos('/', FIniFile) > 0;
  if not bw and not bl then
    Result := FIniFile
  else
  {$IFDEF LCLGTK2}
    if bw then
      Result := 'tmp/fr5.ini'
    else
      Result := FIniFile;
  {$ELSE}
     if bl then
       Result := '\Software\Fast Reports'
     else
       Result := FIniFile;
  {$ENDIF}
end;
{$ENDIF}

procedure TfrxReport.DoMouseEnter(Sender: TfrxView; aPreviousObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
var
  v: Variant;
begin
  Sender.MouseEnter(aPreviousObject, EventParams);
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Sender);
  if (Sender.OnMouseEnter <> '') then
  begin
    v := VarArrayOf([frxInteger(Sender), EventParams.Refresh]);
    Report.DoParamEvent(Sender.OnMouseEnter, v, True);
    EventParams.Refresh := v[1];
  end;
end;

procedure TfrxReport.DoMouseLeave(Sender: TfrxView; X, Y: Integer; aNextObject: TfrxComponent; var EventParams: TfrxInteractiveEventsParams);
var
  v: Variant;
begin
  Sender.MouseLeave(X, Y, aNextObject, EventParams);
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Sender);
  if (Sender.OnMouseLeave <> '') then
  begin
    v := VarArrayOf([frxInteger(Sender), EventParams.Refresh]);
    Report.DoParamEvent(Sender.OnMouseLeave, v, True);
    EventParams.Refresh := v[1];
  end;
end;

procedure TfrxReport.DoMouseUp(Sender: TfrxView; X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
var
  arr: Variant;
begin
  Sender.MouseUp(X, Y, Button, Shift, EventParams);
  if (Sender.OnMouseUp <> '') then
  begin
    arr := VarArrayOf([frxInteger(Sender), X, Y, Button, ShiftToByte(Shift),
      Modified]);
    DoParamEvent(Sender.OnMouseUp, arr, True);
    EventParams.Refresh := arr[1];
  end;
end;


{ TfrxCustomDesigner }

constructor TfrxCustomDesigner.CreateDesigner(AOwner: TComponent;
  AReport: TfrxReport; APreviewDesigner: Boolean);
begin
  inherited Create(AOwner);
  FReport := AReport;
  FIsPreviewDesigner := APreviewDesigner;
  FObjects := TList.Create;
  FSelectedObjects := TfrxSelectedObjectsList.Create;
  FInspectorLock := False;
end;

destructor TfrxCustomDesigner.Destroy;
begin
  FObjects.Free;
  FSelectedObjects.Free;
  inherited;
end;

procedure TfrxCustomDesigner.SetModified(const Value: Boolean);
begin
  FModified := Value;
  if Value then
    FReport.Modified := True;
end;

procedure TfrxCustomDesigner.SetPage(const Value: TfrxPage);
begin
  FPage := Value;
end;


{ TfrxCustomEngine }

procedure TfrxCustomEngine.BreakAllKeep;
begin
// do nothing
end;

constructor TfrxCustomEngine.Create(AReport: TfrxReport);
begin
  FReport := AReport;
  FNotifyList := TList.Create;
end;

destructor TfrxCustomEngine.Destroy;
begin
  FNotifyList.Free;
  inherited;
end;

function TfrxCustomEngine.GetDoublePass: Boolean;
begin
  Result := FReport.EngineOptions.DoublePass;
end;

procedure TfrxCustomEngine.ShowBandByName(const BandName: String);
begin
  ShowBand(TfrxBand(Report.FindObject(BandName)));
end;

procedure TfrxCustomEngine.StopReport;
begin
  Report.Terminated := True;
end;

function TfrxCustomEngine.GetPageHeight: Extended;
begin
  Result := FPageHeight;
end;

{ TfrxCustomOutline }

constructor TfrxCustomOutline.Create(APreviewPages: TfrxCustomPreviewPages);
begin
  FPreviewPages := APreviewPages;
end;

function TfrxCustomOutline.Engine: TfrxCustomEngine;
begin
  Result := FPreviewPages.Engine;
end;

{ TfrxCustomPreviewPages }

constructor TfrxCustomPreviewPages.Create(AReport: TfrxReport);
begin
  FReport := AReport;
  FOutline := TfrxOutline.Create(Self);
  FPostProcessor := TfrxPostProcessor.Create;
end;

destructor TfrxCustomPreviewPages.Destroy;
begin
  FOutline.Free;
  FreeAndNil(FPostProcessor);
  inherited;
end;

{ TfrxExpressionCache }

constructor TfrxExpressionCache.Create(AScript: TfsScript);
begin
  FExpressions := TStringList.Create;
  FExpressions.Sorted := True;
  FScript := TfsScript.Create(nil);
  FScript.ExtendedCharset := True;
  FMainScript := AScript;
{$IFDEF Delphi6}
  FExpressions.CaseSensitive := True;
{$ENDIF}
end;

destructor TfrxExpressionCache.Destroy;
begin
  FExpressions.Free;
  FScript.Free;
  inherited;
end;

procedure TfrxExpressionCache.Clear;
begin
  FExpressions.Clear;
  FScript.Clear;
end;

function TfrxExpressionCache.Calc(const Expression: String;
  var ErrorMsg: String; AScript: TfsScript): Variant;
var
  i: Integer;
  v: TfsProcVariable;
  Compiled, IsProcCall: Boolean;
begin
  ErrorMsg := '';
  FScript.Parent := AScript;
  IsProcCall := Assigned(FMainScript.ProgRunning) and (FMainScript.ProgName <> '');
  if IsProcCall then
    i := FExpressions.IndexOf(FMainScript.ProgName + '.' + Expression)
  else
    i := FExpressions.IndexOf(Expression);
  if i = -1 then
  begin
    i := FExpressions.Count;
    FScript.SyntaxType := FScriptLanguage;
    if CompareText(FScriptLanguage, 'PascalScript') = 0 then
      FScript.Lines.Text := 'function fr3f' + IntToStr(i) + ': Variant; begin ' +
        'Result := ' + Expression + ' end; begin end.'
    else if CompareText(FScriptLanguage, 'C++Script') = 0 then
      FScript.Lines.Text := 'Variant fr3f' + IntToStr(i) + '() { ' +
        'return ' + Expression + '; } {}'
    else if CompareText(FScriptLanguage, 'BasicScript') = 0 then
      FScript.Lines.Text := 'function fr3f' + IntToStr(i) + #13#10 +
        'return ' + Expression + #13#10 + 'end function'
    else if CompareText(FScriptLanguage, 'JScript') = 0 then
      FScript.Lines.Text := 'function fr3f' + IntToStr(i) + '() { ' +
        'return ' + Expression + '; }';

    Compiled := FScript.Compile;
    v := TfsProcVariable(FScript.Find('fr3f' + IntToStr(i)));

    if not Compiled then
    begin
      if v <> nil then
      begin
        v.Free;
        FScript.Remove(v);
      end;
      ErrorMsg := frxResources.Get('clExprError') + ' ''' + Expression + ''': ' +
        FScript.ErrorMsg;
      Result := Null;
      Exit;
    end;
    if IsProcCall then
      FExpressions.AddObject(FMainScript.ProgName + '.' + Expression, v)
    else
      FExpressions.AddObject(Expression, v);
  end
  else
    v := TfsProcVariable(FExpressions.Objects[i]);
  FMainScript.MainProg := False;
  try
    try
      Result := v.Value;
    except
      on e: Exception do
        ErrorMsg := e.Message;
    end;
  finally
    FMainScript.MainProg := True;
  end;
end;

function TfrxExpressionCache.GetCaseSensitive: Boolean;
begin
{$IFDEF Delphi6}
  Result := FExpressions.CaseSensitive;
{$ELSE}
  Result := False;
{$ENDIF}
end;

procedure TfrxExpressionCache.SetCaseSensitive(const Value: Boolean);
begin
{$IFDEF Delphi6}
  FExpressions.CaseSensitive := Value;
{$ENDIF}
end;

{ TfrxCustomIOTransport }

function TfrxCustomIOTransport.AddContainer(Item: TfrxNode): Boolean;
begin
  Result := True;
end;

function TfrxCustomIOTransport.AllInOneContainer: Boolean;
begin
  Result := False;
end;

procedure TfrxCustomIOTransport.AssignFilter(Source: TfrxCustomIOTransport);
begin
  FReport := Source.Report;
  FShowDialog := Source.ShowDialog;
  FOverwritePrompt := Source.OverwritePrompt;
  FDefaultPath := Source.DefaultPath;
  FFileName := Source.FileName;
  FDefaultExt := Source.DefaultExt;
  FExtDescription := Source.ExtDescription;
end;

procedure TfrxCustomIOTransport.AssignSharedProperties(
  Source: TfrxCustomIOTransport);
begin
//
end;

procedure TfrxCustomIOTransport.CloseFilter;
begin
  if Assigned(FInternalFilter) then
  begin
    InternalFilter.FreeTempContainer;
    FreeAndNil(FInternalFilter);
  end;
  if Assigned(FTempFilter) then
  begin
    FTempFilter.FreeTempContainer;
    FreeAndNil(FTempFilter);
  end;
  FDirTree.Clear;
end;

procedure TfrxCustomIOTransport.CopyStreamsNames(aStrings: TStrings; OpenedOnly: Boolean);
  procedure AddItem(aNode: TfrxNode);
  var
    i: integer;
  begin
    for I := 0 to aNode.Count - 1 do
    begin
      if aNode.Items[i].FOriginalName <> '' then
        aStrings.AddObject(aNode.Items[i].FOriginalName, aNode.Items[i].FObjectData);
      AddItem(aNode.Items[i]);
    end;
  end;
begin
  AddItem(FDirTree);
end;

procedure TfrxCustomIOTransport.CloseAllStreams;
  procedure FreeData(aNode: TfrxNode);
  var
    i: integer;
  begin
    for I := 0 to aNode.Count - 1 do
    begin
      if Assigned(aNode.Items[i].FObjectData) then
        FreeAndNil(aNode.Items[i].FObjectData);
      FreeData(aNode.Items[i]);
    end;
  end;
begin
  if FFreeStream then
    FreeData(FDirTree);
end;

constructor TfrxCustomIOTransport.Create(AOwner: TComponent);
begin
  Inherited;
  FFreeStream := True;
  FClosedLoadLock := False;
  FCreatedFrom := fvOther;
  Visibility := [fvDesigner, fvPreview, fvExport];
  FSupportedStreams := [tsIORead, tsIOWrite];
  if not FNoRegister then
    frxIOTransports.Register(Self);
  FTempFilter := nil;
  FFilterAccess := faRead;
  FDirTree := TfrxNode.Create;
  FDirTree.Name := '';
  FCurNode := FDirTree;
  FInternalFilter := nil;
end;

procedure TfrxCustomIOTransport.CreateContainer(const cName: String; bSetCurrent: Boolean);
var
  cItem, CurNode: TfrxNode;
  sName, fPath: String;
  i: Integer;
begin
  sName := '';
  if cName <> '' then
  begin
//  if sName[Length(sName)] = PathDelim then
//    Delete(sName, Length(sName), 1);
    for i := Length(cName) downto 1 do
      if cName[i] = PathDelim then
      begin
        sName := Copy(cName, i + 1, Length(cName));
        break;
      end;

  if sName = '' then
    sName := cName
  else
  begin
  fPath := cName;
  Delete(fPath, Length(fPath) - Length(sName), Length(sName) + 1);
  end;
//  if sName[1] = PathDelim then
//    Delete(sName, 1, 1);
  end;
  CurNode := GetNodeFromPath(fPath, False);
  if CurNode = nil then Exit;

  if cName = '' then
    cItem := FDirTree
  else
    cItem := CurNode.Add(sName);
  if not AddContainer(cItem) then
    if cItem <> FDirTree then
      cItem.Free
    else if bSetCurrent then
      CurrentContainer := cItem.Name;
end;

function TfrxCustomIOTransport.CreateFilterClone(CreatedFrom: TfrxFilterVisibleState): TfrxCustomIOTransport;
begin
  Result := TfrxCustomIOTransport(NewInstance);
  Result.CreateNoRegister;
  Result.FCreatedFrom := CreatedFrom;
  Result.AssignFilter(Self);
  Result.FOriginalCopy := Self;
  Result.AssignSharedProperties(Self);
end;

constructor TfrxCustomIOTransport.CreateNoRegister;
begin
  FNoRegister := True;
  Create(nil)
end;

procedure TfrxCustomIOTransport.CreateTempContainer;
begin

end;

procedure TfrxCustomIOTransport.DeleteContainer(const cName: String);
var
  cItem: TfrxNode;
begin
  cItem := FCurNode.Find(cName);
  if (cItem <> nil) and (RemoveContainer(cItem)) then
    cItem.Free;
end;

destructor TfrxCustomIOTransport.Destroy;
begin
  if not FNoRegister then
    frxIOTransports.Unregister(Self);
  CloseAllStreams;
  FreeAndNil(FDirTree);
  inherited;
end;

function TfrxCustomIOTransport.DoCreateStream(var aFullFilePath: String; aFileName: String): TStream;
begin
  Result := nil;
end;

function TfrxCustomIOTransport.DoFilterSave(aStream: TStream): Boolean;
begin
  Result := False;
end;

procedure TfrxCustomIOTransport.FreeStream(aStream: TStream; aFileName: String);
var
  aNode: TfrxNode;
begin
  aNode := FDirTree.Find(aStream, True);
  if Assigned(aNode) and Assigned(aNode.FObjectData) then
  begin
    aNode.ObjectData.Free;
    aNode.ObjectData := nil;
    if Assigned(FInternalFilter) then
    begin
      aNode := FInternalFilter.FDirTree.Find(aStream, True);
      if Assigned(aNode) then
        aNode.ObjectData := nil;
    end;
  end;
end;

procedure TfrxCustomIOTransport.FreeTempContainer;
begin

end;

function TfrxCustomIOTransport.GetVisibility: TfrxFilterVisibility;
begin
  Result := FVisibility;
end;

procedure TfrxCustomIOTransport.InitFromExport(
  ExportFilter: TfrxCustomExportFilter);
begin
  DefaultPath := ExportFilter.DefaultPath;
  DefaultExt := ExportFilter.DefaultExt;
  FileName := ExportFilter.FileName;
  Report := ExportFilter.Report;
  FilterString := ExportFilter.FilterDesc;
  FOverwritePrompt := ExportFilter.OverwritePrompt;
  FBasePath := ExtractFilePath(ExportFilter.FileName);
  if (DefaultPath <> '') and (FBasePath = '') then
     FBasePath := DefaultPath;
  FFilterAccess := faWrite;
end;

procedure TfrxCustomIOTransport.LoadClosedStreams;
  procedure LoadData(aNode: TfrxNode);
  var
    i: integer;
    lNode: TfrxNode;
  begin
    for I := 0 to aNode.Count - 1 do
    begin
      lNode := aNode.Items[i];
      if (lNode.FOriginalName <> '') and not Assigned(lNode.FObjectData) then
      lNode.FObjectData := DoCreateStream(lNode.FOriginalName, lNode.Name);
      LoadData(lNode);
    end;
  end;

begin
  LoadData(FDirTree);
end;

procedure TfrxCustomIOTransport.LoadStreamsList(aStrings: TStrings);
var
  i: Integer;
begin
  for i := 0 to aStrings.Count - 1 do
    aStrings.Objects[i] := GetStream(aStrings[i]);
end;

function TfrxCustomIOTransport.GetCurrentContainer: String;
begin
  Result := FCurNode.Name;
end;

class function TfrxCustomIOTransport.GetDescription: String;
begin
  Result := '';
end;

function TfrxCustomIOTransport.GetFileNode: TfrxNode;
var
  bFound: Boolean;

  function DoGetFile(aItem: TfrxNode): TfrxNode;
  var
    lItem: tfrxNode;
    i: Integer;
  begin
    Result := nil;
    for i := 0 to aItem.Count - 1 do
    begin
      lItem := aItem.Items[i];
      if lItem.OriginalName <> '' then
      begin
        bFound := True;
        Result := lItem;
      end
      else
        Result := DoGetFile(lItem);
      if bFound then Exit;
    end;
  end;
begin
  Result := nil;
  if FDirTree.FilesCount = 0 then Exit;
  bFound := False;
  if Assigned(FInternalFilter) then
    Result := FInternalFilter.GetFileNode
  else
    Result := DoGetFile(FDirTree)
end;

function TfrxCustomIOTransport.GetFilterString: String;
begin
  Result := FFilterString;
end;

function TfrxCustomIOTransport.GetInternalFilter: TfrxCustomIOTransport;
begin
  Result := FInternalFilter;
  if Assigned(FInternalFilter) then Exit;
  FInternalFilter := TfrxCustomIOTransport(frxDefaultTempFilterClass.NewInstance);
  FInternalFilter.CreateNoRegister;
  FInternalFilter.FilterAccess := FilterAccess;
  Result := FInternalFilter;
end;

function TfrxCustomIOTransport.GetNodeFromPath(aPath: String; bCreateNodes: Boolean; bLastNodeAsFile: Boolean): TfrxNode;
var
  i, NodeNameStart, NameEnd: Integer;
  CurNode, NextNode: TfrxNode;
  NodeName: String;
begin
  Result := nil;
  if aPath = '' then
  begin
    Result := FDirTree;
    Exit;
  end;

  i := PosEx(FBasePath, aPath, 1);
  if i <> 0 then
    aPath := Copy(aPath, Length(FBasePath) + 1, Length(aPath));
  if Assigned(FInternalFilter) then
    FInternalFilter.GetNodeFromPath(aPath, bCreateNodes, bLastNodeAsFile);

  if aPath[1] <> PathDelim then
    aPath := PathDelim + aPath;
  if (aPath[Length(aPath)] <> PathDelim) and not bLastNodeAsFile then
    aPath := aPath + PathDelim;
  CurNode := FDirTree;
  NodeNameStart := 2;
  for i := 2 to Length(aPath) do
  begin
    if (aPath[i] = PathDelim) or (Length(aPath) = i) then
    begin
      NameEnd := i - NodeNameStart;
      if (Length(aPath) = i) then Inc(NameEnd);
      NodeName := Copy(aPath, NodeNameStart, NameEnd);
      NodeNameStart := i + 1;
      NextNode := CurNode.Find(NodeName);
      if NextNode = nil then
        if not bCreateNodes then
         Exit
        else
        begin
          NextNode := CurNode.Add(NodeName);
          if (Length(aPath) <> i) or not bLastNodeAsFile then
            AddContainer(NextNode);
        end;
      CurNode := NextNode;
    end;
  end;
  Result := CurNode;
end;

function TfrxCustomIOTransport.GetStream(aFileName: String): TStream;
var
  aNode: TfrxNode;
  fName: String;
begin

  fName := ExtractFileName(aFileName);
  if (aFileName = '') {and (FilterAccess = faRead)} then
    aFileName := FileName;
  aNode := GetNodeFromPath(aFileName, True, True);
  if (aNode = nil) then
    raise Exception.CreateFmt('Unable to parse path : "%s" to Nodes', [aFileName]);
  if (aNode.FObjectData is TStream) and ((aNode.FilterAccess = FFilterAccess) or not FFreeStream) then
    Result := TStream(aNode.FObjectData)
  else
  begin
    if (aNode.FObjectData is TStream) then
      FreeAndNil(aNode.FObjectData);
    Result := DoCreateStream(aFileName, fName);
    if aNode = FDirTree then
      aNode := aNode.Add(aFileName);
    aNode.OriginalName := aFileName;
    aNode.ObjectData := Result;
    aNode.FilterAccess := FFilterAccess;
  end;
end;

function TfrxCustomIOTransport.GetTempFilter: TfrxCustomIOTransport;
begin
  Result := FTempFilter;
  if Assigned(FTempFilter) then Exit;
  FTempFilter := TfrxCustomIOTransport(frxDefaultTempFilterClass.NewInstance);
  FTempFilter.CreateNoRegister;
  FTempFilter.FilterAccess := FilterAccess;
  FTempFilter.CreateTempContainer;
  Result := FTempFilter;
end;

function TfrxCustomIOTransport.OpenFilter: Boolean;
begin
  Result := True;
end;

function TfrxCustomIOTransport.RemoveContainer(Item: TfrxNode): Boolean;
begin
  Result := True;
end;

procedure TfrxCustomIOTransport.SetCurrentContainer(const Value: String);
var
  cItem, CurNode: TfrxNode;
  i, LastDelim: Integer;
  NodeName: String;
begin
  if Length(Value) = 0 then
  begin
    FCurNode := FDirTree;
    Exit;
  end;
  CurNode := FCurNode;
  NodeName := '';
  LastDelim := 1;
  for i := 1 to Length(Value) do
  begin
    if (Value[i] = PathDelim) or (Length(Value) = i) then
    begin
      NodeName := Copy(Value, LastDelim, i - LastDelim);
      if NodeName = '' then CurNode := FDirTree
      else CurNode := CurNode.Find(NodeName);
      if CurNode = nil then Exit;
    end;
  end;
  cItem := FCurNode.Find(Value);
  if cItem <> nil then
    FCurNode := cItem;
end;

procedure TfrxCustomIOTransport.SetInternalFilter(
  const Value: TfrxCustomIOTransport);
begin
  if Assigned(FInternalFilter) then
    FreeAndNil(FInternalFilter);
  FInternalFilter := Value;
end;

procedure TfrxCustomIOTransport.SetTempFilter(const Value: TfrxCustomIOTransport);
begin
  if Value = nil then Exit;
  if Assigned(FTempFilter) then
  begin
    FTempFilter.FreeTempContainer;
    FreeAndNil(FTempFilter);
  end;
  FTempFilter := Value;
end;

procedure TfrxCustomIOTransport.SetVisibility(const Value: TfrxFilterVisibility);
begin
  FVisibility := Value;
end;

{ TfrxIOTransportFile }

function TfrxIOTransportFile.AddContainer(Item: TfrxNode): Boolean;
var
  aPath: String;
begin
  Result := True;
  aPath := '';
  while Item <> nil do
  begin
    if Item.Name <> '' then
      aPath := Item.Name + PathDelim + aPath;
    Item := Item.Parent;
  end;
  if (Length(FBasePath) > 0) and (FBasePath[Length(FBasePath)] <> PathDelim) then
    aPath := PathDelim + aPath;
  if (FilterAccess = faWrite) and not DirectoryExists(FBasePath + aPath) then
    MkDir(FBasePath + aPath);
end;

procedure TfrxIOTransportFile.CloseFilter;
begin
  inherited;
end;

constructor TfrxIOTransportFile.Create(AOwner: TComponent);
begin
  inherited;
  FTempFolderCreated := False;
end;

procedure TfrxIOTransportFile.CreateTempContainer;
begin
  if FTempFolderCreated then Exit;
  FBasePath := GetTempFile;
  SysUtils.DeleteFile(FBasePath);
  CreateContainer('');
  FTempFolderCreated := True;
end;

procedure TfrxIOTransportFile.DeleteFiles;

  procedure fDelete(aNode: TfrxNode);
  var
    i: integer;
    lNode: TfrxNode;
  begin
    for I := 0 to aNode.Count - 1 do
    begin
      lNode := aNode.Items[i];
      if (lNode.FOriginalName <> '') then
        SysUtils.DeleteFile(lNode.FOriginalName)
      else
        fDelete(lNode);
    end;
  end;
begin
  fDelete(FDirTree);
end;

function TfrxIOTransportFile.DoCreateStream(var aFullFilePath: String; aFileName: String): TStream;
begin
  if FFilterAccess = faWrite then
    Result := TFileStream.Create(aFullFilePath, fmCreate)
  else
    Result := TFileStream.Create(aFullFilePath, fmOpenRead or fmShareDenyWrite);
end;

procedure TfrxIOTransportFile.FreeTempContainer;
begin
  if not FTempFolderCreated then Exit;
  CloseAllStreams;
  DeleteFiles;
  DeleteFolder(FBasePath);
  FTempFolderCreated := False;
end;

class function TfrxIOTransportFile.GetDescription: String;
begin
  Result := frxGet(163);
end;

function TfrxIOTransportFile.OpenFilter: Boolean;
begin
  Result := True;
end;

procedure TfrxIOTransportFile.SetVisibility(const Value: TfrxFilterVisibility);
begin
//  inherited;
  FVisibility := [];
end;

{ TfrxCustomExportFilter }

procedure TfrxCustomExportFilter.AfterFinish;
begin
//
end;

procedure TfrxCustomExportFilter.BeforeStart;
begin
  if SlaveExport and (FileName = '') then
  begin
    if Report.FileName <> '' then
      FileName := ChangeFileExt(GetTemporaryFolder + ExtractFileName(Report.FileName), DefaultExt)
    else
      FileName := ChangeFileExt(GetTempFile, DefaultExt);
    IOTransport.BasePath := ExtractFilePath(FileName);
  end;
  if (FileName <> '') and (ExtractFilePath(FileName) = '') and (DefaultPath <> '') then
  begin
    if DefaultPath[Length(DefaultPath)] = PathDelim then
      FileName := DefaultPath + FileName
    else
      FileName := DefaultPath + PathDelim + FileName;
  end;
end;

procedure TfrxCustomExportFilter.BeginClip(Obj: TfrxView);
begin

end;

constructor TfrxCustomExportFilter.Create(AOwner: TComponent);
begin
  inherited;
  if not FNoRegister then
    frxExportFilters.Register(Self);
  FShowDialog := True;
  FUseFileCache := True;
  FDefaultPath := '';
  FShowProgress := True;
  FSlaveExport := False;
  FOverwritePrompt := False;
  FFiles := nil;
  FDefaultIOTransport := nil;
end;

function TfrxCustomExportFilter.CreateDefaultIOTransport: TfrxCustomIOTransport;
begin
  if ShowDialog and Assigned(frxDefaultIODialogTransportClass) and not (SlaveExport or Assigned(Stream)) then
    FDefaultIOTransport := TfrxCustomIOTransport(frxDefaultIODialogTransportClass.NewInstance)
  else
    FDefaultIOTransport := TfrxCustomIOTransport(frxDefaultIOTransportClass.NewInstance);
  FDefaultIOTransport.Create(nil);
  Result := FDefaultIOTransport;
end;

constructor TfrxCustomExportFilter.CreateNoRegister;
begin
  FNoRegister := True;
  Create(nil);
end;

destructor TfrxCustomExportFilter.Destroy;
begin
  if not FNoRegister then
    frxExportFilters.Unregister(Self);
  if FFiles <> nil then
    FFiles.Free;
  if FDefaultIOTransport <> nil then
    FreeAndNil(FDefaultIOTransport);
  inherited;
end;

procedure TfrxCustomExportFilter.DoFinish;
begin
  Finish;
  AfterFinish;
end;

function TfrxCustomExportFilter.DoStart: Boolean;
begin
  BeforeStart;
  Result := Start;
end;

procedure TfrxCustomExportFilter.EndClip;
begin

end;

function TfrxCustomExportFilter.GetDefaultIOTransport: TfrxCustomIOTransport;
begin
  if FDefaultIOTransport = nil then
    FDefaultIOTransport := CreateDefaultIOTransport;
  Result := FDefaultIOTransport;
end;

class function TfrxCustomExportFilter.GetDescription: String;
begin
  Result := '';
end;

function TfrxCustomExportFilter.IsProcessInternal: Boolean;
begin
  Result := True;
end;

procedure TfrxCustomExportFilter.Finish;
begin
//
end;

procedure TfrxCustomExportFilter.FinishPage(Page: TfrxReportPage;
  Index: Integer);
begin
//
end;

procedure TfrxCustomExportFilter.SetDefaultIOTransport(
  const Value: TfrxCustomIOTransport);
begin
  if FDefaultIOTransport <> nil then
    FDefaultIOTransport.Free;
  FDefaultIOTransport := Value;
end;

procedure TfrxCustomExportFilter.SetFileName(const Value: String);
begin
  FName := Value;
  if Assigned(FIOTransport) then
  begin
    FIOTransport.BasePath := ExtractFilePath(FName);
    FIOTransport.FileName := FName;
  end;
end;

procedure TfrxCustomExportFilter.SetShowDialog(const Value: Boolean);
begin
  FShowDialog := Value;
  DefaultIOTransport := nil;
end;

function TfrxCustomExportFilter.ShowModal: TModalResult;
begin
  Result := mrOk;
end;

function TfrxCustomExportFilter.Start: Boolean;
begin
  Result := True;
end;

procedure TfrxCustomExportFilter.StartPage(Page: TfrxReportPage;
  Index: Integer);
begin
//
end;


{ TfrxCustomWizard }

constructor TfrxCustomWizard.Create(AOwner: TComponent);
begin
  inherited;
  FDesigner := TfrxCustomDesigner(AOwner);
  FReport := FDesigner.Report;
end;

class function TfrxCustomWizard.GetDescription: String;
begin
  Result := '';
end;


{ TfrxCustomCompressor }

constructor TfrxCustomCompressor.Create(AOwner: TComponent);
begin
  inherited;
  FOldCompressor := frxCompressorClass;
  frxCompressorClass := TfrxCompressorClass(ClassType);
  FFilter := TfrxSaveToCompressedFilter.Create(nil);
end;

destructor TfrxCustomCompressor.Destroy;
begin
  if Assigned(FFilter) then
    FreeAndNil(FFilter);
  frxCompressorClass := FOldCompressor;
  if FStream <> nil then
    FStream.Free;
  if FTempFile <> '' then
    SysUtils.DeleteFile(FTempFile);
  inherited;
end;

procedure TfrxCustomCompressor.SetIsFR3File(const Value: Boolean);
begin
  FIsFR3File := Value;
  FFilter.IsFR3File := FIsFR3File;
end;

procedure TfrxCustomCompressor.CreateStream;
begin
  if FIsFR3File or not FReport.EngineOptions.UseFileCache then
    FStream := TMemoryStream.Create
  else
  begin
    FTempFile := frxCreateTempFile(FReport.EngineOptions.TempDir);
    FStream := TFileStream.Create(FTempFile, fmCreate);
  end;
end;

{ TfrxCustomCrypter }

constructor TfrxCustomCrypter.Create(AOwner: TComponent);
begin
  inherited;
  frxCrypterClass := TfrxCrypterClass(ClassType);
end;

destructor TfrxCustomCrypter.Destroy;
begin
  if FStream <> nil then
    FStream.Free;
  inherited;
end;

procedure TfrxCustomCrypter.CreateStream;
begin
  FStream := TMemoryStream.Create;
end;


{ TfrxGlobalDataSetList }

constructor TfrxGlobalDataSetList.Create;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  FCriticalSection := TCriticalSection.Create;
{$ENDIF}
  inherited;
end;

destructor TfrxGlobalDataSetList.Destroy;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  FCriticalSection.Free;
  FCriticalSection := nil;
{$ENDIF}
  inherited;
end;

procedure TfrxGlobalDataSetList.Lock;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  if FCriticalSection <> nil then
    FCriticalSection.Enter;
{$ENDIF}
end;

procedure TfrxGlobalDataSetList.Unlock;
begin
{$IFNDEF NO_CRITICAL_SECTION}
  if FCriticalSection <> nil then
    FCriticalSection.Leave;
{$ENDIF}
end;



{$IFDEF FPC}
//procedure RegisterUnitfrxClass;
//begin
//  RegisterComponents('Fast Report 6',[TfrxReport, TfrxUserDataSet]);
//end;

//procedure Register;
//begin
//  RegisterUnit('frxClass',@RegisterUnitfrxClass);
//end;
{$ENDIF}


{ TfrxInPlaceEditor }

procedure TfrxInPlaceEditor.CopyContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType);
begin

end;

constructor TfrxInPlaceEditor.Create(aClassRef: TfrxComponentClass; aOwner: TWinControl);
begin
  FOwner := aOwner;
  FClassRef := aClassRef;
  FOffsetX := 0;
  FOffsetY := 0;
  FScale := 0;
  FComponent := nil;
  FLocked := False;
  FComponents := nil;
  FClipboardObject := nil;
end;

destructor TfrxInPlaceEditor.Destroy;
begin
  if Assigned(FComponent) then
    Component := nil;
  inherited;
end;

procedure TfrxInPlaceEditor.CopyGoupContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType);
begin
  CopyContent(CopyFrom, EventParams, nil, CopyAs);
end;

function TfrxInPlaceEditor.DoCustomDragDrop(Source: TObject; X,
  Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

function TfrxInPlaceEditor.DoCustomDragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

procedure TfrxInPlaceEditor.DoFinishInPlace(Sender: TObject; Refresh, Modified: Boolean);
begin
  if Assigned(OnFinishInPlace) then
  begin
    OnFinishInPlace(Component, Refresh, Modified);
    OnFinishInPlace := nil;
  end;
end;

function TfrxInPlaceEditor.DoMouseDown(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

function TfrxInPlaceEditor.DoMouseMove(X, Y: Integer;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

function TfrxInPlaceEditor.DoMouseUp(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

function TfrxInPlaceEditor.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  Result := False;
end;

procedure TfrxInPlaceEditor.PasteGoupContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType);
begin
 PasteContent(PasteTo, EventParams, Buffer, PasteAs);
end;

procedure TfrxInPlaceEditor.DrawCustomEditor(aCanvas: TCanvas; aRect: TRect);
begin
// empty
end;

procedure TfrxInPlaceEditor.EditInPlace(aParent: TComponent; aRect: TRect);
begin
// empty
end;

function TfrxInPlaceEditor.EditInPlaceDone: Boolean;
begin
// empty
  Result := False;
end;

function TfrxInPlaceEditor.FillData: Boolean;
begin
// empty
  Result := False;
end;

procedure TfrxInPlaceEditor.FinalizeUI(var EventParams: TfrxInteractiveEventsParams);
begin

end;

function TfrxInPlaceEditor.GetActiveRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
end;

function TfrxInPlaceEditor.HasCustomEditor: Boolean;
begin
// empty
  Result := False;
end;

function TfrxInPlaceEditor.HasInPlaceEditor: Boolean;
begin
// empty
  Result := False;
end;

procedure TfrxInPlaceEditor.InitializeUI(var EventParams: TfrxInteractiveEventsParams);
begin

end;

function TfrxInPlaceEditor.IsPasteAvailable(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType): Boolean;
begin
  Result := False;
end;

function TfrxInPlaceEditor.DefaultContentType: TfrxCopyPasteType;
begin
  Result := cptDefault;
end;

procedure TfrxInPlaceEditor.PasteContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType);
begin

end;

procedure TfrxInPlaceEditor.SetComponent(const Value: TfrxComponent);
begin
  if (Value = FComponent)then Exit;
  if ((Value <> nil) and FLocked) then
  begin
    Value.FComponentEditors := nil;
    Exit;
  end;
  if Assigned(FComponent) then
  begin
    EditInPlaceDone;
    FComponent.FComponentEditors := nil;
  end;
  FComponent := Value;
  if Value <> nil then
    Value.FComponentEditors := frxGetInPlaceEditor(FEditors, Value);
end;

procedure TfrxInPlaceEditor.SetOffset(aOffsetX, aOffsetY, aScale: Extended);
begin
  FOffsetX := aOffsetX;
  FOffsetY := aOffsetY;
  FScale := aScale;
end;

function frxRegEditorsClasses: TfrxComponentEditorsClasses;
begin
  if RegEditorsClasses = nil then
    RegEditorsClasses := TfrxComponentEditorsClasses.Create;
  Result := RegEditorsClasses;
end;

function frxGetInPlaceEditor(aList: TfrxComponentEditorsList; aComponent: TfrxComponent): TfrxComponentEditorsManager;
var
  i: Integer;
begin
  Result := nil;
  i := aList.IndexOf(aComponent.ClassName);
  if (i <> -1) and (aList.Editors[i].FEditorsGlasses.Count > 0) then
    Result := aList.Editors[i];
end;

{ TfrxCustomPreview }

constructor TfrxCustomPreview.Create(AOwner: TComponent);
begin
  inherited;
  FInPlaceditorsList := nil;
  FSelectionList := TfrxSelectedObjectsList.Create;
end;

destructor TfrxCustomPreview.Destroy;
begin
  if Assigned(FInPlaceditorsList) then
    FreeAndNil(FInPlaceditorsList);
  FreeAndNil(FSelectionList);
  inherited;
end;

procedure TfrxCustomPreview.DoFinishInPlace(Sender: TObject; Refresh,
  Modified: Boolean);
begin
  if Modified then
    FPreviewPages.ModifyObject(TfrxComponent(Sender));
end;

procedure TfrxCustomPreview.SetDefaultEventParams(
  var EventParams: TfrxInteractiveEventsParams);
begin
  EventParams.EventSender := esPreview;
  EventParams.Refresh := False;
  EventParams.PopupVisible := False;
  EventParams.EditorsList := FInPlaceditorsList;
  EventParams.OnFinish := DoFinishInPlace;
  EventParams.OffsetX := 0;
  EventParams.OffsetY := 0;
  EventParams.Scale := 1;
  EventParams.Sender := Self;
  EventParams.FireParentEvent := False;
  EventParams.Modified := False;
  EventParams.GridAlign := False;
  EventParams.GridType := gtNone;
  EventParams.GridX := 0;
  EventParams.GridY := 0;
  EventParams.SelectionList := FSelectionList;
  if Assigned(Report) then
    EventParams.EditRestricted := not Report.PreviewOptions.AllowPreviewEdit
  else
    EventParams.EditRestricted := False;
end;

procedure TfrxCustomPreview.InternalCopy;
var
  EditorsManager: TfrxComponentEditorsManager;
  EventParams: TfrxInteractiveEventsParams;
begin

  if (FSelectionList.Count = 0) or not(pbCopy in Report.PreviewOptions.Buttons) then Exit;
  EditorsManager := frxGetInPlaceEditor(FInPlaceditorsList, TfrxComponent(FSelectionList[0]));
  if Assigned(EditorsManager) then
  begin
    SetDefaultEventParams(EventParams);
    EditorsManager.CopyContent(TfrxComponent(FSelectionList[0]), EventParams, nil, cptDefault);
  end;
end;

procedure TfrxCustomPreview.InternalPaste;
var
  EditorsManager: TfrxComponentEditorsManager;
  EventParams: TfrxInteractiveEventsParams;
begin
  if (FSelectionList.Count = 0) or not(pbPaste in Report.PreviewOptions.Buttons) then Exit;
  EditorsManager := frxGetInPlaceEditor(FInPlaceditorsList, TfrxComponent(FSelectionList[0]));
  if Assigned(EditorsManager) then
  begin
    SetDefaultEventParams(EventParams);
    EditorsManager.PasteContent(TfrxComponent(FSelectionList[0]), EventParams, nil);
  end;
  if EventParams.Refresh then Invalidate;
end;

function TfrxCustomPreview.InternalIsPasteAvailable: Boolean;
var
  EditorsManager: TfrxComponentEditorsManager;
  EventParams: TfrxInteractiveEventsParams;
begin
  Result := False;
  if (FSelectionList.Count = 0) or not(pbPaste in Report.PreviewOptions.Buttons) then
    Exit;
  EditorsManager := frxGetInPlaceEditor(FInPlaceditorsList, TfrxComponent(FSelectionList[0]));
  if Assigned(EditorsManager) then
  begin
    SetDefaultEventParams(EventParams);
    Result := EditorsManager.IsPasteAvailable(TfrxComponent(FSelectionList[0]), EventParams);
  end;
end;

{ TfrxFieldsStringList }
{
function TfrxFieldsStringList.GetField(Index: Integer): TfrxFileld;
begin
  Result := GetObject(Index) as TfrxFileld;
end;

procedure TfrxFieldsStringList.PutField(Index: Integer;
  const Value: TfrxFileld);
begin
  PutObject(Index, Value);
end;
}
{ TfrxSelectedObjectsList }

procedure TfrxSelectedObjectsList.ClearInspectorList;
begin
  FInspSelectedObjects.Clear;
end;

constructor TfrxSelectedObjectsList.Create;
begin
  inherited;
  FInspSelectedObjects := TList.Create;
end;

destructor TfrxSelectedObjectsList.Destroy;
begin
  inherited;
  FreeAndNil(FInspSelectedObjects);
end;

procedure TfrxSelectedObjectsList.Notify(Ptr: Pointer;
  Action: TListNotification);
begin
  { sync lists }
  if Action = lnAdded then
  begin
    // designer works only with TfrxComponent
    if not (TObject(Ptr) is TfrxComponent) then
      Remove(Ptr);
    //object inspector can edit any TPresistent acenstor
    if  TObject(Ptr) is TPersistent then
      FInspSelectedObjects.Add(Ptr);
    if (TObject(Ptr) is TfrxComponent) and not TfrxComponent(Ptr).IsSelected then
    begin
      { back compat , for objects with Parent = nil like CrossTab cells }
      if TfrxComponent(Ptr).Report = nil then
        TfrxComponent(Ptr).FSelectList := Self
      else
        TfrxComponent(Ptr).IsSelected := True;
    end;
    FUpdated := True;
  end;
  if Action = lnDeleted then
  begin
    if TObject(Ptr) is TfrxComponent then
      TfrxComponent(Ptr).IsSelected := False;
    if Count = 0 then
      FInspSelectedObjects.Clear
    else
      FInspSelectedObjects.Remove(Ptr);
    FUpdated := True;
  end;
end;

{ TfrxObjectsNotifyList }

procedure TfrxObjectsNotifyList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  If Assigned(FOnNotifyList) then
    FOnNotifyList(Ptr, Action);
end;

{ TfrxPage }

constructor TfrxPage.Create(AOwner: TComponent);
begin
  inherited;
  frComponentStyle := frComponentStyle + [csAcceptsFrxComponents];
end;


procedure TfrxPage.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  if Assigned(FComponentEditors) then
    FComponentEditors.DrawCustomEditor(Canvas, Rect(Round(OffsetX * ScaleX), Round(OffsetY * ScaleY), Round((Width + OffsetX) * ScaleX), Round((Height + OffsetY) * ScaleY)));
end;

{ TfrxSaveToCompressedFilter }

constructor TfrxSaveToCompressedFilter.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FilterString := GetDescription;
  FVisibility := [fvDesignerFileFilter, fvPreviewFileFilter];
  FDefaultExt := '.fp3';
end;

class function TfrxSaveToCompressedFilter.GetDescription: String;
begin
  Result := frxResources.Get('dsComprRepFilter')
end;

function TfrxSaveToCompressedFilter.GetFilterString: String;
begin
  if FCreatedFrom <> fvPreview then
    FilterString := frxResources.Get('dsComprRepFilter')
  else
    FilterString := frxResources.Get('clComprPreparedRepFilter');
  Result := Inherited GetFilterString;
end;

function TfrxSaveToCompressedFilter.OpenFilter: Boolean;
begin
  Report.ReportOptions.Compressed := True;
  Result := True;
end;

procedure TfrxSaveToCompressedFilter.SetIsFR3File(const Value: Boolean);
begin
  FIsFR3File := Value;
  if IsFR3File then
    FilterString := frxResources.Get('dsComprRepFilter')
  else
    FilterString := frxResources.Get('clComprPreparedRepFilter');
end;

{ TfrxNode }

function TfrxNode.Add(Name: String; aObject: TObject): TfrxNode;
var
  aRoot: TfrxNode;
begin
  Result := TfrxNode.Create;
  Result.Name := Name;
  Result.FParent := Self;
  Result.FObjectData := aObject;
  FNodesList.AddObject(Name, Result);

  if aObject <> nil then
    UpdateFilesCount(1);

  aRoot := GetRoot;
  if (aRoot <> nil) and Assigned(aRoot.FOnAddItem) then
    aRoot.OnAddItem(Name, False, aObject);
end;

procedure TfrxNode.Clear;
var
  i: Integer;
begin
  for i := 0 to FNodesList.Count - 1 do
  begin
    // don't call RemoveNode for childs
    TfrxNode(FNodesList.Objects[i]).FParent := nil;
    TfrxNode(FNodesList.Objects[i]).Free;
  end;
  if Assigned(FObjectData) and FOwnObject then
    FreeAndNil(FObjectData);
  FNodesList.Clear;
  FName := '';
end;

function TfrxNode.Count: Integer;
begin
  Result := FNodesList.Count;
end;

constructor TfrxNode.Create;
begin
  FNodesList := TStringList.Create;
  FNodesList.Sorted := True;
  FParent := nil;
  FOwnObject := True;
  FFilterAccess := faWrite;
  FFilesCount := 0;
end;

destructor TfrxNode.Destroy;
begin
  FParent := nil;
  if FParent <> nil then
    FParent.RemoveNode(Self);
  Clear;
  FreeAndNil(FNodesList);
  inherited;
end;

function TfrxNode.Find(aObject: TObject; SearchInChilds: Boolean): TfrxNode;
var
  i: Integer;
  aNode: TfrxNode;
begin
  Result := nil;
  for i := 0 to FNodesList.Count - 1 do
  begin
    aNode := TfrxNode(FNodesList.Objects[i]);
    if aNode.ObjectData = aObject then
      Result := aNode;
    if SearchInChilds and (Result = nil) then
      Result := TfrxNode(FNodesList.Objects[i]).Find(aObject, SearchInChilds);
    if Result <> nil then
      Exit;
  end;
end;

function TfrxNode.Find(Name: String; SearchInChilds: Boolean): TfrxNode;
var
  Index, i: Integer;
begin
  Result := nil;
  Index := FNodesList.IndexOf(Name);
  if Index <> -1 then
    Result := TfrxNode(FNodesList.Objects[Index]);
  if (Result = nil) and SearchInChilds then
    for i := 0 to FNodesList.Count - 1 do
    begin
      Result := TfrxNode(FNodesList.Objects[i]).Find(Name, SearchInChilds);
      if Result <> nil then
        break;
    end;
end;

function TfrxNode.GetNode(Index: Integer): TfrxNode;
begin
  Result := TfrxNode(FNodesList.Objects[Index]);
end;

function TfrxNode.GetRoot: TfrxNode;
begin
  Result := Self;
  while (Result.Parent <> nil) do
    Result := Result.Parent;
end;

procedure TfrxNode.RemoveNode(aNode: TfrxNode);
var
  Index: Integer;
  p: TfrxNode;
begin
  p := Self.Parent;

  Index := FNodesList.IndexOfObject(aNode);
  if Index <> -1 then
  begin
    FNodesList.Delete(Index);
    while (p <> nil) do
    begin
      Dec(p.FFilesCount, aNode.FFilesCount);
      p := p.Parent;
    end;
  end;
end;

procedure TfrxNode.SetName(const Value: String);
var
  aRoot: TfrxNode;
begin
  if FName = Value then Exit;

  aRoot := GetRoot;
  if (aRoot <> nil) and Assigned(aRoot.FOnAddItem) and Assigned(aRoot.FOnRemoveItem) then
  begin
    aRoot.OnRemoveItem(FName);
    aRoot.OnAddItem(Value, False, FObjectData);
  end;
  FName := Value;
end;

procedure TfrxNode.SetObjectData(const Value: TObject);
var
  aRoot: TfrxNode;
begin
  if FObjectData = Value then Exit;

  aRoot := GetRoot;
  if (aRoot <> nil) and Assigned(aRoot.FOnAddItem) and Assigned(aRoot.FOnRemoveItem) then
    if Value = nil then
      aRoot.OnRemoveItem(FName, True)
    else if FObjectData = nil then
    begin
      aRoot.OnAddItem(FName, True, Value);
      UpdateFilesCount(1);
    end
    else
      aRoot.OnAddItem(FName, False, Value);
  FObjectData := Value;
end;

procedure TfrxNode.SetOriginalName(const Value: String);
begin
  if (FOriginalName = '') and (Value <> '') then
    UpdateFilesCount(1);
  FOriginalName := Value;
end;

procedure TfrxNode.UpdateFilesCount(Count: Integer);
var
  pNode: TfrxNode;
begin
  pNode := Self;

  while (pNode <> nil) do
  begin
    Inc(pNode.FFilesCount, Count);
    pNode := pNode.Parent;
  end;

end;

{ TfrxComponentEditorsManager }

procedure TfrxComponentEditorsManager.CopyContent(CopyFrom: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; CopyAs: TfrxCopyPasteType);
var
  i: Integer;
begin
  // when EventParams.SelectionList assigned call method to process group of objects
  for i := 0 to FEditorsGlasses.Count - 1 do
    if Assigned(EventParams.SelectionList) and (EventParams.SelectionList.Count > 1) then
      TfrxInPlaceEditor(FEditorsGlasses[i]).CopyGoupContent(CopyFrom, EventParams, Buffer, CopyAs)
    else
    begin
      if Assigned(CopyFrom) and ((rfDontEditInPreview in CopyFrom.Restrictions) or (EventParams.EditRestricted)) then Exit;
      if CopyAs = cptDefault then
        CopyAs := TfrxInPlaceEditor(FEditorsGlasses[i]).DefaultContentType;
      TfrxInPlaceEditor(FEditorsGlasses[i]).CopyContent(CopyFrom, EventParams, Buffer, CopyAs);
    end;
end;

constructor TfrxComponentEditorsManager.Create;
begin
  FEditorsGlasses := TList.Create;
end;

destructor TfrxComponentEditorsManager.Destroy;
begin
  Component := nil;
  FreeAndNil(FEditorsGlasses);
end;

function TfrxComponentEditorsManager.DoCustomDragDrop(Source: TObject; X,
  Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    Result := TfrxInPlaceEditor(FEditorsGlasses[i]).DoCustomDragDrop(Source, X, Y, EventParams);
    if Result then break;
  end;
end;

function TfrxComponentEditorsManager.DoCustomDragOver(Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    Result := TfrxInPlaceEditor(FEditorsGlasses[i]).DoCustomDragOver(Source, X, Y, State, Accept, EventParams);
    if Result then break;
  end;
end;

function TfrxComponentEditorsManager.DoMouseDown(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    Result := TfrxInPlaceEditor(FEditorsGlasses[i]).DoMouseDown(X, Y, Button, Shift, EventParams);
    if Result then break;
  end;
end;

function TfrxComponentEditorsManager.DoMouseMove(X, Y: Integer;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    Result := TfrxInPlaceEditor(FEditorsGlasses[i]).DoMouseMove(X, Y, Shift, EventParams);
    if Result then break;
  end;
end;

function TfrxComponentEditorsManager.DoMouseUp(X, Y: Integer;
  Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    Result := TfrxInPlaceEditor(FEditorsGlasses[i]).DoMouseUp(X, Y, Button, Shift, EventParams);
    if Result then break;
  end;
end;

function TfrxComponentEditorsManager.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    Result := TfrxInPlaceEditor(FEditorsGlasses[i]).DoMouseWheel(Shift, WheelDelta, MousePos, EventParams);
    if Result then break;
  end;
end;

procedure TfrxComponentEditorsManager.DrawCustomEditor(aCanvas: TCanvas;
  aRect: TRect);
var
  i: Integer;
begin
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    TfrxInPlaceEditor(FEditorsGlasses[i]).DrawCustomEditor(aCanvas, aRect);
  //  if Result then break;
  end;
end;

function TfrxComponentEditorsManager.EditorsActiveRects(
  aComponent: TfrxComponent): TfrxRectArray;
var
  i: Integer;
begin
  SetLength(Result, FEditorsGlasses.Count);
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    Result[i] := TfrxInPlaceEditor(FEditorsGlasses[i]).GetActiveRect;
    Result[i].Top := Round(aComponent.AbsTop) + Result[i].Top;
    Result[i].Left := Round(aComponent.AbsLeft) + Result[i].Left;
    Result[i].Right := Round(aComponent.AbsLeft) + Result[i].Right;
    Result[i].Bottom := Round(aComponent.AbsTop) + Result[i].Bottom;
  end;
end;

procedure TfrxComponentEditorsManager.FinalizeUI(var EventParams: TfrxInteractiveEventsParams);
var
  i: Integer;
begin
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    TfrxInPlaceEditor(FEditorsGlasses[i]).FinalizeUI(EventParams);
    //TfrxInPlaceEditor(FEditorsGlasses[i]).FComponents := nil;
  //  if Result then break;
  end;
end;

function TfrxComponentEditorsManager.GetComponent: TfrxComponent;
begin
  Result := nil;
  if FEditorsGlasses.Count > 0 then
    Result := TfrxInPlaceEditor(FEditorsGlasses[0]).Component;
end;

procedure TfrxComponentEditorsManager.InitializeUI(var EventParams: TfrxInteractiveEventsParams);
var
  i: Integer;
begin
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).SetOffset(FOffsetX, FOffsetY, FScale);
    TfrxInPlaceEditor(FEditorsGlasses[i]).InitializeUI(EventParams);
    TfrxInPlaceEditor(FEditorsGlasses[i]).FComponents := EventParams.SelectionList;
  //  if Result then break;
  end;
end;

function TfrxComponentEditorsManager.IsContain(ObjectRect: TRect; X, Y: Extended): Boolean;
var
  i: Integer;
  r: TRect;
  w, h : Integer;
begin
  Result := False;
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    r := TfrxInPlaceEditor(FEditorsGlasses[i]).GetActiveRect;
    w := r.Right - r.Left;
    h := r.Bottom - r.Top;
    if (w = 0) or (h = 0) then continue;
    r.Left := ObjectRect.Left + r.Left;
    r.Top := ObjectRect.Top + r.Top;
    r.Right := r.Left + w;
    r.Bottom := r.Top + h;
    Result := (X >= r.Left) and
    (X <= r.Right) and
    (Y >= r.Top) and
    (Y <= r.Bottom);
    if Result then
    begin
      break;
      //w := r.Right - r.Left;
    end;
  end;
end;

function TfrxComponentEditorsManager.IsPasteAvailable(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; PasteAs: TfrxCopyPasteType): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Assigned(PasteTo) and ((rfDontEditInPreview in PasteTo.Restrictions) or (EventParams.EditRestricted)) then Exit;
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    Result := TfrxInPlaceEditor(FEditorsGlasses[i]).IsPasteAvailable(PasteTo, EventParams, PasteAs);
    if Result then break;
  end;
end;

procedure TfrxComponentEditorsManager.PasteContent(PasteTo: TfrxComponent;
  var EventParams: TfrxInteractiveEventsParams; Buffer: TStream; PasteAs: TfrxCopyPasteType);
var
  i: Integer;
begin
  for i := 0 to FEditorsGlasses.Count - 1 do
    if Assigned(EventParams.SelectionList) and (EventParams.SelectionList.Count > 1) then
      TfrxInPlaceEditor(FEditorsGlasses[i]).PasteGoupContent(PasteTo, EventParams, Buffer, PasteAs)
    else
    begin
      if Assigned(PasteTo) and ((rfDontEditInPreview in PasteTo.Restrictions) or (EventParams.EditRestricted)) then Exit;
      TfrxInPlaceEditor(FEditorsGlasses[i]).PasteContent(PasteTo, EventParams, Buffer, PasteAs);
    end;
end;

procedure TfrxComponentEditorsManager.SetClipboardObject(const aObject: TPersistent);
var
  i: Integer;
begin
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).FClipboardObject := aObject;
  //  if Result then break;
  end;
end;

procedure TfrxComponentEditorsManager.SetComponent(const Value: TfrxComponent);
var
  i: Integer;
begin
  for i := 0 to FEditorsGlasses.Count - 1 do
  begin
    TfrxInPlaceEditor(FEditorsGlasses[i]).Component := Value;
  //  if Result then break;
  end;
end;

procedure TfrxComponentEditorsManager.SetOffset(aOffsetX, aOffsetY,
  aScale: Extended);
begin
  FOffsetX := aOffsetX;
  FOffsetY := aOffsetY;
  FScale := aScale;
end;

{ TfrxComponentEditorsList }

constructor TfrxComponentEditorsList.Create;
begin
  FEditorsInstances := TList.Create;
end;

procedure TfrxComponentEditorsList.CreateInstanceFromItem(
  aItem: TfrxComponentEditorsRegItem; aOwner: TWinControl; aVisibility: TfrxComponentEditorVisibilityState);
var
  lItem: TfrxComponentEditorsManager;
  i, Index: Integer;
  aClass: TfrxComponentClass;
  aObject: TfrxInPlaceEditor;
begin
  if aItem = nil then Exit;
  lItem := TfrxComponentEditorsManager.Create;
  lItem.FComponentClass := aItem.FComponentClass;
  for i := 0 to aItem.FEditorsGlasses.Count - 1 do
  begin
    if not(aVisibility in TfrxComponentEditorVisibility(Byte(aItem.FEditorsVisibility[i]))) then continue;
    aClass := TfrxComponentClass(aItem.FEditorsGlasses[i]);
    Index := FEditorsInstances.IndexOf(aClass);
    if Index = -1 then
    begin
      aObject := TfrxInPlaceEditor(aClass.NewInstance);
      aObject.Create(aClass, aOwner);
      FEditorsInstances.Add(aObject);
      aObject.FEditors := Self;
    end
    else
      aObject := TfrxInPlaceEditor(FEditorsInstances[Index]);
    lItem.FEditorsGlasses.Add(aObject);
  end;
  AddObject(lItem.FComponentClass.ClassName, lItem);
end;

destructor TfrxComponentEditorsList.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    TObject(Objects[i]).Free;
  for i := 0 to FEditorsInstances.Count - 1 do
    TObject(FEditorsInstances[i]).Free;
  FreeAndNil(FEditorsInstances);
  inherited;
end;

function TfrxComponentEditorsList.GetEditors(
  Index: Integer): TfrxComponentEditorsManager;
begin
  Result := TfrxComponentEditorsManager(Objects[Index]);
end;

procedure TfrxComponentEditorsList.PutEditors(Index: Integer;
  const Value: TfrxComponentEditorsManager);
begin
  Objects[Index] := Value;
end;

{ TfrxComponentEditorsClasses }

function TfrxComponentEditorsClasses.CreateEditorsInstances(
  aVisibility: TfrxComponentEditorVisibilityState; aOwner: TWinControl): TfrxComponentEditorsList;
var
  i: Integer;
begin
  Result := TfrxComponentEditorsList.Create;
  for i := 0 to Count - 1 do
    Result.CreateInstanceFromItem(EditorsClasses[i], aOwner, aVisibility);
end;

destructor TfrxComponentEditorsClasses.Destroy;
var
  I: Integer;
begin
  for i := 0 to Count - 1 do
    TObject(Objects[i]).Free;
  inherited;
end;

function TfrxComponentEditorsClasses.GetEditors(
  Index: Integer): TfrxComponentEditorsRegItem;
begin
  Result := TfrxComponentEditorsRegItem(Objects[Index]);
end;

procedure TfrxComponentEditorsClasses.LoadFromIni(IniFile: TCustomIniFile);
var
  i, j: Integer;
  sName: String;
  aList: TList;
begin
  for i := 0 to Count - 1 do
  begin
    sName := EditorsClasses[i].FComponentClass.ClassName;
    aList := EditorsClasses[i].FEditorsGlasses;
    for j := 0 to aList.Count - 1 do
      EditorsClasses[i].FEditorsVisibility[j] := TObject(IniFile.ReadInteger(sName, TfrxInPlaceEditorClass(aList[j]).ClassName, frxInteger(EditorsClasses[i].FEditorsVisibility[j])));    end;
end;

procedure TfrxComponentEditorsClasses.PutEditors(Index: Integer;
  const Value: TfrxComponentEditorsRegItem);
begin
  Objects[Index] := Value;
end;

procedure TfrxComponentEditorsClasses.Register(ComponentClass
  : TfrxComponentClass; ComponentEditors: array of TfrxInPlaceEditorClass;
  EditorsVisibility: array of TfrxComponentEditorVisibility);
var
  Item: TfrxComponentEditorsRegItem;
  i, vCount: Integer;
  defVisibility: TfrxComponentEditorVisibility;
begin
  defVisibility := [evPreview, evDesigner];
  if High(ComponentEditors) - Low(ComponentEditors) < 0 then Exit;

  i := Indexof(ComponentClass.ClassName);

  if i = -1 then
  begin
    Item := TfrxComponentEditorsRegItem.Create;
    Item.FComponentClass := ComponentClass;
    AddObject(ComponentClass.ClassName, Item);
  end
  else
    Item := TfrxComponentEditorsRegItem(Objects[i]);
  vCount := High(EditorsVisibility);
  for i := Low(ComponentEditors) to High(ComponentEditors) do
  begin
    Item.FEditorsGlasses.Add(ComponentEditors[i]);
    if vCount >= i then
      Item.FEditorsVisibility.Add(Pointer(Byte(EditorsVisibility[i])))
    else
      Item.FEditorsVisibility.Add(Pointer(Byte(defVisibility)));
  end;
end;

procedure TfrxComponentEditorsClasses.SaveToIni(IniFile: TCustomIniFile);
var
  i, j: Integer;
  sName: String;
  aList: TList;
begin
  for i := 0 to Count - 1 do
  begin
    sName := EditorsClasses[i].FComponentClass.ClassName;
    aList := EditorsClasses[i].FEditorsGlasses;
    for j := 0 to aList.Count - 1 do
      IniFile.WriteInteger(sName, TfrxInPlaceEditorClass(aList[j]).ClassName, frxInteger(EditorsClasses[i].FEditorsVisibility[j]));
  end;
end;

procedure TfrxComponentEditorsClasses.UnRegister(
  ComponentClass: TfrxComponentClass);
var
  Index: Integer;
begin
  Index := IndexOf(ComponentClass.ClassName);
  if Index = -1 then Exit;
  EditorsClasses[Index].Free;
  Delete(Index);
end;

procedure TfrxComponentEditorsClasses.UnRegisterEditor(
  EditroClass: TfrxInPlaceEditorClass);
var
  i, j: Integer;
  EList: TList;
begin
  for i := 0 to Count - 1 do
  begin
    EList := EditorsClasses[i].FEditorsGlasses;
    j := 0;
    while j < EList.Count do
      if EList[j] = {$IFDEF FPC}Pointer(EditroClass){$ELSE}EditroClass{$ENDIF} then
        EList.Delete(j)
      else Inc(j);
  end;
end;

{ TfrxComponentEditorsRegItem }

constructor TfrxComponentEditorsRegItem.Create;
begin
  FEditorsGlasses := TList.Create;
  FEditorsVisibility := TList.Create;
end;

destructor TfrxComponentEditorsRegItem.Destroy;
begin
  FreeAndNil(FEditorsGlasses);
  FreeAndNil(FEditorsVisibility);
end;

{ TfrxPostProcessor }

function TfrxPostProcessor.Add(const BandName: String; const Name: String; const Content: WideString; ProcessMode: TfrxProcessAtMode; aComponent: TfrxComponent; bSupressed: Boolean; bEmpty: Boolean): Integer;
var
  MacroItem: TfrxMacrosItem;
  Index, i: Integer;
begin
//  if Band is TfrxGroupHeader then
//    Inc(FGroupLevel);

  Index := FMacroses.IndexOf(Name);
  if Index = - 1 then
  begin
    MacroItem := TfrxMacrosItem.Create;
    MacroItem.FProcessAt := ProcessMode;
    MacroItem.FBaseComponent := aComponent;
    MacroItem.FGroupLevel := FGroupLevel;
    MacroItem.FDataLevel := FDataLevel;
    FMacroses.AddObject(Name, MacroItem);
    MacroItem.FParent := Self;
  end
  else
    MacroItem := TfrxMacrosItem(FMacroses.Objects[Index]);

  if (BandName <> '') and (MacroItem.FBandName = '') then
    MacroItem.FBandName := BandName;

  Index := MacroItem.FItems.Count;
  i := 0;
  if MacroItem.FProcessAt = paDefault then
    i := 1;

  Result := MacroItem.AddObject(Content, TObject(i), bSupressed);
  if (Index < MacroItem.FItems.Count) and bEmpty then
    MacroItem.FItems[MacroItem.FItems.Count - 1] := '';


//  FProcessList.Remove(MacroItem);
  if FProcessList.Count > 0 then
    if FProcessList[FProcessList.Count - 1] = MacroItem then Exit;
  if (MacroItem.FProcessAt <> paDefault) and (Index < MacroItem.FItems.Count) then
    FProcessList.Add(MacroItem);
end;

//procedure TfrxPostProcessor.AddFromComponent(aComponent: TfrxComponent);
//var
//  Index: Integer;
//  m: TfrxCustomMemoView;
//  b: TfrxBand;
//  s: WideString;
//begin
//  if (aComponent is TfrxCustomMemoView) then
//  begin
//    b := aComponent.Parent as TfrxBand;
//    m := TfrxCustomMemoView(aComponent);
//    s := m.Text;
//            if (Length(s) >= 2) and
//          (s[Length(s) - 1] = #13) and (s[Length(s)] = #10) then
//            Delete(s, Length(s) - 1, 2);
//
//        {$IFDEF UNIX} // delete LineEnding
//        if (Length(s) >= 1) and
//          (s[Length(s)] = #10) then
//            Delete(s, Length(s), 1);
//        {$ENDIF}
//
//
//
//
//    Index := Add(b, m.Name, s, m.Processing.ProcessAt, aComponent, ((m.Processing.ProcessAt <> paDefault) or (m.Duplicates <> dmShow)) and Assigned(b));
//    if Index <> -1 then
//      m.Text := IntToStr(Index);
//  end;
//end;

procedure TfrxPostProcessor.Clear;
var
  i: Integer;
begin
  for i := 0 to FMacroses.Count - 1 do
    FMacroses.Objects[i].Free;
  FMacroses.Clear;
  FProcessList.Clear;
  FGroupLevel := 0;
  FDataLevel := 0;
end;

constructor TfrxPostProcessor.Create;
begin
  FMacroses := TStringList.Create;
  TStringList(FMacroses).Sorted := True;
  FBands := TStringList.Create;
  TStringList(FBands).Sorted := True;
  FProcessList := TList.Create;
end;

destructor TfrxPostProcessor.Destroy;
begin
  Clear;
  FreeAndNil(FBands);
  FreeAndNil(FMacroses);
  FreeAndNil(FProcessList);
  inherited;
end;

procedure TfrxPostProcessor.EnterData;
begin
  Inc(FDataLevel);
end;

procedure TfrxPostProcessor.EnterGroup;
begin
  Inc(FGroupLevel);
end;

function TfrxPostProcessor.GetMacroList(
  const MacroName: String): TWideStrings;
var
  Index: Integer;
begin
  Result := nil;
  Index := FMacroses.IndexOf(MacroName);
  if Index <> -1 then
    Result := TfrxMacrosItem(FMacroses.Objects[Index]).FItems;
end;

function TfrxPostProcessor.GetValue(const MacroIndex,
  MacroLine: Integer): WideString;
begin

end;

procedure TfrxPostProcessor.LeaveData;
begin
  Dec(FDataLevel);
  if FDataLevel < 0 then
    FDataLevel := 0;
end;

procedure TfrxPostProcessor.LeaveGroup;
begin
  Dec(FGroupLevel);
  if FGroupLevel < 0 then
    FGroupLevel := 0;
end;

procedure TfrxPostProcessor.LoadFromXML(Item: TfrxXMLItem);
var
  i, j: Integer;
  MacroItem: TfrxMacrosItem;
begin
  if Item = nil then Exit;
  for i := 0 to Item.Count - 1 do
  begin
    MacroItem := TfrxMacrosItem.Create;
    FMacroses.AddObject(Item[i].Name, MacroItem);
    for j := 0 to Item[i].Count - 1 do
{$IFDEF DELPHI12}
      MacroItem.FItems.AddObject(frxXMLToStr(Item[i].Items[j].Prop['cnt']), TObject(1));
{$ELSE}
      MacroItem.FItems.AddObject(frxXMLToStr(UTF8Decode(Item[i].Items[j].Prop['cnt'])), TObject(1));
{$ENDIF}
  end;
  Item.Clear;
end;

function TfrxPostProcessor.LoadValue(aComponent: TfrxComponent): Boolean;
var
  Index: Integer;
begin
  Result := False;
  if aComponent.Name = '' then Exit;
  Index := FMacroses.IndexOf(aComponent.Name);
  if (Index <> -1) and (aComponent is TfrxView) then
    Result := TfrxView(aComponent).LoadContentFromDictionary(nil, TfrxMacrosItem(FMacroses.Objects[Index]));
  if Result then aComponent.Free;
end;

procedure TfrxPostProcessor.ProcessExpressions(aReport: TfrxReport;
  ABand: TfrxBand; ProcessMode: TfrxProcessAtMode);
var
  i, gl: Integer;
  Item: TfrxMacrosItem;
  bCheckLevel: Boolean;
begin
  i := 0;
  FProcessing := True;
  while (i < FProcessList.Count) do
  begin
    Item := TfrxMacrosItem(FProcessList[i]);
    gl := TfrxView(Item.FBaseComponent).Processing.GroupLevel;
    { processes groups and data levels separately }
    case ProcessMode of
      paGroupFinished:
        bCheckLevel := ((gl = FGroupLevel) or ((gl = 0) and (Item.FGroupLevel = FGroupLevel)));
      paDataFinished:
        bCheckLevel := (Item.FDataLevel = FDataLevel);
      else
        bCheckLevel := True;
    end;
    if (Item.FProcessAt <> paDefault) and (ProcessMode = Item.FProcessAt) and bCheckLevel then
    begin
      //Index := Item.FItems.Count - 1;
      TfrxView(Item.FBaseComponent).ProcessDictionary(Item, aReport, Self);
      FProcessList.Remove(Item);
      Dec(i);
    end;
    Inc(i);
  end;
  if ProcessMode = paGroupFinished then
    LeaveGroup;
  FProcessing := False;
end;

procedure TfrxPostProcessor.ProcessObject(AReport: TfrxReport; aComponent: TfrxComponent);
var
  i: Integer;
  Item: TfrxMacrosItem;
begin
  i := 0;
  while (i < FProcessList.Count) do
  begin
    Item := TfrxMacrosItem(FProcessList[i]);
    if (Item.FProcessAt <> paDefault) and (Item.FBaseComponent = aComponent) then
    begin
      FProcessing := True;
      try
        TfrxView(Item.FBaseComponent).ProcessDictionary(Item, aReport, Self);
      finally
        FProcessing := False;
      end;
      FProcessList.Remove(Item);
      Break;
    end;
    Inc(i);
  end;
end;

procedure TfrxPostProcessor.ResetDuplicates(const BandName: String);
var
  I: Integer;
begin
  for I := 0 to FMacroses.Count -1 do
    if (TfrxMacrosItem(FMacroses.Objects[I]).FBandName = BandName) or (BandName = '') then
      TfrxMacrosItem(FMacroses.Objects[I]).FNeedReset := True;
end;

procedure TfrxPostProcessor.ResetSuppressed;
var
  I: Integer;
begin
  for I := 0 to FMacroses.Count -1 do
  begin
    TfrxMacrosItem(FMacroses.Objects[I]).FLastIndex := -1;
    TfrxMacrosItem(FMacroses.Objects[I]).FComponent := nil;
  end;
end;

procedure TfrxPostProcessor.SaveToXML(Item: TfrxXMLItem);
var
  i, j: Integer;
  MacroItem: TfrxMacrosItem;
  lItem: TfrxXMLItem;
begin
  for i := 0 to FMacroses.Count - 1 do
  begin
    MacroItem := TfrxMacrosItem(FMacroses.Objects[i]);
    lItem := Item.Add;
    lItem.Name := FMacroses[i];
    for j := 0 to MacroItem.FItems.Count - 1 do
      with lItem.Add do
      begin
        Name := 'i';
{$IFDEF DELPHI12}
        Text := ' cnt="' + frxStrToXML(MacroItem.FItems[j]) + '"';
{$ELSE}
        Text := ' cnt="' + frxStrToXML(UTF8Encode(MacroItem.FItems[j])) + '"';
{$ENDIF}
      end;
  end;
end;

{ TfrxMacrosItem }

function TfrxMacrosItem.AddObject(const S: WideString; AObject: TObject;
  bSupressed: Boolean): Integer;
begin
  if bSupressed and (FItems.Count >= 1) and not FNeedReset then
    if s = FItems[FItems.Count - 1] then
    begin
      Result := FItems.Count - 1;
      Exit;
    end;
//  Result := FItems.Count - 1;

  Result := FItems.AddObject(S, AObject);
  FNeedReset := False;
end;

function TfrxMacrosItem.Count: Integer;
begin
  Result := FItems.Count;
end;

constructor TfrxMacrosItem.Create;
begin
{$IFDEF Delphi10}
  FItems := TfrxWideStrings.Create;
{$ELSE}
  FItems := TWideStrings.Create;
{$ENDIF}
  FSupressedValue := NULL;
  FLastIndex := -1;
  FComponent := nil;
  FNeedReset := False;
  FProcessAt := paDefault;
  FGroupLevel := 0;
  FDataLevel := 0;
end;

destructor TfrxMacrosItem.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

function TfrxMacrosItem.GetItem(Index: Integer): WideString;
begin
  if (Integer(FItems.Objects[Index]) = 0) and not FParent.FProcessing then
    Result := ''
  else
    Result := FItems[Index];
end;

procedure TfrxMacrosItem.SetItem(Index: Integer; const Value: WideString);
begin
  FItems[Index] := Value;
  if Assigned(FParent) and FParent.FProcessing then
    FItems.Objects[Index] := TObject(1);
end;

{ TfrxObjectProcessing }

procedure TfrxObjectProcessing.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TfrxObjectProcessing then
  begin
    ProcessAt := TfrxObjectProcessing(Source).FProcessAt;
    GroupLevel := TfrxObjectProcessing(Source).FGroupLevel;
  end;
end;

initialization
{$IFDEF PNG}
{$IFDEF Delphi12}
  TPicture.RegisterFileFormat('PNG_OLD', 'Portable Network Graphics', TPNGObject);
{$ENDIF}
{$ENDIF}
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxComponent, TControl);
  GroupDescendentsWith(TfrxDBComponents, TControl);
  GroupDescendentsWith(TfrxCustomCrypter, TControl);
  GroupDescendentsWith(TfrxCustomCompressor, TControl);
  GroupDescendentsWith(TfrxCustomExportFilter, TControl);
  GroupDescendentsWith(TfrxFrame, TControl);
  GroupDescendentsWith(TfrxHighlight, TControl);
  GroupDescendentsWith(TfrxStyleItem, TControl);

{$ENDIF}
{$IFNDEF NO_CRITICAL_SECTION}
  frxCS := TCriticalSection.Create;
{$ENDIF}
  if frxDefaultIOTransportClass = nil then
    frxDefaultIOTransportClass := TfrxIOTransportFile;
  frxDefaultTempFilterClass := TfrxIOTransportFile;
  DatasetList := TfrxGlobalDataSetList.Create;
  frxGlobalVariables := TfrxVariables.Create;
  { create parent form for OLE and RICH controls in the main thread }
  {$IFNDEF FPC}
  frxParentForm;
  {$ENDIF}
  Screen.Cursors[crHand] := LoadCursor(hInstance, 'frxHAND');
  Screen.Cursors[crZoom] := LoadCursor(hInstance, 'frxZOOM');
  Screen.Cursors[crFormat] := LoadCursor(hInstance, 'frxFORMAT');

  RegisterClasses([
    TfrxChild, TfrxColumnFooter, TfrxColumnHeader, TfrxCustomMemoView, TfrxMasterData,
    TfrxDetailData, TfrxSubDetailData, TfrxDataBand4, TfrxDataBand5, TfrxDataBand6,
    TfrxDialogPage, TfrxFooter, TfrxFrame, TfrxGroupFooter, TfrxGroupHeader,
    TfrxHeader, TfrxHighlight, TfrxLineView, TfrxMemoView, TfrxOverlay, TfrxPageFooter,
    TfrxPageHeader, TfrxPictureView, TfrxReport, TfrxReportPage, TfrxReportSummary,
    TfrxReportTitle, TfrxShapeView, TfrxSubreport, TfrxSysMemoView, TfrxStyleItem,
    TfrxNullBand, TfrxCustomLineView, TfrxDataPage]);


  frxResources.UpdateFSResources;
  frxFR2Events := TfrxFR2Events.Create;

finalization
{$IFDEF PNG}
{$IFDEF Delphi12}
  TPicture.UnregisterGraphicClass(TPNGObject);
{$ENDIF}
{$ENDIF}
{$IFNDEF NO_CRITICAL_SECTION}
  frxCS.Free;
{$ENDIF}
  frxGlobalVariables.Free;
  DatasetList.Free;
  if FParentForm <> nil then
  begin
    EmptyParentForm;
    FParentForm.Free;
  end;
  FParentForm := nil;
  frxFR2Events.Free;
  FreeAndNil(RegEditorsClasses);
end.
