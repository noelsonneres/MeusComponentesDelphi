// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGraphicControls.pas' rev: 33.00 (Windows)

#ifndef FrxgraphiccontrolsHPP
#define FrxgraphiccontrolsHPP

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
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgraphiccontrols
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxSwithcButton;
class DELPHICLASS TfrxSwitchButtonsPanel;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxSwithcButtonStyle : unsigned char { sbOn, sbOff };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSwithcButton : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool FSwitch;
	int FWidth;
	int FHeight;
	int FOriginWidth;
	int FOriginHeight;
	System::Uitypes::TColor FButtonColor;
	System::Uitypes::TColor FFrameColor;
	int FFrameWidth;
	System::Uitypes::TColor FFillActivateColor;
	System::Uitypes::TColor FFillDeactivateColor;
	Vcl::Graphics::TBitmap* FBitmap;
	Vcl::Graphics::TBitmap* FOnStyleBitmap;
	Vcl::Graphics::TBitmap* FOffStyleBitmap;
	System::Uitypes::TColor FBackColor;
	bool FNeedUpdate;
	int FTag;
	System::Uitypes::TColor FColorTag;
	void __fastcall SetOriginHeight(const int Value);
	void __fastcall SetSwitch(const bool Value);
	void __fastcall SetBackColor(const System::Uitypes::TColor Value);
	void __fastcall SetFillActivateColor(const System::Uitypes::TColor Value);
	void __fastcall SetFillDeactivateColor(const System::Uitypes::TColor Value);
	void __fastcall SetFrameColor(const System::Uitypes::TColor Value);
	
public:
	__fastcall TfrxSwithcButton()/* overload */;
	__fastcall TfrxSwithcButton(Vcl::Graphics::TBitmap* aOnStyleBitmap, Vcl::Graphics::TBitmap* aOffStyleBitmap)/* overload */;
	__fastcall virtual ~TfrxSwithcButton();
	void __fastcall Draw(Vcl::Graphics::TCanvas* aCanvas, int aLeft, int aTop);
	__property bool Switch = {read=FSwitch, write=SetSwitch, nodefault};
	__property System::Uitypes::TColor ButtonColor = {read=FButtonColor, write=FButtonColor, nodefault};
	__property System::Uitypes::TColor BackColor = {read=FBackColor, write=SetBackColor, nodefault};
	__property System::Uitypes::TColor FrameColor = {read=FFrameColor, write=SetFrameColor, nodefault};
	__property System::Uitypes::TColor FillActivateColor = {read=FFillActivateColor, write=SetFillActivateColor, nodefault};
	__property System::Uitypes::TColor FillDeactivateColor = {read=FFillDeactivateColor, write=SetFillDeactivateColor, nodefault};
	__property int Width = {read=FOriginWidth, nodefault};
	__property int Height = {read=FOriginHeight, write=SetOriginHeight, nodefault};
	__property int Tag = {read=FTag, write=FTag, nodefault};
	__property System::Uitypes::TColor ColorTag = {read=FColorTag, write=FColorTag, nodefault};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxSwitchButtonsPanel : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxSwithcButton* operator[](int Index) { return this->Button[Index]; }
	
private:
	System::Classes::TStringList* FButtons;
	Vcl::Graphics::TBitmap* FSwitchOnStyle;
	Vcl::Graphics::TBitmap* FSwitchOffStyle;
	bool FShowCaption;
	bool FShowColors;
	int FButtonOffsetY;
	int FButtonOffsetX;
	int FColorRectWidth;
	int FColorRectGap;
	System::Classes::TNotifyEvent FOnButtonClick;
	int FButtonsHeight;
	int FTextWidth;
	System::Uitypes::TColor FBackColor;
	Vcl::Graphics::TFont* FFont;
	TfrxSwithcButton* __fastcall GetButton(int Index);
	void __fastcall SetShowCaption(const bool Value);
	void __fastcall SetShowColors(const bool Value);
	
public:
	__fastcall TfrxSwitchButtonsPanel();
	__fastcall virtual ~TfrxSwitchButtonsPanel();
	void __fastcall Draw(Vcl::Graphics::TCanvas* aCanvas, int aLeft, int aTop);
	int __fastcall CalcHeight();
	int __fastcall CalcWidth();
	TfrxSwithcButton* __fastcall AddButton(System::UnicodeString sCaption);
	TfrxSwithcButton* __fastcall IsButtonClicked(int X, int Y);
	TfrxSwithcButton* __fastcall DoClick(int X, int Y);
	void __fastcall Clear();
	int __fastcall Count();
	void __fastcall SetButtonsHeight(int Height);
	__property bool ShowCaption = {read=FShowCaption, write=SetShowCaption, nodefault};
	__property bool ShowColors = {read=FShowColors, write=SetShowColors, nodefault};
	__property TfrxSwithcButton* Button[int Index] = {read=GetButton/*, default*/};
	__property System::Classes::TNotifyEvent OnButtonClick = {read=FOnButtonClick, write=FOnButtonClick};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxgraphiccontrols */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGRAPHICCONTROLS)
using namespace Frxgraphiccontrols;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgraphiccontrolsHPP
