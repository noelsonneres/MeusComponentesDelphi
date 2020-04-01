// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxOLE.pas' rev: 33.00 (Windows)

#ifndef FrxoleHPP
#define FrxoleHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.OleCtnrs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <frxClass.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxole
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxOLEObject;
class DELPHICLASS TfrxOLEView;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfrxSizeMode : unsigned char { fsmClip, fsmScale };

class PASCALIMPLEMENTATION TfrxOLEObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxOLEObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxOLEObject() { }
	
};


class PASCALIMPLEMENTATION TfrxOLEView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	Vcl::Olectnrs::TOleContainer* FOleContainer;
	TfrxSizeMode FSizeMode;
	bool FStretched;
	void __fastcall ReadData(System::Classes::TStream* Stream);
	void __fastcall SetStretched(const bool Value);
	void __fastcall WriteData(System::Classes::TStream* Stream);
	
protected:
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	
public:
	__fastcall virtual TfrxOLEView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxOLEView();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall GetData();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property Vcl::Olectnrs::TOleContainer* OleContainer = {read=FOleContainer};
	virtual bool __fastcall IsEMFExportable();
	
__published:
	__property BrushStyle;
	__property Color;
	__property Cursor = {default=0};
	__property DataField = {default=0};
	__property DataSet;
	__property DataSetName = {default=0};
	__property FillType = {default=0};
	__property Fill;
	__property Frame;
	__property TfrxSizeMode SizeMode = {read=FSizeMode, write=FSizeMode, default=0};
	__property bool Stretched = {read=FStretched, write=SetStretched, default=0};
	__property TagStr = {default=0};
	__property URL = {default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxOLEView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall frxAssignOle(Vcl::Olectnrs::TOleContainer* ContFrom, Vcl::Olectnrs::TOleContainer* ContTo);
}	/* namespace Frxole */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXOLE)
using namespace Frxole;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxoleHPP
