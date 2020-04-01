// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxOS2WindowsMetricsClass.pas' rev: 33.00 (Windows)

#ifndef Frxos2windowsmetricsclassHPP
#define Frxos2windowsmetricsclassHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <TTFHelpers.hpp>
#include <frxTrueTypeTable.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxos2windowsmetricsclass
{
//-- forward type declarations -----------------------------------------------
struct OS2WindowsMetrics;
class DELPHICLASS OS2WindowsMetricsClass;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::Byte, 4> TVendorID;

typedef System::StaticArray<System::Byte, 10> TPanose;

#pragma pack(push,1)
struct DECLSPEC_DRECORD OS2WindowsMetrics
{
public:
	System::Word Version;
	short xAvgCharWidth;
	System::Word usWeightClass;
	System::Word usWidthClass;
	System::Word fsType;
	short ySubscriptXSize;
	short ySubscriptYSize;
	short ySubscriptXOffset;
	short ySubscriptYOffset;
	short ySuperscriptXSize;
	short ySuperscriptYSize;
	short ySuperscriptXOffset;
	short ySuperscriptYOffset;
	short yStrikeoutSize;
	short yStrikeoutPosition;
	short sFamilyClass;
	TPanose panose;
	unsigned ulUnicodeRange1;
	unsigned ulUnicodeRange2;
	unsigned ulUnicodeRange3;
	unsigned ulUnicodeRange4;
	TVendorID achVendID;
	System::Word fsSelection;
	System::Word usFirstCharIndex;
	System::Word usLastCharIndex;
	short sTypoAscender;
	short sTypoDescender;
	short sTypoLineGap;
	System::Word usWinAscent;
	System::Word usWinDescent;
	unsigned ulCodePageRange1;
	unsigned ulCodePageRange2;
	short sxHeight;
	short sCapHeight;
	System::Word usDefaultChar;
	System::Word usBreakChar;
	System::Word usMaxContext;
};
#pragma pack(pop)


typedef OS2WindowsMetrics *POS2WindowsMetrics;

#pragma pack(push,4)
class PASCALIMPLEMENTATION OS2WindowsMetricsClass : public Frxtruetypetable::TrueTypeTable
{
	typedef Frxtruetypetable::TrueTypeTable inherited;
	
private:
	OS2WindowsMetrics *win_metrix;
	
public:
	__fastcall OS2WindowsMetricsClass(Frxtruetypetable::TrueTypeTable* src);
	__fastcall virtual ~OS2WindowsMetricsClass();
	virtual void __fastcall Load(void * font);
	virtual unsigned __fastcall Save(void * font, unsigned offset);
	
private:
	short __fastcall Get_AvgCharWidth();
	System::Word __fastcall Get_Ascent();
	System::Word __fastcall Get_BreakChar();
	System::Word __fastcall Get_DefaultChar();
	System::Word __fastcall Get_Descent();
	System::Word __fastcall Get_FirstCharIndex();
	System::Word __fastcall Get_LastCharIndex();
	
public:
	__property short AvgCharWidth = {read=Get_AvgCharWidth, nodefault};
	__property System::Word Ascent = {read=Get_Ascent, nodefault};
	__property System::Word BreakChar = {read=Get_BreakChar, nodefault};
	__property System::Word DefaultChar = {read=Get_DefaultChar, nodefault};
	__property System::Word Descent = {read=Get_Descent, nodefault};
	__property System::Word FirstCharIndex = {read=Get_FirstCharIndex, nodefault};
	__property System::Word LastCharIndex = {read=Get_LastCharIndex, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxos2windowsmetricsclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXOS2WINDOWSMETRICSCLASS)
using namespace Frxos2windowsmetricsclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frxos2windowsmetricsclassHPP
