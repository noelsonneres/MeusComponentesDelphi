// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxReportTree.pas' rev: 33.00 (Windows)

#ifndef FrxreporttreeHPP
#define FrxreporttreeHPP

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
#include <Vcl.ComCtrls.hpp>
#include <frxClass.hpp>
#include <System.Types.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxreporttree
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxReportTreeForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxReportTreeForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TTreeView* Tree;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall TreeChange(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall TreeKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall TreeDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall TreeDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall TreeMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	
private:
	System::Classes::TList* FComponents;
	Frxclass::TfrxCustomDesigner* FDesigner;
	System::Classes::TList* FNodes;
	Frxclass::TfrxReport* FReport;
	bool FUpdating;
	System::Classes::TNotifyEvent FOnSelectionChanged;
	System::Classes::TList* FSelectedNodeList;
	
public:
	__fastcall virtual TfrxReportTreeForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxReportTreeForm();
	void __fastcall SetColor_(System::Uitypes::TColor Value);
	void __fastcall UpdateItems();
	void __fastcall UpdateSelection();
	__property System::Classes::TNotifyEvent OnSelectionChanged = {read=FOnSelectionChanged, write=FOnSelectionChanged};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxReportTreeForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxReportTreeForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxreporttree */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXREPORTTREE)
using namespace Frxreporttree;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxreporttreeHPP
