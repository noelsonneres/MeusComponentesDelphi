
{******************************************}
{                                          }
{             FastReport v5.0              }
{             XML serializer               }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxXMLSerializer;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TypInfo, frxXML, frxClass
  {$IFDEF FPC}
  , LResources, LCLType, LCLProc, LazHelper
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxGetAncestorEvent = procedure(const ComponentName: String;
    var Ancestor: TPersistent) of object;


{ TfrxXMLSerializer is the XML analogue of the Delphi component streaming -
  TReader and TWriter }

  TfrxXMLSerializer = class(TObject)
  private
    FErrors: TStringList;
    FFixups: TList;
    FOwner: TfrxComponent;
    FReader: TReader;
    FReaderStream: TMemoryStream;
    FSerializeDefaultValues: Boolean;
    FStream: TStream;
    FOldFormat: Boolean;
    FOnGetAncestor: TfrxGetAncestorEvent;
    FGetCustomDataEvent: TfrxGetCustomDataEvent;
    FOnSaveCustomDataEvent: TfrxSaveCustomDataEvent;
    FHandleNestedProperties: Boolean;
    FSaveAncestorOnly: Boolean;
    FIgnoreName: Boolean;
    procedure AddFixup(Obj: TPersistent; p: PPropInfo; Value: String);
    procedure ClearFixups;
    procedure FixupReferences;

    {$IFDEF FPC}
    procedure PropertyNotFoundEvent(Reader: TReader; Instance: TPersistent;
      var PropName: string; IsPath: boolean; var Handled, Skip: Boolean);
    procedure ReadWriteStringPropertyEvent(Sender:TObject;
      const Instance: TPersistent; PropInfo: PPropInfo;
      var Content:string);
    procedure ReaderError(Reader: TReader; const Message: string;
      var Handled: Boolean);
    {$ENDIF}

  public
    constructor Create(Stream: TStream);
    destructor Destroy; override;
    function ObjToXML(Obj: TPersistent; const Add: String = ''; Ancestor: TPersistent = nil): String;
    function ReadComponent(Root: TfrxComponent): TfrxComponent;
    function ReadComponentStr(Root: TfrxComponent; s: String; DontFixup: Boolean = False): TfrxComponent;
    function WriteComponentStr(c: TfrxComponent; Ancestor: TPersistent = nil): String;
    procedure ReadRootComponent(Root: TfrxComponent; XMLItem: TfrxXMLItem = nil);
    procedure CopyFixupList(FixList: TList);
    procedure ReadPersistentStr(Root: TComponent; Obj: TPersistent; const s: String);
    procedure WriteComponent(c: TfrxComponent; Ancestor: TPersistent = nil);
    procedure WriteRootComponent(Root: TfrxComponent; SaveChildren: Boolean = True;
      XMLItem: TfrxXMLItem = nil; Streaming: Boolean = False);
    procedure XMLToObj(const s: String; Obj: TPersistent);
    property Errors: TStringList read FErrors;
    property Owner: TfrxComponent read FOwner write FOwner;
    property Stream: TStream read FStream;
    property Fixups: TList read FFixups;
    property SerializeDefaultValues: Boolean read FSerializeDefaultValues
      write FSerializeDefaultValues;
    property OnGetAncestor: TfrxGetAncestorEvent read FOnGetAncestor write FOnGetAncestor;
    property OnGetCustomDataEvent: TfrxGetCustomDataEvent read FGetCustomDataEvent write FGetCustomDataEvent;
    property OnSaveCustomDataEvent: TfrxSaveCustomDataEvent read FOnSaveCustomDataEvent write FOnSaveCustomDataEvent;
    property OldFormat: Boolean read FOldFormat write FOldFormat;
    property HandleNestedProperties: Boolean read FHandleNestedProperties write FHandleNestedProperties;
    property SaveAncestorOnly: Boolean read FSaveAncestorOnly write FSaveAncestorOnly;
    { ignore components name during loading }
    property IgnoreName: Boolean read FIgnoreName write FIgnoreName;
  end;

  TfrxFixupItem = class(TObject)
  public
    Obj: TPersistent;
    PropInfo: PPropInfo;
    Value: String;
  end;


implementation

uses frxUtils, frxRes, frxUnicodeUtils{$IFDEF FPC}, RtlConsts{$ENDIF};


type
  THackComponent = class(TComponent);
  THackPersistent = class(TPersistent);
  THackReader = class(TReader);


{ TfrxXMLSerializer }

constructor TfrxXMLSerializer.Create(Stream: TStream);
begin
  FErrors := TStringList.Create;
  FErrors.Sorted := True;
  FErrors.Duplicates := dupIgnore;
  FFixups := TList.Create;
  FStream := Stream;
  FReaderStream := TMemoryStream.Create;
  FSaveAncestorOnly := False;
  FReader := TReader.Create(FReaderStream, 4096);
{$IFDEF Delphi12}
  FOldFormat := False;
{$ELSE}
  FOldFormat := True;
{$ENDIF}
{$IFDEF FPC}
  FReader.OnPropertyNotFound := PropertyNotFoundEvent;
  FReader.OnReadStringProperty := ReadWriteStringPropertyEvent;
  FReader.OnError := ReaderError;
  {$ENDIF}
end;

destructor TfrxXMLSerializer.Destroy;
begin
  FErrors.Free;
  FReader.Free;
  FReaderStream.Free;
  ClearFixups;
  FFixups.Free;
  inherited;
end;

procedure TfrxXMLSerializer.ClearFixups;
begin
  while FFixups.Count > 0 do
  begin
    TfrxFixupItem(FFixups[0]).Free;
    FFixups.Delete(0);
  end;
end;

procedure TfrxXMLSerializer.AddFixup(Obj: TPersistent; p: PPropInfo;
  Value: String);
var
  Item: TfrxFixupItem;
begin
  Item := TfrxFixupItem.Create;
  Item.Obj := Obj;
  Item.PropInfo := p;
  Item.Value := Value;
  FFixups.Add(Item);
end;

procedure TfrxXMLSerializer.FixupReferences;
var
  i: Integer;
  Item: TfrxFixupItem;
  Ref: TObject;
begin
  for i := 0 to FFixups.Count - 1 do
  begin
    Item := FFixups[i];
    Ref := nil;
    if FOwner <> nil then
      Ref := FOwner.FindObject(Item.Value);
    if Ref = nil then
      Ref := frxFindComponent(FOwner, Item.Value);
    if Ref <> nil then
      SetOrdProp(Item.Obj, Item.PropInfo, frxInteger(Ref));
  end;

  FReader.FixupReferences;
  FReader.EndReferences;
  ClearFixups;
end;

{$IFDEF FPC}
procedure TfrxXMLSerializer.PropertyNotFoundEvent(Reader: TReader;
  Instance: TPersistent; var PropName: string; IsPath: boolean; var Handled,
  Skip: Boolean);
begin
  {$IFDEF DEBUGFR4XML}
  DebugLn('WARNING: XMLSerializer PropNotFound for ('+Instance.ClassName+'): ' +
    'Skipped property '+PropName+' Handled '+BoolToStr(Handled));
  {$ENDIF}
  Skip := True;
  Handled := True;
end;

procedure TfrxXMLSerializer.ReadWriteStringPropertyEvent(Sender: TObject;
  const Instance: TPersistent; PropInfo: PPropInfo; var Content: string);
begin
  {$IFDEF DEBUGFR4XML}
  DebugLn('TfrxXMLSerializer.ReadWriteStringPropertyEvent: Content ',Content);
  {$ENDIF}
end;

procedure TfrxXMLSerializer.ReaderError(Reader: TReader; const Message: string;
  var Handled: Boolean);
begin
  Handled := True;
  {$IFDEF DEBUGFR4XML}
  DebugLn('TfrxXMLSerializer.ReaderError: Message=',Message);
  {$ENDIF}
end;

type
  THackedObjectReader = class(TBinaryObjectReader);

{$ENDIF}

procedure TfrxXMLSerializer.XMLToObj(const s: String; Obj: TPersistent);
var
  i, j, start, len, code: Integer;
  i1, start1, len1: Integer;
  AName, AValue: String;
  Obj1: TPersistent;
  p: PPropInfo;
  ps, ps1: PChar;

  procedure DoNonPublishedProps(const AValue: String);
  {$IFDEF FPC}
  var
    BufSize: Integer;
    Offset: Integer;
  {$ENDIF}
  begin
    FReaderStream.Clear;
    frxStringToStream(AValue, FReaderStream);
    FReaderStream.Position := 0;

    {$IFDEF FPC}
    THackedObjectReader(FReader.Driver).FStream.Position := 0;
    FReaderStream.Position := 0;
    if FReaderStream.Size = 0 then
      Exit;
    BufSize := THackedObjectReader(FReader.Driver).FBufSize;
    if FReaderStream.Size mod BufSize = 0 then
      Offset := BufSize
    else
      Offset := FReaderStream.Size mod BufSize;
    {$ELSE}
    FReader.Position := 0;
    {$ENDIF}

    try
{$IFDEF DELPHI16}
      ActivateClassGroup(TControl);
{$ENDIF}

{$IFDEF FPC}
       while (THackedObjectReader(FReader.Driver).FBufPos <
              Offset) or  (FReaderStream.Position = 0) do
         THackReader(FReader).ReadProperty(Obj1);
{$ELSE}
       while FReader.Position < FReaderStream.Size do
         THackReader(FReader).ReadProperty(Obj1);
{$ENDIF}
    except
      {$IFDEF FPC}
      on E:Exception do
      begin
        DebugLn('TfrxXMLSerializer.XMLToObj: GENERAL EXCEPTION ',E.Message);
      end;
      {$ENDIF}
    end;
  end;

begin
  { speed optimized code. affects the speed of loading prepared page in the preview }
  len := Length(s);
  i := 1;
  ps := PChar(s) - 1;
  while i < len do
  begin
    j := i;
    len1 := len;
    ps1 := ps;
    while (j < len1) and (ps1[j] = ' ') do
      Inc(j);
    start := j;
    while (j < len1) and (ps1[j] <> '=') do
      Inc(j);
    i := j;
    if i < len then
    begin
      j := i - 1;
      while (j > 0) and (ps1[j] = ' ') do
        Dec(j);
      AName := Copy(s, start, j - start + 1);
      if AName = '' then break;
      j := i;
      len1 := len;
      while (j < len1) and (ps1[j] <> '"') do
        Inc(j);
      start := j + 1;
      Inc(j);
      while (j < len1) and (ps1[j] <> '"') do
        Inc(j);
      i := j;
      AValue := Copy(s, start, i - start);
      Inc(i);

      Obj1 := Obj;

      { check multiple properties }
      len1 := Length(AName);
      start1 := 1;
      i1 := 1;
      while (i1 < len1) and (AName[i1] <> '.') do
        Inc(i1);
      if i1 < len1 then
      begin
        while i1 < len1 do
        begin
          p := GetPropInfo(Obj1.ClassInfo, Copy(AName, start1, i1 - start1));
          if p = nil then
            break;
          Obj1 := TPersistent(GetOrdProp(Obj1, p));
          start1 := i1 + 1;
          Inc(i1);
          while (i1 < len1) and (AName[i1] <> '.') do
            Inc(i1);
        end;
        AName := Copy(AName, start1, MaxInt);
      end;

      try
        if Length(AName) = 1 then
        begin
          { special properties }
          case AName[1] of
            'x':
              begin
                TfrxCustomMemoView(Obj1).Text := frxXMLToStr(AValue);
                continue;
              end;
            'u':
              begin
{$IFDEF Delphi12}
                if FOldFormat then
                  TfrxCustomMemoView(Obj1).Text := frxXMLToStr(Utf8Decode(AnsiString(AValue)))
                else
                  TfrxCustomMemoView(Obj1).Text := frxXMLToStr(AValue);
{$ELSE}
{$IFDEF FPC}
                  TfrxCustomMemoView(Obj1).Text := frxXMLToStr(AValue);
{$ELSE}
                  TfrxCustomMemoView(Obj1).Text := Utf8Decode(frxXMLToStr(AValue));
{$ENDIF}
{$ENDIF}
                continue;
              end;
            'l':
              begin
                TfrxComponent(Obj1).Left := frxStrToFloat(String(AValue));
                continue;
              end;
            't':
              begin
                TfrxComponent(Obj1).Top := frxStrToFloat(String(AValue));
                continue;
              end;
            'w':
              begin
                TfrxComponent(Obj1).Width := frxStrToFloat(String(AValue));
                continue;
              end;
            'h':
              begin
                TfrxComponent(Obj1).Height := frxStrToFloat(String(AValue));
                continue;
              end;
          end;
        end
        else
        begin
          if AName = 'Text' then
          begin
            if Obj1 is TStrings then
            begin
              {$IFNDEF Delphi12}
              if not FOldFormat then
{$IFDEF FPC}
                 TStrings(Obj1).Text := String(frxXMLToStr(AValue))
{$ELSE}
                 TStrings(Obj1).Text := String(UTF8Decode(frxXMLToStr(AValue)))
{$ENDIF}

              else
              {$ENDIF}
                TStrings(Obj1).Text := frxXMLToStr(AValue);
              continue;
            end
            else if Obj1 is {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF} then
            begin
              {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF}(Obj1).Text := frxXMLToStr(AValue);
              continue;
            end
            else if Obj1 is TfrxCustomMemoView then
            begin
              {$IFDEF Delphi12}
              if FOldFormat then
                TfrxCustomMemoView(Obj1).Text := frxXMLToStr(Utf8Decode(AnsiString(AValue)))
              else TfrxCustomMemoView(Obj1).Text := frxXMLToStr(AValue);
              {$ELSE}
              {$IFDEF FPC}
              TfrxCustomMemoView(Obj1).Text := frxXMLToStr(AValue);
              {$ELSE}
              TfrxCustomMemoView(Obj1).Text := Utf8Decode(frxXMLToStr(AValue));
              {$ENDIF}
              {$ENDIF}
              continue;
            end
          end
          else if AName = 'PropData' then
          begin
            DoNonPublishedProps(AValue);
            continue;
          end
          else if (Obj1 is TfrxReport) and (AName = 'Name') then
            continue;
        end;

        p := GetPropInfo(Obj1.ClassInfo, String(AName));
        if (p <> nil) and (p.SetProc <> nil) then
          case p.PropType^.Kind of
            tkInteger, tkSet, tkChar, tkWChar
            {$IFDEF FPC}, tkUChar{$ENDIF}:
              SetOrdProp(Obj1, p, StrToInt(String(AValue)));
{$IFDEF DELPHI16}
            tkInt64:
              SetOrdProp(Obj1, p, StrToInt64(String(AValue)));
{$ENDIF}
            tkEnumeration{$IFDEF FPC}, tkBool{$ENDIF}:
              begin
                Val(String(AValue), j, code);
                if code = 0 then
                  SetOrdProp(Obj1, p, j) else
{$IFDEF FPC}
                  SetOrdProp(Obj1, p, GetEnumValue(p.PropType, String(AValue)));
{$ELSE}
                  SetOrdProp(Obj1, p, GetEnumValue(p.PropType^, String(AValue)));
{$ENDIF}
              end;

            tkFloat:
              SetFloatProp(Obj1, p, frxStrToFloat(String(AValue)));

            tkString, tkLString{$IFDEF Delphi12}{$ELSE}, tkWString{$ENDIF}
            {$IFDEF FPC}, tkAString{$ENDIF}:
{$IFNDEF Delphi12}
              if not FOldFormat then
{$IFDEF FPC}
                 SetStrProp(Obj1, p, String(frxXMLToStr(AValue))) else
{$ELSE}
                 SetStrProp(Obj1, p, String(UTF8Decode(frxXMLToStr(AValue)))) else
{$ENDIF}

{$ENDIF}
              SetStrProp(Obj1, p, String(frxXMLToStr(AValue)));
{$IFDEF Delphi12}
            tkUString, tkWString:
              SetStrProp(Obj1, p, frxXMLToStr(AValue));
{$ENDIF}
            tkClass:
              AddFixup(Obj1, p, String(AValue));

            tkVariant:
              SetVariantProp(Obj1, p, frxXMLToStr(AValue));
          end;
      except
        on E: Exception do
          FErrors.Add(E.Message);
      end;
    end;
  end;
end;

{ this is the almost the same code like in original IsStoredProp   }
{ starts from XE3 IsStoredProp check every property for attributes }
{ but original code cycle each property again,                     }
{ so we have cylce in cycle for each property name                 }
{ it slows down report preparation almost twice                    }
{ as we don't use attributes we're using lite version here         }
{ we should check this code for every new version of RTL           }
{$IFDEF DELPHI17}
function IsStoredPropRTTI(Instance: TObject; aPropInfo: PPropInfo): Boolean;
type
  TStoredProc = function : Boolean of object;
  TStoredIndexProc = function (Index: Integer): Boolean of object;
var
  Method: TMethod;
  StProc: Pointer;
begin
  StProc := aPropInfo^.StoredProc;
  if (UIntPtr(StProc) and (not NativeUInt($FF))) = 0 then
    Exit(Boolean(UIntPtr(StProc) and $FF));
  if ((IntPtr(StProc) and PROPSLOT_MASK) = PROPSLOT_FIELD) then
    Result := Boolean(PNativeInt(Pointer(PByte(Instance) + (IntPtr(StProc) and not PROPSLOT_MASK)))^)
  else
  begin
    if (IntPtr(StProc) and PROPSLOT_MASK) = PROPSLOT_VIRTUAL then
    Method.Code := PPointer(PNativeUInt(Instance)^ + (UIntPtr(StProc) and $FFFF))^
  else
    Method.Code := StProc;
    Method.Data := Instance;
{$IFNDEF DELPHI20}
	Result := TStoredProc(Method)()
{$ELSE}
    if aPropInfo^.Index = Low(aPropInfo^.Index) then
      Result := TStoredProc(Method)()
    else
      Result := TStoredIndexProc(Method)(aPropInfo^.Index);
{$ENDIF}
  end;
end;
{$ENDIF}

function TfrxXMLSerializer.ObjToXML(Obj: TPersistent; const Add: String = '';
  Ancestor: TPersistent = nil): String;
var
  TypeInfo: PTypeInfo;
  PropCount: Integer;
  PropList: PPropList;
  i: Integer;
  s: String;
  ws: WideString;
  Flag, writeNonPublishedProperties: Boolean;

  procedure DoOrdProp;
  var
    Value: frxInteger;

    function IsDefault: Boolean;
    begin
      if Ancestor <> nil then
        Result := Value = GetOrdProp(Ancestor, PropList[i])
      else
        Result := Value = PropList[i].Default;
    end;

  begin
    Value := GetOrdProp(Obj, PropList[i]);
    if not IsDefault or FSerializeDefaultValues then
{$IFDEF DELPHI16}
      if PropList[i].PropType^.Kind = tkInt64 then
        s := IntToStr(Value)
      else
{$ENDIF}
      if PropList[i].PropType^.Kind = tkEnumeration then
{$IFDEF FPC}
		s := GetEnumName(PropList[i].PropType, Integer(Value))
{$ELSE}
		s := GetEnumName(PropList[i].PropType^, Integer(Value))
{$ENDIF}
      else
        s := IntToStr(Integer(Value));
  end;

  procedure DoFloatProp;
  var
    Value: Extended;

    function IsDefault: Boolean;
    begin
      if Ancestor <> nil then
        Result := Abs(Value - GetFloatProp(Ancestor, PropList[i])) < 1e-6
      else
        Result := False;
    end;

  begin
    Value := GetFloatProp(Obj, PropList[i]);
// commented out due to bug with tfrxmemoview.linespacing=0
    if not IsDefault or FSerializeDefaultValues then
      s := FloatToStr(Value);
  end;

  procedure DoStrProp;
  var
    Value: String;

    function IsDefault: Boolean;
    begin
      if Ancestor <> nil then
        Result := Value = GetStrProp(Ancestor, PropList[i])
      else
        Result := Value = '';
    end;

  begin
    Value := GetStrProp(Obj, PropList[i]);
    if not IsDefault or FSerializeDefaultValues then
      s := frxStrToXML(Value);
  end;

  procedure DoVariantProp;
  var
    Value: Variant;

    function IsDefault: Boolean;
    begin
      if Ancestor <> nil then
        Result := Value = GetVariantProp(Ancestor, PropList[i])
      else
        Result := False;
    end;

  begin
    Value := GetVariantProp(Obj, PropList[i]);
    if not IsDefault or FSerializeDefaultValues then
      s := frxStrToXML(VarToStr(Value));
  end;

  procedure DoClassProp;
  var
    FClass: TClass;
    FComp, FAncComp: TComponent;
    FObj, FAncObj: TPersistent;
  begin
{$IFDEF FPC}
    FClass := GetTypeData(PropList[i].PropType).ClassType;
{$ELSE}
    FClass := GetTypeData(PropList[i].PropType^).ClassType;
{$ENDIF}
    FObj := TPersistent(GetOrdProp(Obj, PropList[i]));
    if FClass.InheritsFrom(TComponent) and
      ((FObj = nil) or not(csSubComponent in TComponent(FObj).ComponentStyle)) then
    begin
      FComp := TComponent(FObj);
      if Ancestor <> nil then
        FAncComp := TComponent(GetOrdProp(Ancestor, PropList[i]))
      else
        FAncComp := nil;

      if Ancestor <> nil then
      begin
        if (FComp = nil) and (FAncComp = nil) then Exit;
        if (FComp <> nil) and (FAncComp <> nil) then
          if CompareText(FComp.Name, FAncComp.Name) = 0 then Exit;
        if (FComp = nil) and (FAncComp <> nil) then
        begin
          s := 'nil';
          Exit;
        end;
      end;

      if FComp <> nil then
        s := frxGetFullName(FOwner, FComp);
    end
    else if FClass.InheritsFrom(TPersistent) then
    begin
      if Ancestor <> nil then
        FAncObj := TPersistent(GetOrdProp(Ancestor, PropList[i]))
      else
        FAncObj := nil;

      if FObj is TStrings then
      begin
        if (Ancestor <> nil) and not FSaveAncestorOnly then
          if TStrings(FObj).Text = TStrings(FAncObj).Text then
            Exit;
{$IFDEF Delphi12}
//        s := UTF8Encode(TStrings(FObj).Text);
        s := TStrings(FObj).Text;
{$ELSE}
        s := TStrings(FObj).Text;
{$ENDIF}
        if (Length(s) >= 2) and
           (s[Length(s) - 1] = #13) and (s[Length(s)] = #10) then
          Delete(s, Length(s) - 1, 2);

        {$IFDEF UNIX} // delete lineending
        if (Length(s) >= 1) and
           (s[Length(s)] = #10) then
          Delete(s, Length(s), 1);
        {$ENDIF}

        s := ' ' + Add + String(PropList[i].Name) + '.Text="' +
          frxStrToXML(s) + '"';

      end
      else if FObj is {$IFDEF Delphi10}TfrxWideStrings{$ELSE}TWideStrings{$ENDIF} then
      begin
        // skip, handle separately
      end
      else
        s := ObjToXML(FObj, Add + String(PropList[i].Name) + '.', FAncObj);
      Flag := True;
    end;
  end;

  procedure DoNonPublishedProps;
  var
    wr: TWriter;
    ms, AncMs: TMemoryStream;
  begin
{$IFDEF DELPHI16}
  ActivateClassGroup(TControl);
{$ENDIF}
    ms := TMemoryStream.Create;
    try
      wr := TWriter.Create(ms, 4096);
      wr.Root := FOwner;

      try
        THackPersistent(Obj).DefineProperties(wr);
      finally
        wr.Free;
      end;

      if ms.Size > 0 then
      begin
        if Ancestor <> nil then
        begin
          AncMs := TMemoryStream.Create;
          try
            wr := TWriter.Create(AncMs, 4096);
            wr.Root := FOwner;

            try
              THackPersistent(Ancestor).DefineProperties(wr);
            finally
              wr.Free;
            end;
            if (frxStreamCRC32(ms) = frxStreamCRC32(AncMs)) and not FSaveAncestorOnly then
              Exit;
          finally
            AncMs.Free;
          end;
        end;

        s := frxStreamToString(ms);
        Result := Result + ' ' + Add + 'PropData="' + s + '"';
      end;
    finally
      ms.Free;
    end;
  end;

begin
  Result := '';
  if Obj = nil then Exit;

  TypeInfo := Obj.ClassInfo;
  PropCount := GetTypeData(TypeInfo).PropCount;
  GetMem(PropList, PropCount * SizeOf(PPropInfo));
  GetPropInfos(TypeInfo, PropList);

  try
    if Obj is TfrxComponent then
    begin
      TfrxComponent(Obj).IsWriting := True;
      if (Ancestor = nil) and Assigned(FOnGetAncestor) then
        FOnGetAncestor(TfrxComponent(Obj).Name, Ancestor);
    end;
    if Ancestor is TfrxComponent then
    begin
      TfrxComponent(Ancestor).IsWriting := True;
      if FSaveAncestorOnly then
        Obj := Ancestor;
    end;

    for i := 0 to PropCount - 1 do
    begin
      s := '';
      Flag := False;
{$IFDEF DELPHI17}
      if IsStoredPropRTTI(Obj, PropList[i]) then
{$ELSE}
      if IsStoredProp(Obj, PropList[i]) then
{$ENDIF}	  
        case PropList[i].PropType^.Kind of
        {$IFDEF DELPHI16}
        tkInt64,
        {$ENDIF}
          tkInteger, tkSet, tkChar, tkWChar, tkEnumeration
         {$IFDEF FPC}, tkBool, tkInt64{$ENDIF}:
            DoOrdProp;

          tkFloat:
            DoFloatProp;

          tkString, tkLString, tkWString{$IFDEF Delphi12}, tkUString{$ENDIF}
          {$IFDEF FPC}, tkAString{$ENDIF}:
            DoStrProp;

          tkClass:
            DoClassProp;

          tkVariant:
            DoVariantProp;
        end;

      if s <> '' then
        if Flag then
          Result := Result + s
        else
          Result := Result + ' ' + Add + String(PropList[i].Name) + '="' + s + '"';
    end;

    if Obj is TfrxCustomMemoView then
      if (Ancestor = nil) or FSaveAncestorOnly or
        (TfrxCustomMemoView(Obj).Text <> TfrxCustomMemoView(Ancestor).Text) then
      begin
        ws := TfrxCustomMemoView(Obj).Text;
        if (Length(ws) >= 2) and
          (ws[Length(ws) - 1] = #13) and (ws[Length(ws)] = #10) then
            Delete(ws, Length(ws) - 1, 2);

        {$IFDEF UNIX} // delete LineEnding
        if (Length(ws) >= 1) and
          (ws[Length(ws)] = #10) then
            Delete(ws, Length(ws), 1);
        {$ENDIF}


{$IFDEF Delphi12}
        Result := Result + ' Text="' + frxStrToXML(ws) + '"';
{$ELSE}
{$IFDEF FPC}
        Result := Result + ' Text="' + frxStrToXML(ws) + '"';
{$ELSE}
        Result := Result + ' Text="' + frxStrToXML(Utf8Encode(ws)) + '"';
{$ENDIF}
{$ENDIF}
      end;

    writeNonPublishedProperties := True;
    if Obj is TfrxComponent then
      writeNonPublishedProperties := not (csHandlesNestedProperties in TfrxComponent(Obj).frComponentStyle) or not FHandleNestedProperties;

    if writeNonPublishedProperties then
      DoNonPublishedProps;

  finally
    if Obj is TfrxComponent then
      TfrxComponent(Obj).IsWriting := False;
    if Ancestor is TfrxComponent then
      TfrxComponent(Ancestor).IsWriting := False;
    FreeMem(PropList, PropCount * SizeOf(PPropInfo));
  end;
end;

procedure TfrxXMLSerializer.ReadRootComponent(Root: TfrxComponent;
  XMLItem: TfrxXMLItem = nil);
var
  XMLDoc: TfrxXMLDocument;
  CompList: TList;
  SaveParent: TfrxComponent;

  procedure DoRead(Item: TfrxXMLItem; Owner: TfrxComponent);
  var
    i: Integer;
    c: TfrxComponent;
    IsAncestor: Boolean;
  begin

  if(CompareText(Item.Name, 'FrxCustomData') = 0) then
  begin
    if Assigned(FGetCustomDataEvent) then
      FGetCustomDataEvent(Item);
    Exit;
  end;

{$IFDEF DELPHI16}
  ActivateClassGroup(TControl);
{$ENDIF}
    IsAncestor := CompareText(Item.Name, 'inherited') = 0;
    if not IsAncestor then
      try
        FindClass(String(Item.Name));
      except
        FErrors.Add(frxResources.Get('xrCantFindClass') + ' ' + String(Item.Name));
        Exit;
      end;

    if Owner <> nil then
    begin
      if FIgnoreName then
        c := nil
      else
        c := FOwner.FindComponent(String(Item.Prop['Name'])) as TfrxComponent;
      if not IsAncestor and (c = nil) then
      begin
        c := TfrxComponent(FindClass(String(Item.Name)).NewInstance);
        c.Create(Owner);
      end
      else if IsAncestor and Assigned(c) then
      begin
        // fix original creation order in child reports
        SaveParent := c.Parent;
        c.Parent := nil;
        c.Parent := SaveParent;
      end;
    end
    else
      c := Root;

    if c <> nil then
    begin
      c.IsLoading := True;
      XMLToObj(Item.Text, c);
      CompList.Add(c);

      for i := 0 to Item.Count - 1 do
      begin
        if FHandleNestedProperties then
          if (csHandlesNestedProperties in c.frComponentStyle) and c.ReadNestedProperty(Item[i]) then continue;
        DoRead(Item[i], c);
      end;
    end;
  end;

  procedure DoLoaded;
  var
    i: Integer;
    c: TfrxComponent;
  begin
    for i := 0 to CompList.Count - 1 do
    begin
      c := CompList[i];
      c.IsLoading := False;
      if not (c is TfrxReport) then
        THackComponent(c).Loaded;
    end;
  end;

begin
  if Owner = nil then
    Owner := Root;
  XMLDoc := nil;
  CompList := TList.Create;

  if XMLItem = nil then
  begin
    XMLDoc := TfrxXMLDocument.Create;
    XMLItem := XMLDoc.Root;
    try
      XMLDoc.LoadFromStream(FStream);
      FOldFormat := XMLDoc.OldVersion;
    except
      XMLDoc.Free;
      CompList.Free;
      raise;
    end;
  end;

  FReader.Root := FOwner;
  FReader.BeginReferences;
  try
    DoRead(XMLItem, nil);
    FixupReferences;
    DoLoaded;
  finally
    if XMLDoc <> nil then
      XMLDoc.Free;
    CompList.Free;
  end;
end;

procedure TfrxXMLSerializer.WriteRootComponent(Root: TfrxComponent;
  SaveChildren: Boolean = True; XMLItem: TfrxXMLItem = nil; Streaming: Boolean = False);
var
  XMLDoc: TfrxXMLDocument;

  procedure DoWrite(Item: TfrxXMLItem; ARoot: TfrxComponent);
  var
    i: Integer;
    lAncestor: TPersistent;
  begin
    lAncestor := nil;
    if ARoot.IsAncestor and not Streaming then
    begin
      Item.Name := 'inherited';
      if Assigned(FOnGetAncestor) then
        FOnGetAncestor(TfrxComponent(ARoot).Name, lAncestor);
    end
    else
      Item.Name := ARoot.ClassName;
    if (ARoot = Root) or IgnoreName then
      Item.Text := ObjToXML(ARoot)
    else
      Item.Text := 'Name="' + ARoot.Name + '"' + ObjToXML(ARoot);
    if FHandleNestedProperties and (csHandlesNestedProperties in ARoot.frComponentStyle) then
      ARoot.WriteNestedProperties(Item, lAncestor);
    if SaveChildren then
      for i := 0 to ARoot.Objects.Count - 1 do
        DoWrite(Item.Add, ARoot.Objects[i]);
  end;

begin
  if Owner = nil then
    Owner := Root;
  XMLDoc := nil;

  if XMLItem = nil then
  begin
    XMLDoc := TfrxXMLDocument.Create;
    XMLItem := XMLDoc.Root;
    XMLDoc.AutoIndent := True;
  end;

  try
    DoWrite(XMLItem, Root);
    if Assigned(FOnSaveCustomDataEvent) then
    begin
      XMLItem := XMLDoc.Root;
      XMLItem :=  XMLItem.Add;
      XMLItem.Name := 'FrxCustomData';
      FOnSaveCustomDataEvent(XMLItem);
    end;

    if XMLDoc <> nil then
      XMLDoc.SaveToStream(FStream);
  finally
    if XMLDoc <> nil then
      XMLDoc.Free;
  end;
end;

function TfrxXMLSerializer.ReadComponent(Root: TfrxComponent): TfrxComponent;
var
  rd: TfrxXMLReader;
  RootItem: TfrxXMLItem;
begin
  rd := TfrxXMLReader.Create(FStream);
  RootItem := TfrxXMLItem.Create;

  try
    rd.ReadRootItem(RootItem, False);
    Result := ReadComponentStr(Root, RootItem.Name + ' ' + RootItem.Text);
  finally
    rd.Free;
    RootItem.Free;
  end;
end;

procedure TfrxXMLSerializer.WriteComponent(c: TfrxComponent; Ancestor: TPersistent);
var
  s: AnsiString;
begin
{$IFDEF Delphi12}
  s := '<' + UTF8Encode(WriteComponentStr(c, Ancestor)) + '/>';
{$ELSE}
  s := '<' + WriteComponentStr(c, Ancestor) + '/>';
{$ENDIF}
  FStream.Write(s[1], Length(s));
end;

function TfrxXMLSerializer.ReadComponentStr(Root: TfrxComponent;
  s: String; DontFixup: Boolean = False): TfrxComponent;
var
  n: Integer;
  s1: String;
begin
{$IFDEF DELPHI16}
  ActivateClassGroup(TControl);
{$ENDIF}
  Owner := Root;
  if Trim(String(s)) = '' then
    Result := nil
  else
  begin
    n := Pos(' ', s);
    s1 := Copy(s, n + 1, MaxInt);
    Delete(s, n, MaxInt);

    Result := TfrxComponent(FindClass(s).NewInstance);
    Result.Create(Root);

    FReader.Root := Root;
    FReader.BeginReferences;
    try
      Result.IsLoading := True;
      XMLToObj(s1, Result);
    finally
      if DontFixup then
      begin
        FReader.EndReferences;
        ClearFixups;
      end
      else
        FixupReferences;
      Result.IsLoading := False;
      if not (Result is TfrxReport) then
        THackComponent(Result).Loaded;
    end;
  end;
end;

function TfrxXMLSerializer.WriteComponentStr(c: TfrxComponent; Ancestor: TPersistent): String;
begin
  Result := c.ClassName + ObjToXML(c, '', Ancestor);
end;

procedure TfrxXMLSerializer.ReadPersistentStr(Root: TComponent;
  Obj: TPersistent; const s: String);
begin
  FReader.Root := Root;
  FReader.BeginReferences;
  XMLToObj(s, Obj);
  FixupReferences;
end;

procedure TfrxXMLSerializer.CopyFixupList(FixList: TList);
var
  i: Integer;
  function CopyItem: TfrxFixupItem;
  var
    Item: TfrxFixupItem;
  begin
    Item := TfrxFixupItem(FFixups[i]);
    Result := TfrxFixupItem.Create;
    Result.Obj := Item.Obj;
    Result.PropInfo := Item.PropInfo;
    Result.Value := Item.Value;
  end;
begin
  if FixList = nil then exit;
  for i := 0 to FFixups.Count - 1 do
    FixList.Add(CopyItem);
end;

end.

