unit frxLazBWForm;

{$I frx.inc}

interface

uses
  SysUtils, Classes,  Graphics,  LCLType, FileUtil, Forms, Controls, Dialogs, ExtCtrls,
  ComCtrls, CheckLst, StdCtrls,
  fs_iinterpreter, frxSynMemo, Variants, Grids;

type

  { TfrxBWForm }

  TfrxBWForm = class(TForm)
    BreakPGR: TStringGrid;
    DeleteB: TToolButton;
    EditB: TToolButton;
    EditBtn: TButton;
    pnlB: TPanel;
    tlbB: TToolBar;
    ToggleEnableB: TToolButton;
    WatchLB: TStringGrid;
    WatchLBCB: TCheckListBox;
    pnlW: TPanel;
    splBW: TSplitter;
    ListTB: TTabControl;
    tlbW: TToolBar;
    AddW: TToolButton;
    DeleteW: TToolButton;
    EditW: TToolButton;
    procedure AddBClick(Sender: TObject);
    procedure AddWClick(Sender: TObject);
    procedure BreakPGRDblClick(Sender: TObject);
    procedure BreakPGRDrawCell(Sender: TObject; aCol, aRow: Integer;
      Rect: TRect; aState: TGridDrawState);
    procedure DeleteBClick(Sender: TObject);
    procedure DeleteWClick(Sender: TObject);
    procedure EditBClick(Sender: TObject);
    procedure EditWClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListTBChange(Sender: TObject);
    procedure pnlBResize(Sender: TObject);
    procedure pnlWResize(Sender: TObject);
    procedure ToggleEnableBClick(Sender: TObject);
    procedure WatchLBCBClickCheck(Sender: TObject);
  private
    FScript: TfsScript;
    FScriptRunning: Boolean;
    FSynMemo: TfrxSyntaxMemo;
    FWatches: TStrings;
    procedure SetSynMemo(const Value: TfrxSyntaxMemo);
    procedure BPListUpdated(Sender: TObject);
    function CalcWatch(const s: String): String;
  public
    destructor Destroy; override;
    procedure UpdateList;
    procedure UpdateWatches;
    property Script: TfsScript read FScript write FScript;
    property ScriptRunning: Boolean read FScriptRunning write FScriptRunning;
    property Watches: TStrings read FWatches;
    property SynMemo: TfrxSyntaxMemo read FSynMemo write SetSynMemo;
  end;

var
  frxBWForm: TfrxBWForm;

implementation

uses frxRes, frxEvaluateForm, Math;

{$R *.lfm}

{ TfrxBWForm }

procedure TfrxBWForm.FormCreate(Sender: TObject);
begin
  DeleteB.Hint := frxGet(5902);
  EditB.Hint := frxGet(5903);
  BreakPGR.BorderStyle := bsSingle;
  AddW.Hint := frxGet(5901);
  DeleteW.Hint := frxGet(5902);
  EditW.Hint := frxGet(5903);
  ListTB.Tabs[0] := frxGet(6591);
  ListTB.Tabs[1] := frxGet(6592);
  FWatches := TStringList.Create;
  WatchLB.Cells[0, 0] := frxResources.Get('qpName');
  WatchLB.Cells[1, 0] := frxGet(3002);
  WatchLB.Cells[2, 0] := frxResources.Get('qpValue');
  WatchLBCB.BorderStyle := bsSingle;
  if UseRightToLeftAlignment then
    FlipChildren(True);
end;

procedure TfrxBWForm.AddBClick(Sender: TObject);
begin
  if FSynMemo = nil then Exit;
  FSynMemo.AddNewBreakPoint;
  UpdateList;
end;

procedure TfrxBWForm.AddWClick(Sender: TObject);
begin
  with TfrxEvaluateForm.Create(Owner) do
  begin
    IsWatch := True;
    if ShowModal = mrOk then
    begin
      //Watches.Add(ExpressionE.Text);
      Watches.AddObject(ExpressionE.Text, TObject(1));
      UpdateWatches;
    end;
    Free;
  end;
end;

procedure TfrxBWForm.BreakPGRDblClick(Sender: TObject);
begin
  if BreakPGR.Selection.Left > 0 then Exit;
  ToggleEnableBClick(nil);
end;

procedure TfrxBWForm.BreakPGRDrawCell(Sender: TObject; aCol, aRow: Integer;
  Rect: TRect; aState: TGridDrawState);
var
  BP: TfrxBreakPoint;
begin
  if ACol > 0 then Exit;
  BP := TfrxBreakPoint(BreakPGR.Objects[ACol, ARow]);
  if BP = nil then Exit;
  //BreakPGR.Canvas.Brush.Color := BreakPGR.Color;
  //BreakPGR.Canvas.FillRect(Rect);
  if BP.Enabled then
  begin
    BreakPGR.Canvas.Brush.Color := $005353FF;
    BreakPGR.Canvas.Pen.Color := clRed;
  end
  else
  begin
    BreakPGR.Canvas.Brush.Color := clGray;
    BreakPGR.Canvas.Pen.Color := clBlack;
  end;
 BreakPGR.Canvas.Ellipse(Rect.Left + 2, Rect.Top + 3, Rect.Left + 13, Rect.Top +  14);
end;

procedure TfrxBWForm.DeleteBClick(Sender: TObject);
var
  BP: TfrxBreakPoint;
begin
 if BreakPGR.Selection.Top < 1 then Exit;
 BP := TfrxBreakPoint(BreakPGR.Objects[0, BreakPGR.Selection.Top]);
 if BP = nil then Exit;
  if FSynMemo = nil then Exit;
  FSynMemo.DeleteBreakPoint(BP.Line);
  UpdateList;
  FSynMemo.Invalidate;
end;

procedure TfrxBWForm.DeleteWClick(Sender: TObject);
begin
  if WatchLBCB.ItemIndex <> -1 then
  begin
    Watches.Delete(WatchLBCB.ItemIndex);
    UpdateWatches;
  end;
end;

procedure TfrxBWForm.EditBClick(Sender: TObject);
var
  BP: TfrxBreakPoint;
begin
 if BreakPGR.Selection.Top < 1 then Exit;
 BP := TfrxBreakPoint(BreakPGR.Objects[0, BreakPGR.Selection.Top]);
 if BP = nil then Exit;
 BP.Condition := InputBox(frxGet(6587), frxGet(6588), BP.Condition);
 BreakPGR.Cells[2, BreakPGR.Selection.Top] := BP.Condition;
 BreakPGR.Invalidate;
end;

procedure TfrxBWForm.EditWClick(Sender: TObject);
begin
 if WatchLBCB.ItemIndex <> -1 then
   with TfrxEvaluateForm.Create(Owner) do
   begin
     IsWatch := True;
     ExpressionE.Text := Watches[WatchLBCB.ItemIndex];
     if ShowModal = mrOk then
     begin
       Watches[WatchLBCB.ItemIndex] := ExpressionE.Text;
       UpdateWatches;
     end;
     Free;
   end;
end;

procedure TfrxBWForm.FormShow(Sender: TObject);
begin
  tlbB.Images := frxResources.MainButtonImages;
  tlbW.Images := frxResources.MainButtonImages;
end;

procedure TfrxBWForm.ListTBChange(Sender: TObject);
begin
  UpdateWatches;
end;

procedure TfrxBWForm.pnlBResize(Sender: TObject);
begin
  BreakPGR.ColWidths[2] := BreakPGR.Width -  BreakPGR.ColWidths[0] -  BreakPGR.ColWidths[1];
end;

procedure TfrxBWForm.pnlWResize(Sender: TObject);
var
  Bool: Boolean;
begin
 if (WatchLBCB.ItemIndex <> -1) then
 begin
{$IFDEF FPC}
   Bool := Boolean(PtrInt(Watches.Objects[WatchLBCB.ItemIndex]));
   Watches.Objects[WatchLBCB.ItemIndex] := TObject(PtrInt(not Bool));
{$ELSE}
   Bool := Boolean(Watches.Objects[WatchLBCB.ItemIndex]);
   Watches.Objects[WatchLBCB.ItemIndex] := TObject(not Bool);
{$ENDIF}
   UpdateWatches;
 end;
end;

procedure TfrxBWForm.ToggleEnableBClick(Sender: TObject);
var
  BP: TfrxBreakPoint;
begin
 if BreakPGR.Selection.Top < 1 then Exit;
 BP := TfrxBreakPoint(BreakPGR.Objects[0, BreakPGR.Selection.Top]);
 if BP = nil then Exit;
 BP.Enabled := not BP.Enabled;
 BreakPGR.Invalidate;
 if Assigned(SynMemo) then
  SynMemo.Invalidate;
end;

procedure TfrxBWForm.WatchLBCBClickCheck(Sender: TObject);
var
  Bool: Boolean;
begin
  if (WatchLBCB.ItemIndex <> -1) then
  begin
{$IFDEF FPC}
    Bool := Boolean(PtrInt(Watches.Objects[WatchLBCB.ItemIndex]));
    Watches.Objects[WatchLBCB.ItemIndex] := TObject(PtrInt(not Bool));
{$ELSE}
    Bool := Boolean(Watches.Objects[WatchLBCB.ItemIndex]);
    Watches.Objects[WatchLBCB.ItemIndex] := TObject(not Bool);
{$ENDIF}
    UpdateWatches;
  end;
end;

procedure TfrxBWForm.SetSynMemo(const Value: TfrxSyntaxMemo);
begin
  if Assigned(Value) then
    Value.BreakPoints.OnChange := BPListUpdated
  else if (Value = nil) and Assigned(FSynMemo) then
    FSynMemo.BreakPoints.OnChange := nil;
  FSynMemo := Value;
end;

procedure TfrxBWForm.BPListUpdated(Sender: TObject);
begin
  UpdateList;
end;

function TfrxBWForm.CalcWatch(const s: String): String;
var
  v: Variant;
begin
  if (FScript <> nil) and (FScriptRunning) then
  begin
    v := FScript.Evaluate(s);
    Result := VarToStr(v);
    if TVarData(v).VType = varBoolean then
      if Boolean(v) = True then
        Result := 'True' else
        Result := 'False'
    else if (TVarData(v).VType = varString) or (TVarData(v).VType = varOleStr)
    {$IFDEF Delphi12}or (TVarData(v).VType = varUString){$ENDIF} then
      Result := '''' + v + ''''
    else if v = Null then
      Result := 'Null';
  end
  else
    Result := frxGet(6590);
end;


destructor TfrxBWForm.Destroy;
begin
  if Assigned(FSynMemo) and Assigned(FSynMemo.BreakPoints) then
    FSynMemo.BreakPoints.OnChange := nil;
  FWatches.Free;
  inherited Destroy;
end;

procedure TfrxBWForm.UpdateList;
var
  i: Integer;
  BP: TfrxBreakPoint;
  sList: TStrings;
begin
  BreakPGR.RowCount := 1;
  BreakPGR.RowCount := FSynMemo.BreakPoints.Count + 1;
  if BreakPGR.RowCount = 1 then
  begin
    {$IFDEF FPC}
    BreakPGR.RowCount := 2;
    BreakPGR.Rows[1].Clear;
    {$ELSE}
    BreakPGR.Rows[1].Clear;
    BreakPGR.RowCount := 2;
    {$ENDIF}
  end;
  BreakPGR.FixedRows := 1;
  // TODO move to resources
  BreakPGR.Cells[0, 0] := frxGet(6586);
  BreakPGR.Cells[1, 0] := frxGet(5202);
  BreakPGR.Cells[2, 0] := frxGet(4601);
  for i := 0 to FSynMemo.BreakPoints.Count - 1 do
  begin
    BP := TfrxBreakPoint(FSynMemo.BreakPoints.Objects[i]);
    sList := BreakPGR.Rows[i + 1];
    sList.BeginUpdate;
    sList.Clear;
    sList.AddObject(BoolToStr(BP.Enabled), BP);
    sList.AddObject(IntToStr(BP.Line), BP);
    sList.AddObject(BP.Condition, BP);
    sList.EndUpdate;
  end;
end;

procedure TfrxBWForm.UpdateWatches;
  procedure FillWatches;
  var
  i: Integer;
  begin
    WatchLBCB.Items.BeginUpdate;
    WatchLBCB.Items.Clear;
    for i := 0 to Watches.Count - 1 do
    begin
      if Watches.Objects[i] = TObject(1) then
        WatchLBCB.Items.Add(Watches[i] + ': ' + CalcWatch(Watches[i]))
      else
        WatchLBCB.Items.Add(Watches[i] + ': ' + frxGet(6589));
{$IFDEF FPC}
      WatchLBCB.Checked[i] := Boolean(PtrInt(Watches.Objects[i]));
{$ELSE}
      WatchLBCB.Checked[i] := Boolean(Watches.Objects[i]);
{$ENDIF}
    end;
    WatchLBCB.Items.EndUpdate;
  end;

  procedure FillLocal;
  var
    i: Integer;
    v: TfsVariable;
    lst: TStrings;
  begin
    WatchLB.RowCount := 1;
    {$IFNDEF FPC}
    WatchLB.Rows[1].Clear;
    {$ENDIF}
    if Assigned(Script) and Assigned(Script.ProgRunning) then
      for i := 0 to Script.ProgRunning.Count - 1 do
      begin
        if Script.ProgRunning.Items[i] is TfsVariable then
        begin
          WatchLB.RowCount := WatchLB.RowCount + 1;
          lst := WatchLB.Rows[WatchLB.RowCount - 1];
          lst.BeginUpdate;
          lst.Clear;
          v := TfsVariable(Script.ProgRunning.Items[i]);
          lst.AddObject(v.Name, v);
          lst.AddObject(v.TypeName, v);
          lst.AddObject(VarToStr(v.Value), v);
          lst.EndUpdate;
        end;
      end;
    if WatchLB.RowCount = 1 then
      WatchLB.RowCount := 2;
    WatchLB.FixedRows := 1;
  end;
begin
  AddW.Enabled := (ListTB.TabIndex = 0);
  DeleteW.Enabled := AddW.Enabled;
  EditW.Enabled := AddW.Enabled;
  WatchLB.Visible := (ListTB.TabIndex = 1);
  WatchLBCB.Visible := (ListTB.TabIndex = 0);
  if ListTB.TabIndex = 0 then
    FillWatches
  else
    FillLocal;
end;

end.

