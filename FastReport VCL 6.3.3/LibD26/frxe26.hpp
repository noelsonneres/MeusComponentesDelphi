// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxe26.dpk' rev: 33.00 (Windows)

#ifndef Frxe26HPP
#define Frxe26HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// (rtl)
#include <SysInit.hpp>
#include <frxExportImage.hpp>
#include <GIF.hpp>
#include <frxImageConverter.hpp>
#include <frxExportMatrix.hpp>
#include <frxExportCSV.hpp>
#include <frxExportText.hpp>
#include <frxZip.hpp>
#include <frxrcExports.hpp>
#include <frxSendMAPI.hpp>
#include <frxExportHTML.hpp>
#include <frxExportPDF.hpp>
#include <frxExportPDFHelpers.hpp>
#include <frxEMFAbstractExport.hpp>
#include <frxEMFFormat.hpp>
#include <frxEMFtoSVGExport.hpp>
#include <frxEMFtoPDFExport.hpp>
#include <frxExportRTF.hpp>
#include <frxRC4.hpp>
#include <frxGML.hpp>
#include <frxExportHelpers.hpp>
#include <frxCrypto.hpp>
#include <frxExportBaseDialog.hpp>
#include <frxSMTP.hpp>
#include <frxExportMail.hpp>
#include <frxExportODF.hpp>
#include <frxExportDBF.hpp>
#include <frxExportBIFF.hpp>
#include <frxExportXLS.hpp>
#include <frxExportXML.hpp>
#include <frxExportSVG.hpp>
#include <frxCBFF.hpp>
#include <frxOLEPS.hpp>
#include <frxDraftPool.hpp>
#include <frxBiffConverter.hpp>
#include <frxBIFF.hpp>
#include <frxEscher.hpp>
#include <frxExportHTMLDiv.hpp>
#include <frxExportDOCX.hpp>
#include <frxExportPPTX.hpp>
#include <frxExportXLSX.hpp>
#include <frxOfficeOpen.hpp>
#include <frxExportXLSDialog.hpp>
#include <frxExportXLSXDialog.hpp>
#include <frxExportPPTXDialog.hpp>
#include <frxExportDOCXDialog.hpp>
#include <frxExportHTMLDivDialog.hpp>
#include <frxExportSVGDialog.hpp>
#include <frxExportBIFFDialog.hpp>
#include <frxExportODFDialog.hpp>
#include <frxExportXMLDialog.hpp>
#include <frxExportRTFDialog.hpp>
#include <frxExportPDFDialog.hpp>
#include <frxExportHTMLDialog.hpp>
#include <frxExportTextDialog.hpp>
#include <frxExportCSVDialog.hpp>
#include <frxExportImageDialog.hpp>
#include <frxTrueTypeCollection.hpp>
#include <frxTrueTypeFont.hpp>
#include <frxCmapTableClass.hpp>
#include <frxGlyphTableClass.hpp>
#include <frxGlyphSubstitutionClass.hpp>
#include <frxHorizontalHeaderClass.hpp>
#include <frxHorizontalMetrixClass.hpp>
#include <frxIndexToLocationClass.hpp>
#include <frxKerningTableClass.hpp>
#include <frxPostScriptClass.hpp>
#include <frxMaximumProfileClass.hpp>
#include <frxOS2WindowsMetricsClass.hpp>
#include <frxPreProgramClass.hpp>
#include <frxNameTableClass.hpp>
#include <frxFontHeaderClass.hpp>
#include <frxTrueTypeTable.hpp>
#include <TTFHelpers.hpp>
#include <System.UITypes.hpp>	// (rtl)
#include <Winapi.Windows.hpp>	// (rtl)
#include <Winapi.PsAPI.hpp>	// (rtl)
#include <System.Character.hpp>	// (rtl)
#include <System.Internal.ExcUtils.hpp>	// (rtl)
#include <System.SysUtils.hpp>	// (rtl)
#include <System.VarUtils.hpp>	// (rtl)
#include <System.Variants.hpp>	// (rtl)
#include <System.Math.hpp>	// (rtl)
#include <System.Rtti.hpp>	// (rtl)
#include <System.TypInfo.hpp>	// (rtl)
#include <System.Generics.Defaults.hpp>	// (rtl)
#include <System.Classes.hpp>	// (rtl)
#include <System.TimeSpan.hpp>	// (rtl)
#include <System.DateUtils.hpp>	// (rtl)
#include <System.IOUtils.hpp>	// (rtl)
#include <System.IniFiles.hpp>	// (rtl)
#include <System.Win.Registry.hpp>	// (rtl)
#include <System.UIConsts.hpp>	// (rtl)
#include <Vcl.Graphics.hpp>	// (vcl)
#include <System.Messaging.hpp>	// (rtl)
#include <System.Actions.hpp>	// (rtl)
#include <Vcl.ActnList.hpp>	// (vcl)
#include <System.HelpIntfs.hpp>	// (rtl)
#include <System.SyncObjs.hpp>	// (rtl)
#include <Winapi.UxTheme.hpp>	// (rtl)
#include <Vcl.GraphUtil.hpp>	// (vcl)
#include <Vcl.StdCtrls.hpp>	// (vcl)
#include <Winapi.ShellAPI.hpp>	// (rtl)
#include <Vcl.Printers.hpp>	// (vcl)
#include <Vcl.Clipbrd.hpp>	// (vcl)
#include <Vcl.ComCtrls.hpp>	// (vcl)
#include <Vcl.Dialogs.hpp>	// (vcl)
#include <Vcl.ExtCtrls.hpp>	// (vcl)
#include <Vcl.Themes.hpp>	// (vcl)
#include <System.AnsiStrings.hpp>	// (rtl)
#include <System.Win.ComObj.hpp>	// (rtl)
#include <Winapi.FlatSB.hpp>	// (rtl)
#include <Vcl.Forms.hpp>	// (vcl)
#include <Vcl.Menus.hpp>	// (vcl)
#include <Winapi.MsCTF.hpp>	// (rtl)
#include <Vcl.Controls.hpp>	// (vcl)
#include <Vcl.Buttons.hpp>	// (vcl)
#include <Vcl.Imaging.pngimage.hpp>	// (vclimg)
#include <frxChm.hpp>	// (frx26)
#include <fs_iconst.hpp>	// (fs26)
#include <frxRes.hpp>	// (frx26)
#include <fs_itools.hpp>	// (fs26)
#include <fs_iinterpreter.hpp>	// (fs26)
#include <frxDsgnIntf.hpp>	// (frx26)
#include <frxDMPClass.hpp>	// (frx26)
#include <frxStorage.hpp>	// (frx26)
#include <frxPrinter.hpp>	// (frx26)
#include <frxSearchDialog.hpp>	// (frx26)
#include <Vcl.OleCtnrs.hpp>	// (vcl)
#include <frxRichEdit.hpp>	// (frx26)
#include <frxUnicodeCtrls.hpp>	// (frx26)
#include <frxInPlaceClipboards.hpp>	// (frx26)
#include <frxInPlaceEditors.hpp>	// (frx26)
#include <frxIOTransportIntf.hpp>	// (frx26)
#include <frxIOTransportDialog.hpp>	// (frx26)
#include <frxPreview.hpp>	// (frx26)
#include <frxGraphicUtils.hpp>	// (frx26)
#include <frxrcClass.hpp>	// (frx26)
#include <fs_iclassesrtti.hpp>	// (fs26)
#include <fs_igraphicsrtti.hpp>	// (fs26)
#include <fs_iformsrtti.hpp>	// (fs26)
#include <Vcl.Imaging.jpeg.hpp>	// (vclimg)
#include <frxClassRTTI.hpp>	// (frx26)
#include <fs_ipascal.hpp>	// (fs26)
#include <fs_icpp.hpp>	// (fs26)
#include <fs_ibasic.hpp>	// (fs26)
#include <fs_ijs.hpp>	// (fs26)
#include <fs_idialogsrtti.hpp>	// (fs26)
#include <fs_iinirtti.hpp>	// (fs26)
#include <frxClass.hpp>	// (frx26)
#include <Winapi.Mapi.hpp>	// (rtl)
#include <frxNetUtils.hpp>	// (frx26)
#include <frxChBoxRTTI.hpp>	// (frx26)
#include <frxChBox.hpp>	// (frx26)
#include <frxGradientRTTI.hpp>	// (frx26)
#include <frxGradient.hpp>	// (frx26)
// PRG_EXT: .bpl
// OBJ_EXT: .obj

//-- user supplied -----------------------------------------------------------

namespace Frxe26
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxe26 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXE26)
using namespace Frxe26;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frxe26HPP
