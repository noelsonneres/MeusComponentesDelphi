// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxBaseSocketIOHandler.pas' rev: 33.00 (Windows)

#ifndef FrxbasesocketiohandlerHPP
#define FrxbasesocketiohandlerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <System.Win.ScktComp.hpp>
#include <Winapi.WinSock.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxbasesocketiohandler
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCustomIOHandler;
class DELPHICLASS TfrxWinSockIOHandler;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxBaseSockErrors : unsigned char { bseNone, bseSocketErr, bseWantRead, bseWantWrite, bseWantLookup, bseSYSCall, bseZeroRet, bseWantConnect, bseWantAccept, bseWantAsync };

enum DECLSPEC_DENUM TfrxSecurityProtocol : unsigned char { spNone, spSSLv2, spSSLv3, spSSLv23, spTLSv1, spTLSv1_1, spTLSv1_2 };

typedef System::Set<TfrxSecurityProtocol, TfrxSecurityProtocol::spNone, TfrxSecurityProtocol::spTLSv1_2> TfrxSecurityProtocols;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCustomIOHandler : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int FLastError;
	char *FBuffer;
	int FBuffSize;
	System::Classes::TMemoryStream* FStream;
	bool FConnected;
	TfrxSecurityProtocol FSecurityProtocol;
	virtual int __fastcall DoRead(void *Buffer, int Count) = 0 ;
	virtual int __fastcall DoWrite(void *Buffer, int Count) = 0 ;
	virtual int __fastcall GetErrorCode(int ErrCode) = 0 ;
	virtual void __fastcall SetSecurityProtocol(const TfrxSecurityProtocol Value);
	
public:
	__fastcall virtual TfrxCustomIOHandler();
	__fastcall virtual ~TfrxCustomIOHandler();
	virtual System::UnicodeString __fastcall GetLastError();
	virtual bool __fastcall InitializeHandler();
	virtual void __fastcall BindSocket(System::Win::Scktcomp::TCustomWinSocket* Socket);
	virtual bool __fastcall TryConnect();
	virtual void __fastcall Disconnect();
	virtual bool __fastcall Read(System::Classes::TStream* Stream);
	virtual bool __fastcall Write(System::Classes::TStream* Stream);
	virtual bool __fastcall ProcessIO();
	virtual void __fastcall RunIO();
	virtual TfrxSecurityProtocols __fastcall SupportedSecurityProtocol();
	__property TfrxSecurityProtocol SecurityProtocol = {read=FSecurityProtocol, write=SetSecurityProtocol, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxWinSockIOHandler : public TfrxCustomIOHandler
{
	typedef TfrxCustomIOHandler inherited;
	
private:
	System::Win::Scktcomp::TCustomWinSocket* FWinSock;
	
protected:
	virtual int __fastcall DoRead(void *Buffer, int Count);
	virtual int __fastcall DoWrite(void *Buffer, int Count);
	virtual int __fastcall GetErrorCode(int ErrCode);
	
public:
	__fastcall virtual TfrxWinSockIOHandler();
	__fastcall virtual ~TfrxWinSockIOHandler();
	virtual void __fastcall BindSocket(System::Win::Scktcomp::TCustomWinSocket* Socket);
	void __fastcall Connect();
	virtual bool __fastcall TryConnect();
	virtual void __fastcall Disconnect();
	virtual bool __fastcall ProcessIO();
};

#pragma pack(pop)

typedef System::TMetaClass* TfrxCustomIOHandlerClass;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxCustomIOHandlerClass frxDefaultSocketIOHandlerClass;
}	/* namespace Frxbasesocketiohandler */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXBASESOCKETIOHANDLER)
using namespace Frxbasesocketiohandler;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxbasesocketiohandlerHPP
