// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBarcode2DBase.pas' rev: 33.00 (Windows)

#ifndef Frxbarcode2dbaseHPP
#define Frxbarcode2dbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <frxPrinter.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbarcode2dbase
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBarcode2DBase;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBarcode2DBase : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<System::Byte> _TfrxBarcode2DBase__1;
	
	
protected:
	_TfrxBarcode2DBase__1 FImage;
	int FHeight;
	int FWidth;
	int FPixelWidth;
	int FPixelHeight;
	bool FShowText;
	int FRotation;
	System::UnicodeString FText;
	System::Extended FZoom;
	bool FFontScaled;
	Vcl::Graphics::TFont* FFont;
	System::Uitypes::TColor FColor;
	System::Uitypes::TColor FColorBar;
	System::UnicodeString FErrorText;
	int FQuietZone;
	virtual void __fastcall SetShowText(bool v);
	virtual void __fastcall SetRotation(int v);
	virtual void __fastcall SetText(System::UnicodeString v);
	virtual void __fastcall SetZoom(System::Extended v);
	virtual void __fastcall SetFontScaled(bool v);
	virtual void __fastcall SetFont(Vcl::Graphics::TFont* v);
	virtual void __fastcall SetColor(System::Uitypes::TColor v);
	virtual void __fastcall SetColorBar(System::Uitypes::TColor v);
	virtual void __fastcall SetErrorText(System::UnicodeString v);
	virtual int __fastcall GetWidth();
	virtual int __fastcall GetHeight();
	
public:
	__fastcall virtual TfrxBarcode2DBase();
	__fastcall virtual ~TfrxBarcode2DBase();
	virtual void __fastcall Assign(TfrxBarcode2DBase* src);
	virtual int __fastcall GetFooterHeight();
	virtual void __fastcall Draw2DBarcode(Vcl::Graphics::TCanvas* &g, System::Extended scalex, System::Extended scaley, int x, int y);
	__property bool ShowText = {read=FShowText, write=SetShowText, nodefault};
	__property int Rotation = {read=FRotation, write=SetRotation, nodefault};
	__property System::UnicodeString Text = {read=FText, write=SetText};
	__property System::Extended Zoom = {read=FZoom, write=SetZoom};
	__property bool FontScaled = {read=FFontScaled, write=SetFontScaled, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, nodefault};
	__property System::Uitypes::TColor ColorBar = {read=FColorBar, write=SetColorBar, nodefault};
	__property System::UnicodeString ErrorText = {read=FErrorText, write=SetErrorText};
	__property int Width = {read=GetWidth, nodefault};
	__property int Height = {read=GetHeight, nodefault};
	__property int PixelWidth = {read=FPixelWidth, write=FPixelWidth, nodefault};
	__property int PixelHeight = {read=FPixelHeight, write=FPixelHeight, nodefault};
	__property int QuietZone = {read=FQuietZone, write=FQuietZone, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
#define cbDefaultText L"12345678"
}	/* namespace Frxbarcode2dbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBARCODE2DBASE)
using namespace Frxbarcode2dbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frxbarcode2dbaseHPP
