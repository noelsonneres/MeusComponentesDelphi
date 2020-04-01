// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxChartEditor.pas' rev: 33.00 (Windows)

#ifndef FrxcharteditorHPP
#define FrxcharteditorHPP

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
#include <Vcl.Menus.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <frxClass.hpp>
#include <frxChart.hpp>
#include <frxCustomEditors.hpp>
#include <frxCtrls.hpp>
#include <frxInsp.hpp>
#include <frxDock.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ImgList.hpp>
#include <VCLTee.TeeProcs.hpp>
#include <VCLTee.TeEngine.hpp>
#include <VCLTee.Chart.hpp>
#include <VCLTee.Series.hpp>
#include <VCLTee.TeeGalleryAlternate.hpp>
#include <System.Variants.hpp>
#include <frxDsgnIntf.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxcharteditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxChartEditor;
class DELPHICLASS TfrxHackReport;
class DELPHICLASS TfrxChartEditorForm;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxChartEditor : public Frxcustomeditors::TfrxViewEditor
{
	typedef Frxcustomeditors::TfrxViewEditor inherited;
	
public:
	virtual bool __fastcall Edit();
	virtual bool __fastcall HasEditor();
	virtual void __fastcall GetMenuItems();
	virtual bool __fastcall Execute(int Tag, bool Checked);
public:
	/* TfrxComponentEditor.Create */ inline __fastcall virtual TfrxChartEditor(Frxclass::TfrxComponent* Component, Frxclass::TfrxCustomDesigner* Designer, Vcl::Menus::TMenu* Menu) : Frxcustomeditors::TfrxViewEditor(Component, Designer, Menu) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxChartEditor() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxHackReport : public Frxclass::TfrxReport
{
	typedef Frxclass::TfrxReport inherited;
	
public:
	/* TfrxReport.Create */ inline __fastcall virtual TfrxHackReport(System::Classes::TComponent* AOwner) : Frxclass::TfrxReport(AOwner) { }
	/* TfrxReport.Destroy */ inline __fastcall virtual ~TfrxHackReport() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxHackReport(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxReport(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxChartEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Extctrls::TPanel* Panel2;
	Vcl::Controls::TImageList* ChartImages;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Extctrls::TPanel* SourcePanel;
	Vcl::Stdctrls::TGroupBox* DataSourceGB;
	Vcl::Stdctrls::TRadioButton* DBSourceRB;
	Vcl::Stdctrls::TRadioButton* BandSourceRB;
	Vcl::Stdctrls::TRadioButton* FixedDataRB;
	Vcl::Stdctrls::TComboBox* DatasetsCB;
	Vcl::Stdctrls::TComboBox* DatabandsCB;
	Vcl::Stdctrls::TGroupBox* ValuesGB;
	Vcl::Stdctrls::TComboBox* Values1CB;
	Vcl::Stdctrls::TLabel* Values1L;
	Vcl::Stdctrls::TLabel* Values2L;
	Vcl::Stdctrls::TComboBox* Values2CB;
	Vcl::Stdctrls::TLabel* Values3L;
	Vcl::Stdctrls::TComboBox* Values3CB;
	Vcl::Stdctrls::TLabel* Values4L;
	Vcl::Stdctrls::TComboBox* Values4CB;
	Vcl::Stdctrls::TGroupBox* OptionsGB;
	Vcl::Stdctrls::TLabel* ShowTopLbl;
	Vcl::Stdctrls::TLabel* CaptionLbl;
	Vcl::Stdctrls::TLabel* SortLbl;
	Vcl::Stdctrls::TLabel* XLbl;
	Vcl::Stdctrls::TEdit* TopNE;
	Vcl::Stdctrls::TEdit* TopNCaptionE;
	Vcl::Stdctrls::TComboBox* SortCB;
	Vcl::Comctrls::TUpDown* UpDown1;
	Vcl::Stdctrls::TComboBox* XTypeCB;
	Vcl::Extctrls::TPanel* InspSite;
	Vcl::Stdctrls::TLabel* Values5L;
	Vcl::Stdctrls::TComboBox* Values5CB;
	Vcl::Stdctrls::TLabel* HintL;
	Vcl::Stdctrls::TLabel* Values6L;
	Vcl::Stdctrls::TComboBox* Values6CB;
	Vcl::Extctrls::TPanel* Panel3;
	Vcl::Comctrls::TTreeView* ChartTree;
	Vcl::Extctrls::TPanel* TreePanel;
	Vcl::Buttons::TSpeedButton* AddB;
	Vcl::Buttons::TSpeedButton* DeleteB;
	Vcl::Buttons::TSpeedButton* EditB;
	Vcl::Buttons::TSpeedButton* UPB;
	Vcl::Buttons::TSpeedButton* DownB;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ChartTreeClick(System::TObject* Sender);
	void __fastcall AddBClick(System::TObject* Sender);
	void __fastcall DeleteBClick(System::TObject* Sender);
	void __fastcall DoClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall UpDown1Click(System::TObject* Sender, Vcl::Comctrls::TUDBtnType Button);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall DatasetsCBClick(System::TObject* Sender);
	void __fastcall DatabandsCBClick(System::TObject* Sender);
	void __fastcall DBSourceRBClick(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall EditBClick(System::TObject* Sender);
	void __fastcall ChartTreeEdited(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node, System::UnicodeString &S);
	void __fastcall ChartTreeEditing(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node, bool &AllowEdit);
	void __fastcall UPBClick(System::TObject* Sender);
	void __fastcall DownBClick(System::TObject* Sender);
	void __fastcall ChartTreeChange(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	
private:
	Frxchart::TfrxChartView* FChart;
	Frxchart::TfrxSeriesItem* FCurSeries;
	Frxinsp::TfrxObjectInspector* FInspector;
	bool FModified;
	Frxclass::TfrxReport* FReport;
	bool FUpdating;
	int FValuesGBHeight;
	Frxclass::TfrxCustomDesigner* FDesigner;
	void __fastcall FillDropDownLists(Frxclass::TfrxDataSet* ds);
	void __fastcall SetCurSeries(Frxchart::TfrxSeriesItem* const Value);
	void __fastcall SetModified(const bool Value);
	void __fastcall ShowSeriesData();
	void __fastcall UpdateSeriesData();
	__property bool Modified = {read=FModified, write=SetModified, nodefault};
	__property Frxchart::TfrxSeriesItem* CurSeries = {read=FCurSeries, write=SetCurSeries};
	
public:
	__fastcall virtual TfrxChartEditorForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxChartEditorForm();
	__property Frxchart::TfrxChartView* Chart = {read=FChart, write=FChart};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxChartEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxChartEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxcharteditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCHARTEDITOR)
using namespace Frxcharteditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxcharteditorHPP
