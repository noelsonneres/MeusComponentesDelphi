// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGaugeDialogControl.pas' rev: 33.00 (Windows)

#ifndef FrxgaugedialogcontrolHPP
#define FrxgaugedialogcontrolHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <System.Types.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Messages.hpp>
#include <frxGaugePanel.hpp>
#include <frxGauge.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgaugedialogcontrol
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGaugeDialogControls;
class DELPHICLASS TfrxBaseGaugeControl;
class DELPHICLASS TfrxGaugeControl;
class DELPHICLASS TfrxIntervalGaugeControl;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGaugeDialogControls : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxGaugeDialogControls(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxGaugeDialogControls() { }
	
};


class PASCALIMPLEMENTATION TfrxBaseGaugeControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
protected:
	Frxgaugepanel::TfrxBaseGaugePanel* FBaseGauge;
	virtual void __fastcall CreateGauge() = 0 ;
	
public:
	__fastcall virtual TfrxBaseGaugeControl(System::Classes::TComponent* AOwner);
	
__published:
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxBaseGaugeControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxBaseGaugeControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxGaugeControl : public TfrxBaseGaugeControl
{
	typedef TfrxBaseGaugeControl inherited;
	
private:
	Frxgauge::TfrxGauge* __fastcall GetGauge();
	
protected:
	virtual void __fastcall CreateGauge();
	
__published:
	__property Frxgauge::TfrxGauge* Gauge = {read=GetGauge};
public:
	/* TfrxBaseGaugeControl.Create */ inline __fastcall virtual TfrxGaugeControl(System::Classes::TComponent* AOwner) : TfrxBaseGaugeControl(AOwner) { }
	
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxGaugeControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxGaugeControl(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBaseGaugeControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxIntervalGaugeControl : public TfrxBaseGaugeControl
{
	typedef TfrxBaseGaugeControl inherited;
	
private:
	Frxgauge::TfrxIntervalGauge* __fastcall GetGauge();
	
protected:
	virtual void __fastcall CreateGauge();
	
__published:
	__property Frxgauge::TfrxIntervalGauge* Gauge = {read=GetGauge};
public:
	/* TfrxBaseGaugeControl.Create */ inline __fastcall virtual TfrxIntervalGaugeControl(System::Classes::TComponent* AOwner) : TfrxBaseGaugeControl(AOwner) { }
	
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxIntervalGaugeControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxIntervalGaugeControl(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBaseGaugeControl(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxgaugedialogcontrol */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGAUGEDIALOGCONTROL)
using namespace Frxgaugedialogcontrol;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgaugedialogcontrolHPP
