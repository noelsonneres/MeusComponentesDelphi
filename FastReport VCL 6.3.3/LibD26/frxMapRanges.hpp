// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapRanges.pas' rev: 33.00 (Windows)

#ifndef FrxmaprangesHPP
#define FrxmaprangesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <frxMapHelpers.hpp>
#include <frxAnaliticGeometry.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmapranges
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TMapRangeItem;
class DELPHICLASS TMapRangeCollection;
class DELPHICLASS TMapScale;
class DELPHICLASS TMapRanges;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TMapRangeItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	bool FAutoStart;
	System::Extended FStartValue;
	bool FAutoEnd;
	System::Extended FEndValue;
	void __fastcall SetStartValue(const System::Extended Value);
	void __fastcall SetEndValue(const System::Extended Value);
	void __fastcall SetStartValueByForce(const System::Extended Value);
	void __fastcall SetEndValueByForce(const System::Extended Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	bool __fastcall IsInside(System::Extended Value);
	
public:
	__fastcall virtual TMapRangeItem(System::Classes::TCollection* Collection);
	virtual void __fastcall Read(System::Classes::TReader* Reader);
	virtual void __fastcall Write(System::Classes::TWriter* Writer);
	virtual System::UnicodeString __fastcall AsString(System::UnicodeString FValueFormat);
	
__published:
	__property bool AutoStart = {read=FAutoStart, write=FAutoStart, nodefault};
	__property System::Extended StartValue = {read=FStartValue, write=SetStartValue};
	__property System::Extended StartValueByForce = {read=FStartValue, write=SetStartValueByForce};
	__property bool AutoEnd = {read=FAutoEnd, write=FAutoEnd, nodefault};
	__property System::Extended EndValue = {read=FEndValue, write=SetEndValue};
	__property System::Extended EndValueByForce = {read=FEndValue, write=SetEndValueByForce};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TMapRangeItem() { }
	
};


enum DECLSPEC_DENUM TRangeFactor : unsigned char { rfValue, rfPercentile, rfCluster, rfAutoCluster };

class PASCALIMPLEMENTATION TMapRangeCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TMapRangeItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Extended FMinValue;
	System::Extended FMaxValue;
	
protected:
	Frxanaliticgeometry::TDoubleArray FValues;
	TRangeFactor FRangeFactor;
	HIDESBASE TMapRangeItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TMapRangeItem* const Value);
	System::Extended __fastcall Part(System::Extended Value);
	Frxanaliticgeometry::TDoubleArray __fastcall Ranges(const Frxanaliticgeometry::TDoubleArray Values, TRangeFactor RangeFactor);
	Frxanaliticgeometry::TDoubleArray __fastcall RangesByValue(const Frxanaliticgeometry::TDoubleArray Values);
	Frxanaliticgeometry::TDoubleArray __fastcall RangesByCLuster(const Frxanaliticgeometry::TDoubleArray Values);
	Frxanaliticgeometry::TDoubleArray __fastcall RangesByAutoCLuster(const Frxanaliticgeometry::TDoubleArray Values);
	Frxanaliticgeometry::TDoubleArray __fastcall RangesByPercentile(const Frxanaliticgeometry::TDoubleArray Values);
	double __fastcall MedianValue();
	
public:
	void __fastcall ReadDFM(System::Classes::TStream* Stream);
	void __fastcall WriteDFM(System::Classes::TStream* Stream);
	virtual void __fastcall Read(System::Classes::TReader* Reader);
	virtual void __fastcall Write(System::Classes::TWriter* Writer);
	void __fastcall FillRangeValues(const Frxanaliticgeometry::TDoubleArray Values, TRangeFactor RangeFactor);
	void __fastcall Swap(int Index1, int Index2);
	__property TMapRangeItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Create */ inline __fastcall TMapRangeCollection(System::Classes::TCollectionItemClass ItemClass) : System::Classes::TCollection(ItemClass) { }
	/* TCollection.Destroy */ inline __fastcall virtual ~TMapRangeCollection() { }
	
};


enum DECLSPEC_DENUM TScaleDock : unsigned char { sdTopLeft, sdTopCenter, sdTopRight, sdMiddleLeft, sdMiddleRight, sdBottomLeft, sdBottomCenter, sdBottomRight, sdMiddleCenter };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TMapScale : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FVisible;
	System::Uitypes::TColor FBorderColor;
	int FBorderWidth;
	TScaleDock FDock;
	System::Uitypes::TColor FFillColor;
	Vcl::Graphics::TFont* FFont;
	Vcl::Graphics::TFont* FTitleFont;
	System::UnicodeString FTitleText;
	System::UnicodeString FValueFormat;
	
public:
	__fastcall TMapScale();
	System::Types::TPoint __fastcall LeftTopPoint(const System::Types::TRect &ConstrivtedParentRect);
	__fastcall virtual ~TMapScale();
	
__published:
	__property bool Visible = {read=FVisible, write=FVisible, nodefault};
	__property System::Uitypes::TColor BorderColor = {read=FBorderColor, write=FBorderColor, nodefault};
	__property int BorderWidth = {read=FBorderWidth, write=FBorderWidth, nodefault};
	__property TScaleDock Dock = {read=FDock, write=FDock, nodefault};
	__property System::Uitypes::TColor FillColor = {read=FFillColor, write=FFillColor, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=FFont};
	__property Vcl::Graphics::TFont* TitleFont = {read=FTitleFont};
	__property System::UnicodeString TitleText = {read=FTitleText, write=FTitleText};
	__property System::UnicodeString ValueFormat = {read=FValueFormat, write=FValueFormat};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TMapRanges : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FVisible;
	int __fastcall GetRangeCount();
	void __fastcall SetRangeCount(const int Value);
	int __fastcall GetTitleHeight();
	int __fastcall GetValuesHeight();
	int __fastcall GetWidth();
	int __fastcall GetHeight();
	
protected:
	TRangeFactor FRangeFactor;
	TMapRangeCollection* FMapRangeCollection;
	TMapScale* FMapScale;
	virtual int __fastcall GetSpaceWidth();
	virtual int __fastcall GetStepWidth();
	virtual int __fastcall GetContentHeight();
	virtual void __fastcall DrawContent(Vcl::Graphics::TCanvas* Canvas) = 0 ;
	void __fastcall DrawValues(Vcl::Graphics::TCanvas* Canvas);
	int __fastcall CalcTextHeight(Vcl::Graphics::TFont* Font, System::UnicodeString Text);
	__property int StepWidth = {read=GetStepWidth, nodefault};
	__property int SpaceWidth = {read=GetSpaceWidth, nodefault};
	__property int ContentHeight = {read=GetContentHeight, nodefault};
	__property int TitleHeight = {read=GetTitleHeight, nodefault};
	__property int ValuesHeight = {read=GetValuesHeight, nodefault};
	
public:
	__fastcall TMapRanges(TMapScale* MapScale);
	__fastcall virtual ~TMapRanges();
	Vcl::Graphics::TGraphic* __fastcall GetGraphic();
	void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas);
	__property TMapScale* MapScale = {read=FMapScale};
	__property int Width = {read=GetWidth, nodefault};
	__property int Height = {read=GetHeight, nodefault};
	
__published:
	__property TRangeFactor RangeFactor = {read=FRangeFactor, write=FRangeFactor, nodefault};
	__property int RangeCount = {read=GetRangeCount, write=SetRangeCount, nodefault};
	__property bool Visible = {read=FVisible, write=FVisible, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall RangeFactorGetList(System::Classes::TStrings* List);
extern DELPHI_PACKAGE bool __fastcall IsValidFloat(bool NeedTest, System::UnicodeString stFloat, bool Quiet = false);
}	/* namespace Frxmapranges */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPRANGES)
using namespace Frxmapranges;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmaprangesHPP
