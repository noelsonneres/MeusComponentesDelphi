// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_ievents.pas' rev: 33.00 (Windows)

#ifndef Fs_ieventsHPP
#define Fs_ieventsHPP

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
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fs_ievents
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfsNotifyEvent;
class DELPHICLASS TfsMouseEvent;
class DELPHICLASS TfsMouseMoveEvent;
class DELPHICLASS TfsKeyEvent;
class DELPHICLASS TfsKeyPressEvent;
class DELPHICLASS TfsCloseEvent;
class DELPHICLASS TfsCloseQueryEvent;
class DELPHICLASS TfsCanResizeEvent;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsNotifyEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsNotifyEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsNotifyEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsMouseEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsMouseEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsMouseEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsMouseMoveEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsMouseMoveEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsMouseMoveEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsKeyEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsKeyEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsKeyEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsKeyPressEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::WideChar &Key);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsKeyPressEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsKeyPressEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsCloseEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsCloseEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsCloseEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsCloseQueryEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, bool &CanClose);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsCloseQueryEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsCloseQueryEvent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsCanResizeEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, int &NewWidth, int &NewHeight, bool &Resize);
	virtual void * __fastcall GetMethod();
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsCanResizeEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsCanResizeEvent() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_ievents */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_IEVENTS)
using namespace Fs_ievents;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_ieventsHPP
