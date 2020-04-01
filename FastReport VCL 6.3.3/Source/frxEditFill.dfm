object frxFillEditorForm: TfrxFillEditorForm
  Left = 191
  Top = 116
  BorderStyle = bsDialog
  Caption = 'frxFillEditorForm'
  ClientHeight = 312
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 305
    Height = 257
    ActivePage = BrushTS
    TabOrder = 0
    OnChange = PageControlChange
    object BrushTS: TTabSheet
      Caption = 'Brush'
      object BrushBackColorL: TLabel
        Left = 8
        Top = 44
        Width = 86
        Height = 13
        Caption = 'Background color:'
      end
      object BrushForeColorL: TLabel
        Left = 8
        Top = 72
        Width = 86
        Height = 13
        Caption = 'Foreground color:'
      end
      object BrushStyleL: TLabel
        Left = 8
        Top = 16
        Width = 57
        Height = 13
        Caption = 'Brush style:'
      end
      object BrushStyleCB: TComboBox
        Left = 136
        Top = 12
        Width = 153
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 0
        OnChange = BrushStyleCBChange
        OnDrawItem = BrushStyleCBDrawItem
      end
    end
    object GradientTS: TTabSheet
      Caption = 'Gradient'
      ImageIndex = 1
      object GradientStyleL: TLabel
        Left = 8
        Top = 16
        Width = 71
        Height = 13
        Caption = 'Gradient style:'
      end
      object GradientStartColorL: TLabel
        Left = 8
        Top = 44
        Width = 54
        Height = 13
        Caption = 'Start color:'
      end
      object GradientEndColorL: TLabel
        Left = 8
        Top = 72
        Width = 48
        Height = 13
        Caption = 'End color:'
      end
      object GradientStyleCB: TComboBox
        Left = 136
        Top = 12
        Width = 153
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnChange = GradientStyleCBChange
      end
    end
    object GlassTS: TTabSheet
      Caption = 'Glass'
      ImageIndex = 2
      object GlassOrientationL: TLabel
        Left = 8
        Top = 16
        Width = 58
        Height = 13
        Caption = 'Orientation:'
      end
      object GlassColorL: TLabel
        Left = 8
        Top = 44
        Width = 29
        Height = 13
        Caption = 'Color:'
      end
      object GlassBlendL: TLabel
        Left = 8
        Top = 72
        Width = 30
        Height = 13
        Caption = 'Blend:'
      end
      object GlassOrientationCB: TComboBox
        Left = 136
        Top = 12
        Width = 153
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnChange = GlassOrientationCBChange
      end
      object GlassHatchCB: TCheckBox
        Left = 8
        Top = 100
        Width = 181
        Height = 17
        Caption = 'Hatch'
        TabOrder = 1
        OnClick = GlassHatchCBClick
      end
      object GlassBlendE: TEdit
        Left = 136
        Top = 68
        Width = 153
        Height = 21
        TabOrder = 2
        OnExit = GlassBlendEExit
      end
    end
  end
  object OKB: TButton
    Left = 156
    Top = 276
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object CancelB: TButton
    Left = 236
    Top = 276
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object SampleP: TPanel
    Left = 20
    Top = 168
    Width = 281
    Height = 81
    BevelOuter = bvNone
    TabOrder = 3
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 281
      Height = 81
      Align = alClient
      OnPaint = PaintBox1Paint
    end
  end
end
