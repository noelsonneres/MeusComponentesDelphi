// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditFill.pas' rev: 33.00 (Windows)

#ifndef FrxeditfillHPP
#define FrxeditfillHPP

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
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxClass.hpp>
#include <frxDesgnCtrls.hpp>
#include <System.Variants.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditfill
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxFillEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxFillEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TPageControl* PageControl;
	Vcl::Comctrls::TTabSheet* BrushTS;
	Vcl::Comctrls::TTabSheet* GradientTS;
	Vcl::Comctrls::TTabSheet* GlassTS;
	Vcl::Stdctrls::TLabel* BrushBackColorL;
	Vcl::Stdctrls::TLabel* BrushForeColorL;
	Vcl::Stdctrls::TLabel* BrushStyleL;
	Vcl::Stdctrls::TComboBox* BrushStyleCB;
	Vcl::Stdctrls::TLabel* GradientStyleL;
	Vcl::Stdctrls::TComboBox* GradientStyleCB;
	Vcl::Stdctrls::TLabel* GradientStartColorL;
	Vcl::Stdctrls::TLabel* GradientEndColorL;
	Vcl::Stdctrls::TLabel* GlassOrientationL;
	Vcl::Stdctrls::TComboBox* GlassOrientationCB;
	Vcl::Stdctrls::TLabel* GlassColorL;
	Vcl::Stdctrls::TLabel* GlassBlendL;
	Vcl::Stdctrls::TCheckBox* GlassHatchCB;
	Vcl::Stdctrls::TButton* OKB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Extctrls::TPanel* SampleP;
	Vcl::Stdctrls::TEdit* GlassBlendE;
	Vcl::Extctrls::TPaintBox* PaintBox1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall PaintBox1Paint(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall BrushStyleCBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall PageControlChange(System::TObject* Sender);
	void __fastcall BrushStyleCBChange(System::TObject* Sender);
	void __fastcall GradientStyleCBChange(System::TObject* Sender);
	void __fastcall GlassOrientationCBChange(System::TObject* Sender);
	void __fastcall GlassHatchCBClick(System::TObject* Sender);
	void __fastcall GlassBlendEExit(System::TObject* Sender);
	
private:
	Frxclass::TfrxBrushFill* FBrushFill;
	Frxclass::TfrxGradientFill* FGradientFill;
	Frxclass::TfrxGlassFill* FGlassFill;
	bool FIsSimpleFill;
	Frxdesgnctrls::TfrxColorComboBox* BrushBackColorCB;
	Frxdesgnctrls::TfrxColorComboBox* BrushForeColorCB;
	Frxdesgnctrls::TfrxColorComboBox* GradientStartColorCB;
	Frxdesgnctrls::TfrxColorComboBox* GradientEndColorCB;
	Frxdesgnctrls::TfrxColorComboBox* GlassColorCB;
	Frxclass::TfrxCustomFill* __fastcall GetFill();
	void __fastcall SetFill(Frxclass::TfrxCustomFill* Value);
	void __fastcall SetIsSimpleFill(bool Value);
	void __fastcall UpdateControls();
	void __fastcall Change();
	void __fastcall BrushBackColorChanged(System::TObject* Sender);
	void __fastcall BrushForeColorChanged(System::TObject* Sender);
	void __fastcall GradientStartColorChanged(System::TObject* Sender);
	void __fastcall GradientEndColorChanged(System::TObject* Sender);
	void __fastcall GlassColorChanged(System::TObject* Sender);
	
public:
	__property Frxclass::TfrxCustomFill* Fill = {read=GetFill, write=SetFill};
	__property bool IsSimpleFill = {read=FIsSimpleFill, write=SetIsSimpleFill, nodefault};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxFillEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxFillEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxFillEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxFillEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditfill */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITFILL)
using namespace Frxeditfill;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditfillHPP
