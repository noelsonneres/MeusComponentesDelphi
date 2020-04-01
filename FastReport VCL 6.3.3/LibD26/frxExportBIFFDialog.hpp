// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportBIFFDialog.pas' rev: 33.00 (Windows)

#ifndef FrxexportbiffdialogHPP
#define FrxexportbiffdialogHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Controls.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportbiffdialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBIFFExportDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBIFFExportDialog : public Frxexportbasedialog::TfrxBaseExportDialog
{
	typedef Frxexportbasedialog::TfrxBaseExportDialog inherited;
	
__published:
	Vcl::Stdctrls::TRadioButton* rbOriginal;
	Vcl::Stdctrls::TRadioButton* rbSingle;
	Vcl::Stdctrls::TRadioButton* rbChunks;
	Vcl::Stdctrls::TEdit* edChunk;
	Vcl::Comctrls::TTabSheet* tsInfo;
	Vcl::Stdctrls::TLabel* lbTitle;
	Vcl::Stdctrls::TEdit* edTitle;
	Vcl::Stdctrls::TLabel* lbAuthor;
	Vcl::Stdctrls::TEdit* edAuthor;
	Vcl::Stdctrls::TLabel* lbKeywords;
	Vcl::Stdctrls::TEdit* edKeywords;
	Vcl::Stdctrls::TLabel* lbRevision;
	Vcl::Stdctrls::TEdit* edRevision;
	Vcl::Stdctrls::TLabel* lbAppName;
	Vcl::Stdctrls::TEdit* edAppName;
	Vcl::Stdctrls::TLabel* lbSubject;
	Vcl::Stdctrls::TEdit* edSubject;
	Vcl::Stdctrls::TLabel* lbCategory;
	Vcl::Stdctrls::TEdit* edCategory;
	Vcl::Stdctrls::TLabel* lbCompany;
	Vcl::Stdctrls::TEdit* edCompany;
	Vcl::Stdctrls::TLabel* lbManager;
	Vcl::Stdctrls::TEdit* edManager;
	Vcl::Stdctrls::TLabel* lbComment;
	Vcl::Stdctrls::TMemo* edComment;
	Vcl::Comctrls::TTabSheet* tsProt;
	Vcl::Stdctrls::TLabel* lbPass;
	Vcl::Stdctrls::TEdit* edPass1;
	Vcl::Stdctrls::TLabel* lbPassInfo;
	Vcl::Stdctrls::TLabel* lbPassConf;
	Vcl::Stdctrls::TEdit* edPass2;
	Vcl::Stdctrls::TCheckBox* cbAutoCreateFile;
	Vcl::Comctrls::TTabSheet* TabSheet1;
	Vcl::Stdctrls::TCheckBox* cbPreciseQuality;
	Vcl::Stdctrls::TCheckBox* cbPictures;
	Vcl::Stdctrls::TCheckBox* cbGridLines;
	Vcl::Stdctrls::TCheckBox* cbFit;
	Vcl::Stdctrls::TCheckBox* cbDelEmptyRows;
	Vcl::Stdctrls::TCheckBox* cbFormulas;
	
protected:
	virtual void __fastcall InitControlsFromFilter(Frxexportbasedialog::TfrxBaseDialogExportFilter* ExportFilter);
	virtual void __fastcall InitFilterFromDialog(Frxexportbasedialog::TfrxBaseDialogExportFilter* ExportFilter);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxBIFFExportDialog(System::Classes::TComponent* AOwner) : Frxexportbasedialog::TfrxBaseExportDialog(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxBIFFExportDialog(System::Classes::TComponent* AOwner, int Dummy) : Frxexportbasedialog::TfrxBaseExportDialog(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxBIFFExportDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxBIFFExportDialog(HWND ParentWindow) : Frxexportbasedialog::TfrxBaseExportDialog(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportbiffdialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTBIFFDIALOG)
using namespace Frxexportbiffdialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportbiffdialogHPP
