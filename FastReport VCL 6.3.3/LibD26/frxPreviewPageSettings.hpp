// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPreviewPageSettings.pas' rev: 33.00 (Windows)

#ifndef FrxpreviewpagesettingsHPP
#define FrxpreviewpagesettingsHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <frxClass.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxpreviewpagesettings
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPageSettingsForm;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxDesignerUnits : unsigned char { duCM, duInches, duPixels, duChars };

class PASCALIMPLEMENTATION TfrxPageSettingsForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OKB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TGroupBox* SizeL;
	Vcl::Stdctrls::TLabel* WidthL;
	Vcl::Stdctrls::TLabel* HeightL;
	Vcl::Stdctrls::TLabel* UnitL1;
	Vcl::Stdctrls::TLabel* UnitL2;
	Vcl::Stdctrls::TEdit* WidthE;
	Vcl::Stdctrls::TEdit* HeightE;
	Vcl::Stdctrls::TComboBox* SizeCB;
	Vcl::Stdctrls::TGroupBox* OrientationL;
	Vcl::Extctrls::TImage* PortraitImg;
	Vcl::Extctrls::TImage* LandscapeImg;
	Vcl::Stdctrls::TRadioButton* PortraitRB;
	Vcl::Stdctrls::TRadioButton* LandscapeRB;
	Vcl::Stdctrls::TGroupBox* MarginsL;
	Vcl::Stdctrls::TLabel* LeftL;
	Vcl::Stdctrls::TLabel* TopL;
	Vcl::Stdctrls::TLabel* RightL;
	Vcl::Stdctrls::TLabel* BottomL;
	Vcl::Stdctrls::TLabel* UnitL3;
	Vcl::Stdctrls::TLabel* UnitL4;
	Vcl::Stdctrls::TLabel* UnitL5;
	Vcl::Stdctrls::TLabel* UnitL6;
	Vcl::Stdctrls::TEdit* MarginLeftE;
	Vcl::Stdctrls::TEdit* MarginTopE;
	Vcl::Stdctrls::TEdit* MarginRightE;
	Vcl::Stdctrls::TEdit* MarginBottomE;
	Vcl::Stdctrls::TGroupBox* OtherL;
	Vcl::Stdctrls::TRadioButton* ApplyToCurRB;
	Vcl::Stdctrls::TRadioButton* ApplyToAllRB;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall PortraitRBClick(System::TObject* Sender);
	void __fastcall SizeCBClick(System::TObject* Sender);
	void __fastcall WidthEChange(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
protected:
	Frxclass::TfrxReportPage* FPage;
	Frxclass::TfrxReport* FReport;
	TfrxDesignerUnits FUnits;
	bool FUpdating;
	bool __fastcall GetNeedRebuild();
	System::Extended __fastcall mmToUnits(System::Extended mm);
	System::Extended __fastcall UnitsTomm(System::Extended mm);
	
public:
	__property bool NeedRebuild = {read=GetNeedRebuild, nodefault};
	__property Frxclass::TfrxReportPage* Page = {read=FPage, write=FPage};
	__property Frxclass::TfrxReport* Report = {read=FReport, write=FReport};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxPageSettingsForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxPageSettingsForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxPageSettingsForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxPageSettingsForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxpreviewpagesettings */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPREVIEWPAGESETTINGS)
using namespace Frxpreviewpagesettings;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxpreviewpagesettingsHPP
