// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxERSIShapeDBFImport.pas' rev: 33.00 (Windows)

#ifndef FrxersishapedbfimportHPP
#define FrxersishapedbfimportHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <System.AnsiStrings.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxersishapedbfimport
{
//-- forward type declarations -----------------------------------------------
struct TERSIDBFFileHeader;
struct TERSIDBFFieldDescriptor;
class DELPHICLASS TERSIDBFFileColumn;
class DELPHICLASS TERSIDBFFile;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD TERSIDBFFileHeader
{
public:
	System::Byte Signature;
	System::Byte YY;
	System::Byte MM;
	System::Byte DD;
	unsigned NumberOfRecords;
	System::Word LengthOfHeaderStructure;
	System::Word LengthOfEachRecord;
	System::Word Reserved0;
	System::Byte IncompleteTransaction;
	System::Byte EncryptionFlag;
	unsigned FreeRecordThread;
	System::StaticArray<System::Byte, 8> ReservedForMultiUser;
	System::Byte MDXFlag;
	System::Byte LanguageDriver;
	System::Word Reserved1;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TERSIDBFFieldDescriptor
{
public:
	System::StaticArray<char, 11> FieldName;
	char FieldType;
	unsigned Reserved0;
	System::Byte FieldLength;
	System::Byte DecimalCount;
	System::StaticArray<System::Byte, 13> Reserved1;
	System::Byte IndexFieldFlag;
};
#pragma pack(pop)


enum DECLSPEC_DENUM TDBFFieldType : unsigned char { dfUnhandled, dfChar, dfDate, dfNumeric, dfLogical };

typedef System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)> TAnsiCharSet;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TERSIDBFFileColumn : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<System::AnsiString> _TERSIDBFFileColumn__1;
	
	typedef System::DynamicArray<char> _TERSIDBFFileColumn__2;
	
	
private:
	System::AnsiString FFieldName;
	TDBFFieldType FFieldType;
	System::Byte FFieldLength;
	_TERSIDBFFileColumn__1 FData;
	System::AnsiString __fastcall GetData(int iRecord);
	
protected:
	_TERSIDBFFileColumn__2 FBuffer;
	System::AnsiString __fastcall BufferToAnsiString(const TAnsiCharSet &TrimLeft, const TAnsiCharSet &TrimRight);
	
public:
	__fastcall TERSIDBFFileColumn(System::Classes::TStream* Stream, unsigned NumberOfRecords);
	void __fastcall Read(System::Classes::TStream* Stream, int CurrentRecord);
	__property System::AnsiString FieldName = {read=FFieldName};
	__property TDBFFieldType FieldType = {read=FFieldType, nodefault};
	__property System::Byte FieldLength = {read=FFieldLength, nodefault};
	__property System::AnsiString Data[int iRecord] = {read=GetData};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIDBFFileColumn() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TERSIDBFFile : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<TERSIDBFFileColumn*> _TERSIDBFFile__1;
	
	
private:
	int __fastcall GetCodePage();
	System::AnsiString __fastcall GetLegend(System::AnsiString FieldName, int iRecord);
	System::AnsiString __fastcall GetLegendByColumn(int iColumn, int iRecord);
	
protected:
	TERSIDBFFileHeader FDBFFileHeader;
	_TERSIDBFFile__1 FColumns;
	System::UnicodeString FCPG;
	void __fastcall ReadFromStream(System::Classes::TStream* Stream, int RecordCount);
	
public:
	__fastcall TERSIDBFFile(const System::UnicodeString FileName, int RecordCount);
	__fastcall virtual ~TERSIDBFFile();
	void __fastcall GetColumnList(System::Classes::TStrings* List);
	bool __fastcall IsUTF8();
	__property int CodePage = {read=GetCodePage, nodefault};
	__property System::AnsiString Legend[System::AnsiString FieldName][int iRecord] = {read=GetLegend};
	__property System::AnsiString LegendByColumn[int iColumn][int iRecord] = {read=GetLegendByColumn};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxersishapedbfimport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXERSISHAPEDBFIMPORT)
using namespace Frxersishapedbfimport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxersishapedbfimportHPP
