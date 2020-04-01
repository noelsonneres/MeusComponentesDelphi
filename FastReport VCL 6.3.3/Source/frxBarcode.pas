
{******************************************}
{                                          }
{             FastReport v5.0              }
{          Barcode Add-in object           }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxBarcode;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}Windows, Messages, {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, frxBarcod, frxClass, ExtCtrls
{$IFDEF FPC}
  , LCLType, LCLIntf, LazarusPackageIntf, LazHelper
{$ENDIF}
{$IFDEF Delphi6}
, Variants{$ENDIF}
;


type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxBarCodeObject = class(TComponent);  // fake component

  TfrxBarCodeView = class(TfrxView)
  private
    FBarCode: TfrxBarCode;
    FBarType: TfrxBarcodeType;
    FCalcCheckSum: Boolean;
    FExpression: String;
    FHAlign: TfrxHAlign;
    FRotation: Integer;
    FShowText: Boolean;
    FTestLine: Boolean;
    FText: String;
    FWideBarRatio: Extended;
    FZoom: Extended;
    FMacroLoaded: Boolean;
    FAutoSize: Boolean;
    FExportExpance: integer;
    procedure BcFontChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    destructor Destroy; override;
    function GetVectorGraphic(DrawFill: Boolean = False): TGraphic; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure GetData; override;
    procedure SetText(Value: String);
    class function GetDescription: String; override;
    function GetRealBounds: TfrxRect; override;

    procedure SaveContentToDictionary(aReport: TfrxReport; PostProcessor: TfrxPostProcessor); override;
    function LoadContentFromDictionary(aReport: TfrxReport; aItem: TfrxMacrosItem): Boolean; override;
    procedure ProcessDictionary(aItem: TfrxMacrosItem; aReport: TfrxReport; PostProcessor: TfrxPostProcessor); override;

    property BarCode: TfrxBarCode read FBarCode;
    function GetExportBounds: TfrxRect; override;
  published
    property AutoSize: Boolean read FAutoSize write FAutoSize default True;
    property BarType: TfrxBarcodeType read FBarType write FBarType;
    property BrushStyle;
    property CalcCheckSum: Boolean read FCalcCheckSum write FCalcCheckSum default False;
    property FillType;
    property Fill;
    property Color;
    property Cursor;
    property DataField;
    property DataSet;
    property DataSetName;
    property Expression: String read FExpression write FExpression;
    property Frame;
    property HAlign: TfrxHAlign read FHAlign write FHAlign default haLeft;
    property Processing;
    property Rotation: Integer read FRotation write FRotation;
    property ShowText: Boolean read FShowText write FShowText default True;
    property TagStr;
    property TestLine: Boolean read FTestLine write FTestLine;
    property Text: String read FText write SetText;
    property URL;
    property WideBarRatio: Extended read FWideBarRatio write FWideBarRatio;
    property Zoom: Extended read FZoom write FZoom;
    property Font;
  end;

{$IFDEF FPC}
//  procedure Register;
{$ENDIF}
implementation

uses
  Math,
{$IFNDEF NO_EDITORS}
  frxBarcodeEditor,
{$ENDIF}
  frxInPlaceEditors,
  frxBarcodeRTTI, frxDsgnIntf, frxRes, frxUtils{$IFNDEF RAD_ED}{$IFNDEF ACADEMIC_ED}, frxBarcode2D{$ENDIF}{$ENDIF};

const
  cbDefaultText = '12345678';


{ TfrxBarCodeView }

constructor TfrxBarCodeView.Create(AOwner: TComponent);
begin
  inherited;
  FBarCode := TfrxBarCode.Create(nil);
  FBarType := bcCode39;
  FShowText := True;
  FTestLine := False;
  FZoom := 1;
  FText := cbDefaultText;
  FWideBarRatio := 2;
  Font.Name := 'Arial';
  Font.Size := 9;
  Font.OnChange := BcFontChanged;
  Font.PixelsPerInch := 96;
  FAutoSize := True;
end;

constructor TfrxBarCodeView.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  inherited;
  BarType := TfrxBarcodeType(Flags);
  if BarType = bcCodeUSPSIntelligentMail then
    FText := '12345678901234567890'
  else if BarType = bcGS1Code128 then
    FText := '(01)12345678901234'
  else
    FText := '12345678';
end;

destructor TfrxBarCodeView.Destroy;
begin
  FBarCode.Free;
  inherited Destroy;
end;

class function TfrxBarCodeView.GetDescription: String;
begin
  Result := frxResources.Get('obBarC');
end;

procedure TfrxBarCodeView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  SaveWidth, aScaleX, aScaleY: Extended;
  ErrorText: String;
  DrawRect: TRect;
  CorrL, CorrR: Integer;
  IsHorizontal: Boolean;
begin
  FBarCode.Angle := FRotation;
  FBarCode.Font.Assign(Font);
  FBarCode.Checksum := FCalcCheckSum;
  FBarCode.Typ := FBarType;
  FBarCode.Ratio := FWideBarRatio;
  if Color = clNone then
    FBarCode.Color := clWhite
  else
    FBarCode.Color := Color;
  IsHorizontal := (FRotation = 0) or (FRotation = 180);

  if IsHorizontal then
    SaveWidth := Width
  else
    SaveWidth := Height;

  FBarCode.Text := AnsiString(FText);
  ErrorText := '';
  if FZoom < 0.0001 then
    FZoom := 1;

  { frame correction for some bacrode types }
  if FBarCode.Typ in [bcCodeUPC_E0, bcCodeUPC_E1, bcCodeUPC_A] then
    CorrR := 9
  else
    CorrR := 0;
  if FBarCode.Typ in [bcCodeEAN13, bcCodeUPC_A] then
    CorrL := 8
  else
    CorrL := 0;

  try
    if AutoSize then
    begin
      if IsHorizontal then
        Width := (FBarCode.Width + CorrL + CorrR) * FZoom
      else
        Height := (FBarCode.Width + CorrL + CorrR) * FZoom;
    end
    else
      if IsHorizontal then
        FZoom := Width / (FBarCode.Width + CorrL + CorrR)
      else
        FZoom := Height / (FBarCode.Width + CorrL + CorrR);
  except
    on e: Exception do
    begin
      if FBarCode.Typ = bcCodeUSPSIntelligentMail then
        FText := '12345678901234567890'
      else if BarCode.Typ = bcGS1Code128 then
        FText := '(01)12345678901234'
      else
        FText := '12345678';
      ErrorText := e.Message;
    end;
  end;

  if FHAlign = haRight then
  begin
    if IsHorizontal then
      Left := Left + SaveWidth - Width
    else
      Top := Top + SaveWidth - Height
  end
  else if FHAlign = haCenter then
  begin
    if IsHorizontal then
      Left := Left + (SaveWidth - Width) / 2
    else
      Top := Top + (SaveWidth - Height) / 2
  end;

  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);

  GetScreenScale(aScaleX, aScaleY);
  DrawBackground;
  if ErrorText = '' then
  begin
    if IsHorizontal then
      FBarCode.DrawBarcode(Canvas, Rect(FX + Round(CorrL * ScaleX), FY,
      FX1 - Round(CorrR * ScaleX), FY1), FShowText, aScaleX, aScaleY)
    else
      FBarCode.DrawBarcode(Canvas, Rect(FX, FY + Round(CorrR * ScaleX),
      FX1, FY1 - Round(CorrL * ScaleX)), FShowText, aScaleX, aScaleY);
    if FTestLine then
      begin
        Canvas.Pen.Color:= FBarCode.ColorBar;
        Canvas.Pen.Width:= Round(2 * ScaleY);
        case Rotation of
          0: begin
               Canvas.MoveTo(FX + Round(CorrL * ScaleX) + 1, FY);
               Canvas.LineTo(FX1 - Round((CorrR + 2) * ScaleX), FY);
             end;
         90: begin
               Canvas.MoveTo(FX + Round(CorrL * ScaleX) + 1, FY);
               Canvas.LineTo(FX + Round(CorrL * ScaleX) + 1, FY1);
             end;
        180: begin
               Canvas.MoveTo(FX + Round(CorrL * ScaleX) + 1, FY1);
               Canvas.LineTo(FX1 - Round((CorrR + 2) * ScaleX), FY1);
             end;
        270: begin
               Canvas.MoveTo(FX1 - Round((CorrR + 2) * ScaleX), FY);
               Canvas.LineTo(FX1 - Round((CorrR + 2) * ScaleX), FY1);
             end;
        end;
      end;
  end
  else
    with Canvas do
    begin
      Font.Name := 'Arial';
      Font.Size := Round(8 * ScaleY);
      Font.Color := clRed;
      DrawRect := Rect(FX + 2, FY + 2, FX1, FY1);
      DrawText(Handle, PChar(ErrorText), Length(ErrorText), DrawRect,
        DT_WORDBREAK);
    end;
  DrawFrame;
end;

function TfrxBarCodeView.GetExportBounds: TfrxRect;
begin
  if (FRotation = 0) or (FRotation = 180) then
    Result := frxRect(AbsLeft - FExportExpance, AbsTop, AbsLeft + Width + FExportExpance, AbsTop + Height)
  else
    Result := frxRect(AbsLeft, AbsTop - FExportExpance, AbsLeft + Width, AbsTop + Height + FExportExpance);
end;

procedure TfrxBarCodeView.GetData;
begin
  inherited;
  if IsDataField then
    FText := VarToStr(DataSet.Value[DataField])
  else if FExpression <> '' then
    FText := VarToStr(Report.Calc(FExpression));
end;

function TfrxBarCodeView.GetRealBounds: TfrxRect;
var
  extra1, extra2, txtWidth: Integer;
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

  if (FRotation = 0) or (FRotation = 180) then
  begin
    with bmp.Canvas do
    begin
      Font.Assign(Self.Font);
      txtWidth := TextWidth(String(FBarcode.Text));
      if Width < txtWidth then
      begin
        extra1 := Round((txtWidth - Width) / 2) + 2;
        extra2 := extra1;
      end;
    end;
  end;

  if FBarType in [bcCodeEAN13, bcCodeUPC_A] then
    extra1 := 8;
  if FBarType in [bcCodeUPC_A, bcCodeUPC_E0, bcCodeUPC_E1] then
    extra2 := 8;
  case FRotation of
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

function TfrxBarCodeView.GetVectorGraphic(DrawFill: Boolean): TGraphic;
var
  Bitmap: TBitmap;
  Graphic: TGraphic;
  Canvas: TCanvas;
  TextWidth, aScaleX, aScaleY: Extended;
  IsHorizontal: Boolean;
  SourceTextWidth, AddW, AddH: Integer;
begin
  GetRealBounds;
  FExportExpance := 0;
  Bitmap := TBitmap.Create;
  Bitmap.Canvas.Lock;
  try
    GetScreenScale(aScaleX, aScaleY);
    Bitmap.Canvas.Font.Assign(Self.Font);
    TextWidth := Bitmap.Canvas.TextWidth(String(FBarcode.Text)) * Zoom;
  finally
    Bitmap.Canvas.Unlock;
    Bitmap.Free;
  end;
  IsHorizontal := (FRotation = 0) or (FRotation = 180);
  Graphic := inherited GetVectorGraphic(DrawFill);
  if IsHorizontal then
    SourceTextWidth := Graphic.Width
  else
    SourceTextWidth := Graphic.Height;

  if SourceTextWidth < TextWidth then
  begin
    FExportExpance := Ceil((TextWidth - SourceTextWidth) / 2);
    Result := TMetafile.Create;
    AddW := 0;
    AddH := 0;
    if IsHorizontal then
      AddW :=  2 * FExportExpance
    else
      AddH :=  2 * FExportExpance;
    Result.Width := Round((Graphic.Width + AddW) * aScaleX);
    Result.Height := Round((Graphic.Height + AddH) * aScaleY);
    TMetafile(Result).Enhanced := True;

    Canvas := TMetafileCanvas.Create(TMetafile(Result), 0);
    Canvas.Lock;
    try
      Canvas.Draw(AddW div 2, AddH div 2, Graphic);
    finally
      Graphic.Free;
      Canvas.Unlock;
      Canvas.Free;
    end;
  end
  else
    Result := Graphic;
end;

function TfrxBarCodeView.LoadContentFromDictionary(aReport: TfrxReport;
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

procedure TfrxBarCodeView.ProcessDictionary(aItem: TfrxMacrosItem;
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

procedure TfrxBarCodeView.SaveContentToDictionary(aReport: TfrxReport;
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

procedure TfrxBarCodeView.BcFontChanged(Sender: TObject);
begin
  if Font.Size > 9 then Font.Size := 9;
end;

procedure TfrxBarCodeView.SetText(Value: String);
begin
  FText := Value;
  if Align in [baCenter, baRight] then
    GetRealBounds;
end;

{$IFDEF FPC}
{procedure RegisterUnitfrxBarcode;
begin
  RegisterComponents('Fast Report 6',[TfrxBarCodeObject]);
end;

procedure Register;
begin
  RegisterUnit('frxBarcode',@RegisterUnitfrxBarcode);
end;}
{$ENDIF}

initialization
{$IFDEF DELPHI16}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfrxBarCodeObject, TControl);
{$ENDIF}

  frxObjects.RegisterCategory('Barcode', nil, 'obCatBarcode', 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, '2_5_interleaved', 'Barcode', 0, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, '2_5_industrial', 'Barcode', 1, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, '2_5_matrix', 'Barcode', 2, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Code39', 'Barcode', 3, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Code39 Extended', 'Barcode', 4, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Code128', 'Barcode', 5, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Code128A', 'Barcode', 6, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Code128B', 'Barcode', 7, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Code128C', 'Barcode', 8, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Code93', 'Barcode', 9, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Code93 Extended', 'Barcode', 10, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'MSI', 'Barcode', 11, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'PostNet', 'Barcode', 12, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'Codabar', 'Barcode', 13, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'EAN8', 'Barcode', 14, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'EAN13', 'Barcode', 15, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'UPC_A', 'Barcode', 16, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'UPC_E0', 'Barcode', 17, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'UPC_E1', 'Barcode', 18, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'UPC_Supp2', 'Barcode', 19, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'UPC_Supp5', 'Barcode', 20, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'EAN128', 'Barcode', 21, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'EAN128A', 'Barcode', 22, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'EAN128B', 'Barcode', 23, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'EAN128C', 'Barcode', 24, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'USPS Intelligent Mail', 'Barcode', 25, 23);
  frxObjects.RegisterObject1(TfrxBarcodeView, nil, 'GS1 Code128', 'Barcode', 26, 23);
{$IFNDEF RAD_ED}
{$IFNDEF ACADEMIC_ED}
  frxObjects.RegisterObject1(TfrxBarcode2DView, nil, 'PDF417', 'Barcode', 0, 23);
  frxObjects.RegisterObject1(TfrxBarcode2DView, nil, 'DataMatrix', 'Barcode', 1, 23);
  frxObjects.RegisterObject1(TfrxBarcode2DView, nil, 'QRCode', 'Barcode', 2, 23);
  frxObjects.RegisterObject1(TfrxBarcode2DView, nil, 'Aztec', 'Barcode', 3, 23);
  frxObjects.RegisterObject1(TfrxBarcode2DView, nil, 'MaxiCode', 'Barcode', 4, 23);
  frxRegEditorsClasses.Register(TfrxBarcode2DView, [TfrxInPlaceDataFiledEditor], [[evDesigner]]);
  frxRegEditorsClasses.Register(TfrxBarcodeView, [TfrxInPlaceDataFiledEditor], [[evDesigner]]);
{$ENDIF}
{$ENDIF}

finalization
  frxObjects.UnRegister(TfrxBarCodeView);
{$IFNDEF RAD_ED}
{$IFNDEF ACADEMIC_ED}
  frxObjects.Unregister(TfrxBarcode2DView);
{$ENDIF}
{$ENDIF}

end.
