// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxKerningTableClass.pas' rev: 33.00 (Windows)

#ifndef FrxkerningtableclassHPP
#define FrxkerningtableclassHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <TTFHelpers.hpp>
#include <frxFontHeaderClass.hpp>
#include <frxTrueTypeTable.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxkerningtableclass
{
//-- forward type declarations -----------------------------------------------
struct CommonKerningHeader;
struct FormatZero;
struct FormatZeroPair;
struct KerningTableHeader;
class DELPHICLASS KerningSubtableClass;
class DELPHICLASS KerningTableClass;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD CommonKerningHeader
{
public:
	System::Word Coverage;
	System::Word Length;
	System::Word Version;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD FormatZero
{
public:
	System::Word entrySelector;
	System::Word nPairs;
	System::Word rangeShift;
	System::Word searchRange;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD FormatZeroPair
{
public:
	unsigned key_value;
	short value;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD KerningTableHeader
{
public:
	System::Word Version;
	System::Word nTables;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION KerningSubtableClass : public Ttfhelpers::TTF_Helpers
{
	typedef Ttfhelpers::TTF_Helpers inherited;
	
private:
	CommonKerningHeader common_header;
	System::Classes::TStringList* zero_pairs;
	FormatZero format_zero;
	
public:
	__fastcall KerningSubtableClass(void * kerning_table_ptr);
	__fastcall virtual ~KerningSubtableClass();
	
private:
	short __fastcall get_Item(unsigned inx);
	
public:
	__property short Item[unsigned hash_value] = {read=get_Item};
	__property System::Word Length = {read=common_header.Length, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION KerningTableClass : public Frxtruetypetable::TrueTypeTable
{
	typedef Frxtruetypetable::TrueTypeTable inherited;
	
private:
	KerningTableHeader kerning_table_header;
	System::Classes::TList* kerning_subtables_collection;
	
public:
	__fastcall KerningTableClass(Frxtruetypetable::TrueTypeTable* src);
	__fastcall virtual ~KerningTableClass();
	
private:
	HIDESBASE void __fastcall ChangeEndian();
	
public:
	virtual void __fastcall Load(void * font);
	
private:
	short __fastcall get_Item(unsigned idx);
	
public:
	__property short Item[unsigned hash_value] = {read=get_Item};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxkerningtableclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXKERNINGTABLECLASS)
using namespace Frxkerningtableclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxkerningtableclassHPP
