// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxVariables.pas' rev: 33.00 (Windows)

#ifndef FrxvariablesHPP
#define FrxvariablesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxXML.hpp>
#include <frxCollections.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxvariables
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxVariable;
class DELPHICLASS TfrxVariables;
class DELPHICLASS TfrxArray;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxVariable : public Frxcollections::TfrxCollectionItem
{
	typedef Frxcollections::TfrxCollectionItem inherited;
	
private:
	System::UnicodeString FName;
	System::Variant FValue;
	
protected:
	virtual System::UnicodeString __fastcall GetInheritedName();
	
public:
	__fastcall virtual TfrxVariable(System::Classes::TCollection* ACollection);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual bool __fastcall IsUniqueNameStored();
	
__published:
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property System::Variant Value = {read=FValue, write=FValue};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxVariable() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxVariables : public Frxcollections::TfrxCollection
{
	typedef Frxcollections::TfrxCollection inherited;
	
public:
	System::Variant operator[](System::UnicodeString Index) { return this->Variables[Index]; }
	
private:
	TfrxVariable* __fastcall GetItems(int Index);
	System::Variant __fastcall GetVariable(System::UnicodeString Index);
	void __fastcall SetVariable(System::UnicodeString Index, const System::Variant &Value);
	
public:
	__fastcall TfrxVariables();
	HIDESBASE TfrxVariable* __fastcall Add();
	HIDESBASE TfrxVariable* __fastcall Insert(int Index);
	int __fastcall IndexOf(const System::UnicodeString Name);
	void __fastcall AddVariable(const System::UnicodeString ACategory, const System::UnicodeString AName, const System::Variant &AValue);
	void __fastcall DeleteCategory(const System::UnicodeString Name);
	void __fastcall DeleteVariable(const System::UnicodeString Name);
	void __fastcall GetCategoriesList(System::Classes::TStrings* List, bool ClearList = true);
	void __fastcall GetVariablesList(const System::UnicodeString Category, System::Classes::TStrings* List);
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	void __fastcall LoadFromXMLItem(Frxxml::TfrxXMLItem* Item, bool OldXMLFormat = true);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	void __fastcall SaveToXMLItem(Frxxml::TfrxXMLItem* Item);
	__property TfrxVariable* Items[int Index] = {read=GetItems};
	__property System::Variant Variables[System::UnicodeString Index] = {read=GetVariable, write=SetVariable/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxVariables() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxArray : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	System::Variant operator[](System::Variant Index) { return this->Variables[Index]; }
	
private:
	TfrxVariable* __fastcall GetItems(int Index);
	System::Variant __fastcall GetVariable(const System::Variant &Index);
	void __fastcall SetVariable(const System::Variant &Index, const System::Variant &Value);
	
public:
	__fastcall TfrxArray();
	int __fastcall IndexOf(const System::Variant &Name);
	__property TfrxVariable* Items[int Index] = {read=GetItems};
	__property System::Variant Variables[System::Variant Index] = {read=GetVariable, write=SetVariable/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxArray() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxvariables */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXVARIABLES)
using namespace Frxvariables;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxvariablesHPP
