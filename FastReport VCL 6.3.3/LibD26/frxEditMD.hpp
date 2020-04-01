// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditMD.pas' rev: 33.00 (Windows)

#ifndef FrxeditmdHPP
#define FrxeditmdHPP

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
#include <frxClass.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxCustomDB.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditmd
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMDEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxMDEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TListBox* DetailLB;
	Vcl::Stdctrls::TListBox* MasterLB;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TButton* AddB;
	Vcl::Stdctrls::TListBox* LinksLB;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TButton* ClearB;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Extctrls::TBevel* Bevel1;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall ClearBClick(System::TObject* Sender);
	void __fastcall DetailLBClick(System::TObject* Sender);
	void __fastcall MasterLBClick(System::TObject* Sender);
	void __fastcall AddBClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	Frxcustomdb::TfrxCustomDataset* FDetailDS;
	Frxclass::TfrxCustomDBDataSet* FMasterDS;
	System::UnicodeString FMasterFields;
	void __fastcall FillLists();
	
public:
	__property Frxcustomdb::TfrxCustomDataset* DataSet = {read=FDetailDS, write=FDetailDS};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxMDEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxMDEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxMDEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxMDEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditmd */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITMD)
using namespace Frxeditmd;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditmdHPP
