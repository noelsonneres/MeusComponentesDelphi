
#include <vcl.h>
#pragma hdrstop
USEUNIT("fqbRegBDE.pas");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("fqbBDE50.bpi");

//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------

