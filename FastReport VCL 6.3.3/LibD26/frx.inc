{$DEFINE QBUILDER}
{******************************************}
{                                          }
{             FastReport v4.0              }
{              Include file                }
{                                          }
{         Copyright (c) 1998-2006          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

{$DEFINE FR6VCL}
{$B-} {- Complete Boolean Evaluation }
{$R-} {- Range-Checking }
{$T-} {- Typed @ operator }
{$P+} {- Open string params }
{$H+} {- Use long strings by default }

{$IFNDEF FPC}
  {$V-} {- Var-String Checking }
  {$X+} {- Extended syntax }
  {$J+} {- Writeable structured consts }
{$ENDIF}

{$IFDEF VER120}      // Delphi 4.0
  {$DEFINE Delphi4}
{$ENDIF}

{$IFDEF VER130}      // Delphi 5.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
{$ENDIF}

{$IFDEF VER140}      // Delphi 6.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
{$ENDIF}

{$IFDEF VER150}      // Delphi 7.0 è 7.1
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
{$ENDIF}

{$IFDEF VER170}      // Delphi 9.0 => Delphi 2005
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER180}      // Delphi 10.0 => Delphi 2006
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER185}      // Delphi 11.0 => Delphi 2007
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER190}      // Delphi 11.0 => Delphi 2007 for .Net
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER200}      // Delphi 12.0 => Delphi 2009
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER210} // Rad Studio 13.0 => Delphi 2010
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER220} // Rad Studio XE
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}


{$IFDEF VER230} // Rad Studio XE 2
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER240} // Rad Studio XE 3
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER250} // Rad Studio XE 4
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER260} // Rad Studio XE 5
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER270} // Rad Studio XE 6
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER280} // Rad Studio XE 7
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER290} // Rad Studio XE 8
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER300} // RAD Studio 10 Seattle
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi23}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER310} // RAD Studio 10.1 Berlin
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi23}
  {$DEFINE Delphi24}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER320} // RAD Studio 10.2 
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi23}
  {$DEFINE Delphi24}
  {$DEFINE Delphi25}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER330} // RAD Studio XXX
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi23}
  {$DEFINE Delphi24}
  {$DEFINE Delphi25}
  {$DEFINE Delphi26}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER125}      // Borland C++ Builder 4.0
  {$DEFINE Delphi4}
  {$ObjExportAll On}
  {$DEFINE BCB}
  {$DEFINE RICHBCB}
{$ENDIF}

{$IFDEF VER130}      // Borland C++ Builder 5.0
  {$IFDEF BCB}
    {$ObjExportAll On}
    {$DEFINE RICHBCB}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER140}      // Borland C++ Builder 6.0
  {$IFDEF BCB}
    {$ObjExportAll On}
    {$DEFINE RICHBCB}
  {$ENDIF}
{$ENDIF}

{$IFDEF FPC} // Free pascal compiler
  {$IFDEF CPUX86_64}
    {$DEFINE CPUX64}
  {$ENDIF}
  {$UNDEF Delphi16}
  {$UNDEF FR_VER_BASIC}
  {$MODE DELPHI}
  {$H+}
  {$PACKSET 1}
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {.$DEFINE QBUILDER}
  {$UNDEF FR_FIB}
  {$DEFINE FPCUNICODE} // TODO: use only FPCUNICODE and remove NOUSEFRUNICODEUTILS
  {$DEFINE NOUSEFRUNICODEUTILS} // uncomment for using frxUnicodeUtils and friends
  {$IFNDEF MSWINDOWS}
  {$DEFINE FPCUSEONECHARCUTWORKAROUND} // test for cut-off of one char on memo fields ?!?
  {$ENDIF}
  // for some reason Report.Datasets are not reloaded with FPC
  {$DEFINE FPCLOOSEDATASETS}
  // LCL doesn't have emf, so we use internal implementation (lmf4 unit)
  {$DEFINE FPCUSELMFFOREMF}
  {. $DEFINE FPCUSEPDFPRINTER} // available only with qt, so disabled atm.
  {$IFNDEF MSWINDOWS}
  {$DEFINE DEBUGFR4}
  {$DEFINE DEBUGFR4XML}
  {$DEFINE DEBUGFR4DESIGNER}
  {. $DEFINE DEBUGFR4PRINTERS}
  {. $DEFINE FPCDEBUGFR2TOFR4}
  {. $DEFINE FPCDEBUGFR2TOFR4SCRIPT}
  {$ENDIF}
  // this define is used ONLY by frxPrinter.
  // win32 lcl uses native implementation, while
  // others (including qt and gtk2 on windows) uses OSPrinters.
  {$DEFINE NONWINFPC}
  {$IFDEF MSWINDOWS}
  {$IFNDEF LCLQt}
  {$UNDEF NONWINFPC}
  {$ENDIF}
  {$ENDIF}
  //qt and carbon does not support painting outside of paint event
  {$IF DEFINED(LCLQt) or DEFINED(LCLCarbon)}
  {$DEFINE FPC_NOPAINTOUTSIDEPAINTEVENT}
  {$IFEND}
  {$DEFINE FRX_USE_BITMAP_MAP}
{$ENDIF}

// Uncomment the following line if you don't want to include component editors
// into your exe (in case if you don't use designer)
//{$DEFINE NO_EDITORS}

//-------------------------Additional components----------------------------

//---------------- GetMessage Hook----------------------------------
// Hook to GetMessage function for unicode input support (D4-7, BCB4-BCB6)
//{$DEFINE HOOK_WNDPROC_FOR_UNICODE}

//------------------- JPEG images -----------------------------------
// JPEG images. Adds approximately 100Kb to your EXE.
// If you want to show jpeg images in "Picture" object, uncomment
// the following line:
{$IFNDEF FPC} // Free pascal compiler
{$DEFINE JPEG}
{$ENDIF}

//------------------- PNG images -----------------------------------
// PNG images. If you want to show png images in "Picture" object, uncomment
// the following line:
{$IFNDEF FPC} // Free pascal compiler
{$DEFINE PNG}
{$ENDIF}

//------------------- MAP object -----------------------------------
//{$DEFINE FRX_USE_BITMAP_MAP}

{$IFDEF FRX_USE_BITMAP_MAP}
{$DEFINE FRX_DONT_USE_METAFILE_MAP}
{$ENDIF}

//------------------- "Open Picture" dialog -------------------------
// Adds approximately 60Kb to your EXE.
// If you want to use standard "Open picture" dialog in picture editor,
// uncomment the following line:
//{$DEFINE OPENPICTUREDLG}

//------------------- Visual Query builder --------------------------
// To use visual query builder, you should install FastQBuilder component.
// It is included in FR3 Pro and FR3 EE by default.
//{$DEFINE QBUILDER}

//------------------- TTabSet control -------------------------------
// In Delphi2005 and BDS2006 you can use TTabSet control instead of TTabControl
// to make a report designer more soft-looked.
{$IFNDEF FPC}
{$DEFINE UseTabset}
{$ENDIF}
//-------------------Use INDY for e-mail export ---------------------
//{$DEFINE USE_INDY}
//----------- Use INDY 9 instead of 10 for save filters -------------
// comment these lines if you have indy 10 on Delphi 7
//{$IFDEF USE_INDY}
{$IFNDEF Delphi9}
{$DEFINE INDY9}
{$DEFINE INDYPARAM_INT}
{$ENDIF}

{$IFDEF Delphi9}
{$DEFINE INDY10_1}
{$DEFINE INDYPARAM_INT}
{$DEFINE INDY10_2005}
{$DEFINE INDYFTP10_2005}
{$ENDIF}

{$IFDEF Delphi10}
{$UNDEF INDYFTP10_2005}
{$ENDIF}

{$IFDEF Delphi12}
{$UNDEF INDY10_2005}
{$ENDIF}

{$IFDEF Delphi12}
{$UNDEF INDYPARAM_INT}
{$ENDIF}

{$IFDEF Delphi16}
{$UNDEF INDY10_1}
{$ENDIF}
//{$ENDIF}

//--------Use custom version of Indy 10 (not from RAD)---------------
//{$DEFINE CUSTOM_INDY}
{$IFDEF CUSTOM_INDY}
{$UNDEF INDY9}
{$UNDEF INDYFTP10_2005}
{$UNDEF INDY10_2005}
{$UNDEF INDYPARAM_INT}
{$UNDEF INDY10_1}
{$ENDIF}

//------------------- Group DB components ---------------------------
// Use it to group all frxDB components.
//{$DEFINE DB_CAT}

//{$DEFINE FR_VER_BASIC}

{$IFDEF FR_COM}
  {$IFDEF FR_LITE}
     {$DEFINE FR_VER_BASIC}
  {$ENDIF}
{$ENDIF}

{$IFNDEF Delphi9}
  {$UNDEF UseTabset}
{$ENDIF}

{$IFDEF Delphi4}
  {$IFDEF FR_VER_BASIC}
    {$DEFINE NO_CRITICAL_SECTION}
  {$ENDIF}
{$ENDIF}

