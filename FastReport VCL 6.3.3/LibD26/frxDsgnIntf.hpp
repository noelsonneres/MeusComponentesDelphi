// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDsgnIntf.pas' rev: 33.00 (Windows)

#ifndef FrxdsgnintfHPP
#define FrxdsgnintfHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <System.TypInfo.hpp>
#include <frxClass.hpp>
#include <System.Variants.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdsgnintf
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxPropertyEditor;
class DELPHICLASS TfrxComponentEditor;
class DELPHICLASS TfrxIntegerProperty;
class DELPHICLASS TfrxFloatProperty;
class DELPHICLASS TfrxCharProperty;
class DELPHICLASS TfrxStringProperty;
class DELPHICLASS TfrxEnumProperty;
class DELPHICLASS TfrxSetProperty;
class DELPHICLASS TfrxSetElementProperty;
class DELPHICLASS TfrxClassProperty;
class DELPHICLASS TfrxComponentProperty;
class DELPHICLASS TfrxNameProperty;
class DELPHICLASS TfrxColorProperty;
class DELPHICLASS TfrxFontProperty;
class DELPHICLASS TfrxFontNameProperty;
class DELPHICLASS TfrxFontCharsetProperty;
class DELPHICLASS TfrxModalResultProperty;
class DELPHICLASS TfrxShortCutProperty;
class DELPHICLASS TfrxCursorProperty;
class DELPHICLASS TfrxDateTimeProperty;
class DELPHICLASS TfrxDateProperty;
class DELPHICLASS TfrxTimeProperty;
class DELPHICLASS TfrxPropertyItem;
class DELPHICLASS TfrxPropertyList;
class DELPHICLASS TfrxObjectItem;
class DELPHICLASS TfrxComponentEditorItem;
class DELPHICLASS TfrxPropertyEditorItem;
class DELPHICLASS TfrxExportFilterItem;
class DELPHICLASS TfrxWizardItem;
class DELPHICLASS TfrxObjectCollection;
class DELPHICLASS TfrxComponentEditorCollection;
class DELPHICLASS TfrxPropertyEditorCollection;
class DELPHICLASS TfrxExportFilterCollection;
class DELPHICLASS TfrxSaveFilterItem;
class DELPHICLASS TfrxSaveFiltersCollection;
class DELPHICLASS TfrxWizardCollection;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxPropertyAttribute : unsigned char { paValueList, paSortList, paDialog, paMultiSelect, paSubProperties, paReadOnly, paOwnerDraw };

typedef System::Set<TfrxPropertyAttribute, TfrxPropertyAttribute::paValueList, TfrxPropertyAttribute::paOwnerDraw> TfrxPropertyAttributes;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPropertyEditor : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Frxclass::TfrxCustomDesigner* FDesigner;
	System::Classes::TList* FCompList;
	System::Classes::TList* FPropList;
	int FItemHeight;
	System::Classes::TStrings* FValues;
	System::Typinfo::PPropInfo __fastcall GetPropInfo();
	System::Classes::TPersistent* __fastcall GetComponent();
	Frxclass::TfrxComponent* __fastcall GetfrComponent();
	
protected:
	void __fastcall GetStrProc(const System::UnicodeString s);
	System::Extended __fastcall GetFloatValue();
	NativeInt __fastcall GetOrdValue();
	System::UnicodeString __fastcall GetStrValue();
	System::Variant __fastcall GetVarValue();
	void __fastcall SetFloatValue(System::Extended Value);
	void __fastcall SetOrdValue(NativeInt Value);
	void __fastcall SetStrValue(const System::UnicodeString Value);
	void __fastcall SetVarValue(const System::Variant &Value);
	
public:
	__fastcall virtual TfrxPropertyEditor(Frxclass::TfrxCustomDesigner* Designer);
	__fastcall virtual ~TfrxPropertyEditor();
	virtual bool __fastcall Edit();
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetName();
	virtual int __fastcall GetExtraLBSize();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
	virtual void __fastcall OnDrawLBItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	virtual void __fastcall OnDrawItem(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &ARect);
	__property System::Classes::TPersistent* Component = {read=GetComponent};
	__property Frxclass::TfrxComponent* frComponent = {read=GetfrComponent};
	__property Frxclass::TfrxCustomDesigner* Designer = {read=FDesigner};
	__property int ItemHeight = {read=FItemHeight, write=FItemHeight, nodefault};
	__property System::Typinfo::PPropInfo PropInfo = {read=GetPropInfo};
	__property System::UnicodeString Value = {read=GetValue, write=SetValue};
	__property System::Classes::TStrings* Values = {read=FValues};
};

#pragma pack(pop)

typedef System::TMetaClass* TfrxPropertyEditorClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxComponentEditor : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Frxclass::TfrxComponent* FComponent;
	Frxclass::TfrxCustomDesigner* FDesigner;
	Vcl::Menus::TMenu* FMenu;
	
protected:
	Vcl::Menus::TMenuItem* __fastcall AddItem(const System::UnicodeString Caption, int Tag, bool Checked = false);
	
public:
	__fastcall virtual TfrxComponentEditor(Frxclass::TfrxComponent* Component, Frxclass::TfrxCustomDesigner* Designer, Vcl::Menus::TMenu* Menu);
	virtual bool __fastcall Edit();
	virtual bool __fastcall HasEditor();
	virtual void __fastcall GetMenuItems();
	virtual bool __fastcall Execute(int Tag, bool Checked);
	__property Frxclass::TfrxComponent* Component = {read=FComponent};
	__property Frxclass::TfrxCustomDesigner* Designer = {read=FDesigner};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxComponentEditor() { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TfrxComponentEditorClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxIntegerProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxIntegerProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxIntegerProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFloatProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxFloatProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxFloatProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCharProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxCharProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxCharProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxStringProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxStringProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxStringProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxEnumProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxEnumProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxEnumProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSetProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetValue();
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxSetProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxSetProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSetElementProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
private:
	int FElement;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetName();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxSetElementProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxSetElementProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxClassProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetValue();
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxClassProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxClassProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxComponentProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxComponentProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxComponentProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxNameProperty : public TfrxStringProperty
{
	typedef TfrxStringProperty inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxNameProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxStringProperty(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxNameProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxColorProperty : public TfrxIntegerProperty
{
	typedef TfrxIntegerProperty inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual bool __fastcall Edit();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
	virtual void __fastcall OnDrawLBItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	virtual void __fastcall OnDrawItem(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &ARect);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxColorProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxIntegerProperty(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxColorProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFontProperty : public TfrxClassProperty
{
	typedef TfrxClassProperty inherited;
	
public:
	virtual bool __fastcall Edit();
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxFontProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxClassProperty(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxFontProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFontNameProperty : public TfrxStringProperty
{
	typedef TfrxStringProperty inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual void __fastcall GetValues();
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxFontNameProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxStringProperty(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxFontNameProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFontCharsetProperty : public TfrxIntegerProperty
{
	typedef TfrxIntegerProperty inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxFontCharsetProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxIntegerProperty(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxFontCharsetProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxModalResultProperty : public TfrxIntegerProperty
{
	typedef TfrxIntegerProperty inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxModalResultProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxIntegerProperty(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxModalResultProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxShortCutProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxShortCutProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxShortCutProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCursorProperty : public TfrxIntegerProperty
{
	typedef TfrxIntegerProperty inherited;
	
public:
	virtual TfrxPropertyAttributes __fastcall GetAttributes();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall GetValues();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxCursorProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxIntegerProperty(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxCursorProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxDateTimeProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxDateTimeProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxDateTimeProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxDateProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxDateProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxDateProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxTimeProperty : public TfrxPropertyEditor
{
	typedef TfrxPropertyEditor inherited;
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(const System::UnicodeString Value);
public:
	/* TfrxPropertyEditor.Create */ inline __fastcall virtual TfrxTimeProperty(Frxclass::TfrxCustomDesigner* Designer) : TfrxPropertyEditor(Designer) { }
	/* TfrxPropertyEditor.Destroy */ inline __fastcall virtual ~TfrxTimeProperty() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPropertyItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	TfrxPropertyEditor* FEditor;
	bool FExpanded;
	TfrxPropertyList* FSubProperty;
	
public:
	__fastcall virtual ~TfrxPropertyItem();
	__property TfrxPropertyEditor* Editor = {read=FEditor};
	__property bool Expanded = {read=FExpanded, write=FExpanded, nodefault};
	__property TfrxPropertyList* SubProperty = {read=FSubProperty};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxPropertyItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPropertyList : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxPropertyItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Classes::TPersistent* FComponent;
	Frxclass::TfrxCustomDesigner* FDesigner;
	TfrxPropertyList* FParent;
	void __fastcall AddProperties(TfrxPropertyList* PropertyList);
	void __fastcall FillProperties(System::Classes::TPersistent* AClass);
	void __fastcall FillCommonProperties(TfrxPropertyList* PropertyList);
	void __fastcall SetComponent(System::Classes::TPersistent* Value);
	TfrxPropertyItem* __fastcall GetPropertyItem(int Index);
	
public:
	__fastcall TfrxPropertyList(Frxclass::TfrxCustomDesigner* Designer);
	HIDESBASE TfrxPropertyItem* __fastcall Add();
	__property System::Classes::TPersistent* Component = {read=FComponent, write=SetComponent};
	__property TfrxPropertyItem* Items[int Index] = {read=GetPropertyItem/*, default*/};
	__property TfrxPropertyList* Parent = {read=FParent};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxPropertyList() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TfrxObjectCategory : unsigned char { ctData, ctReport, ctDialog, ctDMP, ctNone };

typedef System::Set<TfrxObjectCategory, TfrxObjectCategory::ctData, TfrxObjectCategory::ctNone> TfrxObjectCategories;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxObjectItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	Frxclass::TfrxComponentClass ClassRef;
	Vcl::Graphics::TBitmap* ButtonBmp;
	int ButtonImageIndex;
	System::UnicodeString ButtonHint;
	System::UnicodeString CategoryName;
	System::Word Flags;
	TfrxObjectCategories Category;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxObjectItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxObjectItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxComponentEditorItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	Frxclass::TfrxComponentClass ComponentClass;
	TfrxComponentEditorClass ComponentEditor;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxComponentEditorItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxComponentEditorItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPropertyEditorItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	System::Typinfo::TTypeInfo *PropertyType;
	System::TClass ComponentClass;
	System::UnicodeString PropertyName;
	TfrxPropertyEditorClass EditorClass;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxPropertyEditorItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxPropertyEditorItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxExportFilterItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	Frxclass::TfrxCustomExportFilter* Filter;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxExportFilterItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxExportFilterItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxWizardItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	Frxclass::TfrxWizardClass ClassRef;
	Vcl::Graphics::TBitmap* ButtonBmp;
	Vcl::Graphics::TBitmap* WizardButtonBmp;
	int ButtonImageIndex;
	int ToolBarButtonImageIndex;
	bool IsToolbarWizard;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxWizardItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxWizardItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxObjectCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxObjectItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxObjectItem* __fastcall GetObjectItem(int Index);
	
public:
	__fastcall TfrxObjectCollection();
	void __fastcall RegisterCategory(const System::UnicodeString CategoryName, Vcl::Graphics::TBitmap* ButtonBmp, const System::UnicodeString ButtonHint, int ImageIndex = 0xffffffff);
	void __fastcall RegisterObject(Frxclass::TfrxComponentClass ClassRef, Vcl::Graphics::TBitmap* ButtonBmp, const System::UnicodeString CategoryName = System::UnicodeString());
	void __fastcall RegisterObject1(Frxclass::TfrxComponentClass ClassRef, Vcl::Graphics::TBitmap* ButtonBmp, const System::UnicodeString ButtonHint = System::UnicodeString(), const System::UnicodeString CategoryName = System::UnicodeString(), int Flags = 0x0, int ImageIndex = 0xffffffff, TfrxObjectCategories Category = TfrxObjectCategories() );
	void __fastcall Unregister(Frxclass::TfrxComponentClass ClassRef);
	__property TfrxObjectItem* Items[int Index] = {read=GetObjectItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxObjectCollection() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxComponentEditorCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxComponentEditorItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxComponentEditorItem* __fastcall GetComponentEditorItem(int Index);
	
public:
	__fastcall TfrxComponentEditorCollection();
	void __fastcall Register(Frxclass::TfrxComponentClass ComponentClass, TfrxComponentEditorClass ComponentEditor);
	void __fastcall UnRegister(TfrxComponentEditorClass ComponentEditor);
	TfrxComponentEditor* __fastcall GetComponentEditor(Frxclass::TfrxComponent* Component, Frxclass::TfrxCustomDesigner* Designer, Vcl::Menus::TMenu* Menu);
	__property TfrxComponentEditorItem* Items[int Index] = {read=GetComponentEditorItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxComponentEditorCollection() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPropertyEditorCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxPropertyEditorItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	int FEventEditorItem;
	TfrxPropertyEditorItem* __fastcall GetPropertyEditorItem(int Index);
	
public:
	__fastcall TfrxPropertyEditorCollection();
	void __fastcall Register(System::Typinfo::PTypeInfo PropertyType, System::TClass ComponentClass, const System::UnicodeString PropertyName, TfrxPropertyEditorClass EditorClass);
	void __fastcall RegisterEventEditor(TfrxPropertyEditorClass EditorClass);
	void __fastcall UnRegister(TfrxPropertyEditorClass EditorClass);
	int __fastcall GetPropertyEditor(System::Typinfo::PTypeInfo PropertyType, System::Classes::TPersistent* Component, System::UnicodeString PropertyName);
	__property TfrxPropertyEditorItem* Items[int Index] = {read=GetPropertyEditorItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxPropertyEditorCollection() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxExportFilterCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxExportFilterItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxExportFilterItem* __fastcall GetExportFilterItem(int Index);
	
public:
	__fastcall TfrxExportFilterCollection();
	void __fastcall Register(Frxclass::TfrxCustomExportFilter* Filter);
	void __fastcall Unregister(Frxclass::TfrxCustomExportFilter* Filter);
	__property TfrxExportFilterItem* Items[int Index] = {read=GetExportFilterItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxExportFilterCollection() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSaveFilterItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	Frxclass::TfrxCustomIOTransport* SaveFilter;
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxSaveFilterItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxSaveFilterItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSaveFiltersCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxSaveFilterItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxSaveFilterItem* __fastcall GetSaveFilterItem(int Index);
	
public:
	__fastcall TfrxSaveFiltersCollection();
	void __fastcall Register(Frxclass::TfrxCustomIOTransport* Filter);
	void __fastcall Unregister(Frxclass::TfrxCustomIOTransport* Filter);
	__property TfrxSaveFilterItem* Items[int Index] = {read=GetSaveFilterItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxSaveFiltersCollection() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxWizardCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxWizardItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxWizardItem* __fastcall GetWizardItem(int Index);
	
public:
	__fastcall TfrxWizardCollection();
	void __fastcall Register(Frxclass::TfrxWizardClass ClassRef, Vcl::Graphics::TBitmap* ButtonBmp, bool IsToolbarWizard = false, Vcl::Graphics::TBitmap* Bmp32x32 = (Vcl::Graphics::TBitmap*)(0x0));
	void __fastcall Register1(Frxclass::TfrxWizardClass ClassRef, int ImageIndex);
	void __fastcall Unregister(Frxclass::TfrxWizardClass ClassRef);
	__property TfrxWizardItem* Items[int Index] = {read=GetWizardItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxWizardCollection() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall frxHideProperties(System::TClass ComponentClass, const System::UnicodeString Properties);
extern DELPHI_PACKAGE TfrxPropertyList* __fastcall frxCreatePropertyList(System::Classes::TList* ComponentList, Frxclass::TfrxCustomDesigner* Designer);
extern DELPHI_PACKAGE TfrxObjectCollection* __fastcall frxObjects(void);
extern DELPHI_PACKAGE TfrxComponentEditorCollection* __fastcall frxComponentEditors(void);
extern DELPHI_PACKAGE TfrxPropertyEditorCollection* __fastcall frxPropertyEditors(void);
extern DELPHI_PACKAGE TfrxExportFilterCollection* __fastcall frxExportFilters(void);
extern DELPHI_PACKAGE TfrxWizardCollection* __fastcall frxWizards(void);
}	/* namespace Frxdsgnintf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDSGNINTF)
using namespace Frxdsgnintf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdsgnintfHPP
