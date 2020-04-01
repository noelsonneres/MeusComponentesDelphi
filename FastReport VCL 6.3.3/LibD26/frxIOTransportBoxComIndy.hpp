// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportBoxComIndy.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportboxcomindyHPP
#define FrxiotransportboxcomindyHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <frxIOTransportHelpers.hpp>
#include <frxIOTransportBoxComBase.hpp>
#include <frxBaseTransportConnection.hpp>
#include <IdHTTP.hpp>
#include <IdComponent.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportboxcomindy
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBoxComIOTransportIndy;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBoxComIOTransportIndy : public Frxiotransportboxcombase::TfrxBaseBoxComIOTransport
{
	typedef Frxiotransportboxcombase::TfrxBaseBoxComIOTransport inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetListFolder();
	virtual System::UnicodeString __fastcall GetListFolderContinue(int Offset);
	virtual void __fastcall CreateFolder(System::UnicodeString Dir);
	virtual void __fastcall DeleteFile(System::UnicodeString Id);
	virtual void __fastcall DeleteFolder(System::UnicodeString Id);
	virtual void __fastcall Upload(System::Classes::TStream* const Source, System::UnicodeString DestFileName = System::UnicodeString());
	
public:
	virtual Frxbasetransportconnection::TfrxBaseTransportConnectionClass __fastcall GetConnectorInstance();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual System::UnicodeString __fastcall GetAccessToken(System::UnicodeString AuthorizationCode, System::UnicodeString ClientId, System::UnicodeString ClientSecret, System::UnicodeString &ErrorMsg);
	virtual void __fastcall TestToken(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST = false);
public:
	/* TfrxBaseBoxComIOTransport.Create */ inline __fastcall virtual TfrxBoxComIOTransportIndy(System::Classes::TComponent* AOwner) : Frxiotransportboxcombase::TfrxBaseBoxComIOTransport(AOwner) { }
	/* TfrxBaseBoxComIOTransport.Destroy */ inline __fastcall virtual ~TfrxBoxComIOTransportIndy() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxBoxComIOTransportIndy() : Frxiotransportboxcombase::TfrxBaseBoxComIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportboxcomindy */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTBOXCOMINDY)
using namespace Frxiotransportboxcomindy;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportboxcomindyHPP
