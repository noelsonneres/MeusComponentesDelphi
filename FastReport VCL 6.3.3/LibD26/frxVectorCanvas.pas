
{******************************************}
{                                          }
{             FastReport v6.0              }
{            EMF to SVG Export             }
{                                          }
{            Copyright (c) 2018            }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxVectorCanvas;

interface

uses
  Contnrs,
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType, LCLIntf, LCLProc,
{$ENDIF}
  Classes, Types;

{$I frx.inc}

type
  TVectorCanvas = class(TObjectList)
  public
    constructor Create;

    procedure ExtTextOutW(X, Y: Integer; Options: Longint; Rect: PRect;
      Str: Pointer {PWideStr}; Count: Longint; Dx: PInteger);
    procedure ExtTextOutA(X, Y: Integer; Options: Longint; Rect: PRect;
      Str: Pointer {PAnsiStr}; Count: Longint; Dx: PInteger);
  end;

  TCharacterDistance = array of Integer;
  // https://docs.microsoft.com/ru-ru/windows/desktop/api/wingdi/nf-wingdi-exttextoutw
  // https://docs.microsoft.com/ru-ru/windows/desktop/api/wingdi/nf-wingdi-exttextouta

  TVector_ExtTextOut = class
  private
    FX: Integer;
    FY: Integer;
    FOptions: Longint;
    FRect: TRect;
    FDx: TCharacterDistance;
    FStr: WideString;
  public
    constructor Create(AX, AY: Integer; AOptions: Longint; ARect: PRect;
      ACount: Longint; ADx: PInteger);
    destructor Destroy; override;
    function AsString: String;
    function TextLength: Integer;

    property X: Integer read FX;
    property Y: Integer read FY;
    property Options: Longint read FOptions;
    property Rect: TRect read FRect;
    property Dx: TCharacterDistance read FDx;
    property Str: WideString read FStr;
  end;

  TVector_ExtTextOutW = class (TVector_ExtTextOut)
  public
    constructor Create(AX, AY: Integer; AOptions: Longint; ARect: PRect;
      AStr: Pointer {PWideStr}; ACount: Longint; ADx: PInteger);
  end;

  TVector_ExtTextOutA = class (TVector_ExtTextOut)
  public
    constructor Create(AX, AY: Integer; AOptions: Longint; ARect: PRect;
      AStr: Pointer {PAnsiStr}; ACount: Longint; ADx: PInteger);
  end;

implementation

uses
  SysUtils;

{ TVectorCanvas }

constructor TVectorCanvas.Create;
begin
  inherited Create;
  OwnsObjects := True;
end;

procedure TVectorCanvas.ExtTextOutA(X, Y: Integer; Options: Longint; Rect: PRect;
  Str: Pointer {PAnsiStr}; Count: Longint; Dx: PInteger);
begin
  Add(TVector_ExtTextOutA.Create(X, Y, Options, Rect, Str, Count, Dx));
end;

procedure TVectorCanvas.ExtTextOutW(X, Y: Integer; Options: Longint; Rect: PRect;
  Str: Pointer {PWideStr}; Count: Longint; Dx: PInteger);
begin
  Add(TVector_ExtTextOutW.Create(X, Y, Options, Rect, Str, Count, Dx));
end;

{ TVector_ExtTextOutW }

constructor TVector_ExtTextOutW.Create(AX, AY: Integer; AOptions: Longint; ARect: PRect;
  AStr: Pointer {PWideStr}; ACount: Longint; ADx: PInteger);
begin
  inherited Create (AX, AY, AOptions, ARect, ACount, ADx);

  SetLength(FStr, ACount);
  Move(AStr^, FStr[1], ACount * SizeOf(WideChar));
end;

{ TVector_ExtTextOut }

function TVector_ExtTextOut.AsString: String;
var
  st: String;
  i: Integer;
begin
  st := '';
  if Dx <> nil then
    for i := 0 to High(Dx) do
      st := st + ' ' + IntToStr(Dx[i]);
  Result := 'ExtTextOutW' +
    #13#10'  X, Y, Options: ' + IntToStr(X) + ', ' + IntToStr(Y) + ', ' + IntToStr(Options) +
    #13#10'  Rect: ' + IntToStr(Rect.Left) + ' ' + IntToStr(Rect.Top) + ' ' + IntToStr(Rect.Right) + ' ' + IntToStr(Rect.Bottom) +
    #13#10'  Text: ' + Str +
    #13#10'  Dx:' + st;
end;

constructor TVector_ExtTextOut.Create(AX, AY: Integer; AOptions: Longint; ARect: PRect;
  ACount: Longint; ADx: PInteger);
begin
  FX := AX;
  FY := AY;
  FOptions := AOptions;
  FRect := ARect^;

  if Assigned(ADx) then
  begin
    SetLength(FDx, ACount);
    Move(ADx^, FDx[0], ACount * SizeOf(ADx^));
  end
  else
    FDx := nil;
end;

destructor TVector_ExtTextOut.Destroy;
begin
  SetLength(FDx, 0);

  inherited;
end;

function TVector_ExtTextOut.TextLength: Integer;
var
  i: Integer;
begin
  Result := 0;
  if Dx <> nil then
    for i := 0 to High(Dx) do
      Result := Result + Dx[i];
end;

{ TVector_ExtTextOutA }

constructor TVector_ExtTextOutA.Create(AX, AY: Integer; AOptions: Longint; ARect: PRect;
  AStr: Pointer {PAnsiStr}; ACount: Longint; ADx: PInteger);
var
  st: AnsiString;
begin
  inherited Create (AX, AY, AOptions, ARect, ACount, ADx);

  SetLength(st, ACount);
  Move(AStr^, st[1], ACount * SizeOf(AnsiChar));
  FStr := WideString(st);
end;

end.
