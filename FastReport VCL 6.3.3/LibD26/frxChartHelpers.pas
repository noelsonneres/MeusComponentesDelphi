
{******************************************}
{                                          }
{             FastReport v5.0              }
{         TeeChart series helpers          }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxChartHelpers;

interface

{$I frx.inc}
{$I tee.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Menus, Controls, frxChart,
{$IFDEF DELPHI16}
  VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, VCLTee.Series, VCLTee.TeCanvas, VCLTee.GanttCh, VCLTee.TeeShape,
  VCLTee.BubbleCh, VCLTee.ArrowCha
{$IFDEF TeeChartPro}
, VCLTee.TeePolar,
{$IFNDEF TeeChart4}
  VCLTee.TeeSmith, VCLTee.TeePyramid, VCLTee.TeeDonut, VCLTee.TeeFunnel, VCLTee.TeeBoxPlot, VCLTee.TeeTriSurface,{$ENDIF}
  VCLTee.TeeBezie, VCLTee.OHLChart, VCLTee.CandleCh, VCLTee.StatChar, VCLTee.ErrorBar,
  VCLTee.TeeSurfa, VCLTee.TeePoin3, VCLTee.MyPoint, VCLTee.Bar3D
{$IFDEF TeeChart7}
, VCLTee.TeeGauges, VCLTee.TeePointFigure
{$ENDIF}
{$ENDIF}
{$ELSE}
  TeeProcs, TeEngine, Chart, Series, TeCanvas, GanttCh, TeeShape,
  BubbleCh, ArrowCha
{$IFDEF TeeChartPro}
, TeePolar, 
{$IFNDEF TeeChart4}
  TeeSmith, TeePyramid, TeeDonut, TeeFunnel, TeeBoxPlot, TeeTriSurface,{$ENDIF} 
  TeeBezie, OHLChart, CandleCh, StatChar, ErrorBar, 
  TeeSurfa, TeePoin3, MyPoint, Bar3D
{$IFDEF TeeChart7}
, TeeGauges, TeePointFigure
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxSeriesHelper = class(TObject)
  public
    function GetParamNames: String; virtual; abstract;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); virtual; abstract;
  end;

  TfrxStdSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxPieSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxGanttSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxArrowSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxBubbleSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

{$IFDEF TeeChartPro}
  TfrxPolarSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxGaugeSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxSmithSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxCandleSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxErrorSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxHiLoSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxFunnelSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxSurfaceSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxVector3DSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxBubble3DSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;

  TfrxBar3DSeriesHelper = class(TfrxSeriesHelper)
  public
    function GetParamNames: String; override;
    procedure AddValues(Series: TChartSeries; const v1, v2, v3, v4, v5, v6: String;
      XType: TfrxSeriesXType); override;
  end;
{$ENDIF}

  TfrxSeriesHelperClass = class of TfrxSeriesHelper;


const
{$IFDEF TeeChartPro}
  frxNumSeries = 44;
{$ELSE}
  frxNumSeries = 11;
{$ENDIF}
  frxChartSeries: array[0..frxNumSeries - 1] of TSeriesClass =
    (TLineSeries, TAreaSeries, TPointSeries,
     TBarSeries, THorizBarSeries, TPieSeries,
     TGanttSeries, TFastLineSeries, TArrowSeries,
     TBubbleSeries, TChartShape
{$IFDEF TeeChartPro}
   , {$IFDEF TeeChart7}THorizAreaSeries{$ELSE}nil{$ENDIF}, {$IFNDEF TeeChart4}THorizLineSeries{$ELSE}nil{$ENDIF}, TPolarSeries,
     TRadarSeries, {$IFDEF TeeChart7}TPolarBarSeries{$ELSE}nil{$ENDIF}, {$IFDEF TeeChart7}TGaugeSeries{$ELSE}nil{$ENDIF},
     {$IFNDEF TeeChart4}TSmithSeries, TPyramidSeries, TDonutSeries{$ELSE}nil, nil, nil{$ENDIF},
     TBezierSeries, TCandleSeries, TVolumeSeries,
     {$IFDEF TeeChart7}TPointFigureSeries{$ELSE}nil{$ENDIF}, {$IFNDEF TeeChart4}THistogramSeries{$ELSE}nil{$ENDIF}, {$IFDEF TeeChart7}THorizHistogramSeries{$ELSE}nil{$ENDIF},
     TErrorBarSeries, TErrorSeries, {$IFNDEF TeeChart4}THighLowSeries{$ELSE}nil{$ENDIF},
     {$IFNDEF TeeChart4}TFunnelSeries, TBoxSeries, THorizBoxSeries{$ELSE}nil, nil, nil{$ENDIF},
     TSurfaceSeries, TContourSeries, {$IFNDEF TeeChart4}TWaterFallSeries,
     TColorGridSeries{$ELSE}nil, nil{$ENDIF}, {$IFDEF TeeChart7}TVector3DSeries{$ELSE}nil{$ENDIF}, {$IFDEF TeeChart7}TTowerSeries{$ELSE}nil{$ENDIF},
     {$IFNDEF TeeChart4}TTriSurfaceSeries{$ELSE}nil{$ENDIF}, TPoint3DSeries, {$IFDEF TeeChart7}TBubble3DSeries{$ELSE}nil{$ENDIF},
     TMyPointSeries, {$IFNDEF TeeChart4}TBarJoinSeries{$ELSE}nil{$ENDIF}, TBar3DSeries
{$ENDIF}
    );
  frxSeriesHelpers: array[0..frxNumSeries - 1] of TfrxSeriesHelperClass =
    (TfrxStdSeriesHelper, TfrxStdSeriesHelper, TfrxStdSeriesHelper,
     TfrxStdSeriesHelper, TfrxStdSeriesHelper, TfrxPieSeriesHelper,
     TfrxGanttSeriesHelper, TfrxStdSeriesHelper, TfrxArrowSeriesHelper,
     TfrxBubbleSeriesHelper, TfrxStdSeriesHelper
{$IFDEF TeeChartPro}
   , TfrxStdSeriesHelper, TfrxStdSeriesHelper, TfrxPolarSeriesHelper,
     TfrxPolarSeriesHelper, TfrxPolarSeriesHelper, TfrxGaugeSeriesHelper,
     TfrxSmithSeriesHelper, TfrxStdSeriesHelper, TfrxPieSeriesHelper,
     TfrxStdSeriesHelper, TfrxCandleSeriesHelper, TfrxStdSeriesHelper,
     TfrxCandleSeriesHelper, TfrxStdSeriesHelper, TfrxStdSeriesHelper,
     TfrxErrorSeriesHelper, TfrxErrorSeriesHelper, TfrxHiLoSeriesHelper,
     TfrxFunnelSeriesHelper, TfrxStdSeriesHelper, TfrxStdSeriesHelper,
     TfrxSurfaceSeriesHelper, TfrxSurfaceSeriesHelper, TfrxSurfaceSeriesHelper,
     TfrxSurfaceSeriesHelper, TfrxVector3DSeriesHelper, TfrxSurfaceSeriesHelper,
     TfrxSurfaceSeriesHelper, TfrxSurfaceSeriesHelper, TfrxBubble3DSeriesHelper,
     TfrxStdSeriesHelper, TfrxStdSeriesHelper, TfrxBar3DSeriesHelper
{$ENDIF}
    );


function frxFindSeriesHelper(Series: TChartSeries): TfrxSeriesHelper;


implementation

uses frxDsgnIntf, frxUtils, frxRes;


function CheckNulls(Value: String): Boolean;
begin
  Result := (UpperCase(Value) = 'NULL') or (Value = '');
end;

function frxFindSeriesHelper(Series: TChartSeries): TfrxSeriesHelper;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to frxNumSeries - 1 do
    if Series.ClassType = frxChartSeries[i] then
    begin
      Result := TfrxSeriesHelper(frxSeriesHelpers[i].NewInstance);
      Result.Create;
      break;
    end;

  if Result = nil then
    Result := TfrxStdSeriesHelper.Create;
end;

{ TfrxStdSeriesHelper }

procedure TfrxStdSeriesHelper.AddValues(Series: TChartSeries; const v1, v2,
  v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  d: Double;
  Color: TColor;
  s: String;
begin
  d := 0;
  Color := clTeeColor;
  if v4 <> '' then
    try
      Color := StringToColor(v4);
    except
    end;
  if CheckNulls(v2) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  if Series.YValues.DateTime then
    d := StrToDateTime(v2)
  else if frxIsValidFloat(v2) then
    d := frxStrToFloat(v2);
  if v3 <> '' then
    s := v3
  else
    s := v1;
  case XType of
    xtText:
      Series.Add(d, v1, Color);
    xtNumber:
      Series.AddXY(frxStrToFloat(s), d, v1, Color);
    xtDate:
      Series.AddXY(StrToDateTime(s), d, v1, Color);
  end;
end;

function TfrxStdSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;Y;X (optional);Color (optional)';
end;


{ TfrxPieSeriesHelper }

procedure TfrxPieSeriesHelper.AddValues(Series: TChartSeries; const v1, v2,
  v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  d: Double;
  c: TColor;
begin
  if CheckNulls(v2) then
  begin
    Series.AddNull(v1);
    Exit;
  end;

  if Series.YValues.DateTime then
    d := StrToDateTime(v2)
  else
    d := frxStrToFloat(v2);

  c := clTeeColor;
  if v3 <> '' then
  try
    c := StringToColor(v3);
  except
  end;

  Series.Add(d, v1, c);
end;

function TfrxPieSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;Pie;Color (optional)';
end;


{ TfrxGanttSeriesHelper }

procedure TfrxGanttSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  d1, d2: Double;
begin
  if CheckNulls(v2) or CheckNulls(v3) or CheckNulls(v4) then
  begin
    Series.AddNull(v1);
    Exit;
  end;

  if TGanttSeries(Series).StartValues.DateTime then
    d1 := StrToDateTime(v2)
  else
    d1 := frxStrToFloat(v2);
  if TGanttSeries(Series).EndValues.DateTime then
    d2 := StrToDateTime(v3)
  else
    d2 := frxStrToFloat(v3);
  TGanttSeries(Series).AddGantt(d1, d2, frxStrToFloat(v4), v1);
  if v5 <> '' then
    TGanttSeries(Series).NextTask[TGanttSeries(Series).NextTask.Count - 1] := StrToInt(v5);
end;

function TfrxGanttSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;Start;End;Y;Next task';
end;


{ TfrxArrowSeriesHelper }

procedure TfrxArrowSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  Color: TColor;
begin
  if CheckNulls(v2) or CheckNulls(v3) or
    CheckNulls(v4) or CheckNulls(v5) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  Color := clTeeColor;
  if v6 <> '' then
    try
      Color := StringToColor(v6);
    except
    end;
  if XType = xtDate then
    TArrowSeries(Series).AddArrow(StrToDateTime(v2), frxStrToFloat(v3),
      StrToDateTime(v4), frxStrToFloat(v5), v1, Color)
  else
    TArrowSeries(Series).AddArrow(frxStrToFloat(v2), frxStrToFloat(v3),
      frxStrToFloat(v4), frxStrToFloat(v5), v1, Color);
end;

function TfrxArrowSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;X0;Y0;X1;Y1;Color (optional)';
end;


{ TfrxBubbleSeriesHelper }

procedure TfrxBubbleSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  Color: TColor;
begin
  if CheckNulls(v2) or CheckNulls(v3) or CheckNulls(v4) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  Color := clTeeColor;
  if v5 <> '' then
    try
      Color := StringToColor(v5);
    except
    end;
  if XType = xtDate then
    TBubbleSeries(Series).AddBubble(StrToDateTime(v2), frxStrToFloat(v3),
    frxStrToFloat(v4), v1, Color)
  else
    TBubbleSeries(Series).AddBubble(frxStrToFloat(v2), frxStrToFloat(v3),
    frxStrToFloat(v4), v1, Color);
end;

function TfrxBubbleSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;X;Y;Radius;Color (optional)';
end;


{$IFDEF TeeChartPro}
{ TfrxPolarSeriesHelper }

procedure TfrxPolarSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  Color: TColor;
begin
  if CheckNulls(v2) or CheckNulls(v3) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  Color := clTeeColor;
  if v4 <> '' then
    try
      Color := StringToColor(v4);
    except
    end;
  Series.AddXY(frxStrToFloat(v2), frxStrToFloat(v3), v1, Color);
end;

function TfrxPolarSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;Angle;Value;Color (optional)';
end;

{ TfrxGaugeSeriesHelper }

procedure TfrxGaugeSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  Color: TColor;
begin
  if CheckNulls(v2) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  Color := clTeeColor;
  if v3 <> '' then
    try
      Color := StringToColor(v3);
    except
    end;
  Series.Clear;
  Series.Add(frxStrToFloat(v2), v1, Color);
end;

function TfrxGaugeSeriesHelper.GetParamNames: String;
begin
  Result := 'Label (optional);Value;Color (optional)';
end;


{ TfrxSmithSeriesHelper }

procedure TfrxSmithSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
begin
{$IFNDEF TeeChart4}
  if CheckNulls(v2) or CheckNulls(v3) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  TSmithSeries(Series).AddPoint(frxStrToFloat(v2), frxStrToFloat(v3), v1);
{$ENDIF}
end;

function TfrxSmithSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;Resistance;Reactance';
end;


{ TfrxCandleSeriesHelper }

procedure TfrxCandleSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
begin
  TOHLCSeries(Series).AddOHLC(StrToDateTime(v1),
    frxStrToFloat(v2), frxStrToFloat(v3), frxStrToFloat(v4), frxStrToFloat(v5));
end;

function TfrxCandleSeriesHelper.GetParamNames: String;
begin
  Result := 'Date;Open;High;Low;Close';
end;


{ TfrxErrorSeriesHelper }

procedure TfrxErrorSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
begin
  if CheckNulls(v2) or CheckNulls(v3) or CheckNulls(v4) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  TCustomErrorSeries(Series).AddErrorBar(frxStrToFloat(v2), frxStrToFloat(v3),
    frxStrToFloat(v4), v1);
end;

function TfrxErrorSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;X;Y;Error';
end;


{ TfrxHiLoSeriesHelper }

procedure TfrxHiLoSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
begin
{$IFNDEF TeeChart4}
  if CheckNulls(v2) or CheckNulls(v3) or CheckNulls(v4) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  THighLowSeries(Series).AddHighLow(frxStrToFloat(v2), frxStrToFloat(v3),
    frxStrToFloat(v4), v1);
{$ENDIF}
end;

function TfrxHiLoSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;X;High;Low';
end;


{ TfrxFunnelSeriesHelper }

procedure TfrxFunnelSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
{$IFNDEF TeeChart4}
var
  Color: TColor;
{$ENDIF}
begin
{$IFNDEF TeeChart4}
  if CheckNulls(v2) or CheckNulls(v3) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  Color := clTeeColor;
  if v4 <> '' then
    try
      Color := StringToColor(v4);
    except
    end;
  TFunnelSeries(Series).AddSegment(frxStrToFloat(v2), frxStrToFloat(v3), v1, Color);
{$ENDIF}
end;

function TfrxFunnelSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;Quote;Opportunity;Color (optional)';
end;


{ TfrxSurfaceSeriesHelper }

procedure TfrxSurfaceSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  Color: TColor;
begin
  if CheckNulls(v2) or CheckNulls(v3) or CheckNulls(v4) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  Color := clTeeColor;
  if v5 <> '' then
    try
      Color := StringToColor(v5);
    except
    end;
{$IFDEF TeeChart4}
  TCustom3DSeries(Series).AddXYZ(Round(frxStrToFloat(v2)), frxStrToFloat(v3),
    Round(frxStrToFloat(v4)), v1, Color);
{$ELSE}
  TCustom3DSeries(Series).AddXYZ(frxStrToFloat(v2), frxStrToFloat(v3),
    frxStrToFloat(v4), v1, Color);
{$ENDIF}
end;

function TfrxSurfaceSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;X;Y;Z;Color (optional)';
end;


{ TfrxVector3DSeriesHelper }

procedure TfrxVector3DSeriesHelper.AddValues(Series: TChartSeries;
  const v1, v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
begin
{$IFDEF TeeChart7}
  TVector3DSeries(Series).AddVector(frxStrToFloat(v1), frxStrToFloat(v2),
    frxStrToFloat(v3), frxStrToFloat(v4), frxStrToFloat(v5), frxStrToFloat(v6));
{$ENDIF}
end;

function TfrxVector3DSeriesHelper.GetParamNames: String;
begin
  Result := 'X1;Y1;Z1;X2;Y2;Z2';
end;


{ TfrxBubble3DSeriesHelper }

procedure TfrxBubble3DSeriesHelper.AddValues(Series: TChartSeries;
  const v1, v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
{$IFDEF TeeChart7}
var
  Color: TColor;
{$ENDIF}
begin
{$IFDEF TeeChart7}
  if CheckNulls(v2) or CheckNulls(v3) or
    CheckNulls(v4) or CheckNulls(v5) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  Color := clTeeColor;
  if v6 <> '' then
    try
      Color := StringToColor(v6);
    except
    end;
  TBubble3DSeries(Series).AddBubble(frxStrToFloat(v2), frxStrToFloat(v3),
    frxStrToFloat(v4), frxStrToFloat(v5), v1, Color);
{$ENDIF}
end;

function TfrxBubble3DSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;X;Y;Z;Radius;Color (optional)';
end;


{ TfrxBar3DSeriesHelper }

procedure TfrxBar3DSeriesHelper.AddValues(Series: TChartSeries; const v1,
  v2, v3, v4, v5, v6: String; XType: TfrxSeriesXType);
var
  Color: TColor;
begin
  if CheckNulls(v2) or CheckNulls(v3) or CheckNulls(v4) then
  begin
    Series.AddNull(v1);
    Exit;
  end;
  Color := clTeeColor;
  if v5 <> '' then
    try
      Color := StringToColor(v5);
    except
    end;
  TBar3DSeries(Series).AddBar(frxStrToFloat(v2), frxStrToFloat(v3),
    frxStrToFloat(v4), v1, Color);
end;

function TfrxBar3DSeriesHelper.GetParamNames: String;
begin
  Result := 'Label;X;Y;Offset;Color (optional)';
end;
{$ENDIF}

end.
