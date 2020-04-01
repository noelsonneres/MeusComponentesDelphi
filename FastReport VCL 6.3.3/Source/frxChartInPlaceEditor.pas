
{******************************************}
{                                          }
{             FastReport v6.0              }
{         TeeChart InPlace Editor          }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxChartInPlaceEditor;

interface

{$I frx.inc}
{$I tee.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  frxClass, frxChart, frxInPlaceEditors,
{$IFDEF DELPHI16}
  VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, VCLTee.Series, VCLTee.TeCanvas
{$ELSE}
  TeeProcs, TeEngine, Chart, Series, TeCanvas
{$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};

type
  TfrxInPlaceChartEditor = class(TfrxInPlaceBasePanelEditor)
  protected
    FDrawButton: Boolean;
    F3DMode: Boolean;
    function GetItem(Index: Integer): Boolean; override;
    procedure SetItem(Index: Integer; const Value: Boolean); override;
    function Count: Integer; override;
    function GetName(Index: Integer): String; override;
    function GetColor(Index: Integer): TColor; override;
  public
    function DoMouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure DrawCustomEditor(aCanvas: TCanvas; aRect: TRect); override;
    procedure InitializeUI(var EventParams: TfrxInteractiveEventsParams); override;
    procedure FinalizeUI(var EventParams: TfrxInteractiveEventsParams); override;
  end;

implementation

uses
  Math, frxRes, Types, Clipbrd, frxXML, frxXMLSerializer;

const
  ClipboardPrefix: String = '#FR6 clipboard#chart#';
  ChartName: String = 'Chart';

type
  TfrxHackView = class(TfrxView);

{ TfrxInPlaceChartEditor }

function TfrxInPlaceChartEditor.Count: Integer;
begin
  Result := 0;
  if FComponent is TfrxChartView then
    Result := TfrxChartView(FComponent).Chart.SeriesCount;
end;

function TfrxInPlaceChartEditor.DoMouseUp(X, Y: Integer; Button: TMouseButton;
  Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
var
  aRect: TRect;
  mDown: Boolean;
begin
  mDown := FMouseDown;
  Result := Inherited DoMouseUp(X, Y, Button, Shift, EventParams);
  if not mDown then Exit;
  aRect.TopLeft := Point(Round(TfrxHackView(FComponent).AbsLeft * FScale), Round(TfrxHackView(FComponent).AbsTop * FScale));
  aRect.BottomRight := Point(Round(aRect.Left + FComponent.Width), Round(aRect.Top + FComponent.Height));
  if (X >= aRect.Right - 16) and
    (X <= aRect.Right) and (Y >= aRect.Top + 2) and
    (Y <= aRect.Top + 18) then
    F3DMode := not F3DMode;
  TfrxChartView(FComponent).Chart.View3D := F3DMode;
  Result := False;
  EventParams.Refresh := True;
end;

procedure TfrxInPlaceChartEditor.DrawCustomEditor(aCanvas: TCanvas;
  aRect: TRect);
var
  r: TRect;
begin
  inherited;
  if not FDrawButton then Exit;
  aRect := Rect(TfrxHackView(FComponent).FX, TfrxHackView(FComponent).FY, TfrxHackView(FComponent).FX1, TfrxHackView(FComponent).FY1);
  r.TopLeft := Point(aRect.Right - 16, aRect.Top + 2);
  r.BottomRight := Point(r.Left + 16, r.Top + 16);
  if F3DMode then
  begin
    r.Top := r.Top - 1;
    r.Left := r.Left - 1;
    r.Bottom := r.Bottom + 1;
    r.Right := r.Right + 1;
    aCanvas.Brush.Color := clGray;
  end
  else
    aCanvas.Brush.Color := clBlack;
  aCanvas.FrameRect(r);
  frxResources.PreviewButtonImages.Draw(aCanvas, aRect.Right - 16, aRect.Top + 2, 28, True);
end;

procedure TfrxInPlaceChartEditor.FinalizeUI(
  var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  FDrawButton := False;
  EventParams.Refresh := True;
end;

function TfrxInPlaceChartEditor.GetColor(Index: Integer): TColor;
begin
  Result := clWhite;
  if FComponent is TfrxChartView then
    Result := TfrxChartView(FComponent).Chart.Series[Index].SeriesColor;
end;

function TfrxInPlaceChartEditor.GetItem(Index: Integer): Boolean;
begin
  Result := False;
  if FComponent is TfrxChartView then
    Result := TfrxChartView(FComponent).Chart.Series[Index].Active;
end;

function TfrxInPlaceChartEditor.GetName(Index: Integer): String;
begin
  Result := '';
  if FComponent is TfrxChartView then
    Result := TfrxChartView(FComponent).Chart.Series[Index].Name;
end;

procedure TfrxInPlaceChartEditor.InitializeUI(
  var EventParams: TfrxInteractiveEventsParams);
begin
  inherited;
  F3DMode := TfrxChartView(FComponent).Chart.View3D;
  FDrawButton := True;
  EventParams.Refresh := True;
end;

procedure TfrxInPlaceChartEditor.SetItem(Index: Integer; const Value: Boolean);
begin
  if FComponent is TfrxChartView then
    TfrxChartView(FComponent).Chart.Series[Index].Active := Value;
end;

initialization
  frxRegEditorsClasses.Register(TfrxChartView, [TfrxInPlaceChartEditor], [[evPreview, evDesigner]]);

end.
