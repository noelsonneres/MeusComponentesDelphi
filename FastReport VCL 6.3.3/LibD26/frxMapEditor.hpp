// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapEditor.pas' rev: 33.00 (Windows)

#ifndef FrxmapeditorHPP
#define FrxmapeditorHPP

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
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <frxCtrls.hpp>
#include <frxDesgnCtrls.hpp>
#include <frxClass.hpp>
#include <frxDsgnIntf.hpp>
#include <frxMap.hpp>
#include <frxMapLayer.hpp>
#include <frxMapRanges.hpp>
#include <frxMapHelpers.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxMapGeodataLayer.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmapeditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMapEditorForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxMapEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* MapGroupBox;
	Vcl::Stdctrls::TButton* OkButton;
	Vcl::Stdctrls::TButton* CancelButton;
	Vcl::Comctrls::TTreeView* MapTreeView;
	Vcl::Buttons::TSpeedButton* UpButton;
	Vcl::Buttons::TSpeedButton* DownButton;
	Vcl::Stdctrls::TButton* AddButton;
	Vcl::Stdctrls::TButton* DeleteButton;
	Vcl::Comctrls::TPageControl* MapOptionsPageControl;
	Vcl::Comctrls::TTabSheet* GeneralTabSheet;
	Vcl::Stdctrls::TCheckBox* MercatorCheckBox;
	Vcl::Comctrls::TTabSheet* ColorScaleTabSheet;
	Vcl::Stdctrls::TGroupBox* ColorScaleTitleGroupBox;
	Vcl::Stdctrls::TGroupBox* ColorScaleValuesGroupBox;
	Vcl::Stdctrls::TLabel* ColorScaleTitleTextLabel;
	Vcl::Stdctrls::TEdit* ColorScaleTitleTextEdit;
	Vcl::Stdctrls::TLabel* ColorScaleValuesFormatLabel;
	Vcl::Stdctrls::TEdit* ColorScaleValuesFormatEdit;
	Vcl::Comctrls::TPageControl* LayerOptionsPageControl;
	Vcl::Comctrls::TTabSheet* DataTabSheet;
	Vcl::Comctrls::TTabSheet* AppearanceTabSheet;
	Vcl::Comctrls::TTabSheet* ColorRangesTabSheet;
	Vcl::Comctrls::TTabSheet* SizeRangesTabSheet;
	Vcl::Comctrls::TTabSheet* LabelsTabSheet;
	Vcl::Stdctrls::TLabel* DataSourceLabel;
	Vcl::Stdctrls::TLabel* FilterLabel;
	Vcl::Stdctrls::TComboBox* DatasetComboBox;
	Frxctrls::TfrxComboEdit* FilterComboEdit;
	Vcl::Stdctrls::TGroupBox* SpatialDataMapLayerGroupBox;
	Vcl::Stdctrls::TLabel* ColumnLabel;
	Vcl::Stdctrls::TLabel* SpatialValueLabel;
	Frxctrls::TfrxComboEdit* SpatialValueComboEdit;
	Vcl::Stdctrls::TComboBox* SpatialColumnComboBox;
	Vcl::Stdctrls::TGroupBox* AnalyticalDataGroupBox;
	Vcl::Stdctrls::TLabel* AnalyticalValueLabel;
	Vcl::Stdctrls::TLabel* FunctionLabel;
	Frxctrls::TfrxComboEdit* AnalyticalValueComboEdit;
	Vcl::Stdctrls::TComboBox* FunctionComboBox;
	Vcl::Stdctrls::TGroupBox* SpatialDataAppLayerGroupBox;
	Vcl::Stdctrls::TLabel* LatitudeLabel;
	Frxctrls::TfrxComboEdit* LatitudeComboEdit;
	Vcl::Stdctrls::TLabel* LongitudeLabel;
	Frxctrls::TfrxComboEdit* LongitudeComboEdit;
	Vcl::Stdctrls::TLabel* LabelLabel;
	Frxctrls::TfrxComboEdit* LabelComboEdit;
	Vcl::Stdctrls::TLabel* ZoomPolygonLabel;
	Frxctrls::TfrxComboEdit* ZoomPolygonComboEdit;
	Vcl::Stdctrls::TCheckBox* LayerVisibleCheckBox;
	Vcl::Stdctrls::TLabel* LayerBorderColorLabel;
	Vcl::Stdctrls::TLabel* LayerBorderStyleLabel;
	Vcl::Stdctrls::TComboBox* LayerBorderStyleComboBox;
	Vcl::Stdctrls::TLabel* LayerBorderWidthLabel;
	Vcl::Stdctrls::TLabel* LayerFillColorLabel;
	Vcl::Stdctrls::TLabel* LayerPaletteLabel;
	Vcl::Stdctrls::TComboBox* LayerPaletteComboBox;
	Vcl::Stdctrls::TCheckBox* ColorRangeVisibleCheckBox;
	Vcl::Stdctrls::TLabel* StartColorLabel;
	Vcl::Stdctrls::TLabel* MiddleColorLabel;
	Vcl::Stdctrls::TLabel* EndColorLabel;
	Vcl::Stdctrls::TLabel* NumColorRangesLabel;
	Vcl::Stdctrls::TLabel* StartSizeLabel;
	Vcl::Stdctrls::TLabel* EndSizeLabel;
	Vcl::Stdctrls::TLabel* NumSizeRangesLabel;
	Vcl::Stdctrls::TLabel* LabelColumnLabel;
	Vcl::Stdctrls::TComboBox* LabelColumnComboBox;
	Vcl::Stdctrls::TLabel* LabelFormatLabel;
	Vcl::Stdctrls::TEdit* LabelFormatEdit;
	Vcl::Dialogs::TFontDialog* FontDialog;
	Vcl::Stdctrls::TButton* ColorScaleTitleFontButton;
	Vcl::Stdctrls::TLabel* ColorScaleTitleFontSampleLabel;
	Vcl::Stdctrls::TLabel* ColorScaleValuesFontSampleLabel;
	Vcl::Stdctrls::TButton* ColorScaleValuesFontButton;
	Vcl::Extctrls::TPaintBox* MapSamplePaintBox;
	Vcl::Stdctrls::TCheckBox* KeepAspectCheckBox;
	Vcl::Stdctrls::TCheckBox* ColorScaleVisibleCheckBox;
	Vcl::Extctrls::TColorBox* ColorBorderColorBox;
	Vcl::Stdctrls::TLabel* ColorBorderWidthLabel;
	Vcl::Stdctrls::TLabel* ColorBorderColorLabel;
	Vcl::Buttons::TSpeedButton* ColorTopLeftSpeedButton;
	Vcl::Buttons::TSpeedButton* ColorMiddleCenterSpeedButton;
	Vcl::Buttons::TSpeedButton* ColorBottomRightSpeedButton;
	Vcl::Buttons::TSpeedButton* ColorBottomCenterSpeedButton;
	Vcl::Buttons::TSpeedButton* ColorBottomLeftSpeedButton;
	Vcl::Buttons::TSpeedButton* ColorMiddleRightSpeedButton;
	Vcl::Buttons::TSpeedButton* ColorMiddleLeftSpeedButton;
	Vcl::Buttons::TSpeedButton* ColorTopRightSpeedButton;
	Vcl::Buttons::TSpeedButton* ColorTopCenterSpeedButton;
	Vcl::Stdctrls::TLabel* ColorScaleDockLabel;
	Vcl::Comctrls::TTabSheet* SizeScaleTabSheet;
	Vcl::Stdctrls::TCheckBox* SizeScaleVisibleCheckBox;
	Vcl::Extctrls::TColorBox* SizeBorderColorBox;
	Vcl::Stdctrls::TGroupBox* SizeScaleValuesGroupBox;
	Vcl::Stdctrls::TLabel* SizeScaleValuesFormatLabel;
	Vcl::Stdctrls::TLabel* SizeScaleValuesFontSampleLabel;
	Vcl::Stdctrls::TEdit* SizeScaleValuesFormatEdit;
	Vcl::Stdctrls::TButton* SizeScaleValuesFontButton;
	Vcl::Stdctrls::TGroupBox* SizeScaleTitleGroupBox;
	Vcl::Stdctrls::TLabel* SizeScaleTitleTextLabel;
	Vcl::Stdctrls::TLabel* SizeScaleTitleFontSampleLabel;
	Vcl::Stdctrls::TEdit* SizeScaleTitleTextEdit;
	Vcl::Stdctrls::TButton* SizeScaleTitleFontButton;
	Vcl::Stdctrls::TLabel* SizeScaleDockLabel;
	Vcl::Buttons::TSpeedButton* SizeTopCenterSpeedButton;
	Vcl::Buttons::TSpeedButton* SizeTopRightSpeedButton;
	Vcl::Buttons::TSpeedButton* SizeMiddleLeftSpeedButton;
	Vcl::Buttons::TSpeedButton* SizeMiddleRightSpeedButton;
	Vcl::Buttons::TSpeedButton* SizeBottomLeftSpeedButton;
	Vcl::Buttons::TSpeedButton* SizeBottomCenterSpeedButton;
	Vcl::Buttons::TSpeedButton* SizeBottomRightSpeedButton;
	Vcl::Buttons::TSpeedButton* SizeMiddleCenterSpeedButton;
	Vcl::Buttons::TSpeedButton* SizeTopLeftSpeedButton;
	Vcl::Stdctrls::TLabel* SizeBorderColorLabel;
	Vcl::Stdctrls::TLabel* SizeBorderWidthLabel;
	Vcl::Extctrls::TColorBox* LayerBorderColorColorBox;
	Vcl::Extctrls::TColorBox* LayerFillColorColorBox;
	Vcl::Stdctrls::TLabel* LayerPointSizeLabel;
	Vcl::Stdctrls::TComboBox* ColorRangeFactorComboBox;
	Vcl::Stdctrls::TLabel* ColorRangeFactorLabel;
	Vcl::Extctrls::TColorBox* StartColorColorBox;
	Vcl::Extctrls::TColorBox* MiddleColorColorBox;
	Vcl::Extctrls::TColorBox* EndColorColorBox;
	Vcl::Stdctrls::TCheckBox* SizeRangeVisibleCheckBox;
	Vcl::Stdctrls::TComboBox* SizeRangeFactorComboBox;
	Vcl::Stdctrls::TLabel* SizeRangeFactorLabel;
	Vcl::Stdctrls::TLabel* LabelKindLabel;
	Vcl::Stdctrls::TComboBox* LabelKindComboBox;
	Vcl::Stdctrls::TButton* LabelFontButton;
	Vcl::Stdctrls::TLabel* LabelFontLabel;
	Vcl::Stdctrls::TButton* FillButton;
	Vcl::Stdctrls::TButton* FrameButton;
	Vcl::Stdctrls::TLabel* LayerHighlightColorLabel;
	Vcl::Extctrls::TColorBox* LayerHighlightColorColorBox;
	Vcl::Stdctrls::TEdit* ColorBorderWidthEdit;
	Vcl::Comctrls::TUpDown* ColorBorderWidthUpDown;
	Vcl::Stdctrls::TEdit* SizeBorderWidthEdit;
	Vcl::Comctrls::TUpDown* SizeBorderWidthUpDown;
	Vcl::Stdctrls::TEdit* LayerBorderWidthEdit;
	Vcl::Comctrls::TUpDown* LayerBorderWidthUpDown;
	Vcl::Stdctrls::TEdit* LayerPointSizeEdit;
	Vcl::Comctrls::TUpDown* LayerPointSizeUpDown;
	Vcl::Stdctrls::TEdit* NumColorRangesEdit;
	Vcl::Comctrls::TUpDown* NumColorRangesUpDown;
	Vcl::Stdctrls::TEdit* NumSizeRangesEdit;
	Vcl::Comctrls::TUpDown* NumSizeRangesUpDown;
	Vcl::Stdctrls::TEdit* StartSizeEdit;
	Vcl::Comctrls::TUpDown* StartSizeUpDown;
	Vcl::Stdctrls::TEdit* EndSizeEdit;
	Vcl::Comctrls::TUpDown* EndSizeUpDown;
	Vcl::Stdctrls::TButton* CREditBtn;
	Vcl::Stdctrls::TButton* SREditBtn;
	Vcl::Stdctrls::TGroupBox* GeodataLayerGroupBox;
	Vcl::Stdctrls::TComboBox* DataColumnComboBox;
	Vcl::Stdctrls::TLabel* DataColumnLabel;
	Vcl::Stdctrls::TLabel* BorderColorLabel;
	Vcl::Stdctrls::TLabel* FillColorLabel;
	Vcl::Stdctrls::TComboBox* BorderColorColumnComboBox;
	Vcl::Stdctrls::TComboBox* FillColorColumnComboBox;
	void __fastcall AddButtonClick(System::TObject* Sender);
	void __fastcall DeleteButtonClick(System::TObject* Sender);
	void __fastcall UpButtonClick(System::TObject* Sender);
	void __fastcall DownButtonClick(System::TObject* Sender);
	void __fastcall MapTreeViewChange(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall MapSamplePaintBoxPaint(System::TObject* Sender);
	void __fastcall ComboBoxChange(System::TObject* Sender);
	void __fastcall ComboEditButtonClick(System::TObject* Sender);
	void __fastcall ComboEditChange(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall ColorBoxChange(System::TObject* Sender);
	void __fastcall SpinEditChange(System::TObject* Sender);
	void __fastcall EditIntKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall DockSpeedButtonClick(System::TObject* Sender);
	void __fastcall EditChange(System::TObject* Sender);
	void __fastcall CheckBoxClick(System::TObject* Sender);
	void __fastcall FontButtonClick(System::TObject* Sender);
	void __fastcall FillButtonClick(System::TObject* Sender);
	void __fastcall FrameButtonClick(System::TObject* Sender);
	void __fastcall CREditBtnClick(System::TObject* Sender);
	void __fastcall SREditBtnClick(System::TObject* Sender);
	
private:
	Frxmap::TfrxMapView* FMap;
	System::UnicodeString FLayerName;
	Frxmap::TfrxMapView* FOriginalMap;
	Frxclass::TfrxReport* FReport;
	Frxclass::TfrxCustomDesigner* FReportDesigner;
	bool FRefreshEnabled;
	void __fastcall SetMap(Frxmap::TfrxMapView* AMap);
	void __fastcall PopulateMapTree(int SelectedIndex = 0xffffffff);
	void __fastcall PopulateMapOptions();
	void __fastcall PopulateLayerOptions();
	Frxmaplayer::TfrxCustomLayer* __fastcall SelectedLayer();
	Frxmaphelpers::TLayerType __fastcall SelectedLayerType();
	Frxmaplayer::TfrxMapFileLayer* __fastcall SelectedMapFileLayer();
	Frxmaplayer::TfrxApplicationLayer* __fastcall SelectedApplicationLayer();
	Frxmapgeodatalayer::TfrxMapGeodataLayer* __fastcall SelectedGeodataLayer();
	bool __fastcall IsGetSelectedLayerIndex(/* out */ int &Index);
	void __fastcall Change();
	void __fastcall FontToLabel(Vcl::Graphics::TFont* Font, Vcl::Stdctrls::TLabel* Lbl);
	void __fastcall FontDialogToLabel(Vcl::Graphics::TFont* Font, Vcl::Stdctrls::TLabel* Lbl);
	
protected:
	void __fastcall SelectLayer(System::UnicodeString LayerName);
	
public:
	__property Frxmap::TfrxMapView* Map = {read=FMap, write=SetMap};
	__property Frxclass::TfrxCustomDesigner* ReportDesigner = {read=FReportDesigner, write=FReportDesigner};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxMapEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxMapEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxMapEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxMapEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxmapeditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPEDITOR)
using namespace Frxmapeditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmapeditorHPP
