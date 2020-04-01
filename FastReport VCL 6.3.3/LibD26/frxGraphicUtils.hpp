// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGraphicUtils.pas' rev: 33.00 (Windows)

#ifndef FrxgraphicutilsHPP
#define FrxgraphicutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxClass.hpp>
#include <System.Variants.hpp>
#include <frxVectorCanvas.hpp>
#include <frxUnicodeUtils.hpp>
#include <System.WideStrings.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------
#undef NewLine

namespace Frxgraphicutils
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxHTMLTag;
class DELPHICLASS TfrxHTMLTags;
class DELPHICLASS TfrxHTMLTagsList;
class DELPHICLASS TfrxDrawText;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<int, 536870911> TIntArray;

typedef TIntArray *PIntArray;

enum DECLSPEC_DENUM TSubStyle : unsigned char { ssNormal, ssSubscript, ssSuperscript };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHTMLTag : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	int Position;
	int Size;
	int AddY;
	System::Uitypes::TFontStyles Style;
	int Color;
	bool Default;
	bool Small;
	bool DontWRAP;
	TSubStyle SubType;
	void __fastcall Assign(TfrxHTMLTag* Tag);
public:
	/* TObject.Create */ inline __fastcall TfrxHTMLTag() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxHTMLTag() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHTMLTags : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxHTMLTag* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Classes::TList* FItems;
	void __fastcall Add(TfrxHTMLTag* Tag);
	TfrxHTMLTag* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxHTMLTags();
	__fastcall virtual ~TfrxHTMLTags();
	void __fastcall Clear();
	int __fastcall Count();
	__property TfrxHTMLTag* Items[int Index] = {read=GetItems/*, default*/};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHTMLTagsList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxHTMLTags* operator[](int Index) { return this->Items[Index]; }
	
private:
	bool FAllowTags;
	int FAddY;
	int FColor;
	int FDefColor;
	int FDefSize;
	System::Uitypes::TFontStyles FDefStyle;
	System::Classes::TList* FItems;
	int FPosition;
	int FSize;
	System::Uitypes::TFontStyles FStyle;
	bool FDontWRAP;
	TIntArray *FTempArray;
	int FTempArraySize;
	TSubStyle FSubStyle;
	void __fastcall NewLine();
	void __fastcall Wrap(int TagsCount, bool AddBreak);
	TfrxHTMLTag* __fastcall Add();
	int __fastcall FillCharSpacingArray(PIntArray &ar, const System::WideString s, Vcl::Graphics::TCanvas* Canvas, int LineIndex, int Add, bool Convert, bool DefCharset);
	TfrxHTMLTags* __fastcall GetItems(int Index);
	TfrxHTMLTag* __fastcall GetPrevTag();
	void __fastcall ReallocTempArray(int ANewSize);
	void __fastcall FreeTempArray();
	
public:
	__fastcall TfrxHTMLTagsList();
	__fastcall virtual ~TfrxHTMLTagsList();
	void __fastcall Clear();
	void __fastcall SetDefaults(System::Uitypes::TColor DefColor, int DefSize, System::Uitypes::TFontStyles DefStyle);
	void __fastcall ExpandHTMLTags(System::WideString &s);
	int __fastcall Count();
	__property bool AllowTags = {read=FAllowTags, write=FAllowTags, nodefault};
	__property TfrxHTMLTags* Items[int Index] = {read=GetItems/*, default*/};
	__property int Position = {read=FPosition, write=FPosition, nodefault};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxDrawText : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Vcl::Graphics::TBitmap* FBMP;
	Vcl::Graphics::TCanvas* FCanvas;
	int FDefPPI;
	int FScrPPI;
	TIntArray *FTempArray;
	int FTempArraySize;
	int FFontSize;
	TfrxHTMLTagsList* FHTMLTags;
	System::Extended FCharSpacing;
	System::Extended FLineSpacing;
	int FOptions;
	System::Types::TRect FOriginalRect;
	System::Extended FParagraphGap;
	System::WideString FPlainText;
	System::Extended FPrintScale;
	int FRotation;
	bool FRTLReading;
	System::Types::TRect FScaledRect;
	System::Extended FScaleX;
	System::Extended FScaleY;
	System::Widestrings::TWideStrings* FText;
	bool FWordBreak;
	bool FWordWrap;
	bool FWysiwyg;
	bool FMonoFont;
	bool FUseDefaultCharset;
	Frxvectorcanvas::TVectorCanvas* FVC;
	bool FUseOldLineHeight;
	System::WideString __fastcall GetWrappedText();
	bool __fastcall IsPrinter(Vcl::Graphics::TCanvas* C);
	void __fastcall DrawTextLine(Vcl::Graphics::TCanvas* C, const System::WideString s, int X, int Y, int DX, int LineIndex, Frxclass::TfrxHAlign Align, HFONT &fh, HFONT &oldfh);
	void __fastcall WrapTextLine(System::WideString s, int Width, int FirstLineWidth, int CharSpacing);
	int __fastcall GetFontHeightMetric(Vcl::Graphics::TCanvas* aCanvas);
	void __fastcall ReallocTempArray(int ANewSize);
	void __fastcall FreeTempArray();
	
public:
	__fastcall TfrxDrawText();
	__fastcall virtual ~TfrxDrawText();
	void __fastcall SetFont(Vcl::Graphics::TFont* Font);
	void __fastcall SetOptions(bool WordWrap, bool HTMLTags, bool RTLReading, bool WordBreak, bool Clipped, bool Wysiwyg, int Rotation);
	void __fastcall SetGaps(System::Extended ParagraphGap, System::Extended CharSpacing, System::Extended LineSpacing);
	void __fastcall SetDimensions(System::Extended ScaleX, System::Extended ScaleY, System::Extended PrintScale, const System::Types::TRect &OriginalRect, const System::Types::TRect &ScaledRect);
	void __fastcall SetText(System::Widestrings::TWideStrings* Text, bool FirstParaBreak = false);
	void __fastcall SetParaBreaks(bool FirstParaBreak, bool LastParaBreak);
	System::WideString __fastcall DeleteTags(const System::WideString Txt);
	void __fastcall DrawText(Vcl::Graphics::TCanvas* C, Frxclass::TfrxHAlign HAlign, Frxclass::TfrxVAlign VAlign, Frxclass::TfrxUnderlinesTextMode UnderlinesTextMode = (Frxclass::TfrxUnderlinesTextMode)(0x0));
	System::Extended __fastcall CalcHeight();
	System::Extended __fastcall CalcWidth();
	System::Extended __fastcall LineHeight();
	System::Extended __fastcall TextHeight();
	int __fastcall GetFontHeight(Vcl::Graphics::TCanvas* aCanvas);
	System::WideString __fastcall GetInBoundsText();
	System::WideString __fastcall GetOutBoundsText(bool &ParaBreak);
	System::Extended __fastcall UnusedSpace();
	void __fastcall Lock();
	void __fastcall Unlock();
	void __fastcall LockCanvas();
	void __fastcall UnlockCanvas();
	__property Vcl::Graphics::TCanvas* Canvas = {read=FCanvas};
	__property int DefPPI = {read=FDefPPI, nodefault};
	__property int ScrPPI = {read=FScrPPI, nodefault};
	__property System::WideString WrappedText = {read=GetWrappedText};
	__property bool UseDefaultCharset = {read=FUseDefaultCharset, write=FUseDefaultCharset, nodefault};
	__property bool UseMonoFont = {read=FMonoFont, write=FMonoFont, nodefault};
	__property System::Widestrings::TWideStrings* Text = {read=FText};
	__property Frxvectorcanvas::TVectorCanvas* VC = {read=FVC, write=FVC};
	__property bool UseOldLineHeight = {read=FUseOldLineHeight, write=FUseOldLineHeight, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxDrawText* frxDrawText;
extern DELPHI_PACKAGE HFONT __fastcall frxCreateRotatedFont(Vcl::Graphics::TFont* Font, int Rotation);
}	/* namespace Frxgraphicutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGRAPHICUTILS)
using namespace Frxgraphicutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgraphicutilsHPP
