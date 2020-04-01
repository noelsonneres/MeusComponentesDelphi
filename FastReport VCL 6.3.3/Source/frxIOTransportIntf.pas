
{******************************************}
{                                          }
{             FastReport v5.0              }
{             Design interface             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxIOTransportIntf;

interface

{$I frx.inc}

uses
  SysUtils, Classes, frxClass
{$IFDEF FPC}
  ,LCLType, LazHelper, LCLProc
{$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxIOTransportItem = class(TCollectionItem)
  public
    IOTransport: TfrxCustomIOTransport;
  end;

  TfrxIOTransportsCollection = class(TCollection)
  private
    function GetIOTransportItem(Index: Integer): TfrxIOTransportItem;
  public
    constructor Create;
    procedure Register(Filter: TfrxCustomIOTransport);
    procedure Unregister(Filter: TfrxCustomIOTransport);
    property Items[Index: Integer]: TfrxIOTransportItem
      read GetIOTransportItem; default;
  end;

function frxIOTransports: TfrxIOTransportsCollection;
procedure FillItemsList(Items: TStrings; VisibleAt: TfrxFilterVisibleState);
function GetFilterDialogVisibility(CreatedFrom: TfrxFilterVisibleState): TfrxFilterVisibleState;

implementation

var
  FIOTransports: TfrxIOTransportsCollection = nil;

{ Routines }

function frxIOTransports: TfrxIOTransportsCollection;
begin
  if FIOTransports = nil then
    FIOTransports := TfrxIOTransportsCollection.Create;
  Result := FIOTransports;
end;

function GetFilterDialogVisibility(CreatedFrom: TfrxFilterVisibleState): TfrxFilterVisibleState;
begin
  Result := fvOther;
  case CreatedFrom of
    fvDesigner: Result := fvDesignerFileFilter;
    fvPreview: Result := fvPreviewFileFilter;
    fvExport: Result := fvExportFileFilter;
  end;
end;

procedure FillItemsList(Items: TStrings; VisibleAt: TfrxFilterVisibleState);
var
  i: Integer;
begin
  Items.Clear;
  Items.BeginUpdate;
  for i := 0 to frxIOTransports.Count - 1 do
    if VisibleAt in frxIOTransports.Items[i].IOTransport.Visibility  then
      Items.AddObject(frxIOTransports.Items[i].IOTransport.GetDescription, frxIOTransports.Items[i].IOTransport);
  Items.EndUpdate;
end;

{ TfrxIOTransportsCollection }

constructor TfrxIOTransportsCollection.Create;
begin
  inherited Create(TfrxIOTransportItem);
end;

function TfrxIOTransportsCollection.GetIOTransportItem(
  Index: Integer): TfrxIOTransportItem;
begin
  Result := TfrxIOTransportItem(inherited Items[Index]);
end;

procedure TfrxIOTransportsCollection.Register(Filter: TfrxCustomIOTransport);
var
  i: Integer;
  Item: TfrxIOTransportItem;
begin
  if Filter = nil then Exit;
  for i := 0 to Count - 1 do
    if Items[i].IOTransport = Filter then
      Exit;

  Item := TfrxIOTransportItem(Add);
  Item.IOTransport := Filter;
end;

procedure TfrxIOTransportsCollection.Unregister(Filter: TfrxCustomIOTransport);
var
  i: Integer;
begin
  i := 0;
  while i < Count do
  begin
    if Items[i].IOTransport = Filter then
      Items[i].Free else
      Inc(i);
  end;
end;


initialization


finalization
  if FIOTransports <> nil then
    FreeAndNil(FIOTransports);
end.
