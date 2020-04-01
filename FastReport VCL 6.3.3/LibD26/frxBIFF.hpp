// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBIFF.pas' rev: 33.00 (Windows)

#ifndef FrxbiffHPP
#define FrxbiffHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <System.Contnrs.hpp>
#include <frxUtils.hpp>
#include <frxStorage.hpp>
#include <frxEscher.hpp>
#include <frxCrypto.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbiff
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TBiffRecord;
class DELPHICLASS TBiffStream;
class DELPHICLASS TBiffObject;
class DELPHICLASS TBiffUCS;
class DELPHICLASS TBiffStyle;
class DELPHICLASS TBiffCell;
class DELPHICLASS TBiffLinkTable;
class DELPHICLASS TBiffFormulaCell;
struct TBiffFormulaLexem;
class DELPHICLASS TBiffFormulaLexer;
struct TBiffFormulaToken;
class DELPHICLASS TBiffFormulaRPNStack;
class DELPHICLASS EBiffFormulaRPNStackError;
class DELPHICLASS TBiffFormulaParser;
class DELPHICLASS EBiffFormulaParserError;
struct TBiffFormulaCellRef;
class DELPHICLASS TBiffFormulaCodeEmitter;
class DELPHICLASS EBiffFormulaCodeEmitterError;
struct TBiffFormulaFunc;
class DELPHICLASS TBiffFormulaFuncList;
class DELPHICLASS TBiffFormulaCompiler;
class DELPHICLASS EBiffFormulaCompilerError;
class DELPHICLASS TBiffTextCell;
class DELPHICLASS TBiffNumberCell;
struct TBiffFontData;
class DELPHICLASS TBiffFont;
struct TBiffLine;
struct TBiffXfData;
class DELPHICLASS TBiffXF;
class DELPHICLASS TBiffColInfo;
class DELPHICLASS TBiffWindow;
class DELPHICLASS TBiffRow;
class DELPHICLASS TBiffPageSetup;
class DELPHICLASS TBiffRC4;
struct TBiffBounds;
class DELPHICLASS TBiffWindow2;
struct TBiffMargin;
class DELPHICLASS TRectangle;
class DELPHICLASS TBiffSheet;
class DELPHICLASS TBiffWorkbook;
//-- type declarations -------------------------------------------------------
typedef System::Word TBiffPaperSize;

typedef int TBiffFormatIndex;

typedef int TBiffStreamKind;

typedef System::Word TBiffRecId;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffRecord : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TBiffStream* FOwner;
	unsigned FOffset;
	System::Word __fastcall GetRecId();
	unsigned __fastcall GetSize();
	void __fastcall SetSize(unsigned n);
	
public:
	__fastcall TBiffRecord(TBiffStream* Owner, unsigned Offset);
	void __fastcall Write(const void *Buffer, unsigned Count);
	void __fastcall WriteConst(unsigned Value, unsigned Size);
	void __fastcall WriteZeros(unsigned Size);
	void __fastcall WriteStream(System::Classes::TStream* Stream);
	void __fastcall WriteBytes(unsigned Offset, unsigned Data, unsigned Count);
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	__property System::Word Id = {read=GetRecId, nodefault};
	__property unsigned Size = {read=GetSize, write=SetSize, nodefault};
	__property unsigned Offset = {read=FOffset, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffRecord() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffStream : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TBiffRecord* operator[](int Index) { return this->Records[Index]; }
	
private:
	System::Classes::TStream* FStream;
	Frxstorage::TListCache* FRecords;
	TBiffRecord* FLastRec;
	unsigned __fastcall ReadBytes(unsigned Offset, unsigned Count);
	void __fastcall WriteBytes(unsigned Offset, unsigned Data, unsigned Count);
	void __fastcall Append(unsigned Data, unsigned Count);
	void __fastcall AppendData(const void *Data, unsigned Count);
	void __fastcall AppendRecord(TBiffRecord* Rec, const void *Data, unsigned DataSize);
	TBiffRecord* __fastcall GetRecord(int Index);
	int __fastcall GetRecCount();
	unsigned __fastcall GetSize();
	
public:
	__fastcall TBiffStream(bool Cached);
	__fastcall virtual ~TBiffStream();
	TBiffRecord* __fastcall Add(System::Word Id);
	TBiffRecord* __fastcall AddBOF(int k);
	TBiffRecord* __fastcall AddEOF();
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	__property TBiffRecord* Records[int Index] = {read=GetRecord/*, default*/};
	__property int Count = {read=GetRecCount, nodefault};
	__property unsigned Size = {read=GetSize, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffObject : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	virtual void __fastcall Flush(TBiffStream* Stream) = 0 ;
	HIDESBASE virtual int __fastcall GetHashCode();
	HIDESBASE virtual bool __fastcall Equals(TBiffObject* s);
	__classmethod void __fastcall FlushList(Frxstorage::TObjList* list, TBiffStream* Stream);
public:
	/* TObject.Create */ inline __fastcall TBiffObject() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffObject() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffUCS : public TBiffObject
{
	typedef TBiffObject inherited;
	
private:
	System::WideString FData;
	System::Classes::TMemoryStream* FRuns;
	int FHash;
	bool FCompress;
	void __fastcall SetData(const System::WideString Value);
	bool __fastcall IsCompressible();
	void __fastcall Init();
	
public:
	bool Len16;
	int Tag;
	int SstIndex;
	__fastcall TBiffUCS()/* overload */;
	__fastcall TBiffUCS(const System::WideString S, bool UCS16)/* overload */;
	__fastcall virtual ~TBiffUCS();
	void __fastcall AddFormat(int Position, int Font);
	virtual void __fastcall Flush(TBiffStream* Stream);
	virtual bool __fastcall Equals(TBiffObject* s);
	virtual int __fastcall GetHashCode();
	__property System::WideString Data = {read=FData, write=SetData};
	__property bool Compress = {read=FCompress, write=FCompress, nodefault};
};

#pragma pack(pop)

enum DECLSPEC_DENUM TBiffBuiltinStyleId : unsigned char { bsiNormal, bsiRowLevel, bsiColLevel, bsiCOmma, bsiCurrency, bsiPercent, bsiComma0, bsiCurrency0, bsiHyperlink, bsiFHyperlink };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffStyle : public TBiffObject
{
	typedef TBiffObject inherited;
	
public:
	int XF;
	int StyleId;
	int Level;
	System::WideString Name;
	__fastcall TBiffStyle();
	virtual void __fastcall Flush(TBiffStream* Stream);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffStyle() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffCell : public TBiffObject
{
	typedef TBiffObject inherited;
	
public:
	int Row;
	int Col;
	int XF;
	__fastcall TBiffCell();
	virtual void __fastcall Flush(TBiffStream* Stream);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffCell() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffLinkTable : public TBiffObject
{
	typedef TBiffObject inherited;
	
	
private:
	typedef System::DynamicArray<System::UnicodeString> _TBiffLinkTable__1;
	
	typedef System::DynamicArray<int> _TBiffLinkTable__2;
	
	
private:
	_TBiffLinkTable__1 FIntSheetNames;
	_TBiffLinkTable__2 FIntSheetIndex;
	int FSheetsCount;
	int __fastcall FindSheet(const System::UnicodeString Name);
	int __fastcall GetRefsCount();
	void __fastcall SetRefsCount(int n);
	
public:
	int __fastcall GetInternalSheetRef(const System::UnicodeString SheetName);
	void __fastcall SetSheetIndex(const System::UnicodeString SheetName, int Index);
	virtual void __fastcall Flush(TBiffStream* Stream);
	__property int RefsCount = {read=GetRefsCount, write=SetRefsCount, nodefault};
	__property int SheetsCount = {read=FSheetsCount, write=FSheetsCount, nodefault};
public:
	/* TObject.Create */ inline __fastcall TBiffLinkTable() : TBiffObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffLinkTable() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffFormulaCell : public TBiffCell
{
	typedef TBiffCell inherited;
	
private:
	System::Classes::TStream* FInst;
	
public:
	__fastcall TBiffFormulaCell(System::Classes::TStream* Instructions);
	__fastcall virtual ~TBiffFormulaCell();
	virtual void __fastcall Flush(TBiffStream* Stream);
};

#pragma pack(pop)

enum DECLSPEC_DENUM TBiffFormulaLexemKind : unsigned char { flkVoid, flkSpace, flkName, flkInt, flkString, flkOp, flkSymbol };

struct DECLSPEC_DRECORD TBiffFormulaLexem
{
public:
	TBiffFormulaLexemKind Kind;
	System::UnicodeString Text;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffFormulaLexer : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<TBiffFormulaLexem> _TBiffFormulaLexer__1;
	
	
public:
	TBiffFormulaLexem operator[](int i) { return this->Lexems[i]; }
	
private:
	System::UnicodeString FText;
	int FPos;
	_TBiffFormulaLexer__1 FLexems;
	bool __fastcall IsAlpha(System::WideChar c);
	bool __fastcall IsDigit(System::WideChar c);
	System::UnicodeString __fastcall Read(int Len);
	System::WideChar __fastcall GetChar();
	System::WideChar __fastcall NextChar();
	void __fastcall SkipChar();
	System::UnicodeString __fastcall SubStr(int Pos, int Len);
	void __fastcall Add(const TBiffFormulaLexem &Lex)/* overload */;
	void __fastcall Add(TBiffFormulaLexemKind LexKind, const System::UnicodeString LexText)/* overload */;
	bool __fastcall AddSpace();
	bool __fastcall AddNumber();
	bool __fastcall AddSymbol();
	bool __fastcall AddName();
	bool __fastcall AddString(System::WideChar Quote);
	bool __fastcall AddOp();
	int __fastcall GetLexemsCount();
	TBiffFormulaLexem __fastcall GetLexem(int i);
	void __fastcall Analyse(const System::UnicodeString Formula);
	
public:
	__property System::UnicodeString Formula = {read=FText, write=Analyse};
	__property int Count = {read=GetLexemsCount, nodefault};
	__property TBiffFormulaLexem Lexems[int i] = {read=GetLexem/*, default*/};
public:
	/* TObject.Create */ inline __fastcall TBiffFormulaLexer() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffFormulaLexer() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TBiffFormulaTokenKind : unsigned char { ftkVoid, ftkArg, ftkOp };

enum DECLSPEC_DENUM TBiffFormulaOperatorKind : unsigned char { fokVoid, fokPush, fokDiv100, fokNeg, fokAdd, fokSub, fokDiv, fokMul, fokPow, fokArea, fokColon, fokIsect, fokExt, fokJoin, fokL, fokG, fokE, fokNE, fokLE, fokGE, fokNull, fokNumber, fokBool, fokString, fokCell, fokFunc, fokId };

struct DECLSPEC_DRECORD TBiffFormulaToken
{
public:
	TBiffFormulaTokenKind Kind;
	TBiffFormulaOperatorKind Op;
	System::UnicodeString Text;
	int Flags;
};


typedef System::DynamicArray<TBiffFormulaToken> TBiffFormulaTokenArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffFormulaRPNStack : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TBiffFormulaToken operator[](int i) { return this->Instructions[i]; }
	
private:
	int FNumArgs;
	TBiffFormulaTokenArray FCode;
	TBiffFormulaTokenArray FStack;
	TBiffFormulaTokenArray FFrame;
	void __fastcall Error(const System::UnicodeString Msg);
	void __fastcall Ensure(bool b, const System::UnicodeString Msg = L"RPN stack failed");
	void __fastcall Push(TBiffFormulaTokenArray &Res, const TBiffFormulaToken &t);
	TBiffFormulaToken __fastcall Pop(TBiffFormulaTokenArray &a);
	TBiffFormulaToken __fastcall Top(const TBiffFormulaTokenArray a);
	void __fastcall PushOp(const TBiffFormulaToken &Op)/* overload */;
	void __fastcall PopOp();
	void __fastcall Unroll();
	bool __fastcall Joinable(TBiffFormulaOperatorKind Op);
	int __fastcall OpPriority(TBiffFormulaOperatorKind Kind);
	int __fastcall GetCount();
	TBiffFormulaToken __fastcall GetInstruction(int i);
	int __fastcall GetFrameArgs();
	int __fastcall GetFrameOps();
	
public:
	void __fastcall PushArg(TBiffFormulaOperatorKind Op, const System::UnicodeString Text, int Flags = 0x0);
	void __fastcall PushOp(TBiffFormulaOperatorKind Op, const System::UnicodeString Text, int NumArgs = 0x0)/* overload */;
	void __fastcall PushFrame(const System::UnicodeString Func = System::UnicodeString());
	void __fastcall PopFrame();
	__property int Count = {read=GetCount, nodefault};
	__property TBiffFormulaToken Instructions[int i] = {read=GetInstruction/*, default*/};
public:
	/* TObject.Create */ inline __fastcall TBiffFormulaRPNStack() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffFormulaRPNStack() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EBiffFormulaRPNStackError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EBiffFormulaRPNStackError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EBiffFormulaRPNStackError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EBiffFormulaRPNStackError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EBiffFormulaRPNStackError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EBiffFormulaRPNStackError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EBiffFormulaRPNStackError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EBiffFormulaRPNStackError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EBiffFormulaRPNStackError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBiffFormulaRPNStackError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBiffFormulaRPNStackError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBiffFormulaRPNStackError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBiffFormulaRPNStackError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EBiffFormulaRPNStackError() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffFormulaParser : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<TBiffFormulaLexem> _TBiffFormulaParser__1;
	
	typedef System::DynamicArray<int> _TBiffFormulaParser__2;
	
	
public:
	TBiffFormulaToken operator[](int i) { return this->Tokens[i]; }
	
private:
	_TBiffFormulaParser__1 FLexems;
	int FPos;
	_TBiffFormulaParser__2 FSavedPos;
	TBiffFormulaRPNStack* FRPN;
	TBiffFormulaTokenArray FCode;
	TBiffFormulaToken __fastcall CreateArgToken(TBiffFormulaOperatorKind Kind, const System::UnicodeString Text = System::UnicodeString(), int Flags = 0x0);
	void __fastcall Push(TBiffFormulaOperatorKind Arg, const System::UnicodeString Text = System::UnicodeString(), int Flags = 0x0);
	void __fastcall Error(const System::UnicodeString ErrorMsg);
	void __fastcall Ensure(bool b, const System::UnicodeString ErrorMsg = L"Invalid formula");
	TBiffFormulaLexem __fastcall Lexem(int i = 0x0);
	void __fastcall SkipLexem();
	bool __fastcall SkipLexemIf(const System::UnicodeString Text)/* overload */;
	bool __fastcall SkipLexemIf(TBiffFormulaLexemKind Kind, /* out */ System::UnicodeString &Text)/* overload */;
	bool __fastcall IsOp(const TBiffFormulaLexem &Lex, const System::UnicodeString Text);
	bool __fastcall IsArgSep(const TBiffFormulaLexem &Lex);
	void __fastcall Save();
	void __fastcall Load();
	void __fastcall Discard();
	TBiffFormulaOperatorKind __fastcall OpKind(const System::UnicodeString s);
	void __fastcall Parse(const System::UnicodeString s);
	void __fastcall BuildLexems(const System::UnicodeString s);
	void __fastcall CleanLexems();
	void __fastcall CopyCodeFromRPNStack();
	bool __fastcall ReadSym(const System::UnicodeString s);
	bool __fastcall ReadString(/* out */ System::UnicodeString &s);
	bool __fastcall ReadNumber(/* out */ System::UnicodeString &s);
	bool __fastcall ReadName(/* out */ System::UnicodeString &s);
	bool __fastcall ReadOp(/* out */ System::UnicodeString &s);
	bool __fastcall ReadSheet(/* out */ System::UnicodeString &s);
	bool __fastcall ReadCell(/* out */ TBiffFormulaToken &t);
	bool __fastcall ParseFormula();
	bool __fastcall ParsePPTerm();
	bool __fastcall ParsePrefOp();
	bool __fastcall ParsePostOp();
	bool __fastcall ParseTerm();
	bool __fastcall ParseString();
	bool __fastcall ParseNumber();
	bool __fastcall ParseCell();
	bool __fastcall ParseArea();
	bool __fastcall ParseBinOp();
	bool __fastcall ParseFuncCall();
	bool __fastcall ParseNameConst();
	bool __fastcall ParseExtCell();
	bool __fastcall ParseExtArea();
	TBiffFormulaToken __fastcall GetToken(int i);
	int __fastcall GetTokensCount();
	
public:
	__property System::UnicodeString Formula = {write=Parse};
	__property TBiffFormulaToken Tokens[int i] = {read=GetToken/*, default*/};
	__property int Count = {read=GetTokensCount, nodefault};
public:
	/* TObject.Create */ inline __fastcall TBiffFormulaParser() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffFormulaParser() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EBiffFormulaParserError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EBiffFormulaParserError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EBiffFormulaParserError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EBiffFormulaParserError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EBiffFormulaParserError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EBiffFormulaParserError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EBiffFormulaParserError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EBiffFormulaParserError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EBiffFormulaParserError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBiffFormulaParserError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBiffFormulaParserError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBiffFormulaParserError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBiffFormulaParserError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EBiffFormulaParserError() { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TBiffFormulaCellRef
{
public:
	int Row;
	int Col;
	bool AbsRow;
	bool AbsCol;
};


enum DECLSPEC_DENUM TBiffFormulaRetType : unsigned char { frtVoid, frtRef, frtVal, frtArray };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffFormulaCodeEmitter : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TStream* FInst;
	TBiffFormulaRetType FRetTypeMode;
	void __fastcall Error(const System::UnicodeString ErrorMsg);
	void __fastcall Ensure(bool b, const System::UnicodeString ErrorMsg = L"Cannot emit opcode");
	void __fastcall EnsureCellRange(const TBiffFormulaCellRef &Cell);
	System::Byte __fastcall RelFlags(bool RelRow, bool RelCol);
	void __fastcall WriteOpCode(System::Byte Op);
	void __fastcall Write(unsigned Inst, unsigned Len = (unsigned)(0x1));
	void __fastcall WriteCellRef(const TBiffFormulaCellRef &Cell);
	void __fastcall WriteAreaRef(const TBiffFormulaCellRef &Cell1, const TBiffFormulaCellRef &Cell2);
	
public:
	void __fastcall Push(int Value)/* overload */;
	void __fastcall Push(double Value)/* overload */;
	void __fastcall Push(bool b)/* overload */;
	void __fastcall Push(const System::UnicodeString s)/* overload */;
	void __fastcall PushNull();
	void __fastcall PushCell(const TBiffFormulaCellRef &Cell);
	void __fastcall PushArea(const TBiffFormulaCellRef &Cell1, const TBiffFormulaCellRef &Cell2);
	void __fastcall PushExtCell(int SheetRefId, const TBiffFormulaCellRef &Cell);
	void __fastcall PushExtArea(int SheetRefId, const TBiffFormulaCellRef &Cell1, const TBiffFormulaCellRef &Cell2);
	void __fastcall Call(unsigned Func)/* overload */;
	void __fastcall Call(unsigned Func, unsigned NumArgs)/* overload */;
	void __fastcall CallId();
	void __fastcall Neg();
	void __fastcall Div100();
	void __fastcall Add();
	void __fastcall Sub();
	void __fastcall Mul();
	void __fastcall Divide();
	void __fastcall Pow();
	void __fastcall CmpL();
	void __fastcall CmpG();
	void __fastcall CmpLE();
	void __fastcall CmpGE();
	void __fastcall CmpE();
	void __fastcall CmpNE();
	void __fastcall Intersect();
	void __fastcall Range();
	void __fastcall Join();
	__property System::Classes::TStream* Output = {read=FInst, write=FInst};
	__property TBiffFormulaRetType RetMode = {read=FRetTypeMode, write=FRetTypeMode, nodefault};
public:
	/* TObject.Create */ inline __fastcall TBiffFormulaCodeEmitter() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffFormulaCodeEmitter() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EBiffFormulaCodeEmitterError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EBiffFormulaCodeEmitterError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EBiffFormulaCodeEmitterError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EBiffFormulaCodeEmitterError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EBiffFormulaCodeEmitterError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EBiffFormulaCodeEmitterError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EBiffFormulaCodeEmitterError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EBiffFormulaCodeEmitterError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EBiffFormulaCodeEmitterError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBiffFormulaCodeEmitterError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBiffFormulaCodeEmitterError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBiffFormulaCodeEmitterError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBiffFormulaCodeEmitterError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EBiffFormulaCodeEmitterError() { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TBiffFormulaFunc
{
public:
	System::UnicodeString Name;
	int Id;
	int MinArgs;
	int MaxArgs;
	bool Volatile;
	System::WideChar RetType;
	System::UnicodeString ArgTypes;
};


typedef System::DynamicArray<TBiffFormulaFunc> TBiffFormulaFuncArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffFormulaFuncList : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	__classmethod void __fastcall Init();
	__classmethod void __fastcall Add(const TBiffFormulaFunc &f)/* overload */;
	__classmethod int __fastcall Find(System::UnicodeString Name);
	__classmethod int __fastcall GetCount();
	__classmethod TBiffFormulaFunc __fastcall GetFunc(int i);
	__classmethod void __fastcall SetFunc(int i, const TBiffFormulaFunc &f);
	__classmethod void __fastcall SetCount(int n);
	
public:
	__classmethod void __fastcall Add(int Id, System::UnicodeString Name, int MinArgs, int MaxArgs, System::WideChar RetType, System::UnicodeString ArgTypes, bool Volatile = false)/* overload */;
	__classmethod bool __fastcall Exists(const System::UnicodeString Name);
	__classmethod TBiffFormulaFunc __fastcall Get(const System::UnicodeString Name);
	__classmethod System::WideChar __fastcall GetArgType(const System::UnicodeString Name, int i);
public:
	/* TObject.Create */ inline __fastcall TBiffFormulaFuncList() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffFormulaFuncList() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffFormulaCompiler : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<TBiffFormulaRetType> _TBiffFormulaCompiler__1;
	
	
private:
	TBiffFormulaParser* FParser;
	int FPos;
	TBiffFormulaCodeEmitter* FEmitter;
	System::Classes::TStream* FCode;
	TBiffLinkTable* FLinkTable;
	_TBiffFormulaCompiler__1 FRetTypes;
	TBiffLinkTable* __fastcall GetLinkTable();
	TBiffFormulaToken __fastcall Token(int i = 0x0);
	void __fastcall SkipToken();
	void __fastcall SelectToken(int i);
	void __fastcall Error(const System::UnicodeString Fmt, const System::TVarRec *Args, const int Args_High);
	void __fastcall Ensure(bool b, const System::UnicodeString ErrorMsg = L"Cannot compile formula")/* overload */;
	void __fastcall Ensure(bool b, const System::UnicodeString Fmt, const System::TVarRec *Args, const int Args_High)/* overload */;
	bool __fastcall IsCell(const TBiffFormulaToken &t);
	bool __fastcall IsStr(const TBiffFormulaToken &t);
	TBiffFormulaCellRef __fastcall GetCellPos(const TBiffFormulaToken &t);
	void __fastcall CalcRetTypes();
	void __fastcall Compile(const System::UnicodeString s);
	void __fastcall CompileToken();
	void __fastcall EmitNum(double Num);
	void __fastcall EmitOp(TBiffFormulaOperatorKind Kind, int NumArgs);
	void __fastcall EmitFunc(System::UnicodeString Name, int NumArgs);
	void __fastcall EmitIdFunc(int NumArgs);
	void __fastcall EmitArea(const TBiffFormulaToken &Cell1, const TBiffFormulaToken &Cell2);
	void __fastcall EmitExtCell(const TBiffFormulaToken &Sheet, const TBiffFormulaToken &Cell);
	void __fastcall EmitExtArea(const TBiffFormulaToken &Sheet, const TBiffFormulaToken &Cell1, const TBiffFormulaToken &Cell2);
	void __fastcall EmitPush(const TBiffFormulaToken &t);
	
public:
	__fastcall TBiffFormulaCompiler();
	__fastcall virtual ~TBiffFormulaCompiler();
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	__property System::UnicodeString Formula = {write=Compile};
	__property TBiffLinkTable* LinkTable = {read=GetLinkTable, write=FLinkTable};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EBiffFormulaCompilerError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EBiffFormulaCompilerError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EBiffFormulaCompilerError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EBiffFormulaCompilerError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EBiffFormulaCompilerError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EBiffFormulaCompilerError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EBiffFormulaCompilerError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EBiffFormulaCompilerError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EBiffFormulaCompilerError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBiffFormulaCompilerError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBiffFormulaCompilerError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBiffFormulaCompilerError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBiffFormulaCompilerError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EBiffFormulaCompilerError() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffTextCell : public TBiffCell
{
	typedef TBiffCell inherited;
	
public:
	int SST;
	__fastcall TBiffTextCell(int SST);
	virtual void __fastcall Flush(TBiffStream* Stream);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffTextCell() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TBiffNumberCell : public TBiffCell
{
	typedef TBiffCell inherited;
	
public:
	double Value;
	__fastcall TBiffNumberCell(double Value);
	virtual void __fastcall Flush(TBiffStream* Stream);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffNumberCell() { }
	
};


enum DECLSPEC_DENUM TBiffColorIndex : unsigned char { ciBlack, ciWhite, ciRed, ciGreen, ciBlue, ciYellow, ciMagenta, ciCyan };

typedef int TBiffFontOptions;

enum DECLSPEC_DENUM TBiffFontFamily : unsigned char { ffNone, ffRoman, ffSwiss, ffModern, ffScript, ffDecorative };

enum DECLSPEC_DENUM TBiffFontEscapement : unsigned char { feNone, feSuperScript, feSubScript };

typedef int TBiffFontUnderline;

typedef int TBiffFontWeight;

struct DECLSPEC_DRECORD TBiffFontData
{
public:
	int Height;
	System::Word Options;
	System::Word Color;
	System::Word Weight;
	TBiffFontEscapement Esc;
	int Underline;
	TBiffFontFamily Family;
	System::Byte Charset;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffFont : public TBiffObject
{
	typedef TBiffObject inherited;
	
public:
	TBiffFontData Data;
	System::WideString Name;
	int Hash;
	int FontIndex;
	__fastcall TBiffFont();
	virtual void __fastcall Flush(TBiffStream* Stream);
	virtual bool __fastcall Equals(TBiffObject* Font);
	virtual int __fastcall GetHashCode();
	int __fastcall StrWidth(const System::WideString Str);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffFont() { }
	
};

#pragma pack(pop)

typedef int TBiffXFTypeProt;

typedef int TBiffXFUsedAttrib;

typedef int TBiffPatternStyle;

enum DECLSPEC_DENUM TBiffXFHAlign : unsigned char { xfhaGeneral, xfhaLeft, xfhaCentered, xfhaRight, xfhaFilled, xfhaJustified, xfhaCAS, xfhaDistributed };

enum DECLSPEC_DENUM TBiffXFVAlign : unsigned char { xfvaTop, xfvaCentered, xfvaBottom, xfvaJustified, xfvaDistributed };

enum DECLSPEC_DENUM TBiffXFTextDir : unsigned char { xftdAuto, xftdLTR, xftdRTL };

enum DECLSPEC_DENUM TBiffXFOrientation : unsigned char { xfoNone, xfoTop, xfo90CCW, xfo90CW };

enum DECLSPEC_DENUM TBiffLineStyle : unsigned char { lsNone, lsThin, lsMedium, lsDashed, lsDotted, lsThick, lsDouble, lsHair, lsMediumDashed, lsThinDashDotted, lsMediumDashDotted, lsThinDashDotDotted, lsMediumDashDotDotted, lsSlantedMediumDashDotted };

struct DECLSPEC_DRECORD TBiffLine
{
public:
	TBiffLineStyle Style;
	System::Byte Color;
};


struct DECLSPEC_DRECORD TBiffXfData
{
public:
	int Font;
	int Format;
	System::Byte Prot;
	int Parent;
	TBiffXFHAlign HAlign;
	bool WordWrap;
	TBiffXFVAlign VAlign;
	bool Justify;
	System::Byte Rotation;
	System::Byte Indent;
	bool Shrink;
	TBiffXFTextDir Direction;
	System::Byte UsedAttrs;
	TBiffLine L;
	TBiffLine T;
	TBiffLine R;
	TBiffLine B;
	TBiffLine D;
	bool LTRB;
	bool LBRT;
	System::Byte Patt;
	System::Word PattColor;
	System::Word PattBgColor;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffXF : public TBiffObject
{
	typedef TBiffObject inherited;
	
public:
	int XfIndex;
	TBiffXfData Data;
	int Hash;
	__fastcall TBiffXF();
	virtual void __fastcall Flush(TBiffStream* Stream);
	virtual bool __fastcall Equals(TBiffObject* XF);
	virtual int __fastcall GetHashCode();
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffXF() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffColInfo : public TBiffObject
{
	typedef TBiffObject inherited;
	
public:
	int First;
	int Last;
	int XF;
	bool Hidden;
	bool Collapsed;
	System::Byte Outline;
	int Width;
	__fastcall TBiffColInfo(int Column, int XF, int Width);
	virtual void __fastcall Flush(TBiffStream* Stream);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffColInfo() { }
	
};

#pragma pack(pop)

typedef int TBiffWindowOptions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffWindow : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	int HPos;
	int VPos;
	int Width;
	int Height;
	int ActiveSheet;
	int FirstTab;
	int SelSheet;
	int TabWidth;
	bool Visible;
	bool Open;
	bool HSBVisible;
	bool VSBVisible;
	bool TabVisible;
	__fastcall TBiffWindow();
	void __fastcall Flush(TBiffStream* Stream);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffWindow() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffRow : public TBiffObject
{
	typedef TBiffObject inherited;
	
public:
	int Row;
	Frxstorage::TObjList* Cells;
	int FirstCol;
	int LastCol;
	int Height;
	System::Byte Outline;
	int XF;
	bool Hidden;
	unsigned FirstCell;
	unsigned Offset;
	__fastcall TBiffRow();
	__fastcall virtual ~TBiffRow();
	virtual void __fastcall Flush(TBiffStream* Stream);
};

#pragma pack(pop)

enum DECLSPEC_DENUM TBiffPageOrientation : unsigned char { bpoLandscape, bpoPortrait };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffPageSetup : public TBiffObject
{
	typedef TBiffObject inherited;
	
public:
	System::Word Size;
	TBiffPageOrientation Orient;
	int Copies;
	bool Colored;
	System::Word Xdpi;
	System::Word Ydpi;
	bool PrintInRows;
	bool Draft;
	bool CellNotes;
	bool SheetNotes;
	__fastcall TBiffPageSetup();
	virtual void __fastcall Flush(TBiffStream* Stream);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffPageSetup() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffRC4 : public TBiffObject
{
	typedef TBiffObject inherited;
	
private:
	System::StaticArray<System::Byte, 16> FSalt;
	System::StaticArray<System::Byte, 16> FVerifier;
	System::StaticArray<System::Byte, 16> FHash;
	System::StaticArray<System::Byte, 5> FTruncHash;
	Frxcrypto::TCryptoRC4* FCipher;
	int FTail;
	int FBlockId;
	void __fastcall EncryptEx(void * Data, int Size);
	void __fastcall MD5(/* out */ void *Hash, const void *Data, int Size);
	
public:
	__fastcall TBiffRC4();
	__fastcall virtual ~TBiffRC4();
	void __fastcall Prepare(const void *Password, int PassLen);
	virtual void __fastcall Flush(TBiffStream* Stream);
	void __fastcall Init(void * Key, int Len);
	void __fastcall Initialize(unsigned BlockId);
	void __cdecl Encrypt(void * Data, int Size);
	void __fastcall EncryptStream(TBiffStream* Stream);
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TBiffBounds
{
public:
	int FR;
	int LR;
	int FC;
	int LC;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffWindow2 : public TBiffObject
{
	typedef TBiffObject inherited;
	
public:
	System::Word Options;
	System::Word FirstRow;
	System::Word FirstCol;
	System::Word GridCol;
	System::Word MFPBP;
	System::Word CMFNV;
	__fastcall TBiffWindow2();
	virtual void __fastcall Flush(TBiffStream* Stream);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBiffWindow2() { }
	
};

#pragma pack(pop)

typedef int TBiffSheetKind;

enum DECLSPEC_DENUM TBiffSheetVisibility : unsigned char { svVisible, svHidden, svVeryHidden };

struct DECLSPEC_DRECORD TBiffMargin
{
public:
	double Left;
	double Top;
	double Right;
	double Bottom;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TRectangle : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Types::TRect FRect;
	int __fastcall GetBottom();
	System::Types::TPoint __fastcall GetBottomRight();
	int __fastcall GetLeft();
	int __fastcall GetRight();
	int __fastcall GetTop();
	System::Types::TPoint __fastcall GetTopLeft();
	void __fastcall SetBottom(const int Value);
	void __fastcall SetBottomRight(const System::Types::TPoint &Value);
	void __fastcall SetLeft(const int Value);
	void __fastcall SetRight(const int Value);
	void __fastcall SetTop(const int Value);
	void __fastcall SetTopLeft(const System::Types::TPoint &Value);
	
public:
	__property int Bottom = {read=GetBottom, write=SetBottom, nodefault};
	__property System::Types::TPoint BottomRight = {read=GetBottomRight, write=SetBottomRight};
	__property int Left = {read=GetLeft, write=SetLeft, nodefault};
	__property int Right = {read=GetRight, write=SetRight, nodefault};
	__property int Top = {read=GetTop, write=SetTop, nodefault};
	__property System::Types::TPoint TopLeft = {read=GetTopLeft, write=SetTopLeft};
public:
	/* TObject.Create */ inline __fastcall TRectangle() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TRectangle() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TBiffSheet : public TBiffObject
{
	typedef TBiffObject inherited;
	
private:
	Frxstorage::TObjList* FRows;
	Frxstorage::TObjList* FCols;
	System::Contnrs::TObjectList* FMrgCells;
	Frxescher::TEscherGroup* FDGroup;
	TBiffWorkbook* FOwner;
	int FKind;
	TBiffSheetVisibility FVis;
	System::Classes::TList* FPB;
	int FStrCount;
	int FLastReadRow;
	void __fastcall SetColWidth(int i, int w);
	void __fastcall SetRowHeight(int i, int h);
	int __fastcall GetColWidth(int i);
	int __fastcall GetRowHeight(int i);
	TBiffRow* __fastcall GetRow(int Index);
	
public:
	System::WideString Name;
	TBiffMargin Margin;
	TBiffPageSetup* PageSetup;
	TBiffWindow2* View;
	TBiffBounds Bounds;
	int RecIndex;
	__fastcall TBiffSheet(TBiffWorkbook* Owner);
	__fastcall virtual ~TBiffSheet();
	void __fastcall AddCell(TBiffCell* Cell);
	void __fastcall MergeCells(const System::Types::TRect &Rect);
	void __fastcall AddColInfo(TBiffColInfo* Info);
	Frxescher::TEscherShape* __fastcall AddDrawing();
	virtual void __fastcall Flush(TBiffStream* Stream);
	void __fastcall AddPageBreak(int Row);
	int __fastcall LastRowIndex();
	__property int ColWidth[int i] = {read=GetColWidth, write=SetColWidth};
	__property int RowHeight[int i] = {read=GetRowHeight, write=SetRowHeight};
	__property int TextCellsCount = {read=FStrCount, nodefault};
	__property TBiffSheetVisibility Visibility = {read=FVis, nodefault};
	__property int Kind = {read=FKind, nodefault};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TBiffWorkbook : public TBiffObject
{
	typedef TBiffObject inherited;
	
private:
	Frxstorage::TObjList* SST;
	Frxstorage::TListHashTable* SSTHash;
	TBiffWindow* Win;
	Frxstorage::TObjList* Sheets;
	Frxstorage::TObjList* Styles;
	Frxstorage::TObjList* FFormats;
	Frxescher::TEscherStorage* Escher;
	TBiffLinkTable* FLinkTbl;
	Frxstorage::TObjList* Fonts;
	Frxstorage::TListHashTable* FontHash;
	Frxstorage::TObjList* XFs;
	Frxstorage::TListHashTable* XFHash;
	System::StaticArray<unsigned, 64> Palette;
	unsigned PalUsed;
	TBiffRC4* FCipher;
	_RTL_CRITICAL_SECTION FCsStrings;
	_RTL_CRITICAL_SECTION FCsFonts;
	_RTL_CRITICAL_SECTION FCsXFs;
	_RTL_CRITICAL_SECTION FCsSheets;
	_RTL_CRITICAL_SECTION FCsStyles;
	_RTL_CRITICAL_SECTION FCsColors;
	_RTL_CRITICAL_SECTION FCsPictures;
	_RTL_CRITICAL_SECTION FCsFormats;
	void __fastcall LockSst();
	void __fastcall UnlockSst();
	void __fastcall LockFonts();
	void __fastcall UnlockFonts();
	void __fastcall LockXfs();
	void __fastcall UnlockXfs();
	void __fastcall LockSheets();
	void __fastcall UnlockSheets();
	void __fastcall LockStyles();
	void __fastcall UnlockStyles();
	void __fastcall LockColors();
	void __fastcall UnlockColors();
	void __fastcall LockPictures();
	void __fastcall UnlockPictures();
	void __fastcall LockFormats();
	void __fastcall UnlockFormats();
	TBiffLinkTable* __fastcall GetLinkTable();
	int __fastcall GetSheetsCount();
	TBiffSheet* __fastcall GetSheet(int Index);
	int __fastcall GetFontsCount();
	TBiffFont* __fastcall GetFont(int Index);
	void __fastcall SetFormat(int i, const System::WideString s);
	int __fastcall AddBlip(Frxescher::TEscherPicture* Blip);
	int __fastcall AddColorInternal(unsigned C);
	
public:
	__fastcall TBiffWorkbook();
	__fastcall virtual ~TBiffWorkbook();
	void __fastcall SetPassword(const System::WideString s);
	unsigned __fastcall AddString(TBiffUCS* S)/* overload */;
	unsigned __fastcall AddString(System::WideString S)/* overload */;
	unsigned __fastcall AddFont(TBiffFont* F);
	unsigned __fastcall AddXF(TBiffXF* X);
	unsigned __fastcall AddSheet(TBiffSheet* S);
	int __fastcall AddStyle(TBiffStyle* S);
	int __fastcall AddFormat(const System::WideString FormatStr, int FormatIndex = 0xffffffff);
	int __fastcall AddColor(unsigned C);
	int __fastcall AddBitmap(System::Byte Kind, System::Classes::TStream* Contents);
	int __fastcall AddMetafile(Vcl::Graphics::TMetafile* Metafile);
	int __fastcall StringsCount();
	virtual void __fastcall Flush(TBiffStream* Stream);
	__property int SheetsCount = {read=GetSheetsCount, nodefault};
	__property TBiffSheet* Sheet[int Index] = {read=GetSheet};
	__property int FontsCount = {read=GetFontsCount, nodefault};
	__property TBiffFont* Font[int Index] = {read=GetFont};
	__property System::WideString Format[int i] = {write=SetFormat};
	__property TBiffLinkTable* LinkTable = {read=GetLinkTable};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word BiffMaxRecLen = System::Word(0x2020);
static const System::Word BiffMaxMrgCellsNum = System::Word(0x402);
static const System::Int8 BiffRowBlockSz = System::Int8(0x20);
static const System::Int8 BiffPaletteSize = System::Int8(0x40);
static const System::Word BiffRrdMaxCount = System::Word(0x1010);
static const System::Word BiffMaxRow = System::Word(0xfffe);
static const System::Byte BiffMaxCol = System::Byte(0xfe);
static const System::Byte BiffUserFormat = System::Byte(0xa4);
static const System::Int8 bkWBGlobals = System::Int8(0x5);
static const System::Int8 bkVBModule = System::Int8(0x6);
static const System::Int8 bkSheet = System::Int8(0x10);
static const System::Int8 bkChart = System::Int8(0x20);
static const System::Int8 bkMacro = System::Int8(0x40);
static const System::Word bkWorkspace = System::Word(0x100);
static const System::Int8 foBold = System::Int8(0x1);
static const System::Int8 foItalic = System::Int8(0x2);
static const System::Int8 foUnderline = System::Int8(0x4);
static const System::Int8 foStruckOut = System::Int8(0x8);
static const System::Int8 foOutline = System::Int8(0x10);
static const System::Int8 foShadow = System::Int8(0x20);
static const System::Int8 foCondense = System::Int8(0x40);
static const System::Byte foExtended = System::Byte(0x80);
static const System::Int8 fuNone = System::Int8(0x0);
static const System::Int8 fuSingle = System::Int8(0x1);
static const System::Int8 fuDouble = System::Int8(0x2);
static const System::Int8 fuSingleAcc = System::Int8(0x21);
static const System::Int8 fuDoubleAcc = System::Int8(0x22);
static const System::Word fwNormal = System::Word(0x190);
static const System::Word fwBold = System::Word(0x2bc);
static const System::Int8 xftpCellLocked = System::Int8(0x1);
static const System::Int8 xftpHidden = System::Int8(0x2);
static const System::Int8 xftpStyle = System::Int8(0x4);
static const System::Int8 BiffXfuaNumber = System::Int8(0x1);
static const System::Int8 BiffXfuaFont = System::Int8(0x2);
static const System::Int8 BiffXfuaText = System::Int8(0x4);
static const System::Int8 BiffXfuaBorders = System::Int8(0x8);
static const System::Int8 BiffXfuaBg = System::Int8(0x10);
static const System::Int8 BiffXfuaCellProt = System::Int8(0x20);
static const System::Int8 BiffXfuaAll = System::Int8(0x3f);
static const System::Int8 psNone = System::Int8(0x0);
static const System::Int8 psSolid = System::Int8(0x1);
static const System::Int8 psChess = System::Int8(0x2);
static const System::Int8 psHorThick = System::Int8(0x5);
static const System::Int8 psVerThick = System::Int8(0x6);
static const System::Int8 psChessThick = System::Int8(0x9);
static const System::Int8 psHor = System::Int8(0xb);
static const System::Int8 psVer = System::Int8(0xc);
static const System::Int8 psDiagBack = System::Int8(0xd);
static const System::Int8 psDiag = System::Int8(0xe);
static const System::Int8 psCross = System::Int8(0xf);
static const System::Int8 psCrossDiag = System::Int8(0x10);
static const System::Int8 woFormula = System::Int8(0x1);
static const System::Int8 woGrid = System::Int8(0x2);
static const System::Int8 woHeaders = System::Int8(0x4);
static const System::Int8 woFreezePanes = System::Int8(0x8);
static const System::Int8 woShowZeros = System::Int8(0x10);
static const System::Int8 woAutoGridCol = System::Int8(0x20);
static const System::Int8 woColRTL = System::Int8(0x40);
static const System::Byte woOutline = System::Byte(0x80);
static const System::Word woNoSplits = System::Word(0x100);
static const System::Word woSelected = System::Word(0x200);
static const System::Word woActive = System::Word(0x400);
static const System::Word woPageBreak = System::Word(0x800);
static const System::Int8 skWorksheet = System::Int8(0x0);
static const System::Int8 skChart = System::Int8(0x2);
static const System::Int8 skVB = System::Int8(0x6);
static const System::Int8 BiffFmtGeneral = System::Int8(0x0);
static const System::Int8 BiffFmtFixedPoint = System::Int8(0x2);
static const System::Int8 BiffFmtThSep = System::Int8(0x4);
static const System::Int8 BiffFmtCurrency = System::Int8(0x5);
static const System::Int8 BiffFmtDateTime = System::Int8(0x16);
static const System::Int8 BiffWoFormulas = System::Int8(0x1);
static const System::Int8 BiffWoGridLines = System::Int8(0x2);
static const System::Int8 BiffWoHeaders = System::Int8(0x4);
static const System::Int8 BiffWoFrozen = System::Int8(0x8);
static const System::Int8 BiffWoZeros = System::Int8(0x10);
static const System::Int8 BiffWoAutoGridColor = System::Int8(0x20);
static const System::Int8 BiffWoColumnsRTL = System::Int8(0x40);
static const System::Byte BiffWoOutline = System::Byte(0x80);
static const System::Word BiffWoNoSplits = System::Word(0x100);
static const System::Word BiffWoSelected = System::Word(0x200);
static const System::Word BiffWoActive = System::Word(0x400);
static const System::Word BiffWoPageBreak = System::Word(0x800);
static const System::Int8 BiffPsUnknown = System::Int8(0x0);
static const System::Int8 BiffPsA4 = System::Int8(0x9);
static const System::Int8 BiffPsReservedMin = System::Int8(0x76);
static const System::Byte BiffPsReservedMax = System::Byte(0xff);
static const System::Word BiffPsCustomMin = System::Word(0x100);
static const System::Int8 BiffBoffWin = System::Int8(0x1);
static const System::Int8 BiffBoffRisc = System::Int8(0x2);
static const System::Int8 BiffBoffBeta = System::Int8(0x4);
static const System::Int8 BiffBoffWinAny = System::Int8(0x8);
static const System::Int8 BiffBoffMacAny = System::Int8(0x10);
static const System::Int8 BiffBoffBetaAny = System::Int8(0x20);
static const System::Word BiffBoffRiscAny = System::Word(0x100);
static const System::Word BiffBoffFontLim = System::Word(0x2000);
static const System::Int8 BiffWsbShowBreaks = System::Int8(0x1);
static const System::Int8 BiffWsbDialog = System::Int8(0x10);
static const System::Int8 BiffWsbOutline = System::Int8(0x20);
static const System::Int8 BiffWsbRowSums = System::Int8(0x40);
static const System::Byte BiffWsbColSums = System::Byte(0x80);
static const System::Word BiffWsbFitPage = System::Word(0x100);
static const System::Word BiffWsbHSync = System::Word(0x1000);
static const System::Word BiffWsbVSync = System::Word(0x2000);
static const System::Word BiffWsbAltExpr = System::Word(0x4000);
static const System::Word BiffWsbAltFormulas = System::Word(0x8000);
extern DELPHI_PACKAGE unsigned __fastcall NearestColor(void * Colors, unsigned Count, unsigned Color);
extern DELPHI_PACKAGE void __fastcall ValidateLineBreaks(System::WideString &s);
}	/* namespace Frxbiff */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBIFF)
using namespace Frxbiff;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxbiffHPP
