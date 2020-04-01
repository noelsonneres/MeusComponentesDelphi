// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxAnaliticGeometry.pas' rev: 33.00 (Windows)

#ifndef FrxanaliticgeometryHPP
#define FrxanaliticgeometryHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxanaliticgeometry
{
//-- forward type declarations -----------------------------------------------
struct TDoublePoint;
struct TDoubleRect;
struct TCircle;
struct TSegment;
class DELPHICLASS TMinDistance;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TDoublePoint
{
public:
	double X;
	double Y;
};


struct DECLSPEC_DRECORD TDoubleRect
{
	
public:
	union
	{
		struct 
		{
			TDoublePoint TopLeft;
			TDoublePoint BottomRight;
		};
		struct 
		{
			double Left;
			double Top;
			double Right;
			double Bottom;
		};
		
	};
};


typedef System::DynamicArray<System::Types::TPoint> TPointArray;

typedef System::DynamicArray<double> TDoubleArray;

typedef System::DynamicArray<TDoublePoint> TDoublePointArray;

typedef System::DynamicArray<TDoublePointArray> TDoublePointMatrix;

struct DECLSPEC_DRECORD TCircle
{
public:
	System::Extended X;
	System::Extended Y;
	System::Extended Radius;
};


struct DECLSPEC_DRECORD TSegment
{
public:
	Frxclass::TfrxPoint First;
	Frxclass::TfrxPoint Second;
};


class PASCALIMPLEMENTATION TMinDistance : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Extended FValue;
	int FIndex;
	System::Extended FTreshold;
	
public:
	__fastcall TMinDistance(System::Extended ATreshold);
	void __fastcall Init(System::Extended ATreshold);
	void __fastcall Add(System::Extended AValue, int AIndex);
	bool __fastcall IsNear();
	bool __fastcall IsZero();
	__property int Index = {read=FIndex, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TMinDistance() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 Unknown = System::Int8(-1);
static const System::Int8 MinSelectDistance = System::Int8(0x8);
static const System::Extended MaxDistance = 1.000000E+38;
extern DELPHI_PACKAGE TCircle __fastcall Circle(System::Extended X, System::Extended Y, System::Extended Radius);
extern DELPHI_PACKAGE TSegment __fastcall Segment(const TDoublePoint &P1, const TDoublePoint &P2)/* overload */;
extern DELPHI_PACKAGE TSegment __fastcall Segment(System::Extended x1, System::Extended y1, System::Extended x2, System::Extended y2)/* overload */;
extern DELPHI_PACKAGE TSegment __fastcall Segment(const System::Types::TPoint &P1, const System::Types::TPoint &P2)/* overload */;
extern DELPHI_PACKAGE TSegment __fastcall Segment(const Frxclass::TfrxPoint &P1, const Frxclass::TfrxPoint &P2)/* overload */;
extern DELPHI_PACKAGE TDoublePoint __fastcall DoublePoint(const Frxclass::TfrxPoint &P)/* overload */;
extern DELPHI_PACKAGE TDoublePoint __fastcall DoublePoint(System::Extended X, System::Extended Y)/* overload */;
extern DELPHI_PACKAGE TDoubleRect __fastcall DoubleRectExpand(const TDoubleRect &DR, double d)/* overload */;
extern DELPHI_PACKAGE TDoubleRect __fastcall DoubleRectExpand(const TDoubleRect &DR, double dX, double dY)/* overload */;
extern DELPHI_PACKAGE TDoubleRect __fastcall DoubleRect(double Left, double Top, double Right, double Bottom)/* overload */;
extern DELPHI_PACKAGE TDoubleRect __fastcall DoubleRect(const System::Types::TRect &R)/* overload */;
extern DELPHI_PACKAGE TDoubleRect __fastcall DoubleRect(const Frxclass::TfrxPoint &TL, const Frxclass::TfrxPoint &BR)/* overload */;
extern DELPHI_PACKAGE TDoubleRect __fastcall ConstrainedDR(const TDoubleRect &DR, double ConstrainWidth, double ConstrainHeight);
extern DELPHI_PACKAGE System::Types::TRect __fastcall ToRect(const TDoubleRect &DR);
extern DELPHI_PACKAGE System::Types::TPoint __fastcall ToPoint(System::Extended X, System::Extended Y)/* overload */;
extern DELPHI_PACKAGE System::Types::TPoint __fastcall ToPoint(const Frxclass::TfrxPoint &frxPoint)/* overload */;
extern DELPHI_PACKAGE Frxclass::TfrxPoint __fastcall ToFrxPoint(const System::Types::TPoint &Point);
extern DELPHI_PACKAGE Frxclass::TfrxPoint __fastcall CenterRect(const Frxclass::TfrxRect &R);
extern DELPHI_PACKAGE void __fastcall InitRect(Frxclass::TfrxRect &R, const TDoublePoint &DP);
extern DELPHI_PACKAGE void __fastcall ExpandRect(Frxclass::TfrxRect &R, const Frxclass::TfrxRect &R1)/* overload */;
extern DELPHI_PACKAGE void __fastcall ExpandRect(Frxclass::TfrxRect &R, const TDoublePoint &DP)/* overload */;
extern DELPHI_PACKAGE void __fastcall ExpandRect(Frxclass::TfrxRect &R, System::Extended X, System::Extended Y)/* overload */;
extern DELPHI_PACKAGE System::Extended __fastcall RectWidth(const Frxclass::TfrxRect &R);
extern DELPHI_PACKAGE System::Extended __fastcall RectHeight(const Frxclass::TfrxRect &R);
extern DELPHI_PACKAGE System::Extended __fastcall DistanceMultiPolygon(TDoublePointMatrix Matrix, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistanceMultiPolyline(TDoublePointMatrix Matrix, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistanceMultiPoint(TDoublePointMatrix Matrix, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistanceSegment(const TSegment &Segment, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistancePolygon(TDoublePointArray Poly, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistancePolyline(TDoublePointArray Poly, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistanceTemplate(TDoublePointArray Poly, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall Distance(const TDoublePoint &P1, const Frxclass::TfrxPoint &P2)/* overload */;
extern DELPHI_PACKAGE System::Extended __fastcall Distance(const Frxclass::TfrxPoint &P1, const Frxclass::TfrxPoint &P2)/* overload */;
extern DELPHI_PACKAGE System::Extended __fastcall Distance(const Frxclass::TfrxPoint &P, System::Extended X, System::Extended Y)/* overload */;
extern DELPHI_PACKAGE System::Extended __fastcall Distance(const System::Types::TPoint &P, System::Extended X, System::Extended Y)/* overload */;
extern DELPHI_PACKAGE System::Extended __fastcall DistanceRect(const TDoubleRect &Rect, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE Frxclass::TfrxPoint __fastcall IntersectionEllipse(const TDoubleRect &Rect, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistanceEllipse(const TDoubleRect &Rect, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistancePicture(const TDoubleRect &Rect, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE System::Extended __fastcall DistanceDiamond(const TDoubleRect &Rect, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE bool __fastcall IsPointInPolygon(System::Extended x, System::Extended y, TPointArray PolyPoints);
extern DELPHI_PACKAGE bool __fastcall IsSegmentsIntersect(const TSegment &S1, const TSegment &S2);
extern DELPHI_PACKAGE Frxclass::TfrxRect __fastcall frxCanonicalRect(System::Extended ALeft, System::Extended ATop, System::Extended ARight, System::Extended ABottom)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsEqual(const TDoublePoint &P1, const TDoublePoint &P2);
extern DELPHI_PACKAGE bool __fastcall IsInsideDiamond(const TDoubleRect &R, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE bool __fastcall IsInsideMultiPolyline(TDoublePointMatrix Matrix, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE bool __fastcall IsInsideMultiPolygon(TDoublePointMatrix Matrix, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE bool __fastcall IsInsidePolyline(TDoublePointArray Poly, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE bool __fastcall IsInsidePolygon(TDoublePointArray Poly, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE bool __fastcall IsInsideEllipse(const TDoubleRect &R, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE bool __fastcall IsInsideRect(const TDoubleRect &R, const Frxclass::TfrxPoint &P);
extern DELPHI_PACKAGE bool __fastcall IsInside(System::Extended Value, System::Extended Start, System::Extended Finish);
extern DELPHI_PACKAGE bool __fastcall IsPointInRect(const Frxclass::TfrxPoint &P, const Frxclass::TfrxRect &R);
extern DELPHI_PACKAGE Frxclass::TfrxRect __fastcall frxCanonicalRect(const TDoubleRect &DR)/* overload */;
extern DELPHI_PACKAGE System::Extended __fastcall Boundary(System::Extended Value, System::Extended MinValue, System::Extended MaxValue);
}	/* namespace Frxanaliticgeometry */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXANALITICGEOMETRY)
using namespace Frxanaliticgeometry;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxanaliticgeometryHPP
