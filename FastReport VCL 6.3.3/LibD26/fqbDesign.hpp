// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fqbDesign.pas' rev: 33.00 (Windows)

#ifndef FqbdesignHPP
#define FqbdesignHPP

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
#include <Vcl.ToolWin.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.DBGrids.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Menus.hpp>
#include <Data.DB.hpp>
#include <System.Variants.hpp>
#include <fqbSynmemo.hpp>
#include <fqbClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fqbdesign
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfqbDesigner;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfqbDesigner : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Data::Db::TDataSource* DataSource1;
	Vcl::Dbgrids::TDBGrid* DBGrid1;
	Fqbclass::TfqbGrid* fqbGrid1;
	Fqbsynmemo::TfqbSyntaxMemo* fqbSyntaxMemo1;
	Fqbclass::TfqbTableArea* fqbTableArea1;
	Fqbclass::TfqbTableListBox* fqbTableListBox1;
	Vcl::Controls::TImageList* ImageList2;
	Vcl::Dialogs::TOpenDialog* OpenDialog1;
	Vcl::Comctrls::TPageControl* PageControl1;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Dialogs::TSaveDialog* SaveDialog1;
	Vcl::Extctrls::TSplitter* Splitter1;
	Vcl::Extctrls::TSplitter* Splitter2;
	Vcl::Comctrls::TTabSheet* TabSheet1;
	Vcl::Comctrls::TTabSheet* TabSheet2;
	Vcl::Comctrls::TTabSheet* TabSheet3;
	Vcl::Comctrls::TToolBar* ToolBar1;
	Vcl::Comctrls::TToolButton* ToolButton10;
	Vcl::Comctrls::TToolButton* ToolButton3;
	Vcl::Comctrls::TToolButton* ToolButton4;
	Vcl::Comctrls::TToolButton* ToolButton5;
	Vcl::Comctrls::TToolButton* ToolButton6;
	Vcl::Comctrls::TToolButton* ToolButton7;
	Vcl::Comctrls::TToolButton* ToolButton8;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall TabSheet2Show(System::TObject* Sender);
	void __fastcall TabSheet3Hide(System::TObject* Sender);
	void __fastcall TabSheet3Show(System::TObject* Sender);
	void __fastcall ToolButton10Click(System::TObject* Sender);
	void __fastcall ToolButton3Click(System::TObject* Sender);
	void __fastcall ToolButton4Click(System::TObject* Sender);
	void __fastcall ToolButton6Click(System::TObject* Sender);
	void __fastcall ToolButton7Click(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	
protected:
	void __fastcall LoadPos();
	void __fastcall SavePos();
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfqbDesigner(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfqbDesigner(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfqbDesigner() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbDesigner(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfqbDesigner* fqbDesigner;
}	/* namespace Fqbdesign */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FQBDESIGN)
using namespace Fqbdesign;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FqbdesignHPP
