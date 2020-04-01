{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit fr6_lazarus;

{$warn 5023 off : no warning about unused units}
interface

uses
  frxXML, frxClass, frxBarcode, frxPrinter, frxCtrls, frxUtils, frxDock, 
  frxChBox, frxDBSet, frxGradient, frxCross, frxDesgnCtrls, frxBarcod, 
  frxDCtrl, frxDesgn, frxPreview, frxXMLSerializer, 
  frxLazarusComponentEditors, frxDelphiZXingQRCode, frxAbout, frxAggregate, 
  frxBarcode2D, frxBarcode2DBase, frxBarcode2DRTTI, frxBarcodeDataMatrix, 
  frxBarcodeEditor, frxBarcodePDF417, frxBarcodeProperties, frxBarcodeQR, 
  frxBarcodeRTTI, frxChBoxRTTI, frxChm, frxClassRTTI, frxCodeUtils, 
  frxCollections, frxConnEditor, frxConnItemEdit, frxConnWizard, 
  frxCrossEditor, frxCrossRTTI, frxCrypt, frxCustomDB, frxCustomDBEditor, 
  frxCustomDBRTTI, frxCustomEditors, frxDataTree, frxDCtrlRTTI, 
  frxDesgnEditors, frxDesgnWorkspace, frxDesgnWorkspace1, frxDialogForm, 
  frxDsgnIntf, frxEditAliases, frxEditDataBand, frxEditExpr, frxEditFill, 
  frxEditFormat, frxEditFrame, frxEditGroup, frxEditHighlight, 
  frxEditHyperlink, frxEditMD, frxEditMemo, frxEditOptions, frxEditPage, 
  frxEditPicture, frxEditQueryParams, frxEditReport, frxEditReportData, 
  frxEditSQL, frxEditStrings, frxEditStyle, frxEditSysMemo, frxEditTabOrder, 
  frxEditVar, frxEngine, frxEvaluateForm, frxGradientRTTI, frxGraphicUtils, 
  frxGZip, frxInheritError, frxInsp, frxmd5, frxNewItem, frxPassw, 
  frxPictureCache, frxPopupForm, frxPreviewPages, frxPreviewPageSettings, 
  frxPrintDialog, frxProgress, frxrcClass, frxrcDesgn, frxrcInsp, 
  frxReportTree, frxRes, frxSearchDialog, frxStdWizard, frxSynMemo, 
  frxUnicodeCtrls, frxUnicodeUtils, frxVariables, frxWatchForm, frxZLib, 
  frxInPlaceClipboards, frxInPlaceEditors, frxLazBWForm, frxTableObjectRTTI, 
  frxTableObject, frxTableObjectClipboard, frxTableObjectEditor, frxReg, 
  frxCellularTextObject, frxGaugeView, frxGauge, frxGaugeDialogControl, 
  frxGaugeEditor, frxGaugePanel, frxGaugeViewRTTI, frxVectorCanvas, 
  frxMapHelpers, frxMap, frxMapColorRangeForm, frxMapILEditor, 
  frxMapInteractiveLayer, frxMapLayer, frxMapRanges, frxMapShape, 
  frxMapSizeRangeForm, frxMapLayerTags, frxMapShapeTags, frxMapEditor, 
  frxMapInPlaceEditor, frxMapLayerForm, frxMapRTTI, frxAnaliticGeometry, 
  frxGPXFileFormat, frxOSMFileFormat, frxERSIShapeFileFormat, 
  frxERSIShapeDBFImport, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('frxLazarusComponentEditors', 
    @frxLazarusComponentEditors.Register);
  RegisterUnit('frxReg', @frxReg.Register);
end;

initialization
  RegisterPackage('fr6_lazarus', @Register);
end.
