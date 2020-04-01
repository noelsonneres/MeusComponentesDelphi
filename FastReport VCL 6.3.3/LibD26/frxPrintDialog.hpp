// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPrintDialog.pas' rev: 33.00 (Windows)

#ifndef FrxprintdialogHPP
#define FrxprintdialogHPP

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
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <frxClass.hpp>
#include <Vcl.ImgList.hpp>
#include <frxCtrls.hpp>
#include <System.Variants.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxprintdialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPrintDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxPrintDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Dialogs::TSaveDialog* FileDlg;
	Vcl::Stdctrls::TGroupBox* Label12;
	Vcl::Stdctrls::TLabel* WhereL;
	Vcl::Stdctrls::TLabel* WhereL1;
	Vcl::Stdctrls::TComboBox* PrintersCB;
	Vcl::Stdctrls::TButton* PropButton;
	Vcl::Stdctrls::TCheckBox* FileCB;
	Vcl::Stdctrls::TGroupBox* Label1;
	Vcl::Stdctrls::TLabel* DescrL;
	Vcl::Stdctrls::TRadioButton* AllRB;
	Vcl::Stdctrls::TRadioButton* CurPageRB;
	Vcl::Stdctrls::TRadioButton* PageNumbersRB;
	Vcl::Stdctrls::TEdit* PageNumbersE;
	Vcl::Stdctrls::TGroupBox* Label2;
	Vcl::Stdctrls::TLabel* CopiesL;
	Vcl::Extctrls::TImage* CollateImg;
	Vcl::Extctrls::TImage* NonCollateImg;
	Vcl::Extctrls::TPaintBox* CopiesPB;
	Vcl::Stdctrls::TEdit* CopiesE;
	Vcl::Stdctrls::TCheckBox* CollateCB;
	Vcl::Comctrls::TUpDown* UpDown1;
	Vcl::Stdctrls::TGroupBox* ScaleGB;
	Vcl::Stdctrls::TComboBox* PagPageSizeCB;
	Vcl::Stdctrls::TLabel* NameL;
	Vcl::Stdctrls::TLabel* PagSizeL;
	Vcl::Stdctrls::TComboBox* PrintModeCB;
	Vcl::Controls::TImageList* PrintModeIL;
	Vcl::Stdctrls::TGroupBox* OtherGB;
	Vcl::Stdctrls::TLabel* PrintL;
	Vcl::Stdctrls::TLabel* DuplexL;
	Vcl::Stdctrls::TComboBox* PrintPagesCB;
	Vcl::Stdctrls::TComboBox* DuplexCB;
	Vcl::Stdctrls::TLabel* OrderL;
	Vcl::Stdctrls::TComboBox* OrderCB;
	void __fastcall PrintersCBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall PropButtonClick(System::TObject* Sender);
	void __fastcall PrintersCBClick(System::TObject* Sender);
	void __fastcall PageNumbersRBClick(System::TObject* Sender);
	void __fastcall CollateLClick(System::TObject* Sender);
	void __fastcall CollateCBClick(System::TObject* Sender);
	void __fastcall CopiesPBPaint(System::TObject* Sender);
	void __fastcall PageNumbersEEnter(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PrintModeCBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall PrintModeCBClick(System::TObject* Sender);
	
private:
	int OldIndex;
	
public:
	Frxclass::TfrxReport* AReport;
	Frxclass::TfrxDuplexMode ADuplexMode;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxPrintDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxPrintDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxPrintDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxPrintDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxprintdialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPRINTDIALOG)
using namespace Frxprintdialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxprintdialogHPP
