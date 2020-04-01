// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxMapILEditor.pas' rev: 33.00 (Windows)

#ifndef FrxmapileditorHPP
#define FrxmapileditorHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ToolWin.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <frxClass.hpp>
#include <frxMapInteractiveLayer.hpp>
#include <frxMap.hpp>
#include <frxMapHelpers.hpp>
#include <frxMapShape.hpp>
#include <frxAnaliticGeometry.hpp>
#include <frxPolygonTemplate.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxmapileditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TCanvasMapPair;
struct TGraphicView;
struct TFigureCreateRecord;
class DELPHICLASS TAbstractFigure;
class DELPHICLASS TfrxMapILEditorForm;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TCanvasMapPair : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Frxclass::TfrxPoint FCanvasPoint;
	Frxclass::TfrxPoint FMapPoint;
	Frxmaphelpers::TMapToCanvasCoordinateConverter* FConverter;
	void __fastcall SetCanvasPoint(const Frxclass::TfrxPoint &Value);
	void __fastcall SetMapPoint(const Frxclass::TfrxPoint &Value);
	
public:
	__fastcall TCanvasMapPair(Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter);
	__fastcall TCanvasMapPair(TCanvasMapPair* CanvasMapPair);
	void __fastcall CalcCanvas();
	void __fastcall CalcMap();
	void __fastcall CanvasShift(System::Extended dX, System::Extended dY);
	__property Frxclass::TfrxPoint CanvasPoint = {read=FCanvasPoint, write=SetCanvasPoint};
	__property Frxclass::TfrxPoint MapPoint = {read=FMapPoint, write=SetMapPoint};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TCanvasMapPair() { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TGraphicView
{
public:
	int PenWidth;
	Vcl::Graphics::TPenStyle PenStyle;
	System::Uitypes::TColor PenColor;
	Vcl::Graphics::TBrushStyle BrushStyle;
	System::Uitypes::TColor BrushColor;
};


struct DECLSPEC_DRECORD TFigureCreateRecord
{
public:
	Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter;
	Vcl::Graphics::TCanvas* Canvas;
	int X;
	int Y;
	Frxmapshape::TShape* Shape;
};


enum DECLSPEC_DENUM TVirtualCursor : unsigned char { vcDefault, vcCanSelect, vcMoveMobile, vcFixAndAdd, vcFix, vcUnfix, vcUnfixSegment, vcSize, vcSizeNESW, vcSizeNS, vcSizeNWSE, vcSizeWE };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TAbstractFigure : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	Frxmapshape::TShape* FShape;
	Vcl::Graphics::TCanvas* FCanvas;
	Frxmaphelpers::TMapToCanvasCoordinateConverter* FConverter;
	TCanvasMapPair* FLastPoint;
	virtual void __fastcall ReadShapeData() = 0 ;
	void __fastcall SetupGraphics(const TGraphicView &GV);
	void __fastcall DrawCircle(const Frxclass::TfrxPoint &Center, const TGraphicView &GV, int Radius = 0xffffffff);
	void __fastcall DrawLine(const Frxclass::TfrxPoint &P1, const Frxclass::TfrxPoint &P2, const TGraphicView &GV);
	void __fastcall DrawRect(const Frxclass::TfrxPoint &TopLeft, const Frxclass::TfrxPoint &BottomRight, const TGraphicView &GV);
	void __fastcall DrawPolygon(Frxanaliticgeometry::TPointArray Points, const TGraphicView &GV);
	void __fastcall DrawEllipse(const Frxclass::TfrxPoint &TopLeft, const Frxclass::TfrxPoint &BottomRight, const TGraphicView &GV);
	void __fastcall DrawMobilePoint();
	bool __fastcall IsNearLastPoint(const int X, const int Y);
	
public:
	__fastcall TAbstractFigure(const TFigureCreateRecord &FCR);
	__fastcall virtual ~TAbstractFigure();
	virtual void __fastcall Draw() = 0 ;
	virtual void __fastcall SetConstrainProportions(bool AConstrainProportions);
	virtual System::UnicodeString __fastcall ShapeName() = 0 ;
	virtual bool __fastcall MouseDown(const int X, const int Y) = 0 ;
	virtual bool __fastcall MouseMove(const int X, const int Y) = 0 ;
	virtual void __fastcall MouseUp(const int X, const int Y);
	virtual void __fastcall RecalcCanvas();
	virtual TVirtualCursor __fastcall GetCursor(const int X, const int Y) = 0 ;
	virtual Frxmaphelpers::TShapeType __fastcall ShapeType() = 0 ;
	virtual Frxmaphelpers::TShapeData* __fastcall GetShapeData(System::Classes::TStrings* Strings) = 0 ;
	virtual bool __fastcall IsCanDeletePoint();
	virtual bool __fastcall IsCanDeleteShape();
	virtual bool __fastcall IsCanSave();
	virtual bool __fastcall IsCanVK_DELETE();
	virtual void __fastcall DeletePoint();
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxMapILEditorForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Stdctrls::TButton* btnOk;
	Vcl::Stdctrls::TGroupBox* ShapeGroupBox;
	Vcl::Stdctrls::TMemo* TagsMemo;
	Vcl::Stdctrls::TLabel* TagsLabel;
	Vcl::Stdctrls::TButton* CancelShapeButton;
	Vcl::Stdctrls::TButton* SaveShapeButton;
	Vcl::Extctrls::TPanel* MapPanel;
	Vcl::Extctrls::TPaintBox* MapPaintBox;
	Vcl::Stdctrls::TButton* RemoveShapeButton;
	Vcl::Stdctrls::TGroupBox* PolyGroupBox;
	Vcl::Stdctrls::TButton* DeletePointButton;
	Vcl::Stdctrls::TGroupBox* PictureGroupBox;
	Vcl::Stdctrls::TButton* EditPictureButton;
	Vcl::Stdctrls::TCheckBox* ConstrainProportionsCheckBox;
	Vcl::Stdctrls::TGroupBox* LegendGroupBox;
	Vcl::Stdctrls::TMemo* TextMemo;
	Vcl::Stdctrls::TButton* LabelFontButton;
	Vcl::Stdctrls::TLabel* LabelFontLabel;
	Vcl::Dialogs::TFontDialog* FontDialog;
	Vcl::Extctrls::TPanel* TopPanel;
	Vcl::Buttons::TSpeedButton* SelectSpeedButton;
	Vcl::Buttons::TSpeedButton* PointSpeedButton;
	Vcl::Menus::TPopupMenu* PointPopupMenu;
	Vcl::Menus::TMenuItem* Point1;
	Vcl::Menus::TMenuItem* Polyline1;
	Vcl::Menus::TMenuItem* Polygon1;
	Vcl::Buttons::TSpeedButton* PointMenuSpeedButton;
	Vcl::Buttons::TSpeedButton* RectSpeedButton;
	Vcl::Buttons::TSpeedButton* RectMenuSpeedButton;
	Vcl::Menus::TPopupMenu* RectPopupMenu;
	Vcl::Menus::TMenuItem* Rectangle1;
	Vcl::Menus::TMenuItem* Ellipse1;
	Vcl::Menus::TMenuItem* Diamond1;
	Vcl::Buttons::TSpeedButton* PictureSpeedButton;
	Vcl::Buttons::TSpeedButton* PictureMenuSpeedButton;
	Vcl::Menus::TPopupMenu* PicturePopupMenu;
	Vcl::Menus::TMenuItem* Picture1;
	Vcl::Menus::TMenuItem* Legend1;
	Vcl::Buttons::TSpeedButton* TemplateSpeedButton;
	Vcl::Buttons::TSpeedButton* TemplateMenuSpeedButton;
	Vcl::Menus::TPopupMenu* TemplatePopupMenu;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormMouseWheel(System::TObject* Sender, System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall MapPaintBoxMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall MapPaintBoxMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall MapPaintBoxMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall MapPaintBoxPaint(System::TObject* Sender);
	void __fastcall SaveShapeButtonClick(System::TObject* Sender);
	void __fastcall CancelShapeButtonClick(System::TObject* Sender);
	void __fastcall RemoveShapeButtonClick(System::TObject* Sender);
	void __fastcall DeletePointButtonClick(System::TObject* Sender);
	void __fastcall EditPictureButtonClick(System::TObject* Sender);
	void __fastcall ConstrainProportionsCheckBoxClick(System::TObject* Sender);
	void __fastcall TextMemoChange(System::TObject* Sender);
	void __fastcall LabelFontButtonClick(System::TObject* Sender);
	void __fastcall PointMenuSpeedButtonClick(System::TObject* Sender);
	void __fastcall Point1Click(System::TObject* Sender);
	void __fastcall Rectangle1Click(System::TObject* Sender);
	void __fastcall RectMenuSpeedButtonClick(System::TObject* Sender);
	void __fastcall Picture1Click(System::TObject* Sender);
	void __fastcall PictureMenuSpeedButtonClick(System::TObject* Sender);
	void __fastcall MapPaintBoxMouseLeave(System::TObject* Sender);
	void __fastcall TemplateMenuSpeedButtonClick(System::TObject* Sender);
	void __fastcall TemplateClick(System::TObject* Sender);
	
private:
	Frxmap::TfrxMapView* FMap;
	Frxmap::TfrxMapView* FOriginalMap;
	Frxclass::TfrxCustomDesigner* FReportDesigner;
	Frxmapinteractivelayer::TfrxMapInteractiveLayer* FLayer;
	TAbstractFigure* FFigure;
	System::Classes::TStringList* FPreviousLines;
	System::Uitypes::TCursor FCurentCursor;
	void __fastcall Change();
	void __fastcall SetLayer(Frxmapinteractivelayer::TfrxMapInteractiveLayer* const Value);
	void __fastcall FontDialogToLabel(Vcl::Stdctrls::TLabel* Lbl);
	void __fastcall RefreshCursor(TVirtualCursor VirtualCursor);
	void __fastcall LoadTemplates();
	
protected:
	Frxmaphelpers::TShapeType FPointNextFigure;
	Frxmaphelpers::TShapeType FRectNextFigure;
	Frxmaphelpers::TShapeType FPictureNextFigure;
	System::UnicodeString __fastcall NextTemplateName();
	bool __fastcall IsInsidePaintBox(const int X, const int Y);
	void __fastcall CancelEditing();
	void __fastcall FigureCreate(const int X, const int Y);
	Frxmaphelpers::TShapeType __fastcall NextFigureShapeType();
	Frxclass::TfrxPoint __fastcall OffsetPoint(System::Extended X, System::Extended Y)/* overload */;
	Frxclass::TfrxPoint __fastcall OffsetPoint(const Frxclass::TfrxPoint &P)/* overload */;
	void __fastcall UpdateControls();
	
public:
	__property Frxmapinteractivelayer::TfrxMapInteractiveLayer* Layer = {read=FLayer, write=SetLayer};
	__property Frxclass::TfrxCustomDesigner* ReportDesigner = {read=FReportDesigner, write=FReportDesigner};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxMapILEditorForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxMapILEditorForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrxMapILEditorForm() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxMapILEditorForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFigureCreateRecord __fastcall FigureCreateRecord(Frxmaphelpers::TMapToCanvasCoordinateConverter* Converter, Vcl::Graphics::TCanvas* Canvas, int X, int Y, Frxmapshape::TShape* Shape);
}	/* namespace Frxmapileditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXMAPILEDITOR)
using namespace Frxmapileditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxmapileditorHPP
