{*******************************************}
{                                           }
{           FastQueryBuilder v1.03          }
{               Include file                }
{                                           }
{          Copyright (c) 2004-2015          }
{              Fast Reports Inc.            }
{                                           }
{*******************************************}


{$B-} {- Complete Boolean Evaluation }
{$R-} {- Range-Checking }
{$V-} {- Var-String Checking }
{$T-} {- Typed @ operator }
{$X+} {- Extended syntax }
{$P+} {- Open string params }
{$J+} {- Writeable structured consts }
{$H+} {- Use long strings by default }

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
{$ENDIF}

{$IFDEF VER150}      // Delphi 7.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

{$IFDEF VER170}      // Delphi 9.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

{$IFDEF VER180}      // Delphi 10.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}  
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

{$IFDEF VER185}      // Delphi 11.0 (Spacely)
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}  
  {$DEFINE Delphi11}  
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

{$IFDEF VER190}      // Delphi 11.0 (Highlander)
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}  
  {$DEFINE Delphi11}  
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

{$IFDEF VER200}      // Delphi 12.0
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
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER210}      // Delphi 13.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER220}      // Delphi XE
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER230}      // Delphi XE 2
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER240}      // Delphi XE 2
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER250}      // Delphi XE 2
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER260}      // Delphi XE 5
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER270}      // Delphi XE 6
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER280}      // Delphi XE 7
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi21}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER290}      // Delphi XE 8
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER300}      // Delphi 10 Seattle
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER310}      // Delphi 10.1
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi24}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER320}      // Delphi 10.2
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi24}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER330}      // Delphi 10.3
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi13}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi24}
  {$DEFINE RICHBCB}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER93}       // Borland C++ Builder 1.0
  {$DEFINE Delphi2}
{$ENDIF}

{$IFDEF VER110}      // Borland C++ Builder 3.0
  {$DEFINE Delphi3}
  {$ObjExportAll on}
{$ENDIF}

{$IFDEF VER125}      // Borland C++ Builder 4.0
  {$DEFINE Delphi4}
  {$ObjExportAll on}
{$ENDIF}

{$IFDEF VER130}      // Borland C++ Builder 5.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER140}      // Borland C++ Builder 6.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER150}      // Borland C++ Builder 7.0
 {$IFDEF BCB}
  {$ObjExportAll on}
  {$WARN UNSAFE_CODE OFF}
 {$ENDIF}
{$ENDIF}

{$WARNINGS OFF}
