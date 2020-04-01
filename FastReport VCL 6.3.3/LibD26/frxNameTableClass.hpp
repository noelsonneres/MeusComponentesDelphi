// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxNameTableClass.pas' rev: 33.00 (Windows)

#ifndef FrxnametableclassHPP
#define FrxnametableclassHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <TTFHelpers.hpp>
#include <frxFontHeaderClass.hpp>
#include <frxTrueTypeTable.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxnametableclass
{
//-- forward type declarations -----------------------------------------------
struct NamingTableHeader;
struct NamingRecord;
class DELPHICLASS NameTableClass;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM NameID : unsigned char { NameID_CompatibleFull = 18, NameID_CopyrightNotice = 0, NameID_Description = 10, NameID_Designer = 9, NameID_FamilyName = 1, NameID_FullName = 4, NameID_LicenseDescription = 13, NameID_LicenseInfoURL, NameID_Manufacturer = 8, NameID_PostscriptCID = 20, NameID_PostscriptName = 6, NameID_PreferredFamily = 16, NameID_PreferredSubFamily, NameID_SampleText = 19, NameID_SubFamilyName = 2, NameID_Trademark = 7, NameID_UniqueID = 3, NameID_URL_Designer = 12, NameID_URL_Vendor = 11, NameID_Version = 5, NameID_WWS_Family_Name = 21, NameID_WWS_SubFamily_Name };

#pragma pack(push,1)
struct DECLSPEC_DRECORD NamingTableHeader
{
public:
	System::Word TableVersion;
	System::Word Count;
	System::Word stringOffset;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD NamingRecord
{
public:
	System::Word PlatformID;
	System::Word EncodingID;
	System::Word LanguageID;
	System::Word NameID;
	System::Word Length;
	System::Word Offset;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION NameTableClass : public Frxtruetypetable::TrueTypeTable
{
	typedef Frxtruetypetable::TrueTypeTable inherited;
	
private:
	NamingTableHeader name_header;
	void *namerecord_ptr;
	void *string_storage_ptr;
	System::Word FPlatform;
	
public:
	__fastcall NameTableClass(Frxtruetypetable::TrueTypeTable* src);
	__fastcall virtual ~NameTableClass();
	
private:
	HIDESBASE void __fastcall ChangeEndian();
	
public:
	virtual void __fastcall Load(void * font);
	
private:
	System::WideString __fastcall get_Item(NameID Index);
	
public:
	System::WideString __fastcall IsHasFontName(NameID Index, const System::WideString FontName);
	__property System::WideString Item[NameID Index] = {read=get_Item};
	__property System::Word Platform = {read=FPlatform, write=FPlatform, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxnametableclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXNAMETABLECLASS)
using namespace Frxnametableclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxnametableclassHPP
