
{******************************************}
{                                          }
{             FastReport v5.0              }
{      Property editors for Designer       }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxCustomEditors;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Classes,
  {$ENDIF}
  SysUtils, Graphics, Controls, StdCtrls, Forms, Menus,
  Dialogs, frxClass, frxDMPClass, frxDsgnIntf
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxViewEditor = class(TfrxComponentEditor)
  public
    procedure GetMenuItems; override;
    function Execute(Tag: Integer; Checked: Boolean): Boolean; override;
  end;

  TfrxCustomMemoEditor = class(TfrxViewEditor)
  public
    procedure GetMenuItems; override;
    function Execute(Tag: Integer; Checked: Boolean): Boolean; override;
  end;


implementation

uses frxEditMemo, frxEditFormat, frxEditHyperlink, frxRes;


{ TfrxViewEditor }

function TfrxViewEditor.Execute(Tag: Integer; Checked: Boolean): Boolean;
var
  i: Integer;
  c: TfrxComponent;
  v: TfrxView;
  Hyperlink: TfrxHyperlink;

  function EditHyperlink: Boolean;
  begin
    with TfrxHyperlinkEditorForm.Create(Designer) do
    begin
      View := TfrxView(Component);
      Result := ShowModal = mrOk;
      if Result then
      begin
        Hyperlink := TfrxHyperlink.Create;
        Hyperlink.Assign(View.Hyperlink);
      end;
    end;
  end;

begin
  Result := False;

  Hyperlink := nil;
  if Tag = 50 then
    if not EditHyperlink then Exit;

  for i := 0 to Designer.SelectedObjects.Count - 1 do
  begin
    c := TfrxComponent(Designer.SelectedObjects[i]);
    if (c is TfrxView) and not (rfDontModify in c.Restrictions) and (Tag in [50..54]) then
    begin
      v := TfrxView(c);
      case Tag of
        50: v.Hyperlink.Assign(Hyperlink);
        51: if Checked then
             v.ShiftMode := smAlways else
             v.ShiftMode := smDontShift;
        52: if Checked then
             v.ShiftMode := smWhenOverlapped else
             v.ShiftMode := smDontShift;
        53: v.Visible := Checked;
        54: v.Printable := Checked;
      end;

      Result := True;
    end;
  end;

  if Hyperlink <> nil then
    Hyperlink.Free;
end;

procedure TfrxViewEditor.GetMenuItems;
var
  v: TfrxView;
begin
  v := TfrxView(Component);

  AddItem(frxResources.Get('mvShift'), 51, v.ShiftMode = smAlways);
  AddItem(frxResources.Get('mvShiftOver'), 52, v.ShiftMode = smWhenOverlapped);
  AddItem(frxResources.Get('mvVisible'), 53, v.Visible);
  AddItem(frxResources.Get('mvPrintable'), 54, v.Printable);
end;


{ TfrxCustomMemoEditor }

function TfrxCustomMemoEditor.Execute(Tag: Integer; Checked: Boolean): Boolean;
var
  i: Integer;
  c: TfrxComponent;
  m: TfrxCustomMemoView;
  Formats: TfrxFormatCollection;

  function EditFormat: Boolean;
  begin
    with TfrxFormatEditorForm.Create(Designer) do
    begin
      Memo := TfrxCustomMemoView(Component);
      Result := ShowModal = mrOk;
      if Result then
      begin
        Formats := TfrxFormatCollection.Create;
        Formats.Assign(Memo.Formats);
      end;
      Free;
    end;
  end;

begin
  Result := inherited Execute(Tag, Checked);

  Formats := nil;
  if Tag = 1 then
    if not EditFormat then Exit;

  for i := 0 to Designer.SelectedObjects.Count - 1 do
  begin
    c := TfrxComponent(Designer.SelectedObjects[i]);
    if (c is TfrxCustomMemoView) and not (rfDontModify in c.Restrictions) then
    begin
      m := TfrxCustomMemoView(c);
      case Tag of
        1: m.Formats.Assign(Formats);
        2: m.Memo.Clear;
        3: m.AutoWidth := Checked;
        4: m.WordWrap := Checked;
        5: m.SuppressRepeated := Checked;
        6: m.HideZeros := Checked;
        7: m.AllowExpressions := Checked;
        8: m.AllowHTMLTags := Checked;
        40: if Checked then
             m.StretchMode := smActualHeight else
             m.StretchMode := smDontStretch;
        41: if Checked then
             m.StretchMode := smMaxHeight else
             m.StretchMode := smDontStretch;
      end;

      Result := True;
    end;
  end;

  if Formats <> nil then
    Formats.Free;
end;

procedure TfrxCustomMemoEditor.GetMenuItems;
var
  m: TfrxCustomMemoView;
begin
  m := TfrxCustomMemoView(Component);

  AddItem(frxResources.Get('mvFormat'), 1);
  AddItem(frxResources.Get('mvHyperlink'), 50);
  AddItem(frxResources.Get('mvClear'), 2);
  AddItem('-', -1);
  AddItem(frxResources.Get('mvAutoWidth'), 3, m.AutoWidth);
  AddItem(frxResources.Get('mvWWrap'), 4, m.WordWrap);
  AddItem(frxResources.Get('mvSuppress'), 5, m.SuppressRepeated);
  AddItem(frxResources.Get('mvHideZ'), 6, m.HideZeros);
  AddItem(frxResources.Get('mvExpr'), 7, m.AllowExpressions);
  if not (m is TfrxDMPMemoView) then
    AddItem(frxResources.Get('mvHTML'), 8, m.AllowHTMLTags);
  AddItem('-', -1);
  AddItem(frxResources.Get('mvStretch'), 40, m.StretchMode = smActualHeight);
  AddItem(frxResources.Get('mvStretchToMax'), 41, m.StretchMode = smMaxHeight);

  inherited;
end;


end.
