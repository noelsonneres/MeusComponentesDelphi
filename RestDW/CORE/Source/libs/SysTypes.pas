unit SysTypes;

{$I uRESTDW.inc}

Interface

Uses
  IdURI, IdGlobal, IdHeaderList, SysUtils, Classes, ServerUtils, uRESTDWBase, uDWConsts,
  uDWJSONObject, uDWConstsData, uDWMassiveBuffer, uRESTDWServerEvents, uSystemEvents,
  uDWConstsCharset;

Type
 TReplyEvent     =             Procedure(SendType           : TSendEvent;
                                         Context            : String;
                                         Var Params         : TDWParams;
                                         Var Result         : String;
                                         AccessTag          : String)  Of Object;
 TMassiveProcess =             Procedure(Var MassiveDataset : TMassiveDatasetBuffer;
                                         Var Ignore         : Boolean) Of Object;
 TMassiveEvent   =             Procedure(Var MassiveDataset : TMassiveDatasetBuffer) Of Object;

Type
  TServerUtils = Class
    Class Procedure ParseRESTURL        (Const Cmd          : String;
                                         vEncoding          : TEncodeSelect;
                                         Var UrlMethod,
                                         urlContext,
                                         mark               : String
                                         {$IFDEF FPC};
                                          DatabaseCharSet   : TDatabaseCharSet
                                         {$ENDIF};
                                         Var Result         : TDWParams);
    Class Function  Result2JSON          (wsResult          : TResultErro)     : String;
    Class Procedure ParseWebFormsParams (Params             : TStrings;
                                         Const URL,
                                         Query              : String;
                                         Var UrlMethod,
                                         urlContext,
                                         mark               : String;
                                         vEncoding          : TEncodeSelect;
                                         {$IFDEF FPC}
                                          DatabaseCharSet   : TDatabaseCharSet;
                                         {$ENDIF}
                                         Var Result         : TDWParams;
                                         MethodType         : String = 'POST'); Overload;
    Class Procedure ParseWebFormsParams (Var DWParams       : TDWParams;
                                         Params             : TStrings;
                                         Const URL,
                                         Query              : String;
                                         Var UrlMethod,
                                         urlContext,
                                         mark               : String;
                                         vEncoding          : TEncodeSelect;
                                         {$IFDEF FPC}
                                          DatabaseCharSet   : TDatabaseCharSet;
                                         {$ENDIF}
                                         MethodType         : String = 'POST');Overload;
    Class Function ParseDWParamsURL     (Const Cmd          : String;
                                         vEncoding          : TEncodeSelect;
                                         Var ResultPR       : TDWParams{$IFDEF FPC}
                                         ;DatabaseCharSet   : TDatabaseCharSet
                                         {$ENDIF})          : Boolean;
    {Tiago IStuque - 28/12/2018}
    Class Function ParseBodyRawToDWParam(Const BodyRaw      : String;
                                         vEncoding          : TEncodeSelect;
                                         Var ResultPR       : TDWParams{$IFDEF FPC}
                                         ;DatabaseCharSet   : TDatabaseCharSet
                                         {$ENDIF})          : Boolean;
    Class Function ParseBodyBinToDWParam(Const BodyBin      : String;
                                         vEncoding          : TEncodeSelect;
                                         Var ResultPR       : TDWParams{$IFDEF FPC}
                                         ;DatabaseCharSet   : TDatabaseCharSet
                                         {$ENDIF})          : Boolean;
    Class Function ParseFormParamsToDWParam(Const FormParams : String;
                                            vEncoding        : TEncodeSelect;
                                            var ResultPR     : TDWParams{$IFDEF FPC}
                                            ;DatabaseCharSet : TDatabaseCharSet
                                            {$ENDIF})        : Boolean;

    {Tiago IStuque - 28/12/2018}
  End;

Type
  TServerMethods = Class(TComponent)
  Protected
   vClientWelcomeMessage : String;
   vReplyEvent     : TReplyEvent;
   vWelcomeMessage : TWelcomeMessage;
   vMassiveProcess : TMassiveProcess;
   vOnMassiveBegin,
   vOnMassiveAfterStartTransaction,
   vOnMassiveAfterBeforeCommit,
   vOnMassiveAfterAfterCommit,
   vOnMassiveEnd                 : TMassiveEvent;
   vOnGetToken                   : TOnGetToken;
   vOnTokenSessionValidate       : TOnTokenSession;
   Function ReturnIncorrectArgs  : String;
   Function ReturnMethodNotFound : String;
  Public
   Encoding: TEncodeSelect;
   Constructor Create(aOwner: TComponent); Override;
   Destructor Destroy; Override;
   Procedure  SetClientWelcomeMessage(Value: String);
  Published
   Property OnReplyEvent     : TReplyEvent      Read vReplyEvent     Write vReplyEvent;
   Property OnWelcomeMessage : TWelcomeMessage  Read vWelcomeMessage Write vWelcomeMessage;
   Property OnMassiveProcess : TMassiveProcess  Read vMassiveProcess Write vMassiveProcess;
   Property OnMassiveBegin                 : TMassiveEvent    Read vOnMassiveBegin                 Write vOnMassiveBegin;
   Property OnMassiveAfterStartTransaction : TMassiveEvent    Read vOnMassiveAfterStartTransaction Write vOnMassiveAfterStartTransaction;
   Property OnMassiveAfterBeforeCommit     : TMassiveEvent    Read vOnMassiveAfterBeforeCommit     Write vOnMassiveAfterBeforeCommit;
   Property OnMassiveAfterAfterCommit      : TMassiveEvent    Read vOnMassiveAfterAfterCommit      Write vOnMassiveAfterAfterCommit;
   Property OnMassiveEnd                   : TMassiveEvent    Read vOnMassiveEnd                   Write vOnMassiveEnd;
   Property OnGetToken                     : TOnGetToken      Read vOnGetToken                     Write vOnGetToken;
   Property OnTokenSessionValidate         : TOnTokenSession  Read vOnTokenSessionValidate         Write vOnTokenSessionValidate;
  End;

implementation

uses uDWJSONTools;

{$IFDEF FPC}
Function URLDecode(const s: String): String;
var
   sAnsi,
   sUtf8    : String;
   sWide    : WideString;
   i, len   : Cardinal;
   ESC      : String[2];
   CharCode : integer;
   c        : char;
begin
   sAnsi := PChar(s);
   SetLength(sUtf8, Length(sAnsi));
   i := 1;
   len := 1;
   while (i <= Cardinal(Length(sAnsi))) do begin
      if (sAnsi[i] <> '%') then begin
         if (sAnsi[i] = '+') then begin
            c := ' ';
         end else begin
            c := sAnsi[i];
         end;
         sUtf8[len] := c;
         Inc(len);
      end else begin
         Inc(i);
         ESC := Copy(sAnsi, i, 2);
         Inc(i, 1);
         try
            CharCode := StrToInt('$' + ESC);
            c := Char(CharCode);
            sUtf8[len] := c;
            Inc(len);
         except end;
      end;
      Inc(i);
   end;
   Dec(len);
   SetLength(sUtf8, len);
   sWide := UTF8Decode(sUtf8);
   len := Length(sWide);
   Result := sWide;
end;
{$ENDIF}

Class Procedure TServerUtils.ParseRESTURL(Const Cmd          : String;
                                          vEncoding          : TEncodeSelect;
                                          Var UrlMethod,
                                          urlContext,
                                          mark               : String
                                          {$IFDEF FPC};
                                          DatabaseCharSet   : TDatabaseCharSet
                                          {$ENDIF};
                                          Var Result         : TDWParams);
Var
 vTempData,
  NewCmd,
  vArrayValues: String;
  ArraySize,
  iBar1,
  IBar2, Cont : Integer;
  JSONParam   : TJSONParam;
  Function CountExpression(Value: String; Expression: Char): Integer;
  Var
    I: Integer;
  Begin
    Result := 0;
    For I := 0 To Length(Value) - 1 Do
    Begin
      If Value[I] = Expression Then
        Inc(Result);
    End;
  End;
Begin
// Result       := Nil;
 JSONParam    := Nil;
 vArrayValues := '';
 If Pos('?', Cmd) > 0 Then
  Begin
   vArrayValues := Copy(Cmd, Pos('?', Cmd) + 1, Length(Cmd));
   NewCmd       := Copy(Cmd, 1, Pos('?', Cmd) - 1);
  End
 Else
  NewCmd     := Cmd;
 urlContext := '';
 UrlMethod  := '';
 If Not Assigned(Result) Then
  Begin
   Result := TDWParams.Create;
   Result.Encoding := vEncoding;
   {$IFDEF FPC}
   Result.DatabaseCharSet := DatabaseCharSet;
   {$ENDIF}
  End;
 If (CountExpression(NewCmd, '/') > 0) Then
  Begin
   ArraySize := CountExpression(NewCmd, '/');
   If NewCmd[InitStrPos] <> '/' then
    NewCmd := '/' + NewCmd
   Else
    NewCmd := Copy(NewCmd, 2, Length(NewCmd));
   If NewCmd[Length(NewCmd) - FinalStrPos] <> '/' Then
    NewCmd := NewCmd + '/';
//   iBar1 := Pos('/', NewCmd);
//   Delete(NewCmd, InitStrPos, iBar1);
   For Cont := 0 to ArraySize - 1 Do
    Begin
     IBar2     := Pos('/', NewCmd);
     {$IFNDEF FPC}
      {$IF (DEFINED(OLDINDY))}
       vTempData := TIdURI.URLDecode(Copy(NewCmd, 1, IBar2 - 1));
      {$ELSE}
       vTempData := TIdURI.URLDecode(Copy(NewCmd, 1, IBar2 - 1), GetEncodingID(vEncoding));
      {$IFEND}
     {$ELSE}
      vTempData := TIdURI.URLDecode(Copy(NewCmd, 1, IBar2 - 1), GetEncodingID(vEncoding));
     {$ENDIF}
     If (Cont = ArraySize -1) or ((UrlMethod = '') and (Cont = ArraySize -1)) Then
      UrlMethod := Copy(NewCmd, 1, IBar2 - 1);
     If ((Cont = ArraySize -2) And (ArraySize > 1)) Or (UrlMethod = '') Then
      If (vTempData <> '') then
       urlContext := vTempData;
     NewCmd := Copy(NewCmd, IBar2 +1, Length(NewCmd));
    End;
   ArraySize := CountExpression(vArrayValues, '&');
   If ArraySize = 0 Then
    Begin
     If Length(vArrayValues) > 0 Then
      ArraySize := 1;
    End
   Else
    ArraySize := ArraySize + 1;
   For Cont := 0 to ArraySize - 1 Do
    Begin
     IBar2     := Pos('&', vArrayValues);
     If IBar2 = 0 Then
      Begin
       IBar2    := Length(vArrayValues);
       vTempData := Copy(vArrayValues, 1, IBar2);
      End
     Else
      vTempData := Copy(vArrayValues, 1, IBar2 - 1);
      If Pos('dwmark:', vTempData) > 0 Then
       mark := Copy(vTempData, Pos('dwmark:', vTempData) + 7, Length(vTempData))
      Else
       Begin
        If Pos('=', vTempData) > 0 Then
         Begin
          JSONParam := TJSONParam.Create(Result.Encoding);
          JSONParam.ObjectDirection := odIN;
          JSONParam.ParamName := Copy(vTempData, 1, Pos('=', vTempData) - 1);
          Delete(vTempData, 1, Pos('=', vTempData));
          {$IFDEF FPC}
           vTempData          := URLDecode(vTempData);
          {$ELSE}
           {$IFNDEF FPC}
            {$IF (DEFINED(OLDINDY))}
             vTempData          := TIdURI.URLDecode(vTempData);
            {$ELSE}
             vTempData          := TIdURI.URLDecode(vTempData, GetEncodingID(vEncoding));
            {$IFEND}
           {$ELSE}
            vTempData          := TIdURI.URLDecode(vTempData, GetEncodingID(vEncoding));
           {$ENDIF}
          {$ENDIF}
          JSONParam.SetValue(vTempData);
         End
        Else
         Begin
          JSONParam := Result.ItemsString[cUndefined];
          If JSONParam = Nil Then
           Begin
            JSONParam := TJSONParam.Create(Result.Encoding);
            JSONParam.ParamName := cUndefined;//Format('PARAM%d', [0]);
            JSONParam.ObjectDirection := odIN;
           End;
          JSONParam.SetValue(vTempData);
         End;
        Result.Add(JSONParam);
       End;
     Delete(vArrayValues, 1, IBar2);
    End;
  End;
End;

{Tiago IStuque - 28/12/2018}
class Function TServerUtils.ParseBodyBinToDWParam(const BodyBin    : String;
                                                  vEncoding        : TEncodeSelect;
                                                  var ResultPR     : TDWParams{$IFDEF FPC}
                                                  ;DatabaseCharSet : TDatabaseCharSet
                                                  {$ENDIF})        : Boolean;
var
  JSONParam: TJSONParam;
  vContentType: string;
begin
 if (BodyBin <> EmptyStr) then
 Begin
  If Not Assigned(ResultPR) Then
   Begin
    ResultPR := TDWParams.Create;
    ResultPR.Encoding := vEncoding;
    {$IFDEF FPC}
    ResultPR.DatabaseCharSet := DatabaseCharSet;
    {$ENDIF}
   End;
  JSONParam                 := TJSONParam.Create(ResultPR.Encoding);
  JSONParam.ObjectDirection := odIN;
  If Assigned(ResultPR.ItemsString['dwParamNameBody']) And (ResultPR.ItemsString['dwParamNameBody'].AsString<>'') Then
   JSONParam.ParamName       := ResultPR.ItemsString['dwParamNameBody'].AsString
  Else
   JSONParam.ParamName       := 'UNDEFINED';
  JSONParam.SetValue(BodyBin, True);
  ResultPR.Add(JSONParam);
  If Assigned(ResultPR.ItemsString['dwFileNameBody']) And (ResultPR.ItemsString['dwFileNameBody'].AsString<>'') Then
   Begin
    JSONParam   := TJSONParam.Create(ResultPR.Encoding);
    JSONParam.ObjectDirection := odIN;
    JSONParam.ParamName := 'dwfilename';
    JSONParam.SetValue(ResultPR.ItemsString['dwFileNameBody'].AsString, JSONParam.Encoded);
    ResultPR.Add(JSONParam);
    If Not Assigned(ResultPR.ItemsString['Content-Type']) then
     Begin
       vContentType:= GetMIMEType(ResultPR.ItemsString['dwFileNameBody'].AsString);
       If vContentType <> '' then
        Begin
         JSONParam   := TJSONParam.Create(ResultPR.Encoding);
         JSONParam.ObjectDirection := odIN;
         JSONParam.ParamName := 'Content-Type';
         JSONParam.SetValue(vContentType, JSONParam.Encoded);
         ResultPR.Add(JSONParam);
        End;
     End;
   End;
 End;
end;

class Function TServerUtils.ParseFormParamsToDWParam(Const FormParams : String;
                                                     vEncoding        : TEncodeSelect;
                                                     var ResultPR     : TDWParams{$IFDEF FPC}
                                                     ;DatabaseCharSet : TDatabaseCharSet
                                                     {$ENDIF})        : Boolean;
Var
 JSONParam: TJSONParam;
 i            : Integer;
 vTempValue,
 vObjectName,
 vArrayValues : String;
 vParamList   : TStringList;
 Function FindValue(ParamList   : TStringList; Var IndexValue : Integer) : String;
 Var
  vFlagnew : Boolean;
 Begin
  vFlagnew := False;
  Result := '';
  While IndexValue <= ParamList.Count -1 Do
   Begin
    If vFlagnew Then
     Begin
      Result := ParamList[IndexValue];
      Break;
     End
    Else
     vFlagnew := ParamList[IndexValue] = '';
    Inc(IndexValue);
   End;
 End;
begin
 vArrayValues := StringReplace(FormParams, '=' + sLineBreak,   '', [rfReplaceAll]);
 vParamList      := TStringList.Create;
 Try
  If (vArrayValues <> EmptyStr) Then
   Begin
    vParamList.Text := vArrayValues;
    I := 0;
    While I <= vParamList.Count -1 Do
     Begin
      If Not Assigned(ResultPR) Then
       Begin
        ResultPR := TDWParams.Create;
        ResultPR.Encoding := vEncoding;
        {$IFDEF FPC}
        ResultPR.DatabaseCharSet := DatabaseCharSet;
        {$ENDIF}
       End;
      vObjectName := Copy(lowercase(vParamList[I]), Pos('; name="', lowercase(vParamList[I])) + length('; name="'),  length(lowercase(vParamList[I])));
      vObjectName := Copy(vObjectName, InitStrPos, Pos('"', vObjectName) -1);
      If vObjectName = '' Then
       Begin
        Inc(I);
        Continue;
       End;
      JSONParam                 := TJSONParam.Create(ResultPR.Encoding);
      JSONParam.ObjectDirection := odIN;
      JSONParam.ParamName       := vObjectName;
      vTempValue := FindValue(vParamList, I);
      If (Pos(Lowercase('{"ObjectType":"toParam", "Direction":"'), lowercase(vTempValue)) > 0) Or
         (Pos(Lowercase('{"ObjectType":"toObject", "Direction":"'), lowercase(vTempValue)) > 0) Then
       JSONParam.FromJSON(vTempValue)
      Else
       JSONParam.SetValue(vTempValue, True);
      ResultPR.Add(JSONParam);
      Inc(I);
     End;
   End;
 Finally
  FreeAndNil(vParamList);
 End;
end;

{Tiago IStuque - 28/12/2018}
class Function TServerUtils.ParseBodyRawToDWParam(const BodyRaw    : String;
                                                  vEncoding        : TEncodeSelect;
                                                  var ResultPR     : TDWParams{$IFDEF FPC}
                                                  ;DatabaseCharSet : TDatabaseCharSet
                                                  {$ENDIF})        : Boolean;
var
  JSONParam: TJSONParam;
begin
 If (BodyRaw <> EmptyStr) Then
 Begin
  If Not Assigned(ResultPR) Then
   Begin
    ResultPR := TDWParams.Create;
    ResultPR.Encoding := vEncoding;
    {$IFDEF FPC}
    ResultPR.DatabaseCharSet := DatabaseCharSet;
    {$ENDIF}
   End;
  JSONParam                 := TJSONParam.Create(ResultPR.Encoding);
  JSONParam.ObjectDirection := odIN;
  If Assigned(ResultPR.ItemsString['dwNameParamBody']) And (ResultPR.ItemsString['dwNameParamBody'].AsString<>'') Then
   JSONParam.ParamName       := ResultPR.ItemsString['dwNameParamBody'].AsString
  Else
   JSONParam.ParamName       := 'UNDEFINED';
  JSONParam.SetValue(BodyRaw, True);
  ResultPR.Add(JSONParam);
 End;
end;

Class Function TServerUtils.ParseDWParamsURL(Const Cmd        : String;
                                             vEncoding        : TEncodeSelect;
                                             Var ResultPR     : TDWParams{$IFDEF FPC}
                                             ;DatabaseCharSet : TDatabaseCharSet
                                             {$ENDIF})        : Boolean;
Var
 vTempData,
 vArrayValues: String;
 ArraySize,
 IBar2, Cont : Integer;
 JSONParam   : TJSONParam;
 vParamList  : TStringList;
 Function CountExpression(Value: String; Expression: Char): Integer;
 Var
  I : Integer;
 Begin
  Result := 0;
  For I := 0 To Length(Value) - 1 Do
   Begin
    If Value[I] = Expression Then
     Inc(Result);
   End;
 End;
Begin
 vArrayValues := Cmd;
 vParamList      := TStringList.Create;
 vParamList.Text := vArrayValues;
 If vParamList.Count <= 1 Then
  Begin
   Result := Pos('=', vArrayValues) > 0;
   If Result Then
    Begin
     If Not Assigned(ResultPR) Then
      Begin
       ResultPR := TDWParams.Create;
       ResultPR.Encoding := vEncoding;
       {$IFDEF FPC}
       ResultPR.DatabaseCharSet := DatabaseCharSet;
       {$ENDIF}
      End;
     JSONParam  := Nil;
     ArraySize := CountExpression(vArrayValues, '&');
     If ArraySize = 0 Then
      Begin
       If Length(vArrayValues) > 0 Then
        ArraySize := 1;
      End
     Else
      ArraySize := ArraySize + 1;
     For Cont := 0 to ArraySize - 1 Do
      Begin
       IBar2     := Pos('&', vArrayValues);
       If IBar2 = 0 Then
        Begin
         IBar2    := Length(vArrayValues);
         vTempData := Copy(vArrayValues, 1, IBar2);
        End
       Else
        vTempData := Copy(vArrayValues, 1, IBar2 - 1);
       If Pos('=', vTempData) > 0 Then
        Begin
         JSONParam := TJSONParam.Create(ResultPR.Encoding);
         JSONParam.ObjectDirection := odIN;
         JSONParam.ParamName := Copy(vTempData, 1, Pos('=', vTempData) - 1);
         Delete(vTempData, 1, Pos('=', vTempData));
         {$IFNDEF FPC}
          {$IF (DEFINED(OLDINDY))}
           JSONParam.SetValue(TIdURI.URLDecode(StringReplace(vTempData, '+', ' ', [rfReplaceAll])));
          {$ELSE}
           JSONParam.SetValue(TIdURI.URLDecode(StringReplace(vTempData, '+', ' ', [rfReplaceAll]), GetEncodingID(ResultPR.Encoding)));
          {$IFEND}
         {$ELSE}
          JSONParam.SetValue(TIdURI.URLDecode(StringReplace(vTempData, '+', ' ', [rfReplaceAll]), GetEncodingID(ResultPR.Encoding)));
         {$ENDIF}
        End
       Else
        Begin
         JSONParam := ResultPR.ItemsString[cUndefined];
         If JSONParam = Nil Then
          Begin
           JSONParam := TJSONParam.Create(ResultPR.Encoding);
           JSONParam.ObjectDirection := odIN;
           JSONParam.ParamName := cUndefined;//Format('PARAM%d', [0]);
          End;
         {$IFNDEF FPC}
          {$IF (DEFINED(OLDINDY))}
           JSONParam.SetValue(TIdURI.URLDecode(StringReplace(vTempData, '+', ' ', [rfReplaceAll])));
          {$ELSE}
           JSONParam.SetValue(TIdURI.URLDecode(StringReplace(vTempData, '+', ' ', [rfReplaceAll]), GetEncodingID(ResultPR.Encoding)));
          {$IFEND}
         {$ELSE}
          JSONParam.SetValue(TIdURI.URLDecode(StringReplace(vTempData, '+', ' ', [rfReplaceAll]), GetEncodingID(ResultPR.Encoding)));
         {$ENDIF}
        End;
       ResultPR.Add(JSONParam);
       Delete(vArrayValues, 1, IBar2);
      End;
    End;
  End
 Else
  Begin
   // Verificar se conteudo Body/Raw é um JSON para casos em que não se passa parametro indicando a presente de JSON
   // Ico Menezes - 30/08/2019
   Result   := True;
   vArrayValues := StringReplace(Trim(vArrayValues), #239#187#191, '', [rfReplaceAll]);
   vArrayValues := StringReplace(vArrayValues, sLineBreak,   '', [rfReplaceAll]);
   If (vArrayValues[InitStrPos] = '[') or (vArrayValues[InitStrPos] = '{') then
   begin
    JSONParam := TJSONParam.Create(ResultPR.Encoding);
    JSONParam.ParamName       := 'UNDEFINED';
    JSONParam.ObjectDirection := odIN;
    JSONParam.SetValue(vArrayValues, True);
    ResultPR.Add(JSONParam)
   end
   else
   begin
    For Cont := 0 to vParamList.Count - 1 Do
    Begin
     JSONParam := TJSONParam.Create(ResultPR.Encoding);
     JSONParam.ParamName := vParamList.Names[cont];
     JSONParam.ObjectDirection := odIN;
     JSONParam.SetValue(vParamList.Values[vParamList.Names[cont]]);
     ResultPR.Add(JSONParam);
    End;
   end;
  End;
 vParamList.Free;
End;

Class Procedure TServerUtils.ParseWebFormsParams (Var DWParams       : TDWParams;
                                                  Params             : TStrings;
                                                  Const URL,
                                                  Query              : String;
                                                  Var UrlMethod,
                                                  urlContext,
                                                  mark               : String;
                                                  vEncoding          : TEncodeSelect;
                                                  {$IFDEF FPC}
                                                   DatabaseCharSet   : TDatabaseCharSet;
                                                  {$ENDIF}
                                                  MethodType         : String = 'POST');
Var
  I: Integer;
  vTempValue,
  Cmd: String;
  JSONParam: TJSONParam;
  vParams : TStringList;
  Uri : TIdURI;
Begin
  // Extrai nome do ServerMethod
 If DWParams = Nil Then
  Begin
   DWParams := TDWParams.Create;
   DWParams.Encoding := vEncoding;
   {$IFDEF FPC}
   DWParams.DatabaseCharSet := DatabaseCharSet;
   {$ENDIF}
  End;
 JSONParam := Nil;
  If Pos('?', URL) > 0 Then
   Begin
    Cmd := URL;
    I := Pos('?', Cmd);
    UrlMethod := StringReplace(Copy(Cmd, 1, I - 1), '/', '', [rfReplaceAll]);
    Delete(Cmd, 1, I);
//    I := Pos('?', Cmd);
   End
  Else
   Begin
    Cmd := URL + '/';
    I := Pos('/', Cmd);
    Delete(Cmd, 1, I);
    UrlMethod := '';
    urlContext := '';
    While Pos('/', Cmd) > 0 Do
     Begin
      I := Pos('/', Cmd);
      If (urlContext = '') Or
         ((urlContext <> '') And (UrlMethod <> '')) Then
       Begin
        urlContext := UrlMethod;
        UrlMethod  := Copy(Cmd, 1, I - 1);
       End
      Else If UrlMethod = '' Then
       UrlMethod := Copy(Cmd, 1, I - 1);
      Delete(Cmd, 1, I);
     End;
    If UrlMethod = '' Then
     Begin
      UrlMethod  := urlContext;
      urlContext := '';
     End;
   End;
  // Extrai Parametros
  If (Params.Count > 0) And (MethodType = 'POST') Then
   Begin
    Params.Text := TIdURI.URLDecode(Params.Text);
    For I := 0 To Params.Count - 1 Do
     Begin
      If Pos('dwmark:', Params[I]) > 0 Then
       mark := Copy(Params[I], Pos('dwmark:', Params[I]) + 7, Length(Params[I]))
      Else
       Begin
        JSONParam := TJSONParam.Create(DWParams.Encoding);
        JSONParam.ObjectDirection := odIN;
        If Pos('{"ObjectType":"toParam", "Direction":"', Params[I]) > 0 Then
         Begin
          If Pos('=', Params[I]) > 0 Then
           JSONParam.FromJSON(Trim(Copy(Params[I], Pos('=', Params[I]) + 1, Length(Params[I]))))
          Else
           JSONParam.FromJSON(Params[I]);
         End
        Else
         Begin
          JSONParam.ParamName := Copy(Params[I], 1, Pos('=', Params[I]) - 1);
          If DWParams.Encoding = esUtf8 then
           JSONParam.AsString  := Utf8Encode(Trim(Copy(Params[I], Pos('=', Params[I]) + 1, Length(Params[I]))))
          Else
           JSONParam.AsString  := Trim(Copy(Params[I], Pos('=', Params[I]) + 1, Length(Params[I])));
          If JSONParam.AsString = '' Then
           JSONParam.Encoded         := False;
         End;
        DWParams.Add(JSONParam);
       End;
     End;
   End
  Else
   Begin
    vParams := TStringList.Create;
    vParams.Delimiter := '&';
    {$IFNDEF FPC}{$if CompilerVersion > 21}vParams.StrictDelimiter := true;{$IFEND}{$ENDIF}
    If pos(UrlMethod + '/', Cmd) > 0 Then
     Cmd := StringReplace(UrlMethod + '/', Cmd, '', [rfReplaceAll]);
    If (MethodType = 'GET') Then
     Begin
      If ((Params.Count > 0) And (Pos('?', URL) = 0)) And (Query = '') then
       Cmd := Cmd + Params.Text
      Else
       Cmd := Cmd + TIdURI.URLDecode(Query);
     End
    Else
     Begin
      If ((Params.Count > 0) And (Pos('?', URL) = 0)) And (Query = '') then
       Cmd := Cmd + TIdURI.URLDecode(Params.Text)
      Else
       Cmd := Cmd + TIdURI.URLDecode(Query);
     End;
    Uri := TIdURI.Create(Cmd);
    Try
     vParams.DelimitedText := Uri.Params;
     If vParams.count = 0 Then
      If Trim(Cmd) <> '' Then
       vParams.DelimitedText := StringReplace(Cmd, sLineBreak, '&', [rfReplaceAll]); //Alterações enviadas por "joaoantonio19"
       //vParams.Add(Cmd);
    Finally
     Uri.Free;
     For I := 0 To vParams.Count - 1 Do
      Begin
       If Pos('dwmark:', vParams[I]) > 0 Then
        mark := Copy(vParams[I], Pos('dwmark:', vParams[I]) + 7, Length(vParams[I]))
       Else
        Begin
         If vParams[I] <> '' Then
          Begin
           JSONParam                 := TJSONParam.Create(DWParams.Encoding);
           JSONParam.ObjectDirection := odIN;
           JSONParam.ParamName       := Trim(Copy(vParams[I], 1, Pos('=', vParams[I]) - 1));
           JSONParam.AsString        := Trim(Copy(vParams[I],    Pos('=', vParams[I]) + 1, Length(vParams[I])));
           DWParams.Add(JSONParam);
          End;
        End;
      End;
     vParams.Free;
    End;
   End;
End;

Class Procedure TServerUtils.ParseWebFormsParams(Params             : TStrings;
                                                 Const URL,
                                                 Query              : String;
                                                 Var UrlMethod,
                                                 urlContext,
                                                 mark               : String;
                                                 vEncoding          : TEncodeSelect;
                                                 {$IFDEF FPC}
                                                  DatabaseCharSet   : TDatabaseCharSet;
                                                 {$ENDIF}
                                                 Var Result         : TDWParams;
                                                 MethodType         : String = 'POST');
Var
  I: Integer;
  vTempValue,
  Cmd: String;
  JSONParam: TJSONParam;
  vParams : TStringList;
  Uri : TIdURI;
  vValue : String;
Begin
  // Extrai nome do ServerMethod
 If Not Assigned(Result) Then
  Begin
   Result := TDWParams.Create;
   Result.Encoding := vEncoding;
   {$IFDEF FPC}
   Result.DatabaseCharSet := DatabaseCharSet;
   {$ENDIF}
  End;
 JSONParam := Nil;
  If Pos('?', URL) > 0 Then
   Begin
    Cmd := URL;
    I := Pos('?', Cmd);
    UrlMethod := StringReplace(Copy(Cmd, 1, I - 1), '/', '', [rfReplaceAll]);
    Delete(Cmd, 1, I);
//    I := Pos('?', Cmd);
   End
  Else
   Begin
    Cmd := URL + '/';
    I := Pos('/', Cmd);
    Delete(Cmd, 1, I);
    UrlMethod := '';
    urlContext := '';
    While Pos('/', Cmd) > 0 Do
     Begin
      I := Pos('/', Cmd);
      If (urlContext = '') Or
         ((urlContext <> '') And (UrlMethod <> '')) Then
       Begin
        urlContext := UrlMethod;
        UrlMethod  := Copy(Cmd, 1, I - 1);
       End
      Else If UrlMethod = '' Then
       UrlMethod := Copy(Cmd, 1, I - 1);
      Delete(Cmd, 1, I);
     End;
    If UrlMethod = '' Then
     Begin
      UrlMethod  := urlContext;
      urlContext := '';
     End;
   End;
  // Extrai Parametros
  If (Params.Count > 0) And (MethodType = 'POST') Then
   Begin
    {$IFNDEF FPC}
    Params.Text := TIdURI.URLDecode(Params.Text);
    {$ENDIF}
    For I := 0 To Params.Count - 1 Do
     Begin
      If Pos('dwmark:', Params[I]) > 0 Then
       mark := Copy(Params[I], Pos('dwmark:', Params[I]) + 7, Length(Params[I]))
      Else
       Begin
        JSONParam := TJSONParam.Create(Result.Encoding);
        {$IFDEF FPC}
        JSONParam.DatabaseCharSet := DatabaseCharSet;
        {$ENDIF}
        JSONParam.ObjectDirection := odIN;
        If Pos('{"ObjectType":"toParam", "Direction":"', Params[I]) > 0 Then
         Begin
          If Pos('=', Params[I]) > 0 Then
           JSONParam.FromJSON(Trim(Copy(Params[I], Pos('=', Params[I]) + 1, Length(Params[I]))))
          Else
           JSONParam.FromJSON(Params[I]);
         End
        Else
         Begin
          JSONParam.ParamName := Copy(Params[I], 1, Pos('=', Params[I]) - 1);
          vValue  := Trim(Copy(Params[I], Pos('=', Params[I]) + 1, Length(Params[I])));
          {$IFNDEF FPC}
           If Result.Encoding = esUtf8 then
            vValue   := Utf8Encode(vValue);
          {$ENDIF}
          JSONParam.AsString   := vValue;
          If JSONParam.AsString = '' Then
           JSONParam.Encoded         := False;
         End;
        Result.Add(JSONParam);
       End;
     End;
   End
  Else
   Begin
    vParams := TStringList.Create;
    vParams.Delimiter := '&';
    {$IFNDEF FPC}{$if CompilerVersion > 21}vParams.StrictDelimiter := true;{$IFEND}{$ENDIF}
    If pos(UrlMethod + '/', Cmd) > 0 Then
     Cmd := StringReplace(UrlMethod + '/', Cmd, '', [rfReplaceAll]);
    If (MethodType = 'GET') Then
     Begin
      If ((Params.Count > 0) And (Pos('?', URL) = 0)) And (Query = '') then
       Cmd := Cmd + Params.Text
      Else
       Cmd := Cmd + TIdURI.URLDecode(Query);
     End
    Else
     Begin
      If ((Params.Count > 0) And (Pos('?', URL) = 0)) And (Query = '') then
       Cmd := Cmd + TIdURI.URLDecode(Params.Text)
      Else
       Cmd := Cmd + TIdURI.URLDecode(Query);
     End;
    Uri := TIdURI.Create(Cmd);
    Try
     vParams.DelimitedText := Uri.Params;
     If vParams.count = 0 Then
      If Trim(Cmd) <> '' Then
       vParams.DelimitedText := StringReplace(Cmd, sLineBreak, '&', [rfReplaceAll]); //Alterações enviadas por "joaoantonio19"
       //vParams.Add(Cmd);
    Finally
     Uri.Free;
     For I := 0 To vParams.Count - 1 Do
      Begin
       If Pos('dwmark:', vParams[I]) > 0 Then
        mark := Copy(vParams[I], Pos('dwmark:', vParams[I]) + 7, Length(vParams[I]))
       Else
        Begin
         If vParams[I] <> '' Then
          Begin
           JSONParam                 := TJSONParam.Create(Result.Encoding);
           JSONParam.ObjectDirection := odIN;
           JSONParam.ParamName       := Trim(Copy(vParams[I], 1, Pos('=', vParams[I]) - 1));
           JSONParam.AsString        := Trim(Copy(vParams[I],    Pos('=', vParams[I]) + 1, Length(vParams[I])));
           {$IFDEF FPC}
           JSONParam.DatabaseCharSet := DatabaseCharSet;
           {$ENDIF}
           Result.Add(JSONParam);
          End;
        End;
      End;
     vParams.Free;
    End;
   End;
End;

Class Function TServerUtils.Result2JSON(wsResult: TResultErro): String;
Begin
  Result := '{"STATUS":"' + wsResult.Status + '","MENSSAGE":"' +
    wsResult.MessageText + '"}';
End;

constructor TServerMethods.Create(aOwner: TComponent);
begin
  inherited;
end;

destructor TServerMethods.Destroy;
begin
  inherited;
end;

Function TServerMethods.ReturnIncorrectArgs: String;
Var
  wsResult: TResultErro;
Begin
  wsResult.Status := '-1';
  wsResult.MessageText := 'Total de argumentos menor que o esperado';
  Result := TServerUtils.Result2JSON(wsResult);
End;

Function TServerMethods.ReturnMethodNotFound: String;
Var
  wsResult: TResultErro;
Begin
  wsResult.Status := '-2';
  wsResult.MessageText := 'Metodo nao encontrado';
  Result := TServerUtils.Result2JSON(wsResult);
End;

procedure TServerMethods.SetClientWelcomeMessage(Value: String);
begin
 vClientWelcomeMessage := Value;
end;

end.

