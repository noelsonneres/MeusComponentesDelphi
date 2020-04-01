// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxClass.pas' rev: 33.00 (Windows)

#ifndef FrxclassHPP
#define FrxclassHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.IniFiles.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Printers.hpp>
#include <frxVariables.hpp>
#include <frxXML.hpp>
#include <frxProgress.hpp>
#include <fs_iinterpreter.hpp>
#include <frxUnicodeUtils.hpp>
#include <System.Variants.hpp>
#include <frxCollections.hpp>
#include <System.Math.hpp>
#include <frxVectorCanvas.hpp>
#include <System.SyncObjs.hpp>
#include <System.WideStrings.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxclass
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS EDuplicateName;
class DELPHICLASS EExportTerminated;
struct TfrxPreviewIntEventParams;
struct TfrxRect;
struct TfrxPoint;
struct TfrxDispatchMessage;
class DELPHICLASS TfrxEventObject;
struct TfrxInteractiveEventsParams;
class DELPHICLASS TfrxObjectsNotifyList;
class DELPHICLASS TfrxComponent;
class DELPHICLASS TfrxReportComponent;
class DELPHICLASS TfrxDialogComponent;
class DELPHICLASS TfrxDialogControl;
class DELPHICLASS TfrxDataSet;
class DELPHICLASS TfrxBindableFieldProps;
class DELPHICLASS TfrxUserDataSet;
class DELPHICLASS TfrxCustomDBDataSet;
class DELPHICLASS TfrxDBComponents;
class DELPHICLASS TfrxCustomDatabase;
class DELPHICLASS TfrxFillGaps;
class DELPHICLASS TfrxCustomFill;
class DELPHICLASS TfrxBrushFill;
class DELPHICLASS TfrxGradientFill;
class DELPHICLASS TfrxGlassFill;
class DELPHICLASS TfrxHyperlink;
class DELPHICLASS TfrxFrameLine;
class DELPHICLASS TfrxFrame;
class DELPHICLASS TfrxView;
class DELPHICLASS TfrxStretcheable;
class DELPHICLASS TfrxHighlight;
class DELPHICLASS TfrxHighlightCollection;
class DELPHICLASS TfrxFormat;
class DELPHICLASS TfrxFormatCollection;
class DELPHICLASS TfrxCustomMemoView;
class DELPHICLASS TfrxMemoView;
class DELPHICLASS TfrxSysMemoView;
class DELPHICLASS TfrxCustomLineView;
class DELPHICLASS TfrxLineView;
class DELPHICLASS TfrxPictureView;
class DELPHICLASS TfrxShapeView;
class DELPHICLASS TfrxSubreport;
class DELPHICLASS TfrxBand;
class DELPHICLASS TfrxDataBand;
class DELPHICLASS TfrxHeader;
class DELPHICLASS TfrxFooter;
class DELPHICLASS TfrxMasterData;
class DELPHICLASS TfrxDetailData;
class DELPHICLASS TfrxSubdetailData;
class DELPHICLASS TfrxDataBand4;
class DELPHICLASS TfrxDataBand5;
class DELPHICLASS TfrxDataBand6;
class DELPHICLASS TfrxPageHeader;
class DELPHICLASS TfrxPageFooter;
class DELPHICLASS TfrxColumnHeader;
class DELPHICLASS TfrxColumnFooter;
class DELPHICLASS TfrxGroupHeader;
class DELPHICLASS TfrxGroupFooter;
class DELPHICLASS TfrxReportTitle;
class DELPHICLASS TfrxReportSummary;
class DELPHICLASS TfrxChild;
class DELPHICLASS TfrxOverlay;
class DELPHICLASS TfrxNullBand;
class DELPHICLASS TfrxPage;
class DELPHICLASS TfrxReportPage;
class DELPHICLASS TfrxDialogPage;
class DELPHICLASS TfrxDataPage;
class DELPHICLASS TfrxEngineOptions;
class DELPHICLASS TfrxPrintOptions;
class DELPHICLASS TfrxPreviewOptions;
class DELPHICLASS TfrxReportOptions;
class DELPHICLASS TfrxExpressionCache;
class DELPHICLASS TfrxDataSetItem;
class DELPHICLASS TfrxReportDataSets;
class DELPHICLASS TfrxStyleItem;
class DELPHICLASS TfrxStyles;
class DELPHICLASS TfrxStyleSheet;
class DELPHICLASS TfrxReport;
class DELPHICLASS TfrxSelectedObjectsList;
class DELPHICLASS TfrxCustomDesigner;
class DELPHICLASS TfrxNode;
class DELPHICLASS TfrxCustomIOTransport;
class DELPHICLASS TfrxIOTransportFile;
class DELPHICLASS TfrxSaveToCompressedFilter;
class DELPHICLASS TfrxCustomExportFilter;
class DELPHICLASS TfrxCustomWizard;
class DELPHICLASS TfrxCustomEngine;
class DELPHICLASS TfrxCustomOutline;
class DELPHICLASS TfrxObjectProcessing;
class DELPHICLASS TfrxMacrosItem;
class DELPHICLASS TfrxPostProcessor;
class DELPHICLASS TfrxCustomPreviewPages;
class DELPHICLASS TfrxCustomPreview;
class DELPHICLASS TfrxCustomCompressor;
class DELPHICLASS TfrxCustomCrypter;
class DELPHICLASS TfrxFR2Events;
class DELPHICLASS TfrxGlobalDataSetList;
class DELPHICLASS TfrxInPlaceEditor;
class DELPHICLASS TfrxComponentEditorsRegItem;
class DELPHICLASS TfrxComponentEditorsManager;
class DELPHICLASS TfrxComponentEditorsList;
class DELPHICLASS TfrxComponentEditorsClasses;
//-- type declarations -------------------------------------------------------
typedef System::UnicodeString TfrxNotifyEvent;

typedef System::UnicodeString TfrxCloseQueryEvent;

typedef System::UnicodeString TfrxKeyEvent;

typedef System::UnicodeString TfrxKeyPressEvent;

typedef System::UnicodeString TfrxMouseEvent;

typedef System::UnicodeString TfrxMouseEnterViewEvent;

typedef System::UnicodeString TfrxMouseLeaveViewEvent;

typedef System::UnicodeString TfrxMouseMoveEvent;

typedef System::UnicodeString TfrxPreviewClickEvent;

typedef System::UnicodeString TfrxRunDialogsEvent;

typedef System::UnicodeString TfrxContentChangedEvent;

#pragma pack(push,4)
class PASCALIMPLEMENTATION EDuplicateName : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDuplicateName(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDuplicateName(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDuplicateName(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDuplicateName(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDuplicateName(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDuplicateName(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDuplicateName(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDuplicateName(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDuplicateName(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDuplicateName(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDuplicateName(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDuplicateName(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDuplicateName() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION EExportTerminated : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	/* TObject.Create */ inline __fastcall EExportTerminated() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~EExportTerminated() { }
	
};

#pragma pack(pop)

typedef int SYSINT;

enum DECLSPEC_DENUM Frxclass__3 : unsigned char { csContainer, csPreviewVisible, csDefaultDiff, csHandlesNestedProperties, csContained, csAcceptsFrxComponents, csObjectsContainer };

typedef System::Set<Frxclass__3, Frxclass__3::csContainer, Frxclass__3::csObjectsContainer> TfrxComponentStyle;

enum DECLSPEC_DENUM TfrxStretchMode : unsigned char { smDontStretch, smActualHeight, smMaxHeight };

enum DECLSPEC_DENUM TfrxShiftMode : unsigned char { smDontShift, smAlways, smWhenOverlapped };

enum DECLSPEC_DENUM TfrxShiftEngine : unsigned char { seLinear, seTree, seDontShift };

enum DECLSPEC_DENUM TfrxDuplexMode : unsigned char { dmNone, dmVertical, dmHorizontal, dmSimplex };

enum DECLSPEC_DENUM TfrxAlign : unsigned char { baNone, baLeft, baRight, baCenter, baWidth, baBottom, baClient, baHidden };

enum DECLSPEC_DENUM TfrxFrameStyle : unsigned char { fsSolid, fsDash, fsDot, fsDashDot, fsDashDotDot, fsDouble, fsAltDot, fsSquare };

enum DECLSPEC_DENUM TfrxFrameType : unsigned char { ftLeft, ftRight, ftTop, ftBottom };

typedef System::Set<TfrxFrameType, TfrxFrameType::ftLeft, TfrxFrameType::ftBottom> TfrxFrameTypes;

enum DECLSPEC_DENUM TfrxVisibilityType : unsigned char { vsPreview, vsExport, vsPrint };

typedef System::Set<TfrxVisibilityType, TfrxVisibilityType::vsPreview, TfrxVisibilityType::vsPrint> TfrxVisibilityTypes;

enum DECLSPEC_DENUM TfrxPrintOnType : unsigned char { ptFirstPage, ptLastPage, ptOddPages, ptEvenPages, ptRepeatedBand };

typedef System::Set<TfrxPrintOnType, TfrxPrintOnType::ptFirstPage, TfrxPrintOnType::ptRepeatedBand> TfrxPrintOnTypes;

enum DECLSPEC_DENUM TfrxFormatKind : unsigned char { fkText, fkNumeric, fkDateTime, fkBoolean };

enum DECLSPEC_DENUM TfrxHAlign : unsigned char { haLeft, haRight, haCenter, haBlock };

enum DECLSPEC_DENUM TfrxVAlign : unsigned char { vaTop, vaBottom, vaCenter };

enum DECLSPEC_DENUM TfrxSilentMode : unsigned char { simMessageBoxes, simSilent, simReThrow };

enum DECLSPEC_DENUM TfrxRestriction : unsigned char { rfDontModify, rfDontSize, rfDontMove, rfDontDelete, rfDontEdit, rfDontEditInPreview, rfDontCopy };

typedef System::Set<TfrxRestriction, TfrxRestriction::rfDontModify, TfrxRestriction::rfDontCopy> TfrxRestrictions;

enum DECLSPEC_DENUM TfrxShapeKind : unsigned char { skRectangle, skRoundRectangle, skEllipse, skTriangle, skDiamond, skDiagonal1, skDiagonal2 };

enum DECLSPEC_DENUM TfrxPreviewButton : unsigned char { pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbNoClose, pbNoFullScreen, pbNoEmail, pbCopy, pbPaste, pbSelection, pbInplaceEdit };

typedef System::Set<TfrxPreviewButton, TfrxPreviewButton::pbPrint, TfrxPreviewButton::pbInplaceEdit> TfrxPreviewButtons;

enum DECLSPEC_DENUM TfrxZoomMode : unsigned char { zmDefault, zmWholePage, zmPageWidth, zmManyPages };

enum DECLSPEC_DENUM TfrxPrintPages : unsigned char { ppAll, ppOdd, ppEven };

enum DECLSPEC_DENUM TfrxAddPageAction : unsigned char { apWriteOver, apAdd };

enum DECLSPEC_DENUM TfrxRangeBegin : unsigned char { rbFirst, rbCurrent };

enum DECLSPEC_DENUM TfrxRangeEnd : unsigned char { reLast, reCurrent, reCount };

enum DECLSPEC_DENUM TfrxFieldType : unsigned char { fftNumeric, fftString, fftBoolean, fftDateTime };

enum DECLSPEC_DENUM TfrxProgressType : unsigned char { ptRunning, ptExporting, ptPrinting };

enum DECLSPEC_DENUM TfrxPrintMode : unsigned char { pmDefault, pmSplit, pmJoin, pmScale };

enum DECLSPEC_DENUM TfrxInheriteMode : unsigned char { imDefault, imDelete, imRename };

enum DECLSPEC_DENUM TfrxSerializeState : unsigned char { ssTemplate, ssPreviewPages };

enum DECLSPEC_DENUM TfrxHyperlinkKind : unsigned char { hkURL, hkAnchor, hkPageNumber, hkDetailReport, hkDetailPage, hkCustom };

enum DECLSPEC_DENUM TfrxFillType : unsigned char { ftBrush, ftGradient, ftGlass };

enum DECLSPEC_DENUM TfrxGradientStyle : unsigned char { gsHorizontal, gsVertical, gsElliptic, gsRectangle, gsVertCenter, gsHorizCenter };

enum DECLSPEC_DENUM TfrxMouseIntEvents : unsigned char { meClick, meDbClick, meMouseMove, meMouseUp, meMouseDown, meDragOver, meDragDrop, meMouseWheel };

enum DECLSPEC_DENUM TfrxDesignTool : unsigned char { dtSelect, dtHand, dtZoom, dtText, dtFormat, dtEditor };

enum DECLSPEC_DENUM TfrxFilterAccess : unsigned char { faRead, faWrite };

enum DECLSPEC_DENUM TfrxDuplicateMerge : unsigned char { dmShow, dmHide, dmClear, dmMerge };

enum DECLSPEC_DENUM TfrxProcessAtMode : unsigned char { paDefault, paReportFinished, paReportPageFinished, paPageFinished, paColumnFinished, paDataFinished, paGroupFinished, paCustom };

enum DECLSPEC_DENUM TfrxGridType : unsigned char { gt1pt, gt1cm, gt1in, gtDialog, gtChar, gtNone };

enum DECLSPEC_DENUM TfrxCopyPasteType : unsigned char { cptDefault, cptText, cptImage, cptNative };

enum DECLSPEC_DENUM TfrxAnchorsKind : unsigned char { fraLeft, fraTop, fraRight, fraBottom };

typedef System::Set<TfrxAnchorsKind, TfrxAnchorsKind::fraLeft, TfrxAnchorsKind::fraBottom> TfrxAnchors;

enum DECLSPEC_DENUM TfrxUnderlinesTextMode : unsigned char { ulmNone, ulmUnderlinesAll, ulmUnderlinesText, ulmUnderlinesTextAndEmptyLines };

enum DECLSPEC_DENUM TfrxMirrorControlMode : unsigned char { mcmRTLBands, mcmRTLObjects, mcmRTLAppearance, mcmRTLContent, mcmRTLSpecial, mcmBTTBands, mcmBTTObjects, mcmBTTAppearance, mcmBTTContent, mcmBTTSpecial, mcmOnlySelected };

typedef System::Set<TfrxMirrorControlMode, TfrxMirrorControlMode::mcmRTLBands, TfrxMirrorControlMode::mcmOnlySelected> TfrxMirrorControlModes;

typedef NativeInt frxInteger;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TfrxPreviewIntEventParams
{
public:
	TfrxMouseIntEvents MouseEventType;
	System::TObject* Sender;
	System::Uitypes::TCursor Cursor;
	TfrxDesignTool EditMode;
	System::Uitypes::TDragState State;
	bool Accept;
	int WheelDelta;
	System::Types::TPoint MousePos;
	bool RetResult;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TfrxRect
{
public:
	System::Extended Left;
	System::Extended Top;
	System::Extended Right;
	System::Extended Bottom;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TfrxPoint
{
public:
	System::Extended X;
	System::Extended Y;
};
#pragma pack(pop)


struct DECLSPEC_DRECORD TfrxDispatchMessage
{
public:
	System::Word MsgID;
	System::TObject* Sender;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxEventObject : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::TObject* Sender;
	NativeInt Index;
public:
	/* TObject.Create */ inline __fastcall TfrxEventObject() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxEventObject() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TfrxInteractiveEventSender : unsigned char { esDesigner, esPreview };

typedef void __fastcall (__closure *TfrxOnFinishInPlaceEdit)(System::TObject* Sender, bool Refresh, bool Modified);

#pragma pack(push,1)
struct DECLSPEC_DRECORD TfrxInteractiveEventsParams
{
public:
	System::TObject* Sender;
	bool Refresh;
	bool Modified;
	bool FireParentEvent;
	TfrxInteractiveEventSender EventSender;
	TfrxOnFinishInPlaceEdit OnFinish;
	TfrxDesignTool EditMode;
	bool PopupVisible;
	bool EditRestricted;
	TfrxComponentEditorsList* EditorsList;
	TfrxSelectedObjectsList* SelectionList;
	System::Extended OffsetX;
	System::Extended OffsetY;
	System::Extended Scale;
	bool GridAlign;
	TfrxGridType GridType;
	System::Extended GridX;
	System::Extended GridY;
};
#pragma pack(pop)


typedef void __fastcall (__closure *TfrxGetCustomDataEvent)(Frxxml::TfrxXMLItem* XMLItem);

typedef void __fastcall (__closure *TfrxSaveCustomDataEvent)(Frxxml::TfrxXMLItem* XMLItem);

typedef void __fastcall (__closure *TfrxProgressEvent)(TfrxReport* Sender, TfrxProgressType ProgressType, int Progress);

typedef void __fastcall (__closure *TfrxBeforePrintEvent)(TfrxReportComponent* Sender);

typedef void __fastcall (__closure *TfrxGetValueEvent)(const System::UnicodeString VarName, System::Variant &Value);

typedef void __fastcall (__closure *TfrxNewGetValueEvent)(System::TObject* Sender, const System::UnicodeString VarName, System::Variant &Value);

typedef void __fastcall (__closure *TfrxGetBlobValueEvent)(System::TObject* Sender, const System::UnicodeString FileldName, System::TObject* AssignTo);

typedef bool __fastcall (__closure *TfrxIsBlobFieldEvent)(System::TObject* Sender, const System::UnicodeString FileldName);

typedef System::Variant __fastcall (__closure *TfrxUserFunctionEvent)(const System::UnicodeString MethodName, System::Variant &Params);

typedef void __fastcall (__closure *TfrxManualBuildEvent)(TfrxPage* Page);

typedef void __fastcall (__closure *TfrxClickObjectEvent)(TfrxView* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, bool &Modified);

typedef void __fastcall (__closure *TfrxMouseOverObjectEvent)(TfrxView* Sender);

typedef void __fastcall (__closure *TfrxMouseEnterEvent)(TfrxView* Sender);

typedef void __fastcall (__closure *TfrxMouseLeaveEvent)(TfrxView* Sender);

typedef void __fastcall (__closure *TfrxCheckEOFEvent)(System::TObject* Sender, bool &Eof);

typedef void __fastcall (__closure *TfrxRunDialogEvent)(TfrxDialogPage* Page);

typedef System::UnicodeString __fastcall (__closure *TfrxEditConnectionEvent)(const System::UnicodeString ConnString);

typedef void __fastcall (__closure *TfrxSetConnectionEvent)(const System::UnicodeString ConnString);

typedef void __fastcall (__closure *TfrxBeforeConnectEvent)(TfrxCustomDatabase* Sender, bool &Connected);

typedef void __fastcall (__closure *TfrxAfterDisconnectEvent)(TfrxCustomDatabase* Sender);

typedef void __fastcall (__closure *TfrxPrintPageEvent)(TfrxReportPage* Page, int CopyNo);

typedef void __fastcall (__closure *TfrxLoadTemplateEvent)(TfrxReport* Report, const System::UnicodeString TemplateName);

typedef bool __fastcall (__closure *TfrxLoadDetailTemplateEvent)(TfrxReport* Report, const System::UnicodeString TemplateName, TfrxHyperlink* const AHyperlink);

typedef void __fastcall (__closure *TfrxObjectsNotifyEvent)(void * Ptr, System::Classes::TListNotification Action);

class PASCALIMPLEMENTATION TfrxObjectsNotifyList : public System::Classes::TList
{
	typedef System::Classes::TList inherited;
	
private:
	TfrxObjectsNotifyEvent FOnNotifyList;
	
protected:
	virtual void __fastcall Notify(void * Ptr, System::Classes::TListNotification Action);
	
public:
	__property TfrxObjectsNotifyEvent OnNotifyList = {read=FOnNotifyList, write=FOnNotifyList};
public:
	/* TList.Destroy */ inline __fastcall virtual ~TfrxObjectsNotifyList() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxObjectsNotifyList() : System::Classes::TList() { }
	
};


class PASCALIMPLEMENTATION TfrxComponent : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	Vcl::Graphics::TFont* FFont;
	TfrxObjectsNotifyList* FObjects;
	System::Classes::TList* FAllObjects;
	System::Classes::TStringList* FSortedObjects;
	System::Extended FLeft;
	System::Extended FTop;
	System::Extended FWidth;
	System::Extended FHeight;
	bool FParentFont;
	int FGroupIndex;
	bool FIsDesigning;
	bool FIsLoading;
	bool FIsPrinting;
	bool FIsWriting;
	bool FMouseInView;
	System::Classes::TList* FSelectList;
	TfrxRestrictions FRestrictions;
	bool FVisible;
	System::UnicodeString FDescription;
	TfrxComponentStyle FComponentStyle;
	bool FAncestorOnlyStream;
	NativeInt FIndexTag;
	TfrxAnchors FAnchors;
	bool FAnchorsUpdating;
	System::Extended __fastcall GetAbsTop();
	TfrxPage* __fastcall GetPage();
	TfrxReport* __fastcall GetReport();
	TfrxComponent* __fastcall GetTopParent();
	bool __fastcall IsFontStored();
	System::Classes::TList* __fastcall GetAllObjects();
	System::Classes::TStringList* __fastcall GetSortedObjects();
	System::Extended __fastcall GetAbsLeft();
	bool __fastcall GetIsLoading();
	bool __fastcall GetIsAncestor();
	bool __fastcall GetIsSelected();
	
protected:
	TfrxComponent* FParent;
	System::UnicodeString FAliasName;
	System::UnicodeString FBaseName;
	bool FAncestor;
	TfrxComponent* FOriginalComponent;
	TfrxRect FOriginalRect;
	TfrxComponent* FOriginalBand;
	TfrxComponentEditorsManager* FComponentEditors;
	Frxxml::TfrxXMLItem* FSerializedItem;
	bool FHighlighted;
	virtual bool __fastcall IsTopStored();
	virtual bool __fastcall IsLeftStored();
	virtual bool __fastcall IsWidthStored();
	virtual bool __fastcall IsHeightStored();
	bool __fastcall IsIndexTagStored();
	virtual void __fastcall SetAnchors(const TfrxAnchors Value);
	virtual void __fastcall SetIsSelected(const bool Value);
	virtual void __fastcall SetParent(TfrxComponent* AParent);
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual void __fastcall SetTop(System::Extended Value);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	virtual void __fastcall SetName(const System::Classes::TComponentName AName);
	virtual void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	virtual void __fastcall SetParentFont(const bool Value);
	virtual void __fastcall SetVisible(bool Value);
	virtual void __fastcall FontChanged(System::TObject* Sender);
	System::UnicodeString __fastcall DiffFont(Vcl::Graphics::TFont* f1, Vcl::Graphics::TFont* f2, const System::UnicodeString Add);
	System::UnicodeString __fastcall InternalDiff(TfrxComponent* AComponent);
	virtual System::Classes::TList* __fastcall GetContainerObjects();
	virtual TfrxRestrictions __fastcall GetRestrictions();
	void __fastcall InintComponentInPlaceEditor(TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall ObjectListNotify(void * Ptr, System::Classes::TListNotification Action);
	void __fastcall LockAnchorsUpdate();
	void __fastcall UnlockAnchorsUpdate();
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	DYNAMIC System::Classes::TComponent* __fastcall GetChildOwner();
	virtual void __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseEnter(TfrxComponent* aPreviousObject, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseLeave(TfrxComponent* aNextObject, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseClick(bool Double, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoDragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoDragDrop(System::TObject* Source, int X, int Y, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall MirrorContent(TfrxMirrorControlModes MirrorModes);
	virtual void __fastcall DoMirror(TfrxMirrorControlModes MirrorModes);
	virtual void __fastcall UpdateAnchors(System::Extended DeltaX, System::Extended Deltay);
	
public:
	__fastcall virtual TfrxComponent(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxComponent(System::Classes::TComponent* AOwner, System::Word Flags);
	__fastcall virtual ~TfrxComponent();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall AlignChildren(bool IgnoreInvisible = false, TfrxMirrorControlModes MirrorModes = TfrxMirrorControlModes() );
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall AssignAll(TfrxComponent* Source, bool Streaming = false);
	void __fastcall AssignAllWithOriginals(TfrxComponent* Source, bool Streaming = false);
	virtual void __fastcall AddSourceObjects();
	virtual void __fastcall BeforeStartReport();
	virtual void __fastcall Clear();
	void __fastcall CreateUniqueName(TfrxReport* DefaultReport = (TfrxReport*)(0x0));
	virtual void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	virtual void __fastcall SaveToStream(System::Classes::TStream* Stream, bool SaveChildren = true, bool SaveDefaultValues = false, bool Streaming = false);
	void __fastcall SetBounds(System::Extended ALeft, System::Extended ATop, System::Extended AWidth, System::Extended AHeight);
	virtual void __fastcall OnNotify(System::TObject* Sender);
	virtual void __fastcall OnPaste();
	System::UnicodeString __fastcall AllDiff(TfrxComponent* AComponent);
	virtual System::UnicodeString __fastcall Diff(TfrxComponent* AComponent);
	virtual TfrxComponent* __fastcall FindObject(const System::UnicodeString AName);
	virtual void __fastcall WriteNestedProperties(Frxxml::TfrxXMLItem* Item, System::Classes::TPersistent* aAcenstor = (System::Classes::TPersistent*)(0x0));
	virtual bool __fastcall ReadNestedProperty(Frxxml::TfrxXMLItem* Item);
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	virtual bool __fastcall IsInRect(const TfrxRect &aRect);
	virtual TfrxRect __fastcall GetClientArea();
	void * __fastcall GetDrawTextObject();
	TfrxReport* __fastcall GetGlobalReport();
	virtual TfrxComponent* __fastcall GetContainedComponent(System::Extended X, System::Extended Y, TfrxComponent* IsCanContain = (TfrxComponent*)(0x0));
	virtual void __fastcall GetContainedComponents(const TfrxRect &aRect, System::TClass InheriteFrom, System::Classes::TList* aComponents, bool bSelectContainers = false);
	virtual bool __fastcall ExportInternal(TfrxCustomExportFilter* Filter);
	virtual bool __fastcall IsAcceptControl(TfrxComponent* aControl);
	virtual bool __fastcall IsAcceptAsChild(TfrxComponent* aParent);
	virtual bool __fastcall IsAcceptControls();
	void __fastcall MouseMove(int X, int Y, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	void __fastcall MouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	bool __fastcall MouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	void __fastcall MouseEnter(TfrxComponent* aPreviousObject, TfrxInteractiveEventsParams &EventParams);
	void __fastcall MouseLeave(int X, int Y, TfrxComponent* aNextObject, TfrxInteractiveEventsParams &EventParams);
	void __fastcall MouseClick(bool Double, TfrxInteractiveEventsParams &EventParams);
	bool __fastcall MouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, TfrxInteractiveEventsParams &EventParams);
	bool __fastcall DragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept, TfrxInteractiveEventsParams &EventParams);
	bool __fastcall DragDrop(System::TObject* Source, int X, int Y, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall UpdateBounds();
	virtual bool __fastcall ContainerAdd(TfrxComponent* Obj);
	TfrxDataSet* __fastcall FindDataSet(TfrxDataSet* DataSet, const System::UnicodeString DSName);
	__property TfrxAnchors Anchors = {read=FAnchors, write=SetAnchors, default=3};
	__property bool AncestorOnlyStream = {read=FAncestorOnlyStream, write=FAncestorOnlyStream, nodefault};
	__property TfrxObjectsNotifyList* Objects = {read=FObjects};
	__property System::Classes::TList* AllObjects = {read=GetAllObjects};
	__property System::Classes::TList* ContainerObjects = {read=GetContainerObjects};
	__property TfrxComponent* Parent = {read=FParent, write=SetParent};
	__property TfrxPage* Page = {read=GetPage};
	__property TfrxReport* Report = {read=GetReport};
	__property TfrxComponent* TopParent = {read=GetTopParent};
	__property bool IsAncestor = {read=GetIsAncestor, nodefault};
	__property bool IsDesigning = {read=FIsDesigning, write=FIsDesigning, nodefault};
	__property bool IsLoading = {read=GetIsLoading, write=FIsLoading, nodefault};
	__property bool IsPrinting = {read=FIsPrinting, write=FIsPrinting, nodefault};
	__property bool IsWriting = {read=FIsWriting, write=FIsWriting, nodefault};
	__property bool IsSelected = {read=GetIsSelected, write=SetIsSelected, nodefault};
	__property System::UnicodeString BaseName = {read=FBaseName};
	__property int GroupIndex = {read=FGroupIndex, write=FGroupIndex, default=0};
	__property TfrxComponentStyle frComponentStyle = {read=FComponentStyle, write=FComponentStyle, nodefault};
	__property System::Extended Left = {read=FLeft, write=SetLeft, stored=IsLeftStored};
	__property System::Extended Top = {read=FTop, write=SetTop, stored=IsTopStored};
	__property System::Extended Width = {read=FWidth, write=SetWidth, stored=IsWidthStored};
	__property System::Extended Height = {read=FHeight, write=SetHeight, stored=IsHeightStored};
	__property System::Extended AbsLeft = {read=GetAbsLeft};
	__property System::Extended AbsTop = {read=GetAbsTop};
	__property System::UnicodeString Description = {read=FDescription, write=FDescription};
	__property bool ParentFont = {read=FParentFont, write=SetParentFont, default=1};
	__property TfrxRestrictions Restrictions = {read=GetRestrictions, write=FRestrictions, default=0};
	__property bool Visible = {read=FVisible, write=SetVisible, default=1};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont, stored=IsFontStored};
	__property NativeInt IndexTag = {read=FIndexTag, write=FIndexTag, stored=IsIndexTagStored, nodefault};
};


class PASCALIMPLEMENTATION TfrxReportComponent : public TfrxComponent
{
	typedef TfrxComponent inherited;
	
private:
	TfrxNotifyEvent FOnAfterData;
	TfrxNotifyEvent FOnAfterPrint;
	TfrxNotifyEvent FOnBeforePrint;
	TfrxPreviewClickEvent FOnPreviewClick;
	TfrxPreviewClickEvent FOnPreviewDblClick;
	TfrxContentChangedEvent FOnContentChanged;
	TfrxPrintOnTypes FPrintOn;
	
protected:
	virtual void __fastcall DrawSizeBox(Vcl::Graphics::TCanvas* aCanvas, System::Extended aScale, bool bForceDraw = false);
	
public:
	System::TObject* FShiftObject;
	int FOriginalObjectsCount;
	__fastcall virtual TfrxReportComponent(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxReportComponent();
	void __fastcall InteractiveDraw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY, bool Highlighted = false, System::Uitypes::TColor hlColor = (System::Uitypes::TColor)(0x1fffffff));
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY) = 0 ;
	virtual void __fastcall DrawChilds(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY, bool Highlighted, bool IsDesigning);
	void __fastcall DrawWithChilds(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY, bool Highlighted, bool IsDesigning);
	virtual void __fastcall DrawHighlight(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY, System::Uitypes::TColor hlColor = (System::Uitypes::TColor)(0x1fffffff));
	virtual void __fastcall BeforePrint();
	virtual void __fastcall GetData();
	virtual void __fastcall AfterPrint();
	virtual System::UnicodeString __fastcall GetComponentText();
	virtual TfrxRect __fastcall GetRealBounds();
	virtual TfrxReportComponent* __fastcall GetSaveToComponent();
	virtual bool __fastcall IsOwnerDraw();
	__property TfrxNotifyEvent OnAfterData = {read=FOnAfterData, write=FOnAfterData};
	__property TfrxNotifyEvent OnAfterPrint = {read=FOnAfterPrint, write=FOnAfterPrint};
	__property TfrxNotifyEvent OnBeforePrint = {read=FOnBeforePrint, write=FOnBeforePrint};
	__property TfrxPreviewClickEvent OnPreviewClick = {read=FOnPreviewClick, write=FOnPreviewClick};
	__property TfrxPreviewClickEvent OnPreviewDblClick = {read=FOnPreviewDblClick, write=FOnPreviewDblClick};
	__property TfrxContentChangedEvent OnContentChanged = {read=FOnContentChanged, write=FOnContentChanged};
	__property TfrxPrintOnTypes PrintOn = {read=FPrintOn, write=FPrintOn, nodefault};
	
__published:
	__property Description = {default=0};
	__property IndexTag;
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxReportComponent(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxComponent(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDialogComponent : public TfrxReportComponent
{
	typedef TfrxReportComponent inherited;
	
private:
	System::Classes::TComponent* FComponent;
	HIDESBASE void __fastcall ReadLeft(System::Classes::TReader* Reader);
	HIDESBASE void __fastcall ReadTop(System::Classes::TReader* Reader);
	HIDESBASE void __fastcall WriteLeft(System::Classes::TWriter* Writer);
	HIDESBASE void __fastcall WriteTop(System::Classes::TWriter* Writer);
	
protected:
	int FImageIndex;
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	
public:
	__fastcall virtual TfrxDialogComponent(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDialogComponent();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	__property System::Classes::TComponent* Component = {read=FComponent, write=FComponent};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDialogComponent(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxReportComponent(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDialogControl : public TfrxReportComponent
{
	typedef TfrxReportComponent inherited;
	
private:
	Vcl::Controls::TControl* FControl;
	TfrxNotifyEvent FOnClick;
	TfrxNotifyEvent FOnDblClick;
	TfrxNotifyEvent FOnEnter;
	TfrxNotifyEvent FOnExit;
	TfrxKeyEvent FOnKeyDown;
	TfrxKeyPressEvent FOnKeyPress;
	TfrxKeyEvent FOnKeyUp;
	TfrxMouseEvent FOnMouseDown;
	TfrxMouseMoveEvent FOnMouseMove;
	TfrxMouseEvent FOnMouseUp;
	System::Classes::TNotifyEvent FOnActivate;
	System::Uitypes::TColor __fastcall GetColor();
	bool __fastcall GetEnabled();
	void __fastcall DoOnClick(System::TObject* Sender);
	void __fastcall DoOnDblClick(System::TObject* Sender);
	void __fastcall DoOnEnter(System::TObject* Sender);
	void __fastcall DoOnExit(System::TObject* Sender);
	void __fastcall DoOnKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall DoOnKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall DoOnKeyUp(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall DoOnMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall DoOnMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall DoOnMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall DoOnMouseWheel(System::TObject* Sender, System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	void __fastcall SetEnabled(const bool Value);
	System::UnicodeString __fastcall GetCaption();
	void __fastcall SetCaption(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetHint();
	void __fastcall SetHint(const System::UnicodeString Value);
	bool __fastcall GetShowHint();
	void __fastcall SetShowHint(const bool Value);
	bool __fastcall GetTabStop();
	void __fastcall SetTabStop(const bool Value);
	
protected:
	virtual void __fastcall SetAnchors(const TfrxAnchors Value);
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual void __fastcall SetTop(System::Extended Value);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	virtual void __fastcall SetParentFont(const bool Value);
	virtual void __fastcall SetVisible(bool Value);
	virtual void __fastcall SetParent(TfrxComponent* AParent);
	virtual void __fastcall FontChanged(System::TObject* Sender);
	void __fastcall InitControl(Vcl::Controls::TControl* AControl);
	virtual void __fastcall SetName(const System::Classes::TComponentName AName);
	
public:
	__fastcall virtual TfrxDialogControl(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDialogControl();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual bool __fastcall IsOwnerDraw();
	virtual bool __fastcall IsAcceptControls();
	virtual bool __fastcall IsAcceptAsChild(TfrxComponent* aParent);
	__property System::UnicodeString Caption = {read=GetCaption, write=SetCaption};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, nodefault};
	__property Vcl::Controls::TControl* Control = {read=FControl, write=FControl};
	__property bool TabStop = {read=GetTabStop, write=SetTabStop, default=1};
	__property TfrxNotifyEvent OnClick = {read=FOnClick, write=FOnClick};
	__property TfrxNotifyEvent OnDblClick = {read=FOnDblClick, write=FOnDblClick};
	__property TfrxNotifyEvent OnEnter = {read=FOnEnter, write=FOnEnter};
	__property TfrxNotifyEvent OnExit = {read=FOnExit, write=FOnExit};
	__property TfrxKeyEvent OnKeyDown = {read=FOnKeyDown, write=FOnKeyDown};
	__property TfrxKeyPressEvent OnKeyPress = {read=FOnKeyPress, write=FOnKeyPress};
	__property TfrxKeyEvent OnKeyUp = {read=FOnKeyUp, write=FOnKeyUp};
	__property TfrxMouseEvent OnMouseDown = {read=FOnMouseDown, write=FOnMouseDown};
	__property TfrxMouseMoveEvent OnMouseMove = {read=FOnMouseMove, write=FOnMouseMove};
	__property TfrxMouseEvent OnMouseUp = {read=FOnMouseUp, write=FOnMouseUp};
	__property System::Classes::TNotifyEvent OnActivate = {read=FOnActivate, write=FOnActivate};
	
__published:
	__property Anchors = {default=3};
	__property Left = {default=0};
	__property Top = {default=0};
	__property Width = {default=0};
	__property Height = {default=0};
	__property Font;
	__property GroupIndex = {default=0};
	__property ParentFont = {default=1};
	__property bool Enabled = {read=GetEnabled, write=SetEnabled, default=1};
	__property System::UnicodeString Hint = {read=GetHint, write=SetHint};
	__property bool ShowHint = {read=GetShowHint, write=SetShowHint, nodefault};
	__property Visible = {default=1};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDialogControl(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxReportComponent(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDataSet : public TfrxDialogComponent
{
	typedef TfrxDialogComponent inherited;
	
private:
	bool FCloseDataSource;
	bool FEnabled;
	bool FEof;
	bool FOpenDataSource;
	TfrxRangeBegin FRangeBegin;
	TfrxRangeEnd FRangeEnd;
	int FRangeEndCount;
	TfrxReport* FReportRef;
	System::UnicodeString FUserName;
	TfrxCheckEOFEvent FOnCheckEOF;
	System::Classes::TNotifyEvent FOnFirst;
	System::Classes::TNotifyEvent FOnNext;
	System::Classes::TNotifyEvent FOnPrior;
	System::Classes::TNotifyEvent FOnOpen;
	System::Classes::TNotifyEvent FOnClose;
	
protected:
	bool FInitialized;
	int FRecNo;
	virtual System::WideString __fastcall GetDisplayText(System::UnicodeString Index);
	virtual int __fastcall GetDisplayWidth(System::UnicodeString Index);
	virtual TfrxFieldType __fastcall GetFieldType(System::UnicodeString Index);
	virtual System::Variant __fastcall GetValue(System::UnicodeString Index);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	virtual void __fastcall SetUserName(const System::UnicodeString Value);
	
public:
	__fastcall virtual TfrxDataSet(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDataSet();
	virtual void __fastcall Initialize();
	virtual void __fastcall Finalize();
	virtual void __fastcall Open();
	virtual void __fastcall Close();
	virtual void __fastcall First();
	virtual void __fastcall Next();
	virtual void __fastcall Prior();
	virtual bool __fastcall Eof();
	virtual int __fastcall FieldsCount();
	bool __fastcall HasField(const System::UnicodeString fName);
	virtual bool __fastcall IsBlobField(const System::UnicodeString fName);
	virtual bool __fastcall IsWideMemoBlobField(const System::UnicodeString fName);
	virtual bool __fastcall IsHasMaster();
	virtual int __fastcall RecordCount();
	virtual void __fastcall AssignBlobTo(const System::UnicodeString fName, System::TObject* Obj);
	virtual void __fastcall GetFieldList(System::Classes::TStrings* List);
	__property System::WideString DisplayText[System::UnicodeString Index] = {read=GetDisplayText};
	__property int DisplayWidth[System::UnicodeString Index] = {read=GetDisplayWidth};
	__property TfrxFieldType FieldType[System::UnicodeString Index] = {read=GetFieldType};
	__property System::Variant Value[System::UnicodeString Index] = {read=GetValue};
	__property bool CloseDataSource = {read=FCloseDataSource, write=FCloseDataSource, nodefault};
	__property bool OpenDataSource = {read=FOpenDataSource, write=FOpenDataSource, default=1};
	__property int RecNo = {read=FRecNo, nodefault};
	__property TfrxReport* ReportRef = {read=FReportRef, write=FReportRef};
	__property System::Classes::TNotifyEvent OnClose = {read=FOnClose, write=FOnClose};
	__property System::Classes::TNotifyEvent OnOpen = {read=FOnOpen, write=FOnOpen};
	
__published:
	__property bool Enabled = {read=FEnabled, write=FEnabled, default=1};
	__property TfrxRangeBegin RangeBegin = {read=FRangeBegin, write=FRangeBegin, default=0};
	__property TfrxRangeEnd RangeEnd = {read=FRangeEnd, write=FRangeEnd, default=0};
	__property int RangeEndCount = {read=FRangeEndCount, write=FRangeEndCount, default=0};
	__property System::UnicodeString UserName = {read=FUserName, write=SetUserName};
	__property TfrxCheckEOFEvent OnCheckEOF = {read=FOnCheckEOF, write=FOnCheckEOF};
	__property System::Classes::TNotifyEvent OnFirst = {read=FOnFirst, write=FOnFirst};
	__property System::Classes::TNotifyEvent OnNext = {read=FOnNext, write=FOnNext};
	__property System::Classes::TNotifyEvent OnPrior = {read=FOnPrior, write=FOnPrior};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDataSet(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDialogComponent(AOwner, Flags) { }
	
};


typedef System::TMetaClass* TfrxComponentClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxBindableFieldProps : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxBindableFieldProps() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxBindableFieldProps() : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxUserDataSet : public TfrxDataSet
{
	typedef TfrxDataSet inherited;
	
private:
	System::Classes::TStrings* FFields;
	TfrxGetValueEvent FOnGetValue;
	TfrxNewGetValueEvent FOnNewGetValue;
	TfrxGetBlobValueEvent FOnGetBlobValue;
	TfrxIsBlobFieldEvent FOnIsBlobField;
	void __fastcall SetFields(System::Classes::TStrings* const Value);
	
protected:
	virtual System::WideString __fastcall GetDisplayText(System::UnicodeString Index);
	virtual System::Variant __fastcall GetValue(System::UnicodeString Index);
	
public:
	__fastcall virtual TfrxUserDataSet(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxUserDataSet();
	virtual int __fastcall FieldsCount();
	virtual void __fastcall GetFieldList(System::Classes::TStrings* List);
	virtual bool __fastcall IsBlobField(const System::UnicodeString FieldName);
	virtual void __fastcall AssignBlobTo(const System::UnicodeString FieldName, System::TObject* Obj);
	
__published:
	__property System::Classes::TStrings* Fields = {read=FFields, write=SetFields};
	__property TfrxGetValueEvent OnGetValue = {read=FOnGetValue, write=FOnGetValue};
	__property TfrxNewGetValueEvent OnNewGetValue = {read=FOnNewGetValue, write=FOnNewGetValue};
	__property TfrxGetBlobValueEvent OnGetBlobValue = {read=FOnGetBlobValue, write=FOnGetBlobValue};
	__property TfrxIsBlobFieldEvent OnIsBlobField = {read=FOnIsBlobField, write=FOnIsBlobField};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxUserDataSet(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDataSet(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxCustomDBDataSet : public TfrxDataSet
{
	typedef TfrxDataSet inherited;
	
private:
	System::Classes::TStrings* FAliases;
	System::Classes::TStringList* FFields;
	void __fastcall SetFieldAliases(System::Classes::TStrings* const Value);
	
protected:
	__property System::Classes::TStringList* Fields = {read=FFields};
	
public:
	__fastcall virtual TfrxCustomDBDataSet(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomDBDataSet();
	System::UnicodeString __fastcall ConvertAlias(const System::UnicodeString fName);
	System::UnicodeString __fastcall GetAlias(const System::UnicodeString fName);
	virtual int __fastcall FieldsCount();
	
__published:
	__property CloseDataSource;
	__property System::Classes::TStrings* FieldAliases = {read=FAliases, write=SetFieldAliases};
	__property OpenDataSource = {default=1};
	__property OnClose;
	__property OnOpen;
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomDBDataSet(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDataSet(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDBComponents : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	virtual System::UnicodeString __fastcall GetDescription();
public:
	/* TComponent.Create */ inline __fastcall virtual TfrxDBComponents(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxDBComponents() { }
	
};


class PASCALIMPLEMENTATION TfrxCustomDatabase : public TfrxDialogComponent
{
	typedef TfrxDialogComponent inherited;
	
protected:
	void __fastcall BeforeConnect(bool &Value);
	void __fastcall AfterDisconnect();
	virtual void __fastcall SetConnected(bool Value);
	virtual void __fastcall SetDatabaseName(const System::UnicodeString Value);
	virtual void __fastcall SetLoginPrompt(bool Value);
	virtual void __fastcall SetParams(System::Classes::TStrings* Value);
	virtual bool __fastcall GetConnected();
	virtual System::UnicodeString __fastcall GetDatabaseName();
	virtual bool __fastcall GetLoginPrompt();
	virtual System::Classes::TStrings* __fastcall GetParams();
	
public:
	HIDESBASE virtual System::WideString __fastcall ToString();
	virtual void __fastcall FromString(const System::WideString Connection);
	virtual void __fastcall SetLogin(const System::UnicodeString Login, const System::UnicodeString Password);
	__property bool Connected = {read=GetConnected, write=SetConnected, default=0};
	__property System::UnicodeString DatabaseName = {read=GetDatabaseName, write=SetDatabaseName};
	__property bool LoginPrompt = {read=GetLoginPrompt, write=SetLoginPrompt, default=1};
	__property System::Classes::TStrings* Params = {read=GetParams, write=SetParams};
public:
	/* TfrxDialogComponent.Create */ inline __fastcall virtual TfrxCustomDatabase(System::Classes::TComponent* AOwner) : TfrxDialogComponent(AOwner) { }
	/* TfrxDialogComponent.Destroy */ inline __fastcall virtual ~TfrxCustomDatabase() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomDatabase(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDialogComponent(AOwner, Flags) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFillGaps : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FTop;
	int FLeft;
	int FBottom;
	int FRight;
	
__published:
	__property int Top = {read=FTop, write=FTop, nodefault};
	__property int Left = {read=FLeft, write=FLeft, nodefault};
	__property int Bottom = {read=FBottom, write=FBottom, nodefault};
	__property int Right = {read=FRight, write=FRight, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxFillGaps() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxFillGaps() : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCustomFill : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* ACanvas, int X, int Y, int X1, int Y1, System::Extended ScaleX, System::Extended ScaleY) = 0 ;
	virtual System::UnicodeString __fastcall Diff(TfrxCustomFill* AFill, const System::UnicodeString Add) = 0 ;
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxCustomFill() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxCustomFill() : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxBrushFill : public TfrxCustomFill
{
	typedef TfrxCustomFill inherited;
	
private:
	System::Uitypes::TColor FBackColor;
	System::Uitypes::TColor FForeColor;
	Vcl::Graphics::TBrushStyle FStyle;
	
public:
	__fastcall TfrxBrushFill();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* ACanvas, int X, int Y, int X1, int Y1, System::Extended ScaleX, System::Extended ScaleY);
	virtual System::UnicodeString __fastcall Diff(TfrxCustomFill* AFill, const System::UnicodeString Add);
	
__published:
	__property System::Uitypes::TColor BackColor = {read=FBackColor, write=FBackColor, default=536870911};
	__property System::Uitypes::TColor ForeColor = {read=FForeColor, write=FForeColor, default=0};
	__property Vcl::Graphics::TBrushStyle Style = {read=FStyle, write=FStyle, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxBrushFill() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxGradientFill : public TfrxCustomFill
{
	typedef TfrxCustomFill inherited;
	
private:
	System::Uitypes::TColor FStartColor;
	System::Uitypes::TColor FEndColor;
	TfrxGradientStyle FGradientStyle;
	
public:
	__fastcall TfrxGradientFill();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* ACanvas, int X, int Y, int X1, int Y1, System::Extended ScaleX, System::Extended ScaleY);
	virtual System::UnicodeString __fastcall Diff(TfrxCustomFill* AFill, const System::UnicodeString Add);
	System::Uitypes::TColor __fastcall GetColor();
	
__published:
	__property System::Uitypes::TColor StartColor = {read=FStartColor, write=FStartColor, default=16777215};
	__property System::Uitypes::TColor EndColor = {read=FEndColor, write=FEndColor, default=0};
	__property TfrxGradientStyle GradientStyle = {read=FGradientStyle, write=FGradientStyle, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxGradientFill() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TfrxGlassFillOrientation : unsigned char { foVertical, foHorizontal, foVerticalMirror, foHorizontalMirror };

class PASCALIMPLEMENTATION TfrxGlassFill : public TfrxCustomFill
{
	typedef TfrxCustomFill inherited;
	
private:
	System::Uitypes::TColor FColor;
	System::Extended FBlend;
	bool FHatch;
	TfrxGlassFillOrientation FOrient;
	
public:
	__fastcall TfrxGlassFill();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* ACanvas, int X, int Y, int X1, int Y1, System::Extended ScaleX, System::Extended ScaleY);
	virtual System::UnicodeString __fastcall Diff(TfrxCustomFill* AFill, const System::UnicodeString Add);
	System::Uitypes::TColor __fastcall GetColor();
	System::Uitypes::TColor __fastcall BlendColor();
	System::Uitypes::TColor __fastcall HatchColor();
	
__published:
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, default=16777215};
	__property System::Extended Blend = {read=FBlend, write=FBlend};
	__property bool Hatch = {read=FHatch, write=FHatch, default=0};
	__property TfrxGlassFillOrientation Orientation = {read=FOrient, write=FOrient, default=1};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxGlassFill() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHyperlink : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TfrxHyperlinkKind FKind;
	System::UnicodeString FDetailReport;
	System::UnicodeString FDetailPage;
	System::UnicodeString FExpression;
	System::UnicodeString FReportVariable;
	System::UnicodeString FValue;
	System::UnicodeString FValuesSeparator;
	System::UnicodeString FTabCaption;
	bool __fastcall IsValuesSeparatorStored();
	
public:
	__fastcall TfrxHyperlink();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	System::UnicodeString __fastcall Diff(TfrxHyperlink* ALink, const System::UnicodeString Add);
	void __fastcall AssignVariables(TfrxReport* aReport);
	
__published:
	__property TfrxHyperlinkKind Kind = {read=FKind, write=FKind, default=0};
	__property System::UnicodeString DetailReport = {read=FDetailReport, write=FDetailReport};
	__property System::UnicodeString DetailPage = {read=FDetailPage, write=FDetailPage};
	__property System::UnicodeString Expression = {read=FExpression, write=FExpression};
	__property System::UnicodeString ReportVariable = {read=FReportVariable, write=FReportVariable};
	__property System::UnicodeString TabCaption = {read=FTabCaption, write=FTabCaption};
	__property System::UnicodeString Value = {read=FValue, write=FValue};
	__property System::UnicodeString ValuesSeparator = {read=FValuesSeparator, write=FValuesSeparator, stored=IsValuesSeparatorStored};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxHyperlink() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxFrameLine : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TfrxFrame* FFrame;
	System::Uitypes::TColor FColor;
	TfrxFrameStyle FStyle;
	System::Extended FWidth;
	bool __fastcall IsColorStored();
	bool __fastcall IsStyleStored();
	bool __fastcall IsWidthStored();
	
public:
	__fastcall TfrxFrameLine(TfrxFrame* AFrame);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	System::UnicodeString __fastcall Diff(TfrxFrameLine* ALine, const System::UnicodeString LineName, bool ColorChanged, bool StyleChanged, bool WidthChanged);
	
__published:
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, stored=IsColorStored, nodefault};
	__property TfrxFrameStyle Style = {read=FStyle, write=FStyle, stored=IsStyleStored, nodefault};
	__property System::Extended Width = {read=FWidth, write=FWidth, stored=IsWidthStored};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxFrameLine() { }
	
};


class PASCALIMPLEMENTATION TfrxFrame : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TfrxFrameLine* FLeftLine;
	TfrxFrameLine* FTopLine;
	TfrxFrameLine* FRightLine;
	TfrxFrameLine* FBottomLine;
	System::Uitypes::TColor FColor;
	bool FDropShadow;
	System::Extended FShadowWidth;
	System::Uitypes::TColor FShadowColor;
	TfrxFrameStyle FStyle;
	TfrxFrameTypes FTyp;
	System::Extended FWidth;
	bool __fastcall IsShadowWidthStored();
	bool __fastcall IsTypStored();
	bool __fastcall IsWidthStored();
	void __fastcall SetBottomLine(TfrxFrameLine* const Value);
	void __fastcall SetLeftLine(TfrxFrameLine* const Value);
	void __fastcall SetRightLine(TfrxFrameLine* const Value);
	void __fastcall SetTopLine(TfrxFrameLine* const Value);
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	void __fastcall SetStyle(const TfrxFrameStyle Value);
	void __fastcall SetWidth(const System::Extended Value);
	
public:
	__fastcall TfrxFrame();
	__fastcall virtual ~TfrxFrame();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	System::UnicodeString __fastcall Diff(TfrxFrame* AFrame);
	void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, int FX, int FY, int FX1, int FY1, System::Extended ScaleX, System::Extended ScaleY);
	
__published:
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, default=0};
	__property bool DropShadow = {read=FDropShadow, write=FDropShadow, default=0};
	__property System::Uitypes::TColor ShadowColor = {read=FShadowColor, write=FShadowColor, default=0};
	__property System::Extended ShadowWidth = {read=FShadowWidth, write=FShadowWidth, stored=IsShadowWidthStored};
	__property TfrxFrameStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property TfrxFrameTypes Typ = {read=FTyp, write=FTyp, stored=IsTypStored, nodefault};
	__property System::Extended Width = {read=FWidth, write=SetWidth, stored=IsWidthStored};
	__property TfrxFrameLine* LeftLine = {read=FLeftLine, write=SetLeftLine};
	__property TfrxFrameLine* TopLine = {read=FTopLine, write=SetTopLine};
	__property TfrxFrameLine* RightLine = {read=FRightLine, write=SetRightLine};
	__property TfrxFrameLine* BottomLine = {read=FBottomLine, write=SetBottomLine};
};


class PASCALIMPLEMENTATION TfrxView : public TfrxReportComponent
{
	typedef TfrxReportComponent inherited;
	
private:
	TfrxAlign FAlign;
	System::Uitypes::TCursor FCursor;
	System::UnicodeString FDataField;
	TfrxDataSet* FDataSet;
	System::UnicodeString FDataSetName;
	TfrxFrame* FFrame;
	TfrxShiftMode FShiftMode;
	System::UnicodeString FTagStr;
	System::UnicodeString FTempTag;
	System::UnicodeString FTempHyperlink;
	System::UnicodeString FHint;
	bool FShowHint;
	System::UnicodeString FURL;
	bool FPlainText;
	TfrxHyperlink* FHyperlink;
	TfrxCustomFill* FFill;
	TfrxVisibilityTypes FVisibility;
	bool FDrawAsMask;
	bool FAllowVectorExport;
	TfrxMouseEnterViewEvent FOnMouseEnter;
	TfrxMouseLeaveViewEvent FOnMouseLeave;
	TfrxMouseEvent FOnMouseDown;
	TfrxMouseMoveEvent FOnMouseMove;
	TfrxMouseEvent FOnMouseUp;
	void __fastcall SetFrame(TfrxFrame* const Value);
	void __fastcall SetDataSet(TfrxDataSet* const Value);
	void __fastcall SetDataSetName(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDataSetName();
	void __fastcall SetFillType(const TfrxFillType Value);
	TfrxFillType __fastcall GetFillType();
	void __fastcall SetBrushStyle(const Vcl::Graphics::TBrushStyle Value);
	Vcl::Graphics::TBrushStyle __fastcall GetBrushStyle();
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	System::Uitypes::TColor __fastcall GetColor();
	void __fastcall SetHyperLink(TfrxHyperlink* const Value);
	void __fastcall SetFill(TfrxCustomFill* const Value);
	void __fastcall SetURL(const System::UnicodeString Value);
	bool __fastcall GetPrintable();
	void __fastcall SetPrintable(bool Value);
	void __fastcall SetProcessing(TfrxObjectProcessing* const Value);
	
protected:
	int FX;
	int FY;
	int FX1;
	int FY1;
	int FDX;
	int FDY;
	int FFrameWidth;
	System::Extended FScaleX;
	System::Extended FScaleY;
	System::Extended FOffsetX;
	System::Extended FOffsetY;
	Vcl::Graphics::TCanvas* FCanvas;
	TfrxObjectProcessing* FProcessing;
	bool FObjAsMetafile;
	bool FDrawFillOnMetaFile;
	Frxvectorcanvas::TVectorCanvas* FVC;
	virtual void __fastcall BeginDraw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall DrawBackground();
	virtual void __fastcall DrawFrame();
	void __fastcall DrawFrameEdges();
	void __fastcall DrawLine(int x, int y, int x1, int y1, int w);
	void __fastcall ExpandVariables(System::UnicodeString &Expr);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall GetScreenScale(System::Extended &aScaleX, System::Extended &aScaleY);
	
public:
	__fastcall virtual TfrxView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxView();
	virtual System::UnicodeString __fastcall Diff(TfrxComponent* AComponent);
	bool __fastcall IsDataField();
	virtual bool __fastcall IsEMFExportable();
	virtual bool __fastcall IsAcceptAsChild(TfrxComponent* aParent);
	virtual Vcl::Graphics::TGraphic* __fastcall GetVectorGraphic(bool DrawFill = false);
	virtual Frxvectorcanvas::TVectorCanvas* __fastcall GetVectorCanvas();
	virtual void __fastcall DrawHighlight(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY, System::Uitypes::TColor hlColor = (System::Uitypes::TColor)(0x1fffffff));
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall DrawClipped(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall BeforePrint();
	virtual void __fastcall GetData();
	virtual void __fastcall GetScaleFactor(System::Extended &ScaleX, System::Extended &ScaleY);
	virtual void __fastcall MirrorContent(TfrxMirrorControlModes MirrorModes);
	virtual void __fastcall AfterPrint();
	System::Extended __fastcall ShadowSize();
	virtual TfrxRect __fastcall GetExportBounds();
	virtual void __fastcall SaveContentToDictionary(TfrxReport* aReport, TfrxPostProcessor* PostProcessor);
	virtual bool __fastcall LoadContentFromDictionary(TfrxReport* aReport, TfrxMacrosItem* aItem);
	virtual void __fastcall ProcessDictionary(TfrxMacrosItem* aItem, TfrxReport* aReport, TfrxPostProcessor* PostProcessor);
	virtual bool __fastcall IsPostProcessAllowed();
	__property TfrxFillType FillType = {read=GetFillType, write=SetFillType, default=0};
	__property TfrxCustomFill* Fill = {read=FFill, write=SetFill};
	__property Vcl::Graphics::TBrushStyle BrushStyle = {read=GetBrushStyle, write=SetBrushStyle, stored=false, nodefault};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, stored=false, nodefault};
	__property System::UnicodeString DataField = {read=FDataField, write=FDataField};
	__property TfrxDataSet* DataSet = {read=FDataSet, write=SetDataSet};
	__property System::UnicodeString DataSetName = {read=GetDataSetName, write=SetDataSetName};
	__property TfrxFrame* Frame = {read=FFrame, write=SetFrame};
	__property bool PlainText = {read=FPlainText, write=FPlainText, nodefault};
	__property System::Uitypes::TCursor Cursor = {read=FCursor, write=FCursor, default=0};
	__property System::UnicodeString TagStr = {read=FTagStr, write=FTagStr};
	__property System::UnicodeString URL = {read=FURL, write=SetURL, stored=false};
	__property bool DrawAsMask = {read=FDrawAsMask, write=FDrawAsMask, nodefault};
	__property TfrxObjectProcessing* Processing = {read=FProcessing, write=SetProcessing};
	
__published:
	__property Anchors = {default=3};
	__property TfrxAlign Align = {read=FAlign, write=FAlign, default=0};
	__property bool AllowVectorExport = {read=FAllowVectorExport, write=FAllowVectorExport, nodefault};
	__property bool Printable = {read=GetPrintable, write=SetPrintable, stored=false, default=1};
	__property TfrxShiftMode ShiftMode = {read=FShiftMode, write=FShiftMode, default=1};
	__property Left = {default=0};
	__property Top = {default=0};
	__property Width = {default=0};
	__property Height = {default=0};
	__property GroupIndex = {default=0};
	__property Restrictions = {default=0};
	__property Visible = {default=1};
	__property OnAfterData = {default=0};
	__property OnAfterPrint = {default=0};
	__property OnBeforePrint = {default=0};
	__property OnContentChanged = {default=0};
	__property TfrxMouseEnterViewEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property TfrxMouseLeaveViewEvent OnMouseLeave = {read=FOnMouseLeave, write=FOnMouseLeave};
	__property TfrxMouseEvent OnMouseDown = {read=FOnMouseDown, write=FOnMouseDown};
	__property TfrxMouseMoveEvent OnMouseMove = {read=FOnMouseMove, write=FOnMouseMove};
	__property TfrxMouseEvent OnMouseUp = {read=FOnMouseUp, write=FOnMouseUp};
	__property OnPreviewClick = {default=0};
	__property OnPreviewDblClick = {default=0};
	__property TfrxHyperlink* Hyperlink = {read=FHyperlink, write=SetHyperLink};
	__property System::UnicodeString Hint = {read=FHint, write=FHint};
	__property bool ShowHint = {read=FShowHint, write=FShowHint, default=0};
	__property TfrxVisibilityTypes Visibility = {read=FVisibility, write=FVisibility, default=7};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxReportComponent(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxStretcheable : public TfrxView
{
	typedef TfrxView inherited;
	
private:
	TfrxStretchMode FStretchMode;
	bool FCanShrink;
	
public:
	System::Extended FSaveHeight;
	System::Extended FSavedTop;
	__fastcall virtual TfrxStretcheable(System::Classes::TComponent* AOwner);
	virtual System::Extended __fastcall CalcHeight();
	virtual System::Extended __fastcall DrawPart();
	virtual void __fastcall InitPart();
	virtual bool __fastcall HasNextDataPart(System::Extended aFreeSpace);
	
__published:
	__property bool CanShrink = {read=FCanShrink, write=FCanShrink, default=0};
	__property TfrxStretchMode StretchMode = {read=FStretchMode, write=FStretchMode, default=0};
public:
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxStretcheable() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxStretcheable(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxView(AOwner, Flags) { }
	
};


enum DECLSPEC_DENUM TfrxInteractiveHighlightEvent : unsigned char { ihNone, ihClick, ihEnter, ieLeave };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHighlight : public Frxcollections::TfrxCollectionItem
{
	typedef Frxcollections::TfrxCollectionItem inherited;
	
private:
	bool FActive;
	bool FApplyFont;
	bool FApplyFill;
	bool FApplyFrame;
	System::UnicodeString FCondition;
	Vcl::Graphics::TFont* FFont;
	TfrxCustomFill* FFill;
	TfrxFrame* FFrame;
	bool FVisible;
	TfrxInteractiveHighlightEvent FInteractiveType;
	void __fastcall SetFont(Vcl::Graphics::TFont* const Value);
	void __fastcall SetFill(TfrxCustomFill* const Value);
	void __fastcall SetFillType(const TfrxFillType Value);
	TfrxFillType __fastcall GetFillType();
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	System::Uitypes::TColor __fastcall GetColor();
	void __fastcall SetFrame(TfrxFrame* const Value);
	
public:
	__fastcall virtual TfrxHighlight(System::Classes::TCollection* Collection);
	__fastcall virtual ~TfrxHighlight();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual bool __fastcall IsUniqueNameStored();
	
__published:
	__property bool Active = {read=FActive, write=FActive, stored=false, default=0};
	__property bool ApplyFont = {read=FApplyFont, write=FApplyFont, default=1};
	__property bool ApplyFill = {read=FApplyFill, write=FApplyFill, default=1};
	__property bool ApplyFrame = {read=FApplyFrame, write=FApplyFrame, default=0};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, stored=false, default=536870911};
	__property System::UnicodeString Condition = {read=FCondition, write=FCondition};
	__property TfrxInteractiveHighlightEvent InteractiveType = {read=FInteractiveType, write=FInteractiveType, default=0};
	__property TfrxFillType FillType = {read=GetFillType, write=SetFillType, nodefault};
	__property TfrxCustomFill* Fill = {read=FFill, write=SetFill};
	__property TfrxFrame* Frame = {read=FFrame, write=SetFrame};
	__property bool Visible = {read=FVisible, write=FVisible, default=1};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxHighlightCollection : public Frxcollections::TfrxCollection
{
	typedef Frxcollections::TfrxCollection inherited;
	
public:
	TfrxHighlight* operator[](int Index) { return this->Items[Index]; }
	
private:
	HIDESBASE TfrxHighlight* __fastcall GetItem(int Index);
	
public:
	__fastcall TfrxHighlightCollection();
	__property TfrxHighlight* Items[int Index] = {read=GetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxHighlightCollection() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFormat : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	System::UnicodeString FDecimalSeparator;
	System::UnicodeString FThousandSeparator;
	System::UnicodeString FFormatStr;
	TfrxFormatKind FKind;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::UnicodeString DecimalSeparator = {read=FDecimalSeparator, write=FDecimalSeparator};
	__property System::UnicodeString ThousandSeparator = {read=FThousandSeparator, write=FThousandSeparator};
	__property System::UnicodeString FormatStr = {read=FFormatStr, write=FFormatStr};
	__property TfrxFormatKind Kind = {read=FKind, write=FKind, default=0};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxFormat(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxFormat() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxFormatCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxFormat* operator[](int Index) { return this->Items[Index]; }
	
private:
	HIDESBASE TfrxFormat* __fastcall GetItem(int Index);
	
public:
	__fastcall TfrxFormatCollection();
	__property TfrxFormat* Items[int Index] = {read=GetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxFormatCollection() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxCustomMemoView : public TfrxStretcheable
{
	typedef TfrxStretcheable inherited;
	
private:
	bool FAllowExpressions;
	bool FAllowHTMLTags;
	bool FAutoWidth;
	System::Extended FCharSpacing;
	bool FClipped;
	TfrxFormatCollection* FFormats;
	System::UnicodeString FExpressionDelimiters;
	TfrxCustomMemoView* FFlowTo;
	bool FFirstParaBreak;
	System::Extended FGapX;
	System::Extended FGapY;
	TfrxHAlign FHAlign;
	bool FHideZeros;
	TfrxHighlightCollection* FHighlights;
	bool FLastParaBreak;
	System::Extended FLineSpacing;
	System::Widestrings::TWideStrings* FMemo;
	System::Extended FParagraphGap;
	System::WideString FPartMemo;
	int FRotation;
	bool FRTLReading;
	System::UnicodeString FStyle;
	bool FSuppressRepeated;
	TfrxDuplicateMerge FDuplicates;
	System::WideString FTempMemo;
	TfrxUnderlinesTextMode FUnderlinesTextMode;
	TfrxVAlign FVAlign;
	System::Variant FValue;
	bool FWordBreak;
	bool FWordWrap;
	bool FWysiwyg;
	bool FUseDefaultCharset;
	bool FHighlightActivated;
	TfrxCustomFill* FTempFill;
	Vcl::Graphics::TFont* FTempFont;
	TfrxFrame* FTempFrame;
	bool FTempVisible;
	System::Types::TRect FScaledRect;
	bool FMacroLoaded;
	void __fastcall SetMemo(System::Widestrings::TWideStrings* const Value);
	void __fastcall SetRotation(int Value);
	void __fastcall SetText(const System::WideString Value);
	void __fastcall SetAnsiText(const System::AnsiString Value);
	System::Extended __fastcall AdjustCalcHeight();
	System::Extended __fastcall AdjustCalcWidth();
	System::WideString __fastcall GetText();
	System::AnsiString __fastcall GetAnsiText();
	bool __fastcall IsExprDelimitersStored();
	bool __fastcall IsLineSpacingStored();
	bool __fastcall IsGapXStored();
	bool __fastcall IsGapYStored();
	bool __fastcall IsHighlightStored();
	bool __fastcall IsDisplayFormatStored();
	bool __fastcall IsParagraphGapStored();
	TfrxHighlight* __fastcall GetHighlight();
	TfrxFormat* __fastcall GetDisplayFormat();
	void __fastcall SetHighlight(TfrxHighlight* const Value);
	void __fastcall SetDisplayFormat(TfrxFormat* const Value);
	void __fastcall SetStyle(const System::UnicodeString Value);
	bool __fastcall IsCharSpacingStored();
	void __fastcall WriteFormats(System::Classes::TWriter* Writer);
	void __fastcall WriteHighlights(System::Classes::TWriter* Writer);
	void __fastcall ReadFormats(System::Classes::TReader* Reader);
	void __fastcall ReadHighlights(System::Classes::TReader* Reader);
	void __fastcall SavePreHighlightState();
	void __fastcall RestorePreHighlightState();
	bool __fastcall GetUnderlines();
	void __fastcall SetUnderlines(const bool Value);
	
protected:
	System::Variant FLastValue;
	int FTotalPages;
	int FCopyNo;
	System::Types::TRect FTextRect;
	System::Extended FPrintScale;
	int FMacroIndex;
	int FMacroLine;
	virtual void __fastcall Loaded();
	System::WideString __fastcall CalcAndFormat(const System::WideString Expr, TfrxFormat* Format);
	System::Types::TRect __fastcall CalcTextRect(System::Extended OffsetX, System::Extended OffsetY, System::Extended ScaleX, System::Extended ScaleY);
	virtual void __fastcall BeginDraw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	void __fastcall SetDrawParams(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	void __fastcall DrawText();
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	
public:
	__fastcall virtual TfrxCustomMemoView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomMemoView();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual System::UnicodeString __fastcall Diff(TfrxComponent* AComponent);
	virtual System::Extended __fastcall CalcHeight();
	virtual System::Extended __fastcall CalcWidth();
	virtual System::Extended __fastcall DrawPart();
	virtual void __fastcall WriteNestedProperties(Frxxml::TfrxXMLItem* Item, System::Classes::TPersistent* aAcenstor = (System::Classes::TPersistent*)(0x0));
	virtual bool __fastcall ReadNestedProperty(Frxxml::TfrxXMLItem* Item);
	void __fastcall ApplyPreviewHighlight();
	virtual void __fastcall SaveContentToDictionary(TfrxReport* aReport, TfrxPostProcessor* PostProcessor);
	virtual bool __fastcall LoadContentFromDictionary(TfrxReport* aReport, TfrxMacrosItem* aItem);
	virtual void __fastcall ProcessDictionary(TfrxMacrosItem* aItem, TfrxReport* aReport, TfrxPostProcessor* PostProcessor);
	virtual bool __fastcall IsPostProcessAllowed();
	virtual void __fastcall DoMouseEnter(TfrxComponent* aPreviousObject, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall DoMouseLeave(TfrxComponent* aNextObject, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall MirrorContent(TfrxMirrorControlModes MirrorModes);
	virtual System::UnicodeString __fastcall GetComponentText();
	System::WideString __fastcall FormatData(const System::Variant &Value, TfrxFormat* AFormat = (TfrxFormat*)(0x0));
	System::WideString __fastcall WrapText(bool WrapWords, System::Widestrings::TWideStrings* aParaText = (System::Widestrings::TWideStrings*)(0x0));
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall BeforePrint();
	virtual void __fastcall GetData();
	virtual void __fastcall AfterPrint();
	virtual void __fastcall InitPart();
	void __fastcall ApplyStyle(TfrxStyleItem* Style);
	void __fastcall ApplyHighlight(TfrxHighlight* AHighlight);
	void __fastcall ExtractMacros(TfrxPostProcessor* Dictionary = (TfrxPostProcessor*)(0x0));
	void __fastcall ResetSuppress();
	int __fastcall ReducedAngle();
	__property System::WideString Text = {read=GetText, write=SetText};
	__property System::AnsiString AnsiText = {read=GetAnsiText, write=SetAnsiText};
	__property System::Variant Value = {read=FValue, write=FValue};
	__property System::Widestrings::TWideStrings* Lines = {read=FMemo, write=SetMemo};
	__property bool AllowExpressions = {read=FAllowExpressions, write=FAllowExpressions, default=1};
	__property bool AllowHTMLTags = {read=FAllowHTMLTags, write=FAllowHTMLTags, default=0};
	__property bool AutoWidth = {read=FAutoWidth, write=FAutoWidth, default=0};
	__property System::Extended CharSpacing = {read=FCharSpacing, write=FCharSpacing, stored=IsCharSpacingStored};
	__property bool Clipped = {read=FClipped, write=FClipped, default=1};
	__property TfrxFormat* DisplayFormat = {read=GetDisplayFormat, write=SetDisplayFormat, stored=IsDisplayFormatStored};
	__property System::UnicodeString ExpressionDelimiters = {read=FExpressionDelimiters, write=FExpressionDelimiters, stored=IsExprDelimitersStored};
	__property TfrxCustomMemoView* FlowTo = {read=FFlowTo, write=FFlowTo};
	__property System::Extended GapX = {read=FGapX, write=FGapX, stored=IsGapXStored};
	__property System::Extended GapY = {read=FGapY, write=FGapY, stored=IsGapYStored};
	__property TfrxHAlign HAlign = {read=FHAlign, write=FHAlign, default=0};
	__property bool HideZeros = {read=FHideZeros, write=FHideZeros, default=0};
	__property TfrxHighlight* Highlight = {read=GetHighlight, write=SetHighlight, stored=IsHighlightStored};
	__property System::Extended LineSpacing = {read=FLineSpacing, write=FLineSpacing, stored=IsLineSpacingStored};
	__property System::Widestrings::TWideStrings* Memo = {read=FMemo, write=SetMemo};
	__property System::Extended ParagraphGap = {read=FParagraphGap, write=FParagraphGap, stored=IsParagraphGapStored};
	__property int Rotation = {read=FRotation, write=SetRotation, default=0};
	__property bool RTLReading = {read=FRTLReading, write=FRTLReading, default=0};
	__property System::UnicodeString Style = {read=FStyle, write=SetStyle};
	__property bool SuppressRepeated = {read=FSuppressRepeated, write=FSuppressRepeated, default=0};
	__property TfrxDuplicateMerge Duplicates = {read=FDuplicates, write=FDuplicates, default=0};
	__property bool Underlines = {read=GetUnderlines, write=SetUnderlines, default=0};
	__property TfrxUnderlinesTextMode UnderlinesTextMode = {read=FUnderlinesTextMode, write=FUnderlinesTextMode, default=0};
	__property bool WordBreak = {read=FWordBreak, write=FWordBreak, default=0};
	__property bool WordWrap = {read=FWordWrap, write=FWordWrap, default=1};
	__property bool Wysiwyg = {read=FWysiwyg, write=FWysiwyg, default=1};
	__property TfrxVAlign VAlign = {read=FVAlign, write=FVAlign, default=0};
	__property bool UseDefaultCharset = {read=FUseDefaultCharset, write=FUseDefaultCharset, default=0};
	__property TfrxHighlightCollection* Highlights = {read=FHighlights};
	__property TfrxFormatCollection* Formats = {read=FFormats};
	
__published:
	__property bool FirstParaBreak = {read=FFirstParaBreak, write=FFirstParaBreak, default=0};
	__property bool LastParaBreak = {read=FLastParaBreak, write=FLastParaBreak, default=0};
	__property Cursor = {default=0};
	__property TagStr = {default=0};
	__property URL = {default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxCustomMemoView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxStretcheable(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxMemoView : public TfrxCustomMemoView
{
	typedef TfrxCustomMemoView inherited;
	
__published:
	__property AutoWidth = {default=0};
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
	__property FlowTo;
	__property Font;
	__property Frame;
	__property FillType = {default=0};
	__property Fill;
	__property GapX = {default=0};
	__property GapY = {default=0};
	__property HAlign = {default=0};
	__property HideZeros = {default=0};
	__property Highlight;
	__property LineSpacing = {default=0};
	__property Memo;
	__property ParagraphGap = {default=0};
	__property ParentFont = {default=1};
	__property Processing;
	__property Rotation = {default=0};
	__property RTLReading = {default=0};
	__property Style = {default=0};
	__property SuppressRepeated = {default=0};
	__property Duplicates = {default=0};
	__property Underlines = {default=0};
	__property UnderlinesTextMode = {default=0};
	__property UseDefaultCharset = {default=0};
	__property WordBreak = {default=0};
	__property WordWrap = {default=1};
	__property Wysiwyg = {default=1};
	__property VAlign = {default=0};
public:
	/* TfrxCustomMemoView.Create */ inline __fastcall virtual TfrxMemoView(System::Classes::TComponent* AOwner) : TfrxCustomMemoView(AOwner) { }
	/* TfrxCustomMemoView.Destroy */ inline __fastcall virtual ~TfrxMemoView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxMemoView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomMemoView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxSysMemoView : public TfrxCustomMemoView
{
	typedef TfrxCustomMemoView inherited;
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property AutoWidth = {default=0};
	__property CharSpacing = {default=0};
	__property Color;
	__property DisplayFormat;
	__property Font;
	__property Frame;
	__property FillType = {default=0};
	__property Fill;
	__property GapX = {default=0};
	__property GapY = {default=0};
	__property HAlign = {default=0};
	__property HideZeros = {default=0};
	__property Highlight;
	__property Memo;
	__property ParentFont = {default=1};
	__property Rotation = {default=0};
	__property RTLReading = {default=0};
	__property Style = {default=0};
	__property SuppressRepeated = {default=0};
	__property Duplicates = {default=0};
	__property VAlign = {default=0};
	__property WordWrap = {default=1};
public:
	/* TfrxCustomMemoView.Create */ inline __fastcall virtual TfrxSysMemoView(System::Classes::TComponent* AOwner) : TfrxCustomMemoView(AOwner) { }
	/* TfrxCustomMemoView.Destroy */ inline __fastcall virtual ~TfrxSysMemoView() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxSysMemoView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomMemoView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxCustomLineView : public TfrxStretcheable
{
	typedef TfrxStretcheable inherited;
	
private:
	System::Uitypes::TColor FColor;
	bool FDiagonal;
	bool FArrowEnd;
	int FArrowLength;
	bool FArrowSolid;
	bool FArrowStart;
	int FArrowWidth;
	void __fastcall DrawArrow(System::Extended x1, System::Extended y1, System::Extended x2, System::Extended y2);
	void __fastcall DrawDiagonalLine();
	
public:
	__fastcall virtual TfrxCustomLineView(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxCustomLineView(System::Classes::TComponent* AOwner, System::Word Flags);
	virtual Vcl::Graphics::TGraphic* __fastcall GetVectorGraphic(bool DrawFill = false);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	virtual bool __fastcall IsInRect(const TfrxRect &aRect);
	__property bool ArrowEnd = {read=FArrowEnd, write=FArrowEnd, default=0};
	__property int ArrowLength = {read=FArrowLength, write=FArrowLength, default=20};
	__property bool ArrowSolid = {read=FArrowSolid, write=FArrowSolid, default=0};
	__property bool ArrowStart = {read=FArrowStart, write=FArrowStart, default=0};
	__property int ArrowWidth = {read=FArrowWidth, write=FArrowWidth, default=5};
	__property bool Diagonal = {read=FDiagonal, write=FDiagonal, default=0};
	
__published:
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, default=536870911};
	__property TagStr = {default=0};
public:
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxCustomLineView() { }
	
};


class PASCALIMPLEMENTATION TfrxLineView : public TfrxCustomLineView
{
	typedef TfrxCustomLineView inherited;
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property ArrowEnd = {default=0};
	__property ArrowLength = {default=20};
	__property ArrowSolid = {default=0};
	__property ArrowStart = {default=0};
	__property ArrowWidth = {default=5};
	__property Frame;
	__property Diagonal = {default=0};
public:
	/* TfrxCustomLineView.Create */ inline __fastcall virtual TfrxLineView(System::Classes::TComponent* AOwner) : TfrxCustomLineView(AOwner) { }
	/* TfrxCustomLineView.DesignCreate */ inline __fastcall virtual TfrxLineView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxCustomLineView(AOwner, Flags) { }
	
public:
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxLineView() { }
	
};


class PASCALIMPLEMENTATION TfrxPictureView : public TfrxView
{
	typedef TfrxView inherited;
	
private:
	bool FAutoSize;
	bool FCenter;
	System::UnicodeString FFileLink;
	int FImageIndex;
	bool FIsImageIndexStored;
	bool FIsPictureStored;
	bool FKeepAspectRatio;
	Vcl::Graphics::TPicture* FPicture;
	bool FPictureChanged;
	bool FStretched;
	bool FHightQuality;
	bool FTransparent;
	System::Uitypes::TColor FTransparentColor;
	void __fastcall SetPicture(Vcl::Graphics::TPicture* const Value);
	void __fastcall PictureChanged(System::TObject* Sender);
	void __fastcall SetAutoSize(const bool Value);
	void __fastcall SetTransparent(const bool Value);
	
public:
	__fastcall virtual TfrxPictureView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxPictureView();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual System::UnicodeString __fastcall Diff(TfrxComponent* AComponent);
	HRESULT __fastcall LoadPictureFromStream(System::Classes::TStream* s, bool ResetStreamPos = true);
	virtual bool __fastcall IsEMFExportable();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall GetData();
	__property bool IsImageIndexStored = {read=FIsImageIndexStored, write=FIsImageIndexStored, nodefault};
	__property bool IsPictureStored = {read=FIsPictureStored, write=FIsPictureStored, nodefault};
	
__published:
	__property Cursor = {default=0};
	__property bool AutoSize = {read=FAutoSize, write=SetAutoSize, default=0};
	__property bool Center = {read=FCenter, write=FCenter, default=0};
	__property DataField = {default=0};
	__property DataSet;
	__property DataSetName = {default=0};
	__property Frame;
	__property FillType = {default=0};
	__property Fill;
	__property System::UnicodeString FileLink = {read=FFileLink, write=FFileLink};
	__property int ImageIndex = {read=FImageIndex, write=FImageIndex, stored=FIsImageIndexStored, nodefault};
	__property bool KeepAspectRatio = {read=FKeepAspectRatio, write=FKeepAspectRatio, default=1};
	__property Vcl::Graphics::TPicture* Picture = {read=FPicture, write=SetPicture, stored=FIsPictureStored};
	__property bool Stretched = {read=FStretched, write=FStretched, default=1};
	__property TagStr = {default=0};
	__property URL = {default=0};
	__property bool HightQuality = {read=FHightQuality, write=FHightQuality, nodefault};
	__property bool Transparent = {read=FTransparent, write=SetTransparent, nodefault};
	__property System::Uitypes::TColor TransparentColor = {read=FTransparentColor, write=FTransparentColor, nodefault};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxPictureView(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxShapeView : public TfrxView
{
	typedef TfrxView inherited;
	
private:
	int FCurve;
	TfrxShapeKind FShape;
	
public:
	__fastcall virtual TfrxShapeView(System::Classes::TComponent* AOwner);
	__fastcall virtual TfrxShapeView(System::Classes::TComponent* AOwner, System::Word Flags);
	virtual System::UnicodeString __fastcall Diff(TfrxComponent* AComponent);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property Color;
	__property Cursor = {default=0};
	__property int Curve = {read=FCurve, write=FCurve, default=0};
	__property FillType = {default=0};
	__property Fill;
	__property Frame;
	__property TfrxShapeKind Shape = {read=FShape, write=FShape, default=0};
	__property TagStr = {default=0};
	__property URL = {default=0};
public:
	/* TfrxView.Destroy */ inline __fastcall virtual ~TfrxShapeView() { }
	
};


class PASCALIMPLEMENTATION TfrxSubreport : public TfrxView
{
	typedef TfrxView inherited;
	
private:
	TfrxReportPage* FPage;
	bool FPrintOnParent;
	void __fastcall SetPage(TfrxReportPage* const Value);
	
public:
	__fastcall virtual TfrxSubreport(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxSubreport();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property TfrxReportPage* Page = {read=FPage, write=SetPage};
	__property bool PrintOnParent = {read=FPrintOnParent, write=FPrintOnParent, default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxSubreport(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxView(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxBand : public TfrxReportComponent
{
	typedef TfrxReportComponent inherited;
	
private:
	bool FAllowSplit;
	TfrxChild* FChild;
	bool FKeepChild;
	TfrxNotifyEvent FOnAfterCalcHeight;
	System::UnicodeString FOutlineText;
	bool FOverflow;
	bool FStartNewPage;
	bool FStretched;
	bool FPrintChildIfInvisible;
	bool FVertical;
	TfrxCustomFill* FFill;
	TfrxFillType FFillType;
	TfrxMemoView* FFillMemo;
	TfrxFillGaps* FFillgap;
	TfrxFrame* FFrame;
	System::Extended FBandDesignHeader;
	TfrxShiftEngine FShiftEngine;
	System::UnicodeString __fastcall GetBandName();
	void __fastcall SetChild(TfrxChild* Value);
	void __fastcall SetVertical(const bool Value);
	void __fastcall SetFill(TfrxCustomFill* const Value);
	void __fastcall SetFillType(const TfrxFillType Value);
	void __fastcall SetFrame(TfrxFrame* const Value);
	
protected:
	virtual System::Uitypes::TColor __fastcall GetBandTitleColor();
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual void __fastcall SetTop(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	
public:
	System::Classes::TList* FSubBands;
	TfrxBand* FHeader;
	TfrxBand* FFooter;
	TfrxBand* FGroup;
	int FLineN;
	int FLineThrough;
	bool FHasVBands;
	System::Extended FStretchedHeight;
	__fastcall virtual TfrxBand(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxBand();
	int __fastcall BandNumber();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	void __fastcall CreateFillMemo();
	void __fastcall DisposeFillMemo();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	virtual TfrxComponent* __fastcall GetContainedComponent(System::Extended X, System::Extended Y, TfrxComponent* IsCanContain = (TfrxComponent*)(0x0));
	__property bool AllowSplit = {read=FAllowSplit, write=FAllowSplit, default=0};
	__property System::UnicodeString BandName = {read=GetBandName};
	__property System::Extended BandDesignHeader = {read=FBandDesignHeader, write=FBandDesignHeader};
	__property TfrxChild* Child = {read=FChild, write=SetChild};
	__property bool KeepChild = {read=FKeepChild, write=FKeepChild, default=0};
	__property System::UnicodeString OutlineText = {read=FOutlineText, write=FOutlineText};
	__property bool Overflow = {read=FOverflow, write=FOverflow, nodefault};
	__property bool PrintChildIfInvisible = {read=FPrintChildIfInvisible, write=FPrintChildIfInvisible, default=0};
	__property bool StartNewPage = {read=FStartNewPage, write=FStartNewPage, default=0};
	__property bool Stretched = {read=FStretched, write=FStretched, default=0};
	__property TfrxShiftEngine ShiftEngine = {read=FShiftEngine, write=FShiftEngine, default=1};
	
__published:
	__property TfrxFillType FillType = {read=FFillType, write=SetFillType, nodefault};
	__property TfrxCustomFill* Fill = {read=FFill, write=SetFill};
	__property TfrxFillGaps* FillGap = {read=FFillgap};
	__property TfrxFrame* Frame = {read=FFrame, write=SetFrame};
	__property Font;
	__property Height = {default=0};
	__property Left = {default=0};
	__property ParentFont = {default=1};
	__property Restrictions = {default=0};
	__property Top = {default=0};
	__property bool Vertical = {read=FVertical, write=SetVertical, default=0};
	__property Visible = {default=1};
	__property Width = {default=0};
	__property TfrxNotifyEvent OnAfterCalcHeight = {read=FOnAfterCalcHeight, write=FOnAfterCalcHeight};
	__property OnAfterPrint = {default=0};
	__property OnBeforePrint = {default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxBand(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxReportComponent(AOwner, Flags) { }
	
};


typedef System::TMetaClass* TfrxBandClass;

enum DECLSPEC_DENUM TfrxToNRowsMode : unsigned char { rmCount, rmAddToCount, rmTillPageEnds };

class PASCALIMPLEMENTATION TfrxDataBand : public TfrxBand
{
	typedef TfrxBand inherited;
	
private:
	System::Extended FColumnGap;
	System::Extended FColumnWidth;
	int FColumns;
	int FCurColumn;
	TfrxDataSet* FDataSet;
	System::UnicodeString FDataSetName;
	System::UnicodeString FFilter;
	bool FFooterAfterEach;
	bool FKeepFooter;
	bool FKeepHeader;
	bool FKeepTogether;
	bool FPrintIfDetailEmpty;
	int FRowCount;
	TfrxNotifyEvent FOnMasterDetail;
	TfrxUserDataSet* FVirtualDataSet;
	void __fastcall SetCurColumn(int Value);
	void __fastcall SetRowCount(const int Value);
	void __fastcall SetDataSet(TfrxDataSet* const Value);
	void __fastcall SetDataSetName(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDataSetName();
	
protected:
	virtual System::Uitypes::TColor __fastcall GetBandTitleColor();
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	System::Extended FMaxY;
	__fastcall virtual TfrxDataBand(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDataBand();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property int CurColumn = {read=FCurColumn, write=SetCurColumn, nodefault};
	__property TfrxUserDataSet* VirtualDataSet = {read=FVirtualDataSet};
	
__published:
	__property AllowSplit = {default=0};
	__property Child;
	__property int Columns = {read=FColumns, write=FColumns, default=0};
	__property System::Extended ColumnWidth = {read=FColumnWidth, write=FColumnWidth};
	__property System::Extended ColumnGap = {read=FColumnGap, write=FColumnGap};
	__property TfrxDataSet* DataSet = {read=FDataSet, write=SetDataSet};
	__property System::UnicodeString DataSetName = {read=GetDataSetName, write=SetDataSetName};
	__property bool FooterAfterEach = {read=FFooterAfterEach, write=FFooterAfterEach, default=0};
	__property System::UnicodeString Filter = {read=FFilter, write=FFilter};
	__property KeepChild = {default=0};
	__property bool KeepFooter = {read=FKeepFooter, write=FKeepFooter, default=0};
	__property bool KeepHeader = {read=FKeepHeader, write=FKeepHeader, default=0};
	__property bool KeepTogether = {read=FKeepTogether, write=FKeepTogether, default=0};
	__property OutlineText = {default=0};
	__property PrintChildIfInvisible = {default=0};
	__property bool PrintIfDetailEmpty = {read=FPrintIfDetailEmpty, write=FPrintIfDetailEmpty, default=0};
	__property int RowCount = {read=FRowCount, write=SetRowCount, nodefault};
	__property StartNewPage = {default=0};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
	__property TfrxNotifyEvent OnMasterDetail = {read=FOnMasterDetail, write=FOnMasterDetail};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDataBand(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxHeader : public TfrxBand
{
	typedef TfrxBand inherited;
	
private:
	bool FReprintOnNewPage;
	
__published:
	__property AllowSplit = {default=0};
	__property Child;
	__property KeepChild = {default=0};
	__property PrintChildIfInvisible = {default=0};
	__property bool ReprintOnNewPage = {read=FReprintOnNewPage, write=FReprintOnNewPage, default=0};
	__property StartNewPage = {default=0};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxHeader(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxHeader() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxHeader(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxFooter : public TfrxBand
{
	typedef TfrxBand inherited;
	
__published:
	__property AllowSplit = {default=0};
	__property Child;
	__property KeepChild = {default=0};
	__property PrintChildIfInvisible = {default=0};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxFooter(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxFooter() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxFooter(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxMasterData : public TfrxDataBand
{
	typedef TfrxDataBand inherited;
	
public:
	/* TfrxDataBand.Create */ inline __fastcall virtual TfrxMasterData(System::Classes::TComponent* AOwner) : TfrxDataBand(AOwner) { }
	/* TfrxDataBand.Destroy */ inline __fastcall virtual ~TfrxMasterData() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxMasterData(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDataBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDetailData : public TfrxDataBand
{
	typedef TfrxDataBand inherited;
	
public:
	/* TfrxDataBand.Create */ inline __fastcall virtual TfrxDetailData(System::Classes::TComponent* AOwner) : TfrxDataBand(AOwner) { }
	/* TfrxDataBand.Destroy */ inline __fastcall virtual ~TfrxDetailData() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDetailData(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDataBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxSubdetailData : public TfrxDataBand
{
	typedef TfrxDataBand inherited;
	
public:
	/* TfrxDataBand.Create */ inline __fastcall virtual TfrxSubdetailData(System::Classes::TComponent* AOwner) : TfrxDataBand(AOwner) { }
	/* TfrxDataBand.Destroy */ inline __fastcall virtual ~TfrxSubdetailData() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxSubdetailData(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDataBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDataBand4 : public TfrxDataBand
{
	typedef TfrxDataBand inherited;
	
public:
	/* TfrxDataBand.Create */ inline __fastcall virtual TfrxDataBand4(System::Classes::TComponent* AOwner) : TfrxDataBand(AOwner) { }
	/* TfrxDataBand.Destroy */ inline __fastcall virtual ~TfrxDataBand4() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDataBand4(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDataBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDataBand5 : public TfrxDataBand
{
	typedef TfrxDataBand inherited;
	
public:
	/* TfrxDataBand.Create */ inline __fastcall virtual TfrxDataBand5(System::Classes::TComponent* AOwner) : TfrxDataBand(AOwner) { }
	/* TfrxDataBand.Destroy */ inline __fastcall virtual ~TfrxDataBand5() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDataBand5(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDataBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDataBand6 : public TfrxDataBand
{
	typedef TfrxDataBand inherited;
	
public:
	/* TfrxDataBand.Create */ inline __fastcall virtual TfrxDataBand6(System::Classes::TComponent* AOwner) : TfrxDataBand(AOwner) { }
	/* TfrxDataBand.Destroy */ inline __fastcall virtual ~TfrxDataBand6() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDataBand6(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxDataBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxPageHeader : public TfrxBand
{
	typedef TfrxBand inherited;
	
private:
	bool FPrintOnFirstPage;
	
public:
	__fastcall virtual TfrxPageHeader(System::Classes::TComponent* AOwner);
	
__published:
	__property Child;
	__property PrintChildIfInvisible = {default=0};
	__property bool PrintOnFirstPage = {read=FPrintOnFirstPage, write=FPrintOnFirstPage, default=1};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
public:
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxPageHeader() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxPageHeader(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxPageFooter : public TfrxBand
{
	typedef TfrxBand inherited;
	
private:
	bool FPrintOnFirstPage;
	bool FPrintOnLastPage;
	
public:
	__fastcall virtual TfrxPageFooter(System::Classes::TComponent* AOwner);
	
__published:
	__property bool PrintOnFirstPage = {read=FPrintOnFirstPage, write=FPrintOnFirstPage, default=1};
	__property bool PrintOnLastPage = {read=FPrintOnLastPage, write=FPrintOnLastPage, default=1};
public:
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxPageFooter() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxPageFooter(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxColumnHeader : public TfrxBand
{
	typedef TfrxBand inherited;
	
__published:
	__property Child;
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxColumnHeader(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxColumnHeader() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxColumnHeader(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxColumnFooter : public TfrxBand
{
	typedef TfrxBand inherited;
	
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxColumnFooter(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxColumnFooter() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxColumnFooter(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxGroupHeader : public TfrxBand
{
	typedef TfrxBand inherited;
	
private:
	System::UnicodeString FCondition;
	System::UnicodeString FDrillName;
	bool FDrillDown;
	bool FExpandDrillDown;
	bool FShowFooterIfDrillDown;
	bool FShowChildIfDrillDown;
	bool FKeepTogether;
	bool FReprintOnNewPage;
	bool FResetPageNumbers;
	
public:
	System::Variant FLastValue;
	virtual System::UnicodeString __fastcall Diff(TfrxComponent* AComponent);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	
__published:
	__property AllowSplit = {default=0};
	__property Child;
	__property System::UnicodeString Condition = {read=FCondition, write=FCondition};
	__property bool DrillDown = {read=FDrillDown, write=FDrillDown, default=0};
	__property bool ExpandDrillDown = {read=FExpandDrillDown, write=FExpandDrillDown, default=0};
	__property KeepChild = {default=0};
	__property bool KeepTogether = {read=FKeepTogether, write=FKeepTogether, default=0};
	__property bool ReprintOnNewPage = {read=FReprintOnNewPage, write=FReprintOnNewPage, default=0};
	__property OutlineText = {default=0};
	__property PrintChildIfInvisible = {default=0};
	__property bool ResetPageNumbers = {read=FResetPageNumbers, write=FResetPageNumbers, default=0};
	__property bool ShowFooterIfDrillDown = {read=FShowFooterIfDrillDown, write=FShowFooterIfDrillDown, default=0};
	__property bool ShowChildIfDrillDown = {read=FShowChildIfDrillDown, write=FShowChildIfDrillDown, default=0};
	__property StartNewPage = {default=0};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
	__property System::UnicodeString DrillName = {read=FDrillName, write=FDrillName};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxGroupHeader(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxGroupHeader() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxGroupHeader(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxGroupFooter : public TfrxBand
{
	typedef TfrxBand inherited;
	
private:
	bool FHideIfSingleDataRecord;
	
__published:
	__property AllowSplit = {default=0};
	__property Child;
	__property bool HideIfSingleDataRecord = {read=FHideIfSingleDataRecord, write=FHideIfSingleDataRecord, default=0};
	__property KeepChild = {default=0};
	__property PrintChildIfInvisible = {default=0};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxGroupFooter(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxGroupFooter() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxGroupFooter(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxReportTitle : public TfrxBand
{
	typedef TfrxBand inherited;
	
__published:
	__property AllowSplit = {default=0};
	__property Child;
	__property KeepChild = {default=0};
	__property PrintChildIfInvisible = {default=0};
	__property StartNewPage = {default=0};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxReportTitle(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxReportTitle() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxReportTitle(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxReportSummary : public TfrxBand
{
	typedef TfrxBand inherited;
	
__published:
	__property AllowSplit = {default=0};
	__property Child;
	__property KeepChild = {default=0};
	__property PrintChildIfInvisible = {default=0};
	__property StartNewPage = {default=0};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxReportSummary(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxReportSummary() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxReportSummary(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxChild : public TfrxBand
{
	typedef TfrxBand inherited;
	
private:
	int FToNRows;
	TfrxToNRowsMode FToNRowsMode;
	
__published:
	__property AllowSplit = {default=0};
	__property Child;
	__property KeepChild = {default=0};
	__property PrintChildIfInvisible = {default=0};
	__property StartNewPage = {default=0};
	__property Stretched = {default=0};
	__property ShiftEngine = {default=1};
	__property int ToNRows = {read=FToNRows, write=FToNRows, nodefault};
	__property TfrxToNRowsMode ToNRowsMode = {read=FToNRowsMode, write=FToNRowsMode, nodefault};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxChild(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxChild() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxChild(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxOverlay : public TfrxBand
{
	typedef TfrxBand inherited;
	
private:
	bool FPrintOnTop;
	
__published:
	__property bool PrintOnTop = {read=FPrintOnTop, write=FPrintOnTop, default=0};
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxOverlay(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxOverlay() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxOverlay(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxNullBand : public TfrxBand
{
	typedef TfrxBand inherited;
	
public:
	/* TfrxBand.Create */ inline __fastcall virtual TfrxNullBand(System::Classes::TComponent* AOwner) : TfrxBand(AOwner) { }
	/* TfrxBand.Destroy */ inline __fastcall virtual ~TfrxNullBand() { }
	
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxNullBand(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxBand(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxPage : public TfrxComponent
{
	typedef TfrxComponent inherited;
	
public:
	__fastcall virtual TfrxPage(System::Classes::TComponent* AOwner);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	
__published:
	__property Font;
	__property Visible = {default=1};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxPage(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxComponent(AOwner, Flags) { }
	/* TfrxComponent.Destroy */ inline __fastcall virtual ~TfrxPage() { }
	
};


class PASCALIMPLEMENTATION TfrxReportPage : public TfrxPage
{
	typedef TfrxPage inherited;
	
private:
	TfrxPictureView* FBackPicture;
	int FBin;
	int FBinOtherPages;
	System::Extended FBottomMargin;
	int FColumns;
	System::Extended FColumnWidth;
	System::Classes::TStrings* FColumnPositions;
	TfrxDataSet* FDataSet;
	TfrxDuplexMode FDuplex;
	bool FEndlessHeight;
	bool FEndlessWidth;
	System::Classes::TStrings* FHGuides;
	bool FLargeDesignHeight;
	System::Extended FLeftMargin;
	bool FMirrorMargins;
	System::Uitypes::TPrinterOrientation FOrientation;
	System::UnicodeString FOutlineText;
	bool FPrintIfEmpty;
	bool FPrintOnPreviousPage;
	bool FResetPageNumbers;
	System::Extended FRightMargin;
	TfrxSubreport* FSubReport;
	bool FTitleBeforeHeader;
	System::Extended FTopMargin;
	System::Classes::TStrings* FVGuides;
	TfrxNotifyEvent FOnAfterPrint;
	TfrxNotifyEvent FOnBeforePrint;
	TfrxNotifyEvent FOnManualBuild;
	System::UnicodeString FDataSetName;
	bool FBackPictureVisible;
	bool FBackPicturePrintable;
	bool FBackPictureStretched;
	int FPageCount;
	bool FShowTitleOnPreviousPage;
	TfrxReport* FReport;
	TfrxMirrorControlModes FMirrorMode;
	void __fastcall SetPageCount(const int Value);
	void __fastcall SetColumns(const int Value);
	void __fastcall SetOrientation(System::Uitypes::TPrinterOrientation Value);
	void __fastcall SetHGuides(System::Classes::TStrings* const Value);
	void __fastcall SetVGuides(System::Classes::TStrings* const Value);
	void __fastcall SetColumnPositions(System::Classes::TStrings* const Value);
	void __fastcall SetFrame(TfrxFrame* const Value);
	TfrxFrame* __fastcall GetFrame();
	System::Uitypes::TColor __fastcall GetColor();
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	Vcl::Graphics::TPicture* __fastcall GetBackPicture();
	void __fastcall SetBackPicture(Vcl::Graphics::TPicture* const Value);
	void __fastcall SetDataSet(TfrxDataSet* const Value);
	void __fastcall SetDataSetName(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDataSetName();
	
protected:
	System::Extended FPaperHeight;
	int FPaperSize;
	System::Extended FPaperWidth;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetPaperHeight(const System::Extended Value);
	virtual void __fastcall SetPaperWidth(const System::Extended Value);
	virtual void __fastcall SetPaperSize(const int Value);
	void __fastcall UpdateDimensions();
	
public:
	System::Classes::TList* FSubBands;
	System::Classes::TList* FVSubBands;
	__fastcall virtual TfrxReportPage(System::Classes::TComponent* AOwner)/* overload */;
	__fastcall TfrxReportPage(System::Classes::TComponent* AOwner, TfrxReport* AReport)/* overload */;
	__fastcall virtual ~TfrxReportPage();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	TfrxBand* __fastcall FindBand(TfrxBandClass Band);
	bool __fastcall IsSubReport();
	virtual void __fastcall AlignChildren(bool IgnoreInvisible = false, TfrxMirrorControlModes MirrorModes = TfrxMirrorControlModes() );
	void __fastcall ClearGuides();
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY);
	virtual void __fastcall SetDefaults();
	void __fastcall SetSizeAndDimensions(int ASize, System::Extended AWidth, System::Extended AHeight);
	__property TfrxSubreport* SubReport = {read=FSubReport};
	__property TfrxReport* ParentReport = {read=FReport};
	
__published:
	__property System::Uitypes::TPrinterOrientation Orientation = {read=FOrientation, write=SetOrientation, default=0};
	__property System::Extended PaperWidth = {read=FPaperWidth, write=SetPaperWidth};
	__property System::Extended PaperHeight = {read=FPaperHeight, write=SetPaperHeight};
	__property int PaperSize = {read=FPaperSize, write=SetPaperSize, nodefault};
	__property System::Extended LeftMargin = {read=FLeftMargin, write=FLeftMargin};
	__property System::Extended RightMargin = {read=FRightMargin, write=FRightMargin};
	__property System::Extended TopMargin = {read=FTopMargin, write=FTopMargin};
	__property System::Extended BottomMargin = {read=FBottomMargin, write=FBottomMargin};
	__property bool MirrorMargins = {read=FMirrorMargins, write=FMirrorMargins, default=0};
	__property int Columns = {read=FColumns, write=SetColumns, default=0};
	__property System::Extended ColumnWidth = {read=FColumnWidth, write=FColumnWidth};
	__property System::Classes::TStrings* ColumnPositions = {read=FColumnPositions, write=SetColumnPositions};
	__property int Bin = {read=FBin, write=FBin, default=7};
	__property int BinOtherPages = {read=FBinOtherPages, write=FBinOtherPages, default=7};
	__property Vcl::Graphics::TPicture* BackPicture = {read=GetBackPicture, write=SetBackPicture};
	__property bool BackPictureVisible = {read=FBackPictureVisible, write=FBackPictureVisible, default=1};
	__property bool BackPicturePrintable = {read=FBackPicturePrintable, write=FBackPicturePrintable, default=1};
	__property bool BackPictureStretched = {read=FBackPictureStretched, write=FBackPictureStretched, default=1};
	__property int PageCount = {read=FPageCount, write=SetPageCount, default=1};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, default=536870911};
	__property TfrxDataSet* DataSet = {read=FDataSet, write=SetDataSet};
	__property System::UnicodeString DataSetName = {read=GetDataSetName, write=SetDataSetName};
	__property TfrxDuplexMode Duplex = {read=FDuplex, write=FDuplex, default=0};
	__property TfrxFrame* Frame = {read=GetFrame, write=SetFrame};
	__property bool EndlessHeight = {read=FEndlessHeight, write=FEndlessHeight, default=0};
	__property bool EndlessWidth = {read=FEndlessWidth, write=FEndlessWidth, default=0};
	__property bool LargeDesignHeight = {read=FLargeDesignHeight, write=FLargeDesignHeight, default=0};
	__property TfrxMirrorControlModes MirrorMode = {read=FMirrorMode, write=FMirrorMode, nodefault};
	__property System::UnicodeString OutlineText = {read=FOutlineText, write=FOutlineText};
	__property bool PrintIfEmpty = {read=FPrintIfEmpty, write=FPrintIfEmpty, default=1};
	__property bool PrintOnPreviousPage = {read=FPrintOnPreviousPage, write=FPrintOnPreviousPage, default=0};
	__property bool ShowTitleOnPreviousPage = {read=FShowTitleOnPreviousPage, write=FShowTitleOnPreviousPage, default=1};
	__property bool ResetPageNumbers = {read=FResetPageNumbers, write=FResetPageNumbers, default=0};
	__property bool TitleBeforeHeader = {read=FTitleBeforeHeader, write=FTitleBeforeHeader, default=1};
	__property System::Classes::TStrings* HGuides = {read=FHGuides, write=SetHGuides};
	__property System::Classes::TStrings* VGuides = {read=FVGuides, write=SetVGuides};
	__property TfrxNotifyEvent OnAfterPrint = {read=FOnAfterPrint, write=FOnAfterPrint};
	__property TfrxNotifyEvent OnBeforePrint = {read=FOnBeforePrint, write=FOnBeforePrint};
	__property TfrxNotifyEvent OnManualBuild = {read=FOnManualBuild, write=FOnManualBuild};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxReportPage(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxPage(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDialogPage : public TfrxPage
{
	typedef TfrxPage inherited;
	
private:
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	System::UnicodeString FCaption;
	System::Uitypes::TColor FColor;
	Vcl::Forms::TForm* FForm;
	TfrxNotifyEvent FOnActivate;
	TfrxNotifyEvent FOnClick;
	TfrxNotifyEvent FOnDeactivate;
	TfrxNotifyEvent FOnHide;
	TfrxKeyEvent FOnKeyDown;
	TfrxKeyPressEvent FOnKeyPress;
	TfrxKeyEvent FOnKeyUp;
	TfrxNotifyEvent FOnResize;
	TfrxNotifyEvent FOnShow;
	TfrxCloseQueryEvent FOnCloseQuery;
	Vcl::Forms::TPosition FPosition;
	System::Uitypes::TWindowState FWindowState;
	System::Extended FClientWidth;
	System::Extended FClientHeight;
	void __fastcall DoInitialize();
	void __fastcall DoOnActivate(System::TObject* Sender);
	void __fastcall DoOnClick(System::TObject* Sender);
	void __fastcall DoOnCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall DoOnDeactivate(System::TObject* Sender);
	void __fastcall DoOnHide(System::TObject* Sender);
	void __fastcall DoOnKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall DoOnKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall DoOnKeyUp(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall DoOnShow(System::TObject* Sender);
	void __fastcall DoOnResize(System::TObject* Sender);
	void __fastcall DoModify(System::TObject* Sender);
	void __fastcall DoOnMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall SetBorderStyle(const Vcl::Forms::TFormBorderStyle Value);
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	System::Uitypes::TModalResult __fastcall GetModalResult();
	void __fastcall SetModalResult(const System::Uitypes::TModalResult Value);
	bool __fastcall GetDoubleBuffered();
	void __fastcall SetDoubleBuffered(const bool Value);
	
protected:
	virtual void __fastcall SetLeft(System::Extended Value);
	virtual void __fastcall SetTop(System::Extended Value);
	virtual void __fastcall SetWidth(System::Extended Value);
	virtual void __fastcall SetHeight(System::Extended Value);
	void __fastcall SetClientWidth(System::Extended Value);
	void __fastcall SetClientHeight(System::Extended Value);
	void __fastcall SetScaled(bool Value);
	bool __fastcall GetScaled();
	System::Extended __fastcall GetClientWidth();
	System::Extended __fastcall GetClientHeight();
	virtual void __fastcall FontChanged(System::TObject* Sender);
	
public:
	__fastcall virtual TfrxDialogPage(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxDialogPage();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	void __fastcall Initialize();
	virtual bool __fastcall IsContain(System::Extended X, System::Extended Y);
	System::Uitypes::TModalResult __fastcall ShowModal();
	__property Vcl::Forms::TForm* DialogForm = {read=FForm};
	__property System::Uitypes::TModalResult ModalResult = {read=GetModalResult, write=SetModalResult, nodefault};
	
__published:
	__property Vcl::Forms::TFormBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=2};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, default=-16777201};
	__property bool DoubleBuffered = {read=GetDoubleBuffered, write=SetDoubleBuffered, nodefault};
	__property Height = {default=0};
	__property System::Extended ClientHeight = {read=GetClientHeight, write=SetClientHeight};
	__property Left = {default=0};
	__property Vcl::Forms::TPosition Position = {read=FPosition, write=FPosition, default=4};
	__property Top = {default=0};
	__property Width = {default=0};
	__property bool Scaled = {read=GetScaled, write=SetScaled, nodefault};
	__property System::Extended ClientWidth = {read=GetClientWidth, write=SetClientWidth};
	__property System::Uitypes::TWindowState WindowState = {read=FWindowState, write=FWindowState, default=0};
	__property TfrxNotifyEvent OnActivate = {read=FOnActivate, write=FOnActivate};
	__property TfrxNotifyEvent OnClick = {read=FOnClick, write=FOnClick};
	__property TfrxCloseQueryEvent OnCloseQuery = {read=FOnCloseQuery, write=FOnCloseQuery};
	__property TfrxNotifyEvent OnDeactivate = {read=FOnDeactivate, write=FOnDeactivate};
	__property TfrxNotifyEvent OnHide = {read=FOnHide, write=FOnHide};
	__property TfrxKeyEvent OnKeyDown = {read=FOnKeyDown, write=FOnKeyDown};
	__property TfrxKeyPressEvent OnKeyPress = {read=FOnKeyPress, write=FOnKeyPress};
	__property TfrxKeyEvent OnKeyUp = {read=FOnKeyUp, write=FOnKeyUp};
	__property TfrxNotifyEvent OnShow = {read=FOnShow, write=FOnShow};
	__property TfrxNotifyEvent OnResize = {read=FOnResize, write=FOnResize};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDialogPage(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxPage(AOwner, Flags) { }
	
};


class PASCALIMPLEMENTATION TfrxDataPage : public TfrxPage
{
	typedef TfrxPage inherited;
	
public:
	__fastcall virtual TfrxDataPage(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	
__published:
	__property Height = {default=0};
	__property Left = {default=0};
	__property Top = {default=0};
	__property Width = {default=0};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxDataPage(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxPage(AOwner, Flags) { }
	/* TfrxComponent.Destroy */ inline __fastcall virtual ~TfrxDataPage() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxEngineOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FConvertNulls;
	bool FDestroyForms;
	bool FDoublePass;
	int FMaxMemSize;
	bool FPrintIfEmpty;
	System::Classes::TThread* FReportThread;
	bool FEnableThreadSafe;
	TfrxSilentMode FSilentMode;
	System::UnicodeString FTempDir;
	bool FUseFileCache;
	bool FUseGlobalDataSetList;
	bool FIgnoreDevByZero;
	void __fastcall SetSilentMode(bool Mode);
	bool __fastcall GetSilentMode();
	
public:
	__fastcall TfrxEngineOptions();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall AssignThreadProps(System::Classes::TPersistent* Source);
	void __fastcall Clear();
	__property System::Classes::TThread* ReportThread = {read=FReportThread, write=FReportThread};
	__property bool DestroyForms = {read=FDestroyForms, write=FDestroyForms, nodefault};
	__property bool EnableThreadSafe = {read=FEnableThreadSafe, write=FEnableThreadSafe, nodefault};
	__property bool UseGlobalDataSetList = {read=FUseGlobalDataSetList, write=FUseGlobalDataSetList, nodefault};
	
__published:
	__property bool ConvertNulls = {read=FConvertNulls, write=FConvertNulls, default=1};
	__property bool DoublePass = {read=FDoublePass, write=FDoublePass, default=0};
	__property int MaxMemSize = {read=FMaxMemSize, write=FMaxMemSize, default=10};
	__property bool PrintIfEmpty = {read=FPrintIfEmpty, write=FPrintIfEmpty, default=1};
	__property bool SilentMode = {read=GetSilentMode, write=SetSilentMode, default=0};
	__property TfrxSilentMode NewSilentMode = {read=FSilentMode, write=FSilentMode, default=0};
	__property System::UnicodeString TempDir = {read=FTempDir, write=FTempDir};
	__property bool UseFileCache = {read=FUseFileCache, write=FUseFileCache, default=0};
	__property bool IgnoreDevByZero = {read=FIgnoreDevByZero, write=FIgnoreDevByZero, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxEngineOptions() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPrintOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FCopies;
	bool FCollate;
	System::UnicodeString FPageNumbers;
	int FPagesOnSheet;
	System::UnicodeString FPrinter;
	TfrxPrintMode FPrintMode;
	int FPrintOnSheet;
	TfrxPrintPages FPrintPages;
	bool FReverse;
	bool FShowDialog;
	bool FSwapPageSize;
	System::UnicodeString FPrnOutFileName;
	TfrxDuplexMode FDuplex;
	int FSplicingLine;
	
public:
	__fastcall TfrxPrintOptions();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall Clear();
	__property System::UnicodeString PrnOutFileName = {read=FPrnOutFileName, write=FPrnOutFileName};
	__property TfrxDuplexMode Duplex = {read=FDuplex, write=FDuplex, nodefault};
	__property int SplicingLine = {read=FSplicingLine, write=FSplicingLine, default=3};
	
__published:
	__property int Copies = {read=FCopies, write=FCopies, default=1};
	__property bool Collate = {read=FCollate, write=FCollate, default=1};
	__property System::UnicodeString PageNumbers = {read=FPageNumbers, write=FPageNumbers};
	__property System::UnicodeString Printer = {read=FPrinter, write=FPrinter};
	__property TfrxPrintMode PrintMode = {read=FPrintMode, write=FPrintMode, default=0};
	__property int PrintOnSheet = {read=FPrintOnSheet, write=FPrintOnSheet, nodefault};
	__property TfrxPrintPages PrintPages = {read=FPrintPages, write=FPrintPages, default=0};
	__property bool Reverse = {read=FReverse, write=FReverse, default=0};
	__property bool ShowDialog = {read=FShowDialog, write=FShowDialog, default=1};
	__property bool SwapPageSize = {read=FSwapPageSize, write=FSwapPageSize, stored=false, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxPrintOptions() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxPreviewOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FAllowEdit;
	bool FAllowPreviewEdit;
	TfrxPreviewButtons FButtons;
	bool FDoubleBuffered;
	bool FMaximized;
	bool FMDIChild;
	bool FModal;
	bool FOutlineExpand;
	bool FOutlineVisible;
	int FOutlineWidth;
	int FPagesInCache;
	bool FShowCaptions;
	bool FThumbnailVisible;
	System::Extended FZoom;
	TfrxZoomMode FZoomMode;
	bool FPictureCacheInFile;
	bool FRTLPreview;
	
public:
	__fastcall TfrxPreviewOptions();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall Clear();
	__property bool RTLPreview = {read=FRTLPreview, write=FRTLPreview, nodefault};
	
__published:
	__property bool AllowEdit = {read=FAllowEdit, write=FAllowEdit, default=1};
	__property bool AllowPreviewEdit = {read=FAllowPreviewEdit, write=FAllowPreviewEdit, default=1};
	__property TfrxPreviewButtons Buttons = {read=FButtons, write=FButtons, nodefault};
	__property bool DoubleBuffered = {read=FDoubleBuffered, write=FDoubleBuffered, default=1};
	__property bool Maximized = {read=FMaximized, write=FMaximized, default=1};
	__property bool MDIChild = {read=FMDIChild, write=FMDIChild, default=0};
	__property bool Modal = {read=FModal, write=FModal, default=1};
	__property bool OutlineExpand = {read=FOutlineExpand, write=FOutlineExpand, default=1};
	__property bool OutlineVisible = {read=FOutlineVisible, write=FOutlineVisible, default=0};
	__property int OutlineWidth = {read=FOutlineWidth, write=FOutlineWidth, default=120};
	__property int PagesInCache = {read=FPagesInCache, write=FPagesInCache, default=50};
	__property bool ThumbnailVisible = {read=FThumbnailVisible, write=FThumbnailVisible, default=0};
	__property bool ShowCaptions = {read=FShowCaptions, write=FShowCaptions, default=0};
	__property System::Extended Zoom = {read=FZoom, write=FZoom};
	__property TfrxZoomMode ZoomMode = {read=FZoomMode, write=FZoomMode, default=0};
	__property bool PictureCacheInFile = {read=FPictureCacheInFile, write=FPictureCacheInFile, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxPreviewOptions() { }
	
};


class PASCALIMPLEMENTATION TfrxReportOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FAuthor;
	bool FCompressed;
	System::UnicodeString FConnectionName;
	System::TDateTime FCreateDate;
	System::Classes::TStrings* FDescription;
	System::UnicodeString FInitString;
	System::UnicodeString FName;
	System::TDateTime FLastChange;
	System::UnicodeString FPassword;
	Vcl::Graphics::TPicture* FPicture;
	TfrxReport* FReport;
	System::UnicodeString FVersionBuild;
	System::UnicodeString FVersionMajor;
	System::UnicodeString FVersionMinor;
	System::UnicodeString FVersionRelease;
	System::UnicodeString FPrevPassword;
	System::UnicodeString FHiddenPassword;
	bool FInfo;
	void __fastcall SetDescription(System::Classes::TStrings* const Value);
	void __fastcall SetPicture(Vcl::Graphics::TPicture* const Value);
	void __fastcall SetConnectionName(const System::UnicodeString Value);
	
public:
	__fastcall TfrxReportOptions(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxReportOptions();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall Clear();
	bool __fastcall CheckPassword();
	__property System::UnicodeString PrevPassword = {write=FPrevPassword};
	__property bool Info = {read=FInfo, write=FInfo, nodefault};
	__property System::UnicodeString HiddenPassword = {read=FHiddenPassword, write=FHiddenPassword};
	
__published:
	__property System::UnicodeString Author = {read=FAuthor, write=FAuthor};
	__property bool Compressed = {read=FCompressed, write=FCompressed, default=0};
	__property System::UnicodeString ConnectionName = {read=FConnectionName, write=SetConnectionName};
	__property System::TDateTime CreateDate = {read=FCreateDate, write=FCreateDate};
	__property System::Classes::TStrings* Description = {read=FDescription, write=SetDescription};
	__property System::UnicodeString InitString = {read=FInitString, write=FInitString};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property System::TDateTime LastChange = {read=FLastChange, write=FLastChange};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__property Vcl::Graphics::TPicture* Picture = {read=FPicture, write=SetPicture};
	__property System::UnicodeString VersionBuild = {read=FVersionBuild, write=FVersionBuild};
	__property System::UnicodeString VersionMajor = {read=FVersionMajor, write=FVersionMajor};
	__property System::UnicodeString VersionMinor = {read=FVersionMinor, write=FVersionMinor};
	__property System::UnicodeString VersionRelease = {read=FVersionRelease, write=FVersionRelease};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxExpressionCache : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TStringList* FExpressions;
	Fs_iinterpreter::TfsScript* FMainScript;
	Fs_iinterpreter::TfsScript* FScript;
	System::UnicodeString FScriptLanguage;
	void __fastcall SetCaseSensitive(const bool Value);
	bool __fastcall GetCaseSensitive();
	
public:
	__fastcall TfrxExpressionCache(Fs_iinterpreter::TfsScript* AScript);
	__fastcall virtual ~TfrxExpressionCache();
	void __fastcall Clear();
	System::Variant __fastcall Calc(const System::UnicodeString Expression, System::UnicodeString &ErrorMsg, Fs_iinterpreter::TfsScript* AScript);
	__property bool CaseSensitive = {read=GetCaseSensitive, write=SetCaseSensitive, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxDataSetItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	TfrxDataSet* FDataSet;
	System::UnicodeString FDataSetName;
	void __fastcall SetDataSet(TfrxDataSet* const Value);
	void __fastcall SetDataSetName(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDataSetName();
	
__published:
	__property TfrxDataSet* DataSet = {read=FDataSet, write=SetDataSet};
	__property System::UnicodeString DataSetName = {read=GetDataSetName, write=SetDataSetName};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TfrxDataSetItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TfrxDataSetItem() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxReportDataSets : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TfrxDataSetItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TfrxReport* FReport;
	HIDESBASE TfrxDataSetItem* __fastcall GetItem(int Index);
	
public:
	__fastcall TfrxReportDataSets(TfrxReport* AReport);
	void __fastcall Initialize();
	void __fastcall Finalize();
	HIDESBASE void __fastcall Add(TfrxDataSet* ds);
	TfrxDataSetItem* __fastcall Find(TfrxDataSet* ds)/* overload */;
	TfrxDataSetItem* __fastcall Find(const System::UnicodeString Name)/* overload */;
	HIDESBASE void __fastcall Delete(const System::UnicodeString Name)/* overload */;
	__property TfrxDataSetItem* Items[int Index] = {read=GetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxReportDataSets() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxStyleItem : public Frxcollections::TfrxCollectionItem
{
	typedef Frxcollections::TfrxCollectionItem inherited;
	
private:
	System::UnicodeString FName;
	Vcl::Graphics::TFont* FFont;
	TfrxFrame* FFrame;
	bool FApplyFont;
	bool FApplyFill;
	bool FApplyFrame;
	TfrxCustomFill* FFill;
	void __fastcall SetFont(Vcl::Graphics::TFont* const Value);
	void __fastcall SetFrame(TfrxFrame* const Value);
	void __fastcall SetName(const System::UnicodeString Value);
	TfrxFillType __fastcall GetFillType();
	void __fastcall SetFill(TfrxCustomFill* const Value);
	void __fastcall SetFillType(const TfrxFillType Value);
	System::Uitypes::TColor __fastcall GetColor();
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	
protected:
	virtual System::UnicodeString __fastcall GetInheritedName();
	
public:
	__fastcall virtual TfrxStyleItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TfrxStyleItem();
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall CreateUniqueName();
	
__published:
	__property System::UnicodeString Name = {read=FName, write=SetName};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, stored=false, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property TfrxFrame* Frame = {read=FFrame, write=SetFrame};
	__property bool ApplyFont = {read=FApplyFont, write=FApplyFont, default=1};
	__property bool ApplyFill = {read=FApplyFill, write=FApplyFill, default=1};
	__property bool ApplyFrame = {read=FApplyFrame, write=FApplyFrame, default=1};
	__property TfrxFillType FillType = {read=GetFillType, write=SetFillType, default=0};
	__property TfrxCustomFill* Fill = {read=FFill, write=SetFill};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxStyles : public Frxcollections::TfrxCollection
{
	typedef Frxcollections::TfrxCollection inherited;
	
public:
	TfrxStyleItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::UnicodeString FName;
	TfrxReport* FReport;
	HIDESBASE TfrxStyleItem* __fastcall GetItem(int Index);
	
public:
	__fastcall TfrxStyles(TfrxReport* AReport);
	HIDESBASE TfrxStyleItem* __fastcall Add();
	TfrxStyleItem* __fastcall Find(const System::UnicodeString Name);
	void __fastcall Apply();
	void __fastcall GetList(System::Classes::TStrings* List);
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	void __fastcall LoadFromXMLItem(Frxxml::TfrxXMLItem* Item, bool OldXMLFormat = true);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	void __fastcall SaveToXMLItem(Frxxml::TfrxXMLItem* Item);
	__property TfrxStyleItem* Items[int Index] = {read=GetItem/*, default*/};
	__property System::UnicodeString Name = {read=FName, write=FName};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TfrxStyles() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxStyleSheet : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TfrxStyles* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Classes::TList* FItems;
	TfrxStyles* __fastcall GetItems(int Index);
	
public:
	__fastcall TfrxStyleSheet();
	__fastcall virtual ~TfrxStyleSheet();
	void __fastcall Clear();
	void __fastcall Delete(int Index);
	void __fastcall GetList(System::Classes::TStrings* List);
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	TfrxStyles* __fastcall Add();
	int __fastcall Count();
	TfrxStyles* __fastcall Find(const System::UnicodeString Name);
	int __fastcall IndexOf(const System::UnicodeString Name);
	__property TfrxStyles* Items[int Index] = {read=GetItems/*, default*/};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxReport : public TfrxComponent
{
	typedef TfrxComponent inherited;
	
private:
	System::UnicodeString FCurObject;
	TfrxDataSet* FDataSet;
	System::UnicodeString FDataSetName;
	TfrxReportDataSets* FDataSets;
	TfrxCustomDesigner* FDesigner;
	bool FDotMatrixReport;
	void *FDrawText;
	System::Classes::TStrings* FDrillState;
	TfrxReportDataSets* FEnabledDataSets;
	TfrxCustomEngine* FEngine;
	TfrxEngineOptions* FEngineOptions;
	System::Classes::TStrings* FErrors;
	TfrxExpressionCache* FExpressionCache;
	System::UnicodeString FFileName;
	System::UnicodeString FIniFile;
	System::Classes::TStream* FLoadStream;
	Fs_iinterpreter::TfsCustomVariable* FLocalValue;
	Fs_iinterpreter::TfsCustomVariable* FSelfValue;
	bool FModified;
	bool FOldStyleProgress;
	Vcl::Forms::TForm* FParentForm;
	System::UnicodeString FParentReport;
	TfrxReport* FParentReportObject;
	TfrxCustomPreviewPages* FPreviewPages;
	TfrxCustomPreviewPages* FMainPreviewPages;
	TfrxCustomPreview* FPreview;
	Vcl::Forms::TForm* FPreviewForm;
	TfrxPreviewOptions* FPreviewOptions;
	TfrxPrintOptions* FPrintOptions;
	Frxprogress::TfrxProgress* FProgress;
	bool FReloading;
	TfrxReportOptions* FReportOptions;
	Fs_iinterpreter::TfsScript* FScript;
	Fs_iinterpreter::TfsScript* FSaveParentScript;
	System::UnicodeString FScriptLanguage;
	System::Classes::TStrings* FScriptText;
	System::Classes::TStrings* FFakeScriptText;
	bool FShowProgress;
	bool FStoreInDFM;
	TfrxStyles* FStyles;
	System::Classes::TStrings* FSysVariables;
	bool FTerminated;
	Vcl::Extctrls::TTimer* FTimer;
	Frxvariables::TfrxVariables* FVariables;
	System::UnicodeString FVersion;
	System::TObject* FXMLSerializer;
	bool FStreamLoaded;
	TfrxBeforePrintEvent FOnAfterPrint;
	System::Classes::TNotifyEvent FOnAfterPrintReport;
	TfrxBeforeConnectEvent FOnBeforeConnect;
	TfrxAfterDisconnectEvent FOnAfterDisconnect;
	TfrxBeforePrintEvent FOnBeforePrint;
	System::Classes::TNotifyEvent FOnBeginDoc;
	TfrxClickObjectEvent FOnClickObject;
	TfrxClickObjectEvent FOnDblClickObject;
	TfrxEditConnectionEvent FOnEditConnection;
	System::Classes::TNotifyEvent FOnEndDoc;
	TfrxGetValueEvent FOnGetValue;
	TfrxNewGetValueEvent FOnNewGetValue;
	TfrxLoadTemplateEvent FOnLoadTemplate;
	TfrxLoadDetailTemplateEvent FOnLoadDetailTemplate;
	TfrxManualBuildEvent FOnManualBuild;
	TfrxMouseOverObjectEvent FOnMouseOverObject;
	System::Classes::TNotifyEvent FOnPreview;
	TfrxPrintPageEvent FOnPrintPage;
	System::Classes::TNotifyEvent FOnPrintReport;
	TfrxProgressEvent FOnProgressStart;
	TfrxProgressEvent FOnProgress;
	TfrxProgressEvent FOnProgressStop;
	TfrxRunDialogsEvent FOnRunDialogs;
	TfrxSetConnectionEvent FOnSetConnection;
	TfrxNotifyEvent FOnStartReport;
	TfrxNotifyEvent FOnStopReport;
	TfrxUserFunctionEvent FOnUserFunction;
	System::Classes::TNotifyEvent FOnClosePreview;
	TfrxNotifyEvent FOnReportPrint;
	System::Classes::TNotifyEvent FOnAfterScriptCompile;
	TfrxMouseEnterEvent FOnMouseEnter;
	TfrxMouseLeaveEvent FOnMouseLeave;
	TfrxGetCustomDataEvent FOnGetCustomDataEvent;
	TfrxSaveCustomDataEvent FOnSaveCustomDataEvent;
	System::Variant __fastcall CallMethod(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString MethodName, System::Variant &Params);
	bool __fastcall DoGetValue(const System::UnicodeString Expr, System::Variant &Value);
	System::Variant __fastcall GetScriptValue(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString MethodName, System::Variant &Params);
	System::Variant __fastcall SetScriptValue(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString MethodName, System::Variant &Params);
	System::Variant __fastcall DoUserFunction(System::TObject* Instance, System::TClass ClassType, const System::UnicodeString MethodName, System::Variant &Params);
	System::UnicodeString __fastcall GetDataSetName();
	System::Variant __fastcall GetLocalValue();
	TfrxView* __fastcall GetSelfValue();
	TfrxPage* __fastcall GetPages(int Index);
	int __fastcall GetPagesCount();
	bool __fastcall GetCaseSensitive();
	System::Classes::TStrings* __fastcall GetScriptText();
	void __fastcall AncestorNotFound(System::Classes::TReader* Reader, const System::UnicodeString ComponentName, System::Classes::TPersistentClass ComponentClass, System::Classes::TComponent* &Component);
	void __fastcall DoClear();
	void __fastcall DoLoadFromStream();
	void __fastcall OnTimer(System::TObject* Sender);
	void __fastcall ReadDatasets(System::Classes::TReader* Reader);
	void __fastcall ReadStyle(System::Classes::TReader* Reader);
	void __fastcall ReadVariables(System::Classes::TReader* Reader);
	void __fastcall SetDataSet(TfrxDataSet* const Value);
	void __fastcall SetDataSetName(const System::UnicodeString Value);
	void __fastcall SetEngineOptions(TfrxEngineOptions* const Value);
	void __fastcall SetSelfValue(TfrxView* const Value);
	void __fastcall SetLocalValue(const System::Variant &Value);
	void __fastcall SetParentReport(const System::UnicodeString Value);
	void __fastcall SetPreviewOptions(TfrxPreviewOptions* const Value);
	void __fastcall SetPrintOptions(TfrxPrintOptions* const Value);
	void __fastcall SetReportOptions(TfrxReportOptions* const Value);
	void __fastcall SetScriptText(System::Classes::TStrings* const Value);
	void __fastcall SetStyles(TfrxStyles* const Value);
	void __fastcall SetTerminated(const bool Value);
	void __fastcall SetCaseSensitive(const bool Value);
	void __fastcall WriteDatasets(System::Classes::TWriter* Writer);
	void __fastcall WriteStyle(System::Classes::TWriter* Writer);
	void __fastcall WriteVariables(System::Classes::TWriter* Writer);
	void __fastcall SetPreview(TfrxCustomPreview* const Value);
	void __fastcall SetVersion(const System::UnicodeString Value);
	void __fastcall SetPreviewPages(TfrxCustomPreviewPages* const Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall DoGetAncestor(const System::UnicodeString Name, System::Classes::TPersistent* &Ancestor);
	
public:
	__fastcall virtual TfrxReport(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxReport();
	virtual void __fastcall Clear();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall WriteNestedProperties(Frxxml::TfrxXMLItem* Item, System::Classes::TPersistent* aAcenstor = (System::Classes::TPersistent*)(0x0));
	virtual bool __fastcall ReadNestedProperty(Frxxml::TfrxXMLItem* Item);
	System::Variant __fastcall Calc(const System::UnicodeString Expr, Fs_iinterpreter::TfsScript* AScript = (Fs_iinterpreter::TfsScript*)(0x0));
	bool __fastcall DesignPreviewPage();
	System::UnicodeString __fastcall GetAlias(TfrxDataSet* DataSet);
	TfrxDataSet* __fastcall GetDataset(const System::UnicodeString Alias);
	void * __fastcall GetReportDrawText();
	System::Inifiles::TCustomIniFile* __fastcall GetIniFile();
	System::UnicodeString __fastcall GetApplicationFolder();
	virtual TfrxComponent* __fastcall FindObject(const System::UnicodeString AName);
	bool __fastcall PrepareScript(TfrxReport* ActiveReport = (TfrxReport*)(0x0));
	bool __fastcall InheritFromTemplate(const System::UnicodeString templName, TfrxInheriteMode InheriteMode = (TfrxInheriteMode)(0x0));
	void __fastcall DesignReport(System::_di_IInterface IDesigner, System::TObject* Editor)/* overload */;
	void __fastcall DoNotifyEvent(System::TObject* Obj, const System::UnicodeString EventName, bool RunAlways = false);
	void __fastcall DoParamEvent(const System::UnicodeString EventName, System::Variant &Params, bool RunAlways = false);
	void __fastcall DoAfterPrint(TfrxReportComponent* c);
	void __fastcall DoBeforePrint(TfrxReportComponent* c);
	void __fastcall DoPreviewClick(TfrxView* v, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, bool &Modified, TfrxInteractiveEventsParams &EventParams, bool DblClick = false);
	HIDESBASE void __fastcall DoMouseEnter(TfrxView* Sender, TfrxComponent* aPreviousObject, TfrxInteractiveEventsParams &EventParams);
	HIDESBASE void __fastcall DoMouseLeave(TfrxView* Sender, int X, int Y, TfrxComponent* aNextObject, TfrxInteractiveEventsParams &EventParams);
	HIDESBASE void __fastcall DoMouseUp(TfrxView* Sender, int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	void __fastcall GetDatasetAndField(const System::UnicodeString ComplexName, TfrxDataSet* &Dataset, System::UnicodeString &Field);
	void __fastcall GetDataSetList(System::Classes::TStrings* List, bool OnlyDB = false);
	void __fastcall GetActiveDataSetList(System::Classes::TStrings* List);
	virtual void __fastcall InternalOnProgressStart(TfrxProgressType ProgressType);
	virtual void __fastcall InternalOnProgress(TfrxProgressType ProgressType, int Progress);
	virtual void __fastcall InternalOnProgressStop(TfrxProgressType ProgressType);
	void __fastcall SelectPrinter();
	void __fastcall SetProgressMessage(const System::UnicodeString Value, bool Ishint = false, bool bHandleMessage = true);
	void __fastcall CheckDataPage();
	bool __fastcall LoadFromFile(const System::UnicodeString FileName, bool ExceptionIfNotFound = false);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	bool __fastcall LoadFromFilter(TfrxCustomIOTransport* Filter, const System::UnicodeString FileName);
	bool __fastcall ProcessIOTransport(TfrxCustomIOTransport* Filter, const System::UnicodeString FileName, TfrxFilterAccess fAccess);
	bool __fastcall SaveToFilter(TfrxCustomIOTransport* Filter, const System::UnicodeString FileName);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	virtual void __fastcall SaveToStream(System::Classes::TStream* Stream, bool SaveChildren = true, bool SaveDefaultValues = false, bool UseGetAncestor = false);
	void __stdcall DesignReport(bool Modal = true, bool MDIChild = false)/* overload */;
	bool __fastcall PrepareReport(bool ClearLastReport = true);
	bool __fastcall PreparePage(TfrxPage* APage);
	void __stdcall ShowPreparedReport();
	void __stdcall ShowReport(bool ClearLastReport = true);
	void __fastcall AddFunction(const System::UnicodeString FuncName, const System::UnicodeString Category = System::UnicodeString(), const System::UnicodeString Description = System::UnicodeString());
	void __fastcall DesignReportInPanel(Vcl::Controls::TWinControl* Panel);
	bool __stdcall Print();
	bool __fastcall Export(TfrxCustomExportFilter* Filter);
	__property System::UnicodeString CurObject = {read=FCurObject, write=FCurObject};
	__property System::Classes::TStrings* DrillState = {read=FDrillState};
	__property System::Variant LocalValue = {read=GetLocalValue, write=SetLocalValue};
	__property TfrxView* SelfValue = {read=GetSelfValue, write=SetSelfValue};
	__property Vcl::Forms::TForm* PreviewForm = {read=FPreviewForm};
	__property System::TObject* XMLSerializer = {read=FXMLSerializer};
	__property bool Reloading = {read=FReloading, write=FReloading, nodefault};
	__property TfrxReportDataSets* DataSets = {read=FDataSets};
	__property TfrxCustomDesigner* Designer = {read=FDesigner, write=FDesigner};
	__property TfrxReportDataSets* EnabledDataSets = {read=FEnabledDataSets};
	__property TfrxCustomEngine* Engine = {read=FEngine};
	__property System::Classes::TStrings* Errors = {read=FErrors};
	__property System::UnicodeString FileName = {read=FFileName, write=FFileName};
	__property bool Modified = {read=FModified, write=FModified, nodefault};
	__property TfrxCustomPreviewPages* PreviewPages = {read=FPreviewPages, write=SetPreviewPages};
	__property TfrxPage* Pages[int Index] = {read=GetPages};
	__property int PagesCount = {read=GetPagesCount, nodefault};
	__property Fs_iinterpreter::TfsScript* Script = {read=FScript};
	__property TfrxStyles* Styles = {read=FStyles, write=SetStyles};
	__property bool Terminated = {read=FTerminated, write=SetTerminated, nodefault};
	__property Frxvariables::TfrxVariables* Variables = {read=FVariables};
	__property bool CaseSensitiveExpressions = {read=GetCaseSensitive, write=SetCaseSensitive, nodefault};
	__property TfrxEditConnectionEvent OnEditConnection = {read=FOnEditConnection, write=FOnEditConnection};
	__property TfrxSetConnectionEvent OnSetConnection = {read=FOnSetConnection, write=FOnSetConnection};
	
__published:
	__property System::UnicodeString Version = {read=FVersion, write=SetVersion};
	__property System::UnicodeString ParentReport = {read=FParentReport, write=SetParentReport};
	__property TfrxDataSet* DataSet = {read=FDataSet, write=SetDataSet};
	__property System::UnicodeString DataSetName = {read=GetDataSetName, write=SetDataSetName};
	__property bool DotMatrixReport = {read=FDotMatrixReport, write=FDotMatrixReport, nodefault};
	__property TfrxEngineOptions* EngineOptions = {read=FEngineOptions, write=SetEngineOptions};
	__property System::UnicodeString IniFile = {read=FIniFile, write=FIniFile};
	__property bool OldStyleProgress = {read=FOldStyleProgress, write=FOldStyleProgress, default=0};
	__property TfrxCustomPreview* Preview = {read=FPreview, write=SetPreview};
	__property TfrxPreviewOptions* PreviewOptions = {read=FPreviewOptions, write=SetPreviewOptions};
	__property TfrxPrintOptions* PrintOptions = {read=FPrintOptions, write=SetPrintOptions};
	__property TfrxReportOptions* ReportOptions = {read=FReportOptions, write=SetReportOptions};
	__property System::UnicodeString ScriptLanguage = {read=FScriptLanguage, write=FScriptLanguage};
	__property System::Classes::TStrings* ScriptText = {read=GetScriptText, write=SetScriptText};
	__property bool ShowProgress = {read=FShowProgress, write=FShowProgress, default=1};
	__property bool StoreInDFM = {read=FStoreInDFM, write=FStoreInDFM, default=1};
	__property TfrxBeforePrintEvent OnAfterPrint = {read=FOnAfterPrint, write=FOnAfterPrint};
	__property TfrxBeforeConnectEvent OnBeforeConnect = {read=FOnBeforeConnect, write=FOnBeforeConnect};
	__property TfrxAfterDisconnectEvent OnAfterDisconnect = {read=FOnAfterDisconnect, write=FOnAfterDisconnect};
	__property TfrxBeforePrintEvent OnBeforePrint = {read=FOnBeforePrint, write=FOnBeforePrint};
	__property System::Classes::TNotifyEvent OnBeginDoc = {read=FOnBeginDoc, write=FOnBeginDoc};
	__property TfrxClickObjectEvent OnClickObject = {read=FOnClickObject, write=FOnClickObject};
	__property TfrxClickObjectEvent OnDblClickObject = {read=FOnDblClickObject, write=FOnDblClickObject};
	__property System::Classes::TNotifyEvent OnEndDoc = {read=FOnEndDoc, write=FOnEndDoc};
	__property TfrxGetValueEvent OnGetValue = {read=FOnGetValue, write=FOnGetValue};
	__property TfrxNewGetValueEvent OnNewGetValue = {read=FOnNewGetValue, write=FOnNewGetValue};
	__property TfrxManualBuildEvent OnManualBuild = {read=FOnManualBuild, write=FOnManualBuild};
	__property TfrxMouseOverObjectEvent OnMouseOverObject = {read=FOnMouseOverObject, write=FOnMouseOverObject};
	__property TfrxMouseEnterEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property TfrxMouseLeaveEvent OnMouseLeave = {read=FOnMouseLeave, write=FOnMouseLeave};
	__property System::Classes::TNotifyEvent OnPreview = {read=FOnPreview, write=FOnPreview};
	__property TfrxPrintPageEvent OnPrintPage = {read=FOnPrintPage, write=FOnPrintPage};
	__property System::Classes::TNotifyEvent OnPrintReport = {read=FOnPrintReport, write=FOnPrintReport};
	__property System::Classes::TNotifyEvent OnAfterPrintReport = {read=FOnAfterPrintReport, write=FOnAfterPrintReport};
	__property TfrxProgressEvent OnProgressStart = {read=FOnProgressStart, write=FOnProgressStart};
	__property TfrxProgressEvent OnProgress = {read=FOnProgress, write=FOnProgress};
	__property TfrxProgressEvent OnProgressStop = {read=FOnProgressStop, write=FOnProgressStop};
	__property TfrxRunDialogsEvent OnRunDialogs = {read=FOnRunDialogs, write=FOnRunDialogs};
	__property TfrxNotifyEvent OnStartReport = {read=FOnStartReport, write=FOnStartReport};
	__property TfrxNotifyEvent OnStopReport = {read=FOnStopReport, write=FOnStopReport};
	__property TfrxUserFunctionEvent OnUserFunction = {read=FOnUserFunction, write=FOnUserFunction};
	__property TfrxLoadTemplateEvent OnLoadTemplate = {read=FOnLoadTemplate, write=FOnLoadTemplate};
	__property TfrxLoadDetailTemplateEvent OnLoadDetailTemplate = {read=FOnLoadDetailTemplate, write=FOnLoadDetailTemplate};
	__property System::Classes::TNotifyEvent OnClosePreview = {read=FOnClosePreview, write=FOnClosePreview};
	__property TfrxNotifyEvent OnReportPrint = {read=FOnReportPrint, write=FOnReportPrint};
	__property System::Classes::TNotifyEvent OnAfterScriptCompile = {read=FOnAfterScriptCompile, write=FOnAfterScriptCompile};
	__property TfrxGetCustomDataEvent OnGetCustomData = {read=FOnGetCustomDataEvent, write=FOnGetCustomDataEvent};
	__property TfrxSaveCustomDataEvent OnSaveCustomData = {read=FOnSaveCustomDataEvent, write=FOnSaveCustomDataEvent};
public:
	/* TfrxComponent.DesignCreate */ inline __fastcall virtual TfrxReport(System::Classes::TComponent* AOwner, System::Word Flags) : TfrxComponent(AOwner, Flags) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxSelectedObjectsList : public System::Classes::TList
{
	typedef System::Classes::TList inherited;
	
private:
	System::Classes::TList* FInspSelectedObjects;
	bool FUpdated;
	
protected:
	virtual void __fastcall Notify(void * Ptr, System::Classes::TListNotification Action);
	
public:
	__fastcall TfrxSelectedObjectsList();
	__fastcall virtual ~TfrxSelectedObjectsList();
	void __fastcall ClearInspectorList();
	__property System::Classes::TList* InspSelectedObjects = {read=FInspSelectedObjects};
	__property bool Updated = {read=FUpdated, write=FUpdated, nodefault};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxCustomDesigner : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
private:
	TfrxReport* FReport;
	bool FIsPreviewDesigner;
	System::UnicodeString FMemoFontName;
	int FMemoFontSize;
	bool FUseObjectFont;
	Vcl::Forms::TForm* FParentForm;
	
protected:
	bool FModified;
	bool FInspectorLock;
	System::Classes::TList* FObjects;
	TfrxPage* FPage;
	TfrxSelectedObjectsList* FSelectedObjects;
	virtual void __fastcall SetModified(const bool Value);
	virtual void __fastcall SetPage(TfrxPage* const Value);
	virtual System::Classes::TStrings* __fastcall GetCode() = 0 ;
	
public:
	__fastcall TfrxCustomDesigner(System::Classes::TComponent* AOwner, TfrxReport* AReport, bool APreviewDesigner);
	__fastcall virtual ~TfrxCustomDesigner();
	virtual System::UnicodeString __fastcall InsertExpression(const System::UnicodeString Expr) = 0 ;
	virtual bool __fastcall IsChangedExpression(const System::UnicodeString InExpr, /* out */ System::UnicodeString &OutExpr) = 0 ;
	virtual void __fastcall Lock() = 0 ;
	virtual void __fastcall ReloadPages(int Index) = 0 ;
	virtual void __fastcall ReloadReport() = 0 ;
	virtual void __fastcall ReloadObjects(bool ResetSelection = true) = 0 ;
	virtual void __fastcall UpdateDataTree() = 0 ;
	virtual void __fastcall UpdatePage() = 0 ;
	virtual void __fastcall UpdateInspector() = 0 ;
	virtual void __fastcall DisableInspectorUpdate() = 0 ;
	virtual void __fastcall EnableInspectorUpdate() = 0 ;
	virtual void __fastcall InternalCopy() = 0 ;
	virtual void __fastcall InternalPaste() = 0 ;
	virtual bool __fastcall InternalIsPasteAvailable() = 0 ;
	__property bool IsPreviewDesigner = {read=FIsPreviewDesigner, nodefault};
	__property bool Modified = {read=FModified, write=SetModified, nodefault};
	__property System::Classes::TList* Objects = {read=FObjects};
	__property TfrxReport* Report = {read=FReport};
	__property TfrxSelectedObjectsList* SelectedObjects = {read=FSelectedObjects};
	__property TfrxPage* Page = {read=FPage, write=SetPage};
	__property System::Classes::TStrings* Code = {read=GetCode};
	__property bool UseObjectFont = {read=FUseObjectFont, write=FUseObjectFont, nodefault};
	__property System::UnicodeString MemoFontName = {read=FMemoFontName, write=FMemoFontName};
	__property int MemoFontSize = {read=FMemoFontSize, write=FMemoFontSize, nodefault};
	__property Vcl::Forms::TForm* ParentForm = {read=FParentForm, write=FParentForm};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrxCustomDesigner(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrxCustomDesigner(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxCustomDesigner(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


typedef System::TMetaClass* TfrxDesignerClass;

typedef void __fastcall (__closure *TfrxNodeChanging)(System::UnicodeString Name, bool bUseRemoveList/* = false*/, System::TObject* aObject/* = (System::TObject*)(0x0)*/);

class PASCALIMPLEMENTATION TfrxNode : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfrxNode* FParent;
	System::Classes::TStringList* FNodesList;
	System::Variant FData;
	System::TObject* FObjectData;
	System::UnicodeString FName;
	System::UnicodeString FOriginalName;
	bool FOwnObject;
	TfrxNodeChanging FOnAddItem;
	TfrxNodeChanging FOnRemoveItem;
	TfrxFilterAccess FFilterAccess;
	int FFilesCount;
	void __fastcall SetName(const System::UnicodeString Value);
	void __fastcall SetObjectData(System::TObject* const Value);
	TfrxNode* __fastcall GetNode(int Index);
	void __fastcall UpdateFilesCount(int Count);
	void __fastcall SetOriginalName(const System::UnicodeString Value);
	
public:
	__fastcall TfrxNode();
	__fastcall virtual ~TfrxNode();
	void __fastcall Clear();
	TfrxNode* __fastcall GetRoot();
	TfrxNode* __fastcall Add(System::UnicodeString Name, System::TObject* aObject = (System::TObject*)(0x0));
	void __fastcall RemoveNode(TfrxNode* aNode);
	TfrxNode* __fastcall Find(System::UnicodeString Name, bool SearchInChilds = false)/* overload */;
	TfrxNode* __fastcall Find(System::TObject* aObject, bool SearchInChilds = false)/* overload */;
	int __fastcall Count();
	__property TfrxNode* Parent = {read=FParent};
	__property System::Variant Data = {read=FData, write=FData};
	__property System::TObject* ObjectData = {read=FObjectData, write=SetObjectData};
	__property System::UnicodeString Name = {read=FName, write=SetName};
	__property TfrxNode* Items[int Index] = {read=GetNode};
	__property System::UnicodeString OriginalName = {read=FOriginalName, write=SetOriginalName};
	__property TfrxNodeChanging OnAddItem = {read=FOnAddItem, write=FOnAddItem};
	__property TfrxNodeChanging OnRemoveItem = {read=FOnRemoveItem, write=FOnRemoveItem};
	__property TfrxFilterAccess FilterAccess = {read=FFilterAccess, write=FFilterAccess, nodefault};
	__property int FilesCount = {read=FFilesCount, nodefault};
};


enum DECLSPEC_DENUM TfrxFilterVisibleState : unsigned char { fvDesigner, fvPreview, fvExport, fvDesignerFileFilter, fvPreviewFileFilter, fvExportFileFilter, fvOther };

typedef System::Set<TfrxFilterVisibleState, TfrxFilterVisibleState::fvDesigner, TfrxFilterVisibleState::fvOther> TfrxFilterVisibility;

enum DECLSPEC_DENUM TfrxIOTransportStream : unsigned char { tsIORead, tsIOWrite };

typedef System::Set<TfrxIOTransportStream, TfrxIOTransportStream::tsIORead, TfrxIOTransportStream::tsIOWrite> TfrxIOTransportStreams;

class PASCALIMPLEMENTATION TfrxCustomIOTransport : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TfrxReport* FReport;
	bool FShowDialog;
	bool FOverwritePrompt;
	System::UnicodeString FDefaultPath;
	System::UnicodeString FBasePath;
	System::UnicodeString FFileName;
	System::UnicodeString FDefaultExt;
	System::UnicodeString FExtDescription;
	System::UnicodeString FFilterString;
	TfrxFilterAccess FFilterAccess;
	TfrxCustomIOTransport* FTempFilter;
	TfrxNode* FCurNode;
	TfrxCustomIOTransport* __fastcall GetTempFilter();
	void __fastcall SetTempFilter(TfrxCustomIOTransport* const Value);
	void __fastcall SetInternalFilter(TfrxCustomIOTransport* const Value);
	TfrxCustomIOTransport* __fastcall GetInternalFilter();
	System::UnicodeString __fastcall GetCurrentContainer();
	void __fastcall SetCurrentContainer(const System::UnicodeString Value);
	
protected:
	bool FNoRegister;
	TfrxFilterVisibility FVisibility;
	TfrxFilterVisibleState FCreatedFrom;
	bool FFreeStream;
	bool FClosedLoadLock;
	TfrxCustomIOTransport* FInternalFilter;
	TfrxNode* FDirTree;
	TfrxIOTransportStreams FSupportedStreams;
	TfrxCustomIOTransport* FOriginalCopy;
	virtual System::UnicodeString __fastcall GetFilterString();
	virtual TfrxFilterVisibility __fastcall GetVisibility();
	virtual void __fastcall SetVisibility(const TfrxFilterVisibility Value);
	TfrxNode* __fastcall GetNodeFromPath(System::UnicodeString aPath, bool bCreateNodes = false, bool bLastNodeAsFile = false);
	virtual bool __fastcall AddContainer(TfrxNode* Item);
	virtual bool __fastcall RemoveContainer(TfrxNode* Item);
	virtual System::Classes::TStream* __fastcall DoCreateStream(System::UnicodeString &aFullFilePath, System::UnicodeString aFileName);
	__property TfrxCustomIOTransport* InternalFilter = {read=GetInternalFilter, write=SetInternalFilter};
	
public:
	__fastcall virtual TfrxCustomIOTransport(System::Classes::TComponent* AOwner);
	__fastcall TfrxCustomIOTransport();
	TfrxCustomIOTransport* __fastcall CreateFilterClone(TfrxFilterVisibleState CreatedFrom);
	__fastcall virtual ~TfrxCustomIOTransport();
	void __fastcall CloseAllStreams();
	void __fastcall CopyStreamsNames(System::Classes::TStrings* aStrings, bool OpenedOnly = false);
	void __fastcall LoadStreamsList(System::Classes::TStrings* aStrings);
	void __fastcall LoadClosedStreams();
	void __fastcall CreateContainer(const System::UnicodeString cName, bool bSetCurrent = false);
	void __fastcall DeleteContainer(const System::UnicodeString cName);
	virtual void __fastcall CreateTempContainer();
	virtual void __fastcall FreeTempContainer();
	virtual System::Classes::TStream* __fastcall GetStream(System::UnicodeString aFileName = System::UnicodeString());
	virtual void __fastcall FreeStream(System::Classes::TStream* aStream, System::UnicodeString aFileName = System::UnicodeString());
	virtual bool __fastcall DoFilterSave(System::Classes::TStream* aStream);
	virtual bool __fastcall AllInOneContainer();
	virtual bool __fastcall OpenFilter();
	virtual void __fastcall CloseFilter();
	void __fastcall InitFromExport(TfrxCustomExportFilter* ExportFilter);
	virtual void __fastcall AssignFilter(TfrxCustomIOTransport* Source);
	virtual void __fastcall AssignSharedProperties(TfrxCustomIOTransport* Source);
	TfrxNode* __fastcall GetFileNode();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property TfrxNode* RootNode = {read=FDirTree};
	__property System::UnicodeString CurrentContainer = {read=GetCurrentContainer, write=SetCurrentContainer};
	__property TfrxFilterVisibleState CreatedFrom = {read=FCreatedFrom, write=FCreatedFrom, nodefault};
	__property TfrxCustomIOTransport* TempFilter = {read=GetTempFilter, write=SetTempFilter};
	__property TfrxFilterAccess FilterAccess = {read=FFilterAccess, write=FFilterAccess, nodefault};
	__property System::UnicodeString FilterString = {read=GetFilterString, write=FFilterString};
	__property TfrxReport* Report = {read=FReport, write=FReport};
	__property bool ShowDialog = {read=FShowDialog, write=FShowDialog, nodefault};
	__property bool OverwritePrompt = {read=FOverwritePrompt, write=FOverwritePrompt, nodefault};
	__property System::UnicodeString DefaultPath = {read=FDefaultPath, write=FDefaultPath};
	__property System::UnicodeString FileName = {read=FFileName, write=FFileName};
	__property System::UnicodeString BasePath = {read=FBasePath, write=FBasePath};
	__property System::UnicodeString DefaultExt = {read=FDefaultExt, write=FDefaultExt};
	__property System::UnicodeString ExtDescription = {read=FExtDescription, write=FExtDescription};
	__property TfrxFilterVisibility Visibility = {read=GetVisibility, write=SetVisibility, nodefault};
	__property TfrxIOTransportStreams SupportedStreams = {read=FSupportedStreams, write=FSupportedStreams, nodefault};
};


class PASCALIMPLEMENTATION TfrxIOTransportFile : public TfrxCustomIOTransport
{
	typedef TfrxCustomIOTransport inherited;
	
private:
	bool FTempFolderCreated;
	
protected:
	virtual void __fastcall SetVisibility(const TfrxFilterVisibility Value);
	virtual bool __fastcall AddContainer(TfrxNode* Item);
	void __fastcall DeleteFiles();
	
public:
	__fastcall virtual TfrxIOTransportFile(System::Classes::TComponent* AOwner);
	virtual bool __fastcall OpenFilter();
	virtual System::Classes::TStream* __fastcall DoCreateStream(System::UnicodeString &aFullFilePath, System::UnicodeString aFileName);
	virtual void __fastcall CloseFilter();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual void __fastcall CreateTempContainer();
	virtual void __fastcall FreeTempContainer();
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxIOTransportFile() : TfrxCustomIOTransport() { }
	/* TfrxCustomIOTransport.Destroy */ inline __fastcall virtual ~TfrxIOTransportFile() { }
	
};


class PASCALIMPLEMENTATION TfrxSaveToCompressedFilter : public TfrxIOTransportFile
{
	typedef TfrxIOTransportFile inherited;
	
private:
	bool FIsFR3File;
	void __fastcall SetIsFR3File(const bool Value);
	
protected:
	virtual System::UnicodeString __fastcall GetFilterString();
	
public:
	__fastcall virtual TfrxSaveToCompressedFilter(System::Classes::TComponent* AOwner);
	virtual bool __fastcall OpenFilter();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	__property bool IsFR3File = {read=FIsFR3File, write=SetIsFR3File, nodefault};
public:
	/* TfrxCustomIOTransport.CreateNoRegister */ inline __fastcall TfrxSaveToCompressedFilter() : TfrxIOTransportFile() { }
	/* TfrxCustomIOTransport.Destroy */ inline __fastcall virtual ~TfrxSaveToCompressedFilter() { }
	
};


class PASCALIMPLEMENTATION TfrxCustomExportFilter : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	bool FCurPage;
	bool FExportNotPrintable;
	System::UnicodeString FName;
	bool FNoRegister;
	System::UnicodeString FPageNumbers;
	TfrxReport* FReport;
	bool FShowDialog;
	System::Classes::TStream* FStream;
	bool FUseFileCache;
	System::UnicodeString FDefaultPath;
	bool FSlaveExport;
	bool FShowProgress;
	System::UnicodeString FDefaultExt;
	System::UnicodeString FFilterDesc;
	bool FSuppressPageHeadersFooters;
	System::UnicodeString FTitle;
	bool FOverwritePrompt;
	System::Classes::TStrings* FFIles;
	System::Classes::TNotifyEvent FOnBeforeExport;
	System::Classes::TNotifyEvent FOnBeginExport;
	System::TDateTime FCreationTime;
	bool FDataOnly;
	TfrxCustomIOTransport* FIOTransport;
	bool FOpenAfterExport;
	TfrxCustomIOTransport* __fastcall GetDefaultIOTransport();
	void __fastcall SetDefaultIOTransport(TfrxCustomIOTransport* const Value);
	void __fastcall SetShowDialog(const bool Value);
	void __fastcall SetFileName(const System::UnicodeString Value);
	
protected:
	TfrxCustomIOTransport* FDefaultIOTransport;
	virtual void __fastcall Finish();
	virtual void __fastcall AfterFinish();
	virtual void __fastcall BeforeStart();
	virtual bool __fastcall Start();
	
public:
	__fastcall virtual TfrxCustomExportFilter(System::Classes::TComponent* AOwner);
	__fastcall TfrxCustomExportFilter();
	__fastcall virtual ~TfrxCustomExportFilter();
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual System::Uitypes::TModalResult __fastcall ShowModal();
	bool __fastcall DoStart();
	virtual TfrxCustomIOTransport* __fastcall CreateDefaultIOTransport();
	virtual void __fastcall ExportObject(TfrxComponent* Obj) = 0 ;
	void __fastcall DoFinish();
	virtual void __fastcall FinishPage(TfrxReportPage* Page, int Index);
	virtual void __fastcall StartPage(TfrxReportPage* Page, int Index);
	virtual void __fastcall BeginClip(TfrxView* Obj);
	virtual void __fastcall EndClip();
	virtual bool __fastcall IsProcessInternal();
	__property TfrxCustomIOTransport* DefaultIOTransport = {read=GetDefaultIOTransport, write=SetDefaultIOTransport};
	__property bool CurPage = {read=FCurPage, write=FCurPage, nodefault};
	__property System::UnicodeString PageNumbers = {read=FPageNumbers, write=FPageNumbers};
	__property TfrxReport* Report = {read=FReport, write=FReport};
	__property System::Classes::TStream* Stream = {read=FStream, write=FStream};
	__property bool SlaveExport = {read=FSlaveExport, write=FSlaveExport, nodefault};
	__property System::UnicodeString DefaultExt = {read=FDefaultExt, write=FDefaultExt};
	__property System::UnicodeString FilterDesc = {read=FFilterDesc, write=FFilterDesc};
	__property bool SuppressPageHeadersFooters = {read=FSuppressPageHeadersFooters, write=FSuppressPageHeadersFooters, nodefault};
	__property System::UnicodeString ExportTitle = {read=FTitle, write=FTitle};
	__property System::Classes::TStrings* Files = {read=FFIles, write=FFIles};
	__property bool OpenAfterExport = {read=FOpenAfterExport, write=FOpenAfterExport, nodefault};
	
__published:
	__property TfrxCustomIOTransport* IOTransport = {read=FIOTransport, write=FIOTransport};
	__property bool ShowDialog = {read=FShowDialog, write=SetShowDialog, default=1};
	__property System::UnicodeString FileName = {read=FName, write=SetFileName};
	__property bool ExportNotPrintable = {read=FExportNotPrintable, write=FExportNotPrintable, default=0};
	__property bool UseFileCache = {read=FUseFileCache, write=FUseFileCache, nodefault};
	__property System::UnicodeString DefaultPath = {read=FDefaultPath, write=FDefaultPath};
	__property bool ShowProgress = {read=FShowProgress, write=FShowProgress, nodefault};
	__property bool OverwritePrompt = {read=FOverwritePrompt, write=FOverwritePrompt, nodefault};
	__property System::TDateTime CreationTime = {read=FCreationTime, write=FCreationTime};
	__property bool DataOnly = {read=FDataOnly, write=FDataOnly, nodefault};
	__property System::Classes::TNotifyEvent OnBeforeExport = {read=FOnBeforeExport, write=FOnBeforeExport};
	__property System::Classes::TNotifyEvent OnBeginExport = {read=FOnBeginExport, write=FOnBeginExport};
};


class PASCALIMPLEMENTATION TfrxCustomWizard : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TfrxCustomDesigner* FDesigner;
	TfrxReport* FReport;
	
public:
	__fastcall virtual TfrxCustomWizard(System::Classes::TComponent* AOwner);
	__classmethod virtual System::UnicodeString __fastcall GetDescription();
	virtual bool __fastcall Execute() = 0 ;
	__property TfrxCustomDesigner* Designer = {read=FDesigner};
	__property TfrxReport* Report = {read=FReport};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrxCustomWizard() { }
	
};


typedef System::TMetaClass* TfrxWizardClass;

class PASCALIMPLEMENTATION TfrxCustomEngine : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FCurColumn;
	int FCurVColumn;
	int FCurLine;
	int FCurLineThrough;
	bool FFinalPass;
	System::Classes::TList* FNotifyList;
	System::Extended FPageHeight;
	System::Extended FPageWidth;
	TfrxCustomPreviewPages* FPreviewPages;
	TfrxReport* FReport;
	bool FRunning;
	System::TDateTime FStartDate;
	System::TDateTime FStartTime;
	int FTotalPages;
	TfrxRunDialogEvent FOnRunDialog;
	bool FSecondScriptCall;
	int FCurTableRow;
	int FCurTableColumn;
	bool __fastcall GetDoublePass();
	
protected:
	System::Extended FCurX;
	System::Extended FCurY;
	virtual System::Extended __fastcall GetPageHeight();
	
public:
	__fastcall virtual TfrxCustomEngine(TfrxReport* AReport);
	__fastcall virtual ~TfrxCustomEngine();
	virtual void __fastcall EndPage() = 0 ;
	virtual void __fastcall BreakAllKeep();
	virtual void __fastcall NewColumn() = 0 ;
	virtual void __fastcall NewPage() = 0 ;
	virtual void __fastcall PrepareShiftTree(TfrxReportComponent* Container) = 0 ;
	virtual TfrxBand* __fastcall ShowBand(TfrxBand* Band) = 0 /* overload */;
	virtual void __fastcall ShowBand(TfrxBandClass Band) = 0 /* overload */;
	void __fastcall ShowBandByName(const System::UnicodeString BandName);
	virtual void __fastcall Stretch(TfrxReportComponent* Band) = 0 ;
	virtual void __fastcall UnStretch(TfrxReportComponent* Band) = 0 ;
	void __fastcall StopReport();
	virtual System::Extended __fastcall HeaderHeight() = 0 ;
	virtual System::Extended __fastcall FooterHeight() = 0 ;
	virtual System::Extended __fastcall FreeSpace() = 0 ;
	virtual System::Variant __fastcall GetAggregateValue(const System::UnicodeString Name, const System::UnicodeString Expression, TfrxBand* Band, int Flags) = 0 ;
	virtual void __fastcall ProcessObject(TfrxView* ReportObject) = 0 ;
	virtual bool __fastcall Run(bool ARunDialogs, bool AClearLast = false, TfrxPage* APage = (TfrxPage*)(0x0)) = 0 ;
	__property int CurLine = {read=FCurLine, write=FCurLine, nodefault};
	__property int CurLineThrough = {read=FCurLineThrough, write=FCurLineThrough, nodefault};
	__property int CurTableRow = {read=FCurTableRow, write=FCurTableRow, nodefault};
	__property int CurTableColumn = {read=FCurTableColumn, write=FCurTableColumn, nodefault};
	__property System::Classes::TList* NotifyList = {read=FNotifyList};
	__property TfrxCustomPreviewPages* PreviewPages = {read=FPreviewPages, write=FPreviewPages};
	__property TfrxReport* Report = {read=FReport};
	__property bool Running = {read=FRunning, write=FRunning, nodefault};
	__property TfrxRunDialogEvent OnRunDialog = {read=FOnRunDialog, write=FOnRunDialog};
	
__published:
	__property int CurColumn = {read=FCurColumn, write=FCurColumn, nodefault};
	__property int CurVColumn = {read=FCurVColumn, write=FCurVColumn, nodefault};
	__property System::Extended CurX = {read=FCurX, write=FCurX};
	__property System::Extended CurY = {read=FCurY, write=FCurY};
	__property bool DoublePass = {read=GetDoublePass, nodefault};
	__property bool FinalPass = {read=FFinalPass, write=FFinalPass, nodefault};
	__property System::Extended PageHeight = {read=GetPageHeight, write=FPageHeight};
	__property System::Extended PageWidth = {read=FPageWidth, write=FPageWidth};
	__property System::TDateTime StartDate = {read=FStartDate, write=FStartDate};
	__property System::TDateTime StartTime = {read=FStartTime, write=FStartTime};
	__property int TotalPages = {read=FTotalPages, write=FTotalPages, nodefault};
	__property bool SecondScriptCall = {read=FSecondScriptCall, write=FSecondScriptCall, nodefault};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCustomOutline : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Frxxml::TfrxXMLItem* FCurItem;
	TfrxCustomPreviewPages* FPreviewPages;
	
protected:
	virtual int __fastcall GetCount() = 0 ;
	
public:
	__fastcall virtual TfrxCustomOutline(TfrxCustomPreviewPages* APreviewPages);
	virtual void __fastcall AddItem(const System::UnicodeString Text, int Top) = 0 ;
	virtual void __fastcall DeleteItems(Frxxml::TfrxXMLItem* From) = 0 ;
	virtual void __fastcall LevelDown(int Index) = 0 ;
	virtual void __fastcall LevelRoot() = 0 ;
	virtual void __fastcall LevelUp() = 0 ;
	virtual void __fastcall GetItem(int Index, System::UnicodeString &Text, int &Page, int &Top) = 0 ;
	virtual void __fastcall ShiftItems(Frxxml::TfrxXMLItem* From, int NewTop) = 0 ;
	TfrxCustomEngine* __fastcall Engine();
	virtual Frxxml::TfrxXMLItem* __fastcall GetCurPosition() = 0 ;
	__property int Count = {read=GetCount, nodefault};
	__property Frxxml::TfrxXMLItem* CurItem = {read=FCurItem, write=FCurItem};
	__property TfrxCustomPreviewPages* PreviewPages = {read=FPreviewPages};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxCustomOutline() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxObjectProcessing : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TfrxProcessAtMode FProcessAt;
	int FGroupLevel;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property TfrxProcessAtMode ProcessAt = {read=FProcessAt, write=FProcessAt, default=0};
	__property int GroupLevel = {read=FGroupLevel, write=FGroupLevel, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfrxObjectProcessing() { }
	
public:
	/* TObject.Create */ inline __fastcall TfrxObjectProcessing() : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxMacrosItem : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Widestrings::TWideStrings* FItems;
	System::Variant FSupressedValue;
	int FLastIndex;
	TfrxComponent* FComponent;
	TfrxComponent* FBaseComponent;
	System::UnicodeString FBandName;
	bool FNeedReset;
	TfrxProcessAtMode FProcessAt;
	int FGroupLevel;
	int FDataLevel;
	TfrxPostProcessor* FParent;
	System::WideString __fastcall GetItem(int Index);
	void __fastcall SetItem(int Index, const System::WideString Value);
	
public:
	__fastcall TfrxMacrosItem();
	__fastcall virtual ~TfrxMacrosItem();
	int __fastcall AddObject(const System::WideString S, System::TObject* AObject, bool bSupressed = false);
	int __fastcall Count();
	__property System::WideString Item[int Index] = {read=GetItem, write=SetItem};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxPostProcessor : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Classes::TStrings* FMacroses;
	System::Classes::TList* FProcessList;
	System::Classes::TStrings* FBands;
	int FGroupLevel;
	int FDataLevel;
	bool FProcessing;
	
public:
	__fastcall TfrxPostProcessor();
	__fastcall virtual ~TfrxPostProcessor();
	void __fastcall Clear();
	int __fastcall Add(const System::UnicodeString BandName, const System::UnicodeString Name, const System::WideString Content, TfrxProcessAtMode ProcessMode, TfrxComponent* aComponent, bool bSupressed = false, bool bEmpty = false);
	void __fastcall EnterGroup();
	void __fastcall LeaveGroup();
	void __fastcall EnterData();
	void __fastcall LeaveData();
	System::WideString __fastcall GetValue(const int MacroIndex, const int MacroLine);
	System::Widestrings::TWideStrings* __fastcall GetMacroList(const System::UnicodeString MacroName);
	bool __fastcall LoadValue(TfrxComponent* aComponent);
	void __fastcall SaveToXML(Frxxml::TfrxXMLItem* Item);
	void __fastcall LoadFromXML(Frxxml::TfrxXMLItem* Item);
	void __fastcall ResetSuppressed();
	void __fastcall ResetDuplicates(const System::UnicodeString BandName = System::UnicodeString());
	void __fastcall ProcessExpressions(TfrxReport* AReport, TfrxBand* ABand, TfrxProcessAtMode ProcessMode);
	void __fastcall ProcessObject(TfrxReport* AReport, TfrxComponent* aComponent);
	__property System::Classes::TStrings* Macroses = {read=FMacroses};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxCustomPreviewPages : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfrxAddPageAction FAddPageAction;
	int FCurPage;
	int FCurPreviewPage;
	int FFirstPage;
	TfrxCustomOutline* FOutline;
	TfrxReport* FReport;
	TfrxCustomEngine* FEngine;
	
protected:
	TfrxPostProcessor* FPostProcessor;
	virtual int __fastcall GetCount() = 0 ;
	virtual TfrxReportPage* __fastcall GetPage(int Index) = 0 ;
	virtual System::Types::TPoint __fastcall GetPageSize(int Index) = 0 ;
	
public:
	__fastcall virtual TfrxCustomPreviewPages(TfrxReport* AReport);
	__fastcall virtual ~TfrxCustomPreviewPages();
	virtual void __fastcall Clear() = 0 ;
	virtual void __fastcall Initialize() = 0 ;
	virtual void __fastcall AddObject(TfrxComponent* Obj) = 0 ;
	virtual void __fastcall AddPage(TfrxReportPage* Page) = 0 ;
	virtual void __fastcall AddSourcePage(TfrxReportPage* Page) = 0 ;
	virtual void __fastcall AddToSourcePage(TfrxComponent* Obj) = 0 ;
	virtual void __fastcall BeginPass() = 0 ;
	virtual void __fastcall ClearFirstPassPages() = 0 ;
	virtual void __fastcall CutObjects(int APosition) = 0 ;
	virtual void __fastcall DeleteObjects(int APosition) = 0 ;
	virtual void __fastcall DeleteAnchors(int From) = 0 ;
	virtual void __fastcall Finish() = 0 ;
	virtual void __fastcall IncLogicalPageNumber() = 0 ;
	virtual void __fastcall ResetLogicalPageNumber() = 0 ;
	virtual void __fastcall PasteObjects(System::Extended X, System::Extended Y) = 0 ;
	virtual void __fastcall ShiftAnchors(int From, int NewTop) = 0 ;
	virtual void __fastcall AddPicture(TfrxPictureView* Picture) = 0 ;
	virtual bool __fastcall BandExists(TfrxBand* Band) = 0 ;
	virtual int __fastcall GetCurPosition() = 0 ;
	virtual int __fastcall GetAnchorCurPosition() = 0 ;
	virtual System::Extended __fastcall GetLastY(System::Extended ColumnPosition = 0.000000E+00) = 0 ;
	virtual int __fastcall GetLogicalPageNo() = 0 ;
	virtual int __fastcall GetLogicalTotalPages() = 0 ;
	virtual void __fastcall AddEmptyPage(int Index) = 0 ;
	virtual void __fastcall DeletePage(int Index) = 0 ;
	virtual void __fastcall ModifyPage(int Index, TfrxReportPage* Page) = 0 ;
	virtual void __fastcall ModifyObject(TfrxComponent* Component) = 0 ;
	virtual void __fastcall DrawPage(int Index, Vcl::Graphics::TCanvas* Canvas, System::Extended ScaleX, System::Extended ScaleY, System::Extended OffsetX, System::Extended OffsetY, bool bHighlightEditable = false) = 0 ;
	virtual void __fastcall ObjectOver(int Index, int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, System::Extended Scale, System::Extended OffsetX, System::Extended OffsetY, TfrxPreviewIntEventParams &EventParams) = 0 ;
	virtual void __fastcall AddFrom(TfrxReport* Report) = 0 ;
	virtual void __fastcall LoadFromStream(System::Classes::TStream* Stream, bool AllowPartialLoading = false) = 0 ;
	virtual void __fastcall SaveToStream(System::Classes::TStream* Stream) = 0 ;
	virtual bool __fastcall SaveToFilter(TfrxCustomIOTransport* Filter, const System::UnicodeString FileName) = 0 ;
	virtual bool __fastcall LoadFromFile(const System::UnicodeString FileName, bool ExceptionIfNotFound = false) = 0 ;
	virtual void __fastcall SaveToFile(const System::UnicodeString FileName) = 0 ;
	virtual bool __fastcall Print() = 0 ;
	virtual bool __fastcall Export(TfrxCustomExportFilter* Filter) = 0 ;
	__property TfrxAddPageAction AddPageAction = {read=FAddPageAction, write=FAddPageAction, nodefault};
	__property int Count = {read=GetCount, nodefault};
	__property int CurPage = {read=FCurPage, write=FCurPage, nodefault};
	__property int CurPreviewPage = {read=FCurPreviewPage, write=FCurPreviewPage, nodefault};
	__property TfrxCustomEngine* Engine = {read=FEngine, write=FEngine};
	__property int FirstPage = {read=FFirstPage, write=FFirstPage, nodefault};
	__property TfrxCustomOutline* Outline = {read=FOutline};
	__property TfrxReportPage* Page[int Index] = {read=GetPage};
	__property System::Types::TPoint PageSize[int Index] = {read=GetPageSize};
	__property TfrxReport* Report = {read=FReport};
	__property TfrxPostProcessor* PostProcessor = {read=FPostProcessor};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxCustomPreview : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	TfrxCustomPreviewPages* FPreviewPages;
	TfrxReport* FReport;
	bool FUseReportHints;
	
protected:
	Vcl::Forms::TForm* FPreviewForm;
	TfrxComponentEditorsList* FInPlaceditorsList;
	TfrxSelectedObjectsList* FSelectionList;
	virtual void __fastcall DoFinishInPlace(System::TObject* Sender, bool Refresh, bool Modified);
	
public:
	__fastcall virtual TfrxCustomPreview(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomPreview();
	virtual void __fastcall SetDefaultEventParams(TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall Init(TfrxReport* aReport, TfrxCustomPreviewPages* aPrevPages) = 0 ;
	virtual void __fastcall UnInit(TfrxCustomPreviewPages* aPreviewPages) = 0 ;
	virtual void __fastcall Lock() = 0 ;
	virtual void __fastcall Unlock() = 0 ;
	virtual void __fastcall RefreshReport() = 0 ;
	virtual void __fastcall InternalCopy();
	virtual void __fastcall InternalPaste();
	virtual bool __fastcall InternalIsPasteAvailable();
	virtual void __fastcall InternalOnProgressStart(TfrxReport* Sender, TfrxProgressType ProgressType, int Progress) = 0 ;
	virtual void __fastcall InternalOnProgress(TfrxReport* Sender, TfrxProgressType ProgressType, int Progress) = 0 ;
	virtual void __fastcall InternalOnProgressStop(TfrxReport* Sender, TfrxProgressType ProgressType, int Progress) = 0 ;
	__property TfrxCustomPreviewPages* PreviewPages = {read=FPreviewPages, write=FPreviewPages};
	__property TfrxReport* Report = {read=FReport, write=FReport};
	__property bool UseReportHints = {read=FUseReportHints, write=FUseReportHints, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrxCustomPreview(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


typedef System::TMetaClass* TfrxCompressorClass;

class PASCALIMPLEMENTATION TfrxCustomCompressor : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	bool FIsFR3File;
	TfrxCompressorClass FOldCompressor;
	TfrxReport* FReport;
	System::Classes::TStream* FStream;
	System::UnicodeString FTempFile;
	TfrxSaveToCompressedFilter* FFilter;
	void __fastcall SetIsFR3File(const bool Value);
	
public:
	__fastcall virtual TfrxCustomCompressor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomCompressor();
	virtual bool __fastcall Decompress(System::Classes::TStream* Source) = 0 ;
	virtual void __fastcall Compress(System::Classes::TStream* Dest) = 0 ;
	void __fastcall CreateStream();
	__property bool IsFR3File = {read=FIsFR3File, write=SetIsFR3File, nodefault};
	__property TfrxReport* Report = {read=FReport, write=FReport};
	__property System::Classes::TStream* Stream = {read=FStream, write=FStream};
};


typedef System::TMetaClass* TfrxCrypterClass;

class PASCALIMPLEMENTATION TfrxCustomCrypter : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	System::Classes::TStream* FStream;
	
public:
	__fastcall virtual TfrxCustomCrypter(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfrxCustomCrypter();
	virtual bool __fastcall Decrypt(System::Classes::TStream* Source, const System::AnsiString Key) = 0 ;
	virtual void __fastcall Crypt(System::Classes::TStream* Dest, const System::AnsiString Key) = 0 ;
	void __fastcall CreateStream();
	__property System::Classes::TStream* Stream = {read=FStream, write=FStream};
};


typedef bool __fastcall (__closure *TfrxLoadEvent)(TfrxReport* Sender, System::Classes::TStream* Stream);

typedef System::Variant __fastcall (__closure *TfrxGetScriptValueEvent)(System::Variant &Params);

class PASCALIMPLEMENTATION TfrxFR2Events : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TfrxGetValueEvent FOnGetValue;
	System::Classes::TNotifyEvent FOnPrepareScript;
	TfrxLoadEvent FOnLoad;
	TfrxGetScriptValueEvent FOnGetScriptValue;
	System::UnicodeString FFilter;
	
public:
	__property TfrxGetValueEvent OnGetValue = {read=FOnGetValue, write=FOnGetValue};
	__property System::Classes::TNotifyEvent OnPrepareScript = {read=FOnPrepareScript, write=FOnPrepareScript};
	__property TfrxLoadEvent OnLoad = {read=FOnLoad, write=FOnLoad};
	__property TfrxGetScriptValueEvent OnGetScriptValue = {read=FOnGetScriptValue, write=FOnGetScriptValue};
	__property System::UnicodeString Filter = {read=FFilter, write=FFilter};
public:
	/* TObject.Create */ inline __fastcall TfrxFR2Events() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxFR2Events() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxGlobalDataSetList : public System::Classes::TList
{
	typedef System::Classes::TList inherited;
	
public:
	System::Syncobjs::TCriticalSection* FCriticalSection;
	__fastcall TfrxGlobalDataSetList();
	__fastcall virtual ~TfrxGlobalDataSetList();
	void __fastcall Lock();
	void __fastcall Unlock();
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TfrxInPlaceEditor : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TfrxComponent* FComponent;
	System::Classes::TComponent* FParentComponent;
	Vcl::Controls::TWinControl* FOwner;
	TfrxOnFinishInPlaceEdit FOnFinishInPlace;
	TfrxComponentClass FClassRef;
	System::Extended FOffsetX;
	System::Extended FOffsetY;
	System::Extended FScale;
	bool FLocked;
	TfrxComponentEditorsList* FEditors;
	TfrxSelectedObjectsList* FComponents;
	System::Classes::TPersistent* FClipboardObject;
	void __fastcall SetComponent(TfrxComponent* const Value);
	
public:
	__fastcall virtual TfrxInPlaceEditor(TfrxComponentClass aClassRef, Vcl::Controls::TWinControl* aOwner);
	__fastcall virtual ~TfrxInPlaceEditor();
	virtual System::Types::TRect __fastcall GetActiveRect();
	virtual bool __fastcall HasInPlaceEditor();
	virtual bool __fastcall HasCustomEditor();
	virtual void __fastcall DrawCustomEditor(Vcl::Graphics::TCanvas* aCanvas, const System::Types::TRect &aRect);
	void __fastcall SetOffset(System::Extended aOffsetX, System::Extended aOffsetY, System::Extended aScale);
	virtual bool __fastcall FillData();
	virtual void __fastcall EditInPlace(System::Classes::TComponent* aParent, const System::Types::TRect &aRect);
	virtual bool __fastcall EditInPlaceDone();
	virtual void __fastcall DoFinishInPlace(System::TObject* Sender, bool Refresh, bool Modified);
	virtual bool __fastcall DoCustomDragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoCustomDragDrop(System::TObject* Source, int X, int Y, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	virtual bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall InitializeUI(TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall FinalizeUI(TfrxInteractiveEventsParams &EventParams);
	virtual void __fastcall CopyGoupContent(TfrxComponent* CopyFrom, TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, TfrxCopyPasteType CopyAs = (TfrxCopyPasteType)(0x0));
	virtual void __fastcall PasteGoupContent(TfrxComponent* PasteTo, TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, TfrxCopyPasteType PasteAs = (TfrxCopyPasteType)(0x0));
	virtual void __fastcall CopyContent(TfrxComponent* CopyFrom, TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, TfrxCopyPasteType CopyAs = (TfrxCopyPasteType)(0x0));
	virtual void __fastcall PasteContent(TfrxComponent* PasteTo, TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, TfrxCopyPasteType PasteAs = (TfrxCopyPasteType)(0x0));
	virtual bool __fastcall IsPasteAvailable(TfrxComponent* PasteTo, TfrxInteractiveEventsParams &EventParams, TfrxCopyPasteType PasteAs = (TfrxCopyPasteType)(0x0));
	virtual TfrxCopyPasteType __fastcall DefaultContentType();
	__property TfrxComponent* Component = {read=FComponent, write=SetComponent};
	__property System::Classes::TComponent* ParentComponent = {read=FParentComponent, write=FParentComponent};
	__property TfrxOnFinishInPlaceEdit OnFinishInPlace = {read=FOnFinishInPlace, write=FOnFinishInPlace};
	__property bool Locked = {read=FLocked, nodefault};
	__property TfrxComponentEditorsList* Editors = {read=FEditors, write=FEditors};
	__property System::Classes::TPersistent* ClipboardObject = {read=FClipboardObject, write=FClipboardObject};
};


typedef System::TMetaClass* TfrxInPlaceEditorClass;

typedef System::TMetaClass* TfrxCustomIOTransportClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxComponentEditorsRegItem : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::Classes::TList* FEditorsGlasses;
	System::Classes::TList* FEditorsVisibility;
	TfrxComponentClass FComponentClass;
	__fastcall TfrxComponentEditorsRegItem();
	__fastcall virtual ~TfrxComponentEditorsRegItem();
};

#pragma pack(pop)

typedef System::DynamicArray<System::Types::TRect> TfrxRectArray;

class PASCALIMPLEMENTATION TfrxComponentEditorsManager : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Extended FOffsetX;
	System::Extended FOffsetY;
	System::Extended FScale;
	System::Classes::TList* FEditorsGlasses;
	TfrxComponentClass FComponentClass;
	TfrxComponent* __fastcall GetComponent();
	void __fastcall SetComponent(TfrxComponent* const Value);
	
public:
	TfrxRectArray __fastcall EditorsActiveRects(TfrxComponent* aComponent);
	void __fastcall DrawCustomEditor(Vcl::Graphics::TCanvas* aCanvas, const System::Types::TRect &aRect);
	bool __fastcall DoCustomDragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept, TfrxInteractiveEventsParams &EventParams);
	bool __fastcall DoCustomDragDrop(System::TObject* Source, int X, int Y, TfrxInteractiveEventsParams &EventParams);
	void __fastcall SetOffset(System::Extended aOffsetX, System::Extended aOffsetY, System::Extended aScale);
	bool __fastcall DoMouseMove(int X, int Y, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	bool __fastcall DoMouseUp(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	bool __fastcall DoMouseDown(int X, int Y, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, TfrxInteractiveEventsParams &EventParams);
	bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos, TfrxInteractiveEventsParams &EventParams);
	void __fastcall InitializeUI(TfrxInteractiveEventsParams &EventParams);
	void __fastcall FinalizeUI(TfrxInteractiveEventsParams &EventParams);
	void __fastcall CopyContent(TfrxComponent* CopyFrom, TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, TfrxCopyPasteType CopyAs = (TfrxCopyPasteType)(0x0));
	void __fastcall PasteContent(TfrxComponent* PasteTo, TfrxInteractiveEventsParams &EventParams, System::Classes::TStream* Buffer, TfrxCopyPasteType PasteAs = (TfrxCopyPasteType)(0x0));
	bool __fastcall IsPasteAvailable(TfrxComponent* PasteTo, TfrxInteractiveEventsParams &EventParams, TfrxCopyPasteType PasteAs = (TfrxCopyPasteType)(0x0));
	bool __fastcall IsContain(const System::Types::TRect &ObjectRect, System::Extended X, System::Extended Y);
	void __fastcall SetClipboardObject(System::Classes::TPersistent* const aObject);
	__fastcall TfrxComponentEditorsManager();
	__fastcall virtual ~TfrxComponentEditorsManager();
	__property TfrxComponent* Component = {read=GetComponent, write=SetComponent};
};


enum DECLSPEC_DENUM TfrxComponentEditorVisibilityState : unsigned char { evPreview, evDesigner };

typedef System::Set<TfrxComponentEditorVisibilityState, TfrxComponentEditorVisibilityState::evPreview, TfrxComponentEditorVisibilityState::evDesigner> TfrxComponentEditorVisibility;

class PASCALIMPLEMENTATION TfrxComponentEditorsList : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
private:
	System::Classes::TList* FEditorsInstances;
	TfrxComponentEditorsManager* __fastcall GetEditors(int Index);
	void __fastcall PutEditors(int Index, TfrxComponentEditorsManager* const Value);
	
public:
	__fastcall TfrxComponentEditorsList()/* overload */;
	__fastcall virtual ~TfrxComponentEditorsList();
	void __fastcall CreateInstanceFromItem(TfrxComponentEditorsRegItem* aItem, Vcl::Controls::TWinControl* aOwner, TfrxComponentEditorVisibilityState aVisibility);
	__property TfrxComponentEditorsManager* Editors[int Index] = {read=GetEditors, write=PutEditors};
public:
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsList(bool OwnsObjects)/* overload */ : System::Classes::TStringList(OwnsObjects) { }
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsList(System::WideChar QuoteChar, System::WideChar Delimiter)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter) { }
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsList(System::WideChar QuoteChar, System::WideChar Delimiter, System::Classes::TStringsOptions Options)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter, Options) { }
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsList(System::Types::TDuplicates Duplicates, bool Sorted, bool CaseSensitive)/* overload */ : System::Classes::TStringList(Duplicates, Sorted, CaseSensitive) { }
	
};


class PASCALIMPLEMENTATION TfrxComponentEditorsClasses : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
private:
	TfrxComponentEditorsRegItem* __fastcall GetEditors(int Index);
	void __fastcall PutEditors(int Index, TfrxComponentEditorsRegItem* const Value);
	
public:
	__fastcall virtual ~TfrxComponentEditorsClasses();
	TfrxComponentEditorsList* __fastcall CreateEditorsInstances(TfrxComponentEditorVisibilityState aVisibility, Vcl::Controls::TWinControl* aOwner);
	void __fastcall Register(TfrxComponentClass ComponentClass, TfrxInPlaceEditorClass *ComponentEditors, const int ComponentEditors_High, TfrxComponentEditorVisibility *EditorsVisibility, const int EditorsVisibility_High);
	void __fastcall UnRegister(TfrxComponentClass ComponentClass);
	void __fastcall UnRegisterEditor(TfrxInPlaceEditorClass EditroClass);
	void __fastcall SaveToIni(System::Inifiles::TCustomIniFile* IniFile);
	void __fastcall LoadFromIni(System::Inifiles::TCustomIniFile* IniFile);
	__property TfrxComponentEditorsRegItem* EditorsClasses[int Index] = {read=GetEditors, write=PutEditors};
public:
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsClasses()/* overload */ : System::Classes::TStringList() { }
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsClasses(bool OwnsObjects)/* overload */ : System::Classes::TStringList(OwnsObjects) { }
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsClasses(System::WideChar QuoteChar, System::WideChar Delimiter)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter) { }
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsClasses(System::WideChar QuoteChar, System::WideChar Delimiter, System::Classes::TStringsOptions Options)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter, Options) { }
	/* TStringList.Create */ inline __fastcall TfrxComponentEditorsClasses(System::Types::TDuplicates Duplicates, bool Sorted, bool CaseSensitive)/* overload */ : System::Classes::TStringList(Duplicates, Sorted, CaseSensitive) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::Extended fr01cm;
extern DELPHI_PACKAGE System::Extended fr1cm;
extern DELPHI_PACKAGE System::Extended fr01in;
extern DELPHI_PACKAGE int fr1in;
extern DELPHI_PACKAGE System::Extended fr1CharX;
extern DELPHI_PACKAGE int fr1CharY;
extern DELPHI_PACKAGE System::Uitypes::TColor clTransparent;
extern DELPHI_PACKAGE int crHand;
extern DELPHI_PACKAGE int crZoom;
extern DELPHI_PACKAGE int crFormat;
extern DELPHI_PACKAGE System::UnicodeString DEF_REG_CONNECTIONS;
static const System::Word WM_CREATEHANDLE = System::Word(0x401);
static const System::Word WM_DESTROYHANDLE = System::Word(0x402);
static const System::Word FRX_OWNER_DESTROY_MESSAGE = System::Word(0xd001);
extern DELPHI_PACKAGE TfrxCustomIOTransportClass frxDefaultIOTransportClass;
extern DELPHI_PACKAGE TfrxCustomIOTransportClass frxDefaultIODialogTransportClass;
extern DELPHI_PACKAGE TfrxCustomIOTransportClass frxDefaultTempFilterClass;
extern DELPHI_PACKAGE TfrxDesignerClass frxDesignerClass;
extern DELPHI_PACKAGE TfrxCustomExportFilter* frxDotMatrixExport;
extern DELPHI_PACKAGE TfrxCompressorClass frxCompressorClass;
extern DELPHI_PACKAGE TfrxCrypterClass frxCrypterClass;
extern DELPHI_PACKAGE int frxCharset;
extern DELPHI_PACKAGE TfrxFR2Events* frxFR2Events;
extern DELPHI_PACKAGE System::Syncobjs::TCriticalSection* frxCS;
extern DELPHI_PACKAGE Frxvariables::TfrxVariables* frxGlobalVariables;
#define FR_VERSION L"6.3.3"
static const System::Int8 BND_COUNT = System::Int8(0x12);
extern DELPHI_PACKAGE System::StaticArray<TfrxComponentClass, 18> frxBands;
extern DELPHI_PACKAGE Vcl::Forms::TForm* __fastcall frxParentForm(void);
extern DELPHI_PACKAGE TfrxDataSet* __fastcall frxFindDataSet(TfrxDataSet* DataSet, const System::UnicodeString Name, System::Classes::TComponent* Owner);
extern DELPHI_PACKAGE void __fastcall frxGetDataSetList(System::Classes::TStrings* List);
extern DELPHI_PACKAGE TfrxCustomFill* __fastcall frxCreateFill(const TfrxFillType Value);
extern DELPHI_PACKAGE TfrxFillType __fastcall frxGetFillType(TfrxCustomFill* const Value);
extern DELPHI_PACKAGE TfrxComponentEditorsClasses* __fastcall frxRegEditorsClasses(void);
extern DELPHI_PACKAGE TfrxComponentEditorsManager* __fastcall frxGetInPlaceEditor(TfrxComponentEditorsList* aList, TfrxComponent* aComponent);
}	/* namespace Frxclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXCLASS)
using namespace Frxclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxclassHPP
