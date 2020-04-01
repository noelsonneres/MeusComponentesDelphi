// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportXLSX.pas' rev: 33.00 (Windows)

#ifndef FrxexportxlsxHPP
#define FrxexportxlsxHPP

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
#include <System.Types.hpp>
#include <frxClass.hpp>
#include <frxExportMatrix.hpp>
#include <Winapi.ShellAPI.hpp>
#include <frxZip.hpp>
#include <frxOfficeOpen.hpp>
#include <frxImageConverter.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportxlsx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxXLSXExport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxXLSXExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	bool FExportPageBreaks;
	bool FEmptyLines;
	Frxexportmatrix::TfrxIEMatrix* FMatrix;
	System::UnicodeString FDocFolder;
	System::Classes::TStream* FContentTypes;
	System::Classes::TStream* FRels;
	System::Classes::TStream* FStyles;
	System::Classes::TStream* FWorkbook;
	System::Classes::TStream* FSharedStrings;
	System::Classes::TStream* FWorkbookRels;
	System::Classes::TStrings* FFonts;
	System::Classes::TStrings* FFills;
	System::Classes::TStrings* FBorders;
	System::Classes::TStrings* FCellStyleXfs;
	System::Classes::TStrings* FCellXfs;
	System::Classes::TList* FColors;
	System::Classes::TStrings* FNumFmts;
	int FPreviousNumFmtsCount;
	System::Classes::TStrings* FStrings;
	int FStringsCount;
	bool FSingleSheet;
	int FChunkSize;
	Frxofficeopen::TfrxMap FLastPage;
	bool FWysiwyg;
	Frximageconverter::TfrxPictureType FPictureType;
	int __fastcall AddString(System::UnicodeString s);
	int __fastcall AddColor(System::Uitypes::TColor c);
	void __fastcall AddColors(const System::Uitypes::TColor *c, const int c_High);
	void __fastcall AddSheet(const Frxofficeopen::TfrxMap &m);
	void __fastcall ExportFormats(System::Classes::TStrings* FNumFmts);
	void __fastcall UpdateStyles();
	
public:
	__fastcall virtual TfrxXLSXExport(System::Classes::TComponent* Owner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	
__published:
	__property int ChunkSize = {read=FChunkSize, write=FChunkSize, nodefault};
	__property bool EmptyLines = {read=FEmptyLines, write=FEmptyLines, default=1};
	__property bool ExportPageBreaks = {read=FExportPageBreaks, write=FExportPageBreaks, default=1};
	__property OpenAfterExport;
	__property OverwritePrompt;
	__property Frximageconverter::TfrxPictureType PictureType = {read=FPictureType, write=FPictureType, nodefault};
	__property bool SingleSheet = {read=FSingleSheet, write=FSingleSheet, default=1};
	__property bool Wysiwyg = {read=FWysiwyg, write=FWysiwyg, default=1};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxXLSXExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxXLSXExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportxlsx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTXLSX)
using namespace Frxexportxlsx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportxlsxHPP
