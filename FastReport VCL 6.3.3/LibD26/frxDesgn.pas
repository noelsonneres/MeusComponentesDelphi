
{******************************************}
{                                          }
{             FastReport v5.0              }
{                Designer                  }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxDesgn;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}Windows, Messages,{$ENDIF} SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Types, ComCtrls, ImgList, Menus, Buttons, StdCtrls, ToolWin, ExtCtrls, ActnList,
  {$IFDEF FPC}
  LResources, LCLType, LMessages, LCLIntf, LCLProc, LazHelper, LazarusPackageIntf,
  {$ELSE}
  CommCtrl,
  {$ENDIF}
  frxClass, frxDock, frxCtrls, frxDesgnCtrls, frxDesgnWorkspace,
  frxInsp, frxDialogForm, frxDataTree, frxReportTree, frxSynMemo,
  fs_iinterpreter, Printers, {$IFNDEF FPC}frxWatchForm, frxBreakPointsForm,{$ELSE}frxLazBWForm,{$ENDIF}
  frxPictureCache, Variants
{$IFDEF Delphi17}
,  System.Actions
{$ENDIF}
{$IFDEF Delphi9}
, GraphUtil, Tabs
{$ENDIF}
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxDesignerUnits = (duCM, duInches, duPixels, duChars);
  TfrxLoadReportEvent = function(Report: TfrxReport): Boolean of object;
  TfrxLoadRecentReportEvent = function(Report: TfrxReport; FileName: String): Boolean of object;
  TfrxSaveReportEvent = function(Report: TfrxReport; SaveAs: Boolean): Boolean of object;
  TfrxGetTemplateListEvent = procedure(List: TStrings) of object;
  TfrxDesignerRestriction =
    (drDontInsertObject, drDontDeletePage, drDontCreatePage, drDontChangePageOptions,
     drDontCreateReport, drDontLoadReport, drDontSaveReport,
     drDontPreviewReport, drDontEditVariables, drDontChangeReportOptions,
     drDontEditReportData, drDontShowRecentFiles, drDontEditReportScript, drDontEditInternalDatasets);
  TfrxDesignerRestrictions = set of TfrxDesignerRestriction;
  TSampleFormat = class;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxDesigner = class(TComponent)
  private
    FCloseQuery: Boolean;
    FDefaultScriptLanguage: String;
    FDefaultFont: TFont;
    FDefaultLeftMargin: Extended;
    FDefaultBottomMargin: Extended;
    FDefaultRightMargin: Extended;
    FDefaultTopMargin: Extended;
    FDefaultPaperSize: Integer;
    FDefaultOrientation: TPrinterOrientation;
{$IFDEF Delphi10}
    FGradient: Boolean;
    FGradientEnd: TColor;
    FGradientStart: TColor;
{$ENDIF}
    FOpenDir: String;
    FSaveDir: String;
    FTemplatesExt: String;
    FTemplateDir: String;
    FStandalone: Boolean;
    FRestrictions: TfrxDesignerRestrictions;
    FRTLLanguage: Boolean;
    FMemoParentFont: Boolean;
    FOnLoadReport: TfrxLoadReportEvent;
    FOnLoadRecentReport: TfrxLoadRecentReportEvent;
    FOnSaveReport: TfrxSaveReportEvent;
    FOnShow: TNotifyEvent;
    FOnInsertObject: TNotifyEvent;
    FOnGetTemplateList: TfrxGetTemplateListEvent;
    FOnShowStartupScreen: TNotifyEvent;

    procedure SetDefaultFont(const Value: TFont);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CloseQuery: Boolean read FCloseQuery write FCloseQuery default True;
    property DefaultScriptLanguage: String read FDefaultScriptLanguage write FDefaultScriptLanguage;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property DefaultLeftMargin: Extended read FDefaultLeftMargin write FDefaultLeftMargin;
    property DefaultRightMargin: Extended read FDefaultRightMargin write FDefaultRightMargin;
    property DefaultTopMargin: Extended read FDefaultTopMargin write FDefaultTopMargin;
    property DefaultBottomMargin: Extended read FDefaultBottomMargin write FDefaultBottomMargin;
    property DefaultPaperSize: Integer read FDefaultPaperSize write FDefaultPaperSize;
    property DefaultOrientation: TPrinterOrientation read FDefaultOrientation write FDefaultOrientation;
{$IFDEF Delphi10}
    property Gradient: Boolean read FGradient write FGradient default False;
    property GradientEnd: TColor read FGradientEnd write FGradientEnd;
    property GradientStart: TColor read FGradientStart write FGradientStart;
{$ENDIF}
    property OpenDir: String read FOpenDir write FOpenDir;
    property SaveDir: String read FSaveDir write FSaveDir;
    property TemplatesExt: String read FTemplatesExt write FTemplatesExt;
    property TemplateDir: String read FTemplateDir write FTemplateDir;
    property Standalone: Boolean read FStandalone write FStandalone default False;
    property Restrictions: TfrxDesignerRestrictions read FRestrictions write FRestrictions;
    property RTLLanguage: Boolean read FRTLLanguage write FRTLLanguage;
    property MemoParentFont: Boolean read FMemoParentFont write FMemoParentFont;
    property OnLoadReport: TfrxLoadReportEvent read FOnLoadReport write FOnLoadReport;
    property OnLoadRecentReport: TfrxLoadRecentReportEvent read FOnLoadRecentReport write FOnLoadRecentReport;
    property OnSaveReport: TfrxSaveReportEvent read FOnSaveReport write FOnSaveReport;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnInsertObject: TNotifyEvent read FOnInsertObject write FOnInsertObject;
    property OnShowStartupScreen: TNotifyEvent read FOnShowStartupScreen write FOnShowStartupScreen;
    property OnGetTemplateList: TfrxGetTemplateListEvent read FOnGetTemplateList write FOnGetTemplateList;
  end;

  { TfrxDesignerForm }

  TfrxDesignerForm = class(TfrxCustomDesigner)
    Bevel1: TBevel;
    StatusBar: TStatusBar;
    DockBottom: TControlBar;
    DockTop: {$IFDEF FPC}TPanel{$ELSE}TControlBar{$ENDIF};
    TextTB: TToolBar;
    PanelTB1: TfrxTBPanel;
    FontSizeCB: TfrxComboBox;
    FontNameCB: TfrxFontComboBox;
    BoldB: TToolButton;
    ItalicB: TToolButton;
    UnderlineB: TToolButton;
    SepTB8: TToolButton;
    FontColorB: TToolButton;
    HighlightB: TToolButton;
    SepTB9: TToolButton;
    TextAlignLeftB: TToolButton;
    TextAlignCenterB: TToolButton;
    TextAlignRightB: TToolButton;
    TextAlignBlockB: TToolButton;
    SepTB10: TToolButton;
    TextAlignTopB: TToolButton;
    TextAlignMiddleB: TToolButton;
    TextAlignBottomB: TToolButton;
    FrameTB: TToolBar;
    FrameTopB: TToolButton;
    FrameBottomB: TToolButton;
    FrameLeftB: TToolButton;
    FrameRightB: TToolButton;
    SepTB11: TToolButton;
    FrameAllB: TToolButton;
    FrameNoB: TToolButton;
    SepTB12: TToolButton;
    FillColorB: TToolButton;
    FrameColorB: TToolButton;
    FrameStyleB: TToolButton;
    PanelTB2: TfrxTBPanel;
    FrameWidthCB: TfrxComboBox;
    StandardTB: TToolBar;
    NewB: TToolButton;
    OpenB: TToolButton;
    SaveB: TToolButton;
    PreviewB: TToolButton;
    CutB: TToolButton;
    CopyB: TToolButton;
    PasteB: TToolButton;
    SepTB2: TToolButton;
    UndoB: TToolButton;
    RedoB: TToolButton;
    SepTB3: TToolButton;
    SepTB4: TToolButton;
    NewPageB: TToolButton;
    NewDialogB: TToolButton;
    DeletePageB: TToolButton;
    PageSettingsB: TToolButton;
    ShowGridB: TToolButton;
    AlignToGridB: TToolButton;
    ExtraToolsTB: TToolBar;
    PagePopup: TPopupMenu;
    CutMI1: TMenuItem;
    CopyMI1: TMenuItem;
    PasteMI1: TMenuItem;
    DeleteMI1: TMenuItem;
    SelectAllMI1: TMenuItem;
    SepMI8: TMenuItem;
    EditMI1: TMenuItem;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    EditMenu: TMenuItem;
    ViewMenu: TMenuItem;
    ToolbarsMI: TMenuItem;
    StandardMI: TMenuItem;
    TextMI: TMenuItem;
    FrameMI: TMenuItem;
    AlignmentMI: TMenuItem;
    ToolsMI: TMenuItem;
    InspectorMI: TMenuItem;
    DataTreeMI: TMenuItem;
    OptionsMI: TMenuItem;
    HelpMenu: TMenuItem;
    HelpContentsMI: TMenuItem;
    SepMI7: TMenuItem;
    AboutMI: TMenuItem;
    OpenDialog: TOpenDialog;
    TabPopup: TPopupMenu;
    NewPageMI1: TMenuItem;
    NewDialogMI1: TMenuItem;
    DeletePageMI1: TMenuItem;
    PageSettingsMI1: TMenuItem;
    ActionList: TActionList;
    ExitCmd: TAction;
    CutCmd: TAction;
    CopyCmd: TAction;
    PasteCmd: TAction;
    UndoCmd: TAction;
    RedoCmd: TAction;
    DeleteCmd: TAction;
    SelectAllCmd: TAction;
    EditCmd: TAction;
    BringToFrontCmd: TAction;
    SendToBackCmd: TAction;
    DeletePageCmd: TAction;
    NewItemCmd: TAction;
    NewPageCmd: TAction;
    NewDialogCmd: TAction;
    NewReportCmd: TAction;
    OpenCmd: TAction;
    SaveCmd: TAction;
    SaveAsCmd: TAction;
    VariablesCmd: TAction;
    PageSettingsCmd: TAction;
    PreviewCmd: TAction;
    NewMI: TMenuItem;
    NewReportMI: TMenuItem;
    NewPageMI: TMenuItem;
    NewDialogMI: TMenuItem;
    SepMI1: TMenuItem;
    OpenMI: TMenuItem;
    SaveMI: TMenuItem;
    SaveAsMI: TMenuItem;
    VariablesMI: TMenuItem;
    SepMI3: TMenuItem;
    PreviewMI: TMenuItem;
    SepMI4: TMenuItem;
    ExitMI: TMenuItem;
    UndoMI: TMenuItem;
    RedoMI: TMenuItem;
    SepMI5: TMenuItem;
    CutMI: TMenuItem;
    CopyMI: TMenuItem;
    PasteMI: TMenuItem;
    DeleteMI: TMenuItem;
    DeletePageMI: TMenuItem;
    SelectAllMI: TMenuItem;
    SepMI6: TMenuItem;
    BringtoFrontMI: TMenuItem;
    SendtoBackMI: TMenuItem;
    EditMI: TMenuItem;
    PanelTB3: TfrxTBPanel;
    ScaleCB: TfrxComboBox;
    ObjectsTB1: TToolBar;
    BandsPopup: TPopupMenu;
    ReportTitleMI: TMenuItem;
    ReportSummaryMI: TMenuItem;
    PageHeaderMI: TMenuItem;
    PageFooterMI: TMenuItem;
    HeaderMI: TMenuItem;
    FooterMI: TMenuItem;
    MasterDataMI: TMenuItem;
    DetailDataMI: TMenuItem;
    SubdetailDataMI: TMenuItem;
    GroupHeaderMI: TMenuItem;
    GroupFooterMI: TMenuItem;
    ColumnHeaderMI: TMenuItem;
    ColumnFooterMI: TMenuItem;
    ChildMI: TMenuItem;
    LeftDockSite1: TfrxDockSite;
    SepTB13: TToolButton;
    PageSettingsMI: TMenuItem;
    Timer: TTimer;
    ReportSettingsMI: TMenuItem;
    Data4levelMI: TMenuItem;
    Data5levelMI: TMenuItem;
    Data6levelMI: TMenuItem;
    SepMI10: TMenuItem;
    SepMI9: TMenuItem;
    ShowGuidesMI: TMenuItem;
    ShowRulersMI: TMenuItem;
    DeleteGuidesMI: TMenuItem;
    SepMI11: TMenuItem;
    N1: TMenuItem;
    BringtoFrontMI1: TMenuItem;
    SendtoBackMI1: TMenuItem;
    SepMI12: TMenuItem;
    RotateB: TToolButton;
    RotationPopup: TPopupMenu;
    R0MI: TMenuItem;
    R45MI: TMenuItem;
    R90MI: TMenuItem;
    R180MI: TMenuItem;
    R270MI: TMenuItem;
    SetToGridB: TToolButton;
    FrameEditB: TToolButton;
    ReportMenu: TMenuItem;
    ReportDataMI: TMenuItem;
    OpenScriptDialog: TOpenDialog;
    SaveScriptDialog: TSaveDialog;
    ReportTreeMI: TMenuItem;
    ObjectsPopup: TPopupMenu;
    AlignTB: TToolBar;
    AlignLeftsB: TToolButton;
    AlignHorzCentersB: TToolButton;
    AlignRightsB: TToolButton;
    AlignTopsB: TToolButton;
    AlignVertCentersB: TToolButton;
    AlignBottomsB: TToolButton;
    SpaceHorzB: TToolButton;
    SpaceVertB: TToolButton;
    CenterHorzB: TToolButton;
    CenterVertB: TToolButton;
    SameWidthB: TToolButton;
    SameHeightB: TToolButton;
    SepTB15: TToolButton;
    SepTB16: TToolButton;
    SepTB18: TToolButton;
    SepTB17: TToolButton;
    OverlayMI: TMenuItem;
    StyleCB: TfrxComboBox;
    ReportStylesMI: TMenuItem;
    TabOrderMI: TMenuItem;
    N2: TMenuItem;
    FindMI: TMenuItem;
    FindNextMI: TMenuItem;
    ReplaceMI: TMenuItem;
    DMPPopup: TPopupMenu;
    BoldMI: TMenuItem;
    ItalicMI: TMenuItem;
    UnderlineMI: TMenuItem;
    SuperScriptMI: TMenuItem;
    SubScriptMI: TMenuItem;
    CondensedMI: TMenuItem;
    WideMI: TMenuItem;
    N12cpiMI: TMenuItem;
    N15cpiMI: TMenuItem;
    FontB: TToolButton;
    VerticalbandsMI: TMenuItem;
    HeaderMI1: TMenuItem;
    FooterMI1: TMenuItem;
    MasterDataMI1: TMenuItem;
    DetailDataMI1: TMenuItem;
    SubdetailDataMI1: TMenuItem;
    GroupHeaderMI1: TMenuItem;
    GroupFooterMI1: TMenuItem;
    ChildMI1: TMenuItem;
    N3: TMenuItem;
    GroupB: TToolButton;
    UngroupB: TToolButton;
    SepTB20: TToolButton;
    GroupCmd: TAction;
    UngroupCmd: TAction;
    GroupMI: TMenuItem;
    UngroupMI: TMenuItem;
    ConnectionsMI: TMenuItem;
    BackPanel: TPanel;
    ScrollBoxPanel: TPanel;
    ScrollBox: TfrxScrollBox;
    LeftRuler: TfrxRuler;
    TopRuler: TfrxRuler;
    CodePanel: TPanel;
    CodeTB: TToolBar;
    frTBPanel1: TfrxTBPanel;
    LangL: TLabel;
    LangCB: TfrxComboBox;
    OpenScriptB: TToolButton;
    SaveScriptB: TToolButton;
    SepTB19: TToolButton;
    RunScriptB: TToolButton;
    RunToCursorB: TToolButton;
    StepScriptB: TToolButton;
    StopScriptB: TToolButton;
    EvaluateB: TToolButton;
    BreakPointB: TToolButton;
    CodeDockSite: TfrxDockSite;
    LeftDockSite2: TfrxDockSite;
    RightDockSite: TfrxDockSite;
    TabPanel: TPanel;
    Panel1: TPanel;
    AddChildMI: TMenuItem;
    FindCmd: TAction;
    ReplaceCmd: TAction;
    FindNextCmd: TAction;
    ReportDataCmd: TAction;
    ReportStylesCmd: TAction;
    ReportOptionsCmd: TAction;
    ShowRulersCmd: TAction;
    ShowGuidesCmd: TAction;
    DeleteGuidesCmd: TAction;
    OptionsCmd: TAction;
    HelpContentsCmd: TAction;
    AboutCmd: TAction;
    StandardTBCmd: TAction;
    TextTBCmd: TAction;
    FrameTBCmd: TAction;
    AlignTBCmd: TAction;
    ExtraTBCmd: TAction;
    InspectorTBCmd: TAction;
    DataTreeTBCmd: TAction;
    ReportTreeTBCmd: TAction;
    ToolbarsCmd: TAction;
    FontColorPopupMenu: TPopupMenu;
    FillColorPopupMenu: TPopupMenu;
    FrameColorPopupMenu: TPopupMenu;
    ToolButton1: TToolButton;
    FillEditB: TToolButton;
    RevertInheritedMI: TMenuItem;
    RevertInheritedChildMI: TMenuItem;
    SelectAllOfTypeMI: TMenuItem;
    SelectAllOfTypeCmd: TAction;
    SelectAllOfTypeOnPageMI: TMenuItem;
    EdConfigMI: TMenuItem;
    EdConfigCmd: TAction;
    CopyContentCmd: TAction;
    CopyContent1: TMenuItem;
    CopyContent2: TMenuItem;
    procedure ExitCmdExecute(Sender: TObject);
    procedure ObjectsButtonClick(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const ARect: TRect);
    procedure ScrollBoxMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBoxMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBoxResize(Sender: TObject);
    procedure ScaleCBClick(Sender: TObject);
    procedure ShowGridBClick(Sender: TObject);
    procedure AlignToGridBClick(Sender: TObject);
    procedure StatusBarDblClick(Sender: TObject);
    procedure StatusBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InsertBandClick(Sender: TObject);
    procedure BandsPopupPopup(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewReportCmdExecute(Sender: TObject);
    procedure ToolButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FontColorBClick(Sender: TObject);
    procedure FrameStyleBClick(Sender: TObject);
    procedure TabChange(Sender: TObject);
    procedure UndoCmdExecute(Sender: TObject);
    procedure RedoCmdExecute(Sender: TObject);
    procedure CutCmdExecute(Sender: TObject);
    procedure CopyCmdExecute(Sender: TObject);
    procedure PasteCmdExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure DeletePageCmdExecute(Sender: TObject);
    procedure NewDialogCmdExecute(Sender: TObject);
    procedure NewPageCmdExecute(Sender: TObject);
    procedure SaveCmdExecute(Sender: TObject);
    procedure SaveAsCmdExecute(Sender: TObject);
    procedure OpenCmdExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DeleteCmdExecute(Sender: TObject);
    procedure SelectAllCmdExecute(Sender: TObject);
    procedure EditCmdExecute(Sender: TObject);
    procedure TabChanging(Sender: TObject; var AllowChange: Boolean);
    procedure PageSettingsCmdExecute(Sender: TObject);
    procedure TopRulerDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AlignLeftsBClick(Sender: TObject);
    procedure AlignRightsBClick(Sender: TObject);
    procedure AlignTopsBClick(Sender: TObject);
    procedure AlignBottomsBClick(Sender: TObject);
    procedure AlignHorzCentersBClick(Sender: TObject);
    procedure AlignVertCentersBClick(Sender: TObject);
    procedure CenterHorzBClick(Sender: TObject);
    procedure CenterVertBClick(Sender: TObject);
    procedure SpaceHorzBClick(Sender: TObject);
    procedure SpaceVertBClick(Sender: TObject);
    procedure SelectToolBClick(Sender: TObject);
    procedure PagePopupPopup(Sender: TObject);
    procedure BringToFrontCmdExecute(Sender: TObject);
    procedure SendToBackCmdExecute(Sender: TObject);
    procedure LangCBClick(Sender: TObject);
    procedure OpenScriptBClick(Sender: TObject);
    procedure SaveScriptBClick(Sender: TObject);
    procedure CodeWindowDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure CodeWindowDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure VariablesCmdExecute(Sender: TObject);
    procedure ObjectBandBClick(Sender: TObject);
    procedure PreviewCmdExecute(Sender: TObject);
    procedure HighlightBClick(Sender: TObject);
    procedure TabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TabDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TabDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SameWidthBClick(Sender: TObject);
    procedure SameHeightBClick(Sender: TObject);
    procedure NewItemCmdExecute(Sender: TObject);
    procedure TabOrderMIClick(Sender: TObject);
    procedure RunScriptBClick(Sender: TObject);
    procedure StopScriptBClick(Sender: TObject);
    procedure EvaluateBClick(Sender: TObject);
    procedure GroupCmdExecute(Sender: TObject);
    procedure UngroupCmdExecute(Sender: TObject);
    procedure ConnectionsMIClick(Sender: TObject);
    procedure LangSelectClick(Sender: TObject);
    procedure BreakPointBClick(Sender: TObject);
    procedure RunToCursorBClick(Sender: TObject);
    procedure CodeDockSiteDockOver(Sender: TObject;
      Source: TDragDockObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormShow(Sender: TObject);
    procedure AddChildMIClick(Sender: TObject);
    procedure FindCmdExecute(Sender: TObject);
    procedure ReplaceCmdExecute(Sender: TObject);
    procedure FindNextCmdExecute(Sender: TObject);
    procedure ReportDataCmdExecute(Sender: TObject);
    procedure ReportStylesCmdExecute(Sender: TObject);
    procedure ReportOptionsCmdExecute(Sender: TObject);
    procedure ShowRulersCmdExecute(Sender: TObject);
    procedure ShowGuidesCmdExecute(Sender: TObject);
    procedure DeleteGuidesCmdExecute(Sender: TObject);
    procedure OptionsCmdExecute(Sender: TObject);
    procedure HelpContentsCmdExecute(Sender: TObject);
    procedure AboutCmdExecute(Sender: TObject);
    procedure StandardTBCmdExecute(Sender: TObject);
    procedure TextTBCmdExecute(Sender: TObject);
    procedure FrameTBCmdExecute(Sender: TObject);
    procedure AlignTBCmdExecute(Sender: TObject);
    procedure ExtraTBCmdExecute(Sender: TObject);
    procedure InspectorTBCmdExecute(Sender: TObject);
    procedure DataTreeTBCmdExecute(Sender: TObject);
    procedure ReportTreeTBCmdExecute(Sender: TObject);
    procedure ToolbarsCmdExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FontColorPopupMenuPopup(Sender: TObject);
    procedure FillColorBClick(Sender: TObject);
    procedure FillColorPopupMenuPopup(Sender: TObject);
    procedure FrameColorBClick(Sender: TObject);
    procedure FrameColorPopupMenuPopup(Sender: TObject);
    procedure RevertInheritedMIClick(Sender: TObject);
    procedure SelectAllOfTypeCmdExecute(Sender: TObject);
    procedure EdConfigCmdExecute(Sender: TObject);
    procedure CopyContentCmdExecute(Sender: TObject);
  private
    { Private declarations }
    ObjectSelectB: TToolButton;
    HandToolB: TToolButton;
    ZoomToolB: TToolButton;
    TextToolB: TToolButton;
    FormatToolB: TToolButton;
    ObjectBandB: TToolButton;

    FClipboard: TfrxClipboard;
    FCodeWindow: TfrxSyntaxMemo;
    FColor: TColor;
    FFontColor: TColor;
    FFillColor: TColor;
    FFrameColor: TColor;
    FCoord1: String;
    FCoord2: String;
    FCoord3: String;
    FDialogForm: TfrxDialogForm;
    FEditAfterInsert: Boolean;
    FDataTree: TfrxDataTreeForm;
    FDropFields: Boolean;
    FGridAlign: Boolean;
    FGridSize1: Extended;
    FGridSize2: Extended;
    FGridSize3: Extended;
    FGridSize4: Extended;
    FInspector: TfrxObjectInspector;
    FLineStyle: TfrxFrameStyle;
    FLocalizedOI: Boolean;
    FLockSelectionChanged: Boolean;
    FModifiedBy: TObject;
    FMouseDown: Boolean;
    FOldDesignerComp: TfrxDesigner;
    FOldUnits: TfrxDesignerUnits;
    FPagePositions: TStrings;
    FPictureCache: TfrxPictureCache;
    FRecentFiles: TStringList;
    FRecentMenuIndex: Integer;
    FReportTree: TfrxReportTreeForm;
    FSampleFormat: TSampleFormat;
    FScale: Extended;
    FScriptFirstTime: Boolean;
    FScriptRunning: Boolean;
    FScriptStep: Boolean;
    FScriptStopped: Boolean;
    FSearchCase: Boolean;
    FSearchIndex: Integer;
    FSearchReplace: Boolean;
    FSearchReplaceText: String;
    FSearchText: String;
    FShowGrid: Boolean;
    FShowGuides: Boolean;
    FShowRulers: Boolean;
    FShowStartup: Boolean;
    FStickToGuides: Boolean;
    FGuidesAsAnchor: Boolean;
{$IFDEF UseTabset}
    FTabs: TTabSet;
{$ELSE}
    FTabs: TTabControl;
{$ENDIF}
    FToolsColor: TColor;
    FUndoBuffer: TfrxUndoBuffer;
    FUnits: TfrxDesignerUnits;
    FUnitsDblClicked: Boolean;
    FUpdatingControls: Boolean;
    {$IFNDEF FPC}
    FWatchList: TfrxWatchForm;
    FBreakPoints: TfrxBreakPointsForm;
    {$ELSE}
    FBWForm:TfrxBWForm;
    {$ENDIF}
    FWorkspace: TfrxDesignerWorkspace;
    FWorkspaceColor: TColor;
    FStatusBarOldWindowProc: TWndMethod;
    FTemplatePath: String;
    FTemplateExt: String;
    FFilterList: TStringList;
    procedure AttachDialogFormEvents(Attach: Boolean);
    procedure ChangeGlyphColor(Index: Integer; Color: TColor);
    procedure CreateColorSelector(Sender: TToolButton);
    procedure CreateExtraToolbar;
    procedure CreateToolWindows;
    procedure CreateObjectsToolbar;
    procedure CreateWorkspace;
    procedure DialogFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DialogFormKeyPress(Sender: TObject; var Key: Char);
    procedure DialogFormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DialogFormModify(Sender: TObject);
    procedure Done;
    procedure DoTopmosts(Enable: Boolean);
    procedure FindOrReplace(replace: Boolean);
    procedure FindText;
    procedure Init;
    procedure NormalizeTopmosts;
    procedure OnCodeChanged(Sender: TObject);
    procedure OnCodeCompletion(const Name: String; List: TfrxCompletionList);
    procedure OnColorChanged(Sender: TObject);
    procedure OnComponentMenuClick(Sender: TObject);
    procedure OnChangePosition(Sender: TObject);
    procedure OnDataTreeDblClick(Sender: TObject);
    procedure OnDisableDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure OnEditObject(Sender: TObject);
    procedure OnEnableDock(Sender, Target: TObject; X, Y: Integer);
    procedure OnExtraToolClick(Sender: TObject);
    procedure OnInsertObject(Sender: TObject);
    procedure OnModify(Sender: TObject);
    procedure OnNotifyPosition(ARect: TfrxRect);
    procedure OnRunLine(Sender: TfsScript; const UnitName, SourcePos: String);
    procedure OnSelectionChanged(Sender: TObject);
    procedure OnStyleChanged(Sender: TObject);
    procedure OpenRecentFile(Sender: TObject);
    procedure OnSaveFilterExecute(Sender: TObject);
    procedure OnEnterWorkSpace(Sender: TObject);
    procedure ReadButtonImages;
    procedure RestorePagePosition;
    procedure RestoreTopmosts;
    procedure SavePagePosition;
    procedure SaveState;
    procedure SetScale(Value: Extended);
    procedure SetGridAlign(const Value: Boolean);
    procedure SetShowGrid(const Value: Boolean);
    procedure SetShowRulers(const Value: Boolean);
    procedure SetToolsColor(const Value: TColor);
    procedure SetUnits(const Value: TfrxDesignerUnits);
    procedure SetWorkspaceColor(const Value: TColor);
    procedure SwitchToolbar;
    procedure UpdateCaption;
    procedure UpdateControls;
    procedure UpdatePageDimensions;
    procedure UpdateRecentFiles(NewFile: String);
    procedure UpdateStyles;
    procedure UpdateSyntaxType;
    procedure UpdateWatches;
    function AskSave: Word;
    function GetPageIndex: Integer;
    function GetReportName: String;
    procedure SetShowGuides(const Value: Boolean);
    procedure Localize;
    procedure CreateLangMenu;
    procedure CMStartup(var Message: TMessage); message WM_USER + 1;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMEnable(var Message: TMessage); message WM_ENABLE;
    {$IFNDEF FPC}
    procedure WMActivateApp(var Message: TWMActivateApp); message WM_ACTIVATEAPP;
    {$ENDIF}
    procedure StatusBarWndProc(var Message: TMessage);
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure SetGridSize1(const Value: Extended);
    procedure SetGridSize2(const Value: Extended);
    procedure SetGridSize3(const Value: Extended);
    procedure SetGridSize4(const Value: Extended);
    procedure SetStickToGuides(const Value: Boolean);
    procedure SetGuidesAsAnchor(const Value: Boolean);
  protected
    procedure UpdateWorkSpace(Sender: TObject);
    procedure UpdateVirtualGuids(Sender: TObject; Position: Extended);
    procedure SetModified(const Value: Boolean); override;
    procedure SetPage(const Value: TfrxPage); override;
    function GetCode: TStrings; override;
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  public
    { Public declarations }
    function CheckOp(Op: TfrxDesignerRestriction): Boolean;
    function InsertExpression(const Expr: String): String; override;
    function IsChangedExpression(const InExpr: String; out OutExpr: String): Boolean; override;

    procedure InternalCopy; override;
    procedure InternalPaste; override;
    function InternalIsPasteAvailable: Boolean; override;

    procedure LoadFile(FileName: String; UseOnLoadEvent: Boolean);
    procedure LoadFilter(aFilter: TfrxCustomIOTransport; FileName: String; UseOnLoadEvent: Boolean);
    procedure Lock; override;
    procedure ReloadPages(Index: Integer); override;
    procedure ReloadReport; override;
    procedure ReloadObjects(ResetSelection: Boolean = True); override;
    procedure RestoreState(RestoreDefault: Boolean = False;
      RestoreMainForm: Boolean = False);
    function SaveFile(SaveAs: Boolean; UseOnSaveEvent: Boolean): Boolean;
    function IOTransport(aFilter: TfrxCustomIOTransport; SaveAs: Boolean; UseOnSaveEvent: Boolean): Boolean;
    procedure SetReportDefaults;
    procedure SwitchToCodeWindow;
    procedure UpdateDataTree; override;
    procedure UpdatePage; override;
    function GetDefaultObjectSize: TfrxPoint;
    function mmToUnits(mm: Extended; X: Boolean = True): Extended;
    function UnitsTomm(mm: Extended; X: Boolean = True): Extended;
    procedure GetTemplateList(List: TStrings);
    procedure UpdateInspector; override;
    procedure DisableInspectorUpdate; override;
    procedure EnableInspectorUpdate; override;
    property CodeWindow: TfrxSyntaxMemo read FCodeWindow;
    property DataTree: TfrxDataTreeForm read FDataTree;
    property DropFields: Boolean read FDropFields write FDropFields;
    property EditAfterInsert: Boolean read FEditAfterInsert write FEditAfterInsert;
    property GridAlign: Boolean read FGridAlign write SetGridAlign;
    property GridSize1: Extended read FGridSize1 write SetGridSize1;
    property GridSize2: Extended read FGridSize2 write SetGridSize2;
    property GridSize3: Extended read FGridSize3 write SetGridSize3;
    property GridSize4: Extended read FGridSize4 write SetGridSize4;
    property Inspector: TfrxObjectInspector read FInspector;
    property PictureCache: TfrxPictureCache read FPictureCache;
    property RecentFiles: TStringList read FRecentFiles;
    property ReportTree: TfrxReportTreeForm read FReportTree;
    property SampleFormat: TSampleFormat read FSampleFormat;
    property Scale: Extended read FScale write SetScale;
    property ShowGrid: Boolean read FShowGrid write SetShowGrid;
    property ShowGuides: Boolean read FShowGuides write SetShowGuides;
    property ShowRulers: Boolean read FShowRulers write SetShowRulers;
    property ShowStartup: Boolean read FShowStartup write FShowStartup;
    property ToolsColor: TColor read FToolsColor write SetToolsColor;
    property Units: TfrxDesignerUnits read FUnits write SetUnits;
    property Workspace: TfrxDesignerWorkspace read FWorkspace;
    property WorkspaceColor: TColor read FWorkspaceColor write SetWorkspaceColor;
    property TemplatePath: String read FTemplatePath write FTemplatePath;
    property StickToGuides: Boolean read FStickToGuides write SetStickToGuides;
    property GuidesAsAnchor: Boolean read FGuidesAsAnchor write SetGuidesAsAnchor;
    {$IFDEF FPC}
    property LockSelectionChanged: Boolean read FLockSelectionChanged write FLockSelectionChanged;
    {$ENDIF}
  end;

  TSampleFormat = class(TObject)
  private
    FMemo: TfrxCustomMemoView;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ApplySample(Memo: TfrxCustomMemoView);
    procedure SetAsSample(Memo: TfrxCustomMemoView);
    property Memo: TfrxCustomMemoView read FMemo;
  end;

  TfrxCustomSavePlugin = class(TObject)
  public
    FileFilter: String;
    procedure Save(Report: TfrxReport; const FileName: String); virtual; abstract;
  end;

{$IFDEF FPC}
//procedure Register;
{$ENDIF}

var
  frxDesignerComp: TfrxDesigner;
///  frxSavePlugin: TfrxCustomSavePlugin;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

{$R *.res}

uses
  TypInfo, IniFiles, Registry,
  frxDsgnIntf, frxUtils, frxPopupForm, frxDesgnWorkspace1,
  frxDesgnEditors, frxEditOptions, frxEditReport, frxEditPage, frxAbout,
  fs_itools, frxXML, frxEditReportData, frxEditVar, frxEditExpr,
  frxEditHighlight, frxEditStyle, frxNewItem, frxEditFrame, frxEditFill,
  frxStdWizard, frxIOTransportIntf,
  frxEditTabOrder, frxCodeUtils, frxRes, frxrcDesgn, frxDMPClass,
  frxEvaluateForm, frxSearchDialog, frxConnEditor, fs_xml, frxVariables,
  frxRegistredEditorsDialog, frxIOTransportDialog;

type
  THackControl = class(TWinControl);



{ TSampleFormat }

constructor TSampleFormat.Create;
begin
  Clear;
end;

destructor TSampleFormat.Destroy;
begin
  FMemo.Free;
  inherited;
end;

procedure TSampleFormat.Clear;
begin
  if FMemo <> nil then
    FMemo.Free;
  FMemo := TfrxMemoView.Create(nil);
  if frxDesignerComp <> nil then
  begin
    FMemo.Font := frxDesignerComp.DefaultFont;
    FMemo.RTLReading := frxDesignerComp.RTLLanguage;
    FMemo.ParentFont := frxDesignerComp.MemoParentFont;
  end;
end;

procedure TSampleFormat.ApplySample(Memo: TfrxCustomMemoView);
begin
  Memo.FillType := FMemo.FillType;
  Memo.Fill.Assign(FMemo.Fill);
  if not (Memo is TfrxDMPMemoView) then
    Memo.Font := FMemo.Font;
  Memo.Frame.Assign(FMemo.Frame);
  Memo.HAlign := FMemo.HAlign;
  Memo.VAlign := FMemo.VAlign;
  Memo.RTLReading := FMemo.RTLReading;
  Memo.ParentFont := FMemo.ParentFont;
end;

procedure TSampleFormat.SetAsSample(Memo: TfrxCustomMemoView);
begin
  FMemo.FillType := Memo.FillType;
  FMemo.Fill.Assign(Memo.Fill);
  if not (Memo is TfrxDMPMemoView) then
    FMemo.Font := Memo.Font;
  FMemo.Frame.Assign(Memo.Frame);
  FMemo.HAlign := Memo.HAlign;
  FMemo.VAlign := Memo.VAlign;
  FMemo.RTLReading := Memo.RTLReading;
  Memo.ParentFont := FMemo.ParentFont;
end;


{ TfrxDesigner }

constructor TfrxDesigner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCloseQuery := True;
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := {$IFNDEF LCLGTK2}'Arial'{$ELSE}'Nimbus Sans L'{$ENDIF};
    Size := 10;
  end;
  FDefaultScriptLanguage := 'PascalScript';
  FTemplatesExt := 'fr3';
  FDefaultLeftMargin := 10;
  FDefaultBottomMargin := 10;
  FDefaultRightMargin := 10;
  FDefaultTopMargin := 10;
  FDefaultPaperSize := DMPAPER_A4;
  FDefaultOrientation := poPortrait;
  frxDesignerComp := Self;
{$IFDEF Delphi10}
  FGradientStart := clWindow;
  FGradientEnd := $00B6D6DA;
{$ENDIF}
end;

destructor TfrxDesigner.Destroy;
begin
  FDefaultFont.Free;
  frxDesignerComp := nil;
  inherited Destroy;
end;

procedure TfrxDesigner.SetDefaultFont(const Value: TFont);
begin
  FDefaultFont.Assign(Value);
end;


{ TfrxDesignerForm }

{ Form events }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.FormShow(Sender: TObject);
begin
  ReadButtonImages;
  CreateObjectsToolbar;
  CreateWorkspace;
  CreateToolWindows;
  Init;
  CreateExtraToolbar;

  Localize;
  CreateLangMenu;

  with ScaleCB.Items do
  begin
    Clear;
    Add('25%');
    Add('50%');
    Add('75%');
    Add('100%');
    Add('150%');
    Add('200%');
    Add(frxResources.Get('zmPageWidth'));
    Add(frxResources.Get('zmWholePage'));
  end;

  if Screen.PixelsPerInch > 96 then
  begin
    StyleCB.Font.Height := -11;
    FontNameCB.Font.Height := -11;
    FontSizeCB.Font.Height := -11;
    ScaleCB.Font.Height := -11;
    FrameWidthCB.Font.Height := -11;
    LangL.Font.Height := -11;
    LangCB.Font.Height := -11;
  end;

  FontSizeCB.DropDownCount := FontSizeCB.Items.Count;
  FontSizeCB.OnExit := ToolButtonClick;

  RestoreState;
  ToolsMI.Visible := ExtraToolsTB.ButtonCount > 0;
  ExtraToolsTB.Visible := ExtraToolsTB.ButtonCount > 0;
  ReloadReport;
  RestoreState(False, True);

  ConnectionsMI.Visible := False;
  if frxDesignerComp <> nil then
  begin
    ConnectionsMI.Visible := frxDesignerComp.Standalone;
    FTemplatePath := frxDesignerComp.FTemplateDir;
    if Assigned(frxDesignerComp.FOnShow) then
      frxDesignerComp.FOnShow(Self);
  end;
  if FTemplatePath = '' then
    FTemplatePath := Report.GetApplicationFolder;
end;

procedure TfrxDesignerForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveState;
  Done;
{$IFDEF FPC}
	FLockSelectionChanged := True; // avoid crash in OnSelectionChange
{$ENDIF}

  Objects.Clear;
  SelectedObjects.Clear;
  Report.Modified := Modified;
  Report.Designer := nil;
  Action := caFree;
end;

procedure TfrxDesignerForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  w: Word;
begin
  FInspector.FormDeactivate(nil);
  if FScriptRunning then
  begin
    CanClose := False;
    Exit;
  end;
  CanClose := True;
  Report.ScriptText := CodeWindow.Lines;

  if (frxDesignerComp <> nil) and not frxDesignerComp.CloseQuery then
    Exit;

  if Modified and not (csDesigning in Report.ComponentState) and CheckOp(drDontSaveReport) then
  begin
    w := AskSave;

    if IsPreviewDesigner then
    begin
      if w = mrNo then
        Modified := False
    end
    else if w = mrYes then
      if not SaveFile(False, True) then
        CanClose := False;

    if not IsPreviewDesigner then
    begin
      if w = mrNo then
        Modified := False
      else
        Modified := True;
    end;

    if w = mrCancel then
      CanClose := False;
  end;
end;

procedure TfrxDesignerForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ActiveDesignerForm: TForm;
begin
  if (Sender is TfrxObjectInspector) and (InspectorTBCmd.ShortCut = Key) then
  begin
    InspectorTBCmdExecute(Sender);
    Exit;
  end;
  if Assigned(ParentForm) then
    ActiveDesignerForm := ParentForm
  else
    ActiveDesignerForm := Self;

  if ((FDialogForm <> nil) or (FPage is TfrxDataPage)) and
    (ActiveDesignerForm.ActiveControl <> FInspector.Edit1) then
    THackControl(FWorkspace).KeyDown(Key, Shift);

  if Key = vk_Return then
    if ActiveDesignerForm.ActiveControl = FontSizeCB then
      ToolButtonClick(FontSizeCB)
    else if ActiveDesignerForm.ActiveControl = ScaleCB then
      ScaleCBClick(Self);

  if (Page <> nil) and (ActiveDesignerForm.ActiveControl <> FInspector.Edit1) then
    if Key = vk_Insert then
      if Shift = [ssShift] then
        PasteCmdExecute(nil)
      else if Shift = [ssCtrl] then
        CopyCmdExecute(nil);

  if (Page <> nil) and (ActiveDesignerForm.ActiveControl <> FInspector.Edit1) then
    if Key = vk_Delete then
      if Shift = [ssShift] then
        CutCmdExecute(nil);

  if (Key = Ord('E')) and (Shift = [ssCtrl]) then
    Page := nil;

  if ((Key = vk_F4) or (Key = vk_F5)) and (Shift = []) and (Page = nil) then
  begin
    if Key = vk_F4 then
      RunToCursorBClick(nil)
    else
      BreakPointBClick(nil);
  end
  else if (Key = vk_F2) and (Shift = [ssCtrl]) then
    StopScriptBClick(StopScriptB)
  else if (Key = vk_F7) and (Shift = [ssCtrl]) and (Page = nil) then
    EvaluateBClick(EvaluateB)
  else if Key = vk_F9 then
    RunScriptBClick(RunScriptB)
  else if ((Key = vk_F7) or (Key = vk_F8)) and (Page = nil) then
    RunScriptBClick(StepScriptB);
end;

procedure TfrxDesignerForm.CMStartup(var Message: TMessage);
begin
  if FShowStartup then
    if (frxDesignerComp <> nil) and Assigned(frxDesignerComp.FOnShowStartupScreen) then
      frxDesignerComp.FOnShowStartupScreen(Self);
end;

procedure TfrxDesignerForm.WMSysCommand(var Message: TWMSysCommand);
begin
  if (Message.CmdType and $FFF0 = SC_MINIMIZE) and (FormStyle <> fsMDIChild)
    and (fsModal in FormState) and not (csDesigning in Report.ComponentState)  then
{$IFNDEF DELPHI12}
      Application.Minimize
{$ELSE}
      inherited
{$ENDIF}
  else
    inherited;
end;

procedure TfrxDesignerForm.DoTopmosts(Enable: Boolean);
var
  fStyle: HWND;

  procedure SetFormStyle(Control: TWinControl);
  begin
    if Control is TToolBar then
      if Control.Floating then
        Control := Control.Parent
      else
        Exit;
    SetWindowPos(Control.Handle, fStyle, 0, 0, 0, 0, SWP_NOMOVE or
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOOWNERZORDER);
  end;

begin
  if Enable then
    fStyle := HWND_TOPMOST
  else
    fStyle := HWND_NOTOPMOST;

  SetFormStyle(FReportTree);
  SetFormStyle(FDataTree);
  SetFormStyle(FInspector);

  SetFormStyle(StandardTB);
  SetFormStyle(TextTB);
  SetFormStyle(FrameTB);
  SetFormStyle(AlignTB);
  SetFormStyle(ExtraToolsTB);
end;

procedure TfrxDesignerForm.NormalizeTopmosts;
begin
  DoTopmosts(False);
end;

procedure TfrxDesignerForm.RestoreTopmosts;
begin
  DoTopmosts(True);
end;

procedure TfrxDesignerForm.RevertInheritedMIClick(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
  TempStream: TMemoryStream;
  NeedRefresh: Boolean;
begin
  TempStream := TMemoryStream.Create;
  NeedRefresh := False;
  try
    for i := 0 to FSelectedObjects.Count - 1 do
    begin
      c := TObject(FSelectedObjects[i]) as TfrxComponent;
      if c.IsAncestor then
      begin
        TempStream.Clear;
        c.AncestorOnlyStream := True;
        try
          c.SaveToStream(TempStream, Sender = RevertInheritedChildMI, true, false);
          TempStream.Position := 0;
          c.LoadFromStream(TempStream);
          NeedRefresh := True;
        finally
          c.AncestorOnlyStream := False;
        end;
      end;
    end;
  finally
    TempStream.Free;
  end;
  if NeedRefresh then
  begin
    FInspector.Objects := FObjects;
    FInspector.UpdateProperties;
    Modified := True
  end;
end;

procedure TfrxDesignerForm.WMEnable(var Message: TMessage);
begin
  inherited;
  { workaround for ShowModal bug. If form with fsStayOnTop style is visible
    before ShowModal call, it will be topmost }
  if Message.WParam <> 0 then
    RestoreTopmosts
  else
    NormalizeTopmosts;
end;

{$IFNDEF FPC}
procedure TfrxDesignerForm.WMActivateApp(var Message: TWMActivateApp);
begin
  inherited;
  if (Message.Active) and not((Report <> nil) and (Report.PreviewForm <> nil)) then
    RestoreTopmosts
  else
    NormalizeTopmosts;
end;
{$ENDIF}

{ Get/Set methods }
{------------------------------------------------------------------------------}

function TfrxDesignerForm.GetDefaultObjectSize: TfrxPoint;
begin
  case FUnits of
    duCM:     Result := frxPoint(fr1cm * 2.5, fr1cm * 0.5);
    duInches: Result := frxPoint(fr1in, fr1in * 0.2);
    duPixels: Result := frxPoint(80, 16);
    duChars:  Result := frxPoint(fr1CharX * 10, fr1CharY);
  end;
end;

function TfrxDesignerForm.GetCode: TStrings;
begin
  Result := CodeWindow.Lines;
end;

procedure TfrxDesignerForm.SetGridAlign(const Value: Boolean);
begin
  FGridAlign := Value;
  AlignToGridB.Down := FGridAlign;
  FWorkspace.GridAlign := FGridAlign;
end;

procedure TfrxDesignerForm.SetModified(const Value: Boolean);
var
  i: Integer;
begin
  if csDestroying in ComponentState then Exit;
  inherited;
  Report.ScriptText := CodeWindow.Lines;
  if IsPreviewDesigner then
    FUndoBuffer.AddUndo(FPage)
  else
    FUndoBuffer.AddUndo(Report);
  FUndoBuffer.ClearRedo;
  SaveCmd.Enabled := Modified;

  if FModifiedBy <> Self then
    UpdateControls;

  if FModifiedBy = FInspector then
    if (FSelectedObjects[0] = FPage) {or
       (TObject(FSelectedObjects[0]) is TfrxSubreport)} then
    begin
      FLockSelectionChanged := True;
      try
        i := Report.Objects.IndexOf(FPage);
        if i >= 0 then
          ReloadPages(i);
      finally
        FLockSelectionChanged := False;
      end;
    end;

  if FModifiedBy <> FWorkspace then
  begin
    FWorkspace.UpdateView;
    FWorkspace.AdjustBands;
  end;

  if FModifiedBy <> FInspector then
    FInspector.UpdateProperties;
  {$IFDEF LCLGTK2}
  if FModifiedBy = FInspector then
    FLockSelectionChanged := True;
  {$ENDIF}
  FReportTree.UpdateItems;
  FModifiedBy := nil;
end;

procedure TfrxDesignerForm.SetPage(const Value: TfrxPage);
begin
  inherited;

  FTabs.TabIndex := Report.Objects.IndexOf(FPage) + 1;
  AttachDialogFormEvents(False);
  ScrollBoxPanel.Visible := FPage <> nil;
  CodePanel.Visible := FPage = nil;

  SwitchToolbar;
  UpdateControls;
  if FPage = nil then
  begin
    CodeWindow.SetFocus;
    Exit;
  end
  else if FPage is TfrxReportPage then
  begin
    with FWorkspace do
    begin
      Parent := ScrollBox;
      Align := alNone;
      Color := FWorkspaceColor;
      Scale := Self.Scale;
      OnMouseEnter := OnEnterWorkSpace;
    end;

    if FPage is TfrxDMPPage then
      Units := duChars else
      Units := FOldUnits;
    UpdatePageDimensions;
    if Visible then
      ScrollBox.SetFocus;
  end
  else if FPage is TfrxDialogPage then
  begin
    Units := duPixels;
    FDialogForm := TfrxDialogForm(TfrxDialogPage(FPage).DialogForm);

    with FWorkspace do
    begin
{$IFDEF FPC}
      Parent := ScrollBox;
      Align := alNone;
{$ELSE}
      Parent := FDialogForm;
      Align := alClient;
{$ENDIF}
      GridType := gtDialog;
      GridX := FGridSize4;
      GridY := FGridSize4;
      Color := TfrxDialogPage(FPage).Color;
      Scale := 1;
{$IFDEF FPC}
      SetPageDimensions(FDialogForm.Width, FDialogForm.Height, Rect(0, 0, 0, 0));
{$ELSE}
      SetPageDimensions(0, 0, Rect(0, 0, 0, 0));
{$ENDIF}
    end;

    if FDialogForm <> nil then
    with FDialogForm do
    begin
      {$IFDEF FPC}
      Width := ClientWidth;
      Height := ClientHeight;
      {$ENDIF}
      Position := poDesigned;
      BorderStyle := bsSizeable;
      AttachDialogFormEvents(True);
      Show;
{$IFDEF FPC}
      SendToBack;
{$ENDIF}
    end;
  end
  else if FPage is TfrxDataPage then
  begin
    Units := duPixels;
    with FWorkspace do
    begin
      Parent := ScrollBox;
      Align := alNone;
      Color := FWorkspaceColor;
      Scale := 1;
      GridType := gtNone;
      GridX := FGridSize4;
      GridY := FGridSize4;
    end;

    UpdatePageDimensions;
    if Visible then
      ScrollBox.SetFocus;
  end
  else
  begin
    Report.Errors.Add('Page object is not page');
  end;
  OnSelectionChanged(Self);
  ReloadObjects;
  RestorePagePosition;
end;

procedure TfrxDesignerForm.SetScale(Value: Extended);
begin
  ScrollBox.AutoScroll := False;
  if Value = 0 then
    Value := 1;
  if Value > 20 then
    Value := 20;
  FScale := Value;
  TopRuler.Scale := Value;
  LeftRuler.Scale := Value;
  FWorkspace.Scale := Value;
  ScaleCB.Text := IntToStr(Round(FScale * 100)) + '%';
  UpdatePageDimensions;
  ScrollBox.AutoScroll := True;
end;

procedure TfrxDesignerForm.SetShowGrid(const Value: Boolean);
begin
  FShowGrid := Value;
  ShowGridB.Down := FShowGrid;
  FWorkspace.ShowGrid := FShowGrid;
end;

procedure TfrxDesignerForm.SetShowRulers(const Value: Boolean);
begin
  FShowRulers := Value;
  TopRuler.Visible := FShowRulers;
  LeftRuler.Visible := FShowRulers;
  LeftRuler.DragMode := dmManual;
  TopRuler.DragMode := dmManual;
  LeftRuler.OnPointerAdded := UpdateWorkSpace;
  TopRuler.OnPointerAdded := UpdateWorkSpace;
  ShowRulersCmd.Checked := FShowRulers;
end;

procedure TfrxDesignerForm.SetShowGuides(const Value: Boolean);
begin
  FShowGuides := Value;
  TDesignerWorkspace(FWorkspace).ShowGuides := FShowGuides;
  ShowGuidesCmd.Checked := FShowGuides;
end;

procedure TfrxDesignerForm.SetStickToGuides(const Value: Boolean);
begin
  FStickToGuides := Value;
  TDesignerWorkspace(FWorkspace).StickToGuides := FStickToGuides;
end;

procedure TfrxDesignerForm.SetGuidesAsAnchor(const Value: Boolean);
begin
  FGuidesAsAnchor := Value;
  TDesignerWorkspace(FWorkspace).GuidesAsAnchor := FGuidesAsAnchor;
end;

procedure TfrxDesignerForm.SetUnits(const Value: TfrxDesignerUnits);
var
  s: String;
  gType: TfrxGridType;
  gSizeX, gSizeY: Extended;
begin
  FUnits := Value;
  s := '';
  if FUnits = duCM then
  begin
    s := frxResources.Get('dsCm');
    gType := gt1cm;
    gSizeX := FGridSize1 * fr1cm;
    gSizeY := gSizeX;
  end
  else if FUnits = duInches then
  begin
    s := frxResources.Get('dsInch');
    gType := gt1in;
    gSizeX := FGridSize2 * fr1in;
    gSizeY := gSizeX;
  end
  else if FUnits = duPixels then
  begin
    s := frxResources.Get('dsPix');
    gType := gt1pt;
    gSizeX := FGridSize3;
    gSizeY := gSizeX;
  end
  else {if FUnits = duChars then}
  begin
    s := frxResources.Get('dsChars');
    gType := gtChar;
    gSizeX := fr1CharX;
    gSizeY := fr1CharY;
  end;

  StatusBar.Panels[0].Text := s;
  TopRuler.Units := TfrxRulerUnits(FUnits);
  LeftRuler.Units := TfrxRulerUnits(FUnits);

  with FWorkspace do
  begin
    GridType := gType;
    GridX := gSizeX;
    GridY := gSizeY;
    AdjustBands;
  end;

  if FSelectedObjects.Count <> 0 then
    OnSelectionChanged(Self);
end;

procedure TfrxDesignerForm.SetToolsColor(const Value: TColor);
begin
  FToolsColor := Value;
  FInspector.SetColor(Value);
  FDataTree.SetColor_(Value);
  FReportTree.SetColor_(Value);
end;

procedure TfrxDesignerForm.SetWorkspaceColor(const Value: TColor);
begin
  FWorkspaceColor := Value;
  if not (FPage is TfrxDialogPage) then
    FWorkspace.Color := Value;
end;


{ Service methods }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.Init;
var
  i: Integer;
  mi: TMenuItem;

  procedure AddItem(ParentMI: TMenuItem; aEvent: TNotifyEvent; sStream: TfrxIOTransportStream);
  begin
    if not(sStream in TfrxCustomIOTransport(FFilterList.Objects[i]).SupportedStreams) then Exit;
    ParentMI.OnClick := nil;
    ParentMI.Action := nil;
    mi := TMenuItem.Create(ParentMI);
    ParentMI.Add(mi);
    mi.Caption := TfrxCustomIOTransport(FFilterList.Objects[i]).GetDescription;
    mi.Tag := i;
    mi.OnClick := aEvent;
  end;

begin
  FPictureCache := TfrxPictureCache.Create;
  FScale := 1;
  ScrollBoxPanel.Align := alClient;
  CodePanel.Align := alClient;
  if Screen.PixelsPerInch > 96 then
  begin
    StatusBar.Panels[0].Width := 100;
    StatusBar.Panels[1].Width := 280;
    StatusBar.Height := 24;
  end;

  fsGetLanguageList(LangCB.Items);
  frxAddCodeRes;

  FUndoBuffer := TfrxUndoBuffer.Create;
  FUndoBuffer.PictureCache := FPictureCache;

  FClipboard := TfrxClipboard.Create(Self);
  FClipboard.PictureCache := FPictureCache;
  Timer.Enabled := True;

  FRecentFiles := TStringList.Create;
  FRecentMenuIndex := FileMenu.IndexOf(SepMI4);
{$IFNDEF FPC}
  MainMenu.AutoHotKeys := maManual;
{$ENDIF}

{$IFNDEF Delphi23}
  if Screen.PixelsPerInch / 96 >= 4 then
    Screen.MenuFont.Size := 6 - Round(Screen.PixelsPerInch /96)
  else if Screen.PixelsPerInch / 96 >= 3 then
    Screen.MenuFont.Size := 7 - Round(Screen.PixelsPerInch /96)
  else if Screen.PixelsPerInch / 96 >= 2 then
    Screen.MenuFont.Size := 8 - Round(Screen.PixelsPerInch /96)
  else if Screen.PixelsPerInch / 96 > 1 then
    Screen.MenuFont.Size := 9 - Round(Screen.PixelsPerInch /96);
{$ENDIF}
  FSampleFormat := TSampleFormat.Create;
  FPagePositions := TStringList.Create;
  for i := 1 to 256 do
    FPagePositions.Add('');

  if IsPreviewDesigner then
  begin
    FOldDesignerComp := frxDesignerComp;
    TfrxDesigner.Create(nil);
    frxDesignerComp.Restrictions := [drDontDeletePage, drDontCreatePage,
      drDontCreateReport, drDontLoadReport, drDontPreviewReport,
      drDontEditVariables, drDontChangeReportOptions];
    if FOldDesignerComp <> nil then
      frxDesignerComp.Restrictions := frxDesignerComp.Restrictions + FOldDesignerComp.Restrictions;

    ObjectBandB.Enabled := False;
  end;

  Report.SelectPrinter;
  FontNameCB.PopulateList;

  FFontColor := clBlack;
  FFillColor := clBlack;
  FFrameColor := clBlack;
  ChangeGlyphColor(23, FFontColor);
  ChangeGlyphColor(38, FFillColor);
  ChangeGlyphColor(39, FFrameColor);

{$IFDEF FR_VER_BASIC}
  NewDialogCmd.Enabled := False;
{$ENDIF}

  NewReportCmd.Enabled := CheckOp(drDontCreateReport);
  NewItemCmd.Enabled := CheckOp(drDontCreateReport);
  NewPageCmd.Enabled := CheckOp(drDontCreatePage);
  NewDialogCmd.Enabled := NewDialogCmd.Enabled and CheckOp(drDontCreatePage);
  SaveAsCmd.Enabled := CheckOp(drDontSaveReport);
  OpenCmd.Enabled := CheckOp(drDontLoadReport);
  ReportOptionsCmd.Enabled := CheckOp(drDontChangeReportOptions);
  ReportStylesCmd.Enabled := CheckOp(drDontChangeReportOptions);
  ReportDataCmd.Enabled := CheckOp(drDontEditReportData);
  VariablesCmd.Enabled := CheckOp(drDontEditVariables);
  PreviewCmd.Enabled := CheckOp(drDontPreviewReport);
  FFilterList := TStringList.Create;

  FillItemsList(FFilterList, fvDesigner);

  if FFilterList.Count > 1 then

    for i := 0 to FFilterList.Count - 1 do
    begin
      AddItem(SaveAsMI, OnSaveFilterExecute, tsIOWrite);
      AddItem(OpenMI, OpenCmdExecute, tsIORead);
    end;
  LeftRuler.OnUpdateVirtualLines := UpdateVirtualGuids;
  TopRuler.OnUpdateVirtualLines := UpdateVirtualGuids;
end;

procedure TfrxDesignerForm.Done;
begin
  AttachDialogFormEvents(False);
  if IsPreviewDesigner then
  begin
    frxDesignerComp.Free;
    frxDesignerComp := FOldDesignerComp;
  end;
  {$IFDEF FPC}
  Timer.Enabled := False;
  {$ENDIF}
  {$IFNDEF FPC}
  FBreakPoints.SynMemo := nil;
  {$ENDIF}
  FPictureCache.Free;
  FUndoBuffer.Free;
  FClipboard.Free;
  FRecentFiles.Free;
  FSampleFormat.Free;
  FPagePositions.Free;
  FFilterList.Free;
end;

procedure TfrxDesignerForm.ChangeGlyphColor(Index: Integer; Color: TColor);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.Width := 16;
  bmp.Height := 16;
{$IFDEF FPC}
  bmp.TransparentColor := clOlive;
{$ENDIF}
  with bmp.Canvas do
  begin
    Brush.Color := clOlive;
    FillRect(Rect(0, 0, 16, 16));
  end;
  frxResources.MainButtonImages.Draw(bmp.Canvas, 0, 0, Index);
  with bmp.Canvas do
  begin
    Brush.Color := Color;
    FillRect(Rect(1, 13, 16, 16));
  end;
  frxResources.MainButtonImages.ReplaceMasked(Index, bmp, bmp.TransparentColor);
  bmp.Free;
end;

procedure TfrxDesignerForm.ReadButtonImages;
var
  MainImages, DisabledImages, ObjectImages: TImageList;
begin
  MainImages := frxResources.MainButtonImages;
  DisabledImages := frxResources.DisabledButtonImages;
  ObjectImages := frxResources.ObjectImages;

  CodeTB.Images := MainImages;
  CodeTB.DisabledImages := DisabledImages;

  StandardTB.Images := MainImages;
  StandardTB.DisabledImages := DisabledImages;

  TextTB.Images := MainImages;
  TextTB.DisabledImages := DisabledImages;

  FrameTB.Images := MainImages;
  FrameTB.DisabledImages := DisabledImages;

  AlignTB.Images := MainImages;
  AlignTB.DisabledImages := DisabledImages;

  ExtraToolsTB.Images := MainImages;
  ExtraToolsTB.DisabledImages := DisabledImages;

  ObjectsTB1.Images := ObjectImages;
  ObjectsPopup.Images := ObjectImages;
  MainMenu.Images := MainImages;
  PagePopup.Images := MainImages;
  TabPopup.Images := MainImages;
  ActionList.Images := MainImages;
  BandsPopup.Images := MainImages;

{$IFDEF Delphi10}
  if (frxDesignerComp <> nil) and (frxDesignerComp.Gradient) then
  begin
    StandardTB.DrawingStyle := ComCtrls.dsGradient;
    StandardTB.GradientStartColor := frxDesignerComp.GradientStart;
    StandardTB.GradientEndColor := frxDesignerComp.GradientEnd;
    TextTB.DrawingStyle := ComCtrls.dsGradient;
    TextTB.GradientStartColor := frxDesignerComp.GradientStart;
    TextTB.GradientEndColor := frxDesignerComp.GradientEnd;
    FrameTB.DrawingStyle := ComCtrls.dsGradient;
    FrameTB.GradientStartColor := frxDesignerComp.GradientStart;
    FrameTB.GradientEndColor := frxDesignerComp.GradientEnd;
    AlignTB.DrawingStyle := ComCtrls.dsGradient;
    AlignTB.GradientStartColor := frxDesignerComp.GradientStart;
    AlignTB.GradientEndColor := frxDesignerComp.GradientEnd;
    ExtraToolsTB.DrawingStyle := ComCtrls.dsGradient;
    ExtraToolsTB.GradientStartColor := frxDesignerComp.GradientStart;
    ExtraToolsTB.GradientEndColor := frxDesignerComp.GradientEnd;
    ObjectsTB1.DrawingStyle := ComCtrls.dsGradient;
    ObjectsTB1.GradientStartColor := frxDesignerComp.GradientStart;
    ObjectsTB1.GradientEndColor := frxDesignerComp.GradientEnd;
    DockTop.DrawingStyle := dsGradient;
    DockTop.GradientStartColor := frxDesignerComp.GradientStart;
    DockTop.GradientEndColor := frxDesignerComp.GradientEnd;
    DockBottom.DrawingStyle := dsGradient;
    DockBottom.GradientStartColor := frxDesignerComp.GradientStart;
    DockBottom.GradientEndColor := frxDesignerComp.GradientEnd;
  end;
{$ENDIF}
{$IFDEF Delphi11}
   StandardTB.Transparent := False;
   AlignTB.Transparent := False;
   TextTB.Transparent := False;
   FrameTB.Transparent := False;
   ExtraToolsTB.Transparent := False;
   ObjectsTB1.Transparent := False;
{$ENDIF}
end;

procedure TfrxDesignerForm.CreateToolWindows;
begin
  FInspector := TfrxObjectInspector.Create(Self);
  with FInspector do
  begin
    OnModify := Self.OnModify;
    OnSelectionChanged := Self.OnSelectionChanged;
    OnStartDock := OnDisableDock;
    OnEndDock := OnEnableDock;
    SelectedObjects := FSelectedObjects;
  end;

  FDataTree := TfrxDataTreeForm.Create(Self);
  with FDataTree do
  begin
    Report := Self.Report;
    CBPanel.Visible := True;
    OnDblClick := OnDataTreeDblClick;
    OnStartDock := OnDisableDock;
    OnEndDock := OnEnableDock;
    MultiSelectAllowed := True;
  end;
  UpdateDataTree;

  FReportTree := TfrxReportTreeForm.Create(Self);
  FReportTree.OnSelectionChanged := OnSelectionChanged;
  FReportTree.OnStartDock := OnDisableDock;
  FReportTree.OnEndDock := OnEnableDock;
  FReportTree.PopupMenu := PagePopup;

  {$IFNDEF FPC}
  FWatchList := TfrxWatchForm.Create(Self);
  FWatchList.Script := Report.Script;
  FBreakPoints := TfrxBreakPointsForm.Create(Self);
  FBreakPoints.SynMemo := FCodeWindow;
  FBreakPoints.Script := Report.Script;
  {$ELSE}
  FBWForm := TfrxBWForm.Create(Self);
  FBWForm.Script := Report.Script;
  FBWForm.SynMemo := FCodeWindow;
  {$ENDIF}
end;

procedure TfrxDesignerForm.CreateWorkspace;
begin
  FWorkspace := TDesignerWorkspace.Create(Self);
  ScrollBox.OnMouseWheel := ScrollBoxMouseWheel;
  with FWorkspace do
  begin
    Parent := ScrollBox;
    OnNotifyPosition := Self.OnNotifyPosition;
    OnInsert := OnInsertObject;
    OnEdit := OnEditObject;
    OnModify := Self.OnModify;
    OnSelectionChanged := Self.OnSelectionChanged;
    OnTopLeftChanged := ScrollBoxResize;
    PopupMenu := PagePopup;
    Objects := FObjects;
    SelectedObjects := FSelectedObjects;
    //InspSelectedObjects := FInspSelectedObjects;
  end;

  {$IFDEF FPC}
  ScrollBox.OnAfterScroll := ScrollBoxResize;
  {$IFDEF WINDOWS}
  FWorkSpace.OnMouseWheelDown:= ScrollBoxMouseWheelDown;
  FWorkSpace.OnMouseWheelUp:= ScrollBoxMouseWheelUp;
  {$ENDIF}
  {$ENDIF}

  FCodeWindow := TfrxSyntaxMemo.Create(Self);
  with FCodeWindow do
  begin
    Parent := CodePanel;
    Align := alClient;
{$IFDEF UseTabset}
    BevelKind := bkFlat;
{$ELSE}
    BorderStyle := bsSingle;
{$ENDIF}
{$IFDEF DELPHI7}
    ImeMode := imClose;
{$ENDIF}
    Lines := Report.ScriptText;
    Color := clWindow;
    OnChangeText := OnCodeChanged;
    OnChangePos := OnChangePosition;
    OnDragOver := CodeWindowDragOver;
    OnDragDrop := CodeWindowDragDrop;
    OnCodeCompletion := Self.OnCodeCompletion;
    FCodeWindow.Script := Report.Script;
  end;

{$IFDEF UseTabset}
  FTabs := TTabSet.Create(Self);
  FTabs.ShrinkToFit := True;
  FTabs.Style := tsSoftTabs;
  FTabs.TabPosition := tpTop;
  FTabs.OnClick := TabChange;
  FTabs.OnChange := TabSetChange;
{$ELSE}
  FTabs := TTabControl.Create(Self);
  FTabs.OnChange := TabChange;
  FTabs.OnChanging := TabChanging;
{$ENDIF}
  FTabs.OnDragDrop := TabDragDrop;
  FTabs.OnDragOver := TabDragOver;
  FTabs.OnMouseDown := TabMouseDown;
  FTabs.OnMouseMove := TabMouseMove;
  FTabs.OnMouseUp := TabMouseUp;
  FTabs.Parent := TabPanel;
  FTabs.Align := alTop;
  FTabs.Font.Height := Round(-11 * Screen.PixelsPerInch / 96);
  FTabs.Height := Abs(FTabs.Font.Height) + Round(8 * Screen.PixelsPerInch / 96);
{$IFDEF UseTabset}
  Panel1.SetBounds(0, FTabs.Height, 2000, 2);
{$ELSE}
  Panel1.BringToFront;
  Panel1.SetBounds(0, FTabs.Height, 2000, 2);
  FTabs.Height := FTabs.Height + 2;
{$ENDIF}
end;

procedure TfrxDesignerForm.CreateObjectsToolbar;
var
  ObjCount: Integer;
  Item: TfrxObjectItem;

  function HasButtons(Item: TfrxObjectItem): Boolean;
  var
    i: Integer;
    Item1: TfrxObjectItem;
  begin
    Result := False;
    for i := 0 to frxObjects.Count - 1 do
    begin
      Item1 := frxObjects[i];
      if (Item1.ClassRef <> nil) and (Item1.CategoryName = Item.CategoryName) then
        Result := True;
    end;
  end;

{$IFDEF FPC}
  procedure SetButtonBouns(b: TToolButton);
  var
    bTop: Integer;
  begin
    bTop := 0;
    b.Align := alNone;
    if ObjectsTB1.ButtonCount > 1 then
    begin
      bTop := ObjectsTB1.Buttons[ObjectsTB1.ButtonCount - 1].Top + ObjectsTB1.ButtonHeight;
     // ObjectsTB1.Buttons[ObjectsTB1.ButtonCount - 1].Align := alNone;
    end;
    b.SetBounds(0, bTop, ObjectsTB1.ButtonWidth, ObjectsTB1.ButtonHeight);
    b.Align:= alTop;
  end;
{$ENDIF}

  procedure CreateButton(Index: Integer; Item: TfrxObjectItem);
  var
    b: TToolButton;
    s: String;
  begin
    b := TToolButton.Create(ObjectsTB1);
    b.Parent := ObjectsTB1;
{$IFDEF FPC}
    SetButtonBouns(b);
{$ENDIF}
    b.Style := tbsCheck;
    b.ImageIndex := Item.ButtonImageIndex;
    b.Grouped := True;
    s := Item.ButtonHint;
    if s = '' then
    begin
      if Item.ClassRef <> nil then
        s := Item.ClassRef.GetDescription;
    end
    else
      s := frxResources.Get(s);
    b.Hint := s;
    b.Tag := Index;
    if Item.ClassRef = nil then  { category }
    begin
      if not HasButtons(Item) then
      begin
        b.Free;
        Exit;
      end;
    end;

    b.OnClick := ObjectsButtonClick;
    b.Wrap := True;
{$IFDEF FR_LITE}
    if Item.CategoryName = 'Other' then
    begin
      b.Enabled := False;
      b.Hint := b.Hint + #13#10 + 'This feature is not available in FreeReport';
    end;
{$ENDIF}
  end;

  procedure CreateCategories;
  var
    i: Integer;
  begin
{$IFNDEF FPC}
    for i := ObjCount downto 0 do
{$ELSE}
    for i := 0 to ObjCount do
{$ENDIF}
    begin
      Item := frxObjects[i];
      if (Item.ButtonBmp <> nil) and (Item.ButtonImageIndex = -1) then
      begin
        frxResources.SetObjectImages(Item.ButtonBmp);
        Item.ButtonImageIndex := frxResources.ObjectImages.Count - 1;
      end;
      if Item.ClassRef = nil then
        CreateButton(i, Item);
    end;
  end;

  procedure CreateObjects;
  var
    I: Integer;
  begin
{$IFNDEF FPC}
    for i := ObjCount downto 0 do
{$ELSE}
    for i := 0 to ObjCount do
{$ENDIF}
     begin
       Item := frxObjects[i];
       if (Item.ButtonBmp <> nil) and (Item.ButtonImageIndex = -1) then
       begin
         frxResources.SetObjectImages(Item.ButtonBmp);
         Item.ButtonImageIndex := frxResources.ObjectImages.Count - 1;
       end;

       if (Item.ClassRef <> nil) and (Item.CategoryName = '') then
         CreateButton(i, Item);
     end;
  end;

  function CreateToolButton(ImgIndex: Integer; onClickEvent: TNotifyEvent; IsDown: Boolean = False): TToolButton;
  begin
    Result := TToolButton.Create(Self);
    with Result do
    begin
      Parent := ObjectsTB1;
{$IFDEF FPC}
      SetButtonBouns(Result);
{$ENDIF}
      Tag := 1000;
      Grouped := True;
      ImageIndex := ImgIndex;
      Style := tbsCheck;
      OnClick := onClickEvent;
      Wrap := True;
      Down := IsDown;
    end;
  end;

begin

  ObjCount := frxObjects.Count - 1;
{$IFDEF FPC}
  ObjectsTB1.BeginUpdate;
  ObjectSelectB := CreateToolButton(0, SelectToolBClick, True);
  HandToolB := CreateToolButton(27, SelectToolBClick);
  ZoomToolB:= CreateToolButton(28, SelectToolBClick);
  TextToolB := CreateToolButton(29, SelectToolBClick);
  FormatToolB := CreateToolButton(30, SelectToolBClick);
  ObjectBandB := CreateToolButton(1, ObjectBandBClick);
  { add object buttons }
  CreateObjects;
  { add category buttons }
  CreateCategories;
  ObjectsTB1.EndUpdate;
  ObjectsTB1.Update;
{$ELSE}
  { add category buttons }
  CreateCategories;
  { add object buttons }
  CreateObjects;
  ObjectBandB := CreateToolButton(1, ObjectBandBClick);
  FormatToolB := CreateToolButton(30, SelectToolBClick);
  TextToolB := CreateToolButton(29, SelectToolBClick);
  ZoomToolB:= CreateToolButton(28, SelectToolBClick);
  HandToolB := CreateToolButton(27, SelectToolBClick);
  ObjectSelectB := CreateToolButton(0, SelectToolBClick, True);
{$ENDIF}


end;

procedure TfrxDesignerForm.CreateExtraToolbar;
var
  i: Integer;
  Item: TfrxWizardItem;
  b: TToolButton;
begin
  for i := 0 to frxWizards.Count - 1 do
  begin
    Item := frxWizards[i];
    if Item.IsToolbarWizard then
    begin
      b := TToolButton.Create(Self);
      with b do
      begin
        Tag := i;
        if (Item.ButtonBmp <> nil) and (Item.ButtonImageIndex = -1) then
        begin
          frxResources.SetButtonImages(Item.ButtonBmp);
          Item.ButtonImageIndex := frxResources.MainButtonImages.Count - 1;
        end;
        ImageIndex := Item.ButtonImageIndex;
        Hint := Item.ClassRef.GetDescription;
        SetBounds(1000, 0, 22, 22);
        Parent := ExtraToolsTB;
      end;
      b.OnClick := OnExtraToolClick;
    end;
  end;

  ExtraToolsTB.Height := 27;
  ExtraToolsTB.Width := 27;
end;

procedure TfrxDesignerForm.AttachDialogFormEvents(Attach: Boolean);
{$IFDEF DELPHI24}
var
  SaveCWidth, SaveCHeight: Integer;
{$ENDIF}
begin
  if Attach then
  begin
{$IFDEF DELPHI24}
    SaveCWidth := FDialogForm.ClientWidth;
    SaveCHeight := FDialogForm.ClientHeight;
{$ENDIF}
    FDialogForm.Parent := GetParentForm(DockTop);
{$IFDEF DELPHI24}
    FDialogForm.ClientWidth := SaveCWidth;
    FDialogForm.ClientHeight := SaveCHeight;
{$ENDIF}
    FDialogForm.OnModify := DialogFormModify;
    FDialogForm.OnKeyDown := DialogFormKeyDown;
    FDialogForm.OnKeyUp := DialogFormKeyUp;
    FDialogForm.OnKeyPress := DialogFormKeyPress;
  end
  else
    if FDialogForm <> nil then
    begin
      FDialogForm.Hide;
      FWorkspace.Parent := nil;
      FDialogForm.Parent := nil;
      FDialogForm.OnModify := nil;
      FDialogForm.OnKeyDown := nil;
      FDialogForm.OnKeyUp := nil;
      FDialogForm.OnKeyPress := nil;
      FDialogForm := nil;
    end;
end;

procedure TfrxDesignerForm.ReloadReport;
var
  i: Integer;
  l: TList;
  c: TfrxComponent;
  p: TfrxPage;
  isDMP: Boolean;
begin
  if Report.PagesCount = 0 then
  begin
    isDMP := Report.DotMatrixReport;
    p := TfrxDataPage.Create(Report);
    p.Name := 'Data';
    if isDMP then
      p := TfrxDMPPage.Create(Report)
    else
    begin
      p := TfrxReportPage.Create(Report);
      TfrxReportPage(p).SetDefaults;
    end;
    p.Name := 'Page1';
  end;

  if not IsPreviewDesigner then
    Report.CheckDataPage;

  LangCB.ItemIndex := LangCB.Items.IndexOf(Report.ScriptLanguage);
  CodeWindow.Lines := Report.ScriptText;
  UpdateSyntaxType;
  ReloadPages(-2);
  UpdateRecentFiles(Report.FileName);
  UpdateCaption;
  UpdateStyles;

  FPictureCache.Clear;
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if c is TfrxPictureView then
      FPictureCache.AddPicture(TfrxPictureView(c));
  end;

  FUndoBuffer.ClearUndo;
  Modified := False;
end;

procedure TfrxDesignerForm.ReloadPages(Index: Integer);
var
  i: Integer;
  c: TfrxPage;
  s: String;
begin
  FCodeWindow.Script := Report.Script;
  Report.Script.AddRTTI;
  FCodeWindow.FillRtti;
  AttachDialogFormEvents(False);
  FTabs.Tabs.BeginUpdate;
  FTabs.Tabs.Clear;
  FTabs.Tabs.Add(frxResources.Get('dsCode'));

  for i := 0 to Report.PagesCount - 1 do
  begin
    c := Report.Pages[i];
    c.IsDesigning := True;
    if (c is TfrxReportPage) and (TfrxReportPage(c).Subreport <> nil) then
      s := TfrxReportPage(c).Subreport.Name
    else if c is TfrxDataPage then
      s := frxResources.Get('dsData')
    else if c.Name = '' then
      s := frxResources.Get('dsPage') + IntToStr(i + 1) else
      s := c.Name;
    FTabs.Tabs.Add(s);
  end;

  FTabs.Tabs.EndUpdate;

  if Index = -1 then
    Page := nil
  else if Index = -2 then
  begin
    Page := nil;
    for i := 0 to Report.PagesCount - 1 do
    begin
      c := Report.Pages[i];
      if not (c is TfrxDataPage) then
      begin
        Page := c;
        break;
      end;
    end;
  end
  else if Index < Report.PagesCount then
    Page := Report.Pages[Index] else
    Page := Report.Pages[0];
end;

procedure TfrxDesignerForm.ReloadObjects(ResetSelection: Boolean = True);
var
  i: Integer;
begin
  FObjects.Clear;
  if ResetSelection then
    FSelectedObjects.Clear;

  for i := 0 to FPage.AllObjects.Count - 1 do
    FObjects.Add(FPage.AllObjects[i]);

  FObjects.Add(Report);
  FObjects.Add(FPage);
  if ResetSelection then
    FSelectedObjects.Add(FPage);
  FWorkspace.Page := FPage;
  FWorkspace.EnableUpdate;
  FWorkspace.AdjustBands;
  FInspector.EnableUpdate;

  if FShowGuides then
  begin
    TopRuler.Guides := TDesignerWorkspace(FWorkspace).VGuides;
    LeftRuler.Guides := TDesignerWorkspace(FWorkspace).HGuides;
  end
  else
  begin
    TopRuler.Guides := nil;
    LeftRuler.Guides := nil;
  end;

  UpdateDataTree;
  FReportTree.UpdateItems;
  if ResetSelection then
    OnSelectionChanged(Self);
end;

procedure TfrxDesignerForm.SetReportDefaults;
begin
  if frxDesignerComp <> nil then
  begin
    Report.ScriptLanguage := frxDesignerComp.DefaultScriptLanguage;
    frxEmptyCode(CodeWindow.Lines, Report.ScriptLanguage);
    UpdateSyntaxType;
    LangCB.ItemIndex := LangCB.Items.IndexOf(Report.ScriptLanguage);

    with TfrxReportPage(Report.Pages[1]) do
    begin
      LeftMargin := frxDesignerComp.DefaultLeftMargin;
      BottomMargin := frxDesignerComp.DefaultBottomMargin;
      RightMargin := frxDesignerComp.DefaultRightMargin;
      TopMargin := frxDesignerComp.DefaultTopMargin;
      PaperSize := frxDesignerComp.DefaultPaperSize;
      Orientation := frxDesignerComp.DefaultOrientation;
    end;
  end
  else
  begin
    Report.ScriptLanguage := 'PascalScript';
    frxEmptyCode(CodeWindow.Lines, Report.ScriptLanguage);
    UpdateSyntaxType;
    LangCB.ItemIndex := LangCB.Items.IndexOf(Report.ScriptLanguage);

    TfrxReportPage(Report.Pages[1]).SetDefaults;
  end;
  Report.ScriptText.Text := CodeWindow.Lines.Text;
end;

procedure TfrxDesignerForm.UpdatePageDimensions;
var
  h: Extended;
begin
  if FPage is TfrxReportPage then
  begin
    with FPage as TfrxReportPage do
    begin
      ScrollBox.HorzScrollBar.Position := 0;
      ScrollBox.VertScrollBar.Position := 0;

      FWorkspace.Origin := Point(10, 10);
      h := PaperHeight;
      if LargeDesignHeight then
        h := h * 8;
      FWorkspace.SetPageDimensions(
        Round(PaperWidth * 96 / 25.4),
        Round(h * 96 / 25.4),
        Rect(Round(LeftMargin * 96 / 25.4), Round(TopMargin * 96 / 25.4),
             Round(RightMargin * 96 / 25.4), Round(BottomMargin * 96 / 25.4)));
    end;
  end
  else if FPage is TfrxDataPage then
  begin
    ScrollBox.HorzScrollBar.Position := 0;
    ScrollBox.VertScrollBar.Position := 0;

    FWorkspace.Origin := Point(0, 0);
    FWorkspace.SetPageDimensions(
      Round(FPage.Width),
      Round(FPage.Height),
      Rect(0, 0, 0, 0));
  end;
end;

procedure TfrxDesignerForm.UpdateControls;

const WidthsArr: array[0..12] of Extended = (0.1, 0.5, 1, 1.5, 2, 3, 4, 5, 6, 7, 8, 9, 10);

var
  c: TfrxComponent;
  p1, p2, p3, p4: PPropInfo;
  Count, i: Integer;
  FontEnabled, AlignEnabled, IsReportPage: Boolean;
  Frame1Enabled, Frame2Enabled, Frame3Enabled, ObjSelected, DMPEnabled: Boolean;
  s: String;
  Frame: TfrxFrame;
  DMPFontStyle: TfrxDMPFontStyles;

  procedure SetEnabled(cAr: array of TControl; Enabled: Boolean);
  var
    i: Integer;
  begin
    for i := 0 to High(cAr) do
    begin
      cAr[i].Enabled := Enabled;
      if (cAr[i] is TToolButton) and not Enabled then
        TToolButton(cAr[i]).Down := False;
    end;
  end;

  procedure ButtonUp(cAr: array of TToolButton);
  var
    i: Integer;
  begin
    for i := 0 to High(cAr) do
      cAr[i].Down := False;
  end;

begin
  FUpdatingControls := True;

  Count := FSelectedObjects.Count;
  if Count > 0 then
  begin
    c := FSelectedObjects[0];
    p1 := GetPropInfo(PTypeInfo(c.ClassInfo), 'Font');
    p2 := GetPropInfo(PTypeInfo(c.ClassInfo), 'Frame');
    p3 := GetPropInfo(PTypeInfo(c.ClassInfo), 'Color');
    p4 := GetPropInfo(PTypeInfo(c.ClassInfo), 'Fill');
  end
  else
  begin
    c := nil;
    p1 := nil;
    p2 := nil;
    p3 := nil;
    p4 := nil;
  end;

  if Count = 1 then
  begin
    FontNameCB.Text := c.Font.Name;
    FontSizeCB.Text := IntToStr(c.Font.Size);

    BoldB.Down := fsBold in c.Font.Style;
    ItalicB.Down := fsItalic in c.Font.Style;
    UnderlineB.Down := fsUnderline in c.Font.Style;

    if c is TfrxCustomMemoView then
      with TfrxCustomMemoView(c) do
      begin
        TextAlignLeftB.Down := HAlign = haLeft;
        TextAlignCenterB.Down := HAlign = haCenter;
        TextAlignRightB.Down := HAlign = haRight;
        TextAlignBlockB.Down := HAlign = haBlock;

        TextAlignTopB.Down := VAlign = vaTop;
        TextAlignMiddleB.Down := VAlign = vaCenter;
        TextAlignBottomB.Down := VAlign = vaBottom;
        if not (c is TfrxDMPMemoView) then
          if Style = '' then
            StyleCB.Text := StyleCB.Items[0] else
            StyleCB.Text := Style;
      end;

    Frame := nil;
    if c is TfrxView then
      Frame := TfrxView(c).Frame
    else if c is TfrxReportPage then
      Frame := TfrxReportPage(c).Frame;

{$IFNDEF FPC}
    FrameWidthCB.Clear;
    for i := 0 to 12 do
      FrameWidthCB.Items.AddObject(FloatToStr(WidthsArr[i]), nil);
{$ENDIF}


    if Frame <> nil then
      with Frame do
      begin
        FrameTopB.Down := ftTop in Typ;
        FrameBottomB.Down := ftBottom in Typ;
        FrameLeftB.Down := ftLeft in Typ;
        FrameRightB.Down := ftRight in Typ;

        FrameWidthCB.Text := FloatToStr(Width);
      end;
  end
  else
  begin
    FontNameCB.Text := '';
    FontSizeCB.Text := '';
    FrameWidthCB.Text := '';

    ButtonUp([BoldB, ItalicB, UnderlineB, TextAlignLeftB, TextAlignCenterB,
      TextAlignRightB, TextAlignBlockB, TextAlignTopB, TextAlignMiddleB,
      TextAlignBottomB, FrameTopB, FrameBottomB, FrameLeftB,
      FrameRightB, FrameEditB]);
  end;
  RevertInheritedMI.Visible := Report.IsAncestor;
  RevertInheritedChildMI.Visible := RevertInheritedMI.Visible;
  RevertInheritedMI.Enabled := False;
  SelectAllOfTypeCmd.Enabled := False;
  if c <> nil then
  begin
    RevertInheritedMI.Enabled := c.IsAncestor;
    SelectAllOfTypeCmd.Enabled := (not (c is TfrxPage)) and (Count = 1);
  end;
  SelectAllOfTypeOnPageMI.Enabled := SelectAllOfTypeCmd.Enabled;
  RevertInheritedChildMI.Enabled := RevertInheritedMI.Enabled;
  FontEnabled := (p1 <> nil) and not (c is TfrxDMPPage) and (FPage <> nil);
  AlignEnabled := (c is TfrxCustomMemoView) and (FPage <> nil);
  Frame1Enabled := (p2 <> nil) and not (c is TfrxLineView) and
    not (c is TfrxShapeView) and not (c is TfrxDMPPage) and (FPage <> nil);
  Frame2Enabled := (p2 <> nil) and not (c is TfrxDMPPage) and (FPage <> nil);
  Frame3Enabled := (p3 <> nil) and not (c is TfrxDMPPage) and (FPage <> nil);
  IsReportPage := FPage is TfrxReportPage;
  ObjSelected := (Count <> 0) and (FPage <> nil) and (FSelectedObjects[0] <> FPage);
  DMPEnabled := (c is TfrxDMPMemoView) or (c is TfrxDMPLineView) or
    (c is TfrxDMPCommand) or (c is TfrxDMPPage);

  SetEnabled([FontNameCB, FontSizeCB, BoldB, ItalicB, UnderlineB, FontColorB],
    (FontEnabled or (Count > 1)) and not (FPage is TfrxDMPPage));
  SetEnabled([FontB], (FontEnabled or DMPEnabled or (Count > 1)));
  SetEnabled([TextAlignLeftB, TextAlignCenterB, TextAlignRightB,
    TextAlignBlockB, TextAlignTopB, TextAlignMiddleB, TextAlignBottomB],
    AlignEnabled or (Count > 1));
  SetEnabled([StyleCB, HighlightB, RotateB],
    (AlignEnabled or (Count > 1)) and not (FPage is TfrxDMPPage));
  SetEnabled([FrameTopB, FrameBottomB, FrameLeftB, FrameRightB, FrameAllB,
    FrameNoB, FrameEditB], Frame1Enabled or (Count > 1));
  SetEnabled([FrameColorB, FrameStyleB, FrameWidthCB],
    (Frame2Enabled or (Count > 1)) and not (FPage is TfrxDMPPage));
  SetEnabled([FillColorB], Frame3Enabled and not (FPage is TfrxDMPPage));
  SetEnabled([FillEditB], p4 <> nil);
  if Report.DotMatrixReport then
  begin
    FontB.DropDownMenu := DMPPopup;
    FontB.OnClick := nil;
  end
  else
  begin
    FontB.DropDownMenu := nil;
    FontB.OnClick := ToolButtonClick;
  end;

  DMPFontStyle := [];
  if c is TfrxDMPMemoView then
    DMPFontStyle := TfrxDMPMemoView(c).FontStyle;
  if c is TfrxDMPLineView then
    DMPFontStyle := TfrxDMPLineView(c).FontStyle;
  if c is TfrxDMPPage then
    DMPFontStyle := TfrxDMPPage(c).FontStyle;

  BoldMI.Checked := fsxBold in DMPFontStyle;
  ItalicMI.Checked := fsxItalic in DMPFontStyle;
  UnderlineMI.Checked := fsxUnderline in DMPFontStyle;
  SuperScriptMI.Checked := fsxSuperScript in DMPFontStyle;
  SubScriptMI.Checked := fsxSubScript in DMPFontStyle;
  CondensedMI.Checked := fsxCondensed in DMPFontStyle;
  WideMI.Checked := fsxWide in DMPFontStyle;
  N12cpiMI.Checked := fsx12cpi in DMPFontStyle;
  N15cpiMI.Checked := fsx15cpi in DMPFontStyle;

  UndoCmd.Enabled := Assigned(FUndoBuffer) and (FUndoBuffer.UndoCount > 1);
  RedoCmd.Enabled := Assigned(FUndoBuffer) and (FUndoBuffer.RedoCount > 0) and (FPage <> nil);
  CutCmd.Enabled := ((Count <> 0) and (FSelectedObjects[0] <> FPage)) or (FPage = nil);
  CopyCmd.Enabled := CutCmd.Enabled;
  //{$IFNDEF LCLGTK2}
  TimerTimer(nil);
  //{$ENDIF}
  PageSettingsCmd.Enabled := IsReportPage and CheckOp(drDontChangePageOptions);
  DeletePageCmd.Enabled := (Report.PagesCount > 2) and (FPage <> nil) and
    not (FPage is TfrxDataPage) and CheckOp(drDontDeletePage) and
    not Page.IsAncestor;
  SaveCmd.Enabled := Modified and CheckOp(drDontSaveReport);
  DeleteCmd.Enabled := ObjSelected;
  SelectAllCmd.Enabled := (FObjects.Count > 2) or (FPage = nil);
  EditCmd.Enabled := (Count = 1) and (FPage <> nil);
  SetToGridB.Enabled := ObjSelected;
  BringToFrontCmd.Enabled := ObjSelected;
  SendToBackCmd.Enabled := ObjSelected;
  GroupCmd.Enabled := ObjSelected and (FSelectedObjects[0] <> Report);
  UngroupCmd.Enabled := GroupCmd.Enabled;
  ScaleCB.Enabled := IsReportPage;

  SetEnabled([HandToolB, ZoomToolB, TextToolB], IsReportPage);
  TabOrderMI.Visible := FPage is TfrxDialogPage;

  if Count <> 1 then
    s := ''
  else
  begin
    s := c.Name;
    if c is TfrxView then
      if TfrxView(c).IsDataField then
        s := s + ': ' + Report.GetAlias(TfrxView(c).DataSet) + '."' + TfrxView(c).DataField + '"'
      else if c is TfrxCustomMemoView then
        s := s + ': ' + Copy(TfrxCustomMemoView(c).Text, 1, 128);
    if c is TfrxDataBand then
      if TfrxDataBand(c).DataSet <> nil then
        s := s + ': ' + Report.GetAlias(TfrxDataBand(c).DataSet);
    if c is TfrxGroupHeader then
      s := s + ': ' + TfrxGroupHeader(c).Condition
  end;

  StatusBar.Panels[2].Text := s;

  FUpdatingControls := False;
end;

procedure TfrxDesignerForm.UpdateDataTree;
begin
  FDataTree.UpdateItems;
  FDataTree.CheclMultiSelection;
end;

procedure TfrxDesignerForm.UpdateInspector;
begin
  if Not FInspectorLock then
    FInspector.UpdateProperties;
end;

procedure TfrxDesignerForm.UpdateStyles;
begin
  Report.Styles.GetList(StyleCB.Items);
  StyleCB.Items.Insert(0, frxResources.Get('dsNoStyle'));
end;

procedure TfrxDesignerForm.UpdateSyntaxType;
begin
  CodeWindow.Syntax := Report.ScriptLanguage;
  if CompareText(Report.ScriptLanguage, 'PascalScript') = 0 then
  begin
    OpenScriptDialog.FilterIndex := 1;
    OpenScriptDialog.DefaultExt := 'pas';
    SaveScriptDialog.FilterIndex := 1;
    SaveScriptDialog.DefaultExt := 'pas';
  end
  else if CompareText(Report.ScriptLanguage, 'C++Script') = 0 then
  begin
    OpenScriptDialog.FilterIndex := 2;
    OpenScriptDialog.DefaultExt := 'cpp';
    SaveScriptDialog.FilterIndex := 2;
    SaveScriptDialog.DefaultExt := 'cpp';
  end
  else if CompareText(Report.ScriptLanguage, 'JScript') = 0 then
  begin
    OpenScriptDialog.FilterIndex := 3;
    OpenScriptDialog.DefaultExt := 'js';
    SaveScriptDialog.FilterIndex := 3;
    SaveScriptDialog.DefaultExt := 'js';
  end
  else if CompareText(Report.ScriptLanguage, 'BasicScript') = 0 then
  begin
    OpenScriptDialog.FilterIndex := 4;
    OpenScriptDialog.DefaultExt := 'vb';
    SaveScriptDialog.FilterIndex := 4;
    SaveScriptDialog.DefaultExt := 'vb';
  end
  else
  begin
    OpenScriptDialog.FilterIndex := 5;
    OpenScriptDialog.DefaultExt := '';
    SaveScriptDialog.FilterIndex := 5;
    SaveScriptDialog.DefaultExt := '';
  end
end;

procedure TfrxDesignerForm.UpdateVirtualGuids(Sender: TObject; Position: Extended);
var
  TopR, LeftR: Extended;
begin
  TopR := 0;
  LeftR := 0;
  if Sender = LeftRuler then
    TopR := Position
  else if Sender = TopRuler then
    LeftR := Position;
  FWorkspace.SetVirtualGuids(LeftR, TopR);
  FWorkspace.Invalidate;
end;

procedure TfrxDesignerForm.FindOrReplace(replace: Boolean);
begin
  with TfrxSearchDialog.Create(Application) do
  begin
    FSearchReplace := replace;
    if FSearchReplace then
      ReplacePanel.Show;
    if Page <> nil then
      TopCB.Enabled := False;
    if ShowModal = mrOk then
    begin
      FSearchText := TextE.Text;
      FSearchReplaceText := ReplaceE.Text;
      FSearchCase := CaseCB.Checked;
      FSearchIndex := 0;
      if (Page = nil) and not TopCB.Checked then
        FSearchIndex := CodeWindow.GetPlainPos;
      FindNextCmd.Enabled := True;
      FindText;
    end;
    Free;
  end;
end;

procedure TfrxDesignerForm.Lock;
begin
{$IFDEF LCLGTK2}
 TopRuler.Guides := nil;
 LeftRuler.Guides := nil;
{$ENDIF}
  FObjects.Clear;
  FSelectedObjects.Clear;
  AttachDialogFormEvents(False);
  FWorkspace.DisableUpdate;
  FInspector.DisableUpdate;
end;

procedure TfrxDesignerForm.CreateColorSelector(Sender: TToolButton);
var
  AColor: TColor;
  i: Integer;
begin
  AColor := clBlack;
  for i := 0 to SelectedObjects.Count - 1 do
    if TObject(SelectedObjects[i]) is TfrxView then
    begin
      if Sender = FontColorB then
        AColor := TfrxView(SelectedObjects[i]).Font.Color
      else if Sender = FrameColorB then
        AColor := TfrxView(SelectedObjects[i]).Frame.Color
      else
      begin
        if TfrxView(SelectedObjects[i]).FillType = ftBrush then
          AColor := TfrxBrushFill(TfrxView(SelectedObjects[i]).Fill).BackColor;
      end;
      break;
    end;

  with TfrxColorSelector.Create(Sender) do
  begin
    Color := AColor;
    BtnCaption := frxResources.Get('dsColorOth');
    OnColorChanged := Self.OnColorChanged;
  end;
end;

procedure TfrxDesignerForm.SwitchToCodeWindow;
begin
  Page := nil;
end;

function TfrxDesignerForm.AskSave: Word;
begin
  if IsPreviewDesigner then
    Result := frxConfirmMsg(frxResources.Get('dsSavePreviewChanges'), mb_YesNoCancel)
  else
    Result := frxConfirmMsg(frxResources.Get('dsSaveChangesTo') + ' ' +
      GetReportName + '?', mb_YesNoCancel);
end;

function TfrxDesignerForm.CheckOp(Op: TfrxDesignerRestriction): Boolean;
begin
  Result := True;
  if (frxDesignerComp <> nil) and (Op in frxDesignerComp.Restrictions) then
    Result := False;
end;

function TfrxDesignerForm.GetPageIndex: Integer;
begin
  Result := Report.Objects.IndexOf(FPage);
end;

function TfrxDesignerForm.GetReportName: String;
begin
  if Report.FileName = '' then
    Result := 'Untitled.'+ FTemplateExt else
    Result := ExtractFileName(Report.FileName);
end;

procedure TfrxDesignerForm.LoadFile(FileName: String; UseOnLoadEvent: Boolean);
var
  SaveSilentMode: Boolean;

  function SaveCurrentFile: Boolean;
  var
    w: Word;
  begin
    Result := True;
    if Modified then
    begin
      w := AskSave;
      if w = mrYes then
        SaveFile(False, UseOnLoadEvent)
      else if w = mrCancel then
        Result := False;
    end;
  end;

  procedure EmptyReport;
  var
    p: TfrxPage;
  begin
    Report.Clear;
    p := TfrxDataPage.Create(Report);
    p.Name := 'Data';
    p := TfrxReportPage.Create(Report);
    p.Name := 'Page1';
  end;

  procedure Error;
  begin
    frxErrorMsg(frxResources.Get('dsCantLoad'));
  end;

begin
  SaveSilentMode := Report.EngineOptions.SilentMode;
  Report.EngineOptions.SilentMode := False;
  FCodeWindow.SavePBToIni(Report.IniFile, 'Form5.TfrxDesignerForm\BreakPoints\' + ExtractFileName(Report.FileName));
  if FileName <> '' then  // call from recent filelist
  begin
    if SaveCurrentFile then
    begin
      Lock;
        if UseOnLoadEvent and (frxDesignerComp <> nil) and
          Assigned(frxDesignerComp.FOnLoadRecentReport) then
        begin
          if frxDesignerComp.FOnLoadRecentReport(Report, FileName) then
            ReloadReport else
            ReloadPages(-2);
        end
        else
        begin
          try
            if not Report.LoadFromFile(FileName) then
              Error;
            except
              EmptyReport;
              ReloadReport;
            end;
        end;
    end;
    Report.EngineOptions.SilentMode := SaveSilentMode;
    ReloadReport;
    FCodeWindow.LoadPBFromIni(Report.IniFile, 'Form5.TfrxDesignerForm\BreakPoints\' + ExtractFileName(Report.FileName));
    Exit;
  end;

  if UseOnLoadEvent then
    if (frxDesignerComp <> nil) and Assigned(frxDesignerComp.FOnLoadReport) then
    begin
      Lock;
      if frxDesignerComp.FOnLoadReport(Report) then
        ReloadReport else
        ReloadPages(-2);
      Report.EngineOptions.SilentMode := SaveSilentMode;
      Exit;
    end;


  if frxDesignerComp <> nil then

    OpenDialog.InitialDir := frxDesignerComp.OpenDir;
  if OpenDialog.Execute then
  begin
    if SaveCurrentFile then
    begin
      Lock;
      if not Report.LoadFromFile(OpenDialog.FileName) then
      begin
        Error;
        EmptyReport;
      end;
    end;
    Report.EngineOptions.SilentMode := SaveSilentMode;
    ReloadReport;
  end;
  FCodeWindow.LoadPBFromIni(Report.IniFile, 'Form5.TfrxDesignerForm\BreakPoints\' + ExtractFileName(Report.FileName));
end;

procedure TfrxDesignerForm.LoadFilter(aFilter: TfrxCustomIOTransport; FileName: String;
  UseOnLoadEvent: Boolean);
var
  SaveSilentMode: Boolean;

  function SaveCurrentFile: Boolean;
  var
    w: Word;
  begin
    Result := True;
    if Modified then
    begin
      w := AskSave;
      if w = mrYes then
        SaveFile(False, UseOnLoadEvent)
      else if w = mrCancel then
        Result := False;
    end;
  end;

  procedure EmptyReport;
  var
    p: TfrxPage;
  begin
    Report.Clear;
    p := TfrxDataPage.Create(Report);
    p.Name := 'Data';
    p := TfrxReportPage.Create(Report);
    p.Name := 'Page1';
  end;

  procedure Error;
  begin
    frxErrorMsg(frxResources.Get('dsCantLoad'));
  end;

begin
  FCodeWindow.SavePBToIni(Report.IniFile, 'Form5.TfrxDesignerForm\BreakPoints\' + ExtractFileName(Report.FileName));
  SaveSilentMode := Report.EngineOptions.SilentMode;
  Report.EngineOptions.SilentMode := False;

  if FileName <> '' then  // call from recent filelist
  begin
    if SaveCurrentFile then
    begin
      Lock;
        if UseOnLoadEvent and (frxDesignerComp <> nil) and
          Assigned(frxDesignerComp.FOnLoadRecentReport) then
        begin
          if frxDesignerComp.FOnLoadRecentReport(Report, FileName) then
            ReloadReport else
            ReloadPages(-2);
        end
        else
        begin
          try
            Report.LoadFromFile(FileName, True);
          except
            Error;
            EmptyReport;
            ReloadReport;
          end;
        end;
    end;
    Report.EngineOptions.SilentMode := SaveSilentMode;
    ReloadReport;
    Exit;
  end;

  if UseOnLoadEvent then
    if (frxDesignerComp <> nil) and Assigned(frxDesignerComp.FOnLoadReport) then
    begin
      Lock;
      if frxDesignerComp.FOnLoadReport(Report) then
        ReloadReport else
        ReloadPages(-2);
      Report.EngineOptions.SilentMode := SaveSilentMode;
      Exit;
    end;

  if not Assigned(aFilter) then Exit;

  if frxDesignerComp <> nil then
    aFilter.DefaultPath := frxDesignerComp.OpenDir;

  if SaveCurrentFile then
  begin
    Lock;
    aFilter.Report := Report;
    aFilter.DefaultExt := FTemplateExt;
    aFilter.FileName := ExtractFileName(Report.FileName);
    aFilter.FilterString := frxGet(2471);

    try
      if Report.ProcessIOTransport(aFilter, '', faRead) then
      begin
        Report.EngineOptions.SilentMode := SaveSilentMode;
        ReloadReport;
      end
      else if Report.Errors.Count > 0 then
        raise Exception.Create(Report.Errors.Text);
    except
      //Error;
      EmptyReport;
      ReloadReport;
    end;
  end;
  FCodeWindow.LoadPBFromIni(Report.IniFile, 'Form5.TfrxDesignerForm\BreakPoints\' + ExtractFileName(Report.FileName));
end;

function TfrxDesignerForm.SaveFile(SaveAs: Boolean; UseOnSaveEvent: Boolean): Boolean;
var
  Filter: TfrxCustomIOTransport;
begin
  if (SaveAs or (Report.FileName = '')) and Assigned(frxDefaultIODialogTransportClass) then
    Filter := frxDefaultIODialogTransportClass.CreateNoRegister
  else
    Filter := frxDefaultIOTransportClass.CreateNoRegister;
  try
    Filter.CreatedFrom := fvDesigner;
    Filter.DefaultExt := '.fr3';
    Result := IOTransport(Filter, SaveAs, UseOnSaveEvent);
  finally
    Filter.Free;
  end;
end;

function TfrxDesignerForm.IOTransport(aFilter: TfrxCustomIOTransport; SaveAs,
  UseOnSaveEvent: Boolean): Boolean;
var
  Saved: Boolean;
  {FilterCount, }i: Integer;
begin
  Result := True;
  Report.ScriptText := CodeWindow.Lines;
  for i := 0 to Report.ScriptText.Count - 1 do
    Report.ScriptText.Strings[i] := TrimRight(Report.ScriptText.Strings[i]);
  Report.ReportOptions.LastChange := Now;

  if UseOnSaveEvent then
    if (frxDesignerComp <> nil) and Assigned(frxDesignerComp.FOnSaveReport) then
    begin
      if frxDesignerComp.FOnSaveReport(Report, SaveAs) then
      begin
        UpdateRecentFiles(Report.FileName);
        UpdateCaption;
        Modified := False;
      end;
      Exit;
    end;

  Saved := True;
  if (SaveAs or (Report.FileName = '')) and (aFilter <> nil) then
  begin
    aFilter.Report := Report;
    aFilter.DefaultExt := '.' + FTemplateExt;
    aFilter.FileName := GetReportName;
    aFilter.FilterString := frxResources.Get('dsRepFilter');

    if frxDesignerComp <> nil then
      aFilter.DefaultPath := frxDesignerComp.SaveDir;
    Saved := Report.SaveToFilter(aFilter, '');
  end
  else
    Report.SaveToFile(Report.FileName);

  UpdateRecentFiles(Report.FileName);
  UpdateCaption;
  if Saved then
    Modified := False;
  Result := Saved;
end;

procedure TfrxDesignerForm.UpdateCaption;
begin
{$IFDEF FR_LITE}
  Caption := 'FreeReport - ' + GetReportName;
{$ELSE}
  Caption := 'FastReport - ' + GetReportName;
{$ENDIF}
end;

procedure TfrxDesignerForm.UpdateRecentFiles(NewFile: String);
var
  i: Integer;
  m: TMenuItem;
begin
  if NewFile <> '' then
  begin
    if FRecentFiles.IndexOf(NewFile) <> -1 then
      FRecentFiles.Delete(FRecentFiles.IndexOf(NewFile));
    FRecentFiles.Add(NewFile);
    while FRecentFiles.Count > 8 do
      FRecentFiles.Delete(0);
  end;

  SepMI11.Visible := FRecentFiles.Count <> 0;

  for i := FileMenu.Count - 1 downto 0 do
  begin
    m := FileMenu.Items[i];
    if m.Tag = 100 then
      m.Free;
  end;

  if CheckOp(drDontShowRecentFiles) then
    for i := FRecentFiles.Count - 1 downto 0 do
    begin
      m := TMenuItem.Create(FileMenu);
      m.Caption := FRecentFiles[i];
      m.OnClick := OpenRecentFile;
      m.Tag := 100;
      FileMenu.Insert(FileMenu.IndexOf(SepMI4), m);
    end;
end;

type
  THackToolBar = class(TToolBar);
procedure TfrxDesignerForm.SwitchToolbar;
var
  i: Integer;
  Item: TfrxObjectItem;
  b: TToolButton;
  Category: TfrxObjectCategories;
  IsToolandBand: Boolean;

  function GetCategory(Category: Integer): TfrxObjectCategories;
  var
    i: Integer;
    Item: TfrxObjectItem;
  begin
    Result := [];
    for i := 0 to frxObjects.Count - 1 do
    begin
      Item := frxObjects[i];
      if (Item.ClassRef <> nil) and
         (Item.CategoryName = frxObjects[Category].CategoryName) then
      begin
        Result := Item.Category;
        break;
      end;
    end;
  end;

begin
  ObjectSelectB.Down := True;
  SelectToolBClick(nil);
{$IFDEF FPC}
  for i := 0 to ObjectsTB1.ControlCount - 1 do
{$ELSE}
  for i := ObjectsTB1.ControlCount - 1 downto 0 do
{$ENDIF}
  begin
    b := TToolButton(ObjectsTB1.Controls[i]);
    if b <> ObjectSelectB then
    begin
      IsToolandBand := False;
      Category := [];

      if b.Tag = 1000 then  { tools and band }
        IsToolandBand := True
      else                  { object or category }
      begin
        Item := frxObjects[b.Tag];
        if Item.ClassRef <> nil then  { object }
          Category := Item.Category
        else
          Category := GetCategory(b.Tag);
      end;

      if FPage is TfrxDialogPage then
        b.Visible := ctDialog in Category
      else if FPage is TfrxDMPPage then
        b.Visible := (ctDMP in Category) or IsToolandBand
      else if FPage is TfrxReportPage then
        b.Visible := (ctReport in Category) or IsToolandBand
      else if FPage is TfrxDataPage then
        b.Visible := ctData in Category
      else if FPage = nil then
        b.Visible := False;
{$IFDEF FPC}
      { Lazarus doesn't realign invisible buttons }
      if b.Visible then
        b.Height := ObjectsTB1.ButtonHeight
      else
        b.Height := 0;
      if (i > 0) then
      begin
        b.Top :=  TToolButton(ObjectsTB1.Controls[i - 1]).Top +
           TToolButton(ObjectsTB1.Controls[i - 1]).Height;
      end;
{$ENDIF}
    end;
  end;
end;

function TfrxDesignerForm.mmToUnits(mm: Extended; X: Boolean = True): Extended;
begin
  Result := 0;
  case FUnits of
    duCM:
      Result := mm / 10;
    duInches:
      Result := mm / 25.4;
    duPixels:
      Result := mm * 96 / 25.4;
    duChars:
      if X then
        Result := Round(mm * fr01cm / fr1CharX) else
        Result := Round(mm * fr01cm / fr1CharY);
  end;
end;

function TfrxDesignerForm.UnitsTomm(mm: Extended; X: Boolean = True): Extended;
begin
  Result := 0;
  case FUnits of
    duCM:
      Result := mm * 10;
    duInches:
      Result := mm * 25.4;
    duPixels:
      Result := mm / 96 * 25.4;
    duChars:
      if X then
        Result := Round(mm) * fr1CharX / fr01cm  else
        Result := Round(mm) * fr1CharY / fr01cm;
  end;
end;

function TfrxDesignerForm.InsertExpression(const Expr: String): String;
begin
  with TfrxExprEditorForm.Create(Self) do
  begin
    ExprMemo.Text := Expr;
    if ShowModal = mrOk then
      Result := ExprMemo.Text else
      Result := '';
    Free;
  end
end;

procedure TfrxDesignerForm.UpdatePage;
begin
{$IFDEF FPC}
  frxUpdateControl(FWorkspace);
{$ELSE}
  FWorkspace.Repaint;
{$ENDIF}
end;

procedure TfrxDesignerForm.FindText;
var
  i: Integer;
  c: TfrxComponent;
  s: String;
  Found, FoundOne: Boolean;
  Flags: TReplaceFlags;
  ReplaceAll: Boolean;

  function AskReplace: Boolean;
  var
    i: Integer;
  begin
    if not ReplaceAll then
      i := MessageDlg(Format(frxResources.Get('dsReplace'), [FSearchText]),
        mtConfirmation, [mbYes, mbNo, mbCancel, mbAll], 0)
    else
      i := mrAll;
    Result := i in [mrYes, mrAll];
    ReplaceAll := i = mrAll;

{    Result := Application.MessageBox(
      PChar(Format(frxResources.Get('dsReplace'), [FSearchText])),
      PChar(frxResources.Get('mbConfirm')), mb_IconQuestion + mb_YesNo) = mrYes;}
  end;

begin
  ReplaceAll := False;
  FoundOne := False;

  repeat
    Found := False;
    if FPage <> nil then
    begin
      c := nil;
      for i := FSearchIndex to Objects.Count - 1 do
      begin
        c := Objects[i];
        if c is TfrxCustomMemoView then
        begin
          s := TfrxCustomMemoView(c).Text;
          if FSearchCase then
          begin
            if Pos(FSearchText, s) <> 0 then
              Found := True;
          end
          else if Pos(AnsiUpperCase(FSearchText), AnsiUpperCase(s)) <> 0 then
            Found := True;
        end;
        if Found then break;
      end;

      if Found then
      begin
        FSearchIndex := i + 1;
        SelectedObjects.Clear;
        SelectedObjects.Add(c);
        OnSelectionChanged(Self);
        if FSearchReplace then
          if AskReplace then
          begin
            Flags := [rfReplaceAll];
            if not FSearchCase then
              Flags := Flags + [rfIgnoreCase];
            TfrxCustomMemoView(c).Text := StringReplace(s, FSearchText,
              FSearchReplaceText, Flags);
            Modified := True;
          end;
      end;
    end
    else
    begin
      Found := CodeWindow.Find(FSearchText, FSearchCase, FSearchIndex);
      if FSearchReplace then
        if Found and AskReplace then
        begin
          CodeWindow.SelText := FSearchReplaceText;
          Modified := True;
        end;
    end;

    if Found then
      FoundOne := True;
  until not ReplaceAll or not Found;

  if not FoundOne then
    frxInfoMsg(Format(frxResources.Get('dsTextNotFound'), [FSearchText]));
end;

procedure TfrxDesignerForm.RestorePagePosition;
var
  pt: TPoint;
begin
  if (FTabs.TabIndex > 0) and (FTabs.TabIndex < 255) then
  begin
    pt := fsPosToPoint(FPagePositions[FTabs.TabIndex]);
    ScrollBox.VertScrollBar.Position := pt.X;
    ScrollBox.HorzScrollBar.Position := pt.Y;
  end;
end;

procedure TfrxDesignerForm.SavePagePosition;
begin
  if (FTabs.TabIndex > 0) and (FTabs.TabIndex < 255) then
    FPagePositions[FTabs.TabIndex] := IntToStr(ScrollBox.HorzScrollBar.Position) +
      ':' + IntToStr(ScrollBox.VertScrollBar.Position);
end;


{ Workspace/Inspector event handlers }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.OnModify(Sender: TObject);
begin
  FModifiedBy := Sender;
  Modified := True;
end;

procedure TfrxDesignerForm.OnSaveFilterExecute(Sender: TObject);
var
  Filter: TfrxCustomIOTransport;
begin
  Filter := TfrxCustomIOTransport(FFilterList.Objects[TComponent(Sender).Tag]).CreateFilterClone(fvDesigner);
  try
    IOTransport(Filter, True, False);
  finally
    TfrxCustomIOTransport(FFilterList.Objects[TComponent(Sender).Tag]).AssignSharedProperties(Filter);
    Filter.Free;
  end;
end;

procedure TfrxDesignerForm.OnSelectionChanged(Sender: TObject);
var
  c: TfrxComponent;
begin
  if FLockSelectionChanged then Exit;
  if (Sender = FReportTree) and Assigned(SelectedObjects) and
     (SelectedObjects.Count > 0) then
  begin
    if TObject(SelectedObjects[0]) is TfrxComponent then
    begin
      c := SelectedObjects[0];
      if (c <> Report) and (Page <> nil) then
        if (c <> nil) and (c.Page <> Page) then
        begin
          FWorkspace.Page := c.Page;
          Page := c.Page;
          SelectedObjects[0] := c;
          FReportTree.UpdateSelection;
        end;
    end;
  end
  else
    FReportTree.UpdateSelection;

  if Sender <> FWorkspace then
    FWorkspace.UpdateView;

  if Sender <> FInspector then
  begin
    FInspector.Objects := FObjects;
    FInspector.UpdateProperties;
  end;

  FDataTree.UpdateSelection;
  UpdateControls;
end;

procedure TfrxDesignerForm.OnEditObject(Sender: TObject);
var
  ed: TfrxComponentEditor;
begin
  if FSelectedObjects[0] <> nil then
    if rfDontEdit in TfrxComponent(FSelectedObjects[0]).Restrictions then
      Exit;

  ed := frxComponentEditors.GetComponentEditor(FSelectedObjects[0], Self, nil);
  if (ed <> nil) and ed.HasEditor then
    if ed.Edit then
    begin
      Modified := True;
      if (FSelectedObjects.Count > 0) and (FSelectedObjects[0] = FPage) then
        UpdatePageDimensions;
    end;
  ed.Free;
end;

procedure TfrxDesignerForm.OnInsertObject(Sender: TObject);
var
  c: TfrxComponent;
  SaveLeft, SaveTop, SaveWidth, SaveHeight: Extended;
  SourcePage, DestPage: TfrxReportPage;

  function CheckContainers(Obj: TfrxComponent): Boolean;
  var
    i: Integer;
    c: TfrxComponent;
  begin
    Result := False;
    for i := 0 to FObjects.Count - 1 do
    begin
      c := FObjects[i];
      if (c <> Obj) and (csContainer in c.frComponentStyle) then
        if (Obj.Left >= c.AbsLeft) and (Obj.Top >= c.AbsTop) and
          (Obj.Left + Obj.Width <= c.AbsLeft + c.Width) and
          (Obj.Top + Obj.Height <= c.AbsTop + c.Height) then
      begin
        Result := c.ContainerAdd(Obj);
        break;
      end;
    end;
  end;

begin
  if (not CheckOp(drDontInsertObject) or (FWorkspace.Insertion.Top < 0)) then
  begin
    FWorkspace.SetInsertion(nil, 0, 0, 0);
    ObjectSelectB.Down := True;
    Exit;
  end;

  with FWorkspace.Insertion do
  begin
    if (ComponentClass = nil) or ((Width = 0) and (Height = 0)) then Exit;

    SaveLeft := Left;
    SaveTop := Top;
    SaveWidth := Width;
    SaveHeight := Height;
    c := TfrxComponent(ComponentClass.NewInstance);
    c.DesignCreate(FPage, Flags);
    c.SetBounds(SaveLeft, SaveTop, SaveWidth, SaveHeight);
    c.CreateUniqueName;
    if c is TfrxCustomLineView then
      FWorkspace.SetInsertion(ComponentClass, 0, 0, Flags)
    else
    begin
      FWorkspace.SetInsertion(nil, 0, 0, 0);
      if not TextToolB.Down then
        ObjectSelectB.Down := True;
    end;

    if (c is TfrxMemoView) or (c is TfrxSysMemoView) then
    begin
      FSampleFormat.ApplySample(TfrxCustomMemoView(c));
      if FPage is TfrxDataPage then
        TfrxCustomMemoView(c).Wysiwyg := False;
    end;

    if not CheckContainers(c) and (FObjects.IndexOf(c) = -1)  then
      FObjects.Add(c);
    FSelectedObjects.Clear;
    FSelectedObjects.Add(c);

    if (frxDesignerComp <> nil) and Assigned(frxDesignerComp.FOnInsertObject) then
      frxDesignerComp.FOnInsertObject(c);

    if c is TfrxSubreport then
    begin
      SourcePage := TfrxReportPage(FPage);
      NewPageCmdExecute(Self);
      TfrxSubreport(c).Page := TfrxReportPage(Report.Pages[Report.PagesCount - 1]);
      DestPage := TfrxSubreport(c).Page;
      DestPage.Orientation := SourcePage.Orientation;
      DestPage.SetSizeAndDimensions(SourcePage.PaperSize, SourcePage.PaperWidth, SourcePage.PaperHeight);

      DestPage.LeftMargin := SourcePage.LeftMargin;
      DestPage.RightMargin := SourcePage.RightMargin;
      DestPage.TopMargin := SourcePage.TopMargin;
      DestPage.BottomMargin := SourcePage.BottomMargin;

      DestPage.Bin := SourcePage.Bin;
      DestPage.BinOtherPages := SourcePage.BinOtherPages;

      DestPage.Columns := SourcePage.Columns;
      DestPage.ColumnWidth := SourcePage.ColumnWidth;
      DestPage.ColumnPositions.Assign(SourcePage.ColumnPositions);

      DestPage.PrintOnPreviousPage := SourcePage.PrintOnPreviousPage;
      DestPage.MirrorMargins := SourcePage.MirrorMargins;
      DestPage.EndlessWidth := SourcePage.EndlessWidth;
      DestPage.EndlessHeight := SourcePage.EndlessHeight;
      DestPage.LargeDesignHeight := SourcePage.LargeDesignHeight;
      DestPage.Duplex := SourcePage.Duplex;
      Modified := True;
      ReloadPages(Report.PagesCount - 1);
    end
    else
    begin
      Modified := True;
      if EditAfterInsert and not
        ((c is TfrxDialogControl) or (c is TfrxDialogComponent)) then
        OnEditObject(Self);
    end;

    FWorkspace.BringToFront;
  end;
end;

procedure TfrxDesignerForm.OnNotifyPosition(ARect: TfrxRect);
var
  dx, dy: Extended;
begin
  with ARect do
  begin
    if FUnits = duCM then
    begin
      dx := 1 / 96 * 2.54;
      dy := dx;
    end
    else if FUnits = duChars then
    begin
      dx := 1 / fr1CharX;
      dy := 1 / fr1CharY;
    end
    else if FUnits = duPixels then
    begin
      dx := 1;
      dy := dx;
    end
    else
    begin
      dx := 1 / 96;
      dy := dx;
    end;

    Left := Left * dx;
    Top := Top * dy;
    if FWorkspace.Mode <> dmScale then
    begin
      Right := Right * dx;
      Bottom := Bottom * dy;
    end;

    if FUnits = duChars then
    begin
      Left := Trunc(Left);
      Top := Trunc(Top);
      Right := Trunc(Right);
      Bottom := Trunc(Bottom);
    end;


    FCoord1 := '';
    FCoord2 := '';
    FCoord3 := '';
    if (not FWorkspace.IsMouseDown) and (FWorkspace.Mode <> dmInsertObject) then
      if (FSelectedObjects.Count > 0) and (FSelectedObjects[0] = FPage) then
        FCoord1 := Format('%f; %f', [Left, Top])
      else
      begin
        FCoord1 := Format('%f; %f', [Left, Top]);
        FCoord2 := Format('%f; %f', [Right, Bottom]);
      end
    else
    case FWorkspace.Mode of
      dmMove, dmSize, dmSizeBand, dmInsertObject, dmInsertLine:
        begin
          FCoord1 := Format('%f; %f', [Left, Top]);
          FCoord2 := Format('%f; %f', [Right, Bottom]);
        end;

      dmScale:
        begin
          FCoord1 := Format('%f; %f', [Left, Top]);
          FCoord3 := Format('%s%f; %s%f', ['%', Right * 100, '%', Bottom * 100]);
        end;
    end;
  end;

  LeftRuler.Position := ARect.Top;
  TopRuler.Position := ARect.Left;

  if FPage = nil then
    OnChangePosition(Self);

{$IFDEF FPC}
  frxUpdateControl(StatusBar);
{$ELSE}
  StatusBar.Repaint;
{$ENDIF}
end;

procedure TfrxDesignerForm.OnEnterWorkSpace(Sender: TObject);
begin
  TopRuler.MouseLeave;
  LeftRuler.MouseLeave;
  FWorkspace.SetVirtualGuids(0, 0);
  FWorkspace.Invalidate;
end;

{ Toolbar buttons' events }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.SelectToolBClick(Sender: TObject);
var
  t: TfrxDesignTool;
begin
  t := dtSelect;
  if HandToolB.Down then
    t := dtHand
  else if ZoomToolB.Down then
    t := dtZoom
  else if TextToolB.Down then
    t := dtText
  else if FormatToolB.Down then
    t := dtFormat;

  TDesignerWorkspace(FWorkspace).Tool := t;
  FWorkspace.SetInsertion(nil, 0, 0, 0);
end;

procedure TfrxDesignerForm.ObjectBandBClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := TControl(Sender).ClientToScreen(Point(TControl(Sender).Width, 0));
  BandsPopup.Popup(pt.X, pt.Y);
end;

procedure TfrxDesignerForm.ObjectsButtonClick(Sender: TObject);
var
  i: Integer;
  Obj, Item: TfrxObjectItem;
  c: TfrxComponent;
  dx, dy: Extended;
  m: TMenuItem;
  pt: TPoint;
  s: String;
begin
  SelectToolBClick(Sender);
  if Page = nil then Exit;
  Obj := frxObjects[TComponent(Sender).Tag];

  if Obj.ClassRef = nil then  { it's a category }
  begin
    while ObjectsPopup.Items.Count > 0 do
      ObjectsPopup.Items[0].Free;

    for i := 0 to frxObjects.Count - 1 do
    begin
      Item := frxObjects[i];
      if (Item.ClassRef <> nil) and (Item.CategoryName = Obj.CategoryName) then
      begin
        if FPage is TfrxDMPPage then
          if not ((Item.ClassRef.ClassName = 'TfrxCrossView') or
            (Item.ClassRef.ClassName = 'TfrxDBCrossView') or
            (Item.ClassRef.InheritsFrom(TfrxDialogComponent))) then continue;

        m := TMenuItem.Create(ObjectsPopup);
        m.ImageIndex := Item.ButtonImageIndex;
        s := Item.ButtonHint;
        if s = '' then
          s := Item.ClassRef.GetDescription else
          s := frxResources.Get(s);
        m.Caption := s;
        m.OnClick := ObjectsButtonClick;
        m.Tag := i;
        ObjectsPopup.Items.Add(m);
      end;
    end;

    pt := TControl(Sender).ClientToScreen(Point(TControl(Sender).Width, 0));
    ObjectsPopup.Popup(pt.X, pt.Y);
  end
  else  { it's a simple object }
  begin
    c := TfrxComponent(Obj.ClassRef.NewInstance);
    try
      // FireDac components may rise exception in constructor !
      c.Create(FPage);
    except
      Exit;
    end;
    dx := c.Width;
    dy := c.Height;
    c.Free;

    if (dx = 0) and (dy = 0) then
    begin
      dx := GetDefaultObjectSize.X;
      dy := GetDefaultObjectSize.Y;
    end;

    FWorkspace.SetInsertion(Obj.ClassRef, dx, dy, Obj.Flags);
  end;
end;

procedure TfrxDesignerForm.OnExtraToolClick(Sender: TObject);
var
  w: TfrxCustomWizard;
  Item: TfrxWizardItem;
begin
  Item := frxWizards[TToolButton(Sender).Tag];
  w := TfrxCustomWizard(Item.ClassRef.NewInstance);
  w.Create(Self);
  if w.Execute then
    Modified := True;
  w.Free;
end;

procedure TfrxDesignerForm.InsertBandClick(Sender: TObject);
var
  i: Integer;
  Band: TfrxBand;
  Size: Extended;

  function FindFreeSpace: Extended;
  var
    i: Integer;
    b: TfrxComponent;
  begin
    Result := 0;
    for i := 0 to FPage.Objects.Count - 1 do
    begin
      b := FPage.Objects[i];
      if (b is TfrxBand) and not TfrxBand(b).Vertical then
        if b.Top + b.Height > Result then
          Result := b.Top + b.Height;
    end;

    Result := Round((Result + Workspace.BandHeader + 4) / Workspace.GridY) * Workspace.GridY;
    Result := Round(Result * 100000000) / 100000000;
  end;

begin
  if Page = nil then Exit;

  i := (Sender as TMenuItem).Tag;

  Band := TfrxBand(frxBands[i mod 100].NewInstance);
  Band.Create(FPage);
  Band.CreateUniqueName;
{$IFNDEF RAD_ED}
  if i >= 100 then
    Band.Vertical := True;
{$ENDIF}

  if not Band.Vertical then
    if Workspace.FreeBandsPlacement then
      Band.Top := FindFreeSpace else
      Band.Top := 10000;

  Size := 0;
  case FUnits of
    duCM:     Size := fr01cm * 6;
    duInches: Size := fr01in * 3;
    duPixels: Size := 20;
    duChars:  Size := fr1CharY;
  end;

  if not Band.Vertical then
    Band.Height := Size
  else
  begin
    Band.Left := Size;
    Band.Width := Size;
  end;

  FObjects.Add(Band);
  FSelectedObjects.Clear;
  FSelectedObjects.Add(Band);
  Modified := True;
  OnSelectionChanged(Self);

  ObjectSelectB.Down := True;
  SelectToolBClick(Sender);

  if EditAfterInsert then
    OnEditObject(Self);
end;

procedure TfrxDesignerForm.ToolButtonClick(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
  wasModified: Boolean;
  gx, gy: Extended;
  TheFont: TFont;
  TheFrame: TfrxFrame;
  TheFill: TfrxCustomFill;

  procedure EditFont;
  begin
    with TFontDialog.Create(Application) do
    begin
      Font := TfrxComponent(FSelectedObjects[0]).Font;
      Options := Options + [fdForceFontExist];
      if Execute then
      begin
        TheFont := TFont.Create;
        TheFont.Assign(Font);
      end;
      Free;
    end;
  end;

  procedure EditFrame;
  begin
    with TfrxFrameEditorForm.Create(Self) do
    begin
      if TComponent(FSelectedObjects[0]) is TfrxView then
        Frame := TfrxView(FSelectedObjects[0]).Frame;
      if ShowModal = mrOk then
      begin
        TheFrame := TfrxFrame.Create;
        TheFrame.Assign(Frame);
      end;
      Free;
    end;
  end;

  procedure EditFill;
  begin
    with TfrxFillEditorForm.Create(Self) do
    begin
      if TComponent(FSelectedObjects[0]) is TfrxView then
        Fill := TfrxView(FSelectedObjects[0]).Fill;
      if TComponent(FSelectedObjects[0]) is TfrxShapeView then
        IsSimpleFill := True;
      if ShowModal = mrOk then
      begin
        TheFill := frxCreateFill(frxGetFillType(Fill));
        TheFill.Assign(Fill);
      end;
      Free;
    end;
  end;

  procedure SetFontStyle(c: TfrxComponent; fStyle: TFontStyle; Include: Boolean);
  begin
    with c.Font do
      if Include then
        Style := Style + [fStyle] else
        Style := Style - [fStyle];
  end;

  procedure SetFrameType(c: TfrxComponent; fType: TfrxFrameType; Include: Boolean);
  var
    f: TfrxFrame;
  begin
    if c is TfrxView then
      f := TfrxView(c).Frame
    else if c is TfrxReportPage then
      f := TfrxReportPage(c).Frame else
      Exit;

     with f do
      if Include then
        Typ := Typ + [fType] else
        Typ := Typ - [fType];
  end;

  procedure SetDMPFontStyle(c: TfrxComponent; fStyle: TfrxDMPFontStyle;
    Include: Boolean);
  var
    Style: TfrxDMPFontStyles;
  begin
    Style := [];
    if c is TfrxDMPMemoView then
      Style := TfrxDMPMemoView(c).FontStyle;
    if c is TfrxDMPLineView then
      Style := TfrxDMPLineView(c).FontStyle;
    if c is TfrxDMPPage then
      Style := TfrxDMPPage(c).FontStyle;
    if not Include then
      Style := Style + [fStyle] else
      Style := Style - [fStyle];
    if c is TfrxDMPMemoView then
      TfrxDMPMemoView(c).FontStyle := Style;
    if c is TfrxDMPLineView then
      TfrxDMPLineView(c).FontStyle := Style;
    if c is TfrxDMPPage then
      TfrxDMPPage(c).FontStyle := Style;
  end;

begin
  if FUpdatingControls then Exit;

  TheFont := nil;
  TheFrame := nil;
  TheFill := nil;
  wasModified := False;
  if TComponent(Sender).Tag = 43 then
    EditFont
  else if TComponent(Sender).Tag = 32 then
    EditFrame
  else if TComponent(Sender).Tag = 44 then
    EditFill;

  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if rfDontModify in c.Restrictions then continue;

    case TComponent(Sender).Tag of

      0:  c.Font.Name := FontNameCB.Text;

      1:  c.Font.Size := StrToIntDef(FontSizeCB.Text, c.Font.Size);

      2:  SetFontStyle(c, fsBold, BoldB.Down);

      3:  SetFontStyle(c, fsItalic, ItalicB.Down);

      4:  SetFontStyle(c, fsUnderline, UnderlineB.Down);

      5:  c.Font.Color := FColor;

      6:;

      7..10:
          if c is TfrxCustomMemoView then
            with TfrxCustomMemoView(c) do
              if TextAlignLeftB.Down then
                HAlign := haLeft
              else if TextAlignCenterB.Down then
                HAlign := haCenter
              else if TextAlignRightB.Down then
                HAlign := haRight
              else
                HAlign := haBlock;

      11..13:
          if c is TfrxCustomMemoView then
            with TfrxCustomMemoView(c) do
              if TextAlignTopB.Down then
                VAlign := vaTop
              else if TextAlignMiddleB.Down then
                VAlign := vaCenter
              else
                VAlign := vaBottom;

      20: SetFrameType(c, ftTop, FrameTopB.Down);

      21: SetFrameType(c, ftBottom, FrameBottomB.Down);

      22: SetFrameType(c, ftLeft, FrameLeftB.Down);

      23: SetFrameType(c, ftRight, FrameRightB.Down);

      24: begin
            SetFrameType(c, ftTop, True);
            SetFrameType(c, ftBottom, True);
            SetFrameType(c, ftLeft, True);
            SetFrameType(c, ftRight, True);
          end;

      25: begin
            SetFrameType(c, ftTop, False);
            SetFrameType(c, ftBottom, False);
            SetFrameType(c, ftLeft, False);
            SetFrameType(c, ftRight, False);
          end;

      26: if c is TfrxView then
          begin
            TfrxView(c).FillType := ftBrush;
            TfrxView(c).Color := FColor;
          end
          else if c is TfrxReportPage then
            TfrxReportPage(c).Color := FColor
          else if c is TfrxDialogPage then
          begin
            TfrxDialogPage(c).Color := FColor;
            FWorkspace.Color := FColor;
          end
          else if c is TfrxDialogControl then
            TfrxDialogControl(c).Color := FColor;

      27: if c is TfrxView then
            TfrxView(c).Frame.Color := FColor
          else if c is TfrxReportPage then
            TfrxReportPage(c).Frame.Color := FColor;

      28: if c is TfrxView then
            TfrxView(c).Frame.Style := FLineStyle
          else if c is TfrxReportPage then
            TfrxReportPage(c).Frame.Style := FLineStyle;

      29: if c is TfrxView then
            TfrxView(c).Frame.Width := frxStrToFloat(FrameWidthCB.Text)
          else if c is TfrxReportPage then
            TfrxReportPage(c).Frame.Width := frxStrToFloat(FrameWidthCB.Text);

      30: if c is TfrxCustomMemoView then
            TfrxCustomMemoView(c).Rotation := TMenuItem(Sender).HelpContext;

      31:
        begin
          gx := FWorkspace.GridX;
          gy := FWorkspace.GridY;
          c.Left := Round(c.Left / gx) * gx;
          c.Top := Round(c.Top / gy) * gy;
          c.Width := Round(c.Width / gx) * gx;
          c.Height := Round(c.Height / gy) * gy;
          if c.Width = 0 then
            c.Width := gx;
          if c.Height = 0 then
            c.Height := gy;
        end;

      32: if c is TfrxView then
            TfrxView(c).Frame := TheFrame
          else if c is TfrxReportPage then
            TfrxReportPage(c).Frame := TheFrame;

      33: if c is TfrxCustomMemoView then
            if StyleCB.ItemIndex = 0 then
              TfrxCustomMemoView(c).Style := '' else
              TfrxCustomMemoView(c).Style := StyleCB.Text;

      34: SetDMPFontStyle(c, fsxBold, BoldMI.Checked);

      35: SetDMPFontStyle(c, fsxItalic, ItalicMI.Checked);

      36: SetDMPFontStyle(c, fsxUnderline, UnderlineMI.Checked);

      37: SetDMPFontStyle(c, fsxSuperScript, SuperScriptMI.Checked);

      38: SetDMPFontStyle(c, fsxSubScript, SubScriptMI.Checked);

      39: SetDMPFontStyle(c, fsxCondensed, CondensedMI.Checked);

      40: SetDMPFontStyle(c, fsxWide, WideMI.Checked);

      41: SetDMPFontStyle(c, fsx12cpi, N12cpiMI.Checked);

      42: SetDMPFontStyle(c, fsx15cpi, N15cpiMI.Checked);

      43: if TheFont <> nil then
            c.Font := TheFont;
      44: if (c is TfrxView) and (TheFill <> nil) then
            TfrxView(c).Fill := TheFill;
    end;

    if TComponent(Sender).Tag in [0..5, 20..29, 32, 44] then
      if c is TfrxCustomMemoView then
      begin
        TfrxCustomMemoView(c).Style := '';
        StyleCB.Text := StyleCB.Items[0];
      end;

    if c is TfrxCustomMemoView then
      FSampleFormat.SetAsSample(TfrxCustomMemoView(c));
    wasModified := True;
  end;

  if TheFont <> nil then
    TheFont.Free;
  if TheFrame <> nil then
    TheFrame.Free;
  if TheFill <> nil then
    TheFill.Free;

  if not TComponent(Sender).Tag in [1] then
    ScrollBox.SetFocus;

  if wasModified then
  begin
    FModifiedBy := Self;
    Modified := True;

    if TComponent(Sender).Tag in [24, 25, 34..44] then
      UpdateControls;
  end;
end;

procedure TfrxDesignerForm.FontColorBClick(Sender: TObject);
begin
  FColor := FFontColor;
  ToolButtonClick(Sender);
end;

procedure TfrxDesignerForm.FillColorBClick(Sender: TObject);
begin
  FColor := FFillColor;
  ToolButtonClick(Sender);
end;

procedure TfrxDesignerForm.FrameColorBClick(Sender: TObject);
begin
  FColor := FFrameColor;
  ToolButtonClick(Sender);
end;

procedure TfrxDesignerForm.FontColorPopupMenuPopup(Sender: TObject);
begin
  if GetTickCount - frxPopupFormCloseTime > 50 then
    CreateColorSelector(FontColorB);
end;

procedure TfrxDesignerForm.FillColorPopupMenuPopup(Sender: TObject);
begin
  if GetTickCount - frxPopupFormCloseTime > 50 then
    CreateColorSelector(FillColorB);
end;

procedure TfrxDesignerForm.FrameColorPopupMenuPopup(Sender: TObject);
begin
  if GetTickCount - frxPopupFormCloseTime > 50 then
    CreateColorSelector(FrameColorB);
end;

procedure TfrxDesignerForm.FrameStyleBClick(Sender: TObject);
begin
  with TfrxLineSelector.Create(TComponent(Sender)) do
    OnStyleChanged := Self.OnStyleChanged;
end;

procedure TfrxDesignerForm.ScaleCBClick(Sender: TObject);
var
  s: String;
  dx, dy: Integer;
begin
  if ScaleCB.ItemIndex = 6 then
    s := IntToStr(Round((ScrollBox.Width - 40) / (TfrxReportPage(FPage).PaperWidth * 96 / 25.4) * 100))
  else if ScaleCB.ItemIndex = 7 then
  begin
    dx := Round(TfrxReportPage(FPage).PaperWidth * 96 / 25.4);
    dy := Round(TfrxReportPage(FPage).PaperHeight * 96 / 25.4);
    if (ScrollBox.Width - 20) / dx < (ScrollBox.Height - 20) / dy then
      s := IntToStr(Round((ScrollBox.Width - 20) / dx * 100)) else
      s := IntToStr(Round((ScrollBox.Height - 20) / dy * 100));
  end
  else
    s := ScaleCB.Text;

  if Pos('%', s) <> 0 then
    s[Pos('%', s)] := ' ';
  while Pos(' ', s) <> 0 do
    Delete(s, Pos(' ', s), 1);

  if s <> '' then
  begin
    Scale := frxStrToFloat(s) / 100;
    ScaleCB.Text := s + '%';
    ScrollBox.SetFocus;
  end;
end;

procedure TfrxDesignerForm.ShowGridBClick(Sender: TObject);
begin
  ShowGrid := ShowGridB.Down;
end;

procedure TfrxDesignerForm.AlignToGridBClick(Sender: TObject);
begin
  GridAlign := AlignToGridB.Down;
end;

procedure TfrxDesignerForm.LangCBClick(Sender: TObject);
begin
  if frxConfirmMsg(frxResources.Get('dsClearScript'), mb_YesNo) <> mrYes then
  begin
    LangCB.ItemIndex := LangCB.Items.IndexOf(Report.ScriptLanguage);
    Exit;
  end;

  Report.ScriptLanguage := LangCB.Text;
  frxEmptyCode(CodeWindow.Lines, Report.ScriptLanguage);

  UpdateSyntaxType;
  Modified := True;
  CodeWindow.SetFocus;
end;

procedure TfrxDesignerForm.OpenScriptBClick(Sender: TObject);
begin
  with OpenScriptDialog do
    if Execute then
    begin
      CodeWindow.Lines.LoadFromFile(FileName);
      Modified := True;
    end;
end;

procedure TfrxDesignerForm.SaveScriptBClick(Sender: TObject);
begin
  with SaveScriptDialog do
    if Execute then
      CodeWindow.Lines.SaveToFile(FileName);
end;

procedure TfrxDesignerForm.HighlightBClick(Sender: TObject);
var
  i: Integer;
begin
  with TfrxHighlightEditorForm.Create(Self) do
  begin
    MemoView := SelectedObjects[0];
    if ShowModal = mrOk then
    begin
      for i := 1 to SelectedObjects.Count - 1 do
        if TObject(SelectedObjects[i]) is TfrxCustomMemoView then
          TfrxCustomMemoView(SelectedObjects[i]).Highlight.Assign(MemoView.Highlight);

      Modified := True;
    end;
    Free;
  end;
end;


{ Controls' event handlers }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.OnCodeChanged(Sender: TObject);
begin
  if FPage = nil then
  begin
    FModified := True;
    SaveCmd.Enabled := CheckOp(drDontSaveReport);
    UndoCmd.Enabled := True;
  end;
end;

procedure TfrxDesignerForm.OnChangePosition(Sender: TObject);
begin
  if FPage = nil then
  begin
    FCoord1 := Format('%d; %d', [CodeWindow.GetPos.Y, CodeWindow.GetPos.X]);
    FCoord2 := '';
    FCoord3 := '';
  end;
{$IFDEF FPC}
  frxUpdateControl(StatusBar);
{$ELSE}
  StatusBar.Repaint;
{$ENDIF}
end;

procedure TfrxDesignerForm.OnColorChanged(Sender: TObject);
begin
  with TfrxColorSelector(Sender) do
  begin
    FColor := Color;
    case TfrxColorSelector(Sender).Tag of
      5: FFontColor := FColor;
      26: FFillColor := FColor;
      27: FFrameColor := FColor;
    end;
    ChangeGlyphColor(23, FFontColor);
    ChangeGlyphColor(38, FFillColor);
    ChangeGlyphColor(39, FFrameColor);
    ToolButtonClick(TfrxColorSelector(Sender));
  end;
end;

procedure TfrxDesignerForm.OnStyleChanged(Sender: TObject);
begin
  with TfrxLineSelector(Sender) do
  begin
    FLineStyle := TfrxFrameStyle(Style);
    ToolButtonClick(TfrxLineSelector(Sender));
  end;
end;

procedure TfrxDesignerForm.ScrollBoxMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  with ScrollBox.VertScrollBar do
    Position := Position - 16;
end;

procedure TfrxDesignerForm.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled := not THackControl(FWorkspace).DoMouseWheel(Shift, WheelDelta, MousePos);
end;

procedure TfrxDesignerForm.ScrollBoxMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  with ScrollBox.VertScrollBar do
    Position := Position + 16;
end;

procedure TfrxDesignerForm.ScrollBoxResize(Sender: TObject);
var
  ofs, st: Integer;
begin
  if FWorkspace = nil then Exit;
  if FWorkspace.Left{$IFDEF FPC} - ScrollBox.HorzScrollBar.Position{$ENDIF} < 0 then
  begin
    ofs := ScrollBox.Left + 2;
    {$IFNDEF FPC}
    st := -FWorkspace.Left;
    {$ELSE}
    st := -(FWorkspace.Left - ScrollBox.HorzScrollBar.Position);
    {$ENDIF}
  end
  else
  begin
    {$IFNDEF FPC}
    ofs := ScrollBox.Left + 2 + FWorkspace.Left;
    {$ELSE}
    ofs := ScrollBox.Left + 2 + (FWorkspace.Left - ScrollBox.HorzScrollBar.Position);
    {$ENDIF}
    st := 0;
  end;

  TopRuler.Offset := ofs;
  TopRuler.Start := st;

  if FWorkspace.Top{$IFDEF FPC} - ScrollBox.VertScrollBar.Position{$ENDIF} < 0 then
  begin
    ofs := 2;
    {$IFNDEF FPC}
    st := -FWorkspace.Top;
    {$ELSE}
     st := -(FWorkspace.Top - ScrollBox.VertScrollBar.Position);
    {$ENDIF}
  end
  else
  begin
    {$IFNDEF FPC}
    ofs := FWorkspace.Top + 2;
    {$ELSE}
    ofs := 2 + (FWorkspace.Top - ScrollBox.VertScrollBar.Position);
    {$ENDIF}
    st := 0;
  end;

  LeftRuler.Offset := ofs;
  LeftRuler.Start := st;
end;

procedure TfrxDesignerForm.StatusBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FUnitsDblClicked := X < StatusBar.Panels[0].Width;
end;

procedure TfrxDesignerForm.StatusBarDblClick(Sender: TObject);
var
  i: Integer;
begin
  if FUnitsDblClicked and not
    ((FWorkspace.GridType = gtDialog) or (FWorkspace.GridType = gtChar)) then
  begin
    i := Integer(FUnits);
    Inc(i);
    if i > 2 then
      i := 0;
    Units := TfrxDesignerUnits(i);
    FOldUnits := FUnits;
  end;
end;

procedure TfrxDesignerForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const ARect: TRect);
begin
  {$IFDEF FPC}
  if not StatusBar.HandleAllocated then
    exit;
  {$ENDIF}
  with StatusBar.Canvas do
  begin
    FillRect(ARect);

    if FCoord1 <> '' then
    begin
      frxResources.MainButtonImages.Draw(StatusBar.Canvas, ARect.Left + 2, ARect.Top - 1, 62);
      TextOut(ARect.Left + 20, ARect.Top + 1, FCoord1);
    end;

    if FCoord2 <> '' then
    begin
      frxResources.MainButtonImages.Draw(StatusBar.Canvas, ARect.Left + 110, ARect.Top - 1, 63);
      TextOut(ARect.Left + 130, ARect.Top + 1, FCoord2);
    end;

    if FCoord3 <> '' then
      TextOut(ARect.Left + 110, ARect.Top + 1, FCoord3);
  end;
end;

procedure TfrxDesignerForm.TimerTimer(Sender: TObject);
begin
  if csDestroying in ComponentState  then Exit;
  {$IFDEF FPC}
  FLockSelectionChanged := True;
  {$ENDIF}
  PasteCmd.Enabled := FClipboard.PasteAvailable or (FPage = nil);
  {$IFDEF FPC}
  FLockSelectionChanged := False;
  {$ENDIF}
end;

procedure TfrxDesignerForm.BandsPopupPopup(Sender: TObject);

  function FindBand(Band: TfrxComponentClass): TfrxBand;
  var
    i: Integer;
  begin
    Result := nil;
    if FPage = nil then Exit;
    for i := 0 to FPage.Objects.Count - 1 do
      if TObject(FPage.Objects[i]) is Band then
        Result := FPage.Objects[i];
  end;

begin
  ReportTitleMI.Enabled := FindBand(TfrxReportTitle) = nil;
  ReportSummaryMI.Enabled := FindBand(TfrxReportSummary) = nil;
  PageHeaderMI.Enabled := FindBand(TfrxPageHeader) = nil;
  PageFooterMI.Enabled := FindBand(TfrxPageFooter) = nil;
  ColumnHeaderMI.Enabled := FindBand(TfrxColumnHeader) = nil;
  ColumnFooterMI.Enabled := FindBand(TfrxColumnFooter) = nil;
end;

procedure TfrxDesignerForm.ToolbarsCmdExecute(Sender: TObject);
begin
  StandardTBCmd.Checked := StandardTB.Visible;
  TextTBCmd.Checked := TextTB.Visible;
  FrameTBCmd.Checked := FrameTB.Visible;
  AlignTBCmd.Checked := AlignTB.Visible;
  ExtraTBCmd.Checked := ExtraToolsTB.Visible;
  InspectorTBCmd.Checked := FInspector.Visible;
  DataTreeTBCmd.Checked := FDataTree.Visible;
  ReportTreeTBCmd.Checked := FReportTree.Visible;
end;

procedure TfrxDesignerForm.TopRulerDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TfrxDesignerWorkspace;
end;

procedure TfrxDesignerForm.PagePopupPopup(Sender: TObject);
var
  i: Integer;
  ed: TfrxComponentEditor;
  p: TPopupMenu;
  m: TMenuItem;
begin
  while PagePopup.Items[3] <> SepMI8 do
    PagePopup.Items[3].Free;

  AddChildMI.Visible := (TObject(FSelectedObjects[0]) is TfrxBand) and
    not (TObject(FSelectedObjects[0]) is TfrxColumnFooter) and
    not (TObject(FSelectedObjects[0]) is TfrxOverlay);
  p := TPopupMenu.Create(nil);
  ed := frxComponentEditors.GetComponentEditor(FSelectedObjects[0], Self, p);
  if ed <> nil then
  begin
    EditMI1.Enabled := ed.HasEditor;
    EditMI1.Default := EditMI1.Enabled;

    ed.GetMenuItems;

    SepMI12.Visible := p.Items.Count > 0;

    for i := p.Items.Count - 1 downto 0 do
    begin
      m := TMenuItem.Create(PagePopup);
      with p.Items[i] do
      begin
        m.Caption := Caption;
        m.Tag := Tag;
        m.Checked := Checked;
        m.Bitmap := Bitmap;
      end;
      m.OnClick := OnComponentMenuClick;
      PagePopup.Items.Insert(3, m);
    end;

    ed.Free;
  end
  else
  begin
    EditMI1.Enabled := False;
    SepMI12.Visible := False;
  end;

  p.Free;
end;

procedure TfrxDesignerForm.CodeWindowDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TTreeView) and (TTreeView(Source).Owner = FDataTree) and
     (FDataTree.GetFieldName <> '');
end;

procedure TfrxDesignerForm.CodeWindowDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  CodeWindow.SelText := FDataTree.GetFieldName;
  CodeWindow.SetFocus;
end;

procedure TfrxDesignerForm.OnDataTreeDblClick(Sender: TObject);
begin
  if Page = nil then
  begin
    CodeWindow.SelText := FDataTree.GetFieldName;
    CodeWindow.SetFocus;
  end
  else if (FDataTree.GetActivePage = 0) and
    (Report.DataSets.Count = 0) then
    ReportDataCmdExecute(Self);
end;

procedure TfrxDesignerForm.TabChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if IsPreviewDesigner or FScriptRunning then
    AllowChange := False;
  {$IFNDEF FPC}
  if (FTabs.TabIndex = 0) and CodeWindow.Modified then
  begin
    Modified := True;
    CodeWindow.Modified := False;
  end;
  {$ENDIF}
  SavePagePosition;
end;

procedure TfrxDesignerForm.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  TabChanging(nil, AllowChange);
end;

procedure TfrxDesignerForm.TabChange(Sender: TObject);
begin
  if (FTabs.TabIndex = 0) then
{$IFDEF FR_VER_BASIC}
    FTabs.TabIndex := 1 else
{$ELSE}
  begin
    if CheckOp(drDontEditReportScript) then
    {$IFNDEF FPC}
      Page := nil
    {$ELSE}
    begin
      if CodeWindow.Modified then
      begin
        Modified := True;
        CodeWindow.Modified := False;
      end;
      Page := nil;
    end
    {$ENDIF}
    else FTabs.TabIndex := 1
  end else
{$ENDIF}
  if (FTabs.TabIndex = 1) and not CheckOp(drDontEditInternalDatasets) then
    FTabs.TabIndex := 2
  else
  begin
    if FTabs.TabIndex >= 0 then
      Page := Report.Pages[FTabs.TabIndex - 1];
  end;
end;

procedure TfrxDesignerForm.TabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  GetCursorPos(p);
  if Button = mbRight then
    TabPopup.Popup(p.X, p.Y) else
    FMouseDown := True;
end;

procedure TfrxDesignerForm.TabMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  FMouseDown := False;
  if Button = mbRight then
  begin
    pt := TControl(Sender).ClientToScreen(Point(X, Y));
    TabPopup.Popup(pt.X, pt.Y);
  end;
end;

procedure TfrxDesignerForm.TabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMouseDown then
    FTabs.BeginDrag(False);
end;

procedure TfrxDesignerForm.TabDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is Sender.ClassType;
end;

{$IFDEF UseTabset}
procedure TfrxDesignerForm.TabDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  HitPage, CurPage: Integer;
begin
  HitPage := FTabs.ItemAtPos(Point(X, Y));
  CurPage := Report.Objects.IndexOf(Page) + 1;
  if (CurPage < 2) or (HitPage < 2) then Exit;

  FTabs.Tabs.Move(CurPage, HitPage);
  Report.Objects.Move(CurPage - 1, HitPage - 1);
  Modified := True;
end;
{$ELSE}
procedure TfrxDesignerForm.TabDragDrop(Sender, Source: TObject; X, Y: Integer);
{$IFNDEF FPC}
var
  HitPage, CurPage: Integer;
  HitTestInfo: TTCHitTestInfo;
{$ENDIF}
begin
  {$IFDEF FPC}
  {$note TfrxDesignerForm.TabDragDrop not implemented yet}
  {$IFDEF DEBUGFR4DESIGNER}
  DebugLn('WARNING: TfrxDesignerForm.TabDragDrop Fixme');
  {$ENDIF}
  {$ELSE}
  HitTestInfo.pt := Point(X, Y);
  HitPage := SendMessage(FTabs.Handle, TCM_HITTEST, 0, frxInteger(@HitTestInfo));
  CurPage := Report.Objects.IndexOf(Page) + 1;
  if (CurPage < 2) or (HitPage < 2) then Exit;

  FTabs.Tabs.Move(CurPage, HitPage);
  Report.Objects.Move(CurPage - 1, HitPage - 1);
  Modified := True;
  {$ENDIF}
end;
{$ENDIF}

{ Dialog form events }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.DialogFormModify(Sender: TObject);
begin
  Page.Left := FDialogForm.Left;
  Page.Top := FDialogForm.Top;
  Page.Width := FDialogForm.Width;
  Page.Height := FDialogForm.Height;
  Modified := True;
end;

procedure TfrxDesignerForm.DisableInspectorUpdate;
begin
  FInspectorLock := True;
end;

procedure TfrxDesignerForm.DialogFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssCtrl] then
    if Key = Ord('C') then
      CopyCmd.Execute
    else if Key = Ord('V') then
      PasteCmd.Execute
    else if Key = Ord('X') then
      CutCmd.Execute
    else if Key = Ord('Z') then
      UndoCmd.Execute
    else if Key = Ord('Y') then
      RedoCmd.Execute
    else if Key = Ord('A') then
      SelectAllCmd.Execute
    else if Key = Ord('S') then
      SaveCmd.Execute;

  THackControl(FWorkspace).KeyDown(Key, Shift);
end;

procedure TfrxDesignerForm.DialogFormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  THackControl(FWorkspace).KeyUp(Key, Shift);
end;

procedure TfrxDesignerForm.DialogFormKeyPress(Sender: TObject; var Key: Char);
begin
  THackControl(FWorkspace).KeyPress(Key);
end;


{ Menu commands }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.ExitCmdExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrxDesignerForm.ConnectionsMIClick(Sender: TObject);
begin
  with TfrxConnEditorForm.Create(nil) do
  begin
    Report := Self.Report;
    ShowModal;
    Free;
  end;
end;

procedure TfrxDesignerForm.UndoCmdExecute(Sender: TObject);
var
  i, SaveX, SaveY: Integer;
  TmpPage: TfrxReportPage;
begin
  if FPage = nil then
  begin
    CodeWindow.Undo;
    Exit;
  end;
  Lock;
  Report.ScriptText := CodeWindow.Lines;
  SaveY := ScrollBox.VertScrollBar.Position;
  SaveX := ScrollBox.HorzScrollBar.Position;
  if IsPreviewDesigner then
  begin
    i := 1;
    if FPage is TfrxDMPPage then
      TmpPage := TfrxDMPPage.Create(nil)
    else
      TmpPage := TfrxReportPage.Create(nil);

    FUndoBuffer.AddRedo(FPage);
    FPage.Free;
    FUndoBuffer.GetUndo(TmpPage);
    TmpPage.Parent := Report;
    FPage := TmpPage;
  end
  else
  begin
    i := GetPageIndex;
    FUndoBuffer.AddRedo(Report);
    FUndoBuffer.GetUndo(Report);
    CodeWindow.Lines := Report.ScriptText;
  end;

  ReloadPages(i);
  ScrollBox.VertScrollBar.Position := SaveY;
  ScrollBox.HorzScrollBar.Position := SaveX;
  if not Modified then
    SaveCmd.Enabled := True;
end;

procedure TfrxDesignerForm.RedoCmdExecute(Sender: TObject);
var
  i, SaveX, SaveY: Integer;
  TmpPage: TfrxReportPage;
begin
  Lock;
  SaveY := ScrollBox.VertScrollBar.Position;
  SaveX := ScrollBox.HorzScrollBar.Position;
  if IsPreviewDesigner then
  begin
    i := 1;
    if FPage is TfrxDMPPage then
      TmpPage := TfrxDMPPage.Create(nil)
    else
      TmpPage := TfrxReportPage.Create(nil);

    FUndoBuffer.GetRedo(TmpPage);
    FUndoBuffer.AddUndo(TmpPage);
    FPage.Free;
    TmpPage.Parent := Report;
    FPage := TmpPage;
  end
  else
  begin
    i := GetPageIndex;
    Report.Reloading := True;
    FUndoBuffer.GetRedo(Report);
    Report.Reloading := False;
    FUndoBuffer.AddUndo(Report);
    CodeWindow.Lines := Report.ScriptText;
  end;

  ReloadPages(i);
  ScrollBox.VertScrollBar.Position := SaveY;
  ScrollBox.HorzScrollBar.Position := SaveX;
end;

procedure TfrxDesignerForm.CutCmdExecute(Sender: TObject);
begin
  if FPage = nil then
  begin
    CodeWindow.CutToClipboard;
    Exit;
  end;

  FClipboard.Copy;
  FWorkspace.DeleteObjects;
  FInspector.Objects := FObjects;

  Modified := True;
end;

procedure TfrxDesignerForm.CopyCmdExecute(Sender: TObject);
begin
  if FPage = nil then
  begin
    CodeWindow.CopyToClipboard;
    Exit;
  end;

  FClipboard.Copy;
  TimerTimer(nil);
end;

procedure TfrxDesignerForm.PasteCmdExecute(Sender: TObject);
var
  bIsNewObj: Boolean;
begin
  if FPage = nil then
  begin
    CodeWindow.PasteFromClipboard;
    Exit;
  end;

  bIsNewObj := FClipboard.Paste;

  if bIsNewObj and (frxDesignerComp <> nil) and Assigned(frxDesignerComp.FOnInsertObject) then
  frxDesignerComp.FOnInsertObject(FSelectedObjects[0]);

  FWorkspace.BringToFront;
  FInspector.Objects := FObjects;
  FInspector.UpdateProperties;

  if (TfrxComponent(FSelectedObjects[0]) is TfrxDialogComponent) or not bIsNewObj then
    Modified := True
  else if FSelectedObjects[0] <> FPage then
    TDesignerWorkspace(FWorkspace).SimulateMove;
end;

procedure TfrxDesignerForm.GroupCmdExecute(Sender: TObject);
begin
  FWorkspace.GroupObjects;
end;

procedure TfrxDesignerForm.UngroupCmdExecute(Sender: TObject);
begin
  FWorkspace.UngroupObjects;
end;

procedure TfrxDesignerForm.DeletePageCmdExecute(Sender: TObject);
begin
  if not CheckOp(drDontDeletePage) then Exit;

  Lock;
  if (FPage is TfrxReportPage) and (TfrxReportPage(FPage).Subreport <> nil) then
    TfrxReportPage(FPage).Subreport.Free;

  FPage.Free;
  ReloadPages(-2);
  Modified := True;
end;

procedure TfrxDesignerForm.NewPageCmdExecute(Sender: TObject);
begin
  if not CheckOp(drDontCreatePage) then Exit;

  Lock;
  if Report.DotMatrixReport then
    FPage := TfrxDMPPage.Create(Report)
  else
    FPage := TfrxReportPage.Create(Report);
  FPage.CreateUniqueName;
  TfrxReportPage(FPage).SetDefaults;
  ReloadPages(Report.PagesCount - 1);
  Modified := True;
end;

procedure TfrxDesignerForm.NewDialogCmdExecute(Sender: TObject);
{$IFDEF FPC}
var
  Pt: TPoint;
{$ENDIF}
begin
  if not CheckOp(drDontCreatePage) then Exit;

  Lock;
  FPage := TfrxDialogPage.Create(Report);
  FPage.CreateUniqueName;
  {$IFDEF FPC}
  Pt := Point(0, 0);
  Pt := ScrollBox.ClientToScreen(Pt);
  with Pt do
    FPage.SetBounds(X + 10, Y + 10, 300, 200);
  {$ELSE}
  FPage.SetBounds(265, 150, 300, 200);
  {$ENDIF}
  if frxDesignerComp <> nil then
    FPage.Font.Assign(frxDesignerComp.DefaultFont);
  ReloadPages(Report.PagesCount - 1);
  Modified := True;
end;

procedure TfrxDesignerForm.NewReportCmdExecute(Sender: TObject);
var
  dp: TfrxDataPage;
  p: TfrxReportPage;
  b: TfrxBand;
  m: TfrxMemoView;
  h, t: Extended;
  w: Word;
begin
  if not CheckOp(drDontCreateReport) then Exit;

  if Modified then
  begin
    w := AskSave;
    if w = mrYes then
      SaveCmdExecute(SaveCmd)
    else if w = mrCancel then
      Exit;
  end;

  t := FWorkspace.BandHeader;
  h := 0;
  case FUnits of
    duCM:     h := fr01cm * 6;
    duInches: h := fr01in * 3;
    duPixels: h := 20;
    duChars:  h := fr1CharY;
  end;

  ObjectSelectB.Down := True;
  SelectToolBClick(Self);

  Lock;
  Report.Clear;
  Report.FileName := '';

  dp := TfrxDataPage.Create(Report);
  dp.Name := 'Data';

  p := TfrxReportPage.Create(Report);
  p.Name := 'Page1';
  SetReportDefaults;

  b := TfrxReportTitle.Create(p);
  b.Name := 'ReportTitle1';
  b.Top := t;
  b.Height := h;

  b := TfrxMasterData.Create(p);
  b.Name := 'MasterData1';
  b.Height := h;
  b.Top := t * 2 + h * 2;

  b := TfrxPageFooter.Create(p);
  b.Name := 'PageFooter1';
  b.Height := h;
  b.Top := t * 3 + h * 4;

  m := TfrxMemoView.Create(b);
  m.Name := 'Memo1';
  m.SetBounds((p.PaperWidth - p.LeftMargin - p.RightMargin - 20) * fr01cm, 0,
    2 * fr1cm, 5 * fr01cm);
  m.HAlign := haRight;
  m.Memo.Text := '[Page#]';

  ReloadPages(-2);
  UpdateCaption;
  Modified := False;
end;

procedure TfrxDesignerForm.SaveCmdExecute(Sender: TObject);
begin
  FInspector.ItemIndex := FInspector.ItemIndex;
  if CheckOp(drDontSaveReport) then
    SaveFile(False, Sender = SaveCmd);
end;

procedure TfrxDesignerForm.SaveAsCmdExecute(Sender: TObject);
begin
  FInspector.ItemIndex := FInspector.ItemIndex;
  if CheckOp(drDontSaveReport) then
    SaveFile(True, Sender = SaveAsCmd);
end;

procedure TfrxDesignerForm.OpenCmdExecute(Sender: TObject);
var
  Filter: TfrxCustomIOTransport;
begin
  if not CheckOp(drDontLoadReport) then Exit;
  Filter := TfrxCustomIOTransport(FFilterList.Objects[TComponent(Sender).Tag]).CreateFilterClone(fvDesigner);
  try
    LoadFilter(Filter, '', Sender = OpenCmd);
  finally
    TfrxCustomIOTransport(FFilterList.Objects[TComponent(Sender).Tag]).AssignSharedProperties(Filter);
    Filter.Free;
  end;
//  if CheckOp(drDontLoadReport) then
//    LoadFile('', Sender = OpenCmd);
end;

procedure TfrxDesignerForm.OpenRecentFile(Sender: TObject);
begin
  if CheckOp(drDontLoadReport) then
    LoadFile(TMenuItem(Sender).Caption, True);
end;

procedure TfrxDesignerForm.DeleteCmdExecute(Sender: TObject);
begin
  FWorkspace.DeleteObjects;
end;

procedure TfrxDesignerForm.SelectAllCmdExecute(Sender: TObject);
var
  i: Integer;
  AParent: TfrxComponent;
begin
  if Page = nil then
  begin
    CodeWindow.SelectAll;
    Exit;
  end;

  AParent := FPage;
  if FSelectedObjects.Count = 1 then
    if TfrxComponent(FSelectedObjects[0]) is TfrxBand then
      AParent := FSelectedObjects[0]
    else if TfrxComponent(FSelectedObjects[0]).Parent is TfrxBand then
      AParent := TfrxComponent(FSelectedObjects[0]).Parent;

  if AParent.Objects.Count <> 0 then
    FSelectedObjects.Clear;
  for i := 0 to AParent.Objects.Count - 1 do
    FSelectedObjects.Add(AParent.Objects[i]);
  OnSelectionChanged(Self);
end;

procedure TfrxDesignerForm.SelectAllOfTypeCmdExecute(Sender: TObject);
var
  i: Integer;
  AParent: TfrxComponent;
  ObjClass: TClass;
begin
  if (Page = nil) or (FSelectedObjects.Count <> 1) then
  begin
    Exit;
  end;
  ObjClass := TfrxComponent(FSelectedObjects[0]).ClassType;
  if Sender = SelectAllOfTypeOnPageMI then
    AParent := FPage
  else
    AParent := TfrxComponent(FSelectedObjects[0]).Parent;

  FSelectedObjects.Clear;
  for i := 0 to AParent.AllObjects.Count - 1 do
    if TfrxComponent(AParent.AllObjects[i]).ClassType = ObjClass then
      FSelectedObjects.Add(AParent.AllObjects[i]);
  OnSelectionChanged(Self);
end;

procedure TfrxDesignerForm.EdConfigCmdExecute(Sender: TObject);
begin
  with TfrxRegEditorsDialog.Create(Self) do
  begin
    ShowModal;
    Free;
  end;
  FWorkspace.CreateInPlaceEditorsList;
end;

procedure TfrxDesignerForm.EditCmdExecute(Sender: TObject);
begin
  FWorkspace.EditObject;
end;

procedure TfrxDesignerForm.EnableInspectorUpdate;
begin
  FInspectorLock := False;
end;

procedure TfrxDesignerForm.BringToFrontCmdExecute(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
begin
  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if c.Parent <> nil then
      if (c is TfrxReportComponent) and not (rfDontMove in c.Restrictions) then
      begin
        c.Parent.Objects.Remove(c);
        c.Parent.Objects.Add(c);
      end;
  end;

  ReloadObjects;
  Modified := True;
end;

procedure TfrxDesignerForm.SendToBackCmdExecute(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
begin
  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if c.Parent <> nil then
      if (c is TfrxReportComponent) and not (rfDontMove in c.Restrictions) then
      begin
        c.Parent.Objects.Remove(c);
        c.Parent.Objects.Insert(0, c);
      end;
  end;

  ReloadObjects;
  Modified := True;
end;

procedure TfrxDesignerForm.TabOrderMIClick(Sender: TObject);
begin
  with TfrxTabOrderEditorForm.Create(Self) do
  begin
    if ShowModal = mrOk then
      Modified := True;
    ReloadObjects;
    Free;
  end;
end;

procedure TfrxDesignerForm.PageSettingsCmdExecute(Sender: TObject);
begin
  if CheckOp(drDontChangePageOptions) then
    if (FPage is TfrxReportPage) and (TfrxReportPage(FPage).Subreport = nil) then
      with TfrxPageEditorForm.Create(Self) do
      begin
        if ShowModal = mrOk then
        begin
          Modified := True;
          UpdatePageDimensions;
        end;
        Free;
      end;
end;

procedure TfrxDesignerForm.OnComponentMenuClick(Sender: TObject);
var
  ed: TfrxComponentEditor;
begin
  ed := frxComponentEditors.GetComponentEditor(FSelectedObjects[0], Self, nil);
  if ed <> nil then
  begin
    if ed.Execute(TMenuItem(Sender).Tag, not TMenuItem(Sender).Checked) then
      Modified := True;
    ed.Free;
  end;
end;

procedure TfrxDesignerForm.ReportDataCmdExecute(Sender: TObject);
begin
  if CheckOp(drDontEditReportData) then
    with TfrxReportDataForm.Create(Self) do
    begin
      Report := Self.Report;
      if ShowModal = mrOk then
      begin
        Modified := True;
        UpdateDataTree;
      end;
      Free;
    end;
end;

procedure TfrxDesignerForm.ReportStylesCmdExecute(Sender: TObject);
begin
  if CheckOp(drDontChangeReportOptions) then
    with TfrxStyleEditorForm.Create(Self) do
    begin
      if ShowModal = mrOk then
      begin
        Modified := True;
        UpdateStyles;
        Report.Styles.Apply;
      end;
      Free;
    end;
end;

procedure TfrxDesignerForm.ReportOptionsCmdExecute(Sender: TObject);
begin
  if CheckOp(drDontChangeReportOptions) then
    with TfrxReportEditorForm.Create(Self) do
    begin
      if ShowModal = mrOk then
      begin
        { reload printer fonts }
        FontNameCB.PopulateList;
        Modified := True;
      end;
      Free;
    end;
end;

procedure TfrxDesignerForm.VariablesCmdExecute(Sender: TObject);
begin
  if CheckOp(drDontEditVariables) then
    with TfrxVarEditorForm.Create(Self) do
    begin
      if ShowModal = mrOk then
      begin
        Modified := True;
        UpdateDataTree;
      end;
      Free;
    end;
end;

procedure TfrxDesignerForm.PreviewCmdExecute(Sender: TObject);
var
  Preview: TfrxCustomPreview;
  pt: TPoint;
  SavePageNo: Integer;
  SaveModalPreview: Boolean;
  SaveDestroyForms: Boolean;
  SaveMDIChild: Boolean;
  SaveVariables: TfrxVariables;
begin
  FInspector.ItemIndex := FInspector.ItemIndex;
  if not CheckOp(drDontPreviewReport) then Exit;

  if FScriptStopped then
  begin
    RunScriptBClick(RunScriptB);
    Exit;
  end;

  SavePagePosition;
  Report.ScriptText := CodeWindow.Lines;
  if not Report.PrepareScript then
  begin
    pt := fsPosToPoint(Report.Script.ErrorPos);
    SwitchToCodeWindow;
    FCodeWindow.SetPos(pt.X, pt.Y);
    FCodeWindow.ShowMessage(Report.Script.ErrorMsg);
    Exit;
  end;

  AttachDialogFormEvents(False);
  SavePageNo := GetPageIndex;
  SaveModalPreview := Report.PreviewOptions.Modal;
  SaveDestroyForms := Report.EngineOptions.DestroyForms;
  SaveMDIChild := Report.PreviewOptions.MDIChild;
  SaveVariables := TfrxVariables.Create;
  SaveVariables.Assign(Report.Variables);

  FUndoBuffer.AddUndo(Report);

  Preview := Report.Preview;
  try
    Report.Preview := nil;
    Report.PreviewOptions.Modal := True;
    Report.EngineOptions.DestroyForms := False;
    Report.PreviewOptions.MDIChild := False;
    {$IFNDEF FPC}
    FWatchList.ScriptRunning := True;
    {$ELSE}
    FBWForm.ScriptRunning := True;
    {$ENDIF}
    Report.ShowReport;
  except
  end;
  {$IFNDEF FPC}
  FWatchList.ScriptRunning := False;
  {$ELSE}
  FBWForm.ScriptRunning := False;
  {$ENDIF}
  Lock;
  FUndoBuffer.GetUndo(Report);

  Report.Script.ClearItems(Report);
  Report.Preview := Preview;
  Report.PreviewOptions.Modal := SaveModalPreview;
  Report.EngineOptions.DestroyForms := SaveDestroyForms;
  Report.PreviewOptions.MDIChild := SaveMDIChild;
  Report.Variables.Assign(SaveVariables);
  SaveVariables.Free;

  if SavePageNo <> -1 then
    ReloadPages(SavePageNo)
  else
  begin
    ReloadPages(-2);
    Page := nil;
  end;

  UpdateWatches;
end;

procedure TfrxDesignerForm.NewItemCmdExecute(Sender: TObject);
begin
  if CheckOp(drDontCreateReport) then
    with TfrxNewItemForm.Create(Self) do
    begin
      ShowModal;
      Free;
    end;
end;

procedure TfrxDesignerForm.FindCmdExecute(Sender: TObject);
begin
  FindOrReplace(False);
end;

procedure TfrxDesignerForm.ReplaceCmdExecute(Sender: TObject);
begin
  FindOrReplace(True);
end;

procedure TfrxDesignerForm.FindNextCmdExecute(Sender: TObject);
begin
  FindText;
end;

procedure TfrxDesignerForm.StandardTBCmdExecute(Sender: TObject);
begin
  StandardTBCmd.Checked := not StandardTBCmd.Checked;
  StandardTB.Visible := StandardTBCmd.Checked;
end;

procedure TfrxDesignerForm.TextTBCmdExecute(Sender: TObject);
begin
  TextTBCmd.Checked := not TextTBCmd.Checked;
  TextTB.Visible := TextTBCmd.Checked;
end;

procedure TfrxDesignerForm.FrameTBCmdExecute(Sender: TObject);
begin
  FrameTBCmd.Checked := not FrameTBCmd.Checked;
  FrameTB.Visible := FrameTBCmd.Checked;
end;

procedure TfrxDesignerForm.AlignTBCmdExecute(Sender: TObject);
begin
  AlignTBCmd.Checked := not AlignTBCmd.Checked;
  AlignTB.Visible := AlignTBCmd.Checked;
end;

procedure TfrxDesignerForm.ExtraTBCmdExecute(Sender: TObject);
begin
  ExtraTBCmd.Checked := not ExtraTBCmd.Checked;
  ExtraToolsTB.Visible := ExtraTBCmd.Checked;
end;

procedure TfrxDesignerForm.InspectorTBCmdExecute(Sender: TObject);
begin
  InspectorTBCmd.Checked := not InspectorTBCmd.Checked;
  FInspector.Visible := InspectorTBCmd.Checked;
  if FInspector.Parent is TfrxDockSite then
    if InspectorTBCmd.Checked then
      FInspector.Width := TfrxDockSite(FInspector.Parent).SavedSize
    else if FInspector.Width > 0 then
      TfrxDockSite(FInspector.Parent).SavedSize := FInspector.Width;
end;

procedure TfrxDesignerForm.InternalCopy;
begin
  FWorkspace.InternalCopy;
end;

function TfrxDesignerForm.InternalIsPasteAvailable: Boolean;
begin
  Result := FWorkspace.InternalIsPasteAvailable;
end;

procedure TfrxDesignerForm.InternalPaste;
begin
  FWorkspace.InternalPaste;
end;

function TfrxDesignerForm.IsChangedExpression(const InExpr: String; out OutExpr: String): Boolean;
begin
  with TfrxExprEditorForm.Create(Self) do
  begin
    ExprMemo.Text := InExpr;
    Result := (ShowModal = mrOk) and (InExpr <> ExprMemo.Text);
    if Result then
      OutExpr := ExprMemo.Text;
    Free;
  end
end;

procedure TfrxDesignerForm.DataTreeTBCmdExecute(Sender: TObject);
begin
  DataTreeTBCmd.Checked := not DataTreeTBCmd.Checked;
  FDataTree.Visible := DataTreeTBCmd.Checked;
  if FDataTree.Parent is TfrxDockSite then
    if DataTreeTBCmd.Checked then
      FDataTree.Width := TfrxDockSite(FDataTree.Parent).SavedSize
    else if FDataTree.Width > 0 then
      TfrxDockSite(FDataTree.Parent).SavedSize := FDataTree.Width;
end;

procedure TfrxDesignerForm.ReportTreeTBCmdExecute(Sender: TObject);
begin
  ReportTreeTBCmd.Checked := not ReportTreeTBCmd.Checked;
  FReportTree.Visible := ReportTreeTBCmd.Checked;
  if FReportTree.Parent is TfrxDockSite then
    if ReportTreeTBCmd.Checked then
      FReportTree.Width := TfrxDockSite(FReportTree.Parent).SavedSize
    else if FReportTree.Width > 0 then
      TfrxDockSite(FReportTree.Parent).SavedSize := FReportTree.Width;
end;

procedure TfrxDesignerForm.ShowRulersCmdExecute(Sender: TObject);
begin
  ShowRulersCmd.Checked := not ShowRulersCmd.Checked;
  ShowRulers := ShowRulersCmd.Checked;
end;

procedure TfrxDesignerForm.ShowGuidesCmdExecute(Sender: TObject);
begin
  ShowGuidesCmd.Checked := not ShowGuidesCmd.Checked;
  ShowGuides := ShowGuidesCmd.Checked;
end;

procedure TfrxDesignerForm.DeleteGuidesCmdExecute(Sender: TObject);
begin
  if FPage is TfrxReportPage then
  begin
    TfrxReportPage(FPage).ClearGuides;
    FWorkspace.Invalidate;
    Modified := True;
  end;
end;

procedure TfrxDesignerForm.OptionsCmdExecute(Sender: TObject);
var
  u: TfrxDesignerUnits;
begin
  u := FUnits;

  with TfrxOptionsEditor.Create(Self) do
  begin
    ShowModal;
    Free;
  end;

  if u <> FUnits then
    FOldUnits := FUnits;

  if FWorkspace.GridType = gtDialog then
  begin
    FWorkspace.GridX := FGridSize4;
    FWorkspace.GridY := FGridSize4;
  end;

  FWorkspace.UpdateView;
  CodeWindow.Invalidate;
end;

procedure TfrxDesignerForm.HelpContentsCmdExecute(Sender: TObject);
var
  tempC: TfrxDialogComponent;
begin
  if Page = nil then
    frxResources.Help(FCodeWindow)
  else if Page is TfrxDialogPage then
    frxResources.Help(Page)
  else if TObject(SelectedObjects[0]) is TfrxDialogComponent then
  begin
    tempC := TfrxDialogComponent.Create(nil);
    frxResources.Help(tempC);
    tempC.Free;
  end
  else
    frxResources.Help(Self);
end;

procedure TfrxDesignerForm.AboutCmdExecute(Sender: TObject);
begin
  with TfrxAboutForm.Create(Self) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TfrxDesignerForm.AddChildMIClick(Sender: TObject);
var
  b, bc: TfrxBand;
begin
  b := FSelectedObjects[0];
  bc := b.Child;
  InsertBandClick(ChildMI);
  b.Child := FSelectedObjects[0];
  b.Child.Child := TfrxChild(bc);
  Modified := True;
end;


{ Debugging }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.RunScriptBClick(Sender: TObject);
begin
  if FScriptRunning then
  begin
    FScriptStep := Sender = StepScriptB;
    if (Sender = RunScriptB) and (CodeWindow.BreakPoints.Count = 0) then
      Report.Script.OnRunLine := nil;
    FScriptStopped := False;
    Exit;
  end;

  if (Sender = RunScriptB) and (CodeWindow.BreakPoints.Count = 0) then
    Report.Script.OnRunLine := nil
  else
    Report.Script.OnRunLine := OnRunLine;

  try
    FScriptRunning := True;
    FScriptFirstTime := True;
    PreviewCmdExecute(Self);
  finally
    FScriptRunning := False;
    Report.Script.OnRunLine := nil;
    CodeWindow.DeleteF4BreakPoints;
    CodeWindow.ActiveLine := -1;
  end;
end;

procedure TfrxDesignerForm.StopScriptBClick(Sender: TObject);
begin
  Report.Script.OnRunLine := nil;
  Report.Script.Terminate;
  Report.Terminated := True;
  FScriptStopped := False;
end;

procedure TfrxDesignerForm.EvaluateBClick(Sender: TObject);
begin
  with TfrxEvaluateForm.Create(Self) do
  begin
    Script := Report.Script;
    if CodeWindow.SelText <> '' then
      ExpressionE.Text := CodeWindow.SelText;
    ShowModal;
    Free;
  end;
end;

procedure TfrxDesignerForm.BreakPointBClick(Sender: TObject);
begin
  CodeWindow.ToggleBreakPoint(CodeWindow.GetPos.Y, '');
end;

procedure TfrxDesignerForm.RunToCursorBClick(Sender: TObject);
begin
  CodeWindow.AddBreakPoint(CodeWindow.GetPos.Y, '', 'F4');
  RunScriptBClick(nil);
end;

procedure TfrxDesignerForm.OnRunLine(Sender: TfsScript; const UnitName,
  SourcePos: String);
var
  p: TPoint;
  SaveActiveForm: TForm;
  Condition: String;
  OldFormStyle: TFormStyle;
  v: Variant;

  procedure CreateLineMarks;
  var

    i: Integer;
  begin
    for i := 0 to Report.Script.Lines.Count - 1 do
      CodeWindow.RunLine[i + 1] := Report.Script.IsExecutableLine(i + 1);
  end;

begin
  p := fsPosToPoint(SourcePos);
  if not FScriptStep and (CodeWindow.BreakPoints.Count > 0) then
    if not CodeWindow.IsActiveBreakPoint(p.Y) then
      Exit;
  OldFormStyle := FormStyle;
  Condition := CodeWindow.GetBreakPointSpecialCondition(p.Y);
  { F4 - run to line, remove the breakpoint }
  if Condition = 'F4' then
    CodeWindow.DeleteBreakPoint(p.Y);

  Condition := CodeWindow.GetBreakPointCondition(p.Y);
  if Condition <> '' then
  begin
    v := Report.Script.Evaluate(Condition);
    if not((TVarData(v).VType = varBoolean) and (v = True)) then Exit;
  end;

  if FScriptFirstTime then
    CreateLineMarks;
  FScriptFirstTime := False;

  SaveActiveForm := Screen.ActiveForm;

  if ParentForm <> nil then
  begin
    EnableWindow(ParentForm.Handle, True);
//{$IFDEF Delphi9}
    ParentForm.Enabled := True;
//{$ENDIF}
    ParentForm.SetFocus;
  end
  else
  begin
    EnableWindow(Handle, True);
    if csDesigning in Report.ComponentState  then
    begin
      FormStyle := fsStayOnTop;
    end;
//{$IFDEF Delphi9}
    Enabled := True;
//{$ENDIF}
    SetFocus;
  end;

  {switch to code Tab}
  if FTabs.TabIndex <> 0  then
    SetPage(nil);

  CodeWindow.ActiveLine := p.Y;
  CodeWindow.SetPos(p.X, p.Y);
  UpdateWatches;

  FScriptStopped := True;
  while FScriptStopped do
    Application.HandleMessage;

  if csDesigning in Report.ComponentState  then
    FormStyle := OldFormStyle;

  if SaveActiveForm <> nil then
    SaveActiveForm.SetFocus;
end;


{ Alignment palette }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.AlignLeftsBClick(Sender: TObject);
var
  i: Integer;
  c0, c: TfrxComponent;
begin
  if FSelectedObjects.Count < 2 then Exit;

  c0 := FSelectedObjects[0];
  for i := 1 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontMove in c.Restrictions) then
      c.Left := c0.Left;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.AlignRightsBClick(Sender: TObject);
var
  i: Integer;
  c0, c: TfrxComponent;
begin
  if FSelectedObjects.Count < 2 then Exit;

  c0 := FSelectedObjects[0];
  for i := 1 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontMove in c.Restrictions) then
      c.Left := c0.Left + c0.Width - c.Width;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.AlignTopsBClick(Sender: TObject);
var
  i: Integer;
  c0, c: TfrxComponent;
begin
  if FSelectedObjects.Count < 2 then Exit;

  c0 := FSelectedObjects[0];
  for i := 1 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontMove in c.Restrictions) then
      if Abs(c.Top - c.AbsTop) < 1e-4 then
        c.Top := c0.AbsTop
      else
        c.Top := c0.AbsTop - c.AbsTop + c.Top;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.AlignBottomsBClick(Sender: TObject);
var
  i: Integer;
  c0, c: TfrxComponent;
begin
  if FSelectedObjects.Count < 2 then Exit;

  c0 := FSelectedObjects[0];
  for i := 1 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontMove in c.Restrictions) then
      if Abs(c.Top - c.AbsTop) < 1e-4 then
        c.Top := c0.AbsTop + c0.Height - c.Height
      else
        c.Top := c0.AbsTop - c.AbsTop + c.Top + c0.Height - c.Height;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.AlignHorzCentersBClick(Sender: TObject);
var
  i: Integer;
  c0, c: TfrxComponent;
begin
  if FSelectedObjects.Count < 2 then Exit;

  c0 := FSelectedObjects[0];
  for i := 1 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontMove in c.Restrictions) then
      c.Left := c0.Left + c0.Width / 2 - c.Width / 2;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.AlignVertCentersBClick(Sender: TObject);
var
  i: Integer;
  c0, c: TfrxComponent;
begin
  if FSelectedObjects.Count < 2 then Exit;

  c0 := FSelectedObjects[0];
  for i := 1 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontMove in c.Restrictions) then
      c.Top := c0.Top + c0.Height / 2 - c.Height / 2;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.CenterHorzBClick(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
begin
  if FSelectedObjects.Count < 1 then Exit;

  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontMove in c.Restrictions) and (c is TfrxView) then
      if c.Parent is TfrxBand then
        c.Left := (c.Parent.Width - c.Width) / 2 else
        c.Left := (FWorkspace.Width / Scale - c.Width) / 2;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.CenterVertBClick(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
begin
  if FSelectedObjects.Count < 1 then Exit;

  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontMove in c.Restrictions) and (c is TfrxView) then
      if c.Parent is TfrxBand then
        c.Top := (c.Parent.Height - c.Height) / 2 else
        c.Top := (FWorkspace.Height / Scale - c.Height) / 2;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.SpaceHorzBClick(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
  sl: TStringList;
  dx: Extended;
begin
  if FSelectedObjects.Count < 3 then Exit;

  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupAccept;

  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    sl.AddObject(Format('%4.4d', [Round(c.Left)]), c);
  end;

  dx := (TfrxComponent(sl.Objects[sl.Count - 1]).Left -
    TfrxComponent(sl.Objects[0]).Left) / (sl.Count - 1);

  for i := 1 to sl.Count - 2 do
  begin
    c := TfrxComponent(sl.Objects[i]);
    if not (rfDontMove in c.Restrictions) then
      c.Left := TfrxComponent(sl.Objects[i - 1]).Left + dx;
  end;

  sl.Free;
  Modified := True;
end;

procedure TfrxDesignerForm.SpaceVertBClick(Sender: TObject);
var
  i: Integer;
  c: TfrxComponent;
  sl: TStringList;
  dy: Extended;
begin
  if FSelectedObjects.Count < 3 then Exit;

  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupAccept;

  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    sl.AddObject(Format('%4.4d', [Round(c.Top)]), c);
  end;

  dy := (TfrxComponent(sl.Objects[sl.Count - 1]).Top -
    TfrxComponent(sl.Objects[0]).Top) / (sl.Count - 1);

  for i := 1 to sl.Count - 2 do
  begin
    c := TfrxComponent(sl.Objects[i]);
    if not (rfDontMove in c.Restrictions) then
      c.Top := TfrxComponent(sl.Objects[i - 1]).Top + dy;
  end;

  sl.Free;
  Modified := True;
end;

procedure TfrxDesignerForm.SameWidthBClick(Sender: TObject);
var
  i: Integer;
  c0, c: TfrxComponent;
begin
  if FSelectedObjects.Count < 2 then Exit;

  c0 := FSelectedObjects[0];
  for i := 1 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontSize in c.Restrictions) then
      c.Width := c0.Width;
  end;

  Modified := True;
end;

procedure TfrxDesignerForm.SameHeightBClick(Sender: TObject);
var
  i: Integer;
  c0, c: TfrxComponent;
begin
  if FSelectedObjects.Count < 2 then Exit;

  c0 := FSelectedObjects[0];
  for i := 1 to FSelectedObjects.Count - 1 do
  begin
    c := FSelectedObjects[i];
    if not (rfDontSize in c.Restrictions) then
      c.Height := c0.Height;
  end;

  Modified := True;
end;


{ Save/restore state }
{------------------------------------------------------------------------------}

procedure TfrxDesignerForm.SaveState;
var
  Ini: TCustomIniFile;
  Nm: String;

  procedure SaveToolbars(t: array of TToolBar);
  var
    i: Integer;
  begin
    for i := Low(t) to High(t) do
      frxSaveToolbarPosition(Ini, t[i]);
  end;

  procedure SaveDocks(t: array of TfrxDockSite);
  var
    i: Integer;
  begin
    for i := Low(t) to High(t) do
      frxSaveDock(Ini, t[i]);
  end;

begin
  if IsPreviewDesigner then Exit;
  if WorkspaceColor = 0 then Exit;

  Ini := Report.GetIniFile;

  if Ini is TIniFile then
  begin
    Nm := ExtractFilePath(Ini.FileName);
    if not DirectoryExists(Nm) then
      if not CreateDir(Nm) then
      begin
        Ini.Free;
        Exit;
      end;
  end;

  Nm := 'Form5.TfrxDesignerForm';
  Ini.WriteInteger('Form5.TfrxObjectInspector', 'SplitPos', FInspector.SplitterPos);
  Ini.WriteInteger('Form5.TfrxObjectInspector', 'Split1Pos', FInspector.Splitter1Pos);
  Ini.WriteFloat(Nm, 'Scale', FScale);
  Ini.WriteBool(Nm, 'ShowGrid', FShowGrid);
  Ini.WriteBool(Nm, 'GridAlign', FGridAlign);
  Ini.WriteBool(Nm, 'ShowRulers', FShowRulers);
  Ini.WriteBool(Nm, 'ShowGuides', FShowGuides);
  Ini.WriteFloat(Nm, 'Grid1', FGridSize1);
  Ini.WriteFloat(Nm, 'Grid2', FGridSize2);
  Ini.WriteFloat(Nm, 'Grid3', FGridSize3);
  Ini.WriteFloat(Nm, 'Grid4', FGridSize4);
  FUnits := FOldUnits;
  Ini.WriteInteger(Nm, 'Units', Integer(FUnits));
  Ini.WriteString(Nm, 'ScriptFontName', CodeWindow.Font.Name);
  Ini.WriteInteger(Nm, 'ScriptFontSize', CodeWindow.Font.Size);
  Ini.WriteString(Nm, 'MemoFontName', MemoFontName);
  Ini.WriteInteger(Nm, 'MemoFontSize', MemoFontSize);
  Ini.WriteBool(Nm, 'UseObjectFont', UseObjectFont);
  Ini.WriteInteger(Nm, 'WorkspaceColor', FWorkspaceColor);
  Ini.WriteInteger(Nm, 'ToolsColor', FToolsColor);
  Ini.WriteBool(Nm, 'GridLCD', FWorkspace.GridLCD);
  Ini.WriteBool(Nm, 'EditAfterInsert', FEditAfterInsert);
  Ini.WriteBool(Nm, 'LocalizedOI', FLocalizedOI);
  if Ini is TIniFile then
    Ini.WriteString(Nm, 'RecentFiles', {'"'+}QuotedStr(FRecentFiles.CommaText){+'"'})
  else
    Ini.WriteString(Nm, 'RecentFiles', FRecentFiles.CommaText);

  FCodeWindow.SavePBToIni(Report.IniFile, Nm + '\BreakPoints\' + ExtractFileName(Report.FileName));

  Ini.WriteInteger(Nm, 'TabStops', FCodeWindow.TabStops);
  Ini.WriteInteger(Nm, 'ShowInCodeComplition', Integer(Byte(FCodeWindow.ShowInCodeComplition)));

  Ini.WriteBool(Nm, 'FreeBands', FWorkspace.FreeBandsPlacement);
  Ini.WriteInteger(Nm, 'BandsGap', FWorkspace.GapBetweenBands);
  Ini.WriteBool(Nm, 'ShowBandCaptions', FWorkspace.ShowBandCaptions);
  Ini.WriteBool(Nm, 'DropFields', FDropFields);
  Ini.WriteBool(Nm, 'ShowStartup', FShowStartup);
  if Ini is TIniFile then
  {$IFNDEF FPC}
    Ini.WriteString(Nm, 'WatchList', FWatchList.Watches.CommaText)
  else
    Ini.WriteString(Nm, 'WatchList', FWatchList.Watches.Text);
  {$ELSE}
    Ini.WriteString(Nm, 'WatchList', FBWForm.Watches.CommaText);
  {$ENDIF}
  Ini.WriteBool(Nm, 'StickToGuides', FStickToGuides);
  Ini.WriteBool(Nm, 'GuidesAsAnchor', FGuidesAsAnchor);

  frxSaveFormPosition(Ini, Self);
  frxSaveFormPosition(Ini, FInspector);
  frxSaveFormPosition(Ini, FDataTree);
  frxSaveFormPosition(Ini, FReportTree);
  {$IFNDEF FPC}
  frxSaveFormPosition(Ini, FWatchList);
  {$ELSE}
  frxSaveFormPosition(Ini, FBWForm);
  {$ENDIF}
  frxRegEditorsClasses.SaveToIni(Ini);

{$IFNDEF FPC}
  SaveToolbars([StandardTB, TextTB, FrameTB, AlignTB, ExtraToolsTB]);
{$ENDIF}
  if (FInspector.Name = 'frxObjectInspector') and (FDataTree.Name = 'frxDataTreeForm')
  and (FReportTree.Name  = 'frxReportTreeForm') and
   ({$IFNDEF FPC}FWatchList.Name = 'frxWatchForm'{$ELSE}FBWForm.Name = 'frxBWForm'{$ENDIF}) then
    SaveDocks([LeftDockSite1, LeftDockSite2, RightDockSite, CodeDockSite]);
  Ini.Free;
end;

procedure TfrxDesignerForm.RestoreState(RestoreDefault: Boolean = False;
  RestoreMainForm: Boolean = False);
const
  DefIni =
'[Form5.TfrxObjectInspector];' +
'Width=159;' +
'SplitPos=75;' +
'Split1Pos=65;' +
'Dock5=LeftDockSite2;' +
'[Form5.TfrxDesignerForm];' +
'EditAfterInsert=1;' +
'Maximized=1;' +
'[Form5.TfrxDataTreeForm];' +
'Width=143;' +
'Dock5=RightDockSite;' +
'[Form5.TfrxReportTreeForm];' +
'Width=159;' +
'Dock5=LeftDockSite2;' +
'[Form5.TfrxWatchForm];' +
'Height=100;' +
'Dock5=CodeDockSite;' +
'[ToolBar5.StandardTB];' +
'Float=0;' +
'Visible=1;' +
'Left=0;' +
'Top=0;' +
'Width=576;' +
'Height=27;' +
'Dock5=DockTop;' +
'[ToolBar5.TextTB];' +
'Float=0;' +
'Visible=1;' +
'Left=0;' +
'Top=27;' +
'Width=651;' +
'Height=27;' +
'Dock5=DockTop;' +
'[ToolBar5.FrameTB];' +
'Float=0;' +
'Visible=1;' +
'Left=651;' +
'Top=27;' +
'Width=305;' +
'Height=27;' +
'Dock5=DockTop;' +
'[ToolBar5.AlignTB];' +
'Visible=1;' +
'[ToolBar5.ExtraToolsTB];' +
'Visible=0;' +
'[Dock5.LeftDockSite2];' +
'Data=00000400000000004F0300000000000001A200000000000000010000000073000000110000006672785265706F727454726565466F726D01000000004F030000120000006672784F626A656374496E73706563746F72FFFFFFFF;' +
'Width=160;' +
'[Dock5.RightDockSite];' +
'Data=000004000000000000000000000000000000000000000000000100000000000000000F0000006672784461746154726565466F726DFFFFFFFF;' +
'Width=160';

var
  Ini: TCustomIniFile;
  Nm: String;

  procedure RestoreToolbars(t: array of TToolBar);
  var
    i: Integer;
  begin
    for i := Low(t) to High(t) do
    begin
      frxRestoreToolbarPosition(Ini, t[i]);
      t[i].ButtonWidth := 23;
      t[i].ButtonHeight := 23;
    end;

  end;

  procedure RestoreDocks(t: array of TfrxDockSite);
  var
    i: Integer;
  begin
    for i := Low(t) to High(t) do
      frxRestoreDock(Ini, t[i]);
  end;

  function Def(Value, DefValue: Extended): Extended;
  begin
    if Value = 0 then
      Result := DefValue else
      Result := Value;
  end;

  procedure DoRestore;
  begin
    if not RestoreMainForm then
    begin
      FInspector.SplitterPos := Ini.ReadInteger('Form5.TfrxObjectInspector',
        'SplitPos', FInspector.Width div 2);
      if FInspector.SplitterPos > FInspector.Width - 10 then
        FInspector.SplitterPos := FInspector.Width div 2;
      FInspector.Splitter1Pos := Ini.ReadInteger('Form5.TfrxObjectInspector',
        'Split1Pos', 65);
      if FInspector.Splitter1Pos < 10 then
        FInspector.Splitter1Pos := 65;
      Scale := Ini.ReadFloat(Nm, 'Scale', 1);
      ShowGrid := Ini.ReadBool(Nm, 'ShowGrid', True);
      GridAlign := Ini.ReadBool(Nm, 'GridAlign', True);
      ShowRulers := Ini.ReadBool(Nm, 'ShowRulers', True);
      ShowGuides := Ini.ReadBool(Nm, 'ShowGuides', True);
      StickToGuides := Ini.ReadBool(Nm, 'StickToGuides', True);
      GuidesAsAnchor := Ini.ReadBool(Nm, 'GuidesAsAnchor', True);
      FGridSize1 := Def(Ini.ReadFloat(Nm, 'Grid1', 0), 0.1);
      FGridSize2 := Def(Ini.ReadFloat(Nm, 'Grid2', 0), 0.1);
      FGridSize3 := Def(Ini.ReadFloat(Nm, 'Grid3', 0), 4);
      FGridSize4 := Def(Ini.ReadFloat(Nm, 'Grid4', 0), 4);
      Units := TfrxDesignerUnits(Ini.ReadInteger(Nm, 'Units', 0));
      FOldUnits := FUnits;
      CodeWindow.Font.Name := Ini.ReadString(Nm, 'ScriptFontName', 'Courier New');
      CodeWindow.Font.Size := Ini.ReadInteger(Nm, 'ScriptFontSize', 10);
      MemoFontName := Ini.ReadString(Nm, 'MemoFontName', {$IFNDEF LCLGTK2}'Arial'{$ELSE}'Nimbus Sans L'{$ENDIF});
      MemoFontSize := Ini.ReadInteger(Nm, 'MemoFontSize', 10);
      UseObjectFont := Ini.ReadBool(Nm, 'UseObjectFont', True);
      WorkspaceColor := Ini.ReadInteger(Nm, 'WorkspaceColor', clWindow);
      ToolsColor := Ini.ReadInteger(Nm, 'ToolsColor', clWindow);
      FWorkspace.GridLCD := Ini.ReadBool(Nm, 'GridLCD', False);
      FEditAfterInsert := Ini.ReadBool(Nm, 'EditAfterInsert', False);
      FRecentFiles.CommaText := Ini.ReadString(Nm, 'RecentFiles', '');
      FWorkspace.FreeBandsPlacement := Ini.ReadBool(Nm, 'FreeBands', False);
      FWorkspace.GapBetweenBands := Ini.ReadInteger(Nm, 'BandsGap', 4);
      FWorkspace.ShowBandCaptions := Ini.ReadBool(Nm, 'ShowBandCaptions', True);
      FDropFields := Ini.ReadBool(Nm, 'DropFields', True);
      FShowStartup := Ini.ReadBool(Nm, 'ShowStartup', True);
      if Ini is TIniFile then
      {$IFNDEF FPC}
        FWatchList.Watches.CommaText := Ini.ReadString(Nm, 'WatchList', '')
      else
        FWatchList.Watches.Text := Ini.ReadString(Nm, 'WatchList', '');
      {$ELSE}
        FBWForm.Watches.CommaText := Ini.ReadString(Nm, 'WatchList', '');
      {$ENDIF}
      FCodeWindow.LoadPBFromIni(Report.IniFile,  Nm + '\BreakPoints\' + ExtractFileName(Report.FileName));
      FCodeWindow.TabStops := Ini.ReadInteger(Nm, 'TabStops', 2);
      FCodeWindow.ShowInCodeComplition := TfrxCompletionListTypes(Byte(Ini.ReadInteger(Nm, 'ShowInCodeComplition', Integer(Byte(FCodeWindow.ShowInCodeComplition)))));
      {$IFNDEF FPC}
      FWatchList.UpdateWatches;
      {$ELSE}
      FBWForm.UpdateWatches;
      {$ENDIF}
      frxRestoreFormPosition(Ini, FInspector);
      if not IsPreviewDesigner then
      begin
        frxRestoreFormPosition(Ini, FDataTree);
        frxRestoreFormPosition(Ini, FReportTree);
        {$IFNDEF FPC}
        frxRestoreFormPosition(Ini, FWatchList);
        {$ELSE}
        frxRestoreFormPosition(Ini, FBWForm);
        {$ENDIF}
      end;

      frxRegEditorsClasses.LoadFromIni(Ini);
      if Assigned(FWorkspace) then
        FWorkspace.CreateInPlaceEditorsList;

      {$IFDEF FPC}
      // fix ugly positions.
      FInspector.Width := 240;
      FReportTree.Width := FInspector.Width;
      FReportTree.Height := Screen.Height div 5;
      FInspector.Top := FReportTree.Top + FReportTree.Height;
      {$ENDIF}
{$IFNDEF FPC}
      // dock panel works bad on fpc
      RestoreToolbars([StandardTB, AlignTB, TextTB, FrameTB, ExtraToolsTB]);
{$ENDIF}
      if not IsPreviewDesigner then
      begin
        RestoreDocks([LeftDockSite1, LeftDockSite2, RightDockSite, CodeDockSite]);
        {$IFDEF FPC}
        // cheat
        RightDockSite.Align:=alLeft;
        RightDockSite.Align:=alRight;
        // fix ugly positions.
        FInspector.Align := alClient;
        FDataTree.Align := alClient;
        FReportTree.Align := alTop;
        {$ENDIF}
      end;

      {$IFNDEF FPC}
      FBreakPoints.Visible := True;
      FBreakPoints.DragMode := dmManual;
      if FBreakPoints.Floating then
        FBreakPoints.ManualDock(CodeDockSite);
      FWatchList.Visible := True;
      FWatchList.DragMode := dmManual;
      if FWatchList.Floating then
        FWatchList.ManualDock(CodeDockSite);
      {$ELSE}
      FBWForm.Align := alClient;
      FBWForm.Visible:= True;
      FBWForm.DragMode:= dmManual;
      if FBWForm.Floating then
        FBWForm.ManualDock(CodeDockSite);
      {$ENDIF}

      with FCodeWindow do
      begin
  {$I frxDesgn.inc}
      end;
    end
    else
      frxRestoreFormPosition(Ini, Self);
  end;

  procedure ReadDefIni;
  var
    MemIni: TMemIniFile;
    sl: TStringList;
  begin
    Ini.Free;
    MemIni := TMemIniFile.Create('');

    sl := TStringList.Create;
    frxSetCommaText(DefIni, sl);
    MemIni.SetStrings(sl);
    sl.Free;
    Ini := MemIni;
  end;

begin
  Ini := Report.GetIniFile;
  Nm := 'Form5.TfrxDesignerForm';
  if RestoreDefault or (Ini.ReadFloat(Nm, 'Scale', 0) = 0) or
    (Ini.ReadInteger(Nm, 'WorkspaceColor', clWindow) = 0) then
    begin
      if Ini.SectionExists('Form5.TfrxMemoEditorForm') then
        Ini.EraseSection('Form5.TfrxMemoEditorForm');
      if Ini.SectionExists('Form5.TfrxRichEditorForm') then
        Ini.EraseSection('Form5.TfrxRichEditorForm');
      if Ini.SectionExists('Form5.TfrxSQLEditorForm') then
        Ini.EraseSection('Form5.TfrxSQLEditorForm');
      ReadDefIni;
    end;

  try
    try
      DoRestore;
    except
      ReadDefIni;
      DoRestore;
    end
  finally
    Ini.Free;
  end;
end;

procedure TfrxDesignerForm.Localize;
begin
  OpenScriptB.Hint := frxGet(2300);
  SaveScriptB.Hint := frxGet(2301);
  RunScriptB.Hint := frxGet(2302);
  StepScriptB.Hint := frxGet(2303);
  StopScriptB.Hint := frxGet(2304);
  EvaluateB.Hint := frxGet(2305);
  LangL.Caption := frxGet(2306);
  AlignTB.Caption := frxGet(2307);
  AlignLeftsB.Hint := frxGet(2308);
  AlignHorzCentersB.Hint := frxGet(2309);
  AlignRightsB.Hint := frxGet(2310);
  AlignTopsB.Hint := frxGet(2311);
  AlignVertCentersB.Hint := frxGet(2312);
  AlignBottomsB.Hint := frxGet(2313);
  SpaceHorzB.Hint := frxGet(2314);
  SpaceVertB.Hint := frxGet(2315);
  CenterHorzB.Hint := frxGet(2316);
  CenterVertB.Hint := frxGet(2317);
  SameWidthB.Hint := frxGet(2318);
  SameHeightB.Hint := frxGet(2319);
  TextTB.Caption := frxGet(2320);
  StyleCB.Hint := frxGet(2321);
  FontNameCB.Hint := frxGet(2322);
  FontSizeCB.Hint := frxGet(2323);
  BoldB.Hint := frxGet(2324);
  ItalicB.Hint := frxGet(2325);
  UnderlineB.Hint := frxGet(2326);
  FontColorB.Hint := frxGet(2327);
  HighlightB.Hint := frxGet(2328);
  RotateB.Hint := frxGet(2329);
  TextAlignLeftB.Hint := frxGet(2330);
  TextAlignCenterB.Hint := frxGet(2331);
  TextAlignRightB.Hint := frxGet(2332);
  TextAlignBlockB.Hint := frxGet(2333);
  TextAlignTopB.Hint := frxGet(2334);
  TextAlignMiddleB.Hint := frxGet(2335);
  TextAlignBottomB.Hint := frxGet(2336);
  FrameTB.Caption := frxGet(2337);
  FrameTopB.Hint := frxGet(2338);
  FrameBottomB.Hint := frxGet(2339);
  FrameLeftB.Hint := frxGet(2340);
  FrameRightB.Hint := frxGet(2341);
  FrameAllB.Hint := frxGet(2342);
  FrameNoB.Hint := frxGet(2343);
  FrameEditB.Hint := frxGet(2344);
  FillColorB.Hint := frxGet(2345);
  FillEditB.Hint := frxGet(2479);
  FrameColorB.Hint := frxGet(2346);
  FrameStyleB.Hint := frxGet(2347);
  FrameWidthCB.Hint := frxGet(2348);
  StandardTB.Caption := frxGet(2349);
  NewB.Hint := frxGet(2350);
  OpenB.Hint := frxGet(2351);
  SaveB.Hint := frxGet(2352);
  PreviewB.Hint := frxGet(2353);
  NewPageB.Hint := frxGet(2354);
  NewDialogB.Hint := frxGet(2355);
  DeletePageB.Hint := frxGet(2356);
  PageSettingsB.Hint := frxGet(2357);
  CutB.Hint := frxGet(2359);
  CopyB.Hint := frxGet(2360);
  PasteB.Hint := frxGet(2361);
  UndoB.Hint := frxGet(2363);
  RedoB.Hint := frxGet(2364);
  GroupB.Hint := frxGet(2365);
  UngroupB.Hint := frxGet(2366);
  ShowGridB.Hint := frxGet(2367);
  AlignToGridB.Hint := frxGet(2368);
  SetToGridB.Hint := frxGet(2369);
  ScaleCB.Hint := frxGet(2370);

  ExtraToolsTB.Caption := frxGet(2371);
  ObjectSelectB.Hint := frxGet(2372);
  HandToolB.Hint := frxGet(2373);
  ZoomToolB.Hint := frxGet(2374);
  TextToolB.Hint := frxGet(2375);
  FormatToolB.Hint := frxGet(2376);
  ObjectBandB.Hint := frxGet(2377);
  FileMenu.Caption := frxGet(2378);
  EditMenu.Caption := frxGet(2379);
  FindCmd.Caption := frxGet(2380);
  FindNextCmd.Caption := frxGet(2381);
  ReplaceCmd.Caption := frxGet(2382);
  ReportMenu.Caption := frxGet(2383);
  ReportDataCmd.Caption := frxGet(2384);
  ReportOptionsCmd.Caption := frxGet(2385);
  ReportStylesCmd.Caption := frxGet(2386);
  ViewMenu.Caption := frxGet(2387);
  ToolbarsCmd.Caption := frxGet(2388);
  StandardTBCmd.Caption := frxGet(2389);
  TextTBCmd.Caption := frxGet(2390);
  FrameTBCmd.Caption := frxGet(2391);
  AlignTBCmd.Caption := frxGet(2392);
  ExtraTBCmd.Caption := frxGet(2393);
  InspectorTBCmd.Caption := frxGet(2394);
  DataTreeTBCmd.Caption := frxGet(2395);
  ReportTreeTBCmd.Caption := frxGet(2396);
  ShowRulersCmd.Caption := frxGet(2397);
  ShowGuidesCmd.Caption := frxGet(2398);
  DeleteGuidesCmd.Caption := frxGet(2399);
  OptionsCmd.Caption := frxGet(2400);
  HelpMenu.Caption := frxGet(2401);
  HelpContentsCmd.Caption := frxGet(2402);
{$IFDEF FR_LITE}
  AboutCmd.Caption := StringReplace(frxGet(2403), 'FastReport', 'FreeReport', []);
{$ELSE}
  AboutCmd.Caption := frxGet(2403);
{$ENDIF}
  TabOrderMI.Caption := frxGet(2404);

  SelectAllOfTypeMI.Caption := frxGet(6300);
  SelectAllOfTypeOnPageMI.Caption := frxGet(6301);
  RevertInheritedMI.Caption := frxGet(6302);
  RevertInheritedChildMI.Caption := frxGet(6303);

  UndoCmd.Caption := frxGet(2405);
  RedoCmd.Caption := frxGet(2406);
  CutCmd.Caption := frxGet(2407);
  CopyCmd.Caption := frxGet(2408);
  CopyContentCmd.Caption := frxGet(160);
  PasteCmd.Caption := frxGet(2409);
  GroupCmd.Caption := frxGet(2410);
  UngroupCmd.Caption := frxGet(2411);
  DeleteCmd.Caption := frxGet(2412);
  DeletePageCmd.Caption := frxGet(2413);
  SelectAllCmd.Caption := frxGet(2414);
  EditCmd.Caption := frxGet(2415);
  BringToFrontCmd.Caption := frxGet(2416);
  SendToBackCmd.Caption := frxGet(2417);
  NewItemCmd.Caption := frxGet(2418);
  NewReportCmd.Caption := frxGet(2419);
  NewPageCmd.Caption := frxGet(2420);
  NewDialogCmd.Caption := frxGet(2421);
  OpenCmd.Caption := frxGet(2422);
  OpenMI.Caption := frxGet(2422);
  SaveCmd.Caption := frxGet(2423);
  SaveAsCmd.Caption := frxGet(2424);
  SaveAsMI.Caption := frxGet(2424);
  VariablesCmd.Caption := frxGet(2425);
  PageSettingsCmd.Caption := frxGet(2426);
  PreviewCmd.Caption := frxGet(2427);
  ExitCmd.Caption := frxGet(2428);
  ReportTitleMI.Caption := frxGet(2429);
  ReportSummaryMI.Caption := frxGet(2430);
  PageHeaderMI.Caption := frxGet(2431);
  PageFooterMI.Caption := frxGet(2432);
  HeaderMI.Caption := frxGet(2433);
  FooterMI.Caption := frxGet(2434);
  MasterDataMI.Caption := frxGet(2435);
  DetailDataMI.Caption := frxGet(2436);
  SubdetailDataMI.Caption := frxGet(2437);
  Data4levelMI.Caption := frxGet(2438);
  Data5levelMI.Caption := frxGet(2439);
  Data6levelMI.Caption := frxGet(2440);
  GroupHeaderMI.Caption := frxGet(2441);
  GroupFooterMI.Caption := frxGet(2442);
  ChildMI.Caption := frxGet(2443);
  ColumnHeaderMI.Caption := frxGet(2444);
  ColumnFooterMI.Caption := frxGet(2445);
  OverlayMI.Caption := frxGet(2446);
  VerticalbandsMI.Caption := frxGet(2447);
  HeaderMI1.Caption := frxGet(2448);
  FooterMI1.Caption := frxGet(2449);
  MasterDataMI1.Caption := frxGet(2450);
  DetailDataMI1.Caption := frxGet(2451);
  SubdetailDataMI1.Caption := frxGet(2452);
  GroupHeaderMI1.Caption := frxGet(2453);
  GroupFooterMI1.Caption := frxGet(2454);
  ChildMI1.Caption := frxGet(2455);
  R0MI.Caption := frxGet(2456);
  R45MI.Caption := frxGet(2457);
  R90MI.Caption := frxGet(2458);
  R180MI.Caption := frxGet(2459);
  R270MI.Caption := frxGet(2460);
  FontB.Hint := frxGet(2461);
  BoldMI.Caption := frxGet(2462);
  ItalicMI.Caption := frxGet(2463);
  UnderlineMI.Caption := frxGet(2464);
  SuperScriptMI.Caption := frxGet(2465);
  SubScriptMI.Caption := frxGet(2466);
  CondensedMI.Caption := frxGet(2467);
  WideMI.Caption := frxGet(2468);
  N12cpiMI.Caption := frxGet(2469);
  N15cpiMI.Caption := frxGet(2470);
  OpenDialog.Filter := frxGet(2471);
  OpenDialog.Options := OpenDialog.Options + [ofNoChangeDir];
  OpenScriptDialog.Options :=  OpenScriptDialog.Options + [ofNoChangeDir];
  SaveScriptDialog.Options :=  SaveScriptDialog.Options + [ofNoChangeDir];
  OpenScriptDialog.Filter := frxGet(2472);
  SaveScriptDialog.Filter := frxGet(2473);
  ConnectionsMI.Caption := frxGet(2474);
  BreakPointB.Hint := frxGet(2476);
  RunToCursorB.Hint := frxGet(2477);
  AddChildMI.Caption := frxGet(2478);
  EdConfigCmd.Caption := frxGet(6600);


  if Assigned(frxFR2Events.OnLoad) then
    OpenDialog.Filter := 'Report (*.' + FTemplateExt + ', ' + frxFR2Events.Filter + ')'
    + '|*.' + FTemplateExt +';' + frxFR2Events.Filter;
end;

procedure TfrxDesignerForm.CreateLangMenu;
var
  m, t: TMenuItem;
  i: Integer;
  reg: TRegistry;
  current: String;
begin
  current := '';
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey('\Software\Fast Reports\Resources', false) then
      current := reg.ReadString('Language');
  finally
    reg.Free;
  end;
  if frxResources.Languages.Count > 0 then
  begin
    m := TMenuItem.Create(ViewMenu);
    m.Caption := '-';
    ViewMenu.Add(m);
    m := TMenuItem.Create(ViewMenu);
    m.Caption := frxGet(2475);
    ViewMenu.Add(m);
    for i := 0 to frxResources.Languages.Count - 1 do
    begin
      t := TMenuItem.Create(m);
      t.Caption := frxResources.Languages[i];
      t.RadioItem := True;
      t.OnClick := LangSelectClick;
      if UpperCase(t.Caption) = UpperCase(current) then
        t.Checked := True;
      m.Add(t);
    end;
  end;
end;

procedure TfrxDesignerForm.LangSelectClick(Sender: TObject);
var
  m: TMenuItem;
  reg: TRegistry;
begin
  m := Sender as TMenuItem;
  m.Checked := True;
  frxResources.LoadFromFile(GetAppPath + m.Caption + '.frc');
  Localize;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey('\Software\Fast Reports\Resources', false) then
      reg.WriteString('Language', m.Caption);
  finally
    reg.Free;
  end;
end;

procedure TfrxDesignerForm.OnCodeCompletion(const Name: String; List: TfrxCompletionList);
var
  i: Integer;
  l: TList;
begin
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
    List.AddVariable(TfrxComponent(l[i]).Name, TfrxComponent(l[i]).ClassName);
  List.AddVariable('Report', Report.ClassName);
  List.AddVariable('Engine', Report.Engine.ClassName);
  List.AddVariable('Outline', Report.PreviewPages.Outline.ClassName);
  List.AddVariable('PreviewPages', Report.PreviewPages.ClassName);
end;

procedure TfrxDesignerForm.CodeDockSiteDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := not (Source.Control is TToolBar);
end;

procedure TfrxDesignerForm.OnDisableDock(Sender: TObject;
  var DragObject: TDragDockObject);
begin
  DockTop.DockSite := False;
  DockBottom.DockSite := False;
end;

procedure TfrxDesignerForm.OnEnableDock(Sender, Target: TObject; X, Y: Integer);
begin
  DockTop.DockSite := True;
  DockBottom.DockSite := True;
end;


procedure TfrxDesignerForm.StatusBarWndProc(var Message: TMessage);
begin
  {$IFNDEF FPC}
  if Message.Msg = WM_SYSCOLORCHANGE then
    DefWindowProc(StatusBar.Handle,Message.Msg,Message.WParam,Message.LParam)
  else
    FStatusBarOldWindowProc(Message);
  {$ENDIF}
end;

procedure TfrxDesignerForm.FormCreate(Sender: TObject);
begin
  {$IFDEF FPC}
  {$warning fixme handleneeded in form creation}
  // HandleNeeded;
  {$ELSE}
  FStatusBarOldWindowProc := StatusBar.WindowProc;
  StatusBar.WindowProc := StatusBarWndProc;
  {$ENDIF}
  LeftDockSite1.TopParentWin := Self;
  LeftDockSite2.TopParentWin := Self;
  RightDockSite.TopParentWin := Self;
  CodeDockSite.TopParentWin := Self;
  FontNameCB.IniFile := Report.GetIniFile;
{$IFDEF Delphi10}
  PanelTB1.ParentBackground := False;
  PanelTB2.ParentBackground := False;
  PanelTB3.ParentBackground := False;
  frTBPanel1.ParentBackground := False;
{$ENDIF}
{$IFDEF RAD_ED}
  VerticalbandsMI.Visible := False;
  VerticalbandsMI.Enabled := False;
{$ENDIF}
  if frxDesignerComp <> nil then
  begin
    if (Length(frxDesignerComp.FTemplatesExt) > 1) and
    (frxDesignerComp.FTemplatesExt[1] = '.') then
       Delete(frxDesignerComp.FTemplatesExt, 1, 1);
    FTemplateExt := frxDesignerComp.FTemplatesExt;
  end
  else
    FTemplateExt := 'fr3'
end;

procedure TfrxDesignerForm.CMDialogKey(var Message: TCMDialogKey);
begin
//need for avoid message from dialog buttons with prop Default = True
end;

procedure TfrxDesignerForm.GetTemplateList(List: TStrings);
var
  sr: TSearchRec;
  dir, DefExt: String;

  function NormalDir(const DirName: string): string;
  begin
    Result := DirName;
    {$IFDEF FPC}
    {$IFDEF MSWINDOWS}
    if (Length(Result) = 1) and (UpCase(Result[1]) in ['A'..'Z']) then
      Result := Result + ':\';
    {$ENDIF}
    if length(Result) > 0 then
      if Result[length(Result)] <> PathDelim then
        Result := Result + PathDelim;
    {$ELSE}
    if (Result <> '') and
{$IFDEF Delphi12}
      not (CharInSet(Result[Length(Result)], [':', '\'])) then
{$ELSE}
      not (Result[Length(Result)] in [':', '\']) then
{$ENDIF}
    begin
{$IFDEF Delphi12}
      if (Length(Result) = 1) and (CharInSet(UpCase(Result[1]),['A'..'Z'])) then
{$ELSE}
      if (Length(Result) = 1) and (UpCase(Result[1]) in ['A'..'Z']) then
{$ENDIF}
        Result := Result + ':\'
      else Result := Result + '\';
    end;
    {$ENDIF}
  end;

begin
  List.Clear;
  DefExt := FTemplateExt;

  if (frxDesignerComp <> nil) and Assigned(frxDesignerComp.OnGetTemplateList) then
    frxDesignerComp.OnGetTemplateList(List)
  else
  begin
    dir := FTemplatePath;
    if (Trim(dir) = '') or (Trim(dir) = '.') then
      if csDesigning in ComponentState then
        dir := GetCurrentDir
      else
        dir := ExtractFilePath(Application.ExeName);
    dir := NormalDir(dir);
    if FindFirst(dir + '*.' + DefExt, faAnyFile, sr) = 0 then
    begin
      repeat
        List.Add(dir + sr.Name);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;
end;


procedure TfrxDesignerForm.SetGridSize1(const Value: Extended);
begin
  if Value > 0 then
    FGridSize1 := Value;
end;

procedure TfrxDesignerForm.SetGridSize2(const Value: Extended);
begin
  if Value > 0 then
    FGridSize2 := Value;
end;

procedure TfrxDesignerForm.SetGridSize3(const Value: Extended);
begin
  if Value > 0 then
    FGridSize3 := Value;
end;

procedure TfrxDesignerForm.SetGridSize4(const Value: Extended);
begin
  if Value > 0 then
    FGridSize4 := Value;
end;

procedure TfrxDesignerForm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  if Page <> nil then
    if ssCtrl in Shift then
    begin
      if WheelDelta = 0 then exit;
      Scale := Scale + Round(WheelDelta / Abs(WheelDelta)) / 20;
      if Scale < 0.3 then
        Scale := 0.3;
      ScaleCB.Text := frxFloatToStr(Round(Scale * 100)) + '%';
      ScrollBox.SetFocus;
    end;
end;

procedure TfrxDesignerForm.UpdateWatches;
var
  ErrCount: Integer;
begin
  ErrCount := Report.Errors.Count;
  {$IFNDEF FPC}
  FWatchList.UpdateWatches;
  {$ELSE}
  FBWForm.UpdateWatches;
  {$ENDIF}
  ErrCount := Report.Errors.Count - ErrCount;
  while (ErrCount <> 0) do
  begin
    Report.Errors.Delete(Report.Errors.Count - 1);
    dec(ErrCount);
  end;
end;

procedure TfrxDesignerForm.UpdateWorkSpace(Sender: TObject);
begin
  Workspace.Invalidate;
end;

{$IFDEF FPC}
{procedure RegisterUnitfrxDesgn;
begin
  RegisterComponents('Fast Report 6',[TfrxDesigner]);
end;

procedure Register;
begin
  RegisterUnit('frxDesgn',@RegisterUnitfrxDesgn);
end;}
{$ENDIF}

procedure TfrxDesignerForm.CopyContentCmdExecute(Sender: TObject);
begin
  FWorkspace.InternalCopy;
end;

initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxDesigner, TControl);
{$ENDIF}
  frxDesignerClass := TfrxDesignerForm;

end.
