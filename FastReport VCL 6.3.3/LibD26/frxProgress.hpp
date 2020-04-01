// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxProgress.pas' rev: 33.00 (Windows)

#ifndef FrxprogressHPP
#define FrxprogressHPP

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
#include <Vcl.ComCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxprogress
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxProgress;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxProgress : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TLabel* LMessage;
	Vcl::Comctrls::TProgressBar* Bar;
	Vcl::Stdctrls::TButton* CancelB;
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Message);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall CancelBClick(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	
private:
	Vcl::Forms::TForm* FActiveForm;
	bool FTerminated;
	int FPosition;
	System::UnicodeString FMessage;
	bool FProgress;
	HIDESBASE void __fastcall SetPosition(int Value);
	void __fastcall SetMessage(const System::UnicodeString Value);
	void __fastcall SetTerminated(bool Value);
	void __fastcall SetProgress(bool Value);
	
public:
	void __fastcall Reset();
	void __fastcall Execute(int MaxValue, const System::UnicodeString Msg, bool Canceled, bool Progress);
	void __fastcall Tick();
	__property bool Terminated = {read=FTerminated, write=SetTerminated, nodefault};
	__property int Position = {read=FPosition, write=SetPosition, nodefault};
	__property bool ShowProgress = {read=FProgress, write=SetProgress, nodefault};
	__property System::UnicodeString Message = {read=FMessage, write=SetMessage};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxProgress(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxProgress(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxProgress() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxProgress(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxprogress */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPROGRESS)
using namespace Frxprogress;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxprogressHPP
