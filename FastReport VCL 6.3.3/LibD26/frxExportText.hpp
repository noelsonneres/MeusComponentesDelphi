// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportText.pas' rev: 33.00 (Windows)

#ifndef FrxexporttextHPP
#define FrxexporttextHPP

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
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexporttext
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxSimpleTextExport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxSimpleTextExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	bool FPageBreaks;
	Frxexportmatrix::TfrxIEMatrix* FMatrix;
	System::Classes::TStream* Exp;
	Frxclass::TfrxReportPage* FPage;
	bool FFrames;
	System::Extended pX;
	System::Extended pY;
	System::Extended pT;
	bool FEmptyLines;
	bool FOEM;
	bool FDeleteEmptyColumns;
	void __fastcall ExportPage(System::Classes::TStream* Stream);
	
public:
	__fastcall virtual TfrxSimpleTextExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	
__published:
	__property bool PageBreaks = {read=FPageBreaks, write=FPageBreaks, default=1};
	__property bool Frames = {read=FFrames, write=FFrames, nodefault};
	__property bool EmptyLines = {read=FEmptyLines, write=FEmptyLines, nodefault};
	__property bool OEMCodepage = {read=FOEM, write=FOEM, nodefault};
	__property OpenAfterExport;
	__property OverwritePrompt;
	__property bool DeleteEmptyColumns = {read=FDeleteEmptyColumns, write=FDeleteEmptyColumns, nodefault};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxSimpleTextExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxSimpleTextExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexporttext */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTTEXT)
using namespace Frxexporttext;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexporttextHPP
