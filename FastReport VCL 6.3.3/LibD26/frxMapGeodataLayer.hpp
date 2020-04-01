// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapGeodataLayer.pas' rev: 33.00 (Windows)

#ifndef FrxmapgeodatalayerHPP
#define FrxmapgeodatalayerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <frxMapLayer.hpp>
#include <frxMapHelpers.hpp>
#include <frxClass.hpp>
#include <frxMapShape.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmapgeodatalayer
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMapGeodataLayer;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TGeoDataKind : unsigned char { gdWKT, gdWKB };

class PASCALIMPLEMENTATION TfrxMapGeodataLayer : public Frxmaplayer::TfrxCustomLayer
{
	typedef Frxmaplayer::TfrxCustomLayer inherited;
	
private:
	System::UnicodeString FBorderColorColumn;
	System::UnicodeString FFillColorColumn;
	System::UnicodeString FDataColumn;
	TGeoDataKind FGeoDataKind;
	Frxclass::TfrxDataSet* FMapDataSet;
	
protected:
	virtual System::UnicodeString __fastcall GetSelectedShapeName();
	virtual System::UnicodeString __fastcall GetSelectedShapeValue();
	virtual void __fastcall InitialiseData();
	void __fastcall LoadShapes();
	virtual bool __fastcall IsCanGetData();
	bool __fastcall IsWideText();
	void __fastcall LoadGeoData(System::Classes::TMemoryStream* MemoryStream, System::Classes::TStringList* Tags);
	virtual void __fastcall AddValueList(const System::Variant &vaAnalyticalValue);
	virtual bool __fastcall IsSpecialBorderColor(int iRecord, /* out */ System::Uitypes::TColor &SpecialColor);
	virtual bool __fastcall IsSpecialFillColor(int iRecord, /* out */ System::Uitypes::TColor &SpecialColor);
	
public:
	__fastcall virtual TfrxMapGeodataLayer(System::Classes::TComponent* AOwner);
	virtual void __fastcall GetColumnList(System::Classes::TStrings* List);
	
__published:
	__property ShowLines = {default=1};
	__property ShowPoints = {default=1};
	__property ShowPolygons = {default=1};
	__property LabelColumn = {default=0};
	__property SpatialColumn = {default=0};
	__property MapAccuracy = {default=0};
	__property PixelAccuracy = {default=0};
	__property Frxclass::TfrxDataSet* MapDataSet = {read=FMapDataSet, write=FMapDataSet};
	__property System::UnicodeString BorderColorColumn = {read=FBorderColorColumn, write=FBorderColorColumn};
	__property System::UnicodeString FillColorColumn = {read=FFillColorColumn, write=FFillColorColumn};
	__property System::UnicodeString DataColumn = {read=FDataColumn, write=FDataColumn};
	__property TGeoDataKind GeoDataKind = {read=FGeoDataKind, write=FGeoDataKind, nodefault};
	__property SpatialValue = {default=0};
public:
	/* TfrxCustomLayer.Destroy */ inline __fastcall virtual ~TfrxMapGeodataLayer() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxMapGeodataLayer(System::Classes::TComponent* AOwner, System::Word Flags) : Frxmaplayer::TfrxCustomLayer(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxmapgeodatalayer */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPGEODATALAYER)
using namespace Frxmapgeodatalayer;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmapgeodatalayerHPP
