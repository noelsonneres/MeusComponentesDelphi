// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxCollections.pas' rev: 33.00 (Windows)

#ifndef FrxcollectionsHPP
#define FrxcollectionsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxcollections
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCollectionItem;
class DELPHICLASS TfrxCollection;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCollectionItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	int FUniqueIndex;
	bool FIsInherited;
	virtual System::UnicodeString __fastcall GetInheritedName();
	virtual void __fastcall SetInheritedName(const System::UnicodeString Value);
	
public:
	__fastcall virtual TfrxCollectionItem(System::Classes::TCollection* ACollection);
	void __fastcall CreateUniqueIName(System::Classes::TCollection* ACollection);
	virtual bool __fastcall IsUniqueNameStored();
	__property bool IsInherited = {read=FIsInherited, write=FIsInherited, nodefault};
	__property System::UnicodeString InheritedName = {read=GetInheritedName, write=SetInheritedName};
	__property int UniqueIndex = {read=FUniqueIndex, write=FUniqueIndex, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxCollectionItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	virtual void __fastcall SerializeProperties(System::TObject* Writer, TfrxCollection* Ancestor, System::Classes::TComponent* Owner);
	virtual void __fastcall DeserializeProperties(System::UnicodeString PropName, System::TObject* Reader, TfrxCollection* Ancestor);
	virtual TfrxCollectionItem* __fastcall FindByName(System::UnicodeString Name);
public:
	/* TCollection.Create */ inline __fastcall TfrxCollection(System::Classes::TCollectionItemClass ItemClass) : System::Classes::TCollection(ItemClass) { }
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxCollection() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxcollections */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCOLLECTIONS)
using namespace Frxcollections;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxcollectionsHPP
