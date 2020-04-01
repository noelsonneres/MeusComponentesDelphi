// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxGauge.pas' rev: 33.00 (Windows)

#ifndef FrxgaugeHPP
#define FrxgaugeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Types.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxgauge
{
//-- forward type declarations -----------------------------------------------
struct TFloatPoint;
struct TRay;
class DELPHICLASS TGaugeCoordinateConverter;
class DELPHICLASS TGaugeScaleTicks;
class DELPHICLASS TGaugeMargin;
class DELPHICLASS TGaugePointer;
class DELPHICLASS TGaugeScale;
class DELPHICLASS TfrxBaseGauge;
class DELPHICLASS TfrxGauge;
class DELPHICLASS TfrxIntervalGauge;
class DELPHICLASS TSegmentPointer;
class DELPHICLASS TBasePolygonPointer;
class DELPHICLASS TTrianglePointer;
class DELPHICLASS TDiamondPointer;
class DELPHICLASS TPentagonPointer;
class DELPHICLASS TBandPointer;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TFloatPoint
{
public:
	System::Extended X;
	System::Extended Y;
};


struct DECLSPEC_DRECORD TRay
{
public:
	TFloatPoint FP;
	System::Extended Angle;
	System::Extended Tangent;
};


class PASCALIMPLEMENTATION TGaugeCoordinateConverter : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Types::TRect FRect;
	int FWidth;
	int FHeight;
	TFloatPoint FIndent;
	TfrxBaseGauge* FBaseGauge;
	System::Extended FRange;
	TFloatPoint FCenter;
	System::Extended FRadius;
	System::Extended FAngle;
	System::Extended __fastcall Part(System::Extended Minimum, System::Extended Value, System::Extended Maximum);
	
public:
	__fastcall TGaugeCoordinateConverter(TfrxBaseGauge* ABaseGauge);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	void __fastcall Init(const System::Types::TRect &Rect, const TFloatPoint &Indent);
	TRay __fastcall ScreenRay(System::Extended Value);
	System::Extended __fastcall Value(const System::Types::TPoint &Point);
	void __fastcall OutsideInside(const TFloatPoint &fp1, const TFloatPoint &fp2, /* out */ TFloatPoint &Outside, /* out */ TFloatPoint &Inside);
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TGaugeCoordinateConverter() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TGaugeScaleTicks : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FLength;
	int FWidth;
	System::Uitypes::TColor FColor;
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	void __fastcall SetLength(const int Value);
	void __fastcall SetWidth(const int Value);
	
protected:
	TfrxBaseGauge* FBaseGauge;
	
public:
	__fastcall TGaugeScaleTicks(TfrxBaseGauge* ABaseGauge);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, const TRay &Ray);
	
__published:
	__property int Length = {read=FLength, write=SetLength, nodefault};
	__property int Width = {read=FWidth, write=SetWidth, nodefault};
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TGaugeScaleTicks() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGaugeMargin : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FLeft;
	int FTop;
	int FRight;
	int FBottom;
	void __fastcall SetBottom(const int Value);
	void __fastcall SetLeft(const int Value);
	void __fastcall SetRight(const int Value);
	void __fastcall SetTop(const int Value);
	
protected:
	TfrxBaseGauge* FBaseGauge;
	
public:
	__fastcall TGaugeMargin(TfrxBaseGauge* ABaseGauge);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	void __fastcall Init(int ALeft, int ATop, int ARight, int ABottom);
	
__published:
	__property int Left = {read=FLeft, write=SetLeft, nodefault};
	__property int Top = {read=FTop, write=SetTop, nodefault};
	__property int Right = {read=FRight, write=SetRight, nodefault};
	__property int Bottom = {read=FBottom, write=SetBottom, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TGaugeMargin() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TGaugePointerKind : unsigned char { pkSegment, pkTriangle, pkDiamond, pkPentagon, pkBand };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGaugePointer : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FColor;
	int FBorderWidth;
	System::Uitypes::TColor FBorderColor;
	int FWidth;
	int FHeight;
	void __fastcall SetBorderColor(const System::Uitypes::TColor Value);
	void __fastcall SetBorderWidth(const int Value);
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	void __fastcall SetWidth(const int Value);
	void __fastcall SetHeight(const int Value);
	
protected:
	TfrxBaseGauge* FBaseGauge;
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* Canvas, System::Extended Value) = 0 ;
	virtual void __fastcall PaintPair(Vcl::Graphics::TCanvas* Canvas, System::Extended StartValue, System::Extended EndValue) = 0 ;
	TFloatPoint __fastcall fp(System::Extended x, System::Extended y);
	void __fastcall PaintFloatPolygon(Vcl::Graphics::TCanvas* Canvas, System::Extended Value, const TFloatPoint *FPs, const int FPs_High);
	
public:
	__fastcall TGaugePointer(TfrxBaseGauge* ABaseGauge);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	void __fastcall SetupCanvas(Vcl::Graphics::TCanvas* Canvas);
	virtual bool __fastcall IsPublishedWidth();
	virtual bool __fastcall IsPublishedHeight();
	virtual bool __fastcall IsPublishedColor();
	__property int Width = {read=FWidth, write=SetWidth, nodefault};
	__property int Height = {read=FHeight, write=SetHeight, nodefault};
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, nodefault};
	
__published:
	__property int BorderWidth = {read=FBorderWidth, write=SetBorderWidth, nodefault};
	__property System::Uitypes::TColor BorderColor = {read=FBorderColor, write=SetBorderColor, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TGaugePointer() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TGaugeScale : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Vcl::Graphics::TFont* FFont;
	TGaugeScaleTicks* FTicks;
	System::UnicodeString FValueFormat;
	bool FVisible;
	bool FVisibleDigits;
	bool FBilateral;
	void __fastcall SetBilateral(const bool Value);
	void __fastcall SetValueFormat(const System::UnicodeString Value);
	void __fastcall SetVisible(const bool Value);
	void __fastcall SetVisibleDigits(const bool Value);
	void __fastcall SetTicks(TGaugeScaleTicks* const Value);
	void __fastcall SetFont(Vcl::Graphics::TFont* const Value);
	
protected:
	System::Types::TSize FTextSize;
	bool FOneDigit;
	System::Extended FOneValue;
	TfrxBaseGauge* FBaseGauge;
	void __fastcall FontChanged(System::TObject* Sender);
	void __fastcall DrawDigits(Vcl::Graphics::TCanvas* Canvas, const TRay &Ray, System::Extended Value);
	int __fastcall Correction();
	
public:
	__fastcall TGaugeScale(TfrxBaseGauge* ABaseGauge);
	__fastcall virtual ~TGaugeScale();
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	void __fastcall SetupCanvas(Vcl::Graphics::TCanvas* Canvas);
	void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ValueStep);
	TFloatPoint __fastcall Indent();
	void __fastcall OneDigitAt(System::Extended Value);
	void __fastcall MultiDigits();
	
__published:
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property TGaugeScaleTicks* Ticks = {read=FTicks, write=SetTicks};
	__property System::UnicodeString ValueFormat = {read=FValueFormat, write=SetValueFormat};
	__property bool Visible = {read=FVisible, write=SetVisible, nodefault};
	__property bool VisibleDigits = {read=FVisibleDigits, write=SetVisibleDigits, nodefault};
	__property bool Bilateral = {read=FBilateral, write=SetBilateral, nodefault};
};


enum DECLSPEC_DENUM TGaugeKind : unsigned char { gkHorizontal, gkVertical, gkCircle };

typedef void __fastcall (__closure *TUpdateEvent)(void);

class PASCALIMPLEMENTATION TfrxBaseGauge : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TUpdateEvent FOnUpdateOI;
	TUpdateEvent FOnRepaint;
	TGaugeScale* FMinorScale;
	TGaugeScale* FMajorScale;
	TGaugePointer* FPointer;
	System::Extended FMajorStep;
	System::Extended FMinorStep;
	System::Extended FMinimum;
	System::Extended FMaximum;
	TGaugeMargin* FMargin;
	TGaugePointerKind FPointerKind;
	TGaugeKind FKind;
	int FAngle;
	void __fastcall SetMaximum(const System::Extended Value);
	void __fastcall SetMinimum(const System::Extended Value);
	void __fastcall SetMajorStep(const System::Extended Value);
	void __fastcall SetMinorStep(const System::Extended Value);
	void __fastcall SetPointerKind(const TGaugePointerKind Value);
	void __fastcall SetMajorScale(TGaugeScale* const Value);
	void __fastcall SetMargin(TGaugeMargin* const Value);
	void __fastcall SetMinorScale(TGaugeScale* const Value);
	void __fastcall SetPointer(TGaugePointer* const Value);
	void __fastcall SetKind(const TGaugeKind Value);
	void __fastcall SetAngle(const int Value);
	
protected:
	System::Extended FScaleX;
	System::Extended FScaleY;
	System::Extended FScale;
	bool FLeftPressed;
	TGaugeCoordinateConverter* FCC;
	bool FIsPrinting;
	TGaugePointer* __fastcall CreatePointer(TGaugePointer* Old = (TGaugePointer*)(0x0), bool DestroyOld = false);
	void __fastcall UpdateOI();
	void __fastcall Repaint();
	virtual void __fastcall OneDigit(const System::Types::TPoint &P) = 0 ;
	virtual void __fastcall MultiDigits();
	virtual void __fastcall CorrectByMaximum() = 0 ;
	virtual void __fastcall CorrectByMinimum() = 0 ;
	
public:
	__fastcall TfrxBaseGauge();
	__fastcall virtual ~TfrxBaseGauge();
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &ClientRect);
	virtual void __fastcall DrawPointer(Vcl::Graphics::TCanvas* Canvas) = 0 ;
	void __fastcall SetXYScales(System::Extended AScaleX, System::Extended AScaleY, bool IsPrinting = false);
	System::Extended __fastcall Radians();
	bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift);
	bool __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift);
	bool __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos) = 0 ;
	__property System::Extended ScaleX = {read=FScaleX};
	__property System::Extended ScaleY = {read=FScaleY};
	__property System::Extended Scale = {read=FScale};
	__property System::Extended Minimum = {read=FMinimum, write=SetMinimum};
	__property System::Extended Maximum = {read=FMaximum, write=SetMaximum};
	
__published:
	__property TUpdateEvent OnUpdateOI = {read=FOnUpdateOI, write=FOnUpdateOI};
	__property TUpdateEvent OnRepaint = {read=FOnRepaint, write=FOnRepaint};
	__property TGaugeKind Kind = {read=FKind, write=SetKind, nodefault};
	__property int Angle = {read=FAngle, write=SetAngle, nodefault};
	__property TGaugeScale* MinorScale = {read=FMinorScale, write=SetMinorScale};
	__property TGaugeScale* MajorScale = {read=FMajorScale, write=SetMajorScale};
	__property TGaugePointer* Pointer = {read=FPointer, write=SetPointer};
	__property TGaugePointerKind PointerKind = {read=FPointerKind, write=SetPointerKind, nodefault};
	__property System::Extended MajorStep = {read=FMajorStep, write=SetMajorStep};
	__property System::Extended MinorStep = {read=FMinorStep, write=SetMinorStep};
	__property TGaugeMargin* Margin = {read=FMargin, write=SetMargin};
};


class PASCALIMPLEMENTATION TfrxGauge : public TfrxBaseGauge
{
	typedef TfrxBaseGauge inherited;
	
private:
	System::Extended FCurrentValue;
	void __fastcall SetCurrentValue(const System::Extended Value);
	
protected:
	virtual void __fastcall OneDigit(const System::Types::TPoint &P);
	virtual void __fastcall CorrectByMaximum();
	virtual void __fastcall CorrectByMinimum();
	
public:
	__fastcall TfrxGauge();
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	virtual void __fastcall DrawPointer(Vcl::Graphics::TCanvas* Canvas);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	
__published:
	__property Minimum = {default=0};
	__property Maximum = {default=0};
	__property System::Extended CurrentValue = {read=FCurrentValue, write=SetCurrentValue};
public:
	/* TfrxBaseGauge.Destroy */ inline __fastcall virtual ~TfrxGauge() { }
	
};


enum DECLSPEC_DENUM TSelectedPointer : unsigned char { spNo, spStart, spEnd, spBoth };

class PASCALIMPLEMENTATION TfrxIntervalGauge : public TfrxBaseGauge
{
	typedef TfrxBaseGauge inherited;
	
private:
	System::Extended FStartValue;
	System::Extended FEndValue;
	void __fastcall SetEndValue(const System::Extended Value);
	void __fastcall SetStartValue(const System::Extended Value);
	
protected:
	TSelectedPointer FSelectedPointer;
	virtual void __fastcall OneDigit(const System::Types::TPoint &P);
	virtual void __fastcall MultiDigits();
	virtual void __fastcall CorrectByMaximum();
	virtual void __fastcall CorrectByMinimum();
	
public:
	__fastcall TfrxIntervalGauge();
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	virtual void __fastcall DrawPointer(Vcl::Graphics::TCanvas* Canvas);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	
__published:
	__property Maximum = {default=0};
	__property Minimum = {default=0};
	__property System::Extended EndValue = {read=FEndValue, write=SetEndValue};
	__property System::Extended StartValue = {read=FStartValue, write=SetStartValue};
public:
	/* TfrxBaseGauge.Destroy */ inline __fastcall virtual ~TfrxIntervalGauge() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TSegmentPointer : public TGaugePointer
{
	typedef TGaugePointer inherited;
	
protected:
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* Canvas, System::Extended Value);
	virtual void __fastcall PaintPair(Vcl::Graphics::TCanvas* Canvas, System::Extended StartValue, System::Extended EndValue);
	
public:
	virtual bool __fastcall IsPublishedHeight();
	
__published:
	__property Height;
public:
	/* TGaugePointer.Create */ inline __fastcall TSegmentPointer(TfrxBaseGauge* ABaseGauge) : TGaugePointer(ABaseGauge) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TSegmentPointer() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBasePolygonPointer : public TGaugePointer
{
	typedef TGaugePointer inherited;
	
public:
	virtual bool __fastcall IsPublishedWidth();
	virtual bool __fastcall IsPublishedHeight();
	virtual bool __fastcall IsPublishedColor();
	
__published:
	__property Height;
	__property Width;
	__property Color;
public:
	/* TGaugePointer.Create */ inline __fastcall TBasePolygonPointer(TfrxBaseGauge* ABaseGauge) : TGaugePointer(ABaseGauge) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TBasePolygonPointer() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TTrianglePointer : public TBasePolygonPointer
{
	typedef TBasePolygonPointer inherited;
	
protected:
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* Canvas, System::Extended Value);
	virtual void __fastcall PaintPair(Vcl::Graphics::TCanvas* Canvas, System::Extended StartValue, System::Extended EndValue);
public:
	/* TGaugePointer.Create */ inline __fastcall TTrianglePointer(TfrxBaseGauge* ABaseGauge) : TBasePolygonPointer(ABaseGauge) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TTrianglePointer() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDiamondPointer : public TBasePolygonPointer
{
	typedef TBasePolygonPointer inherited;
	
protected:
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* Canvas, System::Extended Value);
	virtual void __fastcall PaintPair(Vcl::Graphics::TCanvas* Canvas, System::Extended StartValue, System::Extended EndValue);
public:
	/* TGaugePointer.Create */ inline __fastcall TDiamondPointer(TfrxBaseGauge* ABaseGauge) : TBasePolygonPointer(ABaseGauge) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TDiamondPointer() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TPentagonPointer : public TBasePolygonPointer
{
	typedef TBasePolygonPointer inherited;
	
protected:
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* Canvas, System::Extended Value);
	virtual void __fastcall PaintPair(Vcl::Graphics::TCanvas* Canvas, System::Extended StartValue, System::Extended EndValue);
public:
	/* TGaugePointer.Create */ inline __fastcall TPentagonPointer(TfrxBaseGauge* ABaseGauge) : TBasePolygonPointer(ABaseGauge) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TPentagonPointer() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBandPointer : public TGaugePointer
{
	typedef TGaugePointer inherited;
	
protected:
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* Canvas, System::Extended Value);
	virtual void __fastcall PaintPair(Vcl::Graphics::TCanvas* Canvas, System::Extended StartValue, System::Extended EndValue);
	void __fastcall PaintRectBand(Vcl::Graphics::TCanvas* Canvas, const TRay &Start, const TRay &Current);
	void __fastcall PaintCircleBand(Vcl::Graphics::TCanvas* Canvas, const TRay &Start, const TRay &Current);
	
public:
	virtual bool __fastcall IsPublishedWidth();
	virtual bool __fastcall IsPublishedColor();
	
__published:
	__property Width;
	__property Color;
public:
	/* TGaugePointer.Create */ inline __fastcall TBandPointer(TfrxBaseGauge* ABaseGauge) : TGaugePointer(ABaseGauge) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TBandPointer() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxgauge */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXGAUGE)
using namespace Frxgauge;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxgaugeHPP
