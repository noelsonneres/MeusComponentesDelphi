
{******************************************}
{                                          }
{             FastReport v5.0              }
{          Picture Export Filters          }
{                                          }
{         Copyright (c) 1998-2011          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportImage;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows, Messages,
{$ELSE}
  LCLType, LCLIntf,
{$ENDIF}
  SysUtils, Classes, Graphics, frxClass, frxExportBaseDialog
{$IFNDEF FPC}
  , Jpeg
{$ENDIF}
{$IFDEF Delphi6}
  , Variants
{$ENDIF};

{$IFNDEF FPC}
procedure GIFSaveToFile(const FileName: String; const Bitmap: TBitmap);
{$ENDIF}

type

  { TfrxCustomImageExport }

  TfrxCustomImageExport = class(TfrxBaseDialogExportFilter)
  private
    FBitmap: TBitmap;
    FCrop: Boolean;
    FCurrentPage: Integer;
    FJPEGQuality: Integer;
    FMaxX: Integer;
    FMaxY: Integer;
    FMinX: Integer;
    FMinY: Integer;
    FMonochrome: Boolean;
    FResolution: Integer;
    FCurrentRes: Integer;
    FSeparate: Boolean;
    FYOffset: Integer;
    FFileSuffix: String;
    FFirstPage: Boolean;
    FExportNotPrintable: Boolean;
    function SizeOverflow(const Val: Extended): Boolean;
  protected
    FPaperWidth: Double;
    FPaperHeight: Double;
    FDiv: Extended;
    procedure Save;
    procedure SaveToStream(const aStream: TStream); virtual;
    procedure FinishExport; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function Start: Boolean; override;
    procedure Finish; override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;
    function IsProcessInternal: Boolean; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;

    property JPEGQuality: Integer read FJPEGQuality write FJPEGQuality default 90;
    property CropImages: Boolean read FCrop write FCrop default False;
    property Monochrome: Boolean read FMonochrome write FMonochrome default False;
    property Resolution: Integer read FResolution write FResolution;
    property SeparateFiles: Boolean read FSeparate write FSeparate;
    property ExportNotPrintable: Boolean read FExportNotPrintable write FExportNotPrintable;
    property OverwritePrompt;
  end;

{$IFNDEF FPC}
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxEMFExport = class(TfrxCustomImageExport)
  private
    FMetafile: TMetafile;
    FMetafileCanvas: TMetafileCanvas;
  protected
    procedure FinishExport; override;
    procedure SaveToStream(const aStream: TStream); override;
  public
    function Start: Boolean; override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  published
    property CropImages;
    property OverwritePrompt;
  end;
{$ENDIF}

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxBMPExport = class(TfrxCustomImageExport)
  private
  protected
    procedure SaveToStream(const aStream: TStream); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  published
    property CropImages;
    property Monochrome;
    property OverwritePrompt;
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxTIFFExport = class(TfrxCustomImageExport)
{$IFNDEF FPC}
  private
    FMultiImage: Boolean;
    FIsStreamCreated: Boolean;

    { Saves a picture to a TIFF stream.
      Arguments:

        - Split - if set, the picture will be splitted into
          chunks that fit into a standard page (its dimensions are in
          FPaperWidth and FPaperHeight in millimeters)

        - WriteHeader - a TIFF stream is capable to store several
          images. If the first image is being written to a stream,
          WriteHeader must be True. If an additional image is to be
          written to a non empty TIFF stream, then WriteHeader must
          be False. }

    procedure SaveTiffToStream(const Stream: TStream; const Bitmap: TBitmap;
      Split: Boolean; WriteHeader: Boolean = True);
{$ENDIF}
  protected
    procedure SaveToStream(const aStream: TStream); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
{$IFNDEF FPC}
    function Start: Boolean; override;
    procedure Finish; override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
{$ENDIF}
  published
    property CropImages;
    property Monochrome;
    property OverwritePrompt;

    { It's possible to store a few picture in a single TIFF image.
      If MultiPage = True, then all pictures larger than a standard
      print page (its dimensions are stored in FPaperWidth and FPaperHeight
      in millimeters) will be splitted into a few standard pages and
      then saved to the TIFF image. }
{$IFNDEF FPC}
    property MultiImage: Boolean read FMultiImage write FMultiImage default False;
{$ENDIF}
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxJPEGExport = class(TfrxCustomImageExport)
  protected
    procedure SaveToStream(const aStream: TStream); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  published
    property JPEGQuality;
    property CropImages;
    property Monochrome;
    property OverwritePrompt;
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
{$IFNDEF FPC}
  TfrxGIFExport = class(TfrxCustomImageExport)
  protected
    procedure SaveToStream(const aStream: TStream); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  published
    property CropImages;
    property Monochrome;
    property OverwritePrompt;
  end;
{$ENDIF}

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxPNGExport = class(TfrxCustomImageExport)
  protected
    procedure SaveToStream(const aStream: TStream); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
  published
    property CropImages;
    property Monochrome;
    property OverwritePrompt;
  end;

implementation

uses
  frxUtils,
  frxFileUtils,
  frxRes,
  frxIOTransportIntf,
{$IFDEF Delphi12}
  PNGImage,
{$ELSE}
{$IFNDEF FPC}
  frxPNGImage,
{$ENDIF}
{$ENDIF}
  frxrcExports,
{$IFNDEF FPC}
  GIF,
{$ENDIF}
  frxExportImageDialog;

{$IFNDEF FPC}
type

  PDirEntry = ^TDirEntry;
  TDirEntry = record
    _Tag: Word;
    _Type: Word;
    _Count: LongInt;
    _Value: LongInt;
  end;
{$ENDIF}

const
{$IFNDEF FPC}
  EMF_DIV = 0.911;
  TifHeader: array[0..7] of Byte = (
    $49, $49, $2A, $00, $08, $00, $00, $00);
{$ENDIF}
  { Here http://www.fileformat.info/format/bmp/egff.htm
    is written that BMP file can have size up to 32K x 32K }

  MaxBitmapHeight  = 30000;
  MaxBitmapWidth   = 30000;
{$IFNDEF FPC}
  MAXBITSCODES = 12;
  HSIZE = 5003;
  NullString: array[0..3] of Byte = ($00, $00, $00, $00);
  Software: array[0..9] of AnsiChar = ('F', 'a', 's', 't', 'R', 'e', 'p', 'o', 'r', 't');
  code_mask: array [0..16] of cardinal = ($0000, $0001, $0003, $0007, $000F,
    $001F, $003F, $007F, $00FF, $01FF, $03FF, $07FF, $0FFF,
    $1FFF, $3FFF, $7FFF, $FFFF);
  BitsPerSample: array[0..2] of Word = ($0008, $0008, $0008);
  D_BW_C: array[0..13] of TDirEntry = (
    (_Tag: $00FE; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0100; _Type: $0003; _Count: $00000001; _Value: $00000000),
    (_Tag: $0101; _Type: $0003; _Count: $00000001; _Value: $00000000),
    (_Tag: $0102; _Type: $0003; _Count: $00000001; _Value: $00000001),
    (_Tag: $0103; _Type: $0003; _Count: $00000001; _Value: $00000001),
    (_Tag: $0106; _Type: $0003; _Count: $00000001; _Value: $00000001),
    (_Tag: $0111; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0115; _Type: $0003; _Count: $00000001; _Value: $00000001),
    (_Tag: $0116; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0117; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $011A; _Type: $0005; _Count: $00000001; _Value: $00000000),
    (_Tag: $011B; _Type: $0005; _Count: $00000001; _Value: $00000000),
    (_Tag: $0128; _Type: $0003; _Count: $00000001; _Value: $00000002),
    (_Tag: $0131; _Type: $0002; _Count: $0000000A; _Value: $00000000));
  D_COL_C: array[0..14] of TDirEntry = (
    (_Tag: $00FE; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0100; _Type: $0003; _Count: $00000001; _Value: $00000000),
    (_Tag: $0101; _Type: $0003; _Count: $00000001; _Value: $00000000),
    (_Tag: $0102; _Type: $0003; _Count: $00000001; _Value: $00000008),
    (_Tag: $0103; _Type: $0003; _Count: $00000001; _Value: $00000001),
    (_Tag: $0106; _Type: $0003; _Count: $00000001; _Value: $00000003),
    (_Tag: $0111; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0115; _Type: $0003; _Count: $00000001; _Value: $00000001),
    (_Tag: $0116; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0117; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $011A; _Type: $0005; _Count: $00000001; _Value: $00000000),
    (_Tag: $011B; _Type: $0005; _Count: $00000001; _Value: $00000000),
    (_Tag: $0128; _Type: $0003; _Count: $00000001; _Value: $00000002),
    (_Tag: $0131; _Type: $0002; _Count: $0000000A; _Value: $00000000),
    (_Tag: $0140; _Type: $0003; _Count: $00000300; _Value: $00000008));
  D_RGB_C: array[0..14] of TDirEntry = (
    (_Tag: $00FE; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0100; _Type: $0003; _Count: $00000001; _Value: $00000000),
    (_Tag: $0101; _Type: $0003; _Count: $00000001; _Value: $00000000),
    (_Tag: $0102; _Type: $0003; _Count: $00000003; _Value: $00000008),
    (_Tag: $0103; _Type: $0003; _Count: $00000001; _Value: $00000001),
    (_Tag: $0106; _Type: $0003; _Count: $00000001; _Value: $00000002),
    (_Tag: $0111; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0115; _Type: $0003; _Count: $00000001; _Value: $00000003),
    (_Tag: $0116; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $0117; _Type: $0004; _Count: $00000001; _Value: $00000000),
    (_Tag: $011A; _Type: $0005; _Count: $00000001; _Value: $00000000),
    (_Tag: $011B; _Type: $0005; _Count: $00000001; _Value: $00000000),
    (_Tag: $011C; _Type: $0003; _Count: $00000001; _Value: $00000001),
    (_Tag: $0128; _Type: $0003; _Count: $00000001; _Value: $00000002),
    (_Tag: $0131; _Type: $0002; _Count: $0000000A; _Value: $00000000));
{$ENDIF}

{ TfrxCustomImageExport }

constructor TfrxCustomImageExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCrop := True;
  FJPEGQuality := 90;
  FResolution := 96;
  FSeparate := True;
  FExportNotPrintable := False;
  CropImages := False;
  OpenAfterExport := False;
end;

function TfrxCustomImageExport.Start: Boolean;
begin
  CurPage := False;
  FCurrentPage := 0;
  FYOffset := 0;
  if not FSeparate then
  begin
    FBitmap := TBitmap.Create;
    FBitmap.Canvas.Lock;
    try
      FCurrentRes := FBitmap.Canvas.Font.PixelsPerInch;
      FDiv := FResolution / FCurrentRes;
      FBitmap.Canvas.Brush.Color := clWhite;
    finally
      FBitmap.Canvas.Unlock;
    end;
    FBitmap.Monochrome := Monochrome;
    FMaxX := 0;
    FMaxY := 0;
    FFirstPage := True;
  end;
  Result := (FileName <> '') or (Stream <> nil);
end;

procedure TfrxCustomImageExport.StartPage(Page: TfrxReportPage; Index: Integer);
var
  i: Integer;
  h, w: Extended;
begin
  Inc(FCurrentPage);
  if FSeparate then
  begin
    FBitmap := TBitmap.Create;
    FBitmap.Canvas.Lock;
    try
      FCurrentRes := FBitmap.Canvas.Font.PixelsPerInch;
      FDiv := FResolution / FCurrentRes;
      FBitmap.Canvas.Brush.Color := clWhite;
    finally
      FBitmap.Canvas.Unlock;
    end;
    FBitmap.Monochrome := Monochrome;
    FBitmap.Width := Round(Page.Width * FDiv);
    FBitmap.Height := Round(Page.Height * FDiv);
    FMaxX := 0;
    FMaxY := 0;
    FMinX := FBitmap.Width;
    FMinY := FBitmap.Height;
{$IFDEF FPC}
    FBitmap.Canvas.Lock;
    try
      FBitmap.Canvas.FillRect(0, 0, FMinX, FMinY);
    finally
      FBitmap.Canvas.Unlock;
    end;
{$ENDIF}
  end
  else if FFirstpage then
    with FBitmap do
    begin
      w := 0;
      h := 0;

      for i := 0 to Report.PreviewPages.Count - 1 do
        with Report.PreviewPages.Page[i] do
        begin
          if w < Width then
            w := Width;

          h := h + Height;
        end;

      w := w * FDiv;
      h := h * FDiv;

      if SizeOverflow(w) then
        w := MaxBitmapWidth;

      if SizeOverflow(h) then
        h := MaxBitmapHeight;

      Width   := Round(w);
      Height  := Round(h);

      FMinX   := Width;
      FMinY   := Height;
{$IFDEF FPC}
      FBitmap.Canvas.Lock;
      try
        FBitmap.Canvas.FillRect(0, 0, FMinX, FMinY);
      finally
        FBitmap.Canvas.Unlock;
      end;
{$ENDIF}

      FFirstPage := False;
    end;
end;


class function TfrxCustomImageExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxIMGExportDialog;
end;

procedure TfrxCustomImageExport.ExportObject(Obj: TfrxComponent);
var
  z: Integer;
begin
  if (Obj is TfrxView) and (FExportNotPrintable or TfrxView(Obj).Printable) then
  begin
    if Obj.Name <> '_pagebackground' then
    begin
      z := Round(Obj.AbsLeft * FDiv);
      if z < FMinX then
        FMinX := z;
      z := FYOffset + Round(Obj.AbsTop * FDiv);
      if z < FMinY then
        FMinY := z;
      z := Round((Obj.AbsLeft + Obj.Width) * FDiv) + 1;
      if z > FMaxX then
        FMaxX := z;
      z := FYOffset + Round((Obj.AbsTop + Obj.Height) * FDiv) + 1;
      if z > FMaxY then
        FMaxY := z;
    end;
    FBitmap.Canvas.Lock;
    try
      TfrxView(Obj).Draw(FBitmap.Canvas, FDiv, FDiv, 0, FYOffset);
    finally
      FBitmap.Canvas.Unlock;
    end;
  end;
end;

function TfrxCustomImageExport.IsProcessInternal: Boolean;
begin
  Result:= False;
end;

procedure TfrxCustomImageExport.FinishPage(Page: TfrxReportPage; Index: Integer);
begin
  FPaperWidth := Page.PaperWidth;
  FPaperHeight := Page.PaperHeight;

  if FSeparate then
    FinishExport
  else
    FYOffset := FYOffset + Round(Page.Height * FDiv);
end;

procedure TfrxCustomImageExport.Finish;
begin
  if not FSeparate then
    FinishExport;
end;

procedure TfrxCustomImageExport.Save;
  var
  s: TStream;
begin
  if FSeparate then
    FFileSuffix := '.' + IntToStr(FCurrentPage)
  else
    FFileSuffix := '';
  try
    if Stream <> nil then
      s := Stream
    else
      s := IOTransport.GetStream(ChangeFileExt(FileName, FFileSuffix + DefaultExt));
    try
      SaveToStream(s);
      if Stream = nil then
        IOTransport.DoFilterSave(s);
    finally
      if Stream = nil then
        IOTransport.FreeStream(s);
    end;
  except
    on e: Exception do
      case Report.EngineOptions.NewSilentMode of
        simSilent:
          Report.Errors.Add(e.Message);
        simMessageBoxes:
          frxErrorMsg(e.Message);
        simReThrow:
          raise;
      end;
  end;
end;

procedure TfrxCustomImageExport.SaveToStream(const aStream: TStream);
begin
//
end;

procedure TfrxCustomImageExport.FinishExport;
var
  RFrom, RTo: TRect;
begin
  try
    if FCrop then
    begin
      RFrom := Rect(FMinX, FMinY, FMaxX, FMaxY);
      RTo := Rect(0, 0, FMaxX - FMinX, FMaxY - FMinY);
      FBitmap.Canvas.Lock;
      try
        FBitmap.Canvas.CopyRect(RTo, FBitmap.Canvas, RFrom);
      finally
        FBitmap.Canvas.Unlock;
      end;
      FBitmap.Width := FMaxX - FMinX;
      FBitmap.Height := FMaxY - FMinY;
    end;
    Save;
  finally
    FBitmap.Free;
  end;
end;

function TfrxCustomImageExport.SizeOverflow(const Val: Extended): Boolean;
begin
  Result :=  Val > MaxBitmapHeight;
end;

{ TfrxBMPExport }

constructor TfrxBMPExport.Create(AOwner: TComponent);
begin
  inherited;
  FilterDesc := frxResources.Get('BMPexportFilter');
  DefaultExt := '.bmp';
end;

class function TfrxBMPExport.GetDescription: String;
begin
  Result := frxResources.Get('BMPexport');
end;

procedure TfrxBMPExport.SaveToStream(const aStream: TStream);
begin
  inherited;
  FBitmap.SaveToStream(aStream);
end;

{ TfrxTIFFExport }

constructor TfrxTIFFExport.Create(AOwner: TComponent);
begin
  inherited;
  FilterDesc := frxResources.Get('TIFFexportFilter');
  DefaultExt := '.tif';
{$IFNDEF FPC}
  FIsStreamCreated := False;
{$ENDIF}
end;

{$IFNDEF FPC}
procedure TfrxTIFFExport.Finish;
begin
  if not FMultiImage then
  begin
    inherited;
    Exit;
  end;
  if FIsStreamCreated then
  begin
//    Stream.Free;
    IOTransport.FreeStream(Stream);
    Stream := nil;
    FIsStreamCreated := False;
  end;
end;

procedure TfrxTIFFExport.FinishPage(Page: TfrxReportPage; Index: Integer);
begin
  if not FMultiImage then
  begin
    inherited;
    Exit;
  end;
  try
    SaveTiffToStream(Stream, FBitmap, False, FFirstPage);
  finally
    FBitmap.Free;
  end;
  FFirstPage := False;
end;
{$ENDIF}

class function TfrxTIFFExport.GetDescription: String;
begin
  Result := frxResources.Get('TIFFexport');
end;

procedure TfrxTIFFExport.SaveToStream(const aStream: TStream);
{$IFDEF FPC}
var
  Image: TTiffImage;
{$ENDIF}
begin
  try
{$IFNDEF FPC}
    SaveTiffToStream(aStream, FBitmap, MultiImage)
{$ELSE}
    Image := TTiffImage.Create;
    try
      Image.Assign(FBitmap);
      Image.SaveToStream(aStream);
    finally
      Image.Free;
    end;
{$ENDIF}
  except
    on e: Exception do
      case Report.EngineOptions.NewSilentMode of
        simSilent:
          Report.Errors.Add(e.Message);
        simMessageBoxes:
          frxErrorMsg(e.Message);
        simReThrow:
          raise;
      end;
  end;
end;

{$IFNDEF FPC}
procedure TfrxTIFFExport.SaveTIFFToStream(const Stream: TStream; const Bitmap: TBitmap;
  Split: Boolean; WriteHeader: Boolean);

  function Min(a, b: Integer): Integer;
  begin
    if a < b then
      Result := a
    else
      Result := b;
  end;

var
  i, k, x, y: Integer;
  dib_f: Boolean;
  Header, Bits, BitsPtr, TmpBitsPtr, NewBits: PAnsiChar;
  HeaderSize, BitsSize: DWORD;
  Width, Height, DataWidth, BitCount: Integer;
  MapRed, MapGreen, MapBlue: array[0..255, 0..1] of Byte;
  ColTabSize, BmpWidth: Integer;
  Red, Blue, Green: AnsiChar;
  O_XRes, O_YRes, O_Soft, O_Strip, O_Dir, O_BPS: LongInt;
  RGB: Word;
  Res: Word;
  NoOfDirs: array[0..1] of Byte;
  D_BW: array[0..13] of TDirEntry;
  D_COL: array[0..14] of TDirEntry;
  D_RGB: array[0..14] of TDirEntry;
  Res_Value: array[0..7] of Byte;
  Page: TBitmap;
  Source, Dest: TRect;
  NextIfd: Integer;
begin
  if Bitmap.Handle = 0 then
    Exit;

  { split a big image into smaller images that fit
    into a standard print page }
  { remove part in spli condion - doesn't used anymore }
  if Split then
  begin
    Width := Trunc(FPaperWidth / 25.4 * 96) + 1;
    Height := Trunc(FPaperHeight / 25.4 * 96) + 1;

    y := 0;
    repeat
      x := 0;

      repeat
       /// with Source do doesn't work in XE2 and above , compiler bug ???
        begin
          Source.Left := x;
          Source.Top := y;
          Source.Right := Min(x + Width, Bitmap.Width) - 1;
          Source.Bottom := Min(y + Height, Bitmap.Height) - 1;
        end;

        ///with Dest do
        begin
          Dest.Left := 0;
          Dest.Top := 0;
          Dest.Right := Source.Right - Source.Left;
          Dest.Bottom := Source.Bottom - Source.Top;
        end;

        Page := TBitmap.Create;

        with Page do
        begin
          Canvas.Brush.Color := clWhite;
          Monochrome := Monochrome;
//          SetSize(Dest.Right + 1, Dest.Bottom + 1);
          Width := Dest.Right + 1;
          Height := Dest.Bottom + 1;
          Canvas.CopyRect(Dest, Bitmap.Canvas, Source);
        end;

        SaveTiffToStream(Stream, Page, False, WriteHeader);
        WriteHeader := False;
        Page.Free;
        Inc(x, Width);
      until x > Bitmap.Width;

      Inc(y, Height);
    until y > Bitmap.Height;

    Exit;
  end;

  NoOfDirs[1] := 0;
  Res := FResolution * 10;
  Res_Value[0] := Res and $ff;
  Res_Value[1] := Res shr 8;
  Res_Value[2] := 0;
  Res_Value[3] := 0;
  Res_Value[4] := $0A;
  Res_Value[5] := 0;
  Res_Value[6] := 0;
  Res_Value[7] := 0;
  NextIfd := 0;
  GetDIBSizes(Bitmap.Handle, HeaderSize, BitsSize);
  Header := GlobalAllocPtr(GMEM_MOVEABLE or GMEM_SHARE, HeaderSize + BitsSize);
  try
    Bits := Header + HeaderSize;
    dib_f := GetDIB(Bitmap.Handle, Bitmap.Palette, Header^, Bits^);
    if dib_f then
    begin
      Width := PBITMAPINFO(Header)^.bmiHeader.biWidth;
      Height := PBITMAPINFO(Header)^.bmiHeader.biHeight;
      BitCount := PBITMAPINFO(Header)^.bmiHeader.biBitCount;
      NoOfDirs[0] := $0F;
      ColTabSize := 1 shl BitCount;
      BmpWidth := BitsSize div DWORD(Height);

      if not WriteHeader then
        NextIfd := Stream.Size - 4
      else
      begin
        Stream.Write(TifHeader, sizeof(TifHeader));
        NextIfd := 4;
      end;

      if BitCount = 1 then
      begin
        CopyMemory(@D_BW, @D_BW_C, SizeOf(D_BW));
        NoOfDirs[0] := $0E;

        O_XRes := Stream.Position;
        Stream.Write(Res_Value, sizeof(Res_Value));

        O_YRes := Stream.Position;
        Stream.Write(Res_Value, sizeof(Res_Value));

        O_Soft := Stream.Position;
        Stream.Write(Software, sizeof(Software));

        DataWidth := ((Width + 7) div 8);
        O_Strip := Stream.Position;
        if Height < 0 then
          for i := 0 to Height - 1 do
          begin
            BitsPtr := Bits + i * BmpWidth;
            Stream.Write(BitsPtr^, DataWidth);
          end
        else
          for i := 1 to Height do
          begin
            BitsPtr := Bits + (Height - i) * BmpWidth;
            Stream.Write(BitsPtr^, DataWidth);
          end;

        Stream.Write(NullString, sizeof(NullString));

        D_BW[1]._Value := LongInt(Width);
        D_BW[2]._Value := LongInt(abs(Height));
        D_BW[8]._Value := LongInt(abs(Height));
        D_BW[9]._Value := LongInt(DataWidth * abs(Height));
        D_BW[6]._Value := O_Strip;
        D_BW[10]._Value := O_XRes;
        D_BW[11]._Value := O_YRes;
        D_BW[13]._Value := O_Soft;

        O_Dir := Stream.Position;
        Stream.Write(NoOfDirs, sizeof(NoOfDirs));
        Stream.Write(D_BW, sizeof(D_BW));
        Stream.Write(NullString, sizeof(NullString));
      end;
      if BitCount in [4, 8] then
      begin
        CopyMemory(@D_COL, @D_COL_C, SizeOf(D_COL));
        DataWidth := Width;
        if BitCount = 4 then
        begin
          Width := (Width div BitCount) * BitCount;
          if BitCount = 4 then
            DataWidth := Width div 2;
        end;
        D_COL[1]._Value := LongInt(Width);
        D_COL[2]._Value := LongInt(abs(Height));
        D_COL[3]._Value := LongInt(BitCount);
        D_COL[8]._Value := LongInt(Height);
        D_COL[9]._Value := LongInt(DataWidth * abs(Height));
        for i := 0 to ColTabSize - 1 do
        begin
          MapRed[i][1] := PBITMAPINFO(Header)^.bmiColors[i].rgbRed;
          MapRed[i][0] := 0;
          MapGreen[i][1] := PBITMAPINFO(Header)^.bmiColors[i].rgbGreen;
          MapGreen[i][0] := 0;
          MapBlue[i][1] := PBITMAPINFO(Header)^.bmiColors[i].rgbBlue;
          MapBlue[i][0] := 0;
        end;
        D_COL[14]._Count := LongInt(ColTabSize * 3);
        Stream.Write(MapRed, ColTabSize * 2);
        Stream.Write(MapGreen, ColTabSize * 2);
        Stream.Write(MapBlue, ColTabSize * 2);
        O_XRes := Stream.Position;
        Stream.Write(Res_Value, sizeof(Res_Value));
        O_YRes := Stream.Position;
        Stream.Write(Res_Value, sizeof(Res_Value));
        O_Soft := Stream.Position;
        Stream.Write(Software, sizeof(Software));
        O_Strip := Stream.Position;
        if Height < 0 then
          for i := 0 to Height - 1 do
          begin
            BitsPtr := Bits + i * BmpWidth;
            Stream.Write(BitsPtr^, DataWidth);
          end
        else
          for i := 1 to Height do
          begin
            BitsPtr := Bits + (Height - i) * BmpWidth;
            Stream.Write(BitsPtr^, DataWidth);
          end;
        D_COL[6]._Value := O_Strip;
        D_COL[10]._Value := O_XRes;
        D_COL[11]._Value := O_YRes;
        D_COL[13]._Value := O_Soft;
        O_Dir := Stream.Position;
        Stream.Write(NoOfDirs, sizeof(NoOfDirs));
        Stream.Write(D_COL, sizeof(D_COL));
        Stream.Write(NullString, sizeof(NullString));
      end;
      if BitCount = 16 then
      begin
        CopyMemory(@D_RGB, @D_RGB_C, SizeOf(D_RGB));
        D_RGB[1]._Value := LongInt(Width);
        D_RGB[2]._Value := LongInt(Height);
        D_RGB[8]._Value := LongInt(Height);
        D_RGB[9]._Value := LongInt(3 * Width * Height);
        O_XRes := Stream.Position;
        Stream.Write(Res_Value, sizeof(Res_Value));
        O_YRes := Stream.Position;
        Stream.Write(Res_Value, sizeof(Res_Value));
        O_BPS := Stream.Position;
        Stream.Write(BitsPerSample, sizeof(BitsPerSample));
        O_Soft := Stream.Position;
        Stream.Write(Software, sizeof(Software));
        O_Strip := Stream.Position;
        GetMem(NewBits, Width * Height * 3);
        for i := 0 to Height - 1 do
        begin
          BitsPtr := Bits + i * BmpWidth;
          TmpBitsPtr := NewBits + i * Width * 3;
          for k := 0 to Width - 1 do
          begin
            RGB := PWord(BitsPtr)^;
            Blue := AnsiChar((RGB and $1F) shl 3 or $7);
            Green := AnsiChar((RGB shr 5 and $1F) shl 3 or $7);
            Red := AnsiChar((RGB shr 10 and $1F) shl 3 or $7);
            PByte(TmpBitsPtr)^ := Byte(Red);
            PByte(TmpBitsPtr + 1)^ := Byte(Green);
            PByte(TmpBitsPtr + 2)^ := Byte(Blue);
            BitsPtr := BitsPtr + 2;
            TmpBitsPtr := TmpBitsPtr + 3;
          end;
        end;
        for i := 1 to Height do
        begin
          TmpBitsPtr := NewBits + (Height - i) * Width * 3;
          Stream.Write(TmpBitsPtr^, Width * 3);
        end;
        FreeMem(NewBits);
        D_RGB[3]._Value := O_BPS;
        D_RGB[6]._Value := O_Strip;
        D_RGB[10]._Value := O_XRes;
        D_RGB[11]._Value := O_YRes;
        D_RGB[14]._Value := O_Soft;
        O_Dir := Stream.Position;
        Stream.Write(NoOfDirs, sizeof(NoOfDirs));
        Stream.Write(D_RGB, sizeof(D_RGB));
        Stream.Write(NullString, sizeof(NullString));
      end;
      if BitCount in [24, 32] then
      begin
        CopyMemory(@D_RGB, @D_RGB_C, SizeOf(D_RGB));
        D_RGB[1]._Value := LongInt(Width);
        D_RGB[2]._Value := LongInt(Height);
        D_RGB[8]._Value := LongInt(Height);
        D_RGB[9]._Value := LongInt(3 * Width * Height);
        O_XRes := Stream.Position;
        Stream.Write(Res_Value, sizeof(Res_Value));
        O_YRes := Stream.Position;
        Stream.Write(Res_Value, sizeof(Res_Value));
        O_BPS := Stream.Position;
        Stream.Write(BitsPerSample, sizeof(BitsPerSample));
        O_Soft := Stream.Position;
        Stream.Write(Software, sizeof(Software));
        O_Strip := Stream.Position;
        for i := 0 to Height - 1 do
        begin
          BitsPtr := Bits + i * BmpWidth;
          for k := 0 to Width - 1 do
          begin
            Blue := (BitsPtr)^;
            Red := (BitsPtr + 2)^;
            (BitsPtr)^ := Red;
            (BitsPtr + 2)^ := Blue;
            BitsPtr := BitsPtr + BitCount div 8;
          end;
        end;
        if BitCount = 32 then
          for i := 0 to Height - 1 do
          begin
            BitsPtr := Bits + i * BmpWidth;
            TmpBitsPtr := BitsPtr;
            for k := 0 to Width - 1 do
            begin
              (TmpBitsPtr)^ := (BitsPtr)^;
              (TmpBitsPtr + 1)^ := (BitsPtr + 1)^;
              (TmpBitsPtr + 2)^ := (BitsPtr + 2)^;
              TmpBitsPtr := TmpBitsPtr + 3;
              BitsPtr := BitsPtr + 4;
            end;
          end;
        BmpWidth := Trunc(BitsSize / Height);
        if Height < 0 then
          for i := 0 to Height - 1 do
          begin
            BitsPtr := Bits + i * BmpWidth;
            Stream.Write(BitsPtr^, Width * 3);
          end
        else
          for i := 1 to Height do
          begin
            BitsPtr := Bits + (Height - i) * BmpWidth;
            Stream.Write(BitsPtr^, Width * 3);
          end;
        D_RGB[3]._Value := O_BPS;
        D_RGB[6]._Value := O_Strip;
        D_RGB[10]._Value := O_XRes;
        D_RGB[11]._Value := O_YRes;
        D_RGB[14]._Value := O_Soft;
        O_Dir := Stream.Position;
        Stream.Write(NoOfDirs, sizeof(NoOfDirs));
        Stream.Write(D_RGB, sizeof(D_RGB));
        Stream.Write(NullString, sizeof(NullString));
      end;
    end;
  finally
    GlobalFreePtr(Header);
  end;

  Stream.Seek(NextIfd, soFromBeginning);
  Stream.Write(O_Dir, 4);
  Stream.Seek(0, soFromEnd);
end;

function TfrxTIFFExport.Start: Boolean;
begin
 FMultiImage := FMultiImage and not FSeparate;
 if not FMultiImage then
 begin
  Result := inherited Start;
  Exit;
 end;
  CurPage := False;
  FCurrentPage := 0;
  FYOffset := 0;
  Result := (FileName <> '') or (Stream <> nil);
 try
   if Stream = nil then
   begin
//     Stream := TFileStream.Create(ChangeFileExt(FileName, FFileSuffix + '.tif'), fmCreate);
     Stream := IOTransport.GetStream(ChangeFileExt(FileName, FFileSuffix + DefaultExt));
     FIsStreamCreated := True;
   end;
   FFirstPage := True;
  except
    on e: Exception do
      case Report.EngineOptions.NewSilentMode of
        simSilent:        Report.Errors.Add(e.Message);
        simMessageBoxes:  frxErrorMsg(e.Message);
        simReThrow:       raise;
      end;
  end;
end;

procedure TfrxTIFFExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  if not FMultiImage then
  begin
    inherited;
    Exit;
  end;

  Inc(FCurrentPage);
  FBitmap := TBitmap.Create;
  FBitmap.Canvas.Lock;
  try
    FBitmap.Canvas.Brush.Color := clWhite;
    FCurrentRes := FBitmap.Canvas.Font.PixelsPerInch;
    FDiv := FResolution / FCurrentRes;
  finally
    FBitmap.Canvas.Unlock
  end;
  FBitmap.Monochrome := Monochrome;
  FBitmap.Width := Round(Page.Width * FDiv);
  FBitmap.Height := Round(Page.Height * FDiv);
  FMaxX := 0;
  FMaxY := 0;
  FMinX := FBitmap.Width;
  FMinY := FBitmap.Height;
end;
{$ENDIF}

{ TfrxJPEGExport }

constructor TfrxJPEGExport.Create(AOwner: TComponent);
begin
  inherited;
  FilterDesc := frxResources.Get('JPEGexportFilter');
  DefaultExt := '.jpg';
end;

class function TfrxJPEGExport.GetDescription: String;
begin
  Result := frxResources.Get('JPEGexport');
end;

procedure TfrxJPEGExport.SaveToStream(const aStream: TStream);
var
  Image: TJPEGImage;
begin
  try
    Image := TJPEGImage.Create;
    try
      Image.CompressionQuality := FJPEGQuality;
      Image.Assign(FBitmap);
      Image.SaveToStream(aStream);
    finally
      Image.Free;
    end;
  except
    on e: Exception do
      case Report.EngineOptions.NewSilentMode of
        simSilent:
          Report.Errors.Add(e.Message);
        simMessageBoxes:
          frxErrorMsg(e.Message);
        simReThrow:
          raise;
      end;
  end;
end;

{ TfrxGIFExport }
{$IFNDEF FPC}
procedure GIFSaveToFile(const FileName: String; const Bitmap: TBitmap);
var
  f: TFileStream;
begin
  f := TFileStream.Create(FileName, fmCreate);
  try
    GIFSaveToStream(f, Bitmap);
  finally
    f.Free;
  end;
end;

constructor TfrxGIFExport.Create(AOwner: TComponent);
begin
  inherited;
  FilterDesc := frxResources.Get('GifexportFilter');
  DefaultExt := '.gif';
end;

class function TfrxGIFExport.GetDescription: String;
begin
  Result := frxResources.Get('GIFexport');
end;

procedure TfrxGIFExport.SaveToStream(const aStream: TStream);
begin
  try
    GIFSaveToStream(aStream, FBitmap)
  except
    on e: Exception do
      case Report.EngineOptions.NewSilentMode of
        simSilent:
          Report.Errors.Add(e.Message);
        simMessageBoxes:
          frxErrorMsg(e.Message);
        simReThrow:
          raise;
      end;
  end;
end;
{$ENDIF}

{ TfrxEMFExport }
{$IFNDEF FPC}
constructor TfrxEMFExport.Create(AOwner: TComponent);
begin
  inherited;
  FilterDesc := frxResources.Get('EMFexportFilter');
  DefaultExt := '.emf';
end;

class function TfrxEMFExport.GetDescription: String;
begin
  Result := frxResources.Get('EMFexport')
end;

procedure TfrxEMFExport.ExportObject(Obj: TfrxComponent);
var
  z: Integer;
begin
  if (Obj is TfrxView) and (FExportNotPrintable or TfrxView(Obj).Printable) then
  begin
    if Obj.Name <> '_pagebackground' then
    begin
      z := Round(Obj.AbsLeft * FDiv);
      if z < FMinX then
        FMinX := z;
      z := FYOffset + Round(Obj.AbsTop * FDiv);
      if z < FMinY then
        FMinY := z;
      z := Round((Obj.AbsLeft + Obj.Width) * FDiv) + 1;
      if z > FMaxX then
        FMaxX := z;
      z := FYOffset + Round((Obj.AbsTop + Obj.Height) * FDiv) + 1;
      if z > FMaxY then
        FMaxY := z;
    end;
    TfrxView(Obj).Draw(FMetafileCanvas, FDiv, FDiv, 0, FYOffset);
  end;
end;

procedure TfrxEMFExport.FinishExport;
var
  RFrom, RTo: TRect;
begin
  try
    if FCrop then
    begin
      RFrom := Rect(FMinX, FMinY, FMaxX, FMaxY);
      RTo := Rect(0, 0, FMaxX - FMinX, FMaxY - FMinY);
      FMetafileCanvas.CopyRect(RTo, FMetafileCanvas, RFrom);
      FMetafile.Width := FMaxX - FMinX;
      FMetafile.Height := FMaxY - FMinY;
    end;
    Save;
  finally
    FMetafile.Free;
  end;
end;

procedure TfrxEMFExport.SaveToStream(const aStream: TStream);
begin
  FMetafile.SaveToStream(aStream);
end;

function TfrxEMFExport.Start: Boolean;
begin
  CurPage := False;
  FCurrentPage := 0;
  FYOffset := 0;
  if not FSeparate then
  begin
    FMetafile := TMetafile.Create;
    FMetafileCanvas := TMetafileCanvas.Create(FMetafile, 0);
    FDiv := EMF_DIV;
    FMetafileCanvas.Brush.Color := clWhite;
    FMaxX := 0;
    FMaxY := 0;
    FFirstPage := True;
  end;
  Result := (FileName <> '') or (Stream <> nil);
end;

procedure TfrxEMFExport.StartPage(Page: TfrxReportPage; Index: Integer);
var
  i: Extended;
begin
  Inc(FCurrentPage);
  if FSeparate then
  begin
    FMetafile := TMetafile.Create;
    FDiv := EMF_DIV;
    FMetafile.Width := Round(Page.Width * FDiv);
    FMetafile.Height := Round(Page.Height * FDiv);
    FMetafileCanvas := TMetafileCanvas.Create(FMetafile, 0);
    FMetafileCanvas.Brush.Color := clWhite;
    FMaxX := 0;
    FMaxY := 0;
    FMinX := FMetafile.Width;
    FMinY := FMetafile.Height;
  end else
  begin
    if FFirstpage then
    begin
      if FMetafile.Width < Round(Page.Width * FDiv) then
        FMetafile.Width := Round(Page.Width * FDiv);
      i := Page.Height * Report.PreviewPages.Count * FDiv;
      if SizeOverflow(i) then
        i := MaxBitmapHeight;
      FMetafile.Height := Round(i);
      FFirstPage := False;
      FMinX := FMetafile.Width;
      FMinY := FMetafile.Height;
    end;
  end;
end;
{$ENDIF}

{ TfrxPNGExport }

constructor TfrxPNGExport.Create(AOwner: TComponent);
begin
  inherited;
  DefaultExt := '.png';
  FilterDesc := frxResources.Get('PNGexportFilter')
end;

class function TfrxPNGExport.GetDescription: String;
begin
  Result := frxResources.Get('PNGexport')
end;

procedure TfrxPNGExport.SaveToStream(const aStream: TStream);
{$IFNDEF FPC}
{$IFNDEF Delphi12}
type
  TPngImage = TPngObject;
{$ENDIF}
{$ENDIF}
var
  p: {$IFNDEF FPC}TPngImage{$ELSE}TPortableNetworkGraphic{$ENDIF};
//  s: TStream;
begin
  p := {$IFNDEF FPC}TPngImage.Create{$ELSE}TPortableNetworkGraphic.Create{$ENDIF};
  try
    p.Assign(FBitmap);
    p.SaveToStream(aStream);
  finally
    p.Free
  end;
end;

end.
