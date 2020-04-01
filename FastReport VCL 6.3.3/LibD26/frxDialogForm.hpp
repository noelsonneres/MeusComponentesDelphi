// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDialogForm.pas' rev: 33.00 (Windows)

#ifndef FrxdialogformHPP
#define FrxdialogformHPP

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
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdialogform
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDialogForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDialogForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	
protected:
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	
private:
	System::Classes::TNotifyEvent FOnModify;
	bool FThreadSafe;
	MESSAGE void __fastcall WMExitSizeMove(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Message);
	
public:
	__fastcall virtual TfrxDialogForm(System::Classes::TComponent* AOwner);
	__property System::Classes::TNotifyEvent OnModify = {read=FOnModify, write=FOnModify};
	__property bool ThreadSafe = {read=FThreadSafe, write=FThreadSafe, nodefault};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxDialogForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxDialogForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxDialogForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxdialogform */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDIALOGFORM)
using namespace Frxdialogform;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdialogformHPP
