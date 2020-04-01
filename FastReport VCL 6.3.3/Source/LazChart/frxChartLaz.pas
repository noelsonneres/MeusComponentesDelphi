unit frxChartLaz;

{$I frx.inc}

interface

uses
  SysUtils, Classes, Graphics, Variants,
  frxClass,frxCollections,
  TAGraph, TACustomSource, TAIntervalSources, TACustomSeries, TASeries,
  TAChartTeeChart, TARadialSeries, TAMultiSeries,
  TASources, TATransformations;

const
   CntSeries = 11;
   cPointSeries = 'Point Series';
   cHorizBarSeries = 'HorizBar Series';

type


   TNSeries = array[1..CntSeries] of string;
   TfrxChartSeries = array[1..CntSeries] of TSeriesClass;
   TfrxSeriesDataType = (dtDBData, dtBandData, dtFixedData);

const
   NSeries:TNSeries = (
    'Area', 'Bar', 'HorizBar', 'Line', 'Point', 'Pie', 'Polar',
    'Bubble','OHLC','Box','ConstLine');
   CSeries:TfrxChartSeries = (
      TAreaSeries, TBarSeries, THorizBarSeries, TLineSeries,
      TPointSeries, TPieSeries, TPolarSeries, TBubbleSeries,
      TOpenHighLowCloseSeries, TBoxAndWhiskerSeries,
      TConstantLine
   );
   CTransform: array[1..4] of TAxisTransformClass = (
    TLinearAxisTransform, TAutoScaleAxisTransform,
    TLogarithmAxisTransform, TCumulNormDistrAxisTransform
   );
   NTransform: array[1..4] of string = (
     'Linear', 'AutoScale', 'Logarithm', 'CumulNormDistr'
   );

type


  TfrxChartObject = class(TComponent);  // fake component

  { TStyItem }

  TStyItem = class(TfrxCollectionItem)
  private
    FBrush: TBrush;
    FPen: TPen;
    FFont: TFont;
    FRepeatCount: Cardinal;
    FText: String;
    FUseBrush: Boolean;
    FUsePen: Boolean;
    FUseFont: Boolean;
    FNmSer:string;
  protected
    function IsNameStored: Boolean; override;
  public
    constructor Create(Collection:TCollection);override;
    destructor Destroy;override;
  published
    property Brush: TBrush read FBrush write FBrush;
    property Font: TFont read FFont write FFont;
    property Pen: TPen read FPen write FPen;
    property RepeatCount: Cardinal
      read FRepeatCount write FRepeatCount default 1;
    property Text: String read FText write FText;
    property UseBrush: Boolean read FUseBrush write FUseBrush default true;
    property UseFont: Boolean read FUseFont write FUseFont default true;
    property UsePen: Boolean read FUsePen write FUsePen default true;
    property NmSer:string read FNmSer write FNmSer;
  end;

  { TStyData }

  TStyData = class(TfrxCollection)
  private
    FReport:TfrxReport;
    function GetItems(Index: Integer): TStyItem;
  public
    constructor Create(Report:TfrxReport);
    function Add:TStyItem;
    property Items[Index: Integer]:TStyItem  read GetItems; default;
  end;


  { TLSItem }

  TLSItem = class(TfrxCollectionItem)
  private
    FDataBand: TfrxDataBand;
    FDataSet: TfrxDataSet;
    FDataType: TfrxSeriesDataType;
    FDataSetName: string;
    FYCount:Cardinal;
    FDP:TStrings;
    FDDP:TStrings;
    FSorted:Boolean;
    //------------------
    FParams: TChartAxisIntervalParams;
    FDateTimeFormat: String;
    FSteps: TDateTimeSteps;
    FSuppressPrevUnit: Boolean;
    FNameAS: string;
    FTypeAS: Integer;
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
  protected
    function IsNameStored: Boolean; override;
  public
    constructor Create(Collection:TCollection);override;
    destructor Destroy;override;
  published
    property DataType:TfrxSeriesDataType read FDataType write FDataType;
    property DataBand: TfrxDataBand read FDataBand write FDataBand;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: string read GetDataSetName write SetDataSetName;
    property YCount:Cardinal read FYCount write FYCount;
    property DP:TStrings read FDP write FDP;
    property DDP:TStrings read FDDP write FDDP;
    property Sorted:Boolean read FSorted write FSorted;
    //----------------------------
    property Params: TChartAxisIntervalParams read FParams write FParams;
    property DateTimeFormat: String read FDateTimeFormat write FDateTimeFormat;
    property Steps: TDateTimeSteps
      read FSteps write FSteps default DATE_TIME_STEPS_ALL;
    property SuppressPrevUnit: Boolean
      read FSuppressPrevUnit write FSuppressPrevUnit default true;
    property NameAS: string read FNameAS write FNameAS;
    property TypeAS: Integer read FTypeAS write FTypeAS;
  end;

  { TLSData }

  TLSData = class(TfrxCollection)
  private
    FReport:TfrxReport;
    function GetItems(Index: Integer): TLSItem;
  public
    constructor Create(Report:TfrxReport);
    function Add:TLSItem;
    property Items[Index: Integer]:TLSItem  read GetItems; default;
  end;

  { TTransItem }

  TTransItem = class(TfrxCollectionItem)
  private
    FEnabled: Boolean;
    FOffest: Double;
    {TLinearAxisTransform}
    FOffset: Double;
    FScale: Double;
    {TAutoScaleAxisTransform}
    FMaxValue: Double;
    FMinValue: Double;
    {TLogarithmAxisTransform}
    FBase: Double;
    FNameTr:string;
  protected
    function IsNameStored: Boolean; override;
  public
    constructor Create(Collection:TCollection);override;
    destructor Destroy;override;
  published
    property Enabled:Boolean read FEnabled write FEnabled;
    {TLinearAxisTransform}
    property Offset:Double read FOffset write FOffest;
    property Scale:Double read FScale write FScale;
    {TAutoScaleAxisTransform}
    property MaxValue:Double read FMaxValue write FMaxValue;
    property MinValue:Double read FMinValue write FMinValue;
    {TLogarithmAxisTransform}
    property Base:Double read FBase write FBase;
    property NameTr:string read FNameTr write FNameTr;
  end;

  { TTransData }

  TTransData = class(TfrxCollection)
  private
    FReport:TfrxReport;
    function GetItems(Index: Integer): TTransItem;
  public
    constructor Create(Report:TfrxReport);
    function Add:TTransItem;
    property Items[Index: Integer]:TTransItem  read GetItems; default;
  end;




  { TfrxChartView }

  TfrxChartView = class(TfrxView)
  private
    FChart:TChart;
    FLSData:TLSData;
    FStyData:TStyData;
    FTransData: TTransData;
    FChWidth:Integer;
    FChHeight:Integer;
    FIsDraw:Boolean;
    procedure FillChart;
    procedure ReadData(Stream:TStream);
    procedure ReadData2(Reader: TReader);
    procedure ReadData3(Reader: TReader);
    procedure ReadData4(Reader: TReader);
    procedure WriteData(Stream: TStream);
    procedure WriteData2(Writer: TWriter);
    procedure WriteData3(Writer: TWriter);
    procedure WriteData4(Writer: TWriter);
    procedure FindComponentClass(
      AReader: TReader; const AClassName: String; var AClass: TComponentClass);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AComponent:TComponent);override;
    destructor Destroy;override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure GetData; override;
    procedure Draw(Canvas: TCanvas;
      ScaleX, ScaleY, OffsetX, OffsetY: Extended);override;
    property Chart:TChart read FChart write FChart;
    property LSData:TLSData read FLSData;
    property StyData:TStyData read FStyData;
    property TransData:TTransData read FTransData;
 published
    property ChWidth:Integer read FChWidth write FChWidth;
    property ChHeight:Integer read FChHeight write FChHeight;
    property IsDraw:Boolean read FIsDraw write FIsDraw;
    property FillType;
    property Fill;
    property Cursor;
    property Frame;
    property TagStr;
    property URL;
  end;


implementation

uses
  frxChartEditorLaz,
  TADrawerCanvas,
  Printers, frxPrinter, TAPrint, FPCanvas,
  TATools, TAStyles,
  frxDsgnIntf, frxUtils, frxRes,
   TAChartUtils, LResources;




type
  THackSeries = class(TChartSeries);


{ TTransData }

function TTransData.GetItems(Index: Integer): TTransItem;
begin
  Result := TTransItem(inherited Items[Index]);
end;

constructor TTransData.Create(Report: TfrxReport);
begin
  inherited Create(TTransItem);
  FReport := Report;
end;

function TTransData.Add: TTransItem;
begin
  Result := TTransItem(inherited Add);
end;

{ TTransItem }

function TTransItem.IsNameStored: Boolean;
begin
  Result := True;
end;

constructor TTransItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FScale := 1.0;
  FMaxValue := 1.0;
  FBase := Exp(1);
end;

destructor TTransItem.Destroy;
begin
  inherited Destroy;
end;

{ TStyData }

function TStyData.GetItems(Index: Integer): TStyItem;
begin
  Result := TStyItem(inherited Items[Index]);
end;

constructor TStyData.Create(Report: TfrxReport);
begin
  inherited Create(TStyItem);
  FReport := Report;
end;

function TStyData.Add: TStyItem;
begin
  Result := TStyItem(inherited Add);
end;

{ TStyItem }

function TStyItem.IsNameStored: Boolean;
begin
  Result := True;
end;

constructor TStyItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FBrush := TBrush.Create;
  FFont := TFont.Create;
  FPen := TPen.Create;
  FRepeatCount := 1;
  FUseBrush := true;
  FUseFont := true;
  FUsePen := true;
end;

destructor TStyItem.Destroy;
begin
  FreeAndNil(FBrush);
  FreeAndNil(FFont);
  FreeAndNil(FPen);
  inherited Destroy;
end;


{ TLSData }

function TLSData.GetItems(Index: Integer): TLSItem;
begin
  Result := TLSItem(inherited Items[Index]);
end;

constructor TLSData.Create(Report: TfrxReport);
begin
  inherited Create(TLSItem);
  FReport := Report;
end;

function TLSData.Add: TLSItem;
begin
  Result := TLSItem(inherited Add);
end;

{ TLSItem }

procedure TLSItem.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TLSItem.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  if FDataSetName = '' then
    FDataSet := nil
  else  if TLSData(Collection).FReport <> nil then
    FDataSet := TLSData(Collection).FReport.FindDataSet(FDataSet, FDataSetName);
end;

function TLSItem.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

function TLSItem.IsNameStored: Boolean;
begin
  Result := True;
end;

constructor TLSItem.Create(Collection:TCollection);
begin
  inherited Create(Collection);
  FDP := TStringList.Create;
  FDDP := TStringList.Create;
  FYCount := 1;
  FSuppressPrevUnit := True;
  FSteps := DATE_TIME_STEPS_ALL;
  FParams := TChartAxisIntervalParams.Create(nil);
end;

destructor TLSItem.Destroy;
begin
  FDP.Free;
  FDDP.Free;
  inherited Destroy;
end;





{ TfrxChartView }

procedure TfrxChartView.FillChart;
var
  I,J,K:Integer;
  LS:TListChartSource;
  SCls: TSeriesClass;
  Cs: TChartStyles;
  s, s1, s2: string;
  tr: TAxisTransform;
  dti: TDateTimeIntervalChartSource;
  custs: TCustomChartSource;

  procedure ClearTrans;
  var
    I, J: Integer;
  begin
    for I := 0 to FChart.AxisList.Count - 1 do
    begin
      if FChart.AxisList[I].Transformations <> nil then
      begin
        for J := FChart.AxisList[I].Transformations.List.Count - 1 downto 0 do
        begin
          tr := TAxisTransform(FChart.AxisList[I].Transformations.List[J]);
          FChart.AxisList[I].Transformations.List.Delete(J);
          tr.Free;
        end;
        FChart.AxisList[I].Transformations.Free;
        FChart.AxisList[I].Transformations := nil;
      end;
    end;
  end;

  procedure ClearSource;
  var
    I: Integer;
  begin
    for I := 0 to FChart.AxisList.Count - 1 do
    begin
      if FChart.AxisList[I].Marks.Source <> nil then
      begin
        custs := FChart.AxisList[I].Marks.Source;
        FChart.AxisList[I].Marks.Source := nil;
        custs.Free;
      end;
    end;

    for I := 0 to FChart.Series.Count - 1 do
    begin
      if (FChart.Series[I] is TChartSeries) and
          (TChartSeries(FChart.Series[I]).Source <> nil) then
      begin
        TChartSeries(FChart.Series[I]).Source.Free;
        //LS := TListChartSource(TChartSeries(FChart.Series[I]).Source);
        TChartSeries(FChart.Series[I]).Source := nil;
        //LS.Free;
        if THackSeries(FChart.Series[I]).Styles <> nil then
        begin
          Cs := THackSeries(FChart.Series[I]).Styles;
          Cs.Styles.Clear;
          THackSeries(FChart.Series[I]).Styles := nil;
          Cs.Free;
        end;
      end;
    end;
  end;

  procedure ClearStripes;
  var
    I: Integer;
  begin
    for I := 0 to FChart.AxisList.Count - 1 do
    begin
      if FChart.AxisList[I].Marks.Stripes <> nil then
      begin
        FChart.AxisList[I].Marks.Stripes.Styles.Clear;
        FChart.AxisList[I].Marks.Stripes.Free;
        FChart.AxisList[I].Marks.Stripes := nil;
      end;
    end;
  end;

begin
  ClearTrans;
  ClearSource;
  ClearStripes;
  if FTransData.Count > 0 then
  begin
    for I := 0 to FChart.AxisList.Count - 1 do
    begin
      for J := 0 to FTransData.Count - 1 do
      begin
        s := FTransData[J].NameTr;
        s1 := LeftStr(s, Pos('+',s) - 1);
        s2 := Copy(s, Pos('+',s) + 1, Pos('-', s) - Pos('+',s) - 1);
        K := StrToInt(Copy(s, Pos('-', s) + 1, Length(s)));
        if (StrToInt(s1) = I) and (StrToInt(s2) = J) then
        begin
          if FChart.AxisList[I].Transformations = nil then
            FChart.AxisList[I].Transformations :=
              TChartAxisTransformations.Create(nil);
          tr := CTransform[K].Create(nil);
          case K of
            1:begin
              TLinearAxisTransform(tr).Offset := FTransData[J].Offset;
              TLinearAxisTransform(tr).Scale :=  FTransData[J].Scale;
              tr.Enabled := FTransData[J].Enabled;
            end;
            2:begin
              TAutoScaleAxisTransform(tr).MinValue := FTransData[J].MinValue;
              TAutoScaleAxisTransform(tr).MaxValue := FTransData[J].MaxValue;
              tr.Enabled :=  FTransData[J].Enabled;
            end;
            3: begin
              TLogarithmAxisTransform(tr).Base := FTransData[J].Base;
              tr.Enabled :=  FTransData[J].Enabled;
            end;
            4: tr.Enabled :=  FTransData[J].Enabled;
          end;
          tr.Transformations := FChart.AxisList[I].Transformations;
        end;
      end;
    end;
  end;

  for I := 0 to FChart.AxisList.Count - 1 do
  begin
    for J := 0 to LSData.Count - 1 do
    begin
      if LSData[J].NameAS = IntToStr(I) then
      begin
        case LSData[J].TypeAS of
          1: begin
            Ls := TListChartSource.Create(nil);
            Ls.DataPoints.Assign(LSData[J].DP);
            LS.YCount := LSData[J].YCount;
            LS.Sorted := LSData[J].Sorted;
            FChart.AxisList[I].Marks.Source := Ls;
          end;
          2: begin
            dti := TDateTimeIntervalChartSource.Create(nil);
            dti.Params.Assign(LSData[J].Params);
            dti.DateTimeFormat := LSData[J].DateTimeFormat;
            dti.Steps := LSData[I].Steps;
            dti.SuppressPrevUnit := LSData[I].SuppressPrevUnit;
          end;
        end;
        Break;
      end;
    end;

    for J := 0 to StyData.Count - 1 do
    begin
      s := StyData[J].NmSer;
      if IntToStr(I) = LeftStr(s, Pos('+', s) - 1) then
      begin
        if FChart.AxisList[I].Marks.Stripes = nil then
          FChart.AxisList[I].Marks.Stripes := TChartStyles.Create(nil);
        with  TChartStyle(FChart.AxisList[I].Marks.Stripes.Styles.Add) do
        begin
          Brush.Assign(StyData[J].Brush);
          Font.Assign(StyData[J].Font);
          Pen.Assign(StyData[J].Pen);
          Text := StyData[J].Text;
          RepeatCount := StyData[J].RepeatCount;
          UseBrush := StyData[J].UseBrush;
          UsePen := StyData[J].UsePen;
          UseFont := StyData[J].UseFont;
        end;
      end;
    end;
  end;


  for I := 0 to FChart.Series.Count - 1 do
  begin
      if FChart.Series[I] is TChartSeries then
      begin
        s := FChart.Series[I].Name;
        SCls := TSeriesClass(FChart.Series[I].ClassType);
        LS := TListChartSource.Create(nil);
        for J := 0 to LSData.Count - 1 do
          if s = LSData[J].NameAS then
          begin
            LS.DataPoints := FLSData[J].DP;
            LS.YCount := FLSData[J].YCount;
            LS.Sorted := FLSData[J].Sorted;
            Break;
          end;
        TChartSeries(FChart.Series[I]).Source := LS;
        for J := 1 to CntSeries do
        begin
          if (CSeries[J] = SCls) and (J < 6) then
          begin
            s := FChart.Series[I].Name;
            //Cs := TChartStyles.Create(nil);
            //THackSeries(FChart.Series[I]).Styles := Cs;
            for K := 0 to StyData.Count - 1 do
            begin
              s1 := StyData[K].NmSer;
              if Pos(s, s1) = 1 then
              begin
                if THackSeries(FChart.Series[I]).Styles = nil then
                begin
                  Cs := TChartStyles.Create(nil);
                  THackSeries(FChart.Series[I]).Styles := Cs;
                end
                else
                  Cs := THackSeries(FChart.Series[I]).Styles;
                with TChartStyle(Cs.Styles.Add) do
                begin
                  Brush.Assign(StyData[K].Brush);
                  Font.Assign(StyData[K].Font);
                  Pen.Assign(StyData[K].Pen);
                  Text := StyData[K].Text;
                  RepeatCount := StyData[K].RepeatCount;
                  UseBrush := StyData[K].UseBrush;
                  UsePen := StyData[K].UsePen;
                  UseFont := StyData[K].UseFont;
                end;
              end;
            end;
          end;
        end;
      end
  end;
end;

procedure TfrxChartView.ReadData(Stream:TStream);
var
  Comp: TComponent;
begin
  Comp := nil;
  ReadComponentFromBinaryStream(
      Stream, Comp, FindComponentClass, nil, nil, nil);
  if Comp is TChart then
  begin
      FChart.Free;
      FChart := Comp as TChart;
  end;
end;

procedure TfrxChartView.ReadData2(Reader: TReader);
begin
  frxReadCollection(FLSData, Reader, Self);
end;

procedure TfrxChartView.ReadData3(Reader: TReader);
begin
  frxReadCollection(FStyData, Reader, Self);
end;

procedure TfrxChartView.ReadData4(Reader: TReader);
begin
  frxReadCollection(FTransData, Reader, Self);
end;

procedure WriteComponentToStream(AStream: TStream; AComponent: TComponent);
var
  writer: TWriter;
  destroyDriver: Boolean = false;
begin
  writer := CreateLRSWriter(AStream, destroyDriver);
  try
    writer.Root := AComponent;
    writer.WriteComponent(AComponent);
  finally
    if destroyDriver then
      writer.Driver.Free;
    writer.Free;
  end;
end;

procedure TfrxChartView.WriteData(Stream:TStream);
begin
  //SaveToFile(FChart,'C:\lazproj\lprime1.txt');
  //Stream.WriteComponent(FChart);
  WriteComponentToStream(Stream, FChart);
  //WriteComponentAsBinaryToStream(Stream, FChart);
end;

procedure TfrxChartView.WriteData2(Writer: TWriter);
begin
  //SaveToFile(,'C:\lazproj\cols1.txt');
  frxWriteCollection(FLSData, Writer, Self);
end;

procedure TfrxChartView.WriteData3(Writer: TWriter);
begin
  frxWriteCollection(FStyData, Writer, Self);
end;

procedure TfrxChartView.WriteData4(Writer: TWriter);
begin
  frxWriteCollection(FTransData, Writer, Self);
end;

procedure TfrxChartView.FindComponentClass(AReader: TReader;
  const AClassName: String; var AClass: TComponentClass);
var
  i: Integer;
begin
  Unused(AReader);
  if AClassName = FChart.ClassName then begin
    AClass := TChart;
    exit;
  end;
  for i := 0 to SeriesClassRegistry.Count - 1 do begin
  {$IFDEF VER3}
    AClass := TSeriesClass(SeriesClassRegistry.GetClass(i));
  {$ENDIF}
  {$IFDEF VER2}
    AClass := TSeriesClass(SeriesClassRegistry.Objects[i]);
  {$ENDIF}
    if AClass.ClassNameIs(AClassName) then exit;
  end;
  AClass := nil;
end;


procedure TfrxChartView.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  //Filer.DefineProperty('LSData', ReadData2, WriteData2, True);
  Filer.DefineBinaryProperty('Chart', ReadData, WriteData, True);
  Filer.DefineProperty('LSData', ReadData2, WriteData2, True);
  Filer.DefineProperty('StyData', ReadData3, WriteData3, True);
  Filer.DefineProperty('TransData', ReadData4, WriteData4, True);
end;

procedure TfrxChartView.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if Operation = opRemove then
  begin
    for i := 0 to FLSData.Count - 1 do
      if AComponent is TfrxDataSet then
      begin
        if FLSData[i].DataSet = AComponent then
          FLSData[i].DataSet := nil;
      end
      else if AComponent is TfrxBand then
      begin
        if FLSData[i].DataBand = AComponent then
          FLSData[i].DataBand := nil;
      end;
  end;
end;

constructor TfrxChartView.Create(AComponent: TComponent);
begin
  inherited Create(AComponent);
  FChart := TChart.Create(nil);
  FLSData :=  TLSData.Create(Report);
  FStyData :=  TStyData.Create(Report);
  FTransData := TTransData.Create(Report);
  FChart.BackColor := clWhite;
  FChart.Color :=  clWhite;
  FChart.LeftAxis.Grid.Color := clSilver;
  FChart.BottomAxis.Grid.Color := clSilver;
end;

destructor TfrxChartView.Destroy;
begin
  FChart.Free;
  FLSData.Free;
  FStyData.Free;
  inherited Destroy;
end;

class function TfrxChartView.GetDescription: String;
begin
  Result := frxResources.Get('obChart');
end;

procedure TfrxChartView.BeforeStartReport;
begin
  Report.Engine.NotifyList.Add(Self);
end;

procedure TfrxChartView.GetData;
var
  DY: array of string;
  X,Y: string;
  Txt:string;
  Cl:string;
  S:string;
  I,J,YC,YC1:Integer;

  function ConvertVarToStr(Val: Variant): String;
  begin
    if VarIsNull(Val) then
      Result := 'Nan'
    else
      Result := VarToStr(Val)
  end;

begin
  inherited GetData;
  for I := 0 to LSData.Count - 1 do
  begin
    if (LSData[I].DataType = dtDBData)
        and (LSData[I].DataSet <> nil) then
    begin
      YC := LSData[I].YCount;
      YC1 := YC;
      SetLength(DY, 0);
      if YC > 1 then
        SetLength(DY, YC - 1);
      for J := 0 to LSData[I].DDP.Count - 1 do
      begin
        if J = 0 then
          X := LSData[I].DDP[J];
        if J = 1 then
          Y := LSData[I].DDP[J];
        if (YC1 > 1) and (J > 1) then
        begin
          DY[J - 2] := LSData[I].DDP[J];
          YC1 := YC1 - 1;
        end;
        //else
        if J = LSData[I].DDP.Count - 2 then
          Cl := LSData[I].DDP[J];
        if J = LSData[I].DDP.Count - 1 then
          Txt := LSData[I].DDP[J];
      end;
      S := '';
      LSData[I].DataSet.First;
      while  not LSData[I].DataSet.Eof do
      begin
        if X <> '' then
          S := ConvertVarToStr(Report.Calc(X)) + '|'
        else
          S := '0' + '|';
        if Y <> '' then
          S := S + ConvertVarToStr(Report.Calc(Y)) +'|'
        else
          S := S + '0' +'|';
        if YC > 1 then
        begin
          for J := 0 to Length(DY) - 1 do
            if DY[J] <> '' then
              S := S + ConvertVarToStr(Report.Calc(DY[J])) +'|'
            else
              S := S + '0' + '|';
        end;
        if (Cl <> '') and (Cl <> ' ')  then
          S := S + ConvertVarToStr(Report.Calc(Cl)) +'|'
        else
          S := S + '?' + '|';
        if Txt <> ' ' then
          S := S +  VarToStr(Report.Calc(Txt));
        LSData[I].DP.Add(S);
        S := '';
        LSData[I].DataSet.Next;
      end;
    end;
  end;
end;


procedure TfrxChartView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
{$IFDEF NONWINFPC}
var
  vPen: TPen;
  vBrush: TBrush;
  vFont: TFont;
{$ENDIF}
begin
{$IFDEF NONWINFPC}
  try
    vPen := TPen.Create;
    vBrush := TBrush.Create;
    vFont := TFont.Create;
{$ENDIF}
    BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
    FChWidth := FX1 - FX;
    FChHeight := FY1 - FY;
    DrawBackground;
    FillChart;
{$IFDEF NONWINFPC}
    vPen.Assign(Canvas.Pen);
    vBrush.Assign(Canvas.Brush);
    vFont.Assign(Canvas.Font);
    Canvas.SaveHandleState;
{$ENDIF}
    if Canvas is TfrxPrinterCanvas then
    {$IFDEF NONWINFPC}
      FChart.Draw(TPrinterDrawer.Create(Printer), Rect(FX, FY, FX1, FY1))
    {$ELSE}
      FChart.Draw(TCanvasDrawer.Create(Canvas), Rect(FX, FY, FX1, FY1))
    {$ENDIF}
    else
      FChart.Draw(TCanvasDrawer.Create(Canvas), Rect(FX, FY, FX1, FY1));
    DrawFrame;
    FIsDraw := True;
{$IFDEF NONWINFPC}
  finally
    Canvas.RestoreHandleState;
    Canvas.Pen.Assign(vPen);
    Canvas.Brush.Assign(vBrush);
    Canvas.Font.Assign(vFont);
    vPen.Free;
    vBrush.Free;
    vFont.Free;
  end;
{$ENDIF}
end;




initialization
  frxObjects.RegisterObject1(TfrxChartView, nil, '', '', 0, 25);
  frxHideProperties(TfrxChartView,'ChWidth;ChHeight;IsDraw');
  RegisterSeriesClass(TPointSeries, cPointSeries);
  RegisterSeriesClass(THorizBarSeries, cHorizBarSeries);
finalization
  frxObjects.UnRegister(TfrxChartView);


end.
