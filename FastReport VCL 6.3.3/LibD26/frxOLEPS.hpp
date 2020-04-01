// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxOLEPS.pas' rev: 33.00 (Windows)

#ifndef FrxolepsHPP
#define FrxolepsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxoleps
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOlepsProp;
class DELPHICLASS TOlepsPropSet;
class DELPHICLASS TOlepsStream;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<unsigned, 4> TOlepsFmtId;

typedef unsigned TOlepsPropId;

typedef System::Word TOlepsPropType;

typedef unsigned TOlepsAccess;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOlepsProp : public System::Classes::TMemoryStream
{
	typedef System::Classes::TMemoryStream inherited;
	
public:
	unsigned PropId;
	System::Word PropType;
	int Offset;
	void __fastcall Flush(System::Classes::TStream* Stream);
	void __fastcall WriteVal(int Value, int BytesCount);
	void __fastcall WriteUCS(const System::WideString Str);
	void __fastcall WriteAnsi(const System::AnsiString Str);
public:
	/* TMemoryStream.Destroy */ inline __fastcall virtual ~TOlepsProp() { }
	
public:
	/* TObject.Create */ inline __fastcall TOlepsProp() : System::Classes::TMemoryStream() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOlepsPropSet : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TOlepsFmtId FmtId;
	System::Classes::TList* Props;
	int Offset;
	__fastcall TOlepsPropSet();
	__fastcall virtual ~TOlepsPropSet();
	void __fastcall Flush(System::Classes::TStream* Stream);
	TOlepsProp* __fastcall Add(unsigned PropId, System::Word PropType);
	TOlepsProp* __fastcall AddUCS(unsigned PropId, const System::WideString Str);
	TOlepsProp* __fastcall AddAnsi(unsigned PropId, const System::AnsiString Str);
	TOlepsProp* __fastcall AddUnicode(unsigned PropId, const System::WideString Str);
	TOlepsProp* __fastcall AddTime(unsigned PropId, const _FILETIME &t);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOlepsStream : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::Classes::TList* PropSets;
	__fastcall TOlepsStream();
	__fastcall virtual ~TOlepsStream();
	void __fastcall Flush(System::Classes::TStream* Stream);
	TOlepsPropSet* __fastcall Add(const TOlepsFmtId &FmtId);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 OlepsSiCodepage = System::Int8(0x1);
static const System::Int8 OlepsSiAuthor = System::Int8(0x4);
static const System::Int8 OlepsSiLastAuthor = System::Int8(0x8);
static const System::Int8 OlepsSiAppName = System::Int8(0x12);
static const System::Int8 OlepsSiAccess = System::Int8(0x13);
static const System::Int8 OlepsSiComment = System::Int8(0x6);
static const System::Int8 OlepsSiKeywords = System::Int8(0x5);
static const System::Int8 OlepsSiSubject = System::Int8(0x3);
static const System::Int8 OlepsSiTitle = System::Int8(0x2);
static const System::Int8 OlepsSiRevision = System::Int8(0x9);
static const System::Int8 OlepsSiCreation = System::Int8(0xc);
static const System::Int8 OlepsSiLastSave = System::Int8(0xd);
static const System::Int8 OlepsAfAll = System::Int8(0x0);
static const System::Int8 OlepsAfPassword = System::Int8(0x1);
static const System::Int8 OlepsAfReadOnlyR = System::Int8(0x2);
static const System::Int8 OlepsAfReadOnlyF = System::Int8(0x4);
static const System::Int8 OlepsAfNoAnnot = System::Int8(0x8);
static const System::Int8 OlepsDsiCategory = System::Int8(0x2);
static const System::Int8 OlepsDsiCompany = System::Int8(0xf);
static const System::Int8 OlepsDsiManager = System::Int8(0xe);
extern DELPHI_PACKAGE TOlepsFmtId OlepsFmtIdSi;
extern DELPHI_PACKAGE TOlepsFmtId OlepsFmtIdDsi;
static const System::Int8 OlepsPtWord = System::Int8(0x2);
static const System::Int8 OlepsPtInt = System::Int8(0x3);
static const System::Int8 OlepsPtString = System::Int8(0x1e);
static const System::Int8 OlepsPtUnicode = System::Int8(0x1f);
static const System::Int8 OlepsPtTime = System::Int8(0x40);
}	/* namespace Frxoleps */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXOLEPS)
using namespace Frxoleps;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxolepsHPP
