unit uDWPoolerMethod;

{
  REST Dataware versão CORE.
  Criado por XyberX (Gilbero Rocha da Silva), o REST Dataware tem como objetivo o uso de REST/JSON
 de maneira simples, em qualquer Compilador Pascal (Delphi, Lazarus e outros...).
  O REST Dataware também tem por objetivo levar componentes compatíveis entre o Delphi e outros Compiladores
 Pascal e com compatibilidade entre sistemas operacionais.
  Desenvolvido para ser usado de Maneira RAD, o REST Dataware tem como objetivo principal você usuário que precisa
 de produtividade e flexibilidade para produção de Serviços REST/JSON, simplificando o processo para você programador.

 Membros do Grupo :

 XyberX (Gilberto Rocha)    - Admin - Criador e Administrador do CORE do pacote.
 Ivan Cesar                 - Admin - Administrador do CORE do pacote.
 Joanan Mendonça Jr. (jlmj) - Admin - Administrador do CORE do pacote.
 Giovani da Cruz            - Admin - Administrador do CORE do pacote.
 Alexandre Abbade           - Admin - Administrador do desenvolvimento de DEMOS, coordenador do Grupo.
 Alexandre Souza            - Admin - Administrador do Grupo de Organização.
 Anderson Fiori             - Admin - Gerencia de Organização dos Projetos
 Mizael Rocha               - Member Tester and DEMO Developer.
 Flávio Motta               - Member Tester and DEMO Developer.
 Itamar Gaucho              - Member Tester and DEMO Developer.
}

Interface

Uses {$IFDEF FPC}
     SysUtils,   uSystemEvents, uDWConstsData, Classes, SysTypes,   ServerUtils, {$IFDEF WINDOWS}Windows,{$ENDIF}
     uDWConsts,          uRESTDWBase,        uDWJSONTools,        uDWMassiveBuffer,  uDWJSONObject, uDWConstsCharset;
     {$ELSE}
     {$IF CompilerVersion <= 22}
     SysUtils, Classes,
     {$ELSE}
     System.SysUtils, System.Classes,
     {$IFEND}
     uSystemEvents, uDWMassiveBuffer, SysTypes,   uDWConstsData, uDWConstsCharset, ServerUtils,        {$IFDEF WINDOWS} Windows, {$ENDIF}
     uDWConsts,  uRESTDWBase,        uDWJSONTools,     uDWJSONObject;
     {$ENDIF}

 Type
  TDWPoolerMethodClient  = Class(TComponent)
  Private
   vOnWork               : TOnWork;
   vOnWorkBegin          : TOnWorkBegin;
   vOnWorkEnd            : TOnWorkEnd;
   vOnStatus             : TOnStatus;
   vBinaryRequest,
   vEncodeStrings,
   vCompression          : Boolean;
   vEncoding             : TEncodeSelect;
   {$IFDEF FPC}
   vDatabaseCharSet      : TDatabaseCharSet;
   {$ENDIF}
   vUserAgent,
   vPoolerURL,
   vAccessTag,
   vWelcomeMessage,
   vHost                 : String;
   vPort                 : Integer;
   vCripto               : TCripto;
   vTypeRequest          : TtypeRequest;
   Procedure SetOnWork     (Value : TOnWork);
   Procedure SetOnWorkBegin(Value : TOnWorkBegin);
   Procedure SetOnWorkEnd  (Value : TOnWorkEnd);
   Procedure SetOnStatus   (Value : TOnStatus);
  Public
   Constructor Create(AOwner: TComponent);Override;
   Destructor  Destroy;Override;
   Function GetPoolerList         (Method_Prefix           : String;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : TStringList;Overload;
   Function GetServerEvents       (Method_Prefix           : String;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : TStringList;Overload;
   Function EchoPooler            (Method_Prefix,
                                   Pooler                  : String;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : String;
   //Roda Comando SQL
   Function InsertValue           (Pooler, Method_Prefix,
                                   SQL                     : String;
                                   Params                  : TDWParams;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : Integer;
   Function ExecuteCommand        (Pooler, Method_Prefix,
                                   SQL                     : String;
                                   Params                  : TDWParams;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   Var RowsAffected        : Integer;
                                   Execute                 : Boolean;
                                   BinaryRequest           : Boolean;
                                   BinaryCompatibleMode    : Boolean;
                                   Metadata                : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : TJSONValue;
   Function OpenDatasets          (LinesDataset,
                                   Pooler,
                                   Method_Prefix           : String;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : String;
   Function ApplyUpdates          (Massive                 : TMassiveDatasetBuffer;
                                   Pooler, Method_Prefix,
                                   SQL                     : String;
                                   Params                  : TDWParams;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   Var RowsAffected        : Integer;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   MassiveBuffer           : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)    : TJSONValue;Overload;
   Function ApplyUpdates          (LinesDataset,
                                   Pooler,
                                   Method_Prefix           : String;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)    : String;Overload;
   Function  ApplyUpdates_MassiveCache(MassiveCache,
                                       Pooler, Method_Prefix   : String;
                                       Var Error               : Boolean;
                                       Var MessageError        : String;
                                       Var SocketError         : Boolean;
                                       TimeOut                 : Integer = 3000;
                                       UserName                : String  = '';
                                       Password                : String  = '';
                                       ConnectionDefs          : TObject = Nil;
                                       ReflectChanges          : Boolean = False;
                                       RESTClientPooler        : TRESTClientPooler = Nil) : TJSONValue;
   Function  ProcessMassiveSQLCache   (MassiveSQLCache,
                                       Pooler, Method_Prefix   : String;
                                       Var Error               : Boolean;
                                       Var MessageError        : String;
                                       Var SocketError         : Boolean;
                                       TimeOut                 : Integer = 3000;
                                       UserName                : String  = '';
                                       Password                : String  = '';
                                       ConnectionDefs          : TObject = Nil;
                                       RESTClientPooler        : TRESTClientPooler = Nil) : TJSONValue;
   Function ExecuteCommandJSON    (Pooler, Method_Prefix,
                                   SQL                     : String;
                                   Params                  : TDWParams;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   Var RowsAffected        : Integer;
                                   Execute                 : Boolean;
                                   BinaryRequest           : Boolean;
                                   BinaryCompatibleMode    : Boolean;
                                   Metadata                : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : TJSONValue;
   Function InsertValuePure       (Pooler, Method_Prefix,
                                   SQL                     : String;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : Integer;
   Function ExecuteCommandPureJSON(Pooler,
                                   Method_Prefix,
                                   SQL                     : String;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   Var RowsAffected        : Integer;
                                   Execute                 : Boolean;
                                   BinaryRequest           : Boolean;
                                   BinaryCompatibleMode    : Boolean;
                                   Metadata                : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)   : TJSONValue;
   //Lista todos os Pooler's do Servidor
   Procedure GetPoolerList        (Method_Prefix           : String;
                                   Var PoolerList          : TStringList;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   RESTClientPooler        : TRESTClientPooler = Nil);Overload;
   //StoredProc
   Procedure  ExecuteProcedure    (Pooler,
                                   Method_Prefix,
                                   ProcName                : String;
                                   Params                  : TDWParams;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil);
   Procedure  ExecuteProcedurePure(Pooler,
                                   Method_Prefix,
                                   ProcName                : String;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil);
   Function   GetTableNames       (Pooler,
                                   Method_Prefix           : String;
                                   Var TableNames          : TStringList;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)  : Boolean;
   Function   GetFieldNames       (Pooler,
                                   Method_Prefix,
                                   TableName               : String;
                                   Var FieldNames          : TStringList;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)  : Boolean;
   Function   GetKeyFieldNames    (Pooler,
                                   Method_Prefix,
                                   TableName               : String;
                                   Var FieldNames          : TStringList;
                                   Var Error               : Boolean;
                                   Var MessageError        : String;
                                   Var SocketError         : Boolean;
                                   TimeOut                 : Integer = 3000;
                                   UserName                : String  = '';
                                   Password                : String  = '';
                                   ConnectionDefs          : TObject           = Nil;
                                   RESTClientPooler        : TRESTClientPooler = Nil)  : Boolean;
   Property Compression    : Boolean          Read vCompression     Write vCompression;
   Property BinaryRequest  : Boolean          Read vBinaryRequest   Write vBinaryRequest;
   Property Encoding       : TEncodeSelect    Read vEncoding        Write vEncoding;
   Property EncodeStrings  : Boolean          Read vEncodeStrings   Write vEncodeStrings;
   Property PoolerURL      : String           Read vPoolerURL       Write vPoolerURL;
   Property Host           : String           Read vHost            Write vHost;
   Property Port           : Integer          Read vPort            Write vPort;
   Property WelcomeMessage : String           Read vWelcomeMessage  Write vWelcomeMessage;
   Property OnWork         : TOnWork          Read vOnWork          Write SetOnWork;
   Property OnWorkBegin    : TOnWorkBegin     Read vOnWorkBegin     Write SetOnWorkBegin;
   Property OnWorkEnd      : TOnWorkEnd       Read vOnWorkEnd       Write SetOnWorkEnd;
   Property OnStatus       : TOnStatus        Read vOnStatus        Write SetOnStatus;
   {$IFDEF FPC}
   Property DatabaseCharSet: TDatabaseCharSet Read vDatabaseCharSet Write vDatabaseCharSet;
   {$ENDIF}
   Property TypeRequest    : TTypeRequest     Read vTypeRequest     Write vTypeRequest Default trHttp;
   Property AccessTag      : String           Read vAccessTag       Write vAccessTag;
   Property CriptOptions   : TCripto          Read vCripto          Write vCripto;
   Property UserAgent      : String           Read vUserAgent       Write vUserAgent;
  End;

implementation

Uses uRESTDWPoolerDB, uDWJSONInterface;
{ TDWPoolerMethodClient }

Function TDWPoolerMethodClient.ApplyUpdates(Massive                 : TMassiveDatasetBuffer;
                                            Pooler, Method_Prefix,
                                            SQL                     : String;
                                            Params                  : TDWParams;
                                            Var Error               : Boolean;
                                            Var MessageError        : String;
                                            Var SocketError         : Boolean;
                                            Var RowsAffected        : Integer;
                                            TimeOut                 : Integer = 3000;
                                            UserName                : String  = '';
                                            Password                : String  = '';
                                            MassiveBuffer           : String  = '';
                                            ConnectionDefs          : TObject           = Nil;
                                            RESTClientPooler        : TRESTClientPooler = Nil)   : TJSONValue;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse            : String;
 JSONParam            : TJSONParam;
 DWParams             : TDWParams;
 bJsonValue           : TDWJSONObject;
Begin
 Result := Nil;
 RowsAffected  := 0;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                              := TDWParams.Create;
 DWParams.Encoding                     := RESTClientPoolerExec.Encoding;
 JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName                   := 'Massive';
 JSONParam.ObjectDirection             := odIn;
 If Massive <> Nil Then
  JSONParam.AsString                   := TMassiveDatasetBuffer(Massive).ToJSON
 Else If MassiveBuffer <> '' Then
  JSONParam.AsString                   := MassiveBuffer;
 DWParams.Add(JSONParam);
 JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName                   := 'Pooler';
 JSONParam.ObjectDirection             := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString                   := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString                   := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName                   := 'Method_Prefix';
 JSONParam.ObjectDirection             := odIn;
 JSONParam.AsString                    := Method_Prefix;
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                           := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                 := 'dwConnectionDefs';
   JSONParam.ObjectDirection           := odIn;
   JSONParam.AsString                  := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 If Trim(SQL) <> '' Then
  Begin
   JSONParam                           := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                 := 'SQL';
   JSONParam.ObjectDirection           := odIn;
   If RESTClientPoolerExec.CriptOptions.Use Then
    JSONParam.AsString                 := RESTClientPoolerExec.CriptOptions.Encrypt(SQL)
   Else
    JSONParam.AsString                 := SQL;
   DWParams.Add(JSONParam);
   If Params <> Nil Then
    Begin
     If Params.Count > 0 Then
      Begin
       JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
       JSONParam.ParamName             := 'Params';
       JSONParam.ObjectDirection       := odInOut;
       If RESTClientPoolerExec.CriptOptions.Use Then
        JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Params.ToJSON)
       Else
        JSONParam.AsString             := Params.ToJSON;
       DWParams.Add(JSONParam);
      End;
    End;
  End;
 JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName                   := 'Error';
 JSONParam.ObjectDirection             := odInOut;
 JSONParam.AsBoolean                   := False;
 DWParams.Add(JSONParam);
 JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName                   := 'MessageError';
 JSONParam.ObjectDirection             := odInOut;
 JSONParam.AsString                    := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName                   := 'Result';
 JSONParam.ObjectDirection             := odOUT;
 JSONParam.ObjectValue                 := ovString;
// JSONParam.Encoded                     := False;
 JSONParam.AsString                    := '';
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'RowsAffected';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovInteger;
 DWParams.Add(JSONParam);
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('ApplyUpdates', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result          := TJSONValue.Create;
     Result.Encoding := vEncoding;
     If DWParams.ItemsString['MessageError'] <> Nil Then
      Begin
       If Not DWParams.ItemsString['MessageError'].IsNull Then
        MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
      End;
     If DWParams.ItemsString['Error'] <> Nil Then
      Begin
       If Not DWParams.ItemsString['Error'].IsNull Then
        Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
      End;
     If DWParams.ItemsString['RowsAffected'] <> Nil Then
      RowsAffected  := DWParams.ItemsString['RowsAffected'].AsInteger;
     If DWParams.ItemsString['Result'] <> Nil Then
     If Not DWParams.ItemsString['Result'].isnull Then
      Begin
       If DWParams.ItemsString['Result'].AsString <> '' Then
        Begin
         If Massive.ReflectChanges Then
          Begin
           bJsonValue  := TDWJSONObject.Create(DWParams.ItemsString['Result'].AsString);
           If bJsonValue.PairCount > 3 Then
            Result.SetValue(Decodestrings(TDWJSONObject(bJsonValue).Pairs[4].Value{$IFDEF FPC}, Result.DatabaseCharSet{$ENDIF}));
           FreeAndNil(bJsonValue);
          End
         Else
          Result.SetValue(DWParams.ItemsString['Result'].AsString);
        End;
      End;
    End
   Else
    Begin
     Error         := True;
     If (lResponse = '') Then
      MessageError  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Procedure TDWPoolerMethodClient.SetOnStatus(Value : TOnStatus);
Begin
 {$IFDEF FPC}
  vOnStatus            := Value;
 {$ELSE}
  vOnStatus            := Value;
 {$ENDIF}
End;

Procedure TDWPoolerMethodClient.SetOnWork(Value : TOnWork);
Begin
 {$IFDEF FPC}
  vOnWork            := Value;
 {$ELSE}
  vOnWork            := Value;
 {$ENDIF}
End;

Procedure TDWPoolerMethodClient.SetOnWorkBegin(Value : TOnWorkBegin);
Begin
 {$IFDEF FPC}
  vOnWorkBegin            := Value;
 {$ELSE}
  vOnWorkBegin            := Value;
 {$ENDIF}
End;

Procedure TDWPoolerMethodClient.SetOnWorkEnd(Value : TOnWorkEnd);
Begin
 {$IFDEF FPC}
  vOnWorkEnd            := Value;
 {$ELSE}
  vOnWorkEnd            := Value;
 {$ENDIF}
End;

Function  TDWPoolerMethodClient.ProcessMassiveSQLCache(MassiveSQLCache,
                                                       Pooler, Method_Prefix   : String;
                                                       Var Error               : Boolean;
                                                       Var MessageError        : String;
                                                       Var SocketError         : Boolean;
                                                       TimeOut                 : Integer = 3000;
                                                       UserName                : String  = '';
                                                       Password                : String  = '';
                                                       ConnectionDefs          : TObject = Nil;
                                                       RESTClientPooler        : TRESTClientPooler = Nil) : TJSONValue;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse        : String;
 JSONParam        : TJSONParam;
 DWParams         : TDWParams;
Begin
 Result := Nil;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MassiveSQLCache';
 JSONParam.ObjectDirection       := odIn;
// JSONParam.AsString              := MassiveCache;
 JSONParam.ObjectValue           := ovString;
// JSONParam.Encoded               := False;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.SetValue(RESTClientPoolerExec.CriptOptions.Encrypt(MassiveSQLCache), JSONParam.Encoded)
 Else
  JSONParam.SetValue(MassiveSQLCache, JSONParam.Encoded);
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovString;
// JSONParam.Encoded               := False;
 JSONParam.AsString              := '';
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('ProcessMassiveSQLCache', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result          := TJSONValue.Create;
     Result.Encoding := vEncoding;
     If Not DWParams.ItemsString['MessageError'].IsNull Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['Result'] <> Nil Then
      Begin
       If DWParams.ItemsString['Result'].AsString <> '' Then
        Result.SetValue(DWParams.ItemsString['Result'].AsString);
      End;
    End
   Else
    Begin
     Error         := True;
     If (lResponse = '') Then
      MessageError  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function TDWPoolerMethodClient.ApplyUpdates_MassiveCache(MassiveCache,
                                                         Pooler, Method_Prefix   : String;
                                                         Var Error               : Boolean;
                                                         Var MessageError        : String;
                                                         Var SocketError         : Boolean;
                                                         TimeOut                 : Integer = 3000;
                                                         UserName                : String  = '';
                                                         Password                : String  = '';
                                                         ConnectionDefs          : TObject = Nil;
                                                         ReflectChanges          : Boolean = False;
                                                         RESTClientPooler        : TRESTClientPooler = Nil) : TJSONValue;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse        : String;
 JSONParam        : TJSONParam;
 DWParams         : TDWParams;
Begin
 Result := Nil;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MassiveCache';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.ObjectValue           := ovString;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.SetValue(RESTClientPoolerExec.CriptOptions.Encrypt(MassiveCache), JSONParam.Encoded)
 Else
  JSONParam.SetValue(MassiveCache, JSONParam.Encoded);
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovString;
// JSONParam.Encoded               := False;
 JSONParam.AsString              := '';
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('ApplyUpdates_MassiveCache', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result          := TJSONValue.Create;
     Result.Encoding := vEncoding;
     If Not DWParams.ItemsString['MessageError'].IsNull Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['Result'] <> Nil Then
      Begin
       If DWParams.ItemsString['Result'].AsString <> '' Then
        Result.SetValue(DWParams.ItemsString['Result'].AsString);
      End;
    End
   Else
    Begin
     Error         := True;
     If (lResponse = '') Then
      MessageError  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Constructor TDWPoolerMethodClient.Create(AOwner: TComponent);
Begin
 Inherited;
 vCompression     := True;
 vEncodeStrings   := True;
 vBinaryRequest   := False;
 vEncoding        := esUtf8;
 {$IFNDEF FPC}
  {$if CompilerVersion < 21}
   vEncoding      := esASCII;
  {$IFEND}
 {$ENDIF}
 {$IFDEF FPC}
 vDatabaseCharSet := csUndefined;
 {$ENDIF}
 vCripto          := TCripto.Create;
 Host             := '127.0.0.1';
 Port             := 8082;
 vUserAgent       := cUserAgent;
End;

Destructor TDWPoolerMethodClient.Destroy;
Begin
 If Assigned(vCripto) Then
  FreeAndNil(vCripto);
 Inherited;
End;

Function TDWPoolerMethodClient.GetPoolerList(Method_Prefix    : String;
                                             TimeOut          : Integer = 3000;
                                             UserName         : String  = '';
                                             Password         : String  = '';
                                             RESTClientPooler : TRESTClientPooler = Nil)   : TStringList;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 vTempString,
 lResponse            : String;
 JSONParam            : TJSONParam;
 DWParams             : TDWParams;
Begin
 Result := Nil;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                := RESTClientPooler;
 RESTClientPoolerExec.WelcomeMessage  := vWelcomeMessage;
 RESTClientPoolerExec.Host            := Host;
 RESTClientPoolerExec.Port            := Port;
 RESTClientPoolerExec.UserName        := UserName;
 RESTClientPoolerExec.Password        := Password;
 RESTClientPoolerExec.RequestTimeOut  := TimeOut;
 RESTClientPoolerExec.UrlPath         := Method_Prefix;
 RESTClientPoolerExec.DataCompression := Compression;
 RESTClientPoolerExec.TypeRequest     := vtyperequest;
 RESTClientPoolerExec.OnWork          := vOnWork;
 RESTClientPoolerExec.OnWorkBegin     := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd       := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus        := vOnStatus;
 RESTClientPoolerExec.Encoding        := vEncoding;
 RESTClientPoolerExec.UserAgent       := vUserAgent;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 RESTClientPoolerExec.CriptOptions.Use:= vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key:= vCripto.Key;
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams  := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                     := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovString;
 JSONParam.AsString              := '';
// JSONParam.SetValue('', JSONParam.Encoded);
 DWParams.Add(JSONParam);
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('GetPoolerList', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result      := TStringList.Create;
     vTempString := DWParams.ItemsString['Result'].AsString;
     While Not (vTempString = '') Do
      Begin
       if Pos('|', vTempString) > 0 then
        Begin
         Result.Add(Copy(vTempString, 1, Pos('|', vTempString) -1));
         Delete(vTempString, 1, Pos('|', vTempString));
        End
       Else
        Begin
         Result.Add(Copy(vTempString, 1, Length(vTempString)));
         Delete(vTempString, 1, Length(vTempString));
        End;
      End;
    End
   Else
    Begin
     If (lResponse = '') Then
      lResponse  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      lResponse  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(lResponse);
     lResponse := '';
    End;
  Except
   On E : Exception Do
    Begin
     Raise Exception.Create(E.Message);
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function TDWPoolerMethodClient.EchoPooler(Method_Prefix,
                                          Pooler                  : String;
                                          TimeOut                 : Integer = 3000;
                                          UserName                : String  = '';
                                          Password                : String  = '';
                                          RESTClientPooler        : TRESTClientPooler = Nil) : String;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse            : String;
 JSONParam            : TJSONParam;
 DWParams             : TDWParams;
Begin
 If Not Assigned(RESTClientPooler) Then
  Begin
   RESTClientPoolerExec                  := TRESTClientPooler.Create(Nil);
   RESTClientPoolerExec.Host             := Host;
   RESTClientPoolerExec.Port             := Port;
   RESTClientPoolerExec.DataCompression  := vCompression;
   RESTClientPoolerExec.TypeRequest      := vtyperequest;
   RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
   RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
   RESTClientPoolerExec.SetAccessTag(vAccessTag);
   RESTClientPoolerExec.Encoding         := vEncoding;
   {$IFDEF FPC}
    RESTClientPoolerExec.DatabaseCharSet := vDatabaseCharSet;
   {$ENDIF}
  End
 Else
  RESTClientPoolerExec                   := RESTClientPooler;
 RESTClientPoolerExec.UserAgent          := vUserAgent;
 RESTClientPoolerExec.UserName           := UserName;
 RESTClientPoolerExec.Password           := Password;
 RESTClientPoolerExec.RequestTimeOut     := TimeOut;
 RESTClientPoolerExec.UrlPath            := Method_Prefix;
 RESTClientPoolerExec.OnWork             := vOnWork;
 RESTClientPoolerExec.OnWorkBegin        := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd          := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus           := vOnStatus;
 RESTClientPoolerExec.CriptOptions.Use   := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key   := vCripto.Key;
 DWParams                                := TDWParams.Create;
 DWParams.Encoding                       := RESTClientPoolerExec.Encoding;
 JSONParam                               := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName                     := 'Pooler';
 JSONParam.ObjectDirection               := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString                     := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString                     := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                               := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName                     := 'Result';
 JSONParam.ObjectDirection               := odOUT;
 JSONParam.ObjectValue                   := ovString;
 JSONParam.AsString                      := '';
// JSONParam.SetValue('', JSONParam.Encoded);
 DWParams.Add(JSONParam);
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('EchoPooler', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Result   := DWParams.ItemsString['Result'].AsString
   Else
    Begin
     If (lResponse = '') Then
      lResponse  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      lResponse  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(lResponse);
     lResponse   := '';
    End;
  Except
   On E : Exception Do
    Begin
     Raise Exception.Create(E.Message);
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   If Assigned(RESTClientPoolerExec) Then
    FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function TDWPoolerMethodClient.ExecuteCommand(Pooler, Method_Prefix,
                                              SQL                     : String;
                                              Params                  : TDWParams;
                                              Var Error               : Boolean;
                                              Var MessageError        : String;
                                              Var SocketError         : Boolean;
                                              Var RowsAffected        : Integer;
                                              Execute                 : Boolean;
                                              BinaryRequest           : Boolean;
                                              BinaryCompatibleMode    : Boolean;
                                              Metadata                : Boolean;
                                              TimeOut                 : Integer = 3000;
                                              UserName                : String  = '';
                                              Password                : String  = '';
                                              ConnectionDefs          : TObject           = Nil;
                                              RESTClientPooler        : TRESTClientPooler = Nil)   : TJSONValue;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse            : String;
 JSONParam            : TJSONParam;
 DWParams             : TDWParams;
Begin
 Result := Nil;
 RowsAffected  := 0;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'SQL';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(SQL)
 Else
  JSONParam.AsString             := SQL;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Params';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Params.ToJSON)
 Else
  JSONParam.AsString             := Params.ToJSON;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Execute';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := Execute;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'BinaryRequest';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := BinaryRequest;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'BinaryCompatibleMode';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := BinaryCompatibleMode;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MetadataRequest';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := Metadata;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 If Not vBinaryRequest Then
  Begin
   JSONParam.ObjectValue         := ovString;
   JSONParam.AsString            := '';
  End
 Else
  JSONParam.ObjectValue          := ovBlob;
// JSONParam.Encoded               := False;
 JSONParam.AsString              := '';
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'RowsAffected';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovInteger;
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('ExecuteCommandJSON', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result         := TJSONValue.Create;
     Result.Encoded := False;
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['RowsAffected'] <> Nil Then
      RowsAffected  := DWParams.ItemsString['RowsAffected'].AsInteger;
     If DWParams.ItemsString['Result'] <> Nil Then
      Result.LoadFromJSON(DWParams.ItemsString['Result'].AsString);
    End
   Else
    Begin
     Error         := True;
     If (lResponse = '') Then
      MessageError  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function TDWPoolerMethodClient.ExecuteCommandJSON(Pooler, Method_Prefix,
                                                  SQL                     : String;
                                                  Params                  : TDWParams;
                                                  Var Error               : Boolean;
                                                  Var MessageError        : String;
                                                  Var SocketError         : Boolean;
                                                  Var RowsAffected        : Integer;
                                                  Execute                 : Boolean;
                                                  BinaryRequest           : Boolean;
                                                  BinaryCompatibleMode    : Boolean;
                                                  Metadata                : Boolean;
                                                  TimeOut                 : Integer = 3000;
                                                  UserName                : String  = '';
                                                  Password                : String  = '';
                                                  ConnectionDefs          : TObject           = Nil;
                                                  RESTClientPooler        : TRESTClientPooler = Nil)   : TJSONValue;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse        : String;
 JSONParam        : TJSONParam;
 DWParams         : TDWParams;
Begin
 RowsAffected  := 0;
 SocketError   := False;
 Error         := False;
 MessageError  := '';
 Result        := Nil;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'SQL';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(SQL)
 Else
  JSONParam.AsString             := SQL;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Params';
 JSONParam.ObjectDirection       := odInOut;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Params.ToJSON)
 Else
  JSONParam.AsString             := Params.ToJSON;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Execute';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := Execute;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'BinaryRequest';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := BinaryRequest;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'BinaryCompatibleMode';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := BinaryCompatibleMode;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MetadataRequest';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := Metadata;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 If Not vBinaryRequest Then
  Begin
   JSONParam.ObjectValue         := ovString;
   JSONParam.AsString            := '';
  End
 Else
  JSONParam.ObjectValue          := ovBlob;
// JSONParam.SetValue('', JSONParam.Encoded);
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'RowsAffected';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovInteger;
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('ExecuteCommandJSON', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result         := TJSONValue.Create;
     Result.Encoded := False;
     Result.Encoding := RESTClientPoolerExec.Encoding;
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['RowsAffected'] <> Nil Then
      RowsAffected  := DWParams.ItemsString['RowsAffected'].AsInteger;
     If DWParams.ItemsString['Result'] <> Nil Then
      Begin
       If DWParams.ItemsString['Result'].AsString <> '' Then
        Begin
         If Not BinaryRequest Then
          Result.LoadFromJSON(DWParams.ItemsString['Result'].AsString)
         Else
          Result.SetValue(DWParams.ItemsString['Result'].AsString, False);
        End
       Else
        Result.SetValue(lResponse, False);
      End;
    End
   Else
    Begin
     Error         := True;
     If (lResponse = '') Then
      MessageError  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     SocketError   := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function TDWPoolerMethodClient.ExecuteCommandPureJSON(Pooler,
                                                      Method_Prefix,
                                                      SQL                  : String;
                                                      Var Error            : Boolean;
                                                      Var MessageError     : String;
                                                      Var SocketError      : Boolean;
                                                      Var RowsAffected     : Integer;
                                                      Execute              : Boolean;
                                                      BinaryRequest        : Boolean;
                                                      BinaryCompatibleMode : Boolean;
                                                      Metadata             : Boolean;
                                                      TimeOut              : Integer = 3000;
                                                      UserName             : String  = '';
                                                      Password             : String  = '';
                                                      ConnectionDefs       : TObject           = Nil;
                                                      RESTClientPooler     : TRESTClientPooler = Nil)   : TJSONValue;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse        : String;
 JSONParam        : TJSONParam;
 DWParams         : TDWParams;
Begin
 Result        := Nil;
 SocketError   := False;
 Error         := False;
 MessageError  := '';
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'SQL';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(SQL)
 Else
  JSONParam.AsString             := SQL;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Execute';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := Execute;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'BinaryRequest';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := BinaryRequest;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'BinaryCompatibleMode';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := BinaryCompatibleMode;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MetadataRequest';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsBoolean             := Metadata;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 If Not vBinaryRequest Then
  Begin
   JSONParam.ObjectValue         := ovString;
   JSONParam.AsString            := '';
  End
 Else
  JSONParam.ObjectValue          := ovBlob;
// JSONParam.ObjectValue           := ovString;
// JSONParam.Encoded               := True;
// JSONParam.AsString              := '';
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'RowsAffected';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovInteger;
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('ExecuteCommandPureJSON', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result          := TJSONValue.Create;
     Result.Encoded  := False;
     Result.Encoding := RESTClientPoolerExec.Encoding;
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['RowsAffected'] <> Nil Then
      RowsAffected  := DWParams.ItemsString['RowsAffected'].AsInteger;
     If DWParams.ItemsString['Result'] <> Nil Then
      Begin
       If Not (DWParams.ItemsString['Result'].IsEmpty) Then
        Begin
         If Not BinaryRequest Then
          Result.LoadFromJSON(DWParams.ItemsString['Result'].AsString)
         Else
          Result.SetValue(DWParams.ItemsString['Result'].AsString, False);
        End
       Else
        Result.SetValue(lResponse, False);
      End;
    End
   Else
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value)
     Else
      Begin
       Error         := True;
       If (lResponse = '') Then
        MessageError  := Format('Unresolved Host : ''%s''', [Host])
       Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
        MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
      End;
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     SocketError   := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Procedure TDWPoolerMethodClient.ExecuteProcedure(Pooler,
                                                 Method_Prefix,
                                                 ProcName            : String;
                                                 Params              : TDWParams;
                                                 Var Error           : Boolean;
                                                 Var MessageError    : String;
                                                 Var SocketError     : Boolean;
                                                 ConnectionDefs      : TObject           = Nil;
                                                 RESTClientPooler    : TRESTClientPooler = Nil);
Var
 JSONParam : TJSONParam;
Begin
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPooler.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   Params.Add(JSONParam);
  End;
End;

Function  TDWPoolerMethodClient.GetTableNames(Pooler,
                                              Method_Prefix           : String;
                                              Var TableNames          : TStringList;
                                              Var Error               : Boolean;
                                              Var MessageError        : String;
                                              Var SocketError         : Boolean;
                                              TimeOut                 : Integer = 3000;
                                              UserName                : String  = '';
                                              Password                : String  = '';
                                              ConnectionDefs          : TObject           = Nil;
                                              RESTClientPooler        : TRESTClientPooler = Nil)  : Boolean;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse        : String;
 JSONParam        : TJSONParam;
 DWParams         : TDWParams;
Begin
 Result        := False;
 SocketError   := False;
 Error         := False;
 MessageError  := '';
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.AsString              := '';
// JSONParam.ObjectValue           := ovBlob;
// JSONParam.Encoded               := True;
// JSONParam.SetValue('', JSONParam.Encoded);
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('GetTableNames', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['Result'] <> Nil Then
      Begin
       If Not (DWParams.ItemsString['Result'].IsEmpty) Then
        TableNames.Text := DWParams.ItemsString['Result'].AsString
       Else
        TableNames.Text := '';
      End;
     Result        := Not Error;
    End
   Else
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Begin
       Error  := StringToBoolean(DWParams.ItemsString['Error'].Value);
       Result := Not Error;
      End
     Else
      Begin
       Result := False;
       Error         := True;
       If (lResponse = '') Then
        MessageError  := Format('Unresolved Host : ''%s''', [Host])
       Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
        MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
      End;
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     SocketError   := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function  TDWPoolerMethodClient.GetFieldNames(Pooler,
                                              Method_Prefix,
                                              TableName               : String;
                                              Var FieldNames          : TStringList;
                                              Var Error               : Boolean;
                                              Var MessageError        : String;
                                              Var SocketError         : Boolean;
                                              TimeOut                 : Integer = 3000;
                                              UserName                : String  = '';
                                              Password                : String  = '';
                                              ConnectionDefs          : TObject           = Nil;
                                              RESTClientPooler        : TRESTClientPooler = Nil)  : Boolean;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse        : String;
 JSONParam        : TJSONParam;
 DWParams         : TDWParams;
Begin
 Result        := False;
 SocketError   := False;
 Error         := False;
 MessageError  := '';
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'TableName';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := TableName;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.AsString              := '';
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('GetFieldNames', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['Result'] <> Nil Then
      Begin
       If Not (DWParams.ItemsString['Result'].IsEmpty) Then
        FieldNames.Text := DWParams.ItemsString['Result'].AsString
       Else
        FieldNames.Text := '';
      End;
     Result        := Not Error;
    End
   Else
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Begin
       Error  := StringToBoolean(DWParams.ItemsString['Error'].Value);
       Result := Not Error;
      End
     Else
      Begin
       Result := False;
       Error         := True;
       If (lResponse = '') Then
        MessageError  := Format('Unresolved Host : ''%s''', [Host])
       Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
        MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
      End;
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     SocketError   := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function  TDWPoolerMethodClient.GetKeyFieldNames(Pooler,
                                                 Method_Prefix,
                                                 TableName               : String;
                                                 Var FieldNames          : TStringList;
                                                 Var Error               : Boolean;
                                                 Var MessageError        : String;
                                                 Var SocketError         : Boolean;
                                                 TimeOut                 : Integer = 3000;
                                                 UserName                : String  = '';
                                                 Password                : String  = '';
                                                 ConnectionDefs          : TObject           = Nil;
                                                 RESTClientPooler        : TRESTClientPooler = Nil)  : Boolean;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse        : String;
 JSONParam        : TJSONParam;
 DWParams         : TDWParams;
Begin
 Result        := False;
 SocketError   := False;
 Error         := False;
 MessageError  := '';
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'TableName';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := TableName;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.AsString              := '';
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('GetKeyFieldNames', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['Result'] <> Nil Then
      Begin
       If Not (DWParams.ItemsString['Result'].IsEmpty) Then
        FieldNames.Text := DWParams.ItemsString['Result'].AsString
       Else
        FieldNames.Text := '';
      End;
     Result        := Not Error;
    End
   Else
    Begin
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Error'] <> Nil Then
      Begin
       Error  := StringToBoolean(DWParams.ItemsString['Error'].Value);
       Result := Not Error;
      End
     Else
      Begin
       Result := False;
       Error         := True;
       If (lResponse = '') Then
        MessageError  := Format('Unresolved Host : ''%s''', [Host])
       Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
        MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
      End;
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     SocketError   := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Procedure TDWPoolerMethodClient.ExecuteProcedurePure(Pooler,
                                                     Method_Prefix,
                                                     ProcName            : String;
                                                     Var Error           : Boolean;
                                                     Var MessageError    : String;
                                                     Var SocketError     : Boolean;
                                                     ConnectionDefs      : TObject           = Nil;
                                                     RESTClientPooler    : TRESTClientPooler = Nil);
Var
 JSONParam : TJSONParam;
 Params    : TDWParams;
Begin
 Params := Nil;
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPooler.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   If Assigned(Params) Then
    Params.Add(JSONParam);
  End;
End;

Procedure TDWPoolerMethodClient.GetPoolerList(Method_Prefix    : String;
                                              Var PoolerList   : TStringList;
                                              TimeOut          : Integer = 3000;
                                              UserName         : String  = '';
                                              Password         : String  = '';
                                              RESTClientPooler : TRESTClientPooler = Nil);
Begin

End;

Function TDWPoolerMethodClient.GetServerEvents(Method_Prefix    : String;
                                               TimeOut          : Integer;
                                               UserName,
                                               Password         : String;
                                               RESTClientPooler : TRESTClientPooler) : TStringList;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 vTempString,
 lResponse            : String;
 JSONParam            : TJSONParam;
 DWParams             : TDWParams;
Begin
 Result := Nil;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                := RESTClientPooler;
 RESTClientPoolerExec.WelcomeMessage  := vWelcomeMessage;
 RESTClientPoolerExec.Host            := Host;
 RESTClientPoolerExec.Port            := Port;
 RESTClientPoolerExec.UserName        := UserName;
 RESTClientPoolerExec.Password        := Password;
 RESTClientPoolerExec.RequestTimeOut  := TimeOut;
 RESTClientPoolerExec.UrlPath         := Method_Prefix;
 RESTClientPoolerExec.DataCompression := Compression;
 RESTClientPoolerExec.TypeRequest     := vtyperequest;
 RESTClientPoolerExec.OnWork          := vOnWork;
 RESTClientPoolerExec.OnWorkBegin     := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd       := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus        := vOnStatus;
 RESTClientPoolerExec.Encoding        := vEncoding;
 RESTClientPoolerExec.CriptOptions.Use:= vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key:= vCripto.Key;
 RESTClientPoolerExec.UserAgent       := vUserAgent;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams  := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovString;
 JSONParam.AsString              := '';
// JSONParam.SetValue('', JSONParam.Encoded);
 DWParams.Add(JSONParam);
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('GetServerEventsList', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result      := TStringList.Create;
     vTempString := DWParams.ItemsString['Result'].AsString;
     While Not (vTempString = '') Do
      Begin
       if Pos('|', vTempString) > 0 then
        Begin
         Result.Add(Copy(vTempString, 1, Pos('|', vTempString) -1));
         Delete(vTempString, 1, Pos('|', vTempString));
        End
       Else
        Begin
         Result.Add(Copy(vTempString, 1, Length(vTempString)));
         Delete(vTempString, 1, Length(vTempString));
        End;
      End;
    End
   Else
    Begin
     If (lResponse = '') Then
      lResponse  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      lResponse  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(lResponse);
     lResponse := '';
    End;
  Except
   On E : Exception Do
    Begin
     Raise Exception.Create(E.Message);
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function TDWPoolerMethodClient.InsertValue(Pooler, Method_Prefix,
                                           SQL                     : String;
                                           Params                  : TDWParams;
                                           Var Error               : Boolean;
                                           Var MessageError        : String;
                                           Var SocketError         : Boolean;
                                           TimeOut                 : Integer = 3000;
                                           UserName                : String  = '';
                                           Password                : String  = '';
                                           ConnectionDefs          : TObject           = Nil;
                                           RESTClientPooler        : TRESTClientPooler = Nil): Integer;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse            : String;
 JSONParam            : TJSONParam;
 DWParams             : TDWParams;
Begin
 Result := -1;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'SQL';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(SQL)
 Else
  JSONParam.AsString             := SQL;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Params';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Params.ToJSON)
 Else
  JSONParam.AsString             := Params.ToJSON;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                     := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                     := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovString;
 JSONParam.AsString              := '';
// JSONParam.SetValue('', JSONParam.Encoded);
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('InsertMySQLReturnID_PARAMS', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     Result         := -1;
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Result'] <> Nil Then
      Result := StrToInt(DWParams.ItemsString['Result'].AsString);
    End
   Else
    Begin
     Error         := True;
     If (lResponse = '') Then
      MessageError  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function TDWPoolerMethodClient.InsertValuePure(Pooler, Method_Prefix,
                                               SQL                     : String;
                                               Var Error               : Boolean;
                                               Var MessageError        : String;
                                               Var SocketError         : Boolean;
                                               TimeOut                 : Integer = 3000;
                                               UserName                : String  = '';
                                               Password                : String  = '';
                                               ConnectionDefs          : TObject           = Nil;
                                               RESTClientPooler        : TRESTClientPooler = Nil): Integer;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 lResponse            : String;
 JSONParam            : TJSONParam;
 DWParams             : TDWParams;
Begin
 Result := -1;
 If Not Assigned(RESTClientPooler) Then
  RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
 Else
  RESTClientPoolerExec                 := RESTClientPooler;
 RESTClientPoolerExec.UserAgent        := vUserAgent;
 RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
 RESTClientPoolerExec.Host             := Host;
 RESTClientPoolerExec.Port             := Port;
 RESTClientPoolerExec.UserName         := UserName;
 RESTClientPoolerExec.Password         := Password;
 RESTClientPoolerExec.RequestTimeOut   := TimeOut;
 RESTClientPoolerExec.UrlPath          := Method_Prefix;
 RESTClientPoolerExec.DataCompression  := vCompression;
 RESTClientPoolerExec.TypeRequest      := vtyperequest;
 RESTClientPoolerExec.OnWork           := vOnWork;
 RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
 RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
 RESTClientPoolerExec.OnStatus         := vOnStatus;
 RESTClientPoolerExec.Encoding         := vEncoding;
 RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
 RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
 RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
 RESTClientPoolerExec.SetAccessTag(vAccessTag);
 {$IFDEF FPC}
 RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
 {$ENDIF}
 DWParams                        := TDWParams.Create;
 DWParams.Encoding               := RESTClientPoolerExec.Encoding;
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Pooler';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
 Else
  JSONParam.AsString             := Pooler;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Method_Prefix';
 JSONParam.ObjectDirection       := odIn;
 JSONParam.AsString              := Method_Prefix;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'SQL';
 JSONParam.ObjectDirection       := odIn;
 If RESTClientPoolerExec.CriptOptions.Use Then
  JSONParam.AsString             := RESTClientPoolerExec.CriptOptions.Encrypt(SQL)
 Else
  JSONParam.AsString             := SQL;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Error';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsBoolean             := False;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'MessageError';
 JSONParam.ObjectDirection       := odInOut;
 JSONParam.AsString              := MessageError;
 DWParams.Add(JSONParam);
 JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
 JSONParam.ParamName             := 'Result';
 JSONParam.ObjectDirection       := odOUT;
 JSONParam.ObjectValue           := ovString;
 JSONParam.AsString              := '';
// JSONParam.SetValue('', JSONParam.Encoded);
 DWParams.Add(JSONParam);
 If Assigned(ConnectionDefs) Then
  Begin
   JSONParam                       := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName             := 'dwConnectionDefs';
   JSONParam.ObjectDirection       := odIn;
   JSONParam.AsString              := TConnectionDefs(ConnectionDefs).ToJSON;
   DWParams.Add(JSONParam);
  End;
 Try
  Try
   RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
   lResponse := RESTClientPoolerExec.SendEvent('InsertMySQLReturnID', DWParams);
   If (lResponse <> '') And
      (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
    Begin
     If DWParams.ItemsString['Error'] <> Nil Then
      Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
     If DWParams.ItemsString['MessageError'] <> Nil Then
      MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
     If DWParams.ItemsString['Result'] <> Nil Then
      Result := StrToInt(DWParams.ItemsString['Result'].AsString);
    End
   Else
    Begin
     Error         := True;
     If (lResponse = '') Then
      MessageError  := Format('Unresolved Host : ''%s''', [Host])
     Else If (Uppercase(lResponse) <> Uppercase(cInvalidAuth)) Then
      MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
     Raise Exception.Create(MessageError);
    End;
  Except
   On E : Exception Do
    Begin
     Error         := True;
     MessageError  := E.Message;
    End;
  End;
 Finally
  If Not Assigned(RESTClientPooler) Then
   FreeAndNil(RESTClientPoolerExec);
  FreeAndNil(DWParams);
 End;
End;

Function TDWPoolerMethodClient.ApplyUpdates(LinesDataset,
                                            Pooler,
                                            Method_Prefix    : String;
                                            Var Error        : Boolean;
                                            Var MessageError : String;
                                            Var SocketError  : Boolean;
                                            TimeOut          : Integer = 3000;
                                            UserName         : String  = '';
                                            Password         : String  = '';
                                            ConnectionDefs   : TObject           = Nil;
                                            RESTClientPooler : TRESTClientPooler = Nil) : String;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 JSONParam        : TJSONParam;
 DWParams         : TDWParams;
Begin
 Result := '';
 If LinesDataset <> '' Then
  Begin
   If Not Assigned(RESTClientPooler) Then
    RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
   Else
    RESTClientPoolerExec                 := RESTClientPooler;
   RESTClientPoolerExec.UserAgent        := vUserAgent;
   RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
   RESTClientPoolerExec.Host             := Host;
   RESTClientPoolerExec.Port             := Port;
   RESTClientPoolerExec.UserName         := UserName;
   RESTClientPoolerExec.Password         := Password;
   RESTClientPoolerExec.RequestTimeOut   := TimeOut;
   RESTClientPoolerExec.UrlPath          := Method_Prefix;
   RESTClientPoolerExec.DataCompression  := vCompression;
   RESTClientPoolerExec.TypeRequest      := vtyperequest;
   RESTClientPoolerExec.TypeRequest      := vtyperequest;
   RESTClientPoolerExec.OnWork           := vOnWork;
   RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
   RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
   RESTClientPoolerExec.OnStatus         := vOnStatus;
   RESTClientPoolerExec.Encoding         := vEncoding;
   RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
   RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
   RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
   RESTClientPoolerExec.SetAccessTag(vAccessTag);
   {$IFDEF FPC}
   RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
   {$ENDIF}
   DWParams                              := TDWParams.Create;
   DWParams.Encoding                     := RESTClientPoolerExec.Encoding;
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'LinesDataset';
   JSONParam.ObjectDirection             := odIn;
   If RESTClientPoolerExec.CriptOptions.Use Then
    JSONParam.AsString                   := RESTClientPoolerExec.CriptOptions.Encrypt(LinesDataset)
   Else
     JSONParam.AsString                  := LinesDataset;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'Pooler';
   JSONParam.ObjectDirection             := odIn;
   If RESTClientPoolerExec.CriptOptions.Use Then
    JSONParam.AsString                   := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
   Else
    JSONParam.AsString                   := Pooler;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'Method_Prefix';
   JSONParam.ObjectDirection             := odIn;
   JSONParam.AsString                    := Method_Prefix;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'Error';
   JSONParam.ObjectDirection             := odInOut;
   JSONParam.AsBoolean                   := False;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'MessageError';
   JSONParam.ObjectDirection             := odInOut;
   JSONParam.AsString                    := MessageError;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'Result';
   JSONParam.ObjectDirection             := odOUT;
   JSONParam.ObjectValue                 := ovString;
   JSONParam.AsString                    := '';
//   JSONParam.SetValue('', JSONParam.Encoded);
   DWParams.Add(JSONParam);
   If Assigned(ConnectionDefs) Then
    Begin
     JSONParam                           := TJSONParam.Create(RESTClientPoolerExec.Encoding);
     JSONParam.ParamName                 := 'dwConnectionDefs';
     JSONParam.ObjectDirection           := odIn;
     JSONParam.AsString                  := TConnectionDefs(ConnectionDefs).ToJSON;
     DWParams.Add(JSONParam);
    End;
   Try
    Try
     RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
     Result := RESTClientPoolerExec.SendEvent('ApplyUpdatesSQL', DWParams);
     If (Result <> '') And
        (Uppercase(Result) <> Uppercase(cInvalidAuth)) Then
      Begin
       If DWParams.ItemsString['MessageError'] <> Nil Then
        MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
       If DWParams.ItemsString['Error'] <> Nil Then
        Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
       If DWParams.ItemsString['Result'] <> Nil Then
        Begin
         If DWParams.ItemsString['Result'].AsString <> '' Then
          Result := DWParams.ItemsString['Result'].AsString;
        End;
      End
     Else
      Begin
       Error         := True;
       If (Result = '') Then
        MessageError  := Format('Unresolved Host : ''%s''', [Host])
       Else If (Uppercase(Result) <> Uppercase(cInvalidAuth)) Then
        MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
       Raise Exception.Create(MessageError);
      End;
    Except
     On E : Exception Do
      Begin
       Error         := True;
       MessageError  := E.Message;
      End;
    End;
   Finally
    If Not Assigned(RESTClientPooler) Then
     FreeAndNil(RESTClientPoolerExec);
    FreeAndNil(DWParams);
   End;
  End;
End;

Function TDWPoolerMethodClient.OpenDatasets(LinesDataset,
                                            Pooler,
                                            Method_Prefix           : String;
                                            Var Error               : Boolean;
                                            Var MessageError        : String;
                                            Var SocketError         : Boolean;
                                            TimeOut                 : Integer = 3000;
                                            UserName                : String  = '';
                                            Password                : String  = '';
                                            ConnectionDefs          : TObject           = Nil;
                                            RESTClientPooler        : TRESTClientPooler = Nil) : String;
Var
 RESTClientPoolerExec : TRESTClientPooler;
 JSONParam            : TJSONParam;
 DWParams             : TDWParams;
 vStream              : TStringStream;
Begin
 Result := '';
 If LinesDataset <> '' Then
  Begin
   If Not Assigned(RESTClientPooler) Then
    RESTClientPoolerExec                 := TRESTClientPooler.Create(Nil)
   Else
    RESTClientPoolerExec                 := RESTClientPooler;
   RESTClientPoolerExec.UserAgent        := vUserAgent;
   RESTClientPoolerExec.WelcomeMessage   := vWelcomeMessage;
   RESTClientPoolerExec.Host             := Host;
   RESTClientPoolerExec.Port             := Port;
   RESTClientPoolerExec.UserName         := UserName;
   RESTClientPoolerExec.Password         := Password;
   RESTClientPoolerExec.RequestTimeOut   := TimeOut;
   RESTClientPoolerExec.UrlPath          := Method_Prefix;
   RESTClientPoolerExec.DataCompression  := vCompression;
   RESTClientPoolerExec.TypeRequest      := vtyperequest;
   RESTClientPoolerExec.TypeRequest      := vtyperequest;
   RESTClientPoolerExec.OnWork           := vOnWork;
   RESTClientPoolerExec.OnWorkBegin      := vOnWorkBegin;
   RESTClientPoolerExec.OnWorkEnd        := vOnWorkEnd;
   RESTClientPoolerExec.OnStatus         := vOnStatus;
   RESTClientPoolerExec.Encoding         := vEncoding;
   RESTClientPoolerExec.hEncodeStrings   := EncodeStrings;
   RESTClientPoolerExec.CriptOptions.Use := vCripto.Use;
   RESTClientPoolerExec.CriptOptions.Key := vCripto.Key;
   RESTClientPoolerExec.SetAccessTag(vAccessTag);
   {$IFDEF FPC}
   RESTClientPoolerExec.DatabaseCharSet  := vDatabaseCharSet;
   {$ENDIF}
   DWParams                              := TDWParams.Create;
   DWParams.Encoding                     := RESTClientPoolerExec.Encoding;
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'LinesDataset';
   JSONParam.ObjectDirection             := odIn;
   If RESTClientPoolerExec.CriptOptions.Use Then
    JSONParam.AsString                   := RESTClientPoolerExec.CriptOptions.Encrypt(LinesDataset)
   Else
     JSONParam.AsString                  := LinesDataset;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'Pooler';
   JSONParam.ObjectDirection             := odIn;
   If RESTClientPoolerExec.CriptOptions.Use Then
    JSONParam.AsString                   := RESTClientPoolerExec.CriptOptions.Encrypt(Pooler)
   Else
    JSONParam.AsString                   := Pooler;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'Method_Prefix';
   JSONParam.ObjectDirection             := odIn;
   JSONParam.AsString                    := Method_Prefix;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'Error';
   JSONParam.ObjectDirection             := odInOut;
   JSONParam.AsBoolean                   := False;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'MessageError';
   JSONParam.ObjectDirection             := odInOut;
   JSONParam.AsString                    := MessageError;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'BinaryRequest';
   JSONParam.ObjectDirection             := odIn;
   JSONParam.AsBoolean                   := BinaryRequest;
   DWParams.Add(JSONParam);
   JSONParam                             := TJSONParam.Create(RESTClientPoolerExec.Encoding);
   JSONParam.ParamName                   := 'Result';
   JSONParam.ObjectDirection             := odOUT;
   If Not vBinaryRequest Then
    Begin
     JSONParam.ObjectValue         := ovString;
     JSONParam.AsString            := '';
    End
   Else
    JSONParam.ObjectValue          := ovBlob;
//   JSONParam.SetValue('', JSONParam.Encoded);
   DWParams.Add(JSONParam);
   If Assigned(ConnectionDefs) Then
    Begin
     JSONParam                           := TJSONParam.Create(RESTClientPoolerExec.Encoding);
     JSONParam.ParamName                 := 'dwConnectionDefs';
     JSONParam.ObjectDirection           := odIn;
     JSONParam.AsString                  := TConnectionDefs(ConnectionDefs).ToJSON;
     DWParams.Add(JSONParam);
    End;
   Try
    Try
     RESTClientPoolerExec.BinaryRequest := vBinaryRequest;
     Result := RESTClientPoolerExec.SendEvent('OpenDatasets', DWParams);
     If (Result <> '') And
        (Uppercase(Result) <> Uppercase(cInvalidAuth)) Then
      Begin
       If DWParams.ItemsString['MessageError'] <> Nil Then
        MessageError  := DecodeStrings(DWParams.ItemsString['MessageError'].Value{$IFDEF FPC}, csUndefined{$ENDIF});
       If DWParams.ItemsString['Error'] <> Nil Then
        Error         := StringToBoolean(DWParams.ItemsString['Error'].Value);
       If DWParams.ItemsString['Result'] <> Nil Then
        Begin
         If Not DWParams.ItemsString['Result'].IsNull Then
          Begin
           If vBinaryRequest Then
            Begin
             {$IFDEF FPC}
              vStream := TStringStream.Create('');
             {$ELSE}
              vStream := TStringStream.Create(''{$if CompilerVersion > 21}, TEncoding.UTF8{$IFEND});
             {$ENDIF}
             Try
              DWParams.ItemsString['Result'].SaveToStream(vStream);
              Result := vStream.Datastring;// DWParams.ItemsString['Result'].AsString;
              If Result <> '' Then
               Begin
                If Result[InitStrPos] = '"' Then
                 Delete(Result, 1, 1);
                If Result[Length(Result) -FinalStrPos] = '"' Then
                 Delete(Result, Length(Result), 1);
               End;
             Finally
              FreeAndNil(vStream);
             End;
            End
           Else
            Result := DWParams.ItemsString['Result'].AsString;
          End;
        End;
      End
     Else
      Begin
       Error         := True;
       If (Result = '') Then
        MessageError  := Format('Unresolved Host : ''%s''', [Host])
       Else If (Uppercase(Result) <> Uppercase(cInvalidAuth)) Then
        MessageError  := Format('Unauthorized Username : ''%s''', [UserName]);
       Raise Exception.Create(MessageError);
      End;
    Except
     On E : Exception Do
      Begin
       Error         := True;
       MessageError  := E.Message;
      End;
    End;
   Finally
    If Not Assigned(RESTClientPooler) Then
     FreeAndNil(RESTClientPoolerExec);
    FreeAndNil(DWParams);
   End;
  End;
End;

end.

