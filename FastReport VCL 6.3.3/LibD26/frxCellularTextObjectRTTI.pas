
{******************************************}
{                                          }
{             FastReport v6.0              }
{         Celluar Text Object RTTI         }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxCellularTextObjectRTTI;

interface

{$I frx.inc}

implementation

uses
  Types, Classes, SysUtils,
  fs_iinterpreter, frxClassRTTI, frxCellularTextObject, Variants;


type
  TFunctions = class(TfsRTTIModule)
  private
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
    procedure SetProp(Instance: TObject; ClassType: TClass;
      const PropName: String; Value: Variant);
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    with AddClass(TfrxCellularText, 'TfrxCustomMemoView') do
    begin
      AddProperty('CellWidth', 'Extended', GetProp, SetProp);
      AddProperty('CellHeight', 'Extended', GetProp, SetProp);
      AddProperty('HorzSpacing', 'Extended', GetProp, SetProp);
      AddProperty('VertSpacing', 'Extended', GetProp, SetProp);
    end;
  end;
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TfrxCellularText then
  begin
    if PropName = 'CELLHEIGHT' then
      Result := TfrxCellularText(Instance).CellHeight
    else if PropName = 'CELLWIDTH' then
      Result := TfrxCellularText(Instance).CellWidth
    else if PropName = 'HORZSPACING' then
      Result := TfrxCellularText(Instance).HorzSpacing
    else if PropName = 'VERTSPACING' then
      Result := TfrxCellularText(Instance).VertSpacing;
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TfrxCellularText then
  begin
    if PropName = 'CELLHEIGHT' then
      TfrxCellularText(Instance).CellHeight := Value
    else if PropName = 'CELLWIDTH' then
      TfrxCellularText(Instance).CellWidth := Value
    else if PropName = 'HORZSPACING' then
      TfrxCellularText(Instance).HorzSpacing := Value
    else if PropName = 'VERTSPACING' then
      TfrxCellularText(Instance).VertSpacing := Value;
  end
end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  fsRTTIModules.Remove(TFunctions);

end.
