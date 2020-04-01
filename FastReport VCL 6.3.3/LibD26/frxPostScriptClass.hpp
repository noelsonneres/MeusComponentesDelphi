// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPostScriptClass.pas' rev: 33.00 (Windows)

#ifndef FrxpostscriptclassHPP
#define FrxpostscriptclassHPP

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

namespace Frxpostscriptclass
{
//-- forward type declarations -----------------------------------------------
struct PostScript;
class DELPHICLASS PostScriptClass;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD PostScript
{
public:
	unsigned isFixedPitch;
	int ItalicAngle;
	unsigned maxMemType1;
	unsigned maxMemType42;
	unsigned minMemType1;
	unsigned minMemType42;
	short underlinePosition;
	short underlineThickness;
	unsigned Version;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION PostScriptClass : public Frxtruetypetable::TrueTypeTable
{
	typedef Frxtruetypetable::TrueTypeTable inherited;
	
private:
	PostScript post_script;
	
public:
	__fastcall PostScriptClass(Frxtruetypetable::TrueTypeTable* src);
	
private:
	HIDESBASE void __fastcall ChangeEndian();
	
public:
	virtual void __fastcall Load(void * font);
	virtual unsigned __fastcall Save(void * font, unsigned offset);
	__property int ItalicAngle = {read=post_script.ItalicAngle, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~PostScriptClass() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxpostscriptclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPOSTSCRIPTCLASS)
using namespace Frxpostscriptclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxpostscriptclassHPP
