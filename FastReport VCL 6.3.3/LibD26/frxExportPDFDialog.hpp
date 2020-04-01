// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportPDFDialog.pas' rev: 33.00 (Windows)

#ifndef FrxexportpdfdialogHPP
#define FrxexportpdfdialogHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxExportBaseDialog.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.Variants.hpp>
#include <frxPreview.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportpdfdialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPDFExportDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxPDFExportDialog : public Frxexportbasedialog::TfrxBaseExportDialog
{
	typedef Frxexportbasedialog::TfrxBaseExportDialog inherited;
	
__published:
	Vcl::Comctrls::TTabSheet* InfoPage;
	Vcl::Comctrls::TTabSheet* SecurityPage;
	Vcl::Comctrls::TTabSheet* ViewerPage;
	Vcl::Stdctrls::TCheckBox* CompressedCB;
	Vcl::Stdctrls::TCheckBox* EmbeddedCB;
	Vcl::Stdctrls::TCheckBox* PrintOptCB;
	Vcl::Stdctrls::TCheckBox* OutlineCB;
	Vcl::Stdctrls::TCheckBox* BackgrCB;
	Vcl::Stdctrls::TGroupBox* SecGB;
	Vcl::Stdctrls::TLabel* OwnPassL;
	Vcl::Stdctrls::TLabel* UserPassL;
	Vcl::Stdctrls::TEdit* OwnPassE;
	Vcl::Stdctrls::TEdit* UserPassE;
	Vcl::Stdctrls::TGroupBox* PermGB;
	Vcl::Stdctrls::TCheckBox* PrintCB;
	Vcl::Stdctrls::TCheckBox* ModCB;
	Vcl::Stdctrls::TCheckBox* CopyCB;
	Vcl::Stdctrls::TCheckBox* AnnotCB;
	Vcl::Stdctrls::TGroupBox* DocInfoGB;
	Vcl::Stdctrls::TLabel* TitleL;
	Vcl::Stdctrls::TEdit* TitleE;
	Vcl::Stdctrls::TEdit* AuthorE;
	Vcl::Stdctrls::TLabel* AuthorL;
	Vcl::Stdctrls::TLabel* SubjectL;
	Vcl::Stdctrls::TEdit* SubjectE;
	Vcl::Stdctrls::TLabel* KeywordsL;
	Vcl::Stdctrls::TEdit* KeywordsE;
	Vcl::Stdctrls::TEdit* CreatorE;
	Vcl::Stdctrls::TLabel* CreatorL;
	Vcl::Stdctrls::TLabel* ProducerL;
	Vcl::Stdctrls::TEdit* ProducerE;
	Vcl::Stdctrls::TGroupBox* ViewerGB;
	Vcl::Stdctrls::TCheckBox* HideToolbarCB;
	Vcl::Stdctrls::TCheckBox* HideMenubarCB;
	Vcl::Stdctrls::TCheckBox* HideWindowUICB;
	Vcl::Stdctrls::TCheckBox* FitWindowCB;
	Vcl::Stdctrls::TCheckBox* CenterWindowCB;
	Vcl::Stdctrls::TCheckBox* PrintScalingCB;
	Vcl::Stdctrls::TEdit* QualityEdit;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TCheckBox* TransparentCB;
	Vcl::Stdctrls::TComboBox* PDFStandardComboBox;
	Vcl::Stdctrls::TLabel* PDFStandardLabel;
	Vcl::Stdctrls::TComboBox* PDFVersionComboBox;
	Vcl::Stdctrls::TLabel* PDFVersionLabel;
	void __fastcall PDFStandardComboBoxChange(System::TObject* Sender);
	
protected:
	void __fastcall SetupComboBox(Vcl::Stdctrls::TComboBox* ComboBox, System::UnicodeString st);
	void __fastcall DoStandard();
	virtual void __fastcall InitDialog();
	virtual void __fastcall InitControlsFromFilter(Frxexportbasedialog::TfrxBaseDialogExportFilter* ExportFilter);
	virtual void __fastcall InitFilterFromDialog(Frxexportbasedialog::TfrxBaseDialogExportFilter* ExportFilter);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxPDFExportDialog(System::Classes::TComponent* AOwner) : Frxexportbasedialog::TfrxBaseExportDialog(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxPDFExportDialog(System::Classes::TComponent* AOwner, int Dummy) : Frxexportbasedialog::TfrxBaseExportDialog(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxPDFExportDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxPDFExportDialog(HWND ParentWindow) : Frxexportbasedialog::TfrxBaseExportDialog(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportpdfdialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTPDFDIALOG)
using namespace Frxexportpdfdialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportpdfdialogHPP
