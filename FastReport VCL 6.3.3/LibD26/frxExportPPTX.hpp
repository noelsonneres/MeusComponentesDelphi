// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportPPTX.pas' rev: 33.00 (Windows)

#ifndef FrxexportpptxHPP
#define FrxexportpptxHPP

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
#include <Vcl.ComCtrls.hpp>
#include <frxZip.hpp>
#include <frxImageConverter.hpp>
#include <frxExportBaseDialog.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportpptx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPPTXExport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxPPTXExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	System::UnicodeString FDocFolder;
	System::Classes::TStream* FContentTypes;
	System::Classes::TStream* FPresentation;
	System::Classes::TStream* FPresentationRels;
	System::Classes::TStream* FRels;
	System::Classes::TStream* FSlide;
	System::Classes::TStream* FSlideRels;
	int FSlideId;
	int FObjectId;
	Frxclass::TfrxReportPage* FPage;
	int FWidth;
	int FHeight;
	Frximageconverter::TfrxPictureType FPictureType;
	System::UnicodeString __fastcall SubPath(const System::UnicodeString s);
	void __fastcall AddTextBox(Frxclass::TfrxCustomMemoView* Obj);
	void __fastcall AddLine(Frxclass::TfrxFrameLine* Line, int x, int y, int dx, int dy);
	void __fastcall AddPicture(Frxclass::TfrxView* Obj);
	System::Types::TRect __fastcall GetObjRect(Frxclass::TfrxView* Obj);
	
public:
	__fastcall virtual TfrxPPTXExport(System::Classes::TComponent* Owner);
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
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxPPTXExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxPPTXExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxexportpptx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTPPTX)
using namespace Frxexportpptx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportpptxHPP
