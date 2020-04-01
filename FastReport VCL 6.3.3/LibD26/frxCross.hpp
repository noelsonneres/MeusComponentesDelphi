// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxCross.pas' rev: 33.00 (Windows)

#ifndef FrxcrossHPP
#define FrxcrossHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <frxClass.hpp>
#include <System.Variants.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxcross
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxCrossObject;
struct TfrxCrossCell;
class DELPHICLASS TfrxIndexItem;
class DELPHICLASS TfrxIndexCollection;
class DELPHICLASS TfrxCrossRow;
class DELPHICLASS TfrxCrossRows;
class DELPHICLASS TfrxCrossColumn;
class DELPHICLASS TfrxCrossColumns;
class DELPHICLASS TfrxCrossHeader;
class DELPHICLASS TfrxCrossColumnHeader;
class DELPHICLASS TfrxCrossRowHeader;
class DELPHICLASS TfrxCrossCorner;
class DELPHICLASS TfrxCutBandItem;
class DELPHICLASS TfrxCutBands;
class DELPHICLASS TfrxGridLineItem;
class DELPHICLASS TfrxGridLines;
class DELPHICLASS TfrxCustomCrossView;
class DELPHICLASS TfrxCrossView;
class DELPHICLASS TfrxDBCrossView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrxCrossObject : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxCrossObject(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxCrossObject() { }
	
};


typedef System::UnicodeString TfrxPrintCellEvent;

typedef System::UnicodeString TfrxPrintHeaderEvent;

typedef System::UnicodeString TfrxCalcWidthEvent;

typedef System::UnicodeString TfrxCalcHeightEvent;

typedef void __fastcall (__closure *TfrxOnPrintCellEvent)(Frxclass::TfrxCustomMemoView* Memo, int RowIndex, int ColumnIndex, int CellIndex, const System::Variant &RowValues, const System::Variant &ColumnValues, const System::Variant &Value);

typedef void __fastcall (__closure *TfrxOnPrintHeaderEvent)(Frxclass::TfrxCustomMemoView* Memo, const System::Variant &HeaderIndexes, const System::Variant &HeaderValues, const System::Variant &Value);

typedef void __fastcall (__closure *TfrxOnCalcWidthEvent)(int ColumnIndex, const System::Variant &ColumnValues, System::Extended &Width);

typedef void __fastcall (__closure *TfrxOnCalcHeightEvent)(int RowIndex, const System::Variant &RowValues, System::Extended &Height);

typedef TfrxCrossCell *PfrCrossCell;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TfrxCrossCell
{
public:
	System::Variant Value;
	int Count;
	TfrxCrossCell *Next;
};
#pragma pack(pop)


enum DECLSPEC_DENUM TfrxCrossEditGrid : unsigned char { seLeftTop, seLeftBottom, seRightTop, seRightBottom };

enum DECLSPEC_DENUM TfrxCrossSortOrder : unsigned char { soAscending, soDescending, soNone, soGrouping };

enum DECLSPEC_DENUM TfrxCrossFunction : unsigned char { cfNone, cfSum, cfMin, cfMax, cfAvg, cfCount };

typedef System::DynamicArray<System::Variant> TfrxVariantArray;

typedef System::StaticArray<TfrxCrossSortOrder, 64> TfrxSortArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxIndexItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	TfrxVariantArray FIndexes;
	
public:
	__fastcall virtual ~TfrxIndexItem();
	__property TfrxVariantArray Indexes = {read=FIndexes, write=FIndexes};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxIndexItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxIndexCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxIndexItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	int FIndexesCount;
	TfrxSortArray FSortOrder;
	TfrxIndexItem* __fastcall GetItems(int Index);
	
public:
	bool __fastcall Find(const System::Variant *Indexes, const int Indexes_High, int &Index);
	HIDESBASE virtual TfrxIndexItem* __fastcall InsertItem(int Index, const System::Variant *Indexes, const int Indexes_High);
	__property TfrxIndexItem* Items[int Index] = {read=GetItems/*, default*/};
public:
	/* TCollection.Create */ inline __fastcall TfrxIndexCollection(System::Classes::TCollectionItemClass ItemClass) : System::Classes::TCollection(ItemClass) { }
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxIndexCollection() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCrossRow : public TfrxIndexItem
{
	typedef TfrxIndexItem inherited;
	
private:
	int FCellLevels;
	System::Classes::TList* FCells;
	void __fastcall CreateCell(int Index);
	
public:
	__fastcall virtual TfrxCrossRow(System::Classes::TCollection* Collection);
	__fastcall virtual ~TfrxCrossRow();
	PfrCrossCell __fastcall GetCell(int Index);
	System::Variant __fastcall GetCellValue(int Index1, int Index2);
	void __fastcall SetCellValue(int Index1, int Index2, const System::Variant &Value);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCrossRows : public TfrxIndexCollection
{
	typedef TfrxIndexCollection inherited;
	
public:
	TfrxCrossRow* operator[](int Index) { return this->Items[Index]; }
	
private:
	int FCellLevels;
	HIDESBASE TfrxCrossRow* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxCrossRows();
	virtual TfrxIndexItem* __fastcall InsertItem(int Index, const System::Variant *Indexes, const int Indexes_High);
	TfrxCrossRow* __fastcall Row(const System::Variant *Indexes, const int Indexes_High);
	__property TfrxCrossRow* Items[int Index] = {read=GetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxCrossRows() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCrossColumn : public TfrxIndexItem
{
	typedef TfrxIndexItem inherited;
	
private:
	int FCellIndex;
	
public:
	__property int CellIndex = {read=FCellIndex, write=FCellIndex, nodefault};
public:
	/* TfrxIndexItem.Destroy */ inline __fastcall virtual ~TfrxCrossColumn() { }
	
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxCrossColumn(System::Classes::TCollection* Collection) : TfrxIndexItem(Collection) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCrossColumns : public TfrxIndexCollection
{
	typedef TfrxIndexCollection inherited;
	
public:
	TfrxCrossColumn* operator[](int Index) { return this->Items[Index]; }
	
private:
	HIDESBASE TfrxCrossColumn* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxCrossColumns();
	TfrxCrossColumn* __fastcall Column(const System::Variant *Indexes, const int Indexes_High);
	virtual TfrxIndexItem* __fastcall InsertItem(int Index, const System::Variant *Indexes, const int Indexes_High);
	__property TfrxCrossColumn* Items[int Index] = {read=GetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxCrossColumns() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxCrossHeader : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxCrossHeader* operator[](int Index) { return this->Items[Index]; }
	
private:
	Frxclass::TfrxRect FBounds;
	System::Classes::TList* FMemos;
	System::Classes::TList* FTotalMemos;
	TfrxVariantArray FCounts;
	int FCellIndex;
	int FCellLevels;
	TfrxVariantArray FFuncValues;
	bool FHasCellHeaders;
	int FIndex;
	bool FIsCellHeader;
	bool FIsIndex;
	bool FIsTotal;
	System::Classes::TList* FItems;
	int FLevelsCount;
	Frxclass::TfrxCustomMemoView* FMemo;
	bool FNoLevels;
	TfrxCrossHeader* FParent;
	Frxclass::TfrxPoint FSize;
	int FTotalIndex;
	System::Variant FValue;
	bool FVisible;
	int FDefaultHeight;
	bool FRecalcSizes;
	TfrxCrossHeader* __fastcall AddCellHeader(System::Classes::TList* Memos, int Index, int CellIndex);
	TfrxCrossHeader* __fastcall AddChild(Frxclass::TfrxCustomMemoView* Memo);
	void __fastcall AddFuncValues(const System::Variant *Values, const int Values_High, const System::Variant *Counts, const int Counts_High, const TfrxCrossFunction *CellFunctions, const int CellFunctions_High);
	void __fastcall AddValues(const System::Variant *Values, const int Values_High, bool Unsorted);
	void __fastcall Reset(const TfrxCrossFunction *CellFunctions, const int CellFunctions_High);
	int __fastcall GetCount();
	TfrxCrossHeader* __fastcall GetItems(int Index);
	int __fastcall GetLevel();
	System::Extended __fastcall GetHeight();
	System::Extended __fastcall GetWidth();
	
public:
	__fastcall TfrxCrossHeader(int CellLevels);
	__fastcall virtual ~TfrxCrossHeader();
	virtual void __fastcall CalcBounds() = 0 ;
	virtual void __fastcall CalcSizes(int MaxWidth, int MinWidth, bool AutoSize) = 0 ;
	System::Classes::TList* __fastcall AllItems();
	int __fastcall Find(const System::Variant &Value);
	System::Variant __fastcall GetIndexes();
	System::Variant __fastcall GetValues();
	System::Classes::TList* __fastcall TerminalItems();
	System::Classes::TList* __fastcall IndexItems();
	__property Frxclass::TfrxRect Bounds = {read=FBounds, write=FBounds};
	__property int Count = {read=GetCount, nodefault};
	__property bool HasCellHeaders = {read=FHasCellHeaders, write=FHasCellHeaders, nodefault};
	__property System::Extended Height = {read=GetHeight};
	__property bool IsTotal = {read=FIsTotal, nodefault};
	__property TfrxCrossHeader* Items[int Index] = {read=GetItems/*, default*/};
	__property int Level = {read=GetLevel, nodefault};
	__property Frxclass::TfrxCustomMemoView* Memo = {read=FMemo};
	__property TfrxCrossHeader* Parent = {read=FParent};
	__property System::Variant Value = {read=FValue, write=FValue};
	__property bool Visible = {read=FVisible, write=FVisible, nodefault};
	__property System::Extended Width = {read=GetWidth};
	__property int DefaultHeight = {read=FDefaultHeight, write=FDefaultHeight, nodefault};
};


class PASCALIMPLEMENTATION TfrxCrossColumnHeader : public TfrxCrossHeader
{
	typedef TfrxCrossHeader inherited;
	
private:
	TfrxCrossHeader* FCorner;
	
public:
	virtual void __fastcall CalcBounds();
	virtual void __fastcall CalcSizes(int MaxWidth, int MinWidth, bool AutoSize);
public:
	/* TfrxCrossHeader.Create */ inline __fastcall TfrxCrossColumnHeader(int CellLevels) : TfrxCrossHeader(CellLevels) { }
	/* TfrxCrossHeader.Destroy */ inline __fastcall virtual ~TfrxCrossColumnHeader() { }
	
};


class PASCALIMPLEMENTATION TfrxCrossRowHeader : public TfrxCrossHeader
{
	typedef TfrxCrossHeader inherited;
	
private:
	TfrxCrossHeader* FCorner;
	
public:
	virtual void __fastcall CalcBounds();
	virtual void __fastcall CalcSizes(int MaxWidth, int MinWidth, bool AutoSize);
public:
	/* TfrxCrossHeader.Create */ inline __fastcall TfrxCrossRowHeader(int CellLevels) : TfrxCrossHeader(CellLevels) { }
	/* TfrxCrossHeader.Destroy */ inline __fastcall virtual ~TfrxCrossRowHeader() { }
	
};


class PASCALIMPLEMENTATION TfrxCrossCorner : public TfrxCrossColumnHeader
{
	typedef TfrxCrossColumnHeader inherited;
	
public:
	/* TfrxCrossHeader.Create */ inline __fastcall TfrxCrossCorner(int CellLevels) : TfrxCrossColumnHeader(CellLevels) { }
	/* TfrxCrossHeader.Destroy */ inline __fastcall virtual ~TfrxCrossCorner() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCutBandItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	Frxclass::TfrxBand* Band;
	int FromIndex;
	int ToIndex;
	__fastcall virtual ~TfrxCutBandItem();
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxCutBandItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCutBands : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxCutBandItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxCutBandItem* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxCutBands();
	HIDESBASE void __fastcall Add(Frxclass::TfrxBand* ABand, int AFromIndex, int AToIndex);
	__property TfrxCutBandItem* Items[int Index] = {read=GetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxCutBands() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxGridLineItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	System::Extended Coord;
	System::Classes::TList* Objects;
	__fastcall virtual TfrxGridLineItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TfrxGridLineItem();
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxGridLines : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxGridLineItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxGridLineItem* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxGridLines();
	HIDESBASE void __fastcall Add(System::TObject* AObj, System::Extended ACoord);
	__property TfrxGridLineItem* Items[int Index] = {read=GetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxGridLines() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxCustomCrossView : public Frxclass::TfrxView
{
	typedef Frxclass::TfrxView inherited;
	
private:
	System::Extended FAddHeight;
	System::Extended FAddWidth;
	bool FAllowDuplicates;
	bool FAutoSize;
	bool FBorder;
	System::Classes::TStrings* FCellFields;
	System::StaticArray<TfrxCrossFunction, 64> FCellFunctions;
	int FCellLevels;
	bool FClearBeforePrint;
	TfrxCutBands* FColumnBands;
	System::Classes::TStrings* FColumnFields;
	TfrxCrossColumnHeader* FColumnHeader;
	int FColumnLevels;
	TfrxCrossColumns* FColumns;
	TfrxSortArray FColumnSort;
	TfrxCrossCorner* FCorner;
	int FDefHeight;
	bool FDotMatrix;
	bool FDownThenAcross;
	System::Types::TPoint FFirstMousePos;
	int FGapX;
	int FGapY;
	TfrxGridLines* FGridUsed;
	TfrxGridLines* FGridX;
	TfrxGridLines* FGridY;
	bool FJoinEqualCells;
	bool FKeepTogether;
	System::Types::TPoint FLastMousePos;
	int FMaxWidth;
	int FMinWidth;
	bool FMouseDown;
	int FMovingObjects;
	TfrxCustomCrossView* FNextCross;
	System::Extended FNextCrossGap;
	bool FNoColumns;
	bool FNoRows;
	bool FPlainCells;
	bool FRepeatHeaders;
	TfrxCutBands* FRowBands;
	System::Classes::TStrings* FRowFields;
	TfrxCrossRowHeader* FRowHeader;
	int FRowLevels;
	TfrxCrossRows* FRows;
	TfrxSortArray FRowSort;
	bool FShowColumnHeader;
	bool FShowColumnTotal;
	bool FShowCorner;
	bool FShowRowHeader;
	bool FShowRowTotal;
	bool FShowTitle;
	bool FSuppressNullRecords;
	bool FKeepRowsTogether;
	bool FDragActive;
	bool FShowMoveArrow;
	System::Classes::TList* FAllMemos;
	System::Classes::TList* FCellMemos;
	System::Classes::TList* FCellHeaderMemos;
	System::Classes::TList* FColumnMemos;
	System::Classes::TList* FColumnTotalMemos;
	System::Classes::TList* FCornerMemos;
	System::Classes::TList* FRowMemos;
	System::Classes::TList* FRowTotalMemos;
	TfrxCalcHeightEvent FOnCalcHeight;
	TfrxCalcWidthEvent FOnCalcWidth;
	TfrxPrintCellEvent FOnPrintCell;
	TfrxPrintHeaderEvent FOnPrintColumnHeader;
	TfrxPrintHeaderEvent FOnPrintRowHeader;
	TfrxOnCalcHeightEvent FOnBeforeCalcHeight;
	TfrxOnCalcWidthEvent FOnBeforeCalcWidth;
	TfrxOnPrintCellEvent FOnBeforePrintCell;
	TfrxOnPrintHeaderEvent FOnBeforePrintColumnHeader;
	TfrxOnPrintHeaderEvent FOnBeforePrintRowHeader;
	void __fastcall CalcBounds(System::Extended addWidth, System::Extended addHeight);
	void __fastcall CalcTotal(TfrxCrossHeader* Header, TfrxIndexCollection* Source);
	void __fastcall CalcTotals();
	void __fastcall CreateHeader(TfrxCrossHeader* Header, TfrxIndexCollection* Source, System::Classes::TList* Totals, bool TotalVisible);
	void __fastcall CreateHeaders();
	void __fastcall BuildColumnBands();
	void __fastcall BuildRowBands();
	void __fastcall ClearMatrix();
	void __fastcall ClearMemos();
	void __fastcall CreateCellHeaderMemos(int NewCount);
	void __fastcall CreateCellMemos(int NewCount);
	void __fastcall CreateColumnMemos(int NewCount);
	void __fastcall CreateCornerMemos(int NewCount);
	void __fastcall CreateRowMemos(int NewCount);
	void __fastcall CorrectDMPBounds(Frxclass::TfrxCustomMemoView* Memo);
	void __fastcall DoCalcHeight(int Row, System::Extended &Height);
	void __fastcall DoCalcWidth(int Column, System::Extended &Width);
	void __fastcall DoOnCell(Frxclass::TfrxCustomMemoView* Memo, int Row, int Column, int Cell, const System::Variant &Value);
	void __fastcall DoOnColumnHeader(Frxclass::TfrxCustomMemoView* Memo, TfrxCrossHeader* Header);
	void __fastcall DoOnRowHeader(Frxclass::TfrxCustomMemoView* Memo, TfrxCrossHeader* Header);
	void __fastcall InitMatrix();
	void __fastcall InitMemos(bool AddToScript);
	void __fastcall ReadMemos(System::Classes::TStream* Stream);
	void __fastcall RenderMatrix();
	void __fastcall SetCellFields(System::Classes::TStrings* const Value);
	void __fastcall SetCellFunctions(int Index, const TfrxCrossFunction Value);
	void __fastcall SetColumnFields(System::Classes::TStrings* const Value);
	void __fastcall SetColumnSort(int Index, TfrxCrossSortOrder Value);
	void __fastcall SetDotMatrix(const bool Value);
	void __fastcall SetRowFields(System::Classes::TStrings* const Value);
	void __fastcall SetRowSort(int Index, TfrxCrossSortOrder Value);
	void __fastcall SetupOriginalComponent(Frxclass::TfrxComponent* Obj1, Frxclass::TfrxComponent* Obj2);
	void __fastcall UpdateVisibility();
	void __fastcall WriteMemos(System::Classes::TStream* Stream);
	Frxclass::TfrxCustomMemoView* __fastcall CreateMemo(Frxclass::TfrxComponent* Parent);
	TfrxCrossFunction __fastcall GetCellFunctions(int Index);
	Frxclass::TfrxCustomMemoView* __fastcall GetCellHeaderMemos(int Index);
	Frxclass::TfrxCustomMemoView* __fastcall GetCellMemos(int Index);
	Frxclass::TfrxCustomMemoView* __fastcall GetColumnMemos(int Index);
	TfrxCrossSortOrder __fastcall GetColumnSort(int Index);
	Frxclass::TfrxCustomMemoView* __fastcall GetColumnTotalMemos(int Index);
	Frxclass::TfrxCustomMemoView* __fastcall GetCornerMemos(int Index);
	System::Classes::TList* __fastcall GetNestedObjects();
	Frxclass::TfrxCustomMemoView* __fastcall GetRowMemos(int Index);
	TfrxCrossSortOrder __fastcall GetRowSort(int Index);
	Frxclass::TfrxCustomMemoView* __fastcall GetRowTotalMemos(int Index);
	
protected:
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetCellLevels(const int Value);
	virtual void __fastcall SetColumnLevels(const int Value);
	virtual void __fastcall SetRowLevels(const int Value);
	virtual System::Classes::TList* __fastcall GetContainerObjects();
	
public:
	__fastcall virtual TfrxCustomCrossView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomCrossView();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall BeforePrint();
	virtual void __fastcall BeforeStartReport();
	virtual void __fastcall GetData();
	virtual void __fastcall AddSourceObjects();
	virtual bool __fastcall ContainerAdd(Frxclass::TfrxComponent* Obj);
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	virtual bool __fastcall IsAcceptAsChild(Frxclass::TfrxComponent* aParent);
	virtual Frxclass::TfrxComponent* __fastcall GetContainedComponent(System::Extended X, System::Extended Y, Frxclass::TfrxComponent* IsCanContain = (Frxclass::TfrxComponent*)(0x0));
	virtual void __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseLeave(Frxclass::TfrxComponent* aNextObject, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseEnter(Frxclass::TfrxComponent* aPreviousObject, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoDragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoDragDrop(System::TObject* Source, int X, int Y, Frxclass::TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, Frxclass::TfrxInteractiveEventsParams &EventParams);
	void __fastcall AddValue(const System::Variant *Rows, const int Rows_High, const System::Variant *Columns, const int Columns_High, const System::Variant *Cells, const int Cells_High);
	void __fastcall ApplyStyle(Frxclass::TfrxStyles* Style);
	void __fastcall BeginMatrix();
	void __fastcall EndMatrix();
	virtual void __fastcall FillMatrix();
	void __fastcall GetStyle(Frxclass::TfrxStyles* Style);
	int __fastcall ColCount();
	Frxclass::TfrxPoint __fastcall DrawCross(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	System::Variant __fastcall GetColumnIndexes(int AColumn);
	System::Variant __fastcall GetRowIndexes(int ARow);
	System::Variant __fastcall GetValue(int ARow, int AColumn, int ACell);
	virtual bool __fastcall IsCrossValid();
	bool __fastcall IsGrandTotalColumn(int Index);
	bool __fastcall IsGrandTotalRow(int Index);
	bool __fastcall IsTotalColumn(int Index);
	bool __fastcall IsTotalRow(int Index);
	int __fastcall RowCount();
	System::Extended __fastcall RowHeaderWidth();
	System::Extended __fastcall ColumnHeaderHeight();
	__property TfrxCrossColumnHeader* ColumnHeader = {read=FColumnHeader};
	__property TfrxCrossRowHeader* RowHeader = {read=FRowHeader};
	__property TfrxCrossCorner* Corner = {read=FCorner};
	__property bool NoColumns = {read=FNoColumns, nodefault};
	__property bool NoRows = {read=FNoRows, nodefault};
	__property System::Classes::TStrings* CellFields = {read=FCellFields, write=SetCellFields};
	__property TfrxCrossFunction CellFunctions[int Index] = {read=GetCellFunctions, write=SetCellFunctions};
	__property Frxclass::TfrxCustomMemoView* CellMemos[int Index] = {read=GetCellMemos};
	__property Frxclass::TfrxCustomMemoView* CellHeaderMemos[int Index] = {read=GetCellHeaderMemos};
	__property bool ClearBeforePrint = {read=FClearBeforePrint, write=FClearBeforePrint, nodefault};
	__property System::Classes::TStrings* ColumnFields = {read=FColumnFields, write=SetColumnFields};
	__property Frxclass::TfrxCustomMemoView* ColumnMemos[int Index] = {read=GetColumnMemos};
	__property TfrxCrossSortOrder ColumnSort[int Index] = {read=GetColumnSort, write=SetColumnSort};
	__property Frxclass::TfrxCustomMemoView* ColumnTotalMemos[int Index] = {read=GetColumnTotalMemos};
	__property Frxclass::TfrxCustomMemoView* CornerMemos[int Index] = {read=GetCornerMemos};
	__property bool DotMatrix = {read=FDotMatrix, nodefault};
	__property System::Classes::TStrings* RowFields = {read=FRowFields, write=SetRowFields};
	__property Frxclass::TfrxCustomMemoView* RowMemos[int Index] = {read=GetRowMemos};
	__property TfrxCrossSortOrder RowSort[int Index] = {read=GetRowSort, write=SetRowSort};
	__property Frxclass::TfrxCustomMemoView* RowTotalMemos[int Index] = {read=GetRowTotalMemos};
	__property TfrxOnCalcHeightEvent OnBeforeCalcHeight = {read=FOnBeforeCalcHeight, write=FOnBeforeCalcHeight};
	__property TfrxOnCalcWidthEvent OnBeforeCalcWidth = {read=FOnBeforeCalcWidth, write=FOnBeforeCalcWidth};
	__property TfrxOnPrintCellEvent OnBeforePrintCell = {read=FOnBeforePrintCell, write=FOnBeforePrintCell};
	__property TfrxOnPrintHeaderEvent OnBeforePrintColumnHeader = {read=FOnBeforePrintColumnHeader, write=FOnBeforePrintColumnHeader};
	__property TfrxOnPrintHeaderEvent OnBeforePrintRowHeader = {read=FOnBeforePrintRowHeader, write=FOnBeforePrintRowHeader};
	
__published:
	__property System::Extended AddHeight = {read=FAddHeight, write=FAddHeight};
	__property System::Extended AddWidth = {read=FAddWidth, write=FAddWidth};
	__property bool AllowDuplicates = {read=FAllowDuplicates, write=FAllowDuplicates, default=1};
	__property bool AutoSize = {read=FAutoSize, write=FAutoSize, default=1};
	__property bool Border = {read=FBorder, write=FBorder, default=1};
	__property int CellLevels = {read=FCellLevels, write=SetCellLevels, default=1};
	__property int ColumnLevels = {read=FColumnLevels, write=SetColumnLevels, default=1};
	__property int DefHeight = {read=FDefHeight, write=FDefHeight, default=0};
	__property bool DownThenAcross = {read=FDownThenAcross, write=FDownThenAcross, nodefault};
	__property int GapX = {read=FGapX, write=FGapX, default=3};
	__property int GapY = {read=FGapY, write=FGapY, default=3};
	__property bool JoinEqualCells = {read=FJoinEqualCells, write=FJoinEqualCells, default=0};
	__property bool KeepTogether = {read=FKeepTogether, write=FKeepTogether, default=0};
	__property bool KeepRowsTogether = {read=FKeepRowsTogether, write=FKeepRowsTogether, default=0};
	__property int MaxWidth = {read=FMaxWidth, write=FMaxWidth, default=200};
	__property int MinWidth = {read=FMinWidth, write=FMinWidth, default=0};
	__property TfrxCustomCrossView* NextCross = {read=FNextCross, write=FNextCross};
	__property System::Extended NextCrossGap = {read=FNextCrossGap, write=FNextCrossGap};
	__property bool PlainCells = {read=FPlainCells, write=FPlainCells, default=0};
	__property bool RepeatHeaders = {read=FRepeatHeaders, write=FRepeatHeaders, default=1};
	__property int RowLevels = {read=FRowLevels, write=SetRowLevels, default=1};
	__property bool ShowColumnHeader = {read=FShowColumnHeader, write=FShowColumnHeader, default=1};
	__property bool ShowColumnTotal = {read=FShowColumnTotal, write=FShowColumnTotal, default=1};
	__property bool ShowCorner = {read=FShowCorner, write=FShowCorner, default=1};
	__property bool ShowRowHeader = {read=FShowRowHeader, write=FShowRowHeader, default=1};
	__property bool ShowRowTotal = {read=FShowRowTotal, write=FShowRowTotal, default=1};
	__property bool ShowTitle = {read=FShowTitle, write=FShowTitle, default=1};
	__property bool SuppressNullRecords = {read=FSuppressNullRecords, write=FSuppressNullRecords, default=1};
	__property TfrxCalcHeightEvent OnCalcHeight = {read=FOnCalcHeight, write=FOnCalcHeight};
	__property TfrxCalcWidthEvent OnCalcWidth = {read=FOnCalcWidth, write=FOnCalcWidth};
	__property TfrxPrintCellEvent OnPrintCell = {read=FOnPrintCell, write=FOnPrintCell};
	__property TfrxPrintHeaderEvent OnPrintColumnHeader = {read=FOnPrintColumnHeader, write=FOnPrintColumnHeader};
	__property TfrxPrintHeaderEvent OnPrintRowHeader = {read=FOnPrintRowHeader, write=FOnPrintRowHeader};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomCrossView(System::Classes::TComponent* AOwner, System::Word Flags) : Frxclass::TfrxView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxCrossView : public TfrxCustomCrossView
{
	typedef TfrxCustomCrossView inherited;
	
protected:
	virtual void __fastcall SetCellLevels(const int Value);
	virtual void __fastcall SetColumnLevels(const int Value);
	virtual void __fastcall SetRowLevels(const int Value);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall IsCrossValid();
public:
	/* TfrxCustomCrossView.Create */ inline __fastcall virtual TfrxCrossView(System::Classes::TComponent* AOwner) : TfrxCustomCrossView(AOwner) { }
	/* TfrxCustomCrossView.Destroy */ inline __fastcall virtual ~TfrxCrossView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCrossView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomCrossView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDBCrossView : public TfrxCustomCrossView
{
	typedef TfrxCustomCrossView inherited;
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall IsCrossValid();
	virtual void __fastcall FillMatrix();
	
__published:
	__property CellFields;
	__property ColumnFields;
	__property DataSet;
	__property DataSetName = {default=0};
	__property RowFields;
public:
	/* TfrxCustomCrossView.Create */ inline __fastcall virtual TfrxDBCrossView(System::Classes::TComponent* AOwner) : TfrxCustomCrossView(AOwner) { }
	/* TfrxCustomCrossView.Destroy */ inline __fastcall virtual ~TfrxDBCrossView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDBCrossView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomCrossView(AOwner, Flags) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxcross */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCROSS)
using namespace Frxcross;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxcrossHPP
