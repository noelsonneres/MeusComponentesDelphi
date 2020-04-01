// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxADO26.dpk' rev: 33.00 (Windows)

#ifndef Frxado26HPP
#define Frxado26HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// (rtl)
#include <SysInit.hpp>
#include <frxADOComponents.hpp>
#include <frxADOEditor.hpp>
#include <frxADORTTI.hpp>
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
#include <Data.SqlTimSt.hpp>	// (dbrtl)
#include <Data.FmtBcd.hpp>	// (dbrtl)
#include <Data.DB.hpp>	// (dbrtl)
#include <Vcl.DBLogDlg.hpp>	// (vcldb)
#include <Vcl.DBPWDlg.hpp>	// (vcldb)
#include <Vcl.DBCtrls.hpp>	// (vcldb)
#include <Vcl.Grids.hpp>	// (vcl)
#include <Vcl.CheckLst.hpp>	// (vclx)
#include <Vcl.DBGrids.hpp>	// (vcldb)
#include <fqbRes.hpp>	// (fqb260)
#include <fqbrcDesign.hpp>	// (fqb260)
#include <fqbClass.hpp>	// (fqb260)
#include <frxSynMemo.hpp>	// (frx26)
#include <frxConnWizard.hpp>	// (frxDB26)
#include <frxCustomDBEditor.hpp>	// (frxDB26)
#include <fs_idbrtti.hpp>	// (fsDB26)
#include <frxCustomDBRTTI.hpp>	// (frxDB26)
#include <frxCustomDB.hpp>	// (frxDB26)
#include <Data.Win.ADODB.hpp>	// (adortl)
#include <fs_iadortti.hpp>	// (fsADO26)
// PRG_EXT: .bpl
// OBJ_EXT: .obj

//-- user supplied -----------------------------------------------------------

namespace Frxado26
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxado26 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXADO26)
using namespace Frxado26;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frxado26HPP
