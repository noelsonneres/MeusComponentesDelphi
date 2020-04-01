// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditHighlight.pas' rev: 33.00 (Windows)

#ifndef FrxedithighlightHPP
#define FrxedithighlightHPP

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
#include <frxClass.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <frxCtrls.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxedithighlight
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxHighlightEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxHighlightEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OKB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TGroupBox* ConditionsGB;
	Vcl::Stdctrls::TListBox* HighlightsLB;
	Vcl::Stdctrls::TButton* AddB;
	Vcl::Stdctrls::TButton* DeleteB;
	Vcl::Stdctrls::TButton* EditB;
	Vcl::Stdctrls::TGroupBox* StyleGB;
	Vcl::Buttons::TSpeedButton* FrameB;
	Vcl::Stdctrls::TCheckBox* FrameCB;
	Vcl::Stdctrls::TCheckBox* FillCB;
	Vcl::Buttons::TSpeedButton* FillB;
	Vcl::Stdctrls::TCheckBox* FontCB;
	Vcl::Buttons::TSpeedButton* FontB;
	Vcl::Stdctrls::TCheckBox* VisibleCB;
	Vcl::Buttons::TSpeedButton* UpB;
	Vcl::Buttons::TSpeedButton* DownB;
	Vcl::Dialogs::TFontDialog* FontDialog1;
	Vcl::Extctrls::TPaintBox* PaintBox1;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall AddBClick(System::TObject* Sender);
	void __fastcall EditBClick(System::TObject* Sender);
	void __fastcall DeleteBClick(System::TObject* Sender);
	void __fastcall HighlightsLBClick(System::TObject* Sender);
	void __fastcall FrameCBClick(System::TObject* Sender);
	void __fastcall FillCBClick(System::TObject* Sender);
	void __fastcall FontCBClick(System::TObject* Sender);
	void __fastcall VisibleCBClick(System::TObject* Sender);
	void __fastcall FrameBClick(System::TObject* Sender);
	void __fastcall FillBClick(System::TObject* Sender);
	void __fastcall FontBClick(System::TObject* Sender);
	void __fastcall PaintBox1Paint(System::TObject* Sender);
	void __fastcall UpBClick(System::TObject* Sender);
	void __fastcall DownBClick(System::TObject* Sender);
	
private:
	Frxclass::TfrxCustomMemoView* FMemoView;
	Frxclass::TfrxHighlightCollection* FHighlights;
	Frxclass::TfrxHighlight* FCurHighlight;
	void __fastcall UpdateHighlights();
	void __fastcall UpdateControls();
	void __fastcall Change();
	
public:
	__fastcall virtual TfrxHighlightEditorForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxHighlightEditorForm();
	void __fastcall HostControls(Vcl::Controls::TWinControl* Host);
	void __fastcall UnhostControls(System::Uitypes::TModalResult AModalResult);
	__property Frxclass::TfrxCustomMemoView* MemoView = {read=FMemoView, write=FMemoView};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxHighlightEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxHighlightEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxedithighlight */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITHIGHLIGHT)
using namespace Frxedithighlight;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxedithighlightHPP
