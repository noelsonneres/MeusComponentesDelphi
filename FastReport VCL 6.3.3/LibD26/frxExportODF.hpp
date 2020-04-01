// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportODF.pas' rev: 33.00 (Windows)

#ifndef FrxexportodfHPP
#define FrxexportodfHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Printers.hpp>
#include <frxClass.hpp>
#include <frxExportMatrix.hpp>
#include <frxProgress.hpp>
#include <frxXML.hpp>
#include <frxImageConverter.hpp>
#include <frxExportBaseDialog.hpp>
#include <frxZip.hpp>
#include <System.Variants.hpp>
#include <Winapi.ShellAPI.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportodf
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxODFExport;
class DELPHICLASS TfrxODSExport;
class DELPHICLASS TfrxODTExport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxODFExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	bool FExportPageBreaks;
	bool FExportStyles;
	bool FFirstPage;
	Frxexportmatrix::TfrxIEMatrix* FMatrix;
	System::Extended FPageWidth;
	System::Extended FPageHeight;
	bool FWysiwyg;
	bool FSingleSheet;
	bool FBackground;
	System::UnicodeString FCreator;
	bool FEmptyLines;
	System::UnicodeString FTempFolder;
	Frxzip::TfrxZipArchive* FZipFile;
	Vcl::Extctrls::TImage* FThumbImage;
	Frxprogress::TfrxProgress* FProgress;
	System::UnicodeString FExportType;
	System::UnicodeString FLanguage;
	Frxxml::TfrxXMLItem* FStyleNode;
	System::Classes::TList* FStyles;
	int FPicCount;
	System::TDateTime FCreationTime;
	Frximageconverter::TfrxPictureType FPictureType;
	System::Classes::TStrings* FRowStyleNames;
	System::Classes::TStringList* FPageStyle;
	int FPageIndex;
	bool __fastcall IsTerminated();
	void __fastcall DoOnProgress(System::TObject* Sender);
	System::WideString __fastcall OdfPrepareString(const System::WideString Str);
	System::UnicodeString __fastcall OdfGetFrameName(const Frxclass::TfrxFrameStyle FrameStyle);
	void __fastcall OdfMakeHeader(Frxxml::TfrxXMLItem* const Item);
	void __fastcall OdfCreateMeta(const System::UnicodeString FileName, const System::UnicodeString Creator);
	void __fastcall OdfCreateManifest(const System::UnicodeString FileName, const int PicCount, const System::UnicodeString MValue);
	void __fastcall OdfCreateMime(const System::UnicodeString FileName, const System::UnicodeString MValue);
	void __fastcall AddNumberStyle(Frxxml::TfrxXMLItem* Item, const System::UnicodeString StyleName, const System::UnicodeString Fmt);
	void __fastcall ExportBody(Frxxml::TfrxXMLItem* BodyNode);
	void __fastcall AddPic(Frxxml::TfrxXMLItem* Node, Frxexportmatrix::TfrxIEMObject* Obj);
	void __fastcall SplitOnTags(Frxxml::TfrxXMLItem* pNode, Frxexportmatrix::TfrxIEMObject* obj, System::WideString line);
	System::UnicodeString __fastcall GetHeaderText(Frxexportmatrix::TfrxIEMatrix* m);
	System::UnicodeString __fastcall GetFooterText(Frxexportmatrix::TfrxIEMatrix* m);
	void __fastcall CreateStyles();
	System::UnicodeString __fastcall CreateRowStyle(int Row, bool PageBreakBefore);
	void __fastcall SetPictureType(Frximageconverter::TfrxPictureType PT);
	void __fastcall CreateRow(Frxxml::TfrxXMLItem* Node, int Row, bool PageBreak);
	void __fastcall ExportRows(Frxxml::TfrxXMLItem* PageNode, int RowFirst, int RowLast, int PageIndex);
	void __fastcall CreatEmptyCell(Frxxml::TfrxXMLItem* Node);
	void __fastcall CreateAdjacentCell(Frxxml::TfrxXMLItem* Node, int Columns = 0x1);
	void __fastcall CreateDataCell(Frxxml::TfrxXMLItem* Node, Frxexportmatrix::TfrxIEMObject* Obj, int RowsSpanned, int ColsSpanned);
	System::WideString __fastcall AddStyle(System::Uitypes::TColor Color, System::Uitypes::TFontStyles Style);
	bool __fastcall IsRowEmpty(int Row);
	System::UnicodeString __fastcall BuildPageString(Frxexportmatrix::TfrxIEMPage* aPage);
	
protected:
	void __fastcall ExportPage(System::Classes::TStream* Stream);
	
public:
	__fastcall virtual TfrxODFExport(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxODFExport();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	__classmethod System::WideString __fastcall ProcessSpaces(const System::WideString s);
	__classmethod System::WideString __fastcall ProcessTabs(const System::WideString s);
	__classmethod System::WideString __fastcall ProcessControlSymbols(const System::WideString s);
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	__property System::UnicodeString ExportType = {read=FExportType, write=FExportType};
	__property ExportTitle = {default=0};
	
__published:
	__property Frximageconverter::TfrxPictureType PictureType = {read=FPictureType, write=SetPictureType, nodefault};
	__property bool ExportStyles = {read=FExportStyles, write=FExportStyles, default=1};
	__property bool ExportPageBreaks = {read=FExportPageBreaks, write=FExportPageBreaks, default=1};
	__property OpenAfterExport;
	__property bool Wysiwyg = {read=FWysiwyg, write=FWysiwyg, default=1};
	__property bool Background = {read=FBackground, write=FBackground, default=0};
	__property System::UnicodeString Creator = {read=FCreator, write=FCreator};
	__property System::TDateTime CreationTime = {read=FCreationTime, write=FCreationTime};
	__property bool EmptyLines = {read=FEmptyLines, write=FEmptyLines, default=1};
	__property bool SingleSheet = {read=FSingleSheet, write=FSingleSheet, default=1};
	__property System::UnicodeString Language = {read=FLanguage, write=FLanguage};
	__property SuppressPageHeadersFooters;
	__property OverwritePrompt;
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxODFExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	
};


class PASCALIMPLEMENTATION TfrxODSExport : public TfrxODFExport
{
	typedef TfrxODFExport inherited;
	
public:
	__fastcall virtual TfrxODSExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property ExportTitle = {default=0};
	
__published:
	__property ExportStyles = {default=1};
	__property ExportPageBreaks = {default=1};
	__property ShowProgress;
	__property Wysiwyg = {default=1};
	__property Background = {default=0};
	__property Creator = {default=0};
	__property EmptyLines = {default=1};
	__property SuppressPageHeadersFooters;
	__property OverwritePrompt;
	__property PictureType;
public:
	/* TfrxODFExport.Destroy */ inline __fastcall virtual ~TfrxODSExport() { }
	
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxODSExport() : TfrxODFExport() { }
	
};


class PASCALIMPLEMENTATION TfrxODTExport : public TfrxODFExport
{
	typedef TfrxODFExport inherited;
	
public:
	__fastcall virtual TfrxODTExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property ExportStyles = {default=1};
	__property ExportPageBreaks = {default=1};
	__property ShowProgress;
	__property Wysiwyg = {default=1};
	__property Background = {default=0};
	__property Creator = {default=0};
	__property EmptyLines = {default=1};
	__property SuppressPageHeadersFooters;
	__property OverwritePrompt;
	__property PictureType;
public:
	/* TfrxODFExport.Destroy */ inline __fastcall virtual ~TfrxODTExport() { }
	
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxODTExport() : TfrxODFExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportodf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTODF)
using namespace Frxexportodf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportodfHPP
