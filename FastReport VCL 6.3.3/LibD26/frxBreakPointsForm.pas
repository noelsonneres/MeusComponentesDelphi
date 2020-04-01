{******************************************}
{                                          }
{             FastReport v6.0              }
{         Break Points toolwindow          }
{                                          }
{         Copyright (c) 1998-2017          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxBreakPointsForm;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, fs_iinterpreter, CheckLst, frxSynMemo
  {$IFDEF FPC}
  ,LCLType, StdCtrls
  {$ELSE}
  , StdCtrls, ToolWin
  {$ENDIF}
{$IFDEF Delphi6}
, Variants, Grids
{$ENDIF};

type
  TfrxBreakPointsForm = class(TForm)
    ToolBar1: TToolBar;
    DeleteB: TToolButton;
    EditB: TToolButton;
    ToggleEnableB: TToolButton;
    BreakPGR: TStringGrid;
    EditBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddBClick(Sender: TObject);
    procedure DeleteBClick(Sender: TObject);
    procedure EditBClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ToggleEnableBClick(Sender: TObject);
    procedure BreakPGRDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BreakPGRDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FScript: TfsScript;
    FScriptRunning: Boolean;
    FSynMemo: TfrxSyntaxMemo;
    procedure SetSynMemo(const Value: TfrxSyntaxMemo);
    procedure BPListUpdated(Sender: TObject);
  public
    destructor Destroy; override;
    procedure UpdateList;
    property Script: TfsScript read FScript write FScript;
    property ScriptRunning: Boolean read FScriptRunning write FScriptRunning;
    property SynMemo: TfrxSyntaxMemo read FSynMemo write SetSynMemo;
  end;


implementation
{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

uses frxRes;
{$IFNDEF FPC}
type
  THackWinControl = class(TWinControl);
{$ENDIF}


procedure TfrxBreakPointsForm.FormCreate(Sender: TObject);
begin
  Caption := frxGet(5900);
  DeleteB.Hint := frxGet(5902);
  EditB.Hint := frxGet(5903);
{$IFDEF UseTabset}
  BreakPGR.BevelKind := bkFlat;
{$ELSE}
  BreakPGR.BorderStyle := bsSingle;
{$ENDIF}

  if UseRightToLeftAlignment then
    FlipChildren(True);
end;

procedure TfrxBreakPointsForm.FormShow(Sender: TObject);
begin
  Toolbar1.Images := frxResources.MainButtonImages;
end;

procedure TfrxBreakPointsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxBreakPointsForm.AddBClick(Sender: TObject);
begin
  if FSynMemo = nil then Exit;
  FSynMemo.AddNewBreakPoint;
  UpdateList;
end;

procedure TfrxBreakPointsForm.DeleteBClick(Sender: TObject);
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

procedure TfrxBreakPointsForm.EditBClick(Sender: TObject);
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


procedure TfrxBreakPointsForm.UpdateList;
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

procedure TfrxBreakPointsForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TfrxBreakPointsForm.SetSynMemo(const Value: TfrxSyntaxMemo);
begin
  if Assigned(Value) then
    Value.BreakPoints.OnChange := BPListUpdated
  else if (Value = nil) and Assigned(FSynMemo) then
    FSynMemo.BreakPoints.OnChange := nil;
  FSynMemo := Value;
end;

procedure TfrxBreakPointsForm.BPListUpdated(Sender: TObject);
begin
  UpdateList;
end;

destructor TfrxBreakPointsForm.Destroy;
begin
  if Assigned(FSynMemo) and Assigned(FSynMemo.BreakPoints) then
    FSynMemo.BreakPoints.OnChange := nil;
  inherited;
end;

procedure TfrxBreakPointsForm.ToggleEnableBClick(Sender: TObject);
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

procedure TfrxBreakPointsForm.BreakPGRDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
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

procedure TfrxBreakPointsForm.BreakPGRDblClick(Sender: TObject);
begin
 if BreakPGR.Selection.Left > 0 then Exit;
 ToggleEnableBClick(nil);
end;

procedure TfrxBreakPointsForm.FormResize(Sender: TObject);
begin
  BreakPGR.ColWidths[2] := BreakPGR.Width -  BreakPGR.ColWidths[0] -  BreakPGR.ColWidths[1];
end;

end.
