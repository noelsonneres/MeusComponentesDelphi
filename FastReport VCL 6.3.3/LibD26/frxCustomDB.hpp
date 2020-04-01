// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxCustomDB.pas' rev: 33.00 (Windows)

#ifndef FrxcustomdbHPP
#define FrxcustomdbHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Data.DB.hpp>
#include <frxClass.hpp>
#include <frxDBSet.hpp>
#include <Vcl.DBCtrls.hpp>
#include <System.Variants.hpp>
#include <fqbClass.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxcustomdb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCustomDataset;
class DELPHICLASS TfrxCustomTable;
class DELPHICLASS TfrxParamItem;
class DELPHICLASS TfrxParams;
class DELPHICLASS TfrxCustomQuery;
class DELPHICLASS TfrxDBLookupComboBox;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxCustomDataset : public Frxdbset::TfrxDBDataset
{
	typedef Frxdbset::TfrxDBDataset inherited;
	
private:
	bool FDBConnected;
	Data::Db::TDataSource* FDataSource;
	Frxdbset::TfrxDBDataset* FMaster;
	System::UnicodeString FMasterFields;
	void __fastcall SetActive(bool Value);
	void __fastcall SetFilter(const System::UnicodeString Value);
	void __fastcall SetFiltered(bool Value);
	bool __fastcall GetActive();
	Data::Db::TFields* __fastcall GetFields();
	System::UnicodeString __fastcall GetFilter();
	bool __fastcall GetFiltered();
	void __fastcall InternalSetMaster(Frxdbset::TfrxDBDataset* const Value);
	void __fastcall InternalSetMasterFields(const System::UnicodeString Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetParent(Frxclass::TfrxComponent* AParent);
	virtual void __fastcall SetUserName(const System::UnicodeString Value);
	virtual void __fastcall SetMaster(Data::Db::TDataSource* const Value);
	virtual void __fastcall SetMasterFields(const System::UnicodeString Value);
	__property DataSet;
	
public:
	__fastcall virtual TfrxCustomDataset(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomDataset();
	virtual void __fastcall OnPaste();
	__property bool DBConnected = {read=FDBConnected, write=FDBConnected, nodefault};
	__property Data::Db::TFields* Fields = {read=GetFields};
	__property System::UnicodeString MasterFields = {read=FMasterFields, write=InternalSetMasterFields};
	__property bool Active = {read=GetActive, write=SetActive, default=0};
	
__published:
	__property System::UnicodeString Filter = {read=GetFilter, write=SetFilter};
	__property bool Filtered = {read=GetFiltered, write=SetFiltered, default=0};
	__property Frxdbset::TfrxDBDataset* Master = {read=FMaster, write=InternalSetMaster};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomDataset(System::Classes::TComponent* AOwner, System::Word Flags) : Frxdbset::TfrxDBDataset(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxCustomTable : public TfrxCustomDataset
{
	typedef TfrxCustomDataset inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetIndexFieldNames();
	virtual System::UnicodeString __fastcall GetIndexName();
	virtual System::UnicodeString __fastcall GetTableName();
	virtual void __fastcall SetIndexFieldNames(const System::UnicodeString Value);
	virtual void __fastcall SetIndexName(const System::UnicodeString Value);
	virtual void __fastcall SetTableName(const System::UnicodeString Value);
	__property DataSet;
	
__published:
	__property MasterFields = {default=0};
	__property System::UnicodeString TableName = {read=GetTableName, write=SetTableName};
	__property System::UnicodeString IndexName = {read=GetIndexName, write=SetIndexName};
	__property System::UnicodeString IndexFieldNames = {read=GetIndexFieldNames, write=SetIndexFieldNames};
public:
	/* TfrxCustomDataset.Create */ inline __fastcall virtual TfrxCustomTable(System::Classes::TComponent* AOwner) : TfrxCustomDataset(AOwner) { }
	/* TfrxCustomDataset.Destroy */ inline __fastcall virtual ~TfrxCustomTable() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomTable(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomDataset(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxParamItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	Data::Db::TFieldType FDataType;
	System::UnicodeString FExpression;
	System::UnicodeString FName;
	System::Variant FValue;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::Variant Value = {read=FValue, write=FValue};
	
__published:
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property Data::Db::TFieldType DataType = {read=FDataType, write=FDataType, nodefault};
	__property System::UnicodeString Expression = {read=FExpression, write=FExpression};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxParamItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxParamItem() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxParams : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxParamItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	bool FIgnoreDuplicates;
	TfrxParamItem* __fastcall GetParam(int Index);
	
public:
	__fastcall TfrxParams();
	HIDESBASE TfrxParamItem* __fastcall Add();
	TfrxParamItem* __fastcall Find(const System::UnicodeString Name);
	int __fastcall IndexOf(const System::UnicodeString Name);
	void __fastcall UpdateParams(const System::UnicodeString SQL);
	__property TfrxParamItem* Items[int Index] = {read=GetParam/*, default*/};
	__property bool IgnoreDuplicates = {read=FIgnoreDuplicates, write=FIgnoreDuplicates, nodefault};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxParams() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxCustomQuery : public TfrxCustomDataset
{
	typedef TfrxCustomDataset inherited;
	
private:
	TfrxParams* FParams;
	Data::Db::TDataSetNotifyEvent FSaveOnBeforeOpen;
	System::Classes::TNotifyEvent FSaveOnChange;
	System::UnicodeString FSQLSchema;
	void __fastcall ReadData(System::Classes::TReader* Reader);
	void __fastcall SetParams(TfrxParams* Value);
	void __fastcall WriteData(System::Classes::TWriter* Writer);
	bool __fastcall GetIgnoreDupParams();
	void __fastcall SetIgnoreDupParams(const bool Value);
	
protected:
	Data::Db::TDataSetNotifyEvent FSaveOnBeforeRefresh;
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall OnBeforeOpen(Data::Db::TDataSet* DataSet);
	virtual void __fastcall OnBeforeRefresh(Data::Db::TDataSet* DataSet);
	virtual void __fastcall OnChangeSQL(System::TObject* Sender);
	virtual void __fastcall SetSQL(System::Classes::TStrings* Value);
	virtual System::Classes::TStrings* __fastcall GetSQL();
	
public:
	__fastcall virtual TfrxCustomQuery(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomQuery();
	virtual void __fastcall UpdateParams();
	TfrxParamItem* __fastcall ParamByName(const System::UnicodeString Value);
	virtual Fqbclass::TfqbEngine* __fastcall QBEngine();
	
__published:
	__property bool IgnoreDupParams = {read=GetIgnoreDupParams, write=SetIgnoreDupParams, nodefault};
	__property TfrxParams* Params = {read=FParams, write=SetParams};
	__property System::Classes::TStrings* SQL = {read=GetSQL, write=SetSQL};
	__property System::UnicodeString SQLSchema = {read=FSQLSchema, write=FSQLSchema};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomQuery(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomDataset(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDBLookupComboBox : public Frxclass::TfrxDialogControl
{
	typedef Frxclass::TfrxDialogControl inherited;
	
private:
	Frxdbset::TfrxDBDataset* FDataSet;
	System::UnicodeString FDataSetName;
	Data::Db::TDataSource* FDataSource;
	Vcl::Dbctrls::TDBLookupComboBox* FDBLookupComboBox;
	bool FAutoOpenDataSet;
	System::UnicodeString __fastcall GetDataSetName();
	System::UnicodeString __fastcall GetKeyField();
	System::Variant __fastcall GetKeyValue();
	System::UnicodeString __fastcall GetListField();
	System::UnicodeString __fastcall GetText();
	void __fastcall SetDataSet(Frxdbset::TfrxDBDataset* const Value);
	void __fastcall SetDataSetName(const System::UnicodeString Value);
	void __fastcall SetKeyField(System::UnicodeString Value);
	void __fastcall SetKeyValue(const System::Variant &Value);
	void __fastcall SetListField(System::UnicodeString Value);
	void __fastcall UpdateDataSet();
	void __fastcall OnOpenDS(System::TObject* Sender);
	int __fastcall GetDropDownWidth();
	void __fastcall SetDropDownWidth(const int Value);
	int __fastcall GetDropDownRows();
	void __fastcall SetDropDownRows(const int Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TfrxDBLookupComboBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDBLookupComboBox();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall BeforeStartReport();
	__property Vcl::Dbctrls::TDBLookupComboBox* DBLookupComboBox = {read=FDBLookupComboBox};
	__property System::Variant KeyValue = {read=GetKeyValue, write=SetKeyValue};
	__property System::UnicodeString Text = {read=GetText};
	
__published:
	__property bool AutoOpenDataSet = {read=FAutoOpenDataSet, write=FAutoOpenDataSet, default=0};
	__property Frxdbset::TfrxDBDataset* DataSet = {read=FDataSet, write=SetDataSet};
	__property System::UnicodeString DataSetName = {read=GetDataSetName, write=SetDataSetName};
	__property System::UnicodeString ListField = {read=GetListField, write=SetListField};
	__property System::UnicodeString KeyField = {read=GetKeyField, write=SetKeyField};
	__property int DropDownWidth = {read=GetDropDownWidth, write=SetDropDownWidth, nodefault};
	__property int DropDownRows = {read=GetDropDownRows, write=SetDropDownRows, nodefault};
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
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDBLookupComboBox(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxDialogControl(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall frxParamsToTParams(TfrxCustomQuery* Query, Data::Db::TParams* Params);
}	/* namespace Frxcustomdb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCUSTOMDB)
using namespace Frxcustomdb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxcustomdbHPP
