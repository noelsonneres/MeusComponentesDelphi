// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxIntIO26.dpk' rev: 33.00 (Windows)

#ifndef Frxintio26HPP
#define Frxintio26HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// (rtl)
#include <SysInit.hpp>
#include <frxBaseSocketIOHandler.hpp>
#include <frxTransportHTTP.hpp>
#include <frxOpenSSL.hpp>
#include <frxIOTransportDropbox.hpp>
#include <frxIOTransportOneDrive.hpp>
#include <frxIOTransportBoxCom.hpp>
#include <frxIOTransportGoogleDrive.hpp>
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
#include <System.SyncObjs.hpp>	// (rtl)
#include <Winapi.ShellAPI.hpp>	// (rtl)
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
#include <Winapi.UxTheme.hpp>	// (rtl)
#include <Vcl.GraphUtil.hpp>	// (vcl)
#include <Vcl.StdCtrls.hpp>	// (vcl)
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
#include <frxNetUtils.hpp>	// (frx26)
#include <frxMapHelpers.hpp>	// (frx26)
#include <Vcl.AxCtrls.hpp>	// (vcl)
#include <Vcl.OleCtrls.hpp>	// (vcl)
#include <frxFPUMask.hpp>	// (frxIntIOBase26)
#include <Vcl.OleServer.hpp>	// (vcl)
#include <SHDocVw.hpp>	// (vclie)
#include <frxSaveFilterBrowser.hpp>	// (frxIntIOBase26)
#include <System.JSON.hpp>	// (rtl)
// PRG_EXT: .bpl
// OBJ_EXT: .obj

//-- user supplied -----------------------------------------------------------

namespace Frxintio26
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxintio26 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXINTIO26)
using namespace Frxintio26;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frxintio26HPP
