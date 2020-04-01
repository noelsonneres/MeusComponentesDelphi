// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapSizeRangeForm.pas' rev: 33.00 (Windows)

#ifndef FrxmapsizerangeformHPP
#define FrxmapsizerangeformHPP

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

//-- user supplied -----------------------------------------------------------

namespace Frxmapsizerangeform
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TSizeRangeItem;
class DELPHICLASS TSizeRangeCollection;
class DELPHICLASS TMapSizeRangeForm;
class DELPHICLASS TfrxSizeRanges;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TSizeRangeItem : public Frxmapranges::TMapRangeItem
{
	typedef Frxmapranges::TMapRangeItem inherited;
	
private:
	bool FAutoSize;
	System::Extended FSize;
	void __fastcall SetSize(const System::Extended Value);
	void __fastcall SetSizeByForce(const System::Extended Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall virtual TSizeRangeItem(System::Classes::TCollection* Collection);
	virtual void __fastcall Read(System::Classes::TReader* Reader);
	virtual void __fastcall Write(System::Classes::TWriter* Writer);
	bool __fastcall IsValueInside(System::Extended Value, System::Extended &OutSize);
	virtual System::UnicodeString __fastcall AsString(System::UnicodeString FValueFormat);
	
__published:
	__property bool AutoSize = {read=FAutoSize, write=FAutoSize, nodefault};
	__property System::Extended Size = {read=FSize, write=SetSize};
	__property System::Extended SizeByForce = {read=FSize, write=SetSizeByForce};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TSizeRangeItem() { }
	
};


class PASCALIMPLEMENTATION TSizeRangeCollection : public Frxmapranges::TMapRangeCollection
{
	typedef Frxmapranges::TMapRangeCollection inherited;
	
public:
	TSizeRangeItem* operator[](int Index) { return this->Items[Index]; }
	
protected:
	HIDESBASE TSizeRangeItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TSizeRangeItem* const Value);
	System::Extended __fastcall GetMixedSize(System::Extended Size1, System::Extended Size2, System::Extended p);
	
public:
	__fastcall TSizeRangeCollection();
	HIDESBASE TSizeRangeItem* __fastcall Add();
	System::Extended __fastcall GetSize(System::Extended Value);
	System::Extended __fastcall GetPeerSize(System::Extended StartSize, System::Extended EndSize, System::Extended Value);
	void __fastcall FillRangeSizes(int StartIndex, int EndIndex);
	__property TSizeRangeItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TSizeRangeCollection() { }
	
};


class PASCALIMPLEMENTATION TMapSizeRangeForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TListBox* CollectionListBox;
	Vcl::Stdctrls::TEdit* SizeEdit;
	Vcl::Stdctrls::TEdit* StartEdit;
	Vcl::Stdctrls::TEdit* EndEdit;
	Vcl::Stdctrls::TCheckBox* SizeCheckBox;
	Vcl::Stdctrls::TCheckBox* StartCheckBox;
	Vcl::Stdctrls::TCheckBox* EndCheckBox;
	Vcl::Stdctrls::TLabel* AutoLabel;
	Vcl::Stdctrls::TButton* OkB;
	Vcl::Stdctrls::TButton* CancelB;
	Vcl::Extctrls::TBevel* Bevel1;
	Vcl::Stdctrls::TButton* AddButton;
	Vcl::Stdctrls::TButton* DeleteButton;
	Vcl::Buttons::TSpeedButton* UpSpeedButton;
	Vcl::Buttons::TSpeedButton* DownSpeedButton;
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall CollectionListBoxClick(System::TObject* Sender);
	void __fastcall OkBClick(System::TObject* Sender);
	void __fastcall SizeCheckBoxClick(System::TObject* Sender);
	void __fastcall StartEditChange(System::TObject* Sender);
	void __fastcall AddButtonClick(System::TObject* Sender);
	void __fastcall DeleteButtonClick(System::TObject* Sender);
	void __fastcall UpSpeedButtonClick(System::TObject* Sender);
	void __fastcall DownSpeedButtonClick(System::TObject* Sender);
	
private:
	TSizeRangeCollection* FEditedCollection;
	System::UnicodeString FValueFormat;
	int FPreviousItemIndex;
	void __fastcall RefillCollectionListBox(const int ItemIndex);
	void __fastcall Syncronize();
	void __fastcall UpdateControls();
	
public:
	void __fastcall SetCollection(TSizeRangeCollection* SRCollection);
	TSizeRangeCollection* __fastcall GetCollection();
	__property System::UnicodeString ValueFormat = {read=FValueFormat, write=FValueFormat};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TMapSizeRangeForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TMapSizeRangeForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TMapSizeRangeForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TMapSizeRangeForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrxSizeRanges : public Frxmapranges::TMapRanges
{
	typedef Frxmapranges::TMapRanges inherited;
	
private:
	TSizeRangeCollection* FSizeRangeCollection;
	System::Extended FStartSize;
	System::Extended FEndSize;
	void __fastcall SetSizeRangeCollection(TSizeRangeCollection* const Value);
	
protected:
	virtual void __fastcall DrawContent(Vcl::Graphics::TCanvas* Canvas);
	void __fastcall FillRangeSizes();
	virtual int __fastcall GetSpaceWidth();
	virtual int __fastcall GetStepWidth();
	virtual int __fastcall GetContentHeight();
	
public:
	__fastcall TfrxSizeRanges(Frxmapranges::TMapScale* MapScale);
	void __fastcall Fill(const Frxanaliticgeometry::TDoubleArray Values);
	__property TSizeRangeCollection* SizeRangeCollection = {read=FSizeRangeCollection, write=SetSizeRangeCollection};
	
__published:
	System::Extended __fastcall GetSize(System::Extended Value);
	__property System::Extended StartSize = {read=FStartSize, write=FStartSize};
	__property System::Extended EndSize = {read=FEndSize, write=FEndSize};
public:
	/* TMapRanges.Destroy */ inline __fastcall virtual ~TfrxSizeRanges() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxmapsizerangeform */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPSIZERANGEFORM)
using namespace Frxmapsizerangeform;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmapsizerangeformHPP
