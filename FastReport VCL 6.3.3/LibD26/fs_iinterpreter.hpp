// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_iinterpreter.pas' rev: 33.00 (Windows)

#ifndef Fs_iinterpreterHPP
#define Fs_iinterpreterHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <fs_xml.hpp>
#include <System.Variants.hpp>
#include <System.SyncObjs.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fs_iinterpreter
{
//-- forward type declarations -----------------------------------------------
struct TfsTypeRec;
class DELPHICLASS TfsItemList;
class DELPHICLASS TfsScript;
class DELPHICLASS TfsStatement;
class DELPHICLASS TfsAssignmentStmt;
class DELPHICLASS TfsAssignPlusStmt;
class DELPHICLASS TfsAssignMinusStmt;
class DELPHICLASS TfsAssignMulStmt;
class DELPHICLASS TfsAssignDivStmt;
class DELPHICLASS TfsCallStmt;
class DELPHICLASS TfsIfStmt;
class DELPHICLASS TfsCaseSelector;
class DELPHICLASS TfsCaseStmt;
class DELPHICLASS TfsRepeatStmt;
class DELPHICLASS TfsWhileStmt;
class DELPHICLASS TfsForStmt;
class DELPHICLASS TfsVbForStmt;
class DELPHICLASS TfsCppForStmt;
class DELPHICLASS TfsTryStmt;
class DELPHICLASS TfsBreakStmt;
class DELPHICLASS TfsContinueStmt;
class DELPHICLASS TfsExitStmt;
class DELPHICLASS TfsWithStmt;
class DELPHICLASS TfsCustomVariable;
class DELPHICLASS TfsVariable;
class DELPHICLASS TfsTypeVariable;
class DELPHICLASS TfsStringVariable;
class DELPHICLASS TfsParamItem;
class DELPHICLASS TfsLocalVariablesHelper;
class DELPHICLASS TfsProcVariable;
class DELPHICLASS TfsCustomExpression;
class DELPHICLASS TfsCustomHelper;
class DELPHICLASS TfsArrayHelper;
class DELPHICLASS TfsStringHelper;
class DELPHICLASS TfsPropertyHelper;
class DELPHICLASS TfsMethodHelper;
class DELPHICLASS TfsComponentHelper;
class DELPHICLASS TfsCustomEvent;
class DELPHICLASS TfsEventHelper;
class DELPHICLASS TfsClassVariable;
class DELPHICLASS TfsDesignatorItem;
class DELPHICLASS TfsDesignator;
class DELPHICLASS TfsVariableDesignator;
class DELPHICLASS TfsStringDesignator;
class DELPHICLASS TfsArrayDesignator;
class DELPHICLASS TfsSetExpression;
class DELPHICLASS TfsRTTIModule;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfsVarType : unsigned char { fvtInt, fvtBool, fvtFloat, fvtChar, fvtString, fvtClass, fvtArray, fvtVariant, fvtEnum, fvtConstructor, fvtInt64 };

typedef NativeInt frxInteger;

struct DECLSPEC_DRECORD TfsTypeRec
{
public:
	TfsVarType Typ;
	System::UnicodeString TypeName;
};


typedef System::Variant __fastcall (__closure *TfsGetValueEvent)(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString PropName);

typedef void __fastcall (__closure *TfsSetValueEvent)(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString PropName, const System::Variant &Value);

typedef System::Variant __fastcall (__closure *TfsGetValueNewEvent)(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString PropName, TfsPropertyHelper* Caler);

typedef void __fastcall (__closure *TfsSetValueNewEvent)(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString PropName, const System::Variant &Value, TfsPropertyHelper* Caller);

typedef System::Variant __fastcall (__closure *TfsCallMethodNewEvent)(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString MethodName, TfsMethodHelper* Caller);

typedef System::Variant __fastcall (__closure *TfsCallMethodEvent)(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString MethodName, System::Variant &Params);

typedef void __fastcall (__closure *TfsRunLineEvent)(TfsScript* Sender, const System::UnicodeString UnitName, const System::UnicodeString SourcePos);

typedef void __fastcall (__closure *TfsGetUnitEvent)(TfsScript* Sender, const System::UnicodeString UnitName, System::UnicodeString &UnitText);

typedef System::Variant __fastcall (__closure *TfsGetVariableValueEvent)(System::UnicodeString VarName, TfsVarType VarTyp, const System::Variant &OldValue);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsItemList : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TList* FItems;
	virtual void __fastcall Clear();
	
public:
	__fastcall TfsItemList();
	__fastcall virtual ~TfsItemList();
	void __fastcall Add(System::TObject* Item);
	int __fastcall Count();
	void __fastcall Remove(System::TObject* Item);
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfsScript : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	System::TObject* FAddedBy;
	bool FBreakCalled;
	bool FContinueCalled;
	bool FExitCalled;
	System::UnicodeString FErrorMsg;
	System::UnicodeString FErrorPos;
	System::UnicodeString FErrorUnit;
	bool FExtendedCharset;
	System::Classes::TStringList* FItems;
	bool FIsRunning;
	System::Classes::TStrings* FLines;
	System::Classes::TStrings* FMacros;
	bool FMainProg;
	TfsGetUnitEvent FOnGetILUnit;
	TfsGetUnitEvent FOnGetUnit;
	TfsRunLineEvent FOnRunLine;
	TfsGetVariableValueEvent FOnGetVarValue;
	TfsScript* FParent;
	TfsScript* FProgRunning;
	bool FRTTIAdded;
	TfsStatement* FStatement;
	System::UnicodeString FSyntaxType;
	bool FTerminated;
	System::Classes::TStringList* FUnitLines;
	System::Classes::TStrings* FIncludePath;
	bool FUseClassLateBinding;
	bool FEvaluteRiseError;
	bool FClearLocalVars;
	System::UnicodeString FLastSourcePos;
	System::UnicodeString FProgName;
	TfsCustomVariable* __fastcall GetItem(int Index);
	void __fastcall RunLine(const System::UnicodeString UnitName, const System::UnicodeString Index);
	System::Variant __fastcall GetVariables(System::UnicodeString Index);
	void __fastcall SetVariables(System::UnicodeString Index, const System::Variant &Value);
	void __fastcall SetLines(System::Classes::TStrings* const Value);
	System::UnicodeString __fastcall GetProgName();
	void __fastcall SetProgName(const System::UnicodeString Value);
	
public:
	__fastcall virtual TfsScript(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfsScript();
	void __fastcall Add(const System::UnicodeString Name, System::TObject* Item);
	void __fastcall AddCodeLine(const System::UnicodeString UnitName, const System::UnicodeString APos);
	void __fastcall AddRTTI();
	HIDESBASE void __fastcall Remove(System::TObject* Item);
	void __fastcall RemoveItems(System::TObject* Owner);
	void __fastcall Clear();
	void __fastcall ClearItems(System::TObject* Owner);
	void __fastcall ClearRTTI();
	int __fastcall Count();
	DYNAMIC TfsClassVariable* __fastcall AddClass(System::TClass AClass, const System::UnicodeString Ancestor);
	DYNAMIC void __fastcall AddConst(const System::UnicodeString Name, const System::UnicodeString Typ, const System::Variant &Value);
	DYNAMIC void __fastcall AddEnum(const System::UnicodeString Typ, const System::UnicodeString Names);
	DYNAMIC void __fastcall AddEnumSet(const System::UnicodeString Typ, const System::UnicodeString Names);
	DYNAMIC void __fastcall AddComponent(System::Classes::TComponent* Form);
	DYNAMIC void __fastcall AddForm(System::Classes::TComponent* Form);
	DYNAMIC void __fastcall AddMethod(const System::UnicodeString Syntax, TfsCallMethodNewEvent CallEvent, const System::UnicodeString Category = System::UnicodeString(), const System::UnicodeString Description = System::UnicodeString())/* overload */;
	DYNAMIC void __fastcall AddMethod(const System::UnicodeString Syntax, TfsCallMethodEvent CallEvent, const System::UnicodeString Category = System::UnicodeString(), const System::UnicodeString Description = System::UnicodeString())/* overload */;
	DYNAMIC void __fastcall AddObject(const System::UnicodeString Name, System::TObject* Obj);
	DYNAMIC void __fastcall AddVariable(const System::UnicodeString Name, const System::UnicodeString Typ, const System::Variant &Value);
	DYNAMIC void __fastcall AddType(const System::UnicodeString TypeName, TfsVarType ParentType);
	System::Variant __fastcall CallFunction(const System::UnicodeString Name, const System::Variant &Params, bool sGlobal = false);
	System::Variant __fastcall CallFunction1(const System::UnicodeString Name, System::Variant &Params, bool sGlobal = false);
	System::Variant __fastcall CallFunction2(TfsProcVariable* const Func, const System::Variant &Params);
	bool __fastcall Compile();
	void __fastcall Execute();
	bool __fastcall Run();
	void __fastcall Terminate();
	System::Variant __fastcall Evaluate(const System::UnicodeString Expression);
	bool __fastcall IsExecutableLine(int LineN, const System::UnicodeString UnitName = System::UnicodeString());
	bool __fastcall GetILCode(System::Classes::TStream* Stream);
	bool __fastcall SetILCode(System::Classes::TStream* Stream);
	TfsCustomVariable* __fastcall Find(const System::UnicodeString Name);
	TfsClassVariable* __fastcall FindClass(const System::UnicodeString Name);
	TfsCustomVariable* __fastcall FindLocal(const System::UnicodeString Name);
	__property System::TObject* AddedBy = {read=FAddedBy, write=FAddedBy};
	__property bool ClearLocalVars = {read=FClearLocalVars, write=FClearLocalVars, nodefault};
	__property System::UnicodeString ErrorMsg = {read=FErrorMsg, write=FErrorMsg};
	__property System::UnicodeString ErrorPos = {read=FErrorPos, write=FErrorPos};
	__property System::UnicodeString ErrorUnit = {read=FErrorUnit, write=FErrorUnit};
	__property bool ExtendedCharset = {read=FExtendedCharset, write=FExtendedCharset, nodefault};
	__property TfsCustomVariable* Items[int Index] = {read=GetItem};
	__property bool IsRunning = {read=FIsRunning, nodefault};
	__property System::Classes::TStrings* Macros = {read=FMacros};
	__property bool MainProg = {read=FMainProg, write=FMainProg, nodefault};
	__property TfsScript* Parent = {read=FParent, write=FParent};
	__property TfsScript* ProgRunning = {read=FProgRunning};
	__property System::UnicodeString ProgName = {read=GetProgName, write=SetProgName};
	__property TfsStatement* Statement = {read=FStatement};
	__property System::Variant Variables[System::UnicodeString Index] = {read=GetVariables, write=SetVariables};
	__property System::Classes::TStrings* IncludePath = {read=FIncludePath};
	__property bool UseClassLateBinding = {read=FUseClassLateBinding, write=FUseClassLateBinding, nodefault};
	__property bool EvaluteRiseError = {read=FEvaluteRiseError, nodefault};
	
__published:
	__property System::Classes::TStrings* Lines = {read=FLines, write=SetLines};
	__property System::UnicodeString SyntaxType = {read=FSyntaxType, write=FSyntaxType};
	__property TfsGetUnitEvent OnGetILUnit = {read=FOnGetILUnit, write=FOnGetILUnit};
	__property TfsGetUnitEvent OnGetUnit = {read=FOnGetUnit, write=FOnGetUnit};
	__property TfsRunLineEvent OnRunLine = {read=FOnRunLine, write=FOnRunLine};
	__property TfsGetVariableValueEvent OnGetVarValue = {read=FOnGetVarValue, write=FOnGetVarValue};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsStatement : public TfsItemList
{
	typedef TfsItemList inherited;
	
private:
	TfsScript* FProgram;
	System::UnicodeString FSourcePos;
	System::UnicodeString FUnitName;
	TfsStatement* __fastcall GetItem(int Index);
	void __fastcall RunLine();
	
public:
	__fastcall virtual TfsStatement(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos);
	virtual void __fastcall Execute();
	__property TfsStatement* Items[int Index] = {read=GetItem};
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsStatement() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsAssignmentStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsDesignator* FDesignator;
	TfsCustomExpression* FExpression;
	TfsCustomVariable* FVar;
	TfsCustomVariable* FExpr;
	
public:
	__fastcall virtual ~TfsAssignmentStmt();
	virtual void __fastcall Execute();
	void __fastcall Optimize();
	__property TfsDesignator* Designator = {read=FDesignator, write=FDesignator};
	__property TfsCustomExpression* Expression = {read=FExpression, write=FExpression};
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsAssignmentStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsAssignPlusStmt : public TfsAssignmentStmt
{
	typedef TfsAssignmentStmt inherited;
	
public:
	virtual void __fastcall Execute();
public:
	/* TfsAssignmentStmt.Destroy */ inline __fastcall virtual ~TfsAssignPlusStmt() { }
	
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsAssignPlusStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsAssignmentStmt(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsAssignMinusStmt : public TfsAssignmentStmt
{
	typedef TfsAssignmentStmt inherited;
	
public:
	virtual void __fastcall Execute();
public:
	/* TfsAssignmentStmt.Destroy */ inline __fastcall virtual ~TfsAssignMinusStmt() { }
	
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsAssignMinusStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsAssignmentStmt(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsAssignMulStmt : public TfsAssignmentStmt
{
	typedef TfsAssignmentStmt inherited;
	
public:
	virtual void __fastcall Execute();
public:
	/* TfsAssignmentStmt.Destroy */ inline __fastcall virtual ~TfsAssignMulStmt() { }
	
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsAssignMulStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsAssignmentStmt(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsAssignDivStmt : public TfsAssignmentStmt
{
	typedef TfsAssignmentStmt inherited;
	
public:
	virtual void __fastcall Execute();
public:
	/* TfsAssignmentStmt.Destroy */ inline __fastcall virtual ~TfsAssignDivStmt() { }
	
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsAssignDivStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsAssignmentStmt(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsCallStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsDesignator* FDesignator;
	System::UnicodeString FModificator;
	
public:
	__fastcall virtual ~TfsCallStmt();
	virtual void __fastcall Execute();
	__property TfsDesignator* Designator = {read=FDesignator, write=FDesignator};
	__property System::UnicodeString Modificator = {read=FModificator, write=FModificator};
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsCallStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsIfStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsCustomExpression* FCondition;
	TfsStatement* FElseStmt;
	
public:
	__fastcall virtual TfsIfStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos);
	__fastcall virtual ~TfsIfStmt();
	virtual void __fastcall Execute();
	__property TfsCustomExpression* Condition = {read=FCondition, write=FCondition};
	__property TfsStatement* ElseStmt = {read=FElseStmt, write=FElseStmt};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsCaseSelector : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsSetExpression* FSetExpression;
	
public:
	__fastcall virtual ~TfsCaseSelector();
	bool __fastcall Check(const System::Variant &Value);
	__property TfsSetExpression* SetExpression = {read=FSetExpression, write=FSetExpression};
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsCaseSelector(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsCaseStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsCustomExpression* FCondition;
	TfsStatement* FElseStmt;
	
public:
	__fastcall virtual TfsCaseStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos);
	__fastcall virtual ~TfsCaseStmt();
	virtual void __fastcall Execute();
	__property TfsCustomExpression* Condition = {read=FCondition, write=FCondition};
	__property TfsStatement* ElseStmt = {read=FElseStmt, write=FElseStmt};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsRepeatStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsCustomExpression* FCondition;
	bool FInverseCondition;
	
public:
	__fastcall virtual ~TfsRepeatStmt();
	virtual void __fastcall Execute();
	__property TfsCustomExpression* Condition = {read=FCondition, write=FCondition};
	__property bool InverseCondition = {read=FInverseCondition, write=FInverseCondition, nodefault};
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsRepeatStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsWhileStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsCustomExpression* FCondition;
	
public:
	__fastcall virtual ~TfsWhileStmt();
	virtual void __fastcall Execute();
	__property TfsCustomExpression* Condition = {read=FCondition, write=FCondition};
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsWhileStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsForStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsCustomExpression* FBeginValue;
	bool FDown;
	TfsCustomExpression* FEndValue;
	TfsCustomVariable* FVariable;
	
public:
	__fastcall virtual ~TfsForStmt();
	virtual void __fastcall Execute();
	__property TfsCustomExpression* BeginValue = {read=FBeginValue, write=FBeginValue};
	__property bool Down = {read=FDown, write=FDown, nodefault};
	__property TfsCustomExpression* EndValue = {read=FEndValue, write=FEndValue};
	__property TfsCustomVariable* Variable = {read=FVariable, write=FVariable};
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsForStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsVbForStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsCustomExpression* FBeginValue;
	TfsCustomExpression* FEndValue;
	TfsCustomExpression* FStep;
	TfsCustomVariable* FVariable;
	
public:
	__fastcall virtual ~TfsVbForStmt();
	virtual void __fastcall Execute();
	__property TfsCustomExpression* BeginValue = {read=FBeginValue, write=FBeginValue};
	__property TfsCustomExpression* EndValue = {read=FEndValue, write=FEndValue};
	__property TfsCustomExpression* Step = {read=FStep, write=FStep};
	__property TfsCustomVariable* Variable = {read=FVariable, write=FVariable};
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsVbForStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsCppForStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsStatement* FFirstStmt;
	TfsCustomExpression* FExpression;
	TfsStatement* FSecondStmt;
	
public:
	__fastcall virtual TfsCppForStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos);
	__fastcall virtual ~TfsCppForStmt();
	virtual void __fastcall Execute();
	__property TfsStatement* FirstStmt = {read=FFirstStmt, write=FFirstStmt};
	__property TfsCustomExpression* Expression = {read=FExpression, write=FExpression};
	__property TfsStatement* SecondStmt = {read=FSecondStmt, write=FSecondStmt};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsTryStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	bool FIsExcept;
	TfsStatement* FExceptStmt;
	
public:
	__fastcall virtual TfsTryStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos);
	__fastcall virtual ~TfsTryStmt();
	virtual void __fastcall Execute();
	__property bool IsExcept = {read=FIsExcept, write=FIsExcept, nodefault};
	__property TfsStatement* ExceptStmt = {read=FExceptStmt, write=FExceptStmt};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsBreakStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
public:
	virtual void __fastcall Execute();
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsBreakStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsBreakStmt() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsContinueStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
public:
	virtual void __fastcall Execute();
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsContinueStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsContinueStmt() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsExitStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
public:
	virtual void __fastcall Execute();
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsExitStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsExitStmt() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsWithStmt : public TfsStatement
{
	typedef TfsStatement inherited;
	
private:
	TfsDesignator* FDesignator;
	TfsCustomVariable* FVariable;
	
public:
	__fastcall virtual ~TfsWithStmt();
	virtual void __fastcall Execute();
	__property TfsDesignator* Designator = {read=FDesignator, write=FDesignator};
	__property TfsCustomVariable* Variable = {read=FVariable, write=FVariable};
public:
	/* TfsStatement.Create */ inline __fastcall virtual TfsWithStmt(TfsScript* AProgram, const System::UnicodeString UnitName, const System::UnicodeString SourcePos) : TfsStatement(AProgram, UnitName, SourcePos) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfsCustomVariable : public TfsItemList
{
	typedef TfsItemList inherited;
	
public:
	TfsParamItem* operator[](int Index) { return this->Params[Index]; }
	
private:
	System::TObject* FAddedBy;
	bool FIsMacro;
	bool FIsReadOnly;
	System::UnicodeString FName;
	bool FNeedResult;
	TfsCustomVariable* FRefItem;
	System::UnicodeString FSourcePos;
	System::UnicodeString FSourceUnit;
	TfsVarType FTyp;
	System::UnicodeString FTypeName;
	System::UnicodeString FUppercaseName;
	System::Variant FValue;
	TfsGetVariableValueEvent FOnGetVarValue;
	TfsParamItem* __fastcall GetParam(int Index);
	System::PVariant __fastcall GetPValue();
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsCustomVariable(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName);
	System::UnicodeString __fastcall GetFullTypeName();
	int __fastcall GetNumberOfRequiredParams();
	__property System::TObject* AddedBy = {read=FAddedBy, write=FAddedBy};
	__property bool IsMacro = {read=FIsMacro, write=FIsMacro, nodefault};
	__property bool IsReadOnly = {read=FIsReadOnly, write=FIsReadOnly, nodefault};
	__property System::UnicodeString Name = {read=FName};
	__property bool NeedResult = {read=FNeedResult, write=FNeedResult, nodefault};
	__property TfsParamItem* Params[int Index] = {read=GetParam/*, default*/};
	__property System::PVariant PValue = {read=GetPValue};
	__property TfsCustomVariable* RefItem = {read=FRefItem, write=FRefItem};
	__property System::UnicodeString SourcePos = {read=FSourcePos, write=FSourcePos};
	__property System::UnicodeString SourceUnit = {read=FSourceUnit, write=FSourceUnit};
	__property TfsVarType Typ = {read=FTyp, write=FTyp, nodefault};
	__property System::UnicodeString TypeName = {read=FTypeName, write=FTypeName};
	__property System::Variant Value = {read=GetValue, write=SetValue};
	__property TfsGetVariableValueEvent OnGetVarValue = {read=FOnGetVarValue, write=FOnGetVarValue};
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsCustomVariable() { }
	
};


class PASCALIMPLEMENTATION TfsVariable : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsVariable(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName) : TfsCustomVariable(AName, ATyp, ATypeName) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsVariable() { }
	
};


class PASCALIMPLEMENTATION TfsTypeVariable : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsTypeVariable(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName) : TfsCustomVariable(AName, ATyp, ATypeName) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsTypeVariable() { }
	
};


class PASCALIMPLEMENTATION TfsStringVariable : public TfsVariable
{
	typedef TfsVariable inherited;
	
private:
	System::UnicodeString FStr;
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsStringVariable(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName) : TfsVariable(AName, ATyp, ATypeName) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsStringVariable() { }
	
};


class PASCALIMPLEMENTATION TfsParamItem : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
private:
	System::Variant FDefValue;
	bool FIsOptional;
	bool FIsVarParam;
	
public:
	__fastcall TfsParamItem(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName, bool AIsOptional, bool AIsVarParam);
	__property System::Variant DefValue = {read=FDefValue, write=FDefValue};
	__property bool IsOptional = {read=FIsOptional, nodefault};
	__property bool IsVarParam = {read=FIsVarParam, nodefault};
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsParamItem() { }
	
};


class PASCALIMPLEMENTATION TfsLocalVariablesHelper : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Variant FValue;
	TfsCustomVariable* FVariableLink;
public:
	/* TObject.Create */ inline __fastcall TfsLocalVariablesHelper() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfsLocalVariablesHelper() { }
	
};


class PASCALIMPLEMENTATION TfsProcVariable : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
private:
	bool FExecuting;
	bool FIsFunc;
	TfsScript* FProgram;
	System::Classes::TList* FVarsStack;
	
protected:
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsProcVariable(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName, TfsScript* AParent, bool AIsFunc);
	__fastcall virtual ~TfsProcVariable();
	int __fastcall SaveLocalVariables();
	void __fastcall RestoreLocalVariables(int StackIndex, bool bSkipVarParams = false, TfsDesignatorItem* dItem = (TfsDesignatorItem*)(0x0));
	__property bool Executing = {read=FExecuting, nodefault};
	__property bool IsFunc = {read=FIsFunc, nodefault};
	__property TfsScript* Prog = {read=FProgram};
};


class PASCALIMPLEMENTATION TfsCustomExpression : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsCustomExpression(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName) : TfsCustomVariable(AName, ATyp, ATypeName) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsCustomExpression() { }
	
};


class PASCALIMPLEMENTATION TfsCustomHelper : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
private:
	TfsCustomVariable* FParentRef;
	System::Variant FParentValue;
	TfsScript* FProgram;
	
public:
	__property TfsCustomVariable* ParentRef = {read=FParentRef, write=FParentRef};
	__property System::Variant ParentValue = {read=FParentValue, write=FParentValue};
	__property TfsScript* Prog = {read=FProgram, write=FProgram};
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsCustomHelper(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName) : TfsCustomVariable(AName, ATyp, ATypeName) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsCustomHelper() { }
	
};


class PASCALIMPLEMENTATION TfsArrayHelper : public TfsCustomHelper
{
	typedef TfsCustomHelper inherited;
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsArrayHelper(const System::UnicodeString AName, int DimCount, TfsVarType Typ, const System::UnicodeString TypeName);
	__fastcall virtual ~TfsArrayHelper();
};


class PASCALIMPLEMENTATION TfsStringHelper : public TfsCustomHelper
{
	typedef TfsCustomHelper inherited;
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsStringHelper();
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsStringHelper() { }
	
};


class PASCALIMPLEMENTATION TfsPropertyHelper : public TfsCustomHelper
{
	typedef TfsCustomHelper inherited;
	
private:
	System::TClass FClassRef;
	bool FIsPublished;
	TfsGetValueEvent FOnGetValue;
	TfsSetValueEvent FOnSetValue;
	TfsGetValueNewEvent FOnGetValueNew;
	TfsSetValueNewEvent FOnSetValueNew;
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
	
public:
	__property bool IsPublished = {read=FIsPublished, nodefault};
	__property TfsGetValueEvent OnGetValue = {read=FOnGetValue, write=FOnGetValue};
	__property TfsSetValueEvent OnSetValue = {read=FOnSetValue, write=FOnSetValue};
	__property TfsGetValueNewEvent OnGetValueNew = {read=FOnGetValueNew, write=FOnGetValueNew};
	__property TfsSetValueNewEvent OnSetValueNew = {read=FOnSetValueNew, write=FOnSetValueNew};
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsPropertyHelper(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName) : TfsCustomHelper(AName, ATyp, ATypeName) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsPropertyHelper() { }
	
};


class PASCALIMPLEMENTATION TfsMethodHelper : public TfsCustomHelper
{
	typedef TfsCustomHelper inherited;
	
public:
	System::Variant operator[](int Index) { return this->Params[Index]; }
	
private:
	System::UnicodeString FCategory;
	System::TClass FClassRef;
	System::UnicodeString FDescription;
	bool FIndexMethod;
	TfsCallMethodEvent FOnCall;
	TfsCallMethodNewEvent FOnCallNew;
	System::Variant FSetValue;
	System::UnicodeString FSyntax;
	System::Variant FVarArray;
	System::Variant __fastcall GetVParam(int Index);
	void __fastcall SetVParam(int Index, const System::Variant &Value);
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsMethodHelper(const System::UnicodeString Syntax, TfsScript* Script);
	__fastcall virtual ~TfsMethodHelper();
	__property System::UnicodeString Category = {read=FCategory, write=FCategory};
	__property System::UnicodeString Description = {read=FDescription, write=FDescription};
	__property bool IndexMethod = {read=FIndexMethod, nodefault};
	__property System::Variant Params[int Index] = {read=GetVParam, write=SetVParam/*, default*/};
	__property System::UnicodeString Syntax = {read=FSyntax};
	__property TfsCallMethodEvent OnCall = {read=FOnCall, write=FOnCall};
	__property TfsCallMethodNewEvent OnCallNew = {read=FOnCallNew, write=FOnCallNew};
};


class PASCALIMPLEMENTATION TfsComponentHelper : public TfsCustomHelper
{
	typedef TfsCustomHelper inherited;
	
private:
	System::Classes::TComponent* FComponent;
	
protected:
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsComponentHelper(System::Classes::TComponent* Component);
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsComponentHelper() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsCustomEvent : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfsProcVariable* FHandler;
	System::TObject* FInstance;
	
protected:
	void __fastcall CallHandler(System::TVarRec *Params, const int Params_High);
	
public:
	__fastcall virtual TfsCustomEvent(System::TObject* AObject, TfsProcVariable* AHandler);
	virtual void * __fastcall GetMethod() = 0 ;
	__property TfsProcVariable* Handler = {read=FHandler};
	__property System::TObject* Instance = {read=FInstance};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsCustomEvent() { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TfsEventClass;

class PASCALIMPLEMENTATION TfsEventHelper : public TfsCustomHelper
{
	typedef TfsCustomHelper inherited;
	
private:
	System::TClass FClassRef;
	TfsEventClass FEvent;
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsEventHelper(const System::UnicodeString Name, TfsEventClass AEvent);
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsEventHelper() { }
	
};


class PASCALIMPLEMENTATION TfsClassVariable : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
private:
	System::UnicodeString FAncestor;
	System::TClass FClassRef;
	TfsCustomHelper* FDefProperty;
	TfsItemList* FMembers;
	TfsScript* FProgram;
	void __fastcall AddComponent(System::Classes::TComponent* c);
	void __fastcall AddPublishedProperties(System::TClass AClass);
	TfsCustomHelper* __fastcall GetMembers(int Index);
	int __fastcall GetMembersCount();
	
protected:
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsClassVariable(System::TClass AClass, const System::UnicodeString Ancestor);
	__fastcall virtual ~TfsClassVariable();
	void __fastcall AddConstructor(System::UnicodeString Syntax, TfsCallMethodNewEvent CallEvent)/* overload */;
	void __fastcall AddConstructor(System::UnicodeString Syntax, TfsCallMethodEvent CallEvent)/* overload */;
	void __fastcall AddProperty(const System::UnicodeString Name, const System::UnicodeString Typ, TfsGetValueEvent GetEvent, TfsSetValueEvent SetEvent = 0x0);
	void __fastcall AddPropertyEx(const System::UnicodeString Name, const System::UnicodeString Typ, TfsGetValueNewEvent GetEvent, TfsSetValueNewEvent SetEvent = 0x0);
	void __fastcall AddDefaultProperty(const System::UnicodeString Name, const System::UnicodeString Params, const System::UnicodeString Typ, TfsCallMethodNewEvent CallEvent, bool AReadOnly = false)/* overload */;
	void __fastcall AddDefaultProperty(const System::UnicodeString Name, const System::UnicodeString Params, const System::UnicodeString Typ, TfsCallMethodEvent CallEvent, bool AReadOnly = false)/* overload */;
	void __fastcall AddIndexProperty(const System::UnicodeString Name, const System::UnicodeString Params, const System::UnicodeString Typ, TfsCallMethodNewEvent CallEvent, bool AReadOnly = false)/* overload */;
	void __fastcall AddIndexProperty(const System::UnicodeString Name, const System::UnicodeString Params, const System::UnicodeString Typ, TfsCallMethodEvent CallEvent, bool AReadOnly = false)/* overload */;
	void __fastcall AddMethod(const System::UnicodeString Syntax, TfsCallMethodNewEvent CallEvent)/* overload */;
	void __fastcall AddMethod(const System::UnicodeString Syntax, TfsCallMethodEvent CallEvent)/* overload */;
	void __fastcall AddEvent(const System::UnicodeString Name, TfsEventClass AEvent);
	TfsCustomHelper* __fastcall Find(const System::UnicodeString Name);
	__property System::UnicodeString Ancestor = {read=FAncestor};
	__property System::TClass ClassRef = {read=FClassRef};
	__property TfsCustomHelper* DefProperty = {read=FDefProperty};
	__property TfsCustomHelper* Members[int Index] = {read=GetMembers};
	__property int MembersCount = {read=GetMembersCount, nodefault};
};


enum DECLSPEC_DENUM TfsDesignatorKind : unsigned char { dkOther, dkVariable, dkStringArray, dkArray };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsDesignatorItem : public TfsItemList
{
	typedef TfsItemList inherited;
	
public:
	TfsCustomExpression* operator[](int Index) { return this->Items[Index]; }
	
private:
	bool FFlag;
	TfsCustomVariable* FRef;
	System::UnicodeString FSourcePos;
	TfsCustomExpression* __fastcall GetItem(int Index);
	
public:
	__property TfsCustomExpression* Items[int Index] = {read=GetItem/*, default*/};
	__property bool Flag = {read=FFlag, write=FFlag, nodefault};
	__property TfsCustomVariable* Ref = {read=FRef, write=FRef};
	__property System::UnicodeString SourcePos = {read=FSourcePos, write=FSourcePos};
public:
	/* TfsItemList.Create */ inline __fastcall TfsDesignatorItem() : TfsItemList() { }
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsDesignatorItem() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfsDesignator : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
public:
	TfsDesignatorItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfsDesignatorKind FKind;
	TfsScript* FMainProg;
	TfsScript* FProgram;
	TfsCustomVariable* FRef1;
	TfsDesignatorItem* FRef2;
	Fs_xml::TfsXMLItem* FLateBindingXmlSource;
	void __fastcall CheckLateBinding();
	System::Variant __fastcall DoCalc(const System::Variant &AValue, bool Flag);
	TfsDesignatorItem* __fastcall GetItem(int Index);
	
protected:
	virtual System::Variant __fastcall GetValue();
	virtual void __fastcall SetValue(const System::Variant &Value);
	
public:
	__fastcall TfsDesignator(TfsScript* AProgram);
	__fastcall virtual ~TfsDesignator();
	void __fastcall Borrow(TfsDesignator* ADesignator);
	void __fastcall Finalize();
	__property TfsDesignatorItem* Items[int Index] = {read=GetItem/*, default*/};
	__property TfsDesignatorKind Kind = {read=FKind, nodefault};
	__property Fs_xml::TfsXMLItem* LateBindingXmlSource = {read=FLateBindingXmlSource, write=FLateBindingXmlSource};
};


class PASCALIMPLEMENTATION TfsVariableDesignator : public TfsDesignator
{
	typedef TfsDesignator inherited;
	
protected:
	virtual System::Variant __fastcall GetValue();
	virtual void __fastcall SetValue(const System::Variant &Value);
public:
	/* TfsDesignator.Create */ inline __fastcall TfsVariableDesignator(TfsScript* AProgram) : TfsDesignator(AProgram) { }
	/* TfsDesignator.Destroy */ inline __fastcall virtual ~TfsVariableDesignator() { }
	
};


class PASCALIMPLEMENTATION TfsStringDesignator : public TfsDesignator
{
	typedef TfsDesignator inherited;
	
protected:
	virtual System::Variant __fastcall GetValue();
	virtual void __fastcall SetValue(const System::Variant &Value);
public:
	/* TfsDesignator.Create */ inline __fastcall TfsStringDesignator(TfsScript* AProgram) : TfsDesignator(AProgram) { }
	/* TfsDesignator.Destroy */ inline __fastcall virtual ~TfsStringDesignator() { }
	
};


class PASCALIMPLEMENTATION TfsArrayDesignator : public TfsDesignator
{
	typedef TfsDesignator inherited;
	
protected:
	virtual System::Variant __fastcall GetValue();
	virtual void __fastcall SetValue(const System::Variant &Value);
public:
	/* TfsDesignator.Create */ inline __fastcall TfsArrayDesignator(TfsScript* AProgram) : TfsDesignator(AProgram) { }
	/* TfsDesignator.Destroy */ inline __fastcall virtual ~TfsArrayDesignator() { }
	
};


class PASCALIMPLEMENTATION TfsSetExpression : public TfsCustomVariable
{
	typedef TfsCustomVariable inherited;
	
private:
	TfsCustomExpression* __fastcall GetItem(int Index);
	
protected:
	virtual System::Variant __fastcall GetValue();
	
public:
	bool __fastcall Check(const System::Variant &Value);
	__property TfsCustomExpression* Items[int Index] = {read=GetItem};
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsSetExpression(const System::UnicodeString AName, TfsVarType ATyp, const System::UnicodeString ATypeName) : TfsCustomVariable(AName, ATyp, ATypeName) { }
	
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsSetExpression() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsRTTIModule : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfsScript* FScript;
	
public:
	__fastcall virtual TfsRTTIModule(TfsScript* AScript);
	__property TfsScript* Script = {read=FScript};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsRTTIModule() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfsScript* __fastcall fsGlobalUnit(void);
extern DELPHI_PACKAGE bool __fastcall fsIsGlobalUnitExist(void);
extern DELPHI_PACKAGE System::Classes::TList* __fastcall fsRTTIModules(void);
}	/* namespace Fs_iinterpreter */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_IINTERPRETER)
using namespace Fs_iinterpreter;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_iinterpreterHPP
