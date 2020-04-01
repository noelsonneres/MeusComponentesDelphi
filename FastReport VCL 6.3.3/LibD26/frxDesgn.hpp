// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDesgn.pas' rev: 33.00 (Windows)

#ifndef FrxdesgnHPP
#define FrxdesgnHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.Types.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ToolWin.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ActnList.hpp>
#include <Winapi.CommCtrl.hpp>
#include <frxClass.hpp>
#include <frxDock.hpp>
#include <frxCtrls.hpp>
#include <frxDesgnCtrls.hpp>
#include <frxDesgnWorkspace.hpp>
#include <frxInsp.hpp>
#include <frxDialogForm.hpp>
#include <frxDataTree.hpp>
#include <frxReportTree.hpp>
#include <frxSynMemo.hpp>
#include <fs_iinterpreter.hpp>
#include <Vcl.Printers.hpp>
#include <frxWatchForm.hpp>
#include <frxBreakPointsForm.hpp>
#include <frxPictureCache.hpp>
#include <System.Variants.hpp>
#include <System.Actions.hpp>
#include <Vcl.GraphUtil.hpp>
#include <Vcl.Tabs.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdesgn
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDesigner;
class DELPHICLASS TfrxDesignerForm;
class DELPHICLASS TSampleFormat;
class DELPHICLASS TfrxCustomSavePlugin;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxDesignerUnits : unsigned char { duCM, duInches, duPixels, duChars };

typedef bool __fastcall (__closure *TfrxLoadReportEvent)(Frxclass::TfrxReport* Report);

typedef bool __fastcall (__closure *TfrxLoadRecentReportEvent)(Frxclass::TfrxReport* Report, System::UnicodeString FileName);

typedef bool __fastcall (__closure *TfrxSaveReportEvent)(Frxclass::TfrxReport* Report, bool SaveAs);

typedef void __fastcall (__closure *TfrxGetTemplateListEvent)(System::Classes::TStrings* List);

enum DECLSPEC_DENUM TfrxDesignerRestriction : unsigned char { drDontInsertObject, drDontDeletePage, drDontCreatePage, drDontChangePageOptions, drDontCreateReport, drDontLoadReport, drDontSaveReport, drDontPreviewReport, drDontEditVariables, drDontChangeReportOptions, drDontEditReportData, drDontShowRecentFiles, drDontEditReportScript, drDontEditInternalDatasets };

typedef System::Set<TfrxDesignerRestriction, TfrxDesignerRestriction::drDontInsertObject, TfrxDesignerRestriction::drDontEditInternalDatasets> TfrxDesignerRestrictions;

class PASCALIMPLEMENTATION TfrxDesigner : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	bool FCloseQuery;
	System::UnicodeString FDefaultScriptLanguage;
	Vcl::Graphics::TFont* FDefaultFont;
	System::Extended FDefaultLeftMargin;
	System::Extended FDefaultBottomMargin;
	System::Extended FDefaultRightMargin;
	System::Extended FDefaultTopMargin;
	int FDefaultPaperSize;
	System::Uitypes::TPrinterOrientation FDefaultOrientation;
	bool FGradient;
	System::Uitypes::TColor FGradientEnd;
	System::Uitypes::TColor FGradientStart;
	System::UnicodeString FOpenDir;
	System::UnicodeString FSaveDir;
	System::UnicodeString FTemplatesExt;
	System::UnicodeString FTemplateDir;
	bool FStandalone;
	TfrxDesignerRestrictions FRestrictions;
	bool FRTLLanguage;
	bool FMemoParentFont;
	TfrxLoadReportEvent FOnLoadReport;
	TfrxLoadRecentReportEvent FOnLoadRecentReport;
	TfrxSaveReportEvent FOnSaveReport;
	System::Classes::TNotifyEvent FOnShow;
	System::Classes::TNotifyEvent FOnInsertObject;
	TfrxGetTemplateListEvent FOnGetTemplateList;
	System::Classes::TNotifyEvent FOnShowStartupScreen;
	void __fastcall SetDefaultFont(Vcl::Graphics::TFont* const Value);
	
public:
	__fastcall virtual TfrxDesigner(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDesigner();
	
__published:
	__property bool CloseQuery = {read=FCloseQuery, write=FCloseQuery, default=1};
	__property System::UnicodeString DefaultScriptLanguage = {read=FDefaultScriptLanguage, write=FDefaultScriptLanguage};
	__property Vcl::Graphics::TFont* DefaultFont = {read=FDefaultFont, write=SetDefaultFont};
	__property System::Extended DefaultLeftMargin = {read=FDefaultLeftMargin, write=FDefaultLeftMargin};
	__property System::Extended DefaultRightMargin = {read=FDefaultRightMargin, write=FDefaultRightMargin};
	__property System::Extended DefaultTopMargin = {read=FDefaultTopMargin, write=FDefaultTopMargin};
	__property System::Extended DefaultBottomMargin = {read=FDefaultBottomMargin, write=FDefaultBottomMargin};
	__property int DefaultPaperSize = {read=FDefaultPaperSize, write=FDefaultPaperSize, nodefault};
	__property System::Uitypes::TPrinterOrientation DefaultOrientation = {read=FDefaultOrientation, write=FDefaultOrientation, nodefault};
	__property bool Gradient = {read=FGradient, write=FGradient, default=0};
	__property System::Uitypes::TColor GradientEnd = {read=FGradientEnd, write=FGradientEnd, nodefault};
	__property System::Uitypes::TColor GradientStart = {read=FGradientStart, write=FGradientStart, nodefault};
	__property System::UnicodeString OpenDir = {read=FOpenDir, write=FOpenDir};
	__property System::UnicodeString SaveDir = {read=FSaveDir, write=FSaveDir};
	__property System::UnicodeString TemplatesExt = {read=FTemplatesExt, write=FTemplatesExt};
	__property System::UnicodeString TemplateDir = {read=FTemplateDir, write=FTemplateDir};
	__property bool Standalone = {read=FStandalone, write=FStandalone, default=0};
	__property TfrxDesignerRestrictions Restrictions = {read=FRestrictions, write=FRestrictions, nodefault};
	__property bool RTLLanguage = {read=FRTLLanguage, write=FRTLLanguage, nodefault};
	__property bool MemoParentFont = {read=FMemoParentFont, write=FMemoParentFont, nodefault};
	__property TfrxLoadReportEvent OnLoadReport = {read=FOnLoadReport, write=FOnLoadReport};
	__property TfrxLoadRecentReportEvent OnLoadRecentReport = {read=FOnLoadRecentReport, write=FOnLoadRecentReport};
	__property TfrxSaveReportEvent OnSaveReport = {read=FOnSaveReport, write=FOnSaveReport};
	__property System::Classes::TNotifyEvent OnShow = {read=FOnShow, write=FOnShow};
	__property System::Classes::TNotifyEvent OnInsertObject = {read=FOnInsertObject, write=FOnInsertObject};
	__property System::Classes::TNotifyEvent OnShowStartupScreen = {read=FOnShowStartupScreen, write=FOnShowStartupScreen};
	__property TfrxGetTemplateListEvent OnGetTemplateList = {read=FOnGetTemplateList, write=FOnGetTemplateList};
};


class PASCALIMPLEMENTATION TfrxDesignerForm : public Frxclass::TfrxCustomDesigner
{
	typedef Frxclass::TfrxCustomDesigner inherited;
	
__published:
	Vcl::Extctrls::TBevel* Bevel1;
	Vcl::Comctrls::TStatusBar* StatusBar;
	Vcl::Extctrls::TControlBar* DockBottom;
	Vcl::Extctrls::TControlBar* DockTop;
	Vcl::Comctrls::TToolBar* TextTB;
	Frxdock::TfrxTBPanel* PanelTB1;
	Frxctrls::TfrxComboBox* FontSizeCB;
	Frxctrls::TfrxFontComboBox* FontNameCB;
	Vcl::Comctrls::TToolButton* BoldB;
	Vcl::Comctrls::TToolButton* ItalicB;
	Vcl::Comctrls::TToolButton* UnderlineB;
	Vcl::Comctrls::TToolButton* SepTB8;
	Vcl::Comctrls::TToolButton* FontColorB;
	Vcl::Comctrls::TToolButton* HighlightB;
	Vcl::Comctrls::TToolButton* SepTB9;
	Vcl::Comctrls::TToolButton* TextAlignLeftB;
	Vcl::Comctrls::TToolButton* TextAlignCenterB;
	Vcl::Comctrls::TToolButton* TextAlignRightB;
	Vcl::Comctrls::TToolButton* TextAlignBlockB;
	Vcl::Comctrls::TToolButton* SepTB10;
	Vcl::Comctrls::TToolButton* TextAlignTopB;
	Vcl::Comctrls::TToolButton* TextAlignMiddleB;
	Vcl::Comctrls::TToolButton* TextAlignBottomB;
	Vcl::Comctrls::TToolBar* FrameTB;
	Vcl::Comctrls::TToolButton* FrameTopB;
	Vcl::Comctrls::TToolButton* FrameBottomB;
	Vcl::Comctrls::TToolButton* FrameLeftB;
	Vcl::Comctrls::TToolButton* FrameRightB;
	Vcl::Comctrls::TToolButton* SepTB11;
	Vcl::Comctrls::TToolButton* FrameAllB;
	Vcl::Comctrls::TToolButton* FrameNoB;
	Vcl::Comctrls::TToolButton* SepTB12;
	Vcl::Comctrls::TToolButton* FillColorB;
	Vcl::Comctrls::TToolButton* FrameColorB;
	Vcl::Comctrls::TToolButton* FrameStyleB;
	Frxdock::TfrxTBPanel* PanelTB2;
	Frxctrls::TfrxComboBox* FrameWidthCB;
	Vcl::Comctrls::TToolBar* StandardTB;
	Vcl::Comctrls::TToolButton* NewB;
	Vcl::Comctrls::TToolButton* OpenB;
	Vcl::Comctrls::TToolButton* SaveB;
	Vcl::Comctrls::TToolButton* PreviewB;
	Vcl::Comctrls::TToolButton* CutB;
	Vcl::Comctrls::TToolButton* CopyB;
	Vcl::Comctrls::TToolButton* PasteB;
	Vcl::Comctrls::TToolButton* SepTB2;
	Vcl::Comctrls::TToolButton* UndoB;
	Vcl::Comctrls::TToolButton* RedoB;
	Vcl::Comctrls::TToolButton* SepTB3;
	Vcl::Comctrls::TToolButton* SepTB4;
	Vcl::Comctrls::TToolButton* NewPageB;
	Vcl::Comctrls::TToolButton* NewDialogB;
	Vcl::Comctrls::TToolButton* DeletePageB;
	Vcl::Comctrls::TToolButton* PageSettingsB;
	Vcl::Comctrls::TToolButton* ShowGridB;
	Vcl::Comctrls::TToolButton* AlignToGridB;
	Vcl::Comctrls::TToolBar* ExtraToolsTB;
	Vcl::Menus::TPopupMenu* PagePopup;
	Vcl::Menus::TMenuItem* CutMI1;
	Vcl::Menus::TMenuItem* CopyMI1;
	Vcl::Menus::TMenuItem* PasteMI1;
	Vcl::Menus::TMenuItem* DeleteMI1;
	Vcl::Menus::TMenuItem* SelectAllMI1;
	Vcl::Menus::TMenuItem* SepMI8;
	Vcl::Menus::TMenuItem* EditMI1;
	Vcl::Menus::TMainMenu* MainMenu;
	Vcl::Menus::TMenuItem* FileMenu;
	Vcl::Menus::TMenuItem* EditMenu;
	Vcl::Menus::TMenuItem* ViewMenu;
	Vcl::Menus::TMenuItem* ToolbarsMI;
	Vcl::Menus::TMenuItem* StandardMI;
	Vcl::Menus::TMenuItem* TextMI;
	Vcl::Menus::TMenuItem* FrameMI;
	Vcl::Menus::TMenuItem* AlignmentMI;
	Vcl::Menus::TMenuItem* ToolsMI;
	Vcl::Menus::TMenuItem* InspectorMI;
	Vcl::Menus::TMenuItem* DataTreeMI;
	Vcl::Menus::TMenuItem* OptionsMI;
	Vcl::Menus::TMenuItem* HelpMenu;
	Vcl::Menus::TMenuItem* HelpContentsMI;
	Vcl::Menus::TMenuItem* SepMI7;
	Vcl::Menus::TMenuItem* AboutMI;
	Vcl::Dialogs::TOpenDialog* OpenDialog;
	Vcl::Menus::TPopupMenu* TabPopup;
	Vcl::Menus::TMenuItem* NewPageMI1;
	Vcl::Menus::TMenuItem* NewDialogMI1;
	Vcl::Menus::TMenuItem* DeletePageMI1;
	Vcl::Menus::TMenuItem* PageSettingsMI1;
	Vcl::Actnlist::TActionList* ActionList;
	Vcl::Actnlist::TAction* ExitCmd;
	Vcl::Actnlist::TAction* CutCmd;
	Vcl::Actnlist::TAction* CopyCmd;
	Vcl::Actnlist::TAction* PasteCmd;
	Vcl::Actnlist::TAction* UndoCmd;
	Vcl::Actnlist::TAction* RedoCmd;
	Vcl::Actnlist::TAction* DeleteCmd;
	Vcl::Actnlist::TAction* SelectAllCmd;
	Vcl::Actnlist::TAction* EditCmd;
	Vcl::Actnlist::TAction* BringToFrontCmd;
	Vcl::Actnlist::TAction* SendToBackCmd;
	Vcl::Actnlist::TAction* DeletePageCmd;
	Vcl::Actnlist::TAction* NewItemCmd;
	Vcl::Actnlist::TAction* NewPageCmd;
	Vcl::Actnlist::TAction* NewDialogCmd;
	Vcl::Actnlist::TAction* NewReportCmd;
	Vcl::Actnlist::TAction* OpenCmd;
	Vcl::Actnlist::TAction* SaveCmd;
	Vcl::Actnlist::TAction* SaveAsCmd;
	Vcl::Actnlist::TAction* VariablesCmd;
	Vcl::Actnlist::TAction* PageSettingsCmd;
	Vcl::Actnlist::TAction* PreviewCmd;
	Vcl::Menus::TMenuItem* NewMI;
	Vcl::Menus::TMenuItem* NewReportMI;
	Vcl::Menus::TMenuItem* NewPageMI;
	Vcl::Menus::TMenuItem* NewDialogMI;
	Vcl::Menus::TMenuItem* SepMI1;
	Vcl::Menus::TMenuItem* OpenMI;
	Vcl::Menus::TMenuItem* SaveMI;
	Vcl::Menus::TMenuItem* SaveAsMI;
	Vcl::Menus::TMenuItem* VariablesMI;
	Vcl::Menus::TMenuItem* SepMI3;
	Vcl::Menus::TMenuItem* PreviewMI;
	Vcl::Menus::TMenuItem* SepMI4;
	Vcl::Menus::TMenuItem* ExitMI;
	Vcl::Menus::TMenuItem* UndoMI;
	Vcl::Menus::TMenuItem* RedoMI;
	Vcl::Menus::TMenuItem* SepMI5;
	Vcl::Menus::TMenuItem* CutMI;
	Vcl::Menus::TMenuItem* CopyMI;
	Vcl::Menus::TMenuItem* PasteMI;
	Vcl::Menus::TMenuItem* DeleteMI;
	Vcl::Menus::TMenuItem* DeletePageMI;
	Vcl::Menus::TMenuItem* SelectAllMI;
	Vcl::Menus::TMenuItem* SepMI6;
	Vcl::Menus::TMenuItem* BringtoFrontMI;
	Vcl::Menus::TMenuItem* SendtoBackMI;
	Vcl::Menus::TMenuItem* EditMI;
	Frxdock::TfrxTBPanel* PanelTB3;
	Frxctrls::TfrxComboBox* ScaleCB;
	Vcl::Comctrls::TToolBar* ObjectsTB1;
	Vcl::Menus::TPopupMenu* BandsPopup;
	Vcl::Menus::TMenuItem* ReportTitleMI;
	Vcl::Menus::TMenuItem* ReportSummaryMI;
	Vcl::Menus::TMenuItem* PageHeaderMI;
	Vcl::Menus::TMenuItem* PageFooterMI;
	Vcl::Menus::TMenuItem* HeaderMI;
	Vcl::Menus::TMenuItem* FooterMI;
	Vcl::Menus::TMenuItem* MasterDataMI;
	Vcl::Menus::TMenuItem* DetailDataMI;
	Vcl::Menus::TMenuItem* SubdetailDataMI;
	Vcl::Menus::TMenuItem* GroupHeaderMI;
	Vcl::Menus::TMenuItem* GroupFooterMI;
	Vcl::Menus::TMenuItem* ColumnHeaderMI;
	Vcl::Menus::TMenuItem* ColumnFooterMI;
	Vcl::Menus::TMenuItem* ChildMI;
	Frxdock::TfrxDockSite* LeftDockSite1;
	Vcl::Comctrls::TToolButton* SepTB13;
	Vcl::Menus::TMenuItem* PageSettingsMI;
	Vcl::Extctrls::TTimer* Timer;
	Vcl::Menus::TMenuItem* ReportSettingsMI;
	Vcl::Menus::TMenuItem* Data4levelMI;
	Vcl::Menus::TMenuItem* Data5levelMI;
	Vcl::Menus::TMenuItem* Data6levelMI;
	Vcl::Menus::TMenuItem* SepMI10;
	Vcl::Menus::TMenuItem* SepMI9;
	Vcl::Menus::TMenuItem* ShowGuidesMI;
	Vcl::Menus::TMenuItem* ShowRulersMI;
	Vcl::Menus::TMenuItem* DeleteGuidesMI;
	Vcl::Menus::TMenuItem* SepMI11;
	Vcl::Menus::TMenuItem* N1;
	Vcl::Menus::TMenuItem* BringtoFrontMI1;
	Vcl::Menus::TMenuItem* SendtoBackMI1;
	Vcl::Menus::TMenuItem* SepMI12;
	Vcl::Comctrls::TToolButton* RotateB;
	Vcl::Menus::TPopupMenu* RotationPopup;
	Vcl::Menus::TMenuItem* R0MI;
	Vcl::Menus::TMenuItem* R45MI;
	Vcl::Menus::TMenuItem* R90MI;
	Vcl::Menus::TMenuItem* R180MI;
	Vcl::Menus::TMenuItem* R270MI;
	Vcl::Comctrls::TToolButton* SetToGridB;
	Vcl::Comctrls::TToolButton* FrameEditB;
	Vcl::Menus::TMenuItem* ReportMenu;
	Vcl::Menus::TMenuItem* ReportDataMI;
	Vcl::Dialogs::TOpenDialog* OpenScriptDialog;
	Vcl::Dialogs::TSaveDialog* SaveScriptDialog;
	Vcl::Menus::TMenuItem* ReportTreeMI;
	Vcl::Menus::TPopupMenu* ObjectsPopup;
	Vcl::Comctrls::TToolBar* AlignTB;
	Vcl::Comctrls::TToolButton* AlignLeftsB;
	Vcl::Comctrls::TToolButton* AlignHorzCentersB;
	Vcl::Comctrls::TToolButton* AlignRightsB;
	Vcl::Comctrls::TToolButton* AlignTopsB;
	Vcl::Comctrls::TToolButton* AlignVertCentersB;
	Vcl::Comctrls::TToolButton* AlignBottomsB;
	Vcl::Comctrls::TToolButton* SpaceHorzB;
	Vcl::Comctrls::TToolButton* SpaceVertB;
	Vcl::Comctrls::TToolButton* CenterHorzB;
	Vcl::Comctrls::TToolButton* CenterVertB;
	Vcl::Comctrls::TToolButton* SameWidthB;
	Vcl::Comctrls::TToolButton* SameHeightB;
	Vcl::Comctrls::TToolButton* SepTB15;
	Vcl::Comctrls::TToolButton* SepTB16;
	Vcl::Comctrls::TToolButton* SepTB18;
	Vcl::Comctrls::TToolButton* SepTB17;
	Vcl::Menus::TMenuItem* OverlayMI;
	Frxctrls::TfrxComboBox* StyleCB;
	Vcl::Menus::TMenuItem* ReportStylesMI;
	Vcl::Menus::TMenuItem* TabOrderMI;
	Vcl::Menus::TMenuItem* N2;
	Vcl::Menus::TMenuItem* FindMI;
	Vcl::Menus::TMenuItem* FindNextMI;
	Vcl::Menus::TMenuItem* ReplaceMI;
	Vcl::Menus::TPopupMenu* DMPPopup;
	Vcl::Menus::TMenuItem* BoldMI;
	Vcl::Menus::TMenuItem* ItalicMI;
	Vcl::Menus::TMenuItem* UnderlineMI;
	Vcl::Menus::TMenuItem* SuperScriptMI;
	Vcl::Menus::TMenuItem* SubScriptMI;
	Vcl::Menus::TMenuItem* CondensedMI;
	Vcl::Menus::TMenuItem* WideMI;
	Vcl::Menus::TMenuItem* N12cpiMI;
	Vcl::Menus::TMenuItem* N15cpiMI;
	Vcl::Comctrls::TToolButton* FontB;
	Vcl::Menus::TMenuItem* VerticalbandsMI;
	Vcl::Menus::TMenuItem* HeaderMI1;
	Vcl::Menus::TMenuItem* FooterMI1;
	Vcl::Menus::TMenuItem* MasterDataMI1;
	Vcl::Menus::TMenuItem* DetailDataMI1;
	Vcl::Menus::TMenuItem* SubdetailDataMI1;
	Vcl::Menus::TMenuItem* GroupHeaderMI1;
	Vcl::Menus::TMenuItem* GroupFooterMI1;
	Vcl::Menus::TMenuItem* ChildMI1;
	Vcl::Menus::TMenuItem* N3;
	Vcl::Comctrls::TToolButton* GroupB;
	Vcl::Comctrls::TToolButton* UngroupB;
	Vcl::Comctrls::TToolButton* SepTB20;
	Vcl::Actnlist::TAction* GroupCmd;
	Vcl::Actnlist::TAction* UngroupCmd;
	Vcl::Menus::TMenuItem* GroupMI;
	Vcl::Menus::TMenuItem* UngroupMI;
	Vcl::Menus::TMenuItem* ConnectionsMI;
	Vcl::Extctrls::TPanel* BackPanel;
	Vcl::Extctrls::TPanel* ScrollBoxPanel;
	Frxdesgnctrls::TfrxScrollBox* ScrollBox;
	Frxdesgnctrls::TfrxRuler* LeftRuler;
	Frxdesgnctrls::TfrxRuler* TopRuler;
	Vcl::Extctrls::TPanel* CodePanel;
	Vcl::Comctrls::TToolBar* CodeTB;
	Frxdock::TfrxTBPanel* frTBPanel1;
	Vcl::Stdctrls::TLabel* LangL;
	Frxctrls::TfrxComboBox* LangCB;
	Vcl::Comctrls::TToolButton* OpenScriptB;
	Vcl::Comctrls::TToolButton* SaveScriptB;
	Vcl::Comctrls::TToolButton* SepTB19;
	Vcl::Comctrls::TToolButton* RunScriptB;
	Vcl::Comctrls::TToolButton* RunToCursorB;
	Vcl::Comctrls::TToolButton* StepScriptB;
	Vcl::Comctrls::TToolButton* StopScriptB;
	Vcl::Comctrls::TToolButton* EvaluateB;
	Vcl::Comctrls::TToolButton* BreakPointB;
	Frxdock::TfrxDockSite* CodeDockSite;
	Frxdock::TfrxDockSite* LeftDockSite2;
	Frxdock::TfrxDockSite* RightDockSite;
	Vcl::Extctrls::TPanel* TabPanel;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Menus::TMenuItem* AddChildMI;
	Vcl::Actnlist::TAction* FindCmd;
	Vcl::Actnlist::TAction* ReplaceCmd;
	Vcl::Actnlist::TAction* FindNextCmd;
	Vcl::Actnlist::TAction* ReportDataCmd;
	Vcl::Actnlist::TAction* ReportStylesCmd;
	Vcl::Actnlist::TAction* ReportOptionsCmd;
	Vcl::Actnlist::TAction* ShowRulersCmd;
	Vcl::Actnlist::TAction* ShowGuidesCmd;
	Vcl::Actnlist::TAction* DeleteGuidesCmd;
	Vcl::Actnlist::TAction* OptionsCmd;
	Vcl::Actnlist::TAction* HelpContentsCmd;
	Vcl::Actnlist::TAction* AboutCmd;
	Vcl::Actnlist::TAction* StandardTBCmd;
	Vcl::Actnlist::TAction* TextTBCmd;
	Vcl::Actnlist::TAction* FrameTBCmd;
	Vcl::Actnlist::TAction* AlignTBCmd;
	Vcl::Actnlist::TAction* ExtraTBCmd;
	Vcl::Actnlist::TAction* InspectorTBCmd;
	Vcl::Actnlist::TAction* DataTreeTBCmd;
	Vcl::Actnlist::TAction* ReportTreeTBCmd;
	Vcl::Actnlist::TAction* ToolbarsCmd;
	Vcl::Menus::TPopupMenu* FontColorPopupMenu;
	Vcl::Menus::TPopupMenu* FillColorPopupMenu;
	Vcl::Menus::TPopupMenu* FrameColorPopupMenu;
	Vcl::Comctrls::TToolButton* ToolButton1;
	Vcl::Comctrls::TToolButton* FillEditB;
	Vcl::Menus::TMenuItem* RevertInheritedMI;
	Vcl::Menus::TMenuItem* RevertInheritedChildMI;
	Vcl::Menus::TMenuItem* SelectAllOfTypeMI;
	Vcl::Actnlist::TAction* SelectAllOfTypeCmd;
	Vcl::Menus::TMenuItem* SelectAllOfTypeOnPageMI;
	Vcl::Menus::TMenuItem* EdConfigMI;
	Vcl::Actnlist::TAction* EdConfigCmd;
	Vcl::Actnlist::TAction* CopyContentCmd;
	Vcl::Menus::TMenuItem* CopyContent1;
	Vcl::Menus::TMenuItem* CopyContent2;
	void __fastcall ExitCmdExecute(System::TObject* Sender);
	void __fastcall ObjectsButtonClick(System::TObject* Sender);
	void __fastcall StatusBarDrawPanel(Vcl::Comctrls::TStatusBar* StatusBar, Vcl::Comctrls::TStatusPanel* Panel, const System::Types::TRect &ARect);
	void __fastcall ScrollBoxMouseWheelUp(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall ScrollBoxMouseWheelDown(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall ScrollBoxResize(System::TObject* Sender);
	void __fastcall ScaleCBClick(System::TObject* Sender);
	void __fastcall ShowGridBClick(System::TObject* Sender);
	void __fastcall AlignToGridBClick(System::TObject* Sender);
	void __fastcall StatusBarDblClick(System::TObject* Sender);
	void __fastcall StatusBarMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall InsertBandClick(System::TObject* Sender);
	void __fastcall BandsPopupPopup(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall NewReportCmdExecute(System::TObject* Sender);
	void __fastcall ToolButtonClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FontColorBClick(System::TObject* Sender);
	void __fastcall FrameStyleBClick(System::TObject* Sender);
	void __fastcall TabChange(System::TObject* Sender);
	void __fastcall UndoCmdExecute(System::TObject* Sender);
	void __fastcall RedoCmdExecute(System::TObject* Sender);
	void __fastcall CutCmdExecute(System::TObject* Sender);
	void __fastcall CopyCmdExecute(System::TObject* Sender);
	void __fastcall PasteCmdExecute(System::TObject* Sender);
	void __fastcall TimerTimer(System::TObject* Sender);
	void __fastcall DeletePageCmdExecute(System::TObject* Sender);
	void __fastcall NewDialogCmdExecute(System::TObject* Sender);
	void __fastcall NewPageCmdExecute(System::TObject* Sender);
	void __fastcall SaveCmdExecute(System::TObject* Sender);
	void __fastcall SaveAsCmdExecute(System::TObject* Sender);
	void __fastcall OpenCmdExecute(System::TObject* Sender);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall DeleteCmdExecute(System::TObject* Sender);
	void __fastcall SelectAllCmdExecute(System::TObject* Sender);
	void __fastcall EditCmdExecute(System::TObject* Sender);
	void __fastcall TabChanging(System::TObject* Sender, bool &AllowChange);
	void __fastcall PageSettingsCmdExecute(System::TObject* Sender);
	void __fastcall TopRulerDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall AlignLeftsBClick(System::TObject* Sender);
	void __fastcall AlignRightsBClick(System::TObject* Sender);
	void __fastcall AlignTopsBClick(System::TObject* Sender);
	void __fastcall AlignBottomsBClick(System::TObject* Sender);
	void __fastcall AlignHorzCentersBClick(System::TObject* Sender);
	void __fastcall AlignVertCentersBClick(System::TObject* Sender);
	void __fastcall CenterHorzBClick(System::TObject* Sender);
	void __fastcall CenterVertBClick(System::TObject* Sender);
	void __fastcall SpaceHorzBClick(System::TObject* Sender);
	void __fastcall SpaceVertBClick(System::TObject* Sender);
	void __fastcall SelectToolBClick(System::TObject* Sender);
	void __fastcall PagePopupPopup(System::TObject* Sender);
	void __fastcall BringToFrontCmdExecute(System::TObject* Sender);
	void __fastcall SendToBackCmdExecute(System::TObject* Sender);
	void __fastcall LangCBClick(System::TObject* Sender);
	void __fastcall OpenScriptBClick(System::TObject* Sender);
	void __fastcall SaveScriptBClick(System::TObject* Sender);
	void __fastcall CodeWindowDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall CodeWindowDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall VariablesCmdExecute(System::TObject* Sender);
	void __fastcall ObjectBandBClick(System::TObject* Sender);
	void __fastcall PreviewCmdExecute(System::TObject* Sender);
	void __fastcall HighlightBClick(System::TObject* Sender);
	void __fastcall TabMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall TabMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall TabMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall TabDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall TabDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall SameWidthBClick(System::TObject* Sender);
	void __fastcall SameHeightBClick(System::TObject* Sender);
	void __fastcall NewItemCmdExecute(System::TObject* Sender);
	void __fastcall TabOrderMIClick(System::TObject* Sender);
	void __fastcall RunScriptBClick(System::TObject* Sender);
	void __fastcall StopScriptBClick(System::TObject* Sender);
	void __fastcall EvaluateBClick(System::TObject* Sender);
	void __fastcall GroupCmdExecute(System::TObject* Sender);
	void __fastcall UngroupCmdExecute(System::TObject* Sender);
	void __fastcall ConnectionsMIClick(System::TObject* Sender);
	void __fastcall LangSelectClick(System::TObject* Sender);
	void __fastcall BreakPointBClick(System::TObject* Sender);
	void __fastcall RunToCursorBClick(System::TObject* Sender);
	void __fastcall CodeDockSiteDockOver(System::TObject* Sender, Vcl::Controls::TDragDockObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall TabSetChange(System::TObject* Sender, int NewTab, bool &AllowChange);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall AddChildMIClick(System::TObject* Sender);
	void __fastcall FindCmdExecute(System::TObject* Sender);
	void __fastcall ReplaceCmdExecute(System::TObject* Sender);
	void __fastcall FindNextCmdExecute(System::TObject* Sender);
	void __fastcall ReportDataCmdExecute(System::TObject* Sender);
	void __fastcall ReportStylesCmdExecute(System::TObject* Sender);
	void __fastcall ReportOptionsCmdExecute(System::TObject* Sender);
	void __fastcall ShowRulersCmdExecute(System::TObject* Sender);
	void __fastcall ShowGuidesCmdExecute(System::TObject* Sender);
	void __fastcall DeleteGuidesCmdExecute(System::TObject* Sender);
	void __fastcall OptionsCmdExecute(System::TObject* Sender);
	void __fastcall HelpContentsCmdExecute(System::TObject* Sender);
	void __fastcall AboutCmdExecute(System::TObject* Sender);
	void __fastcall StandardTBCmdExecute(System::TObject* Sender);
	void __fastcall TextTBCmdExecute(System::TObject* Sender);
	void __fastcall FrameTBCmdExecute(System::TObject* Sender);
	void __fastcall AlignTBCmdExecute(System::TObject* Sender);
	void __fastcall ExtraTBCmdExecute(System::TObject* Sender);
	void __fastcall InspectorTBCmdExecute(System::TObject* Sender);
	void __fastcall DataTreeTBCmdExecute(System::TObject* Sender);
	void __fastcall ReportTreeTBCmdExecute(System::TObject* Sender);
	void __fastcall ToolbarsCmdExecute(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormMouseWheel(System::TObject* Sender, System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall FontColorPopupMenuPopup(System::TObject* Sender);
	void __fastcall FillColorBClick(System::TObject* Sender);
	void __fastcall FillColorPopupMenuPopup(System::TObject* Sender);
	void __fastcall FrameColorBClick(System::TObject* Sender);
	void __fastcall FrameColorPopupMenuPopup(System::TObject* Sender);
	void __fastcall RevertInheritedMIClick(System::TObject* Sender);
	void __fastcall SelectAllOfTypeCmdExecute(System::TObject* Sender);
	void __fastcall EdConfigCmdExecute(System::TObject* Sender);
	void __fastcall CopyContentCmdExecute(System::TObject* Sender);
	
private:
	Vcl::Comctrls::TToolButton* ObjectSelectB;
	Vcl::Comctrls::TToolButton* HandToolB;
	Vcl::Comctrls::TToolButton* ZoomToolB;
	Vcl::Comctrls::TToolButton* TextToolB;
	Vcl::Comctrls::TToolButton* FormatToolB;
	Vcl::Comctrls::TToolButton* ObjectBandB;
	Frxdesgnctrls::TfrxClipboard* FClipboard;
	Frxsynmemo::TfrxSyntaxMemo* FCodeWindow;
	System::Uitypes::TColor FColor;
	System::Uitypes::TColor FFontColor;
	System::Uitypes::TColor FFillColor;
	System::Uitypes::TColor FFrameColor;
	System::UnicodeString FCoord1;
	System::UnicodeString FCoord2;
	System::UnicodeString FCoord3;
	Frxdialogform::TfrxDialogForm* FDialogForm;
	bool FEditAfterInsert;
	Frxdatatree::TfrxDataTreeForm* FDataTree;
	bool FDropFields;
	bool FGridAlign;
	System::Extended FGridSize1;
	System::Extended FGridSize2;
	System::Extended FGridSize3;
	System::Extended FGridSize4;
	Frxinsp::TfrxObjectInspector* FInspector;
	Frxclass::TfrxFrameStyle FLineStyle;
	bool FLocalizedOI;
	bool FLockSelectionChanged;
	System::TObject* FModifiedBy;
	bool FMouseDown;
	TfrxDesigner* FOldDesignerComp;
	TfrxDesignerUnits FOldUnits;
	System::Classes::TStrings* FPagePositions;
	Frxpicturecache::TfrxPictureCache* FPictureCache;
	System::Classes::TStringList* FRecentFiles;
	int FRecentMenuIndex;
	Frxreporttree::TfrxReportTreeForm* FReportTree;
	TSampleFormat* FSampleFormat;
	System::Extended FScale;
	bool FScriptFirstTime;
	bool FScriptRunning;
	bool FScriptStep;
	bool FScriptStopped;
	bool FSearchCase;
	int FSearchIndex;
	bool FSearchReplace;
	System::UnicodeString FSearchReplaceText;
	System::UnicodeString FSearchText;
	bool FShowGrid;
	bool FShowGuides;
	bool FShowRulers;
	bool FShowStartup;
	bool FStickToGuides;
	bool FGuidesAsAnchor;
	Vcl::Tabs::TTabSet* FTabs;
	System::Uitypes::TColor FToolsColor;
	Frxdesgnctrls::TfrxUndoBuffer* FUndoBuffer;
	TfrxDesignerUnits FUnits;
	bool FUnitsDblClicked;
	bool FUpdatingControls;
	Frxwatchform::TfrxWatchForm* FWatchList;
	Frxbreakpointsform::TfrxBreakPointsForm* FBreakPoints;
	Frxdesgnworkspace::TfrxDesignerWorkspace* FWorkspace;
	System::Uitypes::TColor FWorkspaceColor;
	System::Classes::TWndMethod FStatusBarOldWindowProc;
	System::UnicodeString FTemplatePath;
	System::UnicodeString FTemplateExt;
	System::Classes::TStringList* FFilterList;
	void __fastcall AttachDialogFormEvents(bool Attach);
	void __fastcall ChangeGlyphColor(int Index, System::Uitypes::TColor Color);
	void __fastcall CreateColorSelector(Vcl::Comctrls::TToolButton* Sender);
	void __fastcall CreateExtraToolbar();
	void __fastcall CreateToolWindows();
	void __fastcall CreateObjectsToolbar();
	void __fastcall CreateWorkspace();
	void __fastcall DialogFormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall DialogFormKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall DialogFormKeyUp(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall DialogFormModify(System::TObject* Sender);
	void __fastcall Done();
	void __fastcall DoTopmosts(bool Enable);
	void __fastcall FindOrReplace(bool replace);
	void __fastcall FindText();
	void __fastcall Init();
	void __fastcall NormalizeTopmosts();
	void __fastcall OnCodeChanged(System::TObject* Sender);
	void __fastcall OnCodeCompletion(const System::UnicodeString Name, Frxsynmemo::TfrxCompletionList* List);
	void __fastcall OnColorChanged(System::TObject* Sender);
	void __fastcall OnComponentMenuClick(System::TObject* Sender);
	void __fastcall OnChangePosition(System::TObject* Sender);
	void __fastcall OnDataTreeDblClick(System::TObject* Sender);
	void __fastcall OnDisableDock(System::TObject* Sender, Vcl::Controls::TDragDockObject* &DragObject);
	void __fastcall OnEditObject(System::TObject* Sender);
	void __fastcall OnEnableDock(System::TObject* Sender, System::TObject* Target, int X, int Y);
	void __fastcall OnExtraToolClick(System::TObject* Sender);
	void __fastcall OnInsertObject(System::TObject* Sender);
	void __fastcall OnModify(System::TObject* Sender);
	void __fastcall OnNotifyPosition(const Frxclass::TfrxRect &ARect);
	void __fastcall OnRunLine(Fs_iinterpreter::TfsScript* Sender, const System::UnicodeString UnitName, const System::UnicodeString SourcePos);
	void __fastcall OnSelectionChanged(System::TObject* Sender);
	void __fastcall OnStyleChanged(System::TObject* Sender);
	void __fastcall OpenRecentFile(System::TObject* Sender);
	void __fastcall OnSaveFilterExecute(System::TObject* Sender);
	void __fastcall OnEnterWorkSpace(System::TObject* Sender);
	void __fastcall ReadButtonImages();
	void __fastcall RestorePagePosition();
	void __fastcall RestoreTopmosts();
	void __fastcall SavePagePosition();
	void __fastcall SaveState();
	void __fastcall SetScale(System::Extended Value);
	void __fastcall SetGridAlign(const bool Value);
	void __fastcall SetShowGrid(const bool Value);
	void __fastcall SetShowRulers(const bool Value);
	void __fastcall SetToolsColor(const System::Uitypes::TColor Value);
	void __fastcall SetUnits(const TfrxDesignerUnits Value);
	void __fastcall SetWorkspaceColor(const System::Uitypes::TColor Value);
	void __fastcall SwitchToolbar();
	void __fastcall UpdateCaption();
	void __fastcall UpdateControls();
	void __fastcall UpdatePageDimensions();
	void __fastcall UpdateRecentFiles(System::UnicodeString NewFile);
	void __fastcall UpdateStyles();
	void __fastcall UpdateSyntaxType();
	void __fastcall UpdateWatches();
	System::Word __fastcall AskSave();
	int __fastcall GetPageIndex();
	System::UnicodeString __fastcall GetReportName();
	void __fastcall SetShowGuides(const bool Value);
	void __fastcall Localize();
	void __fastcall CreateLangMenu();
	MESSAGE void __fastcall CMStartup(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSysCommand(Winapi::Messages::TWMSysCommand &Message);
	MESSAGE void __fastcall WMEnable(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMActivateApp(Winapi::Messages::TWMActivateApp &Message);
	void __fastcall StatusBarWndProc(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogKey(Winapi::Messages::TWMKey &Message);
	void __fastcall SetGridSize1(const System::Extended Value);
	void __fastcall SetGridSize2(const System::Extended Value);
	void __fastcall SetGridSize3(const System::Extended Value);
	void __fastcall SetGridSize4(const System::Extended Value);
	void __fastcall SetStickToGuides(const bool Value);
	void __fastcall SetGuidesAsAnchor(const bool Value);
	
protected:
	void __fastcall UpdateWorkSpace(System::TObject* Sender);
	void __fastcall UpdateVirtualGuids(System::TObject* Sender, System::Extended Position);
	virtual void __fastcall SetModified(const bool Value);
	virtual void __fastcall SetPage(Frxclass::TfrxPage* const Value);
	virtual System::Classes::TStrings* __fastcall GetCode();
	void __fastcall ScrollBoxMouseWheel(System::TObject* Sender, System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, bool &Handled);
	
public:
	bool __fastcall CheckOp(TfrxDesignerRestriction Op);
	virtual System::UnicodeString __fastcall InsertExpression(const System::UnicodeString Expr);
	virtual bool __fastcall IsChangedExpression(const System::UnicodeString InExpr, /* out */ System::UnicodeString &OutExpr);
	virtual void __fastcall InternalCopy();
	virtual void __fastcall InternalPaste();
	virtual bool __fastcall InternalIsPasteAvailable();
	void __fastcall LoadFile(System::UnicodeString FileName, bool UseOnLoadEvent);
	void __fastcall LoadFilter(Frxclass::TfrxCustomIOTransport* aFilter, System::UnicodeString FileName, bool UseOnLoadEvent);
	virtual void __fastcall Lock();
	virtual void __fastcall ReloadPages(int Index);
	virtual void __fastcall ReloadReport();
	virtual void __fastcall ReloadObjects(bool ResetSelection = true);
	void __fastcall RestoreState(bool RestoreDefault = false, bool RestoreMainForm = false);
	bool __fastcall SaveFile(bool SaveAs, bool UseOnSaveEvent);
	bool __fastcall IOTransport(Frxclass::TfrxCustomIOTransport* aFilter, bool SaveAs, bool UseOnSaveEvent);
	void __fastcall SetReportDefaults();
	void __fastcall SwitchToCodeWindow();
	virtual void __fastcall UpdateDataTree();
	virtual void __fastcall UpdatePage();
	Frxclass::TfrxPoint __fastcall GetDefaultObjectSize();
	System::Extended __fastcall mmToUnits(System::Extended mm, bool X = true);
	System::Extended __fastcall UnitsTomm(System::Extended mm, bool X = true);
	void __fastcall GetTemplateList(System::Classes::TStrings* List);
	virtual void __fastcall UpdateInspector();
	virtual void __fastcall DisableInspectorUpdate();
	virtual void __fastcall EnableInspectorUpdate();
	__property Frxsynmemo::TfrxSyntaxMemo* CodeWindow = {read=FCodeWindow};
	__property Frxdatatree::TfrxDataTreeForm* DataTree = {read=FDataTree};
	__property bool DropFields = {read=FDropFields, write=FDropFields, nodefault};
	__property bool EditAfterInsert = {read=FEditAfterInsert, write=FEditAfterInsert, nodefault};
	__property bool GridAlign = {read=FGridAlign, write=SetGridAlign, nodefault};
	__property System::Extended GridSize1 = {read=FGridSize1, write=SetGridSize1};
	__property System::Extended GridSize2 = {read=FGridSize2, write=SetGridSize2};
	__property System::Extended GridSize3 = {read=FGridSize3, write=SetGridSize3};
	__property System::Extended GridSize4 = {read=FGridSize4, write=SetGridSize4};
	__property Frxinsp::TfrxObjectInspector* Inspector = {read=FInspector};
	__property Frxpicturecache::TfrxPictureCache* PictureCache = {read=FPictureCache};
	__property System::Classes::TStringList* RecentFiles = {read=FRecentFiles};
	__property Frxreporttree::TfrxReportTreeForm* ReportTree = {read=FReportTree};
	__property TSampleFormat* SampleFormat = {read=FSampleFormat};
	__property System::Extended Scale = {read=FScale, write=SetScale};
	__property bool ShowGrid = {read=FShowGrid, write=SetShowGrid, nodefault};
	__property bool ShowGuides = {read=FShowGuides, write=SetShowGuides, nodefault};
	__property bool ShowRulers = {read=FShowRulers, write=SetShowRulers, nodefault};
	__property bool ShowStartup = {read=FShowStartup, write=FShowStartup, nodefault};
	__property System::Uitypes::TColor ToolsColor = {read=FToolsColor, write=SetToolsColor, nodefault};
	__property TfrxDesignerUnits Units = {read=FUnits, write=SetUnits, nodefault};
	__property Frxdesgnworkspace::TfrxDesignerWorkspace* Workspace = {read=FWorkspace};
	__property System::Uitypes::TColor WorkspaceColor = {read=FWorkspaceColor, write=SetWorkspaceColor, nodefault};
	__property System::UnicodeString TemplatePath = {read=FTemplatePath, write=FTemplatePath};
	__property bool StickToGuides = {read=FStickToGuides, write=SetStickToGuides, nodefault};
	__property bool GuidesAsAnchor = {read=FGuidesAsAnchor, write=SetGuidesAsAnchor, nodefault};
public:
	/* TfrxCustomDesigner.CreateDesigner */ inline __fastcall TfrxDesignerForm(System::Classes::TComponent* AOwner, Frxclass::TfrxReport* AReport, bool APreviewDesigner) : Frxclass::TfrxCustomDesigner(AOwner, AReport, APreviewDesigner) { }
	/* TfrxCustomDesigner.Destroy */ inline __fastcall virtual ~TfrxDesignerForm() { }
	
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxDesignerForm(System::Classes::TComponent* AOwner) : Frxclass::TfrxCustomDesigner(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxDesignerForm(System::Classes::TComponent* AOwner, int Dummy) : Frxclass::TfrxCustomDesigner(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxDesignerForm(HWND ParentWindow) : Frxclass::TfrxCustomDesigner(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TSampleFormat : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Frxclass::TfrxCustomMemoView* FMemo;
	void __fastcall Clear();
	
public:
	__fastcall TSampleFormat();
	__fastcall virtual ~TSampleFormat();
	void __fastcall ApplySample(Frxclass::TfrxCustomMemoView* Memo);
	void __fastcall SetAsSample(Frxclass::TfrxCustomMemoView* Memo);
	__property Frxclass::TfrxCustomMemoView* Memo = {read=FMemo};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCustomSavePlugin : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString FileFilter;
	virtual void __fastcall Save(Frxclass::TfrxReport* Report, const System::UnicodeString FileName) = 0 ;
public:
	/* TObject.Create */ inline __fastcall TfrxCustomSavePlugin() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxCustomSavePlugin() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxDesigner* frxDesignerComp;
}	/* namespace Frxdesgn */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDESGN)
using namespace Frxdesgn;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdesgnHPP
