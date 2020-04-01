// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxChart.pas' rev: 33.00 (Windows)

#ifndef FrxchartHPP
#define FrxchartHPP

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
#include <Vcl.Menus.hpp>
#include <Vcl.Controls.hpp>
#include <frxCollections.hpp>
#include <frxClass.hpp>
#include <VCLTee.TeeProcs.hpp>
#include <VCLTee.TeEngine.hpp>
#include <VCLTee.Chart.hpp>
#include <VCLTee.Series.hpp>
#include <VCLTee.TeCanvas.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxchart
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxChartObject;
class DELPHICLASS TfrxSeriesItem;
class DELPHICLASS TfrxSeriesData;
class DELPHICLASS TfrxChartView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxChartObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxChartObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxChartObject() { }
	
};


typedef System::TMetaClass* TChartClass;

enum DECLSPEC_DENUM TfrxSeriesDataType : unsigned char { dtDBData, dtBandData, dtFixedData };

enum DECLSPEC_DENUM TfrxSeriesSortOrder : unsigned char { soNone, soAscending, soDescending };

enum DECLSPEC_DENUM TfrxSeriesXType : unsigned char { xtText, xtNumber, xtDate };

typedef System::TMetaClass* TSeriesClass;

enum DECLSPEC_DENUM TfrxChartSeries : unsigned char { csLine, csArea, csPoint, csBar, csHorizBar, csPie, csGantt, csFastLine, csArrow, csBubble, csChartShape, csHorizArea, csHorizLine, csPolar, csRadar, csPolarBar, csGauge, csSmith, csPyramid, csDonut, csBezier, csCandle, csVolume, csPointFigure, csHistogram, csHorizHistogram, csErrorBar, csError, csHighLow, csFunnel, csBox, csHorizBox, csSurface, csContour, csWaterFall, csColorGrid, csVector3D, csTower, csTriSurface, csPoint3D, csBubble3D, csMyPoint, csBarJoin, csBar3D };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSeriesItem : public Frxcollections::TfrxCollectionItem
{
	typedef Frxcollections::TfrxCollectionItem inherited;
	
private:
	Frxclass::TfrxDataBand* FDataBand;
	Frxclass::TfrxDataSet* FDataSet;
	System::UnicodeString FDataSetName;
	TfrxSeriesDataType FDataType;
	TfrxSeriesSortOrder FSortOrder;
	int FTopN;
	System::UnicodeString FTopNCaption;
	System::UnicodeString FSource1;
	System::UnicodeString FSource2;
	System::UnicodeString FSource3;
	System::UnicodeString FSource4;
	System::UnicodeString FSource5;
	System::UnicodeString FSource6;
	TfrxSeriesXType FXType;
	System::UnicodeString FValues1;
	System::UnicodeString FValues2;
	System::UnicodeString FValues3;
	System::UnicodeString FValues4;
	System::UnicodeString FValues5;
	System::UnicodeString FValues6;
	System::Classes::TStringList* Fsl1;
	System::Classes::TStringList* Fsl2;
	System::Classes::TStringList* Fsl3;
	System::Classes::TStringList* Fsl4;
	System::Classes::TStringList* Fsl5;
	System::Classes::TStringList* Fsl6;
	int FValueIndex1;
	int FValueIndex2;
	int FValueIndex3;
	int FValueIndex4;
	int FValueIndex5;
	int FValueIndex6;
	void __fastcall FillSeries(Vcltee::Teengine::TChartSeries* Series);
	void __fastcall SetDataSet(Frxclass::TfrxDataSet* const Value);
	void __fastcall SetDataSetName(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDataSetName();
	
public:
	__fastcall virtual TfrxSeriesItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TfrxSeriesItem();
	virtual bool __fastcall IsUniqueNameStored();
	
__published:
	__property TfrxSeriesDataType DataType = {read=FDataType, write=FDataType, nodefault};
	__property Frxclass::TfrxDataBand* DataBand = {read=FDataBand, write=FDataBand};
	__property Frxclass::TfrxDataSet* DataSet = {read=FDataSet, write=SetDataSet};
	__property System::UnicodeString DataSetName = {read=GetDataSetName, write=SetDataSetName};
	__property TfrxSeriesSortOrder SortOrder = {read=FSortOrder, write=FSortOrder, nodefault};
	__property int TopN = {read=FTopN, write=FTopN, nodefault};
	__property System::UnicodeString TopNCaption = {read=FTopNCaption, write=FTopNCaption};
	__property TfrxSeriesXType XType = {read=FXType, write=FXType, nodefault};
	__property System::UnicodeString Source1 = {read=FSource1, write=FSource1};
	__property System::UnicodeString Source2 = {read=FSource2, write=FSource2};
	__property System::UnicodeString Source3 = {read=FSource3, write=FSource3};
	__property System::UnicodeString Source4 = {read=FSource4, write=FSource4};
	__property System::UnicodeString Source5 = {read=FSource5, write=FSource5};
	__property System::UnicodeString Source6 = {read=FSource6, write=FSource6};
	__property System::UnicodeString Values1 = {read=FValues1, write=FValues1};
	__property System::UnicodeString Values2 = {read=FValues2, write=FValues2};
	__property System::UnicodeString Values3 = {read=FValues3, write=FValues3};
	__property System::UnicodeString Values4 = {read=FValues4, write=FValues4};
	__property System::UnicodeString Values5 = {read=FValues5, write=FValues5};
	__property System::UnicodeString Values6 = {read=FValues6, write=FValues6};
	__property System::UnicodeString XSource = {read=FSource1, write=FSource1};
	__property System::UnicodeString YSource = {read=FSource2, write=FSource2};
	__property System::UnicodeString XValues = {read=FValues1, write=FValues1};
	__property System::UnicodeString YValues = {read=FValues2, write=FValues2};
	__property System::UnicodeString InheritedName = {read=GetInheritedName, write=SetInheritedName, stored=false};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSeriesData : public Frxcollections::TfrxCollection
{
	typedef Frxcollections::TfrxCollection inherited;
	
public:
	TfrxSeriesItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	Frxclass::TfrxReport* FReport;
	TfrxSeriesItem* __fastcall GetSeries(int Index);
	
public:
	__fastcall TfrxSeriesData(Frxclass::TfrxReport* Report);
	HIDESBASE TfrxSeriesItem* __fastcall Add();
	__property TfrxSeriesItem* Items[int Index] = {read=GetSeries/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxSeriesData() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxChartView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	Vcltee::Chart::TCustomChart* FChart;
	TfrxSeriesData* FSeriesData;
	bool FIgnoreNulls;
	bool FNotFillSeries;
	bool FDesignSeriesFilled;
	System::Uitypes::TColor FSavedColor;
	int FHlIndex;
	System::UnicodeString FClickedVal1;
	System::UnicodeString FClickedVal2;
	System::UnicodeString FClickedVal3;
	System::UnicodeString FClickedVal4;
	System::UnicodeString FClickedVal5;
	System::UnicodeString FClickedVal6;
	System::Uitypes::TColor FHighlightColor;
	int FPenWidth;
	Vcl::Graphics::TPenStyle FPenStyle;
	int FSeriesIndex;
	bool FMouseDown;
	System::Extended FMouseOffsetX;
	System::Extended FMouseOffsetY;
	bool FMacroLoaded;
	void __fastcall FillChart();
	void __fastcall ReadData(System::Classes::TStream* Stream);
	void __fastcall ReadData1(System::Classes::TReader* Reader);
	void __fastcall ReadData2(System::Classes::TReader* Reader);
	void __fastcall WriteData(System::Classes::TStream* Stream);
	void __fastcall WriteData1(System::Classes::TWriter* Writer);
	void __fastcall WriteData2(System::Classes::TWriter* Writer);
	Vcl::Graphics::TMetafile* __fastcall CreateMetafile();
	bool __fastcall ResetHighlightSelection();
	
protected:
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall CreateChart();
	__classmethod virtual TChartClass __fastcall GetChartClass();
	bool __fastcall CheckMoveSelector(System::Extended X, System::Extended Y);
	
public:
	__fastcall virtual TfrxChartView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxChartView();
	virtual void __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseEnter(Frxclass::TfrxComponent* aPreviousObject, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseLeave(Frxclass::TfrxComponent* aNextObject, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, Frxclass::TfrxInteractiveEventsParams &EventParams);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall AfterPrint();
	virtual void __fastcall GetData();
	virtual void __fastcall BeforeStartReport();
	virtual void __fastcall OnNotify(System::TObject* Sender);
	void __fastcall ClearSeries();
	void __fastcall AddSeries(TfrxChartSeries Series);
	void __fastcall UpdateSeriesData();
	virtual void __fastcall SaveContentToDictionary(Frxclass::TfrxReport* aReport, Frxclass::TfrxPostProcessor* PostProcessor);
	virtual void __fastcall ProcessDictionary(Frxclass::TfrxMacrosItem* aItem, Frxclass::TfrxReport* aReport, Frxclass::TfrxPostProcessor* PostProcessor);
	virtual bool __fastcall LoadContentFromDictionary(Frxclass::TfrxReport* aReport, Frxclass::TfrxMacrosItem* aItem);
	__property Vcltee::Chart::TCustomChart* Chart = {read=FChart};
	__property TfrxSeriesData* SeriesData = {read=FSeriesData};
	__property int HighlightIndex = {read=FHlIndex, nodefault};
	__property System::UnicodeString ClickedVal1 = {read=FClickedVal1};
	__property System::UnicodeString ClickedVal2 = {read=FClickedVal2};
	__property System::UnicodeString ClickedVal3 = {read=FClickedVal3};
	__property System::UnicodeString ClickedVal4 = {read=FClickedVal4};
	__property System::UnicodeString ClickedVal5 = {read=FClickedVal5};
	__property System::UnicodeString ClickedVal6 = {read=FClickedVal6};
	
__published:
	__property bool IgnoreNulls = {read=FIgnoreNulls, write=FIgnoreNulls, default=0};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=FHighlightColor, default=-16777190};
	__property FillType = {default=0};
	__property Fill;
	__property Cursor = {default=0};
	__property Frame;
	__property TagStr = {default=0};
	__property URL = {default=0};
	__property Processing;
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxChartView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxchart */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCHART)
using namespace Frxchart;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxchartHPP
