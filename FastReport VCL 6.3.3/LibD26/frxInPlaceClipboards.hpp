// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxInPlaceClipboards.pas' rev: 33.00 (Windows)

#ifndef FrxinplaceclipboardsHPP
#define FrxinplaceclipboardsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <frxClass.hpp>
#include <frxUtils.hpp>
#include <frxUnicodeCtrls.hpp>
#include <frxUnicodeUtils.hpp>
#include <Vcl.Clipbrd.hpp>
#include <System.Variants.hpp>
#include <System.WideStrings.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxinplaceclipboards
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxInPlaceBaseCopyPasteEditor;
class DELPHICLASS TfrxInPlaceMemoCopyPasteEditor;
class DELPHICLASS TfrxInPlacePictureCopyPasteEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxInPlaceBaseCopyPasteEditor : public Frxclass::TfrxInPlaceEditor
{
	typedef Frxclass::TfrxInPlaceEditor inherited;
	
private:
	void __fastcall SortObjets(System::Classes::TList* ObjList, System::Classes::TStringList* SortedList);
	
public:
	virtual void __fastcall CopyGoupContent(Frxclass::TfrxComponent* CopyFrom, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType CopyAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual void __fastcall PasteGoupContent(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxInPlaceBaseCopyPasteEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : Frxclass::TfrxInPlaceEditor(aClassRef, aOwner) { }
	/* TfrxInPlaceEditor.Destroy */ inline __fastcall virtual ~TfrxInPlaceBaseCopyPasteEditor() { }
	
};


class PASCALIMPLEMENTATION TfrxInPlaceMemoCopyPasteEditor : public TfrxInPlaceBaseCopyPasteEditor
{
	typedef TfrxInPlaceBaseCopyPasteEditor inherited;
	
public:
	virtual void __fastcall CopyContent(Frxclass::TfrxComponent* CopyFrom, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType CopyAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual void __fastcall PasteContent(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual bool __fastcall IsPasteAvailable(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual Frxclass::TfrxCopyPasteType __fastcall DefaultContentType();
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxInPlaceMemoCopyPasteEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : TfrxInPlaceBaseCopyPasteEditor(aClassRef, aOwner) { }
	/* TfrxInPlaceEditor.Destroy */ inline __fastcall virtual ~TfrxInPlaceMemoCopyPasteEditor() { }
	
};


class PASCALIMPLEMENTATION TfrxInPlacePictureCopyPasteEditor : public Frxclass::TfrxInPlaceEditor
{
	typedef Frxclass::TfrxInPlaceEditor inherited;
	
public:
	virtual void __fastcall CopyContent(Frxclass::TfrxComponent* CopyFrom, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType CopyAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual void __fastcall PasteContent(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
	virtual bool __fastcall IsPasteAvailable(Frxclass::TfrxComponent* PasteTo, Frxclass::TfrxInteractiveEventsParams &EventParams, Frxclass::TfrxCopyPasteType PasteAs = (Frxclass::TfrxCopyPasteType)(0x0));
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxInPlacePictureCopyPasteEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : Frxclass::TfrxInPlaceEditor(aClassRef, aOwner) { }
	/* TfrxInPlaceEditor.Destroy */ inline __fastcall virtual ~TfrxInPlacePictureCopyPasteEditor() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxinplaceclipboards */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXINPLACECLIPBOARDS)
using namespace Frxinplaceclipboards;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxinplaceclipboardsHPP
