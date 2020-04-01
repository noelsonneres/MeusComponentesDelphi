// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fqbClass.pas' rev: 33.00 (Windows)

#ifndef FqbclassHPP
#define FqbclassHPP

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
#include <Vcl.Menus.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Grids.hpp>
#include <Data.DB.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.CheckLst.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.Types.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fqbclass
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS EfqbError;
class DELPHICLASS TfqbField;
class DELPHICLASS TfqbFieldList;
class DELPHICLASS TfqbLink;
class DELPHICLASS TfqbLinkList;
class DELPHICLASS TfqbCheckListBox;
class DELPHICLASS TfqbTable;
class DELPHICLASS TfqbTableArea;
class DELPHICLASS TfqbTableListBox;
struct TGridColumn;
class DELPHICLASS TfqbEdit;
class DELPHICLASS TfqbGrid;
class DELPHICLASS TfqbEngine;
class DELPHICLASS TfqbDialog;
class DELPHICLASS TfqbCore;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION EfqbError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EfqbError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EfqbError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EfqbError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EfqbError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EfqbError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EfqbError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EfqbError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EfqbError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EfqbError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EfqbError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EfqbError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EfqbError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EfqbError() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfqbField : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	System::UnicodeString FFieldName;
	int FFielType;
	bool FLinked;
	System::UnicodeString __fastcall GetFieldName();
	
public:
	__property System::UnicodeString FieldName = {read=GetFieldName, write=FFieldName};
	__property int FieldType = {read=FFielType, write=FFielType, nodefault};
	__property bool Linked = {read=FLinked, write=FLinked, nodefault};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfqbField(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfqbField() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfqbFieldList : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TfqbField* operator[](int Index) { return this->Items[Index]; }
	
private:
	HIDESBASE TfqbField* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TfqbField* const Value);
	
public:
	HIDESBASE TfqbField* __fastcall Add();
	__property TfqbField* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TOwnedCollection.Create */ inline __fastcall TfqbFieldList(System::Classes::TPersistent* AOwner, System::Classes::TCollectionItemClass ItemClass) : System::Classes::TOwnedCollection(AOwner, ItemClass) { }
	
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfqbFieldList() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfqbLink : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	TfqbTableArea* FArea;
	TfqbField* FDestField;
	TfqbTable* FDestTable;
	int FJOp;
	int FJType;
	Vcl::Menus::TPopupMenu* FMenu;
	bool FSelected;
	TfqbField* FSourceField;
	TfqbTable* FSourceTable;
	void __fastcall DoDelete(System::TObject* Sender);
	void __fastcall DoOptions(System::TObject* Sender);
	void __fastcall Draw();
	System::Types::TPoint __fastcall GetDestCoords();
	System::Types::TPoint __fastcall GetSourceCoords();
	void __fastcall SetSelected(const bool Value);
	
public:
	__fastcall virtual TfqbLink(System::Classes::TCollection* Collection);
	__fastcall virtual ~TfqbLink();
	__property System::Types::TPoint DestCoords = {read=GetDestCoords};
	__property TfqbField* DestField = {read=FDestField};
	__property TfqbTable* DestTable = {read=FDestTable};
	__property int JoinOperator = {read=FJOp, write=FJOp, nodefault};
	__property int JoinType = {read=FJType, write=FJType, nodefault};
	__property bool Selected = {read=FSelected, write=SetSelected, nodefault};
	__property System::Types::TPoint SourceCoords = {read=GetSourceCoords};
	__property TfqbField* SourceField = {read=FSourceField};
	__property TfqbTable* SourceTable = {read=FSourceTable};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfqbLinkList : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TfqbLink* operator[](int Index) { return this->Items[Index]; }
	
private:
	HIDESBASE TfqbLink* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TfqbLink* const Value);
	
public:
	HIDESBASE TfqbLink* __fastcall Add();
	__property TfqbLink* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TOwnedCollection.Create */ inline __fastcall TfqbLinkList(System::Classes::TPersistent* AOwner, System::Classes::TCollectionItemClass ItemClass) : System::Classes::TOwnedCollection(AOwner, ItemClass) { }
	
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfqbLinkList() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfqbCheckListBox : public Vcl::Checklst::TCheckListBox
{
	typedef Vcl::Checklst::TCheckListBox inherited;
	
protected:
	DYNAMIC void __fastcall ClickCheck();
	DYNAMIC void __fastcall DragOver(System::TObject* Sender, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	
public:
	DYNAMIC void __fastcall DragDrop(System::TObject* Sender, int X, int Y);
public:
	/* TCheckListBox.Create */ inline __fastcall virtual TfqbCheckListBox(System::Classes::TComponent* AOwner) : Vcl::Checklst::TCheckListBox(AOwner) { }
	/* TCheckListBox.Destroy */ inline __fastcall virtual ~TfqbCheckListBox() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbCheckListBox(HWND ParentWindow) : Vcl::Checklst::TCheckListBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfqbTable : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
private:
	System::UnicodeString FAliasName;
	Vcl::Buttons::TSpeedButton* FButtonClose;
	Vcl::Buttons::TSpeedButton* FButtonMinimize;
	TfqbCheckListBox* FCheckListBox;
	TfqbFieldList* FFieldList;
	Vcl::Extctrls::TImage* FImage;
	Vcl::Stdctrls::TLabel* FLabel;
	int FOldHeight;
	System::UnicodeString FTableName;
	TfqbField* __fastcall GetSellectedField();
	void __fastcall SetTableName(const System::UnicodeString Value);
	void __fastcall SetXPStyle(Vcl::Controls::TControl* const AComp);
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	System::Types::TPoint __fastcall GetLinkPoint(int AIndex, System::WideChar ASide);
	DYNAMIC void __fastcall Resize();
	HIDESBASE MESSAGE void __fastcall WMMove(Winapi::Messages::TWMMove &Message);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &M);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	MESSAGE void __fastcall CMRelease(Winapi::Messages::TMessage &Message);
	void __fastcall _DoExit(System::TObject* Sender);
	void __fastcall _DoMinimize(System::TObject* Sender);
	void __fastcall _DoRestore(System::TObject* Sender);
	__property TfqbCheckListBox* ChBox = {read=FCheckListBox};
	
public:
	__fastcall virtual TfqbTable(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfqbTable();
	void __fastcall UpdateFieldList();
	void __fastcall UpdateLinkList();
	__property System::UnicodeString AliasName = {read=FAliasName};
	__property TfqbFieldList* FieldList = {read=FFieldList, write=FFieldList};
	__property TfqbField* SellectedField = {read=GetSellectedField};
	__property System::UnicodeString TableName = {read=FTableName, write=SetTableName};
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbTable(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfqbTableArea : public Vcl::Forms::TScrollBox
{
	typedef Vcl::Forms::TScrollBox inherited;
	
private:
	Vcl::Graphics::TCanvas* FCanvas;
	int FInstX;
	int FInstY;
	TfqbLinkList* FLinkList;
	
protected:
	DYNAMIC void __fastcall Click();
	virtual System::UnicodeString __fastcall GenerateAlias(const System::UnicodeString ATableNAme);
	int __fastcall GetLineAtCursor();
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	
public:
	__fastcall virtual TfqbTableArea(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfqbTableArea();
	bool __fastcall CompareFields(int TableID1, int FIndex1, int TableID2, int FIndex2);
	DYNAMIC void __fastcall DragDrop(System::TObject* Source, int X, int Y);
	DYNAMIC void __fastcall DragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	TfqbTable* __fastcall FindTable(const System::UnicodeString AName, const System::UnicodeString AAlias);
	void __fastcall InsertTable(const int X, const int Y, const System::UnicodeString Name)/* overload */;
	void __fastcall InsertTable(const System::UnicodeString Name)/* overload */;
	__property TfqbLinkList* LinkList = {read=FLinkList};
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbTableArea(HWND ParentWindow) : Vcl::Forms::TScrollBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfqbTableListBox : public Vcl::Stdctrls::TListBox
{
	typedef Vcl::Stdctrls::TListBox inherited;
	
protected:
	DYNAMIC void __fastcall DblClick();
	virtual void __fastcall DrawItem(int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	virtual void __fastcall CreateWnd();
	
public:
	__fastcall virtual TfqbTableListBox(System::Classes::TComponent* AOwner);
public:
	/* TCustomListBox.Destroy */ inline __fastcall virtual ~TfqbTableListBox() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbTableListBox(HWND ParentWindow) : Vcl::Stdctrls::TListBox(ParentWindow) { }
	
};


typedef TGridColumn *PGridColumn;

struct DECLSPEC_DRECORD TGridColumn
{
public:
	System::UnicodeString Table;
	System::UnicodeString Alias;
	System::UnicodeString Field;
	bool Visibl;
	System::UnicodeString Where;
	int Sort;
	int Func;
	int Group;
};


class PASCALIMPLEMENTATION TfqbEdit : public Vcl::Stdctrls::TEdit
{
	typedef Vcl::Stdctrls::TEdit inherited;
	
private:
	Vcl::Buttons::TSpeedButton* FButton;
	System::Classes::TNotifyEvent FOnButtonClick;
	Vcl::Extctrls::TPanel* FPanel;
	bool FShowButton;
	void __fastcall SetShowButton(const bool Value);
	
protected:
	void __fastcall ButtonClick(System::TObject* Sender);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd();
	void __fastcall SetEditRect();
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	
public:
	__fastcall virtual TfqbEdit(System::Classes::TComponent* AOwner);
	__property System::Classes::TNotifyEvent OnButtonClick = {read=FOnButtonClick, write=FOnButtonClick};
	__property bool ShowButton = {read=FShowButton, write=SetShowButton, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbEdit(HWND ParentWindow) : Vcl::Stdctrls::TEdit(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TfqbEdit() { }
	
};


typedef void __fastcall (__closure *TfqbColumnResizeEvent)(Vcl::Comctrls::TCustomListView* Sender, int ColumnIndex, int ColumnWidth);

class PASCALIMPLEMENTATION TfqbGrid : public Vcl::Comctrls::TListView
{
	typedef Vcl::Comctrls::TListView inherited;
	
private:
	TfqbColumnResizeEvent FEndColumnResizeEvent;
	Vcl::Stdctrls::TComboBox* FFunctionList;
	Vcl::Stdctrls::TComboBox* FGroupList;
	Vcl::Menus::TPopupMenu* FPopupMenu;
	Vcl::Stdctrls::TComboBox* FSortList;
	Vcl::Stdctrls::TComboBox* FVisibleList;
	TfqbEdit* FWhereEditor;
	void __fastcall fqbOnChange(System::TObject* Sender);
	void __fastcall fqbOnMenu(System::TObject* Sender);
	void __fastcall fqbOnPopup(System::TObject* Sender);
	void __fastcall fqbOnSelectItem(System::TObject* Sender, Vcl::Comctrls::TListItem* Item, bool Selected);
	void __fastcall fqbSetBounds(Vcl::Controls::TControl* &Contr);
	
protected:
	virtual void __fastcall CreateWnd();
	virtual void __fastcall DoColumnResize(int ColumnIndex, int ColumnWidth);
	int __fastcall FindColumnIndex(Winapi::Windows::PNMHdr pHeader);
	int __fastcall FindColumnWidth(Winapi::Windows::PNMHdr pHeader);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall RecalcColWidth();
	DYNAMIC void __fastcall Resize();
	HIDESBASE MESSAGE void __fastcall WMNotify(Winapi::Messages::TWMNotify &Msg);
	HIDESBASE MESSAGE void __fastcall WMVscroll(Winapi::Messages::TWMNotify &Msg);
	
public:
	__fastcall virtual TfqbGrid(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfqbGrid();
	int __fastcall AddColumn();
	void __fastcall Exchange(const int AItm1, const int AItm2);
	void __fastcall fqbUpdate();
	HIDESBASE void __fastcall UpdateColumn();
	__property TfqbColumnResizeEvent OnEndColumnResize = {read=FEndColumnResizeEvent, write=FEndColumnResizeEvent};
public:
	/* TWinControl.CreateParented */ inline __fastcall TfqbGrid(HWND ParentWindow) : Vcl::Comctrls::TListView(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfqbEngine : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	bool FShowSystemTables;
	
public:
	virtual void __fastcall ReadFieldList(const System::UnicodeString ATableName, TfqbFieldList* &AFieldList) = 0 ;
	virtual void __fastcall ReadTableList(System::Classes::TStrings* ATableList) = 0 ;
	virtual Data::Db::TDataSet* __fastcall ResultDataSet() = 0 ;
	virtual void __fastcall SetSQL(const System::UnicodeString Value) = 0 ;
	
__published:
	__property bool ShowSystemTables = {read=FShowSystemTables, write=FShowSystemTables, default=0};
public:
	/* TComponent.Create */ inline __fastcall virtual TfqbEngine(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfqbEngine() { }
	
};


class PASCALIMPLEMENTATION TfqbDialog : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TfqbEngine* FEngine;
	bool __fastcall GetSchemaInsideSQL();
	System::UnicodeString __fastcall GetSQL();
	System::UnicodeString __fastcall GetSQLSchema();
	void __fastcall SetEngine(TfqbEngine* const Value);
	void __fastcall SetSchemaInsideSQL(const bool Value);
	void __fastcall SetSQL(System::UnicodeString Value);
	void __fastcall SetSQLSchema(const System::UnicodeString Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TfqbDialog(System::Classes::TComponent* AOwner);
	virtual bool __fastcall Execute();
	__property System::UnicodeString SQL = {read=GetSQL, write=SetSQL};
	__property System::UnicodeString SQLSchema = {read=GetSQLSchema, write=SetSQLSchema};
	
__published:
	__property TfqbEngine* Engine = {read=FEngine, write=SetEngine};
	__property bool SchemaInsideSQL = {read=GetSchemaInsideSQL, write=SetSchemaInsideSQL, default=1};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TfqbDialog() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfqbCore : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfqbEngine* FEngine;
	TfqbGrid* FGrid;
	bool FSchemaInsideSQL;
	System::UnicodeString FSQL;
	System::UnicodeString FSQLSchema;
	TfqbTableArea* FTableArea;
	bool FUseCoding;
	System::UnicodeString FText;
	bool FUsingQuotes;
	System::UnicodeString __fastcall ExtractSchema(const System::UnicodeString Value);
	System::UnicodeString __fastcall ExtractSQL(const System::UnicodeString Str);
	TfqbEngine* __fastcall GetEngine();
	TfqbGrid* __fastcall GetGrid();
	System::UnicodeString __fastcall GetSQL();
	System::UnicodeString __fastcall GetSQLSchema();
	TfqbTableArea* __fastcall GetTableArea();
	void __fastcall SetSchemaInsideSQL(const bool Value);
	void __fastcall SetSQL(System::UnicodeString Value);
	void __fastcall SetSQLSchema(const System::UnicodeString Value);
	
public:
	__fastcall virtual TfqbCore();
	__fastcall virtual ~TfqbCore();
	void __fastcall Clear();
	System::UnicodeString __fastcall GenerateSQL();
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	void __fastcall LoadFromStr(System::Classes::TStringList* const Str);
	void __fastcall RecognizeModel(const unsigned crc32, const System::UnicodeString FileName);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	void __fastcall SaveToStr(System::Classes::TStringList* &Str);
	__property TfqbEngine* Engine = {read=GetEngine, write=FEngine};
	__property TfqbGrid* Grid = {read=GetGrid, write=FGrid};
	__property System::UnicodeString SQL = {read=GetSQL, write=SetSQL};
	__property System::UnicodeString SQLSchema = {read=GetSQLSchema, write=SetSQLSchema};
	__property TfqbTableArea* TableArea = {read=GetTableArea, write=FTableArea};
	__property bool SchemaInsideSQL = {read=FSchemaInsideSQL, write=SetSchemaInsideSQL, default=1};
	__property bool UsingQuotes = {read=FUsingQuotes, write=FUsingQuotes, nodefault};
};

#pragma pack(pop)

typedef System::StaticArray<System::UnicodeString, 52> Fqbclass__51;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Fqbclass__51 StrFieldType;
#define _fqbBeginModel L"/*_FQBMODEL"
#define _fqbEndModel L"_FQBEND*/"
extern DELPHI_PACKAGE TfqbCore* __fastcall fqbCore(void);
}	/* namespace Fqbclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FQBCLASS)
using namespace Fqbclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FqbclassHPP
