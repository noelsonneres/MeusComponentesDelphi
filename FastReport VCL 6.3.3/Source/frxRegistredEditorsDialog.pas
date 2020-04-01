unit frxRegistredEditorsDialog;

interface

uses
  {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, frxClass, ComCtrls, StdCtrls,
  Grids, ValEdit, TypInfo, Buttons, Menus, frxPopupForm,
  ExtCtrls, Types;

type
  TfrxRegEditorsDialog = class(TForm)
    CancelBTN: TButton;
    OkBTN: TButton;
    EditorsVL: TValueListEditor;
    ComponentsLB: TListBox;
    ComboPanel: TPanel;
    ComboBtn: TSpeedButton;
    BackPanel: TPanel;
    procedure FormShow(Sender: TObject);
    procedure ComponentsLBClick(Sender: TObject);
    procedure EditorsVLDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure VisibilityCBDrawItem(Control: TWinControl; Index: Integer;
      aRect: TRect; State: TOwnerDrawState);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditorsVLSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClick(Sender: TObject);
    procedure ComboBtnClick(Sender: TObject);
  private
    FPopupForm: TfrxPopupForm;
    FListBox: TListBox;
    FEditItem: TfrxComponentEditorVisibility;
    FEditRow: Integer;
    FRegItem: TfrxComponentEditorsRegItem;
    procedure FillComponentsList;
    procedure FillEditors;
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}


procedure TfrxRegEditorsDialog.Button1Click(Sender: TObject);
begin
  with FListBox do
  begin
{$IFNDEF FPC}
    Ctl3D := False;
{$ENDIF}
    Align := alClient;
    Style := lbOwnerDrawFixed;
    ItemHeight := 16;
//    OnClick := DoLBClick;
    OnDrawItem := VisibilityCBDrawItem;

    FPopupForm.Show;
  end;
end;

procedure TfrxRegEditorsDialog.ComboBtnClick(Sender: TObject);
begin
  FPopupForm.Show;
  ComboPanel.Enabled := False;
end;

procedure TfrxRegEditorsDialog.ComponentsLBClick(Sender: TObject);
begin
  FillEditors;
end;

procedure TfrxRegEditorsDialog.EditorsVLDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  p: TPoint;
begin
  if not((ACol = 1) and (gdSelected in State)) then Exit;
  p := Self.ClientToScreen(Point(EditorsVL.Left + Rect.Left, EditorsVL.Top + Rect.Bottom));
  FPopupForm.SetBounds(p.X, p.Y, Rect.Right - Rect.Left, FListBox.ItemHeight * FListBox.Items.Count + 2);
  ComboPanel.Left := EditorsVL.Left + Rect.Right - 16;
  ComboPanel.Top := EditorsVL.Top + Rect.Top + 3;
  ComboPanel.Visible := True;
end;

procedure TfrxRegEditorsDialog.EditorsVLSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  RegItem: TfrxComponentEditorsRegItem;
  aIndex: Integer;
begin
  aIndex := ComponentsLB.ItemIndex;
  if aIndex < 0 then Exit;
  aIndex := frxRegEditorsClasses.IndexOf(ComponentsLB.Items[aIndex]);
  if aIndex < 0 then Exit;
  RegItem := frxRegEditorsClasses.EditorsClasses[aIndex];
  FEditItem := TfrxComponentEditorVisibility(Byte(RegItem.FEditorsVisibility[ARow - 1]));
  FEditRow := ARow;
end;

procedure TfrxRegEditorsDialog.FillComponentsList;
var
  i: Integer;
begin
  ComponentsLB.Items.BeginUpdate;
  ComponentsLB.Items.Clear;
  for i := 0 to frxRegEditorsClasses.Count - 1 do
    ComponentsLB.Items.AddObject(frxRegEditorsClasses.EditorsClasses[i].FComponentClass.ClassName, frxRegEditorsClasses.EditorsClasses[i]);
  ComponentsLB.Items.EndUpdate;
end;

function GetSetDescription(Value: Integer): String;
var
  S: TIntegerSet;
  aTypeInfo: PTypeInfo;
  I: Integer;
begin
  Integer(S) := Value;
  aTypeInfo := TypeInfo(TfrxComponentEditorVisibility);
  {$IFDEF FPC}
  aTypeInfo := GetTypeData(aTypeInfo).CompType;
  {$ELSE}
  aTypeInfo := GetTypeData(aTypeInfo).CompType^;
  {$ENDIF}
  Result := '[';
  for i := 0 to 31 do
    if i in S then
    begin
      if Length(Result) <> 1 then
        Result := Result + ',';
      {$IFDEF FPC}
      Result := Result + typinfo.GetEnumName(aTypeInfo, i);
      {$ELSE}
      Result := Result + GetEnumName(aTypeInfo, i);
      {$ENDIF}
    end;
  Result := Result + ']';
end;


procedure TfrxRegEditorsDialog.FillEditors;
var
  Index, i: Integer;
 // RegItem: TfrxComponentEditorsRegItem;
  sProp: String;
  aTypeInfo: PTypeInfo;
  ptData: TTypeData;
  b: Boolean;
begin
  Index := ComponentsLB.ItemIndex;
  if Index < 0 then Exit;
  Index := frxRegEditorsClasses.IndexOf(ComponentsLB.Items[Index]);
  if Index < 0 then Exit;
  FListBox.Items.BeginUpdate;
  FListBox.Items.Clear;

  aTypeInfo := TypeInfo(TfrxComponentEditorVisibility);
  ptData := {$IFNDEF FPC}GetTypeData(GetTypeData(aTypeInfo).CompType^)^{$ELSE}
            GetTypeData(GetTypeData(aTypeInfo).CompType)^{$ENDIF};
  for i := ptData.MinValue to ptData.MaxValue do
    {$IFNDEF FPC}FListBox.Items.AddObject(GetEnumName(GetTypeData(aTypeInfo).CompType^, i), TObject(i)){$ELSE}
    FListBox.Items.AddObject(GetEnumName(GetTypeData(aTypeInfo).CompType, i), TObject(i)){$ENDIF};

  FListBox.Items.EndUpdate;

  EditorsVL.Strings.BeginUpdate;
  EditorsVL.Strings.Clear;
  FRegItem := frxRegEditorsClasses.EditorsClasses[Index];
  for i := 0 to FRegItem.FEditorsGlasses.Count - 1 do
  begin
    sProp := GetSetDescription(Byte(FRegItem.FEditorsVisibility[i]));
    //GetSetElementName(TypeInfo(TfrxComponentEditorVisibility), Integer(RegItem.FEditorsVisibility[i]));
    EditorsVL.InsertRow(TfrxInPlaceEditorClass(FRegItem.FEditorsGlasses[i]).ClassName, sProp, True);
  end;
  EditorsVL.Strings.EndUpdate;
  EditorsVLSelectCell(nil, 1, 1, b);
end;

procedure TfrxRegEditorsDialog.FormClick(Sender: TObject);
var
  Index: Integer;
begin
//
  Index := FListBox.ItemIndex;
  if index = -1 then Exit;

  if TfrxComponentEditorVisibilityState(FListBox.Items.Objects[Index]) in FEditItem then
    Exclude(FEditItem, TfrxComponentEditorVisibilityState(FListBox.Items.Objects[Index]))
  else
    Include(FEditItem, TfrxComponentEditorVisibilityState(FListBox.Items.Objects[Index]));
  FListBox.Repaint;
end;

procedure TfrxRegEditorsDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 ComboPanel.Enabled := True;
 if FEditRow <= 0 then Exit;
 FRegItem.FEditorsVisibility[FEditRow - 1] := TObject(Byte(FEditItem));
 FillEditors;
 EditorsVL.Repaint;
end;

procedure TfrxRegEditorsDialog.FormCreate(Sender: TObject);
begin
  FPopupForm := TfrxPopupForm.Create(Self);
  FListBox := TListBox.Create(FPopupForm);
  with FListBox do
  begin
    Parent := FPopupForm;
{$IFNDEF FPC}
    Ctl3D := False;
{$ENDIF}
    Align := alClient;
    Style := lbOwnerDrawFixed;
    ItemHeight := 16;
//    OnClick := DoLBClick;
    OnDrawItem := VisibilityCBDrawItem;
    OnClick := FormClick;
  end;
  FPopupForm.OnClose := FormClose;
end;

procedure TfrxRegEditorsDialog.FormShow(Sender: TObject);
begin
  FillComponentsList;
  ComponentsLB.ItemIndex := 0;
  FillEditors;
end;

procedure TfrxRegEditorsDialog.VisibilityCBDrawItem(Control: TWinControl;
  Index: Integer; aRect: TRect; State: TOwnerDrawState);
var
  add: Integer;
begin
  FListBox.Canvas.FillRect(aRect);
  with FListBox.Canvas do
  begin
    Rectangle(ARect.Left + 2, ARect.Top + 2, ARect.Left + (ARect.Bottom - ARect.Top - 3), ARect.Bottom - 1);
    Pen.Color := clBlack;
    if Screen.PixelsPerInch > 96 then
      add := 2
    else
      add := 0;
    if TfrxComponentEditorVisibilityState(FListBox.Items.Objects[Index]) in FEditItem then
      with ARect do
      begin
        PolyLine([Point(Left + 4 + add, Top + 6 + add), Point(Left + 6 + add, Top + 8 + add), Point(Left + 11 + add, Top + 3 + add)]);
        PolyLine([Point(Left + 4 + add, Top + 7 + add), Point(Left + 6 + add, Top + 9 + add), Point(Left + 11 + add, Top + 4 + add)]);
        PolyLine([Point(Left + 4 + add, Top + 8 + add), Point(Left + 6 + add, Top + 10 + add), Point(Left + 11 + add, Top + 5 + add)]);
      end;
  end;
  FListBox.Canvas.TextOut(aRect.Left + 20, aRect.Top + 1, FListBox.Items[Index]);
end;

end.
