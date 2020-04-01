// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEMFtoSVGExport.pas' rev: 33.00 (Windows)

#ifndef FrxemftosvgexportHPP
#define FrxemftosvgexportHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <frxClass.hpp>
#include <frxExportHelpers.hpp>
#include <frxEMFAbstractExport.hpp>
#include <frxEMFFormat.hpp>
#include <frxUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxemftosvgexport
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TSVGDeviceContext;
class DELPHICLASS TEMFtoSVGExport;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSVGDeviceContext : public Frxemfabstractexport::TDeviceContext
{
	typedef Frxemfabstractexport::TDeviceContext inherited;
	
protected:
	System::UnicodeString FLastClipPathName;
	System::UnicodeString FLastPatternName;
	
public:
	virtual void __fastcall CopyFrom(System::TObject* ADC);
	virtual void __fastcall Init();
public:
	/* TObject.Create */ inline __fastcall TSVGDeviceContext() : Frxemfabstractexport::TDeviceContext() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TSVGDeviceContext() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TEMFtoSVGExport : public Frxemfabstractexport::TEMFAbstractExport
{
	typedef Frxemfabstractexport::TEMFAbstractExport inherited;
	
private:
	Frxexporthelpers::TfrxCSS* FCSS;
	System::UnicodeString FPath;
	bool FEmbedded;
	System::Extended FX;
	System::Extended FY;
	bool FForceMitterLineJoin;
	bool FLinearBarcode;
	void __fastcall NextClipPath();
	void __fastcall NextPattern();
	System::UnicodeString __fastcall MeasureUnit(System::Extended r, System::UnicodeString DefaultUnits = System::UnicodeString());
	System::UnicodeString __fastcall MU(System::Extended r);
	System::UnicodeString __fastcall MeasureAngleArc(const System::Types::TPoint &Center, int Radius, float StartAngle, float SweepAngle);
	System::UnicodeString __fastcall MeasureClipPath();
	System::UnicodeString __fastcall MeasureDominantBaseline();
	System::UnicodeString __fastcall MeasureDx(Frxutils::TLongWordArray OutputDx, System::WideString OutputString);
	System::UnicodeString __fastcall MeasureDy(Frxutils::TLongWordArray OutputDy, System::WideString OutputString);
	System::UnicodeString __fastcall MeasureEllipse(const System::Types::TRect &LR);
	System::UnicodeString __fastcall MeasureEndCap();
	System::UnicodeString __fastcall MeasureFill(System::Byte Options);
	System::UnicodeString __fastcall MeasureFontStyle();
	System::UnicodeString __fastcall MeasureFontSize();
	System::UnicodeString __fastcall MeasureFontOrientation(const System::Types::TPoint &LP);
	System::UnicodeString __fastcall MeasureLine();
	System::UnicodeString __fastcall MeasureLineJoin();
	System::UnicodeString __fastcall MeasurePie(const System::Types::TRect &LR, const System::Types::TPoint &LStart, const System::Types::TPoint &LEnd);
	System::UnicodeString __fastcall MeasurePoint(const Frxclass::TfrxPoint &LP, System::Extended dX = 0.000000E+00)/* overload */;
	System::UnicodeString __fastcall MeasurePoint(const System::Types::TPoint &LP, System::Extended dX = 0.000000E+00)/* overload */;
	System::UnicodeString __fastcall MeasurePoint(System::Types::TSmallPoint LP, System::Extended dX = 0.000000E+00)/* overload */;
	System::UnicodeString __fastcall MeasurePolyPoints();
	System::UnicodeString __fastcall MeasurePoly16Points();
	System::UnicodeString __fastcall MeasurePolyFillMode();
	System::UnicodeString __fastcall MeasureStroke(System::Byte Options);
	System::UnicodeString __fastcall MeasureStrokeMiterLimit();
	System::UnicodeString __fastcall MeasureStrokeDasharray();
	System::UnicodeString __fastcall MeasureTextAnchor();
	System::UnicodeString __fastcall MeasureTextDecoration();
	System::UnicodeString __fastcall MeasureRect(const System::Types::TRect &LR)/* overload */;
	System::UnicodeString __fastcall MeasureRect(int x, int y, int cx, int cy)/* overload */;
	System::UnicodeString __fastcall MeasureRectAsPath(const System::Types::TRect &LR);
	System::UnicodeString __fastcall MeasureRoundRect(const System::Types::TRect &LR, const System::Types::TSize &LS)/* overload */;
	System::UnicodeString __fastcall MeasureXY(const System::Types::TPoint &LP);
	System::UnicodeString __fastcall MeasureXYText(const System::Types::TPoint &LP);
	System::UnicodeString __fastcall SpaceDlm(System::UnicodeString st);
	void __fastcall Puts(const System::WideString s)/* overload */;
	void __fastcall Puts(const System::WideString Fmt, const System::TVarRec *Args, const int Args_High)/* overload */;
	void __fastcall PutsA(const System::AnsiString s);
	void __fastcall PutsRaw(const System::AnsiString s);
	System::UnicodeString __fastcall CSSPaintStyleName(System::Byte Options);
	void __fastcall Do_BitMap(System::UnicodeString DestRect, unsigned dwRop, Frxemfformat::TEMRBitmap* EMRBitmap);
	void __fastcall Do_Pattern(bool XLine, bool YLine, bool Turn);
	void __fastcall Do_PolyPoly(System::UnicodeString Name, System::Byte Options);
	void __fastcall Do_PolyPoly16(System::UnicodeString Name, System::Byte Options);
	
protected:
	virtual void __fastcall Comment(System::UnicodeString CommentString = System::UnicodeString());
	Frxclass::TfrxRect __fastcall NormalizeRect(const Frxclass::TfrxRect &frxRect)/* overload */;
	virtual void __fastcall DCCreate();
	virtual Vcl::Graphics::TFont* __fastcall FontCreate();
	TSVGDeviceContext* __fastcall SVGDeviceContext();
	bool __fastcall IsNonZero(Frxutils::TIntegerArray A);
	virtual void __fastcall DoEMR_AbortPath();
	virtual void __fastcall DoEMR_AlphaBlend();
	virtual void __fastcall DoEMR_AngleArc();
	virtual void __fastcall DoEMR_Arc();
	virtual void __fastcall DoEMR_ArcTo();
	virtual void __fastcall DoEMR_BeginPath();
	virtual void __fastcall DoEMR_BitBlt();
	virtual void __fastcall DoEMR_Chord();
	virtual void __fastcall DoEMR_CloseFigure();
	virtual void __fastcall DoEMR_Ellipse();
	virtual void __fastcall DoEMR_EoF();
	virtual void __fastcall DoEMR_ExtSelectClipRgn();
	virtual void __fastcall DoEMR_ExtTextOutA();
	virtual void __fastcall DoEMR_ExtTextOutW();
	virtual void __fastcall DoEMR_FillPath();
	virtual void __fastcall DoEMR_FillRgn();
	virtual void __fastcall DoEMR_FlattenPath();
	virtual void __fastcall DoEMR_FrameRgn();
	virtual void __fastcall DoEMR_Header();
	virtual void __fastcall DoEMR_LineTo();
	virtual void __fastcall DoEMR_MaskBlt();
	virtual void __fastcall DoEMR_MoveToEx();
	virtual void __fastcall DoEMR_PaintRgn();
	virtual void __fastcall DoEMR_Pie();
	virtual void __fastcall DoEMR_PLGBlt();
	virtual void __fastcall DoEMR_PolyBezier();
	virtual void __fastcall DoEMR_PolyBezier16();
	virtual void __fastcall DoEMR_PolyBezierTo();
	virtual void __fastcall DoEMR_PolyBezierTo16();
	virtual void __fastcall DoEMR_PolyDraw();
	virtual void __fastcall DoEMR_PolyDraw16();
	virtual void __fastcall DoEMR_Polygon();
	virtual void __fastcall DoEMR_Polygon16();
	virtual void __fastcall DoEMR_Polyline();
	virtual void __fastcall DoEMR_Polyline16();
	virtual void __fastcall DoEMR_PolylineTo();
	virtual void __fastcall DoEMR_PolylineTo16();
	virtual void __fastcall DoEMR_PolyPolygon();
	virtual void __fastcall DoEMR_PolyPolygon16();
	virtual void __fastcall DoEMR_PolyPolyline();
	virtual void __fastcall DoEMR_PolyPolyline16();
	virtual void __fastcall DoEMR_PolyTextOutA();
	virtual void __fastcall DoEMR_PolyTextOutW();
	virtual void __fastcall DoEMR_Rectangle();
	virtual void __fastcall DoEMR_RoundRect();
	virtual void __fastcall DoEMR_SelectClipPath();
	virtual void __fastcall DoEMR_SetDIBitsToDevice();
	virtual void __fastcall DoEMR_SetMetaRgn();
	virtual void __fastcall DoEMR_SetPixelV();
	virtual void __fastcall DoEMR_SmallTextOut();
	virtual void __fastcall DoEMR_StretchBlt();
	virtual void __fastcall DoEMR_StretchDIBits();
	virtual void __fastcall DoEMR_StrokeAndFillPath();
	virtual void __fastcall DoEMR_StrokePath();
	virtual void __fastcall DoEMR_TransparentBlt();
	virtual void __fastcall DoEMR_WidenPath();
	virtual void __fastcall DoStart();
	virtual void __fastcall DoFinish();
	
public:
	virtual void __fastcall AfterConstruction();
	void __fastcall SetEmbedded(Frxexporthelpers::TfrxCSS* CSS, System::Extended X, System::Extended Y);
	void __fastcall SetEmbedded2(Frxexporthelpers::TfrxCSS* CSS, Frxclass::TfrxView* Obj);
	__property bool ForceMitterLineJoin = {write=FForceMitterLineJoin, nodefault};
	__property bool LinearBarcode = {write=FLinearBarcode, nodefault};
public:
	/* TEMFAbstractExport.Create */ inline __fastcall TEMFtoSVGExport(System::Classes::TStream* InStream, System::Classes::TStream* OutStream) : Frxemfabstractexport::TEMFAbstractExport(InStream, OutStream) { }
	/* TEMFAbstractExport.Destroy */ inline __fastcall virtual ~TEMFtoSVGExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxemftosvgexport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEMFTOSVGEXPORT)
using namespace Frxemftosvgexport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxemftosvgexportHPP
