
{******************************************}
{                                          }
{             FastReport v5.0              }
{            Gauge View Object             }
{                                          }
{            Copyright (c) 2017            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxGaugeView;

interface

{$I frx.inc}

uses
  Types, {$IFNDEF FPC}Windows,{$ENDIF} Graphics, Classes, Controls,
  {$IFDEF FPC}LCLType, LCLIntf, LCLProc,{$ENDIF}
  frxClass, frxGauge;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxGaugeObject = class(TComponent)  // fake component
  end;
  
  TfrxBaseGaugeView = class(TfrxView)
  private
    FBaseGauge: TfrxBaseGauge;
  protected
    function InnerPoint(X, Y: Integer): TPoint;
    procedure CreateGauge; virtual; abstract;
    procedure ContentChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure UpdateInspector;

    function DoMouseDown(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean; override;
    procedure DoMouseMove(X, Y: Integer;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams); override;
    procedure DoMouseUp(X, Y: Integer; Button: TMouseButton;
      Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams); override;
    function DoMouseWheel(Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean; override;

    property BaseGauge: TfrxBaseGauge read FBaseGauge;
  published
    property FillType;
    property Fill;
    property Frame;
    property Cursor;
    property TagStr;
  end;

  {$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  TfrxGaugeView = class(TfrxBaseGaugeView)
  private
    FGauge: TfrxGauge;
    FExpression: String;
    FMacroLoaded: Boolean;
    procedure SetGauge(const Value: TfrxGauge);
  protected
    procedure CreateGauge; override;
  public
    procedure GetData; override;
    procedure SaveContentToDictionary(aReport: TfrxReport; PostProcessor: TfrxPostProcessor); override;
    function LoadContentFromDictionary(aReport: TfrxReport; aItem: TfrxMacrosItem): Boolean; override;
    procedure ProcessDictionary(aItem: TfrxMacrosItem; aReport: TfrxReport; PostProcessor: TfrxPostProcessor); override;
  published
    property Expression: String read FExpression write FExpression;
    property Gauge: TfrxGauge read FGauge write SetGauge;
    property Processing;
  end;

  {$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  TfrxIntervalGaugeView = class(TfrxBaseGaugeView)
  private
    FIntervalGauge: TfrxIntervalGauge;
    FStartExpression: String;
    FEndExpression: String;
    procedure SetIntervalGauge(const Value: TfrxIntervalGauge);
  protected
    procedure CreateGauge; override;
  public
    procedure GetData; override;
  published
    property StartExpression: String read FStartExpression write FStartExpression;
    property EndExpression: String read FEndExpression write FEndExpression;
    property IntervalGauge: TfrxIntervalGauge read FIntervalGauge write SetIntervalGauge;
  end;


implementation

uses
  frxDsgnIntf, frxUtils, frxRes, frxGaugeViewRTTI, frxGaugeEditor, Variants, SysUtils;

const
  meCompleted = True;
  meUnCompleted = False;

{ TfrxBaseGaugeView }

procedure TfrxBaseGaugeView.ContentChanged(Sender: TObject);
begin
end;

constructor TfrxBaseGaugeView.Create(AOwner: TComponent);
begin
  inherited;

  Width := fr1cm * 6;
  Height := fr1cm * 2;
  CreateGauge;
  BaseGauge.OnUpdateOI := UpdateInspector;
end;

destructor TfrxBaseGaugeView.Destroy;
begin
  BaseGauge.Free;

  inherited;
end;

function TfrxBaseGaugeView.DoMouseDown(X, Y: Integer; Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  if EventParams.EventSender = esDesigner then
    Result := inherited DoMouseDown(X, Y, Button, Shift, EventParams)
  else
  begin
    with InnerPoint(X, Y) do
      EventParams.Refresh := BaseGauge.DoMouseDown(X, Y, Button, Shift);
    Result := meCompleted;
  end;
end;

procedure TfrxBaseGaugeView.DoMouseMove(X, Y: Integer; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
begin
  if EventParams.EventSender = esDesigner then
    inherited DoMouseMove(X, Y, Shift, EventParams)
  else
    with InnerPoint(X, Y) do
      EventParams.Refresh := BaseGauge.DoMouseMove(X, Y, Shift);
end;

procedure TfrxBaseGaugeView.DoMouseUp(X, Y: Integer; Button: TMouseButton; Shift: TShiftState; var EventParams: TfrxInteractiveEventsParams);
begin
  if EventParams.EventSender = esDesigner then
    inherited DoMouseUp(X, Y, Button, Shift, EventParams)
  else
    with InnerPoint(X, Y) do
      EventParams.Refresh := BaseGauge.DoMouseUp(X, Y, Button, Shift);
  EventParams.Modified := EventParams.Refresh;
end;

function TfrxBaseGaugeView.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var EventParams: TfrxInteractiveEventsParams): Boolean;
begin
  if EventParams.EventSender = esDesigner then
    Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos, EventParams)
  else
  begin
    EventParams.Refresh := BaseGauge.DoMouseWheel(Shift, WheelDelta, MousePos);
    Result := meCompleted;
  end;
  EventParams.Modified := EventParams.Refresh;
end;

procedure TfrxBaseGaugeView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  inherited;

  BaseGauge.SetXYScales(ScaleX, ScaleY, IsPrinting);
  BaseGauge.Draw(Canvas, Rect(FX, FY, FX1, FY1));
end;

function TfrxBaseGaugeView.InnerPoint(X, Y: Integer): TPoint;
begin
  Result := Point(FX + Round(X - AbsLeft * FScaleX),
                  FY + Round(Y - AbsTop * FScaleY));
end;

procedure TfrxBaseGaugeView.UpdateInspector;
begin
  if (Report <> nil) and (Report.Designer <> nil) then
    TfrxCustomDesigner(Report.Designer).UpdateInspector;
end;

{ TfrxGaugeView }

procedure TfrxGaugeView.CreateGauge;
begin
  inherited;
  FGauge := TfrxGauge.Create;
  FBaseGauge := Gauge;
end;

procedure TfrxGaugeView.GetData;
begin
  inherited;
  if IsDataField then
    FGauge.CurrentValue := frxStrToFloat(VarToStr(DataSet.Value[DataField]))
  else if FExpression <> '' then
    FGauge.CurrentValue := frxStrToFloat(VarToStr(Report.Calc(FExpression)));
end;

function TfrxGaugeView.LoadContentFromDictionary(aReport: TfrxReport;
  aItem: TfrxMacrosItem): Boolean;
var
  ItemIdx: Integer;
  s: String;
begin
  Result := False;
  if (aItem <> nil) and not FMacroLoaded then
  begin
    ItemIdx := Trunc(FGauge.CurrentValue);
    s := aItem.Item[ItemIdx];
    if s <> '' then
    begin
      FGauge.CurrentValue := frxStrToFloat(s);
      FMacroLoaded := True;
    end;
  end;
end;


procedure TfrxGaugeView.ProcessDictionary(aItem: TfrxMacrosItem;
  aReport: TfrxReport; PostProcessor: TfrxPostProcessor);
var
  sName: String;
  Val: Extended;
  Index: Integer;
begin
  Index := aItem.Count - 1;
  Val := FGauge.CurrentValue;
  sName := aReport.CurObject;
  try
    aReport.CurObject := Name;
    GetData;
    aItem.Item[Index] := frxFloatToStr(FGauge.CurrentValue);
  finally
    aReport.CurObject := sName;
    FGauge.CurrentValue := Val;
  end;
end;


procedure TfrxGaugeView.SaveContentToDictionary(aReport: TfrxReport;
  PostProcessor: TfrxPostProcessor);
var
  s: String;
  bName: String;
  Index: Integer;
begin
  bName := '';
  if Assigned(Parent) then
    bName := Parent.Name;
  s := frxFloatToStr(FGauge.CurrentValue);
  Index := PostProcessor.Add(bName, Name, s, Processing.ProcessAt, Self,
    ((Processing.ProcessAt <> paDefault)) and
    (bName <> ''));
  if Index <> -1 then
    FGauge.CurrentValue := Index;
end;


procedure TfrxGaugeView.SetGauge(const Value: TfrxGauge);
begin
  Gauge.Assign(Value);
end;

{ TfrxIntervalGaugeView }

procedure TfrxIntervalGaugeView.CreateGauge;
begin
  FIntervalGauge := TfrxIntervalGauge.Create;
  FBaseGauge := IntervalGauge;
end;

procedure TfrxIntervalGaugeView.GetData;
begin
  inherited;
  if FStartExpression <> '' then
    FIntervalGauge.StartValue := frxStrToFloat(VarToStr(Report.Calc(FStartExpression)));
  if FEndExpression <> '' then
    FIntervalGauge.EndValue := frxStrToFloat(VarToStr(Report.Calc(FEndExpression)));
end;

procedure TfrxIntervalGaugeView.SetIntervalGauge(const Value: TfrxIntervalGauge);
begin
  IntervalGauge.Assign(Value);
end;

initialization
  frxObjects.RegisterObject1(TfrxGaugeView, nil, frxResources.Get('obGauge'), '', 0, 70);
  frxObjects.RegisterObject1(TfrxIntervalGaugeView, nil, frxResources.Get('obIntervalGauge'), '', 0, 70);

finalization
  frxObjects.Unregister(TfrxGaugeView);
  frxObjects.Unregister(TfrxIntervalGaugeView);

end.
