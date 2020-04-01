// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportGoogleDriveIndy.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportgoogledriveindyHPP
#define FrxiotransportgoogledriveindyHPP

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
#include <frxIOTransportGoogleDriveBase.hpp>
#include <frxBaseTransportConnection.hpp>
#include <IdHTTP.hpp>
#include <IdComponent.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportgoogledriveindy
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGoogleDriveIOTransportIndy;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGoogleDriveIOTransportIndy : public Frxiotransportgoogledrivebase::TfrxBaseGoogleDriveIOTransport
{
	typedef Frxiotransportgoogledrivebase::TfrxBaseGoogleDriveIOTransport inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetListFolder(System::UnicodeString aFilter = System::UnicodeString());
	virtual System::UnicodeString __fastcall GetListFolderContinue(System::UnicodeString NextPageToken, System::UnicodeString aFilter = System::UnicodeString());
	virtual void __fastcall CreateFolder(System::UnicodeString Dir);
	virtual void __fastcall DeleteFileOrFolder(const System::UnicodeString Id);
	virtual void __fastcall Upload(System::Classes::TStream* const Source, System::UnicodeString DestFileName = System::UnicodeString());
	virtual void __fastcall Download(const System::UnicodeString SourceFileName, System::Classes::TStream* const Source);
	
public:
	virtual Frxbasetransportconnection::TfrxBaseTransportConnectionClass __fastcall GetConnectorInstance();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual System::UnicodeString __fastcall GetAccessToken(System::UnicodeString AuthorizationCode, System::UnicodeString ClientId, System::UnicodeString ClientSecret, System::UnicodeString &ErrorMsg);
	virtual void __fastcall TestToken(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST = false);
public:
	/* TfrxBaseGoogleDriveIOTransport.Create */ inline __fastcall virtual TfrxGoogleDriveIOTransportIndy(System::Classes::TComponent* AOwner) : Frxiotransportgoogledrivebase::TfrxBaseGoogleDriveIOTransport(AOwner) { }
	/* TfrxBaseGoogleDriveIOTransport.Destroy */ inline __fastcall virtual ~TfrxGoogleDriveIOTransportIndy() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxGoogleDriveIOTransportIndy() : Frxiotransportgoogledrivebase::TfrxBaseGoogleDriveIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportgoogledriveindy */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTGOOGLEDRIVEINDY)
using namespace Frxiotransportgoogledriveindy;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportgoogledriveindyHPP
