// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGML.pas' rev: 33.00 (Windows)

#ifndef FrxgmlHPP
#define FrxgmlHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgml
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGmlList;
struct TGmlStr;
class DELPHICLASS TGmlNode;
class DELPHICLASS TGmlRtfNode;
class DELPHICLASS TGmlRtfGroup;
class DELPHICLASS TGmlRtfText;
class DELPHICLASS TGmlRtfControl;
class DELPHICLASS TGmlRtfNumber;
class DELPHICLASS TGmlRtfSymbol;
class DELPHICLASS TGmlRtfFont;
class DELPHICLASS TGmlRtfColor;
class DELPHICLASS TGmlRtf;
//-- type declarations -------------------------------------------------------
typedef int TGmlEaResult;

typedef int TGmlElValue;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlList : public System::Classes::TList
{
	typedef System::Classes::TList inherited;
	
public:
	virtual void __fastcall Clear();
public:
	/* TList.Destroy */ inline __fastcall virtual ~TGmlList() { }
	
public:
	/* TObject.Create */ inline __fastcall TGmlList() : System::Classes::TList() { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TGmlStr
{
public:
	int Pos;
	int Len;
	System::AnsiString Data;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlNode : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	void __fastcall SetHeader(const System::AnsiString s);
	void __fastcall SetBody(const System::AnsiString s);
	
protected:
	TGmlStr FHeader;
	TGmlStr FBody;
	virtual System::AnsiString __fastcall GetHeader() = 0 ;
	virtual System::AnsiString __fastcall GetBody() = 0 ;
	
public:
	TGmlNode* FParent;
	System::Classes::TList* FSubNodes;
	__fastcall virtual ~TGmlNode();
	void __fastcall DestroyTree();
	bool __fastcall Empty();
	void __fastcall UpdateParent();
	void __fastcall Remove(bool DestroyItself = true);
	int __fastcall SelfSubIndex();
	System::Classes::TList* __fastcall Select(int First, int Last = 0xffffffff);
	int __fastcall NodesCount();
	__property System::AnsiString Header = {read=GetHeader, write=SetHeader};
	__property System::AnsiString Body = {read=GetBody, write=SetBody};
public:
	/* TObject.Create */ inline __fastcall TGmlNode() : System::TObject() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtfNode : public TGmlNode
{
	typedef TGmlNode inherited;
	
protected:
	virtual System::AnsiString __fastcall GetHeader();
	virtual System::AnsiString __fastcall GetBody();
	
public:
	TGmlRtf* FDoc;
	virtual void __fastcall Serialize(System::Classes::TStream* Stream);
	void __fastcall SerializeSubNodes(System::Classes::TStream* Stream, int First, int Last);
	TGmlRtfNode* __fastcall Node(int Index);
	TGmlRtfNode* __fastcall Find(const System::AnsiString Hdr);
	System::Classes::TList* __fastcall FindAll(const System::AnsiString Hdr, int MaxCount = 0x0);
public:
	/* TGmlNode.Destroy */ inline __fastcall virtual ~TGmlRtfNode() { }
	
public:
	/* TObject.Create */ inline __fastcall TGmlRtfNode() : TGmlNode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtfGroup : public TGmlRtfNode
{
	typedef TGmlRtfNode inherited;
	
public:
	virtual void __fastcall Serialize(System::Classes::TStream* Stream);
public:
	/* TGmlNode.Destroy */ inline __fastcall virtual ~TGmlRtfGroup() { }
	
public:
	/* TObject.Create */ inline __fastcall TGmlRtfGroup() : TGmlRtfNode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtfText : public TGmlRtfNode
{
	typedef TGmlRtfNode inherited;
	
public:
	virtual void __fastcall Serialize(System::Classes::TStream* Stream);
public:
	/* TGmlNode.Destroy */ inline __fastcall virtual ~TGmlRtfText() { }
	
public:
	/* TObject.Create */ inline __fastcall TGmlRtfText() : TGmlRtfNode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtfControl : public TGmlRtfNode
{
	typedef TGmlRtfNode inherited;
	
private:
	bool FArg;
	int FArgValue;
	void __fastcall SetValue(int x);
	int __fastcall GetValue();
	
public:
	virtual void __fastcall Serialize(System::Classes::TStream* Stream);
	__property int Value = {read=GetValue, write=SetValue, nodefault};
public:
	/* TGmlNode.Destroy */ inline __fastcall virtual ~TGmlRtfControl() { }
	
public:
	/* TObject.Create */ inline __fastcall TGmlRtfControl() : TGmlRtfNode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtfNumber : public TGmlRtfNode
{
	typedef TGmlRtfNode inherited;
	
public:
	int FValue;
	virtual void __fastcall Serialize(System::Classes::TStream* Stream);
public:
	/* TGmlNode.Destroy */ inline __fastcall virtual ~TGmlRtfNumber() { }
	
public:
	/* TObject.Create */ inline __fastcall TGmlRtfNumber() : TGmlRtfNode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtfSymbol : public TGmlRtfNode
{
	typedef TGmlRtfNode inherited;
	
public:
	char Symbol;
	virtual void __fastcall Serialize(System::Classes::TStream* Stream);
public:
	/* TGmlNode.Destroy */ inline __fastcall virtual ~TGmlRtfSymbol() { }
	
public:
	/* TObject.Create */ inline __fastcall TGmlRtfSymbol() : TGmlRtfNode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtfFont : public TGmlRtfNode
{
	typedef TGmlRtfNode inherited;
	
private:
	int __fastcall GetIndex();
	int __fastcall GetCharset();
	System::AnsiString __fastcall GetName();
	
public:
	__property int Index = {read=GetIndex, nodefault};
	__property int Charset = {read=GetCharset, nodefault};
	__property System::AnsiString Name = {read=GetName};
public:
	/* TGmlNode.Destroy */ inline __fastcall virtual ~TGmlRtfFont() { }
	
public:
	/* TObject.Create */ inline __fastcall TGmlRtfFont() : TGmlRtfNode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtfColor : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TGmlRtfControl* R;
	TGmlRtfControl* G;
	TGmlRtfControl* B;
	System::AnsiString __fastcall Serialize();
public:
	/* TObject.Create */ inline __fastcall TGmlRtfColor() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGmlRtfColor() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGmlRtf : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::AnsiString FText;
	TGmlRtfNode* FRoot;
	System::Classes::TList* FStack;
	int FPos;
	int FLast;
	System::Classes::TList* FFontList;
	TGmlList* FColorList;
	char __fastcall Current(bool SkipInvisibles = false);
	char __fastcall Get();
	char __fastcall Prepare();
	void __fastcall Push();
	void __fastcall Pop(bool Discard = false);
	bool __cdecl IsVisible(char c);
	char __fastcall Escape(char c);
	bool __cdecl IsSpecChar(char c);
	bool __cdecl IsAlpha(char c);
	bool __cdecl IsDigit(char c);
	System::Byte __cdecl HexDigit(char c);
	bool __fastcall SkipAlpha();
	bool __fastcall SkipDigit();
	TGmlRtfNode* __fastcall SkipControl();
	TGmlRtfNode* __fastcall SkipGroup();
	TGmlRtfNode* __fastcall SkipNumber();
	TGmlRtfNode* __fastcall SkipText();
	TGmlRtfNode* __fastcall SkipControlSymbol();
	System::Classes::TList* __fastcall SkipList();
	System::Classes::TList* __fastcall Parse(int First, int Last);
	void __fastcall LoadFonts();
	void __fastcall LoadColors();
	
public:
	__fastcall TGmlRtf(const System::AnsiString Text);
	__fastcall virtual ~TGmlRtf();
	int __fastcall Length();
	int __fastcall Copy(int Pos, int Len, char * Dest)/* overload */;
	System::AnsiString __fastcall Copy(int Pos, int Len)/* overload */;
	System::AnsiString __fastcall Copy(const TGmlStr &Str)/* overload */;
	char __fastcall Char(int Pos);
	void __fastcall Serialize(System::Classes::TStream* Stream);
	__property TGmlRtfNode* Root = {read=FRoot};
	int __fastcall FontsCount();
	TGmlRtfFont* __fastcall Font(int i);
	int __fastcall ColorsCount();
	TGmlRtfColor* __fastcall Color(int i);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 GmlEaFailure = System::Int8(0x0);
static const System::Int8 GmlEaSuccess = System::Int8(0x1);
static const System::Int8 GmlEaIncomplete = System::Int8(0x2);
static const System::Int8 GmlElNone = System::Int8(0x0);
static const System::Int8 GmlElOne = System::Int8(0x1);
static const System::Int8 GmlElAll = System::Int8(-1);
extern DELPHI_PACKAGE char GmlRtfScEscape;
extern DELPHI_PACKAGE char GmlRtfScOpen;
extern DELPHI_PACKAGE char GmlRtfScClose;
static const System::Int8 GmlRtfMaxControl = System::Int8(0x20);
static const System::Int8 GmlRtfMaxControlArg = System::Int8(0xa);
}	/* namespace Frxgml */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGML)
using namespace Frxgml;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgmlHPP
