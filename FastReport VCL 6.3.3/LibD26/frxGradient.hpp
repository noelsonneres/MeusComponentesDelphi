// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGradient.pas' rev: 33.00 (Windows)

#ifndef FrxgradientHPP
#define FrxgradientHPP

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
#include <frxClass.hpp>
#include <System.Variants.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgradient
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGradientObject;
class DELPHICLASS TfrxGradientView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGradientObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxGradientObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxGradientObject() { }
	
};


class PASCALIMPLEMENTATION TfrxGradientView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	System::Uitypes::TColor FBeginColor;
	System::Uitypes::TColor FEndColor;
	Frxclass::TfrxGradientStyle FStyle;
	void __fastcall DrawGradient(int X, int Y, int X1, int Y1);
	HIDESBASE System::Uitypes::TColor __fastcall GetColor();
	HIDESBASE void __fastcall SetColor(const System::Uitypes::TColor Value);
	
public:
	__fastcall virtual TfrxGradientView(System::Classes::TComponent* AOwner);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property System::Uitypes::TColor BeginColor = {read=FBeginColor, write=FBeginColor, default=16777215};
	__property System::Uitypes::TColor EndColor = {read=FEndColor, write=FEndColor, default=8421504};
	__property Frxclass::TfrxGradientStyle Style = {read=FStyle, write=FStyle, nodefault};
	__property Frame;
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, nodefault};
public:
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxGradientView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxGradientView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxgradient */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGRADIENT)
using namespace Frxgradient;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgradientHPP
