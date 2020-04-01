// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxCBFF.pas' rev: 33.00 (Windows)

#ifndef FrxcbffHPP
#define FrxcbffHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <frxStorage.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxcbff
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TCbffStream;
class DELPHICLASS TCbffDir;
class DELPHICLASS TCbffDocument;
struct TCbffHeader;
struct TCbffDirEntry;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TCbffStream : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Frxstorage::TBlockStream* Stream;
	Frxstorage::TBlockStream* SAT;
	__fastcall TCbffStream()/* overload */;
	__fastcall TCbffStream(unsigned SecShift)/* overload */;
	__fastcall virtual ~TCbffStream();
	int __fastcall WriteStream(void * Data, unsigned Size);
};

#pragma pack(pop)

enum DECLSPEC_DENUM TCbffDirKind : unsigned char { dkEmpty, dkStorage, dkStream, dkLock, dkProp, dkRoot };

enum DECLSPEC_DENUM TCbffNodeColor : unsigned char { ncRed, ncBlack };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCbffDir : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::WideString Name;
	Frxstorage::TBlockStream* Stream;
	Frxstorage::TObjList* Childs;
	TCbffDir* Right;
	TCbffDir* Left;
	TCbffDir* Parent;
	bool IsBlack;
	TCbffDirKind Kind;
	int SecID;
	int LeftID;
	int RightID;
	int ChildID;
	int SelfID;
	__fastcall TCbffDir();
	__fastcall virtual ~TCbffDir();
	void __fastcall Flush(System::Classes::TStream* Stream);
	TCbffDir* __fastcall Add(const System::WideString Name);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCbffDocument : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TCbffDir* Root;
	int SecShift;
	int ShortSecShift;
	unsigned MinStreamSize;
	__fastcall TCbffDocument();
	__fastcall virtual ~TCbffDocument();
	void __fastcall Flush(System::Classes::TStream* Stream);
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TCbffHeader
{
public:
	System::StaticArray<System::Byte, 8> Sign;
	System::StaticArray<System::Word, 8> Id;
	System::Word Rev;
	System::Word Ver;
	System::Word Order;
	System::Word Sec;
	System::Word SSec;
	System::StaticArray<System::Word, 5> NA1;
	unsigned nSAT;
	int Dir;
	unsigned NA2;
	unsigned MinSize;
	int SSAT;
	unsigned nSSAT;
	int MSAT;
	unsigned nMSAT;
	System::StaticArray<int, 109> sMSAT;
};
#pragma pack(pop)


typedef TCbffHeader *PCbffHeader;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TCbffDirEntry
{
public:
	System::StaticArray<System::WideChar, 32> Name;
	System::Word NameSize;
	System::Byte Kind;
	System::Byte Color;
	int Left;
	int Right;
	int Child;
	System::StaticArray<System::Word, 8> Id;
	unsigned Flags;
	System::StaticArray<unsigned, 2> Creation;
	System::StaticArray<unsigned, 2> LastMod;
	int Stream;
	unsigned Size;
	unsigned NA1;
};
#pragma pack(pop)


typedef TCbffDirEntry *PCbffDirEntry;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 siFree = System::Int8(-1);
static const System::Int8 siEOC = System::Int8(-2);
static const System::Int8 siSAT = System::Int8(-3);
static const System::Int8 siMSAT = System::Int8(-4);
}	/* namespace Frxcbff */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCBFF)
using namespace Frxcbff;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxcbffHPP
