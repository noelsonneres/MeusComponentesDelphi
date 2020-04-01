// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'rc_ApiRef.pas' rev: 33.00 (Windows)

#ifndef Rc_apirefHPP
#define Rc_apirefHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <rc_AlgRef.hpp>

//-- user supplied -----------------------------------------------------------

namespace Rc_apiref
{
//-- forward type declarations -----------------------------------------------
struct keyInstance;
struct cipherInstance;
//-- type declarations -------------------------------------------------------
typedef System::Byte word8;

typedef System::Word word16;

typedef unsigned word32;

typedef System::StaticArray<System::Byte, 2147483647> TByteArray;

typedef TByteArray *PByte;

typedef keyInstance *PkeyInstance;

#pragma pack(push,1)
struct DECLSPEC_DRECORD keyInstance
{
public:
	System::Byte direction;
	int keyLen;
	System::StaticArray<char, 65> keyMaterial;
	int blockLen;
	Rc_algref::TArrayRK keySched;
};
#pragma pack(pop)


typedef keyInstance TkeyInstance;

typedef cipherInstance *PcipherInstance;

#pragma pack(push,1)
struct DECLSPEC_DRECORD cipherInstance
{
public:
	System::Byte mode;
	System::StaticArray<System::Byte, 16> IV;
	int blockLen;
};
#pragma pack(pop)


typedef cipherInstance TcipherInstance;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 MAXBC = System::Int8(0x8);
static const System::Int8 MAXKC = System::Int8(0x8);
static const System::Int8 MAXROUNDS = System::Int8(0xe);
static const System::Int8 DIR_ENCRYPT = System::Int8(0x0);
static const System::Int8 DIR_DECRYPT = System::Int8(0x1);
static const System::Int8 MODE_ECB = System::Int8(0x1);
static const System::Int8 MODE_CBC = System::Int8(0x2);
static const System::Int8 MODE_CFB1 = System::Int8(0x3);
static const System::Int8 rTRUE = System::Int8(0x1);
static const System::Int8 rFALSE = System::Int8(0x0);
static const System::Byte BITSPERBLOCK = System::Byte(0x80);
static const System::Int8 BAD_KEY_DIR = System::Int8(-1);
static const System::Int8 BAD_KEY_MAT = System::Int8(-2);
static const System::Int8 BAD_KEY_INSTANCE = System::Int8(-3);
static const System::Int8 BAD_CIPHER_MODE = System::Int8(-4);
static const System::Int8 BAD_CIPHER_STATE = System::Int8(-5);
static const System::Int8 BAD_CIPHER_INSTANCE = System::Int8(-7);
static const System::Int8 MAX_KEY_SIZE = System::Int8(0x40);
static const System::Int8 MAX_IV_SIZE = System::Int8(0x10);
extern DELPHI_PACKAGE int __fastcall makeKey(PkeyInstance key, System::Byte direction, int keyLen, char * keyMaterial);
extern DELPHI_PACKAGE int __fastcall cipherInit(PcipherInstance cipher, System::Byte mode, System::WideChar * IV);
extern DELPHI_PACKAGE int __fastcall blocksEnCrypt(PcipherInstance cipher, PkeyInstance key, PByte input, int inputLen, PByte outBuffer);
extern DELPHI_PACKAGE int __fastcall blocksDeCrypt(PcipherInstance cipher, PkeyInstance key, PByte input, int inputLen, PByte outBuffer);
extern DELPHI_PACKAGE int __fastcall cipherUpdateRounds(PcipherInstance cipher, PkeyInstance key, PByte input, int inputLen, PByte outBuffer, int iRounds);
}	/* namespace Rc_apiref */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_RC_APIREF)
using namespace Rc_apiref;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Rc_apirefHPP
