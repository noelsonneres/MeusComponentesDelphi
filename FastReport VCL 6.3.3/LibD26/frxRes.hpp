// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxRes.pas' rev: 33.00 (Windows)

#ifndef FrxresHPP
#define FrxresHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <System.TypInfo.hpp>
#include <Vcl.Buttons.hpp>
#include <frxUnicodeUtils.hpp>
#include <Vcl.ImgList.hpp>
#include <System.Variants.hpp>
#include <System.WideStrings.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxres
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxResources;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxResources : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Vcl::Controls::TImageList* FDisabledButtonImages;
	Vcl::Controls::TImageList* FMainButtonImages;
	System::Classes::TStringList* FNames;
	Vcl::Controls::TImageList* FObjectImages;
	Vcl::Controls::TImageList* FPreviewButtonImages;
	System::Widestrings::TWideStrings* FValues;
	Vcl::Controls::TImageList* FWizardImages;
	System::Classes::TStringList* FLanguages;
	System::UnicodeString FHelpFile;
	unsigned FCP;
	void __fastcall BuildLanguagesList();
	Vcl::Controls::TImageList* __fastcall GetMainButtonImages();
	Vcl::Controls::TImageList* __fastcall GetObjectImages();
	Vcl::Controls::TImageList* __fastcall GetPreviewButtonImages();
	Vcl::Controls::TImageList* __fastcall GetWizardImages();
	
public:
	__fastcall TfrxResources();
	__fastcall virtual ~TfrxResources();
	System::UnicodeString __fastcall Get(const System::UnicodeString StrName);
	void __fastcall Add(const System::UnicodeString Ref, const System::UnicodeString Str);
	void __fastcall AddW(const System::UnicodeString Ref, System::WideString Str);
	void __fastcall AddStrings(const System::UnicodeString Str);
	void __fastcall AddXML(const System::AnsiString Str);
	void __fastcall Clear();
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	void __fastcall SetButtonImages(Vcl::Graphics::TBitmap* Images, bool Clear = false);
	void __fastcall SetObjectImages(Vcl::Graphics::TBitmap* Images, bool Clear = false);
	void __fastcall SetPreviewButtonImages(Vcl::Graphics::TBitmap* Images, bool Clear = false);
	void __fastcall SetWizardImages(Vcl::Graphics::TBitmap* Images, bool Clear = false);
	void __fastcall SetGlyph(Vcl::Buttons::TSpeedButton* Button, int Index);
	void __fastcall UpdateFSResources();
	void __fastcall Help(System::TObject* Sender)/* overload */;
	__property Vcl::Controls::TImageList* DisabledButtonImages = {read=FDisabledButtonImages};
	__property Vcl::Controls::TImageList* MainButtonImages = {read=GetMainButtonImages};
	__property Vcl::Controls::TImageList* PreviewButtonImages = {read=GetPreviewButtonImages};
	__property Vcl::Controls::TImageList* ObjectImages = {read=GetObjectImages};
	__property Vcl::Controls::TImageList* WizardImages = {read=GetWizardImages};
	__property System::Classes::TStringList* Languages = {read=FLanguages};
	__property System::UnicodeString HelpFile = {read=FHelpFile, write=FHelpFile};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxResources* __fastcall frxResources(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall frxGet(int ID);
}	/* namespace Frxres */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXRES)
using namespace Frxres;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxresHPP
