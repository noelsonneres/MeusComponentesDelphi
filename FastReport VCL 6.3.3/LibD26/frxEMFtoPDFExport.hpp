// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEMFtoPDFExport.pas' rev: 33.00 (Windows)

#ifndef FrxemftopdfexportHPP
#define FrxemftopdfexportHPP

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
#include <frxExportHelpers.hpp>
#include <frxEMFAbstractExport.hpp>
#include <frxEMFFormat.hpp>
#include <frxExportPDFHelpers.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxemftopdfexport
{
//-- forward type declarations -----------------------------------------------
struct TBezierResult;
class DELPHICLASS TPDFDeviceContext;
class DELPHICLASS TPDFPath;
class DELPHICLASS TEMFtoPDFExport;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TBezierResult
{
public:
	Frxclass::TfrxPoint P0;
	Frxclass::TfrxPoint P1;
	Frxclass::TfrxPoint P2;
	Frxclass::TfrxPoint P3;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TPDFDeviceContext : public Frxemfabstractexport::TDeviceContext
{
	typedef Frxemfabstractexport::TDeviceContext inherited;
	
protected:
	bool FExtSelectClipRgnCreated;
	
public:
	virtual void __fastcall CopyFrom(System::TObject* ADC);
	virtual void __fastcall Init();
public:
	/* TObject.Create */ inline __fastcall TPDFDeviceContext() : Frxemfabstractexport::TDeviceContext() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TPDFDeviceContext() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TPDFPath : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TStream* FOutStream;
	bool FExists;
	
protected:
	System::Classes::TMemoryStream* FStream;
	
public:
	__fastcall TPDFPath(System::Classes::TStream* AOutStream);
	__fastcall virtual ~TPDFPath();
	void __fastcall Put(const System::AnsiString S);
	void __fastcall Flush();
	__property bool Exists = {read=FExists, write=FExists, nodefault};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TEMFtoPDFExport : public Frxemfabstractexport::TEMFAbstractExport
{
	typedef Frxemfabstractexport::TEMFAbstractExport inherited;
	
private:
	bool FForceMitterLineJoin;
	bool FForceButtLineCap;
	int FJPGQuality;
	bool FForceNullBrush;
	bool FTransparency;
	bool FForceAnsi;
	void __fastcall Put(const System::AnsiString S);
	void __fastcall PutLn(const System::AnsiString S)/* overload */;
	void __fastcall PutLn(const System::UnicodeString S)/* overload */;
	System::Extended __fastcall pdfSize(System::Extended emfSize);
	Frxclass::TfrxPoint __fastcall pdfFrxPoint(const System::Types::TPoint &emfP)/* overload */;
	Frxclass::TfrxPoint __fastcall pdfFrxPoint(System::Types::TSmallPoint emfSP)/* overload */;
	Frxclass::TfrxPoint __fastcall pdfFrxPoint(const Frxclass::TfrxPoint &emfDP)/* overload */;
	Frxclass::TfrxRect __fastcall pdfFrxRect(const System::Types::TRect &emfR);
	System::UnicodeString __fastcall emfPoint2Str(const System::Types::TPoint &emfP)/* overload */;
	System::UnicodeString __fastcall emfPoint2Str(System::Types::TSmallPoint emfSP)/* overload */;
	System::UnicodeString __fastcall emfPoint2Str(const Frxclass::TfrxPoint &emfFP)/* overload */;
	System::UnicodeString __fastcall emfRect2Str(const System::Types::TRect &emfR);
	System::UnicodeString __fastcall EvenOdd();
	bool __fastcall IsNullBrush();
	bool __fastcall IsNullPen();
	TBezierResult __fastcall BezierCurve(const Frxclass::TfrxPoint &Center, const Frxclass::TfrxPoint &Radius, double startAngle, double arcAngle);
	void __fastcall cmd_AngleArc(const Frxclass::TfrxPoint &Center, const Frxclass::TfrxPoint &Radius, float StartAngle, float SweepAngle);
	void __fastcall cmd_RoundRect(System::Extended l, System::Extended t, System::Extended r, System::Extended b, System::Extended rx, System::Extended ry);
	void __fastcall cmdPathPainting(int Options, bool UseBkColor = false);
	void __fastcall cmdPathParams(int Options, bool UseBkColor);
	void __fastcall cmdSetClippingPath();
	void __fastcall cmdCloseSubpath();
	void __fastcall cmdAppendAngleArcToPath(const tagEMRANGLEARC &AngleArc);
	void __fastcall cmdAppendPieToPath(const tagEMRARC &Pie);
	void __fastcall cmdAppendEllipsToPath(const System::Types::TRect &emfRect);
	void __fastcall cmdAppendRectangleToPath(const System::Types::TRect &emfRect);
	void __fastcall cmdAppendEMFRectangleToPath(const System::Types::TRect &emfRect);
	void __fastcall cmdAppendRoundRectToPath(const System::Types::TRect &emfRect, const System::Types::TSize &emfCorners);
	void __fastcall cmdMoveTo(System::Extended X, System::Extended Y)/* overload */;
	void __fastcall cmdMoveTo(const System::Types::TPoint &emfP)/* overload */;
	void __fastcall cmdMoveTo(System::Types::TSmallPoint emfSP)/* overload */;
	void __fastcall cmdMoveTo(const Frxclass::TfrxPoint &emfFP)/* overload */;
	void __fastcall cmdLineTo(System::Extended X, System::Extended Y)/* overload */;
	void __fastcall cmdLineTo(const System::Types::TPoint &emfP)/* overload */;
	void __fastcall cmdLineTo(System::Types::TSmallPoint emfSP)/* overload */;
	void __fastcall cmdLineTo(const Frxclass::TfrxPoint &emfDP)/* overload */;
	void __fastcall cmdSetLineDashPattern(unsigned PenStyle, System::Extended Width);
	void __fastcall cmdSetStrokeColor(System::Uitypes::TColor Color);
	void __fastcall cmdSetFillColor(System::Uitypes::TColor Color);
	void __fastcall cmdSetLineWidth(System::Extended Width)/* overload */;
	void __fastcall cmdSetLineWidth(System::UnicodeString PDFWidth)/* overload */;
	void __fastcall cmdSetMiterLimit(System::Extended MiterLimit);
	void __fastcall cmdSetLineCap(int PenEndCap);
	void __fastcall cmdSetLineJoin(int PenLineJoin);
	void __fastcall cmdAppendCurvedSegment2final(System::Types::TSmallPoint emfSP1, System::Types::TSmallPoint emfSP3)/* overload */;
	void __fastcall cmdAppendCurvedSegment2final(const System::Types::TPoint &emfP1, const System::Types::TPoint &emfP3)/* overload */;
	void __fastcall cmdAppendCurvedSegment3(System::Types::TSmallPoint emfSP1, System::Types::TSmallPoint emfSP2, System::Types::TSmallPoint emfSP3)/* overload */;
	void __fastcall cmdAppendCurvedSegment3(const System::Types::TPoint &emfP1, const System::Types::TPoint &emfP2, const System::Types::TPoint &emfP3)/* overload */;
	void __fastcall cmdAppendCurvedSegment3(const Frxclass::TfrxPoint &emfDP1, const Frxclass::TfrxPoint &emfDP2, const Frxclass::TfrxPoint &emfDP3)/* overload */;
	void __fastcall cmdPolyBezier(int Options = 0x0);
	void __fastcall cmdPolyBezier16(int Options = 0x0);
	void __fastcall cmdPolyLine(int Options = 0x0);
	void __fastcall cmdPolyLine16(int Options = 0x0);
	void __fastcall cmdPolyPolyLine(int Options = 0x0);
	void __fastcall cmdPolyPolyLine16(int Options = 0x0);
	void __fastcall cmdCreateExtSelectClipRgn();
	void __fastcall cmdSaveGraphicsState();
	void __fastcall cmdRestoreGraphicsState();
	void __fastcall cmdBitmap(const System::Types::TRect &emfRect, unsigned dwRop, Frxemfformat::TEMRBitmap* EMRBitmap);
	void __fastcall cmdTranslationAndScaling(System::Extended Sx, System::Extended Sy, System::Extended Tx, System::Extended Ty);
	
protected:
	Frxclass::TfrxRect FPDFRect;
	Frxclass::TfrxPoint FEMFtoPDFFactor;
	Frxexportpdfhelpers::TPDFObjectsHelper* FPOH;
	Frxexporthelpers::TRotation2D* FRotation2D;
	System::Classes::TStringList* FRealizationList;
	int FqQBalance;
	bool FPdfA;
	TPDFPath* FPath;
	virtual void __fastcall Comment(System::UnicodeString CommentString = System::UnicodeString());
	void __fastcall CommentAboutRealization();
	void __fastcall RealizationListFill(System::UnicodeString *RealizedCommands, const int RealizedCommands_High);
	virtual void __fastcall DCCreate();
	virtual Vcl::Graphics::TFont* __fastcall FontCreate();
	TPDFDeviceContext* __fastcall PDFDeviceContext();
	void __fastcall DrawFontLines(int FontSize, const Frxclass::TfrxPoint &TextPosition, System::Extended TextWidth);
	void __fastcall DrawFigureStart();
	void __fastcall DrawFigureFinish(int Options);
	int __fastcall FillStrokeOptions(int Options);
	virtual void __fastcall DoEMR_AngleArc();
	virtual void __fastcall DoEMR_AlphaBlend();
	virtual void __fastcall DoEMR_BitBlt();
	virtual void __fastcall DoEMR_CloseFigure();
	virtual void __fastcall DoEMR_Ellipse();
	virtual void __fastcall DoEMR_EoF();
	virtual void __fastcall DoEMR_ExtSelectClipRgn();
	virtual void __fastcall DoEMR_ExtTextOutW();
	virtual void __fastcall DoEMR_FillPath();
	virtual void __fastcall DoEMR_Header();
	virtual void __fastcall DoEMR_IntersectClipRect();
	virtual void __fastcall DoEMR_LineTo();
	virtual void __fastcall DoEMR_MaskBlt();
	virtual void __fastcall DoEMR_MoveToEx();
	virtual void __fastcall DoEMR_Pie();
	virtual void __fastcall DoEMR_PolyBezier();
	virtual void __fastcall DoEMR_PolyBezier16();
	virtual void __fastcall DoEMR_PolyBezierTo();
	virtual void __fastcall DoEMR_PolyBezierTo16();
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
	virtual void __fastcall DoEMR_Rectangle();
	virtual void __fastcall DoEMR_RestoreDC();
	virtual void __fastcall DoEMR_RoundRect();
	virtual void __fastcall DoEMR_SaveDC();
	virtual void __fastcall DoEMR_SelectClipPath();
	virtual void __fastcall DoEMR_StretchBlt();
	virtual void __fastcall DoEMR_StretchDIBits();
	virtual void __fastcall DoEMR_StrokeAndFillPath();
	virtual void __fastcall DoEMR_StrokePath();
	virtual void __fastcall DoEMR_TransparentBlt();
	virtual void __fastcall DoStart();
	virtual void __fastcall DoFinish();
	
public:
	__fastcall TEMFtoPDFExport(System::Classes::TStream* InStream, System::Classes::TStream* OutStream, const Frxclass::TfrxRect &APDFRect, Frxexportpdfhelpers::TPDFObjectsHelper* APOH, bool APdfA);
	__fastcall virtual ~TEMFtoPDFExport();
	__property bool ForceMitterLineJoin = {read=FForceMitterLineJoin, write=FForceMitterLineJoin, nodefault};
	__property bool ForceButtLineCap = {write=FForceButtLineCap, nodefault};
	__property int JPGQuality = {write=FJPGQuality, nodefault};
	__property bool ForceNullBrush = {write=FForceNullBrush, nodefault};
	__property bool Transparency = {write=FTransparency, nodefault};
	__property bool ForceAnsi = {write=FForceAnsi, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxemftopdfexport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEMFTOPDFEXPORT)
using namespace Frxemftopdfexport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxemftopdfexportHPP
