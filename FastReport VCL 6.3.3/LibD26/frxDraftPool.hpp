// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDraftPool.pas' rev: 33.00 (Windows)

#ifndef FrxdraftpoolHPP
#define FrxdraftpoolHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <frxStorage.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdraftpool
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TDpDraftPool;
class DELPHICLASS TDpThread;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TDpProcessRoutine)(System::TObject* Draft);

class PASCALIMPLEMENTATION TDpDraftPool : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Frxstorage::TObjList* Sheets;
	int DraftSheets;
	NativeUInt EvNoDraftSheets;
	_RTL_CRITICAL_SECTION CsSheets;
	_RTL_CRITICAL_SECTION CsDraftSheets;
	Frxstorage::TObjList* Threads;
	TDpProcessRoutine DraftProcess;
	void __fastcall LockSheets();
	void __fastcall UnlockSheets();
	void __fastcall LockDraftSheets();
	void __fastcall UnlockDraftSheets();
	void __fastcall AddDraft(System::TObject* Draft);
	void __fastcall DraftProcessed();
	void __fastcall WaitForThreads();
	__fastcall TDpDraftPool(int ThreadsCount, int SheetsCount, TDpProcessRoutine DraftProcRoutine);
	__fastcall virtual ~TDpDraftPool();
};


class PASCALIMPLEMENTATION TDpThread : public System::Classes::TThread
{
	typedef System::Classes::TThread inherited;
	
private:
	System::Classes::TList* FDraftSheets;
	NativeUInt FEvNewDraft;
	TDpDraftPool* FPool;
	_RTL_CRITICAL_SECTION FCsDraftSheets;
	int FActiveDrafts;
	void __fastcall LockDrafts();
	void __fastcall UnlockDrafts();
	
public:
	int ProcessedDrafts;
	int MaxQueueLength;
	__fastcall TDpThread(TDpDraftPool* Pool);
	__fastcall virtual ~TDpThread();
	void __fastcall ForceStart();
	void __fastcall PushDraft(System::TObject* Draft);
	System::TObject* __fastcall PopDraft();
	virtual void __fastcall Execute();
	__property int ActiveDrafts = {read=FActiveDrafts, write=FActiveDrafts, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxdraftpool */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDRAFTPOOL)
using namespace Frxdraftpool;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdraftpoolHPP
