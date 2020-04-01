// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditReport.pas' rev: 33.00 (Windows)

#ifndef FrxeditreportHPP
#define FrxeditreportHPP

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
#include <frxCtrls.hpp>
#include <Vcl.FileCtrl.hpp>
#include <System.Variants.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditreport
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxReportEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxReportEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Comctrls::TPageControl* PageControl;
	Vcl::Comctrls::TTabSheet* GeneralTS;
	Vcl::Comctrls::TTabSheet* DescriptionTS;
	Vcl::Stdctrls::TGroupBox* ReportSettingsL;
	Vcl::Stdctrls::TListBox* PrintersLB;
	Vcl::Stdctrls::TLabel* CopiesL;
	Vcl::Stdctrls::TEdit* CopiesE;
	Vcl::Stdctrls::TCheckBox* CollateCB;
	Vcl::Stdctrls::TGroupBox* GeneralL;
	Vcl::Stdctrls::TLabel* PasswordL;
	Vcl::Stdctrls::TCheckBox* DoublePassCB;
	Vcl::Stdctrls::TCheckBox* PrintIfEmptyCB;
	Vcl::Stdctrls::TEdit* PasswordE;
	Vcl::Stdctrls::TGroupBox* DescriptionL;
	Vcl::Extctrls::TBevel* Bevel3;
	Vcl::Stdctrls::TLabel* NameL;
	Vcl::Extctrls::TImage* PictureImg;
	Vcl::Stdctrls::TLabel* Description1L;
	Vcl::Stdctrls::TLabel* PictureL;
	Vcl::Stdctrls::TLabel* AuthorL;
	Vcl::Stdctrls::TEdit* NameE;
	Vcl::Stdctrls::TMemo* DescriptionE;
	Vcl::Stdctrls::TButton* PictureB;
	Vcl::Stdctrls::TEdit* AuthorE;
	Vcl::Stdctrls::TGroupBox* VersionL;
	Vcl::Stdctrls::TLabel* MajorL;
	Vcl::Stdctrls::TLabel* MinorL;
	Vcl::Stdctrls::TLabel* ReleaseL;
	Vcl::Stdctrls::TLabel* BuildL;
	Vcl::Stdctrls::TLabel* CreatedL;
	Vcl::Stdctrls::TLabel* Created1L;
	Vcl::Stdctrls::TLabel* ModifiedL;
	Vcl::Stdctrls::TLabel* Modified1L;
	Vcl::Stdctrls::TEdit* MajorE;
	Vcl::Stdctrls::TEdit* MinorE;
	Vcl::Stdctrls::TEdit* ReleaseE;
	Vcl::Stdctrls::TEdit* BuildE;
	Vcl::Comctrls::TTabSheet* InheritTS;
	Vcl::Stdctrls::TGroupBox* InheritGB;
	Vcl::Stdctrls::TLabel* InheritStateL;
	Vcl::Stdctrls::TRadioButton* DetachRB;
	Vcl::Stdctrls::TLabel* SelectL;
	Vcl::Stdctrls::TRadioButton* InheritRB;
	Vcl::Stdctrls::TRadioButton* DontChangeRB;
	Vcl::Comctrls::TListView* InheritLV;
	Vcl::Stdctrls::TLabel* PathLB;
	Vcl::Stdctrls::TEdit* PathE;
	Vcl::Stdctrls::TButton* BrowseB;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall PictureBClick(System::TObject* Sender);
	void __fastcall PrintersLBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall BrowseBClick(System::TObject* Sender);
	void __fastcall FillTemplatelist();
	void __fastcall PathEKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall PageControlChange(System::TObject* Sender);
	
private:
	System::Classes::TStringList* FTemplates;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxReportEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxReportEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxReportEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxReportEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditreport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITREPORT)
using namespace Frxeditreport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditreportHPP
