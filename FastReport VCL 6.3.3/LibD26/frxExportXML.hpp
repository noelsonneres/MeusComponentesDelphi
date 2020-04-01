// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportXML.pas' rev: 33.00 (Windows)

#ifndef FrxexportxmlHPP
#define FrxexportxmlHPP

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
#include <Vcl.Printers.hpp>
#include <System.Win.ComObj.hpp>
#include <frxClass.hpp>
#include <frxExportMatrix.hpp>
#include <frxProgress.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportxml
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxXMLExport;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxSplitToSheet : unsigned char { ssNotSplit, ssRPages, ssPrintOnPrev, ssRowsCount };

class PASCALIMPLEMENTATION TfrxXMLExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
	
private:
	typedef System::DynamicArray<int> _TfrxXMLExport__1;
	
	typedef System::DynamicArray<System::Uitypes::TPrinterOrientation> _TfrxXMLExport__2;
	
	
private:
	bool FExportPageBreaks;
	bool FExportStyles;
	bool FFirstPage;
	Frxexportmatrix::TfrxIEMatrix* FMatrix;
	System::Extended FPageBottom;
	System::Extended FPageLeft;
	System::Extended FPageRight;
	System::Extended FPageTop;
	System::Uitypes::TPrinterOrientation FPageOrientation;
	System::Classes::TStringList* FPaperNames;
	_TfrxXMLExport__1 FPaperSizes;
	_TfrxXMLExport__2 FPaperOrientations;
	Frxprogress::TfrxProgress* FProgress;
	bool FWysiwyg;
	bool FBackground;
	System::UnicodeString FCreator;
	bool FEmptyLines;
	int FRowsCount;
	TfrxSplitToSheet FSplit;
	void __fastcall ExportPage(System::Classes::TStream* Stream);
	System::UnicodeString __fastcall ChangeReturns(const System::UnicodeString Str);
	System::WideString __fastcall TruncReturns(const System::WideString Str);
	void __fastcall SetRowsCount(const int Value);
	bool __fastcall GetOpenExcel();
	void __fastcall SetOpenExcel(const bool Value);
	
public:
	__fastcall virtual TfrxXMLExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	
__published:
	__property bool ExportStyles = {read=FExportStyles, write=FExportStyles, default=1};
	__property bool ExportPageBreaks = {read=FExportPageBreaks, write=FExportPageBreaks, default=1};
	__property bool OpenExcelAfterExport = {read=GetOpenExcel, write=SetOpenExcel, default=0};
	__property bool Wysiwyg = {read=FWysiwyg, write=FWysiwyg, default=1};
	__property bool Background = {read=FBackground, write=FBackground, default=0};
	__property System::UnicodeString Creator = {read=FCreator, write=FCreator};
	__property bool EmptyLines = {read=FEmptyLines, write=FEmptyLines, nodefault};
	__property SuppressPageHeadersFooters;
	__property OverwritePrompt;
	__property int RowsCount = {read=FRowsCount, write=SetRowsCount, nodefault};
	__property TfrxSplitToSheet Split = {read=FSplit, write=FSplit, nodefault};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxXMLExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxXMLExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportxml */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTXML)
using namespace Frxexportxml;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportxmlHPP
