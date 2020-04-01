// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxNetUtils.pas' rev: 33.00 (Windows)

#ifndef FrxnetutilsHPP
#define FrxnetutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <System.Win.Registry.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxnetutils
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall GMTDateTimeToRFCDateTime(const System::TDateTime D);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DateTimeToRFCDateTime(const System::TDateTime D);
extern DELPHI_PACKAGE System::UnicodeString __fastcall PadLeft(const System::UnicodeString S, const System::WideChar PadChar, const int Len);
extern DELPHI_PACKAGE System::UnicodeString __fastcall PadRight(const System::UnicodeString S, const System::WideChar PadChar, const int Len);
extern DELPHI_PACKAGE System::AnsiString __fastcall Base64Encode(const System::AnsiString S);
extern DELPHI_PACKAGE System::AnsiString __fastcall Base64Decode(const System::AnsiString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetFileMIMEType(const System::UnicodeString FileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetSocketErrorText(const int ErrorCode);
extern DELPHI_PACKAGE void __fastcall PMessages(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UpdateCookies(const System::UnicodeString Header, const System::UnicodeString Cookies);
extern DELPHI_PACKAGE System::AnsiString __fastcall ParseHeaderField(const System::AnsiString Field, const System::AnsiString Header);
}	/* namespace Frxnetutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXNETUTILS)
using namespace Frxnetutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxnetutilsHPP
