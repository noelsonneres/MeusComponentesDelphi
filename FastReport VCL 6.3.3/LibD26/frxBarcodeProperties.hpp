// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBarcodeProperties.pas' rev: 33.00 (Windows)

#ifndef FrxbarcodepropertiesHPP
#define FrxbarcodepropertiesHPP

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
#include <frxDelphiZXingQRCode.hpp>
#include <frxBarcode2DBase.hpp>
#include <frxBarcodeAztec.hpp>
#include <frxBarcodeMaxiCode.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbarcodeproperties
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBarcode2DProperties;
class DELPHICLASS TfrxPDF417Properties;
class DELPHICLASS TfrxDataMatrixProperties;
class DELPHICLASS TfrxQRProperties;
class DELPHICLASS TfrxAztecProperties;
class DELPHICLASS TfrxMaxiCodeProperties;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBarcode2DProperties : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Classes::TNotifyEvent FOnChange;
	
public:
	System::TObject* FWhose;
	void __fastcall Changed();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source) = 0 ;
	void __fastcall SetWhose(System::TObject* w);
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxBarcode2DProperties() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxBarcode2DProperties() : System::Classes::TPersistent() { }
	
};


class PASCALIMPLEMENTATION TfrxPDF417Properties : public TfrxBarcode2DProperties
{
	typedef TfrxBarcode2DProperties inherited;
	
private:
	System::Extended __fastcall GetAspectRatio();
	int __fastcall GetColumns();
	int __fastcall GetRows();
	Frxbarcodepdf417::PDF417ErrorCorrection __fastcall GetErrorCorrection();
	int __fastcall GetCodePage();
	Frxbarcodepdf417::PDF417CompactionMode __fastcall GetCompactionMode();
	int __fastcall GetPixelWidth();
	int __fastcall GetPixelHeight();
	void __fastcall SetAspectRatio(System::Extended v);
	void __fastcall SetColumns(int v);
	void __fastcall SetRows(int v);
	void __fastcall SetErrorCorrection(Frxbarcodepdf417::PDF417ErrorCorrection v);
	void __fastcall SetCodePage(int v);
	void __fastcall SetCompactionMode(Frxbarcodepdf417::PDF417CompactionMode v);
	void __fastcall SetPixelWidth(int v);
	void __fastcall SetPixelHeight(int v);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::Extended AspectRatio = {read=GetAspectRatio, write=SetAspectRatio};
	__property int Columns = {read=GetColumns, write=SetColumns, nodefault};
	__property int Rows = {read=GetRows, write=SetRows, nodefault};
	__property Frxbarcodepdf417::PDF417ErrorCorrection ErrorCorrection = {read=GetErrorCorrection, write=SetErrorCorrection, nodefault};
	__property int CodePage = {read=GetCodePage, write=SetCodePage, nodefault};
	__property Frxbarcodepdf417::PDF417CompactionMode CompactionMode = {read=GetCompactionMode, write=SetCompactionMode, nodefault};
	__property int PixelWidth = {read=GetPixelWidth, write=SetPixelWidth, nodefault};
	__property int PixelHeight = {read=GetPixelHeight, write=SetPixelHeight, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxPDF417Properties() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxPDF417Properties() : TfrxBarcode2DProperties() { }
	
};


class PASCALIMPLEMENTATION TfrxDataMatrixProperties : public TfrxBarcode2DProperties
{
	typedef TfrxBarcode2DProperties inherited;
	
private:
	int __fastcall GetCodePage();
	int __fastcall GetPixelSize();
	Frxbarcodedatamatrix::DatamatrixSymbolSize __fastcall GetSymbolSize();
	Frxbarcodedatamatrix::DatamatrixEncoding __fastcall GetEncoding();
	void __fastcall SetCodePage(int v);
	void __fastcall SetPixelSize(int v);
	void __fastcall SetSymbolSize(Frxbarcodedatamatrix::DatamatrixSymbolSize v);
	void __fastcall SetEncoding(Frxbarcodedatamatrix::DatamatrixEncoding v);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property int CodePage = {read=GetCodePage, write=SetCodePage, nodefault};
	__property int PixelSize = {read=GetPixelSize, write=SetPixelSize, nodefault};
	__property Frxbarcodedatamatrix::DatamatrixSymbolSize SymbolSize = {read=GetSymbolSize, write=SetSymbolSize, nodefault};
	__property Frxbarcodedatamatrix::DatamatrixEncoding Encoding = {read=GetEncoding, write=SetEncoding, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxDataMatrixProperties() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxDataMatrixProperties() : TfrxBarcode2DProperties() { }
	
};


class PASCALIMPLEMENTATION TfrxQRProperties : public TfrxBarcode2DProperties
{
	typedef TfrxBarcode2DProperties inherited;
	
private:
	Frxdelphizxingqrcode::TQRCodeEncoding __fastcall GetEncoding();
	int __fastcall GetQuietZone();
	int __fastcall GetPixelSize();
	void __fastcall SetPixelSize(int v);
	void __fastcall SetEncoding(const Frxdelphizxingqrcode::TQRCodeEncoding Value);
	void __fastcall SetQuietZone(const int Value);
	Frxdelphizxingqrcode::TQRErrorLevels __fastcall GetErrorLevels();
	void __fastcall SetErrorLevels(const Frxdelphizxingqrcode::TQRErrorLevels Value);
	int __fastcall GetCodePage();
	void __fastcall SetCodePage(const int Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property Frxdelphizxingqrcode::TQRCodeEncoding Encoding = {read=GetEncoding, write=SetEncoding, nodefault};
	__property int QuietZone = {read=GetQuietZone, write=SetQuietZone, nodefault};
	__property Frxdelphizxingqrcode::TQRErrorLevels ErrorLevels = {read=GetErrorLevels, write=SetErrorLevels, nodefault};
	__property int PixelSize = {read=GetPixelSize, write=SetPixelSize, nodefault};
	__property int CodePage = {read=GetCodePage, write=SetCodePage, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxQRProperties() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxQRProperties() : TfrxBarcode2DProperties() { }
	
};


class PASCALIMPLEMENTATION TfrxAztecProperties : public TfrxBarcode2DProperties
{
	typedef TfrxBarcode2DProperties inherited;
	
private:
	int __fastcall GetMinECCPercent();
	void __fastcall SetMinECCPercent(const int Value);
	int __fastcall GetPixelSize();
	void __fastcall SetPixelSize(const int Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property int MinECCPercent = {read=GetMinECCPercent, write=SetMinECCPercent, nodefault};
	__property int PixelSize = {read=GetPixelSize, write=SetPixelSize, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxAztecProperties() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxAztecProperties() : TfrxBarcode2DProperties() { }
	
};


class PASCALIMPLEMENTATION TfrxMaxiCodeProperties : public TfrxBarcode2DProperties
{
	typedef TfrxBarcode2DProperties inherited;
	
private:
	int __fastcall GetMode();
	void __fastcall SetMode(const int Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property int Mode = {read=GetMode, write=SetMode, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxMaxiCodeProperties() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxMaxiCodeProperties() : TfrxBarcode2DProperties() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxbarcodeproperties */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBARCODEPROPERTIES)
using namespace Frxbarcodeproperties;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxbarcodepropertiesHPP
