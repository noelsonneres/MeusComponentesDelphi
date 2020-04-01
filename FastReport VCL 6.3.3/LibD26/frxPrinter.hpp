// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxPrinter.pas' rev: 33.00 (Windows)

#ifndef FrxprinterHPP
#define FrxprinterHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Printers.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxprinter
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCustomPrinter;
class DELPHICLASS TfrxVirtualPrinter;
class DELPHICLASS TfrxPrinter;
class DELPHICLASS TfrxPrinters;
class DELPHICLASS TfrxPrinterCanvas;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxCustomPrinter : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FBin;
	int FDuplex;
	System::Classes::TStrings* FBins;
	TfrxPrinterCanvas* FCanvas;
	System::Uitypes::TPrinterOrientation FDefOrientation;
	int FDefPaper;
	System::Extended FDefPaperHeight;
	System::Extended FDefPaperWidth;
	int FDefDuplex;
	int FDefBin;
	System::Types::TPoint FDPI;
	System::UnicodeString FFileName;
	NativeUInt FHandle;
	bool FInitialized;
	System::UnicodeString FName;
	int FPaper;
	System::Classes::TStrings* FPapers;
	System::Extended FPaperHeight;
	System::Extended FPaperWidth;
	System::Extended FLeftMargin;
	System::Extended FTopMargin;
	System::Extended FRightMargin;
	System::Extended FBottomMargin;
	System::Uitypes::TPrinterOrientation FOrientation;
	System::UnicodeString FPort;
	bool FPrinting;
	System::UnicodeString FTitle;
	
public:
	__fastcall virtual TfrxCustomPrinter(const System::UnicodeString AName, const System::UnicodeString APort);
	__fastcall virtual ~TfrxCustomPrinter();
	virtual void __fastcall Init() = 0 ;
	virtual void __fastcall Abort() = 0 ;
	virtual void __fastcall BeginDoc() = 0 ;
	virtual void __fastcall BeginPage() = 0 ;
	virtual void __fastcall BeginRAWDoc() = 0 ;
	virtual void __fastcall EndDoc() = 0 ;
	virtual void __fastcall EndPage() = 0 ;
	virtual void __fastcall EndRAWDoc() = 0 ;
	virtual void __fastcall WriteRAWDoc(const System::AnsiString buf) = 0 ;
	int __fastcall BinIndex(int ABin);
	int __fastcall PaperIndex(int APaper);
	int __fastcall BinNameToNumber(const System::UnicodeString ABin);
	int __fastcall PaperNameToNumber(const System::UnicodeString APaper);
	virtual void __fastcall SetViewParams(int APaperSize, System::Extended APaperWidth, System::Extended APaperHeight, System::Uitypes::TPrinterOrientation AOrientation) = 0 ;
	virtual void __fastcall SetPrintParams(int APaperSize, System::Extended APaperWidth, System::Extended APaperHeight, System::Uitypes::TPrinterOrientation AOrientation, int ABin, int ADuplex, int ACopies) = 0 ;
	virtual void __fastcall PropertiesDlg() = 0 ;
	__property int Bin = {read=FBin, write=FBin, nodefault};
	__property int Duplex = {read=FDuplex, nodefault};
	__property System::Classes::TStrings* Bins = {read=FBins};
	__property TfrxPrinterCanvas* Canvas = {read=FCanvas};
	__property System::Uitypes::TPrinterOrientation DefOrientation = {read=FDefOrientation, nodefault};
	__property int DefPaper = {read=FDefPaper, nodefault};
	__property System::Extended DefPaperHeight = {read=FDefPaperHeight};
	__property System::Extended DefPaperWidth = {read=FDefPaperWidth};
	__property int DefBin = {read=FDefBin, nodefault};
	__property int DefDuplex = {read=FDefDuplex, nodefault};
	__property System::Types::TPoint DPI = {read=FDPI};
	__property System::UnicodeString FileName = {read=FFileName, write=FFileName};
	__property NativeUInt Handle = {read=FHandle, nodefault};
	__property System::UnicodeString Name = {read=FName};
	__property int Paper = {read=FPaper, nodefault};
	__property System::Classes::TStrings* Papers = {read=FPapers};
	__property System::Extended PaperHeight = {read=FPaperHeight};
	__property System::Extended PaperWidth = {read=FPaperWidth};
	__property System::Extended LeftMargin = {read=FLeftMargin};
	__property System::Extended TopMargin = {read=FTopMargin};
	__property System::Extended RightMargin = {read=FRightMargin};
	__property System::Extended BottomMargin = {read=FBottomMargin};
	__property System::Uitypes::TPrinterOrientation Orientation = {read=FOrientation, nodefault};
	__property System::UnicodeString Port = {read=FPort};
	__property System::UnicodeString Title = {read=FTitle, write=FTitle};
	__property bool Initialized = {read=FInitialized, nodefault};
};


class PASCALIMPLEMENTATION TfrxVirtualPrinter : public TfrxCustomPrinter
{
	typedef TfrxCustomPrinter inherited;
	
public:
	virtual void __fastcall Init();
	virtual void __fastcall Abort();
	virtual void __fastcall BeginDoc();
	virtual void __fastcall BeginPage();
	virtual void __fastcall BeginRAWDoc();
	virtual void __fastcall EndDoc();
	virtual void __fastcall EndPage();
	virtual void __fastcall EndRAWDoc();
	virtual void __fastcall WriteRAWDoc(const System::AnsiString buf);
	virtual void __fastcall SetViewParams(int APaperSize, System::Extended APaperWidth, System::Extended APaperHeight, System::Uitypes::TPrinterOrientation AOrientation);
	virtual void __fastcall SetPrintParams(int APaperSize, System::Extended APaperWidth, System::Extended APaperHeight, System::Uitypes::TPrinterOrientation AOrientation, int ABin, int ADuplex, int ACopies);
	virtual void __fastcall PropertiesDlg();
public:
	/* TfrxCustomPrinter.Create */ inline __fastcall virtual TfrxVirtualPrinter(const System::UnicodeString AName, const System::UnicodeString APort) : TfrxCustomPrinter(AName, APort) { }
	/* TfrxCustomPrinter.Destroy */ inline __fastcall virtual ~TfrxVirtualPrinter() { }
	
};


class PASCALIMPLEMENTATION TfrxPrinter : public TfrxCustomPrinter
{
	typedef TfrxCustomPrinter inherited;
	
private:
	NativeUInt FDeviceMode;
	HDC FDC;
	System::UnicodeString FDriver;
	_devicemodeW *FMode;
	void __fastcall CreateDevMode();
	void __fastcall FreeDevMode();
	void __fastcall GetDC();
	
public:
	__fastcall virtual ~TfrxPrinter();
	virtual void __fastcall Init();
	void __fastcall RecreateDC();
	virtual void __fastcall Abort();
	virtual void __fastcall BeginDoc();
	virtual void __fastcall BeginPage();
	virtual void __fastcall BeginRAWDoc();
	virtual void __fastcall EndDoc();
	virtual void __fastcall EndPage();
	virtual void __fastcall EndRAWDoc();
	virtual void __fastcall WriteRAWDoc(const System::AnsiString buf);
	virtual void __fastcall SetViewParams(int APaperSize, System::Extended APaperWidth, System::Extended APaperHeight, System::Uitypes::TPrinterOrientation AOrientation);
	virtual void __fastcall SetPrintParams(int APaperSize, System::Extended APaperWidth, System::Extended APaperHeight, System::Uitypes::TPrinterOrientation AOrientation, int ABin, int ADuplex, int ACopies);
	virtual void __fastcall PropertiesDlg();
	bool __fastcall UpdateDeviceCaps();
	__property Winapi::Windows::PDeviceModeW DeviceMode = {read=FMode};
public:
	/* TfrxCustomPrinter.Create */ inline __fastcall virtual TfrxPrinter(const System::UnicodeString AName, const System::UnicodeString APort) : TfrxCustomPrinter(AName, APort) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPrinters : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxCustomPrinter* operator[](int Index) { return this->Items[Index]; }
	
private:
	bool FHasPhysicalPrinters;
	System::Classes::TStrings* FPrinters;
	int FPrinterIndex;
	System::Classes::TList* FPrinterList;
	System::UnicodeString __fastcall GetDefaultPrinter();
	TfrxCustomPrinter* __fastcall GetItem(int Index);
	TfrxCustomPrinter* __fastcall GetCurrentPrinter();
	void __fastcall SetPrinterIndex(int Value);
	
public:
	__fastcall TfrxPrinters();
	__fastcall virtual ~TfrxPrinters();
	int __fastcall IndexOf(System::UnicodeString AName);
	void __fastcall Clear();
	void __fastcall FillPrinters();
	__property TfrxCustomPrinter* Items[int Index] = {read=GetItem/*, default*/};
	__property bool HasPhysicalPrinters = {read=FHasPhysicalPrinters, nodefault};
	__property TfrxCustomPrinter* Printer = {read=GetCurrentPrinter};
	__property int PrinterIndex = {read=FPrinterIndex, write=SetPrinterIndex, nodefault};
	__property System::Classes::TStrings* Printers = {read=FPrinters};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxPrinterCanvas : public Vcl::Graphics::TCanvas
{
	typedef Vcl::Graphics::TCanvas inherited;
	
private:
	TfrxCustomPrinter* FPrinter;
	void __fastcall UpdateFont();
	
public:
	virtual void __fastcall Changing();
public:
	/* TCanvas.Create */ inline __fastcall TfrxPrinterCanvas() : Vcl::Graphics::TCanvas() { }
	/* TCanvas.Destroy */ inline __fastcall virtual ~TfrxPrinterCanvas() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall frxGetPaperDimensions(int PaperSize, System::Extended &Width, System::Extended &Height);
extern DELPHI_PACKAGE TfrxPrinters* __fastcall frxPrinters(void);
}	/* namespace Frxprinter */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXPRINTER)
using namespace Frxprinter;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxprinterHPP
