// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxInheritError.pas' rev: 33.00 (Windows)

#ifndef FrxinheriterrorHPP
#define FrxinheriterrorHPP

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
#include <Vcl.ImgList.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxinheriterror
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxInheritErrorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxInheritErrorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TLabel* MessageL;
	Vcl::Stdctrls::TRadioButton* DeleteRB;
	Vcl::Stdctrls::TRadioButton* RenameRB;
	Vcl::Extctrls::TPaintBox* PaintBox1;
	Vcl::Controls::TImageList* ImageList1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall PaintBox1Paint(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxInheritErrorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxInheritErrorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxInheritErrorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxInheritErrorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxinheriterror */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXINHERITERROR)
using namespace Frxinheriterror;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxinheriterrorHPP
