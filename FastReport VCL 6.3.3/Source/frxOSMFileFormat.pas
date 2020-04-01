
{******************************************}
{                                          }
{             FastReport v5.0              }
{           Open Street Map File           }
{                                          }
{            Copyright (c) 2016            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxOSMFileFormat;

{$I frx.inc}

interface

uses
  frxXML, Classes, frxMapHelpers, frxAnaliticGeometry;

type
  TOSMNode = class(TTaggedElement)
  private
    FLatitude: Double;
    FLongitude: Double;
  protected
  public
    constructor Create(Lat, Lon: Double);

    property Latitude: Double read FLatitude;
    property Longitude: Double read FLongitude;
  end;

  TOSMWay = class(TTaggedElement)
  private
    function GetCount: integer;
    function GetShapeType: TShapeType;
    function GetNodes(Index: Integer): String;
  protected
    FNodeRefs: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddNodeRef(const stNodeRef: String);

    property Count: integer read GetCount;
    property ShapeType: TShapeType read GetShapeType;
    property NodeRefs[Index: Integer]: String read GetNodes;
  end;

  TOSMFile = class
  private
    FXmin: Double;
    FYmin: Double;
    FXmax: Double;
    FYmax: Double;
    function GetCountOfNodes: Integer;
    function GetCountOfWays: Integer;
    function GetWays(Index: integer): TOSMWay;
    function GetNodes(Index: integer): TOSMNode;
  protected
    FOSMNodes: TStringList;
    FOSMWays: TStringList;
    FSumTags: TfrxSumStringList;

    procedure Load(const FileName: string);
    procedure LoadBounds(XMLItem: TfrxXMLItem);
    procedure LoadNode(XMLItem: TfrxXMLItem);
    procedure LoadWay(XMLItem: TfrxXMLItem);
    procedure ParseItem(XMLItem: TfrxXMLItem);
    function ValidUTF8(st: String): String;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    function IsGetNodeAsPoint(const iWay, iNode: integer; out DP: TDoublePoint): boolean;

    property Xmin: Double read FXmin;
    property Ymin: Double read FYmin;
    property Xmax: Double read FXmax;
    property Ymax: Double read FYmax;

    property CountOfWays: Integer read GetCountOfWays;
    property Ways[Index: integer]: TOSMWay read GetWays;
    property CountOfNodes: Integer read GetCountOfNodes;
    property Nodes[Index: integer]: TOSMNode read GetNodes;

    property SumTags: TfrxSumStringList read FSumTags;
  end;

implementation

uses
  SysUtils, Math, frxUtils;

{ TOSMFile }

constructor TOSMFile.Create(const FileName: string);
begin
  FOSMNodes := TStringList.Create;
  FOSMWays := TStringList.Create;
  FSumTags := TfrxSumStringList.Create;

  Load(FileName);

  FOSMNodes.Sorted := True;
end;

destructor TOSMFile.Destroy;
  procedure FreeWithObjects(var StringList: TStringList);
  var
    i: Integer;
  begin
    for i := 0 to StringList.Count - 1 do
      StringList.Objects[i].Free;
    StringList.Free;
  end;
begin
  FreeWithObjects(FOSMNodes);
  FreeWithObjects(FOSMWays);

  FreeAndNil(FSumTags);

  inherited;
end;

function TOSMFile.GetCountOfNodes: Integer;
begin
  Result := FOSMNodes.Count;
end;

function TOSMFile.GetCountOfWays: Integer;
begin
  Result := FOSMWays.Count;
end;

function TOSMFile.GetNodes(Index: integer): TOSMNode;
begin
  Result := TOSMNode(FOSMNodes.Objects[Index]);
end;

function TOSMFile.GetWays(Index: integer): TOSMWay;
begin
  Result := TOSMWay(FOSMWays.Objects[Index]);
end;

function TOSMFile.IsGetNodeAsPoint(const iWay, iNode: integer; out DP: TDoublePoint): boolean;
var
  NodeIndex: Integer;
  Node: TOSMNode;
begin
  Result := FOSMNodes.Find(Ways[iWay].NodeRefs[iNode], NodeIndex);
  if Result then
  begin
    Node := Nodes[NodeIndex];
    DP := DoublePoint(Node.Longitude, Node.Latitude);
  end;
end;

procedure TOSMFile.Load(const FileName: string);
var
  MapXMLDocument: TfrxMapXMLDocument;
  Item: TfrxXMLItem;
begin
  Item := nil;
  MapXMLDocument := TfrxMapXMLDocument.Create;
  try
    MapXMLDocument.InitMapXMLFile(FileName);
    repeat
      Item := TfrxXMLItem.Create;
      if MapXMLDocument.IsReadItem(Item) then
        ParseItem(Item)
      else
        Break;
      Item.Free;
    until False;
  finally
    Item.Free;
    MapXMLDocument.DoneMapXMLFile;
    MapXMLDocument.Free;
  end;
end;

procedure TOSMFile.LoadBounds(XMLItem: TfrxXMLItem);
begin
  FXmin := frxStrToFloat(XMLItem.Prop['minlon']);
  FYmin := frxStrToFloat(XMLItem.Prop['minlat']);
  FXmax := frxStrToFloat(XMLItem.Prop['maxlon']);
  FYmax := frxStrToFloat(XMLItem.Prop['maxlat']);
end;

procedure TOSMFile.LoadNode(XMLItem: TfrxXMLItem);
var
  id: String;
  lat, lon: Double;
  OSMNode: TOSMNode;
  loName: String;
  i: Integer;
begin
  id := XMLItem.Prop['id'];
  lat := frxStrToFloat(XMLItem.Prop['lat']);
  lon := frxStrToFloat(XMLItem.Prop['lon']);
  OSMNode := TOSMNode.Create(lat, lon);
  for i := 0 to XMLItem.Count - 1 do
    with XMLItem.Items[i] do
    begin
      loName := AnsiLowerCase(Name);
      if loName = 'tag' then
      begin
        OSMNode.AddTag(ValidUTF8(Prop['k']), ValidUTF8(Prop['v']));
        SumTags.AddSum(ValidUTF8(Prop['k']));
      end;
    end;
  FOSMNodes.AddObject(id, OSMNode);
end;

procedure TOSMFile.LoadWay(XMLItem: TfrxXMLItem);
var
  id: String;
  OSMWay: TOSMWay;
  loName: String;
  i: Integer;
begin
  id := XMLItem.Prop['id'];
  OSMWay := TOSMWay.Create;
  for i := 0 to XMLItem.Count - 1 do
    with XMLItem.Items[i] do
    begin
      loName := AnsiLowerCase(Name);
      if      loName = 'nd' then
        OSMWay.AddNodeRef(Prop['ref'])
      else if loName = 'tag' then
      begin
        OSMWay.AddTag(ValidUTF8(Prop['k']), ValidUTF8(Prop['v']));
        SumTags.AddSum(ValidUTF8(Prop['k']));
      end;
    end;
  FOSMWays.AddObject(id, OSMWay);
end;

procedure TOSMFile.ParseItem(XMLItem: TfrxXMLItem);
var
  loName: String;
begin
  loName := AnsiLowerCase(XMLItem.Name);
  if      loName = 'bounds' then   LoadBounds(XMLItem)
  else if loName = 'node' then     LoadNode(XMLItem)
  else if loName = 'way' then      LoadWay(XMLItem)
  else if loName = 'relation' then { TODO : Skipped for now};
end;

function TOSMFile.ValidUTF8(st: String): String;
begin
  Result := {$IFDEF DELPHI12} st;
            {$ELSE}           UTF8Decode(AnsiString(st));
            {$ENDIF}
end;

{ TOSMNode }

constructor TOSMNode.Create(Lat, Lon: Double);
begin
  inherited Create;

  FLatitude := Lat;
  FLongitude := Lon;
end;

{ TOSMWay }

procedure TOSMWay.AddNodeRef(const stNodeRef: String);
begin
  FNodeRefs.Add(stNodeRef);
end;

constructor TOSMWay.Create;
begin
  inherited Create;

  FNodeRefs := TStringList.Create;
end;

destructor TOSMWay.Destroy;
begin
  FNodeRefs.Free;

  inherited;
end;

function TOSMWay.GetCount: integer;
begin
  Result := FNodeRefs.Count;
end;

function TOSMWay.GetNodes(Index: Integer): String;
begin
  Result := FNodeRefs[Index];
end;

function TOSMWay.GetShapeType: TShapeType;
begin
  if      Count = 1 then                           Result := stPoint
  else if FNodeRefs[0] = FNodeRefs[Count - 1] then Result := stPolygon
  else                                             Result := stPolyLine;
end;

end.
