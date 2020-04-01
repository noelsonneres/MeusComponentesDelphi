// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditPicture.pas' rev: 33.00 (Windows)

#ifndef FrxeditpictureHPP
#define FrxeditpictureHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ToolWin.hpp>
#include <frxCtrls.hpp>
#include <frxDock.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditpicture
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPictureEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxPictureEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TToolBar* ToolBar;
	Vcl::Comctrls::TToolButton* LoadB;
	Vcl::Comctrls::TToolButton* ClearB;
	Vcl::Comctrls::TToolButton* OkB;
	Vcl::Forms::TScrollBox* Box;
	Vcl::Comctrls::TToolButton* ToolButton1;
	Vcl::Comctrls::TToolButton* CancelB;
	Vcl::Extctrls::TImage* Image;
	Vcl::Comctrls::TStatusBar* StatusBar;
	Vcl::Comctrls::TToolButton* CopyB;
	Vcl::Comctrls::TToolButton* PasteB;
	void __fastcall ClearBClick(System::TObject* Sender);
	void __fastcall LoadBClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall CancelBClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall CopyBClick(System::TObject* Sender);
	void __fastcall PasteBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	System::Classes::TWndMethod FStatusBarOldWindowProc;
	void __fastcall StatusBarWndProc(Winapi::Messages::TMessage &Message);
	void __fastcall UpdateImage();
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxPictureEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxPictureEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxPictureEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxPictureEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditpicture */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITPICTURE)
using namespace Frxeditpicture;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditpictureHPP
