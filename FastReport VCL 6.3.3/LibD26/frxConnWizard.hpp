// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxConnWizard.pas' rev: 33.00 (Windows)

#ifndef FrxconnwizardHPP
#define FrxconnwizardHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ToolWin.hpp>
#include <frxClass.hpp>
#include <frxSynMemo.hpp>
#include <frxCustomDB.hpp>
#include <System.Variants.hpp>
#include <fqbClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxconnwizard
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDBConnWizard;
class DELPHICLASS TfrxDBTableWizard;
class DELPHICLASS TfrxDBQueryWizard;
class DELPHICLASS TfrxConnectionWizardForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDBConnWizard : public Frxclass::TfrxCustomWizard
{
	typedef Frxclass::TfrxCustomWizard inherited;
	
private:
	Frxclass::TfrxCustomDatabase* FDatabase;
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall Execute();
	__property Frxclass::TfrxCustomDatabase* Database = {read=FDatabase, write=FDatabase};
public:
	/* TfrxCustomWizard.Create */ inline __fastcall virtual TfrxDBConnWizard(System::Classes::TComponent* AOwner) : Frxclass::TfrxCustomWizard(AOwner) { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxDBConnWizard() { }
	
};


class PASCALIMPLEMENTATION TfrxDBTableWizard : public Frxclass::TfrxCustomWizard
{
	typedef Frxclass::TfrxCustomWizard inherited;
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall Execute();
public:
	/* TfrxCustomWizard.Create */ inline __fastcall virtual TfrxDBTableWizard(System::Classes::TComponent* AOwner) : Frxclass::TfrxCustomWizard(AOwner) { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxDBTableWizard() { }
	
};


class PASCALIMPLEMENTATION TfrxDBQueryWizard : public Frxclass::TfrxCustomWizard
{
	typedef Frxclass::TfrxCustomWizard inherited;
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall Execute();
public:
	/* TfrxCustomWizard.Create */ inline __fastcall virtual TfrxDBQueryWizard(System::Classes::TComponent* AOwner) : Frxclass::TfrxCustomWizard(AOwner) { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxDBQueryWizard() { }
	
};


class PASCALIMPLEMENTATION TfrxConnectionWizardForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OKB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Comctrls::TPageControl* PageControl1;
	Vcl::Comctrls::TTabSheet* ConnTS;
	Vcl::Comctrls::TTabSheet* TableTS;
	Vcl::Stdctrls::TLabel* ConnL1;
	Vcl::Stdctrls::TLabel* DBL;
	Vcl::Stdctrls::TLabel* LoginL;
	Vcl::Stdctrls::TLabel* PasswordL;
	Vcl::Buttons::TSpeedButton* ChooseB;
	Vcl::Stdctrls::TComboBox* ConnCB;
	Vcl::Stdctrls::TEdit* DatabaseE;
	Vcl::Stdctrls::TEdit* LoginE;
	Vcl::Stdctrls::TEdit* PasswordE;
	Vcl::Stdctrls::TRadioButton* PromptRB;
	Vcl::Stdctrls::TRadioButton* LoginRB;
	Vcl::Stdctrls::TLabel* ConnL2;
	Vcl::Stdctrls::TComboBox* ConnCB1;
	Vcl::Stdctrls::TLabel* TableL;
	Vcl::Stdctrls::TComboBox* TableCB;
	Vcl::Stdctrls::TCheckBox* FilterCB;
	Vcl::Stdctrls::TEdit* FilterE;
	Vcl::Comctrls::TTabSheet* QueryTS;
	Vcl::Stdctrls::TLabel* ConnL3;
	Vcl::Stdctrls::TComboBox* ConnCB2;
	Vcl::Stdctrls::TLabel* QueryL;
	Vcl::Comctrls::TToolBar* ToolBar1;
	Vcl::Comctrls::TToolButton* BuildSQLB;
	Vcl::Comctrls::TToolButton* ParamsB;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall ChooseBClick(System::TObject* Sender);
	void __fastcall ConnCBClick(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ConnCB1Click(System::TObject* Sender);
	void __fastcall ConnCB2Click(System::TObject* Sender);
	void __fastcall BuildSQLBClick(System::TObject* Sender);
	void __fastcall ParamsBClick(System::TObject* Sender);
	void __fastcall OKBClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	Frxclass::TfrxComponent* FComponent;
	Frxclass::TfrxCustomDatabase* FDatabase;
	Frxclass::TfrxCustomDesigner* FDesigner;
	int FItem;
	int FItemIndex;
	Frxsynmemo::TfrxSyntaxMemo* FMemo;
	int FOldItem;
	Frxclass::TfrxPage* FPage;
	Frxcustomdb::TfrxCustomQuery* FQuery;
	Frxclass::TfrxReport* FReport;
	Frxcustomdb::TfrxCustomTable* FTable;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxConnectionWizardForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxConnectionWizardForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxConnectionWizardForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxConnectionWizardForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxconnwizard */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCONNWIZARD)
using namespace Frxconnwizard;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxconnwizardHPP
