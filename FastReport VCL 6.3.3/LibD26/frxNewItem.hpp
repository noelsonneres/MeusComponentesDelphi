// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxNewItem.pas' rev: 33.00 (Windows)

#ifndef FrxnewitemHPP
#define FrxnewitemHPP

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
#include <Vcl.ComCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ImgList.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxnewitem
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxNewItemForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxNewItemForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TPageControl* Pages;
	Vcl::Comctrls::TTabSheet* ItemsTab;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Comctrls::TTabSheet* TemplateTab;
	Vcl::Stdctrls::TCheckBox* InheritCB;
	Vcl::Comctrls::TListView* TemplateLV;
	Vcl::Comctrls::TListView* ItemsLV;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ItemsLVDblClick(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	System::Classes::TStringList* FTemplates;
	
public:
	__fastcall virtual TfrxNewItemForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxNewItemForm();
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxNewItemForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxNewItemForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxnewitem */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXNEWITEM)
using namespace Frxnewitem;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxnewitemHPP
