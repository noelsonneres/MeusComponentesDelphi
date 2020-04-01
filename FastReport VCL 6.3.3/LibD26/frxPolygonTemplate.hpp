// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPolygonTemplate.pas' rev: 33.00 (Windows)

#ifndef FrxpolygontemplateHPP
#define FrxpolygontemplateHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Contnrs.hpp>
#include <Vcl.Graphics.hpp>
#include <frxJSON.hpp>
#include <frxMapHelpers.hpp>
#include <frxAnaliticGeometry.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxpolygontemplate
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TPointIndexByName;
class DELPHICLASS TAbstractTemplateComponent;
class DELPHICLASS TTemplateComponentList;
class DELPHICLASS TfrxPolygonTemplate;
class DELPHICLASS TfrxPolygonTemplateList;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TPointIndexByName : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<System::UnicodeString> _TPointIndexByName__1;
	
	typedef System::DynamicArray<Vcl::Graphics::TBitmap*> _TPointIndexByName__2;
	
	
private:
	int __fastcall GetIndexByName(System::UnicodeString Name);
	Vcl::Graphics::TBitmap* __fastcall GetNameBitmap(int Index);
	
protected:
	_TPointIndexByName__1 FPointName;
	_TPointIndexByName__2 FNameBitmap;
	
public:
	__fastcall TPointIndexByName(System::TObject* JSON);
	__fastcall virtual ~TPointIndexByName();
	int __fastcall Count();
	__property int IndexByName[System::UnicodeString Name] = {read=GetIndexByName};
	__property Vcl::Graphics::TBitmap* NameBitmap[int Index] = {read=GetNameBitmap};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TAbstractTemplateComponent : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<int> _TAbstractTemplateComponent__1;
	
	
protected:
	_TAbstractTemplateComponent__1 FPointIndex;
	TPointIndexByName* FPointIndexByName;
	
public:
	__fastcall TAbstractTemplateComponent(Frxjson::TfrxJSON* JSON, TPointIndexByName* PointIndexByName);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, Frxanaliticgeometry::TPointArray Points) = 0 ;
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TAbstractTemplateComponent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TTemplateComponentList : public System::Contnrs::TObjectList
{
	typedef System::Contnrs::TObjectList inherited;
	
public:
	TAbstractTemplateComponent* operator[](int Index) { return this->Items[Index]; }
	
private:
	TAbstractTemplateComponent* __fastcall GetItems(int Index);
	void __fastcall SetItems(int Index, TAbstractTemplateComponent* const Value);
	
public:
	__fastcall TTemplateComponentList();
	__property TAbstractTemplateComponent* Items[int Index] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TList.Destroy */ inline __fastcall virtual ~TTemplateComponentList() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPolygonTemplate : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString FName;
	int FCount;
	
protected:
	TPointIndexByName* FPointIndexByName;
	TTemplateComponentList* FTemplateComponentList;
	
public:
	__fastcall TfrxPolygonTemplate(Frxjson::TfrxJSON* JSON);
	__fastcall virtual ~TfrxPolygonTemplate();
	void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, Frxanaliticgeometry::TPointArray Points, bool DrawNames = false);
	void __fastcall DrawWithNames(Vcl::Graphics::TCanvas* Canvas, Frxanaliticgeometry::TPointArray Points);
	void __fastcall LoadArray(Frxjson::TfrxJSON* JSON, System::UnicodeString nm);
	__property System::UnicodeString Name = {read=FName};
	__property int Count = {read=FCount, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPolygonTemplateList : public System::Contnrs::TObjectList
{
	typedef System::Contnrs::TObjectList inherited;
	
public:
	TfrxPolygonTemplate* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxPolygonTemplate* __fastcall GetTemplate(int Index);
	void __fastcall SetTemplate(int Index, TfrxPolygonTemplate* const Value);
	TfrxPolygonTemplate* __fastcall GetItemsByName(System::UnicodeString Name);
	
protected:
	int FVersion;
	
public:
	__fastcall TfrxPolygonTemplateList(System::Sysutils::TFileName FileName);
	__property TfrxPolygonTemplate* Items[int Index] = {read=GetTemplate, write=SetTemplate/*, default*/};
	__property TfrxPolygonTemplate* ItemsByName[System::UnicodeString Name] = {read=GetItemsByName};
public:
	/* TList.Destroy */ inline __fastcall virtual ~TfrxPolygonTemplateList() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxPolygonTemplateList* PolygonTemplateList;
}	/* namespace Frxpolygontemplate */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPOLYGONTEMPLATE)
using namespace Frxpolygontemplate;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxpolygontemplateHPP
