// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportBoxCom.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportboxcomHPP
#define FrxiotransportboxcomHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <frxIOTransportHelpers.hpp>
#include <frxBaseTransportConnection.hpp>
#include <frxIOTransportBoxComBase.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportboxcom
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBoxComIOTransport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxBoxComIOTransport : public Frxiotransportboxcombase::TfrxBaseBoxComIOTransport
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
	virtual System::UnicodeString __fastcall GetAccessToken(System::UnicodeString AuthorizationCode, System::UnicodeString ClientId, System::UnicodeString ClientSecret, System::UnicodeString &ErrorMsg);
	virtual Frxbasetransportconnection::TfrxBaseTransportConnectionClass __fastcall GetConnectorInstance();
	virtual void __fastcall TestToken(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST = false);
public:
	/* TfrxBaseBoxComIOTransport.Create */ inline __fastcall virtual TfrxBoxComIOTransport(System::Classes::TComponent* AOwner) : Frxiotransportboxcombase::TfrxBaseBoxComIOTransport(AOwner) { }
	/* TfrxBaseBoxComIOTransport.Destroy */ inline __fastcall virtual ~TfrxBoxComIOTransport() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxBoxComIOTransport() : Frxiotransportboxcombase::TfrxBaseBoxComIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportboxcom */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTBOXCOM)
using namespace Frxiotransportboxcom;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportboxcomHPP
