// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'rc_Crypt.pas' rev: 33.00 (Windows)

#ifndef Rc_cryptHPP
#define Rc_cryptHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <rc_ApiRef.hpp>

//-- user supplied -----------------------------------------------------------

namespace Rc_crypt
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::Byte _KEYLength = System::Byte(0x80);
extern DELPHI_PACKAGE System::AnsiString __fastcall ExpandKey(System::AnsiString sKey, int iLength);
extern DELPHI_PACKAGE System::AnsiString __fastcall EnCryptString(const System::AnsiString sMessage, System::AnsiString sKeyMaterial);
extern DELPHI_PACKAGE System::AnsiString __fastcall DeCryptString(const System::AnsiString sMessage, System::AnsiString sKeyMaterial);
}	/* namespace Rc_crypt */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_RC_CRYPT)
using namespace Rc_crypt;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Rc_cryptHPP
