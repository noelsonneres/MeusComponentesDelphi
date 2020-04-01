// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDock.pas' rev: 33.00 (Windows)

#ifndef FrxdockHPP
#define FrxdockHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <System.IniFiles.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdock
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxTBPanel;
class DELPHICLASS TfrxDockSite;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxTBPanel : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
protected:
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	
public:
	__fastcall virtual TfrxTBPanel(System::Classes::TComponent* AOwner);
	virtual void __fastcall Paint();
public:
	/* TCustomControl.Destroy */ inline __fastcall virtual ~TfrxTBPanel() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxTBPanel(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxDockSite : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
private:
	int FPanelSize;
	int FSavedSize;
	Vcl::Controls::TControl* FSplitter;
	Vcl::Controls::TWinControl* FTopParentWin;
	
public:
	__fastcall virtual TfrxDockSite(System::Classes::TComponent* AOwner);
	DYNAMIC void __fastcall DockDrop(Vcl::Controls::TDragDockObject* Source, int X, int Y);
	DYNAMIC void __fastcall DockOver(Vcl::Controls::TDragDockObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	DYNAMIC bool __fastcall DoUnDock(Vcl::Controls::TWinControl* NewTarget, Vcl::Controls::TControl* Client);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	DYNAMIC void __fastcall ReloadDockedControl(const System::UnicodeString AControlName, Vcl::Controls::TControl* &AControl);
	__property int SavedSize = {read=FSavedSize, write=FSavedSize, nodefault};
	__property Vcl::Controls::TWinControl* TopParentWin = {read=FTopParentWin, write=FTopParentWin};
public:
	/* TCustomControl.Destroy */ inline __fastcall virtual ~TfrxDockSite() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxDockSite(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall frxSaveToolbarPosition(System::Inifiles::TCustomIniFile* Ini, Vcl::Comctrls::TToolBar* t);
extern DELPHI_PACKAGE void __fastcall frxRestoreToolbarPosition(System::Inifiles::TCustomIniFile* Ini, Vcl::Comctrls::TToolBar* t);
extern DELPHI_PACKAGE void __fastcall frxSaveDock(System::Inifiles::TCustomIniFile* Ini, TfrxDockSite* d);
extern DELPHI_PACKAGE void __fastcall frxRestoreDock(System::Inifiles::TCustomIniFile* Ini, TfrxDockSite* d);
extern DELPHI_PACKAGE void __fastcall frxSaveFormPosition(System::Inifiles::TCustomIniFile* Ini, Vcl::Forms::TForm* f);
extern DELPHI_PACKAGE void __fastcall frxRestoreFormPosition(System::Inifiles::TCustomIniFile* Ini, Vcl::Forms::TForm* f);
}	/* namespace Frxdock */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDOCK)
using namespace Frxdock;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdockHPP
