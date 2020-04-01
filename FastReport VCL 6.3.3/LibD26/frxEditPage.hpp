// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditPage.pas' rev: 33.00 (Windows)

#ifndef FrxeditpageHPP
#define FrxeditpageHPP

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
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <frxCtrls.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditpage
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPageEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxPageEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OKB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Comctrls::TPageControl* PageControl1;
	Vcl::Comctrls::TTabSheet* TabSheet1;
	Vcl::Comctrls::TTabSheet* TabSheet3;
	Vcl::Stdctrls::TGroupBox* Label11;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* UnitL1;
	Vcl::Stdctrls::TLabel* UnitL2;
	Vcl::Stdctrls::TEdit* WidthE;
	Vcl::Stdctrls::TEdit* HeightE;
	Vcl::Stdctrls::TComboBox* SizeCB;
	Vcl::Stdctrls::TGroupBox* Label14;
	Vcl::Stdctrls::TGroupBox* Label12;
	Vcl::Extctrls::TImage* PortraitImg;
	Vcl::Extctrls::TImage* LandscapeImg;
	Vcl::Stdctrls::TRadioButton* PortraitRB;
	Vcl::Stdctrls::TRadioButton* LandscapeRB;
	Vcl::Stdctrls::TGroupBox* Label13;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TLabel* Label6;
	Vcl::Stdctrls::TLabel* UnitL3;
	Vcl::Stdctrls::TLabel* UnitL4;
	Vcl::Stdctrls::TLabel* UnitL5;
	Vcl::Stdctrls::TLabel* UnitL6;
	Vcl::Stdctrls::TEdit* MarginLeftE;
	Vcl::Stdctrls::TEdit* MarginTopE;
	Vcl::Stdctrls::TEdit* MarginRightE;
	Vcl::Stdctrls::TEdit* MarginBottomE;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Stdctrls::TLabel* Label10;
	Vcl::Stdctrls::TComboBox* Tray1CB;
	Vcl::Stdctrls::TComboBox* Tray2CB;
	Vcl::Stdctrls::TGroupBox* Label7;
	Vcl::Stdctrls::TLabel* Label8;
	Vcl::Stdctrls::TLabel* Label15;
	Vcl::Stdctrls::TLabel* Label16;
	Vcl::Stdctrls::TLabel* UnitL7;
	Vcl::Stdctrls::TEdit* ColumnsNumberE;
	Vcl::Stdctrls::TEdit* ColumnWidthE;
	Vcl::Stdctrls::TMemo* ColumnPositionsM;
	Vcl::Comctrls::TUpDown* UpDown1;
	Vcl::Stdctrls::TGroupBox* Label17;
	Vcl::Stdctrls::TLabel* Label18;
	Vcl::Stdctrls::TCheckBox* PrintOnPrevCB;
	Vcl::Stdctrls::TCheckBox* MirrorMarginsCB;
	Vcl::Stdctrls::TCheckBox* LargeHeightCB;
	Vcl::Stdctrls::TComboBox* DuplexCB;
	Vcl::Stdctrls::TCheckBox* EndlessWidthCB;
	Vcl::Stdctrls::TCheckBox* EndlessHeightCB;
	void __fastcall PortraitRBClick(System::TObject* Sender);
	void __fastcall SizeCBClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall WidthEChange(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall UpDown1Click(System::TObject* Sender, Vcl::Comctrls::TUDBtnType Button);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	bool FUpdating;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxPageEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxPageEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxPageEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxPageEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditpage */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITPAGE)
using namespace Frxeditpage;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditpageHPP
