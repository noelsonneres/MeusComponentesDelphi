// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxInsp.pas' rev: 33.00 (Windows)

#ifndef FrxinspHPP
#define FrxinspHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <frxDsgnIntf.hpp>
#include <frxPopupForm.hpp>
#include <frxClass.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Tabs.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxinsp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxObjectInspector;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxObjectInspector : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TComboBox* ObjectsCB;
	Vcl::Menus::TPopupMenu* PopupMenu1;
	Vcl::Menus::TMenuItem* N11;
	Vcl::Menus::TMenuItem* N21;
	Vcl::Menus::TMenuItem* N31;
	Vcl::Extctrls::TPanel* BackPanel;
	Vcl::Forms::TScrollBox* Box;
	Vcl::Extctrls::TPaintBox* PB;
	Vcl::Stdctrls::TEdit* Edit1;
	Vcl::Extctrls::TPanel* EditPanel;
	Vcl::Buttons::TSpeedButton* EditBtn;
	Vcl::Extctrls::TPanel* ComboPanel;
	Vcl::Buttons::TSpeedButton* ComboBtn;
	Vcl::Forms::TScrollBox* HintPanel;
	Vcl::Extctrls::TSplitter* Splitter1;
	Vcl::Stdctrls::TLabel* PropL;
	Vcl::Stdctrls::TLabel* DescrL;
	Vcl::Menus::TMenuItem* N41;
	Vcl::Menus::TMenuItem* N51;
	Vcl::Menus::TMenuItem* N61;
	void __fastcall PBPaint(System::TObject* Sender);
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall PBMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall PBMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall PBMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall Edit1KeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall Edit1KeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall EditBtnClick(System::TObject* Sender);
	void __fastcall ComboBtnClick(System::TObject* Sender);
	void __fastcall Edit1MouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall ObjectsCBClick(System::TObject* Sender);
	void __fastcall ObjectsCBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall PBDblClick(System::TObject* Sender);
	void __fastcall FormMouseWheelDown(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall FormMouseWheelUp(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall FormEndDock(System::TObject* Sender, System::TObject* Target, int X, int Y);
	void __fastcall ComboBtnMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall TabChange(System::TObject* Sender);
	void __fastcall N11Click(System::TObject* Sender);
	void __fastcall N21Click(System::TObject* Sender);
	void __fastcall N31Click(System::TObject* Sender);
	void __fastcall FormDeactivate(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall ObjectsCBDropDown(System::TObject* Sender);
	
private:
	Frxclass::TfrxCustomDesigner* FDesigner;
	bool FDisableDblClick;
	bool FDisableUpdate;
	bool FDown;
	Frxdsgnintf::TfrxPropertyList* FEventList;
	Vcl::Controls::THintWindow* FHintWindow;
	int FItemIndex;
	System::UnicodeString FLastPosition;
	Frxdsgnintf::TfrxPropertyList* FList;
	Frxpopupform::TfrxPopupForm* FPopupForm;
	Vcl::Stdctrls::TListBox* FPopupLB;
	bool FPopupLBVisible;
	Frxdsgnintf::TfrxPropertyList* FPropertyList;
	Vcl::Extctrls::TPanel* FPanel;
	int FRowHeight;
	Frxclass::TfrxSelectedObjectsList* FSelectedObjects;
	int FSplitterPos;
	Vcl::Tabs::TTabSet* FTabs;
	Vcl::Graphics::TBitmap* FTempBMP;
	Frxclass::TfrxSelectedObjectsList* FTempList;
	unsigned FTickCount;
	bool FUpdatingObjectsCB;
	bool FUpdatingPB;
	System::Classes::TNotifyEvent FOnSelectionChanged;
	System::Classes::TNotifyEvent FOnModify;
	int __fastcall Count();
	Frxdsgnintf::TfrxPropertyItem* __fastcall GetItem(int Index);
	System::UnicodeString __fastcall GetName(int Index);
	int __fastcall GetOffset(int Index);
	Frxdsgnintf::TfrxPropertyAttributes __fastcall GetType(int Index);
	System::UnicodeString __fastcall GetValue(int Index);
	void __fastcall AdjustControls();
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Msg);
	void __fastcall DrawOneLine(int i, bool Selected);
	void __fastcall DoModify();
	void __fastcall SetObjects(System::Classes::TList* Value);
	void __fastcall SetItemIndex(int Value);
	void __fastcall SetSelectedObjects(Frxclass::TfrxSelectedObjectsList* Value);
	void __fastcall SetValue(int Index, System::UnicodeString Value);
	void __fastcall LBClick(System::TObject* Sender);
	int __fastcall GetSplitter1Pos();
	void __fastcall SetSplitter1Pos(const int Value);
	
public:
	__fastcall virtual TfrxObjectInspector(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxObjectInspector();
	void __fastcall DisableUpdate();
	void __fastcall EnableUpdate();
	void __fastcall Inspect(System::Classes::TPersistent* *AObjects, const int AObjects_High);
	HIDESBASE void __fastcall SetColor(System::Uitypes::TColor Color);
	void __fastcall UpdateProperties();
	__property System::Classes::TList* Objects = {write=SetObjects};
	__property int ItemIndex = {read=FItemIndex, write=SetItemIndex, nodefault};
	__property Frxclass::TfrxSelectedObjectsList* SelectedObjects = {read=FSelectedObjects, write=SetSelectedObjects};
	__property int SplitterPos = {read=FSplitterPos, write=FSplitterPos, nodefault};
	__property int Splitter1Pos = {read=GetSplitter1Pos, write=SetSplitter1Pos, nodefault};
	__property System::Classes::TNotifyEvent OnModify = {read=FOnModify, write=FOnModify};
	__property System::Classes::TNotifyEvent OnSelectionChanged = {read=FOnSelectionChanged, write=FOnSelectionChanged};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxObjectInspector(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxObjectInspector(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxinsp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXINSP)
using namespace Frxinsp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxinspHPP
