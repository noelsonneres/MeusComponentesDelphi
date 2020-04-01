// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapColorRangeForm.pas' rev: 33.00 (Windows)

#ifndef FrxmapcolorrangeformHPP
#define FrxmapcolorrangeformHPP

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
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <frxMapRanges.hpp>
#include <frxMapHelpers.hpp>
#include <frxAnaliticGeometry.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmapcolorrangeform
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TColorRangeItem;
class DELPHICLASS TColorRangeCollection;
class DELPHICLASS TMapColorRangeForm;
class DELPHICLASS TfrxColorRanges;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TColorRangeItem : public Frxmapranges::TMapRangeItem
{
	typedef Frxmapranges::TMapRangeItem inherited;
	
private:
	bool FAutoColor;
	System::Uitypes::TColor FColor;
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	void __fastcall SetColorByForce(const System::Uitypes::TColor Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall virtual TColorRangeItem(System::Classes::TCollection* Collection);
	virtual void __fastcall Read(System::Classes::TReader* Reader);
	virtual void __fastcall Write(System::Classes::TWriter* Writer);
	bool __fastcall IsValueInside(System::Extended Value, System::Uitypes::TColor &OutColor);
	virtual System::UnicodeString __fastcall AsString(System::UnicodeString FValueFormat);
	
__published:
	__property bool AutoColor = {read=FAutoColor, write=FAutoColor, nodefault};
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, nodefault};
	__property System::Uitypes::TColor ColorByForce = {read=FColor, write=SetColorByForce, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TColorRangeItem() { }
	
};


class PASCALIMPLEMENTATION TColorRangeCollection : public Frxmapranges::TMapRangeCollection
{
	typedef Frxmapranges::TMapRangeCollection inherited;
	
public:
	TColorRangeItem* operator[](int Index) { return this->Items[Index]; }
	
protected:
	HIDESBASE TColorRangeItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TColorRangeItem* const Value);
	System::Uitypes::TColor __fastcall GetMixedColor(System::Uitypes::TColor C1, System::Uitypes::TColor C2, System::Extended p);
	
public:
	__fastcall TColorRangeCollection();
	HIDESBASE TColorRangeItem* __fastcall Add();
	System::Uitypes::TColor __fastcall GetColor(System::Extended Value);
	System::Uitypes::TColor __fastcall GetPeerColor(System::Uitypes::TColor StartColor, System::Uitypes::TColor MiddleColor, System::Uitypes::TColor EndColor, System::Extended Value);
	System::Uitypes::TColor __fastcall GetPeerPartColor(System::Uitypes::TColor StartColor, System::Uitypes::TColor MiddleColor, System::Uitypes::TColor EndColor, System::Extended Part);
	void __fastcall FillRangeColors(int StartIndex, int EndIndex);
	__property TColorRangeItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TColorRangeCollection() { }
	
};


class PASCALIMPLEMENTATION TMapColorRangeForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TListBox* CollectionListBox;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Extctrls::TColorBox* ColorColorBox;
	Vcl::Stdctrls::TEdit* StartEdit;
	Vcl::Stdctrls::TEdit* EndEdit;
	Vcl::Stdctrls::TCheckBox* ColorCheckBox;
	Vcl::Stdctrls::TCheckBox* StartCheckBox;
	Vcl::Stdctrls::TCheckBox* EndCheckBox;
	Vcl::Stdctrls::TLabel* AutoLabel;
	Vcl::Stdctrls::TButton* AddButton;
	Vcl::Stdctrls::TButton* DeleteButton;
	Vcl::Buttons::TSpeedButton* UpSpeedButton;
	Vcl::Buttons::TSpeedButton* DownSpeedButton;
	Vcl::Extctrls::TBevel* Bevel1;
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall CollectionListBoxClick(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall ColorCheckBoxClick(System::TObject* Sender);
	void __fastcall StartEditChange(System::TObject* Sender);
	void __fastcall AddButtonClick(System::TObject* Sender);
	void __fastcall DeleteButtonClick(System::TObject* Sender);
	void __fastcall UpSpeedButtonClick(System::TObject* Sender);
	void __fastcall DownSpeedButtonClick(System::TObject* Sender);
	
private:
	TColorRangeCollection* FEditedCollection;
	System::UnicodeString FValueFormat;
	int FPreviousItemIndex;
	void __fastcall RefillCollectionListBox(const int ItemIndex);
	void __fastcall Syncronize();
	void __fastcall UpdateControls();
	
public:
	void __fastcall SetCollection(TColorRangeCollection* CRCollection);
	TColorRangeCollection* __fastcall GetCollection();
	__property System::UnicodeString ValueFormat = {read=FValueFormat, write=FValueFormat};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TMapColorRangeForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TMapColorRangeForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TMapColorRangeForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TMapColorRangeForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxColorRanges : public Frxmapranges::TMapRanges
{
	typedef Frxmapranges::TMapRanges inherited;
	
private:
	TColorRangeCollection* FColorRangeCollection;
	System::Uitypes::TColor FStartColor;
	System::Uitypes::TColor FMiddleColor;
	System::Uitypes::TColor FEndColor;
	void __fastcall SetColorRangeCollection(TColorRangeCollection* const Value);
	
protected:
	virtual void __fastcall DrawContent(Vcl::Graphics::TCanvas* Canvas);
	void __fastcall FillRangeColors();
	
public:
	__fastcall TfrxColorRanges(Frxmapranges::TMapScale* MapScale);
	void __fastcall Fill(const Frxanaliticgeometry::TDoubleArray Values);
	__property TColorRangeCollection* ColorRangeCollection = {read=FColorRangeCollection, write=SetColorRangeCollection};
	
__published:
	System::Uitypes::TColor __fastcall GetColor(System::Extended Value);
	__property System::Uitypes::TColor StartColor = {read=FStartColor, write=FStartColor, nodefault};
	__property System::Uitypes::TColor MiddleColor = {read=FMiddleColor, write=FMiddleColor, nodefault};
	__property System::Uitypes::TColor EndColor = {read=FEndColor, write=FEndColor, nodefault};
public:
	/* TMapRanges.Destroy */ inline __fastcall virtual ~TfrxColorRanges() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxmapcolorrangeform */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPCOLORRANGEFORM)
using namespace Frxmapcolorrangeform;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmapcolorrangeformHPP
