// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxZipCode.pas' rev: 33.00 (Windows)

#ifndef FrxzipcodeHPP
#define FrxzipcodeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Types.hpp>
#include <frxClass.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxzipcode
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxZipCodeView;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TZipCodeKind : unsigned char { zcCustom, zcInternational, zcRF, zcSample };

class PASCALIMPLEMENTATION TfrxZipCodeView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	System::Extended FmmDigitWidth;
	System::Extended FmmDigitHeight;
	System::Extended FmmSpacing;
	System::Extended FmmLineWidth;
	bool FShowMarkers;
	bool FShowGrid;
	System::UnicodeString FExpression;
	System::UnicodeString FText;
	int FDigitCount;
	TZipCodeKind FKind;
	System::Uitypes::TColor FColor;
	void __fastcall SetKind(const TZipCodeKind Value);
	void __fastcall SetmmDigitWidth(const System::Extended Value);
	void __fastcall SetmmDigitHeight(const System::Extended Value);
	void __fastcall SetmmLineWidth(const System::Extended Value);
	void __fastcall SetmmSpacing(const System::Extended Value);
	void __fastcall SetDigitCount(const int Value);
	void __fastcall SetShowMarkers(const bool Value);
	void __fastcall SetShowGrid(const bool Value);
	void __fastcall SetText(const System::UnicodeString Value);
	
protected:
	int FMarker;
	Frxclass::TfrxPoint F1mm;
	System::Extended FSpacing;
	System::Extended FMarkerHeight;
	System::Extended FMarkerWidth;
	Frxclass::TfrxPoint FGridPoint;
	Frxclass::TfrxPoint FGridStep;
	Frxclass::TfrxPoint FDigitLeftTop;
	System::Extended FDigitWidth;
	System::Extended FDigitHeight;
	System::Extended FDigitPenThickness;
	void __fastcall DrawSegment(Vcl::Graphics::TCanvas* Canvas, int Number);
	void __fastcall PaintPolyline(Vcl::Graphics::TCanvas* Canvas, const System::Types::TPoint *Ps, const int Ps_High);
	
public:
	__fastcall virtual TfrxZipCodeView(System::Classes::TComponent* AOwner);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall GetData();
	
__published:
	__property FillType = {default=0};
	__property Fill;
	__property Cursor = {default=0};
	__property DataField = {default=0};
	__property DataSet;
	__property DataSetName = {default=0};
	__property System::UnicodeString Expression = {read=FExpression, write=FExpression};
	__property System::UnicodeString Text = {read=FText, write=SetText};
	__property TZipCodeKind Kind = {read=FKind, write=SetKind, nodefault};
	__property System::Extended mmDigitWidth = {read=FmmDigitWidth, write=SetmmDigitWidth};
	__property System::Extended mmDigitHeight = {read=FmmDigitHeight, write=SetmmDigitHeight};
	__property System::Extended mmLineWidth = {read=FmmLineWidth, write=SetmmLineWidth};
	__property System::Extended mmSpacing = {read=FmmSpacing, write=SetmmSpacing};
	__property int DigitCount = {read=FDigitCount, write=SetDigitCount, nodefault};
	__property bool ShowMarkers = {read=FShowMarkers, write=SetShowMarkers, nodefault};
	__property bool ShowGrid = {read=FShowGrid, write=SetShowGrid, nodefault};
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, nodefault};
public:
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxZipCodeView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxZipCodeView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxzipcode */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXZIPCODE)
using namespace Frxzipcode;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxzipcodeHPP
