// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportBIFF.pas' rev: 33.00 (Windows)

#ifndef FrxexportbiffHPP
#define FrxexportbiffHPP

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
#include <frxClass.hpp>
#include <frxExportMatrix.hpp>
#include <frxProgress.hpp>
#include <frxStorage.hpp>
#include <frxBIFF.hpp>
#include <frxOLEPS.hpp>
#include <frxEscher.hpp>
#include <frxDraftPool.hpp>
#include <frxBiffConverter.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportbiff
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDraftSheet;
class DELPHICLASS TfrxBIFFExport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDraftSheet : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Frxbiffconverter::TfrxBiffPageOptions Options;
public:
	/* TObject.Create */ inline __fastcall TfrxDraftSheet() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxDraftSheet() { }
	
};


class PASCALIMPLEMENTATION TfrxBIFFExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	int FParallelPages;
	Frxprogress::TfrxProgress* FProgress;
	bool FSingleSheet;
	bool FDeleteEmptyRows;
	int FChunkSize;
	bool FGridLines;
	System::Extended FInaccuracy;
	bool FFitPages;
	bool FPictures;
	System::Extended FRowHeightScale;
	bool FExportFormulas;
	Frxexportmatrix::TfrxIEMatrix* FMatrix;
	Frxbiff::TBiffWorkbook* FWB;
	int FZCW;
	int FTSW;
	Frxbiffconverter::TfrxPageInfo FLastPage;
	Frxdraftpool::TDpDraftPool* FDraftPool;
	System::AnsiString FAuthor;
	System::AnsiString FComment;
	System::AnsiString FKeywords;
	System::AnsiString FRevision;
	System::AnsiString FAppName;
	System::AnsiString FSubject;
	System::AnsiString FCategory;
	System::AnsiString FCompany;
	System::AnsiString FTitle;
	unsigned FAccess;
	System::AnsiString FManager;
	System::WideString FPassword;
	void __fastcall SetChunkSize(int Value);
	void __fastcall SetPassword(const System::WideString s);
	void __fastcall SetParallelPages(int Count);
	void __fastcall SetRowHeightScale(System::Extended Value);
	Frxbiffconverter::TfrxBiffPageOptions __fastcall GetExportOptionsDraft();
	void __fastcall SaveWorkbook(System::Classes::TStream* s);
	void __fastcall SaveSI(System::Classes::TStream* s);
	void __fastcall SaveDSI(System::Classes::TStream* s);
	void __fastcall InitProgressBar(int Steps, System::UnicodeString Text);
	void __fastcall StepProgressBar();
	void __fastcall FreeProgressBar();
	
public:
	__fastcall virtual TfrxBIFFExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	bool __fastcall UseParallelPages();
	Frxexportmatrix::TfrxIEMatrix* __fastcall CreateMatrix();
	void __fastcall ExportPage(System::TObject* Draft);
	
__published:
	__property OpenAfterExport;
	__property OverwritePrompt;
	__property bool SingleSheet = {read=FSingleSheet, write=FSingleSheet, default=0};
	__property bool DeleteEmptyRows = {read=FDeleteEmptyRows, write=FDeleteEmptyRows, default=0};
	__property System::Extended RowHeightScale = {read=FRowHeightScale, write=SetRowHeightScale};
	__property int ChunkSize = {read=FChunkSize, write=SetChunkSize, nodefault};
	__property bool GridLines = {read=FGridLines, write=FGridLines, default=1};
	__property System::Extended Inaccuracy = {read=FInaccuracy, write=FInaccuracy};
	__property bool FitPages = {read=FFitPages, write=FFitPages, nodefault};
	__property bool Pictures = {read=FPictures, write=FPictures, nodefault};
	__property System::AnsiString Author = {read=FAuthor, write=FAuthor};
	__property System::AnsiString Comment = {read=FComment, write=FComment};
	__property System::AnsiString Keywords = {read=FKeywords, write=FKeywords};
	__property System::AnsiString Revision = {read=FRevision, write=FRevision};
	__property System::AnsiString AppName = {read=FAppName, write=FAppName};
	__property System::AnsiString Subject = {read=FSubject, write=FSubject};
	__property System::AnsiString Category = {read=FCategory, write=FCategory};
	__property System::AnsiString Company = {read=FCompany, write=FCompany};
	__property System::AnsiString Title = {read=FTitle, write=FTitle};
	__property System::AnsiString Manager = {read=FManager, write=FManager};
	__property System::WideString Password = {read=FPassword, write=SetPassword};
	__property int ParallelPages = {read=FParallelPages, write=SetParallelPages, nodefault};
	__property bool ExportFormulas = {read=FExportFormulas, write=FExportFormulas, default=1};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxBIFFExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxBIFFExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportbiff */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTBIFF)
using namespace Frxexportbiff;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportbiffHPP
