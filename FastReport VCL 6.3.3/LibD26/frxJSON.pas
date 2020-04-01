
{******************************************}
{                                          }
{             FastReport v6.0              }
{            JSON Manipulation             }
{                                          }
{            Copyright (c) 2017            }
{            by Oleg Adibekov,             }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxJSON;

{$I frx.inc}

interface

uses
  {$If     Defined(Delphi20)} JSON,
  {$Else}                     frxLkJSON,
  {$IfEnd}
  {$IFNDEF FPC}
    Windows
  {$ELSE}
    LCLType, LCLIntf, LCLProc
  {$ENDIF};

type
  TfrxJSON = class
  private
    JSONObject: {$IfDef Delphi20} TJSONObject;
                {$Else}           TlkJSONobject;
                {$EndIf}
    Weak: boolean;
  public
    constructor Create(const JSONString: String);
    constructor CreateWeek(const SingleObject: TObject);
    destructor Destroy; override;
    function IsValid: Boolean;
    function IsNameExists(const Name: String): boolean;
    function IsNameValueExists(const Name, Value: String): boolean;
    function ValueByName(const Name: String): String;
    function ObjectByName(const Name: String): TObject;
  end;

  TfrxJSONArray = class
  private
    JSONArray: {$IfDef Delphi20} TJSONArray;
               {$Else}           TlkJSONList;
               {$EndIf}
  public
    constructor Create(const ArrayObject: TObject);
    function Count: integer;
    function Get(Index: Integer): TfrxJSON;
    function GetString(Index: Integer): String;
  end;

implementation

{ TfrxJSON }

constructor TfrxJSON.Create(const JSONString: String);
begin
  JSONObject :=
{$IfDef Delphi20} TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
{$Else}           TlkJSON.ParseText(AnsiString(JSONString)) as TlkJSONobject;
{$EndIf}
  Weak := False;
end;

constructor TfrxJSON.CreateWeek(const SingleObject: TObject);
begin
  JSONObject :=
{$IfDef Delphi20} SingleObject as TJSONObject;
{$Else}           SingleObject as TlkJSONobject;
{$EndIf}
  Weak := True;
end;

destructor TfrxJSON.Destroy;
begin
  if not Weak then
    JSONObject.Free;
  inherited;
end;

function TfrxJSON.IsNameExists(const Name: String): boolean;
begin
  Result :=
{$IfDef Delphi20} JSONObject.Values[Name] <> nil;
{$Else}           JSONObject.IndexOfName(Name) <> -1;
{$EndIf}
end;

function TfrxJSON.IsNameValueExists(const Name, Value: String): boolean;
begin
  Result := IsNameExists(Name) and
           (ValueByName(Name) = Value);
end;

function TfrxJSON.IsValid: Boolean;
begin
  Result := Assigned(JSONObject);
end;

function TfrxJSON.ObjectByName(const Name: String): TObject;
begin
  Result :=
{$IfDef Delphi20} JSONObject.Get(Name).JSONValue;
{$Else}           JSONObject.Field[Name];
{$EndIf}
end;

function TfrxJSON.ValueByName(const Name: String): String;
begin
  Result :=
{$IfDef Delphi20} JSONObject.Get(Name).JSONValue.Value;
{$Else}           JSONObject.Field[Name].Value;
{$EndIf}
end;

{ TfrxJSONArray }

function TfrxJSONArray.Count: integer;
begin
  Result := JSONArray.Count;
end;

constructor TfrxJSONArray.Create(const ArrayObject: TObject);
begin
  JSONArray :=
{$IfDef Delphi20} ArrayObject as TJSONArray;
{$Else}           ArrayObject as TlkJSONList;
{$EndIf}
end;

function TfrxJSONArray.Get(Index: Integer): TfrxJSON;
begin
  Result := TfrxJSON.CreateWeek(
{$IfDef Delphi20} JSONArray.Items[Index]);
{$Else}           JSONArray.Child[Index]);
{$EndIf}
end;

function TfrxJSONArray.GetString(Index: Integer): String;
begin
  Result :=
{$IfDef Delphi20} JSONArray.Items[Index].Value;
{$Else}           JSONArray.Child[Index].Value;
{$EndIf}
end;

end.
