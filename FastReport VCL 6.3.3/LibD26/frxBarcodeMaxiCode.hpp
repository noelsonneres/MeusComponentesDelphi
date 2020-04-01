// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBarcodeMaxiCode.pas' rev: 33.00 (Windows)

#ifndef FrxbarcodemaxicodeHPP
#define FrxbarcodemaxicodeHPP

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
#include <frxDelphiMaxiCode.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbarcodemaxicode
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBarcodeMaxiCode;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBarcodeMaxiCode : public Frxbarcode2dbase::TfrxBarcode2DBase
{
	typedef Frxbarcode2dbase::TfrxBarcode2DBase inherited;
	
private:
	int __fastcall GetMode();
	void __fastcall SetMode(const int Value);
	
protected:
	Frxdelphimaxicode::TMaxicodeEncoder* FMaxiCodeEncoder;
	void __fastcall Generate();
	virtual void __fastcall SetText(System::UnicodeString v);
	
public:
	__fastcall virtual TfrxBarcodeMaxiCode();
	__fastcall virtual ~TfrxBarcodeMaxiCode();
	virtual void __fastcall Assign(Frxbarcode2dbase::TfrxBarcode2DBase* src);
	
__published:
	__property int Mode = {read=GetMode, write=SetMode, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxbarcodemaxicode */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBARCODEMAXICODE)
using namespace Frxbarcodemaxicode;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxbarcodemaxicodeHPP
