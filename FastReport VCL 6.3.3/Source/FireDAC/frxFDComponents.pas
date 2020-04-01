{ --------------------------------------------------------------------------- }
{ AnyDAC FastReport v 4.0 enduser components                                  }
{                                                                             }
{ (c)opyright DA-SOFT Technologies 2004-2013.                                 }
{ All rights reserved.                                                        }
{                                                                             }
{ Initially created by: Serega Glazyrin <glserega@mezonplus.ru>               }
{ Extended by: Francisco Armando Duenas Rodriguez <fduenas@gmxsoftware.com>   }
{                                                                             }
{ Extended by: Copyright (c) 2018 by Stalker SoftWare <stalker4zx@gmail.com>  }
{ --------------------------------------------------------------------------- }
{$I frx.inc}

unit frxFDComponents;

interface

uses
  Windows, Classes, SysUtils, frxClass, frxCustomDB, DB, frxXML, FireDAC.DatS,
  FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Comp.DataSet,
  FireDAC.Stan.Param, FireDAC.Stan.Intf, Variants
{$IFDEF QBUILDER}
, fqbClass
{$ENDIF};

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxFDComponents = class(TfrxDBComponents)
  private
    FDefaultDatabase: TFDConnection;
    FOldComponents: TfrxFDComponents;
    FDesignTimeExpr: Boolean;
    procedure SetDefaultDatabase(const AValue: TFDConnection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDescription: String; override;
  published
    property DefaultDatabase: TFDConnection read FDefaultDatabase write SetDefaultDatabase;
    // whether or not to calc expressions at design-time
    property DesignTimeExpr: Boolean read FDesignTimeExpr write FDesignTimeExpr
      stored False default False;
  end;

  TfrxFDDatabase = class(TfrxCustomDatabase)
  private
    FDatabase: TFDConnection;
    function GetDriverName: string;
    procedure SetDriverName(const AValue: string);
    function GetConnectionDefName: string;
    procedure SetConnectionDefName(const AValue: string);
  protected
    procedure SetConnected(AValue: Boolean); override;
    procedure SetDatabaseName(const AValue: String); override;
    procedure SetLoginPrompt(AValue: Boolean); override;
    procedure SetParams(AValue: TStrings); override;
    function GetConnected: Boolean; override;
    function GetDatabaseName: String; override;
    function GetLoginPrompt: Boolean; override;
    function GetParams: TStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    procedure SetLogin(const ALogin, APassword: String); override;
    function ToString: WideString; override;
    procedure FromString(const AConnection: WideString); override;
    property Database: TFDConnection read FDatabase;
  published
    property ConnectionDefName: string read GetConnectionDefName write SetConnectionDefName;
    property DriverName: string read GetDriverName write SetDriverName;
    property DatabaseName;
    property Params;
    property LoginPrompt;
    property Connected;
  end;

  TfrxDataSetNotifyEvent = type String;
  TfrxFilterRecordEvent  = type String;

  TfrxFDQuery = class(TfrxCustomQuery)
  private
    FDatabase    :TfrxFDDatabase;
    FQuery       :TFDQuery;
    FMacroParams :TfrxParams;

    FAfterOpen      :TfrxDataSetNotifyEvent;
    FBeforeOpen     :TfrxDataSetNotifyEvent;
    FAfterScroll    :TfrxDataSetNotifyEvent;
    FBeforeScroll   :TfrxDataSetNotifyEvent;
    FOnFilterRecord :TfrxFilterRecordEvent;

    FChangeFieldEventList  :TStrings;
    FGetTextFieldEventList :TStrings;

    procedure SetDatabase(const AValue: TfrxFDDatabase);
    function GetUniDirectional() :Boolean;
    procedure SetUniDirectional(const AValue :Boolean);
    procedure DoMasterSetValues(ASender :TFDDataSet);
    procedure SetMacroParams(const Value :TfrxParams);
    procedure ReadData(Reader :TReader);
    procedure WriteData(Writer :TWriter);
    procedure FDMacrosToMacroParams();
    procedure MacroParamsToFDParams();
    function GetCachedUpdates() :Boolean;
    procedure SetCachedUpdates(const Value: Boolean);
    function GetMacroCreate() :Boolean;
    procedure SetMacroCreate(const Value :Boolean);
    function GetMacroExpand() :Boolean;
    procedure SetMacroExpand(const Value :Boolean);
    function GetFDRecNo() :LongInt;
    procedure SetFDRecNo(const Value :LongInt);
    function GetReadOnly() :Boolean;
    procedure SetReadOnly(const Value :Boolean);

    procedure DoAfterOpen(DataSet: TDataSet);
    procedure DoBeforeOpen(DataSet: TDataSet);
    procedure DoAfterScroll(DataSet: TDataSet);
    procedure DoBeforeScroll(DataSet: TDataSet);
    procedure DoFilterRecord(DataSet: TDataSet; var Accept: Boolean);

    procedure DoChangeField(Field: TField);
    procedure DoGetTextField(Field: TField; var Text: String; DisplayText: Boolean);

  protected
    FLocked  :Boolean;
    FStrings :TStrings;

    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure OnChangeSQL(Sender: TObject); override;
    procedure SetMaster(const AValue: TDataSource); override;
    procedure SetMasterFields(const AValue: String); override;
    procedure SetSQL(AValue: TStrings); override;
    function GetSQL(): TStrings; override;
    procedure SetName(const AName: TComponentName); override;
    procedure DefineProperties(Filer: TFiler); override;

  public
    constructor Create(AOwner :TComponent); override;
    constructor DesignCreate(AOwner :TComponent; AFlags :Word); override;
    destructor Destroy(); override;

    class function GetDescription() :String; override;

    procedure WriteNestedProperties(Item: TfrxXmlItem; aAcenstor: TPersistent = nil); override;
    function ReadNestedProperty(Item: TfrxXmlItem): Boolean; override;

    procedure BeforeStartReport(); override;
    procedure FetchParams(); virtual;
    procedure UpdateParams(); override;

    procedure SetChangeFieldEvent(cFieldName, cEventName :String);
    procedure SetGetTextFieldEvent(cFieldName, cEventName :String);

    function MacroByName(const MacroName :String) :TfrxParamItem;
    procedure ExecSQL();
    procedure FetchAll();
    procedure EnableControls();
    procedure DisableControls();
    function CreateBlobStream(Field :TField; Mode: TBlobStreamMode) :TStream;
    function FindField(const FieldName :String) :TField;
    function LocateEx(const AKeyFields :String; const AKeyValues :Variant; AOptions: TFDDataSetLocateOptions = []) :Boolean; overload;
    function LocateEx(const AExpression :String; AOptions :TFDDataSetLocateOptions = []) :Boolean; overload;

{$IFDEF QBUILDER}
    function QBEngine :TfqbEngine; override;
{$ENDIF}

    property Query   :TFDQuery read FQuery;
    property FDRecNo :LongInt  read GetFDRecNo write SetFDRecNo;

  published
    property MacroCreate    :Boolean        read GetMacroCreate    write SetMacroCreate;
    property MacroExpand    :Boolean        read GetMacroExpand    write SetMacroExpand;
    property ReadOnly       :Boolean        read GetReadOnly       write SetReadOnly;
    property SQL;
    property Database       :TfrxFDDatabase read FDatabase         write SetDatabase;
    property UniDirectional :Boolean        read GetUniDirectional write SetUniDirectional default False;
    property MasterFields;
    property Macros         :TfrxParams     read FMacroParams      write SetMacroParams;
    property CachedUpdates  :Boolean        read GetCachedUpdates  write SetCachedUpdates default False;
    property Active default False;

    property AfterOpen      :TfrxDataSetNotifyEvent read FAfterOpen      write FAfterOpen;
    property BeforeOpen     :TfrxDataSetNotifyEvent read FBeforeOpen     write FBeforeOpen;
    property AfterScroll    :TfrxDataSetNotifyEvent read FAfterScroll    write FAfterScroll;
    property BeforeScroll   :TfrxDataSetNotifyEvent read FBeforeScroll   write FBeforeScroll;
    property OnFilterRecord :TfrxFilterRecordEvent  read FOnFilterRecord write FOnFilterRecord;

  end;

  TfrxFDMemTable = class(TfrxCustomDataset)
  private
    FFDMemTable     :TFDMemTable;
    FAfterOpen      :TfrxDataSetNotifyEvent;
    FBeforeOpen     :TfrxDataSetNotifyEvent;
    FAfterScroll    :TfrxDataSetNotifyEvent;
    FBeforeScroll   :TfrxDataSetNotifyEvent;
    FOnFilterRecord :TfrxFilterRecordEvent;

    FChangeFieldEventList  :TStrings;
    FGetTextFieldEventList :TStrings;

    function GetReadOnly() :Boolean;
    procedure SetReadOnly(const Value :Boolean);
    function GetAutoCalcFields() :Boolean;
    procedure SetAutoCalcFields(const Value :Boolean);
    function GetFieldDefs() :TFieldDefs;
    procedure SetFieldDefs(const Value :TFieldDefs);
    function GetIndexFieldNames() :String;
    procedure SetIndexFieldNames(const Value :String);
    function GetFDRecNo() :LongInt;
    procedure SetFDRecNo(const Value :LongInt);

    procedure DoAfterOpen(DataSet: TDataSet);
    procedure DoBeforeOpen(DataSet: TDataSet);
    procedure DoAfterScroll(DataSet: TDataSet);
    procedure DoBeforeScroll(DataSet: TDataSet);
    procedure DoFilterRecord(DataSet: TDataSet; var Accept: Boolean);

    procedure DoChangeField(Field: TField);
    procedure DoGetTextField(Field: TField; var Text: String; DisplayText: Boolean);

  protected
    procedure SetName(const AName :TComponentName); override;
    procedure SetMaster(const Value :TDataSource); override;
    procedure SetMasterFields(const Value :String); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;

    procedure CreateDataSet();
    procedure EnableControls();
    procedure DisableControls();
    procedure CopyDataSet(ASource :TDataset; AOptions :TFDCopyDataSetOptions);
    procedure Refresh();
    function FindField(const FieldName :String) :TField;
    function LocateEx(const AKeyFields :String; const AKeyValues :Variant; AOptions: TFDDataSetLocateOptions = []) :Boolean; overload;
    function LocateEx(const AExpression :String; AOptions :TFDDataSetLocateOptions = []) :Boolean; overload;

    procedure SetFDData(ASource :TFDDataSet);
    procedure SetChangeFieldEvent(cFieldName, cEventName :String);
    procedure SetGetTextFieldEvent(cFieldName, cEventName :String);

    property FDMemTable :TFDMemTable read FFDMemTable;
    property FieldDefs  :TFieldDefs  read GetFieldDefs write SetFieldDefs;
    property FDRecNo    :LongInt     read GetFDRecNo   write SetFDRecNo;

  published
    property IndexFieldNames :String  read GetIndexFieldNames write SetIndexFieldNames;
    property ReadOnly        :Boolean read GetReadOnly        write SetReadOnly default False;
    property AutoCalcFields  :Boolean read GetAutoCalcFields  write SetAutoCalcFields default True;
    property MasterFields;
    property Active          default False;

    property AfterOpen      :TfrxDataSetNotifyEvent read FAfterOpen      write FAfterOpen;
    property BeforeOpen     :TfrxDataSetNotifyEvent read FBeforeOpen     write FBeforeOpen;
    property AfterScroll    :TfrxDataSetNotifyEvent read FAfterScroll    write FAfterScroll;
    property BeforeScroll   :TfrxDataSetNotifyEvent read FBeforeScroll   write FBeforeScroll;
    property OnFilterRecord :TfrxFilterRecordEvent  read FOnFilterRecord write FOnFilterRecord;

  end; { TfrxFDMemTable }

  TfrxFDTable = class(TfrxCustomTable)
  private
    FDatabase: TfrxFDDatabase;
    FTable: TFDTable;
    procedure SetDatabase(const AValue: TfrxFDDatabase);
    function GetCatalogName: String;
    function GetSchemaName: String;
    procedure SetCatalogName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure SetMaster(const AValue: TDataSource); override;
    procedure SetMasterFields(const AValue: String); override;
    procedure SetIndexFieldNames(const AValue: String); override;
    procedure SetIndexName(const AValue: String); override;
    procedure SetTableName(const AValue: String); override;
    function GetIndexFieldNames: String; override;
    function GetIndexName: String; override;
    function GetTableName: String; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; AFlags: Word); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    property Table: TFDTable read FTable;
  published
    property Database: TfrxFDDatabase read FDatabase write SetDatabase;
    property CatalogName: String read GetCatalogName write SetCatalogName;
    property SchemaName: String read GetSchemaName write SetSchemaName;
  end;

  TfrxCustomStoredProc = class(TfrxCustomDataset)
  private
    FParams: TfrxParams;
    FSaveOnBeforeOpen: TDataSetNotifyEvent;
    FSaveOnAfterOpen: TDataSetNotifyEvent;
    procedure ReadParamData(AReader: TReader);
    procedure WriteParamData(AWriter: TWriter);
    procedure SetParams(AValue: TfrxParams);
  protected
    procedure DefineProperties(AFiler: TFiler); override;
    function GetStoredProcName: string; virtual;
    procedure SetStoredProcName(const AValue: string); virtual;
    procedure TriggerOnBeforeOpen(ADataSet: TDataSet); virtual;
    procedure TriggerOnAfterOpen(ADataSet: TDataSet); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecProc; virtual;
    procedure UpdateParams; virtual;
    procedure Prepare; virtual;
    procedure FetchParams; virtual;
    function ParamByName(const AValue: String): TfrxParamItem;
  published
    property Params: TfrxParams read FParams write SetParams;
    property StoredProcName: string read GetStoredProcName write SetStoredProcName; {added by fduenas}
  end;

  TfrxFDStoredProc = class(TfrxCustomStoredProc)
  private
    FDatabase: TfrxFDDatabase;
    FStoredProc: TFDStoredProc;
	// added for Master-Detail relationship
    procedure DoMasterSetValues(ASender: TFDDataSet);
    procedure SetDatabase(const AValue: TfrxFDDatabase);
    function GetPackageName: String;
    procedure SetPackageName(const AValue: String);
    function GetCatalogName: String;
    function GetSchemaName: String;
    procedure SetCatalogName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    function GetStoredProcName: string; override;
    procedure SetStoredProcName(const AValue: string); override;
    // added for Master-Detail RelationShip
    procedure SetMaster(const AValue: TDataSource); override;
    procedure TriggerOnAfterOpen(ADataSet: TDataSet); override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; AFlags: Word); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure ExecProc; override;
    procedure Prepare; override;
    procedure UpdateParams; override;
    procedure FetchParams; override;
    property StoredProc: TFDStoredProc read FStoredProc;
  published
    property Database: TfrxFDDatabase read FDatabase write SetDatabase;
    property CatalogName: String read GetCatalogName write SetCatalogName;
    property SchemaName: String read GetSchemaName write SetSchemaName;
    property PackageName: String read GetPackageName write SetPackageName;
  end;

{$IFDEF QBUILDER}
  TfrxEngineFD = class(TfqbEngine)
  private
    FQuery: TFDQuery;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadTableList(ATableList: TStrings); override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const AValue: string); override;
  end;
{$ENDIF}

var
  GFDComponents: TfrxFDComponents;

implementation

{$R *.res}

uses
  Dialogs, StrUtils,
  frxFDRTTI,
{$IFNDEF NO_EDITORS}
  frxFDEditor,
{$ENDIF}
  frxDsgnIntf, frxUtils, frxRes,
  FireDAC.Stan.Def, FireDAC.Stan.Util, FireDAC.Phys;

type
  TfrxHackFDDataSet = Class(TFDDataSet);

{-------------------------------------------------------------------------------}
{ TfrxFDComponents                                                              }
{-------------------------------------------------------------------------------}
constructor TfrxFDComponents.Create(AOwner: TComponent);
begin

 inherited Create(AOwner);

 FOldComponents := GFDComponents;
 FDesignTimeExpr := True;
 GFDComponents := Self;

end;

{-------------------------------------------------------------------------------}
destructor TfrxFDComponents.Destroy();
begin

  if GFDComponents = Self then
    GFDComponents := FOldComponents;

  inherited Destroy();

end;

{-------------------------------------------------------------------------------}
procedure TfrxFDComponents.Notification(AComponent: TComponent; Operation: TOperation);
begin

 inherited Notification(AComponent, Operation);

 if (AComponent = FDefaultDatabase) and (Operation = opRemove) then
   FDefaultDatabase := nil;

end;

{-------------------------------------------------------------------------------}
function TfrxFDComponents.GetDescription: String;
begin
 Result := 'FD';
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDComponents.SetDefaultDatabase(const AValue: TFDConnection);
begin

 if FDefaultDatabase <> AValue then begin

   if FDefaultDatabase <> nil then
     FDefaultDatabase.RemoveFreeNotification(Self);

   FDefaultDatabase := AValue;

   if FDefaultDatabase <> nil then
     FDefaultDatabase.FreeNotification(Self);

 end;

end;

{-------------------------------------------------------------------------------}
{ TfrxFDDatabase                                                                }
{-------------------------------------------------------------------------------}
constructor TfrxFDDatabase.Create(AOwner: TComponent);
begin

 inherited Create(AOwner);

 FDatabase := TFDConnection.Create(nil);
 Component := FDatabase;

end;

{-------------------------------------------------------------------------------}
destructor TfrxFDDatabase.Destroy;
begin
  // FDatabase.Free;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TfrxFDDatabase.GetDescription() :String;
begin
 Result := 'FD Database';
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabase.GetConnectionDefName() :String;
begin
 Result := FDatabase.ConnectionDefName;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabase.SetConnectionDefName(const AValue :String);
begin
 FDatabase.ConnectionDefName := AValue;
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabase.GetDriverName: string;
begin
 Result := FDatabase.DriverName;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabase.SetDriverName(const AValue :String);
begin
 FDatabase.DriverName := AValue;
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabase.GetDatabaseName: String;
begin
{$IFDEF DELPHI21}
  Result := FDatabase.ResultConnectionDef.Params.Database;
{$ELSE}
  Result := FDatabase.ResultConnectionDef.Database;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabase.SetDatabaseName(const AValue: String);
begin
{$IFDEF DELPHI21}
  FDatabase.ResultConnectionDef.Params.Database := AValue;
{$ELSE}
  FDatabase.ResultConnectionDef.Database := AValue;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabase.GetParams() :TStrings;
begin
 Result := FDatabase.Params;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabase.SetParams(AValue :TStrings);
begin
{$IFDEF DELPHI21}
  FDatabase.Params.Assign(AValue);
{$ELSE}
  FDatabase.Params := AValue;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabase.GetLoginPrompt() :Boolean;
begin
  Result := FDatabase.LoginPrompt;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabase.SetLoginPrompt(AValue :Boolean);
begin
 FDatabase.LoginPrompt := AValue;
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabase.GetConnected: Boolean;
begin
 Result := FDatabase.Connected;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabase.SetConnected(AValue :Boolean);
begin
 BeforeConnect(AValue);
 FDatabase.Connected := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabase.SetLogin(const ALogin, APassword :String);
begin
{$IFDEF DELPHI21}
  FDatabase.ResultConnectionDef.Params.UserName := ALogin;
  FDatabase.ResultConnectionDef.Params.Password := APassword;
{$ELSE}
  FDatabase.ResultConnectionDef.UserName := ALogin;
  FDatabase.ResultConnectionDef.Password := APassword;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDDatabase.FromString(const AConnection :WideString);
begin
 FDatabase.ResultConnectionDef.ParseString(AConnection);
end;

{-------------------------------------------------------------------------------}
function TfrxFDDatabase.ToString: WideString;
begin
 Result := FDatabase.ResultConnectionDef.BuildString();
end;

{-------------------------------------------------------------------------------}
{ TfrxFDQuery                                                                   }
{-------------------------------------------------------------------------------}
procedure frxParamsToFDParams(ADataSet :TfrxCustomDataset; AFrxParams :TfrxParams; AFDParams :TFDParams; AMasterDetail :Boolean = False);
var
  i, j, iFld    :Integer;
  oFDParam      :TFDParam;
  oFrxParam     :TfrxParamItem;
  oMasterFields :TStringList;
  lSkip         :Boolean;
  lDesignTime   :Boolean;
  oQuery        :TFDQuery;
  sExpr         :String;
  vRes          :Variant;
  ds            :TFDRdbmsDataSet;

  function CanExpandEscape(AReport :TfrxReport; AExpr :String; out ARes :Variant) :Boolean;
  var
    sVar   :String;
    i      :Integer;
    lIsVar :Boolean;

  begin

   Result := oQuery.Connection <> nil;

   if Result then begin

     sVar := AExpr;

     // 1st iteration of check
     lIsVar := (sVar[1] = '<') and (sVar[Length(sVar)] = '>');
     if lIsVar then begin

       i := AReport.Variables.IndexOf(Copy(sVar, 2, Length(sVar) - 2));

       Result := (i <> -1);

       if Result then
         sVar := VarToStr(AReport.Variables.Items[i].Value)
       else
         Exit;

     end; { if }

     // 2nd iteration
     Result := (Length(sVar) >= 5) and (sVar[1] = '{') and
               (sVar[Length(sVar)] = '}') and not(FDInSet(sVar[2], ['0' .. '9']));

     if Result then begin

       oQuery.SQL.Text := 'SELECT ' + sVar;
       try
         oQuery.Open;
       except
         Result := False;
       end; { try }

       Result := Result and (oQuery.RecordCount = 1);

       if Result then
         ARes := oQuery.Fields[0].Value;

     end; { if }

   end; { if }

  end; { CanExpandEscape }

begin

 ds := nil;

 if ADataSet is TfrxFDQuery then
   ds := TfrxFDQuery(ADataSet).FQuery
 else
 if ADataSet is TfrxFDStoredProc then
   ds := TfrxFDStoredProc(ADataSet).FStoredProc;

 if ds = nil then Exit;

 lDesignTime := (ADataSet.IsLoading or ADataSet.IsDesigning);

 oQuery := TFDQuery.Create(nil);
 oQuery.Connection := ds.Connection;
 oQuery.ResourceOptions.EscapeExpand := True;

 try

   for i := 0 to AFDParams.Count - 1 do begin

     oFDParam := AFDParams[i];
     j := AFrxParams.IndexOf(oFDParam.Name);

     if j <> -1 then begin

       oFrxParam := AFrxParams[j];
       oFDParam.Clear;
       oFDParam.DataType := oFrxParam.DataType;
       oFDParam.Bound := lDesignTime;

       if AMasterDetail and (ADataSet is TfrxFDQuery) then begin

         oMasterFields := TStringList.Create();
         try

           oMasterFields.Delimiter := ';';
           oMasterFields.DelimitedText := ds.MasterFields;
           lSkip := False;

           for iFld := 0 to oMasterFields.Count - 1 do begin

             lSkip := {$IFDEF AnyDAC_NOLOCALE_META} FDCompareText {$ELSE} AnsiCompareText {$ENDIF}
               (oFDParam.Name, oMasterFields[iFld]) = 0;

             if lSkip then
               Break;

           end; { for }

           if lSkip then
             Continue;

         finally
           oMasterFields.Free;
         end; { try }

       end; { if }

       sExpr := oFrxParam.Expression;

       if Trim(sExpr) <> '' then begin

         if ADataSet.Report <> nil then
           if CanExpandEscape(ADataSet.Report, sExpr, vRes) then
              oFrxParam.Value := vRes
           else
           if not (ADataSet.IsLoading or ADataSet.IsDesigning) then begin

             ADataSet.Report.CurObject := ADataSet.Name;
             oFrxParam.Value := ADataSet.Report.Calc(oFrxParam.Expression);

           end else begin

             if oFDParam.DataType in [ftString, ftWideString, ftFixedWideChar, ftWideMemo, ftFmtMemo, ftMemo] then
               oFrxParam.Value := ''
             else
             if oFDParam.DataType in [ftVariant, ftInteger, ftWord, ftLargeint, ftTimeStamp, ftFMTBcd, ftOraTimeStamp, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle] then
               oFrxParam.Value := 0
             else
               oFrxParam.Value := Unassigned;

           end; { if }
           // else
           //   oFrxParam.Value := sExpr;

       end; { if }

       if not VarIsEmpty(oFrxParam.Value) then begin
         oFDParam.Bound := True;
         oFDParam.Value := oFrxParam.Value;
       end; { if }

     end; { if }

   end; { for }

 finally
   oQuery.Free;
 end; { try }

end; { frxParamsToFDParams }

{-------------------------------------------------------------------------------}
{
 function used to recreate a TFrxParams collection from a TFDParams collection
 useful when borrowing TFDparams from any TFDQuery and TFDStoredProc objects after assigning
 a new SQL Text that can contain parameters (:paramName1, :paramName2, :paramNameN)
}

procedure frxFDParamsToParams(ADataSet :TfrxCustomDataSet; AFDParams :TFDParams; AfrxParams :TfrxParams; AIgnoreDuplicates :Boolean = True; AMasterDataSet :TDataSet = Nil);
var
  i, j      :Integer;
  NewParams :TfrxParams;

begin

 if AfrxParams = nil then
   Exit;

 { create new TfrxParams object and copy all params to it }
 NewParams := TfrxParams.Create();

 try

   for i := 0 to AFDParams.Count - 1 do
     if not ((NewParams.IndexOf(AFDParams[i].Name) <> -1) and AIgnoreDuplicates) then
       with NewParams.Add() do begin

          Name     := AFDParams[i].Name;
          j        := AfrxParams.IndexOf(Name);
          DataType := AFDParams.Items[i].DataType;

          if Assigned(AMasterDataSet) and
             Assigned(AMasterDataSet.FindField(Name)) and
             (DataType = ftUnknown) then
            DataType := AMasterDataSet.FindField(Name).DataType;

          if j <> -1 then begin
            Value := AfrxParams.Items[j].Value;
            Expression := AfrxParams.Items[j].Expression;
          end else
            Value := AFDParams.Items[i].Value;

       end; { with }

   AfrxParams.Clear;
   AfrxParams.Assign(NewParams);

 finally
    NewParams.Free;
 end; { try }

end; { frxFDParamsToParams }

{-------------------------------------------------------------------------------}
{
 function borrow only values from any TFDparams to TfrxParams
  used normally when calling TfrxFDStoredProc.ExecProc and the stored
  procedure returns values by Parameters )
}

procedure frxFDParamValuesToParams(ADataSet: TfrxCustomDataSet; AFDParams: TFDParams;
  AfrxParams: TfrxParams; AOnlyOutputParams: Boolean = False);
var
  i, j: Integer;
begin
  if AfrxParams = nil then
    Exit;
  for i := 0 to AFDParams.Count - 1 do
    if not AOnlyOutputParams or
       (AFDParams[i].ParamType in [ptInputOutput, ptOutput]) then begin
      j := AfrxParams.IndexOf(AFDParams[i].Name);
      if j > -1 then begin
        AfrxParams.Items[j].DataType := AFDParams.Items[i].DataType;
        AfrxParams.Items[j].Value := AFDParams.Items[i].Value;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
{ Code to assign current Master field values for Master-Detail Relationship }

procedure frxDoMasterSetValues(ADetailDataSet :TFDDataSet);
var
  i      :Integer;
  oParam :TFDParam;
  oField :TField;

begin

 with ADetailDataSet do begin

   if (MasterSource = Nil) or (MasterLink = Nil) then
     Exit;

   for i := 0 to MasterLink.Fields.Count - 1 do begin

     oField := TField(MasterLink.Fields[i]);
     oParam := FindParam(oField.FieldName);

     if oParam <> nil then
       oParam.AssignFieldValue(oField, oField.Value);

   end; { for }

 end; { with }

end; { frxDoMasterSetValues }

{-------------------------------------------------------------------------------}
constructor TfrxFDQuery.Create(AOwner: TComponent);
begin

 FLocked := False;
 FStrings := TStringList.Create();

 try
   FQuery := TFDQuery.Create(nil);
 except
   FQuery := nil;
 end; { try }

 if FQuery <> nil then
   FQuery.OnMasterSetValues := DoMasterSetValues;

 DataSet := FQuery;
 SetDatabase(nil);

 FMacroParams := TfrxParams.Create();

 FQuery.AfterOpen      := DoAfterOpen;
 FQuery.BeforeOpen     := DoBeforeOpen;
 FQuery.AfterScroll    := DoAfterScroll;
 FQuery.BeforeScroll   := DoBeforeScroll;
 FQuery.OnFilterRecord := DoFilterRecord;

 FChangeFieldEventList := TStringList.Create();
 FGetTextFieldEventList := TStringList.Create();

 inherited Create(AOwner);

 frComponentStyle := frComponentStyle + [csHandlesNestedProperties];

 if FQuery = nil then
   raise Exception.Create('DataSet is nil.');

end; { Create }

{-------------------------------------------------------------------------------}
constructor TfrxFDQuery.DesignCreate(AOwner: TComponent; AFlags: Word);
var
  i: Integer;
  l: TList;

begin

 inherited DesignCreate(AOwner, AFlags);

 l := Report.AllObjects;

 for i := 0 to l.Count - 1 do
   if TObject(l[i]) is TfrxFDDatabase then begin
     SetDatabase(TfrxFDDatabase(l[i]));
     Break;
   end; { if }

end; { DesignCreate }

{-------------------------------------------------------------------------------}
destructor TfrxFDQuery.Destroy();
begin

 FStrings.Clear;
 FreeAndNil(FStrings);

 FreeAndNil(FMacroParams);
 FreeAndNil(FChangeFieldEventList);
 FreeAndNil(FGetTextFieldEventList);

 inherited Destroy();

end; { Destroy }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DoMasterSetValues(ASender: TFDDataSet);
begin

 if FQuery = nil then Exit;

 frxParamsToFDParams(Self, Params, FQuery.Params, True);

 // Code to assign current Master field values for Master-Detail Relationship
 frxDoMasterSetValues(FQuery);

end; { DoMasterSetValues }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.FetchParams();
begin

 if FQuery = nil then Exit;

 frxFDParamsToParams(Self, FQuery.Params, Params, IgnoreDupParams);

end; { FetchParams }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetName(const AName :TComponentName);
begin

 inherited;

 if FQuery = nil then Exit;

 FQuery.Name := AName;

end; { SetName }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DefineProperties(Filer :TFiler);
begin

 inherited;

 Filer.DefineProperty('Macross', ReadData, WriteData, True);

end; { DefineProperties }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.ReadData(Reader: TReader);
begin

 frxReadCollection(FMacroParams, Reader, Self);
 MacroParamsToFDParams();

end; { ReadData }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.WriteData(Writer: TWriter);
begin
 frxWriteCollection(FMacroParams, Writer, Self);
end; { WriteData }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.WriteNestedProperties(Item :TfrxXmlItem; aAcenstor :TPersistent = nil);
begin

 if FMacroParams.Count > 0 then
   frxWriteCollection(FMacroParams, 'Macross', Item, Self, nil);

 if Self.Params.Count > 0 then
   frxWriteCollection(Self.Params, 'Parameters', Item, Self, nil);

end; { WriteNestedProperties }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.ReadNestedProperty(Item :TfrxXmlItem) :Boolean;
begin

 Result := True;

 if CompareText(Item.Name, 'Macross') = 0 then begin
   FMacroParams.Clear;
   frxReadCollection(FMacroParams, Item, Self, nil)
 end else
 if CompareText(Item.Name, 'Parameters') = 0 then begin
   Self.Params.Clear;
   frxReadCollection(Self.Params, Item, Self, nil)
 end else
   Result := False;

 if Result then
   UpdateParams();

end; { ReadNestedProperty }

{-------------------------------------------------------------------------------}
class function TfrxFDQuery.GetDescription() :String;
begin
 Result := 'FD Query';
end; { GetDescription }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.Notification(AComponent: TComponent; AOperation: TOperation);
begin

 inherited Notification(AComponent, AOperation);

 if (AOperation = opRemove) and (AComponent = FDatabase) then
   SetDatabase(nil);

end; { Notification }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.OnChangeSQL(Sender: TObject);
var
  i, ind   :Integer;
  frxParam :TfrxParamItem;
  FDParam  :TFDParam;
  nCount   :Integer;

begin

  if FQuery = nil then Exit;

  // code borrowed from TfrxFDOquery component
  if not FLocked then begin

    nCount := FQuery.Params.Count;

    // needed to update parameters
    FQuery.SQL.Text := '';
    FQuery.SQL.Assign(FStrings);

   if (FQuery.Params.Count <> nCount) and (FQuery.MasterFields <> '') then
     FQuery.MasterFields := '';

    FDMacrosToMacroParams();

    frxParamsToFDParams(Self, Params, FQuery.Params);

    inherited;

    // fill datatype automatically, if possible
    for i := 0 to FQuery.Params.Count - 1 do begin

      FDParam := FQuery.Params[i];
      ind := Params.IndexOf(FDParam.Name);

      if ind <> -1 then begin

        frxParam := Params[ind];

        if (frxParam.DataType = ftUnknown) and Self.IsDesigning then begin

          if Assigned(Self.Master) and Assigned(Self.Master.DataSet) then begin

            if (not Self.Master.DataSet.Active) and
               (Self.Master.DataSet.FieldCount = 0) and
               (Self.Master.FieldAliases.IndexOfName(FDParam.Name) > -1) then
              Self.Master.DataSet.Active := True;

            if Assigned(Self.Master.DataSet.FindField(FDParam.Name)) then begin
              frxParam.DataType := Self.Master.DataSet.FindField(FDParam.Name).DataType;
              FDParam.DataType  := frxParam.DataType;
            end; { if }

          end; { if }

        end; { if }

        if (frxParam.DataType = ftUnknown) and (FDParam.DataType <> ftUnknown) then
          frxParam.DataType := FDParam.DataType;

      end; { if }

    end; { for }

  end; { if }

end; { OnChangeSQL }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.FDMacrosToMacroParams();
var
  i, j      :Integer;
  NewParams :TfrxParams;
  oQuery    :TFDQuery;

begin

 oQuery := TFDQuery.Create(Self);
 try

   oQuery.ResourceOptions.MacroCreate := True;
   oQuery.ResourceOptions.MacroExpand := True;
   oQuery.SQL.Assign(FQuery.SQL);

   FQuery.Macros.Clear;
   for i := 0 to oQuery.MacroCount - 1 do
      FQuery.Macros.Add.Assign(oQuery.Macros[i]);

 finally
   FreeAndNil(oQuery);
 end; { try }

 NewParams := TfrxParams.Create();
 try

   for i := 0 to FQuery.MacroCount - 1 do
     with NewParams.Add() do begin

       Name := FQuery.Macros[i].Name;
       j := Macros.IndexOf(Name);

       if j <> -1 then begin
         DataType   := Macros.Items[j].DataType;
         Value      := Macros.Items[j].Value;
         Expression := Macros.Items[j].Expression;
       end; { if }

     end; { with }

 finally

   Macros.Assign(NewParams);
   FreeAndNil(NewParams);

 end; { try }

end; { FDMacrosToMacroParams }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.MacroParamsToFDParams();

 function ConvPT(oFieldType :TFieldType) :TFDMacroDataType;
 begin

   case oFieldType of
     ftFloat    :Result := mdFloat;
     ftInteger  :Result := mdInteger;
     ftSmallInt :Result := mdInteger;
     ftCurrency :Result := mdFloat;
     ftDate     :Result := mdDate;
     ftDateTime :Result := mdDateTime;
     ftTime     :Result := mdTime;
     ftBoolean  :Result := mdBoolean;
     ftString   :Result := mdString;
   else
     Result := mdRaw
   end; { case }

 end; { ConvPT }

var
  i      :Integer;
  Item   :TfrxParamItem;
  nCount :Integer;

begin

 nCount := FQuery.Params.Count;

 for i := 0 to FQuery.Macros.Count - 1 do
   if Self.Macros.IndexOf(FQuery.Macros[i].Name) <> -1 then begin

     Item := Self.Macros[Self.Macros.IndexOf(FQuery.Macros[i].Name)];
     FQuery.Macros[i].Clear;
     FQuery.Macros[i].DataType := ConvPT(Item.DataType);

     if Trim(Item.Expression) <> '' then begin

       FQuery.Macros[i].Value := '';

       if not (Self.IsLoading or Self.IsDesigning) then
         if Self.Report <> nil then begin
           Self.Report.CurObject := Self.Name;
           Item.Value := Self.Report.Calc(Item.Expression);
         end; { if }

     end; { if }

     if not VarIsEmpty(Item.Value) then
       FQuery.Macros[i].Value := VarToStr(Item.Value);

   end; { if }

 if (FQuery.Params.Count <> nCount) and (FQuery.MasterFields <> '') then
   FQuery.MasterFields := '';

end; { MacroParamsToFDParams }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetDatabase(const AValue: TfrxFDDatabase);
begin

 if FQuery = nil then Exit;

 FDatabase := AValue;

 if AValue <> nil then
   FQuery.Connection := AValue.Database
 else
 if GFDComponents <> nil then
   FQuery.Connection := GFDComponents.DefaultDatabase
 else
   FQuery.Connection := nil;

 DBConnected := FQuery.Connection <> nil;

end; { SetDatabase }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.GetSQL() :TStrings;
begin

 Result := FStrings;
 if FQuery = nil then Exit;

 FLocked := True;
 try
   FStrings.Assign(FQuery.SQL);
 finally
   FLocked := False;
 end; { try }

end; { GetSQL }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetSQL(AValue: TStrings);
begin

 FQuery.SQL.Assign(AValue);
 FStrings.Assign(FQuery.SQL);

end; { SetSQL }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetMaster(const AValue: TDataSource);
begin

 if FQuery = nil then Exit;

 FQuery.MasterSource := AValue;

end; { SetMaster }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetMasterFields(const AValue: String);
begin
  if FQuery = nil then Exit;
  FQuery.MasterFields := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.UpdateParams();
begin

 if FQuery = nil then Exit;

 MacroParamsToFDParams();
 frxParamsToFDParams(Self, Params, FQuery.Params, ASSIGNED(Master));

end; { UpdateParams }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.BeforeStartReport();
begin

 if FQuery = nil then Exit;

 SetDatabase(FDatabase);

end; { BeforeStartReport }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.GetUniDirectional() :Boolean;
begin

 Result := False;

 if FQuery = nil then Exit;

 Result := FQuery.FetchOptions.Unidirectional;

end; { GetUniDirectional }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetUniDirectional(const AValue: Boolean);
begin

 if FQuery = nil then Exit;

 FQuery.FetchOptions.Unidirectional := AValue;

end; { SetUniDirectional }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.GetCachedUpdates() :Boolean;
begin
 Result := FQuery.CachedUpdates;
end; { GetCachedUpdates }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetCachedUpdates(const Value: Boolean);
begin
 FQuery.CachedUpdates := Value;
end; { SetCachedUpdates }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetMacroParams(const Value :TfrxParams);
begin
 FMacroParams.Assign(Value);
end; { SetMacroParams }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.GetMacroCreate() :Boolean;
begin
 Result := FQuery.ResourceOptions.MacroCreate;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetMacroCreate(const Value :Boolean);
begin
 FQuery.ResourceOptions.MacroCreate := Value;
end; { SetMacroCreate }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.GetMacroExpand() :Boolean;
begin
 Result := FQuery.ResourceOptions.MacroExpand;
end; { GetMacroExpand }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetMacroExpand(const Value :Boolean);
begin
 FQuery.ResourceOptions.MacroExpand := Value;
end; { SetMacroExpand }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.GetReadOnly() :Boolean;
begin
 Result := FQuery.UpdateOptions.ReadOnly;
end; { GetReadOnly }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetReadOnly(const Value :Boolean);
begin
 FQuery.UpdateOptions.ReadOnly := Value;
end; { SetReadOnly }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.GetFDRecNo() :LongInt;
begin
 Result := FQuery.RecNo;
end; { GetFDRecNo }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetFDRecNo(const Value :LongInt);
begin
 FQuery.RecNo := Value;
end; { SetFDRecNo }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.MacroByName(const MacroName :String) :TfrxParamItem;
begin
 Result := FMacroParams.Find(MacroName);
end; { MacroByName }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.ExecSQL();
begin
 FQuery.ExecSQL();
end; { ExecSQL }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.FetchAll();
begin
 FQuery.FetchAll();
end; { FetchAll }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DisableControls();
begin
 FQuery.DisableControls();
end; { DisableControls }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.EnableControls();
begin
 FQuery.EnableControls();
end; { EnableControls }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.CreateBlobStream(Field :TField; Mode :TBlobStreamMode) :TStream;
begin
 Result := FQuery.CreateBlobStream(Field, Mode);
end; { CreateBlobStream }

function TfrxFDQuery.FindField(const FieldName :String) :TField;
begin
 Result := FQuery.FindField(FieldName);
end; { FindField }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.LocateEx(const AKeyFields :String; const AKeyValues :Variant; AOptions: TFDDataSetLocateOptions = []) :Boolean;
begin
 Result := FQuery.LocateEx(AKeyFields, AKeyValues, AOptions);
end; { LocateEx }

{-------------------------------------------------------------------------------}
function TfrxFDQuery.LocateEx(const AExpression :String; AOptions :TFDDataSetLocateOptions = []) :Boolean;
begin
 Result := FQuery.LocateEx(AExpression, AOptions);
end; { LocateEx }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DoAfterOpen(DataSet: TDataSet);
var
  vArr: Variant;

begin

 if FAfterOpen <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet)]);

   if Report <> nil then
     Report.DoParamEvent(FAfterOpen, vArr);

 end; { if }

end; { DoAfterOpen }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DoBeforeOpen(DataSet: TDataSet);
var
  vArr: Variant;

begin

 if FBeforeOpen <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet)]);

   if Report <> nil then
     Report.DoParamEvent(FBeforeOpen, vArr);

 end; { if }

end; { DoBeforeOpen }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DoAfterScroll(DataSet: TDataSet);
var
  vArr: Variant;

begin

 if FAfterScroll <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet)]);

   if Report <> nil then
     Report.DoParamEvent(FAfterScroll, vArr);

 end; { if }

end; { DoAfterScroll }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DoBeforeScroll(DataSet: TDataSet);
var
  vArr: Variant;

begin

 if FBeforeScroll <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet)]);

   if Report <> nil then
     Report.DoParamEvent(FBeforeScroll, vArr);

 end; { if }

end;  { DoBeforeScroll }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DoFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  vArr: Variant;

begin

 if FOnFilterRecord <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet), Accept]);

   if Report <> nil then
     Report.DoParamEvent(FOnFilterRecord, vArr);

   Accept := vArr[1];

 end; { if }

end; { DoFilterRecord }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetChangeFieldEvent(cFieldName, cEventName :String);
begin

 if not Assigned(FQuery.FindField(cFieldName)) then begin
   raise Exception.Create('SetChangeFieldEvent: Field '+cFieldName+' not Found.');
   Exit;
 end; { if }

 if cEventName <> '' then begin
   FChangeFieldEventList.Values[cFieldName] := cEventName;
   FQuery.FieldByName(cFieldName).OnChange := DoChangeField;
 end else begin
   with FChangeFieldEventList do Delete(IndexOfName(cFieldName));
   FQuery.FieldByName(cFieldName).OnChange := nil;
 end; { if }

end; { SetChangeFieldEvent }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DoChangeField(Field :TField);
var
  vArr :Variant;

begin

 if not Assigned(Field) then begin
   raise Exception.Create('DoChangeField: Field not Found.');
   Exit;
 end; { if }

 vArr := VarArrayOf([frxInteger(Field)]);

 if Report <> nil then
   Report.DoParamEvent(FChangeFieldEventList.Values[Field.FieldName], vArr);

end;  { DoChangeField }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.SetGetTextFieldEvent(cFieldName, cEventName :String);
begin

 if not Assigned(FQuery.FindField(cFieldName)) then begin
   raise Exception.Create('SetGetTextFieldEvent: Field '+cFieldName+' not Found.');
   Exit;
 end; { if }

 if cEventName <> '' then begin
   FGetTextFieldEventList.Values[cFieldName] := cEventName;
   FQuery.FieldByName(cFieldName).OnGetText := DoGetTextField;
 end else begin
   with FGetTextFieldEventList do Delete(IndexOfName(cFieldName));
   FQuery.FieldByName(cFieldName).OnGetText := nil;
 end; { if }

end; { SetGetTextFieldEvent }

{-------------------------------------------------------------------------------}
procedure TfrxFDQuery.DoGetTextField(Field :TField; var Text :String; DisplayText :Boolean);
var
  vArr :Variant;

begin

 if not Assigned(Field) then begin
   raise Exception.Create('DoGetTextField: Field not Found.');
   Exit;
 end; { if }

 vArr := VarArrayOf([frxInteger(Field), Text, DisplayText]);

 if Report <> nil then
   Report.DoParamEvent(FGetTextFieldEventList.Values[Field.FieldName], vArr);

 Text := vArr[1];

end; { DoGetTextField }

{-------------------------------------------------------------------------------}
{$IFDEF QBUILDER}
function TfrxFDQuery.QBEngine() :TfqbEngine;
begin

 Result := TfrxEngineFD.Create(nil);

 TfrxEngineFD(Result).FQuery.Connection := FQuery.Connection;

 if (FQuery.Connection <> nil) and not FQuery.Connection.Connected then
   FQuery.Connection.Connected := True;

end; { QBEngine }
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TfrxFDMemTable                                                                }
{-------------------------------------------------------------------------------}
constructor TfrxFDMemTable.Create(AOwner :TComponent);
begin

 FFDMemTable := TFDMemTable.Create(nil);
 DataSet     := FFDMemTable;

 FFDMemTable.AfterOpen      := DoAfterOpen;
 FFDMemTable.BeforeOpen     := DoBeforeOpen;
 FFDMemTable.AfterScroll    := DoAfterScroll;
 FFDMemTable.BeforeScroll   := DoBeforeScroll;
 FFDMemTable.OnFilterRecord := DoFilterRecord;

 FChangeFieldEventList  := TStringList.Create();
 FGetTextFieldEventList := TStringList.Create();

 inherited Create(AOwner);

end; { Create }

{-------------------------------------------------------------------------------}
destructor TfrxFDMemTable.Destroy();
begin

 FreeAndNil(FChangeFieldEventList);
 FreeAndNil(FGetTextFieldEventList);

 inherited Destroy();

end; { Destroy }

{-------------------------------------------------------------------------------}
class function TfrxFDMemTable.GetDescription: String;
begin
 Result := 'FD MemTable';
end; { GetDescription }

{-------------------------------------------------------------------------------}
function TfrxFDMemTable.GetReadOnly() :Boolean;
begin
 Result := FFDMemTable.ReadOnly;
end; { GetReadOnly }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetReadOnly(const Value :Boolean);
begin
 FFDMemTable.ReadOnly := Value;
end; { SetReadOnly }

{-------------------------------------------------------------------------------}
function TfrxFDMemTable.GetAutoCalcFields() :Boolean;
begin
 Result := FFDMemTable.AutoCalcFields;
end; { GetAutoCalcFields }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetAutoCalcFields(const Value :Boolean);
begin
 FFDMemTable.AutoCalcFields := Value;
end; { SetAutoCalcFields }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetName(const AName :TComponentName);
begin
 inherited;
 FFDMemTable.Name := AName;
end; { SetName }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetMaster(const Value :TDataSource);
begin
 FFDMemTable.MasterSource := Value;
end; { SetMaster }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetMasterFields(const Value :String);
begin
 FFDMemTable.MasterFields := Value;
end; { SetMasterFields }

{-------------------------------------------------------------------------------}
function TfrxFDMemTable.GetFieldDefs() :TFieldDefs;
begin
 Result := FFDMemTable.FieldDefs;
end; { GetFieldDefs }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetFieldDefs(const Value :TFieldDefs);
begin
 FFDMemTable.FieldDefs := Value;
end; { SetFieldDefs }

{-------------------------------------------------------------------------------}
function TfrxFDMemTable.GetIndexFieldNames() :String;
begin
 Result := FFDMemTable.IndexFieldNames;
end; { GetFieldDefs }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetIndexFieldNames(const Value :String);
begin
 FFDMemTable.IndexFieldNames := Value;
end; { SetFieldDefs }

{-------------------------------------------------------------------------------}
function TfrxFDMemTable.GetFDRecNo() :LongInt;
begin
 Result := FFDMemTable.RecNo;
end; { GetFDRecNo }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetFDRecNo(const Value :LongInt);
begin
 FFDMemTable.RecNo := Value;
end; { SetFDRecNo }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetFDData(ASource :TFDDataSet);
begin
 FFDMemTable.Data := ASource.Data;
end; { SetFDData }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.CreateDataSet();
begin
 FFDMemTable.CreateDataSet();
end; { CreateDataSet }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.DisableControls();
begin
 FFDMemTable.DisableControls();
end; { DisableControls }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.EnableControls();
begin
 FFDMemTable.EnableControls();
end; { EnableControls }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.CopyDataSet(ASource :TDataset; AOptions :TFDCopyDataSetOptions);
begin
 FFDMemTable.CopyDataSet(ASource, AOptions);
end; { CopyDataSet }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.Refresh();
begin
 FFDMemTable.Refresh();
end; { Refresh }

{-------------------------------------------------------------------------------}
function TfrxFDMemTable.FindField(const FieldName :String) :TField;
begin
 Result := FFDMemTable.FindField(FieldName);
end; { FindField }

{-------------------------------------------------------------------------------}
function TfrxFDMemTable.LocateEx(const AKeyFields :String; const AKeyValues :Variant; AOptions: TFDDataSetLocateOptions = []) :Boolean;
begin
 Result := FFDMemTable.LocateEx(AKeyFields, AKeyValues, AOptions);
end; { LocateEx }

{-------------------------------------------------------------------------------}
function TfrxFDMemTable.LocateEx(const AExpression :String; AOptions :TFDDataSetLocateOptions = []) :Boolean;
begin
 Result := FFDMemTable.LocateEx(AExpression, AOptions);
end; { LocateEx }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.DoAfterOpen(DataSet :TDataSet);
var
  vArr :Variant;

begin

 if FAfterOpen <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet)]);

   if Report <> nil then
     Report.DoParamEvent(FAfterOpen, vArr);

 end; { if }

end; { DoAfterOpen }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.DoBeforeOpen(DataSet :TDataSet);
var
  vArr :Variant;

begin

 if FBeforeOpen <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet)]);

   if Report <> nil then
     Report.DoParamEvent(FBeforeOpen, vArr);

 end; { if }

end; { DoBeforeOpen }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.DoAfterScroll(DataSet :TDataSet);
var
  vArr :Variant;

begin

 if FAfterScroll <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet)]);

   if Report <> nil then
     Report.DoParamEvent(FAfterScroll, vArr);

 end; { if }

end; { DoAfterScroll }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.DoBeforeScroll(DataSet :TDataSet);
var
  vArr :Variant;

begin

 if FBeforeScroll <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet)]);

   if Report <> nil then
     Report.DoParamEvent(FBeforeScroll, vArr);

 end; { if }

end; { DoBeforeScroll }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.DoFilterRecord(DataSet :TDataSet; var Accept :Boolean);
var
  vArr :Variant;

begin

 if FOnFilterRecord <> '' then begin

   vArr := VarArrayOf([frxInteger(DataSet), Accept]);

   if Report <> nil then
     Report.DoParamEvent(FOnFilterRecord, vArr);

   Accept := vArr[1];

 end; { if }

end; { DoFilterRecord }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetChangeFieldEvent(cFieldName, cEventName :String);
begin

 if not Assigned(FFDMemTable.FindField(cFieldName)) then begin
   raise Exception.Create('SetChangeFieldEvent: Field '+cFieldName+' not Found.');
   Exit;
 end; { if }

 if cEventName <> '' then begin
   FChangeFieldEventList.Values[cFieldName] := cEventName;
   FFDMemTable.FieldByName(cFieldName).OnChange := DoChangeField;
 end else begin
   with FChangeFieldEventList do Delete(IndexOfName(cFieldName));
   FFDMemTable.FieldByName(cFieldName).OnChange := nil;
 end; { if }

end; { SetChangeFieldEvent }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.DoChangeField(Field :TField);
var
  vArr :Variant;

begin

 if not Assigned(Field) then begin
   raise Exception.Create('DoChangeField: Field not Found.');
   Exit;
 end; { if }

 vArr := VarArrayOf([frxInteger(Field)]);

 if Report <> nil then
   Report.DoParamEvent(FChangeFieldEventList.Values[Field.FieldName], vArr);

end; { DoChangeField }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.SetGetTextFieldEvent(cFieldName, cEventName :String);
begin

 if not Assigned(FFDMemTable.FindField(cFieldName)) then begin
   raise Exception.Create('SetGetTextFieldEvent: Field '+cFieldName+' not Found.');
   Exit;
 end; { if }

 if cEventName <> '' then begin
   FGetTextFieldEventList.Values[cFieldName] := cEventName;
   FFDMemTable.FieldByName(cFieldName).OnGetText := DoGetTextField;
 end else begin
   with FGetTextFieldEventList do Delete(IndexOfName(cFieldName));
   FFDMemTable.FieldByName(cFieldName).OnGetText := nil;
 end; { if }

end; { SetGetTextFieldEvent }

{-------------------------------------------------------------------------------}
procedure TfrxFDMemTable.DoGetTextField(Field :TField; var Text :String; DisplayText :Boolean);
var
  vArr :Variant;

begin

 if not Assigned(Field) then begin
   raise Exception.Create('DoGetTextField: Field not Found.');
   Exit;
 end; { if }

 vArr := VarArrayOf([frxInteger(Field), Text, DisplayText]);

 if Report <> nil then
   Report.DoParamEvent(FGetTextFieldEventList.Values[Field.FieldName], vArr);

 Text := vArr[1];

end; { DoGetTextField }

{-------------------------------------------------------------------------------}
{ TfrxFDTable                                                                   }
{-------------------------------------------------------------------------------}
constructor TfrxFDTable.Create(AOwner: TComponent);
begin
  try
    FTable := TFDTable.Create(nil);
  except
    FTable := nil;
  end;
  DataSet := FTable;
  SetDatabase(nil);
  inherited Create(AOwner);
  if FTable = nil then
    raise Exception.Create('DataSet is nil.');
end;

{-------------------------------------------------------------------------------}
constructor TfrxFDTable.DesignCreate(AOwner: TComponent; AFlags: Word);
var
  i: Integer;
  l: TList;
begin
  inherited DesignCreate(AOwner, AFlags);
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
    if TObject(l[i]) is TfrxFDDatabase then begin
      SetDatabase(TfrxFDDatabase(l[i]));
      break;
    end;
end;

{-------------------------------------------------------------------------------}
class function TfrxFDTable.GetDescription: String;
begin
  Result := 'FD Table';
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if (AOperation = opRemove) and (AComponent = FDatabase) then
    SetDatabase(nil);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.SetDatabase(const AValue: TfrxFDDatabase);
begin
  if FTable = nil then Exit;
  FDatabase := AValue;
  if AValue <> nil then
    FTable.Connection := AValue.Database
  else if GFDComponents <> nil then
    FTable.Connection := GFDComponents.DefaultDatabase
  else
    FTable.Connection := nil;
  DBConnected := FTable.Connection <> nil;
end;

{-------------------------------------------------------------------------------}
function TfrxFDTable.GetIndexFieldNames: String;
begin
  if FTable = nil then Exit;
  Result := FTable.IndexFieldNames;
end;

{-------------------------------------------------------------------------------}
function TfrxFDTable.GetIndexName: String;
begin
  if FTable = nil then Exit;
  Result := FTable.IndexName;
end;

{-------------------------------------------------------------------------------}
function TfrxFDTable.GetCatalogName: String;
begin
  if FTable = nil then Exit;
  Result := FTable.CatalogName;
end;

{-------------------------------------------------------------------------------}
function TfrxFDTable.GetSchemaName: String;
begin
  if FTable = nil then Exit;
  Result := FTable.SchemaName;
end;

{-------------------------------------------------------------------------------}
function TfrxFDTable.GetTableName: String;
begin
  if FTable = nil then Exit;
  Result := FTable.TableName;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.SetIndexFieldNames(const AValue: String);
begin
  if FTable = nil then Exit;
  FTable.IndexFieldNames := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.SetIndexName(const AValue: String);
begin
  if FTable = nil then Exit;
  FTable.IndexName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.SetCatalogName(const AValue: String);
begin
  if FTable = nil then Exit;
  FTable.CatalogName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.SetSchemaName(const AValue: String);
begin
  if FTable = nil then Exit;
  FTable.SchemaName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.SetTableName(const AValue: String);
begin
  if FTable = nil then Exit;
  FTable.TableName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.SetMaster(const AValue: TDataSource);
begin
  if FTable = nil then Exit;
  FTable.MasterSource := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.SetMasterFields(const AValue: String);
begin
  if FTable = nil then Exit;
  FTable.MasterFields := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDTable.BeforeStartReport;
begin
  if FTable = nil then Exit;
  SetDatabase(FDatabase);
end;

{-------------------------------------------------------------------------------}
{ TfrxCustomStoredProc                                                          }
{-------------------------------------------------------------------------------}
constructor TfrxCustomStoredProc.Create(AOwner: TComponent);
begin
  FParams := TfrxParams.Create;
  inherited Create(AOwner);
  if DataSet <> nil then
  begin
    FSaveOnBeforeOpen := DataSet.BeforeOpen;
    FSaveOnAfterOpen := DataSet.AfterOpen;
    DataSet.BeforeOpen := TriggerOnBeforeOpen;
  end;
end;

{-------------------------------------------------------------------------------}
destructor TfrxCustomStoredProc.Destroy;
begin
  FParams.Free;
  if DataSet <> nil then
    DataSet.BeforeOpen := FSaveOnBeforeOpen;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.ExecProc;
begin
 // Do nothing, code Should be added on inherited Classes;
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.DefineProperties(AFiler: TFiler);
begin
  inherited DefineProperties(AFiler);
  AFiler.DefineProperty('Parameters', ReadParamData, WriteParamData, True);
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.ReadParamData(AReader: TReader);
begin
  frxReadCollection(FParams, AReader, Self);
  UpdateParams;
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.WriteParamData(AWriter: TWriter);
begin
  frxWriteCollection(FParams, AWriter, Self);
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.TriggerOnAfterOpen(ADataSet: TDataSet);
begin
 if Assigned(FSaveOnAfterOpen) then
    FSaveOnAfterOpen(DataSet);
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.TriggerOnBeforeOpen(ADataSet: TDataSet);
begin
  UpdateParams;
  if Assigned(FSaveOnBeforeOpen) then
    FSaveOnBeforeOpen(DataSet);
end;

{-------------------------------------------------------------------------------}
function TfrxCustomStoredProc.ParamByName(const AValue: String): TfrxParamItem;
begin
  Result := FParams.Find(AValue);
  if Result = nil then
    raise Exception.Create('Parameter "' + AValue + '" not found');
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.Prepare;
begin
  // Do nothing, code Should be added on inherited Classes;
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.FetchParams;
begin
  // Do nothing, code Should be added on inherited Classes;
end;

{-------------------------------------------------------------------------------}
function TfrxCustomStoredProc.GetStoredProcName: string;
begin
  // Do nothing, code Should be added on inherited Classes;
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.SetParams(AValue: TfrxParams);
begin
  FParams.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.SetStoredProcName(const AValue: string);
begin
  // Do nothing, code Should be added on inherited Classes;
end;

{-------------------------------------------------------------------------------}
procedure TfrxCustomStoredProc.UpdateParams;
begin
  // Do nothing, code Should be added on inherited Classes;
end;

{-------------------------------------------------------------------------------}
{ TfrxFDStoredProc                                                              }
{-------------------------------------------------------------------------------}
constructor TfrxFDStoredProc.Create(AOwner: TComponent);
begin
  try
    FStoredProc := TFDStoredProc.Create(nil);
  except
    FStoredProc := nil;
  end;
  if FStoredProc <> nil then
    FStoredProc.OnMasterSetValues := DoMasterSetValues;
  Dataset := FStoredProc;
  SetDatabase(nil);
  inherited Create(AOwner);
  if FStoredProc = nil then
    raise Exception.Create('DataSet is nil.');
end;

{-------------------------------------------------------------------------------}
constructor TfrxFDStoredProc.DesignCreate(AOwner: TComponent; AFlags: Word);
var
  i: Integer;
  l: TList;
begin
  inherited DesignCreate(AOwner, AFlags);
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
    if TObject(l[i]) is TfrxFDDatabase then begin
      SetDatabase(TfrxFDDatabase(l[i]));
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.DoMasterSetValues(ASender: TFDDataSet);
begin
  if FStoredProc = nil then Exit;
  // Code to assign current Master field values for Master-Detail Relationship
  frxDoMasterSetValues( FStoredProc );
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.ExecProc;
begin
  if FStoredProc = nil then Exit;
  UpdateParams;
  FStoredProc.ExecProc;
  frxFDParamValuesToParams(Self, FStoredProc.Params, Params, True);
end;

{-------------------------------------------------------------------------------}
class function TfrxFDStoredProc.GetDescription: String;
begin
  Result := 'FD StoredProc';
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if (AOperation = opRemove) and (AComponent = FDatabase) then
    SetDatabase(nil);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.Prepare;
begin
  if FStoredProc = nil then Exit;
  FetchParams;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.FetchParams;
begin
  if FStoredProc = nil then Exit;
  if csDesigning in ComponentState then
    Exit;
  FStoredProc.Unprepare;
  if (StoredProcName <> '') and (FStoredProc.Connection <> nil) then
    FStoredProc.Prepare;
  if (StoredProcName = '') or FStoredProc.Prepared then
    frxFDParamsToParams(Self, FStoredProc.Params, FParams, True);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.SetCatalogName(const AValue: String);
begin
  if FStoredProc = nil then Exit;
  FStoredProc.CatalogName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.SetSchemaName(const AValue: String);
begin
  if FStoredProc = nil then Exit;
  FStoredProc.SchemaName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.TriggerOnAfterOpen(ADataSet: TDataSet);
begin
  if FStoredProc = nil then Exit;
  // copy Values from Output Type TFDParams to TfrxParams, only for SP that return values
  frxFDParamValuesToParams(Self, FStoredProc.Params, Params, true);
  inherited;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.SetDatabase(const AValue: TfrxFDDatabase);
begin
  if FStoredProc = nil then Exit;
  FDatabase := AValue;
  if AValue <> nil then
    FStoredProc.Connection := AValue.Database
  else if GFDComponents <> nil then
    FStoredProc.Connection := GFDComponents.DefaultDatabase
  else
    FStoredProc.Connection := nil;
  if (AValue <> nil) and (AValue.Connected) then
    FetchParams;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.SetMaster(const AValue: TDataSource);
begin
  if FStoredProc = nil then Exit;
  FStoredProc.MasterSource := AValue;
end;

{-------------------------------------------------------------------------------}
function TfrxFDStoredProc.GetPackageName: String;
begin
  if FStoredProc = nil then Exit;
  Result := FStoredProc.PackageName;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.SetPackageName(const AValue: String);
begin
  if FStoredProc = nil then Exit;
  FStoredProc.PackageName := AValue;
end;

{-------------------------------------------------------------------------------}
function TfrxFDStoredProc.GetCatalogName: String;
begin
  if FStoredProc = nil then Exit;
  Result := FStoredProc.CatalogName;
end;

{-------------------------------------------------------------------------------}
function TfrxFDStoredProc.GetSchemaName: String;
begin
  if FStoredProc = nil then Exit;
  Result := FStoredProc.SchemaName;
end;

{-------------------------------------------------------------------------------}
function TfrxFDStoredProc.GetStoredProcName: string;
begin
  Result := FStoredProc.StoredProcName;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.SetStoredProcName(const AValue: string);
begin
  FStoredProc.StoredProcName := AValue;
  FetchParams;
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.UpdateParams;
begin
  if FStoredProc = nil then Exit;
  frxParamsToFDParams(Self, Params, FStoredProc.Params);
end;

{-------------------------------------------------------------------------------}
procedure TfrxFDStoredProc.BeforeStartReport;
begin
  if FStoredProc = nil then Exit;
  inherited BeforeStartReport;
  SetDatabase(FDatabase);
end;

{-------------------------------------------------------------------------------}
{ TfrxEngineFD                                                                  }
{-------------------------------------------------------------------------------}
{$IFDEF QBUILDER}
constructor TfrxEngineFD.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuery := TFDQuery.Create(nil);
end;

{-------------------------------------------------------------------------------}
destructor TfrxEngineFD.Destroy;
begin
  FreeAndNil(FQuery);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TfrxEngineFD.ReadFieldList(const ATableName: string;
  var AFieldList: TfqbFieldList);
var
  oTab: TFDTable;
  oDefs: TFieldDefs;
  i: Integer;
  oQBField: TfqbField;
begin
  AFieldList.Clear;
  oTab := TFDTable.Create(Self);
  oTab.Connection := FQuery.Connection;
  oTab.TableName := ATableName;
  oDefs := oTab.FieldDefs;
  try
    try
      oTab.Active := True;
      oQBField := TfqbField(AFieldList.Add);
      oQBField.FieldName := '*';
      for i := 0 to oDefs.Count - 1 do begin
        oQBField := TfqbField(AFieldList.Add);
        oQBField.FieldName := oDefs.Items[i].Name;
        oQBField.FieldType := Ord(oDefs.Items[i].DataType)
      end;
    except
    end;
  finally
    oTab.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrxEngineFD.ReadTableList(ATableList: TStrings);
begin
  ATableList.Clear;
  FQuery.Connection.GetTableNames(FQuery.ConnectionName, '', '', ATableList);
end;

{-------------------------------------------------------------------------------}
function TfrxEngineFD.ResultDataSet: TDataSet;
begin
  Result := FQuery;
end;

{-------------------------------------------------------------------------------}
procedure TfrxEngineFD.SetSQL(const AValue: string);
begin
  FQuery.SQL.Text := AValue;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
initialization
  frxResources.Add('TfrxDataSetNotifyEvent',
    'PascalScript=(DataSet: TDataSet);' + #13#10 +
    'C++Script=(TDataSet DataSet)' + #13#10 +
    'BasicScript=(DataSet)' + #13#10 +
    'JScript=(DataSet)');
  frxResources.Add('TfrxFilterRecordEvent',
    'PascalScript=(DataSet: TDataSet; var Accept: Boolean);' + #13#10 +
    'C++Script=(TDataSet DataSet; Boolean &Accept)' + #13#10 +
    'BasicScript=(DataSet, byref Accept)' + #13#10 +
    'JScript=(DataSet, byref Accept)');

  frxObjects.RegisterObject1(TfrxFDDataBase, nil, '', {$IFDEF DB_CAT}'DATABASES'{$ELSE}''{$ENDIF}, 0, 77);
  frxObjects.RegisterObject1(TfrxFDTable, nil, '', {$IFDEF DB_CAT}'QUERIES'{$ELSE}''{$ENDIF}, 0, 78);
  frxObjects.RegisterObject1(TfrxFDQuery, nil, '', {$IFDEF DB_CAT}'QUERIES'{$ELSE}''{$ENDIF}, 0, 79);
  frxObjects.RegisterObject1(TfrxFDMemTable, nil, '', {$IFDEF DB_CAT}'QUERIES'{$ELSE}''{$ENDIF}, 0, 78);
  frxObjects.RegisterObject1(TfrxFDStoredProc, nil, '', {$IFDEF DB_CAT}'QUERIES'{$ELSE}''{$ENDIF}, 0, 80);

finalization
  frxObjects.UnRegister(TfrxFDDataBase);
  frxObjects.UnRegister(TfrxFDTable);
  frxObjects.UnRegister(TfrxFDQuery);
  frxObjects.UnRegister(TfrxFDMemTable);
  frxObjects.UnRegister(TfrxFDStoredProc);

end.
