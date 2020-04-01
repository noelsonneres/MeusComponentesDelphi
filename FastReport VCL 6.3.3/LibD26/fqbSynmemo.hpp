// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fqbSynmemo.pas' rev: 33.00 (Windows)

#ifndef FqbsynmemoHPP
#define FqbsynmemoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Graphics.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fqbsynmemo
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfqbSyntaxMemo;
class DELPHICLASS TfqbSynMemoSearch;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TSyntaxType : unsigned char { stPascal, stCpp, stSQL, stText };

enum DECLSPEC_DENUM TCharAttr : unsigned char { caNone, caText, caBlock, caComment, caKeyword, caString };

typedef System::Set<TCharAttr, TCharAttr::caNone, TCharAttr::caString> TCharAttributes;

class PASCALIMPLEMENTATION TfqbSyntaxMemo : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
	
private:
	typedef System::DynamicArray<int> _TfqbSyntaxMemo__1;
	
	
private:
	bool FAllowLinesChange;
	int FCharHeight;
	int FCharWidth;
	bool FDoubleClicked;
	bool FDown;
	int FGutterWidth;
	int FFooterHeight;
	bool FIsMonoType;
	System::UnicodeString FKeywords;
	int FMaxLength;
	System::UnicodeString FMessage;
	bool FModified;
	bool FMoved;
	System::Types::TPoint FOffset;
	System::Types::TPoint FPos;
	bool FReadOnly;
	System::Types::TPoint FSelEnd;
	System::Types::TPoint FSelStart;
	System::Classes::TStrings* FSynStrings;
	TSyntaxType FSyntaxType;
	System::Types::TPoint FTempPos;
	System::Classes::TStringList* FText;
	Vcl::Graphics::TFont* FKeywordAttr;
	Vcl::Graphics::TFont* FStringAttr;
	Vcl::Graphics::TFont* FTextAttr;
	Vcl::Graphics::TFont* FCommentAttr;
	System::Uitypes::TColor FBlockColor;
	System::Uitypes::TColor FBlockFontColor;
	System::Classes::TStringList* FUndo;
	bool FUpdating;
	bool FUpdatingSyntax;
	Vcl::Stdctrls::TScrollBar* FVScroll;
	System::Types::TPoint FWindowSize;
	Vcl::Menus::TPopupMenu* FPopupMenu;
	int KWheel;
	System::UnicodeString LastSearch;
	bool FShowGutter;
	bool FShowFooter;
	_TfqbSyntaxMemo__1 Bookmarks;
	int FActiveLine;
	HIDESBASE System::Classes::TStrings* __fastcall GetText();
	HIDESBASE void __fastcall SetText(System::Classes::TStrings* Value);
	void __fastcall SetSyntaxType(TSyntaxType Value);
	void __fastcall SetShowGutter(bool Value);
	void __fastcall SetShowFooter(bool Value);
	bool __fastcall FMemoFind(System::UnicodeString Text, System::Types::TPoint &Position);
	TCharAttributes __fastcall GetCharAttr(const System::Types::TPoint &Pos);
	int __fastcall GetLineBegin(int Index);
	int __fastcall GetPlainTextPos(const System::Types::TPoint &Pos);
	System::Types::TPoint __fastcall GetPosPlainText(int Pos);
	System::UnicodeString __fastcall GetSelText();
	System::UnicodeString __fastcall LineAt(int Index);
	int __fastcall LineLength(int Index);
	System::UnicodeString __fastcall Pad(int n);
	void __fastcall AddSel();
	void __fastcall AddUndo();
	void __fastcall ClearSel();
	void __fastcall CreateSynArray();
	void __fastcall DoChange();
	void __fastcall EnterIndent();
	void __fastcall SetSelText(System::UnicodeString Value);
	void __fastcall ShiftSelected(bool ShiftRight);
	void __fastcall ShowCaretPos();
	void __fastcall TabIndent();
	void __fastcall UnIndent();
	void __fastcall UpdateScrollBar();
	void __fastcall UpdateSyntax();
	void __fastcall DoLeft();
	void __fastcall DoRight();
	void __fastcall DoUp();
	void __fastcall DoDown();
	void __fastcall DoHome(bool Ctrl);
	void __fastcall DoEnd(bool Ctrl);
	void __fastcall DoPgUp();
	void __fastcall DoPgDn();
	void __fastcall DoChar(System::WideChar Ch);
	void __fastcall DoReturn();
	void __fastcall DoDel();
	void __fastcall DoBackspace();
	void __fastcall DoCtrlI();
	void __fastcall DoCtrlU();
	void __fastcall DoCtrlR();
	void __fastcall DoCtrlL();
	void __fastcall ScrollClick(System::TObject* Sender);
	void __fastcall ScrollEnter(System::TObject* Sender);
	void __fastcall LinesChange(System::TObject* Sender);
	void __fastcall ShowPos();
	void __fastcall BookmarkDraw(int Y, int line);
	void __fastcall ActiveLineDraw(int Y, int line);
	void __fastcall CorrectBookmark(int Line, int delta);
	void __fastcall SetKeywordAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetStringAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetTextAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetCommentAttr(Vcl::Graphics::TFont* Value);
	
protected:
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* Value);
	virtual System::Types::TRect __fastcall GetClientRect();
	DYNAMIC void __fastcall DblClick();
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	void __fastcall CopyPopup(System::TObject* Sender);
	void __fastcall PastePopup(System::TObject* Sender);
	void __fastcall CutPopup(System::TObject* Sender);
	void __fastcall MouseWheelUp(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall MouseWheelDown(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall DOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall DDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	
public:
	__fastcall virtual TfqbSyntaxMemo(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfqbSyntaxMemo();
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	virtual void __fastcall Paint();
	void __fastcall CopyToClipboard();
	void __fastcall CutToClipboard();
	void __fastcall PasteFromClipboard();
	void __fastcall SetPos(int x, int y);
	void __fastcall ShowMessage(System::UnicodeString s);
	void __fastcall Undo();
	void __fastcall UpdateView();
	System::Types::TPoint __fastcall GetPos();
	bool __fastcall Find(System::UnicodeString Text);
	__property bool Modified = {read=FModified, write=FModified, nodefault};
	__property System::UnicodeString SelText = {read=GetSelText, write=SetSelText};
	int __fastcall IsBookmark(int Line);
	void __fastcall AddBookmark(int Line, int Number);
	void __fastcall DeleteBookmark(int Number);
	void __fastcall GotoBookmark(int Number);
	void __fastcall SetActiveLine(int Line);
	int __fastcall GetActiveLine();
	
__published:
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property DragKind = {default=0};
	__property ParentBiDiMode = {default=1};
	__property Color = {default=-16777211};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Width;
	__property Height;
	__property Visible = {default=1};
	__property System::Uitypes::TColor BlockColor = {read=FBlockColor, write=FBlockColor, nodefault};
	__property System::Uitypes::TColor BlockFontColor = {read=FBlockFontColor, write=FBlockFontColor, nodefault};
	__property Vcl::Graphics::TFont* CommentAttr = {read=FCommentAttr, write=SetCommentAttr};
	__property Vcl::Graphics::TFont* KeywordAttr = {read=FKeywordAttr, write=SetKeywordAttr};
	__property Vcl::Graphics::TFont* StringAttr = {read=FStringAttr, write=SetStringAttr};
	__property Vcl::Graphics::TFont* TextAttr = {read=FTextAttr, write=SetTextAttr};
	__property System::Classes::TStrings* Lines = {read=GetText, write=SetText};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, nodefault};
	__property TSyntaxType SyntaxType = {read=FSyntaxType, write=SetSyntaxType, nodefault};
	__property bool ShowFooter = {read=FShowFooter, write=SetShowFooter, nodefault};
	__property bool ShowGutter = {read=FShowGutter, write=SetShowGutter, nodefault};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbSyntaxMemo(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfqbSynMemoSearch : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* Search;
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TEdit* Edit1;
	void __fastcall FormKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall FormCreate(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfqbSynMemoSearch(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfqbSynMemoSearch(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfqbSynMemoSearch() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbSynMemoSearch(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfqbSynMemoSearch* fqbSynMemoSearch;
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Fqbsynmemo */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FQBSYNMEMO)
using namespace Fqbsynmemo;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FqbsynmemoHPP
