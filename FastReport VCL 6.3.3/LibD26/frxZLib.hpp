// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxZLib.pas' rev: 33.00 (Windows)

#ifndef FrxzlibHPP
#define FrxzlibHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxzlib
{
//-- forward type declarations -----------------------------------------------
struct TZStreamRec;
class DELPHICLASS TCustomZStream;
class DELPHICLASS TZCompressionStream;
class DELPHICLASS TZDecompressionStream;
class DELPHICLASS EZLibError;
class DELPHICLASS EZCompressionError;
class DELPHICLASS EZDecompressionError;
//-- type declarations -------------------------------------------------------
typedef void * __fastcall (*TZAlloc)(void * opaque, int items, int size);

typedef void __fastcall (*TZFree)(void * opaque, void * block);

enum DECLSPEC_DENUM TZCompressionLevel : unsigned char { zcNone, zcFastest, zcDefault, zcMax };

#pragma pack(push,1)
struct DECLSPEC_DRECORD TZStreamRec
{
public:
	System::Byte *next_in;
	int avail_in;
	int total_in;
	System::Byte *next_out;
	int avail_out;
	int total_out;
	System::Byte *msg;
	void *state;
	TZAlloc zalloc;
	TZFree zfree;
	void *opaque;
	int data_type;
	int adler;
	int reserved;
};
#pragma pack(pop)


class PASCALIMPLEMENTATION TCustomZStream : public System::Classes::TStream
{
	typedef System::Classes::TStream inherited;
	
private:
	System::Classes::TStream* FStream;
	int FStreamPos;
	System::Classes::TNotifyEvent FOnProgress;
	TZStreamRec FZStream;
	System::StaticArray<System::Byte, 65536> FBuffer;
	
protected:
	__fastcall TCustomZStream(System::Classes::TStream* stream);
	DYNAMIC void __fastcall DoProgress();
	__property System::Classes::TNotifyEvent OnProgress = {read=FOnProgress, write=FOnProgress};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TCustomZStream() { }
	
};


class PASCALIMPLEMENTATION TZCompressionStream : public TCustomZStream
{
	typedef TCustomZStream inherited;
	
private:
	float __fastcall GetCompressionRate();
	
public:
	__fastcall TZCompressionStream(System::Classes::TStream* dest, TZCompressionLevel compressionLevel);
	__fastcall virtual ~TZCompressionStream();
	virtual int __fastcall Read(void *buffer, int count)/* overload */;
	virtual int __fastcall Write(const void *buffer, int count)/* overload */;
	virtual int __fastcall Seek(int offset, System::Word origin)/* overload */;
	__property float CompressionRate = {read=GetCompressionRate};
	__property OnProgress;
	/* Hoisted overloads: */
	
public:
	inline int __fastcall  Read(System::DynamicArray<System::Byte> Buffer, int Offset, int Count){ return System::Classes::TStream::Read(Buffer, Offset, Count); }
	inline int __fastcall  Read(System::DynamicArray<System::Byte> &Buffer, int Count){ return System::Classes::TStream::Read(Buffer, Count); }
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Offset, int Count){ return System::Classes::TStream::Write(Buffer, Offset, Count); }
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Count){ return System::Classes::TStream::Write(Buffer, Count); }
	inline __int64 __fastcall  Seek(const __int64 Offset, System::Classes::TSeekOrigin Origin){ return System::Classes::TStream::Seek(Offset, Origin); }
	inline __int64 __fastcall  Seek _DEPRECATED_ATTRIBUTE0 (const __int64 Offset, System::Word Origin){ return System::Classes::TStream::Seek(Offset, Origin); }
	
};


class PASCALIMPLEMENTATION TZDecompressionStream : public TCustomZStream
{
	typedef TCustomZStream inherited;
	
public:
	__fastcall TZDecompressionStream(System::Classes::TStream* source);
	__fastcall virtual ~TZDecompressionStream();
	virtual int __fastcall Read(void *buffer, int count)/* overload */;
	virtual int __fastcall Write(const void *buffer, int count)/* overload */;
	virtual int __fastcall Seek(int offset, System::Word origin)/* overload */;
	__property OnProgress;
	/* Hoisted overloads: */
	
public:
	inline int __fastcall  Read(System::DynamicArray<System::Byte> Buffer, int Offset, int Count){ return System::Classes::TStream::Read(Buffer, Offset, Count); }
	inline int __fastcall  Read(System::DynamicArray<System::Byte> &Buffer, int Count){ return System::Classes::TStream::Read(Buffer, Count); }
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Offset, int Count){ return System::Classes::TStream::Write(Buffer, Offset, Count); }
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Count){ return System::Classes::TStream::Write(Buffer, Count); }
	inline __int64 __fastcall  Seek(const __int64 Offset, System::Classes::TSeekOrigin Origin){ return System::Classes::TStream::Seek(Offset, Origin); }
	inline __int64 __fastcall  Seek _DEPRECATED_ATTRIBUTE0 (const __int64 Offset, System::Word Origin){ return System::Classes::TStream::Seek(Offset, Origin); }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION EZLibError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EZLibError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EZLibError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EZLibError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EZLibError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EZLibError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EZLibError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EZLibError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EZLibError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EZLibError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EZLibError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EZLibError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EZLibError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EZLibError() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EZCompressionError : public EZLibError
{
	typedef EZLibError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EZCompressionError(const System::UnicodeString Msg) : EZLibError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EZCompressionError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EZLibError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EZCompressionError(NativeUInt Ident)/* overload */ : EZLibError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EZCompressionError(System::PResStringRec ResStringRec)/* overload */ : EZLibError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EZCompressionError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EZLibError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EZCompressionError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EZLibError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EZCompressionError(const System::UnicodeString Msg, int AHelpContext) : EZLibError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EZCompressionError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EZLibError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EZCompressionError(NativeUInt Ident, int AHelpContext)/* overload */ : EZLibError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EZCompressionError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EZLibError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EZCompressionError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EZLibError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EZCompressionError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EZLibError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EZCompressionError() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EZDecompressionError : public EZLibError
{
	typedef EZLibError inherited;
	
public:
	/* Exception.Create */ inline __fastcall EZDecompressionError(const System::UnicodeString Msg) : EZLibError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EZDecompressionError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : EZLibError(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EZDecompressionError(NativeUInt Ident)/* overload */ : EZLibError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EZDecompressionError(System::PResStringRec ResStringRec)/* overload */ : EZLibError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EZDecompressionError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : EZLibError(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EZDecompressionError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : EZLibError(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EZDecompressionError(const System::UnicodeString Msg, int AHelpContext) : EZLibError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EZDecompressionError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : EZLibError(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EZDecompressionError(NativeUInt Ident, int AHelpContext)/* overload */ : EZLibError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EZDecompressionError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EZLibError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EZDecompressionError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EZLibError(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EZDecompressionError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : EZLibError(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EZDecompressionError() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define ZLIB_VERSION L"1.2.1"
extern DELPHI_PACKAGE void __fastcall ZCompress(const void * inBuffer, int inSize, /* out */ void * &outBuffer, /* out */ int &outSize, TZCompressionLevel level = (TZCompressionLevel)(0x2));
extern DELPHI_PACKAGE void __fastcall ZDecompress(const void * inBuffer, int inSize, /* out */ void * &outBuffer, /* out */ int &outSize, int outEstimate = 0x0);
extern DELPHI_PACKAGE int __fastcall adler32(int adler, const char * buf, int len);
extern DELPHI_PACKAGE int __fastcall compressBound(int sourceLen);
extern DELPHI_PACKAGE int __fastcall crc32(int crc, const char * buf, int len);
extern DELPHI_PACKAGE int __fastcall deflateInit_(TZStreamRec &strm, int level, char * version, int recsize);
extern DELPHI_PACKAGE int __fastcall deflate(TZStreamRec &strm, int flush);
extern DELPHI_PACKAGE int __fastcall deflateEnd(TZStreamRec &strm);
extern DELPHI_PACKAGE int __fastcall inflateInit_(TZStreamRec &strm, char * version, int recsize);
extern DELPHI_PACKAGE int __fastcall inflate(TZStreamRec &strm, int flush);
extern DELPHI_PACKAGE int __fastcall inflateEnd(TZStreamRec &strm);
}	/* namespace Frxzlib */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXZLIB)
using namespace Frxzlib;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxzlibHPP
