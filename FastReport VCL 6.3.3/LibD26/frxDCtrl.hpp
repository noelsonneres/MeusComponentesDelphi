// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDCtrl.pas' rev: 33.00 (Windows)

#ifndef FrxdctrlHPP
#define FrxdctrlHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <Winapi.CommCtrl.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Mask.hpp>
#include <Vcl.CheckLst.hpp>
#include <frxClass.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdctrl
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDialogControls;
class DELPHICLASS TfrxLabelControl;
class DELPHICLASS TfrxPageControl;
class DELPHICLASS TfrxTabSheet;
class DELPHICLASS TfrxCustomEditControl;
class DELPHICLASS TfrxEditControl;
class DELPHICLASS TfrxMemoControl;
class DELPHICLASS TfrxButtonControl;
class DELPHICLASS TfrxCheckBoxControl;
class DELPHICLASS TfrxRadioButtonControl;
class DELPHICLASS TfrxListBoxControl;
class DELPHICLASS TfrxComboBoxControl;
class DELPHICLASS TfrxPanelControl;
class DELPHICLASS TfrxGroupBoxControl;
class DELPHICLASS TfrxDateEditControl;
class DELPHICLASS TfrxImageControl;
class DELPHICLASS TfrxBevelControl;
class DELPHICLASS TfrxBitBtnControl;
class DELPHICLASS TfrxSpeedButtonControl;
class DELPHICLASS TfrxMaskEditControl;
class DELPHICLASS TfrxCheckListBoxControl;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDialogControls : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxDialogControls(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxDialogControls() { }
	
};


class PASCALIMPLEMENTATION TfrxLabelControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Stdctrls::TLabel* FLabel;
	System::Classes::TAlignment __fastcall GetAlignment();
	bool __fastcall GetAutoSize();
	bool __fastcall GetWordWrap();
	void __fastcall SetAlignment(const System::Classes::TAlignment Value);
	void __fastcall SetAutoSize(const bool Value);
	void __fastcall SetWordWrap(const bool Value);
	
public:
	__fastcall virtual TfrxLabelControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall BeforeStartReport();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	__property Vcl::Stdctrls::TLabel* LabelCtl = {read=FLabel};
	
__published:
	__property System::Classes::TAlignment Alignment = {read=GetAlignment, write=SetAlignment, default=0};
	__property bool AutoSize = {read=GetAutoSize, write=SetAutoSize, default=1};
	__property Caption = {default=0};
	__property Color;
	__property bool WordWrap = {read=GetWordWrap, write=SetWordWrap, default=0};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxLabelControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxLabelControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


typedef System::UnicodeString TfrxOnChangingEvent;

class PASCALIMPLEMENTATION TfrxPageControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Comctrls::TPageControl* FPageControl;
	Frxclass::TfrxNotifyEvent FOnChange;
	TfrxOnChangingEvent FOnChanging;
	bool __fastcall GetMultiLine();
	bool __fastcall GetRaggedRight();
	bool __fastcall GetScrollOpposite();
	Vcl::Comctrls::TTabStyle __fastcall GetStyle();
	short __fastcall GetTabHeight();
	int __fastcall GetTabIndex();
	int __fastcall GetTabOrder();
	Vcl::Comctrls::TTabPosition __fastcall GetTabPosition();
	short __fastcall GetTabWidth();
	void __fastcall SetMultiLine(const bool Value);
	void __fastcall SetRaggedRight(const bool Value);
	void __fastcall SetScrollOpposite(const bool Value);
	void __fastcall SetStyle(const Vcl::Comctrls::TTabStyle Value);
	void __fastcall SetTabHeight(const short Value);
	void __fastcall SetTabIndex(const int Value);
	void __fastcall SetTabOrder(const int Value);
	void __fastcall SetTabPosition(const Vcl::Comctrls::TTabPosition Value);
	void __fastcall SetTabWidth(const short Value);
	bool __fastcall GetHotTrack();
	void __fastcall SetHotTrack(const bool Value);
	void __fastcall DoOnChange(System::TObject* Sender);
	void __fastcall DoOnChanging(System::TObject* Sender, bool &AllowChange);
	
protected:
	virtual void __fastcall SetParent(Frxclass::TfrxComponent* AParent);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	void __fastcall UpdateSize();
	
public:
	__fastcall virtual TfrxPageControl(System::Classes::TComponent* AOwner);
	virtual bool __fastcall IsAcceptControl(Frxclass::TfrxComponent* aControl);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	__property Vcl::Comctrls::TPageControl* PageControl = {read=FPageControl};
	
__published:
	__property bool HotTrack = {read=GetHotTrack, write=SetHotTrack, default=0};
	__property bool MultiLine = {read=GetMultiLine, write=SetMultiLine, default=0};
	__property bool RaggedRight = {read=GetRaggedRight, write=SetRaggedRight, default=0};
	__property bool ScrollOpposite = {read=GetScrollOpposite, write=SetScrollOpposite, default=0};
	__property Vcl::Comctrls::TTabStyle Style = {read=GetStyle, write=SetStyle, default=0};
	__property short TabHeight = {read=GetTabHeight, write=SetTabHeight, default=0};
	__property int TabIndex = {read=GetTabIndex, write=SetTabIndex, stored=false, nodefault};
	__property Vcl::Comctrls::TTabPosition TabPosition = {read=GetTabPosition, write=SetTabPosition, default=0};
	__property short TabWidth = {read=GetTabWidth, write=SetTabWidth, default=0};
	__property int TabOrder = {read=GetTabOrder, write=SetTabOrder, nodefault};
	__property TabStop = {default=1};
	__property Frxclass::TfrxNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property TfrxOnChangingEvent OnChanging = {read=FOnChanging, write=FOnChanging};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxPageControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxPageControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxTabSheet : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Comctrls::TTabSheet* FTabSheet;
	int __fastcall GetBorderWidth();
	bool __fastcall GetHighlighted();
	int __fastcall GetImageIndex();
	int __fastcall GetPageIndex();
	bool __fastcall GetTabVisible();
	void __fastcall SetBorderWidth(const int Value);
	void __fastcall SetHighlighted(const bool Value);
	void __fastcall SetImageIndex(const int Value);
	void __fastcall SetPageIndex(const int Value);
	void __fastcall SetTabVisible(const bool Value);
	
protected:
	virtual void __fastcall SetParent(Frxclass::TfrxComponent* AParent);
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual void __fastcall SetTop(System::Extended Value);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	void __fastcall UpdateSize();
	
public:
	__fastcall virtual TfrxTabSheet(System::Classes::TComponent* AOwner);
	virtual bool __fastcall IsAcceptAsChild(Frxclass::TfrxComponent* aParent);
	virtual bool __fastcall IsOwnerDraw();
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	virtual Frxclass::TfrxComponent* __fastcall GetContainedComponent(System::Extended X, System::Extended Y, Frxclass::TfrxComponent* IsCanContain = (Frxclass::TfrxComponent*)(0x0));
	__property Vcl::Comctrls::TTabSheet* TabSheet = {read=FTabSheet};
	__property int ImageIndex = {read=GetImageIndex, write=SetImageIndex, default=0};
	
__published:
	__property Caption = {default=0};
	__property TabStop = {default=1};
	__property int BorderWidth = {read=GetBorderWidth, write=SetBorderWidth, nodefault};
	__property bool TabVisible = {read=GetTabVisible, write=SetTabVisible, default=1};
	__property int PageIndex = {read=GetPageIndex, write=SetPageIndex, stored=false, nodefault};
	__property bool Highlighted = {read=GetHighlighted, write=SetHighlighted, default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxTabSheet() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxTabSheet(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxCustomEditControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Frxclass::TfrxNotifyEvent FOnChange;
	int __fastcall GetMaxLength();
	System::WideChar __fastcall GetPasswordChar();
	bool __fastcall GetReadOnly();
	System::UnicodeString __fastcall GetText();
	void __fastcall DoOnChange(System::TObject* Sender);
	void __fastcall SetMaxLength(const int Value);
	void __fastcall SetPasswordChar(const System::WideChar Value);
	void __fastcall SetReadOnly(const bool Value);
	void __fastcall SetText(const System::UnicodeString Value);
	
protected:
	Vcl::Stdctrls::TCustomEdit* FCustomEdit;
	virtual System::Uitypes::TEditCharCase __fastcall GetCharCase();
	virtual void __fastcall SetCharCase(const System::Uitypes::TEditCharCase Value);
	
public:
	__fastcall virtual TfrxCustomEditControl(System::Classes::TComponent* AOwner);
	__property System::Uitypes::TEditCharCase CharCase = {read=GetCharCase, write=SetCharCase, default=0};
	__property int MaxLength = {read=GetMaxLength, write=SetMaxLength, nodefault};
	__property System::WideChar PasswordChar = {read=GetPasswordChar, write=SetPasswordChar, nodefault};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, default=0};
	__property System::UnicodeString Text = {read=GetText, write=SetText};
	__property Frxclass::TfrxNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxCustomEditControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomEditControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxEditControl : public TfrxCustomEditControl
{
	typedef TfrxCustomEditControl inherited;
	
private:
	Vcl::Stdctrls::TEdit* FEdit;
	
protected:
	virtual System::Uitypes::TEditCharCase __fastcall GetCharCase();
	virtual void __fastcall SetCharCase(const System::Uitypes::TEditCharCase Value);
	
public:
	__fastcall virtual TfrxEditControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Stdctrls::TEdit* Edit = {read=FEdit};
	
__published:
	__property CharCase = {default=0};
	__property Color;
	__property MaxLength;
	__property PasswordChar;
	__property ReadOnly = {default=0};
	__property TabStop = {default=1};
	__property Text = {default=0};
	__property OnChange = {default=0};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxEditControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxEditControl(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomEditControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxMemoControl : public TfrxCustomEditControl
{
	typedef TfrxCustomEditControl inherited;
	
private:
	Vcl::Stdctrls::TMemo* FMemo;
	System::Classes::TStrings* __fastcall GetLines();
	void __fastcall SetLines(System::Classes::TStrings* const Value);
	System::Uitypes::TScrollStyle __fastcall GetScrollStyle();
	bool __fastcall GetWordWrap();
	void __fastcall SetScrollStyle(const System::Uitypes::TScrollStyle Value);
	void __fastcall SetWordWrap(const bool Value);
	
protected:
	virtual System::Uitypes::TEditCharCase __fastcall GetCharCase();
	virtual void __fastcall SetCharCase(const System::Uitypes::TEditCharCase Value);
	
public:
	__fastcall virtual TfrxMemoControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Stdctrls::TMemo* Memo = {read=FMemo};
	
__published:
	__property CharCase = {default=0};
	__property Color;
	__property System::Classes::TStrings* Lines = {read=GetLines, write=SetLines};
	__property MaxLength;
	__property ReadOnly = {default=0};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=GetScrollStyle, write=SetScrollStyle, default=0};
	__property TabStop = {default=1};
	__property bool WordWrap = {read=GetWordWrap, write=SetWordWrap, default=1};
	__property OnChange = {default=0};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxMemoControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxMemoControl(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomEditControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxButtonControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Stdctrls::TButton* FButton;
	bool __fastcall GetCancel();
	bool __fastcall GetDefault();
	System::Uitypes::TModalResult __fastcall GetModalResult();
	void __fastcall SetCancel(const bool Value);
	void __fastcall SetDefault(const bool Value);
	void __fastcall SetModalResult(const System::Uitypes::TModalResult Value);
	bool __fastcall GetWordWrap();
	void __fastcall SetWordWrap(const bool Value);
	
public:
	__fastcall virtual TfrxButtonControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Stdctrls::TButton* Button = {read=FButton};
	
__published:
	__property bool Cancel = {read=GetCancel, write=SetCancel, default=0};
	__property Caption = {default=0};
	__property bool Default = {read=GetDefault, write=SetDefault, default=0};
	__property System::Uitypes::TModalResult ModalResult = {read=GetModalResult, write=SetModalResult, default=0};
	__property bool WordWrap = {read=GetWordWrap, write=SetWordWrap, default=0};
	__property TabStop = {default=1};
	__property OnClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxButtonControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxButtonControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxCheckBoxControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Stdctrls::TCheckBox* FCheckBox;
	System::Classes::TAlignment __fastcall GetAlignment();
	bool __fastcall GetAllowGrayed();
	bool __fastcall GetChecked();
	Vcl::Stdctrls::TCheckBoxState __fastcall GetState();
	void __fastcall SetAlignment(const System::Classes::TAlignment Value);
	void __fastcall SetAllowGrayed(const bool Value);
	void __fastcall SetChecked(const bool Value);
	void __fastcall SetState(const Vcl::Stdctrls::TCheckBoxState Value);
	bool __fastcall GetWordWrap();
	void __fastcall SetWordWrap(const bool Value);
	
public:
	__fastcall virtual TfrxCheckBoxControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Stdctrls::TCheckBox* CheckBox = {read=FCheckBox};
	
__published:
	__property System::Classes::TAlignment Alignment = {read=GetAlignment, write=SetAlignment, default=1};
	__property Caption = {default=0};
	__property bool Checked = {read=GetChecked, write=SetChecked, default=0};
	__property bool AllowGrayed = {read=GetAllowGrayed, write=SetAllowGrayed, default=0};
	__property Vcl::Stdctrls::TCheckBoxState State = {read=GetState, write=SetState, default=0};
	__property TabStop = {default=1};
	__property bool WordWrap = {read=GetWordWrap, write=SetWordWrap, default=0};
	__property Color;
	__property OnClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxCheckBoxControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCheckBoxControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxRadioButtonControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Stdctrls::TRadioButton* FRadioButton;
	System::Classes::TAlignment __fastcall GetAlignment();
	bool __fastcall GetChecked();
	void __fastcall SetAlignment(const System::Classes::TAlignment Value);
	void __fastcall SetChecked(const bool Value);
	bool __fastcall GetWordWrap();
	void __fastcall SetWordWrap(const bool Value);
	
public:
	__fastcall virtual TfrxRadioButtonControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Stdctrls::TRadioButton* RadioButton = {read=FRadioButton};
	
__published:
	__property System::Classes::TAlignment Alignment = {read=GetAlignment, write=SetAlignment, default=1};
	__property Caption = {default=0};
	__property bool Checked = {read=GetChecked, write=SetChecked, default=0};
	__property TabStop = {default=1};
	__property bool WordWrap = {read=GetWordWrap, write=SetWordWrap, default=0};
	__property Color;
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxRadioButtonControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxRadioButtonControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxListBoxControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Stdctrls::TListBox* FListBox;
	System::Classes::TStrings* __fastcall GetItems();
	void __fastcall SetItems(System::Classes::TStrings* const Value);
	int __fastcall GetItemIndex();
	void __fastcall SetItemIndex(const int Value);
	
public:
	__fastcall virtual TfrxListBoxControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Stdctrls::TListBox* ListBox = {read=FListBox};
	__property int ItemIndex = {read=GetItemIndex, write=SetItemIndex, nodefault};
	
__published:
	__property Color;
	__property System::Classes::TStrings* Items = {read=GetItems, write=SetItems};
	__property TabStop = {default=1};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxListBoxControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxListBoxControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxComboBoxControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Stdctrls::TComboBox* FComboBox;
	Frxclass::TfrxNotifyEvent FOnChange;
	int __fastcall GetItemIndex();
	System::Classes::TStrings* __fastcall GetItems();
	Vcl::Stdctrls::TComboBoxStyle __fastcall GetStyle();
	System::UnicodeString __fastcall GetText();
	void __fastcall DoOnChange(System::TObject* Sender);
	void __fastcall SetItemIndex(const int Value);
	void __fastcall SetItems(System::Classes::TStrings* const Value);
	void __fastcall SetStyle(const Vcl::Stdctrls::TComboBoxStyle Value);
	void __fastcall SetText(const System::UnicodeString Value);
	
protected:
	virtual System::Uitypes::TEditCharCase __fastcall GetCharCase();
	virtual void __fastcall SetCharCase(const System::Uitypes::TEditCharCase Value);
	
public:
	__fastcall virtual TfrxComboBoxControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Stdctrls::TComboBox* ComboBox = {read=FComboBox};
	
__published:
	__property System::Uitypes::TEditCharCase CharCase = {read=GetCharCase, write=SetCharCase, default=0};
	__property Color;
	__property System::Classes::TStrings* Items = {read=GetItems, write=SetItems};
	__property Vcl::Stdctrls::TComboBoxStyle Style = {read=GetStyle, write=SetStyle, default=0};
	__property TabStop = {default=1};
	__property System::UnicodeString Text = {read=GetText, write=SetText};
	__property int ItemIndex = {read=GetItemIndex, write=SetItemIndex, nodefault};
	__property Frxclass::TfrxNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxComboBoxControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxComboBoxControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxPanelControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Extctrls::TPanel* FPanel;
	System::Classes::TAlignment __fastcall GetAlignment();
	Vcl::Controls::TBevelCut __fastcall GetBevelInner();
	Vcl::Controls::TBevelCut __fastcall GetBevelOuter();
	int __fastcall GetBevelWidth();
	void __fastcall SetAlignment(const System::Classes::TAlignment Value);
	void __fastcall SetBevelInner(const Vcl::Controls::TBevelCut Value);
	void __fastcall SetBevelOuter(const Vcl::Controls::TBevelCut Value);
	void __fastcall SetBevelWidth(const int Value);
	
public:
	__fastcall virtual TfrxPanelControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Extctrls::TPanel* Panel = {read=FPanel};
	
__published:
	__property System::Classes::TAlignment Alignment = {read=GetAlignment, write=SetAlignment, default=2};
	__property Vcl::Controls::TBevelCut BevelInner = {read=GetBevelInner, write=SetBevelInner, default=0};
	__property Vcl::Controls::TBevelCut BevelOuter = {read=GetBevelOuter, write=SetBevelOuter, default=2};
	__property int BevelWidth = {read=GetBevelWidth, write=SetBevelWidth, default=1};
	__property Caption = {default=0};
	__property Color;
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxPanelControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxPanelControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxGroupBoxControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Stdctrls::TGroupBox* FGroupBox;
	
public:
	__fastcall virtual TfrxGroupBoxControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Stdctrls::TGroupBox* GroupBox = {read=FGroupBox};
	
__published:
	__property Caption = {default=0};
	__property Color;
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxGroupBoxControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxGroupBoxControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDateEditControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Comctrls::TDateTimePicker* FDateEdit;
	Frxclass::TfrxNotifyEvent FOnChange;
	bool FWeekNumbers;
	System::TDate __fastcall GetDate();
	System::TTime __fastcall GetTime();
	Vcl::Comctrls::TDTDateFormat __fastcall GetDateFormat();
	Vcl::Comctrls::TDateTimeKind __fastcall GetKind();
	void __fastcall DoOnChange(System::TObject* Sender);
	void __fastcall SetDate(const System::TDate Value);
	void __fastcall SetTime(const System::TTime Value);
	void __fastcall SetDateFormat(const Vcl::Comctrls::TDTDateFormat Value);
	void __fastcall SetKind(const Vcl::Comctrls::TDateTimeKind Value);
	void __fastcall DropDown(System::TObject* Sender);
	
public:
	__fastcall virtual TfrxDateEditControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Comctrls::TDateTimePicker* DateEdit = {read=FDateEdit};
	
__published:
	__property Color;
	__property System::TDate Date = {read=GetDate, write=SetDate};
	__property Vcl::Comctrls::TDTDateFormat DateFormat = {read=GetDateFormat, write=SetDateFormat, default=0};
	__property Vcl::Comctrls::TDateTimeKind Kind = {read=GetKind, write=SetKind, default=0};
	__property TabStop = {default=1};
	__property System::TTime Time = {read=GetTime, write=SetTime};
	__property bool WeekNumbers = {read=FWeekNumbers, write=FWeekNumbers, nodefault};
	__property Frxclass::TfrxNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxDateEditControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDateEditControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxImageControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Extctrls::TImage* FImage;
	bool __fastcall GetAutoSize();
	bool __fastcall GetCenter();
	Vcl::Graphics::TPicture* __fastcall GetPicture();
	bool __fastcall GetStretch();
	void __fastcall SetAutoSize(const bool Value);
	void __fastcall SetCenter(const bool Value);
	void __fastcall SetPicture(Vcl::Graphics::TPicture* const Value);
	void __fastcall SetStretch(const bool Value);
	
public:
	__fastcall virtual TfrxImageControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Extctrls::TImage* Image = {read=FImage};
	
__published:
	__property bool AutoSize = {read=GetAutoSize, write=SetAutoSize, default=0};
	__property bool Center = {read=GetCenter, write=SetCenter, default=0};
	__property Vcl::Graphics::TPicture* Picture = {read=GetPicture, write=SetPicture};
	__property bool Stretch = {read=GetStretch, write=SetStretch, default=0};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxImageControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxImageControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxBevelControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Extctrls::TBevel* FBevel;
	Vcl::Extctrls::TBevelShape __fastcall GetBevelShape();
	Vcl::Extctrls::TBevelStyle __fastcall GetBevelStyle();
	void __fastcall SetBevelShape(const Vcl::Extctrls::TBevelShape Value);
	void __fastcall SetBevelStyle(const Vcl::Extctrls::TBevelStyle Value);
	
public:
	__fastcall virtual TfrxBevelControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Extctrls::TBevel* Bevel = {read=FBevel};
	
__published:
	__property Vcl::Extctrls::TBevelShape Shape = {read=GetBevelShape, write=SetBevelShape, default=0};
	__property Vcl::Extctrls::TBevelStyle Style = {read=GetBevelStyle, write=SetBevelStyle, default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxBevelControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxBevelControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxBitBtnControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Buttons::TBitBtn* FBitBtn;
	Vcl::Graphics::TBitmap* __fastcall GetGlyph();
	Vcl::Buttons::TBitBtnKind __fastcall GetKind();
	Vcl::Buttons::TButtonLayout __fastcall GetLayout();
	int __fastcall GetMargin();
	System::Uitypes::TModalResult __fastcall GetModalResult();
	int __fastcall GetSpacing();
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* const Value);
	void __fastcall SetKind(const Vcl::Buttons::TBitBtnKind Value);
	void __fastcall SetLayout(const Vcl::Buttons::TButtonLayout Value);
	void __fastcall SetMargin(const int Value);
	void __fastcall SetModalResult(const System::Uitypes::TModalResult Value);
	void __fastcall SetSpacing(const int Value);
	int __fastcall GetNumGlyphs();
	void __fastcall SetNumGlyphs(const int Value);
	bool __fastcall GetWordWrap();
	void __fastcall SetWordWrap(const bool Value);
	
public:
	__fastcall virtual TfrxBitBtnControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Buttons::TBitBtn* BitBtn = {read=FBitBtn};
	
__published:
	__property Vcl::Graphics::TBitmap* Glyph = {read=GetGlyph, write=SetGlyph};
	__property Vcl::Buttons::TBitBtnKind Kind = {read=GetKind, write=SetKind, default=0};
	__property Caption = {default=0};
	__property Vcl::Buttons::TButtonLayout Layout = {read=GetLayout, write=SetLayout, default=0};
	__property int Margin = {read=GetMargin, write=SetMargin, default=-1};
	__property System::Uitypes::TModalResult ModalResult = {read=GetModalResult, write=SetModalResult, default=0};
	__property int NumGlyphs = {read=GetNumGlyphs, write=SetNumGlyphs, default=1};
	__property int Spacing = {read=GetSpacing, write=SetSpacing, default=4};
	__property bool WordWrap = {read=GetWordWrap, write=SetWordWrap, default=0};
	__property TabStop = {default=1};
	__property OnClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxBitBtnControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxBitBtnControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxSpeedButtonControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Buttons::TSpeedButton* FSpeedButton;
	bool __fastcall GetAllowAllUp();
	bool __fastcall GetDown();
	bool __fastcall GetFlat();
	Vcl::Graphics::TBitmap* __fastcall GetGlyph();
	int __fastcall GetGroupIndex();
	Vcl::Buttons::TButtonLayout __fastcall GetLayout();
	int __fastcall GetMargin();
	int __fastcall GetSpacing();
	void __fastcall SetAllowAllUp(const bool Value);
	void __fastcall SetDown(const bool Value);
	void __fastcall SetFlat(const bool Value);
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* const Value);
	void __fastcall SetGroupIndex(const int Value);
	void __fastcall SetLayout(const Vcl::Buttons::TButtonLayout Value);
	void __fastcall SetMargin(const int Value);
	void __fastcall SetSpacing(const int Value);
	
public:
	__fastcall virtual TfrxSpeedButtonControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Buttons::TSpeedButton* SpeedButton = {read=FSpeedButton};
	
__published:
	__property bool AllowAllUp = {read=GetAllowAllUp, write=SetAllowAllUp, default=0};
	__property Caption = {default=0};
	__property bool Down = {read=GetDown, write=SetDown, default=0};
	__property bool Flat = {read=GetFlat, write=SetFlat, default=0};
	__property Vcl::Graphics::TBitmap* Glyph = {read=GetGlyph, write=SetGlyph};
	__property int GroupIndex = {read=GetGroupIndex, write=SetGroupIndex, nodefault};
	__property Vcl::Buttons::TButtonLayout Layout = {read=GetLayout, write=SetLayout, default=0};
	__property int Margin = {read=GetMargin, write=SetMargin, default=-1};
	__property int Spacing = {read=GetSpacing, write=SetSpacing, default=4};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxSpeedButtonControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxSpeedButtonControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxMaskEditControl : public TfrxCustomEditControl
{
	typedef TfrxCustomEditControl inherited;
	
private:
	Vcl::Mask::TMaskEdit* FMaskEdit;
	System::UnicodeString __fastcall GetEditMask();
	void __fastcall SetEditMask(const System::UnicodeString Value);
	
protected:
	virtual System::Uitypes::TEditCharCase __fastcall GetCharCase();
	virtual void __fastcall SetCharCase(const System::Uitypes::TEditCharCase Value);
	
public:
	__fastcall virtual TfrxMaskEditControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Mask::TMaskEdit* MaskEdit = {read=FMaskEdit};
	
__published:
	__property CharCase = {default=0};
	__property Color;
	__property System::UnicodeString EditMask = {read=GetEditMask, write=SetEditMask};
	__property MaxLength;
	__property ReadOnly = {default=0};
	__property TabStop = {default=1};
	__property Text = {default=0};
	__property OnChange = {default=0};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxMaskEditControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxMaskEditControl(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomEditControl(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxCheckListBoxControl : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Vcl::Checklst::TCheckListBox* FCheckListBox;
	bool __fastcall GetAllowGrayed();
	System::Classes::TStrings* __fastcall GetItems();
	bool __fastcall GetSorted();
	bool __fastcall GetChecked(int Index);
	Vcl::Stdctrls::TCheckBoxState __fastcall GetState(int Index);
	void __fastcall SetAllowGrayed(const bool Value);
	void __fastcall SetItems(System::Classes::TStrings* const Value);
	void __fastcall SetSorted(const bool Value);
	void __fastcall SetChecked(int Index, const bool Value);
	void __fastcall SetState(int Index, const Vcl::Stdctrls::TCheckBoxState Value);
	int __fastcall GetItemIndex();
	void __fastcall SetItemIndex(const int Value);
	
public:
	__fastcall virtual TfrxCheckListBoxControl(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Checklst::TCheckListBox* CheckListBox = {read=FCheckListBox};
	__property bool Checked[int Index] = {read=GetChecked, write=SetChecked};
	__property int ItemIndex = {read=GetItemIndex, write=SetItemIndex, nodefault};
	__property Vcl::Stdctrls::TCheckBoxState State[int Index] = {read=GetState, write=SetState};
	
__published:
	__property bool AllowGrayed = {read=GetAllowGrayed, write=SetAllowGrayed, default=0};
	__property Color;
	__property System::Classes::TStrings* Items = {read=GetItems, write=SetItems};
	__property bool Sorted = {read=GetSorted, write=SetSorted, default=0};
	__property TabStop = {default=1};
	__property OnClick = {default=0};
	__property OnDblClick = {default=0};
	__property OnEnter = {default=0};
	__property OnExit = {default=0};
	__property OnKeyDown = {default=0};
	__property OnKeyPress = {default=0};
	__property OnKeyUp = {default=0};
	__property OnMouseDown = {default=0};
	__property OnMouseMove = {default=0};
	__property OnMouseUp = {default=0};
public:
	/* TfrxDialogControl.Destroy */ inline __fastcall virtual ~TfrxCheckListBoxControl() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCheckListBoxControl(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxdctrl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDCTRL)
using namespace Frxdctrl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdctrlHPP
