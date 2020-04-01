// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxTrueTypeCollection.pas' rev: 33.00 (Windows)

#ifndef FrxtruetypecollectionHPP
#define FrxtruetypecollectionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Windows.hpp>
#include <TTFHelpers.hpp>
#include <frxTrueTypeFont.hpp>
#include <frxFontHeaderClass.hpp>
#include <frxNameTableClass.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxtruetypecollection
{
//-- forward type declarations -----------------------------------------------
struct TTCollectionHeader;
class DELPHICLASS TrueTypeCollection;
//-- type declarations -------------------------------------------------------
typedef System::Classes::TList TFontCollection;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TTCollectionHeader
{
public:
	unsigned TTCTag;
	unsigned Version;
	unsigned numFonts;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TrueTypeCollection : public Ttfhelpers::TTF_Helpers
{
	typedef Ttfhelpers::TTF_Helpers inherited;
	
private:
	System::Classes::TList* fonts_collection;
	System::Classes::TList* __fastcall get_FontCollection();
	Frxtruetypefont::TrueTypeFont* __fastcall get_Item(System::UnicodeString FamilyName);
	
public:
	__fastcall TrueTypeCollection();
	__fastcall virtual ~TrueTypeCollection();
	void __fastcall Initialize(char * FD, int FontDataSize);
	Frxtruetypefont::TrueTypeFont* __fastcall LoadFont(Vcl::Graphics::TFont* font);
	Frxtruetypefont::TByteArray __fastcall PackFont(Frxtruetypefont::TrueTypeFont* ttf, System::Classes::TList* UsedAlphabet);
	__property System::Classes::TList* FontCollection = {read=get_FontCollection};
	__property Frxtruetypefont::TrueTypeFont* Item[System::UnicodeString FamilyName] = {read=get_Item};
};

#pragma pack(pop)

typedef System::StaticArray<System::WideString, 12> Frxtruetypecollection__2;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 Elements = System::Int8(0xc);
extern DELPHI_PACKAGE Frxtruetypecollection__2 Substitutes;
}	/* namespace Frxtruetypecollection */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXTRUETYPECOLLECTION)
using namespace Frxtruetypecollection;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxtruetypecollectionHPP
