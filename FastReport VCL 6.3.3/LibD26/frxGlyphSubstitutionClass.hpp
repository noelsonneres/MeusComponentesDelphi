// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGlyphSubstitutionClass.pas' rev: 33.00 (Windows)

#ifndef FrxglyphsubstitutionclassHPP
#define FrxglyphsubstitutionclassHPP

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

namespace Frxglyphsubstitutionclass
{
//-- forward type declarations -----------------------------------------------
struct FeatureRecord;
struct GSUB_Header;
struct LangSysRecord;
struct LangSysTable;
struct ScriptListRecord;
struct ScriptListTable;
struct ScriptTable;
class DELPHICLASS GlyphSubstitutionClass;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD FeatureRecord
{
public:
	System::Word Feature;
	unsigned FeatureTag;
};
#pragma pack(pop)


struct DECLSPEC_DRECORD GSUB_Header
{
public:
	unsigned Version;
	System::Word ScriptList;
	System::Word FeatureList;
	System::Word LookupList;
};


#pragma pack(push,1)
struct DECLSPEC_DRECORD LangSysRecord
{
public:
	unsigned LangSysTag;
	System::Word LangSys;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD LangSysTable
{
public:
	System::Word LookupOrder;
	System::Word ReqFeatureIndex;
	System::Word FeatureCount;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD ScriptListRecord
{
public:
	unsigned ScriptTag;
	System::Word ScriptOffset;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD ScriptListTable
{
public:
	System::Word CountScripts;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD ScriptTable
{
public:
	System::Word DefaultLangSys;
	System::Word LangSysCount;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION GlyphSubstitutionClass : public Frxtruetypetable::TrueTypeTable
{
	typedef Frxtruetypetable::TrueTypeTable inherited;
	
private:
	GSUB_Header header;
	
public:
	__fastcall GlyphSubstitutionClass(Frxtruetypetable::TrueTypeTable* src);
	
private:
	HIDESBASE void __fastcall ChangeEndian();
	
public:
	virtual void __fastcall Load(void * font);
	virtual unsigned __fastcall Save(void * font, unsigned offset);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~GlyphSubstitutionClass() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxglyphsubstitutionclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGLYPHSUBSTITUTIONCLASS)
using namespace Frxglyphsubstitutionclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxglyphsubstitutionclassHPP
