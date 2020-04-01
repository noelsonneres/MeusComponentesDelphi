// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBarcode2D.pas' rev: 33.00 (Windows)

#ifndef Frxbarcode2dHPP
#define Frxbarcode2dHPP

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
#include <System.Types.hpp>
#include <Vcl.Controls.hpp>
#include <System.Variants.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxClass.hpp>
#include <frxDesgn.hpp>
#include <frxBarcodePDF417.hpp>
#include <frxBarcodeDataMatrix.hpp>
#include <frxBarcodeQR.hpp>
#include <frxBarcodeAztec.hpp>
#include <frxBarcodeMaxiCode.hpp>
#include <frxBarcode2DBase.hpp>
#include <frxBarcodeProperties.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbarcode2d
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBarcode2DView;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxBarcode2DType : unsigned char { bcCodePDF417, bcCodeDataMatrix, bcCodeQR, bcCodeAztec, bcCodeMaxiCode };

class PASCALIMPLEMENTATION TfrxBarcode2DView : public Frxclass::TfrxStretcheable
{
	typedef Frxclass::TfrxStretcheable inherited;
	
private:
	Frxbarcode2dbase::TfrxBarcode2DBase* FBarCode;
	TfrxBarcode2DType FBarType;
	Frxclass::TfrxHAlign FHAlign;
	Frxbarcodeproperties::TfrxBarcode2DProperties* FProp;
	System::UnicodeString FExpression;
	bool FMacroLoaded;
	bool FAutoSize;
	void __fastcall SetZoom(System::Extended z);
	System::Extended __fastcall GetZoom();
	void __fastcall SetRotation(int v);
	int __fastcall GetRotation();
	void __fastcall SetShowText(bool v);
	bool __fastcall GetShowText();
	void __fastcall SetText(System::UnicodeString v);
	System::UnicodeString __fastcall GetText();
	void __fastcall SetFontScaled(bool v);
	bool __fastcall GetFontScaled();
	void __fastcall SetErrorText(System::UnicodeString v);
	System::UnicodeString __fastcall GetErrorText();
	void __fastcall SetQuietZone(int v);
	int __fastcall GetQuietZone();
	void __fastcall SetProp(Frxbarcodeproperties::TfrxBarcode2DProperties* v);
	void __fastcall SetBarType(TfrxBarcode2DType v);
	void __fastcall CalcSize();
	Frxclass::TfrxPoint __fastcall CalcAddSize();
	
protected:
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	
public:
	__fastcall virtual TfrxBarcode2DView(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxBarcode2DView(System::Classes::TComponent* AOwner, System::Word Flags);
	__fastcall virtual ~TfrxBarcode2DView();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall GetData();
	virtual Frxclass::TfrxRect __fastcall GetRealBounds();
	virtual void __fastcall GetScaleFactor(System::Extended &ScaleX, System::Extended &ScaleY);
	virtual System::Extended __fastcall CalcHeight();
	virtual System::Extended __fastcall DrawPart();
	virtual void __fastcall SaveContentToDictionary(Frxclass::TfrxReport* aReport, Frxclass::TfrxPostProcessor* PostProcessor);
	virtual bool __fastcall LoadContentFromDictionary(Frxclass::TfrxReport* aReport, Frxclass::TfrxMacrosItem* aItem);
	virtual void __fastcall ProcessDictionary(Frxclass::TfrxMacrosItem* aItem, Frxclass::TfrxReport* aReport, Frxclass::TfrxPostProcessor* PostProcessor);
	
__published:
	__property bool AutoSize = {read=FAutoSize, write=FAutoSize, default=1};
	__property System::UnicodeString Expression = {read=FExpression, write=FExpression};
	__property TfrxBarcode2DType BarType = {read=FBarType, write=SetBarType, nodefault};
	__property Frxbarcodeproperties::TfrxBarcode2DProperties* BarProperties = {read=FProp, write=SetProp};
	__property BrushStyle;
	__property Color;
	__property Cursor = {default=0};
	__property DataField = {default=0};
	__property DataSet;
	__property DataSetName = {default=0};
	__property Fill;
	__property Frame;
	__property Frxclass::TfrxHAlign HAlign = {read=FHAlign, write=FHAlign, default=0};
	__property Processing;
	__property int Rotation = {read=GetRotation, write=SetRotation, nodefault};
	__property bool ShowText = {read=GetShowText, write=SetShowText, nodefault};
	__property TagStr = {default=0};
	__property System::UnicodeString Text = {read=GetText, write=SetText};
	__property URL = {default=0};
	__property System::Extended Zoom = {read=GetZoom, write=SetZoom};
	__property Font;
	__property bool FontScaled = {read=GetFontScaled, write=SetFontScaled, nodefault};
	__property System::UnicodeString ErrorText = {read=GetErrorText, write=SetErrorText};
	__property int QuietZone = {read=GetQuietZone, write=SetQuietZone, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxbarcode2d */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBARCODE2D)
using namespace Frxbarcode2d;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frxbarcode2dHPP
