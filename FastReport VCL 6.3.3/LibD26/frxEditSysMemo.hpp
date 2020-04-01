// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditSysMemo.pas' rev: 33.00 (Windows)

#ifndef FrxeditsysmemoHPP
#define FrxeditsysmemoHPP

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

namespace Frxeditsysmemo
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxSysMemoEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxSysMemoEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OKB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TRadioButton* AggregateRB;
	Vcl::Stdctrls::TRadioButton* SysVariableRB;
	Vcl::Stdctrls::TRadioButton* TextRB;
	Vcl::Stdctrls::TGroupBox* AggregatePanel;
	Vcl::Stdctrls::TLabel* DataBandL;
	Vcl::Stdctrls::TLabel* DataSetL;
	Vcl::Stdctrls::TLabel* DataFieldL;
	Vcl::Stdctrls::TLabel* FunctionL;
	Vcl::Stdctrls::TLabel* ExpressionL;
	Vcl::Stdctrls::TComboBox* DataFieldCB;
	Vcl::Stdctrls::TComboBox* DataSetCB;
	Vcl::Stdctrls::TComboBox* DataBandCB;
	Vcl::Stdctrls::TCheckBox* CountInvisibleCB;
	Vcl::Stdctrls::TComboBox* FunctionCB;
	Frxctrls::TfrxComboEdit* ExpressionE;
	Vcl::Stdctrls::TCheckBox* RunningTotalCB;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TComboBox* SysVariableCB;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Stdctrls::TEdit* TextE;
	Vcl::Stdctrls::TLabel* SampleL;
	void __fastcall ExpressionEButtonClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall DataSetCBChange(System::TObject* Sender);
	void __fastcall DataBandCBChange(System::TObject* Sender);
	void __fastcall DataFieldCBChange(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FunctionCBChange(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	bool FAggregateOnly;
	Frxclass::TfrxReport* FReport;
	System::UnicodeString FText;
	void __fastcall FillDataBandCB();
	void __fastcall FillDataFieldCB();
	void __fastcall FillDataSetCB();
	System::UnicodeString __fastcall CreateAggregate();
	void __fastcall UpdateSample();
	
public:
	__property bool AggregateOnly = {read=FAggregateOnly, write=FAggregateOnly, nodefault};
	__property System::UnicodeString Text = {read=FText, write=FText};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxSysMemoEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxSysMemoEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxSysMemoEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxSysMemoEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditsysmemo */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITSYSMEMO)
using namespace Frxeditsysmemo;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditsysmemoHPP
