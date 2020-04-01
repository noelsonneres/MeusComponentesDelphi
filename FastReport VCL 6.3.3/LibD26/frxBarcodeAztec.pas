{******************************************}
{                                          }
{             FastReport v5.0              }
{               Aztec code                 }
{                                          }
{           Copyright (c) 2015             }
{            by Oleg Adibekov,             }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxBarcodeAztec;

interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  SysUtils, Types, StrUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frxBarcode2DBase, frxDelphiZXIngAztecCode;

type
  TfrxBarcodeAztec = class(TfrxBarcode2DBase)
  private
    function GetPixelSize: integer;
    procedure SetPixelSize(const Value: integer);
    function GetMinECCPercent: integer;
    procedure SetMinECCPercent(const Value: integer);
  protected
    FAztecEncoder: TAztecEncoder;

    procedure Generate;
    procedure SetText(v: string); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(src: TfrxBarcode2DBase); override;
  published
    property PixelSize: integer read GetPixelSize write SetPixelSize;
    property MinECCPercent: integer read GetMinECCPercent
      write SetMinECCPercent;
  end;

implementation

{ TfrxBarcodeAztec }

procedure TfrxBarcodeAztec.Assign(src: TfrxBarcode2DBase);
var
  BarcodeAztec: TfrxBarcodeAztec;
begin
  inherited;
  if src is TfrxBarcodeAztec then
  begin
    BarcodeAztec := src as TfrxBarcodeAztec;

    PixelSize := BarcodeAztec.PixelSize;
    MinECCPercent := BarcodeAztec.MinECCPercent;
  end;
end;

constructor TfrxBarcodeAztec.Create;
begin
  inherited;
  FAztecEncoder := TAztecEncoder.Create;
  FAztecEncoder.Data := FText;

  PixelSize := 4;
  MinECCPercent := DEFAULT_EC_PERCENT;

  Generate;
end;

destructor TfrxBarcodeAztec.Destroy;
begin
  FAztecEncoder.Free;
  inherited;
end;

procedure TfrxBarcodeAztec.Generate;
var
  Stride, h, w, LenBits: integer;
begin
  FWidth := FAztecEncoder.MatrixSize;
  FHeight := FWidth;
  LenBits := ((FWidth - 1) div 8 + 1) * FHeight;
  SetLength(FImage, LenBits);
  FillChar(FImage[0], Length(FImage), 0);
  Stride := (FWidth + 7) div 8;

  for w := 0 to FWidth - 1 do
    for h := 0 to FHeight - 1 do
      if FAztecEncoder.IsBlack[w, h] then
        FImage[w * Stride + h div 8] := FImage[w * Stride + h div 8] or
          (128 shr (h and 7));
end;

function TfrxBarcodeAztec.GetMinECCPercent: integer;
begin
  Result := FAztecEncoder.MinECCPercent;
end;

function TfrxBarcodeAztec.GetPixelSize: integer;
begin
  Result := FPixelWidth;
end;

procedure TfrxBarcodeAztec.SetMinECCPercent(const Value: integer);
begin
  FAztecEncoder.MinECCPercent := Value;
  Generate;
end;

procedure TfrxBarcodeAztec.SetPixelSize(const Value: integer);
begin
  FPixelWidth := Value;
  FPixelHeight := Value;
end;

procedure TfrxBarcodeAztec.SetText(v: string);
begin
  inherited;
  FAztecEncoder.Data := v;
  Generate;
end;

end.

