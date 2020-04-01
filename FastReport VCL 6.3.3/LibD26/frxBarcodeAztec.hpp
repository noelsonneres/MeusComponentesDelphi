// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBarcodeAztec.pas' rev: 33.00 (Windows)

#ifndef FrxbarcodeaztecHPP
#define FrxbarcodeaztecHPP

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
#include <System.Types.hpp>
#include <System.StrUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxBarcode2DBase.hpp>
#include <frxDelphiZXIngAztecCode.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbarcodeaztec
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBarcodeAztec;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBarcodeAztec : public Frxbarcode2dbase::TfrxBarcode2DBase
{
	typedef Frxbarcode2dbase::TfrxBarcode2DBase inherited;
	
private:
	int __fastcall GetPixelSize();
	void __fastcall SetPixelSize(const int Value);
	int __fastcall GetMinECCPercent();
	void __fastcall SetMinECCPercent(const int Value);
	
protected:
	Frxdelphizxingazteccode::TAztecEncoder* FAztecEncoder;
	void __fastcall Generate();
	virtual void __fastcall SetText(System::UnicodeString v);
	
public:
	__fastcall virtual TfrxBarcodeAztec();
	__fastcall virtual ~TfrxBarcodeAztec();
	virtual void __fastcall Assign(Frxbarcode2dbase::TfrxBarcode2DBase* src);
	
__published:
	__property int PixelSize = {read=GetPixelSize, write=SetPixelSize, nodefault};
	__property int MinECCPercent = {read=GetMinECCPercent, write=SetMinECCPercent, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxbarcodeaztec */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBARCODEAZTEC)
using namespace Frxbarcodeaztec;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxbarcodeaztecHPP
