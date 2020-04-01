// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditQueryParams.pas' rev: 33.00 (Windows)

#ifndef FrxeditqueryparamsHPP
#define FrxeditqueryparamsHPP

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
#include <Data.DB.hpp>
#include <frxCustomDB.hpp>
#include <frxCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditqueryparams
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxParamsEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxParamsEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TListView* ParamsLV;
	Vcl::Stdctrls::TComboBox* TypeCB;
	Vcl::Stdctrls::TEdit* ValueE;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Extctrls::TPanel* ButtonPanel;
	Vcl::Buttons::TSpeedButton* ExpressionB;
	void __fastcall ParamsLVSelectItem(System::TObject* Sender, Vcl::Comctrls::TListItem* Item, bool Selected);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ParamsLVMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall ValueEButtonClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	Frxcustomdb::TfrxParams* FParams;
	
public:
	__property Frxcustomdb::TfrxParams* Params = {read=FParams, write=FParams};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxParamsEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxParamsEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxParamsEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxParamsEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditqueryparams */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITQUERYPARAMS)
using namespace Frxeditqueryparams;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditqueryparamsHPP
