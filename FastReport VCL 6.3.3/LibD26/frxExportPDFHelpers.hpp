// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportPDFHelpers.pas' rev: 33.00 (Windows)

#ifndef FrxexportpdfhelpersHPP
#define FrxexportpdfhelpersHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Imaging.pngimage.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <frxRC4.hpp>
#include <frxTrueTypeCollection.hpp>
#include <frxTrueTypeFont.hpp>
#include <frxEMFAbstractExport.hpp>
#include <frxClass.hpp>
#include <frxEMFFormat.hpp>
#include <frxUtils.hpp>
#include <Vcl.Imaging.jpeg.hpp>
#include <System.AnsiStrings.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportpdfhelpers
{
//-- forward type declarations -----------------------------------------------
struct SCRIPT_ANALYSIS;
class DELPHICLASS TfrxPDFRun;
struct TRemapedString;
class DELPHICLASS TfrxPDFFont;
struct TfrxPDFXObject;
class DELPHICLASS TPDFObjectsHelper;
struct TViewSizes;
struct TRGBAWord;
//-- type declarations -------------------------------------------------------
typedef void * SCRIPT_CACHE;

typedef void * *PScriptCache;

struct DECLSPEC_DRECORD SCRIPT_ANALYSIS
{
public:
	System::Word fFlags;
	System::Word s;
};


typedef SCRIPT_ANALYSIS *PScriptAnalysis;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPDFRun : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	SCRIPT_ANALYSIS analysis;
	System::WideString text;
	__fastcall TfrxPDFRun(System::WideString t, SCRIPT_ANALYSIS a);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxPDFRun() { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TRemapedString
{
public:
	System::WideString Data;
	int Width;
	int SpacesCount;
	bool IsValidCharWidth;
	Frxutils::TIntegerArray CharWidth;
	bool IsHasLigatures;
};


class PASCALIMPLEMENTATION TfrxPDFFont : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Vcl::Graphics::TBitmap* tempBitmap;
	void * *FUSCache;
	Frxtruetypecollection::TrueTypeCollection* TrueTypeTables;
	System::Uitypes::TColor FColor;
	System::AnsiString FFontName;
	System::Extended FSize;
	bool FForceAnsi;
	int __fastcall GetGlyphs(HDC hdc, TfrxPDFRun* run, PWORD glyphs, System::PInteger widths, int maxGlyphs, bool rtl, bool IsIndexes = false);
	System::Classes::TList* __fastcall Itemize(System::WideString s, bool rtl, int maxItems);
	System::Classes::TList* __fastcall Layout(System::Classes::TList* runs, bool rtl);
	int __fastcall GetGlyphIndices(HDC hdc, System::WideString text, PWORD glyphs, System::PInteger widths, bool rtl, bool IsIndexes = false);
	
protected:
	int Index;
	Frxtruetypefont::TrueTypeFont* ttf;
	Vcl::Graphics::TFont* SourceFont;
	bool PackFont;
	double PDFdpi_divider;
	double FDpiFX;
	bool FIsLigatureless;
	void __fastcall FillOutlineTextMetrix();
	void __fastcall Cleanup();
	void __fastcall GetFontFile();
	TRemapedString __fastcall RemapString(System::WideString str, bool rtl, bool IsIndexes = false);
	
public:
	System::Classes::TList* Widths;
	System::Classes::TList* UsedAlphabet;
	System::Classes::TList* UsedAlphabetUnicode;
	_OUTLINETEXTMETRICA *TextMetric;
	System::AnsiString Name;
	int Reference;
	bool Saved;
	char *FontData;
	int FontDataSize;
	__fastcall TfrxPDFFont(Vcl::Graphics::TFont* Font);
	__fastcall virtual ~TfrxPDFFont();
	void __fastcall PackTTFFont();
	TRemapedString __fastcall SoftRemapString(System::WideString str, bool rtl, bool PdfA, bool IsIndexes = false);
	System::AnsiString __fastcall GetFontName();
	System::Extended __fastcall SpaceAdjustment(const TRemapedString &RS, System::Extended TextWidth, System::Extended FontSize);
	__property System::AnsiString FontName = {read=FFontName, write=FFontName};
	__property System::Extended Size = {read=FSize, write=FSize};
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, nodefault};
	__property bool ForceAnsi = {write=FForceAnsi, nodefault};
};


typedef System::StaticArray<System::Byte, 16> TfrxPDFXObjectHash;

struct DECLSPEC_DRECORD TfrxPDFXObject
{
public:
	int ObjId;
	TfrxPDFXObjectHash Hash;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TPDFObjectsHelper : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<TfrxPDFXObject> _TPDFObjectsHelper__1;
	
	typedef System::DynamicArray<int> _TPDFObjectsHelper__2;
	
	
private:
	System::Classes::TList* FFonts;
	System::Classes::TList* FPageFonts;
	System::Classes::TStringList* FXRef;
	System::Classes::TStream* FpdfStream;
	bool FProtection;
	System::AnsiString FEncKey;
	bool FEmbedded;
	int FQuality;
	_TPDFObjectsHelper__1 FXObjects;
	_TPDFObjectsHelper__2 FUsedXObjects;
	TfrxPDFFont* __fastcall GetFonts(int Index);
	int __fastcall GetFontsCount();
	TfrxPDFFont* __fastcall GetPageFonts(int Index);
	int __fastcall GetPageFontsCount();
	
public:
	__fastcall TPDFObjectsHelper();
	__fastcall virtual ~TPDFObjectsHelper();
	void __fastcall Clear();
	TfrxPDFFont* __fastcall GetGlobalFont(Vcl::Graphics::TFont* const Font);
	int __fastcall GetObjFontNumber(Vcl::Graphics::TFont* const Font);
	void __fastcall ClearUsedXObjects();
	void __fastcall OutUsedXObjects();
	int __fastcall FindXObject(const TfrxPDFXObjectHash &Hash);
	int __fastcall AddXObject(int Id, const TfrxPDFXObjectHash &Hash);
	void __fastcall ClearXObject();
	void __fastcall AddUsedObject(int Index);
	int __fastcall GetXObjectsId(int Index);
	int __fastcall OutXObjectImage(const TfrxPDFXObjectHash &XObjectHash, Vcl::Imaging::Jpeg::TJPEGImage* Jpg, System::Classes::TStream* XObjectStream, bool IsTransparent = false, int MaskId = 0x0);
	int __fastcall OutTransparentPNG(Vcl::Imaging::Pngimage::TPngImage* PNGA, const System::Types::TSize &Size);
	int __fastcall UpdateXRef();
	__property TfrxPDFFont* Fonts[int Index] = {read=GetFonts};
	__property int FontsCount = {read=GetFontsCount, nodefault};
	__property TfrxPDFFont* PageFonts[int Index] = {read=GetPageFonts};
	__property int PageFontsCount = {read=GetPageFontsCount, nodefault};
	__property System::Classes::TStream* pdfStream = {write=FpdfStream};
	__property System::Classes::TStringList* XRef = {read=FXRef};
	__property bool Protection = {write=FProtection, nodefault};
	__property System::AnsiString EncKey = {write=FEncKey};
	__property bool EmbeddedFonts = {read=FEmbedded, write=FEmbedded, default=0};
	__property int Quality = {write=FQuality, nodefault};
};

#pragma pack(pop)

typedef System::DynamicArray<System::Byte> TMaskArray;

typedef System::Set<Frxclass::TfrxShapeKind, Frxclass::TfrxShapeKind::skRectangle, Frxclass::TfrxShapeKind::skDiagonal2> TfrxShapeKindSet;

struct DECLSPEC_DRECORD TViewSizes
{
public:
	System::Extended l;
	System::Extended t;
	System::Extended w;
	System::Extended h;
	System::Extended r;
	System::Extended b;
};


#pragma pack(push,1)
struct DECLSPEC_DRECORD TRGBAWord
{
public:
	System::Byte Blue;
	System::Byte Green;
	System::Byte Red;
	System::Byte Alpha;
};
#pragma pack(pop)


typedef System::StaticArray<TRGBAWord, 4096> TRGBAWordArray;

typedef TRGBAWordArray *PRGBAWord;

enum DECLSPEC_DENUM TPDFStandard : unsigned char { psNone, psPDFA_1a, psPDFA_1b, psPDFA_2a, psPDFA_2b, psPDFA_3a, psPDFA_3b };

enum DECLSPEC_DENUM TPDFVersion : unsigned char { pv14, pv15, pv16, pv17 };

typedef System::StaticArray<System::UnicodeString, 7> Frxexportpdfhelpers__4;

typedef System::StaticArray<System::UnicodeString, 7> Frxexportpdfhelpers__5;

typedef System::StaticArray<System::UnicodeString, 7> Frxexportpdfhelpers__6;

typedef System::StaticArray<System::UnicodeString, 4> Frxexportpdfhelpers__7;

//-- var, const, procedure ---------------------------------------------------
#define PDF_DIVIDER  (7.500000E-01)
extern DELPHI_PACKAGE Frxexportpdfhelpers__4 PDFStandardName;
extern DELPHI_PACKAGE Frxexportpdfhelpers__5 PDFPartName;
extern DELPHI_PACKAGE Frxexportpdfhelpers__6 PDFConformanceName;
extern DELPHI_PACKAGE Frxexportpdfhelpers__7 PDFVersionName;
extern DELPHI_PACKAGE Vcl::Graphics::TBitmap* __fastcall CreateBitmap(Vcl::Graphics::TPixelFormat PixelFormat, int Width, int Height)/* overload */;
extern DELPHI_PACKAGE Vcl::Graphics::TBitmap* __fastcall CreateBitmap(Vcl::Graphics::TPixelFormat PixelFormat, Vcl::Graphics::TBitmap* SizeBitmap)/* overload */;
extern DELPHI_PACKAGE int __fastcall BitmapPixelSize(Vcl::Graphics::TBitmap* Bitmap);
extern DELPHI_PACKAGE void __fastcall SaveMask(System::Classes::TStream* pdf, System::Classes::TStream* XObjectStream, TMaskArray MaskBytes, TPDFObjectsHelper* FPOH, Vcl::Graphics::TBitmap* TempBitmap, bool FProtection, System::AnsiString FEncKey, /* out */ TfrxPDFXObjectHash &XObjectHash, /* out */ int &XMaskId, /* out */ int &PicIndex);
extern DELPHI_PACKAGE void __fastcall CreateMask(Vcl::Graphics::TBitmap* Bitmap, TMaskArray &Mask);
extern DELPHI_PACKAGE bool __fastcall IsVersionByStandard(TPDFStandard ps, TPDFVersion &pv);
extern DELPHI_PACKAGE bool __fastcall IsPDFA_1(TPDFStandard ps);
extern DELPHI_PACKAGE bool __fastcall IsPDFA(TPDFStandard ps);
extern DELPHI_PACKAGE TPDFVersion __fastcall PDFVersionByName(System::UnicodeString VersionName);
extern DELPHI_PACKAGE TPDFStandard __fastcall PDFStandardByName(System::UnicodeString StandardName);
extern DELPHI_PACKAGE TViewSizes __fastcall ShadowlessSizes(Frxclass::TfrxView* Obj);
extern DELPHI_PACKAGE bool __fastcall Is2DShape(Frxclass::TfrxView* Obj);
extern DELPHI_PACKAGE bool __fastcall IsShape(Frxclass::TfrxView* Obj, TfrxShapeKindSet ShapeKindSet);
extern DELPHI_PACKAGE void __fastcall Write(System::Classes::TStream* Stream, const System::AnsiString S)/* overload */;
extern DELPHI_PACKAGE void __fastcall WriteLn(System::Classes::TStream* Stream, const System::AnsiString S)/* overload */;
extern DELPHI_PACKAGE void __fastcall WriteLn(System::Classes::TStream* Stream, const System::UnicodeString S)/* overload */;
extern DELPHI_PACKAGE void __fastcall Write(System::Classes::TStream* Stream, const System::UnicodeString S)/* overload */;
extern DELPHI_PACKAGE void __fastcall GetStreamHash(/* out */ TfrxPDFXObjectHash &Hash, System::Classes::TStream* S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ObjNumber(int FNumber);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ObjNumberRef(int FNumber);
extern DELPHI_PACKAGE System::UnicodeString __fastcall PrepXRefPos(int Index);
extern DELPHI_PACKAGE System::AnsiString __fastcall CryptStream(System::Classes::TStream* Source, System::Classes::TStream* Target, System::AnsiString Key, int id);
extern DELPHI_PACKAGE void __fastcall AddLigatureless(System::UnicodeString FontName);
extern DELPHI_PACKAGE void __fastcall DeleteLigatureless(System::UnicodeString FontName);
extern DELPHI_PACKAGE void __fastcall AddStyleSimulation(System::UnicodeString FontName, System::Uitypes::TFontStyles FontStyles);
extern DELPHI_PACKAGE void __fastcall DeleteStyleSimulation(System::UnicodeString FontName);
extern DELPHI_PACKAGE bool __fastcall IsNeedsBoldSimulation(Vcl::Graphics::TFont* Font, /* out */ System::UnicodeString &Simulation);
extern DELPHI_PACKAGE bool __fastcall IsNeedsItalicSimulation(Vcl::Graphics::TFont* Font, /* out */ System::UnicodeString &Simulation);
extern DELPHI_PACKAGE System::UnicodeString __fastcall Color2Str(System::Uitypes::TColor Color);
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxRect2Str(const Frxclass::TfrxRect &DR);
extern DELPHI_PACKAGE Frxclass::TfrxPoint __fastcall frxPointSum(const Frxclass::TfrxPoint &P1, const Frxclass::TfrxPoint &P2);
extern DELPHI_PACKAGE Frxclass::TfrxPoint __fastcall frxPointMult(const Frxclass::TfrxPoint &P, System::Extended Factor);
extern DELPHI_PACKAGE System::AnsiString __fastcall StrToHex(const System::WideString Value);
extern DELPHI_PACKAGE System::AnsiString __fastcall StrToHexDx(const System::WideString RemappedStr, Frxutils::TLongWordArray OutputDx, System::Extended DxFactor, bool SkipFirstDx, Frxutils::TIntegerArray CharWidth);
extern DELPHI_PACKAGE System::AnsiString __fastcall StrToHexSp(const System::WideString SourceStr, const System::WideString Value, System::Extended SpaceAdjustment);
}	/* namespace Frxexportpdfhelpers */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTPDFHELPERS)
using namespace Frxexportpdfhelpers;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportpdfhelpersHPP
