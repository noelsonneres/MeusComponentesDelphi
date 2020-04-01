// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditOptions.pas' rev: 33.00 (Windows)

#ifndef FrxeditoptionsHPP
#define FrxeditoptionsHPP

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
#include <frxCtrls.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditoptions
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxOptionsEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxOptionsEditor : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Dialogs::TColorDialog* ColorDialog;
	Vcl::Stdctrls::TButton* RestoreDefaultsB;
	Vcl::Stdctrls::TGroupBox* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* Label13;
	Vcl::Stdctrls::TLabel* Label14;
	Vcl::Stdctrls::TLabel* Label15;
	Vcl::Stdctrls::TLabel* Label16;
	Vcl::Stdctrls::TRadioButton* CMRB;
	Vcl::Stdctrls::TRadioButton* InchesRB;
	Vcl::Stdctrls::TRadioButton* PixelsRB;
	Vcl::Stdctrls::TEdit* CME;
	Vcl::Stdctrls::TEdit* InchesE;
	Vcl::Stdctrls::TEdit* PixelsE;
	Vcl::Stdctrls::TEdit* DialogFormE;
	Vcl::Stdctrls::TCheckBox* ShowGridCB;
	Vcl::Stdctrls::TCheckBox* AlignGridCB;
	Vcl::Stdctrls::TGroupBox* Label6;
	Vcl::Stdctrls::TLabel* Label7;
	Vcl::Stdctrls::TLabel* Label8;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Stdctrls::TLabel* Label10;
	Vcl::Stdctrls::TComboBox* CodeWindowFontCB;
	Vcl::Stdctrls::TComboBox* CodeWindowSizeCB;
	Vcl::Stdctrls::TComboBox* MemoEditorFontCB;
	Vcl::Stdctrls::TComboBox* MemoEditorSizeCB;
	Vcl::Stdctrls::TCheckBox* ObjectFontCB;
	Vcl::Stdctrls::TGroupBox* Label11;
	Vcl::Extctrls::TPaintBox* WorkspacePB;
	Vcl::Extctrls::TPaintBox* ToolPB;
	Vcl::Stdctrls::TButton* WorkspaceB;
	Vcl::Stdctrls::TButton* ToolB;
	Vcl::Stdctrls::TCheckBox* LCDCB;
	Vcl::Stdctrls::TGroupBox* Label5;
	Vcl::Stdctrls::TLabel* Label12;
	Vcl::Stdctrls::TLabel* Label17;
	Vcl::Stdctrls::TCheckBox* EditAfterInsCB;
	Vcl::Stdctrls::TCheckBox* FreeBandsCB;
	Vcl::Stdctrls::TEdit* GapE;
	Vcl::Stdctrls::TCheckBox* BandsCaptionsCB;
	Vcl::Stdctrls::TCheckBox* StartupCB;
	Vcl::Stdctrls::TCheckBox* GuidesStickCB;
	Vcl::Stdctrls::TCheckBox* GuidesAsAnchorCB;
	Vcl::Stdctrls::TGroupBox* CCGB;
	Vcl::Stdctrls::TCheckBox* ShowScriptVARCB;
	Vcl::Stdctrls::TCheckBox* ShowADDVARCB;
	Vcl::Stdctrls::TCheckBox* ShowRttiVARCB;
	Vcl::Stdctrls::TEdit* TBE;
	Vcl::Stdctrls::TLabel* Label18;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall WorkspacePBPaint(System::TObject* Sender);
	void __fastcall ToolPBPaint(System::TObject* Sender);
	void __fastcall WorkspaceBClick(System::TObject* Sender);
	void __fastcall ToolBClick(System::TObject* Sender);
	void __fastcall RestoreDefaultsBClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	System::Uitypes::TColor FWColor;
	System::Uitypes::TColor FTColor;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxOptionsEditor(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxOptionsEditor(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxOptionsEditor() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxOptionsEditor(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditoptions */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITOPTIONS)
using namespace Frxeditoptions;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditoptionsHPP
