// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxSendMAPI.pas' rev: 33.00 (Windows)

#ifndef FrxsendmapiHPP
#define FrxsendmapiHPP

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

//-- user supplied -----------------------------------------------------------

namespace Frxsendmapi
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TMapiControl;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TMapiErrEvent)(System::TObject* Sender, int ErrCode);

class PASCALIMPLEMENTATION TMapiControl : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
__published:
	__fastcall virtual TMapiControl(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TMapiControl();
	
private:
	System::UnicodeString FSubject;
	System::UnicodeString FMailtext;
	System::UnicodeString FFromName;
	System::UnicodeString FFromAdress;
	System::Classes::TStrings* FTOAdr;
	System::Classes::TStrings* FCCAdr;
	System::Classes::TStrings* FBCCAdr;
	System::Classes::TStrings* FAttachedFileName;
	bool FShowDialog;
	bool FUseAppHandle;
	int FMAPISendFlag;
	System::Classes::TNotifyEvent FOnUserAbort;
	TMapiErrEvent FOnMapiError;
	System::Classes::TNotifyEvent FOnSuccess;
	void __fastcall SetToAddr(System::Classes::TStrings* newValue);
	void __fastcall SetCCAddr(System::Classes::TStrings* newValue);
	void __fastcall SetBCCAddr(System::Classes::TStrings* newValue);
	void __fastcall SetAttachedFileName(System::Classes::TStrings* newValue);
	
public:
	NativeUInt ApplicationHandle;
	System::UnicodeString __fastcall Sendmail(System::UnicodeString User, System::UnicodeString Passwd);
	void __fastcall Reset();
	System::AnsiString __fastcall GetName(System::UnicodeString mailaddress);
	System::AnsiString __fastcall GetAddress(System::UnicodeString mailaddress);
	
__published:
	__property System::UnicodeString Subject = {read=FSubject, write=FSubject};
	__property System::UnicodeString Body = {read=FMailtext, write=FMailtext};
	__property System::UnicodeString FromName = {read=FFromName, write=FFromName};
	__property System::UnicodeString FromAdress = {read=FFromAdress, write=FFromAdress};
	__property System::Classes::TStrings* Recipients = {read=FTOAdr, write=SetToAddr};
	__property System::Classes::TStrings* CopyTo = {read=FCCAdr, write=SetCCAddr};
	__property System::Classes::TStrings* BlindCopyTo = {read=FBCCAdr, write=SetBCCAddr};
	__property System::Classes::TStrings* AttachedFiles = {read=FAttachedFileName, write=SetAttachedFileName};
	__property bool ShowDialog = {read=FShowDialog, write=FShowDialog, nodefault};
	__property bool UseAppHandle = {read=FUseAppHandle, write=FUseAppHandle, nodefault};
	__property System::Classes::TNotifyEvent OnUserAbort = {read=FOnUserAbort, write=FOnUserAbort};
	__property TMapiErrEvent OnMapiError = {read=FOnMapiError, write=FOnMapiError};
	__property System::Classes::TNotifyEvent OnSuccess = {read=FOnSuccess, write=FOnSuccess};
	__property int MAPISendFlag = {read=FMAPISendFlag, write=FMAPISendFlag, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxsendmapi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXSENDMAPI)
using namespace Frxsendmapi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxsendmapiHPP
