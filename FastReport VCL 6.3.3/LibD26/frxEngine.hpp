// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxEngine.pas' rev: 33.00 (Windows)

#ifndef FrxengineHPP
#define FrxengineHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxClass.hpp>
#include <frxAggregate.hpp>
#include <frxXML.hpp>
#include <frxDMPClass.hpp>
#include <frxStorage.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxengine
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxHeaderListItem;
class DELPHICLASS TfrxShiftEngine;
class DELPHICLASS TfrxHeaderList;
class DELPHICLASS TfrxEngine;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxHeaderListItem : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Frxclass::TfrxBand* Band;
	System::Extended Left;
	bool IsInKeepList;
public:
	/* TObject.Create */ inline __fastcall TfrxHeaderListItem() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxHeaderListItem() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxShiftEngine : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TList* FContainers;
	System::Classes::TList* FDestroyQueue;
	
public:
	__fastcall TfrxShiftEngine();
	__fastcall virtual ~TfrxShiftEngine();
	void __fastcall Clear();
	void __fastcall ClearDestroyQueue();
	void __fastcall ClearContainer(Frxclass::TfrxReportComponent* Container);
	void __fastcall PrepareShiftTree(Frxclass::TfrxReportComponent* Container);
	void __fastcall ShiftObjects(Frxclass::TfrxReportComponent* Container);
	void __fastcall InitShiftAmount(Frxclass::TfrxReportComponent* AObject, System::Extended ShiftAmount);
	void __fastcall ContainerToDestroyQueue(System::TObject* AContainer);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHeaderList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxHeaderListItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Classes::TList* FList;
	int __fastcall GetCount();
	TfrxHeaderListItem* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxHeaderList();
	__fastcall virtual ~TfrxHeaderList();
	void __fastcall Clear();
	void __fastcall AddItem(Frxclass::TfrxBand* ABand, System::Extended ALeft, bool AInKeepList);
	void __fastcall RemoveItem(Frxclass::TfrxBand* ABand);
	__property int Count = {read=GetCount, nodefault};
	__property TfrxHeaderListItem* Items[int Index] = {read=GetItems/*, default*/};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxEngine : public Frxclass::TfrxCustomEngine
{
	typedef Frxclass::TfrxCustomEngine inherited;
	
private:
	Frxaggregate::TfrxAggregateList* FAggregates;
	bool FCallFromAddPage;
	bool FCallFromEndPage;
	Frxclass::TfrxBand* FCurBand;
	Frxclass::TfrxBand* FLastBandOnPage;
	bool FDontShowHeaders;
	TfrxHeaderList* FHeaderList;
	bool FFirstReportPage;
	System::Extended FFirstColumnY;
	bool FIsFirstBand;
	bool FIsFirstPage;
	bool FIsLastPage;
	bool FTitlePrinted;
	System::Classes::TStrings* FHBandNamesTree;
	Frxclass::TfrxBand* FKeepBand;
	bool FKeepFooter;
	bool FKeeping;
	bool FKeepHeader;
	System::Extended FKeepCurY;
	System::Extended FPrevFooterHeight;
	Frxxml::TfrxXMLItem* FKeepOutline;
	int FKeepPosition;
	int FKeepAnchor;
	bool FCallFromPHeader;
	Frxclass::TfrxNullBand* FOutputTo;
	Frxclass::TfrxReportPage* FPage;
	System::Extended FPageCurX;
	Frxclass::TfrxBand* FStartNewPageBand;
	System::Classes::TList* FVHeaderList;
	Frxclass::TfrxBand* FVMasterBand;
	System::Classes::TList* FVPageList;
	int FSubSavePageN;
	System::Extended FSubSaveCurY;
	bool FBreakShowBandTree;
	bool FLockResetAggregates;
	TfrxShiftEngine* FShiftEngine;
	void __fastcall AddBandOutline(Frxclass::TfrxBand* Band);
	void __fastcall AddColumn();
	void __fastcall AddPage();
	void __fastcall AddPageOutline();
	void __fastcall AddToHeaderList(Frxclass::TfrxBand* Band);
	void __fastcall AddToVHeaderList(Frxclass::TfrxBand* Band);
	void __fastcall CheckBandColumns(Frxclass::TfrxDataBand* Band, int ColumnKeepPos, int &HeaderKeepPos, System::Extended SaveCurY, System::Extended SaveHeaderY);
	void __fastcall CheckDrill(Frxclass::TfrxDataBand* Master, Frxclass::TfrxGroupHeader* Band);
	void __fastcall CheckGroups(Frxclass::TfrxDataBand* Master, Frxclass::TfrxGroupHeader* Band, int ColumnKeepPos, System::Extended SaveCurY);
	void __fastcall CheckSubReports(Frxclass::TfrxBand* Band);
	void __fastcall CheckSuppress(Frxclass::TfrxBand* Band);
	void __fastcall DoShow(Frxclass::TfrxBand* Band);
	void __fastcall DrawSplit(Frxclass::TfrxBand* Band);
	void __fastcall EndColumn();
	void __fastcall EndKeep(Frxclass::TfrxBand* Band);
	void __fastcall InitGroups(Frxclass::TfrxDataBand* Master, Frxclass::TfrxGroupHeader* Band, int Index, bool ResetLineN = false);
	void __fastcall InitPage();
	void __fastcall NotifyObjects(Frxclass::TfrxBand* Band);
	void __fastcall OutlineRoot();
	void __fastcall OutlineUp(Frxclass::TfrxBand* Band);
	void __fastcall PreparePage(System::Classes::TStrings* ErrorList, bool PrepareVBands);
	void __fastcall RemoveFromHeaderList(Frxclass::TfrxBand* Band);
	void __fastcall RemoveFromVHeaderList(Frxclass::TfrxBand* Band);
	void __fastcall ResetSuppressValues(Frxclass::TfrxBand* Band);
	void __fastcall RunPage(Frxclass::TfrxReportPage* Page);
	void __fastcall RunReportPages(Frxclass::TfrxReportPage* APage);
	void __fastcall ShowGroupFooters(Frxclass::TfrxGroupHeader* Band, int Index, Frxclass::TfrxDataBand* Master);
	void __fastcall ShowVBands(Frxclass::TfrxBand* HBand);
	void __fastcall StartKeep(Frxclass::TfrxBand* Band, int Position = 0x0);
	bool __fastcall CanShow(System::TObject* Obj, bool PrintIfDetailEmpty);
	Frxclass::TfrxBand* __fastcall FindBand(Frxclass::TfrxBandClass Band);
	bool __fastcall RunDialogs();
	void __fastcall RestoreVBandsObjects();
	
protected:
	virtual System::Extended __fastcall GetPageHeight();
	void __fastcall DoProcessState(Frxclass::TfrxBand* aBand, Frxclass::TfrxProcessAtMode aState);
	
public:
	__fastcall virtual TfrxEngine(Frxclass::TfrxReport* AReport);
	__fastcall virtual ~TfrxEngine();
	virtual void __fastcall EndPage();
	virtual void __fastcall NewColumn();
	virtual void __fastcall NewPage();
	virtual bool __fastcall Run(bool ARunDialogs, bool AClearLast = false, Frxclass::TfrxPage* APage = (Frxclass::TfrxPage*)(0x0));
	virtual Frxclass::TfrxBand* __fastcall ShowBand(Frxclass::TfrxBand* Band)/* overload */;
	virtual void __fastcall ShowBand(Frxclass::TfrxBandClass Band)/* overload */;
	virtual void __fastcall Stretch(Frxclass::TfrxReportComponent* Container);
	virtual void __fastcall UnStretch(Frxclass::TfrxReportComponent* Container);
	virtual System::Extended __fastcall HeaderHeight();
	virtual System::Extended __fastcall FooterHeight();
	virtual System::Extended __fastcall FreeSpace();
	virtual void __fastcall BreakAllKeep();
	virtual void __fastcall PrepareShiftTree(Frxclass::TfrxReportComponent* Container);
	virtual void __fastcall ProcessObject(Frxclass::TfrxView* ReportObject);
	virtual System::Variant __fastcall GetAggregateValue(const System::UnicodeString Name, const System::UnicodeString Expression, Frxclass::TfrxBand* Band, int Flags);
	bool __fastcall Initialize();
	void __fastcall Finalize();
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxengine */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXENGINE)
using namespace Frxengine;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxengineHPP
