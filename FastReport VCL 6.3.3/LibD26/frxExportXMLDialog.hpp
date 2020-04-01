// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportXMLDialog.pas' rev: 33.00 (Windows)

#ifndef FrxexportxmldialogHPP
#define FrxexportxmldialogHPP

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
#include <System.Variants.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportxmldialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxXMLExportDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxXMLExportDialog : public Frxexportbasedialog::TfrxBaseExportDialog
{
	typedef Frxexportbasedialog::TfrxBaseExportDialog inherited;
	
__published:
	Vcl::Stdctrls::TCheckBox* WCB;
	Vcl::Stdctrls::TCheckBox* ContinuousCB;
	Vcl::Stdctrls::TCheckBox* PageBreaksCB;
	Vcl::Stdctrls::TCheckBox* BackgrCB;
	Vcl::Stdctrls::TGroupBox* SplitToSheetGB;
	Vcl::Stdctrls::TRadioButton* RPagesRB;
	Vcl::Stdctrls::TRadioButton* PrintOnPrevRB;
	Vcl::Stdctrls::TRadioButton* RowsCountRB;
	Vcl::Stdctrls::TEdit* ERows;
	Vcl::Stdctrls::TRadioButton* NotSplitRB;
	void __fastcall ERowsKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall ERowsChange(System::TObject* Sender);
	
protected:
	virtual void __fastcall InitControlsFromFilter(Frxexportbasedialog::TfrxBaseDialogExportFilter* ExportFilter);
	virtual void __fastcall InitFilterFromDialog(Frxexportbasedialog::TfrxBaseDialogExportFilter* ExportFilter);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxXMLExportDialog(System::Classes::TComponent* AOwner) : Frxexportbasedialog::TfrxBaseExportDialog(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxXMLExportDialog(System::Classes::TComponent* AOwner, int Dummy) : Frxexportbasedialog::TfrxBaseExportDialog(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxXMLExportDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxXMLExportDialog(HWND ParentWindow) : Frxexportbasedialog::TfrxBaseExportDialog(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportxmldialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTXMLDIALOG)
using namespace Frxexportxmldialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportxmldialogHPP
