// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapShape.pas' rev: 33.00 (Windows)

#ifndef FrxmapshapeHPP
#define FrxmapshapeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.Contnrs.hpp>
#include <frxClass.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Types.hpp>
#include <frxMapHelpers.hpp>
#include <frxOSMFileFormat.hpp>
#include <frxGPXFileFormat.hpp>
#include <frxERSIShapeFileFormat.hpp>
#include <frxAnaliticGeometry.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmapshape
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TShapeStyle;
class DELPHICLASS TShape;
class DELPHICLASS TAdjustableShape;
class DELPHICLASS TShapeList;
class DELPHICLASS TOSMFileList;
class DELPHICLASS TOSMShapeList;
class DELPHICLASS TGPXShapeList;
class DELPHICLASS TERSIShapeList;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TShapeStyle : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FBorderColor;
	Vcl::Graphics::TPenStyle FBorderStyle;
	int FBorderWidth;
	System::Uitypes::TColor FFillColor;
	System::Extended FPointSize;
	
public:
	__fastcall TShapeStyle();
	void __fastcall TunePen(Vcl::Graphics::TPen* Pen);
	
__published:
	__property System::Uitypes::TColor BorderColor = {read=FBorderColor, write=FBorderColor, nodefault};
	__property Vcl::Graphics::TPenStyle BorderStyle = {read=FBorderStyle, write=FBorderStyle, nodefault};
	__property int BorderWidth = {read=FBorderWidth, write=FBorderWidth, nodefault};
	__property System::Uitypes::TColor FillColor = {read=FFillColor, write=FFillColor, nodefault};
	__property System::Extended PointSize = {read=FPointSize, write=FPointSize};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TShapeStyle() { }
	
};


class PASCALIMPLEMENTATION TShape : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Extended FZoom;
	System::Extended FCenterOffsetX;
	System::Extended FCenterOffsetY;
	System::Extended FOffsetX;
	System::Extended FOffsetY;
	System::Extended FValue;
	Frxmaphelpers::TShapeType __fastcall GetShapeType();
	System::UnicodeString __fastcall GetLegend(const System::UnicodeString Name);
	int __fastcall GetPartCount();
	Frxclass::TfrxPoint __fastcall GetShapeCenter();
	System::Classes::TStringList* __fastcall GetShapeTags();
	
protected:
	Frxmaphelpers::TShapeData* FShapeData;
	virtual void __fastcall Clear();
	
public:
	void __fastcall Write(System::Classes::TWriter* Writer);
	void __fastcall WriteData(System::Classes::TWriter* Writer);
	void __fastcall Read(System::Classes::TReader* Reader);
	void __fastcall ReadData(System::Classes::TReader* Reader);
	__fastcall TShape();
	__fastcall virtual ~TShape();
	bool __fastcall IsValueEmpty();
	__property System::Extended Value = {read=FValue, write=FValue};
	__property Frxmaphelpers::TShapeType ShapeType = {read=GetShapeType, nodefault};
	__property System::UnicodeString Legend[const System::UnicodeString Name] = {read=GetLegend};
	__property int PartCount = {read=GetPartCount, nodefault};
	__property Frxclass::TfrxPoint ShapeCenter = {read=GetShapeCenter};
	__property Frxmaphelpers::TShapeData* ShapeData = {read=FShapeData};
	__property System::Extended OffsetX = {read=FOffsetX, write=FOffsetX};
	__property System::Extended OffsetY = {read=FOffsetY, write=FOffsetY};
	__property System::Extended Zoom = {read=FZoom, write=FZoom};
	
__published:
	__property System::Extended CenterOffsetX = {read=FCenterOffsetX, write=FCenterOffsetX};
	__property System::Extended CenterOffsetY = {read=FCenterOffsetY, write=FCenterOffsetY};
	__property System::Classes::TStringList* ShapeTags = {read=GetShapeTags};
};


class PASCALIMPLEMENTATION TAdjustableShape : public TShape
{
	typedef TShape inherited;
	
__published:
	__property OffsetX = {default=0};
	__property OffsetY = {default=0};
	__property Zoom = {default=0};
public:
	/* TShape.CreateClear */ inline __fastcall TAdjustableShape() : TShape() { }
	/* TShape.Destroy */ inline __fastcall virtual ~TAdjustableShape() { }
	
};


class PASCALIMPLEMENTATION TShapeList : public System::Contnrs::TObjectList
{
	typedef System::Contnrs::TObjectList inherited;
	
public:
	TShape* operator[](int Index) { return this->Items[Index]; }
	
private:
	bool FEmbeddedData;
	bool FAdjustableShape;
	TShape* __fastcall GetShape(int Index);
	void __fastcall SetShape(int Index, TShape* const AShape);
	
protected:
	System::Extended FXMin;
	System::Extended FXMax;
	System::Extended FYMin;
	System::Extended FYMax;
	Frxmaphelpers::TMapToCanvasCoordinateConverter* FConverter;
	bool FValidMapRect;
	void __fastcall SetMapRect(System::Extended XMin, System::Extended XMax, System::Extended YMin, System::Extended YMax);
	Frxanaliticgeometry::TDoublePoint __fastcall Data(int iRecord, int iPart, int iPoint);
	
public:
	__fastcall TShapeList(Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter);
	int __fastcall AddShapeData(Frxmaphelpers::TShapeData* const AShapeData);
	void __fastcall ReplaceShapeData(int iRecord, Frxmaphelpers::TShapeData* const AShapeData);
	void __fastcall ReadDFM(System::Classes::TStream* Stream);
	void __fastcall WriteDFM(System::Classes::TStream* Stream);
	void __fastcall Read(System::Classes::TReader* Reader);
	void __fastcall Write(System::Classes::TWriter* Writer);
	bool __fastcall IsGetValues(Frxanaliticgeometry::TDoubleArray &Values);
	void __fastcall ClearValues();
	bool __fastcall IsCanvasPolyPoints(int iRecord, int iPart, System::Extended MapAccuracy, System::Extended PixelAccuracy, Frxanaliticgeometry::TPointArray &PolyPoints);
	Frxclass::TfrxPoint __fastcall CanvasPoint(int iRecord);
	Frxanaliticgeometry::TDoubleRect __fastcall CanvasRect(int iRecord);
	Frxanaliticgeometry::TDoublePointArray __fastcall CanvasPoly(int iRecord);
	Frxanaliticgeometry::TDoublePointMatrix __fastcall CanvasMatrix(int iRecord);
	Frxclass::TfrxRect __fastcall CanvasWidestPartBounds(int iRecord);
	void __fastcall GetColumnList(System::Classes::TStrings* List);
	bool __fastcall IsValidMapRect(/* out */ Frxclass::TfrxRect &MapRect);
	void __fastcall SetMapRectByData();
	bool __fastcall IsHasLegend(System::UnicodeString FieldName, System::UnicodeString Legend, /* out */ int &iRecord);
	System::Extended __fastcall CanvasDistance(int iRecord, const Frxclass::TfrxPoint &P);
	bool __fastcall IsInside(int iRecord, const Frxclass::TfrxPoint &P);
	void __fastcall SaveToTextFile(System::UnicodeString FileName);
	__property TShape* Items[int Index] = {read=GetShape, write=SetShape/*, default*/};
	__property bool EmbeddedData = {read=FEmbeddedData, write=FEmbeddedData, nodefault};
	__property bool AdjustableShape = {read=FAdjustableShape, write=FAdjustableShape, nodefault};
public:
	/* TList.Destroy */ inline __fastcall virtual ~TShapeList() { }
	
};


class PASCALIMPLEMENTATION TOSMFileList : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
public:
	__fastcall TOSMFileList();
	__fastcall virtual ~TOSMFileList();
	void __fastcall AddFile(System::UnicodeString FileName);
	Frxosmfileformat::TOSMFile* __fastcall FileByName(System::UnicodeString FileName);
};


class PASCALIMPLEMENTATION TOSMShapeList : public TShapeList
{
	typedef TShapeList inherited;
	
protected:
	void __fastcall LoadData(Frxosmfileformat::TOSMFile* OSMFile, System::Classes::TStrings* LayerTags);
	
public:
	__fastcall TOSMShapeList(System::UnicodeString FileName, Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter, TOSMFileList* FileList, System::Classes::TStrings* LayerTags);
public:
	/* TShapeList.Create */ inline __fastcall TOSMShapeList(Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter) : TShapeList(Converter) { }
	
public:
	/* TList.Destroy */ inline __fastcall virtual ~TOSMShapeList() { }
	
};


class PASCALIMPLEMENTATION TGPXShapeList : public TShapeList
{
	typedef TShapeList inherited;
	
protected:
	void __fastcall LoadData(Frxgpxfileformat::TGPXFile* GPXFile);
	
public:
	__fastcall TGPXShapeList(System::UnicodeString FileName, Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter);
public:
	/* TShapeList.Create */ inline __fastcall TGPXShapeList(Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter) : TShapeList(Converter) { }
	
public:
	/* TList.Destroy */ inline __fastcall virtual ~TGPXShapeList() { }
	
};


class PASCALIMPLEMENTATION TERSIShapeList : public TShapeList
{
	typedef TShapeList inherited;
	
protected:
	void __fastcall LoadData(Frxersishapefileformat::TERSIShapeFile* ERSIFile);
	
public:
	__fastcall TERSIShapeList(System::UnicodeString FileName, Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter);
public:
	/* TShapeList.Create */ inline __fastcall TERSIShapeList(Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter) : TShapeList(Converter) { }
	
public:
	/* TList.Destroy */ inline __fastcall virtual ~TERSIShapeList() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxmapshape */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPSHAPE)
using namespace Frxmapshape;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmapshapeHPP
