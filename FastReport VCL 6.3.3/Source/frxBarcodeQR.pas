
{******************************************}
{                                          }
{             FastReport v5.0              }
{                 QR code                  }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxBarcodeQR;


interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  SysUtils, Types, StrUtils, Classes, Graphics, Controls, Forms, Dialogs, frxBarcode2DBase, frxDelphiZXingQRCode;

type
  TfrxBarcodeQR = class( TfrxBarcode2DBase )
  private
    FDelphiZXingQRCode: TDelphiZXingQRCode;
    procedure Generate();
    function GetEncoding: TQRCodeEncoding;
    function GetQuietZone: Integer;
    procedure SetEncoding(const Value: TQRCodeEncoding);
    procedure SetQuietZone(const Value: Integer);
    function GetErrorLevels: TQRErrorLevels;
    procedure SetErrorLevels(const Value: TQRErrorLevels);
    function  GetPixelSize : integer;
    procedure SetPixelSize(v : integer);
    function GetCodepage: Longint;
    procedure SetCodepage(const Value: Longint);
  protected
    procedure SetText( v : string ); override;
  public
    constructor Create; override;
    destructor  Destroy; override;
    procedure   Assign(src: TfrxBarcode2DBase);override;
  published
     property Encoding: TQRCodeEncoding read GetEncoding write SetEncoding;
     property QuietZone: Integer read GetQuietZone write SetQuietZone;
     property ErrorLevels: TQRErrorLevels read GetErrorLevels write SetErrorLevels;
     property PixelSize : integer read GetPixelSize write SetPixelSize;
     property Codepage : Longint read GetCodepage write SetCodepage;
  end;


implementation


{ TfrxBarcodeQR }

procedure TfrxBarcodeQR.Assign(src: TfrxBarcode2DBase);
var
   BSource : TfrxBarcodeQR;
begin
   inherited;
   if src is TfrxBarcodeQR then
   begin
      BSource    := TfrxBarcodeQR( src );
      FHeight    := BSource.FHeight;
      Encoding := BSource.Encoding;
      QuietZone := BSource.QuietZone;
      ErrorLevels := BSource.ErrorLevels;
   end;
end;

constructor TfrxBarcodeQR.Create;
begin
  inherited;
  FDelphiZXingQRCode := TDelphiZXingQRCode.Create;
  FDelphiZXingQRCode.Data := FText;
  PixelWidth := 4;
  PixelHeight := 4;
  QuietZone := 0;
  Generate;
end;

destructor TfrxBarcodeQR.Destroy;
begin
  FDelphiZXingQRCode.Free;
  inherited;
end;

procedure TfrxBarcodeQR.Generate;
var
  stride, x, y, lenBits: Integer;
begin
    FHeight := FDelphiZXingQRCode.Rows;
    FWidth := FDelphiZXingQRCode.Columns;
    lenBits := ((FWidth - 1) div 8 + 1) * FHeight;
    SetLength(FImage, lenBits);
    FillChar(FImage[0],length(FImage),0);
    stride := (FWidth + 7) div 8;

    for x := 0 to FHeight-1 do
    begin
      for y := 0 to FWidth-1 do
        if FDelphiZXingQRCode.IsBlack[y, x] then
          FImage[y * stride + x div 8] := FImage[y * stride + x div 8] or ( 128 shr (x and 7) );
    end;
end;

function TfrxBarcodeQR.GetCodepage: Longint;
begin
  Result := FDelphiZXingQRCode.CodePage;
end;

function TfrxBarcodeQR.GetEncoding: TQRCodeEncoding;
begin
  Result := FDelphiZXingQRCode.Encoding;
end;

function TfrxBarcodeQR.GetErrorLevels: TQRErrorLevels;
begin
  Result := FDelphiZXingQRCode.ErrorLevels;
end;

function TfrxBarcodeQR.GetQuietZone: Integer;
begin
  Result := FDelphiZXingQRCode.QuietZone;
end;

procedure TfrxBarcodeQR.SetCodepage(const Value: Longint);
begin
  FDelphiZXingQRCode.CodePage := Value;
end;

procedure TfrxBarcodeQR.SetEncoding(const Value: TQRCodeEncoding);
begin
  FDelphiZXingQRCode.Encoding := Value;
  Generate;
end;

procedure TfrxBarcodeQR.SetErrorLevels(const Value: TQRErrorLevels);
begin
  FDelphiZXingQRCode.ErrorLevels := Value;
  Generate;
end;

procedure TfrxBarcodeQR.SetQuietZone(const Value: Integer);
begin
  FDelphiZXingQRCode.QuietZone := Value;
  Generate;
end;

procedure TfrxBarcodeQR.SetText(v: string);
begin
  inherited;
  FDelphiZXingQRCode.Data := v;
  Generate;
end;

function TfrxBarcodeQR.GetPixelSize: integer;
begin
  result := FPixelWidth;
end;

procedure TfrxBarcodeQR.SetPixelSize(v : integer);
begin
  FPixelWidth := v;
  FPixelHeight := v;
end;


end.
