// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxDBXComponents.pas' rev: 33.00 (Windows)

#ifndef FrxdbxcomponentsHPP
#define FrxdbxcomponentsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <frxClass.hpp>
#include <frxCustomDB.hpp>
#include <Data.DB.hpp>
#include <Data.DBCommonTypes.hpp>
#include <Data.SqlExpr.hpp>
#include <Datasnap.Provider.hpp>
#include <Datasnap.DBClient.hpp>
#include <System.Variants.hpp>
#include <fqbClass.hpp>
#include <frxDBSet.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxdbxcomponents
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxDBXDataset;
class DELPHICLASS TfrxDBXComponents;
class DELPHICLASS TfrxDBXDatabase;
class DELPHICLASS TfrxDBXTable;
class DELPHICLASS TfrxDBXQuery;
class DELPHICLASS TfrxEngineDBX;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxDBXDataset : public Datasnap::Dbclient::TCustomClientDataSet
{
	typedef Datasnap::Dbclient::TCustomClientDataSet inherited;
	
private:
	Data::Db::TDataSet* FDataSet;
	Datasnap::Provider::TDataSetProvider* FProvider;
	void __fastcall SetDataset(Data::Db::TDataSet* const Value);
	
protected:
	virtual void __fastcall OpenCursor(bool InfoQuery);
	
public:
	__fastcall virtual TfrxDBXDataset(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDBXDataset();
	__property Data::Db::TDataSet* Dataset = {read=FDataSet, write=SetDataset};
};


class PASCALIMPLEMENTATION TfrxDBXComponents : public Frxclass::TfrxDBComponents
{
	typedef Frxclass::TfrxDBComponents inherited;
	
private:
	Data::Sqlexpr::TSQLConnection* FDefaultDatabase;
	TfrxDBXComponents* FOldComponents;
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetDefaultDatabase(Data::Sqlexpr::TSQLConnection* Value);
	
public:
	__fastcall virtual TfrxDBXComponents(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDBXComponents();
	virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property Data::Sqlexpr::TSQLConnection* DefaultDatabase = {read=FDefaultDatabase, write=SetDefaultDatabase};
};


class PASCALIMPLEMENTATION TfrxDBXDatabase : public Frxclass::TfrxCustomDatabase
{
	typedef Frxclass::TfrxCustomDatabase inherited;
	
private:
	Data::Sqlexpr::TSQLConnection* FDatabase;
	System::Classes::TStrings* FStrings;
	bool FLock;
	System::UnicodeString __fastcall GetDriverName();
	System::UnicodeString __fastcall GetGetDriverFunc();
	System::UnicodeString __fastcall GetLibraryName();
	System::UnicodeString __fastcall GetVendorLib();
	void __fastcall SetDriverName(const System::UnicodeString Value);
	void __fastcall SetGetDriverFunc(const System::UnicodeString Value);
	void __fastcall SetLibraryName(const System::UnicodeString Value);
	void __fastcall SetVendorLib(const System::UnicodeString Value);
	void __fastcall OnChange(System::TObject* Sender);
	
protected:
	virtual void __fastcall SetConnected(bool Value);
	virtual void __fastcall SetDatabaseName(const System::UnicodeString Value);
	virtual void __fastcall SetLoginPrompt(bool Value);
	virtual void __fastcall SetParams(System::Classes::TStrings* Value);
	virtual bool __fastcall GetConnected();
	virtual System::UnicodeString __fastcall GetDatabaseName();
	virtual bool __fastcall GetLoginPrompt();
	virtual System::Classes::TStrings* __fastcall GetParams();
	
public:
	__fastcall virtual TfrxDBXDatabase(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDBXDatabase();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Data::Sqlexpr::TSQLConnection* Database = {read=FDatabase};
	
__published:
	__property System::UnicodeString ConnectionName = {read=GetDatabaseName, write=SetDatabaseName};
	__property System::UnicodeString DriverName = {read=GetDriverName, write=SetDriverName};
	__property System::UnicodeString GetDriverFunc = {read=GetGetDriverFunc, write=SetGetDriverFunc};
	__property System::UnicodeString LibraryName = {read=GetLibraryName, write=SetLibraryName};
	__property LoginPrompt = {default=1};
	__property Params;
	__property System::UnicodeString VendorLib = {read=GetVendorLib, write=SetVendorLib};
	__property Connected = {default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDBXDatabase(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxCustomDatabase(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDBXTable : public Frxcustomdb::TfrxCustomTable
{
	typedef Frxcustomdb::TfrxCustomTable inherited;
	
private:
	TfrxDBXDatabase* FDatabase;
	Data::Sqlexpr::TSQLTable* FTable;
	void __fastcall SetDatabase(TfrxDBXDatabase* const Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetMaster(Data::Db::TDataSource* const Value);
	virtual void __fastcall SetMasterFields(const System::UnicodeString Value);
	virtual void __fastcall SetIndexName(const System::UnicodeString Value);
	virtual void __fastcall SetIndexFieldNames(const System::UnicodeString Value);
	virtual void __fastcall SetTableName(const System::UnicodeString Value);
	virtual System::UnicodeString __fastcall GetIndexName();
	virtual System::UnicodeString __fastcall GetIndexFieldNames();
	virtual System::UnicodeString __fastcall GetTableName();
	
public:
	__fastcall virtual TfrxDBXTable(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxDBXTable(System::Classes::TComponent* AOwner, System::Word Flags);
	__fastcall virtual ~TfrxDBXTable();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall BeforeStartReport();
	__property Data::Sqlexpr::TSQLTable* Table = {read=FTable};
	
__published:
	__property TfrxDBXDatabase* Database = {read=FDatabase, write=SetDatabase};
};


class PASCALIMPLEMENTATION TfrxDBXQuery : public Frxcustomdb::TfrxCustomQuery
{
	typedef Frxcustomdb::TfrxCustomQuery inherited;
	
private:
	TfrxDBXDatabase* FDatabase;
	Data::Sqlexpr::TSQLQuery* FQuery;
	System::Classes::TStrings* FStrings;
	bool FLock;
	void __fastcall SetDatabase(TfrxDBXDatabase* const Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetMaster(Data::Db::TDataSource* const Value);
	virtual void __fastcall SetSQL(System::Classes::TStrings* Value);
	virtual System::Classes::TStrings* __fastcall GetSQL();
	virtual void __fastcall OnChangeSQL(System::TObject* Sender);
	
public:
	__fastcall virtual TfrxDBXQuery(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxDBXQuery(System::Classes::TComponent* AOwner, System::Word Flags);
	__fastcall virtual ~TfrxDBXQuery();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall BeforeStartReport();
	virtual void __fastcall UpdateParams();
	virtual Fqbclass::TfqbEngine* __fastcall QBEngine();
	__property Data::Sqlexpr::TSQLQuery* Query = {read=FQuery};
	
__published:
	__property TfrxDBXDatabase* Database = {read=FDatabase, write=SetDatabase};
};


class PASCALIMPLEMENTATION TfrxEngineDBX : public Fqbclass::TfqbEngine
{
	typedef Fqbclass::TfqbEngine inherited;
	
private:
	Data::Sqlexpr::TSQLQuery* FQuery;
	TfrxDBXDataset* FDBXDataset;
	
public:
	__fastcall virtual TfrxEngineDBX(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxEngineDBX();
	virtual void __fastcall ReadTableList(System::Classes::TStrings* ATableList);
	virtual void __fastcall ReadFieldList(const System::UnicodeString ATableName, Fqbclass::TfqbFieldList* &AFieldList);
	virtual Data::Db::TDataSet* __fastcall ResultDataSet();
	virtual void __fastcall SetSQL(const System::UnicodeString Value);
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxDBXComponents* DBXComponents;
}	/* namespace Frxdbxcomponents */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXDBXCOMPONENTS)
using namespace Frxdbxcomponents;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxdbxcomponentsHPP
