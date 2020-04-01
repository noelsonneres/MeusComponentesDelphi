
{******************************************}
{                                          }
{             FastReport v5.0              }
{               Map Ranges                 }
{                                          }
{        Copyright (c) 2015 - 2018         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapRanges;

interface

{$I frx.inc}

uses
  Classes, frxMapHelpers, frxAnaliticGeometry, Graphics, Types;

type
  TMapRangeItem = class(TCollectionItem)
  private
    FAutoStart: Boolean;
    FStartValue: Extended;
    FAutoEnd: Boolean;
    FEndValue: Extended;

    procedure SetStartValue(const Value: Extended);
    procedure SetEndValue(const Value: Extended);
    procedure SetStartValueByForce(const Value: Extended);
    procedure SetEndValueByForce(const Value: Extended);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function IsInside(Value: Extended): Boolean;
  public
    constructor Create(Collection: TCollection); override;
    procedure Read(Reader: TReader); virtual;
    procedure Write(Writer: TWriter); virtual;
    function AsString(FValueFormat: String): String; virtual;
  published
    property AutoStart: Boolean read FAutoStart write FAutoStart;
    property StartValue: Extended read FStartValue write SetStartValue;
    property StartValueByForce: Extended read FStartValue write SetStartValueByForce;
    property AutoEnd: Boolean read FAutoEnd write FAutoEnd;
    property EndValue: Extended read FEndValue write SetEndValue;
    property EndValueByForce: Extended read FEndValue write SetEndValueByForce;
  end;
(******************************************************************************)
  TRangeFactor = (rfValue, rfPercentile, rfCluster, rfAutoCluster);

  TMapRangeCollection = class(TCollection)
  private
    FMinValue, FMaxValue: Extended;
  protected
    FValues: TDoubleArray;
    FRangeFactor: TRangeFactor;

    function GetItem(Index: Integer): TMapRangeItem;
    procedure SetItem(Index: Integer; const Value: TMapRangeItem);
    function Part(Value: Extended): Extended;
    function Ranges(const Values: TDoubleArray; RangeFactor: TRangeFactor): TDoubleArray;
    function RangesByValue(const Values: TDoubleArray): TDoubleArray;
    function RangesByCLuster(const Values: TDoubleArray): TDoubleArray;
    function RangesByAutoCLuster(const Values: TDoubleArray): TDoubleArray;
    function RangesByPercentile(const Values: TDoubleArray): TDoubleArray;
    function MedianValue: Double;
  public
    procedure ReadDFM(Stream: TStream);
    procedure WriteDFM(Stream: TStream);
    procedure Read(Reader: TReader); virtual;
    procedure Write(Writer: TWriter); virtual;
    procedure FillRangeValues(const Values: TDoubleArray; RangeFactor: TRangeFactor);
    procedure Swap(Index1, Index2: Integer);

    property Items[Index: Integer]: TMapRangeItem read GetItem write SetItem; default;
  end;
(******************************************************************************)
  TScaleDock = (sdTopLeft, sdTopCenter, sdTopRight, sdMiddleLeft, sdMiddleRight,
    sdBottomLeft, sdBottomCenter, sdBottomRight, sdMiddleCenter);

  TMapScale = class(TPersistent)
  private
    FVisible: Boolean;
    FBorderColor: TColor;
    FBorderWidth: Integer;
    FDock: TScaleDock;
    FFillColor: TColor;
    FFont: TFont;
    FTitleFont: TFont;
    FTitleText: String;
    FValueFormat: String;
  public
    constructor Create;
    function LeftTopPoint(ConstrivtedParentRect: TRect): TPoint;
    destructor Destroy; override;
  published
    property Visible: Boolean read FVisible write FVisible;
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BorderWidth: Integer read FBorderWidth write FBorderWidth;
    property Dock: TScaleDock read FDock write FDock;
    property FillColor: TColor read FFillColor write FFillColor;
    property Font: TFont read FFont;
    property TitleFont: TFont read FTitleFont;
    property TitleText: String read FTitleText write FTitleText;
    property ValueFormat: String read FValueFormat write FValueFormat;
  end;
(******************************************************************************)
  TMapRanges = class(TPersistent)
  private
    FVisible: Boolean;

    function GetRangeCount: Integer;
    procedure SetRangeCount(const Value: Integer);

    function GetTitleHeight: Integer;
    function GetValuesHeight: Integer;
    function GetWidth: Integer;
    function GetHeight: Integer;
  protected
    FRangeFactor: TRangeFactor;
    FMapRangeCollection: TMapRangeCollection;
    FMapScale: TMapScale;

    function GetSpaceWidth: Integer; virtual;
    function GetStepWidth: Integer; virtual;
    function GetContentHeight: Integer; virtual;

    procedure DrawContent(Canvas: TCanvas); virtual; abstract;
    procedure DrawValues(Canvas: TCanvas);
    function CalcTextHeight(Font: TFont; Text: String): Integer;

    property StepWidth: Integer read GetStepWidth;
    property SpaceWidth: Integer read GetSpaceWidth;
    property ContentHeight: Integer read GetContentHeight;
    property TitleHeight: Integer read GetTitleHeight;
    property ValuesHeight: Integer read GetValuesHeight;
  public
    constructor Create(MapScale: TMapScale);
    destructor Destroy; override;
    function GetGraphic: TGraphic;
    procedure Draw(Canvas: TCanvas);

    property MapScale: TMapScale read FMapScale;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
  published
    property RangeFactor: TRangeFactor read FRangeFactor write FRangeFactor;
    property RangeCount: Integer read GetRangeCount write SetRangeCount;
    property Visible: Boolean read FVisible write FVisible;
  end;
(******************************************************************************)
  function IsValidFloat(NeedTest: Boolean; stFloat: String; Quiet: Boolean = False): Boolean;
  procedure RangeFactorGetList(List: TStrings);
(******************************************************************************)
implementation

uses
  SysUtils, Dialogs, Math, frxRes, frxUtils;

const
  Eps = 1e-3;

type
  TTaxonomy = class
  private
    FClusterCount: Integer;
  protected
    FValues: TDoubleArray;
    FCenters: TDoubleArray;
    FClusters: array of Integer;
    FValuesCount: Integer;

    procedure InitClusters;
    function SplitQuality: Double;
  public
    constructor Create(const Values: TDoubleArray);
    destructor Destroy; override;
    procedure Split(const ClusterCount: Integer);
    procedure OptimalSplit(const MinClusterCount, MaxClusterCount: Integer);
    function Ranges: TDoubleArray;

    property ClusterCount: Integer read FClusterCount;
    property Centers: TDoubleArray read FCenters; // Centers of CLusters
  end;

{ Functions }

procedure RangeFactorGetList(List: TStrings);
begin
  List.Clear;
  List.Add(frxResources.Get('rfValue'));
  List.Add(frxResources.Get('rfPercentile'));
  List.Add(frxResources.Get('rfCluster'));
  List.Add(frxResources.Get('rfAutoCluster'));
end;

function IsValidFloat(NeedTest: Boolean; stFloat: String; Quiet: Boolean = False): Boolean;
begin
  Result := True;
  try
    if NeedTest then
      StrToFloat(stFloat);
  except
    on Exception : EConvertError do
    begin
      if not Quiet then
        ShowMessage(Exception.Message);
      Result := False;
    end;
  end;
end;

procedure frxSort(const A: TDoubleArray);

  procedure qSort(const A: TDoubleArray; L, R: Integer);
  var
    i, j: Integer;
    supp, tmp: Double;
  begin
    supp := A[R - ((R - L) div 2)];
    i := L; j := R;
    while i < j do
      begin
        while A[i] < supp do Inc(i);
        while A[j] > supp do Dec(j);
        if i <= j then
        begin
          tmp := A[i]; A[i] := A[j]; A[j] := tmp;
          Inc(i); Dec(j);
        end;
      end;
    if L < j then qSort(A, L, j);
    if i < R then qSort(A, i, R);
  end;

begin
  qSort(A, 0, High(A));
end;

{ TMapRangeItem }

procedure TMapRangeItem.AssignTo(Dest: TPersistent);
var
  CRDest: TMapRangeItem;
begin
  if Dest is TMapRangeItem then
  begin
    CRDest := TMapRangeItem(Dest);
    CRDest.FAutoStart := FAutoStart;
    CRDest.FStartValue := FStartValue;
    CRDest.FAutoEnd := FAutoEnd;
    CRDest.FEndValue := FEndValue;
  end
  else
    inherited;
end;

function TMapRangeItem.AsString(FValueFormat: String): String;
begin
  Result := IfStr(AutoStart, GetStr('Auto'), Format(FValueFormat, [StartValue])) +
    ' - ' + IfStr(AutoEnd,   GetStr('Auto'), Format(FValueFormat, [EndValue]));
end;

constructor TMapRangeItem.Create(Collection: TCollection);
begin
  inherited;

  FAutoStart := True;
  FStartValue := 0;
  FAutoEnd := True;
  FEndValue := 0;
end;

function TMapRangeItem.IsInside(Value: Extended): Boolean;
begin
  Result := (Value >= FStartValue) and (Value < FEndValue);
end;

procedure TMapRangeItem.Read(Reader: TReader);
begin
  FAutoStart := Reader.ReadBoolean;
  FStartValue := Reader.ReadFloat;
  FAutoEnd := Reader.ReadBoolean;
  FEndValue := Reader.ReadFloat;
end;

procedure TMapRangeItem.SetEndValue(const Value: Extended);
begin
  if FAutoEnd then
    FEndValue := Value;
end;

procedure TMapRangeItem.SetEndValueByForce(const Value: Extended);
begin
  FEndValue := Value;
end;

procedure TMapRangeItem.SetStartValue(const Value: Extended);
begin
  if FAutoStart then
    FStartValue := Value;
end;

procedure TMapRangeItem.SetStartValueByForce(const Value: Extended);
begin
  FStartValue := Value;
end;

procedure TMapRangeItem.Write(Writer: TWriter);
begin
  Writer.WriteBoolean(FAutoStart);
  Writer.WriteFloat(FStartValue);
  Writer.WriteBoolean(FAutoEnd);
  Writer.WriteFloat(FEndValue);
end;

{ TMapRangeCollection }

procedure TMapRangeCollection.FillRangeValues(const Values: TDoubleArray; RangeFactor: TRangeFactor);
var
  RandesData: TDoubleArray;
  i: Integer;
begin
  FValues := Values;
  FRangeFactor := RangeFactor;

  FMinValue := MinValue(Values);
  FMaxValue := MaxValue(Values);
  RandesData := Ranges(Values, RangeFactor);

  BeginUpdate;
  for i := 0 to Count - 1 do
    with TMapRangeItem(Items[i]) do
    begin
      StartValue := RandesData[i];
      EndValue := RandesData[i + 1];
    end;
  EndUpdate;
end;

function TMapRangeCollection.GetItem(Index: Integer): TMapRangeItem;
begin
  Result := TMapRangeItem(inherited GetItem(Index))
end;

function TMapRangeCollection.MedianValue: Double;
var
  HV, HV2: Integer;
begin
  HV := High(FValues);
  HV2 := HV div 2;
  if Odd(HV) then
    Result := (FValues[HV2] + FValues[HV2 + 1]) / 2
  else
    Result := FValues[HV2];
end;

function TMapRangeCollection.Part(Value: Extended): Extended;
var
  L, H, i: Integer;
begin
  case FRangeFactor of
    rfValue, rfCLuster, rfAutoCLuster:
      if FMaxValue - FMinValue < Eps then
        Result := 0.5
      else
        Result := (Value - FMinValue) / (FMaxValue - FMinValue);
    rfPercentile:
      begin
        L := 0; H := High(FValues);
        while H - L > 1 do
        begin
          i := (L + H) div 2;
          if      Value > FValues[i] then L := i
          else if Value < FValues[i] then H := i
          else
          begin
            Result := i / High(FValues);
            Exit;
          end;
        end;
        if      Value = FValues[L] then Result := L
        else if Value = FValues[H] then Result := H
        else                            Result := (L + H) / 2;
        Result := Result / High(FValues);
      end;
    else
      Result := 0.5
  end;
end;

function TMapRangeCollection.Ranges(const Values: TDoubleArray; RangeFactor: TRangeFactor): TDoubleArray;
begin
  case RangeFactor of
    rfValue:
      Result := RangesByValue(Values);
    rfPercentile:
      Result := RangesByPercentile(Values);
    rfCLuster:
      Result := RangesByCLuster(Values);
    rfAutoCLuster:
      Result := RangesByAutoCLuster(Values);
  end;
end;

function TMapRangeCollection.RangesByAutoCLuster(const Values: TDoubleArray): TDoubleArray;
const
  MaxTaxonCount = 7;
var
  Taxonomy: TTaxonomy;
begin
  Taxonomy := TTaxonomy.Create(Values);

  Taxonomy.OptimalSplit(2, Min(Length(Values) div 3, MaxTaxonCount));

  BeginUpdate;
  Clear;
  while Count < Taxonomy.ClusterCount do
    Add;
  EndUpDate;
  Result := Taxonomy.Ranges;

  Taxonomy.Free;
end;

function TMapRangeCollection.RangesByCLuster(const Values: TDoubleArray): TDoubleArray;
var
  Taxonomy: TTaxonomy;
begin
  Taxonomy := TTaxonomy.Create(Values);

  Taxonomy.Split(Count);

  Result := Taxonomy.Ranges;

  Taxonomy.Free;
end;

function TMapRangeCollection.RangesByPercentile(const Values: TDoubleArray): TDoubleArray;
var
  rIndex: Extended;
  i: Integer;
begin
  SetLength(Result, Count + 1);
  frxSort(Values);

  Result[0] := FMinValue - Eps;
  for i := 1 to Count - 1 do
  begin
    rIndex := i * (High(Values) / Count);
    Result[i] := (Values[Floor(rIndex)] + Values[Ceil(rIndex)]) / 2;
  end;
  Result[Count] := FMaxValue + Eps;
end;

function TMapRangeCollection.RangesByValue(const Values: TDoubleArray): TDoubleArray;
var
  Delta: Extended;
  i: Integer;
begin
  SetLength(Result, Count + 1);

  Delta := (FMaxValue - FMinValue) / Count;

  Result[0] := FMinValue - Eps;
  for i := 1 to Count - 1 do
    Result[i] := FMinValue + i * Delta;
  Result[Count] := FMaxValue + Eps;
end;

procedure TMapRangeCollection.Read(Reader: TReader);
var
  i: Integer;
begin
  FMinValue := Reader.ReadFloat;
  FMaxValue := Reader.ReadFloat;
  FRangeFactor := TRangeFactor(Reader.ReadInteger);

  SetLength(FValues, Reader.ReadInteger + 1);
  for i := 0 to High(FValues) do
    FValues[i] := Reader.ReadFloat;

  BeginUpdate;
  for i := 0 to Count - 1 do
    TMapRangeItem(Items[i]).Read(Reader);
  EndUpdate;
end;

procedure TMapRangeCollection.ReadDFM(Stream: TStream);
var
  Reader: TReader;
begin
  Reader := TReader.Create(Stream, 4096);
  Read(Reader);
  Reader.Free;
end;

procedure TMapRangeCollection.SetItem(Index: Integer; const Value: TMapRangeItem);
begin
  inherited SetItem(Index, Value)
end;

procedure TMapRangeCollection.Swap(Index1, Index2: Integer);
begin
  if Index1 < Index2 then
  begin
    BeginUpdate;
    Items[Index2].Index:= Index1; // Items[Index1] have moved right
    Items[Index1 + 1].Index:= Index2;
    EndUpdate;
  end
  else
    Swap(Index2, Index1);
end;

procedure TMapRangeCollection.Write(Writer: TWriter);
var
  i: Integer;
begin
  Writer.WriteFloat(FMinValue);
  Writer.WriteFloat(FMaxValue);
  Writer.WriteInteger(Ord(FRangeFactor));

  Writer.WriteInteger(High(FValues));
  for i := 0 to High(FValues) do
    Writer.WriteFloat(FValues[i]);

  for i := 0 to Count - 1 do
    TMapRangeItem(Items[i]).Write(Writer);
end;

procedure TMapRangeCollection.WriteDFM(Stream: TStream);
var
  Writer: TWriter;
begin
  Writer := TWriter.Create(Stream, 4096);
  Write(Writer);
  Writer.Free;
end;

{ TMapRanges }

{$IFNDEF FRX_DONT_USE_METAFILE_MAP}
function TMapRanges.CalcTextHeight(Font: TFont; Text: String): Integer;
var
  MetaFile: TMetaFile;
  Canvas: TMetafileCanvas;
begin
  MetaFile := TMetaFile.Create;
  Canvas := TMetafileCanvas.Create(MetaFile, 0);
  Canvas.Lock;
  try
    Canvas.Font := Font;
    Result := Canvas.TextHeight(Text);
  finally
    Canvas.UnLock;
    Canvas.Free;
  end;
  MetaFile.Free;
end;
{$ELSE}
function TMapRanges.CalcTextHeight(Font: TFont; Text: String): Integer;
var
  aBitmap: TBitmap;
begin
  aBitmap := TBitmap.Create;
  aBitmap.Width := 1;
  aBitmap.Height := 1;
  aBitmap.Canvas.Lock;
  try
    aBitmap.Canvas.Font := Font;
    Result := aBitmap.Canvas.TextHeight(Text);
  finally
    aBitmap.Canvas.UnLock;
    aBitmap.Free;
  end;
end;
{$ENDIF}

constructor TMapRanges.Create(MapScale: TMapScale);
begin
  FMapScale := MapScale;
  FRangeFactor := rfValue;
  FVisible := True;
  FMapRangeCollection := nil;
end;

destructor TMapRanges.Destroy;
begin
  FMapRangeCollection.Free;

  inherited;
end;

procedure TMapRanges.Draw(Canvas: TCanvas);
begin
  Canvas.Lock;
  try
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := FMapScale.FillColor;
    Canvas.Pen.Color := FMapScale.BorderColor;
    Canvas.Pen.Width := FMapScale.BorderWidth;
    Canvas.Rectangle(0, 0, Width, Height);

    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 1;
    DrawContent(Canvas);

    Canvas.Brush.Style := bsClear;
    DrawValues(Canvas);
  finally
    Canvas.Unlock;
  end;
end;

procedure TMapRanges.DrawValues(Canvas: TCanvas);
var
  i, Left: Integer;
  Top: array[Boolean] of Integer;

  procedure OutNumber(Value: Extended; Odd: Boolean);
  var
    Legend: String;
  begin
    Legend := Format(FMapScale.ValueFormat, [Value]);
    Canvas.TextOut(Left - Canvas.TextWidth(Legend) div 2, Top[Odd], Legend);
  end;

begin
  Canvas.Font := FMapScale.TitleFont;
  Canvas.TextOut((Width - Canvas.TextWidth(FMapScale.TitleText)) div 2, 0, FMapScale.TitleText);

  Canvas.Font := FMapScale.Font;
  Left := SpaceWidth;
  Top[True] := TitleHeight;
  Top[False] := TitleHeight + ValuesHeight + ContentHeight;

  if RangeCount > 1 then
  begin
    for i := 0 to RangeCount - 1 do
    begin
      OutNumber(FMapRangeCollection[i].StartValue, Odd(i));
      Left := Left + StepWidth - 1;
    end;
    OutNumber(FMapRangeCollection[RangeCount - 1].EndValue, Odd(RangeCount));
  end
  else
    with FMapRangeCollection[0] do
    begin
      OutNumber(StartValue, Odd(0));
      Left := Left + StepWidth - 1;
      if FRangeFactor in [rfValue, rfCLuster, rfAutoCLuster] then
        OutNumber((StartValue + EndValue) / 2, Odd(1))
      else if (FRangeFactor = rfPercentile) and (FMapRangeCollection.FValues <> nil) then
        OutNumber(FMapRangeCollection.MedianValue, Odd(1));
      Left := Left + StepWidth - 1;
      OutNumber(EndValue, Odd(2));
    end;
end;

function TMapRanges.GetContentHeight: Integer;
begin
  Result := 2 * FMapScale.Font.Size;
end;

function TMapRanges.GetHeight: Integer;
begin
  Result := TitleHeight + 2 * ValuesHeight + ContentHeight;
end;

{$IFNDEF FRX_DONT_USE_METAFILE_MAP}
function TMapRanges.GetGraphic: TGraphic;
var
  Canvas: TMetafileCanvas;
begin
  Result := TMetaFile.Create;
  Result.Width := Width;
  Result.Height := Height;

  Canvas := TMetafileCanvas.Create(TMetaFile(Result), 0);
  try
    Draw(Canvas);
  finally
    Canvas.Free;
  end;
end;
{$ELSE}
function TMapRanges.GetGraphic: TGraphic;
begin
  // not used
  Result := nil;
end;
{$ENDIF}

function TMapRanges.GetRangeCount: Integer;
begin
  Result := FMapRangeCollection.Count;
end;

function TMapRanges.GetSpaceWidth: Integer;
begin
  Result := 3 * FMapScale.Font.Size;
end;

function TMapRanges.GetStepWidth: Integer;
begin
  Result := 4 * FMapScale.Font.Size;
end;

function TMapRanges.GetTitleHeight: Integer;
begin
  Result := IfInt(FMapScale.TitleText <> '', CalcTextHeight(FMapScale.TitleFont, '0123456789'));
end;

function TMapRanges.GetValuesHeight: Integer;
begin
  Result := CalcTextHeight(FMapScale.Font, '0123456789');
end;

function TMapRanges.GetWidth: Integer;
begin
  Result := 2 * SpaceWidth + Max(RangeCount, 2) * StepWidth;
end;

procedure TMapRanges.SetRangeCount(const Value: Integer);
begin
  while RangeCount < Value do
    FMapRangeCollection.Add;
  while RangeCount > Value do
    FMapRangeCollection.Delete(RangeCount - 1);
end;

{ TMapScale }

constructor TMapScale.Create;
begin
  FVisible := True;
  FBorderColor := clBlack;
  FBorderWidth := 1;
  FDock := sdBottomRight;
  FFillColor := clWhite;
  FFont := TFont.Create;
  FTitleFont := TFont.Create;
  FValueFormat := '%1.2f';
end;

destructor TMapScale.Destroy;
begin
  FFont.Free;
  FTitleFont.Free;

  inherited;
end;

function TMapScale.LeftTopPoint(ConstrivtedParentRect: TRect): TPoint;
begin
  with ConstrivtedParentRect, Result do
  begin
    if      Dock in [sdTopLeft, sdTopCenter, sdTopRight] then          Y := Top
    else if Dock in [sdMiddleLeft, sdMiddleRight, sdMiddleCenter] then Y := (Top + Bottom) div 2
    else {  Dock in [sdBottomLeft, sdBottomCenter, sdBottomRight]}     Y := Bottom;

    if      Dock in [sdTopLeft, sdMiddleLeft, sdBottomLeft] then       X := Left
    else if Dock in [sdTopCenter, sdBottomCenter, sdMiddleCenter] then X := (Left + Right) div 2
    else {  Dock in [sdTopRight, sdMiddleRight, sdBottomRight]}        X := Right;
  end;
end;

{ TTaxonomy }

constructor TTaxonomy.Create(const Values: TDoubleArray);
begin
  FValuesCount := Length(Values);
  SetLength(FClusters, FValuesCount);

  SetLength(FValues, FValuesCount);
  Move(Values[0], FValues[0], FValuesCount * SizeOf(Values[0]));
  frxSort(FValues);
end;

destructor TTaxonomy.Destroy;
begin
  Finalize(FValues);
  Finalize(FCenters);
  Finalize(FClusters);

  inherited;
end;

procedure TTaxonomy.InitClusters;
var
  iValue: Integer;
  Factor: Double;
begin
  Factor := ClusterCount / FValuesCount;
  for iValue := 0 to High(FValues) do
    FClusters[iValue] := Trunc(iValue * Factor);
end;

procedure TTaxonomy.OptimalSplit(const MinClusterCount, MaxClusterCount: Integer);
var
  BestClusterCount, CC: Integer;
  BestSplitQuality, SQ: Double;
begin
  BestClusterCount := -1;
  BestSplitQuality := -1;
  for CC := MinClusterCount to MaxClusterCount do
  begin
    Split(CC);
    SQ := SplitQuality;
    if BestSplitQuality < SQ then
    begin
      BestClusterCount := CC;
      BestSplitQuality := SQ;
    end;
  end;
  Split(BestClusterCount);
end;

function TTaxonomy.Ranges: TDoubleArray;
var
  iCluster: Integer;
begin
  SetLength(Result, ClusterCount + 1);
  Result[0] := FValues[0] - Eps;
  for iCluster := 1 to ClusterCount - 1 do
    Result[iCluster] := (Centers[iCluster - 1] + Centers[iCluster]) / 2;
  Result[ClusterCount] := FValues[FValuesCount - 1] + Eps;
end;

procedure TTaxonomy.Split(const ClusterCount: Integer);
var
  PointsInCluster: array of Integer;
  Value: Double;
  iCluster, iValue, Changes: Integer;
begin
  FClusterCount := ClusterCount;
  SetLength(FCenters, ClusterCount);
  SetLength(PointsInCluster, ClusterCount);

  InitClusters;

  repeat
    // Calc Centers
    for iCluster := 0 to ClusterCount - 1 do
    begin
      Centers[iCluster] := 0.0;
      PointsInCluster[iCluster] := 0;
    end;
    for iValue := 0 to FValuesCount - 1 do
    begin
      iCluster := FClusters[iValue];
      Centers[iCluster] := Centers[iCluster] + FValues[iValue];
      PointsInCluster[iCluster] := PointsInCluster[iCluster] + 1;
    end;
    for iCluster := 0 to ClusterCount - 1 do
      if PointsInCluster[iCluster] > 1 then
        Centers[iCluster] := Centers[iCluster] / PointsInCluster[iCluster];
    // Calc Clusters
    Changes := 0;
    for iValue := 0 to FValuesCount - 1 do
    begin
      Value := FValues[iValue];
      for iCluster := 0 to ClusterCount - 1 do
        if iCluster <> FClusters[iValue] then
          if (Abs(Value - Centers[iCluster]) < Abs(Value - Centers[FClusters[iValue]]))  then
          begin
            FClusters[iValue] := iCluster;
            Inc(Changes);
          end;
    end;
  until Changes = 0;

  frxSort(Centers);
end;

function TTaxonomy.SplitQuality: Double;
var
  InnernalSumSQ, InnernalSD, ExternalSumSQ, ExternalSD: Double;
  iValue, iCluster1, iCluster2: Integer;
begin
  InnernalSumSQ := 0.0;
  for iValue := 0 to FValuesCount - 1 do
    InnernalSumSQ := InnernalSumSQ + Sqr(FValues[iValue] - Centers[FClusters[iValue]]);
  InnernalSD := InnernalSumSQ / FValuesCount;

  ExternalSumSQ := 0.0;
  for iCluster1 := 0 to ClusterCount - 2 do
    for iCluster2 := iCluster1 + 1 to ClusterCount - 1 do
      ExternalSumSQ := ExternalSumSQ + Sqr(Centers[iCluster1] - Centers[iCluster2]);
  ExternalSD := ExternalSumSQ / ClusterCount / (ClusterCount - 1) * 2;

  Result := ExternalSD / InnernalSD;
end;

end.
