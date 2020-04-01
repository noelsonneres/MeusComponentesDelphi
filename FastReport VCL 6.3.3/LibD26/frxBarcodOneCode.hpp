// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBarcodOneCode.pas' rev: 33.00 (Windows)

#ifndef FrxbarcodonecodeHPP
#define FrxbarcodonecodeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbarcodonecode
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOneCode;
//-- type declarations -------------------------------------------------------
typedef System::DynamicArray<int> TLongIntArray;

class PASCALIMPLEMENTATION TOneCode : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::AnsiString __fastcall PadLeft(System::AnsiString str, int TotalWidth, char PaddingChar);
	System::AnsiString __fastcall TrimStart(System::AnsiString str, char TrimChar);
	System::AnsiString __fastcall TrimOff(System::AnsiString source, System::AnsiString bad);
	System::AnsiString __fastcall Substring(System::AnsiString str, int startIndex, int len = 0xffffffff);
	int __fastcall AnsiToInt(System::AnsiString str);
	
protected:
	__int64 entries2Of13;
	__int64 entries5Of13;
	TLongIntArray table2Of13;
	TLongIntArray table5Of13;
	System::StaticArray<System::StaticArray<__int64, 2>, 10> codewordArray;
	TLongIntArray __fastcall OneCodeInfo(int topic);
	bool __fastcall OneCodeInitializeNof13Table(TLongIntArray ai, int i, int j);
	int __fastcall OneCodeMathReverse(int i);
	bool __fastcall OneCodeMathAdd(TLongIntArray bytearray, int i, int j);
	bool __fastcall OneCodeMathDivide(System::AnsiString v);
	int __fastcall OneCodeMathFcs(TLongIntArray bytearray);
	bool __fastcall OneCodeMathMultiply(TLongIntArray bytearray, int i, int j);
	
public:
	__fastcall TOneCode();
	System::AnsiString __fastcall Bars(System::AnsiString source);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TOneCode() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxbarcodonecode */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBARCODONECODE)
using namespace Frxbarcodonecode;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxbarcodonecodeHPP
