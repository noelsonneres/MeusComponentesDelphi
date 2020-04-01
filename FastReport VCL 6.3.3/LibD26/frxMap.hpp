// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMap.pas' rev: 33.00 (Windows)

#ifndef FrxmapHPP
#define FrxmapHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <frxClass.hpp>
#include <frxMapLayer.hpp>
#include <frxMapHelpers.hpp>
#include <frxMapRanges.hpp>
#include <frxMapShape.hpp>
#include <frxMapLayerForm.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmap
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMapObject;
class DELPHICLASS TfrxMapView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxMapObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxMapObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxMapObject() { }
	
};


class PASCALIMPLEMENTATION TfrxMapView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	System::Extended FZoom;
	System::Extended FMinZoom;
	System::Extended FMaxZoom;
	System::Extended FMapOffsetX;
	System::Extended FMapOffsetY;
	bool FKeepAspectRatio;
	bool FMercatorProjection;
	void __fastcall SetZoom(const System::Extended Value);
	void __fastcall SetMaxZoom(const System::Extended Value);
	void __fastcall SetMinZoom(const System::Extended Value);
	void __fastcall SetMercatorProjection(const bool Value);
	System::UnicodeString __fastcall GetSelectedShapeName();
	
protected:
	Frxmaplayer::TMapLayerList* FLayers;
	bool FHasPreviousOffset;
	Frxclass::TfrxPoint FPreviousOffset;
	bool FShowMoveArrow;
	Frxmaphelpers::TMapToCanvasCoordinateConverter* FConverter;
	bool FFirstDraw;
	Frxclass::TfrxHyperlinkKind FPreviousHyperlinkKind;
	bool FNeedBuildVector;
	Frxmapranges::TMapScale* FColorScale;
	Frxmapranges::TMapScale* FSizeScale;
	Frxmapshape::TOSMFileList* FOSMFileList;
	bool FClipMap;
	System::Extended oldLeft;
	System::Extended oldTop;
	System::Extended oldWidth;
	System::Extended oldHeight;
	System::Extended oldOffsetX;
	System::Extended oldOffsetY;
	System::Extended oldZoom;
	bool FModified;
	bool FAddingLayer;
	void __fastcall DrawMap(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY);
	bool __fastcall IsMoveArrowArea(System::Extended X, System::Extended Y);
	Frxclass::TfrxPoint __fastcall CanvasSize();
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall InitConverter();
	bool __fastcall IsAlignByZoomPolygon();
	void __fastcall ZoomRecenter(System::Extended CenterX, System::Extended CenterY, System::Extended Factor);
	void __fastcall EnableSupportedHyperlink();
	void __fastcall DisableSupportedHyperlink();
	bool __fastcall ShowMoveArrow();
	
public:
	__fastcall virtual TfrxMapView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxMapView();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall DrawClipped(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual System::Classes::TList* __fastcall GetContainerObjects();
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	virtual void __fastcall GetData();
	void __fastcall ExpandVar(System::UnicodeString &Expr);
	void __fastcall AddLayer(Frxmaphelpers::TLayerType LayerType, bool IsEmbed, System::UnicodeString AMapFileName, Frxclass::TfrxReport* DefaultReport = (Frxclass::TfrxReport*)(0x0));
	void __fastcall GeometrySave();
	void __fastcall GeometryChange(System::Extended ALeft, System::Extended ATop, System::Extended AWidth, System::Extended AHeight);
	void __fastcall GeometryRestore();
	void __fastcall ZoomByRect(const Frxclass::TfrxRect &ZoomRect);
	void __fastcall ZoomByFactor(System::Extended Factor);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseEnter(Frxclass::TfrxComponent* aPreviousObject, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseLeave(Frxclass::TfrxComponent* aNextObject, Frxclass::TfrxInteractiveEventsParams &EventParams);
	__property Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter = {read=FConverter};
	__property System::UnicodeString SelectedShapeName = {read=GetSelectedShapeName};
	__property Frxmaplayer::TMapLayerList* Layers = {read=FLayers};
	__property Frxmapshape::TOSMFileList* OSMFileList = {read=FOSMFileList};
	__property bool ClipMap = {read=FClipMap, write=FClipMap, nodefault};
	__property bool NeedBuildVector = {read=FNeedBuildVector, write=FNeedBuildVector, nodefault};
	
__published:
	__property Font;
	__property FillType = {default=0};
	__property Fill;
	__property Frame;
	__property Cursor = {default=0};
	__property System::Extended Zoom = {read=FZoom, write=SetZoom};
	__property System::Extended MaxZoom = {read=FMaxZoom, write=SetMaxZoom};
	__property System::Extended MinZoom = {read=FMinZoom, write=SetMinZoom};
	__property System::Extended OffsetX = {read=FMapOffsetX, write=FMapOffsetX};
	__property System::Extended OffsetY = {read=FMapOffsetY, write=FMapOffsetY};
	__property bool KeepAspectRatio = {read=FKeepAspectRatio, write=FKeepAspectRatio, nodefault};
	__property bool MercatorProjection = {read=FMercatorProjection, write=SetMercatorProjection, nodefault};
	__property Frxmapranges::TMapScale* ColorScale = {read=FColorScale};
	__property Frxmapranges::TMapScale* SizeScale = {read=FSizeScale};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxMapView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxmap */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAP)
using namespace Frxmap;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmapHPP
