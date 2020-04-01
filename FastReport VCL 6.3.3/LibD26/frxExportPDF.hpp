// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxExportPDF.pas' rev: 33.00 (Windows)

#ifndef FrxexportpdfHPP
#define FrxexportpdfHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <System.Win.ComObj.hpp>
#include <Vcl.Printers.hpp>
#include <Vcl.Imaging.jpeg.hpp>
#include <System.Variants.hpp>
#include <System.Contnrs.hpp>
#include <frxExportBaseDialog.hpp>
#include <frxClass.hpp>
#include <frxExportPDFHelpers.hpp>
#include <frxVectorCanvas.hpp>
#include <System.WideStrings.hpp>
#include <System.AnsiStrings.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------
#pragma link "usp10.lib"

namespace Frxexportpdf
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPDFOutlineNode;
class DELPHICLASS TfrxPDFPage;
class DELPHICLASS TfrxPDFAnnot;
class DELPHICLASS TfrxPDFExport;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxPDFEncBit : unsigned char { ePrint, eModify, eCopy, eAnnot };

typedef System::Set<TfrxPDFEncBit, TfrxPDFEncBit::ePrint, TfrxPDFEncBit::eAnnot> TfrxPDFEncBits;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPDFOutlineNode : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	int Number;
	int Dest;
	int Top;
	int CountTree;
	int Count;
	System::UnicodeString Title;
	TfrxPDFOutlineNode* First;
	TfrxPDFOutlineNode* Last;
	TfrxPDFOutlineNode* Next;
	TfrxPDFOutlineNode* Prev;
	TfrxPDFOutlineNode* Parent;
	__fastcall TfrxPDFOutlineNode();
	__fastcall virtual ~TfrxPDFOutlineNode();
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxPDFPage : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	double Height;
	bool BackPictureVisible;
public:
	/* TObject.Create */ inline __fastcall TfrxPDFPage() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxPDFPage() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPDFAnnot : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	int Number;
	System::UnicodeString Rect;
	System::UnicodeString Hyperlink;
	int DestPage;
	int DestY;
public:
	/* TObject.Create */ inline __fastcall TfrxPDFAnnot() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxPDFAnnot() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TEmbeddedRelation : unsigned char { erData, erSource, erAlternative, erSupplement, erUnspecified };

enum DECLSPEC_DENUM TZUGFeRD_ConformanceLevel : unsigned char { clBASIC, clCOMFORT, clEXTENDED };

class PASCALIMPLEMENTATION TfrxPDFExport : public Frxexportbasedialog::TfrxBaseDialogExportFilter
{
	typedef Frxexportbasedialog::TfrxBaseDialogExportFilter inherited;
	
private:
	bool FCompressed;
	bool FEmbeddedFonts;
	bool FEmbedProt;
	bool FPrintOpt;
	System::Classes::TList* FPages;
	bool FOutline;
	int FQuality;
	Frxclass::TfrxCustomOutline* FPreviewOutline;
	System::WideString FSubject;
	System::WideString FAuthor;
	bool FBackground;
	System::WideString FCreator;
	bool FTags;
	bool FProtection;
	System::AnsiString FUserPassword;
	System::AnsiString FOwnerPassword;
	TfrxPDFEncBits FProtectionFlags;
	System::WideString FKeywords;
	System::WideString FTitle;
	System::WideString FProducer;
	bool FPrintScaling;
	bool FFitWindow;
	bool FHideMenubar;
	bool FCenterWindow;
	bool FHideWindowUI;
	bool FHideToolbar;
	bool FTransparency;
	bool FSaveOriginalImages;
	System::Classes::TStream* pdf;
	int FRootNumber;
	int FPagesNumber;
	int FInfoNumber;
	int FStartXRef;
	Frxexportpdfhelpers::TPDFObjectsHelper* FPOH;
	System::Classes::TStringList* FPagesRef;
	System::Extended FWidth;
	System::Extended FHeight;
	System::Extended FMarginLeft;
	System::Extended FMarginTop;
	System::AnsiString FEncKey;
	System::AnsiString FOPass;
	System::AnsiString FUPass;
	unsigned FEncBits;
	System::AnsiString FFileID;
	System::Uitypes::TColor FLastColor;
	System::UnicodeString FLastColorResult;
	System::Classes::TMemoryStream* OutStream;
	System::Classes::TMemoryStream* FPageAnnots;
	System::Classes::TList* FAnnots;
	int FMetaFileId;
	int FStructId;
	int FColorProfileId;
	int FAttachmentsNamesId;
	int FAttachmentsListId;
	int FPDFviaEMF;
	bool FPdfA;
	Frxexportpdfhelpers::TPDFStandard FPDFStandard;
	Frxexportpdfhelpers::TPDFVersion FPDFVersion;
	bool FUsePNGAlpha;
	System::UnicodeString __fastcall GetPDFDash(const Frxclass::TfrxFrameStyle LineStyle, System::Extended Width);
	System::AnsiString __fastcall GetID();
	System::AnsiString __fastcall CryptStr(System::AnsiString Source, System::AnsiString Key, bool Enc, int id);
	System::AnsiString __fastcall PrepareString(const System::WideString Text, System::AnsiString Key, bool Enc, int id);
	System::AnsiString __fastcall EscapeSpecialChar(System::AnsiString TextStr);
	System::AnsiString __fastcall StrToUTF16(const System::WideString Value);
	System::AnsiString __fastcall StrToUTF16H(const System::WideString Value);
	System::AnsiString __fastcall PMD52Str(void * p);
	System::AnsiString __fastcall PadPassword(System::AnsiString Password);
	void __fastcall PrepareKeys();
	void __fastcall SetProtectionFlags(const TfrxPDFEncBits Value);
	void __fastcall Clear();
	void __fastcall WriteFont(Frxexportpdfhelpers::TfrxPDFFont* pdfFont);
	void __fastcall AddObject(Frxclass::TfrxView* const Obj);
	void __fastcall AddMemo(Frxclass::TfrxCustomMemoView* const Memo);
	void __fastcall AddLine(Frxclass::TfrxCustomLineView* const Line);
	void __fastcall AddShape(Frxclass::TfrxShapeView* const Shape);
	void __fastcall AddCheckBox(Frxclass::TfrxView* const Obj);
	void __fastcall AddViaEMF(Frxclass::TfrxView* const Obj);
	void __fastcall AddAsPicture(Frxclass::TfrxView* const Obj);
	void __fastcall CreateColorMask(Frxclass::TfrxView* Obj, System::Uitypes::TColor TransparentColorMask, System::Extended Scale, const System::Types::TPoint &Offset, Vcl::Graphics::TBitmap* TempBitmap, Frxexportpdfhelpers::TMaskArray &MaskBytes);
	void __fastcall CreatePNGMask(Frxclass::TfrxPictureView* PictObj, System::Extended Scale, const System::Types::TPoint &Offset, Vcl::Graphics::TBitmap* TempBitmap, Frxexportpdfhelpers::TMaskArray &MaskBytes);
	TfrxPDFPage* __fastcall AddPage(Frxclass::TfrxReportPage* Page);
	System::UnicodeString __fastcall GetPDFColor(const System::Uitypes::TColor Color);
	void __fastcall AddAttachments();
	void __fastcall AddEmbeddedFileItem(System::TObject* EmbeddedFile);
	void __fastcall AddStructure();
	void __fastcall AddMetaData();
	void __fastcall AddColorProfile();
	void __fastcall WritePDFStream(System::Classes::TStream* Target, System::Classes::TStream* Source, int id, bool Compressed, bool Encrypted, bool startingBrackets, bool endingBrackets, bool enableLength2);
	void __fastcall SetEmbeddedFonts(const bool Value);
	Frxclass::TfrxRect __fastcall GetRect(Frxclass::TfrxView* Obj);
	Frxclass::TfrxRect __fastcall GetClipRect(Frxclass::TfrxView* Obj, bool Internal = false);
	Frxclass::TfrxRect __fastcall GetDMPRect(const Frxclass::TfrxRect &R);
	Frxclass::TfrxRect __fastcall GetRectEMFExport(Frxclass::TfrxView* Obj);
	void __fastcall Cmd(const System::UnicodeString Args);
	void __fastcall Cmd_ObjPath(Frxclass::TfrxView* Obj);
	void __fastcall Cmd_RoundRectanglePath(Frxclass::TfrxShapeView* RoundedRect);
	void __fastcall Cmd_EllipsePath(Frxclass::TfrxShapeView* Ellipse);
	void __fastcall Cmd_TrianglePath(Frxclass::TfrxShapeView* Triangle);
	void __fastcall Cmd_DiamondPath(Frxclass::TfrxShapeView* Diamond);
	void __fastcall Cmd_ClipObj(Frxclass::TfrxView* Obj);
	void __fastcall Cmd_FillObj(Frxclass::TfrxView* Obj, System::Uitypes::TColor Color);
	void __fastcall Cmd_FillBrush(Frxclass::TfrxView* Obj, Frxclass::TfrxBrushFill* BrushFill);
	void __fastcall Cmd_FillGlass(Frxclass::TfrxView* Obj, Frxclass::TfrxGlassFill* GlassFill);
	void __fastcall Cmd_FillGradient(Frxclass::TfrxView* Obj, Frxclass::TfrxGradientFill* GradientFill);
	void __fastcall Cmd_Hatch(Frxclass::TfrxView* Obj, System::Uitypes::TColor Color, Vcl::Graphics::TBrushStyle Style);
	void __fastcall Cmd_ClipRect(Frxclass::TfrxView* Obj);
	Frxexportpdfhelpers::TfrxPDFFont* __fastcall Cmd_Font(Frxclass::TfrxView* Obj);
	void __fastcall CmdMoveTo(System::Extended x, System::Extended y);
	void __fastcall CmdLineTo(System::Extended x, System::Extended y);
	void __fastcall CmdCurveTo(System::Extended x1, System::Extended y1, System::Extended x2, System::Extended y2, System::Extended x3, System::Extended y3);
	void __fastcall CmdFillColor(System::Uitypes::TColor Color);
	void __fastcall CmdStrokeColor(System::Uitypes::TColor Color);
	void __fastcall CmdStroke();
	void __fastcall CmdLineWidth(System::Extended Value);
	System::Extended __fastcall pdfX(System::Extended x);
	System::Extended __fastcall pdfY(System::Extended y);
	System::Extended __fastcall pdfSize(System::Extended Size);
	Frxclass::TfrxPoint __fastcall pdfPoint(System::Extended x, System::Extended y);
	void __fastcall SetPDFStandard(const Frxexportpdfhelpers::TPDFStandard Value);
	void __fastcall SetPDFVersion(const Frxexportpdfhelpers::TPDFVersion Value);
	void __fastcall SetTransparency(const bool Value);
	void __fastcall SetPdfA(const bool Value);
	
protected:
	Frxclass::TfrxRect FPageRect;
	System::UnicodeString stLeft;
	System::UnicodeString stRight;
	System::UnicodeString stTop;
	System::UnicodeString stBottom;
	System::Contnrs::TObjectList* FEmbeddedFiles;
	System::UnicodeString FZUGFeRDDescription;
	System::TDateTime FCreationDateTime;
	bool __fastcall IsHasHTMLTags(Frxclass::TfrxCustomMemoView* const MemoView);
	bool __fastcall IsAddViaEMF(Frxclass::TfrxView* const Obj);
	void __fastcall AddAsPictureOld(Frxclass::TfrxView* const Obj);
	void __fastcall DoFill(Frxclass::TfrxView* const Obj);
	void __fastcall DoFrame(Frxclass::TfrxFrame* const aFrame, const Frxclass::TfrxRect &aRect);
	System::UnicodeString __fastcall STpdfPoint(System::Extended x, System::Extended y);
	System::UnicodeString __fastcall STpdfSize(System::Extended Size);
	System::UnicodeString __fastcall STpdfRect(System::Extended x, System::Extended y, System::Extended Width, System::Extended Height);
	void __fastcall ExportViaVector(Frxclass::TfrxCustomMemoView* const Memo);
	void __fastcall Vector_ExtTextOut(Frxclass::TfrxCustomMemoView* Memo, Frxvectorcanvas::TVector_ExtTextOut* Vector);
	
public:
	__fastcall virtual TfrxPDFExport(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxPDFExport();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__classmethod virtual Frxexportbasedialog::TfrxBaseExportDialogClass __fastcall ExportDialogClass();
	virtual bool __fastcall Start();
	virtual void __fastcall ExportObject(Frxclass::TfrxComponent* Obj);
	virtual void __fastcall Finish();
	virtual void __fastcall StartPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall FinishPage(Frxclass::TfrxReportPage* Page, int Index);
	virtual void __fastcall BeginClip(Frxclass::TfrxView* Obj);
	virtual void __fastcall EndClip();
	void __fastcall AddEmbeddedFile(System::UnicodeString Name, System::UnicodeString Description, System::TDateTime ModDate, TEmbeddedRelation Relation, System::UnicodeString MIME, System::Classes::TStream* FileStream);
	void __fastcall AddEmbeddedXML(System::UnicodeString Name, System::UnicodeString Description, System::TDateTime ModDate, System::Classes::TStream* FileStream, TZUGFeRD_ConformanceLevel ZUGFeRDLevel = (TZUGFeRD_ConformanceLevel)(0x0));
	bool __fastcall IsPDFA();
	bool __fastcall IsPDFA_1();
	__property bool SaveOriginalImages = {read=FSaveOriginalImages, write=FSaveOriginalImages, nodefault};
	__property bool UsePNGAlpha = {read=FUsePNGAlpha, write=FUsePNGAlpha, nodefault};
	
__published:
	__property bool Compressed = {read=FCompressed, write=FCompressed, default=1};
	__property bool EmbeddedFonts = {read=FEmbeddedFonts, write=SetEmbeddedFonts, default=0};
	__property bool EmbedFontsIfProtected = {read=FEmbedProt, write=FEmbedProt, default=1};
	__property OpenAfterExport;
	__property bool PrintOptimized = {read=FPrintOpt, write=FPrintOpt, nodefault};
	__property bool Outline = {read=FOutline, write=FOutline, nodefault};
	__property bool Background = {read=FBackground, write=FBackground, nodefault};
	__property bool HTMLTags = {read=FTags, write=FTags, nodefault};
	__property OverwritePrompt;
	__property int Quality = {read=FQuality, write=FQuality, nodefault};
	__property bool Transparency = {read=FTransparency, write=SetTransparency, nodefault};
	__property System::WideString Title = {read=FTitle, write=FTitle};
	__property System::WideString Author = {read=FAuthor, write=FAuthor};
	__property System::WideString Subject = {read=FSubject, write=FSubject};
	__property System::WideString Keywords = {read=FKeywords, write=FKeywords};
	__property System::WideString Creator = {read=FCreator, write=FCreator};
	__property System::WideString Producer = {read=FProducer, write=FProducer};
	__property System::AnsiString UserPassword = {read=FUserPassword, write=FUserPassword};
	__property System::AnsiString OwnerPassword = {read=FOwnerPassword, write=FOwnerPassword};
	__property TfrxPDFEncBits ProtectionFlags = {read=FProtectionFlags, write=SetProtectionFlags, nodefault};
	__property bool HideToolbar = {read=FHideToolbar, write=FHideToolbar, nodefault};
	__property bool HideMenubar = {read=FHideMenubar, write=FHideMenubar, nodefault};
	__property bool HideWindowUI = {read=FHideWindowUI, write=FHideWindowUI, nodefault};
	__property bool FitWindow = {read=FFitWindow, write=FFitWindow, nodefault};
	__property bool CenterWindow = {read=FCenterWindow, write=FCenterWindow, nodefault};
	__property bool PrintScaling = {read=FPrintScaling, write=FPrintScaling, nodefault};
	__property bool PdfA = {read=FPdfA, write=SetPdfA, nodefault};
	__property Frxexportpdfhelpers::TPDFStandard PDFStandard = {read=FPDFStandard, write=SetPDFStandard, nodefault};
	__property Frxexportpdfhelpers::TPDFVersion PDFVersion = {read=FPDFVersion, write=SetPDFVersion, nodefault};
public:
	/* TfrxCustomExportFilter.CreateNoRegister */ inline __fastcall TfrxPDFExport() : Frxexportbasedialog::TfrxBaseDialogExportFilter() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfSetLineColor(System::Uitypes::TColor Color);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfSetLineWidth(double Width);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfStrokeRect(const Frxclass::TfrxRect &R, System::Uitypes::TColor Color, System::Extended LineWidth);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfFillRect(const Frxclass::TfrxRect &R, System::Uitypes::TColor Color);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfSetColor(System::Uitypes::TColor Color);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfStroke(void);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfFill(void);
extern DELPHI_PACKAGE System::AnsiString __fastcall pdfPoint(double x, double y);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfLine(double x, double y);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfMove(double x, double y);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfColor(System::Uitypes::TColor Color);
extern DELPHI_PACKAGE System::AnsiString __fastcall PdfString(const System::WideString Str);
}	/* namespace Frxexportpdf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXEXPORTPDF)
using namespace Frxexportpdf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxexportpdfHPP
