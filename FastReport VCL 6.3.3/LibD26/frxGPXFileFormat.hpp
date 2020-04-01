// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGPXFileFormat.pas' rev: 33.00 (Windows)

#ifndef FrxgpxfileformatHPP
#define FrxgpxfileformatHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <frxXML.hpp>
#include <System.Classes.hpp>
#include <frxMapHelpers.hpp>
#include <frxAnaliticGeometry.hpp>
#include <System.Contnrs.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgpxfileformat
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGPXAnyPoint;
class DELPHICLASS TGPXTrackSegment;
class DELPHICLASS TGPXTrack;
class DELPHICLASS TGPXFile;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TGPXAnyPoint : public Frxmaphelpers::TTaggedElement
{
	typedef Frxmaphelpers::TTaggedElement inherited;
	
private:
	double FLatitude;
	double FLongitude;
	
public:
	__fastcall TGPXAnyPoint(double Lat, double Lon);
	__property double Latitude = {read=FLatitude};
	__property double Longitude = {read=FLongitude};
public:
	/* TTaggedElement.Destroy */ inline __fastcall virtual ~TGPXAnyPoint() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TGPXTrackSegment : public Frxmaphelpers::TTaggedElement
{
	typedef Frxmaphelpers::TTaggedElement inherited;
	
private:
	System::Contnrs::TObjectList* FTrackPoints;
	
public:
	__fastcall TGPXTrackSegment();
	__fastcall virtual ~TGPXTrackSegment();
	void __fastcall GetSegmentPoints(/* out */ Frxanaliticgeometry::TDoublePointArray &DPA);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGPXTrack : public Frxmaphelpers::TTaggedElement
{
	typedef Frxmaphelpers::TTaggedElement inherited;
	
private:
	System::Contnrs::TObjectList* FTrackSegments;
	Frxmaphelpers::TShapeType __fastcall GetShapeType();
	int __fastcall GetCount();
	
public:
	__fastcall TGPXTrack();
	__fastcall virtual ~TGPXTrack();
	void __fastcall GetSegmentPoints(int iTrackSegment, /* out */ Frxanaliticgeometry::TDoublePointArray &DPA);
	__property int Count = {read=GetCount, nodefault};
	__property Frxmaphelpers::TShapeType ShapeType = {read=GetShapeType, nodefault};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TGPXFile : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	double FXmin;
	double FYmin;
	double FXmax;
	double FYmax;
	int __fastcall GetCountOfTracks();
	int __fastcall GetCountOfWayPoints();
	TGPXAnyPoint* __fastcall GetWayPoints(int Index);
	TGPXTrack* __fastcall GetTracks(int Index);
	
protected:
	System::Contnrs::TObjectList* FWayPoints;
	System::Contnrs::TObjectList* FTracks;
	bool FValidBounds;
	void __fastcall Load(const System::UnicodeString FileName);
	void __fastcall LoadBounds(Frxxml::TfrxXMLItem* XMLItem);
	void __fastcall LoadMetadata(Frxxml::TfrxXMLItem* XMLItem);
	TGPXAnyPoint* __fastcall fnLoadAnyPoint(Frxxml::TfrxXMLItem* XMLItem);
	TGPXTrack* __fastcall fnLoadTrack(Frxxml::TfrxXMLItem* XMLItem);
	TGPXTrackSegment* __fastcall fnLoadTrackSegment(Frxxml::TfrxXMLItem* XMLItem);
	TGPXTrack* __fastcall fnLoadRoute(Frxxml::TfrxXMLItem* XMLItem);
	void __fastcall ParseItem(Frxxml::TfrxXMLItem* XMLItem);
	
public:
	__fastcall TGPXFile(const System::UnicodeString FileName);
	__fastcall virtual ~TGPXFile();
	bool __fastcall IsValidBounds();
	__property double Xmin = {read=FXmin};
	__property double Ymin = {read=FYmin};
	__property double Xmax = {read=FXmax};
	__property double Ymax = {read=FYmax};
	__property int CountOfWayPoints = {read=GetCountOfWayPoints, nodefault};
	__property TGPXAnyPoint* WayPoints[int Index] = {read=GetWayPoints};
	__property int CountOfTracks = {read=GetCountOfTracks, nodefault};
	__property TGPXTrack* Tracks[int Index] = {read=GetTracks};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxgpxfileformat */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGPXFILEFORMAT)
using namespace Frxgpxfileformat;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgpxfileformatHPP
