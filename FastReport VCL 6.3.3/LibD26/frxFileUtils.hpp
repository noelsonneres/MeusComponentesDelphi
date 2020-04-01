// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxFileUtils.pas' rev: 33.00 (Windows)

#ifndef FrxfileutilsHPP
#define FrxfileutilsHPP

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
#include <Winapi.ShlObj.hpp>
#include <Vcl.FileCtrl.hpp>
#include <System.Win.Registry.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxfileutils
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE int __fastcall GetFileSize(const System::UnicodeString FileName);
extern DELPHI_PACKAGE int __fastcall StreamSearch(System::Classes::TStream* Strm, const int StartPos, const System::AnsiString Value);
extern DELPHI_PACKAGE System::UnicodeString __fastcall BrowseDialog(const System::UnicodeString Path, const System::UnicodeString Title = System::UnicodeString());
extern DELPHI_PACKAGE void __fastcall DeleteFolder(const System::UnicodeString DirName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetFileMIMEType(const System::UnicodeString Extension);
}	/* namespace Frxfileutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXFILEUTILS)
using namespace Frxfileutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxfileutilsHPP
