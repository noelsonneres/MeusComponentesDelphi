// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditSQL.pas' rev: 33.00 (Windows)

#ifndef FrxeditsqlHPP
#define FrxeditsqlHPP

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
#include <frxSynMemo.hpp>
#include <frxCustomDB.hpp>
#include <System.Variants.hpp>
#include <fqbClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditsql
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxSQLEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxSQLEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TToolBar* ToolBar;
	Vcl::Comctrls::TToolButton* OkB;
	Vcl::Comctrls::TToolButton* CancelB;
	Vcl::Comctrls::TToolButton* QBB;
	Vcl::Comctrls::TToolButton* ParamsB;
	Vcl::Comctrls::TToolButton* ToolButton2;
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall CancelBClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall MemoKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall QBBClick(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall ParamsBClick(System::TObject* Sender);
	
private:
	Frxsynmemo::TfrxSyntaxMemo* FMemo;
	Frxcustomdb::TfrxCustomQuery* FQuery;
	Fqbclass::TfqbEngine* FQBEngine;
	System::Classes::TStrings* FSaveSQL;
	System::UnicodeString FSaveSchema;
	Frxcustomdb::TfrxParams* FSaveParams;
	
public:
	__property Frxcustomdb::TfrxCustomQuery* Query = {read=FQuery, write=FQuery};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxSQLEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxSQLEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxSQLEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxSQLEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditsql */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITSQL)
using namespace Frxeditsql;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditsqlHPP
