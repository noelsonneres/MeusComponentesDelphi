unit frxlazdbfcomp;

{$I frx.inc}

interface

uses
  Classes, SysUtils,
  frxClass, frxCustomDB, DB, dbf,
  LResources;

type

  { TfrxLazDBFComponents }

  TfrxLazDBFComponents = class(TfrxDBComponents)
  private
    FOldComponents: TfrxLazDBFComponents;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDescription: string; override;
  end;

  { TfrxDBFTable }

  TfrxDBFTable = class(TfrxCustomTable)
  private
    FDBF: TDbf;
    FDBFCharset: string;
    FTranslate: Boolean;
    function GetFilePath: string;
    procedure SetFilePath(AValue: string);
    procedure SetTranslate(AValue: Boolean);
  protected
    procedure SetMaster(const Value: TDataSource); override;
    procedure SetMasterFields(const Value: String); override;
    function GetIndexFieldNames: String; override;
    function GetIndexName: String; override;
    procedure SetIndexFieldNames(const Value: String);override;
    procedure SetIndexName(const Value: String); override;

    function GetTableName: String; override;
    procedure SetTableName(const Value: String); override;
    function DbfTranslate(Dbf: TDbf; Src, Dest: PChar; ToOem: Boolean): Integer;
    procedure DbfAfterOpen(DataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddIndex(AIndexName, AFields: string);
    procedure AddIndexDescending(AIndexName, AFields: string);
    property DBF: TDBF read FDBF;
  published
    property DBFCharset: string read FDBFCharset write FDBFCharset;
    property Active;
    property FilePath: string read GetFilePath write SetFilePath;
    property Translate: Boolean read FTransLate write SetTranslate;
  end;




var
  LazDBFComponents: TfrxLazDBFComponents;

procedure Register;

implementation

uses
  LConvEncoding,
  frxlazdbfrtti,
  frxlazdbfeditor,
  frxDsgnIntf,frxRes;

procedure Register;
begin
  RegisterComponents('FastReport 6.0',[TfrxLazDBFComponents]);
end;

{ TfrxDBFTable }

function TfrxDBFTable.GetFilePath: string;
begin
  Result := FDBF.FilePath;
end;

procedure TfrxDBFTable.SetFilePath(AValue: string);
begin
  FDBF.FilePath := AValue;
end;

procedure TfrxDBFTable.SetTranslate(AValue: Boolean);
begin
  FTransLate := AValue;
  if AValue then
  begin
    FDBF.OnTranslate := DbfTranslate;
    FDBF.AfterOpen := DbfAfterOpen;
  end
  else
  begin
    FDBF.OnTranslate := nil;
    FDBF.AfterOpen := nil;
  end;
end;

procedure TfrxDBFTable.SetMaster(const Value: TDataSource);
begin
  FDBF.MasterSource := Value;
end;

procedure TfrxDBFTable.SetMasterFields(const Value: String);
begin
  FDBF.MasterFields := Value;
end;

function TfrxDBFTable.GetIndexFieldNames: String;
begin
  Result:= FDBF.IndexFieldNames;
end;

function TfrxDBFTable.GetIndexName: String;
begin
  Result := FDBF.IndexName;
end;

procedure TfrxDBFTable.SetIndexFieldNames(const Value: String);
begin
  FDBF.IndexFieldNames := Value;
end;

procedure TfrxDBFTable.SetIndexName(const Value: String);
begin
  FDBF.IndexName := Value;
end;

function TfrxDBFTable.GetTableName: String;
begin
  Result:= FDBF.TableName;
end;

procedure TfrxDBFTable.SetTableName(const Value: String);
begin
  FDBF.TableName := Value;
end;

function TfrxDBFTable.DbfTranslate(Dbf: TDbf; Src, Dest: PChar; ToOem: Boolean
  ): Integer;
var
  S: String;
begin
  if FDBFCharset <> '' then
    S := ConvertEncoding(Src, FDBFCharset, 'utf8');
  StrCopy(Dest, PChar(S));
  Result := StrLen(Dest);
end;

procedure TfrxDBFTable.DbfAfterOpen(DataSet: TDataSet);
var
  I: Integer;
begin
  for I := 0 to FDBF.FieldCount - 1 do
  if FDBF.Fields[I].DataType = ftString then
    TStringField(FDBF.Fields[I]).Transliterate := True;
end;

constructor TfrxDBFTable.Create(AOwner: TComponent);
begin
  FDBF := TDbf.Create(nil);
  DataSet := FDBF;
  inherited Create(AOwner);
end;

procedure TfrxDBFTable.AddIndex(AIndexName, AFields: string);
begin
  try
  FDBF.AddIndex(AIndexName, AFields, []);
  except
  end;
end;

procedure TfrxDBFTable.AddIndexDescending(AIndexName, AFields: string);
begin
  try
  FDBF.AddIndex(AIndexName, AFields, [ixDescending]);
  except
  end;
end;

{ TfrxLazDBFComponents }

constructor TfrxLazDBFComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOldComponents := LazDBFComponents;
  LazDBFComponents := Self;
end;

destructor TfrxLazDBFComponents.Destroy;
begin
  if LazDBFComponents = Self then
    LazDBFComponents := FOldComponents;
  inherited Destroy;
end;

function TfrxLazDBFComponents.GetDescription: string;
begin
  Result:= 'LazDBF';
end;

initialization
  {$INCLUDE frxlazdbfcomp.lrs}

  frxObjects.RegisterObject1(TfrxDBFTable, nil, '', {$IFDEF DB_CAT}'TABLES'{$ELSE}''{$ENDIF}, 0, 81);
finalization
  frxObjects.UnRegister(TfrxDBFTable);

end.

