
{******************************************}
{                                          }
{             FastReport v5.0              }
{              Picture Cache               }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxPictureCache;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frxClass, frxXML
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxCacheItem = packed record
    Segment: Longint;
    Offset: Longint;
  end;
  
  PfrxCacheItem = ^TfrxCacheItem;

  TfrxCacheList = class(TObject)
  private
    function Get(Index: Integer): PfrxCacheItem;
  protected
    FItems: TList;
  protected
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function Add: PfrxCacheItem;
    function Count: Integer;
    property Items[Index: Integer]: PfrxCacheItem read Get; default;
  end;

  TfrxFileStream = class(TFileStream)
  private
    FSz: LongWord;
  public
    function Seek(Offset: Longint; Origin: Word): Longint; override;
{$IFDEF Delphi6}
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
{$ENDIF}
  end;

  TfrxMemoryStream = class(TMemoryStream)
  private
    FSz: LongWord;
  public
    function Seek(Offset: Longint; Origin: Word): Longint; override;
{$IFDEF Delphi6}
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
{$ENDIF}
  end;


  TfrxPictureCache = class(TObject)
  private
    FItems: TfrxCacheList;
    FCacheStreamList: TList;
    FTempFile: TStringList;
    FTempDir: String;
    FUseFileCache: Boolean;
    procedure Add;
    procedure SetTempDir(const Value: String);
    procedure SetUseFileCache(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddPicture(Picture: TfrxPictureView); overload;
    procedure AddPicture(aGraphic: TGraphic; var ImageIndex: Integer); overload;
    procedure GetPicture(Picture: TfrxPictureView); overload;
    procedure GetPicture(aGraphic: TGraphic; ImageIndex: Integer); overload;
    procedure SaveToXML(Item: TfrxXMLItem);
    procedure LoadFromXML(Item: TfrxXMLItem);
    procedure AddSegment;
    property UseFileCache: Boolean read FUseFileCache write SetUseFileCache;
    property TempDir: String read FTempDir write SetTempDir;
  end;


implementation


function frxStreamToString(Stream: TStream; Size: Integer): String;
var
{$IFDEF Delphi12}
    p: PAnsiChar;
{$ELSE}
    p: PChar;
{$ENDIF}
begin
  SetLength(Result, Size * 2);
  GetMem(p, Size);
  Stream.Read(p^, Size);
  BinToHex(p, PChar(@Result[1]), Size);
  FreeMem(p, Size);
end;

procedure frxStringToStream(const s: String; Stream: TStream);
var
  Size: Integer;
{$IFDEF Delphi12}
    p: PAnsiChar;
{$ELSE}
    p: PChar;
{$ENDIF}
begin
  Size := Length(s) div 2;
  GetMem(p, Size);
  HexToBin(PChar(@s[1]), p, Size * 2);
  Stream.Write(p^, Size);
  FreeMem(p, Size);
end;


{ TfrxPictureCache }

constructor TfrxPictureCache.Create;
begin
  FItems := TfrxCacheList.Create;
  FCacheStreamList := TList.Create;
  FTempFile := TStringList.Create;
  FUseFileCache := False;
end;

destructor TfrxPictureCache.Destroy;
begin
  Clear;
  FItems.Free;
  FCacheStreamList.Free;
  FTempFile.Free;
  inherited;
end;

procedure TfrxPictureCache.GetPicture(aGraphic: TGraphic; ImageIndex: Integer);
var
  Size, Offset, Segment: Longint;
  Stream: TStream;
begin
  if (ImageIndex <= 0) or (ImageIndex > FItems.Count) then
    Exit
  else
  begin
    if FCacheStreamList.Count = 0 then
      Exit;

    Segment := Fitems[ImageIndex - 1]^.Segment;
    Offset := FItems[ImageIndex - 1]^.Offset;
    Stream := TStream(FCacheStreamList[Segment]);

    if (ImageIndex < FItems.Count) and (Fitems[ImageIndex]^.Segment = Segment) then
      Size := FItems[ImageIndex]^.Offset - Offset
    else
      Size := Stream.Size - Offset;

    Stream.Position := Offset;

    if FUseFileCache then
      TfrxFileStream(Stream).FSz := Offset + Size
    else
      TfrxMemoryStream(Stream).FSz := Offset + Size;

    aGraphic.LoadFromStream(Stream);

    if FUseFileCache then
      TfrxFileStream(Stream).FSz := 0
    else
      TfrxMemoryStream(Stream).FSz := 0
  end;
end;

procedure TfrxPictureCache.Clear;
begin
  while FCacheStreamList.Count > 0 do
  begin
    TObject(FCacheStreamList[0]).Free;
    FCacheStreamList.Delete(0);
    if FUseFileCache then
    begin
      DeleteFile(FTempFile[0]);
      FTempFile.Delete(0);
    end;
  end;
  FItems.Clear;
end;

procedure TfrxPictureCache.Add;
begin
  if (FCacheStreamList.Count = 0) or (TStream(FCacheStreamList[FCacheStreamList.Count - 1]).Size >= Round(MaxInt - MaxInt/6)) then
    AddSegment;

    with FItems.Add^ do
    begin
      Segment := FCacheStreamList.Count - 1;
      Offset := TStream(FCacheStreamList[FCacheStreamList.Count - 1]).Size;
      TStream(FCacheStreamList[FCacheStreamList.Count - 1]).Position := Offset;
    end;
end;

procedure TfrxPictureCache.AddPicture(Picture: TfrxPictureView);
begin
  if Picture.Picture.Graphic = nil then
    Picture.ImageIndex := 0
  else
  begin
    Picture.ImageIndex := FItems.Count + 1;
    Add;
    Picture.Picture.Graphic.SaveToStream(TStream(FCacheStreamList[FItems[Picture.ImageIndex - 1]^.Segment]));
  end;
end;

procedure TfrxPictureCache.GetPicture(Picture: TfrxPictureView);
var
  Size, Offset, Segment: Longint;
  ImageIndex: Integer;
  Stream: TStream;
begin
  if (Picture.ImageIndex <= 0) or (Picture.ImageIndex > FItems.Count) then
    Picture.Picture.Assign(nil)
  else
  begin
    if FCacheStreamList.Count = 0 then
      Exit;
    ImageIndex := Picture.ImageIndex ;
    Segment := Fitems[ImageIndex - 1]^.Segment;
    Offset := FItems[ImageIndex - 1]^.Offset;
    Stream := TStream(FCacheStreamList[Segment]);

    if (Picture.ImageIndex < FItems.Count) and (Fitems[ImageIndex]^.Segment = Segment) then
      Size := FItems[ImageIndex]^.Offset - Offset
    else
      Size := Stream.Size - Offset;

    Stream.Position := Offset;

    if FUseFileCache then
      TfrxFileStream(Stream).FSz := Offset + Size
    else
      TfrxMemoryStream(Stream).FSz := Offset + Size;

    Picture.LoadPictureFromStream(Stream, False);

    if FUseFileCache then
      TfrxFileStream(Stream).FSz := 0
    else
      TfrxMemoryStream(Stream).FSz := 0
  end;
end;

procedure TfrxPictureCache.LoadFromXML(Item: TfrxXMLItem);
var
  i: Integer;
  xi: TfrxXMLItem;
begin
  Clear;
  for i := 0 to Item.Count - 1 do
  begin
    xi := Item[i];
    Add;
    frxStringToStream(xi.Prop['stream'], TStream(FCacheStreamList[FCacheStreamList.Count - 1]));
  end;
end;

procedure TfrxPictureCache.SaveToXML(Item: TfrxXMLItem);
var
  i, Size: Integer;
  xi: TfrxXMLItem;
begin
  Item.Clear;
  for i := 0 to FCacheStreamList.Count - 1 do
    TStream(FCacheStreamList[i]).Position := 0;
  for i := 0 to FItems.Count - 1 do
  begin
    if (i + 1 < FItems.Count) and (Fitems[i]^.Segment = Fitems[i + 1]^.Segment) then
        Size := Integer(FItems[i + 1]^.Offset) - Integer(FItems[i]^.Offset)
    else
        Size := TStream(FCacheStreamList[FItems[i]^.Segment]).Size - Integer(FItems[i]^.Offset);
    xi := Item.Add;
    xi.Name := 'item';
    xi.Text := 'stream="' + frxStreamToString(TStream(FCacheStreamList[FItems[i]^.Segment]), Size) + '"';
  end;
end;

procedure TfrxPictureCache.SetTempDir(const Value: String);
begin
  if FCacheStreamList.Count = 0 then
    FTempDir := Value;
end;

procedure TfrxPictureCache.SetUseFileCache(const Value: Boolean);
begin
  if FCacheStreamList.Count = 0 then
    FUseFileCache := Value;
end;

procedure TfrxPictureCache.AddPicture(aGraphic: TGraphic; var ImageIndex: Integer);
begin
  if (aGraphic = nil) or ((aGraphic.Width = 0) and (aGraphic.Height = 0)) then
    Exit
  else
  begin
    ImageIndex := FItems.Count + 1;
    Add;
    aGraphic.SaveToStream(TStream(FCacheStreamList[FItems[ImageIndex - 1]^.Segment]));
  end;
end;

procedure TfrxPictureCache.AddSegment;
var
  Stream: TStream;
{$IFDEF FPC}
  Path: String;
  FileName: String;
  AFileHandle: THandle;
{$ELSE}
{$IFDEF Delphi12}
  Path: WideString;
  FileName: WideString;
{$ELSE}
  Path: String[64];
  FileName: String[255];
{$ENDIF}
{$ENDIF}
begin
  if FUseFileCache then
  begin
{$IFDEF Delphi12}
    SetLength(FileName, 255);
{$ENDIF}
    Path := FTempDir;
    if Path = '' then
{$IFDEF Delphi12}
    begin
      SetLength(Path, 255);
      SetLength(Path, GetTempPath(255, @Path[1]));
    end
    else
{$ELSE}
  {$IFDEF FPC}
      Path := GetTempDir(True);
  {$ELSE}
      Path[0] := Chr(GetTempPath(64, @Path[1])) else
  {$ENDIF}
{$ENDIF}
  {$IFDEF FPC}
    if (Path <> '') and (Path[Length(Path)] <> PathDelim) then
      Path := Path + PathDelim;
    FileName := GetTempFileName(Path, 'frPic');
    AFileHandle := FileCreate(FileName);
    if AFileHandle <> -1 then
    begin
      FileClose(AFileHandle);
      Path := FileName;
    end;
{$ELSE}
      Path := Path + #0;
    if (Path <> '') and (Path[Length(Path)] <> '\') then
      Path := Path + '\';
    GetTempFileName(@Path[1], PChar('frPic'), 0, @FileName[1]);
{$IFDEF Delphi12}
    Path := StrPas(PWideChar(@FileName[1]));
{$ELSE}
    Path := StrPas(@FileName[1]);
{$ENDIF}
  {$ENDIF} // FPC
    FTempFile.Add(String(Path));
    Stream := TfrxFileStream.Create(String(Path), fmOpenReadWrite);
    TfrxFileStream(Stream).FSz := 0;
  end
  else
  begin
    Stream := TfrxMemoryStream.Create;
    TfrxMemoryStream(Stream).FSz := 0;
  end;
  FCacheStreamList.Add(Stream);
end;


function TfrxMemoryStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  if (FSz <> 0) and (Offset = 0) and (Origin = soFromEnd) then
    Result := FSz
  else
    Result :=  inherited Seek(Offset, Origin);
end;

{$IFDEF Delphi6}
function TfrxMemoryStream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  if (FSz <> 0) and (Offset = 0) and (Origin = soEnd) then
    Result := FSz
  else
    Result :=  inherited Seek(Offset, Origin);
end;
{$ENDIF}

function TfrxFileStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  if (FSz <> 0) and (Offset = 0) and (Origin = soFromEnd) then
    Result := FSz
  else
    Result := inherited Seek(Offset, Origin);
end;

{$IFDEF Delphi6}
function TfrxFileStream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  if (FSz <> 0) and (Offset = 0) and (Origin = soEnd) then
    Result := FSz
  else
    Result :=  inherited Seek(Offset, Origin);
end;
{$ENDIF}

{ TfrxCacheList }

function TfrxCacheList.Add: PfrxCacheItem;
begin
  GetMem(Result, sizeof(TfrxCacheItem));
  FItems.Add(Result);
end;

procedure TfrxCacheList.Clear;
var
  idx: Integer;
begin
  for idx := 0 to FItems.Count - 1 do
    FreeMem(FItems[idx], sizeof(TfrxCacheItem));
  FItems.Clear;
end;

function TfrxCacheList.Count: Integer;
begin
  Result := FItems.Count;
end;

constructor TfrxCacheList.Create;
begin
  FItems := TList.Create;
end;

destructor TfrxCacheList.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

function TfrxCacheList.Get(Index: Integer): PfrxCacheItem;
begin
  Result := PfrxCacheItem(FItems[Index]);
end;

end.
