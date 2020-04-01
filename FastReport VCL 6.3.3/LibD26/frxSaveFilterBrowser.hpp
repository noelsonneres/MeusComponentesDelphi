// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxSaveFilterBrowser.pas' rev: 33.00 (Windows)

#ifndef FrxsavefilterbrowserHPP
#define FrxsavefilterbrowserHPP

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
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.OleCtrls.hpp>
#include <frxFPUMask.hpp>
#include <SHDocVw.hpp>
#include <System.Math.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxsavefilterbrowser
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TBrowserForm;
//-- type declarations -------------------------------------------------------
typedef bool __fastcall (__closure *TTestURLEvent)(System::UnicodeString URL);

class PASCALIMPLEMENTATION TBrowserForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Shdocvw::TWebBrowser* WebBrowser;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall WebBrowserNavigateComplete2(System::TObject* ASender, const _di_IDispatch pDisp, const System::OleVariant &URL);
	void __fastcall NavigateError(System::TObject* ASender, const _di_IDispatch pDisp, const System::OleVariant &URL, const System::OleVariant &Frame, const System::OleVariant &StatusCode, System::WordBool &Cancel);
	void __fastcall FormCreate(System::TObject* Sender);
	
private:
	System::UnicodeString FURL;
	System::Classes::TStringList* FNavigateHistory;
	TTestURLEvent FOnTestURL;
	System::Classes::TNotifyEvent FOnDocumentComplet;
	void __fastcall DocumentComplet(System::TObject* ASender, const _di_IDispatch pDisp, const System::OleVariant &URL);
	
public:
	__fastcall virtual TBrowserForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TBrowserForm();
	__property System::UnicodeString URL = {read=FURL, write=FURL};
	__property System::Classes::TStringList* NavigateHistory = {read=FNavigateHistory};
	__property TTestURLEvent OnTestURL = {read=FOnTestURL, write=FOnTestURL};
	__property System::Classes::TNotifyEvent OnDocumentComplet = {read=FOnDocumentComplet, write=FOnDocumentComplet};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TBrowserForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TBrowserForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxsavefilterbrowser */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXSAVEFILTERBROWSER)
using namespace Frxsavefilterbrowser;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxsavefilterbrowserHPP
