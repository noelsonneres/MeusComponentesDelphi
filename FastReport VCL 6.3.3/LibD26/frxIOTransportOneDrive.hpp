// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportOneDrive.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportonedriveHPP
#define FrxiotransportonedriveHPP

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
#include <frxIOTransportOneDriveBase.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportonedrive
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxOneDriveIOTransport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxOneDriveIOTransport : public Frxiotransportonedrivebase::TfrxBaseOneDriveIOTransport
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
	virtual void __fastcall TestToken(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST = false);
public:
	/* TfrxBaseOneDriveIOTransport.Create */ inline __fastcall virtual TfrxOneDriveIOTransport(System::Classes::TComponent* AOwner) : Frxiotransportonedrivebase::TfrxBaseOneDriveIOTransport(AOwner) { }
	
public:
	/* TfrxHTTPIOTransport.Destroy */ inline __fastcall virtual ~TfrxOneDriveIOTransport() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxOneDriveIOTransport() : Frxiotransportonedrivebase::TfrxBaseOneDriveIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportonedrive */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTONEDRIVE)
using namespace Frxiotransportonedrive;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportonedriveHPP
