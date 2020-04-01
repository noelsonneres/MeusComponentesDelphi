
{******************************************}
{                                          }
{             FastReport v5.0              }
{           Dialog controls RTTI           }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxDCtrlRTTI;

interface

{$I frx.inc}

implementation

uses
  {$IFNDEF FPC}Windows,{$ENDIF} Types, Classes, SysUtils, Forms,
  fs_iinterpreter, fs_iformsrtti, frxDCtrl, frxClassRTTI, Variants;


type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
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
    AddClass(TfrxLabelControl, 'TfrxDialogControl');
    AddEnum('TEditCharCase', 'ecNormal, ecUpperCase, ecLowerCase');
    AddClass(TfrxEditControl, 'TfrxDialogControl');
    AddClass(TfrxMemoControl, 'TfrxDialogControl');
    AddClass(TfrxButtonControl, 'TfrxDialogControl');
    AddClass(TfrxCheckBoxControl, 'TfrxDialogControl');
    AddClass(TfrxRadioButtonControl, 'TfrxDialogControl');
    with AddClass(TfrxListBoxControl, 'TfrxDialogControl') do
      AddProperty('ItemIndex', 'Integer', GetProp, SetProp);
    AddClass(TfrxComboBoxControl, 'TfrxDialogControl');
    AddClass(TfrxDateEditControl, 'TfrxDialogControl');
    AddClass(TfrxImageControl, 'TfrxDialogControl');
    AddClass(TfrxBevelControl, 'TfrxDialogControl');
    AddClass(TfrxPanelControl, 'TfrxDialogControl');
    AddClass(TfrxGroupBoxControl, 'TfrxDialogControl');
    AddClass(TfrxBitBtnControl, 'TfrxDialogControl');
    AddClass(TfrxSpeedButtonControl, 'TfrxDialogControl');
    AddClass(TfrxMaskEditControl, 'TfrxDialogControl');
    with AddClass(TfrxCheckListBoxControl, 'TfrxDialogControl') do
    begin
      AddIndexProperty('Checked', 'Integer', 'Boolean', CallMethod);
      AddIndexProperty('State', 'Integer', 'TCheckBoxState', CallMethod);
      AddProperty('ItemIndex', 'Integer', GetProp, SetProp);
    end;

    with AddClass(TfrxPageControl, 'TfrxDialogControl') do
    begin
      AddProperty('ActivePageIndex', 'Integer', GetProp, SetProp);
      AddProperty('PageCount', 'Integer', GetProp, nil);
      AddIndexProperty('Pages', 'Integer', 'TfrxTabSheet', CallMethod);
    end;

    with AddClass(TfrxTabSheet, 'TfrxDialogControl') do
    begin
      AddProperty('PageControl', 'TfrxPageControl', GetProp, SetProp);
      AddProperty('TabIndex', 'Integer', GetProp, nil);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TfrxCheckListBoxControl then
  begin
    if MethodName = 'CHECKED.GET' then
      Result := TfrxCheckListBoxControl(Instance).Checked[Caller.Params[0]]
    else if MethodName = 'CHECKED.SET' then
      TfrxCheckListBoxControl(Instance).Checked[Caller.Params[0]] := Caller.Params[1]
    else if MethodName = 'STATE.GET' then
      Result := TfrxCheckListBoxControl(Instance).State[Caller.Params[0]]
    else if MethodName = 'STATE.SET' then
      TfrxCheckListBoxControl(Instance).State[Caller.Params[0]] := Caller.Params[1]
  end
  else if ClassType = TfrxPageControl then
  begin
    if MethodName = 'PAGES.GET' then
      Result := frxInteger(TfrxPageControl(Instance).PageControl.Pages[Caller.Params[0]])
  end;

end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TfrxListBoxControl then
  begin
    if PropName = 'ITEMINDEX' then
      Result := TfrxListBoxControl(Instance).ItemIndex
  end
  else if ClassType = TfrxCheckListBoxControl then
  begin
    if PropName = 'ITEMINDEX' then
      Result := TfrxCheckListBoxControl(Instance).ItemIndex
  end
  else if ClassType = TfrxPageControl then
  begin
    if PropName = 'ACTIVEPAGEINDEX' then
      Result := TfrxPageControl(Instance).PageControl.ActivePageIndex
    else if PropName = 'PAGECOUNT' then
      Result := TfrxPageControl(Instance).PageControl.PageCount
  end
  else if ClassType = TfrxTabSheet then
  begin
    if PropName = 'PAGECONTROL' then
      Result := frxInteger(TfrxPageControl(TfrxTabSheet(Instance).Parent))
    else if PropName = 'TABINDEX' then
      Result := TfrxTabSheet(Instance).TabSheet.TabIndex
  end;
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TfrxListBoxControl then
  begin
    if PropName = 'ITEMINDEX' then
      TfrxListBoxControl(Instance).ItemIndex := Value;
  end
  else if ClassType = TfrxCheckListBoxControl then
  begin
    if PropName = 'ITEMINDEX' then
      TfrxCheckListBoxControl(Instance).ItemIndex := Value;
  end
  else if ClassType = TfrxPageControl then
  begin
    if PropName = 'ACTIVEPAGEINDEX' then
      TfrxPageControl(Instance).PageControl.ActivePageIndex := Value
  end
  else if ClassType = TfrxTabSheet then
  begin
    if PropName = 'PAGECONTROL' then
      TfrxTabSheet(Instance).Parent := TfrxPageControl(frxInteger(Value))
  end;
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
