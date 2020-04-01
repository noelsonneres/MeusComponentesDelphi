// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPlatformServices.pas' rev: 33.00 (Windows)

#ifndef FrxplatformservicesHPP
#define FrxplatformservicesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxplatformservices
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef NativeInt frxInteger;

//-- var, const, procedure ---------------------------------------------------
#define LineBreak L"\r\n"
extern DELPHI_PACKAGE NativeInt __fastcall frxLength(System::UnicodeString s);
extern DELPHI_PACKAGE NativeInt __fastcall frxPos(const System::UnicodeString substr, const System::UnicodeString s);
extern DELPHI_PACKAGE void __fastcall frxDelete(System::UnicodeString &s, NativeInt Index, NativeInt Count)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxCopy(const System::UnicodeString s, NativeInt Index, NativeInt Count);
extern DELPHI_PACKAGE void __fastcall frxInsert(const System::UnicodeString source, System::UnicodeString &s, NativeInt Index);
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxUpperCase(const System::UnicodeString s);
extern DELPHI_PACKAGE void __fastcall frxDelete(System::WideString &s, NativeInt Index, NativeInt Count)/* overload */;
}	/* namespace Frxplatformservices */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPLATFORMSERVICES)
using namespace Frxplatformservices;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxplatformservicesHPP
