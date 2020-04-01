// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxInPlaceEditors.pas' rev: 33.00 (Windows)

#ifndef FrxinplaceeditorsHPP
#define FrxinplaceeditorsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Menus.hpp>
#include <System.TypInfo.hpp>
#include <Vcl.Dialogs.hpp>
#include <frxClass.hpp>
#include <frxUtils.hpp>
#include <frxGraphicControls.hpp>
#include <frxRes.hpp>
#include <frxUnicodeCtrls.hpp>
#include <frxUnicodeUtils.hpp>
#include <Vcl.Buttons.hpp>
#include <frxPopupForm.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxinplaceeditors
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxInPlaceMemoEditorBase;
class DELPHICLASS TfrxInPlaceTextEditorBase;
class DELPHICLASS TfrxInPlaceMemoEditor;
class DELPHICLASS TfrxInPlaceDataFiledEditor;
class DELPHICLASS TfrxInPlaceBasePanelEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxInPlaceMemoEditorBase : public Frxclass::TfrxInPlaceEditor
{
	typedef Frxclass::TfrxInPlaceEditor inherited;
	
private:
	void __fastcall LinesChange(System::TObject* Sender);
	void __fastcall MemoKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall DoExit(System::TObject* Sender);
	void __fastcall MemoKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
protected:
	Vcl::Stdctrls::TCustomMemo* FInPlaceMemo;
	bool FEdited;
	virtual void __fastcall InitControlFromComponent();
	virtual void __fastcall InitComponentFromControl();
	void __fastcall EditDone();
	virtual void __fastcall CreateMemo() = 0 ;
	
public:
	__fastcall virtual TfrxInPlaceMemoEditorBase(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner);
	__fastcall virtual ~TfrxInPlaceMemoEditorBase();
	virtual bool __fastcall HasCustomEditor();
	virtual bool __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall EditInPlace(System::Classes::TComponent* aParent, const System::Types::TRect &aRect);
	virtual bool __fastcall EditInPlaceDone();
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall FinalizeUI(Frxclass::TfrxInteractiveEventsParams &EventParams);
};


class PASCALIMPLEMENTATION TfrxInPlaceTextEditorBase : public TfrxInPlaceMemoEditorBase
{
	typedef TfrxInPlaceMemoEditorBase inherited;
	
protected:
	virtual void __fastcall CreateMemo();
public:
	/* TfrxInPlaceMemoEditorBase.Create */ inline __fastcall virtual TfrxInPlaceTextEditorBase(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : TfrxInPlaceMemoEditorBase(aClassRef, aOwner) { }
	/* TfrxInPlaceMemoEditorBase.Destroy */ inline __fastcall virtual ~TfrxInPlaceTextEditorBase() { }
	
};


class PASCALIMPLEMENTATION TfrxInPlaceMemoEditor : public TfrxInPlaceTextEditorBase
{
	typedef TfrxInPlaceTextEditorBase inherited;
	
protected:
	virtual void __fastcall InitControlFromComponent();
	virtual void __fastcall InitComponentFromControl();
public:
	/* TfrxInPlaceMemoEditorBase.Create */ inline __fastcall virtual TfrxInPlaceMemoEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : TfrxInPlaceTextEditorBase(aClassRef, aOwner) { }
	/* TfrxInPlaceMemoEditorBase.Destroy */ inline __fastcall virtual ~TfrxInPlaceMemoEditor() { }
	
};


class PASCALIMPLEMENTATION TfrxInPlaceDataFiledEditor : public Frxclass::TfrxInPlaceEditor
{
	typedef Frxclass::TfrxInPlaceEditor inherited;
	
private:
	Frxpopupform::TfrxPopupForm* FPopupForm;
	Vcl::Stdctrls::TListBox* FListBox;
	bool FDrawDropDown;
	bool FDrawButton;
	bool FDRawDragDrop;
	System::Types::TRect FRect;
	bool FModified;
	void __fastcall UpdateRect();
	void __fastcall DoPopupHide(System::TObject* Sender);
	void __fastcall DoLBClick(System::TObject* Sender);
	void __fastcall LBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &aRect, Winapi::Windows::TOwnerDrawState State);
	Frxclass::TfrxDataSet* __fastcall GetParentDS();
	
public:
	virtual void __fastcall InitializeUI(Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall FinalizeUI(Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DrawCustomEditor(Vcl::Graphics::TCanvas* aCanvas, const System::Types::TRect &aRect);
	virtual bool __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	bool __fastcall ShowPopup(System::Classes::TComponent* aParent, const System::Types::TRect &aRect, int X, int Y);
	virtual bool __fastcall DoCustomDragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoCustomDragDrop(System::TObject* Source, int X, int Y, Frxclass::TfrxInteractiveEventsParams &EventParams);
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxInPlaceDataFiledEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : Frxclass::TfrxInPlaceEditor(aClassRef, aOwner) { }
	/* TfrxInPlaceEditor.Destroy */ inline __fastcall virtual ~TfrxInPlaceDataFiledEditor() { }
	
};


class PASCALIMPLEMENTATION TfrxInPlaceBasePanelEditor : public Frxclass::TfrxInPlaceEditor
{
	typedef Frxclass::TfrxInPlaceEditor inherited;
	
private:
	Frxgraphiccontrols::TfrxSwitchButtonsPanel* FButtonsPanel;
	bool FSwitchMode;
	System::Types::TPoint FPosition;
	bool __fastcall DestroyPanel();
	
protected:
	bool FMouseDown;
	virtual bool __fastcall GetItem(int Index) = 0 ;
	virtual void __fastcall SetItem(int Index, const bool Value) = 0 ;
	virtual int __fastcall Count() = 0 ;
	virtual System::UnicodeString __fastcall GetName(int Index) = 0 ;
	virtual System::Uitypes::TColor __fastcall GetColor(int Index) = 0 ;
	
public:
	__fastcall virtual ~TfrxInPlaceBasePanelEditor();
	virtual void __fastcall AfterConstruction();
	virtual void __fastcall InitializeUI(Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall FinalizeUI(Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual System::Types::TRect __fastcall GetActiveRect();
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DrawCustomEditor(Vcl::Graphics::TCanvas* aCanvas, const System::Types::TRect &aRect);
	__property bool Item[int Index] = {read=GetItem, write=SetItem};
public:
	/* TfrxInPlaceEditor.Create */ inline __fastcall virtual TfrxInPlaceBasePanelEditor(Frxclass::TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner) : Frxclass::TfrxInPlaceEditor(aClassRef, aOwner) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxinplaceeditors */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXINPLACEEDITORS)
using namespace Frxinplaceeditors;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxinplaceeditorsHPP
