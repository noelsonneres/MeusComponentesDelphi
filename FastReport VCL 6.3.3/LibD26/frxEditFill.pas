
{******************************************}
{                                          }
{             FastReport v5.0              }
{               Fill editor                }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxEditFill;

interface

{$I frx.inc}

uses
{$IFDEF FPC}
  LCLType, LMessages, LazHelper, LCLIntf,
{$ELSE}
  Windows, Messages,
{$ENDIF}  
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, frxClass, frxDesgnCtrls
{$IFDEF Delphi6}
, Variants
{$ENDIF}
;

type
  TfrxFillEditorForm = class(TForm)
    PageControl: TPageControl;
    BrushTS: TTabSheet;
    GradientTS: TTabSheet;
    GlassTS: TTabSheet;
    BrushBackColorL: TLabel;
    BrushForeColorL: TLabel;
    BrushStyleL: TLabel;
    BrushStyleCB: TComboBox;
    GradientStyleL: TLabel;
    GradientStyleCB: TComboBox;
    GradientStartColorL: TLabel;
    GradientEndColorL: TLabel;
    GlassOrientationL: TLabel;
    GlassOrientationCB: TComboBox;
    GlassColorL: TLabel;
    GlassBlendL: TLabel;
    GlassHatchCB: TCheckBox;
    OKB: TButton;
    CancelB: TButton;
    SampleP: TPanel;
    GlassBlendE: TEdit;
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BrushStyleCBDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure PageControlChange(Sender: TObject);
    procedure BrushStyleCBChange(Sender: TObject);
    procedure GradientStyleCBChange(Sender: TObject);
    procedure GlassOrientationCBChange(Sender: TObject);
    procedure GlassHatchCBClick(Sender: TObject);
    procedure GlassBlendEExit(Sender: TObject);
  private
    { Private declarations }
    FBrushFill: TfrxBrushFill;
    FGradientFill: TfrxGradientFill;
    FGlassFill: TfrxGlassFill;
    FIsSimpleFill: Boolean;
    BrushBackColorCB: TfrxColorComboBox;
    BrushForeColorCB: TfrxColorComboBox;
    GradientStartColorCB: TfrxColorComboBox;
    GradientEndColorCB: TfrxColorComboBox;
    GlassColorCB: TfrxColorComboBox;
    function GetFill: TfrxCustomFill;
    procedure SetFill(Value: TfrxCustomFill);
    procedure SetIsSimpleFill(Value: Boolean);
    procedure UpdateControls;
    procedure Change;
    procedure BrushBackColorChanged(Sender: TObject);
    procedure BrushForeColorChanged(Sender: TObject);
    procedure GradientStartColorChanged(Sender: TObject);
    procedure GradientEndColorChanged(Sender: TObject);
    procedure GlassColorChanged(Sender: TObject);
  public
    { Public declarations }
    property Fill: TfrxCustomFill read GetFill write SetFill;
    property IsSimpleFill: Boolean read FIsSimpleFill write SetIsSimpleFill;
  end;


implementation

{$IFDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

uses frxUtils, frxRes;

procedure TfrxFillEditorForm.FormCreate(Sender: TObject);
begin
  FBrushFill := TfrxBrushFill.Create;

  BrushBackColorCB := TfrxColorComboBox.Create(Self);
  BrushBackColorCB.Parent := BrushTS;
  BrushBackColorCB.SetBounds(BrushStyleCB.Left, BrushBackColorL.Top - 3, BrushStyleCB.Width, BrushStyleCB.Height);
  BrushBackColorCB.ShowColorName := True;
  BrushBackColorCB.OnColorChanged := BrushBackColorChanged;

  BrushForeColorCB := TfrxColorComboBox.Create(Self);
  BrushForeColorCB.Parent := BrushTS;
  BrushForeColorCB.SetBounds(BrushStyleCB.Left, BrushForeColorL.Top - 3, BrushStyleCB.Width, BrushStyleCB.Height);
  BrushForeColorCB.ShowColorName := True;
  BrushForeColorCB.OnColorChanged := BrushForeColorChanged;

  with BrushStyleCB.Items do
  begin
    Clear;
    Add(frxResources.Get('bsSolid'));
    Add(frxResources.Get('bsClear'));
    Add(frxResources.Get('bsHorizontal'));
    Add(frxResources.Get('bsVertical'));
    Add(frxResources.Get('bsFDiagonal'));
    Add(frxResources.Get('bsBDiagonal'));
    Add(frxResources.Get('bsCross'));
    Add(frxResources.Get('bsDiagCross'));
  end;

  FGradientFill := TfrxGradientFill.Create;

  GradientStartColorCB := TfrxColorComboBox.Create(Self);
  GradientStartColorCB.Parent := GradientTS;
  GradientStartColorCB.SetBounds(BrushStyleCB.Left, GradientStartColorL.Top - 3, BrushStyleCB.Width, BrushStyleCB.Height);
  GradientStartColorCB.ShowColorName := True;
  GradientStartColorCB.OnColorChanged := GradientStartColorChanged;

  GradientEndColorCB := TfrxColorComboBox.Create(Self);
  GradientEndColorCB.Parent := GradientTS;
  GradientEndColorCB.SetBounds(BrushStyleCB.Left, GradientEndColorL.Top - 3, BrushStyleCB.Width, BrushStyleCB.Height);
  GradientEndColorCB.ShowColorName := True;
  GradientEndColorCB.OnColorChanged := GradientEndColorChanged;

  with GradientStyleCB.Items do
  begin
    Clear;
    Add(frxResources.Get('gsHorizontal'));
    Add(frxResources.Get('gsVertical'));
    Add(frxResources.Get('gsElliptic'));
    Add(frxResources.Get('gsRectangle'));
    Add(frxResources.Get('gsVertCenter'));
    Add(frxResources.Get('gsHorizCenter'));
  end;

  FGlassFill := TfrxGlassFill.Create;

  GlassColorCB := TfrxColorComboBox.Create(Self);
  GlassColorCB.Parent := GlassTS;
  GlassColorCB.SetBounds(BrushStyleCB.Left, GlassColorL.Top - 3, BrushStyleCB.Width, BrushStyleCB.Height);
  GlassColorCB.ShowColorName := True;
  GlassColorCB.OnColorChanged := GlassColorChanged;

  with GlassOrientationCB.Items do
  begin
    Clear;
    Add(frxResources.Get('foVertical'));
    Add(frxResources.Get('foHorizontal'));
    Add(frxResources.Get('foVerticalMirror'));
    Add(frxResources.Get('foHorizontalMirror'));
  end;

  Caption := frxGet(6100);
  BrushTS.Caption := frxGet(6101);
  GradientTS.Caption := frxGet(6102);
  GlassTS.Caption := frxGet(6103);
  BrushStyleL.Caption := frxGet(6104);
  BrushBackColorL.Caption := frxGet(6105);
  BrushForeColorL.Caption := frxGet(6106);
  GradientStyleL.Caption := frxGet(6107);
  GradientStartColorL.Caption := frxGet(6108);
  GradientEndColorL.Caption := frxGet(6109);
  GlassOrientationL.Caption := frxGet(6110);
  GlassColorL.Caption := frxGet(6111);
  GlassBlendL.Caption := frxGet(6112);
  GlassHatchCB.Caption := frxGet(6113);

  OKB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxFillEditorForm.FormDestroy(Sender: TObject);
begin
  FBrushFill.Free;
  FGradientFill.Free;
  FGlassFill.Free;
end;

function TfrxFillEditorForm.GetFill: TfrxCustomFill;
begin
  Result := nil;
  if PageControl.ActivePage = BrushTS then
    Result := FBrushFill
  else if PageControl.ActivePage = GradientTS then
    Result := FGradientFill
  else if PageControl.ActivePage = GlassTS then
    Result := FGlassFill;
end;

procedure TfrxFillEditorForm.SetFill(Value: TfrxCustomFill);
begin
  if Value is TfrxBrushFill then
  begin
    FBrushFill.Assign(Value);
    PageControl.ActivePage := BrushTS;
  end
  else if Value is TfrxGradientFill then
  begin
    FGradientFill.Assign(Value);
    PageControl.ActivePage := GradientTS;
  end
  else if Value is TfrxGlassFill then
  begin
    FGlassFill.Assign(Value);
    PageControl.ActivePage := GlassTS;
  end;

  UpdateControls;
end;

procedure TfrxFillEditorForm.SetIsSimpleFill(Value: Boolean);
begin
  FIsSimpleFill := Value;
  if Value then
  begin
    GradientTS.TabVisible := False;
    GlassTS.TabVisible := False;
  end;
end;

procedure TfrxFillEditorForm.UpdateControls;
begin
  BrushStyleCB.ItemIndex := Ord(FBrushFill.Style);
  BrushBackColorCB.Color := FBrushFill.BackColor;
  BrushForeColorCB.Color := FBrushFill.ForeColor;
  GradientStyleCB.ItemIndex := Ord(FGradientFill.GradientStyle);
  GradientStartColorCB.Color := FGradientFill.StartColor;
  GradientEndColorCB.Color := FGradientFill.EndColor;
  GlassOrientationCB.ItemIndex := Ord(FGlassFill.Orientation);
  GlassColorCB.Color := FGlassFill.Color;
  GlassBlendE.Text := FloatToStr(FGlassFill.Blend);
  GlassHatchCB.Checked := FGlassFill.Hatch;
end;

procedure TfrxFillEditorForm.Change;
begin
  PaintBox1.Repaint;
end;

procedure TfrxFillEditorForm.PaintBox1Paint(Sender: TObject);
begin
  with PaintBox1.Canvas do
  begin
    Brush.Color := clWhite;
    Brush.Style := bsSolid;
    FillRect(PaintBox1.ClientRect);
    GetFill.Draw(PaintBox1.Canvas, 0, 0, PaintBox1.Width, PaintBox1.Height, 1, 1);
    Pen.Color := clBtnShadow;
    Brush.Style := bsClear;
    Rectangle(0, 0, PaintBox1.Width, PaintBox1.Height);
  end;
end;

procedure TfrxFillEditorForm.BrushStyleCBDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
  r: TRect;
begin
  with BrushStyleCB.Canvas do
  begin
    FillRect(ARect);
    Brush.Color := clWhite;
    Brush.Style := bsSolid;
    r := Rect(ARect.Left + 1, ARect.Top + 2, ARect.Left + 21, ARect.Bottom - 2);
    FillRect(r);

    Brush.Style := TBrushStyle(Index);
    if Index = 1 then
      Brush.Color := clWhite
    else
      Brush.Color := clBlack;
    Pen.Color := clBtnShadow;
    Rectangle(r.Left, r.Top, r.Right, r.Bottom);
    Font := BrushStyleCB.Font;
    Brush.Color := clWhite;
    Brush.Style := bsClear;
    TextOut(r.Right + 4, r.Top, BrushStyleCB.Items[Index]);
  end;
end;

procedure TfrxFillEditorForm.PageControlChange(Sender: TObject);
begin
  Change;
end;

procedure TfrxFillEditorForm.BrushStyleCBChange(Sender: TObject);
begin
  FBrushFill.Style := TBrushStyle(BrushStyleCB.ItemIndex);
  Change;
end;

procedure TfrxFillEditorForm.BrushBackColorChanged(Sender: TObject);
begin
  FBrushFill.BackColor := BrushBackColorCB.Color;
  Change;
end;

procedure TfrxFillEditorForm.BrushForeColorChanged(Sender: TObject);
begin
  FBrushFill.ForeColor := BrushForeColorCB.Color;
  Change;
end;

procedure TfrxFillEditorForm.GradientStyleCBChange(Sender: TObject);
begin
  FGradientFill.GradientStyle := TfrxGradientStyle(GradientStyleCB.ItemIndex);
  Change;
end;

procedure TfrxFillEditorForm.GradientStartColorChanged(Sender: TObject);
begin
  FGradientFill.StartColor := GradientStartColorCB.Color;
  Change;
end;

procedure TfrxFillEditorForm.GradientEndColorChanged(Sender: TObject);
begin
  FGradientFill.EndColor := GradientEndColorCB.Color;
  Change;
end;

procedure TfrxFillEditorForm.GlassOrientationCBChange(Sender: TObject);
begin
  FGlassFill.Orientation := TfrxGlassFillOrientation(GlassOrientationCB.ItemIndex);
  Change;
end;

procedure TfrxFillEditorForm.GlassColorChanged(Sender: TObject);
begin
  FGlassFill.Color := GlassColorCB.Color;
  Change;
end;

procedure TfrxFillEditorForm.GlassBlendEExit(Sender: TObject);
begin
  FGlassFill.Blend := frxStrToFloat(GlassBlendE.Text);
  Change;
end;

procedure TfrxFillEditorForm.GlassHatchCBClick(Sender: TObject);
begin
  FGlassFill.Hatch := GlassHatchCb.Checked;
  Change;
end;

end.
