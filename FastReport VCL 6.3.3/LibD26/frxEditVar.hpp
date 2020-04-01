// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEditVar.pas' rev: 33.00 (Windows)

#ifndef FrxeditvarHPP
#define FrxeditvarHPP

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
#include <frxDock.hpp>
#include <frxVariables.hpp>
#include <frxDataTree.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.ToolWin.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxeditvar
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxVarEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxVarEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TTreeView* VarTree;
	Vcl::Comctrls::TToolBar* ToolBar;
	Vcl::Comctrls::TToolButton* NewCategoryB;
	Vcl::Comctrls::TToolButton* NewVarB;
	Vcl::Comctrls::TToolButton* EditB;
	Vcl::Comctrls::TToolButton* DeleteB;
	Vcl::Comctrls::TToolButton* EditListB;
	Vcl::Comctrls::TToolButton* OkB;
	Vcl::Comctrls::TToolButton* CancelB;
	Vcl::Comctrls::TToolButton* Sep1;
	Vcl::Stdctrls::TMemo* ExprMemo;
	Vcl::Extctrls::TSplitter* Splitter1;
	Vcl::Extctrls::TSplitter* Splitter2;
	Vcl::Extctrls::TPanel* ExprPanel;
	Vcl::Comctrls::TToolButton* LoadB;
	Vcl::Comctrls::TToolButton* SaveB;
	Vcl::Comctrls::TToolButton* Sep2;
	Vcl::Dialogs::TOpenDialog* OpenDialog1;
	Vcl::Dialogs::TSaveDialog* SaveDialog1;
	Vcl::Extctrls::TPanel* Panel;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall DeleteBClick(System::TObject* Sender);
	void __fastcall NewCategoryBClick(System::TObject* Sender);
	void __fastcall NewVarBClick(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall EditBClick(System::TObject* Sender);
	void __fastcall VarTreeEdited(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node, System::UnicodeString &S);
	void __fastcall VarTreeKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall ExprMemoDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall ExprMemoDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall VarTreeChange(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall VarTreeChanging(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node, bool &AllowChange);
	void __fastcall CancelBClick(System::TObject* Sender);
	void __fastcall EditListBClick(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall LoadBClick(System::TObject* Sender);
	void __fastcall SaveBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall Splitter2Moved(System::TObject* Sender);
	
private:
	Frxclass::TfrxReport* FReport;
	bool FUpdating;
	Frxvariables::TfrxVariables* FVariables;
	Frxdatatree::TfrxDataTreeForm* FDataTree;
	bool FIsInheritedReport;
	Vcl::Comctrls::TTreeNode* __fastcall Root();
	void __fastcall CreateUniqueName(System::UnicodeString &s);
	void __fastcall FillVariables();
	void __fastcall UpdateItem0();
	void __fastcall OnDataTreeDblClick(System::TObject* Sender);
	void __fastcall UpdateControls();
	
public:
	__property bool IsInheritedReport = {read=FIsInheritedReport, write=FIsInheritedReport, nodefault};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxVarEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxVarEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxVarEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxVarEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxeditvar */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEDITVAR)
using namespace Frxeditvar;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxeditvarHPP
