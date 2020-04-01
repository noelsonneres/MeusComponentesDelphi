// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxCellularTextObject.pas' rev: 33.00 (Windows)

#ifndef FrxcellulartextobjectHPP
#define FrxcellulartextobjectHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Variants.hpp>
#include <Vcl.Controls.hpp>
#include <frxClass.hpp>
#include <frxTableObject.hpp>
#include <frxUnicodeUtils.hpp>
#include <System.WideStrings.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxcellulartextobject
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxReportCellularTextObject;
class DELPHICLASS TfrxCellularText;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxReportCellularTextObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxReportCellularTextObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxReportCellularTextObject() { }
	
};


class PASCALIMPLEMENTATION TfrxCellularText : public Frxclass::TfrxCustomMemoView
{
	typedef Frxclass::TfrxCustomMemoView inherited;
	
private:
	System::Extended FCellWidth;
	System::Extended FCellHeight;
	System::Extended FHorzSpacing;
	System::Extended FVertSpacing;
	System::Extended __fastcall GetCellWidth();
	System::Extended __fastcall GetCellHeight();
	HIDESBASE void __fastcall WrapText(System::Widestrings::TWideStrings* sLines, int ColumnCount);
	void __fastcall BuildTable(Frxtableobject::TfrxTableObject* aTable);
	
protected:
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	
public:
	__fastcall virtual TfrxCellularText(System::Classes::TComponent* AOwner);
	virtual System::Extended __fastcall CalcHeight();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual System::Extended __fastcall DrawPart();
	virtual bool __fastcall ExportInternal(Frxclass::TfrxCustomExportFilter* Filter);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property AllowExpressions = {default=1};
	__property BrushStyle;
	__property Color;
	__property System::Extended CellWidth = {read=FCellWidth, write=FCellWidth};
	__property System::Extended CellHeight = {read=FCellHeight, write=FCellHeight};
	__property System::Extended HorzSpacing = {read=FHorzSpacing, write=FHorzSpacing};
	__property System::Extended VertSpacing = {read=FVertSpacing, write=FVertSpacing};
	__property DataField = {default=0};
	__property DataSet;
	__property DataSetName = {default=0};
	__property DisplayFormat;
	__property ExpressionDelimiters = {default=0};
	__property Font;
	__property Frame;
	__property FillType = {default=0};
	__property Fill;
	__property HAlign = {default=0};
	__property HideZeros = {default=0};
	__property Highlight;
	__property Memo;
	__property ParentFont = {default=1};
	__property RTLReading = {default=0};
	__property Style = {default=0};
	__property SuppressRepeated = {default=0};
	__property UseDefaultCharset = {default=0};
	__property WordWrap = {default=1};
	__property VAlign = {default=0};
public:
	/* TfrxCustomMemoView.Destroy */ inline __fastcall virtual ~TfrxCellularText() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCellularText(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxCustomMemoView(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxcellulartextobject */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCELLULARTEXTOBJECT)
using namespace Frxcellulartextobject;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxcellulartextobjectHPP
