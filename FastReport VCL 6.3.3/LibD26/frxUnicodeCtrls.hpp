// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxUnicodeCtrls.pas' rev: 33.00 (Windows)

#ifndef FrxunicodectrlsHPP
#define FrxunicodectrlsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <frxRichEdit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxunicodectrls
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TUnicodeEdit;
class DELPHICLASS TUnicodeMemo;
class DELPHICLASS TRxUnicodeRichEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TUnicodeEdit : public Vcl::Stdctrls::TEdit
{
	typedef Vcl::Stdctrls::TEdit inherited;
	
private:
	HIDESBASE void __fastcall SetSelText(const System::WideString Value);
	HIDESBASE System::WideString __fastcall GetText();
	HIDESBASE void __fastcall SetText(const System::WideString Value);
	
protected:
	virtual void __fastcall CreateWindowHandle(const Vcl::Controls::TCreateParams &Params);
	HIDESBASE System::WideString __fastcall GetSelText();
	
public:
	__property System::WideString SelText = {read=GetSelText, write=SetSelText};
	__property System::WideString Text = {read=GetText, write=SetText};
public:
	/* TCustomEdit.Create */ inline __fastcall virtual TUnicodeEdit(System::Classes::TComponent* AOwner) : Vcl::Stdctrls::TEdit(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TUnicodeEdit(HWND ParentWindow) : Vcl::Stdctrls::TEdit(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TUnicodeEdit() { }
	
};


class PASCALIMPLEMENTATION TUnicodeMemo : public Vcl::Stdctrls::TMemo
{
	typedef Vcl::Stdctrls::TMemo inherited;
	
public:
	/* TCustomMemo.Create */ inline __fastcall virtual TUnicodeMemo(System::Classes::TComponent* AOwner) : Vcl::Stdctrls::TMemo(AOwner) { }
	/* TCustomMemo.Destroy */ inline __fastcall virtual ~TUnicodeMemo() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TUnicodeMemo(HWND ParentWindow) : Vcl::Stdctrls::TMemo(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TRxUnicodeRichEdit : public Frxrichedit::TRxRichEdit
{
	typedef Frxrichedit::TRxRichEdit inherited;
	
public:
	/* TRxCustomRichEdit.Create */ inline __fastcall virtual TRxUnicodeRichEdit(System::Classes::TComponent* AOwner) : Frxrichedit::TRxRichEdit(AOwner) { }
	/* TRxCustomRichEdit.Destroy */ inline __fastcall virtual ~TRxUnicodeRichEdit() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TRxUnicodeRichEdit(HWND ParentWindow) : Frxrichedit::TRxRichEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxunicodectrls */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXUNICODECTRLS)
using namespace Frxunicodectrls;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxunicodectrlsHPP
