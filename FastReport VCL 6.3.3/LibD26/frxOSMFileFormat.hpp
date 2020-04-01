// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxOSMFileFormat.pas' rev: 33.00 (Windows)

#ifndef FrxosmfileformatHPP
#define FrxosmfileformatHPP

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

//-- user supplied -----------------------------------------------------------

namespace Frxosmfileformat
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOSMNode;
class DELPHICLASS TOSMWay;
class DELPHICLASS TOSMFile;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOSMNode : public Frxmaphelpers::TTaggedElement
{
	typedef Frxmaphelpers::TTaggedElement inherited;
	
private:
	double FLatitude;
	double FLongitude;
	
public:
	__fastcall TOSMNode(double Lat, double Lon);
	__property double Latitude = {read=FLatitude};
	__property double Longitude = {read=FLongitude};
public:
	/* TTaggedElement.Destroy */ inline __fastcall virtual ~TOSMNode() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOSMWay : public Frxmaphelpers::TTaggedElement
{
	typedef Frxmaphelpers::TTaggedElement inherited;
	
private:
	int __fastcall GetCount();
	Frxmaphelpers::TShapeType __fastcall GetShapeType();
	System::UnicodeString __fastcall GetNodes(int Index);
	
protected:
	System::Classes::TStringList* FNodeRefs;
	
public:
	__fastcall TOSMWay();
	__fastcall virtual ~TOSMWay();
	void __fastcall AddNodeRef(const System::UnicodeString stNodeRef);
	__property int Count = {read=GetCount, nodefault};
	__property Frxmaphelpers::TShapeType ShapeType = {read=GetShapeType, nodefault};
	__property System::UnicodeString NodeRefs[int Index] = {read=GetNodes};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOSMFile : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	double FXmin;
	double FYmin;
	double FXmax;
	double FYmax;
	int __fastcall GetCountOfNodes();
	int __fastcall GetCountOfWays();
	TOSMWay* __fastcall GetWays(int Index);
	TOSMNode* __fastcall GetNodes(int Index);
	
protected:
	System::Classes::TStringList* FOSMNodes;
	System::Classes::TStringList* FOSMWays;
	Frxmaphelpers::TfrxSumStringList* FSumTags;
	void __fastcall Load(const System::UnicodeString FileName);
	void __fastcall LoadBounds(Frxxml::TfrxXMLItem* XMLItem);
	void __fastcall LoadNode(Frxxml::TfrxXMLItem* XMLItem);
	void __fastcall LoadWay(Frxxml::TfrxXMLItem* XMLItem);
	void __fastcall ParseItem(Frxxml::TfrxXMLItem* XMLItem);
	System::UnicodeString __fastcall ValidUTF8(System::UnicodeString st);
	
public:
	__fastcall TOSMFile(const System::UnicodeString FileName);
	__fastcall virtual ~TOSMFile();
	bool __fastcall IsGetNodeAsPoint(const int iWay, const int iNode, /* out */ Frxanaliticgeometry::TDoublePoint &DP);
	__property double Xmin = {read=FXmin};
	__property double Ymin = {read=FYmin};
	__property double Xmax = {read=FXmax};
	__property double Ymax = {read=FYmax};
	__property int CountOfWays = {read=GetCountOfWays, nodefault};
	__property TOSMWay* Ways[int Index] = {read=GetWays};
	__property int CountOfNodes = {read=GetCountOfNodes, nodefault};
	__property TOSMNode* Nodes[int Index] = {read=GetNodes};
	__property Frxmaphelpers::TfrxSumStringList* SumTags = {read=FSumTags};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxosmfileformat */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXOSMFILEFORMAT)
using namespace Frxosmfileformat;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxosmfileformatHPP
