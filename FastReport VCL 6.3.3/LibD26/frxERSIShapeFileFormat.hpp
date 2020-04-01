// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxERSIShapeFileFormat.pas' rev: 33.00 (Windows)

#ifndef FrxersishapefileformatHPP
#define FrxersishapefileformatHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.Contnrs.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Types.hpp>
#include <frxERSIShapeDBFImport.hpp>
#include <frxClass.hpp>
#include <frxMapHelpers.hpp>
#include <frxAnaliticGeometry.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxersishapefileformat
{
//-- forward type declarations -----------------------------------------------
struct TERSIMainFileHeader;
struct TERSIMainFileRecordHeader;
class DELPHICLASS TERSINull;
class DELPHICLASS TERSIPoint;
struct TDoublePointM;
class DELPHICLASS TERSIPointM;
struct TDoublePointZ;
class DELPHICLASS TERSIPointZ;
struct TBox;
class DELPHICLASS TERSIMultiPoint;
class DELPHICLASS TERSIMultiPointM;
class DELPHICLASS TERSIMultiPointZ;
class DELPHICLASS TERSIPolyLine;
class DELPHICLASS TERSIPolygon;
class DELPHICLASS TERSIPolyLineM;
class DELPHICLASS TERSIPolygonM;
class DELPHICLASS TERSIPolyLineZ;
class DELPHICLASS TERSIPolygonZ;
class DELPHICLASS TMultiPath;
class DELPHICLASS TERSIShapeFile;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD TERSIMainFileHeader
{
public:
	int FileCode;
	System::StaticArray<int, 5> Unused;
	int FileLength;
	int Version;
	int ShapeType;
	double Xmin;
	double Ymin;
	double Xmax;
	double Ymax;
	double Zmin;
	double Zmax;
	double Mmin;
	double Mmax;
};
#pragma pack(pop)


struct DECLSPEC_DRECORD TERSIMainFileRecordHeader
{
public:
	int RecordNumber;
	int ContentLength;
	int ShapeType;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TERSINull : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TERSIMainFileRecordHeader FHeader;
	
public:
	__fastcall TERSINull(const TERSIMainFileRecordHeader &AHeader);
	__property TERSIMainFileRecordHeader Header = {read=FHeader};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSINull() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TERSIPoint : public TERSINull
{
	typedef TERSINull inherited;
	
private:
	Frxanaliticgeometry::TDoublePoint FPoint;
	
public:
	__fastcall TERSIPoint(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	__property Frxanaliticgeometry::TDoublePoint Point = {read=FPoint};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPoint() { }
	
};


struct DECLSPEC_DRECORD TDoublePointM
{
public:
	double X;
	double Y;
	double M;
};


typedef System::DynamicArray<TDoublePointM> TDoublePointMArray;

class PASCALIMPLEMENTATION TERSIPointM : public TERSINull
{
	typedef TERSINull inherited;
	
private:
	TDoublePointM FPointM;
	
public:
	__fastcall TERSIPointM(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	__property TDoublePointM PointM = {read=FPointM};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPointM() { }
	
};


struct DECLSPEC_DRECORD TDoublePointZ
{
public:
	double X;
	double Y;
	double Z;
	double M;
};


typedef System::DynamicArray<TDoublePointZ> TDoublePointZArray;

class PASCALIMPLEMENTATION TERSIPointZ : public TERSINull
{
	typedef TERSINull inherited;
	
private:
	TDoublePointZ FPointZ;
	
public:
	__fastcall TERSIPointZ(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	__property TDoublePointZ PointZ = {read=FPointZ};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPointZ() { }
	
};


struct DECLSPEC_DRECORD TBox
{
public:
	double Xmin;
	double Ymin;
	double Xmax;
	double Ymax;
};


class PASCALIMPLEMENTATION TERSIMultiPoint : public TERSINull
{
	typedef TERSINull inherited;
	
private:
	TBox FBox;
	int FNumPoints;
	Frxanaliticgeometry::TDoublePointArray FPoints;
	
public:
	__fastcall TERSIMultiPoint(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	__property TBox Box = {read=FBox};
	__property int NumPoints = {read=FNumPoints, nodefault};
	__property Frxanaliticgeometry::TDoublePointArray Points = {read=FPoints};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIMultiPoint() { }
	
};


class PASCALIMPLEMENTATION TERSIMultiPointM : public TERSIMultiPoint
{
	typedef TERSIMultiPoint inherited;
	
private:
	double FMMin;
	double FMMax;
	Frxanaliticgeometry::TDoubleArray FPointsM;
	
public:
	__fastcall TERSIMultiPointM(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	__property double MMin = {read=FMMin};
	__property double MMax = {read=FMMax};
	__property Frxanaliticgeometry::TDoubleArray PointsM = {read=FPointsM};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIMultiPointM() { }
	
};


class PASCALIMPLEMENTATION TERSIMultiPointZ : public TERSIMultiPoint
{
	typedef TERSIMultiPoint inherited;
	
private:
	double FZMin;
	double FZMax;
	Frxanaliticgeometry::TDoubleArray FPointsZ;
	double FMMin;
	double FMMax;
	Frxanaliticgeometry::TDoubleArray FPointsM;
	
public:
	__fastcall TERSIMultiPointZ(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	__property double ZMin = {read=FZMin};
	__property double ZMax = {read=FZMax};
	__property Frxanaliticgeometry::TDoubleArray PointsZ = {read=FPointsZ};
	__property double MMin = {read=FMMin};
	__property double MMax = {read=FMMax};
	__property Frxanaliticgeometry::TDoubleArray PointsM = {read=FPointsM};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIMultiPointZ() { }
	
};


typedef System::DynamicArray<int> TLongIntArray;

class PASCALIMPLEMENTATION TERSIPolyLine : public TERSINull
{
	typedef TERSINull inherited;
	
private:
	TBox FBox;
	int FNumParts;
	int FNumPoints;
	TLongIntArray FPartFirsPointIndex;
	Frxanaliticgeometry::TDoublePointArray FPoints;
	
public:
	__fastcall TERSIPolyLine(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	int __fastcall PartLastPointIndex(int PartNumber);
	int __fastcall PartCount(int PartNumber);
	__property TBox Box = {read=FBox};
	__property int NumParts = {read=FNumParts, nodefault};
	__property int NumPoints = {read=FNumPoints, nodefault};
	__property TLongIntArray PartFirsPointIndex = {read=FPartFirsPointIndex};
	__property Frxanaliticgeometry::TDoublePointArray Points = {read=FPoints};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPolyLine() { }
	
};


class PASCALIMPLEMENTATION TERSIPolygon : public TERSIPolyLine
{
	typedef TERSIPolyLine inherited;
	
public:
	/* TERSIPolyLine.Create */ inline __fastcall TERSIPolygon(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream) : TERSIPolyLine(AHeader, Stream) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPolygon() { }
	
};


class PASCALIMPLEMENTATION TERSIPolyLineM : public TERSIPolyLine
{
	typedef TERSIPolyLine inherited;
	
private:
	double FMMin;
	double FMMax;
	Frxanaliticgeometry::TDoubleArray FPointsM;
	
public:
	__fastcall TERSIPolyLineM(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	__property double MMin = {read=FMMin};
	__property double MMax = {read=FMMax};
	__property Frxanaliticgeometry::TDoubleArray PointsM = {read=FPointsM};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPolyLineM() { }
	
};


class PASCALIMPLEMENTATION TERSIPolygonM : public TERSIPolyLineM
{
	typedef TERSIPolyLineM inherited;
	
public:
	/* TERSIPolyLineM.Create */ inline __fastcall TERSIPolygonM(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream) : TERSIPolyLineM(AHeader, Stream) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPolygonM() { }
	
};


class PASCALIMPLEMENTATION TERSIPolyLineZ : public TERSIPolyLine
{
	typedef TERSIPolyLine inherited;
	
private:
	double FZMin;
	double FZMax;
	Frxanaliticgeometry::TDoubleArray FPointsZ;
	double FMMin;
	double FMMax;
	Frxanaliticgeometry::TDoubleArray FPointsM;
	
public:
	__fastcall TERSIPolyLineZ(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	__property double ZMin = {read=FZMin};
	__property double MZax = {read=FZMax};
	__property Frxanaliticgeometry::TDoubleArray PointsZ = {read=FPointsZ};
	__property double MMin = {read=FMMin};
	__property double MMax = {read=FMMax};
	__property Frxanaliticgeometry::TDoubleArray PointsM = {read=FPointsM};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPolyLineZ() { }
	
};


class PASCALIMPLEMENTATION TERSIPolygonZ : public TERSIPolyLineZ
{
	typedef TERSIPolyLineZ inherited;
	
public:
	/* TERSIPolyLineZ.Create */ inline __fastcall TERSIPolygonZ(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream) : TERSIPolyLineZ(AHeader, Stream) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TERSIPolygonZ() { }
	
};


class PASCALIMPLEMENTATION TMultiPath : public TERSINull
{
	typedef TERSINull inherited;
	
private:
	TBox FBox;
	int FNumParts;
	int FNumPoints;
	TLongIntArray FPartFirsPointIndex;
	TLongIntArray FPartTypes;
	Frxanaliticgeometry::TDoublePointArray FPoints;
	double FZMin;
	double FZMax;
	Frxanaliticgeometry::TDoubleArray FPointsZ;
	double FMMin;
	double FMMax;
	Frxanaliticgeometry::TDoubleArray FPointsM;
	
public:
	__fastcall TMultiPath(const TERSIMainFileRecordHeader &AHeader, System::Classes::TStream* Stream);
	int __fastcall PartLastPointIndex(int PartNumber);
	int __fastcall PartCount(int PartNumber);
	__property TBox Box = {read=FBox};
	__property int NumParts = {read=FNumParts, nodefault};
	__property int NumPoints = {read=FNumPoints, nodefault};
	__property TLongIntArray PartFirsPointIndex = {read=FPartFirsPointIndex};
	__property TLongIntArray PartTypes = {read=FPartTypes};
	__property Frxanaliticgeometry::TDoublePointArray Points = {read=FPoints};
	__property double ZMin = {read=FZMin};
	__property double MZax = {read=FZMax};
	__property Frxanaliticgeometry::TDoubleArray PointsZ = {read=FPointsZ};
	__property double MMin = {read=FMMin};
	__property double MMax = {read=FMMax};
	__property Frxanaliticgeometry::TDoubleArray PointsM = {read=FPointsM};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TMultiPath() { }
	
};


class PASCALIMPLEMENTATION TERSIShapeFile : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int __fastcall GetRecordCount();
	int __fastcall GetPolyPartsCount(int iRecord);
	int __fastcall GetPolyPointsCount(int iRecord, int iPart);
	int __fastcall GetMultiPointCount(int iRecord);
	Frxanaliticgeometry::TDoublePoint __fastcall GetPolyPoint(int iRecord, int iPart, int iPoint);
	Frxanaliticgeometry::TDoublePoint __fastcall GetPoint(int iRecord);
	Frxanaliticgeometry::TDoublePoint __fastcall GetMultiPoint(int iRecord, int iPoint);
	System::AnsiString __fastcall GetLegend(System::AnsiString FieldName, int iRecord);
	int __fastcall GetERSIShapeType(int iRecord);
	System::AnsiString __fastcall GetLegendByColumn(int iColumn, int iRecord);
	System::UnicodeString __fastcall GetLegendToString(int iColumn, int iRecord);
	
protected:
	TERSIMainFileHeader FMainFileHeader;
	double XRange;
	double YRange;
	System::Contnrs::TObjectList* FList;
	Frxersishapedbfimport::TERSIDBFFile* FDBFFile;
	void __fastcall SwapEndianness(int &Value);
	void __fastcall ReadFromStream(System::Classes::TStream* Stream);
	
public:
	__fastcall TERSIShapeFile(const System::UnicodeString FileName);
	__fastcall virtual ~TERSIShapeFile();
	void __fastcall GetColumnList(System::Classes::TStrings* List);
	void __fastcall GetPartPoints(Frxanaliticgeometry::TDoublePointArray &PartPoints, int iRecord, int iPart);
	__property double Xmin = {read=FMainFileHeader.Xmin};
	__property double Ymin = {read=FMainFileHeader.Ymin};
	__property double Xmax = {read=FMainFileHeader.Xmax};
	__property double Ymax = {read=FMainFileHeader.Ymax};
	__property int RecordCount = {read=GetRecordCount, nodefault};
	__property int PolyPartsCount[int iRecord] = {read=GetPolyPartsCount};
	__property int PolyPointsCount[int iRecord][int iPart] = {read=GetPolyPointsCount};
	__property int MultiPointCount[int iRecord] = {read=GetMultiPointCount};
	__property System::AnsiString Legend[System::AnsiString FieldName][int iRecord] = {read=GetLegend};
	__property System::AnsiString LegendByColumn[int iColumn][int iRecord] = {read=GetLegendByColumn};
	__property System::UnicodeString LegendToString[int iColumn][int iRecord] = {read=GetLegendToString};
	__property int ERSIShapeType[int iRecord] = {read=GetERSIShapeType};
	__property Frxanaliticgeometry::TDoublePoint PolyPoint[int iRecord][int iPart][int iPoint] = {read=GetPolyPoint};
	__property Frxanaliticgeometry::TDoublePoint Point[int iRecord] = {read=GetPoint};
	__property Frxanaliticgeometry::TDoublePoint MultiPoint[int iRecord][int iPoint] = {read=GetMultiPoint};
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 ERSI_Null = System::Int8(0x0);
static const System::Int8 ERSI_Point = System::Int8(0x1);
static const System::Int8 ERSI_PolyLine = System::Int8(0x3);
static const System::Int8 ERSI_Polygon = System::Int8(0x5);
static const System::Int8 ERSI_MultiPoint = System::Int8(0x8);
static const System::Int8 ERSI_PointZ = System::Int8(0xb);
static const System::Int8 ERSI_PolyLineZ = System::Int8(0xd);
static const System::Int8 ERSI_PolygonZ = System::Int8(0xf);
static const System::Int8 ERSI_MultiPointZ = System::Int8(0x12);
static const System::Int8 ERSI_PointM = System::Int8(0x15);
static const System::Int8 ERSI_PolyLineM = System::Int8(0x17);
static const System::Int8 ERSI_PolygonM = System::Int8(0x19);
static const System::Int8 ERSI_MultiPointM = System::Int8(0x1c);
static const System::Int8 ERSI_MultiPatch = System::Int8(0x1f);
}	/* namespace Frxersishapefileformat */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXERSISHAPEFILEFORMAT)
using namespace Frxersishapefileformat;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxersishapefileformatHPP
