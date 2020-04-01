// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fqbRes.pas' rev: 33.00 (Windows)

#ifndef FqbresHPP
#define FqbresHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.ImgList.hpp>
#include <System.TypInfo.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fqbres
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfqbResources;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfqbResources : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TStringList* FNames;
	System::Classes::TStringList* FValues;
	
public:
	__fastcall TfqbResources();
	__fastcall virtual ~TfqbResources();
	System::UnicodeString __fastcall Get(const System::UnicodeString StrName);
	void __fastcall Add(const System::UnicodeString Ref, const System::UnicodeString Str);
	void __fastcall AddStrings(const System::UnicodeString Str);
	void __fastcall Clear();
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfqbResources* __fastcall fqbResources(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall fqbGet(int ID);
}	/* namespace Fqbres */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FQBRES)
using namespace Fqbres;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FqbresHPP
