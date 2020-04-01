// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditTabOrder.pas' rev: 33.00 (Windows)

#ifndef FrxedittaborderHPP
#define FrxedittaborderHPP

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
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxedittaborder
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxTabOrderEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxTabOrderEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TButton* UpB;
	Vcl::Stdctrls::TButton* DownB;
	Vcl::Stdctrls::TListBox* ControlsLB;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall UpBClick(System::TObject* Sender);
	void __fastcall DownBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	System::Classes::TList* FOldOrder;
	Frxclass::TfrxComponent* FParent;
	void __fastcall UpdateOrder();
	
public:
	__fastcall virtual TfrxTabOrderEditorForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxTabOrderEditorForm();
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxTabOrderEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxTabOrderEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxedittaborder */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITTABORDER)
using namespace Frxedittaborder;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxedittaborderHPP
