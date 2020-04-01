// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportGoogleDrive.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportgoogledriveHPP
#define FrxiotransportgoogledriveHPP

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
#include <frxIOTransportGoogleDriveBase.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportgoogledrive
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxGoogleDriveIOTransport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxGoogleDriveIOTransport : public Frxiotransportgoogledrivebase::TfrxBaseGoogleDriveIOTransport
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
	virtual System::UnicodeString __fastcall GetAccessToken(System::UnicodeString AuthorizationCode, System::UnicodeString ClientId, System::UnicodeString ClientSecret, System::UnicodeString &ErrorMsg);
	virtual Frxbasetransportconnection::TfrxBaseTransportConnectionClass __fastcall GetConnectorInstance();
	virtual void __fastcall TestToken(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST = false);
public:
	/* TfrxBaseGoogleDriveIOTransport.Create */ inline __fastcall virtual TfrxGoogleDriveIOTransport(System::Classes::TComponent* AOwner) : Frxiotransportgoogledrivebase::TfrxBaseGoogleDriveIOTransport(AOwner) { }
	/* TfrxBaseGoogleDriveIOTransport.Destroy */ inline __fastcall virtual ~TfrxGoogleDriveIOTransport() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxGoogleDriveIOTransport() : Frxiotransportgoogledrivebase::TfrxBaseGoogleDriveIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportgoogledrive */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTGOOGLEDRIVE)
using namespace Frxiotransportgoogledrive;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportgoogledriveHPP
