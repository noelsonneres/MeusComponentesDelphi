// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportImage.pas' rev: 33.00 (Windows)

#ifndef FrxexportimageHPP
#define FrxexportimageHPP

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
#include <frxExportBaseDialog.hpp>
#include <Vcl.Imaging.jpeg.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxexportimage
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCustomImageExport;
class DELPHICLASS TfrxEMFExport;
class DELPHICLASS TfrxBMPExport;
class DELPHICLASS TfrxTIFFExport;
class DELPHICLASS TfrxJPEGExport;
class DELPHICLASS TfrxGIFExport;
class DELPHICLASS TfrxPNGExport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxCustomImageExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	Vcl::Graphics::TBitmap* FBitmap;
	bool FCrop;
	int FCurrentPage;
	int FJPEGQuality;
	int FMaxX;
	int FMaxY;
	int FMinX;
	int FMinY;
	bool FMonochrome;
	int FResolution;
	int FCurrentRes;
	bool FSeparate;
	int FYOffset;
	System::UnicodeString FFileSuffix;
	bool FFirstPage;
	bool FExportNotPrintable;
	bool __fastcall SizeOverflow(const System::Extended Val);
	
protected:
	double FPaperWidth;
	double FPaperHeight;
	System::Extended FDiv;
	void __fastcall Save();
	virtual void __fastcall SaveToStream(System::Classes::TStream* const aStream);
	virtual void __fastcall FinishExport();
	
public:
	__fastcall virtual TfrxCustomImageExport(System::Classes::TComponent* AOwner);
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	virtual bool __fastcall IsProcessInternal();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	__property int JPEGQuality = {read=FJPEGQuality, write=FJPEGQuality, default=90};
	__property bool CropImages = {read=FCrop, write=FCrop, default=0};
	__property bool Monochrome = {read=FMonochrome, write=FMonochrome, default=0};
	__property int Resolution = {read=FResolution, write=FResolution, nodefault};
	__property bool SeparateFiles = {read=FSeparate, write=FSeparate, nodefault};
	__property bool ExportNotPrintable = {read=FExportNotPrintable, write=FExportNotPrintable, nodefault};
	__property OverwritePrompt;
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxCustomImageExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxCustomImageExport() { }
	
};


class PASCALIMPLEMENTATION TfrxEMFExport : public TfrxCustomImageExport
{
	typedef TfrxCustomImageExport inherited;
	
private:
	Vcl::Graphics::TMetafile* FMetafile;
	Vcl::Graphics::TMetafileCanvas* FMetafileCanvas;
	
protected:
	virtual void __fastcall FinishExport();
	virtual void __fastcall SaveToStream(System::Classes::TStream* const aStream);
	
public:
	virtual bool __fastcall Start();
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	__fastcall virtual TfrxEMFExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property CropImages = {default=0};
	__property OverwritePrompt;
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxEMFExport() : TfrxCustomImageExport() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxEMFExport() { }
	
};


class PASCALIMPLEMENTATION TfrxBMPExport : public TfrxCustomImageExport
{
	typedef TfrxCustomImageExport inherited;
	
protected:
	virtual void __fastcall SaveToStream(System::Classes::TStream* const aStream);
	
public:
	__fastcall virtual TfrxBMPExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property CropImages = {default=0};
	__property Monochrome = {default=0};
	__property OverwritePrompt;
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxBMPExport() : TfrxCustomImageExport() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxBMPExport() { }
	
};


class PASCALIMPLEMENTATION TfrxTIFFExport : public TfrxCustomImageExport
{
	typedef TfrxCustomImageExport inherited;
	
private:
	bool FMultiImage;
	bool FIsStreamCreated;
	void __fastcall SaveTiffToStream(System::Classes::TStream* const Stream, Vcl::Graphics::TBitmap* const Bitmap, bool Split, bool WriteHeader = true);
	
protected:
	virtual void __fastcall SaveToStream(System::Classes::TStream* const aStream);
	
public:
	__fastcall virtual TfrxTIFFExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall Start();
	virtual void __fastcall Finish();
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	
__published:
	__property CropImages = {default=0};
	__property Monochrome = {default=0};
	__property OverwritePrompt;
	__property bool MultiImage = {read=FMultiImage, write=FMultiImage, default=0};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxTIFFExport() : TfrxCustomImageExport() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxTIFFExport() { }
	
};


class PASCALIMPLEMENTATION TfrxJPEGExport : public TfrxCustomImageExport
{
	typedef TfrxCustomImageExport inherited;
	
protected:
	virtual void __fastcall SaveToStream(System::Classes::TStream* const aStream);
	
public:
	__fastcall virtual TfrxJPEGExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property JPEGQuality = {default=90};
	__property CropImages = {default=0};
	__property Monochrome = {default=0};
	__property OverwritePrompt;
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxJPEGExport() : TfrxCustomImageExport() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxJPEGExport() { }
	
};


class PASCALIMPLEMENTATION TfrxGIFExport : public TfrxCustomImageExport
{
	typedef TfrxCustomImageExport inherited;
	
protected:
	virtual void __fastcall SaveToStream(System::Classes::TStream* const aStream);
	
public:
	__fastcall virtual TfrxGIFExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property CropImages = {default=0};
	__property Monochrome = {default=0};
	__property OverwritePrompt;
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxGIFExport() : TfrxCustomImageExport() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxGIFExport() { }
	
};


class PASCALIMPLEMENTATION TfrxPNGExport : public TfrxCustomImageExport
{
	typedef TfrxCustomImageExport inherited;
	
protected:
	virtual void __fastcall SaveToStream(System::Classes::TStream* const aStream);
	
public:
	__fastcall virtual TfrxPNGExport(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property CropImages = {default=0};
	__property Monochrome = {default=0};
	__property OverwritePrompt;
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxPNGExport() : TfrxCustomImageExport() { }
	/* TfrxCustomExportFilter.Destroy */ inline __fastcall virtual ~TfrxPNGExport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall GIFSaveToFile(const System::UnicodeString FileName, Vcl::Graphics::TBitmap* const Bitmap);
}	/* namespace Frxexportimage */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTIMAGE)
using namespace Frxexportimage;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportimageHPP
