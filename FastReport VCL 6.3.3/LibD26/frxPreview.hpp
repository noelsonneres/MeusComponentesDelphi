// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPreview.pas' rev: 33.00 (Windows)

#ifndef FrxpreviewHPP
#define FrxpreviewHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ImgList.hpp>
#include <frxCtrls.hpp>
#include <frxDock.hpp>
#include <Vcl.ToolWin.hpp>
#include <frxPreviewPages.hpp>
#include <frxClass.hpp>
#include <System.Actions.hpp>
#include <System.Variants.hpp>
#include <Vcl.ActnList.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxpreview
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPreviewTabItem;
class DELPHICLASS TfrxPreviewTabs;
class DELPHICLASS TfrxPreview;
class DELPHICLASS TfrxPreviewForm;
class DELPHICLASS TfrxPreviewWorkspace;
class DELPHICLASS TfrxPageItem;
class DELPHICLASS TfrxPageList;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxPreviewTool : unsigned char { ptHand, ptZoom };

typedef void __fastcall (__closure *TfrxPageChangedEvent)(TfrxPreview* Sender, int PageNo);

class PASCALIMPLEMENTATION TfrxPreviewTabItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	System::UnicodeString Name;
	int Top;
	int Left;
	int PageNo;
	int ThumbTop;
	Frxclass::TfrxReport* Report;
	Frxclass::TfrxCustomPreviewPages* PreviewPages;
	System::UnicodeString DetailPage;
	System::Extended Zoom;
	Frxclass::TfrxZoomMode ZoomMode;
	int OutlineItem;
	bool FreeObjects;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxPreviewTabItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxPreviewTabItem() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPreviewTabs : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxPreviewTabItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxPreviewWorkspace* FThumbnail;
	TfrxPreviewWorkspace* FWorkspace;
	TfrxPreview* FPreview;
	int FCurTab;
	TfrxPreviewTabItem* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxPreviewTabs(TfrxPreview* APreview);
	__property TfrxPreviewTabItem* Items[int Index] = {read=GetItems/*, default*/};
	void __fastcall AddTab(Frxclass::TfrxReport* AReport, System::UnicodeString aDetailPage, const System::UnicodeString TabName, bool AFreeObjects);
	void __fastcall DeleteTab(int Index);
	void __fastcall SetCurrentTab(int Index);
	void __fastcall ClearItems();
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxPreviewTabs() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxPreview : public Frxclass::TfrxCustomPreview
{
	typedef Frxclass::TfrxCustomPreview inherited;
	
private:
	bool FAllowF3;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	Vcl::Stdctrls::TButton* FCancelButton;
	bool FLocked;
	Vcl::Stdctrls::TLabel* FMessageLabel;
	Vcl::Extctrls::TPanel* FMessagePanel;
	TfrxPageChangedEvent FOnPageChanged;
	Vcl::Comctrls::TTreeView* FOutline;
	System::Uitypes::TColor FOutlineColor;
	Vcl::Menus::TPopupMenu* FOutlinePopup;
	int FPageNo;
	int FSavedPageNo;
	bool FRefreshing;
	bool FRunning;
	System::Uitypes::TScrollStyle FScrollBars;
	Vcl::Extctrls::TSplitter* FSplitter;
	TfrxPreviewWorkspace* FThumbnail;
	unsigned FTick;
	TfrxPreviewTool FTool;
	TfrxPreviewWorkspace* FWorkspace;
	System::Extended FZoom;
	Frxclass::TfrxZoomMode FZoomMode;
	Vcl::Comctrls::TTabControl* FTabs;
	bool FInitialized;
	bool FCalledFromPreview;
	TfrxPreviewTabs* FTabItems;
	Vcl::Controls::TImageList* FTabImgList;
	bool FEachReportInTab;
	System::Uitypes::TColor __fastcall GetActiveFrameColor();
	System::Uitypes::TColor __fastcall GetBackColor();
	System::Uitypes::TColor __fastcall GetFrameColor();
	bool __fastcall GetOutlineVisible();
	int __fastcall GetOutlineWidth();
	int __fastcall GetPageCount();
	bool __fastcall GetThumbnailVisible();
	Vcl::Controls::TMouseEvent __fastcall GetOnMouseDown();
	void __fastcall AddCloseBtnToImageList();
	void __fastcall EditTemplate();
	void __fastcall OnCancel(System::TObject* Sender);
	void __fastcall OnCollapseClick(System::TObject* Sender);
	void __fastcall OnExpandClick(System::TObject* Sender);
	void __fastcall OnMoveSplitter(System::TObject* Sender);
	void __fastcall OnOutlineClick(System::TObject* Sender);
	void __fastcall OnChangeTab(System::TObject* Sender);
	void __fastcall OnTabMouseUP(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall SetActiveFrameColor(const System::Uitypes::TColor Value);
	void __fastcall SetBackColor(const System::Uitypes::TColor Value);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall SetFrameColor(const System::Uitypes::TColor Value);
	void __fastcall SetOutlineColor(const System::Uitypes::TColor Value);
	void __fastcall SetOutlineWidth(const int Value);
	void __fastcall SetOutlineVisible(const bool Value);
	void __fastcall SetPageNo(int Value);
	void __fastcall SetActivePage(int Value);
	void __fastcall SetThumbnailVisible(const bool Value);
	void __fastcall SetZoom(const System::Extended Value);
	void __fastcall SetZoomMode(const Frxclass::TfrxZoomMode Value);
	void __fastcall SetOnMouseDown(const Vcl::Controls::TMouseEvent Value);
	void __fastcall UpdateOutline();
	void __fastcall UpdatePages();
	void __fastcall UpdatePageNumbers();
	MESSAGE void __fastcall WMEraseBackground(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Message);
	void __fastcall SetHighlightEditable(const bool Value);
	bool __fastcall GetHighlightEditable();
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	DYNAMIC void __fastcall Resize();
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall DoFinishInPlace(System::TObject* Sender, bool Refresh, bool Modified);
	
public:
	__fastcall virtual TfrxPreview(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxPreview();
	void __fastcall ClearAllTabs();
	virtual bool __fastcall Init(Frxclass::TfrxReport* aReport, Frxclass::TfrxCustomPreviewPages* aPrevPages);
	virtual void __fastcall UnInit(Frxclass::TfrxCustomPreviewPages* aPreviewPages);
	virtual void __fastcall Lock();
	virtual void __fastcall Unlock();
	virtual void __fastcall RefreshReport();
	virtual void __fastcall InternalOnProgressStart(Frxclass::TfrxReport* Sender, Frxclass::TfrxProgressType ProgressType, int Progress);
	virtual void __fastcall InternalOnProgress(Frxclass::TfrxReport* Sender, Frxclass::TfrxProgressType ProgressType, int Progress);
	virtual void __fastcall InternalOnProgressStop(Frxclass::TfrxReport* Sender, Frxclass::TfrxProgressType ProgressType, int Progress);
	void __fastcall AddPage();
	void __fastcall DeletePage();
	void __fastcall Print();
	void __fastcall Edit();
	void __fastcall First();
	void __fastcall Next();
	void __fastcall Prior();
	void __fastcall Last();
	void __fastcall PageSetupDlg();
	void __fastcall PageSetupDialog();
	void __fastcall Find();
	void __fastcall FindNext();
	void __fastcall Cancel();
	void __fastcall Clear();
	void __fastcall SetPosition(int PageN, int Top);
	void __fastcall ShowMessage(const System::UnicodeString s);
	void __fastcall HideMessage();
	void __fastcall MouseWheelScroll(int Delta, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool Horz = false);
	int __fastcall GetTopPosition();
	void __fastcall LoadFromFile()/* overload */;
	void __fastcall LoadFromFile(System::UnicodeString FileName)/* overload */;
	void __fastcall SaveToFile()/* overload */;
	void __fastcall SaveToFile(System::UnicodeString FileName)/* overload */;
	void __fastcall Export(Frxclass::TfrxCustomExportFilter* Filter);
	bool __fastcall FindText(System::UnicodeString SearchString, bool FromTop, bool IsCaseSensitive);
	bool __fastcall FindTextFound();
	void __fastcall FindTextClear();
	void __fastcall AddPreviewTab(Frxclass::TfrxReport* AReport, const System::UnicodeString TabName, const System::UnicodeString TabCaption = System::UnicodeString(), bool FreeObjects = true, System::UnicodeString aDetailPage = System::UnicodeString());
	void __fastcall AddPreviewTabOrSwitch(Frxclass::TfrxReport* AReport, const System::UnicodeString TabName, const System::UnicodeString TabCaption = System::UnicodeString(), bool FreeObjects = true, System::UnicodeString aDetailPage = System::UnicodeString());
	void __fastcall RemoveTab(int TabIndex);
	bool __fastcall HasTab(const System::UnicodeString TabName)/* overload */;
	bool __fastcall HasTab(Frxclass::TfrxReport* const aReport)/* overload */;
	bool __fastcall HasVisibleTabs();
	void __fastcall SwitchToTab(const System::UnicodeString TabName)/* overload */;
	void __fastcall SwitchToTab(Frxclass::TfrxReport* const aReport)/* overload */;
	__property int PageCount = {read=GetPageCount, nodefault};
	__property int PageNo = {read=FPageNo, write=SetPageNo, nodefault};
	__property TfrxPreviewTool Tool = {read=FTool, write=FTool, nodefault};
	__property System::Extended Zoom = {read=FZoom, write=SetZoom};
	__property Frxclass::TfrxZoomMode ZoomMode = {read=FZoomMode, write=SetZoomMode, nodefault};
	__property bool Locked = {read=FLocked, nodefault};
	__property Vcl::Comctrls::TTreeView* OutlineTree = {read=FOutline};
	__property Vcl::Extctrls::TSplitter* Splitter = {read=FSplitter};
	__property TfrxPreviewWorkspace* Thumbnail = {read=FThumbnail};
	__property TfrxPreviewWorkspace* Workspace = {read=FWorkspace};
	__property bool HighlightEditable = {read=GetHighlightEditable, write=SetHighlightEditable, nodefault};
	
__published:
	__property Align = {default=0};
	__property System::Uitypes::TColor ActiveFrameColor = {read=GetActiveFrameColor, write=SetActiveFrameColor, default=3983359};
	__property System::Uitypes::TColor BackColor = {read=GetBackColor, write=SetBackColor, default=8421504};
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property BorderWidth = {default=0};
	__property Constraints;
	__property bool EachReportInTab = {read=FEachReportInTab, write=FEachReportInTab, default=0};
	__property Enabled = {default=1};
	__property System::Uitypes::TColor FrameColor = {read=GetFrameColor, write=SetFrameColor, default=6316128};
	__property System::Uitypes::TColor OutlineColor = {read=FOutlineColor, write=SetOutlineColor, default=-16777211};
	__property bool OutlineVisible = {read=GetOutlineVisible, write=SetOutlineVisible, nodefault};
	__property int OutlineWidth = {read=GetOutlineWidth, write=SetOutlineWidth, nodefault};
	__property PopupMenu;
	__property bool ThumbnailVisible = {read=GetThumbnailVisible, write=SetThumbnailVisible, nodefault};
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property TfrxPageChangedEvent OnPageChanged = {read=FOnPageChanged, write=FOnPageChanged};
	__property Vcl::Controls::TMouseEvent OnMouseDown = {read=GetOnMouseDown, write=SetOnMouseDown};
	__property Anchors = {default=3};
	__property UseReportHints;
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxPreview(HWND ParentWindow) : Frxclass::TfrxCustomPreview(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxPreviewForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TToolBar* ToolBar;
	Vcl::Comctrls::TToolButton* OpenB;
	Vcl::Comctrls::TToolButton* SaveB;
	Vcl::Comctrls::TToolButton* PrintB;
	Vcl::Comctrls::TToolButton* FindB;
	Vcl::Comctrls::TToolButton* PageSettingsB;
	Frxdock::TfrxTBPanel* Sep3;
	Frxctrls::TfrxComboBox* ZoomCB;
	Vcl::Comctrls::TToolButton* Sep1;
	Vcl::Comctrls::TToolButton* Sep2;
	Vcl::Comctrls::TToolButton* FirstB;
	Vcl::Comctrls::TToolButton* PriorB;
	Frxdock::TfrxTBPanel* Sep4;
	Vcl::Stdctrls::TEdit* PageE;
	Vcl::Comctrls::TToolButton* NextB;
	Vcl::Comctrls::TToolButton* LastB;
	Vcl::Comctrls::TStatusBar* StatusBar;
	Vcl::Comctrls::TToolButton* ZoomMinusB;
	Vcl::Comctrls::TToolButton* Sep5;
	Vcl::Comctrls::TToolButton* ZoomPlusB;
	Vcl::Comctrls::TToolButton* DesignerB;
	Frxdock::TfrxTBPanel* frTBPanel1;
	Vcl::Buttons::TSpeedButton* CancelB;
	Vcl::Menus::TPopupMenu* ExportPopup;
	Vcl::Menus::TPopupMenu* HiddenMenu;
	Vcl::Menus::TMenuItem* Showtemplate1;
	Vcl::Menus::TPopupMenu* RightMenu;
	Vcl::Comctrls::TToolButton* FullScreenBtn;
	Vcl::Comctrls::TToolButton* EmailB;
	Vcl::Comctrls::TToolButton* PdfB;
	Vcl::Comctrls::TToolButton* OutlineB;
	Vcl::Comctrls::TToolButton* ThumbB;
	Vcl::Menus::TMenuItem* N1;
	Vcl::Menus::TMenuItem* ExpandMI;
	Vcl::Menus::TMenuItem* CollapseMI;
	Vcl::Stdctrls::TLabel* OfNL;
	Vcl::Comctrls::TToolButton* HighlightEditableTB;
	Vcl::Actnlist::TActionList* PreviewActionList;
	Vcl::Actnlist::TAction* CopyCmd;
	Vcl::Actnlist::TAction* PasteCmd;
	Vcl::Menus::TMenuItem* CopyCmd1;
	Vcl::Menus::TMenuItem* PasteCmd1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall ZoomMinusBClick(System::TObject* Sender);
	void __fastcall ZoomCBClick(System::TObject* Sender);
	void __fastcall FormKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall FirstBClick(System::TObject* Sender);
	void __fastcall PriorBClick(System::TObject* Sender);
	void __fastcall NextBClick(System::TObject* Sender);
	void __fastcall LastBClick(System::TObject* Sender);
	void __fastcall PageEClick(System::TObject* Sender);
	void __fastcall PrintBClick(System::TObject* Sender);
	void __fastcall OpenBClick(System::TObject* Sender);
	void __fastcall SaveBClick(System::TObject* Sender);
	void __fastcall FindBClick(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall DesignerBClick(System::TObject* Sender);
	void __fastcall NewPageBClick(System::TObject* Sender);
	void __fastcall DelPageBClick(System::TObject* Sender);
	void __fastcall CancelBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PageSettingsBClick(System::TObject* Sender);
	void __fastcall FormMouseWheel(System::TObject* Sender, System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall DesignerBMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall Showtemplate1Click(System::TObject* Sender);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall FullScreenBtnClick(System::TObject* Sender);
	void __fastcall PdfBClick(System::TObject* Sender);
	void __fastcall EmailBClick(System::TObject* Sender);
	void __fastcall ZoomPlusBClick(System::TObject* Sender);
	void __fastcall OutlineBClick(System::TObject* Sender);
	void __fastcall ThumbBClick(System::TObject* Sender);
	void __fastcall CollapseAllClick(System::TObject* Sender);
	void __fastcall ExpandAllClick(System::TObject* Sender);
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall HighlightEditableTBClick(System::TObject* Sender);
	void __fastcall CopyCmdExecute(System::TObject* Sender);
	void __fastcall PasteCmdExecute(System::TObject* Sender);
	void __fastcall RightMenuPopup(System::TObject* Sender);
	
private:
	System::Classes::TStringList* FFilterList;
	bool FFreeOnClose;
	bool FIsClosing;
	TfrxPreview* FPreview;
	Vcl::Forms::TFormBorderStyle FOldBS;
	System::Uitypes::TWindowState FOldState;
	bool FFullScreen;
	Frxclass::TfrxCustomExportFilter* FPDFExport;
	Frxclass::TfrxCustomExportFilter* FEmailExport;
	System::Classes::TWndMethod FStatusBarOldWindowProc;
	void __fastcall ExportMIClick(System::TObject* Sender);
	void __fastcall OnPageChanged(TfrxPreview* Sender, int PageNo);
	void __fastcall OnPreviewDblClick(System::TObject* Sender);
	void __fastcall UpdateControls();
	void __fastcall UpdateZoom();
	MESSAGE void __fastcall WMUpdateZoom(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMActivateApp(Winapi::Messages::TWMActivateApp &Msg);
	HIDESBASE MESSAGE void __fastcall WMSysCommand(Winapi::Messages::TWMSysCommand &Msg);
	void __fastcall StatusBarWndProc(Winapi::Messages::TMessage &Message);
	Frxclass::TfrxReport* __fastcall GetReport();
	void __fastcall OnSaveFilterExecute(System::TObject* Sender);
	
public:
	void __fastcall Init();
	void __fastcall SetMessageText(const System::UnicodeString Value, bool IsHint = false);
	void __fastcall SwitchToFullScreen();
	__property bool IsClosing = {read=FIsClosing, write=FIsClosing, nodefault};
	__property bool FreeOnClose = {read=FFreeOnClose, write=FFreeOnClose, nodefault};
	__property TfrxPreview* Preview = {read=FPreview};
	__property Frxclass::TfrxReport* Report = {read=GetReport};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxPreviewForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxPreviewForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxPreviewForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxPreviewForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxPreviewWorkspace : public Frxctrls::TfrxScrollWin
{
	typedef Frxctrls::TfrxScrollWin inherited;
	
private:
	System::Uitypes::TColor FActiveFrameColor;
	System::Uitypes::TColor FBackColor;
	System::Uitypes::TCursor FDefaultCursor;
	bool FDisableUpdate;
	bool FDown;
	Vcl::Graphics::TMetafile* FEMFImage;
	int FEMFImagePage;
	System::Uitypes::TColor FFrameColor;
	bool FIsThumbnail;
	int FLastFoundPage;
	System::Types::TPoint FLastPoint;
	bool FLocked;
	System::Types::TPoint FOffset;
	unsigned FTimeOffset;
	TfrxPageList* FPageList;
	int FPageNo;
	TfrxPreview* FPreview;
	Frxclass::TfrxCustomPreviewPages* FPreviewPages;
	System::Extended FZoom;
	bool FRTLLanguage;
	bool FHighlightEditable;
	System::Types::TRect FSelectRect;
	Vcl::Graphics::TBitmap* FCachedView;
	void __fastcall DrawPages(bool BorderOnly);
	void __fastcall FindText();
	void __fastcall SetToPageNo(int PageNo);
	void __fastcall UpdateScrollBars();
	void __fastcall SetLocked(const bool Value);
	
protected:
	void __fastcall PrevDblClick(System::TObject* Sender);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	virtual void __fastcall OnHScrollChange(System::TObject* Sender);
	DYNAMIC void __fastcall Resize();
	virtual void __fastcall OnVScrollChange(System::TObject* Sender);
	void __fastcall CallIteractiveEvent(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y, Frxclass::TfrxPreviewIntEventParams &aEvent);
	void __fastcall SetEditMode(Frxclass::TfrxPreviewIntEventParams &aEvent);
	Frxclass::TfrxRect __fastcall ScaleRect(const System::Types::TRect &aRect, System::Extended Scale, System::Extended aOffsetX, System::Extended aOffsetY);
	
public:
	__fastcall virtual TfrxPreviewWorkspace(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxPreviewWorkspace();
	virtual void __fastcall Paint();
	HIDESBASE void __fastcall SetPosition(int PageN, int Top);
	int __fastcall GetTopPosition();
	void __fastcall AddPage(int AWidth, int AHeight);
	void __fastcall ClearPageList();
	void __fastcall CalcPageBounds(int ClientWidth);
	__property System::Uitypes::TColor ActiveFrameColor = {read=FActiveFrameColor, write=FActiveFrameColor, default=8405024};
	__property System::Uitypes::TColor BackColor = {read=FBackColor, write=FBackColor, default=8421504};
	__property System::Uitypes::TColor FrameColor = {read=FFrameColor, write=FFrameColor, default=0};
	__property bool IsThumbnail = {read=FIsThumbnail, write=FIsThumbnail, nodefault};
	__property bool Locked = {read=FLocked, write=SetLocked, nodefault};
	__property int PageNo = {read=FPageNo, write=FPageNo, nodefault};
	__property TfrxPreview* Preview = {read=FPreview, write=FPreview};
	__property Frxclass::TfrxCustomPreviewPages* PreviewPages = {read=FPreviewPages, write=FPreviewPages};
	__property System::Extended Zoom = {read=FZoom, write=FZoom};
	__property bool RTLLanguage = {read=FRTLLanguage, write=FRTLLanguage, nodefault};
	__property bool HighlightEditable = {read=FHighlightEditable, write=FHighlightEditable, nodefault};
	__property OnDblClick;
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxPreviewWorkspace(HWND ParentWindow) : Frxctrls::TfrxScrollWin(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPageItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	int Height;
	int Width;
	int OffsetX;
	int OffsetY;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxPageItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxPageItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPageList : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxPageItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	int FMaxWidth;
	TfrxPageItem* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxPageList();
	__property TfrxPageItem* Items[int Index] = {read=GetItems/*, default*/};
	void __fastcall AddPage(int AWidth, int AHeight, System::Extended Zoom);
	void __fastcall CalcBounds(int ClientWidth);
	int __fastcall FindPage(int OffsetY, int OffsetX = 0x0);
	System::Types::TRect __fastcall GetPageBounds(int Index, int ClientWidth, System::Extended Scale, bool RTL);
	System::Types::TPoint __fastcall GetMaxBounds();
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxPageList() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word WM_UPDATEZOOM = System::Word(0x401);
}	/* namespace Frxpreview */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPREVIEW)
using namespace Frxpreview;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxpreviewHPP
