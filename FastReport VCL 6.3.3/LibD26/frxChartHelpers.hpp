// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxChartHelpers.pas' rev: 33.00 (Windows)

#ifndef FrxcharthelpersHPP
#define FrxcharthelpersHPP

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
#include <Vcl.Menus.hpp>
#include <Vcl.Controls.hpp>
#include <frxChart.hpp>
#include <VCLTee.TeeProcs.hpp>
#include <VCLTee.TeEngine.hpp>
#include <VCLTee.Chart.hpp>
#include <VCLTee.Series.hpp>
#include <VCLTee.TeCanvas.hpp>
#include <VCLTee.GanttCh.hpp>
#include <VCLTee.TeeShape.hpp>
#include <VCLTee.BubbleCh.hpp>
#include <VCLTee.ArrowCha.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxcharthelpers
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxSeriesHelper;
class DELPHICLASS TfrxStdSeriesHelper;
class DELPHICLASS TfrxPieSeriesHelper;
class DELPHICLASS TfrxGanttSeriesHelper;
class DELPHICLASS TfrxArrowSeriesHelper;
class DELPHICLASS TfrxBubbleSeriesHelper;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSeriesHelper : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	virtual System::UnicodeString __fastcall GetParamNames() = 0 ;
	virtual void __fastcall AddValues(Vcltee::Teengine::TChartSeries* Series, const System::UnicodeString v1, const System::UnicodeString v2, const System::UnicodeString v3, const System::UnicodeString v4, const System::UnicodeString v5, const System::UnicodeString v6, Frxchart::TfrxSeriesXType XType) = 0 ;
public:
	/* TObject.Create */ inline __fastcall TfrxSeriesHelper() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxSeriesHelper() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxStdSeriesHelper : public TfrxSeriesHelper
{
	typedef TfrxSeriesHelper inherited;
	
public:
	virtual System::UnicodeString __fastcall GetParamNames();
	virtual void __fastcall AddValues(Vcltee::Teengine::TChartSeries* Series, const System::UnicodeString v1, const System::UnicodeString v2, const System::UnicodeString v3, const System::UnicodeString v4, const System::UnicodeString v5, const System::UnicodeString v6, Frxchart::TfrxSeriesXType XType);
public:
	/* TObject.Create */ inline __fastcall TfrxStdSeriesHelper() : TfrxSeriesHelper() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxStdSeriesHelper() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPieSeriesHelper : public TfrxSeriesHelper
{
	typedef TfrxSeriesHelper inherited;
	
public:
	virtual System::UnicodeString __fastcall GetParamNames();
	virtual void __fastcall AddValues(Vcltee::Teengine::TChartSeries* Series, const System::UnicodeString v1, const System::UnicodeString v2, const System::UnicodeString v3, const System::UnicodeString v4, const System::UnicodeString v5, const System::UnicodeString v6, Frxchart::TfrxSeriesXType XType);
public:
	/* TObject.Create */ inline __fastcall TfrxPieSeriesHelper() : TfrxSeriesHelper() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxPieSeriesHelper() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxGanttSeriesHelper : public TfrxSeriesHelper
{
	typedef TfrxSeriesHelper inherited;
	
public:
	virtual System::UnicodeString __fastcall GetParamNames();
	virtual void __fastcall AddValues(Vcltee::Teengine::TChartSeries* Series, const System::UnicodeString v1, const System::UnicodeString v2, const System::UnicodeString v3, const System::UnicodeString v4, const System::UnicodeString v5, const System::UnicodeString v6, Frxchart::TfrxSeriesXType XType);
public:
	/* TObject.Create */ inline __fastcall TfrxGanttSeriesHelper() : TfrxSeriesHelper() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxGanttSeriesHelper() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxArrowSeriesHelper : public TfrxSeriesHelper
{
	typedef TfrxSeriesHelper inherited;
	
public:
	virtual System::UnicodeString __fastcall GetParamNames();
	virtual void __fastcall AddValues(Vcltee::Teengine::TChartSeries* Series, const System::UnicodeString v1, const System::UnicodeString v2, const System::UnicodeString v3, const System::UnicodeString v4, const System::UnicodeString v5, const System::UnicodeString v6, Frxchart::TfrxSeriesXType XType);
public:
	/* TObject.Create */ inline __fastcall TfrxArrowSeriesHelper() : TfrxSeriesHelper() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxArrowSeriesHelper() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxBubbleSeriesHelper : public TfrxSeriesHelper
{
	typedef TfrxSeriesHelper inherited;
	
public:
	virtual System::UnicodeString __fastcall GetParamNames();
	virtual void __fastcall AddValues(Vcltee::Teengine::TChartSeries* Series, const System::UnicodeString v1, const System::UnicodeString v2, const System::UnicodeString v3, const System::UnicodeString v4, const System::UnicodeString v5, const System::UnicodeString v6, Frxchart::TfrxSeriesXType XType);
public:
	/* TObject.Create */ inline __fastcall TfrxBubbleSeriesHelper() : TfrxSeriesHelper() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxBubbleSeriesHelper() { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TfrxSeriesHelperClass;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 frxNumSeries = System::Int8(0xb);
extern DELPHI_PACKAGE System::StaticArray<Frxchart::TSeriesClass, 11> frxChartSeries;
extern DELPHI_PACKAGE System::StaticArray<TfrxSeriesHelperClass, 11> frxSeriesHelpers;
extern DELPHI_PACKAGE TfrxSeriesHelper* __fastcall frxFindSeriesHelper(Vcltee::Teengine::TChartSeries* Series);
}	/* namespace Frxcharthelpers */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCHARTHELPERS)
using namespace Frxcharthelpers;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxcharthelpersHPP
