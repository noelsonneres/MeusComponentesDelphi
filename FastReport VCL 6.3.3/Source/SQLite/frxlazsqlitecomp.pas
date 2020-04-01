unit frxlazsqlitecomp;

{$I frx.inc}


interface

uses
  Classes, SysUtils, frxClass, frxCustomDB, DB, sqldb, sqlite3conn,
  Variants, LResources;

type

  { TfrxLazSqLiteComponents }

  TfrxLazSqLiteComponents = class(TfrxDBComponents)
  private
    FDefaultDatabase: TSQLite3Connection;
    FOldComponents: TfrxLazSqLiteComponents;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetDefaultDatabase(Value: TSQLite3Connection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDescription: String; override;
  published
    property DefaultDatabase: TSQLite3Connection read FDefaultDatabase write SetDefaultDatabase;
  end;

  { TfrxLazSqliteDatabase }

  TfrxLazSqliteDatabase = class(TfrxCustomDatabase)
  private
    FDatabase: TSQLite3Connection;
    FTransaction: TSqlTransaction;
    function GetCharSet: string;
    function GetOptions: TSQLConnectionOptions;
    function GetPassword: string;
    function GetUserName: string;
    procedure SetCharSet(AValue: string);
    procedure SetOptions(AValue: TSQLConnectionOptions);
    procedure SetPassword(AValue: string);
    procedure SetUserName(AValue: string);
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
    //procedure SetLogin(const Login, Password: String); override;
    property Database: TSQLite3Connection read FDatabase;
  published
    property CharSet: string read GetCharSet write SetCharSet;
    property DatabaseName;
    property LoginPrompt;
    property Params;
    property UserName:string read GetUserName  write SetUserName;
    property Password:string read GetPassword write SetPassword;
    property Options: TSQLConnectionOptions read GetOptions write SetOptions;
    property Connected;
  end;

  { TfrxLazSqliteQuery }

  TfrxLazSqliteQuery = class(TfrxCustomQuery)
  private
    FDatabase: TfrxLazSqliteDatabase;
    FQuery: TSqlQuery;
    procedure SetDatabase(const Value: TfrxLazSqliteDatabase);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetMaster(const Value: TDataSource); override;
    procedure SetSQL(Value: TStrings); override;
    function GetSQL: TStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure UpdateParams; override;
    property Query: TSqlQuery read FQuery;
  published
    property Database: TfrxLazSqliteDatabase read FDatabase write SetDatabase;
  end;



var
  LazSqliteComponents: TfrxLazSqliteComponents;

procedure Register;


implementation

uses
  frxLazSqliteEditor,frxDsgnIntf, frxRes,
  frxlazsqlitertti;



procedure Register;
begin
  RegisterComponents('FastReport 6.0',[TfrxLazSqliteComponents]);
end;

{ TfrxLazSqliteQuery }

procedure TfrxLazSqliteQuery.SetDatabase(const Value: TfrxLazSqliteDatabase);
begin
  FDatabase := Value;

  if Value <> nil then
  begin
    FQuery.Database := Value.Database;
    FQuery.Transaction := Value.FTransaction;
  end
  else if LazSqliteComponents <> nil then
  begin
    FQuery.Database := LazSqliteComponents.DefaultDatabase;
    if Assigned(FQuery.Database) then
      FQuery.Transaction := LazSqliteComponents.DefaultDatabase.Transaction;
  end
  else
    FQuery.Database := nil;
  DBConnected := FQuery.Database <> nil;
end;

procedure TfrxLazSqliteQuery.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDatabase) then
    SetDatabase(nil);
end;

procedure TfrxLazSqliteQuery.SetMaster(const Value: TDataSource);
begin
   FQuery.DataSource := Value;
end;

procedure TfrxLazSqliteQuery.SetSQL(Value: TStrings);
begin
  FQuery.SQL := TStringList(Value);
end;

function TfrxLazSqliteQuery.GetSQL: TStrings;
begin
  Result := FQuery.SQL;
end;

constructor TfrxLazSqliteQuery.Create(AOwner: TComponent);
begin
  FQuery := TSqlQuery.Create(nil);
  Dataset := FQuery;
  SetDatabase(nil);
  inherited Create(AOwner);
end;

constructor TfrxLazSqliteQuery.DesignCreate(AOwner: TComponent; Flags: Word);
var
  i: Integer;
  l: TList;
begin
  inherited;
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
    if TObject(l[i]) is TfrxLazSqliteDatabase then
    begin
      SetDatabase(TfrxLazSqliteDatabase(l[i]));
      break;
    end;
end;


class function TfrxLazSqliteQuery.GetDescription: String;
begin
  Result:= 'Sqlite Query';
end;

procedure TfrxLazSqliteQuery.BeforeStartReport;
begin
  SetDatabase(FDatabase);
end;

procedure TfrxLazSqliteQuery.UpdateParams;
begin
  if Assigned(FQuery.Database) then
    frxParamsToTParams(Self, FQuery.Params);
end;

{ TfrxLazSqliteDatabase }

function TfrxLazSqliteDatabase.GetOptions: TSQLConnectionOptions;
begin
  Result := FDataBase.Options;
end;

function TfrxLazSqliteDatabase.GetCharSet: string;
begin
  Result := FDataBase.CharSet;
end;

function TfrxLazSqliteDatabase.GetPassword: string;
begin
  Result := FDatabase.Password;
end;

function TfrxLazSqliteDatabase.GetUserName: string;
begin
  Result := FDatabase.UserName;
end;

procedure TfrxLazSqliteDatabase.SetCharSet(AValue: string);
begin
  FDataBase.CharSet := AValue;
end;

procedure TfrxLazSqliteDatabase.SetOptions(AValue: TSQLConnectionOptions);
begin
  FDataBase.Options := AValue;
end;

procedure TfrxLazSqliteDatabase.SetPassword(AValue: string);
begin
   FDatabase.Password := AValue;
end;

procedure TfrxLazSqliteDatabase.SetUserName(AValue: string);
begin
  FDatabase.UserName := AValue;
end;

procedure TfrxLazSqliteDatabase.SetConnected(Value: Boolean);
begin
  BeforeConnect(Value);
  FDatabase.Connected := Value;
  FTransaction.Active := Value;
end;

procedure TfrxLazSqliteDatabase.SetDatabaseName(const Value: String);
begin
  FDatabase.DatabaseName := Value;
end;

procedure TfrxLazSqliteDatabase.SetLoginPrompt(Value: Boolean);
begin
  FDatabase.LoginPrompt := Value;
end;

procedure TfrxLazSqliteDatabase.SetParams(Value: TStrings);
begin
  FDatabase.Params := Value;
end;

function TfrxLazSqliteDatabase.GetConnected: Boolean;
begin
  Result := FDatabase.Connected;
end;

function TfrxLazSqliteDatabase.GetDatabaseName: String;
begin
  Result := FDatabase.DatabaseName;
end;

function TfrxLazSqliteDatabase.GetLoginPrompt: Boolean;
begin
  Result := FDatabase.LoginPrompt;
end;

function TfrxLazSqliteDatabase.GetParams: TStrings;
begin
  Result := FDatabase.Params;
end;

constructor TfrxLazSqliteDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDatabase := TSQLite3Connection.Create(nil);
  FTransaction := TSqlTransaction.Create(nil);
  FDatabase.Transaction := FTransaction;
  Component := FDatabase;
end;

destructor TfrxLazSqliteDatabase.Destroy;
begin
  FTransaction.Free;
  inherited Destroy;
end;

class function TfrxLazSqliteDatabase.GetDescription: String;
begin
  Result:= 'SqLite3 Database';

end;

{procedure TfrxLazSqliteDatabase.SetLogin(const Login, Password: String);
begin
  inherited SetLogin(Login, Password);
end;}

{ TfrxLazSqLiteComponents }

procedure TfrxLazSqLiteComponents.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

procedure TfrxLazSqLiteComponents.SetDefaultDatabase(Value: TSQLite3Connection);
begin
  FDefaultDatabase := Value;
end;

constructor TfrxLazSqLiteComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOldComponents := LazSqliteComponents;
  LazSqliteComponents := Self;
end;

destructor TfrxLazSqLiteComponents.Destroy;
begin
  if LazSqliteComponents = Self then
    LazSqliteComponents := FOldComponents;
  inherited Destroy;
end;

function TfrxLazSqLiteComponents.GetDescription: String;
begin
  Result :='LazSqlite3';
end;

initialization

{$INCLUDE frxlazsqlitecomp.lrs}

  frxObjects.RegisterObject1(TfrxLazSqliteDataBase, nil, '', '', 0, 37);
  frxObjects.RegisterObject1(TfrxLazSqliteQuery, nil, '', '', 0, 39);

finalization
  frxObjects.UnRegister(TfrxLazSqliteDataBase);
  frxObjects.UnRegister(TfrxLazSqliteQuery);
end.

