// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditGroup.pas' rev: 33.00 (Windows)

#ifndef FrxeditgroupHPP
#define FrxeditgroupHPP

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
#include <frxClass.hpp>
#include <frxCtrls.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditgroup
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGroupEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGroupEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OKB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TGroupBox* BreakOnL;
	Vcl::Stdctrls::TComboBox* DataFieldCB;
	Vcl::Stdctrls::TComboBox* DataSetCB;
	Frxctrls::TfrxComboEdit* ExpressionE;
	Vcl::Stdctrls::TRadioButton* DataFieldRB;
	Vcl::Stdctrls::TRadioButton* ExpressionRB;
	Vcl::Stdctrls::TGroupBox* OptionsL;
	Vcl::Stdctrls::TCheckBox* KeepGroupTogetherCB;
	Vcl::Stdctrls::TCheckBox* StartNewPageCB;
	Vcl::Stdctrls::TCheckBox* OutlineCB;
	Vcl::Stdctrls::TCheckBox* DrillCB;
	Vcl::Stdctrls::TCheckBox* ResetCB;
	void __fastcall ExpressionEButtonClick(System::TObject* Sender);
	void __fastcall DataFieldRBClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall DataSetCBChange(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	Frxclass::TfrxGroupHeader* FGroupHeader;
	Frxclass::TfrxReport* FReport;
	void __fastcall FillDataFieldCB();
	void __fastcall FillDataSetCB();
	
public:
	__property Frxclass::TfrxGroupHeader* GroupHeader = {read=FGroupHeader, write=FGroupHeader};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxGroupEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxGroupEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxGroupEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxGroupEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditgroup */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITGROUP)
using namespace Frxeditgroup;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditgroupHPP
