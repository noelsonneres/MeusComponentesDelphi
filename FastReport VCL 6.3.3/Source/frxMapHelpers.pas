
{******************************************}
{                                          }
{             FastReport v6.0              }
{               Map Helpers                }
{                                          }
{         Copyright (c) 2016 - 2019        }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapHelpers;

interface

{$I frx.inc}

uses
  frxClass, Classes, Contnrs, frxXML, Controls, Types,
  {$IFNDEF FPC}
  Windows,
  {$ELSE}
  LCLType, LCLIntf, LCLProc,
  {$ENDIF}
  Graphics, Menus
  {$IFNDEF FPC}{$IFDEF Delphi12},pngimage{$ELSE},frxpngimage{$ENDIF}{$ENDIF},
  frxAnaliticGeometry;

type
  TLayerType = (ltMapFile, ltApplication, ltInteractive, ltGeodata);
  TShapeType = (stNone, stPoint, stPolyLine, stPolygon,
    stRect, stDiamond, stEllipse, stPicture, stLegend, stTemplate,
    stMultiPoint, stMultiPolyLine, stMultiPolygon);

  TShapeData = class
  private
    FData: TDoublePointMatrix;
    FShapeType: TShapeType;
    FWidestPartBounds: TfrxRect;
    FShapeCenter: TfrxPoint;
    FPicture: TPicture;
    FConstrainProportions: Boolean;
    FFont: TFont;
    FLegendText: TStringList;
    FTemplateName: String;

    function GetLegend(const Name: String): String;

    function GetPoint: TDoublePoint;
    procedure SetPoint(const Value: TDoublePoint);

    function GetMultiLine(iPart, iPoint: Integer): TDoublePoint;
    procedure SetMultiLine(iPart, iPoint: Integer; const Value: TDoublePoint);
    function GetPartCount: Integer;
    procedure SetPartCount(const Value: Integer);
    function GetMultiLineCount(iPart: Integer): Integer;
    procedure SetMultiLineCount(iPart: Integer; const Value: Integer);
    function GetRect: TDoubleRect;
    procedure SetRect(const Value: TDoubleRect);
    function GetMultiPoint(iPoint: Integer): TDoublePoint;
    function GetMultiPointCount: Integer;
    procedure SetMultiPoint(iPoint: Integer; const Value: TDoublePoint);
    procedure SetMultiPointCount(const Value: Integer);
  protected
    FTags: TStringList; // SparialData
  public
    constructor CreateFull(iParts: Integer; AShapeType: TShapeType; ATags: TStrings);
    constructor CreatePoint(ATags: TStrings; X, Y: Double);
    constructor CreateRect(ATags: TStrings; AShapeType: TShapeType; DR: TDoubleRect);
    constructor CreatePoly(AShapeType: TShapeType; ATags: TStrings; iPoints: Integer);
    constructor CreateEmpty(AShapeType: TShapeType; ATags: TStrings);
    destructor Destroy; override;
    procedure AddPart(iPoints: Integer);
    function IsGetColumnList(List: TStrings): Boolean;
    procedure CalcBounds;
    procedure GetPolyPoints(var Points: TDoublePointArray; iPart: Integer);
    function IsClosed: Boolean;

    procedure ReadStringList(var SL: TStringList; Reader: TReader);
    procedure ReadTags(Reader: TReader);
    procedure ReadData(Reader: TReader);
    procedure ReadPicture(Reader: TReader);
    procedure ReadFont(Reader: TReader);

    procedure WriteStringList(SL: TStringList; Writer: TWriter);
    procedure WriteTags(Writer: TWriter);
    procedure WriteData(Writer: TWriter);
    procedure WritePicture(Writer: TWriter);
    procedure WriteFont(Writer: TWriter);

    property Point: TDoublePoint read GetPoint write SetPoint;
    property Rect: TDoubleRect read GetRect write SetRect;

    property MultiPoint[iPoint: Integer]: TDoublePoint read GetMultiPoint write SetMultiPoint;
    property MultiPointCount: Integer read GetMultiPointCount write SetMultiPointCount;

    property MultiLine[iPart, iPoint: Integer]: TDoublePoint read GetMultiLine write SetMultiLine;
    property PartCount: Integer read GetPartCount write SetPartCount;
    property MultiLineCount[iPart: Integer]: Integer read GetMultiLineCount write SetMultiLineCount;

    property Legend[const Name: String]: String read GetLegend;
    property ShapeType: TShapeType read FShapeType;
    property WidestPartBounds: TfrxRect read FWidestPartBounds;
    property ShapeCenter: TfrxPoint read FShapeCenter;

    property Tags: TStringList read FTags; // SparialData
    property Picture: TPicture read FPicture;
    property ConstrainProportions: Boolean read FConstrainProportions write FConstrainProportions;
    property Font: TFont read FFont;
    property LegendText: TStringList read FLegendText;
    property TemplateName: String read FTemplateName write FTemplateName;
  end;

  TMapToCanvasCoordinateConverter = class
  private
    FMercatorProjection: Boolean;
    FIsHasData: Boolean;

    procedure SetMercatorProjection(const Value: Boolean);
  protected
    FXmin, FYmin, FXmax, FYmax: Extended; // Map
    FXRange, FYRange, FYmaxTransformed: Extended; // speedup
    FWidth, FHeight, FOffsetX, FOffsetY: Extended; // Canvas

    FShapeActive: Boolean;
    FShapeZoom: Extended;
    FShapeOffset, FShapeCenter: TfrxPoint;
    FUseOffset: Boolean;

    function YTransform(Y: Extended): Extended;
    function ConvertMercator(Y: Extended): Extended;
    function MapTransform(P: TfrxPoint): TfrxPoint; overload;
    function MapTransform(X, Y: Extended): TfrxPoint; overload;
    function ShapeTransform(P: TfrxPoint): TfrxPoint;
  public
    procedure Init;
    procedure IncludeRect(LayerRect: TfrxRect);
    function AspectRatio: Extended;
    procedure SetCanvasSize(CanvasSize: TfrxPoint);
    procedure SetOffset(OffsetX, OffsetY: Extended);

    procedure ReadDFM(Stream: TStream);
    procedure WriteDFM(Stream: TStream);
    procedure Read(Reader: TReader);
    procedure Write(Writer: TWriter);

    procedure IgnoreShape;
    procedure InitShape(AOffsetX, AOffsetY, AZoom: Extended; AShapeCenter: TfrxPoint);

    function Transform(X, Y: Extended): TfrxPoint; overload;
    function Transform(DoublePoint: TDoublePoint): TfrxPoint; overload;
    function Transform(frxPoint: TfrxPoint): TfrxPoint; overload;
    function TransformOffset(frxPoint: TfrxPoint): TfrxPoint; overload;
    function TransformRect(R: TfrxRect): TfrxRect; // Flip Top <--> Bottom

    function CanvasToMap(Canvas: TfrxPoint): TfrxPoint;

    property UseOffset: Boolean read FUseOffset write FUseOffset;
    property MercatorProjection: Boolean read FMercatorProjection write SetMercatorProjection;
    property IsHasData: Boolean read FIsHasData;
  end;

  TTaggedElement = class
  protected
    FTags: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTag(const stName, stValue: String);

    function IsHaveAllTags(LayerTags: TStrings): Boolean;
    function IsHaveAnyTag(LayerTags: TStrings): Boolean;

    property Tags: TStringList read FTags;
  end;

  TfrxMapXMLReader = class(TfrxXMLReader)
  protected
    function IsLastSlash(const InSt: String): Boolean;
    function IsFirstSlash(const InSt: String): Boolean;
    procedure ReadValuedItem(var {$IFDEF Delphi12}NameS, ValueS{$ELSE}Name, Value{$ENDIF}, Text: String);
  public
    function IsReadMapXMLRootItem(Item: TfrxXMLItem): Boolean;
    function IsReadMapXMLItem(Item: TfrxXMLItem): Boolean;
  end;

  TfrxMapXMLDocument = class(TfrxXMLDocument)
  protected
    FMapXMLStream: TFileStream;
    FMapXMLStreamReader: TfrxMapXMLReader;
  public
    procedure InitMapXMLFile(const FileName: String);
    procedure DoneMapXMLFile;
    function IsReadItem(Item: TfrxXMLItem): Boolean;
  end;

  TfrxSumStringList = class (TStringList)
  private
    function GetSum(i: Integer): Integer;
    procedure SetSum(i: Integer; const Value: Integer);
  public
    procedure AddSum(st: String);
    procedure SortSum;

    property Sum[i: Integer]: Integer read GetSum write SetSum;
  end;

type
  TfrxClippingRect = class
  private
    FR: TfrxRect;
    FActive: Boolean;
  public
    constructor Create;
    procedure Init(Active: Boolean; R: TfrxRect);
    function IsCircleInside(Circle: TCircle): Boolean;
    function IsPolygonCover(PolyPoints: TPointArray): Boolean; overload;
    function IsPolygonCover(PolyPoints: TDoublePointArray): Boolean; overload;
    function IsPolygonCover(ShapeData: TShapeData; iPart: Integer): Boolean; overload;
    function IsPointInside(P: TfrxPoint): Boolean;
    function IsPolyLineInside(PolyPoints: TPointArray): Boolean; overload;
    function IsPolyLineInside(PolyPoints: TDoublePointArray): Boolean; overload;
    function IsPolyLineInside(ShapeData: TShapeData; iPart: Integer): Boolean; overload;
    function IsPolygonInside(PolyPoints: TPointArray): Boolean; overload;
    function IsPolygonInside(PolyPoints: TDoublePointArray): Boolean; overload;
    function IsPolygonInside(ShapeData: TShapeData; iPart: Integer): Boolean; overload;
    function IsSegmentInside(S: TSegment): Boolean;
    function IsRectInside(Rect: TRect): Boolean;
    function IsDiamondInside(Rect: TRect): Boolean;
  end;

procedure Simplify(Points: TDoublePointArray; Accuracy: Extended; var UsedCount: Integer);
function SafeFileName(FileName: String): String;

procedure Log(Text: String); overload;
procedure Log(Strings: TStrings); overload;
procedure Log(Stream: TStream); overload;
function ToHex(b: Byte): string;

procedure Translate(WinControl: TWinControl);
procedure TranslateMenu(Menu: TMenu);

{$IFNDEF FPC}
function IsCanPngToTransparentBitmap32(PNG: TPngObject; out Bitmap: TBitmap): boolean;

const
  Bitmap32BF: TBlendFunction = ( BlendOp: AC_SRC_OVER; BlendFlags: 0;
    SourceConstantAlpha: 255; AlphaFormat: AC_SRC_ALPHA );
{$ENDIF}

function PlatformFileName(const FileName: string): string;

implementation

uses
  Math, SysUtils, {$IFNDEF FPC}jpeg,{$ENDIF} Dialogs,
  frxUtils;

type
  TPictureFormat = (pfUnknown, pfPNG, {$IFNDEF FPC}pfEMF,{$ENDIF} pfBMP, pfJPG);

function GetPictureFormat(Graphic: TGraphic): TPictureFormat;
begin
  if      Graphic is TBitmap then     Result := pfBMP
  else if Graphic is TJpegImage then  Result := pfJPG
{$IFNDEF FRX_DONT_USE_METAFILE_MAP}
  else if Graphic is TMetaFile then   Result := pfEMF
{$ENDIF}
  else if Graphic is {$IFNDEF FPC}TPngObject{$ELSE}
  TPortableNetworkGraphic{$ENDIF}
  then  Result := pfPNG
  else                                Result := pfUnknown;
end;

{ Functions}

function PlatformFileName(const FileName: string): string;
begin
  Result := {$IFDEF NONWINFPC} ExpandUNCFileName(FileName)
            {$ELSE}            FileName
            {$ENDIF};
end;

procedure SaveFontToStream(Stream: TStream; AFont: TFont);
var
  LogFont: TLogFont;
  Color: TColor;
begin
  if GetObject(AFont.Handle, SizeOf(LogFont), @LogFont) = 0 then
    RaiseLastOSError;
  Stream.WriteBuffer(LogFont, SizeOf(LogFont));
  Color := AFont.Color;
  Stream.WriteBuffer(Color, SizeOf(Color));
end;

procedure LoadFontFromStream(Stream: TStream; AFont: TFont);
var
  LogFont: TLogFont;
  F: HFONT;
  Color: TColor;
begin
  Stream.ReadBuffer(LogFont, SizeOf(LogFont));
  F := CreateFontIndirect(LogFont);
  if F = 0 then
    RaiseLastOSError;
  AFont.Handle := F;
  Stream.ReadBuffer(Color, SizeOf(Color));
  AFont.Color := Color;
end;

{$IFNDEF FPC}
procedure Png32ToTransparentBitmap32(PNG: TPngObject; out Bitmap: TBitmap);
var
  AlphaScanline: {$IFDEF Delphi12}pngimage.{$ELSE}frxpngimage.{$ENDIF}pByteArray;
  Alpha: Byte;
  Dest: PByte;
  y, x: Integer;
begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf32bit;
  Bitmap.Width := PNG.Width;
  Bitmap.Height := PNG.Height;
  Bitmap.Canvas.Draw(0, 0, PNG);

  for y := 0 to PNG.Height - 1 do
  begin
    AlphaScanline := PNG.AlphaScanline[y];
    Dest := Bitmap.ScanLine[y];
    for x := 0 to PNG.Width - 1 do
    begin
      Alpha := AlphaScanline^[x];
      Dest^ := MulDiv(Dest^, Alpha, 255); Inc(Dest);
      Dest^ := MulDiv(Dest^, Alpha, 255); Inc(Dest);
      Dest^ := MulDiv(Dest^, Alpha, 255); Inc(Dest);
      Dest^ := Alpha;                     Inc(Dest);
    end;
  end;
end;


function IsCanPngToTransparentBitmap32(PNG: TPngObject; out Bitmap: TBitmap): boolean;
var
  PNGA: TPngObject;
begin
  Result := PNG.TransparencyMode in [ptmBit, ptmPartial];
  if Result then
    if PNG.Header.ColorType = COLOR_RGBALPHA then
      Png32ToTransparentBitmap32(PNG, Bitmap)
    else
    begin
      PNGA := PNGToPNGA(PNG);
      Png32ToTransparentBitmap32(PNGA, Bitmap);
      PNGA.Free;
    end;
end;
{$ENDIF}
function ToHex(b: Byte): string;
const
  d: string = '0123456789abcdef';
begin
  Result := d[1 + b div 16] + d[1 + b mod 16];
end;

procedure Log(Stream: TStream);
var
  SL: TStringList;
  OldPosition: Int64;
begin
  SL := TStringList.Create;
  try
    OldPosition := Stream.Position;
    Stream.Position := 0;
    SL.LoadFromStream(Stream);
    Stream.Position := OldPosition;
    Log(SL);
  finally
    SL.Free;
  end;
end;

procedure Log(Strings: TStrings);
begin
  Log(Strings.Text);
end;

procedure Log(Text: String);
var
  F: TextFile;
  FileName: String;
begin
  FileName := ExtractFilePath(Paramstr(0)) + 'Log.txt';
  AssignFile(F, FileName);
  if FileExists(FileName) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, text);
  CloseFile(F);
end;

function SafeFileName(FileName: String): String;
begin
  Result := AnsiLowerCase(ExpandUNCFileName(FileName));
end;

procedure Simplify(Points: TDoublePointArray; Accuracy: Extended; var UsedCount: Integer);

  function Dist(i1, i2: integer): Extended;
  begin
    Result := Sqrt(Sqr(Points[i1].X - Points[i2].X) + Sqr(Points[i1].Y - Points[i2].Y));
  end;

var
  iPoint, AccuracyCount: Integer;
begin
  AccuracyCount := 1;
  for iPoint := 1 to UsedCount - 1 do
    if Dist(AccuracyCount - 1, iPoint) > Accuracy then
    begin
      Points[AccuracyCount] := Points[iPoint];
      Inc(AccuracyCount);
    end;
  UsedCount := AccuracyCount;
end;

procedure TranslateMenu(Menu: TMenu);
var
  i: Integer;
begin
  for i := 0 to Menu.Items.Count - 1 do
    with Menu.Items[i] do
      if Tag > 0 then
        Caption := GetStr(IntToStr(Tag));
end;

procedure Translate(WinControl: TWinControl);

  procedure AssignTexts(Root: TControl);
  var
    i: Integer;
  begin
    with Root do
    begin
      if Tag > 0 then
        SetTextBuf(PChar(GetStr(IntToStr(Tag))));

      if Root is TWinControl then
        with Root as TWinControl do
          for i := 0 to ControlCount - 1 do
            if Controls[i] is TControl then
              AssignTexts(Controls[i] as TControl);
    end;
  end;

begin
  AssignTexts(WinControl);

  if WinControl.UseRightToLeftAlignment then
    WinControl.FlipChildren(True);
end;

{ TShapeData }

procedure TShapeData.AddPart(iPoints: Integer);
begin
  PartCount := PartCount + 1;
  MultiLineCount[PartCount - 1] := iPoints;
end;

procedure TShapeData.CalcBounds;
var
  iPart, iPoint: Integer;
  ShapeBounds, PartBounds: TfrxRect;
begin
  case ShapeType of
    stPolyLine, stPolygon, stTemplate,
    stMultiPoint, stMultiPolyLine, stMultiPolygon:
      begin
        InitRect(ShapeBounds, MultiLine[0, 0]);
        FWidestPartBounds := ShapeBounds;

        for iPart := 0 to PartCount - 1 do
        begin
          InitRect(PartBounds, MultiLine[iPart, 0]);
          for iPoint := 0 to MultiLineCount[iPart] - 1 do
            ExpandRect(PartBounds, MultiLine[iPart, iPoint]);
          ExpandRect(ShapeBounds, PartBounds);
          if RectWidth(FWidestPartBounds) < RectWidth(PartBounds) then
            FWidestPartBounds := PartBounds;
        end;
        FShapeCenter := CenterRect(ShapeBounds);
      end;
    stRect, stDiamond, stEllipse, stPicture, stLegend:
      begin
        FWidestPartBounds := frxCanonicalRect(Rect);
        FShapeCenter := CenterRect(FWidestPartBounds);
      end;
    stPoint:
      with Point do
        FShapeCenter := frxPoint(X, Y);
  else
    raise Exception.Create('Unknown ShapeType');
  end
end;

constructor TShapeData.CreateEmpty(AShapeType: TShapeType; ATags: TStrings);
begin
  CreateFull(0, AShapeType, ATags);
end;

constructor TShapeData.CreateFull(iParts: Integer; AShapeType: TShapeType; ATags: TStrings);
begin
  PartCount := iParts;
  FShapeType := AShapeType;
  FTags := TStringList.Create;
  FTags.Assign(ATags);
  case ShapeType of
    stPicture:
      FPicture := TPicture.Create;
    stLegend:
      begin
        FFont := TFont.Create;
        FLegendText := TStringList.Create;
      end;
    stTemplate:
      FTemplateName := '';
  end;
end;

constructor TShapeData.CreatePoly(AShapeType: TShapeType; ATags: TStrings; iPoints: Integer);
begin
  CreateFull(1, AShapeType, ATags);
  MultiLineCount[0] := iPoints;
end;

constructor TShapeData.CreateRect(ATags: TStrings; AShapeType: TShapeType; DR: TDoubleRect);
begin
  CreateFull(1, AShapeType, ATags);
  MultiLineCount[0] := 2;
  Rect := DR;
end;

constructor TShapeData.CreatePoint(ATags: TStrings; X, Y: Double);
begin
  CreateFull(1, stPoint, ATags);
  MultiLineCount[0] := 1;
  Point := DoublePoint(X, Y);
end;

destructor TShapeData.Destroy;
var
  iParts: Integer;
begin
  for iParts := 0 to High(FData) do
    Finalize(FData[iParts]);
  Finalize(FData);
  FTags.Free;
  FPicture.Free;
  FFont.Free;
  FLegendText.Free;

  inherited;
end;

function TShapeData.GetLegend(const Name: String): String;
begin
  Result := FTags.Values[Name];
end;

function TShapeData.GetMultiLine(iPart, iPoint: Integer): TDoublePoint;
begin
  Result := FData[iPart, iPoint];
end;

function TShapeData.GetMultiLineCount(iPart: Integer): Integer;
begin
  Result := Length(FData[iPart]);
end;

function TShapeData.GetMultiPoint(iPoint: Integer): TDoublePoint;
begin
  Result := FData[0, iPoint];
end;

function TShapeData.GetMultiPointCount: Integer;
begin
  Result := Length(FData[0]);
end;

function TShapeData.GetPartCount: Integer;
begin
  Result := Length(FData);
end;

function TShapeData.GetPoint: TDoublePoint;
begin
  Result := GetMultiLine(0, 0);
end;

procedure TShapeData.GetPolyPoints(var Points: TDoublePointArray; iPart: Integer);
var
  iPoint: Integer;
begin
  SetLength(Points, MultiLineCount[iPart]);
  for iPoint := 0 to High(Points) do
    Points[iPoint] := MultiLine[iPart, iPoint];
end;

function TShapeData.GetRect: TDoubleRect;
begin
  Result.TopLeft := GetMultiLine(0, 0);
  Result.BottomRight := GetMultiLine(0, 1);
end;

function TShapeData.IsClosed: Boolean; // The first point coincides with the last
var
  iPart: Integer;
  DP: TDoublePoint;
begin
  Result := False;
  for iPart := 0 to High(FData) do
    if High(FData[iPart]) > 1 then
    begin
      DP := FData[iPart, 0];
      with FData[iPart, High(FData[iPart])] do
        Result := (DP.X = X) and (DP.Y = Y);
      if Result then
        Break;
    end;
end;

function TShapeData.IsGetColumnList(List: TStrings): Boolean;
var
  iTag: Integer;
begin
  Result := FTags.Count > 0;
  for iTag := 0 to FTags.Count - 1 do
    List.Add(FTags.Names[iTag]);
end;

procedure TShapeData.ReadData(Reader: TReader);
var
  iPart, iPoint: Integer;
begin
  FWidestPartBounds := frxRect(Reader.ReadFloat, Reader.ReadFloat, Reader.ReadFloat, Reader.ReadFloat);
  FShapeCenter := frxPoint(Reader.ReadFloat, Reader.ReadFloat);
  FShapeType := TShapeType(Reader.ReadInteger);
  PartCount := Reader.ReadInteger;
  for iPart := 0 to PartCount - 1 do
  begin
    MultiLineCount[iPart] := Reader.ReadInteger;
    for iPoint := 0 to MultiLineCount[iPart] - 1 do
      MultiLine[iPart, iPoint] := DoublePoint(Reader.ReadFloat, Reader.ReadFloat);
  end;
  case ShapeType of
    stPicture:
      begin
        FConstrainProportions := Reader.ReadBoolean;
        ReadPicture(Reader);
      end;
    stLegend:
      begin
        ReadFont(Reader);
        ReadStringList(FLegendText, Reader);
      end;
    stTemplate:
      FTemplateName := Reader.ReadString;
  end;
end;

procedure TShapeData.ReadFont(Reader: TReader);
var
  MemoryStream: TMemoryStream;
begin
  FFont.Free;
  FFont := TFont.Create;
  MemoryStream := TMemoryStream.Create;
  MemoryStream.Size := Reader.ReadInteger;
  Reader.Read(MemoryStream.Memory^, MemoryStream.Size);
  LoadFontFromStream(MemoryStream, FFont);
  MemoryStream.Free;
end;

procedure TShapeData.ReadPicture(Reader: TReader);
var
  PictureFormat: TPictureFormat;
  MemoryStream: TMemoryStream;
  Graphic: TGraphic;
begin
  PictureFormat := TPictureFormat(Reader.ReadInteger);
  if PictureFormat = pfUnknown then
    Exit;

  if FPicture = nil then FPicture := TPicture.Create
  else                   FPicture.Graphic.Free;

  case PictureFormat of
    pfPNG: Graphic := {$IFNDEF FPC}TPngObject{$ELSE}TPortableNetworkGraphic{$ENDIF}.Create;
{$IFNDEF FRX_DONT_USE_METAFILE_MAP}
    pfEMF: Graphic := TMetafile.Create;
{$ELSE}
{$IFNDEF FPC}
    pfEMF: raise Exception.Create('Unknown PictureFormat');
{$ENDIF}
{$ENDIF}
    pfBMP: Graphic := TBitmap.Create;
    pfJPG: Graphic := TJPEGImage.Create;
  else
    raise Exception.Create('Unknown PictureFormat');
  end;
  FPicture.Graphic := Graphic;
  Graphic.Free;

  MemoryStream := TMemoryStream.Create;
  MemoryStream.Size := Reader.ReadInteger;
  Reader.Read(MemoryStream.Memory^, MemoryStream.Size);
  FPicture.Graphic.LoadFromStream(MemoryStream);
  MemoryStream.Free;
end;

procedure TShapeData.ReadStringList(var SL: TStringList; Reader: TReader);
var
  i, Count: Integer;
begin
  if SL <> nil then SL.Clear
  else              SL := TStringList.Create;

  Count := Reader.ReadInteger;
  for i := 0 to Count - 1 do
    SL.Add(Reader.ReadWideString);
end;

procedure TShapeData.ReadTags(Reader: TReader);
begin
  ReadStringList(FTags, Reader);
end;

procedure TShapeData.SetMultiLine(iPart, iPoint: Integer; const Value: TDoublePoint);
begin
  FData[iPart, iPoint] := Value;
end;

procedure TShapeData.SetMultiLineCount(iPart: Integer; const Value: Integer);
begin
  SetLength(FData[iPart], Value);
end;

procedure TShapeData.SetMultiPoint(iPoint: Integer; const Value: TDoublePoint);
begin
  FData[0, iPoint] := Value;
end;

procedure TShapeData.SetMultiPointCount(const Value: Integer);
begin
  SetLength(FData[0], Value);
end;

procedure TShapeData.SetPartCount(const Value: Integer);
begin
  SetLength(FData, Value);
end;

procedure TShapeData.SetPoint(const Value: TDoublePoint);
begin
  SetMultiLine(0, 0, Value);
end;

procedure TShapeData.SetRect(const Value: TDoubleRect);
begin
  SetMultiLine(0, 0, Value.TopLeft);
  SetMultiLine(0, 1, Value.BottomRight);
end;

procedure TShapeData.WriteData(Writer: TWriter);
var
  iPart, iPoint: Integer;
begin
  Writer.WriteFloat(FWidestPartBounds.Left);
  Writer.WriteFloat(FWidestPartBounds.Top);
  Writer.WriteFloat(FWidestPartBounds.Right);
  Writer.WriteFloat(FWidestPartBounds.Bottom);
  Writer.WriteFloat(FShapeCenter.X);
  Writer.WriteFloat(FShapeCenter.Y);
  Writer.WriteInteger(Integer(ShapeType));
  Writer.WriteInteger(PartCount);
  for iPart := 0 to PartCount - 1 do
  begin
    Writer.WriteInteger(MultiLineCount[iPart]);
    for iPoint := 0 to MultiLineCount[iPart] - 1 do
      with MultiLine[iPart, iPoint] do
      begin
        Writer.WriteFloat(X);
        Writer.WriteFloat(Y);
      end;
  end;
  case ShapeType of
    stPicture:
      begin
        Writer.WriteBoolean(FConstrainProportions);
        WritePicture(Writer);
      end;
    stLegend:
      begin
        WriteFont(Writer);
        WriteStringList(FLegendText, Writer);
      end;
    stTemplate:
      Writer.WriteString(FTemplateName);
  end;
end;

procedure TShapeData.WriteFont(Writer: TWriter);
var
  MemoryStream: TMemoryStream;
begin
  MemoryStream := TMemoryStream.Create;
  SaveFontToStream(MemoryStream, FFont);
  Writer.WriteInteger(MemoryStream.Size);
  Writer.Write(MemoryStream.Memory^, MemoryStream.Size);
  MemoryStream.Free;
end;

procedure TShapeData.WritePicture(Writer: TWriter);
var
  MemoryStream: TMemoryStream;
begin
  if (FPicture.Graphic = nil) or
     (GetPictureFormat(FPicture.Graphic) = pfUnknown) then
    Writer.WriteInteger(Integer(pfUnknown))
  else
  begin
    Writer.WriteInteger(Integer(GetPictureFormat(FPicture.Graphic)));

    MemoryStream := TMemoryStream.Create;
    FPicture.Graphic.SaveToStream(MemoryStream);
    Writer.WriteInteger(MemoryStream.Size);
    Writer.Write(MemoryStream.Memory^, MemoryStream.Size);
    MemoryStream.Free;
  end;
end;

procedure TShapeData.WriteStringList(SL: TStringList; Writer: TWriter);
var
  i: Integer;
begin
  Writer.WriteInteger(SL.Count);
  for i := 0 to SL.Count - 1 do
    Writer.WriteWideString(SL[i]);
end;

procedure TShapeData.WriteTags(Writer: TWriter);
begin
  WriteStringList(FTags, Writer);
end;

{ TMapToCanvasCoordinateConverter }

function TMapToCanvasCoordinateConverter.AspectRatio: Extended;
begin
  Result := FXRange / FYRange;
end;

function TMapToCanvasCoordinateConverter.CanvasToMap(Canvas: TfrxPoint): TfrxPoint;
var
  YTransformed, SinLat: Extended;
begin
  Result.X := (Canvas.X - FOffsetX) * FXRange / FWidth + FXmin;
  YTransformed := FYmaxTransformed - (Canvas.Y - FOffsetY) * FYRange / FHeight;
  if MercatorProjection  then
  begin
    SinLat := (Exp(YTransformed * Pi / 90) - 1) / (Exp(YTransformed * Pi / 90) + 1);
    Result.Y := ArcSin(SinLat) * 180 / Pi;
  end
  else
    Result.Y := YTransformed;
end;

function TMapToCanvasCoordinateConverter.ConvertMercator(Y: Extended): Extended;
const
  MaxLat = 85.0511287798066;
var
  SinLat: Extended;
begin
  if      Y > MaxLat then Y := MaxLat
  else if Y < -MaxLat then Y := -MaxLat;
  SinLat := Sin(Pi / 180 * Y);
  Result := 90 / Pi * Ln((1 + SinLat) / (1 - SinLat));
end;

procedure TMapToCanvasCoordinateConverter.IgnoreShape;
begin
  FShapeActive := False;
end;

procedure TMapToCanvasCoordinateConverter.IncludeRect(LayerRect: TfrxRect);
begin
  with LayerRect do
    if IsHasData then
    begin
      FXmin := Min(FXmin, Left);
      FYmin := Min(FYmin, Top);
      FXmax := Max(FXmax, Right);
      FYmax := Max(FYmax, Bottom);
    end
    else
    begin
      FIsHasData := True;
      FXmin := Left;
      FYmin := Top;
      FXmax := Right;
      FYmax := Bottom;
    end;
  FXRange := FXmax - FXmin;
  FYmaxTransformed := YTransform(FYmax);
  FYRange := FYmaxTransformed - YTransform(FYmin);
end;

procedure TMapToCanvasCoordinateConverter.Init;
begin
  FIsHasData := False;
  FShapeActive := False;
end;

procedure TMapToCanvasCoordinateConverter.InitShape(AOffsetX, AOffsetY, AZoom: Extended; AShapeCenter: TfrxPoint);
begin
  FShapeActive := MaxValue([Abs(AZoom - 1), Abs(AOffsetX), Abs(AOffsetY)]) > 1e-3;
  if FShapeActive then
  begin
    FShapeOffset := frxPoint(AOffsetX, AOffsetY);
    FShapeZoom := AZoom;
    FShapeCenter := MapTransform(AShapeCenter);
  end;
end;

function TMapToCanvasCoordinateConverter.MapTransform(P: TfrxPoint): TfrxPoint;
begin
  Result := MapTransform(P.X, P.Y);
end;

function TMapToCanvasCoordinateConverter.MapTransform(X, Y: Extended): TfrxPoint;
begin
  Result := frxPoint((X - FXmin) * FWidth / FXRange,
    (FYmaxTransformed - YTransform(Y)) * FHeight / FYRange);
end;

procedure TMapToCanvasCoordinateConverter.ReadDFM(Stream: TStream);
var
  Reader: TReader;
begin
  Reader := TReader.Create(Stream, 4096);
  Read(Reader);
  Reader.Free;
end;

procedure TMapToCanvasCoordinateConverter.Read(Reader: TReader);
begin
  FMercatorProjection := Reader.ReadBoolean;
  FIsHasData := Reader.ReadBoolean;
  FXmin := Reader.ReadFloat;
  FYmin := Reader.ReadFloat;
  FXmax := Reader.ReadFloat;
  FYmax := Reader.ReadFloat;
  FXRange := Reader.ReadFloat;
  FYRange := Reader.ReadFloat;
  FYmaxTransformed := Reader.ReadFloat;
  FWidth := Reader.ReadFloat;
  FHeight := Reader.ReadFloat;
  FShapeActive := Reader.ReadBoolean;
  FShapeZoom := Reader.ReadFloat;
  FShapeOffset.X := Reader.ReadFloat;
  FShapeOffset.Y := Reader.ReadFloat;
  FShapeCenter.X := Reader.ReadFloat;
  FShapeCenter.Y := Reader.ReadFloat;
end;

procedure TMapToCanvasCoordinateConverter.SetCanvasSize(CanvasSize: TfrxPoint);
begin
  FWidth := CanvasSize.X;
  FHeight := CanvasSize.Y;
end;

procedure TMapToCanvasCoordinateConverter.SetMercatorProjection(const Value: Boolean);
begin
  FMercatorProjection := Value;
  FYmaxTransformed := YTransform(FYmax);
  FYRange := FYmaxTransformed - YTransform(FYmin);
end;

procedure TMapToCanvasCoordinateConverter.SetOffset(OffsetX, OffsetY: Extended);
begin
  FOffsetX := OffsetX;
  FOffsetY := OffsetY;
end;

function TMapToCanvasCoordinateConverter.ShapeTransform(P: TfrxPoint): TfrxPoint;
begin
  Result := frxPoint(FShapeCenter.X + (P.X - FShapeCenter.X) * FShapeZoom + FShapeOffset.X,
                     FShapeCenter.Y + (P.Y - FShapeCenter.Y) * FShapeZoom + FShapeOffset.Y)
end;

function TMapToCanvasCoordinateConverter.Transform(X, Y: Extended): TfrxPoint;
begin
  Result := MapTransform(X, Y);
  if FShapeActive then
    Result := ShapeTransform(Result);
  if UseOffset then
  begin
    Result.X := Result.X + FOffsetX;
    Result.Y := Result.Y + FOffSetY;
  end;
end;

function TMapToCanvasCoordinateConverter.Transform(DoublePoint: TDoublePoint): TfrxPoint;
begin
  with DoublePoint do
    Result := Transform(X, Y);
end;

function TMapToCanvasCoordinateConverter.Transform(frxPoint: TfrxPoint): TfrxPoint;
begin
  with frxPoint do
    Result := Transform(X, Y);
end;

function TMapToCanvasCoordinateConverter.TransformOffset(frxPoint: TfrxPoint): TfrxPoint;
begin
  with Transform(frxPoint) do
  begin
    Result.X := X + FOffsetX;
    Result.Y := Y + FOffSetY;
  end;
end;

function TMapToCanvasCoordinateConverter.TransformRect(R: TfrxRect): TfrxRect; // Flip Top <--> Bottom
var
  P1, P2: TfrxPoint;
begin
  P1 := Transform(R.Left, R.Bottom);
  P2 := Transform(R.Right, R.Top);
  Result := frxRect(P1.X, P1.Y, P2.X, P2.Y);
end;

procedure TMapToCanvasCoordinateConverter.WriteDFM(Stream: TStream);
var
  Writer: TWriter;
begin
  Writer := TWriter.Create(Stream, 4096);
  Write(Writer);
  Writer.Free;
end;

procedure TMapToCanvasCoordinateConverter.Write(Writer: TWriter);
begin
  Writer.WriteBoolean(FMercatorProjection);
  Writer.WriteBoolean(FIsHasData);
  Writer.WriteFloat(FXmin);
  Writer.WriteFloat(FYmin);
  Writer.WriteFloat(FXmax);
  Writer.WriteFloat(FYmax);
  Writer.WriteFloat(FXRange);
  Writer.WriteFloat(FYRange);
  Writer.WriteFloat(FYmaxTransformed);
  Writer.WriteFloat(FWidth);
  Writer.WriteFloat(FHeight);
  Writer.WriteBoolean(FShapeActive);
  Writer.WriteFloat(FShapeZoom);
  Writer.WriteFloat(FShapeOffset.X);
  Writer.WriteFloat(FShapeOffset.Y);
  Writer.WriteFloat(FShapeCenter.X);
  Writer.WriteFloat(FShapeCenter.Y);
end;

function TMapToCanvasCoordinateConverter.YTransform(Y: Extended): Extended;
begin
  if MercatorProjection then
    Result := ConvertMercator(Y)
  else
    Result := Y;
end;

{ TTaggedElement }

procedure TTaggedElement.AddTag(const stName, stValue: String);
begin
  FTags.Add(stName + FTags.NameValueSeparator + stValue);
end;

constructor TTaggedElement.Create;
begin
  FTags := TStringList.Create;
end;

destructor TTaggedElement.Destroy;
begin
  FTags.Free;
end;

function TTaggedElement.IsHaveAllTags(LayerTags: TStrings): Boolean;
var
  i: Integer;
begin
  Result := False;
  if LayerTags.Count <> 0 then
    for i := 0 to LayerTags.Count - 1 do
      if Tags.IndexOfName(LayerTags[i]) = -1 then
        Exit;
  Result := True;
end;

function TTaggedElement.IsHaveAnyTag(LayerTags: TStrings): Boolean;
var
  i: Integer;
begin
  Result := True;
  if LayerTags.Count = 0 then
    Exit;
  for i := 0 to LayerTags.Count - 1 do
    if Tags.IndexOfName(LayerTags[i]) <> -1 then
      Exit;
  Result := False;
end;

{ TfrxMapXMLReader }

function TfrxMapXMLReader.IsFirstSlash(const InSt: String): Boolean;
begin
  Result := InSt[1] = '/';
end;

function TfrxMapXMLReader.IsLastSlash(const InSt: String): Boolean;
var
  Len: Integer;
begin
  Len := Length(InSt);
  Result := (Len > 0) and (InSt[Len] = '/');
end;

function TfrxMapXMLReader.IsReadMapXMLItem(Item: TfrxXMLItem): Boolean;
var
  ChildItem: TfrxXMLItem;
begin
  Result := IsReadMapXMLRootItem(Item);
  if not Result or IsLastSlash(Item.Text) then
    Exit;

  repeat
    ChildItem := TfrxXMLItem.Create;
    if IsReadMapXMLItem(ChildItem) then
      Item.AddItem(ChildItem)
    else
    begin
      if IsFirstSlash(ChildItem.Name) then
        Item.Value := ChildItem.Value;
      ChildItem.Free;
      Break;
    end;
  until False;
end;

function TfrxMapXMLReader.IsReadMapXMLRootItem(Item: TfrxXMLItem): Boolean;
var
  sName, sText, sValue: String;
begin
  repeat
    ReadValuedItem(sName, sValue, sText);
  until (Position >= Size) or (sName + sText <> '');
  Item.Name := sName;
  Item.Text := sText;
  Item.Value := sValue;

  Result := (sName <> '') and not IsFirstSlash(sName);
end;

procedure TfrxMapXMLReader.ReadValuedItem(var {$IFDEF Delphi12}NameS, ValueS{$ELSE}Name, Value{$ENDIF}, Text: String);
const
  LenPiece = 512;
var
  c: Byte;
  curposName, curPosValue: Integer;
  i: Integer;
{$IFDEF Delphi12}
  Name, Value: AnsiString;
{$ENDIF}
begin
  if EndOfStream then
    Exit;
  c := 0;
  Text := '';
  curposName := 0;
  SetLength(Name, LenPiece);

  curposValue := 0;
  SetLength(Value, LenPiece);

  while not EndOfStream do
  begin
    c := ReadFromBuffer;
    if c = Ord('<') then
      Break
    else
    begin
      Inc(curposValue);
      if curposValue > Length(Value) then
        SetLength(Value, Length(Value) + LenPiece);
      Value[curposValue] := AnsiChar(Chr(c));
    end;
  end;

  while not EndOfStream do
  begin
    c := ReadFromBuffer;
    if c = Ord('<') then
      RaiseException
    else if c = Ord('>') then
      Break
    else
    begin
      Inc(curposName);
      if curposName > Length(Name) then
        SetLength(Name, Length(Name) + LenPiece);
      Name[curposName] := AnsiChar(Chr(c));
    end;
  end;
  if c <> Ord('>') then
    RaiseException;

  SetLength(Name, curposName);

  i := {$IFDEF Delphi12} Pos(AnsiString(' '), Name);
       {$ELSE}           Pos(' ', Name);
       {$ENDIF}
  if i <> 0 then
  begin
    Text := {$IFDEF Delphi12} UTF8Decode(Copy(Name, i + 1, curposName - i));
            {$ELSE}           Copy(Name, i + 1, curposName - i);
            {$ENDIF}
    SetLength(Name, i - 1);
  end;

  SetLength(Value, curposValue);
{$IFDEF Delphi12}
  NameS := String(Name);
  ValueS := UTF8Decode(Copy(Value, 1, curposValue));
{$ENDIF}
end;

{ TfrxMapXMLDocument }

procedure TfrxMapXMLDocument.DoneMapXMLFile;
begin
  FMapXMLStreamReader.Free;
  FTempStream := FMapXMLStream;
end;

procedure TfrxMapXMLDocument.InitMapXMLFile(const FileName: String);
begin
  DeleteTempFile;
  FMapXMLStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  FMapXMLStreamReader := TfrxMapXMLReader.Create(FMapXMLStream);
  Root.Clear;
  Root.Offset := 0;
  FMapXMLStreamReader.ReadHeader;
  FOldVersion := FMapXMLStreamReader.OldFormat;
  FMapXMLStreamReader.IsReadMapXMLRootItem(Root);
end;

function TfrxMapXMLDocument.IsReadItem(Item: TfrxXMLItem): Boolean;
begin
  Result := FMapXMLStreamReader.IsReadMapXMLItem(Item);
end;

{ TfrxSumStringList }

function SumSortFunc(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := -Sign(Integer(List.Objects[Index1]) - Integer(List.Objects[Index2]));
end;

procedure TfrxSumStringList.AddSum(st: String);
var
  i: Integer;
begin
  Sorted := True;
  if Find(st, i) then
    Sum[i] := Sum[i] + 1
  else
    AddObject(st, Pointer(1));
end;

function TfrxSumStringList.GetSum(i: Integer): Integer;
begin
  Result := Integer(Objects[i]);
end;

procedure TfrxSumStringList.SetSum(i: Integer; const Value: Integer);
begin
  Objects[i] := Pointer(Value);
end;

procedure TfrxSumStringList.SortSum;
begin
  Sorted := False;
  CustomSort(SumSortFunc);
end;

{ TfrxClippingRect }

constructor TfrxClippingRect.Create;
begin
  FActive := False;
end;

procedure TfrxClippingRect.Init(Active: Boolean; R: TfrxRect);
begin
  FActive := Active;
  FR := R;
end;

function TfrxClippingRect.IsCircleInside(Circle: TCircle): Boolean;
var
  DistX, DistY: Extended;
begin
  if FActive then
  begin
    DistX := Circle.X - Boundary(Circle.X, FR.Left, FR.Right);
    DistY := Circle.Y - Boundary(Circle.Y, FR.Top, FR.Bottom);

    Result := Sqr(DistX) + Sqr(DistY) < Sqr(Circle.Radius);
  end
  else
    Result := True;
end;

function TfrxClippingRect.IsDiamondInside(Rect: TRect): Boolean;
var
  PolyPoints: TPointArray;
begin
  if FActive then
  begin
    SetLength(PolyPoints, 4);
    with Rect do
    begin
      PolyPoints[0] := Point((Left + Right) div 2, Top);
      PolyPoints[1] := Point(Right, (Top + Bottom) div 2);
      PolyPoints[2] := Point((Left + Right) div 2, Bottom);
      PolyPoints[3] := Point(Left, (Top + Bottom) div 2);
    end;
    Result := IsPolygonInside(PolyPoints);
  end
  else
    Result := True;
end;

function TfrxClippingRect.IsPointInside(P: TfrxPoint): Boolean;
begin
  if FActive then
    Result := IsPointInRect(P, FR)
  else
    Result := True;
end;

function TfrxClippingRect.IsPolygonCover(PolyPoints: TPointArray): Boolean;
begin
  Result := IsPointInPolygon(FR.Left, FR.Top, PolyPoints);
end;

function TfrxClippingRect.IsPolygonCover(
  PolyPoints: TDoublePointArray): Boolean;
begin
   Result := IsInsidePolygon(PolyPoints, frxPoint(FR.Left, FR.Top));
end;

function TfrxClippingRect.IsPolygonInside(
  PolyPoints: TDoublePointArray): Boolean;
begin
  Result := not FActive
    or IsPolyLineInside(PolyPoints)
    or IsSegmentInside(Segment(PolyPoints[0], PolyPoints[High(PolyPoints)]))
    or IsPolygonCover(PolyPoints);
end;

function TfrxClippingRect.IsPolyLineInside(ShapeData: TShapeData; iPart: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if FActive then
  begin
    for i := 0 to ShapeData.MultiLineCount[iPart] - 2 do
      if IsSegmentInside(Segment(ShapeData.MultiLine[iPart, i], ShapeData.MultiLine[iPart, i + 1])) then
        Exit;
    Result := False;
  end;
end;

function TfrxClippingRect.IsPolygonInside(PolyPoints: TPointArray): Boolean;
begin
  Result := not FActive
    or IsPolyLineInside(PolyPoints)
    or IsSegmentInside(Segment(PolyPoints[0], PolyPoints[High(PolyPoints)]))
    or IsPolygonCover(PolyPoints);
end;

function TfrxClippingRect.IsPolyLineInside(
  PolyPoints: TDoublePointArray): Boolean;
var
  i: Integer;
begin
  Result := True;
  if FActive then
  begin
    for i := 0 to High(PolyPoints) - 1 do
      if IsSegmentInside(Segment(PolyPoints[i], PolyPoints[i + 1])) then
        Exit;
    Result := False;
  end;
end;

function TfrxClippingRect.IsPolyLineInside(PolyPoints: TPointArray): Boolean;
var
  i: Integer;
begin
  Result := True;
  if FActive then
  begin
    for i := 0 to High(PolyPoints) - 1 do
      if IsSegmentInside(Segment(PolyPoints[i], PolyPoints[i + 1])) then
        Exit;
    Result := False;
  end;
end;

function TfrxClippingRect.IsRectInside(Rect: TRect): Boolean;
var
  PolyPoints: TPointArray;
begin
  if FActive then
  begin
    SetLength(PolyPoints, 4);
    with Rect do
    begin
      PolyPoints[0] := Point(Left, Top);
      PolyPoints[1] := Point(Right, Top);
      PolyPoints[2] := Point(Right, Bottom);
      PolyPoints[3] := Point(Left, Bottom);
    end;
    Result := IsPolygonInside(PolyPoints);
  end
  else
    Result := True;
end;

function TfrxClippingRect.IsSegmentInside(S: TSegment): Boolean;
begin
  if FActive then
    Result := IsPointInside(S.First) or IsPointInside(S.Second)
      or IsSegmentsIntersect(S, Segment(FR.Left, FR.Top, FR.Right, FR.Top))
      or IsSegmentsIntersect(S, Segment(FR.Left, FR.Top, FR.Left, FR.Bottom))
      or IsSegmentsIntersect(S, Segment(FR.Left, FR.Bottom, FR.Right, FR.Bottom))
      or IsSegmentsIntersect(S, Segment(FR.Right, FR.Top, FR.Right, FR.Bottom))
  else
    Result := True;
end;

function TfrxClippingRect.IsPolygonCover(ShapeData: TShapeData;
  iPart: Integer): Boolean;
var
 i1, i2: Integer;
begin
  Result := False;
  i2 := 0;
  i1 := ShapeData.MultiLineCount[iPart] - 2;// Length(Poly) - 1;

  while i1 >= 0 do
  begin;

    if not ((ShapeData.MultiLine[iPart, i1].X < FR.Left) xor (FR.Left <= ShapeData.MultiLine[iPart, i2].X)) then
      if FR.Top - ShapeData.MultiLine[iPart, i1].Y < (FR.Left - ShapeData.MultiLine[iPart, i1].X) * (ShapeData.MultiLine[iPart, i2].Y - ShapeData.MultiLine[iPart, i1].Y) /
         (ShapeData.MultiLine[iPart, i2].X - ShapeData.MultiLine[iPart, i1].X) then
        Result := not Result;
    i2 := i1;
    i1 := i1 - 1;
  end;
end;

function TfrxClippingRect.IsPolygonInside(ShapeData: TShapeData;
  iPart: Integer): Boolean;
begin
  Result := not FActive
    or IsPolyLineInside(ShapeData, iPart)
    or IsSegmentInside(Segment(ShapeData.MultiLine[iPart, 0], ShapeData.MultiLine[iPart, ShapeData.MultiLineCount[iPart] - 1]))
    or IsPolygonCover(ShapeData, iPart);
end;
end.
