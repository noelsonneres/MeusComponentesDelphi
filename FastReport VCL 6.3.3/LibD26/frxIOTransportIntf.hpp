// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportIntf.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportintfHPP
#define FrxiotransportintfHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <frxClass.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportintf
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxIOTransportItem;
class DELPHICLASS TfrxIOTransportsCollection;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxIOTransportItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	Frxclass::TfrxCustomIOTransport* IOTransport;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxIOTransportItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxIOTransportItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxIOTransportsCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxIOTransportItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxIOTransportItem* __fastcall GetIOTransportItem(int Index);
	
public:
	__fastcall TfrxIOTransportsCollection();
	void __fastcall Register(Frxclass::TfrxCustomIOTransport* Filter);
	void __fastcall Unregister(Frxclass::TfrxCustomIOTransport* Filter);
	__property TfrxIOTransportItem* Items[int Index] = {read=GetIOTransportItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxIOTransportsCollection() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxIOTransportsCollection* __fastcall frxIOTransports(void);
extern DELPHI_PACKAGE Frxclass::TfrxFilterVisibleState __fastcall GetFilterDialogVisibility(Frxclass::TfrxFilterVisibleState CreatedFrom);
extern DELPHI_PACKAGE void __fastcall FillItemsList(System::Classes::TStrings* Items, Frxclass::TfrxFilterVisibleState VisibleAt);
}	/* namespace Frxiotransportintf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTINTF)
using namespace Frxiotransportintf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportintfHPP
