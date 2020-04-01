// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDelphiMaxiCode.pas' rev: 33.00 (Windows)

#ifndef FrxdelphimaxicodeHPP
#define FrxdelphimaxicodeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdelphimaxicode
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TMaxicodeEncoder;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TMaxicodeEncoder : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::WideString FData;
	int FMode;
	void __fastcall SetData(const System::WideString Value);
	void __fastcall SetMode(const int Value);
	bool __fastcall GetIsBlack(int Row, int Column);
	
protected:
	Vcl::Graphics::TBitmap* FBitmap;
	void __fastcall Update();
	
public:
	__fastcall TMaxicodeEncoder();
	__fastcall virtual ~TMaxicodeEncoder();
	int __fastcall Width();
	int __fastcall Height();
	System::Sysutils::PByteArray __fastcall GetScanLine(int Column);
	__property bool IsBlack[int Row][int Column] = {read=GetIsBlack};
	__property System::WideString Data = {read=FData, write=SetData};
	__property int Mode = {read=FMode, write=SetMode, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxdelphimaxicode */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDELPHIMAXICODE)
using namespace Frxdelphimaxicode;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdelphimaxicodeHPP
