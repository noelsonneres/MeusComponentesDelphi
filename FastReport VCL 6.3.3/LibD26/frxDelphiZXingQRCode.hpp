// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDelphiZXingQRCode.pas' rev: 33.00 (Windows)

#ifndef FrxdelphizxingqrcodeHPP
#define FrxdelphizxingqrcodeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdelphizxingqrcode
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TErrorCorrectionLevel;
class DELPHICLASS TDelphiZXingQRCode;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TQRCodeEncoding : unsigned char { qrAuto, qrNumeric, qrAlphanumeric, qrISO88591, qrUTF8NoBOM, qrUTF8BOM, qrShift_JIS };

enum DECLSPEC_DENUM TQRErrorLevels : unsigned char { ecL, ecM, ecQ, ecH };

typedef System::DynamicArray<bool> Frxdelphizxingqrcode__1;

typedef System::DynamicArray<System::DynamicArray<bool> > T2DBooleanArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TErrorCorrectionLevel : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FBits;
	int FOrdinal;
	
public:
	void __fastcall Assign(TErrorCorrectionLevel* Source);
	__property int Bits = {read=FBits, write=FBits, nodefault};
	__property int Ordinal = {read=FOrdinal, write=FOrdinal, nodefault};
public:
	/* TObject.Create */ inline __fastcall TErrorCorrectionLevel() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TErrorCorrectionLevel() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDelphiZXingQRCode : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	void __fastcall SetErrorLevels(const TQRErrorLevels Value);
	void __fastcall SetCodePage(const int Value);
	
protected:
	System::WideString FData;
	int FRows;
	int FColumns;
	TQRCodeEncoding FEncoding;
	int FQuietZone;
	T2DBooleanArray FElements;
	TQRErrorLevels FErrorLevels;
	TErrorCorrectionLevel* FLevel;
	int FCodePage;
	void __fastcall SetEncoding(TQRCodeEncoding NewEncoding);
	void __fastcall SetData(const System::WideString NewData);
	void __fastcall SetQuietZone(int NewQuietZone);
	bool __fastcall GetIsBlack(int Row, int Column);
	void __fastcall Update();
	
public:
	__fastcall TDelphiZXingQRCode();
	__fastcall virtual ~TDelphiZXingQRCode();
	__property System::WideString Data = {read=FData, write=SetData};
	__property TQRCodeEncoding Encoding = {read=FEncoding, write=SetEncoding, nodefault};
	__property int QuietZone = {read=FQuietZone, write=SetQuietZone, nodefault};
	__property int Rows = {read=FRows, nodefault};
	__property int Columns = {read=FColumns, nodefault};
	__property bool IsBlack[int Row][int Column] = {read=GetIsBlack};
	__property TQRErrorLevels ErrorLevels = {read=FErrorLevels, write=SetErrorLevels, nodefault};
	__property int CodePage = {read=FCodePage, write=SetCodePage, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxdelphizxingqrcode */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDELPHIZXINGQRCODE)
using namespace Frxdelphizxingqrcode;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdelphizxingqrcodeHPP
