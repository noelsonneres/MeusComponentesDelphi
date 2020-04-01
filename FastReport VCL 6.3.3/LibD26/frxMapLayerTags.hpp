// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapLayerTags.pas' rev: 33.00 (Windows)

#ifndef FrxmaplayertagsHPP
#define FrxmaplayertagsHPP

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
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <frxMapHelpers.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmaplayertags
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TMapLayerTagsForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TMapLayerTagsForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TLabel* FileTagsLabel;
	Vcl::Stdctrls::TListBox* LayerTagsListBox;
	Vcl::Stdctrls::TLabel* LayerTagsLabel;
	Vcl::Stdctrls::TLabel* FilterLabel;
	Vcl::Stdctrls::TEdit* FilterEdit;
	Vcl::Stdctrls::TButton* LayerAddButton;
	Vcl::Stdctrls::TButton* LayerDeleteButton;
	Vcl::Comctrls::TListView* FileTagsListView;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FileTagsListViewColumnClick(System::TObject* Sender, Vcl::Comctrls::TListColumn* Column);
	void __fastcall LayerAddButtonClick(System::TObject* Sender);
	void __fastcall LayerDeleteButtonClick(System::TObject* Sender);
	void __fastcall FilterEditKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall FilterEditChange(System::TObject* Sender);
	
protected:
	Frxmaphelpers::TfrxSumStringList* FSumTags;
	int FTagId;
	void __fastcall FillFileTags();
	bool __fastcall IsInLayerTags(System::UnicodeString st);
	bool __fastcall IsEditFilter(System::UnicodeString st);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TMapLayerTagsForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TMapLayerTagsForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TMapLayerTagsForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TMapLayerTagsForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall EditLayerTags(Frxmaphelpers::TfrxSumStringList* FileTags, System::Classes::TStringList* LayerTags, System::Classes::TComponent* Owner = (System::Classes::TComponent*)(0x0));
}	/* namespace Frxmaplayertags */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPLAYERTAGS)
using namespace Frxmaplayertags;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmaplayertagsHPP
