// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxTransportIndyConnectorHTTP.pas' rev: 33.00 (Windows)

#ifndef FrxtransportindyconnectorhttpHPP
#define FrxtransportindyconnectorhttpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <frxBaseTransportConnection.hpp>
#include <frxTransportIndyConnector.hpp>
#include <IdTCPConnection.hpp>
#include <IdHTTP.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxtransportindyconnectorhttp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxTransportIndyConnectorHTTP;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxTransportIndyConnectorHTTP : public Frxtransportindyconnector::TfrxTransportIndyConnector
{
	typedef Frxtransportindyconnector::TfrxTransportIndyConnector inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProxyHost();
	virtual System::UnicodeString __fastcall GetProxyLogin();
	virtual System::UnicodeString __fastcall GetProxyPassword();
	virtual int __fastcall GetProxyPort();
	virtual void __fastcall SetProxyHost(const System::UnicodeString Value);
	virtual void __fastcall SetProxyLogin(const System::UnicodeString Value);
	virtual void __fastcall SetProxyPassword(const System::UnicodeString Value);
	virtual void __fastcall SetProxyPort(const int Value);
	
public:
	__fastcall virtual TfrxTransportIndyConnectorHTTP(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxTransportIndyConnectorHTTP();
	Idhttp::TIdHTTP* __fastcall GetIdHTTP();
	virtual void __fastcall SetDefaultParametersWithToken(System::UnicodeString AToken);
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall IndyLog(System::UnicodeString LogFileName, Idtcpconnection::TIdTCPConnection* IdTCPConnection);
extern DELPHI_PACKAGE void __fastcall frxTestTokenIndy(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST);
}	/* namespace Frxtransportindyconnectorhttp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXTRANSPORTINDYCONNECTORHTTP)
using namespace Frxtransportindyconnectorhttp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxtransportindyconnectorhttpHPP
