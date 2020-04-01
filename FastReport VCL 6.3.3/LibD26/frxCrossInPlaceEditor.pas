{******************************************}
{                                          }
{             FastReport v6.0              }
{           Cross Object Editors           }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxCrossInPlaceEditor;

interface

{$I frx.inc}

implementation

uses
  {$IFDEF FPC}LazHelper{$ELSE}Windows{$ENDIF},
  Types, Classes, SysUtils, Graphics, Controls, StdCtrls, ComCtrls, Forms, Menus,
  Dialogs, frxClass, frxDesgn, frxDsgnIntf, frxUtils,
  frxRes, frxDesgnWorkspace, frxCross
{$IFDEF Delphi6}
, Variants
{$ENDIF}
{$IFDEF Delphi10}
, WideStrings
{$ENDIF};

type
  { Inline editors }
  TfrxHackCustomCrossView = class(TfrxCustomCrossView);

  TfrxInPlaceCrossEditor = class(TfrxInPlaceEditor)
    FDragActive: Boolean;
    FActiveGrid: TfrxCrossEditGrid;
//  private
  public
    constructor Create(aClassRef: TfrxComponentClass; aOwner: TWinControl); override;
    function HasCustomEditor: Boolean; override;
    procedure DrawCustomEditor(aCanvas: TCanvas; aRect: TRect); override;
    function DoCustomDragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    function DoCustomDragDrop(Source: TObject; X, Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure InitializeUI(var EventParams: TfrxInteractiveEventsParams); override;
    procedure FinalizeUI(var EventParams: TfrxInteractiveEventsParams); override;
  end;

{ TfrxMemoEditor }


{ TfrxInPlaceCrossEditor }

constructor TfrxInPlaceCrossEditor.Create(aClassRef: TfrxComponentClass;
  aOwner: TWinControl);
begin
  inherited;
end;

function TfrxInPlaceCrossEditor.DoCustomDragDrop(Source: TObject; X,
  Y: Integer; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  Node: TTreeNode;
  i, selcount: Integer;
  s: String;
  cross: TfrxHackCustomCrossView;
begin
  Inherited DoCustomDragDrop(Source, X, Y, EventParams);
  Result := False;
  cross := nil;
  if Component is TfrxCustomCrossView then
    cross := TfrxHackCustomCrossView(Component);

  if Assigned(cross) then
    with cross do
    begin
      selcount := TTreeView(Source).SelectionCount - 1;
      for i := selcount downto 0 do
      begin
        Node := TTreeView(Source).Selections[i];
        s := '';
        if (Node <> nil) and (Node.Data <> nil) then
          s := Report.GetAlias(TfrxDataSet(Node.Data));
        if s <> '' then
        begin
          Result := True;
          if DataSet = nil then
            DataSet := TfrxDataSet(Node.Data);
          if (FActiveGrid = seRightBottom) or
            ((FActiveGrid = seLeftTop) and (selcount - i >= 2)) then
          begin
            CellLevels := CellLevels + 1;
            CellFields.Add(Node.Text);
          end
          else if (FActiveGrid = seRightTop) or
            ((FActiveGrid = seLeftTop) and (selcount - i = 1)) then
          begin
            ColumnLevels := ColumnLevels + 1;
            ColumnFields.Add(Node.Text)
          end
          else if (FActiveGrid = seLeftBottom) or
            ((FActiveGrid = seLeftTop) and (selcount - i = 0)) then
          begin
            if (FActiveGrid = seLeftTop) then
            begin
              RowFields.Clear;
              ColumnFields.Clear;
              CellFields.Clear;
              RowLevels := 0;
              ColumnLevels := 0;
              CellLevels := 0;
              DataSet := TfrxDataSet(Node.Data);
            end;
            RowLevels := RowLevels + 1;
            RowFields.Add(Node.Text)
          end;
        end;
      end;
    end;
end;

function TfrxInPlaceCrossEditor.DoCustomDragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  cross: TfrxHackCustomCrossView;
begin
  cross := nil;
  Result := False;
  if Component is TfrxCustomCrossView then
    cross := TfrxHackCustomCrossView(Component);
  with cross do
    if (Source is TTreeView) and Assigned(cross) then
    begin
      FActiveGrid := seLeftTop;
      if (AbsLeft + Width / 2 < X) and (AbsLeft + Width > X) and
        (AbsTop + Height / 2 < Y) and (cross.AbsTop + cross.Height > Y) then
        FActiveGrid := seRightBottom
      else if (AbsLeft + Width / 2 < X) and (AbsLeft + Width > X) and
        (AbsTop < Y) and (AbsTop + Height / 2 > Y) then
        FActiveGrid := seRightTop
      else if (AbsLeft < X) and (AbsLeft + Width / 2 > X) and
        (AbsTop + Height / 2 < Y) and (AbsTop + Height > Y) then
        FActiveGrid := seLeftBottom;
      Accept := True;
      Result := True;
    end;
  if Accept then
    FDragActive := True;
end;

procedure TfrxInPlaceCrossEditor.DrawCustomEditor(aCanvas: TCanvas;
  aRect: TRect);
var
  TempRect: TRect;
  s: String;
  AbsLeft, AbsTop, Width, Height: Extended;
begin
  AbsLeft := TfrxHackCustomCrossView(FComponent).AbsLeft;
  AbsTop := TfrxHackCustomCrossView(FComponent).AbsTop;
  Width := TfrxHackCustomCrossView(FComponent).Width;
  Height := TfrxHackCustomCrossView(FComponent).Height;
    { TODO : Move strings to editor DrawCustomEditor }
  if FDragActive and Assigned(aCanvas) then
  begin
    aCanvas.Brush.Color := clWhite;
    aCanvas.FillRect(Rect(TfrxHackCustomCrossView(FComponent).FX, TfrxHackCustomCrossView(FComponent).FY, TfrxHackCustomCrossView(FComponent).FX1, TfrxHackCustomCrossView(FComponent).FY1));
    aCanvas.MoveTo(Round((AbsLeft + Width / 2) * FScale), Round(AbsTop * FScale));
    aCanvas.LineTo(Round((AbsLeft + Width / 2) * FScale), Round((AbsTop + Height) * FScale));
    aCanvas.MoveTo(Round(AbsLeft * FScale), Round((AbsTop + Height / 2) * FScale));
    aCanvas.LineTo(Round((AbsLeft + Width) * FScale), Round((AbsTop + Height / 2) * FScale));
    aCanvas.Brush.Color := $00E8E3E3;
    aCanvas.Brush.Style := bsSolid;
    TempRect := Rect(Round(AbsLeft * FScale) + 1, Round(AbsTop * FScale) + 1, Round((AbsLeft + Width / 2) * FScale), Round((AbsTop + Height / 2) * FScale));
    s := 'New table';
    case FActiveGrid of
      seRightTop:
      begin
        TempRect := Rect(Round((AbsLeft + Width/ 2) * FScale) + 1, Round(AbsTop * FScale) + 1, Round((AbsLeft + Width) * FScale) - 1, Round((AbsTop + Height / 2) * FScale) - 1);
        s := 'Drop column';
      end;
      seLeftBottom:
      begin
        TempRect := Rect(Round(AbsLeft * FScale) + 1, Round((AbsTop + Height / 2) * FScale) + 1, Round((AbsLeft + Width / 2) * FScale), Round((AbsTop + Height) * FScale) - 1);
        s := 'Drop row';
      end;
      seRightBottom:
      begin
        TempRect := Rect(Round((AbsLeft + Width/ 2) * FScale) + 1, Round((AbsTop + Height / 2) * FScale) + 1, Round((AbsLeft + Width) * FScale) - 1, Round((AbsTop + Height) * FScale) - 1);
        s := 'Drop cell';
      end;
    end;
    aCanvas.FillRect(TempRect);
    //TempRect.Top := TempRect.Top + Round(Height * FScale / 10);
    aCanvas.Font.Size := 12;
    aCanvas.Font.Color := clBlack;
    aCanvas.Pen.Color := clBlack;
    aCanvas.Font.Height := Round(aCanvas.Font.Height * FScale);
    aCanvas.Font.Style := [fsBold];
    aCanvas.TextRect(TempRect, 4, 4, s);
  end;

end;

procedure TfrxInPlaceCrossEditor.FinalizeUI(
  var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  FDragActive := False;
end;

function TfrxInPlaceCrossEditor.HasCustomEditor: Boolean;
begin
  Result := True;
end;

procedure TfrxInPlaceCrossEditor.InitializeUI(
  var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  FDragActive := False;
end;

initialization
  frxRegEditorsClasses.Register(TfrxDBCrossView, [TfrxInPlaceCrossEditor], []);

end.
