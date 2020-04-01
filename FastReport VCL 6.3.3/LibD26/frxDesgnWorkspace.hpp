// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDesgnWorkspace.pas' rev: 33.00 (Windows)

#ifndef FrxdesgnworkspaceHPP
#define FrxdesgnworkspaceHPP

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
#include <frxClass.hpp>
#include <frxUnicodeCtrls.hpp>
#include <System.Variants.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdesgnworkspace
{
//-- forward type declarations -----------------------------------------------
struct TfrxInsertion;
class DELPHICLASS TfrxDesignerWorkspace;
class DELPHICLASS TInplaceMemo;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxDesignMode : unsigned char { dmSelect, dmInsert, dmDrag };

enum DECLSPEC_DENUM TfrxDesignMode1 : unsigned char { dmNone, dmMove, dmSize, dmSizeBand, dmScale, dmInplaceEdit, dmSelectionRect, dmInsertObject, dmInsertLine, dmMoveGuide, dmContainer };

enum DECLSPEC_DENUM TfrxCursorType : unsigned char { ct0, ct1, ct2, ct3, ct4, ct5, ct6, ct7, ct8, ct9, ct10 };

typedef void __fastcall (__closure *TfrxNotifyPositionEvent)(const Frxclass::TfrxRect &ARect);

#pragma pack(push,1)
struct DECLSPEC_DRECORD TfrxInsertion
{
public:
	Frxclass::TfrxComponentClass ComponentClass;
	System::Extended Left;
	System::Extended Top;
	System::Extended Width;
	System::Extended Height;
	System::Extended OriginalWidth;
	System::Extended OriginalHeight;
	System::Word Flags;
};
#pragma pack(pop)


class PASCALIMPLEMENTATION TfrxDesignerWorkspace : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
protected:
	System::Extended FBandHeader;
	Vcl::Graphics::TCanvas* FCanvas;
	System::Uitypes::TColor FColor;
	TfrxCursorType FCT;
	bool FDblClicked;
	bool FDisableUpdate;
	bool FFreeBandsPlacement;
	int FGapBetweenBands;
	bool FGridAlign;
	bool FGridLCD;
	Frxclass::TfrxGridType FGridType;
	System::Extended FGridX;
	System::Extended FGridY;
	TfrxInsertion FInsertion;
	System::Extended FLastMousePointX;
	System::Extended FLastMousePointY;
	System::Types::TRect FMargins;
	Vcl::Extctrls::TPanel* FMarginsPanel;
	TfrxDesignMode FMode;
	TfrxDesignMode1 FMode1;
	bool FModifyFlag;
	bool FMouseDown;
	System::Classes::TList* FObjects;
	System::Extended FOffsetX;
	System::Extended FOffsetY;
	Frxclass::TfrxPage* FPage;
	int FPageHeight;
	int FPageWidth;
	System::Extended FScale;
	Frxclass::TfrxRect FScaleRect;
	Frxclass::TfrxRect FScaleRect1;
	Frxclass::TfrxSelectedObjectsList* FSelectedObjects;
	System::Classes::TList* FInternalSelObjects;
	System::Classes::TList* FSavedAlign;
	Frxclass::TfrxRect FSelectionRect;
	bool FShowBandCaptions;
	bool FShowEdges;
	bool FShowGrid;
	Frxclass::TfrxBand* FSizedBand;
	System::Classes::TNotifyEvent FOnModify;
	System::Classes::TNotifyEvent FOnEdit;
	System::Classes::TNotifyEvent FOnInsert;
	System::Classes::TNotifyEvent FOnMouseEnter;
	TfrxNotifyPositionEvent FOnNotifyPosition;
	System::Classes::TNotifyEvent FOnSelectionChanged;
	System::Classes::TNotifyEvent FOnTopLeftChanged;
	Frxclass::TfrxComponentEditorsList* FInPlaceditorsList;
	Frxclass::TfrxComponent* FLastObjectOver;
	bool FPopUpActive;
	void __fastcall DoModify();
	void __fastcall AdjustBandHeight(Frxclass::TfrxBand* Bnd);
	virtual void __fastcall CheckGuides(System::Extended &kx, System::Extended &ky, bool &Result, bool IsMouseDown);
	void __fastcall DoNudge(System::Extended dx, System::Extended dy, bool Smooth);
	void __fastcall DoSize(System::Extended dx, System::Extended dy);
	void __fastcall DoStick(int dx, int dy);
	void __fastcall DoTab();
	void __fastcall DrawBackground();
	void __fastcall DrawCross(bool Down);
	void __fastcall DrawInsertionRect();
	virtual void __fastcall DrawObjects();
	void __fastcall DrawSelectionRect();
	void __fastcall FindNearest(int dx, int dy);
	virtual void __fastcall MouseLeave();
	void __fastcall NormalizeCoord(Frxclass::TfrxComponent* c);
	void __fastcall NormalizeRect(Frxclass::TfrxRect &R);
	void __fastcall SelectionChanged(System::Classes::TList* aNewSelection = (System::Classes::TList*)(0x0));
	void __fastcall UpdateInternalSelection();
	void __fastcall SetScale(System::Extended Value);
	void __fastcall SetShowBandCaptions(const bool Value);
	void __fastcall UpdateBandHeader();
	virtual void __fastcall DoFinishInPlace(System::TObject* Sender, bool Refresh, bool Modified);
	virtual void __fastcall SetDefaultEventParams(Frxclass::TfrxInteractiveEventsParams &EventParams);
	DYNAMIC void __fastcall DblClick();
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMMove(Winapi::Messages::TWMMove &Message);
	MESSAGE void __fastcall WMEraseBackground(Winapi::Messages::TMessage &Message);
	void __fastcall SetColor_(const System::Uitypes::TColor Value);
	void __fastcall SetGridType(const Frxclass::TfrxGridType Value);
	void __fastcall SetOrigin(const System::Types::TPoint &Value);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	void __fastcall SetShowGrid(const bool Value);
	System::Types::TPoint __fastcall GetOrigin();
	Frxclass::TfrxComponent* __fastcall GetRightBottomObject();
	Frxclass::TfrxRect __fastcall GetSelectionBounds();
	bool __fastcall ListsEqual(System::Classes::TList* List1, System::Classes::TList* List2);
	int __fastcall SelectedCount();
	
public:
	__fastcall virtual TfrxDesignerWorkspace(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDesignerWorkspace();
	virtual void __fastcall Paint();
	void __fastcall AdjustBands(bool AttachObjects = true);
	virtual void __fastcall DeleteObjects();
	virtual void __fastcall RemoveObjectsFromLits(System::Classes::TList* aObjectsList);
	void __fastcall DisableUpdate();
	void __fastcall EnableUpdate();
	virtual void __fastcall EditObject();
	void __fastcall GroupObjects();
	void __fastcall UngroupObjects();
	virtual void __fastcall SetInsertion(Frxclass::TfrxComponentClass AClass, System::Extended AWidth, System::Extended AHeight, System::Word AFlag);
	void __fastcall SetPageDimensions(int AWidth, int AHeight, const System::Types::TRect &AMargins);
	void __fastcall UpdateView();
	virtual void __fastcall ClearLastView();
	void __fastcall CreateInPlaceEditorsList();
	virtual void __fastcall InternalCopy();
	virtual void __fastcall InternalPaste();
	void __fastcall SetClipboardObject(System::Classes::TPersistent* Clipboard);
	virtual void __fastcall SetVirtualGuids(System::Extended VGuid, System::Extended HGuid);
	virtual bool __fastcall InternalIsPasteAvailable();
	__property System::Extended BandHeader = {read=FBandHeader, write=FBandHeader};
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor_, nodefault};
	__property bool FreeBandsPlacement = {read=FFreeBandsPlacement, write=FFreeBandsPlacement, nodefault};
	__property int GapBetweenBands = {read=FGapBetweenBands, write=FGapBetweenBands, nodefault};
	__property bool GridAlign = {read=FGridAlign, write=FGridAlign, nodefault};
	__property bool GridLCD = {read=FGridLCD, write=FGridLCD, nodefault};
	__property Frxclass::TfrxGridType GridType = {read=FGridType, write=SetGridType, nodefault};
	__property System::Extended GridX = {read=FGridX, write=FGridX};
	__property System::Extended GridY = {read=FGridY, write=FGridY};
	__property TfrxInsertion Insertion = {read=FInsertion};
	__property bool IsMouseDown = {read=FMouseDown, nodefault};
	__property TfrxDesignMode1 Mode = {read=FMode1, nodefault};
	__property System::Classes::TList* Objects = {read=FObjects, write=FObjects};
	__property System::Extended OffsetX = {read=FOffsetX, write=FOffsetX};
	__property System::Extended OffsetY = {read=FOffsetY, write=FOffsetY};
	__property System::Types::TPoint Origin = {read=GetOrigin, write=SetOrigin};
	__property Frxclass::TfrxPage* Page = {read=FPage, write=FPage};
	__property System::Extended Scale = {read=FScale, write=SetScale};
	__property Frxclass::TfrxSelectedObjectsList* SelectedObjects = {read=FSelectedObjects, write=FSelectedObjects};
	__property bool ShowBandCaptions = {read=FShowBandCaptions, write=SetShowBandCaptions, nodefault};
	__property bool ShowEdges = {read=FShowEdges, write=FShowEdges, nodefault};
	__property bool ShowGrid = {read=FShowGrid, write=SetShowGrid, nodefault};
	__property System::Classes::TNotifyEvent OnModify = {read=FOnModify, write=FOnModify};
	__property System::Classes::TNotifyEvent OnEdit = {read=FOnEdit, write=FOnEdit};
	__property System::Classes::TNotifyEvent OnInsert = {read=FOnInsert, write=FOnInsert};
	__property System::Classes::TNotifyEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property TfrxNotifyPositionEvent OnNotifyPosition = {read=FOnNotifyPosition, write=FOnNotifyPosition};
	__property System::Classes::TNotifyEvent OnSelectionChanged = {read=FOnSelectionChanged, write=FOnSelectionChanged};
	__property System::Classes::TNotifyEvent OnTopLeftChanged = {read=FOnTopLeftChanged, write=FOnTopLeftChanged};
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxDesignerWorkspace(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TInplaceMemo : public Frxunicodectrls::TUnicodeMemo
{
	typedef Frxunicodectrls::TUnicodeMemo inherited;
	
private:
	TfrxDesignerWorkspace* FDesigner;
	Frxclass::TfrxCustomMemoView* FObject;
	System::Types::TSize FOriginalSize;
	void __fastcall LinesChange(System::TObject* Sender);
	
public:
	__fastcall virtual TInplaceMemo(System::Classes::TComponent* AOwner);
	void __fastcall Edit(Frxclass::TfrxCustomMemoView* c);
	void __fastcall EditDone();
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
public:
	/* TCustomMemo.Destroy */ inline __fastcall virtual ~TInplaceMemo() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TInplaceMemo(HWND ParentWindow) : Frxunicodectrls::TUnicodeMemo(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 crPencil = System::Int8(0xb);
}	/* namespace Frxdesgnworkspace */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDESGNWORKSPACE)
using namespace Frxdesgnworkspace;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdesgnworkspaceHPP
