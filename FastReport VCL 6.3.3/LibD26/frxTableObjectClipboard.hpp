// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxTableObjectClipboard.pas' rev: 33.00 (Windows)

#ifndef FrxtableobjectclipboardHPP
#define FrxtableobjectclipboardHPP

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

//-- user supplied -----------------------------------------------------------

namespace Frxtableobjectclipboard
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxRowColumnCopyPasteEditor;
class DELPHICLASS TfrxTableCellCopyPasteEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxRowColumnCopyPasteEditor : public Frxclass::TfrxInPlaceEditor
{
	typedef Frxclass::TfrxInPlaceEditor inherited;
	
public:
	virtual void __fastcall CopyContent(Frxclass::TfrxComponent* CopyFrom, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType CopyAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual void __fastcall PasteContent(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual bool __fastcall IsPasteAvailable(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxRowColumnCopyPasteEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : Frxclass::TfrxInPlaceEditor(aClassRef, aOwner) { }
	/* TfrxInPlaceEditor.Destroy */ inline __fastcall virtual ~TfrxRowColumnCopyPasteEditor() { }
	
};


class PASCALIMPLEMENTATION TfrxTableCellCopyPasteEditor : public Frxclass::TfrxInPlaceEditor
{
	typedef Frxclass::TfrxInPlaceEditor inherited;
	
public:
	virtual void __fastcall CopyContent(Frxclass::TfrxComponent* CopyFrom, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType CopyAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual void __fastcall PasteContent(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual bool __fastcall IsPasteAvailable(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxTableCellCopyPasteEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : Frxclass::TfrxInPlaceEditor(aClassRef, aOwner) { }
	/* TfrxInPlaceEditor.Destroy */ inline __fastcall virtual ~TfrxTableCellCopyPasteEditor() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxtableobjectclipboard */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXTABLEOBJECTCLIPBOARD)
using namespace Frxtableobjectclipboard;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxtableobjectclipboardHPP
