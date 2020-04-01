// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxSynMemo.pas' rev: 33.00 (Windows)

#ifndef FrxsynmemoHPP
#define FrxsynmemoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <Winapi.Imm.hpp>
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <frxCtrls.hpp>
#include <fs_iparser.hpp>
#include <frxPopupForm.hpp>
#include <fs_xml.hpp>
#include <fs_iinterpreter.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxsynmemo
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxBreakPoint;
class DELPHICLASS TfrxCompletionItem;
class DELPHICLASS TfrxCompletionList;
class DELPHICLASS TfrxCodeCompletionThread;
class DELPHICLASS TfrxSyntaxMemo;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TCharAttr : unsigned char { caNo, caText, caBlock, caComment, caKeyword, caString, caNumber };

typedef System::Set<TCharAttr, TCharAttr::caNo, TCharAttr::caNumber> TCharAttributes;

typedef void __fastcall (__closure *TfrxCodeCompletionEvent)(const System::UnicodeString Name, TfrxCompletionList* List);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxBreakPoint : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString FCondition;
	System::UnicodeString FSpecialCondition;
	bool FEnabled;
	int FLine;
	
public:
	__property System::UnicodeString Condition = {read=FCondition, write=FCondition};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
	__property int Line = {read=FLine, write=FLine, nodefault};
	__property System::UnicodeString SpecialCondition = {read=FSpecialCondition, write=FSpecialCondition};
public:
	/* TObject.Create */ inline __fastcall TfrxBreakPoint() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxBreakPoint() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TfrxItemType : unsigned char { itVar, itProcedure, itFunction, itProperty, itIndex, itConstant, itConstructor, itType, itEvent };

typedef System::Set<TfrxItemType, TfrxItemType::itVar, TfrxItemType::itEvent> TfrxItemTypes;

enum DECLSPEC_DENUM TfrxCompletionListType : unsigned char { cltRtti, cltScript, cltAddon };

typedef System::Set<TfrxCompletionListType, TfrxCompletionListType::cltRtti, TfrxCompletionListType::cltAddon> TfrxCompletionListTypes;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCompletionItem : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfrxCompletionItem* FParent;
	System::UnicodeString FName;
	System::UnicodeString FType;
	System::UnicodeString FParams;
	TfrxItemType FItemType;
	int FStartVisible;
	int FEndVisible;
	
public:
	__property System::UnicodeString Name = {read=FName};
	__property System::UnicodeString Typ = {read=FType};
	__property System::UnicodeString Params = {read=FParams};
	__property TfrxItemType ItemType = {read=FItemType, nodefault};
public:
	/* TObject.Create */ inline __fastcall TfrxCompletionItem() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxCompletionItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCompletionList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxCompletionItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Classes::TStringList* FConstants;
	System::Classes::TStringList* FVariables;
	System::Classes::TStringList* FFunctions;
	System::Classes::TStringList* FClasses;
	bool FLocked;
	TfrxCompletionItem* __fastcall AddBaseVar(System::Classes::TStrings* varList, System::UnicodeString Name, System::UnicodeString sType, int VisibleStart = 0x0, int VisibleEnd = 0xffffffff, System::UnicodeString ParentFunc = System::UnicodeString());
	TfrxCompletionItem* __fastcall GetItem(int Index);
	
public:
	__fastcall TfrxCompletionList();
	__fastcall virtual ~TfrxCompletionList();
	void __fastcall DestroyItems();
	int __fastcall Count();
	TfrxCompletionItem* __fastcall AddConstant(System::UnicodeString Name, System::UnicodeString sType, int VisibleStart = 0x0, int VisibleEnd = 0xffffffff, System::UnicodeString ParentFunc = System::UnicodeString());
	TfrxCompletionItem* __fastcall AddVariable(System::UnicodeString Name, System::UnicodeString sType, int VisibleStart = 0x0, int VisibleEnd = 0xffffffff, System::UnicodeString ParentFunc = System::UnicodeString());
	TfrxCompletionItem* __fastcall AddClass(System::UnicodeString Name, System::UnicodeString sType, int VisibleStart = 0x0, int VisibleEnd = 0xffffffff, System::UnicodeString ParentFunc = System::UnicodeString());
	TfrxCompletionItem* __fastcall AddFunction(System::UnicodeString Name, System::UnicodeString sType, System::UnicodeString Params, int VisibleStart = 0x0, int VisibleEnd = 0xffffffff, System::UnicodeString ParentFunc = System::UnicodeString());
	TfrxCompletionItem* __fastcall Find(System::UnicodeString Name);
	__property TfrxCompletionItem* Items[int Index] = {read=GetItem/*, default*/};
	__property bool Locked = {read=FLocked, write=FLocked, nodefault};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxCodeCompletionThread : public System::Classes::TThread
{
	typedef System::Classes::TThread inherited;
	
private:
	System::Classes::TStringList* FText;
	Fs_iinterpreter::TfsScript* FScript;
	Fs_iinterpreter::TfsScript* FOriginalScript;
	System::Classes::TStream* FILCode;
	Fs_xml::TfsXMLDocument* FXML;
	TfrxCompletionList* FCompletionList;
	System::UnicodeString FSyntaxType;
	void __fastcall SyncScript();
	void __fastcall UpdateCode();
	void __fastcall FreeScript();
	void __fastcall FillCodeCompletion();
	
public:
	__fastcall virtual ~TfrxCodeCompletionThread();
	virtual void __fastcall Execute();
	__property Fs_iinterpreter::TfsScript* Script = {read=FOriginalScript, write=FOriginalScript};
public:
	/* TThread.Create */ inline __fastcall TfrxCodeCompletionThread()/* overload */ : System::Classes::TThread() { }
	/* TThread.Create */ inline __fastcall TfrxCodeCompletionThread(bool CreateSuspended)/* overload */ : System::Classes::TThread(CreateSuspended) { }
	/* TThread.Create */ inline __fastcall TfrxCodeCompletionThread(bool CreateSuspended, NativeUInt ReservedStackSize)/* overload */ : System::Classes::TThread(CreateSuspended, ReservedStackSize) { }
	
};


class PASCALIMPLEMENTATION TfrxSyntaxMemo : public Frxctrls::TfrxScrollWin
{
	typedef Frxctrls::TfrxScrollWin inherited;
	
private:
	int FActiveLine;
	bool FAllowLinesChange;
	System::Uitypes::TColor FBlockColor;
	System::Uitypes::TColor FBlockFontColor;
	System::StaticArray<int, 10> FBookmarks;
	int FCharHeight;
	int FCharWidth;
	Vcl::Graphics::TFont* FCommentAttr;
	Frxpopupform::TfrxPopupForm* FCompletionForm;
	Vcl::Stdctrls::TListBox* FCompletionLB;
	bool FDoubleClicked;
	bool FDown;
	bool FToggleBreakPointDown;
	int FGutterWidth;
	bool FIsMonoType;
	Vcl::Graphics::TFont* FKeywordAttr;
	int FMaxLength;
	System::UnicodeString FMessage;
	bool FModified;
	bool FMoved;
	Vcl::Graphics::TFont* FNumberAttr;
	System::Types::TPoint FOffset;
	System::Classes::TNotifyEvent FOnChangePos;
	System::Classes::TNotifyEvent FOnChangeText;
	TfrxCodeCompletionEvent FOnCodeCompletion;
	Fs_iparser::TfsParser* FParser;
	System::Types::TPoint FPos;
	Vcl::Graphics::TFont* FStringAttr;
	System::Types::TPoint FSelEnd;
	System::Types::TPoint FSelStart;
	int FTabStops;
	System::Types::TPoint FCompSelStart;
	System::Types::TPoint FCompSelEnd;
	bool FShowGutter;
	System::Classes::TStrings* FSynStrings;
	System::UnicodeString FSyntax;
	System::Types::TPoint FTempPos;
	System::Classes::TStringList* FText;
	Vcl::Graphics::TFont* FTextAttr;
	System::Classes::TStringList* FUndo;
	bool FUpdatingSyntax;
	System::Types::TPoint FWindowSize;
	System::Classes::TStringList* FBreakPoints;
	System::Classes::TStringList* FCodeCompList;
	int FStartCodeCompPos;
	System::UnicodeString FCompleationFilter;
	Fs_xml::TfsXMLDocument* FScriptRTTIXML;
	TfrxCompletionList* FRttiCompletionList;
	TfrxCompletionList* FScriptCompletionList;
	TfrxCompletionList* FAddonCompletionList;
	TfrxCompletionList* FClassCompletionList;
	TfrxCodeCompletionThread* FCodeCompletionThread;
	Fs_iinterpreter::TfsScript* FScript;
	Vcl::Extctrls::TTimer* FTimer;
	bool FShowLineNumber;
	TfrxItemTypes FCodeComplitionFilter;
	TfrxCompletionListTypes FShowInCodeComplition;
	TCharAttributes __fastcall GetCharAttr(const System::Types::TPoint &Pos);
	int __fastcall GetLineBegin(int Index);
	int __fastcall GetPlainTextPos(const System::Types::TPoint &Pos);
	System::Types::TPoint __fastcall GetPosPlainText(int Pos);
	bool __fastcall GetRunLine(int Index);
	System::UnicodeString __fastcall GetSelText();
	HIDESBASE System::Classes::TStrings* __fastcall GetText();
	System::UnicodeString __fastcall LineAt(int Index);
	int __fastcall LineLength(int Index);
	System::UnicodeString __fastcall Pad(int n);
	void __fastcall AddSel();
	void __fastcall AddUndo();
	void __fastcall ClearSel();
	void __fastcall ClearSyntax(int ClearFrom);
	void __fastcall CompletionLBDblClick(System::TObject* Sender);
	void __fastcall CompletionLBDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall CompletionClose();
	void __fastcall CompletionLBKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall CompletionLBKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall CorrectBookmark(int Line, int Delta);
	void __fastcall CorrectBreakPoints(int Line, int Delta);
	void __fastcall CreateSynArray(int EndLine);
	void __fastcall DoBackspace();
	void __fastcall DoChange();
	void __fastcall DoChar(System::WideChar Ch);
	void __fastcall DoCodeCompletion();
	void __fastcall BuildCClist(System::UnicodeString sName);
	void __fastcall DoCtrlI();
	void __fastcall DoCtrlU();
	void __fastcall DoCtrlR();
	void __fastcall DoCtrlL();
	void __fastcall DoDel();
	void __fastcall DoDown();
	void __fastcall DoEnd(bool Ctrl);
	void __fastcall DoHome(bool Ctrl);
	void __fastcall DoLeft();
	void __fastcall DoPgUp();
	void __fastcall DoPgDn();
	void __fastcall DoReturn();
	void __fastcall DoRight();
	void __fastcall DoUp();
	void __fastcall EnterIndent();
	void __fastcall LinesChange(System::TObject* Sender);
	void __fastcall SetActiveLine(int Line);
	void __fastcall SetCommentAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetKeywordAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetNumberAttr(Vcl::Graphics::TFont* const Value);
	void __fastcall SetRunLine(int Index, const bool Value);
	void __fastcall SetSelText(const System::UnicodeString Value);
	void __fastcall SetShowGutter(bool Value);
	void __fastcall SetStringAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetSyntax(const System::UnicodeString Value);
	HIDESBASE void __fastcall SetText(System::Classes::TStrings* Value);
	void __fastcall SetTextAttr(Vcl::Graphics::TFont* Value);
	void __fastcall ShiftSelected(bool ShiftRight);
	void __fastcall ShowCaretPos();
	void __fastcall TabIndent();
	void __fastcall UnIndent();
	HIDESBASE void __fastcall UpdateScrollBar();
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMIMEStartComp(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMIMEEndComp(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMIMECOMPOSITION(Winapi::Messages::TMessage &Message);
	bool __fastcall GetTextSelected();
	void __fastcall SetGutterWidth(const int Value);
	void __fastcall SetShowInCodeComplition(const TfrxCompletionListTypes Value);
	
protected:
	DYNAMIC void __fastcall DblClick();
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall MouseWheelDown(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall MouseWheelUp(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	virtual void __fastcall OnHScrollChange(System::TObject* Sender);
	virtual void __fastcall OnVScrollChange(System::TObject* Sender);
	DYNAMIC void __fastcall Resize();
	System::UnicodeString __fastcall GetCompletionString();
	System::UnicodeString __fastcall GetFilter(System::UnicodeString aStr);
	void __fastcall DoTimer(System::TObject* Sender);
	
public:
	__fastcall virtual TfrxSyntaxMemo(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxSyntaxMemo();
	virtual void __fastcall Paint();
	void __fastcall CopyToClipboard();
	void __fastcall CutToClipboard();
	void __fastcall PasteFromClipboard();
	void __fastcall SelectAll();
	void __fastcall SetPos(int x, int y);
	void __fastcall ShowMessage(const System::UnicodeString s);
	void __fastcall Undo();
	void __fastcall UpdateView();
	void __fastcall ClearBreakPoints();
	bool __fastcall Find(const System::UnicodeString SearchText, bool CaseSensitive, int &SearchFrom);
	int __fastcall GetPlainPos();
	System::Types::TPoint __fastcall GetPos();
	int __fastcall IsBookmark(int Line);
	void __fastcall AddBookmark(int Line, int Number);
	void __fastcall DeleteBookmark(int Number);
	void __fastcall GotoBookmark(int Number);
	void __fastcall AddNewBreakPoint();
	void __fastcall AddBreakPoint(int Number, const System::UnicodeString Condition, const System::UnicodeString Special);
	void __fastcall ToggleBreakPoint(int Number, const System::UnicodeString Condition);
	void __fastcall DeleteBreakPoint(int Number);
	void __fastcall DeleteF4BreakPoints();
	bool __fastcall IsBreakPoint(int Number);
	bool __fastcall IsActiveBreakPoint(int Number);
	System::UnicodeString __fastcall GetBreakPointCondition(int Number);
	System::UnicodeString __fastcall GetBreakPointSpecialCondition(int Number);
	void __fastcall FillRtti();
	void __fastcall SavePBToIni(const System::UnicodeString IniPath, const System::UnicodeString Section);
	void __fastcall LoadPBFromIni(const System::UnicodeString IniPath, const System::UnicodeString Section);
	__property TfrxCodeCompletionThread* CodeCompletionThread = {read=FCodeCompletionThread};
	__property int ActiveLine = {read=FActiveLine, write=SetActiveLine, nodefault};
	__property System::Uitypes::TColor BlockColor = {read=FBlockColor, write=FBlockColor, nodefault};
	__property System::Uitypes::TColor BlockFontColor = {read=FBlockFontColor, write=FBlockFontColor, nodefault};
	__property System::Classes::TStringList* BreakPoints = {read=FBreakPoints};
	__property Color = {default=-16777211};
	__property Vcl::Graphics::TFont* CommentAttr = {read=FCommentAttr, write=SetCommentAttr};
	__property TfrxItemTypes CodeComplitionFilter = {read=FCodeComplitionFilter, write=FCodeComplitionFilter, nodefault};
	__property TfrxCompletionListTypes ShowInCodeComplition = {read=FShowInCodeComplition, write=SetShowInCodeComplition, nodefault};
	__property Font;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property int TabStops = {read=FTabStops, write=FTabStops, nodefault};
	__property int GutterWidth = {read=FGutterWidth, write=SetGutterWidth, nodefault};
	__property Vcl::Graphics::TFont* KeywordAttr = {read=FKeywordAttr, write=SetKeywordAttr};
	__property bool Modified = {read=FModified, write=FModified, nodefault};
	__property Vcl::Graphics::TFont* NumberAttr = {read=FNumberAttr, write=SetNumberAttr};
	__property bool RunLine[int Index] = {read=GetRunLine, write=SetRunLine};
	__property System::UnicodeString SelText = {read=GetSelText, write=SetSelText};
	__property Vcl::Graphics::TFont* StringAttr = {read=FStringAttr, write=SetStringAttr};
	__property Vcl::Graphics::TFont* TextAttr = {read=FTextAttr, write=SetTextAttr};
	__property System::Classes::TStrings* Lines = {read=GetText, write=SetText};
	__property System::UnicodeString Syntax = {read=FSyntax, write=SetSyntax};
	__property Fs_iinterpreter::TfsScript* Script = {read=FScript, write=FScript};
	__property bool ShowGutter = {read=FShowGutter, write=SetShowGutter, nodefault};
	__property bool ShowLineNumber = {read=FShowLineNumber, write=FShowLineNumber, nodefault};
	__property bool TextSelected = {read=GetTextSelected, nodefault};
	__property Fs_xml::TfsXMLDocument* ScriptRTTIXML = {read=FScriptRTTIXML};
	__property System::Classes::TNotifyEvent OnChangePos = {read=FOnChangePos, write=FOnChangePos};
	__property System::Classes::TNotifyEvent OnChangeText = {read=FOnChangeText, write=FOnChangeText};
	__property TfrxCodeCompletionEvent OnCodeCompletion = {read=FOnCodeCompletion, write=FOnCodeCompletion};
	__property OnDragDrop;
	__property OnDragOver;
	__property OnKeyDown;
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxSyntaxMemo(HWND ParentWindow) : Frxctrls::TfrxScrollWin(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxsynmemo */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXSYNMEMO)
using namespace Frxsynmemo;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxsynmemoHPP
