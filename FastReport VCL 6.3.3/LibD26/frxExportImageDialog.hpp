// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportImageDialog.pas' rev: 33.00 (Windows)

#ifndef FrxexportimagedialogHPP
#define FrxexportimagedialogHPP

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
#include <frxExportBaseDialog.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportimagedialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxIMGExportDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxIMGExportDialog : public Frxexportbasedialog::TfrxBaseExportDialog
{
	typedef Frxexportbasedialog::TfrxBaseExportDialog inherited;
	
__published:
	Vcl::Stdctrls::TCheckBox* CropPage;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TEdit* Quality;
	Vcl::Stdctrls::TCheckBox* Mono;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TEdit* Resolution;
	Vcl::Stdctrls::TCheckBox* SeparateCB;
	
private:
	Frxexportbasedialog::TfrxBaseDialogExportFilter* FFilter;
	void __fastcall SetFilter(Frxexportbasedialog::TfrxBaseDialogExportFilter* const Value);
	
protected:
	virtual void __fastcall InitControlsFromFilter(Frxexportbasedialog::TfrxBaseDialogExportFilter* ExportFilter);
	virtual void __fastcall InitFilterFromDialog(Frxexportbasedialog::TfrxBaseDialogExportFilter* ExportFilter);
	
public:
	__property Frxexportbasedialog::TfrxBaseDialogExportFilter* Filter = {read=FFilter, write=SetFilter};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxIMGExportDialog(System::Classes::TComponent* AOwner) : Frxexportbasedialog::TfrxBaseExportDialog(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxIMGExportDialog(System::Classes::TComponent* AOwner, int Dummy) : Frxexportbasedialog::TfrxBaseExportDialog(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxIMGExportDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxIMGExportDialog(HWND ParentWindow) : Frxexportbasedialog::TfrxBaseExportDialog(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportimagedialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTIMAGEDIALOG)
using namespace Frxexportimagedialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportimagedialogHPP
