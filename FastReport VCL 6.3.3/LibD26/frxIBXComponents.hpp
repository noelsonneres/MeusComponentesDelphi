// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIBXComponents.pas' rev: 33.00 (Windows)

#ifndef FrxibxcomponentsHPP
#define FrxibxcomponentsHPP

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
#include <IBX.IBDatabase.hpp>
#include <IBX.IBTable.hpp>
#include <IBX.IBQuery.hpp>
#include <System.Variants.hpp>
#include <fqbClass.hpp>
#include <frxDBSet.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxibxcomponents
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxIBXComponents;
class DELPHICLASS TfrxIBXDatabase;
class DELPHICLASS TfrxIBXTable;
class DELPHICLASS TfrxIBXQuery;
class DELPHICLASS TfrxEngineIBX;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxIBXComponents : public Frxclass::TfrxDBComponents
{
	typedef Frxclass::TfrxDBComponents inherited;
	
private:
	Ibx::Ibdatabase::TIBDatabase* FDefaultDatabase;
	TfrxIBXComponents* FOldComponents;
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetDefaultDatabase(Ibx::Ibdatabase::TIBDatabase* Value);
	
public:
	__fastcall virtual TfrxIBXComponents(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxIBXComponents();
	virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property Ibx::Ibdatabase::TIBDatabase* DefaultDatabase = {read=FDefaultDatabase, write=SetDefaultDatabase};
};


class PASCALIMPLEMENTATION TfrxIBXDatabase : public Frxclass::TfrxCustomDatabase
{
	typedef Frxclass::TfrxCustomDatabase inherited;
	
private:
	Ibx::Ibdatabase::TIBDatabase* FDatabase;
	Ibx::Ibdatabase::TIBTransaction* FTransaction;
	int __fastcall GetSQLDialect();
	void __fastcall SetSQLDialect(const int Value);
	
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
	__fastcall virtual TfrxIBXDatabase(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxIBXDatabase();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall SetLogin(const System::UnicodeString Login, const System::UnicodeString Password);
	__property Ibx::Ibdatabase::TIBDatabase* Database = {read=FDatabase};
	
__published:
	__property DatabaseName = {default=0};
	__property LoginPrompt = {default=1};
	__property Params;
	__property int SQLDialect = {read=GetSQLDialect, write=SetSQLDialect, nodefault};
	__property Connected = {default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxIBXDatabase(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxCustomDatabase(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxIBXTable : public Frxcustomdb::TfrxCustomTable
{
	typedef Frxcustomdb::TfrxCustomTable inherited;
	
private:
	TfrxIBXDatabase* FDatabase;
	Ibx::Ibtable::TIBTable* FTable;
	void __fastcall SetDatabase(TfrxIBXDatabase* const Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetMaster(Data::Db::TDataSource* const Value);
	virtual void __fastcall SetMasterFields(const System::UnicodeString Value);
	virtual void __fastcall SetIndexFieldNames(const System::UnicodeString Value);
	virtual void __fastcall SetIndexName(const System::UnicodeString Value);
	virtual void __fastcall SetTableName(const System::UnicodeString Value);
	virtual System::UnicodeString __fastcall GetIndexFieldNames();
	virtual System::UnicodeString __fastcall GetIndexName();
	virtual System::UnicodeString __fastcall GetTableName();
	
public:
	__fastcall virtual TfrxIBXTable(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxIBXTable(System::Classes::TComponent* AOwner, System::Word Flags);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall BeforeStartReport();
	__property Ibx::Ibtable::TIBTable* Table = {read=FTable};
	
__published:
	__property TfrxIBXDatabase* Database = {read=FDatabase, write=SetDatabase};
public:
	/* TfrxCustomDataset.Destroy */ inline __fastcall virtual ~TfrxIBXTable() { }
	
};


class PASCALIMPLEMENTATION TfrxIBXQuery : public Frxcustomdb::TfrxCustomQuery
{
	typedef Frxcustomdb::TfrxCustomQuery inherited;
	
private:
	TfrxIBXDatabase* FDatabase;
	Ibx::Ibquery::TIBQuery* FQuery;
	void __fastcall SetDatabase(TfrxIBXDatabase* const Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetMaster(Data::Db::TDataSource* const Value);
	virtual void __fastcall SetSQL(System::Classes::TStrings* Value);
	virtual System::Classes::TStrings* __fastcall GetSQL();
	
public:
	__fastcall virtual TfrxIBXQuery(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxIBXQuery(System::Classes::TComponent* AOwner, System::Word Flags);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall BeforeStartReport();
	virtual void __fastcall UpdateParams();
	virtual Fqbclass::TfqbEngine* __fastcall QBEngine();
	__property Ibx::Ibquery::TIBQuery* Query = {read=FQuery};
	
__published:
	__property TfrxIBXDatabase* Database = {read=FDatabase, write=SetDatabase};
public:
	/* TfrxCustomQuery.Destroy */ inline __fastcall virtual ~TfrxIBXQuery() { }
	
};


class PASCALIMPLEMENTATION TfrxEngineIBX : public Fqbclass::TfqbEngine
{
	typedef Fqbclass::TfqbEngine inherited;
	
private:
	Ibx::Ibquery::TIBQuery* FQuery;
	
public:
	__fastcall virtual TfrxEngineIBX(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxEngineIBX();
	virtual void __fastcall ReadTableList(System::Classes::TStrings* ATableList);
	virtual void __fastcall ReadFieldList(const System::UnicodeString ATableName, Fqbclass::TfqbFieldList* &AFieldList);
	virtual Data::Db::TDataSet* __fastcall ResultDataSet();
	virtual void __fastcall SetSQL(const System::UnicodeString Value);
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrxIBXComponents* IBXComponents;
}	/* namespace Frxibxcomponents */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIBXCOMPONENTS)
using namespace Frxibxcomponents;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxibxcomponentsHPP
