// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxTableObject.pas' rev: 33.00 (Windows)

#ifndef FrxtableobjectHPP
#define FrxtableobjectHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Variants.hpp>
#include <Vcl.Controls.hpp>
#include <frxClass.hpp>
#include <System.UITypes.hpp>
#include <System.WideStrings.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxtableobject
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxHackView;
class DELPHICLASS TfrxContainerPadding;
class DELPHICLASS TfrxReportTableObject;
class DELPHICLASS TfrxTableCell;
class DELPHICLASS TfrxTableRowColumnBase;
class DELPHICLASS TfrxTableColumn;
class DELPHICLASS TfrxTableRow;
class DELPHICLASS TfrxTableObject;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxHackView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
public:
	/* TfrxView.Create */ inline __fastcall virtual TfrxHackView(System::Classes::TComponent* AOwner) : Frxclass::TfrxView(AOwner) { }
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxHackView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxHackView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxContainerPadding : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Extended FLeftPading;
	System::Extended FTopPading;
	System::Extended FRightPading;
	System::Extended FBottomPading;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::Extended LeftPading = {read=FLeftPading, write=FLeftPading};
	__property System::Extended TopPading = {read=FTopPading, write=FTopPading};
	__property System::Extended RightPading = {read=FRightPading, write=FRightPading};
	__property System::Extended BottomPading = {read=FBottomPading, write=FBottomPading};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxContainerPadding() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxContainerPadding() : System::Classes::TPersistent() { }
	
};


class PASCALIMPLEMENTATION TfrxReportTableObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxReportTableObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxReportTableObject() { }
	
};


class PASCALIMPLEMENTATION TfrxTableCell : public Frxclass::TfrxCustomMemoView
{
	typedef Frxclass::TfrxCustomMemoView inherited;
	
private:
	int FColSpan;
	int FRowSpan;
	bool FHidden;
	TfrxContainerPadding* FContainerPadding;
	void __fastcall SetColSpan(int Value);
	void __fastcall SetRowSpan(int Value);
	System::Extended __fastcall CellWidth();
	System::Extended __fastcall CellHeight();
	void __fastcall SetContainerPadding(TfrxContainerPadding* const Value);
	bool __fastcall IsPaddingStored();
	
protected:
	int FIndex;
	virtual void __fastcall SetParent(Frxclass::TfrxComponent* AParent);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	virtual Frxclass::TfrxRestrictions __fastcall GetRestrictions();
	virtual void __fastcall SetIsSelected(const bool Value);
	virtual bool __fastcall IsTopStored();
	virtual bool __fastcall IsLeftStored();
	virtual bool __fastcall IsWidthStored();
	virtual bool __fastcall IsHeightStored();
	virtual void __fastcall DrawSizeBox(Vcl::Graphics::TCanvas* aCanvas, System::Extended aScale, bool bForceDraw = false);
	
public:
	__fastcall virtual TfrxTableCell(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxTableCell();
	virtual void __fastcall AfterPrint();
	virtual void __fastcall BeforePrint();
	virtual System::Extended __fastcall CalcHeight();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	void __fastcall DrawSelected(System::Uitypes::TColor Color = (System::Uitypes::TColor)(0xf0caa6));
	virtual bool __fastcall IsAcceptControl(Frxclass::TfrxComponent* aControl);
	virtual bool __fastcall IsOwnerDraw();
	virtual System::UnicodeString __fastcall Diff(Frxclass::TfrxComponent* AComponent);
	virtual void __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoDragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall GetData();
	virtual Frxclass::TfrxRect __fastcall GetClientArea();
	TfrxTableObject* __fastcall ParentTable();
	TfrxTableRow* __fastcall ParentRow();
	
__published:
	__property AllowExpressions = {default=1};
	__property AllowHTMLTags = {default=0};
	__property BrushStyle;
	__property CharSpacing = {default=0};
	__property Clipped = {default=1};
	__property Color;
	__property DataField = {default=0};
	__property DataSet;
	__property DataSetName = {default=0};
	__property DisplayFormat;
	__property ExpressionDelimiters = {default=0};
	__property Font;
	__property Frame;
	__property FillType = {default=0};
	__property Fill;
	__property FlowTo;
	__property GapX = {default=0};
	__property GapY = {default=0};
	__property HAlign = {default=0};
	__property HideZeros = {default=0};
	__property Highlight;
	__property LineSpacing = {default=0};
	__property Memo;
	__property ParagraphGap = {default=0};
	__property ParentFont = {default=1};
	__property TfrxContainerPadding* ContainerPadding = {read=FContainerPadding, write=SetContainerPadding, stored=IsPaddingStored};
	__property Rotation = {default=0};
	__property RTLReading = {default=0};
	__property Style = {default=0};
	__property SuppressRepeated = {default=0};
	__property Underlines = {default=0};
	__property UseDefaultCharset = {default=0};
	__property WordBreak = {default=0};
	__property WordWrap = {default=1};
	__property Wysiwyg = {default=1};
	__property VAlign = {default=0};
	__property int ColSpan = {read=FColSpan, write=SetColSpan, default=1};
	__property int RowSpan = {read=FRowSpan, write=SetRowSpan, default=1};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxTableCell(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxCustomMemoView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxTableRowColumnBase : public Frxclass::TfrxComponent
{
	typedef Frxclass::TfrxComponent inherited;
	
private:
	bool FAutoSize;
	void __fastcall SetAutoSize(bool Value);
	
protected:
	int FIndex;
	virtual void __fastcall SetParent(Frxclass::TfrxComponent* AParent);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	virtual void __fastcall SetIsSelected(const bool Value);
	virtual bool __fastcall IsTopStored();
	virtual bool __fastcall IsLeftStored();
	
public:
	__fastcall virtual ~TfrxTableRowColumnBase();
	TfrxTableObject* __fastcall ParentTable();
	virtual void __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	__property int Index = {read=FIndex, nodefault};
	
__published:
	__property bool AutoSize = {read=FAutoSize, write=SetAutoSize, default=0};
public:
	/* TfrxComponent.Create */ inline __fastcall virtual TfrxTableRowColumnBase(System::Classes::TComponent* AOwner) : Frxclass::TfrxComponent(AOwner) { }
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxTableRowColumnBase(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxComponent(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxTableColumn : public TfrxTableRowColumnBase
{
	typedef TfrxTableRowColumnBase inherited;
	
private:
	System::Extended FMinWidth;
	System::Extended FMaxWidth;
	
protected:
	virtual bool __fastcall IsHeightStored();
	
public:
	__fastcall virtual TfrxTableColumn(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxTableColumn();
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	
__published:
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	__property Width = {default=0};
	__property System::Extended MinWidth = {read=FMinWidth, write=FMinWidth};
	__property System::Extended MaxWidth = {read=FMaxWidth, write=FMaxWidth};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxTableColumn(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxTableRowColumnBase(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxTableRow : public TfrxTableRowColumnBase
{
	typedef TfrxTableRowColumnBase inherited;
	
private:
	System::Extended FMinHeight;
	System::Extended FMaxHeight;
	int __fastcall GetCellCount();
	TfrxTableCell* __fastcall GetCell(int Index);
	void __fastcall InitCells(int Value);
	void __fastcall CorrectCellsOnColumnChange(int Index, int Correct);
	
protected:
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual bool __fastcall IsWidthStored();
	virtual TfrxTableCell* __fastcall CreateTableCell(int Index);
	
public:
	__fastcall virtual TfrxTableRow(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxTableRow();
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	__property int CellCount = {read=GetCellCount, nodefault};
	__property TfrxTableCell* Cells[int Index] = {read=GetCell};
	
__published:
	__property System::Extended MinHeight = {read=FMinHeight, write=FMinHeight};
	__property System::Extended MaxHeight = {read=FMaxHeight, write=FMaxHeight};
	__property Height = {default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxTableRow(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxTableRowColumnBase(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxTableObject : public Frxclass::TfrxStretcheable
{
	typedef Frxclass::TfrxStretcheable inherited;
	
private:
	int FRowCount;
	int FColumnCount;
	bool FLockCorrectSpans;
	bool FLockObjectsUpdate;
	bool FDragDropActive;
	bool FColumnSelection;
	bool FRowSelection;
	System::Types::TRect FSelectionStart;
	System::Types::TRect FSelectionEnd;
	System::Types::TRect FCellsSelection;
	bool FModified;
	int FNewColumnDim;
	int FNewRowDim;
	bool FResizeActive;
	bool FBoundsUpdating;
	bool FTableActive;
	System::Types::TPoint FSelectorPoint;
	Frxclass::TfrxCustomFill* FSelectionFill;
	int FSelectedGridCol;
	int FSelectedGridRow;
	bool FCopyAppearance;
	int FVertSplitter;
	int FHorzSplitter;
	int FBreakRowIndex;
	System::Types::TPoint FLastMousePos;
	TfrxTableObject* FBrakeTo;
	System::Extended FDefaultCellHeight;
	System::Extended FDefaultCellWidth;
	TfrxTableColumn* __fastcall GetColumn(int Index);
	TfrxTableRow* __fastcall GetRow(int Index);
	TfrxTableCell* __fastcall GetCell(int X, int Y);
	void __fastcall SetColumnCount(int Value);
	void __fastcall SetRowCount(int Value);
	void __fastcall CorrectSpansOnColumnChange(int ColumnIndex, int Correct);
	void __fastcall CorrectSpansOnRowChange(int RowIndex, int Correct);
	void __fastcall ResetSpanList();
	void __fastcall DrawTable(bool Highlighted = false);
	void __fastcall CalcWidthInternal();
	void __fastcall CalcHeightInternal();
	void __fastcall NormalizeSpans();
	void __fastcall AssignCellAppearance(TfrxTableCell* FromCell, TfrxTableCell* ToCell);
	void __fastcall UpdateDesigner();
	void __fastcall UpdateCellDimensions(TfrxTableCell* cell);
	System::Extended __fastcall GetTableHeight();
	System::Extended __fastcall GetTableWidth();
	void __fastcall SetTableHeight(const System::Extended Value);
	void __fastcall SetTableWidth(const System::Extended Value);
	
protected:
	TfrxTableRowColumnBase* FSelectedRowCol;
	int FSelectedRowColCount;
	void __fastcall NormalizeObjectsList();
	void __fastcall FillSpanList(Frxclass::TfrxRectArray &SpanList);
	bool __fastcall IsInsideSpan(Frxclass::TfrxRectArray SpanList, const System::Types::TPoint &p);
	bool __fastcall IsTableActive();
	bool __fastcall CheckColumnSelector(System::Extended X, System::Extended Y);
	bool __fastcall CheckRowSelector(System::Extended X, System::Extended Y);
	bool __fastcall CheckMoveArrow(System::Extended X, System::Extended Y);
	bool __fastcall CheckSizeArrow(System::Extended X, System::Extended Y);
	virtual void __fastcall ObjectListNotify(void * Ptr, System::Classes::TListNotification Action);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	TfrxTableRowColumnBase* __fastcall GetRowColumnByClass(System::TClass aClass, int Index);
	virtual bool __fastcall IsWidthStored();
	virtual bool __fastcall IsHeightStored();
	virtual TfrxTableColumn* __fastcall CreateTableColumn();
	virtual TfrxTableRow* __fastcall CreateTableRow();
	virtual void __fastcall Loaded();
	virtual void __fastcall DoMirror(Frxclass::TfrxMirrorControlModes MirrorModes);
	
public:
	__fastcall virtual TfrxTableObject(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxTableObject(System::Classes::TComponent* AOwner, System::Word Flags);
	__fastcall virtual ~TfrxTableObject();
	virtual void __fastcall AlignChildren(bool IgnoreInvisible = false, Frxclass::TfrxMirrorControlModes MirrorModes = Frxclass::TfrxMirrorControlModes() );
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual System::Extended __fastcall DrawPart();
	virtual void __fastcall InitPart();
	virtual bool __fastcall HasNextDataPart(System::Extended aFreeSpace);
	virtual void __fastcall DoMouseEnter(Frxclass::TfrxComponent* aPreviousObject, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseLeave(Frxclass::TfrxComponent* aPreviousObject, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	virtual bool __fastcall IsAcceptAsChild(Frxclass::TfrxComponent* aParent);
	virtual Frxclass::TfrxComponent* __fastcall GetContainedComponent(System::Extended X, System::Extended Y, Frxclass::TfrxComponent* IsCanContain = (Frxclass::TfrxComponent*)(0x0));
	virtual void __fastcall BeforePrint();
	virtual void __fastcall AfterPrint();
	virtual System::Extended __fastcall CalcHeight();
	TfrxTableColumn* __fastcall CreateNewColumn(int Index);
	TfrxTableRow* __fastcall CreateNewRow(int Index);
	virtual void __fastcall GetData();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall ExportInternal(Frxclass::TfrxCustomExportFilter* Filter);
	virtual Frxclass::TfrxReportComponent* __fastcall GetSaveToComponent();
	void __fastcall AddColumn(TfrxTableColumn* Value);
	void __fastcall InsertColumn(int Index, TfrxTableColumn* Value);
	void __fastcall MoveColumn(int Index, int NewIndex);
	void __fastcall DeleteColumn(int Index);
	void __fastcall AddRow(TfrxTableRow* Value);
	void __fastcall InsertRow(int Index, TfrxTableRow* Value);
	void __fastcall SwapRows(int Row1, int Row2);
	void __fastcall DeleteRow(int Index);
	virtual void __fastcall UpdateBounds();
	void __fastcall JoinSelection(int TopX = 0x7fffffff, int TopY = 0x7fffffff, int BottomX = 0xffffffff, int BottomY = 0xffffffff);
	void __fastcall SplitSelected();
	void __fastcall SplitCell(TfrxTableCell* aCell);
	__property TfrxTableColumn* Columns[int Index] = {read=GetColumn};
	__property TfrxTableRow* Rows[int Index] = {read=GetRow};
	__property TfrxTableCell* Cells[int X][int Y] = {read=GetCell};
	__property System::Extended DefaultCellHeight = {read=FDefaultCellHeight, write=FDefaultCellHeight};
	__property System::Extended DefaultCellWidth = {read=FDefaultCellWidth, write=FDefaultCellWidth};
	__property System::Extended TableHeight = {read=GetTableHeight, write=SetTableHeight};
	__property System::Extended TableWidth = {read=GetTableWidth, write=SetTableWidth};
	
__published:
	__property int ColumnCount = {read=FColumnCount, write=SetColumnCount, stored=false, nodefault};
	__property int RowCount = {read=FRowCount, write=SetRowCount, stored=false, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::Extended DefaultRowHeight;
extern DELPHI_PACKAGE System::Extended DefaultColumnWidth;
}	/* namespace Frxtableobject */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXTABLEOBJECT)
using namespace Frxtableobject;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxtableobjectHPP
