// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBarcod.pas' rev: 33.00 (Windows)

#ifndef FrxbarcodHPP
#define FrxbarcodHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxBarcodOneCode.hpp>
#include <System.StrUtils.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbarcod
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBarcode;
struct TBCdata;
struct TfrxAICodesData;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxBarcodeType : unsigned char { bcCode_2_5_interleaved, bcCode_2_5_industrial, bcCode_2_5_matrix, bcCode39, bcCode39Extended, bcCode128, bcCode128A, bcCode128B, bcCode128C, bcCode93, bcCode93Extended, bcCodeMSI, bcCodePostNet, bcCodeCodabar, bcCodeEAN8, bcCodeEAN13, bcCodeUPC_A, bcCodeUPC_E0, bcCodeUPC_E1, bcCodeUPC_Supp2, bcCodeUPC_Supp5, bcCodeEAN128, bcCodeEAN128A, bcCodeEAN128B, bcCodeEAN128C, bcCodeUSPSIntelligentMail, bcGS1Code128 };

enum DECLSPEC_DENUM TfrxBarLineType : unsigned char { white, black, black_half, black_track, black_ascend, black_descend };

enum DECLSPEC_DENUM TfrxCheckSumMethod : unsigned char { csmNone, csmModulo10 };

class PASCALIMPLEMENTATION TfrxBarcode : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	double FAngle;
	System::Uitypes::TColor FColor;
	System::Uitypes::TColor FColorBar;
	bool FCheckSum;
	TfrxCheckSumMethod FCheckSumMethod;
	int FHeight;
	int FLeft;
	int FModul;
	double FRatio;
	System::AnsiString FText;
	int FTop;
	TfrxBarcodeType FTyp;
	Vcl::Graphics::TFont* FFont;
	System::StaticArray<System::Int8, 4> modules;
	void __fastcall DoLines(System::AnsiString data, Vcl::Graphics::TCanvas* Canvas);
	void __fastcall OneBarProps(char code, int &Width, TfrxBarLineType &lt);
	System::AnsiString __fastcall SetLen(System::Byte pI);
	System::AnsiString __fastcall Code_2_5_interleaved();
	System::AnsiString __fastcall Code_2_5_industrial();
	System::AnsiString __fastcall Code_2_5_matrix();
	System::AnsiString __fastcall Code_39();
	System::AnsiString __fastcall Code_39Extended();
	System::AnsiString __fastcall Code_128();
	System::AnsiString __fastcall Code_93();
	System::AnsiString __fastcall Code_93Extended();
	System::AnsiString __fastcall Code_MSI();
	System::AnsiString __fastcall Code_PostNet();
	System::AnsiString __fastcall Code_Codabar();
	System::AnsiString __fastcall Code_EAN8();
	System::AnsiString __fastcall Code_EAN13();
	System::AnsiString __fastcall Code_UPC_A();
	System::AnsiString __fastcall Code_UPC_E0();
	System::AnsiString __fastcall Code_UPC_E1();
	System::AnsiString __fastcall Code_Supp5();
	System::AnsiString __fastcall Code_Supp2();
	System::AnsiString __fastcall Code_USPSIntelligentMail();
	void __fastcall MakeModules();
	int __fastcall GetWidth();
	System::AnsiString __fastcall DoCheckSumming(const System::AnsiString data);
	System::AnsiString __fastcall MakeData();
	void __fastcall SetTyp(const TfrxBarcodeType Value);
	
public:
	__fastcall virtual TfrxBarcode(System::Classes::TComponent* Owner);
	__fastcall virtual ~TfrxBarcode();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall DrawBarcode(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &ARect, bool ShowText, System::Extended aScaleDPIX, System::Extended aScaleDPIY, bool DirectToEMF = false);
	
__published:
	__property System::AnsiString Text = {read=FText, write=FText};
	__property int Modul = {read=FModul, write=FModul, nodefault};
	__property double Ratio = {read=FRatio, write=FRatio};
	__property TfrxBarcodeType Typ = {read=FTyp, write=SetTyp, nodefault};
	__property bool Checksum = {read=FCheckSum, write=FCheckSum, nodefault};
	__property TfrxCheckSumMethod CheckSumMethod = {read=FCheckSumMethod, write=FCheckSumMethod, nodefault};
	__property double Angle = {read=FAngle, write=FAngle};
	__property int Width = {read=GetWidth, nodefault};
	__property int Height = {read=FHeight, write=FHeight, nodefault};
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, nodefault};
	__property System::Uitypes::TColor ColorBar = {read=FColorBar, write=FColorBar, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=FFont};
};


#pragma pack(push,1)
struct DECLSPEC_DRECORD TBCdata
{
public:
	System::AnsiString Name;
	bool num;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TfrxAICodesData
{
public:
	System::AnsiString AI;
	System::Byte AISize;
	System::Byte DataMinSize;
	System::Byte DataMaxSize;
	bool FNC1;
};
#pragma pack(pop)


typedef System::StaticArray<TBCdata, 27> Frxbarcod__2;

typedef System::StaticArray<TfrxAICodesData, 89> Frxbarcod__3;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Frxbarcod__2 BCdata;
static const System::Int8 AICodesCount = System::Int8(0x59);
extern DELPHI_PACKAGE Frxbarcod__3 AICodesData;
}	/* namespace Frxbarcod */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBARCOD)
using namespace Frxbarcod;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxbarcodHPP
