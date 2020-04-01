// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_idbrtti.pas' rev: 33.00 (Windows)

#ifndef Fs_idbrttiHPP
#define Fs_idbrttiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <fs_iinterpreter.hpp>
#include <fs_itools.hpp>
#include <fs_iclassesrtti.hpp>
#include <fs_ievents.hpp>
#include <Data.DB.hpp>
#include <System.Types.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fs_idbrtti
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfsDBRTTI;
class DELPHICLASS TfsDatasetNotifyEvent;
class DELPHICLASS TfsFilterRecordEvent;
class DELPHICLASS TfsFieldGetTextEvent;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfsDBRTTI : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfsDBRTTI(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfsDBRTTI() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsDatasetNotifyEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TDataSet* Dataset);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsDatasetNotifyEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsDatasetNotifyEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsFilterRecordEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TDataSet* DataSet, bool &Accept);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsFilterRecordEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsFilterRecordEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsFieldGetTextEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TField* Sender, System::UnicodeString &Text, bool DisplayText);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsFieldGetTextEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsFieldGetTextEvent() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_idbrtti */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_IDBRTTI)
using namespace Fs_idbrtti;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_idbrttiHPP
