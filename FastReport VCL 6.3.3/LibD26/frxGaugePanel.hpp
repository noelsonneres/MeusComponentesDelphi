// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGaugePanel.pas' rev: 33.00 (Windows)

#ifndef FrxgaugepanelHPP
#define FrxgaugepanelHPP

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
#include <frxGauge.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgaugepanel
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBaseGaugePanel;
class DELPHICLASS TfrxGaugePanel;
class DELPHICLASS TfrxIntervalGaugePanel;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBaseGaugePanel : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
protected:
	Frxgauge::TfrxBaseGauge* FBaseGauge;
	virtual void __fastcall CreateGauge() = 0 ;
	virtual void __fastcall Paint();
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	
public:
	__fastcall virtual TfrxBaseGaugePanel(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxBaseGaugePanel();
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxBaseGaugePanel(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxGaugePanel : public TfrxBaseGaugePanel
{
	typedef TfrxBaseGaugePanel inherited;
	
private:
	Frxgauge::TfrxGauge* FGauge;
	void __fastcall SetGauge(Frxgauge::TfrxGauge* const Value);
	
protected:
	virtual void __fastcall CreateGauge();
	
__published:
	__property Frxgauge::TfrxGauge* Gauge = {read=FGauge, write=SetGauge};
public:
	/* TfrxBaseGaugePanel.Create */ inline __fastcall virtual TfrxGaugePanel(System::Classes::TComponent* AOwner) : TfrxBaseGaugePanel(AOwner) { }
	/* TfrxBaseGaugePanel.Destroy */ inline __fastcall virtual ~TfrxGaugePanel() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxGaugePanel(HWND ParentWindow) : TfrxBaseGaugePanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxIntervalGaugePanel : public TfrxBaseGaugePanel
{
	typedef TfrxBaseGaugePanel inherited;
	
private:
	Frxgauge::TfrxIntervalGauge* FIntervalGauge;
	void __fastcall SetGauge(Frxgauge::TfrxIntervalGauge* const Value);
	
protected:
	virtual void __fastcall CreateGauge();
	
__published:
	__property Frxgauge::TfrxIntervalGauge* Gauge = {read=FIntervalGauge, write=SetGauge};
public:
	/* TfrxBaseGaugePanel.Create */ inline __fastcall virtual TfrxIntervalGaugePanel(System::Classes::TComponent* AOwner) : TfrxBaseGaugePanel(AOwner) { }
	/* TfrxBaseGaugePanel.Destroy */ inline __fastcall virtual ~TfrxIntervalGaugePanel() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxIntervalGaugePanel(HWND ParentWindow) : TfrxBaseGaugePanel(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxgaugepanel */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGAUGEPANEL)
using namespace Frxgaugepanel;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgaugepanelHPP
