// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditMemo.pas' rev: 33.00 (Windows)

#ifndef FrxeditmemoHPP
#define FrxeditmemoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ToolWin.hpp>
#include <frxClass.hpp>
#include <frxEditFormat.hpp>
#include <frxEditHighlight.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditmemo
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMemoEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxMemoEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TPageControl* PageControl1;
	Vcl::Comctrls::TTabSheet* TextTS;
	Vcl::Comctrls::TTabSheet* FormatTS;
	Vcl::Comctrls::TTabSheet* HighlightTS;
	Vcl::Comctrls::TToolBar* ToolBar;
	Vcl::Comctrls::TToolButton* ExprB;
	Vcl::Comctrls::TToolButton* AggregateB;
	Vcl::Comctrls::TToolButton* WordWrapB;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall WordWrapBClick(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall MemoKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall ExprBClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall AggregateBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PageControl1Change(System::TObject* Sender);
	
private:
	Frxeditformat::TfrxFormatEditorForm* FFormat;
	Frxedithighlight::TfrxHighlightEditorForm* FHighlight;
	Frxclass::TfrxCustomMemoView* FMemoView;
	bool FIsUnicode;
	System::WideString FText;
	
public:
	Vcl::Stdctrls::TMemo* Memo;
	__property Frxclass::TfrxCustomMemoView* MemoView = {read=FMemoView, write=FMemoView};
	__property System::WideString Text = {read=FText, write=FText};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxMemoEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxMemoEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxMemoEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxMemoEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditmemo */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITMEMO)
using namespace Frxeditmemo;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditmemoHPP
