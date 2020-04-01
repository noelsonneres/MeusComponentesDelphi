
{******************************************}
{                                          }
{             FastReport v5.0              }
{              FR Variables                }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxVariables;

interface

{$I frx.inc}

uses
  SysUtils,
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  Classes, Graphics, Controls, Forms, Dialogs,
  frxXML, frxCollections
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxVariable = class(TfrxCollectionItem)
  private
    FName: String;
    FValue: Variant;
    {$IFDEF FPC}
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
    {$ENDIF}
  protected
    function GetInheritedName: String; override;
    {$IFDEF FPC}
    procedure DefineProperties(Filer: TFiler); override;
    {$ENDIF}
  public
    constructor Create(ACollection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    {$IFDEF FPC}
    property Value: Variant read FValue write FValue;
    {$ENDIF}
    function IsUniqueNameStored: Boolean; override;
  published
    property Name: String read FName write FName;
    {$IFNDEF FPC}
    property Value: Variant read FValue write FValue;
    {$ENDIF}
  end;

  TfrxVariables = class(TfrxCollection)
  private
    function GetItems(Index: Integer): TfrxVariable;
    function GetVariable(Index: String): Variant;
    procedure SetVariable(Index: String; const Value: Variant);
  public
    constructor Create;
    function Add: TfrxVariable;
    function Insert(Index: Integer): TfrxVariable;
    function IndexOf(const Name: String): Integer;
    procedure AddVariable(const ACategory, AName: String; const AValue: Variant);
    procedure DeleteCategory(const Name: String);
    procedure DeleteVariable(const Name: String);
    procedure GetCategoriesList(List: TStrings; ClearList: Boolean = True);
    procedure GetVariablesList(const Category: String; List: TStrings);
    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXMLItem(Item: TfrxXMLItem; OldXMLFormat: Boolean = True);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToXMLItem(Item: TfrxXMLItem);
    property Items[Index: Integer]: TfrxVariable read GetItems;
    property Variables[Index: String]: Variant read GetVariable
      write SetVariable; default;
  end;

  TfrxArray = class(TCollection)
  private
    function GetItems(Index: Integer): TfrxVariable;
    function GetVariable(Index: Variant): Variant;
    procedure SetVariable(Index: Variant; const Value: Variant);
  public
    constructor Create;
    function IndexOf(const Name: Variant): Integer;
    property Items[Index: Integer]: TfrxVariable read GetItems;
    property Variables[Index: Variant]: Variant read GetVariable
      write SetVariable; default;
  end;


implementation

uses frxXMLSerializer;


{ TfrxVariable }

constructor TfrxVariable.Create(ACollection: TCollection);
begin
  inherited;
  FValue := Null;
end;

{$IFDEF FPC}
procedure TfrxVariable.ReadData(Reader: TReader);
begin
  FValue := Reader.ReadVariant;
end;

procedure TfrxVariable.WriteData(Writer: TWriter);
var
  b:Byte;
begin
  case VarType(FValue) and varTypeMask of
    varEmpty:
      begin
      b := Byte(vaNil);
      Writer.Write(b,1);
      end;
    varNull:
      begin
      b := Byte(vaNull);
      Writer.Write(b,1);
      end;
    varOleStr:
      Writer.WriteString(FValue);
    varString:
      Writer.WriteString(FValue);
    varByte, varShortInt, varWord, varSmallInt, varInteger, varLongWord, varInt64:
      Writer.WriteInteger(FValue);
    varSingle:
      Writer.WriteSingle(FValue);
    varDouble:
      Writer.WriteFloat(FValue);
    varCurrency:
      Writer.WriteCurrency(FValue);
    varDate:
      Writer.WriteDate(FValue);
    varBoolean:
      Writer.WriteBoolean(FValue);
  end;
end;
{$ENDIF}


function TfrxVariable.GetInheritedName: String;
begin
  if Name <> '' then
    Result := Name
  else
    Result := inherited GetInheritedName;
end;

function TfrxVariable.IsUniqueNameStored: Boolean;
begin
  Result := False;
end;

{$IFDEF FPC}
procedure TfrxVariable.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Value', ReadData, WriteData, True);
end;
{$ENDIF}


procedure TfrxVariable.Assign(Source: TPersistent);
begin
  if Source is TfrxVariable then
  begin
    FName := TfrxVariable(Source).Name;
    FValue := TfrxVariable(Source).Value;
    FIsInherited := TfrxVariable(Source).IsInherited;
  end;
end;


{ TfrxVariables }

constructor TfrxVariables.Create;
begin
  inherited Create(TfrxVariable);
end;

function TfrxVariables.Add: TfrxVariable;
begin
  Result := TfrxVariable(inherited Add);
end;

function TfrxVariables.Insert(Index: Integer): TfrxVariable;
begin
  Result := TfrxVariable(inherited Insert(Index));
end;

function TfrxVariables.GetItems(Index: Integer): TfrxVariable;
begin
  Result := TfrxVariable(inherited Items[Index]);
end;

function TfrxVariables.IndexOf(const Name: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Name, Items[i].Name) = 0 then
    begin
      Result := i;
      break;
    end;
end;

function TfrxVariables.GetVariable(Index: String): Variant;
var
  i: Integer;
begin
  i := IndexOf(Index);
  if i <> -1 then
    Result := Items[i].Value else
    Result := Null;
end;

procedure TfrxVariables.SetVariable(Index: String; const Value: Variant);
var
  i: Integer;
  v: TfrxVariable;
begin
  i := IndexOf(Index);
  if i <> -1 then
    Items[i].Value := Value
  else
  begin
    v := Add;
    v.Name := Index;
    v.Value := Value;
  end;
end;

procedure TfrxVariables.GetCategoriesList(List: TStrings; ClearList: Boolean = True);
var
  i: Integer;
  s: String;
begin
  if ClearList then
    List.Clear;

  for i := 0 to Count - 1 do
  begin
    s := Items[i].Name;
    if (s <> '') and (s[1] = ' ') then
      List.Add(Copy(s, 2, 255));
  end;
end;

procedure TfrxVariables.GetVariablesList(const Category: String; List: TStrings);
var
  i, j: Integer;
  s: String;
begin
  List.Clear;
  for i := 0 to Count - 1 do
    if (Category = '') or (AnsiCompareText(Items[i].Name, ' ' + Category) = 0) then
    begin
      if Category <> '' then
        j := i + 1 else
        j := i;
      while j < Count do
      begin
        s := Items[j].Name;
        Inc(j);
        if (s <> '') and (s[1] <> ' ') then
          List.Add(s) else
          break
      end;
      break;
    end;
end;

procedure TfrxVariables.DeleteCategory(const Name: String);
var
  i: Integer;
begin
  i := 0;
  while i < Count do
  begin
    if AnsiCompareText(Items[i].Name, ' ' + Name) = 0 then
    begin
      Items[i].Free;
      while (i < Count) and (Items[i].Name[1] <> ' ') do
        Items[i].Free;
      break;
    end;
    Inc(i);
  end;
end;

procedure TfrxVariables.DeleteVariable(const Name: String);
var
  i: Integer;
begin
  i := IndexOf(Name);
  if i <> -1 then
    Items[i].Free;
end;

procedure TfrxVariables.AddVariable(const ACategory, AName: String;
  const AValue: Variant);
var
  i, idx: Integer;
begin
  i := 0;
  while i < Count do
  begin
    if AnsiCompareText(Items[i].Name, ' ' + ACategory) = 0 then
    begin
      Inc(i);
      while (i < Count) and (Items[i].Name[1] <> ' ') do
        Inc(i);
      idx := IndexOf(AName);
      if  idx <> - 1 then
        Items[idx].Value := AValue
      else
        if i = Count then
          with Add do
          begin
            Name := AName;
            Value := AValue;
          end
        else
          with Insert(i) do
          begin
            Name := AName;
            Value := AValue;
          end;
      break;
    end;
    Inc(i);
  end;
end;

procedure TfrxVariables.LoadFromFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxVariables.LoadFromStream(Stream: TStream);
var
  x: TfrxXMLDocument;
begin
  Clear;
  x := TfrxXMLDocument.Create;
  try
    x.LoadFromStream(Stream);
    if CompareText(x.Root.Name, 'variables') = 0 then
      LoadFromXMLItem(x.Root, x.OldVersion);
  finally
    x.Free;
  end;
end;

procedure TfrxVariables.LoadFromXMLItem(Item: TfrxXMLItem; OldXMLFormat: Boolean);
var
  xs: TfrxXMLSerializer;
  i: Integer;
begin
  Clear;
  xs := TfrxXMLSerializer.Create(nil);
  xs.OldFormat := OldXMLFormat;
  try
    for i := 0 to Item.Count - 1 do
      if CompareText(Item[i].Name, 'item') = 0 then
        xs.XMLToObj(Item[i].Text, Add);
  finally
    xs.Free;
  end;
end;

procedure TfrxVariables.SaveToFile(const FileName: String);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(f);
  finally
    f.Free;
  end;
end;

procedure TfrxVariables.SaveToStream(Stream: TStream);
var
  x: TfrxXMLDocument;
begin
  x := TfrxXMLDocument.Create;
  x.AutoIndent := True;
  try
    x.Root.Name := 'variables';
    SaveToXMLItem(x.Root);
    x.SaveToStream(Stream);
  finally
    x.Free;
  end;
end;

procedure TfrxVariables.SaveToXMLItem(Item: TfrxXMLItem);
var
  xi: TfrxXMLItem;
  xs: TfrxXMLSerializer;
  i: Integer;
begin
  xs := TfrxXMLSerializer.Create(nil);
  try
    for i := 0 to Count - 1 do
    begin
      xi := Item.Add;
      xi.Name := 'item';
      xi.Text := xs.ObjToXML(Items[i]);
    end;
  finally
    xs.Free;
  end;
end;


{ TfrxArray }

constructor TfrxArray.Create;
begin
  inherited Create(TfrxVariable);
end;

function TfrxArray.GetItems(Index: Integer): TfrxVariable;
begin
  Result := TfrxVariable(inherited Items[Index]);
end;

function TfrxArray.IndexOf(const Name: Variant): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if AnsiCompareText(VarToStr(Name), Items[i].Name) = 0 then
    begin
      Result := i;
      break;
    end;
end;

function TfrxArray.GetVariable(Index: Variant): Variant;
var
  i: Integer;
begin
  i := IndexOf(Index);
  if i <> -1 then
    Result := Items[i].Value else
    Result := Null;
end;

procedure TfrxArray.SetVariable(Index: Variant; const Value: Variant);
var
  i: Integer;
  v: TfrxVariable;
begin
  i := IndexOf(Index);
  if i <> -1 then
    Items[i].Value := Value
  else
  begin
    v := TfrxVariable(inherited Add);
    v.Name := Index;
    v.Value := Value;
  end;
end;

end.
