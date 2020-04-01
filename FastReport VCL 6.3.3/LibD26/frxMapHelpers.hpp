// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapHelpers.pas' rev: 33.00 (Windows)

#ifndef FrxmaphelpersHPP
#define FrxmaphelpersHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <frxClass.hpp>
#include <System.Classes.hpp>
#include <System.Contnrs.hpp>
#include <frxXML.hpp>
#include <Vcl.Controls.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Imaging.pngimage.hpp>
#include <frxAnaliticGeometry.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmaphelpers
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TShapeData;
class DELPHICLASS TMapToCanvasCoordinateConverter;
class DELPHICLASS TTaggedElement;
class DELPHICLASS TfrxMapXMLReader;
class DELPHICLASS TfrxMapXMLDocument;
class DELPHICLASS TfrxSumStringList;
class DELPHICLASS TfrxClippingRect;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TLayerType : unsigned char { ltMapFile, ltApplication, ltInteractive, ltGeodata };

enum DECLSPEC_DENUM TShapeType : unsigned char { stNone, stPoint, stPolyLine, stPolygon, stRect, stDiamond, stEllipse, stPicture, stLegend, stTemplate, stMultiPoint, stMultiPolyLine, stMultiPolygon };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TShapeData : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Frxanaliticgeometry::TDoublePointMatrix FData;
	TShapeType FShapeType;
	Frxclass::TfrxRect FWidestPartBounds;
	Frxclass::TfrxPoint FShapeCenter;
	Vcl::Graphics::TPicture* FPicture;
	bool FConstrainProportions;
	Vcl::Graphics::TFont* FFont;
	System::Classes::TStringList* FLegendText;
	System::UnicodeString FTemplateName;
	System::UnicodeString __fastcall GetLegend(const System::UnicodeString Name);
	Frxanaliticgeometry::TDoublePoint __fastcall GetPoint();
	void __fastcall SetPoint(const Frxanaliticgeometry::TDoublePoint &Value);
	Frxanaliticgeometry::TDoublePoint __fastcall GetMultiLine(int iPart, int iPoint);
	void __fastcall SetMultiLine(int iPart, int iPoint, const Frxanaliticgeometry::TDoublePoint &Value);
	int __fastcall GetPartCount();
	void __fastcall SetPartCount(const int Value);
	int __fastcall GetMultiLineCount(int iPart);
	void __fastcall SetMultiLineCount(int iPart, const int Value);
	Frxanaliticgeometry::TDoubleRect __fastcall GetRect();
	void __fastcall SetRect(const Frxanaliticgeometry::TDoubleRect &Value);
	Frxanaliticgeometry::TDoublePoint __fastcall GetMultiPoint(int iPoint);
	int __fastcall GetMultiPointCount();
	void __fastcall SetMultiPoint(int iPoint, const Frxanaliticgeometry::TDoublePoint &Value);
	void __fastcall SetMultiPointCount(const int Value);
	
protected:
	System::Classes::TStringList* FTags;
	
