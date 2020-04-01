// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxServerUtils.pas' rev: 33.00 (Windows)

#ifndef FrxserverutilsHPP
#define FrxserverutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <Winapi.ActiveX.hpp>
#include <frxUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxserverutils
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxServerFormat : unsigned char { sfHTM, sfXML, sfXLS, sfRTF, sfCSV, sfTXT, sfPDF, sfJPG, sfBMP, sfTIFF, sfGIF, sfFRP, sfODS, sfODT };

typedef System::Set<TfrxServerFormat, TfrxServerFormat::sfHTM, TfrxServerFormat::sfODT> TfrxServerOutputFormats;

enum DECLSPEC_DENUM TfrxHTTPQueryType : unsigned char { qtGet, qtPost, qtHead };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::AnsiString __fastcall StrToHex(const System::AnsiString s);
extern DELPHI_PACKAGE System::AnsiString __fastcall HexToStr(const System::AnsiString s);
extern DELPHI_PACKAGE System::AnsiString __fastcall Byte2Hex(const System::Byte b);
extern DELPHI_PACKAGE System::AnsiString __fastcall GetHTTPErrorText(const int ErrorCode);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetUniqueFileName(const System::UnicodeString Path, const System::UnicodeString Prefix);
extern DELPHI_PACKAGE System::AnsiString __fastcall Str2HTML(const System::WideString Str)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall Str2HTML(const System::AnsiString Str)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall HTML2Str(const System::AnsiString Line);
extern DELPHI_PACKAGE System::AnsiString __fastcall UnQuoteStr(const System::AnsiString s);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetEnvVar(const System::UnicodeString VarName);
extern DELPHI_PACKAGE System::AnsiString __fastcall MakeSessionId(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxGetAbsPath(const System::UnicodeString Path);
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxGetAbsPathDir(const System::UnicodeString Path, const System::UnicodeString Dir);
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxGetRelPath(const System::UnicodeString Path);
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxGetRelPathDir(const System::UnicodeString Path, const System::UnicodeString Dir);
extern DELPHI_PACKAGE void __fastcall frxTouchDir(const System::UnicodeString Path);
extern DELPHI_PACKAGE void __fastcall SetCommaText(const System::UnicodeString Text, System::Classes::TStrings* sl, System::WideChar Comma = (System::WideChar)(0x3b));
extern DELPHI_PACKAGE System::UnicodeString __fastcall NormalDir(const System::UnicodeString DirName);
extern DELPHI_PACKAGE void __fastcall CopyFile(const System::UnicodeString fFrom, const System::UnicodeString fTo);
extern DELPHI_PACKAGE void __fastcall CopyFiles(const System::UnicodeString sFrom, const System::UnicodeString sTo, const System::UnicodeString sNames, const System::UnicodeString sExcept, const bool Recursive);
extern DELPHI_PACKAGE void __fastcall CopyFilesF(const System::UnicodeString sFrom, const System::UnicodeString sTo, const System::UnicodeString sNames, const System::UnicodeString sExcept);
}	/* namespace Frxserverutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXSERVERUTILS)
using namespace Frxserverutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxserverutilsHPP
