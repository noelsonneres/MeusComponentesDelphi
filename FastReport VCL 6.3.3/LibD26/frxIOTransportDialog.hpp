// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIOTransportDialog.pas' rev: 33.00 (Windows)

#ifndef FrxiotransportdialogHPP
#define FrxiotransportdialogHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <frxClass.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.Variants.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxiotransportdialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxIOTransportFileDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxIOTransportFileDialog : public Frxclass::TfrxIOTransportFile
{
	typedef Frxclass::TfrxIOTransportFile inherited;
	
private:
	Vcl::Dialogs::TOpenDialog* FSaveDialog;
	Frxclass::TfrxCustomIOTransport* FFilter;
	
protected:
	virtual void __fastcall SetVisibility(const Frxclass::TfrxFilterVisibility Value);
	
public:
	virtual bool __fastcall OpenFilter();
	virtual void __fastcall CloseFilter();
	virtual System::Classes::TStream* __fastcall GetStream(System::UnicodeString aFileName = System::UnicodeString());
	virtual void __fastcall FreeStream(System::Classes::TStream* aStream, System::UnicodeString aFileName = System::UnicodeString());
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall DoFilterSave(System::Classes::TStream* aStream);
public:
	/* TfrxIOTransportFile.Create */ inline __fastcall virtual TfrxIOTransportFileDialog(System::Classes::TComponent* AOwner) : Frxclass::TfrxIOTransportFile(AOwner) { }
	
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxIOTransportFileDialog() : Frxclass::TfrxIOTransportFile() { }
	/* TfrxCustomIOTransport.Destroy */ inline __fastcall virtual ~TfrxIOTransportFileDialog() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxiotransportdialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXIOTRANSPORTDIALOG)
using namespace Frxiotransportdialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxiotransportdialogHPP
