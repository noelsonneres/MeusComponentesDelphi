// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPreviewPages.pas' rev: 33.00 (Windows)

#ifndef FrxpreviewpagesHPP
#define FrxpreviewpagesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxClass.hpp>
#include <frxXML.hpp>
#include <frxPictureCache.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxpreviewpages
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxOutline;
class DELPHICLASS TfrxDictionary;
class DELPHICLASS TfrxPreviewPages;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxOutline : public Frxclass::TfrxCustomOutline
{
	typedef Frxclass::TfrxCustomOutline inherited;
	
protected:
	virtual int __fastcall GetCount();
	
public:
	Frxxml::TfrxXMLItem* __fastcall Root();
	virtual void __fastcall AddItem(const System::UnicodeString Text, int Top);
	virtual void __fastcall DeleteItems(Frxxml::TfrxXMLItem* From);
	virtual void __fastcall LevelDown(int Index);
	virtual void __fastcall LevelRoot();
	virtual void __fastcall LevelUp();
	virtual void __fastcall GetItem(int Index, System::UnicodeString &Text, int &Page, int &Top);
	virtual void __fastcall ShiftItems(Frxxml::TfrxXMLItem* From, int NewTop);
	virtual Frxxml::TfrxXMLItem* __fastcall GetCurPosition();
public:
	/* TfrxCustomOutline.Create */ inline __fastcall virtual TfrxOutline(Frxclass::TfrxCustomPreviewPages* APreviewPages) : Frxclass::TfrxCustomOutline(APreviewPages) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxOutline() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxDictionary : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TStringList* FNames;
	System::Classes::TStringList* FSourceNames;
	
public:
	__fastcall TfrxDictionary();
	__fastcall virtual ~TfrxDictionary();
	void __fastcall Add(const System::UnicodeString Name, const System::UnicodeString SourceName, System::TObject* Obj);
	void __fastcall Clear();
	System::UnicodeString __fastcall AddUnique(const System::UnicodeString Base, const System::UnicodeString SourceName, System::TObject* Obj);
	System::UnicodeString __fastcall CreateUniqueName(const System::UnicodeString Base);
	System::UnicodeString __fastcall GetSourceName(const System::UnicodeString Name);
	System::TObject* __fastcall GetObject(const System::UnicodeString Name);
	__property System::Classes::TStringList* Names = {read=FNames};
	__property System::Classes::TStringList* SourceNames = {read=FSourceNames};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxPreviewPages : public Frxclass::TfrxCustomPreviewPages
{
	typedef Frxclass::TfrxCustomPreviewPages inherited;
	
private:
	bool FAllowPartialLoading;
	int FCopyNo;
	TfrxDictionary* FDictionary;
	int FFirstObjectIndex;
	int FFirstPageIndex;
	int FFirstOutlineIndex;
	int FLogicalPageN;
	System::Classes::TStringList* FPageCache;
	Frxxml::TfrxXMLItem* FPagesItem;
	Frxpicturecache::TfrxPictureCache* FPictureCache;
	System::Extended FPrintScale;
	System::Classes::TList* FSourcePages;
	System::Classes::TStream* FTempStream;
	Frxxml::TfrxXMLDocument* FXMLDoc;
	int FXMLSize;
	System::Extended FLastY;
	Frxclass::TfrxView* FLastObjectOver;
	Frxclass::TfrxGroupHeader* FLastDrill;
	Frxclass::TfrxReportPage* FLockedPage;
	void __fastcall AfterLoad();
	void __fastcall BeforeSave();
	void __fastcall ClearPageCache();
	void __fastcall ClearSourcePages();
	Frxxml::TfrxXMLItem* __fastcall CurXMLPage();
	Frxclass::TfrxComponent* __fastcall GetObject(const System::UnicodeString Name);
	void __fastcall DoLoadFromStream();
	void __fastcall DoSaveToStream();
	
protected:
	virtual int __fastcall GetCount();
	virtual Frxclass::TfrxReportPage* __fastcall GetPage(int Index);
	virtual System::Types::TPoint __fastcall GetPageSize(int Index);
	
public:
	__fastcall virtual TfrxPreviewPages(Frxclass::TfrxReport* AReport);
	__fastcall virtual ~TfrxPreviewPages();
	virtual void __fastcall Clear();
	virtual void __fastcall Initialize();
	void __fastcall AddAnchor(const System::UnicodeString Text);
	virtual void __fastcall AddObject(Frxclass::TfrxComponent* Obj);
	virtual void __fastcall AddPage(Frxclass::TfrxReportPage* Page);
	virtual void __fastcall AddPicture(Frxclass::TfrxPictureView* Picture);
	virtual void __fastcall AddSourcePage(Frxclass::TfrxReportPage* Page);
	virtual void __fastcall AddToSourcePage(Frxclass::TfrxComponent* Obj);
	virtual void __fastcall BeginPass();
	virtual void __fastcall ClearFirstPassPages();
	virtual void __fastcall CutObjects(int APosition);
	virtual void __fastcall DeleteObjects(int APosition);
	virtual void __fastcall DeleteAnchors(int From);
	virtual void __fastcall Finish();
	virtual void __fastcall IncLogicalPageNumber();
	virtual void __fastcall ResetLogicalPageNumber();
	virtual void __fastcall PasteObjects(System::Extended X, System::Extended Y);
	virtual void __fastcall ShiftAnchors(int From, int NewTop);
	void __fastcall UpdatePageDimensions(Frxclass::TfrxReportPage* Page, System::Extended Width, System::Extended Height);
	void __fastcall UpdatePageDimension(int Index, System::Extended Width, System::Extended Height, System::Uitypes::TPrinterOrientation AOrientation);
	void __fastcall UpdatePageLastColumn(int aColumn, System::Extended aColumnPos, bool aReset = false);
	void __fastcall GetLastColumnPos(int &aColumn, System::Extended &ColumnPos);
	virtual bool __fastcall BandExists(Frxclass::TfrxBand* Band);
	Frxxml::TfrxXMLItem* __fastcall FindAnchor(const System::UnicodeString Text);
	Frxxml::TfrxXMLItem* __fastcall FindAnchorRoot();
	int __fastcall GetAnchorPage(const System::UnicodeString Text);
	virtual int __fastcall GetAnchorCurPosition();
	virtual int __fastcall GetCurPosition();
	virtual System::Extended __fastcall GetLastY(System::Extended ColumnPosition = 0.000000E+00);
	virtual int __fastcall GetLogicalPageNo();
	virtual int __fastcall GetLogicalTotalPages();
	void __fastcall LockPage();
	void __fastcall UnlockPage();
	virtual void __fastcall DrawPage(int Index, Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY, bool bHighlightEditable = false);
	virtual void __fastcall AddEmptyPage(int Index);
	virtual void __fastcall DeletePage(int Index);
	virtual void __fastcall ModifyPage(int Index, Frxclass::TfrxReportPage* Page);
	virtual void __fastcall ModifyObject(Frxclass::TfrxComponent* Component);
	virtual void __fastcall AddFrom(Frxclass::TfrxReport* Report);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* Stream, bool AllowPartialLoading = false);
	virtual bool __fastcall SaveToFilter(Frxclass::TfrxCustomIOTransport* Filter, const System::UnicodeString FileName);
	virtual void __fastcall SaveToStream(System::Classes::TStream* Stream);
	virtual bool __fastcall LoadFromFile(const System::UnicodeString FileName, bool ExceptionIfNotFound = false);
	virtual void __fastcall SaveToFile(const System::UnicodeString FileName);
	virtual bool __fastcall Print();
	virtual bool __fastcall Export(Frxclass::TfrxCustomExportFilter* Filter);
	virtual void __fastcall ObjectOver(int Index, int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, System::Extended Scale, System::Extended OffsetX, System::Extended OffsetY, Frxclass::TfrxPreviewIntEventParams &aEventParams);
	__property System::Classes::TList* SourcePages = {read=FSourcePages};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxpreviewpages */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPREVIEWPAGES)
using namespace Frxpreviewpages;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxpreviewpagesHPP
