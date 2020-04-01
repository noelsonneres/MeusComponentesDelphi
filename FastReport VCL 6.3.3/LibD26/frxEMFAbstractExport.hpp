// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEMFAbstractExport.pas' rev: 33.00 (Windows)

#ifndef FrxemfabstractexportHPP
#define FrxemfabstractexportHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>
#include <frxEMFFormat.hpp>
#include <System.Contnrs.hpp>
#include <Vcl.Graphics.hpp>
#include <frxClass.hpp>
#include <frxUtils.hpp>
#include <frxAnaliticGeometry.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxemfabstractexport
{
//-- forward type declarations -----------------------------------------------
struct TDeviceContextData;
class DELPHICLASS TDeviceContext;
struct TMemoExternalParams;
class DELPHICLASS TEMFAbstractExport;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TDeviceContextData
{
	
private:
	typedef System::DynamicArray<System::Uitypes::TColor> _TDeviceContextData__1;
	
	
public:
	Frxclass::TfrxPoint rTopLeft;
	unsigned Layout;
	unsigned MapMode;
	System::Types::TPoint WindowOrgEx;
	System::Types::TPoint ViewPortOrgEx;
	System::Types::TPoint BrushOrgEx;
	System::Types::TSize WindowExtEx;
	System::Types::TSize ViewPortExtEx;
	Frxemfformat::TEnhMetaObj* Pen;
	Frxemfformat::TEnhMetaObj* Brush;
	Frxemfformat::TEnhMetaObj* Font;
	Frxemfformat::TEnhMetaObj* Palette;
	Frxemfformat::TEnhMetaObj* ColorSpace;
	Frxemfformat::TEnhMetaObj* ColorAdjustment;
	System::Types::TPoint PositionCurrent;
	System::Types::TPoint PositionNext;
	unsigned BkMode;
	float MiterLimit;
	unsigned BkColor;
	unsigned TextColor;
	unsigned SetRop2;
	unsigned PolyFillMode;
	HRGN ClipRgn;
	_TDeviceContextData__1 EOFPalette;
	unsigned StretchMode;
	bool IsPathBracketOpened;
	unsigned TextAlignmentMode;
	unsigned ICMMode;
	tagXFORM XForm;
	unsigned MapperFlags;
	unsigned iArcDirection;
};


typedef System::DynamicArray<Frxemfformat::TEnhMetaObj*> TEnhMetaObjArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDeviceContext : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	unsigned __fastcall GetLogPenStyle();
	unsigned __fastcall GetPenType();
	unsigned __fastcall GetPenStyle();
	unsigned __fastcall GetPenEndCap();
	unsigned __fastcall GetPenLineJoin();
	System::Extended __fastcall GetPenWidth();
	float __fastcall GetMiterLimit();
	System::Uitypes::TColor __fastcall GetPenColor();
	System::Uitypes::TColor __fastcall GetBrushColor();
	unsigned __fastcall GetBrushStyle();
	unsigned __fastcall GetBrushHatch();
	System::Uitypes::TColor __fastcall GetTextColor();
	System::UnicodeString __fastcall GetFontFamily();
	int __fastcall GetFontSize();
	int __fastcall GetFontWeight();
	bool __fastcall GetFontItalic();
	bool __fastcall GetFontStrikeOut();
	System::Byte __fastcall GetFontCharSet();
	bool __fastcall GetFontUnderline();
	int __fastcall GetFontOrientation();
	System::Extended __fastcall GetFontRadian();
	System::Uitypes::TColor __fastcall GetBkColor();
	Frxclass::TfrxHAlign __fastcall GetHAlign();
	Frxclass::TfrxVAlign __fastcall GetVAlign();
	
protected:
	TDeviceContextData FData;
	void __fastcall DeleteObject(unsigned ih);
	void __fastcall SelectObject(unsigned ih, TEnhMetaObjArray EnhMetaObjArray);
	
public:
	virtual void __fastcall CopyFrom(System::TObject* ADC);
	virtual void __fastcall Init();
	bool __fastcall IsXFormDefault();
	__property HRGN ClipRgn = {read=FData.ClipRgn, nodefault};
	__property bool IsPathBracketOpened = {read=FData.IsPathBracketOpened, nodefault};
	__property unsigned Layout = {read=FData.Layout, nodefault};
	__property unsigned MapMode = {read=FData.MapMode, nodefault};
	__property unsigned PolyFillMode = {read=FData.PolyFillMode, nodefault};
	__property System::Types::TPoint PositionCurrent = {read=FData.PositionCurrent};
	__property System::Types::TPoint PositionNext = {read=FData.PositionNext};
	__property unsigned ICMMode = {read=FData.ICMMode, nodefault};
	__property unsigned MapperFlags = {read=FData.MapperFlags, nodefault};
	__property unsigned iArcDirection = {read=FData.iArcDirection, nodefault};
	__property unsigned LogPenStyle = {read=GetLogPenStyle, nodefault};
	__property unsigned PenType = {read=GetPenType, nodefault};
	__property unsigned PenStyle = {read=GetPenStyle, nodefault};
	__property unsigned PenEndCap = {read=GetPenEndCap, nodefault};
	__property unsigned PenLineJoin = {read=GetPenLineJoin, nodefault};
	__property System::Extended PenWidth = {read=GetPenWidth};
	__property System::Uitypes::TColor PenColor = {read=GetPenColor, nodefault};
	__property float MiterLimit = {read=GetMiterLimit};
	__property unsigned SetRop2 = {read=FData.SetRop2, nodefault};
	__property unsigned StretchMode = {read=FData.StretchMode, nodefault};
	__property unsigned TextAlignmentMode = {read=FData.TextAlignmentMode, nodefault};
	__property System::Uitypes::TColor TextColor = {read=GetTextColor, nodefault};
	__property System::Uitypes::TColor BkColor = {read=GetBkColor, nodefault};
	__property System::UnicodeString FontFamily = {read=GetFontFamily};
	__property int FontSize = {read=GetFontSize, nodefault};
	__property int FontWeight = {read=GetFontWeight, nodefault};
	__property bool FontItalic = {read=GetFontItalic, nodefault};
	__property System::Byte FontCharSet = {read=GetFontCharSet, nodefault};
	__property bool FontUnderline = {read=GetFontUnderline, nodefault};
	__property bool FontStrikeOut = {read=GetFontStrikeOut, nodefault};
	__property int FontOrientation = {read=GetFontOrientation, nodefault};
	__property System::Extended FontRadian = {read=GetFontRadian};
	__property System::Uitypes::TColor BrushColor = {read=GetBrushColor, nodefault};
	__property unsigned BrushStyle = {read=GetBrushStyle, nodefault};
	__property unsigned BrushHatch = {read=GetBrushHatch, nodefault};
	__property unsigned BkMode = {read=FData.BkMode, nodefault};
	__property Frxclass::TfrxPoint rTopLeft = {read=FData.rTopLeft};
	__property System::Types::TPoint WindowOrgEx = {read=FData.WindowOrgEx};
	__property System::Types::TPoint ViewPortOrgEx = {read=FData.ViewPortOrgEx};
	__property System::Types::TPoint BrushOrgEx = {read=FData.BrushOrgEx};
	__property System::Types::TSize WindowExtEx = {read=FData.WindowExtEx};
	__property System::Types::TSize ViewPortExtEx = {read=FData.ViewPortExtEx};
	__property tagXFORM XForm = {read=FData.XForm};
	__property Frxclass::TfrxVAlign VAlign = {read=GetVAlign, nodefault};
	__property Frxclass::TfrxHAlign HAlign = {read=GetHAlign, nodefault};
public:
	/* TObject.Create */ inline __fastcall TDeviceContext() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDeviceContext() { }
	
};

#pragma pack(pop)

typedef System::StaticArray<System::WideChar, 1> TWideCharArray;

typedef TWideCharArray *PWideCharArray;

struct DECLSPEC_DRECORD TMemoExternalParams
{
public:
	bool IsExternal;
	Frxclass::TfrxRect Margins;
	System::Extended Width;
	System::Extended Height;
	Frxclass::TfrxPoint Shift;
};


class PASCALIMPLEMENTATION TEMFAbstractExport : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool FShowComments;
	bool FFormatted;
	bool FEnableTransform;
	System::WideString FParsing;
	System::Classes::TStream* FInStream;
	tagEMR FLastRecord;
	System::Contnrs::TObjectList* FDCList;
	void __fastcall SetParsing(const System::WideString Value);
	void __fastcall ReadCurrentRecord();
	void __fastcall PlayMetaCommand();
	void __fastcall AddLastRecord();
	System::UnicodeString __fastcall ByteToHex(System::Byte B);
	void __fastcall ReadEoFPalette();
	void __fastcall ReadAlign();
	void __fastcall TransformPoint(Frxclass::TfrxPoint &DP);
	void __fastcall Parse_Poly(System::UnicodeString Name);
	void __fastcall Parse_Poly16(System::UnicodeString Name);
	void __fastcall Parse_PolyPoly(System::UnicodeString Name);
	void __fastcall Parse_PolyPoly16(System::UnicodeString Name);
	System::UnicodeString __fastcall CommentRect(const System::Types::TRect &Rect);
	System::UnicodeString __fastcall CommentPoint(const System::Types::TPoint &Point);
	System::Extended __fastcall LogToDevX(System::Extended LX);
	System::Extended __fastcall LogToDevY(System::Extended LY);
	
protected:
	System::Classes::TStream* FOutStream;
	System::Contnrs::TObjectList* FEMRList;
	TEnhMetaObjArray FEMRLastCreated;
	TDeviceContext* FDC;
	TMemoExternalParams FMEP;
	void __fastcall CalcMemoExternalParams(Frxclass::TfrxView* Obj);
	virtual void __fastcall Comment(System::UnicodeString CommentString = System::UnicodeString());
	System::UnicodeString __fastcall CommentArray(Frxutils::TLongWordArray A)/* overload */;
	System::UnicodeString __fastcall CommentArray(Frxutils::TIntegerArray A)/* overload */;
	System::UnicodeString __fastcall CommentArray(Frxanaliticgeometry::TDoubleArray A, int Prec = 0x1)/* overload */;
	Frxemfformat::PEnhMetaData __fastcall PLast();
	virtual void __fastcall DCCreate();
	virtual Vcl::Graphics::TFont* __fastcall FontCreate();
	Frxclass::TfrxPoint __fastcall LogToDevPoint(System::Types::TSmallPoint LP)/* overload */;
	Frxclass::TfrxPoint __fastcall LogToDevPoint(const System::Types::TPoint &LP)/* overload */;
	Frxclass::TfrxPoint __fastcall LogToDevPoint(const Frxclass::TfrxPoint &LP)/* overload */;
	Frxclass::TfrxPoint __fastcall LogToDevPoint(System::Extended X, System::Extended Y)/* overload */;
	Frxclass::TfrxRect __fastcall LogToDevRect(const System::Types::TRect &LR);
	System::Extended __fastcall LogToDevSizeX(System::Extended Value);
	System::Extended __fastcall LogToDevSizeY(System::Extended Value);
	System::Extended __fastcall LogToDevSize(System::Extended Value);
	virtual void __fastcall DoEMR_AbortPath();
	virtual void __fastcall DoEMR_AlphaBlend();
	virtual void __fastcall DoEMR_AngleArc();
	virtual void __fastcall DoEMR_Arc();
	virtual void __fastcall DoEMR_ArcTo();
	virtual void __fastcall DoEMR_BeginPath();
	virtual void __fastcall DoEMR_BitBlt();
	virtual void __fastcall DoEMR_Chord();
	virtual void __fastcall DoEMR_CloseFigure();
	virtual void __fastcall DoEMR_ColorCorrectPalette();
	virtual void __fastcall DoEMR_ColorMatchToTargetW();
	virtual void __fastcall DoEMR_CreateBrushIndirect();
	virtual void __fastcall DoEMR_CreateColorSpace();
	virtual void __fastcall DoEMR_CreateColorSpaceW();
	virtual void __fastcall DoEMR_CreateDIBPatternBrushPt();
	virtual void __fastcall DoEMR_CreateMonoBrush();
	virtual void __fastcall DoEMR_CreatePalette();
	virtual void __fastcall DoEMR_CreatePen();
	virtual void __fastcall DoEMR_DeleteColorSpace();
	virtual void __fastcall DoEMR_DeleteObject();
	virtual void __fastcall DoEMR_DrawEscape();
	virtual void __fastcall DoEMR_Ellipse();
	virtual void __fastcall DoEMR_EndPath();
	virtual void __fastcall DoEMR_EoF();
	virtual void __fastcall DoEMR_ExcludeClipRect();
	virtual void __fastcall DoEMR_ExtCreateFontIndirectW();
	virtual void __fastcall DoEMR_ExtCreatePen();
	virtual void __fastcall DoEMR_ExtEscape();
	virtual void __fastcall DoEMR_ExtFloodFill();
	virtual void __fastcall DoEMR_ExtSelectClipRgn();
	virtual void __fastcall DoEMR_ExtTextOutA();
	virtual void __fastcall DoEMR_ExtTextOutW();
	virtual void __fastcall DoEMR_FillPath();
	virtual void __fastcall DoEMR_FillRgn();
	virtual void __fastcall DoEMR_FlattenPath();
	virtual void __fastcall DoEMR_ForceUFIMapping();
	virtual void __fastcall DoEMR_FrameRgn();
	virtual void __fastcall DoEMR_GDIComment();
	virtual void __fastcall DoEMR_GLSBoundedRecord();
	virtual void __fastcall DoEMR_GLSRecord();
	virtual void __fastcall DoEMR_GradientFill();
	virtual void __fastcall DoEMR_Header();
	virtual void __fastcall DoEMR_IntersectClipRect();
	virtual void __fastcall DoEMR_InvertRgn();
	virtual void __fastcall DoEMR_LineTo();
	virtual void __fastcall DoEMR_MaskBlt();
	virtual void __fastcall DoEMR_ModifyWorldTransform();
	virtual void __fastcall DoEMR_MoveToEx();
	virtual void __fastcall DoEMR_NamedEscape();
	virtual void __fastcall DoEMR_OffsetClipRgn();
	virtual void __fastcall DoEMR_PaintRgn();
	virtual void __fastcall DoEMR_Pie();
	virtual void __fastcall DoEMR_PixelFormat();
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
	virtual void __fastcall DoEMR_RealizePalette();
	virtual void __fastcall DoEMR_Rectangle();
	virtual void __fastcall DoEMR_Reserved_69();
	virtual void __fastcall DoEMR_ResizePalette();
	virtual void __fastcall DoEMR_RestoreDC();
	virtual void __fastcall DoEMR_RoundRect();
	virtual void __fastcall DoEMR_SaveDC();
	virtual void __fastcall DoEMR_ScaleViewportExtEx();
	virtual void __fastcall DoEMR_ScaleWindowExtEx();
	virtual void __fastcall DoEMR_SelectClipPath();
	virtual void __fastcall DoEMR_SelectObject();
	virtual void __fastcall DoEMR_SelectPalette();
	virtual void __fastcall DoEMR_SetArcDirection();
	virtual void __fastcall DoEMR_SetBkColor();
	virtual void __fastcall DoEMR_SetBkMode();
	virtual void __fastcall DoEMR_SetBrushOrgEx();
	virtual void __fastcall DoEMR_SetColorSpace();
	virtual void __fastcall DoEMR_SetColorAdjustment();
	virtual void __fastcall DoEMR_SetDIBitsToDevice();
	virtual void __fastcall DoEMR_SetICMMode();
	virtual void __fastcall DoEMR_SetIcmProfileA();
	virtual void __fastcall DoEMR_SetIcmProfileW();
	virtual void __fastcall DoEMR_SetLayout();
	virtual void __fastcall DoEMR_SetLinkedUFIs();
	virtual void __fastcall DoEMR_SetMapMode();
	virtual void __fastcall DoEMR_SetMapperFlags();
	virtual void __fastcall DoEMR_SetMetaRgn();
	virtual void __fastcall DoEMR_SetMiterLimit();
	virtual void __fastcall DoEMR_SetPaletteEntries();
	virtual void __fastcall DoEMR_SetPixelV();
	virtual void __fastcall DoEMR_SetPolyFillMode();
	virtual void __fastcall DoEMR_SetRop2();
	virtual void __fastcall DoEMR_SetStretchBltMode();
	virtual void __fastcall DoEMR_SetTextAlign();
	virtual void __fastcall DoEMR_SetTextColor();
	virtual void __fastcall DoEMR_SetTextJustification();
	virtual void __fastcall DoEMR_SetViewPortExtEx();
	virtual void __fastcall DoEMR_SetViewPortOrgEx();
	virtual void __fastcall DoEMR_SetWindowExtEx();
	virtual void __fastcall DoEMR_SetWindowOrgEx();
	virtual void __fastcall DoEMR_SetWorldTransform();
	virtual void __fastcall DoEMR_SmallTextOut();
	virtual void __fastcall DoEMR_StartDoc();
	virtual void __fastcall DoEMR_StretchBlt();
	virtual void __fastcall DoEMR_StretchDIBits();
	virtual void __fastcall DoEMR_StrokeAndFillPath();
	virtual void __fastcall DoEMR_StrokePath();
	virtual void __fastcall DoEMR_TransparentBlt();
	virtual void __fastcall DoEMR_TransparentDIB();
	virtual void __fastcall DoEMR_WidenPath();
	virtual void __fastcall DoStart();
	virtual void __fastcall DoFinish();
	virtual void __fastcall DoUnknown();
	
public:
	__fastcall TEMFAbstractExport(System::Classes::TStream* InStream, System::Classes::TStream* OutStream);
	__fastcall virtual ~TEMFAbstractExport();
	void __fastcall PlayMetaFile();
	__property bool ShowComments = {read=FShowComments, write=FShowComments, nodefault};
	__property bool Formatted = {read=FFormatted, write=FFormatted, nodefault};
	__property System::WideString Parsing = {read=FParsing, write=SetParsing};
	__property bool EnableTransform = {read=FEnableTransform, write=FEnableTransform, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxemfabstractexport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEMFABSTRACTEXPORT)
using namespace Frxemfabstractexport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxemfabstractexportHPP
