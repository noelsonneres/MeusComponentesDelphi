// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxFontHeaderClass.pas' rev: 33.00 (Windows)

#ifndef FrxfontheaderclassHPP
#define FrxfontheaderclassHPP

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

namespace Frxfontheaderclass
{
//-- forward type declarations -----------------------------------------------
struct FontHeader;
class DELPHICLASS FontHeaderClass;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD FontHeader
{
public:
	unsigned version;
	unsigned revision;
	unsigned checkSumAdjustment;
	unsigned magicNumber;
	System::Word flags;
	System::Word unitsPerEm;
	unsigned __int64 CreatedDateTime;
	unsigned __int64 ModifiedDateTime;
	short xMin;
	short yMin;
	short xMax;
	short yMax;
	System::Word macStyle;
	System::Word lowestRecPPEM;
	short fontDirectionHint;
	short indexToLocFormat;
	short glyphDataFormat;
};
#pragma pack(pop)


enum DECLSPEC_DENUM IndexToLoc : unsigned char { IndexToLoc_LongType = 0x1, IndexToLoc_ShortType = 0x0 };

enum DECLSPEC_DENUM FontType : unsigned int { FontType_TrueTypeCollection = 1717793908, FontType_TrueTypeFontType = 0, FontType_OpenTypeFontType };

#pragma pack(push,4)
class PASCALIMPLEMENTATION FontHeaderClass : public Frxtruetypetable::TrueTypeTable
{
	typedef Frxtruetypetable::TrueTypeTable inherited;
	
public:
	FontHeader font_header;
	
private:
	IndexToLoc __fastcall get_indexToLocFormat();
	
public:
	__property IndexToLoc indexToLocFormat = {read=get_indexToLocFormat, nodefault};
	__property System::Word unitsPerEm = {read=font_header.unitsPerEm, nodefault};
	__fastcall FontHeaderClass(Frxtruetypetable::TrueTypeTable* src);
	
private:
	HIDESBASE void __fastcall ChangeEndian();
	
public:
	virtual void __fastcall Load(void * font);
	void __fastcall SaveFontHeader(void * header_ptr, unsigned CheckSum);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~FontHeaderClass() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxfontheaderclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXFONTHEADERCLASS)
using namespace Frxfontheaderclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxfontheaderclassHPP
