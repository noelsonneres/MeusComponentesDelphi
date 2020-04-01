
{******************************************}
{                                          }
{             FastReport v5.0              }
{              Frame editor                }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxEditFrame;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ExtCtrls, StdCtrls, ComCtrls, ToolWin, Buttons, frxCtrls, frxDock, frxClass, frxDesgnCtrls
  {$IFDEF FPC}
  , LResources, LCLType
  {$ENDIF}
  ;

type
  TfrxFrameEditorForm = class(TForm)
    OkB: TButton;
    CancelB: TButton;
    FrameGB: TGroupBox;
    FrameAllB: TSpeedButton;
    FrameNoB: TSpeedButton;
    FrameTopB: TSpeedButton;
    FrameBottomB: TSpeedButton;
    FrameLeftB: TSpeedButton;
    FrameRightB: TSpeedButton;
    ShadowCB: TCheckBox;
    ShadowWidthL: TLabel;
    ShadowWidthCB: TComboBox;
    ShadowColorL: TLabel;
    LineGB: TGroupBox;
    LineStyleL: TLabel;
    LineWidthL: TLabel;
    LineWidthCB: TComboBox;
    LineColorL: TLabel;
    HintL: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FrameAllBClick(Sender: TObject);
    procedure FrameNoBClick(Sender: TObject);
    procedure FrameLineClick(Sender: TObject);
    procedure ShadowCBClick(Sender: TObject);
    procedure ShadowWidthCBChange(Sender: TObject);
  private
    FFrame: TfrxFrame;
    SampleC: TfrxFrameSampleControl;
    LineStyleC: TfrxLineStyleControl;
    ShadowColorCB: TfrxColorComboBox;
    LineColorCB: TfrxColorComboBox;
    procedure SetFrame(const Value: TfrxFrame);
    procedure FrameLineClicked(Line: TfrxFrameType; state: Boolean);
    procedure ShadowColorChanged(Sender: TObject);
    function LineStyle: TfrxFrameStyle;
    function LineWidth: Extended;
    function LineColor: TColor;
    procedure UpdateControls;
    procedure Change;
  public
    property Frame: TfrxFrame read FFrame write SetFrame;
  end;


implementation

{$IFNDEF FPC}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses frxUtils, frxRes;


procedure TfrxFrameEditorForm.FormCreate(Sender: TObject);
begin
  FFrame := TfrxFrame.Create;

  SampleC := TfrxFrameSampleControl.Create(Self);
  SampleC.Parent := FrameGB;
  SampleC.SetBounds(12, 52, 160, 94);
  SampleC.Frame := FFrame;
  SampleC.OnFrameLineClicked := FrameLineClicked;
  LineStyleC := TfrxLineStyleControl.Create(Self);
  LineStyleC.Parent := LineGB;
  LineStyleC.SetBounds(12, 40, 98, 106);
  ShadowColorCB := TfrxColorComboBox.Create(Self);
  ShadowColorCB.Parent := FrameGB;
  ShadowColorCB.SetBounds(100, {$IFDEF FPC}205{$ELSE}216{$ENDIF}, 73, 25);
  ShadowColorCB.OnColorChanged := ShadowColorChanged;
  LineColorCB := TfrxColorComboBox.Create(Self);
  LineColorCB.Parent := LineGB;
  LineColorCB.SetBounds(12, {$IFDEF FPC}205{$ELSE}216{$ENDIF}, 98, 25);

  frxResources.SetGlyph(FrameTopB, 32);
  frxResources.SetGlyph(FrameBottomB, 33);
  frxResources.SetGlyph(FrameLeftB, 34);
  frxResources.SetGlyph(FrameRightB, 35);
  frxResources.SetGlyph(FrameAllB, 36);
  frxResources.SetGlyph(FrameNoB, 37);

  Caption := frxGet(5200);
  FrameGB.Caption := frxGet(5201);
  LineGB.Caption := frxGet(5202);
  ShadowCB.Caption := frxGet(5203);
  ShadowWidthL.Caption := frxGet(5215);
  ShadowColorL.Caption := frxGet(5214);
  LineStyleL.Caption := frxGet(5211);
  LineWidthL.Caption := frxGet(5215);
  LineColorL.Caption := frxGet(5214);
  HintL.Caption := frxGet(5216);

  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxFrameEditorForm.FormDestroy(Sender: TObject);
begin
  FFrame.Free;
end;

procedure TfrxFrameEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxFrameEditorForm.FormShow(Sender: TObject);
begin
  LineWidthCB.Text := FloatToStr(FFrame.Width);
  LineColorCB.Color := FFrame.Color;
  LineStyleC.Style := FFrame.Style;
  UpdateControls;
end;

procedure TfrxFrameEditorForm.SetFrame(const Value: TfrxFrame);
begin
  FFrame.Assign(Value);
end;

function TfrxFrameEditorForm.LineStyle: TfrxFrameStyle;
begin
  Result := TfrxFrameStyle(LineStyleC.Style);
end;

function TfrxFrameEditorForm.LineWidth: Extended;
begin
  Result := frxStrToFloat(LineWidthCB.Text);
end;

function TfrxFrameEditorForm.LineColor: TColor;
begin
  Result := LineColorCB.Color;
end;

procedure TfrxFrameEditorForm.Change;
begin
  UpdateControls;
end;

procedure TfrxFrameEditorForm.FrameLineClicked(Line: TfrxFrameType; state: Boolean);
var
  frameLine: TfrxFrameLine;
begin
  frameLine := nil;
  case Line of
    ftLeft: frameLine := FFrame.LeftLine;
    ftRight: frameLine := FFrame.RightLine;
    ftTop: frameLine := FFrame.TopLine;
    ftBottom: frameLine := FFrame.BottomLine;
  end;

  if frameLine <> nil then
  begin
    if state or (frameLine.Style <> LineStyle) or (frameLine.Width <> LineWidth) or (frameLine.Color <> LineColor) then
    begin
      FFrame.Typ := FFrame.Typ + [Line];
      frameLine.Style := LineStyle;
      frameLine.Width := LineWidth;
      frameLine.Color := LineColor;
    end
    else
      FFrame.Typ := FFrame.Typ - [Line];
  end;

  Change;
end;

procedure TfrxFrameEditorForm.FrameAllBClick(Sender: TObject);
begin
  FFrame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
  FFrame.Style := LineStyle;
  FFrame.Width := LineWidth;
  FFrame.Color := LineColor;
  Change;
end;

procedure TfrxFrameEditorForm.FrameNoBClick(Sender: TObject);
begin
  FFrame.Typ := [];
  Change;
end;

procedure TfrxFrameEditorForm.FrameLineClick(Sender: TObject);
var
  line: TfrxFrameType;
begin
  line := ftLeft;
  if Sender = FrameTopB then
    line := ftTop
  else if Sender = FrameBottomB then
    line := ftBottom
  else if Sender = FrameLeftB then
    line := ftLeft
  else if Sender = FrameRightB then
    line := ftRight;

  FrameLineClicked(line, (Sender as TSpeedButton).Down);
end;

procedure TfrxFrameEditorForm.UpdateControls;
begin
  FrameTopB.Down := ftTop in FFrame.Typ;
  FrameBottomB.Down := ftBottom in FFrame.Typ;
  FrameLeftB.Down := ftLeft in FFrame.Typ;
  FrameRightB.Down := ftRight in FFrame.Typ;
  ShadowCB.Checked := FFrame.DropShadow;
  ShadowCB.Checked := FFrame.DropShadow;
  ShadowWidthCB.Text := FloatToStr(FFrame.ShadowWidth);
  ShadowColorCB.Color := FFrame.ShadowColor;
  ShadowWidthL.Enabled := FFrame.DropShadow;
  ShadowWidthCB.Enabled := FFrame.DropShadow;
  ShadowColorL.Enabled := FFrame.DropShadow;
  ShadowColorCB.Enabled := FFrame.DropShadow;
  SampleC.Repaint;
end;

procedure TfrxFrameEditorForm.ShadowCBClick(Sender: TObject);
begin
  FFrame.DropShadow := ShadowCB.Checked;
  Change;
end;

procedure TfrxFrameEditorForm.ShadowWidthCBChange(Sender: TObject);
begin
  FFrame.ShadowWidth := frxStrToFloat(ShadowWidthCB.Text);
  Change;
end;

procedure TfrxFrameEditorForm.ShadowColorChanged(Sender: TObject);
begin
  FFrame.ShadowColor := ShadowColorCB.Color;
  Change;
end;

end.
