// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fqbLinkForm.pas' rev: 33.00 (Windows)

#ifndef FqblinkformHPP
#define FqblinkformHPP

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
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fqblinkform
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfqbLinkForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfqbLinkForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TRadioGroup* RadioOpt;
	Vcl::Extctrls::TRadioGroup* RadioType;
	Vcl::Stdctrls::TStaticText* txtTable1;
	Vcl::Stdctrls::TStaticText* txtTable2;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TStaticText* txtCol1;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TStaticText* txtCol2;
	Vcl::Buttons::TBitBtn* BitBtn1;
	Vcl::Buttons::TBitBtn* BitBtn2;
	void __fastcall FormCreate(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfqbLinkForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfqbLinkForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfqbLinkForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbLinkForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fqblinkform */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FQBLINKFORM)
using namespace Fqblinkform;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FqblinkformHPP
