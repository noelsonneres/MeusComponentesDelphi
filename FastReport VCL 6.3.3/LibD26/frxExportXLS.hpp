// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportXLS.pas' rev: 33.00 (Windows)

#ifndef FrxexportxlsHPP
#define FrxexportxlsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Printers.hpp>
#include <System.Win.ComObj.hpp>
#include <frxClass.hpp>
#include <frxProgress.hpp>
#include <frxExportMatrix.hpp>
#include <Vcl.Clipbrd.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Variants.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportxls
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxXLSExport;
class DELPHICLASS TfrxExcel;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxXLSExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	TfrxExcel* FExcel;
	bool FExportPictures;
	bool FExportStyles;
	bool FFirstPage;
	Frxexportmatrix::TfrxIEMatrix* FMatrix;
	bool FMergeCells;
	bool FOpenExcelAfterExport;
	System::Extended FPageBottom;
	System::Extended FPageLeft;
	System::Extended FPageRight;
	System::Extended FPageTop;
	System::Uitypes::TPrinterOrientation FPageOrientation;
	Frxprogress::TfrxProgress* FProgress;
	bool FWysiwyg;
	bool FAsText;
	bool FBackground;
	bool FFastExport;
	bool FpageBreaks;
	bool FEmptyLines;
	bool FExportEMF;
	bool FTruncateLongTexts;
	bool FGridLines;
	void __fastcall ExportPage_Fast();
	void __fastcall ExportPage();
	System::WideString __fastcall CleanReturns(const System::WideString Str);
	System::Byte __fastcall FrameTypesToByte(Frxclass::TfrxFrameTypes Value);
	int __fastcall GetNewIndex(System::Classes::TStrings* Strings, int ObjValue);
	System::Extended __fastcall GetObjWidth(Frxexportmatrix::TfrxIEMObject* Obj);
	System::Extended __fastcall GetObjHeight(Frxexportmatrix::TfrxIEMObject* Obj);
	
protected:
	virtual void __fastcall AfterFinish();
	
public:
	__fastcall virtual TfrxXLSExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	
__published:
	__property bool ExportEMF = {read=FExportEMF, write=FExportEMF, nodefault};
	__property bool ExportStyles = {read=FExportStyles, write=FExportStyles, default=1};
	__property bool ExportPictures = {read=FExportPictures, write=FExportPictures, default=1};
	__property bool MergeCells = {read=FMergeCells, write=FMergeCells, default=1};
	__property bool OpenExcelAfterExport = {read=FOpenExcelAfterExport, write=FOpenExcelAfterExport, default=0};
	__property bool Wysiwyg = {read=FWysiwyg, write=FWysiwyg, default=1};
	__property bool AsText = {read=FAsText, write=FAsText, nodefault};
	__property bool Background = {read=FBackground, write=FBackground, nodefault};
	__property bool FastExport = {read=FFastExport, write=FFastExport, nodefault};
	__property bool PageBreaks = {read=FpageBreaks, write=FpageBreaks, nodefault};
	__property bool EmptyLines = {read=FEmptyLines, write=FEmptyLines, nodefault};
	__property SuppressPageHeadersFooters;
	__property OverwritePrompt;
	__property bool TruncateLongTexts = {read=FTruncateLongTexts, write=FTruncateLongTexts, default=1};
	__property bool GridLines = {read=FGridLines, write=FGridLines, default=1};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxXLSExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxXLSExport() { }
	
};


class PASCALIMPLEMENTATION TfrxExcel : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool FIsOpened;
	bool FIsVisible;
	System::Variant Excel;
	System::Variant WorkBook;
	System::Variant WorkSheet;
	System::Variant Range;
	Frxclass::TfrxFrameTypes __fastcall ByteToFrameTypes(System::Byte Value);
	
protected:
	System::UnicodeString __fastcall IntToCoord(int X, int Y);
	System::UnicodeString __fastcall Pos2Str(int Pos);
	void __fastcall SetVisible(bool DoShow);
	void __fastcall ApplyStyles(System::Classes::TStrings* aRanges, System::Byte Kind, Frxprogress::TfrxProgress* aProgress);
	void __fastcall ApplyFrame(const System::UnicodeString RangeCoord, System::Byte aFrame);
	void __fastcall SetRowsSize(System::Classes::TStrings* aRanges, System::Currency *Sizes, const int Sizes_High, int MainSizeIndex, int RowsCount, Frxprogress::TfrxProgress* aProgress);
	void __fastcall ApplyStyle(const System::UnicodeString RangeCoord, int aStyle);
	void __fastcall ApplyFormats(System::Classes::TStringList* aRanges, Frxprogress::TfrxProgress* aProgress);
	void __fastcall ApplyFormat(const System::UnicodeString RangeCoord, const System::UnicodeString aFormat);
	
public:
	__fastcall TfrxExcel();
	__fastcall virtual ~TfrxExcel();
	void __fastcall MergeCells();
	void __fastcall SetCellFrame(Frxclass::TfrxFrameTypes Frame);
	void __fastcall SetRowSize(int y, System::Extended Size);
	void __fastcall OpenExcel();
	void __fastcall SetColSize(int x, System::Extended Size);
	void __fastcall SetPageMargin(System::Extended Left, System::Extended Right, System::Extended Top, System::Extended Bottom, System::Uitypes::TPrinterOrientation Orientation);
	void __fastcall SetRange(int x, int y, int dx, int dy);
	__property bool Visible = {read=FIsVisible, write=SetVisible, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportxls */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTXLS)
using namespace Frxexportxls;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportxlsHPP
