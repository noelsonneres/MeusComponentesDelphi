// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportSVG.pas' rev: 33.00 (Windows)

#ifndef FrxexportsvgHPP
#define FrxexportsvgHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.StrUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <frxClass.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.UITypes.hpp>
#include <System.WideStrings.hpp>
#include <frxExportHelpers.hpp>
#include <frxUnicodeUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportsvg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxSVGExport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxSVGExport : public Frxexporthelpers::TExportHTMLDivSVGParent
{
	typedef Frxexporthelpers::TExportHTMLDivSVGParent inherited;
	
private:
	Frxexporthelpers::TfrxCSSStyle* FShadowStyle;
	Frxexporthelpers::TfrxCSSStyle* __fastcall GetShadowStyle();
	void __fastcall PutImage(Frxclass::TfrxView* Obj, Vcl::Graphics::TGraphic* Pic);
	void __fastcall StartSVG(System::Extended Width, System::Extended Height);
	void __fastcall FinishSVG();
	bool __fastcall ExportAsPicture(Frxclass::TfrxView* Obj);
	bool __fastcall ExportPicture(Frxclass::TfrxView* Obj);
	bool __fastcall ExportViaEMF(Frxclass::TfrxView* Obj);
	bool __fastcall ExportGradient(Frxclass::TfrxView* Obj);
	bool __fastcall ExportLine(Frxclass::TfrxView* Obj);
	bool __fastcall ExportShape(Frxclass::TfrxView* Obj);
	bool __fastcall ExportMemo(Frxclass::TfrxView* Obj);
	
protected:
	System::Extended FGlobalPageY;
	virtual void __fastcall RunExportsChain(Frxclass::TfrxView* Obj);
	void __fastcall DoGradient(Frxclass::TfrxView* Obj, System::UnicodeString BeginValue, System::UnicodeString EndValue, Frxclass::TfrxGradientStyle Style, System::UnicodeString ClipValue = System::UnicodeString());
	void __fastcall DoFrameLine(System::Extended x1, System::Extended y1, System::Extended x2, System::Extended y2, Frxclass::TfrxFrameLine* frxFrameLine);
	void __fastcall DoFill(Frxclass::TfrxView* Obj);
	void __fastcall DoFrame(Frxclass::TfrxView* Obj);
	void __fastcall DoFilledRect(int x, int y, int Width, int Height, System::UnicodeString FillValue, System::UnicodeString ClipValue = System::UnicodeString())/* overload */;
	void __fastcall DoFilledRect(Frxclass::TfrxView* Obj, System::UnicodeString FillValue, System::UnicodeString ClipValue = System::UnicodeString())/* overload */;
	bool __fastcall DoHyperLink(Frxclass::TfrxView* Obj);
	void __fastcall DoExportAsPicture(Frxclass::TfrxView* Obj, bool Transparent, System::Uitypes::TColor TransparentColor = (System::Uitypes::TColor)(0x1fffffff));
	System::WideString __fastcall WrapByTSpan(System::Widestrings::TWideStrings* const TextList, Frxclass::TfrxCustomMemoView* Memo, const System::Extended x, const System::Extended dy, const System::Extended Width);
	System::UnicodeString __fastcall DefineShapeClipPath(Frxclass::TfrxView* Obj);
	System::UnicodeString __fastcall DefineRectClipPath(Frxclass::TfrxView* Obj);
	void __fastcall StartAnchors();
	void __fastcall StartNavigator();
	virtual void __fastcall CreateCSS();
	
public:
	__fastcall virtual TfrxSVGExport(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxSVGExport();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall Finish();
	__property Frxexporthelpers::TfrxCSSStyle* ShadowStyle = {read=GetShadowStyle};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxSVGExport() : Frxexporthelpers::TExportHTMLDivSVGParent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportsvg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTSVG)
using namespace Frxexportsvg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportsvgHPP
