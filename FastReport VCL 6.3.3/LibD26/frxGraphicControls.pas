{******************************************}
{                                          }
{             FastReport v6.0              }
{    Basic visual controls for Editors     }
{                                          }
{         Copyright (c) 1998-2018          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxGraphicControls;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  {$IFDEF FPC} LCLProc, LMessages,{$ENDIF}
  SysUtils, Variants, Classes, Graphics;

type
  TfrxSwithcButtonStyle = (sbOn, sbOff);
  TfrxSwithcButton = Class
  private
    FSwitch: Boolean;
    FWidth: Integer;
    FHeight: Integer;
    FOriginWidth: Integer;
    FOriginHeight: Integer;
    FButtonColor: TColor;
    FFrameColor: TColor;
    FFrameWidth: Integer;
    FFillActivateColor: TColor;
    FFillDeactivateColor: TColor;
    FBitmap: TBitmap;
    FOnStyleBitmap: TBitmap;
    FOffStyleBitmap: TBitmap;
    FBackColor: TColor;
    FNeedUpdate: Boolean;
    FTag: Integer;
    FColorTag: TColor;
    procedure SetOriginHeight(const Value: Integer);
    procedure SetSwitch(const Value: Boolean);
    procedure SetBackColor(const Value: TColor);
    procedure SetFillActivateColor(const Value: TColor);
    procedure SetFillDeactivateColor(const Value: TColor);
    procedure SetFrameColor(const Value: TColor);
  public
    constructor Create; overload;
    constructor Create(aOnStyleBitmap: TBitmap; aOffStyleBitmap: TBitmap); overload;
    destructor Destroy; override;
    procedure Draw(aCanvas: TCanvas; aLeft, aTop: Integer);
    property Switch: Boolean read FSwitch write SetSwitch;
    property ButtonColor: TColor read FButtonColor write FButtonColor;
    property BackColor: TColor read FBackColor write SetBackColor;
    property FrameColor: TColor read FFrameColor write SetFrameColor;
    property FillActivateColor: TColor read FFillActivateColor write SetFillActivateColor;
    property FillDeactivateColor: TColor read FFillDeactivateColor write SetFillDeactivateColor;
    property Width: Integer read FOriginWidth;
    property Height: Integer read FOriginHeight write SetOriginHeight;
    property Tag: Integer read FTag write FTag;
    property ColorTag: TColor read FColorTag write FColorTag;
  end;


  TfrxSwitchButtonsPanel = class
  private
    FButtons: TStringList;
    FSwitchOnStyle: TBitmap;
    FSwitchOffStyle: TBitmap;
    FShowCaption: Boolean;
    FShowColors: Boolean;
    FButtonOffsetY: Integer;
    FButtonOffsetX: Integer;
    FColorRectWidth: Integer;
    FColorRectGap: Integer;
    FOnButtonClick: TNotifyEvent;
    FButtonsHeight: Integer;
    FTextWidth: Integer;
    FBackColor: TColor;
    FFont: TFont;
    function GetButton(Index: Integer): TfrxSwithcButton;
    procedure SetShowCaption(const Value: Boolean);
    procedure SetShowColors(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Draw(aCanvas: TCanvas; aLeft, aTop: Integer);
    function CalcHeight: Integer;
    function CalcWidth: Integer;
    function AddButton(sCaption: String): TfrxSwithcButton;
    function IsButtonClicked(X, Y: Integer): TfrxSwithcButton;
    function DoClick(X, Y: Integer): TfrxSwithcButton;
    procedure Clear;
    function Count: Integer;
    procedure SetButtonsHeight(Height: Integer);
    property ShowCaption: Boolean read FShowCaption write SetShowCaption;
    property ShowColors: Boolean read FShowColors write SetShowColors;
    property Button[Index: Integer]: TfrxSwithcButton read GetButton; default;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;


implementation

uses {$IFDEF DELPHI16} System.UITypes, {$ENDIF} Types
  {$IFDEF FPC},GraphType, LCLType, LCLIntf, lazhelper{$ENDIF};

const MaxTextWidth = 100;
const DefColorGap = 4;

{ TfrxSwithcButton }

constructor TfrxSwithcButton.Create;
begin
  FFrameColor := clGray;
  FButtonColor := clGray;
  FFillActivateColor := clSkyBlue;
  FFillDeactivateColor := clSilver;
  FSwitch := False;
  FBackColor := clWhite;
  FBitmap := nil;
  if not(Assigned(FOffStyleBitmap) and Assigned(FOnStyleBitmap)) then
    FBitmap := TBitmap.Create;
  SetOriginHeight(16);
  FNeedUpdate := True;
end;

constructor TfrxSwithcButton.Create(aOnStyleBitmap, aOffStyleBitmap: TBitmap);
begin
  FOffStyleBitmap := aOffStyleBitmap;
  FOnStyleBitmap := aOnStyleBitmap;
  Create;
end;

destructor TfrxSwithcButton.Destroy;
begin
  if Assigned(FBitmap) then
    FreeAndNil(FBitmap);
  inherited;
end;

procedure TfrxSwithcButton.Draw(aCanvas: TCanvas; aLeft, aTop: Integer);
const
  InnerFrameWidth = 2;
var
  LG: {$IFDEF FPC}TLogBrush{$ELSE}LOGBRUSH{$ENDIF};
  hP: HPEN;
  OldPen: HGDIOBJ;
  FillColor, SaveBrushColor, SavePenColor: TColor;
  QuarterW, halfW, Offset, ButtonSize, SavePenWidth, FreeSpaceOffset: Integer;
  dBitmap: TBitmap;

  procedure DrawArcFrame(Canvas: TCanvas; Left, Top: Integer; OffSetX, OffSetY: Integer);
  begin
    Canvas.Arc(Left + OffSetX, Top + OffSetY, Left + halfW - OffSetX,
      Top + FHeight - OffSetY, Left + QuarterW, Top, Left + QuarterW,
      Top + FHeight - OffSetX);
    Canvas.Arc(Left + halfW + OffSetX, Top + OffSetY, Left + FWidth - OffSetX,
      Top + FHeight - OffSetY, Left + FWidth - QuarterW, Left + FWidth,
      Left + FWidth - QuarterW, Top + OffSetX);
    Canvas.MoveTo(Left + QuarterW, Top + OffSetY + 1);
    Canvas.LineTo(Left + FWidth - QuarterW, Top + OffSetY + 1);

    Canvas.MoveTo(Left + QuarterW, Top + FHeight - OffSetY - 1);
    Canvas.LineTo(Left + FWidth - QuarterW, Top + FHeight - OffSetY - 1);
  end;

  procedure DrawOn(Canvas: TCanvas; Left, Top: Integer);
  begin
    FreeSpaceOffset := FFrameWidth * 4 div 3;
    if FreeSpaceOffset < 4 then FreeSpaceOffset := 4;

    LG.lbStyle := BS_SOLID;
    LG.lbColor := FFrameColor;
    LG.lbHatch := 0;
    hP := ExtCreatePen(PS_GEOMETRIC or PS_ENDCAP_ROUND, FFrameWidth,
      LG, 0, nil);
    try
      OldPen := SelectObject(Canvas.Handle, hP);
      Canvas.Pen.Width := FFrameWidth;
      Canvas.Pen.Color := FFrameColor;

      halfW := FWidth div 2;
      QuarterW := FWidth div 4;

      DrawArcFrame(Canvas, Left, Top,  0, 0);
      SelectObject(Canvas.Handle, OldPen);
      OldPen := SelectObject(Canvas.Handle, hP);
      Canvas.Pen.Width := InnerFrameWidth;
      Offset := FFrameWidth div 2 + FreeSpaceOffset;
      Canvas.Pen.Color := FillColor;
      DrawArcFrame(Canvas, Left, Top, Offset, Offset);
      Canvas.Brush.Color := FillColor;
      Canvas.FloodFill(Left + halfW, Top + FHeight div 2,
        Canvas.Pixels[Left + halfW, Top + FHeight div 2], fsSurface);
      SelectObject(Canvas.Handle, OldPen);

      Canvas.Pen.Width := InnerFrameWidth;
      Canvas.Brush.Color := FButtonColor;
      Canvas.Pen.Color := FButtonColor;

      ButtonSize := FHeight - Offset * 2;
      if FillColor = FFillDeactivateColor then
        Canvas.Ellipse(Left + Offset, Top + Offset, Left + Offset + ButtonSize,
          Top + Offset + ButtonSize)
      else
        Canvas.Ellipse(Left + FWidth - Offset - ButtonSize, Top + Offset,
          Left + FWidth - Offset, Top + Offset + ButtonSize);

    finally
      DeleteObject(hP);
    end;
  end;

  procedure DrawOnBitmap(aBitmap: TBitmap);
  begin
    aBitmap.Canvas.Brush.Color := FBackColor;
    aBitmap.Canvas.FillRect(Rect(0, 0, aBitmap.Width, aBitmap.Height));
    DrawOn(aBitmap.Canvas, FFrameWidth div 2, FFrameWidth div 2);
  end;

begin
  FillColor := FFillActivateColor;
  if not Switch then
    FillColor := FFillDeactivateColor;

  SaveBrushColor := aCanvas.Brush.Color;
  SavePenColor := aCanvas.Pen.Color;
  SavePenWidth := aCanvas.Pen.Width;
  try
    if FNeedUpdate then
    begin
      if Assigned(FOffStyleBitmap) and Assigned(FOnStyleBitmap) then
      begin
        FillColor := FFillActivateColor;
        DrawOnBitmap(FOnStyleBitmap);
        FillColor := FFillDeactivateColor;
        DrawOnBitmap(FOffStyleBitmap);
      end
      else
        DrawOnBitmap(FBitmap);
      FNeedUpdate := False;
    end;
    dBitmap := FBitmap;

    if Assigned(FOffStyleBitmap) and Assigned(FOnStyleBitmap) then
    begin
      dBitmap := FOffStyleBitmap;
      if Switch then
        dBitmap := FOnStyleBitmap;
    end;

    SetStretchBltMode(aCanvas.Handle, MAXSTRETCHBLTMODE);
    StretchBlt(aCanvas.Handle, aLeft, aTop, FOriginWidth, FOriginHeight, dBitmap.Canvas.Handle, 0,0,
      dBitmap.Width, dBitmap.Height, SRCCOPY);
  finally
    aCanvas.Brush.Color := SaveBrushColor;
    aCanvas.Pen.Color := SavePenColor;
    aCanvas.Pen.Width := SavePenWidth;
  end;
end;

procedure TfrxSwithcButton.SetBackColor(const Value: TColor);
begin
  if Value <> FBackColor then
    FNeedUpdate := True;
  FBackColor := Value;
end;

procedure TfrxSwithcButton.SetFillActivateColor(const Value: TColor);
begin
  if Value <> FFillActivateColor then
    FNeedUpdate := True;
  FFillActivateColor := Value;
end;

procedure TfrxSwithcButton.SetFillDeactivateColor(const Value: TColor);
begin
  if Value <> FFillDeactivateColor then
    FNeedUpdate := True;
  FFillDeactivateColor := Value;
end;

procedure TfrxSwithcButton.SetFrameColor(const Value: TColor);
begin
  if Value <> FFrameColor then
    FNeedUpdate := True;
  FFrameColor := Value;
end;

procedure TfrxSwithcButton.SetOriginHeight(const Value: Integer);
begin
  if Value = FOriginHeight then Exit;
  FNeedUpdate := True;
  if Value < 8 then
    FOriginHeight := 8
  else
    FOriginHeight := Value;
  FOriginWidth := FOriginHeight * 2;
  FHeight := FOriginHeight * 2;
  if FHeight < 64 then FHeight := 64;

  FFrameWidth := FHeight div 10;
  FWidth := FHeight * 2;
  if Assigned(FBitmap) then
  begin
    FBitmap.Width := FWidth + FFrameWidth;
    FBitmap.Height := FHeight + FFrameWidth;
  end;
  if Assigned(FOffStyleBitmap) and Assigned(FOnStyleBitmap) then
  begin
    FOffStyleBitmap.Width := FWidth + FFrameWidth;
    FOffStyleBitmap.Height := FHeight + FFrameWidth;
    FOnStyleBitmap.Width := FWidth + FFrameWidth;
    FOnStyleBitmap.Height := FHeight + FFrameWidth;
  end;
end;

procedure TfrxSwithcButton.SetSwitch(const Value: Boolean);
begin
  if (Value <> FSwitch) and not(Assigned(FOffStyleBitmap) and Assigned(FOnStyleBitmap)) then
    FNeedUpdate := True;
  FSwitch := Value;
end;

{ TfrxSwitchButtonsPanel }

function TfrxSwitchButtonsPanel.AddButton(sCaption: String): TfrxSwithcButton;
var
  w: Integer;
begin
  Result := TfrxSwithcButton.Create(FSwitchOnStyle, FSwitchOffStyle);
  if FButtons.Count = 0 then
    Result.Height := FButtonsHeight
  else
    Result.FOriginHeight := FButtonsHeight;
  FButtons.AddObject(sCaption, Result);
  Result.BackColor := FBackColor;
  if FShowColors then
    FColorRectWidth := Result.Height div 2; //colored square
  if (sCaption = '') or not FShowCaption then Exit;
  FFont.Height := -((FButtonsHeight * 2) div 3);
  FSwitchOnStyle.Canvas.Font.Assign(FFont);
  w := FSwitchOnStyle.Canvas.TextWidth(sCaption);
  if w > FTextWidth then FTextWidth := w;
  if FTextWidth > MaxTextWidth then FTextWidth := MaxTextWidth;
end;

function TfrxSwitchButtonsPanel.CalcHeight: Integer;
begin
  Result := FButtonOffsetY;
  if FButtons.Count > 0 then
    Result := (Result + TfrxSwithcButton(FButtons.Objects[0]).Height) * FButtons.Count;
  Inc(Result, FButtonOffsetY + 4);
end;

function TfrxSwitchButtonsPanel.CalcWidth: Integer;
begin
  Result := FButtonOffsetX * 2 + FTextWidth + FColorRectWidth + FColorRectGap;
  if FButtons.Count > 0 then
    Result := Result + TfrxSwithcButton(FButtons.Objects[0]).Width;
end;

procedure TfrxSwitchButtonsPanel.Clear;
var
  i: Integer;
begin
  for i := 0 to FButtons.Count - 1 do
    FButtons.Objects[i].Free;
  FButtons.Clear;
  FSwitchOnStyle.FreeImage;
  FSwitchOffStyle.FreeImage;
end;

function TfrxSwitchButtonsPanel.Count: Integer;
begin
  Result := FButtons.Count;
end;

constructor TfrxSwitchButtonsPanel.Create;
begin
  FButtons := TStringList.Create;
  FSwitchOnStyle := TBitmap.Create;
  FSwitchOffStyle := TBitmap.Create;
  FButtonOffsetY := 2;
  FButtonOffsetX := 10;
  FColorRectWidth := 0;
  FButtonsHeight := 16;
  FColorRectGap := 0;
  FBackColor := clWhite;
  FFont := TFont.Create;
  FFont.Name := 'Arial';
end;

destructor TfrxSwitchButtonsPanel.Destroy;
begin
  Clear;
  FreeAndNil(FFont);
  FreeAndNil(FButtons);
  FreeAndNil(FSwitchOnStyle);
  FreeAndNil(FSwitchOffStyle);
  inherited;
end;

function TfrxSwitchButtonsPanel.DoClick(X, Y: Integer): TfrxSwithcButton;
var
  btn: TfrxSwithcButton;
begin
  btn := IsButtonClicked(X, Y);
  if btn <> nil then
  begin
    btn.Switch := not btn.Switch;
    if Assigned(OnButtonClick) then
      OnButtonClick(btn);
  end;
  Result := btn;
end;

procedure TfrxSwitchButtonsPanel.Draw(aCanvas: TCanvas; aLeft, aTop: Integer);
var
  i, w, h: Integer;
  btn: TfrxSwithcButton;
  aRect: TRect;
begin
  w := CalcWidth;
  h := CalcHeight;
  aCanvas.Brush.Color := FBackColor;
  aCanvas.Pen.Color := clBlack;
  aCanvas.Pen.Style := psSolid;
  aCanvas.Pen.Width := 2;
  aCanvas.FillRect(Rect(aLeft, aTop, aLeft + w, aTop + h));
  aCanvas.Rectangle(aLeft, aTop, aLeft + w, aTop + h);

  for i := 0 to FButtons.Count - 1 do
  begin
    btn := TfrxSwithcButton(FButtons.Objects[i]);
    Inc(aTop, FButtonOffsetY);
    aCanvas.Brush.Color := btn.ColorTag;
    aCanvas.Pen.Color := clBlack;
    aCanvas.Pen.Style := psSolid;
    aCanvas.Pen.Width := 1;
    aRect := Rect(aLeft + FButtonOffsetX,
      aTop + (btn.Height div 2 - FColorRectWidth div 2),
      aLeft + FButtonOffsetX + FColorRectWidth,
      aTop + (btn.Height div 2 + FColorRectWidth div 2));
    aCanvas.FillRect(aRect);
    aCanvas.Rectangle(aRect.Left, aRect.Top, aRect.Right, aRect.Bottom);
    aCanvas.Brush.Color := FBackColor;
    aRect := Rect(aRect.Right + FColorRectGap, aTop, aRect.Right + FColorRectGap
      + FTextWidth, aTop + btn.Height);
    aCanvas.Font.Assign(FFont);
    aCanvas.TextRect(aRect, aRect.Left, aRect.Top, FButtons[i]);
    btn.Draw(aCanvas, aLeft + w - btn.Width - FButtonOffsetX, aTop);
    aTop := aTop + btn.Height;
  end;
end;

function TfrxSwitchButtonsPanel.GetButton(Index: Integer): TfrxSwithcButton;
begin
  Result := TfrxSwithcButton(FButtons.Objects[index]);
end;

function TfrxSwitchButtonsPanel.IsButtonClicked(X, Y: Integer): TfrxSwithcButton;
var
  i, w, bX, bY: Integer;
  btn: TfrxSwithcButton;
begin
  btn := nil;
  w := CalcWidth;
  for i := 0 to FButtons.Count - 1 do
  begin
    btn := TfrxSwithcButton(FButtons.Objects[i]);
    bX := w - btn.Width - FButtonOffsetX;
    bY :=  (FButtonOffsetY + btn.Height) * i + FButtonOffsetY;
    if (X >= bX) and (X <= bX + btn.Width) and (Y >= bY) and
      (Y <= bY + btn.Height) then break;
    btn := nil;
  end;
  Result := btn;
end;

procedure TfrxSwitchButtonsPanel.SetButtonsHeight(Height: Integer);
var
  i: Integer;
begin
  if FButtonsHeight = Height then Exit;
  for i := 0 to FButtons.Count - 1 do
    if i = 0 then
    begin
      Button[i].Height := Height;
      FButtonsHeight := Button[i].Height;
    end
    else
      Button[i].Height := FButtonsHeight;
  if FShowColors then
    FColorRectWidth := Height div 2; //colored square
  FFont.Height := -((FButtonsHeight * 2) div 3);
end;

procedure TfrxSwitchButtonsPanel.SetShowCaption(const Value: Boolean);
begin
  FShowCaption := Value;
  if not FShowCaption then FTextWidth := 0;
end;

procedure TfrxSwitchButtonsPanel.SetShowColors(const Value: Boolean);
begin
  FShowColors := Value;
  if not FShowColors then
  begin
    FColorRectWidth := 0;
    FColorRectGap := 0;
  end
  else
    FColorRectGap := DefColorGap;
end;

end.
