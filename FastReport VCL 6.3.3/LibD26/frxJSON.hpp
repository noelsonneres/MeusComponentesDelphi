// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'frxJSON.pas' rev: 33.00 (Windows)

#ifndef FrxjsonHPP
#define FrxjsonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.JSON.hpp>
#include <Winapi.Windows.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frxjson
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrxJSON;
class DELPHICLASS TfrxJSONArray;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxJSON : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Json::TJSONObject* JSONObject;
	bool Weak;
	
public:
	__fastcall TfrxJSON(const System::UnicodeString JSONString);
	__fastcall TfrxJSON(System::TObject* const SingleObject);
	__fastcall virtual ~TfrxJSON();
	bool __fastcall IsValid();
	bool __fastcall IsNameExists(const System::UnicodeString Name);
	bool __fastcall IsNameValueExists(const System::UnicodeString Name, const System::UnicodeString Value);
	System::UnicodeString __fastcall ValueByName(const System::UnicodeString Name);
	System::TObject* __fastcall ObjectByName(const System::UnicodeString Name);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TfrxJSONArray : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Json::TJSONArray* JSONArray;
	
public:
	__fastcall TfrxJSONArray(System::TObject* const ArrayObject);
	int __fastcall Count();
	TfrxJSON* __fastcall Get(int Index);
	System::UnicodeString __fastcall GetString(int Index);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfrxJSONArray() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Frxjson */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRXJSON)
using namespace Frxjson;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FrxjsonHPP
