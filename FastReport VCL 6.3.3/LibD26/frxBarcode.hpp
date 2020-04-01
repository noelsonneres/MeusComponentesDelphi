// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBarcode.pas' rev: 33.00 (Windows)

#ifndef FrxbarcodeHPP
#define FrxbarcodeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <frxBarcod.hpp>
#include <frxClass.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbarcode
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBarCodeObject;
class DELPHICLASS TfrxBarCodeView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBarCodeObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxBarCodeObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxBarCodeObject() { }
	
};


class PASCALIMPLEMENTATION TfrxBarCodeView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	Frxbarcod::TfrxBarcode* FBarCode;
	Frxbarcod::TfrxBarcodeType FBarType;
	bool FCalcCheckSum;
	System::UnicodeString FExpression;
	Frxclass::TfrxHAlign FHAlign;
	int FRotation;
	bool FShowText;
	bool FTestLine;
	System::UnicodeString FText;
	System::Extended FWideBarRatio;
	System::Extended FZoom;
	bool FMacroLoaded;
	bool FAutoSize;
	int FExportExpance;
	void __fastcall BcFontChanged(System::TObject* Sender);
	
public:
	__fastcall virtual TfrxBarCodeView(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxBarCodeView(System::Classes::TComponent* AOwner, System::Word Flags);
	__fastcall virtual ~TfrxBarCodeView();
	virtual Vcl::Graphics::TGraphic* __fastcall GetVectorGraphic(bool DrawFill = false);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall GetData();
	void __fastcall SetText(System::UnicodeString Value);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual Frxclass::TfrxRect __fastcall GetRealBounds();
	virtual void __fastcall SaveContentToDictionary(Frxclass::TfrxReport* aReport, Frxclass::TfrxPostProcessor* PostProcessor);
	virtual bool __fastcall LoadContentFromDictionary(Frxclass::TfrxReport* aReport, Frxclass::TfrxMacrosItem* aItem);
	virtual void __fastcall ProcessDictionary(Frxclass::TfrxMacrosItem* aItem, Frxclass::TfrxReport* aReport, Frxclass::TfrxPostProcessor* PostProcessor);
	__property Frxbarcod::TfrxBarcode* BarCode = {read=FBarCode};
	virtual Frxclass::TfrxRect __fastcall GetExportBounds();
	
__published:
	__property bool AutoSize = {read=FAutoSize, write=FAutoSize, default=1};
	__property Frxbarcod::TfrxBarcodeType BarType = {read=FBarType, write=FBarType, nodefault};
	__property BrushStyle;
	__property bool CalcCheckSum = {read=FCalcCheckSum, write=FCalcCheckSum, default=0};
	__property FillType = {default=0};
	__property Fill;
	__property Color;
	__property Cursor = {default=0};
	__property DataField = {default=0};
	__property DataSet;
	__property DataSetName = {default=0};
	__property System::UnicodeString Expression = {read=FExpression, write=FExpression};
	__property Frame;
	__property Frxclass::TfrxHAlign HAlign = {read=FHAlign, write=FHAlign, default=0};
	__property Processing;
	__property int Rotation = {read=FRotation, write=FRotation, nodefault};
	__property bool ShowText = {read=FShowText, write=FShowText, default=1};
	__property TagStr = {default=0};
	__property bool TestLine = {read=FTestLine, write=FTestLine, nodefault};
	__property System::UnicodeString Text = {read=FText, write=SetText};
	__property URL = {default=0};
	__property System::Extended WideBarRatio = {read=FWideBarRatio, write=FWideBarRatio};
	__property System::Extended Zoom = {read=FZoom, write=FZoom};
	__property Font;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxbarcode */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBARCODE)
using namespace Frxbarcode;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxbarcodeHPP
