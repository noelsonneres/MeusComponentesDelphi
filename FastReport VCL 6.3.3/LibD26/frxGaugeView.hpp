// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGaugeView.pas' rev: 33.00 (Windows)

#ifndef FrxgaugeviewHPP
#define FrxgaugeviewHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <frxClass.hpp>
#include <frxGauge.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgaugeview
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGaugeObject;
class DELPHICLASS TfrxBaseGaugeView;
class DELPHICLASS TfrxGaugeView;
class DELPHICLASS TfrxIntervalGaugeView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGaugeObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxGaugeObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxGaugeObject() { }
	
};


class PASCALIMPLEMENTATION TfrxBaseGaugeView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	Frxgauge::TfrxBaseGauge* FBaseGauge;
	
protected:
	System::Types::TPoint __fastcall InnerPoint(int X, int Y);
	virtual void __fastcall CreateGauge() = 0 ;
	void __fastcall ContentChanged(System::TObject* Sender);
	
public:
	__fastcall virtual TfrxBaseGaugeView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxBaseGaugeView();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	void __fastcall UpdateInspector();
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, Frxclass::TfrxInteractiveEventsParams &EventParams);
	__property Frxgauge::TfrxBaseGauge* BaseGauge = {read=FBaseGauge};
	
__published:
	__property FillType = {default=0};
	__property Fill;
	__property Frame;
	__property Cursor = {default=0};
	__property TagStr = {default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxBaseGaugeView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxGaugeView : public TfrxBaseGaugeView
{
	typedef TfrxBaseGaugeView inherited;
	
private:
	Frxgauge::TfrxGauge* FGauge;
	System::UnicodeString FExpression;
	bool FMacroLoaded;
	void __fastcall SetGauge(Frxgauge::TfrxGauge* const Value);
	
protected:
	virtual void __fastcall CreateGauge();
	
public:
	virtual void __fastcall GetData();
	virtual void __fastcall SaveContentToDictionary(Frxclass::TfrxReport* aReport, Frxclass::TfrxPostProcessor* PostProcessor);
	virtual bool __fastcall LoadContentFromDictionary(Frxclass::TfrxReport* aReport, Frxclass::TfrxMacrosItem* aItem);
	virtual void __fastcall ProcessDictionary(Frxclass::TfrxMacrosItem* aItem, Frxclass::TfrxReport* aReport, Frxclass::TfrxPostProcessor* PostProcessor);
	
__published:
	__property System::UnicodeString Expression = {read=FExpression, write=FExpression};
	__property Frxgauge::TfrxGauge* Gauge = {read=FGauge, write=SetGauge};
	__property Processing;
public:
	/* TfrxBaseGaugeView.Create */ inline __fastcall virtual TfrxGaugeView(System::Classes::TComponent* AOwner) : TfrxBaseGaugeView(AOwner) { }
	/* TfrxBaseGaugeView.Destroy */ inline __fastcall virtual ~TfrxGaugeView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxGaugeView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBaseGaugeView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxIntervalGaugeView : public TfrxBaseGaugeView
{
	typedef TfrxBaseGaugeView inherited;
	
private:
	Frxgauge::TfrxIntervalGauge* FIntervalGauge;
	System::UnicodeString FStartExpression;
	System::UnicodeString FEndExpression;
	void __fastcall SetIntervalGauge(Frxgauge::TfrxIntervalGauge* const Value);
	
protected:
	virtual void __fastcall CreateGauge();
	
public:
	virtual void __fastcall GetData();
	
__published:
	__property System::UnicodeString StartExpression = {read=FStartExpression, write=FStartExpression};
	__property System::UnicodeString EndExpression = {read=FEndExpression, write=FEndExpression};
	__property Frxgauge::TfrxIntervalGauge* IntervalGauge = {read=FIntervalGauge, write=SetIntervalGauge};
public:
	/* TfrxBaseGaugeView.Create */ inline __fastcall virtual TfrxIntervalGaugeView(System::Classes::TComponent* AOwner) : TfrxBaseGaugeView(AOwner) { }
	/* TfrxBaseGaugeView.Destroy */ inline __fastcall virtual ~TfrxIntervalGaugeView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxIntervalGaugeView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBaseGaugeView(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxgaugeview */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGAUGEVIEW)
using namespace Frxgaugeview;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgaugeviewHPP
