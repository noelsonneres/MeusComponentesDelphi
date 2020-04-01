// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditDataBand.pas' rev: 33.00 (Windows)

#ifndef FrxeditdatabandHPP
#define FrxeditdatabandHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <frxClass.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.Variants.hpp>
#include <frxCtrls.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditdataband
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDataBandEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDataBandEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TGroupBox* DatasetGB;
	Vcl::Stdctrls::TListBox* DatasetsLB;
	Vcl::Stdctrls::TLabel* RecordsL;
	Vcl::Stdctrls::TEdit* RecordsE;
	Vcl::Comctrls::TUpDown* RecordsUD;
	Vcl::Stdctrls::TGroupBox* FilterGB;
	Frxctrls::TfrxComboEdit* FilterE;
	void __fastcall DatasetsLBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall DatasetsLBDblClick(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall DatasetsLBClick(System::TObject* Sender);
	void __fastcall FilterEButtonClick(System::TObject* Sender);
	
private:
	Frxclass::TfrxDataBand* FDataBand;
	Frxclass::TfrxCustomDesigner* FDesigner;
	
public:
	__property Frxclass::TfrxDataBand* DataBand = {read=FDataBand, write=FDataBand};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxDataBandEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxDataBandEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxDataBandEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxDataBandEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditdataband */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITDATABAND)
using namespace Frxeditdataband;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditdatabandHPP
