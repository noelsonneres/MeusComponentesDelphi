
{******************************************}
{                                          }
{             FastReport v5.0              }
{            Designer controls             }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxDesgnCtrls;

interface

{$I frx.inc}

uses
  SysUtils, {$IFNDEF FPC}Windows, Messages,{$ENDIF}
  Types, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, ImgList, frxClass,
  frxPictureCache
  {$IFDEF FPC}
  , LResources, LCLType, LazHelper, LCLIntf, LazarusPackageIntf
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


const
  ClipboardPrefix: String = '#FR3 clipboard#';

type
  TfrxRulerUnits = (ruCM, ruInches, ruPixels, ruChars);
  TfrxUpdateVirtualLines = procedure (Sender: TObject; Position: Extended) of object;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxRuler = class(TPanel)
  private
    FOffset: Integer;
    FScale: Extended;
    FStart: Integer;
    FUnits: TfrxRulerUnits;
    FPosition: Extended;
    FSize: Integer;
    FGuides: TStrings;
    FVirtualGuid: Extended;
    FMouseDown: Boolean;
    FOnPointerAdded: TNotifyEvent;
    FOnUpdateVirtualLines: TfrxUpdateVirtualLines;
    procedure SetOffset(const Value: Integer);
    procedure SetScale(const Value: Extended);
    procedure SetStart(const Value: Integer);
    procedure SetUnits(const Value: TfrxRulerUnits);
    procedure SetPosition(const Value: Extended);
    procedure WMEraseBackground(var Message: TMessage); message WM_ERASEBKGND;
    procedure SetSize(const Value: Integer);
    procedure DrawArrow(aCanvas: TCanvas; aPos: Integer; BrushColor: TColor);
    procedure DrawHint(aCanvas: TCanvas; aPos: Integer; Value: Extended);
  protected
    procedure DblClick; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    constructor Create(AOwner: TComponent); override;
    procedure MouseLeave;
    procedure Paint; override;
    property Guides: TStrings read FGuides write FGuides;
  published
    property OnPointerAdded: TNotifyEvent read FOnPointerAdded write FOnPointerAdded;
    property OnUpdateVirtualLines: TfrxUpdateVirtualLines read FOnUpdateVirtualLines write FOnUpdateVirtualLines;
    property Offset: Integer read FOffset write SetOffset;
    property Scale: Extended read FScale write SetScale;
    property Start: Integer read FStart write SetStart;
    property Units: TfrxRulerUnits read FUnits write SetUnits default ruPixels;
    property Position: Extended read FPosition write SetPosition;
    property Size: Integer read FSize write SetSize;
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}

  { TfrxScrollBox }

  TfrxScrollBox = class(TScrollBox)
  {$IFDEF FPC}
  private
    FOnAfterScroll: TNotifyEvent;
  {$ENDIF}
  protected
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  {$IFDEF FPC}
    procedure ScrollBy(DeltaX, DeltaY: Integer); override;
  public
    property OnAfterScroll:TNotifyEvent read FOnAfterScroll write FOnAfterScroll;
  {$ENDIF}
  end;

  TfrxCustomSelector = class(TPanel)
  private
    FclWidth: Integer;
    FclHeight: Integer;
    {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
    FSavedIsDown: Boolean;
    FSavedX: Integer;
    FSavedY: Integer;
    {$ENDIF}
    procedure WMEraseBackground(var Message: TMessage); message WM_ERASEBKGND;
  protected
    procedure DrawEdge(X, Y: Integer; IsDown: Boolean); virtual; abstract;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    property SavedX: Integer read FSavedX;
    property SavedY: Integer read FSavedY;
    property SavedIsDown: Boolean read FSavedIsDown;
    {$ENDIF}
  public
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TfrxColorSelector = class(TfrxCustomSelector)
  private
    FColor: TColor;
    FOnColorChanged: TNotifyEvent;
    FBtnCaption: String;
  protected
    procedure DrawEdge(X, Y: Integer; IsDown: Boolean); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    property Color: TColor read FColor write FColor;
    property OnColorChanged: TNotifyEvent read FOnColorChanged write FOnColorChanged;
    property BtnCaption: String read FBtnCaption write FBtnCaption;
  end;

  TfrxLineSelector = class(TfrxCustomSelector)
  private
    FStyle: Byte;
    FOnStyleChanged: TNotifyEvent;
  protected
    procedure DrawEdge(X, Y: Integer; IsDown: Boolean); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    property Style: Byte read FStyle;
    property OnStyleChanged: TNotifyEvent read FOnStyleChanged write FOnStyleChanged;
  end;

  TfrxUndoBuffer = class(TObject)
  private
    FPictureCache: TfrxPictureCache;
    FRedo: TList;
    FUndo: TList;
    function GetRedoCount: Integer;
    function GetUndoCount: Integer;
    procedure SetPictureFlag(ReportComponent: TfrxComponent; Flag: Boolean);
    procedure SetPictures(ReportComponent: TfrxComponent);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddUndo(ReportComponent: TfrxComponent);
    procedure AddRedo(ReportComponent: TfrxComponent);
    procedure GetUndo(ReportComponent: TfrxComponent);
    procedure GetRedo(ReportComponent: TfrxComponent);
    procedure ClearUndo;
    procedure ClearRedo;
    property UndoCount: Integer read GetUndoCount;
    property RedoCount: Integer read GetRedoCount;
    property PictureCache: TfrxPictureCache read FPictureCache write FPictureCache;
  end;

  TfrxClipboard = class(TObject)
  private
    FDesigner: TfrxCustomDesigner;
    FPictureCache: TfrxPictureCache;
    function GetPasteAvailable: Boolean;
    function IsFrxPasteAvailable: Boolean;
  public
    constructor Create(ADesigner: TfrxCustomDesigner);
    procedure Copy;
    function Paste: Boolean;
    property PasteAvailable: Boolean read GetPasteAvailable;
    property PictureCache: TfrxPictureCache read FPictureCache write FPictureCache;
  end;

  TfrxFrameLineClickedEvent = procedure(Line: TfrxFrameType; state: Boolean) of object;

  TfrxFrameSampleControl = class(TCustomControl)
  private
    FFrame: TfrxFrame;
    FOnFrameLineClicked: TfrxFrameLineClickedEvent;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    procedure Paint; override;
    property Frame: TfrxFrame read FFrame write FFrame;
    property OnFrameLineClicked: TfrxFrameLineClickedEvent read FOnFrameLineClicked write FOnFrameLineClicked;
  end;

  TfrxLineStyleControl = class(TCustomControl)
  private
    FStyle: TfrxFrameStyle;
    FOnStyleChanged: TNotifyEvent;
    procedure WMEraseBackground(var Message: TMessage); message WM_ERASEBKGND;
    procedure SetStyle(const Value: TfrxFrameStyle);
  protected
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    property Style: TfrxFrameStyle read FStyle write SetStyle;
    property OnStyleChanged: TNotifyEvent read FOnStyleChanged write FOnStyleChanged;
  end;

  TfrxColorComboBox = class(TCustomControl)
  private
    FCombo: TComboBox;
    FColor: TColor;
    FShowColorName: Boolean;
    FOnColorChanged: TNotifyEvent;
    FBlockPopup: Boolean;
    procedure SetColor(const Value: TColor);
    procedure SetShowColorName(const Value: Boolean);
    procedure ColorChanged(Sender: TObject);
  protected
    procedure SetEnabled(Value: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property Color: TColor read FColor write SetColor;
    property ShowColorName: Boolean read FShowColorName write SetShowColorName;
    property OnColorChanged: TNotifyEvent read FOnColorChanged write FOnColorChanged;
  end;


{$IFDEF FPC}
//  procedure Register;
{$ENDIF}

implementation

uses
  frxDMPClass, frxPopupForm, frxDsgnIntf, frxCtrls, frxXMLSerializer, Clipbrd,
  frxUtils, frxXML, frxRes;

const
  PrivateColors: array[0..47] of TColor =
    (clNone, clWhite, clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple,
     clGray, clSilver, clTeal, clRed, clLime, clYellow, clBlue, clFuchsia,
     $CCCCCC, $E4E4E4, clAqua, $00CCFF, $00CC98, $98FFFF, $FFCC00, $FF98CC,
     $D8D8D8, $F0F0F0, $FFFFDC, $CAE4FF, $CCFFCC, $CCFFFF, $FFF4CC, $CC98FF,
     clBtnFace, $46DAFF, $9BEBFF, $00A47B, $FDBD97, $FED3BA, $6ACFFF, $FFF4CC,
     clBtnFace, clBtnFace, clBtnFace, clBtnFace, clBtnFace, clBtnFace, clBtnFace, clBtnFace);

type
  THackControl = class(TWinControl);


{ TfrxRuler }

function CreateRotatedFont(Font: TFont): HFont;
var
  F: TLogFont;
begin
  GetObject(Font.Handle, SizeOf(TLogFont), @F);
  F.lfEscapement := 90 * 10;
  F.lfOrientation := 90 * 10;
  Result := CreateFontIndirect(F);
end;

procedure TfrxRuler.CMMouseLeave(var Message: TMessage);
begin
  Inherited;
  MouseLeave;
end;

constructor TfrxRuler.Create(AOwner: TComponent);
begin
  inherited;
  FScale := 1;
  DoubleBuffered := True;
  FVirtualGuid := 0;
end;

procedure TfrxRuler.WMEraseBackground(var Message: TMessage);
begin
//
end;

procedure TfrxRuler.DblClick;
begin
  inherited;

end;

procedure TfrxRuler.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited;
  FMouseDown := False;
end;

procedure TfrxRuler.DrawArrow(aCanvas: TCanvas; aPos: Integer; BrushColor: TColor);
begin
  Canvas.Brush.Color := BrushColor;
  Canvas.Brush.Style := bsSolid;
  if Align = alLeft then
    Canvas.Polygon([Point(Width - 12, aPos - 5), Point(Width - 7, aPos - 5),
      Point(Width - 2, aPos), Point(Width - 7, aPos + 5), Point(Width - 12, aPos + 5),
      Point(Width - 12, aPos - 5)])
  else
    Canvas.Polygon([Point(aPos - 5, Height - 12), Point(aPos - 5, Height - 7),
      Point(aPos, Height - 2), Point(aPos + 5, Height - 7), Point(aPos + 5, Height - 12),
      Point(aPos - 5, Height - 12)]);

end;

procedure TfrxRuler.DrawHint(aCanvas: TCanvas; aPos: Integer; Value: Extended);
var
  hTop: Integer;
  TextSize: TSize;
  r: TRect;
  fh, oldfh: HFont;
  lText: String;
  eChar: Extended;
begin
// TODO move all the constants in general file
  fh := 0; oldfh := 0;
  if Align = alLeft then
    eChar := fr1CharY
  else
    eChar := fr1CharX;
  case FUnits of
    ruCM: lText := Format(' %2.2f cm ', [Value / fr1cm]);
    ruInches: lText := Format(' %2.2f in ', [Value / fr1in]);
    ruPixels: lText := Format(' %2.2f pt ', [Value]);
    ruChars: lText := Format(' %2.2f ch ', [Value / eChar]);
  end;

  TextSize := Canvas.TextExtent(lText);

  if Align = alLeft then
  begin
    hTop := (Width - TextSize.cy) div 2;
    r := Rect(hTop - 1, aPos - 12 - TextSize.cx, hTop + 1 + TextSize.cy, aPos - 8);
    fh := CreateRotatedFont(Font);
    oldfh := SelectObject(Handle, fh);
  end
  else
  begin
    hTop := (Height - TextSize.cy) div 2;
    r := Rect(aPos + 8, hTop - 1, aPos + 12 + TextSize.cx, hTop + 1 + TextSize.cy);
  end;
  Canvas.Brush.Color := clCream;
  Canvas.Pen.Color := clBlack;
  Canvas.FillRect(r);
  Canvas.Brush.Color := clBlack;
  Canvas.FrameRect(r);
  Canvas.Brush.Style := bsClear;


  if Align = alLeft then
  begin
    Canvas.TextOut(r.Left + 1, r.Bottom - 2, lText);
    SelectObject(Canvas.Handle, oldfh);
    DeleteObject(fh);
  end
  else
    Canvas.TextOut(r.Left + 2, r.Top + 1, lText);
end;

procedure TfrxRuler.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  i, d: Integer;
begin
  inherited;
  FMouseDown := True;
  if (FGuides = nil) then Exit;
  if (ssDouble in Shift) and (Button = mbLeft) then
    FGuides.Add(frxFloatToStr(Position))
  else if (Button = mbRight) then
    for I := FGuides.Count - 1 downto 0 do
    begin
      d := Trunc(frxStrToFloat(FGuides[i]));// * Scale + FOffset - FStart) - 1;
      if (Position - 5 <= d) and (Position + 5 >= d) then
      begin
        FGuides.Delete(i);
        break;
      end;
    end;
  Invalidate;
  if Assigned(FOnPointerAdded) then
    FOnPointerAdded(Self);
end;

procedure TfrxRuler.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FMouseDown then
    BeginAutoDrag;
  if Align = alLeft then
    Position := (Y - (FOffset - FStart)) / FScale
  else
    Position := (X - (FOffset - FStart)) / FScale;
  if Assigned(FOnUpdateVirtualLines) then
  begin
    FOnUpdateVirtualLines(Self, Position);
    FVirtualGuid := Position;
  end;
end;

procedure TfrxRuler.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FMouseDown := False;
end;

procedure TfrxRuler.Paint;
var
  fh, oldfh: HFont;
  sz: Integer;
  procedure LineInternal(x, y, dx, dy: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x + dx, y + dy);
  end;

  procedure DrawGuides;
  var
    i: Integer;
  begin
    if FGuides = nil then Exit;
    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Style := psSolid;
      Pen.Color := clBlack;
      Pen.Mode := pmCopy;
    end;
    for i := 0 to FGuides.Count - 1 do
      DrawArrow(Canvas, Trunc(frxStrToFloat(FGuides[i]) * Scale + FOffset - FStart) - 1, clBtnFace);

  end;

  procedure DrawLines;
  var
    i, dx, maxi: Extended;
    i1, h, w, w5, w10, maxw, ofs: Integer;
    s: String;
  begin
    with Canvas do
    begin
      Pen.Color := clBlack;
      Brush.Style := bsClear;
      w5 := 5;
      w10 := 10;
      if FUnits = ruCM then
        dx := fr01cm * FScale
      else if FUnits = ruInches then
        dx := fr01in * FScale
      else if FUnits = ruChars then
      begin
        if Align = alLeft then
          dx := fr1CharY * FScale / 10 else
          dx := fr1CharX * FScale / 10
      end
      else
      begin
        dx := FScale;
        w5 := 50;
        w10 := 100;
      end;

      if FSize = 0 then
      begin
        if Align = alLeft then
          maxi := Self.Height + FStart else
          maxi := Self.Width + FStart;
      end
      else
        maxi := FSize;

      if FUnits = ruPixels then
        s := IntToStr(FStart + Round(maxi / dx)) else
        s := IntToStr((FStart + Round(maxi / dx)) div 10);

      maxw := TextWidth(s);
      ofs := FOffset - FStart;
      if FUnits = ruChars then
      begin
        if Align = alLeft then
          Inc(ofs, Round(fr1CharY * FScale / 2)) else
          Inc(ofs, Round(fr1CharX * FScale / 2))
      end;

      i := 0;
      i1 := 0;
      while i < maxi do
      begin
        h := 0;
        if i1 = 0 then
          h := 0
        else if i1 mod w10 = 0 then
          h := 6
        else if i1 mod w5 = 0 then
          h := 4
        else if FUnits <> ruPixels then
          h := 2;

        if (h = 2) and (dx * w10 < 41) then
          h := 0;
        if (h = 4) and (dx * w10 < 21) then
          h := 0;

        w := 0;
        if h = 6 then
        begin
          if maxw > dx * w10 * 1.5 then
            w := w10 * 4
          else if maxw > dx * w10 * 0.7 then
            w := w10 * 2
          else
            w := w10;
        end;

        if FUnits = ruPixels then
          s := IntToStr(i1) else
          s := IntToStr(i1 div 10);

        if (w <> 0) and (i1 mod w = 0) and (ofs + i >= FOffset) then
          if Align = alLeft then
            TextOut(Self.Width - TextHeight(s) - 6, ofs + Round(i) + TextWidth(s) div 2 + 1, s) else
            TextOut(ofs + Round(i) - TextWidth(s) div 2 + 1, 4, s)
        else if (h <> 0) and (ofs + i >= FOffset) then
          if Align = alLeft then
            LineInternal(3 + (13 - h) div 2, ofs + Round(i), h, 0) else
            LineInternal(ofs + Round(i), 3 + (13 - h) div 2, 0, h);

        i := i + dx;
        Inc(i1);
      end;

      i := FPosition * dx;
      if FUnits <> ruPixels then
        i := i * 10;
      if ofs + i >= FOffset then
        if Align = alLeft then
          LineInternal(3, ofs + Round(i), 13, 0) else
          LineInternal(ofs + Round(i), 3, 0, 13);
    end;
  end;

begin
  fh := 0; oldfh := 0;
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;
    FillRect(Rect(0, 0, Self.Width, Self.Height));
    Brush.Color := clWindow;

    Font.Name := 'Arial';
    Font.Size := 7;
    if Align = alLeft then
    begin
      if FSize = 0 then
        sz := Self.Height
      else
        sz := FSize + FOffset;
      FillRect(Rect(3, FOffset, Self.Width - 5, sz));
      fh := CreateRotatedFont(Font);
      oldfh := SelectObject(Handle, fh);
    end
    else
    begin
      if FSize = 0 then
        sz := Self.Width
      else
        sz := FSize + FOffset;
      FillRect(Rect(FOffset, 3, sz, Self.Height - 5));
    end;
  end;

  DrawLines;
  DrawGuides;
  if (FVirtualGuid > 0) then
  begin
    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Style := psSolid;
      Pen.Color := clBlack;
      Pen.Mode := pmCopy;
    end;
    DrawArrow(Canvas, Trunc(FVirtualGuid * Scale + FOffset - FStart) - 1, clWhite);
    DrawHint(Canvas, Trunc(FVirtualGuid * Scale + FOffset - FStart) - 1, FVirtualGuid);
  end;

  if Align = alLeft then
  begin
    SelectObject(Canvas.Handle, oldfh);
    DeleteObject(fh);
  end;
end;

procedure TfrxRuler.MouseLeave;
begin
  FVirtualGuid := 0;
  if Assigned(FOnUpdateVirtualLines) then
    FOnUpdateVirtualLines(Self, 0);
  Invalidate;
end;

procedure TfrxRuler.SetOffset(const Value: Integer);
begin
  FOffset := Value;
  Invalidate;
end;

procedure TfrxRuler.SetPosition(const Value: Extended);
begin
  FPosition := Value;
  Invalidate;
end;

procedure TfrxRuler.SetScale(const Value: Extended);
begin
  FScale := Value;
  Invalidate;
end;

procedure TfrxRuler.SetStart(const Value: Integer);
begin
  FStart := Value;
  Invalidate;
end;

procedure TfrxRuler.SetUnits(const Value: TfrxRulerUnits);
begin
  FUnits := Value;
  Invalidate;
end;

procedure TfrxRuler.SetSize(const Value: Integer);
begin
  FSize := Value;
  Invalidate;
end;


{ TfrxScrollBox }

procedure TfrxScrollBox.KeyDown(var Key: Word; Shift: TShiftState);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TWinControl then
      THackControl(Controls[i]).KeyDown(Key, Shift);
end;

procedure TfrxScrollBox.KeyPress(var Key: Char);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TWinControl then
      THackControl(Controls[i]).KeyPress(Key);
end;

{$IFDEF FPC}
procedure TfrxScrollBox.ScrollBy(DeltaX, DeltaY: Integer);
begin
  inherited ScrollBy(DeltaX, DeltaY);
  if Assigned(FOnAfterScroll) then
     FOnAfterScroll(Self);
end;
{$ENDIF}

procedure TfrxScrollBox.KeyUp(var Key: Word; Shift: TShiftState);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TWinControl then
      THackControl(Controls[i]).KeyUp(Key, Shift);
end;

procedure TfrxScrollBox.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTTAB;
end;


{ TfrxCustomSelector }

constructor TfrxCustomSelector.Create(AOwner: TComponent);
var
  f: TfrxPopupForm;
  p: TPoint;
begin
  {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
  FSavedIsDown := False;
  FSavedX := -1;
  FSavedY := -1;
  {$ENDIF}
  f := TfrxPopupForm.Create(nil);

  inherited Create(f);
  Width :=   FclWidth;
  Height :=   FclHeight;
  Parent := f;
  DoubleBuffered := True;
  f.AutoSize := True;
  Tag := AOwner.Tag;

  with TControl(AOwner) do
    p := ClientToScreen(Point(0, Height + 2));
  f.SetBounds(p.X, p.Y, 20, 20);
  f.Show;
end;

procedure TfrxCustomSelector.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
  FSavedIsDown := True;
  FSavedX := X;
  FSavedY := Y;
  {$ELSE}
  DrawEdge(X, Y, True);
  {$ENDIF}
end;

procedure TfrxCustomSelector.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
  FSavedIsDown := False;
  FSavedX := X;
  FSavedY := Y;
  Update;
  {$ELSE}
  DrawEdge(X, Y, False);
  {$ENDIF}
end;

{$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
procedure TfrxCustomSelector.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FSavedIsDown := False;
  FSavedX := -1;
  FSavedY := -1;
end;
{$ENDIF}

procedure TfrxCustomSelector.Paint;
begin
  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    Brush.Color := clWindow;
    Rectangle(0, 0, ClientWidth, ClientHeight);
  end;
end;

procedure TfrxCustomSelector.WMEraseBackground(var Message: TMessage);
begin
//

end;


{ TfrxColorSelector }

constructor TfrxColorSelector.Create(AOwner: TComponent);
begin
  FclWidth := 155;
  FclHeight := 143;
  FBtnCaption := 'Other...';
  inherited Create(AOwner);
end;

procedure TfrxColorSelector.DrawEdge(X, Y: Integer; IsDown: Boolean);
var
  r: TRect;
begin
  {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
  {$note fixme TfrxColorSelector.DrawEdge}
  exit;
  {$ENDIF}
  X := (X - 5) div 18;
  if X >= 8 then
    X := 7;
  Y := (Y - 5) div 18;

  Repaint;
  if Y < 6 then
    r := Rect(X * 18 + 5, Y * 18 + 5, X * 18 + 23, Y * 18 + 23) else
    r := Rect(5, 113, Width - 6, Height - 6);

  with Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Color := $C56A31;
    Rectangle(r.Left, r.Top, r.Right, r.Bottom);
    InflateRect(r, -1, -1);
    Pen.Color := $E8E6E2;
    Rectangle(r.Left, r.Top, r.Right, r.Bottom);
    InflateRect(r, -1, -1);
    Rectangle(r.Left, r.Top, r.Right, r.Bottom);
  end;
end;

procedure TfrxColorSelector.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  cd: TColorDialog;

  procedure AddCustomColor;
  var
    i: Integer;
    Found: Boolean;
    Empty: Integer;
  begin
    Found := False;
    Empty := 0;
    for i := 0 to 47 do
    begin
      if PrivateColors[i] = FColor then
        Found := True;
      if (i > 37) and (PrivateColors[i] = clBtnFace) and (Empty = 0) then
        Empty := i;
    end;

    if Found then exit;

    if Empty = 0 then
    begin
      for i := 40 to 46 do
        PrivateColors[i] := PrivateColors[i + 1];
      Empty := 47;
    end;
    PrivateColors[Empty] := FColor;
  end;

begin
  {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
  inherited;
  {$ENDIF}
  X := (X - 5) div 18;
  if X >= 8 then
    X := 7;
  Y := (Y - 5) div 18;

  if Y < 6 then
    FColor := PrivateColors[X + Y * 8]
  else
  begin
    TForm(Parent).AutoSize := False;
    Parent.Height := 0;
    cd := TColorDialog.Create(Self);
    {$IFNDEF FPC}
    cd.Options := [cdFullOpen];
    {$ENDIF}
    cd.Color := FColor;
    if cd.Execute then
      FColor := cd.Color else
      Exit;

    AddCustomColor;
  end;

  Repaint;
  if Assigned(FOnColorChanged) then
    FOnColorChanged(Self);
  Parent.Hide;
end;

procedure TfrxColorSelector.Paint;
var
  i, j: Integer;
  s: String;
begin
  inherited;

  with Canvas do
  begin
    for j := 0 to 5 do
      for i := 0 to 7 do
      begin
        if (i = 0) and (j = 0) then
          Brush.Color := clWhite else
          Brush.Color := PrivateColors[i + j * 8];
        Pen.Color := clGray;
        Rectangle(i * 18 + 8, j * 18 + 8, i * 18 + 20, j * 18 + 20);
        if (i = 0) and (j = 0) then
        begin
          MoveTo(i * 18 + 10, j * 18 + 10);
          LineTo(i * 18 + 18, j * 18 + 18);
          MoveTo(i * 18 + 17, j * 18 + 10);
          LineTo(i * 18 + 9, j * 18 + 18);
        end;
      end;

    Pen.Color := clGray;
    Brush.Color := clBtnFace;
    {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
    Rectangle(8, 116, Width - 9, Height - 7);
    {$ELSE}
    Rectangle(8, 116, Self.Width - 9, Self.Height - 9);
    {$ENDIF}
    s := FBtnCaption;
    Font := Self.Font;
    TextOut((Self.Width - TextWidth(s)) div 2, 118, s);
  end;
end;


{ TfrxLineSelector }

constructor TfrxLineSelector.Create(AOwner: TComponent);
begin
  FclWidth := 98;
  FclHeight := 106;
  inherited;
end;

procedure TfrxLineSelector.DrawEdge(X, Y: Integer; IsDown: Boolean);
var
  r: TRect;
begin
  {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
  {$note fixme TfrxLineSelector.DrawEdge}
  exit;
  {$ENDIF}
  Y := (Y - 5) div 16;
  if Y > 5 then
    Y := 5;

  Repaint;

  r := Rect(5, Y * 16 + 5, Width - 5, Y * 16 + 21);
  if IsDown then
    {$IFDEF FPC}
    Frame3D(Canvas.Handle, r, 1, bvLowered) else
    Frame3D(Canvas.Handle, r, 1, bvRaised);
    {$ELSE}
    Frame3D(Canvas, r, clBtnShadow, clBtnShadow, 2) else
    Frame3D(Canvas, r, clBtnShadow, clBtnShadow, 1);
    {$ENDIF}
end;

procedure TfrxLineSelector.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
  inherited;
  {$ENDIF}
  Y := (Y - 5) div 16;
  if Y > 5 then
    Y := 5;

  FStyle := Y;

  Repaint;
  if Assigned(FOnStyleChanged) then
    FOnStyleChanged(Self);
  Parent.Hide;
end;

procedure TfrxLineSelector.Paint;
var
  i: Integer;

  procedure DrawLine(Y, Style: Integer);
  begin
    if Style = 5 then
    begin
      Style := 0;
      DrawLine(Y - 2, Style);
      Inc(Y, 2);
    end;

    with Canvas do
    begin
      Pen.Color := clBlack;
      Pen.Style := TPenStyle(Style);
      MoveTo(7, Y);
      LineTo(Self.Width - 8, Y);
      MoveTo(7, Y + 1);
      LineTo(Self.Width - 8, Y + 1);
    end;
  end;

begin
  inherited;
  {$IFDEF FPC_NOPAINTOUTSIDEPAINTEVENT}
  if (SavedX <> -1) and (SavedY <> -1) then
    Self.DrawEdge(SavedX, SavedY, SavedIsDown);
  {$ENDIF}

  for i := 0 to 5 do
    DrawLine(12 + i * 16, i);
end;


{ TfrxUndoBuffer }

constructor TfrxUndoBuffer.Create;
begin
  FRedo := TList.Create;
  FUndo := TList.Create;
end;

destructor TfrxUndoBuffer.Destroy;
begin
  ClearUndo;
  ClearRedo;
  FUndo.Free;
  FRedo.Free;
  inherited;
end;

procedure TfrxUndoBuffer.AddUndo(ReportComponent: TfrxComponent);
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  FUndo.Add(m);
  SetPictureFlag(ReportComponent, False);
  try
    ReportComponent.SaveToStream(m);
  finally
    SetPictureFlag(ReportComponent, True);
  end;
end;

procedure TfrxUndoBuffer.AddRedo(ReportComponent: TfrxComponent);
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  FRedo.Add(m);
  SetPictureFlag(ReportComponent, False);
  try
    ReportComponent.SaveToStream(m);
  finally
    SetPictureFlag(ReportComponent, True);
  end;
end;

procedure TfrxUndoBuffer.GetUndo(ReportComponent: TfrxComponent);
var
  m: TMemoryStream;
  IsReport: Boolean;
begin
  IsReport := False;
  if ReportComponent is TfrxReport then
    isReport := True;
  m := FUndo[FUndo.Count - 2];
  m.Position := 0;
  if IsReport then
    TfrxReport(ReportComponent).Reloading := True;
  try
    ReportComponent.LoadFromStream(m);
  finally
  if IsReport then
    TfrxReport(ReportComponent).Reloading := False;
  end;
  SetPictures(ReportComponent);

  m := FUndo[FUndo.Count - 1];
  m.Free;
  FUndo.Delete(FUndo.Count - 1);
end;

procedure TfrxUndoBuffer.GetRedo(ReportComponent: TfrxComponent);
var
  m: TMemoryStream;
  IsReport: Boolean;
begin
  IsReport := False;
  if ReportComponent is TfrxReport then
    isReport := True;
  m := FRedo[FRedo.Count - 1];
  m.Position := 0;
  if IsReport then
    TfrxReport(ReportComponent).Reloading := True;
  try
    ReportComponent.LoadFromStream(m);
  finally
    if IsReport then
      TfrxReport(ReportComponent).Reloading := False;
  end;
  SetPictures(ReportComponent);

  m.Free;
  FRedo.Delete(FRedo.Count - 1);
end;

procedure TfrxUndoBuffer.ClearUndo;
begin
  while FUndo.Count > 0 do
  begin
    TMemoryStream(FUndo[0]).Free;
    FUndo.Delete(0);
  end;
end;

procedure TfrxUndoBuffer.ClearRedo;
begin
  while FRedo.Count > 0 do
  begin
    TMemoryStream(FRedo[0]).Free;
    FRedo.Delete(0);
  end;
end;

function TfrxUndoBuffer.GetRedoCount: Integer;
begin
  Result := FRedo.Count;
end;

function TfrxUndoBuffer.GetUndoCount: Integer;
begin
  Result := FUndo.Count;
end;

procedure TfrxUndoBuffer.SetPictureFlag(ReportComponent: TfrxComponent; Flag: Boolean);
var
  i: Integer;
  l: TList;
  c: TfrxComponent;
begin
  l := ReportComponent.AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if c is TfrxPictureView then
    begin
      TfrxPictureView(c).IsPictureStored := Flag;
      TfrxPictureView(c).IsImageIndexStored := not Flag;
    end;
  end;
end;

procedure TfrxUndoBuffer.SetPictures(ReportComponent: TfrxComponent);
var
  i: Integer;
  l: TList;
  c: TfrxComponent;
begin
  l := ReportComponent.AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    c := l[i];
    if c is TfrxPictureView then
      FPictureCache.GetPicture(TfrxPictureView(c));
  end;
end;


{ TfrxClipboard }

constructor TfrxClipboard.Create(ADesigner: TfrxCustomDesigner);
begin
  FDesigner := ADesigner;
end;

procedure TfrxClipboard.Copy;
var
  c, c1: TfrxComponent;
  i, j: Integer;
  text: String;
  minX, minY: Extended;
  List: TList;
  Flag: Boolean;
  ss: TStringStream;
  aRoot: TfrxXMLItem;
  wr: TfrxXMLWriter;

  procedure Write(c: TfrxComponent);
  var
    c1: TfrxComponent;
    Writer: TfrxXMLSerializer;
  begin
    c1 := TfrxComponent(c.NewInstance);
    c1.Create(FDesigner.Page);

    if c is TfrxPictureView then
    begin
      TfrxPictureView(c).IsPictureStored := False;
      TfrxPictureView(c).IsImageIndexStored := True;
    end;

    try
      c1.Assign(c);
    finally
      if c is TfrxPictureView then
      begin
        TfrxPictureView(c).IsPictureStored := True;
        TfrxPictureView(c).IsImageIndexStored := False;
        TfrxPictureView(c1).IsImageIndexStored := True;
      end;
    end;

    c1.Left := c1.Left - minX;
    c1.Top := c.AbsTop - minY;
    ss := TStringStream.Create(''{$IFDEF Delphi12} ,TEncoding.UTF8 {$ENDIF});
    Writer := TfrxXMLSerializer.Create(nil);
    aRoot := TfrxXMLItem.Create;
    wr := TfrxXMLWriter.Create(ss);
    try
      Writer.Owner := c1.Report;
      if (csContainer in c.frComponentStyle) or (csObjectsContainer in c.frComponentStyle) then
      begin
        Writer.WriteRootComponent(c, true, aRoot, true);
        wr.AutoIndent := False;
        wr.WriteRootItem(aRoot);
        text := text + ss.DataString;
      end
      else
        text := text + '<' + c1.ClassName + ' Name="' + c.Name + '"' + Writer.ObjToXML(c1) + '/>';
    finally
      aRoot.Free;
      wr.Free;
      ss.Free;
      Writer.Free;
    end;
    c1.Free;
  end;

begin
  if (FDesigner.SelectedObjects.Count > 0) and (csContained in TfrxComponent(FDesigner.SelectedObjects[0]).frComponentStyle) then
  begin
    FDesigner.InternalCopy;
    Exit;
  end;

  text := ClipboardPrefix + #10#13;
  minX := 100000;
  minY := 100000;
  for i := 0 to FDesigner.SelectedObjects.Count - 1 do
  begin
    c := FDesigner.SelectedObjects[i];
    if c.AbsLeft < minX then
      minX := c.AbsLeft;
    if c.AbsTop < minY then
      minY := c.AbsTop;
  end;

  List := FDesigner.Page.AllObjects;
  for i := 0 to List.Count - 1 do
  begin
    c := List[i];
    if FDesigner.SelectedObjects.IndexOf(c) <> -1 then
    begin
      if csContained in c.frComponentStyle then Continue;
      Write(c);
      if c is TfrxBand then
      begin
        Flag := False;
        for j := 0 to c.Objects.Count - 1 do
        begin
          c1 := c.Objects[j];
          if FDesigner.SelectedObjects.IndexOf(c1) <> -1 then
            Flag := True;
        end;

        if not Flag then
          for j := 0 to c.Objects.Count - 1 do
            Write(c.Objects[j]);
      end;
    end;
  end;

  Clipboard.AsText := text;
end;

function TfrxClipboard.GetPasteAvailable: Boolean;
begin
  Result := IsFrxPasteAvailable or FDesigner.InternalIsPasteAvailable;
end;

function TfrxClipboard.IsFrxPasteAvailable: Boolean;
var
  lString, cString: String;
begin
  Result := Clipboard.HasFormat(CF_TEXT);
  if Result then
  begin
    try
      cString := Clipboard.AsText;
    except
    end;
    lString := System.Copy(cString, 1, Length(ClipboardPrefix));
    Result := (CompareStr(ClipboardPrefix, lString) = 0);
  end;
end;

function TfrxClipboard.Paste: Boolean;
var
  c: TfrxComponent;
  sl: TStrings;
  s: TStream;
  List: TList;
  NewCompName: string;
  NewComp: TfrxComponent;

  function ReadComponent_(AReader: TfrxXMLSerializer; Root: TfrxComponent): TfrxComponent;
  var
    rd: TfrxXMLReader;
    RootItem: TfrxXMLItem;
    i: Integer;
  begin
    rd := TfrxXMLReader.Create(AReader.Stream);
    RootItem := TfrxXMLItem.Create;

    try
      rd.ReadRootItem(RootItem, True);
      Result := AReader.ReadComponentStr(Root, RootItem.Name + ' ' + RootItem.Text);
      { handle containers }
      if (RootItem.Count > 0) and ((csContainer in Result.frComponentStyle) or (csObjectsContainer in Result.frComponentStyle)) then
      begin
        AReader.IgnoreName := True;
        AReader.ReadRootComponent(Result, RootItem);
        for i := 0 to Result.AllObjects.Count - 1 do
          if TfrxComponent(Result.AllObjects[i]).Name = '' then
            TfrxComponent(Result.AllObjects[i]).CreateUniqueName;

        AReader.IgnoreName := False;
      end;

      NewCompName := RootItem.Prop['Name'];
    finally
      rd.Free;
      RootItem.Free;
    end;
  end;

  function ReadComponent: TfrxComponent;
  var
    Reader: TfrxXMLSerializer;
  begin
    Reader := TfrxXMLSerializer.Create(s);
    Result := ReadComponent_(Reader, FDesigner.Report);
    Reader.Free;
  end;

  function FindBand(Band: TfrxComponent): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to FDesigner.Page.Objects.Count - 1 do
      if (FDesigner.Page.Objects[i] <> Band) and
        (TObject(FDesigner.Page.Objects[i]) is Band.ClassType) then
        Result := True;
  end;

  function CanInsert(c: TfrxComponent): Boolean;
  begin
    Result := True;
    if (c is TfrxDialogControl) and (FDesigner.Page is TfrxReportPage) then
      Result := False;
    if (c is TfrxDialogComponent) and not (FDesigner.Page is TfrxDataPage) then
      Result := False;
    if not (c is TfrxDialogComponent) and not (c is TfrxDialogControl) and
      (FDesigner.Page is TfrxDialogPage) then
      Result := False;
    if ((c is TfrxDMPMemoView) or (c is TfrxDMPLineView) or (c is TfrxDMPCommand)) and
      not (FDesigner.Page is TfrxDMPPage) then
      Result := False;
    if not ((c is TfrxBand) or (c is TfrxDMPMemoView) or (c is TfrxDMPLineView) or
      (c is TfrxDMPCommand)) and (FDesigner.Page is TfrxDMPPage) then
      Result := False;
    if not ((c is TfrxCustomLineView) or (c is TfrxCustomMemoView) or
      (c is TfrxShapeView) or (c is TfrxDialogComponent)) and
      (FDesigner.Page is TfrxDataPage) then
      Result := False;
  end;

  procedure FindParent(c: TfrxComponent);
  var
    i: Integer;
    Found: Boolean;
    c1: TfrxComponent;
  begin
    Found := False;
    if not (c is TfrxBand) then
      for i := List.Count - 1 downto 0 do
      begin
        c1 := List[i];
        if c1 is TfrxBand then
          if (c.Top >= c1.Top) and (c.Top < c1.Top + c1.Height) then
          begin
            c.Parent := c1;
            c.Top := c.Top - c1.Top;
            Found := True;
            break;
          end;
      end;
    if not Found then
      c.Parent := FDesigner.Page;
  end;

begin
  Result := False;
  if not IsFrxPasteAvailable then
  begin
    FDesigner.InternalPaste;
    FDesigner.ReloadObjects(False);
    Exit;
  end;

  Result := True;
  FDesigner.SelectedObjects.Clear;

  sl := TStringList.Create;
  sl.Text := Clipboard.AsText;
  sl.Delete(0);

  s := TMemoryStream.Create;
  sl.SaveToStream(s{$IFDEF Delphi12} ,TEncoding.UTF8 {$ENDIF});
  sl.Free;
  s.Position := 0;

  List := TList.Create;

  while s.Position < s.Size do
  begin
    c := ReadComponent;
    if c = nil then break;

    if (((c is TfrxReportTitle) or (c is TfrxReportSummary) or
       (c is TfrxPageHeader) or (c is TfrxPageFooter) or
       (c is TfrxColumnHeader) or (c is TfrxColumnFooter)) and FindBand(c)) or
       not CanInsert(c) then
      c.Free
    else
    begin
      if c is TfrxPictureView then
        FPictureCache.GetPicture(TfrxPictureView(c));
      List.Add(c);
      FindParent(c);
      if FDesigner.IsPreviewDesigner then
        NewComp := FDesigner.Report.FindObject(NewCompName) as TfrxComponent
      else
        NewComp := FDesigner.Report.FindComponent(NewCompName) as TfrxComponent;
      if ((NewComp <> nil) and (NewComp <> c)) or (NewCompName = '') then
        c.CreateUniqueName
      else
        c.Name := NewCompName;
      c.GroupIndex := 0;
      FDesigner.Objects.Add(c);
      if c.Parent = FDesigner.Page then
        FDesigner.SelectedObjects.Add(c);
      c.OnPaste;
    end;
  end;

  if FDesigner.SelectedObjects.Count = 0 then
    FDesigner.SelectedObjects.Add(FDesigner.Page);

  List.Free;
  s.Free;
  FDesigner.ReloadObjects(False);
end;


{ TfrxFrameSampleControl }

procedure TfrxFrameSampleControl.Paint;
var
  s: String;
  size: TSize;

  procedure DrawLine(x, y, x1, y1: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x1, y1);
  end;

begin
  with Canvas do
  begin
    // draw control frame
    Pen.Color := clBtnShadow;//$B99D7F;
    Pen.Style := psSolid;
    Pen.Width := 1;
    Brush.Color := clWindow;
    Brush.Style := bsSolid;
    Rectangle(Rect(0, 0, Self.Width, Self.Height));
    // draw corners
    Pen.Color := clGray;
    DrawLine(10, 10, 10, 5);
    DrawLine(10, 10, 5, 10);
    DrawLine(10, Self.Height - 11, 10, Self.Height - 6);
    DrawLine(10, Self.Height - 11, 5, Self.Height - 11);
    DrawLine(Self.Width - 11, 10, Self.Width - 11, 5);
    DrawLine(Self.Width - 11, 10, Self.Width - 6, 10);
    DrawLine(Self.Width - 11, Self.Height - 11, Self.Width - 11, Self.Height - 6);
    DrawLine(Self.Width - 11, Self.Height - 11, Self.Width - 6, Self.Height - 11);
    // draw text
    Font := Self.Font;
    s := 'Sample';
    size := TextExtent(s);
    TextOut((Self.Width - size.cx) div 2, (Self.Height - size.cy) div 2, s);
    // draw frame
    if FFrame <> nil then
      FFrame.Draw(Canvas, 10, 10, Self.Width - 11, Self.Height - 11, 1, 1);
  end;
end;

procedure TfrxFrameSampleControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  typ: TfrxFrameType;
begin
  if (X > 12) and (X < Width - 12) and (Y > 5) and (Y < 18) then
    typ := ftTop
  else if (X > 12) and (X < Width - 12) and (Y > Height - 18) and (Y < Height - 5) then
    typ := ftBottom
  else if (X > 5) and (X < 18) and (Y > 12) and (Y < Height - 12) then
    typ := ftLeft
  else if (X > Width - 18) and (X < Width - 5) and (Y > 12) and (Y < Height - 12) then
    typ := ftRight
  else
    Exit;

  if Assigned(FOnFrameLineClicked) then
    FOnFrameLineClicked(typ, not (typ in FFrame.Typ));
  Refresh;
end;


{ TfrxLineStyleControl }

constructor TfrxLineStyleControl.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := True;
end;

procedure TfrxLineStyleControl.WMEraseBackground(var Message: TMessage);
begin
//
end;

procedure TfrxLineStyleControl.SetStyle(const Value: TfrxFrameStyle);
begin
  FStyle := Value;
  Invalidate;
end;

procedure TfrxLineStyleControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Y := (Y - 5) div 16;
  if Y > 5 then
    Y := 5;

  FStyle := TfrxFrameStyle(Y);

  Repaint;
  if Assigned(FOnStyleChanged) then
    FOnStyleChanged(Self);
end;

procedure TfrxLineStyleControl.Paint;
var
  i: Integer;

  procedure DrawLine(Y, Style: Integer);
  begin
    if Style = 5 then
    begin
      Style := 0;
      DrawLine(Y - 1, Style);
      Inc(Y);
    end;

    with Canvas do
    begin
      Pen.Color := clBlack;
      Pen.Style := TPenStyle(Style);
      Brush.Style := bsClear;
      MoveTo(7, Y);
      LineTo(Self.Width - 8, Y);
    end;
  end;

  procedure DrawHighlight(Y: Integer);
  begin
    with Canvas do
    begin
      Pen.Color := clBtnShadow;
      Pen.Style := psSolid;
      Brush.Color := clHighlight;
      Brush.Style := bsSolid;
      Rectangle(5, Y * 16 + 5, Self.Width - 5, Y * 16 + 21);
    end;
  end;

begin
  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    Brush.Color := clWindow;
    Rectangle(0, 0, Self.Width, Self.Height);
  end;

  for i := 0 to 5 do
  begin
    if FStyle = TfrxFrameStyle(i) then
      DrawHighlight(i);
    DrawLine(12 + i * 16, i);
  end;
end;


{ TfrxColorComboBox }

constructor TfrxColorComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FCombo := TComboBox.Create(Self);
  FCombo.Parent := Self;
  FCombo.Top := -100;
end;

procedure TfrxColorComboBox.SetEnabled(Value: Boolean);
begin
  inherited;
  FCombo.Enabled := Enabled;
  Invalidate;
end;

procedure TfrxColorComboBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  AHeight := FCombo.Height;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FCombo.Width := Width;
end;

procedure TfrxColorComboBox.SetColor(const Value: TColor);
begin
  FColor := Value;
  Invalidate;
end;

procedure TfrxColorComboBox.SetShowColorName(const Value: Boolean);
begin
  FShowColorName := Value;
  Invalidate;
end;

procedure TfrxColorComboBox.Paint;
var
  s: String;
begin
  // update height
  Height := Height;
  FCombo.PaintTo(Canvas, 0, 0);

  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    Brush.Color := FColor;
    if Enabled then
      Brush.Style := bsSolid
    else
      Brush.Style := bsClear;
    Rectangle(4, 4, 24, Self.Height - 5);

    if FShowColorName then
    begin
      Pen.Color := clWindowText;
      Brush.Style := bsClear;
      s := ColorToString(FColor);
      if (Length(s) > 2) and (Copy(s, 1, 2) = 'cl') then
        Delete(s, 1, 2)
      else if (Length(s) > 3) and (Copy(s, 1, 3) = '$00') then
        Delete(s, 2, 2);
      Font := Self.Font;
      TextOut(28, 3, s);
    end;
  end;
end;

procedure TfrxColorComboBox.ColorChanged(Sender: TObject);
begin
  FColor := TfrxColorSelector(Sender).Color;
  Repaint;
  if Assigned(FOnColorChanged) then
    FOnColorChanged(Self);
end;

procedure TfrxColorComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FBlockPopup := GetTickCount - frxPopupFormCloseTime < 50;
end;

procedure TfrxColorComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not FBlockPopup then
    with TfrxColorSelector.Create(Self) do
    begin
      BtnCaption := frxResources.Get('dsColorOth');
      OnColorChanged := ColorChanged;
    end;
end;


{$IFDEF FPC}
{procedure RegisterUnitfrxDesgnCtrls;
begin
  RegisterComponents('Fast Report 6 Design',[TfrxRuler, TfrxScrollBox,
    TfrxColorSelector, TfrxLineSelector, TfrxColorComboBox
   ]);
end;

procedure Register;
begin
  RegisterUnit('frxDesgnCtrls',@RegisterUnitfrxDesgnCtrls);
end; }
{$ENDIF}


end.
