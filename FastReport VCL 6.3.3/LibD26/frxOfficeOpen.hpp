// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxOfficeOpen.pas' rev: 33.00 (Windows)

#ifndef FrxofficeopenHPP
#define FrxofficeopenHPP

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
#include <Vcl.Graphics.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxofficeopen
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxStrList;
class DELPHICLASS TfrxWriter;
class DELPHICLASS TfrxFileWriter;
struct TfrxMap;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxStrList : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
public:
	virtual int __fastcall AddObject(const System::UnicodeString s, System::TObject* Obj);
public:
	/* TStringList.Create */ inline __fastcall TfrxStrList()/* overload */ : System::Classes::TStringList() { }
	/* TStringList.Create */ inline __fastcall TfrxStrList(bool OwnsObjects)/* overload */ : System::Classes::TStringList(OwnsObjects) { }
	/* TStringList.Create */ inline __fastcall TfrxStrList(System::WideChar QuoteChar, System::WideChar Delimiter)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter) { }
	/* TStringList.Create */ inline __fastcall TfrxStrList(System::WideChar QuoteChar, System::WideChar Delimiter, System::Classes::TStringsOptions Options)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter, Options) { }
	/* TStringList.Create */ inline __fastcall TfrxStrList(System::Types::TDuplicates Duplicates, bool Sorted, bool CaseSensitive)/* overload */ : System::Classes::TStringList(Duplicates, Sorted, CaseSensitive) { }
	/* TStringList.Destroy */ inline __fastcall virtual ~TfrxStrList() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxWriter : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TStream* FStream;
	bool FOwn;
	
public:
	__fastcall TfrxWriter(System::Classes::TStream* Stream, bool Own);
	__fastcall virtual ~TfrxWriter();
	void __fastcall Write(System::UnicodeString s, bool UCS = false)/* overload */;
	void __fastcall Write(const System::UnicodeString *a, const int a_High, bool UCS = false)/* overload */;
	void __fastcall Write(const System::UnicodeString Section, System::Classes::TStrings* StrList)/* overload */;
	void __fastcall Write(const System::UnicodeString Fmt, const System::TVarRec *f, const int f_High)/* overload */;
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFileWriter : public TfrxWriter
{
	typedef TfrxWriter inherited;
	
public:
	__fastcall TfrxFileWriter(System::UnicodeString FileName)/* overload */;
public:
	/* TfrxWriter.Destroy */ inline __fastcall virtual ~TfrxFileWriter() { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TfrxMap
{
public:
	int FirstRow;
	int LastRow;
	Frxclass::TfrxRect Margins;
	int PaperSize;
	int PageOrientation;
	int Index;
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Exchange(int &a, int &b);
extern DELPHI_PACKAGE System::WideString __fastcall CleanTrash(const System::WideString s);
extern DELPHI_PACKAGE System::Uitypes::TColor __fastcall RGBSwap(System::Uitypes::TColor c);
extern DELPHI_PACKAGE int __fastcall Distance(int c1, int c2);
extern DELPHI_PACKAGE System::WideString __fastcall Escape(System::WideString s);
extern DELPHI_PACKAGE void __fastcall CreateDirs(Frxclass::TfrxCustomIOTransport* aSaveFilter, const System::UnicodeString *SubDirs, const int SubDirs_High);
extern DELPHI_PACKAGE void __fastcall WriteStr(System::Classes::TStream* Stream, const System::UnicodeString s, bool UCS = false);
extern DELPHI_PACKAGE void __fastcall WriteStrList(System::Classes::TStream* Stream, const System::UnicodeString Section, System::Classes::TStrings* StrList);
extern DELPHI_PACKAGE System::TDateTime __fastcall DateTimeToUTC(System::TDateTime DateTime);
}	/* namespace Frxofficeopen */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXOFFICEOPEN)
using namespace Frxofficeopen;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxofficeopenHPP
