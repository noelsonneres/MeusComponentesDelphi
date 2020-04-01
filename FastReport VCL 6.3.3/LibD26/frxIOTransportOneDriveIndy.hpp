// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportOneDriveIndy.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportonedriveindyHPP
#define FrxiotransportonedriveindyHPP

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
#include <frxIOTransportOneDriveBase.hpp>
#include <frxBaseTransportConnection.hpp>
#include <IdHTTP.hpp>
#include <IdComponent.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportonedriveindy
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxOneDriveIOTransportIndy;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxOneDriveIOTransportIndy : public Frxiotransportonedrivebase::TfrxBaseOneDriveIOTransport
{
	typedef Frxiotransportonedrivebase::TfrxBaseOneDriveIOTransport inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetListFolder();
	virtual System::UnicodeString __fastcall GetListFolderContinue(System::UnicodeString NextLink);
	virtual void __fastcall CreateFolder(System::UnicodeString Dir);
	virtual void __fastcall DeleteFileOrFolder(System::UnicodeString Name);
	virtual void __fastcall Upload(System::Classes::TStream* const Source, System::UnicodeString DestFileName = System::UnicodeString());
	virtual void __fastcall Download(const System::UnicodeString SourceFileName, System::Classes::TStream* const Source);
	
public:
	virtual Frxbasetransportconnection::TfrxBaseTransportConnectionClass __fastcall GetConnectorInstance();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall TestToken(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST = false);
public:
	/* TfrxBaseOneDriveIOTransport.Create */ inline __fastcall virtual TfrxOneDriveIOTransportIndy(System::Classes::TComponent* AOwner) : Frxiotransportonedrivebase::TfrxBaseOneDriveIOTransport(AOwner) { }
	
public:
	/* TfrxHTTPIOTransport.Destroy */ inline __fastcall virtual ~TfrxOneDriveIOTransportIndy() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxOneDriveIOTransportIndy() : Frxiotransportonedrivebase::TfrxBaseOneDriveIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportonedriveindy */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTONEDRIVEINDY)
using namespace Frxiotransportonedriveindy;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportonedriveindyHPP
