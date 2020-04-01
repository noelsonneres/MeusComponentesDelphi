// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDataTree.pas' rev: 33.00 (Windows)

#ifndef FrxdatatreeHPP
#define FrxdatatreeHPP

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
#include <frxClass.hpp>
#include <fs_xml.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Tabs.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdatatree
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDataTreeForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDataTreeForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* DataPn;
	Vcl::Comctrls::TTreeView* DataTree;
	Vcl::Extctrls::TPanel* CBPanel;
	Vcl::Stdctrls::TCheckBox* InsFieldCB;
	Vcl::Stdctrls::TCheckBox* InsCaptionCB;
	Vcl::Extctrls::TPanel* VariablesPn;
	Vcl::Comctrls::TTreeView* VariablesTree;
	Vcl::Extctrls::TPanel* FunctionsPn;
	Vcl::Extctrls::TSplitter* Splitter1;
	Vcl::Forms::TScrollBox* HintPanel;
	Vcl::Stdctrls::TLabel* FunctionDescL;
	Vcl::Stdctrls::TLabel* FunctionNameL;
	Vcl::Comctrls::TTreeView* FunctionsTree;
	Vcl::Extctrls::TPanel* ClassesPn;
	Vcl::Comctrls::TTreeView* ClassesTree;
	Vcl::Forms::TScrollBox* NoDataPn;
	Vcl::Stdctrls::TLabel* NoDataL;
	Vcl::Stdctrls::TCheckBox* SortCB;
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall DataTreeCustomDrawItem(Vcl::Comctrls::TCustomTreeView* Sender, Vcl::Comctrls::TTreeNode* Node, Vcl::Comctrls::TCustomDrawState State, bool &DefaultDraw);
	void __fastcall FunctionsTreeChange(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall DataTreeDblClick(System::TObject* Sender);
	void __fastcall ClassesTreeExpanding(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node, bool &AllowExpansion);
	void __fastcall ClassesTreeCustomDrawItem(Vcl::Comctrls::TCustomTreeView* Sender, Vcl::Comctrls::TTreeNode* Node, Vcl::Comctrls::TCustomDrawState State, bool &DefaultDraw);
	void __fastcall SortCBClick(System::TObject* Sender);
	
private:
	Fs_xml::TfsXMLDocument* FXML;
	Vcl::Controls::TImageList* FImages;
	Frxclass::TfrxReport* FReport;
	bool FUpdating;
	bool FFirstTime;
	bool FMultiSelectAllowed;
	Vcl::Tabs::TTabSet* FTabs;
	void __fastcall FillClassesTree();
	void __fastcall FillDataTree();
	void __fastcall FillFunctionsTree();
	void __fastcall FillVariablesTree();
	void __fastcall TabsChange(System::TObject* Sender);
	System::UnicodeString __fastcall GetCollapsedNodes();
	
public:
	__fastcall virtual TfrxDataTreeForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDataTreeForm();
	void __fastcall SetColor_(System::Uitypes::TColor AColor);
	void __fastcall SetControlsParent(Vcl::Controls::TWinControl* AParent);
	void __fastcall SetLastPosition(const System::Types::TPoint &p);
	void __fastcall ShowTab(int Index);
	void __fastcall UpdateItems();
	void __fastcall UpdateSelection();
	void __fastcall UpdateSize();
	void __fastcall CheclMultiSelection();
	int __fastcall GetActivePage();
	System::UnicodeString __fastcall GetFieldName(int SelectionIndex = 0xffffffff);
	Frxclass::TfrxDataSet* __fastcall GetDataSet(int SelectionIndex);
	System::UnicodeString __fastcall ActiveDS();
	System::Types::TPoint __fastcall GetLastPosition();
	bool __fastcall IsDataField();
	int __fastcall GetSelectionCount();
	__property Frxclass::TfrxReport* Report = {read=FReport, write=FReport};
	__property bool MultiSelectAllowed = {read=FMultiSelectAllowed, write=FMultiSelectAllowed, nodefault};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxDataTreeForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxDataTreeForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxdatatree */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDATATREE)
using namespace Frxdatatree;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdatatreeHPP
