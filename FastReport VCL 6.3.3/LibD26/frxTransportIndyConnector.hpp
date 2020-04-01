// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxTransportIndyConnector.pas' rev: 33.00 (Windows)

#ifndef FrxtransportindyconnectorHPP
#define FrxtransportindyconnectorHPP

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
#include <frxBaseTransportConnection.hpp>
#include <IdComponent.hpp>
#include <IdTCPConnection.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxtransportindyconnector
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxTransportIndyConnector;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxTransportIndyConnector : public Frxbasetransportconnection::TfrxBaseTransportConnection
{
	typedef Frxbasetransportconnection::TfrxBaseTransportConnection inherited;
	
private:
	void __fastcall SetIdConnection(Idtcpconnection::TIdTCPConnection* const Value);
	void __fastcall ConnectionWorkBegin(System::TObject* Sender, Idcomponent::TWorkMode AWorkMode, __int64 AWorkCount);
	void __fastcall ConnectionWork(System::TObject* Sender, Idcomponent::TWorkMode AWorkMode, __int64 AWorkCount);
	
protected:
	Idtcpconnection::TIdTCPConnection* FIdConnection;
	
public:
	__fastcall virtual TfrxTransportIndyConnector(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxTransportIndyConnector();
	virtual void __fastcall Connect();
	virtual void __fastcall Disconnect();
	__property Idtcpconnection::TIdTCPConnection* IdConnection = {read=FIdConnection, write=SetIdConnection};
	
__published:
	__property ProxyHost = {default=0};
	__property ProxyPort;
	__property ProxyLogin = {default=0};
	__property ProxyPassword = {default=0};
	__property OnWork;
	__property OnWorkBegin;
	__property OnWorkEnd;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxtransportindyconnector */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXTRANSPORTINDYCONNECTOR)
using namespace Frxtransportindyconnector;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxtransportindyconnectorHPP
