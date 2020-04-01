// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportIndyMail.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportindymailHPP
#define FrxiotransportindymailHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxClass.hpp>
#include <System.IniFiles.hpp>
#include <Vcl.ComCtrls.hpp>
#include <frxIOTransportMail.hpp>
#include <frxProgress.hpp>
#include <IdSMTP.hpp>
#include <IdMessage.hpp>
#include <IdComponent.hpp>
#include <IdSSLOpenSSL.hpp>
#include <IdExplicitTLSClientServerBase.hpp>
#include <IdAttachmentFile.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportindymail
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxMailIOTransportIndy;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxMailIOTransportIndy : public Frxiotransportmail::TfrxMailIOTransport
{
	typedef Frxiotransportmail::TfrxMailIOTransport inherited;
	
private:
	Frxprogress::TfrxProgress* FProgress;
	
protected:
	virtual System::UnicodeString __fastcall DoMailSMTP(const System::UnicodeString Server, const int Port, const System::UnicodeString UserField, const System::UnicodeString PasswordField, System::WideString FromField, System::WideString ToField, System::WideString SubjectField, System::WideString CompanyField, System::WideString TextField, System::Classes::TStringList* FileNames, int Timeout = 0x3c, bool ConfurmReading = false, System::WideString MailCc = System::WideString(), System::WideString MailBcc = System::WideString());
	void __fastcall ConnectionWork(System::TObject* Sender, Idcomponent::TWorkMode AWorkMode, __int64 AWorkCount);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
public:
	/* TfrxMailIOTransport.Create */ inline __fastcall virtual TfrxMailIOTransportIndy(System::Classes::TComponent* AOwner) : Frxiotransportmail::TfrxMailIOTransport(AOwner) { }
	/* TfrxMailIOTransport.Destroy */ inline __fastcall virtual ~TfrxMailIOTransportIndy() { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxMailIOTransportIndy() : Frxiotransportmail::TfrxMailIOTransport() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportindymail */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTINDYMAIL)
using namespace Frxiotransportindymail;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportindymailHPP
