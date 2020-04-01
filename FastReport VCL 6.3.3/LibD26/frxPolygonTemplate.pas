
{******************************************}
{                                          }
{             FastReport v6.0              }
{             Poligon Template             }
{                                          }
{            Copyright (c) 2018            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxPolygonTemplate;

interface

{$I frx.inc}

uses
  SysUtils, Contnrs, Graphics,
  frxJSON, frxMapHelpers, frxAnaliticGeometry;

type
  TPointIndexByName = class
  private
    function GetIndexByName(Name: String): Integer;
    function GetNameBitmap(Index: Integer): TBitmap;
  protected
    FPointName: array of String;
    FNameBitmap: array of TBitmap;
  public
    constructor Create(JSON: TObject);
    destructor Destroy; override;
    function Count: Integer;

    property IndexByName[Name: String]: Integer read GetIndexByName;
    property NameBitmap[Index: Integer]: TBitmap read GetNameBitmap;
  end;

  TAbstractTemplateComponent = class
  protected
    FPointIndex: array of Integer;
    FPointIndexByName: TPointIndexByName; // Pointer to paren object
  public
    constructor Create(JSON: TfrxJSON; PointIndexByName: TPointIndexByName);
    procedure Draw(Canvas: TCanvas; Points: TPointArray); virtual; abstract;
  end;

  TTemplateComponentList = class(TObjectList)
  private
    function GetItems(Index: Integer): TAbstractTemplateComponent;
    procedure SetItems(Index: Integer; const Value: TAbstractTemplateComponent);
  public
    constructor Create;

    property Items[Index: Integer]: TAbstractTemplateComponent read GetItems write SetItems; default;
  end;

  TfrxPolygonTemplate = class
  private
    FName: String;
    FCount: Integer;
  protected
    FPointIndexByName: TPointIndexByName;
    FTemplateComponentList: TTemplateComponentList;
  public
    constructor Create(JSON: TfrxJSON);
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; Points: TPointArray; DrawNames: Boolean = False);
    procedure DrawWithNames(Canvas: TCanvas; Points: TPointArray);
    procedure LoadArray(JSON: TfrxJSON; nm: String);

    property Name: String read FName;
    property Count: Integer read FCount;
  end;

  TfrxPolygonTemplateList = class(TObjectList)
  private
    function GetTemplate(Index: Integer): TfrxPolygonTemplate;
    procedure SetTemplate(Index: Integer; const Value: TfrxPolygonTemplate);
    function GetItemsByName(Name: String): TfrxPolygonTemplate;
  protected
    FVersion: Integer;
  public
    constructor Create(FileName: TFileName);

    property Items[Index: Integer]: TfrxPolygonTemplate read GetTemplate write SetTemplate; default;
    property ItemsByName[Name: String]: TfrxPolygonTemplate read GetItemsByName;
  end;

var
  PolygonTemplateList: TfrxPolygonTemplateList;

implementation

uses
  Classes, Math, Types;

const
  PatternFileName = 'Patterns.json';

type
  TLineTemplateComponent = class(TAbstractTemplateComponent)
  protected
    FWidth: Integer;
  public
    constructor Create(JSON: TfrxJSON; PointIndexByName: TPointIndexByName);
    procedure Draw(Canvas: TCanvas; Points: TPointArray); override;
  end;

  TPolygonTemplateComponent = class(TLineTemplateComponent)
  protected
    FFill: Boolean;
    FMaxIndex: Integer;
  public
    constructor Create(JSON: TfrxJSON; PointIndexByName: TPointIndexByName);
    procedure Draw(Canvas: TCanvas; Points: TPointArray); override;
  end;

const
  nmNameless = 'Nameless';
  nmVersion = 'version';
  nmItems = 'items';
  nmName = 'name';
  nmPoints = 'points';
  nmLines = 'lines';
  nmWidth = 'width';
  nmPolygons = 'polygons';
  nmFill = 'fill';

{ TfrxPoligonTemplate }

constructor TfrxPolygonTemplateList.Create(FileName: TFileName);
var
  SL: TStringList;
  JSON, Item: TfrxJSON;
  Items: TfrxJSONArray;
  i: Integer;
begin
  inherited Create;
  OwnsObjects := True;

  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    JSON := TfrxJSON.Create(SL.Text);
    if JSON.IsValid then
    begin
      if JSON.IsNameExists(nmVersion) then
        FVersion := StrToInt(JSON.ValueByName(nmVersion))
      else
        FVersion := 0;
      Items := TfrxJSONArray.Create(JSON.ObjectByName(nmItems));
      for i := 0 to Items.Count - 1 do
      begin
        Item := Items.Get(i);
        Add(TfrxPolygonTemplate.Create(Item));
        Item.Free;
      end;
      Items.Free;
    end;
    JSON.Free;
  finally
    SL.Free;
  end;
end;

function TfrxPolygonTemplateList.GetItemsByName(Name: String): TfrxPolygonTemplate;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].Name = Name then
    begin
      Result := Items[i];
      Break;
    end;
end;


function TfrxPolygonTemplateList.GetTemplate(Index: Integer): TfrxPolygonTemplate;
begin
  Result := (inherited Items[Index]) as TfrxPolygonTemplate;
end;

procedure TfrxPolygonTemplateList.SetTemplate(Index: Integer; const Value: TfrxPolygonTemplate);
begin
  inherited Items[Index] := Value;
end;

{ TfrxPolygonTemplate }

constructor TfrxPolygonTemplate.Create(JSON: TfrxJSON);
begin
  if JSON.IsNameExists(nmName) then
    FName := JSON.ValueByName(nmName)
  else
    FName := nmNameless;

  FPointIndexByName := TPointIndexByName.Create(JSON.ObjectByName(nmPoints));
  FCount := FPointIndexByName.Count;

  FTemplateComponentList := TTemplateComponentList.Create;

  LoadArray(JSON, nmLines);
  LoadArray(JSON, nmPolygons);
end;

destructor TfrxPolygonTemplate.Destroy;
begin
  FPointIndexByName.Free;
  FTemplateComponentList.Free;
  inherited;
end;

procedure TfrxPolygonTemplate.Draw(Canvas: TCanvas; Points: TPointArray; DrawNames: Boolean = False);
var
  iComponent, iPoint: Integer;
begin
  for iComponent := 0 to FTemplateComponentList.Count - 1 do
    FTemplateComponentList[iComponent].Draw(Canvas, Points);

  if DrawNames then
  begin
    Canvas.CopyMode := cmSrcInvert;
    for iPoint := 0 to High(Points) do
      with Points[iPoint] do
        Canvas.Draw(X, Y, FPointIndexByName.NameBitmap[iPoint]);
  end;
end;

procedure TfrxPolygonTemplate.DrawWithNames(Canvas: TCanvas; Points: TPointArray);
begin
  Draw(Canvas, Points, True);
end;

procedure TfrxPolygonTemplate.LoadArray(JSON: TfrxJSON; nm: String);
var
  i: Integer;
  JSONArray: TfrxJSONArray;
  Item: TfrxJSON;
begin
  if JSON.IsNameExists(nm) then
  begin
    JSONArray := TfrxJSONArray.Create(JSON.ObjectByName(nm));
    for i := 0 to JSONArray.Count - 1 do
    begin
      Item := JSONArray.Get(i);
      if nm = nmLines then
        FTemplateComponentList.Add(TLineTemplateComponent.Create(Item, FPointIndexByName))
      else if nm = nmPolygons then
        FTemplateComponentList.Add(TPolygonTemplateComponent.Create(Item, FPointIndexByName));
      Item.Free;
    end;
    JSONArray.Free;
  end;
end;

{ TPointIndexByName }

function TPointIndexByName.Count: Integer;
begin
  Result := Length(FPointName);
end;

constructor TPointIndexByName.Create(JSON: TObject);
const
  NameIndent = 4;
var
  JSONArray: TfrxJSONArray;
  i: Integer;
begin
  JSONArray := TfrxJSONArray.Create(JSON);
  SetLength(FPointName, JSONArray.Count);
  SetLength(FNameBitmap, JSONArray.Count);
  for i := Low(FPointName) to High(FPointName) do
  begin
    FPointName[i] := JSONArray.GetString(i);

    FNameBitmap[i] := TBitMap.Create;
    with FNameBitmap[i] do
    begin
      Width := Canvas.TextWidth(FPointName[i]) + 2 * NameIndent;
      Height := Canvas.TextHeight(FPointName[i]) + 2 * NameIndent;
      Canvas.TextOut(NameIndent, NameIndent, FPointName[i]);
    end;
  end;

  JSONArray.Free;
end;

destructor TPointIndexByName.Destroy;
var
  i: Integer;
begin
  for i := Low(FPointName) to High(FPointName) do
    FNameBitmap[i].Free;

  inherited;
end;

function TPointIndexByName.GetIndexByName(Name: String): Integer;
var
  i: Integer;
begin
  Result := UnKnown;
  for i := Low(FPointName) to High(FPointName) do
    if FPointName[i] = Name then
    begin
      Result := i;
      Break;
    end;
end;

function TPointIndexByName.GetNameBitmap(Index: Integer): TBitmap;
begin
  Result := FNameBitmap[Index];
end;

{ TTemplateComponentList }

constructor TTemplateComponentList.Create;
begin
  inherited;
  OwnsObjects := True;
end;

function TTemplateComponentList.GetItems(Index: Integer): TAbstractTemplateComponent;
begin
  Result := (inherited Items[Index]) as TAbstractTemplateComponent;
end;

procedure TTemplateComponentList.SetItems(Index: Integer; const Value: TAbstractTemplateComponent);
begin
  inherited Items[Index] := Value;
end;

{ TAbstractTemplateComponent }

constructor TAbstractTemplateComponent.Create(JSON: TfrxJSON; PointIndexByName: TPointIndexByName);
var
  JSONArray: TfrxJSONArray;
  i: Integer;
begin
  JSONArray := TfrxJSONArray.Create(JSON.ObjectByName(nmPoints));
  SetLength(FPointIndex, JSONArray.Count);
  for i := 0 to JSONArray.Count - 1 do
    FPointIndex[i] := PointIndexByName.IndexByName[JSONArray.GetString(i)];
  JSONArray.Free;

  FPointIndexByName := PointIndexByName;
end;

{ TLineTemplateComponent }

constructor TLineTemplateComponent.Create(JSON: TfrxJSON; PointIndexByName: TPointIndexByName);
begin
  inherited Create(JSON, PointIndexByName);

  FWidth := StrToInt(JSON.ValueByName(nmWidth));
end;

procedure TLineTemplateComponent.Draw(Canvas: TCanvas; Points: TPointArray);
var
  i: Integer;
begin
  Canvas.Pen.Width := FWidth;
  for i := 0 to High(FPointIndex) - 1 do
    if (FPointIndex[i] <= High(Points)) and (FPointIndex[i + 1] <= High(Points)) then
    begin
      with Points[FPointIndex[i]] do
        Canvas.MoveTo(X, Y);
      with Points[FPointIndex[i + 1]] do
        Canvas.LineTo(X, Y);
    end;
end;

{ TPolygonTemplateComponent }

constructor TPolygonTemplateComponent.Create(JSON: TfrxJSON; PointIndexByName: TPointIndexByName);
begin
  inherited Create(JSON, PointIndexByName);

  FFill := JSON.IsNameExists(nmFill) and StrToBool(JSON.ValueByName(nmFill));

  if not FFill and (FPointIndex[0] <> FPointIndex[High(FPointIndex)]) then
  begin
    SetLength(FPointIndex, Length(FPointIndex) + 1);
    FPointIndex[High(FPointIndex)] := FPointIndex[0];
  end;

  FMaxIndex := MaxIntValue(FPointIndex);
end;

procedure TPolygonTemplateComponent.Draw(Canvas: TCanvas; Points: TPointArray);
var
  i: Integer;
  LP: TPointArray;
begin
  if FFill and (High(Points) >= FMaxIndex) then
  begin
    SetLength(LP, Length(FPointIndex));
    for i := 0 to High(LP) do
      LP[i] := Points[FPointIndex[i]];
    Canvas.Polygon(LP);
  end
  else
    inherited Draw(Canvas, Points);
end;

initialization

  if FileExists(ExtractFilePath(ParamStr(0)) + PatternFileName) then
    PolygonTemplateList := TfrxPolygonTemplateList.Create(PatternFileName)
  else
    PolygonTemplateList := nil;

finalization

  PolygonTemplateList.Free;

end.
