
{******************************************}
{                                          }
{             FastReport v6.0              }
{                Map Editor                }
{                                          }
{        Copyright (c) 2015 - 2018         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapInPlaceEditor;

interface

{$I frx.inc}

uses
  Types,
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType, LCLIntf, LCLProc,
{$ENDIF}
  Classes, Graphics, frxClass;

implementation

uses
  frxMap, frxInPlaceEditors;

  type
  TfrxInPlaceMapEditor = class(TfrxInPlaceBasePanelEditor)
  protected
    function GetItem(Index: Integer): Boolean; override;
    procedure SetItem(Index: Integer; const Value: Boolean); override;
    function Count: Integer; override;
    function GetName(Index: Integer): String; override;
    function GetColor(Index: Integer): TColor; override;
  end;

{ TfrxInPlaceChartEditor }

function TfrxInPlaceMapEditor.Count: Integer;
begin
  Result := 0;
  if FComponent is TfrxMapView then
    Result := TfrxMapView(FComponent).Layers.Count;
end;

function TfrxInPlaceMapEditor.GetColor(Index: Integer): TColor;
begin
  Result := clWhite;
  if FComponent is TfrxMapView then
    Result := TColor(RGB((Index + 1) * 50 mod 255, Index *50 mod 255, 255));
end;

function TfrxInPlaceMapEditor.GetItem(Index: Integer): Boolean;
begin
  Result := False;
  if FComponent is TfrxMapView then
    Result := TfrxMapView(FComponent).Layers[Index].Active;
end;

function TfrxInPlaceMapEditor.GetName(Index: Integer): String;
begin
  Result := '';
  if FComponent is TfrxMapView then
    Result := TfrxMapView(FComponent).Layers[Index].Name;
end;

procedure TfrxInPlaceMapEditor.SetItem(Index: Integer; const Value: Boolean);
begin
  if FComponent is TfrxMapView then
    TfrxMapView(FComponent).Layers[Index].Active := Value;
end;

initialization
  frxRegEditorsClasses.Register(TfrxMapView, [TfrxInPlaceMapEditor], [[evPreview]]);

end.
