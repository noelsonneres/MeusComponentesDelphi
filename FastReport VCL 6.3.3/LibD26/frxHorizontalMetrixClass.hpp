// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxHorizontalMetrixClass.pas' rev: 33.00 (Windows)

#ifndef FrxhorizontalmetrixclassHPP
#define FrxhorizontalmetrixclassHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <TTFHelpers.hpp>
#include <frxTrueTypeTable.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxhorizontalmetrixclass
{
//-- forward type declarations -----------------------------------------------
struct longHorMetric;
class DELPHICLASS HorizontalMetrixClass;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD longHorMetric
{
public:
	System::Word advanceWidth;
	short lsb;
};
#pragma pack(pop)


typedef System::DynamicArray<longHorMetric> THorMetricArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION HorizontalMetrixClass : public Frxtruetypetable::TrueTypeTable
{
	typedef Frxtruetypetable::TrueTypeTable inherited;
	
private:
	THorMetricArray MetrixTable;
	
public:
	System::Word NumberOfMetrics;
	__fastcall HorizontalMetrixClass(Frxtruetypetable::TrueTypeTable* src);
	virtual void __fastcall Load(void * font);
	longHorMetric __fastcall GetItem(int index);
	__property longHorMetric Item[int index] = {read=GetItem};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~HorizontalMetrixClass() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxhorizontalmetrixclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXHORIZONTALMETRIXCLASS)
using namespace Frxhorizontalmetrixclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxhorizontalmetrixclassHPP
