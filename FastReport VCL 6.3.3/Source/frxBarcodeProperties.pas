unit frxBarcodeProperties;

interface

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  SysUtils, Classes, Graphics, Types, Controls, Forms, Dialogs, StdCtrls, Menus,
  ExtCtrls,
  frxClass, frxDesgn, frxBarcodePDF417, frxBarcodeDataMatrix, frxBarcodeQR,
  frxDelphiZXingQRCode, frxBarcode2DBase, frxBarcodeAztec, frxBarcodeMaxiCode;

type

{$M+}
  // свойство, добавляемое в рантайме
  TfrxBarcode2DProperties = class(TPersistent)
  private
    FOnChange: TNotifyEvent;
  public
    FWhose: TObject; // чьи свойства
    procedure Changed;
    procedure Assign(Source: TPersistent); override; abstract;
    procedure SetWhose(w: TObject);
  end;

  TfrxPDF417Properties = class(TfrxBarcode2DProperties)
  private
    function GetAspectRatio: Extended;
    function GetColumns: Integer;
    function GetRows: Integer;
    function GetErrorCorrection: PDF417ErrorCorrection;
    function GetCodePage: Integer;
    function GetCompactionMode: PDF417CompactionMode;
    function GetPixelWidth: Integer;
    function GetPixelHeight: Integer;

    procedure SetAspectRatio(v: Extended);
    procedure SetColumns(v: Integer);
    procedure SetRows(v: Integer);
    procedure SetErrorCorrection(v: PDF417ErrorCorrection);
    procedure SetCodePage(v: Integer);
    procedure SetCompactionMode(v: PDF417CompactionMode);
    procedure SetPixelWidth(v: Integer);
    procedure SetPixelHeight(v: Integer);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property AspectRatio: Extended read GetAspectRatio write SetAspectRatio;
    property Columns: Integer read GetColumns write SetColumns;
    property Rows: Integer read GetRows write SetRows;
    property ErrorCorrection: PDF417ErrorCorrection read GetErrorCorrection
      write SetErrorCorrection;
    property CodePage: Integer read GetCodePage write SetCodePage;
    property CompactionMode: PDF417CompactionMode read GetCompactionMode
      write SetCompactionMode;
    property PixelWidth: Integer read GetPixelWidth write SetPixelWidth;
    property PixelHeight: Integer read GetPixelHeight write SetPixelHeight;
  end;

  TfrxDataMatrixProperties = class(TfrxBarcode2DProperties)
  private
    function GetCodePage: Integer;
    function GetPixelSize: Integer;
    function GetSymbolSize: DatamatrixSymbolSize;
    function GetEncoding: DatamatrixEncoding;

    procedure SetCodePage(v: Integer);
    procedure SetPixelSize(v: Integer);
    procedure SetSymbolSize(v: DatamatrixSymbolSize);
    procedure SetEncoding(v: DatamatrixEncoding);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property CodePage: Integer read GetCodePage write SetCodePage;
    property PixelSize: Integer read GetPixelSize write SetPixelSize;
    property SymbolSize: DatamatrixSymbolSize read GetSymbolSize
      write SetSymbolSize;
    property Encoding: DatamatrixEncoding read GetEncoding write SetEncoding;
  end;

  TfrxQRProperties = class(TfrxBarcode2DProperties)
  private
    function GetEncoding: TQRCodeEncoding;
    function GetQuietZone: Integer;
    function GetPixelSize: Integer;
    procedure SetPixelSize(v: Integer);
    procedure SetEncoding(const Value: TQRCodeEncoding);
    procedure SetQuietZone(const Value: Integer);
    function GetErrorLevels: TQRErrorLevels;
    procedure SetErrorLevels(const Value: TQRErrorLevels);
    function GetCodePage: Longint;
    procedure SetCodePage(const Value: Longint);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Encoding: TQRCodeEncoding read GetEncoding write SetEncoding;
    property QuietZone: Integer read GetQuietZone write SetQuietZone;
    property ErrorLevels: TQRErrorLevels read GetErrorLevels
      write SetErrorLevels;
    property PixelSize: Integer read GetPixelSize write SetPixelSize;
    property CodePage: Longint read GetCodePage write SetCodePage;
  end;

  TfrxAztecProperties = class(TfrxBarcode2DProperties)
  private
    function GetMinECCPercent: integer;
    procedure SetMinECCPercent(const Value: integer);
    function GetPixelSize: integer;
    procedure SetPixelSize(const Value: integer);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property MinECCPercent: integer read GetMinECCPercent
      write SetMinECCPercent;
    property PixelSize: integer read GetPixelSize write SetPixelSize;
  end;

  TfrxMaxiCodeProperties = class(TfrxBarcode2DProperties)
  private
    function GetMode: Integer;
    procedure SetMode(const Value: Integer);
//    function GetMinECCPercent: integer;
//    procedure SetMinECCPercent(const Value: integer);
//    function GetPixelSize: integer;
//    procedure SetPixelSize(const Value: integer);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Mode: Integer read GetMode write SetMode;
  end;

implementation

uses Math;

{ TfrxBarcode2DProperties }

procedure TfrxBarcode2DProperties.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TfrxBarcode2DProperties.SetWhose(w: TObject);
begin
  FWhose := w;
end;

{ TfrxPDF417Properties }

procedure TfrxPDF417Properties.Assign(Source: TPersistent);
var
  src: TfrxPDF417Properties;
begin
  if Source is TfrxPDF417Properties then
  begin
    src := TfrxPDF417Properties(Source);
    SetAspectRatio(src.AspectRatio);
    SetColumns(src.Columns);
    SetRows(src.Rows);
    SetErrorCorrection(src.ErrorCorrection);
    SetCodePage(src.CodePage);
    SetCompactionMode(src.CompactionMode);
    SetPixelWidth(src.PixelWidth);
    SetPixelHeight(src.PixelHeight);
    SetWhose(src.FWhose);
  end
  else
    inherited;
end;

function TfrxPDF417Properties.GetAspectRatio: Extended;
begin
  Result := TfrxBarcodePDF417(FWhose).AspectRatio;
end;

function TfrxPDF417Properties.GetCodePage: integer;
begin
  Result := TfrxBarcodePDF417(FWhose).CodePage;
end;

function TfrxPDF417Properties.GetColumns: Integer;
begin
  Result := TfrxBarcodePDF417(FWhose).Columns;
end;

function TfrxPDF417Properties.GetCompactionMode: PDF417CompactionMode;
begin
  Result := TfrxBarcodePDF417(FWhose).CompactionMode;
end;

function TfrxPDF417Properties.GetErrorCorrection: PDF417ErrorCorrection;
begin
  Result := TfrxBarcodePDF417(FWhose).ErrorCorrection;
end;

function TfrxPDF417Properties.GetPixelHeight: Integer;
begin
  Result := TfrxBarcodePDF417(FWhose).PixelHeight;
end;

function TfrxPDF417Properties.GetPixelWidth: Integer;
begin
  Result := TfrxBarcodePDF417(FWhose).PixelWidth;
end;

function TfrxPDF417Properties.GetRows: Integer;
begin
  Result := TfrxBarcodePDF417(FWhose).Rows;
end;

procedure TfrxPDF417Properties.SetAspectRatio(v: Extended);
begin
  TfrxBarcodePDF417(FWhose).AspectRatio := v;
end;

procedure TfrxPDF417Properties.SetCodePage(v: Integer);
begin
  TfrxBarcodePDF417(FWhose).CodePage := v;
end;

procedure TfrxPDF417Properties.SetColumns(v: Integer);
begin
  TfrxBarcodePDF417(FWhose).Columns := v;
end;

procedure TfrxPDF417Properties.SetCompactionMode(v: PDF417CompactionMode);
begin
  TfrxBarcodePDF417(FWhose).CompactionMode := v;
end;

procedure TfrxPDF417Properties.SetErrorCorrection(v: PDF417ErrorCorrection);
begin
  TfrxBarcodePDF417(FWhose).ErrorCorrection := v;
end;

procedure TfrxPDF417Properties.SetPixelHeight(v: Integer);
begin
  TfrxBarcodePDF417(FWhose).PixelHeight := v;
end;

procedure TfrxPDF417Properties.SetPixelWidth(v: Integer);
begin
  TfrxBarcodePDF417(FWhose).PixelWidth := v;
end;

procedure TfrxPDF417Properties.SetRows(v: Integer);
begin
  TfrxBarcodePDF417(FWhose).Rows := v;
end;

{ TfrxDataMatrixProperties }

procedure TfrxDataMatrixProperties.Assign(Source: TPersistent);
var
  src: TfrxDataMatrixProperties;
begin
  if Source is TfrxDataMatrixProperties then
  begin
    src := TfrxDataMatrixProperties(Source);
    SetCodePage(src.CodePage);
    SetPixelSize(src.PixelSize);
    SetSymbolSize(src.SymbolSize);
    SetEncoding(src.Encoding);
  end
  else
    inherited;
end;

function TfrxDataMatrixProperties.GetCodePage: Integer;
begin
  Result := TfrxBarcodeDataMatrix(FWhose).CodePage;
end;

function TfrxDataMatrixProperties.GetEncoding: DatamatrixEncoding;
begin
  Result := TfrxBarcodeDataMatrix(FWhose).Encoding;
end;

function TfrxDataMatrixProperties.GetPixelSize: Integer;
begin
  Result := TfrxBarcodeDataMatrix(FWhose).PixelSize;
end;

function TfrxDataMatrixProperties.GetSymbolSize: DatamatrixSymbolSize;
begin
  Result := TfrxBarcodeDataMatrix(FWhose).SymbolSize;
end;

procedure TfrxDataMatrixProperties.SetCodePage(v: Integer);
begin
  TfrxBarcodeDataMatrix(FWhose).CodePage := v;
end;

procedure TfrxDataMatrixProperties.SetEncoding(v: DatamatrixEncoding);
begin
  TfrxBarcodeDataMatrix(FWhose).Encoding := v;
end;

procedure TfrxDataMatrixProperties.SetPixelSize(v: Integer);
begin
  TfrxBarcodeDataMatrix(FWhose).PixelSize := Max(2, v);
end;

procedure TfrxDataMatrixProperties.SetSymbolSize(v: DatamatrixSymbolSize);
begin
  TfrxBarcodeDataMatrix(FWhose).SymbolSize := v;
end;

{ TfrxQRProperties }

procedure TfrxQRProperties.Assign(Source: TPersistent);
var
  src: TfrxQRProperties;
begin
  if Source is TfrxQRProperties then
  begin
    src := TfrxQRProperties(Source);
    SetEncoding(src.Encoding);
    SetQuietZone(src.QuietZone);
    SetErrorLevels(src.ErrorLevels);
    SetCodePage(src.CodePage);
  end
  else
    inherited;
end;

function TfrxQRProperties.GetCodePage: Longint;
begin
  Result := TfrxBarcodeQR(FWhose).CodePage;
end;

function TfrxQRProperties.GetEncoding: TQRCodeEncoding;
begin
  Result := TfrxBarcodeQR(FWhose).Encoding;
end;

function TfrxQRProperties.GetErrorLevels: TQRErrorLevels;
begin
  Result := TfrxBarcodeQR(FWhose).ErrorLevels;
end;

function TfrxQRProperties.GetPixelSize: Integer;
begin
  Result := TfrxBarcodeQR(FWhose).PixelSize;
end;

function TfrxQRProperties.GetQuietZone: Integer;
begin
  Result := TfrxBarcodeQR(FWhose).QuietZone;
end;

procedure TfrxQRProperties.SetCodePage(const Value: Longint);
begin
  TfrxBarcodeQR(FWhose).CodePage := Value;
end;

procedure TfrxQRProperties.SetEncoding(const Value: TQRCodeEncoding);
begin
  TfrxBarcodeQR(FWhose).Encoding := Value;
end;

procedure TfrxQRProperties.SetErrorLevels(const Value: TQRErrorLevels);
begin
  TfrxBarcodeQR(FWhose).ErrorLevels := Value;
end;

procedure TfrxQRProperties.SetPixelSize(v: integer);
begin
  TfrxBarcodeQR(FWhose).PixelSize := Max(2, v);
end;

procedure TfrxQRProperties.SetQuietZone(const Value: Integer);
begin
  TfrxBarcodeQR(FWhose).QuietZone := Value;
end;

{ TfrxAztecProperties }

procedure TfrxAztecProperties.Assign(Source: TPersistent);
var
  src: TfrxAztecProperties;
begin
  if Source is TfrxAztecProperties then
  begin
    src := Source as TfrxAztecProperties;
    SetMinECCPercent(src.MinECCPercent);
  end
  else
    inherited;
end;

function TfrxAztecProperties.GetMinECCPercent: integer;
begin
  Result := TfrxBarcodeAztec(FWhose).MinECCPercent;
end;

function TfrxAztecProperties.GetPixelSize: integer;
begin
  Result := TfrxBarcodeAztec(FWhose).PixelSize;
end;

procedure TfrxAztecProperties.SetMinECCPercent(const Value: integer);
begin
  TfrxBarcodeAztec(FWhose).MinECCPercent := Value;
end;

procedure TfrxAztecProperties.SetPixelSize(const Value: integer);
begin
  TfrxBarcodeAztec(FWhose).PixelSize := Value;
end;

{ TfrxMaxiCodeProperties }

procedure TfrxMaxiCodeProperties.Assign(Source: TPersistent);
var
  src: TfrxMaxiCodeProperties;
begin
  if Source is TfrxMaxiCodeProperties then
  begin
    src := Source as TfrxMaxiCodeProperties;
    SetMode(src.Mode);
  end
  else
    inherited;
end;

function TfrxMaxiCodeProperties.GetMode: Integer;
begin
  Result := TfrxBarcodeMaxiCode(FWhose).Mode;
end;

procedure TfrxMaxiCodeProperties.SetMode(const Value: Integer);
begin
  TfrxBarcodeMaxiCode(FWhose).Mode := Value;
end;

end.
