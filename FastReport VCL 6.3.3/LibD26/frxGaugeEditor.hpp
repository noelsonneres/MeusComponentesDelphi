// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGaugeEditor.pas' rev: 33.00 (Windows)

#ifndef FrxgaugeeditorHPP
#define FrxgaugeeditorHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxClass.hpp>
#include <frxGaugeView.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgaugeeditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGaugeEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGaugeEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* CancelButton;
	Vcl::Stdctrls::TButton* OkButton;
	Vcl::Extctrls::TPaintBox* SamplePaintBox;
	Vcl::Stdctrls::TButton* FillButton;
	Vcl::Stdctrls::TButton* FrameButton;
	Vcl::Comctrls::TPageControl* GaugeOptionsPageControl;
	Vcl::Comctrls::TTabSheet* GeneralTabSheet;
	Vcl::Comctrls::TTabSheet* MajorScaleTabSheet;
	Vcl::Stdctrls::TCheckBox* MajorScaleVisibleCheckBox;
	Vcl::Comctrls::TTabSheet* MinorScaleTabSheet;
	Vcl::Stdctrls::TCheckBox* MinorScaleVisibleCheckBox;
	Vcl::Comctrls::TTabSheet* PointerTabSheet;
	Vcl::Stdctrls::TComboBox* GaugeKindComboBox;
	Vcl::Stdctrls::TLabel* GaugeKindLabel;
	Vcl::Stdctrls::TComboBox* PointerKindComboBox;
	Vcl::Stdctrls::TLabel* PointerKindLabel;
	Vcl::Stdctrls::TLabel* MinimumLabel;
	Vcl::Stdctrls::TLabel* MaximumLabel;
	Vcl::Stdctrls::TEdit* MinimumEdit;
	Vcl::Stdctrls::TEdit* MaximumEdit;
	Vcl::Stdctrls::TLabel* MajorStepLabel;
	Vcl::Stdctrls::TEdit* MajorStepEdit;
	Vcl::Stdctrls::TEdit* CurrentValueEdit;
	Vcl::Stdctrls::TLabel* CurrentValueLabel;
	Vcl::Stdctrls::TEdit* MinorStepEdit;
	Vcl::Stdctrls::TLabel* MinorStepLabel;
	Vcl::Stdctrls::TGroupBox* MarginsGroupBox;
	Vcl::Stdctrls::TLabel* TopLabel;
	Vcl::Stdctrls::TLabel* LeftLabel;
	Vcl::Stdctrls::TLabel* BottomLabel;
	Vcl::Stdctrls::TLabel* RightLabel;
	Vcl::Stdctrls::TLabel* BorderWidthLabel;
	Vcl::Extctrls::TColorBox* BorderColorColorBox;
	Vcl::Stdctrls::TLabel* BorderColorLabel;
	Vcl::Stdctrls::TLabel* ColorLabel;
	Vcl::Extctrls::TColorBox* ColorColorBox;
	Vcl::Stdctrls::TLabel* WidthLabel;
	Vcl::Stdctrls::TLabel* HeightLabel;
	Vcl::Stdctrls::TCheckBox* MajorScaleVisibleDigitsCheckBox;
	Vcl::Stdctrls::TCheckBox* MinorScaleVisibleDigitsCheckBox;
	Vcl::Stdctrls::TCheckBox* MajorScaleBilateralCheckBox;
	Vcl::Stdctrls::TCheckBox* MinorScaleBilateralCheckBox;
	Vcl::Stdctrls::TEdit* MinorScaleFormatEdit;
	Vcl::Stdctrls::TLabel* MinorScaleFormatLabel;
	Vcl::Stdctrls::TLabel* MajorScaleFormatLabel;
	Vcl::Stdctrls::TEdit* MajorScaleFormatEdit;
	Vcl::Stdctrls::TButton* MajorScaleFontButton;
	Vcl::Stdctrls::TLabel* MajorScaleFontLabel;
	Vcl::Dialogs::TFontDialog* FontDialog;
	Vcl::Stdctrls::TButton* MinorScaleFontButton;
	Vcl::Stdctrls::TLabel* MinorScaleFontLabel;
	Vcl::Stdctrls::TGroupBox* MajorScaleTicksGroupBox;
	Vcl::Stdctrls::TLabel* MajorScaleTicksWidthLabel;
	Vcl::Stdctrls::TLabel* MajorScaleTicksLengthLabel;
	Vcl::Stdctrls::TLabel* MajorScaleTicksColorLabel;
	Vcl::Extctrls::TColorBox* MajorScaleTicksColorColorBox;
	Vcl::Stdctrls::TGroupBox* MinorScaleTicksGroupBox;
	Vcl::Stdctrls::TLabel* MinorScaleTicksWidthLabel;
	Vcl::Stdctrls::TLabel* MinorScaleTicksLengthLabel;
	Vcl::Stdctrls::TLabel* MinorScaleTicksColorLabel;
	Vcl::Extctrls::TColorBox* MinorScaleTicksColorColorBox;
	Vcl::Stdctrls::TEdit* LeftEdit;
	Vcl::Comctrls::TUpDown* LeftUpDown;
	Vcl::Stdctrls::TEdit* TopEdit;
	Vcl::Comctrls::TUpDown* TopUpDown;
	Vcl::Stdctrls::TEdit* RightEdit;
	Vcl::Comctrls::TUpDown* RightUpDown;
	Vcl::Stdctrls::TEdit* BottomEdit;
	Vcl::Comctrls::TUpDown* BottomUpDown;
	Vcl::Stdctrls::TEdit* MajorScaleTicksWidthEdit;
	Vcl::Comctrls::TUpDown* MajorScaleTicksWidthUpDown;
	Vcl::Comctrls::TUpDown* MajorScaleTicksLengthUpDown;
	Vcl::Stdctrls::TEdit* MajorScaleTicksLengthEdit;
	Vcl::Stdctrls::TEdit* MinorScaleTicksLengthEdit;
	Vcl::Comctrls::TUpDown* MinorScaleTicksLengthUpDown;
	Vcl::Comctrls::TUpDown* MinorScaleTicksWidthUpDown;
	Vcl::Stdctrls::TEdit* MinorScaleTicksWidthEdit;
	Vcl::Stdctrls::TEdit* WidthEdit;
	Vcl::Comctrls::TUpDown* WidthUpDown;
	Vcl::Comctrls::TUpDown* HeightUpDown;
	Vcl::Stdctrls::TEdit* HeightEdit;
	Vcl::Stdctrls::TEdit* BorderWidthEdit;
	Vcl::Comctrls::TUpDown* BorderWidthUpDown;
	Vcl::Stdctrls::TLabel* StartValueLabel;
	Vcl::Stdctrls::TEdit* StartValueEdit;
	Vcl::Stdctrls::TLabel* EndValueLabel;
	Vcl::Stdctrls::TEdit* EndValueEdit;
	Vcl::Stdctrls::TLabel* AngleLabel;
	Vcl::Comctrls::TUpDown* AngleUpDown;
	Vcl::Stdctrls::TEdit* AngleEdit;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall SamplePaintBoxPaint(System::TObject* Sender);
	void __fastcall EditFloatKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall EditIntKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall FillButtonClick(System::TObject* Sender);
	void __fastcall FrameButtonClick(System::TObject* Sender);
	void __fastcall FontButtonClick(System::TObject* Sender);
	void __fastcall ComboBoxChange(System::TObject* Sender);
	void __fastcall EditChange(System::TObject* Sender);
	void __fastcall SpinEditChange(System::TObject* Sender);
	void __fastcall ColorBoxChange(System::TObject* Sender);
	void __fastcall CheckBoxClick(System::TObject* Sender);
	
private:
	Frxgaugeview::TfrxBaseGaugeView* FBaseGaugeView;
	Frxgaugeview::TfrxGaugeView* FGaugeView;
	Frxgaugeview::TfrxGaugeView* FOriginalGaugeView;
	Frxgaugeview::TfrxIntervalGaugeView* FIntervalGaugeView;
	Frxgaugeview::TfrxIntervalGaugeView* FOriginalIntervalGaugeView;
	Frxclass::TfrxCustomDesigner* FReportDesigner;
	void __fastcall Change();
	void __fastcall SetBaseGaugeView(Frxgaugeview::TfrxBaseGaugeView* const Value);
	void __fastcall FontToLabel(Vcl::Graphics::TFont* Font, Vcl::Stdctrls::TLabel* Lbl);
	void __fastcall FontDialogToLabel(Vcl::Graphics::TFont* Font, Vcl::Stdctrls::TLabel* Lbl);
	
public:
	__property Frxgaugeview::TfrxBaseGaugeView* BaseGaugeView = {read=FBaseGaugeView, write=SetBaseGaugeView};
	__property Frxclass::TfrxCustomDesigner* ReportDesigner = {read=FReportDesigner, write=FReportDesigner};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxGaugeEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxGaugeEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxGaugeEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxGaugeEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxGaugeEditorForm* frxGaugeEditorForm;
}	/* namespace Frxgaugeeditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGAUGEEDITOR)
using namespace Frxgaugeeditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgaugeeditorHPP
