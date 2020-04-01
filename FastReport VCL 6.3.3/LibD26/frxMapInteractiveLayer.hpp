// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapInteractiveLayer.pas' rev: 33.00 (Windows)

#ifndef FrxmapinteractivelayerHPP
#define FrxmapinteractivelayerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <frxMapLayer.hpp>
#include <frxMapHelpers.hpp>
#include <frxClass.hpp>
#include <frxMapShape.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmapinteractivelayer
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMapInteractiveLayer;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxMapInteractiveLayer : public Frxmaplayer::TfrxCustomLayer
{
	typedef Frxmaplayer::TfrxCustomLayer inherited;
	
private:
	Frxmapshape::TShape* FEditedShape;
	
protected:
	virtual void __fastcall AddValueList(const System::Variant &vaAnalyticalValue);
	
public:
	__fastcall virtual TfrxMapInteractiveLayer(System::Classes::TComponent* AOwner);
	void __fastcall AddShape(Frxmaphelpers::TShapeData* const ShapeData);
	void __fastcall ReplaceShape(Frxmaphelpers::TShapeData* const ShapeData);
	bool __fastcall IsSelectEditedShape(const Frxclass::TfrxPoint &P, System::Extended Threshold);
	virtual bool __fastcall IsHighlightSelectedShape();
	virtual bool __fastcall IsHiddenShape(int iRecord);
	bool __fastcall IsEditing();
	void __fastcall CancelEditedShape(bool NeedRebuild = true);
	void __fastcall RemoveEditedShape();
	__property Frxmapshape::TShape* EditedShape = {read=FEditedShape};
	
__published:
	__property LabelColumn = {default=0};
public:
	/* TfrxCustomLayer.Destroy */ inline __fastcall virtual ~TfrxMapInteractiveLayer() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxMapInteractiveLayer(System::Classes::TComponent* AOwner, System::Word Flags) : Frxmaplayer::TfrxCustomLayer(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxmapinteractivelayer */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPINTERACTIVELAYER)
using namespace Frxmapinteractivelayer;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmapinteractivelayerHPP
