// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDesgnWorkspace1.pas' rev: 33.00 (Windows)

#ifndef Frxdesgnworkspace1HPP
#define Frxdesgnworkspace1HPP

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
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <frxClass.hpp>
#include <frxDesgn.hpp>
#include <frxDesgnWorkspace.hpp>
#include <frxPopupForm.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdesgnworkspace1
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGuideItem;
class DELPHICLASS TfrxVirtualGuides;
class DELPHICLASS TDesignerWorkspace;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGuideItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	System::Extended Left;
	System::Extended Top;
	System::Extended Right;
	System::Extended Bottom;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxGuideItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxGuideItem() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxVirtualGuides : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxGuideItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxGuideItem* __fastcall GetGuides(int Index);
	
public:
	__fastcall TfrxVirtualGuides();
	HIDESBASE void __fastcall Add(System::Extended Left, System::Extended Top, System::Extended Right, System::Extended Bottom);
	__property TfrxGuideItem* Items[int Index] = {read=GetGuides/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxVirtualGuides() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TDesignerWorkspace : public Frxdesgnworkspace::TfrxDesignerWorkspace
{
	typedef Frxdesgnworkspace::TfrxDesignerWorkspace inherited;
	
private:
	Frxdesgn::TfrxDesignerForm* FDesigner;
	int FGuide;
	bool FShowGuides;
	bool FSimulateMove;
	Frxclass::TfrxDesignTool FTool;
	TfrxVirtualGuides* FVirtualGuides;
	System::Classes::TList* FVirtualGuideObjects;
	System::Classes::TList* FGuidesObjects;
	System::Classes::TList* FGuidesObjectsSize;
	bool FPopupFormVisible;
	Frxclass::TfrxComponent* FMouseDownObject;
	bool FStickToGuides;
	bool FGuidesAsAnchor;
	System::Extended FStickAccuracy;
	System::Extended FVVirtualGuid;
	System::Extended FHVirtualGuid;
	void __fastcall CreateVirtualGuides();
	void __fastcall SetShowGuides(const bool Value);
	void __fastcall SetHGuides(System::Classes::TStrings* const Value);
	void __fastcall SetVGuides(System::Classes::TStrings* const Value);
	System::Classes::TStrings* __fastcall GetHGuides();
	System::Classes::TStrings* __fastcall GetVGuides();
	void __fastcall SetTool(const Frxclass::TfrxDesignTool Value);
	
protected:
	virtual void __fastcall CheckGuides(System::Extended &kx, System::Extended &ky, bool &Result, bool IsMouseDown);
	DYNAMIC void __fastcall DragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	virtual void __fastcall DrawObjects();
	virtual void __fastcall DoFinishInPlace(System::TObject* Sender, bool Refresh, bool Modified);
	virtual void __fastcall SetDefaultEventParams(Frxclass::TfrxInteractiveEventsParams &EventParams);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	DYNAMIC void __fastcall DblClick();
	
public:
	__fastcall virtual TDesignerWorkspace(System::Classes::TComponent* AOwner);
	virtual void __fastcall ClearLastView();
	__fastcall virtual ~TDesignerWorkspace();
	virtual void __fastcall DeleteObjects();
	DYNAMIC void __fastcall DragDrop(System::TObject* Source, int X, int Y);
	void __fastcall SimulateMove();
	virtual void __fastcall SetVirtualGuids(System::Extended VGuid, System::Extended HGuid);
	virtual void __fastcall SetInsertion(Frxclass::TfrxComponentClass AClass, System::Extended AWidth, System::Extended AHeight, System::Word AFlag);
	__property System::Classes::TStrings* HGuides = {read=GetHGuides, write=SetHGuides};
	__property System::Classes::TStrings* VGuides = {read=GetVGuides, write=SetVGuides};
	__property bool ShowGuides = {read=FShowGuides, write=SetShowGuides, nodefault};
	__property bool StickToGuides = {read=FStickToGuides, write=FStickToGuides, nodefault};
	__property bool GuidesAsAnchor = {read=FGuidesAsAnchor, write=FGuidesAsAnchor, nodefault};
	__property System::Extended StickAccuracy = {read=FStickAccuracy, write=FStickAccuracy};
	__property Frxclass::TfrxDesignTool Tool = {read=FTool, write=SetTool, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TDesignerWorkspace(HWND ParentWindow) : Frxdesgnworkspace::TfrxDesignerWorkspace(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxdesgnworkspace1 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDESGNWORKSPACE1)
using namespace Frxdesgnworkspace1;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frxdesgnworkspace1HPP
