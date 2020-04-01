// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_iexpression.pas' rev: 33.00 (Windows)

#ifndef Fs_iexpressionHPP
#define Fs_iexpressionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <fs_iinterpreter.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fs_iexpression
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfsExpressionNode;
class DELPHICLASS TfsOperandNode;
class DELPHICLASS TfsOperatorNode;
class DELPHICLASS TfsDesignatorNode;
class DELPHICLASS TfsSetNode;
class DELPHICLASS TfsExpression;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfsOperatorType : unsigned char { opNone, opGreat, opLess, opLessEq, opGreatEq, opNonEq, opEq, opPlus, opMinus, opOr, opXor, opMul, opDivFloat, opDivInt, opMod, opAnd, opShl, opShr, opLeftBracket, opRightBracket, opNot, opUnMinus, opIn, opIs };

class PASCALIMPLEMENTATION TfsExpressionNode : public Fs_iinterpreter::TfsCustomVariable
{
	typedef Fs_iinterpreter::TfsCustomVariable inherited;
	
private:
	TfsExpressionNode* FLeft;
	TfsExpressionNode* FRight;
	TfsExpressionNode* FParent;
	void __fastcall AddNode(TfsExpressionNode* Node);
	void __fastcall RemoveNode(TfsExpressionNode* Node);
	
public:
	__fastcall virtual ~TfsExpressionNode();
	virtual int __fastcall Priority() = 0 ;
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsExpressionNode(const System::UnicodeString AName, Fs_iinterpreter::TfsVarType ATyp, const System::UnicodeString ATypeName) : Fs_iinterpreter::TfsCustomVariable(AName, ATyp, ATypeName) { }
	
};


class PASCALIMPLEMENTATION TfsOperandNode : public TfsExpressionNode
{
	typedef TfsExpressionNode inherited;
	
public:
	__fastcall TfsOperandNode(const System::Variant &AValue);
	virtual int __fastcall Priority();
public:
	/* TfsExpressionNode.Destroy */ inline __fastcall virtual ~TfsOperandNode() { }
	
};


class PASCALIMPLEMENTATION TfsOperatorNode : public TfsExpressionNode
{
	typedef TfsExpressionNode inherited;
	
private:
	TfsOperatorType FOp;
	bool FOptimizeInt;
	bool FOptimizeBool;
	
public:
	__fastcall TfsOperatorNode(TfsOperatorType Op);
	virtual int __fastcall Priority();
public:
	/* TfsExpressionNode.Destroy */ inline __fastcall virtual ~TfsOperatorNode() { }
	
};


class PASCALIMPLEMENTATION TfsDesignatorNode : public TfsOperandNode
{
	typedef TfsOperandNode inherited;
	
private:
	Fs_iinterpreter::TfsDesignator* FDesignator;
	Fs_iinterpreter::TfsCustomVariable* FVar;
	
protected:
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsDesignatorNode(Fs_iinterpreter::TfsDesignator* ADesignator);
	__fastcall virtual ~TfsDesignatorNode();
};


class PASCALIMPLEMENTATION TfsSetNode : public TfsOperandNode
{
	typedef TfsOperandNode inherited;
	
private:
	Fs_iinterpreter::TfsSetExpression* FSetExpression;
	
protected:
	virtual System::Variant __fastcall GetValue();
	
public:
	__fastcall TfsSetNode(Fs_iinterpreter::TfsSetExpression* ASet);
	__fastcall virtual ~TfsSetNode();
};


class PASCALIMPLEMENTATION TfsExpression : public Fs_iinterpreter::TfsCustomExpression
{
	typedef Fs_iinterpreter::TfsCustomExpression inherited;
	
private:
	TfsExpressionNode* FCurNode;
	TfsExpressionNode* FNode;
	Fs_iinterpreter::TfsScript* FScript;
	System::UnicodeString FSource;
	void __fastcall AddOperand(TfsExpressionNode* Node);
	
protected:
	virtual System::Variant __fastcall GetValue();
	virtual void __fastcall SetValue(const System::Variant &Value);
	
public:
	__fastcall TfsExpression(Fs_iinterpreter::TfsScript* Script);
	__fastcall virtual ~TfsExpression();
	void __fastcall AddConst(const System::Variant &AValue);
	void __fastcall AddConstWithType(const System::Variant &AValue, Fs_iinterpreter::TfsVarType aTyp);
	void __fastcall AddDesignator(Fs_iinterpreter::TfsDesignator* ADesignator);
	void __fastcall AddOperator(const System::UnicodeString Op);
	void __fastcall AddSet(Fs_iinterpreter::TfsSetExpression* ASet);
	System::UnicodeString __fastcall Finalize();
	System::UnicodeString __fastcall Optimize(Fs_iinterpreter::TfsDesignator* Designator);
	Fs_iinterpreter::TfsCustomVariable* __fastcall SingleItem();
	__property System::UnicodeString Source = {read=FSource, write=FSource};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_iexpression */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_IEXPRESSION)
using namespace Fs_iexpression;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_iexpressionHPP
