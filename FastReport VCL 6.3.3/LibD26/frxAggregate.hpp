// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxAggregate.pas' rev: 33.00 (Windows)

#ifndef FrxaggregateHPP
#define FrxaggregateHPP

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
#include <Vcl.Dialogs.hpp>
#include <frxClass.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxaggregate
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxAggregateItem;
class DELPHICLASS TfrxAggregateList;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxAggregateFunction : unsigned char { agSum, agAvg, agMin, agMax, agCount };

class PASCALIMPLEMENTATION TfrxAggregateItem : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfrxAggregateFunction FAggregateFunction;
	Frxclass::TfrxDataBand* FBand;
	bool FCountInvisibleBands;
	bool FDontReset;
	System::UnicodeString FExpression;
	bool FIsPageFooter;
	System::Variant FItemsArray;
	int FItemsCount;
	System::Variant FItemsCountArray;
	System::Variant FItemsValue;
	bool FKeeping;
	int FLastCount;
	System::Variant FLastValue;
	int FSavedCount;
	System::Variant FSavedValue;
	System::UnicodeString FMemoName;
	System::UnicodeString FOriginalName;
	Frxclass::TfrxBand* FParentBand;
	Frxclass::TfrxReport* FReport;
	int FTempItemsCount;
	System::Variant FTempItemsValue;
	int FVColumn;
	
public:
	void __fastcall Calc();
	void __fastcall DeleteValue();
	void __fastcall SaveValue();
	void __fastcall RestoreValue();
	void __fastcall Reset();
	void __fastcall StartKeep();
	void __fastcall EndKeep();
	System::Variant __fastcall Value();
public:
	/* TObject.Create */ inline __fastcall TfrxAggregateItem() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxAggregateItem() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxAggregateList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxAggregateItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Classes::TList* FList;
	Frxclass::TfrxReport* FReport;
	TfrxAggregateItem* __fastcall GetItem(int Index);
	void __fastcall FindAggregates(Frxclass::TfrxCustomMemoView* Memo, Frxclass::TfrxDataBand* DataBand);
	void __fastcall ParseName(const System::UnicodeString ComplexName, TfrxAggregateFunction &Func, System::UnicodeString &Expr, Frxclass::TfrxDataBand* &Band, bool &CountInvisible, bool &DontReset);
	__property TfrxAggregateItem* Items[int Index] = {read=GetItem/*, default*/};
	
public:
	__fastcall TfrxAggregateList(Frxclass::TfrxReport* AReport);
	__fastcall virtual ~TfrxAggregateList();
	void __fastcall Clear();
	void __fastcall ClearValues();
	void __fastcall AddItems(Frxclass::TfrxReportPage* Page);
	void __fastcall AddValue(Frxclass::TfrxBand* Band, int VColumn = 0x0);
	void __fastcall DeleteValue(Frxclass::TfrxBand* Band);
	void __fastcall SaveValue(Frxclass::TfrxBand* Band);
	void __fastcall RestoreValue(Frxclass::TfrxBand* Band);
	void __fastcall EndKeep();
	void __fastcall Reset(Frxclass::TfrxBand* ParentBand);
	void __fastcall StartKeep();
	System::Variant __fastcall GetValue(Frxclass::TfrxBand* ParentBand, const System::UnicodeString ComplexName, int VColumn = 0x0)/* overload */;
	System::Variant __fastcall GetValue(Frxclass::TfrxBand* ParentBand, int VColumn, const System::UnicodeString Name, const System::UnicodeString Expression, Frxclass::TfrxBand* Band, int Flags)/* overload */;
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxaggregate */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXAGGREGATE)
using namespace Frxaggregate;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxaggregateHPP
