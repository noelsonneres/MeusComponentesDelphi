// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxRichEdit.pas' rev: 33.00 (Windows)

#ifndef FrxricheditHPP
#define FrxricheditHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Win.ComObj.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <System.Types.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Dialogs.hpp>
#include <Winapi.RichEdit.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxrichedit
{
//-- forward type declarations -----------------------------------------------
struct TCharFormat2A;
struct TParaFormat2;
class DELPHICLASS TRxTextAttributes;
class DELPHICLASS TRxParaAttributes;
class DELPHICLASS TOEMConversion;
struct TRichConversionFormat;
class DELPHICLASS TRxCustomRichEdit;
class DELPHICLASS TRxRichEdit;
//-- type declarations -------------------------------------------------------
typedef System::Int8 TRichEditVersion;

typedef NativeInt frxInteger;

struct DECLSPEC_DRECORD TCharFormat2A
{
public:
	unsigned cbSize;
	unsigned dwMask;
	unsigned dwEffects;
	int yHeight;
	int yOffset;
	unsigned crTextColor;
	System::Byte bCharSet;
	System::Byte bPitchAndFamily;
	System::StaticArray<System::WideChar, 32> szFaceName;
	System::Word wWeight;
	short sSpacing;
	unsigned crBackColor;
	unsigned lid;
	unsigned dwReserved;
	short sStyle;
	System::Word wKerning;
	System::Byte bUnderlineType;
	System::Byte bAnimation;
	System::Byte bRevAuthor;
	System::Byte bReserved1;
};


typedef TCharFormat2A TCharFormat2;

struct DECLSPEC_DRECORD TParaFormat2
{
public:
	unsigned cbSize;
	unsigned dwMask;
	System::Word wNumbering;
	System::Word wReserved;
	int dxStartIndent;
	int dxRightIndent;
	int dxOffset;
	System::Word wAlignment;
	short cTabCount;
	System::StaticArray<int, 32> rgxTabs;
	int dySpaceBefore;
	int dySpaceAfter;
	int dyLineSpacing;
	short sStyle;
	System::Byte bLineSpacingRule;
	System::Byte bCRC;
	System::Word wShadingWeight;
	System::Word wShadingStyle;
	System::Word wNumberingStart;
	System::Word wNumberingStyle;
	System::Word wNumberingTab;
	System::Word wBorderSpace;
	System::Word wBorderWidth;
	System::Word wBorders;
};


enum DECLSPEC_DENUM TRxAttributeType : unsigned char { atDefaultText, atSelected, atWord };

enum DECLSPEC_DENUM TRxConsistentAttribute : unsigned char { caBold, caColor, caFace, caItalic, caSize, caStrikeOut, caUnderline, caProtected, caOffset, caHidden, caLink, caBackColor, caDisabled, caWeight, caSubscript, caRevAuthor };

typedef System::Set<TRxConsistentAttribute, TRxConsistentAttribute::caBold, TRxConsistentAttribute::caRevAuthor> TRxConsistentAttributes;

enum DECLSPEC_DENUM TSubscriptStyle : unsigned char { ssNone, ssSubscript, ssSuperscript };

enum DECLSPEC_DENUM TUnderlineType : unsigned char { utNone, utSolid, utWord, utDouble, utDotted, utWave };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TRxTextAttributes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TRxCustomRichEdit* RichEdit;
	TRxAttributeType FType;
	void __fastcall AssignFont(Vcl::Graphics::TFont* Font);
	void __fastcall GetAttributes(TCharFormat2A &Format);
	System::Uitypes::TFontCharset __fastcall GetCharset();
	void __fastcall SetCharset(System::Uitypes::TFontCharset Value);
	TSubscriptStyle __fastcall GetSubscriptStyle();
	void __fastcall SetSubscriptStyle(TSubscriptStyle Value);
	System::Uitypes::TColor __fastcall GetBackColor();
	System::Uitypes::TColor __fastcall GetColor();
	TRxConsistentAttributes __fastcall GetConsistentAttributes();
	int __fastcall GetHeight();
	bool __fastcall GetHidden();
	bool __fastcall GetDisabled();
	bool __fastcall GetLink();
	System::Uitypes::TFontName __fastcall GetName();
	int __fastcall GetOffset();
	System::Uitypes::TFontPitch __fastcall GetPitch();
	bool __fastcall GetProtected();
	System::Byte __fastcall GetRevAuthorIndex();
	int __fastcall GetSize();
	System::Uitypes::TFontStyles __fastcall GetStyle();
	TUnderlineType __fastcall GetUnderlineType();
	void __fastcall SetAttributes(TCharFormat2A &Format);
	void __fastcall SetBackColor(System::Uitypes::TColor Value);
	void __fastcall SetColor(System::Uitypes::TColor Value);
	void __fastcall SetDisabled(bool Value);
	void __fastcall SetHeight(int Value);
	void __fastcall SetHidden(bool Value);
	void __fastcall SetLink(bool Value);
	void __fastcall SetName(System::Uitypes::TFontName Value);
	void __fastcall SetOffset(int Value);
	void __fastcall SetPitch(System::Uitypes::TFontPitch Value);
	void __fastcall SetProtected(bool Value);
	void __fastcall SetRevAuthorIndex(System::Byte Value);
	void __fastcall SetSize(int Value);
	void __fastcall SetStyle(System::Uitypes::TFontStyles Value);
	void __fastcall SetUnderlineType(TUnderlineType Value);
	
protected:
	void __fastcall InitFormat(TCharFormat2A &Format);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall TRxTextAttributes(TRxCustomRichEdit* AOwner, TRxAttributeType AttributeType);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::Uitypes::TFontCharset Charset = {read=GetCharset, write=SetCharset, nodefault};
	__property System::Uitypes::TColor BackColor = {read=GetBackColor, write=SetBackColor, nodefault};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, nodefault};
	__property TRxConsistentAttributes ConsistentAttributes = {read=GetConsistentAttributes, nodefault};
	__property bool Disabled = {read=GetDisabled, write=SetDisabled, nodefault};
	__property bool Hidden = {read=GetHidden, write=SetHidden, nodefault};
	__property bool Link = {read=GetLink, write=SetLink, nodefault};
	__property System::Uitypes::TFontName Name = {read=GetName, write=SetName};
	__property int Offset = {read=GetOffset, write=SetOffset, nodefault};
	__property System::Uitypes::TFontPitch Pitch = {read=GetPitch, write=SetPitch, nodefault};
	__property bool Protected = {read=GetProtected, write=SetProtected, nodefault};
	__property System::Byte RevAuthorIndex = {read=GetRevAuthorIndex, write=SetRevAuthorIndex, nodefault};
	__property TSubscriptStyle SubscriptStyle = {read=GetSubscriptStyle, write=SetSubscriptStyle, nodefault};
	__property int Size = {read=GetSize, write=SetSize, nodefault};
	__property System::Uitypes::TFontStyles Style = {read=GetStyle, write=SetStyle, nodefault};
	__property int Height = {read=GetHeight, write=SetHeight, nodefault};
	__property TUnderlineType UnderlineType = {read=GetUnderlineType, write=SetUnderlineType, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TRxTextAttributes() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TRxNumbering : unsigned char { nsNone, nsBullet, nsArabicNumbers, nsLoCaseLetter, nsUpCaseLetter, nsLoCaseRoman, nsUpCaseRoman };

enum DECLSPEC_DENUM TRxNumberingStyle : unsigned char { nsParenthesis, nsPeriod, nsEnclosed, nsSimple };

enum DECLSPEC_DENUM TParaAlignment : unsigned char { paLeftJustify, paRightJustify, paCenter, paJustify };

enum DECLSPEC_DENUM TLineSpacingRule : unsigned char { lsSingle, lsOneAndHalf, lsDouble, lsSpecifiedOrMore, lsSpecified, lsMultiple };

typedef System::Int8 THeadingStyle;

enum DECLSPEC_DENUM TParaTableStyle : unsigned char { tsNone, tsTableRow, tsTableCellEnd, tsTableCell };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TRxParaAttributes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TRxCustomRichEdit* RichEdit;
	void __fastcall GetAttributes(TParaFormat2 &Paragraph);
	TParaAlignment __fastcall GetAlignment();
	int __fastcall GetFirstIndent();
	THeadingStyle __fastcall GetHeadingStyle();
	int __fastcall GetLeftIndent();
	int __fastcall GetRightIndent();
	int __fastcall GetSpaceAfter();
	int __fastcall GetSpaceBefore();
	int __fastcall GetLineSpacing();
	TLineSpacingRule __fastcall GetLineSpacingRule();
	TRxNumbering __fastcall GetNumbering();
	TRxNumberingStyle __fastcall GetNumberingStyle();
	System::Word __fastcall GetNumberingTab();
	int __fastcall GetTab(System::Byte Index);
	int __fastcall GetTabCount();
	TParaTableStyle __fastcall GetTableStyle();
	void __fastcall SetAlignment(TParaAlignment Value);
	void __fastcall SetAttributes(TParaFormat2 &Paragraph);
	void __fastcall SetFirstIndent(int Value);
	void __fastcall SetHeadingStyle(THeadingStyle Value);
	void __fastcall SetLeftIndent(int Value);
	void __fastcall SetRightIndent(int Value);
	void __fastcall SetSpaceAfter(int Value);
	void __fastcall SetSpaceBefore(int Value);
	void __fastcall SetLineSpacing(int Value);
	void __fastcall SetLineSpacingRule(TLineSpacingRule Value);
	void __fastcall SetNumbering(TRxNumbering Value);
	void __fastcall SetNumberingStyle(TRxNumberingStyle Value);
	void __fastcall SetNumberingTab(System::Word Value);
	void __fastcall SetTab(System::Byte Index, int Value);
	void __fastcall SetTabCount(int Value);
	void __fastcall SetTableStyle(TParaTableStyle Value);
	
protected:
	void __fastcall InitPara(TParaFormat2 &Paragraph);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall TRxParaAttributes(TRxCustomRichEdit* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property TParaAlignment Alignment = {read=GetAlignment, write=SetAlignment, nodefault};
	__property int FirstIndent = {read=GetFirstIndent, write=SetFirstIndent, nodefault};
	__property THeadingStyle HeadingStyle = {read=GetHeadingStyle, write=SetHeadingStyle, nodefault};
	__property int LeftIndent = {read=GetLeftIndent, write=SetLeftIndent, nodefault};
	__property int LineSpacing = {read=GetLineSpacing, write=SetLineSpacing, nodefault};
	__property TLineSpacingRule LineSpacingRule = {read=GetLineSpacingRule, write=SetLineSpacingRule, nodefault};
	__property TRxNumbering Numbering = {read=GetNumbering, write=SetNumbering, nodefault};
	__property TRxNumberingStyle NumberingStyle = {read=GetNumberingStyle, write=SetNumberingStyle, nodefault};
	__property System::Word NumberingTab = {read=GetNumberingTab, write=SetNumberingTab, nodefault};
	__property int RightIndent = {read=GetRightIndent, write=SetRightIndent, nodefault};
	__property int SpaceAfter = {read=GetSpaceAfter, write=SetSpaceAfter, nodefault};
	__property int SpaceBefore = {read=GetSpaceBefore, write=SetSpaceBefore, nodefault};
	__property int Tab[System::Byte Index] = {read=GetTab, write=SetTab};
	__property int TabCount = {read=GetTabCount, write=SetTabCount, nodefault};
	__property TParaTableStyle TableStyle = {read=GetTableStyle, write=SetTableStyle, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TRxParaAttributes() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOEMConversion : public Vcl::Comctrls::TConversion
{
	typedef Vcl::Comctrls::TConversion inherited;
	
public:
	virtual int __fastcall ConvertReadStream(System::Classes::TStream* Stream, System::DynamicArray<System::Byte> Buffer, int BufSize);
	virtual int __fastcall ConvertWriteStream(System::Classes::TStream* Stream, System::DynamicArray<System::Byte> Buffer, int BufSize);
public:
	/* TConversion.Create */ inline __fastcall virtual TOEMConversion() : Vcl::Comctrls::TConversion() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TOEMConversion() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TUndoName : unsigned char { unUnknown, unTyping, unDelete, unDragDrop, unCut, unPaste };

enum DECLSPEC_DENUM TRichSearchType : unsigned char { stWholeWord, stMatchCase, stBackward, stSetSelection };

typedef System::Set<TRichSearchType, TRichSearchType::stWholeWord, TRichSearchType::stSetSelection> TRichSearchTypes;

enum DECLSPEC_DENUM TRichSelection : unsigned char { stText, stObject, stMultiChar, stMultiObject };

typedef System::Set<TRichSelection, TRichSelection::stText, TRichSelection::stMultiObject> TRichSelectionType;

enum DECLSPEC_DENUM TRichLangOption : unsigned char { rlAutoKeyboard, rlAutoFont, rlImeCancelComplete, rlImeAlwaysSendNotify };

typedef System::Set<TRichLangOption, TRichLangOption::rlAutoKeyboard, TRichLangOption::rlImeAlwaysSendNotify> TRichLangOptions;

enum DECLSPEC_DENUM TRichStreamFormat : unsigned char { sfDefault, sfRichText, sfPlainText };

enum DECLSPEC_DENUM TRichStreamMode : unsigned char { smSelection, smPlainRtf, smNoObjects, smUnicode };

typedef System::Set<TRichStreamMode, TRichStreamMode::smSelection, TRichStreamMode::smUnicode> TRichStreamModes;

typedef void __fastcall (__closure *TRichEditURLClickEvent)(System::TObject* Sender, const System::UnicodeString URLText, System::Uitypes::TMouseButton Button);

typedef void __fastcall (__closure *TRichEditProtectChangeEx)(System::TObject* Sender, const Winapi::Messages::TMessage &Message, int StartPos, int EndPos, bool &AllowChange);

typedef void __fastcall (__closure *TRichEditFindErrorEvent)(System::TObject* Sender, const System::UnicodeString FindText);

typedef void __fastcall (__closure *TRichEditFindCloseEvent)(System::TObject* Sender, Vcl::Dialogs::TFindDialog* Dialog);

typedef TRichConversionFormat *PRichConversionFormat;

struct DECLSPEC_DRECORD TRichConversionFormat
{
public:
	Vcl::Comctrls::TConversionClass ConversionClass;
	System::UnicodeString Extension;
	bool PlainText;
	TRichConversionFormat *Next;
};


class PASCALIMPLEMENTATION TRxCustomRichEdit : public Vcl::Stdctrls::TCustomMemo
{
	typedef Vcl::Stdctrls::TCustomMemo inherited;
	
private:
	bool FHideScrollBars;
	bool FSelectionBar;
	bool FAutoURLDetect;
	bool FWordSelection;
	bool FPlainText;
	TRxTextAttributes* FSelAttributes;
	TRxTextAttributes* FDefAttributes;
	TRxTextAttributes* FWordAttributes;
	TRxParaAttributes* FParagraph;
	TParaAlignment FOldParaAlignment;
	int FScreenLogPixels;
	int FUndoLimit;
	System::Classes::TStrings* FRichEditStrings;
	System::Classes::TMemoryStream* FMemStream;
	bool FHideSelection;
	TRichLangOptions FLangOptions;
	bool FModified;
	bool FLinesUpdating;
	System::Types::TRect FPageRect;
	CHARRANGE FClickRange;
	System::Uitypes::TMouseButton FClickBtn;
	Vcl::Dialogs::TFindDialog* FFindDialog;
	Vcl::Dialogs::TReplaceDialog* FReplaceDialog;
	Vcl::Dialogs::TFindDialog* FLastFind;
	bool FAllowObjects;
	System::TObject* FCallback;
	System::_di_IInterface FRichEditOle;
	Vcl::Menus::TPopupMenu* FPopupVerbMenu;
	System::UnicodeString FTitle;
	bool FAutoVerbMenu;
	bool FAllowInPlace;
	Vcl::Comctrls::TConversionClass FDefaultConverter;
	System::Classes::TNotifyEvent FOnSelChange;
	Vcl::Comctrls::TRichEditResizeEvent FOnResizeRequest;
	Vcl::Comctrls::TRichEditProtectChange FOnProtectChange;
	TRichEditProtectChangeEx FOnProtectChangeEx;
	Vcl::Comctrls::TRichEditSaveClipboard FOnSaveClipboard;
	TRichEditURLClickEvent FOnURLClick;
	TRichEditFindErrorEvent FOnTextNotFound;
	TRichEditFindCloseEvent FOnCloseFindDialog;
	bool __fastcall GetAutoURLDetect();
	bool __fastcall GetWordSelection();
	TRichLangOptions __fastcall GetLangOptions();
	bool __fastcall GetCanRedo();
	bool __fastcall GetCanPaste();
	TUndoName __fastcall GetRedoName();
	TUndoName __fastcall GetUndoName();
	TRichStreamFormat __fastcall GetStreamFormat();
	TRichStreamModes __fastcall GetStreamMode();
	TRichSelectionType __fastcall GetSelectionType();
	void __fastcall PopupVerbClick(System::TObject* Sender);
	void __fastcall ObjectPropsClick(System::TObject* Sender);
	void __fastcall CloseObjects();
	void __fastcall UpdateHostNames();
	void __fastcall SetAllowObjects(bool Value);
	void __fastcall SetStreamFormat(TRichStreamFormat Value);
	void __fastcall SetStreamMode(TRichStreamModes Value);
	void __fastcall SetAutoURLDetect(bool Value);
	void __fastcall SetWordSelection(bool Value);
	void __fastcall SetHideScrollBars(bool Value);
	HIDESBASE void __fastcall SetHideSelection(bool Value);
	void __fastcall SetTitle(const System::UnicodeString Value);
	void __fastcall SetLangOptions(TRichLangOptions Value);
	void __fastcall SetRichEditStrings(System::Classes::TStrings* Value);
	void __fastcall SetDefAttributes(TRxTextAttributes* Value);
	void __fastcall SetSelAttributes(TRxTextAttributes* Value);
	void __fastcall SetWordAttributes(TRxTextAttributes* Value);
	void __fastcall SetSelectionBar(bool Value);
	void __fastcall SetUndoLimit(int Value);
	void __fastcall UpdateTextModes(bool Plain);
	void __fastcall AdjustFindDialogPosition(Vcl::Dialogs::TFindDialog* Dialog);
	void __fastcall SetupFindDialog(Vcl::Dialogs::TFindDialog* Dialog, const System::UnicodeString SearchStr, const System::UnicodeString ReplaceStr);
	bool __fastcall FindEditText(Vcl::Dialogs::TFindDialog* Dialog, bool AdjustPos, bool Events);
	bool __fastcall GetCanFindNext();
	void __fastcall FindDialogFind(System::TObject* Sender);
	void __fastcall ReplaceDialogReplace(System::TObject* Sender);
	void __fastcall FindDialogClose(System::TObject* Sender);
	void __fastcall SetUIActive(bool Active);
	MESSAGE void __fastcall CMDocWindowActivate(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMUIDeactivate(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMBiDiModeChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CNNotify(Winapi::Messages::TWMNotify &Message);
	MESSAGE void __fastcall EMReplaceSel(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMDestroy(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFont(Winapi::Messages::TWMSetFont &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonUp(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWindowHandle(const Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd();
	virtual void __fastcall DestroyWnd();
	DYNAMIC Vcl::Menus::TPopupMenu* __fastcall GetPopupMenu();
	virtual void __fastcall TextNotFound(Vcl::Dialogs::TFindDialog* Dialog);
	virtual void __fastcall RequestSize(const System::Types::TRect &Rect);
	DYNAMIC void __fastcall SelectionChange();
	DYNAMIC bool __fastcall ProtectChange(const Winapi::Messages::TMessage &Message, int StartPos, int EndPos);
	DYNAMIC bool __fastcall SaveClipboard(int NumObj, int NumChars);
	DYNAMIC void __fastcall URLClick(const System::UnicodeString URLText, System::Uitypes::TMouseButton Button);
	virtual void __fastcall SetPlainText(bool Value);
	virtual void __fastcall CloseFindDialog(Vcl::Dialogs::TFindDialog* Dialog);
	virtual void __fastcall DoSetMaxLength(int Value);
	virtual int __fastcall GetSelLength();
	virtual int __fastcall GetSelStart();
	virtual System::UnicodeString __fastcall GetSelText();
	virtual void __fastcall SetSelLength(int Value);
	virtual void __fastcall SetSelStart(int Value);
	__property bool AllowInPlace = {read=FAllowInPlace, write=FAllowInPlace, default=1};
	__property bool AllowObjects = {read=FAllowObjects, write=SetAllowObjects, default=1};
	__property bool AutoURLDetect = {read=GetAutoURLDetect, write=SetAutoURLDetect, default=1};
	__property bool AutoVerbMenu = {read=FAutoVerbMenu, write=FAutoVerbMenu, default=1};
	__property bool HideSelection = {read=FHideSelection, write=SetHideSelection, default=1};
	__property bool HideScrollBars = {read=FHideScrollBars, write=SetHideScrollBars, default=1};
	__property System::UnicodeString Title = {read=FTitle, write=SetTitle};
	__property TRichLangOptions LangOptions = {read=GetLangOptions, write=SetLangOptions, default=2};
	__property System::Classes::TStrings* Lines = {read=FRichEditStrings, write=SetRichEditStrings};
	__property bool PlainText = {read=FPlainText, write=SetPlainText, default=0};
	__property bool SelectionBar = {read=FSelectionBar, write=SetSelectionBar, default=1};
	__property TRichStreamFormat StreamFormat = {read=GetStreamFormat, write=SetStreamFormat, default=0};
	__property TRichStreamModes StreamMode = {read=GetStreamMode, write=SetStreamMode, default=0};
	__property int UndoLimit = {read=FUndoLimit, write=SetUndoLimit, default=100};
	__property bool WordSelection = {read=GetWordSelection, write=SetWordSelection, default=1};
	__property ScrollBars = {default=3};
	__property TabStop = {default=1};
	__property Vcl::Comctrls::TRichEditSaveClipboard OnSaveClipboard = {read=FOnSaveClipboard, write=FOnSaveClipboard};
	__property System::Classes::TNotifyEvent OnSelectionChange = {read=FOnSelChange, write=FOnSelChange};
	__property Vcl::Comctrls::TRichEditProtectChange OnProtectChange = {read=FOnProtectChange, write=FOnProtectChange};
	__property TRichEditProtectChangeEx OnProtectChangeEx = {read=FOnProtectChangeEx, write=FOnProtectChangeEx};
	__property Vcl::Comctrls::TRichEditResizeEvent OnResizeRequest = {read=FOnResizeRequest, write=FOnResizeRequest};
	__property TRichEditURLClickEvent OnURLClick = {read=FOnURLClick, write=FOnURLClick};
	__property TRichEditFindErrorEvent OnTextNotFound = {read=FOnTextNotFound, write=FOnTextNotFound};
	__property TRichEditFindCloseEvent OnCloseFindDialog = {read=FOnCloseFindDialog, write=FOnCloseFindDialog};
	
public:
	__fastcall virtual TRxCustomRichEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TRxCustomRichEdit();
	virtual void __fastcall Clear();
	HIDESBASE int __fastcall GetTextLen();
	void __fastcall SetSelection(int StartPos, int EndPos, bool ScrollCaret);
	CHARRANGE __fastcall GetSelection();
	System::UnicodeString __fastcall GetTextRange(int StartPos, int EndPos);
	int __fastcall LineFromChar(int CharIndex);
	int __fastcall GetLineIndex(int LineNo);
	int __fastcall GetLineLength(int CharIndex);
	System::UnicodeString __fastcall WordAtCursor();
	int __fastcall FindText(const System::UnicodeString SearchStr, int StartPos, int Length, TRichSearchTypes Options);
	virtual int __fastcall GetSelTextBuf(System::WideChar * Buffer, int BufSize);
	virtual System::Types::TPoint __fastcall GetCaretPos();
	System::Types::TPoint __fastcall GetCharPos(int CharIndex);
	bool __fastcall InsertObjectDialog();
	bool __fastcall ObjectPropertiesDialog();
	bool __fastcall PasteSpecialDialog();
	Vcl::Dialogs::TFindDialog* __fastcall FindDialog(const System::UnicodeString SearchStr);
	Vcl::Dialogs::TReplaceDialog* __fastcall ReplaceDialog(const System::UnicodeString SearchStr, const System::UnicodeString ReplaceStr);
	bool __fastcall FindNext();
	virtual void __fastcall Print(const System::UnicodeString Caption);
	__classmethod void __fastcall RegisterConversionFormat(const System::UnicodeString AExtension, bool APlainText, Vcl::Comctrls::TConversionClass AConversionClass);
	HIDESBASE void __fastcall ClearUndo();
	void __fastcall Redo();
	void __fastcall StopGroupTyping();
	__property bool CanFindNext = {read=GetCanFindNext, nodefault};
	__property bool CanRedo = {read=GetCanRedo, nodefault};
	__property bool CanPaste = {read=GetCanPaste, nodefault};
	__property TUndoName RedoName = {read=GetRedoName, nodefault};
	__property TUndoName UndoName = {read=GetUndoName, nodefault};
	__property Vcl::Comctrls::TConversionClass DefaultConverter = {read=FDefaultConverter, write=FDefaultConverter};
	__property TRxTextAttributes* DefAttributes = {read=FDefAttributes, write=SetDefAttributes};
	__property TRxTextAttributes* SelAttributes = {read=FSelAttributes, write=SetSelAttributes};
	__property TRxTextAttributes* WordAttributes = {read=FWordAttributes, write=SetWordAttributes};
	__property System::Types::TRect PageRect = {read=FPageRect, write=FPageRect};
	__property TRxParaAttributes* Paragraph = {read=FParagraph};
	__property TRichSelectionType SelectionType = {read=GetSelectionType, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TRxCustomRichEdit(HWND ParentWindow) : Vcl::Stdctrls::TCustomMemo(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TRxRichEdit : public TRxCustomRichEdit
{
	typedef TRxCustomRichEdit inherited;
	
__published:
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property AutoURLDetect = {default=1};
	__property AutoVerbMenu = {default=1};
	__property AllowObjects = {default=1};
	__property AllowInPlace = {default=1};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property BorderWidth = {default=0};
	__property DragKind = {default=0};
	__property BorderStyle = {default=1};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property HideSelection = {default=1};
	__property HideScrollBars = {default=1};
	__property Title = {default=0};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property LangOptions = {default=2};
	__property Lines;
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PlainText = {default=0};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ScrollBars = {default=3};
	__property SelectionBar = {default=1};
	__property ShowHint;
	__property StreamFormat = {default=0};
	__property StreamMode = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property UndoLimit = {default=100};
	__property Visible = {default=1};
	__property WantTabs = {default=0};
	__property WantReturns = {default=1};
	__property WordSelection = {default=1};
	__property WordWrap = {default=1};
	__property OnChange;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnContextPopup;
	__property OnEndDock;
	__property OnStartDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseWheel;
	__property OnMouseWheelDown;
	__property OnMouseWheelUp;
	__property OnProtectChange;
	__property OnProtectChangeEx;
	__property OnResizeRequest;
	__property OnSaveClipboard;
	__property OnSelectionChange;
	__property OnStartDrag;
	__property OnTextNotFound;
	__property OnCloseFindDialog;
	__property OnURLClick;
public:
	/* TRxCustomRichEdit.Create */ inline __fastcall virtual TRxRichEdit(System::Classes::TComponent* AOwner) : TRxCustomRichEdit(AOwner) { }
	/* TRxCustomRichEdit.Destroy */ inline __fastcall virtual ~TRxRichEdit() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TRxRichEdit(HWND ParentWindow) : TRxCustomRichEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TRichEditVersion RichEditVersion;
extern DELPHI_PACKAGE bool IsWin8;
extern DELPHI_PACKAGE bool IsWin10;
}	/* namespace Frxrichedit */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXRICHEDIT)
using namespace Frxrichedit;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxricheditHPP
