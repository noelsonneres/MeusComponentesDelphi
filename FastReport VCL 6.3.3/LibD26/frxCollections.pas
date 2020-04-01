unit frxCollections;

interface

{$I frx.inc}

uses
  SysUtils, {$IFNDEF FPC}Windows, Messages,{$ENDIF} Classes;

type

  { TfrxCollectionItem }

  TfrxCollectionItem = class(TCollectionItem)
  protected
    FUniqueIndex: Integer;
    FIsInherited: Boolean;
    function GetInheritedName: String; virtual;
    procedure SetInheritedName(const Value: String); virtual;
  public
    constructor Create(ACollection: TCollection); override;
    procedure CreateUniqueIName(ACollection: TCollection);
    function IsUniqueNameStored: Boolean; virtual;
    property IsInherited: Boolean read FIsInherited write FIsInherited;
    property InheritedName: String read GetInheritedName write SetInheritedName;
    property UniqueIndex: Integer read FUniqueIndex write FUniqueIndex;
  end;

{$WARNINGS OFF}
  TfrxCollection = class(TCollection)
  public
    procedure SerializeProperties(Writer: TObject; Ancestor: TfrxCollection; Owner: TComponent); virtual;
    procedure DeserializeProperties(PropName: String; Reader: TObject; Ancestor: TfrxCollection); virtual;
    function FindByName(Name: String): TfrxCollectionItem; virtual;
  end;
{$WARNINGS ON}

implementation

uses frxXMLSerializer;

{ TfrxCollectionItem }

{ TODO: Make sorted regions list for indexes }
{ shold be enough for simple collections }
constructor TfrxCollectionItem.Create(ACollection: TCollection);
begin
  if IsUniqueNameStored then
    CreateUniqueIName(ACollection);
  inherited;
end;

procedure TfrxCollectionItem.CreateUniqueIName(ACollection: TCollection);
var
  i, nMax, nMin: Integer;
  Item: TfrxCollectionItem;
begin
  nMin := MaxInt;
  nMax := 1;
  for i := 0 to ACollection.Count - 1 do
  begin
    Item := TfrxCollectionItem(ACollection.Items[i]);
    if nMin > Item.FUniqueIndex then
      nMin := Item.FUniqueIndex;
    if nMax < Item.FUniqueIndex then
      nMax := Item.FUniqueIndex;
  end;

  if nMin > 1 then
    FUniqueIndex := 1
  else
    FUniqueIndex := nMax + 1;
end;

function TfrxCollectionItem.GetInheritedName: String;
begin
  Result := 'frxUIN' + IntToStr(FUniqueIndex);
end;

function TfrxCollectionItem.IsUniqueNameStored: Boolean;
begin
  Result := False;
end;

procedure TfrxCollectionItem.SetInheritedName(const Value: String);
begin
  // do nothing
end;

{ TfrxCollection }

procedure TfrxCollection.DeserializeProperties(PropName: String;
  Reader: TObject; Ancestor: TfrxCollection);
begin

end;

function TfrxCollection.FindByName(Name: String): TfrxCollectionItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if TfrxCollectionItem(Items[i]).InheritedName = Name then
    begin
      Result := TfrxCollectionItem(Items[i]);
      Exit;
    end;
end;

procedure TfrxCollection.SerializeProperties(Writer: TObject;
  Ancestor: TfrxCollection; Owner: TComponent);
begin
end;

end.
