// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxCrypt.pas' rev: 33.00 (Windows)

#ifndef FrxcryptHPP
#define FrxcryptHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <frxClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxcrypt
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCrypt;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxCrypt : public Frxclass::TfrxCustomCrypter
{
	typedef Frxclass::TfrxCustomCrypter inherited;
	
private:
	System::AnsiString __fastcall AskKey(const System::AnsiString Key);
	
public:
	virtual void __fastcall Crypt(System::Classes::TStream* Dest, const System::AnsiString Key);
	virtual bool __fastcall Decrypt(System::Classes::TStream* Source, const System::AnsiString Key);
public:
	/* TfrxCustomCrypter.Create */ inline __fastcall virtual TfrxCrypt(System::Classes::TComponent* AOwner) : Frxclass::TfrxCustomCrypter(AOwner) { }
	/* TfrxCustomCrypter.Destroy */ inline __fastcall virtual ~TfrxCrypt() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall frxCryptStream(System::Classes::TStream* Source, System::Classes::TStream* Dest, const System::AnsiString Key);
extern DELPHI_PACKAGE void __fastcall frxDecryptStream(System::Classes::TStream* Source, System::Classes::TStream* Dest, const System::AnsiString Key);
}	/* namespace Frxcrypt */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCRYPT)
using namespace Frxcrypt;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxcryptHPP
