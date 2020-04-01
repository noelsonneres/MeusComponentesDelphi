// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportHelpers.pas' rev: 33.00 (Windows)

#ifndef FrxexporthelpersHPP
#define FrxexporthelpersHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <frxClass.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.UITypes.hpp>
#include <frxCrypto.hpp>
#include <frxStorage.hpp>
#include <frxVectorCanvas.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexporthelpers
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCSSStyle;
class DELPHICLASS TfrxCSS;
struct TfrxPictureInfo;
class DELPHICLASS TfrxPictureStorage;
class DELPHICLASS TfrxPicture;
class DELPHICLASS TTextFragment;
class DELPHICLASS TAnsiMemoryStream;
class DELPHICLASS TExportHTMLDivSVGParent;
class DELPHICLASS TRotation2D;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCSSStyle : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString operator[](System::UnicodeString Index) { return this->Style[Index]; }
	
private:
	System::Classes::TStrings* FKeys;
	System::Classes::TStrings* FValues;
	System::UnicodeString FName;
	void __fastcall SetStyle(System::UnicodeString Index, const System::UnicodeString Value);
	void __fastcall SetPrefixStyle(System::UnicodeString Index, const System::UnicodeString Value);
	System::UnicodeString __fastcall GetStyle(System::UnicodeString Index);
	
public:
	__fastcall TfrxCSSStyle();
	__fastcall virtual ~TfrxCSSStyle();
	TfrxCSSStyle* __fastcall This();
	int __fastcall Count();
	System::UnicodeString __fastcall Text(bool Formatted = false);
	void __fastcall AssignTo(TfrxCSSStyle* Dest);
	__property System::UnicodeString Style[System::UnicodeString Index] = {read=GetStyle, write=SetStyle/*, default*/};
	__property System::UnicodeString PrefixStyle[System::UnicodeString Index] = {write=SetPrefixStyle};
	__property System::UnicodeString Name = {read=FName, write=FName};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCSS : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Frxstorage::TObjList* FStyles;
	System::Classes::TList* FStyleHashes;
	
protected:
	TfrxCSSStyle* __fastcall GetStyle(int i);
	int __fastcall GetHash(const System::UnicodeString s);
	System::UnicodeString __fastcall GetStyleName(int i);
	int __fastcall GetStylesCount();
	
public:
	__fastcall TfrxCSS();
	__fastcall virtual ~TfrxCSS();
	System::UnicodeString __fastcall Add(TfrxCSSStyle* Style)/* overload */;
	TfrxCSSStyle* __fastcall Add(const System::UnicodeString StyleName)/* overload */;
	void __fastcall Save(System::Classes::TStream* Stream, bool Formatted);
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TfrxPictureInfo
{
public:
	System::UnicodeString Extension;
	System::UnicodeString Mimetype;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPictureStorage : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString FWorkDir;
	System::UnicodeString FPrefix;
	System::Classes::TList* FHashes;
	
protected:
	int __fastcall GetHash(System::Classes::TMemoryStream* Stream);
	
public:
	__fastcall TfrxPictureStorage(const System::UnicodeString WorkDir, System::UnicodeString Prefix);
	__fastcall virtual ~TfrxPictureStorage();
	System::UnicodeString __fastcall Save(Vcl::Graphics::TGraphic* Pic, Frxclass::TfrxCustomIOTransport* Filter);
	__classmethod TfrxPictureInfo __fastcall GetInfo(Vcl::Graphics::TGraphic* Pic);
};

#pragma pack(pop)

enum DECLSPEC_DENUM TfrxPictureFormat : unsigned char { pfPNG, pfEMF, pfBMP, pfJPG };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPicture : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfrxPictureFormat FFormat;
	Vcl::Graphics::TGraphic* FGraphic;
	Vcl::Graphics::TCanvas* FCanvas;
	Vcl::Graphics::TBitmap* FBitmap;
	
public:
	__fastcall TfrxPicture(TfrxPictureFormat Format, int Width, int Height);
	__fastcall virtual ~TfrxPicture();
	Vcl::Graphics::TGraphic* __fastcall Release();
	void __fastcall SetTransparentColor(System::Uitypes::TColor TransparentColor);
	void __fastcall FillColor(System::Uitypes::TColor Color);
	__property Vcl::Graphics::TCanvas* Canvas = {read=FCanvas};
};

#pragma pack(pop)

typedef bool __fastcall (__closure *TfrxExportHandler)(Frxclass::TfrxView* Obj);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TTextFragment : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool FFormatted;
	System::UnicodeString FText;
	
public:
	__fastcall TTextFragment(bool AFormatted);
	void __fastcall Add(const System::UnicodeString s)/* overload */;
	void __fastcall Add(const System::UnicodeString Fmt, const System::TVarRec *Args, const int Args_High)/* overload */;
	__property System::UnicodeString Text = {read=FText};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TTextFragment() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TAnsiMemoryStream : public System::Classes::TMemoryStream
{
	typedef System::Classes::TMemoryStream inherited;
	
private:
	void __fastcall PutsRaw(const System::AnsiString s);
	void __fastcall PutsA(const System::AnsiString s);
	
protected:
	bool FFormatted;
	
public:
	__fastcall TAnsiMemoryStream(bool AFormatted);
	void __fastcall Puts(const System::UnicodeString s)/* overload */;
	void __fastcall Puts(const System::UnicodeString Fmt, const System::TVarRec *Args, const int Args_High)/* overload */;
	System::AnsiString __fastcall AsAnsiString();
public:
	/* TMemoryStream.Destroy */ inline __fastcall virtual ~TAnsiMemoryStream() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TExportHTMLDivSVGParent : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
	
private:
	typedef System::DynamicArray<TfrxExportHandler> _TExportHTMLDivSVGParent__1;
	
	
private:
	bool FMultiPage;
	bool FFormatted;
	TfrxPictureFormat FPicFormat;
	bool FUnifiedPictures;
	bool FNavigation;
	bool FEmbeddedPictures;
	bool FEmbeddedCSS;
	System::Classes::TStream* FFilterStream;
	void __fastcall SetPicFormat(TfrxPictureFormat Fmt);
	
protected:
	int FCurrentPage;
	TfrxCSS* FCSS;
	TfrxPictureStorage* FPictures;
	_TExportHTMLDivSVGParent__1 FHandlers;
	System::Classes::TStream* FCurrentFile;
	void __fastcall AttachHandler(TfrxExportHandler Handler);
	virtual void __fastcall RunExportsChain(Frxclass::TfrxView* Obj);
	System::UnicodeString __fastcall GetCSSFileName();
	System::UnicodeString __fastcall GetCSSFilePath();
	void __fastcall SaveCSS(const System::UnicodeString FileName);
	virtual void __fastcall CreateCSS() = 0 ;
	bool __fastcall IsCanSavePicture(Vcl::Graphics::TGraphic* Pic);
	void __fastcall SavePicture(Vcl::Graphics::TGraphic* Pic);
	void __fastcall FreeStream();
	void __fastcall PutsRaw(const System::AnsiString s);
	void __fastcall PutsA(const System::AnsiString s);
	void __fastcall Puts(const System::UnicodeString s)/* overload */;
	void __fastcall Puts(const System::UnicodeString Fmt, const System::TVarRec *Args, const int Args_High)/* overload */;
	System::UnicodeString __fastcall LockStyle(TfrxCSSStyle* Style);
	System::AnsiString __fastcall ExportViaVector(Frxclass::TfrxView* Obj);
	void __fastcall Vector_ExtTextOut(Frxclass::TfrxView* Obj, TAnsiMemoryStream* AMS, Frxvectorcanvas::TVector_ExtTextOut* Vector, const System::Types::TPoint &Shift);
	
public:
	__fastcall virtual TExportHTMLDivSVGParent(System::Classes::TComponent* AOwner);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	virtual bool __fastcall Start();
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	
__published:
	__property OverwritePrompt;
	__property OpenAfterExport;
	__property bool MultiPage = {read=FMultiPage, write=FMultiPage, nodefault};
	__property bool Formatted = {read=FFormatted, write=FFormatted, nodefault};
	__property TfrxPictureFormat PictureFormat = {read=FPicFormat, write=SetPicFormat, nodefault};
	__property bool UnifiedPictures = {read=FUnifiedPictures, write=FUnifiedPictures, nodefault};
	__property bool Navigation = {read=FNavigation, write=FNavigation, nodefault};
	__property bool EmbeddedPictures = {read=FEmbeddedPictures, write=FEmbeddedPictures, nodefault};
	__property bool EmbeddedCSS = {read=FEmbeddedCSS, write=FEmbeddedCSS, nodefault};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TExportHTMLDivSVGParent() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TExportHTMLDivSVGParent() { }
	
};


class PASCALIMPLEMENTATION TRotation2D : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Frxclass::TfrxPoint FCenter;
	System::UnicodeString FMatrix;
	
protected:
	System::Extended Sinus;
	System::Extended Cosinus;
	System::Extended C1;
	System::Extended C2;
	
public:
	void __fastcall Init(System::Extended Radian, const Frxclass::TfrxPoint &Center);
	System::UnicodeString __fastcall Turn2Str(const Frxclass::TfrxPoint &DP);
	Frxclass::TfrxPoint __fastcall Turn(const Frxclass::TfrxPoint &DP);
	__property System::UnicodeString Matrix = {read=FMatrix};
public:
	/* TObject.Create */ inline __fastcall TRotation2D() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TRotation2D() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 spStroke = System::Int8(0x1);
static const System::Int8 spHTML = System::Int8(0x2);
extern DELPHI_PACKAGE bool __fastcall IsContain(const int Options, const int Param);
extern DELPHI_PACKAGE System::Extended __fastcall PiecewiseLinearInterpolation(int Rotation, int *X, const int X_High, int *Y, const int Y_High);
extern DELPHI_PACKAGE void __fastcall BitmapFill(Vcl::Graphics::TBitmap* Bitmap, System::Uitypes::TColor Color);
extern DELPHI_PACKAGE bool __fastcall IsTransparentPNG(Frxclass::TfrxView* Obj);
extern DELPHI_PACKAGE System::AnsiString __fastcall GraphicToBase64AnsiString(Vcl::Graphics::TGraphic* Graphic);
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxPoint2Str(const Frxclass::TfrxPoint &DP)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxPoint2Str(System::Extended X, System::Extended Y)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall Float2Str(const System::Extended Value, const int Prec = 0x3);
extern DELPHI_PACKAGE System::WideString __fastcall SVGStartSpace(const System::WideString s);
extern DELPHI_PACKAGE System::WideString __fastcall SVGEscapeTextAndAttribute(const System::WideString s);
extern DELPHI_PACKAGE System::UnicodeString __fastcall SVGUniqueID(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall SVGDasharray(Frxclass::TfrxFrameStyle Style, System::Extended LineWidth);
extern DELPHI_PACKAGE System::UnicodeString __fastcall SVGLine(bool Formatted, bool ZeroBased, TfrxCSS* CSS, Frxclass::TfrxLineView* Line);
extern DELPHI_PACKAGE void __fastcall CalcGlassRect(Frxclass::TfrxGlassFillOrientation Orientation, System::Extended AbsTop, System::Extended AbsLeft, int &x, int &y, int &Width, int &Height);
extern DELPHI_PACKAGE System::UnicodeString __fastcall SVGShapePath(Frxclass::TfrxShapeView* Shape, int Options = 0x0);
extern DELPHI_PACKAGE System::UnicodeString __fastcall SVGPattern(bool Formatted, bool XLine, bool YLine, bool Turn, System::Uitypes::TColor Color, System::Extended LineWidth, System::UnicodeString Name);
extern DELPHI_PACKAGE System::WideString __fastcall StrFindAndReplace(const System::WideString Source, const System::WideString Dlm, System::WideString *SFR, const int SFR_High);
extern DELPHI_PACKAGE bool __fastcall HasSpecialChars(const System::UnicodeString s);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetBorderRadius(int Curve);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetColor(System::Uitypes::TColor Color);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetCursor(System::Uitypes::TCursor Cursor);
}	/* namespace Frxexporthelpers */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTHELPERS)
using namespace Frxexporthelpers;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexporthelpersHPP
