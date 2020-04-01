// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportBaseDialog.pas' rev: 33.00 (Windows)

#ifndef FrxexportbasedialogHPP
#define FrxexportbasedialogHPP

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
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxClass.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportbasedialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBaseDialogExportFilter;
class DELPHICLASS TfrxBaseExportDialog;
//-- type declarations -------------------------------------------------------
typedef System::TMetaClass* TfrxBaseExportDialogClass;

class PASCALIMPLEMENTATION TfrxBaseDialogExportFilter : public Frxclass::TfrxCustomExportFilter
{
	typedef Frxclass::TfrxCustomExportFilter inherited;
	
protected:
	virtual void __fastcall AfterFinish();
	
public:
	virtual System::Uitypes::TModalResult __fastcall ShowModal();
	__classmethod virtual TfrxBaseExportDialogClass __fastcall ExportDialogClass();
public:
	/* TfrxCustomExportFilter.Create */ inline __fastcall virtual TfrxBaseDialogExportFilter(System::Classes::TComponent* AOwner) : Frxclass::TfrxCustomExportFilter(AOwner) { }
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxBaseDialogExportFilter() : Frxclass::TfrxCustomExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxBaseDialogExportFilter() { }
	
};


class PASCALIMPLEMENTATION TfrxBaseExportDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TPageControl* PageControl1;
	Vcl::Comctrls::TTabSheet* ExportPage;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TCheckBox* OpenCB;
	Vcl::Stdctrls::TGroupBox* GroupQuality;
	Vcl::Stdctrls::TGroupBox* GroupPageRange;
	Vcl::Stdctrls::TLabel* DescrL;
	Vcl::Stdctrls::TRadioButton* AllRB;
	Vcl::Stdctrls::TRadioButton* CurPageRB;
	Vcl::Stdctrls::TRadioButton* PageNumbersRB;
	Vcl::Stdctrls::TEdit* PageNumbersE;
	Vcl::Stdctrls::TComboBox* FiltersNameCB;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall PageNumbersEChange(System::TObject* Sender);
	void __fastcall PageNumbersEKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall OkBClick(System::TObject* Sender);
	
protected:
	virtual void __fastcall InitDialog();
	virtual void __fastcall InitControlsFromFilter(TfrxBaseDialogExportFilter* ExportFilter);
	virtual void __fastcall InitFilterFromDialog(TfrxBaseDialogExportFilter* ExportFilter);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxBaseExportDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxBaseExportDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxBaseExportDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxBaseExportDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportbasedialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTBASEDIALOG)
using namespace Frxexportbasedialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportbasedialogHPP
