// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapLayer.pas' rev: 33.00 (Windows)

#ifndef FrxmaplayerHPP
#define FrxmaplayerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <frxClass.hpp>
#include <System.Contnrs.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <frxMapShape.hpp>
#include <frxMapHelpers.hpp>
#include <frxDsgnIntf.hpp>
#include <frxMapColorRangeForm.hpp>
#include <frxMapSizeRangeForm.hpp>
#include <frxMapRanges.hpp>
#include <frxAnaliticGeometry.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmaplayer
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOperationCalculator;
class DELPHICLASS TValuesList;
class DELPHICLASS TfrxCustomLayer;
class DELPHICLASS TMapLayerList;
class DELPHICLASS TfrxMapFileLayer;
class DELPHICLASS TfrxApplicationLayer;
class DELPHICLASS TfrxLabelColumnProperty;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TMapOperation : unsigned char { opSum, opAverage, opMin, opMax, opCount };

enum DECLSPEC_DENUM TMapLabelKind : unsigned char { mlNone, mlName, mlValue, mlNameAndValue };

enum DECLSPEC_DENUM TMapPalette : unsigned char { mpNone, mpLight, mpPastel, mpGrayScale, mpEarth, mpSea, mpBrightPastel };

class PASCALIMPLEMENTATION TOperationCalculator : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Extended FValue;
	int FCount;
	TMapOperation FOperation;
	
public:
	__fastcall TOperationCalculator(TMapOperation AOperation);
	void __fastcall Add(System::Extended AValue);
	System::Extended __fastcall Get();
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TOperationCalculator() { }
	
};


class PASCALIMPLEMENTATION TValuesList : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
private:
	TMapOperation FOperation;
	TOperationCalculator* __fastcall GetOperationCalculator(int Index);
	
public:
	__fastcall TValuesList(TMapOperation AOperation);
	__fastcall virtual ~TValuesList();
	void __fastcall AddValue(System::UnicodeString SpatialValue, System::Extended AnalyticalValue);
	System::Extended __fastcall MinValue();
	System::Extended __fastcall MaxValue();
	__property TOperationCalculator* OperationCalculator[int Index] = {read=GetOperationCalculator};
};


class PASCALIMPLEMENTATION TfrxCustomLayer : public Frxclass::TfrxComponent
{
	typedef Frxclass::TfrxComponent inherited;
	
private:
	TMapLabelKind FLabelKind;
	System::Uitypes::TColor FHighlightColor;
	int FSelectedShapeIndex;
	System::UnicodeString FAnalyticalValue;
	System::UnicodeString FSpatialValue;
	TMapPalette FMapPalette;
	TMapOperation FOperation;
	Frxclass::TfrxDataSet* FDataSet;
	Frxmapcolorrangeform::TfrxColorRanges* FColorRanges;
	System::UnicodeString FValueFormat;
	System::UnicodeString FFilter;
	Frxmapshape::TShapeStyle* FDefaultShapeStyle;
	Frxmapsizerangeform::TfrxSizeRanges* FSizeRanges;
	System::Extended FPointLabelsVisibleAtZoom;
	bool FActive;
	bool FShowLines;
	bool FShowPoints;
	bool FShowPolygons;
	Frxmapshape::TShape* __fastcall GetSelectedShape();
	Frxmapcolorrangeform::TColorRangeCollection* __fastcall GetColorRangeData();
	Frxmapsizerangeform::TSizeRangeCollection* __fastcall GetSizeRangeData();
	
protected:
	System::UnicodeString FLabelColumn;
	System::UnicodeString FSpatialColumn;
	System::Extended FMapAccuracy;
	System::Extended FPixelAccuracy;
	int FPreviousSelectedShapeIndex;
	TValuesList* FValuesList;
	Frxmapshape::TShapeList* FShapes;
	Frxmaphelpers::TMapToCanvasCoordinateConverter* FConverter;
	System::Classes::TComponent* FMapView;
	bool FActiveHyperlink;
	Vcl::Graphics::TGraphic* FVectorGraphic;
	Frxmaphelpers::TfrxClippingRect* FClippingRect;
	void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas);
	void __fastcall DrawClippedPoint(Vcl::Graphics::TCanvas* Canvas, System::Extended X, System::Extended Y, System::Extended Radius);
	void __fastcall DrawPoint(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawMultiPoint(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawPointLegend(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawPolyLine(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawPolygon(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawPolyLegend(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawTemplate(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawRect(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawDiamond(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawEllipse(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawPicture(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawLegend(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall DrawHighlightFrame(Vcl::Graphics::TCanvas* Canvas, int iRecord);
	void __fastcall TunePoint(Vcl::Graphics::TCanvas* Canvas, int iRecord, /* out */ System::Extended &Radius);
	void __fastcall TuneBrush(Vcl::Graphics::TBrush* Brush, int iRecord);
	void __fastcall TunePen(Vcl::Graphics::TPen* Pen, int iRecord);
	virtual void __fastcall SetParent(Frxclass::TfrxComponent* AParent);
	virtual void __fastcall InitTransform(int iRecord);
	System::UnicodeString __fastcall GetShapeValue(int iRecord);
	System::UnicodeString __fastcall GetShapeName(System::UnicodeString FieldName, int iRecord);
	System::UnicodeString __fastcall GetShapeLegeng(System::UnicodeString FieldName, int iRecord);
	virtual System::UnicodeString __fastcall GetSelectedShapeName();
	virtual System::UnicodeString __fastcall GetSelectedShapeValue();
	virtual bool __fastcall IsHighlightSelectedShape();
	virtual bool __fastcall IsHiddenShape(int iRecord);
	void __fastcall GetDesigningData();
	virtual void __fastcall InitialiseData();
	virtual bool __fastcall IsCanGetData();
	void __fastcall FinaliseData();
	void __fastcall FillRanges(const Frxanaliticgeometry::TDoubleArray Values);
	virtual void __fastcall ExpandVariables();
	virtual void __fastcall AddValueList(const System::Variant &vaAnalyticalValue) = 0 ;
	virtual bool __fastcall IsIncludeAsRegion(const Frxclass::TfrxPoint &P);
	virtual bool __fastcall IsSpecialBorderColor(int iRecord, /* out */ System::Uitypes::TColor &SpecialColor);
	virtual bool __fastcall IsSpecialFillColor(int iRecord, /* out */ System::Uitypes::TColor &SpecialColor);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall DefinePrimeProperties(System::Classes::TFiler* Filer);
	Vcl::Graphics::TMetafile* __fastcall GetMetaFile(const Frxclass::TfrxPoint &CanvasSize, bool ActiveHyperlink);
	__property int SelectedShapeIndex = {read=FSelectedShapeIndex, write=FSelectedShapeIndex, nodefault};
	__property System::Extended MapAccuracy = {read=FMapAccuracy, write=FMapAccuracy};
	__property System::Extended PixelAccuracy = {read=FPixelAccuracy, write=FPixelAccuracy};
	
public:
	__fastcall virtual TfrxCustomLayer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomLayer();
	void __fastcall DrawOn(Vcl::Graphics::TCanvas* Canvas, bool ActiveHyperlink, const Frxclass::TfrxRect &aClipRect);
	void __fastcall BuildGraphic(const Frxclass::TfrxPoint &CanvasSize, bool ActiveHyperlink);
	virtual bool __fastcall IsInclude(const Frxclass::TfrxPoint &P);
	void __fastcall GetData();
	bool __fastcall IsHasMapRect(/* out */ Frxclass::TfrxRect &MapRect);
	virtual bool __fastcall IsHasZoomRect(/* out */ Frxclass::TfrxRect &ZoomRect);
	bool __fastcall IsSelectedShapeChanded();
	virtual void __fastcall GetColumnList(System::Classes::TStrings* List);
	void __fastcall ClearSelectedShape();
	__property Frxmaphelpers::TfrxClippingRect* ClippingRect = {read=FClippingRect};
	__property Frxmapshape::TShape* SelectedShape = {read=GetSelectedShape};
	__property System::UnicodeString SelectedShapeName = {read=GetSelectedShapeName};
	__property System::UnicodeString SelectedShapeValue = {read=GetSelectedShapeValue};
	__property Vcl::Graphics::TGraphic* VectorGraphic = {read=FVectorGraphic};
	__property System::Classes::TComponent* MapView = {read=FMapView};
	__property bool ShowLines = {read=FShowLines, write=FShowLines, default=1};
	__property bool ShowPoints = {read=FShowPoints, write=FShowPoints, default=1};
	__property bool ShowPolygons = {read=FShowPolygons, write=FShowPolygons, default=1};
	__property System::UnicodeString LabelColumn = {read=FLabelColumn, write=FLabelColumn};
	__property System::UnicodeString SpatialColumn = {read=FSpatialColumn, write=FSpatialColumn};
	__property System::UnicodeString SpatialValue = {read=FSpatialValue, write=FSpatialValue};
	
__published:
	__property bool Active = {read=FActive, write=FActive, nodefault};
	__property Visible = {default=1};
	__property Font;
	__property System::UnicodeString AnalyticalValue = {read=FAnalyticalValue, write=FAnalyticalValue};
	__property Frxmapcolorrangeform::TfrxColorRanges* ColorRanges = {read=FColorRanges};
	__property Frxmapcolorrangeform::TColorRangeCollection* ColorRangesData = {read=GetColorRangeData};
	__property Frxclass::TfrxDataSet* DataSet = {read=FDataSet, write=FDataSet};
	__property Frxmapshape::TShapeStyle* DefaultShapeStyle = {read=FDefaultShapeStyle};
	__property System::UnicodeString Filter = {read=FFilter, write=FFilter};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=FHighlightColor, nodefault};
	__property TMapOperation Operation = {read=FOperation, write=FOperation, nodefault};
	__property System::UnicodeString ValueFormat = {read=FValueFormat, write=FValueFormat};
	__property TMapLabelKind LabelKind = {read=FLabelKind, write=FLabelKind, nodefault};
	__property TMapPalette MapPalette = {read=FMapPalette, write=FMapPalette, nodefault};
	__property Frxmapsizerangeform::TfrxSizeRanges* SizeRanges = {read=FSizeRanges};
	__property Frxmapsizerangeform::TSizeRangeCollection* SizeRangesData = {read=GetSizeRangeData};
	__property System::Extended PointLabelsVisibleAtZoom = {read=FPointLabelsVisibleAtZoom, write=FPointLabelsVisibleAtZoom};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomLayer(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxComponent(AOwner, Flags) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TMapLayerList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxCustomLayer* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Classes::TList* FObjects;
	int FSelectedLayerIndex;
	TfrxCustomLayer* __fastcall GetSelectedLayer();
	int __fastcall GetCount();
	TfrxCustomLayer* __fastcall GetLayer(int Index);
	
protected:
	int FPreviousSelectedLayerIndex;
	
public:
	__fastcall TMapLayerList(System::Classes::TList* AObjects);
	void __fastcall Exchange(int Index1, int Index2);
	int __fastcall IndexOf(void * Item);
	bool __fastcall IsSelectedShapeChanded();
	bool __fastcall IsInclude(const Frxclass::TfrxPoint &P);
	void __fastcall GetData();
	__property int Count = {read=GetCount, nodefault};
	__property TfrxCustomLayer* Items[int Index] = {read=GetLayer/*, default*/};
	__property TfrxCustomLayer* SelectedLayer = {read=GetSelectedLayer};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TMapLayerList() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxMapFileLayer : public TfrxCustomLayer
{
	typedef TfrxCustomLayer inherited;
	
private:
	System::UnicodeString FZoomPolygon;
	void __fastcall SetLayerTags(System::Classes::TStringList* const Value);
	Frxmaphelpers::TfrxSumStringList* __fastcall GetFileTags();
	
protected:
	System::UnicodeString FMapFileName;
	System::Classes::TStringList* FLayerTags;
	bool FFirstReading;
	virtual System::UnicodeString __fastcall GetSelectedShapeName();
	virtual System::UnicodeString __fastcall GetSelectedShapeValue();
	virtual void __fastcall InitTransform(int iRecord);
	virtual void __fastcall InitialiseData();
	virtual bool __fastcall IsCanGetData();
	virtual bool __fastcall IsHighlightSelectedShape();
	void __fastcall SetMapFileName(const System::UnicodeString AMapFileName);
	System::UnicodeString __fastcall GetFileExtension();
	virtual void __fastcall ExpandVariables();
	virtual void __fastcall AddValueList(const System::Variant &vaAnalyticalValue);
	
public:
	__fastcall virtual TfrxMapFileLayer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxMapFileLayer();
	virtual bool __fastcall IsHasZoomRect(/* out */ Frxclass::TfrxRect &ZoomRect);
	void __fastcall Embed();
	void __fastcall ReRead();
	void __fastcall JustAdded();
	__property Frxmaphelpers::TfrxSumStringList* FileTags = {read=GetFileTags};
	
__published:
	__property ShowLines = {default=1};
	__property ShowPoints = {default=1};
	__property ShowPolygons = {default=1};
	__property LabelColumn = {default=0};
	__property SpatialColumn = {default=0};
	__property System::Classes::TStringList* LayerTags = {read=FLayerTags, write=SetLayerTags};
	__property MapAccuracy = {default=0};
	__property System::UnicodeString MapFileName = {read=FMapFileName, write=SetMapFileName};
	__property PixelAccuracy = {default=0};
	__property SpatialValue = {default=0};
	__property System::UnicodeString ZoomPolygon = {read=FZoomPolygon, write=FZoomPolygon};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxMapFileLayer(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomLayer(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxApplicationLayer : public TfrxCustomLayer
{
	typedef TfrxCustomLayer inherited;
	
private:
	System::UnicodeString FLabelValue;
	System::UnicodeString FLatitudeValue;
	System::UnicodeString FLongitudeValue;
	
protected:
	virtual void __fastcall InitialiseData();
	virtual bool __fastcall IsCanGetData();
	virtual void __fastcall ExpandVariables();
	virtual void __fastcall AddValueList(const System::Variant &vaAnalyticalValue);
	Frxmaphelpers::TShapeData* __fastcall ApplicationShapeData(System::Extended X, System::Extended Y, System::UnicodeString Name, System::UnicodeString Location);
	
public:
	__fastcall virtual TfrxApplicationLayer(System::Classes::TComponent* AOwner);
	virtual bool __fastcall IsInclude(const Frxclass::TfrxPoint &P);
	
__published:
	__property System::UnicodeString LabelValue = {read=FLabelValue, write=FLabelValue};
	__property System::UnicodeString LatitudeValue = {read=FLatitudeValue, write=FLatitudeValue};
	__property System::UnicodeString LongitudeValue = {read=FLongitudeValue, write=FLongitudeValue};
public:
	/* TfrxCustomLayer.Destroy */ inline __fastcall virtual ~TfrxApplicationLayer() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxApplicationLayer(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomLayer(AOwner, Flags) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxLabelColumnProperty : public Frxdsgnintf::TfrxPropertyEditor
{
	typedef Frxdsgnintf::TfrxPropertyEditor inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	virtual Frxdsgnintf::TfrxPropertyAttributes __fastcall GetAttributes();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxLabelColumnProperty(Frxclass::TfrxCustomDesigner* Designer) : Frxdsgnintf::TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxLabelColumnProperty() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall MapLabelKindGetList(System::Classes::TStrings* List);
extern DELPHI_PACKAGE void __fastcall PenStyleGetList(System::Classes::TStrings* List);
extern DELPHI_PACKAGE void __fastcall PaletteGetList(System::Classes::TStrings* List);
extern DELPHI_PACKAGE void __fastcall OperationGetList(System::Classes::TStrings* List);
}	/* namespace Frxmaplayer */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPLAYER)
using namespace Frxmaplayer;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmaplayerHPP
