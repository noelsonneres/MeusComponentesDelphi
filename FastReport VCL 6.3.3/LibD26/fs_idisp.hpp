// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_idisp.pas' rev: 33.00 (Windows)

#ifndef Fs_idispHPP
#define Fs_idispHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Win.ComObj.hpp>
#include <fs_iinterpreter.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fs_idisp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfsOLEHelper;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfsOLEHelper : public Fs_iinterpreter::TfsCustomHelper
{
	typedef Fs_iinterpreter::TfsCustomHelper inherited;
	
private:
	System::Variant __fastcall DispatchInvoke(const System::Variant &ParamArray, int ParamCount, System::Word Flags);
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsOLEHelper(const System::UnicodeString AName);
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsOLEHelper() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_idisp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_IDISP)
using namespace Fs_idisp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_idispHPP
