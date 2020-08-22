unit uDmService;

interface

{$DEFINE APPWIN}

uses
  SysUtils, Classes, IBConnection, sqldb, SysTypes, uDWDatamodule,
  uDWJSONObject, Dialogs, ZConnection, ZDataset, ServerUtils, uDWConsts,
  uDWConstsData, uRESTDWPoolerDB, uRESTDWServerEvents, uRESTDWServerContext,
  uRestDWLazDriver, uRESTDWDriverZEOS, uDWJSONTools, LConvEncoding,
  {$IFDEF APPWIN}
  RestDWServerFormU
  {$ELSE}
  uConsts
  {$ENDIF};

Const
 WelcomeSample = False;
 Const404Page  = 'www/404.html';
 bl            = #10#13;


type

  { TServerMethodDM }

  TServerMethodDM = class(TServerMethodDataModule)
    dwcrIndex: TDWContextRules;
    dwcrLogin: TDWContextRules;
    dwsCrudServer: TDWServerContext;
    RESTDWDriverZeos1: TRESTDWDriverZeos;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    Server_FDConnection: TZConnection;
    FDQuery1: TZQuery;
    procedure dwcrIndexBeforeRenderer(aSelf: TComponent);
    procedure dwcrIndexItemscadModalBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemscadModalRequestExecute(const Params: TDWParams;
      Var ContentType, Result: String);
    procedure dwcrIndexItemsdatatableRequestExecute(const Params: TDWParams;
      Var ContentType, Result: String);
    procedure dwcrIndexItemsdeleteModalRequestExecute(const Params: TDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsdwcbCargosBeforeRendererContextItem(
      Var ContextItemTag: String);
    procedure dwcrIndexItemsdwcbCargosRequestExecute(const Params: TDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsdwcbPaisesBeforeRendererContextItem(
      Var ContextItemTag: String);
    procedure dwcrIndexItemsdwframeBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemsdwmyhtmlRequestExecute(const Params: TDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsdwsidemenuBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemseditModalRequestExecute(const Params: TDWParams;
      var ContentType, Result: String);
    procedure dwcrIndexItemsLabelMenuBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemsmeuloginnameBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwcrIndexItemsoperationRequestExecute(const Params: TDWParams;
      Var ContentType, Result: String);
    procedure dwcrLoginBeforeRenderer(aSelf: TComponent);
    procedure dwcrLoginItemsmeuloginnameBeforeRendererContextItem(
      var ContextItemTag: String);
    procedure dwsCrudServerBeforeRenderer(aSelf: TComponent);
    procedure dwsCrudServerContextListindexAuthRequest(const Params: TDWParams;
      var Rejected: Boolean; var ResultError: String; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure Server_FDConnectionBeforeConnect(Sender: TObject);
  private
    { Private declarations }
    IDUser     : Integer;
    IDUserName : String;
    Function MyMenu: String;
  public
    { Public declarations }
  end;

var
  ServerMethodDM: TServerMethodDM;

implementation

uses uDWConstsCharset;
{$R *.lfm}

Function LoadHTMLFile(FileName : String) : String;
Var
 vStringCad : TStringList;
begin
 vStringCad := TStringList.Create;
 Try
  vStringCad.LoadFromFile(FileName);
  Result := utf8decode(vStringCad.Text);
 Finally
  vStringCad.Free;
 End;
end;

Function SwapHTMLDateToDelphiDate(Value : String) : String;
Begin
 Result := Copy(Value, 1, Pos('-', Value) -1);
 Delete(Value, 1, Pos('-', Value));
 Result := Copy(Value, 1, Pos('-', Value) -1) + '/' + Result;
 Delete(Value, 1, Pos('-', Value));
 Result := Copy(Value, 1, Length(Value)) + '/' + Result;
End;

Function TServerMethodDM.MyMenu : String;
Begin
 If (IDUser > 0) Then
  Result := Format('<li class="active"><a href=# onClick="newEmployee()"><i class="fa fa-address-book"></i> <span>Novo Empregado</span></a></li>'    + bl +
                   '<li class="active"><a href=# onClick="newClientes()"><i class="fa fa-users"></i> <span>Novo Cliente</span></a></li>' + bl +
                   '<li class="active"><a href=# onClick="reloadDatatable(false)"><i class="fa fa-users"></i> <span>Lista de Empregados</span></a></li>' + bl +
                   '<li class="active"><a href="./login"><i class="fa fa-sign-out"></i> <span>Logout</span></a></li>', [Uppercase(IDUserName)])
 Else
  Result := '';
End;

procedure TServerMethodDM.ServerMethodDataModuleCreate(Sender: TObject);
begin
 {$IFDEF APPWIN}
 RESTDWPoolerDB1.Active := RestDWForm.CbPoolerState.Checked;
 {$ENDIF}
end;

procedure TServerMethodDM.Server_FDConnectionBeforeConnect(Sender: TObject);
VAR
  Driver_BD: STRING;
  Porta_BD: STRING;
  Servidor_BD: STRING;
  DataBase: STRING;
  Pasta_BD: STRING;
  Usuario_BD: STRING;
  Senha_BD: STRING;
  DataSource_BD: STRING;
  Monitor_BD: STRING;
  OsAuthent_BD: BOOLEAN;
BEGIN
   database     := RestDWForm.EdBD.Text;
   Driver_BD    := RestDWForm.CbDriver.Text;
   Monitor_BD   := RestDWForm.EdMonitor.Text;
   OsAuthent_BD := RestDWForm.cbOsAuthent.Checked;
   DataSource_BD:= RestDWForm.EdDataSource.Text;
   If RestDWForm.CkUsaURL.Checked Then
    Servidor_BD := RestDWForm.EdURL.Text
   Else
    Servidor_BD := RestDWForm.DatabaseIP;
   Case RestDWForm.CbDriver.ItemIndex Of
    0 : Begin                                                               // FB
         Pasta_BD := IncludeTrailingPathDelimiter(RestDWForm.EdPasta.Text);
         Database := RestDWForm.edBD.Text;
         Database := Pasta_BD + Database;
        End;
    1 :   Database := RestDWForm.EdBD.Text;
    2 :   Driver_BD := 'MySQL'; // Desenvolver
    3 :   Driver_BD := 'PG';    // Desenvolver
    4 :   Driver_BD := 'ODBC';
   End;
   Porta_BD   := RestDWForm.EdPortaBD.Text;
   Usuario_BD := RestDWForm.EdUserNameBD.Text;
   Senha_BD   := RestDWForm.EdPasswordBD.Text;
   TZConnection(Sender).HostName := Servidor_BD;
   TZConnection(Sender).Port     := StrToInt(Porta_BD);
   TZConnection(Sender).Database := Database;
   TZConnection(Sender).User     := Usuario_BD;
   TZConnection(Sender).Password := Senha_BD;
   TZConnection(Sender).LoginPrompt := FALSE;
End;

procedure TServerMethodDM.dwcrIndexItemscadModalRequestExecute(
  const Params: TDWParams; Var ContentType, Result: String);
Var
 JSONValue :  TJSONValue;
begin
 JSONValue            := TJSONValue.Create;
 Try
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from employee where emp_no = '+params.ItemsString['id'].AsString);
  Try
   FDQuery1.Open;
   JSONValue.JsonMode := jmPureJSON;
   JSONValue.Encoding := Encoding;
   JSONValue.DatabaseCharSet := RESTDWDriverZeos1.DatabaseCharSet;
   JSONValue.LoadFromDataset('', FDQuery1, False,  JSONValue.JsonMode, 'yyyy-mm-dd', '.');
   Result             := JSONValue.ToJson;
  Except
   On E : Exception Do
    Begin
     Result := Format('{"Error":"%s"}', [E.Message]);
    End;
  End;
 Finally
  JSONValue.Free;
 End;
end;

procedure TServerMethodDM.dwcrIndexItemscadModalBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := LoadHTMLFile('./www/templates/cademployee.html');
end;

procedure TServerMethodDM.dwcrIndexBeforeRenderer(aSelf: TComponent);
begin
 TDWContextRules(aSelf).MasterHtml.LoadFromFile('./www/templates/index.html');
end;

procedure TServerMethodDM.dwcrIndexItemsdatatableRequestExecute(
  const Params: TDWParams; Var ContentType, Result: String);
Var
 JSONValue :  TJSONValue;
begin
 JSONValue := TJSONValue.Create;
 Try
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from employee');
  Try
   FDQuery1.Open;
   JSONValue.JsonMode := jmPureJSON;
   JSONValue.Encoding := Encoding;
   JSONValue.LoadFromDataset('', FDQuery1, False,  JSONValue.JsonMode, 'dd/mm/yyyy', '.');
   Result := JSONValue.ToJson;
  Except
   On E : Exception Do
    Begin
     Result := Format('{"Error":"%s"}', [E.Message]);
    End;
  End;
 Finally
  JSONValue.Free;
 End;
end;

procedure TServerMethodDM.dwcrIndexItemsdeleteModalRequestExecute(
  const Params: TDWParams; var ContentType, Result: String);
begin
 result := 'true';
 FDQuery1.Close;
 FDQuery1.SQL.Clear;
 FDQuery1.SQL.Add('delete from employee where emp_no = ' + Params.ItemsString['id'].AsString);
 Try
  FDQuery1.ExecSQL;
  Server_FDConnection.Commit;
 Except
  Server_FDConnection.Rollback;
  result := 'false';
 End;
end;

procedure TServerMethodDM.dwcrIndexItemsdwcbCargosBeforeRendererContextItem(
  Var ContextItemTag: String);
begin
 FDQuery1.Close;
 FDQuery1.SQL.Clear;
 FDQuery1.SQL.Add('select JOB_CODE, JOB_GRADE, JOB_COUNTRY, JOB_TITLE from JOB');
 FDQuery1.Open;
 ContextItemTag := ContextItemTag + '<option value="" >Selecione Cargo</option>';
 While Not FDQuery1.EOF Do
  Begin
   ContextItemTag := ContextItemTag + Format('<option value="%s">%s</option>', [CP1252ToUTF8(FDQuery1.FindField('JOB_GRADE').AsString),
                                                                                CP1252ToUTF8(FDQuery1.FindField('JOB_COUNTRY').AsString) + ' - ' +
                                                                                CP1252ToUTF8(FDQuery1.FindField('JOB_TITLE').AsString)]);
   FDQuery1.Next;
  End;
 ContextItemTag := ContextItemTag + '</select>';
 FDQuery1.Close;
end;

procedure TServerMethodDM.dwcrIndexItemsdwcbCargosRequestExecute(
  const Params: TDWParams; var ContentType, Result: String);
Var
 JSONValue :  TJSONValue;
begin
 JSONValue            := TJSONValue.Create;
 Try
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select JOB_GRADE, (JOB_COUNTRY ||''/''|| JOB_TITLE)JOB_TITLE from JOB');
  Try
   FDQuery1.Open;
   JSONValue.JsonMode := jmPureJSON;
   JSONValue.Encoding := Encoding;
   JSONValue.LoadFromDataset('', FDQuery1, False,  JSONValue.JsonMode, 'dd/mm/yyyy', '.');
   Result             := JSONValue.ToJson;
  Except
   On E : Exception Do
    Begin
     Result := Format('{"Error":"%s"}', [E.Message]);
    End;
  End;
 Finally
  JSONValue.Free;
 End;
end;

procedure TServerMethodDM.dwcrIndexItemsdwcbPaisesBeforeRendererContextItem(
  Var ContextItemTag: String);
begin
 FDQuery1.Close;
 FDQuery1.SQL.Clear;
 FDQuery1.SQL.Add('select * from COUNTRY');
 FDQuery1.Open;
 ContextItemTag := ContextItemTag + '<option value="" >Selecione seu país</option>';
 While Not FDQuery1.EOF Do
  Begin
   ContextItemTag := ContextItemTag + Format('<option value="%s">%s</option>', [FDQuery1.FindField('UF').AsString,
                                                                                FDQuery1.FindField('COUNTRY').AsString]);
   FDQuery1.Next;
  End;
 ContextItemTag := ContextItemTag + '</select>';
 FDQuery1.Close;
end;

procedure TServerMethodDM.dwcrIndexItemsdwframeBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := LoadHTMLFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamSTR(0))) + 'www/templates/dataFrame.html');
end;

procedure TServerMethodDM.dwcrIndexItemsdwmyhtmlRequestExecute(
  const Params: TDWParams; var ContentType, Result: String);
begin
 ContentType := 'text/html';
 If Params.ItemsString['myhtml'] <> Nil Then
  Result := LoadHTMLFile('www/templates/' + Params.ItemsString['myhtml'].AsString + '.html');
end;

procedure TServerMethodDM.dwcrIndexItemsdwsidemenuBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := ContextItemTag +
                   '<li class="active"><a href="javascript:window.location.reload(true)"><i class="fa fa-home"></i> <span>Home</span></a></li>'+ bl +
                   '<li class="active"><a href=# onClick="loadEditCad()"><i class="fa fa-vcard"></i> <span>Novo Empregado</span></a></li>' + bl +
                   '<li class="active"><a href=# onClick="newClientes()"><i class="fa fa-users"></i> <span>Lista de Clientes</span></a></li>' + bl +
                   '<li class="active"><a href=# onClick="reloadDatatable(true)"><i class="fa fa-users"></i> <span>Lista de Empregado</span></a></li>' + bl +
                   '<li class="active"><a href="./login"><i class="fa fa-sign-out"></i> <span>Logout</span></a></li>';
end;

procedure TServerMethodDM.dwcrIndexItemseditModalRequestExecute(
  const Params: TDWParams; var ContentType, Result: String);
Var
 JSONValue :  TJSONValue;
begin
 JSONValue            := TJSONValue.Create;
 Try
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from employee where emp_no = '+params.ItemsString['id'].AsString);

  Try
   FDQuery1.Open;
   JSONValue.JsonMode := jmPureJSON;
   JSONValue.Encoding := Encoding;
   JSONValue.LoadFromDataset('', FDQuery1, False,  JSONValue.JsonMode, 'dd/mm/yyyy', '.');
   Result             := JSONValue.ToJson;
  Except
   On E : Exception Do
    Begin
     Result := Format('{"Error":"%s"}', [E.Message]);
    End;
  End;
 Finally
  JSONValue.Free;
 End;
end;

procedure TServerMethodDM.dwcrIndexItemsLabelMenuBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 If IDUser > 0 then
  ContextItemTag := MyMenu;
end;

procedure TServerMethodDM.dwcrIndexItemsmeuloginnameBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := Format('<p id="mynamepan" idd="%d">%s</p>', [IDUser, IDUserName]);
end;

procedure TServerMethodDM.dwcrIndexItemsoperationRequestExecute(
  const Params: TDWParams; Var ContentType, Result: String);
begin
 Result := 'true';
 FDQuery1.Close;
 FDQuery1.SQL.Clear;
 If Params.ItemsString['operation'].AsString = 'edit' Then
  FDQuery1.SQL.Add('update employee set FIRST_NAME = :FIRST_NAME, LAST_NAME = :LAST_NAME, ' +
                   'PHONE_EXT = :PHONE_EXT, HIRE_DATE = :HIRE_DATE, DEPT_NO = :DEPT_NO, ' +
                   'JOB_CODE  = :JOB_CODE, JOB_GRADE = :JOB_GRADE, JOB_COUNTRY = :JOB_COUNTRY, ' +
                   'SALARY = :SALARY ' +
                   'Where EMP_NO = ' + Params.ItemsString['id'].AsString)
 Else If Params.ItemsString['operation'].AsString = 'insert' Then
  FDQuery1.SQL.Add('insert into employee (EMP_NO, FIRST_NAME, LAST_NAME, ' +
                                          'PHONE_EXT, HIRE_DATE, DEPT_NO, ' +
                                          'JOB_CODE, JOB_GRADE, JOB_COUNTRY, SALARY) ' +
                   'VALUES (gen_id(emp_no_gen, 1), :FIRST_NAME, :LAST_NAME, :PHONE_EXT, :HIRE_DATE, :DEPT_NO, :JOB_CODE, ' +
                           ':JOB_GRADE, :JOB_COUNTRY, :SALARY)')
 Else If Params.ItemsString['operation'].AsString = 'delete' Then
  FDQuery1.SQL.Add('delete from employee Where EMP_NO = ' + Params.ItemsString['id'].AsString);
 Try
  If Params.ItemsString['operation'].AsString <> 'delete' Then
   Begin
    FDQuery1.ParamByName('FIRST_NAME').AsString  := Params.ItemsString['FIRST_NAME'].AsString;
    FDQuery1.ParamByName('LAST_NAME').AsString   := Params.ItemsString['LAST_NAME'].AsString;
    FDQuery1.ParamByName('PHONE_EXT').AsString   := StringReplace(StringReplace(Params.ItemsString['PHONE_EXT'].AsString, '(', '', [rfReplaceAll]), ')', '', [rfReplaceAll]);
    FDQuery1.ParamByName('DEPT_NO').AsString     := '600';
    FDQuery1.ParamByName('JOB_CODE').AsString    := 'Vp';
    FDQuery1.ParamByName('HIRE_DATE').AsDateTime := StrToDate(SwapHTMLDateToDelphiDate(Params.ItemsString['HIRE_DATE'].asstring));
    FDQuery1.ParamByName('JOB_GRADE').AsString   := Params.ItemsString['JOB_GRADE'].AsString;
    FDQuery1.ParamByName('JOB_COUNTRY').AsString := Params.ItemsString['JOB_COUNTRY'].AsString;
    FDQuery1.ParamByName('SALARY').AsFloat       := Params.ItemsString['SALARY'].AsFloat;
   End;
  FDQuery1.ExecSQL;
  Server_FDConnection.Commit;
 Except
  On E : Exception Do
    Begin
     Server_FDConnection.Rollback;
     Result := 'false';
    End;
 End;
end;

procedure TServerMethodDM.dwcrLoginBeforeRenderer(aSelf: TComponent);
begin
 TDWContextRules(aSelf).MasterHtml.LoadFromFile('./www/templates/login.html');
end;

procedure TServerMethodDM.dwcrLoginItemsmeuloginnameBeforeRendererContextItem(
  var ContextItemTag: String);
begin
 ContextItemTag := Format('<p id="mynamepan" idd="%d">%s</p>', [IDUser, IDUserName]);
end;

procedure TServerMethodDM.dwsCrudServerBeforeRenderer(aSelf: TComponent);
begin
 TDWServerContext(aSelf).BaseHeader.LoadFromFile('./www/templates/master.html');
 TDWServerContext(aSelf).BaseHeader.text := utf8decode(TDWServerContext(aSelf).BaseHeader.text);
end;

procedure TServerMethodDM.dwsCrudServerContextListindexAuthRequest(
  const Params: TDWParams; var Rejected: Boolean; var ResultError: String;
  var StatusCode: Integer; RequestHeader: TStringList);
Var
 vusername,
 vpassword  : String;
 Function RejectURL : String;
 Var
  v404Error  : TStringList;
 Begin
  v404Error  := TStringList.Create;
  Try
   {$IFDEF APPWIN}
   v404Error.LoadFromFile(RestDWForm.RESTServicePooler1.RootPath + Const404Page);
   {$ELSE}
   v404Error.LoadFromFile('.\www\' + Const404Page);
   {$ENDIF}
   Result := v404Error.Text;
  Finally
   v404Error.Free;
  End;
 End;
begin
 Rejected  := (Params.ItemsString['username'] = Nil) Or
              (Params.ItemsString['password'] = Nil);
 If Not Rejected Then
  Begin
   vusername := Uppercase(decodestrings(Params.ItemsString['username'].AsString{$IFDEF FPC}, csUndefined{$ENDIF}));
   vpassword := Uppercase(decodestrings(Params.ItemsString['password'].AsString{$IFDEF FPC}, csUndefined{$ENDIF}));
   FDQuery1.Close;
   FDQuery1.SQL.Clear;
   FDQuery1.SQL.Add('select * from TB_USUARIO where NM_LOGIN = :NM_LOGIN and DS_SENHA = :DS_SENHA');
   Try
    FDQuery1.ParamByName('NM_LOGIN').AsString := vusername;
    FDQuery1.ParamByName('DS_SENHA').AsString := vpassword;
    FDQuery1.Open;
    IDUser     := FDQuery1.FindField('ID_PESSOA').AsInteger;
    IDUserName := FDQuery1.FindField('NM_LOGIN').AsString;
   Finally
    Rejected  := FDQuery1.EOF;
    FDQuery1.Close;
    If Rejected Then
     Begin
      ResultError := RejectURL;
      StatusCode  := 404;
     End;
   End;
  End
 Else
  Begin
   ResultError := RejectURL;
   StatusCode  := 404;
  End;
end;


end.
