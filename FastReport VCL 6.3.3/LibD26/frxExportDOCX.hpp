// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportDOCX.pas' rev: 33.00 (Windows)

#ifndef FrxexportdocxHPP
#define FrxexportdocxHPP

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
#include <frxClass.hpp>
#include <Winapi.ShellAPI.hpp>
#include <frxZip.hpp>
#include <frxExportMatrix.hpp>
#include <frxImageConverter.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportdocx
{
//-- forward type declarations -----------------------------------------------
struct TfrxDocxPage;
class DELPHICLASS TfrxDOCXExport;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TfrxDocxPage
{
public:
	int Width;
	int Height;
	System::Types::TRect Margins;
};


class PASCALIMPLEMENTATION TfrxDOCXExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	System::UnicodeString FDocFolder;
	System::Classes::TStream* FDocument;
	System::Classes::TStream* FDocRels;
	Frxexportmatrix::TfrxIEMatrix* FMatrix;
	TfrxDocxPage FLastPage;
	int FPicNum;
	int FURLNum;
	bool FFirstPage;
	Frximageconverter::TfrxPictureType FPictureType;
	System::UnicodeString __fastcall SubPath(const System::UnicodeString s);
	System::UnicodeString __fastcall SecPr();
	
public:
	__fastcall virtual TfrxDOCXExport(System::Classes::TComponent* Owner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	
__published:
	__property OpenAfterExport;
	__property OverwritePrompt;
	__property Frximageconverter::TfrxPictureType PictureType = {read=FPictureType, write=FPictureType, nodefault};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxDOCXExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxDOCXExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportdocx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTDOCX)
using namespace Frxexportdocx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportdocxHPP
