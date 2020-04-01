
{ ****************************************** }
{                                            }
{             FastReport v5.0                }
{          Barcode Add-in object             }
{                                            }
{         Copyright (c) 1998-2014            }
{         by Alexander Tzyganenko,           }
{            Fast Reports Inc.               }
{                                            }
{ ****************************************** }

unit frxBarcode2D;

interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  SysUtils, Classes, Graphics, Types, Controls, Variants, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls,
  frxClass, frxDesgn, frxBarcodePDF417, frxBarcodeDataMatrix, frxBarcodeQR,
  frxBarcodeAztec, frxBarcodeMaxiCode, frxBarcode2DBase, frxBarcodeProperties;

type

  // Типы штрих-кодов ////////////////////////////////////////////////////////////////////////
  TfrxBarcode2DType = (bcCodePDF417, bcCodeDataMatrix, bcCodeQR, bcCodeAztec, bcCodeMaxiCode);

  TfrxBarcode2DView = class(TfrxStretcheable)
  private
    FBarCode: TfrxBarcode2DBase;
    FBarType: TfrxBarcode2DType;
    FHAlign: TfrxHAlign;
    FProp: TfrxBarcode2DProperties;
    // класс содержит свойства для текущего типа баркода
    FExpression: String;
    FMacroLoaded: Boolean;
    FAutoSize: Boolean;
    procedure SetZoom(z: Extended);
    function GetZoom: Extended;
    procedure SetRotation(v: Integer);
    function GetRotation: Integer;
    procedure SetShowText(v: Boolean);
    function GetShowText: Boolean;
    procedure SetText(v: String);
    function GetText: String;
    procedure SetFontScaled(v: Boolean);
    function GetFontScaled: Boolean;
    procedure SetErrorText(v: String);
    function GetErrorText: String;
    procedure SetQuietZone(v: Integer);
    function GetQuietZone: Integer;

    procedure SetProp(v: TfrxBarcode2DProperties);
    procedure SetBarType(v: TfrxBarcode2DType);
    procedure CalcSize;
    function CalcAddSize: TfrxPoint;
  protected
    procedure SetWidth(Value: Extended); override;
    procedure SetHeight(Value: Extended); override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
      OffsetY: Extended); override;
    class function GetDescription: String; override;
    procedure GetData; override;
    function GetRealBounds: TfrxRect; override;
    procedure GetScaleFactor(var ScaleX: Extended; var ScaleY: Extended); override;
  	function CalcHeight: Extended; override;
    function DrawPart: Extended; override;
    procedure SaveContentToDictionary(aReport: TfrxReport; PostProcessor: TfrxPostProcessor); override;
    function LoadContentFromDictionary(aReport: TfrxReport; aItem: TfrxMacrosItem): Boolean; override;
    procedure ProcessDictionary(aItem: TfrxMacrosItem; aReport: TfrxReport; PostProcessor: TfrxPostProcessor); override;
  published
    property AutoSize: Boolean read FAutoSize write FAutoSize default True;
    property Expression: String read FExpression write FExpression;
    property BarType: TfrxBarcode2DType read FBarType write SetBarType;
    property BarProperties: TfrxBarcode2DProperties read FProp write SetProp;
    property BrushStyle;
    property Color;
    property Cursor;
    property DataField;
    property DataSet;
    property DataSetName;
    property Fill;
    property Frame;
    property HAlign: TfrxHAlign read FHAlign write FHAlign default haLeft;
    property Processing;
    property Rotation: Integer read GetRotation write SetRotation;
    property ShowText: Boolean read GetShowText write SetShowText;
    property TagStr;
    property Text: String read GetText write SetText;
    property URL;
    property Zoom: Extended read GetZoom write SetZoom;
    property Font;
    property FontScaled: Boolean read GetFontScaled write SetFontScaled;
    property ErrorText: String read GetErrorText write SetErrorText;
    property QuietZone: Integer read GetQuietZone write SetQuietZone;
  end;

implementation

uses
{$IFNDEF NO_EDITORS}
  frxBarcodeEditor,
{$ENDIF}
  frxRes, frxUtils, frxDsgnIntf, frxBarcode2DRTTI, Math;

type
  TfrxBarcode2DPropertiesProperty = class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
  end;

  { TfrxBarcode2DView }

function TfrxBarcode2DView.CalcAddSize: TfrxPoint;
begin
  if FontScaled or (not ShowText) then
  begin
    Result.X := 0;
    Result.Y := 0;
  end
  else
  begin
    Result.Y := FBarCode.GetFooterHeight;
    Result.X := 0;
    if (Rotation = 90) or (Rotation = 270) then
    begin
      Result.X := FBarCode.GetFooterHeight;
      Result.Y := 0;
    end;
  end;

  Result.X := -(Result.X * Zoom) + Result.X;
  Result.Y := -(Result.Y * Zoom) + Result.Y;
  if Frame.DropShadow then
  begin
    Result.Y := Result.Y + Round(Frame.ShadowWidth);
    Result.X := Result.X + Round(Frame.ShadowWidth);
  end;
end;

function TfrxBarcode2DView.CalcHeight: Extended;
var
  r: TfrxRect;
  h: Extended;
begin
  { 2D barcode may grow, so we need to emulate strechable object }
  if not AutoSize then
  begin
    Result := Height;
    Exit;
  end;
  h := Height;
  r := GetRealBounds;
  Result := r.Bottom - r.Top;
  Height := h;
end;

procedure TfrxBarcode2DView.CalcSize;
var
  w, h, tmp: Extended;
  Sizes: TfrxPoint;
begin
  case Round(Rotation) of
    0 .. 44:
      Rotation := 0;
    45 .. 135:
      Rotation := 90;
    136 .. 224:
      Rotation := 180;
    225 .. 315:
      Rotation := 270;
  else
    Rotation := 0;
  end;
  FBarCode.Font.Assign(Font);
  w := FBarCode.Width;
  h := FBarCode.Height;

  if (Rotation = 90) or (Rotation = 270) then
  begin
    tmp := w;
    w := h;
    h := tmp;
  end;
  Sizes := CalcAddSize;
  Height := h * Zoom + Sizes.Y;
  Width := w * Zoom + Sizes.X;
end;

constructor TfrxBarcode2DView.Create(AOwner: TComponent);
begin
  inherited;
  FBarCode := TfrxBarcodePDF417.Create;
  FBarType := bcCodePDF417;
  FBarCode.Font.Assign(Font);
  Width := 0;
  Height := 0;
  FProp := TfrxPDF417Properties.Create;
  FProp.SetWhose(FBarCode);
  StretchMode := smActualHeight;
  FAutoSize := True;
end;

constructor TfrxBarcode2DView.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  inherited;
  BarType := TfrxBarcode2DType(Flags);
end;

destructor TfrxBarcode2DView.Destroy;
begin
  FBarCode.Free;
  FProp.Free;
  inherited Destroy;
end;

procedure TfrxBarcode2DView.SetProp(v: TfrxBarcode2DProperties);
begin
  FProp.Assign(v);
end;

procedure TfrxBarcode2DView.SaveContentToDictionary(aReport: TfrxReport;
  PostProcessor: TfrxPostProcessor);
var
  s: String;
  bName: String;
  Index: Integer;
begin
  bName := '';
  if Assigned(Parent) then
    bName := Parent.Name;
  s := Text;
  Index := PostProcessor.Add(bName, Name, s, Processing.ProcessAt, Self,
    ((Processing.ProcessAt <> paDefault)) and
    (bName <> ''));
  if Index <> -1 then
    Text := IntToStr(Index);
end;

procedure TfrxBarcode2DView.SetBarType(v: TfrxBarcode2DType);
begin
  if FBarType = v then
    Exit;
  FBarType := v;
  FBarCode.Free;
  case v of
    bcCodePDF417:     FBarCode := TfrxBarcodePDF417.Create;
    bcCodeDataMatrix: FBarCode := TfrxBarcodeDataMatrix.Create;
    bcCodeQR:         FBarCode := TfrxBarcodeQR.Create;
    bcCodeAztec:      FBarCode := TfrxBarcodeAztec.Create;
    bcCodeMaxiCode:   FBarCode := TfrxBarcodeMaxiCode.Create;
  end;
  FProp.Free;
  case v of
    bcCodePDF417:     FProp := TfrxPDF417Properties.Create;
    bcCodeDataMatrix: FProp := TfrxDataMatrixProperties.Create;
    bcCodeQR:         FProp := TfrxQRProperties.Create;
    bcCodeAztec:      FProp := TfrxAztecProperties.Create;
    bcCodeMaxiCode:   FProp := TfrxMaxiCodeProperties.Create;
  end;
    FProp.SetWhose(FBarCode);
    if (Tfrxcomponent(self).Report <> nil) and
      (Tfrxcomponent(self).Report.Designer <> nil) then
      TfrxCustomDesigner(Tfrxcomponent(self).Report.Designer).UpdateInspector;
end;

procedure TfrxBarcode2DView.SetZoom(z: Extended);
begin
  FBarCode.Zoom := z;
end;

// возвращаются и устанавливаются соответствующие свойства в FBarcode
function TfrxBarcode2DView.GetZoom: Extended;
begin
  Result := FBarCode.Zoom;
end;

function TfrxBarcode2DView.LoadContentFromDictionary(aReport: TfrxReport;
  aItem: TfrxMacrosItem): Boolean;
var
  ItemIdx: Integer;
  s: String;
begin
  Result := False;
  if (aItem <> nil) and not FMacroLoaded then
    if TryStrToInt(Text, ItemIdx) then
    begin
      s := aItem.Item[ItemIdx];
      if s <> '' then
      begin
        Text := s;
        FMacroLoaded := True;
      end;
    end;
end;

procedure TfrxBarcode2DView.ProcessDictionary(aItem: TfrxMacrosItem;
  aReport: TfrxReport; PostProcessor: TfrxPostProcessor);
var
  sName, s: String;
  Index: Integer;
begin
  Index := aItem.Count - 1;
  s := Text;
  sName := aReport.CurObject;
  try
    aReport.CurObject := Name;
    GetData;
    aItem.Item[Index] := Text;
  finally
    aReport.CurObject := sName;
    Text := s;
  end;
end;

procedure TfrxBarcode2DView.SetRotation(v: Integer);
begin
  FBarCode.Rotation := v;
end;

function TfrxBarcode2DView.GetRotation: Integer;
begin
  Result := FBarCode.Rotation;
end;

procedure TfrxBarcode2DView.SetShowText(v: Boolean);
begin
  FBarCode.ShowText := v;
end;

procedure TfrxBarcode2DView.GetScaleFactor(var ScaleX, ScaleY: Extended);
begin
  inherited;
  ScaleX := Zoom;
  ScaleY := Zoom;
end;

function TfrxBarcode2DView.GetShowText: Boolean;
begin
  Result := FBarCode.ShowText;
end;

procedure TfrxBarcode2DView.SetText(v: String);
begin
  FBarCode.Text := v;
  if not FAutoSize then
    Zoom := Width / FBarCode.Width;
end;

procedure TfrxBarcode2DView.SetWidth(Value: Extended);
var
  Sz: Extended;
begin
  Sz := CalcAddSize.X;
  if not FAutoSize and not SameValue(Value, Width)  then
    Zoom := (Value - Sz) / FBarCode.Width;
  inherited;
end;

function TfrxBarcode2DView.GetText: String;
begin
  Result := FBarCode.Text;
end;

procedure TfrxBarcode2DView.SetFontScaled(v: Boolean);
begin
  FBarCode.FontScaled := v;
end;

procedure TfrxBarcode2DView.SetHeight(Value: Extended);
var
  Sz: Extended;
begin
  Sz := CalcAddSize.Y;
  if not FAutoSize and not SameValue(Value, Height) then
    Zoom := (Value - Sz) / FBarCode.Height;
  inherited;
end;

function TfrxBarcode2DView.GetFontScaled: Boolean;
begin
  Result := FBarCode.FontScaled;
end;

procedure TfrxBarcode2DView.SetErrorText(v: String);
begin
  FBarCode.ErrorText := v;
end;

function TfrxBarcode2DView.GetErrorText: String;
begin
  Result := FBarCode.ErrorText;
end;

procedure TfrxBarcode2DView.SetQuietZone(v: Integer);
begin
  FBarCode.QuietZone := v;
end;

function TfrxBarcode2DView.GetQuietZone: Integer;
begin
  Result := FBarCode.QuietZone;
end;

procedure TfrxBarcode2DView.GetData;
begin
  inherited;
  if IsDataField then
    FBarCode.Text := VarToStr(DataSet.Value[DataField])
  else if FExpression <> '' then
    FBarCode.Text := VarToStr(Report.Calc(FExpression));
  if not FAutoSize then
    Zoom := Width / FBarCode.Width;
end;

class function TfrxBarcode2DView.GetDescription: String;
begin
  Result := frxResources.Get('obBarC');
end;

procedure TfrxBarcode2DView.Draw(Canvas: TCanvas;
  ScaleX, ScaleY, OffsetX, OffsetY: Extended);
var
  DrawRect: TRect;
begin
  if Color = clNone then
    FBarCode.Color := clWhite
  else
    FBarCode.Color := Color;

  // if FHAlign = haRight then
  // Left := Left + SaveWidth - Width
  // else if FHAlign = haCenter then
  // Left := Left + (SaveWidth - Width) / 2;

  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  CalcSize;
  if FBarCode.ErrorText <> '' then
  begin
    with Canvas do
    begin
      Font.Name := 'Arial';
      Font.Size := Round(8 * ScaleY);
      Font.Color := clRed;
      Pen.Color := clBlack;
      DrawRect := Rect(FX + 2, FY + 2, FX1, FY1);
      DrawText(Handle, PChar(FBarCode.ErrorText), Length(FBarCode.ErrorText),
        DrawRect, DT_WORDBREAK);
      exit;
    end;
  end;

  DrawBackground;
  FBarCode.Draw2DBarcode(Canvas, FScaleX, FScaleY, FX, FY);
  DrawFrame;
end;

function TfrxBarcode2DView.DrawPart: Extended;
begin
  Result := Height;
end;

function TfrxBarcode2DView.GetRealBounds: TfrxRect;
var
  extra1, extra2: Integer;
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.Canvas.Lock;
  try
    Draw(bmp.Canvas, 1, 1, 0, 0);
  finally
    bmp.Canvas.Unlock;
  end;

  Result := inherited GetRealBounds;
  extra1 := 0;
  extra2 := 0;

//  if (Rotation = 0) or (Rotation = 180) then
//    begin
//      with bmp.Canvas do
//      begin
//       {Font.Name := 'Arial';
//        Font.Size := 9;
//        Font.Style := []; }
//        Font.Assign(Self.Font);
//        txtWidth := TextWidth(String(FBarcode.Text));
//        if Width < txtWidth then
//          begin
//          extra1 := Round((txtWidth - Width) / 2) + 2;
//          extra2 := extra1;
//          end;
//      end;
//    end;

  case Rotation of
    0:
      begin
        Result.Left := Result.Left - extra1;
        Result.Right := Result.Right + extra2;
      end;
    90:
      begin
        Result.Bottom := Result.Bottom + extra1;
        Result.Top := Result.Top - extra2;
      end;
    180:
      begin
        Result.Left := Result.Left - extra2;
        Result.Right := Result.Right + extra1;
      end;
    270:
      begin
        Result.Bottom := Result.Bottom + extra2;
        Result.Top := Result.Top - extra1;
      end;
  end;

  bmp.Free;
end;

{ TfrxBarcode2DPropertiesProperty }

function TfrxBarcode2DPropertiesProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paSubProperties, paReadOnly]; // no multiselect!
end;

initialization
frxHideProperties(TfrxBarcode2DView, 'StretchMode');
frxPropertyEditors.Register(TypeInfo(TfrxBarcode2DProperties), nil, '',
  TfrxBarcode2DPropertiesProperty);

end.
