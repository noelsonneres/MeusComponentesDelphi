// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'rc_AlgRef.pas' rev: 33.00 (Windows)

#ifndef Rc_algrefHPP
#define Rc_algrefHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Rc_algref
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef System::Byte word8;

typedef System::Word word16;

typedef unsigned word32;

typedef System::StaticArray<System::StaticArray<System::Byte, 8>, 4> TArrayK;

typedef TArrayK *PArrayK;

typedef System::StaticArray<System::StaticArray<System::StaticArray<System::Byte, 8>, 4>, 15> TArrayRK;

typedef System::StaticArray<System::Byte, 256> TArrayBox;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 MAXBC = System::Int8(0x8);
static const System::Int8 MAXKC = System::Int8(0x8);
static const System::Int8 MAXROUNDS = System::Int8(0xe);
extern DELPHI_PACKAGE int __fastcall rijndaelKeySched(const TArrayK &k, int keyBits, int blockBits, TArrayRK &W);
extern DELPHI_PACKAGE int __fastcall rijndaelEncrypt(TArrayK &a, int keyBits, int blockBits, const TArrayRK &rk);
extern DELPHI_PACKAGE int __fastcall rijndaelEncryptRound(TArrayK &a, int keyBits, int blockBits, const TArrayRK &rk, int &irounds);
extern DELPHI_PACKAGE int __fastcall rijndaelDecrypt(TArrayK &a, int keyBits, int blockBits, const TArrayRK &rk);
extern DELPHI_PACKAGE int __fastcall rijndaelDecryptRound(TArrayK &a, int keyBits, int blockBits, const TArrayRK &rk, int &irounds);
}	/* namespace Rc_algref */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_RC_ALGREF)
using namespace Rc_algref;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Rc_algrefHPP
