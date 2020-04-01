// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportDropbox.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportdropboxHPP
#define FrxiotransportdropboxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <frxIOTransportDropboxBase.hpp>
#include <frxIOTransportHelpers.hpp>
#include <frxBaseTransportConnection.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportdropbox
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDropboxIOTransport;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDropboxIOTransport : public Frxiotransportdropboxbase::TfrxBaseDropboxIOTransport
{
	typedef Frxiotransportdropboxbase::TfrxBaseDropboxIOTransport inherited;
	
protected:
	virtual System::UnicodeString __fastcall FolderAPI(const System::UnicodeString URL, const System::UnicodeString Source);
	virtual void __fastcall Upload(System::Classes::TStream* const Source, System::UnicodeString DestFileName = System::UnicodeString());
	virtual void __fastcall Download(const System::UnicodeString SourceFileName, System::Classes::TStream* const Source);
	
public:
	virtual Frxbasetransportconnection::TfrxBaseTransportConnectionClass __fastcall GetConnectorInstance();
	virtual void __fastcall TestToken(const System::UnicodeString URL, System::UnicodeString &sToken, bool bUsePOST = false);
public:
	/* TfrxBaseDropboxIOTransport.Create */ inline __fastcall virtual TfrxDropboxIOTransport(System::Classes::TComponent* AOwner) : Frxiotransportdropboxbase::TfrxBaseDropboxIOTransport(AOwner) { }
	
public:
	/* TfrxHTTPIOTransport.Destroy */ inline __fastcall virtual ~TfrxDropboxIOTransport() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxDropboxIOTransport() : Frxiotransportdropboxbase::TfrxBaseDropboxIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportdropbox */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTDROPBOX)
using namespace Frxiotransportdropbox;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportdropboxHPP
