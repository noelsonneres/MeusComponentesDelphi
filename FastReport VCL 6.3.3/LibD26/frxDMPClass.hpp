// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDMPClass.pas' rev: 33.00 (Windows)

#ifndef FrxdmpclassHPP
#define FrxdmpclassHPP

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
#include <System.UITypes.hpp>
#include <System.WideStrings.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdmpclass
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDMPMemoView;
class DELPHICLASS TfrxDMPLineView;
class DELPHICLASS TfrxDMPCommand;
class DELPHICLASS TfrxDMPPage;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxDMPFontStyle : unsigned char { fsxBold, fsxItalic, fsxUnderline, fsxSuperScript, fsxSubScript, fsxCondensed, fsxWide, fsx12cpi, fsx15cpi };

typedef System::Set<TfrxDMPFontStyle, TfrxDMPFontStyle::fsxBold, TfrxDMPFontStyle::fsx15cpi> TfrxDMPFontStyles;

class PASCALIMPLEMENTATION TfrxDMPMemoView : public Frxclass::TfrxCustomMemoView
{
	typedef Frxclass::TfrxCustomMemoView inherited;
	
private:
	TfrxDMPFontStyles FFontStyle;
	bool FTruncOutboundText;
	void __fastcall SetFontStyle(const TfrxDMPFontStyles Value);
	bool __fastcall IsFontStyleStored();
	
protected:
	virtual void __fastcall DrawFrame();
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual void __fastcall SetTop(System::Extended Value);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	virtual void __fastcall SetParentFont(const bool Value);
	
public:
	__fastcall virtual TfrxDMPMemoView(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	void __fastcall ResetFontOptions();
	void __fastcall SetBoundsDirect(System::Extended ALeft, System::Extended ATop, System::Extended AWidth, System::Extended AHeight);
	virtual System::Extended __fastcall CalcHeight();
	virtual System::Extended __fastcall CalcWidth();
	System::UnicodeString __fastcall GetoutBoundText();
	virtual bool __fastcall IsEMFExportable();
	
__published:
	__property AutoWidth = {default=0};
	__property AllowExpressions = {default=1};
	__property DataField = {default=0};
	__property DataSet;
	__property DataSetName = {default=0};
	__property DisplayFormat;
	__property ExpressionDelimiters = {default=0};
	__property FlowTo;
	__property TfrxDMPFontStyles FontStyle = {read=FFontStyle, write=SetFontStyle, stored=IsFontStyleStored, nodefault};
	__property Frame;
	__property HAlign = {default=0};
	__property HideZeros = {default=0};
	__property Memo;
	__property ParentFont = {default=1};
	__property RTLReading = {default=0};
	__property SuppressRepeated = {default=0};
	__property WordWrap = {default=1};
	__property bool TruncOutboundText = {read=FTruncOutboundText, write=FTruncOutboundText, nodefault};
	__property VAlign = {default=0};
public:
	/* TfrxCustomMemoView.Destroy */ inline __fastcall virtual ~TfrxDMPMemoView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDMPMemoView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxCustomMemoView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDMPLineView : public Frxclass::TfrxCustomLineView
{
	typedef Frxclass::TfrxCustomLineView inherited;
	
private:
	TfrxDMPFontStyles FFontStyle;
	void __fastcall SetFontStyle(const TfrxDMPFontStyles Value);
	bool __fastcall IsFontStyleStored();
	
protected:
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual void __fastcall SetTop(System::Extended Value);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetParentFont(const bool Value);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property TfrxDMPFontStyles FontStyle = {read=FFontStyle, write=SetFontStyle, stored=IsFontStyleStored, nodefault};
	__property ParentFont = {default=1};
public:
	/* TfrxCustomLineView.Create */ inline __fastcall virtual TfrxDMPLineView(System::Classes::TComponent* AOwner) : Frxclass::TfrxCustomLineView(AOwner) { }
	/* TfrxCustomLineView.DesignCreate */ inline __fastcall virtual TfrxDMPLineView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxCustomLineView(AOwner, Flags) { }
	
public:
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxDMPLineView() { }
	
};


class PASCALIMPLEMENTATION TfrxDMPCommand : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	System::UnicodeString FCommand;
	
protected:
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual void __fastcall SetTop(System::Extended Value);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	System::UnicodeString __fastcall ToChr();
	
__published:
	__property System::UnicodeString Command = {read=FCommand, write=FCommand};
public:
	/* TfrxView.Create */ inline __fastcall virtual TfrxDMPCommand(System::Classes::TComponent* AOwner) : Frxclass::TfrxView(AOwner) { }
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxDMPCommand() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDMPCommand(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDMPPage : public Frxclass::TfrxReportPage
{
	typedef Frxclass::TfrxReportPage inherited;
	
private:
	TfrxDMPFontStyles FFontStyle;
	void __fastcall SetFontStyle(const TfrxDMPFontStyles Value);
	
protected:
	virtual void __fastcall SetPaperHeight(const System::Extended Value);
	virtual void __fastcall SetPaperWidth(const System::Extended Value);
	virtual void __fastcall SetPaperSize(const int Value);
	
public:
	__fastcall virtual TfrxDMPPage(System::Classes::TComponent* AOwner)/* overload */;
	virtual void __fastcall SetDefaults();
	void __fastcall ResetFontOptions();
	
__published:
	__property TfrxDMPFontStyles FontStyle = {read=FFontStyle, write=SetFontStyle, nodefault};
public:
	/* TfrxReportPage.CreateInPreview */ inline __fastcall TfrxDMPPage(System::Classes::TComponent* AOwner, Frxclass::TfrxReport* AReport)/* overload */ : Frxclass::TfrxReportPage(AOwner, AReport) { }
	/* TfrxReportPage.Destroy */ inline __fastcall virtual ~TfrxDMPPage() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDMPPage(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxReportPage(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxdmpclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDMPCLASS)
using namespace Frxdmpclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdmpclassHPP
