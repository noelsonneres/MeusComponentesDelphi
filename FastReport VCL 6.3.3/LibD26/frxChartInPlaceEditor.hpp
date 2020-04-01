// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxChartInPlaceEditor.pas' rev: 33.00 (Windows)

#ifndef FrxchartinplaceeditorHPP
#define FrxchartinplaceeditorHPP

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
#include <Vcl.Controls.hpp>
#include <frxClass.hpp>
#include <frxChart.hpp>
#include <frxInPlaceEditors.hpp>
#include <VCLTee.TeeProcs.hpp>
#include <VCLTee.TeEngine.hpp>
#include <VCLTee.Chart.hpp>
#include <VCLTee.Series.hpp>
#include <VCLTee.TeCanvas.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxchartinplaceeditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxInPlaceChartEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxInPlaceChartEditor : public Frxinplaceeditors::TfrxInPlaceBasePanelEditor
{
	typedef Frxinplaceeditors::TfrxInPlaceBasePanelEditor inherited;
	
protected:
	bool FDrawButton;
	bool F3DMode;
	virtual bool __fastcall GetItem(int Index);
	virtual void __fastcall SetItem(int Index, const bool Value);
	virtual int __fastcall Count();
	virtual System::UnicodeString __fastcall GetName(int Index);
	virtual System::Uitypes::TColor __fastcall GetColor(int Index);
	
public:
	virtual bool __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DrawCustomEditor(Vcl::Graphics::TCanvas* aCanvas, const System::Types::TRect &aRect);
	virtual void __fastcall InitializeUI(Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall FinalizeUI(Frxclass::TfrxInteractiveEventsParams &EventParams);
public:
	/* TfrxInPlaceBasePanelEditor.Destroy */ inline __fastcall virtual ~TfrxInPlaceChartEditor() { }
	
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxInPlaceChartEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : Frxinplaceeditors::TfrxInPlaceBasePanelEditor(aClassRef, aOwner) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxchartinplaceeditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCHARTINPLACEEDITOR)
using namespace Frxchartinplaceeditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxchartinplaceeditorHPP
