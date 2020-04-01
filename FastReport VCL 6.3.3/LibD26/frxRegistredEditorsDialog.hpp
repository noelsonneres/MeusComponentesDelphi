// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxRegistredEditorsDialog.pas' rev: 33.00 (Windows)

#ifndef FrxregistrededitorsdialogHPP
#define FrxregistrededitorsdialogHPP

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
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxClass.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.ValEdit.hpp>
#include <System.TypInfo.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Menus.hpp>
#include <frxPopupForm.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxregistrededitorsdialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxRegEditorsDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxRegEditorsDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* CancelBTN;
	Vcl::Stdctrls::TButton* OkBTN;
	Vcl::Valedit::TValueListEditor* EditorsVL;
	Vcl::Stdctrls::TListBox* ComponentsLB;
	Vcl::Extctrls::TPanel* ComboPanel;
	Vcl::Buttons::TSpeedButton* ComboBtn;
	Vcl::Extctrls::TPanel* BackPanel;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ComponentsLBClick(System::TObject* Sender);
	void __fastcall EditorsVLDrawCell(System::TObject* Sender, int ACol, int ARow, const System::Types::TRect &Rect, Vcl::Grids::TGridDrawState State);
	void __fastcall VisibilityCBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &aRect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall Button1Click(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall EditorsVLSelectCell(System::TObject* Sender, int ACol, int ARow, bool &CanSelect);
	void __fastcall FormClick(System::TObject* Sender);
	void __fastcall ComboBtnClick(System::TObject* Sender);
	
private:
	Frxpopupform::TfrxPopupForm* FPopupForm;
	Vcl::Stdctrls::TListBox* FListBox;
	Frxclass::TfrxComponentEditorVisibility FEditItem;
	int FEditRow;
	Frxclass::TfrxComponentEditorsRegItem* FRegItem;
	void __fastcall FillComponentsList();
	void __fastcall FillEditors();
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxRegEditorsDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxRegEditorsDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxRegEditorsDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxRegEditorsDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxregistrededitorsdialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXREGISTREDEDITORSDIALOG)
using namespace Frxregistrededitorsdialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxregistrededitorsdialogHPP
