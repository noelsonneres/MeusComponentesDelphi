// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportHTMLDiv.pas' rev: 33.00 (Windows)

#ifndef FrxexporthtmldivHPP
#define FrxexporthtmldivHPP

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
#include <Winapi.ShellAPI.hpp>
#include <Vcl.Graphics.hpp>
#include <frxClass.hpp>
#include <frxStorage.hpp>
#include <frxGradient.hpp>
#include <System.UITypes.hpp>
#include <frxExportHelpers.hpp>
#include <frxExportBaseDialog.hpp>
#include <frxVectorCanvas.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexporthtmldiv
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBoundsGauge;
class DELPHICLASS TfrxHTMLItem;
class DELPHICLASS TfrxHTMLItemQueue;
class DELPHICLASS TfrxHTMLDivExport;
class DELPHICLASS TfrxHTML5DivExport;
class DELPHICLASS TfrxHTML4DivExport;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxBoundsGauge : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Frxclass::TfrxView* FObj;
	bool FBoundsSet;
	System::Types::TRect FBounds;
	System::Types::TRect FBorders;
	int FX;
	int FY;
	int FX1;
	int FY1;
	int FDX;
	int FDY;
	int FFrameWidth;
	void __fastcall SetObj(Frxclass::TfrxView* Obj);
	void __fastcall AddBounds(const System::Types::TRect &r);
	int __fastcall GetInnerWidth();
	int __fastcall GetInnerHeight();
	
protected:
	void __fastcall BeginDraw();
	void __fastcall DrawBackground();
	void __fastcall DrawFrame();
	void __fastcall DrawLine(int x1, int y1, int x2, int y2, int w, Frxclass::TfrxFrameType Side);
	
public:
	__property Frxclass::TfrxView* Obj = {read=FObj, write=SetObj};
	__property System::Types::TRect Bounds = {read=FBounds};
	__property System::Types::TRect Borders = {read=FBorders};
	__property int InnerWidth = {read=GetInnerWidth, nodefault};
	__property int InnerHeight = {read=GetInnerHeight, nodefault};
public:
	/* TObject.Create */ inline __fastcall TfrxBoundsGauge() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxBoundsGauge() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxHTMLItem : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<System::Extended> _TfrxHTMLItem__1;
	
	
public:
	System::UnicodeString operator[](System::UnicodeString Index) { return this->Prop[Index]; }
	
private:
	System::UnicodeString FName;
	System::Classes::TStrings* FKeys;
	System::Classes::TStrings* FValues;
	System::UnicodeString FValue;
	System::AnsiString FRawValue;
	Frxstorage::TObjList* FChildren;
	System::Extended FLeft;
	System::Extended FTop;
	System::Extended FWidth;
	System::Extended FHeight;
	bool FLeftSet;
	bool FTopSet;
	bool FWidthSet;
	bool FHeightSet;
	Frxexporthelpers::TfrxCSSStyle* FStyle;
	System::UnicodeString FClass;
	int FRotation;
	bool FAllowNegativeLeft;
	bool FIsTransformMatrix;
	_TfrxHTMLItem__1 FTM;
	void __fastcall SetProp(System::UnicodeString Index, const System::UnicodeString Value);
	System::UnicodeString __fastcall GetProp(System::UnicodeString Index);
	Frxexporthelpers::TfrxCSSStyle* __fastcall GetStyle();
	void __fastcall SetLeft(System::Extended a);
	void __fastcall SetTop(System::Extended a);
	void __fastcall SetWidth(System::Extended a);
	void __fastcall SetHeight(System::Extended a);
	
public:
	__fastcall TfrxHTMLItem(const System::UnicodeString Name);
	__fastcall virtual ~TfrxHTMLItem();
	TfrxHTMLItem* __fastcall This();
	void __fastcall GaudeFrame(Frxclass::TfrxView* Obj);
	void __fastcall Gaude(Frxclass::TfrxView* Obj);
	void __fastcall WidenBy(System::Extended Size);
	void __fastcall DoPositive();
	__classmethod System::UnicodeString __fastcall EscapeAttribute(const System::UnicodeString s);
	void __fastcall Save(System::Classes::TStream* Stream, bool Formatted);
	TfrxHTMLItem* __fastcall Add(const System::UnicodeString Tag)/* overload */;
	TfrxHTMLItem* __fastcall Add(TfrxHTMLItem* Item)/* overload */;
	TfrxHTMLItem* __fastcall AddRotated(const System::UnicodeString Tag, int ARotation);
	TfrxHTMLItem* __fastcall AddTransformed(const System::UnicodeString Tag, System::Extended *ATransformMatrix, const int ATransformMatrix_High);
	void __fastcall AddCSSClass(const System::UnicodeString s);
	__property System::UnicodeString Prop[System::UnicodeString Index] = {read=GetProp, write=SetProp/*, default*/};
	__property System::UnicodeString Value = {write=FValue};
	__property System::AnsiString RawValue = {write=FRawValue};
	__property System::UnicodeString Name = {write=FName};
	__property Frxexporthelpers::TfrxCSSStyle* Style = {read=GetStyle};
	__property System::Extended Left = {read=FLeft, write=SetLeft};
	__property System::Extended Top = {read=FTop, write=SetTop};
	__property System::Extended Width = {read=FWidth, write=SetWidth};
	__property System::Extended Height = {read=FHeight, write=SetHeight};
	__property bool AllowNegativeLeft = {read=FAllowNegativeLeft, write=FAllowNegativeLeft, nodefault};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHTMLItemQueue : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<TfrxHTMLItem*> _TfrxHTMLItemQueue__1;
	
	
private:
	_TfrxHTMLItemQueue__1 FQueue;
	int FUsed;
	System::Classes::TStream* FStream;
	bool FFormatted;
	
protected:
	void __fastcall Flush();
	
public:
	__fastcall TfrxHTMLItemQueue(System::Classes::TStream* Stream, bool Formatted);
	__fastcall virtual ~TfrxHTMLItemQueue();
	void __fastcall Push(TfrxHTMLItem* Item);
	void __fastcall SetQueueLength(int n);
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxHTMLDivExport : public Frxexporthelpers::TExportHTMLDivSVGParent
{
	typedef Frxexporthelpers::TExportHTMLDivSVGParent inherited;
	
private:
	System::UnicodeString FTitle;
	bool FHTML5;
	bool FAllPictures;
	Frxexporthelpers::TfrxCSSStyle* FPageStyle;
	bool FExportAnchors;
	int FPictureTag;
	TfrxHTMLItemQueue* FQueue;
	Frxexporthelpers::TfrxCSSStyle* __fastcall GetPageStyle();
	bool __fastcall GetAnchor(System::UnicodeString &Page, const System::UnicodeString Name);
	System::UnicodeString __fastcall GetHRef(const System::UnicodeString URL);
	void __fastcall PutImg(Frxclass::TfrxView* Obj, Vcl::Graphics::TGraphic* Pic, bool WriteSize);
	void __fastcall StartHTML();
	void __fastcall EndHTML();
	bool __fastcall ExportTaggedView(Frxclass::TfrxView* Obj);
	bool __fastcall ExportAllPictures(Frxclass::TfrxView* Obj);
	bool __fastcall ExportMemo(Frxclass::TfrxView* Obj);
	bool __fastcall ExportPicture(Frxclass::TfrxView* Obj);
	bool __fastcall ExportShape(Frxclass::TfrxView* Obj);
	bool __fastcall ExportLine(Frxclass::TfrxView* Obj);
	bool __fastcall ExportGradient(Frxclass::TfrxView* Obj);
	bool __fastcall ExportViaEMF(Frxclass::TfrxView* Obj);
	bool __fastcall ExportAsPicture(Frxclass::TfrxView* Obj);
	
protected:
	TfrxHTMLItem* __fastcall AddTag(const System::UnicodeString Name);
	TfrxHTMLItem* __fastcall CreateDiv(Frxclass::TfrxView* Obj, int Widen = 0x0);
	TfrxHTMLItem* __fastcall CreateFrameDiv(Frxclass::TfrxView* Obj);
	TfrxHTMLItem* __fastcall CreateFillDiv(Frxclass::TfrxView* Obj);
	void __fastcall FillGraduienProps(Frxexporthelpers::TfrxCSSStyle* Style, System::Uitypes::TColor BeginColor, System::Uitypes::TColor EndColor, Frxclass::TfrxGradientStyle GradientStyle);
	System::UnicodeString __fastcall FilterHTML(const System::UnicodeString Text);
	System::UnicodeString __fastcall EscapeText(const System::UnicodeString s);
	System::UnicodeString __fastcall DoHyperLink(System::UnicodeString Text, Frxclass::TfrxView* Obj);
	void __fastcall DoExportAsPicture(Frxclass::TfrxView* Obj, bool Transparent, System::Uitypes::TColor TransparentColor = (System::Uitypes::TColor)(0x1fffffff));
	System::UnicodeString __fastcall NavPageNumber(int PageNumber);
	void __fastcall StartAnchors();
	void __fastcall StartNavigator();
	virtual void __fastcall CreateCSS();
	
public:
	__fastcall virtual TfrxHTMLDivExport(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxHTMLDivExport();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall Finish();
	__property Frxexporthelpers::TfrxCSSStyle* PageStyle = {read=GetPageStyle};
	
__published:
	__property System::UnicodeString Title = {read=FTitle, write=FTitle};
	__property bool HTML5 = {read=FHTML5, write=FHTML5, nodefault};
	__property bool AllPictures = {read=FAllPictures, write=FAllPictures, nodefault};
	__property bool ExportAnchors = {read=FExportAnchors, write=FExportAnchors, nodefault};
	__property int PictureTag = {read=FPictureTag, write=FPictureTag, nodefault};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxHTMLDivExport() : Frxexporthelpers::TExportHTMLDivSVGParent() { }
	
};


class PASCALIMPLEMENTATION TfrxHTML5DivExport : public TfrxHTMLDivExport
{
	typedef TfrxHTMLDivExport inherited;
	
public:
	__fastcall virtual TfrxHTML5DivExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
public:
	/* TfrxHTMLDivExport.Destroy */ inline __fastcall virtual ~TfrxHTML5DivExport() { }
	
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxHTML5DivExport() : TfrxHTMLDivExport() { }
	
};


class PASCALIMPLEMENTATION TfrxHTML4DivExport : public TfrxHTMLDivExport
{
	typedef TfrxHTMLDivExport inherited;
	
public:
	__fastcall virtual TfrxHTML4DivExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
public:
	/* TfrxHTMLDivExport.Destroy */ inline __fastcall virtual ~TfrxHTML4DivExport() { }
	
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxHTML4DivExport() : TfrxHTMLDivExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexporthtmldiv */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTHTMLDIV)
using namespace Frxexporthtmldiv;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexporthtmldivHPP
