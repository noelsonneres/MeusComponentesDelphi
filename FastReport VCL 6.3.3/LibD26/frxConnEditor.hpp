// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxConnEditor.pas' rev: 33.00 (Windows)

#ifndef FrxconneditorHPP
#define FrxconneditorHPP

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
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxClass.hpp>
#include <frxConnItemEdit.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxconneditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxConnEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxConnEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* NewB;
	Vcl::Stdctrls::TButton* DeleteB;
	Vcl::Comctrls::TListView* ConnLV;
	Vcl::Stdctrls::TButton* OKB;
	Vcl::Stdctrls::TButton* EditB;
	Vcl::Stdctrls::TButton* TestB;
	void __fastcall NewBClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall DeleteBClick(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall OKBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall EditBClick(System::TObject* Sender);
	void __fastcall TestBClick(System::TObject* Sender);
	
private:
	void __fastcall ReadADOConnections();
	void __fastcall SaveADOConnections();
	
public:
	Frxclass::TfrxReport* Report;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxConnEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxConnEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxConnEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxConnEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxconneditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCONNEDITOR)
using namespace Frxconneditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxconneditorHPP
