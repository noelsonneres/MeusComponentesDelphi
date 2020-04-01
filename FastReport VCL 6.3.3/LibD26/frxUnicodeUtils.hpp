// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxUnicodeUtils.pas' rev: 33.00 (Windows)

#ifndef FrxunicodeutilsHPP
#define FrxunicodeutilsHPP

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
#include <System.WideStrings.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxunicodeutils
{
//-- forward type declarations -----------------------------------------------
struct TWString;
class DELPHICLASS TfrxWideStrings;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TWString
{
public:
	System::WideString WString;
	System::TObject* Obj;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxWideStrings : public System::Widestrings::TWideStrings
{
	typedef System::Widestrings::TWideStrings inherited;
	
public:
	System::WideString operator[](int Index) { return this->Strings[Index]; }
	
private:
	System::Classes::TList* FWideStringList;
	HIDESBASE void __fastcall ReadData(System::Classes::TReader* Reader);
	void __fastcall ReadDataWOld(System::Classes::TReader* Reader);
	void __fastcall ReadDataW(System::Classes::TReader* Reader);
	void __fastcall WriteDataW(System::Classes::TWriter* Writer);
	
protected:
	virtual System::WideString __fastcall Get(int Index);
	virtual void __fastcall Put(int Index, const System::WideString S);
	virtual System::TObject* __fastcall GetObject(int Index);
	virtual void __fastcall PutObject(int Index, System::TObject* Value);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual System::WideString __fastcall GetTextStr();
	virtual void __fastcall SetTextStr(const System::WideString Value);
	virtual int __fastcall GetCount();
	
public:
	__fastcall TfrxWideStrings();
	__fastcall virtual ~TfrxWideStrings();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall Clear();
	virtual void __fastcall Delete(int Index);
	virtual int __fastcall Add(const System::WideString S);
	virtual void __fastcall AddStrings(System::Widestrings::TWideStrings* Strings)/* overload */;
	virtual int __fastcall AddObject(const System::WideString S, System::TObject* AObject);
	virtual int __fastcall IndexOf(const System::WideString S);
	virtual void __fastcall Insert(int Index, const System::WideString S);
	virtual void __fastcall LoadFromFile(const System::WideString FileName)/* overload */;
	virtual void __fastcall LoadFromStream(System::Classes::TStream* Stream)/* overload */;
	void __fastcall LoadFromWStream(System::Classes::TStream* Stream);
	virtual void __fastcall SaveToFile(const System::WideString FileName)/* overload */;
	virtual void __fastcall SaveToStream(System::Classes::TStream* Stream)/* overload */;
	__property System::TObject* Objects[int Index] = {read=GetObject, write=PutObject};
	__property System::WideString Strings[int Index] = {read=Get, write=Put/*, default*/};
	__property System::WideString Text = {read=GetTextStr, write=SetTextStr};
	/* Hoisted overloads: */
	
public:
	inline void __fastcall  AddStrings(System::Classes::TStrings* Strings){ System::Widestrings::TWideStrings::AddStrings(Strings); }
	inline void __fastcall  LoadFromFile(const System::WideString FileName, System::Sysutils::TEncoding* Encoding){ System::Widestrings::TWideStrings::LoadFromFile(FileName, Encoding); }
	inline void __fastcall  LoadFromStream(System::Classes::TStream* Stream, System::Sysutils::TEncoding* Encoding){ System::Widestrings::TWideStrings::LoadFromStream(Stream, Encoding); }
	inline void __fastcall  SaveToFile(const System::WideString FileName, System::Sysutils::TEncoding* Encoding){ System::Widestrings::TWideStrings::SaveToFile(FileName, Encoding); }
	inline void __fastcall  SaveToStream(System::Classes::TStream* Stream, System::Sysutils::TEncoding* Encoding){ System::Widestrings::TWideStrings::SaveToStream(Stream, Encoding); }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::AnsiString __fastcall OemToStr(const System::AnsiString AnsiStr);
extern DELPHI_PACKAGE unsigned __fastcall CharSetToCodePage(unsigned ciCharset);
extern DELPHI_PACKAGE System::WideString __fastcall AnsiToUnicode(const System::AnsiString s, unsigned Charset, int CodePage = 0x0);
extern DELPHI_PACKAGE System::AnsiString __fastcall _UnicodeToAnsi(const System::WideString WS, unsigned Charset, int CodePage = 0x0);
extern DELPHI_PACKAGE unsigned __fastcall GetLocalByCharSet(unsigned Charset);
}	/* namespace Frxunicodeutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXUNICODEUTILS)
using namespace Frxunicodeutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxunicodeutilsHPP
