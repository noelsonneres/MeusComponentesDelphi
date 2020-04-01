// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDelphiZXIngCode.pas' rev: 33.00 (Windows)

#ifndef FrxdelphizxingcodeHPP
#define FrxdelphizxingcodeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Contnrs.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdelphizxingcode
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGenericGF;
class DELPHICLASS TGenericGFPoly;
class DELPHICLASS TReedSolomonEncoder;
class DELPHICLASS TBitArray;
//-- type declarations -------------------------------------------------------
typedef System::DynamicArray<int> TIntegerArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGenericGF : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<TGenericGFPoly*> _TGenericGF__1;
	
	
private:
	TIntegerArray FExpTable;
	TIntegerArray FLogTable;
	TGenericGFPoly* FZero;
	TGenericGFPoly* FOne;
	int FSize;
	int FPrimitive;
	int FGeneratorBase;
	bool FInitialized;
	_TGenericGF__1 FPolyList;
	void __fastcall CheckInit();
	void __fastcall Initialize();
	
public:
	__classmethod TGenericGF* __fastcall CreateQRCodeField256();
	__classmethod TGenericGF* __fastcall CreateAztecData12();
	__classmethod TGenericGF* __fastcall CreateAztecData10();
	__classmethod TGenericGF* __fastcall CreateAztecData8();
	__classmethod TGenericGF* __fastcall CreateMatrixField256();
	__classmethod TGenericGF* __fastcall CreateAztecData6();
	__classmethod TGenericGF* __fastcall CreateMaxicodeField64();
	__classmethod TGenericGF* __fastcall CreateAztecParam();
	__classmethod int __fastcall AddOrSubtract(int A, int B);
	__fastcall TGenericGF(int Primitive, int Size, int B);
	__fastcall virtual ~TGenericGF();
	TGenericGFPoly* __fastcall GetZero();
	int __fastcall Exp(int A);
	int __fastcall GetGeneratorBase();
	int __fastcall Inverse(int A);
	int __fastcall Multiply(int A, int B);
	TGenericGFPoly* __fastcall BuildMonomial(int Degree, int Coefficient);
};

#pragma pack(pop)

typedef System::DynamicArray<TGenericGFPoly*> TGenericGFPolyArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGenericGFPoly : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TGenericGF* FField;
	TIntegerArray FCoefficients;
	
public:
	__fastcall TGenericGFPoly(TGenericGF* AField, TIntegerArray ACoefficients);
	__fastcall virtual ~TGenericGFPoly();
	TIntegerArray __fastcall Coefficients();
	TGenericGFPoly* __fastcall Multiply(TGenericGFPoly* Other);
	TGenericGFPoly* __fastcall MultiplyByMonomial(int Degree, int Coefficient);
	TGenericGFPolyArray __fastcall Divide(TGenericGFPoly* Other);
	TIntegerArray __fastcall GetCoefficients();
	bool __fastcall IsZero();
	int __fastcall GetCoefficient(int Degree);
	int __fastcall GetDegree();
	TGenericGFPoly* __fastcall AddOrSubtract(TGenericGFPoly* Other);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TReedSolomonEncoder : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TGenericGF* FField;
	System::Contnrs::TObjectList* FCachedGenerators;
	
public:
	__fastcall TReedSolomonEncoder(TGenericGF* AField);
	__fastcall virtual ~TReedSolomonEncoder();
	void __fastcall Encode(TIntegerArray ToEncode, int ECBytes);
	TGenericGFPoly* __fastcall BuildGenerator(int Degree);
};

#pragma pack(pop)

typedef System::DynamicArray<System::Byte> TByteArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBitArray : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<int> _TBitArray__1;
	
	
public:
	bool operator[](int i) { return this->Item[i]; }
	
private:
	int FSize;
	_TBitArray__1 Bits;
	void __fastcall SetItem(int i, const bool Value);
	
protected:
	void __fastcall EnsureCapacity(int Size);
	
public:
	__fastcall TBitArray()/* overload */;
	__fastcall TBitArray(const int Size)/* overload */;
	void __fastcall Clear();
	int __fastcall GetSizeInBytes();
	int __fastcall GetSize();
	bool __fastcall Get(int i);
	void __fastcall SetBit(int Index);
	void __fastcall AppendBit(bool Bit);
	void __fastcall AppendBits(int Value, int NumBits);
	void __fastcall AppendBitArray(TBitArray* NewBitArray);
	void __fastcall ToBytes(int BitOffset, TByteArray Source, int Offset, int NumBytes);
	void __fastcall XorOperation(TBitArray* Other);
	__property int Size = {read=FSize, nodefault};
	__property bool Item[int i] = {read=Get, write=SetItem/*, default*/};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBitArray() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall FreeAndSetBitArray(TBitArray* &BitArray1, TBitArray* BitArray2);
extern DELPHI_PACKAGE char __fastcall IfValue(bool IsTrue, char TrueValue, char FalseValue)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall IfValue(bool IsTrue, System::UnicodeString TrueValue, System::UnicodeString FalseValue)/* overload */;
extern DELPHI_PACKAGE int __fastcall IfValue(bool IsTrue, int TrueValue, int FalseValue)/* overload */;
}	/* namespace Frxdelphizxingcode */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDELPHIZXINGCODE)
using namespace Frxdelphizxingcode;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdelphizxingcodeHPP
