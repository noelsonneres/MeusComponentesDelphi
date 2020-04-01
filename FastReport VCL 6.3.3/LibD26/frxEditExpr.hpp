// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditExpr.pas' rev: 33.00 (Windows)

#ifndef FrxeditexprHPP
#define FrxeditexprHPP

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
#include <frxClass.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <frxDataTree.hpp>
#include <Vcl.ImgList.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditexpr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxExprEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxExprEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TMemo* ExprMemo;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Extctrls::TSplitter* Splitter1;
	Vcl::Extctrls::TPanel* Panel2;
	Vcl::Stdctrls::TLabel* ExprL;
	Vcl::Extctrls::TPanel* Panel;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall ExprMemoDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall ExprMemoDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormResize(System::TObject* Sender);
	
private:
	Frxdatatree::TfrxDataTreeForm* FDataTree;
	Frxclass::TfrxReport* FReport;
	void __fastcall OnDataTreeDblClick(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxExprEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxExprEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxExprEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxExprEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditexpr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITEXPR)
using namespace Frxeditexpr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditexprHPP
