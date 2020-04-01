
{******************************************}
{                                          }
{             FastReport v6.0              }
{             Image Converter              }
{                                          }
{         Copyright (c) 1998-2017          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

{$I frx.inc}

unit frxImageConverter;

interface

uses
  Graphics,
  Classes;

type
  TfrxPictureType = (gpPNG, gpBMP,
                     {$IFNDEF FPC}gpEMF, gpWMF,{$ENDIF}
                     gpJPG
                     {$IFNDEF FPC},gpGIF{$ENDIF});

procedure SaveGraphicAs(Graphic: TGraphic; Stream: TStream; PicType: TfrxPictureType); overload;
procedure SaveGraphicAs(Graphic: TGraphic; Path: string; PicType: TfrxPictureType); overload;

function GetPicFileExtension(PicType: TfrxPictureType): string;

implementation

{$IFNDEF FPC}
uses

  {$IFDEF Delphi12}
  PNGImage,
  {$ELSE}
  frxPNGImage,
  {$ENDIF}
  JPEG,
  GIF;

{$ENDIF}

function GetPicFileExtension(PicType: TfrxPictureType): string;
begin
  case PicType of
    gpPNG: Result := 'png';
    gpBMP: Result := 'bmp';
{$IFNDEF FPC}
    gpEMF: Result := 'emf';
    gpWMF: Result := 'wmf';
{$ENDIF}
    gpJPG: Result := 'jpg';
{$IFNDEF FPC}
    gpGIF: Result := 'gif';
{$ENDIF}
    else   Result := '';
  end;
end;

procedure SaveGraphicAs(Graphic: TGraphic; Path: string; PicType: TfrxPictureType);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Path, fmCreate);

  try
    SaveGraphicAs(Graphic, Stream, PicType)
  finally
    Stream.Free
  end
end;

procedure SaveGraphicAs(Graphic: TGraphic; Stream: TStream; PicType: TfrxPictureType);
  {$IFNDEF FPC}
  procedure SaveAsMetafile(Enhanced: Boolean);
  var
    Metafile: TMetafile;
    Canvas: TCanvas;
  begin
    Metafile := TMetafile.Create;

    try
      Metafile.Width := Graphic.Width;
      Metafile.Height := Graphic.Height;
      Metafile.Enhanced := Enhanced;
      Canvas := TMetafileCanvas.Create(Metafile, 0);

      try
        Canvas.Draw(0, 0, Graphic)
      finally
        Canvas.Free
      end;

      Metafile.SaveToStream(Stream);
    finally
      Metafile.Free
    end
  end;
  {$ENDIF}

  procedure SaveAsBitmap(PixFormat: TPixelFormat);
  var
    Image: TBitmap;
  begin
    Image := TBitmap.Create;

    try
      Image.Width := Graphic.Width;
      Image.Height := Graphic.Height;
      Image.PixelFormat := PixFormat;

      Image.TransparentColor := $FFFFFF;
      Image.Canvas.Lock;
      try
        Image.Canvas.Brush.Color := Image.TransparentColor;
        Image.Canvas.FillRect(Image.Canvas.ClipRect);

        Image.Canvas.Draw(0, 0, Graphic);
      finally
        Image.Canvas.Unlock;
      end;
      Image.SaveToStream(Stream);
    finally
      Image.Free
    end
  end;

  procedure SaveAsPNG;
  {$IFNDEF FPC}
  {$IFNDEF Delphi12}
  type
    TPngImage = TPngObject;
  {$ENDIF}
  var
    Image: TPngImage;
  begin
    Image := TPngImage.CreateBlank(COLOR_RGB, 8, Graphic.Width, Graphic.Height);

    try
      Image.TransparentColor := $FFFFFF;
      Image.Canvas.Lock;
      try
        Image.Canvas.Brush.Color := Image.TransparentColor;
        Image.Canvas.FillRect(Image.Canvas.ClipRect);

        Image.Canvas.Draw(0, 0, Graphic);
      finally
        Image.Canvas.Unlock;
      end;
      Image.SaveToStream(Stream);
    finally
      Image.Free
    end
  end;
  {$ELSE}
  var
    Bitmap: TBitmap;
    Image: TPortableNetworkGraphic;
  begin
    Bitmap := TBitmap.Create;

    try
      Bitmap.Width := Graphic.Width;
      Bitmap.Height := Graphic.Height;
      Bitmap.Canvas.Lock;
      try
{$IFDEF FPC}
        Bitmap.Canvas.Brush.Color := clWhite;
        Bitmap.Canvas.FillRect(0, 0, Bitmap.Width, Bitmap.Height);
{$ENDIF}
        Bitmap.Canvas.Draw(0, 0, Graphic);
      finally
        Bitmap.Canvas.Unlock;
      end;

      Image := TPortableNetworkGraphic.Create;

      try
        Image.Assign(Bitmap);
        Image.SaveToStream(Stream);
      finally
        Image.Free
      end
    finally
      Bitmap.Free
    end
end;
{$ENDIF}

  procedure SaveAsJPG;
  var
    Bitmap: TBitmap;
    Image: TJPEGImage;
  begin
    Bitmap := TBitmap.Create;

    try
      Bitmap.Width := Graphic.Width;
      Bitmap.Height := Graphic.Height;
      Bitmap.Canvas.Lock;
      try
{$IFDEF FPC}
        Bitmap.Canvas.Brush.Color := clWhite;
        Bitmap.Canvas.FillRect(0, 0, Bitmap.Width, Bitmap.Height);
{$ENDIF}
        Bitmap.Canvas.Draw(0, 0, Graphic);
      finally
        Bitmap.Canvas.Unlock;
      end;

      Image := TJPEGImage.Create;

      try
        Image.Assign(Bitmap);
        Image.SaveToStream(Stream);
      finally
        Image.Free
      end
    finally
      Bitmap.Free
    end
  end;

  {$IFNDEF FPC}
  procedure SaveAsGIF;
  var
    Bitmap: TBitmap;
  begin
    Bitmap := TBitmap.Create;

    try
      Bitmap.Width := Graphic.Width;
      Bitmap.Height := Graphic.Height;
      Bitmap.Canvas.Lock;
      try
        Bitmap.Canvas.Draw(0, 0, Graphic);
      finally
        Bitmap.Canvas.Unlock;
      end;
      GIFSaveToStream(Stream, Bitmap);
    finally
      Bitmap.Free
    end
  end;
  {$ENDIF}

begin
  case PicType of
    {$IFNDEF FPC}
    gpEMF: SaveAsMetafile(True);
    gpWMF: SaveAsMetafile(False);
    {$ENDIF}
    gpBMP: SaveAsBitmap(pf24bit);
    gpPNG: SaveAsPNG;
    gpJPG: SaveAsJPG;
    {$IFNDEF FPC}
    gpGIF: SaveAsGIF;
    {$ENDIF}
  end;
end;

end.
