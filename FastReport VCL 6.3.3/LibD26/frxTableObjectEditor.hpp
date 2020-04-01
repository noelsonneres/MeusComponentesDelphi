// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxTableObjectEditor.pas' rev: 33.00 (Windows)

#ifndef FrxtableobjecteditorHPP
#define FrxtableobjecteditorHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <System.Variants.hpp>
#include <Vcl.Controls.hpp>
#include <frxClass.hpp>
#include <frxDsgnIntf.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxtableobjecteditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxTableCellEditor;
class DELPHICLASS TfrxTableRowColumnEditor;
class DELPHICLASS TfrxDragDropRowColumnEditor;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxTableCellEditor : public Frxdsgnintf::TfrxComponentEditor
{
	typedef Frxdsgnintf::TfrxComponentEditor inherited;
	
public:
	virtual void __fastcall GetMenuItems();
	virtual bool __fastcall Execute(int Tag, bool Checked);
	virtual bool __fastcall Edit();
	virtual bool __fastcall HasEditor();
public:
	/* TfrxComponentEditor.Create */ inline __fastcall virtual TfrxTableCellEditor(Frxclass::TfrxComponent* Component, Frxclass::TfrxCustomDesigner* Designer, Vcl::Menus::TMenu* Menu) : Frxdsgnintf::TfrxComponentEditor(Component, Designer, Menu) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxTableCellEditor() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxTableRowColumnEditor : public Frxdsgnintf::TfrxComponentEditor
{
	typedef Frxdsgnintf::TfrxComponentEditor inherited;
	
public:
	virtual void __fastcall GetMenuItems();
	virtual bool __fastcall Execute(int Tag, bool Checked);
public:
	/* TfrxComponentEditor.Create */ inline __fastcall virtual TfrxTableRowColumnEditor(Frxclass::TfrxComponent* Component, Frxclass::TfrxCustomDesigner* Designer, Vcl::Menus::TMenu* Menu) : Frxdsgnintf::TfrxComponentEditor(Component, Designer, Menu) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxTableRowColumnEditor() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxDragDropRowColumnEditor : public Frxclass::TfrxInPlaceEditor
{
	typedef Frxclass::TfrxInPlaceEditor inherited;
	
public:
	virtual bool __fastcall DoCustomDragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoCustomDragDrop(System::TObject* Source, int X, int Y, Frxclass::TfrxInteractiveEventsParams &EventParams);
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxDragDropRowColumnEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : Frxclass::TfrxInPlaceEditor(aClassRef, aOwner) { }
	/* TfrxInPlaceEditor.Destroy */ inline __fastcall virtual ~TfrxDragDropRowColumnEditor() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxtableobjecteditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXTABLEOBJECTEDITOR)
using namespace Frxtableobjecteditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxtableobjecteditorHPP
