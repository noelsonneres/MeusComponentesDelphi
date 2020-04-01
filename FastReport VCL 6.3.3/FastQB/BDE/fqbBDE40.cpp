//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEUNIT("fqbRegBDE.pas");
USERES("fqb_bde.DCR");
USEPACKAGE("vcl40.bpi");
USEPACKAGE("vclx40.bpi");
USEPACKAGE("vcldb40.bpi");
USEPACKAGE("fqb40.bpi");
USEUNIT("fqbBDEEngine.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
