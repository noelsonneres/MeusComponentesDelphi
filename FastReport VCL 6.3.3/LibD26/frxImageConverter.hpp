// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxImageConverter.pas' rev: 33.00 (Windows)

#ifndef FrximageconverterHPP
#define FrximageconverterHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frximageconverter
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxPictureType : unsigned char { gpPNG, gpBMP, gpEMF, gpWMF, gpJPG, gpGIF };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetPicFileExtension(TfrxPictureType PicType);
extern DELPHI_PACKAGE void __fastcall SaveGraphicAs(Vcl::Graphics::TGraphic* Graphic, System::UnicodeString Path, TfrxPictureType PicType)/* overload */;
extern DELPHI_PACKAGE void __fastcall SaveGraphicAs(Vcl::Graphics::TGraphic* Graphic, System::Classes::TStream* Stream, TfrxPictureType PicType)/* overload */;
}	/* namespace Frximageconverter */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIMAGECONVERTER)
using namespace Frximageconverter;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrximageconverterHPP
