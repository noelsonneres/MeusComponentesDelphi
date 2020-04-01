{******************************************}
{                                          }
{             FastReport v5.0              }
{         Fib enduser components           }
{                                          }
{         Copyright (c) 2004               }
{         by Alexander Tzyganenko,         }
{******************************************}
{                                          }
{       Improved by Butov Konstantin       }
{  Improved by  Serge Buzadzhy             }
{             buzz@devrace.com             }
{                                          }
{******************************************}

unit frxFIBComponents;

interface

{$I frx.inc}

uses
  Graphics, Windows, Classes, SysUtils, frxClass, frxCustomDB, DB,
  FIBDatabase, pFIBDatabase, FIBDataSet, pFIBDataSet, FIBQuery, pFIBProps, Variants
{$IFDEF QBUILDER}
, fqbClass
{$ENDIF};

type
  TfrxFIBComponents = class(TfrxDBComponents)
  private
    FDefaultDatabase: TpFIBDatabase;
    FOldComponents: TfrxFIBComponents;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetDefaultDatabase(Value: TpFIBDatabase);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDescription: String; override;
  published
    property DefaultDatabase: TpFIBDatabase read FDefaultDatabase write SetDefaultDatabase;
  end;

  TfrxFIBDatabase = class(TfrxCustomDatabase)
  private
    FDatabase: TpFIBDatabase;
    FTransaction: TpFIBTransaction;
    function GetSQLDialect: Integer;
    procedure SetSQLDialect(const Value: Integer);
  protected
    procedure SetConnected(Value: Boolean); override;
    procedure SetDatabaseName(const Value: String); override;
    procedure SetLoginPrompt(Value: Boolean); override;
    procedure SetParams(Value: TStrings); override;
    function GetConnected: Boolean; override;
    function GetDatabaseName: String; override;
    function GetLoginPrompt: Boolean; override;
    function GetParams: TStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    function ToString: WideString; override;
    procedure FromString(const Connection: WideString); override;
    procedure SetLogin(const Login, Password: String); override;
    property Database: TpFIBDatabase read FDatabase;
  published
    property DatabaseName;
    property LoginPrompt;
    property Params;
    property SQLDialect: Integer read GetSQLDialect write SetSQLDialect;
    property Connected;
  end;

  TfrxFIBQuery = class(TfrxCustomQuery)
  private
    FDatabase: TfrxFIBDatabase;
    FQuery: TpFIBDataset;
    procedure SetDatabase(const Value: TfrxFIBDatabase);
    function GetFetchAll: Boolean;
    procedure SetFetchAll(const Value: Boolean);
    function GetUniDirectional: Boolean;
    procedure SetUniDirectional(const Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetMaster(const Value: TDataSource); override;
    procedure SetSQL(Value: TStrings); override;
    function  GetSQL: TStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure UpdateParams; override;
{$IFDEF QBUILDER}
    function QBEngine: TfqbEngine; override;
{$ENDIF}
    property Query: TpFIBDataset read FQuery;
    property FetchAll: Boolean Read GetFetchAll write SetFetchAll;
  published
    property Database: TfrxFIBDatabase read FDatabase write SetDatabase;
    property UniDirectional: Boolean read GetUniDirectional write SetUniDirectional default False;
  end;

{$IFDEF QBUILDER}
  TfrxEngineFIB = class(TfqbEngine)
  private
    FQuery: TpFIBDataset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadTableList(ATableList: TStrings); override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  end;
{$ENDIF}

var
  FIBComponents: TfrxFIBComponents;


implementation

uses
  frxFIBRTTI, frxUtils, frxRes,
{$IFNDEF NO_EDITORS}
  frxFIBEditor,
{$ENDIF}
  frxDsgnIntf;


procedure frxFIBParamsToTParams(Query: TfrxCustomQuery; aParams: TFIBXSQLDA);
var
  i: Integer;
  Item: TfrxParamItem;
begin
  with Query do
  for i := 0 to aParams.Count - 1 do
    if Params.IndexOf(aParams[i].Name) <> -1 then
    begin
      Item := Params.Find(aParams[i].Name);
      if Item <> nil  then
      begin
        if Trim(Item.Expression) <> '' then
          if not (IsLoading or IsDesigning) then
          begin
            Report.CurObject := Name;
            Item.Value := Report.Calc(Item.Expression);
          end;
        if not VarIsEmpty(Item.Value) then
        try
          if Item.DataType = ftDate then
            aParams[i].AsDate := VarToDateTime(Item.Value)
          else
{$IFDEF Delphi12}
            aParams[i].AsWideString := VarToStr(Item.Value);
{$ELSE}
            aParams[i].AsString := VarToStr(Item.Value);
{$ENDIF}
        except
{$IFDEF Delphi12}
          aParams[i].AsWideString := Item.Value;
{$ELSE}
          aParams[i].AsString := Item.Value;
{$ENDIF}
        end;
      end;
    end;
end;


{ TfrxDBComponents }

constructor TfrxFIBComponents.Create(AOwner: TComponent);
begin
  inherited;
  FOldComponents := FIBComponents;
  FIBComponents := Self;
end;

destructor TfrxFIBComponents.Destroy;
begin
  if FIBComponents = Self then
    FIBComponents := FOldComponents;
  inherited;
end;

function TfrxFIBComponents.GetDescription: String;
begin
  Result := 'FIB';
end;

procedure TfrxFIBComponents.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FDefaultDatabase) and (Operation = opRemove) then
    FDefaultDatabase := nil;
end;

procedure TfrxFIBComponents.SetDefaultDatabase(Value: TpFIBDatabase);
begin
  if (Value <> nil) then
    Value.FreeNotification(Self);

  if FDefaultDatabase <> nil then
      FDefaultDatabase.RemoveFreeNotification(Self);

  FDefaultDatabase := Value;
end;


{ TfrxFIBDatabase }

constructor TfrxFIBDatabase.Create(AOwner: TComponent);
begin
  inherited;
  FDatabase := TpFIBDatabase.Create(nil);
  FTransaction := TpFIBTransaction.Create(nil);
  FDatabase.DefaultTransaction := FTransaction;
  Component := FDatabase;
end;

destructor TfrxFIBDatabase.Destroy;
begin
  FTransaction.Free;
  inherited;
end;

class function TfrxFIBDatabase.GetDescription: String;
begin
  Result := frxResources.Get('obFIBDB');
end;

function TfrxFIBDatabase.GetConnected: Boolean;
begin
  Result := FDatabase.Connected;
end;

function TfrxFIBDatabase.GetDatabaseName: String;
begin
  Result := FDatabase.DatabaseName;
end;

function TfrxFIBDatabase.GetLoginPrompt: Boolean;
begin
  Result := FDatabase.UseLoginPrompt;
end;

function TfrxFIBDatabase.GetParams: TStrings;
begin
  Result := FDatabase.DBParams;
end;

function TfrxFIBDatabase.GetSQLDialect: Integer;
begin
  Result := FDatabase.SQLDialect;
end;

procedure TfrxFIBDatabase.SetConnected(Value: Boolean);
begin
  BeforeConnect(Value);
  FDatabase.Connected := Value;
  FTransaction.Active := Value;
end;

procedure TfrxFIBDatabase.SetDatabaseName(const Value: String);
begin
  FDatabase.DatabaseName := Value;
end;

procedure TfrxFIBDatabase.SetLoginPrompt(Value: Boolean);
begin
  FDatabase.UseLoginPrompt := Value;
end;

procedure TfrxFIBDatabase.SetParams(Value: TStrings);
begin
  FDatabase.DBParams.AddStrings(Value);
end;

procedure TfrxFIBDatabase.SetSQLDialect(const Value: Integer);
begin
  FDatabase.SQLDialect := Value;
end;

procedure TfrxFIBDatabase.SetLogin(const Login, Password: String);
begin
  Params.Text := 'user_name=' + Login + #13#10 + 'password=' + Password;
end;


procedure TfrxFIBDatabase.FromString(const Connection: WideString);
var
  i: Integer;
  s, v: String;
  mode: Integer;

  procedure SetParam(const ParamName: String; const ParamValue: String);
  var
    List: TStringList;
{$IFNDEF Delphi6}
    i, j: Integer;
    s: String;
{$ENDIF}
  begin
    if ParamName = 'DBName' then
      FDatabase.DBName := ParamValue
    else if ParamName = 'DBParams' then
    begin
      List := TStringList.Create;
      try
{$IFDEF Delphi6}
        List.Delimiter := ';';
        List.DelimitedText := ParamValue;
{$ELSE}
        i := 1;
        j := 1;
        while i <= Length(ParamValue) do
        begin
          if ParamValue[i] = ';' then
          begin
            s := Copy(ParamValue, j, i - j);
            List.Add(s);
            j := i + 1;
          end;
          Inc(i);
        end;
        s := Copy(ParamValue, j, i - j);
        List.Add(s);
{$ENDIF}
        FDatabase.DBParams.Text := List.Text;
      finally
        List.Free;
      end;
    end
    else if ParamName = 'SQLDialect' then
      FDatabase.SQLDialect := StrToInt(ParamValue)
    else if ParamName = 'AliasName' then
      FDatabase.AliasName := AnsiString(ParamValue)
    else if ParamName = 'LibraryName' then
      FDatabase.LibraryName := ParamValue
  end;

begin
  s := '';
  v := '';
  mode := 0;
  for i := 1 to Length(Connection) do
    if (Connection[i] = '=') and (mode = 0) then
      Inc(mode)
    else if (Connection[i] = '"') and (mode = 1) then
      Inc(mode)
    else if (Connection[i] = '"') and (mode = 2) then
      Dec(mode)
    else if (Connection[i] = ';') and (mode = 1) then
    begin
      Dec(mode);
      SetParam(s, v);
      s := '';
      v := '';
    end
    else if mode = 2 then
      v := v + Connection[i]
    else if mode = 0 then
      s := s + Connection[i];
end;

function TfrxFIBDatabase.ToString: WideString;
var
  List: TStringList;
{$IFNDEF Delphi6}
  i, nCount: Integer;
{$ENDIF}
begin
  if FDatabase.DBName <> '' then
    Result := 'DBName="' + FDatabase.DBName + '";';
  if FDatabase.DBParams.Count <> 0 then
  begin
    List := TStringList.Create;
    try
      List.Assign(FDatabase.DBParams);
{$IFDEF Delphi6}
      List.Delimiter := ';';
      Result := Result + 'DBParams="' + List.DelimitedText + '";';
{$ELSE}
      Result := Result + 'DBParams="';
      nCount := List.Count - 1;
      for i := 0 to nCount  do
      begin
        Result := Result + List[i];
        if nCount > i then
          Result := Result + ';';
      end;
      Result := Result + '";';
{$ENDIF}
    finally
      List.Free;
    end;
  end;
  Result := Result + 'SQLDialect="' + IntToStr(FDatabase.SQLDialect) + '";';
  if FDatabase.AliasName <> '' then
    Result := Result + 'AliasName="' + String(FDatabase.AliasName) + '";';
  if FDatabase.LibraryName <> '' then
    Result := Result + 'LibraryName="' + FDatabase.LibraryName + '";';
end;

{ TfrxFIBQuery }

constructor TfrxFIBQuery.Create(AOwner: TComponent);
begin
  FQuery := TpFIBDataset.Create(nil);
  Dataset := FQuery;
  SetDatabase(nil);
  inherited;
end;

constructor TfrxFIBQuery.DesignCreate(AOwner: TComponent; Flags: Word);
var
  i: Integer;
  l: TList;
begin
  inherited;
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
    if TObject(l[i]) is TfrxFIBDatabase then
    begin
      SetDatabase(TfrxFIBDatabase(l[i]));
      break;
    end;
end;

class function TfrxFIBQuery.GetDescription: String;
begin
  Result := frxResources.Get('obFIBQ');
end;

procedure TfrxFIBQuery.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDatabase) then
    SetDatabase(nil);
end;

procedure TfrxFIBQuery.SetDatabase(const Value: TfrxFIBDatabase);
begin
  FDatabase := Value;
  if Value <> nil then
  begin
    FQuery.Database := Value.Database;
	FQuery.Transaction := Value.FTransaction;
  end
  else if FIBComponents <> nil then
    FQuery.Database := FIBComponents.DefaultDatabase
  else
    FQuery.Database := nil;
  DBConnected := FQuery.Database <> nil;
end;

procedure TfrxFIBQuery.SetMaster(const Value: TDataSource);
begin
  FQuery.DataSource := Value;
end;

procedure TfrxFIBQuery.SetSQL(Value: TStrings);
begin
  FQuery.SelectSQL := Value;
end;

procedure TfrxFIBQuery.SetUniDirectional(const Value: boolean);
begin
  FQuery.UniDirectional := Value;
end;

function TfrxFIBQuery.GetSQL: TStrings;
begin
  Result := FQuery.SelectSQL;
end;

function TfrxFIBQuery.GetUniDirectional: boolean;
begin
  Result := FQuery.UniDirectional;
end;

function TfrxFIBQuery.GetFetchAll: boolean;
begin
  Result:=poFetchAll in FQuery.Options;
end;

procedure TfrxFIBQuery.SetFetchAll(const Value: boolean);
begin
  if Value then 
    FQuery.Options:=FQuery.Options+[poFetchAll] 
  else
    FQuery.Options:=FQuery.Options-[poFetchAll];
end;

procedure TfrxFIBQuery.UpdateParams;
begin
  frxFIBParamsToTParams(Self, FQuery.Params);
end;

procedure TfrxFIBQuery.BeforeStartReport;
begin
  SetDatabase(FDatabase);
end;

{$IFDEF QBUILDER}
function TfrxFIBQuery.QBEngine: TfqbEngine;
begin
  Result := TfrxEngineFIB.Create(nil);
  TfrxEngineFIB(Result).FQuery.Database := FQuery.Database;
  if (FQuery.Database <> nil) and not FQuery.Database.Connected then
    FQuery.Database.Connected := True;
end;
{$ENDIF}


{$IFDEF QBUILDER}
constructor TfrxEngineFIB.Create(AOwner: TComponent);
begin
  inherited;
  FQuery := TpFIBDataset.Create(Self);
end;

destructor TfrxEngineFIB.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TfrxEngineFIB.ReadFieldList(const ATableName: string;
  var AFieldList: TfqbFieldList);
var
  tmpTransaction: TpFIBTransaction;
  tbl: TFIBDataSet;
  tmpField: TfqbField;
  i: Integer;
begin
  tbl := TpFIBDataSet.Create(Self);
  tmpTransaction := TpFIBTransaction.Create(Self);
  tmpTransaction.DefaultDatabase := FQuery.Database;
  try
    tbl.Database := FQuery.Database;
    tbl.Transaction := tmpTransaction;
    tbl.SelectSQL.Add('SELECT *');
    tbl.SelectSQL.Add('FROM ' + UpperCase(ATableName));
    tmpTransaction.StartTransaction;
    tbl.Prepare;
    tbl.Open;
    tmpField:= TfqbField(AFieldList.Add);
    tmpField.FieldName := '*';
    for i := 0 to tbl.FieldCount - 1 do
    begin
      tmpField:= TfqbField(AFieldList.Add);
      tmpField.FieldName := tbl.Fields[i].DisplayName;
      tmpField.FieldType := Ord(tbl.Fields[i].DataType);
    end
  finally
    if tmpTransaction.Active then
      tmpTransaction.Commit;
    tbl.Close;
    tbl.Free;
    tmpTransaction.Free;
  end;
end;

procedure TfrxEngineFIB.ReadTableList(ATableList: TStrings);
begin
  ATableList.Clear;
  TpFIBDatabase(FQuery.Database).GetTableNames(ATableList, ShowSystemTables);
end;

function TfrxEngineFIB.ResultDataSet: TDataSet;
begin
  Result := FQuery;
end;

procedure TfrxEngineFIB.SetSQL(const Value: string);
begin
  FQuery.SelectSQL.Text := Value;
end;
{$ENDIF}


initialization
  frxObjects.RegisterObject1(TfrxFIBDataBase, nil, '', {$IFDEF DB_CAT}'DATABASES'{$ELSE}''{$ENDIF}, 0, 37);
  frxObjects.RegisterObject1(TfrxFIBQuery, nil, '', {$IFDEF DB_CAT}'QUERIES'{$ELSE}''{$ENDIF}, 0, 39);

finalization
  frxObjects.UnRegister(TfrxFIBDataBase);
  frxObjects.UnRegister(TfrxFIBQuery);


end.