public:
	__fastcall TShapeData(int iParts, TShapeType AShapeType, System::Classes::TStrings* ATags);
	__fastcall TShapeData(System::Classes::TStrings* ATags, double X, double Y);
	__fastcall TShapeData(System::Classes::TStrings* ATags, TShapeType AShapeType, const Frxanaliticgeometry::TDoubleRect &DR);
	__fastcall TShapeData(TShapeType AShapeType, System::Classes::TStrings* ATags, int iPoints);
	__fastcall TShapeData(TShapeType AShapeType, System::Classes::TStrings* ATags);
	__fastcall virtual ~TShapeData();
	void __fastcall AddPart(int iPoints);
	bool __fastcall IsGetColumnList(System::Classes::TStrings* List);
	void __fastcall CalcBounds();
	void __fastcall GetPolyPoints(Frxanaliticgeometry::TDoublePointArray &Points, int iPart);
	bool __fastcall IsClosed();
	void __fastcall ReadStringList(System::Classes::TStringList* &SL, System::Classes::TReader* Reader);
	void __fastcall ReadTags(System::Classes::TReader* Reader);
	void __fastcall ReadData(System::Classes::TReader* Reader);
	void __fastcall ReadPicture(System::Classes::TReader* Reader);
	void __fastcall ReadFont(System::Classes::TReader* Reader);
	void __fastcall WriteStringList(System::Classes::TStringList* SL, System::Classes::TWriter* Writer);
	void __fastcall WriteTags(System::Classes::TWriter* Writer);
	void __fastcall WriteData(System::Classes::TWriter* Writer);
	void __fastcall WritePicture(System::Classes::TWriter* Writer);
	void __fastcall WriteFont(System::Classes::TWriter* Writer);
	__property Frxanaliticgeometry::TDoublePoint Point = {read=GetPoint, write=SetPoint};
	__property Frxanaliticgeometry::TDoubleRect Rect = {read=GetRect, write=SetRect};
	__property Frxanaliticgeometry::TDoublePoint MultiPoint[int iPoint] = {read=GetMultiPoint, write=SetMultiPoint};
	__property int MultiPointCount = {read=GetMultiPointCount, write=SetMultiPointCount, nodefault};
	__property Frxanaliticgeometry::TDoublePoint MultiLine[int iPart][int iPoint] = {read=GetMultiLine, write=SetMultiLine};
	__property int PartCount = {read=GetPartCount, write=SetPartCount, nodefault};
	__property int MultiLineCount[int iPart] = {read=GetMultiLineCount, write=SetMultiLineCount};
	__property System::UnicodeString Legend[const System::UnicodeString Name] = {read=GetLegend};
	__property TShapeType ShapeType = {read=FShapeType, nodefault};
	__property Frxclass::TfrxRect WidestPartBounds = {read=FWidestPartBounds};
	__property Frxclass::TfrxPoint ShapeCenter = {read=FShapeCenter};
	__property System::Classes::TStringList* Tags = {read=FTags};
	__property Vcl::Graphics::TPicture* Picture = {read=FPicture};
	__property bool ConstrainProportions = {read=FConstrainProportions, write=FConstrainProportions, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=FFont};
	__property System::Classes::TStringList* LegendText = {read=FLegendText};
	__property System::UnicodeString TemplateName = {read=FTemplateName, write=FTemplateName};
public:
	/* TObject.Create */ inline __fastcall TShapeData() : System::TObject() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TMapToCanvasCoordinateConverter : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool FMercatorProjection;
	bool FIsHasData;
	void __fastcall SetMercatorProjection(const bool Value);
	
protected:
	System::Extended FXmin;
	System::Extended FYmin;
	System::Extended FXmax;
	System::Extended FYmax;
	System::Extended FXRange;
	System::Extended FYRange;
	System::Extended FYmaxTransformed;
	System::Extended FWidth;
	System::Extended FHeight;
	System::Extended FOffsetX;
	System::Extended FOffsetY;
	bool FShapeActive;
	System::Extended FShapeZoom;
	Frxclass::TfrxPoint FShapeOffset;
	Frxclass::TfrxPoint FShapeCenter;
	bool FUseOffset;
	System::Extended __fastcall YTransform(System::Extended Y);
	System::Extended __fastcall ConvertMercator(System::Extended Y);
	Frxclass::TfrxPoint __fastcall MapTransform(const Frxclass::TfrxPoint &P)/* overload */;
	Frxclass::TfrxPoint __fastcall MapTransform(System::Extended X, System::Extended Y)/* overload */;
	Frxclass::TfrxPoint __fastcall ShapeTransform(const Frxclass::TfrxPoint &P);
	
public:
	void __fastcall Init();
	void __fastcall IncludeRect(const Frxclass::TfrxRect &LayerRect);
	System::Extended __fastcall AspectRatio();
	void __fastcall SetCanvasSize(const Frxclass::TfrxPoint &CanvasSize);
	void __fastcall SetOffset(System::Extended OffsetX, System::Extended OffsetY);
	void __fastcall ReadDFM(System::Classes::TStream* Stream);
	void __fastcall WriteDFM(System::Classes::TStream* Stream);
	void __fastcall Read(System::Classes::TReader* Reader);
	void __fastcall Write(System::Classes::TWriter* Writer);
	void __fastcall IgnoreShape();
	void __fastcall InitShape(System::Extended AOffsetX, System::Extended AOffsetY, System::Extended AZoom, const Frxclass::TfrxPoint &AShapeCenter);
	Frxclass::TfrxPoint __fastcall Transform(System::Extended X, System::Extended Y)/* overload */;
	Frxclass::TfrxPoint __fastcall Transform(const Frxanaliticgeometry::TDoublePoint &DoublePoint)/* overload */;
	Frxclass::TfrxPoint __fastcall Transform(const Frxclass::TfrxPoint &frxPoint)/* overload */;
	Frxclass::TfrxPoint __fastcall TransformOffset(const Frxclass::TfrxPoint &frxPoint)/* overload */;
	Frxclass::TfrxRect __fastcall TransformRect(const Frxclass::TfrxRect &R);
	Frxclass::TfrxPoint __fastcall CanvasToMap(const Frxclass::TfrxPoint &Canvas);
	__property bool UseOffset = {read=FUseOffset, write=FUseOffset, nodefault};
	__property bool MercatorProjection = {read=FMercatorProjection, write=SetMercatorProjection, nodefault};
	__property bool IsHasData = {read=FIsHasData, nodefault};
public:
	/* TObject.Create */ inline __fastcall TMapToCanvasCoordinateConverter() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TMapToCanvasCoordinateConverter() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTaggedElement : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TStringList* FTags;
	
public:
	__fastcall TTaggedElement();
	__fastcall virtual ~TTaggedElement();
	void __fastcall AddTag(const System::UnicodeString stName, const System::UnicodeString stValue);
	bool __fastcall IsHaveAllTags(System::Classes::TStrings* LayerTags);
	bool __fastcall IsHaveAnyTag(System::Classes::TStrings* LayerTags);
	__property System::Classes::TStringList* Tags = {read=FTags};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxMapXMLReader : public Frxxml::TfrxXMLReader
{
	typedef Frxxml::TfrxXMLReader inherited;
	
protected:
	bool __fastcall IsLastSlash(const System::UnicodeString InSt);
	bool __fastcall IsFirstSlash(const System::UnicodeString InSt);
	void __fastcall ReadValuedItem(System::UnicodeString &NameS, System::UnicodeString &ValueS, System::UnicodeString &Text);
	
public:
	bool __fastcall IsReadMapXMLRootItem(Frxxml::TfrxXMLItem* Item);
	bool __fastcall IsReadMapXMLItem(Frxxml::TfrxXMLItem* Item);
public:
	/* TfrxXMLReader.Create */ inline __fastcall TfrxMapXMLReader(System::Classes::TStream* Stream) : Frxxml::TfrxXMLReader(Stream) { }
	/* TfrxXMLReader.Destroy */ inline __fastcall virtual ~TfrxMapXMLReader() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxMapXMLDocument : public Frxxml::TfrxXMLDocument
{
	typedef Frxxml::TfrxXMLDocument inherited;
	
protected:
	System::Classes::TFileStream* FMapXMLStream;
	TfrxMapXMLReader* FMapXMLStreamReader;
	
public:
	void __fastcall InitMapXMLFile(const System::UnicodeString FileName);
	void __fastcall DoneMapXMLFile();
	bool __fastcall IsReadItem(Frxxml::TfrxXMLItem* Item);
public:
	/* TfrxXMLDocument.Create */ inline __fastcall TfrxMapXMLDocument() : Frxxml::TfrxXMLDocument() { }
	/* TfrxXMLDocument.Destroy */ inline __fastcall virtual ~TfrxMapXMLDocument() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxSumStringList : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
private:
	int __fastcall GetSum(int i);
	void __fastcall SetSum(int i, const int Value);
	
public:
	void __fastcall AddSum(System::UnicodeString st);
	void __fastcall SortSum();
	__property int Sum[int i] = {read=GetSum, write=SetSum};
public:
	/* TStringList.Create */ inline __fastcall TfrxSumStringList()/* overload */ : System::Classes::TStringList() { }
	/* TStringList.Create */ inline __fastcall TfrxSumStringList(bool OwnsObjects)/* overload */ : System::Classes::TStringList(OwnsObjects) { }
	/* TStringList.Create */ inline __fastcall TfrxSumStringList(System::WideChar QuoteChar, System::WideChar Delimiter)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter) { }
	/* TStringList.Create */ inline __fastcall TfrxSumStringList(System::WideChar QuoteChar, System::WideChar Delimiter, System::Classes::TStringsOptions Options)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter, Options) { }
	/* TStringList.Create */ inline __fastcall TfrxSumStringList(System::Types::TDuplicates Duplicates, bool Sorted, bool CaseSensitive)/* overload */ : System::Classes::TStringList(Duplicates, Sorted, CaseSensitive) { }
	/* TStringList.Destroy */ inline __fastcall virtual ~TfrxSumStringList() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxClippingRect : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Frxclass::TfrxRect FR;
	bool FActive;
	
public:
	__fastcall TfrxClippingRect();
	void __fastcall Init(bool Active, const Frxclass::TfrxRect &R);
	bool __fastcall IsCircleInside(const Frxanaliticgeometry::TCircle &Circle);
	bool __fastcall IsPolygonCover(Frxanaliticgeometry::TPointArray PolyPoints)/* overload */;
	bool __fastcall IsPolygonCover(Frxanaliticgeometry::TDoublePointArray PolyPoints)/* overload */;
	bool __fastcall IsPolygonCover(TShapeData* ShapeData, int iPart)/* overload */;
	bool __fastcall IsPointInside(const Frxclass::TfrxPoint &P);
	bool __fastcall IsPolyLineInside(Frxanaliticgeometry::TPointArray PolyPoints)/* overload */;
	bool __fastcall IsPolyLineInside(Frxanaliticgeometry::TDoublePointArray PolyPoints)/* overload */;
	bool __fastcall IsPolyLineInside(TShapeData* ShapeData, int iPart)/* overload */;
	bool __fastcall IsPolygonInside(Frxanaliticgeometry::TPointArray PolyPoints)/* overload */;
	bool __fastcall IsPolygonInside(Frxanaliticgeometry::TDoublePointArray PolyPoints)/* overload */;
	bool __fastcall IsPolygonInside(TShapeData* ShapeData, int iPart)/* overload */;
	bool __fastcall IsSegmentInside(const Frxanaliticgeometry::TSegment &S);
	bool __fastcall IsRectInside(const System::Types::TRect &Rect);
	bool __fastcall IsDiamondInside(const System::Types::TRect &Rect);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxClippingRect() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE _BLENDFUNCTION Bitmap32BF;
extern DELPHI_PACKAGE System::UnicodeString __fastcall PlatformFileName(const System::UnicodeString FileName);
extern DELPHI_PACKAGE bool __fastcall IsCanPngToTransparentBitmap32(Vcl::Imaging::Pngimage::TPngImage* PNG, /* out */ Vcl::Graphics::TBitmap* &Bitmap);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ToHex(System::Byte b);
extern DELPHI_PACKAGE void __fastcall Log(System::Classes::TStream* Stream)/* overload */;
extern DELPHI_PACKAGE void __fastcall Log(System::Classes::TStrings* Strings)/* overload */;
extern DELPHI_PACKAGE void __fastcall Log(System::UnicodeString Text)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall SafeFileName(System::UnicodeString FileName);
extern DELPHI_PACKAGE void __fastcall Simplify(Frxanaliticgeometry::TDoublePointArray Points, System::Extended Accuracy, int &UsedCount);
extern DELPHI_PACKAGE void __fastcall TranslateMenu(Vcl::Menus::TMenu* Menu);
extern DELPHI_PACKAGE void __fastcall Translate(Vcl::Controls::TWinControl* WinControl);
}	/* namespace Frxmaphelpers */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPHELPERS)
using namespace Frxmaphelpers;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmaphelpersHPP
