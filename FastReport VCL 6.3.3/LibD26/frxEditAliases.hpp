// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditAliases.pas' rev: 33.00 (Windows)

#ifndef FrxeditaliasesHPP
#define FrxeditaliasesHPP

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
#include <Vcl.ComCtrls.hpp>
#include <frxClass.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditaliases
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxAliasesEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxAliasesEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TListView* AliasesLV;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TButton* ResetB;
	Vcl::Stdctrls::TLabel* HintL;
	Vcl::Stdctrls::TLabel* DSAliasL;
	Vcl::Stdctrls::TEdit* DSAliasE;
	Vcl::Stdctrls::TLabel* FieldAliasesL;
	Vcl::Stdctrls::TButton* UpdateB;
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ResetBClick(System::TObject* Sender);
	void __fastcall AliasesLVKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall UpdateBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall AliasesLVEdited(System::TObject* Sender, Vcl::Comctrls::TListItem* Item, System::UnicodeString &S);
	
private:
	Frxclass::TfrxCustomDBDataSet* FDataSet;
	void __fastcall BuildAliasList(System::Classes::TStrings* List);
	
public:
	__property Frxclass::TfrxCustomDBDataSet* DataSet = {read=FDataSet, write=FDataSet};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxAliasesEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxAliasesEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxAliasesEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxAliasesEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditaliases */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITALIASES)
using namespace Frxeditaliases;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditaliasesHPP
