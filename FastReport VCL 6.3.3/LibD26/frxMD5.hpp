// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxmd5.pas' rev: 33.00 (Windows)

#ifndef Frxmd5HPP
#define Frxmd5HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmd5
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMD5;
//-- type declarations -------------------------------------------------------
typedef unsigned uint4;

typedef System::Byte uchar;

typedef unsigned *Puint4;

typedef System::Byte *Puchar;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxMD5 : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::StaticArray<unsigned, 4> m_State;
	System::StaticArray<unsigned, 2> m_Count;
	System::StaticArray<System::Byte, 64> m_Buffer;
	System::StaticArray<System::Byte, 16> m_Digest;
	void __fastcall Transform(Puchar block);
	void __fastcall Encode(Puchar dest, Puint4 src, unsigned nLength);
	void __fastcall Decode(Puint4 dest, Puchar src, unsigned nLength);
	unsigned __fastcall RotateLeft(unsigned x, unsigned n);
	void __fastcall FF(unsigned &a, unsigned b, unsigned c, unsigned d, unsigned x, unsigned s, unsigned ac);
	void __fastcall GG(unsigned &a, unsigned b, unsigned c, unsigned d, unsigned x, unsigned s, unsigned ac);
	void __fastcall HH(unsigned &a, unsigned b, unsigned c, unsigned d, unsigned x, unsigned s, unsigned ac);
	void __fastcall II(unsigned &a, unsigned b, unsigned c, unsigned d, unsigned x, unsigned s, unsigned ac);
	
public:
	__fastcall TfrxMD5();
	void __fastcall Init();
	void __fastcall Update(Puchar chInput, unsigned nInputLen);
	void __fastcall Finalize();
	Puchar __fastcall Digest();
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxMD5() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const int MD5_INIT_STATE_0 = int(0x67452301);
static const unsigned MD5_INIT_STATE_1 = unsigned(0xefcdab89);
static const unsigned MD5_INIT_STATE_2 = unsigned(0x98badcfe);
static const int MD5_INIT_STATE_3 = int(0x10325476);
static const System::Int8 MD5_S11 = System::Int8(0x7);
static const System::Int8 MD5_S12 = System::Int8(0xc);
static const System::Int8 MD5_S13 = System::Int8(0x11);
static const System::Int8 MD5_S14 = System::Int8(0x16);
static const System::Int8 MD5_S21 = System::Int8(0x5);
static const System::Int8 MD5_S22 = System::Int8(0x9);
static const System::Int8 MD5_S23 = System::Int8(0xe);
static const System::Int8 MD5_S24 = System::Int8(0x14);
static const System::Int8 MD5_S31 = System::Int8(0x4);
static const System::Int8 MD5_S32 = System::Int8(0xb);
static const System::Int8 MD5_S33 = System::Int8(0x10);
static const System::Int8 MD5_S34 = System::Int8(0x17);
static const System::Int8 MD5_S41 = System::Int8(0x6);
static const System::Int8 MD5_S42 = System::Int8(0xa);
static const System::Int8 MD5_S43 = System::Int8(0xf);
static const System::Int8 MD5_S44 = System::Int8(0x15);
static const unsigned MD5_T01 = unsigned(0xd76aa478);
static const unsigned MD5_T02 = unsigned(0xe8c7b756);
static const int MD5_T03 = int(0x242070db);
static const unsigned MD5_T04 = unsigned(0xc1bdceee);
static const unsigned MD5_T05 = unsigned(0xf57c0faf);
static const int MD5_T06 = int(0x4787c62a);
static const unsigned MD5_T07 = unsigned(0xa8304613);
static const unsigned MD5_T08 = unsigned(0xfd469501);
static const int MD5_T09 = int(0x698098d8);
static const unsigned MD5_T10 = unsigned(0x8b44f7af);
static const unsigned MD5_T11 = unsigned(0xffff5bb1);
static const unsigned MD5_T12 = unsigned(0x895cd7be);
static const int MD5_T13 = int(0x6b901122);
static const unsigned MD5_T14 = unsigned(0xfd987193);
static const unsigned MD5_T15 = unsigned(0xa679438e);
static const int MD5_T16 = int(0x49b40821);
static const unsigned MD5_T17 = unsigned(0xf61e2562);
static const unsigned MD5_T18 = unsigned(0xc040b340);
static const int MD5_T19 = int(0x265e5a51);
static const unsigned MD5_T20 = unsigned(0xe9b6c7aa);
static const unsigned MD5_T21 = unsigned(0xd62f105d);
static const int MD5_T22 = int(0x2441453);
static const unsigned MD5_T23 = unsigned(0xd8a1e681);
static const unsigned MD5_T24 = unsigned(0xe7d3fbc8);
static const int MD5_T25 = int(0x21e1cde6);
static const unsigned MD5_T26 = unsigned(0xc33707d6);
static const unsigned MD5_T27 = unsigned(0xf4d50d87);
static const int MD5_T28 = int(0x455a14ed);
static const unsigned MD5_T29 = unsigned(0xa9e3e905);
static const unsigned MD5_T30 = unsigned(0xfcefa3f8);
static const int MD5_T31 = int(0x676f02d9);
static const unsigned MD5_T32 = unsigned(0x8d2a4c8a);
static const unsigned MD5_T33 = unsigned(0xfffa3942);
static const unsigned MD5_T34 = unsigned(0x8771f681);
static const int MD5_T35 = int(0x6d9d6122);
static const unsigned MD5_T36 = unsigned(0xfde5380c);
static const unsigned MD5_T37 = unsigned(0xa4beea44);
static const int MD5_T38 = int(0x4bdecfa9);
static const unsigned MD5_T39 = unsigned(0xf6bb4b60);
static const unsigned MD5_T40 = unsigned(0xbebfbc70);
static const int MD5_T41 = int(0x289b7ec6);
static const unsigned MD5_T42 = unsigned(0xeaa127fa);
static const unsigned MD5_T43 = unsigned(0xd4ef3085);
static const int MD5_T44 = int(0x4881d05);
static const unsigned MD5_T45 = unsigned(0xd9d4d039);
static const unsigned MD5_T46 = unsigned(0xe6db99e5);
static const int MD5_T47 = int(0x1fa27cf8);
static const unsigned MD5_T48 = unsigned(0xc4ac5665);
static const unsigned MD5_T49 = unsigned(0xf4292244);
static const int MD5_T50 = int(0x432aff97);
static const unsigned MD5_T51 = unsigned(0xab9423a7);
static const unsigned MD5_T52 = unsigned(0xfc93a039);
static const int MD5_T53 = int(0x655b59c3);
static const unsigned MD5_T54 = unsigned(0x8f0ccc92);
static const unsigned MD5_T55 = unsigned(0xffeff47d);
static const unsigned MD5_T56 = unsigned(0x85845dd1);
static const int MD5_T57 = int(0x6fa87e4f);
static const unsigned MD5_T58 = unsigned(0xfe2ce6e0);
static const unsigned MD5_T59 = unsigned(0xa3014314);
static const int MD5_T60 = int(0x4e0811a1);
static const unsigned MD5_T61 = unsigned(0xf7537e82);
static const unsigned MD5_T62 = unsigned(0xbd3af235);
static const int MD5_T63 = int(0x2ad7d2bb);
static const unsigned MD5_T64 = unsigned(0xeb86d391);
extern DELPHI_PACKAGE System::StaticArray<System::Byte, 64> PADDING;
extern DELPHI_PACKAGE System::AnsiString __fastcall PrintMD5(Puchar md5Digest);
extern DELPHI_PACKAGE System::AnsiString __fastcall MD5String(System::AnsiString szString);
extern DELPHI_PACKAGE System::AnsiString __fastcall MD5Stream(System::Classes::TStream* Stream);
extern DELPHI_PACKAGE System::AnsiString __fastcall MD5File(System::UnicodeString szFilename);
extern DELPHI_PACKAGE void __fastcall MD5Buf(void * Buf, const int Len, void * Digest);
}	/* namespace Frxmd5 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMD5)
using namespace Frxmd5;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frxmd5HPP
