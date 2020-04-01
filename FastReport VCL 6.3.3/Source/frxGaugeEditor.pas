unit frxGaugeEditor;

interface

{$I frx.inc}

uses
  Forms, StdCtrls, ExtCtrls, Classes, Controls, Graphics, Buttons, ComCtrls,
  Dialogs,
{$IFDEF FPC}
  ColorBox,
{$ENDIF}
  frxClass, frxGaugeView;

type
  TfrxGaugeEditorForm = class(TForm)
    CancelButton: TButton;
    OkButton: TButton;
    SamplePaintBox: TPaintBox;
    FillButton: TButton;
    FrameButton: TButton;
    GaugeOptionsPageControl: TPageControl;
    GeneralTabSheet: TTabSheet;
    MajorScaleTabSheet: TTabSheet;
    MajorScaleVisibleCheckBox: TCheckBox;
    MinorScaleTabSheet: TTabSheet;
    MinorScaleVisibleCheckBox: TCheckBox;
    PointerTabSheet: TTabSheet;
    GaugeKindComboBox: TComboBox;
    GaugeKindLabel: TLabel;
    PointerKindComboBox: TComboBox;
    PointerKindLabel: TLabel;
    MinimumLabel: TLabel;
    MaximumLabel: TLabel;
    MinimumEdit: TEdit;
    MaximumEdit: TEdit;
    MajorStepLabel: TLabel;
    MajorStepEdit: TEdit;
    CurrentValueEdit: TEdit;
    CurrentValueLabel: TLabel;
    MinorStepEdit: TEdit;
    MinorStepLabel: TLabel;
    MarginsGroupBox: TGroupBox;
    TopLabel: TLabel;
    LeftLabel: TLabel;
    BottomLabel: TLabel;
    RightLabel: TLabel;
    BorderWidthLabel: TLabel;
    BorderColorColorBox: TColorBox;
    BorderColorLabel: TLabel;
    ColorLabel: TLabel;
    ColorColorBox: TColorBox;
    WidthLabel: TLabel;
    HeightLabel: TLabel;
    MajorScaleVisibleDigitsCheckBox: TCheckBox;
    MinorScaleVisibleDigitsCheckBox: TCheckBox;
    MajorScaleBilateralCheckBox: TCheckBox;
    MinorScaleBilateralCheckBox: TCheckBox;
    MinorScaleFormatEdit: TEdit;
    MinorScaleFormatLabel: TLabel;
    MajorScaleFormatLabel: TLabel;
    MajorScaleFormatEdit: TEdit;
    MajorScaleFontButton: TButton;
    MajorScaleFontLabel: TLabel;
    FontDialog: TFontDialog;
    MinorScaleFontButton: TButton;
    MinorScaleFontLabel: TLabel;
    MajorScaleTicksGroupBox: TGroupBox;
    MajorScaleTicksWidthLabel: TLabel;
    MajorScaleTicksLengthLabel: TLabel;
    MajorScaleTicksColorLabel: TLabel;
    MajorScaleTicksColorColorBox: TColorBox;
    MinorScaleTicksGroupBox: TGroupBox;
    MinorScaleTicksWidthLabel: TLabel;
    MinorScaleTicksLengthLabel: TLabel;
    MinorScaleTicksColorLabel: TLabel;
    MinorScaleTicksColorColorBox: TColorBox;
    LeftEdit: TEdit;
    LeftUpDown: TUpDown;
    TopEdit: TEdit;
    TopUpDown: TUpDown;
    RightEdit: TEdit;
    RightUpDown: TUpDown;
    BottomEdit: TEdit;
    BottomUpDown: TUpDown;
    MajorScaleTicksWidthEdit: TEdit;
    MajorScaleTicksWidthUpDown: TUpDown;
    MajorScaleTicksLengthUpDown: TUpDown;
    MajorScaleTicksLengthEdit: TEdit;
    MinorScaleTicksLengthEdit: TEdit;
    MinorScaleTicksLengthUpDown: TUpDown;
    MinorScaleTicksWidthUpDown: TUpDown;
    MinorScaleTicksWidthEdit: TEdit;
    WidthEdit: TEdit;
    WidthUpDown: TUpDown;
    HeightUpDown: TUpDown;
    HeightEdit: TEdit;
    BorderWidthEdit: TEdit;
    BorderWidthUpDown: TUpDown;
    StartValueLabel: TLabel;
    StartValueEdit: TEdit;
    EndValueLabel: TLabel;
    EndValueEdit: TEdit;
    AngleLabel: TLabel;
    AngleUpDown: TUpDown;
    AngleEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SamplePaintBoxPaint(Sender: TObject);
    procedure EditFloatKeyPress(Sender: TObject; var Key: Char);
    procedure EditIntKeyPress(Sender: TObject; var Key: Char);
    procedure FillButtonClick(Sender: TObject);
    procedure FrameButtonClick(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);

    procedure ComboBoxChange(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure SpinEditChange(Sender: TObject);
    procedure ColorBoxChange(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
  private
    FBaseGaugeView: TfrxBaseGaugeView;
    FGaugeView, FOriginalGaugeView: TfrxGaugeView;
    FIntervalGaugeView, FOriginalIntervalGaugeView: TfrxIntervalGaugeView;
    FReportDesigner: TfrxCustomDesigner;

    procedure Change;
    procedure SetBaseGaugeView(const Value: TfrxBaseGaugeView);
    procedure FontToLabel(Font: TFont; Lbl: TLabel);
    procedure FontDialogToLabel(Font: TFont; Lbl: TLabel);
  public
    property BaseGaugeView: TfrxBaseGaugeView read FBaseGaugeView write SetBaseGaugeView;
    property ReportDesigner: TfrxCustomDesigner read FReportDesigner write FReportDesigner;
  end;

var
  frxGaugeEditorForm: TfrxGaugeEditorForm;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  SysUtils,
{$IFNDEF FPC}
  Windows, frxMapHelpers,
{$ELSE}
  LCLType, LCLIntf, LCLProc, LazHelper,
{$ENDIF}
  frxCustomEditors, frxDsgnIntf, frxEditFill, frxRes, frxUtils,
  frxGauge, frxEditFrame;

type
  TfrxGaugeEditor = class(TfrxViewEditor)
  public
    function Edit: Boolean; override;
    function HasEditor: Boolean; override;
  end;

{ TfrxGaugeEditor }

function TfrxGaugeEditor.Edit: Boolean;
begin
  with TfrxGaugeEditorForm.Create(Designer) do
  begin
    BaseGaugeView := TfrxBaseGaugeView(Component);
    ReportDesigner := Self.Designer;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

function TfrxGaugeEditor.HasEditor: Boolean;
begin
  Result := True;
end;

{ TfrxGaugeEditorForm }

procedure TfrxGaugeEditorForm.Change;
begin
  if BaseGaugeView = nil then
    Exit;

  SamplePaintBox.Refresh;

  WidthLabel.Visible := BaseGaugeView.BaseGauge.Pointer.IsPublishedWidth;
  WidthUpDown.Visible := WidthLabel.Visible;
  WidthEdit.Visible := WidthLabel.Visible;

  HeightLabel.Visible := BaseGaugeView.BaseGauge.Pointer.IsPublishedHeight;
  HeightUpDown.Visible := HeightLabel.Visible;
  HeightEdit.Visible := HeightLabel.Visible;

  ColorLabel.Visible := BaseGaugeView.BaseGauge.Pointer.IsPublishedColor;
  ColorColorBox.Visible := ColorLabel.Visible;
end;

procedure TfrxGaugeEditorForm.CheckBoxClick(Sender: TObject);
begin
  with Sender as TCheckBox do
    if      Sender = MajorScaleVisibleCheckBox then
      BaseGaugeView.BaseGauge.MajorScale.Visible := Checked
    else if Sender = MinorScaleVisibleCheckBox then
      BaseGaugeView.BaseGauge.MinorScale.Visible := Checked
    else if Sender = MajorScaleVisibleDigitsCheckBox then
      BaseGaugeView.BaseGauge.MajorScale.VisibleDigits := Checked
    else if Sender = MinorScaleVisibleDigitsCheckBox then
      BaseGaugeView.BaseGauge.MinorScale.VisibleDigits := Checked
    else if Sender = MajorScaleBilateralCheckBox then
      BaseGaugeView.BaseGauge.MajorScale.Bilateral := Checked
    else if Sender = MinorScaleBilateralCheckBox then
      BaseGaugeView.BaseGauge.MinorScale.Bilateral := Checked
    ;
  Change;
end;

procedure TfrxGaugeEditorForm.ColorBoxChange(Sender: TObject);
begin
  with Sender as TColorBox do
    if      Sender = BorderColorColorBox then
      BaseGaugeView.BaseGauge.Pointer.BorderColor := Selected
    else if Sender = ColorColorBox then
      BaseGaugeView.BaseGauge.Pointer.Color := Selected
    else if Sender = MajorScaleTicksColorColorBox then
      BaseGaugeView.BaseGauge.MajorScale.Ticks.Color := Selected
    else if Sender = MinorScaleTicksColorColorBox then
      BaseGaugeView.BaseGauge.MinorScale.Ticks.Color := Selected
    ;
  Change;
end;

procedure TfrxGaugeEditorForm.ComboBoxChange(Sender: TObject);
begin
  with Sender as TComboBox do
    if      Sender = GaugeKindComboBox then
      BaseGaugeView.BaseGauge.Kind := TGaugeKind(ItemIndex)
    else if Sender = PointerKindComboBox then
      BaseGaugeView.BaseGauge.PointerKind := TGaugePointerKind(ItemIndex)
    ;
  Change;
end;

procedure TfrxGaugeEditorForm.EditChange(Sender: TObject);

  function StringToFloat(s: String): Extended;
  begin
    if s = '' then Result := 0.0
    else           Result := frxStrToFloat(s);
  end;
begin
  with Sender as TEdit do
    if      Sender = MinimumEdit then
    begin
      BaseGaugeView.BaseGauge.Minimum := StringToFloat(MinimumEdit.Text);
      MinimumEdit.Text := FloatToStr(BaseGaugeView.BaseGauge.Minimum);
    end
    else if Sender = MaximumEdit then
    begin
      BaseGaugeView.BaseGauge.Maximum := StringToFloat(MaximumEdit.Text);
      MaximumEdit.Text := FloatToStr(BaseGaugeView.BaseGauge.Maximum);
    end
    else if (Sender = CurrentValueEdit) and (BaseGaugeView is TfrxGaugeView) then
    begin
      FGaugeView.Gauge.CurrentValue := StringToFloat(CurrentValueEdit.Text);
      CurrentValueEdit.Text := FloatToStr(FGaugeView.Gauge.CurrentValue);
    end
    else if (Sender = StartValueEdit) and (BaseGaugeView is TfrxIntervalGaugeView) then
    begin
      FIntervalGaugeView.IntervalGauge.StartValue := StringToFloat(StartValueEdit.Text);
      StartValueEdit.Text := FloatToStr(FIntervalGaugeView.IntervalGauge.StartValue);
    end
    else if (Sender = EndValueEdit) and (BaseGaugeView is TfrxIntervalGaugeView) then
    begin
      FIntervalGaugeView.IntervalGauge.EndValue := StringToFloat(EndValueEdit.Text);
      EndValueEdit.Text := FloatToStr(FIntervalGaugeView.IntervalGauge.EndValue);
    end
    else if Sender = MajorStepEdit then
      BaseGaugeView.BaseGauge.MajorStep := StringToFloat(MajorStepEdit.Text)
    else if Sender = MinorStepEdit then
      BaseGaugeView.BaseGauge.MinorStep := StringToFloat(MinorStepEdit.Text)
    else if Sender = MajorScaleFormatEdit then
      BaseGaugeView.BaseGauge.MajorScale.ValueFormat := MajorScaleFormatEdit.Text
    else if Sender = MinorScaleFormatEdit then
      BaseGaugeView.BaseGauge.MinorScale.ValueFormat := MinorScaleFormatEdit.Text
    ;
  Change;
end;

procedure TfrxGaugeEditorForm.EditFloatKeyPress(Sender: TObject; var Key: Char);
var
  Edit: TEdit;

  function IsHave(C: Char): boolean;
  begin
    Result := Pos(C, Edit.Text) > 0;
  end;

  function IsCursorBeforeSign: boolean;
  begin
    Result := Edit.SelStart < Pos('-', Edit.Text);
  end;

begin
  Edit := Sender as TEdit;
  case Key of
    Chr(VK_BACK):
      ;
    '0'..'9':
      if IsCursorBeforeSign then
        Key := Chr(0);
    '.', ',':
      if IsCursorBeforeSign or IsHave('.') or IsHave(',') then
        Key := Chr(0);
    '-':
      if IsHave('-') or (Edit.SelStart > 0) then
        Key := Chr(0);
  else
    key := Chr(0);
  end;
end;

procedure TfrxGaugeEditorForm.EditIntKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    Chr(VK_BACK), '0'..'9':
      ;
  else
    key := Chr(0);
  end;
end;

procedure TfrxGaugeEditorForm.FillButtonClick(Sender: TObject);
begin
  with TfrxFillEditorForm.Create(nil) do
  begin
    IsSimpleFill := False;
    Fill := BaseGaugeView.Fill;
    if ShowModal = mrOK  then
    begin
      if Fill is TfrxBrushFill then         BaseGaugeView.FillType := ftBrush
      else if Fill is TfrxGradientFill then BaseGaugeView.FillType := ftGradient
      else if Fill is TfrxGlassFill then    BaseGaugeView.FillType := ftGlass;
      BaseGaugeView.Fill.Assign(Fill);
    end;
    Free;
    Change;
  end;
end;

procedure TfrxGaugeEditorForm.FontButtonClick(Sender: TObject);
begin
  if      Sender = MajorScaleFontButton then
    FontDialogToLabel(BaseGaugeView.BaseGauge.MajorScale.Font, MajorScaleFontLabel)
  else if Sender = MinorScaleFontButton then
    FontDialogToLabel(BaseGaugeView.BaseGauge.MinorScale.Font, MinorScaleFontLabel)
  ;
  Change
end;

procedure TfrxGaugeEditorForm.FontDialogToLabel(Font: TFont; Lbl: TLabel);
begin
  FontDialog.Font.Assign(Font);
  if FontDialog.Execute then
  begin
    Font.Assign(FontDialog.Font);
    FontToLabel(Font, Lbl);
    Change;
  end;
end;

procedure TfrxGaugeEditorForm.FontToLabel(Font: TFont; Lbl: TLabel);
begin
  Lbl.Caption := Font.Name + ', ' + IntToStr(Font.Size);
  Lbl.Font.Assign(Font);
end;

procedure TfrxGaugeEditorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    if      FGaugeView <> nil then
      FOriginalGaugeView.AssignAll(FGaugeView)
    else if FIntervalGaugeView <> nil then
      FOriginalIntervalGaugeView.AssignAll(FIntervalGaugeView);
    if Assigned(FReportDesigner) then
      FReportDesigner.ReloadObjects(False);
  end;
  BaseGaugeView.Free;
end;

procedure TfrxGaugeEditorForm.FormCreate(Sender: TObject);
var
  gk: TGaugeKind;
  pk: TGaugePointerKind;
begin
  Translate(Self);

  for gk := Low(TGaugeKind) to High(TGaugeKind) do
    GaugeKindComboBox.Items.Add(frxResources.Get('GaugeKind' + IntToStr(Ord(gk))));
  for pk := Low(TGaugePointerKind) to High(TGaugePointerKind) do
    PointerKindComboBox.Items.Add(frxResources.Get('PointerKind' + IntToStr(Ord(pk))));
end;

procedure TfrxGaugeEditorForm.FrameButtonClick(Sender: TObject);
begin
  with TfrxFrameEditorForm.Create(nil) do
  begin
    Frame := BaseGaugeView.Frame;
    if ShowModal = mrOK  then
      BaseGaugeView.Frame.Assign(Frame);
    Free;
    Change;
  end;
end;

procedure TfrxGaugeEditorForm.SamplePaintBoxPaint(Sender: TObject);
var
  saveLeft, saveTop, saveWidth, saveHeight: Extended;
begin
  saveLeft :=   BaseGaugeView.Left;
  saveTop :=    BaseGaugeView.Top;
  saveWidth :=  BaseGaugeView.Width;
  saveHeight := BaseGaugeView.Height;

  try
    SamplePaintBox.Canvas.Lock;
    try
      SamplePaintBox.Canvas.Brush.Color := clWindow;
      SamplePaintBox.Canvas.FillRect(Rect(0, 0, SamplePaintBox.Width, SamplePaintBox.Height));
    finally
      SamplePaintBox.Canvas.Unlock;
    end;
    BaseGaugeView.Left := 0;
    BaseGaugeView.Top := 0;
    BaseGaugeView.Width := SamplePaintBox.Width;
    BaseGaugeView.Height := SamplePaintBox.Height;
    BaseGaugeView.Draw(SamplePaintBox.Canvas, 1, 1, 0, 0);
  finally
    BaseGaugeView.Left :=   saveLeft;
    BaseGaugeView.Top :=    saveTop;
    BaseGaugeView.Width :=  saveWidth;
    BaseGaugeView.Height := saveHeight;
  end;
end;

procedure TfrxGaugeEditorForm.SetBaseGaugeView(const Value: TfrxBaseGaugeView);
begin
  if      Value is TfrxGaugeView then
  begin
    FOriginalGaugeView := TfrxGaugeView(Value);
    FGaugeView := TfrxGaugeView.Create(nil);
    FGaugeView.AssignAll(FOriginalGaugeView);
    FBaseGaugeView := FGaugeView;

    CurrentValueEdit.Text := FloatToStr(FGaugeView.Gauge.CurrentValue);

    StartValueEdit.Visible := False;
    StartValueLabel.Visible := False;
    EndValueEdit.Visible := False;
    EndValueLabel.Visible := False;
  end
  else if Value is TfrxIntervalGaugeView then
  begin
    FOriginalIntervalGaugeView := TfrxIntervalGaugeView(Value);
    FIntervalGaugeView := TfrxIntervalGaugeView.Create(nil);
    FIntervalGaugeView.AssignAll(FOriginalIntervalGaugeView);
    FBaseGaugeView := FIntervalGaugeView;

    StartValueEdit.Text := FloatToStr(FIntervalGaugeView.IntervalGauge.StartValue);
    EndValueEdit.Text := FloatToStr(FIntervalGaugeView.IntervalGauge.EndValue);

    StartValueEdit.Left := CurrentValueEdit.Left;
    StartValueLabel.Left := CurrentValueLabel.Left;
    CurrentValueEdit.Visible := False;
    CurrentValueLabel.Visible := False;
  end;

  GaugeKindComboBox.ItemIndex := Ord(BaseGaugeView.BaseGauge.Kind);
  PointerKindComboBox.ItemIndex := Ord(BaseGaugeView.BaseGauge.PointerKind);
  MinimumEdit.Text := FloatToStr(BaseGaugeView.BaseGauge.Minimum);
  MaximumEdit.Text := FloatToStr(BaseGaugeView.BaseGauge.Maximum);
  AngleUpDown.Position := BaseGaugeView.BaseGauge.Angle;
  MajorStepEdit.Text := FloatToStr(BaseGaugeView.BaseGauge.MajorStep);
  MinorStepEdit.Text := FloatToStr(BaseGaugeView.BaseGauge.MinorStep);

  LeftUpDown.Position := BaseGaugeView.BaseGauge.Margin.Left;
  TopUpDown.Position := BaseGaugeView.BaseGauge.Margin.Top;
  RightUpDown.Position := BaseGaugeView.BaseGauge.Margin.Right;
  BottomUpDown.Position := BaseGaugeView.BaseGauge.Margin.Bottom;

  BorderWidthUpDown.Position := BaseGaugeView.BaseGauge.Pointer.BorderWidth;
  BorderColorColorBox.Selected := BaseGaugeView.BaseGauge.Pointer.BorderColor;
  WidthUpDown.Position := BaseGaugeView.BaseGauge.Pointer.Width;
  HeightUpDown.Position := BaseGaugeView.BaseGauge.Pointer.Height;
  ColorColorBox.Selected := BaseGaugeView.BaseGauge.Pointer.Color;

  MajorScaleVisibleCheckBox.Checked := BaseGaugeView.BaseGauge.MajorScale.Visible;
  MinorScaleVisibleCheckBox.Checked := BaseGaugeView.BaseGauge.MinorScale.Visible;
  MajorScaleVisibleDigitsCheckBox.Checked := BaseGaugeView.BaseGauge.MajorScale.VisibleDigits;
  MinorScaleVisibleDigitsCheckBox.Checked := BaseGaugeView.BaseGauge.MinorScale.VisibleDigits;
  MajorScaleBilateralCheckBox.Checked := BaseGaugeView.BaseGauge.MajorScale.Bilateral;
  MinorScaleBilateralCheckBox.Checked := BaseGaugeView.BaseGauge.MinorScale.Bilateral;
  MajorScaleFormatEdit.Text := BaseGaugeView.BaseGauge.MajorScale.ValueFormat;
  MinorScaleFormatEdit.Text := BaseGaugeView.BaseGauge.MinorScale.ValueFormat;
  FontToLabel(BaseGaugeView.BaseGauge.MajorScale.Font, MajorScaleFontLabel);
  FontToLabel(BaseGaugeView.BaseGauge.MinorScale.Font, MinorScaleFontLabel);
  MajorScaleTicksColorColorBox.Selected := BaseGaugeView.BaseGauge.MajorScale.Ticks.Color;
  MinorScaleTicksColorColorBox.Selected := BaseGaugeView.BaseGauge.MinorScale.Ticks.Color;
  MajorScaleTicksLengthUpDown.Position := BaseGaugeView.BaseGauge.MajorScale.Ticks.Length;
  MinorScaleTicksLengthUpDown.Position := BaseGaugeView.BaseGauge.MinorScale.Ticks.Length;
  MajorScaleTicksWidthUpDown.Position := BaseGaugeView.BaseGauge.MajorScale.Ticks.Width;
  MinorScaleTicksWidthUpDown.Position := BaseGaugeView.BaseGauge.MinorScale.Ticks.Width;
end;

procedure TfrxGaugeEditorForm.SpinEditChange(Sender: TObject);
var
  EditValue: Integer;
begin
  if BaseGaugeView = nil then
    Exit;

  with Sender as TEdit do
    if Text = '' then
      EditValue := 0
    else
      EditValue := StrToInt(Text);

  with Sender as TEdit do
    if      Sender = LeftEdit then
    begin
      LeftUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.Margin.Left := EditValue;
    end
    else if Sender = TopEdit then
    begin
      TopUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.Margin.Top := EditValue;
    end
    else if Sender = RightEdit then
    begin
      RightUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.Margin.Right := EditValue;
    end
    else if Sender = BottomEdit then
    begin
      BottomUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.Margin.Bottom := EditValue;
    end
    else if Sender = AngleEdit then
    begin
      AngleUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.Angle := EditValue;
    end
    else if Sender = MajorScaleTicksLengthEdit then
    begin
      MajorScaleTicksLengthUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.MajorScale.Ticks.Length := EditValue;
    end
    else if Sender = MajorScaleTicksWidthEdit then
    begin
      MajorScaleTicksWidthUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.MajorScale.Ticks.Width := EditValue;
    end
    else if Sender = MinorScaleTicksLengthEdit then
    begin
      MinorScaleTicksLengthUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.MinorScale.Ticks.Length := EditValue;
    end
    else if Sender = MinorScaleTicksWidthEdit then
    begin
      MinorScaleTicksWidthUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.MinorScale.Ticks.Width := EditValue;
    end
    else if Sender = BorderWidthEdit then
    begin
      BorderWidthUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.Pointer.BorderWidth := EditValue;
    end
    else if Sender = WidthEdit then
    begin
      WidthUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.Pointer.Width := EditValue;
    end
    else if Sender = HeightEdit then
    begin
      HeightUpDown.Position := EditValue;
      BaseGaugeView.BaseGauge.Pointer.Height := EditValue;
    end
    ;
  Change;
end;

initialization

frxComponentEditors.Register(TfrxGaugeView, TfrxGaugeEditor);
frxComponentEditors.Register(TfrxIntervalGaugeView, TfrxGaugeEditor);

end.
