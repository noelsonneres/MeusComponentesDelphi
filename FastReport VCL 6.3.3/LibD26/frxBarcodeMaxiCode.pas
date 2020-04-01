
{******************************************}
{                                          }
{             FastReport v6.0              }
{                MaxiCode                  }
{                                          }
{           Copyright (c) 2017             }
{            by Oleg Adibekov,             }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxBarcodeMaxiCode;

interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  SysUtils, Types, StrUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frxBarcode2DBase, frxDelphiMaxiCode;

type
  TfrxBarcodeMaxiCode = class(TfrxBarcode2DBase)
  private
    function GetMode: Integer;
    procedure SetMode(const Value: Integer);
  protected
    FMaxiCodeEncoder: TMaxiCodeEncoder;

    procedure Generate;
    procedure SetText(v: String); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(src: TfrxBarcode2DBase); override;
  published
    property Mode: Integer read GetMode write SetMode;
  end;

implementation

uses
  Math;

{ TfrxBarcodeMaxiCode }

procedure TfrxBarcodeMaxiCode.Assign(src: TfrxBarcode2DBase);
var
  BarcodeMaxiCode: TfrxBarcodeMaxiCode;
begin
  inherited;
  if src is TfrxBarcodeMaxiCode then
  begin
    BarcodeMaxiCode := src as TfrxBarcodeMaxiCode;

    Mode := BarcodeMaxiCode.Mode;
  end;
end;

constructor TfrxBarcodeMaxiCode.Create;
begin
  inherited;

  FMaxiCodeEncoder := TMaxiCodeEncoder.Create;
  FMaxiCodeEncoder.Data := FText;

  PixelWidth := 1;
  PixelHeight := 1;

  Generate;
end;

destructor TfrxBarcodeMaxiCode.Destroy;
begin
  FMaxiCodeEncoder.Free;

  inherited;
end;

procedure TfrxBarcodeMaxiCode.Generate;
var
  Stride, h, w, LenBits: Integer;
  ScanLine: PByteArray;
begin
  FWidth := Max(FMaxiCodeEncoder.Width, FMaxiCodeEncoder.Height);
  FHeight := FWidth;

  LenBits := ((FWidth - 1) div 8 + 1) * FHeight;
  SetLength(FImage, LenBits);
  FillChar(FImage[0], Length(FImage), 0);
  Stride := (FWidth + 7) div 8;

{$IFNDEF LCLGTK2}
// Quick
// под Линукс тут неверно рисует
  for w := 0 to FWidth - 1 do
  begin
    ScanLine := FMaxiCodeEncoder.GetScanLine(w);
    for h := 0 to FHeight - 1 do
      if (ScanLine^[h div 8] and (128 shr (h and 7))) = 0 then // IsBlack[h, w]
        FImage[w * Stride + h div 8] := FImage[w * Stride + h div 8] or
         (128 shr (h and 7));
  end;
{$ELSE}
// Slow
  for w := 0 to FWidth - 1 do
    for h := 0 to FHeight - 1 do
      if FMaxiCodeEncoder.IsBlack[h, w] then
        FImage[w * Stride + h div 8] := FImage[w * Stride + h div 8] or
          (128 shr (h and 7));
{$ENDIF}
end;

function TfrxBarcodeMaxiCode.GetMode: Integer;
begin
  Result := FMaxiCodeEncoder.Mode;
end;

procedure TfrxBarcodeMaxiCode.SetMode(const Value: Integer);
begin
  FMaxiCodeEncoder.Mode := Value;
  Generate;
end;

procedure TfrxBarcodeMaxiCode.SetText(v: String);
begin
  inherited;
  FMaxiCodeEncoder.Data := v;
  Generate;
end;

end.
