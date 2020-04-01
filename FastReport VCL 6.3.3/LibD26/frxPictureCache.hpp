// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPictureCache.pas' rev: 33.00 (Windows)

#ifndef FrxpicturecacheHPP
#define FrxpicturecacheHPP

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
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxClass.hpp>
#include <frxXML.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxpicturecache
{
//-- forward type declarations -----------------------------------------------
struct TfrxCacheItem;
class DELPHICLASS TfrxCacheList;
class DELPHICLASS TfrxFileStream;
class DELPHICLASS TfrxMemoryStream;
class DELPHICLASS TfrxPictureCache;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD TfrxCacheItem
{
public:
	int Segment;
	int Offset;
};
#pragma pack(pop)


typedef TfrxCacheItem *PfrxCacheItem;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCacheList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	PfrxCacheItem operator[](int Index) { return this->Items[Index]; }
	
private:
	PfrxCacheItem __fastcall Get(int Index);
	
protected:
	System::Classes::TList* FItems;
	void __fastcall Clear();
	
public:
	__fastcall TfrxCacheList();
	__fastcall virtual ~TfrxCacheList();
	PfrxCacheItem __fastcall Add();
	int __fastcall Count();
	__property PfrxCacheItem Items[int Index] = {read=Get/*, default*/};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFileStream : public System::Classes::TFileStream
{
	typedef System::Classes::TFileStream inherited;
	
private:
	unsigned FSz;
	
public:
	virtual int __fastcall Seek(int Offset, System::Word Origin)/* overload */;
	virtual __int64 __fastcall Seek(const __int64 Offset, System::Classes::TSeekOrigin Origin)/* overload */;
public:
	/* TFileStream.Create */ inline __fastcall TfrxFileStream(const System::UnicodeString AFileName, System::Word Mode)/* overload */ : System::Classes::TFileStream(AFileName, Mode) { }
	/* TFileStream.Create */ inline __fastcall TfrxFileStream(const System::UnicodeString AFileName, System::Word Mode, unsigned Rights)/* overload */ : System::Classes::TFileStream(AFileName, Mode, Rights) { }
	/* TFileStream.Destroy */ inline __fastcall virtual ~TfrxFileStream() { }
	
	/* Hoisted overloads: */
	
public:
	inline __int64 __fastcall  Seek _DEPRECATED_ATTRIBUTE0 (const __int64 Offset, System::Word Origin){ return System::Classes::TStream::Seek(Offset, Origin); }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxMemoryStream : public System::Classes::TMemoryStream
{
	typedef System::Classes::TMemoryStream inherited;
	
private:
	unsigned FSz;
	
public:
	virtual int __fastcall Seek(int Offset, System::Word Origin)/* overload */;
	virtual __int64 __fastcall Seek(const __int64 Offset, System::Classes::TSeekOrigin Origin)/* overload */;
public:
	/* TMemoryStream.Destroy */ inline __fastcall virtual ~TfrxMemoryStream() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxMemoryStream() : System::Classes::TMemoryStream() { }
	
	/* Hoisted overloads: */
	
public:
	inline __int64 __fastcall  Seek _DEPRECATED_ATTRIBUTE0 (const __int64 Offset, System::Word Origin){ return System::Classes::TStream::Seek(Offset, Origin); }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPictureCache : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfrxCacheList* FItems;
	System::Classes::TList* FCacheStreamList;
	System::Classes::TStringList* FTempFile;
	System::UnicodeString FTempDir;
	bool FUseFileCache;
	void __fastcall Add();
	void __fastcall SetTempDir(const System::UnicodeString Value);
	void __fastcall SetUseFileCache(const bool Value);
	
public:
	__fastcall TfrxPictureCache();
	__fastcall virtual ~TfrxPictureCache();
	void __fastcall Clear();
	void __fastcall AddPicture(Frxclass::TfrxPictureView* Picture)/* overload */;
	void __fastcall AddPicture(Vcl::Graphics::TGraphic* aGraphic, int &ImageIndex)/* overload */;
	void __fastcall GetPicture(Frxclass::TfrxPictureView* Picture)/* overload */;
	void __fastcall GetPicture(Vcl::Graphics::TGraphic* aGraphic, int ImageIndex)/* overload */;
	void __fastcall SaveToXML(Frxxml::TfrxXMLItem* Item);
	void __fastcall LoadFromXML(Frxxml::TfrxXMLItem* Item);
	void __fastcall AddSegment();
	__property bool UseFileCache = {read=FUseFileCache, write=SetUseFileCache, nodefault};
	__property System::UnicodeString TempDir = {read=FTempDir, write=SetTempDir};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxpicturecache */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPICTURECACHE)
using namespace Frxpicturecache;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxpicturecacheHPP
