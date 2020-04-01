// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportCSV.pas' rev: 33.00 (Windows)

#ifndef FrxexportcsvHPP
#define FrxexportcsvHPP

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
#include <frxExportMatrix.hpp>
#include <frxExportBaseDialog.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportcsv
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCSVExport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxCSVExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	Frxexportmatrix::TfrxIEMatrix* FMatrix;
	System::Classes::TStream* Exp;
	Frxclass::TfrxReportPage* FPage;
	bool FOEM;
	bool FUTF8;
	System::UnicodeString FSeparator;
	bool FNoSysSymbols;
	bool FForcedQuotes;
	void __fastcall ExportPage(System::Classes::TStream* Stream);
	
public:
	__fastcall virtual TfrxCSVExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	
__published:
	__property System::UnicodeString Separator = {read=FSeparator, write=FSeparator};
	__property bool OEMCodepage = {read=FOEM, write=FOEM, nodefault};
	__property bool UTF8 = {read=FUTF8, write=FUTF8, nodefault};
	__property OpenAfterExport;
	__property OverwritePrompt;
	__property bool NoSysSymbols = {read=FNoSysSymbols, write=FNoSysSymbols, nodefault};
	__property bool ForcedQuotes = {read=FForcedQuotes, write=FForcedQuotes, nodefault};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxCSVExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxCSVExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportcsv */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTCSV)
using namespace Frxexportcsv;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportcsvHPP
